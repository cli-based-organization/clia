#!/usr/bin/env bash
# Description: Les scripts des ressources — ls, activate, deactivate.
# Périmètre: dépôt
# Signature: script ls
# Signature: script activate SCRIPT [PREFIXE]
# Signature: script deactivate SCRIPT [PREFIXE]
#
# Implémente SES-001 tâche 15.
#
# Un script est un verbe de la commande d'une ressource — le CMD de
# « clia <ressource> CMD … ». Il n'est déclaré nulle part en tant que tel : il
# se lit dans les signatures que le fichier de commande porte déjà. Une
# ressource n'a donc rien à écrire pour que ses scripts soient listés, et la
# liste ne peut pas mentir sur ce que la commande accepte.
#
# L'asymétrie avec les fonctionnalités et les skills, et sa raison
# ----------------------------------------------------------------
#
# Une fonctionnalité est inactive tant qu'on ne l'a pas posée. Un script,
# lui, est actif dès que sa ressource est là : les verbes d'une commande
# viennent avec elle, et une ressource dont aucun verbe ne répondrait ne
# servirait à rien.
#
# Ce qui est donc déclaré dans la carte est la désactivation, et elle seule :
#
#   desactives:
#     - script: RES/release
#
# Un inventaire de tout ce qui va bien serait un inventaire que personne ne
# relit. Celui-ci ne porte que les écarts, et il est court par construction.
#
# Le refus est appliqué par le point d'entrée, avant que la commande ne soit
# lancée. C'est le même endroit que la garde de périmètre, et pour la même
# raison : ce qui est uniforme se tient à un seul endroit.

set -euo pipefail

_CLIA_NOM='clia'
# shellcheck source=../commun.sh
. "$CLIA_SOURCE_DIR/_scripts/lib/commun.sh"
# shellcheck source=../texte.sh
. "$CLIA_SOURCE_DIR/_scripts/lib/texte.sh"
# shellcheck source=../fourniture.sh
. "$CLIA_SOURCE_DIR/_scripts/lib/fourniture.sh"

DEPOT="${CLIA_WORK_DIR:-}"

# --------------------------------------------------------------------------

manuel() {
  cat <<'EOF' | _clia_man clia-script 1 "Manuel de l'utilisateur clia"
NOM
clia-script - les verbes des commandes de ressources, et leur état

SYNOPSIS
clia script ls
clia script activate SCRIPT [PREFIXE]
clia script deactivate SCRIPT [PREFIXE]

DESCRIPTION
Un script est un verbe de la commande d'une ressource : le CMD de
« clia <ressource> CMD … ». « clia res new » et « clia res release »
sont deux scripts de la ressource ressource.

Ils ne sont déclarés nulle part : ils se lisent dans les signatures
que le fichier de commande porte déjà. Une ressource n'a donc rien
à écrire pour que ses scripts soient listés, et la liste ne peut
pas mentir sur ce que la commande accepte.

Un script est actif dès que sa ressource est là : les verbes d'une
commande viennent avec elle. C'est ce qui le distingue d'une
fonctionnalité ou d'un skill, inactifs tant qu'on ne les a pas
posés.

Désactiver un script le fait refuser par clia. La commande de la
ressource n'est pas lancée du tout : le refus vient du point
d'entrée, avant elle.

Ce qui est inscrit dans la carte est donc la désactivation, et elle
seule. Un inventaire de tout ce qui va bien serait un inventaire
que personne ne relit.

SOUS-COMMANDES
ls
       Les scripts des ressources du dépôt, leur état, et la
       signature qui les déclare.

activate SCRIPT [PREFIXE]
       Rend le verbe à nouveau appelable, en ôtant sa ligne de la
       carte.

       PREFIXE nomme la ressource, et n'est utile que si deux
       d'entre elles offrent un verbe du même nom — « ls » l'est
       chez presque toutes.

deactivate SCRIPT [PREFIXE]
       Fait refuser le verbe. Rien n'est effacé : le script est
       toujours dans la ressource, et l'activation le rend.

SORTIE
La sortie standard de « ls » porte une ligne d'en-tête et une ligne
par script. Les deux autres verbes n'en portent aucune.

CODE DE RETOUR
0
       La demande est satisfaite, même s'il n'y avait rien à faire.

1
       Refus : script inconnu, ou désignation ambiguë.

2
       Demande mal formée.

FICHIERS
_ressources/<ressource>/_scripts/<commande>.sh
       La commande d'une ressource. Ses lignes « # Signature: »
       font ses scripts.

clia.yaml, .clia.yaml, .dev/clia.yaml
       La carte. Son bloc « desactives: » porte les verbes refusés.

EXEMPLES
Voir les verbes des ressources :

       $ clia script ls
       RESSOURCE  SCRIPT   ETAT   SIGNATURE
       ressource  release  actif  res release major|minor|patch RESSOURCE

Refuser un verbe dans ce dépôt :

       $ clia script deactivate release res
       $ clia res release patch analyse
       clia: le script « release » est désactivé dans ce dépôt

VOIR AUSSI
clia(1), clia-feature(1), clia-skill(1)
EOF
}

