#!/usr/bin/env bash
# _scripts/tests/test_version.sh — le point d'entrée, et la commande version.
#
# Éprouve SES-001 tâche 1.
#
# Chaque cas travaille dans un dépôt jetable sous un répertoire temporaire.
# Le dernier titre vérifie que le dépôt réel n'a pas bougé : un banc qui
# écrirait dans le dépôt qu'il éprouve ne prouverait rien sur les suivants.

set -uo pipefail

RACINE=$(cd -P "$(dirname "${BASH_SOURCE[0]}")/../.." && pwd)
CLIA="$RACINE/_scripts/bin/clia"

# shellcheck source=banc.sh
. "$RACINE/_scripts/tests/banc.sh"

BAC=$(mktemp -d)
trap 'rm -rf "$BAC"' EXIT

# Empreinte du dépôt réel, prise avant le premier cas.
REEL_HEAD=$(git -C "$RACINE" rev-parse HEAD)
REEL_ETAT=$(git -C "$RACINE" status --porcelain | sort)

# --------------------------------------------------------------------------
# Fabrique de dépôts jetables
# --------------------------------------------------------------------------

# depot <nom> — crée un dépôt git vide et l'imprime.
depot() {
  local d="$BAC/$1"
  mkdir -p "$d"
  git -C "$d" init -q
  git -C "$d" config user.email 'banc@example.invalid'
  git -C "$d" config user.name 'banc'
  printf '%s\n' "$d"
}

# carte <depot> <chemin> <version> — écrit une carte portant cette version.
carte() {
  local d="$1" chemin="$2" version="$3"
  mkdir -p "$(dirname "$d/$chemin")"
  cat > "$d/$chemin" <<EOF
namespace: exemple.test/banc
version: $version
maturity: unstable

use:
  core:
  - ressource: exemple.test/RES
    version: 9.9.9
EOF
}

# commit <depot> <message>
commit() {
  git -C "$1" add -A
  git -C "$1" commit -q -m "$2"
}

# dans <depot> <args…> — lance clia depuis ce dépôt.
dans() {
  local d="$1"; shift
  ( cd "$d" && "$CLIA" "$@" )
}

# lignes_stdout <depot> <args…> — le nombre de lignes écrites sur la sortie
# standard seule. La composabilité en dépend.
lignes_stdout() {
  local d="$1"; shift
  ( cd "$d" && "$CLIA" "$@" 2>/dev/null ) | wc -l | tr -d ' '
}

# ==========================================================================
titre 'Le point d entree'
# ==========================================================================

rc 'clia sans argument affiche l aide' 0 "$CLIA"
dit 'et elle nomme la commande version' 'version'
dit 'et elle documente les codes de retour' 'Codes de retour'

rc 'clia --help' 0 "$CLIA" --help
dit 'la description est lue dans le fichier de commande' "l'alias lisible, ou le hash exact"

rc 'une commande inconnue est une demande mal formee' 2 "$CLIA" pas-une-commande
dit 'et elle renvoie a l aide' 'clia --help'

rc 'un nom de commande avec un separateur est refuse' 2 "$CLIA" ../evil
rc 'un nom de commande vide de sens est refuse' 2 "$CLIA" 'Version'

rc 'clia version --help' 0 "$CLIA" version --help
dit 'l aide dit que la source de verite est le commit' 'source de vérité est le commit'

# ==========================================================================
titre 'Hors d un depot git'
# ==========================================================================

HORS="$BAC/hors-depot"
mkdir -p "$HORS"
rc 'clia version hors d un depot git refuse' 1 bash -c "cd '$HORS' && '$CLIA' version"
dit 'et il dit pourquoi' "n'est pas dans un dépôt git"

# ==========================================================================
titre 'Un depot sans commit'
# ==========================================================================

D=$(depot vide)
rc 'sans commit ni carte, clia version refuse' 1 bash -c "cd '$D' && '$CLIA' version"
dit 'et il nomme le champ a declarer' 'version: X.Y.Z'

