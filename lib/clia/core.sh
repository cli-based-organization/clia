#!/usr/bin/env bash
# core.sh - Fonctions communes de clia.
#
# Ce module ne produit aucune sortie a l'import. Il fournit :
#   - la resolution du contexte-repertoire (repo courant, distinct de CLIA_HOME)
#   - le chargement de la configuration
#   - la lecture du frontmatter YAML
#   - la derivation des types de ressources depuis leurs definitions
#   - les utilitaires de sortie et d'erreur
#
# Voir ADR-003 pour les decisions que ce code applique.

# --------------------------------------------------------------------------
# Sortie et erreurs
# --------------------------------------------------------------------------

# Les messages destines a l'humain vont sur stderr, les donnees sur stdout.
# Cela rend toute sortie de donnees analysable par un programme sans filtrage.

clia_die() {
  printf 'clia: %s\n' "$*" >&2
  exit 1
}

clia_warn() {
  printf 'clia: %s\n' "$*" >&2
}

clia_hint() {
  printf '      %s\n' "$*" >&2
}

# --------------------------------------------------------------------------
# Aide
# --------------------------------------------------------------------------
#
# Une demande d'aide doit etre reconnue AVANT toute validation d'arguments.
# Sans cela, `clia res new -h` repond "description manquante", ce qui rend la
# commande indecouvrable : bogue signale le 2026-08-10, present sur six des
# sept verbes.
#
# Voir PDC-001 : l'auto-decouvrabilite est un principe de conception, et sa
# violation est un defaut.

clia_is_help() {
  case "${1:-}" in
    -h|--help|help|'-?') return 0 ;;
    *) return 1 ;;
  esac
}

# --------------------------------------------------------------------------
# Contexte-repertoire
# --------------------------------------------------------------------------
#
# Deux racines distinctes, et les confondre est un bogue deja constate dans
# ce depot (session du 2026-07-31, tache 1) :
#
#   CLIA_HOME      ou vit clia lui-meme (sources, gabarits)
#   CLIA_REPO_ROOT le depot sur lequel on travaille, determine a l'execution
#                  depuis le repertoire courant
#
# CLIA_HOME est fixe par setup.sh. CLIA_REPO_ROOT est resolu a chaque appel.

clia_resolve_repo_root() {
  # Une valeur fournie par l'environnement ou la configuration a preseance.
  if [[ -n "${CLIA_REPO_ROOT:-}" ]]; then
    printf '%s\n' "$CLIA_REPO_ROOT"
    return 0
  fi

  local dir
  dir=$(pwd -P)

  # Premier marqueur cherche : le repertoire de developpement du systeme.
  local probe="$dir"
  while [[ "$probe" != "/" ]]; do
    if [[ -d "$probe/${CLIA_DEV_DIR_NAME:-.dev}" ]]; then
      printf '%s\n' "$probe"
      return 0
    fi
    probe=$(dirname "$probe")
  done

  # Second marqueur : la racine du depot git.
  if git -C "$dir" rev-parse --show-toplevel >/dev/null 2>&1; then
    git -C "$dir" rev-parse --show-toplevel
    return 0
  fi

  return 1
}

# --------------------------------------------------------------------------
# Configuration
# --------------------------------------------------------------------------
#
# Trois niveaux, du plus faible au plus fort :
#   1. les valeurs par defaut de ce fichier
#   2. le fichier de configuration de l'utilisateur (convention XDG)
#   3. l'environnement
#
# Le fichier est sourcable : une ligne CLE=valeur par variable.

clia_config_file() {
  printf '%s/clia/config\n' "${XDG_CONFIG_HOME:-$HOME/.config}"
}

# Liste des variables reconnues, avec leur valeur par defaut.
# Une variable non listee ici reste assignable : la liste sert a l'affichage
# et a la documentation, pas a restreindre.
clia_config_keys() {
  cat <<'EOF'
CLIA_EDITOR
CLIA_DEV_DIR_NAME
CLIA_RESOURCES_DIR_NAME
CLIA_EXCLUDE_DIRS
CLIA_REPO_ROOT
EOF
}

clia_config_default() {
  case "$1" in
    CLIA_EDITOR)              printf '%s\n' "${VISUAL:-${EDITOR:-vi}}" ;;
    CLIA_DEV_DIR_NAME)        printf '.dev\n' ;;
    CLIA_RESOURCES_DIR_NAME)  printf 'ressources\n' ;;
    CLIA_EXCLUDE_DIRS)        printf 'archives,templates\n' ;;
    CLIA_REPO_ROOT)           printf '\n' ;;
    *)                        printf '\n' ;;
  esac
}

