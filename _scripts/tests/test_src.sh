#!/usr/bin/env bash
# _scripts/tests/test_src.sh — les sources, et les extensions.
#
# Éprouve SES-001 tâche 10, côté noyau.
#
# Ce banc ne dépend d'aucun dépôt voisin. L'extension qu'il éprouve est
# fabriquée dans le bac : une extension réelle rendrait le résultat dépendant
# de ce qui est cloné à côté, et un banc qui passe ou échoue selon le contenu
# du disque ne mesure plus rien.
#
# Les deux propriétés qui comptent :
#
#   une extension déclarée en source apporte ses commandes, sans qu'aucun
#   fichier du dépôt source ait changé ;
#
#   elle ne peut masquer ni le noyau, ni les ressources du CLI. L'ordre de
#   fouille est une garantie, pas une habitude.

set -uo pipefail

RACINE=$(cd -P "$(dirname "${BASH_SOURCE[0]}")/../.." && pwd)
CLIA="$RACINE/_scripts/bin/clia"

# shellcheck source=banc.sh
. "$RACINE/_scripts/tests/banc.sh"

BAC=$(mktemp -d)
trap 'rm -rf "$BAC"' EXIT

REEL_ETAT=$(git -C "$RACINE" status --porcelain | sort)

# --------------------------------------------------------------------------
# Outils
# --------------------------------------------------------------------------

_TITRE_BLOC='^[A-Za-z]+ :$'
_ENTREE='^  [^ ]'

lignes_de_prose() {
  local ligne
  while IFS= read -r ligne; do
    [[ -z "$ligne" ]] && continue
    [[ "$ligne" =~ $_TITRE_BLOC ]] && continue
    [[ "$ligne" =~ $_ENTREE ]] && continue
    printf '%s\n' "$ligne"
  done
}

