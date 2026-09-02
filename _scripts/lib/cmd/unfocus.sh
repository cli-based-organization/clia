#!/usr/bin/env bash
# Description: Retire une information du focus.
# Périmètre: dépôt
# Signature: unfocus INFORMATION
#
# Implémente SES-001 tâche 16, qui nomme ce geste ainsi : « clia unfocus
# FOCUSED_INFO ». C'est le contraire de « clia focus on », et il porte son
# propre nom plutôt que d'être un verbe de focus — relâcher son attention
# n'est pas une variante de la porter.
#
# Tout ce qui décrit le focus est dans clia-focus(1) ; cette page ne redit
# que ce qui lui est propre.

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
  cat <<'EOF' | _clia_man clia-unfocus 1 "Manuel de l'utilisateur clia"
NOM
clia-unfocus - retirer une information du focus

SYNOPSIS
clia unfocus INFORMATION

DESCRIPTION
Retire du focus le lien qui désigne cette information. Rien de ce
qu'il désignait n'est touché : un lien s'enlève, le document reste.

Ce qu'est un focus, et comment on en met une information, est dans
clia-focus(1).

DESIGNER CE QU ON RETIRE
Deux formes, et clia essaie la première d'abord.

NOM
       Le nom du lien, tel que « clia focus ls » l'affiche. C'est
       la forme la plus sûre : elle ne dépend d'aucune résolution.

INFORMATION
       La même désignation qu'à l'entrée — un chemin, @chemin, ou
       un alias PREFIXE-SEQ. clia résout, puis cherche le lien qui
       désigne ce qu'elle a trouvé.

Retirer ce qui n'est pas au focus n'est pas une erreur : clia le
dit, et n'a rien à faire.

LE HARNAIS
Retirer le dernier lien ôte la directive du focus du harnais. Un
focus vide n'est pas annoncé : le harnais ne peut pas promettre un
focus qui n'existe pas.

SORTIE
Rien sur la sortie standard.

CODE DE RETOUR
0
       La demande est satisfaite, même s'il n'y avait rien à
       retirer.

1
       Refus : rien de ce nom, et rien qui désigne cette
       information.

2
       Demande mal formée.

FICHIERS
focus/
       Les liens.

CLAUDE.md
       Le harnais, et la zone gérée qui porte la directive.

EXEMPLES
Retirer par le nom du lien :

       $ clia unfocus SES-002

Ou par ce que le lien désigne :

       $ clia unfocus @.dev/reqs/REQ-004.md

VOIR AUSSI
clia(1), clia-focus(1)
EOF
}

# --------------------------------------------------------------------------

# Le lien qui désigne une information, ou rien. La désignation est résolue en
# silence : elle peut très bien ne rien désigner de présent, et c'est le nom
# du lien qui répondra alors.
lien_par_cible() {
  local demande="$1" cible nom l
  cible=$(_clia_fo_cible "$DEPOT" "$demande" 2>/dev/null) || return 1
  for l in "$FOCUS"/*; do
    [[ -L "$l" ]] || continue
    [[ "$(readlink -f "$l" 2>/dev/null)" == "$cible" ]] || continue
    nom=$(basename "$l")
    printf '%s\n' "$nom"
    return 0
  done
  return 1
}

retirer() {
  local demande="$1" nom=''

  if [[ -e "$FOCUS/$demande" || -L "$FOCUS/$demande" ]]; then
    nom="$demande"
  elif ! nom=$(lien_par_cible "$demande"); then
    _clia_msg "rien de ce nom au focus : $demande"
    if _clia_fo_vide "$DEPOT"; then
      _clia_detail "le focus est vide"
    else
      _clia_detail "ce qu'il porte : clia focus ls"
    fi
    return 1
  fi

  rm -rf "${FOCUS:?}/$nom"

  _clia_msg "retiré du focus : $nom"
  _clia_detail "ce qu'il désignait n'a pas été touché"
  if _clia_fo_harnais_accorder "$DEPOT"; then
    _clia_detail "le focus est vide : sa directive est ôtée de CLAUDE.md"
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

case "${1:-}" in
  '')
    _clia_msg "clia unfocus attend une information"
    _clia_detail "l'usage : clia unfocus INFORMATION"
    _clia_detail "ce que le focus porte : clia focus ls"
    exit 2 ;;
esac

(( $# == 1 )) || {
  _clia_msg "unfocus attend une information, et une seule : $*"
  _clia_detail "l'usage : clia unfocus INFORMATION"
  exit 2
}

retirer "$1"
