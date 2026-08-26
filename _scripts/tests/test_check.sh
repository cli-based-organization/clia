#!/usr/bin/env bash
# _scripts/tests/test_check.sh — banc de USE-008, la conformité d'un dépôt.
#
# Sans --fix, la commande ne répare rien : chaque cas du constat éprouve donc
# deux choses, ce qu'elle dit et le fait qu'elle n'ait rien touché. Les cas de
# --fix éprouvent l'inverse — l'écart réparé, et le second passage qui ne le
# voit plus. Les dérives sont fabriquées à la main dans un dépôt jetable —
# c'est le seul moyen d'obtenir un dépôt hors conformité, puisque clia n'en
# produit pas.
#
# Comme les autres bancs, celui-ci n'écrit que sous /tmp, jamais dans le dépôt
# clia — c'est vérifié au démarrage et en clôture.
#
# Lancement :  bash _scripts/tests/test_check.sh

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

SOURCE="$BAC/source"
mkdir -p "$SOURCE/.dev"
cp -r "$RACINE/_scripts" "$RACINE/_ressources" "$SOURCE/"
cp "$RACINE/.dev/clia.yaml" "$SOURCE/.dev/clia.yaml"
CLIA="$SOURCE/_scripts/bin/clia"

EMPREINTE_SOURCE=$(cd "$RACINE" && git status --porcelain 2>/dev/null | sort)
TETE_REELLE=$(cd "$RACINE" && git rev-parse HEAD 2>/dev/null || printf '')

# Un dépôt neuf, instrumenté par clia, à chaque cas : les dérives fabriquées
# ici ne doivent pas se transmettre d'un cas au suivant.
neuf() {
  local d="$BAC/$1"
  rm -rf "$d"
  "$CLIA" init "$d" >/dev/null 2>&1 || {
    printf 'banc: clia init a échoué pour %s\n' "$d" >&2; exit 1
  }
  printf '%s\n' "$d"
}

# L'empreinte d'un dépôt : ce que check ne doit jamais changer.
empreinte() {
  ( cd "$1" && find . -path ./.git -prune -o -type f -print0 \
      | sort -z | xargs -0 sha1sum 2>/dev/null )
}

# --------------------------------------------------------------------------

printf 'banc de USE-008 — la conformité d%sun dépôt\n' "'"
printf 'bac : %s\n' "$BAC"

titre 'Un dépôt que clia vient d'\''instrumenter est conforme'

PROJET=$(neuf projet) || exit 1
clia() { ( cd "$PROJET" && "$CLIA" "$@" ); }

AVANT=$(empreinte "$PROJET")
rc  "check aboutit"                           0 clia check
dit "il le dit"                               'conforme'
dit "il nomme le dépôt"                       "^dépôt "
dit "et son namespace"                        '^namespace '
dit "C1 passe"                                'C1 *ok'
dit "C2 passe"                                'C2 *ok'
dit "C3 passe"                                'C3 *ok'
dit "C4 passe"                                'C4 *ok'
dit "C5 passe"                                'C5 *ok'
dit "C6 passe"                                'C6 *ok'
vrai "et rien n'a été modifié"                test "$(empreinte "$PROJET")" = "$AVANT"

titre 'La demande mal formée'

rc  "deux chemins sont refusés"               2 clia check a b
dit "il rappelle l'usage"                     'au plus un chemin'
rc  "un chemin inexistant est refusé"         2 clia check "$BAC/nulle-part"
dit "il le dit"                               "n'existe pas"

PAS_GIT="$BAC/pas-git"
mkdir -p "$PAS_GIT"
rc  "un répertoire hors git est refusé"       2 clia check "$PAS_GIT"
dit "il le dit"                               "pas un dépôt git"
dit "et pourquoi"                             'que sur des dépôts git'

titre 'check accepte le chemin d'\''un autre dépôt'

rc  "un dépôt tiers est vérifié"              0 clia check "$PROJET"
dit "c'est bien lui qui est nommé"            "$PROJET"

titre 'C1 — la carte absente'

