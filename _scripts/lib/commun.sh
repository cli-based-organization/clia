# shellcheck shell=bash
# _scripts/lib/commun.sh — ce que setup.sh et le CLI partagent.
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
# Les ressources
# --------------------------------------------------------------------------
#
# Ce que clia sait installer vit dans son dépôt source, et ce qu'il installe
# va dans le dépôt de travail. noumanity-wiki, d'où ces commandes sont
# reprises, confondait les deux : son CLI n'instrumentait que son propre
# dépôt. clia instrumente n'importe quel dépôt git, ce qui oblige à nommer
# les deux côtés séparément.
#
# REQ-002 range chaque ressource sous _ressources/<nom>/, avec ses scripts,
# ses primitives, ses templates et ses schémas. Ces trois fonctions sont le
# seul endroit qui connaît cette disposition.

_clia_ressource_dir() { printf '%s/_ressources/%s\n' "${CLIA_SOURCE_DIR:-}" "$1"; }
_clia_primitives()    { printf '%s/_ressources/%s/primitives\n' "${CLIA_SOURCE_DIR:-}" "$1"; }
_clia_templates()     { printf '%s/_ressources/%s/templates\n'  "${CLIA_SOURCE_DIR:-}" "$1"; }
_clia_definition()    { printf '%s/_ressources/%s/schemas/%s.yaml\n' "${CLIA_SOURCE_DIR:-}" "$1" "$1"; }

# Un champ de la définition d'un type. Extraction à plat : les champs lus par
# le CLI sont des chaînes simples en tête de ligne, jamais des listes ni des
# blocs. Ce n'est pas un analyseur YAML, et ça n'a pas à en devenir un — le
# jour où un champ structuré devra être lu, c'est cette fonction qu'il faudra
# remplacer, et elle seule.
_clia_def_champ() {
  local fichier
  fichier=$(_clia_definition "$1")
  [[ -f "$fichier" ]] || return 1
  local ligne
  ligne=$(grep -m1 -E "^${2}:[[:space:]]" "$fichier" 2>/dev/null) || return 1
  ligne="${ligne#*:}"
  # Retire les espaces de tête, puis les guillemets s'il y en a.
  ligne="${ligne#"${ligne%%[![:space:]]*}"}"
  ligne="${ligne%\"}"
  ligne="${ligne#\"}"
  printf '%s\n' "$ligne"
}

# Le gabarit d'instance déclaré par un type, résolu en chemin complet.
_clia_gabarit_de() {
  local nom="$1" relatif
  relatif=$(_clia_def_champ "$nom" gabarit) || return 1
  [[ -n "$relatif" ]] || return 1
  printf '%s/%s\n' "$(_clia_ressource_dir "$nom")" "$relatif"
}

# --------------------------------------------------------------------------
# Le périmètre d'exécution
# --------------------------------------------------------------------------
#
# Le mode d'installation ne décide pas seulement de la durée de vie de la
# commande : il décide de ce sur quoi elle a le droit de travailler.
#
#   activate  le dépôt source, et lui seul
#   dev       le dépôt git courant, quel qu'il soit
#   direct    idem, la commande ayant été appelée par son chemin
#
# La garde est appliquée une fois, par le dispatcher, pour toute commande
# déclarant « Périmètre: dépôt ».

# Le périmètre autorise-t-il d'agir sur ce chemin ? La cible peut ne pas
# exister encore : clia init crée le dépôt qu'il instrumente, et il doit être
# refusé avant de créer quoi que ce soit, non après.
_clia_perimetre_permet() {
  local cible="$1"
  [[ "$(_clia_mode_constate)" == 'activate' ]] || return 0

  if [[ "$cible" != "${CLIA_HOME:-}" ]]; then
    _clia_msg "hors périmètre : l'activation ne permet que le dépôt source"
    _clia_detail "demandé      : $cible"
    _clia_detail "dépôt source : ${CLIA_HOME:-inconnu}"
    _clia_detail "pour travailler sur tout dépôt : . setup.sh install --dev"
    return 1
  fi
  return 0
}

_clia_depot_de_travail() {
  local depot
  depot=$(_clia_depot_git "$PWD") || {
    _clia_msg "le répertoire courant n'est pas dans un dépôt git"
    _clia_detail "clia travaille sur un dépôt ; placez-vous dans un dépôt git"
    return 1
  }

  _clia_perimetre_permet "$depot" || return 1
  printf '%s\n' "$depot"
}

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
