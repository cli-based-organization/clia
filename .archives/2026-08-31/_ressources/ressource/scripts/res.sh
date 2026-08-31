#!/usr/bin/env bash
# Description: Les ressources du dépôt — ls, info, new, activate, version, upgrade.
# Périmètre: dépôt
# Alias: ressource resource
#
# Implémente .dev/usages/USE-003-instrumenter-les-ressources.md.
#
# La commande de la ressource « ressource » opère sur les instances de son
# type, c'est-à-dire sur les ressources elles-mêmes. Elle vit donc sous
# _ressources/ressource/scripts/, et non parmi les commandes du CLI :
# SPC-001 S7, le test étant qu'une ressource se tient seule.
#
# Deux dépôts, comme toujours. Le dépôt courant porte ses ressources dans son
# _ressources/ ; le dépôt source de clia est le remote, et ce qu'il offre et
# que le dépôt courant n'a pas est disponible, non activé.

set -euo pipefail

_CLIA_NOM='clia'
# shellcheck source=../../../_scripts/lib/commun.sh
. "$CLIA_SOURCE_DIR/_scripts/lib/commun.sh"

NAMESPACE_LOCAL=$(_clia_carte_champ "$CLIA_WORK_DIR" namespace 2>/dev/null || printf '')
NAMESPACE_SOURCE=$(_clia_carte_champ "$CLIA_SOURCE_DIR" namespace 2>/dev/null || printf '')

# --------------------------------------------------------------------------

aide() {
  cat <<'EOF'
Usage : clia res <verbe> [arguments]

Verbes :
  ls [NAMESPACE] [--remote]
        liste les ressources activées du dépôt courant : préfixe, nom,
        nombre d'instances, namespace. --remote y ajoute celles que les
        remotes offrent. NAMESPACE restreint la liste à un namespace.

  info [RESSOURCE]
        sans argument, la carte du dépôt : namespace, version, maturité,
        génération. Avec un nom, tout ce que la définition de ce type
        déclare, et le nombre de ses instances.

  new [--category CATEGORIE] PREFIXE NOM [DESCRIPTION]
        crée une ressource dans _ressources/NOM, ou _ressources/CATEGORIE/NOM.
        PREFIXE est en majuscules, NOM en minuscules sans accent.

  activate [NAMESPACE] RESSOURCE
        reprend dans le dépôt courant une ressource qu'un remote offre, avec
        tout ce qu'elle porte : sa définition, ses gabarits, ses skills et
        ses fonctionnalités.

  version [ls] RESSOURCE
        la version installée, celle qu'offre sa provenance, et l'écart entre
        les deux. Avec ls, les versions que l'historique de la provenance
        garde.

  upgrade RESSOURCE [X.Y.Z] [--migrate] [--force]
  downgrade RESSOURCE [X.Y.Z] [--migrate] [--force]
        reprend la copie à une autre version — la plus récente par défaut
        pour upgrade, la précédente pour downgrade. La copie est remplacée,
        non fusionnée : une ressource modifiée sur place est refusée, sauf
        avec --force. --migrate enchaîne la migration des instances.

  migrate RESSOURCE INSTANCE | --all [--to X.Y.Z]
        amène les instances à la version du type, en appliquant les scripts
        de _ressources/RESSOURCE/scripts/migrations/X.Y.Z.sh.

clia ressource et clia resource répondent aussi, et le nom de la ressource
peut précéder le verbe : clia res session version se lit comme
clia res version session.

Le namespace est celui du dépôt, déclaré dans .dev/clia.yaml. Une catégorie
n'en est pas un : elle range, elle ne qualifie pas la provenance.

Codes de retour :
  0  la demande est satisfaite
  1  refus : ressource inconnue, ou emplacement déjà occupé
  2  demande mal formée
EOF
}

# Une ligne par ressource : préfixe, nom, instances, namespace, état.
# Le nombre d'instances est compté dans le dépôt courant, y compris pour une
# ressource qui n'y est pas encore activée — c'est ce qui permet de voir
# qu'un dépôt porte déjà des instances d'un type qu'il n'a pas installé.
decrire() {
  local nom="$1" dir="$2" namespace="$3" etat="$4"
  local def prefixe emplacement instances
  def="$dir/schemas/$(basename "$dir").yaml"
  prefixe=$(_clia_champ_de_fichier "$def" prefixe 2>/dev/null || printf '?')
  emplacement=$(_clia_champ_de_fichier "$def" emplacement 2>/dev/null || printf '')
  instances=$(_clia_instances "$CLIA_WORK_DIR" "$emplacement")
  printf '%s\t%s\t%s\t%s\t%s\n' "$prefixe" "$nom" "$instances" "$namespace" "$etat"
}

