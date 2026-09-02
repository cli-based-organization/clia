# shellcheck shell=bash
# _scripts/lib/ressource.sh — le verbe que toutes les ressources portent.
#
# Implémente SES-001 tâche 11 : « ajouter une commande générique à toutes les
# ressources permettant de désinstaller la ressource ».
#
# Pourquoi ici, et non dans chaque script de ressource
# ----------------------------------------------------
#
# Une ressource écrit ce qu'elle sait faire. Retirer une ressource n'est pas
# quelque chose qu'une ressource sait faire : c'est quelque chose que le
# dépôt fait d'une ressource. Le geste est le même pour toutes, et le tenir
# une fois vaut mieux que le voir recopié dans chaque script — d'autant
# qu'une ressource reprise d'une extension n'aurait aucune raison de le
# porter.
#
# Le point d'entrée intercepte donc « clia <ressource> deactivate » avant de
# passer la main au script, et l'aide de chaque ressource l'annonce.
#
# Ce fichier porte aussi le retrait lui-même, parce que deux commandes le
# font : « clia <ressource> deactivate » en retire une, « clia extension
# uninstall » retire celles qui viennent d'une extension. Les refus doivent
# être les mêmes des deux côtés, et deux écritures finiraient par diverger.
#
# Ce que la désactivation refuse, et pourquoi
# -------------------------------------------
#
# Elle efface des fichiers. Trois refus la rendent sûre à lancer :
#
#   ce que le dépôt publie ne se désinstalle pas. Le bloc « provide: » de la
#   carte dit ce que ce dépôt-ci offre aux autres ; retirer cela serait
#   retirer ce qu'il est, non ce qu'il a pris ailleurs.
#
#   ce qui n'est pas dans le dépôt de travail ne s'y retire pas. Une
#   ressource du dépôt source de clia est atteinte de partout ; elle n'est
#   installée nulle part, et il n'y a rien à défaire.
#
#   ce que git ne tient pas encore ne s'efface pas. Une ressource non
#   commitée, ou modifiée depuis son dernier commit, disparaîtrait sans
#   retour. clia demande de la commiter d'abord — après quoi l'historique la
#   rend.

# Les deux verbes que le point d'entrée tient pour toutes les ressources :
# « deactivate », qui retire la ressource, et « provide », qui dit ce qu'elle
# apporte. Le second a besoin de savoir lire les fournitures.
#
# shellcheck source=texte.sh
. "${CLIA_SOURCE_DIR:-}/_scripts/lib/texte.sh"
# shellcheck source=fourniture.sh
. "${CLIA_SOURCE_DIR:-}/_scripts/lib/fourniture.sh"

_clia_r_definition() { printf '%s/_ressources/%s/%s.yaml\n' "$1" "$2" "$2"; }

# Le nom de la ressource que porte un fichier de commande, ou rien.
# Le chemin est <racine>/_ressources/<nom>/_scripts/<commande>.sh.
_clia_r_nom_de_fichier() {
  local dir
  dir=$(dirname "$(dirname "$1")")
  [[ "$(basename "$(dirname "$dir")")" == '_ressources' ]] || return 1
  basename "$dir"
}

# La racine du dépôt d'où vient un fichier de commande.
_clia_r_racine_de_fichier() {
  local dir
  dir=$(dirname "$(dirname "$(dirname "$(dirname "$1")")")")
  printf '%s\n' "$dir"
}

# Vrai si la carte du dépôt déclare publier cette ressource.
_clia_r_est_publiee() {
  local depot="$1" nom="$2" carte n
  carte=$(_clia_carte "$depot") || return 1
  while IFS="$_CLIA_SEP" read -r _ n; do
    [[ "$n" == "$nom" ]] && return 0
  done < <(_clia_bloc_yaml "$carte" provide prefix name)
  return 1
}

# _clia_r_identite <dépôt> <nom> — l'identité sous laquelle l'inventaire
# porte cette ressource, ou rien. Elle s'écrit <provider>/<PREFIXE>.
_clia_r_identite() {
  local depot="$1" nom="$2" prefixe id
  prefixe=$(_clia_champ_yaml "$(_clia_r_definition "$depot" "$nom")" prefixe || printf '')
  [[ -n "$prefixe" ]] || return 1
  while IFS="$_CLIA_SEP" read -r id _; do
    [[ "$id" == */"$prefixe" ]] || continue
    printf '%s\n' "$id"
    return 0
  done < <(_clia_installees "$depot")
  return 1
}

# _clia_r_nom_du_prefixe <dépôt> <PREFIXE> — la ressource du dépôt qui porte
# ce préfixe, ou rien.
_clia_r_nom_du_prefixe() {
  local depot="$1" prefixe="$2" nom p
  while IFS=$'\t' read -r nom p _; do
    [[ "$p" == "$prefixe" ]] && { printf '%s\n' "$nom"; return 0; }
  done < <(_clia_ressources_de "$depot")
  return 1
}

# _clia_r_verifier_retrait <dépôt> <nom> — 0 si la ressource peut être
# retirée, sinon un refus nommé sur la sortie d'erreur.
_clia_r_verifier_retrait() {
  local depot="$1" nom="$2" sale

  if [[ ! -d "$depot/_ressources/$nom" ]]; then
    _clia_msg "$nom n'est pas installée dans ce dépôt"
    return 1
  fi

  if _clia_r_est_publiee "$depot" "$nom"; then
    _clia_msg "$nom est une ressource que ce dépôt publie"
    _clia_detail "elle figure dans le bloc « provide: » de sa carte"
    _clia_detail "on ne désinstalle pas ce qu'on publie ; retirez-la de provide: d'abord"
    return 1
  fi

  # Ce que git ne tient pas encore disparaîtrait sans retour.
  sale=$(git -C "$depot" status --porcelain -- "_ressources/$nom" 2>/dev/null || printf '')
  if [[ -n "$sale" ]]; then
    _clia_msg "$nom porte des changements que git ne tient pas encore"
    _clia_detail "elle serait effacée sans retour ; commitez-la d'abord"
    printf '%s\n' "$sale" >&2
    return 1
  fi

  return 0
}

