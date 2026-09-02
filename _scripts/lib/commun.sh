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

# Les primitives du harnais voyagent avec la ressource installée : un dépôt
# qui installe harness-ia doit pouvoir en tirer ses fichiers, et il n'a pas
# l'instance qui les écrit.
_clia_harnais_primitives() {
  printf '%s/harness-ia/primitives\n' "$(_clia_zone_livree)"
}

# « nom<TAB>chemin de la primitive », triés par nom.
_clia_harnais_offerts() {
  local f
  for f in "${CLIA_SOURCE_DIR:-}/$(_clia_harnais_primitives)"/*; do
    [[ -f "$f" ]] && printf '%s\t%s\n' "$(basename "$f")" "$f"
  done | LC_ALL=C sort
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

# Les champs sont séparés par le séparateur d'unité, et non par une
# tabulation. La tabulation est un blanc au sens de IFS : « read -r a b c » y
# fusionne deux champs consécutifs vides, et le troisième champ se lirait dans
# le deuxième. Un champ absent est le cas ordinaire ici — une source sans
# « type: », une entrée sans « version: » — et il doit rester vide sans
# décaler ceux qui suivent.
_CLIA_SEP=$'\x1f'

# _clia_bloc_yaml <fichier> <bloc> <champ…> — une ligne par entrée.
_clia_bloc_yaml() {
  local fichier="$1" bloc="$2"; shift 2
  [[ -f "$fichier" ]] || return 0
  awk -v bloc="$bloc" -v demandes="$*" -v sep="$_CLIA_SEP" '
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
        ligne = ligne (i > 1 ? sep : "") (champ[demande[i]] "")
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
# Lecture d'un bloc imbriqué
# --------------------------------------------------------------------------
#
# La carte porte aussi des listes rangées sous une clé de deuxième niveau :
#
#   use:
#     extensions:
#     - resource: session.clia.noumanity.com/SES
#       version: 0.1.0
#
# Les entrées y sont indentées comme leur clé, et non davantage. C'est la
# forme que l'humain a écrite, et l'analyseur l'épouse plutôt que de la
# corriger.

# _clia_sous_bloc_yaml <fichier> <parent> <bloc> <champ…> — une ligne par entrée.
_clia_sous_bloc_yaml() {
  local fichier="$1" parent="$2" bloc="$3"; shift 3
  [[ -f "$fichier" ]] || return 0
  awk -v parent="$parent" -v bloc="$bloc" -v demandes="$*" -v sep="$_CLIA_SEP" '
    function valeur(l,   s) {
      s = l
      sub(/^[^:]*:[[:space:]]*/, "", s)
      sub(/[[:space:]]*#.*$/, "", s)
      sub(/[[:space:]]+$/, "", s)
      if (substr(s, 1, 1) == "\"" && substr(s, length(s), 1) == "\"")
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
        ligne = ligne (i > 1 ? sep : "") (champ[demande[i]] "")
      print ligne
      delete champ
      ouvert = 0
    }
    BEGIN { nb = split(demandes, demande, " ") }
    /^[[:space:]]*#/ { next }
    /^[[:space:]]*$/ { next }
    /^[^[:space:]]/  { vider(); dans_parent = ($0 ~ "^" parent ":[[:space:]]*$"); dans = 0; next }
    !dans_parent     { next }
    /^[[:space:]]+[A-Za-z][A-Za-z0-9_-]*:[[:space:]]*$/ {
      vider(); dans = ($0 ~ "^[[:space:]]+" bloc ":[[:space:]]*$"); next
    }
    !dans { next }
    /^[[:space:]]*-[[:space:]]/       { vider(); ouvert = 1; champ[cle($0)] = valeur($0); next }
    ouvert && /^[[:space:]]+[A-Za-z]/ { champ[cle($0)] = valeur($0); next }
    END { vider() }
  ' "$fichier"
}

# --------------------------------------------------------------------------
# Écrire une entrée dans la carte
# --------------------------------------------------------------------------
#
# La carte est écrite par un humain : elle porte des commentaires, un ordre,
# des blocs qu'il a rangés comme il l'entend. Une entrée s'y ajoute à la fin
# de son bloc, et rien d'autre n'est touché — ni réindenté, ni réordonné, ni
# recommenté. Une commande qui reformaterait la carte rendrait illisible le
# diff de ce qu'elle a vraiment changé.
#
# Un bloc absent est créé à la fin du fichier. Le créer ailleurs demanderait
# de deviner où l'humain l'aurait mis.

