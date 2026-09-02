#!/usr/bin/env bash
# _scripts/tests/test_source.sh — les sources de données.
#
# Éprouve SES-001 tâche 12, côté source.
#
# La tâche 12 partage en deux ce que « clia src » tenait ensemble. Ce que ce
# banc mesure, et qui est le coeur du partage : la frontière n'est pas
# déclarée, elle est constatée. Une même entrée de la carte passe d'une
# commande à l'autre quand le dépôt qu'elle désigne reçoit une ressource,
# sans que personne ne la redéclare.

set -uo pipefail

RACINE=$(cd -P "$(dirname "${BASH_SOURCE[0]}")/../.." && pwd)
CLIA="$RACINE/_scripts/bin/clia"

# shellcheck source=banc.sh
. "$RACINE/_scripts/tests/banc.sh"

BAC=$(mktemp -d)
trap 'rm -rf "$BAC"' EXIT

export XDG_CACHE_HOME="$BAC/cache"

REEL_ETAT=$(git -C "$RACINE" status --porcelain | sort)

# --------------------------------------------------------------------------

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

depot() {
  local d="$BAC/$1"
  mkdir -p "$d"
  git -C "$d" init -q
  printf 'namespace: exemple.test/%s\nversion: 1.0.0\n' "$1" > "$d/clia.yaml"
  printf '%s\n' "$d"
}

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

# ==========================================================================
titre 'La commande est decouverte, et documentee'
# ==========================================================================

rc 'clia --help liste source' 0 "$CLIA" --help
dit 'sous les commandes du noyau' '^  source  *Les sources de données'

rc 'clia source --help' 0 "$CLIA" source --help
dit 'ses deux signatures y sont' 'clia source add URI \[NOM\]'
dit 'et celle de ls' 'clia source ls'
RESTE=$("$CLIA" source --help 2>/dev/null | lignes_de_prose)
vrai 'et son aide ne porte aucune prose' test -z "$RESTE"
[[ -n "$RESTE" ]] && printf '         ligne fautive : %s\n' "$RESTE"

rc 'clia source --man' 0 "$CLIA" source --man
dit 'la page porte son nom' '^CLIA-SOURCE(1)'
for section in NOM SYNOPSIS DESCRIPTION SOUS-COMMANDES SORTIE \
               'CODE DE RETOUR' FICHIERS EXEMPLES 'VOIR AUSSI'; do
  dit "la section $section y est" "^$section\$"
done
LONGUES=$("$CLIA" source --man 2>/dev/null | lignes_trop_longues)
vrai 'aucune ligne du manuel ne depasse 80 colonnes' test -z "$LONGUES"
[[ -n "$LONGUES" ]] && printf '         ligne fautive : %s\n' "$LONGUES"

HORS="$BAC/hors-depot"; mkdir -p "$HORS"
rc 'le manuel repond hors d un depot' 0 bash -c "cd '$HORS' && '$CLIA' source --man"
rc 'mais le travail exige un depot' 1 bash -c "cd '$HORS' && '$CLIA' source ls"

# ==========================================================================
titre 'Declarer une source'
# ==========================================================================

D=$(depot travail)
rc_dans 'un depot sans source le dit' 0 "$D" source ls
dit 'et nomme la commande qui en ajoute une' 'clia source add URI'

# Un dépôt clia sans ressource : son namespace est lu, non deviné.
NU=$(depot nu)
rc_dans 'clia source add est satisfaite' 0 "$D" source add ../nu
dit 'et elle nomme la provenance lue dans la carte de la source' 'exemple.test/nu'
vrai 'la source est inscrite dans la carte' grep -q 'provider: exemple.test/nu' "$D/clia.yaml"
vrai 'avec son type' grep -q '    type: local' "$D/clia.yaml"
vrai 'et son uri' grep -q '    uri: \.\./nu' "$D/clia.yaml"
vrai 'la declaration ne commite rien' test -n "$(git -C "$D" status --porcelain)"

rc_dans 'la redeclarer ne change rien' 0 "$D" source add ../nu
dit 'et clia le dit' 'déjà déclarée'

SORTIE=$(sortie "$D" source ls)
dit 'l en-tete nomme les colonnes' '^SOURCE *ETAT *URI$'
dit 'un depot clia sans ressource est un depot clia' 'exemple.test/nu *dépôt clia'

