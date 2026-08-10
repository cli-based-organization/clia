#!/usr/bin/env bash
# setup.sh - Installation et activation de clia.
#
# Quatre principes, empruntes a cli-based-organization/linux-inspect :
#
#   Universalite     bash 4 ou plus, outils presents sur toute distribution
#   Adaptabilite     activation ephemere ou installation permanente
#   Non-intrusivite  aucun fichier du systeme modifie sans demande explicite
#   Reflexivite      setup.sh expose sa version, son chemin et ses commandes
#
# Usage :
#   . setup.sh activate      active clia dans le shell courant (ephemere)
#   . setup.sh deactivate    retire clia du shell courant
#   ./setup.sh check         verifie les prerequis et l'etat
#   ./setup.sh install       ajoute l'activation a ~/.bashrc (permanent)
#   ./setup.sh uninstall     retire l'activation de ~/.bashrc
#   ./setup.sh help

CLIA_SETUP_VERSION='0.1.0'

# --------------------------------------------------------------------------
# Detection du mode d'invocation
# --------------------------------------------------------------------------
#
# activate et deactivate modifient le shell courant : ils exigent un
# sourcing. Les autres commandes fonctionnent dans les deux modes.

if [[ -n "${BASH_SOURCE[0]:-}" && "${BASH_SOURCE[0]}" != "${0}" ]]; then
  _clia_sourced=1
else
  _clia_sourced=0
fi

