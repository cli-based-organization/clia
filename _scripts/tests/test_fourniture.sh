#!/usr/bin/env bash
# _scripts/tests/test_fourniture.sh — ce qu'une ressource apporte.
#
# Éprouve SES-001 tâche 15 : les fonctionnalités, les skills, les scripts, et
# le verbe « provide » que toute ressource porte.
#
# La ressource éprouvée est fabriquée dans le bac, et son préfixe ne peut
# heurter aucune de celles que ce dépôt porte : un banc qui passerait ou
# échouerait selon ce qui est installé ici ne mesurerait plus rien.
#
# Trois propriétés que le banc mesure, et qui n'iraient pas de soi :
#
#   l'état d'une fonctionnalité se lit dans le harnais, non dans un
#   inventaire. Poser puis retirer rend le fichier à ce qu'il était ;
#
#   hors des marqueurs de zone, clia ne touche à rien ;
#
#   un verbe désactivé est refusé par le point d'entrée, avant que la
#   commande de la ressource ne soit lancée.

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

# Un dépôt portant une ressource qui fournit les trois natures.
depot() {
  local d="$BAC/$1" r
  mkdir -p "$d"
  git -C "$d" init -q
  printf 'namespace: exemple.test/%s\nversion: 1.0.0\n' "$1" > "$d/clia.yaml"
  cat > "$d/CLAUDE.md" <<'MD'
# Conventions

Ce paragraphe est à moi, et clia n'y touche pas.
MD

  r="$d/_ressources/fourni"
  mkdir -p "$r/_scripts" "$r/features" "$r/skills/interroger"
  cat > "$r/fourni.yaml" <<'YAML'
nom: fourni
titre: Fourni
prefixe: FRN
version: 0.1.0

description: "Une ressource de banc, qui fournit les trois natures."
YAML

  cat > "$r/_scripts/frn.sh" <<'SH'
#!/usr/bin/env bash
# Description: Une ressource de banc.
# Périmètre: aucun
# Signature: frn dis MOT
# Signature: frn compte
set -euo pipefail
printf '%s\n' "${2:-rien}"
SH

  cat > "$r/features/journal-continu.md" <<'MD'
---
nom: journal-continu
description: Chaque tâche laisse une trace.
---

Toute tâche laisse une trace dans le journal, avant d'être close.

C'est ce qui rend le travail relisible.
MD

  cat > "$r/features/deuxieme.md" <<'MD'
---
nom: deuxieme
description: Une deuxième, pour éprouver la cohabitation.
---

Le corps de la deuxième fonctionnalité.
MD

  cat > "$r/skills/interroger/SKILL.md" <<'MD'
---
name: interroger
description: À employer quand un énoncé est incomplet.
---

Poser la question, puis poursuivre ce qui n'en dépend pas.
MD
  printf 'une reference\n' > "$r/skills/interroger/reference.md"

  cat > "$r/skills/court.md" <<'MD'
---
name: court
description: Un skill qui tient en une page.
---

Le corps du skill court.
MD

  printf '%s\n' "$d"
}

zone() { sed -n "/CLIA:$2:BEGIN/,/CLIA:$2:END/p" "$1/CLAUDE.md"; }

# ==========================================================================
titre 'Les trois commandes sont decouvertes, et documentees'
# ==========================================================================

rc 'clia --help les liste' 0 "$CLIA" --help
dit 'feature y figure' '^  feature  *Les fonctionnalités'
dit 'skill aussi' '^  skill  *Les skills'
dit 'et script aussi' '^  script  *Les scripts'
dit 'sous les commandes du noyau' '^Commandes :$'

for cmd in feature skill script; do
  rc "clia $cmd --help" 0 "$CLIA" "$cmd" --help
  dit "ses trois signatures y sont" "clia $cmd ls"
  RESTE=$("$CLIA" "$cmd" --help 2>/dev/null | lignes_de_prose)
  vrai "l aide de $cmd ne porte aucune prose" test -z "$RESTE"
  [[ -n "$RESTE" ]] && printf '         ligne fautive : %s\n' "$RESTE"

  rc "clia $cmd --man" 0 "$CLIA" "$cmd" --man
  dit "la page porte son nom" "^CLIA-$(printf '%s' "$cmd" | tr '[:lower:]' '[:upper:]')(1)"
  for section in NOM SYNOPSIS DESCRIPTION SOUS-COMMANDES SORTIE \
                 'CODE DE RETOUR' FICHIERS EXEMPLES 'VOIR AUSSI'; do
    dit "la section $section y est" "^$section\$"
  done
  LONGUES=$("$CLIA" "$cmd" --man 2>/dev/null | lignes_trop_longues)
  vrai "aucune ligne du manuel de $cmd ne depasse 80 colonnes" test -z "$LONGUES"
  [[ -n "$LONGUES" ]] && printf '         ligne fautive : %s\n' "$LONGUES"
