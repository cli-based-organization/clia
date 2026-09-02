#!/usr/bin/env bash
# _scripts/tests/test_focus.sh — le focus, et ce qu'il dit au harnais.
#
# Éprouve SES-001 tâche 16.
#
# Quatre propriétés que le banc mesure, et qui n'iraient pas de soi :
#
#   les liens sont relatifs. Un lien absolu casse au clone et au déplacement
#   du dépôt, et c'est le défaut qu'une génération précédente a constaté ;
#
#   la directive du harnais est une conséquence de l'état, non un geste de
#   plus : elle paraît au premier lien et disparaît avec le dernier ;
#
#   hors des marqueurs de zone, le harnais n'est pas touché ;
#
#   relâcher le focus ne touche à rien de ce qu'il désignait ;
#
#   un alias n'est cherché que sous .dev/ — SES-001 tâche 18. Le dépôt porte
#   des archives et des worktrees qui répètent les mêmes noms, et les y
#   chercher rendait ambigu un alias qui ne désignait qu'une chose.

set -uo pipefail

RACINE=$(cd -P "$(dirname "${BASH_SOURCE[0]}")/../.." && pwd)
CLIA="$RACINE/_scripts/bin/clia"

# shellcheck source=banc.sh
. "$RACINE/_scripts/tests/banc.sh"

BAC=$(mktemp -d)
trap 'rm -rf "$BAC"' EXIT

REEL_ETAT=$(git -C "$RACINE" status --porcelain | sort)

# --------------------------------------------------------------------------
# Outils
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

dans()   { local d="$1"; shift; ( cd "$d" && "$CLIA" "$@" ); }
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

depot() {
  local d="$BAC/$1"
  mkdir -p "$d/.dev/logs/SES-002-le-focus" "$d/.dev/reqs" "$d/ailleurs" \
           "$d/.past-generations/logs/SES-002-archivee"
  git -C "$d" init -q
  printf 'namespace: exemple.test/%s\nversion: 1.0.0\n' "$1" > "$d/clia.yaml"
  printf '# Conventions\n\nCe paragraphe est à moi, et clia n%sy touche pas.\n' "'" \
    > "$d/CLAUDE.md"
  printf 'la session\n' > "$d/.dev/logs/SES-002-le-focus/session.md"
  printf 'le requis\n'  > "$d/.dev/reqs/REQ-004.md"
  printf 'autre chose\n' > "$d/ailleurs/note.md"
  # Une archive qui répète l'alias : elle ne doit pas entrer en concurrence.
  printf 'une session archivée\n' > "$d/.past-generations/logs/SES-002-archivee/session.md"
  printf 'un requis archivé\n'    > "$d/.past-generations/REQ-009.md"
  printf '%s\n' "$d"
}

# ==========================================================================
titre 'Les deux commandes sont decouvertes, et documentees'
# ==========================================================================

rc 'clia --help les liste' 0 "$CLIA" --help
dit 'focus y figure' '^  focus  *Le focus'
dit 'unfocus aussi' '^  unfocus  *Retire une information du focus'
dit 'sous les commandes du noyau' '^Commandes :$'

rc 'clia focus --help' 0 "$CLIA" focus --help
dit 'ses trois signatures y sont' 'clia focus on INFORMATION'
dit 'ls' 'clia focus ls'
dit 'clear' 'clia focus clear'
RESTE=$("$CLIA" focus --help 2>/dev/null | lignes_de_prose)
vrai 'et son aide ne porte aucune prose' test -z "$RESTE"
[[ -n "$RESTE" ]] && printf '         ligne fautive : %s\n' "$RESTE"

rc 'clia unfocus --help' 0 "$CLIA" unfocus --help
dit 'sa signature y est' 'clia unfocus INFORMATION'

for cmd in focus unfocus; do
  rc "clia $cmd --man" 0 "$CLIA" "$cmd" --man
  dit "la page porte son nom" "^CLIA-$(printf '%s' "$cmd" | tr '[:lower:]' '[:upper:]')(1)"
  for section in NOM SYNOPSIS DESCRIPTION SORTIE 'CODE DE RETOUR' \
                 FICHIERS EXEMPLES 'VOIR AUSSI'; do
    dit "la section $section y est" "^$section\$"
  done
  LONGUES=$("$CLIA" "$cmd" --man 2>/dev/null | lignes_trop_longues)
  vrai "aucune ligne du manuel de $cmd ne depasse 80 colonnes" test -z "$LONGUES"
  [[ -n "$LONGUES" ]] && printf '         ligne fautive : %s\n' "$LONGUES"
