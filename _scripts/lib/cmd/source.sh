#!/usr/bin/env bash
# Description: Les sources de données — add, ls.
# Périmètre: dépôt
# Signature: source add URI [NOM]
# Signature: source ls
#
# Implémente SES-001 tâche 12.
#
# La tâche 12 partage en deux ce que « clia src » tenait ensemble :
#
#   extension  un dépôt clia qui porte des ressources — clia-extension(1)
#   source     tout le reste : un dépôt clia sans ressource, ou un dépôt qui
#              n'est pas un dépôt clia
#
# Les deux se déclarent au même endroit — le bloc « sources: » de la carte —
# parce que c'est le même geste : dire d'où quelque chose vient. Ce qui les
# sépare n'est pas déclaré, il est constaté : une source qui porte des
# ressources est une extension, et le devient sans qu'on la redéclare.
#
# Ce que clia tient d'une source de données, et ce qu'il n'en tient pas
# ---------------------------------------------------------------------
#
# Il en tient la déclaration : d'où viennent les données que ce dépôt emploie,
# inscrit dans sa carte, versionné avec lui. C'est ce qui manque à un dépôt
# dont les entrées viennent d'ailleurs sans que rien ne dise d'où.
#
# Aucune commande n'en tire encore de contenu. Le dire vaut mieux que le
# laisser découvrir : ce qui est déclaré ici est une provenance, pas un accès.

set -euo pipefail

_CLIA_NOM='clia'
# shellcheck source=../commun.sh
. "$CLIA_SOURCE_DIR/_scripts/lib/commun.sh"

DEPOT="${CLIA_WORK_DIR:-}"

# --------------------------------------------------------------------------

manuel() {
  cat <<'EOF' | _clia_man clia-source 1 "Manuel de l'utilisateur clia"
NOM
clia-source - déclarer d'où viennent les données d'un dépôt

SYNOPSIS
clia source add URI [NOM]
clia source ls

DESCRIPTION
Une source est un dépôt d'où viennent des ressources ou des
données. La carte du dépôt les déclare toutes au même endroit, et
rien d'autre ne les déclare : clia ne fouille pas le disque.

Ce qui sépare une source d'une extension n'est pas déclaré, il est
constaté. Une source qui est un dépôt clia et qui porte des
ressources est une extension, et clia-extension(1) en rend compte.
Tout le reste est une source de données, et c'est ce que cette
commande montre.

Une source qui reçoit des ressources devient une extension sans
qu'on la redéclare : c'est la même entrée dans la même carte.

clia tient la déclaration : d'où viennent les données que ce dépôt
emploie, inscrit dans sa carte et versionné avec lui. Aucune
commande n'en tire encore de contenu. La provenance est déclarée ;
l'accès ne l'est pas.

SOUS-COMMANDES
add URI [NOM]
       Déclare une source. URI est le chemin d'un répertoire —
       relatif à la racine du dépôt, ou absolu — ou l'URI d'un
       dépôt distant.

       NOM est le provider sous lequel la source est déclarée. Il
       est lu dans la carte de la source quand elle en porte une ;
       sinon il doit être donné. clia ne le devine pas :
       CONSTITUTION.md R2 lui interdit de nommer une provenance à
       la place de l'humain.

       Une source qui mène au même endroit qu'une source déjà
       déclarée n'est pas redéclarée.

       Rien n'est commité.

ls
       Les sources déclarées qui ne sont pas des extensions, et ce
       qu'elles sont :

       dépôt clia    dépôt clia, sans ressource
       dépôt         présent, sans carte clia
       absente       l'uri locale ne mène à aucun répertoire
       non clonée    déclarée en git, et absente du cache
       type inconnu  un type que clia ne sait pas atteindre

SORTIE
La sortie standard porte une ligne d'en-tête et une ligne par
source. Tout le reste va sur la sortie d'erreur.

CODE DE RETOUR
0
       La demande est satisfaite, même si le dépôt ne déclare
       aucune source.

1
       Refus : provider indéterminable, ou carte absente.

2
       Demande mal formée.

FICHIERS
clia.yaml, .clia.yaml, .dev/clia.yaml
       La carte. Son bloc « sources: » porte les déclarations.

EXEMPLES
Déclarer un dépôt de données voisin :

       $ clia source add ../donnees-publiques donnees.exemple.org

Voir ce qui est déclaré :

       $ clia source ls
       SOURCE                 ETAT   URI
       donnees.exemple.org    dépôt  ../donnees-publiques

VOIR AUSSI
clia(1), clia-extension(1), clia-check(1)
EOF
}

# --------------------------------------------------------------------------

carte_du_depot() {
  local carte
  if ! carte=$(_clia_carte "$DEPOT"); then
    _clia_msg "ce dépôt ne porte pas de carte clia"
    _clia_detail "clia init la pose ; clia check dit ce qui manque"
    return 1
  fi
  printf '%s\n' "$carte"
}

