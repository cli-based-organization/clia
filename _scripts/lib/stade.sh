# shellcheck shell=bash
# _scripts/lib/stade.sh — les stades d'une ressource, et ses primitives.
#
# Implémente SES-001 tâche 22, et .dev/ressources/RES-001-ressource/
# primitive-2/SPC-002-stades.md, qui en tire l'ontologie.
#
# Trois stades, et l'énoncé les nomme
# -----------------------------------
#
#   primitive  ce à partir de quoi la ressource est produite — ordre 1, ce
#              que seul un humain écrit ; ordre 2, ce dont la provenance est
#              plurielle
#   générée    ce qui est construit à partir des primitives
#   livrée     ce qui est rendu public hors de la ressource
#
# Un stade n'est pas un répertoire : c'est un moment dans la production. Il
# se trouve qu'un répertoire le porte, et « clia <ressource> zone ls » dit
# lequel — SES-001 tâche 21 pour la notion de zone.
#
# Une primitive est une ressource, à un stade
# -------------------------------------------
#
# C'est la conséquence que l'énoncé tire, et elle a une portée concrète :
# une primitive porte un identifiant de la même forme qu'une instance —
# <PREFIXE>-<SEQ> — et ce préfixe est celui d'une ressource. SPC-001 est une
# spécification ; REQ-005 est un requis. Les deux vivent sous une instance
# qui n'est ni l'une ni l'autre.
#
# Ce que clia déduit, et ce qu'il lit
# -----------------------------------
#
#   identifiant  le nom du fichier              déduit
#   ordre        le répertoire qui la porte     déduit
#   structure    l'extension du fichier         déduit
#   origine      depot | externe                déclarée, depot par défaut
#   editeur      humain | agent | automatisme   déclarée ; humain à l'ordre 1
#
# Ce qui se déduit ne se déclare pas. Une déclaration qui contredirait le
# fichier serait une déclaration qui ment, et clia refuse de la poser.
#
# Où les déclarations vivent
# --------------------------
#
# Dans la primitive elle-même : le frontmatter d'un markdown, la tête d'un
# YAML. Pas de fichier voisin qui la décrirait — un inventaire parallèle peut
# mentir, le fichier non. C'est le même choix que pour l'état d'une
# fonctionnalité, qui se lit dans le harnais et nulle part ailleurs.
#
# Une primitive qui ne peut porter aucune déclaration — un CSV, une image —
# n'en porte donc aucune. clia le dit plutôt que de deviner.

# --------------------------------------------------------------------------
# Le vocabulaire
# --------------------------------------------------------------------------

_CLIA_S_ID='^[A-Z]{2,5}-[0-9]{3,}$'
_CLIA_S_FICHIER='^([A-Z]{2,5}-[0-9]{3,})(-[a-z0-9][a-z0-9-]*)?\.[A-Za-z0-9]+$'

_CLIA_S_ORIGINES='depot externe'
_CLIA_S_EDITEURS='humain agent automatisme'

# Les clés qu'une primitive déclare. Les autres propriétés se déduisent, et
# « prim set » les refuse.
_CLIA_S_DECLARABLES='origine editeur'

# _clia_s_structure <fichier> — ce que l'extension dit du fichier.
#
# Trois natures, et l'énoncé les nomme : structurée, semi-structurée, non
# structurée. L'extension est le seul indice qui ne demande pas d'ouvrir le
# fichier, et ouvrir ne dirait pas mieux : un .md bien formé et un .md vide
# sont l'un et l'autre semi-structurés.
_clia_s_structure() {
  case "${1##*.}" in
    yaml|yml|json|csv|tsv|toml|ini) printf 'structurée\n' ;;
    md|markdown|rst|adoc|org)       printf 'semi-structurée\n' ;;
    *)                              printf 'non structurée\n' ;;
  esac
}

# _clia_s_porteuse <fichier> — vrai si le fichier peut porter ses
# déclarations. Un markdown a un frontmatter, un YAML a une tête ; un CSV et
# une image n'ont nulle part où les mettre.
_clia_s_porteuse() {
  case "${1##*.}" in
    md|markdown|yaml|yml) return 0 ;;
    *)                    return 1 ;;
  esac
}

