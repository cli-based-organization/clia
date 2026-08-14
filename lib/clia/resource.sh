#!/usr/bin/env bash
# resource.sh - Commande clia resource.
#
# Grammaire : nom puis verbe (clia res ls), conformement au choix retenu par
# la tache 6 de la session du 2026-08-09. FND-001 section 5.1 documente les
# deux ordres possibles et note que celui-ci se prete mieux a l'extensibilite.
#
# Frontiere appliquee, ADR-003 D5 : clia garantit ce qui doit etre garanti,
# l'agent interprete. Concretement, clia cree le fichier, pose le frontmatter
# et attribue le numero ; il ne redige aucun contenu.

clia_resource_usage() {
  cat <<'EOF'
Usage : clia resource|res|r <verbe> [arguments]

Verbes :
  ls                       liste les types de ressources connus du depot
  ls TYPE                  liste les instances d'un type
  new TYPE DESCRIPTION     cree une ressource, slug derive de la description
  show ID                  affiche une ressource
  explain ID               explique le TYPE de cette ressource : champs, valeurs, cycle de vie
  edit ID                  ouvre une ressource avec CLIA_EDITOR
  check [TYPE]             signale un champ obligatoire constant sur toutes les instances

TYPE se designe par son nom ou par son prefixe, sans distinction de casse :
  clia res ls objection
  clia res ls NON

ID se designe par son numero de sequence ou par son identifiant stable :
  clia res show RES-001
  clia res show RES-ressource

Aide detaillee d'un verbe :
  clia res ls --help
  clia res new --help
  clia res show --help
  clia res explain --help
  clia res edit --help
  clia res check --help
EOF
}

# Aide propre a chaque verbe. Un verbe sans aide est un verbe indecouvrable.
clia_resource_usage_verb() {
  case "$1" in
    ls) cat <<'EOF'
Usage : clia resource ls [TYPE]

Sans argument, liste les types de ressources connus du depot, avec leur
prefixe, leur cycle de vie, leur regime d'edition, leur definition et leur
nombre d'instances. Les types employes sans definition apparaissent avec la
mention "aucune".

Avec un TYPE, liste ses instances : identifiant, description, statut.

TYPE se designe par son nom, son nom canonique ou son prefixe, sans
distinction de casse, au singulier ou au pluriel :
  clia res ls objection
  clia res ls NON
  clia res ls decision

Alias : list
EOF
;;
    new) cat <<'EOF'
Usage : clia resource new TYPE DESCRIPTION

Cree une ressource du type donne. Le slug est derive de la description :
minuscules, accents translitteres, separateurs reduits a un trait d'union.

  clia res new objection "Portee du systeme"
  -> .dev/objections/NON-006-portee-du-systeme.md

Ce que la commande fait :
  - attribue le numero de sequence suivant du type,
    une sequence a trois chiffres ou une date ISO ;
  - pose les champs que la definition declare obligatoires, en marquant
    "À RENSEIGNER" ceux dont la valeur depend du contenu ;
  - ecrit les sections que la definition annonce.

Ce que la commande ne fait pas : rediger le contenu. Voir ADR-003 D5.

Elle refuse si le type n'a pas de definition, si le slug est deja employe,
ou si le type porte un statut deprecie ou non-installe.

Alias : create
EOF
;;
    show) cat <<'EOF'
Usage : clia resource show ID

Affiche une ressource sur la sortie standard.

ID accepte trois formes, essayees dans cet ordre :
  RES-001           prefixe et discriminant, l'adresse du fichier
  RES-ressource     identifiant stable du frontmatter
  001               numero seul, si un seul type le porte

En cas d'ambiguite, la commande refuse et nomme les candidats. Le numero de
sequence n'est pas un identifiant : voir NON-001.

Les ressources archivees ne sont pas trouvees. Voir CLIA_EXCLUDE_DIRS.

Alias : cat
EOF
;;
    explain) cat <<'EOF'
Usage : clia resource explain ID

Explique le TYPE de la ressource designee : ses champs obligatoires et les
valeurs que chacun admet, son cycle de vie, son regime d'edition, ses
relations admissibles, et le nombre d'instances qui existent.

ID accepte une instance comme une definition. Les deux formes suivantes
donnent la meme sortie, celle du type « decision » :
  clia res explain DCN-016     une instance
  clia res explain RES-009     la definition du type