SANS_CARTE=$(neuf sans-carte) || exit 1
rm "$SANS_CARTE/.dev/clia.yaml"
rc  "l'absence de carte est bloquante"        1 clia check "$SANS_CARTE"
dit "C1 échoue"                               'C1 *ÉCHEC'
dit "il dit ce qui manque"                    'ne porte pas \.dev/clia\.yaml'
dit "et il dit quoi poser"                    'maturity: unstable'
dit "le bilan compte l'écart"                 '1 écart'

titre 'C1 — la carte incomplète'

AMPUTEE=$(neuf amputee) || exit 1
grep -v '^maturity:' "$AMPUTEE/.dev/clia.yaml" > "$AMPUTEE/.dev/c.tmp"
mv "$AMPUTEE/.dev/c.tmp" "$AMPUTEE/.dev/clia.yaml"
rc  "un champ manquant est bloquant"          1 clia check "$AMPUTEE"
dit "C1 échoue"                               'C1 *ÉCHEC'
dit "il nomme le champ"                       'maturity'

titre 'C2 — le harnais'

SANS_HARNAIS=$(neuf sans-harnais) || exit 1
rm "$SANS_HARNAIS/CLAUDE.md"
rc  "un harnais absent n'est pas bloquant"    0 clia check "$SANS_HARNAIS"
dit "C2 avertit"                              'C2 *avert'
dit "il dit comment en poser un"              'clia harness-ia init'

NON_INVENTORIE=$(neuf non-inventorie) || exit 1
grep -v 'harness' "$NON_INVENTORIE/.dev/clia.yaml" \
  | grep -v 'nom: harness-ia' > "$NON_INVENTORIE/.dev/c.tmp"
mv "$NON_INVENTORIE/.dev/c.tmp" "$NON_INVENTORIE/.dev/clia.yaml"
rc  "un harnais hors inventaire avertit"      0 clia check "$NON_INVENTORIE"
dit "C2 avertit"                              'C2 *avert'
dit "il dit comment l'y inscrire"             'clia harness-ia init --force'

VIEUX=$(neuf vieux) || exit 1
sed -i 's/^    version: .*/    version: 0.0.1/' "$VIEUX/.dev/clia.yaml"
rc  "un harnais en retard avertit"            0 clia check "$VIEUX"
dit "C2 avertit"                              'C2 *avert'
dit "il donne les deux versions"              '0\.0\.1'
dit "et comment régénérer"                    'clia harness-ia init --force'

titre 'C3 — une extension déclarée mais non clonée'

ORPHELINE=$(neuf orpheline) || exit 1
cat >> "$ORPHELINE/.dev/clia.yaml" <<'EOF'
  - type: extension
    namespace: acme.com/absente
    nom: absente
    version: 0.1.0
    uri: git@example.invalid:acme/absente.git
EOF
rc  "le clone manquant est bloquant"          1 clia check "$ORPHELINE"
dit "C3 échoue"                               'C3 *ÉCHEC'
dit "il nomme l'extension"                    'acme\.com/absente'
dit "et dit comment rétablir le clone"        'clia extension add git@example'

titre 'C4 — ce qui est inventorié a disparu du disque'

FANTOME=$(neuf fantome) || exit 1
cat >> "$FANTOME/.dev/clia.yaml" <<'EOF'
  - type: ressource
    namespace: acme.com/x
    nom: disparue
    version: 0.1.0
  - type: skill
    namespace: acme.com/x
    nom: envole
    version: 0.1.0
  - type: feature
    namespace: acme.com/x
    nom: evaporee
    version: 0.1.0
EOF
rc  "les entrées orphelines avertissent"      0 clia check "$FANTOME"
dit "la ressource est signalée"               'ressource disparue'
dit "le skill aussi"                          'skill envole'
dit "et la fonctionnalité"                    'evaporee'
dit "sans rien bloquer"                       'conforme, avec'

titre 'C5 — une ressource du disque hors inventaire'

MUETTE=$(neuf muette) || exit 1
mkdir -p "$MUETTE/_ressources/orpheline/schemas"
printf 'nom: orpheline\ndescription: posée à la main\n' \
  > "$MUETTE/_ressources/orpheline/schemas/orpheline.yaml"
rc  "elle avertit sans bloquer"               0 clia check "$MUETTE"
dit "C5 avertit"                              'C5 *avert'
dit "il la nomme"                             'ressource orpheline'
dit "et dit où la réinscrire"                 'sous installe'

