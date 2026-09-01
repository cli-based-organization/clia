# shellcheck shell=bash
# setup.sh — la gestion d'une installation de clia.
#
# Ce qu'est une installation
# --------------------------
#
# SES-001 tâche 4 la définit en trois parties :
#
#   1. un programme — ici le CLI clia ;
#   2. l'ensemble des variables d'environnement décrivant son mode
#      d'intégration dans le système hôte ;
#   3. l'ensemble des options modulant son fonctionnement.
#
# Et lui donne trois propriétés, qui sont ce que « status » rapporte :
#
#   durée de vie   jusqu'à quand elle vaut
#   source         d'où vient l'exécutable et ses fichiers de support
#   portée         sur quoi elle est utilisable
#
# L'activation
# ------------
#
# Une activation est l'installation la plus légère : sa durée de vie est
# celle du shell courant, sa source est le dépôt où vit ce script, et sa
# portée est un seul dépôt de travail.
#
#   . setup.sh [-C ROOT_PATH] activate
#
# Rien n'est écrit sur le disque. Fermer le terminal suffit à la défaire, et
# c'est ce qui la rend sans risque : il n'existe aucun état à nettoyer, donc
# aucun état à oublier de nettoyer.
#
# Pourquoi il faut la sourcer
# ---------------------------
#
# Une activation modifie PATH et pose des variables d'environnement dans le
# shell appelant. Un processus fils ne peut pas le faire pour son père : le
# script doit donc être sourcé, et il refuse plutôt que de paraître réussir.
#
# Pourquoi ce fichier n'active pas « set -euo pipefail »
# ------------------------------------------------------
#
# Ces options appartiendraient au shell de l'utilisateur, puisque ce fichier
# y est sourcé. Une commande qui échoue fermerait alors son terminal. Le
# fichier est donc écrit sans elles, et vérifie ses erreurs explicitement.
#
# Pour la même raison, tout ce qu'il déclare porte le préfixe _clia_ et est
# retiré du shell avant de rendre la main : un shell interactif ne doit rien
# garder de clia qu'il n'ait demandé, hors les variables exportées, qui sont
# précisément l'installation.

# --------------------------------------------------------------------------
# Amorçage
# --------------------------------------------------------------------------

# Sourcé, ou exécuté ? Les deux sont permis, mais pas pour les mêmes verbes.
if [[ -n "${BASH_SOURCE[0]:-}" && "${BASH_SOURCE[0]}" != "${0}" ]]; then
  _clia_source=1
else
  _clia_source=0
fi

_clia_racine=$(cd -P "$(dirname "${BASH_SOURCE[0]}")" >/dev/null 2>&1 && pwd)

if [[ ! -f "$_clia_racine/_scripts/lib/commun.sh" ]]; then
  printf 'setup: _scripts/lib/commun.sh est introuvable sous %s\n' "$_clia_racine" >&2
  printf '       lancez setup.sh depuis le dépôt clia, sans le déplacer\n' >&2
  if (( _clia_source )); then return 1; else exit 1; fi
fi

_CLIA_NOM='setup'
# shellcheck source=_scripts/lib/commun.sh
. "$_clia_racine/_scripts/lib/commun.sh"
# shellcheck source=_scripts/lib/installation.sh
. "$_clia_racine/_scripts/lib/installation.sh"

# --------------------------------------------------------------------------
# Documentation
# --------------------------------------------------------------------------
#
# Même contrat que les commandes du CLI, posé par SES-001 tâche 3 : l'aide
# brève ne porte que des signatures et des options, et le manuel porte ce qui
# explique.

_clia_setup_aide() {
  printf 'Usage :\n'
  printf '  . setup.sh [-C ROOT_PATH] activate\n'
  printf '  . setup.sh deactivate\n'
  printf '  . setup.sh install --dev\n'
  printf '  setup.sh status\n'
  printf '  setup.sh help\n'
  printf '  setup.sh --man\n'
  _clia_bloc 'Verbes' activate deactivate install status help
  _clia_bloc 'Options' '-C ROOT_PATH' '--dev' '--man'
}

