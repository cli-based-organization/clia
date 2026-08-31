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

rc 'une commande inconnue est une demande mal formee' 2 "$CLIA" pas-une-commande
dit 'et elle renvoie a l aide' 'clia --help'

rc 'un nom de commande avec un separateur est refuse' 2 "$CLIA" ../evil
rc 'un nom de commande vide de sens est refuse' 2 "$CLIA" 'Version'

rc 'clia version --help' 0 "$CLIA" version --help

# Ce qui explique a quitté l'aide brève pour le manuel — SES-001 tâche 3. Ces
# trois cas suivent le texte à son nouvel emplacement plutôt que de
# disparaître : ce qu'ils gardaient reste gardé.
rc 'clia --man' 0 "$CLIA" --man
dit 'le manuel documente les codes de retour' '^CODE DE RETOUR$'
dit 'et la description du fichier de commande y est reprise' "l'alias lisible, ou le hash exact"

rc 'clia version --man' 0 "$CLIA" version --man
dit 'le manuel dit que la source de verite est le commit' 'source de vérité est le commit'

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
titre 'Publier : les trois post-conditions de SES-001 tache 2'
# ==========================================================================

# publiable <nom> <version> — un depot propre, d un seul commit, publiable.
publiable() {
  local d
  d=$(depot "$1")
  carte "$d" clia.yaml "$2"
  commit "$d" 'premier commit'
  printf '%s\n' "$d"
}

D=$(publiable post-conditions 1.2.3)
AVANT=$(dans "$D" version 2>/dev/null)
rc 'clia version release patch est satisfaite' 0 bash -c "cd '$D' && '$CLIA' version release patch"

APRES=$(dans "$D" version 2>/dev/null)
vrai 'post-condition 1 : la version rapportee est une version publiee' \
  test "$APRES" = "${APRES%%+*}"
faux 'et elle ne porte donc pas de suffixe de travail' \
  test "$APRES" != "${APRES%%+*}"
vrai 'post-condition 2 : elle est superieure a la precedente' \
  test "$(printf '%s\n%s\n' "$AVANT" "$APRES" | sort -V | tail -1)" = "$APRES"
vrai 'post-condition 3 : l increment est celui demande' test "$APRES" = '1.2.4'

# ==========================================================================
titre 'Les trois niveaux d increment'
# ==========================================================================

D=$(publiable incr-patch 1.2.3)
vrai 'patch incremente le troisieme nombre' \
  test "$(dans "$D" version release patch 2>/dev/null)" = '1.2.4'

D=$(publiable incr-minor 1.2.3)
vrai 'minor incremente le deuxieme et remet le troisieme a zero' \
  test "$(dans "$D" version release minor 2>/dev/null)" = '1.3.0'

D=$(publiable incr-major 1.2.3)
vrai 'major incremente le premier et remet les deux autres a zero' \
  test "$(dans "$D" version release major 2>/dev/null)" = '2.0.0'

# Regression. Une premiere ecriture decoupait la correspondance en champs
# separes par des espaces ; un prefixe absent y produisait un champ vide que
# le decoupage faisait disparaitre, et 1.2.3 devenait 12.3.1.
D=$(publiable regression-decalage 1.2.3)
SORTIE=$(dans "$D" version release patch 2>/dev/null)
faux 'les nombres ne se decalent pas quand le prefixe est absent' \
  test "$SORTIE" = '12.3.1'
vrai 'et le resultat est bien 1.2.4' test "$SORTIE" = '1.2.4'

D=$(publiable zero-en-tete 1.08.0)
vrai 'un nombre a zero en tete est lu en base dix' \
  test "$(dans "$D" version release minor 2>/dev/null)" = '1.9.0'

D=$(publiable majuscules 1.2.3)
vrai 'le niveau s ecrit aussi en majuscules' \
  test "$(dans "$D" version release PATCH 2>/dev/null)" = '1.2.4'

# ==========================================================================
titre 'Ce que l alias porte est conserve, ou dit'
# ==========================================================================

D=$(publiable prefixe-v v1.2.3)
vrai 'le prefixe v est conserve' \
  test "$(dans "$D" version release patch 2>/dev/null)" = 'v1.2.4'

D=$(publiable pre-publication 1.2.3-beta)
SORTIE=$(dans "$D" version release patch 2>/dev/null)
vrai 'le tag de pre-publication est retire' test "$SORTIE" = '1.2.4'
rc 'et le retrait est annonce' 0 bash -c "cd '$(publiable pre-publication-bis 2.0.0-rc.1)' && '$CLIA' version release patch"
dit 'en nommant le tag retire' 'pré-publication'

D=$(depot commentaire)
cat > "$D/clia.yaml" <<'CARTE'
namespace: exemple.test/banc
version: 1.2.3   # l alias lisible, tenu a la main
maturity: unstable

use:
  core:
  - ressource: exemple.test/RES
    version: 9.9.9
CARTE
commit "$D" 'carte avec commentaire'
dans "$D" version release patch >/dev/null 2>&1
vrai 'le commentaire de fin de ligne est conserve' \
  grep -q 'version: 1.2.4  # l alias lisible' "$D/clia.yaml"
vrai 'la version imbriquee sous use: n est pas touchee' \
  grep -q '    version: 9.9.9' "$D/clia.yaml"
vrai 'le reste de la carte est intact' \
  grep -q '^namespace: exemple.test/banc' "$D/clia.yaml"

