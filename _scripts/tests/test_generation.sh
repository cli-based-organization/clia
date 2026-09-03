#!/usr/bin/env bash
# _scripts/tests/test_generation.sh — la génération, et ce qui décide de refaire.
#
# Éprouve SES-001 tâche 23 : le format des recettes, le graphe, les deux
# façons de changer, et les quatre niveaux de politique.
#
# Ce que le banc mesure, et qui n'irait pas de soi :
#
#   une cible est refaite quand son contenu d'entrée a changé, non quand sa
#   date a bougé. Toucher un fichier sans le modifier ne doit rien
#   déclencher — un clone remet toutes les dates à la même ;
#
#   le graphe se propage : une cible à refaire rend à refaire tout ce qui en
#   dépend, et l'ordre de construction respecte les dépendances ;
#
#   une dépendance de ressource ne se mesure pas comme un fichier. Sous
#   fixed-version, une ressource qui bouge sans changer de version ne
#   provoque rien ; sous rolling-release, si ;
#
#   les quatre niveaux de politique s'ordonnent, et le plus proche l'emporte.
#   Une préférence d'utilisateur ne défait pas ce qu'une ressource a posé ;
#
#   une recette est jugée sur ce qu'elle pose. Se terminer sans produire sa
#   cible est un échec.

set -uo pipefail

RACINE=$(cd -P "$(dirname "${BASH_SOURCE[0]}")/../.." && pwd)
CLIA="$RACINE/_scripts/bin/clia"

# shellcheck source=banc.sh
. "$RACINE/_scripts/tests/banc.sh"

BAC=$(mktemp -d)
trap 'rm -rf "$BAC"' EXIT

export XDG_CACHE_HOME="$BAC/cache"
export XDG_CONFIG_HOME="$BAC/config"

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

# Un dépôt qui écrit la ressource « outil », et l'a installée.
depot() {
  local d="$BAC/$1"
  mkdir -p "$d/$INST/$ID/primitive-1" "$d/$INST/$ID/livrables/_scripts" "$d/$LIVREE"
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
  printf -- '---\ntitre: "La source"\n---\n\nune ligne\n' \
    > "$d/$INST/$ID/primitive-1/ENO-001-source.md"
  cat > "$d/$INST/$ID/livrables/_scripts/resumer.sh" <<'SH'
#!/usr/bin/env bash
set -euo pipefail
mkdir -p "$(dirname "$CLIA_CIBLE")"
wc -l < primitive-1/ENO-001-source.md > "$CLIA_CIBLE"
SH
  cat > "$d/$INST/$ID/livrables/_scripts/final.sh" <<'SH'
#!/usr/bin/env bash
set -euo pipefail
mkdir -p "$(dirname "$CLIA_CIBLE")"
{ printf 'resume: '; cat genere/resume.txt; } > "$CLIA_CIBLE"
SH
  cp -r "$d/$INST/$ID/livrables" "$d/$LIVREE/outil"
  git_ "$d" add -A >/dev/null
  git_ "$d" commit -q -m 'outil 0.1.0'
  printf '%s\n' "$d"
}

# Les recettes ordinaires : une chaîne de deux cibles.
recettes() {
  cat > "$1/$INST/$ID/generation.yaml" <<'YAML'
recettes:
  - cible: genere/resume.txt
    depuis: primitive-1/ENO-001-source.md
    par: livrables/_scripts/resumer.sh

  - cible: livrables/rapport.md
    depuis: genere/resume.txt
    par: livrables/_scripts/final.sh
YAML
}

# ==========================================================================
titre 'Les verbes sont tenus, et documentés'
# ==========================================================================

SORTIE=$("$CLIA" res --help 2>/dev/null)
dit 'make figure dans l aide d une ressource' 'clia res make ls'
dit 'avec ses politiques' 'clia res make policy set CLE VALEUR'
SORTIE=$("$CLIA" hrn --help 2>/dev/null)
dit 'et dans celle d une autre' 'clia hrn make \[CIBLE'

SORTIE=$("$CLIA" --help 2>/dev/null)
dit 'make est aussi une commande du noyau' '^  make '

rc 'le manuel de clia decrit le verbe' 0 "$CLIA" --man
dit 'il dit que clia n emploie pas make(1)' "clia n'emploie pas make(1)"
dit 'et nomme le fichier de recettes' 'generation.yaml'

