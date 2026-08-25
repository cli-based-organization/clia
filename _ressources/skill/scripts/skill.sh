#!/usr/bin/env bash
# Description: Les skills offerts par les ressources — install, activate, list.
# Périmètre: dépôt
# Alias: skills skl
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
  list, ls [--remote]
                   liste les skills du dépôt courant ; --remote y ajoute ceux
                   que les remotes offrent
  activate [NAMESPACE] <nom>
                   reprend dans le dépôt courant un skill offert par un
                   remote, sans l'installer

Un skill opère sur une ressource, et vit sous elle :
_ressources/<RESSOURCE>/skills/<nom>.md. Il n'y a pas de catalogue central.

Trois gestes, et non un seul :
  activate  le skill entre dans le dépôt, sous sa ressource
  install   il entre dans .claude/skills/, où l'agent peut l'invoquer
  uninstall il en sort, mais reste dans le dépôt

clia skills et clia skl répondent aussi.
EOF
}

# Une ligne par skill, avec son état et sa provenance. « offert » désigne ce
# qu'un remote propose et que le dépôt courant n'a pas repris.
decrire() {
  local nom="$1" ressource="$2" f="$3" provenance="$4" desc etat
  # L'état dit si le skill est posé dans .claude/skills, la provenance d'où il
  # vient. Les deux sont indépendants : un skill repris d'un remote peut être
  # installé, et un skill du dépôt peut ne pas l'être.
  if [[ -f "$CLIA_WORK_DIR/.claude/skills/${nom}/SKILL.md" ]]; then
    etat='installé'
  else
    etat='non installé'
  fi
  printf '  %-24s %-16s %-13s %s\n' "$nom" "$ressource" "$etat" "$provenance"
  desc=$(_clia_frontmatter_champ "$f" description)
  # Un « && » suffirait, mais sous set -e la dernière commande d'une
  # fonction décide de son code de retour : un skill sans description en
  # fin de liste ferait échouer la commande entière.
  if [[ -n "$desc" ]]; then printf '      %s\n' "$desc"; fi
}

lister() {
  local remote=0 namespace='' arg
  for arg in "$@"; do
    case "$arg" in
      --remote) remote=1 ;;
      -*) _clia_msg "option inconnue pour ls : $arg"
          _clia_detail "la seule option est --remote"
          exit 2 ;;
      *)  namespace="$arg"; remote=1 ;;
    esac
  done

  local locaux rien=1 connus=$'\n'
  locaux=$(_clia_concept_partout "$CLIA_WORK_DIR" skills)

  printf 'Skills :\n\n'
  local nom ressource f ns chemin
  if [[ -n "$locaux" ]]; then
    rien=0
    while IFS=$'\t' read -r nom ressource f; do
      connus+="$nom"$'\n'
      decrire "$nom" "$ressource" "$f" 'local'
    done <<<"$locaux"
  fi

  if (( remote == 1 )); then
    local remotes
    if ! remotes=$(_clia_remotes_filtres "$namespace"); then
      _clia_msg "aucun remote pour le namespace $namespace"
      exit 1
    fi
    while IFS=$'\t' read -r ns chemin; do
      [[ -n "$chemin" ]] || continue
      while IFS=$'\t' read -r nom ressource f; do
        [[ -n "$nom" ]] || continue
        [[ "$connus" == *$'\n'"$nom"$'\n'* ]] && continue
        rien=0
        decrire "$nom" "$ressource" "$f" "$ns"
      done < <(_clia_concept_partout "$chemin" skills)
    done <<<"$remotes"
  fi

  if (( rien == 1 )); then
    printf '  (aucun)\n'
    if (( remote == 0 )); then
      printf '\nceux que les remotes offrent : clia skill ls --remote\n'
    fi
  fi
}

# Le fichier d'un skill : dans le dépôt courant s'il l'a repris, chez un
# remote sinon.
trouver() {
  local nom="$1" f ns chemin
  f=$(_clia_concept_fichier "$CLIA_WORK_DIR" skills "$nom")
  if [[ -n "$f" ]]; then printf '%s\n' "$f"; return 0; fi
  while IFS=$'\t' read -r ns chemin; do
    [[ -n "$chemin" ]] || continue
    f=$(_clia_concept_fichier "$chemin" skills "$nom")
    if [[ -n "$f" ]]; then printf '%s\n' "$f"; return 0; fi
  done < <(_clia_remotes)
  return 0
}

