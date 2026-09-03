#!/usr/bin/env bash
# _scripts/tests/test_identite.sh — l'IIE d'une ressource, et ses formes.
#
# Éprouve SES-001 tâche 24 : l'identité polymorphe, les trois porteurs d'une
# IIE interne, l'IIE externe, le contrôle C0, et la validation par cue.
#
# Ce que le banc mesure, et qui n'irait pas de soi :
#
#   la présence d'une IIE est le PREMIER critère de conformité — c'est le
#   seul qui décide si l'objet jugé est une ressource ;
#
#   seule la forme absolue est déclarée. Les deux autres se dérivent du
#   dépôt, et une ressource installée garde l'autorité de son éditeur ;
#
#   une IIE se lit dans trois porteurs — tête d'un YAML, frontmatter,
#   en-tête de commentaires — et le type du fichier les départage ;
#
#   une IIE externe doit dire vers quoi elle pointe, sinon elle n'identifie
#   rien ;
#
#   la forme entière est jugée par cue, contre le schéma que la ressource
#   porte. Le noyau, lui, se contente de la présence — il doit répondre là
#   où cue n'est pas installé.

set -uo pipefail

RACINE=$(cd -P "$(dirname "${BASH_SOURCE[0]}")/../.." && pwd)
CLIA="$RACINE/_scripts/bin/clia"

# shellcheck source=banc.sh
. "$RACINE/_scripts/tests/banc.sh"

BAC=$(mktemp -d)
trap 'rm -rf "$BAC"' EXIT

export XDG_CACHE_HOME="$BAC/cache"

INST='.dev/ressources'
LIVREE='.clia/ressources'
ID='RES-001-outil'

REEL_ETAT=$(git -C "$RACINE" status --porcelain | sort)

# --------------------------------------------------------------------------
# Outils
# --------------------------------------------------------------------------

git_() { git -C "$1" -c user.email=banc@example.invalid -c user.name=banc "${@:2}"; }

sortie() { local d="$1"; shift; ( cd "$d" && "$CLIA" "$@" 2>/dev/null ); }

rc_dans() {
  local titre="$1" attendu="$2" d="$3"; shift 3
  local reel
  SORTIE=$( ( cd "$d" && "$CLIA" "$@" ) 2>&1 ); reel=$?
  if (( reel == attendu )); then
    ok "$titre"
  else
    echec "$titre" "code $reel, attendu $attendu — $(printf '%s' "$SORTIE" | tr '\n' '|' | cut -c1-160)"
  fi
}