# --------------------------------------------------------------------------

lister() {
  local prefixe nom verbe sig etat lignes=''

  if [[ -z "$(_clia_f_scripts "$DEPOT")" ]]; then
    _clia_msg "aucune ressource de ce dépôt n'offre de script"
    _clia_detail "ce que le dépôt porte : clia res ls"
    return 0
  fi

  while IFS="$_CLIA_SEP" read -r prefixe nom verbe sig; do
    [[ -n "$verbe" ]] || continue
    if _clia_f_est_desactive "$DEPOT" "$prefixe" "$verbe"; then
      etat='désactivé'
    else
      etat='actif'
    fi
    lignes+=$(printf '%s\t%s\t%s\t%s' "$nom" "$verbe" "$etat" "$sig")$'\n'
  done < <(_clia_f_scripts "$DEPOT")

  { printf 'RESSOURCE\tSCRIPT\tETAT\tSIGNATURE\n'
    printf '%s' "$lignes"
  } | column -t -s $'\t'
  return 0
}

resoudre() {
  local nom="$1" prefixe="${2:-}" ligne code
  ligne=$(_clia_f_scripts "$DEPOT" | _clia_f_resoudre "$nom" "$prefixe") && code=0 || code=$?
  if (( code == 0 )); then printf '%s\n' "$ligne"; return 0; fi
  if (( code == 1 )); then
    _clia_msg "script inconnu : $nom"
    _clia_detail "ceux que le dépôt offre : clia script ls"
  fi
  return 1
}

carte_du_depot() {
  local carte
  if ! carte=$(_clia_carte "$DEPOT"); then
    _clia_msg "ce dépôt ne porte pas de carte clia"
    _clia_detail "clia init la pose ; clia check dit ce qui manque"
    return 1
  fi
  printf '%s\n' "$carte"
}

desactiver() {
  local ligne prefixe nom verbe sig carte
  ligne=$(resoudre "$@") || return 1
  IFS="$_CLIA_SEP" read -r prefixe nom verbe sig <<<"$ligne"
  carte=$(carte_du_depot) || return 1

  if _clia_f_est_desactive "$DEPOT" "$prefixe" "$verbe"; then
    _clia_msg "$prefixe/$verbe est déjà désactivé"
    _clia_detail "pour le rendre : clia script activate $verbe $prefixe"
    return 0
  fi

  _clia_carte_inserer "$carte" desactives "  - script: $prefixe/$verbe"

  _clia_msg "$prefixe/$verbe désactivé dans ce dépôt"
  _clia_detail "« clia $(printf '%s' "$prefixe" | tr '[:upper:]' '[:lower:]') $verbe » est désormais refusé"
  _clia_detail "inscrit dans ${carte#"$DEPOT"/} ; rien n'est effacé"
  _clia_detail "rien n'est commité"
  return 0
}

activer() {
  local ligne prefixe nom verbe sig carte
  ligne=$(resoudre "$@") || return 1
  IFS="$_CLIA_SEP" read -r prefixe nom verbe sig <<<"$ligne"
  carte=$(carte_du_depot) || return 1

  if ! _clia_f_est_desactive "$DEPOT" "$prefixe" "$verbe"; then
    _clia_msg "$prefixe/$verbe est déjà actif"
    return 0
  fi

  _clia_carte_retirer "$carte" desactives script "$prefixe/$verbe" || true

  _clia_msg "$prefixe/$verbe rendu à ce dépôt"
  _clia_detail "« clia $(printf '%s' "$prefixe" | tr '[:upper:]' '[:lower:]') $verbe » répond de nouveau"
  _clia_detail "rien n'est commité"
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
    _clia_msg "clia script attend un verbe"
    _clia_detail "l'usage : clia script --help"
    exit 2 ;;

  ls)
    (( $# == 0 )) || { _clia_msg "ls ne prend pas d'argument : $*"; exit 2; }
    lister ;;

  activate|deactivate)
    (( $# >= 1 )) || {
      _clia_msg "$VERBE attend un script"
      _clia_detail "l'usage : clia script $VERBE SCRIPT [PREFIXE]"
      exit 2
    }
    (( $# <= 2 )) || { _clia_msg "argument en trop : ${3:-}"; exit 2; }
    if [[ "$VERBE" == 'activate' ]]; then activer "$@"; else desactiver "$@"; fi ;;

  *)
    _clia_msg "verbe inconnu : $VERBE"
    _clia_detail "l'usage : clia script --help"
    exit 2 ;;
esac