_clia_setup_manuel() {
  cat <<'FIN' | _clia_man clia-setup 1 "Manuel de l'utilisateur clia"
NOM
clia-setup - gérer une installation de clia

SYNOPSIS
. setup.sh [-C ROOT_PATH] activate
. setup.sh deactivate
. setup.sh install --dev
setup.sh status
setup.sh help
setup.sh --man

DESCRIPTION
Une installation de clia est faite de trois choses : le programme
lui-même, les variables d'environnement qui décrivent son intégration
au système hôte, et les options qui modulent son fonctionnement.

Elle a trois propriétés, et « status » les rapporte : sa durée de
vie, sa source, et sa portée.

Il en existe deux natures.

Une activation est la plus légère. Sa durée de vie est celle du shell
courant, sa source est le dépôt où vit ce script, et sa portée est un
seul dépôt de travail. Rien n'est écrit sur le disque ; fermer le
terminal suffit à la défaire.

Une installation dev est permanente. Sa durée de vie va jusqu'à son
retrait, sa source est le dépôt d'où elle a été lancée, et sa portée
n'est pas bornée : la commande répond dans n'importe quel dépôt git.

Les deux peuvent coexister. L'activation l'emporte alors, et status
le dit — sans quoi on attribuerait à l'une le comportement de
l'autre.

VERBES
activate
       Rend la commande clia disponible dans le shell courant, et
       limite sa portée au dépôt de travail qui contient ROOT_PATH.

       ROOT_PATH vaut le répertoire courant par défaut, et doit se
       trouver dans un dépôt git : la portée est la racine de ce
       dépôt. Une activation dont la portée ne serait pas un dépôt
       ne permettrait aucun travail, et le refus vaut mieux qu'une
       activation inutile.

       Une activation déjà en place est remplacée, et le rapport dit
       ce qui a changé. Il n'y a rien à défaire d'abord : une
       activation ne laisse aucune trace sur le disque.

       Doit être sourcé.

deactivate
       Retire l'activation du shell courant : la commande sort du
       PATH, et les variables d'environnement sont retirées.

       Sans activation en place, la commande le dit et réussit :
       l'état voulu est déjà celui-là.

       Doit être sourcé.

install --dev
       Installe clia pour toutes les sessions : un lien symbolique
       vers l'exécutable du dépôt courant, et une configuration qui
       décrit l'installation.

       Le lien, et non une copie : modifier le dépôt source change
       immédiatement la commande, ce qui est le propre d'un mode
       développement.

       Aucune portée n'est déclarée, et c'est ce qui rend la commande
       utilisable dans n'importe quel dépôt git.

       Un lien menant à un autre dépôt n'est pas écrasé : il
       appartient à une autre installation, et l'écraser la ferait
       disparaître sans le dire.

       Le retrait appartient au CLI : clia setup uninstall.

       Peut être exécuté ; sourcé, la commande répond aussi tout de
       suite dans le shell courant.

status
       Rapporte l'installation en place et ses trois propriétés.
       Rend 1 quand il n'y en a aucune, pour qu'un script en dépende.

help
       L'aide brève : les signatures valides et les options.

OPTIONS
-C ROOT_PATH
       Le répertoire dont le dépôt fixe la portée de l'activation.
       Vaut le répertoire courant par défaut. Peut être relatif.

--dev
       Le mode d'installation permanente. C'est le seul aujourd'hui,
       et install l'exige plutôt que de le supposer.

--man
       Cette page.

FICHIERS
~/.local/bin/clia
       Le lien posé par install --dev. Son répertoire se change par
       CLIA_BIN_DIR.

~/.config/clia/installation.yaml
       Ce que l'installation dev déclare : sa nature, sa source, son
       lien. Son répertoire suit XDG_CONFIG_HOME.

       Ces deux fichiers sont tout ce qu'une installation dev laisse
       sur le disque, et tout ce que uninstall retire.

ENVIRONNEMENT
Ces variables sont l'installation, au sens de la définition
ci-dessus. Les poser à la main plutôt que par « activate » n'est pas
prévu, et rien ne les valide.

CLIA_INSTALLATION
       La nature de l'installation en place. Vaut « activation ».
       Son absence signifie qu'aucune installation n'est en place.

CLIA_SOURCE_DIR
       Le dépôt d'où viennent l'exécutable et ses fichiers de
       support.

CLIA_PORTEE
       La racine du dépôt de travail sur lequel l'installation
       permet de travailler. Une commande lancée hors de ce dépôt
       est refusée. Une installation dev n'en pose pas : sa portée
       n'est pas bornée.

CLIA_BIN_DIR
       Où install --dev pose son lien. Vaut ~/.local/bin par défaut.

XDG_CONFIG_HOME
       Où install --dev pose sa configuration. Vaut ~/.config par
       défaut.

CODE DE RETOUR
0
       La demande est satisfaite, même s'il n'y avait rien à faire.

1
       Refus : script exécuté là où il devait être sourcé, ROOT_PATH
       hors d'un dépôt git, ou dépendance manquante. Pour « status »,
       1 signifie qu'aucune installation n'est en place.

2
       Demande mal formée : verbe inconnu, ou option sans valeur.

EXEMPLES
Activer clia sur le dépôt courant :

       $ . setup.sh activate

Activer clia sur un autre dépôt, sans s'y déplacer :

       $ . setup.sh -C ~/git/mon-projet activate

Voir ce qui est en place :

       $ setup.sh status

Défaire l'activation sans fermer le terminal :

       $ . setup.sh deactivate

Installer clia pour toutes les sessions :

       $ . setup.sh install --dev

Et le retirer :

       $ clia setup uninstall

VOIR AUSSI
clia(1), clia-version(1), clia-check(1), bash(1)
FIN
}

