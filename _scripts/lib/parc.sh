# shellcheck shell=bash
# _scripts/lib/parc.sh — le parc des ressources installées dans un dépôt.
#
# Implémente SES-002 tâche 1.
#
# Ce que « le parc » veut dire
# ----------------------------
#
# Un dépôt clia emploie des ressources : les siennes, et celles qu'il a
# reprises d'extensions. Le parc, c'est cet ensemble, vu du dépôt qui s'en
# sert — non du dépôt qui les publie.
#
# Quatre questions se posent à leur sujet, et ce fichier y répond une fois
# pour les cinq commandes qui les emploient :
#
#   d'où vient-elle ?      la source — le namespace de qui la publie
#   quelle version ?       celle qui est posée ici, et rien d'autre
#   est-elle en retard ?   par rapport à ce que sa source déclare aujourd'hui
#   répond-elle ?          sa commande est-elle réellement servie
#
# Pourquoi ces commandes sont au premier niveau
# ---------------------------------------------
#
# « clia res ls » liste ce que le dépôt écrit et ce qu'il a installé : c'est
# le point de vue de qui développe des ressources. « clia ls » liste ce dont
# le dépôt se sert : c'est le point de vue de qui les emploie.
#
# Les deux existent, et ce ne sont pas les mêmes lecteurs. SES-002 pose le
# second au premier niveau parce que c'est la question la plus fréquente d'un
# dépôt ordinaire — celui qui emploie clia sans en écrire les ressources.

# --------------------------------------------------------------------------
# Désigner une ressource
# --------------------------------------------------------------------------

# _clia_pc_resoudre <dépôt> <désignation> — le nom d'une ressource installée.
#
# Trois désignations valent : son nom, son préfixe, et la commande qu'elle
# porte — « session », « SES », « ses ». Ce sont les trois façons dont on la
# nomme ailleurs dans clia, et exiger la bonne serait exiger de savoir
# laquelle est la bonne.
#
# Une désignation qui n'en désigne aucune est refusée, et les candidates sont
# nommées : clia ne choisit pas à la place de l'appelant.
_clia_pc_resoudre() {
  local depot="$1" quoi="$2" nom prefixe minuscule
  minuscule=$(printf '%s' "$quoi" | tr '[:upper:]' '[:lower:]')

  while IFS=$'\t' read -r nom prefixe _; do
    [[ -n "$nom" ]] || continue
    if [[ "$nom" == "$quoi" ]] \
       || [[ "$prefixe" == "$(printf '%s' "$quoi" | tr '[:lower:]' '[:upper:]')" ]] \
       || [[ "$(printf '%s' "$prefixe" | tr '[:upper:]' '[:lower:]')" == "$minuscule" ]]; then
      printf '%s\n' "$nom"
      return 0
    fi
  done < <(_clia_ressources_de "$depot")

  _clia_msg "aucune ressource installée ne répond à « $quoi »"
  _clia_detail "elles se désignent par leur nom, leur préfixe ou leur commande"
  _clia_detail "celles qui sont là : clia ls"
  return 1
}

# --------------------------------------------------------------------------
# D'où une ressource vient
# --------------------------------------------------------------------------

# Ce dépôt publie-t-il cette ressource ? La lecture vit dans mise-a-jour.sh,
# où la mise à jour s'en sert pour savoir quelle est la source.
_clia_pc_publiee_ici() { _clia_mj_publiee_ici "$@"; }

# _clia_pc_source <dépôt> <nom> — le namespace de qui publie la ressource.
#
# Celui du dépôt lui-même quand il la publie, celui de l'extension d'où elle
# vient sinon. Une ressource dont la carte ne dit rien n'a pas de source : le
# dire vaut mieux que d'en supposer une.
_clia_pc_source() {
  local depot="$1" nom="$2" provider
  if _clia_pc_publiee_ici "$depot" "$nom"; then
    _clia_id_namespace "$depot" 2>/dev/null || printf '(namespace non déclaré)\n'
    return 0
  fi
  if IFS=$'\t' read -r provider _ < <(_clia_mj_provenance "$depot" "$nom"); then
    printf '%s\n' "$provider"
    return 0
  fi
  printf '—\n'
  return 0
}

