# shellcheck shell=bash
# _scripts/lib/commun.sh — ce que le point d'entrée et les commandes partagent.
#
# Ce fichier ne fait aucune action : il déclare des emplacements et des
# fonctions de lecture. Le sourcer ne modifie ni le shell, ni le disque.
#
# Tout ce qui est déclaré ici porte le préfixe _clia_, pour qu'un shell
# interactif qui l'aurait sourcé puisse tout retirer d'un coup. Un shell ne
# doit rien garder de clia qu'il n'ait demandé.
#
# Il est volontairement court. La génération précédente y avait accumulé 756
# lignes ; ce qui suit est ce dont la première commande a besoin, et rien de
# plus. Il grandira quand une commande le demandera, pas avant.

# --------------------------------------------------------------------------
# Sortie
# --------------------------------------------------------------------------
#
# Tout passe par l'erreur standard, sauf ce qu'un programme viendrait lire.
# Un message dit ce qui s'est produit, puis ce que le lecteur peut faire
# ensuite : un constat sans suite oblige à deviner.

_clia_msg()    { printf '%s: %s\n' "${_CLIA_NOM:-clia}" "$*" >&2; }
_clia_detail() { printf '%*s  %s\n' "${#_CLIA_NOM}" '' "$*" >&2; }

# --------------------------------------------------------------------------
# Le dépôt
# --------------------------------------------------------------------------

# Racine du dépôt git contenant un répertoire. Échoue s'il n'y en a pas.
_clia_depot_git() {
  git -C "${1:-$PWD}" rev-parse --show-toplevel 2>/dev/null
}

# --------------------------------------------------------------------------
# La carte du dépôt
# --------------------------------------------------------------------------
#
# La carte est le fichier qui déclare ce que le dépôt est. SES-001 tâche 1 en
# nomme trois emplacements possibles sans trancher entre eux : les trois sont
# donc cherchés, dans l'ordre ci-dessous, et le premier trouvé l'emporte.
#
# Cet ordre est une convention de lecture, pas une décision. Fixer
# l'emplacement de la carte appartient à l'humain ; tant qu'il ne l'a pas
# fait, chercher aux trois endroits vaut mieux que d'en supposer un.
#
# Les chemins sont relatifs à la racine du dépôt, parce que c'est sous cette
# forme que git les lit dans un commit passé — voir _clia_version_au_commit.

_CLIA_CARTE_EMPLACEMENTS=('clia.yaml' '.clia.yaml' '.dev/clia.yaml')

# Le chemin, relatif à la racine, de la carte du dépôt de travail. Rien si
# aucun des trois emplacements n'est occupé.
_clia_carte_relative() {
  local depot="$1" emplacement
  for emplacement in "${_CLIA_CARTE_EMPLACEMENTS[@]}"; do
    if [[ -f "$depot/$emplacement" ]]; then
      printf '%s\n' "$emplacement"
      return 0
    fi
  done
  return 1
}

# Le chemin absolu de la carte, ou rien.
_clia_carte() {
  local depot="$1" relative
  relative=$(_clia_carte_relative "$depot") || return 1
  printf '%s/%s\n' "$depot" "$relative"
}

# --------------------------------------------------------------------------
# Lecture d'un champ de la carte
# --------------------------------------------------------------------------
#
# La carte est du YAML, et clia le lit sans dépendre d'un analyseur YAML : la
# portabilité vaut ici plus que la généralité, et les champs lus sont des
# scalaires de premier niveau.
#
# Le motif exige la colonne zéro. C'est ce qui distingue le champ « version »
# du dépôt des champs « version » imbriqués sous « use: », qui sont indentés
# et désignent la version d'une ressource, non celle du dépôt.

