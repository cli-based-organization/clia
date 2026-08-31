#!/usr/bin/env bash
# Description: La version du dépôt — l'alias lisible, ou le hash exact.
# Périmètre: dépôt
#
# Implémente SES-001 tâche 1.
#
# Le lexique, et pourquoi il compte
# ---------------------------------
#
#   source de vérité   le commit. Une version est un état du dépôt, et git
#                      est le seul à en tenir l'historique sans mentir.
#   version exacte     le hash du commit. Elle désigne un et un seul état,
#                      et c'est elle qu'on emploie pour valider.
#   alias de version   X.Y.Z[-tag], lisible par un humain, inscrit dans la
#                      carte du dépôt. Commode, et faillible.
#   version publiée    HEAD porte un alias différent de celui de son parent :
#                      quelqu'un l'a délibérément changé à ce commit.
#   version de travail HEAD porte le même alias que son parent : rien n'a été
#                      publié depuis, et le dépôt a avancé. Son alias est
#                      alors X.Y.Z+<hash court>, qui désigne à nouveau un
#                      état unique.
#
# Pourquoi l'alias ne suffit pas. Il n'est exact que si quelqu'un l'a
# incrémenté au bon commit. Rien ne l'y oblige, et deux commits peuvent donc
# porter le même alias. Le suffixe +hash rend l'alias d'une version de
# travail à nouveau univoque, sans prétendre qu'il a été publié.
#
# Une correction à l'énoncé
# -------------------------
#
# SES-001 tâche 1 énonce deux règles qui, prises au mot, se contredisent :
# une version différente chez le parent donne une version publiée (ligne 36),
# et « n'a pas la même » entrée donne une version de travail (ligne 38). Les
# deux conditions sont la même, pour deux conclusions opposées.
#
# La lecture retenue est celle qui rend les deux règles complémentaires, et
# c'est aussi celle que la génération précédente avait écrite dans USE-004 :
#
#   alias(HEAD) != alias(HEAD^)  ->  version publiée
#   alias(HEAD) == alias(HEAD^)  ->  version de travail
#
# Le cas où HEAD n'a pas de parent est traité comme une publication : il n'y
# a pas d'alias antérieur dont celui-ci pourrait être la répétition.

set -euo pipefail

_CLIA_NOM='clia'
# shellcheck source=../commun.sh
. "$CLIA_SOURCE_DIR/_scripts/lib/commun.sh"

DEPOT="$CLIA_WORK_DIR"

git_() { git -C "$DEPOT" "$@"; }

# --------------------------------------------------------------------------

aide() {
  cat <<'EOF'
Usage : clia version [--true]

Sans argument, l'alias de version lisible du dépôt courant :

  X.Y.Z              version publiée — l'alias a changé à ce commit
  X.Y.Z+<hash>       version de travail — l'alias n'a pas changé depuis le
                     commit précédent, et le hash dit de quel état il s'agit

  --true             la version exacte : le hash complet du commit

La source de vérité est le commit, non l'alias. L'alias est inscrit à la main
dans la carte du dépôt et peut n'avoir pas été incrémenté ; --true ne peut
pas se tromper. Utilisez --true dès qu'il s'agit de valider.

La carte du dépôt est cherchée à trois emplacements, dans cet ordre :
clia.yaml, .clia.yaml, .dev/clia.yaml. Le premier trouvé l'emporte.

Ce que la commande écrit sur la sortie standard tient sur une ligne, pour
qu'une autre commande puisse la lire. Tout le reste va sur l'erreur standard.

Codes de retour :
  0  la demande est satisfaite
  1  refus : aucun commit, ou aucun alias à rapporter
  2  demande mal formée
EOF
}

# --------------------------------------------------------------------------
# Lecture
# --------------------------------------------------------------------------

# L'alias que porte la carte du dépôt à un commit donné, ou rien. Les trois
# emplacements sont essayés : la carte a pu être déplacée dans l'historique.
alias_au_commit() {
  local commit="$1" emplacement contenu ligne
  for emplacement in "${_CLIA_CARTE_EMPLACEMENTS[@]}"; do
    contenu=$(git_ show "$commit:$emplacement" 2>/dev/null) || continue
    ligne=$(printf '%s\n' "$contenu" | grep -m1 -E '^version:[[:space:]]') || continue
    _clia_valeur_yaml "${ligne#*:}"
    return 0
  done
  return 1
}

# L'alias que porte la carte sur le disque, ou rien.
alias_sur_disque() {
  local carte
  carte=$(_clia_carte "$DEPOT") || return 1
  _clia_champ_yaml "$carte" version
}