# La source déjà déclarée qui mène au même répertoire, ou rien.
deja_declaree() {
  local racine="$1" provider type uri autre
  while IFS="$_CLIA_SEP" read -r provider type uri; do
    [[ -n "$provider" ]] || continue
    autre=$(_clia_source_racine "$DEPOT" "$type" "$uri" "$provider" 2>/dev/null) || continue
    [[ "$autre" == "$racine" ]] && { printf '%s\n' "$provider"; return 0; }
  done < <(_clia_sources "$DEPOT")
  return 1
}

ajouter() {
  local uri="$1" nom="${2:-}" carte chemin racine='' ns='' type deja

  carte=$(carte_du_depot) || return 1

  case "$uri" in
    /*) chemin="$uri" ;;
    *)  chemin="$DEPOT/$uri" ;;
  esac

  if [[ -d "$chemin" ]]; then
    racine=$(cd -P "$chemin" && pwd)
    type='local'
    if _clia_carte_relative "$racine" >/dev/null; then
      ns=$(_clia_champ_yaml "$(_clia_carte "$racine")" namespace || printf '')
      [[ "$ns" == *'<'* ]] && ns=''
    fi
  else
    type='git'
  fi

  # Le provider est lu quand la source le déclare, et demandé sinon.
  # CONSTITUTION.md R2 : nommer une provenance appartient à l'humain, et un
  # automatisme qui devrait deviner refuse.
  if [[ -n "$nom" ]]; then
    ns="$nom"
  elif [[ -z "$ns" ]]; then
    _clia_msg "cette source ne déclare pas de provenance : $uri"
    if [[ -n "$racine" ]]; then
      _clia_detail "elle ne porte pas de carte clia déclarant un namespace"
    else
      _clia_detail "une source distante n'est pas lue avant d'être déclarée"
    fi
    _clia_detail "nommez-la : clia source add $uri NOM"
    _clia_detail "rien n'a été déclaré"
    return 1
  fi

  if [[ -n "$racine" ]] && deja=$(deja_declaree "$racine"); then
    _clia_msg "cette source est déjà déclarée : $deja"
    _clia_detail "elle mène au même endroit ; rien n'a été modifié"
    return 0
  fi

  _clia_carte_inserer "$carte" sources \
    "  - provider: $ns" \
    "    type: $type" \
    "    uri: $uri"

  _clia_msg "source déclarée : $ns"
  _clia_detail "dans ${carte#"$DEPOT"/}, en source $type"
  _clia_detail "ce que le dépôt déclare : clia source ls"
  if [[ -n "$racine" && -n "$(_clia_ressources_de "$racine")" ]]; then
    _clia_detail ''
    _clia_msg "cette source porte des ressources : c'est une extension"
    _clia_detail "pour les reprendre : clia extension install $ns"
  fi
  _clia_detail "rien n'est commité"
  return 0
}

lister() {
  local provider type uri nature lignes='' extensions=0

  if [[ -z "$(_clia_sources "$DEPOT")" ]]; then
    _clia_msg "ce dépôt ne déclare aucune source"
    _clia_detail "pour en ajouter une : clia source add URI [NOM]"
    return 0
  fi

  while IFS="$_CLIA_SEP" read -r provider type uri; do
    [[ -n "$provider" ]] || continue
    nature=$(_clia_source_nature "$DEPOT" "$provider" "$type" "$uri")
    if [[ "$nature" == 'extension' ]]; then
      extensions=$((extensions + 1))
      continue
    fi
    lignes+=$(printf '%s\t%s\t%s' "$provider" "$nature" "${uri:-—}")$'\n'
  done < <(_clia_sources "$DEPOT")

  if [[ -z "$lignes" ]]; then
    _clia_msg "toutes les sources de ce dépôt sont des extensions"
    _clia_detail "elles se lisent avec : clia extension ls"
    return 0
  fi

  { printf 'SOURCE\tETAT\tURI\n'
    printf '%s' "$lignes"
  } | column -t -s $'\t'

  (( extensions )) && {
    _clia_msg "$extensions source(s) sont des extensions, et ne figurent pas ici"
    _clia_detail "elles se lisent avec : clia extension ls"
  }
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
    _clia_msg "clia source attend un verbe"
    _clia_detail "l'usage : clia source --help"
    exit 2 ;;

  add)
    (( $# >= 1 )) || {
      _clia_msg "add attend une URI"
      _clia_detail "l'usage : clia source add URI [NOM]"
      exit 2
    }
    (( $# <= 2 )) || { _clia_msg "argument en trop : ${3:-}"; exit 2; }
    ajouter "$@" ;;

  ls)
    (( $# == 0 )) || { _clia_msg "ls ne prend pas d'argument : $*"; exit 2; }
    lister ;;

  *)
    _clia_msg "verbe inconnu : $VERBE"
    _clia_detail "l'usage : clia source --help"
    exit 2 ;;
esac