# Un dépôt ordinaire : rien à lire, donc le nom est exigé.
ORD="$BAC/ordinaire"; mkdir -p "$ORD"
rc_dans 'un depot sans carte doit etre nomme' 1 "$D" source add ../ordinaire
dit 'et clia refuse de deviner la provenance' 'ne déclare pas de provenance'
dit 'en disant comment la donner' 'clia source add ../ordinaire NOM'
vrai 'et rien n a ete declare' test "$(grep -c 'ordinaire' "$D/clia.yaml")" -eq 0

rc_dans 'nomme, il est accepte' 0 "$D" source add ../ordinaire donnees.exemple.org
vrai 'sous le nom donne' grep -q 'provider: donnees.exemple.org' "$D/clia.yaml"
SORTIE=$(sortie "$D" source ls)
dit 'et il est montre pour ce qu il est' 'donnees.exemple.org *dépôt'

# Une uri qui ne mène nulle part est déclarée telle quelle : une source
# distante n'est pas jointe pour être déclarée.
rc_dans 'une source distante doit etre nommee aussi' 1 "$D" source add https://exemple.test/x.git
dit 'car elle n est pas lue avant d etre declaree' "n'est pas lue avant"
rc_dans 'nommee, elle est declaree' 0 "$D" source add https://exemple.test/x.git x.exemple.test
vrai 'en type git' \
  test "$(grep -A1 'provider: x.exemple.test' "$D/clia.yaml" | tail -1)" = '    type: git'
SORTIE=$(sortie "$D" source ls)
dit 'et elle est dite non clonee' 'x.exemple.test *non clonée'

# ==========================================================================
titre 'La frontiere se constate, elle ne se declare pas'
# ==========================================================================
#
# La même entrée passe de « clia source » à « clia extension » quand le dépôt
# qu'elle désigne reçoit une ressource. Personne ne la redéclare.

SORTIE=$(sortie "$D" source ls)
dit 'le depot nu figure parmi les sources' 'exemple.test/nu'

mkdir -p "$NU/.dev/ressources/RES-001-analyse/livrables"
cat > "$NU/.dev/ressources/RES-001-analyse/livrables/analyse.yaml" <<'YAML'
nom: analyse
titre: Analyse
prefixe: ANL
version: 0.1.0

description: "Une ressource de banc."
YAML

SORTIE=$(sortie "$D" source ls)
ne_dit_pas 'la voila qui quitte les sources' 'exemple.test/nu '
rc_dans 'et clia dit ou elle est passee' 0 "$D" source ls
dit 'en renvoyant vers extension ls' 'clia extension ls'
dit 'et en comptant celles qui n y figurent pas' 'sont des extensions'

SORTIE=$(sortie "$D" extension ls)
dit 'elle est devenue une extension' 'exemple.test/nu *extension *ANL'
vrai 'sans que la carte ait ete retouchee' \
  test "$(grep -c 'provider: exemple.test/nu' "$D/clia.yaml")" -eq 1

# ==========================================================================
titre 'Ce que la commande refuse'
# ==========================================================================

rc_dans 'add sans uri est mal forme' 2 "$D" source add
rc_dans 'add avec un argument en trop est mal forme' 2 "$D" source add a b c
rc_dans 'ls ne prend pas d argument' 2 "$D" source ls trop
rc_dans 'un verbe inconnu est mal forme' 2 "$D" source bidule
rc_dans 'source sans verbe est mal forme' 2 "$D" source

# Un dépôt dont toutes les sources sont des extensions.
TOUT=$(depot tout-extension)
mkdir -p "$BAC/ext-x/.dev/ressources/RES-001-r/livrables"
git -C "$BAC/ext-x" init -q
printf 'namespace: x.exemple.test/ext-x\nversion: 0.1.0\n' > "$BAC/ext-x/clia.yaml"
printf 'nom: r\ntitre: R\nprefixe: RRR\nversion: 0.1.0\n' > "$BAC/ext-x/.dev/ressources/RES-001-r/livrables/r.yaml"
rc_dans 'declarer une extension par source add fonctionne' 0 "$TOUT" source add ../ext-x
dit 'et clia dit que c en est une' "c'est une extension"
rc_dans 'ls le dit quand il ne reste rien a montrer' 0 "$TOUT" source ls
dit 'et renvoie vers extension ls' 'clia extension ls'

# ==========================================================================
titre 'Le depot reel n a pas bouge'
# ==========================================================================

vrai 'son etat de travail est le meme qu au depart' \
  test "$(git -C "$RACINE" status --porcelain | sort)" = "$REEL_ETAT"

bilan
