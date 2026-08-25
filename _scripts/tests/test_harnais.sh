#!/usr/bin/env bash
# _scripts/tests/test_harnais.sh — banc des commandes harness-ia, skill et feature.
#
# Deux dépôts jetables, parce que les commandes en distinguent deux : un
# dépôt source, copie du dépôt réel augmentée de skills de fixture, et un
# dépôt de travail, qui reçoit le harnais. Le dépôt réel n'est jamais écrit —
# ni comme source, ni comme cible — et c'est vérifié en fin de banc.
#
# Lancement :  bash _scripts/tests/test_harnais.sh

set -uo pipefail

RACINE=$(cd -P "$(dirname "${BASH_SOURCE[0]}")/../.." >/dev/null 2>&1 && pwd)

# shellcheck source=banc.sh
. "$(dirname "${BASH_SOURCE[0]}")/banc.sh"

# --------------------------------------------------------------------------
# Les deux dépôts
# --------------------------------------------------------------------------

BAC=$(mktemp -d) || exit 1
trap 'rm -rf "$BAC"' EXIT

SOURCE="$BAC/source"
mkdir -p "$SOURCE"
cp -r "$RACINE/_scripts" "$RACINE/_ressources" "$SOURCE/"

CAT_SKILLS="$SOURCE/_ressources/skill/skills"
mkdir -p "$CAT_SKILLS"

# Deux skills de fixture : le catalogue réel est vide, et un banc qui
# écrirait dedans violerait la règle qu'il est là pour vérifier.
cat > "$CAT_SKILLS/exemple.md" <<'EOF'
---
name: exemple
description: Skill de fixture, sans autre usage que d'être installé puis retiré.
---

# exemple

Procédure de fixture.
EOF
cat > "$CAT_SKILLS/sans-frontmatter.md" <<'EOF'
# sans-frontmatter

Un skill dont le frontmatter manque : la description doit alors être suppléée.
EOF

CLIA="$SOURCE/_scripts/bin/clia"
PROJET="$BAC/projet"
mkdir -p "$PROJET"
git -C "$PROJET" init -q >/dev/null 2>&1 || { printf 'banc: git init a échoué\n' >&2; exit 1; }

HARNAIS="$PROJET/CLAUDE.md"
PRIMITIVE="$SOURCE/_ressources/harness-ia/primitives/CLAUDE.primitive.md"
EMPREINTE_SOURCE=$(cd "$RACINE" && git status --porcelain 2>/dev/null | sort)

# Exécute clia depuis le dépôt de travail, comme le ferait l'utilisateur.
clia() { ( cd "$PROJET" && "$CLIA" "$@" ); }

# Idem, depuis un répertoire quelconque hors dépôt git.
clia_hors_depot() { ( cd "$BAC" && "$CLIA" "$@" ); }

zone() {
  awk -v b="$1" -v e="$2" 'index($0,b){d=1;next} index($0,e){d=0;next} d' "$HARNAIS"
}

# --------------------------------------------------------------------------

printf 'banc du harnais — harness-ia, skill, feature\n'
printf 'source : %s\nprojet : %s\n' "$SOURCE" "$PROJET"

titre 'Le dépôt de travail avant instrumentation'

rc  "harness-ia status répond"                0 clia harness-ia status
dit "il dit que CLAUDE.md est absent"         'absent'
rc  "skill list répond"                       0 clia skill list
dit "les skills offerts nomment la fixture"   'exemple'
dit "et le donne pour non installé"           'non installé'
rc  "feature list répond"                     0 clia feature list
dit "le catalogue nomme session"              'session'
dit "et la donne pour inactive"               'inactive'
rc  "feature install sans harnais est refusé" 1 clia feature install session
dit "et il dit quoi lancer d'abord"           'clia harness-ia init'

titre 'harness-ia init'

rc  "init aboutit"                            0 clia harness-ia init
vrai "CLAUDE.md existe"                       test -f "$HARNAIS"
vrai "il est identique à la primitive"        diff -q "$PRIMITIVE" "$HARNAIS"
rc  "status le voit"                          0 clia harness-ia status
dit "la zone skills est présente"             '^zone skills     présente'
dit "la zone features est présente"           '^zone features   présente'
rc  "un second init est refusé"               1 clia harness-ia init
dit "il dit que rien n'a été modifié"         "rien n'a été modifié"
dit "et il indique --force"                   '--force'
vrai "le fichier est intact"                  diff -q "$PRIMITIVE" "$HARNAIS"
faux "aucune sauvegarde n'a été écrite"       test -e "${HARNAIS}.bak"

titre 'skill install'

