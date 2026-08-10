#!/usr/bin/env bash
# test_clia.sh - Tests de clia, sans dependance externe.
#
# Chaque test s'execute dans un depot temporaire et une configuration
# temporaire : aucun test ne touche ni le depot de travail, ni la
# configuration de l'utilisateur. Cette isolation est la seule maniere de
# rendre les tests rejouables.
#
# Usage : ./tests/test_clia.sh
# Sortie : une ligne par test, puis un bilan. Code de retour non nul si un
# test echoue.

set -uo pipefail

CLIA_TEST_ROOT=$(cd -P "$(dirname "${BASH_SOURCE[0]}")/.." && pwd)
CLIA_BIN="$CLIA_TEST_ROOT/bin/clia"

pass=0
fail=0

# --------------------------------------------------------------------------
# Harnais de test
# --------------------------------------------------------------------------

ok() {
  printf '  ok   %s\n' "$1"
  pass=$((pass + 1))
}

ko() {
  printf '  KO   %s\n' "$1"
  [[ -n "${2:-}" ]] && printf '       %s\n' "$2"
  fail=$((fail + 1))
}

# assert_contains DESCRIPTION MOTIF SORTIE
assert_contains() {
  if printf '%s' "$3" | grep -qF -- "$2"; then
    ok "$1"
  else
    ko "$1" "motif absent : $2"
  fi
}

assert_not_contains() {
  if printf '%s' "$3" | grep -qF -- "$2"; then
    ko "$1" "motif present alors qu'il ne devrait pas : $2"
  else
    ok "$1"
  fi
}

# assert_rc DESCRIPTION ATTENDU OBTENU
assert_rc() {
  if [[ "$2" == "$3" ]]; then
    ok "$1"
  else
    ko "$1" "code de retour attendu $2, obtenu $3"
  fi
}

assert_file() {
  if [[ -f "$2" ]]; then ok "$1"; else ko "$1" "fichier absent : $2"; fi
}

# --------------------------------------------------------------------------
# Environnement isole
# --------------------------------------------------------------------------

TMP=$(mktemp -d)
trap 'rm -rf "$TMP"' EXIT

export XDG_CONFIG_HOME="$TMP/config"
export CLIA_HOME="$CLIA_TEST_ROOT"
# Ne pas heriter d'une configuration du poste.
unset CLIA_EDITOR CLIA_DEV_DIR_NAME CLIA_RESOURCES_DIR_NAME
unset CLIA_EXCLUDE_DIRS CLIA_REPO_ROOT

DEPOT="$TMP/depot"
mkdir -p "$DEPOT/.dev/ressources" "$DEPOT/.dev/archives/ressources"

# Deux definitions de type, un cycle de vie chacune.
cat > "$DEPOT/.dev/ressources/RES-001-chose.md" <<'EOF'
---
type: ressource
id: RES-chose
title: "Chose"
version: 0.1.0
status: draft
prefixe: CHO
emplacement: ".dev/choses/CHO-<SEQ>-<SLUG>.md"
cycle-de-vie: vivant
edition: ia
champs-obligatoires: [type, id, title]
relations-admissibles: [ressource]
skill: aucun
adr: aucun
statut: actif
---

# RES-001 - Chose
EOF

cat > "$DEPOT/.dev/ressources/RES-002-traces.md" <<'EOF'
---
type: ressource
id: RES-traces
title: "Traces"
version: 0.1.0
status: draft
prefixe: TRC
emplacement: ".dev/traces/TRC-<DATE>-<SLUG>.md"
cycle-de-vie: point-fixe
edition: ia
champs-obligatoires: [type, id, title]
relations-admissibles: [ressource]
skill: aucun
adr: aucun
statut: actif
---

# RES-002 - Traces
EOF

# Une ressource archivee, qui ne doit jamais etre comptee ni trouvee.
cat > "$DEPOT/.dev/archives/ressources/CHO-999-archivee.md" <<'EOF'
---
type: chose
id: CHO-archivee
title: "Chose archivee"
status: draft
---
EOF

