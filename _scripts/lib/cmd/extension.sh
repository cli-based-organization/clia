#!/usr/bin/env bash
# Description: Les extensions — add, ls, install, uninstall.
# Périmètre: dépôt
# Signature: extension add URI
# Signature: extension ls
# Signature: extension install EXTENSION
# Signature: extension uninstall EXTENSION
#
# Implémente SES-001 tâches 11, 12 et 14.
#
# Ce qu'est une extension
# -----------------------
#
# Un dépôt git qui est un dépôt clia — il porte une carte déclarant un
# namespace — et qui porte des ressources sous _ressources/. Les deux
# conditions sont exigées : sans carte, les ressources n'ont pas de
# provenance déclarée, et CONSTITUTION.md R2 interdit à l'automatisme d'en
# deviner une.
#
# Une source qui n'est pas une extension n'est pas une erreur : c'est une
# source de données, et clia-source(1) en rend compte.
#
# Deux endroits, et c'est voulu
# -----------------------------
#
#   la carte du dépôt        la déclaration, versionnée, qui suit le dépôt
#   ~/.cache/clia/extensions le clone d'une source distante, propre à cette
#                            machine
#
# La répartition est celle de la génération 2026-08-31, et rien depuis ne l'a
# mise en défaut. Un clone dans l'historique ferait entrer dans le dépôt un
# artefact qui n'en dit rien.
#
# Une source locale n'est pas clonée : elle est déjà là. La déclarer suffit.
#
# Déclarer n'est pas installer
# ---------------------------
#
# Déclarer une extension dit d'où des ressources peuvent venir. Rien n'en est
# exécutable pour autant. « install » reprend les ressources dans le dépôt :
# elles y sont copiées, versionnées avec lui, et lisibles par qui l'ouvre.
# « uninstall » les en retire.
#
# C'est ce qui fait que clia n'exécute jamais de code depuis un dépôt voisin.
# Le code qui tourne est celui du dépôt, ou celui du CLI, et il se relit.
#
# Ce qui est repris, et ce qui ne l'est pas
# -----------------------------------------
#
# Tout, sauf les primitives — SES-001 tâche 14. Une ressource dit comment
# produire des livrables et porte les primitives à partir desquelles ils sont
# produits. Le comment appartient à l'extension et se reprend ; les
# primitives appartiennent au dépôt qui les écrit. Reprendre celles de
# l'extension mettrait dans ce dépôt-ci un contenu qui parle d'un autre.
#
# Les collisions ne sont pas gérées
# ---------------------------------
#
# SES-001 tâche 14 : ni de nom, ni de préfixe. Une reprise qui heurterait une
# ressource déjà là est refusée, et rien n'est posé — pas même les ressources
# de la même extension qui, elles, ne heurtent rien. Une extension à moitié
# reprise obligerait à savoir laquelle des moitiés est là.
#
# Renommer à la volée serait l'autre issue, et elle est pire : l'identité
# d'une ressource est son préfixe, et un préfixe choisi par l'outil ne
# désigne plus rien de stable.

set -euo pipefail

_CLIA_NOM='clia'
# shellcheck source=../commun.sh
. "$CLIA_SOURCE_DIR/_scripts/lib/commun.sh"

# shellcheck source=../ressource.sh
. "$CLIA_SOURCE_DIR/_scripts/lib/ressource.sh"

DEPOT="${CLIA_WORK_DIR:-}"

# --------------------------------------------------------------------------