# --------------------------------------------------------------------------
# Ce que sa source déclare aujourd'hui
# --------------------------------------------------------------------------

# _clia_pc_racine_et_def <dépôt> <nom> — « racine SEP définition relative » du
# dépôt qui publie la ressource. Rend 1 s'il n'est pas joignable.
#
# Un dépôt qui publie une ressource est sa propre source : ce qu'il en écrit
# sous son instance est ce vers quoi la copie installée peut monter. C'est ce
# qui rend visible le va-et-vient d'un dépôt qui développe ce qu'il emploie.
_clia_pc_racine_et_def() {
  local depot="$1" nom="$2" provider racine def
  if _clia_pc_publiee_ici "$depot" "$nom"; then
    racine="$depot"
  else
    IFS=$'\t' read -r provider _ < <(_clia_mj_provenance "$depot" "$nom") || return 1
    racine=$(_clia_mj_racine_extension "$depot" "$provider") || return 1
  fi
  def=$(_clia_mj_def_offerte "$racine" "$nom") || return 1
  printf '%s%s%s\n' "$racine" "$_CLIA_SEP" "$def"
  return 0
}

# _clia_pc_derniere <dépôt> <nom> — la dernière version que sa source déclare.
_clia_pc_derniere() {
  local racine def
  IFS="$_CLIA_SEP" read -r racine def < <(_clia_pc_racine_et_def "$1" "$2") || return 1
  _clia_m_derniere "$racine" "$def"
}

# _clia_pc_versions <dépôt> <nom> — « version TAB commit », de la plus
# ancienne à la plus récente.
_clia_pc_versions() {
  local racine def
  IFS="$_CLIA_SEP" read -r racine def < <(_clia_pc_racine_et_def "$1" "$2") || return 1
  _clia_m_versions "$racine" "$def"
}

# _clia_pc_etat <dépôt> <nom> <version posée> — « à jour », « en retard », ou
# « en avance » quand la copie dépasse ce que sa source déclare.
#
# « inconnu » n'est pas un jugement mis par défaut : il dit que la source n'a
# pas été jointe, et c'est une information, non une absence d'information.
_clia_pc_etat() {
  local depot="$1" nom="$2" posee="$3" derniere
  derniere=$(_clia_pc_derniere "$depot" "$nom") || { printf 'inconnu\n'; return 0; }
  case "$(_clia_m_comparer "$posee" "$derniere" 2>/dev/null)" in
    '0')  printf 'à jour\n' ;;
    '-1') printf 'en retard\n' ;;
    '1')  printf 'en avance\n' ;;
    *)    printf 'inconnu\n' ;;
  esac
  return 0
}

# --------------------------------------------------------------------------
# Répond-elle ?
# --------------------------------------------------------------------------
#
# Une ressource est active quand la commande qu'elle porte est réellement
# servie par elle. Elle ne l'est pas dans trois cas, et ils se constatent :
#
#   elle ne porte aucun script du nom de son préfixe ;
#   une commande du noyau porte ce nom, et le noyau l'emporte ;
#   une autre ressource, trouvée avant elle, porte déjà ce nom.
#
# Rien n'est déclaré : l'état se lit là où le point d'entrée regarde, et il ne
# peut donc pas mentir. C'est le même choix que pour l'état d'une
# fonctionnalité — REQ-001 §4.3.

# _clia_pc_commande <prefixe> — le nom de commande d'une ressource.
_clia_pc_commande() { printf '%s\n' "$(printf '%s' "$1" | tr '[:upper:]' '[:lower:]')"; }

