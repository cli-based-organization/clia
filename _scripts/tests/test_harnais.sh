#!/usr/bin/env bash
# _scripts/tests/test_harnais.sh — les harnais IA, l'instrumentation, la conformité.
#
# Éprouve SES-001 tâche 6.
#
# Les post-conditions de la tâche sont vérifiées nommément : après
# « clia init REPO_PATH », REPO_PATH est un dépôt git, CLAUDE.md existe, et
# CONSTITUTION.md existe.
#
# Deux propriétés sont vérifiées au-delà de l'énoncé, parce que leur absence
# se paierait cher : rien n'est jamais écrasé, et rien n'est commité.

set -uo pipefail

RACINE=$(cd -P "$(dirname "${BASH_SOURCE[0]}")/../.." && pwd)
CLIA="$RACINE/_scripts/bin/clia"
LIVREE='.clia/ressources'
PRIMITIVES="$RACINE/$LIVREE/harness-ia/primitives"

# shellcheck source=banc.sh
. "$RACINE/_scripts/tests/banc.sh"

BAC=$(mktemp -d)
trap 'rm -rf "$BAC"' EXIT

REEL_HEAD=$(git -C "$RACINE" rev-parse HEAD)
REEL_ETAT=$(git -C "$RACINE" status --porcelain | sort)

# --------------------------------------------------------------------------
# Outils
# --------------------------------------------------------------------------

# instrumente <nom> — un dépôt neuf, instrumenté, et l'imprime.
instrumente() {
  local d="$BAC/$1"
  "$CLIA" init "$d" >/dev/null 2>&1
  git -C "$d" config user.email 'banc@example.invalid'
  git -C "$d" config user.name 'banc'
  printf '%s\n' "$d"
}

rc_dans() {
  local titre="$1" attendu="$2" d="$3"; shift 3
  local reel
  SORTIE=$( ( cd "$d" && "$CLIA" "$@" ) 2>&1 ); reel=$?
  if (( reel == attendu )); then
    ok "$titre"
  else
    echec "$titre" "code $reel, attendu $attendu — $(printf '%s' "$SORTIE" | tr '\n' '|' | cut -c1-140)"
  fi
}

sortie() { local d="$1"; shift; ( cd "$d" && "$CLIA" "$@" 2>/dev/null ); }

_TITRE_BLOC='^[A-Za-z]+ :$'
_ENTREE='^  [^ ]'

lignes_de_prose() {
  local ligne
  while IFS= read -r ligne; do
    [[ -z "$ligne" ]] && continue
    [[ "$ligne" =~ $_TITRE_BLOC ]] && continue
    [[ "$ligne" =~ $_ENTREE ]] && continue
    printf '%s\n' "$ligne"
  done
}