lignes_trop_longues() {
  local ligne
  while IFS= read -r ligne; do
    (( ${#ligne} > 80 )) && printf '%s\n' "$ligne"
  done
  return 0
}

depot() {
  local d="$BAC/$1"
  mkdir -p "$d"
  git -C "$d" init -q
  git -C "$d" config user.email 'banc@example.invalid'
  git -C "$d" config user.name 'banc'
  printf 'namespace: exemple.test/%s\nversion: 1.0.0\n' "$1" > "$d/clia.yaml"
  printf '%s\n' "$d"
}

dans() { local d="$1"; shift; ( cd "$d" && "$CLIA" "$@" ); }

rc_dans() {
  local titre="$1" attendu="$2" d="$3"; shift 3
  local reel
  SORTIE=$( ( cd "$d" && "$CLIA" "$@" ) 2>&1 ); reel=$?
  if (( reel == attendu )); then
    ok "$titre"
  else
    echec "$titre" "code $reel, attendu $attendu — $(printf '%s' "$SORTIE" | tr '\n' '|' | cut -c1-140)"
  fi
}

# Fabrique une extension : un dépôt clia portant une ressource et sa commande.
extension() {
  local d="$BAC/$1" prefixe="$2" nom="$3" commande
  commande=$(printf '%s' "$prefixe" | tr '[:upper:]' '[:lower:]')
  mkdir -p "$d/_ressources/$nom/_scripts"
  git -C "$d" init -q
  printf 'namespace: %s/%s\nversion: 0.1.0\n' "$4" "$1" > "$d/clia.yaml"
  cat > "$d/_ressources/$nom/$nom.yaml" <<YAML
nom: $nom
titre: ${nom^}
prefixe: $prefixe
version: 0.1.0

description: "Une ressource de banc."
YAML
  cat > "$d/_ressources/$nom/_scripts/$commande.sh" <<SH
#!/usr/bin/env bash
# Description: Une commande apportee par une extension de banc.
# Périmètre: aucun
# Signature: $commande dis
set -euo pipefail
printf '%s\n' "\${1:-rien}"
SH
  printf '%s\n' "$d"
}

# Écrit un bloc « sources: » dans la carte d'un dépôt.
declare_source() {
  local d="$1" provider="$2" type="$3" uri="$4"
  { printf '\nsources:\n'
    printf '  - provider: %s\n    type: %s\n    uri: %s\n' "$provider" "$type" "$uri"
  } >> "$d/clia.yaml"
}

# ==========================================================================
titre 'La commande est decouverte, et documentee'
# ==========================================================================

rc 'clia --help liste src' 0 "$CLIA" --help
dit 'la commande y figure' '^  src$'
dit 'et sa signature aussi' 'clia src ls'

rc 'clia src --help' 0 "$CLIA" src --help
RESTE=$("$CLIA" src --help 2>/dev/null | lignes_de_prose)
vrai 'et son aide ne porte aucune prose' test -z "$RESTE"
[[ -n "$RESTE" ]] && printf '         ligne fautive : %s\n' "$RESTE"

rc 'clia src --man' 0 "$CLIA" src --man
dit 'la page porte son nom' '^CLIA-SRC(1)'
for section in NOM SYNOPSIS DESCRIPTION SOUS-COMMANDES SORTIE \
               'CODE DE RETOUR' FICHIERS EXEMPLES 'VOIR AUSSI'; do
  dit "la section $section y est" "^$section\$"
done
LONGUES=$("$CLIA" src --man 2>/dev/null | lignes_trop_longues)
vrai 'aucune ligne du manuel ne depasse 80 colonnes' test -z "$LONGUES"
[[ -n "$LONGUES" ]] && printf '         ligne fautive : %s\n' "$LONGUES"

HORS="$BAC/hors-depot"; mkdir -p "$HORS"
rc 'le manuel repond hors d un depot' 0 bash -c "cd '$HORS' && '$CLIA' src --man"
rc 'mais le travail exige un depot' 1 bash -c "cd '$HORS' && '$CLIA' src ls"

# ==========================================================================
titre 'Ce que src ls constate'
# ==========================================================================

D=$(depot lecture)
rc_dans 'un depot sans source le dit' 0 "$D" src ls
dit 'et nomme ou les declarer' 'sources:'

EXT=$(extension ext-a SES session 'session.exemple.test')
NON_CLIA="$BAC/ordinaire"; mkdir -p "$NON_CLIA"; git -C "$NON_CLIA" init -q

declare_source "$D" 'session.exemple.test' local '../ext-a'
declare_source "$D" 'ordinaire.exemple.test' local '../ordinaire'
declare_source "$D" 'absente.exemple.test' local '../nulle-part'
declare_source "$D" 'distante.exemple.test' git 'https://exemple.test/x.git'

SORTIE=$(dans "$D" src ls 2>/dev/null)
dit 'l en-tete nomme les colonnes' '^PROVIDER *TYPE *URI *ETAT *RESSOURCES$'
dit 'un depot clia avec des ressources est une extension' 'session.exemple.test *local *\.\./ext-a *extension *SES'
dit 'un depot sans carte clia est un depot ordinaire' 'ordinaire.exemple.test *local *\.\./ordinaire *dépôt *—'
dit 'une uri qui ne mene nulle part est absente' 'absente.exemple.test .*absente'
dit 'un type que clia ne sait pas atteindre est signale' 'distante.exemple.test .*type inconnu'

# Un dépôt clia sans _ressources n'est pas une extension.
SANS_RES=$(depot sans-ressources)
declare_source "$D" 'nu.exemple.test' local '../sans-ressources'
SORTIE=$(dans "$D" src ls 2>/dev/null)
dit 'un depot clia sans ressources n est pas une extension' 'nu.exemple.test .*dépôt clia'

# L'écart entre le provider déclaré et le namespace trouvé.
MAL=$(extension ext-mal ANL analyse 'autre.exemple.test')
declare_source "$D" 'attendu.exemple.test' local '../ext-mal'
rc_dans 'un namespace qui ne concorde pas est signale' 0 "$D" src ls
dit 'et clia nomme le namespace trouve' 'autre.exemple.test/ext-mal'
dit 'sans corriger ni l un ni l autre' 'ne concordent pas'

rc_dans 'ls ne prend pas d argument' 2 "$D" src ls trop
rc_dans 'un verbe inconnu est mal forme' 2 "$D" src bidule
rc_dans 'src sans verbe est mal forme' 2 "$D" src

# ==========================================================================
titre 'Une extension apporte ses commandes'
# ==========================================================================

W=$(depot travail)
declare_source "$W" 'session.exemple.test' local '../ext-a'

rc_dans 'la commande de l extension apparait dans l aide' 0 "$W" --help
dit 'son nom y figure' '^  ses$'
dit 'et sa signature aussi' 'clia ses dis'

rc_dans 'elle repond' 0 "$W" ses bonjour
dit 'et c est bien elle qui a repondu' '^bonjour$'

rc_dans 'son aide de niveau repond' 0 "$W" ses --help
dit 'avec sa signature' 'clia ses dis'

vrai 'aucun fichier du depot source n a change' \
  test "$(git -C "$RACINE" status --porcelain | sort)" = "$REEL_ETAT"

# Un dépôt qui ne la déclare pas ne la voit pas : la portée d'une extension
# est le dépôt qui l'accepte, non la machine.
AUTRE=$(depot sans-extension)
SORTIE=$(dans "$AUTRE" --help 2>/dev/null)
ne_dit_pas 'un depot qui ne la declare pas ne la voit pas' '^  ses$'

# ==========================================================================
titre 'Une extension ajoute, elle ne remplace pas'
# ==========================================================================

USURPE=$(extension ext-usurpe VER version 'usurpe.exemple.test')
cat > "$USURPE/_ressources/version/_scripts/version.sh" <<'SH'
#!/usr/bin/env bash
# Description: Une commande d extension qui tente de masquer le noyau.
# Périmètre: aucun
# Signature: version usurpee
set -euo pipefail
printf 'usurpee\n'
SH

MASQUE=$(depot masque)
declare_source "$MASQUE" 'usurpe.exemple.test' local '../ext-usurpe'
SORTIE=$(dans "$MASQUE" version 2>&1)
ne_dit_pas 'une extension ne peut pas masquer une commande du noyau' '^usurpee$'

# Ni une ressource du CLI lui-même.
USURPE2=$(extension ext-usurpe2 RES ressource 'usurpe2.exemple.test')
cat > "$USURPE2/_ressources/ressource/_scripts/res.sh" <<'SH'
#!/usr/bin/env bash
# Description: Une commande d extension qui tente de masquer une ressource du CLI.
# Périmètre: aucun
# Signature: res usurpee
set -euo pipefail
printf 'usurpee\n'
SH
declare_source "$MASQUE" 'usurpe2.exemple.test' local '../ext-usurpe2'
SORTIE=$(dans "$MASQUE" res ls 2>&1)
ne_dit_pas 'ni une ressource du CLI lui-meme' '^usurpee$'

# ==========================================================================
titre 'Une source declaree qui ne mene a rien ne bloque rien'
# ==========================================================================
#
# Un dépôt voisin non cloné est le cas ordinaire, non une erreur : le travail
# doit continuer sans lui.

CASSE=$(depot casse)
declare_source "$CASSE" 'absente.exemple.test' local '../nulle-part'
declare_source "$CASSE" 'session.exemple.test' local '../ext-a'
rc_dans 'le travail continue malgre une source absente' 0 "$CASSE" version
rc_dans 'et l aide aussi' 0 "$CASSE" --help
dit 'la commande de la source presente y est quand meme' '^  ses$'

SANS_CARTE="$BAC/sans-carte"; mkdir -p "$SANS_CARTE"; git -C "$SANS_CARTE" init -q
rc 'un depot sans carte ne cherche aucune extension' 0 \
  bash -c "cd '$SANS_CARTE' && '$CLIA' --help"

# ==========================================================================
titre 'Le depot reel n a pas bouge'
# ==========================================================================

vrai 'son etat de travail est le meme qu au depart' \
  test "$(git -C "$RACINE" status --porcelain | sort)" = "$REEL_ETAT"

bilan