lister() {
  local filtre='' remote=0 arg
  for arg in "$@"; do
    case "$arg" in
      --remote) remote=1 ;;
      -*) _clia_msg "option inconnue pour ls : $arg"
          _clia_detail "la seule option est --remote"
          exit 2 ;;
      *)  filtre="$arg" ;;
    esac
  done

  local lignes='' nom dir
  while IFS=$'\t' read -r nom dir; do
    [[ -n "$nom" ]] || continue
    lignes+=$(decrire "$nom" "$dir" "${NAMESPACE_LOCAL:-—}" 'activée')$'\n'
  done < <(_clia_ressources_de "$CLIA_WORK_DIR")

  # Tous les remotes, et non le seul dépôt source : une extension en est un
  # comme un autre. USE-006.
  if (( remote == 1 )); then
    local connus=$'\n' ns chemin
    while IFS=$'\t' read -r nom dir; do
      [[ -n "$nom" ]] && connus+="$nom"$'\n'
    done < <(_clia_ressources_de "$CLIA_WORK_DIR")
    while IFS=$'\t' read -r ns chemin; do
      [[ -n "$chemin" ]] || continue
      while IFS=$'\t' read -r nom dir; do
        [[ -n "$nom" ]] || continue
        [[ "$connus" == *$'\n'"$nom"$'\n'* ]] && continue
        lignes+=$(decrire "$nom" "$dir" "${ns:-—}" 'disponible')$'\n'
      done < <(_clia_ressources_de "$chemin")
    done < <(_clia_remotes)
  fi

  # Le filtre par namespace ne s'applique qu'à la colonne du même nom : une
  # catégorie ne s'y trouve pas, elle fait partie du nom de la ressource.
  if [[ -n "$filtre" ]]; then
    lignes=$(printf '%s' "$lignes" | awk -F'\t' -v n="$filtre" '$4 == n')
    lignes="${lignes:+$lignes$'\n'}"
  fi

  if [[ -z "${lignes//[$'\n']/}" ]]; then
    if [[ -n "$filtre" ]]; then
      _clia_msg "aucune ressource dans le namespace $filtre"
      _clia_detail "celui du dépôt courant est ${NAMESPACE_LOCAL:-non déclaré}"
    else
      _clia_msg "aucune ressource dans $CLIA_WORK_DIR"
      _clia_detail "celles que le dépôt source offre : clia res ls --remote"
    fi
    return 0
  fi

  # Sans filtre, le namespace est affiché ; avec, il est connu et retiré.
  {
    if [[ -n "$filtre" ]]; then
      printf 'PREFIXE\tNOM\tINSTANCES\tETAT\n'
      printf '%s' "$lignes" | awk -F'\t' 'NF{print $1"\t"$2"\t"$3"\t"$5}'
    else
      printf 'PREFIXE\tNOM\tINSTANCES\tNAMESPACE\tETAT\n'
      printf '%s' "$lignes" | awk -F'\t' 'NF{print}'
    fi
  } | column -t -s"$(printf '\t')"
}

info() {
  local nom="${1:-}"

  if [[ -z "$nom" ]]; then
    printf 'namespace       %s\n' "${NAMESPACE_LOCAL:-non déclaré dans .dev/clia.yaml}"
    printf 'version         %s\n' "$(_clia_carte_champ "$CLIA_WORK_DIR" version 2>/dev/null || printf '—')"
    printf 'maturité        %s\n' "$(_clia_carte_champ "$CLIA_WORK_DIR" maturity 2>/dev/null || printf '—')"
    printf 'génération      %s\n' "$(_clia_carte_champ "$CLIA_WORK_DIR" generation 2>/dev/null || printf '—')"
    printf 'dépôt           %s\n' "$CLIA_WORK_DIR"
    printf 'ressources      %s activée(s)\n' "$(_clia_ressources_de "$CLIA_WORK_DIR" | grep -c . || true)"
    return 0
  fi

  # Le dépôt courant d'abord, le remote ensuite : une ressource redéfinie
  # localement l'emporte sur celle que le dépôt source offre.
  local dir='' namespace="$NAMESPACE_LOCAL" etat='activée' d n
  while IFS=$'\t' read -r n d; do
    [[ "$n" == "$nom" ]] && { dir="$d"; break; }
  done < <(_clia_ressources_de "$CLIA_WORK_DIR")

  if [[ -z "$dir" ]]; then
    local ns chemin
    while IFS=$'\t' read -r ns chemin; do
      [[ -n "$chemin" ]] || continue
      while IFS=$'\t' read -r n d; do
        [[ "$n" == "$nom" ]] && { dir="$d"; namespace="$ns"; etat='disponible'; break; }
      done < <(_clia_ressources_de "$chemin")
      [[ -n "$dir" ]] && break
    done < <(_clia_remotes)
  fi

  if [[ -z "$dir" ]]; then
    _clia_msg "ressource inconnue : $nom"
    _clia_detail "celles du dépôt : clia res ls"
    _clia_detail "celles du dépôt source : clia res ls --remote"
    exit 1
  fi

  local def champ
  def="$dir/schemas/$(basename "$dir").yaml"
  printf 'nom             %s\n' "$nom"
  for champ in titre prefixe version emplacement gabarit edition cycle-de-vie; do
    printf '%-15s %s\n' "$champ" "$(_clia_champ_de_fichier "$def" "$champ" 2>/dev/null || printf '—')"
  done
  printf 'namespace       %s\n' "${namespace:-—}"
  printf 'maturité        %s\n' "$(_clia_carte_champ "$CLIA_WORK_DIR" maturity 2>/dev/null || printf '—')"
  printf 'génération      %s\n' "$(_clia_carte_champ "$CLIA_WORK_DIR" generation 2>/dev/null || printf '—')"
  printf 'état            %s\n' "$etat"
  printf 'instances       %s\n' "$(_clia_instances "$CLIA_WORK_DIR" "$(_clia_champ_de_fichier "$def" emplacement 2>/dev/null || printf '')")"
  printf 'définition      %s\n' "$def"

  # Le résumé est un bloc « > » : il tient sur les lignes indentées qui
  # suivent la clé, et se lit mieux détaché du tableau.
  local resume
  resume=$(awk '/^resume:/{d=1;next} d && /^[[:space:]]/{sub(/^[[:space:]]+/,"");print;next} d{exit}' "$def" 2>/dev/null || true)
  if [[ -n "$resume" ]]; then
    printf '\n%s\n' "$resume"
  fi
}

