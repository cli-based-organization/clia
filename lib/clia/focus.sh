#!/usr/bin/env bash
# focus.sh - Commande clia focus.
#
# Repond a « que dois-je faire maintenant ? ».
#
# Motif, ANL-011 : l'information existe deja, dispersee dans plus de soixante
# fichiers. Ce qui manque n'est pas la donnee, c'est son agregation. L'humain
# le formule ainsi : « un humain a besoin de focus et d'une seule action
# claire a prendre pour pouvoir agir ».
#
# Decisions appliquees :
#   PLN-012     les categories, et l'ordre de priorite
#   ADR-003 D9  la sortie sert un humain, un agent, et un programme
#
# La commande n'execute rien. Elle nomme l'action et la commande qui la
# ferait.

# --------------------------------------------------------------------------
# Le classement
# --------------------------------------------------------------------------
#
# PLN-012 chantier A declare quatre categories. Une cinquieme a ete ajoutee
# en l'executant : les bogues ouverts sont des items ouverts, et le critere
# du chantier exige que CHAQUE item recoive une categorie. Ecart declare
# dans le journal de la tache 9.
#
# Sortie, un item par ligne, champs separes par une tabulation :
#   categorie  destinataire  alias  titre  poids

clia_focus_categorie_libelle() {
  case "$1" in
    decider)   printf 'A DECIDER\thumain\n' ;;
    clore)     printf 'A CLORE\tagent\n' ;;
    executer)  printf 'A EXECUTER\tagent\n' ;;
    corriger)  printf 'A CORRIGER\tagent\n' ;;
    defricher) printf 'A DEFRICHER\tles deux\n' ;;
  esac
}

# Nombre de documents qui renvoient a un alias, hors le document lui-meme.
#
# C'est la mesure de ce qu'un item debloque : plus il est cite, plus le
# traiter libere de travail ailleurs. La mesure est grossiere — elle compte
# des renvois declares, et ceux-ci sont incomplets — et le plan le declare
# dans ses objections.
clia_focus_poids() {
  local alias="$1" dev
  dev=$(clia_dev_dir)
  [[ -d "$dev" ]] || { printf '0\n'; return 0; }
  local n
  n=$(grep -rl --include='*.md' --exclude-dir=logs --exclude-dir=archives \
        -- "$alias" "$dev" 2>/dev/null | grep -vc "/${alias}-") || n=0
  printf '%s\n' "${n:-0}"
}

# Les objections : sans reponse, elles attendent l'humain ; repondues, elles
# attendent une cloture.
clia_focus_objections() {
  local dir f alias titre etat q r
  dir="$(clia_dev_dir)/objections"
  [[ -d "$dir" ]] || return 0
  while IFS= read -r f; do
    [[ -n "$f" ]] || continue
    alias=$(basename "$f" .md | grep -oE '^NON-[0-9]{3}')
    titre=$(clia_frontmatter_field "$f" title 2>/dev/null)
    etat=$(clia_frontmatter_field "$f" etat 2>/dev/null)
    case "$etat" in
      ouverte)
        printf 'decider\t%s\t%s\n' "$alias" "$titre" ;;
      repondue)
        printf 'clore\t%s\t%s\n' "$alias" "$titre" ;;
    esac
  done < <(find -L "$dir" -maxdepth 1 -type f -name 'NON-*.md' 2>/dev/null | sort)
}

