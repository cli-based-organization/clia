#!/usr/bin/env bash
# Description: Vérifie la conformité d'un dépôt clia.
# Périmètre: aucun
#
# Implémente .dev/usages/USE-008-verifier-la-conformite-d-un-repo.md.
#
# Le périmètre est déclaré « aucun » parce que la commande accepte le chemin
# d'un autre dépôt : le dispatcher ne peut pas résoudre celui-là comme dépôt
# courant. La garde du mode --activate est donc appliquée ici.
#
# La commande ne répare rien. Un contrôle qui corrige ce qu'il trouve ne peut
# plus être lancé pour savoir où l'on en est.

set -euo pipefail

_CLIA_NOM='clia'
# shellcheck source=../commun.sh
. "$CLIA_SOURCE_DIR/_scripts/lib/commun.sh"

# --------------------------------------------------------------------------

aide() {
  cat <<'EOF'
Usage : clia check [PATH]

Vérifie la conformité d'un dépôt clia. PATH vaut le répertoire courant par
défaut. Rien n'est modifié : la commande constate, elle ne répare pas.

Six contrôles :
  C1  le dépôt porte .dev/clia.yaml, avec ses quatre champs
  C2  le harnais installé est de la version qu'offre clia
  C3  chaque extension déclarée est clonée sur cette machine
  C4  chaque chose inventoriée existe encore sur le disque
  C5  chaque ressource du disque est inventoriée
  C6  aucune déclaration ne subsiste dans un emplacement abandonné

Codes de retour :
  0  conforme, ou seulement des avertissements
  1  au moins un écart bloquant
  2  demande mal formée
EOF
}

case "${1:-}" in
  -h|--help|help) aide; exit 0 ;;
esac