done

HORS="$BAC/hors-depot"; mkdir -p "$HORS"
rc 'le manuel repond hors d un depot' 0 bash -c "cd '$HORS' && '$CLIA' focus --man"
rc 'mais le travail exige un depot' 1 bash -c "cd '$HORS' && '$CLIA' focus ls"

# ==========================================================================
titre 'Mettre une information au focus'
# ==========================================================================

D=$(depot travail)
AVANT=$(cat "$D/CLAUDE.md")

rc_dans 'un focus vide le dit' 0 "$D" focus ls
dit 'et nomme la commande qui le remplit' 'clia focus on INFORMATION'

rc_dans 'clia focus on par alias est satisfaite' 0 "$D" focus on SES-002
dit 'et nomme ce qui est au focus' 'au focus : SES-002-le-focus'
dit 'et ce que cela designe' '.dev/logs/SES-002-le-focus'

vrai 'le lien est pose' test -L "$D/focus/SES-002-le-focus"
vrai 'il mene a la cible' \
  test "$(readlink -f "$D/focus/SES-002-le-focus")" = "$(readlink -f "$D/.dev/logs/SES-002-le-focus")"
CIBLE=$(readlink "$D/focus/SES-002-le-focus")
faux 'et il est relatif, non absolu' test "${CIBLE:0:1}" = '/'

# Un lien relatif survit au déplacement du dépôt.
cp -r "$D" "$BAC/deplace"
vrai 'il tient apres un deplacement du depot' \
  test -e "$(readlink -f "$BAC/deplace/focus/SES-002-le-focus")"

rc_dans 'un @chemin depuis la racine est accepte' 0 "$D" focus on @.dev/reqs/REQ-004.md
vrai 'et le lien est pose' test -L "$D/focus/REQ-004.md"

rc_dans 'un chemin relatif au repertoire courant aussi' 0 "$D" focus on ailleurs/note.md
vrai 'et le lien est pose' test -L "$D/focus/note.md"

SORTIE=$(sortie "$D" focus ls)
dit 'l en-tete nomme les colonnes' '^NOM *DESIGNE *ETAT$'
dit 'chaque lien y figure' 'SES-002-le-focus *\.dev/logs/SES-002-le-focus'
dit 'et le requis aussi' 'REQ-004.md *\.dev/reqs/REQ-004.md'
vrai 'les liens sont tries par nom' \
  test "$(sortie "$D" focus ls | tail -n +2 | awk '{print $1}' | tr '\n' ' ')" = 'REQ-004.md SES-002-le-focus note.md '

# ==========================================================================
titre 'Le focus n entre pas dans l index de git'
# ==========================================================================

vrai 'le .gitignore porte la ligne' grep -qx '/focus/' "$D/.gitignore"
vrai 'precedee de sa raison' grep -q '^# Le focus de clia' "$D/.gitignore"
vrai 'et git ne voit pas le repertoire' \
  test "$(git -C "$D" status --porcelain --ignored=no -- focus | wc -l)" -eq 0
vrai 'la ligne n est ecrite qu une fois' \
  test "$(grep -c '^/focus/$' "$D/.gitignore")" -eq 1

# Un .gitignore qui l'ignore déjà n'est pas retouché.
DEJA=$(depot deja-ignore)
printf 'focus/\n' > "$DEJA/.gitignore"
dans "$DEJA" focus on SES-002 >/dev/null 2>&1
vrai 'un .gitignore qui l ignore deja n est pas retouche' \
  test "$(cat "$DEJA/.gitignore")" = 'focus/'

# ==========================================================================
titre 'La directive du harnais suit l etat du focus'
# ==========================================================================

vrai 'la directive est dans le harnais' grep -q '^## Le focus$' "$D/CLAUDE.md"
vrai 'elle dit de ne prendre en compte que le focus' \
  grep -q 'ne prenez en compte' "$D/CLAUDE.md"
