#!/usr/bin/env bash
# setup.sh — rendre la commande clia disponible à un utilisateur.
#
# Deux modes, qui diffèrent par deux choses : la durée de la disponibilité,
# et le périmètre d'exécution permis.
#
#   --activate   le shell courant seulement, et seul le dépôt source est
#                exploitable. Rien n'est écrit sur le disque : fermer le
#                terminal suffit à défaire l'activation.
#
#   --dev        les sessions suivantes aussi, par un lien symbolique dans
#                le répertoire des exécutables de l'utilisateur. clia
#                s'exécute alors dans le dépôt git courant, quel qu'il soit,
#                mais le code employé reste celui de ce dépôt-ci — non une
#                copie. Modifier le source change immédiatement la commande.
#
# Usage :
#   . setup.sh install --activate    active clia dans ce shell
#   . setup.sh activate              raccourci de la ligne précédente
#   . setup.sh install --dev         installe clia pour l'utilisateur
#   . setup.sh deactivate            retire l'activation du shell courant
#   ./setup.sh help
#
# --force lève le refus opposé quand la commande clia est déjà disponible.
#
# La désinstallation, elle, appartient au CLI : clia setup uninstall. Voir
# .dev/usages/USE-001-installer-clia.md, dont ce fichier est l'implémentation.

_CLIA_NOM='setup'

# --------------------------------------------------------------------------
# Amorçage
# --------------------------------------------------------------------------

# Sourcé, ou exécuté ? activate, deactivate et l'ajout au PATH modifient le
# shell appelant : un processus fils ne peut pas le faire pour son père.
if [[ -n "${BASH_SOURCE[0]:-}" && "${BASH_SOURCE[0]}" != "${0}" ]]; then
  _clia_source=1
else
  _clia_source=0
fi

_clia_racine=$(cd -P "$(dirname "${BASH_SOURCE[0]}")" >/dev/null 2>&1 && pwd)

if [[ ! -f "$_clia_racine/lib/clia/commun.sh" ]]; then
  printf 'setup: lib/clia/commun.sh est introuvable sous %s\n' "$_clia_racine" >&2
  printf '       lancez setup.sh depuis le dépôt clia, sans le déplacer\n' >&2
  return 1 2>/dev/null || exit 1
fi

# shellcheck source=lib/clia/commun.sh
. "$_clia_racine/lib/clia/commun.sh"

# --------------------------------------------------------------------------
# Prérequis
# --------------------------------------------------------------------------

