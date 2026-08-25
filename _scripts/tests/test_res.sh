#!/usr/bin/env bash
# _scripts/tests/test_res.sh — banc de clia res, et de USE-003.
#
# Deux dépôts, comme les commandes en distinguent deux : un dépôt source qui
# fait office de remote, et un dépôt de travail où les ressources se créent.
# Le dépôt réel n'est jamais écrit, et c'est vérifié en fin de banc.
#
# Lancement :  bash _scripts/tests/test_res.sh

set -uo pipefail

RACINE=$(cd -P "$(dirname "${BASH_SOURCE[0]}")/../.." >/dev/null 2>&1 && pwd)

# shellcheck source=banc.sh
. "$(dirname "${BASH_SOURCE[0]}")/banc.sh"

BAC=$(mktemp -d) || exit 1
trap 'rm -rf "$BAC"' EXIT

SOURCE="$BAC/source"
mkdir -p "$SOURCE"
cp -r "$RACINE/_scripts" "$RACINE/_ressources" "$SOURCE/"
mkdir -p "$SOURCE/.dev"
cp "$RACINE/.dev/clia.yaml" "$SOURCE/.dev/clia.yaml"
CLIA="$SOURCE/_scripts/bin/clia"

EMPREINTE_SOURCE=$(cd "$RACINE" && git status --porcelain 2>/dev/null | sort)

PROJET="$BAC/projet"
"$CLIA" init "$PROJET" >/dev/null 2>&1 || { printf 'banc: clia init a échoué\n' >&2; exit 1; }

clia() { ( cd "$PROJET" && "$CLIA" "$@" ); }