manuel() {
  cat <<'EOF' | _clia_man clia-extension 1 "Manuel de l'utilisateur clia"
NOM
clia-extension - déclarer des extensions, et reprendre leurs ressources

SYNOPSIS
clia extension add URI
clia extension ls
clia extension install EXTENSION
clia extension uninstall EXTENSION

DESCRIPTION
Une extension est un dépôt clia qui porte des ressources. Un autre
dépôt peut les reprendre : c'est ainsi qu'une capacité écrite une
fois sert à plusieurs dépôts.

Deux gestes, et ils ne font pas la même chose.

Déclarer une extension dit d'où des ressources peuvent venir. La
déclaration va dans la carte du dépôt, elle est versionnée, et elle
le suit. Rien n'en devient exécutable.

Installer une extension reprend ses ressources dans le dépôt :
elles y sont copiées sous _ressources/, versionnées avec lui, et
lisibles par qui l'ouvre. C'est à ce moment que leurs commandes
répondent. Désinstaller les en retire.

Tout est repris, sauf les primitives. Une ressource dit comment
produire des livrables, et porte les primitives à partir desquelles
ils sont produits. Le comment appartient à l'extension et se
reprend ; les primitives appartiennent au dépôt qui les écrit.

clia n'exécute donc jamais de code depuis un dépôt voisin. Ce qui
tourne est ce que le dépôt porte, ou ce que le CLI porte.

Une source distante est clonée dans un cache de cette machine, sous
~/.cache/clia/extensions. Le clone est un artefact local : il n'a
rien à faire dans l'historique du dépôt, qui ne porte que l'URI.

Une source locale n'est pas clonée. Elle est déjà là, et la
déclarer suffit.

SOUS-COMMANDES
add URI
       Déclare un dépôt comme extension.

       URI est soit le chemin d'un répertoire — relatif à la racine
       du dépôt, ou absolu — soit l'URI d'un dépôt git distant.
       Un chemin qui désigne un répertoire existant est pris comme
       tel ; tout le reste est tenté comme dépôt git.

       Le dépôt visé doit porter une carte déclarant un namespace,
       et au moins une ressource. C'est ce namespace qui identifie
       l'extension : deux URI peuvent mener au même dépôt, un
       namespace n'en désigne qu'un.

       Une source qui mène au même répertoire qu'une source déjà
       déclarée n'est pas redéclarée.

       Rien n'est installé, et rien n'est commité.

ls
       Les extensions déclarées, ce qu'elles portent, et ce que ce
       dépôt en a repris.

       La colonne RESSOURCES porte les préfixes offerts ; celles
       qui sont déjà dans le dépôt y figurent entre crochets.

install EXTENSION
       Reprend dans le dépôt toutes les ressources de l'extension,
       sans leurs primitives, et les inscrit à l'inventaire de la
       carte.

       Les collisions ne sont pas gérées : si une ressource du
       dépôt porte déjà le nom ou le préfixe de l'une d'elles, la
       reprise est refusée et rien n'est posé — pas même les
       ressources qui ne heurtent rien. Une extension à moitié
       reprise obligerait à savoir laquelle des moitiés est là.

       EXTENSION se désigne par son provider tel qu'il est déclaré,
       par son namespace, ou par une portion qui n'en désigne
       qu'une.

       Rien n'est commité.

uninstall EXTENSION
       Retire du dépôt les ressources reprises de cette extension,
       et leurs entrées d'inventaire.

       Ce qui est retiré est ce que l'inventaire dit venir de là.
       L'extension elle-même n'est pas lue : on désinstalle
       justement quand elle n'est plus joignable.

       Sa déclaration de source reste. Désinstaller n'est pas
       oublier d'où cela venait.

       Les refus sont ceux de « clia <ressource> deactivate », et
       ils portent sur tout avant que rien ne soit effacé : un
       retrait à moitié fait laisserait un inventaire qui ment.

       Rien n'est commité.

SORTIE
La sortie standard de « ls » porte une ligne d'en-tête et une ligne
par extension. Celle d'« install » porte le chemin de chaque
ressource reprise. « uninstall » n'en porte aucune.

Tout le reste va sur la sortie d'erreur.

CODE DE RETOUR
0
       La demande est satisfaite, même s'il n'y a aucune extension.

1
       Refus : URI inutilisable, dépôt qui n'est pas une extension,
       extension inconnue, clone impossible, collision de nom ou de
       préfixe, ou ressource que le retrait ne peut pas garantir.

2
       Demande mal formée.

FICHIERS
clia.yaml, .clia.yaml, .dev/clia.yaml
       La carte. Son bloc « sources: » porte les déclarations, son
       bloc « use: extensions: » l'inventaire de ce qui a été
       repris.

~/.cache/clia/extensions/<namespace>
       Le clone d'une source distante, propre à cette machine.

_ressources/<nom>/
       Une ressource reprise, sans son répertoire primitives/. Elle
       appartient au dépôt dès lors : clia ne la régénère pas, et
       « clia <ressource> deactivate » en retire une, « clia
       extension uninstall » toutes celles d'une extension.

EXEMPLES
Déclarer un dépôt voisin, puis en reprendre les ressources :

       $ clia extension add ../clia-session
       $ clia extension install session.clia.noumanity.com

Retirer une ressource reprise, puis toute l'extension :

       $ clia ses deactivate
       $ clia extension uninstall session.clia.noumanity.com

VOIR AUSSI
clia(1), clia-source(1), clia-res(1), clia-check(1)
EOF
}