run() { ( cd "$DEPOT" && "$CLIA_BIN" "$@" ) 2>&1; }
run_out() { ( cd "$DEPOT" && "$CLIA_BIN" "$@" ) 2>/dev/null; }

# --------------------------------------------------------------------------
printf '\nreflexivite\n'
# --------------------------------------------------------------------------

out=$(run --version); assert_contains 'clia --version affiche une version' 'clia 0.' "$out"
out=$(run --help);    assert_contains 'clia --help affiche l usage' 'Usage : clia' "$out"
out=$(run);           assert_contains 'sans argument, clia affiche l aide' 'Usage : clia' "$out"
run >/dev/null 2>&1;  assert_rc 'sans argument, code de retour nul' 0 "$?"

out=$(run --context)
assert_contains 'le contexte distingue CLIA_HOME du depot' "$DEPOT" "$out"
assert_contains 'le contexte signale que les deux racines differrent' 'non' "$out"

run commande-qui-nexiste-pas >/dev/null 2>&1
assert_rc 'commande inconnue, code de retour 2' 2 "$?"

# --------------------------------------------------------------------------
printf '\nresolution du contexte-repertoire\n'
# --------------------------------------------------------------------------

# Le depot de travail est celui d'ou l'on lance clia, jamais CLIA_HOME.
# Regression du bogue constate le 2026-07-31.
out=$( cd "$DEPOT" && "$CLIA_BIN" --context 2>&1 )
assert_contains 'le depot courant est le repertoire de lancement' "depot courant                $DEPOT" "$out"
assert_not_contains 'CLIA_HOME n est pas pris pour le depot courant' \
  "depot courant                $CLIA_TEST_ROOT" "$out"

# Depuis un sous-repertoire, la racine est remontee.
mkdir -p "$DEPOT/sous/repertoire"
out=$( cd "$DEPOT/sous/repertoire" && "$CLIA_BIN" --context 2>&1 )
assert_contains 'la racine est remontee depuis un sous-repertoire' "depot courant                $DEPOT" "$out"

# Hors de tout depot equipe, clia refuse et le dit.
out=$( cd "$TMP" && "$CLIA_BIN" res ls 2>&1 ); rc=$?
assert_rc 'hors depot, res ls echoue' 1 "$rc"
assert_contains 'hors depot, le message est explicite' 'aucun depot clia trouve' "$out"

# --------------------------------------------------------------------------
printf '\nresource ls\n'
# --------------------------------------------------------------------------

out=$(run_out res ls)
assert_contains 'ls liste les types definis' 'Chose' "$out"
assert_contains 'ls affiche le prefixe' 'CHO' "$out"
assert_contains 'ls affiche le cycle de vie' 'point-fixe' "$out"
assert_contains 'ls signale les types employes sans definition' 'aucune' "$out"

# Une ressource archivee ne compte pas : le type Chose n'a aucune instance
# active, alors que .dev/archives en contient une.
if printf '%s' "$out" | awk '$1 == "Chose" { vu = 1; zero = ($NF == 0) } END { exit !(vu && zero) }'; then
  ok 'ls ne compte pas les ressources archivees'
else
  ko 'ls ne compte pas les ressources archivees' 'le compte de Chose devrait etre 0'
fi

out=$(run_out r ls); assert_contains 'l alias r fonctionne' 'Chose' "$out"

# Avant toute creation, le repertoire d'un type n'existe pas : clia le dit
# plutot que d'afficher un tableau vide.
out=$(run res ls chose)
assert_contains 'ls TYPE sans instance le signale' 'aucune instance' "$out"
run res ls chose >/dev/null 2>&1
assert_rc 'ls TYPE sans instance n est pas une erreur' 0 "$?"

run res ls type-inexistant >/dev/null 2>&1
assert_rc 'ls d un type inconnu echoue' 1 "$?"

# --------------------------------------------------------------------------
printf '\nresource new\n'
# --------------------------------------------------------------------------

