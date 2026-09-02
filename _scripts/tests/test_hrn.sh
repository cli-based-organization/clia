#!/usr/bin/env bash
# _scripts/tests/test_hrn.sh — les gabarits de harnais, et leur génération.
#
# Éprouve SES-001 tâche 8.
#
# Trois propriétés valent plus que les autres, et sont vérifiées mécaniquement :
#
#   le rendu par défaut est identique aux primitives d'aujourd'hui — c'est
#   ce qui permettra à « clia init » de basculer sur le générateur sans que
#   le contenu posé dans un dépôt change d'un octet ;
#
#   le rendu est déterministe — deux générations rendent le même fichier,
#   sinon « à jour » ne veut rien dire ;
#
#   le levier commande vraiment — une section mise à « non » disparaît, et
#   le reste du fichier ne bouge pas.

set -uo pipefail

RACINE=$(cd -P "$(dirname "${BASH_SOURCE[0]}")/../.." && pwd)
CLIA="$RACINE/_scripts/bin/clia"
GABARITS="$RACINE/_ressources/harness-ia/gabarits"
PRIMITIVES="$RACINE/_ressources/harness-ia/primitives"

# shellcheck source=banc.sh
. "$RACINE/_scripts/tests/banc.sh"

# Une activation héritée poserait une portée, et tous les dépôts du bac
# seraient alors hors de cette portée.
unset CLIA_PORTEE CLIA_INSTALLATION CLIA_WORK_DIR

BAC=$(mktemp -d)
trap 'rm -rf "$BAC"' EXIT

REEL_HEAD=$(git -C "$RACINE" rev-parse HEAD)
REEL_ETAT=$(git -C "$RACINE" status --porcelain | sort)

# --------------------------------------------------------------------------
# Outils
# --------------------------------------------------------------------------

# depot <nom> — un dépôt git jetable, instrumenté, et l'imprime.
depot() {
  local d="$BAC/$1"
  mkdir -p "$d"
  git -C "$d" init -q
  git -C "$d" config user.email 'banc@example.invalid'
  git -C "$d" config user.name 'banc'
  printf 'namespace: exemple.test/%s\nversion: 1.0.0\n' "$1" > "$d/clia.yaml"
  printf '%s\n' "$d"
}

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

sortie() { local d="$1"; shift; ( cd "$d" && "$CLIA" "$@" 2>/dev/null ); }

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

# ==========================================================================
titre 'La ressource porte ses gabarits et leurs schemas'
# ==========================================================================

vrai 'le gabarit du harnais principal est la' test -f "$GABARITS/CLAUDE.md"
vrai 'et son schema aussi' test -f "$GABARITS/CLAUDE.yaml"
vrai 'le gabarit constitutionnel est la' test -f "$GABARITS/CONSTITUTION.md"
vrai 'et son schema aussi' test -f "$GABARITS/CONSTITUTION.yaml"

vrai 'un gabarit porte des marqueurs de section' \
  grep -q '^{{#section ' "$GABARITS/CLAUDE.md"
vrai 'et des champs a substituer' grep -q '{{titre}}' "$GABARITS/CLAUDE.md"

vrai 'un schema declare son livrable' \
  grep -q '^livrable: "CLAUDE.md"$' "$GABARITS/CLAUDE.yaml"
vrai 'il declare des champs' grep -q '^champs:$' "$GABARITS/CLAUDE.yaml"
vrai 'et des sections' grep -q '^sections:$' "$GABARITS/CLAUDE.yaml"

vrai 'le script de la commande vit dans la ressource' \
  test -f "$RACINE/_ressources/harness-ia/_scripts/hrn.sh"

# ==========================================================================
titre 'Une commande deposee par une ressource est decouverte'
# ==========================================================================

rc 'clia --help la liste' 0 "$CLIA" --help
dit 'son nom y figure, avec ce qu elle fait' '^  hrn  *Les harnais IA'
dit 'et sous les ressources, non sous les commandes du noyau' '^Ressources :$'