C'est ADR-018 D3 : celui qui bute sur une decision a DCN-016 sous les yeux,
non RES-009.

L'explication est DERIVEE, jamais redigee. Ses sources sont le frontmatter de
la definition et le schema cue du type. Un champ que le schema ne contraint
pas est affiche « libre », jamais omis.

Ce qu'elle ne fait pas : dire le SENS. Pourquoi le champ effet existe et ce
que « suspendue » engage vivent dans la definition, que la commande designe
en derniere ligne.

Alias : help
EOF
;;
    edit) cat <<'EOF'
Usage : clia resource edit ID

Ouvre une ressource avec l'editeur declare par CLIA_EDITOR, a defaut VISUAL,
a defaut EDITOR, a defaut vi.

ID accepte les memes trois formes que show.

  clia config set EDITOR nvim
  clia res edit RES-001
EOF
;;
    check) cat <<'EOF'
Usage : clia resource check [TYPE]

Signale un champ obligatoire dont toutes les instances d'un type portent la
meme valeur. Un tel champ n'apprend rien : c'est le defaut que NON-035 a
mesure sur le champ status, valant draft dans les cent cinquante-sept
instances du depot pendant trois jours, sans que rien ne le signale.

Sans TYPE, tous les types definis a deux instances ou plus sont examines.
Avec TYPE, seul celui-la.

Le champ type n'est jamais signale : il est constant par construction.

Sortie vide si rien n'est constant. Code de retour 1 si un champ constant est
trouve, 0 sinon : la commande peut servir de garde dans un script.

Ce n'est pas clia validate. Un seul controle, pas les dix que ISU-007
reclame.
EOF
;;
  esac
}

# --------------------------------------------------------------------------
# ls, sans argument : les types
# --------------------------------------------------------------------------

clia_resource_ls_types() {
  clia_require_repo

  local defined used
  defined=$(clia_types_defined)
  used=$(clia_types_used)

  if [[ -z "$defined" && -z "$used" ]]; then
    clia_warn "aucun type de ressource dans $(clia_dev_dir)"
    clia_hint "une definition de type vit dans $(clia_resources_dir)/RES-<SEQ>-<SLUG>.md"
    return 1
  fi

  {
    printf 'TYPE\tPREFIXE\tCYCLE\tEDITION\tDEFINITION\tINSTANCES\n'

    # Types definis, avec leur nombre d'instances constate.
    #
    # Le decompte compare le nom CANONIQUE de la definition au champ type des
    # instances, jamais le titre. Le titre est un libelle lisible ("Principe de
    # conception"), le nom canonique est ce que le frontmatter porte
    # ("principe-de-conception"). Comparer les titres faisait apparaitre deux
    # lignes pour un seul type, l'une definie a zero instance et l'autre non
    # definie : bogue constate le 2026-08-10, quatrieme manifestation de la
    # confusion entre l'affichage et l'identite.
    while IFS=$'\t' read -r title prefixe _empl cycle edition definition _statut canonique; do
      [[ -n "$title" ]] || continue
      local n
      n=$(printf '%s\n' "$used" | awk -F'\t' -v k="$canonique" \
            'tolower($1) == tolower(k) { print $2; found = 1 } END { if (!found) print 0 }')
      printf '%s\t%s\t%s\t%s\t%s\t%s\n' \
        "$title" "$prefixe" "$cycle" "$edition" "$definition" "$n"
    done <<< "$defined"

    # Types employes sans definition. Les taire serait cacher la dette que
    # NON-011 porte : ce depot emploie plus de types qu'il n'en definit.
    while IFS=$'\t' read -r t n; do
      [[ -n "$t" ]] || continue
      if ! printf '%s\n' "$defined" | awk -F'\t' -v k="$t" \
             'tolower($8) == tolower(k) { found = 1 } END { exit !found }'; then
        printf '%s\t%s\t%s\t%s\t%s\t%s\n' "$t" '?' '?' '?' 'aucune' "$n"
      fi
    done <<< "$used"
  } | column -t -s $'\t'
}

# --------------------------------------------------------------------------
# ls TYPE : les instances
# --------------------------------------------------------------------------

