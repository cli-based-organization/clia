#!/usr/bin/env bash
# _scripts/tests/test_zone.sh — les zones, et ce qui les rend.
#
# Éprouve SES-001 tâche 21 : une zone est un endroit où une ressource écrit,
# la ressource la déclare, et « clia config ls » dit ce qui règle le dépôt.
#
# Ce que le banc mesure, et qui n'irait pas de soi :
#
#   une zone déclarée par une ressource installée est suivie. C'est tout
#   l'énoncé de la tâche : la ressource contrôle l'endroit où elle génère ;
#
#   la variable se déduit du nom, et la déduction porte les tirets ;
#
#   l'environnement l'emporte sur la déclaration, et la déclaration sur
#   l'amorce du noyau. Trois sources, un ordre, et « config ls » le dit ;
#
#   déplacer CLIA_ZONE_RESSOURCE déplace vraiment où les instances sont
#   cherchées. Une zone qui ne serait qu'affichée ne serait pas une zone ;
#
#   la zone livrée ne se déclare pas : il faut la connaître pour lire une
#   déclaration. Une ressource qui la déclarerait n'est pas suivie.

set -uo pipefail

RACINE=$(cd -P "$(dirname "${BASH_SOURCE[0]}")/../.." && pwd)
CLIA="$RACINE/_scripts/bin/clia"

# shellcheck source=banc.sh
. "$RACINE/_scripts/tests/banc.sh"

BAC=$(mktemp -d)
trap 'rm -rf "$BAC"' EXIT

export XDG_CACHE_HOME="$BAC/cache"

INST='.dev/ressources'
LIVREE='.clia/ressources'

REEL_ETAT=$(git -C "$RACINE" status --porcelain | sort)

# --------------------------------------------------------------------------
# Outils
# --------------------------------------------------------------------------

git_() { git -C "$1" -c user.email=banc@example.invalid -c user.name=banc "${@:2}"; }

sortie() { local d="$1"; shift; ( cd "$d" && "$CLIA" "$@" 2>/dev/null ); }

rc_dans() {
  local titre="$1" attendu="$2" d="$3"; shift 3
  local reel
  SORTIE=$( ( cd "$d" && "$CLIA" "$@" ) 2>&1 ); reel=$?
  if (( reel == attendu )); then
    ok "$titre"
  else
    echec "$titre" "code $reel, attendu $attendu — $(printf '%s' "$SORTIE" | tr '\n' '|' | cut -c1-160)"
  fi
}

# rc_env TITRE ATTENDU DEPOT "VAR=VAL …" ARGS…
rc_env() {
  local titre="$1" attendu="$2" d="$3" reglages="$4"; shift 4
  local reel
  # shellcheck disable=SC2086
  SORTIE=$( ( cd "$d" && env $reglages "$CLIA" "$@" ) 2>&1 ); reel=$?
  if (( reel == attendu )); then
    ok "$titre"
  else
    echec "$titre" "code $reel, attendu $attendu — $(printf '%s' "$SORTIE" | tr '\n' '|' | cut -c1-160)"
  fi
}

# Une ressource installée, avec le bloc de zones qu'on lui donne.
installer_ressource() {
  local depot="$1" nom="$2" prefixe="$3" commande="$4" zones="$5"
  local dir="$depot/$LIVREE/$nom"
  mkdir -p "$dir/_scripts"
  { cat <<YAML
nom: $nom
titre: $nom
prefixe: $prefixe
version: 0.1.0

description: "Une ressource de banc."
YAML
    [[ -n "$zones" ]] && printf '\n%s\n' "$zones"
  } > "$dir/$nom.yaml"
  cat > "$dir/_scripts/$commande.sh" <<SH
#!/usr/bin/env bash
# Description: Une ressource de banc.
# Périmètre: dépôt
# Signature: $commande dis
set -euo pipefail
printf 'un\n'
SH
}

# Un dépôt clia minimal.
depot() {
  local d="$BAC/$1"
  mkdir -p "$d/$INST" "$d/$LIVREE"
  git -C "$d" init -q
  printf 'namespace: exemple.test/%s\nversion: 1.0.0\n' "$1" > "$d/clia.yaml"
  git_ "$d" add -A >/dev/null
  git_ "$d" commit -q -m 'un dépôt de banc'
  printf '%s\n' "$d"
}

