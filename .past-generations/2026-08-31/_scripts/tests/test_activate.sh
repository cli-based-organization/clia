#!/usr/bin/env bash
# _scripts/tests/test_activate.sh — banc de USE-005, activer ce qu'un remote offre.
#
# Un dépôt source qui fait office de remote, augmenté de fixtures, et un dépôt
# de travail vierge. Ce qui est éprouvé : ce qu'une liste montre selon qu'on
# demande --remote ou non, et ce que le verbe activate fait entrer dans le
# dépôt. Le dépôt réel n'est jamais écrit.
#
# Lancement :  bash _scripts/tests/test_activate.sh

set -uo pipefail

RACINE=$(cd -P "$(dirname "${BASH_SOURCE[0]}")/../.." >/dev/null 2>&1 && pwd)

# shellcheck source=banc.sh
. "$(dirname "${BASH_SOURCE[0]}")/banc.sh"

BAC=$(mktemp -d) || exit 1
trap 'rm -rf "$BAC"' EXIT

SOURCE="$BAC/source"
mkdir -p "$SOURCE/.dev"
cp -r "$RACINE/_scripts" "$RACINE/_ressources" "$SOURCE/"
cp "$RACINE/.dev/clia.yaml" "$SOURCE/.dev/clia.yaml"
NAMESPACE=$(grep -m1 '^namespace:' "$SOURCE/.dev/clia.yaml" | sed 's/^namespace:[[:space:]]*//')

# Le remote offre un skill et une fonctionnalité de plus, sous la ressource
# session, pour éprouver ce qu'une ressource emporte avec elle.
mkdir -p "$SOURCE/_ressources/session/skills"
cat > "$SOURCE/_ressources/session/skills/tenir-session.md" <<'EOF'
---
name: tenir-session
description: Skill de fixture, offert par la ressource session.
---

# tenir-session

Procédure de fixture.
EOF

CLIA="$SOURCE/_scripts/bin/clia"
EMPREINTE_SOURCE=$(cd "$RACINE" && git status --porcelain 2>/dev/null | sort)

PROJET="$BAC/projet"
"$CLIA" init "$PROJET" >/dev/null 2>&1 || { printf 'banc: clia init a échoué\n' >&2; exit 1; }
clia() { ( cd "$PROJET" && "$CLIA" "$@" ); }

# --------------------------------------------------------------------------

printf 'banc de USE-005 — activer ce qu%s remote offre\n' "'un"
printf 'source : %s\nprojet : %s\n' "$SOURCE" "$PROJET"

titre 'Sans --remote, une liste ne montre que le dépôt courant'

rc  "res ls ne montre rien"                   0 clia res ls
dit "et renvoie au remote"                    'clia res ls --remote'
rc  "skill ls ne montre rien"                 0 clia skill ls
dit "il le dit"                               '(aucun)'
dit "et renvoie au remote"                    'clia skill ls --remote'
rc  "feature ls ne montre rien"               0 clia feature ls
dit "il le dit"                               '(aucune)'
dit "et renvoie au remote"                    'clia feature ls --remote'

titre 'Avec --remote, ce que le remote offre apparaît'

rc  "res ls --remote répond"                  0 clia res ls --remote
dit "les ressources du remote sont là"        'INT *intention'
dit "avec le namespace du remote"             "$NAMESPACE"
dit "et données pour disponibles"             'disponible'

rc  "skill ls --remote répond"                0 clia skill ls --remote
dit "le skill de fixture est offert"          'tenir-session'
dit "avec la ressource qui le porte"          'tenir-session *session'
dit "et la provenance du remote"              "$NAMESPACE"

rc  "feature ls --remote répond"              0 clia feature ls --remote
dit "la fonctionnalité session est offerte"   'session'
dit "avec sa provenance"                      "$NAMESPACE"

titre 'Le namespace filtre les remotes'

rc  "un namespace connu passe"                0 clia skill ls "$NAMESPACE"
dit "et montre ce qu'il offre"                'tenir-session'
rc  "un namespace inconnu est refusé"         1 clia skill ls autre.com/inconnu
dit "il le dit"                               'aucun remote pour le namespace'
rc  "idem pour feature"                       1 clia feature ls autre.com/inconnu
rc  "idem pour res"                           0 clia res ls autre.com/inconnu
dit "res, lui, filtre sa propre colonne"      'aucune ressource dans le namespace'

titre 'Un concept ne s'\''active pas sans sa ressource'

rc  "skill activate est refusé"               1 clia skill activate tenir-session
dit "il nomme la ressource manquante"         'la ressource session'
dit "et la commande qui la ferait venir"      'clia res activate session'
faux "rien n'a été créé"                      test -e "$PROJET/_ressources/session"

rc  "feature activate est refusé aussi"       1 clia feature activate session
dit "avec le même conseil"                    'clia res activate session'

titre 'res activate emporte ce que la ressource porte'