# Repertoire des instances d'un type, deduit du champ emplacement de sa
# definition. Le champ porte un motif, par exemple
# ".dev/objections/NON-<SEQ>-<SLUG>.md" : on n'en garde que le repertoire.
clia_resource_dir_of() {
  local emplacement="$1" dir
  dir=$(dirname "$emplacement")
  dir="${dir#./}"
  if [[ "$dir" == /* ]]; then
    printf '%s\n' "$dir"
  else
    printf '%s/%s\n' "$CLIA_REPO_ROOT_RESOLVED" "$dir"
  fi
}

# Le champ d'etat PROPRE d'un type, deduit de ses champs obligatoires.
#
# PLN-011. Motif : clia res ls affichait status, qui vaut draft dans les 163
# instances du depot, et jamais le champ qui varie. ISU-008, ouverte a la
# demande de l'humain le 2026-08-11 et redemandee le 2026-08-13.
#
# Les sept noms cherches sont ceux que DCN-016 recense dans le depot. Le
# premier trouve gagne : aucun type n'en porte deux. Onze types sur trente-
# sept en ont un ; les autres retombent sur status.
#
# Cette fonction n'attend pas DCN-016 ni les quatre champs d'etat : elle lit
# ce que chaque definition declare aujourd'hui.
clia_resource_champ_etat() {
  local definition="$1" champs c
  champs=$(clia_frontmatter_field \
             "$(clia_resources_dir)/${definition}.md" champs-obligatoires 2>/dev/null) || champs=''
  champs=$(printf '%s' "$champs" | tr -d '[]' | tr ',' '\n' | sed 's/^ *//;s/ *$//')
  for c in etat effet statut-plan statut-decision statut exploitation tenue; do
    if printf '%s\n' "$champs" | grep -qx "$c"; then
      printf '%s\n' "$c"
      return 0
    fi
  done
  printf 'status\n'
}

# --------------------------------------------------------------------------
# clia res explain : PLN-016, chantiers A a C
# --------------------------------------------------------------------------
#
# ADR-018 D2 : l'explication est DERIVEE, jamais redigee. Ses deux sources
# sont le frontmatter de la definition et le schema cue du type. Une
# documentation redigee a part se perime ; une derivation ne le peut pas.
#
# Motif, tache 14 : « c'est difficile de comprendre comment fonctionne les
# metadata de decision DCN et son cycle de vie ». Tout etait ecrit, disperse
# dans trois endroits dont un schema cue qui n'est pas fait pour etre lu.

# Les valeurs admises d'un champ enumere, lues dans le schema cue du type.
#
# PLN-016 chantier A. Le piege, mesure a la tache 11 : une declaration cue
# longue s'ecrit sur plusieurs lignes, et une lecture naive deborde sur les
# champs suivants — effet ramenait aussi attestation et diffusion. La
# declaration s'arrete a la premiere ligne qui ne se termine PAS par « | ».
clia_resource_valeurs_admises() {
  local type="$1" champ="$2" schema ligne bloc n
  schema="$(clia_dev_dir)/schemas/${type}.cue"
  [[ -f "$schema" ]] || return 1

  n=0
  while IFS= read -r ligne; do
    n=$((n + 1))
    if [[ "$ligne" =~ ^[[:space:]]*\"?${champ}\"?:[[:space:]]*(.*)$ ]]; then
      bloc="${BASH_REMATCH[1]}"
      while [[ "${bloc%"${bloc##*[![:space:]]}"}" == *\| ]]; do
        IFS= read -r ligne || break
        bloc+=" ${ligne#"${ligne%%[![:space:]]*}"}"
      done
      local valeurs
      # paste -sd', ' emploie les deux caracteres en alternance, non comme un
      # separateur unique : « a,b c,d ». Le separateur se pose apres coup.
      valeurs=$(printf '%s\n' "$bloc" | grep -oE '"[^"]+"' | tr -d '"' \
                  | paste -sd, | sed 's/,/, /g')
      # Un champ dont le schema ne donne aucune valeur litterale n'est pas
      # enumere : id, title, version renvoient a une contrainte de forme.
      # ADR-018 D4 veut qu'il s'affiche « libre », donc l'appel doit echouer.
      [[ -n "$valeurs" ]] || return 1
      printf '%s\n' "$valeurs"
      return 0
    fi
  done < "$schema"
  return 1
}

# La definition qui decrit le type d'un fichier donne.
clia_resource_definition_de() {
  local fichier="$1" type f
  type=$(clia_frontmatter_field "$fichier" type 2>/dev/null) || return 1
  [[ -n "$type" ]] || return 1

  # Une definition se decrit elle-meme : son type est « ressource ».
  for f in "$(clia_resources_dir)"/RES-*.md; do
    [[ -f "$f" ]] || continue
    if [[ "$(basename "$f" .md)" =~ ^RES-[0-9]{3}-(.*)$ ]] \
       && [[ "${BASH_REMATCH[1]}" == "$type" ]]; then
      printf '%s\n' "$f"
      return 0
    fi
  done
  return 1
}

clia_resource_explain_ligne() {
  printf '%s\t%s\n' "$1" "${2:-—}"
}

clia_resource_explain() {
  # PDC-001 : l'aide est reconnue AVANT toute validation d'argument.
  if clia_is_help "${1:-}"; then clia_resource_usage_verb explain; return 0; fi
  clia_require_repo

  local wanted="${1:-}"
  [[ -n "$wanted" ]] || { clia_resource_usage_verb explain >&2; return 2; }

  local fichier definition
  if ! fichier=$(clia_resource_find "$wanted"); then
    clia_warn "introuvable : $wanted"
    return 1
  fi

  # ADR-018 D3 : l'argument peut etre une instance ou la definition. L'humain
  # qui bute sur une decision a DCN-016 sous les yeux, pas RES-009.
  if [[ "$(clia_frontmatter_field "$fichier" type 2>/dev/null)" == "ressource" ]]; then
    definition="$fichier"
  elif ! definition=$(clia_resource_definition_de "$fichier"); then
    clia_warn "aucune definition pour le type de $wanted"
    clia_hint "un type sans definition RES n'a rien a deriver"
    return 1
  fi

  local type titre prefixe emplacement famille cycle edition
  local champs relations sections skill adr dir n
  type=$(basename "$definition" .md | sed -E 's/^RES-[0-9]{3}-//')
  titre=$(clia_frontmatter_field "$definition" title)
  prefixe=$(clia_frontmatter_field "$definition" prefixe)
  emplacement=$(clia_frontmatter_field "$definition" emplacement)
  famille=$(clia_frontmatter_field "$definition" famille)
  cycle=$(clia_frontmatter_field "$definition" cycle-de-vie)
  edition=$(clia_frontmatter_field "$definition" edition)
  champs=$(clia_frontmatter_field "$definition" champs-obligatoires)
  relations=$(clia_frontmatter_field "$definition" relations-admissibles)
  sections=$(clia_frontmatter_field "$definition" sections)
  skill=$(clia_frontmatter_field "$definition" skill)
  adr=$(clia_frontmatter_field "$definition" adr)

  dir=$(clia_resource_dir_of "$emplacement")
  n=$(find -L "$dir" -maxdepth 1 -type f -name "${prefixe}-*.md" 2>/dev/null | grep -c '') || n=0

  printf '%s — %s\n\n' "$titre" "$type"

  {
    clia_resource_explain_ligne 'prefixe' "$prefixe"
    clia_resource_explain_ligne 'emplacement' "$emplacement"
    clia_resource_explain_ligne 'famille' "$famille"
    clia_resource_explain_ligne 'cycle de vie' "$cycle"
    clia_resource_explain_ligne 'edition' "$edition"
    clia_resource_explain_ligne 'instances' "$n"
    clia_resource_explain_ligne 'skill' "$skill"
    clia_resource_explain_ligne 'adr' "$adr"
    clia_resource_explain_ligne 'definition' "${definition#"$CLIA_REPO_ROOT_RESOLVED"/}"
  } | column -t -s $'\t'

  # ADR-018 D4 : un champ que le schema ne contraint pas s'affiche « libre »,
  # jamais omis. Une definition mal remplie doit se voir.
  printf '\nCHAMPS OBLIGATOIRES\n'
  {
    printf 'CHAMP\tVALEURS ADMISES\n'
    local c valeurs
    # « || [[ -n "$c" ]] » : le dernier champ n'est pas suivi d'un saut de
    # ligne, et read echoue en le lisant. Sans cette garde, diffusion — le
    # dernier champ obligatoire de la decision — disparaissait de la sortie.
    while IFS= read -r c || [[ -n "$c" ]]; do
      [[ -n "$c" ]] || continue
      if valeurs=$(clia_resource_valeurs_admises "$type" "$c"); then
        printf '%s\t%s\n' "$c" "$valeurs"
      else
        printf '%s\t%s\n' "$c" 'libre'
      fi
    done < <(printf '%s' "$champs" | tr -d '[]' | tr ',' '\n' | sed 's/^ *//;s/ *$//')
  } | column -t -s $'\t'

  # domain-status n'est pas declare dans le schema du type : commun.cue le
  # porte comme une chaine libre, et ce sont les RES qui en declarent
  # l'enumeration. DCN-016 pose qu'il REPREND les valeurs du champ propre du
  # type — effet pour la decision, etat pour l'objection. C'est donc la que
  # ses valeurs se lisent.
  local propre ds
  propre=$(clia_resource_champ_etat "$(basename "$definition" .md)")
  if [[ -n "$propre" && "$propre" != "status" ]] \
     && ds=$(clia_resource_valeurs_admises "$type" "$propre"); then
    printf '\ndomain-status : %s\n' "$ds"
    printf '                reprises du champ %s, DCN-016\n' "$propre"
  fi

  [[ -n "$relations" ]] && printf '\nrelations admissibles : %s\n' "$relations"
  [[ -n "$sections" ]] && printf 'sections attendues    : %s\n' "$sections"

  clia_hint "clia res show $(basename "$definition" .md | grep -oE '^RES-[0-9]{3}') pour le sens, les frontieres et les objections"
  return 0
}

clia_resource_ls_instances() {
  if clia_is_help "${1:-}"; then clia_resource_usage_verb ls; return 0; fi
  clia_require_repo
  local wanted="$1" line
  if ! line=$(clia_type_resolve "$wanted"); then
    clia_warn "type inconnu : $wanted"
    clia_hint "clia res ls affiche les types connus"
    return 1
  fi

  local title prefixe emplacement cycle edition definition statut
  IFS=$'\t' read -r title prefixe emplacement cycle edition definition statut <<< "$line"

  local dir
  dir=$(clia_resource_dir_of "$emplacement")
  if [[ ! -d "$dir" ]]; then
    clia_warn "aucune instance : $dir n'existe pas"
    return 0
  fi

  local champ_etat entete
  champ_etat=$(clia_resource_champ_etat "$definition")
  entete=$(printf '%s' "$champ_etat" | tr '[:lower:]-' '[:upper:]_')

  {
    printf 'ID\tDESCRIPTION\t%s\n' "$entete"
    local file base id desc status
    while IFS= read -r file; do
      base=$(basename "$file" .md)
      # ID affiche : prefixe et discriminant, qui forment l'adresse du
      # fichier. Le discriminant est une sequence a trois chiffres pour les
      # cycles vivant et travail, une date ISO pour le cycle point-fixe : les
      # deux formes doivent etre reconnues, faute de quoi une date est
      # tronquee a ses trois premiers chiffres.
      # L'identifiant stable du frontmatter est un autre objet ; voir NON-001
      # sur cette divergence.
      id=$(printf '%s' "$base" \
        | sed -E "s/^(${prefixe}-([0-9]{4}-[0-9]{2}-[0-9]{2}|[0-9]{3})).*/\1/")
      [[ -n "$id" ]] || id="$base"
      desc=$(clia_frontmatter_field "$file" title 2>/dev/null) || desc=''
      status=$(clia_frontmatter_field "$file" "$champ_etat" 2>/dev/null) || status=''
      printf '%s\t%s\t%s\n' "$id" "${desc:-?}" "${status:-?}"
    done < <(find -L "$dir" -maxdepth 1 -type f -name "${prefixe}-*.md" 2>/dev/null | sort)
  } | column -t -s $'\t'
}

# --------------------------------------------------------------------------
# new TYPE DESCRIPTION
# --------------------------------------------------------------------------

clia_resource_next_seq() {
  local dir="$1" prefixe="$2" max
  max=$(find -L "$dir" -maxdepth 1 -type f -name "${prefixe}-*.md" 2>/dev/null \
        | sed -E "s#.*/${prefixe}-([0-9]{3}).*#\1#" \
        | grep -E '^[0-9]{3}$' | sort -n | tail -1)
  printf '%03d\n' $(( 10#${max:-0} + 1 ))
}

clia_resource_new() {
  if clia_is_help "${1:-}"; then clia_resource_usage_verb new; return 0; fi
  clia_require_repo
  local wanted="$1"; shift
  local description="$*"

  [[ -n "$wanted" ]]      || { clia_resource_usage >&2; return 2; }
  [[ -n "$description" ]] || { clia_warn "description manquante"; return 2; }

  local line
  if ! line=$(clia_type_resolve "$wanted"); then
    clia_warn "type sans definition : $wanted"
    clia_hint "clia refuse de creer une instance d'un type non defini :"
    clia_hint "la premiere instance ferait precedent (skl-001-ressource, regle A5)"
    clia_hint "definissez le type dans $(clia_resources_dir), ou ouvrez une objection"
    return 1
  fi

  local title prefixe emplacement cycle edition definition statut
  IFS=$'\t' read -r title prefixe emplacement cycle edition definition statut <<< "$line"

  if [[ "$statut" == "deprecie" || "$statut" == "non-installe" ]]; then
    clia_warn "le type $title porte le statut $statut"
    return 1
  fi

  local dir slug
  dir=$(clia_resource_dir_of "$emplacement")
  slug=$(clia_slug "$description")
  [[ -n "$slug" ]] || { clia_warn "la description ne produit aucun slug"; return 2; }

  mkdir -p "$dir"

  # ADR-007 D4 : le nommage date est aboli. Tous les types se nomment
  # <PREFIX>-<SEQ>-<SLUG>.md, quel que soit leur cycle de vie. Le cycle ne
  # commande plus que le versionnage.
  #
  # Bogue constate le 2026-08-11 : la forme datee subsistait pour les types
  # point-fixe, et elle a produit FRG-2026-08-11, non conforme des sa
  # creation, sur un fichier de l'humain.
  local discriminant
  discriminant=$(clia_resource_next_seq "$dir" "$prefixe")

  local file="$dir/${prefixe}-${discriminant}-${slug}.md"
  if [[ -e "$file" ]]; then
    clia_warn "existe deja : ${file#$CLIA_REPO_ROOT_RESOLVED/}"
    return 1
  fi
  # Un slug deja employe sous un autre numero est presque toujours un doublon.
  local jumeau
  jumeau=$(find -L "$dir" -maxdepth 1 -type f -name "${prefixe}-*-${slug}.md" 2>/dev/null | head -1)
  if [[ -n "$jumeau" ]]; then
    clia_warn "un slug identique existe : ${jumeau#$CLIA_REPO_ROOT_RESOLVED/}"
    clia_hint "changez la description, ou modifiez la ressource existante"
    return 1
  fi

  # Le nom canonique du type vient du slug du nom de fichier de sa definition,
  # jamais de son id ni de son titre. Depuis ADR-007, l'id d'une definition
  # vaut RES-<SEQ> et son suffixe est un numero : le deduire de l'id produisait
  # type: 009 au lieu de type: decision. Bogue constate le 2026-08-10, corrige
  # le 2026-08-11 sur un gabarit destine a l'humain.
  local type_canonique
  type_canonique="${definition#*-*-}"
  [[ -n "$type_canonique" ]] || type_canonique=$(printf '%s' "$title" | tr '[:upper:]' '[:lower:]')

  # Les champs a poser sont ceux que la definition declare obligatoires, non une
  # liste fixe. Sans cela, l'instance produite est non conforme des sa creation :
  # bogue constate le 2026-08-10 sur NON-013, cree la veille par cette commande.
  local champs
  champs=$(clia_frontmatter_field "$(clia_resources_dir)/${definition}.md" champs-obligatoires 2>/dev/null)
  champs=$(printf '%s' "$champs" | tr -d '[]' | tr ',' '\n' | sed 's/^ *//;s/ *$//')
  [[ -n "$champs" ]] || champs=$(printf 'type\nid\ntitle\nstatus\n')

  # L'id est l'alias interne, <PREFIX>-<SEQ>, jamais <PREFIX>-<SLUG> : ADR-008
  # D2, et ADR-007 D1 avant lui, qui abolit la forme a slug.
  local id="${prefixe}-${discriminant}"
  local sections
  sections=$(clia_frontmatter_field "$(clia_resources_dir)/${definition}.md" sections 2>/dev/null)

  {
    printf -- '---\n'
    local c
    while IFS= read -r c; do
      [[ -n "$c" ]] || continue
      case "$c" in
        type)    printf 'type: %s\n' "$type_canonique" ;;
        id)      printf 'id: %s\n' "$id" ;;
        title)   printf 'title: "%s"\n' "$description" ;;
        name)    printf 'name: %s\n' "${prefixe}-${discriminant}-${slug}" ;;
        status)  printf 'status: draft\n' ;;
        version) printf 'version: 0.1.0\n' ;;
        date*)   printf '%s: %s\n' "$c" "$(date +%Y-%m-%d)" ;;
        aucun*)  ;;
        *)       printf '%s: À RENSEIGNER\n' "$c" ;;
      esac
    done <<< "$champs"
    printf -- '---\n'
    printf '\n'
    printf '# %s-%s - %s\n' "$prefixe" "$discriminant" "$description"
    printf '\n'
    printf '> À rédiger.\n'
    if [[ -n "$sections" ]]; then
      printf '%s' "$sections" | tr -d '[]' | tr ',' '\n' | sed 's/^ *//;s/ *$//' \
        | while IFS= read -r sec; do
            [[ -n "$sec" ]] || continue
            printf '\n## %s\n' "$sec"
          done
    else
      printf '\n## Relations\n'
    fi
  } > "$file"

  # La sortie de donnees va sur stdout : le chemin, seul, est utilisable par
  # une autre commande.
  printf '%s\n' "$file"
  clia_warn "cree : ${file#$CLIA_REPO_ROOT_RESOLVED/}"
  clia_hint "clia ne redige pas le contenu : c'est le travail de l'agent ou de l'humain"
  if [[ -n "$definition" && "$definition" != "aucune" ]]; then
    clia_hint "consultez $definition avant de rediger"
  fi
  return 0
}