done

# ==========================================================================
titre 'Ce qu une ressource apporte : clia RESSOURCE provide'
# ==========================================================================

D=$(depot fourniture)

rc_dans 'le verbe generique repond' 0 "$D" frn provide
dit 'l en-tete nomme les colonnes' '^FOURNITURE *NOM *ETAT *DESCRIPTION$'
dit 'les fonctionnalites y sont' 'fonctionnalité *journal-continu *inactive'
dit 'les skills aussi' 'skill *interroger *inactif'
dit 'et les scripts aussi' 'script *dis *actif *frn dis MOT'
dit 'la ressource est nommee avec son prefixe' 'ressource fourni (FRN)'

rc_dans 'provide ls dit la meme chose' 0 "$D" frn provide ls
dit 'les memes lignes' 'fonctionnalité *journal-continu'
rc_dans 'provide n accepte pas autre chose' 2 "$D" frn provide bidule

rc_dans 'il figure dans l aide de la ressource' 0 "$D" frn --help
dit 'a cote de deactivate' 'clia frn provide'
dit 'et de deactivate' 'clia frn deactivate'

# ==========================================================================
titre 'Les fonctionnalites entrent dans le harnais'
# ==========================================================================

rc_dans 'clia feature ls' 0 "$D" feature ls
dit 'l en-tete nomme les colonnes' '^RESSOURCE *FONCTIONNALITE *ETAT *DESCRIPTION$'
dit 'la fonctionnalite y figure, inactive' 'fourni *journal-continu *inactive'
dit 'avec sa description' 'Chaque tâche laisse une trace'

AVANT=$(cat "$D/CLAUDE.md")
rc_dans 'clia feature activate est satisfaite' 0 "$D" feature activate journal-continu
dit 'et clia dit ou elle a ete posee' 'posée dans CLAUDE.md'
dit 'et que la zone a ete creee' 'zone gérée des fonctionnalités a été créée'

vrai 'le corps est dans le harnais' \
  grep -q 'Toute tâche laisse une trace dans le journal' "$D/CLAUDE.md"
vrai 'sous un titre que clia ecrit' \
  grep -q '^## Fonctionnalité : journal-continu$' "$D/CLAUDE.md"
vrai 'le frontmatter, lui, n y est pas' \
  test "$(grep -c '^description: Chaque' "$D/CLAUDE.md")" -eq 0
vrai 'le texte de l humain est intact' \
  grep -q "Ce paragraphe est à moi" "$D/CLAUDE.md"

SORTIE=$(zone "$D" FEATURES)
dit 'le bloc est dans la zone geree' 'BEGIN feature journal-continu'
dit 'et refermé' 'END feature journal-continu'

SORTIE=$(sortie "$D" feature ls)
dit 'ls la dit active' 'fourni *journal-continu *active'

rc_dans 'la reposer ne fait rien' 0 "$D" feature activate journal-continu
dit 'et clia le dit' 'déjà posée'

rc_dans 'une deuxieme cohabite' 0 "$D" feature activate deuxieme
vrai 'les deux corps sont la' \
  test "$(grep -c '^## Fonctionnalité : ' "$D/CLAUDE.md")" -eq 2
vrai 'et la zone n a ete creee qu une fois' \
  test "$(grep -c 'CLIA:FEATURES:BEGIN' "$D/CLAUDE.md")" -eq 1

rc_dans 'clia feature deactivate est satisfaite' 0 "$D" feature deactivate deuxieme
vrai 'son corps est parti' \
  test "$(grep -c 'Le corps de la deuxième' "$D/CLAUDE.md")" -eq 0
