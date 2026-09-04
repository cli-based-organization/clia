#!/usr/bin/env bash
# _scripts/tests/test_parc.sh — le parc des ressources installées.
#
# Éprouve SES-002 tâche 1 : clia ls, clia update, clia version RESSOURCE,
# clia upgrade RESSOURCE et clia downgrade RESSOURCE VERSION.
#
# Ce que le banc mesure, et qui n'irait pas de soi :
#
#   l'historique d'une ressource porte toutes ses versions. « git log
#   --follow --reverse » n'en rendait qu'une, et tout ce qui compare une
#   version posée à la dernière disponible s'en trouvait faux ;
#
#   un dépôt qui publie une ressource en est la source : sa copie installée
#   monte vers ce que son instance déclare, par les mêmes commandes que le
#   reste ;
#
#   une ressource se désigne par son nom, son préfixe ou sa commande, et les
#   trois répondent ;
#
#   « actif » se lit là où le point d'entrée cherche ses commandes, et non
#   dans une déclaration qui pourrait mentir ;
#
#   « ls » et « update » n'écrivent rien.

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
UUID='clia:0f9a1b2c-3d4e-5f60-8192-a3b4c5d6e7f8'

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

# Écrit le livrable de la ressource « outil » à une version donnée.
livrable() {
  local liv="$1" version="$2"
  mkdir -p "$liv/_scripts"
  cat > "$liv/outil.yaml" <<YAML
nom: outil
id: $UUID
titre: Outil
prefixe: OUT
version: $version

description: "Une ressource de banc."
YAML
  cat > "$liv/_scripts/out.sh" <<'SH'
#!/usr/bin/env bash
# Description: Une ressource de banc.
# Périmètre: dépôt
# Signature: out dis
set -euo pipefail
printf 'un\n'
SH
}

# Un dépôt qui publie « outil » : son instance est commitée en 0.1.0, sa
# copie installée est posée à la même version.
depot() {
  local d="$BAC/$1"
  mkdir -p "$d/$INST/$ID" "$d/$LIVREE"
  git -C "$d" init -q
  { printf 'namespace: exemple.test/%s\n' "$1"
    printf 'version: 1.0.0\n\n'
    printf 'provide:\n  - prefix: OUT\n    name: outil\n'
  } > "$d/clia.yaml"
  livrable "$d/$INST/$ID/livrables" 0.1.0
  cp -r "$d/$INST/$ID/livrables" "$d/$LIVREE/outil"
  git_ "$d" add -A >/dev/null
  git_ "$d" commit -q -m 'outil 0.1.0'
  printf '%s\n' "$d"
}

# Publie une version de plus dans l'instance, et la commite.
publier() {
  local d="$1" version="$2"
  livrable "$d/$INST/$ID/livrables" "$version"
  git_ "$d" add -A >/dev/null
  git_ "$d" commit -q -m "outil $version"
}

# ==========================================================================
titre 'Les commandes sont là, et documentées'
# ==========================================================================

SORTIE=$("$CLIA" --help 2>/dev/null)
dit 'ls figure parmi les commandes du noyau' '^  ls  *Les ressources installées'
dit 'update aussi' '^  update  *Ce qui est à mettre à jour'

rc 'le manuel de ls repond' 0 "$CLIA" ls --man
dit 'il nomme les colonnes' 'ACTIVE'
dit 'et dit ce que STATE veut dire' 'en retard  sa source en déclare une plus récente'
dit 'et ce qu est une ressource brisee' 'brisée     tout le reste'
dit 'et qu elle n est jamais dite active' "Une ressource brisée n'est jamais rendue active"

rc 'le manuel de update repond' 0 "$CLIA" update --man
dit 'il dit qu il n ecrit rien' "C'est clia upgrade qui déplace"

SORTIE=$("$CLIA" version --help 2>/dev/null)
dit 'version accepte une ressource' 'clia version RESSOURCE'
SORTIE=$("$CLIA" upgrade --help 2>/dev/null)
dit 'upgrade aussi' 'clia upgrade RESSOURCE \[VERSION\]'
SORTIE=$("$CLIA" downgrade --help 2>/dev/null)
dit 'downgrade exige la version' 'clia downgrade RESSOURCE VERSION'

