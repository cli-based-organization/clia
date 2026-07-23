#!/usr/bin/env bash
# Test de clia en bac à sable isolé (aucune écriture hors du répertoire temporaire).
# Couvre : clia release (major|minor|patch, dry-run, erreurs) et la cohérence
# dispatch/documentation (REQ-001-F9). Lancer : bash test/test_clia.sh
set -euo pipefail

HERE="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"
SRC="$(dirname "$HERE")/src"
pass=0; fail=0
check() {
  if [ "$2" = "$3" ]; then pass=$((pass + 1))
  else fail=$((fail + 1)); printf 'FAIL: %s (attendu "%s", obtenu "%s")\n' "$1" "$3" "$2"; fi
}

SB="$(mktemp -d)"; trap 'rm -rf "$SB"' EXIT
cp -r "$SRC" "$SB/src"
printf 'version: 1.2.3\n' > "$SB/version.yaml"
CLIA="$SB/src/bin/clia"
ver() { sed -n 's/^version:[[:space:]]*//p' "$SB/version.yaml"; }

# release : bumps semver
check "release patch (stdout)" "$("$CLIA" release patch)" "1.2.4"
check "release patch (fichier)" "$(ver)" "1.2.4"
"$CLIA" release minor >/dev/null
check "release minor" "$(ver)" "1.3.0"
"$CLIA" release major >/dev/null
check "release major" "$(ver)" "2.0.0"

# dry-run : n'écrit pas
"$CLIA" --dry-run release major >/dev/null
check "dry-run n'écrit pas" "$(ver)" "2.0.0"

# erreurs d'usage (code 2)
set +e
"$CLIA" release        >/dev/null 2>&1; check "release sans arg -> 2" "$?" "2"
"$CLIA" release bogus  >/dev/null 2>&1; check "release invalide -> 2" "$?" "2"
set -e

# cohérence dispatch/documentation (REQ-001-F9)
rc=0
(
  set +e
  # shellcheck disable=SC1091
  . "$SB/src/lib/common.sh"
  DOC_FILE="$SB/src/clia.doc.yaml"
  . "$SB/src/lib/doc.sh"; . "$SB/src/lib/version.sh"
  . "$SB/src/lib/resource.sh"; . "$SB/src/lib/session.sh"
  _doc_selfcheck
) || rc=$?
check "cohérence dispatch/documentation" "$rc" "0"

printf -- '----\nPASS=%d FAIL=%d\n' "$pass" "$fail"
[ "$fail" -eq 0 ]
