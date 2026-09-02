#!/usr/bin/env bash
# Description: Les ressources du dépôt — new, ls, version, release.
# Périmètre: dépôt
# Signature: res new PREFIXE NOM [DESCRIPTION]
# Signature: res ls
# Signature: res version [--true] RESSOURCE
# Signature: res release major|minor|patch RESSOURCE
# Option: res version --true
#
# Implémente SES-001 tâche 5.
#
# Où vit une ressource
# --------------------
#
#   _ressources/<nom>/<nom>.yaml     sa définition — ce qui en fait une
#   _ressources/<nom>/primitives/    ce à partir de quoi ses livrables sont produits
#   _ressources/<nom>/skills/        les procédures qu'elle fournit
#   _ressources/<nom>/_scripts/      les automatismes qu'elle fournit
#
# Un répertoire de _ressources/ est une ressource parce qu'il porte sa
# définition, et pour aucune autre raison. Le reste est admis, jamais exigé :
# un répertoire vide oblige à l'ouvrir pour découvrir qu'il n'y a rien.
#
# Ce qui change par rapport à la génération précédente. Elle rangeait la
# définition sous schemas/<nom>.yaml. Ce niveau portait plusieurs formats de
# schéma qui n'existent plus ; il ne porte aujourd'hui qu'un fichier, et un
# répertoire qui n'en contient qu'un est un détour. La règle de
# reconnaissance y gagne : le répertoire porte son propre nom, suffixé .yaml.
#
# Ce que la définition déclare
# ----------------------------
#
# Cinq champs, et ce sont exactement ceux que les commandes emploient. La
# génération précédente en déclarait le double — emplacement des instances,
# gabarit, régime d'édition, cycle de vie — sans qu'aucune commande les fasse
# tenir, et son objection NON-001 porte précisément là-dessus : « les
# ressources core déclarent plus que le système ne tient ». Ces champs
# reviendront avec les commandes qui les emploieront.
#
# L'identité d'une ressource
# --------------------------
#
# SES-001 : « une version est définie par le namespace + prefix + version ».
# Le namespace est celui du dépôt, déclaré une fois dans sa carte ; le
# préfixe appartient à la ressource. Une ressource se désigne donc par
# <namespace>/<PREFIXE>, et porte sa propre version.
#
# La version d'une ressource
# --------------------------
#
# « exactement comme celle du repo » : les règles sont celles de
# _scripts/lib/version.sh, appelées par les deux commandes. Une seule
# écriture, donc un « exactement » garanti plutôt que ressemblant.
#
# Un seul point diffère, et c'est la portée de l'historique. La version du
# dépôt se lit sur HEAD et son parent ; celle d'une ressource se lit sur les
# deux derniers commits qui l'ont touchée. Sans cela, la version exacte d'une
# ressource changerait à chaque commit du dépôt, y compris ceux qui ne la
# concernent pas — et une empreinte qui change quand l'objet ne change pas ne
# désigne plus rien.

set -euo pipefail

_CLIA_NOM='clia'
# shellcheck source=../commun.sh
. "$CLIA_SOURCE_DIR/_scripts/lib/commun.sh"
# shellcheck source=../version.sh
. "$CLIA_SOURCE_DIR/_scripts/lib/version.sh"

DEPOT="${CLIA_WORK_DIR:-}"

git_() { git -C "$DEPOT" "$@"; }

# --------------------------------------------------------------------------

