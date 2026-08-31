#!/usr/bin/env bash
# Description: Le harnais IA du dépôt (CLAUDE.md) — init, status.
# Périmètre: dépôt
#
# Installe CLAUDE.md dans le dépôt de travail à partir de la primitive du
# dépôt source, en préservant les zones gérées : les skills installés et les
# fonctionnalités activées survivent à une régénération.
#
# PDC-003 : le harnais est une ressource générée. On ne le modifie pas dans
# ses parties générées — on modifie la primitive, puis on régénère. Les deux
# zones gérées font exception dans l'autre sens : elles sont écrites par
# clia, et c'est le reste du fichier qui appartient à son auteur.

set -euo pipefail

_CLIA_NOM='clia'
# shellcheck source=../../../_scripts/lib/commun.sh
. "$CLIA_SOURCE_DIR/_scripts/lib/commun.sh"
# shellcheck source=../../../_scripts/lib/texte.sh
. "$CLIA_SOURCE_DIR/_scripts/lib/texte.sh"

HARNAIS=$(_clia_harnais)
# Le chemin de la primitive n'est pas écrit ici : c'est la définition du type
# qui le déclare, comme pour toute autre ressource.
PRIMITIVE=$(_clia_gabarit_de harness-ia) || {
  _clia_msg "le type harness-ia ne déclare pas de gabarit"
  _clia_detail "attendu dans $(_clia_definition harness-ia)"
  exit 1
}

# --------------------------------------------------------------------------

aide() {
  cat <<'EOF'
Usage : clia harness-ia <verbe>

Verbes :
  init [--force]   installe CLAUDE.md dans le dépôt courant, depuis la
                   primitive du dépôt source. --force régénère un fichier
                   existant : une sauvegarde .bak est écrite, et les zones
                   skills et fonctionnalités sont préservées telles quelles.
  status           état du harnais : présence du fichier, des zones gérées,
                   et de leur contenu.

Le harnais est installé dans le dépôt git courant ; la primitive, elle, vient
du dépôt source de clia. Les deux zones gérées sont écrites par clia :

  <!-- CLIA:SKILLS:BEGIN -->     clia skill install <nom>
  <!-- CLIA:FEATURES:BEGIN -->   clia feature install <nom>

Codes de retour :
  0  la demande est satisfaite
  1  refus : primitive absente, ou fichier existant sans --force
  2  demande mal formée
EOF
}

init() {
  local force="${1:-}"

  if [[ ! -f "$PRIMITIVE" ]]; then
    _clia_msg "primitive introuvable : $PRIMITIVE"
    _clia_detail "le dépôt source de clia est-il complet ?"
    exit 1
  fi

  if [[ -f "$HARNAIS" && "$force" != '--force' ]]; then
    _clia_msg "$(_clia_chemin_court "$HARNAIS") existe déjà, rien n'a été modifié"
    _clia_detail "pour le régénérer : clia harness-ia init --force"
    _clia_detail "une sauvegarde .bak sera écrite, et les skills et fonctionnalités"
    _clia_detail "déjà installés seront réinjectés dans le nouveau fichier"
    exit 1
  fi

  local skills features
  skills=$(mktemp)
  features=$(mktemp)
  # shellcheck disable=SC2064  # les chemins sont fixés maintenant, pas au piège
  trap "rm -f '$skills' '$features'" EXIT

  if [[ -f "$HARNAIS" ]]; then
    _clia_zone_contenu "$HARNAIS" "$_CLIA_ZONE_SKILLS_DEBUT"   "$_CLIA_ZONE_SKILLS_FIN"   > "$skills"
    _clia_zone_contenu "$HARNAIS" "$_CLIA_ZONE_FEATURES_DEBUT" "$_CLIA_ZONE_FEATURES_FIN" > "$features"

    # Aucune zone skills : fichier antérieur aux zones. Les sections y sont
    # en fin de fichier — on les récupère plutôt que de les perdre.
    if [[ ! -s "$skills" ]]; then
      _clia_sections_hors_zone "$HARNAIS" > "$skills"
    fi

    cp "$HARNAIS" "${HARNAIS}.bak"
    _clia_msg "sauvegarde : $(_clia_chemin_court "${HARNAIS}.bak")"
  fi

  cp "$PRIMITIVE" "$HARNAIS"
  _clia_msg "installé : $(_clia_chemin_court "$HARNAIS")"
  _clia_detail "depuis $PRIMITIVE"

  local n
  if [[ -s "$skills" ]]; then
    _clia_inserer_avant "$HARNAIS" "$_CLIA_ZONE_SKILLS_FIN" "$skills"
    n=$(grep -c '<!-- BEGIN .* skill -->' "$skills" || true)
    _clia_detail "zone skills : ${n} section(s) préservée(s)"
  fi
  if [[ -s "$features" ]]; then
    _clia_inserer_avant "$HARNAIS" "$_CLIA_ZONE_FEATURES_FIN" "$features"
    n=$(grep -c '<!-- BEGIN .* feature -->' "$features" || true)
    _clia_detail "zone fonctionnalités : ${n} section(s) préservée(s)"
  fi

  _clia_normaliser_lignes_vides "$HARNAIS"

  # Ce qui est posé est inscrit à l'inventaire : sans cela, rien ne dirait
  # avec quelle version du harnais ce dépôt a été instrumenté, ni d'où elle
  # venait. C'est le défaut que la tâche 12 relève.
  local ns version
  ns=$(_clia_carte_champ "$CLIA_SOURCE_DIR" namespace 2>/dev/null || printf '—')
  version=$(_clia_def_champ harness-ia version 2>/dev/null || printf '?')
  _clia_enregistrer "$CLIA_WORK_DIR" harness "$ns" harness-ia "$version" 2>/dev/null || true
}

