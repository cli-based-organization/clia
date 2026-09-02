#!/usr/bin/env bash
# _scripts/tests/test_extension.sh — les extensions, et le verbe deactivate.
#
# Éprouve SES-001 tâches 11, 12 et 14.
#
# Ce banc ne dépend d'aucun dépôt voisin : les extensions qu'il éprouve sont
# fabriquées dans le bac. Un banc qui passerait ou échouerait selon ce qui est
# cloné à côté ne mesurerait plus rien.
#
# Le cache est détourné vers le bac par XDG_CACHE_HOME : un banc n'a pas à
# écrire dans le cache de la machine de qui le lance.
#
# Les trois propriétés qui comptent :
#
#   déclarer n'exécute rien. Une extension déclarée et non installée
#   n'apporte aucune commande — c'est ce qui fait que clia n'exécute jamais
#   de code venu d'un dépôt voisin ;
#
#   installer dépose le code dans le dépôt, où il se relit et se commite ;
#
#   deactivate refuse tout ce qui ferait perdre quelque chose.
#
# La tâche 14 y ajoute deux invariants qui ne se voient qu'en les mesurant :
# une reprise n'emporte pas les primitives de l'extension, et une collision
# refuse la reprise entière — pas seulement la ressource qui heurte.

set -uo pipefail

RACINE=$(cd -P "$(dirname "${BASH_SOURCE[0]}")/../.." && pwd)
CLIA="$RACINE/_scripts/bin/clia"

# shellcheck source=banc.sh
. "$RACINE/_scripts/tests/banc.sh"

BAC=$(mktemp -d)
trap 'rm -rf "$BAC"' EXIT

export XDG_CACHE_HOME="$BAC/cache"

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

git_() { git -C "$1" -c user.email=banc@example.invalid -c user.name=banc "${@:2}"; }

depot() {
  local d="$BAC/$1"
  mkdir -p "$d"
  git -C "$d" init -q
  printf 'namespace: exemple.test/%s\nversion: 1.0.0\n' "$1" > "$d/clia.yaml"
  git_ "$d" add -A >/dev/null
  git_ "$d" commit -q -m 'premier commit'
  printf '%s\n' "$d"
}

# Une extension : un dépôt clia portant une ressource et sa commande.
extension() {
  local d="$BAC/$1" prefixe="$2" nom="$3" ns="$4" commande
  commande=$(printf '%s' "$prefixe" | tr '[:upper:]' '[:lower:]')
  mkdir -p "$d/_ressources/$nom/_scripts"
  git -C "$d" init -q
  printf 'namespace: %s\nversion: 0.1.0\n' "$ns" > "$d/clia.yaml"
  cat > "$d/_ressources/$nom/$nom.yaml" <<YAML
nom: $nom
titre: ${nom^}
prefixe: $prefixe
version: 0.2.0

description: "Une ressource de banc."
YAML
  mkdir -p "$d/_ressources/$nom/gabarits" "$d/_ressources/$nom/primitives"
  printf 'un gabarit\n'   > "$d/_ressources/$nom/gabarits/g.md"
  printf 'une primitive\n' > "$d/_ressources/$nom/primitives/p.md"
  cat > "$d/_ressources/$nom/_scripts/$commande.sh" <<SH
#!/usr/bin/env bash
# Description: Une ressource de banc, apportee par une extension.
# Périmètre: aucun
# Signature: $commande dis
set -euo pipefail
printf '%s\n' "\${2:-rien}"
SH
  git_ "$d" add -A >/dev/null
  git_ "$d" commit -q -m 'la ressource'
  printf '%s\n' "$d"
}

# Ajoute une ressource à une extension déjà fabriquée.
ressource_de_plus() {
  local d="$BAC/$1" prefixe="$2" nom="$3"
  mkdir -p "$d/_ressources/$nom"
  cat > "$d/_ressources/$nom/$nom.yaml" <<YAML
nom: $nom
titre: ${nom^}
prefixe: $prefixe
version: 0.1.0

description: "Une deuxième ressource de banc."
YAML
  git_ "$d" add -A >/dev/null
  git_ "$d" commit -q -m "ressource $nom"
}

dans()   { local d="$1"; shift; ( cd "$d" && "$CLIA" "$@" ); }
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

