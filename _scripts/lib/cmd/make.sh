#!/usr/bin/env bash
# Description: La politique de génération du dépôt — policy ls, policy set.
# Périmètre: dépôt
# Signature: make policy ls
# Signature: make policy set CLE VALEUR
#
# Implémente SES-001 tâche 23.
#
# Pourquoi une commande du noyau, alors que « make » est déjà un verbe
# --------------------------------------------------------------------
#
# « clia <ressource> make » construit ce qu'une ressource génère. Cette
# commande-ci ne construit rien : elle règle ce qui vaut pour toutes les
# ressources du dépôt.
#
# Ce sont deux niveaux, et l'énoncé les sépare :
#
#   clia <ressource> make policy set …   pour une ressource
#   clia make policy set …               pour ce dépôt
#   clia setup config set make.policy.…  pour cet utilisateur
#
# Le plus proche l'emporte. Régler au plus près ne doit jamais être défait
# par plus loin, sans quoi une politique posée sur une ressource pourrait
# être annulée par une préférence d'utilisateur — ce qui serait l'inverse de
# ce que « poser » veut dire.
#
# Où cela s'écrit
# ---------------
#
# Dans la carte du dépôt, sous « make-politiques: ». C'est ce que le dépôt
# déclare de lui-même, au même titre que ses sources et ses extensions.
#
# Ce qui règle une génération se lit toujours au même endroit, quel que soit
# le niveau qui le donne : clia <ressource> make policy ls le rend, et nomme
# le niveau.

set -euo pipefail

_CLIA_NOM='clia'
# shellcheck source=../commun.sh
. "$CLIA_SOURCE_DIR/_scripts/lib/commun.sh"
# shellcheck source=../generation.sh
. "$CLIA_SOURCE_DIR/_scripts/lib/generation.sh"

DEPOT="${CLIA_WORK_DIR:-}"

# --------------------------------------------------------------------------

manuel() {
  cat <<'FIN' | _clia_man clia-make 1 "Manuel de l'utilisateur clia"
NOM
clia-make - la politique de génération du dépôt

SYNOPSIS
clia make policy ls
clia make policy set CLE VALEUR

DESCRIPTION
Cette commande ne construit rien. Elle règle ce qui vaut pour
toutes les ressources du dépôt quand elles se génèrent.

Construire est le fait d'une ressource : clia <ressource> make.
Voir le manuel de ce verbe pour les recettes et pour ce qui décide
de refaire une cible.

LES NIVEAUX
Une politique se règle à quatre niveaux, et le plus proche
l'emporte :

       $CLIA_MAKE_POLICY_<CLE>              l'appel
       clia <ressource> make policy set     la ressource
       clia make policy set                 le dépôt
       clia setup config set make.policy.   l'utilisateur

Régler au plus près ne doit jamais être défait par plus loin : une
politique posée sur une ressource ne peut pas être annulée par une
préférence d'utilisateur.

LES POLITIQUES
ressource.version
       Ce qui, d'une ressource dont une recette dépend, déclenche
       une régénération.

       fixed-version — seule sa version compte. Une ressource qui
       bouge sans changer de version ne provoque rien. C'est le
       défaut : une ressource installée est figée.

       rolling-release — son contenu compte aussi. Ce qui bouge se
       répercute. C'est ce que demande un dépôt qui développe les
       ressources dont il se sert.

SORTIE
Une ligne par politique : son nom, sa valeur, le niveau qui la
donne, et les valeurs admises.

FICHIERS
clia.yaml, .clia.yaml, .dev/clia.yaml
       La carte du dépôt. « policy set » y écrit, sous
       « make-politiques: ».

CODE DE RETOUR
0
       La demande est satisfaite.

1
       Refus. Le dépôt ne porte pas de carte où écrire.

2
       Demande mal formée.

EXEMPLES
Ce qui règle la génération dans ce dépôt :

       $ clia make policy ls

Suivre ce qui bouge, plutôt que les versions publiées :

       $ clia make policy set ressource.version rolling-release

VOIR AUSSI
clia(1), clia-config(1), clia-setup(1), clia-res(1)
FIN
}

# --------------------------------------------------------------------------

politiques_ls() {
  local p valeur niveau
  { printf 'POLITIQUE%sVALEUR%sNIVEAU%sVALEURS ADMISES\n' \
      "$_CLIA_SEP" "$_CLIA_SEP" "$_CLIA_SEP"
    for p in $_CLIA_G_POLITIQUES; do
      IFS="$_CLIA_SEP" read -r valeur niveau < <(_clia_g_politique "$p" "$DEPOT" '')
      printf '%s%s%s%s%s%s%s\n' "$p" "$_CLIA_SEP" "$valeur" "$_CLIA_SEP" \
        "$niveau" "$_CLIA_SEP" "$_CLIA_G_VERSION_VALEURS"
    done
  } | column -t -s "$_CLIA_SEP"
  _clia_detail "une ressource peut en poser une autre : clia <ressource> make policy set"
  return 0
}

politiques_set() {
  local cle="$1" valeur="$2" carte

  if [[ " $_CLIA_G_POLITIQUES " != *" $cle "* ]]; then
    _clia_msg "politique inconnue : $cle"
    _clia_detail "celles qui existent : $_CLIA_G_POLITIQUES"
    return 2
  fi
  if ! _clia_g_valeur_admise "$cle" "$valeur"; then
    _clia_msg "valeur inconnue pour $cle : $valeur"
    _clia_detail "valeurs admises : $_CLIA_G_VERSION_VALEURS"
    return 2
  fi

  if ! carte=$(_clia_carte "$DEPOT"); then
    _clia_msg "ce dépôt ne porte pas de carte où écrire"
    _clia_detail "les emplacements cherchés : ${_CLIA_CARTE_EMPLACEMENTS[*]}"
    _clia_detail "pour en poser une : clia init ."
    return 1
  fi

  _clia_g_politique_poser "$carte" "$cle" "$valeur" || return 1
  _clia_msg "$cle = $valeur, pour ce dépôt"
  _clia_detail "inscrit dans ${carte#"$DEPOT"/}"
  _clia_detail "pour une seule ressource : clia <ressource> make policy set $cle $valeur"
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

case "${1:-}" in
  policy)
    case "${2:-ls}" in
      ls)
        (( $# <= 2 )) || { _clia_msg "policy ls ne prend pas d'argument : ${*:3}"; exit 2; }
        politiques_ls ;;
      set)
        (( $# == 4 )) || {
          _clia_msg "policy set attend une clé et une valeur"
          _clia_detail "l'usage : clia make policy set CLE VALEUR"; exit 2; }
        politiques_set "$3" "$4" ;;
      *) _clia_msg "policy n'accepte que « ls » ou « set » : $2"
         _clia_detail "l'usage : clia make --help"; exit 2 ;;
    esac ;;
  '')
    _clia_msg 'clia make attend un verbe'
    _clia_detail "ce qui règle la génération de ce dépôt : clia make policy ls"
    _clia_detail "pour construire une ressource : clia <ressource> make"
    exit 2 ;;
  *)
    _clia_msg "verbe inconnu : $1"
    _clia_detail "l'usage : clia make --help"
    exit 2 ;;
esac