_clia_prerequis() {
  local manque=0 outil

  if (( BASH_VERSINFO[0] < 4 )); then
    _clia_msg "bash 4 ou plus est requis, version détectée : ${BASH_VERSION}"
    manque=1
  fi

  local absents=()
  for outil in git grep sed awk ln readlink dirname mktemp; do
    command -v "$outil" >/dev/null 2>&1 || absents+=("$outil")
  done
  if (( ${#absents[@]} > 0 )); then
    _clia_msg "outils absents : ${absents[*]}"
    manque=1
  fi

  if [[ ! -f "$_clia_racine/bin/clia" ]]; then
    _clia_msg "bin/clia est introuvable sous $_clia_racine"
    manque=1
  elif [[ ! -x "$_clia_racine/bin/clia" ]]; then
    chmod +x "$_clia_racine/bin/clia" 2>/dev/null || {
      _clia_msg "bin/clia n'est pas exécutable, et chmod a échoué"
      manque=1
    }
  fi

  return $manque
}

# --------------------------------------------------------------------------
# Le scénario 2 : la commande clia est déjà disponible
# --------------------------------------------------------------------------
#
# L'usage demande de ne rien modifier, de dire ce que l'installation
# changerait, et de sortir en erreur. Une installation silencieuse par-dessus
# une autre laisserait l'utilisateur avec une commande dont il ne sait plus
# d'où elle vient, ni quelle version elle sert.

_clia_refus_deja_disponible() {
  local mode_vise="$1" chemin_vise="$2"
  local chemin_actuel version_actuelle mode_actuel

  chemin_actuel=$(command -v clia 2>/dev/null) || return 0
  [[ -n "$chemin_actuel" ]] || return 0

  version_actuelle=$("$chemin_actuel" --version 2>/dev/null) || version_actuelle='inconnue'
  mode_actuel=$(_clia_mode_constate)

  _clia_msg "la commande clia est déjà disponible, rien n'a été modifié"
  _clia_detail "trouvée   : $chemin_actuel"
  [[ -L "$chemin_actuel" ]] && _clia_detail "            lien vers $(readlink "$chemin_actuel")"
  _clia_detail "mode      : $mode_actuel"
  _clia_detail "version   : $version_actuelle"

  # Ce que l'installation demandée impliquerait de différent, et rien d'autre :
  # une différence tue est une surprise, une différence nommée est un choix.
  local ecarts=()
  [[ "$mode_actuel"    != "$mode_vise"      ]] && ecarts+=("mode        $mode_actuel -> $mode_vise")
  [[ "$chemin_actuel"  != "$chemin_vise"    ]] && ecarts+=("emplacement $chemin_actuel -> $chemin_vise")
  [[ "$version_actuelle" != "$_CLIA_VERSION" ]] && ecarts+=("version     $version_actuelle -> $_CLIA_VERSION")

  if (( ${#ecarts[@]} > 0 )); then
    _clia_detail ''
    _clia_detail "l'installation demandée impliquerait :"
    local e
    for e in "${ecarts[@]}"; do _clia_detail "  $e"; done
  else
    _clia_detail ''
    _clia_detail "l'installation demandée est identique à celle en place"
  fi

  # Ce qui retire l'installation en place dépend de qui l'a posée. Renvoyer
  # vers clia setup uninstall dans tous les cas serait faux : cette commande
  # ne retire que ce que ce setup.sh a posé, et le dire autrement enverrait
  # l'utilisateur vers une commande qui répondra « rien à retirer ».
  _clia_detail ''
  _clia_detail "pour l'appliquer malgré tout : --force"
  case "$mode_actuel" in
    dev)
      _clia_detail "pour retirer celle en place   : clia setup uninstall" ;;
    activate)
      _clia_detail "pour retirer celle en place   : . setup.sh deactivate" ;;
    *)
      _clia_detail "celle en place n'a pas été posée par ce setup.sh : elle vient de"
      _clia_detail "votre PATH, ou d'un fichier de configuration de votre shell."
      _clia_detail "clia ne retire pas ce qu'il n'a pas posé ; à vous de le faire." ;;
  esac
  return 1
}

# --------------------------------------------------------------------------
# Mode --activate
# --------------------------------------------------------------------------

_clia_activate() {
  local force="$1"

  if (( _clia_source == 0 )); then
    _clia_msg "activate doit être sourcé pour modifier le shell courant"
    _clia_detail "lancez : . setup.sh activate"
    return 2
  fi

  _clia_prerequis || return 1

  if (( force == 0 )); then
    _clia_refus_deja_disponible activate "$_clia_racine/bin/clia" || return 1
  fi

  export CLIA_HOME="$_clia_racine"
  export CLIA_MODE='activate'

  # Idempotent : une seconde activation ne dépose pas un second chemin.
  case ":${PATH}:" in
    *":$_clia_racine/bin:"*) ;;
    *) export PATH="$_clia_racine/bin:$PATH" ;;
  esac
  hash -r 2>/dev/null

  _clia_msg "clia est actif dans ce shell"
  _clia_detail "version      : $_CLIA_VERSION"
  _clia_detail "dépôt source : $CLIA_HOME"
  _clia_detail "portée       : ce shell, et ce dépôt seulement"
  _clia_detail "fermer ce terminal suffit à défaire l'activation ;"
  _clia_detail "avant cela : . setup.sh deactivate"
  return 0
}

_clia_deactivate() {
  if (( _clia_source == 0 )); then
    _clia_msg "deactivate doit être sourcé pour modifier le shell courant"
    _clia_detail "lancez : . setup.sh deactivate"
    return 2
  fi

  if [[ -z "${CLIA_MODE:-}" ]]; then
    _clia_msg "aucune activation dans ce shell"
    if _clia_config_existe; then
      _clia_detail "une installation persistante existe, elle : clia setup uninstall"
    fi
    return 0
  fi

  local reste='' part
  local IFS=':'
  for part in $PATH; do
    [[ "$part" == "${CLIA_HOME:-}/bin" ]] && continue
    reste="${reste:+$reste:}$part"
  done
  export PATH="$reste"
  unset CLIA_HOME CLIA_MODE
  hash -r 2>/dev/null

  _clia_msg "clia est retiré de ce shell"
  return 0
}

# --------------------------------------------------------------------------
# Mode --dev
# --------------------------------------------------------------------------
#
# Un lien symbolique, et un fichier qui dit ce qui a été fait. Rien d'autre :
# aucun fichier de configuration du shell n'est modifié. Ce que setup.sh a
# posé, clia setup uninstall sait le retirer, et lui seul.

_clia_install_dev() {
  local force="$1"
  local bindir lien conf
  bindir=$(_clia_bin_dir)
  lien=$(_clia_lien)
  conf=$(_clia_config_fichier)

  _clia_prerequis || return 1

  if (( force == 0 )); then
    _clia_refus_deja_disponible dev "$lien" || return 1
  fi

  # Non-intrusivité : --force autorise à remplacer une installation de clia,
  # jamais à écraser un fichier que clia n'a pas posé. Le distinguo tient au
  # fait qu'un lien est réversible et qu'un fichier régulier ne l'est pas.
  if [[ -e "$lien" || -L "$lien" ]]; then
    if [[ ! -L "$lien" ]]; then
      _clia_msg "$lien existe et n'est pas un lien symbolique"
      _clia_detail "clia ne remplace pas un fichier qu'il n'a pas posé, même avec --force"
      _clia_detail "retirez-le vous-même, puis relancez l'installation"
      return 1
    fi
  fi

  mkdir -p "$bindir" || { _clia_msg "impossible de créer $bindir"; return 1; }
  ln -sfn "$_clia_racine/bin/clia" "$lien" || {
    _clia_msg "impossible de poser le lien $lien"
    return 1
  }

  mkdir -p "$(_clia_config_dir)" || { _clia_msg "impossible de créer $(_clia_config_dir)"; return 1; }
  {
    printf '# écrit par setup.sh, lu par clia. Retiré par clia setup uninstall.\n'
    printf 'mode=dev\n'
    printf 'source=%s\n' "$_clia_racine"
    printf 'lien=%s\n' "$lien"
    printf 'version=%s\n' "$_CLIA_VERSION"
    printf 'installe-le=%s\n' "$(date -Iseconds 2>/dev/null || date)"
  } > "$conf" || { _clia_msg "impossible d'écrire $conf"; return 1; }

  _clia_msg "clia est installé pour $(id -un 2>/dev/null || printf 'cet utilisateur')"
  _clia_detail "version      : $_CLIA_VERSION"
  _clia_detail "lien         : $lien -> $_clia_racine/bin/clia"
  _clia_detail "dépôt source : $_clia_racine"
  _clia_detail "portée       : toute session, et tout dépôt git"

  # Le lien ne sert à rien si son répertoire n'est pas cherché. On le dit,
  # et on ne modifie aucun fichier de l'utilisateur pour le corriger.
  case ":${PATH}:" in
    *":$bindir:"*) ;;
    *)
      _clia_detail ''
      _clia_detail "$bindir n'est pas dans votre PATH"
      if (( _clia_source == 1 )); then
        export PATH="$bindir:$PATH"
        hash -r 2>/dev/null
        _clia_detail "il y est ajouté pour ce shell. Pour les suivants, ajoutez à ~/.bashrc :"
      else
        _clia_detail "ajoutez à ~/.bashrc, puis ouvrez un nouveau terminal :"
      fi
      _clia_detail "  export PATH=\"$bindir:\$PATH\""
      ;;
  esac
  return 0
}

