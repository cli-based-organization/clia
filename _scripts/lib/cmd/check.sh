#!/usr/bin/env bash
# Description: Vérifie la conformité d'un dépôt clia, et la répare sur demande.
# Périmètre: aucun
#
# Implémente .dev/usages/USE-008-verifier-la-conformite-d-un-repo.md.
#
# Le périmètre est déclaré « aucun » parce que la commande accepte le chemin
# d'un autre dépôt : le dispatcher ne peut pas résoudre celui-là comme dépôt
# courant. La garde du mode --activate est donc appliquée ici.
#
# Par défaut, la commande ne répare rien : un contrôle qui corrige ce qu'il
# trouve ne peut plus être lancé pour savoir où l'on en est. La réparation est
# donc un mode demandé, --fix, et jamais un effet de bord du constat.
#
# Ce que --fix répare, et ce qu'il ne répare pas : un écart se répare
# automatiquement quand la réparation ne décide rien à la place de l'humain.
# Poser un fichier de configuration absent ne décide rien — son contenu est
# posé à compléter, comme clia init le fait. Réécrire le corps du harnais, en
# revanche, touche à du texte qui appartient au dépôt : c'est une décision, et
# --fix la laisse à l'humain en disant quelle commande la prend. PDC-002.

set -euo pipefail

_CLIA_NOM='clia'
# shellcheck source=../commun.sh
. "$CLIA_SOURCE_DIR/_scripts/lib/commun.sh"

# --------------------------------------------------------------------------

aide() {
  cat <<'EOF'
Usage : clia check [PATH] [--fix]

Vérifie la conformité d'un dépôt clia. PATH vaut le répertoire courant par
défaut. Sans --fix, rien n'est modifié : la commande constate.

Six contrôles :
  C1  le dépôt porte .dev/clia.yaml, avec ses quatre champs
  C2  le harnais installé est de la version qu'offre clia
  C3  chaque extension déclarée est clonée sur cette machine
  C4  chaque chose inventoriée existe encore sur le disque
  C5  chaque ressource du disque est inventoriée
  C6  aucune déclaration ne subsiste dans un emplacement abandonné

Avec --fix, les écarts réparables le sont, puis le dépôt est vérifié de
nouveau : le rapport rendu est celui d'après réparation.

  C1  .dev/clia.yaml est posé, ou complété, avec des valeurs à compléter
  C2  un harnais absent est posé
  C3  le clone manquant d'une extension déclarée est rétabli
  C4  une entrée inventoriée sans objet sur le disque est retirée
  C5  une ressource du disque est inscrite à l'inventaire
  C6  .dev/extensions.yaml est fondu dans l'inventaire, puis retiré

Ce que --fix ne répare pas, parce que ce sont des décisions :
  le namespace du dépôt, posé à compléter et jamais deviné
  un harnais en retard d'une version, dont le corps appartient au dépôt
    — clia harness-ia init --force le régénère

Les gestes de --fix modifient des fichiers versionnés : git diff les montre,
git checkout les défait.

Codes de retour :
  0  conforme, ou seulement des avertissements
  1  au moins un écart bloquant
  2  demande mal formée
EOF
}

case "${1:-}" in
  -h|--help|help) aide; exit 0 ;;
esac

# --------------------------------------------------------------------------
# La demande
# --------------------------------------------------------------------------

MODE='constat'
DEMANDE=''
for arg in "$@"; do
  case "$arg" in
    --fix) MODE='fix' ;;
    -*)
      _clia_msg "option inconnue pour check : $arg"
      _clia_detail "usage : clia check [PATH] [--fix]"
      exit 2 ;;
    *)
      if [[ -n "$DEMANDE" ]]; then
        _clia_msg "check prend au plus un chemin : $*"
        exit 2
      fi
      DEMANDE="$arg" ;;
  esac
done

case "${DEMANDE:=$PWD}" in
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
#
# Un écart réparable inscrit en plus le geste qui le solderait. Le constat le
# compte sans l'exécuter ; --fix l'exécute. Un seul endroit décide donc de ce
# qui est réparable, et c'est le contrôle lui-même.

RAPPORT=''
BLOQUANTS=0
AVERTISSEMENTS=0
CONSEILS=''
REPARATIONS=''
REPARABLES=0

verdict() {
  local ref="$1" gravite="$2" enonce="$3"
  local marque
  case "$gravite" in
    ok)    marque='ok' ;;
    avert) marque='avert'; AVERTISSEMENTS=$((AVERTISSEMENTS + 1)) ;;
    *)     marque='ÉCHEC'; BLOQUANTS=$((BLOQUANTS + 1)) ;;
  esac
  RAPPORT+="${ref}"$'\t'"${marque}"$'\t'"${enonce}"$'\n'
}