# ==========================================================================
titre 'La commande est decouverte, et documentee'
# ==========================================================================

rc 'clia --help liste extension' 0 "$CLIA" --help
dit 'sous les commandes du noyau' '^  extension  *Les extensions'
ne_dit_pas 'src n existe plus' '^  src '
dit 'source non plus n est plus src' '^  source  *Les sources de données'

# SES-001 tâche 12 : les commandes à trois lettres sont celles des
# ressources, et elles seules.
COURTS=$("$CLIA" --help 2>/dev/null \
  | sed -n '/^Commandes :$/,/^$/p' | sed -nE 's/^  ([a-z-]{1,3}) .*/\1/p')
vrai 'aucune commande du noyau ne tient en trois lettres' test -z "$COURTS"
[[ -n "$COURTS" ]] && printf '         commande fautive : %s\n' "$COURTS"

LONGS=$("$CLIA" --help 2>/dev/null \
  | sed -n '/^Ressources :$/,/^$/p' | sed -nE 's/^  ([a-z-]{4,}) .*/\1/p')
vrai 'et toute commande de ressource y tient' test -z "$LONGS"
[[ -n "$LONGS" ]] && printf '         ressource fautive : %s\n' "$LONGS"

rc 'clia extension --help' 0 "$CLIA" extension --help
dit 'ses trois signatures y sont' 'clia extension add URI'
dit 'ls' 'clia extension ls'
dit 'install' 'clia extension install EXTENSION'
RESTE=$("$CLIA" extension --help 2>/dev/null | lignes_de_prose)
vrai 'et son aide ne porte aucune prose' test -z "$RESTE"
[[ -n "$RESTE" ]] && printf '         ligne fautive : %s\n' "$RESTE"

rc 'clia extension --man' 0 "$CLIA" extension --man
dit 'la page porte son nom' '^CLIA-EXTENSION(1)'
for section in NOM SYNOPSIS DESCRIPTION SOUS-COMMANDES SORTIE \
               'CODE DE RETOUR' FICHIERS EXEMPLES 'VOIR AUSSI'; do
  dit "la section $section y est" "^$section\$"
done
LONGUES=$("$CLIA" extension --man 2>/dev/null | lignes_trop_longues)
vrai 'aucune ligne du manuel ne depasse 80 colonnes' test -z "$LONGUES"
[[ -n "$LONGUES" ]] && printf '         ligne fautive : %s\n' "$LONGUES"

HORS="$BAC/hors-depot"; mkdir -p "$HORS"
rc 'le manuel repond hors d un depot' 0 bash -c "cd '$HORS' && '$CLIA' extension --man"
rc 'mais le travail exige un depot' 1 bash -c "cd '$HORS' && '$CLIA' extension ls"

# ==========================================================================
titre 'Ajouter une extension locale'
# ==========================================================================

D=$(depot travail)
EXT_A=$(extension ext-a SES session 'session.exemple.test/ext-a')

rc_dans 'un depot sans extension le dit' 0 "$D" extension ls
dit 'et nomme la commande qui en ajoute une' 'clia extension add URI'

rc_dans 'clia extension add est satisfaite' 0 "$D" extension add ../ext-a
dit 'et elle nomme l extension par le namespace qu elle declare' 'session.exemple.test/ext-a'
dit 'et dit que rien n est installe' "rien n'est installé"

vrai 'la source est inscrite dans la carte' \
  grep -q 'provider: session.exemple.test/ext-a' "$D/clia.yaml"
vrai 'avec son type' grep -q '    type: local' "$D/clia.yaml"
vrai 'et son uri telle qu elle a ete donnee' grep -q '    uri: \.\./ext-a' "$D/clia.yaml"
vrai 'la declaration ne commite rien' test -n "$(git -C "$D" status --porcelain)"

rc_dans 'la redeclarer ne change rien' 0 "$D" extension add ../ext-a
dit 'et clia le dit' 'déjà déclarée'
vrai 'la carte ne porte qu une entree' \
  test "$(grep -c 'provider: session.exemple.test/ext-a' "$D/clia.yaml")" -eq 1

SORTIE=$(sortie "$D" extension ls)
dit 'l en-tete nomme les colonnes' '^EXTENSION *ETAT *RESSOURCES *URI$'
dit 'l extension y figure, avec ce qu elle offre' 'session.exemple.test/ext-a *extension *SES'

