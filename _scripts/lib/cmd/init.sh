#!/usr/bin/env bash
# Description: Crée ou instrumente un dépôt — son état, et ses harnais IA.
# Périmètre: aucun
# Signature: init [REPO_PATH]
#
# Implémente SES-001 tâche 6.
#
# Post-conditions, telles que la tâche les pose : REPO_PATH est un dépôt git,
# CLAUDE.md existe, CONSTITUTION.md existe. Le fichier d'état est posé avec,
# sans quoi le dépôt ne déclarerait pas ce qu'il est.
#
# Pourquoi « aucun » périmètre. Cette commande crée le dépôt sur lequel les
# autres travailleront : exiger d'être déjà dans un dépôt git la rendrait
# incapable de faire ce pour quoi elle existe. Elle reçoit sa cible en
# argument, il n'y a donc pas de dépôt atteint par mégarde.
#
# Ce qui existe n'est jamais écrasé
# ---------------------------------
#
# Chaque fichier est posé s'il est absent, et laissé s'il est là. Un dépôt
# qui a adapté son harnais ne le perd pas en relançant la commande, et
# relancer est donc sans conséquence — la seconde fois ne fait rien.
#
# Rien n'est commité. Créer n'est pas décider d'inscrire dans l'historique,
# et cette décision appartient à l'humain.

set -euo pipefail

_CLIA_NOM='clia'
# shellcheck source=../commun.sh
. "$CLIA_SOURCE_DIR/_scripts/lib/commun.sh"

# --------------------------------------------------------------------------

manuel() {
  cat <<'FIN' | _clia_man clia-init 1 "Manuel de l'utilisateur clia"
NOM
clia-init - créer un dépôt clia, ou instrumenter un dépôt existant

SYNOPSIS
clia init [REPO_PATH]

DESCRIPTION
Rend un dépôt capable de gérer des ressources informationnelles et
des livrables avec le système clia.

REPO_PATH vaut le répertoire courant par défaut. S'il n'existe pas,
il est créé. S'il n'est pas un dépôt git, il le devient.

Trois choses y sont posées, et seulement si elles manquent : le
fichier d'état, le harnais IA principal, et le harnais
constitutionnel qui dit les rôles et les permissions de chaque
intervenant.

Les harnais ne sont pas énumérés par cette commande : ce sont les
primitives de la ressource harness-ia, et clia les trouve. Ajouter
un harnais se fait en déposant un fichier dans ses primitives.

CE QUI EST POSE
clia.yaml
       La carte du dépôt : son namespace et sa version. Le namespace
       est posé à compléter, jamais deviné — il désigne la
       provenance de tout ce que le dépôt publie, et une provenance
       fausse serait invisible.

CLAUDE.md
       Le harnais IA principal : comment travailler dans ce dépôt.

CONSTITUTION.md
       Les rôles et les permissions des humains, des automatismes et
       des agents IA. Elle prime sur le harnais principal.

CE QUI N'EST PAS FAIT
Rien n'est écrasé. Un fichier déjà présent est laissé tel quel et
signalé ; relancer la commande est donc sans conséquence.

Rien n'est commité. Inscrire dans l'historique est une décision, et
elle appartient à l'humain.

Un REPO_PATH situé à l'intérieur d'un dépôt git sans en être la
racine est refusé : y créer un dépôt imbriqué serait un piège, et
instrumenter le dépôt englobant à la place ne serait pas ce qui a
été demandé.

CODE DE RETOUR
0
       La demande est satisfaite, même s'il n'y avait rien à poser.

1
       Refus : cible imbriquée dans un dépôt, ou geste en échec.

2
       Demande mal formée.

EXEMPLES
Instrumenter le dépôt courant :

       $ clia init .

Créer un dépôt neuf, et l'instrumenter :

       $ clia init ~/git/mon-projet

Puis vérifier :

       $ clia check

VOIR AUSSI
clia(1), clia-check(1), clia-setup(1)
FIN
}

# --------------------------------------------------------------------------
# La carte posée dans un dépôt neuf
# --------------------------------------------------------------------------
#
# Le namespace n'est pas deviné. Le nom du dépôt, lui, n'est pas une
# supposition — c'est le nom du répertoire ; seul le publisher reste à dire,
# et il reste visible comme tel.

