#!/usr/bin/env bash
# Description: La version du dépôt, ou d'une ressource installée.
# Périmètre: dépôt
# Signature: version
# Signature: version --true
# Signature: version release major|minor|patch
# Signature: version RESSOURCE
# Option: version --true
#
# Implémente SES-001 tâches 1 et 2. L'aide brève n'est pas écrite ici : elle
# découle des quatre déclarations ci-dessus, que le point d'entrée lit. Ce
# fichier ne porte donc que le manuel, et le travail.
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
# shellcheck source=../version.sh
. "$CLIA_SOURCE_DIR/_scripts/lib/version.sh"
# shellcheck source=../identite.sh
. "$CLIA_SOURCE_DIR/_scripts/lib/identite.sh"
# shellcheck source=../maj.sh
. "$CLIA_SOURCE_DIR/_scripts/lib/maj.sh"
# shellcheck source=../mise-a-jour.sh
. "$CLIA_SOURCE_DIR/_scripts/lib/mise-a-jour.sh"
# shellcheck source=../parc.sh
. "$CLIA_SOURCE_DIR/_scripts/lib/parc.sh"

# Le point d'entrée pose CLIA_WORK_DIR pour toute invocation qui travaille, et
# ne le pose pas pour une demande de manuel : une page de manuel ne dépend
# d'aucun dépôt, et l'exiger la rendrait illisible hors d'un dépôt git. La
# valeur peut donc être vide, et elle ne l'est que sur ce chemin-là, qui sort
# avant d'avoir touché à git.
DEPOT="${CLIA_WORK_DIR:-}"

git_() { git -C "$DEPOT" "$@"; }

# --------------------------------------------------------------------------

manuel() {
  cat <<'EOF' | _clia_man clia-version 1 "Manuel de l'utilisateur clia"
NOM
clia-version - rapporter la version du dépôt courant, et la publier

SYNOPSIS
clia version
clia version --true
clia version release major|minor|patch

DESCRIPTION
La version d'un dépôt s'énonce de deux façons, et les confondre est
la source de la plupart des erreurs de publication.

La source de vérité est le commit. Un commit désigne un et un seul
état du dépôt, et son empreinte ne peut pas mentir. C'est la version
exacte, et c'est elle qu'il faut employer pour valider.

L'alias de version est la forme lisible, X.Y.Z, inscrite à la main
dans le champ « version » de la carte du dépôt. Il est commode et
faillible : rien n'oblige à l'incrémenter, et deux commits peuvent
donc porter le même.

Une version est dite publiée quand l'alias que porte HEAD diffère de
celui que portait son parent : quelqu'un l'a délibérément changé à ce
commit. Son alias est rendu tel quel, X.Y.Z.

Une version est dite de travail quand HEAD porte le même alias que
son parent : rien n'a été publié depuis, et le dépôt a seulement
avancé. Son alias est alors X.Y.Z+<hash court>, ce qui le rend
univoque à nouveau sans prétendre qu'il a été publié.

Un commit sans parent est traité comme une publication : il n'existe
pas d'alias antérieur dont celui-ci pourrait être la répétition.

L'alias rapporté est celui de HEAD, jamais celui du disque. Quand la
carte a été modifiée sans être commitée, la commande rapporte l'alias
de HEAD et le signale sur la sortie d'erreur.

SOUS-COMMANDES
release major|minor|patch
       Incrémente l'alias dans la carte, puis commite ce seul
       fichier. Le message du commit est « release X.Y.Z ».

       major porte X.Y.Z à X+1.0.0, minor à X.Y+1.0, patch à
       X.Y.Z+1. Le niveau s'écrit indifféremment en majuscules ou
       en minuscules.

       Un préfixe « v » est conservé. Un tag de pré-publication est
       retiré, et le retrait est signalé : une version publiée n'est
       pas une pré-publication.

       Le dépôt doit être propre — aucun fichier modifié, indexé ni
       non suivi. Sans cette condition, le commit de publication
       emporterait du travail en cours dont personne n'a demandé la
       publication.

       Aucune étiquette git n'est posée, et rien n'est poussé.
       Publier est un fait inscrit dans l'historique ; ce qu'on en
       fait ensuite appartient à qui publie.

       Si le commit échoue, la carte est remise dans l'état de
       HEAD : la publication est tout ou rien.

OPTIONS
--true
       Rend la version exacte, c'est-à-dire l'empreinte complète du
       commit HEAD, sur quarante caractères. Ne prend aucun argument.

SORTIE
La sortie standard ne porte qu'une seule ligne, pour qu'une autre
commande puisse la lire sans la filtrer : l'alias, l'empreinte, ou
l'alias nouvellement publié selon l'invocation.

Tout le reste — avertissements, refus, compte rendu de publication —
va sur la sortie d'erreur.

CODE DE RETOUR
0
       La demande est satisfaite. Des avertissements ont pu être
       écrits sur la sortie d'erreur : un alias qui n'a pas la forme
       X.Y.Z, un répertoire de travail modifié, une carte non
       commitée.

1
       Refus : aucun commit, aucun alias à rapporter, dépôt non
       propre, ou alias non incrémentable.

2
       Demande mal formée : argument inattendu, niveau de
       publication absent, inconnu, ou fourni plusieurs fois.

FICHIERS
clia.yaml, .clia.yaml, .dev/clia.yaml
       La carte du dépôt. Les trois emplacements sont cherchés dans
       cet ordre, et le premier trouvé l'emporte. Seul le champ
       « version » en colonne zéro est lu et réécrit : les champs
       « version » imbriqués désignent la version d'une ressource,
       non celle du dépôt. Un commentaire de fin de ligne est
       conservé.

EXEMPLES
L'alias d'une version publiée :

       $ clia version
       0.3.0

L'alias d'une version de travail, deux commits plus loin :

       $ clia version
       0.3.0+a1b2c3d

La version exacte, celle sur laquelle on valide :

       $ clia version --true
       04cddad0e1f2a3b4c5d6e7f8091a2b3c4d5e6f70

Publier un correctif :

       $ clia version release patch
       0.3.1

VOIR AUSSI
clia(1), clia-res(1), git-rev-parse(1), git-log(1)

La forme X.Y.Z est celle de la gestion sémantique de version,
décrite sur https://semver.org.
EOF
}

