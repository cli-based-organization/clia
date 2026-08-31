#!/usr/bin/env bash
# Description: La conformité du dépôt — son état, et ses harnais IA.
# Périmètre: dépôt
# Signature: check
# Signature: check --harness
# Option: check --harness
#
# Implémente SES-001 tâche 6.
#
# Ce qu'est un dépôt clia, et donc ce qui est vérifié
# ---------------------------------------------------
#
# Un dépôt clia est un dépôt capable de gérer des ressources
# informationnelles et des livrables avec le système clia. Le minimum pour
# l'être, posé par la tâche 6 :
#
#   un fichier d'état      clia.yaml, .clia.yaml ou .dev/clia.yaml
#   un harnais IA principal    CLAUDE.md
#   un harnais constitutionnel CONSTITUTION.md
#
# Les deux derniers ne sont pas énumérés ici : ce sont les primitives de la
# ressource harness-ia, et clia les trouve. Ajouter un harnais se fait en
# déposant un fichier dans ses primitives, non en modifiant cette commande.
#
# Constater n'est pas réparer
# ---------------------------
#
# Cette commande n'écrit rien. Elle nomme chaque écart et la commande qui le
# solderait — clia init pose ce qui manque. Un constat qui écrirait serait un
# constat auquel on n'oserait pas se fier.

set -euo pipefail

_CLIA_NOM='clia'
# shellcheck source=../commun.sh
. "$CLIA_SOURCE_DIR/_scripts/lib/commun.sh"

DEPOT="${CLIA_WORK_DIR:-}"

# --------------------------------------------------------------------------

manuel() {
  cat <<'FIN' | _clia_man clia-check 1 "Manuel de l'utilisateur clia"
NOM
clia-check - vérifier la conformité d'un dépôt clia

SYNOPSIS
clia check
clia check --harness

DESCRIPTION
Un dépôt clia est un dépôt capable de gérer des ressources
informationnelles et des livrables avec le système clia.

Pour l'être, il lui faut au minimum un fichier d'état, un harnais IA
principal, et un harnais constitutionnel qui dit les rôles et les
permissions de chaque intervenant : humains, automatismes et agents.

Cette commande constate. Elle n'écrit rien, et nomme pour chaque
écart la commande qui le solderait.

CONTROLES
E1  le dépôt porte un fichier d'état
       Cherché à clia.yaml, .clia.yaml puis .dev/clia.yaml. Le
       premier trouvé l'emporte. Son absence est bloquante : sans
       lui, le dépôt ne déclare pas ce qu'il est.

E2  l'état déclare un namespace et une version
       Le namespace désigne la provenance de ce que le dépôt
       publie ; la version, où il en est. Un namespace laissé à
       compléter est signalé sans être bloquant : clia ne le devine
       pas, et personne ne peut le deviner à la place de l'humain.

H1, H2, …  chaque harnais offert est installé
       Un contrôle par primitive de la ressource harness-ia. Un
       harnais absent est bloquant.

       Un harnais présent mais différent de la primitive dont il
       vient est signalé, non reproché : le dépôt a pu l'adapter, ou
       clia a pu avancer. Ce qui compte est que la divergence se
       voie.

OPTIONS
--harness
       N'exécuter que les contrôles de harnais, et détailler ce qui
       ne va pas. Les contrôles d'état ne sont pas rendus.

SORTIE
Un en-tête nommant le dépôt, son namespace et sa version, puis une
ligne par contrôle : son identifiant, son verdict, et ce qu'il dit.

Un verdict « ok » ne demande rien. Un verdict « !! » est un écart
bloquant. Un verdict « -- » signale sans bloquer.

CODE DE RETOUR
0
       Conforme, ou seulement des signalements.

1
       Au moins un écart bloquant.

2
       Demande mal formée.

EXEMPLES
Vérifier le dépôt courant :

       $ clia check
       E1  ok  le dépôt porte son état : clia.yaml
       E2  ok  namespace et version sont déclarés
       H1  ok  CLAUDE.md
       H2  ok  CONSTITUTION.md

       clia: conforme

Ne regarder que les harnais :

       $ clia check --harness

VOIR AUSSI
clia(1), clia-init(1), clia-res(1)
FIN
}

