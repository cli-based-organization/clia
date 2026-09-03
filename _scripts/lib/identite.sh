# shellcheck shell=bash
# _scripts/lib/identite.sh — l'IIE d'une ressource, et ses formes.
#
# Implémente SES-001 tâche 24, et .dev/ressources/RES-001-ressource/
# primitive-2/SPC-003-identite.md, qui en tire l'ontologie.
#
# Ce qu'est une IIE
# ----------------
#
# Une ressource clia est reconnaissable à une seule chose : elle porte des
# informations d'identification et d'essentialisation. Tout le reste — un
# répertoire, un fichier, un dépôt — est une forme de représentation ; l'IIE
# est ce qui en fait une ressource.
#
# Trois natures d'information, et elles ne servent pas à la même chose :
#
#   identité      ce qui atteste l'unicité de la ressource
#   essentielles  ce qui définit ce qu'elle est
#   accidentelles ce qui décrit comment elle est, ce qui lui est arrivé
#
# L'IIE porte les deux premières. Les accidentelles vivent où elles veulent :
# une version publiée, une date de génération, une empreinte, un état — rien
# de cela ne dit ce qu'une ressource est.
#
# L'identité est polymorphe
# -------------------------
#
# Une même ressource se désigne de trois façons, selon d'où l'on parle :
#
#   absolue       clia:<uuid>                      partout, et pour toujours
#   relative      <PREFIXE>-<SEQ>                  dans un dépôt
#   partageable   <NAMESPACE>/<PREFIXE>-<SEQ>      entre dépôts
#
# Seule la forme absolue est déclarée : un uuid ne se déduit de rien. Les deux
# autres se dérivent — la séquence du nom de l'instance, le namespace de la
# carte du dépôt. Ce qui se déduit ne se déclare pas, et une déclaration qui
# contredirait le dépôt serait une déclaration qui ment.
#
# Une ressource sans séquence — une ressource clia, par opposition à une de
# ses instances — se désigne par son seul préfixe : RES, et
# clia.noumanity.com/clia/RES.
#
# Interne ou externe
# ------------------
#
# L'IIE est dans la représentation, ou à côté d'elle.
#
#   interne   le fichier la porte lui-même : les clés de tête d'un YAML, le
#             frontmatter d'un markdown, un en-tête de commentaires ailleurs.
#             Un répertoire la porte dans un fichier qui lui appartient ; un
#             dépôt, dans sa carte.
#
#   externe   un fichier structuré la porte, et il DOIT dire vers quoi elle
#             pointe — « representation: ». C'est le seul moyen d'identifier
#             ce qu'on ne peut pas modifier : un PDF, un binaire, une URL.
#
# Une IIE externe sans représentation n'identifie rien. clia le refuse.

_CLIA_ID_UUID='^clia:[0-9a-f]{8}-[0-9a-f]{4}-[0-9a-f]{4}-[0-9a-f]{4}-[0-9a-f]{12}$'
_CLIA_ID_CHAMPS='id nom titre prefixe version description'

# --------------------------------------------------------------------------
# Fabriquer une identité
# --------------------------------------------------------------------------

# _clia_id_neuve — une forme absolue neuve. Le noyau la lit là où Linux la
# donne, et n'appelle uuidgen qu'à défaut : un dépôt qui n'a pas util-linux
# doit pouvoir créer une ressource.
_clia_id_neuve() {
  local u=''
  if [[ -r /proc/sys/kernel/random/uuid ]]; then
    read -r u < /proc/sys/kernel/random/uuid
  elif command -v uuidgen >/dev/null 2>&1; then
    u=$(uuidgen)
  fi
  [[ -n "$u" ]] || return 1
  printf 'clia:%s\n' "$(printf '%s' "$u" | tr '[:upper:]' '[:lower:]')"
}

_clia_id_est_absolue() { [[ "$1" =~ $_CLIA_ID_UUID ]]; }

# --------------------------------------------------------------------------
# Lire une IIE
# --------------------------------------------------------------------------
#
# Trois porteurs, et le type du fichier les départage. Un fichier qui n'en est
# aucun ne porte pas d'IIE interne : il en faut une externe.

