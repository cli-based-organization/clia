#!/usr/bin/env bash
# Description: Ce qui règle clia — ses zones, ses politiques, ce qu'il pose.
# Périmètre: dépôt
# Signature: config ls
# Option: config ls --explain
#
# Implémente SES-001 tâche 21.
#
# Ce que cette commande rend, et pourquoi elle existe
# ---------------------------------------------------
#
# clia se règle par l'environnement, et par rien d'autre : aucun fichier de
# configuration ne s'ajoute à la carte du dépôt. C'est commode pour un
# automatisme, et opaque pour qui arrive — une variable qu'on ne connaît pas
# est une variable qu'on ne peut pas régler.
#
# Cette commande est la réponse à cette opacité. Elle ne rend pas une liste
# écrite : elle rend ce que le système tient réellement, et une variable ne
# peut donc ni y manquer ni y figurer sans exister.
#
# Trois natures, et elles ne se règlent pas de la même façon
# ----------------------------------------------------------
#
#   zone       où une ressource écrit. Déclarée par la ressource qui écrit
#              dedans — SES-001 tâche 21 — et déplaçable par sa variable.
#
#   politique  une décision du système, pas un emplacement. Elle ne change
#              pas ce que clia sait faire : elle change ce qu'il conclut.
#
#   posée      clia l'écrit lui-même. La régler n'a aucun effet : le point
#              d'entrée la réécrit avant que la commande la lise. Elle est
#              rendue parce qu'une variable qu'on croit pouvoir changer et
#              qui sera réécrite est un piège.
#
# Constater n'est pas régler. Cette commande n'écrit rien, et il n'y a rien
# à écrire : une valeur se pose dans l'environnement, où elle est visible.

set -euo pipefail

_CLIA_NOM='clia'
# shellcheck source=../commun.sh
. "$CLIA_SOURCE_DIR/_scripts/lib/commun.sh"

DEPOT="${CLIA_WORK_DIR:-}"

EXPLIQUER=0

# --------------------------------------------------------------------------

manuel() {
  cat <<'FIN' | _clia_man clia-config 1 "Manuel de l'utilisateur clia"
NOM
clia-config - ce qui règle clia, et d'où chaque valeur vient

SYNOPSIS
clia config ls
clia config ls --explain

DESCRIPTION
clia se règle par l'environnement. Aucun fichier de configuration
ne s'y ajoute : la carte du dépôt dit ce que le dépôt est, non
comment l'outil se comporte.

Cette commande rend ce que le système tient réellement — les zones
que les ressources déclarent, les politiques du noyau, et ce que
clia pose lui-même. Elle ne lit aucune liste écrite : une variable
ne peut donc ni y manquer, ni y figurer sans exister.

Elle n'écrit rien. Une valeur se règle en la posant dans
l'environnement, où elle reste visible.

LES NATURES
zone
       Un endroit où une ressource écrit. La ressource la déclare
       dans sa définition, et contrôle ainsi l'endroit où elle
       génère :

              zones:
                - nom: harnais
                  defaut: .dev/harnais-ia
                  description: "..."

       La variable se déduit du nom : CLIA_ZONE_, puis le nom en
       majuscules, les tirets changés en soulignés. Elle ne se
       déclare pas — deux endroits à tenir d'accord finissent par
       se contredire.

       Une zone n'est lue que des ressources installées. Une
       ressource qu'un dépôt écrit sans l'avoir installée ne
       déclare rien : voir clia-res(1) et SPC-001-ontologie.

politique
       Une décision du système, non un emplacement. Elle ne change
       pas ce que clia sait faire ; elle change ce qu'il conclut.

posée
       clia l'écrit lui-même, avant que la commande la lise. La
       régler n'a aucun effet.

AMORCE
Deux zones ne viennent d'aucune ressource, et une seule raison
l'explique : pour lire la déclaration d'une ressource, il faut
d'abord la trouver, et pour la trouver il faut connaître la zone
livrée.

CLIA_ZONE_RESSOURCE_LIVREE appartient donc au noyau, et une
ressource qui la déclarerait ne serait pas suivie.
CLIA_ZONE_RESSOURCE lui appartient aussi, mais en dernier recours
seulement : la ressource « ressource » la déclare, et la colonne
FOURNIE PAR dit laquelle des deux répond.

OPTIONS
--explain
       Ajouter, sous chaque variable, ce qu'elle règle.

SORTIE
Une ligne par variable : sa nature, son nom, d'où sa valeur vient,
qui la déclare, et sa valeur.

La colonne SOURCE vaut « environnement » quand la variable est
posée dans l'environnement — c'est elle qui l'emporte —, « défaut »
quand personne ne l'a posée, et « clia » quand la valeur est écrite
par clia lui-même.

La colonne FOURNIE PAR nomme la ressource qui déclare la zone, ou
« noyau » quand elle vient du noyau.

CODE DE RETOUR
0
       La liste a été rendue.

2
       Demande mal formée.

EXEMPLES
Ce qui règle le dépôt courant :

       $ clia config ls
       NATURE     VARIABLE             SOURCE   FOURNIE PAR  VALEUR
       zone       CLIA_ZONE_RESSOURCE  défaut   ressource    .dev/ressources

Ce que chaque variable règle :

       $ clia config ls --explain

Déplacer une zone le temps d'une commande :

       $ CLIA_ZONE_RESSOURCE=doc/ressources clia res ls

VOIR AUSSI
clia(1), clia-res(1), clia-check(1), clia-setup(1)
FIN
}