vrai 'elle est dans la zone geree' \
  test "$(sed -n '/CLIA:FOCUS:BEGIN/,/CLIA:FOCUS:END/p' "$D/CLAUDE.md" | grep -c '^## Le focus$')" -eq 1
vrai 'et elle n y est qu une fois, malgre trois liens' \
  test "$(grep -c '^## Le focus$' "$D/CLAUDE.md")" -eq 1
vrai 'le texte de l humain est intact' \
  grep -q "Ce paragraphe est à moi" "$D/CLAUDE.md"

# Un dépôt sans harnais travaille quand même.
SANS=$(depot sans-harnais)
rm -f "$SANS/CLAUDE.md"
rc_dans 'un depot sans harnais accepte le focus' 0 "$SANS" focus on SES-002
vrai 'et aucun harnais n est cree' test ! -e "$SANS/CLAUDE.md"

# ==========================================================================
titre 'Ce que focus on refuse'
# ==========================================================================

rc_dans 'remettre la meme information ne fait rien' 0 "$D" focus on SES-002
dit 'et clia le dit' 'est déjà au focus'
vrai 'et rien n a double' test "$(sortie "$D" focus ls | tail -n +2 | wc -l)" -eq 3

# Deux informations de même nom ne peuvent pas être au focus ensemble.
mkdir -p "$D/autre-part"
printf 'un homonyme\n' > "$D/autre-part/note.md"
rc_dans 'un nom deja pris est refuse' 1 "$D" focus on autre-part/note.md
dit 'et clia dit ce que le lien designe deja' 'désigne autre chose'
dit 'et comment le liberer' 'clia unfocus note.md'

mkdir -p "$D/.dev/logs/SES-002-bis"
rc_dans 'un alias ambigu est refuse' 1 "$D" focus on SES-002
dit 'en nommant les candidates' '\.dev/logs/SES-002-bis'
dit 'et en disant comment lever le doute' 'désignez-la par son chemin'
rm -rf "$D/.dev/logs/SES-002-bis"

rc_dans 'un alias que rien ne porte est refuse' 1 "$D" focus on ZZZ-999
dit 'et clia dit ce qu il cherchait' 'ZZZ-999-'
dit 'et ou il a cherche' 'sous \.dev/'

# ==========================================================================
titre 'Un alias n est cherche que sous .dev'
# ==========================================================================
#
# SES-001 tâche 18. Le dépôt réel portait le même alias quatre fois : une
# instance, deux générations archivées et un worktree. L'alias devenait
# ambigu là où il ne désignait qu'une chose.

ARCH=$(depot archives)
vrai 'l archive porte pourtant le meme alias' \
  test -d "$ARCH/.past-generations/logs/SES-002-archivee"
rc_dans 'et l alias reste sans ambiguite' 0 "$ARCH" focus on SES-002
dit 'car seule l instance sous .dev est vue' 'désigne \.dev/logs/SES-002-le-focus'
vrai 'un seul lien est pose' test "$(sortie "$ARCH" focus ls | tail -n +2 | wc -l)" -eq 1

rc_dans 'un alias qui n existe que hors de .dev est introuvable' 1 "$ARCH" focus on REQ-009
dit 'et clia dit ou il a cherche' 'sous \.dev/'
dit 'et que le chemin reste possible' 'par son chemin'
rc_dans 'ce document se met au focus par son chemin' 0 "$ARCH" focus on @.past-generations/REQ-009.md
vrai 'et le lien est pose' test -L "$ARCH/focus/REQ-009.md"

SANS_DEV=$(depot sans-dev)
rm -rf "$SANS_DEV/.dev"
rc_dans 'un depot sans .dev refuse l alias sans echouer autrement' 1 "$SANS_DEV" focus on SES-002
dit 'et le dit' 'aucune instance'
rc_dans 'un chemin qui n existe pas est refuse' 1 "$D" focus on @nulle-part.md
dit 'et clia rappelle les trois formes' 'alias PREFIXE-SEQ'

rc_dans 'pointer le focus sur lui-meme est refuse' 1 "$D" focus on @focus
dit 'et clia dit pourquoi' 'ne porte que des liens'