poser_carte() {
  local cible="$1" nom
  nom=$(basename "$cible")
  cat > "$cible/clia.yaml" <<FIN
# La carte de ce dépôt clia : ce qu'il est.
#
# Le namespace désigne la provenance de tout ce que ce dépôt publie. clia ne
# le devine pas : remplacez <publisher> par qui publie.

namespace: <publisher>/$nom
version: 0.1.0
FIN
}

# --------------------------------------------------------------------------

POSES=0
LAISSES=0

poser() {
  local source="$1" destination="$2" nom="$3"
  if [[ -e "$destination" ]]; then
    _clia_detail "laissé   $nom (déjà présent)"
    LAISSES=$((LAISSES + 1))
    return 0
  fi
  cp "$source" "$destination"
  _clia_detail "posé     $nom"
  POSES=$((POSES + 1))
}

# --------------------------------------------------------------------------
# Dispatch
# --------------------------------------------------------------------------

for _arg in "$@"; do
  [[ "$_arg" == '--man' ]] || continue
  manuel
  exit 0
done

if (( $# > 1 )); then
  _clia_msg "init n'attend qu'un chemin : $*"
  _clia_detail "l'usage : clia init [REPO_PATH]"
  exit 2
fi

DEMANDE="${1:-.}"
case "$DEMANDE" in
  -*) _clia_msg "option inconnue pour init : $DEMANDE"
      _clia_detail "l'usage : clia init --help"
      exit 2 ;;
esac

# --------------------------------------------------------------------------
# La cible
# --------------------------------------------------------------------------

if [[ ! -e "$DEMANDE" ]]; then
  mkdir -p "$DEMANDE" || {
    _clia_msg "ce répertoire n'a pas pu être créé : $DEMANDE"
    exit 1
  }
  _clia_msg "répertoire créé : $DEMANDE"
elif [[ ! -d "$DEMANDE" ]]; then
  _clia_msg "ce n'est pas un répertoire : $DEMANDE"
  exit 1
fi

CIBLE=$(cd -P "$DEMANDE" && pwd)

if [[ ! -d "$CIBLE/.git" ]]; then
  # Un dépôt imbriqué serait un piège : deux historiques pour un même arbre,
  # et le fichier du dessous invisible à celui du dessus.
  if ENGLOBANT=$(_clia_depot_git "$CIBLE") && [[ -n "$ENGLOBANT" ]]; then
    _clia_msg "cette cible est à l'intérieur d'un dépôt git, sans en être la racine"
    _clia_detail "racine : $ENGLOBANT"
    _clia_detail "cible  : $CIBLE"
    _clia_detail "instrumentez la racine, ou choisissez une cible hors de ce dépôt"
    exit 1
  fi
  git -C "$CIBLE" init -q || {
    _clia_msg "git init a échoué dans $CIBLE"
    exit 1
  }
  _clia_msg "dépôt git initialisé : $CIBLE"
fi

# --------------------------------------------------------------------------
# Ce qui est posé
# --------------------------------------------------------------------------

_clia_msg "instrumentation de $CIBLE"

if CARTE=$(_clia_carte_relative "$CIBLE"); then
  _clia_detail "laissé   $CARTE (déjà présent)"
  LAISSES=$((LAISSES + 1))
else
  poser_carte "$CIBLE"
  _clia_detail "posé     clia.yaml"
  POSES=$((POSES + 1))
fi

NB_HARNAIS=0
while IFS=$'\t' read -r NOM PRIMITIVE; do
  [[ -n "$NOM" ]] || continue
  NB_HARNAIS=$((NB_HARNAIS + 1))
  poser "$PRIMITIVE" "$CIBLE/$NOM" "$NOM"
done < <(_clia_harnais_offerts)

if (( NB_HARNAIS == 0 )); then
  _clia_msg "clia n'offre aucun harnais : rien n'a été posé de ce côté"
  _clia_detail "l'installation de clia est-elle complète ?"
  exit 1
fi

_clia_detail ''
_clia_detail "$POSES posé(s), $LAISSES laissé(s) tel(s) quel(s)"
_clia_detail "rien n'est commité : inscrire dans l'historique reste votre décision"
_clia_detail "pour vérifier : clia check"