# Origine effective d'une variable : environment, file, ou default.
# Renseignee par clia_config_load dans CLIA_ORIGIN_<CLE>.
clia_config_load() {
  local key value file
  file=$(clia_config_file)

  # Memoriser ce qui vient de l'environnement avant de charger le fichier.
  while read -r key; do
    if [[ -n "${!key:-}" ]]; then
      eval "CLIA_ORIGIN_${key}=environment"
    fi
  done < <(clia_config_keys)

  if [[ -f "$file" ]]; then
    # Lecture ligne a ligne plutot que source : on refuse d'executer du code
    # arbitraire depuis un fichier de configuration.
    while IFS='=' read -r key value; do
      [[ "$key" =~ ^[[:space:]]*# ]] && continue
      [[ -z "${key// }" ]] && continue
      key="${key// }"
      [[ "$key" =~ ^[A-Za-z_][A-Za-z0-9_]*$ ]] || continue
      # L'environnement a preseance sur le fichier.
      if [[ -z "${!key:-}" ]]; then
        value="${value%\"}"; value="${value#\"}"
        value="${value%\'}"; value="${value#\'}"
        eval "export ${key}=\"\$value\""
        eval "CLIA_ORIGIN_${key}=file"
      fi
    done < "$file"
  fi

  # Combler par les valeurs par defaut.
  while read -r key; do
    if [[ -z "${!key:-}" ]]; then
      local def
      def=$(clia_config_default "$key")
      [[ -n "$def" ]] && eval "export ${key}=\"\$def\""
      eval ": \"\${CLIA_ORIGIN_${key}:=default}\""
    fi
  done < <(clia_config_keys)
}

clia_config_origin() {
  local var="CLIA_ORIGIN_$1"
  printf '%s\n' "${!var:-default}"
}

# --------------------------------------------------------------------------
# Chemins derives
# --------------------------------------------------------------------------

clia_dev_dir() {
  printf '%s/%s\n' "$CLIA_REPO_ROOT_RESOLVED" "${CLIA_DEV_DIR_NAME:-.dev}"
}

clia_resources_dir() {
  printf '%s/%s\n' "$(clia_dev_dir)" "${CLIA_RESOURCES_DIR_NAME:-ressources}"
}

clia_require_repo() {
  if [[ -z "${CLIA_REPO_ROOT_RESOLVED:-}" ]]; then
    clia_warn "aucun depot clia trouve depuis $(pwd -P)"
    clia_hint "un depot clia porte un repertoire ${CLIA_DEV_DIR_NAME:-.dev}/"
    clia_hint "creez-le, ou lancez clia depuis un depot equipe"
    exit 1
  fi
}

# --------------------------------------------------------------------------
# Frontmatter
# --------------------------------------------------------------------------
#
# Un frontmatter est delimite par deux lignes contenant exactement ---, la
# premiere en ligne 1. On ne lit qu'un sous-ensemble de YAML : des paires
# cle: valeur sur une ligne. C'est suffisant pour les champs que le modele
# rend obligatoires, et cela evite une dependance a un analyseur YAML.

clia_frontmatter_field() {
  local file="$1" field="$2"
  [[ -f "$file" ]] || return 1
  awk -v field="$field" '
    NR == 1 && $0 != "---" { exit 1 }
    NR == 1 { next }
    /^---[[:space:]]*$/ { exit }
    {
      idx = index($0, ":")
      if (idx == 0) next
      key = substr($0, 1, idx - 1)
      gsub(/^[[:space:]]+|[[:space:]]+$/, "", key)
      if (key != field) next
      val = substr($0, idx + 1)
      gsub(/^[[:space:]]+|[[:space:]]+$/, "", val)
      gsub(/^"|"$/, "", val)
      gsub(/^'"'"'|'"'"'$/, "", val)
      print val
      exit
    }
  ' "$file"
}

# --------------------------------------------------------------------------
# Slug
# --------------------------------------------------------------------------
#
# Derive un slug d'une description en francais : translitteration des
# accents, minuscules, separateurs reduits a un trait d'union.

clia_slug() {
  local text="$*" slug
  slug=$(printf '%s' "$text" | iconv -f UTF-8 -t ASCII//TRANSLIT 2>/dev/null) \
    || slug="$text"
  slug=$(printf '%s' "$slug" \
    | tr '[:upper:]' '[:lower:]' \
    | sed -e "s/['\`]/ /g" \
          -e 's/[^a-z0-9]\+/-/g' \
          -e 's/^-\+//' -e 's/-\+$//' \
          -e 's/-\{2,\}/-/g')
  printf '%s\n' "$slug"
}

# --------------------------------------------------------------------------
# Types de ressources
# --------------------------------------------------------------------------
#
# ADR-003 D7 : clia lit les types dans une source machine-lisible derivee
# des definitions, et non dans une table redigee pour un lecteur humain.
# La derivation est faite ici, a la lecture, sans fichier intermediaire :
# c'est le moyen le moins couteux d'eviter une source parallele.
#
# Sortie, un type par ligne, champs separes par une tabulation :
#   type  prefixe  emplacement  cycle-de-vie  edition  definition  statut  canonique
#
# La huitieme colonne est le slug du nom de fichier de la definition, c'est-a-dire
# le nom canonique du type, sans accent. C'est la valeur que porte le champ type
# des instances, et celle qu'un humain tape au clavier. Sans elle, "decision" ne
# resolvait pas le type intitule "Décision" : bogue constate le 2026-08-10.

clia_types_defined() {
  local dir file base
  dir=$(clia_resources_dir)
  [[ -d "$dir" ]] || return 0
  while IFS= read -r file; do
    base=$(basename "$file")
    # Une definition de type porte un numero de sequence. index.md n'en est
    # pas une : c'est une vue.
    [[ "$base" =~ ^RES-[0-9]{3}- ]] || continue
    local title prefixe emplacement cycle edition statut
    title=$(clia_frontmatter_field "$file" title)
    prefixe=$(clia_frontmatter_field "$file" prefixe)
    emplacement=$(clia_frontmatter_field "$file" emplacement)
    cycle=$(clia_frontmatter_field "$file" cycle-de-vie)
    edition=$(clia_frontmatter_field "$file" edition)
    statut=$(clia_frontmatter_field "$file" statut)
    [[ -n "$prefixe" ]] || continue
    # Le nom canonique du type vient du SLUG DU NOM DE FICHIER, non de l'id.
    # Depuis ADR-007, l'id est <PREFIX>-<SEQ> et ne porte plus de slug : le
    # deriver de l'id donnerait un numero. Le nom de fichier, lui, porte
    # <PREFIX>-<SEQ>-<SLUG>, et le slug est le nom canonique du type.
    local canonique
    canonique=$(printf '%s' "${base%.md}" | sed -E 's/^[A-Za-z]{2,4}-[0-9]{3}-//')
    printf '%s\t%s\t%s\t%s\t%s\t%s\t%s\t%s\n' \
      "${title:-?}" "$prefixe" "${emplacement:-?}" "${cycle:-?}" \
      "${edition:-?}" "${base%.md}" "${statut:-?}" "${canonique:-?}"
  done < <(find "$dir" -maxdepth 1 -type f -name 'RES-*.md' | sort)
}

# Repertoires du depot de developpement exclus des parcours.
#
# archives  : l'etat revolu du depot. Les compter comme instances actives
#             fausse tout denombrement. Bogue constate le 2026-08-09, ou 14 ADR
#             archives etaient comptes parmi les 3 ADR actifs.
# templates : des squelettes destines a etre copies, que RES-001 place
#             explicitement hors du modele de ressources. Un gabarit porte le
#             champ type de son type et serait compte comme une instance.
#             Bogue constate le 2026-08-10. C'est la reponse d'implementation a
#             la question Q6 de NON-012.
clia_excluded_dirs() {
  printf '%s\n' "${CLIA_EXCLUDE_DIRS:-archives}" | tr ',' '\n' | sed '/^$/d'
}

# Liste les fichiers markdown du depot de developpement, archives exclues.
clia_dev_files() {
  local dev
  dev=$(clia_dev_dir)
  [[ -d "$dev" ]] || return 0
  local -a prune=()
  local d
  while read -r d; do
    prune+=( -path "$dev/$d" -prune -o )
  done < <(clia_excluded_dirs)
  find "$dev" "${prune[@]}" -type f -name '*.md' -print 2>/dev/null | sort
}

# Types effectivement employes dans le depot, deduits du champ type des
# frontmatter. Sortie : type<TAB>nombre d'instances.
#
# Cette fonction existe parce que le depot emploie plus de types qu'il n'en
# definit (voir NON-011). Les rendre visibles est le role de l'outil.

clia_types_used() {
  local file t
  # Le decompte est fait en awk et non par uniq -c : une valeur de type
  # comportant une espace, comme "harnais IA", serait scindee au reformatage.
  while IFS= read -r file; do
    t=$(clia_frontmatter_field "$file" type 2>/dev/null) || continue
    [[ -n "$t" ]] && printf '%s\n' "$t"
  done < <(clia_dev_files) \
    | awk '
        { count[$0]++ }
        END { for (t in count) printf "%s\t%s\n", t, count[t] }
      ' | sort
}

# Resout un identifiant de type : nom du type ou prefixe, sans distinction de
# casse. Affiche la ligne de type correspondante, ou echoue.
#
# L'awk ne sort pas au premier match : il lit toute son entree. Sortir plus
# tot ferme le tube et fait recevoir SIGPIPE au producteur, ce que pipefail
# transforme en echec du pipeline entier. Bogue constate au premier essai.
clia_type_resolve() {
  local wanted="$1" lower alt
  lower=$(printf '%s' "$wanted" | tr '[:upper:]' '[:lower:]')

  # Tolerance du singulier et du pluriel. Le type nomme "Faits" doit repondre
  # a "fait", comme kubectl repond a pod et a pods. Sans cela, le nom exact du
  # champ title devient une devinette.
  if [[ "$lower" == *s ]]; then alt="${lower%s}"; else alt="${lower}s"; fi

  clia_types_defined | awk -F'\t' -v w="$lower" -v a="$alt" '
    !found {
      t = tolower($1); p = tolower($2); c = tolower($8)
      if (t == w || p == w || c == w) { line = $0; found = 1; next }
      if (t == a || p == a || c == a) { fallback = $0; hasfallback = 1 }
    }
    END {
      if (found) { print line; exit 0 }
      if (hasfallback) { print fallback; exit 0 }
      exit 1
    }
  '
}
