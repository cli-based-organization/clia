# shellcheck shell=bash
# lib/clia/commun.sh — ce que setup.sh et bin/clia partagent.
#
# Ce fichier est sourcé par les deux, et par rien d'autre. Il ne fait aucune
# action : il déclare la version, les emplacements, et les fonctions de
# lecture. Le fait de le sourcer ne modifie ni le shell, ni le disque.
#
# Tout ce qui est déclaré ici porte le préfixe _clia_, pour que setup.sh
# puisse retirer l'ensemble du shell de l'utilisateur après usage — voir la
# section « nettoyage » de setup.sh. Un shell interactif ne doit rien garder
# de clia qu'il n'ait demandé.

_CLIA_VERSION='0.1.0'

# --------------------------------------------------------------------------
# Emplacements
# --------------------------------------------------------------------------
#
# CLIA_BIN_DIR et XDG_CONFIG_HOME permettent de déplacer l'installation sans
# toucher au code : le banc de tests s'en sert pour installer dans un HOME
# jetable plutôt que dans celui de l'utilisateur.

_clia_bin_dir() {
  printf '%s\n' "${CLIA_BIN_DIR:-$HOME/.local/bin}"
}

_clia_lien() {
  printf '%s/clia\n' "$(_clia_bin_dir)"
}

_clia_config_dir() {
  printf '%s/clia\n' "${XDG_CONFIG_HOME:-$HOME/.config}"
}

_clia_config_fichier() {
  printf '%s/install.conf\n' "$(_clia_config_dir)"
}

# --------------------------------------------------------------------------
# Le fichier d'installation
# --------------------------------------------------------------------------
#
# Format clé=valeur, une paire par ligne. Il est lu par extraction et jamais
# par sourcing : un fichier de configuration ne doit pas pouvoir exécuter du
# code. Le mode --activate n'écrit pas ce fichier ; il est éphémère par
# définition, et laisser une trace sur le disque le rendrait durable.

_clia_config_valeur() {
  local cle="$1" fichier
  fichier=$(_clia_config_fichier)
  [[ -f "$fichier" ]] || return 1
  local ligne
  ligne=$(grep -m1 "^${cle}=" "$fichier" 2>/dev/null) || return 1
  printf '%s\n' "${ligne#*=}"
}

_clia_config_existe() {
  [[ -f "$(_clia_config_fichier)" ]]
}

# --------------------------------------------------------------------------
# Résolution de chemins
# --------------------------------------------------------------------------

# Répertoire réel d'un fichier, les liens symboliques suivis jusqu'au bout.
# bin/clia est atteint par un lien en mode --dev : sans cette résolution, il
# chercherait ses modules dans ~/.local/bin.
_clia_dir_reel() {
  local src="$1" dir
  while [[ -L "$src" ]]; do
    dir=$(cd -P "$(dirname "$src")" >/dev/null 2>&1 && pwd)
    src=$(readlink "$src")
    [[ "$src" != /* ]] && src="$dir/$src"
  done
  (cd -P "$(dirname "$src")" >/dev/null 2>&1 && pwd)
}

# Racine du dépôt git contenant un répertoire. Échoue s'il n'y en a pas.
_clia_depot_git() {
  git -C "${1:-$PWD}" rev-parse --show-toplevel 2>/dev/null
}

# --------------------------------------------------------------------------
# Sortie
# --------------------------------------------------------------------------
#
# Tout passe par l'erreur standard sauf ce qu'un programme viendrait lire.
# PDC-004 : un message nomme ce qui s'est produit, puis ce que l'humain peut
# faire ensuite. Un message qui constate sans indiquer la suite oblige le
# lecteur à deviner.

_clia_msg()    { printf '%s: %s\n' "${_CLIA_NOM:-clia}" "$*" >&2; }
_clia_detail() { printf '%*s  %s\n' "${#_CLIA_NOM}" '' "$*" >&2; }

# --------------------------------------------------------------------------
# Le mode d'installation constaté
# --------------------------------------------------------------------------
#
# Trois modes, et l'ordre compte : l'activation d'une session l'emporte sur
# l'installation persistante, parce qu'elle est plus proche de l'utilisateur.
#
#   activate  variables du shell courant, exécution restreinte au dépôt source
#   dev       lien dans le répertoire des exécutables, exécution dans le dépôt courant
#   direct    aucune installation, le fichier a été appelé par son chemin
_clia_mode_constate() {
  if [[ -n "${CLIA_MODE:-}" ]]; then
    printf '%s\n' "$CLIA_MODE"
  elif [[ "$(_clia_config_valeur mode 2>/dev/null)" == 'dev' ]]; then
    printf 'dev\n'
  else
    printf 'direct\n'
  fi
}