titre 'C6 — l'\''emplacement abandonné'

ANCIENNE=$(neuf ancienne) || exit 1
printf 'extensions:\n' > "$ANCIENNE/.dev/extensions.yaml"
AVANT_ANCIENNE=$(empreinte "$ANCIENNE")
rc  "il est signalé sans bloquer"             0 clia check "$ANCIENNE"
dit "C6 avertit"                              'C6 *avert'
dit "il nomme le fichier"                     '\.dev/extensions\.yaml'
dit "et dit où les extensions vont"           '\.dev/clia\.yaml'
vrai "le fichier n'est pas retiré"            test -f "$ANCIENNE/.dev/extensions.yaml"
vrai "et rien n'a été modifié"                test "$(empreinte "$ANCIENNE")" = "$AVANT_ANCIENNE"

# Le cas qui a motivé USE-008 : les extensions de l'ancien fichier sont encore
# lues, donc encore vérifiées. Un dépôt cloné ailleurs n'en a pas le clone, et
# les deux constats se cumulent.
CSCN=$(neuf cscn) || exit 1
printf 'extensions:\n  - namespace: acme.com/x\n    uri: git@example.invalid:acme/x.git\n' \
  > "$CSCN/.dev/extensions.yaml"
rc  "l'ancien fichier reste lu"               1 clia check "$CSCN"
dit "C6 signale l'emplacement"                'C6 *avert'
dit "et C3 le clone manquant"                 'C3 *ÉCHEC'
dit "l'extension y est nommée"                'acme\.com/x'

titre 'Un cycle installation/désinstallation est neutre'

CYCLE=$(neuf cycle) || exit 1
CARTE_INITIALE=$(cat "$CYCLE/.dev/clia.yaml")
HARNAIS_INITIAL=$(cat "$CYCLE/CLAUDE.md")

cycle() { ( cd "$CYCLE" && "$CLIA" "$@" ); }

rc  "la fonctionnalité s'installe"            0 cycle feature install session
rc  "elle est inventoriée"                    0 grep -q '^    nom: session$' "$CYCLE/.dev/clia.yaml"
rc  "avec une version, non un vide"           0 grep -A1 '^    nom: session$' "$CYCLE/.dev/clia.yaml"
ne_dit_pas "la version n'est pas vide"        '^    version: *$'
rc  "check reste conforme"                    0 cycle check
ne_dit_pas "sans avertissement"               'avert'

rc  "elle se désinstalle"                     0 cycle feature uninstall session
vrai "la carte est revenue à l'identique"     test "$(cat "$CYCLE/.dev/clia.yaml")" = "$CARTE_INITIALE"
vrai "le harnais aussi"                       test "$(cat "$CYCLE/CLAUDE.md")" = "$HARNAIS_INITIAL"
rc  "check reste conforme"                    0 cycle check
ne_dit_pas "et toujours sans avertissement"   'avert'

titre 'Le même cycle pour un skill'

mkdir -p "$CYCLE/_ressources/essai/schemas" "$CYCLE/_ressources/essai/skills"
printf 'nom: essai\ndescription: ressource du banc\n' \
  > "$CYCLE/_ressources/essai/schemas/essai.yaml"
printf -- '---\nname: bidule\ndescription: skill du banc.\n---\n\nCorps.\n' \
  > "$CYCLE/_ressources/essai/skills/bidule.md"
CARTE_AVEC_ESSAI=$(cat "$CYCLE/.dev/clia.yaml")

rc  "le skill s'installe"                     0 cycle skill install bidule
rc  "il est inventorié"                       0 grep -q '^    nom: bidule$' "$CYCLE/.dev/clia.yaml"
rc  "avec le namespace du dépôt"              0 grep -B1 '^    nom: bidule$' "$CYCLE/.dev/clia.yaml"
dit "celui de la carte"                       'namespace'
vrai "et le fichier est posé"                 test -f "$CYCLE/.claude/skills/bidule/SKILL.md"

rc  "il se désinstalle"                       0 cycle skill uninstall bidule
faux "le fichier est retiré"                  test -e "$CYCLE/.claude/skills/bidule"
vrai "et la carte est revenue"                test "$(cat "$CYCLE/.dev/clia.yaml")" = "$CARTE_AVEC_ESSAI"

