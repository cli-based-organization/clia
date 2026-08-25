#!/usr/bin/env bash
# Description: Crée un dépôt git et l'instrumente avec clia.
# Périmètre: aucun
#
# Implémente .dev/usages/USE-002-initialiser-un-repo.md. L'interface est celle
# de git init : un chemin facultatif, le répertoire courant par défaut.
#
# USE-002 supporte un seul cas, celui du dépôt qui n'existe pas. Un dépôt git
# déjà là est refusé sans rien modifier : instrumenter l'existant appartient
# aux commandes de ressource, qui posent un élément à la fois.
#
# Le périmètre est déclaré « aucun » parce que la cible peut ne pas exister
# encore : le dispatcher ne peut pas la résoudre comme dépôt courant. La garde
# du mode --activate est donc appliquée ici, sur le chemin demandé, et avant
# que quoi que ce soit ne soit créé.
#
# Ce que la commande pose :
#
#   CLAUDE.md               le harnais IA, par clia harness-ia
#   .dev/intentions/INT-001 l'intention ultime, vide et à remplir
#   INTENTION.md            un lien symbolique vers elle
#   .dev/session.md         le fichier de travail
#
# Aucun fichier existant n'est écrasé. INTENTION.md fait exception dans un
# seul sens : s'il existe comme fichier régulier, son contenu est déplacé vers
# l'instance INT-001 et le lien symbolique est posé à sa place. Rien n'est
# perdu, et le dépôt gagne l'emplacement conventionnel.

set -euo pipefail

_CLIA_NOM='clia'
# shellcheck source=../commun.sh
. "$CLIA_SOURCE_DIR/_scripts/lib/commun.sh"

# --------------------------------------------------------------------------

aide() {
  cat <<'EOF'
Usage : clia init [PATH]

Crée un dépôt git et l'instrumente avec clia. PATH vaut le répertoire courant
par défaut.

Ce que la commande pose :
  CLAUDE.md                        le harnais IA
  .dev/intentions/INT-001-*.md     l'intention ultime, à remplir
  INTENTION.md                     un lien symbolique vers elle
  .dev/session.md                  le fichier de travail

Un dépôt git qui existe déjà n'est pas un cas supporté : la commande refuse,
sans rien modifier. Pour instrumenter un dépôt existant, les commandes de
ressource s'en chargent — clia harness-ia init, clia feature install.

Rien de ce qui existe n'est écrasé : un emplacement déjà occupé est annoncé
et conservé. Un INTENTION.md régulier déjà présent est déplacé vers
l'instance INT-001, et remplacé par le lien symbolique.

Codes de retour :
  0  le dépôt est créé et instrumenté
  1  refus : dépôt déjà existant, hors périmètre, ou un geste a échoué
  2  demande mal formée
EOF
}

case "${1:-}" in
  -h|--help|help) aide; exit 0 ;;
esac