# ==========================================================================
titre 'La commande est trouvée, et documentée'
# ==========================================================================

SORTIE=$("$CLIA" --help 2>/dev/null)
dit 'config figure parmi les commandes du noyau' '^  config '
dit 'et dit ce qu elle fait' 'config .*zones'

rc 'clia config --help repond' 0 "$CLIA" config --help
dit 'et donne sa signature' 'clia config ls'

rc 'clia config ls --help porte son option' 0 "$CLIA" config ls --help
dit 'et l option y est' '^  --explain$'

rc 'le manuel de la commande repond' 0 "$CLIA" config --man
dit 'il nomme la commande' 'clia-config'
dit 'il dit comment la variable se deduit du nom' 'CLIA_ZONE_, puis le nom en'
dit 'et il dit ce qu est l amorce' '^AMORCE$'

rc 'le manuel de clia parle des zones' 0 "$CLIA" --man
dit 'sous une entree generique' 'CLIA_ZONE_<NOM>'
dit 'et renvoie vers config ls' 'clia config ls'

# ==========================================================================
titre 'Ce que clia config ls rend'
# ==========================================================================

D=$(depot nu)
rc_dans 'clia config ls est satisfaite' 0 "$D" config ls
dit 'l en-tete nomme les colonnes' '^NATURE .*VARIABLE .*SOURCE .*FOURNIE PAR .*VALEUR$'
dit 'la zone livree y est' '^zone .*CLIA_ZONE_RESSOURCE_LIVREE .*\.clia/ressources$'
dit 'la zone des instances aussi' '^zone .*CLIA_ZONE_RESSOURCE .*\.dev/ressources$'
dit 'la politique de conformite y est' '^politique .*CLIA_POLICY_ROLLING_RESSOURCE .*false$'
dit 'et ce que clia pose lui-meme' '^posée .*CLIA_SOURCE_DIR .*clia '
# La ressource « ressource » que le CLI porte déclare la zone des instances :
# c'est elle qui la fournit, même dans un dépôt qui n'a rien installé.
dit 'la zone des instances vient de la ressource qui la declare' \
  'CLIA_ZONE_RESSOURCE  *défaut  *ressource'

rc_dans 'clia config ls --explain est satisfaite' 0 "$D" config ls --explain
dit 'chaque variable dit ce qu elle regle' '^       règle    '
dit 'et d ou sa valeur vient' '^       source   défaut, fournie par noyau$'
dit 'ce que clia pose est dit sans effet' "posée par clia — la régler n'a aucun effet"

rc_dans 'un verbe inconnu est mal forme' 2 "$D" config bidule
dit 'et clia le nomme' 'verbe inconnu : bidule'
rc_dans 'sans verbe, clia le demande' 2 "$D" config
dit 'et dit lequel' 'clia config ls'
rc_dans 'une option inconnue est mal formee' 2 "$D" config ls --bidule

# ==========================================================================
titre 'Une ressource déclare sa zone'
# ==========================================================================

Z=$(depot declaree)
installer_ressource "$Z" atelier ATL atl "zones:
  - nom: atelier
    defaut: .dev/atelier
    description: \"où l'atelier écrit ce qu'il produit\""

rc_dans 'la zone declaree figure dans config ls' 0 "$Z" config ls
dit 'sous la variable deduite de son nom' '^zone .*CLIA_ZONE_ATELIER '
dit 'a l emplacement qu elle declare' 'CLIA_ZONE_ATELIER .*\.dev/atelier$'
dit 'et clia nomme la ressource qui la fournit' 'CLIA_ZONE_ATELIER .*défaut .*atelier '

SORTIE=$(sortie "$Z" config ls --explain)
dit 'et --explain rend sa description' "où l'atelier écrit ce qu'il produit"

# Un tiret dans le nom devient un souligné dans la variable.
T=$(depot tiret)
installer_ressource "$T" carnet CRN crn "zones:
  - nom: bloc-notes
    defaut: .dev/bloc-notes
    description: \"le bloc-notes du dépôt\""
