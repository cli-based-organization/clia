#!/usr/bin/env bash
# _scripts/tests/test_stade.sh — les stades d'une ressource, et ses primitives.
#
# Éprouve SES-001 tâche 22 : les verbes « prim » et « zone », que le point
# d'entrée tient pour toutes les ressources.
#
# Ce que le banc mesure, et qui n'irait pas de soi :
#
#   ce qui se déduit du fichier — l'identifiant, l'ordre, la structure — ne
#   se déclare pas, et « set » le refuse. Une déclaration qui contredit le
#   fichier est un écart, non une variante ;
#
#   une primitive de premier ordre est écrite par un humain, et rien ne
#   permet de déclarer le contraire — SPC-001 §1.4 ;
#
#   « set » écrit dans la primitive elle-même : frontmatter d'un markdown,
#   tête d'un YAML. Un fichier qui n'a nulle part où le mettre est refusé,
#   et non doté d'un fichier voisin qui pourrait mentir ;
#
#   chaque contrôle de « prim check » échoue pour sa propre raison.

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

# Un dépôt qui écrit la ressource « outil », et l'a installée.
depot() {
  local d="$BAC/$1"
  mkdir -p "$d/$INST/$ID/primitive-1" "$d/$INST/$ID/primitive-2" \
           "$d/$INST/$ID/livrables/_scripts"
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
  mkdir -p "$d/$LIVREE"
  cp -r "$d/$INST/$ID/livrables" "$d/$LIVREE/outil"
  git_ "$d" add -A >/dev/null
  git_ "$d" commit -q -m 'outil 0.1.0'
  printf '%s\n' "$d"
}

# Une primitive de premier ordre, écrite par un humain.
prim1() {
  cat > "$1/$INST/$ID/primitive-1/$2" <<'MD'
---
titre: "Un énoncé"
---

Ce que quelqu'un a décidé.
MD
}

# Une primitive de deuxième ordre.
prim2() {
  cat > "$1/$INST/$ID/primitive-2/$2" <<'MD'
---
titre: "Ce qui en est tiré"
---

Ce qu'un agent en a fait.
MD
}

# ==========================================================================
titre 'Les verbes sont tenus pour toutes les ressources, et documentés'
# ==========================================================================

SORTIE=$("$CLIA" res --help 2>/dev/null)
dit 'prim figure dans l aide d une ressource' 'clia res prim ls \[-1 | -2\]'
dit 'et ses trois autres formes' 'clia res prim IDENTIFIANT set CLE VALEUR'
dit 'zone aussi' 'clia res zone ls'
SORTIE=$("$CLIA" hrn --help 2>/dev/null)
dit 'et dans celle d une autre, sans qu elle l ait declare' 'clia hrn prim check'

rc 'le manuel de clia les decrit' 0 "$CLIA" --man
dit 'il compte neuf verbes' 'Neuf verbes valent pour toute commande'
dit 'il dit ce qui se declare' 'origine.*depot, externe'
dit 'et ce qui se deduit' 'se déduisent du fichier'

# ==========================================================================
titre 'clia RESSOURCE prim ls'
# ==========================================================================

D=$(depot lecture)
prim1 "$D" 'ENO-001-un-enonce.md'
prim2 "$D" 'SPC-001-ce-qui-en-vient.md'
printf 'a,b\n1,2\n' > "$D/$INST/$ID/primitive-2/DAT-001-mesures.csv"
printf 'cle: valeur\n' > "$D/$INST/$ID/primitive-2/CFG-001-reglages.yaml"

rc_dans 'prim ls repond' 0 "$D" out prim ls
dit 'l en-tete nomme les colonnes' '^IDENTIFIANT .*ORDRE .*STRUCTURE .*ORIGINE .*EDITEUR .*FICHIER$'
dit 'un markdown est semi-structure' '^SPC-001 *2 *semi-structurée'
dit 'un csv est structure' '^DAT-001 *2 *structurée'
dit 'un yaml aussi' '^CFG-001 *2 *structurée'
dit 'l origine vaut depot par defaut' 'SPC-001 .*depot'
dit 'une primitive d ordre 1 est ecrite par un humain' '^ENO-001 *1 .*humain'
dit 'une primitive d ordre 2 sans declaration ne dit pas qui l ecrit' '^SPC-001 .*—'

rc_dans 'prim ls -1 ne rend que le premier ordre' 0 "$D" out prim ls -1
dit 'il porte l enonce' 'ENO-001'
ne_dit_pas 'et pas ce qui en vient' 'SPC-001'

rc_dans 'prim ls -2 ne rend que le second' 0 "$D" out prim ls -2
dit 'il porte ce qui en vient' 'SPC-001'
ne_dit_pas 'et pas l enonce' 'ENO-001'

rc_dans 'un argument inattendu est mal forme' 2 "$D" out prim ls --bidule

V=$(depot vide)
rc_dans 'une instance sans primitive le dit' 0 "$V" out prim ls
dit 'et nomme les repertoires' 'primitive-1 et primitive-2'