# Le CLI, tel qu'il sera quand la ressource « ressource » aura été réinstallée
# depuis son instance.
#
# Les verbes que la tâche 24 ajoute à « clia res » vivent dans l'instance ;
# le CLI, lui, ne lit que la copie installée — SPC-001 invariant 4. Le banc
# fait donc le va-et-vient que rien ne mécanise encore, dans une copie, pour
# éprouver ce que le dépôt aura après la réinstallation.
CLIA_JOUR=''
clia_a_jour() {
  [[ -n "$CLIA_JOUR" ]] && { printf '%s\n' "$CLIA_JOUR"; return 0; }
  local src="$BAC/clia-source"
  mkdir -p "$src"
  cp -r "$RACINE/_scripts" "$RACINE/$INST" "$RACINE/clia.yaml" "$src/" 2>/dev/null
  mkdir -p "$src/$LIVREE"
  cp -r "$RACINE/$LIVREE"/* "$src/$LIVREE/" 2>/dev/null
  rm -rf "${src:?}/$LIVREE/ressource"
  cp -r "$RACINE/$INST/RES-001-ressource/livrables" "$src/$LIVREE/ressource"
  CLIA_JOUR="$src/_scripts/bin/clia"
  printf '%s\n' "$CLIA_JOUR"
}

rc_jour() {
  local titre="$1" attendu="$2" d="$3"; shift 3
  local reel c
  c=$(clia_a_jour)
  SORTIE=$( ( cd "$d" && "$c" "$@" ) 2>&1 ); reel=$?
  if (( reel == attendu )); then
    ok "$titre"
  else
    echec "$titre" "code $reel, attendu $attendu — $(printf '%s' "$SORTIE" | tr '\n' '|' | cut -c1-160)"
  fi
}

UUID='clia:0f9a1b2c-3d4e-5f60-8192-a3b4c5d6e7f8'
UUID2='clia:1a2b3c4d-5e6f-7081-92a3-b4c5d6e7f809'

# Un dépôt qui écrit la ressource « outil », et l'a installée.
depot() {
  local d="$BAC/$1" iie="${2:-$UUID}"
  mkdir -p "$d/$INST/$ID/primitive-1" "$d/$INST/$ID/primitive-2" \
           "$d/$INST/$ID/livrables/_scripts" "$d/$LIVREE"
  git -C "$d" init -q
  printf 'namespace: exemple.test/%s\nversion: 1.0.0\n' "$1" > "$d/clia.yaml"
  { printf 'nom: outil\n'
    [[ "$iie" != 'sans' ]] && printf 'id: %s\n' "$iie"
    printf 'titre: Outil\nprefixe: OUT\nversion: 0.1.0\n\n'
    printf 'description: "Une ressource de banc."\n'
  } > "$d/$INST/$ID/livrables/outil.yaml"
  cat > "$d/$INST/$ID/livrables/_scripts/out.sh" <<'SH'
#!/usr/bin/env bash
# Description: Une ressource de banc.
# Périmètre: dépôt
# Signature: out dis
set -euo pipefail
printf 'un\n'
SH
  cp -r "$d/$INST/$ID/livrables" "$d/$LIVREE/outil"
  git_ "$d" add -A >/dev/null
  git_ "$d" commit -q -m 'outil 0.1.0'
  printf '%s\n' "$d"
}

# ==========================================================================
titre 'C0 — la présence d une IIE'
# ==========================================================================

D=$(depot conforme)
rc_dans 'une ressource qui porte son identite est conforme' 0 "$D" out check
dit 'C0 vient en premier' '^C0  ok'
dit 'et rend l identite absolue' "^C0  ok  $UUID\$"
dit 'l en-tete rend la forme partageable' '^identité   exemple.test/conforme/OUT$'

S=$(depot sans-identite sans)
rc_dans 'sans identite, la ressource n est pas conforme' 1 "$S" out check
dit 'et clia dit ce qui manque' '^C0  !!  aucune identité déclarée'

M=$(depot mal-formee 'clia:pas-un-uuid')
rc_dans 'une identite mal formee est bloquante' 1 "$M" out check
dit 'et clia rappelle la forme' "n'a pas la forme clia:<uuid>"

rc_dans 'l explication dit pourquoi c est le premier controle' 0 "$D" out check --explain
dit 'et le dit' 'le seul qui décide si l.objet'
dit 'elle montre la forme absolue' 'id: clia:0f9a1b2c'
dit 'et dit que les deux autres se derivent' 'Elles ne se déclarent donc'

# ==========================================================================
titre 'Les trois formes'
# ==========================================================================

SORTIE=$(sortie "$D" out check)
dit 'la forme partageable prefixe du namespace du depot' 'exemple.test/conforme/OUT'

# Une ressource installée garde l'autorité de son éditeur.
E=$(depot venue-d-ailleurs)
rm -rf "${E:?}/$INST"
printf '\nsources:\n  - provider: ailleurs.test\n    type: local\n    uri: ../ailleurs\n' >> "$E/clia.yaml"
printf '\nuse:\n  extensions:\n  - resource: ailleurs.test/OUT\n    version: 0.1.0\n' >> "$E/clia.yaml"
git_ "$E" add -A >/dev/null; git_ "$E" commit -q -m 'reprise'
SORTIE=$(sortie "$E" out check)
dit 'et non de celui qui la lit' '^identité   ailleurs.test/OUT$'

# ==========================================================================
titre 'Les trois porteurs d une IIE interne'
# ==========================================================================

P=$(depot porteurs)
printf -- '---\nid: %s\nnom: note\ntitre: Note\nprefixe: NOT\nversion: 0.1.0\ndescription: "x"\n---\n\ntexte\n' \
  "$UUID2" > "$P/$INST/$ID/primitive-2/NOT-001-note.md"
printf '#!/usr/bin/env bash\n# clia-id: %s\n# clia-prefixe: SCR\n\nexit 0\n' \
  "$UUID2" > "$P/$INST/$ID/primitive-2/SCR-001-outil.sh"
printf 'a,b\n1,2\n' > "$P/$INST/$ID/primitive-2/DAT-001-mesures.csv"

C=$(clia_a_jour)
SORTIE=$( ( cd "$P" && "$C" res iie ls ) 2>&1 )
dit 'un yaml porte son IIE en tete' "outil.yaml"
dit 'un markdown, dans son frontmatter' "NOT-001-note.md"
dit 'un script, dans un en-tete de commentaires' 'SCR-001-outil\.sh'
dit 'la portee est dite' '^instance '
dit 'et la forme relative aussi' 'NOT-001'
dit 'un csv ne porte rien' '^primitive *DAT-001 *— *.*DAT-001-mesures\.csv'

rc_jour 'res iie ls repond' 0 "$P" res iie ls
dit 'l en-tete nomme les colonnes' '^PORTEE .*RELATIVE .*ABSOLUE .*OU$'
dit 'le depot lui-meme y figure quand il porte une identite' '^ressource '

# ==========================================================================
titre 'Une IIE externe'
# ==========================================================================

X=$(depot externe)
python3 - "$X/$INST/$ID/livrables/outil.yaml" <<'PY'
import sys
p = sys.argv[1]
s = open(p, encoding='utf-8').read()
open(p, 'w', encoding='utf-8').write(s + '\nrepresentation: rapport.pdf\n')
PY
rc_dans 'une IIE externe qui pointe vers rien est bloquante' 1 "$X" out check
dit 'et clia dit vers quoi elle pointait' 'rapport.pdf'

printf 'un pdf, pour de faux\n' > "$X/$INST/$ID/livrables/rapport.pdf"
rc_dans 'elle devient conforme quand sa representation est la' 0 "$X" out check
dit 'et clia la nomme' '^C0  ok  identité externe, vers rapport.pdf$'

Y=$(depot externe-uri)
python3 - "$Y/$INST/$ID/livrables/outil.yaml" <<'PY'
import sys
p = sys.argv[1]
s = open(p, encoding='utf-8').read()
open(p, 'w', encoding='utf-8').write(s + '\nrepresentation: https://exemple.test/rapport.pdf\n')
PY
rc_dans 'une representation distante est acceptee' 0 "$Y" out check
dit 'et clia la rend telle quelle' 'https://exemple.test/rapport.pdf'

# ==========================================================================
titre 'La validation par cue'
# ==========================================================================

vrai 'la ressource porte son schema' \
  test -f "$RACINE/$INST/RES-001-ressource/livrables/schemas/iie.cue"
vrai 'et l outil qui le fait juger' \
  test -x "$RACINE/$INST/RES-001-ressource/livrables/outils/valider-iie.sh"

if command -v cue >/dev/null 2>&1; then
  rc_jour 'res iie check juge les definitions du depot' 0 "$D" res iie check
  dit 'et les dit conformes' 'IIE conforme(s) au schéma'

  rc_jour 'une identite mal formee est refusee par le schema' 1 "$M" res iie check
  dit 'et cue dit ce qui cloche' 'id: invalid value'

  Z=$(depot prefixe-minuscule)
  sed -i 's/^prefixe: OUT$/prefixe: out/' "$Z/$INST/$ID/livrables/outil.yaml"
  rc_jour 'un prefixe minuscule est refuse par le schema' 1 "$Z" res iie check
  dit 'et cue le nomme' 'prefixe: invalid value'

  W=$(depot composee)
  python3 - "$W/$INST/$ID/livrables/outil.yaml" "$UUID2" <<'PY'
import sys
p, u = sys.argv[1], sys.argv[2]
s = open(p, encoding='utf-8').read()
open(p, 'w', encoding='utf-8').write(s + '\ncomposee-de: %s\n' % u)
PY
  rc_jour 'une composition est acceptee' 0 "$W" res iie check

  V=$(depot composee-fausse)
  python3 - "$V/$INST/$ID/livrables/outil.yaml" <<'PY'
import sys
p = sys.argv[1]
s = open(p, encoding='utf-8').read()
open(p, 'w', encoding='utf-8').write(s + '\ncomposee-de: pas-une-identite\n')
PY
  rc_jour 'une composition mal formee est refusee' 1 "$V" res iie check
else
  ok 'cue est absent : la validation par schéma n est pas éprouvée'
fi

# ==========================================================================
titre 'Une ressource neuve porte une identité'
# ==========================================================================

N=$(depot creation)
rc_jour 'res new repond' 0 "$N" res new ANL analyse "Une analyse."
NEUVE=$(ls -d "$N/$INST"/RES-*-analyse 2>/dev/null | head -1)
vrai 'la definition est la' test -f "$NEUVE/livrables/analyse.yaml"
vrai 'et elle porte une identite absolue' \
  grep -qE '^id: clia:[0-9a-f]{8}-[0-9a-f]{4}-[0-9a-f]{4}-[0-9a-f]{4}-[0-9a-f]{12}$' \
    "$NEUVE/livrables/analyse.yaml"

if command -v cue >/dev/null 2>&1; then
  rc_jour 'et le schema l accepte' 0 "$N" res iie check "$NEUVE/livrables/analyse.yaml"
fi

# Deux ressources neuves ne partagent pas la même identité.
rc_jour 'une seconde ressource neuve repond' 0 "$N" res new BNC banc "Un banc."
AUTRE=$(ls -d "$N/$INST"/RES-*-banc 2>/dev/null | head -1)
vrai 'et son identite est une autre' \
  test "$(grep '^id:' "$NEUVE/livrables/analyse.yaml")" != "$(grep '^id:' "$AUTRE/livrables/banc.yaml")"

# ==========================================================================
titre 'Le dépôt réel'
# ==========================================================================

# C0 est ce qui est mesuré, non le verdict d'ensemble : celui-ci dépend des
# autres contrôles, et l'état du dépôt réel bouge.
SORTIE=$("$CLIA" res check 2>&1) || true
dit 'C0 passe pour ressource' '^C0  ok  clia:'
SORTIE=$("$CLIA" hrn check 2>&1) || true
dit 'C0 aussi pour harness-ia' '^C0  ok  clia:'

vrai 'la carte du depot porte la sienne' \
  grep -qE '^id: clia:' "$RACINE/clia.yaml"

vrai 'son etat de travail est le meme qu au depart' \
  test "$(git -C "$RACINE" status --porcelain | sort)" = "$REEL_ETAT"

bilan
