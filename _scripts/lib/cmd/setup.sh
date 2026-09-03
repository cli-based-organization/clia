#!/usr/bin/env bash
# Description: L'installation de clia — status, version, uninstall.
# Périmètre: aucun
# Signature: setup status
# Signature: setup version
# Signature: setup version ls
# Signature: setup config ls
# Signature: setup config set CLE VALEUR
# Signature: setup uninstall
#
# Implémente SES-001 tâches 7 et 17.
#
# Pourquoi « setup version » et non « clia version »
# --------------------------------------------------
#
# SES-001 tâche 17 : « clia agit sur le repo dans lequel on se trouve. Donc,
# clia version donne la version du repo courant. » La version du CLI qui
# exécute la commande est autre chose, et c'est une propriété de
# l'installation — d'où sa place ici.
#
# Les deux coïncident dans le dépôt source de clia, et divergent partout
# ailleurs. Les confondre ferait croire qu'un dépôt suit la version de l'outil
# qui l'instrumente, ce qui est précisément ce que la tâche 17 défait.
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
# shellcheck source=../generation.sh
. "$CLIA_SOURCE_DIR/_scripts/lib/generation.sh"
# shellcheck source=../installation.sh
. "$CLIA_SOURCE_DIR/_scripts/lib/installation.sh"
# shellcheck source=../version.sh
. "$CLIA_SOURCE_DIR/_scripts/lib/version.sh"
# shellcheck source=../maj.sh
. "$CLIA_SOURCE_DIR/_scripts/lib/maj.sh"

# --------------------------------------------------------------------------