# ==========================================================================
titre 'clia ls'
# ==========================================================================

D=$(depot parc)
rc_dans 'clia ls repond' 0 "$D" ls
dit 'l en-tete nomme les six colonnes' '^PREFIX .*NAME .*SOURCE .*VERSION .*STATE .*ACTIVE$'
dit 'la ressource y est' '^OUT  *outil '
dit 'sa source est le namespace du depot qui la publie' 'exemple.test/parc'
dit 'sa version est celle qui est posee' ' 0\.1\.0 '
dit 'elle est a jour' 'à jour'
dit 'et active' 'actif$'

rc_dans 'ls ne prend pas d argument' 2 "$D" ls outil

V=$(mktemp -d)/vide; mkdir -p "$V"; git -C "$V" init -q
printf 'namespace: exemple.test/vide\nversion: 1.0.0\n' > "$V/clia.yaml"
git_ "$V" add -A >/dev/null; git_ "$V" commit -q -m 'un dépôt nu'
rc_dans 'un depot sans ressource le dit' 0 "$V" ls
dit 'et dit comment en avoir' 'clia res new PREFIXE NOM'
rm -rf "$(dirname "$V")"

# ==========================================================================
titre 'STATE — ce que la source déclare'
# ==========================================================================

R=$(depot retard)
publier "$R" 0.2.0
SORTIE=$(sortie "$R" ls)
dit 'une copie plus ancienne que la source est en retard' '^OUT .*0\.1\.0 .*en retard'

# C'est ici que « git log --follow --reverse » se trompait : il ne rendait
# qu'un seul commit, et 0.2.0 passait inaperçue.
SORTIE=$(sortie "$R" update outil)
dit 'l historique porte les deux versions' '^0\.1\.0 '
dit 'et la seconde aussi' '^0\.2\.0 '
dit 'la version posee est marquee' '^0\.1\.0 .*posée ici'

# SES-002 tâche 2 : deux états sont sains, et tout le reste est « brisée ».
# « inconnu » n'existe plus.
A=$(depot avance)
sed -i 's/^version: 0.1.0$/version: 0.9.0/' "$A/$LIVREE/outil/outil.yaml"
rc_dans 'une copie qui depasse sa source est brisee' 0 "$A" ls
dit 'la colonne le dit' 'brisée'
dit 'et clia dit pourquoi' 'elle dépasse 0\.1\.0, la dernière que sa source déclare'
ne_dit_pas 'aucun etat « en avance »' 'en avance'

I=$(depot sans-source)
python3 - "$I/clia.yaml" <<'PYEOF'
import sys
p = sys.argv[1]
s = open(p, encoding='utf-8').read().replace('provide:\n  - prefix: OUT\n    name: outil\n', '')
open(p, 'w', encoding='utf-8').write(s)
PYEOF
rc_dans 'sans source declaree, la ressource est brisee' 0 "$I" ls
dit 'la colonne le dit' 'brisée'
dit 'et clia nomme la cause' 'clia ne trouve pas le dépôt qui la publie'
dit 'et la source vaut tiret' '^OUT  *outil  *—'
ne_dit_pas 'aucun etat « inconnu »' 'inconnu'

W=$(depot version-illisible)
sed -i 's/^version: 0.1.0$/version: toute-neuve/' "$W/$LIVREE/outil/outil.yaml"
rc_dans 'une version illisible brise la ressource' 0 "$W" ls
dit 'et clia rappelle la forme' "n'a pas la forme X.Y.Z"

# ==========================================================================
titre 'Une ressource brisée n est pas servie'
# ==========================================================================

rc_dans 'brisee, elle est inactive' 0 "$I" ls
dit 'la colonne ACTIVE le dit' 'inactif'
dit 'et clia le rattache a ce qui la brise' 'elle est brisée :'

# SES-002 tâche 2 dit qu'une ressource brisée « ne DOIT PAS être actif ».
# clia le rend partout où il rapporte un état ; il ne refuse pas de servir sa
# commande pour autant — voir le compte rendu de la tâche.
rc_dans 'sa commande repond encore' 0 "$I" out dis
dit 'et c est bien elle qui repond' '^un$'