# ==========================================================================
titre 'Declarer n installe rien'
# ==========================================================================
#
# C'est ce qui fait que clia n'exécute jamais de code venu d'un dépôt voisin.

SORTIE=$(dans "$D" --help 2>&1)
ne_dit_pas 'la commande de l extension n est pas encore la' '^  ses '
rc_dans 'et elle ne repond pas' 2 "$D" ses dis bonjour
dit 'clia dit qu il ne la connait pas' 'commande inconnue'

# ==========================================================================
titre 'Ce que add refuse'
# ==========================================================================

ORDINAIRE="$BAC/ordinaire"; mkdir -p "$ORDINAIRE"; git -C "$ORDINAIRE" init -q
rc_dans 'un depot sans carte clia est refuse' 1 "$D" extension add ../ordinaire
dit 'et clia dit pourquoi' "n'est pas un dépôt clia"

depot nu >/dev/null
rc_dans 'un depot clia sans ressource est refuse' 1 "$D" extension add ../nu
dit 'et clia renvoie vers source add' 'clia source add'

INVITE="$BAC/invite"; mkdir -p "$INVITE"; git -C "$INVITE" init -q
printf 'namespace: <publisher>/invite\nversion: 0.1.0\n' > "$INVITE/clia.yaml"
mkdir -p "$INVITE/_ressources"
rc_dans 'un namespace resté une invite est refuse' 1 "$D" extension add ../invite
dit 'et clia dit ce qui manque' 'namespace'

rc_dans 'une uri qui ne mene nulle part est refusee' 1 "$D" extension add ../nulle-part
dit 'le clone est tente, et il echoue' 'le clone a échoué'
vrai 'et rien n est declare' \
  test "$(grep -c 'nulle-part' "$D/clia.yaml")" -eq 0

rc_dans 'add sans uri est mal forme' 2 "$D" extension add
rc_dans 'add avec deux uri est mal forme' 2 "$D" extension add a b
rc_dans 'un verbe inconnu est mal forme' 2 "$D" extension bidule
rc_dans 'extension sans verbe est mal forme' 2 "$D" extension

# ==========================================================================
titre 'Ajouter une extension distante'
# ==========================================================================

extension ext-b SES session 'b.exemple.test/ext-b' >/dev/null

DIST=$(extension ext-dist LOG journal 'journal.exemple.test/ext-dist')
G=$(depot avec-distant)

rc_dans 'clia extension add clone un depot distant' 0 "$G" extension add "file://$DIST"
dit 'et dit ou le clone est pose' "$XDG_CACHE_HOME/clia/extensions"
vrai 'le clone est dans le cache, hors du depot' \
  test -f "$XDG_CACHE_HOME/clia/extensions/journal.exemple.test/ext-dist/clia.yaml"
vrai 'la carte porte le type git' grep -q '    type: git' "$G/clia.yaml"
vrai 'et l uri distante, non le chemin du cache' grep -q "uri: file://$DIST" "$G/clia.yaml"
vrai 'rien du clone n entre dans le depot' \
  test ! -e "$G/.clia" -a ! -e "$G/_ressources"

SORTIE=$(sortie "$G" extension ls)
dit 'ls la voit par son clone' 'journal.exemple.test/ext-dist *extension *LOG'

VIDE_G="$BAC/vide-git"; mkdir -p "$VIDE_G"; git -C "$VIDE_G" init -q
rc_dans 'un depot sans commit est refuse' 1 "$G" extension add "file://$VIDE_G"
dit 'et clia distingue ce cas de l autre' "aucun commit"

# ==========================================================================
titre 'Installer une extension'
# ==========================================================================

rc_dans 'clia extension install est satisfaite' 0 "$D" extension install session.exemple.test/ext-a
dit 'et elle nomme ce qu elle a repris' 'reprise : session'
dit 'et dit que rien n est commite' "rien n'est commité"

vrai 'la ressource est copiee dans le depot' test -d "$D/_ressources/session"
vrai 'avec sa definition' test -f "$D/_ressources/session/session.yaml"
vrai 'et son script' test -f "$D/_ressources/session/_scripts/ses.sh"
vrai 'la sortie standard porte le chemin repris' \
  test "$(sortie "$D" extension ls >/dev/null; true)" = ''

