# shellcheck shell=bash
# _scripts/lib/installation.sh — ce qu'est une installation de clia.
#
# Deux entrées s'en servent, et c'est la raison de ce module :
#
#   setup.sh                 pose et retire ce qui touche au shell
#   _scripts/lib/cmd/setup.sh  la commande « clia setup »
#
# Une installation ne doit pas se décrire différemment selon qui l'interroge.
# Le rapport, les emplacements et la lecture de l'état vivent donc ici, et
# les deux entrées les appellent.
#
# Les deux natures d'installation
# -------------------------------
#
# SES-001 tâches 4 et 7 en définissent deux, par leurs trois propriétés :
#
#              durée de vie              source                portée
#   activation le shell courant          le dépôt de setup.sh  un seul dépôt
#   dev        permanente, jusqu'au      le dépôt installé     n'importe quel
#              retrait                                         dépôt git
#
# Une activation ne laisse rien sur le disque : elle est faite de variables
# d'environnement, et fermer le terminal suffit à la défaire. Une
# installation dev laisse deux traces, et ne peut donc se défaire que par un
# geste — clia setup uninstall.
#
# Les deux peuvent coexister. L'activation l'emporte alors, parce qu'elle
# passe devant dans le PATH et pose une portée ; le rapport le dit, sans quoi
# on attribuerait à l'une le comportement de l'autre.
#
# Les emplacements se laissent déplacer
# -------------------------------------
#
# CLIA_BIN_DIR et XDG_CONFIG_HOME décident où l'installation pose ses traces.
# Ce n'est pas une commodité : c'est ce qui permet à un banc de tests
# d'installer dans un répertoire jetable plutôt que dans celui de
# l'utilisateur. Un banc qui ne pourrait pas le faire ne pourrait pas
# éprouver l'installation.

_CLIA_I_NATURE_DEV='dev'
_CLIA_I_NATURE_ACTIVATION='activation'

# --------------------------------------------------------------------------
# Emplacements
# --------------------------------------------------------------------------

_clia_i_bin_dir()    { printf '%s\n' "${CLIA_BIN_DIR:-$HOME/.local/bin}"; }
_clia_i_lien()       { printf '%s/clia\n' "$(_clia_i_bin_dir)"; }
_clia_i_config_dir() { printf '%s/clia\n' "${XDG_CONFIG_HOME:-$HOME/.config}"; }
_clia_i_config()     { printf '%s/installation.yaml\n' "$(_clia_i_config_dir)"; }

# Le répertoire des exécutables d'un dépôt source.
_clia_i_bin_du_source() { printf '%s/_scripts/bin\n' "$1"; }

# --------------------------------------------------------------------------
# L'état sur le disque
# --------------------------------------------------------------------------
#
# Le fichier de configuration est lu champ par champ, jamais sourcé : un
# fichier de configuration ne doit pas pouvoir exécuter du code.

_clia_i_champ() { _clia_champ_yaml "$(_clia_i_config)" "$1"; }

# Une installation dev est en place quand sa configuration et son lien le
# sont tous les deux. L'un sans l'autre est une installation à moitié
# défaite, et le rapport le dira plutôt que de choisir.
_clia_i_dev_posee() { [[ -f "$(_clia_i_config)" ]]; }
_clia_i_lien_pose() { [[ -L "$(_clia_i_lien)" ]]; }

_clia_i_dev_complete() { _clia_i_dev_posee && _clia_i_lien_pose; }

# --------------------------------------------------------------------------
# Poser et retirer
# --------------------------------------------------------------------------

# _clia_i_ecrire_config <source>
_clia_i_ecrire_config() {
  local source="$1" config
  config=$(_clia_i_config)
  mkdir -p "$(dirname "$config")" || return 1
  cat > "$config" <<FIN
# L'installation de clia, posée par « . setup.sh install --dev ».
#
# Ce fichier est écrit par clia et lu par lui. Il se retire par
# « clia setup uninstall », qui retire aussi le lien.

nature: $_CLIA_I_NATURE_DEV
source: $source
lien: $(_clia_i_lien)
FIN
}