conseil() { CONSEILS+="$1"$'\n'; }

# reparable CODE ACTION [ARGUMENT…] — le geste qui solderait l'écart.
reparable() {
  local ligne="$1"$'\t'"$2" a
  shift 2
  for a in "$@"; do ligne+=$'\t'"$a"; done
  REPARATIONS+="$ligne"$'\n'
  REPARABLES=$((REPARABLES + 1))
}

# --------------------------------------------------------------------------
# Les six contrôles
# --------------------------------------------------------------------------
#
# Rassemblés dans une fonction parce que --fix les joue deux fois : une fois
# pour savoir quoi réparer, une fois pour dire où l'on en est après.

verifier() {
  RAPPORT=''
  BLOQUANTS=0
  AVERTISSEMENTS=0
  CONSEILS=''
  REPARATIONS=''
  REPARABLES=0

  local carte
  carte=$(_clia_carte "$CIBLE")

  # C1 — la carte d'identité du dépôt.
  if [[ ! -f "$carte" ]]; then
    verdict C1 bloquant "le dépôt ne porte pas .dev/clia.yaml"
    conseil "ce dépôt a été instrumenté avant que la configuration n'existe."
    conseil "posez .dev/clia.yaml avec ses quatre champs :"
    conseil "  namespace: <publisher>/$(basename "$CIBLE")"
    conseil "  version: 0.1.0"
    conseil "  maturity: unstable"
    conseil "  generation: 1"
    reparable C1 carte-creer
  else
    local manquants='' champ
    for champ in namespace version maturity generation; do
      [[ -n "$(_clia_carte_champ "$CIBLE" "$champ" 2>/dev/null || printf '')" ]] \
        || manquants+="$champ "
    done
    if [[ -z "$manquants" ]]; then
      verdict C1 ok ".dev/clia.yaml porte ses quatre champs"
    else
      verdict C1 bloquant ".dev/clia.yaml est incomplet : $manquants"
      conseil "ajoutez les champs manquants à .dev/clia.yaml : $manquants"
      # shellcheck disable=SC2086  # la liste des champs est voulue éclatée
      reparable C1 carte-completer $manquants
    fi
  fi

  # C2 — le harnais installé, comparé à celui qu'offre clia.
  local attendue entree posee
  attendue=$(_clia_def_champ harness-ia version 2>/dev/null || printf '')
  entree=$(_clia_installe_entree "$CIBLE" harness harness-ia)
  posee=$(printf '%s' "$entree" | awk -F'\t' '{print $4}')

  if [[ ! -f "$CIBLE/CLAUDE.md" ]]; then
    verdict C2 avert "aucun harnais IA n'est posé"
    conseil "pour en poser un : clia harness-ia init"
    reparable C2 harnais-poser
  elif [[ -z "$posee" ]]; then
    verdict C2 avert "un harnais est posé mais n'est pas inventorié"
    conseil "il a été posé avant l'inventaire. Sa version ne se lit pas sur le"
    conseil "fichier : seule sa régénération l'établit, et elle réécrit un corps"
    conseil "qui appartient au dépôt. C'est à vous de la demander :"
    conseil "  clia harness-ia init --force"
  elif [[ "$posee" == "$attendue" ]]; then
    verdict C2 ok "harnais en version $posee, celle qu'offre clia"
  else
    verdict C2 avert "harnais en version $posee, clia en offre $attendue"
    conseil "pour le régénérer sans perdre skills ni fonctionnalités :"
    conseil "  clia harness-ia init --force"
  fi

  # C3 — les extensions déclarées, et leur clone.
  local n_ext=0 ns uri
  while IFS=$'\t' read -r ns uri; do
    [[ -n "$ns" ]] || continue
    n_ext=$((n_ext + 1))
    if [[ -d "$(_clia_extension_cache "$ns")" ]]; then
      verdict C3 ok "extension $ns : clonée"
    else
      verdict C3 bloquant "extension $ns : déclarée, non clonée"
      conseil "pour rétablir le clone de $ns :"
      conseil "  clia extension add ${uri:-<uri>}"
      # Sans URI, rien ne dit d'où recloner : l'écart reste, et se solde à la
      # main.
      [[ -n "$uri" ]] && reparable C3 extension-cloner "$ns" "$uri"
    fi
  done < <(_clia_extensions_declarees "$CIBLE")
  (( n_ext == 0 )) && verdict C3 ok "aucune extension déclarée"

  # C4 — ce qui est inventorié existe-t-il encore ?
  local n_perdus=0 type nom version
  while IFS=$'\t' read -r type ns nom version uri; do
    [[ -n "$type" ]] || continue
    case "$type" in
      ressource)
        [[ -d "$CIBLE/_ressources/$nom" ]] || {
          verdict C4 avert "ressource $nom : inventoriée, absente du disque"
          conseil "la ressource $nom a été retirée sans l'être de l'inventaire"
          reparable C4 inventaire-oublier ressource "$nom"
          n_perdus=$((n_perdus + 1))
        } ;;
      skill)
        [[ -f "$CIBLE/.claude/skills/$nom/SKILL.md" ]] || {
          verdict C4 avert "skill $nom : inventorié, absent du disque"
          reparable C4 inventaire-oublier skill "$nom"
          n_perdus=$((n_perdus + 1))
        } ;;
      feature)
        grep -qF "<!-- BEGIN ${nom} feature -->" "$CIBLE/CLAUDE.md" 2>/dev/null || {
          verdict C4 avert "fonctionnalité $nom : inventoriée, absente du harnais"
          reparable C4 inventaire-oublier feature "$nom"
          n_perdus=$((n_perdus + 1))
        } ;;
    esac
  done < <(_clia_installe "$CIBLE")
  (( n_perdus == 0 )) && verdict C4 ok "tout ce qui est inventorié est sur le disque"

  # C5 — ce qui est sur le disque est-il inventorié ?
  local n_muets=0 dir
  while IFS=$'\t' read -r nom dir; do
    [[ -n "$nom" ]] || continue
    if [[ -z "$(_clia_installe_entree "$CIBLE" ressource "$nom")" ]]; then
      verdict C5 avert "ressource $nom : sur le disque, non inventoriée"
      reparable C5 inventaire-inscrire "$nom" "$dir"
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
    reparable C6 extensions-fondre
  else
    verdict C6 ok "aucun emplacement abandonné"
  fi

  return 0
}

