#!/usr/bin/env bash
# _scripts/tests/test_init.sh — banc de clia init, et des ressources qu'il pose.
#
# Deux objets : les définitions de type ressource et intention, dont la
# cohérence est vérifiée contre le méta-type qu'elles déclarent suivre ; et la
# commande init, éprouvée sur USE-002 et sur les états de dépôt qui ne sont
# pas le cas nominal.
#
# Lancement :  bash _scripts/tests/test_init.sh

set -uo pipefail

RACINE=$(cd -P "$(dirname "${BASH_SOURCE[0]}")/../.." >/dev/null 2>&1 && pwd)

# shellcheck source=banc.sh
. "$(dirname "${BASH_SOURCE[0]}")/banc.sh"

BAC=$(mktemp -d) || exit 1
trap 'rm -rf "$BAC"' EXIT

SOURCE="$BAC/source"
mkdir -p "$SOURCE"
cp -r "$RACINE/_scripts" "$RACINE/_ressources" "$SOURCE/"
CLIA="$SOURCE/_scripts/bin/clia"

EMPREINTE_SOURCE=$(cd "$RACINE" && git status --porcelain 2>/dev/null | sort)

# Les valeurs scalaires d'une liste YAML à plat, sous une clé de premier
# niveau. Suffit aux définitions de type, qui n'imbriquent pas.
liste_yaml() {
  awk -v cle="$2" '
    $0 ~ "^" cle ":[[:space:]]*$" { dedans = 1; next }
    dedans && /^[^[:space:]#]/    { dedans = 0 }
    dedans && /^[[:space:]]*-[[:space:]]/ {
      sub(/^[[:space:]]*-[[:space:]]*/, "")
      sub(/[[:space:]]*#.*$/, "")
      if (length($0)) print
    }
  ' "$1"
}

champ_yaml() {
  grep -m1 -E "^${2}:[[:space:]]" "$1" 2>/dev/null | sed -E "s/^${2}:[[:space:]]*//; s/^\"//; s/\"$//"
}

# --------------------------------------------------------------------------

printf 'banc de clia init — USE-002, et les ressources ressource et intention\n'
printf 'bac : %s\n' "$BAC"

titre 'Tâche 3 — la ressource « ressource »'

META="$RACINE/_ressources/ressource/schemas/ressource.yaml"
vrai "la définition existe"                   test -f "$META"
vrai "elle se déclare de type ressource"      test "$(champ_yaml "$META" type)" = 'ressource'
vrai "elle se nomme ressource"                test "$(champ_yaml "$META" nom)" = 'ressource'
vrai "elle déclare un gabarit"                test -n "$(champ_yaml "$META" gabarit)"
vrai "le gabarit déclaré existe"              test -f "$RACINE/_ressources/ressource/$(champ_yaml "$META" gabarit)"
vrai "elle déclare des champs obligatoires"   test -n "$(liste_yaml "$META" champs-obligatoires)"

# Le méta-type se prend lui-même pour objet : il doit satisfaire le contrat
# qu'il énonce. Une définition qui n'obéit pas à sa propre règle est un
# défaut, pas une exception.
titre 'Les définitions obéissent au contrat qu'\''elles déclarent'

for def in "$RACINE"/_ressources/*/schemas/*.yaml; do
  nom=$(basename "$def" .yaml)
  manquants=''
  while IFS= read -r champ; do
    [[ -n "$champ" ]] || continue
    grep -qE "^${champ}:" "$def" || manquants+="$champ "
  done < <(liste_yaml "$META" champs-obligatoires)
  if [[ -z "$manquants" ]]; then
    ok "$nom porte tous les champs obligatoires"
  else
    echec "$nom porte tous les champs obligatoires" "manquants : $manquants"
  fi
done

titre 'Tâche 3 — la ressource « intention »'

INT="$RACINE/_ressources/intention/schemas/intention.yaml"
vrai "la définition existe"                   test -f "$INT"
vrai "son préfixe est INT"                    test "$(champ_yaml "$INT" prefixe)" = 'INT'
vrai "elle est en édition humaine"            test "$(champ_yaml "$INT" edition)" = 'humain'
vrai "son emplacement est conventionnel"      test "$(champ_yaml "$INT" emplacement)" = '.dev/intentions/INT-<SEQ>-<SLUG>.md'
vrai "le gabarit déclaré existe"              test -f "$RACINE/_ressources/intention/$(champ_yaml "$INT" gabarit)"
GABARIT="$RACINE/_ressources/intention/$(champ_yaml "$INT" gabarit)"
rc  "le gabarit porte le frontmatter du type" 0 grep -q '^type: intention$' "$GABARIT"
rc  "il porte le critère de satisfaction"     0 grep -q '^critere-de-satisfaction:' "$GABARIT"
rc  "il porte les sections déclarées"         0 grep -q '^## Critère de satisfaction$' "$GABARIT"

titre 'Tâche 4 — USE-002, cas d'\''usage 1 : nouveau dépôt'

NEUF="$BAC/neuf"
rc  "init aboutit"                            0 "$CLIA" init "$NEUF"
vrai "le répertoire est créé"                 test -d "$NEUF"
vrai "c'est un dépôt git"                     test -d "$NEUF/.git"
vrai "CLAUDE.md est posé"                     test -f "$NEUF/CLAUDE.md"
vrai "INTENTION.md est posé"                  test -e "$NEUF/INTENTION.md"
vrai ".dev/session.md est posé"               test -f "$NEUF/.dev/session.md"

vrai "INTENTION.md est un lien symbolique"    test -L "$NEUF/INTENTION.md"
vrai "il pointe sur l'instance INT-001"       test "$(readlink "$NEUF/INTENTION.md")" = '.dev/intentions/INT-001-intention-ultime.md'
vrai "l'instance existe"                      test -f "$NEUF/.dev/intentions/INT-001-intention-ultime.md"
rc  "elle porte le frontmatter du type"       0 grep -q '^type: intention$' "$NEUF/INTENTION.md"
rc  "sa portée est ultime"                    0 grep -q '^portee: ultime$' "$NEUF/INTENTION.md"
rc  "le titre est celui du dépôt"             0 grep -q '^titre: "neuf"$' "$NEUF/INTENTION.md"
faux "aucun marqueur de gabarit ne subsiste"  grep -q '{{' "$NEUF/INTENTION.md"
rc  "la session porte ses sections"           0 grep -q '^## INTENTION$' "$NEUF/.dev/session.md"

rc  "le harnais est reconnu par harness-ia"   0 bash -c 'cd "$1" && "$2" harness-ia status' banc "$NEUF" "$CLIA"
dit "les deux zones sont présentes"           '^zone skills     présente'

titre 'USE-002, cas d'\''usage 2 : dépôt git existant'

# Le cas est explicitement non supporté. Le refus doit venir avant toute
# écriture : un refus après coup ne serait pas un refus.
AVANT=$(cd "$NEUF" && find . -not -path './.git/*' -not -name '.git' | sort)
EMPREINTE=$(cat "$NEUF/CLAUDE.md" "$NEUF/.dev/session.md" "$NEUF/.dev/intentions/INT-001-intention-ultime.md")
rc  "relancer init est refusé"                1 "$CLIA" init "$NEUF"
dit "il dit que le cas n'est pas supporté"    "n'est pas supporté"
dit "il dit que rien n'a été modifié"         "rien n'a été modifié"
dit "il oriente vers harness-ia"              'clia harness-ia init'
vrai "aucun fichier n'a été ajouté ni retiré" test "$(cd "$NEUF" && find . -not -path './.git/*' -not -name '.git' | sort)" = "$AVANT"
vrai "aucun contenu n'a changé"               test "$(cat "$NEUF/CLAUDE.md" "$NEUF/.dev/session.md" "$NEUF/.dev/intentions/INT-001-intention-ultime.md")" = "$EMPREINTE"

VIERGE="$BAC/vierge-git"
mkdir -p "$VIERGE"
git -C "$VIERGE" init -q
rc  "un dépôt git vide est refusé aussi"      1 "$CLIA" init "$VIERGE"
faux "et rien n'y a été posé"                 test -e "$VIERGE/CLAUDE.md"

SOUS="$NEUF/sous-repertoire"
mkdir -p "$SOUS"
rc  "un sous-répertoire d'un dépôt est refusé" 1 "$CLIA" init "$SOUS"
dit "et le dépôt englobant est nommé"         "$NEUF"

titre 'Un répertoire non git, avec un INTENTION.md à lui'

EXISTANT="$BAC/existant"
mkdir -p "$EXISTANT"
printf '# Mon intention\n\nCe dépôt sert à quelque chose de précis.\n' > "$EXISTANT/INTENTION.md"
CONTENU=$(cat "$EXISTANT/INTENTION.md")

rc  "init aboutit"                            0 "$CLIA" init "$EXISTANT"
dit "le déplacement est annoncé"              'déplacé : INTENTION\.md'
vrai "INTENTION.md est devenu un lien"        test -L "$EXISTANT/INTENTION.md"
vrai "le contenu d'origine est intact"        test "$(cat "$EXISTANT/INTENTION.md")" = "$CONTENU"
vrai "il vit à l'emplacement du type"         test -f "$EXISTANT/.dev/intentions/INT-001-intention-ultime.md"
dit "et il est dit ce qui lui manque"         'frontmatter'

titre 'Un INTENTION.md régulier et une instance déjà présents'

CONFLIT="$BAC/conflit"
mkdir -p "$CONFLIT/.dev/intentions"
printf 'à la racine\n' > "$CONFLIT/INTENTION.md"
printf 'dans .dev\n'   > "$CONFLIT/.dev/intentions/INT-001-intention-ultime.md"

rc  "init aboutit sans trancher"              0 "$CLIA" init "$CONFLIT"
dit "il dit que les deux existent"            'existent tous deux'
vrai "le fichier de racine est intact"        test "$(cat "$CONFLIT/INTENTION.md")" = 'à la racine'
vrai "l'instance est intacte"                 test "$(cat "$CONFLIT/.dev/intentions/INT-001-intention-ultime.md")" = 'dans .dev'
faux "aucun lien n'a été posé"                test -L "$CONFLIT/INTENTION.md"

titre 'Un répertoire existant qui n'\''est pas un dépôt git'

NONGIT="$BAC/nongit"
mkdir -p "$NONGIT"
rc  "init l'initialise"                       0 "$CLIA" init "$NONGIT"
dit "et le dit"                               'dépôt git initialisé'
vrai "c'est un dépôt git"                     test -d "$NONGIT/.git"

titre 'Sans argument, le répertoire courant'

ICI="$BAC/ici"
mkdir -p "$ICI"
rc  "init sans argument aboutit"              0 bash -c 'cd "$1" && "$2" init' banc "$ICI" "$CLIA"
vrai "le répertoire courant est instrumenté"  test -f "$ICI/CLAUDE.md"
vrai "et c'est devenu un dépôt git"           test -d "$ICI/.git"
rc  "relancé au même endroit, il refuse"      1 bash -c 'cd "$1" && "$2" init' banc "$ICI" "$CLIA"

titre 'La commande lit la définition, elle ne code pas le chemin en dur'

# Le gabarit d'instance est celui que le type déclare : le changer dans la
# définition change ce que init pose. C'est ce qui rend la ressource
# instrumentée plutôt que décorative.
AUTRE="$SOURCE/_ressources/intention/templates/autre.template.md"
printf -- '---\ntype: intention\n---\n\n# gabarit de rechange {{titre}}\n' > "$AUTRE"
sed -i 's|^gabarit: .*|gabarit: templates/autre.template.md|' "$SOURCE/_ressources/intention/schemas/intention.yaml"

RECHANGE="$BAC/rechange"
rc  "init aboutit"                            0 "$CLIA" init "$RECHANGE"
rc  "le gabarit déclaré a été employé"        0 grep -q 'gabarit de rechange' "$RECHANGE/INTENTION.md"

# Une définition sans gabarit doit faire refuser, non poser un fichier vide.
sed -i '/^gabarit:/d' "$SOURCE/_ressources/intention/schemas/intention.yaml"
rc  "sans gabarit déclaré, init refuse"       1 "$CLIA" init "$BAC/sans-gabarit"
dit "et il dit où le déclarer"                'schemas/intention\.yaml'

titre 'Demandes mal formées'

rc  "init --help répond"                      0 "$CLIA" init --help
dit "il nomme ce que la commande pose"        'INTENTION\.md'
rc  "deux chemins sont refusés"               2 "$CLIA" init /tmp/a /tmp/b
dit "et il rappelle l'usage"                  'clia init \[PATH\]'

titre 'La garde du mode --activate couvre init'

# En activation, seul le dépôt source est exploitable : init ne doit pas
# créer un dépôt ailleurs, et doit refuser avant de créer quoi que ce soit.
INTERDIT="$BAC/interdit"
rc  "init hors du dépôt source est refusé"    1 env CLIA_MODE=activate CLIA_HOME="$SOURCE" "$CLIA" init "$INTERDIT"
dit "et il dit pourquoi"                      'hors périmètre'
faux "rien n'a été créé"                      test -e "$INTERDIT"

titre 'Le dépôt source réel n'\''est pas modifié'

vrai "aucun changement dans le dépôt réel"    test "$(cd "$RACINE" && git status --porcelain 2>/dev/null | sort)" = "$EMPREINTE_SOURCE"

# --------------------------------------------------------------------------

bilan