vrai 'l autre est restee' grep -q '^## Fonctionnalité : journal-continu$' "$D/CLAUDE.md"
vrai 'et son fichier reste sous la ressource' \
  test -f "$D/_ressources/fourni/features/deuxieme.md"

rc_dans 'la retirer deux fois ne fait rien' 0 "$D" feature deactivate deuxieme
dit 'et clia le dit' "n'est pas posée"

# Poser puis retirer rend le fichier à ce qu'il était, aux marqueurs près.
rc_dans 'retirer la derniere' 0 "$D" feature deactivate journal-continu
vrai 'le texte de l humain est toujours intact' \
  grep -q "Ce paragraphe est à moi" "$D/CLAUDE.md"
vrai 'et il ne reste aucun corps de fonctionnalite' \
  test "$(grep -c '^## Fonctionnalité : ' "$D/CLAUDE.md")" -eq 0

# Poser puis retirer rend le harnais à ce qu'il était, aux marqueurs de zone
# près. C'est la forme mesurable de « hors des marqueurs, clia ne touche à
# rien » : un banc qui ne vérifierait qu'un paragraphe laisserait passer une
# ligne vide ajoutée à chaque geste.
APRES=$(grep -v 'CLIA:FEATURES:' "$D/CLAUDE.md")
vrai 'le harnais est rendu a ce qu il etait' test "$APRES" = "$AVANT"
[[ "$APRES" != "$AVANT" ]] && diff <(printf '%s\n' "$AVANT") <(printf '%s\n' "$APRES")

rc_dans 'une fonctionnalite inconnue est refusee' 1 "$D" feature activate inexistante
dit 'et clia renvoie a la liste' 'clia feature ls'
rc_dans 'activate sans nom est mal forme' 2 "$D" feature activate
rc_dans 'ls ne prend pas d argument' 2 "$D" feature ls trop
rc_dans 'un verbe inconnu est mal forme' 2 "$D" feature bidule

# ==========================================================================
titre 'Les skills entrent sous .claude, et leur directive dans le harnais'
# ==========================================================================

rc_dans 'clia skill ls' 0 "$D" skill ls
dit 'l en-tete nomme les colonnes' '^RESSOURCE *SKILL *ETAT *DESCRIPTION$'
dit 'le skill en repertoire y figure' 'fourni *interroger *inactif'
dit 'le skill en fichier aussi' 'fourni *court *inactif'
dit 'avec sa description' "quand un énoncé est incomplet"

rc_dans 'clia skill activate est satisfaite' 0 "$D" skill activate interroger
dit 'et clia dit ou la procedure est posee' '.claude/skills/interroger'

vrai 'la procedure est sous .claude' test -f "$D/.claude/skills/interroger/SKILL.md"
vrai 'avec ce que le skill emporte' test -f "$D/.claude/skills/interroger/reference.md"
vrai 'la directive est dans le harnais' \
  grep -q '^## Skill : interroger$' "$D/CLAUDE.md"
vrai 'et elle dit quand employer le skill' \
  grep -q "quand un énoncé est incomplet" "$D/CLAUDE.md"

SORTIE=$(zone "$D" SKILLS)
dit 'la directive est dans la zone des skills' 'BEGIN skill interroger'
SORTIE=$(zone "$D" FEATURES)
ne_dit_pas 'et non dans celle des fonctionnalites' 'BEGIN skill interroger'

SORTIE=$(sortie "$D" skill ls)
dit 'ls le dit actif' 'fourni *interroger *actif'

rc_dans 'un skill en fichier seul devient un repertoire' 0 "$D" skill activate court
vrai 'avec SKILL.md dedans' test -f "$D/.claude/skills/court/SKILL.md"

rc_dans 'un emplacement occupe est refuse' 1 "$D" skill activate interroger
dit 'et clia dit qu il n ecrase pas' "n'écrase pas ce qu'il n'a pas posé"

rc_dans 'clia skill deactivate est satisfaite' 0 "$D" skill deactivate court
vrai 'la copie est effacee' test ! -e "$D/.claude/skills/court"
vrai 'la directive est otee' test "$(grep -c '^## Skill : court$' "$D/CLAUDE.md")" -eq 0
vrai 'et le skill reste sous sa ressource' \
  test -f "$D/_ressources/fourni/skills/court.md"