status() {
  if [[ ! -f "$HARNAIS" ]]; then
    printf 'CLAUDE.md       absent — clia harness-ia init l'\''installera\n'
    return 0
  fi
  printf 'CLAUDE.md       présent (%s lignes)\n' "$(wc -l < "$HARNAIS")"
  printf 'dépôt           %s\n' "$CLIA_WORK_DIR"

  local n
  if grep -qF "$_CLIA_ZONE_SKILLS_DEBUT" "$HARNAIS" && grep -qF "$_CLIA_ZONE_SKILLS_FIN" "$HARNAIS"; then
    n=$(_clia_zone_contenu "$HARNAIS" "$_CLIA_ZONE_SKILLS_DEBUT" "$_CLIA_ZONE_SKILLS_FIN" \
        | grep -c '<!-- BEGIN .* skill -->' || true)
    printf 'zone skills     présente (%s installé(s))\n' "$n"
  else
    printf 'zone skills     ABSENTE — clia harness-ia init --force l'\''ajoutera\n'
  fi

  if grep -qF "$_CLIA_ZONE_FEATURES_DEBUT" "$HARNAIS" && grep -qF "$_CLIA_ZONE_FEATURES_FIN" "$HARNAIS"; then
    n=$(_clia_zone_contenu "$HARNAIS" "$_CLIA_ZONE_FEATURES_DEBUT" "$_CLIA_ZONE_FEATURES_FIN" \
        | grep -c '<!-- BEGIN .* feature -->' || true)
    printf 'zone features   présente (%s activée(s))\n' "$n"
  else
    printf 'zone features   ABSENTE — clia harness-ia init --force l'\''ajoutera\n'
  fi

  # Une section hors de sa zone survivrait à init --force sans y être
  # replacée : la signaler évite une duplication silencieuse.
  if grep -qF "$_CLIA_ZONE_SKILLS_DEBUT" "$HARNAIS"; then
    local total dans_zone
    total=$(grep -c '<!-- BEGIN .* skill -->' "$HARNAIS" || true)
    dans_zone=$(_clia_zone_contenu "$HARNAIS" "$_CLIA_ZONE_SKILLS_DEBUT" "$_CLIA_ZONE_SKILLS_FIN" \
                | grep -c '<!-- BEGIN .* skill -->' || true)
    if (( total > dans_zone )); then
      printf 'ATTENTION       %s section(s) de skill hors de la zone gérée\n' "$(( total - dans_zone ))"
    fi
  fi
}

case "${1:-}" in
  init)              shift; init "${1:-}" ;;
  status)            status ;;
  -h|--help|help)    aide ;;
  '')                aide >&2; exit 2 ;;
  *)
    _clia_msg "verbe inconnu pour harness-ia : $1"
    _clia_detail "les verbes connus : init, status"
    exit 2 ;;
esac
