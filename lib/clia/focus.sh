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
    approuver) printf 'A APPROUVER\thumain\n' ;;
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
#
# Les sept etats du schema sont traites, et aucun autre cas ne disparait.
# Un etat absent ou inconnu ne vaut pas un etat clos : l'item est range a
# defricher plutot qu'omis. Sans cela le decompte ment, et le critere de
# PLN-012 chantier A — chaque item ouvert recoit exactement une categorie —
# tombe des qu'une instance est incomplete. C'etait le cas de NON-013, seule
# objection sans champ etat, invisible du focus jusqu'ici.
clia_focus_objections() {
  local dir f alias titre etat
  dir="$(clia_dev_dir)/objections"
  [[ -d "$dir" ]] || return 0
  while IFS= read -r f; do
    [[ -n "$f" ]] || continue
    alias=$(basename "$f" .md | grep -oE '^NON-[0-9]{3}')
    titre=$(clia_frontmatter_field "$f" title 2>/dev/null)
    etat=$(clia_frontmatter_field "$f" etat 2>/dev/null)
    case "$etat" in
      ouverte|partiellement-repondue)
        printf 'decider\t%s\t%s\n' "$alias" "$titre" ;;
      repondue)
        printf 'clore\t%s\t%s\n' "$alias" "$titre" ;;
      differee)
        printf 'defricher\t%s\t%s (differee : a reprendre)\n' "$alias" "$titre" ;;
      resolue|levee-par-decision|caduque)
        ;;  # etats clos : l'objection ne demande plus rien
      *)
        printf 'defricher\t%s\t%s (etat %s)\n' \
          "$alias" "$titre" "${etat:-absent}" ;;
    esac
  done < <(find -L "$dir" -maxdepth 1 -type f -name 'NON-*.md' 2>/dev/null | sort)
}

# La premiere decision suspendue dont un plan derive, ou rien.
#
# BUG-004 : PDC-003 mesure la forme d'un chantier — livrable, critere, limite
# — et jamais la disponibilite de ses prealables. PLN-007 satisfait les trois
# controles et n'est pas executable : DCN-016, dont il derive, porte
# effet: suspendue depuis le 2026-08-11. Il a ete propose a l'execution
# pendant quatre taches.
#
# Le lien est ecrit en clair dans le plan ; personne ne le suivait.
clia_focus_prealable_suspendu() {
  local plan="$1" dev alias f effet
  dev=$(clia_dev_dir)
  while IFS= read -r alias; do
    [[ -n "$alias" ]] || continue
    f=$(find -L "$dev/decisions" -maxdepth 1 -type f \
          -name "${alias}-*.md" 2>/dev/null | head -1)
    [[ -n "$f" ]] || continue
    effet=$(clia_frontmatter_field "$f" effet 2>/dev/null)
    if [[ "$effet" == "suspendue" ]]; then
      printf '%s\n' "$alias"
      return 0
    fi
  done < <(grep -oE 'DCN-[0-9]{3}' "$plan" 2>/dev/null | sort -u)
  return 1
}

# Les plans proposes attendent une execution. Un plan SMART declare un
# livrable, un critere et une limite par chantier : PDC-003.
clia_focus_plans() {
  local dir f alias titre statut livrables criteres suspendue
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
    elif suspendue=$(clia_focus_prealable_suspendu "$f"); then
      printf 'defricher\t%s\t%s (prealable suspendu : %s)\n' \
        "$alias" "$titre" "$suspendue"
    else
      printf 'executer\t%s\t%s\n' "$alias" "$titre"
    fi
  done < <(find -L "$dir" -maxdepth 1 -type f -name 'PLN-*.md' 2>/dev/null | sort)
}

# Meme regle que pour les objections : seuls les etats clos declares par le
# schema font disparaitre un item. Un etat absent est un defaut de l'instance,
# pas une raison de la taire.
clia_focus_issues() {
  local dir f alias titre etat
  dir="$(clia_dev_dir)/issues"
  [[ -d "$dir" ]] || return 0
  while IFS= read -r f; do
    [[ -n "$f" ]] || continue
    etat=$(clia_frontmatter_field "$f" etat 2>/dev/null)
    case "$etat" in
      close|abandonnee) continue ;;
    esac
    alias=$(basename "$f" .md | grep -oE '^ISU-[0-9]{3}')
    titre=$(clia_frontmatter_field "$f" title 2>/dev/null)
    case "$etat" in
      ouverte|en-cours) printf 'defricher\t%s\t%s\n' "$alias" "$titre" ;;
      *)                printf 'defricher\t%s\t%s (etat %s)\n' \
                          "$alias" "$titre" "${etat:-absent}" ;;
    esac
  done < <(find -L "$dir" -maxdepth 1 -type f -name 'ISU-*.md' 2>/dev/null | sort)
}

