#!/usr/bin/env bash
# _scripts/tests/test_release.sh — banc de clia release, et de USE-004.
#
# Ce banc est le seul du dépôt qui écrive dans un historique git : release
# commite et tague, on ne peut pas l'éprouver autrement. Toutes ses écritures
# vont dans des dépôts jetables créés sous /tmp par mktemp, jamais dans le
# dépôt clia — c'est vérifié au démarrage et en clôture.
#
# Lancement :  bash _scripts/tests/test_release.sh

set -uo pipefail

RACINE=$(cd -P "$(dirname "${BASH_SOURCE[0]}")/../.." >/dev/null 2>&1 && pwd)

# shellcheck source=banc.sh
. "$(dirname "${BASH_SOURCE[0]}")/banc.sh"

BAC=$(mktemp -d) || exit 1
trap 'rm -rf "$BAC"' EXIT

# Garde : rien de ce qui suit ne doit pouvoir atteindre le dépôt réel.
case "$BAC" in
  /tmp/*|/var/tmp/*) ;;
  *) printf 'banc: le bac n%st pas sous /tmp : %s\n' "'es" "$BAC" >&2; exit 1 ;;
esac
if [[ "$BAC" == "$RACINE"* ]]; then
  printf 'banc: le bac est dans le dépôt réel, abandon\n' >&2
  exit 1
fi

SOURCE="$BAC/source"
mkdir -p "$SOURCE"
cp -r "$RACINE/_scripts" "$RACINE/_ressources" "$SOURCE/"
CLIA="$SOURCE/_scripts/bin/clia"

EMPREINTE_SOURCE=$(cd "$RACINE" && git status --porcelain 2>/dev/null | sort)
TETE_REELLE=$(cd "$RACINE" && git rev-parse HEAD 2>/dev/null || printf '')

# Un dépôt jetable instrumenté, avec une identité git à lui.
depot_neuf() {
  local d="$BAC/$1"
  "$CLIA" init "$d" >/dev/null 2>&1 || return 1
  git -C "$d" config user.email 'banc@example.invalid'
  git -C "$d" config user.name 'banc'
  printf '%s\n' "$d"
}

# Un commit dans un dépôt jetable. Jamais ailleurs : le chemin est vérifié.
commiter() {
  local d="$1" message="$2"
  [[ "$d" == "$BAC"/* ]] || { printf 'banc: commit hors du bac : %s\n' "$d" >&2; exit 1; }
  git -C "$d" add -A
  git -C "$d" commit -q -m "$message"
}

clia_dans() { local d="$1"; shift; ( cd "$d" && "$CLIA" "$@" ); }

# --------------------------------------------------------------------------

printf 'banc de clia release — USE-004\n'
printf 'bac : %s\n' "$BAC"

titre 'Un dépôt sans version'

NUE="$BAC/nue"
mkdir -p "$NUE"
git -C "$NUE" init -q
git -C "$NUE" config user.email 'banc@example.invalid'
git -C "$NUE" config user.name 'banc'

rc  "ls refuse faute de version"              1 clia_dans "$NUE" release ls
dit "et il dit où elle se déclare"            '\.dev/clia\.yaml'
rc  "patch refuse aussi"                      1 clia_dans "$NUE" release patch
dit "il dit qu'il n'y a rien à incrémenter" 'rien à incrémenter'

titre 'Un dépôt instrumenté, avant tout commit'

D=$(depot_neuf projet) || { printf 'banc: init a échoué\n' >&2; exit 1; }
rc  "ls répond"                               0 clia_dans "$D" release ls
dit "la version déclarée est celle de init"   '^version déclarée   0\.1\.0$'
dit "aucune version n'est publiée"          "n'a jamais été commité"

titre 'La première publication est le commit qui pose le fichier'

commiter "$D" 'premier commit'
rc  "ls la voit"                              0 clia_dans "$D" release ls
dit "la version est listée"                   '^0\.1\.0 '
dit "sans tag, car aucun n'a été posé"      '0\.1\.0.*—'
dit "et la version effective est nette"       '^version effective  0\.1\.0$'

titre 'La version de développement porte le hash'

printf 'du travail\n' > "$D/travail.md"
commiter "$D" 'du travail'
rc  "ls répond"                               0 clia_dans "$D" release ls
dit "la version effective porte un hash"      '^version effective  0\.1\.0+[0-9a-f]\{7,\}'
dit "et le dit en clair"                      'le dépôt a avancé'
dit "la version déclarée, elle, ne bouge pas" '^version déclarée   0\.1\.0$'

titre 'release patch'

rc  "patch aboutit"                           0 clia_dans "$D" release patch
dit "il annonce l'incrément"                'version 0\.1\.0 -> 0\.1\.1'
dit "le commit"                               'commit créé : release 0\.1\.1'
dit "et le tag"                               'tag posé    : v0\.1\.1'

vrai "le fichier porte la nouvelle version"   grep -q '^version: 0.1.1$' "$D/.dev/clia.yaml"
vrai "le tag existe"                          git -C "$D" rev-parse --verify --quiet refs/tags/v0.1.1
vrai "le dépôt est propre"                    test -z "$(git -C "$D" status --porcelain)"
vrai "le commit ne porte que la carte"        test "$(git -C "$D" show --name-only --format= HEAD)" = '.dev/clia.yaml'
vrai "le message est celui annoncé"           test "$(git -C "$D" show -s --format=%s HEAD)" = 'release 0.1.1'

# Le reste du fichier appartient au dépôt : la commande n'y touche pas.
rc  "les commentaires sont préservés"         0 grep -q "carte d'identité" "$D/.dev/clia.yaml"
rc  "le namespace aussi"                      0 grep -q '^namespace: ' "$D/.dev/clia.yaml"
rc  "et la maturité"                          0 grep -q '^maturity: ' "$D/.dev/clia.yaml"

rc  "ls liste les deux publications"          0 clia_dans "$D" release ls
dit "la plus récente en premier"              '^0\.1\.1 '
dit "avec son tag"                            '0\.1\.1.*v0\.1\.1'
dit "et l'ancienne dessous"                 '^0\.1\.0 '
dit "la version effective est nette à nouveau" '^version effective  0\.1\.1$'

titre 'Les trois refus de USE-004'

rc  "sans changement, patch refuse"           1 clia_dans "$D" release patch
dit "il dit pourquoi"                         "rien n'a changé depuis la publication"
dit "et que rien n'a été modifié"           "rien n'a été modifié"
vrai "la version n'a pas bougé"             grep -q '^version: 0.1.1$' "$D/.dev/clia.yaml"

printf 'encore du travail\n' > "$D/autre.md"
rc  "sur un dépôt sale, patch refuse"         1 clia_dans "$D" release patch
dit "il dit que le dépôt n'est pas propre"  "le dépôt n'est pas propre"
vrai "la version n'a pas bougé"             grep -q '^version: 0.1.1$' "$D/.dev/clia.yaml"
commiter "$D" 'encore du travail'

git -C "$D" checkout -q -b une-branche
rc  "hors de la branche de publication, refus" 1 clia_dans "$D" release patch
dit "il nomme les deux branches"              'publication : main'
vrai "la version n'a pas bougé"             grep -q '^version: 0.1.1$' "$D/.dev/clia.yaml"
git -C "$D" checkout -q main

titre 'minor et major'

rc  "minor aboutit"                           0 clia_dans "$D" release minor
dit "il remet le correctif à zéro"            'version 0\.1\.1 -> 0\.2\.0'
printf 'suite\n' > "$D/suite.md"; commiter "$D" 'suite'
rc  "major aboutit"                           0 clia_dans "$D" release major
dit "il remet mineur et correctif à zéro"     'version 0\.2\.0 -> 1\.0\.0'
vrai "les quatre tags existent"               bash -c 'for v in 0.1.1 0.2.0 1.0.0; do git -C "'"$D"'" rev-parse --verify --quiet "refs/tags/v$v" >/dev/null || exit 1; done'
rc  "ls liste les quatre publications"        0 clia_dans "$D" release ls
vrai "quatre lignes de version"               test "$(clia_dans "$D" release ls | grep -c '^[0-9]\+\.[0-9]\+\.[0-9]\+ ')" = 4

titre 'Un tag déjà posé bloque'

printf 'travail\n' > "$D/encore.md"; commiter "$D" 'travail'
git -C "$D" tag v1.0.1
rc  "patch refuse"                            1 clia_dans "$D" release patch
dit "il nomme le tag"                         'v1\.0\.1 existe déjà'
vrai "la version n'a pas bougé"             grep -q '^version: 1.0.0$' "$D/.dev/clia.yaml"
git -C "$D" tag -d v1.0.1 >/dev/null

titre 'Une version qui n'\''est pas un semver'

E=$(depot_neuf casse) || exit 1
sed -i 's|^version: .*|version: pas-un-semver|' "$E/.dev/clia.yaml"
commiter "$E" 'version illisible'
rc  "patch refuse"                            1 clia_dans "$E" release patch
dit "il dit ce qui est attendu"               'X\.Y\.Z'

titre 'Demandes mal formées'

rc  "release --help répond"                   0 clia_dans "$D" release --help
dit "il nomme les quatre verbes"              'major | minor | patch'
rc  "un verbe inconnu est refusé"             2 clia_dans "$D" release bidon
dit "et il nomme les verbes connus"           'ls, major, minor, patch'
rc  "un argument en trop est refusé"          2 clia_dans "$D" release patch 3

titre 'La commande est découvrable'

# SORTIE est ce que « dit » et « ne_dit_pas » lisent.
# shellcheck disable=SC2034
SORTIE=$(clia_dans "$D" --help 2>&1)
dit "clia --help annonce release"             '^  release '
ne_dit_pas "et rien n'est masqué"           'masquée'

titre 'Le dépôt réel n'\''a pas été touché'

vrai "aucun changement de fichier"            test "$(cd "$RACINE" && git status --porcelain 2>/dev/null | sort)" = "$EMPREINTE_SOURCE"
vrai "HEAD n'a pas bougé"                   test "$(cd "$RACINE" && git rev-parse HEAD 2>/dev/null || printf '')" = "$TETE_REELLE"
faux "aucun tag de version n'y a été posé"  bash -c "git -C '$RACINE' rev-parse --verify --quiet refs/tags/v0.1.1 >/dev/null"

# --------------------------------------------------------------------------

bilan
