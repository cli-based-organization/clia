#!/usr/bin/env bash
# Description: Les skills offerts par les ressources — install, uninstall, status, list.
# Périmètre: dépôt
#
# Un skill est une procédure exécutable par l'agent. Son fichier est copié du
# catalogue du dépôt source vers .claude/skills/<nom>/SKILL.md du dépôt de
# travail, et une section d'activation est posée dans la zone gérée de
# CLAUDE.md — c'est elle qui fait connaître le skill à l'agent.
#
# À distinguer d'une fonctionnalité, dont le contenu est injecté directement
# dans CLAUDE.md sans fichier chargé séparément. Voir cmd/feature.sh.

set -euo pipefail

_CLIA_NOM='clia'
# shellcheck source=../../../_scripts/lib/commun.sh
. "$CLIA_SOURCE_DIR/_scripts/lib/commun.sh"
# shellcheck source=../../../_scripts/lib/texte.sh
. "$CLIA_SOURCE_DIR/_scripts/lib/texte.sh"

HARNAIS=$(_clia_harnais)

# --------------------------------------------------------------------------

aide() {
  cat <<'EOF'
Usage : clia skill <verbe> [<nom>]

Verbes :
  install <nom>    copie le skill dans .claude/skills/<nom>/SKILL.md du dépôt
                   courant, et pose sa section d'activation dans CLAUDE.md
  uninstall <nom>  retire le skill installé et sa section d'activation
  status <nom>     dit si le skill est installé, et si CLAUDE.md est à jour
  list, ls         liste les skills offerts, avec leur état et leur description

Un skill opère sur une ressource, et vit sous elle :
_ressources/<RESSOURCE>/skills/<nom>.md. Il n'y a pas de catalogue central.
L'installation, elle, se fait dans le dépôt git courant.
EOF
}

lister() {
  local sortie
  sortie=$(_clia_concept_partout skills)

  printf 'Skills offerts par les ressources :\n\n'
  if [[ -z "$sortie" ]]; then
    printf '  (aucun)\n'
    return 0
  fi
  local nom ressource f desc
  while IFS=$'\t' read -r nom ressource f; do
    if [[ -f "$CLIA_WORK_DIR/.claude/skills/${nom}/SKILL.md" ]]; then
      printf '  %-28s %-16s [installé]\n' "$nom" "$ressource"
    else
      printf '  %-28s %-16s [non installé]\n' "$nom" "$ressource"
    fi
    desc=$(_clia_frontmatter_champ "$f" description)
    # Un « && » suffirait, mais sous set -e la dernière commande d'une
    # fonction décide de son code de retour : un skill sans description en
    # fin de catalogue ferait échouer la commande entière.
    if [[ -n "$desc" ]]; then printf '      %s\n' "$desc"; fi
  done <<<"$sortie"
}

installer() {
  local nom="$1"
  local source
  source=$(_clia_concept_fichier skills "$nom")
  local cible_dir="$CLIA_WORK_DIR/.claude/skills/${nom}"
  local cible="$cible_dir/SKILL.md"
  local debut="<!-- BEGIN ${nom} skill -->"
  local fin="<!-- END ${nom} skill -->"

  if [[ -z "$source" || ! -f "$source" ]]; then
    _clia_msg "skill inconnu : $nom"
    _clia_detail "ceux qui sont offerts : clia skill list"
    exit 1
  fi

  mkdir -p "$cible_dir"
  cp "$source" "$cible"
  _clia_msg "installé : $(_clia_chemin_court "$cible")"

  if [[ ! -f "$HARNAIS" ]]; then
    _clia_detail "CLAUDE.md est absent : le skill est en place, mais rien ne"
    _clia_detail "l'annonce à l'agent. Lancez : clia harness-ia init"
    return 0
  fi

  if grep -qF "$debut" "$HARNAIS"; then
    _clia_detail "CLAUDE.md est déjà à jour : la section d'activation est présente"
    return 0
  fi

  local desc bloc
  desc=$(_clia_frontmatter_champ "$source" description)
  [[ -z "$desc" ]] && desc="Voir .claude/skills/${nom}/SKILL.md pour le détail de la procédure."

  bloc=$(mktemp)
  # shellcheck disable=SC2064
  trap "rm -f '$bloc'" EXIT
  # La ligne vide est en fin de bloc, non au début : c'est l'espacement
  # canonique que produit harness-ia init, et ce qui rend la régénération
  # idempotente.
  {
    printf '%s\n\n' "$debut"
    printf '## Skill : %s\n\n' "$nom"
    printf 'Le skill `%s` est installé (`.claude/skills/%s/SKILL.md`). %s\n' "$nom" "$nom" "$desc"
    printf "Invoque-le via l'outil Skill dès qu'une demande correspond à cette description, plutôt que de\n"
    printf 'suivre les règles de ce fichier de mémoire — le skill les encode déjà sous forme de procédure.\n\n'
    printf '%s\n\n' "$fin"
  } > "$bloc"

  if grep -qF "$_CLIA_ZONE_SKILLS_FIN" "$HARNAIS"; then
    local tmp
    tmp=$(mktemp)
    awk -v e="$_CLIA_ZONE_SKILLS_FIN" -v cf="$bloc" '
      index($0, e) { while ((getline ligne < cf) > 0) print ligne; close(cf) }
      { print }
    ' "$HARNAIS" > "$tmp"
    mv "$tmp" "$HARNAIS"
    _clia_detail "CLAUDE.md : section d'activation ajoutée dans la zone gérée"
  else
    # Pas de zone gérée — CLAUDE.md antérieur au harnais, ou écrit à la main.
    # L'ajout en fin de fichier reste correct, et harness-ia init le
    # récupérera pour le replacer dans la zone.
    printf '\n' >> "$HARNAIS"
    cat "$bloc" >> "$HARNAIS"
    _clia_detail "CLAUDE.md : section ajoutée en fin de fichier, la zone gérée étant absente"
  fi
  _clia_normaliser_lignes_vides "$HARNAIS"
}