titre 'Désactiver solde une entrée sans section'

SOLDE=$(neuf solde) || exit 1
solde() { ( cd "$SOLDE" && "$CLIA" "$@" ); }
rc  "la fonctionnalité s'installe"            0 solde feature install session
# La section est retirée à la main : l'entrée reste, et c'est l'écart que C4
# signale. Désactiver doit pouvoir le solder.
sed -i '\|<!-- BEGIN session feature -->|,\|<!-- END session feature -->|d' \
  "$SOLDE/CLAUDE.md"
rc  "check signale l'entrée orpheline"        0 solde check
dit "C4 avertit"                              'C4 *avert'
rc  "désactiver la solde"                     0 solde feature uninstall session
rc  "check n'a plus rien à dire"              0 solde check
ne_dit_pas "plus d'avertissement"             'avert'

# --------------------------------------------------------------------------
# --fix
# --------------------------------------------------------------------------
#
# Le constat et la réparation partagent les six contrôles : chaque cas éprouve
# donc l'écart réparé, et le fait que le second passage de check ne le voie
# plus. Ce qui n'est pas réparable est éprouvé aussi — un geste que --fix
# refuse de faire est une décision, et elle doit rester visible.

titre '--fix — la demande'

rc  "une option inconnue est refusée"         2 clia check --oups
dit "il rappelle l'usage"                     'clia check \[PATH\] \[--fix\]'
rc  "deux chemins avec --fix sont refusés"    2 clia check a b --fix
rc  "l'aide mentionne --fix"                  0 clia check --help
dit "et ce qu'il ne répare pas"               'ne répare pas'

titre '--fix sur un dépôt conforme ne fait rien'

SAIN=$(neuf sain) || exit 1
AVANT_SAIN=$(empreinte "$SAIN")
rc  "il aboutit"                              0 clia check --fix "$SAIN"
dit "il dit qu'il n'y avait rien à réparer"   'rien à réparer'
dit "et que le dépôt est conforme"            'conforme'
vrai "rien n'a été modifié"                   test "$(empreinte "$SAIN")" = "$AVANT_SAIN"

titre '--fix pose la carte absente'

SANS_CARTE2=$(neuf sans-carte2) || exit 1
rm "$SANS_CARTE2/.dev/clia.yaml"
rc  "le constat annonce la réparation"        1 clia check "$SANS_CARTE2"
dit "il dit par quoi"                         'réparables : clia check --fix'
vrai "et il n'a rien posé"                    test ! -f "$SANS_CARTE2/.dev/clia.yaml"

rc  "--fix aboutit"                           0 clia check --fix "$SANS_CARTE2"
dit "il dit ce qu'il a posé"                  'réparé  *C1'
dit "et que le namespace reste à compléter"   'namespace à compléter'
dit "C1 passe désormais"                      'C1 *ok'
vrai "la carte est là"                        test -f "$SANS_CARTE2/.dev/clia.yaml"
rc  "avec ses quatre champs"                  0 grep -q '^maturity: unstable$' "$SANS_CARTE2/.dev/clia.yaml"
rc  "et un namespace à compléter, non deviné" 0 grep -q '^namespace: <publisher>/' "$SANS_CARTE2/.dev/clia.yaml"

titre '--fix complète la carte amputée sans casser l'\''inventaire'

AMPUTEE2=$(neuf amputee2) || exit 1
grep -v '^maturity:' "$AMPUTEE2/.dev/clia.yaml" > "$AMPUTEE2/.dev/c.tmp"
mv "$AMPUTEE2/.dev/c.tmp" "$AMPUTEE2/.dev/clia.yaml"
rc  "--fix aboutit"                           0 clia check --fix "$AMPUTEE2"
dit "il nomme le champ ajouté"                'complété : maturity'
dit "C1 passe"                                'C1 *ok'
dit "et le harnais reste inventorié"          'C2 *ok'
rc  "le champ est dans l'entête"              0 awk '/^installe:/ { fin = 1 } /^maturity:/ && !fin { ok = 1 } END { exit !ok }' "$AMPUTEE2/.dev/clia.yaml"

