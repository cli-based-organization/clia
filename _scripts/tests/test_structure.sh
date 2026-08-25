#!/usr/bin/env bash
# _scripts/tests/test_structure.sh — banc de SPC-001 et REQ-003.
#
# Une spécification qui ne se vérifie pas est un souhait. Ce banc contrôle le
# dépôt réel contre ce que SPC-001 énonce : deux natures de répertoire, la
# règle de l'underscore, aucun répertoire vide, aucun catalogue central.
#
# Il ne modifie rien : il lit le dépôt tel qu'il est.
#
# Lancement :  bash _scripts/tests/test_structure.sh

set -uo pipefail

RACINE=$(cd -P "$(dirname "${BASH_SOURCE[0]}")/../.." >/dev/null 2>&1 && pwd)

# shellcheck source=banc.sh
. "$(dirname "${BASH_SOURCE[0]}")/banc.sh"

RES="$RACINE/_ressources"

# Les huit concepts rattachés, et les trois répertoires de la ressource
# elle-même. REQ-003.
CONCEPTS=(principes ontology specs reqs scripts skills features methodes)
PROPRES=(schemas templates primitives)

# Le nom qualifié de chaque ressource : un répertoire de _ressources/ qui
# porte schemas/<nom>.yaml, au premier ou au second niveau.
ressources() {
  local d nom
  for d in "$RES"/*/ "$RES"/*/*/; do
    [[ -d "$d" ]] || continue
    d="${d%/}"
    nom="${d#"$RES"/}"
    [[ -f "$d/schemas/$(basename "$d").yaml" ]] && printf '%s\n' "$nom"
  done
  return 0
}

est_admis() {
  local nom="$1" c
  for c in "${PROPRES[@]}"; do [[ "$nom" == "$c" ]] && return 0; done
  for c in "${CONCEPTS[@]}"; do
    [[ "$nom" == "$c" || "$nom" == "_$c" ]] && return 0
  done
  return 1
}

# --------------------------------------------------------------------------

printf 'banc de la structure — SPC-001, REQ-003\n'
printf 'dépôt : %s\n' "$RACINE"

titre 'S2 — deux natures de répertoire, et rien d'\''autre'

LISTE=$(ressources)
vrai "au moins une ressource est déclarée"    test -n "$LISTE"
printf '         ressources : %s\n' "$(printf '%s ' $LISTE)"

# Un répertoire de premier niveau est soit une ressource, soit une catégorie
# dont tous les enfants sont des ressources. Rien d'autre n'est admis.
for d in "$RES"/*/; do
  d="${d%/}"
  nom=$(basename "$d")
  if [[ -f "$d/schemas/$nom.yaml" ]]; then
    ok "$nom est une ressource, il porte sa définition"
    continue
  fi
  # Pas de définition : c'est une catégorie. Tous ses enfants doivent en être.
  enfants=0
  fautifs=''
  for e in "$d"/*/; do
    [[ -d "$e" ]] || continue
    e="${e%/}"
    enfants=$((enfants + 1))
    [[ -f "$e/schemas/$(basename "$e").yaml" ]] || fautifs+="$(basename "$e") "
  done
  if (( enfants == 0 )); then
    echec "$nom est une ressource ou une catégorie" "ni définition, ni ressource enfant"
  elif [[ -n "$fautifs" ]]; then
    echec "$nom est une catégorie de ressources" "sans définition : $fautifs"
  else
    ok "$nom est une catégorie, ses $enfants enfants sont des ressources"
  fi
done

titre 'S2 — la profondeur s'\''arrête à deux'

trop=''
for d in "$RES"/*/*/*/; do
  [[ -d "$d" ]] || continue
  base=$(basename "${d%/}")
  est_admis "$base" && continue
  trop+="${d#"$RES"/} "
done
if [[ -z "$trop" ]]; then
  ok "aucune ressource au troisième niveau"
else
  echec "aucune ressource au troisième niveau" "trouvé : $trop"