# --------------------------------------------------------------------------
# Les réparations
# --------------------------------------------------------------------------
#
# Un geste par écart, et chacun rend un code : ce qui a échoué est dit comme
# tel, jamais compté comme réparé. Rapporter un succès non constaté serait
# pire que de ne rien réparer — le dépôt paraîtrait sain.

GESTES=''
REPARES=0
ECHOUES=0

geste()  { GESTES+="réparé"$'\t'"$1"$'\t'"$2"$'\n'; REPARES=$((REPARES + 1)); }
manque() { GESTES+="échec"$'\t'"$1"$'\t'"$2"$'\n'; ECHOUES=$((ECHOUES + 1)); }

# Le namespace que le remote suggère, ou rien. Il est montré, jamais écrit :
# USE-003 fait du namespace une déclaration du dépôt, et le déduire d'un
# remote reviendrait à décider de la provenance de ses ressources.
namespace_suggere() {
  local url nom reste owner
  url=$(git -C "$CIBLE" remote get-url origin 2>/dev/null) || return 1
  [[ -n "$url" ]] || return 1
  url="${url%.git}"; url="${url%/}"
  nom="${url##*/}"
  reste="${url%/*}"
  owner="${reste##*[:/]}"
  [[ -n "$owner" && -n "$nom" && "$owner" != "$url" ]] || return 1
  printf '%s/%s\n' "$owner" "$nom"
}

valeur_par_defaut() {
  case "$1" in
    namespace)  printf '<publisher>/%s\n' "$(basename "$CIBLE")" ;;
    version)    printf '0.1.0\n' ;;
    maturity)   printf 'unstable\n' ;;
    generation) printf '1\n' ;;
  esac
}

# C1 — poser la carte. Le contenu est celui de clia init : le namespace y est
# une invite, non une valeur.
carte_creer() {
  local carte suggestion
  carte=$(_clia_carte "$CIBLE")
  mkdir -p "$(dirname "$carte")" || return 1
  {
    printf '# La carte d'\''identité de ce dépôt clia.\n#\n'
    printf '# Posée par clia check --fix : ce dépôt a été instrumenté avant que la\n'
    printf '# configuration n'\''existe. Le namespace est à compléter — il dérive du\n'
    printf '# couple (publisher|user)/repo_name, et clia ne le devine pas.\n\n'
    printf 'namespace: %s\n' "$(valeur_par_defaut namespace)"
    printf 'version: %s\n' "$(valeur_par_defaut version)"
    printf 'maturity: %s\n' "$(valeur_par_defaut maturity)"
    printf 'generation: %s\n' "$(valeur_par_defaut generation)"
  } > "$carte" || return 1

  suggestion=$(namespace_suggere || printf '')
  if [[ -n "$suggestion" ]]; then
    geste C1 ".dev/clia.yaml posé — namespace à compléter (le remote suggère $suggestion)"
  else
    geste C1 ".dev/clia.yaml posé — namespace à compléter"
  fi
}

