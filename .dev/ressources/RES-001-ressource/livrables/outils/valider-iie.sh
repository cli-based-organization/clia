#!/usr/bin/env bash
# valider-iie.sh — juger une IIE contre le schéma que la ressource porte.
#
# SES-001 tâche 24 : « la ressource RES contient un script permettant de
# valider l'IIE », et « choix d'implémentation : utiliser cuelang pour
# décrire et valider l'IIE ».
#
#     valider-iie.sh <fichier>…
#
# Rend 0 si toutes les IIE lues sont conformes, 1 sinon, 2 si la demande est
# mal formée ou si cue n'est pas là.
#
# Ce que ce script fait, et que le noyau ne fait pas
# --------------------------------------------------
#
# Le noyau vérifie la présence d'une identité et sa forme absolue — C0 de
# « clia <ressource> check ». Il le fait en bash, parce que ce contrôle doit
# répondre partout, y compris là où cue n'est pas installé.
#
# Ici, c'est la forme entière qui est jugée, contre schemas/iie.cue. La
# description et le juge sont le même fichier : un schéma qui décrirait sans
# juger finirait par mentir.
#
# Extraire, puis juger
# --------------------
#
# cue lit du YAML et du JSON. Une IIE, elle, vit où le fichier peut la
# porter : la tête d'un YAML, le frontmatter d'un markdown, un en-tête de
# commentaires ailleurs. Ce script l'extrait d'abord, sous la forme d'un YAML
# qui ne porte qu'elle, puis le donne à cue.
#
# Ce que cela veut dire : ce qui est jugé est l'IIE, non le fichier. Un
# fichier peut porter tout ce qu'il veut d'autre.

set -euo pipefail

_CLIA_NOM='clia'
# shellcheck source=/dev/null
. "$CLIA_SOURCE_DIR/_scripts/lib/commun.sh"
# shellcheck source=/dev/null
. "$CLIA_SOURCE_DIR/_scripts/lib/texte.sh"
# shellcheck source=/dev/null
. "$CLIA_SOURCE_DIR/_scripts/lib/identite.sh"

RESSOURCE="$(cd -P "$(dirname "${BASH_SOURCE[0]}")/.." && pwd)"
SCHEMA="$RESSOURCE/schemas/iie.cue"

# Ce script vit sous outils/, non sous _scripts/ : tout fichier .sh de
# _scripts/ devient une commande du CLI — REQ-002 §2 — et celui-ci n'en est
# pas une. Il est appelé par « clia res iie check ».

if (( $# == 0 )); then
  _clia_msg 'valider-iie.sh attend au moins un fichier'
  exit 2
fi

if ! command -v cue >/dev/null 2>&1; then
  _clia_msg "cue est introuvable : la forme d'une IIE ne peut pas être jugée"
  _clia_detail "le schéma est dans ${SCHEMA#"$CLIA_SOURCE_DIR"/}"
  _clia_detail "la présence d'une identité, elle, se vérifie sans cue :"
  _clia_detail "  clia <ressource> check"
  exit 2
fi

if [[ ! -f "$SCHEMA" ]]; then
  _clia_msg "le schéma est introuvable : $SCHEMA"
  _clia_detail "la ressource « ressource » le porte sous schemas/"
  exit 2
fi

# Extrait l'IIE d'un fichier, sous forme de YAML.
extraire() {
  local f="$1" champ valeur
  for champ in $_CLIA_ID_CHAMPS representation composee-de; do
    valeur=$(_clia_id_champ "$f" "$champ")
    [[ -n "$valeur" ]] || continue
    printf '%s: %s\n' "$champ" "$(printf '%s' "$valeur" | sed 's/"/\\"/g; s/^/"/; s/$/"/')"
  done
}

ECARTS=0

# cue déduit l'encodage de l'extension : le fichier extrait doit donc se
# nommer .yaml, et un mktemp nu ne le permet pas.
BAC=$(mktemp -d); trap 'rm -rf "$BAC"' EXIT
TAMPON="$BAC/iie.yaml"

for FICHIER in "$@"; do
  if [[ ! -f "$FICHIER" ]]; then
    _clia_msg "$FICHIER : introuvable"
    ECARTS=$((ECARTS + 1))
    continue
  fi

  extraire "$FICHIER" > "$TAMPON"
  if [[ ! -s "$TAMPON" ]]; then
    _clia_msg "$FICHIER : aucune IIE à juger"
    _clia_detail "elle se pose dans la tête d'un YAML, un frontmatter, ou un en-tête"
    ECARTS=$((ECARTS + 1))
    continue
  fi

  if cue vet "$SCHEMA" "$TAMPON" 2>"$TAMPON.erreurs"; then
    printf 'ok  %s\n' "$FICHIER"
  else
    printf '!!  %s\n' "$FICHIER"
    sed -e '/^ /d' -e "s|$TAMPON|$FICHIER|" "$TAMPON.erreurs" | sed 's/^/    /'
    ECARTS=$((ECARTS + 1))
  fi
  rm -f "$TAMPON.erreurs"
done

if (( ECARTS > 0 )); then
  _clia_msg "$ECARTS IIE ne se conforment pas au schéma"
  _clia_detail "le schéma : ${SCHEMA#"$CLIA_SOURCE_DIR"/}"
  exit 1
fi
_clia_msg "$# IIE conforme(s) au schéma"
exit 0
