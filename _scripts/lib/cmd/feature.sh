#!/usr/bin/env bash
# Description: Les fonctionnalités des ressources — ls, activate, deactivate.
# Périmètre: dépôt
# Signature: feature ls
# Signature: feature activate FONCTIONNALITE [PREFIXE]
# Signature: feature deactivate FONCTIONNALITE [PREFIXE]
#
# Implémente SES-001 tâche 15.
#
# Une fonctionnalité est un extrait ajouté au harnais IA. Son corps entre
# directement dans CLAUDE.md, où l'agent le lit à chaque fois : elle est
# toujours dans le contexte. Un skill, lui, n'y entre qu'à l'invocation —
# c'est ce qui sépare les deux, et ce qui décide laquelle des deux on écrit.
#
# Une fonctionnalité n'est pas une ressource : elle est toujours la
# fonctionnalité de quelque chose. Cette commande vit donc dans le noyau, et
# non sous une ressource, et elle porte sur celles de toutes les ressources à
# la fois.
#
# L'état ne se déclare nulle part : il se lit dans le harnais. Le bloc y est,
# ou il n'y est pas. Un inventaire parallèle aurait pu mentir ; le fichier,
# non — et c'est lui qui décide de ce que l'agent lit.

set -euo pipefail

_CLIA_NOM='clia'
# shellcheck source=../commun.sh
. "$CLIA_SOURCE_DIR/_scripts/lib/commun.sh"
# shellcheck source=../texte.sh
. "$CLIA_SOURCE_DIR/_scripts/lib/texte.sh"
# shellcheck source=../fourniture.sh
. "$CLIA_SOURCE_DIR/_scripts/lib/fourniture.sh"

DEPOT="${CLIA_WORK_DIR:-}"
HARNAIS=$(_clia_f_harnais "$DEPOT")

# --------------------------------------------------------------------------

manuel() {
  cat <<'EOF' | _clia_man clia-feature 1 "Manuel de l'utilisateur clia"
NOM
clia-feature - poser dans le harnais les fonctionnalités des ressources

SYNOPSIS
clia feature ls
clia feature activate FONCTIONNALITE [PREFIXE]
clia feature deactivate FONCTIONNALITE [PREFIXE]

DESCRIPTION
Une fonctionnalité est un extrait de texte qu'une ressource offre
au harnais IA du dépôt. L'activer pose son corps dans CLAUDE.md ;
la désactiver l'en retire.

Elle est donc toujours dans le contexte de l'agent, à chaque
échange. Un skill, lui, n'y entre qu'à l'invocation. C'est ce qui
sépare les deux, et ce qui décide laquelle des deux on écrit : ce
qui doit valoir tout le temps est une fonctionnalité, ce qui ne sert
qu'à l'occasion est un skill.

Une fonctionnalité vit sous la ressource qui la donne, dans
<zone livrée>/<ressource>/features/<nom>.md. Il n'y a pas de
catalogue : clia trouve ce qui est là.

clia pose le corps du fichier, sous un titre qu'il écrit lui-même —
« ## Fonctionnalité : <nom> ». Le corps n'a donc pas à porter son
propre titre de premier niveau.

LA ZONE GEREE
Ce que clia pose va entre deux marqueurs :

       <!-- CLIA:FEATURES:BEGIN -->
       <!-- CLIA:FEATURES:END -->

Hors de ces marqueurs, le harnais appartient à qui l'écrit : clia
n'y touche jamais. Dedans, il n'y a que ce que clia a posé.

Une zone absente est créée en fin de fichier, et clia le dit.

SOUS-COMMANDES
ls
       Les fonctionnalités offertes par les ressources du dépôt, et
       leur état dans le harnais.

activate FONCTIONNALITE [PREFIXE]
       Pose le corps de la fonctionnalité dans la zone gérée.

       PREFIXE nomme la ressource, et n'est utile que si deux
       d'entre elles offrent une fonctionnalité du même nom. clia
       ne choisit pas à la place de l'appelant : une désignation
       ambiguë est refusée.

       Une fonctionnalité déjà posée n'est pas reposée.

deactivate FONCTIONNALITE [PREFIXE]
       Retire son bloc du harnais. Le fichier de la fonctionnalité,
       lui, reste sous sa ressource : ce qui est retiré est ce que
       l'agent lit, non ce que le dépôt porte.

SORTIE
La sortie standard de « ls » porte une ligne d'en-tête et une ligne
par fonctionnalité. Les deux autres verbes n'en portent aucune.

CODE DE RETOUR
0
       La demande est satisfaite, même s'il n'y avait rien à faire.

1
       Refus : fonctionnalité inconnue, désignation ambiguë, ou
       harnais absent.

2
       Demande mal formée.

FICHIERS
<zone livrée>/<ressource>/features/<nom>.md
       Une fonctionnalité : un frontmatter qui la décrit, puis le
       corps que clia pose. La zone livrée est .clia/ressources par
       défaut ; $CLIA_ZONE_RESSOURCE_LIVREE la déplace.

CLAUDE.md
       Le harnais IA du dépôt, et la zone gérée qu'il porte.

EXEMPLES
Voir ce qui est offert, et ce qui est posé :

       $ clia feature ls
       RESSOURCE  FONCTIONNALITE  ETAT
       session    journal-continu inactive

Poser une fonctionnalité :

       $ clia feature activate journal-continu

VOIR AUSSI
clia(1), clia-skill(1), clia-script(1), clia-hrn(1)
EOF
}