if (( $# > 1 )); then
  _clia_msg "init prend au plus un chemin : $*"
  _clia_detail "usage : clia init [PATH]"
  exit 2
fi

# --------------------------------------------------------------------------
# La cible
# --------------------------------------------------------------------------

DEMANDE="${1:-$PWD}"
case "$DEMANDE" in
  /*) CIBLE="$DEMANDE" ;;
  *)  CIBLE="$PWD/${DEMANDE#./}" ;;
esac
# Normalise sans exiger que le chemin existe : realpath -m, ou le repli.
CIBLE=$(realpath -m "$CIBLE" 2>/dev/null || printf '%s\n' "${CIBLE%/}")

_clia_perimetre_permet "$CIBLE" || exit 1

# --------------------------------------------------------------------------
# Le dépôt git
# --------------------------------------------------------------------------
#
# USE-002 supporte un seul cas : le dépôt n'existe pas. Un dépôt git déjà là
# est un cas explicitement non supporté, et le refus vient avant toute
# écriture — un refus après coup ne serait pas un refus.
#
# Un répertoire qui existe sans être un dépôt git n'est ni l'un ni l'autre.
# Il est traité comme le cas nominal : c'est ce que git init fait lui-même,
# et refuser obligerait à effacer un répertoire vide pour le recréer.

if [[ -d "$CIBLE" ]] && git -C "$CIBLE" rev-parse --git-dir >/dev/null 2>&1; then
  DEPOT=$(git -C "$CIBLE" rev-parse --show-toplevel 2>/dev/null || printf '%s' "$CIBLE")
  _clia_msg "un dépôt git existe déjà, et ce cas n'est pas supporté par init"
  _clia_detail "dépôt : $DEPOT"
  _clia_detail "rien n'a été modifié. USE-002 ne couvre que la création d'un dépôt neuf."
  _clia_detail ''
  _clia_detail "pour instrumenter un dépôt existant, les commandes de ressource"
  _clia_detail "s'en chargent, une par une et sans rien écraser :"
  _clia_detail "  clia harness-ia init      pose CLAUDE.md"
  _clia_detail "  clia feature install ...  active une fonctionnalité"
  exit 1
fi

if [[ ! -d "$CIBLE" ]]; then
  mkdir -p "$CIBLE" || { _clia_msg "impossible de créer $CIBLE"; exit 1; }
fi

git -C "$CIBLE" init -q || { _clia_msg "git init a échoué dans $CIBLE"; exit 1; }
_clia_msg "dépôt git initialisé : $CIBLE"

# À partir d'ici, les commandes de ressource travaillent sur la cible.
export CLIA_WORK_DIR="$CIBLE"

mkdir -p "$CIBLE/.dev/intentions"

# --------------------------------------------------------------------------
# La carte du dépôt
# --------------------------------------------------------------------------
#
# USE-003 : le namespace ne peut pas être deviné, mais sa déclaration ne peut
# pas être reportée — sans elle, rien ne dit d'où vient une ressource. Il est
# donc posé à compléter, avec le nom du dépôt pour moitié.
#
# Le déduire d'un remote git serait tentant, mais le dépôt vient d'être créé
# par cette commande et n'en a aucun : ce serait du code que rien n'atteint.
#
# Le contenu est écrit ici plutôt que tiré d'un gabarit : .dev/clia.yaml n'est
# pas une ressource, il est la carte d'identité qui permet d'en avoir.

CARTE="$CIBLE/.dev/clia.yaml"
if [[ -f "$CARTE" ]]; then
  _clia_msg "conservé : .dev/clia.yaml existe déjà"
else
  NAMESPACE="<publisher>/$(basename "$CIBLE")"
  {
    printf '# La carte d'\''identité de ce dépôt clia.\n#\n'
    printf '# Le namespace dérive du couple (publisher|user)/repo_name. Il désigne la\n'
    printf '# provenance des ressources de ce dépôt, et rien d'\''autre : une catégorie\n'
    printf '# sous _ressources/ n'\''en est pas un.\n\n'
    printf 'namespace: %s\n' "$NAMESPACE"
    printf 'version: 0.1.0\n'
    printf 'maturity: unstable\n'
    printf 'generation: 1\n'
  } > "$CARTE"

  _clia_msg "installé : .dev/clia.yaml"
  _clia_detail "namespace à compléter : $NAMESPACE"
fi

# --------------------------------------------------------------------------
# Le harnais IA
# --------------------------------------------------------------------------
#
# Déléguée plutôt que réécrite : harness-ia sait déjà poser CLAUDE.md, et
# refuse de lui-même si le fichier existe. Son refus n'est pas une erreur
# ici — un dépôt qui a déjà son harnais reste un dépôt instrumentable.

HARNESS="$CLIA_SOURCE_DIR/_ressources/harness-ia/scripts/harness-ia.sh"
if [[ -f "$CIBLE/CLAUDE.md" ]]; then
  _clia_msg "conservé : CLAUDE.md existe déjà"
  _clia_detail "pour le régénérer : clia harness-ia init --force"
else
  bash "$HARNESS" init || { _clia_msg "la pose du harnais a échoué"; exit 1; }
fi

# --------------------------------------------------------------------------
# L'intention ultime
# --------------------------------------------------------------------------
#
# INTENTION.md n'est pas une ressource : c'est une adresse fixe qui pointe
# vers l'instance qui porte l'intention ultime. Le type le déclare, et c'est
# ce qui lui évite un emplacement dérogatoire.

GABARIT_INT=$(_clia_gabarit_de intention) || {
  _clia_msg "le type intention ne déclare pas de gabarit"
  _clia_detail "attendu dans $(_clia_definition intention)"
  exit 1
}
[[ -f "$GABARIT_INT" ]] || { _clia_msg "gabarit introuvable : $GABARIT_INT"; exit 1; }

INSTANCE="$CIBLE/.dev/intentions/INT-001-intention-ultime.md"
LIEN="$CIBLE/INTENTION.md"
TITRE=$(basename "$CIBLE")

poser_instance() {
  sed "s/{{titre}}/$TITRE/g" "$GABARIT_INT" > "$INSTANCE"
}

if [[ -L "$LIEN" ]]; then
  _clia_msg "conservé : INTENTION.md est déjà un lien symbolique"
  _clia_detail "vers $(readlink "$LIEN")"
  [[ -f "$INSTANCE" ]] || poser_instance
elif [[ -f "$LIEN" ]]; then
  # Un INTENTION.md régulier existe : son contenu appartient au dépôt et ne
  # se perd pas. Il devient l'instance, et l'adresse fixe devient le lien.
  if [[ -f "$INSTANCE" ]]; then
    _clia_msg "conservés : INTENTION.md et .dev/intentions/$(basename "$INSTANCE") existent tous deux"
    _clia_detail "clia ne choisit pas entre eux ; faites du premier un lien vers le second"
  else
    mv "$LIEN" "$INSTANCE"
    ln -s ".dev/intentions/$(basename "$INSTANCE")" "$LIEN"
    _clia_msg "déplacé : INTENTION.md -> .dev/intentions/$(basename "$INSTANCE")"
    _clia_detail "INTENTION.md est désormais un lien symbolique vers lui"
    _clia_detail "son contenu est intact, mais il lui manque le frontmatter du type"
  fi
else
  [[ -f "$INSTANCE" ]] || poser_instance
  ln -s ".dev/intentions/$(basename "$INSTANCE")" "$LIEN"
  _clia_msg "installé : .dev/intentions/$(basename "$INSTANCE")"
  _clia_detail "INTENTION.md pointe dessus. À remplir : c'est la raison d'être du dépôt"
fi

# --------------------------------------------------------------------------
# La session
# --------------------------------------------------------------------------

# Comme l'intention, la session est une ressource, et c'est sa définition qui
# dit où vit son gabarit — ici sous _features/, parce que le fichier posé est
# indissociable de la fonctionnalité qui apprend à l'agent à le lire.
GABARIT_SES=$(_clia_gabarit_de session) || {
  _clia_msg "le type session ne déclare pas de gabarit"
  _clia_detail "attendu dans $(_clia_definition session)"
  exit 1
}
SESSION="$CIBLE/.dev/session.md"

if [[ -f "$SESSION" ]]; then
  _clia_msg "conservé : .dev/session.md existe déjà"
elif [[ -f "$GABARIT_SES" ]]; then
  cp "$GABARIT_SES" "$SESSION"
  _clia_msg "installé : .dev/session.md"
else
  _clia_msg "gabarit de session introuvable : $GABARIT_SES"
  exit 1
fi

# --------------------------------------------------------------------------

_clia_msg "dépôt instrumenté : $CIBLE"
_clia_detail "l'état du harnais : clia harness-ia status"
_clia_detail "ce qui peut y être ajouté : clia skill list, clia feature list"