# --------------------------------------------------------------------------
# Resolution d'un identifiant
# --------------------------------------------------------------------------
#
# Accepte trois formes, dans cet ordre :
#   RES-001         prefixe et numero de sequence
#   RES-ressource   identifiant stable du frontmatter (ADR-001 D3)
#   001             numero seul, si un seul type correspond

clia_resource_find() {
  local wanted="$1" matches

  # Les archives sont exclues de toutes les recherches : elles portent l'etat
  # revolu du depot.
  # Forme prefixe-sequence ou prefixe-slug, cherchee dans le nom de fichier.
  matches=$(clia_dev_files | grep -E "/${wanted}[^/]*\.md$" || true)

  # Sinon, recherche par identifiant stable dans les frontmatter.
  if [[ -z "$matches" ]]; then
    local file id
    while IFS= read -r file; do
      id=$(clia_frontmatter_field "$file" id 2>/dev/null) || continue
      if [[ "$id" == "$wanted" ]]; then
        matches="$file"
        break
      fi
    done < <(clia_dev_files)
  fi

  # Sinon, numero seul.
  if [[ -z "$matches" && "$wanted" =~ ^[0-9]{1,3}$ ]]; then
    local seq
    seq=$(printf '%03d' "$((10#$wanted))")
    matches=$(clia_dev_files | grep -E "/[A-Za-z]+-${seq}-[^/]*\.md$" || true)
  fi

  [[ -n "$matches" ]] || return 1

  local count
  count=$(printf '%s\n' "$matches" | grep -c '')
  if (( count > 1 )); then
    clia_warn "identifiant ambigu : $wanted"
    printf '%s\n' "$matches" | sed "s#^$CLIA_REPO_ROOT_RESOLVED/#      #" >&2
    return 1
  fi

  printf '%s\n' "$matches"
}

