#!/usr/bin/env bash
# _scripts/tests/test_generation.sh — le stade généré, et make(1).
#
# Éprouve SES-001 tâche 22, verbe « make ».
#
# Ce que le banc mesure, et qui n'irait pas de soi :
#
#   clia délègue vraiment. Ce qui est construit l'est par les règles du
#   Makefile de l'instance, non par quelque chose que clia porterait ;
#
#   le répertoire de travail de make est l'instance. Un Makefile écrit avec
#   des chemins relatifs construit la même chose où que le dépôt soit cloné ;
#
#   les trois formes se distinguent : construire, dire ce qui serait fait,
#   demander si c'est à jour. La troisième ne construit rien ;
#
#   un refus arrive avant que make soit lancé — programme absent, règles
#   absentes — et nomme ce qui manque ;
#
#   C1 admet genere/ et le Makefile dans une instance. Sans cela, construire
#   rendrait la ressource non conforme.

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
ID='RES-001-outil'

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

depot() {
  local d="$BAC/$1"
  mkdir -p "$d/$INST/$ID/primitive-1" "$d/$INST/$ID/livrables/_scripts"
  git -C "$d" init -q
  printf 'namespace: exemple.test/%s\nversion: 1.0.0\n' "$1" > "$d/clia.yaml"
  cat > "$d/$INST/$ID/livrables/outil.yaml" <<'YAML'
nom: outil
titre: Outil
prefixe: OUT
version: 0.1.0

description: "Une ressource de banc."
YAML
  cat > "$d/$INST/$ID/livrables/_scripts/out.sh" <<'SH'
#!/usr/bin/env bash
# Description: Une ressource de banc.
# Périmètre: dépôt
# Signature: out dis
set -euo pipefail
printf 'un\n'
SH
  printf -- '---\ntitre: "La source"\n---\n\nce que quelqu un a écrit\n' \
    > "$d/$INST/$ID/primitive-1/ENO-001-source.md"
  mkdir -p "$d/$LIVREE"
  cp -r "$d/$INST/$ID/livrables" "$d/$LIVREE/outil"
  git_ "$d" add -A >/dev/null
  git_ "$d" commit -q -m 'outil 0.1.0'
  printf '%s\n' "$d"
}

# Un Makefile qui construit genere/resume.txt depuis la primitive.
regles() {
  local d="$1" nom="${2:-Makefile}"
  { printf 'genere/resume.txt: primitive-1/ENO-001-source.md\n'
    printf '\tmkdir -p genere\n'
    printf '\twc -l < $< > $@\n'
    printf '\n'
    printf 'tout: genere/resume.txt\n'
  } > "$d/$INST/$ID/$nom"
}

# ==========================================================================
titre 'Le verbe est tenu pour toutes les ressources, et documenté'
# ==========================================================================

SORTIE=$("$CLIA" res --help 2>/dev/null)
dit 'make figure dans l aide d une ressource' 'clia res make ls'
dit 'avec sa forme de configuration' 'clia res make config ls'
SORTIE=$("$CLIA" hrn --help 2>/dev/null)
dit 'et dans celle d une autre' 'clia hrn make \[CIBLE'

rc 'le manuel de clia le decrit' 0 "$CLIA" --man
dit 'il dit que clia delegue' 'il lance make(1) dans'
dit 'et nomme son autre nom' '« generate » nomme le même verbe'

# ==========================================================================
titre 'Construire'
# ==========================================================================

D=$(depot construire)
regles "$D"

rc_dans 'make construit' 0 "$D" out make
dit 'et clia dit ou' 'construit sous \.dev/ressources/RES-001-outil/genere'
dit 'et qu il ne commite rien' "rien n'est commité"
vrai 'la cible est la' test -f "$D/$INST/$ID/genere/resume.txt"

rc_dans 'relance, il n a rien a faire' 0 "$D" out make
rc_dans 'generate est le meme verbe' 0 "$D" out generate
# « gen » n'est pas repris : « clia hrn gen » existe déjà, et un verbe
# générique qui masquerait un verbe de ressource ferait disparaître une
# commande sans le dire.
rc_dans 'gen reste au script de la ressource' 0 "$D" out gen
dit 'et c est lui qui repond' '^un$'

rc_dans 'une cible peut etre nommee' 0 "$D" out make tout
rc_dans 'une cible inconnue fait echouer' 1 "$D" out make bidule
dit 'et clia nomme les regles' 'les règles sont dans .*Makefile'

# ==========================================================================
titre 'Dire ce qui serait fait'
# ==========================================================================

