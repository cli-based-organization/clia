#!/usr/bin/env bash
# config.sh - Commande clia configuration.
#
# La configuration est celle de l'utilisateur, non celle du depot : elle vit
# donc a l'emplacement prescrit par la convention XDG et non dans le depot.
# Un depot equipe reste ainsi identique d'un poste a l'autre.
#
# Le fichier n'est jamais source : il est lu ligne a ligne. Un fichier de
# configuration ne doit pas pouvoir executer du code.

clia_config_usage() {
  cat <<'EOF'
Usage : clia configuration|config|c <verbe> [arguments]

Verbes :
  ls                affiche les variables, leur valeur et leur origine
  set CLE VALEUR    assigne une variable dans le fichier de configuration
  edit              ouvre le fichier de configuration avec CLIA_EDITOR
  path              affiche le chemin du fichier de configuration

La cle s'ecrit avec ou sans le prefixe CLIA_, indifferemment :
  clia config set EDITOR nvim
  clia config set CLIA_EDITOR nvim

Origines possibles, de la plus forte a la plus faible :
  environment   variable exportee dans le shell
  file          fichier de configuration
  default       valeur par defaut de clia

Aide detaillee d'un verbe :
  clia config ls --help
  clia config set --help
  clia config edit --help
  clia config path --help
EOF
}

clia_config_usage_verb() {
  case "$1" in
    ls) cat <<'EOF'
Usage : clia configuration ls

Affiche les variables reconnues, leur valeur effective et leur origine.

Origines, de la plus forte a la plus faible :
  environment   variable exportee dans le shell courant
  file          fichier de configuration de l'utilisateur
  default       valeur par defaut de clia

Les variables presentes dans le fichier mais inconnues de clia sont
affichees avec la mention "file (inconnue)", afin qu'une faute de frappe ne
reste pas invisible.

Alias : list
EOF
;;
    set) cat <<'EOF'
Usage : clia configuration set CLE VALEUR

Assigne une variable dans le fichier de configuration de l'utilisateur.

La cle s'ecrit avec ou sans le prefixe CLIA_, indifferemment :
  clia config set EDITOR nvim
  clia config set CLIA_EDITOR nvim

Variables reconnues :
  CLIA_EDITOR              editeur employe par res edit et config edit
  CLIA_DEV_DIR_NAME        nom du repertoire de developpement, defaut .dev
  CLIA_RESOURCES_DIR_NAME  nom du repertoire des definitions
  CLIA_EXCLUDE_DIRS        repertoires exclus des parcours, defaut archives
  CLIA_REPO_ROOT           force le depot de travail

Une cle inconnue est enregistree et signalee : aucune commande ne la lira.
Pour vider une variable : clia config set CLE ''

Le fichier est reecrit de maniere atomique, et jamais execute.
EOF
;;
    edit) cat <<'EOF'
Usage : clia configuration edit

Ouvre le fichier de configuration avec l'editeur declare par CLIA_EDITOR.
Le fichier est cree s'il n'existe pas.
EOF
;;
    path) cat <<'EOF'
Usage : clia configuration path

Affiche le chemin du fichier de configuration, selon la convention XDG :
  $XDG_CONFIG_HOME/clia/config, a defaut ~/.config/clia/config
EOF
;;
  esac
}

clia_config_normalize_key() {
  local key
  key=$(printf '%s' "$1" | tr '[:lower:]' '[:upper:]' | tr -c 'A-Z0-9_' '_')
  key="${key%_}"
  [[ "$key" == CLIA_* ]] || key="CLIA_${key}"
  printf '%s\n' "$key"
}