liste_yaml() {
  awk -v cle="$2" '
    $0 ~ "^" cle ":[[:space:]]*$" { dedans = 1; next }
    dedans && /^[^[:space:]#]/    { dedans = 0 }
    dedans && /^[[:space:]]*-[[:space:]]/ {
      sub(/^[[:space:]]*-[[:space:]]*/, ""); sub(/[[:space:]]*#.*$/, "")
      if (length($0)) print
    }
  ' "$1"
}

# --------------------------------------------------------------------------

printf 'banc de clia res — USE-003\n'
printf 'source : %s\nprojet : %s\n' "$SOURCE" "$PROJET"

titre 'clia init pose la carte du dépôt'

CARTE="$PROJET/.dev/clia.yaml"
vrai ".dev/clia.yaml est posé"                test -f "$CARTE"
rc  "il déclare un namespace"                 0 grep -q '^namespace: ' "$CARTE"
rc  "à compléter, faute de pouvoir le déduire" 0 grep -q '^namespace: <publisher>/projet$' "$CARTE"
rc  "il déclare une version"                  0 grep -q '^version: ' "$CARTE"
rc  "une maturité"                            0 grep -q '^maturity: ' "$CARTE"
rc  "et une génération"                       0 grep -q '^generation: ' "$CARTE"

titre 'res ls — le dépôt courant, et le remote'

rc  "ls répond sur un dépôt sans ressource"   0 clia res ls
dit "il le dit"                               'aucune ressource'
dit "et renvoie au remote"                    'clia res ls --remote'

rc  "ls --remote répond"                      0 clia res ls --remote
dit "l'en-tête porte les colonnes de USE-003" 'PREFIXE.*NOM.*INSTANCES.*NAMESPACE'
dit "les ressources du source sont listées"   'INT *intention'
dit "avec le namespace du source"             'noumanity\.com/clia'
dit "et données pour disponibles"             'disponible'

titre 'res ls — le nombre d'\''instances est celui du dépôt courant'

# Le dépôt neuf porte une intention et une session, posées par init. Le
# comptage suit l'emplacement que chaque définition déclare.
dit "l'intention du dépôt est comptée"        'INT *intention *1'
dit "la session aussi"                        'SES *session *1'
dit "et le skill, qu'\''il n'\''a pas, est à zéro" 'SKL *skill *0'

titre 'res new'

rc  "new aboutit"                             0 clia res new DEC decision "Une décision tranchée et sa raison."
dit "il nomme ce qui a été créé"              '_ressources/decision'
dit "et ce qui reste à faire"                 'à faire ensuite'
vrai "la définition existe"                   test -f "$PROJET/_ressources/decision/schemas/decision.yaml"

DEF="$PROJET/_ressources/decision/schemas/decision.yaml"
rc  "elle se déclare de type ressource"       0 grep -q '^type: ressource$' "$DEF"
rc  "elle porte le nom demandé"               0 grep -q '^nom: decision$' "$DEF"
rc  "et le préfixe demandé"                   0 grep -q '^prefixe: DEC$' "$DEF"
rc  "la description devient le résumé"        0 grep -q 'Une décision tranchée et sa raison' "$DEF"
rc  "l'\''emplacement est dérivé du nom"       0 grep -q '^emplacement: \.dev/decisions/DEC-<SEQ>-<SLUG>\.md$' "$DEF"
faux "aucun marqueur <NOM> ne subsiste"       grep -q '<NOM>' "$DEF"
faux "l'\''entête du gabarit est retiré"       grep -q 'À copier vers' "$DEF"
vrai "la première ligne est une clé"          bash -c "head -1 '$DEF' | grep -q '^type:'"

# Le méta-type déclare ce qu'une définition doit porter : ce qui est créé
# doit y répondre, sinon la commande produit du non conforme.
META="$RACINE/_ressources/ressource/schemas/ressource.yaml"
manquants=''
while IFS= read -r champ; do
  [[ -n "$champ" ]] || continue
  grep -qE "^${champ}:" "$DEF" || manquants+="$champ "
done < <(liste_yaml "$META" champs-obligatoires)
if [[ -z "$manquants" ]]; then
  ok "elle porte tous les champs obligatoires du méta-type"
else
  echec "elle porte tous les champs obligatoires du méta-type" "manquants : $manquants"
fi

rc  "ls la voit maintenant"                   0 clia res ls
dit "avec son préfixe"                        'DEC *decision'
dit "et le namespace du dépôt"                '<publisher>/projet'
dit "elle est activée"                        'activée'

titre 'res new --category'

rc  "new avec catégorie aboutit"              0 clia res new ART article --category edition
vrai "elle vit sous la catégorie"             test -f "$PROJET/_ressources/edition/article/schemas/article.yaml"
rc  "ls la nomme avec sa catégorie"           0 clia res ls
dit "nom qualifié"                            'ART *edition/article'

titre 'res new — ce qui est refusé'

rc  "un emplacement occupé est refusé"        1 clia res new XXX decision
dit "et rien n'\''est créé"                    "rien n'a été créé"
rc  "un préfixe déjà pris est refusé"         1 clia res new DEC autre-chose
dit "il nomme la ressource qui le porte"      'déjà celui de decision'
rc  "un préfixe en minuscules est refusé"     2 clia res new dec truc
dit "il dit la règle"                         'majuscules'
rc  "un nom avec majuscule est refusé"        2 clia res new TRC Truc
rc  "une catégorie invalide est refusée"      2 clia res new TRC truc --category Edition
rc  "new sans argument est refusé"            2 clia res new
dit "il rappelle l'\''usage"                   'clia res new'
faux "aucune ressource fantôme n'\''a été créée" test -e "$PROJET/_ressources/truc"

titre 'res ls NAMESPACE'

rc  "le namespace du dépôt filtre"            0 clia res ls '<publisher>/projet'
dit "les ressources locales restent"          'DEC *decision'
ne_dit_pas "la colonne namespace est retirée" 'NAMESPACE'
rc  "un namespace inconnu ne rend rien"       0 clia res ls autre.com/inconnu
dit "et il le dit"                            'aucune ressource dans le namespace'
dit "en rappelant celui du dépôt"             '<publisher>/projet'

titre 'res info'

rc  "info sans argument répond"               0 clia res info
dit "il donne le namespace"                   '^namespace *<publisher>/projet$'
dit "la version"                              '^version'
dit "la maturité"                             '^maturité'
dit "et la génération"                        '^génération'

rc  "info sur une ressource locale répond"    0 clia res info decision
dit "il donne le préfixe"                     '^prefixe *DEC$'
dit "l'\''emplacement"                         '^emplacement'
dit "l'\''état"                                '^état *activée$'
dit "le nombre d'\''instances"                 '^instances'
dit "et le résumé en clair"                   'Une décision tranchée'

rc  "info sur une ressource du remote répond" 0 clia res info intention
dit "elle est donnée pour disponible"         '^état *disponible$'
dit "avec le namespace du source"             'noumanity\.com/clia'

rc  "info sur une inconnue est refusé"        1 clia res info fantome
dit "il renvoie aux deux listes"              'clia res ls --remote'

titre 'Les alias de USE-003'

rc  "clia ressource ls répond"                0 clia ressource ls
dit "comme clia res ls"                       'DEC *decision'
rc  "clia resource ls répond aussi"           0 clia resource ls
rc  "clia res --help répond"                  0 clia res --help
dit "il nomme les trois noms"                 'clia ressource et clia resource'
rc  "un verbe inconnu est refusé"             2 clia res bidon
dit "et il nomme les verbes connus"           'ls, info, new'
rc  "une option inconnue de ls est refusée"   2 clia res ls --bidon

titre 'La commande reste découvrable une fois'

rc  "clia --help répond"                      0 clia --help
dit "res y figure"                            '^  res '
ne_dit_pas "et aucun alias ne la double"      '^  ressource '
ne_dit_pas "aucune commande masquée"          'masquée'

titre 'Le dépôt source réel n'\''est pas modifié'

vrai "aucun changement dans le dépôt réel"    test "$(cd "$RACINE" && git status --porcelain 2>/dev/null | sort)" = "$EMPREINTE_SOURCE"

# --------------------------------------------------------------------------

bilan
