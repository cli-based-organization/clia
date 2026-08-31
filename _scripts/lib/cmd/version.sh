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
        clia version release major|minor|patch

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

Publier une version
-------------------

  release major      X.Y.Z  ->  X+1.0.0
  release minor      X.Y.Z  ->  X.Y+1.0
  release patch      X.Y.Z  ->  X.Y.Z+1

La commande incrémente l'alias dans la carte, puis commite ce seul fichier.
Le dépôt doit être propre : sans cela, la publication emporterait du travail
en cours dont personne n'a demandé la publication.

Elle ne pose pas d'étiquette git et ne pousse rien : publier une version est
un fait inscrit dans l'historique du dépôt, et ce qu'on en fait ensuite
appartient à qui le publie.

Ce que la commande écrit sur la sortie standard tient sur une ligne, pour
qu'une autre commande puisse la lire. Tout le reste va sur l'erreur standard.

Codes de retour :
  0  la demande est satisfaite
  1  refus : aucun commit, aucun alias à rapporter, dépôt non propre, ou
     alias non incrémentable
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
# Publier une version
# --------------------------------------------------------------------------
#
# SES-001 tâche 2. Publier, c'est faire en sorte que l'alias de HEAD diffère
# de celui de son parent — c'est la définition même d'une version publiée,
# donnée par la tâche 1. Il suffit donc d'incrémenter l'alias dans la carte
# et de commiter ce seul fichier ; la post-condition en découle, elle n'a pas
# à être arrangée après coup.
#
# Pourquoi le dépôt doit être propre. Le commit de publication ne doit porter
# que le changement d'alias. Si le dépôt portait du travail en cours, publier
# l'emporterait avec lui, et l'historique dirait qu'une version a été publiée
# là où quelqu'un a surtout sauvegardé son travail.

depot_est_propre() {
  [[ -z "$(git_ status --porcelain 2>/dev/null)" ]]
}

