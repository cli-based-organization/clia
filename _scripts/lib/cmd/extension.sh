#!/usr/bin/env bash
# Description: Les extensions du dépôt — add, ls, install.
# Périmètre: dépôt
# Alias: ext extensions
#
# Implémente .dev/usages/USE-006-ajout-dun-repo-externe.md.
#
# Une extension est un dépôt clia dont le dépôt courant reprend des
# ressources. Elle est déclarée dans l'inventaire de .dev/clia.yaml, qui est
# versionné, et clonée dans un cache de la machine, qui ne l'est pas — voir la
# note de _scripts/lib/commun.sh.
#
# Une extension n'est pas une ressource : elle est une provenance, pas une
# chose que le dépôt produit. SPC-001 S7, d'où la place de ce fichier.

set -euo pipefail

_CLIA_NOM='clia'
# shellcheck source=../commun.sh
. "$CLIA_SOURCE_DIR/_scripts/lib/commun.sh"

# --------------------------------------------------------------------------

aide() {
  cat <<'EOF'
Usage : clia extension <verbe> [arguments]

Verbes :
  add URI          déclare un dépôt clia comme extension, et le clone
  ls               les extensions déclarées, et leur état
  install NAMESPACE
                   reprend dans le dépôt tout ce que l'extension offre :
                   ses ressources, avec les skills et fonctionnalités
                   qu'elles portent

Deux endroits, et c'est voulu :
  .dev/clia.yaml         la déclaration, versionnée, qui suit le dépôt
  ~/.cache/clia/…        le clone, propre à cette machine

Une extension déclarée dont le clone manque est dite « non clonée » : elle
est connue du dépôt, mais rien ne peut en être lu tant qu'elle n'est pas là.

Une fois une extension ajoutée, ce qu'elle offre se lit et se reprend comme
le reste :
  clia res ls --remote NAMESPACE
  clia res activate NAMESPACE RESSOURCE

clia ext et clia extensions répondent aussi.

Codes de retour :
  0  la demande est satisfaite
  1  refus : URI inutilisable, extension inconnue, ou clone impossible
  2  demande mal formée
EOF
}

# Le namespace que déclare un dépôt cloné. C'est lui qui identifie
# l'extension, et non l'URI : deux URI peuvent mener au même dépôt, un
# namespace n'en désigne qu'un.
namespace_de() {
  _clia_carte_champ "$1" namespace 2>/dev/null || printf ''
}