# _clia_s_id <fichier> — l'identifiant que le nom du fichier porte, ou rien.
_clia_s_id() {
  local base
  base=$(basename "$1")
  [[ "$base" =~ $_CLIA_S_FICHIER ]] || return 1
  printf '%s\n' "${BASH_REMATCH[1]}"
}

# --------------------------------------------------------------------------
# Lire une déclaration
# --------------------------------------------------------------------------

# _clia_s_declare <fichier> <clé> — la valeur déclarée, ou rien.
_clia_s_declare() {
  local f="$1" cle="$2"
  case "${f##*.}" in
    md|markdown) _clia_t_champ "$f" "$cle" 2>/dev/null || printf '' ;;
    yaml|yml)    _clia_champ_yaml "$f" "$cle" 2>/dev/null || printf '' ;;
    *)           printf '' ;;
  esac
  return 0
}

# _clia_s_origine <fichier> — declarée, ou « depot » : une primitive qui est
# dans le dépôt en vient, jusqu'à ce que quelqu'un dise le contraire.
_clia_s_origine() {
  local v
  v=$(_clia_s_declare "$1" origine)
  printf '%s\n' "${v:-depot}"
}

# _clia_s_editeur <fichier> <ordre> — qui l'écrit.
#
# À l'ordre 1, c'est un humain et ce n'est pas une question : SPC-001 §1.4
# définit la primitive de premier ordre comme ce que seul un humain écrit. À
# l'ordre 2, la provenance est plurielle, et seule une déclaration le dit.
_clia_s_editeur() {
  local f="$1" ordre="$2" v
  if [[ "$ordre" == '1' ]]; then printf 'humain\n'; return 0; fi
  v=$(_clia_s_declare "$f" editeur)
  printf '%s\n' "${v:-—}"
}

# --------------------------------------------------------------------------
# Les zones d'une instance
# --------------------------------------------------------------------------
#
# Où chaque stade vit, pour une instance donnée. Un stade est un moment dans
# la production ; le répertoire qui le porte est ce que cette lecture rend.
#
# genere/ est le seul de ces répertoires que clia écrit — par make(1), et
# jamais autrement. Les autres sont écrits par qui les écrit.

# _clia_s_zones <dépôt> <nom> <id> — « stade SEP chemin SEP état ».
_clia_s_zones() {
  local depot="$1" nom="$2" id="$3" zone livree chemin
  zone=$(_clia_zone_ressource)
  livree=$(_clia_zone_livree)

  if [[ -n "$id" ]]; then
    _clia_s_zone_ligne ressource   "$depot" "$zone/$id"
    _clia_s_zone_ligne primitive-1 "$depot" "$zone/$id/primitive-1"
    _clia_s_zone_ligne primitive-2 "$depot" "$zone/$id/primitive-2"
    _clia_s_zone_ligne générée     "$depot" "$zone/$id/genere"
    _clia_s_zone_ligne livrée      "$depot" "$zone/$id/livrables"
  else
    printf 'ressource%s—%sce dépôt n%sécrit pas cette ressource\n' \
      "$_CLIA_SEP" "$_CLIA_SEP" "'"
  fi
  chemin="$livree/$nom"
  _clia_s_zone_ligne installée "$depot" "$chemin"
  return 0
}

_clia_s_zone_ligne() {
  local stade="$1" depot="$2" chemin="$3" etat
  if [[ -d "$depot/$chemin" ]]; then etat='présente'; else etat='absente'; fi
  printf '%s%s%s%s%s\n' "$stade" "$_CLIA_SEP" "$chemin" "$_CLIA_SEP" "$etat"
}

# --------------------------------------------------------------------------
# Les primitives d'une instance
# --------------------------------------------------------------------------