# L'alias incrémenté, ou un échec si l'alias n'a pas la forme attendue.
#
# Le préfixe « v » facultatif est conservé : la commande incrémente ce que la
# carte déclare, elle ne la reformate pas. Le tag de pré-publication, lui, est
# retiré — une version publiée n'est pas une pré-publication, et le garder
# ferait qu'un « release patch » depuis 0.1.0-beta rendrait 0.1.1-beta, qui
# n'en est toujours pas une.
#
# Les groupes de la correspondance sont lus directement, sans passer par une
# ligne à découper : un préfixe absent y produit un champ vide que le
# découpage par espaces ferait disparaître, et tous les nombres se
# décaleraient d'un rang. C'était le cas — 1.2.3 devenait 12.3.1.
#
# La base dix est forcée : un alias tel que 1.08.0 est mal formé au regard de
# semver, mais le motif l'accepte, et l'arithmétique du shell lirait 08 comme
# un octal invalide plutôt que comme huit.
incrementer() {
  local alias="$1" niveau="$2" prefixe major minor patch
  [[ "$alias" =~ ^(v?)([0-9]+)\.([0-9]+)\.([0-9]+)(-[0-9A-Za-z.-]+)?$ ]] || return 1
  prefixe="${BASH_REMATCH[1]}"
  major=$((10#${BASH_REMATCH[2]}))
  minor=$((10#${BASH_REMATCH[3]}))
  patch=$((10#${BASH_REMATCH[4]}))
  case "$niveau" in
    major) major=$((major + 1)); minor=0; patch=0 ;;
    minor) minor=$((minor + 1)); patch=0 ;;
    patch) patch=$((patch + 1)) ;;
    *)     return 1 ;;
  esac
  printf '%s%s.%s.%s\n' "$prefixe" "$major" "$minor" "$patch"
}

# Réécrit le champ « version » de la carte, et rien d'autre.
#
# Seule la première ligne « version: » en colonne zéro est touchée : les
# champs « version » imbriqués sous « use: » désignent la version d'une
# ressource, non celle du dépôt. Un commentaire de fin de ligne est conservé.
# L'écriture passe par un fichier temporaire : une écriture interrompue
# laisserait la carte tronquée, et la carte est ce qui identifie le dépôt.
ecrire_alias() {
  local carte="$1" nouveau="$2" tmp
  tmp=$(mktemp "${carte}.XXXXXX") || return 1
  if ! awk -v nouveau="$nouveau" '
        /^version:[ \t]/ && !fait {
          commentaire = ""
          if (match($0, /#.*/)) commentaire = "  " substr($0, RSTART)
          print "version: " nouveau commentaire
          fait = 1
          next
        }
        { print }
      ' "$carte" > "$tmp"; then
    rm -f "$tmp"
    return 1
  fi
  # Les droits du fichier d'origine, non ceux que mktemp a posés.
  chmod --reference="$carte" "$tmp" 2>/dev/null || true
  mv -f "$tmp" "$carte"
}

publier() {
  local niveau="$1" tete carte relative ancien nouveau

  case "$niveau" in
    major|minor|patch) ;;
    *) _clia_msg "niveau inconnu : $niveau"
       _clia_detail "les niveaux sont major, minor et patch"
       return 2 ;;
  esac

  if ! depot_est_propre; then
    _clia_msg "le dépôt n'est pas propre : la publication est refusée"
    _clia_detail "un commit de publication ne porte que le changement de version"
    git_ status --short >&2
    return 1
  fi

  tete=$(git_ rev-parse --verify --quiet HEAD 2>/dev/null || printf '')
  if [[ -z "$tete" ]]; then
    _clia_msg "le dépôt n'a aucun commit : il n'y a pas de version à incrémenter"
    _clia_detail "commitez une carte portant « version: X.Y.Z », puis publiez"
    return 1
  fi

  if ! relative=$(_clia_carte_relative "$DEPOT"); then
    _clia_msg "aucune carte de dépôt : il n'y a pas de version à incrémenter"
    _clia_detail "déclarez « version: X.Y.Z » dans clia.yaml, puis commitez"
    return 1
  fi
  carte="$DEPOT/$relative"

  ancien=$(_clia_champ_yaml "$carte" version || printf '')
  if [[ -z "$ancien" ]]; then
    _clia_msg "la carte $relative ne déclare pas de champ « version »"
    _clia_detail "déclarez « version: X.Y.Z », puis publiez"
    return 1
  fi

  if ! nouveau=$(incrementer "$ancien" "$niveau"); then
    _clia_msg "l'alias « $ancien » n'a pas la forme X.Y.Z : il n'est pas incrémentable"
    _clia_detail "corrigez le champ « version » de $relative, puis publiez"
    return 1
  fi

  [[ "$ancien" == *-* ]] && {
    _clia_msg "le tag de pré-publication de « $ancien » est retiré"
    _clia_detail "une version publiée n'est pas une pré-publication"
  }

  ecrire_alias "$carte" "$nouveau" || {
    _clia_msg "la carte $relative n'a pas pu être réécrite"
    return 1
  }

  # Ce seul fichier est indexé : le dépôt était propre, rien d'autre ne doit
  # entrer dans ce commit.
  if ! git_ add -- "$relative" \
     || ! git_ commit -q -m "release $nouveau" -- "$relative"; then
    _clia_msg "le commit de publication a échoué : rien n'est publié"
    _clia_detail "la carte est remise dans l'état de HEAD"
    git_ reset -q HEAD -- "$relative" 2>/dev/null || true
    git_ checkout -q -- "$relative" 2>/dev/null || true
    return 1
  fi

  printf '%s\n' "$nouveau"
  _clia_msg "$ancien -> $nouveau, publié par $(git_ rev-parse --short HEAD)"
  _clia_detail "aucune étiquette n'est posée, et rien n'est poussé"
  return 0
}

# --------------------------------------------------------------------------
# Dispatch
# --------------------------------------------------------------------------

case "${1:-}" in
  '')            alias_de_version ;;
  --true)        [[ $# -eq 1 ]] || { _clia_msg "--true ne prend pas d'argument"; exit 2; }
                 version_exacte ;;
  release)       shift
                 if [[ $# -eq 0 ]]; then
                   _clia_msg "clia version release attend un niveau"
                   _clia_detail "les niveaux sont major, minor et patch"
                   exit 2
                 fi
                 if [[ $# -gt 1 ]]; then
                   _clia_msg "clia version release n'attend qu'un niveau : $*"
                   exit 2
                 fi
                 # Les niveaux sont écrits en majuscules dans SES-001 et en
                 # minuscules dans les autres commandes : les deux répondent.
                 publier "$(printf '%s' "$1" | tr '[:upper:]' '[:lower:]')" ;;
  -h|--help)     aide; exit 0 ;;
  *)             _clia_msg "argument inattendu : $1"
                 _clia_detail "l'usage : clia version --help"
                 exit 2 ;;
esac