# --------------------------------------------------------------------------
# Ce que la carte déclare
# --------------------------------------------------------------------------

carte_du_depot() {
  local carte
  if ! carte=$(_clia_carte "$DEPOT"); then
    _clia_msg "ce dépôt ne porte pas de carte clia"
    _clia_detail "clia init la pose ; clia check dit ce qui manque"
    return 1
  fi
  printf '%s\n' "$carte"
}

# « provider<SEP>type<SEP>uri<SEP>racine » pour chaque source qui est une
# extension. Une source déclarée mais absente y figure avec une racine vide :
# elle est connue du dépôt, et rien ne peut en être lu.
extensions_declarees() {
  local provider type uri nature racine
  while IFS="$_CLIA_SEP" read -r provider type uri; do
    [[ -n "$provider" ]] || continue
    nature=$(_clia_source_nature "$DEPOT" "$provider" "$type" "$uri")
    racine=$(_clia_source_racine "$DEPOT" "$type" "$uri" "$provider" 2>/dev/null) || racine=''
    case "$nature" in
      extension)             ;;
      'non clonée'|absente)  racine='' ;;
      *)                     continue ;;
    esac
    printf '%s%s%s%s%s%s%s\n' \
      "$provider" "$_CLIA_SEP" "${type:-local}" "$_CLIA_SEP" "$uri" "$_CLIA_SEP" "$racine"
  done < <(_clia_sources "$DEPOT")
  return 0
}

# Résout une désignation vers un provider déclaré.
resoudre() {
  local demande="$1" provider trouve='' nb=0 ns racine
  while IFS="$_CLIA_SEP" read -r provider _ _ racine; do
    [[ -n "$provider" ]] || continue
    if [[ "$provider" == "$demande" ]]; then printf '%s\n' "$provider"; return 0; fi
    ns=''
    [[ -n "$racine" ]] && ns=$(_clia_champ_yaml "$(_clia_carte "$racine")" namespace || printf '')
    if [[ "$ns" == "$demande" || "$provider" == *"$demande"* ]]; then
      trouve="$provider"; nb=$((nb + 1))
    fi
  done < <(extensions_declarees)

  if (( nb == 1 )); then printf '%s\n' "$trouve"; return 0; fi
  if (( nb > 1 )); then
    _clia_msg "désignation ambiguë : $demande"
    _clia_detail "elle désigne plus d'une extension ; celles du dépôt : clia extension ls"
    return 1
  fi
  _clia_msg "extension inconnue : $demande"
  _clia_detail "celles que le dépôt déclare : clia extension ls"
  return 1
}

# --------------------------------------------------------------------------
# add
# --------------------------------------------------------------------------