# --------------------------------------------------------------------------

etat_de() {
  if _clia_t_pose "$HARNAIS" "$1" feature; then printf 'active\n'; else printf 'inactive\n'; fi
}

lister() {
  local prefixe nom n f desc lignes=''

  if [[ -z "$(_clia_f_features "$DEPOT")" ]]; then
    _clia_msg "aucune ressource de ce dépôt n'offre de fonctionnalité"
    _clia_detail "elles se rangent sous $(_clia_zone_livree)/<ressource>/features/"
    _clia_detail "ce que le dépôt porte : clia res ls"
    return 0
  fi

  while IFS="$_CLIA_SEP" read -r prefixe nom n f desc; do
    [[ -n "$n" ]] || continue
    lignes+=$(printf '%s\t%s\t%s\t%s' \
      "$nom" "$n" "$(etat_de "$n")" "${desc:-—}")$'\n'
  done < <(_clia_f_features "$DEPOT")

  { printf 'RESSOURCE\tFONCTIONNALITE\tETAT\tDESCRIPTION\n'
    printf '%s' "$lignes"
  } | column -t -s $'\t'
  return 0
}

resoudre() {
  local nom="$1" prefixe="${2:-}" ligne code
  ligne=$(_clia_f_features "$DEPOT" | _clia_f_resoudre "$nom" "$prefixe") && code=0 || code=$?
  if (( code == 0 )); then printf '%s\n' "$ligne"; return 0; fi
  # Le code 3 dit que clia a déjà nommé l'ambiguïté ; il ne reste rien à dire.
  if (( code == 1 )); then
    _clia_msg "fonctionnalité inconnue : $nom"
    _clia_detail "celles que le dépôt offre : clia feature ls"
  fi
  return 1
}

activer() {
  local ligne prefixe nom n f desc bloc
  ligne=$(resoudre "$@") || return 1
  IFS="$_CLIA_SEP" read -r prefixe nom n f desc <<<"$ligne"

  _clia_f_exiger_harnais "$DEPOT" || return 1

  if _clia_t_pose "$HARNAIS" "$n" feature; then
    _clia_msg "$n est déjà posée dans CLAUDE.md"
    _clia_detail "pour l'en retirer : clia feature deactivate $n"
    return 0
  fi

  bloc=$(mktemp)
  # shellcheck disable=SC2064
  trap "rm -f '$bloc'" RETURN
  { _clia_t_borne_debut "$n" feature
    printf '## Fonctionnalité : %s\n\n' "$n"
    _clia_t_corps "$f"
    _clia_t_borne_fin "$n" feature
  } > "$bloc"

  if ! _clia_t_zone_assurer "$HARNAIS" features; then
    _clia_msg "la zone gérée des fonctionnalités a été créée en fin de CLAUDE.md"
    _clia_detail "déplacez-la où vous voulez : clia y posera la suite"
  fi
  _clia_t_inserer "$HARNAIS" features "$bloc"

  _clia_msg "$n posée dans CLAUDE.md, depuis la ressource $nom"
  _clia_detail "l'agent la lit désormais à chaque échange"
  _clia_detail "rien n'est commité"
  return 0
}

desactiver() {
  local ligne prefixe nom n f desc
  ligne=$(resoudre "$@") || return 1
  IFS="$_CLIA_SEP" read -r prefixe nom n f desc <<<"$ligne"

  if [[ ! -f "$HARNAIS" ]] || ! _clia_t_pose "$HARNAIS" "$n" feature; then
    _clia_msg "$n n'est pas posée dans CLAUDE.md : rien à retirer"
    return 0
  fi

  _clia_t_retirer "$HARNAIS" "$n" feature
  _clia_msg "$n retirée de CLAUDE.md"
  _clia_detail "son fichier reste sous $(_clia_zone_livree)/$nom/features"
  _clia_detail "rien n'est commité"
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

VERBE="${1:-}"
[[ $# -gt 0 ]] && shift

case "$VERBE" in
  '')
    _clia_msg "clia feature attend un verbe"
    _clia_detail "l'usage : clia feature --help"
    exit 2 ;;

  ls)
    (( $# == 0 )) || { _clia_msg "ls ne prend pas d'argument : $*"; exit 2; }
    lister ;;

  activate|deactivate)
    (( $# >= 1 )) || {
      _clia_msg "$VERBE attend une fonctionnalité"
      _clia_detail "l'usage : clia feature $VERBE FONCTIONNALITE [PREFIXE]"
      exit 2
    }
    (( $# <= 2 )) || { _clia_msg "argument en trop : ${3:-}"; exit 2; }
    if [[ "$VERBE" == 'activate' ]]; then activer "$@"; else desactiver "$@"; fi ;;

  *)
    _clia_msg "verbe inconnu : $VERBE"
    _clia_detail "l'usage : clia feature --help"
    exit 2 ;;
esac
