#!/usr/bin/env bash
# setup.sh - amorcage de clia (couche 1) et extension de clia (couche 2).
#
# Usage :
#   ./setup.sh install        installe clia (dev + permanent + local)
#   ./setup.sh --check        etat d'installation, n'ecrit rien   (0 installe / 1 sinon)
#   ./setup.sh --uninstall    retire ce que l'installation a pose
#   ./setup.sh --contract-version   version du contrat d'extension implemente
#   . setup.sh activate       ajoute src/bin au PATH de la session courante
#
# Conception : ADR-010 (D1, D2), ADR-014 ; exigences REQ-003 ; interface SPEC-004.
# Cible : Debian 12, bash uniquement. Aucun privilege eleve, aucun sudo.

# Mode strict uniquement en execution : sourcer ne doit pas alterer le shell appelant.
if [ "${BASH_SOURCE[0]}" = "$0" ]; then
  set -euo pipefail
fi

SETUP_VERSION="0.2.0"
SETUP_CONTRACT_VERSION="1.0.0"
SETUP_ROOT="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"
SETUP_BIN="${SETUP_ROOT}/src/bin"
SETUP_RC="${HOME}/.bashrc"
SETUP_MARK_OPEN="# >>> clia setup >>>"
SETUP_MARK_CLOSE="# <<< clia setup <<<"
SETUP_DEPS=(yq git)

# Paquet distribuable (ADR-010 D6) : harnais et actifs seulement.
# L'outil (src/, clia.doc.yaml) et sa documentation en sont EXCLUS.
SETUP_HARNESS_FILES=(CLAUDE.md CONSTITUTION.md ARCHITECTURE.md INTENTION.md)
SETUP_MARK_FILE=".dev/installation.yaml"

_setup_info() { printf '[INFO] %s\n' "$1" >&2; }
_setup_ok()   { printf '[OK] %s\n'   "$1" >&2; }
_setup_warn() { printf '[WARN] %s\n' "$1" >&2; }
_setup_err()  { printf '[ERR] %s\n'  "$1" >&2; }
_setup_die()  { _setup_err "$1"; exit "${2:-1}"; }