# --------------------------------------------------------------------------
# Les deux sorties
# --------------------------------------------------------------------------
#
# Les règles — quel commit fait foi, publiée ou de travail, comment un alias
# s'incrémente — vivent dans _scripts/lib/version.sh, partagées avec les
# ressources. Ce qui suit n'est que la mise en forme et les messages.

version_exacte() {
  local tete
  if ! tete=$(_clia_v_commit "$DEPOT" '') || [[ -z "$tete" ]]; then
    _clia_msg "le dépôt n'a aucun commit : il n'y a pas de version exacte"
    _clia_detail "la version exacte est un hash de commit ; commitez d'abord"
    return 1
  fi
  printf '%s\n' "$tete"

  if ! _clia_v_depot_propre "$DEPOT"; then
    _clia_msg "le répertoire de travail a changé depuis ce commit"
    _clia_detail "le hash désigne HEAD, non ce qui est sur le disque"
  fi
  return 0
}

alias_de_version() {
  local carte tete alias_tete alias_disque resolu commit alias etat court

  carte=$(_clia_carte "$DEPOT" || printf '')
  alias_disque=''
  [[ -n "$carte" ]] && alias_disque=$(_clia_v_alias_disque "$carte" || printf '')

  tete=$(_clia_v_commit "$DEPOT" '' || printf '')

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

  alias_tete=$(_clia_v_alias_au_commit "$DEPOT" "$tete" \
    "${_CLIA_CARTE_EMPLACEMENTS[@]}" || printf '')

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

  # L'alias rapporté est celui de HEAD, non celui du disque : la source de
  # vérité est le commit. Quand les deux diffèrent, le taire ferait croire
  # que ce qui est écrit dans la carte est déjà une version.
  if [[ -n "$alias_disque" && "$alias_disque" != "$alias_tete" ]]; then
    _clia_msg "la carte déclare $alias_disque sur le disque, non commité"
    _clia_detail "l'alias rapporté est celui de HEAD ; commitez pour le publier"
  fi

  resolu=$(_clia_v_resoudre "$DEPOT" '' "${_CLIA_CARTE_EMPLACEMENTS[@]}") || return 1
  IFS=$'\t' read -r commit alias etat <<<"$resolu"
  court=$(git_ rev-parse --short "$commit")

  _clia_v_est_semantique "$alias" || {
    _clia_msg "l'alias « $alias » n'a pas la forme X.Y.Z[-tag]"
    _clia_detail "il est rapporté tel quel ; --true donne la version exacte"
  }

  _clia_v_alias_affiche "$alias" "$etat" "$court"

  if ! _clia_v_depot_propre "$DEPOT"; then
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

publier() {
  local niveau="$1" tete relative ancien nouveau

  case "$niveau" in
    major|minor|patch) ;;
    *) _clia_msg "niveau inconnu : $niveau"
       _clia_detail "les niveaux sont major, minor et patch"
       return 2 ;;
  esac

  if ! _clia_v_depot_propre "$DEPOT"; then
    _clia_msg "le dépôt n'est pas propre : la publication est refusée"
    _clia_detail "un commit de publication ne porte que le changement de version"
    git_ status --short >&2
    return 1
  fi

  tete=$(_clia_v_commit "$DEPOT" '' || printf '')
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

  ancien=$(_clia_v_alias_disque "$DEPOT/$relative" || printf '')
  if [[ -z "$ancien" ]]; then
    _clia_msg "la carte $relative ne déclare pas de champ « version »"
    _clia_detail "déclarez « version: X.Y.Z », puis publiez"
    return 1
  fi

  if ! nouveau=$(_clia_v_incrementer "$ancien" "$niveau"); then
    _clia_msg "l'alias « $ancien » n'a pas la forme X.Y.Z : il n'est pas incrémentable"
    _clia_detail "corrigez le champ « version » de $relative, puis publiez"
    return 1
  fi

  [[ "$ancien" == *-* ]] && {
    _clia_msg "le tag de pré-publication de « $ancien » est retiré"
    _clia_detail "une version publiée n'est pas une pré-publication"
  }

  _clia_v_publier "$DEPOT" "$relative" "$nouveau" "release $nouveau" || return 1

  printf '%s\n' "$nouveau"
  _clia_msg "$ancien -> $nouveau, publié par $(git_ rev-parse --short HEAD)"
  _clia_detail "aucune étiquette n'est posée, et rien n'est poussé"
  return 0
}