# Ce qu'un répertoire doit être pour qu'on le déclare extension.
verifier_extension() {
  local racine="$1" quoi="$2" ns
  if ! _clia_carte_relative "$racine" >/dev/null; then
    _clia_msg "$quoi n'est pas un dépôt clia"
    _clia_detail "il ne porte pas de carte déclarant un namespace"
    _clia_detail "un dépôt le devient avec : clia init"
    return 1
  fi
  ns=$(_clia_champ_yaml "$(_clia_carte "$racine")" namespace || printf '')
  if [[ -z "$ns" || "$ns" == *'<'* ]]; then
    _clia_msg "$quoi ne déclare pas de namespace utilisable"
    _clia_detail "sa carte porte « namespace: ${ns:-(vide)} »"
    _clia_detail "une ressource sans provenance déclarée n'est pas identifiable"
    return 1
  fi
  if [[ -z "$(_clia_ressources_de "$racine")" ]]; then
    _clia_msg "$quoi ne porte aucune ressource"
    _clia_detail "une extension apporte des ressources ; celui-ci n'en a pas"
    _clia_detail "pour le déclarer comme source de données : clia source add"
    return 1
  fi
  printf '%s\n' "$ns"
  return 0
}

# La source déjà déclarée qui mène au même répertoire, ou rien.
deja_declaree() {
  local racine="$1" provider type uri autre
  while IFS="$_CLIA_SEP" read -r provider type uri; do
    [[ -n "$provider" ]] || continue
    autre=$(_clia_source_racine "$DEPOT" "$type" "$uri" "$provider" 2>/dev/null) || continue
    [[ "$autre" == "$racine" ]] && { printf '%s\n' "$provider"; return 0; }
  done < <(_clia_sources "$DEPOT")
  return 1
}

declarer() {
  local carte="$1" provider="$2" type="$3" uri="$4"
  _clia_carte_inserer "$carte" sources \
    "  - provider: $provider" \
    "    type: $type" \
    "    uri: $uri"
}

