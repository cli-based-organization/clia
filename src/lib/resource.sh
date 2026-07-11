#!/usr/bin/env bash
# resource.sh - inspection des ressources livrables (res / resource).
# Sourcé par src/bin/clia. Requiert REPO_ROOT.

# Table des types de ressources connus : "PREFIX|sous-repertoire|cycle-de-vie".
# cycle-de-vie : vivant | pointfixe | travail (voir ADR-004).
_RES_TABLE=(
  "PLN|.dev/plans|travail"
  "ADR|.dev/adr|vivant"
  "SPEC|.dev/specs|vivant"
  "REQ|.dev/requis|vivant"
  "BUG|.dev/bugs|vivant"
  "FND|.dev/fondations|pointfixe"
  "ANL|.dev/analyses|pointfixe"
  "SES|.dev/sessions|pointfixe"
  "LOG|logs/ia-output|pointfixe"
)

# _res_lookup PREFIX : imprime "dir|kind" ou rien.
_res_lookup() {
  local prefix="$1" row
  for row in "${_RES_TABLE[@]}"; do
    if [ "${row%%|*}" = "$prefix" ]; then
      printf '%s' "${row#*|}"
      return 0
    fi
  done
  return 1
}

# _res_state FILE KIND : état lu dans le fichier, ou "-" pour un point fixe.
# La ligne d'état doit débuter (hors puce/gras) par "Statut :" ; on ne retient
# que le mot-clé d'état, sans la parenthèse explicative éventuelle.
_res_state() {
  local file="$1" kind="$2" state
  if [ "$kind" = "pointfixe" ]; then
    printf '%s' "-"
    return 0
  fi
  state="$(grep -iE '^[-* ]*statut[* ]*:' "$file" | head -n1 \
    | sed -E 's/^[-* ]*[Ss]tatut[* ]*:[[:space:]]*//; s/\*//g; s/\(.*$//; s/[[:space:]]*$//')"
  printf '%s' "${state:--}"
}

# _res_version FILE KIND : version pour un vivant ; date pour un point fixe ;
# "-" pour une ressource de travail (PLN, non versionnée, voir ADR-004).
# La ligne de version doit débuter (hors puce/gras) par "Version :".
_res_version() {
  local file="$1" kind="$2" ver
  if [ "$kind" = "pointfixe" ]; then
    printf '%s' "$(basename "$file" | sed -nE 's/^[A-Z]+-([0-9]{4}-[0-9]{2}-[0-9]{2}).*/\1/p')"
    return 0
  fi
  if [ "$kind" = "travail" ]; then
    printf '%s' "-"
    return 0
  fi
  ver="$(grep -iE '^[-* ]*version[* ]*:' "$file" | head -n1 \
    | sed -E 's/^[-* ]*[Vv]ersion[* ]*:[[:space:]]*//; s/\*//g; s/[[:space:]].*$//')"
  printf '%s' "${ver:--}"
}

# _res_table_print : liste des types connus.
_res_table_print() {
  local row prefix dir kind
  printf '%-6s %-16s %s\n' "PREFIX" "CYCLE" "EMPLACEMENT"
  for row in "${_RES_TABLE[@]}"; do
    prefix="${row%%|*}"; dir="$(printf '%s' "${row#*|}" | cut -d'|' -f1)"
    kind="${row##*|}"
    printf '%-6s %-16s %s\n' "$prefix" "$kind" "$dir"
  done
}

# _res_instances PREFIX : instances d'un type sous forme ID | STATE | VERSION.
_res_instances() {
  local prefix="$1" info dir kind file id state ver found=0
  info="$(_res_lookup "$prefix")" || _die "type de ressource inconnu : $prefix" 2
  dir="${info%%|*}"; kind="${info##*|}"
  local absdir="$REPO_ROOT/$dir"
  [ -d "$absdir" ] || _die "répertoire absent : $dir" 1
  for file in "$absdir/$prefix"-*.md; do
    [ -e "$file" ] || continue
    found=1
    id="$(basename "$file" .md)"
    state="$(_res_state "$file" "$kind")"
    ver="$(_res_version "$file" "$kind")"
    printf '%s | %s | %s\n' "$id" "$state" "$ver"
  done
  [ "$found" -eq 1 ] || _info "aucune instance $prefix dans $dir"
}

# cmd_res ARGS... : dispatch du groupe res/resource.
cmd_res() {
  case "${1:-}" in
    -h|--help|"")
      printf '%s\n' "Usage : clia res ls [PREFIX] [--version|--long]"
      ;;
    ls)
      shift
      local prefix=""
      # premier argument non-option = PREFIX
      case "${1:-}" in
        ""|--version|--long) prefix="" ;;
        *) prefix="$1"; shift ;;
      esac
      if [ -z "$prefix" ]; then
        _res_table_print
        if [ "${1:-}" = "--version" ]; then
          printf '\n'
          cmd_version --long | sed -n '/Ensembles/,$p'
        fi
      else
        _res_instances "$prefix"
      fi
      ;;
    *)
      _die "sous-commande res inconnue : ${1}" 2
      ;;
  esac
}