# C1 — compléter la carte. Les champs manquants sont insérés après la dernière
# ligne de l'entête, jamais en fin de fichier : la section installe y est, et
# un champ du dépôt tombé dedans ne serait plus lu.
carte_completer() {
  local carte tmp ajouts='' liste='' champ
  carte=$(_clia_carte "$CIBLE")
  # Les arguments vides sont ceux que la lecture d'une ligne de réparation
  # laisse quand elle porte moins de champs qu'elle n'en peut porter.
  for champ in "$@"; do
    [[ -n "$champ" ]] || continue
    ajouts+="$champ: $(valeur_par_defaut "$champ")"$'\n'
    liste+="${liste:+ }$champ"
  done
  [[ -n "$ajouts" ]] || return 0
  tmp=$(mktemp) || return 1
  awk -v ajouts="$ajouts" '
    { lignes[NR] = $0
      if ($0 ~ /^installe:[[:space:]]*$/ && !stop) stop = NR }
    END {
      fin = stop ? stop - 1 : NR
      for (i = 1; i <= fin; i++) if (lignes[i] ~ /[^[:space:]]/) pos = i
      for (i = 1; i <= NR; i++) {
        print lignes[i]
        if (i == pos) printf "%s", ajouts
      }
      if (!pos) printf "%s", ajouts
    }
  ' "$carte" > "$tmp" || { rm -f "$tmp"; return 1; }
  mv "$tmp" "$carte" || return 1
  geste C1 ".dev/clia.yaml complété : $liste"
}

# C2 — poser un harnais absent. Délégué à harness-ia, qui sait le faire et
# inscrit ce qu'il pose ; il refuse de lui-même si le fichier existe.
harnais_poser() {
  local script="$CLIA_SOURCE_DIR/_ressources/harness-ia/scripts/harness-ia.sh"
  if bash "$script" init >/dev/null 2>&1; then
    geste C2 "CLAUDE.md posé, et inscrit à l'inventaire"
  else
    manque C2 "la pose du harnais a échoué — clia harness-ia init dira pourquoi"
  fi
}

# C3 — rétablir un clone. Délégué à extension add, qui reconnaît une extension
# déjà déclarée et se borne alors à recloner.
extension_cloner() {
  local ns="$1" uri="$2"
  local script="$CLIA_SOURCE_DIR/_scripts/lib/cmd/extension.sh"
  if bash "$script" add "$uri" >/dev/null 2>&1; then
    geste C3 "extension $ns : clone rétabli depuis $uri"
  else
    manque C3 "extension $ns : le clone a échoué — clia extension add $uri dira pourquoi"
  fi
}

# C4 — retirer une entrée dont l'objet a disparu. L'inventaire redit alors le
# disque ; ce que l'entrée gardait — la provenance — est perdu avec elle, et
# c'est pourquoi le geste est nommé dans le rapport.
inventaire_oublier() {
  local type="$1" nom="$2"
  if _clia_oublier "$CIBLE" "$type" "$nom" 2>/dev/null; then
    geste C4 "$type $nom : entrée retirée de l'inventaire"
  else
    manque C4 "$type $nom : l'entrée n'a pas pu être retirée"
  fi
}

# C5 — inscrire une ressource du disque. Sa provenance est perdue : elle est
# supposée locale, comme pour une ressource créée sur place, et le rapport le
# dit pour que l'humain corrige si elle vient d'une extension.
inventaire_inscrire() {
  local nom="$1" dir="$2" def version ns
  def="$dir/schemas/$(basename "$dir").yaml"
  version=$(_clia_champ_de_fichier "$def" version 2>/dev/null || printf '')
  ns=$(_clia_carte_champ "$CIBLE" namespace 2>/dev/null || printf '')
  if _clia_enregistrer "$CIBLE" ressource "${ns:-—}" "$nom" "${version:-—}" 2>/dev/null; then
    geste C5 "ressource $nom : inscrite, provenance supposée locale"
  else
    manque C5 "ressource $nom : l'inscription a échoué"
  fi
}