clia_config_ls() {
  if clia_is_help "${1:-}"; then clia_config_usage_verb ls; return 0; fi
  local file
  file=$(clia_config_file)

  {
    printf 'CLE\tVALEUR\tORIGINE\n'
    local key value origin
    while read -r key; do
      value="${!key:-}"
      origin=$(clia_config_origin "$key")
      printf '%s\t%s\t%s\n' "$key" "${value:-(vide)}" "$origin"
    done < <(clia_config_keys)

    # Variables presentes dans le fichier mais hors de la liste connue.
    # Les afficher evite qu'une faute de frappe reste invisible.
    if [[ -f "$file" ]]; then
      while IFS='=' read -r key value; do
        [[ "$key" =~ ^[[:space:]]*# ]] && continue
        key="${key// }"
        [[ -n "$key" ]] || continue
        [[ "$key" =~ ^[A-Za-z_][A-Za-z0-9_]*$ ]] || continue
        if ! clia_config_keys | grep -qx "$key"; then
          printf '%s\t%s\t%s\n' "$key" "$value" 'file (inconnue)'
        fi
      done < "$file"
    fi
  } | column -t -s $'\t'

  clia_warn "fichier : $file$([[ -f "$file" ]] || printf ' (absent)')"
}

clia_config_set() {
  if clia_is_help "${1:-}"; then clia_config_usage_verb set; return 0; fi
  local raw_key="${1:-}" value="${2:-}"
  [[ -n "$raw_key" ]] || { clia_config_usage >&2; return 2; }
  if [[ $# -lt 2 ]]; then
    clia_warn "valeur manquante pour $raw_key"
    clia_hint "pour vider une variable : clia config set $raw_key ''"
    return 2
  fi

  local key file dir tmp
  key=$(clia_config_normalize_key "$raw_key")
  file=$(clia_config_file)
  dir=$(dirname "$file")

  mkdir -p "$dir"
  [[ -f "$file" ]] || {
    {
      printf '# config - configuration de clia\n'
      printf '# Une ligne CLE=valeur par variable. Ce fichier est lu, jamais execute.\n'
    } > "$file"
  }

  # Reecriture atomique : on ecrit a cote puis on remplace. Une interruption
  # ne laisse pas de fichier de configuration tronque.
  tmp=$(mktemp "${file}.XXXXXX")
  local replaced=0 line lkey
  while IFS= read -r line || [[ -n "$line" ]]; do
    lkey="${line%%=*}"
    lkey="${lkey// }"
    if [[ "$lkey" == "$key" ]]; then
      printf '%s=%s\n' "$key" "$value" >> "$tmp"
      replaced=1
    else
      printf '%s\n' "$line" >> "$tmp"
    fi
  done < "$file"
  if (( replaced == 0 )); then
    printf '%s=%s\n' "$key" "$value" >> "$tmp"
  fi
  chmod --reference="$file" "$tmp" 2>/dev/null || chmod 600 "$tmp"
  mv -f "$tmp" "$file"

  printf '%s=%s\n' "$key" "$value"
  if ! clia_config_keys | grep -qx "$key"; then
    clia_warn "variable inconnue de clia : $key"
    clia_hint "elle est enregistree, mais aucune commande ne la lit"
  fi
  # N'avertir que si la valeur effective vient reellement de l'environnement.
  # La comparer a ${!key} sans verifier l'origine signalait a tort une
  # preseance de l'environnement alors que la valeur venait du defaut, celui-ci
  # etant exporte par clia_config_load.
  if [[ "$(clia_config_origin "$key")" == "environment" && "${!key:-}" != "$value" ]]; then
    clia_warn "l'environnement porte une autre valeur pour $key et a preseance"
    clia_hint "valeur effective dans ce shell : ${!key}"
    clia_hint "la valeur enregistree servira dans un shell ou $key n'est pas exportee"
  fi
}

clia_config_edit() {
  if clia_is_help "${1:-}"; then clia_config_usage_verb edit; return 0; fi
  local file dir editor
  file=$(clia_config_file)
  dir=$(dirname "$file")
  mkdir -p "$dir"
  [[ -f "$file" ]] || printf '# config - configuration de clia\n' > "$file"
  editor="${CLIA_EDITOR:-${VISUAL:-${EDITOR:-vi}}}"
  command -v "${editor%% *}" >/dev/null 2>&1 \
    || clia_die "editeur introuvable : $editor (voir clia config set EDITOR)"
  "$editor" "$file"
}

clia_config_main() {
  local verb="${1:-}"
  [[ $# -gt 0 ]] && shift
  case "$verb" in
    ls|list)  clia_config_ls "$@" ;;
    set)      clia_config_set "$@" ;;
    edit)     clia_config_edit "$@" ;;
    path)     if clia_is_help "${1:-}"; then clia_config_usage_verb path
              else clia_config_file; fi ;;
    ''|-h|--help|help) clia_config_usage ;;
    *)
      clia_warn "verbe inconnu : $verb"
      clia_config_usage >&2
      return 2 ;;
  esac
}