rc 'ses signatures sont a son propre niveau' 0 "$CLIA" hrn --help
dit 'celle de new' 'clia hrn new HARNAIS'
dit 'et celle de gen' 'clia hrn gen \[HARNAIS\]'

rc 'son aide de niveau repond' 0 "$CLIA" hrn --help
ne_dit_pas 'et elle ne porte pas les signatures des autres commandes' 'clia res ls'

RESTE=$("$CLIA" hrn --help 2>/dev/null | lignes_de_prose)
vrai 'cette aide ne porte aucune prose' test -z "$RESTE"
[[ -n "$RESTE" ]] && printf '         ligne fautive : %s\n' "$RESTE"

rc 'sa description alimente le manuel de clia' 0 "$CLIA" --man
dit 'sous la section COMMANDES' 'Les harnais IA — leurs gabarits'
dit 'et les deux emplacements de fouille y sont dits' '_ressources/\*/_scripts/\*\.sh'

rc 'son manuel repond' 0 "$CLIA" hrn --man
dit 'il porte son nom de page' '^CLIA-HRN(1)'
for section in NOM SYNOPSIS DESCRIPTION SOUS-COMMANDES SORTIE \
               'CODE DE RETOUR' FICHIERS EXEMPLES 'VOIR AUSSI'; do
  dit "la section $section y est" "^$section\$"
done

LONGUES=$("$CLIA" hrn --man 2>/dev/null | lignes_trop_longues)
vrai 'aucune ligne de ce manuel ne depasse 80 colonnes' test -z "$LONGUES"
[[ -n "$LONGUES" ]] && printf '         ligne fautive : %s\n' "$LONGUES"

# Le noyau doit l'emporter : une ressource ajoute, elle ne remplace pas.
COPIE="$BAC/copie"
mkdir -p "$COPIE"
cp -r "$RACINE/_scripts" "$RACINE/_ressources" "$COPIE/"
mkdir -p "$COPIE/_ressources/harness-ia/_scripts"
cat > "$COPIE/_ressources/harness-ia/_scripts/version.sh" <<'FIN'
#!/usr/bin/env bash
# Description: Une commande de ressource qui tente de masquer le noyau.
# Périmètre: aucun
# Signature: version usurpee
set -euo pipefail
printf 'usurpee\n'
FIN
SORTIE=$( ( cd "$RACINE" && "$COPIE/_scripts/bin/clia" version ) 2>&1 )
ne_dit_pas 'une ressource ne peut pas masquer une commande du noyau' '^usurpee$'

# ==========================================================================
titre 'Le rendu par defaut est celui des primitives d aujourd hui'
# ==========================================================================
#
# C'est l'invariant qui permettra a « clia init » de basculer sur le
# generateur sans que le contenu pose dans un depot change d'un octet.

NEUF=$(depot neuf)
rc_dans 'clia hrn new CLAUDE' 0 "$NEUF" hrn new CLAUDE
rc_dans 'clia hrn new CONSTITUTION' 0 "$NEUF" hrn new CONSTITUTION

vrai 'le rendu par defaut de CLAUDE est identique a sa primitive' \
  cmp -s "$NEUF/.dev/harnais-ia/CLAUDE.md" "$PRIMITIVES/CLAUDE.md"
vrai 'celui de CONSTITUTION aussi' \
  cmp -s "$NEUF/.dev/harnais-ia/CONSTITUTION.md" "$PRIMITIVES/CONSTITUTION.md"

vrai 'aucun marqueur de gabarit ne subsiste dans le livrable' \
  test -z "$(grep -F '{{' "$NEUF/.dev/harnais-ia/CLAUDE.md" || true)"

# ==========================================================================
titre 'Ce que new pose, et ou'
# ==========================================================================