rc 'sans commit, --true refuse' 1 bash -c "cd '$D' && '$CLIA' version --true"
dit 'et il dit qu il n y a pas de version exacte' "pas de version exacte"

carte "$D" clia.yaml 0.1.0
rc 'avec une carte non commitee, l alias est rendu' 0 bash -c "cd '$D' && '$CLIA' version"
dit 'et le rendu est l alias declare' '0.1.0'
dit 'et il avertit qu il n est adosse a rien' "adossé à rien"
vrai 'et la sortie standard tient sur une ligne' \
  test "$(lignes_stdout "$D" version)" -eq 1

# ==========================================================================
titre 'Premier commit : une version publiee'
# ==========================================================================

D=$(depot publiee)
carte "$D" clia.yaml 0.1.0
commit "$D" 'premier commit'

SORTIE=$(dans "$D" version 2>/dev/null)
vrai 'un premier commit porte une version publiee, sans suffixe' \
  test "$SORTIE" = '0.1.0'

rc 'et la commande est satisfaite' 0 bash -c "cd '$D' && '$CLIA' version"
vrai 'sur un depot propre et publie, rien n est ecrit sur l erreur standard' \
  test -z "$( ( cd "$D" && "$CLIA" version ) 2>&1 >/dev/null )"

ATTENDU=$(git -C "$D" rev-parse HEAD)
SORTIE=$(dans "$D" version --true 2>/dev/null)
vrai '--true rend le hash complet de HEAD' test "$SORTIE" = "$ATTENDU"
vrai 'le hash fait quarante caracteres' test "${#SORTIE}" -eq 40

SORTIE=$(dans "$D" -v 2>/dev/null)
vrai 'clia -v rend la meme chose que clia version' test "$SORTIE" = '0.1.0'
SORTIE=$(dans "$D" --version 2>/dev/null)
vrai 'clia --version aussi' test "$SORTIE" = '0.1.0'

# ==========================================================================
titre 'Deuxieme commit sans changement d alias : une version de travail'
# ==========================================================================

printf 'du travail\n' > "$D/fichier.txt"
commit "$D" 'du travail, sans publier'

COURT=$(git -C "$D" rev-parse --short HEAD)
SORTIE=$(dans "$D" version 2>/dev/null)
vrai 'l alias porte le hash court quand rien n a ete publie' \
  test "$SORTIE" = "0.1.0+$COURT"
vrai 'et la sortie standard tient toujours sur une ligne' \
  test "$(lignes_stdout "$D" version)" -eq 1

ATTENDU=$(git -C "$D" rev-parse HEAD)
SORTIE=$(dans "$D" version --true 2>/dev/null)
vrai '--true suit HEAD' test "$SORTIE" = "$ATTENDU"

# ==========================================================================
titre 'Troisieme commit avec changement d alias : publiee de nouveau'
# ==========================================================================

carte "$D" clia.yaml 0.2.0
commit "$D" 'publie 0.2.0'

SORTIE=$(dans "$D" version 2>/dev/null)
vrai 'un alias different de celui du parent est une version publiee' \
  test "$SORTIE" = '0.2.0'
ne_dit_pas 'et il ne porte pas de suffixe' '+'

# Et le commit suivant retombe en version de travail.
printf 'encore\n' >> "$D/fichier.txt"
commit "$D" 'encore du travail'
COURT=$(git -C "$D" rev-parse --short HEAD)
SORTIE=$(dans "$D" version 2>/dev/null)
vrai 'le commit suivant est de nouveau une version de travail' \
  test "$SORTIE" = "0.2.0+$COURT"

# ==========================================================================
titre 'La carte, et ses trois emplacements'
# ==========================================================================

D=$(depot carte-cachee)
carte "$D" .clia.yaml 1.2.3
commit "$D" 'carte en .clia.yaml'
SORTIE=$(dans "$D" version 2>/dev/null)
vrai 'la carte est trouvee en .clia.yaml' test "$SORTIE" = '1.2.3'

