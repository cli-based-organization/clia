# shellcheck shell=bash
# _scripts/lib/version.sh — la version, et sa publication.
#
# Ce module porte les règles ; les commandes ne portent que la mise en forme.
#
# Pourquoi il existe. SES-001 tâche 5 demande que la version d'une ressource
# fonctionne « exactement comme celle du repo ». Deux écritures parallèles ne
# peuvent pas garantir un « exactement » : elles peuvent seulement se
# ressembler, jusqu'au jour où l'une est corrigée sans l'autre. Une seule
# écriture, appelée depuis les deux endroits, le garantit par construction.
#
# Ce que le module ne connaît pas : ce qu'est un dépôt, ce qu'est une
# ressource, où vit une carte. Il reçoit un dépôt, un fichier qui porte le
# champ « version », et un chemin dont l'historique fait foi.
#
# Le vocabulaire est celui de la tâche 1 :
#
#   source de vérité   le commit
#   version exacte     son empreinte
#   alias de version   X.Y.Z[-tag], lisible, inscrit à la main, faillible
#   version publiée    l'alias diffère de celui du commit précédent
#   version de travail l'alias est le même — rien n'a été publié depuis, et
#                      l'alias devient X.Y.Z+<hash court>

# --------------------------------------------------------------------------
# Le champ « version »
# --------------------------------------------------------------------------
#
# Le motif exige la colonne zéro. C'est ce qui distingue le champ « version »
# d'un document des champs « version » imbriqués, qui en désignent d'autres.

# _clia_v_alias_disque <fichier> — l'alias que porte un fichier, ou rien.
_clia_v_alias_disque() {
  _clia_champ_yaml "$1" version
}

# _clia_v_alias_au_commit <depot> <commit> <chemin…> — l'alias que porte, à ce
# commit, le premier des chemins qui existe. Plusieurs chemins sont admis
# parce qu'un fichier a pu être déplacé dans l'historique.
_clia_v_alias_au_commit() {
  local depot="$1" commit="$2"; shift 2
  local chemin contenu ligne
  for chemin in "$@"; do
    contenu=$(git -C "$depot" show "$commit:$chemin" 2>/dev/null) || continue
    ligne=$(printf '%s\n' "$contenu" | grep -m1 -E '^version:[[:space:]]') || continue
    _clia_valeur_yaml "${ligne#*:}"
    return 0
  done
  return 1
}

# --------------------------------------------------------------------------
# Les deux commits qui décident de l'état
# --------------------------------------------------------------------------
#
# Sans portée, ce sont HEAD et son parent : la version du dépôt tout entier.
#
# Avec une portée — le répertoire d'une ressource — ce sont les deux derniers
# commits qui l'ont touchée. C'est ce qui fait qu'une ressource inchangée
# depuis cinquante commits garde la même version exacte : son état ne dépend
# que de ce qui la concerne, et un travail voisin ne la déplace pas.

# _clia_v_commit <depot> [portée] — le commit qui porte l'état courant.
_clia_v_commit() {
  local depot="$1" portee="${2:-}"
  if [[ -z "$portee" ]]; then
    git -C "$depot" rev-parse --verify --quiet HEAD 2>/dev/null || return 1
    return 0
  fi
  local commit
  commit=$(git -C "$depot" log -1 --format=%H -- "$portee" 2>/dev/null) || return 1
  [[ -n "$commit" ]] || return 1
  printf '%s\n' "$commit"
}

# _clia_v_commit_avant <depot> <commit> [portée] — celui qui le précède.
_clia_v_commit_avant() {
  local depot="$1" commit="$2" portee="${3:-}"
  if [[ -z "$portee" ]]; then
    git -C "$depot" rev-parse --verify --quiet "${commit}^" 2>/dev/null || return 1
    return 0
  fi
  local precedent
  precedent=$(git -C "$depot" log -1 --format=%H "${commit}^" -- "$portee" 2>/dev/null) || return 1
  [[ -n "$precedent" ]] || return 1
  printf '%s\n' "$precedent"
}

# --------------------------------------------------------------------------
# L'état
# --------------------------------------------------------------------------

# _clia_v_resoudre <depot> <portée> <chemin…>
#
# Rend « commit<TAB>alias<TAB>état », où l'état vaut « publiee » ou
# « travail ». Échoue s'il n'y a pas de commit, ou pas d'alias à ce commit.
#
# Un commit sans précédent est traité comme une publication : il n'existe pas
# d'alias antérieur dont celui-ci pourrait être la répétition.
_clia_v_resoudre() {
  local depot="$1" portee="$2"; shift 2
  local commit avant alias_ici alias_avant etat

  commit=$(_clia_v_commit "$depot" "$portee") || return 1
  alias_ici=$(_clia_v_alias_au_commit "$depot" "$commit" "$@") || return 1

  if avant=$(_clia_v_commit_avant "$depot" "$commit" "$portee"); then
    alias_avant=$(_clia_v_alias_au_commit "$depot" "$avant" "$@" || printf '')
  else
    alias_avant=''
  fi

  if [[ "$alias_ici" == "$alias_avant" ]]; then etat='travail'; else etat='publiee'; fi
  printf '%s\t%s\t%s\n' "$commit" "$alias_ici" "$etat"
}

