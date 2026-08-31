#!/usr/bin/env bash
# Description: Ramène en arrière ce que le dépôt a repris d'ailleurs.
# Périmètre: dépôt
#
# Implémente .dev/usages/USE-007. Le corps est partagé avec upgrade et
# migrate : voir _scripts/lib/maj.sh.

_CLIA_SENS='downgrade'
# shellcheck source=../maj.sh
. "$CLIA_SOURCE_DIR/_scripts/lib/maj.sh"