ajouter() {
  local uri="$1" carte racine ns type deja chemin

  carte=$(carte_du_depot) || return 1

  # Un chemin qui désigne un répertoire existant est pris comme tel. Tout le
  # reste est tenté comme dépôt git : c'est la seule autre chose qu'une URI
  # puisse être ici, et l'échec du clone le dira mieux qu'une devinette sur
  # la forme de la chaîne.
  case "$uri" in
    /*) chemin="$uri" ;;
    *)  chemin="$DEPOT/$uri" ;;
  esac

  if [[ -d "$chemin" ]]; then
    racine=$(cd -P "$chemin" && pwd)
    ns=$(verifier_extension "$racine" "$uri") || return 1
    type='local'
  else
    racine=$(cloner "$uri") || return 1
    ns=$(_clia_champ_yaml "$(_clia_carte "$racine")" namespace)
    type='git'
  fi

  if deja=$(deja_declaree "$racine"); then
    _clia_msg "cette source est déjà déclarée : $deja"
    _clia_detail "elle mène au même dépôt ; rien n'a été modifié"
    _clia_detail "pour en reprendre les ressources : clia extension install $deja"
    return 0
  fi

  # Le provider est le namespace que la source déclare. Il n'est pas dérivé :
  # deux URI peuvent mener au même dépôt, un namespace n'en désigne qu'un, et
  # CONSTITUTION.md R2 refuse à l'automatisme de deviner une provenance.
  declarer "$carte" "$ns" "$type" "$uri" || return 1

  _clia_msg "extension déclarée : $ns"
  _clia_detail "dans ${carte#"$DEPOT"/}, en source $type"
  [[ "$type" == 'git' ]] && _clia_detail "clonée dans $(_clia_extension_cache "$ns")"
  _clia_detail ''
  _clia_detail "ce qu'elle porte     : clia extension ls"
  _clia_detail "tout reprendre       : clia extension install $ns"
  _clia_detail "rien n'est installé, et rien n'est commité"
  return 0
}

# Clone une source distante dans le cache, et rend sa racine.
#
# Le clone va d'abord dans un temporaire : tant que le dépôt n'a pas montré
# qu'il est une extension, il n'a rien à faire dans le cache.
cloner() {
  local uri="$1" tmp ns cache
  tmp=$(mktemp -d)
  # shellcheck disable=SC2064
  trap "rm -rf '$tmp'" RETURN

  if ! git clone --quiet "$uri" "$tmp/depot" 2>/dev/null; then
    _clia_msg "le clone a échoué : $uri"
    _clia_detail "est-ce le chemin d'un répertoire, ou l'URI d'un dépôt git joignable ?"
    _clia_detail "rien n'a été déclaré"
    return 1
  fi

  # Un dépôt sans commit se clone sans erreur, et donne un répertoire vide.
  # Le distinguer d'un dépôt qui n'est pas une extension évite d'accuser le
  # second de ce dont le premier est coupable.
  if ! git -C "$tmp/depot" rev-parse --verify --quiet HEAD >/dev/null 2>&1; then
    _clia_msg "ce dépôt n'a aucun commit : $uri"
    _clia_detail "il n'y a rien à en cloner, et donc rien à en reprendre"
    _clia_detail "rien n'a été déclaré"
    return 1
  fi

  ns=$(verifier_extension "$tmp/depot" "$uri") || return 1

  cache=$(_clia_extension_cache "$ns")
  mkdir -p "$(dirname "$cache")"
  rm -rf "$cache"
  cp -r "$tmp/depot" "$cache"
  printf '%s\n' "$cache"
  return 0
}

# --------------------------------------------------------------------------
# ls
# --------------------------------------------------------------------------

lister() {
  local provider type uri racine nom prefixe version offertes reprises lignes=''

  if [[ -z "$(extensions_declarees)" ]]; then
    _clia_msg "ce dépôt ne déclare aucune extension"
    _clia_detail "pour en ajouter une : clia extension add URI"
    _clia_detail "les autres sources déclarées : clia source ls"
    return 0
  fi

  while IFS="$_CLIA_SEP" read -r provider type uri racine; do
    [[ -n "$provider" ]] || continue
    offertes=''
    reprises=0
    if [[ -n "$racine" ]]; then
      while IFS=$'\t' read -r nom prefixe version; do
        [[ -n "$nom" ]] || continue
        if [[ -d "$DEPOT/_ressources/$nom" ]]; then
          offertes="${offertes:+$offertes }[$prefixe]"
          reprises=$((reprises + 1))
        else
          offertes="${offertes:+$offertes }$prefixe"
        fi
      done < <(_clia_ressources_de "$racine")
    fi
    lignes+=$(printf '%s\t%s\t%s\t%s' \
      "$provider" \
      "$(_clia_source_nature "$DEPOT" "$provider" "$type" "$uri")" \
      "${offertes:-—}" \
      "$uri")$'\n'
  done < <(extensions_declarees)

  { printf 'EXTENSION\tETAT\tRESSOURCES\tURI\n'
    printf '%s' "$lignes"
  } | column -t -s $'\t'

  _clia_msg "entre crochets : ce que ce dépôt a déjà repris"
  return 0
}

# --------------------------------------------------------------------------
# install
# --------------------------------------------------------------------------

# La racine d'une extension déclarée, ou rien.
racine_de() {
  local provider="$1" nom racine
  while IFS="$_CLIA_SEP" read -r nom _ _ racine; do
    [[ "$nom" == "$provider" ]] && { printf '%s\n' "$racine"; return 0; }
  done < <(extensions_declarees)
  return 1
}

# Copie une ressource sans ses primitives — SES-001 tâche 14.
copier_ressource() {
  local src="$1" dst="$2" f
  mkdir -p "$dst"
  for f in "$src"/* "$src"/.[!.]*; do
    [[ -e "$f" ]] || continue
    [[ "$(basename "$f")" == 'primitives' ]] && continue
    cp -r "$f" "$dst/"
  done
  return 0
}

# Ce qui empêcherait la reprise, nommé. Rien si la voie est libre.
#
# Tout est vérifié avant qu'une seule ressource soit posée : une extension à
# moitié reprise obligerait à savoir laquelle des moitiés est là.
collisions() {
  local racine="$1" nom prefixe autre
  while IFS=$'\t' read -r nom prefixe _; do
    [[ -n "$nom" ]] || continue
    if [[ -e "$DEPOT/_ressources/$nom" ]]; then
      printf '%s\t%s\n' "$nom" "une ressource de ce nom est déjà là"
      continue
    fi
    if autre=$(_clia_r_nom_du_prefixe "$DEPOT" "$prefixe"); then
      printf '%s\t%s\n' "$nom" "le préfixe $prefixe est déjà celui de $autre"
    fi
  done < <(_clia_ressources_de "$racine")
  return 0
}

installer() {
  local demande="$1" carte provider racine nom prefixe version quoi
  local reprises=0

  carte=$(carte_du_depot) || return 1
  provider=$(resoudre "$demande") || return 1
  racine=$(racine_de "$provider") || racine=''

  if [[ -z "$racine" ]]; then
    _clia_msg "$provider est déclarée, et rien ne peut en être lu"
    _clia_detail "une source locale absente, ou une source distante non clonée"
    _clia_detail "pour rétablir le clone : clia extension add <URI>"
    return 1
  fi

  # SES-001 tâche 14 : les collisions ne sont pas gérées. Une seule suffit à
  # tout refuser, et rien n'est posé.
  local heurts
  heurts=$(collisions "$racine")
  if [[ -n "$heurts" ]]; then
    _clia_msg "$provider ne peut pas être reprise ici"
    while IFS=$'\t' read -r nom quoi; do
      [[ -n "$nom" ]] || continue
      _clia_detail "$nom : $quoi"
    done <<<"$heurts"
    _clia_detail ''
    _clia_detail "les collisions de nom et de préfixe ne sont pas gérées"
    _clia_detail "retirez ce qui est là — clia extension uninstall, ou"
    _clia_detail "clia <ressource> deactivate — puis reprenez"
    _clia_detail "rien n'a été repris"
    return 1
  fi

  while IFS=$'\t' read -r nom prefixe version; do
    [[ -n "$nom" ]] || continue

    mkdir -p "$DEPOT/_ressources"
    copier_ressource "$racine/_ressources/$nom" "$DEPOT/_ressources/$nom"

    # L'inventaire peut déjà porter cette identité — une carte écrite à la
    # main la déclare parfois avant que la ressource soit là. L'y remettre
    # ferait deux entrées pour une chose.
    #
    # « grep -c » et non « grep -q » : sous pipefail, un grep qui referme le
    # tube au premier résultat fait recevoir SIGPIPE à l'amont, et le test
    # rendrait faux là où il devait rendre vrai.
    local deja_inscrite
    deja_inscrite=$(_clia_installees "$DEPOT" | grep -cF "$provider/$prefixe$_CLIA_SEP") || true
    if (( deja_inscrite == 0 )); then
      _clia_carte_inserer "$carte" use.extensions \
        "  - resource: $provider/$prefixe" \
        "    version: $version"
    fi

    printf '_ressources/%s\n' "$nom"
    _clia_detail "reprise : $nom ($prefixe $version)"
    reprises=$((reprises + 1))
  done < <(_clia_ressources_de "$racine")

  if (( reprises == 0 )); then
    _clia_msg "$provider ne porte aucune ressource"
    return 0
  fi

  _clia_msg "$provider : $reprises ressource(s) reprise(s), sans leurs primitives"
  _clia_detail "inscrites à l'inventaire de ${carte#"$DEPOT"/}"
  _clia_detail "ce que le dépôt porte : clia res ls"
  _clia_detail "pour tout retirer     : clia extension uninstall $provider"
  _clia_detail "rien n'est commité"
  return 0
}

# --------------------------------------------------------------------------
# uninstall
# --------------------------------------------------------------------------
#
# Le contraire d'install, et de lui seul : la déclaration de la source reste.
# Retirer ce qu'on a repris n'est pas oublier d'où cela venait, et une
# extension qu'on désinstalle est souvent une extension qu'on réinstallera.
#
# Ce qui est retiré est ce que l'inventaire dit venir de cette extension. La
# lecture ne passe pas par l'extension elle-même : on désinstalle précisément
# quand elle n'est plus joignable, et une désinstallation qui exigerait la
# source ne servirait pas dans ce cas-là.

desinstaller() {
  local demande="$1" carte provider id prefixe nom
  local cibles='' orphelines='' retirees=0

  carte=$(carte_du_depot) || return 1
  provider=$(resoudre "$demande") || return 1

  while IFS="$_CLIA_SEP" read -r id _; do
    [[ "$id" == "$provider"/* ]] || continue
    prefixe="${id##*/}"
    if nom=$(_clia_r_nom_du_prefixe "$DEPOT" "$prefixe"); then
      cibles+="$nom"$'\n'
    else
      orphelines+="$id"$'\n'
    fi
  done < <(_clia_installees "$DEPOT")

  if [[ -z "$cibles$orphelines" ]]; then
    _clia_msg "rien n'a été repris de $provider dans ce dépôt"
    _clia_detail "l'inventaire de sa carte n'en porte aucune ressource"
    _clia_detail "ce qui est déclaré : clia extension ls"
    return 1
  fi

  # Tout est vérifié avant qu'une seule ressource soit effacée : un retrait à
  # moitié fait laisserait un dépôt dont l'inventaire ment.
  local refus=0
  while IFS= read -r nom; do
    [[ -n "$nom" ]] || continue
    _clia_r_verifier_retrait "$DEPOT" "$nom" || refus=1
  done <<<"$cibles"
  if (( refus )); then
    _clia_msg "$provider n'a pas été désinstallée"
    _clia_detail "rien n'a été retiré"
    return 1
  fi

  while IFS= read -r nom; do
    [[ -n "$nom" ]] || continue
    _clia_r_retirer "$DEPOT" "$nom"
    _clia_detail "retirée : $nom"
    retirees=$((retirees + 1))
  done <<<"$cibles"

  # Une entrée d'inventaire dont la ressource n'est plus là : elle a été
  # retirée à la main. L'entrée part avec le reste, et clia le dit plutôt que
  # de la faire disparaître en silence.
  while IFS= read -r id; do
    [[ -n "$id" ]] || continue
    _clia_carte_retirer "$carte" use.extensions resource "$id" \
      || _clia_carte_retirer "$carte" use.extensions ressource "$id" \
      || true
    _clia_msg "$id était à l'inventaire, et sa ressource n'était plus là"
    _clia_detail "l'entrée a été retirée"
  done <<<"$orphelines"

  _clia_msg "$provider désinstallée : $retirees ressource(s) retirée(s)"
  _clia_detail "sa déclaration de source reste dans ${carte#"$DEPOT"/}"
  _clia_detail "pour la reprendre : clia extension install $provider"
  _clia_detail "rien n'est commité"
  return 0
}