rc 'le manuel de la commande make repond' 0 "$CLIA" make --man
dit 'il nomme les quatre niveaux' 'clia setup config set make.policy.'

# ==========================================================================
titre 'Construire'
# ==========================================================================

D=$(depot construire)
recettes "$D"

rc_dans 'make ls repond avant toute construction' 0 "$D" out make ls
dit 'il nomme la ressource' '^ressource  outil$'
dit 'et la politique en vigueur' 'ressource.version = fixed-version  (défaut)'
dit 'la premiere cible est a construire' '^genere/resume.txt *à construire'
dit 'la seconde suit la premiere' '^livrables/rapport.md *à refaire *genere/resume.txt va être refaite'
dit 'et il compte ce qui reste' '2 cible(s) à faire sur 2'
dit 'et dit qu il n a rien construit' "rien n'a été construit"
faux 'rien n est ecrit' test -e "$D/$INST/$ID/genere/resume.txt"

rc_dans 'make --check dit ce qui reste' 1 "$D" out make --check
faux 'et n ecrit rien non plus' test -e "$D/$INST/$ID/genere/resume.txt"

rc_dans 'make construit' 0 "$D" out make
dit 'il compte ce qu il a fait' '2 cible(s) construite(s)'
vrai 'la premiere cible est la' test -f "$D/$INST/$ID/genere/resume.txt"
vrai 'la seconde aussi' test -f "$D/$INST/$ID/livrables/rapport.md"
vrai 'et elle a vu la premiere' \
  grep -q '^resume: ' "$D/$INST/$ID/livrables/rapport.md"
vrai 'les empreintes sont inscrites' test -f "$D/$INST/$ID/.empreintes.yaml"

rc_dans 'relance, il n a rien a faire' 0 "$D" out make
dit 'et il le dit' 'rien à faire, tout est à jour'
rc_dans 'et --check le confirme' 0 "$D" out make --check

# ==========================================================================
titre 'Ce qui décide de refaire'
# ==========================================================================

touch "$D/$INST/$ID/primitive-1/ENO-001-source.md"
rc_dans 'toucher un fichier sans le modifier ne declenche rien' 0 "$D" out make --check
dit 'et clia le dit' 'tout est à jour'

printf 'une ligne de plus\n' >> "$D/$INST/$ID/primitive-1/ENO-001-source.md"
rc_dans 'en modifier le contenu declenche' 1 "$D" out make --check
SORTIE=$(sortie "$D" out make ls)
dit 'et clia dit pourquoi' '^genere/resume.txt *à refaire *ses entrées ont changé'
dit 'et la suite est entrainee' '^livrables/rapport.md *à refaire *genere/resume.txt va être refaite'

rc_dans 'refaire suffit' 0 "$D" out make
rc_dans 'et tout redevient a jour' 0 "$D" out make --check

rm -f "$D/$INST/$ID/genere/resume.txt"
SORTIE=$(sortie "$D" out make ls)
dit 'une cible effacee est a construire' '^genere/resume.txt *à construire'

# ==========================================================================
titre 'Une cible nommée'
# ==========================================================================

E=$(depot nommee)
recettes "$E"

rc_dans 'une cible nommee construit ce dont elle depend' 0 "$E" out make genere/resume.txt
vrai 'la cible demandee est la' test -f "$E/$INST/$ID/genere/resume.txt"
faux 'et pas ce qui en depend' test -f "$E/$INST/$ID/livrables/rapport.md"

rc_dans 'une cible inconnue est refusee' 1 "$E" out make genere/inconnue.txt
dit 'et clia renvoie vers la liste' 'clia out make ls'

# ==========================================================================
titre 'Ce que les recettes peuvent avoir de faux'
# ==========================================================================

S=$(depot sans-recettes)
rc_dans 'sans fichier de recettes, clia refuse' 1 "$S" out make
dit 'et nomme ce qu il attendait' 'attendu : \.dev/ressources/RES-001-outil/generation.yaml'

V=$(depot vide)
printf 'recettes:\n' > "$V/$INST/$ID/generation.yaml"
rc_dans 'un fichier sans recette est refuse' 1 "$V" out make
dit 'et clia le dit' 'ne déclare aucune recette'