_setup_help() {
  cat <<EOF
setup.sh ${SETUP_VERSION} - amorcage de clia (couche 1)

Usage : ./setup.sh COMMANDE

Commandes (couche 1, l'outil sur le poste) :
  install              installe clia (mode dev + permanent + local)
  --check              etat d'installation, sans ecriture (0 installe / 1 sinon)
  --uninstall          retire le bloc pose par l'installation
  --contract-version   version du contrat d'extension implemente

Commandes (couche 2, le harnais dans un depot) :
  init [-C DIR] [NOM]  cree le depot si absent et y pose le harnais
  versions [-C DIR]    versions disponibles et version installee

  -h, --help           cette aide

Sourcage :
  . setup.sh activate  ajoute ${SETUP_BIN} au PATH de la session courante

L'installation est locale a l'utilisateur courant, sans sudo. Le mode dev fait
pointer clia vers cet arbre source : toute modification y est immediatement active.
EOF
}

# --- helpers -----------------------------------------------------------------

# Racine actuellement rattachee dans le bloc, ou chaine vide.
_setup_installed_root() {
  [ -f "${SETUP_RC}" ] || return 0
  awk -v o="${SETUP_MARK_OPEN}" -v c="${SETUP_MARK_CLOSE}" '
    $0 == o { inb = 1; next }
    $0 == c { inb = 0; next }
    inb && $0 ~ /^export CLIA_HOME=/ {
      line = $0
      sub(/^export CLIA_HOME="/, "", line)
      sub(/"$/, "", line)
      print line
      exit
    }
  ' "${SETUP_RC}"
}

_setup_is_installed() {
  [ -f "${SETUP_RC}" ] || return 1
  grep -qxF "${SETUP_MARK_OPEN}" "${SETUP_RC}"
}

_setup_check_deps() {
  local missing=()
  local dep
  for dep in "${SETUP_DEPS[@]}"; do
    command -v "$dep" >/dev/null 2>&1 || missing+=("$dep")
  done
  if [ "${#missing[@]}" -gt 0 ]; then
    _setup_die "dependance(s) requise(s) absente(s) : ${missing[*]} (aucune ecriture effectuee)"
  fi
}

_setup_block() {
  printf '%s\n' "${SETUP_MARK_OPEN}"
  printf 'export CLIA_HOME="%s"\n' "${SETUP_ROOT}"
  printf 'export PATH="%s:${PATH}"\n' "${SETUP_BIN}"
  printf '%s\n' "${SETUP_MARK_CLOSE}"
}

# Reecrit la configuration sans le bloc, dans le fichier passe en argument.
_setup_strip_block_into() {
  local out="$1"
  if [ -f "${SETUP_RC}" ]; then
    awk -v o="${SETUP_MARK_OPEN}" -v c="${SETUP_MARK_CLOSE}" '
      $0 == o { skip = 1; next }
      $0 == c { skip = 0; next }
      !skip   { print }
    ' "${SETUP_RC}" > "${out}"
  else
    : > "${out}"
  fi
}

# --- commandes ---------------------------------------------------------------

_setup_cmd_install() {
  _setup_check_deps

  [ -x "${SETUP_BIN}/clia" ] || _setup_die "arbre source invalide : ${SETUP_BIN}/clia introuvable ou non executable"

  local rc_dir; rc_dir="$(dirname "${SETUP_RC}")"
  [ -d "${rc_dir}" ] || _setup_die "repertoire de configuration absent : ${rc_dir} (aucune ecriture effectuee)"
  if [ -e "${SETUP_RC}" ] && [ ! -w "${SETUP_RC}" ]; then
    _setup_die "configuration non accessible en ecriture : ${SETUP_RC} (aucune ecriture effectuee)"
  fi
  [ -w "${rc_dir}" ] || _setup_die "repertoire non accessible en ecriture : ${rc_dir} (aucune ecriture effectuee)"

  local current; current="$(_setup_installed_root)"
  if [ -n "${current}" ] && [ "${current}" = "${SETUP_ROOT}" ]; then
    _setup_ok "deja installe depuis la meme racine (${SETUP_ROOT}), rien a faire"
    return 0
  fi

  local tmp; tmp="$(mktemp "${rc_dir}/.bashrc.clia.XXXXXX")"
  trap 'rm -f "${tmp}"' EXIT
  _setup_strip_block_into "${tmp}"
  _setup_block >> "${tmp}"
  chmod 0644 "${tmp}"
  mv -f "${tmp}" "${SETUP_RC}"
  trap - EXIT

  if [ -n "${current}" ]; then
    _setup_ok "bloc mis a jour dans ${SETUP_RC} : ${current} -> ${SETUP_ROOT}"
  else
    _setup_ok "bloc ecrit dans ${SETUP_RC} (racine : ${SETUP_ROOT})"
  fi
  _setup_info "activez la session courante avec : source ${SETUP_RC}"
}

_setup_cmd_check() {
  if _setup_is_installed; then
    local current; current="$(_setup_installed_root)"
    _setup_ok "clia est installe dans ${SETUP_RC}"
    _setup_info "CLIA_HOME : ${current:-introuvable}"
    if [ -n "${current}" ] && [ "${current}" != "${SETUP_ROOT}" ]; then
      _setup_warn "la racine rattachee (${current}) differe de cet arbre source (${SETUP_ROOT})"
    fi
    return 0
  fi
  _setup_warn "clia n'est pas installe dans ${SETUP_RC}"
  return 1
}

_setup_cmd_uninstall() {
  if ! _setup_is_installed; then
    _setup_ok "clia n'est pas installe, rien a faire"
    return 0
  fi
  local rc_dir; rc_dir="$(dirname "${SETUP_RC}")"
  local tmp; tmp="$(mktemp "${rc_dir}/.bashrc.clia.XXXXXX")"
  trap 'rm -f "${tmp}"' EXIT
  _setup_strip_block_into "${tmp}"
  chmod 0644 "${tmp}"
  mv -f "${tmp}" "${SETUP_RC}"
  trap - EXIT
  _setup_ok "bloc retire de ${SETUP_RC}"
}

_setup_cmd_activate() {
  export PATH="${SETUP_BIN}:${PATH}"
  if command -v clia >/dev/null 2>&1; then
    _setup_ok "clia disponible (${SETUP_BIN} ajoute au PATH)"
  else
    _setup_warn "clia introuvable apres activation"
  fi
  local dep
  for dep in "${SETUP_DEPS[@]}"; do
    command -v "$dep" >/dev/null 2>&1 || _setup_warn "dependance absente : ${dep}"
  done
}

# --- couche 2 : materialisation dans un depot cible ---------------------------

# Etat d'une cible (ADR-010 D9, ADR-013 D5) :
#   equipped-marked | equipped-unmarked | not-equipped | no-repo
_setup_target_state() {
  local dir="$1"
  [ -d "${dir}" ] || { printf 'no-repo\n'; return 0; }
  if [ ! -d "${dir}/.git" ]; then
    printf 'no-repo\n'
    return 0
  fi
  if [ -f "${dir}/CLAUDE.md" ] && [ -f "${dir}/.dev/resource-types.yaml" ]; then
    if [ -f "${dir}/${SETUP_MARK_FILE}" ]; then
      printf 'equipped-marked\n'
    else
      printf 'equipped-unmarked\n'
    fi
    return 0
  fi
  printf 'not-equipped\n'
}

# Version du systeme d'augmentation portee par l'arbre source (ADR-013 D1).
_setup_source_version() {
  local vf="${SETUP_ROOT}/version.yaml"
  [ -f "${vf}" ] || { printf 'inconnue\n'; return 0; }
  yq -r '.version // "inconnue"' "${vf}"
}

# Etiquette exacte de la revision courante, ou chaine vide (etat de travail).
_setup_source_tag() {
  git -C "${SETUP_ROOT}" describe --exact-match --tags HEAD 2>/dev/null || true
}

_setup_source_revision() {
  git -C "${SETUP_ROOT}" rev-parse --short HEAD 2>/dev/null || printf 'inconnue'
}

# Repertoires de ressources a creer vides, lus depuis la couche type (PDC-006).
_setup_resource_dirs() {
  yq -r '.types_livrables[].emplacement' "${SETUP_ROOT}/.dev/resource-types.yaml" \
    | grep -v '^\.$' | grep -v '^\.dev/skills$' | sort -u
}

# Copie atomique d'un fichier source vers la cible, avec creation du parent.
_setup_put_file() {
  local src="$1" dst="$2" tmp
  mkdir -p "$(dirname "${dst}")"
  tmp="$(mktemp "$(dirname "${dst}")/.clia.XXXXXX")"
  cat "${src}" > "${tmp}"
  chmod 0644 "${tmp}"
  mv -f "${tmp}" "${dst}"
}

_setup_cmd_init() {
  _setup_check_deps

  local base="" name="" dry=0
  while [ $# -gt 0 ]; do
    case "$1" in
      -C)        base="${2:-}"; shift 2 ;;
      --dry-run) dry=1; shift ;;
      --debug)   shift ;;
      --force)   SETUP_FORCE=1; shift ;;
      -h|--help) _setup_help; return 0 ;;
      -*)        _setup_err "option inconnue : $1"; exit 2 ;;
      *)         name="$1"; shift ;;
    esac
  done

  # Resolution de la cible (ADR-010 D4) : -C, puis racine du depot courant, puis cwd.
  local target
  if [ -n "${base}" ]; then
    target="${base}"
  else
    target="$(git rev-parse --show-toplevel 2>/dev/null || pwd)"
  fi
  if [ -n "${name}" ] && [ "${name}" != "." ]; then
    target="${target%/}/${name}"
  fi

  local state; state="$(_setup_target_state "${target}")"
  case "${state}" in
    equipped-marked|equipped-unmarked)
      _setup_err "cible deja equipee : ${target}"
      _setup_info "pour la faire evoluer, utilisez la mise a niveau (non disponible a ce stade)"
      exit 1
      ;;
  esac

  if [ -d "${target}" ] && [ -n "$(ls -A "${target}" 2>/dev/null | grep -v '^\.git$' || true)" ]; then
    if [ "${SETUP_FORCE:-0}" != 1 ]; then
      _setup_err "emplacement non vide : ${target} (utilisez --force pour passer outre)"
      exit 1
    fi
  fi

  local version tag revision posed=()
  version="$(_setup_source_version)"
  tag="$(_setup_source_tag)"
  revision="$(_setup_source_revision)"

  local f d
  if [ "${dry}" = 1 ]; then
    printf 'cible               %s\n' "${target}"
    printf 'version posee       %s\n' "${tag:-${version} (etat de travail)}"
    printf 'revision source     %s\n' "${revision}"
    printf 'a poser :\n'
    for f in "${SETUP_HARNESS_FILES[@]}"; do
      [ -f "${SETUP_ROOT}/${f}" ] && printf '  %s\n' "${f}"
    done
    printf '  .dev/resource-types.yaml\n  .dev/skills/\n  .dev/templates/\n  version.yaml\n  %s\n' "${SETUP_MARK_FILE}"
    while IFS= read -r d; do printf '  %s/ (vide)\n' "${d}"; done < <(_setup_resource_dirs)
    return 0
  fi

  mkdir -p "${target}"
  if [ ! -d "${target}/.git" ]; then
    git -C "${target}" init -q
    _setup_ok "depot cree : ${target}"
  fi

  # Harnais et actifs. L'outil et sa source documentaire sont EXCLUS (ADR-010 D6).
  for f in "${SETUP_HARNESS_FILES[@]}"; do
    [ -f "${SETUP_ROOT}/${f}" ] || continue
    _setup_put_file "${SETUP_ROOT}/${f}" "${target}/${f}"
    posed+=("${f}")
  done
  _setup_put_file "${SETUP_ROOT}/.dev/resource-types.yaml" "${target}/.dev/resource-types.yaml"
  posed+=(".dev/resource-types.yaml")

  local rel
  for d in skills templates; do
    [ -d "${SETUP_ROOT}/.dev/${d}" ] || continue
    while IFS= read -r f; do
      rel="${f#${SETUP_ROOT}/}"
      _setup_put_file "${f}" "${target}/${rel}"
      posed+=("${rel}")
    done < <(find "${SETUP_ROOT}/.dev/${d}" -type f | sort)
  done

  while IFS= read -r d; do
    mkdir -p "${target}/${d}"
    [ -e "${target}/${d}/.gitkeep" ] || : > "${target}/${d}/.gitkeep"
  done < <(_setup_resource_dirs)

  if [ ! -f "${target}/version.yaml" ]; then
    printf '# Version du contenu metier de ce depot (ADR-007).\nversion: 0.1.0\n' > "${target}/version.yaml"
    posed+=("version.yaml")
  fi

  # Marque d'installation (ADR-013 D3).
  {
    printf '# Marque d installation du systeme d augmentation (ADR-013).\n'
    printf '# Ecrite et lue par clia. Ne pas editer a la main.\n'
    printf 'version: "%s"\n' "${tag:-${version}}"
    printf 'published: %s\n' "$([ -n "${tag}" ] && printf 'true' || printf 'false')"
    printf 'source-revision: "%s"\n' "${revision}"
    printf 'date: "%s"\n' "$(date +%Y-%m-%dT%H:%M:%S%z)"
    printf 'mode: copie\n'
    printf 'files:\n'
    for f in "${posed[@]}"; do
      printf '  - path: "%s"\n    digest: "%s"\n' "${f}" "$(md5sum "${target}/${f}" | cut -d' ' -f1)"
    done
  } > "${target}/${SETUP_MARK_FILE}"

  _setup_ok "depot equipe : ${target}"
  _setup_info "version posee : ${tag:-${version} (etat de travail, revision ${revision})}"
  _setup_info "${#posed[@]} fichiers poses ; l outil n est pas copie dans la cible"
}