# _clia_v_alias_affiche <alias> <état> <hash court> — l'alias tel qu'il se lit.
_clia_v_alias_affiche() {
  if [[ "$2" == 'travail' ]]; then printf '%s+%s\n' "$1" "$3"; else printf '%s\n' "$1"; fi
}

# --------------------------------------------------------------------------
# La forme d'un alias
# --------------------------------------------------------------------------

_CLIA_V_SEMVER='^(v?)([0-9]+)\.([0-9]+)\.([0-9]+)(-[0-9A-Za-z.-]+)?$'

_clia_v_est_semantique() {
  [[ "$1" =~ $_CLIA_V_SEMVER ]]
}

# _clia_v_incrementer <alias> <niveau> — l'alias incrémenté, ou un échec.
#
# Le préfixe « v » facultatif est conservé : on incrémente ce qui est déclaré,
# on ne le reformate pas. Le tag de pré-publication est retiré — une version
# publiée n'est pas une pré-publication, et le garder ferait qu'un incrément
# de correctif depuis 0.1.0-beta rendrait 0.1.1-beta, qui n'en est pas une.
#
# Les groupes de la correspondance sont lus directement, sans passer par une
# ligne à découper : un préfixe absent y produirait un champ vide que le
# découpage ferait disparaître, et tous les nombres se décaleraient d'un rang.
#
# La base dix est forcée : un alias tel que 1.08.0 est mal formé au regard de
# semver, mais le motif l'accepte, et l'arithmétique du shell lirait 08 comme
# un octal invalide plutôt que comme huit.
_clia_v_incrementer() {
  local alias="$1" niveau="$2" prefixe major minor patch
  [[ "$alias" =~ $_CLIA_V_SEMVER ]] || return 1
  prefixe="${BASH_REMATCH[1]}"
  major=$((10#${BASH_REMATCH[2]}))
  minor=$((10#${BASH_REMATCH[3]}))
  patch=$((10#${BASH_REMATCH[4]}))
  case "$niveau" in
    major) major=$((major + 1)); minor=0; patch=0 ;;
    minor) minor=$((minor + 1)); patch=0 ;;
    patch) patch=$((patch + 1)) ;;
    *)     return 1 ;;
  esac
  printf '%s%s.%s.%s\n' "$prefixe" "$major" "$minor" "$patch"
}

# --------------------------------------------------------------------------
# Écrire, et publier
# --------------------------------------------------------------------------

# _clia_v_ecrire_alias <fichier> <nouveau>
#
# Seule la première ligne « version: » en colonne zéro est touchée, et un
# commentaire de fin de ligne est conservé. L'écriture passe par un fichier
# temporaire : une écriture interrompue laisserait le fichier tronqué, et ce
# fichier est ce qui identifie ce qu'il décrit.
_clia_v_ecrire_alias() {
  local fichier="$1" nouveau="$2" tmp
  tmp=$(mktemp "${fichier}.XXXXXX") || return 1
  if ! awk -v nouveau="$nouveau" '
        /^version:[ \t]/ && !fait {
          commentaire = ""
          if (match($0, /#.*/)) commentaire = "  " substr($0, RSTART)
          print "version: " nouveau commentaire
          fait = 1
          next
        }
        { print }
      ' "$fichier" > "$tmp"; then
    rm -f "$tmp"
    return 1
  fi
  chmod --reference="$fichier" "$tmp" 2>/dev/null || true
  mv -f "$tmp" "$fichier"
}

_clia_v_depot_propre() {
  [[ -z "$(git -C "$1" status --porcelain 2>/dev/null)" ]]
}

# _clia_v_publier <depot> <fichier relatif> <nouvel alias> <message>
#
# Écrit l'alias et commite ce seul fichier. Si le commit échoue, le fichier
# est remis dans l'état de HEAD : publier est tout ou rien.
#
# L'appelant a vérifié que le dépôt est propre et que l'alias est
# incrémentable ; cette fonction ne fait que le geste.
_clia_v_publier() {
  local depot="$1" relatif="$2" nouveau="$3" message="$4"

  _clia_v_ecrire_alias "$depot/$relatif" "$nouveau" || {
    _clia_msg "$relatif n'a pas pu être réécrit"
    return 1
  }

  if ! git -C "$depot" add -- "$relatif" \
     || ! git -C "$depot" commit -q -m "$message" -- "$relatif"; then
    _clia_msg "le commit de publication a échoué : rien n'est publié"
    _clia_detail "le fichier est remis dans l'état de HEAD"
    git -C "$depot" reset -q HEAD -- "$relatif" 2>/dev/null || true
    git -C "$depot" checkout -q -- "$relatif" 2>/dev/null || true
    return 1
  fi
  return 0
}
