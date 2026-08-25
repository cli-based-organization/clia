#!/usr/bin/env bash
# _scripts/tests/test_extension.sh — banc de USE-006, les extensions.
#
# Une extension est un dépôt git : l'éprouver demande d'en fabriquer un et d'y
# commiter, puisqu'un clone ne rapporte que ce qui est commité. Comme
# test_release, ce banc n'écrit que dans des dépôts jetables créés sous /tmp,
# jamais dans le dépôt clia — c'est vérifié au démarrage et en clôture.
#
# Le HOME est jetable lui aussi : le cache des clones vit sous XDG_CACHE_HOME,
# et le banc ne doit pas toucher celui de l'utilisateur.
#
# Lancement :  bash _scripts/tests/test_extension.sh

set -uo pipefail

RACINE=$(cd -P "$(dirname "${BASH_SOURCE[0]}")/../.." >/dev/null 2>&1 && pwd)

# shellcheck source=banc.sh
. "$(dirname "${BASH_SOURCE[0]}")/banc.sh"

BAC=$(mktemp -d) || exit 1
trap 'rm -rf "$BAC"' EXIT

case "$BAC" in
  /tmp/*|/var/tmp/*) ;;
  *) printf 'banc: le bac n%st pas sous /tmp : %s\n' "'es" "$BAC" >&2; exit 1 ;;
esac

export HOME="$BAC/home"
export XDG_CACHE_HOME="$HOME/.cache"
mkdir -p "$HOME"
CACHE="$XDG_CACHE_HOME/clia/extensions"

SOURCE="$BAC/source"
mkdir -p "$SOURCE/.dev"
cp -r "$RACINE/_scripts" "$RACINE/_ressources" "$SOURCE/"
cp "$RACINE/.dev/clia.yaml" "$SOURCE/.dev/clia.yaml"
CLIA="$SOURCE/_scripts/bin/clia"

EMPREINTE_SOURCE=$(cd "$RACINE" && git status --porcelain 2>/dev/null | sort)
TETE_REELLE=$(cd "$RACINE" && git rev-parse HEAD 2>/dev/null || printf '')

# Un commit dans un dépôt jetable. Jamais ailleurs : le chemin est vérifié.
commiter() {
  local d="$1" message="$2"
  [[ "$d" == "$BAC"/* ]] || { printf 'banc: commit hors du bac : %s\n' "$d" >&2; exit 1; }
  git -C "$d" add -A
  git -C "$d" commit -q -m "$message"
}

# Une extension jetable : un dépôt clia, son namespace, une ressource à lui,
# et un commit — sans quoi il n'y aurait rien à cloner.
fabriquer_extension() {
  local d="$BAC/$1" ns="$2" prefixe="$3" nom="$4"
  "$CLIA" init "$d" >/dev/null 2>&1 || return 1
  sed -i "s|^namespace: .*|namespace: $ns|" "$d/.dev/clia.yaml"
  git -C "$d" config user.email 'banc@example.invalid'
  git -C "$d" config user.name 'banc'
  ( cd "$d" && "$CLIA" res new "$prefixe" "$nom" "Ressource de fixture." >/dev/null )
  mkdir -p "$d/_ressources/$nom/features"
  cat > "$d/_ressources/$nom/features/$nom-feat.md" <<EOF
---
name: $nom-feat
description: Fonctionnalité de fixture, offerte par $ns.
---

Le corps de la fonctionnalité $nom.
EOF
  commiter "$d" 'extension de fixture'
  printf '%s\n' "$d"
}

PROJET="$BAC/projet"
"$CLIA" init "$PROJET" >/dev/null 2>&1 || { printf 'banc: clia init a échoué\n' >&2; exit 1; }
clia() { ( cd "$PROJET" && "$CLIA" "$@" ); }

EXT_A=$(fabriquer_extension outils 'acme.com/outils' OUT outil) || exit 1
EXT_B=$(fabriquer_extension revue 'acme.com/revue' RVU revue) || exit 1

# --------------------------------------------------------------------------

printf 'banc de USE-006 — les extensions\n'
printf 'bac : %s\n' "$BAC"

titre 'Un dépôt sans extension'

rc  "extension ls répond"                     0 clia extension ls
dit "il dit qu'il n'y en a aucune"            'aucune extension déclarée'
dit "et comment en ajouter"                   'clia extension add'
faux "aucun fichier de déclaration"           test -e "$PROJET/.dev/extensions.yaml"

titre 'Ce qui n'\''est pas une extension est refusé'

rc  "add sans URI est refusé"                 2 clia extension add
dit "il rappelle l'usage"                     'clia extension add URI'
rc  "add avec deux URI est refusé"            2 clia extension add a b

VIDE="$BAC/vide"
mkdir -p "$VIDE"; git -C "$VIDE" init -q
rc  "un dépôt sans commit est refusé"         1 clia extension add "$VIDE"
dit "il dit ce qui manque"                    "aucun commit"

QUELCONQUE="$BAC/quelconque"
mkdir -p "$QUELCONQUE"; git -C "$QUELCONQUE" init -q
git -C "$QUELCONQUE" config user.email 'b@x.invalid'; git -C "$QUELCONQUE" config user.name 'b'
printf 'rien\n' > "$QUELCONQUE/README.md"
commiter "$QUELCONQUE" 'un dépôt quelconque'
rc  "un dépôt sans carte est refusé"          1 clia extension add "$QUELCONQUE"
dit "il dit ce qui manque"                    'ne porte pas de \.dev/clia\.yaml'
faux "et rien n'a été déclaré"                test -e "$PROJET/.dev/extensions.yaml"

rc  "une URI inexistante est refusée"         1 clia extension add "$BAC/nulle-part"
dit "il le dit"                               'le clone a échoué'

# Le refus tient au namespace, non au clone : le dépôt doit donc avoir au
# moins un commit pour que le contrôle soit atteint.
git -C "$PROJET" config user.email 'banc@example.invalid'
git -C "$PROJET" config user.name 'banc'
commiter "$PROJET" 'premier commit'
rc  "le dépôt lui-même est refusé"            1 clia extension add "$PROJET"
dit "un dépôt n'est pas sa propre extension"  'sa propre extension'

titre 'extension add'

rc  "add aboutit"                             0 clia extension add "$EXT_A"
dit "il nomme le namespace"                   'acme\.com/outils'
dit "il dit où la déclaration va"             '\.dev/extensions\.yaml'
dit "et où le clone va"                       'clonée dans'
dit "il dit quoi faire ensuite"               'clia res ls --remote acme\.com/outils'

vrai "la déclaration existe"                  test -f "$PROJET/.dev/extensions.yaml"
rc  "elle porte le namespace"                 0 grep -q '^  - namespace: acme.com/outils$' "$PROJET/.dev/extensions.yaml"
rc  "et l'URI"                                0 grep -q "^    uri: $EXT_A\$" "$PROJET/.dev/extensions.yaml"
vrai "le clone est dans le cache"             test -d "$CACHE/acme.com/outils"
vrai "et il porte la carte de l'extension"    test -f "$CACHE/acme.com/outils/.dev/clia.yaml"
faux "le clone n'est pas dans le dépôt"       test -e "$PROJET/_ressources/outil"

rc  "extension ls la voit"                    0 clia extension ls
dit "avec son namespace"                      'acme\.com/outils'
dit "et son état"                             'clonée'

rc  "l'ajouter deux fois ne duplique rien"    0 clia extension add "$EXT_A"
dit "il le dit"                               'déjà déclarée et clonée'
vrai "une seule déclaration"                  test "$(grep -c 'namespace: acme.com/outils' "$PROJET/.dev/extensions.yaml")" = 1

titre 'Une extension est un remote comme un autre'

rc  "res ls --remote la voit"                 0 clia res ls --remote
dit "sa ressource est offerte"                'OUT *outil'
dit "avec son namespace"                      'acme\.com/outils'
rc  "le namespace filtre"                     0 clia res ls --remote 'acme.com/outils'
dit "seule sa ressource reste"                'OUT *outil'
ne_dit_pas "et pas celles du dépôt source"    'INT *intention'

rc  "feature ls --remote la voit"             0 clia feature ls --remote
dit "sa fonctionnalité est offerte"           'outil-feat'
dit "avec sa provenance"                      'acme\.com/outils'

rc  "res activate depuis l'extension"         0 clia res activate 'acme.com/outils' outil
vrai "la ressource est dans le dépôt"         test -f "$PROJET/_ressources/outil/schemas/outil.yaml"
vrai "avec la fonctionnalité qu'elle porte"   test -f "$PROJET/_ressources/outil/features/outil-feat.md"

titre 'Deux extensions cohabitent'

rc  "add la seconde"                          0 clia extension add "$EXT_B"
rc  "extension ls les montre toutes deux"     0 clia extension ls
dit "la première"                             'acme\.com/outils'
dit "la seconde"                              'acme\.com/revue'
vrai "deux déclarations"                      test "$(grep -c '^  - namespace: ' "$PROJET/.dev/extensions.yaml")" = 2
rc  "res ls --remote les distingue"           0 clia res ls --remote
dit "la ressource de la seconde est offerte"  'RVU *revue'

titre 'Une extension déclarée mais non clonée'

# Le cas d'un dépôt cloné sur une autre machine : la déclaration a suivi, le
# cache non. USE-006 demande que l'état le dise.
rm -rf "$CACHE/acme.com/revue"
rc  "extension ls le signale"                 0 clia extension ls
dit "elle est dite non clonée"                'acme\.com/revue *non clonée'
rc  "res ls --remote ne l'offre plus"         0 clia res ls --remote
ne_dit_pas "sa ressource a disparu"           'RVU *revue'
rc  "install refuse tant qu'elle manque"      1 clia extension install 'acme.com/revue'
dit "et dit comment la rétablir"              'clia extension add'
rc  "add la rétablit"                         0 clia extension add "$EXT_B"
dit "il le dit"                               'clone rétabli'
vrai "le clone est revenu"                    test -d "$CACHE/acme.com/revue"
vrai "sans redéclarer"                        test "$(grep -c '^  - namespace: ' "$PROJET/.dev/extensions.yaml")" = 2

titre 'extension install'

rc  "install aboutit"                         0 clia extension install 'acme.com/revue'
dit "il compte ce qui est repris"             'ressource(s) reprise(s)'
vrai "la ressource est là"                    test -f "$PROJET/_ressources/revue/schemas/revue.yaml"
vrai "avec sa fonctionnalité"                 test -f "$PROJET/_ressources/revue/features/revue-feat.md"

rc  "relancer install ne casse rien"          0 clia extension install 'acme.com/revue'
dit "ce qui est déjà là est sauté"            'sautée'

rc  "un namespace inconnu est refusé"         1 clia extension install autre.com/x
dit "il renvoie à la liste"                   'clia extension ls'
rc  "install sans namespace est refusé"       2 clia extension install
rc  "install avec deux namespaces est refusé" 2 clia extension install a b

titre 'Demandes mal formées'

rc  "extension --help répond"                 0 clia extension --help
dit "il nomme les trois verbes"               'add URI'
dit "et explique les deux endroits"           'la déclaration, versionnée'
rc  "un verbe inconnu est refusé"             2 clia extension bidon
dit "il nomme les verbes connus"              'add, ls, install'

titre 'Les alias'

rc  "clia ext ls répond"                      0 clia ext ls
rc  "clia extensions ls répond"               0 clia extensions ls
rc  "clia --help compte la commande une fois" 0 clia --help
dit "extension y figure"                      '^  extension '
ne_dit_pas "ext n'y figure pas"               '^  ext '
ne_dit_pas "et rien n'est masqué"             'masquée'

titre 'Le dépôt réel n'\''est pas touché'

vrai "aucun changement de fichier"            test "$(cd "$RACINE" && git status --porcelain 2>/dev/null | sort)" = "$EMPREINTE_SOURCE"
vrai "HEAD n'a pas bougé"                     test "$(cd "$RACINE" && git rev-parse HEAD 2>/dev/null || printf '')" = "$TETE_REELLE"
faux "et il n'a pas reçu d'extensions"        test -e "$RACINE/.dev/extensions.yaml"

# --------------------------------------------------------------------------

bilan