# _clia_carte_inserer <fichier> <chemin> <ligne…> — le chemin est « bloc » ou
# « parent.bloc ». Les lignes sont écrites telles quelles.
_clia_carte_inserer() {
  local fichier="$1" chemin="$2"; shift 2
  local parent bloc lignes=() i fin=-1 debut_bloc=-1

  case "$chemin" in
    *.*) parent="${chemin%%.*}"; bloc="${chemin#*.}" ;;
    *)   parent=''; bloc="$chemin" ;;
  esac

  mapfile -t lignes < "$fichier"

  if [[ -z "$parent" ]]; then
    for i in "${!lignes[@]}"; do
      if [[ "${lignes[i]}" =~ ^${bloc}:[[:space:]]*$ ]]; then debut_bloc=$i; continue; fi
      if (( debut_bloc >= 0 )) && [[ "${lignes[i]}" =~ ^[^[:space:]#] ]]; then fin=$i; break; fi
    done
  else
    local dans_parent=0
    for i in "${!lignes[@]}"; do
      if [[ "${lignes[i]}" =~ ^${parent}:[[:space:]]*$ ]]; then dans_parent=1; continue; fi
      if (( debut_bloc >= 0 )); then
        # Une clé de deuxième niveau, ou un retour en colonne zéro, ferme le bloc.
        if [[ "${lignes[i]}" =~ ^[^[:space:]#] ]] \
           || [[ "${lignes[i]}" =~ ^[[:space:]]+[A-Za-z][A-Za-z0-9_-]*:[[:space:]]*$ ]]; then
          fin=$i; break
        fi
        continue
      fi
      (( dans_parent )) || continue
      if [[ "${lignes[i]}" =~ ^[^[:space:]#] ]]; then dans_parent=0; continue; fi
      [[ "${lignes[i]}" =~ ^[[:space:]]+${bloc}:[[:space:]]*$ ]] && debut_bloc=$i
    done
  fi

  # Bloc absent : il est créé à la fin, avec son parent au besoin.
  if (( debut_bloc < 0 )); then
    { printf '\n'
      [[ -n "$parent" ]] && printf '%s:\n  %s:\n' "$parent" "$bloc"
      [[ -n "$parent" ]] || printf '%s:\n' "$bloc"
      printf '%s\n' "$@"
    } >> "$fichier"
    return 0
  fi

  (( fin < 0 )) && fin=${#lignes[@]}

  # Les lignes vides qui précèdent la fin du bloc appartiennent à ce qui suit.
  while (( fin > debut_bloc + 1 )) && [[ -z "${lignes[fin-1]}" ]]; do fin=$((fin - 1)); done

  { (( fin > 0 )) && printf '%s\n' "${lignes[@]:0:fin}"
    printf '%s\n' "$@"
    (( fin < ${#lignes[@]} )) && printf '%s\n' "${lignes[@]:fin}"
  } > "$fichier.nouveau"
  mv -f "$fichier.nouveau" "$fichier"
  return 0
}

# _clia_carte_retirer <fichier> <chemin> <champ> <valeur> — retire l'entrée
# dont <champ> vaut <valeur>. Rend 1 si aucune entrée ne correspond.
_clia_carte_retirer() {
  local fichier="$1" chemin="$2" champ="$3" valeur="$4"
  local lignes=() garde=() i debut=-1 trouve=0

  mapfile -t lignes < "$fichier"

  for i in "${!lignes[@]}"; do
    if [[ "${lignes[i]}" =~ ^[[:space:]]*-[[:space:]] ]]; then
      # Une entrée commence : celle d'avant est close.
      if (( debut >= 0 )); then debut=-1; fi
      if [[ "${lignes[i]}" =~ ^[[:space:]]*-[[:space:]]+${champ}:[[:space:]]*\"?${valeur}\"?[[:space:]]*$ ]]; then
        debut=$i; trouve=1; continue
      fi
    elif (( debut >= 0 )) && [[ "${lignes[i]}" =~ ^[[:space:]]+[A-Za-z] ]]; then
      continue
    elif (( debut >= 0 )); then
      debut=-1
    fi
    (( debut >= 0 )) || garde+=("${lignes[i]}")
  done

  (( trouve )) || return 1
  printf '%s\n' "${garde[@]}" > "$fichier.nouveau"
  mv -f "$fichier.nouveau" "$fichier"
  return 0
}

# --------------------------------------------------------------------------
# Les deux zones de ressources
# --------------------------------------------------------------------------
#
# SES-001 tâche 19, et .dev/ressources/RES-001-ressource/primitive-2/
# SPC-001-ontologie.md, qui en tire l'ontologie.
#
#   $CLIA_ZONE_RESSOURCE        ce que le dépôt écrit    (.dev/ressources)
#   $CLIA_ZONE_RESSOURCE_LIVREE ce qu'il a installé      (.clia/ressources)
#
# La séparation n'est pas un rangement : elle sépare ce qu'on écrit de ce
# qu'on emploie. Ce qu'on écrit change, se discute, se reprend ; ce qu'on
# emploie est figé, et sa version est un fait. Les confondre revenait à ce
# qu'une ressource change sous les pieds de ce qui s'en sert.
#
# Le CLI ne trouve ses ressources que dans la zone livrée. Une ressource
# qu'un dépôt écrit sans l'avoir installée ne répond pas — et c'est ce qui
# fait de l'installation un geste, donc une trace.
#
# Les deux emplacements se règlent par l'environnement, ce qui permet de
# ranger la zone livrée hors de l'index de git si on le veut.

_CLIA_ZONE_RESSOURCE_DEFAUT='.dev/ressources'
_CLIA_ZONE_LIVREE_DEFAUT='.clia/ressources'

_clia_zone_ressource() { printf '%s\n' "${CLIA_ZONE_RESSOURCE:-$_CLIA_ZONE_RESSOURCE_DEFAUT}"; }
_clia_zone_livree()    { printf '%s\n' "${CLIA_ZONE_RESSOURCE_LIVREE:-$_CLIA_ZONE_LIVREE_DEFAUT}"; }

# --------------------------------------------------------------------------
# Ce qu'un dépôt porte
# --------------------------------------------------------------------------
#
# Trois lectures, et elles ne disent pas la même chose :
#
#   _clia_ressources_de  ce qui est installé, et donc utilisable
#   _clia_instances_de   ce que le dépôt écrit, sous forme d'instances
#   _clia_offertes_de    ce qu'il publie, tiré des livrables de ses instances
#
# Un répertoire est une ressource installée parce qu'il porte sa définition,
# et pour aucune autre raison. Une instance en est une parce que son nom
# porte un préfixe, une séquence et un slug.

# _clia_ressources_de <racine> — « nom<TAB>prefixe<TAB>version » des
# ressources installées, triées par nom.
_clia_ressources_de() {
  local racine="$1" zone def nom prefixe version
  zone=$(_clia_zone_livree)
  for def in "$racine/$zone"/*/*.yaml; do
    [[ -f "$def" ]] || continue
    nom=$(basename "$(dirname "$def")")
    [[ "$(basename "$def")" == "$nom.yaml" ]] || continue
    prefixe=$(_clia_champ_yaml "$def" prefixe || printf '')
    version=$(_clia_champ_yaml "$def" version || printf '')
    printf '%s\t%s\t%s\n' "$nom" "${prefixe:-—}" "${version:-—}"
  done | LC_ALL=C sort
  return 0
}

_CLIA_INSTANCE='^[A-Z]{2,5}-[0-9]{3,}-'

# _clia_instances_de <racine> — « id<TAB>nom<TAB>prefixe<TAB>version » pour
# chaque instance dont le livrable porte une définition de ressource.
#
# L'identifiant est le nom du répertoire — PREFIXE-SEQ-SLUG. Le nom et le
# préfixe sont ceux que le livrable déclare : le répertoire les répète pour
# un lecteur, la définition les tient pour la machine.
_clia_instances_de() {
  local racine="$1" zone dir id def nom prefixe version
  zone=$(_clia_zone_ressource)
  for dir in "$racine/$zone"/*/; do
    [[ -d "$dir" ]] || continue
    id=$(basename "$dir")
    [[ "$id" =~ $_CLIA_INSTANCE ]] || continue
    for def in "$dir"livrables/*.yaml; do
      [[ -f "$def" ]] || continue
      nom=$(_clia_champ_yaml "$def" nom || printf '')
      [[ -n "$nom" && "$(basename "$def")" == "$nom.yaml" ]] || continue
      prefixe=$(_clia_champ_yaml "$def" prefixe || printf '')
      version=$(_clia_champ_yaml "$def" version || printf '')
      printf '%s\t%s\t%s\t%s\n' "$id" "$nom" "${prefixe:-—}" "${version:-—}"
    done
  done | LC_ALL=C sort
  return 0
}

# _clia_offertes_de <racine> — « nom<TAB>prefixe<TAB>version<TAB>livrable »
# pour ce qu'un dépôt publie. C'est ce qu'une extension offre à installer.
_clia_offertes_de() {
  local racine="$1" zone id nom prefixe version
  zone=$(_clia_zone_ressource)
  while IFS=$'\t' read -r id nom prefixe version; do
    [[ -n "$nom" ]] || continue
    printf '%s\t%s\t%s\t%s\n' \
      "$nom" "$prefixe" "$version" "$racine/$zone/$id/livrables"
  done < <(_clia_instances_de "$racine")
  return 0
}

# _clia_instance_de <racine> <nom> — l'identifiant de l'instance qui publie
# cette ressource, ou rien.
_clia_instance_de() {
  local cible="$2" id nom
  while IFS=$'\t' read -r id nom _ _; do
    [[ "$nom" == "$cible" ]] && { printf '%s\n' "$id"; return 0; }
  done < <(_clia_instances_de "$1")
  return 1
}

# --------------------------------------------------------------------------
# Les sources
# --------------------------------------------------------------------------
#
# Une source est un dépôt d'où viennent des ressources ou des données. La
# carte du dépôt de travail les déclare, et rien d'autre ne les déclare : clia
# ne fouille pas le disque à la recherche de dépôts voisins.
#
#   sources:
#     - provider: session.clia.noumanity.com
#       type: local
#       uri: ../clia-session
#
# Deux types. « local » désigne un répertoire, par un chemin relatif à la
# racine du dépôt qui le déclare, ou absolu. « git » désigne un dépôt
# distant : la déclaration porte son URI, et le clone vit dans un cache de la
# machine.
#
# Deux endroits, et c'est voulu : la déclaration est versionnée et suit le
# dépôt ; le clone est un artefact de cette machine-ci et n'a rien à faire
# dans l'historique. C'est la répartition qu'avait retenue la génération
# 2026-08-31, et rien depuis ne l'a mise en défaut.

_clia_cache_racine() {
  printf '%s/clia/extensions\n' "${XDG_CACHE_HOME:-$HOME/.cache}"
}

# _clia_extension_cache <provider> — où le clone d'une source distante vit.
_clia_extension_cache() {
  printf '%s/%s\n' "$(_clia_cache_racine)" "$1"
}

# _clia_source_racine <dépôt> <type> <uri> <provider> — le répertoire qu'une
# source désigne réellement, ou rien.
_clia_source_racine() {
  local depot="$1" type="$2" uri="$3" provider="$4" chemin
  case "${type:-local}" in
    local)
      [[ -n "$uri" ]] || return 1
      case "$uri" in
        /*) chemin="$uri" ;;
        *)  chemin="$depot/$uri" ;;
      esac ;;
    git)
      chemin=$(_clia_extension_cache "$provider") ;;
    *)
      return 1 ;;
  esac
  [[ -d "$chemin" ]] || return 1
  (cd -P "$chemin" >/dev/null 2>&1 && pwd)
}

# _clia_sources <dépôt> — « provider<TAB>type<TAB>uri » pour chaque source.
_clia_sources() {
  local carte
  carte=$(_clia_carte "$1") || return 0
  _clia_bloc_yaml "$carte" sources provider type uri
}

# _clia_source_nature <dépôt> <provider> <type> <uri> — ce que la source est,
# constaté et non déclaré :
#
#   extension     dépôt clia portant des ressources
#   dépôt clia    dépôt clia qui ne publie aucune ressource
#   dépôt         présent, sans carte clia
#   non clonée    déclarée en git, et absente du cache
#   absente       l'uri locale ne mène à aucun répertoire
#   type inconnu  un type que clia ne sait pas atteindre
_clia_source_nature() {
  local depot="$1" provider="$2" type="$3" uri="$4" racine
  case "${type:-local}" in
    local|git) ;;
    *) printf 'type inconnu\n'; return 0 ;;
  esac
  if ! racine=$(_clia_source_racine "$depot" "$type" "$uri" "$provider"); then
    [[ "$type" == 'git' ]] && { printf 'non clonée\n'; return 0; }
    printf 'absente\n'; return 0
  fi
  if ! _clia_carte_relative "$racine" >/dev/null; then
    printf 'dépôt\n'; return 0
  fi
  if [[ -n "$(_clia_offertes_de "$racine")" ]]; then
    printf 'extension\n'
  else
    printf 'dépôt clia\n'
  fi
}

# _clia_extensions <dépôt> — « provider<TAB>racine » pour chaque source
# utilisable comme extension.
_clia_extensions() {
  local depot="$1" provider type uri racine
  while IFS="$_CLIA_SEP" read -r provider type uri; do
    [[ -n "$provider" ]] || continue
    [[ "$(_clia_source_nature "$depot" "$provider" "$type" "$uri")" == 'extension' ]] || continue
    racine=$(_clia_source_racine "$depot" "$type" "$uri" "$provider") || continue
    printf '%s\t%s\n' "$provider" "$racine"
  done < <(_clia_sources "$depot")
  return 0
}

# _clia_installees <dépôt> — « identité<TAB>version » de ce que la carte
# déclare avoir repris d'une extension. L'identité s'écrit
# <provider>/<PREFIXE>.
#
# Les deux orthographes du champ — « resource » et « ressource » — sont lues :
# la carte de ce dépôt porte les deux, et refuser l'une ferait disparaître ce
# qu'elle déclare.
_clia_installees() {
  local carte a b version
  carte=$(_clia_carte "$1") || return 0
  while IFS="$_CLIA_SEP" read -r a b version; do
    [[ -n "$a$b" ]] || continue
    printf '%s%s%s\n' "${a:-$b}" "$_CLIA_SEP" "$version"
  done < <(_clia_sous_bloc_yaml "$carte" use extensions resource ressource version)
  return 0
}