rc_dans 'on sans information est mal forme' 2 "$D" focus on
rc_dans 'on avec deux informations est mal forme' 2 "$D" focus on a b
rc_dans 'ls ne prend pas d argument' 2 "$D" focus ls trop
rc_dans 'un verbe inconnu est mal forme' 2 "$D" focus bidule
rc_dans 'focus sans verbe est mal forme' 2 "$D" focus

# ==========================================================================
titre 'Un lien dont la cible a disparu le dit'
# ==========================================================================

rm -f "$D/ailleurs/note.md"
SORTIE=$(sortie "$D" focus ls)
dit 'ls le constate' 'note.md .*cible absente'
ne_dit_pas 'et les autres restent sains' 'REQ-004.md .*cible absente'
rc_dans 'et il se retire quand meme' 0 "$D" unfocus note.md
vrai 'le lien est parti' test ! -e "$D/focus/note.md"

# ==========================================================================
titre 'Retirer du focus'
# ==========================================================================

rc_dans 'clia unfocus par le nom du lien' 0 "$D" unfocus REQ-004.md
dit 'et clia dit ce qu il a retire' 'retiré du focus : REQ-004.md'
dit 'et que la cible est intacte' "n'a pas été touché"
vrai 'le lien est parti' test ! -e "$D/focus/REQ-004.md"
vrai 'et le document reste' test -f "$D/.dev/reqs/REQ-004.md"

dans "$D" focus on @.dev/reqs/REQ-004.md >/dev/null 2>&1
rc_dans 'clia unfocus par ce que le lien designe' 0 "$D" unfocus @.dev/reqs/REQ-004.md
vrai 'le lien est parti' test ! -e "$D/focus/REQ-004.md"

rc_dans 'retirer le dernier ote la directive' 0 "$D" unfocus SES-002-le-focus
dit 'et clia le dit' 'sa directive est ôtée de CLAUDE.md'
vrai 'la directive est partie' test "$(grep -c '^## Le focus$' "$D/CLAUDE.md")" -eq 0

# Poser puis retirer rend le harnais à ce qu'il était, aux marqueurs près.
APRES=$(grep -v 'CLIA:FOCUS:' "$D/CLAUDE.md")
vrai 'le harnais est rendu a ce qu il etait' test "$APRES" = "$AVANT"
[[ "$APRES" != "$AVANT" ]] && diff <(printf '%s\n' "$AVANT") <(printf '%s\n' "$APRES")

rc_dans 'retirer ce qui n est pas au focus est refuse' 1 "$D" unfocus inexistant
dit 'et clia dit que le focus est vide' 'le focus est vide'
rc_dans 'unfocus sans information est mal forme' 2 "$D" unfocus
rc_dans 'unfocus avec deux informations est mal forme' 2 "$D" unfocus a b

# ==========================================================================
titre 'Relacher tout le focus'
# ==========================================================================

V=$(depot vidange)
dans "$V" focus on SES-002 >/dev/null 2>&1
dans "$V" focus on @.dev/reqs/REQ-004.md >/dev/null 2>&1

rc_dans 'clia focus clear est satisfaite' 0 "$V" focus clear
dit 'et compte ce qui est parti' '2 lien(s) retiré(s)'
dit 'et dit que rien n a ete touche' "n'a été touché"
vrai 'le focus est vide' test -z "$(ls -A "$V/focus")"
vrai 'les documents sont intacts' \
  test -f "$V/.dev/reqs/REQ-004.md" -a -d "$V/.dev/logs/SES-002-le-focus"
vrai 'et la directive est otee' test "$(grep -c '^## Le focus$' "$V/CLAUDE.md")" -eq 0

rc_dans 'vider un focus deja vide ne fait rien' 0 "$V" focus clear
dit 'et clia le dit' 'est déjà vide'

dans "$V" focus on SES-002 >/dev/null 2>&1
rc_dans 'clean repond aussi' 0 "$V" focus clean
dans "$V" focus on SES-002 >/dev/null 2>&1
rc_dans 'et reset aussi' 0 "$V" focus reset
rc_dans 'clear ne prend pas d argument' 2 "$V" focus clear trop

# ==========================================================================
titre 'Le depot reel n a pas bouge'
# ==========================================================================

vrai 'son etat de travail est le meme qu au depart' \
  test "$(git -C "$RACINE" status --porcelain | sort)" = "$REEL_ETAT"

bilan