clia_focus_bogues() {
  local dir f alias titre etat
  dir="$(clia_dev_dir)/bogues"
  [[ -d "$dir" ]] || return 0
  while IFS= read -r f; do
    [[ -n "$f" ]] || continue
    etat=$(clia_frontmatter_field "$f" etat 2>/dev/null)
    case "$etat" in
      corrige|non-reproduit|accepte) continue ;;
    esac
    alias=$(basename "$f" .md | grep -oE '^BUG-[0-9]{3}')
    titre=$(clia_frontmatter_field "$f" title 2>/dev/null)
    case "$etat" in
      ouvert) printf 'corriger\t%s\t%s\n' "$alias" "$titre" ;;
      *)      printf 'defricher\t%s\t%s (etat %s)\n' \
                "$alias" "$titre" "${etat:-absent}" ;;
    esac
  done < <(find -L "$dir" -maxdepth 1 -type f -name 'BUG-*.md' 2>/dev/null | sort)
}

# Les decisions suspendues attendent l'humain, et personne d'autre.
#
# BUG-005 : DCN-013 pose qu'un premier jet d'agent reste suspendu jusqu'a
# approbation manuelle. C'est donc une attente adressee a l'humain — et le
# systeme ne la comptait pas. DCN-016 bloquait cinq chantiers de PLN-007
# depuis le 2026-08-11 sans etre un item pour personne : la commande ne la
# nommait que comme motif d'un plan range a defricher.
clia_focus_decisions() {
  local dir f alias titre effet n
  dir="$(clia_dev_dir)/decisions"
  [[ -d "$dir" ]] || return 0
  while IFS= read -r f; do
    [[ -n "$f" ]] || continue
    effet=$(clia_frontmatter_field "$f" effet 2>/dev/null)
    [[ "$effet" == "suspendue" ]] || continue
    alias=$(basename "$f" .md | grep -oE '^DCN-[0-9]{3}')
    titre=$(clia_frontmatter_field "$f" title 2>/dev/null)
    n=$(clia_focus_plans_bloques "$alias")
    if (( n > 0 )); then
      printf 'approuver\t%s\t%s (bloque %s plan(s))\n' "$alias" "$titre" "$n"
    else
      printf 'approuver\t%s\t%s\n' "$alias" "$titre"
    fi
  done < <(find -L "$dir" -maxdepth 1 -type f -name 'DCN-*.md' 2>/dev/null | sort)
}

# Combien de plans proposes citent cet alias de decision.
clia_focus_plans_bloques() {
  local alias="$1" dir f n=0
  dir="$(clia_dev_dir)/plans"
  [[ -d "$dir" ]] || { printf '0\n'; return 0; }
  while IFS= read -r f; do
    [[ -n "$f" ]] || continue
    [[ "$(clia_frontmatter_field "$f" statut-plan 2>/dev/null)" == "propose" ]] || continue
    grep -q -- "$alias" "$f" 2>/dev/null && n=$((n + 1))
  done < <(find -L "$dir" -maxdepth 1 -type f -name 'PLN-*.md' 2>/dev/null)
  printf '%s\n' "$n"
}

clia_focus_items() {
  clia_focus_decisions
  clia_focus_objections
  clia_focus_plans
  clia_focus_issues
  clia_focus_bogues
}

# --------------------------------------------------------------------------
# L'ordre de priorite
# --------------------------------------------------------------------------
#
# Une decision suspendue passe avant tout : elle attend l'humain, et lui seul
# peut la lever. Ensuite un bogue ouvert, ecart constate a une regle ecrite.
#
# Puis ce qui est pret a etre fait par l'agent, puis ce qui attend une reponse
# de l'humain, puis ce qui demande un defrichage.
#
# A l'interieur d'une categorie, le poids departage : ce qui est le plus cite
# ailleurs debloque le plus.