# --------------------------------------------------------------------------
# Le PATH
# --------------------------------------------------------------------------
#
# Le répertoire des exécutables est retiré avant d'être ajouté : sans cela,
# activer deux fois l'inscrirait deux fois, et désactiver n'en retirerait
# qu'une.

_clia_setup_path_sans() {
  local retire="$1" reste='' element
  local ancien_ifs="$IFS"
  IFS=':'
  for element in $PATH; do
    [[ "$element" == "$retire" ]] && continue
    reste="${reste:+$reste:}$element"
  done
  IFS="$ancien_ifs"
  printf '%s\n' "$reste"
}

# --------------------------------------------------------------------------
# Les verbes
# --------------------------------------------------------------------------

# git est la seule dépendance : la source de vérité d'une version est un
# commit, et la portée d'une activation est un dépôt. Elle est vérifiée avant
# que rien ne soit posé, pour qu'un refus laisse le shell intact.
_clia_setup_prerequis() {
  if ! command -v git >/dev/null 2>&1; then
    _clia_msg "git est absent, et clia en dépend"
    _clia_detail "la version d'un dépôt est un commit, et la portée un dépôt"
    return 1
  fi
  return 0
}

_clia_setup_activate() {
  local racine_demandee="$1" portee bin ancienne_portee ancienne_source
  local clia_avant clia_apres

  if (( ! _clia_source )); then
    _clia_msg "activate modifie le shell courant : il doit être sourcé"
    _clia_detail ". setup.sh activate"
    return 1
  fi

  _clia_setup_prerequis || return 1

  if [[ ! -d "$racine_demandee" ]]; then
    _clia_msg "ce répertoire n'existe pas : $racine_demandee"
    return 1
  fi

  if ! portee=$(_clia_depot_git "$racine_demandee") || [[ -z "$portee" ]]; then
    _clia_msg "ce répertoire n'est pas dans un dépôt git : $racine_demandee"
    _clia_detail "la portée d'une activation est un dépôt de travail"
    return 1
  fi

  ancienne_source="${CLIA_SOURCE_DIR:-}"
  ancienne_portee="${CLIA_PORTEE:-}"
  clia_avant=$(command -v clia 2>/dev/null || printf '')

  # Une activation antérieure est remplacée. Elle n'a rien écrit sur le
  # disque : il n'y a rien à défaire, seulement à dire.
  if [[ -n "${CLIA_INSTALLATION:-}" ]]; then
    PATH=$(_clia_setup_path_sans "$(_clia_i_bin_du_source "$ancienne_source")")
  fi

  bin=$(_clia_i_bin_du_source "$_clia_racine")
  PATH="$bin:$(_clia_setup_path_sans "$bin")"

  CLIA_INSTALLATION='activation'
  CLIA_SOURCE_DIR="$_clia_racine"
  CLIA_PORTEE="$portee"
  export PATH CLIA_INSTALLATION CLIA_SOURCE_DIR CLIA_PORTEE

  if [[ -n "$ancienne_portee" && "$ancienne_portee" != "$portee" ]]; then
    _clia_msg "activation déplacée de $ancienne_portee vers $portee"
  else
    _clia_msg "clia est actif, sur $portee"
  fi

  # Une autre installation peut avoir posé un clia dans le PATH — un lien
  # permanent, par exemple. L'activation le masque, et le taire ferait
  # attribuer à celle-ci le comportement de celle-là.
  clia_apres=$(command -v clia 2>/dev/null || printf '')
  if [[ -n "$clia_avant" && "$clia_avant" != "$clia_apres" ]]; then
    _clia_detail "cette activation en masque une autre : $clia_avant"
  fi

  _clia_detail "ce qui est en place : setup.sh status"
  return 0
}

