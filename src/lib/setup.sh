#!/usr/bin/env bash
# setup.sh (lib) - groupe `clia setup` : delegation a l'extension d'amorcage.
# Source par src/bin/clia. Requiert REPO_ROOT, DEBUG, DRY_RUN.
#
# Ce module n'implemente RIEN de la logique d'installation (ADR-010 D8) : il
# invoque le script d'amorcage declare comme extension (ADR-014) et propage son
# code de retour tel quel. Une seule implementation existe, dans setup.sh.

# Version majeure de contrat d'extension supportee par clia (ADR-014 D5).
CLIA_SETUP_CONTRACT_MAJOR="1"

# _setup_ext : chemin de l'extension declaree. Emplacement fixe dans l'arbre
# source de l'outil ; jamais dans un depot cible (ADR-014 D6).
_setup_ext() { printf '%s/setup.sh' "$REPO_ROOT"; }

# _setup_ext_check : verifie presence, executabilite et compatibilite de contrat.
_setup_ext_check() {
  local ext; ext="$(_setup_ext)"
  [ -f "$ext" ] || _die "extension introuvable : $ext" 1
  [ -x "$ext" ] || _die "extension non executable : $ext" 1

  local declared major
  declared="$("$ext" --contract-version 2>/dev/null || true)"
  [ -n "$declared" ] || _die "l'extension n'annonce aucune version de contrat : $ext" 1
  major="${declared%%.*}"
  if [ "$major" != "$CLIA_SETUP_CONTRACT_MAJOR" ]; then
    _die "contrat d'extension incompatible : l'extension annonce $declared, clia attend ${CLIA_SETUP_CONTRACT_MAJOR}.x" 1
  fi
  _dbg "extension $ext, contrat $declared"
}

# _setup_forward SOUS-COMMANDE [ARGS] : invoque l'extension et propage son code.
# Les options globales dont l'extension doit tenir compte lui sont transmises
# explicitement (ADR-014 D3).
_setup_forward() {
  local sub="$1"; shift
  _setup_ext_check
  local pass=()
  [ "${DEBUG:-0}" = 1 ]   && pass+=(--debug)
  [ "${DRY_RUN:-0}" = 1 ] && pass+=(--dry-run)
  _dbg "delegation : setup.sh $sub ${pass[*]:-} $*"
  "$(_setup_ext)" "$sub" "${pass[@]}" "$@"
}

# cmd_setup_init : materialise le systeme d'augmentation dans un depot cible.
cmd_setup_init() { _setup_forward init "$@"; }

# cmd_setup_versions : versions disponibles et version installee (lecture seule).
cmd_setup_versions() { _setup_forward versions "$@"; }

# cmd_setup : dispatch du groupe, valide contre la source documentaire (REQ-001-F9).
cmd_setup() {
  local sub="${1:-}"
  case "$sub" in
    -h|--help|"") _doc_help_group setup; return 0 ;;
  esac
  shift
  case "${1:-}" in
    -h|--help) _doc_help_sub setup "$sub"; return 0 ;;
  esac
  _doc_subcommands setup | grep -qx "$sub" \
    || { _err "sous-commande inconnue : $sub"; _doc_help_group setup >&2; exit 2; }
  case "$sub" in
    init)     cmd_setup_init "$@" ;;
    versions) cmd_setup_versions "$@" ;;
    *)        _die "sous-commande sans handler : $sub" 2 ;;
  esac
}