# Reprendre dans le dépôt courant un skill qu'un remote offre. La copie va au
# même emplacement relatif : un skill appartient à sa ressource, et changer de
# dépôt ne change pas sur quoi il opère.
activer() {
  local namespace='' nom=''
  case $# in
    1) nom="$1" ;;
    2) namespace="$1"; nom="$2" ;;
    *) _clia_msg "activate attend un nom, précédé au besoin d'un namespace"
       _clia_detail "usage : clia skill activate [NAMESPACE] <nom>"
       exit 2 ;;
  esac

  if [[ -n "$(_clia_concept_fichier "$CLIA_WORK_DIR" skills "$nom")" ]]; then
    _clia_msg "skill déjà dans le dépôt : $nom"
    _clia_detail "pour le poser dans .claude/skills : clia skill install $nom"
    return 0
  fi

  local remotes
  if ! remotes=$(_clia_remotes_filtres "$namespace"); then
    _clia_msg "aucun remote pour le namespace $namespace"
    exit 1
  fi

  local ns chemin source='' ressource=''
  while IFS=$'\t' read -r ns chemin; do
    [[ -n "$chemin" ]] || continue
    source=$(_clia_concept_fichier "$chemin" skills "$nom")
    if [[ -n "$source" ]]; then
      ressource="${source#"$chemin"/_ressources/}"
      ressource="${ressource%/skills/*}"
      break
    fi
  done <<<"$remotes"

  if [[ -z "$source" ]]; then
    _clia_msg "aucun remote n'offre le skill $nom"
    _clia_detail "ce qui est offert : clia skill ls --remote"
    exit 1
  fi

  # Un skill vit sous sa ressource : sans elle, le dépôt aurait un répertoire
  # sans définition, que SPC-001 S2 lit comme une catégorie.
  local dir="$CLIA_WORK_DIR/_ressources/$ressource"
  if [[ ! -f "$dir/schemas/$(basename "$ressource").yaml" ]]; then
    _clia_msg "la ressource $ressource n'est pas activée dans ce dépôt"
    _clia_detail "elle porte le skill $nom, et doit venir d'abord :"
    _clia_detail "  clia res activate $ressource"
    exit 1
  fi

  mkdir -p "$dir/skills"
  cp "$source" "$dir/skills/$nom.md"
  _clia_msg "activé : _ressources/$ressource/skills/$nom.md"
  _clia_detail "repris de $ns"
  _clia_detail "pour le poser dans .claude/skills : clia skill install $nom"
}

installer() {
  local nom="$1"
  local source
  source=$(trouver "$nom")
  local cible_dir="$CLIA_WORK_DIR/.claude/skills/${nom}"
  local cible="$cible_dir/SKILL.md"
  local debut="<!-- BEGIN ${nom} skill -->"
  local fin="<!-- END ${nom} skill -->"

  if [[ -z "$source" || ! -f "$source" ]]; then
    _clia_msg "skill inconnu : $nom"
    _clia_detail "ceux qui sont offerts : clia skill ls --remote"
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

  local source locale ressource
  locale=$(_clia_concept_fichier "$CLIA_WORK_DIR" skills "$nom")
  source=$(trouver "$nom")
  if [[ -n "$source" ]]; then
    ressource="${source#*/_ressources/}"
    printf 'offert par      %s\n' "${ressource%/skills/*}"
    if [[ -n "$locale" ]]; then
      printf 'provenance      ce dépôt\n'
    else
      printf 'provenance      un remote — clia skill activate %s le reprendrait\n' "$nom"
    fi
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
  list|ls)        shift; lister "$@"; exit 0 ;;
  activate)       shift; activer "$@"; exit 0 ;;
  -h|--help|help) aide; exit 0 ;;
  install|uninstall|status) ;;
  '')             aide >&2; exit 2 ;;
  *)
    _clia_msg "verbe inconnu pour skill : $VERBE"
    _clia_detail "les verbes connus : install, uninstall, status, activate, list"
    exit 2 ;;
esac

if [[ -z "$NOM" ]]; then
  _clia_msg "le verbe $VERBE attend un nom de skill"
  _clia_detail "ceux qui sont offerts : clia skill ls --remote"
  exit 2
fi

case "$VERBE" in
  install)   installer "$NOM" ;;
  uninstall) desinstaller "$NOM" ;;
  status)    etat "$NOM" ;;
esac