# --------------------------------------------------------------------------
# Les contrôles
# --------------------------------------------------------------------------

BLOQUANTS=0
SIGNALEMENTS=0

# verdict <identifiant> <ok|bloquant|signalement> <ce qu'il dit>
verdict() {
  local id="$1" nature="$2" texte="$3" marque
  case "$nature" in
    ok)          marque='ok' ;;
    bloquant)    marque='!!'; BLOQUANTS=$((BLOQUANTS + 1)) ;;
    signalement) marque='--'; SIGNALEMENTS=$((SIGNALEMENTS + 1)) ;;
  esac
  printf '%-3s %-2s  %s\n' "$id" "$marque" "$texte"
}

# clia init pose le namespace avec une invite visible, qu'il revient à
# l'humain de compléter. Les chevrons la signalent.
namespace_est_une_invite() { [[ "$1" == *'<'* ]]; }

controles_etat() {
  local relative ns version

  if ! relative=$(_clia_carte_relative "$DEPOT"); then
    verdict E1 bloquant "aucun fichier d'état — ${_CLIA_CARTE_EMPLACEMENTS[*]}"
    verdict E2 bloquant "namespace et version sont donc introuvables"
    return 0
  fi
  verdict E1 ok "le dépôt porte son état : $relative"

  ns=$(_clia_champ_yaml "$DEPOT/$relative" namespace || printf '')
  version=$(_clia_champ_yaml "$DEPOT/$relative" version || printf '')

  if [[ -z "$ns" || -z "$version" ]]; then
    verdict E2 bloquant "$relative ne déclare pas $(
      [[ -z "$ns" ]] && printf 'de namespace'
      [[ -z "$ns" && -z "$version" ]] && printf ' ni '
      [[ -z "$version" ]] && printf 'de version')"
  elif namespace_est_une_invite "$ns"; then
    verdict E2 signalement "le namespace est à compléter dans $relative"
  else
    verdict E2 ok "namespace et version sont déclarés"
  fi
}

controles_harnais() {
  local n i=0 nom primitive

  n=$(_clia_harnais_offerts | wc -l)
  if (( n == 0 )); then
    verdict H1 bloquant "clia n'offre aucun harnais — installation incomplète ?"
    return 0
  fi

  while IFS=$'\t' read -r nom primitive; do
    [[ -n "$nom" ]] || continue
    i=$((i + 1))
    if [[ ! -f "$DEPOT/$nom" ]]; then
      verdict "H$i" bloquant "$nom est absent"
    elif ! cmp -s "$DEPOT/$nom" "$primitive"; then
      verdict "H$i" signalement "$nom diffère de la primitive dont il vient"
    else
      verdict "H$i" ok "$nom"
    fi
  done < <(_clia_harnais_offerts)
}

# --------------------------------------------------------------------------
# Rapport
# --------------------------------------------------------------------------

entete() {
  local relative ns version
  printf 'dépôt      %s\n' "$DEPOT"
  if relative=$(_clia_carte_relative "$DEPOT"); then
    ns=$(_clia_champ_yaml "$DEPOT/$relative" namespace || printf '—')
    version=$(_clia_champ_yaml "$DEPOT/$relative" version || printf '—')
    printf 'namespace  %s\n' "${ns:-—}"
    printf 'version    %s\n' "${version:-—}"
  fi
  printf '\n'
}

conclure() {
  if (( BLOQUANTS > 0 )); then
    _clia_msg "$BLOQUANTS écart(s) bloquant(s) : ce dépôt n'est pas conforme"
    _clia_detail "pour poser ce qui manque : clia init ."
    return 1
  fi
  if (( SIGNALEMENTS > 0 )); then
    _clia_msg "conforme, avec $SIGNALEMENTS signalement(s)"
    return 0
  fi
  _clia_msg 'conforme'
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

HARNAIS_SEUL=0
for arg in "$@"; do
  case "$arg" in
    --harness) HARNAIS_SEUL=1 ;;
    *) _clia_msg "argument inattendu : $arg"
       _clia_detail "l'usage : clia check --help"
       exit 2 ;;
  esac
done

entete
if (( HARNAIS_SEUL )); then
  controles_harnais
else
  controles_etat
  controles_harnais
fi
printf '\n'
conclure
