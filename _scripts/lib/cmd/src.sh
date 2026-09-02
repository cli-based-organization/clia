#!/usr/bin/env bash
# Description: Les sources du dépôt — d'où viennent les ressources.
# Périmètre: dépôt
# Signature: src ls
#
# Implémente SES-001 tâche 10.
#
# Ce qu'est une source
# --------------------
#
# Une source est un dépôt d'où viennent des ressources. La carte du dépôt de
# travail les déclare, une par entrée :
#
#   sources:
#     - provider: session.clia.noumanity.com
#       type: local
#       uri: ../clia-session
#
# Deux natures, et l'énoncé de la tâche 10 les distingue : une source peut
# être un dépôt clia, ou un dépôt ordinaire. Un dépôt clia porte une carte, et
# c'est elle qui dit quel namespace ses ressources portent.
#
# Une extension est une source dont on tire des ressources. Elle doit donc
# être un dépôt clia : une ressource dont la provenance n'est pas déclarée
# n'est pas identifiable, et CONSTITUTION.md R2 interdit à l'automatisme de
# deviner une provenance.
#
# Pourquoi cette commande ne fait que constater
# ---------------------------------------------
#
# Déclarer une source, c'est rendre exécutable du code qui vient d'ailleurs.
# Ce geste appartient à l'humain, qui l'écrit dans la carte de son propre
# dépôt. clia ne fouille pas le disque à la recherche de dépôts voisins, et
# n'ajoute jamais une source de lui-même.
#
# Ce que cette commande rend, c'est ce que la déclaration donne réellement :
# la source est-elle là, est-elle un dépôt clia, que porte-t-elle. Une
# déclaration qui ne mène à rien se voit ici plutôt qu'à l'usage.

set -euo pipefail

_CLIA_NOM='clia'
# shellcheck source=../commun.sh
. "$CLIA_SOURCE_DIR/_scripts/lib/commun.sh"

DEPOT="${CLIA_WORK_DIR:-}"

# --------------------------------------------------------------------------

manuel() {
  cat <<'EOF' | _clia_man clia-src 1 "Manuel de l'utilisateur clia"
NOM
clia-src - les sources d'un dépôt, et ce qu'elles apportent

SYNOPSIS
clia src ls

DESCRIPTION
Une source est un dépôt d'où viennent des ressources. La carte du
dépôt de travail les déclare ; rien d'autre ne les déclare.

Une source est de l'une de deux natures. Un dépôt clia porte une
carte, et sa carte dit le namespace de ce qu'il publie. Un dépôt
ordinaire n'en porte pas : clia peut en tirer des fichiers, non des
ressources.

Une extension est une source dont on tire des ressources. Elle doit
être un dépôt clia, et porter un répertoire _ressources. Ses
ressources apportent leurs commandes : elles paraissent dans
clia --help au même titre que celles du noyau, sans qu'aucun
fichier du dépôt source ait changé.

Le noyau l'emporte toujours, puis les ressources du CLI, puis les
extensions. Une extension ajoute ; elle ne remplace pas.

Déclarer une source rend exécutable du code venu d'ailleurs. C'est
pourquoi clia ne fouille pas le disque et n'ajoute jamais une
source : la déclaration est écrite à la main, dans la carte du
dépôt qui l'accepte.

SOUS-COMMANDES
ls
       Les sources déclarées, ce qu'elles sont, et ce qu'elles
       portent. Une source déclarée qui ne mène à rien s'y voit.

       L'état d'une source est constaté, non déclaré :

       extension     dépôt clia, avec des ressources
       dépôt clia    dépôt clia, sans répertoire _ressources
       dépôt         présent, mais sans carte clia
       absente       l'uri ne mène à aucun répertoire
       type inconnu  un type que clia ne sait pas atteindre

       Le namespace trouvé dans la carte de la source est confronté
       au provider déclaré. Un écart est signalé : il rendrait
       fausses les identités des ressources tirées de là.

CHAMPS D UNE SOURCE
provider
       Qui publie. C'est le début du namespace des ressources que la
       source apporte.

type
       Comment l'atteindre. « local » est le seul type que clia
       tienne aujourd'hui ; un autre est signalé et laissé de côté.

uri
       Où elle est. Pour une source locale, un chemin relatif à la
       racine du dépôt qui la déclare, ou un chemin absolu.

SORTIE
La sortie standard porte une ligne d'en-tête et une ligne par
source. Tout le reste va sur la sortie d'erreur.

CODE DE RETOUR
0
       La demande est satisfaite, même si le dépôt ne déclare
       aucune source.

1
       Refus.

2
       Demande mal formée.

FICHIERS
clia.yaml, .clia.yaml, .dev/clia.yaml
       La carte du dépôt. Son bloc « sources: » est la seule
       déclaration que clia lise pour atteindre un autre dépôt.

<source>/_ressources/*/_scripts/*.sh
       Les commandes qu'une extension apporte.

EXEMPLES
Voir d'où viennent les ressources :

       $ clia src ls
       PROVIDER                    TYPE   URI              ETAT
       session.clia.noumanity.com  local  ../clia-session  extension

VOIR AUSSI
clia(1), clia-res(1), clia-check(1)
EOF
}

# --------------------------------------------------------------------------
# Ce qu'une source est, une fois constatée
# --------------------------------------------------------------------------

# Les préfixes des ressources d'un dépôt, séparés par des espaces.
prefixes_de() {
  local racine="$1" def nom prefixe liste=''
  for def in "$racine"/_ressources/*/*.yaml; do
    [[ -f "$def" ]] || continue
    nom=$(basename "$(dirname "$def")")
    [[ "$(basename "$def")" == "$nom.yaml" ]] || continue
    prefixe=$(_clia_champ_yaml "$def" prefixe || printf '')
    [[ -n "$prefixe" ]] || prefixe="($nom)"
    liste="${liste:+$liste }$prefixe"
  done
  printf '%s\n' "$liste"
}