vrai 'l inventaire de la carte l inscrit' \
  grep -q 'resource: session.exemple.test/ext-a/SES' "$D/clia.yaml"
vrai 'avec la version de la ressource, non celle du depot' \
  test "$(grep -A1 'resource: session.exemple.test/ext-a/SES' "$D/clia.yaml" | tail -1)" = '    version: 0.2.0'

rc_dans 'et sa commande repond maintenant' 0 "$D" ses dis bonjour
dit 'c est bien elle qui a repondu' '^bonjour$'

SORTIE=$(dans "$D" --help 2>&1)
dit 'elle figure dans l aide, sous les ressources' '^  ses  *Une ressource de banc'

SORTIE=$(sortie "$D" extension ls)
dit 'ls marque ce qui a ete repris' '\[SES\]'

# ==========================================================================
titre 'La reprise laisse les primitives de l extension'
# ==========================================================================
#
# SES-001 tâche 14. Le comment appartient à l'extension et se reprend ; les
# primitives appartiennent au dépôt qui les écrit.

vrai 'le script est repris' test -f "$D/_ressources/session/_scripts/ses.sh"
vrai 'les gabarits aussi' test -f "$D/_ressources/session/gabarits/g.md"
vrai 'la definition aussi' test -f "$D/_ressources/session/session.yaml"
vrai 'mais pas les primitives' test ! -e "$D/_ressources/session/primitives"
vrai 'elles sont restees dans l extension' test -f "$EXT_A/_ressources/session/primitives/p.md"

NEUF=$(depot primitives)
dans "$NEUF" extension add ../ext-a >/dev/null 2>&1
rc_dans 'et clia le dit en reprenant' 0 "$NEUF" extension install ext-a
dit 'sans leurs primitives' 'sans leurs primitives'
vrai 'la reprise n en porte aucune' test ! -e "$NEUF/_ressources/session/primitives"

# ==========================================================================
titre 'Les collisions de nom et de prefixe sont refusees'
# ==========================================================================

rc_dans 'reinstaller heurte le nom deja pris' 1 "$D" extension install session.exemple.test/ext-a
dit 'et clia nomme le heurt' 'une ressource de ce nom est déjà là'
dit 'et dit que rien n a ete repris' "rien n'a été repris"
vrai 'l inventaire ne double pas' \
  test "$(grep -c 'resource: session.exemple.test/ext-a/SES' "$D/clia.yaml")" -eq 1

# Un préfixe déjà pris, sous un autre nom.
extension ext-pref SES reunion 'pref.exemple.test/ext-pref' >/dev/null
P=$(depot prefixe)
dans "$P" extension add ../ext-a >/dev/null 2>&1
dans "$P" extension install ext-a >/dev/null 2>&1
dans "$P" extension add ../ext-pref >/dev/null 2>&1
rc_dans 'un prefixe deja pris est refuse' 1 "$P" extension install ext-pref
dit 'en nommant qui le porte' 'le préfixe SES est déjà celui de session'
vrai 'et la ressource n a pas ete posee' test ! -e "$P/_ressources/reunion"

# Une seule collision suffit à tout refuser : pas de reprise à moitié.
ressource_de_plus ext-b LIB libre
B=$(depot partielle)
dans "$B" extension add ../ext-b >/dev/null 2>&1
mkdir -p "$B/_ressources/session"
printf 'nom: session\ntitre: Session\nprefixe: ZZZ\nversion: 0.1.0\n' \
  > "$B/_ressources/session/session.yaml"
rc_dans 'une seule collision refuse toute la reprise' 1 "$B" extension install ext-b
dit 'en nommant celle qui heurte' 'session : une ressource de ce nom'
vrai 'et celle qui ne heurtait rien n est pas posee non plus' \
  test ! -e "$B/_ressources/libre"

# Une carte écrite à la main déclare parfois la ressource avant qu'elle soit
# là. L'inventaire ne doit pas la porter deux fois pour autant.
AVANCE=$(depot inventaire-avance)
dans "$AVANCE" extension add ../ext-a >/dev/null 2>&1
printf '\nuse:\n  extensions:\n  - resource: session.exemple.test/ext-a/SES\n    version: 0.1.0\n' \
  >> "$AVANCE/clia.yaml"
