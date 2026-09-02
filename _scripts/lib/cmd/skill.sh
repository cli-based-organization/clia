#!/usr/bin/env bash
# Description: Les skills des ressources — ls, activate, deactivate.
# Périmètre: dépôt
# Signature: skill ls
# Signature: skill activate SKILL [PREFIXE]
# Signature: skill deactivate SKILL [PREFIXE]
#
# Implémente SES-001 tâche 15.
#
# Un skill est une procédure qu'un agent charge à l'invocation. Deux gestes
# le rendent employable, et l'activation fait les deux :
#
#   la procédure est déposée sous .claude/skills/<nom>/ — c'est là que
#   l'agent la trouve ;
#
#   une directive est posée dans le harnais, qui dit quand l'employer. Sans
#   elle, le skill est là et personne ne sait qu'il faut le prendre.
#
# Ce qui le sépare d'une fonctionnalité : une fonctionnalité est dans le
# contexte à chaque échange, un skill n'y entre qu'à l'invocation. Ce qui doit
# valoir tout le temps est une fonctionnalité ; ce qui ne sert qu'à
# l'occasion est un skill.
#
# .claude/ est le seul emplacement que clia sait servir aujourd'hui. L'énoncé
# de SES-001 tâche 15 dit « .claude (ou autre selon le système IA utilisé) » ;
# l'autre viendra quand un autre système sera là, et le dire vaut mieux que
# laisser croire que le choix existe déjà.

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

SKILLS_REL='.claude/skills'
SKILLS="$DEPOT/$SKILLS_REL"

# --------------------------------------------------------------------------

manuel() {
  cat <<'EOF' | _clia_man clia-skill 1 "Manuel de l'utilisateur clia"
NOM
clia-skill - poser les skills des ressources dans le dépôt

SYNOPSIS
clia skill ls
clia skill activate SKILL [PREFIXE]
clia skill deactivate SKILL [PREFIXE]

DESCRIPTION
Un skill est une procédure qu'un agent charge à l'invocation. Une
ressource peut en offrir ; l'activer le rend employable dans ce
dépôt.

Activer fait deux choses, et les deux sont nécessaires. La
procédure est copiée sous .claude/skills/<nom>/, où l'agent la
trouve. Une directive est posée dans le harnais, qui dit quand
l'employer — sans elle, le skill est là et personne ne sait qu'il
faut le prendre.

Ce qui le sépare d'une fonctionnalité : une fonctionnalité est dans
le contexte de l'agent à chaque échange, un skill n'y entre qu'à
l'invocation. Ce qui doit valoir tout le temps est une
fonctionnalité ; ce qui ne sert qu'à l'occasion est un skill.

Un skill vit sous la ressource qui le donne, dans
<zone livrée>/<ressource>/skills/. Deux formes sont admises : un
répertoire portant SKILL.md, qui laisse le skill emporter ses
propres fichiers, ou un fichier seul pour un skill qui tient en une
page. L'activation les ramène toutes deux à la première.

.claude/ est le seul emplacement que clia sait servir aujourd'hui.

SOUS-COMMANDES
ls
       Les skills offerts par les ressources du dépôt, et leur état.

       Un skill est actif quand sa procédure est sous .claude et sa
       directive dans le harnais. Les deux sont posées ensemble ; si
       l'une manque, l'état le dit.

activate SKILL [PREFIXE]
       Copie la procédure sous .claude/skills/, et pose sa directive
       dans la zone gérée du harnais.

       Un emplacement déjà occupé sous .claude/skills/ est refusé :
       clia n'écrase pas ce qu'il n'a pas posé.

       PREFIXE nomme la ressource, et n'est utile que si deux
       d'entre elles offrent un skill du même nom.

deactivate SKILL [PREFIXE]
       Retire la copie et la directive.

       Une copie qui a été modifiée depuis son dépôt est refusée :
       la modification serait perdue, et clia ne sait pas si elle
       comptait.

LA ZONE GEREE
Les directives vont entre deux marqueurs du harnais :

       <!-- CLIA:SKILLS:BEGIN -->
       <!-- CLIA:SKILLS:END -->

Hors de ces marqueurs, le harnais appartient à qui l'écrit. Une
zone absente est créée en fin de fichier, et clia le dit.

SORTIE
La sortie standard de « ls » porte une ligne d'en-tête et une ligne
par skill. Les deux autres verbes n'en portent aucune.

CODE DE RETOUR
0
       La demande est satisfaite, même s'il n'y avait rien à faire.

1
       Refus : skill inconnu, désignation ambiguë, harnais absent,
       emplacement occupé, ou copie modifiée.

2
       Demande mal formée.

FICHIERS
<zone livrée>/<ressource>/skills/<nom>/SKILL.md
       Un skill, et ce qu'il emporte.

.claude/skills/<nom>/
       Sa copie dans le dépôt, là où l'agent la trouve.

CLAUDE.md
       Le harnais, et la zone gérée qui porte les directives.

EXEMPLES
Voir ce qui est offert :

       $ clia skill ls
       RESSOURCE  SKILL      ETAT      DESCRIPTION
       analyse    interroger inactif   Comment mener un examen.

Rendre un skill employable :

       $ clia skill activate interroger

VOIR AUSSI
clia(1), clia-feature(1), clia-script(1)
EOF
}