fi

titre 'S3 — seuls les onze emplacements sont admis'

for d in "$RES"/*/ "$RES"/*/*/; do
  [[ -d "$d" ]] || continue
  d="${d%/}"
  nom="${d#"$RES"/}"
  # Une catégorie ne porte que des ressources, pas de concept.
  [[ -f "$d/schemas/$(basename "$d").yaml" ]] || continue
  intrus=''
  for s in "$d"/*/; do
    [[ -d "$s" ]] || continue
    est_admis "$(basename "${s%/}")" || intrus+="$(basename "${s%/}") "
  done
  if [[ -z "$intrus" ]]; then
    ok "$nom ne porte que des emplacements admis"
  else
    echec "$nom ne porte que des emplacements admis" "intrus : $intrus"
  fi
done

titre 'S4 — un template porte le nom de sa primitive'

for d in "$RES"/*/ "$RES"/*/*/; do
  [[ -d "$d" ]] || continue
  d="${d%/}"
  for c in "${CONCEPTS[@]}"; do
    [[ -d "$d/_$c" ]] || continue
    orphelins=''
    for t in "$d/_$c"/*; do
      [[ -f "$t" ]] || continue
      base=$(basename "$t")
      # <nom>.template.<ext> doit répondre à <nom>.<ext> dans le concept nu.
      case "$base" in
        *.template.*)
          primitive="${base/.template./.}"
          [[ -f "$d/$c/$primitive" ]] || orphelins+="$base "
          ;;
        *) orphelins+="$base (pas de .template)" ;;
      esac
    done
    if [[ -z "$orphelins" ]]; then
      ok "${d#"$RES"/}/_$c : chaque template répond à une primitive"
    else
      echec "${d#"$RES"/}/_$c : chaque template répond à une primitive" "orphelins : $orphelins"
    fi
  done
done

titre 'S5 — aucun répertoire vide'

vides=$(find "$RES" "$RACINE/_scripts" -type d -empty 2>/dev/null | sed "s|$RACINE/||")
if [[ -z "$vides" ]]; then
  ok "aucun répertoire vide sous _ressources ni _scripts"
else
  echec "aucun répertoire vide sous _ressources ni _scripts" "$(printf '%s ' $vides)"
fi

titre 'S6 — aucun catalogue central'

faux "pas de _templates à la racine"          test -d "$RACINE/_templates"
faux "pas de _ressources/feature"             test -d "$RES/feature"
faux "pas de _ressources/skill/primitives"    test -d "$RES/skill/primitives"

titre 'S7 — une fonctionnalité n'\''est pas une ressource'

vrai "la commande feature est celle du CLI"   test -f "$RACINE/_scripts/lib/cmd/feature.sh"
faux "et non celle d'une ressource"           test -e "$RES/feature/scripts/feature.sh"

titre 'Tâche 6 — session est une ressource'

vrai "elle porte sa définition"               test -f "$RES/session/schemas/session.yaml"
vrai "sa fonctionnalité est sous elle"        test -f "$RES/session/features/session.md"
vrai "son gabarit est le template de celle-ci" test -f "$RES/session/_features/session.template.md"
vrai "la définition déclare ce gabarit"       test "$(grep -m1 '^gabarit:' "$RES/session/schemas/session.yaml" | sed 's/^gabarit:[[:space:]]*//')" = '_features/session.template.md'

titre 'Les commandes restent toutes découvrables'

# SORTIE est la variable que « dit » et « ne_dit_pas » lisent : elle est
# posée ici une fois, plutôt que de relancer l'aide à chaque assertion.
# shellcheck disable=SC2034
SORTIE=$("$RACINE/_scripts/bin/clia" --help 2>&1)
for c in context feature harness-ia init setup skill; do
  dit "clia --help annonce $c" "^  $c "
done
ne_dit_pas "aucune commande n'est masquée"    'masquée'

# --------------------------------------------------------------------------

bilan
