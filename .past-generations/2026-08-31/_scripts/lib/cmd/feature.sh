#!/usr/bin/env bash
# Description: Les fonctionnalités offertes par les ressources — install, activate, list.
# Périmètre: dépôt
# Alias: features feat
#
# Contrairement à un skill — dont la procédure vit dans un fichier chargé
# séparément et n'est que référencée depuis CLAUDE.md — une fonctionnalité
# n'a pas de fichier propre dans le dépôt de travail : son corps est injecté
# directement dans la zone CLIA:FEATURES du harnais. Elle est donc toujours
# dans le contexte de l'agent, là où un skill n'y entre qu'à l'invocation.
#
# Une fonctionnalité n'est pas une ressource : elle est toujours la
# fonctionnalité de quelque chose. SPC-001 S7. Cette commande vit donc parmi
# celles du CLI, et non sous _ressources/, et elle opère sur les
# fonctionnalités de toutes les ressources à la fois.

set -euo pipefail

_CLIA_NOM='clia'
# shellcheck source=../commun.sh
. "$CLIA_SOURCE_DIR/_scripts/lib/commun.sh"
# shellcheck source=../texte.sh
. "$CLIA_SOURCE_DIR/_scripts/lib/texte.sh"

HARNAIS=$(_clia_harnais)

# --------------------------------------------------------------------------

aide() {
  cat <<'EOF'
Usage : clia feature <verbe> [<nom>]

Verbes :
  install <nom>    injecte la fonctionnalité dans la zone gérée de CLAUDE.md
  uninstall <nom>  retire sa section de CLAUDE.md
  status <nom>     dit si la fonctionnalité est active
  list, ls [--remote]
                   liste les fonctionnalités du dépôt courant ; --remote y
                   ajoute celles que les remotes offrent
  activate [NAMESPACE] <nom>
                   reprend dans le dépôt courant une fonctionnalité offerte
                   par un remote, sans l'installer

Une fonctionnalité est fournie par une ressource, et vit sous elle :
_ressources/<RESSOURCE>/features/<nom>.md. Il n'y a pas de catalogue central.

Trois gestes, et non un seul :
  activate  la fonctionnalité entre dans le dépôt, sous sa ressource
  install   son corps entre dans CLAUDE.md, où l'agent le lit
  uninstall il en sort, mais elle reste dans le dépôt

clia features et clia feat répondent aussi.
EOF
}

est_active() {
  grep -qF "<!-- BEGIN ${1} feature -->" "$HARNAIS" 2>/dev/null
}

# Une ligne par fonctionnalité, avec son état dans le harnais et sa
# provenance. « offerte » désigne ce qu'un remote propose et que le dépôt
# courant n'a pas repris : voir le verbe activate.
decrire() {
  local nom="$1" ressource="$2" f="$3" provenance="$4" desc etat
  # L'état dit si la fonctionnalité est dans CLAUDE.md, la provenance d'où
  # elle vient. Les deux sont indépendants : une fonctionnalité reprise d'un
  # remote peut être active, et une du dépôt peut ne pas l'être.
  if est_active "$nom"; then etat='active'; else etat='inactive'; fi
  printf '  %-24s %-16s %-10s %s\n' "$nom" "$ressource" "$etat" "$provenance"
  desc=$(_clia_frontmatter_champ "$f" description)
  # Voir la note de cmd/skill.sh : sous set -e, un « && » en dernière
  # position déciderait du code de retour de la commande.
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

  local locales rien=1
  locales=$(_clia_concept_partout "$CLIA_WORK_DIR" features)

  printf 'Fonctionnalités :\n\n'
  local nom ressource f ns chemin connus=$'\n'
  if [[ -n "$locales" ]]; then
    rien=0
    while IFS=$'\t' read -r nom ressource f; do
      connus+="$nom"$'\n'
      decrire "$nom" "$ressource" "$f" 'locale'
    done <<<"$locales"
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
      done < <(_clia_concept_partout "$chemin" features)
    done <<<"$remotes"
  fi

  if (( rien == 1 )); then
    printf '  (aucune)\n'
    if (( remote == 0 )); then
      printf '\ncelles que les remotes offrent : clia feature ls --remote\n'
    fi
  fi
}