# _clia_r_retirer <dépôt> <nom> — efface la ressource et l'ôte de
# l'inventaire. La vérification est supposée faite.
_clia_r_retirer() {
  local depot="$1" nom="$2" carte id
  carte=$(_clia_carte "$depot") || carte=''
  if [[ -n "$carte" ]] && id=$(_clia_r_identite "$depot" "$nom"); then
    _clia_carte_retirer "$carte" use.extensions resource "$id" \
      || _clia_carte_retirer "$carte" use.extensions ressource "$id" \
      || true
  fi
  rm -rf "${depot:?}/_ressources/$nom"
  return 0
}

# _clia_r_desactiver <commande> <fichier> — retire du dépôt de travail la
# ressource que cette commande porte.
_clia_r_desactiver() {
  local commande="$1" fichier="$2" depot="${CLIA_WORK_DIR:-}" nom racine id ns=''

  if ! nom=$(_clia_r_nom_de_fichier "$fichier"); then
    _clia_msg "clia $commande n'est pas la commande d'une ressource"
    _clia_detail "deactivate ne vaut que pour une ressource"
    return 2
  fi

  racine=$(_clia_r_racine_de_fichier "$fichier")
  if [[ "$racine" != "$depot" ]]; then
    _clia_msg "$nom n'est pas installée dans ce dépôt"
    _clia_detail "elle vient de $racine, et y reste"
    _clia_detail "ce dépôt ne porte que ce que clia extension install y a repris"
    return 1
  fi

  _clia_r_verifier_retrait "$depot" "$nom" || return 1

  id=$(_clia_r_identite "$depot" "$nom") && ns="${id%/*}"
  _clia_r_retirer "$depot" "$nom"

  _clia_msg "$nom retirée de ce dépôt : _ressources/$nom"
  [[ -n "$ns" ]] && _clia_detail "et de l'inventaire de la carte"
  _clia_detail "la commande « clia $commande » ne répond plus ici"
  _clia_detail "pour la reprendre : clia extension install ${ns:-EXTENSION}"
  _clia_detail "rien n'est commité"
  return 0
}

# --------------------------------------------------------------------------
# provide — ce qu'une ressource apporte
# --------------------------------------------------------------------------
#
# SES-001 tâche 15. Trois natures de fourniture, dans une seule table : la
# question « qu'est-ce que cette ressource m'apporte » ne se pose pas trois
# fois, et y répondre en trois commandes obligerait à les appeler toutes pour
# savoir.
#
# Les commandes clia-feature(1), clia-skill(1) et clia-script(1) répondent à
# l'autre question — « qu'est-ce que tout le dépôt porte de telle nature » —
# et c'est elles qui activent et désactivent.

# _clia_r_provide <commande> <fichier>
_clia_r_provide() {
  local commande="$1" fichier="$2" depot="${CLIA_WORK_DIR:-}" nom prefixe harnais
  local p item desc sig etat lignes=''

  if ! nom=$(_clia_r_nom_de_fichier "$fichier"); then
    _clia_msg "clia $commande n'est pas la commande d'une ressource"
    return 2
  fi

  prefixe=$(_clia_champ_yaml \
    "$(_clia_r_racine_de_fichier "$fichier")/_ressources/$nom/$nom.yaml" prefixe || printf '')
  harnais=$(_clia_f_harnais "$depot")

  while IFS="$_CLIA_SEP" read -r p _ item _ desc; do
    [[ "$p" == "$prefixe" ]] || continue
    if _clia_t_pose "$harnais" "$item" feature; then etat='active'; else etat='inactive'; fi
    lignes+=$(printf 'fonctionnalité\t%s\t%s\t%s' "$item" "$etat" "${desc:-—}")$'\n'
  done < <(_clia_f_features "$depot")

  while IFS="$_CLIA_SEP" read -r p _ item _ desc; do
    [[ "$p" == "$prefixe" ]] || continue
    if [[ -d "$depot/.claude/skills/$item" ]]; then etat='actif'; else etat='inactif'; fi
    lignes+=$(printf 'skill\t%s\t%s\t%s' "$item" "$etat" "${desc:-—}")$'\n'
  done < <(_clia_f_skills "$depot")

  while IFS="$_CLIA_SEP" read -r p _ item sig; do
    [[ "$p" == "$prefixe" ]] || continue
    if _clia_f_est_desactive "$depot" "$p" "$item"; then etat='désactivé'; else etat='actif'; fi
    lignes+=$(printf 'script\t%s\t%s\t%s' "$item" "$etat" "$sig")$'\n'
  done < <(_clia_f_scripts "$depot")

  if [[ -z "$lignes" ]]; then
    _clia_msg "$nom n'apporte rien pour l'instant"
    _clia_detail "une ressource apporte des fonctionnalités, des skills et des scripts"
    _clia_detail "ils se rangent sous features/, skills/ et _scripts/"
    return 0
  fi

  { printf 'FOURNITURE\tNOM\tETAT\tDESCRIPTION\n'
    printf '%s' "$lignes"
  } | column -t -s $'\t'

  _clia_msg "ressource $nom ($prefixe)"
  _clia_detail "poser une fonctionnalité : clia feature activate NOM"
  _clia_detail "poser un skill           : clia skill activate NOM"
  return 0
}