clia_resource_show() {
  if clia_is_help "${1:-}"; then clia_resource_usage_verb show; return 0; fi
  clia_require_repo
  local wanted="${1:-}"
  [[ -n "$wanted" ]] || { clia_resource_usage >&2; return 2; }
  local file
  if ! file=$(clia_resource_find "$wanted"); then
    clia_warn "introuvable : $wanted"
    return 1
  fi
  cat "$file"
}

clia_resource_edit() {
  if clia_is_help "${1:-}"; then clia_resource_usage_verb edit; return 0; fi
  clia_require_repo
  local wanted="${1:-}"
  [[ -n "$wanted" ]] || { clia_resource_usage >&2; return 2; }
  local file
  if ! file=$(clia_resource_find "$wanted"); then
    clia_warn "introuvable : $wanted"
    return 1
  fi
  local editor="${CLIA_EDITOR:-${VISUAL:-${EDITOR:-vi}}}"
  command -v "${editor%% *}" >/dev/null 2>&1 \
    || clia_die "editeur introuvable : $editor (voir clia config set EDITOR)"
  "$editor" "$file"
}

# --------------------------------------------------------------------------
# check : un champ obligatoire dont toutes les instances portent la meme
# valeur
# --------------------------------------------------------------------------
#
# PLN-007 chantier G. Motif : status a valu draft dans les cent cinquante-
# sept instances du depot pendant trois jours, et rien ne le signalait.
# NON-035 l'a mesure a la main ; ce controle le mesure a chaque appel.
#
# Independant de DCN-016 : il ne pose ni ne suppose les quatre champs
# qu'elle declare, seulement une regle generale sur n'importe quel champ
# obligatoire d'un type deja defini.
#
# Ce n'est pas clia validate, que ISU-007 reclame : un seul controle, pas les
# dix V1 a V10 ni la validation de schema. Un premier pas, pas l'outil entier.

