#!/usr/bin/env bash
# Description: Les ressources du dépôt — new, ls, version, release.
# Périmètre: dépôt
# Signature: res new PREFIXE NOM [DESCRIPTION]
# Signature: res ls
# Signature: res version [--true] RESSOURCE
# Signature: res release major|minor|patch RESSOURCE
# Option: res version --true
#
# Implémente SES-001 tâches 5 et 9.
#
# Pourquoi cette commande n'est pas dans le noyau
# -----------------------------------------------
#
# SES-001 tâche 9 pose que toutes les ressources exposent une commande. La
# ressource « ressource » est celle qui dit ce qu'est une ressource ; la
# commande qui les crée, les liste et les versionne est donc la sienne, et
# elle vit avec elle.
#
# Le point d'entrée trouve les commandes de _scripts/lib/cmd/ et celles que
# les ressources déposent sous _ressources/<nom>/_scripts/. Rien n'a eu à
# changer au noyau pour que « res » continue de répondre : c'est ce que ce
# déplacement éprouve.
#
# Le noyau garde ce dont aucune ressource ne répond — version, check, init,
# setup. Ce qui appartient à une ressource part avec elle.
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
# Sauf le script : « clia res new » le pose en même temps que la définition,
# pour que l'énoncé « toutes les ressources exposent une commande » soit tenu
# à la création plutôt que rappelé après coup. Il est posé, pas rédigé — ce
# que la ressource sait faire appartient à qui la crée.
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
# shellcheck source=../../../_scripts/lib/commun.sh
. "$CLIA_SOURCE_DIR/_scripts/lib/commun.sh"
# shellcheck source=../../../_scripts/lib/version.sh
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

Toute ressource expose une commande, nommée par son préfixe en
minuscules : la ressource ressource porte « clia res », harness-ia
porte « clia hrn ». Elle est posée à la création, à partir d'un
gabarit ; ce qu'elle sait faire appartient à qui la crée.

SOUS-COMMANDES
new PREFIXE NOM [DESCRIPTION]
       Crée la ressource : sa définition, en version 0.1.0, et sa
       commande, dans _ressources/NOM/_scripts/. Les deux sortent
       des gabarits de la ressource ressource.

       La commande porte le préfixe en minuscules. Un préfixe dont
       la commande est déjà celle du noyau est accepté, et signalé :
       le noyau l'emporte, et le script ne serait pas atteint.

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

_ressources/<nom>/_scripts/<commande>.sh
       Sa commande, posée à la création. Elle vous appartient :
       clia l'a posée, il ne la régénérera pas. Découverte comme
       celles du noyau — voir clia(1).

_ressources/<nom>/primitives/, skills/
       Le reste de ce que la ressource porte. Admis, jamais exigés.

_ressources/ressource/gabarits/
       Ce dont une ressource neuve est faite : definition.yaml et
       commande.sh. Un {{champ}} y est un trou, remplacé au rendu.

EXEMPLES
Créer une ressource :

       $ clia res new ANL analyse "Ce qu'un examen du réel établit"
       créée : _ressources/analyse

Puis appeler la commande qu'elle expose :

       $ clia anl ls

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

# Les gabarits de la ressource « ressource » : ce dont une ressource neuve est
# faite. Ils vivent dans le dépôt source, avec la ressource qui les porte, et
# non dans le dépôt de travail — une ressource créée ailleurs sort du même
# moule que celles d'ici.
GABARITS="$CLIA_SOURCE_DIR/_ressources/ressource/gabarits"

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

# La commande d'une ressource est son préfixe en minuscules : RES donne
# « clia res », HRN donne « clia hrn ». Le préfixe est déjà ce qui adresse la
# ressource, et lui donner une deuxième adresse en ferait deux noms à tenir.
commande_de() { printf '%s\n' "$(printf '%s' "$1" | tr '[:upper:]' '[:lower:]')"; }