_clia_setup_deactivate() {
  if (( ! _clia_source )); then
    _clia_msg "deactivate modifie le shell courant : il doit être sourcé"
    _clia_detail ". setup.sh deactivate"
    return 1
  fi

  if [[ -z "${CLIA_INSTALLATION:-}" ]]; then
    _clia_msg "aucune activation en place : il n'y a rien à retirer"
    return 0
  fi

  PATH=$(_clia_setup_path_sans "$(_clia_i_bin_du_source "${CLIA_SOURCE_DIR:-}")")
  export PATH
  unset CLIA_INSTALLATION CLIA_SOURCE_DIR CLIA_PORTEE CLIA_WORK_DIR

  _clia_msg "activation retirée du shell courant"
  return 0
}

# Rapporte l'installation en place et ses trois propriétés. Le rendu vient du
# module partagé : « setup.sh status » et « clia setup status » doivent dire
# la même chose du même état.
_clia_setup_status() { _clia_i_rapport; }

# Installation permanente — SES-001 tâche 7.
#
# Sa durée de vie va jusqu'au retrait, sa source est le dépôt d'où elle est
# lancée, et sa portée n'est pas bornée : aucune portée n'est déclarée, et
# c'est ce qui rend clia utilisable dans n'importe quel dépôt git.
#
# Elle est faite d'un lien symbolique vers l'exécutable du dépôt source, non
# d'une copie : modifier le source change immédiatement la commande, ce qui
# est le propre d'un mode développement.
_clia_setup_install() {
  local mode="$1" lien cible_actuelle bin

  if [[ "$mode" != '--dev' ]]; then
    _clia_msg "install attend un mode : --dev"
    _clia_detail "l'usage : . setup.sh install --dev"
    return 2
  fi

  _clia_setup_prerequis || return 1

  lien=$(_clia_i_lien)
  bin=$(_clia_i_bin_du_source "$_clia_racine")

  # Un lien déjà posé vers un autre dépôt n'est pas écrasé : il appartient à
  # une autre installation, et l'écraser la ferait disparaître sans le dire.
  if [[ -e "$lien" || -L "$lien" ]]; then
    cible_actuelle=$(readlink -f "$lien" 2>/dev/null || printf '')
    if [[ "$cible_actuelle" != "$(readlink -f "$bin/clia" 2>/dev/null)" ]]; then
      _clia_msg "une commande clia occupe déjà cet emplacement : $lien"
      _clia_detail "elle mène à : ${cible_actuelle:-(cible introuvable)}"
      _clia_detail "retirez-la — clia setup uninstall — puis réinstallez"
      return 1
    fi
  fi

  _clia_i_poser "$_clia_racine" || return 1

  _clia_msg "clia est installé, depuis $_clia_racine"
  _clia_detail "lien   $lien"
  _clia_detail "portée n'importe quel dépôt git"

  # Sourcé, le PATH du shell courant est complété pour que la commande
  # réponde tout de suite. Ce geste-là est éphémère ; la permanence tient au
  # lien, et donc à ce que le répertoire soit dans le PATH des sessions
  # suivantes.
  local dir
  dir=$(_clia_i_bin_dir)
  if (( _clia_source )); then
    PATH="$dir:$(_clia_setup_path_sans "$dir")"
    export PATH
  fi

  if ! _clia_setup_path_contient "$dir"; then
    _clia_msg "$dir n'est pas dans votre PATH"
    _clia_detail "ajoutez cette ligne à votre profil, sans quoi la commande"
    _clia_detail "ne répondra pas dans les sessions suivantes :"
    _clia_detail ""
    _clia_detail "  export PATH=\"$dir:\$PATH\""
  elif (( ! _clia_source )); then
    _clia_detail "ce shell-ci ne la voit que si $dir est déjà dans son PATH"
  fi

  _clia_detail "ce qui est en place : setup.sh status"
  return 0
}

