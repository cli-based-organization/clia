#!/usr/bin/env bash
# Description: La version du dépôt — ls, major, minor, patch.
# Périmètre: dépôt
#
# Implémente .dev/usages/USE-004-version-et-upgrade+downgrade.md.
#
# La source de vérité est le champ version de .dev/clia.yaml, sur la branche
# de publication. Ni un tag, ni un fichier de journal : le tag est posé en
# plus, pour que git retrouve une version sans lire de YAML, mais c'est le
# fichier qui fait foi. Un tag effacé ne fait pas disparaître une version.
#
# La version appartient au dépôt et non à une ressource : cette commande vit
# donc parmi celles du CLI. SPC-001 S7.
#
# Cette commande écrit dans l'historique git — elle commite et elle tague.
# C'est un geste de mainteneur, invoqué par un humain.

set -euo pipefail

_CLIA_NOM='clia'
# shellcheck source=../commun.sh
. "$CLIA_SOURCE_DIR/_scripts/lib/commun.sh"

CARTE="$CLIA_WORK_DIR/.dev/clia.yaml"

# --------------------------------------------------------------------------

aide() {
  cat <<'EOF'
Usage : clia release <verbe>

Verbes :
  ls                    les versions publiées, de la plus récente à la plus
                        ancienne, et la version effective du dépôt
  major | minor | patch incrémente la version, commite, et pose le tag

La source de vérité est le champ version de .dev/clia.yaml, sur la branche de
publication. Une version publiée est un commit qui change ce champ ; le tag
vX.Y.Z est posé en plus, pour que git la retrouve seul.

La version effective porte le hash court de HEAD tant que le dépôt a avancé
depuis la dernière publication : 0.1.0+a1b2c3d se lit « après 0.1.0 ».

Un incrément est refusé si :
  - le dépôt git n'est pas propre
  - rien n'a changé depuis la dernière publication
  - la branche courante n'est pas la branche de publication

Codes de retour :
  0  la demande est satisfaite
  1  refus : une des trois conditions ci-dessus, ou pas de version déclarée
  2  demande mal formée
EOF
}

git_() { git -C "$CLIA_WORK_DIR" "$@"; }

# La branche de publication : main si le dépôt en a une, la branche courante
# sinon. USE-004 dit « sur la branche main » ; un dépôt qui n'en a pas ne doit
# pas pour autant devenir impubliable.
branche_de_publication() {
  if git_ show-ref --verify --quiet refs/heads/main; then
    printf 'main\n'
  else
    git_ branch --show-current
  fi
}

version_declaree() {
  _clia_carte_champ "$CLIA_WORK_DIR" version 2>/dev/null || printf ''
}

# La version que porte .dev/clia.yaml à un commit donné, ou rien.
version_au_commit() {
  git_ show "$1:.dev/clia.yaml" 2>/dev/null \
    | grep -m1 -E '^version:[[:space:]]' \
    | sed -E 's/^version:[[:space:]]*//; s/^"//; s/"$//' || true
}

# Les publications, de la plus récente à la plus ancienne : « version<TAB>hash
# court<TAB>date ».
#
# Une publication est un commit où le champ version diffère de celui de son
# parent. C'est la lecture directe de « la source de vérité est le fichier » :
# l'historique du fichier porte l'historique des versions, sans qu'aucun
# registre n'ait à être tenu à côté.
publications() {
  local branche commit precedent version_ici version_avant
  branche=$(branche_de_publication)
  [[ -n "$branche" ]] || return 0

  while IFS= read -r commit; do
    [[ -n "$commit" ]] || continue
    version_ici=$(version_au_commit "$commit")
    [[ -n "$version_ici" ]] || continue
    precedent=$(git_ rev-parse --verify --quiet "${commit}^" 2>/dev/null || printf '')
    if [[ -n "$precedent" ]]; then
      version_avant=$(version_au_commit "$precedent")
    else
      version_avant=''
    fi
    if [[ "$version_ici" != "$version_avant" ]]; then
      printf '%s\t%s\t%s\n' \
        "$version_ici" \
        "$(git_ rev-parse --short "$commit")" \
        "$(git_ show -s --format=%cs "$commit")"
    fi
  done < <(git_ log --format=%H "$branche" -- .dev/clia.yaml 2>/dev/null || true)
  return 0
}

# Le commit de la publication la plus récente, ou rien.
commit_de_publication() {
  local branche commit precedent vi va
  branche=$(branche_de_publication)
  [[ -n "$branche" ]] || return 0
  while IFS= read -r commit; do
    [[ -n "$commit" ]] || continue
    vi=$(version_au_commit "$commit")
    [[ -n "$vi" ]] || continue
    precedent=$(git_ rev-parse --verify --quiet "${commit}^" 2>/dev/null || printf '')
    if [[ -n "$precedent" ]]; then va=$(version_au_commit "$precedent"); else va=''; fi
    if [[ "$vi" != "$va" ]]; then printf '%s\n' "$commit"; return 0; fi
  done < <(git_ log --format=%H "$branche" -- .dev/clia.yaml 2>/dev/null || true)
  return 0
}

# X.Y.Z si HEAD est la publication elle-même, X.Y.Z+hash sinon. USE-004 : une
# version identique à celle du commit précédent est une version de
# développement, et le hash dit laquelle.
version_effective() {
  local declaree tete publication
  declaree=$(version_declaree)
  [[ -n "$declaree" ]] || { printf '\n'; return 0; }

  tete=$(git_ rev-parse --verify --quiet HEAD 2>/dev/null || printf '')
  if [[ -z "$tete" ]]; then
    printf '%s\n' "$declaree"
    return 0
  fi
  publication=$(commit_de_publication)
  if [[ -n "$publication" && "$publication" == "$tete" ]]; then
    printf '%s\n' "$declaree"
  else
    printf '%s+%s\n' "$declaree" "$(git_ rev-parse --short HEAD)"
  fi
}