D=$(depot carte-dev-release)
carte "$D" .dev/clia.yaml 0.4.0
commit "$D" 'carte en .dev'
vrai 'la publication trouve la carte a ses autres emplacements' \
  test "$(dans "$D" version release minor 2>/dev/null)" = '0.5.0'

# ==========================================================================
titre 'La pre-condition : le depot doit etre propre'
# ==========================================================================

D=$(publiable sale-non-suivi 1.2.3)
printf 'brouillon\n' > "$D/brouillon.txt"
rc 'un fichier non suivi empeche la publication' 1 bash -c "cd '$D' && '$CLIA' version release patch"
dit 'et clia dit pourquoi' "n'est pas propre"
dit 'et montre ce qui salit le depot' 'brouillon.txt'
vrai 'la version n a pas bouge' test "$(dans "$D" version 2>/dev/null)" = '1.2.3'
vrai 'et aucun commit n a ete cree' \
  test "$(git -C "$D" rev-list --count HEAD)" -eq 1

D=$(publiable sale-modifie 1.2.3)
printf 'change\n' >> "$D/clia.yaml"
rc 'un fichier suivi modifie empeche la publication' 1 bash -c "cd '$D' && '$CLIA' version release patch"
vrai 'et la carte n est pas reecrite' \
  test "$(git -C "$D" diff --name-only)" = 'clia.yaml'

D=$(publiable sale-indexe 1.2.3)
printf 'indexe\n' > "$D/indexe.txt"
git -C "$D" add indexe.txt
rc 'un changement indexe empeche la publication' 1 bash -c "cd '$D' && '$CLIA' version release patch"
vrai 'la version n a pas bouge' test "$(dans "$D" version 2>/dev/null)" = '1.2.3'

# ==========================================================================
titre 'Ce que le commit de publication porte'
# ==========================================================================

D=$(publiable commit-propre 1.2.3)
dans "$D" version release minor >/dev/null 2>&1
vrai 'le commit ne porte qu un seul fichier' \
  test "$(git -C "$D" show --name-only --format= HEAD | grep -c .)" -eq 1
vrai 'et ce fichier est la carte' \
  test "$(git -C "$D" show --name-only --format= HEAD | tr -d '[:space:]')" = 'clia.yaml'
vrai 'le message de commit nomme la version publiee' \
  test "$(git -C "$D" log -1 --format=%s)" = 'release 1.3.0'
vrai 'aucune etiquette n est posee' \
  test "$(git -C "$D" tag -l | wc -l)" -eq 0
vrai 'le depot est propre apres la publication' \
  test -z "$(git -C "$D" status --porcelain)"
vrai 'la sortie standard tient sur une ligne' \
  test "$(lignes_stdout "$D" version)" -eq 1

# Deux publications de suite : chacune est publiee, et l historique le montre.
D=$(publiable deux-publications 1.0.0)
dans "$D" version release minor >/dev/null 2>&1
dans "$D" version release patch >/dev/null 2>&1
vrai 'deux publications successives sont chacune publiees' \
  test "$(dans "$D" version 2>/dev/null)" = '1.1.1'
vrai 'et l historique porte les deux' \
  test "$(git -C "$D" rev-list --count HEAD)" -eq 3

# Un commit ordinaire apres une publication rend la version au travail.
printf 'suite\n' > "$D/suite.txt"
commit "$D" 'du travail apres la publication'
COURT=$(git -C "$D" rev-parse --short HEAD)
vrai 'un commit ordinaire apres une publication rend une version de travail' \
  test "$(dans "$D" version 2>/dev/null)" = "1.1.1+$COURT"

# ==========================================================================
titre 'Les refus de publication'
# ==========================================================================

D=$(publiable niveau-absent 1.2.3)
rc 'sans niveau, la demande est mal formee' 2 bash -c "cd '$D' && '$CLIA' version release"
dit 'et les niveaux sont nommes' 'major, minor et patch'

rc 'un niveau inconnu est refuse' 2 bash -c "cd '$D' && '$CLIA' version release majeur"
rc 'deux niveaux sont refuses' 2 bash -c "cd '$D' && '$CLIA' version release patch minor"
vrai 'et rien n a ete publie' test "$(dans "$D" version 2>/dev/null)" = '1.2.3'

D=$(publiable alias-non-incrementable tout-neuf)
rc 'un alias non semantique n est pas incrementable' 1 bash -c "cd '$D' && '$CLIA' version release patch"
dit 'et clia dit ce qu il faut corriger' "n'est pas incrémentable"
vrai 'la carte n est pas touchee' \
  test -z "$(git -C "$D" status --porcelain)"

D=$(depot publier-sans-carte)
printf 'rien\n' > "$D/fichier.txt"
commit "$D" 'aucune carte'
rc 'publier sans carte est refuse' 1 bash -c "cd '$D' && '$CLIA' version release patch"
dit 'et clia dit ce qui manque' 'aucune carte'

D=$(depot publier-sans-commit)
rc 'publier sans commit est refuse' 1 bash -c "cd '$D' && '$CLIA' version release patch"
dit 'et clia dit qu il n y a rien a incrementer' 'aucun commit'

rc 'publier hors d un depot git est refuse' 1 bash -c "cd '$HORS' && '$CLIA' version release patch"

# ==========================================================================
titre 'Le depot reel n a pas bouge'
# ==========================================================================

vrai 'HEAD est le meme qu au depart' \
  test "$(git -C "$RACINE" rev-parse HEAD)" = "$REEL_HEAD"
vrai 'et son etat de travail aussi' \
  test "$(git -C "$RACINE" status --porcelain | sort)" = "$REEL_ETAT"

bilan
