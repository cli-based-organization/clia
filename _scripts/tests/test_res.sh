#!/usr/bin/env bash
# _scripts/tests/test_res.sh — les ressources, et leur version.
#
# Éprouve SES-001 tâche 5.
#
# Le cas qui compte le plus est celui de la portée : la version d'une
# ressource ne doit pas bouger quand le dépôt avance ailleurs. C'est ce qui
# distingue une version de ressource d'une version de dépôt, et c'est la
# seule chose qu'une lecture littérale de « exactement comme celle du repo »
# aurait fait manquer.

set -uo pipefail

RACINE=$(cd -P "$(dirname "${BASH_SOURCE[0]}")/../.." && pwd)
CLIA="$RACINE/_scripts/bin/clia"

# shellcheck source=banc.sh
. "$RACINE/_scripts/tests/banc.sh"

BAC=$(mktemp -d)
trap 'rm -rf "$BAC"' EXIT

REEL_HEAD=$(git -C "$RACINE" rev-parse HEAD)
REEL_ETAT=$(git -C "$RACINE" status --porcelain | sort)

# --------------------------------------------------------------------------
# Outils
# --------------------------------------------------------------------------

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

commit() { git -C "$1" add -A; git -C "$1" commit -q -m "$2"; }

dans() { local d="$1"; shift; ( cd "$d" && "$CLIA" "$@" ); }

sortie() { local d="$1"; shift; ( cd "$d" && "$CLIA" "$@" 2>/dev/null ); }

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

bloc_options() { sed -n '/^Options :$/,$p' | tail -n +2; }

# ==========================================================================
titre 'La commande est decouverte, et documentee'
# ==========================================================================

rc 'clia --help liste res' 0 "$CLIA" --help
dit 'la commande y figure' '^  res$'
dit 'et ses signatures aussi' 'clia res release major|minor|patch RESSOURCE'

rc 'clia res --help' 0 "$CLIA" res --help
dit 'il porte les quatre signatures' 'clia res new PREFIXE NOM \[DESCRIPTION\]'
RESTE=$("$CLIA" res --help 2>/dev/null | lignes_de_prose)
vrai 'et aucune prose' test -z "$RESTE"

SORTIE=$("$CLIA" res version --help 2>/dev/null | bloc_options)
dit '--true est offerte au niveau de version' '--true'
SORTIE=$("$CLIA" res release --help 2>/dev/null | bloc_options)
ne_dit_pas 'et pas au niveau de release' '--true'

rc 'clia res --man' 0 "$CLIA" res --man
dit 'la page porte son nom' '^CLIA-RES(1)'
for section in NOM SYNOPSIS DESCRIPTION SOUS-COMMANDES OPTIONS SORTIE \
               'CODE DE RETOUR' FICHIERS EXEMPLES 'VOIR AUSSI'; do
  dit "la section $section y est" "^$section\$"
done
LONGUES=$("$CLIA" res --man 2>/dev/null | lignes_trop_longues)
vrai 'aucune ligne du manuel ne depasse 80 colonnes' test -z "$LONGUES"

HORS="$BAC/hors-depot"; mkdir -p "$HORS"
rc 'le manuel repond hors d un depot' 0 bash -c "cd '$HORS' && '$CLIA' res --man"
rc 'mais le travail exige un depot' 1 bash -c "cd '$HORS' && '$CLIA' res ls"

# ==========================================================================
titre 'Creer une ressource'
# ==========================================================================

D=$(depot creation)
rc_dans 'clia res new est satisfaite' 0 "$D" res new ANL analyse "Ce qu un examen etablit"
dit 'et elle dit ou la ressource a ete creee' '_ressources/analyse'
dit 'et que rien n est commite' "créer n'est pas publier"

DEF="$D/_ressources/analyse/analyse.yaml"
vrai 'la definition est posee a son emplacement' test -f "$DEF"
vrai 'elle declare le nom' grep -q '^nom: analyse$' "$DEF"
vrai 'elle declare le titre' grep -q '^titre: Analyse$' "$DEF"
vrai 'elle declare le prefixe' grep -q '^prefixe: ANL$' "$DEF"
vrai 'elle declare la version initiale' grep -q '^version: 0.1.0$' "$DEF"
vrai 'elle declare la description' grep -q 'Ce qu un examen etablit' "$DEF"

vrai 'la creation ne commite rien' \
  test -n "$(git -C "$D" status --porcelain)"

rc_dans 'une description omise laisse une invite' 0 "$D" res new FND fondation
vrai 'et la definition le dit' grep -q 'À rédiger' "$D/_ressources/fondation/fondation.yaml"