# _clia_s_primitives <dépôt> <id> [ordre] — une ligne par primitive :
# « id SEP ordre SEP structure SEP origine SEP editeur SEP chemin relatif ».
#
# Les fichiers sont pris tels que le répertoire les porte, triés par nom. Un
# fichier dont le nom ne porte pas d'identifiant est rendu quand même, avec
# un identifiant vide : c'est à « prim check » de le reprocher, non à la
# lecture de le taire.
_clia_s_primitives() {
  local depot="$1" id="$2" filtre="${3:-}" zone ordre f base pid
  zone=$(_clia_zone_ressource)
  for ordre in 1 2; do
    [[ -z "$filtre" || "$filtre" == "$ordre" ]] || continue
    for f in "$depot/$zone/$id/primitive-$ordre"/*; do
      [[ -f "$f" ]] || continue
      base=$(basename "$f")
      pid=$(_clia_s_id "$f" || printf '')
      printf '%s%s%s%s%s%s%s%s%s%s%s\n' \
        "$pid" "$_CLIA_SEP" "$ordre" "$_CLIA_SEP" \
        "$(_clia_s_structure "$f")" "$_CLIA_SEP" \
        "$(_clia_s_origine "$f")" "$_CLIA_SEP" \
        "$(_clia_s_editeur "$f" "$ordre")" "$_CLIA_SEP" \
        "primitive-$ordre/$base"
    done
  done
  return 0
}

# _clia_s_trouver <dépôt> <id d'instance> <identifiant> — la ligne unique de
# la primitive désignée. Rend 1 si rien ne correspond, 3 si l'identifiant en
# désigne plusieurs — clia ne choisit pas à la place de l'appelant.
_clia_s_trouver() {
  local depot="$1" inst="$2" cible="$3" ligne pid retenue='' nb=0
  while IFS= read -r ligne; do
    [[ -n "$ligne" ]] || continue
    IFS="$_CLIA_SEP" read -r pid _ <<<"$ligne"
    [[ "$pid" == "$cible" ]] || continue
    retenue="$ligne"; nb=$((nb + 1))
  done < <(_clia_s_primitives "$depot" "$inst")

  if (( nb == 1 )); then printf '%s\n' "$retenue"; return 0; fi
  if (( nb > 1 )); then
    _clia_msg "identifiant ambigu : $cible"
    _clia_detail "plus d'une primitive le porte dans cette instance"
    _clia_detail "ce qu'elle porte : clia … prim ls"
    return 3
  fi
  return 1
}

# --------------------------------------------------------------------------
# Poser une déclaration
# --------------------------------------------------------------------------
#
# Deux formes, une par nature de porteuse.
#
# Un markdown déclare dans son frontmatter. S'il n'en a pas, clia en pose un
# et le dit : refuser aurait obligé à préparer le fichier avant de pouvoir
# rien y déclarer, pour un frontmatter que clia sait très bien écrire.
#
# Un YAML déclare en tête — après les commentaires et les scalaires de tête,
# avant le premier bloc. Une clé ajoutée en fin de fichier serait avalée par
# le dernier bloc, et ne dirait plus ce qu'elle dit.

# _clia_s_poser <fichier> <clé> <valeur> — rend 0, ou 2 si le fichier ne peut
# rien porter.
_clia_s_poser() {
  local f="$1" cle="$2" valeur="$3"
  _clia_s_porteuse "$f" || return 2
  case "${f##*.}" in
    md|markdown) _clia_s_poser_frontmatter "$f" "$cle" "$valeur" ;;
    yaml|yml)    _clia_s_poser_tete        "$f" "$cle" "$valeur" ;;
  esac
}

_clia_s_poser_frontmatter() {
  local f="$1" cle="$2" valeur="$3" lignes=() i fin=-1 pose=0
  mapfile -t lignes < "$f"

  if (( ${#lignes[@]} > 0 )) && [[ "${lignes[0]}" =~ ^---[[:space:]]*$ ]]; then
    for (( i = 1; i < ${#lignes[@]}; i++ )); do
      if [[ "${lignes[i]}" =~ ^---[[:space:]]*$ ]]; then fin=$i; break; fi
      if [[ "${lignes[i]}" =~ ^[[:space:]]*${cle}: ]]; then
        lignes[i]="$cle: $valeur"; pose=1
      fi
    done
    if (( fin < 0 )); then
      _clia_msg "le frontmatter de $(basename "$f") n'est pas refermé"
      _clia_detail "une ligne « --- » lui manque"
      return 1
    fi
    (( pose )) || lignes=("${lignes[@]:0:fin}" "$cle: $valeur" "${lignes[@]:fin}")
    printf '%s\n' "${lignes[@]}" > "$f.nouveau"
    mv -f "$f.nouveau" "$f"
    return 0
  fi

  { printf -- '---\n%s: %s\n---\n\n' "$cle" "$valeur"
    (( ${#lignes[@]} > 0 )) && printf '%s\n' "${lignes[@]}"
  } > "$f.nouveau"
  mv -f "$f.nouveau" "$f"
  _clia_msg "un frontmatter a été posé en tête de $(basename "$f")"
  _clia_detail "il ne portait aucune déclaration"
  return 0
}

_clia_s_poser_tete() {
  local f="$1" cle="$2" valeur="$3" lignes=() i tete=0 pose=0
  mapfile -t lignes < "$f"

  for (( i = 0; i < ${#lignes[@]}; i++ )); do
    if [[ "${lignes[i]}" =~ ^[[:space:]]*(#|$) ]]; then
      (( pose )) || tete=$((i + 1)); continue
    fi
    if [[ "${lignes[i]}" =~ ^${cle}: ]]; then
      lignes[i]="$cle: $valeur"; pose=1; continue
    fi
    # Un scalaire de tête : « clé: valeur » sur une seule ligne.
    if [[ "${lignes[i]}" =~ ^[A-Za-z_][A-Za-z0-9_-]*:[[:space:]]+[^[:space:]] ]]; then
      tete=$((i + 1)); continue
    fi
    break
  done

  if (( pose )); then
    printf '%s\n' "${lignes[@]}" > "$f.nouveau"
  else
    { (( tete > 0 )) && printf '%s\n' "${lignes[@]:0:tete}"
      printf '%s: %s\n' "$cle" "$valeur"
      (( tete < ${#lignes[@]} )) && printf '%s\n' "${lignes[@]:tete}"
    } > "$f.nouveau"
  fi
  mv -f "$f.nouveau" "$f"
  return 0
}

# --------------------------------------------------------------------------
# Le verbe « zone »
# --------------------------------------------------------------------------
#
# Où chaque stade de la ressource vit dans ce dépôt. Trois options le
# restreignent, et elles reprennent les noms de l'énoncé : --ressource pour
# l'instance et ses primitives, --generated pour ce qui est construit,
# --delivered pour ce qui est rendu public.

# _clia_s_zone <commande> <fichier> <arguments…>
_clia_s_zone() {
  local commande="$1" fichier="$2"; shift 2
  local depot="${CLIA_WORK_DIR:-}" nom id arg verbe='' filtre='' cible=''
  local stade chemin etat tampon=''

  if ! nom=$(_clia_r_nom_de_fichier "$fichier"); then
    _clia_msg "clia $commande n'est pas la commande d'une ressource"
    return 2
  fi

  for arg in "$@"; do
    case "$arg" in
      ls)                          verbe='ls' ;;
      --ressource)                 filtre='ressource' ;;
      --generated)                 filtre='générée' ;;
      --delivered)                 filtre='livrée' ;;
      -*) _clia_msg "option inconnue : $arg"
          _clia_detail "l'usage : clia $commande zone --help"; return 2 ;;
      *)  if [[ "$arg" =~ $_CLIA_S_ID ]]; then cible="$arg"
          else
            _clia_msg "argument inattendu : $arg"
            _clia_detail "l'usage : clia $commande zone --help"; return 2
          fi ;;
    esac
  done

  if [[ "$verbe" != 'ls' ]]; then
    _clia_msg "clia $commande zone attend « ls »"
    _clia_detail "où vit chaque stade : clia $commande zone ls"
    return 2
  fi

  id=$(_clia_instance_de "$depot" "$nom" || printf '')

  if [[ -n "$cible" ]]; then
    local ligne pid ordre rel
    if [[ -z "$id" ]]; then
      _clia_msg "ce dépôt n'écrit pas $nom : aucune primitive à situer"
      return 1
    fi
    ligne=$(_clia_s_trouver "$depot" "$id" "$cible") || {
      (( $? == 3 )) && return 1
      _clia_msg "aucune primitive ne porte $cible dans $nom"
      _clia_detail "ce que l'instance porte : clia $commande prim ls"
      return 1
    }
    IFS="$_CLIA_SEP" read -r pid ordre _ _ _ rel <<<"$ligne"
    { printf 'STADE%sZONE%sETAT\n' "$_CLIA_SEP" "$_CLIA_SEP"
      printf 'primitive-%s%s%s/%s/%s%s présente\n' \
        "$ordre" "$_CLIA_SEP" "$(_clia_zone_ressource)" "$id" "$rel" "$_CLIA_SEP"
    } | column -t -s "$_CLIA_SEP"
    return 0
  fi

  while IFS="$_CLIA_SEP" read -r stade chemin etat; do
    [[ -n "$stade" ]] || continue
    case "$filtre" in
      '') ;;
      ressource) [[ "$stade" == ressource || "$stade" == primitive-* ]] || continue ;;
      *)         [[ "$stade" == "$filtre" ]] || continue ;;
    esac
    tampon+=$(printf '%s%s%s%s%s' "$stade" "$_CLIA_SEP" "$chemin" "$_CLIA_SEP" "$etat")$'\n'
  done < <(_clia_s_zones "$depot" "$nom" "$id")

  if [[ -z "$tampon" ]]; then
    _clia_msg "aucun stade ne répond à ce filtre"
    return 1
  fi

  { printf 'STADE%sZONE%sETAT\n' "$_CLIA_SEP" "$_CLIA_SEP"
    printf '%s' "$tampon"
  } | column -t -s "$_CLIA_SEP"
  return 0
}

# --------------------------------------------------------------------------
# Le verbe « prim »
# --------------------------------------------------------------------------

_CLIA_S_BLOQUANTS=0
_CLIA_S_SIGNALEMENTS=0

_clia_s_verdict() {
  local id="$1" nature="$2" texte="$3" marque
  case "$nature" in
    ok)          marque='ok' ;;
    bloquant)    marque='!!'; _CLIA_S_BLOQUANTS=$((_CLIA_S_BLOQUANTS + 1)) ;;
    signalement) marque='--'; _CLIA_S_SIGNALEMENTS=$((_CLIA_S_SIGNALEMENTS + 1)) ;;
  esac
  printf '%-3s %-2s  %s\n' "$id" "$marque" "$texte"
}

# _clia_s_prim <commande> <fichier> <arguments…>
_clia_s_prim() {
  local commande="$1" fichier="$2"; shift 2
  local depot="${CLIA_WORK_DIR:-}" nom id

  if ! nom=$(_clia_r_nom_de_fichier "$fichier"); then
    _clia_msg "clia $commande n'est pas la commande d'une ressource"
    return 2
  fi

  id=$(_clia_instance_de "$depot" "$nom" || printf '')
  if [[ -z "$id" ]]; then
    _clia_msg "ce dépôt n'écrit pas $nom : il n'en porte aucune primitive"
    _clia_detail "une primitive vit sous une instance, non sous une copie installée"
    _clia_detail "ce que le dépôt écrit : clia res ls"
    return 1
  fi

  case "${1:-}" in
    ls)    shift; _clia_s_prim_ls    "$commande" "$depot" "$id" "$@" ;;
    check) shift; _clia_s_prim_check "$commande" "$depot" "$id" "$@" ;;
    '')
      _clia_msg "clia $commande prim attend un verbe ou un identifiant"
      _clia_detail "ce que l'instance porte : clia $commande prim ls"
      return 2 ;;
    *)
      if [[ "$1" =~ $_CLIA_S_ID ]]; then
        _clia_s_prim_une "$commande" "$depot" "$id" "$@"
      else
        _clia_msg "verbe inconnu : $1"
        _clia_detail "l'usage : clia $commande prim --help"
        return 2
      fi ;;
  esac
}

# prim ls [-1|-2]
_clia_s_prim_ls() {
  local commande="$1" depot="$2" id="$3"; shift 3
  local arg filtre='' pid ordre structure origine editeur rel tampon=''

  for arg in "$@"; do
    case "$arg" in
      -1) filtre='1' ;;
      -2) filtre='2' ;;
      *)  _clia_msg "argument inattendu : $arg"
          _clia_detail "l'usage : clia $commande prim --help"; return 2 ;;
    esac
  done

  while IFS="$_CLIA_SEP" read -r pid ordre structure origine editeur rel; do
    [[ -n "$rel" ]] || continue
    tampon+=$(printf '%s%s%s%s%s%s%s%s%s%s%s' \
      "${pid:-—}" "$_CLIA_SEP" "$ordre" "$_CLIA_SEP" "$structure" "$_CLIA_SEP" \
      "$origine" "$_CLIA_SEP" "$editeur" "$_CLIA_SEP" "$rel")$'\n'
  done < <(_clia_s_primitives "$depot" "$id" "$filtre")

  if [[ -z "$tampon" ]]; then
    if [[ -n "$filtre" ]]; then
      _clia_msg "aucune primitive d'ordre $filtre sous $id"
    else
      _clia_msg "aucune primitive sous $id"
    fi
    _clia_detail "elles se rangent sous $(_clia_zone_ressource)/$id/primitive-1 et primitive-2"
    return 0
  fi

  { printf 'IDENTIFIANT%sORDRE%sSTRUCTURE%sORIGINE%sEDITEUR%sFICHIER\n' \
      "$_CLIA_SEP" "$_CLIA_SEP" "$_CLIA_SEP" "$_CLIA_SEP" "$_CLIA_SEP"
    printf '%s' "$tampon"
  } | column -t -s "$_CLIA_SEP"
  return 0
}

# prim <ID> ls | prim <ID> set KEY VALUE
_clia_s_prim_une() {
  local commande="$1" depot="$2" id="$3" cible="$4"; shift 4
  local ligne pid ordre structure origine editeur rel chemin

  ligne=$(_clia_s_trouver "$depot" "$id" "$cible") || {
    (( $? == 3 )) && return 1
    _clia_msg "aucune primitive ne porte $cible sous $id"
    _clia_detail "ce que l'instance porte : clia $commande prim ls"
    return 1
  }
  IFS="$_CLIA_SEP" read -r pid ordre structure origine editeur rel <<<"$ligne"
  chemin="$depot/$(_clia_zone_ressource)/$id/$rel"

  case "${1:-ls}" in
    ls)
      (( $# <= 1 )) || { _clia_msg "ls ne prend pas d'argument : ${*:2}"; return 2; }
      printf 'identifiant  %s\n' "$pid"
      printf 'fichier      %s\n' "$rel"
      printf 'ordre        %s  (déduit du répertoire)\n' "$ordre"
      printf 'structure    %s  (déduite de l%sextension)\n' "$structure" "'"
      if [[ "$ordre" == '1' ]]; then
        printf 'editeur      %s  (un humain, par définition de l%sordre 1)\n' "$editeur" "'"
      elif [[ -n "$(_clia_s_declare "$chemin" editeur)" ]]; then
        printf 'editeur      %s  (déclarée)\n' "$editeur"
      else
        printf 'editeur      %s  (non déclarée)\n' "$editeur"
      fi
      if [[ -n "$(_clia_s_declare "$chemin" origine)" ]]; then
        printf 'origine      %s  (déclarée)\n' "$origine"
      else
        printf 'origine      %s  (par défaut)\n' "$origine"
      fi
      return 0 ;;
    set)
      shift
      _clia_s_prim_set "$commande" "$chemin" "$pid" "$ordre" "$@" ;;
    *)
      _clia_msg "verbe inconnu : $1"
      _clia_detail "l'usage : clia $commande prim --help"
      return 2 ;;
  esac
}

_clia_s_prim_set() {
  local commande="$1" chemin="$2" pid="$3" ordre="$4" cle="${5:-}" valeur="${6:-}"

  if [[ -z "$cle" || -z "$valeur" ]] || (( $# > 6 )); then
    _clia_msg "set attend une clé et une valeur"
    _clia_detail "l'usage : clia $commande prim $pid set KEY VALUE"
    return 2
  fi

  if [[ " $_CLIA_S_DECLARABLES " != *" $cle "* ]]; then
    _clia_msg "$cle ne se déclare pas"
    _clia_detail "déclarables : $_CLIA_S_DECLARABLES"
    _clia_detail "l'identifiant, l'ordre et la structure se déduisent du fichier"
    return 2
  fi

  case "$cle" in
    origine)
      [[ " $_CLIA_S_ORIGINES " == *" $valeur "* ]] || {
        _clia_msg "origine inconnue : $valeur"
        _clia_detail "valeurs admises : $_CLIA_S_ORIGINES"; return 2; } ;;
    editeur)
      [[ " $_CLIA_S_EDITEURS " == *" $valeur "* ]] || {
        _clia_msg "editeur inconnu : $valeur"
        _clia_detail "valeurs admises : $_CLIA_S_EDITEURS"; return 2; }
      if [[ "$ordre" == '1' && "$valeur" != 'humain' ]]; then
        _clia_msg "une primitive de premier ordre est écrite par un humain"
        _clia_detail "SPC-001 §1.4 : ni un agent, ni un automatisme, ni une source externe"
        _clia_detail "si elle ne l'est pas, elle est d'ordre 2 — déplacez-la"
        return 1
      fi ;;
  esac

  # Le statut est recueilli plutôt que lu après coup : sous « set -e », une
  # commande qui rend 2 sans être dans une condition arrête le shell, et le
  # refus ne serait jamais dit.
  local pose=0
  _clia_s_poser "$chemin" "$cle" "$valeur" || pose=$?
  case "$pose" in
    0) ;;
    2) _clia_msg "$(basename "$chemin") ne peut porter aucune déclaration"
       _clia_detail "un markdown la porte dans son frontmatter, un YAML en tête"
       _clia_detail "les autres formes n'ont nulle part où la mettre"
       return 1 ;;
    *) return 1 ;;
  esac

  _clia_msg "$pid : $cle = $valeur"
  _clia_detail "posée dans ${chemin##*/}"
  _clia_detail "rien n'est commité"
  return 0
}