manuel() {
  cat <<'FIN' | _clia_man clia-res 1 "Manuel de l'utilisateur clia"
NOM
clia-res - créer, lister et versionner les ressources d'un dépôt

SYNOPSIS
clia res new PREFIXE NOM [DESCRIPTION]
clia res ls
clia res version [--true] RESSOURCE
clia res release major|minor|patch RESSOURCE

DESCRIPTION
Les ressources informationnelles sont le fondement du système
d'information. Une ressource dit comment produire des livrables
d'une nature précise, contient les primitives à partir desquelles
ils sont produits, et peut fournir les skills ou les scripts qui les
valident ou agissent sur eux.

Une primitive peut venir d'un humain, d'un agent, d'un automatisme,
ou d'une source d'information externe. Ce qui compte est qu'elle
soit là : un livrable reproductible est un livrable dont toutes les
entrées sont dans le dépôt.

Une ressource vit dans un répertoire qui porte son nom, sous
_ressources/. Ce répertoire est une ressource parce qu'il porte sa
définition, et pour aucune autre raison.

Chaque ressource a un nom et un préfixe. Le nom sert de chemin ; le
préfixe sert d'adresse à ses instances, et doit rester distinctif
dans le dépôt.

Une ressource a son propre cycle de vie, donc sa propre version. Son
identité est celle du dépôt qui la publie, suivie de son préfixe :
<namespace>/<PREFIXE>.

SOUS-COMMANDES
new PREFIXE NOM [DESCRIPTION]
       Crée _ressources/NOM/NOM.yaml, en version 0.1.0.

       PREFIXE s'écrit en deux à cinq majuscules. NOM s'écrit en
       minuscules, chiffres et tirets. Un préfixe déjà porté par une
       autre ressource est refusé : deux ressources au même préfixe
       rendraient les adresses de leurs instances ambiguës.

       Rien n'est commité. Créer n'est pas publier, et le dépôt doit
       être propre pour publier : commitez la ressource neuve avant
       d'incrémenter sa version.

ls
       Les ressources du dépôt : préfixe, nom, version déclarée,
       identité, description.

       La version montrée est celle que la définition déclare. Pour
       savoir si elle est publiée ou de travail, demandez-la :
       clia res version RESSOURCE.

version [--true] RESSOURCE
       La version de cette ressource, selon les mêmes règles que
       celle du dépôt. Voir clia-version(1) pour le lexique.

       RESSOURCE se désigne par son nom ou par son préfixe.

release major|minor|patch RESSOURCE
       Incrémente la version de cette ressource dans sa définition,
       puis commite ce seul fichier. Le message du commit est
       « release NOM X.Y.Z ».

       Le dépôt doit être propre, pour la même raison que pour la
       publication du dépôt lui-même.

OPTIONS
--true
       Rend la version exacte de la ressource : l'empreinte du
       dernier commit qui l'a touchée.

SORTIE
La sortie standard de « version » et de « release » ne porte qu'une
seule ligne, comme celle du dépôt. Celle de « ls » porte une ligne
d'en-tête et une ligne par ressource.

Tout le reste va sur la sortie d'erreur.

CODE DE RETOUR
0
       La demande est satisfaite, même s'il n'y a aucune ressource.

1
       Refus : ressource inconnue, emplacement occupé, préfixe déjà
       pris, dépôt non propre, ou alias non incrémentable.

2
       Demande mal formée.

FICHIERS
_ressources/<nom>/<nom>.yaml
       La définition. Elle déclare nom, titre, prefixe, version et
       description — exactement ce que les commandes emploient. Un
       champ qu'aucune commande ne fait tenir serait une promesse
       que le système ne tient pas.

_ressources/<nom>/primitives/, skills/, _scripts/
       Ce que la ressource porte. Admis, jamais exigés.

       Un fichier <nom>.sh déposé sous _scripts/ devient une
       commande de clia, découverte comme celles du noyau. Voir
       clia(1), et clia-hrn(1) pour celle de harness-ia.

EXEMPLES
Créer une ressource :

       $ clia res new ANL analyse "Ce qu'un examen du réel établit"
       créée : _ressources/analyse

Voir ce que le dépôt porte :

       $ clia res ls
       PREFIXE  NOM      VERSION  IDENTITE
       ANL      analyse  0.1.0    clia.noumanity.com/clia/ANL

Publier une version de cette ressource :

       $ clia res release minor analyse
       0.2.0

VOIR AUSSI
clia(1), clia-version(1), clia-setup(1)
FIN
}

# --------------------------------------------------------------------------
# Trouver les ressources
# --------------------------------------------------------------------------

RESSOURCES="$DEPOT/_ressources"