_clia_setup_path_contient() {
  local cherche="$1" element
  local ancien_ifs="$IFS"
  IFS=':'
  for element in $PATH; do
    if [[ "$element" == "$cherche" ]]; then IFS="$ancien_ifs"; return 0; fi
  done
  IFS="$ancien_ifs"
  return 1
}

# --------------------------------------------------------------------------
# Analyse de la demande
# --------------------------------------------------------------------------

_clia_setup_main() {
  local verbe='' racine="$PWD" mode=''

  while (( $# )); do
    case "$1" in
      -C) if [[ -z "${2:-}" ]]; then
            _clia_msg "-C attend un répertoire"
            return 2
          fi
          racine="$2"
          shift 2 ;;
      --man)
          _clia_setup_manuel
          return 0 ;;
      -h|--help|help)
          _clia_setup_aide
          return 0 ;;
      --dev)
          mode='--dev'
          shift ;;
      activate|deactivate|status|install)
          verbe="$1"
          shift ;;
      *)  _clia_msg "verbe inconnu : $1"
          _clia_detail "l'usage : setup.sh help"
          return 2 ;;
    esac
  done

  case "$verbe" in
    activate)   _clia_setup_activate "$racine" ;;
    deactivate) _clia_setup_deactivate ;;
    install)    _clia_setup_install "$mode" ;;
    status)     _clia_setup_status ;;
    '')         _clia_setup_aide ;;
  esac
}

# --------------------------------------------------------------------------
# Exécution, puis nettoyage du shell
# --------------------------------------------------------------------------

# Tout ce qui a été déclaré est retiré, et le code de retour est porté par
# cette fonction plutôt que par une variable : une variable qui porterait le
# code devrait survivre au nettoyage pour être lue ensuite, et resterait donc
# dans le shell de l'utilisateur.
#
# La fonction se retire elle-même en chemin. Bash garde le corps d'une
# fonction en cours d'exécution, et son « return » a donc bien lieu.
#
# Les variables exportées, elles, survivent : elles ne sont pas des restes,
# elles sont l'installation.
_clia_setup_fin() {
  local code="$1" nom
  for nom in $(compgen -A function _clia_ 2>/dev/null); do unset -f "$nom"; done
  for nom in $(compgen -v _CLIA_ 2>/dev/null); do unset "$nom"; done
  unset _clia_source _clia_racine
  return "$code"
}

# Sourcé, le fichier rend le code de sa dernière commande ; exécuté, il en
# fait son code de sortie. Une seule écriture suffit donc aux deux.
_clia_setup_main "$@"
_clia_setup_fin "$?"