# Les plans proposes attendent une execution. Un plan SMART declare un
# livrable, un critere et une limite par chantier : PDC-003.
clia_focus_plans() {
  local dir f alias titre statut livrables criteres
  dir="$(clia_dev_dir)/plans"
  [[ -d "$dir" ]] || return 0
  while IFS= read -r f; do
    [[ -n "$f" ]] || continue
    statut=$(clia_frontmatter_field "$f" statut-plan 2>/dev/null)
    [[ "$statut" == "propose" ]] || continue
    alias=$(basename "$f" .md | grep -oE '^PLN-[0-9]{3}')
    titre=$(clia_frontmatter_field "$f" title 2>/dev/null)
    # Un plan sans critere de reussite n'est pas executable : il est signale
    # comme tel plutot que propose a l'execution.
    criteres=$(grep -c '\*\*Critère de réussite\*\*' "$f" 2>/dev/null) || criteres=0
    livrables=$(grep -c '\*\*Livrable\*\*' "$f" 2>/dev/null) || livrables=0
    if (( criteres == 0 || livrables == 0 )); then
      printf 'defricher\t%s\t%s (non SMART : ni livrable ni critere declare)\n' \
        "$alias" "$titre"
    else
      printf 'executer\t%s\t%s\n' "$alias" "$titre"
    fi
  done < <(find -L "$dir" -maxdepth 1 -type f -name 'PLN-*.md' 2>/dev/null | sort)
}

clia_focus_issues() {
  local dir f alias titre etat
  dir="$(clia_dev_dir)/issues"
  [[ -d "$dir" ]] || return 0
  while IFS= read -r f; do
    [[ -n "$f" ]] || continue
    etat=$(clia_frontmatter_field "$f" etat 2>/dev/null)
    [[ "$etat" == "ouverte" || "$etat" == "en-cours" ]] || continue
    alias=$(basename "$f" .md | grep -oE '^ISU-[0-9]{3}')
    titre=$(clia_frontmatter_field "$f" title 2>/dev/null)
    printf 'defricher\t%s\t%s\n' "$alias" "$titre"
  done < <(find -L "$dir" -maxdepth 1 -type f -name 'ISU-*.md' 2>/dev/null | sort)
}

clia_focus_bogues() {
  local dir f alias titre etat
  dir="$(clia_dev_dir)/bogues"
  [[ -d "$dir" ]] || return 0
  while IFS= read -r f; do
    [[ -n "$f" ]] || continue
    etat=$(clia_frontmatter_field "$f" etat 2>/dev/null)
    [[ "$etat" == "ouvert" ]] || continue
    alias=$(basename "$f" .md | grep -oE '^BUG-[0-9]{3}')
    titre=$(clia_frontmatter_field "$f" title 2>/dev/null)
    printf 'corriger\t%s\t%s\n' "$alias" "$titre"
  done < <(find -L "$dir" -maxdepth 1 -type f -name 'BUG-*.md' 2>/dev/null | sort)
}

clia_focus_items() {
  clia_focus_objections
  clia_focus_plans
  clia_focus_issues
  clia_focus_bogues
}

# --------------------------------------------------------------------------
# L'ordre de priorite
# --------------------------------------------------------------------------
#
# Un bogue ouvert passe avant tout : c'est un ecart constate a une regle
# ecrite, et le laisser ouvert fait diverger le systeme de ce qu'il declare.
#
# Ensuite ce qui est pret a etre fait par l'agent, puis ce qui attend
# l'humain, puis ce qui demande un defrichage.
#
# A l'interieur d'une categorie, le poids departage : ce qui est le plus cite
# ailleurs debloque le plus.

clia_focus_rang() {
  case "$1" in
    corriger)  printf '1\n' ;;
    executer)  printf '2\n' ;;
    decider)   printf '3\n' ;;
    clore)     printf '4\n' ;;
    defricher) printf '5\n' ;;
    *)         printf '9\n' ;;
  esac
}

# --------------------------------------------------------------------------
# Aide
# --------------------------------------------------------------------------

clia_focus_usage() {
  cat <<'EOF'
Usage : clia focus [--tout]

Repond a « que dois-je faire maintenant ? ».

Sans argument, la commande nomme UNE action et la commande qui l'executerait.
Avec --tout, elle affiche le decompte par categorie et les items de chacune.

Les cinq categories, dans l'ordre de priorite :

  A CORRIGER    un bogue ouvert : le systeme diverge de ce qu'il declare
  A EXECUTER    un plan propose, avec livrable et critere declares
  A DECIDER     une objection sans reponse : elle attend l'humain
  A CLORE       une objection repondue : l'initiateur n'a pas statue
  A DEFRICHER   une issue ouverte, ou un plan sans critere de reussite

A l'interieur d'une categorie, l'item le plus cite ailleurs passe devant :
le traiter libere le plus de travail.

La commande n'execute rien.
EOF
}