vrai 'l instance porte le fichier de donnees' test -f "$NEUF/.dev/harnais-ia/hrn.yaml"
vrai 'le livrable est a l emplacement que la tache nomme' \
  test -f "$NEUF/.dev/harnais-ia/CLAUDE.md"

vrai 'les donnees portent le bloc du harnais' \
  grep -q '^CLAUDE:$' "$NEUF/.dev/harnais-ia/hrn.yaml"
vrai 'avec ses champs' grep -q '^    titre: Conventions pour les agents$' \
  "$NEUF/.dev/harnais-ia/hrn.yaml"
vrai 'et ses sections a leur defaut' \
  grep -q '^    frontiere: oui$' "$NEUF/.dev/harnais-ia/hrn.yaml"
vrai 'chaque levier porte sa description en commentaire' \
  grep -q "^    # Ce que clia tient, et ce qu'il ne tient pas\.$" \
  "$NEUF/.dev/harnais-ia/hrn.yaml"

SORTIE=$(sortie "$NEUF" hrn ls)
dit 'ls rapporte les deux harnais' '^CLAUDE '
dit 'et les dit a jour' 'à jour'
dit 'il compte les sections actives' '6/6'

vrai 'la sortie standard de new ne porte que le chemin du livrable' \
  test "$(sortie "$(depot pour-sortie)" hrn new CLAUDE)" = '.dev/harnais-ia/CLAUDE.md'

# ==========================================================================
titre 'Le rendu est deterministe, et new n ecrase pas'
# ==========================================================================

AVANT=$(cat "$NEUF/.dev/harnais-ia/CLAUDE.md")
rc_dans 'clia hrn gen CLAUDE' 0 "$NEUF" hrn gen CLAUDE
vrai 'une seconde generation rend exactement le meme fichier' \
  test "$(cat "$NEUF/.dev/harnais-ia/CLAUDE.md")" = "$AVANT"

DONNEES_AVANT=$(cat "$NEUF/.dev/harnais-ia/hrn.yaml")
rc_dans 'new sur un harnais deja pose est refuse' 1 "$NEUF" hrn new CLAUDE
dit 'et il dit ce qui le solde' 'clia hrn gen CLAUDE'
vrai 'les donnees du depot ne sont pas touchees' \
  test "$(cat "$NEUF/.dev/harnais-ia/hrn.yaml")" = "$DONNEES_AVANT"

# ==========================================================================
titre 'Le levier commande vraiment'
# ==========================================================================

REGLE=$(depot regle)
sortie "$REGLE" hrn new CONSTITUTION >/dev/null
COMPLET=$(cat "$REGLE/.dev/harnais-ia/CONSTITUTION.md")

sed -i 's/^    r4-verification: oui$/    r4-verification: non/' \
  "$REGLE/.dev/harnais-ia/hrn.yaml"

SORTIE=$(sortie "$REGLE" hrn ls)
dit 'ls voit que le livrable ne correspond plus a ses donnees' 'à régénérer'

rc_dans 'la regeneration est satisfaite' 0 "$REGLE" hrn gen CONSTITUTION
vrai 'la section retiree a disparu' \
  test -z "$(grep -F 'R4 — Ce qui est fait se vérifie' \
    "$REGLE/.dev/harnais-ia/CONSTITUTION.md" || true)"
vrai 'celles qui restent sont la' \
  grep -q 'R5 — Ce qui est écrit' "$REGLE/.dev/harnais-ia/CONSTITUTION.md"
vrai 'et le numero de la regle retiree reste inoccupe' \
  test -z "$(grep -E '^## R4' "$REGLE/.dev/harnais-ia/CONSTITUTION.md" || true)"

vrai 'le fichier a bien maigri' \
  test "$(wc -l < "$REGLE/.dev/harnais-ia/CONSTITUTION.md")" -lt \
       "$(printf '%s\n' "$COMPLET" | wc -l)"

SORTIE=$(sortie "$REGLE" hrn ls)
dit 'et ls le recompte' '7/8'

