#!/usr/bin/env bash
# Description: L'installation de clia — status, uninstall.
# Périmètre: aucun
# Signature: setup status
# Signature: setup uninstall
#
# Implémente SES-001 tâche 7 : « clia fournit les commandes du script setup ».
#
# Lesquelles, et pourquoi pas les autres
# --------------------------------------
#
# Une commande de clia s'exécute dans un processus fils. Elle peut donc tout
# ce qui touche au disque, et rien de ce qui touche au shell appelant.
#
#   status     lit un état          -> possible ici
#   uninstall  retire deux fichiers -> possible ici
#   activate   modifie PATH du shell appelant   -> impossible ici
#   deactivate idem                             -> impossible ici
#   install    pose des fichiers, mais son intérêt est de compléter aussi le
#              PATH du shell courant            -> reste à setup.sh
#
# Ce n'est donc pas un choix de périmètre mais une limite du système : un
# processus fils ne modifie pas l'environnement de son père. La commande le
# dit plutôt que de laisser croire qu'elle a échoué.
#
# Pourquoi « aucun » périmètre
# ----------------------------
#
# L'installation n'appartient à aucun dépôt : elle appartient au poste. Exiger
# d'être dans un dépôt git pour la retirer n'aurait aucun sens, et empêcherait
# de la retirer depuis n'importe où.

set -euo pipefail

_CLIA_NOM='clia'
# shellcheck source=../commun.sh
. "$CLIA_SOURCE_DIR/_scripts/lib/commun.sh"
# shellcheck source=../installation.sh
. "$CLIA_SOURCE_DIR/_scripts/lib/installation.sh"

# --------------------------------------------------------------------------

manuel() {
  cat <<'FIN' | _clia_man clia-setup-cmd 1 "Manuel de l'utilisateur clia"
NOM
clia-setup - consulter et retirer l'installation de clia

SYNOPSIS
clia setup status
clia setup uninstall

DESCRIPTION
L'installation de clia appartient au poste, non à un dépôt. Cette
commande la consulte et la retire.

Elle ne l'installe pas, et n'active ni ne désactive : poser une
installation dev complète le PATH du shell courant, et une activation
est faite tout entière de variables d'environnement. Un processus
fils ne peut modifier ni l'un ni l'autre chez son père. Ces gestes
appartiennent donc à setup.sh, qui se source. Voir clia-setup(1) pour
eux.

SOUS-COMMANDES
status
       Rapporte l'installation qui répond quand on tape clia : sa
       nature, sa durée de vie, sa source, sa portée, et le chemin
       de la commande.

       Quand une activation et une installation dev sont toutes deux
       en place, l'activation l'emporte et la seconde est nommée
       comme masquée.

       Rend 1 quand il n'y a aucune installation, pour qu'un script
       puisse en dépendre.

uninstall
       Retire l'installation dev : son lien et sa configuration, et
       rien d'autre. Le répertoire de configuration n'est retiré que
       s'il devient vide.

       Une activation n'est pas retirée par cette commande — elle
       vit dans le shell appelant. Quand il y en a une, uninstall le
       dit et nomme le geste qui la défait.

       Sans installation dev en place, la commande le dit et
       réussit : l'état voulu est déjà celui-là.

       Un lien qui ne mène pas là où la configuration l'annonce
       n'est pas retiré : il appartient à autre chose.

CODE DE RETOUR
0
       La demande est satisfaite, même s'il n'y avait rien à faire.

1
       Pour status, aucune installation en place. Pour uninstall, un
       refus : un lien qui n'est pas celui de cette installation.

2
       Demande mal formée.

FICHIERS
~/.local/bin/clia
       Le lien de l'installation dev. CLIA_BIN_DIR le déplace.

~/.config/clia/installation.yaml
       Ce que l'installation dev déclare. XDG_CONFIG_HOME le
       déplace.

EXEMPLES
Voir ce qui est en place :

       $ clia setup status
       installation   dev
       durée de vie   permanente, jusqu'à la désinstallation
       source         /home/moi/git/clia
       portée         n'importe quel dépôt git

Retirer l'installation :

       $ clia setup uninstall

VOIR AUSSI
clia(1), clia-setup(1), clia-check(1)
FIN
}

# --------------------------------------------------------------------------

retirer() {
  local lien config attendu reel activation=0

  [[ -n "${CLIA_INSTALLATION:-}" ]] && activation=1

  if ! _clia_i_dev_posee; then
    _clia_msg "aucune installation dev en place : il n'y a rien à retirer"
    if (( activation )); then
      _clia_detail "une activation est en place ; elle se défait par :"
      _clia_detail "  . setup.sh deactivate"
    fi
    return 0
  fi

  lien=$(_clia_i_lien)
  config=$(_clia_i_config)

  # Le lien n'est retiré que s'il est bien celui que la configuration
  # annonce. Un autre lien appartient à autre chose, et le retirer ferait
  # disparaître une installation que celle-ci n'a pas posée.
  if [[ -L "$lien" ]]; then
    attendu=$(_clia_i_champ lien || printf '')
    reel=$(readlink -f "$lien" 2>/dev/null || printf '')
    if [[ -n "$attendu" && "$attendu" != "$lien" ]]; then
      _clia_msg "la configuration annonce un autre lien : $attendu"
      _clia_detail "celui-ci n'est pas retiré : $lien"
      return 1
    fi
    if [[ -n "$reel" && "$reel" != */_scripts/bin/clia ]]; then
      _clia_msg "ce lien ne mène pas à un exécutable clia : $lien"
      _clia_detail "il mène à : $reel"
      _clia_detail "il n'est pas retiré ; retirez-le vous-même si c'est un reste"
      return 1
    fi
  fi

  _clia_i_retirer

  _clia_msg 'installation retirée'
  _clia_detail "lien   $lien"
  _clia_detail "config $config"

  if (( activation )); then
    _clia_detail ''
    _clia_detail "une activation reste en place dans ce shell ; pour la défaire :"
    _clia_detail "  . setup.sh deactivate"
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
    _clia_msg 'clia setup attend un verbe'
    _clia_detail "l'usage : clia setup --help"
    exit 2 ;;

  status)
    [[ $# -eq 1 ]] || { _clia_msg "status ne prend pas d'argument : ${*:2}"; exit 2; }
    _clia_i_rapport ;;

  uninstall)
    [[ $# -eq 1 ]] || { _clia_msg "uninstall ne prend pas d'argument : ${*:2}"; exit 2; }
    retirer ;;

  activate|deactivate|install)
    _clia_msg "« $1 » modifie le shell courant : clia ne peut pas le faire"
    _clia_detail "un processus fils ne modifie pas l'environnement de son père"
    _clia_detail "lancez plutôt : . setup.sh $1"
    exit 1 ;;

  *)
    _clia_msg "verbe inconnu : $1"
    _clia_detail "l'usage : clia setup --help"
    exit 2 ;;
esac