_setup_cmd_versions() {
  _setup_check_deps

  local base="" target
  while [ $# -gt 0 ]; do
    case "$1" in
      -C) base="${2:-}"; shift 2 ;;
      --debug|--dry-run) shift ;;
      -h|--help) _setup_help; return 0 ;;
      *) shift ;;
    esac
  done
  if [ -n "${base}" ]; then
    target="${base}"
  else
    target="$(git rev-parse --show-toplevel 2>/dev/null || pwd)"
  fi

  local installed="" state
  state="$(_setup_target_state "${target}")"
  case "${state}" in
    equipped-marked)
      installed="$(yq -r '.version // ""' "${target}/${SETUP_MARK_FILE}")"
      ;;
  esac

  local tags; tags="$(git -C "${SETUP_ROOT}" tag -l 2>/dev/null | sort -V || true)"
  if [ -z "${tags}" ]; then
    _setup_warn "aucune version publiee : l arbre source ne porte aucune etiquette"
  else
    local latest t mark
    latest="$(printf '%s\n' "${tags}" | tail -1)"
    while IFS= read -r t; do
      mark=""
      [ "${t}" = "${installed}" ] && mark="${mark} (installee)"
      [ "${t}" = "${latest}" ] && mark="${mark} (plus recente)"
      printf '%s%s\n' "${t}" "${mark}"
    done <<< "${tags}"
  fi

  case "${state}" in
    equipped-marked)
      printf 'installee ici : %s\n' "${installed}"
      if [ -n "${tags}" ] && ! printf '%s\n' "${tags}" | grep -qx "${installed}"; then
        _setup_warn "la version installee (${installed}) ne correspond a aucune version publiee"
      fi
      ;;
    equipped-unmarque|equipped-unmarked)
      _setup_err "depot equipe sans marque d installation : etat a regulariser (${target})"
      return 1
      ;;
    not-equipped)
      _setup_info "aucun systeme d augmentation installe ici (${target})"
      ;;
    no-repo)
      _setup_info "hors d un depot equipe (${target})"
      ;;
  esac
}

# --- dispatch ----------------------------------------------------------------

_setup_main() {
  local sub="${1:-}"
  case "${sub}" in
    install)            _setup_cmd_install ;;
    --check)            _setup_cmd_check ;;
    --uninstall)        _setup_cmd_uninstall ;;
    --contract-version) printf '%s\n' "${SETUP_CONTRACT_VERSION}" ;;
    init)               shift; _setup_cmd_init "$@" ;;
    versions)           shift; _setup_cmd_versions "$@" ;;
    -h|--help|"")       _setup_help ;;
    activate)
      _setup_err "activate doit etre source : . setup.sh activate"
      exit 2
      ;;
    *)
      _setup_err "commande inconnue : $1"
      _setup_help >&2
      exit 2
      ;;
  esac
}

if [ "${BASH_SOURCE[0]}" = "$0" ]; then
  _setup_main "$@"
else
  case "${1:-}" in
    activate) _setup_cmd_activate ;;
    ""|-h|--help) _setup_help ;;
    *) _setup_err "sourcage : seule 'activate' est supportee (recu : $1)" ;;
  esac
fi