# _clia_id_champ <fichier> <champ> — la valeur déclarée, ou rien.
_clia_id_champ() {
  local f="$1" champ="$2"
  [[ -f "$f" ]] || return 0
  case "${f##*.}" in
    yaml|yml)    _clia_champ_yaml "$f" "$champ" 2>/dev/null || printf '' ;;
    md|markdown) _clia_t_champ    "$f" "$champ" 2>/dev/null || printf '' ;;
    *)           _clia_id_champ_commente "$f" "$champ" ;;
  esac
  return 0
}

# Un en-tête de commentaires, pour les fichiers qui n'ont ni tête YAML ni
# frontmatter :
#
#   # clia-id: clia:0f9a…
#   # clia-prefixe: OUT
#
# Le préfixe de commentaire n'est pas imposé — #, //, ;, * — parce qu'il
# dépend du langage, et qu'exiger le sien reviendrait à ne servir qu'un
# langage. Seules les vingt premières lignes sont lues : une IIE est en tête,
# ou elle n'y est pas.
_clia_id_champ_commente() {
  local f="$1" champ="$2"
  head -20 "$f" 2>/dev/null \
    | sed -n -E "s@^[[:space:]]*[#;/*-]+[[:space:]]*clia-${champ}:[[:space:]]*(.+)[[:space:]]*\$@\1@p" \
    | head -1
  return 0
}

# _clia_id_porteuse <fichier> — vrai si le fichier peut porter une IIE
# interne. Un CSV, une image, un binaire ne le peuvent pas.
_clia_id_porteuse() {
  case "${1##*.}" in
    yaml|yml|md|markdown|sh|py|js|ts|c|h|go|rs|el|lua|toml|ini|conf) return 0 ;;
    *) return 1 ;;
  esac
}

# _clia_id_lire <fichier> — « id SEP nom SEP titre SEP prefixe SEP version SEP
# description SEP representation ». Rend 1 si aucune identité n'est déclarée.
_clia_id_lire() {
  local f="$1" champ valeurs=() representation
  for champ in $_CLIA_ID_CHAMPS; do
    valeurs+=("$(_clia_id_champ "$f" "$champ")")
  done
  [[ -n "${valeurs[0]}" ]] || return 1
  representation=$(_clia_id_champ "$f" representation)
  ( IFS="$_CLIA_SEP"; printf '%s%s%s\n' "${valeurs[*]}" "$_CLIA_SEP" "$representation" )
  return 0
}

# _clia_id_externe <fichier> — vrai si l'IIE que ce fichier porte désigne
# autre chose que lui-même.
_clia_id_externe() {
  [[ -n "$(_clia_id_champ "$1" representation)" ]]
}

# --------------------------------------------------------------------------
# Les trois formes
# --------------------------------------------------------------------------

# _clia_id_namespace <dépôt> — l'autorité que la carte déclare, ou rien.
_clia_id_namespace() {
  local carte
  carte=$(_clia_carte "$1" 2>/dev/null) || return 1
  _clia_champ_yaml "$carte" namespace || return 1
}

# _clia_id_relative <prefixe> [sequence] — la forme relative à un dépôt.
_clia_id_relative() {
  local prefixe="$1" seq="${2:-}"
  [[ -n "$prefixe" ]] || return 1
  if [[ -n "$seq" ]]; then printf '%s-%s\n' "$prefixe" "$seq"
  else printf '%s\n' "$prefixe"; fi
}

# _clia_id_partageable <dépôt> <prefixe> [sequence] — la forme entre dépôts.
_clia_id_partageable() {
  local depot="$1" relative ns
  relative=$(_clia_id_relative "${@:2}") || return 1
  ns=$(_clia_id_namespace "$depot") || {
    printf '(namespace non déclaré)/%s\n' "$relative"; return 0; }
  printf '%s/%s\n' "$ns" "$relative"
}

# _clia_id_sequence <identifiant d'instance> — la séquence d'un PREFIXE-SEQ-slug.
_clia_id_sequence() {
  local id="$1"
  [[ "$id" =~ ^[A-Z]{2,5}-([0-9]{3,}) ]] || return 1
  printf '%s\n' "${BASH_REMATCH[1]}"
}