# Reprendre dans le dépôt courant une ressource qu'un remote offre.
#
# Tout le répertoire est copié, et non la seule définition : ce qu'une
# ressource porte lui appartient, et trier ici à sa place obligerait à
# décider, pour chaque concept, s'il voyage avec elle. Un dépôt qui n'a que
# faire d'un skill peut le retirer ; il ne peut pas deviner qu'il existait.
activer() {
  local namespace='' nom=''
  case $# in
    1) nom="$1" ;;
    2) namespace="$1"; nom="$2" ;;
    *) _clia_msg "activate attend une ressource, précédée au besoin d'un namespace"
       _clia_detail "usage : clia res activate [NAMESPACE] RESSOURCE"
       exit 2 ;;
  esac

  local dir_local="$CLIA_WORK_DIR/_ressources/$nom"
  if [[ -e "$dir_local" ]]; then
    _clia_msg "la ressource $nom est déjà dans ce dépôt"
    _clia_detail "rien n'a été modifié"
    return 0
  fi

  local remotes
  if ! remotes=$(_clia_remotes_filtres "$namespace"); then
    _clia_msg "aucun remote pour le namespace $namespace"
    _clia_detail "celui du dépôt source est ${NAMESPACE_SOURCE:-non déclaré}"
    exit 1
  fi

  local ns chemin source='' provenance=''
  while IFS=$'\t' read -r ns chemin; do
    [[ -n "$chemin" ]] || continue
    local n d
    while IFS=$'\t' read -r n d; do
      if [[ "$n" == "$nom" ]]; then source="$d"; provenance="$ns"; break; fi
    done < <(_clia_ressources_de "$chemin")
    [[ -n "$source" ]] && break
  done <<<"$remotes"

  if [[ -z "$source" ]]; then
    _clia_msg "aucun remote n'offre la ressource $nom"
    _clia_detail "ce qui est offert : clia res ls --remote"
    exit 1
  fi

  # Le préfixe doit rester distinctif dans le dépôt d'accueil, comme pour une
  # ressource créée sur place.
  local prefixe autre n d
  prefixe=$(_clia_champ_de_fichier "$source/schemas/$(basename "$source").yaml" prefixe 2>/dev/null || printf '')
  while IFS=$'\t' read -r n d; do
    [[ -n "$n" ]] || continue
    autre=$(_clia_champ_de_fichier "$d/schemas/$(basename "$d").yaml" prefixe 2>/dev/null || printf '')
    if [[ -n "$prefixe" && "$autre" == "$prefixe" ]]; then
      _clia_msg "le préfixe $prefixe est déjà celui de $n dans ce dépôt"
      _clia_detail "rien n'a été repris ; deux types au même préfixe rendent les alias ambigus"
      exit 1
    fi
  done < <(_clia_ressources_de "$CLIA_WORK_DIR")

  mkdir -p "$(dirname "$dir_local")"
  cp -r "$source" "$dir_local"

  # La copie perd la provenance : l'inventaire la garde. C'est tout ce qu'il
  # apporte que le disque ne dit pas déjà.
  _clia_enregistrer "$CLIA_WORK_DIR" ressource "$provenance" "$nom" \
    "$(_clia_champ_de_fichier "$dir_local/schemas/$(basename "$nom").yaml" version 2>/dev/null || printf '—')" \
    2>/dev/null || true

  _clia_msg "activée : _ressources/$nom"
  _clia_detail "reprise de $provenance"
  _clia_detail "préfixe $prefixe, instances dans $(_clia_champ_de_fichier "$dir_local/schemas/$(basename "$nom").yaml" emplacement 2>/dev/null || printf '?')"

  local skills features
  skills=$(_clia_concept_partout "$CLIA_WORK_DIR" skills | awk -F'\t' -v r="$nom" '$2 == r' | wc -l)
  features=$(_clia_concept_partout "$CLIA_WORK_DIR" features | awk -F'\t' -v r="$nom" '$2 == r' | wc -l)
  if (( skills > 0 || features > 0 )); then
    _clia_detail "elle apporte $skills skill(s) et $features fonctionnalité(s)"
    _clia_detail "à poser au besoin : clia skill install, clia feature install"
  fi
}

# --------------------------------------------------------------------------
# Les versions d'une ressource — USE-007
# --------------------------------------------------------------------------
#
# Une ressource installée est une copie prise chez une provenance, à une
# version. Trois choses, donc, et il faut les tenir séparées :
#
#   installée   ce que le dépôt porte, d'après l'inventaire
#   offerte     ce que la provenance offre aujourd'hui
#   disponibles ce que son historique git garde
#
# Mettre à jour, c'est reprendre la copie à une autre version. Rien n'est
# fusionné : une ressource est un ensemble de fichiers générés ou repris, non
# un fichier que deux mains éditent. Ce qui aurait été modifié sur place
# serait donc perdu — d'où la garde, et --force pour l'outrepasser.

DIR=''; INSTALLEE=''; PROVENANCE=''
OFFRE_NS=''; OFFRE_DEPOT=''; OFFRE_DIR=''; OFFERTE=''

def_de() { printf '%s/schemas/%s.yaml\n' "$1" "$(basename "$1")"; }

# Ce que le dépôt porte sous ce nom. Rend 1 si la ressource n'y est pas.
lire_installe() {
  local nom="$1" n d entree
  DIR=''; INSTALLEE=''; PROVENANCE=''
  while IFS=$'\t' read -r n d; do
    [[ "$n" == "$nom" ]] && { DIR="$d"; break; }
  done < <(_clia_ressources_de "$CLIA_WORK_DIR")
  [[ -n "$DIR" ]] || return 1

  entree=$(_clia_installe_entree "$CLIA_WORK_DIR" ressource "$nom")
  PROVENANCE=$(printf '%s' "$entree" | awk -F'\t' '{print $2}')
  INSTALLEE=$(printf '%s' "$entree" | awk -F'\t' '{print $4}')
  [[ "$PROVENANCE" == '—' ]] && PROVENANCE=''
  # L'inventaire peut être muet — c'est l'écart C5 de clia check. La
  # définition dit alors la version, et la provenance reste inconnue.
  if [[ -z "$INSTALLEE" || "$INSTALLEE" == '—' ]]; then
    INSTALLEE=$(_clia_champ_de_fichier "$(def_de "$DIR")" version 2>/dev/null || printf '')
  fi
  return 0
}