manuel() {
  cat <<'FIN' | _clia_man clia-setup-cmd 1 "Manuel de l'utilisateur clia"
NOM
clia-setup - consulter et retirer l'installation de clia

SYNOPSIS
clia setup status
clia setup version [ls]
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

version [ls]
       Sans argument, la version du CLI qui répond — celle du dépôt
       source d'où il vient.

       Ce n'est pas la version du dépôt où l'on travaille, que
       « clia version » rend. Les deux coïncident dans le dépôt
       source de clia, et divergent partout ailleurs.

       Avec « ls », toutes les versions que l'historique du dépôt
       source déclare, la plus récente d'abord. Une flèche marque
       celle du CLI.

       Une version est disponible quand un commit la déclare : il
       n'y a pas de registre ailleurs, ni d'étiquettes. clia ne peut
       donc offrir que les versions dont il a l'historique.

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
clia(1), clia-version(1), clia-upgrade(1), clia-check(1)
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
# La configuration de l'utilisateur — SES-001 tâche 23
# --------------------------------------------------------------------------
#
# Le niveau le plus lointain des quatre qui règlent une génération. Il
# appartient à l'utilisateur, non au dépôt : il suit la personne d'un dépôt à
# l'autre, et n'est donc pas versionné.
#
#   ${XDG_CONFIG_HOME:-~/.config}/clia/config.yaml
#
# Les clés y sont écrites en clair, telles que l'énoncé les nomme :
# « make.policy.ressource.version ». Ce qui est rangé dessous est le même
# bloc que dans une carte de dépôt — « make-politiques: » — pour qu'un seul
# lecteur serve les quatre niveaux.

CONFIG_PREFIXE='make.policy.'

config_fichier() { _clia_g_config_utilisateur; }

config_ls() {
  local fichier nom valeur
  fichier=$(config_fichier)
  { printf 'CLE%sVALEUR\n' "$_CLIA_SEP"
    while IFS="$_CLIA_SEP" read -r nom valeur; do
      [[ -n "$nom" ]] || continue
      printf '%s%s%s%s\n' "$CONFIG_PREFIXE" "$nom" "$_CLIA_SEP" "$valeur"
    done < <(_clia_bloc_yaml "$fichier" 'make-politiques' nom valeur)
  } | column -t -s "$_CLIA_SEP"

  if [[ -f "$fichier" ]]; then
    _clia_msg "lu dans $fichier"
  else
    _clia_msg "aucune configuration d'utilisateur : $fichier"
    _clia_detail "elle sera posée à la première écriture"
  fi
  _clia_detail "ce qui s'applique vraiment : clia make policy ls"
  return 0
}

config_set() {
  local cle="$1" valeur="$2" fichier nom
  fichier=$(config_fichier)

  if [[ "$cle" != "$CONFIG_PREFIXE"* ]]; then
    _clia_msg "clé inconnue : $cle"
    _clia_detail "les clés de configuration commencent par « $CONFIG_PREFIXE »"
    _clia_detail "celles qui existent : ${CONFIG_PREFIXE}ressource.version"
    return 2
  fi
  nom="${cle#"$CONFIG_PREFIXE"}"

  if [[ " $_CLIA_G_POLITIQUES " != *" $nom "* ]]; then
    _clia_msg "politique inconnue : $nom"
    _clia_detail "celles qui existent : $_CLIA_G_POLITIQUES"
    return 2
  fi
  if ! _clia_g_valeur_admise "$nom" "$valeur"; then
    _clia_msg "valeur inconnue pour $nom : $valeur"
    _clia_detail "valeurs admises : $_CLIA_G_VERSION_VALEURS"
    return 2
  fi

  mkdir -p "$(dirname "$fichier")"
  _clia_g_politique_poser "$fichier" "$nom" "$valeur" || return 1
  _clia_msg "$cle = $valeur, pour cet utilisateur"
  _clia_detail "inscrit dans $fichier"
  _clia_detail "un dépôt ou une ressource peut en poser une autre, et elle l'emporte"
  return 0
}

# --------------------------------------------------------------------------
# Dispatch
# --------------------------------------------------------------------------

# --------------------------------------------------------------------------
# La version du CLI, et celles qu'il porte
# --------------------------------------------------------------------------
#
# Une version est disponible quand un commit du dépôt source la déclare. Il
# n'y a pas de registre ailleurs, ni d'étiquettes — SES-001 tâche 2 pose que
# la publication n'en met aucune. clia ne peut donc offrir que les versions
# dont il a l'historique sous la main, et le dire vaut mieux que promettre
# celles qu'il n'a pas.

version_du_cli() {
  local carte resolu commit alias etat court

  carte=$(_clia_carte_relative "$CLIA_SOURCE_DIR") || {
    _clia_msg "le dépôt source de clia ne porte pas de carte"
    _clia_detail "source : $CLIA_SOURCE_DIR"
    return 1
  }

  if ! resolu=$(_clia_v_resoudre "$CLIA_SOURCE_DIR" '' "$carte"); then
    _clia_msg "le dépôt source de clia n'a pas de version adossée à un commit"
    _clia_detail "source : $CLIA_SOURCE_DIR"
    return 1
  fi
  IFS=$'\t' read -r commit alias etat <<<"$resolu"
  court=$(git -C "$CLIA_SOURCE_DIR" rev-parse --short "$commit")

  _clia_v_alias_affiche "$alias" "$etat" "$court"
  _clia_msg "le CLI vient de $CLIA_SOURCE_DIR"
  _clia_detail "la version du dépôt où vous travaillez : clia version"
  return 0
}

lister_versions() {
  local carte courant v c marque lignes=''

  carte=$(_clia_carte_relative "$CLIA_SOURCE_DIR") || {
    _clia_msg "le dépôt source de clia ne porte pas de carte"
    return 1
  }
  courant=$(_clia_v_alias_disque "$CLIA_SOURCE_DIR/$carte" || printf '')

  # La plus récente d'abord : c'est celle qu'on cherche le plus souvent, et
  # une liste qui grandit par le bas finirait par la reléguer hors de l'écran.
  while IFS=$'\t' read -r v c; do
    [[ -n "$v" ]] || continue
    if [[ "$v" == "$courant" ]]; then marque='->'; else marque='  '; fi
    lignes=$(printf '%s\t%s\t%s' \
      "$marque" "$v" "$(git -C "$CLIA_SOURCE_DIR" rev-parse --short "$c")")$'\n'"$lignes"
  done < <(_clia_m_versions "$CLIA_SOURCE_DIR" "$carte")

  if [[ -z "$lignes" ]]; then
    _clia_msg "aucune version publiée dans l'historique du dépôt source"
    _clia_detail "source : $CLIA_SOURCE_DIR"
    return 1
  fi

  { printf '\tVERSION\tCOMMIT\n'
    printf '%s' "$lignes"
  } | column -t -s $'\t'

  _clia_msg "la plus récente d'abord ; la flèche marque celle du CLI"
  _clia_detail "pour y amener un dépôt : clia upgrade [VERSION]"
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

  version)
    case "${2:-}" in
      '')   version_du_cli ;;
      ls)   [[ $# -eq 2 ]] || { _clia_msg "ls ne prend pas d'argument : ${*:3}"; exit 2; }
            lister_versions ;;
      *)    _clia_msg "verbe inconnu pour version : $2"
            _clia_detail "l'usage : clia setup version [ls]"
            exit 2 ;;
    esac ;;

  config)
    case "${2:-ls}" in
      ls)  [[ $# -le 2 ]] || { _clia_msg "config ls ne prend pas d'argument : ${*:3}"; exit 2; }
           config_ls ;;
      set) [[ $# -eq 4 ]] || {
             _clia_msg "config set attend une clé et une valeur"
             _clia_detail "l'usage : clia setup config set CLE VALEUR"; exit 2; }
           config_set "$3" "$4" ;;
      *)   _clia_msg "config n'accepte que « ls » ou « set » : $2"
           _clia_detail "l'usage : clia setup --help"
           exit 2 ;;
    esac ;;

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