# _clia_champ_yaml <fichier> <champ> — la valeur, ou rien.
_clia_champ_yaml() {
  local fichier="$1" champ="$2" ligne
  [[ -f "$fichier" ]] || return 1
  ligne=$(grep -m1 -E "^${champ}:[[:space:]]" "$fichier" 2>/dev/null) || return 1
  printf '%s\n' "$(_clia_valeur_yaml "${ligne#*:}")"
}

# La valeur d'un champ, débarrassée de ses espaces, de ses guillemets et d'un
# commentaire de fin de ligne.
_clia_valeur_yaml() {
  local brut="$1"
  brut="${brut%%#*}"
  brut="$(printf '%s' "$brut" | sed -E 's/^[[:space:]]+//; s/[[:space:]]+$//')"
  brut="${brut%\"}"; brut="${brut#\"}"
  brut="${brut%\'}"; brut="${brut#\'}"
  printf '%s\n' "$brut"
}

# --------------------------------------------------------------------------
# Les déclarations que porte un fichier de commande
# --------------------------------------------------------------------------
#
# Une commande se décrit elle-même, en tête de son propre fichier. Le point
# d'entrée lit ces lignes sans exécuter le fichier, ce qui lui permet de
# composer l'aide de tout le CLI sans lancer une seule commande.
#
#   # Description: ce que la commande fait, en une ligne
#   # Périmètre:   dépôt | aucun
#   # Signature:   <une forme d'invocation valide>      (répétable)
#   # Option:      <chemin> <option telle qu'elle s'écrit> (répétable)
#
# Signature et Option sont ce dont l'aide brève est faite. Les déclarer ici
# plutôt que dans un texte d'aide écrit à la main évite qu'ils divergent : il
# n'y a qu'une source, et c'est celle que le point d'entrée lit.
#
# Une option porte le chemin auquel elle s'applique, parce qu'une option d'une
# commande n'est pas valide pour ses sous-commandes : « version --true » ne
# doit pas paraître dans l'aide de « version release ». Le chemin est ce qui
# précède le premier mot commençant par un tiret.

# _clia_declarations <fichier> <clé> — les valeurs, une par ligne.
_clia_declarations() {
  grep -E "^#[[:space:]]*$2:" "$1" 2>/dev/null \
    | sed -E "s/^#[[:space:]]*$2:[[:space:]]*//" || true
}

_clia_signatures_de() { _clia_declarations "$1" 'Signature'; }
_clia_options_de()    { _clia_declarations "$1" 'Option'; }

# --------------------------------------------------------------------------
# L'aide brève
# --------------------------------------------------------------------------
#
# SES-001 tâche 3 : « la version de base ne doit pas contenir d'information
# textuelle. Seulement une liste des commandes, la ou les signatures valides
# pour chaque commande ou sous-commande et les options disponibles. »
#
# Ce que cela impose, et qui est vérifié par le banc : toute ligne de l'aide
# brève est soit un titre de bloc, soit une entrée indentée de deux espaces.
# Aucune phrase. Ce qui explique appartient au manuel, que --man rend.

# Celles que le point d'entrée traite lui-même. --version n'est reconnue qu'en
# première position — « clia version --version » n'a pas de sens — alors que
# l'aide et le manuel répondent à toute profondeur.
_CLIA_OPTIONS_GLOBALES=('-h, --help' '--man' '-v, --version')
_CLIA_OPTIONS_UNIVERSELLES=('-h, --help' '--man')

# _clia_lignes_options <chemin> — lit des déclarations d'option sur l'entrée
# standard et rend celles dont le chemin est exactement celui demandé.
_clia_lignes_options() {
  local demande="$1" ligne chemin option
  while IFS= read -r ligne; do
    [[ -n "$ligne" ]] || continue
    chemin=''
    option="$ligne"
    while [[ "$option" == [!-]* && "$option" == *' '* ]]; do
      chemin="${chemin:+$chemin }${option%% *}"
      option="${option#* }"
    done
    [[ "$chemin" == "$demande" ]] && printf '%s\n' "$option"
  done
  return 0
}

# _clia_lignes_usage <préfixe> — lit des signatures sur l'entrée standard et
# rend celles qui commencent par le préfixe, préfixées du nom de l'outil.
# Un préfixe vide les rend toutes.
_clia_lignes_usage() {
  local prefixe="$1" ligne
  while IFS= read -r ligne; do
    [[ -n "$ligne" ]] || continue
    if [[ -z "$prefixe" || "$ligne" == "$prefixe" || "$ligne" == "$prefixe "* ]]; then
      printf '  %s %s\n' "${_CLIA_NOM:-clia}" "$ligne"
    fi
  done
}

# _clia_bloc <titre> <entrée…> — un bloc de l'aide brève, ou rien s'il est
# vide. Un bloc vide vaut mieux tu qu'affiché : il ferait chercher.
_clia_bloc() {
  local titre="$1"; shift
  (( $# )) || return 0
  printf '\n%s :\n' "$titre"
  printf '  %s\n' "$@"
}

# --------------------------------------------------------------------------
# Le manuel
# --------------------------------------------------------------------------
#
# Le format est celui des pages de manuel unix, tel que man(1) le rend sur
# cette machine : titres de section en capitales en colonne zéro, corps
# indenté de sept caractères, description d'une option indentée de sept de
# plus, lignes d'en-tête et de pied sur la largeur de la page.
#
# Les noms de section sont ceux des pages francophones — NOM, SYNOPSIS,
# DESCRIPTION, OPTIONS, CODE DE RETOUR, ENVIRONNEMENT, FICHIERS, EXEMPLES,
# VOIR AUSSI — parce que c'est ce que man rend ici et que tout le reste de ce
# dépôt est en français.
#
# La date est une constante et non la date du jour : une sortie qui change
# d'une exécution à l'autre ne serait pas vérifiable.

_CLIA_MAN_LARGEUR=80
_CLIA_MAN_DATE='31 août 2026'

# _clia_man_ligne <gauche> <centre> <droite> — une ligne d'en-tête ou de pied.
_clia_man_ligne() {
  local g="$1" c="$2" d="$3" reste avant apres
  reste=$(( _CLIA_MAN_LARGEUR - ${#g} - ${#d} ))
  avant=$(( (reste - ${#c}) / 2 ))
  apres=$(( reste - ${#c} - avant ))
  (( avant < 1 )) && avant=1
  (( apres < 1 )) && apres=1
  printf '%s%*s%s%*s%s\n' "$g" "$avant" '' "$c" "$apres" '' "$d"
}

# Indente le corps lu sur l'entrée standard. Une ligne entièrement en
# capitales est un titre de section et reste en colonne zéro ; tout le reste
# est décalé de sept, ce qui porte à quatorze une ligne déjà indentée de sept
# dans la source — l'indentation d'une description d'option.
#
# Le motif est nommé plutôt qu'écrit dans la condition : il contient une
# espace et un tiret, et une classe de caractères écrite à même un test
# conditionnel y serait découpée en deux mots.
_CLIA_MAN_TITRE='^[A-Z][A-Z -]*$'

_clia_man_corps() {
  local ligne
  while IFS= read -r ligne; do
    if [[ -z "$ligne" ]]; then
      printf '\n'
    elif [[ "$ligne" =~ $_CLIA_MAN_TITRE ]]; then
      printf '%s\n' "$ligne"
    else
      printf '       %s\n' "$ligne"
    fi
  done
}

# _clia_man <nom> <section> <titre-centre> — la page complète, corps lu sur
# l'entrée standard.
_clia_man() {
  local nom="$1" section="$2" centre="$3" etiquette
  etiquette="$(printf '%s' "$nom" | tr '[:lower:]-' '[:upper:]-')($section)"
  _clia_man_ligne "$etiquette" "$centre" "$etiquette"
  printf '\n'
  _clia_man_corps
  printf '\n'
  _clia_man_ligne 'clia' "$_CLIA_MAN_DATE" "$etiquette"
}

# --------------------------------------------------------------------------
# Les harnais que clia offre
# --------------------------------------------------------------------------
#
# Le harnais IA est une ressource comme une autre : ses primitives sont les
# fichiers qu'un dépôt instrumenté reçoit. La liste n'est donc écrite nulle
# part — elle est ce que le répertoire contient, et ajouter un harnais se
# fait en y déposant un fichier.
#
# C'est la règle qui vaut déjà pour les commandes : le noyau trouve, il
# n'énumère pas.

_CLIA_HARNAIS_PRIMITIVES='_ressources/harness-ia/primitives'

# « nom<TAB>chemin de la primitive », triés par nom.
_clia_harnais_offerts() {
  local f
  for f in "${CLIA_SOURCE_DIR:-}/$_CLIA_HARNAIS_PRIMITIVES"/*; do
    [[ -f "$f" ]] && printf '%s\t%s\n' "$(basename "$f")" "$f"
  done | sort
  return 0
}

# --------------------------------------------------------------------------
# Lecture d'une liste de mappings
# --------------------------------------------------------------------------
#
# La carte porte des listes dont chaque entrée est un mapping :
#
#   sources:
#     - provider: session.clia.noumanity.com
#       type: local
#       uri: ../clia-session
#
# Le même esprit que _clia_champ_yaml : la forme exacte que ce dépôt écrit et
# relit, non le YAML entier. Une entrée commence au tiret, et se poursuit tant
# que les lignes sont indentées ; une ligne en colonne zéro referme le bloc.
#
# Les champs demandés sont rendus dans l'ordre demandé, séparés par des
# tabulations. Un champ absent rend une valeur vide plutôt que de décaler les
# colonnes : l'appelant lit toujours le même nombre de champs.

# _clia_bloc_yaml <fichier> <bloc> <champ…> — une ligne par entrée.
_clia_bloc_yaml() {
  local fichier="$1" bloc="$2"; shift 2
  [[ -f "$fichier" ]] || return 0
  awk -v bloc="$bloc" -v demandes="$*" '
    function valeur(l,   s) {
      s = l
      sub(/^[^:]*:[[:space:]]*/, "", s)
      sub(/[[:space:]]*#.*$/, "", s)
      sub(/[[:space:]]+$/, "", s)
      if (substr(s, 1, 1) == "\"" && substr(s, length(s), 1) == "\"")
        s = substr(s, 2, length(s) - 2)
      if (substr(s, 1, 1) == "'"'"'" && substr(s, length(s), 1) == "'"'"'")
        s = substr(s, 2, length(s) - 2)
      return s
    }
    function cle(l,   s) {
      s = l
      sub(/^[[:space:]]*-?[[:space:]]*/, "", s)
      sub(/:.*$/, "", s)
      return s
    }
    function vider(   i, ligne) {
      if (!ouvert) return
      ligne = ""
      for (i = 1; i <= nb; i++)
        ligne = ligne (i > 1 ? "\t" : "") (champ[demande[i]] "")
      print ligne
      delete champ
      ouvert = 0
    }
    BEGIN { nb = split(demandes, demande, " ") }
    /^[[:space:]]*#/  { next }
    /^[[:space:]]*$/  { next }
    /^[^[:space:]]/   { vider(); dans = ($0 ~ "^" bloc ":[[:space:]]*$"); next }
    !dans             { next }
    /^[[:space:]]*-[[:space:]]/ { vider(); ouvert = 1; champ[cle($0)] = valeur($0); next }
    ouvert && /^[[:space:]]+[A-Za-z]/ { champ[cle($0)] = valeur($0); next }
    END { vider() }
  ' "$fichier"
}

# --------------------------------------------------------------------------
# Le rendu d'un gabarit
# --------------------------------------------------------------------------
#
# Une seule forme : {{nom}}, remplacé par la valeur du champ. Pas de section,
# pas de boucle — un gabarit qui saurait tester porterait la logique du
# système ailleurs que dans le code. La ressource harness-ia, elle, en a
# besoin ; elle porte sa propre langue, plus riche, dans son script.
#
# Un trou que la table ne connaît pas fait échouer le rendu : un fichier
# livré avec « {{…}} » dedans serait un fichier faux, et rien n'y
# distinguerait le trou oublié du texte voulu.

# _clia_rendre <gabarit> <valeurs> — le gabarit sur la sortie standard.
# <valeurs> est un fichier de lignes « nom<TAB>valeur ».
_clia_rendre() {
  local gabarit="$1" valeurs="$2" texte nom val reste
  [[ -f "$gabarit" ]] || { _clia_msg "gabarit introuvable : $gabarit"; return 1; }
  texte=$(cat "$gabarit")
  while IFS=$'\t' read -r nom val; do
    [[ -n "$nom" ]] || continue
    texte="${texte//\{\{$nom\}\}/$val}"
  done < "$valeurs"
  if [[ "$texte" == *'{{'* ]]; then
    reste="${texte#*\{\{}"
    _clia_msg "le gabarit ${gabarit##*/} porte un champ inconnu : {{${reste%%\}\}*}}}"
    return 1
  fi
  printf '%s\n' "$texte"
}

# --------------------------------------------------------------------------
# Les sources
# --------------------------------------------------------------------------
#
# Une source est un dépôt d'où viennent des ressources. La carte du dépôt de
# travail les déclare, et rien d'autre ne les déclare : clia ne fouille pas le
# disque à la recherche de dépôts, et n'exécute donc que ce qu'un humain a
# nommé dans la carte de son propre dépôt.
#
#   sources:
#     - provider: session.clia.noumanity.com
#       type: local
#       uri: ../clia-session
#
# Une source est soit un dépôt clia — elle porte une carte — soit un dépôt
# ordinaire. Une extension doit être un dépôt clia : c'est sa carte qui dit
# quel namespace ses ressources portent, et une ressource sans provenance
# déclarée n'est pas identifiable.
#
# Le type « local » est le seul que clia tienne aujourd'hui. Un type qu'il ne
# connaît pas est signalé et laissé de côté : mieux vaut le dire que faire
# comme si la source n'avait pas été déclarée.

# _clia_source_racine <dépôt> <uri> — le chemin absolu d'une source locale,
# l'uri étant relative à la racine du dépôt qui la déclare. Rien si le
# répertoire n'existe pas.
_clia_source_racine() {
  local depot="$1" uri="$2" chemin
  [[ -n "$uri" ]] || return 1
  case "$uri" in
    /*) chemin="$uri" ;;
    *)  chemin="$depot/$uri" ;;
  esac
  [[ -d "$chemin" ]] || return 1
  (cd -P "$chemin" >/dev/null 2>&1 && pwd)
}

# _clia_sources <dépôt> — « provider<TAB>type<TAB>uri » pour chaque source
# déclarée par la carte du dépôt.
_clia_sources() {
  local carte
  carte=$(_clia_carte "$1") || return 0
  _clia_bloc_yaml "$carte" sources provider type uri
}

# _clia_extensions <dépôt> — « provider<TAB>racine » pour chaque source qui
# est utilisable comme extension : locale, présente, dépôt clia, et portant
# un répertoire _ressources.
#
# Les autres ne sont pas une erreur ici : elles sont ce qu'elles sont, et
# c'est « clia src ls » qui en rend compte. Une commande de travail ne doit
# pas échouer parce qu'un dépôt voisin n'est pas cloné.
_clia_extensions() {
  local depot="$1" provider type uri racine
  while IFS=$'\t' read -r provider type uri; do
    [[ -n "$provider" ]] || continue
    [[ "$type" == 'local' || -z "$type" ]] || continue
    racine=$(_clia_source_racine "$depot" "$uri") || continue
    _clia_carte_relative "$racine" >/dev/null || continue
    [[ -d "$racine/_ressources" ]] || continue
    printf '%s\t%s\n' "$provider" "$racine"
  done < <(_clia_sources "$depot")
  return 0
}