rc_dans 'une guillemet dans la description est remplacee' 0 "$D" res new PLN plan 'un "plan" borne'
dit 'et le remplacement est annonce' 'remplacés par des apostrophes'
vrai 'la definition reste lisible' \
  grep -q "^description: \"un 'plan' borne\"\$" "$D/_ressources/plan/plan.yaml"

# ==========================================================================
titre 'Ce que la creation refuse'
# ==========================================================================

rc_dans 'un prefixe en minuscules est refuse' 2 "$D" res new anl truc
dit 'et la regle est rappelee' 'deux à cinq majuscules'
rc_dans 'un prefixe trop long est refuse' 2 "$D" res new TROPLONG truc
rc_dans 'un prefixe avec un chiffre est refuse' 2 "$D" res new AN1 truc
rc_dans 'un nom en majuscules est refuse' 2 "$D" res new XYZ Truc
dit 'et la regle est rappelee' 'minuscules, chiffres et tirets'

rc_dans 'un emplacement occupe est refuse' 1 "$D" res new XYZ analyse
dit 'et rien n est cree' "rien n'a été créé"
rc_dans 'un prefixe deja pris est refuse' 1 "$D" res new ANL autre
dit 'en nommant qui le porte' 'déjà celui de analyse'
vrai 'et la ressource n a pas ete creee' test ! -e "$D/_ressources/autre"

rc_dans 'new sans argument est mal forme' 2 "$D" res new
rc_dans 'new avec un seul argument est mal forme' 2 "$D" res new ANL
rc_dans 'new avec un argument en trop est mal forme' 2 "$D" res new ANL x y z

# ==========================================================================
titre 'Lister'
# ==========================================================================

VIDE=$(depot vide)
rc_dans 'un depot sans ressource le dit' 0 "$VIDE" res ls
dit 'et nomme la commande qui en cree une' 'clia res new PREFIXE NOM'

commit "$D" 'ajoute les ressources'
SORTIE=$(sortie "$D" res ls)
dit 'l en-tete nomme les colonnes' '^PREFIXE  *NOM  *VERSION  *IDENTITE  *DESCRIPTION$'
dit 'chaque ressource y figure' '^ANL  *analyse  *0.1.0'
dit 'l identite est le namespace du depot suivi du prefixe' 'exemple.test/creation/ANL'
vrai 'les ressources sont triees par nom' \
  test "$(sortie "$D" res ls | tail -n +2 | awk '{print $2}' | tr '\n' ' ')" = 'analyse fondation plan '

rc_dans 'ls ne prend pas d argument' 2 "$D" res ls analyse

# ==========================================================================
titre 'La version d une ressource'
# ==========================================================================

D=$(depot version)
dans "$D" res new ANL analyse "Une analyse" >/dev/null 2>&1

rc_dans 'une ressource non commitee rend son alias declare' 0 "$D" res version analyse
dit 'et clia dit qu il n est adosse a rien' "adossé à rien"
vrai 'la sortie standard tient sur une ligne' \
  test "$(sortie "$D" res version analyse | wc -l)" -eq 1

rc_dans 'et sa version exacte est refusee' 1 "$D" res version --true analyse
dit 'faute de commit' "pas de version exacte"

commit "$D" 'ajoute analyse'
vrai 'une ressource neuve commitee est une version publiee' \
  test "$(sortie "$D" res version analyse)" = '0.1.0'
vrai 'et sa version exacte est le commit qui l a introduite' \
  test "$(sortie "$D" res version --true analyse)" = "$(git -C "$D" rev-parse HEAD)"

# Le cas central : la portée.
printf 'ailleurs\n' > "$D/ailleurs.txt"
commit "$D" 'du travail qui ne concerne pas la ressource'
COMMIT_RES=$(git -C "$D" log -1 --format=%H -- _ressources/analyse)

vrai 'un commit ailleurs ne change pas la version de la ressource' \
  test "$(sortie "$D" res version analyse)" = '0.1.0'
vrai 'ni sa version exacte' \
  test "$(sortie "$D" res version --true analyse)" = "$COMMIT_RES"
faux 'qui n est donc pas HEAD' \
  test "$(sortie "$D" res version --true analyse)" = "$(git -C "$D" rev-parse HEAD)"
vrai 'alors que la version du depot, elle, a bouge' \
  test "$(sortie "$D" version)" = "1.0.0+$(git -C "$D" rev-parse --short HEAD)"

# La ressource avance sans être publiée.
mkdir -p "$D/_ressources/analyse/primitives"
printf 'une primitive\n' > "$D/_ressources/analyse/primitives/p.md"
commit "$D" 'une primitive pour analyse'
COURT=$(git -C "$D" rev-parse --short HEAD)
vrai 'une ressource qui avance sans publier est une version de travail' \
  test "$(sortie "$D" res version analyse)" = "0.1.0+$COURT"