titre '--fix pose un harnais absent'

SANS_HARNAIS2=$(neuf sans-harnais2) || exit 1
rm "$SANS_HARNAIS2/CLAUDE.md"
rc  "--fix aboutit"                           0 clia check --fix "$SANS_HARNAIS2"
dit "il dit l'avoir posé"                     'CLAUDE.md posé'
dit "C2 passe"                                'C2 *ok'
vrai "le fichier est là"                      test -f "$SANS_HARNAIS2/CLAUDE.md"

titre '--fix ne régénère pas un harnais en retard : c'\''est une décision'

VIEUX2=$(neuf vieux2) || exit 1
sed -i 's/^    version: .*/    version: 0.0.1/' "$VIEUX2/.dev/clia.yaml"
HARNAIS_VIEUX=$(cat "$VIEUX2/CLAUDE.md")
rc  "--fix aboutit"                           0 clia check --fix "$VIEUX2"
dit "il n'a rien à réparer"                   'rien à réparer'
dit "C2 avertit toujours"                     'C2 *avert'
dit "et dit à qui revient le geste"           'clia harness-ia init --force'
vrai "le harnais est intact"                  test "$(cat "$VIEUX2/CLAUDE.md")" = "$HARNAIS_VIEUX"

titre '--fix solde les entrées dont l'\''objet a disparu'

FANTOME2=$(neuf fantome2) || exit 1
cat >> "$FANTOME2/.dev/clia.yaml" <<'EOF'
  - type: ressource
    namespace: acme.com/x
    nom: disparue
    version: 0.1.0
  - type: skill
    namespace: acme.com/x
    nom: envole
    version: 0.1.0
EOF
rc  "--fix aboutit"                           0 clia check --fix "$FANTOME2"
dit "la ressource est retirée"                'ressource disparue : entrée retirée'
dit "le skill aussi"                          'skill envole : entrée retirée'
dit "C4 passe"                                'C4 *ok'
faux "l'entrée n'est plus dans la carte"      grep -q '^    nom: disparue$' "$FANTOME2/.dev/clia.yaml"
faux "ni celle du skill"                      grep -q '^    nom: envole$' "$FANTOME2/.dev/clia.yaml"

titre '--fix inscrit la ressource du disque'

MUETTE2=$(neuf muette2) || exit 1
mkdir -p "$MUETTE2/_ressources/orpheline/schemas"
printf 'nom: orpheline\nversion: 0.4.2\ndescription: posée à la main\n' \
  > "$MUETTE2/_ressources/orpheline/schemas/orpheline.yaml"
rc  "--fix aboutit"                           0 clia check --fix "$MUETTE2"
dit "il l'inscrit"                            'ressource orpheline : inscrite'
dit "en disant la provenance supposée"        'provenance supposée locale'
dit "C5 passe"                                'C5 *ok'
rc  "l'entrée est dans la carte"              0 grep -q '^    nom: orpheline$' "$MUETTE2/.dev/clia.yaml"
rc  "avec la version de son schéma"           0 grep -q '^    version: 0.4.2$' "$MUETTE2/.dev/clia.yaml"

titre '--fix fond l'\''ancien fichier d'\''extensions dans l'\''inventaire'

ANCIENNE2=$(neuf ancienne2) || exit 1
printf 'extensions:\n  - namespace: acme.com/y\n    uri: git@example.invalid:acme/y.git\n' \
  > "$ANCIENNE2/.dev/extensions.yaml"
rc  "--fix aboutit, le clone manquant reste"  1 clia check --fix "$ANCIENNE2"
dit "il dit avoir retiré le fichier"          '\.dev/extensions\.yaml retiré'
dit "C6 passe"                                'C6 *ok'
dit "et C3 voit toujours l'extension"         'C3 *ÉCHEC'
faux "l'ancien fichier n'est plus là"         test -f "$ANCIENNE2/.dev/extensions.yaml"
rc  "l'extension est dans l'inventaire"       0 grep -q '^    namespace: acme.com/y$' "$ANCIENNE2/.dev/clia.yaml"
rc  "avec son uri"                            0 grep -q '^    uri: git@example.invalid:acme/y.git$' "$ANCIENNE2/.dev/clia.yaml"