# Un champ change le texte, la ou le gabarit le porte.
sed -i 's/^    titre: CONSTITUTION$/    titre: LOI DU DEPOT/' \
  "$REGLE/.dev/harnais-ia/hrn.yaml"
sortie "$REGLE" hrn gen CONSTITUTION >/dev/null
vrai 'un champ modifie change le texte rendu' \
  grep -q '^# LOI DU DEPOT$' "$REGLE/.dev/harnais-ia/CONSTITUTION.md"

# ==========================================================================
titre 'Une donnee que le schema ne declare pas est signalee'
# ==========================================================================

printf '    inventee: oui\n' >> "$REGLE/.dev/harnais-ia/hrn.yaml"
SORTIE=$( ( cd "$REGLE" && "$CLIA" hrn gen CONSTITUTION ) 2>&1 )
dit 'elle est nommee' 'inventee'
dit 'et dite ignoree' 'ignorés'
rc_dans 'et la generation reste satisfaite' 0 "$REGLE" hrn gen CONSTITUTION

# ==========================================================================
titre 'Les refus, et les demandes mal formees'
# ==========================================================================

VIDE=$(depot vide)

rc_dans 'gen sans harnais pose est refuse' 1 "$VIDE" hrn gen
dit 'et il dit comment en poser un' 'clia hrn new HARNAIS'

rc_dans 'gen d un harnais non pose est refuse' 1 "$VIDE" hrn gen CLAUDE
dit 'et il le dit' "n'est pas posé"

rc_dans 'un harnais inconnu est refuse' 1 "$VIDE" hrn new BIDULE
dit 'et il renvoie a ce qui est offert' 'clia hrn ls'

rc_dans 'ls repond meme sans instance' 0 "$VIDE" hrn ls
dit 'en disant que rien n est pose' 'absent'

rc_dans 'un verbe inconnu est mal forme' 2 "$VIDE" hrn bidule
dit 'et il renvoie a l usage' 'clia hrn --help'
rc_dans 'hrn sans verbe est mal forme' 2 "$VIDE" hrn
rc_dans 'ls ne prend pas d argument' 2 "$VIDE" hrn ls trop
rc_dans 'new attend un harnais' 2 "$VIDE" hrn new
rc_dans 'new n en attend qu un' 2 "$VIDE" hrn new CLAUDE CONSTITUTION
rc_dans 'gen n en attend qu un' 2 "$VIDE" hrn gen CLAUDE CONSTITUTION

# ==========================================================================
titre 'Le perimetre, et la documentation qui y echappe'
# ==========================================================================

HORS="$BAC/hors-depot"
mkdir -p "$HORS"

rc 'hrn ls hors d un depot git est refuse' 1 bash -c "cd '$HORS' && '$CLIA' hrn ls"
dit 'et il dit pourquoi' "n'est pas dans un dépôt git"
rc 'son manuel repond partout' 0 bash -c "cd '$HORS' && '$CLIA' hrn --man"
rc 'son aide aussi' 0 bash -c "cd '$HORS' && '$CLIA' hrn --help"

# ==========================================================================
titre 'Rien n est commite'
# ==========================================================================

vrai 'le depot instrumente n a aucun commit' \
  test -z "$(git -C "$NEUF" log --oneline 2>/dev/null || true)"
vrai 'et ses fichiers y sont non suivis' \
  test -n "$(git -C "$NEUF" status --porcelain -- .dev/harnais-ia | grep '^??' || true)"

# ==========================================================================
titre 'Le depot reel n a pas bouge'
# ==========================================================================

vrai 'son HEAD est le meme qu au depart' \
  test "$(git -C "$RACINE" rev-parse HEAD)" = "$REEL_HEAD"
vrai 'son etat de travail est le meme qu au depart' \
  test "$(git -C "$RACINE" status --porcelain | sort)" = "$REEL_ETAT"

bilan
