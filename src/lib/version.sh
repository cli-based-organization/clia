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