# --------------------------------------------------------------------------
# La version d'une ressource installée — SES-002 tâche 1
# --------------------------------------------------------------------------
#
# Celle qui est posée dans ce dépôt, et rien d'autre : une ressource
# installée est figée, et sa version est un fait — SPC-001 §1.9.
#
# Ce vers quoi elle pourrait aller est une autre question, et une autre
# commande : clia update RESSOURCE.

version_de_ressource() {
  local quoi="$1" depot="${CLIA_WORK_DIR:-}" nom posee etat

  nom=$(_clia_pc_resoudre "$depot" "$quoi") || return 1
  posee=$(_clia_champ_yaml "$depot/$(_clia_zone_livree)/$nom/$nom.yaml" version || printf '')
  if [[ -z "$posee" ]]; then
    _clia_msg "$nom ne déclare pas de version"
    _clia_detail "sa définition : $(_clia_zone_livree)/$nom/$nom.yaml"
    return 1
  fi
  printf '%s\n' "$posee"

  etat=$(_clia_pc_etat "$depot" "$nom" "$posee")
  case "$etat" in
    'à jour')
      _clia_msg "$nom : $posee, la dernière que $(_clia_pc_source "$depot" "$nom") déclare" ;;
    'en retard')
      _clia_msg "$nom : $posee, alors que $(_clia_pc_derniere "$depot" "$nom") est disponible"
      _clia_detail "pour l'y amener : clia upgrade $nom" ;;
    'en avance')
      _clia_msg "$nom : $posee, au-delà de ce que sa source déclare" ;;
    *)
      _clia_msg "$nom : $posee ; sa source n'a pas été jointe" ;;
  esac
  _clia_detail "les versions disponibles : clia update $nom"
  return 0
}

# --------------------------------------------------------------------------
# Dispatch
# --------------------------------------------------------------------------

# Le manuel est reconnu à n'importe quelle profondeur : « clia version
# release --man » rend la même page que « clia version --man ». L'unité de
# manuel est la commande, comme dans unix — il n'existe pas de page distincte
# pour chaque sous-commande.
for _arg in "$@"; do
  [[ "$_arg" == '--man' ]] || continue
  manuel
  exit 0
done

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
  # -h et --help n'apparaissent pas ici : le point d'entrée les intercepte à
  # toute profondeur et rend l'aide brève à partir des déclarations de tête.
  # Une commande n'écrit pas son aide, elle déclare ses signatures.
  # Un argument qui n'est ni une option ni un verbe désigne une ressource
  # installée — SES-002 tâche 1. « clia version » dit où en est le dépôt ;
  # « clia version RESSOURCE » dit où en est ce qu'il a installé.
  -*)            _clia_msg "option inconnue : $1"
                 _clia_detail "l'usage : clia version --help"
                 exit 2 ;;
  *)             [[ $# -eq 1 ]] || {
                   _clia_msg "clia version n'attend qu'une ressource : $*"
                   _clia_detail "l'usage : clia version RESSOURCE"
                   exit 2
                 }
                 version_de_ressource "$1" ;;
esac
