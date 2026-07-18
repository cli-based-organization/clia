#!/usr/bin/env bash
# setup.sh - configuration de l'environnement in-repo pour clia.
#
# Usage :
#   . setup.sh activate     ajoute src/bin au PATH (session shell courante)
#
# Doit être *sourcé* (`.` ou `source`) pour que la modification du PATH
# persiste dans le shell appelant. Aucune modification de fichier.

_setup_root="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"

case "${1:-}" in
  activate)
    export PATH="$_setup_root/src/bin:$PATH"
    if command -v clia >/dev/null 2>&1; then
      printf '[OK] clia disponible (%s/src/bin ajouté au PATH)\n' "$_setup_root" >&2
    else
      printf '[WARN] clia introuvable après activation\n' >&2
    fi
    if command -v yq >/dev/null 2>&1; then
      printf '[OK] yq présent (%s)\n' "$(command -v yq)" >&2
    else
      printf '[WARN] yq (mikefarah) absent : dépendance requise par clia pour aide et documentation (REQ-002-NF6).\n' >&2
    fi
    ;;
  ""|-h|--help)
    printf 'Usage : . setup.sh activate\n' >&2
    ;;
  *)
    printf '[ERR] argument inconnu : %s (attendu : activate)\n' "$1" >&2
    ;;
esac

unset _setup_root
