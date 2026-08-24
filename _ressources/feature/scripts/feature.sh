#!/usr/bin/env bash
# Description: Les fonctionnalités du catalogue — install, uninstall, status, list.
# Périmètre: dépôt
#
# Contrairement à un skill — dont la procédure vit dans un fichier chargé
# séparément et n'est que référencée depuis CLAUDE.md — une fonctionnalité
# n'a pas de fichier propre dans le dépôt de travail : son corps est injecté
# directement dans la zone CLIA:FEATURES du harnais. Elle est donc toujours
# dans le contexte de l'agent, là où un skill n'y entre qu'à l'invocation.

set -euo pipefail

_CLIA_NOM='clia'
# shellcheck source=../../../_scripts/lib/commun.sh
. "$CLIA_SOURCE_DIR/_scripts/lib/commun.sh"
# shellcheck source=../../../_scripts/lib/texte.sh
. "$CLIA_SOURCE_DIR/_scripts/lib/texte.sh"

HARNAIS=$(_clia_harnais)
CATALOGUE=$(_clia_primitives feature)

# --------------------------------------------------------------------------

aide() {
  cat <<'EOF'
Usage : clia feature <verbe> [<nom>]

Verbes :
  install <nom>    injecte la fonctionnalité dans la zone gérée de CLAUDE.md
  uninstall <nom>  retire sa section de CLAUDE.md
  status <nom>     dit si la fonctionnalité est active
  list, ls         liste le catalogue, avec l'état et la description de chacune

Le catalogue vit dans le dépôt source de clia ; l'activation se fait dans le
CLAUDE.md du dépôt git courant.
EOF
}

est_active() {
  grep -qF "<!-- BEGIN ${1} feature -->" "$HARNAIS" 2>/dev/null
}

lister() {
  printf 'Catalogue des fonctionnalités (%s) :\n\n' "$CATALOGUE"
  if ! compgen -G "$CATALOGUE/*.md" >/dev/null 2>&1; then
    printf '  (aucune)\n'
    return 0
  fi
  local f nom desc
  for f in "$CATALOGUE"/*.md; do
    [[ -f "$f" ]] || continue
    nom=$(basename "$f" .md)
    if est_active "$nom"; then
      printf '  %-35s [active]\n' "$nom"
    else
      printf '  %-35s [inactive]\n' "$nom"
    fi
    desc=$(_clia_frontmatter_champ "$f" description)
    # Voir la note de cmd/skill.sh : sous set -e, un « && » en dernière
    # position déciderait du code de retour de la commande.
    if [[ -n "$desc" ]]; then printf '      %s\n' "$desc"; fi
  done
}

installer() {
  local nom="$1"
  local source="$CATALOGUE/${nom}.md"
  local debut="<!-- BEGIN ${nom} feature -->"
  local fin="<!-- END ${nom} feature -->"

  if [[ ! -f "$source" ]]; then
    _clia_msg "fonctionnalité inconnue : $nom"
    _clia_detail "le catalogue : clia feature list"
    exit 1
  fi
  if [[ ! -f "$HARNAIS" ]]; then
    _clia_msg "CLAUDE.md est absent du dépôt courant"
    _clia_detail "une fonctionnalité vit dans le harnais : clia harness-ia init"
    exit 1
  fi
  if est_active "$nom"; then
    _clia_msg "fonctionnalité déjà active : $nom"
    return 0
  fi

  local bloc
  bloc=$(mktemp)
  # shellcheck disable=SC2064
  trap "rm -f '$bloc'" EXIT
  {
    printf '%s\n\n' "$debut"
    printf '## Fonctionnalité : %s\n\n' "$nom"
    _clia_frontmatter_corps "$source"
    printf '\n%s\n\n' "$fin"
  } > "$bloc"

  if grep -qF "$_CLIA_ZONE_FEATURES_FIN" "$HARNAIS"; then
    local tmp
    tmp=$(mktemp)
    awk -v e="$_CLIA_ZONE_FEATURES_FIN" -v cf="$bloc" '
      index($0, e) { while ((getline ligne < cf) > 0) print ligne; close(cf) }
      { print }
    ' "$HARNAIS" > "$tmp"
    mv "$tmp" "$HARNAIS"
    _clia_msg "activée : $nom"
    _clia_detail "injectée dans la zone gérée de $(_clia_chemin_court "$HARNAIS")"
  else
    printf '\n' >> "$HARNAIS"
    cat "$bloc" >> "$HARNAIS"
    _clia_msg "activée : $nom"
    _clia_detail "ajoutée en fin de $(_clia_chemin_court "$HARNAIS"), la zone gérée étant absente"
  fi
  _clia_normaliser_lignes_vides "$HARNAIS"
}

desinstaller() {
  local nom="$1"
  local debut="<!-- BEGIN ${nom} feature -->"
  local fin="<!-- END ${nom} feature -->"

  if [[ ! -f "$HARNAIS" ]] || ! est_active "$nom"; then
    _clia_msg "rien à désactiver : $nom n'est pas active"
    return 0
  fi
  sed -i "\|${debut}|,\|${fin}|d" "$HARNAIS"
  _clia_normaliser_lignes_vides "$HARNAIS"
  _clia_msg "désactivée : $nom"
  _clia_detail "section retirée de $(_clia_chemin_court "$HARNAIS")"
}

etat() {
  local nom="$1"
  if [[ ! -f "$CATALOGUE/${nom}.md" ]]; then
    printf 'fonctionnalité  %s — absente du catalogue\n' "$nom"
  fi
  if est_active "$nom"; then
    printf 'état            active\n'
    printf 'CLAUDE.md       section présente\n'
  else
    printf 'état            inactive\n'
    printf 'CLAUDE.md       section absente\n'
  fi
}

# --------------------------------------------------------------------------

VERBE="${1:-}"
NOM="${2:-}"

case "$VERBE" in
  list|ls)        lister; exit 0 ;;
  -h|--help|help) aide; exit 0 ;;
  install|uninstall|status) ;;
  '')             aide >&2; exit 2 ;;
  *)
    _clia_msg "verbe inconnu pour feature : $VERBE"
    _clia_detail "les verbes connus : install, uninstall, status, list"
    exit 2 ;;
esac

if [[ -z "$NOM" ]]; then
  _clia_msg "le verbe $VERBE attend un nom de fonctionnalité"
  _clia_detail "le catalogue : clia feature list"
  exit 2
fi

case "$VERBE" in
  install)   installer "$NOM" ;;
  uninstall) desinstaller "$NOM" ;;
  status)    etat "$NOM" ;;
esac