# --------------------------------------------------------------------------

# L'état se constate en deux endroits, parce que l'activation en touche deux.
etat_de() {
  local n="$1" copie=0 directive=0
  [[ -d "$SKILLS/$n" ]] && copie=1
  _clia_t_pose "$HARNAIS" "$n" skill && directive=1
  if (( copie && directive )); then printf 'actif\n'
  elif (( copie ));             then printf 'sans directive\n'
  elif (( directive ));         then printf 'sans procédure\n'
  else                               printf 'inactif\n'
  fi
}

lister() {
  local prefixe nom n f desc lignes=''

  if [[ -z "$(_clia_f_skills "$DEPOT")" ]]; then
    _clia_msg "aucune ressource de ce dépôt n'offre de skill"
    _clia_detail "ils se rangent sous $(_clia_zone_livree)/<ressource>/skills/"
    _clia_detail "ce que le dépôt porte : clia res ls"
    return 0
  fi

  while IFS="$_CLIA_SEP" read -r prefixe nom n f desc; do
    [[ -n "$n" ]] || continue
    lignes+=$(printf '%s\t%s\t%s\t%s' \
      "$nom" "$n" "$(etat_de "$n")" "${desc:-—}")$'\n'
  done < <(_clia_f_skills "$DEPOT")

  { printf 'RESSOURCE\tSKILL\tETAT\tDESCRIPTION\n'
    printf '%s' "$lignes"
  } | column -t -s $'\t'
  return 0
}

resoudre() {
  local nom="$1" prefixe="${2:-}" ligne code
  ligne=$(_clia_f_skills "$DEPOT" | _clia_f_resoudre "$nom" "$prefixe") && code=0 || code=$?
  if (( code == 0 )); then printf '%s\n' "$ligne"; return 0; fi
  if (( code == 1 )); then
    _clia_msg "skill inconnu : $nom"
    _clia_detail "ceux que le dépôt offre : clia skill ls"
  fi
  return 1
}

# La source d'un skill : le répertoire quand il en est un, le fichier sinon.
source_de() { local f="$1"; [[ "$(basename "$f")" == 'SKILL.md' ]] && dirname "$f" || printf '%s\n' "$f"; }