# prim check [ID]
_clia_s_prim_check() {
  local commande="$1" depot="$2" id="$3" cible="${4:-}"
  local ligne pid ordre structure origine editeur rel chemin
  local mal='' doubles='' muettes='' inconnues='' sans='' usurpees=''
  local vus='' n=0

  if [[ -n "$cible" ]] && ! [[ "$cible" =~ $_CLIA_S_ID ]]; then
    _clia_msg "identifiant mal formé : $cible"
    _clia_detail "la forme attendue : PREFIXE-SEQ, comme SPC-001"
    return 2
  fi
  (( $# <= 4 )) || { _clia_msg "check ne prend qu'un identifiant : ${*:5}"; return 2; }

  _CLIA_S_BLOQUANTS=0
  _CLIA_S_SIGNALEMENTS=0

  while IFS="$_CLIA_SEP" read -r pid ordre structure origine editeur rel; do
    [[ -n "$rel" ]] || continue
    [[ -z "$cible" || "$pid" == "$cible" ]] || continue
    n=$((n + 1))
    chemin="$depot/$(_clia_zone_ressource)/$id/$rel"

    if [[ -z "$pid" ]]; then
      mal="${mal:+$mal }${rel##*/}"
    elif [[ " $vus " == *" $pid "* ]]; then
      doubles="${doubles:+$doubles }$pid"
    else
      vus="$vus $pid"
    fi

    _clia_s_porteuse "$chemin" || muettes="${muettes:+$muettes }${pid:-${rel##*/}}"

    if [[ " $_CLIA_S_ORIGINES " != *" $origine "* ]]; then
      inconnues="${inconnues:+$inconnues }$pid:origine=$origine"
    fi
    # Une propriété déduite peut aussi être écrite dans le fichier —
    # « ordre: 2 » dans un frontmatter. Tant qu'elle dit la même chose que le
    # répertoire, elle ne gêne personne ; si elle le contredit, elle ment, et
    # c'est la déclaration qui a tort : le fichier est là où il est.
    local dit_ordre
    dit_ordre=$(_clia_s_declare "$chemin" ordre)
    if [[ -n "$dit_ordre" && "$dit_ordre" != "$ordre" ]]; then
      inconnues="${inconnues:+$inconnues }$pid:ordre=$dit_ordre"
    fi
    if [[ "$ordre" == '2' ]]; then
      if [[ "$editeur" == '—' ]]; then
        sans="${sans:+$sans }$pid"
      elif [[ " $_CLIA_S_EDITEURS " != *" $editeur "* ]]; then
        inconnues="${inconnues:+$inconnues }$pid:editeur=$editeur"
      fi
    else
      local dit
      dit=$(_clia_s_declare "$chemin" editeur)
      [[ -z "$dit" || "$dit" == 'humain' ]] || \
        usurpees="${usurpees:+$usurpees }$pid"
    fi
  done < <(_clia_s_primitives "$depot" "$id")

  if (( n == 0 )); then
    if [[ -n "$cible" ]]; then
      _clia_msg "aucune primitive ne porte $cible sous $id"
      _clia_detail "ce que l'instance porte : clia $commande prim ls"
      return 1
    fi
    _clia_msg "$id ne porte aucune primitive"
    _clia_detail "un livrable dont aucune entrée n'est là n'est pas reproductible"
    return 1
  fi

  printf 'instance   %s\n' "$id"
  printf 'primitives %s\n\n' "$n"

  if [[ -n "$mal" ]]; then
    _clia_s_verdict P1 bloquant "nom(s) sans identifiant : $mal"
  else
    _clia_s_verdict P1 ok "chaque nom porte son identifiant"
  fi

  if [[ -n "$doubles" ]]; then
    _clia_s_verdict P2 bloquant "identifiant(s) portés plus d'une fois : $doubles"
  else
    _clia_s_verdict P2 ok "les identifiants ne se répètent pas"
  fi

  if [[ -n "$muettes" ]]; then
    _clia_s_verdict P3 signalement "sans place pour une déclaration : $muettes"
  else
    _clia_s_verdict P3 ok "chaque primitive peut porter ses déclarations"
  fi

  if [[ -n "$inconnues" ]]; then
    _clia_s_verdict P4 bloquant "valeur(s) non reconnue(s) ou contredisant le fichier : $inconnues"
  else
    _clia_s_verdict P4 ok "les valeurs déclarées sont reconnues, et ne contredisent rien"
  fi

  if [[ -n "$usurpees" ]]; then
    _clia_s_verdict P5 bloquant "ordre 1 déclarant un autre éditeur qu'humain : $usurpees"
  elif [[ -n "$sans" ]]; then
    _clia_s_verdict P5 signalement "ordre 2 sans éditeur déclaré : $sans"
  else
    _clia_s_verdict P5 ok "chaque primitive dit qui l'écrit"
  fi

  printf '\n'
  if (( _CLIA_S_BLOQUANTS > 0 )); then
    _clia_msg "$id : $_CLIA_S_BLOQUANTS écart(s) bloquant(s)"
    _clia_detail "ce que chaque primitive déclare : clia $commande prim ls"
    return 1
  fi
  if (( _CLIA_S_SIGNALEMENTS > 0 )); then
    _clia_msg "$id : conforme, avec $_CLIA_S_SIGNALEMENTS signalement(s)"
  else
    _clia_msg "$id : conforme"
  fi
  _clia_detail "pour déclarer : clia $commande prim <ID> set KEY VALUE"
  return 0
}