out=$(run_out res new chose "Première chose à faire")
assert_file 'new cree le fichier, slug translittere' \
  "$DEPOT/.dev/choses/CHO-001-premiere-chose-a-faire.md"
assert_contains 'new affiche le chemin sur stdout' 'CHO-001-premiere-chose-a-faire.md' "$out"

content=$(cat "$DEPOT/.dev/choses/CHO-001-premiere-chose-a-faire.md")
assert_contains 'le frontmatter porte le type' 'type: chose' "$content"
assert_contains 'le frontmatter porte un id stable' 'id: CHO-premiere-chose-a-faire' "$content"
assert_contains 'le frontmatter porte le titre donne' 'title: "Première chose à faire"' "$content"
assert_contains 'un type vivant porte une version' 'version: 0.1.0' "$content"
assert_contains 'le statut initial est draft' 'status: draft' "$content"
assert_contains 'le corps reste a rediger' 'À rédiger' "$content"

# clia ne redige pas : le corps doit rester un squelette.
lines=$(grep -c '' <<< "$content")
if (( lines < 20 )); then
  ok 'new ne redige aucun contenu'
else
  ko 'new ne redige aucun contenu' "le fichier compte $lines lignes"
fi

run_out res new chose "Deuxième chose" >/dev/null
assert_file 'la sequence s incremente' "$DEPOT/.dev/choses/CHO-002-deuxieme-chose.md"

# Un type point-fixe est nomme par date, sans version.
today=$(date +%Y-%m-%d)
run_out res new traces "Un relevé" >/dev/null
assert_file 'un type point-fixe est nomme par date' \
  "$DEPOT/.dev/traces/TRC-${today}-un-releve.md"
content=$(cat "$DEPOT/.dev/traces/TRC-${today}-un-releve.md")
assert_not_contains 'un type point-fixe ne porte pas de version' 'version:' "$content"

# Refus d un slug deja employe.
run res new chose "Première chose à faire" >/dev/null 2>&1
assert_rc 'new refuse un slug deja employe' 1 "$?"

# Refus d un type sans definition.
out=$(run res new inconnu "Quelque chose"); rc=$?
assert_rc 'new refuse un type sans definition' 1 "$rc"
assert_contains 'le refus explique pourquoi' 'ferait precedent' "$out"

# Arguments manquants.
run res new chose >/dev/null 2>&1
assert_rc 'new sans description echoue en 2' 2 "$?"

# --------------------------------------------------------------------------
printf '\nresolution d un type\n'
# --------------------------------------------------------------------------

out=$(run_out res ls chose)
assert_contains 'ls TYPE par nom du type' 'CHO-001' "$out"
out=$(run_out res ls CHO)
assert_contains 'ls TYPE par prefixe' 'CHO-001' "$out"
out=$(run_out res ls choses)
assert_contains 'ls TYPE tolere le pluriel' 'CHO-001' "$out"
out=$(run_out res ls traces)
assert_contains 'ls TYPE par nom au pluriel declare' 'TRC-' "$out"
out=$(run_out res ls trace)
assert_contains 'ls TYPE tolere le singulier' 'TRC-' "$out"

# --------------------------------------------------------------------------
printf '\nresource show et edit\n'
# --------------------------------------------------------------------------

out=$(run_out res show CHO-001)
assert_contains 'show par prefixe et sequence' 'Première chose' "$out"
out=$(run_out res show CHO-premiere-chose-a-faire)
assert_contains 'show par identifiant stable' 'Première chose' "$out"
# Le numero seul ne designe rien de facon unique : CHO-002 et RES-002
# coexistent. clia refuse plutot que de choisir, et nomme les candidats.
# C'est la demonstration a l'usage du defaut D1 de ANL-001 : le numero de
# sequence n'est pas un identifiant.
out=$(run res show 002); rc=$?
assert_rc 'show par numero seul echoue si le numero est partage' 1 "$rc"
assert_contains 'show nomme les candidats en cas d ambiguite' 'ambigu' "$out"
assert_contains 'show liste le premier candidat' 'CHO-002' "$out"
assert_contains 'show liste le second candidat' 'RES-002' "$out"