# --------------------------------------------------------------------------

lister() {
  local declaree effective
  declaree=$(version_declaree)
  if [[ -z "$declaree" ]]; then
    _clia_msg "aucune version déclarée dans .dev/clia.yaml"
    _clia_detail "un dépôt instrumenté en porte une : clia init la pose"
    exit 1
  fi

  effective=$(version_effective)
  printf 'version déclarée   %s\n' "$declaree"
  if [[ "$effective" != "$declaree" ]]; then
    printf 'version effective  %s   (le dépôt a avancé depuis la publication)\n' "$effective"
  else
    printf 'version effective  %s\n' "$effective"
  fi
  printf 'branche            %s\n' "$(branche_de_publication)"

  local lignes
  lignes=$(publications)
  if [[ -z "$lignes" ]]; then
    printf '\naucune version publiée : .dev/clia.yaml n'\''a jamais été commité\n'
    return 0
  fi

  printf '\n'
  {
    printf 'VERSION\tCOMMIT\tDATE\tTAG\n'
    while IFS=$'\t' read -r v c d; do
      [[ -n "$v" ]] || continue
      local tag='—'
      git_ rev-parse --verify --quiet "refs/tags/v$v" >/dev/null 2>&1 && tag="v$v"
      printf '%s\t%s\t%s\t%s\n' "$v" "$c" "$d" "$tag"
    done <<<"$lignes"
  } | column -t -s"$(printf '\t')"
}

incrementer() {
  local niveau="$1" declaree branche courante
  declaree=$(version_declaree)

  if [[ -z "$declaree" ]]; then
    _clia_msg "aucune version déclarée dans .dev/clia.yaml"
    _clia_detail "rien à incrémenter"
    exit 1
  fi
  if [[ ! "$declaree" =~ ^([0-9]+)\.([0-9]+)\.([0-9]+)$ ]]; then
    _clia_msg "la version déclarée n'est pas un semver : $declaree"
    _clia_detail "attendu X.Y.Z, trois nombres séparés par des points"
    exit 1
  fi
  local majeur="${BASH_REMATCH[1]}" mineur="${BASH_REMATCH[2]}" correctif="${BASH_REMATCH[3]}"

  # Les trois refus de USE-004, vérifiés avant toute écriture.
  branche=$(branche_de_publication)
  courante=$(git_ branch --show-current)
  if [[ -n "$branche" && "$courante" != "$branche" ]]; then
    _clia_msg "la branche courante n'est pas celle de publication"
    _clia_detail "courante    : ${courante:-détachée}"
    _clia_detail "publication : $branche"
    _clia_detail "rien n'a été modifié"
    exit 1
  fi

  if [[ -n "$(git_ status --porcelain)" ]]; then
    _clia_msg "le dépôt n'est pas propre, rien n'a été modifié"
    _clia_detail "une publication ne doit emporter que le changement de version"
    _clia_detail "l'état du dépôt : git status"
    exit 1
  fi

  local publication tete
  publication=$(commit_de_publication)
  tete=$(git_ rev-parse --verify --quiet HEAD 2>/dev/null || printf '')
  if [[ -n "$publication" && "$publication" == "$tete" ]]; then
    _clia_msg "rien n'a changé depuis la publication de $declaree"
    _clia_detail "publier deux fois le même état donnerait deux versions identiques"
    _clia_detail "rien n'a été modifié"
    exit 1
  fi

  case "$niveau" in
    major) majeur=$((majeur + 1)); mineur=0; correctif=0 ;;
    minor) mineur=$((mineur + 1)); correctif=0 ;;
    patch) correctif=$((correctif + 1)) ;;
  esac
  local nouvelle="${majeur}.${mineur}.${correctif}"

  if git_ rev-parse --verify --quiet "refs/tags/v$nouvelle" >/dev/null 2>&1; then
    _clia_msg "le tag v$nouvelle existe déjà"
    _clia_detail "rien n'a été modifié"
    exit 1
  fi

  # La ligne est remplacée, le reste du fichier ne bouge pas : commentaires et
  # autres champs appartiennent au dépôt, pas à cette commande.
  local tmp
  tmp=$(mktemp)
  sed -E "s|^version:[[:space:]].*$|version: ${nouvelle}|" "$CARTE" > "$tmp"
  mv "$tmp" "$CARTE"

  git_ add .dev/clia.yaml
  git_ commit -q -m "release ${nouvelle}"
  git_ tag "v${nouvelle}"

  _clia_msg "version ${declaree} -> ${nouvelle}"
  _clia_detail "commit créé : release ${nouvelle}"
  _clia_detail "tag posé    : v${nouvelle}"
  _clia_detail "branche     : ${courante}"
  _clia_detail ''
  _clia_detail "rien n'est poussé : git push --follow-tags le fera"
}

# --------------------------------------------------------------------------

VERBE="${1:-}"
shift 2>/dev/null || true

if (( $# > 0 )); then
  _clia_msg "release ne prend pas d'argument après son verbe : $*"
  exit 2
fi

case "$VERBE" in
  ls|list)             lister ;;
  major|minor|patch)   incrementer "$VERBE" ;;
  -h|--help|help|'')   aide ;;
  *)
    _clia_msg "verbe inconnu pour release : $VERBE"
    _clia_detail "les verbes connus : ls, major, minor, patch"
    exit 2 ;;
esac
