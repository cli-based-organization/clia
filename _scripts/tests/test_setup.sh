#!/usr/bin/env bash
# _scripts/tests/test_setup.sh — l'installation, et l'activation.
#
# Éprouve SES-001 tâche 4.
#
# Une activation modifie le shell qui la source. Un banc qui la sourcerait
# lui-même mesurerait ses propres effets de bord, et le premier cas
# fausserait tous les suivants. Chaque scénario est donc joué dans un shell
# neuf, dont l'environnement est débarrassé de toute variable d'installation
# héritée — y compris celle du shell qui lance le banc.

set -uo pipefail

RACINE=$(cd -P "$(dirname "${BASH_SOURCE[0]}")/../.." && pwd)
SETUP="$RACINE/setup.sh"
BIN="$RACINE/_scripts/bin"

# shellcheck source=banc.sh
. "$RACINE/_scripts/tests/banc.sh"

BAC=$(mktemp -d)
trap 'rm -rf "$BAC"' EXIT

REEL_ETAT=$(git -C "$RACINE" status --porcelain | sort)

# --------------------------------------------------------------------------
# Outils
# --------------------------------------------------------------------------

# depot <nom> — un dépôt git jetable, portant une carte, et l'imprime.
depot() {
  local d="$BAC/$1"
  mkdir -p "$d"
  git -C "$d" init -q
  git -C "$d" config user.email 'banc@example.invalid'
  git -C "$d" config user.name 'banc'
  printf 'namespace: exemple.test/%s\nversion: 1.0.0\n' "$1" > "$d/clia.yaml"
  git -C "$d" add -A
  git -C "$d" commit -q -m 'premier commit'
  printf '%s\n' "$d"
}

# scenario <code bash> — joue le code dans un shell neuf, sans installation
# héritée. Sortie standard et erreur confondues, pour que les assertions de
# texte voient les deux.
scenario() {
  env -u CLIA_INSTALLATION -u CLIA_SOURCE_DIR -u CLIA_PORTEE -u CLIA_WORK_DIR \
    bash -c "$1" 2>&1
}

# rc_scenario <titre> <attendu> <code bash>
rc_scenario() {
  local titre="$1" attendu="$2" code="$3" reel
  SORTIE=$(scenario "$code"); reel=$?
  if (( reel == attendu )); then
    ok "$titre"
  else
    echec "$titre" "code $reel, attendu $attendu — $(printf '%s' "$SORTIE" | tr '\n' '|' | cut -c1-140)"
  fi
}

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

PROJET=$(depot projet)
AUTRE=$(depot autre)
mkdir -p "$BAC/pas-un-depot"

# ==========================================================================
titre 'Ce qui doit etre source refuse d etre execute'
# ==========================================================================

rc 'activate execute est refuse' 1 bash "$SETUP" activate
dit 'et il dit comment le lancer' '\. setup.sh activate'
rc 'deactivate execute est refuse' 1 bash "$SETUP" deactivate
dit 'et il dit comment le lancer' '\. setup.sh deactivate'

rc 'status s execute sans etre source' 1 bash "$SETUP" status
dit 'et rapporte qu il n y a pas d installation' 'aucune installation'
rc 'help s execute sans etre source' 0 bash "$SETUP" help
rc 'le manuel s execute sans etre source' 0 bash "$SETUP" --man

# ==========================================================================
titre 'Les demandes mal formees'
# ==========================================================================

rc 'un verbe inconnu est une demande mal formee' 2 bash "$SETUP" bidule
dit 'et il renvoie a l usage' 'setup.sh help'
rc '-C sans valeur est une demande mal formee' 2 bash "$SETUP" -C
dit 'et il dit ce qui manque' '-C attend un répertoire'

rc 'sans verbe, l aide est rendue' 0 bash "$SETUP"
dit 'et elle porte les signatures' '\. setup.sh \[-C ROOT_PATH\] activate'

# ==========================================================================
titre 'La documentation suit le contrat de la tache 3'
# ==========================================================================

RESTE=$(bash "$SETUP" help 2>/dev/null | lignes_de_prose)
vrai 'l aide breve de setup.sh ne porte aucune prose' test -z "$RESTE"
[[ -n "$RESTE" ]] && printf '         ligne fautive : %s\n' "$RESTE"

rc 'le manuel de setup.sh' 0 bash "$SETUP" --man
dit 'porte son nom de page' '^CLIA-SETUP(1)'
for section in NOM SYNOPSIS DESCRIPTION VERBES OPTIONS ENVIRONNEMENT \
               'CODE DE RETOUR' EXEMPLES 'VOIR AUSSI'; do
  dit "la section $section y est" "^$section\$"
done
dit 'les trois proprietes d une installation y sont nommees' 'Sa durée de vie dit'