# etat_de <type> <racine|vide> — l'état, constaté.
etat_de() {
  local type="$1" racine="$2"
  if [[ -n "$type" && "$type" != 'local' ]]; then
    printf 'type inconnu\n'; return 0
  fi
  [[ -n "$racine" ]] || { printf 'absente\n'; return 0; }
  if ! _clia_carte_relative "$racine" >/dev/null; then
    printf 'dépôt\n'; return 0
  fi
  if [[ -d "$racine/_ressources" ]]; then
    printf 'extension\n'
  else
    printf 'dépôt clia\n'
  fi
}

# --------------------------------------------------------------------------
# ls
# --------------------------------------------------------------------------

lister() {
  local provider type uri racine etat prefixes carte ns
  local lignes='' ecarts=''

  if [[ -z "$(_clia_sources "$DEPOT")" ]]; then
    _clia_msg "ce dépôt ne déclare aucune source"
    _clia_detail "déclarez-les dans le bloc « sources: » de sa carte"
    _clia_detail "le format : clia src --man"
    return 0
  fi

  while IFS=$'\t' read -r provider type uri; do
    [[ -n "$provider" ]] || continue
    racine=$(_clia_source_racine "$DEPOT" "$uri" 2>/dev/null) || racine=''
    etat=$(etat_de "$type" "$racine")

    prefixes=''
    if [[ "$etat" == 'extension' ]]; then
      prefixes=$(prefixes_de "$racine")
    fi

    # Le namespace d'un dépôt clia est confronté au provider déclaré. Un
    # écart rendrait fausses les identités des ressources tirées de là ;
    # clia le signale, et ne corrige ni l'un ni l'autre.
    if [[ "$etat" == 'extension' || "$etat" == 'dépôt clia' ]]; then
      carte=$(_clia_carte "$racine") && ns=$(_clia_champ_yaml "$carte" namespace || printf '')
      if [[ -n "$ns" && "$ns" != "$provider" && "$ns" != "$provider"/* ]]; then
        ecarts+="$provider	$ns"$'\n'
      fi
    fi

    lignes+=$(printf '%s\t%s\t%s\t%s\t%s' \
      "$provider" "${type:-—}" "${uri:-—}" "$etat" "${prefixes:-—}")$'\n'
  done < <(_clia_sources "$DEPOT")

  { printf 'PROVIDER\tTYPE\tURI\tETAT\tRESSOURCES\n'
    printf '%s' "$lignes"
  } | column -t -s $'\t'

  while IFS=$'\t' read -r provider ns; do
    [[ -n "$provider" ]] || continue
    _clia_msg "$provider : la carte de la source déclare le namespace $ns"
    _clia_detail "le provider déclaré et le namespace trouvé ne concordent pas"
  done <<<"$ecarts"

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
    _clia_msg "clia src attend un verbe"
    _clia_detail "l'usage : clia src --help"
    exit 2 ;;

  ls)
    (( $# == 0 )) || { _clia_msg "ls ne prend pas d'argument : $*"; exit 2; }
    lister ;;

  *)
    _clia_msg "verbe inconnu : $VERBE"
    _clia_detail "l'usage : clia src --help"
    exit 2 ;;
esac