# La provenance interrogeable, s'il y en a une. Rend 1 sinon, après avoir dit
# pourquoi : une ressource née ici n'a personne à qui demander une version.
lire_offre() {
  local nom="$1" ligne=''
  OFFRE_NS=''; OFFRE_DEPOT=''; OFFRE_DIR=''; OFFERTE=''

  if [[ -n "$PROVENANCE" && -n "$NAMESPACE_LOCAL" && "$PROVENANCE" == "$NAMESPACE_LOCAL" ]]; then
    _clia_msg "la ressource $nom est née dans ce dépôt"
    _clia_detail "elle n'a pas de provenance à interroger : sa version se change"
    _clia_detail "dans $(def_de "$DIR")"
    return 1
  fi

  if [[ -n "$PROVENANCE" ]]; then
    ligne=$(_clia_offre_ressource "$nom" "$PROVENANCE") || {
      _clia_msg "la provenance de $nom n'est pas joignable : $PROVENANCE"
      _clia_detail "une extension déclarée mais non clonée en est la cause la"
      _clia_detail "plus fréquente. L'état du dépôt : clia check"
      return 1
    }
  else
    ligne=$(_clia_offre_ressource "$nom") || {
      _clia_msg "aucun remote n'offre la ressource $nom"
      _clia_detail "son inventaire est muet, et rien ne dit d'où elle vient"
      _clia_detail "ce qui est offert : clia res ls --remote"
      return 1
    }
  fi

  IFS=$'\t' read -r OFFRE_NS OFFRE_DEPOT OFFRE_DIR <<<"$ligne"
  OFFERTE=$(_clia_champ_de_fichier "$(def_de "$OFFRE_DIR")" version 2>/dev/null || printf '')
  return 0
}

# La ligne du catalogue qui porte une version, ou rien.
ligne_de_version() {
  local catalogue="$1" version="$2"
  printf '%s' "$catalogue" | awk -F'\t' -v v="$version" '$1 == v && !vu { print; vu = 1 }'
}

# Le répertoire de la ressource, tel qu'il est à une version, déposé sous
# TMP/_ressources/NOM. Le répertoire de travail se copie ; une version de
# l'historique s'extrait du commit qui la déclare.
extraire() {
  local depot="$1" nom="$2" commit="$3" tmp="$4"
  mkdir -p "$tmp/_ressources/$(dirname "$nom")"
  if [[ "$commit" == 'travail' ]]; then
    cp -r "$depot/_ressources/$nom" "$tmp/_ressources/$nom"
  else
    git -C "$depot" archive "$commit" "_ressources/$nom" 2>/dev/null | tar -x -C "$tmp"
  fi
  [[ -d "$tmp/_ressources/$nom" ]]
}

# La copie installée est-elle restée celle qui a été prise ? Écrit ce qui a
# été constaté, et rend 1 quand elle a été modifiée sur place.
copie_intacte() {
  local nom="$1" catalogue="$2" ligne commit tmp
  ligne=$(ligne_de_version "$catalogue" "$INSTALLEE")
  if [[ -z "$ligne" ]]; then
    _clia_detail "la version installée ($INSTALLEE) n'est plus au catalogue de la"
    _clia_detail "provenance : les modifications locales n'ont pas pu être vérifiées"
    return 0
  fi
  commit=$(printf '%s' "$ligne" | awk -F'\t' '{print $2}')
  tmp=$(mktemp -d)
  # shellcheck disable=SC2064
  trap "rm -rf '$tmp'" RETURN
  extraire "$OFFRE_DEPOT" "$nom" "$commit" "$tmp" || return 0
  diff -r -q "$tmp/_ressources/$nom" "$DIR" >/dev/null 2>&1
}

versions() {
  local nom='' verbe='' arg
  for arg in "$@"; do
    case "$arg" in
      ls|list) verbe='ls' ;;
      -*) _clia_msg "option inconnue pour version : $arg"; exit 2 ;;
      *)  if [[ -z "$nom" ]]; then nom="$arg"
          else _clia_msg "argument en trop : $arg"; exit 2; fi ;;
    esac
  done

  if [[ -z "$nom" ]]; then
    _clia_msg "version attend le nom d'une ressource"
    _clia_detail "usage : clia res version [ls] RESSOURCE"
    _clia_detail "celles du dépôt : clia res ls"
    exit 2
  fi

  if ! lire_installe "$nom"; then
    _clia_msg "la ressource $nom n'est pas dans ce dépôt"
    _clia_detail "pour l'y reprendre : clia res activate $nom"
    exit 1
  fi

  # L'état sans provenance reste lisible : la version installée est un fait du
  # dépôt, même quand personne ne peut dire s'il en existe une plus récente.
  # Deux causes, et elles ne se disent pas de la même façon : une ressource née
  # ici n'a personne à interroger, une provenance absente en avait un.
  local joignable=1 nee_ici=0
  [[ -n "$PROVENANCE" && -n "$NAMESPACE_LOCAL" && "$PROVENANCE" == "$NAMESPACE_LOCAL" ]] && nee_ici=1
  lire_offre "$nom" >/dev/null 2>&1 || joignable=0

  if [[ "$verbe" == 'ls' ]]; then
    if (( joignable == 0 )); then
      lire_offre "$nom" || true
      _clia_detail ''
      _clia_detail "version installée : ${INSTALLEE:-—}"
      exit 1
    fi
    local catalogue
    catalogue=$(_clia_versions_ressource "$OFFRE_DEPOT" "$nom")
    if [[ -z "$catalogue" ]]; then
      _clia_msg "la provenance $OFFRE_NS n'a aucune version de $nom dans son historique"
      _clia_detail "son dépôt n'a peut-être jamais commité cette ressource"
      exit 1
    fi
    printf 'ressource   %s\n' "$nom"
    printf 'provenance  %s\n\n' "$OFFRE_NS"
    {
      printf 'VERSION\tCOMMIT\tDATE\tETAT\n'
      local v c d etat
      while IFS=$'\t' read -r v c d; do
        [[ -n "$v" ]] || continue
        etat='—'
        [[ "$v" == "$INSTALLEE" ]] && etat='installée'
        printf '%s\t%s\t%s\t%s\n' "$v" "$c" "$d" "$etat"
      done <<<"$catalogue"
    } | column -t -s"$(printf '\t')"
    return 0
  fi

  printf 'ressource   %s\n' "$nom"
  printf 'installée   %s\n' "${INSTALLEE:-—}"
  printf 'provenance  %s\n' "${PROVENANCE:-inconnue}"
  if (( joignable == 1 )); then
    printf 'offerte     %s\n' "${OFFERTE:-—}"
    local sens
    sens=$(_clia_semver_cmp "${INSTALLEE:-0}" "${OFFERTE:-0}")
    case "$sens" in
      -1) printf 'état        en retard — clia res upgrade %s\n' "$nom" ;;
      1)  printf 'état        en avance sur sa provenance\n' ;;
      *)  printf 'état        à jour\n' ;;
    esac
  elif (( nee_ici == 1 )); then
    printf 'offerte     —\n'
    printf 'état        née dans ce dépôt — sa version se change dans sa définition\n'
  else
    printf 'offerte     —\n'
    printf 'état        provenance non joignable\n'
  fi

  local emplacement
  emplacement=$(_clia_champ_de_fichier "$(def_de "$DIR")" emplacement 2>/dev/null || printf '')
  printf 'instances   %s\n' "$(_clia_instances "$CLIA_WORK_DIR" "$emplacement")"
  local retard
  retard=$(instances_en_retard "$nom" | grep -c . || true)
  (( retard > 0 )) && printf 'à migrer    %s — clia res migrate %s --all\n' "$retard" "$nom"
  return 0
}