LONGUES=$(bash "$SETUP" --man 2>/dev/null | lignes_trop_longues)
vrai 'aucune ligne du manuel ne depasse 80 colonnes' test -z "$LONGUES"
[[ -n "$LONGUES" ]] && printf '         ligne fautive : %s\n' "$LONGUES"

# ==========================================================================
titre 'Activer : ce que l installation pose'
# ==========================================================================

rc_scenario 'une activation est satisfaite' 0 "
  cd '$PROJET' && . '$SETUP' activate"
dit 'et elle nomme la portee' "clia est actif, sur $PROJET"

SORTIE=$(scenario "cd '$PROJET' && . '$SETUP' activate >/dev/null 2>&1
  printf 'installation=%s\n' \"\$CLIA_INSTALLATION\"
  printf 'source=%s\n' \"\$CLIA_SOURCE_DIR\"
  printf 'portee=%s\n' \"\$CLIA_PORTEE\"")
dit 'la nature de l installation est posee' '^installation=activation$'
dit 'la source est le depot ou vit setup.sh' "^source=$RACINE\$"
dit 'la portee est la racine du depot de travail' "^portee=$PROJET\$"

SORTIE=$(scenario "cd '$PROJET' && . '$SETUP' activate >/dev/null 2>&1
  command -v clia")
dit 'la commande clia devient joignable par son nom' "^$BIN/clia\$"

SORTIE=$(scenario "cd '$PROJET' && . '$SETUP' activate >/dev/null 2>&1
  bash '$SETUP' status")
dit 'status rapporte la nature' '^installation   activation$'
dit 'status rapporte la duree de vie' '^durée de vie   le shell courant$'
dit 'status rapporte la source' "^source         $RACINE\$"
dit 'status rapporte la portee' "^portée         $PROJET\$"

rc_scenario 'status est satisfaite quand une installation est en place' 0 "
  cd '$PROJET' && . '$SETUP' activate >/dev/null 2>&1
  bash '$SETUP' status"

# La portée se prend depuis un sous-répertoire : c'est la racine du dépôt.
mkdir -p "$PROJET/sous/dossier"
SORTIE=$(scenario "cd '$PROJET/sous/dossier' && . '$SETUP' activate >/dev/null 2>&1
  printf '%s\n' \"\$CLIA_PORTEE\"")
dit 'la portee est la racine, non le repertoire ou l on se trouve' "^$PROJET\$"

SORTIE=$(scenario "cd '$BAC' && . '$SETUP' -C 'projet' activate >/dev/null 2>&1
  printf '%s\n' \"\$CLIA_PORTEE\"")
dit '-C accepte un chemin relatif' "^$PROJET\$"

# ==========================================================================
titre 'Le shell ne garde rien qu il n ait demande'
# ==========================================================================

SORTIE=$(scenario "cd '$PROJET' && . '$SETUP' activate >/dev/null 2>&1
  compgen -A function _clia_ 2>/dev/null
  compgen -v _CLIA_ 2>/dev/null
  compgen -v _clia_ 2>/dev/null
  printf 'FIN\n'")
vrai 'aucune fonction ni variable interne ne subsiste' test "$SORTIE" = 'FIN'

SORTIE=$(scenario "cd '$PROJET' && . '$SETUP' activate >/dev/null 2>&1
  printf '%s\n' \"\$(tr ':' '\n' <<<\"\$PATH\" | grep -c '^$BIN\$')\"")
vrai 'le repertoire des executables est inscrit une seule fois' test "$SORTIE" = '1'

SORTIE=$(scenario "cd '$PROJET'
  . '$SETUP' activate >/dev/null 2>&1
  . '$SETUP' activate >/dev/null 2>&1
  . '$SETUP' activate >/dev/null 2>&1
  printf '%s\n' \"\$(tr ':' '\n' <<<\"\$PATH\" | grep -c '^$BIN\$')\"")
vrai 'trois activations ne l inscrivent pas trois fois' test "$SORTIE" = '1'

# ==========================================================================
titre 'La portee limite le travail a un seul depot'
# ==========================================================================

SORTIE=$(scenario "cd '$PROJET' && . '$SETUP' activate >/dev/null 2>&1
  clia version 2>/dev/null")
vrai 'dans la portee, la commande travaille' test "$SORTIE" = '1.0.0'

rc_scenario 'hors de la portee, la commande refuse' 1 "
  cd '$PROJET' && . '$SETUP' activate >/dev/null 2>&1
  cd '$AUTRE' && clia version"
dit 'et clia dit ou est la portee' "portée : $PROJET"
dit 'et ou l on se trouve' "ici    : $AUTRE"
dit 'et comment travailler ici' 'setup.sh -C . activate'

rc_scenario 'hors de la portee, l aide repond quand meme' 0 "
  cd '$PROJET' && . '$SETUP' activate >/dev/null 2>&1
  cd '$AUTRE' && clia version --help"

rc_scenario 'hors de la portee, le manuel repond quand meme' 0 "
  cd '$PROJET' && . '$SETUP' activate >/dev/null 2>&1
  cd '$AUTRE' && clia version --man"

rc_scenario 'sans installation, aucune portee ne restreint' 0 "
  cd '$AUTRE' && '$BIN/clia' version"

# ==========================================================================
titre 'Deplacer, et refuser de deplacer'
# ==========================================================================

SORTIE=$(scenario "cd '$PROJET' && . '$SETUP' activate >/dev/null 2>&1
  cd '$AUTRE' && . '$SETUP' activate 2>&1
  printf 'portee=%s\n' \"\$CLIA_PORTEE\"")
dit 'une activation deplacee le dit' "activation déplacée de $PROJET vers $AUTRE"
dit 'et la portee a bien change' "^portee=$AUTRE\$"

rc_scenario 'activer hors d un depot git est refuse' 1 "
  . '$SETUP' -C '$BAC/pas-un-depot' activate"
dit 'et clia dit pourquoi' "n'est pas dans un dépôt git"
dit 'et rappelle ce qu est une portee' 'un dépôt de travail'

SORTIE=$(scenario "cd '$PROJET' && . '$SETUP' activate >/dev/null 2>&1
  . '$SETUP' -C '$BAC/pas-un-depot' activate >/dev/null 2>&1
  printf 'portee=%s\n' \"\$CLIA_PORTEE\"")
dit 'un refus laisse l activation precedente intacte' "^portee=$PROJET\$"

rc_scenario 'activer sur un repertoire absent est refuse' 1 "
  . '$SETUP' -C '$BAC/nulle-part' activate"
dit 'et clia le dit' "n'existe pas"

# ==========================================================================
titre 'Desactiver rend le shell a son etat'
# ==========================================================================

rc_scenario 'une desactivation est satisfaite' 0 "
  cd '$PROJET' && . '$SETUP' activate >/dev/null 2>&1
  . '$SETUP' deactivate"
dit 'et elle le dit' 'activation retirée du shell courant'

SORTIE=$(scenario "cd '$PROJET'
  AVANT=\"\$PATH\"
  . '$SETUP' activate >/dev/null 2>&1
  . '$SETUP' deactivate >/dev/null 2>&1
  [[ \"\$PATH\" == \"\$AVANT\" ]] && printf 'identique\n' || printf 'different: %s\n' \"\$PATH\"")
vrai 'le PATH est rendu a l identique' test "$SORTIE" = 'identique'

SORTIE=$(scenario "cd '$PROJET'
  . '$SETUP' activate >/dev/null 2>&1
  . '$SETUP' deactivate >/dev/null 2>&1
  printf 'installation=[%s] source=[%s] portee=[%s]\n' \
    \"\${CLIA_INSTALLATION:-}\" \"\${CLIA_SOURCE_DIR:-}\" \"\${CLIA_PORTEE:-}\"")
vrai 'les variables d installation sont retirees' \
  test "$SORTIE" = 'installation=[] source=[] portee=[]'

rc_scenario 'desactiver deux fois reste satisfait' 0 "
  cd '$PROJET' && . '$SETUP' activate >/dev/null 2>&1
  . '$SETUP' deactivate >/dev/null 2>&1
  . '$SETUP' deactivate"
dit 'et la seconde fois le dit' "il n'y a rien à retirer"

rc_scenario 'desactiver sans avoir active reste satisfait' 0 "
  cd '$PROJET' && . '$SETUP' deactivate"

# ==========================================================================
titre 'Une activation qui en masque une autre le dit'
# ==========================================================================

FAUX="$BAC/faux-bin"
mkdir -p "$FAUX"
printf '#!/usr/bin/env bash\nexit 0\n' > "$FAUX/clia"
chmod +x "$FAUX/clia"

# Le PATH est fixé pour ces deux cas plutôt qu'hérité : la machine du banc
# peut déjà porter une installation de clia — celle-ci en porte une, posée
# par la génération précédente — et le second cas dépendrait alors de ce qui
# se trouve sur cette machine-là.
MINIMAL='/usr/bin:/bin'

SORTIE=$(scenario "cd '$PROJET' && export PATH='$FAUX:$MINIMAL'
  . '$SETUP' activate 2>&1")
dit 'le masquage est signale' "cette activation en masque une autre : $FAUX/clia"

SORTIE=$(scenario "cd '$PROJET' && export PATH='$MINIMAL'
  . '$SETUP' activate 2>&1")
ne_dit_pas 'et il ne l est pas quand il n y a rien a masquer' 'en masque une autre'
dit 'l activation reussit tout de meme' 'clia est actif'

# ==========================================================================
titre 'Le depot reel n a pas bouge'
# ==========================================================================

vrai 'son etat de travail est le meme qu au depart' \
  test "$(git -C "$RACINE" status --porcelain | sort)" = "$REEL_ETAT"

bilan
