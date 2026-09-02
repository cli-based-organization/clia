# shellcheck shell=bash
# _scripts/lib/texte.sh — les zones gérées d'un harnais, et ce qu'on y pose.
#
# Implémente une partie de SES-001 tâche 15.
#
# Un harnais IA est un fichier que l'humain écrit. clia y ajoute pourtant du
# texte : le corps d'une fonctionnalité, la directive d'emploi d'un skill.
# Les deux doivent cohabiter sans que l'un efface l'autre.
#
# Les zones gérées
# ----------------
#
#   <!-- CLIA:FEATURES:BEGIN -->   ce que clia pose y va, et rien d'autre
#   <!-- CLIA:FEATURES:END -->
#   <!-- CLIA:SKILLS:BEGIN -->
#   <!-- CLIA:SKILLS:END -->
#
# Hors de ces marqueurs, le fichier appartient à qui l'écrit : clia n'y touche
# jamais. Dedans, il n'y a que ce que clia a posé, et lui seul le retire.
#
# Les marqueurs sont des commentaires HTML : ils ne paraissent pas au rendu
# markdown, et un agent qui lit le fichier n'y voit que le texte.
#
# Une zone absente est créée en fin de fichier, et clia le dit. Refuser aurait
# obligé à préparer le harnais avant de pouvoir rien y poser, pour un fichier
# que clia sait très bien terminer lui-même.
#
# Chaque élément posé porte ses propres bornes, à l'intérieur de la zone :
#
#   <!-- BEGIN <nom> feature -->  …  <!-- END <nom> feature -->
#
# C'est ce qui fait que l'état ne se déclare nulle part : il se lit dans le
# fichier. Le bloc est là, ou il n'y est pas. Un inventaire parallèle aurait
# pu mentir ; le fichier, non.

_CLIA_ZONE_FEATURES_DEBUT='<!-- CLIA:FEATURES:BEGIN -->'
_CLIA_ZONE_FEATURES_FIN='<!-- CLIA:FEATURES:END -->'
_CLIA_ZONE_SKILLS_DEBUT='<!-- CLIA:SKILLS:BEGIN -->'
_CLIA_ZONE_SKILLS_FIN='<!-- CLIA:SKILLS:END -->'

# _clia_t_zone <features|skills> — « début<TAB>fin ».
_clia_t_zone() {
  case "$1" in
    features) printf '%s\t%s\n' "$_CLIA_ZONE_FEATURES_DEBUT" "$_CLIA_ZONE_FEATURES_FIN" ;;
    skills)   printf '%s\t%s\n' "$_CLIA_ZONE_SKILLS_DEBUT"   "$_CLIA_ZONE_SKILLS_FIN" ;;
    *)        return 1 ;;
  esac
}

_clia_t_borne_debut() { printf '<!-- BEGIN %s %s -->\n' "$2" "$1"; }
_clia_t_borne_fin()   { printf '<!-- END %s %s -->\n'   "$2" "$1"; }

# --------------------------------------------------------------------------
# Le frontmatter
# --------------------------------------------------------------------------
#
# Une fonctionnalité et un skill se décrivent en tête de leur propre fichier,
# entre deux lignes « --- ». Ce que clia pose dans le harnais est le corps,
# jamais le frontmatter : il est le catalogue, non le texte.

# _clia_t_champ <fichier> <champ> — la valeur, ou rien.
_clia_t_champ() {
  [[ -f "$1" ]] || return 1
  awk -v champ="$2" '
    NR == 1 && $0 !~ /^---[[:space:]]*$/ { exit 1 }
    NR == 1 { next }
    /^---[[:space:]]*$/ { exit }
    {
      i = index($0, ":")
      if (i == 0) next
      cle = substr($0, 1, i - 1)
      gsub(/^[[:space:]]+|[[:space:]]+$/, "", cle)
      if (cle != champ) next
      val = substr($0, i + 1)
      gsub(/^[[:space:]]+|[[:space:]]+$/, "", val)
      gsub(/^"|"$/, "", val)
      print val
      exit
    }
  ' "$1"
}

# _clia_t_corps <fichier> — tout ce qui suit le frontmatter. Un fichier qui
# n'en porte pas est rendu entier : il est alors tout entier son corps.
_clia_t_corps() {
  awk '
    NR == 1 && $0 ~ /^---[[:space:]]*$/ { dans = 1; next }
    dans && $0 ~ /^---[[:space:]]*$/    { dans = 0; sorti = 1; next }
    dans { next }
    { print }
  ' "$1" | sed -e '/./,$!d'
}

# --------------------------------------------------------------------------
# Poser et retirer
# --------------------------------------------------------------------------

# _clia_t_pose <fichier> <nom> <type> — vrai si l'élément est dans le harnais.
_clia_t_pose() {
  [[ -f "$1" ]] || return 1
  grep -qF "$(_clia_t_borne_debut "$2" "$3")" "$1"
}

# _clia_t_zone_assurer <fichier> <zone> — crée la zone si elle manque.
# Rend 0 si elle existait, 1 si elle vient d'être créée.
_clia_t_zone_assurer() {
  local fichier="$1" debut fin
  IFS=$'\t' read -r debut fin < <(_clia_t_zone "$2")
  if grep -qF "$fin" "$fichier" 2>/dev/null; then
    return 0
  fi
  { printf '\n%s\n\n%s\n' "$debut" "$fin"; } >> "$fichier"
  return 1
}

# _clia_t_inserer <fichier> <zone> <bloc> — pose le contenu d'un fichier de
# bloc juste avant la fin de la zone.
_clia_t_inserer() {
  local fichier="$1" bloc="$3" debut fin tmp
  IFS=$'\t' read -r debut fin < <(_clia_t_zone "$2")
  tmp=$(mktemp)
  awk -v f="$fin" -v b="$bloc" '
    index($0, f) { while ((getline l < b) > 0) print l; close(b) }
    { print }
  ' "$fichier" > "$tmp"
  mv -f "$tmp" "$fichier"
  _clia_t_normaliser "$fichier"
}

# _clia_t_retirer <fichier> <nom> <type> — ôte le bloc et ses bornes.
_clia_t_retirer() {
  local fichier="$1" tmp d f
  d=$(_clia_t_borne_debut "$2" "$3")
  f=$(_clia_t_borne_fin "$2" "$3")
  tmp=$(mktemp)
  awk -v d="$d" -v f="$f" '
    index($0, d) { dedans = 1; next }
    index($0, f) { dedans = 0; next }
    !dedans { print }
  ' "$fichier" > "$tmp"
  mv -f "$tmp" "$fichier"
  _clia_t_normaliser "$fichier"
}

# Deux lignes vides de suite deviennent une, et le fichier finit par une
# seule. Poser et retirer laissent sinon des trous qui grandissent à chaque
# geste, et le diff du harnais cesse de montrer ce qui a vraiment changé.
_clia_t_normaliser() {
  local fichier="$1" tmp
  tmp=$(mktemp)
  awk '
    /^[[:space:]]*$/ { vide = 1; next }
    { if (vide && vu) print ""; vide = 0; vu = 1; print }
  ' "$fichier" > "$tmp"
  mv -f "$tmp" "$fichier"
}