# --------------------------------------------------------------------------
# Ce que le dépôt porte comme IIE
# --------------------------------------------------------------------------
#
# Trois endroits, et ils ne se recouvrent pas :
#
#   la carte du dépôt          le dépôt lui-même, quand il est une ressource
#   les ressources installées  ce qu'il emploie
#   les instances              ce qu'il écrit, et les primitives de chacune
#
# Rien n'est fouillé au hasard : ce sont les mêmes endroits que le reste du
# CLI regarde, et une IIE posée ailleurs n'est pas trouvée. C'est voulu — un
# balayage du disque trouverait des identités que personne n'a déclarées au
# dépôt.

# _clia_id_du_depot <dépôt> — « portee SEP chemin SEP id SEP relative ».
_clia_id_du_depot() {
  local depot="$1" carte id prefixe
  carte=$(_clia_carte "$depot" 2>/dev/null) || return 0
  id=$(_clia_champ_yaml "$carte" id || printf '')
  [[ -n "$id" ]] || return 0
  prefixe=$(_clia_champ_yaml "$carte" prefixe || printf '')
  printf 'dépôt%s%s%s%s%s%s\n' \
    "$_CLIA_SEP" "${carte#"$depot"/}" "$_CLIA_SEP" "$id" "$_CLIA_SEP" \
    "$(_clia_id_relative "$prefixe" 2>/dev/null || printf '—')"
  return 0
}

# _clia_id_toutes <dépôt> — « portee SEP chemin SEP id SEP relative », une par
# IIE trouvée dans le dépôt.
_clia_id_toutes() {
  local depot="$1" zone livree nom id_inst def f id prefixe seq ordre

  _clia_id_du_depot "$depot"

  livree=$(_clia_zone_livree)
  while IFS=$'\t' read -r nom _ _; do
    [[ -n "$nom" ]] || continue
    def="$depot/$livree/$nom/$nom.yaml"
    id=$(_clia_id_champ "$def" id)
    prefixe=$(_clia_id_champ "$def" prefixe)
    printf 'ressource%s%s%s%s%s%s\n' \
      "$_CLIA_SEP" "${def#"$depot"/}" "$_CLIA_SEP" "${id:-—}" "$_CLIA_SEP" \
      "$(_clia_id_relative "$prefixe" 2>/dev/null || printf '—')"
  done < <(_clia_ressources_de "$depot")

  zone=$(_clia_zone_ressource)
  while IFS=$'\t' read -r id_inst nom _ _; do
    [[ -n "$id_inst" ]] || continue
    def="$depot/$zone/$id_inst/livrables/$nom.yaml"
    id=$(_clia_id_champ "$def" id)
    prefixe=$(_clia_id_champ "$def" prefixe)
    seq=$(_clia_id_sequence "$id_inst" || printf '')
    printf 'instance%s%s%s%s%s%s\n' \
      "$_CLIA_SEP" "$zone/$id_inst" "$_CLIA_SEP" "${id:-—}" "$_CLIA_SEP" \
      "$(_clia_id_relative "$prefixe" "$seq" 2>/dev/null || printf '—')"

    for ordre in 1 2; do
      for f in "$depot/$zone/$id_inst/primitive-$ordre"/*; do
        [[ -f "$f" ]] || continue
        id=$(_clia_id_champ "$f" id)
        prefixe=''; seq=''
        if [[ "$(basename "$f")" =~ ^([A-Z]{2,5})-([0-9]{3,}) ]]; then
          prefixe="${BASH_REMATCH[1]}"; seq="${BASH_REMATCH[2]}"
        fi
        printf 'primitive%s%s%s%s%s%s\n' \
          "$_CLIA_SEP" "${f#"$depot"/}" "$_CLIA_SEP" "${id:-—}" "$_CLIA_SEP" \
          "$(_clia_id_relative "$prefixe" "$seq" 2>/dev/null || printf '—')"
      done
    done
  done < <(_clia_instances_de "$depot")
  return 0
}