rc  "install aboutit"                         0 clia skill install exemple
vrai "le fichier du skill est posé"           test -f "$PROJET/.claude/skills/exemple/SKILL.md"
vrai "il est identique à sa source"           diff -q "$CAT_SKILLS/exemple.md" "$PROJET/.claude/skills/exemple/SKILL.md"
vrai "la section est dans la zone gérée"      bash -c 'grep -q "BEGIN exemple skill" <<<"$(awk -v b="<!-- CLIA:SKILLS:BEGIN -->" -v e="<!-- CLIA:SKILLS:END -->" "index(\$0,b){d=1;next} index(\$0,e){d=0;next} d" "'"$HARNAIS"'")"'
rc  "la description du frontmatter est reprise" 0 grep -q "Skill de fixture" "$HARNAIS"
rc  "un second install ne duplique rien"      0 clia skill install exemple
dit "et il le dit"                            'déjà à jour'
vrai "une seule section dans le fichier"      test "$(grep -c 'BEGIN exemple skill' "$HARNAIS")" = 1
rc  "status le voit"                          0 clia skill status exemple
dit "le fichier est rapporté"                 '\.claude/skills/exemple/SKILL\.md'
dit "la section aussi"                        "section d'activation présente"
rc  "list le donne pour installé"             0 clia skill list
dit "avec la ressource qui l'offre"           'exemple  *skill  *\[installé\]'

rc  "un skill sans frontmatter s'installe"    0 clia skill install sans-frontmatter
rc  "sa description est suppléée"             0 grep -q 'Voir `\?\.claude/skills/sans-frontmatter/SKILL\.md' "$HARNAIS"
rc  "skill inconnu est refusé"                1 clia skill install absent-du-catalogue
dit "et il renvoie à la liste"                'clia skill list'

titre 'feature install'

rc  "install aboutit"                         0 clia feature install session
dit "il dit où elle a été injectée"           'zone gérée'
vrai "la section est dans la zone features"   bash -c 'grep -q "BEGIN session feature" <<<"$(awk -v b="<!-- CLIA:FEATURES:BEGIN -->" -v e="<!-- CLIA:FEATURES:END -->" "index(\$0,b){d=1;next} index(\$0,e){d=0;next} d" "'"$HARNAIS"'")"'
rc  "le corps est injecté, pas le frontmatter" 0 grep -q 'Ne modifie jamais' "$HARNAIS"
faux "le frontmatter n'est pas recopié"       grep -q '^name: session$' "$HARNAIS"
rc  "un second install ne duplique rien"      0 clia feature install session
dit "et il le dit"                            'déjà active'
vrai "une seule section"                      test "$(grep -c 'BEGIN session feature' "$HARNAIS")" = 1
rc  "fonctionnalité inconnue est refusée"     1 clia feature install absente
rc  "status répond"                           0 clia feature status session
dit "elle est active"                         '^état            active$'
dit "et sa ressource est nommée"              '^fournie par     session$'

titre 'Les catalogues sont distribués — SPC-001 S6'

# Une ressource peut vivre sous une catégorie : le balayage doit la trouver
# au second niveau comme au premier, sans qu'aucune liste ne la déclare.
mkdir -p "$SOURCE/_ressources/edition/article/features"
cat > "$SOURCE/_ressources/edition/article/features/relecture.md" <<'EOF'
---
name: relecture
description: Fonctionnalité de fixture, fournie par une ressource dans un namespace.
---

Relire avant de publier.
EOF

rc  "feature list trouve le namespace"        0 clia feature list
dit "la fonctionnalité est listée"            'relecture'
dit "et sa ressource est nommée en entier"    'relecture  *edition/article'
rc  "elle s'installe"                         0 clia feature install relecture
rc  "son corps est injecté"                   0 grep -q 'Relire avant de publier' "$HARNAIS"
rc  "status nomme la ressource qui l'offre"   0 clia feature status relecture
dit "avec son namespace"                      '^fournie par     edition/article$'
rc  "elle se désactive"                       0 clia feature uninstall relecture

titre 'harness-ia status avec des extensions'

rc  "status répond"                           0 clia harness-ia status
dit "il compte deux skills"                   'zone skills     présente (2 installé(s))'
dit "et une fonctionnalité"                   'zone features   présente (1 activée(s))'

titre 'harness-ia init --force préserve les zones'