# --------------------------------------------------------------------------
# La commande
# --------------------------------------------------------------------------

clia_focus_action_pour() {
  local cat="$1" alias="$2"
  case "$cat" in
    corriger)  printf 'clia res show %s   # lire, puis corriger la cause\n' "$alias" ;;
    executer)  printf 'clia res show %s   # lire, puis executer ses chantiers\n' "$alias" ;;
    decider)   printf 'clia res edit %s   # repondre aux questions\n' "$alias" ;;
    clore)     printf 'clia res edit %s   # statuer : resolue, levee-par-decision, ou caduque\n' "$alias" ;;
    defricher) printf 'clia res show %s   # lire, puis decider par ou commencer\n' "$alias" ;;
  esac
}

clia_focus_main() {
  if clia_is_help "${1:-}"; then clia_focus_usage; return 0; fi
  clia_require_repo

  local tout=0
  case "${1:-}" in
    --tout|-a) tout=1 ;;
    '')        ;;
    *)         clia_warn "option inconnue : $1"
               clia_focus_usage >&2
               return 2 ;;
  esac

  local items
  items=$(clia_focus_items)
  if [[ -z "$items" ]]; then
    printf 'rien en attente\n'
    return 0
  fi

  # Le poids n'est calcule que sur les candidats de la categorie la plus
  # prioritaire : le calculer sur tous couterait un parcours du depot par
  # item.
  local cat_prio rang meilleur=9
  while IFS=$'\t' read -r cat _alias _titre; do
    rang=$(clia_focus_rang "$cat")
    (( rang < meilleur )) && { meilleur=$rang; cat_prio="$cat"; }
  done <<< "$items"

  local choix_alias='' choix_titre='' poids_max=-1 p
  while IFS=$'\t' read -r cat alias titre; do
    [[ "$cat" == "$cat_prio" ]] || continue
    p=$(clia_focus_poids "$alias")
    if (( p > poids_max )); then
      poids_max=$p; choix_alias="$alias"; choix_titre="$titre"
    fi
  done <<< "$items"

  local libelle destinataire
  IFS=$'\t' read -r libelle destinataire < <(clia_focus_categorie_libelle "$cat_prio")

  if (( tout == 0 )); then
    {
      printf 'CLE\tVALEUR\n'
      printf 'a faire\t%s\n' "$libelle"
      printf 'qui\t%s\n' "$destinataire"
      printf 'quoi\t%s - %s\n' "$choix_alias" "$choix_titre"
      printf 'cite par\t%s document(s)\n' "$poids_max"
      printf 'en attente\t%s item(s) au total\n' "$(printf '%s\n' "$items" | grep -c '')"
    } | column -t -s $'\t'
    printf '\n'
    clia_focus_action_pour "$cat_prio" "$choix_alias"
    clia_hint "clia focus --tout affiche toutes les categories"
    return 0
  fi

  {
    printf 'CATEGORIE\tQUI\tNOMBRE\n'
    local c n
    for c in corriger executer decider clore defricher; do
      n=$(printf '%s\n' "$items" | awk -F'\t' -v k="$c" '$1 == k' | grep -c '') || n=0
      (( n > 0 )) || continue
      IFS=$'\t' read -r libelle destinataire < <(clia_focus_categorie_libelle "$c")
      printf '%s\t%s\t%s\n' "$libelle" "$destinataire" "$n"
    done
  } | column -t -s $'\t'

  printf '\n'
  local c
  for c in corriger executer decider clore defricher; do
    local lignes
    lignes=$(printf '%s\n' "$items" | awk -F'\t' -v k="$c" '$1 == k')
    [[ -n "$lignes" ]] || continue
    IFS=$'\t' read -r libelle destinataire < <(clia_focus_categorie_libelle "$c")
    printf '%s\n' "$libelle"
    printf '%s\n' "$lignes" | awk -F'\t' '{ printf "  %-9s %s\n", $2, $3 }'
    printf '\n'
  done
}
