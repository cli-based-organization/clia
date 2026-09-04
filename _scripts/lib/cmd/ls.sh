#!/usr/bin/env bash
# Description: Les ressources installées dans ce dépôt.
# Périmètre: dépôt
# Signature: ls
#
# Implémente SES-002 tâche 1.
#
# Ce que cette commande répond, et à qui
# --------------------------------------
#
# « De quoi ce dépôt dispose-t-il ? » C'est la question la plus fréquente
# d'un dépôt ordinaire — celui qui emploie clia sans en écrire les
# ressources — et elle méritait le premier niveau.
#
# « clia res ls » répond à une autre : ce que le dépôt écrit, et ce qu'il a
# installé. C'est le point de vue de qui développe des ressources. Les deux
# existent parce que ce ne sont pas les mêmes lecteurs.
#
# Ce que chaque colonne dit
# -------------------------
#
#   SOURCE   le namespace de qui publie la ressource — le sien quand le dépôt
#            la publie lui-même, celui de l'extension sinon
#
#   VERSION  celle qui est posée ici, et rien d'autre. Une ressource
#            installée est figée — SPC-001 §1.9
#
#   ETAT     « à jour » ou « en retard » par rapport à ce que sa source
#            déclare aujourd'hui. « brisée » quand ce n'est ni l'un ni
#            l'autre — SES-002 tâche 2
#
#   ACTIF    sa commande est-elle réellement servie par elle. Rien n'est
#            déclaré : l'état se lit là où le point d'entrée regarde, et il
#            ne peut donc pas mentir
#
# Cette commande n'écrit rien.

set -euo pipefail

_CLIA_NOM='clia'
# shellcheck source=../commun.sh
. "$CLIA_SOURCE_DIR/_scripts/lib/commun.sh"
# shellcheck source=../texte.sh
. "$CLIA_SOURCE_DIR/_scripts/lib/texte.sh"
# shellcheck source=../identite.sh
. "$CLIA_SOURCE_DIR/_scripts/lib/identite.sh"
# shellcheck source=../version.sh
. "$CLIA_SOURCE_DIR/_scripts/lib/version.sh"
# shellcheck source=../maj.sh
. "$CLIA_SOURCE_DIR/_scripts/lib/maj.sh"
# shellcheck source=../mise-a-jour.sh
. "$CLIA_SOURCE_DIR/_scripts/lib/mise-a-jour.sh"
# shellcheck source=../parc.sh
. "$CLIA_SOURCE_DIR/_scripts/lib/parc.sh"

DEPOT="${CLIA_WORK_DIR:-}"

# --------------------------------------------------------------------------

manuel() {
  cat <<'FIN' | _clia_man clia-ls 1 "Manuel de l'utilisateur clia"
NOM
clia-ls - les ressources installées dans un dépôt

SYNOPSIS
clia ls

DESCRIPTION
Ce dont ce dépôt dispose : les ressources qu'il a installées, d'où
elles viennent, où elles en sont, et si elles répondent.

C'est le point de vue de qui emploie clia. Celui de qui écrit des
ressources est ailleurs : clia res ls dit ce que le dépôt écrit
autant que ce qu'il a installé — voir clia-res(1).

COLONNES
PREFIX
       Le préfixe de la ressource. C'est aussi le nom de la
       commande qu'elle porte, en minuscules.

NAME
       Son nom, qui est aussi celui de son répertoire et de sa
       définition.

SOURCE
       Le namespace de qui la publie : celui du dépôt lui-même
       quand il la publie, celui de l'extension d'où elle vient
       sinon. Une ressource dont la carte ne dit rien n'a pas de
       source, et la colonne le dit.

VERSION
       Celle qui est posée ici. Une ressource installée est figée :
       elle ne suit pas ce qui bouge ailleurs, et seule une mise à
       jour explicite la déplace.

STATE
       à jour     la version posée est la dernière que sa source
                  déclare
       en retard  sa source en déclare une plus récente
       brisée     tout le reste

       Deux états sont sains, et un seul ne l'est pas. Une
       ressource brisée est une ressource dont clia ne peut dire ni
       d'où elle vient ni où elle en est : le dépôt qui la publie
       est introuvable, il ne déclare aucune version d'elle, sa
       version ne se lit pas, ou la copie posée dépasse ce que sa
       source déclare.

       Ce dernier cas n'est pas une avance : c'est une copie dont
       l'origine ne se retrouve pas.

ACTIVE
       actif      sa commande est servie par elle
       inactif    elle est brisée, elle ne porte pas de script, ou
                  son nom de commande est pris par le noyau ou par
                  une autre ressource

       Une ressource brisée n'est jamais rendue active : clia ne
       peut pas dire d'où elle vient, et s'en remettre à elle
       reviendrait à s'en remettre à ce qu'on ne sait pas.

       Rien n'est déclaré : l'état se lit là où le point d'entrée
       cherche ses commandes.

SORTIE
Une ligne par ressource installée, triée par nom. Rien n'est écrit.

CODE DE RETOUR
0
       La liste a été rendue, même si elle est vide.

2
       Demande mal formée.

EXEMPLES
Ce dont ce dépôt dispose :

       $ clia ls
       PREFIX  NAME     SOURCE                      VERSION  STATE   ACTIVE
       SES     session  session.clia.noumanity.com  0.1.0    à jour  actif

Ce qui demande une mise à jour :

       $ clia update

VOIR AUSSI
clia(1), clia-update(1), clia-upgrade(1), clia-res(1),
clia-extension(1)
FIN
}

# --------------------------------------------------------------------------

lister() {
  local prefixe nom source version etat actif raison lignes='' inactives=0

  while IFS="$_CLIA_SEP" read -r prefixe nom source version etat _ actif raison; do
    [[ -n "$nom" ]] || continue
    [[ "$actif" == 'inactif' ]] && inactives=$((inactives + 1))
    lignes+=$(printf '%s\t%s\t%s\t%s\t%s\t%s' \
      "$prefixe" "$nom" "$source" "$version" "$etat" "$actif")$'\n'
  done < <(_clia_pc_parc "$DEPOT")

  if [[ -z "$lignes" ]]; then
    _clia_msg "ce dépôt n'a installé aucune ressource"
    _clia_detail "pour en reprendre d'une extension : clia extension ls"
    _clia_detail "pour en écrire une : clia res new PREFIXE NOM"
    return 0
  fi

  { printf 'PREFIX\tNAME\tSOURCE\tVERSION\tSTATE\tACTIVE\n'
    printf '%s' "$lignes"
  } | column -t -s $'\t'

  if (( inactives > 0 )); then
    _clia_msg "$inactives ressource(s) inactive(s) : clia ne sert pas leur commande"
    while IFS="$_CLIA_SEP" read -r _ nom _ _ _ _ actif raison; do
      [[ "$actif" == 'inactif' ]] || continue
      _clia_detail "$nom : $raison"
    done < <(_clia_pc_parc "$DEPOT")
  fi
  _clia_detail "ce qui est à mettre à jour : clia update"
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

(( $# == 0 )) || {
  _clia_msg "clia ls ne prend pas d'argument : $*"
  _clia_detail "pour une seule ressource : clia version RESSOURCE"
  exit 2
}

lister
