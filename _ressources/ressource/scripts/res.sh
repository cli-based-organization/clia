#!/usr/bin/env bash
# Description: Les ressources du dépôt — ls, info, new.
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
        nombre d'instances, namespace. --remote ajoute celles que le dépôt
        source offre et que le dépôt courant n'a pas encore. NAMESPACE
        restreint la liste à un namespace.

  info [RESSOURCE]
        sans argument, la carte du dépôt : namespace, version, maturité,
        génération. Avec un nom, tout ce que la définition de ce type
        déclare, et le nombre de ses instances.

  new [--category CATEGORIE] PREFIXE NOM [DESCRIPTION]
        crée une ressource dans _ressources/NOM, ou _ressources/CATEGORIE/NOM.
        PREFIXE est en majuscules, NOM en minuscules sans accent.

clia ressource et clia resource répondent aussi.

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

  if (( remote == 1 )) && [[ "$CLIA_SOURCE_DIR" != "$CLIA_WORK_DIR" ]]; then
    local connus=$'\n'
    while IFS=$'\t' read -r nom dir; do
      [[ -n "$nom" ]] && connus+="$nom"$'\n'
    done < <(_clia_ressources_de "$CLIA_WORK_DIR")
    while IFS=$'\t' read -r nom dir; do
      [[ -n "$nom" ]] || continue
      [[ "$connus" == *$'\n'"$nom"$'\n'* ]] && continue
      lignes+=$(decrire "$nom" "$dir" "${NAMESPACE_SOURCE:-—}" 'disponible')$'\n'
    done < <(_clia_ressources_de "$CLIA_SOURCE_DIR")
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
    while IFS=$'\t' read -r n d; do
      [[ "$n" == "$nom" ]] && { dir="$d"; namespace="$NAMESPACE_SOURCE"; etat='disponible'; break; }
    done < <(_clia_ressources_de "$CLIA_SOURCE_DIR")
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

  _clia_msg "créée : _ressources/$qualifie"
  _clia_detail "définition : _ressources/$qualifie/schemas/$nom.yaml"
  _clia_detail "préfixe $prefixe, instances dans $(_clia_champ_de_fichier "$def" emplacement)"
  _clia_detail ''
  _clia_detail "à faire ensuite : renseigner emplacement, edition et cycle-de-vie,"
  _clia_detail "puis écrire le gabarit d'instance dans templates/"
}

# --------------------------------------------------------------------------

VERBE="${1:-}"
shift 2>/dev/null || true

case "$VERBE" in
  ls|list)           lister "$@" ;;
  info)              info "$@" ;;
  new)               creer "$@" ;;
  -h|--help|help|'') aide ;;
  *)
    _clia_msg "verbe inconnu pour res : $VERBE"
    _clia_detail "les verbes connus : ls, info, new"
    exit 2 ;;
esac