E=$(depot dire)
regles "$E"

rc_dans 'make ls repond' 0 "$E" out make ls
dit 'il nomme la ressource' '^ressource  outil$'
dit 'et l instance' '^instance   \.dev/ressources/RES-001-outil$'
dit 'et le fichier de regles' '^règles     Makefile$'
dit 'et rend ce que make ferait' 'mkdir -p genere'
faux 'et ne construit rien' test -f "$E/$INST/$ID/genere/resume.txt"

( cd "$E" && "$CLIA" out make >/dev/null 2>&1 )
SORTIE=$(sortie "$E" out make ls)
ne_dit_pas 'une fois construit, il n y a plus rien a faire' 'mkdir -p genere'

# ==========================================================================
titre 'Demander si c est à jour'
# ==========================================================================

F=$(depot ajour)
regles "$F"

rc_dans 'avant de construire, ce n est pas a jour' 1 "$F" out make --check
dit 'et clia le dit' "le stade généré n'est pas à jour"
dit 'et dit quoi faire' 'pour le construire  : clia out make'
faux 'et --check ne construit rien' test -f "$F/$INST/$ID/genere/resume.txt"

rc_dans 'construit, il devient a jour' 0 "$F" out make
rc_dans 'et --check le dit' 0 "$F" out make --check
dit 'clia le confirme' 'le stade généré est à jour'

printf 'une ligne de plus\n' >> "$F/$INST/$ID/primitive-1/ENO-001-source.md"
rc_dans 'la primitive touchee, il ne l est plus' 1 "$F" out make --check

# ==========================================================================
titre 'Ce qui règle la génération'
# ==========================================================================

rc_dans 'make config ls repond' 0 "$F" out make config ls
dit 'il nomme le programme' '^CLIA_MAKE  *make  *défaut'
dit 'et le fichier trouve' '^CLIA_MAKEFILE  *Makefile  *trouvé'
dit 'et situe le stade genere' '^genere     \.dev/ressources/RES-001-outil/genere$'

rc_dans 'config sans ls dit la meme chose' 0 "$F" out make config
rc_dans 'config n accepte rien d autre' 2 "$F" out make config bidule

G=$(depot regles-nommees)
regles "$G" 'Makefile.dev'
rc_dans 'sans regles au nom attendu, clia refuse' 1 "$G" out make
dit 'et dit ce qu il a cherche' 'GNUmakefile makefile Makefile'

rc_env 'CLIA_MAKEFILE nomme le fichier' 0 "$G" 'CLIA_MAKEFILE=Makefile.dev' out make
vrai 'et la cible est la' test -f "$G/$INST/$ID/genere/resume.txt"

rc_env 'un CLIA_MAKEFILE absent est refuse' 1 "$G" 'CLIA_MAKEFILE=Makefile.absent' out make
dit 'et clia le nomme' 'Makefile.absent est absent'

rc_env 'un programme introuvable est refuse' 1 "$G" 'CLIA_MAKE=make-qui-n-existe-pas' out make
dit 'et clia dit comment en nommer un autre' 'CLIA_MAKE=<programme>'

# ==========================================================================
titre 'La documentation du verbe'
# ==========================================================================

rc_dans 'make --explain repond' 0 "$D" out make --explain
dit 'il dit pourquoi clia delegue' 'Pourquoi déléguer'
dit 'et ce que la delegation coute' 'Ce que la délégation coûte'
faux 'et il ne construit rien' test -f "$BAC/rien"

rc_dans 'make --man repond' 0 "$D" out make --man
dit 'il nomme la page' 'clia-out-make'
dit 'il dit ce que make recoit' 'CLIA_INSTANCE'

rc_dans 'une option inconnue est mal formee' 2 "$D" out make --bidule

# ==========================================================================
titre 'Ce que le stade généré ne casse pas'
# ==========================================================================

rc_dans 'une instance qui porte genere et Makefile reste conforme' 0 "$D" out check
dit 'C1 passe' '^C1  ok'

H=$(depot sans-instance)
rm -rf "${H:?}/$INST"
git_ "$H" add -A >/dev/null; git_ "$H" commit -q -m 'plus que la copie installee'
rc_dans 'sans instance, il n y a rien a construire' 1 "$H" out make
dit 'et clia dit pourquoi' "il n'y a rien à construire ici"

# ==========================================================================
titre 'Le dépôt réel n a pas bougé'
# ==========================================================================

vrai 'son etat de travail est le meme qu au depart' \
  test "$(git -C "$RACINE" status --porcelain | sort)" = "$REEL_ETAT"

bilan
