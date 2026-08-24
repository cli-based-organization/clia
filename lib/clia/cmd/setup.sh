#!/usr/bin/env bash
# Description: L'installation de clia — status, uninstall.
# Périmètre: aucun
#
# La pose de l'installation appartient à setup.sh du dépôt source ; ce module
# porte ce qui vient après : dire ce qui est en place, et le retirer. Voir
# .dev/usages/USE-001-installer-clia.md.

set -uo pipefail

_CLIA_NOM='clia'
# shellcheck source=../commun.sh
. "$CLIA_SOURCE_DIR/lib/clia/commun.sh"

# --------------------------------------------------------------------------

_clia_status() {
  local mode
  mode=$(_clia_mode_constate)

  printf 'mode            %s\n' "$mode"
  printf 'version         %s\n' "$_CLIA_VERSION"
  printf 'dépôt source    %s\n' "$CLIA_SOURCE_DIR"

  case "$mode" in
    activate)
      printf 'portée          ce shell, et le dépôt source seulement\n'
      printf 'sur le disque   rien\n'
      ;;
    dev)
      printf 'portée          toute session, et tout dépôt git\n'
      printf 'lien            %s\n' "$(_clia_config_valeur lien 2>/dev/null || _clia_lien)"
      printf 'configuration   %s\n' "$(_clia_config_fichier)"
      printf 'installé le     %s\n' "$(_clia_config_valeur installe-le 2>/dev/null || printf 'inconnu')"
      ;;
    direct)
      printf 'portée          cette invocation seulement\n'
      printf 'sur le disque   rien\n'
      printf 'exécutable      %s\n' "${CLIA_EXECUTABLE:-inconnu}"
      # Deux situations mènent ici, et elles se disent de la même façon :
      # l'appel par le chemin, et un PATH que clia n'a pas écrit lui-même.
      printf 'note            aucune installation déclarée par setup.sh\n'
      ;;
  esac
  return 0
}

# La fonctionnalité inverse de setup.sh, et son exacte réciproque : ce qui a
# été posé sur le disque est retiré, et rien d'autre. Une activation de shell
# n'a rien posé sur le disque — elle ne peut donc pas être retirée d'ici, et
# le dire vaut mieux que faire croire au contraire.
_clia_uninstall() {
  local conf lien source_declaree retire=0
  conf=$(_clia_config_fichier)

  if [[ -f "$conf" ]]; then
    lien=$(_clia_config_valeur lien 2>/dev/null) || lien=$(_clia_lien)
    source_declaree=$(_clia_config_valeur source 2>/dev/null) || source_declaree=''

    if [[ -L "$lien" ]]; then
      local cible
      cible=$(readlink "$lien")
      if [[ "$cible" == "$source_declaree/bin/clia" || "$cible" == "$CLIA_SOURCE_DIR/bin/clia" ]]; then
        rm -f "$lien" && retire=1
        _clia_msg "lien retiré : $lien"
      else
        _clia_msg "$lien pointe ailleurs que sur ce dépôt, il est laissé en place"
        _clia_detail "cible : $cible"
      fi
    elif [[ -e "$lien" ]]; then
      _clia_msg "$lien n'est pas un lien symbolique, il est laissé en place"
      _clia_detail "clia ne retire que ce qu'il a posé"
    fi

    rm -f "$conf" && _clia_msg "configuration retirée : $conf"
    rmdir "$(_clia_config_dir)" 2>/dev/null
    retire=1
  fi

  # L'activation vit dans les variables du shell appelant. Un processus fils
  # ne peut pas les modifier : seule la commande sourcée le peut.
  if [[ "${CLIA_MODE:-}" == 'activate' ]]; then
    _clia_msg "ce shell porte une activation, qu'une commande ne peut pas défaire"
    _clia_detail "lancez, depuis $CLIA_SOURCE_DIR :"
    _clia_detail "  . setup.sh deactivate"
    _clia_detail "fermer ce terminal produit le même effet"
    return 1
  fi

  if (( retire == 0 )); then
    _clia_msg "aucune installation posée par setup.sh n'a été trouvée"
    _clia_detail "rien à retirer"

    # La commande peut rester disponible sans que clia l'ait installée : un
    # PATH modifié à la main, ou une version antérieure. Taire ce fait
    # laisserait croire que la post-condition « clia n'est plus accessible »
    # est atteinte, alors qu'elle ne l'est pas.
    local ailleurs
    ailleurs=$(command -v clia 2>/dev/null)
    if [[ -n "$ailleurs" ]]; then
      _clia_detail ''
      _clia_detail "la commande clia reste pourtant disponible : $ailleurs"
      _clia_detail "elle vient de votre PATH, ou d'un fichier de configuration de"
      _clia_detail "votre shell. clia ne retire pas ce qu'il n'a pas posé."
    fi
    return 0
  fi

  _clia_msg "clia est désinstallé"
  _clia_detail "ce shell peut garder le chemin en cache ; au besoin : hash -r"
  return 0
}

_clia_aide() {
  cat <<'EOF'
Usage : clia setup <verbe>

Verbes :
  status      ce que l'installation en place est, et où elle vit
  uninstall   retire l'installation : le lien, et sa configuration

L'installation, elle, appartient à setup.sh du dépôt source :
  . setup.sh install --activate    ce shell, et le dépôt source seulement
  . setup.sh install --dev         toute session, et tout dépôt git

Une activation de shell n'écrit rien sur le disque : uninstall ne peut donc
pas la défaire. C'est . setup.sh deactivate qui s'en charge, ou la fermeture
du terminal.
EOF
}

case "${1:-}" in
  status)            _clia_status ;;
  uninstall)         _clia_uninstall ;;
  ''|-h|--help|help) _clia_aide ;;
  *)
    _clia_msg "verbe inconnu pour setup : $1"
    _clia_detail "les verbes connus : status, uninstall"
    exit 2 ;;
esac
