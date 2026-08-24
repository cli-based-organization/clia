#!/usr/bin/env bash
# common.sh - helpers partagés de clia (flux, diagnostics, utilitaires).
# Sourcé par src/bin/clia ; ne s'exécute pas seul.

# Diagnostics : toujours sur stderr (SPEC-001 / REQ-001-NF2).
_info() { printf '%s\n' "$*" >&2; }
_warn() { printf '[WARN] %s\n' "$*" >&2; }
_err()  { printf '[ERR] %s\n' "$*" >&2; }

# _die MESSAGE [CODE] : diagnostic + sortie (CODE défaut 1).
_die() { _err "$1"; exit "${2:-1}"; }

# _dbg MESSAGE : trace de débogage sur stderr si l'option globale --debug est active.
_dbg() { if [ "${DEBUG:-0}" = 1 ]; then printf '[DBG] %s\n' "$*" >&2; fi; }

# _now_iso : horodatage ISO 8601 avec fuseau (ex. 2026-07-10T08:00:00-04:00).
_now_iso() { date +%Y-%m-%dT%H:%M:%S%z | sed -E 's/([0-9]{2})([0-9]{2})$/\1:\2/'; }

# _slugify : minuscules, espaces -> tirets, caractères non alphanumériques retirés.
_slugify() {
  printf '%s' "$1" \
    | tr '[:upper:]' '[:lower:]' \
    | sed -E 's/[[:space:]]+/-/g; s/[^a-z0-9-]//g; s/-+/-/g; s/^-//; s/-$//'
}

# _iso_date ISO : extrait la date AAAA-MM-JJ d'un horodatage ISO.
_iso_date() { printf '%s' "${1:0:10}"; }

# _iso_hms ISO : extrait l'heure HHMMSS d'un horodatage ISO.
_iso_hms() { printf '%s' "$1" | sed -E 's/^[0-9-]+T([0-9]{2}):([0-9]{2}):([0-9]{2}).*/\1\2\3/'; }