titre '--fix dit ce qu'\''il n'\''a pas pu réparer'

INJOIGNABLE=$(neuf injoignable) || exit 1
cat >> "$INJOIGNABLE/.dev/clia.yaml" <<'EOF'
  - type: extension
    namespace: acme.com/absente
    nom: absente
    version: 0.1.0
    uri: git@example.invalid:acme/absente.git
EOF
rc  "l'écart bloquant demeure"                1 clia check --fix "$INJOIGNABLE"
dit "l'échec du geste est dit"                'échec  *C3'
dit "avec la commande qui dira pourquoi"      'clia extension add git@example'
dit "et le bilan le compte"                   '1 échec'
dit "il invite à relancer plus tard"          'restent réparables'

titre '--fix rétablit le clone d'\''une extension joignable'

# Une extension locale, clonable sans réseau : le geste doit aboutir, là où
# celui du cas précédent ne le peut pas.
EXT="$BAC/ext-locale"
"$CLIA" init "$EXT" >/dev/null 2>&1 || { printf 'banc: init extension\n' >&2; exit 1; }
sed -i 's|^namespace: .*|namespace: acme.com/locale|' "$EXT/.dev/clia.yaml"
git -C "$EXT" config user.email 'banc@example.invalid'
git -C "$EXT" config user.name 'banc'
git -C "$EXT" add -A >/dev/null 2>&1
git -C "$EXT" commit -q -m 'extension de fixture' >/dev/null 2>&1

CLONE=$(neuf clone) || exit 1
dans() { local d="$1"; shift; ( cd "$d" && "$CLIA" "$@" ); }
rc  "l'extension s'ajoute"                    0 dans "$CLONE" extension add "$EXT"
CACHE="$XDG_CACHE_HOME/clia/extensions/acme.com/locale"
vrai "elle est clonée"                        test -d "$CACHE"
rm -rf "$CACHE"
rc  "sans son clone, check bloque"            1 clia check "$CLONE"
dit "C3 échoue"                               'C3 *ÉCHEC'
rc  "--fix rétablit le clone"                 0 clia check --fix "$CLONE"
dit "il le dit"                               'clone rétabli'
dit "C3 passe"                                'C3 *ok'
vrai "le clone est revenu"                    test -d "$CACHE"

titre '--fix est idempotent'

DOUBLE=$(neuf double) || exit 1
rm "$DOUBLE/.dev/clia.yaml"
printf 'extensions:\n' > "$DOUBLE/.dev/extensions.yaml"
rc  "le premier passage répare"               0 clia check --fix "$DOUBLE"
dit "il le dit"                               'réparé'
APRES=$(empreinte "$DOUBLE")
rc  "le second n'a plus rien à faire"         0 clia check --fix "$DOUBLE"
dit "il le dit"                               'rien à réparer'
vrai "et le dépôt n'a pas rebougé"            test "$(empreinte "$DOUBLE")" = "$APRES"

titre 'Le chemin se place avant ou après --fix'

ORDRE=$(neuf ordre) || exit 1
rc  "clia check PATH --fix"                   0 clia check "$ORDRE" --fix
dit "c'est bien lui qui est vérifié"          "$ORDRE"
rc  "clia check --fix PATH"                   0 clia check --fix "$ORDRE"
dit "et lui encore"                           "$ORDRE"

titre 'Le dépôt source de clia est lui-même conforme'

# Le dépôt qui fournit la commande doit la satisfaire : une ressource ajoutée
# sans être inventoriée se verrait ici, et nulle part ailleurs.
rc  "check aboutit sur le dépôt clia"         0 clia check "$RACINE"
dit "il le dit"                               'conforme'
ne_dit_pas "sans le moindre avertissement"    'avert'

titre 'Le dépôt réel n'\''est pas touché'

vrai "aucun changement de fichier"            test "$(cd "$RACINE" && git status --porcelain 2>/dev/null | sort)" = "$EMPREINTE_SOURCE"
vrai "HEAD n'a pas bougé"                     test "$(cd "$RACINE" && git rev-parse HEAD 2>/dev/null || printf '')" = "$TETE_REELLE"

# --------------------------------------------------------------------------

bilan