# ==========================================================================
titre 'clia RESSOURCE prim IDENTIFIANT ls'
# ==========================================================================

rc_dans 'une primitive designee repond' 0 "$D" out prim SPC-001 ls
dit 'elle nomme son fichier' 'fichier      primitive-2/SPC-001-ce-qui-en-vient\.md'
dit 'l ordre est dit deduit' 'ordre        2  (déduit du répertoire)'
dit 'la structure aussi' 'structure    semi-structurée  (déduite'
dit 'l origine est dite par defaut' 'origine      depot  (par défaut)'
dit 'et l editeur non declare' 'editeur      —  (non déclarée)'

rc_dans 'a l ordre 1, l editeur vient de la definition' 0 "$D" out prim ENO-001 ls
dit 'et clia dit pourquoi' 'humain, par définition'

rc_dans 'un identifiant inconnu est refuse' 1 "$D" out prim ZZZ-999 ls
dit 'et clia renvoie vers la liste' 'clia out prim ls'

# ==========================================================================
titre 'clia RESSOURCE prim IDENTIFIANT set'
# ==========================================================================

rc_dans 'poser l editeur d une primitive d ordre 2' 0 "$D" out prim SPC-001 set editeur agent
dit 'clia dit ce qu il a pose' 'SPC-001 : editeur = agent'
dit 'et qu il ne commite rien' "rien n'est commité"
SORTIE=$(sortie "$D" out prim SPC-001 ls)
dit 'la valeur est relue depuis le fichier' 'editeur      agent  (déclarée)'
vrai 'elle est dans le frontmatter du fichier' \
  grep -q '^editeur: agent$' "$D/$INST/$ID/primitive-2/SPC-001-ce-qui-en-vient.md"

rc_dans 'poser l origine' 0 "$D" out prim SPC-001 set origine externe
SORTIE=$(sortie "$D" out prim ls)
dit 'elle est rendue' 'SPC-001 .*externe'

rc_dans 'un yaml declare en tete' 0 "$D" out prim CFG-001 set editeur automatisme
vrai 'la cle est posee avant le reste' \
  test "$(head -1 "$D/$INST/$ID/primitive-2/CFG-001-reglages.yaml")" = 'cle: valeur'
vrai 'et le fichier la porte' \
  grep -q '^editeur: automatisme$' "$D/$INST/$ID/primitive-2/CFG-001-reglages.yaml"

rc_dans 'un csv ne peut rien porter' 1 "$D" out prim DAT-001 set editeur agent
dit 'et clia dit pourquoi' 'ne peut porter aucune déclaration'

rc_dans 'ce qui se deduit ne se declare pas' 2 "$D" out prim SPC-001 set ordre 1
dit 'et clia nomme ce qui se declare' 'déclarables : origine editeur'

rc_dans 'une valeur inconnue est refusee' 2 "$D" out prim SPC-001 set editeur bidule
dit 'et clia nomme les valeurs admises' 'valeurs admises : humain agent automatisme'

rc_dans 'un ordre 1 ne se declare pas ecrit par un agent' 1 "$D" out prim ENO-001 set editeur agent
dit 'et clia dit d ou vient la regle' 'SPC-001 §1.4'
dit 'et ce qu il faudrait faire' "elle est d'ordre 2 — déplacez-la"

rc_dans 'set attend une cle et une valeur' 2 "$D" out prim SPC-001 set editeur

# Un markdown sans frontmatter en reçoit un.
printf 'Rien que du texte.\n' > "$D/$INST/$ID/primitive-2/TXT-001-brut.md"
rc_dans 'un markdown sans frontmatter en recoit un' 0 "$D" out prim TXT-001 set editeur humain
dit 'et clia le dit' 'un frontmatter a été posé'
vrai 'le texte est conserve' \
  grep -q '^Rien que du texte\.$' "$D/$INST/$ID/primitive-2/TXT-001-brut.md"
rm -f "$D/$INST/$ID/primitive-2/TXT-001-brut.md"

# ==========================================================================
titre 'clia RESSOURCE prim check'
# ==========================================================================

C=$(depot conforme)
prim1 "$C" 'ENO-001-un-enonce.md'
prim2 "$C" 'SPC-001-ce-qui-en-vient.md'
rc_dans 'prim check repond' 0 "$C" out prim check
dit 'il compte les primitives' '^primitives 2$'
dit 'P1 passe' '^P1  ok'
dit 'P2 passe' '^P2  ok'
dit 'P3 passe' '^P3  ok'
dit 'P4 passe' '^P4  ok'
dit 'P5 signale l ordre 2 sans editeur' '^P5  --  ordre 2 sans éditeur déclaré : SPC-001'
dit 'et la conclusion compte les signalements' 'conforme, avec 1 signalement'

( cd "$C" && "$CLIA" out prim SPC-001 set editeur agent >/dev/null 2>&1 )
rc_dans 'declare, P5 passe' 0 "$C" out prim check
dit 'et l instance est conforme' ': conforme$'