# --------------------------------------------------------------------------
# Le rendu
# --------------------------------------------------------------------------
#
# Deux formes, et l'option les sépare.
#
# Sans --explain, une table : une ligne par variable, alignée par column,
# comme les autres inventaires de clia. Elle se lit d'un coup d'œil, et une
# autre commande peut la découper.
#
# Avec --explain, un bloc par variable. Ce n'est pas la même table plus des
# phrases : une explication indentée sous une ligne alignée sur des données
# ferait danser l'indentation d'un rendu à l'autre. Un bloc porte ses propres
# étiquettes, et ne dépend de la largeur de rien.

LIGNES=''

# ligne <nature> <variable> <source> <fournie par> <valeur> <description>
ligne() {
  local nature="$1" variable="$2" source="$3" fournie="$4" valeur="${5:-—}" desc="${6:-}"
  if (( EXPLIQUER )); then
    printf '%s  (%s)\n' "$variable" "$nature"
    printf '       valeur   %s\n' "$valeur"
    if [[ "$source" == 'clia' ]]; then
      printf '       source   %s\n' "posée par clia — la régler n'a aucun effet"
    else
      printf '       source   %s, fournie par %s\n' "$source" "$fournie"
    fi
    printf '       règle    %s\n\n' "${desc:-(sans description)}"
    return 0
  fi
  LIGNES+=$(printf '%s\t%s\t%s\t%s\t%s' \
    "$nature" "$variable" "$source" "$fournie" "$valeur")$'\n'
}

rendre() {
  (( EXPLIQUER )) && return 0
  { printf 'NATURE\tVARIABLE\tSOURCE\tFOURNIE PAR\tVALEUR\n'
    printf '%s' "$LIGNES"
  } | column -t -s $'\t'
}

# La source d'une valeur : l'environnement l'emporte, sinon le défaut.
source_de() {
  local variable="$1"
  if [[ -n "${!variable:-}" ]]; then printf 'environnement\n'; else printf 'défaut\n'; fi
}

# --------------------------------------------------------------------------
# Les zones
# --------------------------------------------------------------------------
#
# Celles que les ressources installées déclarent, puis celles que le noyau
# tient et que personne n'a déclarées. L'ordre place l'amorce en dernier :
# ce qui vient d'une ressource est ce qu'on est venu lire.

zones() {
  local nom defaut fournie desc variable declarees=''

  while IFS="$_CLIA_SEP" read -r nom defaut fournie desc; do
    [[ -n "$nom" ]] || continue
    declarees="$declarees $nom"
    variable=$(_clia_zone_variable "$nom")
    ligne 'zone' "$variable" "$(source_de "$variable")" "$fournie" \
      "$(_clia_zone "$nom" "$DEPOT")" "$desc"
  done < <(_clia_zones_declarees "$DEPOT" | LC_ALL=C sort -t"$_CLIA_SEP" -k1,1)

  # L'amorce, et seulement ce qu'aucune ressource n'a déclaré.
  local a
  for a in 'ressource-livree' 'ressource'; do
    [[ " $declarees " == *" $a "* ]] && continue
    variable=$(_clia_zone_variable "$a")
    case "$a" in
      ressource-livree)
        desc="où le dépôt tient les ressources qu'il a installées — la seule zone où le CLI cherche" ;;
      ressource)
        desc="ce que le dépôt écrit d'une ressource — aucune ressource installée ne la déclare ici" ;;
    esac
    ligne 'zone' "$variable" "$(source_de "$variable")" 'noyau' \
      "$(_clia_zone "$a" "$DEPOT")" "$desc"
  done
}

# --------------------------------------------------------------------------
# Les politiques, et ce que clia pose
# --------------------------------------------------------------------------

politiques() {
  local variable defaut desc
  while IFS="$_CLIA_SEP" read -r variable defaut desc; do
    [[ -n "$variable" ]] || continue
    ligne 'politique' "$variable" "$(source_de "$variable")" 'noyau' \
      "${!variable:-$defaut}" "$desc"
  done < <(_clia_politiques_noyau)
}

posees() {
  local variable desc
  while IFS="$_CLIA_SEP" read -r variable desc; do
    [[ -n "$variable" ]] || continue
    ligne 'posée' "$variable" 'clia' 'noyau' "${!variable:-}" "$desc"
  done < <(_clia_variables_posees)
}

lister() {
  zones
  politiques
  posees
  rendre
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

for arg in "$@"; do
  case "$arg" in
    --explain) EXPLIQUER=1 ;;
    *) _clia_msg "argument inattendu : $arg"
       _clia_detail "l'usage : clia config --help"
       exit 2 ;;
  esac
done

case "$VERBE" in
  ls) lister ;;
  '')
    _clia_msg 'clia config attend un verbe'
    _clia_detail "ce qui règle clia : clia config ls"
    exit 2 ;;
  *)
    _clia_msg "verbe inconnu : $VERBE"
    _clia_detail "l'usage : clia config --help"
    exit 2 ;;
esac
