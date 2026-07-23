#!/usr/bin/env bash
# version.sh - lecture des versions (métier + ensembles vivants).
# Sourcé par src/bin/clia. Requiert VERSION_FILE et RESSOURCES_FILE.

# _metier_version : version du domaine métier lue dans version.yaml.
_metier_version() {
  if [ -f "$VERSION_FILE" ]; then
    sed -n 's/^version:[[:space:]]*//p' "$VERSION_FILE" | head -n1
  else
    printf 'inconnue'
  fi
}

# cmd_release LEVEL : incrémente la version métier (version.yaml) selon semver.
# LEVEL dans {major, minor, patch}. Respecte --dry-run. Aucune opération git.
cmd_release() {
  case "${1:-}" in
    -h|--help)
      printf 'Usage : %s\n\n%s\n' \
        "$(_doc_val '.commands[] | select(.name=="release") | .usage')" \
        "$(_doc_val '.commands[] | select(.name=="release") | (.long // .short)')"
      return 0 ;;
  esac
  local level="${1:-}"
  case "$level" in
    major|minor|patch) ;;
    "") _die "release requiert un niveau : major|minor|patch" 2 ;;
    *)  _die "niveau invalide : $level (attendu major|minor|patch)" 2 ;;
  esac
  [ -f "$VERSION_FILE" ] || _die "version.yaml absent : $VERSION_FILE" 1
  local cur; cur="$(_metier_version)"
  case "$cur" in
    [0-9]*.[0-9]*.[0-9]*) ;;
    *) _die "version métier mal formée : '$cur' (attendu X.Y.Z)" 1 ;;
  esac
  local maj min pat; IFS=. read -r maj min pat <<EOF
$cur
EOF
  case "$maj$min$pat" in *[!0-9]*) _die "version métier non numérique : '$cur'" 1 ;; esac
  case "$level" in
    major) maj=$((maj + 1)); min=0; pat=0 ;;
    minor) min=$((min + 1)); pat=0 ;;
    patch) pat=$((pat + 1)) ;;
  esac
  local new="$maj.$min.$pat"
  _dbg "release: $cur -> $new (level=$level, dry_run=$DRY_RUN)"
  if [ "${DRY_RUN:-0}" = "1" ]; then
    printf '%s -> %s (dry-run : version.yaml non modifié)\n' "$cur" "$new"
    return 0
  fi
  local tmp; tmp="$(mktemp)"
  awk -v new="$new" '
    /^version:[[:space:]]/ && !d { sub(/version:.*/, "version: " new); d = 1 }
    { print }
  ' "$VERSION_FILE" > "$tmp" && mv "$tmp" "$VERSION_FILE"
  printf '%s\n' "$new"
}

# cmd_version [--long] : version métier ; --long ajoute les ensembles vivants.
cmd_version() {
  printf '%s\n' "$(_metier_version)"
  if [ "${1:-}" = "--long" ]; then
    if [ -f "$RESSOURCES_FILE" ]; then
      printf '\nEnsembles vivants :\n'
      awk '
        /^ensembles:/ { inens = 1; next }
        inens && /^  [A-Za-z].*:$/ { name = $1; sub(/:$/, "", name); next }
        inens && /^    version:/ { printf "  %-24s %s\n", name, $2 }
      ' "$RESSOURCES_FILE"
    else
      _warn "manifeste absent : $RESSOURCES_FILE"
    fi
  fi
}