# --------------------------------------------------------------------------
# Aide
# --------------------------------------------------------------------------

_clia_aide() {
  cat <<EOF
setup.sh $_CLIA_VERSION — rendre la commande clia disponible

Dépôt source détecté : $_clia_racine

Commandes :
  . setup.sh install --activate   active clia dans ce shell
  . setup.sh activate             raccourci de install --activate
  . setup.sh install --dev        installe clia pour l'utilisateur
  . setup.sh deactivate           retire l'activation de ce shell
  ./setup.sh help                 cette aide
  ./setup.sh version              la version de clia

Les deux modes :

  --activate  ce shell seulement, et seul le dépôt source est exploitable.
              Rien n'est écrit sur le disque.

  --dev       les sessions suivantes aussi, par un lien symbolique dans
              $(_clia_bin_dir).
              clia s'exécute alors dans le dépôt git courant, quel qu'il
              soit, en employant le code de ce dépôt-ci, non une copie.

Option :
  --force     installe même si la commande clia est déjà disponible.

Le point qui précède . setup.sh n'est pas décoratif : activate, deactivate
et l'ajout au PATH modifient le shell courant, ce qu'un fichier exécuté dans
un processus fils ne peut pas faire.

Pour désinstaller, c'est le CLI qui s'en charge :
  clia setup uninstall

Codes de retour :
  0  la demande est satisfaite
  1  refus : prérequis absent, ou commande clia déjà disponible
  2  demande mal formée
EOF
}