# Reprendre la copie à une autre version. Le sens dit lequel des deux verbes
# a été demandé : ils ne diffèrent que par le défaut et par le refus.
deplacer() {
  local sens="$1"; shift
  local nom='' demandee='' migrer=0 force=0 arg
  for arg in "$@"; do
    case "$arg" in
      --migrate) migrer=1 ;;
      --force)   force=1 ;;
      -*) _clia_msg "option inconnue pour $sens : $arg"
          _clia_detail "les options sont --migrate et --force"
          exit 2 ;;
      *)  if   [[ -z "$nom" ]];      then nom="$arg"
          elif [[ -z "$demandee" ]]; then demandee="$arg"
          else _clia_msg "argument en trop : $arg"; exit 2; fi ;;
    esac
  done

  if [[ -z "$nom" ]]; then
    _clia_msg "$sens attend le nom d'une ressource"
    _clia_detail "usage : clia res $sens RESSOURCE [X.Y.Z] [--migrate] [--force]"
    exit 2
  fi
  if [[ -n "$demandee" && ! "$demandee" =~ ^[0-9]+\.[0-9]+\.[0-9]+$ ]]; then
    _clia_msg "version invalide : $demandee"
    _clia_detail "attendu X.Y.Z, trois nombres séparés par des points"
    exit 2
  fi

  if ! lire_installe "$nom"; then
    _clia_msg "la ressource $nom n'est pas dans ce dépôt"
    _clia_detail "pour l'y reprendre : clia res activate $nom"
    exit 1
  fi
  lire_offre "$nom" || exit 1

  local catalogue
  catalogue=$(_clia_versions_ressource "$OFFRE_DEPOT" "$nom")
  if [[ -z "$catalogue" ]]; then
    _clia_msg "la provenance $OFFRE_NS n'a aucune version de $nom dans son historique"
    _clia_detail "rien n'a été modifié"
    exit 1
  fi

  # La cible : celle qui est demandée, ou le défaut du verbe. La plus récente
  # pour upgrade ; pour downgrade, la plus récente d'entre les antérieures.
  local cible="$demandee" v _c _d
  if [[ -z "$cible" ]]; then
    if [[ "$sens" == 'upgrade' ]]; then
      cible=$(printf '%s' "$catalogue" | awk -F'\t' 'NR == 1 { print $1 }')
    else
      while IFS=$'\t' read -r v _c _d; do
        [[ -n "$v" ]] || continue
        if [[ "$(_clia_semver_cmp "$v" "$INSTALLEE")" == '-1' ]]; then cible="$v"; break; fi
      done <<<"$catalogue"
      if [[ -z "$cible" ]]; then
        _clia_msg "aucune version de $nom n'est antérieure à $INSTALLEE"
        _clia_detail "les versions disponibles : clia res version ls $nom"
        exit 1
      fi
    fi
  fi

  local ligne
  ligne=$(ligne_de_version "$catalogue" "$cible")
  if [[ -z "$ligne" ]]; then
    _clia_msg "la provenance $OFFRE_NS n'offre pas la version $cible de $nom"
    _clia_detail "les versions disponibles : clia res version ls $nom"
    exit 1
  fi

  local comparaison
  comparaison=$(_clia_semver_cmp "$cible" "${INSTALLEE:-0}")
  if [[ "$comparaison" == '0' ]]; then
    _clia_msg "$nom est déjà en version $cible"
    _clia_detail "rien n'a été modifié"
    return 0
  fi
  if [[ "$sens" == 'upgrade' && "$comparaison" == '-1' ]]; then
    _clia_msg "la version $cible est antérieure à $INSTALLEE"
    _clia_detail "pour revenir en arrière : clia res downgrade $nom $cible"
    exit 1
  fi
  if [[ "$sens" == 'downgrade' && "$comparaison" == '1' ]]; then
    _clia_msg "la version $cible est postérieure à $INSTALLEE"
    _clia_detail "pour avancer : clia res upgrade $nom $cible"
    exit 1
  fi

  if (( force == 0 )) && ! copie_intacte "$nom" "$catalogue"; then
    _clia_msg "la copie installée de $nom a été modifiée dans ce dépôt"
    _clia_detail "reprendre une autre version l'écraserait : une ressource se"
    _clia_detail "reprend en entier, elle ne se fusionne pas"
    _clia_detail "rien n'a été modifié"
    _clia_detail ''
    _clia_detail "ce qui diffère : diff -r <la provenance> _ressources/$nom"
    _clia_detail "pour passer outre : clia res $sens $nom $cible --force"
    exit 1
  fi

  local commit tmp
  commit=$(printf '%s' "$ligne" | awk -F'\t' '{print $2}')
  tmp=$(mktemp -d)
  # shellcheck disable=SC2064
  trap "rm -rf '$tmp'" EXIT
  if ! extraire "$OFFRE_DEPOT" "$nom" "$commit" "$tmp"; then
    _clia_msg "la version $cible de $nom n'a pas pu être extraite de $OFFRE_NS"
    _clia_detail "commit $commit ; rien n'a été modifié"
    exit 1
  fi

  rm -rf "$DIR"
  mkdir -p "$(dirname "$DIR")"
  cp -r "$tmp/_ressources/$nom" "$DIR"

  _clia_enregistrer "$CLIA_WORK_DIR" ressource "${OFFRE_NS:-—}" "$nom" "$cible" \
    2>/dev/null || true

  _clia_msg "$nom : $INSTALLEE -> $cible"
  _clia_detail "reprise de $OFFRE_NS, commit $commit"
  _clia_detail "répertoire remplacé : _ressources/$nom"

  local skills features
  skills=$(_clia_concept_partout "$CLIA_WORK_DIR" skills | awk -F'\t' -v r="$nom" '$2 == r' | wc -l)
  features=$(_clia_concept_partout "$CLIA_WORK_DIR" features | awk -F'\t' -v r="$nom" '$2 == r' | wc -l)
  if (( skills > 0 || features > 0 )); then
    _clia_detail ''
    _clia_detail "ses $skills skill(s) et $features fonctionnalité(s) ont changé avec elle."
    _clia_detail "ce qui est posé dans le harnais ne l'a pas suivi : pour le reprendre,"
    _clia_detail "  clia skill install …   clia feature install …"
  fi

  INSTALLEE="$cible"
  if (( migrer == 1 )); then
    printf '\n' >&2
    migrer_instances "$nom" '' 1 "$cible"
  else
    local retard
    retard=$(instances_en_retard "$nom" | grep -c . || true)
    (( retard > 0 )) && {
      _clia_detail ''
      _clia_detail "$retard instance(s) portent encore une version antérieure :"
      _clia_detail "  clia res migrate $nom --all"
    }
  fi
  return 0
}