# _clia_pc_actif <dépôt> <nom> <prefixe> — « actif SEP raison ».
_clia_pc_actif() {
  local depot="$1" nom="$2" prefixe="$3" commande racine autre autre_prefixe
  commande=$(_clia_pc_commande "$prefixe")

  if [[ -f "${CLIA_SOURCE_DIR:-}/_scripts/lib/cmd/$commande.sh" ]]; then
    printf 'inactif%s« clia %s » est une commande du noyau\n' "$_CLIA_SEP" "$commande"
    return 0
  fi

  local trouve=''
  for racine in "${CLIA_SOURCE_DIR:-}" "$depot"; do
    [[ -n "$racine" ]] || continue
    while IFS=$'\t' read -r autre autre_prefixe _; do
      [[ -n "$autre" ]] || continue
      [[ -f "$racine/$(_clia_zone_livree)/$autre/_scripts/$(_clia_pc_commande "$autre_prefixe").sh" ]] || continue
      [[ "$(_clia_pc_commande "$autre_prefixe")" == "$commande" ]] || continue
      [[ -z "$trouve" ]] && trouve="$autre"
    done < <(_clia_ressources_de "$racine")
  done

  if [[ -z "$trouve" ]]; then
    printf 'inactif%selle ne porte pas _scripts/%s.sh\n' "$_CLIA_SEP" "$commande"
    return 0
  fi
  if [[ "$trouve" != "$nom" ]]; then
    printf 'inactif%s« clia %s » est servie par %s\n' "$_CLIA_SEP" "$commande" "$trouve"
    return 0
  fi
  printf 'actif%s—\n' "$_CLIA_SEP"
  return 0
}

# --------------------------------------------------------------------------
# Le parc, d'un coup
# --------------------------------------------------------------------------

# _clia_pc_parc <dépôt> — une ligne par ressource installée :
# « prefixe SEP nom SEP source SEP version SEP etat SEP actif SEP raison ».
_clia_pc_parc() {
  local depot="$1" nom prefixe version etat actif raison
  while IFS=$'\t' read -r nom prefixe version; do
    [[ -n "$nom" ]] || continue
    etat=$(_clia_pc_etat "$depot" "$nom" "$version")
    IFS="$_CLIA_SEP" read -r actif raison < <(_clia_pc_actif "$depot" "$nom" "$prefixe")
    printf '%s%s%s%s%s%s%s%s%s%s%s%s%s\n' \
      "$prefixe" "$_CLIA_SEP" "$nom" "$_CLIA_SEP" \
      "$(_clia_pc_source "$depot" "$nom")" "$_CLIA_SEP" \
      "$version" "$_CLIA_SEP" "$etat" "$_CLIA_SEP" "$actif" "$_CLIA_SEP" "$raison"
  done < <(_clia_ressources_de "$depot")
  return 0
}

# --------------------------------------------------------------------------
# Déplacer une ressource
# --------------------------------------------------------------------------
#
# « clia upgrade RESSOURCE » et « clia <ressource> upgrade » font le même
# geste, et le font par le même code : _clia_mj_ressource le fait, et
# _clia_mj_rapport_ressource le raconte. Ne diffère que la façon de nommer la
# ressource — par son nom au premier niveau, par sa commande au second.

# _clia_pc_maj <sens> <arguments…>
_clia_pc_maj() {
  local sens="$1"; shift
  local depot="${CLIA_WORK_DIR:-}" quoi='' cible='' force=0 migrer=0 arg nom ligne

  for arg in "$@"; do
    case "$arg" in
      --with-instances|--migrate) migrer=1 ;;
      --force)                    force=1 ;;
      -*) _clia_msg "option inconnue pour $sens : $arg"
          _clia_detail "les options : --with-instances (ou --migrate), --force"
          return 2 ;;
      *)  if [[ -z "$quoi" ]]; then quoi="$arg"
          elif [[ -z "$cible" ]]; then cible="$arg"
          else
            _clia_msg "$sens n'attend qu'une ressource et une version : $*"
            return 2
          fi ;;
    esac
  done

  nom=$(_clia_pc_resoudre "$depot" "$quoi") || return 1

  if [[ "$sens" == 'downgrade' && -z "$cible" ]]; then
    _clia_msg "downgrade attend la version où revenir"
    _clia_detail "celles que sa source déclare : clia update $nom"
    return 2
  fi

  ligne=$(_clia_mj_ressource "$depot" "$nom" "$sens" "$cible" "$force" "$migrer") || return 1
  _clia_mj_rapport_ressource "$ligne"
}
