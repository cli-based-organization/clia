#!/usr/bin/env bash
# Description: Met à jour ce que le dépôt a repris d'ailleurs.
# Périmètre: dépôt
#
# Implémente .dev/usages/USE-007. Le corps est partagé avec downgrade et
# migrate : voir _scripts/lib/maj.sh, qui dit pourquoi trois fichiers plutôt
# qu'un seul avec des alias.

_CLIA_SENS='upgrade'
# shellcheck source=../maj.sh
. "$CLIA_SOURCE_DIR/_scripts/lib/maj.sh"