# C6 — fondre l'ancien fichier dans l'inventaire, puis le retirer. Une
# extension déjà inventoriée n'est pas réécrite : l'inventaire fait foi, et
# l'ancien fichier n'est qu'une survivance.
extensions_fondre() {
  local ancien="$CIBLE/.dev/extensions.yaml" ns uri nom version cache reprises=0
  while IFS=$'\t' read -r ns uri; do
    [[ -n "$ns" ]] || continue
    nom=$(basename "$ns")
    [[ -n "$(_clia_installe_entree "$CIBLE" extension "$nom")" ]] && continue
    cache=$(_clia_extension_cache "$ns")
    version=$(_clia_carte_champ "$cache" version 2>/dev/null || printf '')
    if _clia_enregistrer "$CIBLE" extension "$ns" "$nom" "${version:-—}" "$uri" 2>/dev/null; then
      reprises=$((reprises + 1))
    else
      manque C6 "extension $ns : n'a pas pu être inscrite à l'inventaire"
      return 0
    fi
  done < <(_clia_extensions_ancien_fichier "$ancien")

  if rm -f "$ancien"; then
    geste C6 ".dev/extensions.yaml retiré, $reprises extension(s) fondue(s) dans l'inventaire"
  else
    manque C6 ".dev/extensions.yaml n'a pas pu être retiré"
  fi
}

appliquer() {
  local code action a1 a2 a3 a4
  while IFS=$'\t' read -r code action a1 a2 a3 a4; do
    [[ -n "$action" ]] || continue
    case "$action" in
      carte-creer)         carte_creer ;;
      carte-completer)     carte_completer "$a1" "$a2" "$a3" "$a4" ;;
      harnais-poser)       harnais_poser ;;
      extension-cloner)    extension_cloner "$a1" "$a2" ;;
      inventaire-oublier)  inventaire_oublier "$a1" "$a2" ;;
      inventaire-inscrire) inventaire_inscrire "$a1" "$a2" ;;
      extensions-fondre)   extensions_fondre ;;
      *)                   manque "$code" "geste inconnu : $action" ;;
    esac
  done <<<"$REPARATIONS"
  return 0
}

# --------------------------------------------------------------------------
# Le déroulé
# --------------------------------------------------------------------------

verifier
if [[ "$MODE" == 'fix' ]]; then
  # Le premier passage dit quoi réparer, le second dit où l'on en est : c'est
  # ce second-là qui est rendu. Un rapport d'avant réparation ferait croire à
  # des écarts qui n'existent plus.
  appliquer
  verifier
fi

printf 'dépôt      %s\n' "$CIBLE"
printf 'namespace  %s\n' "$(_clia_carte_champ "$CIBLE" namespace 2>/dev/null || printf '—')"
printf 'version    %s\n' "$(_clia_carte_champ "$CIBLE" version 2>/dev/null || printf '—')"
printf '\n'

if [[ -n "$GESTES" ]]; then
  while IFS=$'\t' read -r marque code enonce; do
    [[ -n "$marque" ]] || continue
    printf '%-7s %-3s %s\n' "$marque" "$code" "$enonce"
  done <<<"$GESTES"
  printf '\n'
fi

printf '%s' "$RAPPORT" | column -t -s"$(printf '\t')"
printf '\n'

BILAN=''
if (( BLOQUANTS > 0 )); then
  BILAN="$BLOQUANTS écart(s) bloquant(s), $AVERTISSEMENTS avertissement(s)"
elif (( AVERTISSEMENTS > 0 )); then
  BILAN="conforme, avec $AVERTISSEMENTS avertissement(s)"
else
  BILAN='conforme'
fi

if [[ "$MODE" == 'fix' ]]; then
  if (( REPARES == 0 && ECHOUES == 0 )); then
    _clia_msg "rien à réparer ; $BILAN"
  else
    _clia_msg "$REPARES écart(s) réparé(s), $ECHOUES échec(s) ; $BILAN"
  fi
else
  _clia_msg "$BILAN"
fi

if [[ -n "$CONSEILS" ]]; then
  printf '\n' >&2
  while IFS= read -r ligne; do
    [[ -n "$ligne" ]] && _clia_detail "$ligne"
  done <<<"$CONSEILS"
fi

if (( REPARABLES > 0 )); then
  printf '\n' >&2
  if [[ "$MODE" == 'fix' ]]; then
    _clia_msg "$REPARABLES écart(s) restent réparables : relancez clia check --fix"
    _clia_detail "quand ce qui a fait échouer le geste sera levé (réseau, droits)"
  else
    _clia_msg "$REPARABLES écart(s) sur $((BLOQUANTS + AVERTISSEMENTS)) sont réparables : clia check --fix"
  fi
fi

(( BLOQUANTS > 0 )) && exit 1
exit 0
