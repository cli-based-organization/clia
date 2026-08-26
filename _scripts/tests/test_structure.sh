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

titre 'Un gabarit tient ce que sa définition déclare'

# Une définition qui annonce des sections et des champs sans que son gabarit
# les porte laisse celui qui s'en sert les inventer. Le contrôle est
# générique : il vaut pour toute ressource qui déclare un gabarit.

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

champ_yaml() {
  grep -m1 -E "^${2}:[[:space:]]" "$1" 2>/dev/null | sed -E "s/^${2}:[[:space:]]*//; s/^\"//; s/\"$//"
}

prefixes=' '
for def in "$RES"/*/schemas/*.yaml "$RES"/*/*/schemas/*.yaml; do
  [[ -f "$def" ]] || continue
  nom=$(basename "$def" .yaml)
  dir=$(dirname "$(dirname "$def")")

  # Deux types au même préfixe rendent tout alias ambigu dans le dépôt.
  p=$(champ_yaml "$def" prefixe)
  if [[ "$prefixes" == *" $p "* ]]; then
    echec "$nom a un préfixe distinctif" "$p est déjà pris"
  else
    prefixes+="$p "
    ok "$nom a un préfixe distinctif : $p"
  fi

  gabarit=$(champ_yaml "$def" gabarit)
  [[ -n "$gabarit" ]] || continue
  if [[ ! -f "$dir/$gabarit" ]]; then
    echec "$nom : son gabarit existe" "déclaré : $gabarit"
    continue
  fi
  g="$dir/$gabarit"

  # Quand une instance porte un champ « type », c'est lui qui la rattache à sa
  # définition, et il doit donc valoir le nom du type. Toutes n'en portent pas :
  # le frontmatter d'un skill est celui qu'attend l'agent qui le charge, non
  # celui que clia préférerait. Le contrôle suit la déclaration, il ne lui
  # impose pas une convention qu'elle n'a pas prise.
  if liste_yaml "$def" champs-d-instance | grep -qx 'type'; then
    attendu=$(grep -m1 -E '^type:' "$g" | sed -E 's/^type:[[:space:]]*//' || true)
    if [[ "$attendu" == "$nom" ]]; then
      ok "$nom : son gabarit se déclare du bon type"
    else
      echec "$nom : son gabarit se déclare du bon type" "trouvé : ${attendu:-aucun}"
    fi
  fi

  manquants=''
  while IFS= read -r champ; do
    [[ -n "$champ" ]] || continue
    grep -qE "^${champ}:" "$g" || manquants+="$champ "
  done < <(liste_yaml "$def" champs-d-instance)
  if [[ -z "$manquants" ]]; then
    ok "$nom : son gabarit porte les champs d'instance"
  else
    echec "$nom : son gabarit porte les champs d'instance" "manquants : $manquants"
  fi

  absentes=''
  while IFS= read -r section; do
    [[ -n "$section" ]] || continue
    grep -qF "# $section" "$g" || absentes+="« $section » "
  done < <(liste_yaml "$def" sections)
  if [[ -z "$absentes" ]]; then
    ok "$nom : son gabarit porte les sections déclarées"
  else
    echec "$nom : son gabarit porte les sections déclarées" "absentes : $absentes"
  fi
done

titre 'Les six ressources core de la tâche 11'

for r in fondation analyse objection plan session log; do
  if [[ -f "$RES/$r/schemas/$r.yaml" ]]; then
    ok "$r est définie"
  else
    echec "$r est définie" "pas de $RES/$r/schemas/$r.yaml"
  fi
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
for c in check context extension feature harness-ia init release res setup skill; do
  dit "clia --help annonce $c" "^  $c "
done
ne_dit_pas "aucune commande n'est masquée"    'masquée'

# --------------------------------------------------------------------------

bilan