# _clia_i_poser <source> — le lien, puis la configuration.
_clia_i_poser() {
  local source="$1" lien bin
  bin=$(_clia_i_bin_du_source "$source")
  lien=$(_clia_i_lien)

  [[ -x "$bin/clia" ]] || {
    _clia_msg "l'exécutable est introuvable : $bin/clia"
    return 1
  }

  mkdir -p "$(dirname "$lien")" || {
    _clia_msg "ce répertoire n'a pas pu être créé : $(dirname "$lien")"
    return 1
  }

  ln -sfn "$bin/clia" "$lien" || {
    _clia_msg "le lien n'a pas pu être posé : $lien"
    return 1
  }

  _clia_i_ecrire_config "$source" || {
    _clia_msg "la configuration n'a pas pu être écrite : $(_clia_i_config)"
    rm -f "$lien"
    return 1
  }
  return 0
}

# Retire ce que l'installation a posé, et rien d'autre.
_clia_i_retirer() {
  local lien config
  lien=$(_clia_i_lien)
  config=$(_clia_i_config)
  [[ -L "$lien" ]] && rm -f "$lien"
  [[ -f "$config" ]] && rm -f "$config"
  # Le répertoire de configuration n'est retiré que s'il devient vide : il
  # peut porter autre chose que ce que cette installation y a mis.
  rmdir "$(dirname "$config")" 2>/dev/null || true
  return 0
}

# --------------------------------------------------------------------------
# Le rapport
# --------------------------------------------------------------------------
#
# Rend l'installation qui répond quand on tape « clia », puis, s'il y en a
# une seconde, ce qu'elle est et qu'elle est masquée.
#
# Code de retour : 0 s'il y a une installation, 1 s'il n'y en a aucune. Un
# script peut donc en dépendre.

_clia_i_rapport() {
  local activation=0 dev=0

  [[ -n "${CLIA_INSTALLATION:-}" ]] && activation=1
  _clia_i_dev_posee && dev=1

  if (( ! activation && ! dev )); then
    _clia_msg 'aucune installation en place'
    _clia_detail 'pour ce shell seulement    : . setup.sh activate'
    _clia_detail 'pour toutes les sessions   : . setup.sh install --dev'
    return 1
  fi

  if (( activation )); then
    printf 'installation   %s\n' "$_CLIA_I_NATURE_ACTIVATION"
    printf 'durée de vie   %s\n' 'le shell courant'
    printf 'source         %s\n' "${CLIA_SOURCE_DIR:-(inconnue)}"
    printf 'portée         %s\n' "${CLIA_PORTEE:-(inconnue)}"
  else
    printf 'installation   %s\n' "$_CLIA_I_NATURE_DEV"
    printf 'durée de vie   %s\n' 'permanente, jusqu'"'"'à la désinstallation'
    printf 'source         %s\n' "$(_clia_i_champ source || printf '(inconnue)')"
    printf 'portée         %s\n' "n'importe quel dépôt git"
  fi
  printf 'commande       %s\n' "$(command -v clia 2>/dev/null || printf '(hors du PATH)')"

  if (( activation && dev )); then
    printf '\n'
    printf 'une installation %s est aussi en place, et masquée par celle-ci\n' \
      "$_CLIA_I_NATURE_DEV"
    printf '  source       %s\n' "$(_clia_i_champ source || printf '(inconnue)')"
    printf '  lien         %s\n' "$(_clia_i_champ lien || printf '(inconnu)')"
  fi

  # Une installation dev à moitié défaite ne se devine pas : elle se dit.
  if (( dev )) && ! _clia_i_lien_pose; then
    _clia_msg "la configuration décrit une installation dev dont le lien est absent"
    _clia_detail "lien attendu : $(_clia_i_lien)"
    _clia_detail "pour repartir proprement : clia setup uninstall, puis réinstallez"
  fi
  return 0
}
