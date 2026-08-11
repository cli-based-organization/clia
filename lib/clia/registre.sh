#!/usr/bin/env bash
# registre.sh - Instrumentation des registres.
#
# Un registre contient une liste de ressources, chacune avec son alias, une
# description et un statut. Il ne porte aucun contenu propre : c'est une vue.
#
# Decisions appliquees :
#   RES-035     definition du type registre
#   ADR-003 D3  grammaire orientee ressources, nom puis verbe
#   ADR-003 D9  la sortie sert un humain, un agent, et un programme
#
# Le tableau d'items est lu dans le corps du fichier, sous la rubrique Items.
# C'est le meme mecanisme que le recueil de faits de RES-005 : le fichier est
# l'unite, l'entree numerotee est l'unite de sens.

# --------------------------------------------------------------------------
# Localisation
# --------------------------------------------------------------------------

clia_registre_dir() {
  printf '%s/registres\n' "$(clia_dev_dir)"
}

# Liste les fichiers de registre, un par ligne.
clia_registre_files() {
  local dir
  dir=$(clia_registre_dir)
  [[ -d "$dir" ]] || return 0
  find "$dir" -maxdepth 1 -type f -name 'REG-*.md' 2>/dev/null | sort
}

# Resout un alias de registre vers son fichier. Accepte REG-001 et 001.
clia_registre_find() {
  local wanted="$1" seq matches

  if [[ "$wanted" =~ ^[0-9]{1,3}$ ]]; then
    seq=$(printf '%03d' "$((10#$wanted))")
    wanted="REG-${seq}"
  fi

  matches=$(clia_registre_files | grep -E "/${wanted}-[^/]*\.md$" || true)
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

# --------------------------------------------------------------------------
# Lecture du tableau d'items
# --------------------------------------------------------------------------
#
# Le tableau vit sous la rubrique Items. Ses lignes de donnees portent quatre
# colonnes et commencent par un numero sur trois chiffres, ce qui les
# distingue de l'en-tete et du separateur sans avoir a les compter.
#
# Sortie : SEQ<TAB>RESSOURCE<TAB>DESCRIPTION<TAB>STATUS

clia_registre_items() {
  local file="$1"
  awk -F'|' '
    /^## Items/          { dans = 1; next }
    dans && /^## /       { dans = 0 }
    dans && NF >= 5 {
      seq = $2; res = $3; desc = $4; st = $5
      gsub(/^[ \t]+|[ \t]+$/, "", seq)
      gsub(/^[ \t]+|[ \t]+$/, "", res)
      gsub(/^[ \t]+|[ \t]+$/, "", desc)
      gsub(/^[ \t]+|[ \t]+$/, "", st)
      if (seq ~ /^[0-9]{3}$/) printf "%s\t%s\t%s\t%s\n", seq, res, desc, st
    }
  ' "$file"
}

# --------------------------------------------------------------------------
# ls : les registres, ou les items d'un registre
# --------------------------------------------------------------------------

clia_registre_ls_registres() {
  local files
  files=$(clia_registre_files)
  if [[ -z "$files" ]]; then
    clia_warn "aucun registre dans $(clia_registre_dir)"
    clia_hint "clia res new registre \"<description>\" en cree un"
    return 0
  fi

  {
    printf 'ID\tREGISTRE-DE\tTENUE\tITEMS\tTITRE\n'
    local f id rde tenue titre n
    while IFS= read -r f; do
      id=$(clia_frontmatter_field "$f" id 2>/dev/null)
      rde=$(clia_frontmatter_field "$f" registre-de 2>/dev/null)
      tenue=$(clia_frontmatter_field "$f" tenue 2>/dev/null)
      titre=$(clia_frontmatter_field "$f" title 2>/dev/null)
      titre="${titre%\"}"; titre="${titre#\"}"
      n=$(clia_registre_items "$f" | grep -c '' || true)
      printf '%s\t%s\t%s\t%s\t%s\n' "$id" "$rde" "$tenue" "$n" "$titre"
    done <<< "$files"
  } | column -t -s $'\t'
}

clia_registre_ls_items() {
  local wanted="$1" file
  if ! file=$(clia_registre_find "$wanted"); then
    clia_warn "registre introuvable : $wanted"
    clia_hint "clia reg ls affiche les registres connus"
    return 1
  fi

  local items
  items=$(clia_registre_items "$file")
  if [[ -z "$items" ]]; then
    clia_warn "aucun item dans $wanted"
    return 0
  fi

  {
    printf 'SEQ\tRESSOURCE\tDESCRIPTION\tSTATUS\n'
    printf '%s\n' "$items"
  } | column -t -s $'\t'
}

clia_registre_ls() {
  if clia_is_help "${1:-}"; then clia_registre_usage_ls; return 0; fi
  if [[ $# -eq 0 ]]; then
    clia_registre_ls_registres
  else
    clia_registre_ls_items "$1"
  fi
}

# --------------------------------------------------------------------------
# show et edit : un item designe une ressource
# --------------------------------------------------------------------------
#
# Un item n'a pas de contenu propre : il pointe. show affiche l'item puis la
# ressource designee ; edit ouvre cette ressource. Editer l'item lui-meme
# reviendrait a editer une ligne de tableau, ce qui n'a pas d'interet.

# Rend la ligne d'un item : SEQ<TAB>RESSOURCE<TAB>DESCRIPTION<TAB>STATUS
clia_registre_item() {
  local file="$1" seq="$2"
  [[ "$seq" =~ ^[0-9]{1,3}$ ]] && seq=$(printf '%03d' "$((10#$seq))")
  clia_registre_items "$file" | awk -F'\t' -v s="$seq" '$1 == s { print; found = 1 } END { exit !found }'
}

clia_registre_resoudre() {
  # $1 registre, $2 numero d'item. Affiche le chemin de la ressource designee.
  local wanted="$1" seq="$2" file ligne alias
  if ! file=$(clia_registre_find "$wanted"); then
    clia_warn "registre introuvable : $wanted"
    return 1
  fi
  if ! ligne=$(clia_registre_item "$file" "$seq"); then
    clia_warn "item introuvable : $wanted item $seq"
    clia_hint "clia reg ls $wanted affiche les items"
    return 1
  fi
  alias=$(printf '%s' "$ligne" | cut -f2)
  printf '%s\t%s\n' "$ligne" "$alias"
}

clia_registre_show() {
  if clia_is_help "${1:-}"; then clia_registre_usage_show; return 0; fi
  local wanted="${1:-}" seq="${2:-}"
  [[ -n "$wanted" && -n "$seq" ]] || {
    clia_warn "registre et numero d'item requis"
    clia_hint "clia reg show REG-001 3"
    return 2
  }

  local resolu ligne alias
  resolu=$(clia_registre_resoudre "$wanted" "$seq") || return 1
  ligne=$(printf '%s' "$resolu" | cut -f1-4)
  alias=$(printf '%s' "$resolu" | cut -f5)

  {
    printf 'SEQ\tRESSOURCE\tDESCRIPTION\tSTATUS\n'
    printf '%s\n' "$ligne"
  } | column -t -s $'\t'

  local cible
  if cible=$(clia_resource_find "$alias" 2>/dev/null); then
    printf '\n'
    cat "$cible"
  else
    clia_warn "la ressource designee est introuvable : $alias"
    clia_hint "l'item pointe vers une ressource absente du depot"
    return 1
  fi
}

clia_registre_edit() {
  if clia_is_help "${1:-}"; then clia_registre_usage_edit; return 0; fi
  local wanted="${1:-}" seq="${2:-}"
  [[ -n "$wanted" && -n "$seq" ]] || {
    clia_warn "registre et numero d'item requis"
    clia_hint "clia reg edit REG-001 3"
    return 2
  }

  local resolu alias
  resolu=$(clia_registre_resoudre "$wanted" "$seq") || return 1
  alias=$(printf '%s' "$resolu" | cut -f5)

  local cible
  if ! cible=$(clia_resource_find "$alias" 2>/dev/null); then
    clia_warn "la ressource designee est introuvable : $alias"
    return 1
  fi

  local editor="${CLIA_EDITOR:-${VISUAL:-${EDITOR:-vi}}}"
  command -v "${editor%% *}" >/dev/null 2>&1 || {
    clia_warn "editeur introuvable : $editor"
    clia_hint "clia config set CLIA_EDITOR <editeur>"
    return 1
  }
  clia_warn "edition de $alias, designe par $wanted item $seq"
  $editor "$cible"
}

# --------------------------------------------------------------------------
# Aide
# --------------------------------------------------------------------------

clia_registre_usage() {
  cat <<'EOF'
Usage : clia registre|reg <verbe> [arguments]

Verbes :
  ls                       liste les registres du depot
  ls REG-<SEQ>             liste les items d'un registre
  show REG-<SEQ> <SEQ>     affiche un item et la ressource qu'il designe
  edit REG-<SEQ> <SEQ>     ouvre la ressource designee avec CLIA_EDITOR

Un registre contient une liste de ressources. Il ne porte aucun contenu
propre : ce qu'il dit d'une ressource est repris de cette ressource.

Aide detaillee d'un verbe :
  clia reg ls --help
  clia reg show --help
  clia reg edit --help
EOF
}

clia_registre_usage_ls() {
  cat <<'EOF'
Usage : clia reg ls [REG-<SEQ>]

Sans argument, liste les registres : leur identifiant, ce qu'ils registrent,
leur mode de tenue, leur nombre d'items et leur titre.

Avec un registre, liste ses items : SEQ, RESSOURCE, DESCRIPTION, STATUS.

Le registre se designe par son alias ou par son numero seul :
  clia reg ls REG-001
  clia reg ls 1

Le mode de tenue vaut saisie ou derivee. Un registre saisie est tenu a la
main et derive au premier oubli.
EOF
}

clia_registre_usage_show() {
  cat <<'EOF'
Usage : clia reg show REG-<SEQ> <SEQ>

Affiche l'item, puis le contenu de la ressource qu'il designe.

Un item n'a pas de contenu propre : c'est un renvoi. Ce que la commande
montre apres la ligne d'item est la ressource elle-meme.

Le numero d'item s'ecrit avec ou sans zeros de tete :
  clia reg show REG-001 3
  clia reg show REG-001 003
EOF
}

clia_registre_usage_edit() {
  cat <<'EOF'
Usage : clia reg edit REG-<SEQ> <SEQ>

Ouvre avec CLIA_EDITOR la ressource designee par l'item, non l'item.

Editer l'item reviendrait a editer une ligne de tableau. Ce qui a du contenu
est la ressource.

Pour corriger la description ou le statut d'un item, editer le registre :
  clia res edit REG-001
EOF
}

# --------------------------------------------------------------------------
# Dispatch
# --------------------------------------------------------------------------

clia_registre_main() {
  local verb="${1:-}"
  [[ $# -gt 0 ]] && shift
  case "$verb" in
    ''|-h|--help|help) clia_registre_usage; return 0 ;;
  esac
  clia_require_repo || return $?
  case "$verb" in
    ls|list)   clia_registre_ls "$@" ;;
    show|cat)  clia_registre_show "$@" ;;
    edit)      clia_registre_edit "$@" ;;
    *)
      clia_warn "verbe inconnu : $verb"
      clia_registre_usage >&2
      return 2 ;;
  esac
}