desinstaller() {
  local nom="$1"
  local cible_dir="$CLIA_WORK_DIR/.claude/skills/${nom}"
  local debut="<!-- BEGIN ${nom} skill -->"
  local fin="<!-- END ${nom} skill -->"

  if [[ -d "$cible_dir" ]]; then
    rm -rf "$cible_dir"
    _clia_msg "désinstallé : $(_clia_chemin_court "$cible_dir")"
  else
    _clia_msg "rien à désinstaller : $(_clia_chemin_court "$cible_dir") n'existe pas"
  fi

  # Le répertoire des skills disparaît s'il est devenu vide : un dépôt qui
  # n'a plus de skill ne doit pas garder la trace d'en avoir eu.
  local skills_dir="$CLIA_WORK_DIR/.claude/skills"
  [[ -d "$skills_dir" && -z "$(ls -A "$skills_dir")" ]] && rmdir "$skills_dir"

  if [[ -f "$HARNAIS" ]] && grep -qF "$debut" "$HARNAIS"; then
    sed -i "\|${debut}|,\|${fin}|d" "$HARNAIS"
    _clia_normaliser_lignes_vides "$HARNAIS"
    _clia_detail "CLAUDE.md : section d'activation retirée"
  else
    _clia_detail "CLAUDE.md : aucune section d'activation à retirer"
  fi
}

etat() {
  local nom="$1"
  local cible="$CLIA_WORK_DIR/.claude/skills/${nom}/SKILL.md"
  local debut="<!-- BEGIN ${nom} skill -->"

  local source
  source=$(_clia_concept_fichier skills "$nom")
  if [[ -n "$source" ]]; then
    local ressource="${source#"$CLIA_SOURCE_DIR"/_ressources/}"
    printf 'offert par      %s\n' "${ressource%/skills/*}"
  else
    printf 'offert par      aucune ressource — %s est inconnu\n' "$nom"
  fi
  if [[ -f "$cible" ]]; then
    printf 'fichier         %s\n' "$(_clia_chemin_court "$cible")"
  else
    printf 'fichier         non installé\n'
  fi
  if grep -qF "$debut" "$HARNAIS" 2>/dev/null; then
    printf 'CLAUDE.md       section d'\''activation présente\n'
  else
    printf 'CLAUDE.md       section d'\''activation absente\n'
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
    _clia_msg "verbe inconnu pour skill : $VERBE"
    _clia_detail "les verbes connus : install, uninstall, status, list"
    exit 2 ;;
esac

if [[ -z "$NOM" ]]; then
  _clia_msg "le verbe $VERBE attend un nom de skill"
  _clia_detail "le catalogue : clia skill list"
  exit 2
fi

case "$VERBE" in
  install)   installer "$NOM" ;;
  uninstall) desinstaller "$NOM" ;;
  status)    etat "$NOM" ;;
esac