AVANT=$(cat "$HARNAIS")
rc  "--force aboutit"                         0 clia harness-ia init --force
dit "une sauvegarde est annoncée"             'CLAUDE\.md\.bak'
vrai "la sauvegarde existe"                   test -f "${HARNAIS}.bak"
vrai "elle porte l'état antérieur"            test "$(cat "${HARNAIS}.bak")" = "$AVANT"
vrai "les deux skills sont préservés"         test "$(grep -c 'BEGIN .* skill' "$HARNAIS")" = 2
vrai "la fonctionnalité est préservée"        test "$(grep -c 'BEGIN session feature' "$HARNAIS")" = 1
vrai "la régénération est idempotente"        test "$(cat "$HARNAIS")" = "$AVANT"

titre 'Une section hors zone est récupérée'

# Un CLAUDE.md antérieur aux zones : les sections de skill y sont en fin de
# fichier. init --force doit les replacer dans la zone plutôt que les perdre.
LEGACY="$BAC/legacy"
mkdir -p "$LEGACY" && git -C "$LEGACY" init -q
{
  printf '# Conventions maison\n\nRègles écrites à la main.\n\n'
  printf '<!-- BEGIN ancien skill -->\n\n## Skill : ancien\n\nInstallé avant les zones.\n\n<!-- END ancien skill -->\n'
} > "$LEGACY/CLAUDE.md"

rc  "init --force aboutit"                    0 bash -c 'cd "$1" && "$2" harness-ia init --force' banc "$LEGACY" "$CLIA"
dit "il annonce la section préservée"         'zone skills : 1 section'
vrai "la section est dans la zone"            bash -c 'grep -q "BEGIN ancien skill" <<<"$(awk -v b="<!-- CLIA:SKILLS:BEGIN -->" -v e="<!-- CLIA:SKILLS:END -->" "index(\$0,b){d=1;next} index(\$0,e){d=0;next} d" "'"$LEGACY/CLAUDE.md"'")"'
vrai "une seule occurrence"                   test "$(grep -c 'BEGIN ancien skill' "$LEGACY/CLAUDE.md")" = 1

titre 'Désinstallation'

rc  "skill uninstall aboutit"                 0 clia skill uninstall exemple
faux "le fichier du skill a disparu"          test -e "$PROJET/.claude/skills/exemple"
faux "sa section aussi"                       grep -q 'BEGIN exemple skill' "$HARNAIS"
vrai "l'autre skill est intact"               test -f "$PROJET/.claude/skills/sans-frontmatter/SKILL.md"
rc  "uninstall est idempotent"                0 clia skill uninstall exemple
dit "et il le dit"                            'rien à désinstaller'

rc  "le second skill se retire aussi"         0 clia skill uninstall sans-frontmatter
faux "le répertoire des skills a disparu"     test -e "$PROJET/.claude/skills"

rc  "feature uninstall aboutit"               0 clia feature uninstall session
faux "sa section a disparu"                   grep -q 'BEGIN session feature' "$HARNAIS"
rc  "uninstall est idempotent"                0 clia feature uninstall session
dit "et il le dit"                            "n'est pas active"

vrai "le harnais est revenu à la primitive"   diff -q "$PRIMITIVE" "$HARNAIS"

titre 'Demandes mal formées'

rc  "harness-ia sans verbe"                   2 clia harness-ia
rc  "harness-ia verbe inconnu"                2 clia harness-ia bidon
rc  "skill sans verbe"                        2 clia skill
rc  "skill verbe inconnu"                     2 clia skill bidon
rc  "skill install sans nom"                  2 clia skill install
dit "il dit ce qui manque"                    'attend un nom'
rc  "feature sans verbe"                      2 clia feature
rc  "feature install sans nom"                2 clia feature install
rc  "les aides répondent"                     0 clia harness-ia --help
rc  "celle de skill aussi"                    0 clia skill --help
rc  "celle de feature aussi"                  0 clia feature --help

titre 'La garde de périmètre couvre les nouvelles commandes'

rc  "harness-ia hors dépôt git est refusé"    1 clia_hors_depot harness-ia status
dit "et il dit pourquoi"                      "n'est pas dans un dépôt git"
rc  "skill list hors dépôt git est refusé"    1 clia_hors_depot skill list
rc  "feature list hors dépôt git est refusé"  1 clia_hors_depot feature list

titre 'Le dépôt source réel n'\''est pas modifié'

# Le dépôt réel est lui-même instrumenté : son CLAUDE.md et ses catalogues
# existent. Ce qui est vérifié n'est donc pas leur absence, mais qu'aucune
# commande du banc ne les a touchés.
vrai "aucun changement dans le dépôt réel"    test "$(cd "$RACINE" && git status --porcelain 2>/dev/null | sort)" = "$EMPREINTE_SOURCE"
faux "le catalogue réel n'a pas reçu de fixture" test -e "$RACINE/_ressources/skill/primitives/exemple.md"

# --------------------------------------------------------------------------

bilan