# Un alias sémantique : X.Y.Z, un « v » facultatif devant, un tag facultatif
# derrière. Ce contrôle n'échoue pas la commande — il avertit. Un alias mal
# formé reste ce que la carte déclare, et le taire serait pire que le dire.
alias_est_semantique() {
  [[ "$1" =~ ^v?[0-9]+\.[0-9]+\.[0-9]+(-[0-9A-Za-z.-]+)?$ ]]
}

# --------------------------------------------------------------------------
# Les deux sorties
# --------------------------------------------------------------------------

version_exacte() {
  local tete
  if ! tete=$(git_ rev-parse --verify --quiet HEAD 2>/dev/null) || [[ -z "$tete" ]]; then
    _clia_msg "le dépôt n'a aucun commit : il n'y a pas de version exacte"
    _clia_detail "la version exacte est un hash de commit ; commitez d'abord"
    return 1
  fi
  printf '%s\n' "$tete"

  if [[ -n "$(git_ status --porcelain 2>/dev/null)" ]]; then
    _clia_msg "le répertoire de travail a changé depuis ce commit"
    _clia_detail "le hash désigne HEAD, non ce qui est sur le disque"
  fi
  return 0
}

alias_de_version() {
  local tete parent alias_tete alias_parent alias_disque retenu court

  tete=$(git_ rev-parse --verify --quiet HEAD 2>/dev/null || printf '')

  alias_disque=$(alias_sur_disque || printf '')

  # Sans commit, il n'y a ni source de vérité ni parent à comparer. Ce que la
  # carte déclare est tout ce qu'on a, et cela se dit.
  if [[ -z "$tete" ]]; then
    if [[ -z "$alias_disque" ]]; then
      _clia_msg "aucun commit, et aucun alias de version dans la carte du dépôt"
      _clia_detail "déclarez « version: X.Y.Z » dans clia.yaml"
      return 1
    fi
    _clia_msg "le dépôt n'a aucun commit : cet alias n'est adossé à rien"
    _clia_detail "tant que rien n'est commité, il n'y a pas de version exacte"
    printf '%s\n' "$alias_disque"
    return 0
  fi

  alias_tete=$(alias_au_commit "$tete" || printf '')

  if [[ -z "$alias_tete" ]]; then
    if [[ -z "$alias_disque" ]]; then
      _clia_msg "aucun alias de version : la carte du dépôt n'en déclare pas"
      _clia_detail "déclarez « version: X.Y.Z » dans clia.yaml, puis commitez"
      return 1
    fi
    _clia_msg "l'alias de version n'est pas commité : il ne vaut que sur ce disque"
    _clia_detail "commitez la carte pour que la version soit adossée à un commit"
    printf '%s\n' "$alias_disque"
    return 0
  fi

  retenu="$alias_tete"

  # L'alias rapporté est celui de HEAD, non celui du disque : la source de
  # vérité est le commit. Quand les deux diffèrent, le taire ferait croire
  # que ce qui est écrit dans la carte est déjà une version.
  if [[ -n "$alias_disque" && "$alias_disque" != "$alias_tete" ]]; then
    _clia_msg "la carte déclare $alias_disque sur le disque, non commité"
    _clia_detail "l'alias rapporté est celui de HEAD ; commitez pour le publier"
  fi

  parent=$(git_ rev-parse --verify --quiet "${tete}^" 2>/dev/null || printf '')
  if [[ -n "$parent" ]]; then
    alias_parent=$(alias_au_commit "$parent" || printf '')
  else
    alias_parent=''
  fi

  # Version de travail : le parent porte le même alias, donc rien n'a été
  # publié à ce commit. Le hash court rend l'alias univoque à nouveau.
  if [[ "$alias_tete" == "$alias_parent" ]]; then
    court=$(git_ rev-parse --short HEAD)
    retenu="${alias_tete}+${court}"
  fi

  alias_est_semantique "$alias_tete" || {
    _clia_msg "l'alias « $alias_tete » n'a pas la forme X.Y.Z[-tag]"
    _clia_detail "il est rapporté tel quel ; --true donne la version exacte"
  }

  printf '%s\n' "$retenu"

  if [[ -n "$(git_ status --porcelain 2>/dev/null)" ]]; then
    _clia_msg "le répertoire de travail a changé depuis ce commit"
    _clia_detail "l'alias désigne HEAD, non ce qui est sur le disque"
  fi
  return 0
}

# --------------------------------------------------------------------------
# Dispatch
# --------------------------------------------------------------------------

case "${1:-}" in
  '')            alias_de_version ;;
  --true)        [[ $# -eq 1 ]] || { _clia_msg "--true ne prend pas d'argument"; exit 2; }
                 version_exacte ;;
  -h|--help)     aide; exit 0 ;;
  *)             _clia_msg "argument inattendu : $1"
                 _clia_detail "l'usage : clia version --help"
                 exit 2 ;;
esac