vrai 'une ressource se designe aussi par son prefixe' \
  test "$(sortie "$D" res version ANL)" = "$(sortie "$D" res version analyse)"

rc_dans 'une ressource inconnue est refusee' 1 "$D" res version inexistante
dit 'et clia renvoie a la liste' 'clia res ls'
rc_dans 'version sans ressource est mal forme' 2 "$D" res version
rc_dans 'version avec deux ressources est mal forme' 2 "$D" res version analyse ANL
rc_dans 'une option inconnue est mal formee' 2 "$D" res version --faux analyse

# ==========================================================================
titre 'Publier la version d une ressource'
# ==========================================================================

D=$(depot publication)
dans "$D" res new ANL analyse "Une analyse" >/dev/null 2>&1
dans "$D" res new FND fondation "Une fondation" >/dev/null 2>&1
commit "$D" 'ajoute deux ressources'

rc_dans 'clia res release patch est satisfaite' 0 "$D" res release patch analyse
vrai 'et rend le nouvel alias' test "$(sortie "$D" res version analyse)" = '0.1.1'
PUBLIEE=$(sortie "$D" res version analyse)
vrai 'qui est une version publiee, sans suffixe de travail' \
  test "$PUBLIEE" = "${PUBLIEE%%+*}"

vrai 'le message de commit nomme la ressource et sa version' \
  test "$(git -C "$D" log -1 --format=%s)" = 'release analyse 0.1.1'
vrai 'le commit ne porte que la definition' \
  test "$(git -C "$D" show --name-only --format= HEAD | tr -d '[:space:]')" = '_ressources/analyse/analyse.yaml'
vrai 'aucune etiquette n est posee' test "$(git -C "$D" tag -l | wc -l)" -eq 0
vrai 'le depot est propre apres la publication' \
  test -z "$(git -C "$D" status --porcelain)"

vrai 'minor incremente le deuxieme nombre' \
  test "$(sortie "$D" res release minor analyse)" = '0.2.0'
vrai 'major incremente le premier' \
  test "$(sortie "$D" res release major analyse)" = '1.0.0'
vrai 'le niveau s ecrit aussi en majuscules' \
  test "$(sortie "$D" res release PATCH analyse)" = '1.0.1'

vrai 'publier une ressource ne touche pas l autre' \
  test "$(sortie "$D" res version fondation)" = '0.1.0'
vrai 'ni la version du depot' \
  test "$(sortie "$D" version)" = "1.0.0+$(git -C "$D" rev-parse --short HEAD)"

printf 'sale\n' > "$D/brouillon.txt"
rc_dans 'un depot non propre empeche la publication' 1 "$D" res release patch analyse
dit 'et clia dit pourquoi' "n'est pas propre"
vrai 'la version n a pas bouge' test "$(sortie "$D" res version analyse)" = '1.0.1'
rm -f "$D/brouillon.txt"

rc_dans 'un niveau inconnu est mal forme' 2 "$D" res release majeur analyse
rc_dans 'release sans ressource est mal forme' 2 "$D" res release patch
rc_dans 'release sans argument est mal forme' 2 "$D" res release
rc_dans 'release sur une ressource inconnue est refuse' 1 "$D" res release patch inexistante

# Un alias non incrémentable.
D=$(depot alias-casse)
dans "$D" res new ANL analyse "x" >/dev/null 2>&1
sed -i 's/^version: 0.1.0$/version: tout-neuf/' "$D/_ressources/analyse/analyse.yaml"
commit "$D" 'un alias non semantique'
rc_dans 'un alias non semantique n est pas incrementable' 1 "$D" res release patch analyse
dit 'et clia dit ce qu il faut corriger' "n'est pas incrémentable"
rc_dans 'mais il est rapporte tel quel' 0 "$D" res version analyse
dit 'avec un avertissement sur sa forme' 'X.Y.Z'

# ==========================================================================
titre 'Les verbes inconnus'
# ==========================================================================

rc_dans 'un verbe inconnu est mal forme' 2 "$D" res bidule
dit 'et il renvoie a l usage' 'clia res --help'
rc_dans 'res sans verbe est mal forme' 2 "$D" res

# ==========================================================================
titre 'Le depot reel n a pas bouge'
# ==========================================================================

vrai 'HEAD est le meme qu au depart' \
  test "$(git -C "$RACINE" rev-parse HEAD)" = "$REEL_HEAD"
vrai 'et son etat de travail aussi' \
  test "$(git -C "$RACINE" status --porcelain | sort)" = "$REEL_ETAT"
vrai 'et aucune ressource n y a ete creee' test ! -e "$RACINE/_ressources"

bilan