SORTIE=$(sortie "$T" config ls)
dit 'un tiret du nom devient un souligne' '^zone .*CLIA_ZONE_BLOC_NOTES .*\.dev/bloc-notes$'

# ==========================================================================
titre 'Trois sources, et leur ordre'
# ==========================================================================

rc_env "l environnement l emporte sur la declaration" 0 "$Z" \
  CLIA_ZONE_ATELIER=ailleurs/atelier config ls
dit 'la valeur est celle de l environnement' 'CLIA_ZONE_ATELIER .*ailleurs/atelier$'
dit 'et clia dit d ou elle vient' 'CLIA_ZONE_ATELIER *environnement'

SORTIE=$(sortie "$Z" config ls)
dit 'sans reglage, la declaration tient' 'CLIA_ZONE_ATELIER .*défaut .*atelier .*\.dev/atelier$'

# La zone des instances aussi se déclare : le noyau n'a le dernier mot qu'en
# l'absence de déclaration.
#
# La zone livrée est déplacée pour l'occasion, et cela mesure deux choses à
# la fois : que la variable la déplace, et que le dépôt de banc est alors
# seul à déclarer — les ressources du dépôt source de clia, rangées ailleurs,
# ne sont plus trouvées, et ne masquent donc plus celle du banc.
R=$(depot fournie)
LIVREE='.clia/ateliers'
installer_ressource "$R" ressource RES res "zones:
  - nom: ressource
    defaut: atelier/ressources
    description: \"ce que le dépôt écrit d'une ressource\""
LIVREE='.clia/ressources'

rc_env 'declaree, la zone des instances vient de la ressource' 0 "$R" \
  'CLIA_ZONE_RESSOURCE_LIVREE=.clia/ateliers' config ls
dit 'et clia nomme celle qui la fournit' 'CLIA_ZONE_RESSOURCE  *défaut  *ressource '
dit 'a l emplacement qu elle declare' 'CLIA_ZONE_RESSOURCE  *défaut  *ressource  *atelier/ressources$'
ne_dit_pas 'le noyau ne la fournit plus' 'CLIA_ZONE_RESSOURCE  *défaut  *noyau'
dit 'et la zone livree deplacee se voit' \
  'CLIA_ZONE_RESSOURCE_LIVREE  *environnement  *noyau  *\.clia/ateliers$'

# ==========================================================================
titre 'La zone livrée ne se déclare pas'
# ==========================================================================

L=$(depot amorce)
installer_ressource "$L" pirate PIR pir "zones:
  - nom: ressource-livree
    defaut: ailleurs/installees
    description: \"une déclaration que clia ne suit pas\""
SORTIE=$(sortie "$L" config ls)
dit 'la zone livree reste celle du noyau' \
  'CLIA_ZONE_RESSOURCE_LIVREE  *défaut  *noyau  *\.clia/ressources$'
ne_dit_pas 'et la declaration n est pas suivie' 'ailleurs/installees'

# ==========================================================================
titre 'Une zone déplacée déplace vraiment'
# ==========================================================================

M=$(depot deplacee)
mkdir -p "$M/atelier/RES-001-outil/livrables" "$M/atelier/RES-001-outil/primitive-1"
cat > "$M/atelier/RES-001-outil/livrables/outil.yaml" <<'YAML'
nom: outil
titre: Outil
prefixe: OUT
version: 0.1.0

description: "Une ressource rangée ailleurs."
YAML
git_ "$M" add -A >/dev/null; git_ "$M" commit -q -m 'une instance hors de la zone par défaut'

SORTIE=$(sortie "$M" res ls)
ne_dit_pas 'hors de la zone, l instance est invisible' 'outil'

rc_env 'la zone deplacee rend l instance visible' 0 "$M" \
  CLIA_ZONE_RESSOURCE=atelier res ls
dit 'et clia la dit ecrite ici' 'outil .*0\.1\.0 .*écrite'

# ==========================================================================
titre 'Ce que la commande ne fait pas'
# ==========================================================================

rc 'config ls n ecrit rien' 0 "$CLIA" config ls
vrai 'le depot reel n a pas bouge' \
  test "$(git -C "$RACINE" status --porcelain | sort)" = "$REEL_ETAT"

bilan
