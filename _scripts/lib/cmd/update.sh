#!/usr/bin/env bash
# Description: Ce qui est à mettre à jour, et vers quoi.
# Périmètre: dépôt
# Signature: update
# Signature: update RESSOURCE
#
# Implémente SES-002 tâche 1.
#
# Constater n'est pas mettre à jour
# ---------------------------------
#
# Cette commande n'écrit rien. Elle dit ce qui est en retard, et vers quelles
# versions chacune pourrait monter ; c'est « clia upgrade » qui déplace.
#
# La séparation est la même que celle de « clia check » et « clia init » :
# une commande qui constate est une commande qu'on lance sans y penser, et
# c'est ce qui la rend utile.
#
# Deux questions, deux formes
# ---------------------------
#
#   clia update             qu'est-ce qui est en retard ?
#   clia update RESSOURCE   vers quoi celle-ci peut-elle monter ?
#
# La seconde rend l'historique que sa source déclare, la version posée
# marquée. Ce sont les versions vers lesquelles « clia upgrade » et
# « clia downgrade » savent aller, et aucune autre.

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
  cat <<'FIN' | _clia_man clia-update 1 "Manuel de l'utilisateur clia"
NOM
clia-update - ce qui est à mettre à jour, et vers quoi

SYNOPSIS
clia update
clia update RESSOURCE

DESCRIPTION
Sans argument, les ressources installées dont la source déclare une
version plus récente que celle qui est posée ici.

Avec une ressource, les versions vers lesquelles elle peut aller —
celles que l'historique de sa source déclare, et aucune autre.

Cette commande n'écrit rien. C'est clia upgrade qui déplace.

RESSOURCE se désigne par son nom, son préfixe ou sa commande :
« session », « SES » et « ses » nomment la même.

COLONNES
Sans argument :

PREFIX, NAME, SOURCE
       Comme pour clia ls.

ACTUAL_VERSION
       Celle qui est posée dans ce dépôt.

LATEST_AVAILABLE_VERSION
       La plus récente que sa source déclare.

Avec une ressource, une ligne par version que sa source déclare,
de la plus ancienne à la plus récente, avec le commit qui l'a
introduite. La version posée ici est marquée.

CE QUI N EST PAS RENDU
Une ressource à jour n'apparaît pas dans la liste sans argument :
la question posée est « qu'est-ce qui est en retard », et une
réponse qui listerait aussi ce qui va bien ne se lirait plus.

Une ressource brisée n'y apparaît pas non plus, et clia la nomme à
part avec ce qui la brise : aucune mise à jour ne la concerne tant
que clia ne sait pas d'où elle vient. Voir clia-ls(1).

CODE DE RETOUR
0
       La liste a été rendue, même vide.

1
       La ressource nommée n'existe pas, ou clia ne trouve pas le
       dépôt qui la publie.

2
       Demande mal formée.

EXEMPLES
Ce qui est en retard :

       $ clia update
       PREFIX  NAME       SOURCE                   ACTUAL_VERSION  LATEST_AVAILABLE_VERSION
       RES     ressource  clia.noumanity.com/clia  0.1.0           0.2.0

Vers quoi « session » peut aller :

       $ clia update session

Et pour l'y amener :

       $ clia upgrade session

VOIR AUSSI
clia(1), clia-ls(1), clia-upgrade(1), clia-downgrade(1)
FIN
}

# --------------------------------------------------------------------------

en_retard() {
  local prefixe nom source version etat lignes='' brisees='' pourquoi

  while IFS="$_CLIA_SEP" read -r prefixe nom source version etat pourquoi _ _; do
    [[ -n "$nom" ]] || continue
    case "$etat" in
      'en retard')
        lignes+=$(printf '%s\t%s\t%s\t%s\t%s' "$prefixe" "$nom" "$source" \
          "$version" "$(_clia_pc_derniere "$DEPOT" "$nom")")$'\n' ;;
      'brisée')  brisees+=$(printf '%s\t%s' "$nom" "$pourquoi")$'\n' ;;
    esac
  done < <(_clia_pc_parc "$DEPOT")

  if [[ -n "$lignes" ]]; then
    { printf 'PREFIX\tNAME\tSOURCE\tACTUAL_VERSION\tLATEST_AVAILABLE_VERSION\n'
      printf '%s' "$lignes"
    } | column -t -s $'\t'
    _clia_msg "pour en amener une : clia upgrade RESSOURCE [VERSION]"
  else
    _clia_msg "aucune ressource installée n'est en retard"
  fi

  if [[ -n "$brisees" ]]; then
    _clia_msg "et $(printf '%s' "$brisees" | grep -c .) ressource(s) brisée(s), qu'aucune mise à jour ne concerne :"
    while IFS=$'\t' read -r nom pourquoi; do
      [[ -n "$nom" ]] || continue
      _clia_detail "$nom : $pourquoi"
    done <<<"$brisees"
    _clia_detail "les sources déclarées : clia extension ls"
  fi
  return 0
}

versions_de() {
  local quoi="$1" nom posee v c lignes='' marque
  nom=$(_clia_pc_resoudre "$DEPOT" "$quoi") || return 1
  posee=$(_clia_champ_yaml "$DEPOT/$(_clia_zone_livree)/$nom/$nom.yaml" version || printf '')

  while IFS=$'\t' read -r v c; do
    [[ -n "$v" ]] || continue
    if [[ "$v" == "$posee" ]]; then marque='<- posée ici'; else marque=''; fi
    lignes+=$(printf '%s\t%s\t%s' "$v" "${c:0:12}" "$marque")$'\n'
  done < <(_clia_pc_versions "$DEPOT" "$nom")

  if [[ -z "$lignes" ]]; then
    _clia_msg "$nom : le dépôt qui la publie ne déclare aucune version d'elle"
    _clia_detail "soit clia ne le trouve pas, soit rien n'y a été commité"
    _clia_detail "d'où elle vient : clia ls"
    return 1
  fi

  { printf 'VERSION\tCOMMIT\t\n'
    printf '%s' "$lignes"
  } | column -t -s $'\t'
  _clia_msg "$nom : posée en ${posee:-—}, source $(_clia_pc_source "$DEPOT" "$nom")"
  _clia_detail "pour y aller : clia upgrade $nom [VERSION]"
  _clia_detail "pour revenir : clia downgrade $nom VERSION"
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

case $# in
  0) en_retard ;;
  1)
    [[ "${1:0:1}" != '-' ]] || {
      _clia_msg "option inconnue : $1"
      _clia_detail "l'usage : clia update --help"
      exit 2
    }
    versions_de "$1" ;;
  *)
    _clia_msg "clia update n'attend qu'une ressource : $*"
    _clia_detail "l'usage : clia update [RESSOURCE]"
    exit 2 ;;
esac