C=$(depot cycle)
cat > "$C/$INST/$ID/generation.yaml" <<'YAML'
recettes:
  - cible: a.txt
    depuis: b.txt
    par: livrables/_scripts/resumer.sh
  - cible: b.txt
    depuis: a.txt
    par: livrables/_scripts/resumer.sh
YAML
rc_dans 'un cycle est refuse' 1 "$C" out make
dit 'et clia le nomme' 'cycle entre cibles'

P=$(depot sans-par)
cat > "$P/$INST/$ID/generation.yaml" <<'YAML'
recettes:
  - cible: genere/resume.txt
    depuis: primitive-1/ENO-001-source.md
YAML
rc_dans 'une recette sans « par » ne genere rien' 1 "$P" out make
SORTIE=$(sortie "$P" out make ls)
dit 'et clia dit qu il n y a pas de recette' 'sans recette *la recette ne dit pas'

M=$(depot recette-absente)
cat > "$M/$INST/$ID/generation.yaml" <<'YAML'
recettes:
  - cible: genere/resume.txt
    depuis: primitive-1/ENO-001-source.md
    par: livrables/_scripts/absent.sh
YAML
rc_dans 'une recette introuvable est refusee' 1 "$M" out make
dit 'et clia la nomme' 'la recette est introuvable — livrables/_scripts/absent.sh'

R=$(depot recette-muette)
printf '#!/usr/bin/env bash\nexit 0\n' > "$R/$INST/$ID/livrables/_scripts/muette.sh"
cat > "$R/$INST/$ID/generation.yaml" <<'YAML'
recettes:
  - cible: genere/resume.txt
    depuis: primitive-1/ENO-001-source.md
    par: livrables/_scripts/muette.sh
YAML
rc_dans 'une recette qui ne produit rien est un echec' 1 "$R" out make
dit 'et clia dit sur quoi elle est jugee' 'jugée sur ce qu.elle pose'

X=$(depot recette-cassee)
printf '#!/usr/bin/env bash\nexit 3\n' > "$X/$INST/$ID/livrables/_scripts/cassee.sh"
cat > "$X/$INST/$ID/generation.yaml" <<'YAML'
recettes:
  - cible: genere/resume.txt
    depuis: primitive-1/ENO-001-source.md
    par: livrables/_scripts/cassee.sh
YAML
rc_dans 'une recette qui echoue arrete la construction' 1 "$X" out make
dit 'et clia la nomme' 'la recette a échoué'

# ==========================================================================
titre 'Une dépendance de ressource'
# ==========================================================================

res_depend() {
  cat > "$1/$INST/$ID/generation.yaml" <<'YAML'
recettes:
  - cible: genere/resume.txt
    depuis: primitive-1/ENO-001-source.md
    ressources: outil
    par: livrables/_scripts/resumer.sh
YAML
}

F=$(depot fixed)
res_depend "$F"
rc_dans 'la construction passe' 0 "$F" out make
rc_dans 'et tout est a jour' 0 "$F" out make --check

printf '\n# une ligne de plus\n' >> "$F/$LIVREE/outil/_scripts/out.sh"
rc_dans 'sous fixed-version, une ressource qui bouge ne declenche rien' 0 "$F" out make --check
dit 'et clia le dit' 'tout est à jour'

sed -i 's/^version: 0.1.0$/version: 0.2.0/' "$F/$LIVREE/outil/outil.yaml"
rc_dans 'mais un changement de version declenche' 1 "$F" out make --check

G=$(depot rolling)
res_depend "$G"
rc_dans 'la construction passe aussi' 0 "$G" out make
printf '\n# une ligne de plus\n' >> "$G/$LIVREE/outil/_scripts/out.sh"
rc_env 'sous rolling-release, ce qui bouge declenche' 1 "$G" \
  'CLIA_MAKE_POLICY_RESSOURCE_VERSION=rolling-release' out make --check

H=$(depot epinglee)
cat > "$H/$INST/$ID/generation.yaml" <<'YAML'
recettes:
  - cible: genere/resume.txt
    depuis: primitive-1/ENO-001-source.md
    ressources: outil@0.1.0
    par: livrables/_scripts/resumer.sh
YAML
rc_dans 'une version epinglee construit' 0 "$H" out make
printf '\n# une ligne de plus\n' >> "$H/$LIVREE/outil/_scripts/out.sh"
sed -i 's/^version: 0.1.0$/version: 0.9.0/' "$H/$LIVREE/outil/outil.yaml"
rc_env 'et rien ne la fait bouger, meme en rolling-release' 0 "$H" \
  'CLIA_MAKE_POLICY_RESSOURCE_VERSION=rolling-release' out make --check