# Racine de clia, resolue depuis l'emplacement reel de ce fichier.
_clia_setup_root() {
  local src="${BASH_SOURCE[0]}" dir
  while [[ -L "$src" ]]; do
    dir=$(cd -P "$(dirname "$src")" && pwd)
    src=$(readlink "$src")
    [[ "$src" != /* ]] && src="$dir/$src"
  done
  cd -P "$(dirname "$src")" && pwd
}

_clia_msg()  { printf 'setup: %s\n' "$*" >&2; }
_clia_hint() { printf '       %s\n' "$*" >&2; }

# --------------------------------------------------------------------------
# Prerequis
# --------------------------------------------------------------------------

_clia_check() {
  local root="$1" ok=0

  if (( BASH_VERSINFO[0] < 4 )); then
    _clia_msg "bash 4 ou plus est requis, version detectee : ${BASH_VERSION}"
    ok=1
  fi

  local missing=()
  local tool
  for tool in awk sed find sort column iconv date mktemp; do
    command -v "$tool" >/dev/null 2>&1 || missing+=("$tool")
  done
  if (( ${#missing[@]} > 0 )); then
    _clia_msg "outils manquants : ${missing[*]}"
    ok=1
  fi

  if [[ ! -x "$root/bin/clia" ]]; then
    if [[ -f "$root/bin/clia" ]]; then
      _clia_msg "bin/clia n'est pas executable"
      _clia_hint "chmod +x $root/bin/clia"
    else
      _clia_msg "bin/clia est introuvable dans $root"
    fi
    ok=1
  fi

  local m
  for m in core.sh resource.sh config.sh; do
    [[ -f "$root/lib/clia/$m" ]] || { _clia_msg "module manquant : lib/clia/$m"; ok=1; }
  done

  if (( ok == 0 )); then
    _clia_msg "prerequis satisfaits"
    _clia_hint "racine        : $root"
    _clia_hint "version setup : $CLIA_SETUP_VERSION"
    if command -v clia >/dev/null 2>&1; then
      _clia_hint "clia actif    : $(command -v clia)"
    else
      _clia_hint "clia actif    : non. Lancez : . setup.sh activate"
    fi
  fi
  return $ok
}

# --------------------------------------------------------------------------
# Activation ephemere
# --------------------------------------------------------------------------

_clia_activate() {
  local root="$1"

  if (( _clia_sourced == 0 )); then
    _clia_msg "activate doit etre source pour modifier le shell courant"
    _clia_hint ". setup.sh activate"
    return 1
  fi

  if [[ ! -f "$root/bin/clia" ]]; then
    _clia_msg "bin/clia introuvable dans $root"
    return 1
  fi
  [[ -x "$root/bin/clia" ]] || chmod +x "$root/bin/clia"

  export CLIA_HOME="$root"

  # Idempotent : une seconde activation ne duplique pas le PATH.
  case ":${PATH}:" in
    *":$root/bin:"*) ;;
    *) export PATH="$root/bin:$PATH" ;;
  esac

  _clia_msg "clia actif dans ce shell"
  _clia_hint "CLIA_HOME : $CLIA_HOME"
  _clia_hint "version   : $("$root/bin/clia" --version 2>/dev/null || echo '?')"
  _clia_hint "le depot de travail est resolu depuis le repertoire courant,"
  _clia_hint "pas depuis CLIA_HOME. Verifiez avec : clia --context"
  return 0
}

_clia_deactivate() {
  if (( _clia_sourced == 0 )); then
    _clia_msg "deactivate doit etre source"
    _clia_hint ". setup.sh deactivate"
    return 1
  fi
  local root="$1" newpath='' part
  local IFS=':'
  for part in $PATH; do
    [[ "$part" == "$root/bin" ]] && continue
    newpath="${newpath:+$newpath:}$part"
  done
  export PATH="$newpath"
  unset CLIA_HOME
  _clia_msg "clia retire de ce shell"
  return 0
}

# --------------------------------------------------------------------------
# Installation permanente
# --------------------------------------------------------------------------
#
# Non-intrusivite : ~/.bashrc n'est modifie que par cette commande, jamais
# par activate, et le bloc ajoute est delimite pour pouvoir etre retire.

_CLIA_MARK_BEGIN='# >>> clia >>>'
_CLIA_MARK_END='# <<< clia <<<'

_clia_install() {
  local root="$1" rc="${HOME}/.bashrc"

  if grep -qF "$_CLIA_MARK_BEGIN" "$rc" 2>/dev/null; then
    _clia_msg "deja installe dans $rc"
    _clia_hint "pour changer de racine : ./setup.sh uninstall puis install"
    return 0
  fi

  _clia_msg "cette commande va ajouter 5 lignes a $rc"
  _clia_hint "activation de clia depuis $root"
  printf '       continuer ? [o/N] ' >&2
  local answer
  read -r answer
  case "$answer" in
    o|O|y|Y) ;;
    *) _clia_msg "abandon, aucun fichier modifie"; return 1 ;;
  esac

  cp -p "$rc" "${rc}.clia-backup-$(date +%Y%m%d%H%M%S)" 2>/dev/null || true
  {
    printf '\n%s\n' "$_CLIA_MARK_BEGIN"
    printf 'export CLIA_HOME="%s"\n' "$root"
    printf 'case ":$PATH:" in *":$CLIA_HOME/bin:"*) ;; *) export PATH="$CLIA_HOME/bin:$PATH" ;; esac\n'
    printf '%s\n' "$_CLIA_MARK_END"
  } >> "$rc"

  _clia_msg "installe dans $rc"
  _clia_hint "ouvrez un nouveau terminal, ou lancez : . $rc"
  return 0
}

_clia_uninstall() {
  local rc="${HOME}/.bashrc"
  if ! grep -qF "$_CLIA_MARK_BEGIN" "$rc" 2>/dev/null; then
    _clia_msg "aucune installation trouvee dans $rc"
    return 0
  fi
  local tmp
  tmp=$(mktemp "${rc}.XXXXXX")
  awk -v b="$_CLIA_MARK_BEGIN" -v e="$_CLIA_MARK_END" '
    $0 == b { skip = 1; next }
    $0 == e { skip = 0; next }
    !skip
  ' "$rc" > "$tmp"
  chmod --reference="$rc" "$tmp" 2>/dev/null || true
  mv -f "$tmp" "$rc"
  _clia_msg "retire de $rc"
  _clia_hint "le shell courant garde clia actif jusqu'a sa fermeture"
  return 0
}

# --------------------------------------------------------------------------
# Aide
# --------------------------------------------------------------------------

_clia_help() {
  cat <<EOF
setup.sh $CLIA_SETUP_VERSION - installation et activation de clia

Racine detectee : $(_clia_setup_root)

Commandes :
  . setup.sh activate      active clia dans le shell courant (ephemere)
  . setup.sh deactivate    retire clia du shell courant
  ./setup.sh check         verifie les prerequis et l'etat
  ./setup.sh install       ajoute l'activation a ~/.bashrc, apres confirmation
  ./setup.sh uninstall     retire l'activation de ~/.bashrc
  ./setup.sh help          cette aide

activate et deactivate modifient le shell courant : ils doivent etre sources,
d'ou le point qui precede. Les autres commandes s'executent normalement.

Aucun fichier du systeme n'est modifie par activate. install le fait, une
seule fois, apres confirmation, et en delimitant son ajout pour permettre
son retrait.
EOF
}

# --------------------------------------------------------------------------
# Dispatch
# --------------------------------------------------------------------------

_clia_setup_main() {
  local root
  root=$(_clia_setup_root)
  local cmd="${1:-help}"
  case "$cmd" in
    activate)    _clia_activate "$root" ;;
    deactivate)  _clia_deactivate "$root" ;;
    check)       _clia_check "$root" ;;
    install)     _clia_install "$root" ;;
    uninstall)   _clia_uninstall ;;
    version|--version|-v) printf 'setup.sh %s\n' "$CLIA_SETUP_VERSION" ;;
    help|--help|-h) _clia_help ;;
    *)
      _clia_msg "commande inconnue : $cmd"
      _clia_help >&2
      return 2 ;;
  esac
}

_clia_setup_main "$@"
