#!/usr/bin/env bash
# Description: Amène les instances du dépôt à la version de leur type.
# Périmètre: dépôt
#
# Implémente .dev/usages/USE-007. Le corps est partagé avec upgrade et
# downgrade : voir _scripts/lib/maj.sh.

_CLIA_SENS='migrate'
# shellcheck source=../maj.sh
. "$CLIA_SOURCE_DIR/_scripts/lib/maj.sh"