D=$(depot carte-dev)
carte "$D" .dev/clia.yaml 4.5.6
commit "$D" 'carte en .dev/clia.yaml'
SORTIE=$(dans "$D" version 2>/dev/null)
vrai 'la carte est trouvee en .dev/clia.yaml' test "$SORTIE" = '4.5.6'

D=$(depot carte-double)
carte "$D" clia.yaml 1.0.0
carte "$D" .dev/clia.yaml 2.0.0
commit "$D" 'deux cartes'
SORTIE=$(dans "$D" version 2>/dev/null)
vrai 'clia.yaml l emporte sur .dev/clia.yaml' test "$SORTIE" = '1.0.0'

D=$(depot sans-carte)
printf 'rien\n' > "$D/fichier.txt"
commit "$D" 'aucune carte'
rc 'un depot commite sans carte refuse' 1 bash -c "cd '$D' && '$CLIA' version"
dit 'et il dit ce qui manque' "n'en déclare pas"

# ==========================================================================
titre 'Le champ version est lu au premier niveau seulement'
# ==========================================================================

D=$(depot imbrique)
carte "$D" clia.yaml 3.0.0
commit "$D" 'carte avec des versions imbriquees'
SORTIE=$(dans "$D" version 2>/dev/null)
vrai 'la version imbriquee sous use: n est pas confondue avec celle du depot' \
  test "$SORTIE" = '3.0.0'
faux 'et la version d une ressource n apparait pas' \
  test "$SORTIE" = '9.9.9'

# ==========================================================================
titre 'Ce qui est incertain se dit'
# ==========================================================================

D=$(depot pas-semantique)
carte "$D" clia.yaml 'tout-neuf'
commit "$D" 'un alias qui n est pas semantique'
rc 'un alias non semantique ne fait pas echouer la commande' 0 bash -c "cd '$D' && '$CLIA' version"
dit 'mais il est signale' 'X.Y.Z'
SORTIE=$(dans "$D" version 2>/dev/null)
vrai 'et il est rendu tel quel' test "$SORTIE" = 'tout-neuf'

D=$(depot sale)
carte "$D" clia.yaml 0.1.0
commit "$D" 'propre'
printf 'non commite\n' > "$D/brouillon.txt"
rc 'un repertoire de travail modifie ne fait pas echouer' 0 bash -c "cd '$D' && '$CLIA' version"
dit 'mais il est signale' 'a changé depuis ce commit'
vrai 'et la sortie standard reste sur une ligne' \
  test "$(lignes_stdout "$D" version)" -eq 1

rc '--true le signale aussi' 0 bash -c "cd '$D' && '$CLIA' version --true"
dit 'et dit que le hash designe HEAD' 'désigne HEAD'

D=$(depot alias-non-commite)
carte "$D" clia.yaml 0.1.0
commit "$D" 'publie 0.1.0'
carte "$D" clia.yaml 0.9.9
rc 'un alias modifie mais non commite ne fait pas echouer' 0 bash -c "cd '$D' && '$CLIA' version"
dit 'et clia dit que le disque declare autre chose' 'sur le disque, non commité'
SORTIE=$(dans "$D" version 2>/dev/null)
vrai 'l alias rendu est celui de HEAD, non celui du disque' test "$SORTIE" = '0.1.0'

# ==========================================================================
titre 'Les demandes mal formees'
# ==========================================================================

D=$(depot mal-forme)
carte "$D" clia.yaml 0.1.0
commit "$D" 'premier commit'

rc 'un argument inattendu est refuse' 2 bash -c "cd '$D' && '$CLIA' version bogus"
dit 'et il renvoie a l usage' 'clia version --help'
rc '--true ne prend pas d argument' 2 bash -c "cd '$D' && '$CLIA' version --true bogus"

# ==========================================================================
titre 'Le depot reel n a pas bouge'
# ==========================================================================

vrai 'HEAD est le meme qu au depart' \
  test "$(git -C "$RACINE" rev-parse HEAD)" = "$REEL_HEAD"
vrai 'et son etat de travail aussi' \
  test "$(git -C "$RACINE" status --porcelain | sort)" = "$REEL_ETAT"

bilan