# --------------------------------------------------------------------------
# Dispatch
# --------------------------------------------------------------------------

for _arg in "$@"; do
  [[ "$_arg" == '--man' ]] || continue
  manuel
  exit 0
done

VERBE="${1:-}"
[[ $# -gt 0 ]] && shift

case "$VERBE" in
  '')
    _clia_msg "clia extension attend un verbe"
    _clia_detail "l'usage : clia extension --help"
    exit 2 ;;

  add)
    (( $# == 1 )) || {
      _clia_msg "add attend une URI, et une seule"
      _clia_detail "l'usage : clia extension add URI"
      exit 2
    }
    ajouter "$1" ;;

  ls)
    (( $# == 0 )) || { _clia_msg "ls ne prend pas d'argument : $*"; exit 2; }
    lister ;;

  install)
    (( $# == 1 )) || {
      _clia_msg "install attend une extension, et une seule"
      _clia_detail "l'usage : clia extension install EXTENSION"
      exit 2
    }
    installer "$1" ;;

  uninstall)
    (( $# == 1 )) || {
      _clia_msg "uninstall attend une extension, et une seule"
      _clia_detail "l'usage : clia extension uninstall EXTENSION"
      exit 2
    }
    desinstaller "$1" ;;

  *)
    _clia_msg "verbe inconnu : $VERBE"
    _clia_detail "l'usage : clia extension --help"
    exit 2 ;;
esac