# --------------------------------------------------------------------------
# Dispatch
# --------------------------------------------------------------------------

_clia_main() {
  local commande="${1:-help}" force=0 mode=''
  shift 2>/dev/null || true

  case "$commande" in
    activate)   mode='activate' ;;
    deactivate) mode='deactivate' ;;
    install)    mode='' ;;
    help|--help|-h)      _clia_aide; return 0 ;;
    version|--version|-v) printf '%s\n' "$_CLIA_VERSION"; return 0 ;;
    *)
      _clia_msg "commande inconnue : $commande"
      _clia_detail "les commandes connues : install, activate, deactivate, help, version"
      return 2 ;;
  esac

  local arg
  for arg in "$@"; do
    case "$arg" in
      --force)    force=1 ;;
      --activate) mode='activate' ;;
      --dev)      mode='dev' ;;
      *)
        _clia_msg "option inconnue : $arg"
        _clia_detail "les options connues : --activate, --dev, --force"
        return 2 ;;
    esac
  done

  case "$mode" in
    activate)   _clia_activate "$force" ;;
    dev)        _clia_install_dev "$force" ;;
    deactivate) _clia_deactivate ;;
    '')
      # Deviner le mode à la place de l'humain serait pire que le lui
      # demander : les deux modes n'ont ni la même durée, ni le même
      # périmètre. PDC-004.
      _clia_msg "install attend un mode"
      _clia_detail ". setup.sh install --activate   ce shell, ce dépôt, rien sur le disque"
      _clia_detail ". setup.sh install --dev        toute session, tout dépôt git"
      return 2 ;;
  esac
}

# --------------------------------------------------------------------------
# Nettoyage
# --------------------------------------------------------------------------
#
# Sourcer un fichier dépose ses fonctions dans le shell de l'utilisateur.
# Celles-ci en repartent : seules les variables exportées, qui sont le
# produit demandé, restent. La fonction se retire elle-même en dernier, son
# corps étant déjà chargé.

_clia_sortir() {
  local rc="$1" noms
  noms=$(compgen -A function _clia_ 2>/dev/null | grep -vx '_clia_sortir')
  [[ -n "$noms" ]] && unset -f $noms
  noms=$(compgen -v _clia_ 2>/dev/null)
  [[ -n "$noms" ]] && unset $noms
  unset _CLIA_VERSION _CLIA_NOM
  unset -f _clia_sortir
  return "$rc"
}

_clia_main "$@"
_clia_sortir "$?"