if (( $# > 1 )); then
  _clia_msg "check prend au plus un chemin : $*"
  exit 2
fi

DEMANDE="${1:-$PWD}"
case "$DEMANDE" in
  /*) CIBLE="$DEMANDE" ;;
  *)  CIBLE="$PWD/${DEMANDE#./}" ;;
esac
CIBLE=$(realpath -m "$CIBLE" 2>/dev/null || printf '%s\n' "${CIBLE%/}")

if [[ ! -d "$CIBLE" ]]; then
  _clia_msg "ce chemin n'existe pas : $CIBLE"
  exit 2
fi
if ! git -C "$CIBLE" rev-parse --git-dir >/dev/null 2>&1; then
  _clia_msg "ce n'est pas un dépôt git : $CIBLE"
  _clia_detail "clia ne travaille que sur des dépôts git"
  exit 2
fi
CIBLE=$(git -C "$CIBLE" rev-parse --show-toplevel)
_clia_perimetre_permet "$CIBLE" || exit 1

# Les fonctions de lecture qui suivent regardent le dépôt vérifié, non celui
# où la commande a été lancée.
export CLIA_WORK_DIR="$CIBLE"

# --------------------------------------------------------------------------
# Le rapport
# --------------------------------------------------------------------------
#
# Accumulé puis rendu d'un bloc : le verdict se lit avant le détail, et les
# colonnes s'alignent. Un écart bloquant empêche clia de travailler ; un
# avertissement signale une dérive qui n'empêche rien aujourd'hui.

RAPPORT=''
BLOQUANTS=0
AVERTISSEMENTS=0
CONSEILS=''

verdict() {
  local ref="$1" gravite="$2" enonce="$3"
  local marque
  case "$gravite" in
    ok)    marque='ok' ;;
    avert) marque='avert'; AVERTISSEMENTS=$((AVERTISSEMENTS + 1)) ;;
    *)     marque='ÉCHEC'; BLOQUANTS=$((BLOQUANTS + 1)) ;;
  esac
  RAPPORT+="${ref}	${marque}	${enonce}
"
}

conseil() { CONSEILS+="$1
"; }

# --------------------------------------------------------------------------

CARTE=$(_clia_carte "$CIBLE")

if [[ ! -f "$CARTE" ]]; then
  verdict C1 bloquant "le dépôt ne porte pas .dev/clia.yaml"
  conseil "ce dépôt a été instrumenté avant que la configuration n'existe."
  conseil "posez .dev/clia.yaml avec ses quatre champs :"
  conseil "  namespace: <publisher>/$(basename "$CIBLE")"
  conseil "  version: 0.1.0"
  conseil "  maturity: unstable"
  conseil "  generation: 1"
else
  manquants=''
  for champ in namespace version maturity generation; do
    [[ -n "$(_clia_carte_champ "$CIBLE" "$champ" 2>/dev/null || printf '')" ]] || manquants+="$champ "
  done
  if [[ -z "$manquants" ]]; then
    verdict C1 ok ".dev/clia.yaml porte ses quatre champs"
  else
    verdict C1 bloquant ".dev/clia.yaml est incomplet : $manquants"
    conseil "ajoutez les champs manquants à .dev/clia.yaml : $manquants"
  fi
fi

# C2 — le harnais installé, comparé à celui qu'offre clia.
attendue=$(_clia_def_champ harness-ia version 2>/dev/null || printf '')
entree=$(_clia_installe_entree "$CIBLE" harness harness-ia)
posee=$(printf '%s' "$entree" | awk -F'\t' '{print $4}')

if [[ ! -f "$CIBLE/CLAUDE.md" ]]; then
  verdict C2 avert "aucun harnais IA n'est posé"
  conseil "pour en poser un : clia harness-ia init"
elif [[ -z "$posee" ]]; then
  verdict C2 avert "un harnais est posé mais n'est pas inventorié"
  conseil "il a été posé avant l'inventaire. Pour l'y inscrire :"
  conseil "  clia harness-ia init --force"
elif [[ "$posee" == "$attendue" ]]; then
  verdict C2 ok "harnais en version $posee, celle qu'offre clia"
else
  verdict C2 avert "harnais en version $posee, clia en offre $attendue"
  conseil "pour le régénérer sans perdre skills ni fonctionnalités :"
  conseil "  clia harness-ia init --force"
fi

# C3 — les extensions déclarées, et leur clone.
n_ext=0
while IFS=$'\t' read -r ns uri; do
  [[ -n "$ns" ]] || continue
  n_ext=$((n_ext + 1))
  if [[ -d "$(_clia_extension_cache "$ns")" ]]; then
    verdict C3 ok "extension $ns : clonée"
  else
    verdict C3 bloquant "extension $ns : déclarée, non clonée"
    conseil "pour rétablir le clone de $ns :"
    conseil "  clia extension add ${uri:-<uri>}"
  fi
done < <(_clia_extensions_declarees "$CIBLE")
(( n_ext == 0 )) && verdict C3 ok "aucune extension déclarée"

# C4 — ce qui est inventorié existe-t-il encore ?
n_perdus=0
while IFS=$'\t' read -r type ns nom version uri; do
  [[ -n "$type" ]] || continue
  case "$type" in
    ressource)
      [[ -d "$CIBLE/_ressources/$nom" ]] || {
        verdict C4 avert "ressource $nom : inventoriée, absente du disque"
        conseil "la ressource $nom a été retirée sans l'être de l'inventaire"
        n_perdus=$((n_perdus + 1))
      } ;;
    skill)
      [[ -f "$CIBLE/.claude/skills/$nom/SKILL.md" ]] || {
        verdict C4 avert "skill $nom : inventorié, absent du disque"
        n_perdus=$((n_perdus + 1))
      } ;;
    feature)
      grep -qF "<!-- BEGIN ${nom} feature -->" "$CIBLE/CLAUDE.md" 2>/dev/null || {
        verdict C4 avert "fonctionnalité $nom : inventoriée, absente du harnais"
        n_perdus=$((n_perdus + 1))
      } ;;
  esac
done < <(_clia_installe "$CIBLE")
(( n_perdus == 0 )) && verdict C4 ok "tout ce qui est inventorié est sur le disque"

# C5 — ce qui est sur le disque est-il inventorié ?
n_muets=0
while IFS=$'\t' read -r nom dir; do
  [[ -n "$nom" ]] || continue
  if [[ -z "$(_clia_installe_entree "$CIBLE" ressource "$nom")" ]]; then
    verdict C5 avert "ressource $nom : sur le disque, non inventoriée"
    n_muets=$((n_muets + 1))
  fi
done < <(_clia_ressources_de "$CIBLE")
if (( n_muets == 0 )); then
  verdict C5 ok "toute ressource du disque est inventoriée"
else
  conseil "$n_muets ressource(s) sont antérieures à l'inventaire."
  conseil "leur provenance est perdue ; elle se réinscrit à la main dans"
  conseil ".dev/clia.yaml, sous installe:"
fi

# C6 — les emplacements abandonnés.
if [[ -f "$CIBLE/.dev/extensions.yaml" ]]; then
  verdict C6 avert ".dev/extensions.yaml subsiste, emplacement abandonné"
  conseil "les extensions se déclarent désormais dans .dev/clia.yaml."
  conseil "celles de .dev/extensions.yaml sont encore lues, mais le fichier"
  conseil "devrait être fondu dans l'inventaire puis retiré."
else
  verdict C6 ok "aucun emplacement abandonné"
fi

# --------------------------------------------------------------------------

printf 'dépôt      %s\n' "$CIBLE"
printf 'namespace  %s\n' "$(_clia_carte_champ "$CIBLE" namespace 2>/dev/null || printf '—')"
printf 'version    %s\n' "$(_clia_carte_champ "$CIBLE" version 2>/dev/null || printf '—')"
printf '\n'
printf '%s' "$RAPPORT" | column -t -s"$(printf '\t')"
printf '\n'

if (( BLOQUANTS > 0 )); then
  _clia_msg "$BLOQUANTS écart(s) bloquant(s), $AVERTISSEMENTS avertissement(s)"
elif (( AVERTISSEMENTS > 0 )); then
  _clia_msg "conforme, avec $AVERTISSEMENTS avertissement(s)"
else
  _clia_msg "conforme"
fi

if [[ -n "$CONSEILS" ]]; then
  printf '\n' >&2
  while IFS= read -r ligne; do
    [[ -n "$ligne" ]] && _clia_detail "$ligne"
  done <<<"$CONSEILS"
fi

(( BLOQUANTS > 0 )) && exit 1
exit 0
