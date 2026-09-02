#!/usr/bin/env bash
# Description: Le focus — ce sur quoi l'attention se porte.
# Périmètre: dépôt
# Signature: focus on INFORMATION
# Signature: focus ls
# Signature: focus clear
#
# Implémente SES-001 tâche 16.
#
# Un focus concentre l'attention sur une quantité restreinte d'information.
# Le répertoire focus/ ne porte que des liens ; le harnais y renvoie l'agent
# tant qu'il n'est pas vide.
#
# Pourquoi une commande du noyau, et non une ressource. Le focus ne produit
# aucun livrable et ne porte aucune primitive : il désigne, il ne fabrique
# pas. Il porte sur les instances de toutes les ressources à la fois, et sur
# des fichiers qui n'appartiennent à aucune.
#
# Le contraire de « focus on » s'écrit « clia unfocus » — SES-001 tâche 16 le
# nomme ainsi, et clia-unfocus(1) en rend compte.

set -euo pipefail

_CLIA_NOM='clia'
# shellcheck source=../commun.sh
. "$CLIA_SOURCE_DIR/_scripts/lib/commun.sh"
# shellcheck source=../texte.sh
. "$CLIA_SOURCE_DIR/_scripts/lib/texte.sh"
# shellcheck source=../focus.sh
. "$CLIA_SOURCE_DIR/_scripts/lib/focus.sh"

DEPOT="${CLIA_WORK_DIR:-}"
FOCUS=$(_clia_fo_dir "$DEPOT")

# --------------------------------------------------------------------------

manuel() {
  cat <<'EOF' | _clia_man clia-focus 1 "Manuel de l'utilisateur clia"
NOM
clia-focus - concentrer l'attention sur une part du dépôt

SYNOPSIS
clia focus on INFORMATION
clia focus ls
clia focus clear

DESCRIPTION
Un focus dit ce qui compte pour le travail en cours. Le répertoire
focus/, à la racine du dépôt, ne porte que des liens vers les
documents retenus.

Un agent qui ouvre le dépôt n'a plus à deviner par où commencer :
tant que le focus n'est pas vide, le harnais l'y renvoie, et le
focus le renvoie aux documents.

Des liens, et non des copies. Un lien ne se périme pas : le
document qu'il désigne reste le seul exemplaire, et l'éditer par le
focus l'édite là où il vit. Les liens sont relatifs, et survivent
donc au clone et au déplacement du dépôt.

Le focus n'est pas versionné. clia ajoute « /focus/ » au .gitignore
la première fois, et le dit. Le focus est ce que quelqu'un regarde
en ce moment, non ce que le dépôt est : deux personnes n'ont aucune
raison de partager leur attention.

DESIGNER UNE INFORMATION
Trois formes, et clia les distingue sans rien deviner.

@chemin
       Un chemin relatif à la racine du dépôt.

chemin
       Un chemin relatif au répertoire courant, ou absolu.

PREFIXE-SEQ
       Une instance de ressource — SES-002, REQ-004. clia cherche
       sous .dev/ un fichier ou un répertoire portant ce nom, seul,
       suivi d'un tiret, ou suivi d'une extension.

       Sous .dev/, et nulle part ailleurs. Ce qui est ailleurs dans
       un dépôt est une archive, un clone ou un livrable — pas une
       instance de ce dépôt-ci — et les y chercher rendait ambigus
       des alias qui ne désignaient qu'une chose.

       Un document rangé hors de .dev/ reste désignable par son
       chemin : c'est l'alias qui est restreint, non le focus.

       Un alias que plus d'une information porte est refusé, et
       clia nomme les candidates.

L'ordre compte : un chemin qui existe est pris comme tel, et un
alias n'est cherché que si rien de ce nom n'existe.

SOUS-COMMANDES
on INFORMATION
       Ajoute un lien vers cette information dans focus/.

       Le lien porte le nom de ce qu'il désigne. Deux informations
       de même nom ne peuvent donc pas être au focus ensemble : la
       seconde est refusée plutôt que renommée.

       Crée focus/ et la ligne du .gitignore au premier appel.

ls
       Ce que le focus porte : le nom de chaque lien, ce qu'il
       désigne, et son état.

       Un lien dont la cible a disparu le dit. Le focus n'empêche
       pas de déplacer un document ; il constate quand c'est fait.

clear
       Retire tous les liens. Rien de ce qu'ils désignaient n'est
       touché.

       « clean » et « reset » répondent aussi.

LE HARNAIS
Un focus non vide pose sa directive dans la zone gérée du harnais :

       <!-- CLIA:FOCUS:BEGIN -->
       <!-- CLIA:FOCUS:END -->

Un focus vide l'en retire. La directive est donc une conséquence de
l'état, non un geste de plus : le harnais ne peut pas annoncer un
focus qui n'existe pas.

Hors de ces marqueurs, le harnais appartient à qui l'écrit.

SORTIE
La sortie standard de « ls » porte une ligne d'en-tête et une ligne
par lien. Les autres verbes n'en portent aucune.

CODE DE RETOUR
0
       La demande est satisfaite, même si le focus était déjà vide.

1
       Refus : information introuvable, alias ambigu, ou nom déjà
       pris dans le focus.

2
       Demande mal formée.

FICHIERS
focus/
       Les liens. Rien d'autre n'y a sa place.

.dev/
       Où les instances vivent, et où un alias est cherché.

.gitignore
       clia y ajoute « /focus/ » une fois, précédé de sa raison.

CLAUDE.md
       Le harnais, et la zone gérée qui porte la directive.

EXEMPLES
Concentrer l'attention sur une session et un requis :

       $ clia focus on SES-002
       $ clia focus on @.dev/reqs/REQ-004.md

Voir ce qui est retenu :

       $ clia focus ls
       NOM        DESIGNE                        ETAT
       REQ-004.md .dev/reqs/REQ-004.md           —
       SES-002    .dev/logs/SES-002-le-focus     —

Tout relâcher :

       $ clia focus clear

VOIR AUSSI
clia(1), clia-unfocus(1), clia-res(1)
EOF
}

