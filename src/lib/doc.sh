#!/usr/bin/env bash
# doc.sh - génération de l'aide de clia depuis la source documentaire YAML.
# Sourcé par src/bin/clia. Requiert DOC_FILE. Dépend de yq (mikefarah).
# Mécanisme : source de vérité YAML unique + templates de rendu + génération à
# la volée (SPEC-001, REQ-001-F5/F7/F8/F9 ; interface clia : SPEC-002, REQ-002).

# _doc_require_yq : vérifie la présence de yq (implémentation mikefarah, REQ-002-NF6).
_doc_require_yq() {
  command -v yq >/dev/null 2>&1 \
    || _die "dépendance manquante : yq (mikefarah/yq) requis pour l'aide. Voir REQ-002-NF6." 1
}

# _doc_val EXPR : évalue une expression yq scalaire sur la source documentaire.
_doc_val() { yq "$1" "$DOC_FILE"; }

# _doc_pairs EXPR : émet des lignes "col1<TAB>col2" (EXPR concatène via strenv(SEP)).
_doc_pairs() { SEP=$'\t' yq "$1" "$DOC_FILE"; }

# _doc_list : template « liste » — rend "  nom  description" depuis des paires
# nom<TAB>desc lues sur stdin. Format identique à tous les niveaux (uniformité).
_doc_list() { local n d; while IFS=$'\t' read -r n d; do printf '  %-14s %s\n' "$n" "$d"; done; }

# _doc_help : aide courte de niveau supérieur (template court).
_doc_help() {
  _doc_require_yq
  printf '%s - %s\n\n' "$(_doc_val '.tool')" "$(_doc_val '.short')"
  printf 'Usage :\n  clia [OPTIONS_GLOBALES] COMMANDE|GROUPE [OPTIONS]\n\n'
  printf 'Options globales :\n'
  _doc_pairs '.global_options[] | .flag + strenv(SEP) + .short' | _doc_list
  printf '\nCommandes :\n'
  _doc_pairs '.commands[] | .name + strenv(SEP) + .short' | _doc_list
}

# _doc_help_group GROUP : aide courte d'un groupe (énumère ses sous-commandes).
_doc_help_group() {
  _doc_require_yq
  printf 'Usage : %s\n\n' "$(_doc_val ".commands[] | select(.name==\"$1\") | .usage")"
  printf 'Sous-commandes :\n'
  _doc_pairs ".commands[] | select(.name==\"$1\") | .subcommands[] | .name + strenv(SEP) + .short" | _doc_list
}

# _doc_help_sub GROUP SUB : aide propre à une sous-commande.
_doc_help_sub() {
  _doc_require_yq
  local base=".commands[] | select(.name==\"$1\") | .subcommands[] | select(.name==\"$2\")"
  printf 'Usage : %s\n\n%s\n' "$(_doc_val "$base | .usage")" "$(_doc_val "$base | (.long // .short)")"
}

# _doc_man : aide longue (manpage), générée depuis la même source (template long).
_doc_man() {
  _doc_require_yq
  printf 'NOM\n    %s - %s\n\n' "$(_doc_val '.tool')" "$(_doc_val '.short')"
  printf 'SYNOPSIS\n    clia [OPTIONS_GLOBALES] COMMANDE|GROUPE [OPTIONS]\n\n'
  printf 'DESCRIPTION\n    %s\n\n' "$(_doc_val '.long')"
  printf 'OPTIONS GLOBALES\n'
  _doc_val '.global_options[] | "    " + .flag + " - " + .short'
  printf '\nCOMMANDES\n'
  _doc_val '.commands[] | "    " + .name + " - " + .short, (.subcommands[] | "        " + .name + " - " + .short)'
}

# _doc_commands : inventaire des commandes documentées (cohérence, REQ-001-F9).
_doc_commands() { _doc_require_yq; _doc_val '.commands[].name'; }

# _doc_subcommands GROUP : inventaire des sous-commandes documentées d'un groupe.
_doc_subcommands() { _doc_require_yq; _doc_val ".commands[] | select(.name==\"$1\") | .subcommands[].name"; }

# _doc_canon NAME : nom canonique si NAME est un alias, sinon NAME inchangé.
_doc_canon() {
  _doc_require_yq
  local c; c="$(_doc_val ".commands[] | select(.name==\"$1\" or .alias==\"$1\") | .name")"
  printf '%s' "${c:-$1}"
}

# _doc_selfcheck : contrôle de cohérence dispatch/documentation (REQ-001-F9).
# Chaque commande documentée doit avoir une fonction cmd_<name>, et chaque
# sous-commande documentée une fonction cmd_<group>_<sub>. 0 si cohérent, 1 sinon.
_doc_selfcheck() {
  _doc_require_yq
  local rc=0 c s
  while IFS= read -r c; do
    [ -z "$c" ] && continue
    declare -F "cmd_$c" >/dev/null || { _err "documenté sans handler : cmd_$c"; rc=1; }
    while IFS= read -r s; do
      [ -z "$s" ] && continue
      declare -F "cmd_${c}_${s}" >/dev/null || { _err "documenté sans handler : cmd_${c}_${s}"; rc=1; }
    done < <(_doc_subcommands "$c")
  done < <(_doc_commands)
  return "$rc"
}