# --------------------------------------------------------------------------
# La migration des instances
# --------------------------------------------------------------------------
#
# Une instance déclare sa version dans son frontmatter — c'est un champ que
# les gabarits posent. Quand le type avance, ses instances restent à la
# version où elles ont été écrites : les migrer, c'est leur appliquer ce que
# le type dit du passage.
#
# Ce que le type dit du passage vit dans scripts/migrations/X.Y.Z.sh, sous le
# répertoire de la ressource : un script qui amène UNE instance à la version
# X.Y.Z, et qui la reçoit en premier argument. Une version sans script n'a pas
# changé le format de ses instances — le marqueur suffit alors, et clia
# l'avance seul.
#
# Sous scripts/ et non dans un répertoire à eux : SPC-001 S3 n'admet que onze
# emplacements sous une ressource, et un script de migration est un script qui
# l'instrumente. Le sous-répertoire les tient hors de scripts/*.sh, que le
# dispatcher balaie pour trouver les commandes.
#
# La migration ne redescend pas : aucun script ne dit comment défaire un
# passage, et l'inventer reviendrait à décider du format à la place de qui
# l'a écrit. Un downgrade laisse donc les instances telles quelles, et le dit.

# Les scripts de migration, du plus ancien au plus récent.
# Sortie : « version<TAB>script ».
migrations_de() {
  local dir="$1" f v
  [[ -d "$dir/scripts/migrations" ]] || return 0
  for f in "$dir"/scripts/migrations/*.sh; do
    [[ -f "$f" ]] || continue
    v=$(basename "$f" .sh)
    [[ "$v" =~ ^[0-9]+\.[0-9]+\.[0-9]+$ ]] && printf '%s\t%s\n' "$v" "$f"
  done | sort -t"$(printf '\t')" -k1,1V
  return 0
}

# Les instances dont le frontmatter porte une version antérieure à celle du
# type. Sortie : « fichier<TAB>version ».
instances_en_retard() {
  local nom="$1" emplacement cible f v
  [[ -n "$DIR" ]] || return 0
  cible=$(_clia_champ_de_fichier "$(def_de "$DIR")" version 2>/dev/null || printf '')
  [[ -n "$cible" ]] || return 0
  emplacement=$(_clia_champ_de_fichier "$(def_de "$DIR")" emplacement 2>/dev/null || printf '')
  while IFS= read -r f; do
    [[ -n "$f" ]] || continue
    v=$(_clia_frontmatter_champ "$f" version 2>/dev/null || printf '')
    [[ -n "$v" ]] || continue
    [[ "$(_clia_semver_cmp "$v" "$cible")" == '-1' ]] && printf '%s\t%s\n' "$f" "$v"
  done < <(_clia_instances_liste "$CLIA_WORK_DIR" "$emplacement")
  return 0
}

# Avance le champ version du frontmatter d'une instance, et lui seul.
marquer_version() {
  local fichier="$1" version="$2" tmp
  tmp=$(mktemp) || return 1
  awk -v v="$version" '
    NR == 1 && $0 == "---" { dedans = 1; print; next }
    dedans && $0 == "---"  { dedans = 0; print; next }
    dedans && index($0, "version:") == 1 { print "version: " v; fait = 1; next }
    { print }
  ' "$fichier" > "$tmp" || { rm -f "$tmp"; return 1; }
  mv "$tmp" "$fichier"
}

migrer_instances() {
  local nom="$1" demande="$2" toutes="${3:-0}" cible="${4:-}"

  [[ -n "$DIR" ]] || lire_installe "$nom" || {
    _clia_msg "la ressource $nom n'est pas dans ce dépôt"
    exit 1
  }
  [[ -n "$cible" ]] || cible=$(_clia_champ_de_fichier "$(def_de "$DIR")" version 2>/dev/null || printf '')
  if [[ -z "$cible" ]]; then
    _clia_msg "la définition de $nom ne déclare pas de version"
    _clia_detail "rien ne dit vers quoi migrer ses instances"
    exit 1
  fi

  local emplacement liste=''
  emplacement=$(_clia_champ_de_fichier "$(def_de "$DIR")" emplacement 2>/dev/null || printf '')

  if (( toutes == 1 )); then
    liste=$(_clia_instances_liste "$CLIA_WORK_DIR" "$emplacement")
  else
    # Une instance se désigne par son chemin, ou par le début de son nom —
    # ANL-001 plutôt que .dev/analyses/ANL-001-quelque-chose.md.
    local f base
    while IFS= read -r f; do
      [[ -n "$f" ]] || continue
      base=$(basename "$f")
      if [[ "$f" == "$demande" || "$f" == "$CLIA_WORK_DIR/$demande" \
            || "$base" == "$demande" || "$base" == "$demande"* ]]; then
        liste+="$f"$'\n'
      fi
    done < <(_clia_instances_liste "$CLIA_WORK_DIR" "$emplacement")
    if [[ -z "$liste" ]]; then
      _clia_msg "aucune instance de $nom ne répond à : $demande"
      _clia_detail "elles vivent dans ${emplacement:-un emplacement non déclaré}"
      exit 1
    fi
  fi

  if [[ -z "${liste//[$'\n']/}" ]]; then
    _clia_msg "aucune instance de $nom dans ce dépôt"
    _clia_detail "emplacement déclaré : ${emplacement:-aucun}"
    return 0
  fi

  local scripts
  scripts=$(migrations_de "$DIR")

  local f v etape script sautees=0 migrees=0 marquees=0 echouees=0
  while IFS= read -r f; do
    [[ -n "$f" ]] || continue
    v=$(_clia_frontmatter_champ "$f" version 2>/dev/null || printf '')
    if [[ -z "$v" ]]; then
      _clia_detail "sautée   : $(basename "$f") — pas de version au frontmatter"
      sautees=$((sautees + 1))
      continue
    fi
    case "$(_clia_semver_cmp "$v" "$cible")" in
      0)
        sautees=$((sautees + 1)); continue ;;
      1)
        _clia_detail "sautée   : $(basename "$f") — en $v, postérieure à $cible"
        _clia_detail "           aucun script ne redescend une instance"
        sautees=$((sautees + 1)); continue ;;
    esac

    local applique=0 rate=0
    while IFS=$'\t' read -r etape script; do
      [[ -n "$etape" ]] || continue
      [[ "$(_clia_semver_cmp "$etape" "$v")" == '1' ]] || continue
      [[ "$(_clia_semver_cmp "$etape" "$cible")" == '1' ]] && continue
      if ( cd "$CLIA_WORK_DIR" && bash "$script" "$f" >/dev/null 2>&1 ); then
        applique=$((applique + 1))
      else
        _clia_msg "le script de migration $etape a échoué sur $(basename "$f")"
        _clia_detail "script : $script"
        _clia_detail "l'instance est laissée dans l'état où il l'a mise"
        rate=1
        break
      fi
    done <<<"$scripts"

    if (( rate == 1 )); then
      echouees=$((echouees + 1))
      continue
    fi
    if marquer_version "$f" "$cible"; then
      if (( applique > 0 )); then
        _clia_detail "migrée   : $(basename "$f") — $v -> $cible, $applique script(s)"
        migrees=$((migrees + 1))
      else
        _clia_detail "marquée  : $(basename "$f") — $v -> $cible, aucun script à appliquer"
        marquees=$((marquees + 1))
      fi
    else
      _clia_msg "la version de $(basename "$f") n'a pas pu être avancée"
      echouees=$((echouees + 1))
    fi
  done <<<"$liste"

  _clia_msg "$nom en $cible : $migrees migrée(s), $marquees marquée(s), $sautees inchangée(s), $echouees échec(s)"
  (( echouees > 0 )) && exit 1
  return 0
}

migrer() {
  local nom='' demande='' toutes=0 cible='' arg attend_to=0
  for arg in "$@"; do
    if (( attend_to == 1 )); then cible="$arg"; attend_to=0; continue; fi
    case "$arg" in
      --all)  toutes=1 ;;
      --to)   attend_to=1 ;;
      --to=*) cible="${arg#--to=}" ;;
      -*) _clia_msg "option inconnue pour migrate : $arg"
          _clia_detail "les options sont --all et --to X.Y.Z"
          exit 2 ;;
      *)  if   [[ -z "$nom" ]];     then nom="$arg"
          elif [[ -z "$demande" ]]; then demande="$arg"
          else _clia_msg "argument en trop : $arg"; exit 2; fi ;;
    esac
  done

  if [[ -z "$nom" ]]; then
    _clia_msg "migrate attend le nom d'une ressource"
    _clia_detail "usage : clia res migrate RESSOURCE INSTANCE"
    _clia_detail "        clia res migrate RESSOURCE --all"
    exit 2
  fi
  if [[ -z "$demande" && $toutes -eq 0 ]]; then
    _clia_msg "migrate attend une instance, ou --all"
    _clia_detail "usage : clia res migrate $nom INSTANCE"
    _clia_detail "        clia res migrate $nom --all"
    exit 2
  fi
  if [[ -n "$cible" && ! "$cible" =~ ^[0-9]+\.[0-9]+\.[0-9]+$ ]]; then
    _clia_msg "version invalide : $cible"
    exit 2
  fi

  if ! lire_installe "$nom"; then
    _clia_msg "la ressource $nom n'est pas dans ce dépôt"
    _clia_detail "pour l'y reprendre : clia res activate $nom"
    exit 1
  fi
  migrer_instances "$nom" "$demande" "$toutes" "$cible"
}

creer() {
  local categorie='' prefixe='' nom='' description=''
  while (( $# > 0 )); do
    case "$1" in
      --category)
        shift
        [[ $# -gt 0 ]] || { _clia_msg "--category attend une catégorie"; exit 2; }
        categorie="$1" ;;
      --category=*) categorie="${1#--category=}" ;;
      -*) _clia_msg "option inconnue pour new : $1"; exit 2 ;;
      *)
        if   [[ -z "$prefixe" ]]; then prefixe="$1"
        elif [[ -z "$nom" ]];     then nom="$1"
        elif [[ -z "$description" ]]; then description="$1"
        else _clia_msg "argument en trop : $1"; exit 2
        fi ;;
    esac
    shift
  done

  if [[ -z "$prefixe" || -z "$nom" ]]; then
    _clia_msg "new attend un préfixe et un nom"
    _clia_detail "usage : clia res new [--category CATEGORIE] PREFIXE NOM [DESCRIPTION]"
    exit 2
  fi

  # Le préfixe sert d'alias aux instances : court, lisible, tapable sans
  # copier-coller. Le nom sert de chemin : minuscules, sans accent.
  if [[ ! "$prefixe" =~ ^[A-Z]{2,5}$ ]]; then
    _clia_msg "préfixe invalide : $prefixe"
    _clia_detail "deux à cinq majuscules, sans chiffre ni accent — INT, RES, SES"
    exit 2
  fi
  if [[ ! "$nom" =~ ^[a-z0-9][a-z0-9-]*$ ]]; then
    _clia_msg "nom invalide : $nom"
    _clia_detail "minuscules, chiffres et tirets, sans accent"
    exit 2
  fi
  if [[ -n "$categorie" && ! "$categorie" =~ ^[a-z0-9][a-z0-9-]*$ ]]; then
    _clia_msg "catégorie invalide : $categorie"
    _clia_detail "mêmes règles que le nom"
    exit 2
  fi

  local qualifie="${categorie:+$categorie/}$nom"
  local dir="$CLIA_WORK_DIR/_ressources/$qualifie"

  if [[ -e "$dir" ]]; then
    _clia_msg "l'emplacement est déjà occupé : _ressources/$qualifie"
    _clia_detail "rien n'a été créé"
    exit 1
  fi

  # Le préfixe doit rester distinctif : deux types qui le partagent rendent
  # les alias ambigus dans tout le dépôt.
  local n d autre
  while IFS=$'\t' read -r n d; do
    [[ -n "$n" ]] || continue
    autre=$(_clia_champ_de_fichier "$d/schemas/$(basename "$d").yaml" prefixe 2>/dev/null || printf '')
    if [[ "$autre" == "$prefixe" ]]; then
      _clia_msg "le préfixe $prefixe est déjà celui de $n"
      _clia_detail "rien n'a été créé ; deux types au même préfixe rendent les alias ambigus"
      exit 1
    fi
  done < <(_clia_ressources_de "$CLIA_WORK_DIR")

  local gabarit
  gabarit=$(_clia_gabarit_de ressource) || {
    _clia_msg "le type ressource ne déclare pas de gabarit"
    exit 1
  }
  [[ -f "$gabarit" ]] || { _clia_msg "gabarit introuvable : $gabarit"; exit 1; }

  mkdir -p "$dir/schemas"
  local def="$dir/schemas/$nom.yaml"
  local titre="${nom^}"
  # Le repli est posé à part : dans "${var:-mot}", bash interprète les
  # apostrophes du mot de repli, et une élision suffit à casser le fichier.
  local resume="$description"
  [[ -n "$resume" ]] || resume='À rédiger. Ce que ce type est, et à quoi il sert.'

  # L'entête du gabarit s'adresse à qui le copie, non à qui lira la
  # définition : il est retiré, avec les lignes de commentaire qui le
  # composent, jusqu'à la première clé.
  sed -e "s|<NOM>|$nom|g" \
      -e "s|<Titre lisible>|$titre|" \
      -e "s|<XXX>|$prefixe|g" \
      -e "s|<REPERTOIRE>|${nom}s|" \
      "$gabarit" \
    | awk 'debut { print; next } /^[^#[:space:]]/ { debut = 1; print }' > "$def"

  # Le résumé est un bloc « > » du gabarit : la description donnée remplace
  # ses deux lignes d'invite, et rien d'autre.
  if [[ -n "$description" ]]; then
    awk -v r="$resume" '
      /^resume:/ { print; print "  " r; passe = 1; next }
      passe && /^[[:space:]]/ { next }
      { passe = 0; print }
    ' "$def" > "$def.tmp" && mv "$def.tmp" "$def"
  fi

  _clia_enregistrer "$CLIA_WORK_DIR" ressource "${NAMESPACE_LOCAL:-—}" "$qualifie" \
    "$(_clia_champ_de_fichier "$def" version 2>/dev/null || printf '—')" 2>/dev/null || true

  _clia_msg "créée : _ressources/$qualifie"
  _clia_detail "définition : _ressources/$qualifie/schemas/$nom.yaml"
  _clia_detail "préfixe $prefixe, instances dans $(_clia_champ_de_fichier "$def" emplacement)"
  _clia_detail ''
  _clia_detail "à faire ensuite : renseigner emplacement, edition et cycle-de-vie,"
  _clia_detail "puis écrire le gabarit d'instance dans templates/"
}

# --------------------------------------------------------------------------

est_verbe() {
  case "$1" in
    ls|list|info|new|activate|version|upgrade|downgrade|migrate) return 0 ;;
    *) return 1 ;;
  esac
}

VERBE="${1:-}"

# USE-003 écrit « clia res VERBE RESSOURCE », USE-007 « clia res RESSOURCE
# VERBE ». Les deux disent la même demande : quand le premier mot n'est pas un
# verbe et que le second en est un, ils sont échangés. Aucune ressource ne
# porte le nom d'un verbe — clia res new le refuserait comme ambigu.
if (( $# >= 2 )) && ! est_verbe "$VERBE" && est_verbe "$2"; then
  RESSOURCE="$1"
  VERBE="$2"
  shift 2
  set -- "$RESSOURCE" "$@"
else
  shift 2>/dev/null || true
fi

case "$VERBE" in
  ls|list)           lister "$@" ;;
  info)              info "$@" ;;
  new)               creer "$@" ;;
  activate)          activer "$@" ;;
  version)           versions "$@" ;;
  upgrade)           deplacer upgrade "$@" ;;
  downgrade)         deplacer downgrade "$@" ;;
  migrate)           migrer "$@" ;;
  -h|--help|help|'') aide ;;
  *)
    _clia_msg "verbe inconnu pour res : $VERBE"
    _clia_detail "les verbes connus : ls, info, new, activate, version,"
    _clia_detail "                    upgrade, downgrade, migrate"
    exit 2 ;;
esac
