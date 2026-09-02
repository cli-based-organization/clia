#!/usr/bin/env bash
# _scripts/tests/test_documentation.sh — l'aide brève, et le manuel.
#
# Éprouve SES-001 tâches 3 et 13.
#
# La tâche 13 a scindé l'aide en deux formes, et le banc les mesure
# séparément. Au premier niveau, « clia --help » sert à trouver une commande :
# il porte les commandes et ce que chacune fait, sans signatures. Aux niveaux
# suivants, il sert à employer une commande déjà trouvée : il porte ses
# signatures et ses options, et aucune prose.
#
# Deux propriétés y sont mécaniques plutôt que jugées à l'oeil, parce que
# l'énoncé les pose comme des contraintes de forme :
#
#   l'aide brève d'un niveau de commande ne porte aucune prose — toute ligne
#   y est un titre de bloc ou une entrée indentée de deux espaces ;
#
#   le manuel tient dans la largeur d'une page — aucune ligne rendue ne
#   dépasse quatre-vingts colonnes.
#
# Un banc qui vérifierait ces deux choses par un simple « le motif est
# présent » laisserait passer une phrase glissée dans l'aide, ou une ligne
# qui déborde. Les deux sont donc vérifiées sur toutes les lignes.

set -uo pipefail

RACINE=$(cd -P "$(dirname "${BASH_SOURCE[0]}")/../.." && pwd)
CLIA="$RACINE/_scripts/bin/clia"

# shellcheck source=banc.sh
. "$RACINE/_scripts/tests/banc.sh"

BAC=$(mktemp -d)
trap 'rm -rf "$BAC"' EXIT

REEL_ETAT=$(git -C "$RACINE" status --porcelain | sort)

# --------------------------------------------------------------------------
# Outils de mesure
# --------------------------------------------------------------------------

_TITRE_BLOC='^[A-Za-z]+ :$'
_ENTREE='^  [^ ]'

# Rend les lignes qui ne sont ni un titre de bloc, ni une entrée indentée de
# deux espaces. Une aide brève conforme n'en produit aucune.
lignes_de_prose() {
  local ligne
  while IFS= read -r ligne; do
    [[ -z "$ligne" ]] && continue
    [[ "$ligne" =~ $_TITRE_BLOC ]] && continue
    [[ "$ligne" =~ $_ENTREE ]] && continue
    printf '%s\n' "$ligne"
  done
}