P1=$(depot p1)
prim2 "$P1" 'SPC-001-bon.md'
printf 'x\n' > "$P1/$INST/$ID/primitive-2/notes-en-vrac.md"
rc_dans 'un nom sans identifiant est bloquant' 1 "$P1" out prim check
dit 'et clia le nomme' '^P1  !!  .*notes-en-vrac\.md'

P2=$(depot p2)
prim2 "$P2" 'SPC-001-un.md'
prim1 "$P2" 'SPC-001-deux.md'
rc_dans 'un identifiant porte deux fois est bloquant' 1 "$P2" out prim check
dit 'et clia le nomme' '^P2  !!  .*SPC-001'

P3=$(depot p3)
prim2 "$P3" 'SPC-001-bon.md'
printf 'a,b\n' > "$P3/$INST/$ID/primitive-2/DAT-001-mesures.csv"
rc_dans 'une primitive sans place pour declarer est signalee' 0 "$P3" out prim check
dit 'et clia la nomme' '^P3  --  .*DAT-001'

P4=$(depot p4)
prim2 "$P4" 'SPC-001-bon.md'
( cd "$P4" && "$CLIA" out prim SPC-001 set editeur agent >/dev/null 2>&1 )
printf -- '---\ntitre: "x"\nordre: 1\nediteur: agent\n---\n\ntexte\n' \
  > "$P4/$INST/$ID/primitive-2/SPC-002-menteuse.md"
rc_dans 'un ordre declare qui contredit le repertoire est bloquant' 1 "$P4" out prim check
dit 'et clia dit ce qui est contredit' '^P4  !!  .*SPC-002:ordre=1'

P5=$(depot p5)
prim1 "$P5" 'ENO-001-un-enonce.md'
printf -- '---\ntitre: "x"\nediteur: agent\n---\n\ntexte\n' \
  > "$P5/$INST/$ID/primitive-1/ENO-002-usurpee.md"
rc_dans 'un ordre 1 qui se dit ecrit par un agent est bloquant' 1 "$P5" out prim check
dit 'et clia le nomme' '^P5  !!  .*ENO-002'

rc_dans 'check sur une primitive designee' 0 "$C" out prim check SPC-001
dit 'il n en compte qu une' '^primitives 1$'
rc_dans 'un identifiant mal forme est refuse' 2 "$C" out prim check bidule

# ==========================================================================
titre 'Une ressource que le dépôt n écrit pas'
# ==========================================================================

I=$(depot installee)
rm -rf "${I:?}/$INST"
git_ "$I" add -A >/dev/null; git_ "$I" commit -q -m 'plus que la copie installee'
rc_dans 'prim refuse, faute d instance' 1 "$I" out prim ls
dit 'et clia dit pourquoi' "il n'en porte aucune primitive"

# ==========================================================================
titre 'clia RESSOURCE zone ls'
# ==========================================================================

rc_dans 'zone ls repond' 0 "$D" out zone ls
dit 'l en-tete nomme les colonnes' '^STADE .*ZONE .*ETAT$'
dit 'l instance y est' '^ressource .*\.dev/ressources/RES-001-outil .*présente'
dit 'les deux ordres de primitives aussi' '^primitive-2 .*primitive-2 .*présente'
dit 'le stade genere a sa zone' '^générée .*genere .*absente'
dit 'le livrable y est' '^livrée .*livrables .*présente'
dit 'et la copie installee' '^installée .*\.clia/ressources/outil .*présente'

rc_dans 'le filtre --delivered restreint' 0 "$D" out zone ls --delivered
dit 'il ne rend que la livraison' '^livrée '
ne_dit_pas 'et pas les primitives' '^primitive-1 '

rc_dans 'le filtre --ressource porte l instance et ses primitives' 0 "$D" out zone ls --ressource
dit 'il rend l instance' '^ressource '
dit 'et ses primitives' '^primitive-1 '
ne_dit_pas 'et pas la livraison' '^livrée '

rc_dans 'zone ls situe une primitive' 0 "$D" out zone ls SPC-001
dit 'et dit son stade' '^primitive-2 .*SPC-001-ce-qui-en-vient\.md'

rc_dans 'zone attend ls' 2 "$D" out zone
rc_dans 'une option inconnue est mal formee' 2 "$D" out zone ls --bidule

rc_dans 'sans instance, zone ls repond quand meme' 0 "$I" out zone ls
dit 'et dit que le depot n ecrit pas la ressource' "n'écrit pas cette ressource"
dit 'la copie installee reste situee' '^installée '

# ==========================================================================
titre 'Le dépôt réel n a pas bougé'
# ==========================================================================

rc 'zone ls n ecrit rien sur le depot reel' 0 "$CLIA" res zone ls
vrai 'son etat de travail est le meme qu au depart' \
  test "$(git -C "$RACINE" status --porcelain | sort)" = "$REEL_ETAT"

bilan