ajouter() {
  local uri="${1:-}"
  if [[ -z "$uri" ]]; then
    _clia_msg "add attend l'URI d'un dépôt git"
    _clia_detail "usage : clia extension add URI"
    exit 2
  fi
  if (( $# > 1 )); then
    _clia_msg "add ne prend qu'une URI : $*"
    exit 2
  fi

  # Le clone va d'abord dans un temporaire : tant que le dépôt n'a pas montré
  # qu'il est une extension clia, il n'a rien à faire dans le cache.
  local tmp
  tmp=$(mktemp -d)
  # shellcheck disable=SC2064
  trap "rm -rf '$tmp'" EXIT

  if ! git clone --quiet "$uri" "$tmp/depot" 2>/dev/null; then
    _clia_msg "le clone a échoué : $uri"
    _clia_detail "l'URI est-elle celle d'un dépôt git accessible ?"
    _clia_detail "rien n'a été déclaré"
    exit 1
  fi

  # Un dépôt sans commit se clone sans erreur, et donne un répertoire vide.
  # Le distinguer d'un dépôt qui n'est pas une extension évite d'accuser le
  # second de ce dont le premier est coupable.
  if ! git -C "$tmp/depot" rev-parse --verify --quiet HEAD >/dev/null 2>&1; then
    _clia_msg "ce dépôt n'a aucun commit : $uri"
    _clia_detail "il n'y a rien à en cloner, et donc rien à en reprendre"
    _clia_detail "rien n'a été déclaré"
    exit 1
  fi

  local ns
  ns=$(namespace_de "$tmp/depot")
  if [[ -z "$ns" ]]; then
    _clia_msg "ce dépôt n'est pas une extension clia"
    _clia_detail "il ne porte pas de .dev/clia.yaml déclarant un namespace"
    _clia_detail "un dépôt le devient avec : clia init, puis un commit"
    _clia_detail "rien n'a été déclaré, et le clone est jeté"
    exit 1
  fi

  local propre
  propre=$(namespace_de "$CLIA_WORK_DIR")
  if [[ -n "$propre" && "$ns" == "$propre" ]]; then
    _clia_msg "ce dépôt porte le namespace de celui-ci : $ns"
    _clia_detail "un dépôt ne peut pas être sa propre extension"
    exit 1
  fi

  # Déjà déclarée : on ne redéclare pas, mais on répare un clone manquant.
  local nom uri_declaree deja=''
  while IFS=$'\t' read -r nom uri_declaree; do
    [[ "$nom" == "$ns" ]] && deja="$uri_declaree"
  done < <(_clia_extensions_declarees)

  local cache
  cache=$(_clia_extension_cache "$ns")

  if [[ -n "$deja" ]]; then
    if [[ -d "$cache" ]]; then
      _clia_msg "extension déjà déclarée et clonée : $ns"
      _clia_detail "déclarée depuis : $deja"
      _clia_detail "rien n'a été modifié"
      return 0
    fi
    mkdir -p "$(dirname "$cache")"
    cp -r "$tmp/depot" "$cache"
    _clia_msg "extension déjà déclarée, clone rétabli : $ns"
    _clia_detail "cache : $cache"
    return 0
  fi

  mkdir -p "$(dirname "$cache")"
  rm -rf "$cache"
  cp -r "$tmp/depot" "$cache"

  local version
  version=$(_clia_carte_champ "$tmp/depot" version 2>/dev/null || printf '—')
  if ! _clia_enregistrer "$CLIA_WORK_DIR" extension "$ns" "$(basename "$ns")" "$version" "$uri"; then
    _clia_msg "ce dépôt n'a pas de .dev/clia.yaml, l'extension ne peut pas être déclarée"
    _clia_detail "un dépôt clia en porte un : clia check dira ce qui manque"
    exit 1
  fi

  _clia_msg "extension ajoutée : $ns"
  _clia_detail "déclarée dans .dev/clia.yaml"
  _clia_detail "clonée dans $cache"
  _clia_detail ''
  _clia_detail "ce qu'elle offre : clia res ls --remote $ns"
  _clia_detail "tout reprendre   : clia extension install $ns"
}

lister() {
  local lignes
  lignes=$(_clia_extensions_declarees)

  if [[ -z "$lignes" ]]; then
    _clia_msg "aucune extension déclarée dans ce dépôt"
    _clia_detail "pour en ajouter une : clia extension add URI"
    return 0
  fi

  local nom uri cache etat
  {
    printf 'NAMESPACE\tETAT\tURI\n'
    while IFS=$'\t' read -r nom uri; do
      [[ -n "$nom" ]] || continue
      cache=$(_clia_extension_cache "$nom")
      if [[ -d "$cache" ]]; then etat='clonée'; else etat='non clonée'; fi
      printf '%s\t%s\t%s\n' "$nom" "$etat" "$uri"
    done <<<"$lignes"
  } | column -t -s"$(printf '\t')"
}

# Reprendre tout ce qu'une extension offre.
#
# USE-006 dit « toutes les ressources, les skills, les scripts et les
# fonctionnalités par défaut ». Rien ne définit ce qui est « par défaut » :
# faute de déclaration, tout ce que l'extension porte est repris. Une
# ressource emporte déjà ses skills, ses scripts et ses fonctionnalités.
installer() {
  local ns="${1:-}"
  if [[ -z "$ns" ]]; then
    _clia_msg "install attend le namespace d'une extension"
    _clia_detail "celles qui sont déclarées : clia extension ls"
    exit 2
  fi
  if (( $# > 1 )); then
    _clia_msg "install ne prend qu'un namespace : $*"
    exit 2
  fi

  local nom uri trouvee=0
  while IFS=$'\t' read -r nom uri; do
    [[ "$nom" == "$ns" ]] && trouvee=1
  done < <(_clia_extensions_declarees)

  if (( trouvee == 0 )); then
    _clia_msg "extension inconnue : $ns"
    _clia_detail "celles qui sont déclarées : clia extension ls"
    exit 1
  fi

  local cache
  cache=$(_clia_extension_cache "$ns")
  if [[ ! -d "$cache" ]]; then
    _clia_msg "l'extension $ns est déclarée mais pas clonée"
    _clia_detail "pour la rétablir : clia extension add $uri"
    exit 1
  fi

  local res="$CLIA_SOURCE_DIR/_ressources/ressource/scripts/res.sh"
  local n reprises=0 sautees=0
  while IFS=$'\t' read -r n _; do
    [[ -n "$n" ]] || continue
    if [[ -e "$CLIA_WORK_DIR/_ressources/$n" ]]; then
      sautees=$((sautees + 1))
      continue
    fi
    # Chaque reprise passe par res activate : les contrôles qu'il applique —
    # préfixe distinctif, emplacement libre — valent aussi ici, et les
    # dupliquer les ferait diverger.
    if bash "$res" activate "$ns" "$n" >/dev/null 2>&1; then
      reprises=$((reprises + 1))
      _clia_detail "reprise : $n"
    else
      sautees=$((sautees + 1))
      _clia_detail "sautée  : $n (clia res activate $ns $n dira pourquoi)"
    fi
  done < <(_clia_ressources_de "$cache")

  if (( reprises == 0 && sautees == 0 )); then
    _clia_msg "l'extension $ns n'offre aucune ressource"
    return 0
  fi

  _clia_msg "extension $ns : $reprises ressource(s) reprise(s), $sautees sautée(s)"
  if (( reprises > 0 )); then
    _clia_detail "ce qui est là : clia res ls"
    _clia_detail "à poser au besoin : clia skill install, clia feature install"
  fi
}

# --------------------------------------------------------------------------

VERBE="${1:-}"
shift 2>/dev/null || true

case "$VERBE" in
  add)               ajouter "$@" ;;
  ls|list)           lister ;;
  install)           installer "$@" ;;
  -h|--help|help|'') aide ;;
  *)
    _clia_msg "verbe inconnu pour extension : $VERBE"
    _clia_detail "les verbes connus : add, ls, install"
    exit 2 ;;
esac