# Rend les lignes qui dépassent la largeur d'une page.
lignes_trop_longues() {
  local ligne
  while IFS= read -r ligne; do
    (( ${#ligne} > 80 )) && printf '%s\n' "$ligne"
  done
  return 0
}

# Le bloc « Options : » d'une aide brève.
bloc_options() {
  sed -n '/^Options :$/,$p' | tail -n +2
}

# ==========================================================================
titre 'L aide d un niveau de commande ne porte aucune prose'
# ==========================================================================
#
# Le premier niveau en est exclu depuis la tâche 13 : il porte désormais une
# description par commande, et c'est ce qu'elle demande.

for niveau in 'version' 'version release'; do
  # shellcheck disable=SC2086
  RESTE=$("$CLIA" $niveau --help 2>/dev/null | lignes_de_prose)
  vrai "aucune prose dans « clia ${niveau:-} --help »" test -z "$RESTE"
  [[ -n "$RESTE" ]] && printf '         ligne fautive : %s\n' "$RESTE"
done

rc 'clia --help est satisfaite' 0 "$CLIA" --help
ne_dit_pas 'et elle ne porte pas de phrase de presentation' 'système d.information'
ne_dit_pas 'et elle n explique pas les codes de retour' 'Codes de retour'

# ==========================================================================
titre 'L aide generale porte les commandes et ce que chacune fait'
# ==========================================================================
#
# SES-001 tâche 13 : pas de section usage, une description par commande, et
# les ressources séparées des commandes du noyau.

rc 'clia --help' 0 "$CLIA" --help
ne_dit_pas 'elle ne porte pas de section usage' '^Usage :$'
ne_dit_pas 'ni la signature de l outil lui-meme' 'clia \[-h | --help | --man'
ne_dit_pas 'ni celle d une commande' 'clia version release major|minor|patch'

dit 'un bloc nomme les commandes du noyau' '^Commandes :$'
dit 'et version y figure, avec ce qu elle fait' '^  version  *La version du dépôt'
dit 'extension aussi' '^  extension  *Les extensions'
dit 'et source aussi' '^  source  *Les sources de données'

dit 'un bloc nomme les ressources, a part' '^Ressources :$'
dit 'et res y figure' '^  res  *Les ressources du dépôt'
dit 'et hrn aussi' '^  hrn  *Les harnais IA'

dit 'un bloc nomme les options' '^Options :$'

# Une ressource ne figure pas parmi les commandes du noyau, ni l'inverse.
BLOC_NOYAU=$("$CLIA" --help 2>/dev/null | sed -n '/^Commandes :$/,/^$/p')
BLOC_RES=$("$CLIA" --help 2>/dev/null | sed -n '/^Ressources :$/,/^$/p')
vrai 'res n est pas dans le bloc des commandes' \
  test "$(printf '%s' "$BLOC_NOYAU" | grep -c '^  res ')" -eq 0
vrai 'et version n est pas dans celui des ressources' \
  test "$(printf '%s' "$BLOC_RES" | grep -c '^  version ')" -eq 0

vrai 'chaque commande listee porte une description' \
  test "$("$CLIA" --help 2>/dev/null | grep -cE '^  [a-z-]+ +[^ ]')" -ge 8

LONGUES=$("$CLIA" --help 2>/dev/null | lignes_trop_longues)
vrai 'aucune ligne de l aide generale ne depasse 80 colonnes' test -z "$LONGUES"
[[ -n "$LONGUES" ]] && printf '         ligne fautive : %s\n' "$LONGUES"

# ==========================================================================
titre 'L aide repond a tous les niveaux, et se restreint a celui demande'
# ==========================================================================

SORTIE=$("$CLIA" version --help 2>/dev/null)
dit 'clia version --help porte les signatures de version' 'clia version --true'
ne_dit_pas 'et pas la signature de l outil lui-meme' '\[-h | --help | --man | -v'

SORTIE=$("$CLIA" version release --help 2>/dev/null)
dit 'clia version release --help porte la signature de release' 'release major|minor|patch'
ne_dit_pas 'et pas celles des autres niveaux' 'clia version --true'

vrai 'une seule signature au niveau de release' \
  test "$("$CLIA" version release --help 2>/dev/null | sed -n '/^Usage :$/,/^$/p' | grep -c '^  clia')" -eq 1

rc 'une option placee avant --help ne perturbe pas le niveau' 0 "$CLIA" version --true --help
dit 'et l aide rendue est celle de version' 'clia version release major|minor|patch'

# ==========================================================================
titre 'Les options annoncees sont celles qui repondent a ce niveau'
# ==========================================================================

SORTIE=$("$CLIA" --help 2>/dev/null | bloc_options)
dit '-v est offerte au premier niveau' '-v, --version'

SORTIE=$("$CLIA" version --help 2>/dev/null | bloc_options)
dit '--true est offerte au niveau de version' '--true'
ne_dit_pas 'et -v ne l est pas, elle ne repond qu en premiere position' '-v, --version'

SORTIE=$("$CLIA" version release --help 2>/dev/null | bloc_options)
ne_dit_pas '--true n est pas offerte au niveau de release' '--true'
dit '--help l est' '-h, --help'
dit 'et --man aussi' '--man'

# ==========================================================================
titre 'Les formes equivalentes de la demande d aide'
# ==========================================================================

REFERENCE=$("$CLIA" --help 2>/dev/null)
for forme in '-h' 'help' ''; do
  # shellcheck disable=SC2086
  vrai "« clia ${forme:-(sans argument)} » rend la meme aide que --help" \
    test "$("$CLIA" $forme 2>/dev/null)" = "$REFERENCE"
done

# ==========================================================================
titre 'Le manuel suit les conventions unix'
# ==========================================================================

rc 'clia --man est satisfaite' 0 "$CLIA" --man
for section in NOM SYNOPSIS DESCRIPTION COMMANDES OPTIONS 'CODE DE RETOUR' \
               ENVIRONNEMENT FICHIERS EXEMPLES 'VOIR AUSSI'; do
  dit "la section $section est presente et en colonne zero" "^$section\$"
done

# SORTIE est lue par « dit » et « ne_dit_pas », qui viennent de banc.sh.
# shellcheck disable=SC2034
SORTIE=$("$CLIA" --man 2>/dev/null)
dit 'la ligne d en-tete porte le nom et la section' '^CLIA(1) .*CLIA(1)$'
dit 'le corps est indente de sept' '^       clia - '
vrai 'la derniere ligne est un pied de page' \
  test "$("$CLIA" --man 2>/dev/null | tail -1 | grep -c 'CLIA(1)$')" -eq 1

rc 'clia version --man est satisfaite' 0 "$CLIA" version --man
dit 'la page porte son propre nom' '^CLIA-VERSION(1)'
dit 'et le nom compose reste en un seul mot de section' 'clia-version - '
dit 'une sous-commande est documentee sous SOUS-COMMANDES' '^SOUS-COMMANDES$'
dit 'la description d une option est indentee de quatorze' '^              Rend la version exacte'

# ==========================================================================
titre 'Le manuel tient dans la largeur d une page'
# ==========================================================================

for page in '--man' 'version --man'; do
  # shellcheck disable=SC2086
  LONGUES=$("$CLIA" $page 2>/dev/null | lignes_trop_longues)
  vrai "aucune ligne de « clia $page » ne depasse 80 colonnes" test -z "$LONGUES"
  [[ -n "$LONGUES" ]] && printf '         ligne fautive : %s\n' "$LONGUES"
done

# ==========================================================================
titre 'La documentation ne depend d aucun depot'
# ==========================================================================

HORS="$BAC/hors-depot"
mkdir -p "$HORS"

rc 'clia --help repond hors d un depot git' 0 bash -c "cd '$HORS' && '$CLIA' --help"
rc 'clia --man aussi' 0 bash -c "cd '$HORS' && '$CLIA' --man"
rc 'clia version --help aussi' 0 bash -c "cd '$HORS' && '$CLIA' version --help"
rc 'clia version --man aussi' 0 bash -c "cd '$HORS' && '$CLIA' version --man"
dit 'et la page rendue est bien celle de version' 'clia-version - '

rc 'alors que le travail, lui, exige un depot' 1 bash -c "cd '$HORS' && '$CLIA' version"

vrai 'clia version release --man rend la meme page que clia version --man' \
  test "$("$CLIA" version release --man 2>/dev/null)" = "$("$CLIA" version --man 2>/dev/null)"

# ==========================================================================
titre 'La documentation est deterministe'
# ==========================================================================

for page in '--help' '--man' 'version --help' 'version --man'; do
  # shellcheck disable=SC2086
  vrai "deux executions de « clia $page » rendent la meme sortie" \
    test "$("$CLIA" $page 2>/dev/null)" = "$("$CLIA" $page 2>/dev/null)"
done

# ==========================================================================
titre 'La documentation decoule des declarations, non d un texte ecrit'
# ==========================================================================

# Une commande deposee dans une copie du depot doit apparaitre dans l aide
# sans qu aucun fichier du noyau soit touche. C est ce qui rend la
# documentation « accessible dynamiquement » au sens de la tache 3.
COPIE="$BAC/copie"
mkdir -p "$COPIE"
cp -r "$RACINE/_scripts" "$COPIE/"
cat > "$COPIE/_scripts/lib/cmd/fixture.sh" <<'FIN'
#!/usr/bin/env bash
# Description: Une commande de banc, deposee pour eprouver la decouverte.
# Périmètre: aucun
# Signature: fixture
# Signature: fixture pousse --fort
# Option: fixture --doucement
# Option: fixture pousse --fort
set -euo pipefail
exit 0
FIN

rc 'une commande deposee apparait dans l aide' 0 "$COPIE/_scripts/bin/clia" --help
dit 'son nom est liste, avec sa description' '^  fixture  *Une commande de banc'
dit 'et sous les commandes du noyau, car elle vient de lib/cmd' '^Commandes :$'
ne_dit_pas 'ses signatures ne sont pas dans l aide generale' 'clia fixture pousse --fort'

rc 'ses signatures sont a son propre niveau' 0 "$COPIE/_scripts/bin/clia" fixture --help
dit 'et elles y sont' 'clia fixture pousse --fort'

rc 'son aide de niveau repond' 0 "$COPIE/_scripts/bin/clia" fixture --help
dit 'avec son option propre' '--doucement'

rc 'et celle de sa sous-commande aussi' 0 "$COPIE/_scripts/bin/clia" fixture pousse --help
dit 'avec l option de ce niveau' '--fort'
ne_dit_pas 'et sans celle du niveau au-dessus' '--doucement'

RESTE=$("$COPIE/_scripts/bin/clia" fixture pousse --help 2>/dev/null | lignes_de_prose)
vrai 'et cette aide ne porte pas davantage de prose' test -z "$RESTE"

rc 'sa description alimente le manuel, elle' 0 "$COPIE/_scripts/bin/clia" --man
dit 'sous la section COMMANDES' 'deposee pour eprouver la decouverte'

# ==========================================================================
titre 'Le depot reel n a pas bouge'
# ==========================================================================

vrai 'son etat de travail est le meme qu au depart' \
  test "$(git -C "$RACINE" status --porcelain | sort)" = "$REEL_ETAT"
vrai 'et aucune commande de banc n y a ete deposee' \
  test ! -e "$RACINE/_scripts/lib/cmd/fixture.sh"

bilan