# Une copie modifiée porte un travail que clia ne sait pas rendre.
printf 'une note ajoutee sur place\n' >> "$D/.claude/skills/interroger/SKILL.md"
rc_dans 'une copie modifiee n est pas effacee' 1 "$D" skill deactivate interroger
dit 'et clia dit pourquoi' 'diffère du skill dont il vient'
vrai 'elle est toujours la' test -f "$D/.claude/skills/interroger/SKILL.md"

rm -rf "$D/.claude/skills/interroger"
rc_dans 'sans copie, la directive seule se retire' 0 "$D" skill deactivate interroger
vrai 'et la directive est partie' test "$(grep -c '^## Skill : interroger$' "$D/CLAUDE.md")" -eq 0

rc_dans 'un skill inconnu est refuse' 1 "$D" skill activate inexistant
dit 'et clia renvoie a la liste' 'clia skill ls'
rc_dans 'skill ls ne prend pas d argument' 2 "$D" skill ls trop

# ==========================================================================
titre 'Les scripts sont les verbes des commandes de ressources'
# ==========================================================================

rc_dans 'clia script ls' 0 "$D" script ls
dit 'l en-tete nomme les colonnes' '^RESSOURCE *SCRIPT *ETAT *SIGNATURE$'
dit 'les verbes de la ressource y sont' 'fourni *dis *actif *frn dis MOT'
dit 'et le deuxieme aussi' 'fourni *compte *actif'
dit 'ceux des ressources du CLI aussi' 'ressource *release *actif'

rc_dans 'le verbe repond' 0 "$D" frn dis bonjour
dit 'et c est bien lui qui a repondu' '^bonjour$'

rc_dans 'clia script deactivate est satisfaite' 0 "$D" script deactivate dis FRN
dit 'et clia dit ce qui est desormais refuse' 'clia frn dis'
vrai 'la carte l inscrit' grep -q '  - script: FRN/dis' "$D/clia.yaml"
vrai 'et rien n est efface' test -f "$D/_ressources/fourni/_scripts/frn.sh"

SORTIE=$(sortie "$D" script ls)
dit 'ls le dit desactive' 'fourni *dis *désactivé'
dit 'et l autre reste actif' 'fourni *compte *actif'

rc_dans 'le verbe desactive est refuse' 1 "$D" frn dis bonjour
dit 'par le point d entree, avant la commande' 'est désactivé dans ce dépôt'
dit 'qui dit comment le rendre' 'clia script activate dis FRN'
ne_dit_pas 'et la commande n a pas repondu' '^bonjour$'

rc_dans 'l autre verbe repond toujours' 0 "$D" frn compte

rc_dans 'la desactiver deux fois ne fait rien' 0 "$D" script deactivate dis FRN
dit 'et clia le dit' 'est déjà désactivé'

rc_dans 'clia script activate le rend' 0 "$D" script activate dis FRN
vrai 'la carte ne l inscrit plus' \
  test "$(grep -c '  - script: FRN/dis' "$D/clia.yaml")" -eq 0
rc_dans 'et le verbe repond de nouveau' 0 "$D" frn dis bonjour
dit 'comme avant' '^bonjour$'

rc_dans 'l activer deux fois ne fait rien' 0 "$D" script activate dis FRN
dit 'et clia le dit' 'est déjà actif'

# « ls » est offert par presque toutes les ressources : la désignation
# doit être levée par le préfixe.
rc_dans 'une designation ambigue est refusee' 1 "$D" script deactivate ls
dit 'et clia dit comment la lever' 'nommez la ressource'
rc_dans 'le prefixe la leve' 0 "$D" script deactivate ls RES
rc_dans 'et le verbe de cette ressource-la est refuse' 1 "$D" res ls
rc_dans 'alors que celui d une autre repond' 0 "$D" hrn ls
dans "$D" script activate ls RES >/dev/null 2>&1

rc_dans 'un script inconnu est refuse' 1 "$D" script deactivate inexistant
dit 'et clia renvoie a la liste' 'clia script ls'
rc_dans 'script ls ne prend pas d argument' 2 "$D" script ls trop

# ==========================================================================
titre 'Le depot reel n a pas bouge'
# ==========================================================================

vrai 'son etat de travail est le meme qu au depart' \
  test "$(git -C "$RACINE" status --porcelain | sort)" = "$REEL_ETAT"

bilan