# Un numero non partage se resout sans ambiguite : RES s'arrete a 002, donc
# 003 ne designe qu'une seule ressource.
run_out res new chose "Troisieme chose" >/dev/null
out=$(run_out res show 003)
assert_contains 'show par numero seul quand il est unique au depot' 'Troisieme chose' "$out"

run res show CHO-999 >/dev/null 2>&1
assert_rc 'show ne trouve pas une ressource archivee' 1 "$?"

run res show ZZZ-000 >/dev/null 2>&1
assert_rc 'show d un identifiant absent echoue' 1 "$?"

# edit delegue a un editeur : on en fournit un factice qui trace son appel.
cat > "$TMP/faux-editeur" <<EOF
#!/bin/sh
printf '%s\n' "\$1" > "$TMP/edite"
EOF
chmod +x "$TMP/faux-editeur"
( cd "$DEPOT" && CLIA_EDITOR="$TMP/faux-editeur" "$CLIA_BIN" res edit CHO-001 ) >/dev/null 2>&1
if [[ -f "$TMP/edite" ]] && grep -q 'CHO-001' "$TMP/edite"; then
  ok 'edit ouvre la bonne ressource avec CLIA_EDITOR'
else
  ko 'edit ouvre la bonne ressource avec CLIA_EDITOR'
fi

# --------------------------------------------------------------------------
printf '\nconfiguration\n'
# --------------------------------------------------------------------------

out=$(run_out config ls)
assert_contains 'config ls affiche les cles connues' 'CLIA_EDITOR' "$out"
assert_contains 'config ls affiche l origine' 'default' "$out"

out=$(run_out config set EDITOR nano)
assert_contains 'config set normalise la cle sans prefixe' 'CLIA_EDITOR=nano' "$out"
out=$(run_out config ls)
assert_contains 'la valeur enregistree est relue' 'nano' "$out"
assert_contains 'l origine devient file' 'file' "$out"

run_out config set CLIA_EDITOR vim >/dev/null
out=$(run_out config ls)
assert_contains 'config set remplace sans dupliquer' 'vim' "$out"
occurrences=$(grep -c '^CLIA_EDITOR=' "$XDG_CONFIG_HOME/clia/config")
assert_rc 'une seule ligne par cle dans le fichier' 1 "$occurrences"

out=$(run config set CLE_INCONNUE valeur)
assert_contains 'une cle inconnue est enregistree mais signalee' 'variable inconnue' "$out"

run config set >/dev/null 2>&1
assert_rc 'config set sans argument echoue en 2' 2 "$?"
run config set CLE >/dev/null 2>&1
assert_rc 'config set sans valeur echoue en 2' 2 "$?"

out=$(run_out config path)
assert_contains 'config path affiche le chemin' 'clia/config' "$out"

# Le fichier de configuration n est jamais execute.
printf 'CLIA_PIEGE=$(touch %s/execute)\n' "$TMP" >> "$XDG_CONFIG_HOME/clia/config"
run_out config ls >/dev/null 2>&1
if [[ -f "$TMP/execute" ]]; then
  ko 'le fichier de configuration n est pas execute'
else
  ok 'le fichier de configuration n est pas execute'
fi

# --------------------------------------------------------------------------
printf '\nexclusion des archives\n'
# --------------------------------------------------------------------------

out=$(run_out res ls chose)
assert_not_contains 'ls n affiche pas les instances archivees' 'archivee' "$out"

# L exclusion est configurable.
out=$( cd "$DEPOT" && CLIA_EXCLUDE_DIRS='' "$CLIA_BIN" res ls 2>/dev/null )
assert_contains 'sans exclusion, les archives redeviennent visibles' 'aucune' "$out"

# --------------------------------------------------------------------------
printf '\nbilan : %d reussis, %d echoues\n' "$pass" "$fail"
# --------------------------------------------------------------------------

(( fail == 0 ))