activer() {
  local ligne prefixe nom n f desc src bloc
  ligne=$(resoudre "$@") || return 1
  IFS="$_CLIA_SEP" read -r prefixe nom n f desc <<<"$ligne"

  _clia_f_exiger_harnais "$DEPOT" || return 1

  if [[ -e "$SKILLS/$n" ]]; then
    _clia_msg "l'emplacement est déjà occupé : $SKILLS_REL/$n"
    _clia_detail "clia n'écrase pas ce qu'il n'a pas posé"
    _clia_detail "pour le retirer d'abord : clia skill deactivate $n"
    return 1
  fi

  src=$(source_de "$f")
  mkdir -p "$SKILLS/$n"
  if [[ -d "$src" ]]; then
    cp -r "$src/." "$SKILLS/$n/"
  else
    cp "$src" "$SKILLS/$n/SKILL.md"
  fi

  if ! _clia_t_pose "$HARNAIS" "$n" skill; then
    bloc=$(mktemp)
    # shellcheck disable=SC2064
    trap "rm -f '$bloc'" RETURN
    { _clia_t_borne_debut "$n" skill
      printf '## Skill : %s\n\n' "$n"
      [[ -n "$desc" ]] && printf '%s\n\n' "$desc"
      printf 'La procédure est dans `%s/%s`. Elle vient de la ressource %s.\n' \
        "$SKILLS_REL" "$n" "$nom"
      _clia_t_borne_fin "$n" skill
    } > "$bloc"

    if ! _clia_t_zone_assurer "$HARNAIS" skills; then
      _clia_msg "la zone gérée des skills a été créée en fin de CLAUDE.md"
      _clia_detail "déplacez-la où vous voulez : clia y posera la suite"
    fi
    _clia_t_inserer "$HARNAIS" skills "$bloc"
  fi

  _clia_msg "$n posé, depuis la ressource $nom"
  _clia_detail "procédure : $SKILLS_REL/$n"
  _clia_detail "directive : CLAUDE.md, zone gérée des skills"
  _clia_detail "rien n'est commité"
  return 0
}

desactiver() {
  local ligne prefixe nom n f desc src
  ligne=$(resoudre "$@") || return 1
  IFS="$_CLIA_SEP" read -r prefixe nom n f desc <<<"$ligne"

  local copie=0 directive=0
  [[ -d "$SKILLS/$n" ]] && copie=1
  [[ -f "$HARNAIS" ]] && _clia_t_pose "$HARNAIS" "$n" skill && directive=1

  if (( ! copie && ! directive )); then
    _clia_msg "$n n'est pas posé dans ce dépôt : rien à retirer"
    return 0
  fi

  # Une copie modifiée depuis son dépôt porte un travail que clia ne sait pas
  # rendre. Il refuse plutôt que de l'effacer.
  if (( copie )); then
    src=$(source_de "$f")
    if [[ -d "$src" ]]; then
      if ! diff -rq "$src" "$SKILLS/$n" >/dev/null 2>&1; then
        _clia_msg "$SKILLS_REL/$n diffère du skill dont il vient"
        _clia_detail "la modification serait perdue ; clia ne l'efface pas"
        _clia_detail "reportez-la dans $f, ou effacez la copie vous-même"
        return 1
      fi
    elif ! cmp -s "$src" "$SKILLS/$n/SKILL.md"; then
      _clia_msg "$SKILLS_REL/$n diffère du skill dont il vient"
      _clia_detail "la modification serait perdue ; clia ne l'efface pas"
      _clia_detail "reportez-la dans $f, ou effacez la copie vous-même"
      return 1
    fi
    rm -rf "${SKILLS:?}/$n"
  fi

  (( directive )) && _clia_t_retirer "$HARNAIS" "$n" skill

  _clia_msg "$n retiré de ce dépôt"
  (( copie ))     && _clia_detail "la copie de $SKILLS_REL/$n est effacée"
  (( directive )) && _clia_detail "sa directive est ôtée de CLAUDE.md"
  _clia_detail "le skill reste sous $(_clia_zone_livree)/$nom/skills"
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
    _clia_msg "clia skill attend un verbe"
    _clia_detail "l'usage : clia skill --help"
    exit 2 ;;

  ls)
    (( $# == 0 )) || { _clia_msg "ls ne prend pas d'argument : $*"; exit 2; }
    lister ;;

  activate|deactivate)
    (( $# >= 1 )) || {
      _clia_msg "$VERBE attend un skill"
      _clia_detail "l'usage : clia skill $VERBE SKILL [PREFIXE]"
      exit 2
    }
    (( $# <= 2 )) || { _clia_msg "argument en trop : ${3:-}"; exit 2; }
    if [[ "$VERBE" == 'activate' ]]; then activer "$@"; else desactiver "$@"; fi ;;

  *)
    _clia_msg "verbe inconnu : $VERBE"
    _clia_detail "l'usage : clia skill --help"
    exit 2 ;;
esac