rc  "res activate aboutit"                    0 clia res activate session
dit "il nomme ce qui a été repris"            '_ressources/session'
dit "et de quel remote"                       "$NAMESPACE"
dit "et ce qu'elle apporte"                   '1 skill(s) et 1 fonctionnalité(s)'

vrai "la définition est là"                   test -f "$PROJET/_ressources/session/schemas/session.yaml"
vrai "le gabarit aussi"                       test -f "$PROJET/_ressources/session/_features/session.template.md"
vrai "la fonctionnalité aussi"                test -f "$PROJET/_ressources/session/features/session.md"
vrai "et le skill"                            test -f "$PROJET/_ressources/session/skills/tenir-session.md"
vrai "la définition est identique à la source" diff -q "$SOURCE/_ressources/session/schemas/session.yaml" "$PROJET/_ressources/session/schemas/session.yaml"

rc  "res ls la voit maintenant"               0 clia res ls
dit "avec son préfixe"                        'SES *session'
dit "elle est activée"                        'activée'
rc  "skill ls la voit sans --remote"          0 clia skill ls
dit "le skill est devenu local"               'tenir-session .* locale\|tenir-session .*local'
rc  "feature ls aussi"                        0 clia feature ls
dit "la fonctionnalité est locale"            'session .* locale'

titre 'Activer deux fois ne dégrade rien'

AVANT=$(cd "$PROJET" && find _ressources -type f | sort)
rc  "res activate le dit"                     0 clia res activate session
dit "et ne modifie rien"                      "rien n'a été modifié"
rc  "skill activate le dit"                   0 clia skill activate tenir-session
dit "il renvoie vers install"                 'clia skill install tenir-session'
rc  "feature activate le dit"                 0 clia feature activate session
dit "il renvoie vers install"                 'clia feature install session'
vrai "aucun fichier n'a bougé"                test "$(cd "$PROJET" && find _ressources -type f | sort)" = "$AVANT"

titre 'Ce qui est repris s'\''installe comme le reste'

rc  "skill install aboutit"                   0 clia skill install tenir-session
vrai "le skill est posé"                      test -f "$PROJET/.claude/skills/tenir-session/SKILL.md"
rc  "skill ls le donne pour installé"         0 clia skill ls
dit "installé, et local"                      'tenir-session .*installé'
rc  "feature install aboutit"                 0 clia feature install session
rc  "feature ls la donne pour active"         0 clia feature ls
dit "active, et locale"                       'session .*active'

titre 'Ce qu'\''aucun remote n'\''offre'

rc  "skill activate refuse"                   1 clia skill activate fantome
dit "il le dit"                               "aucun remote n'offre le skill"
rc  "feature activate refuse"                 1 clia feature activate fantome
dit "il le dit"                               "aucun remote n'offre la fonctionnalité"
rc  "res activate refuse"                     1 clia res activate fantome
dit "il le dit"                               "aucun remote n'offre la ressource"

titre 'Le namespace nommé à activate'

# Deux formes : « activate NOM » et « activate NAMESPACE NOM ». La seconde
# est celle que USE-006 emploiera pour désigner une extension parmi d'autres.
rc  "un namespace inconnu est refusé"         1 clia res activate autre.com/x intention
dit "il le dit"                               'aucun remote pour le namespace'
rc  "le bon namespace passe"                  0 clia res activate "$NAMESPACE" intention
vrai "la ressource est reprise"               test -f "$PROJET/_ressources/intention/schemas/intention.yaml"
rc  "trop d'arguments est refusé"             2 clia res activate a b c

titre 'Un préfixe déjà pris bloque la reprise'

# Le dépôt se donne une ressource au préfixe RES, celui que porte la
# ressource « ressource » du remote : la reprise doit alors être refusée.
rc  "une ressource locale prend RES"          0 clia res new RES mienne
rc  "reprendre ressource est refusé"          1 clia res activate ressource
dit "il nomme le conflit"                     'déjà celui de mienne'
faux "rien n'a été repris"                    test -e "$PROJET/_ressources/ressource"

titre 'Les alias de USE-005'

rc  "clia skills ls répond"                   0 clia skills ls
rc  "clia skl ls répond"                      0 clia skl ls
rc  "clia features ls répond"                 0 clia features ls
rc  "clia feat ls répond"                     0 clia feat ls
rc  "clia --help les compte une fois"         0 clia --help
dit "skill y figure"                          '^  skill '
ne_dit_pas "skills n'y figure pas"            '^  skills '
ne_dit_pas "feat non plus"                    '^  feat '
ne_dit_pas "et rien n'est masqué"             'masquée'

titre 'Le dépôt réel n'\''est pas modifié'

vrai "aucun changement"                       test "$(cd "$RACINE" && git status --porcelain 2>/dev/null | sort)" = "$EMPREINTE_SOURCE"

# --------------------------------------------------------------------------

bilan