# ==========================================================================
titre 'Les quatre niveaux de politique'
# ==========================================================================

N=$(depot niveaux)
recettes "$N"

rc_dans 'par defaut, la politique vient du defaut' 0 "$N" out make policy ls
dit 'et clia le dit' 'ressource.version *fixed-version *défaut'

rc_dans 'l utilisateur peut la poser' 0 "$N" setup config set make.policy.ressource.version rolling-release
dit 'et clia dit ou' 'inscrit dans .*config/clia/config.yaml'
SORTIE=$(sortie "$N" out make policy ls)
dit 'elle vient alors de l utilisateur' 'ressource.version *rolling-release *utilisateur'

rc_dans 'setup config ls la rend' 0 "$N" setup config ls
dit 'sous la cle de l enonce' 'make\.policy\.ressource\.version *rolling-release'

rc_dans 'le depot l emporte sur l utilisateur' 0 "$N" make policy set ressource.version fixed-version
SORTIE=$(sortie "$N" out make policy ls)
dit 'et clia nomme le niveau depot' 'ressource.version *fixed-version *dépôt'

rc_dans 'la ressource l emporte sur le depot' 0 "$N" out make policy set ressource.version rolling-release
SORTIE=$(sortie "$N" out make policy ls)
dit 'et clia nomme le niveau ressource' 'ressource.version *rolling-release *ressource'

SORTIE=$( ( cd "$N" && CLIA_MAKE_POLICY_RESSOURCE_VERSION=fixed-version "$CLIA" out make policy ls ) 2>&1 )
dit 'l appel l emporte sur tout' 'ressource.version *fixed-version *appel'

vrai 'les recettes survivent a une politique posee' \
  test "$(sortie "$N" out make ls | grep -c '^genere/resume.txt')" = '1'

rc_dans 'une politique inconnue est refusee' 2 "$N" out make policy set bidule x
dit 'et clia nomme celles qui existent' 'celles qui existent : ressource.version'
rc_dans 'une valeur inconnue est refusee' 2 "$N" out make policy set ressource.version bidule
dit 'et clia nomme les valeurs admises' 'valeurs admises : fixed-version rolling-release'
rc_dans 'la meme chose au niveau du depot' 2 "$N" make policy set ressource.version bidule
rc_dans 'une cle mal formee est refusee par setup' 2 "$N" setup config set bidule x
dit 'et clia dit la forme attendue' 'commencent par « make.policy. »'

rc_dans 'clia make sans verbe est mal forme' 2 "$N" make
dit 'et renvoie vers la politique' 'clia make policy ls'
rc_dans 'un verbe inconnu aussi' 2 "$N" make bidule

# ==========================================================================
titre 'Ce que la génération ne casse pas'
# ==========================================================================

rc_dans 'une instance qui porte generation.yaml et genere reste conforme' 0 "$D" out check
dit 'C1 passe' '^C1  ok'

rc_dans 'make config ls situe les deux fichiers' 0 "$D" out make config ls
dit 'les recettes' 'recettes *\.dev/ressources/RES-001-outil/generation.yaml *présent'
dit 'et les empreintes' 'empreintes *\.dev/ressources/RES-001-outil/\.empreintes\.yaml *présent'

I=$(depot sans-instance)
rm -rf "${I:?}/$INST"
git_ "$I" add -A >/dev/null; git_ "$I" commit -q -m 'plus que la copie installee'
rc_dans 'sans instance, il n y a rien a generer' 1 "$I" out make
dit 'et clia dit pourquoi' "il n'y a rien à générer ici"

rc_dans 'make --explain repond' 0 "$D" out make --explain
dit 'il dit ce qui distingue clia de make' 'Ce qui le distingue de make(1)'
rc_dans 'make --man repond' 0 "$D" out make --man
dit 'il nomme la page' 'clia-out-make'
rc_dans 'une option inconnue est mal formee' 2 "$D" out make --bidule

# ==========================================================================
titre 'Le dépôt réel n a pas bougé'
# ==========================================================================

vrai 'son etat de travail est le meme qu au depart' \
  test "$(git -C "$RACINE" status --porcelain | sort)" = "$REEL_ETAT"

bilan