rc_dans 'installer une ressource deja inscrite est satisfait' 0 "$AVANCE" extension install ext-a
vrai 'la ressource est bien reprise' test -d "$AVANCE/_ressources/session"
vrai 'et l inventaire ne la porte qu une fois' \
  test "$(grep -c 'session.exemple.test/ext-a/SES' "$AVANCE/clia.yaml")" -eq 1

rc_dans 'une extension inconnue est refusee' 1 "$D" extension install inexistante
dit 'et clia renvoie a la liste' 'clia extension ls'
rc_dans 'install sans extension est mal forme' 2 "$D" extension install

# ==========================================================================
titre 'Le verbe deactivate, que toutes les ressources portent'
# ==========================================================================

rc_dans 'il figure dans l aide de la ressource' 0 "$D" ses --help
dit 'sans avoir ete declare par son script' 'clia ses deactivate'

rc_dans 'une ressource non commitee n est pas effacee' 1 "$D" ses deactivate
dit 'et clia dit pourquoi' "git ne tient pas encore"
vrai 'elle est toujours la' test -d "$D/_ressources/session"

git_ "$D" add -A >/dev/null; git_ "$D" commit -q -m 'reprend session'

rc_dans 'une ressource commitee se retire' 0 "$D" ses deactivate
dit 'et clia dit ce qu il a retire' 'retirée de ce dépôt'
vrai 'le repertoire est parti' test ! -e "$D/_ressources/session"
vrai 'et l inventaire aussi' \
  test "$(grep -c 'resource: session.exemple.test/ext-a/SES' "$D/clia.yaml")" -eq 0
vrai 'la declaration de la source, elle, reste' \
  grep -q 'provider: session.exemple.test/ext-a' "$D/clia.yaml"

rc_dans 'sa commande ne repond plus' 2 "$D" ses dis bonjour
rc_dans 'et elle se reprend' 0 "$D" extension install ext-a
vrai 'la ressource est revenue' test -d "$D/_ressources/session"

# Ce que le dépôt publie ne se désinstalle pas.
rc 'une ressource que le depot publie est protegee' 1 "$CLIA" res deactivate
dit 'et clia dit pourquoi' 'que ce dépôt publie'
vrai 'elle est intacte' test -d "$RACINE/_ressources/ressource"

# Une ressource du dépôt source de clia n'est installée nulle part ailleurs.
rc_dans 'une ressource du CLI n est pas installee dans un autre depot' 1 "$D" res deactivate
dit 'et clia dit d ou elle vient' "n'est pas installée dans ce dépôt"

rc_dans 'deactivate ne prend pas d argument' 2 "$D" ses deactivate trop

# ==========================================================================
titre 'Desinstaller une extension'
# ==========================================================================

U=$(depot desinstallation)
dans "$U" extension add ../ext-b >/dev/null 2>&1
rc_dans 'une extension a deux ressources est reprise' 0 "$U" extension install ext-b
vrai 'les deux sont la' \
  test -d "$U/_ressources/session" -a -d "$U/_ressources/libre"
vrai 'et l inventaire les porte' \
  test "$(grep -c 'resource: b.exemple.test/ext-b/' "$U/clia.yaml")" -eq 2

rc_dans 'desinstaller ce qui n est pas commite est refuse' 1 "$U" extension uninstall ext-b
dit 'et clia dit pourquoi' "git ne tient pas encore"
dit 'et que rien n a ete retire' "rien n'a été retiré"
vrai 'les deux sont toujours la' \
  test -d "$U/_ressources/session" -a -d "$U/_ressources/libre"

git_ "$U" add -A >/dev/null; git_ "$U" commit -q -m 'reprend ext-b'

rc_dans 'clia extension uninstall est satisfaite' 0 "$U" extension uninstall ext-b
dit 'elle nomme ce qu elle retire' 'retirée : session'
dit 'et compte ce qui est parti' '2 ressource(s) retirée(s)'
dit 'et dit que rien n est commite' "rien n'est commité"

vrai 'les deux repertoires sont partis' \
  test ! -e "$U/_ressources/session" -a ! -e "$U/_ressources/libre"
