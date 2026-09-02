#!/usr/bin/env bash
# Description: La ressource {{nom}} — ce qu'elle porte.
# Périmètre: dépôt
# Signature: {{commande}} ls
#
# La commande de la ressource « {{nom}} ».
#
# Ce fichier a été posé par « clia res new », à partir du gabarit
# _ressources/ressource/gabarits/commande.sh. Il vous appartient : clia l'a
# posé, il ne l'a pas rédigé, et il ne le régénérera pas.
#
# Pourquoi il est ici plutôt que dans le noyau. Le point d'entrée trouve les
# commandes de _scripts/lib/cmd/ et celles que les ressources déposent sous
# _ressources/<nom>/_scripts/. Une ressource apporte donc ses automatismes
# avec elle, et le noyau n'a pas à savoir qu'elle existe.
#
# Ce qu'il faut savoir pour l'étendre :
#
#   le nom du fichier est le nom de la commande — {{commande}}.sh donne
#   « clia {{commande}} », et le noyau l'emporte en cas d'homonymie ;
#
#   les déclarations en tête font l'aide brève. Ajouter un verbe, c'est
#   ajouter une ligne « # Signature: » et la traiter dans le dispatch ;
#
#   la sortie standard ne porte que ce qu'un autre programme viendrait lire.
#   Tout le reste — constats, refus — va sur la sortie d'erreur.

set -euo pipefail

_CLIA_NOM='clia'
# shellcheck source=/dev/null
. "$CLIA_SOURCE_DIR/_scripts/lib/commun.sh"

DEPOT="${CLIA_WORK_DIR:-}"

RESSOURCE_REL='_ressources/{{nom}}'
RESSOURCE="$DEPOT/$RESSOURCE_REL"
PRIMITIVES="$RESSOURCE/primitives"

# --------------------------------------------------------------------------

manuel() {
  cat <<'FIN' | _clia_man clia-{{commande}} 1 "Manuel de l'utilisateur clia"
NOM
clia-{{commande}} - la ressource {{nom}}

SYNOPSIS
clia {{commande}} ls

DESCRIPTION
{{titre}} est une ressource informationnelle de ce dépôt. Elle dit
comment produire des livrables d'une nature précise, et contient
les primitives à partir desquelles ils sont produits.

Sa définition, son préfixe et sa version se lisent avec
clia-res(1) ; cette commande-ci porte ce qu'elle sait faire.

Ce manuel est un point de départ. Ce que la ressource sait faire
appartient à qui l'écrit : décrivez-le ici, sous SOUS-COMMANDES.

SOUS-COMMANDES
ls
       Les primitives que la ressource porte, une par ligne, en
       chemin relatif à la racine du dépôt.

SORTIE
La sortie standard ne porte que les chemins. Tout le reste va sur
la sortie d'erreur.

CODE DE RETOUR
0
       La demande est satisfaite, même s'il n'y a aucune primitive.

1
       Refus.

2
       Demande mal formée.

FICHIERS
_ressources/{{nom}}/{{nom}}.yaml
       La définition de la ressource.

_ressources/{{nom}}/primitives/
       Ce à partir de quoi ses livrables sont produits.

_ressources/{{nom}}/_scripts/{{commande}}.sh
       Ce fichier.

VOIR AUSSI
clia(1), clia-res(1)
FIN
}

# --------------------------------------------------------------------------
# ls
# --------------------------------------------------------------------------
#
# Ce que la ressource porte se constate, il ne se déclare pas : la liste est
# ce que le répertoire contient, et déposer un fichier suffit à l'y faire
# figurer.

lister() {
  local f nb=0

  if [[ -d "$PRIMITIVES" ]]; then
    for f in "$PRIMITIVES"/*; do
      [[ -e "$f" ]] || continue
      printf '%s/primitives/%s\n' "$RESSOURCE_REL" "$(basename "$f")"
      nb=$((nb + 1))
    done
  fi

  if (( nb == 0 )); then
    _clia_msg "{{nom}} ne porte aucune primitive"
    _clia_detail "elles se rangent sous $RESSOURCE_REL/primitives"
  fi
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
    _clia_msg "clia {{commande}} attend un verbe"
    _clia_detail "l'usage : clia {{commande}} --help"
    exit 2 ;;

  ls)
    (( $# == 0 )) || { _clia_msg "ls ne prend pas d'argument : $*"; exit 2; }
    lister ;;

  *)
    _clia_msg "verbe inconnu : $VERBE"
    _clia_detail "l'usage : clia {{commande}} --help"
    exit 2 ;;
esac