# --------------------------------------------------------------------------

accorder_harnais() {
  local avant="$1"
  if _clia_fo_harnais_accorder "$DEPOT"; then
    if [[ "$avant" == 'vide' ]]; then
      _clia_detail "la directive du focus est posée dans CLAUDE.md"
    else
      _clia_detail "la directive du focus est ôtée de CLAUDE.md"
    fi
  fi
  return 0
}

ajouter() {
  local demande="$1" cible nom lien avant

  cible=$(_clia_fo_cible "$DEPOT" "$demande") || return 1

  if [[ "$cible" == "$FOCUS" || "$cible" == "$FOCUS"/* ]]; then
    _clia_msg "cette information est déjà dans le focus : ${cible#"$DEPOT"/}"
    _clia_detail "focus/ ne porte que des liens ; on n'y pointe pas ses propres liens"
    return 1
  fi

  nom=$(basename "$cible")
  lien="$FOCUS/$nom"

  if [[ -e "$lien" || -L "$lien" ]]; then
    if [[ -L "$lien" && "$(readlink -f "$lien" 2>/dev/null)" == "$cible" ]]; then
      _clia_msg "$nom est déjà au focus"
      return 0
    fi
    _clia_msg "le focus porte déjà un $nom, et il désigne autre chose"
    _clia_detail "désigne : $(readlink "$lien" 2>/dev/null || printf '(pas un lien)')"
    _clia_detail "deux informations de même nom ne peuvent pas y être ensemble"
    _clia_detail "retirez la première : clia unfocus $nom"
    return 1
  fi

  avant='plein'
  _clia_fo_vide "$DEPOT" && avant='vide'

  mkdir -p "$FOCUS"
  if _clia_fo_ignorer "$DEPOT"; then
    _clia_msg "/focus/ ajouté au .gitignore"
    _clia_detail "le focus est ce que quelqu'un regarde, non ce que le dépôt est"
  fi

  ln -sfn "$(realpath --relative-to="$FOCUS" "$cible" 2>/dev/null || printf '%s' "$cible")" "$lien"

  _clia_msg "au focus : $nom"
  _clia_detail "désigne ${cible#"$DEPOT"/}"
  accorder_harnais "$avant"
  return 0
}

lister() {
  local nom cible etat lignes=''

  if _clia_fo_vide "$DEPOT"; then
    _clia_msg "le focus est vide"
    _clia_detail "pour y mettre une information : clia focus on INFORMATION"
    return 0
  fi

  while IFS="$_CLIA_SEP" read -r nom cible etat; do
    [[ -n "$nom" ]] || continue
    lignes+=$(printf '%s\t%s\t%s' "$nom" "$cible" "$etat")$'\n'
  done < <(_clia_fo_liens "$DEPOT")

  { printf 'NOM\tDESIGNE\tETAT\n'
    printf '%s' "$lignes"
  } | column -t -s $'\t'
  return 0
}

vider() {
  local nom nb=0

  if _clia_fo_vide "$DEPOT"; then
    _clia_msg "le focus est déjà vide"
    return 0
  fi

  while IFS="$_CLIA_SEP" read -r nom _ _; do
    [[ -n "$nom" ]] || continue
    rm -rf "${FOCUS:?}/$nom"
    nb=$((nb + 1))
  done < <(_clia_fo_liens "$DEPOT")

  _clia_msg "focus relâché : $nb lien(s) retiré(s)"
  _clia_detail "rien de ce qu'ils désignaient n'a été touché"
  accorder_harnais 'plein'
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
    _clia_msg "clia focus attend un verbe"
    _clia_detail "l'usage : clia focus --help"
    exit 2 ;;

  on)
    (( $# == 1 )) || {
      _clia_msg "on attend une information, et une seule"
      _clia_detail "l'usage : clia focus on INFORMATION"
      exit 2
    }
    ajouter "$1" ;;

  ls)
    (( $# == 0 )) || { _clia_msg "ls ne prend pas d'argument : $*"; exit 2; }
    lister ;;

  # L'énoncé de SES-001 tâche 16 écrit les trois. Elles disent la même chose,
  # et refuser deux d'entre elles ferait chercher laquelle est la bonne.
  clear|clean|reset)
    (( $# == 0 )) || { _clia_msg "$VERBE ne prend pas d'argument : $*"; exit 2; }
    vider ;;

  *)
    _clia_msg "verbe inconnu : $VERBE"
    _clia_detail "l'usage : clia focus --help"
    exit 2 ;;
esac