lignes_trop_longues() {
  local ligne
  while IFS= read -r ligne; do
    (( ${#ligne} > 80 )) && printf '%s\n' "$ligne"
  done
  return 0
}

# ==========================================================================
titre 'La ressource harnais'
# ==========================================================================

vrai 'la ressource harness-ia porte sa definition' \
  test -f "$RACINE/$LIVREE/harness-ia/harness-ia.yaml"
vrai 'son prefixe est HRN' \
  grep -q '^prefixe: HRN$' "$RACINE/$LIVREE/harness-ia/harness-ia.yaml"

rc 'clia res ls la montre' 0 bash -c "cd '$RACINE' && '$CLIA' res ls"
dit 'avec son prefixe' '^HRN '

vrai 'elle porte le harnais IA principal en primitive' test -f "$PRIMITIVES/CLAUDE.md"
vrai 'et le harnais constitutionnel' test -f "$PRIMITIVES/CONSTITUTION.md"

vrai 'la constitution nomme l humain' grep -q 'Humain' "$PRIMITIVES/CONSTITUTION.md"
vrai 'elle nomme l automatisme' grep -q 'Automatisme' "$PRIMITIVES/CONSTITUTION.md"
vrai 'elle nomme l agent IA' grep -q 'Agent IA' "$PRIMITIVES/CONSTITUTION.md"
vrai 'et elle porte une table de permissions' \
  grep -q 'Les permissions' "$PRIMITIVES/CONSTITUTION.md"
vrai 'le harnais principal renvoie a la constitution' \
  grep -q 'CONSTITUTION.md' "$PRIMITIVES/CLAUDE.md"

# ==========================================================================
titre 'Les commandes sont decouvertes et documentees'
# ==========================================================================

rc 'clia --help les liste' 0 "$CLIA" --help
dit 'check y figure, avec ce qu elle fait' '^  check  *La conformité du dépôt'
dit 'init y figure aussi' '^  init  *Crée ou instrumente un dépôt'

rc 'et leurs signatures sont a leur propre niveau' 0 "$CLIA" check --help
dit 'celle de check --harness' 'clia check --harness'
rc 'celle de init aussi' 0 "$CLIA" init --help
dit 'et elle y est' 'clia init \[REPO_PATH\]'

for niveau in check init; do
  RESTE=$("$CLIA" $niveau --help 2>/dev/null | lignes_de_prose)
  vrai "l aide de $niveau ne porte aucune prose" test -z "$RESTE"
done

SORTIE=$("$CLIA" check --help 2>/dev/null)
dit '--harness est offerte au niveau de check' '--harness'

rc 'le manuel de check' 0 "$CLIA" check --man
dit 'porte son nom de page' '^CLIA-CHECK(1)'
dit 'et une section de controles' '^CONTROLES$'
rc 'le manuel de init' 0 "$CLIA" init --man
dit 'porte son nom de page' '^CLIA-INIT(1)'
dit 'et dit ce qui est pose' '^CE QUI EST POSE$'

for page in 'check --man' 'init --man'; do
  # shellcheck disable=SC2086
  LONGUES=$("$CLIA" $page 2>/dev/null | lignes_trop_longues)
  vrai "aucune ligne de « clia $page » ne depasse 80 colonnes" test -z "$LONGUES"
done

HORS="$BAC/hors-depot"; mkdir -p "$HORS"
rc 'les manuels repondent hors d un depot' 0 bash -c "cd '$HORS' && '$CLIA' check --man"
rc 'mais check exige un depot' 1 bash -c "cd '$HORS' && '$CLIA' check"

# ==========================================================================
titre 'clia init : les post-conditions de la tache'
# ==========================================================================

CIBLE="$BAC/projet-neuf"
rc 'clia init sur un chemin absent est satisfaite' 0 "$CLIA" init "$CIBLE"
dit 'et elle dit avoir cree le depot git' 'dépôt git initialisé'

vrai 'post-condition 1 : REPO_PATH est un depot git' \
  test "$(git -C "$CIBLE" rev-parse --show-toplevel)" = "$CIBLE"
vrai 'post-condition 2 : CLAUDE.md existe' test -f "$CIBLE/CLAUDE.md"
vrai 'post-condition 3 : CONSTITUTION.md existe' test -f "$CIBLE/CONSTITUTION.md"
vrai 'et le fichier d etat est pose avec' test -f "$CIBLE/clia.yaml"

vrai 'le harnais pose est celui de la primitive' \
  cmp -s "$CIBLE/CLAUDE.md" "$PRIMITIVES/CLAUDE.md"
vrai 'la constitution posee aussi' \
  cmp -s "$CIBLE/CONSTITUTION.md" "$PRIMITIVES/CONSTITUTION.md"

vrai 'le namespace est pose a completer' \
  grep -q '^namespace: <publisher>/projet-neuf$' "$CIBLE/clia.yaml"
vrai 'et la version est initialisee' grep -q '^version: 0.1.0$' "$CIBLE/clia.yaml"

vrai 'rien n est commite' \
  test "$(git -C "$CIBLE" rev-list --count --all 2>/dev/null || printf 0)" -eq 0

# ==========================================================================
titre 'clia init n ecrase jamais rien'
# ==========================================================================

printf 'mon harnais a moi\n' > "$CIBLE/CLAUDE.md"
rc 'relancer init reste satisfait' 0 "$CLIA" init "$CIBLE"
dit 'et il dit avoir laisse ce qui existait' 'laissé   CLAUDE.md'
dit 'sans rien poser' '0 posé(s), 3 laissé(s)'
vrai 'le fichier adapte est intact' \
  test "$(cat "$CIBLE/CLAUDE.md")" = 'mon harnais a moi'

EXISTANT=$(instrumente projet-existant)
printf 'namespace: deja/la\nversion: 9.9.9\n' > "$EXISTANT/clia.yaml"
rc 'un etat deja present est laisse' 0 "$CLIA" init "$EXISTANT"
dit 'et signale comme tel' 'laissé   clia.yaml'
vrai 'son contenu est intact' grep -q '^version: 9.9.9$' "$EXISTANT/clia.yaml"

# ==========================================================================
titre 'Ce que clia init refuse'
# ==========================================================================

mkdir -p "$EXISTANT/sous-repertoire"
rc 'une cible imbriquee dans un depot est refusee' 1 "$CLIA" init "$EXISTANT/sous-repertoire"
dit 'et clia nomme la racine englobante' "racine : $EXISTANT"
dit 'et dit quoi faire' 'instrumentez la racine'
vrai 'et aucun depot imbrique n a ete cree' test ! -d "$EXISTANT/sous-repertoire/.git"

printf 'un fichier\n' > "$BAC/pas-un-repertoire"
rc 'une cible qui est un fichier est refusee' 1 "$CLIA" init "$BAC/pas-un-repertoire"
dit 'et clia le dit' "n'est pas un répertoire"

rc 'deux chemins sont une demande mal formee' 2 "$CLIA" init a b
rc 'une option inconnue est une demande mal formee' 2 "$CLIA" init --nawak

# ==========================================================================
titre 'clia check : un depot conforme'
# ==========================================================================

CONFORME=$(instrumente conforme)
sed -i 's|^namespace: .*|namespace: exemple.test/conforme|' "$CONFORME/clia.yaml"

rc_dans 'un depot instrumente est conforme' 0 "$CONFORME" check
dit 'l en-tete nomme le depot' "^dépôt      $CONFORME\$"
dit 'et son namespace' '^namespace  exemple.test/conforme$'
dit 'et sa version' '^version    0.1.0$'
dit 'E1 constate l etat' '^E1  ok  '
dit 'E2 constate namespace et version' '^E2  ok  '
dit 'H1 constate le premier harnais' '^H1  ok  CLAUDE.md$'
dit 'H2 constate le second' '^H2  ok  CONSTITUTION.md$'
dit 'et la conclusion le dit' 'clia: conforme'

# ==========================================================================
titre 'clia check : ce qui bloque'
# ==========================================================================

SANS_HARNAIS=$(instrumente sans-harnais)
rm -f "$SANS_HARNAIS/CLAUDE.md"
rc_dans 'un harnais absent rend le depot non conforme' 1 "$SANS_HARNAIS" check
dit 'et le controle le nomme' '^H1  !!  CLAUDE.md est absent$'
dit 'tandis que l autre reste ok' '^H2  ok  CONSTITUTION.md$'
dit 'et la conclusion compte les ecarts' "1 écart(s) bloquant(s)"
dit 'en nommant la commande qui les solde' 'clia init .'

SANS_ETAT=$(instrumente sans-etat)
rm -f "$SANS_ETAT/clia.yaml"
rc_dans 'un etat absent rend le depot non conforme' 1 "$SANS_ETAT" check
dit 'E1 le dit' '^E1  !!  aucun fichier d.état'
dit 'et E2 en decoule' '^E2  !!  '
dit 'les trois emplacements sont nommes' 'clia.yaml .clia.yaml .dev/clia.yaml'

SANS_NS=$(instrumente sans-namespace)
printf 'version: 1.0.0\n' > "$SANS_NS/clia.yaml"
rc_dans 'un etat sans namespace est bloquant' 1 "$SANS_NS" check
dit 'et clia dit ce qui manque' 'ne déclare pas de namespace'

# ==========================================================================
titre 'clia check : ce qui se signale sans bloquer'
# ==========================================================================

A_COMPLETER=$(instrumente a-completer)
rc_dans 'un namespace a completer ne bloque pas' 0 "$A_COMPLETER" check
dit 'mais il est signale' '^E2  --  le namespace est à compléter'
dit 'et la conclusion le compte' 'conforme, avec 1 signalement'

ADAPTE=$(instrumente harnais-adapte)
sed -i 's|^namespace: .*|namespace: exemple.test/adapte|' "$ADAPTE/clia.yaml"
printf '\nune convention propre à ce dépôt\n' >> "$ADAPTE/CLAUDE.md"
rc_dans 'un harnais adapte ne bloque pas' 0 "$ADAPTE" check
dit 'mais la divergence se voit' '^H1  --  CLAUDE.md diffère de la primitive'
dit 'et la conclusion le compte' 'conforme, avec 1 signalement'

# ==========================================================================
titre 'clia check --harness'
# ==========================================================================

rc_dans '--harness est satisfait sur un depot conforme' 0 "$CONFORME" check --harness
dit 'les controles de harnais sont rendus' '^H1  ok  CLAUDE.md$'
ne_dit_pas 'et ceux de l etat ne le sont pas' '^E1'
ne_dit_pas 'ni E2' '^E2'

rc_dans '--harness bloque quand un harnais manque' 1 "$SANS_HARNAIS" check --harness
dit 'et rapporte le probleme' 'CLAUDE.md est absent'

rc_dans '--harness signale un harnais adapte' 0 "$ADAPTE" check --harness
dit 'sans bloquer' 'diffère de la primitive'

rc_dans 'un argument inattendu est mal forme' 2 "$CONFORME" check --nawak
dit 'et il renvoie a l usage' 'clia check --help'

# ==========================================================================
titre 'Le dépôt réel n a pas bouge'
# ==========================================================================

vrai 'HEAD est le meme qu au depart' \
  test "$(git -C "$RACINE" rev-parse HEAD)" = "$REEL_HEAD"
vrai 'et son etat de travail aussi' \
  test "$(git -C "$RACINE" status --porcelain | sort)" = "$REEL_ETAT"

bilan