# Reprendre dans le dépôt courant une fonctionnalité qu'un remote offre.
# La copie va au même emplacement relatif : une fonctionnalité appartient à
# sa ressource, et changer de dépôt ne change pas de qui elle relève.
activer() {
  local namespace='' nom=''
  case $# in
    1) nom="$1" ;;
    2) namespace="$1"; nom="$2" ;;
    *) _clia_msg "activate attend un nom, précédé au besoin d'un namespace"
       _clia_detail "usage : clia feature activate [NAMESPACE] <nom>"
       exit 2 ;;
  esac

  if [[ -n "$(_clia_concept_fichier "$CLIA_WORK_DIR" features "$nom")" ]]; then
    _clia_msg "fonctionnalité déjà dans le dépôt : $nom"
    _clia_detail "pour la poser dans CLAUDE.md : clia feature install $nom"
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
    source=$(_clia_concept_fichier "$chemin" features "$nom")
    if [[ -n "$source" ]]; then
      ressource="${source#"$chemin"/_ressources/}"
      ressource="${ressource%/features/*}"
      break
    fi
  done <<<"$remotes"

  if [[ -z "$source" ]]; then
    _clia_msg "aucun remote n'offre la fonctionnalité $nom"
    _clia_detail "ce qui est offert : clia feature ls --remote"
    exit 1
  fi

  # Une fonctionnalité vit sous sa ressource : sans elle, le dépôt aurait un
  # répertoire sans définition, que SPC-001 S2 lit comme une catégorie.
  local dir="$CLIA_WORK_DIR/_ressources/$ressource"
  if [[ ! -f "$dir/schemas/$(basename "$ressource").yaml" ]]; then
    _clia_msg "la ressource $ressource n'est pas activée dans ce dépôt"
    _clia_detail "elle porte la fonctionnalité $nom, et doit venir d'abord :"
    _clia_detail "  clia res activate $ressource"
    exit 1
  fi

  mkdir -p "$dir/features"
  cp "$source" "$dir/features/$nom.md"
  _clia_msg "activée : _ressources/$ressource/features/$nom.md"
  _clia_detail "reprise de $ns"
  _clia_detail "pour la poser dans CLAUDE.md : clia feature install $nom"
}

# Le fichier d'une fonctionnalité : dans le dépôt courant s'il l'a reprise,
# chez un remote sinon. Installer sans avoir activé reste permis — exiger les
# deux gestes pour un usage simple serait une cérémonie sans contrepartie.
trouver() {
  local nom="$1" f ns chemin
  f=$(_clia_concept_fichier "$CLIA_WORK_DIR" features "$nom")
  if [[ -n "$f" ]]; then printf '%s\n' "$f"; return 0; fi
  while IFS=$'\t' read -r ns chemin; do
    [[ -n "$chemin" ]] || continue
    f=$(_clia_concept_fichier "$chemin" features "$nom")
    if [[ -n "$f" ]]; then printf '%s\n' "$f"; return 0; fi
  done < <(_clia_remotes)
  return 0
}

installer() {
  local nom="$1"
  local source
  source=$(trouver "$nom")
  local debut="<!-- BEGIN ${nom} feature -->"
  local fin="<!-- END ${nom} feature -->"

  if [[ -z "$source" || ! -f "$source" ]]; then
    _clia_msg "fonctionnalité inconnue : $nom"
    _clia_detail "celles qui sont offertes : clia feature ls --remote"
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

  # La provenance ne se lit pas sur la section injectée : l'inventaire la garde.
  local ns_source v_source
  IFS=$'\t' read -r ns_source v_source < <(_clia_provenance_de "$source")
  _clia_enregistrer "$CLIA_WORK_DIR" feature "$ns_source" "$nom" "$v_source" \
    2>/dev/null || true
}

desinstaller() {
  local nom="$1"
  local debut="<!-- BEGIN ${nom} feature -->"
  local fin="<!-- END ${nom} feature -->"

  # L'oubli vient en premier, et il a lieu même quand la section est déjà
  # absente : une entrée sans section est précisément l'écart que clia check
  # signale, et désactiver doit pouvoir le solder.
  _clia_oublier "$CLIA_WORK_DIR" feature "$nom" 2>/dev/null || true

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
  local nom="$1" source locale ressource
  locale=$(_clia_concept_fichier "$CLIA_WORK_DIR" features "$nom")
  source=$(trouver "$nom")
  if [[ -n "$source" ]]; then
    ressource="${source#*/_ressources/}"
    printf 'fournie par     %s\n' "${ressource%/features/*}"
    if [[ -n "$locale" ]]; then
      printf 'provenance      ce dépôt\n'
    else
      printf 'provenance      un remote — clia feature activate %s la reprendrait\n' "$nom"
    fi
  else
    printf 'fournie par     aucune ressource — %s est inconnue\n' "$nom"
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
  list|ls)        shift; lister "$@"; exit 0 ;;
  activate)       shift; activer "$@"; exit 0 ;;
  -h|--help|help) aide; exit 0 ;;
  install|uninstall|status) ;;
  '')             aide >&2; exit 2 ;;
  *)
    _clia_msg "verbe inconnu pour feature : $VERBE"
    _clia_detail "les verbes connus : install, uninstall, status, activate, list"
    exit 2 ;;
esac

if [[ -z "$NOM" ]]; then
  _clia_msg "le verbe $VERBE attend un nom de fonctionnalité"
  _clia_detail "celles qui sont offertes : clia feature ls --remote"
  exit 2
fi

case "$VERBE" in
  install)   installer "$NOM" ;;
  uninstall) desinstaller "$NOM" ;;
  status)    etat "$NOM" ;;
esac