# Une decision suspendue passe devant tout.
#
# BUG-005, correction S2. Elle bloque par construction tout ce qui en derive,
# et c'est la seule categorie ou l'humain est le seul a pouvoir agir :
# CONSTITUTION.md C1. La laisser derriere un bogue que personne n'attend est
# ce qui a immobilise PLN-007 pendant deux jours.
clia_focus_rang() {
  case "$1" in
    approuver) printf '1\n' ;;
    corriger)  printf '2\n' ;;
    executer)  printf '3\n' ;;
    decider)   printf '4\n' ;;
    clore)     printf '5\n' ;;
    defricher) printf '6\n' ;;
    *)         printf '9\n' ;;
  esac
}

# Le destinataire d'une categorie, pour le filtre de clia focus --humain.
clia_focus_destinataire() {
  case "$1" in
    approuver|decider) printf 'humain\n' ;;
    clore|executer|corriger) printf 'agent\n' ;;
    defricher) printf 'les deux\n' ;;
    *) printf '?\n' ;;
  esac
}

# --------------------------------------------------------------------------
# Aide
# --------------------------------------------------------------------------

clia_focus_usage() {
  cat <<'EOF'
Usage : clia focus [--tout] [--humain | --agent]

Repond a « que dois-je faire maintenant ? ».

Sans argument, la commande nomme UNE action et la commande qui l'executerait.

  --tout      le decompte par categorie, et les items de chacune
  --humain    seulement ce que l'humain peut faire, et lui seul
  --agent     seulement ce que l'agent peut faire

Les six categories, dans l'ordre de priorite :

  A APPROUVER   une decision suspendue : elle attend l'humain, et lui seul
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
    approuver) printf 'clia res edit %s   # poser effet: en-vigueur, ou reviser\n' "$alias" ;;
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

  # BUG-005 S3 : l'humain qui lance la commande veut SON geste, non la
  # priorite du depot. Sur 61 items le 2026-08-13, 57 etaient du travail
  # d'agent, et la commande designait l'un d'eux.
  local tout=0 qui=''
  while (( $# > 0 )); do
    case "$1" in
      --tout|-a) tout=1 ;;
      --humain)  qui='humain' ;;
      --agent)   qui='agent' ;;
      '')        ;;
      *)         clia_warn "option inconnue : $1"
                 clia_focus_usage >&2
                 return 2 ;;
    esac
    shift
  done

  local items
  items=$(clia_focus_items)

  # Le defrichage s'adresse aux deux : il reste dans les deux filtres.
  if [[ -n "$qui" ]]; then
    local gardes='' cat_ligne dest
    while IFS= read -r cat_ligne; do
      [[ -n "$cat_ligne" ]] || continue
      dest=$(clia_focus_destinataire "${cat_ligne%%$'\t'*}")
      if [[ "$dest" == "$qui" || "$dest" == "les deux" ]]; then
        gardes+="$cat_ligne"$'\n'
      fi
    done <<< "$items"
    items="${gardes%$'\n'}"
  fi

  if [[ -z "$items" ]]; then
    if [[ -n "$qui" ]]; then
      printf 'rien en attente pour %s\n' "$qui"
    else
      printf 'rien en attente\n'
    fi
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
    for c in approuver corriger executer decider clore defricher; do
      n=$(printf '%s\n' "$items" | awk -F'\t' -v k="$c" '$1 == k' | grep -c '') || n=0
      (( n > 0 )) || continue
      IFS=$'\t' read -r libelle destinataire < <(clia_focus_categorie_libelle "$c")
      printf '%s\t%s\t%s\n' "$libelle" "$destinataire" "$n"
    done
  } | column -t -s $'\t'

  printf '\n'
  local c
  for c in approuver corriger executer decider clore defricher; do
    local lignes
    lignes=$(printf '%s\n' "$items" | awk -F'\t' -v k="$c" '$1 == k')
    [[ -n "$lignes" ]] || continue
    IFS=$'\t' read -r libelle destinataire < <(clia_focus_categorie_libelle "$c")
    printf '%s\n' "$libelle"
    printf '%s\n' "$lignes" | awk -F'\t' '{ printf "  %-9s %s\n", $2, $3 }'
    printf '\n'
  done
}