# « nom<TAB>chemin de la définition, relatif au dépôt », triées par nom.
inventaire() {
  local dir nom def
  for dir in "$RESSOURCES"/*/; do
    [[ -d "$dir" ]] || continue
    nom=$(basename "$dir")
    def="_ressources/$nom/$nom.yaml"
    [[ -f "$DEPOT/$def" ]] || continue
    printf '%s\t%s\n' "$nom" "$def"
  done | sort
  return 0
}

# _nom_de <désignation> — le nom de la ressource désignée par son nom ou par
# son préfixe, ou rien. Les deux ne peuvent pas se confondre : un nom est en
# minuscules, un préfixe en majuscules.
_nom_de() {
  local demande="$1" nom def prefixe
  while IFS=$'\t' read -r nom def; do
    [[ -n "$nom" ]] || continue
    if [[ "$nom" == "$demande" ]]; then printf '%s\n' "$nom"; return 0; fi
    prefixe=$(_clia_champ_yaml "$DEPOT/$def" prefixe || printf '')
    if [[ -n "$prefixe" && "$prefixe" == "$demande" ]]; then
      printf '%s\n' "$nom"; return 0
    fi
  done < <(inventaire)
  return 1
}

# Résout une désignation, ou refuse en nommant ce qui existe.
resoudre() {
  local demande="$1" nom
  if nom=$(_nom_de "$demande"); then
    printf '%s\n' "$nom"
    return 0
  fi
  _clia_msg "ressource inconnue : $demande"
  if [[ -z "$(inventaire)" ]]; then
    _clia_detail "ce dépôt n'en porte aucune ; clia res new en crée une"
  else
    _clia_detail "celles du dépôt : clia res ls"
  fi
  return 1
}

def_de()    { printf '_ressources/%s/%s.yaml\n' "$1" "$1"; }
portee_de() { printf '_ressources/%s\n' "$1"; }

namespace_du_depot() {
  local carte
  carte=$(_clia_carte "$DEPOT") || return 1
  _clia_champ_yaml "$carte" namespace
}

# --------------------------------------------------------------------------
# ls
# --------------------------------------------------------------------------

lister() {
  local nom def ns prefixe version description lignes=''

  if [[ -z "$(inventaire)" ]]; then
    _clia_msg "ce dépôt ne porte aucune ressource"
    _clia_detail "pour en créer une : clia res new PREFIXE NOM"
    return 0
  fi

  ns=$(namespace_du_depot || printf '')
  [[ -n "$ns" ]] || ns='(namespace non déclaré)'

  while IFS=$'\t' read -r nom def; do
    [[ -n "$nom" ]] || continue
    prefixe=$(_clia_champ_yaml "$DEPOT/$def" prefixe || printf '—')
    version=$(_clia_v_alias_disque "$DEPOT/$def" || printf '—')
    description=$(_clia_champ_yaml "$DEPOT/$def" description || printf '')
    lignes+=$(printf '%s\t%s\t%s\t%s/%s\t%s' \
      "$prefixe" "$nom" "$version" "$ns" "$prefixe" "$description")$'\n'
  done < <(inventaire)

  { printf 'PREFIXE\tNOM\tVERSION\tIDENTITE\tDESCRIPTION\n'
    printf '%s' "$lignes"
  } | column -t -s $'\t'
  return 0
}

# --------------------------------------------------------------------------
# version
# --------------------------------------------------------------------------

version_exacte() {
  local nom="$1" commit
  if ! commit=$(_clia_v_commit "$DEPOT" "$(portee_de "$nom")"); then
    _clia_msg "$nom n'a aucun commit : il n'y a pas de version exacte"
    _clia_detail "commitez la ressource pour qu'elle soit adossée à un commit"
    return 1
  fi
  printf '%s\n' "$commit"

  if ! _clia_v_depot_propre "$DEPOT"; then
    _clia_msg "le répertoire de travail a changé depuis ce commit"
    _clia_detail "le hash désigne le dernier commit qui a touché $nom"
  fi
  return 0
}

alias_de_version() {
  local nom="$1" def portee alias_disque resolu commit alias etat court alias_commit

  def=$(def_de "$nom")
  portee=$(portee_de "$nom")
  alias_disque=$(_clia_v_alias_disque "$DEPOT/$def" || printf '')

  if ! commit=$(_clia_v_commit "$DEPOT" "$portee"); then
    if [[ -z "$alias_disque" ]]; then
      _clia_msg "$nom n'est pas commité, et sa définition ne déclare pas de version"
      _clia_detail "déclarez « version: X.Y.Z » dans $def"
      return 1
    fi
    _clia_msg "$nom n'est pas commité : cet alias n'est adossé à rien"
    _clia_detail "commitez la ressource pour qu'elle ait une version exacte"
    printf '%s\n' "$alias_disque"
    return 0
  fi

  alias_commit=$(_clia_v_alias_au_commit "$DEPOT" "$commit" "$def" || printf '')
  if [[ -z "$alias_commit" ]]; then
    if [[ -z "$alias_disque" ]]; then
      _clia_msg "$nom ne déclare aucune version"
      _clia_detail "déclarez « version: X.Y.Z » dans $def, puis commitez"
      return 1
    fi
    _clia_msg "la version de $nom n'est pas commitée : elle ne vaut que sur ce disque"
    _clia_detail "commitez $def pour qu'elle soit adossée à un commit"
    printf '%s\n' "$alias_disque"
    return 0
  fi

  if [[ -n "$alias_disque" && "$alias_disque" != "$alias_commit" ]]; then
    _clia_msg "la définition déclare $alias_disque sur le disque, non commité"
    _clia_detail "l'alias rapporté est celui du commit ; commitez pour le publier"
  fi

  resolu=$(_clia_v_resoudre "$DEPOT" "$portee" "$def") || return 1
  IFS=$'\t' read -r commit alias etat <<<"$resolu"
  court=$(git_ rev-parse --short "$commit")

  _clia_v_est_semantique "$alias" || {
    _clia_msg "l'alias « $alias » n'a pas la forme X.Y.Z[-tag]"
    _clia_detail "il est rapporté tel quel ; --true donne la version exacte"
  }

  _clia_v_alias_affiche "$alias" "$etat" "$court"

  if ! _clia_v_depot_propre "$DEPOT"; then
    _clia_msg "le répertoire de travail a changé depuis ce commit"
    _clia_detail "l'alias désigne le dernier commit qui a touché $nom"
  fi
  return 0
}

# --------------------------------------------------------------------------
# release
# --------------------------------------------------------------------------

publier() {
  local niveau="$1" nom="$2" def ancien nouveau

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

  def=$(def_de "$nom")
  ancien=$(_clia_v_alias_disque "$DEPOT/$def" || printf '')
  if [[ -z "$ancien" ]]; then
    _clia_msg "$def ne déclare pas de champ « version »"
    _clia_detail "déclarez « version: X.Y.Z », puis publiez"
    return 1
  fi

  if ! nouveau=$(_clia_v_incrementer "$ancien" "$niveau"); then
    _clia_msg "l'alias « $ancien » n'a pas la forme X.Y.Z : il n'est pas incrémentable"
    _clia_detail "corrigez le champ « version » de $def, puis publiez"
    return 1
  fi

  [[ "$ancien" == *-* ]] && {
    _clia_msg "le tag de pré-publication de « $ancien » est retiré"
    _clia_detail "une version publiée n'est pas une pré-publication"
  }

  _clia_v_publier "$DEPOT" "$def" "$nouveau" "release $nom $nouveau" || return 1

  printf '%s\n' "$nouveau"
  _clia_msg "$nom : $ancien -> $nouveau, publié par $(git_ rev-parse --short HEAD)"
  _clia_detail "aucune étiquette n'est posée, et rien n'est poussé"
  return 0
}

# --------------------------------------------------------------------------
# new
# --------------------------------------------------------------------------

creer() {
  local prefixe="$1" nom="$2" description="${3:-}" dir def titre n d autre

  if [[ ! "$prefixe" =~ ^[A-Z]{2,5}$ ]]; then
    _clia_msg "préfixe invalide : $prefixe"
    _clia_detail "deux à cinq majuscules, sans chiffre ni accent — ANL, RES, SES"
    return 2
  fi
  if [[ ! "$nom" =~ ^[a-z0-9][a-z0-9-]*$ ]]; then
    _clia_msg "nom invalide : $nom"
    _clia_detail "minuscules, chiffres et tirets, sans accent"
    return 2
  fi

  dir="$RESSOURCES/$nom"
  if [[ -e "$dir" ]]; then
    _clia_msg "l'emplacement est déjà occupé : _ressources/$nom"
    _clia_detail "rien n'a été créé"
    return 1
  fi

  # Deux ressources au même préfixe rendraient ambiguës les adresses de leurs
  # instances dans tout le dépôt.
  while IFS=$'\t' read -r n d; do
    [[ -n "$n" ]] || continue
    autre=$(_clia_champ_yaml "$DEPOT/$d" prefixe || printf '')
    if [[ "$autre" == "$prefixe" ]]; then
      _clia_msg "le préfixe $prefixe est déjà celui de $n"
      _clia_detail "rien n'a été créé"
      return 1
    fi
  done < <(inventaire)

  # La description est écrite sur une ligne, entre guillemets. Une guillemet
  # dans le texte fermerait la valeur : elle est remplacée, et le dire vaut
  # mieux que rendre un fichier que rien ne peut relire.
  if [[ "$description" == *'"'* ]]; then
    description="${description//\"/\'}"
    _clia_msg "les guillemets de la description ont été remplacés par des apostrophes"
  fi
  [[ -n "$description" ]] || description='À rédiger.'

  titre="${nom^}"
  def="$dir/$nom.yaml"
  mkdir -p "$dir"
  cat > "$def" <<FIN
# La définition de la ressource « $nom ».
#
# Elle porte ce que les commandes de clia savent tenir aujourd'hui, et rien
# de plus : un champ qu'aucune commande n'emploie serait une promesse que le
# système ne tient pas.
#
# Ce qui se range à côté de ce fichier, quand la ressource en a :
#
#   primitives/  ce à partir de quoi ses livrables sont produits
#   skills/      les procédures qu'elle fournit
#   _scripts/    les automatismes qu'elle fournit — un <nom>.sh y devient
#                une commande de clia

nom: $nom
titre: $titre
prefixe: $prefixe
version: 0.1.0

description: "$description"
FIN

  _clia_msg "créée : _ressources/$nom"
  _clia_detail "définition : $(def_de "$nom")"
  _clia_detail "préfixe $prefixe, version 0.1.0"
  _clia_detail ''
  _clia_detail "rien n'est commité : créer n'est pas publier"
  _clia_detail "commitez, puis : clia res release patch $nom"
  return 0
}

# --------------------------------------------------------------------------
# Dispatch
# --------------------------------------------------------------------------

for _arg in "$@"; do
  [[ "$_arg" == '--man' ]] || continue
  manuel
  exit 0
done

VERBE="${1:-}"
[[ $# -gt 0 ]] && shift

case "$VERBE" in
  '')
    _clia_msg "clia res attend un verbe"
    _clia_detail "l'usage : clia res --help"
    exit 2 ;;

  ls)
    [[ $# -eq 0 ]] || { _clia_msg "ls ne prend pas d'argument : $*"; exit 2; }
    lister ;;

  new)
    (( $# >= 2 )) || {
      _clia_msg "new attend un préfixe et un nom"
      _clia_detail "l'usage : clia res new PREFIXE NOM [DESCRIPTION]"
      exit 2
    }
    (( $# <= 3 )) || { _clia_msg "argument en trop : ${4:-}"; exit 2; }
    creer "$@" ;;

  version)
    VRAI=0
    CIBLE=''
    for arg in "$@"; do
      case "$arg" in
        --true) VRAI=1 ;;
        -*)     _clia_msg "option inconnue pour version : $arg"; exit 2 ;;
        *)      if [[ -n "$CIBLE" ]]; then
                  _clia_msg "version n'attend qu'une ressource : $CIBLE et $arg"
                  exit 2
                fi
                CIBLE="$arg" ;;
      esac
    done
    [[ -n "$CIBLE" ]] || {
      _clia_msg "version attend une ressource"
      _clia_detail "l'usage : clia res version [--true] RESSOURCE"
      exit 2
    }
    NOM=$(resoudre "$CIBLE") || exit 1
    if (( VRAI )); then version_exacte "$NOM"; else alias_de_version "$NOM"; fi ;;

  release)
    (( $# >= 1 )) || {
      _clia_msg "release attend un niveau et une ressource"
      _clia_detail "les niveaux sont major, minor et patch"
      exit 2
    }
    (( $# == 2 )) || {
      _clia_msg "release attend un niveau et une ressource"
      _clia_detail "l'usage : clia res release major|minor|patch RESSOURCE"
      exit 2
    }
    # Les niveaux sont écrits en majuscules dans SES-001 et en minuscules
    # dans les autres commandes : les deux répondent.
    NIVEAU=$(printf '%s' "$1" | tr '[:upper:]' '[:lower:]')
    NOM=$(resoudre "$2") || exit 1
    publier "$NIVEAU" "$NOM" ;;

  *)
    _clia_msg "verbe inconnu : $VERBE"
    _clia_detail "l'usage : clia res --help"
    exit 2 ;;
esac