clia_resource_check() {
  if clia_is_help "${1:-}"; then clia_resource_usage_verb check; return 0; fi
  clia_require_repo

  local defined
  defined=$(clia_types_defined)

  local rapport=''
  local title prefixe emplacement cycle edition definition statut canonique
  while IFS=$'\t' read -r title prefixe emplacement cycle edition definition statut canonique; do
    [[ -n "$title" ]] || continue
    if [[ -n "${1:-}" ]]; then
      local voulu
      voulu=$(printf '%s' "$1" | tr '[:upper:]' '[:lower:]')
      [[ "$(printf '%s' "$canonique" | tr '[:upper:]' '[:lower:]')" == "$voulu" \
         || "$(printf '%s' "$prefixe" | tr '[:upper:]' '[:lower:]')" == "$voulu" ]] || continue
    fi

    local dir
    dir=$(clia_resource_dir_of "$emplacement")
    [[ -d "$dir" ]] || continue

    local -a fichiers=()
    while IFS= read -r f; do fichiers+=("$f"); done \
      < <(find -L "$dir" -maxdepth 1 -type f -name "${prefixe}-*.md" 2>/dev/null | sort)
    local n=${#fichiers[@]}
    (( n >= 2 )) || continue

    local champs
    champs=$(clia_frontmatter_field "$(clia_resources_dir)/${definition}.md" champs-obligatoires 2>/dev/null)
    champs=$(printf '%s' "$champs" | tr -d '[]' | tr ',' '\n' | sed 's/^ *//;s/ *$//')

    local champ
    while IFS= read -r champ; do
      [[ -n "$champ" ]] || continue
      # type est constant par construction : c'est ce qui definit le type,
      # pas un defaut a signaler.
      [[ "$champ" == "type" ]] && continue

      local -a valeurs=()
      local f v
      for f in "${fichiers[@]}"; do
        v=$(clia_frontmatter_field "$f" "$champ" 2>/dev/null) || v=''
        valeurs+=("$v")
      done

      local unique
      unique=$(printf '%s\n' "${valeurs[@]}" | sort -u | grep -c '')
      if (( unique == 1 )); then
        rapport+="${canonique}	${champ}	${valeurs[0]:-(vide)}	${n}
"
      fi
    done <<< "$champs"
  done <<< "$defined"

  if [[ -z "$rapport" ]]; then
    clia_warn "aucun champ obligatoire constant trouve"
    return 0
  fi

  { printf 'TYPE\tCHAMP\tVALEUR\tINSTANCES\n'; printf '%s' "$rapport"; } \
    | column -t -s $'\t'
  clia_warn "un champ constant sur toutes les instances n'apprend rien : voir ISU-008"
  return 1
}

# --------------------------------------------------------------------------
# Dispatch
# --------------------------------------------------------------------------

clia_resource_main() {
  local verb="${1:-}"
  [[ $# -gt 0 ]] && shift
  case "$verb" in
    ls|list)
      if clia_is_help "${1:-}"; then clia_resource_usage_verb ls
      elif [[ $# -eq 0 ]]; then clia_resource_ls_types
      else clia_resource_ls_instances "$1"; fi ;;
    new|create)   clia_resource_new "$@" ;;
    show|cat)     clia_resource_show "$@" ;;
    explain|help) clia_resource_explain "$@" ;;
    edit)         clia_resource_edit "$@" ;;
    check)        clia_resource_check "$@" ;;
    ''|-h|--help|help) clia_resource_usage ;;
    *)
      clia_warn "verbe inconnu : $verb"
      clia_resource_usage >&2
      return 2 ;;
  esac
}