rc_dans 'une ressource saine est servie' 0 "$D" out dis
dit 'et elle repond' '^un$'

# ==========================================================================
titre 'ACTIVE — la commande est-elle servie'
# ==========================================================================

S=$(depot sans-script)
rm -f "$S/$LIVREE/outil/_scripts/out.sh"
rc_dans 'sans script, la ressource est inactive' 0 "$S" ls
dit 'la colonne le dit' 'inactif'
dit 'et clia dit pourquoi' 'elle ne porte pas _scripts/out.sh'

M=$(depot masquee)
sed -i 's/^prefixe: OUT$/prefixe: LS/' "$M/$LIVREE/outil/outil.yaml"
mv "$M/$LIVREE/outil/_scripts/out.sh" "$M/$LIVREE/outil/_scripts/ls.sh"
rc_dans 'un nom pris par le noyau rend la ressource inactive' 0 "$M" ls
dit 'la colonne le dit aussi' 'inactif'
dit 'et clia le nomme' '« clia ls » est une commande du noyau'

# ==========================================================================
titre 'clia update'
# ==========================================================================

rc_dans 'update liste ce qui est en retard' 0 "$R" update
dit 'l en-tete nomme les cinq colonnes' '^PREFIX .*NAME .*SOURCE .*ACTUAL_VERSION .*LATEST_AVAILABLE_VERSION$'
dit 'avec la version posee et la derniere' '^OUT .*0\.1\.0 .*0\.2\.0$'
dit 'et dit comment y aller' 'clia upgrade RESSOURCE'

rc_dans 'a jour, update ne liste rien' 0 "$D" update
dit 'et le dit' "aucune ressource installée n'est en retard"

rc_dans 'une ressource brisee est dite a part' 0 "$I" update
dit 'et clia la nomme' 'brisée'
dit 'avec ce qui la brise' 'outil : clia ne trouve pas le dépôt qui la publie'

rc_dans 'update sur une ressource inconnue est refuse' 1 "$D" update bidule
dit 'et clia renvoie vers la liste' 'clia ls'
rc_dans 'update n attend qu une ressource' 2 "$D" update outil autre

# ==========================================================================
titre 'Désigner une ressource'
# ==========================================================================

for QUOI in outil OUT out; do
  rc_dans "clia version repond a « $QUOI »" 0 "$D" version "$QUOI"
  dit 'et rend la version posee' '^0\.1\.0$'
done

rc_dans 'une designation inconnue est refusee' 1 "$D" version bidule
dit 'et clia dit comment les lister' 'clia ls'

rc_dans 'clia version sans argument dit le depot' 0 "$D" version
ne_dit_pas 'et ne parle pas d une ressource' 'les versions disponibles'

rc_dans 'en retard, version dit vers quoi aller' 0 "$R" version outil
dit 'et clia nomme la version disponible' 'alors que 0\.2\.0 est disponible'

rc_dans 'brisee, version le dit' 0 "$I" version outil
dit 'et clia dit qu elle est inactive' 'elle est inactive'

# ==========================================================================
titre 'clia upgrade et clia downgrade'
# ==========================================================================

U=$(depot montee)
publier "$U" 0.2.0
rc_dans 'upgrade amene la ressource' 0 "$U" upgrade outil
dit 'et dit le saut' 'outil : 0\.1\.0 -> 0\.2\.0'
dit 'et que le depot la publie' 'ce dépôt la publie'
vrai 'la copie installee a suivi' \
  grep -q '^version: 0.2.0$' "$U/$LIVREE/outil/outil.yaml"

rc_dans 'relance, elle est deja la' 0 "$U" upgrade outil
dit 'et clia le dit' 'est déjà en 0\.2\.0'

rc_dans 'downgrade la ramene' 0 "$U" downgrade outil 0.1.0
vrai 'la copie installee est revenue' \
  grep -q '^version: 0.1.0$' "$U/$LIVREE/outil/outil.yaml"