script_de()   { printf '_ressources/%s/_scripts/%s.sh\n' "$1" "$2"; }
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

  # SES-001 tâche 17 : chaque nouvelle version doit fournir son script de
  # migration. clia le constate, et ne refuse pas : une version peut ne rien
  # changer aux instances, et l'auteur est le seul à le savoir. Mais il doit
  # le savoir en publiant, non le découvrir à la première migration.
  if [[ ! -f "$DEPOT/_ressources/$nom/migrations/$ancien-$nouveau.sh" ]]; then
    _clia_msg "aucun script de migration pour $ancien -> $nouveau"
    _clia_detail "s'il y a des instances à faire évoluer, écrivez-le :"
    _clia_detail "_ressources/$nom/migrations/$ancien-$nouveau.sh"
    _clia_detail "sans lui, « clia <ressource> migrate » refusera ce saut"
  fi

  _clia_v_publier "$DEPOT" "$def" "$nouveau" "release $nom $nouveau" || return 1

  printf '%s\n' "$nouveau"
  _clia_msg "$nom : $ancien -> $nouveau, publié par $(git_ rev-parse --short HEAD)"
  _clia_detail "aucune étiquette n'est posée, et rien n'est poussé"
  return 0
}

# --------------------------------------------------------------------------
# new
# --------------------------------------------------------------------------
#
# Ce qu'une ressource neuve reçoit est dans gabarits/, pas ici. Un texte
# écrit à même le code se relit mal et se compare mal : le gabarit se lit tel
# qu'il sera rendu, et le banc peut le confronter à ce qui a été écrit.
#
# La langue du gabarit tient en une forme : {{nom}}, remplacé par la valeur
# du champ. Le rendu lui-même est dans _scripts/lib/commun.sh — la ressource
# session s'en sert aussi, et une deuxième écriture du même awk finirait par
# diverger de la première.

creer() {
  local prefixe="$1" nom="$2" description="${3:-}"
  local dir def script commande val n d autre

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

  commande=$(commande_de "$prefixe")

  val=$(mktemp)
  # shellcheck disable=SC2064
  trap "rm -f '$val'" RETURN
  { printf 'nom\t%s\n'         "$nom"
    printf 'titre\t%s\n'       "${nom^}"
    printf 'prefixe\t%s\n'     "$prefixe"
    printf 'version\t%s\n'     '0.1.0'
    printf 'description\t%s\n' "$description"
    printf 'commande\t%s\n'    "$commande"
  } > "$val"

  def="$dir/$nom.yaml"
  script="$dir/_scripts/$commande.sh"
  mkdir -p "$dir/_scripts"

  # Les deux fichiers sont rendus avant qu'aucun ne soit posé : une ressource
  # à qui il manquerait son script obligerait à savoir laquelle des deux
  # écritures a échoué, et l'emplacement resterait occupé.
  local def_rendu script_rendu
  def_rendu=$(_clia_rendre "$GABARITS/definition.yaml" "$val") \
    && script_rendu=$(_clia_rendre "$GABARITS/commande.sh" "$val") \
    || {
      rm -rf "$dir"
      _clia_msg "rien n'a été créé"
      _clia_detail "l'installation de clia est-elle complète ?"
      return 1
    }

  printf '%s\n' "$def_rendu"    > "$def"
  printf '%s\n' "$script_rendu" > "$script"
  chmod +x "$script"

  _clia_msg "créée : _ressources/$nom"
  _clia_detail "définition : $(def_de "$nom")"
  _clia_detail "commande   : $(script_de "$nom" "$commande") — clia $commande"
  _clia_detail "préfixe $prefixe, version 0.1.0"

  # Le noyau l'emporte en cas d'homonymie : le script serait déposé, et jamais
  # atteint. Le dire ici vaut mieux que le laisser découvrir à l'usage.
  if [[ -f "$CLIA_SOURCE_DIR/_scripts/lib/cmd/$commande.sh" ]]; then
    _clia_detail ''
    _clia_msg "« clia $commande » est déjà une commande du noyau, qui l'emporte"
    _clia_detail "le script est posé, et il ne sera pas atteint"
    _clia_detail "choisissez un autre préfixe si la commande doit répondre"
  fi

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