vrai 'l inventaire ne les porte plus' \
  test "$(grep -c 'resource: b.exemple.test/ext-b/' "$U/clia.yaml")" -eq 0
vrai 'la declaration de source, elle, reste' \
  grep -q 'provider: b.exemple.test/ext-b' "$U/clia.yaml"
rc_dans 'la commande de l extension ne repond plus' 2 "$U" ses dis bonjour

rc_dans 'et elle se reprend' 0 "$U" extension install ext-b
vrai 'les deux ressources sont revenues' \
  test -d "$U/_ressources/session" -a -d "$U/_ressources/libre"

# Une entrée d'inventaire dont la ressource a été retirée à la main.
git_ "$U" add -A >/dev/null; git_ "$U" commit -q -m 'reprend a nouveau'
rm -rf "$U/_ressources/libre"
git_ "$U" add -A >/dev/null; git_ "$U" commit -q -m 'retire libre a la main'
rc_dans 'une entree orpheline est retiree et signalee' 0 "$U" extension uninstall ext-b
dit 'clia dit que sa ressource n etait plus la' "était à l'inventaire"
vrai 'et l inventaire est net' \
  test "$(grep -c 'resource: b.exemple.test/ext-b/' "$U/clia.yaml")" -eq 0

rc_dans 'desinstaller ce qui n a jamais ete repris est refuse' 1 "$U" extension uninstall ext-b
dit 'et clia le dit' "rien n'a été repris"

# Ce que le dépôt publie n'est pas retiré par une désinstallation.
PUB=$(depot publiee)
dans "$PUB" extension add ../ext-a >/dev/null 2>&1
dans "$PUB" extension install ext-a >/dev/null 2>&1
git_ "$PUB" add -A >/dev/null; git_ "$PUB" commit -q -m 'reprend ext-a'
printf '\nprovide:\n  - prefix: SES\n    name: session\n' >> "$PUB/clia.yaml"
rc_dans 'une ressource publiee par le depot est protegee' 1 "$PUB" extension uninstall ext-a
dit 'et clia dit pourquoi' 'que ce dépôt publie'
vrai 'elle est intacte' test -d "$PUB/_ressources/session"

rc_dans 'uninstall sans extension est mal forme' 2 "$U" extension uninstall
rc_dans 'uninstall avec deux extensions est mal forme' 2 "$U" extension uninstall a b
rc_dans 'une extension inconnue est refusee' 1 "$U" extension uninstall inexistante

# ==========================================================================
titre 'Une ressource reprise ne masque ni le noyau, ni le CLI'
# ==========================================================================

USURPE=$(extension ext-usurpe VER version 'usurpe.exemple.test/ext-usurpe')
cat > "$USURPE/_ressources/version/_scripts/version.sh" <<'SH'
#!/usr/bin/env bash
# Description: Une ressource qui tente de masquer le noyau.
# Périmètre: aucun
# Signature: version usurpee
set -euo pipefail
printf 'usurpee\n'
SH
git_ "$USURPE" add -A >/dev/null; git_ "$USURPE" commit -q -m 'usurpation'

M=$(depot masque)
dans "$M" extension add ../ext-usurpe >/dev/null 2>&1
dans "$M" extension install usurpe.exemple.test/ext-usurpe >/dev/null 2>&1
vrai 'la ressource a bien ete reprise' test -d "$M/_ressources/version"
SORTIE=$(dans "$M" version 2>&1)
ne_dit_pas 'et pourtant le noyau repond' '^usurpee$'

# ==========================================================================
titre 'Une source declaree qui ne mene a rien ne bloque rien'
# ==========================================================================

C=$(depot casse)
dans "$C" extension add ../ext-a >/dev/null 2>&1
printf '  - provider: fantome.test\n    type: local\n    uri: ../nulle-part\n' >> "$C/clia.yaml"
rc_dans 'le travail continue' 0 "$C" version
rc_dans 'et l aide aussi' 0 "$C" --help
rc_dans 'ls la montre pour ce qu elle est' 0 "$C" extension ls
dit 'absente' 'fantome.test *absente'

# ==========================================================================
titre 'Le depot reel n a pas bouge'
# ==========================================================================

vrai 'son etat de travail est le meme qu au depart' \
  test "$(git -C "$RACINE" status --porcelain | sort)" = "$REEL_ETAT"

bilan