# Ce qui est posé vient d'un commit : du travail non commité dans l'instance
# n'y est pas, et le poser l'effacerait.
printf '\n# du travail en cours\n' >> "$U/$INST/$ID/livrables/outil.yaml"
rc_dans 'une instance non commitee arrete la mise a jour' 1 "$U" upgrade outil
dit 'et clia dit ce qui serait perdu' 'porte du travail non commité'
dit 'et comment passer outre' '\-\-force passe outre'
git_ "$U" add -A >/dev/null; git_ "$U" commit -q -m 'le travail en cours'
rc_dans 'commitee, elle repart' 0 "$U" upgrade outil

rc_dans 'downgrade sans version est mal forme' 2 "$U" downgrade outil
dit 'et clia dit ou les voir' 'clia update outil'

rc_dans 'upgrade vers une version inferieure est refuse' 1 "$U" upgrade outil 0.0.9
rc_dans 'upgrade sur une ressource inconnue est refuse' 1 "$U" upgrade bidule

# Une version en première position vise toujours le dépôt, non une ressource.
rc_dans 'une version seule vise le depot' 1 "$U" upgrade 9.9.9
ne_dit_pas 'et non une ressource' 'aucune ressource installée'

# ==========================================================================
titre 'clia -C ROOT_PATH — SES-002 tâche 3'
# ==========================================================================

SORTIE=$("$CLIA" --help 2>/dev/null)
dit 'l option figure dans l aide' '^  -C ROOT_PATH$'
rc 'le manuel la decrit' 0 "$CLIA" --man
dit 'et dit ce qu elle fait' 'Agir comme si l.appel venait de ROOT_PATH'
dit 'et la place avant la commande' '\[-C ROOT_PATH\] <commande>'

# Le même dépôt, vu de deux endroits : les deux réponses doivent coïncider.
DEDANS=$( ( cd "$R" && "$CLIA" ls ) 2>&1 )
DEHORS=$( ( cd "$BAC" && "$CLIA" -C "$R" ls ) 2>&1 )
vrai 'clia -C repond comme si l appel venait de la' test "$DEDANS" = "$DEHORS"

DEDANS_V=$( ( cd "$R" && "$CLIA" version outil ) 2>&1 )
DEHORS_V=$( ( cd "$BAC" && "$CLIA" -C "$R" version outil ) 2>&1 )
vrai 'et pour une ressource aussi' test "$DEDANS_V" = "$DEHORS_V"

# Un chemin relatif est résolu depuis là où l'appel a lieu.
RELATIF=$( ( cd "$BAC" && "$CLIA" -C "$(basename "$R")" ls ) 2>&1 )
vrai 'un chemin relatif repond de meme' test "$RELATIF" = "$DEHORS"

rc '-C sans repertoire est mal forme' 2 "$CLIA" -C
dit 'et clia dit l usage' 'clia -C ROOT_PATH COMMANDE'

rc '-C vers ce qui n est pas un repertoire est refuse' 1 "$CLIA" -C "$BAC/nexiste-pas" ls
dit 'et clia le nomme' "ce n'est pas un répertoire"

# Hors d'un dépôt git, une commande de périmètre « dépôt » est refusée — et
# -C sert justement à en désigner un.
HORS="$BAC/hors-depot"; mkdir -p "$HORS"
rc 'sans -C, hors d un depot, ls est refuse' 1 bash -c "cd '$HORS' && '$CLIA' ls"
dit 'et clia le dit' "n'est pas dans un dépôt git"
rc 'avec -C, il repond' 0 bash -c "cd '$HORS' && '$CLIA' -C '$R' ls"

# ==========================================================================
titre 'Ce que ces commandes n écrivent pas'
# ==========================================================================

AVANT=$(git -C "$D" status --porcelain | sort)
sortie "$D" ls >/dev/null
sortie "$D" update >/dev/null
sortie "$D" version outil >/dev/null
vrai 'ls, update et version n ecrivent rien' \
  test "$(git -C "$D" status --porcelain | sort)" = "$AVANT"

vrai 'le depot reel n a pas bouge' \
  test "$(git -C "$RACINE" status --porcelain | sort)" = "$REEL_ETAT"

bilan
