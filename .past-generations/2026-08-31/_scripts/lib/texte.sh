# shellcheck shell=bash
# _scripts/lib/texte.sh — le harnais vu comme un texte à zones.
#
# CLAUDE.md est écrit par un humain et par clia à la fois. La cohabitation
# tient à deux marqueurs qui délimitent ce que clia écrit ; hors de ces
# zones, le fichier appartient à son auteur et n'est jamais réécrit.
#
# Les marqueurs sont ceux de noumanity-wiki, à l'identique et non traduits :
# un dépôt instrumenté par ce dépôt-là reste lisible par clia, et
# inversement. Les changer casserait cette compatibilité sans rien gagner.
#
# Sourcé par les commandes harness-ia, skill et feature. Pas par setup.sh,
# qui n'a rien à faire d'un harnais.

_CLIA_ZONE_SKILLS_DEBUT='<!-- CLIA:SKILLS:BEGIN -->'
_CLIA_ZONE_SKILLS_FIN='<!-- CLIA:SKILLS:END -->'
_CLIA_ZONE_FEATURES_DEBUT='<!-- CLIA:FEATURES:BEGIN -->'
_CLIA_ZONE_FEATURES_FIN='<!-- CLIA:FEATURES:END -->'

# --------------------------------------------------------------------------
# Lecture des zones
# --------------------------------------------------------------------------

# Contenu strictement compris entre deux marqueurs, marqueurs exclus.
_clia_zone_contenu() {
  local fichier="$1" debut="$2" fin="$3"
  [[ -f "$fichier" ]] || return 0
  awk -v b="$debut" -v e="$fin" '
    index($0, b) { dedans = 1; next }
    index($0, e) { dedans = 0; next }
    dedans { print }
  ' "$fichier"
}

# Repli pour un CLAUDE.md antérieur aux zones : les sections de skill y sont
# simplement ajoutées en fin de fichier. On les récupère pour ne pas les
# perdre en régénérant.
_clia_sections_hors_zone() {
  local fichier="$1"
  [[ -f "$fichier" ]] || return 0
  awk '
    /<!-- BEGIN .* skill -->/ { dedans = 1 }
    dedans { print }
    /<!-- END .* skill -->/   { if (dedans) { dedans = 0; print "" } }
  ' "$fichier"
}

# --------------------------------------------------------------------------
# Écriture des zones
# --------------------------------------------------------------------------

# Retire les lignes vides en tête et en queue d'un fichier.
_clia_rogner_lignes_vides() {
  local fichier="$1" tmp
  tmp=$(mktemp)
  awk 'NF{p=1} p' "$fichier" | tac | awk 'NF{p=1} p' | tac > "$tmp"
  mv "$tmp" "$fichier"
}

# Réduit les lignes vides consécutives à une seule, et ne laisse qu'un unique
# saut de ligne terminal — la substitution de commande absorbe les autres.
_clia_normaliser_lignes_vides() {
  local fichier="$1" tmp contenu
  tmp=$(mktemp)
  awk 'NF{vide=0; print; next} {vide++} vide<2{print}' "$fichier" > "$tmp"
  contenu=$(cat "$tmp")
  printf '%s\n' "$contenu" > "$fichier"
  rm -f "$tmp"
}

# Insère le contenu d'un fichier juste avant la ligne du marqueur de fin,
# encadré d'exactement une ligne vide de chaque côté. Ce formatage canonique
# est ce qui rend « init --force » idempotent : réextraire puis réinjecter
# redonne le même fichier.
_clia_inserer_avant() {
  local fichier="$1" marqueur_fin="$2" contenu="$3" tmp
  _clia_rogner_lignes_vides "$contenu"
  tmp=$(mktemp)
  awk -v e="$marqueur_fin" -v cf="$contenu" '
    index($0, e) {
      print ""
      while ((getline ligne < cf) > 0) print ligne
      close(cf)
      print ""
    }
    { print }
  ' "$fichier" > "$tmp"
  mv "$tmp" "$fichier"
}

# --------------------------------------------------------------------------
# Frontmatter
# --------------------------------------------------------------------------
#
# Un skill comme une fonctionnalité se déclarent par un frontmatter YAML :
# name, description. Ce n'est pas un analyseur YAML — c'est une extraction de
# champ à plat, qui suffit à ces deux clés et qui n'introduit aucune
# dépendance.

_clia_frontmatter_champ() {
  local fichier="$1" champ="$2"
  awk '/^---[[:space:]]*$/{c++; next} c==1' "$fichier" 2>/dev/null \
    | grep -m1 -E "^${champ}:" \
    | sed -E "s/^${champ}:[[:space:]]*//" || true
}

# Corps du fichier : tout ce qui suit le frontmatter — ou le fichier entier
# s'il n'en porte pas — débarrassé de ses lignes vides de tête et de queue.
_clia_frontmatter_corps() {
  local fichier="$1"
  awk '
    NR == 1 && $0 ~ /^---[[:space:]]*$/ { dedans = 1; next }
    dedans && $0 ~ /^---[[:space:]]*$/  { dedans = 0; next }
    !dedans { print }
  ' "$fichier" | awk 'NF{p=1} p' | tac | awk 'NF{p=1} p' | tac
}

# --------------------------------------------------------------------------
# Le harnais du dépôt de travail
# --------------------------------------------------------------------------

_clia_harnais() { printf '%s/CLAUDE.md\n' "${CLIA_WORK_DIR:-.}"; }

# Chemin affiché à l'humain : relatif au dépôt de travail, parce qu'un chemin
# absolu de quatre-vingts caractères ne dit rien de plus. PDC-004.
_clia_chemin_court() {
  local chemin="$1" base="${CLIA_WORK_DIR:-}"
  printf '%s\n' "${chemin#"$base"/}"
}
