#!/usr/bin/env bash
# _scripts/tests/test_upgrade.sh — banc de USE-007, la mise à jour des
# ressources et des extensions.
#
# Une mise à jour se juge sur trois choses, et le banc les sépare : ce que la
# commande dit, ce que le disque devient, et ce que l'inventaire garde. Une
# reprise qui ne réinscrit pas sa version ferait mentir clia check ; une
# reprise qui écrase une copie modifiée perdrait du travail sans le dire.
#
# La fixture est une extension jetable dont la ressource a trois versions
# commitées : c'est le seul moyen d'avoir un historique à interroger, puisque
# « les versions disponibles » sont lues dans l'historique git de la
# provenance et nulle part ailleurs.
#
# Comme les autres bancs, celui-ci n'écrit que sous /tmp, jamais dans le dépôt
# clia — c'est vérifié au démarrage et en clôture.
#
# Lancement :  bash _scripts/tests/test_upgrade.sh

set -uo pipefail

RACINE=$(cd -P "$(dirname "${BASH_SOURCE[0]}")/../.." >/dev/null 2>&1 && pwd)

# shellcheck source=banc.sh
. "$(dirname "${BASH_SOURCE[0]}")/banc.sh"

BAC=$(mktemp -d) || exit 1
trap 'rm -rf "$BAC"' EXIT

case "$BAC" in
  /tmp/*|/var/tmp/*) ;;
  *) printf 'banc: le bac n%st pas sous /tmp : %s\n' "'es" "$BAC" >&2; exit 1 ;;
esac

export HOME="$BAC/home"
export XDG_CACHE_HOME="$HOME/.cache"
mkdir -p "$HOME"

SOURCE="$BAC/source"
mkdir -p "$SOURCE/.dev"
cp -r "$RACINE/_scripts" "$RACINE/_ressources" "$SOURCE/"
cp "$RACINE/.dev/clia.yaml" "$SOURCE/.dev/clia.yaml"
CLIA="$SOURCE/_scripts/bin/clia"

EMPREINTE_SOURCE=$(cd "$RACINE" && git status --porcelain 2>/dev/null | sort)
TETE_REELLE=$(cd "$RACINE" && git rev-parse HEAD 2>/dev/null || printf '')

# Un commit dans un dépôt jetable. Jamais ailleurs : le chemin est vérifié.
commiter() {
  local d="$1" message="$2"
  [[ "$d" == "$BAC"/* ]] || { printf 'banc: commit hors du bac : %s\n' "$d" >&2; exit 1; }
  git -C "$d" -c user.email='banc@example.invalid' -c user.name='banc' add -A
  git -C "$d" -c user.email='banc@example.invalid' -c user.name='banc' commit -q -m "$message"
}

# L'extension de fixture : une ressource « labo » en 0.1.0, puis 0.2.0 avec un
# script de migration, puis 0.3.0 sans script — les trois cas que la migration
# doit distinguer.
fabriquer_extension() {
  local d="$BAC/labo"
  "$CLIA" init "$d" >/dev/null 2>&1 || return 1
  sed -i 's|^namespace: .*|namespace: acme.com/labo|' "$d/.dev/clia.yaml"
  ( cd "$d" && "$CLIA" res new LAB labo 'Ressource du banc.' >/dev/null 2>&1 )
  sed -i 's|^emplacement: .*|emplacement: .dev/labos/LAB-<SEQ>-<SLUG>.md|' \
    "$d/_ressources/labo/schemas/labo.yaml"
  mkdir -p "$d/_ressources/labo/templates"
  printf -- '---\ntype: labo\nid: LAB-{{seq}}\nversion: 0.1.0\n---\n\ncorps v1\n' \
    > "$d/_ressources/labo/templates/labo.template.md"
  commiter "$d" 'labo 0.1.0'

  sed -i 's|^version: 0.1.0$|version: 0.2.0|' "$d/_ressources/labo/schemas/labo.yaml"
  printf -- '---\ntype: labo\nid: LAB-{{seq}}\nversion: 0.2.0\nstatut: actif\n---\n\ncorps v2\n' \
    > "$d/_ressources/labo/templates/labo.template.md"
  mkdir -p "$d/_ressources/labo/scripts/migrations"
  cat > "$d/_ressources/labo/scripts/migrations/0.2.0.sh" <<'EOF'
#!/usr/bin/env bash
# Ajoute le champ statut au frontmatter d'une instance de labo.
set -euo pipefail
grep -q '^statut:' "$1" || sed -i '2i statut: actif' "$1"
EOF
  commiter "$d" 'labo 0.2.0'

  sed -i 's|^version: 0.2.0$|version: 0.3.0|' "$d/_ressources/labo/schemas/labo.yaml"
  commiter "$d" 'labo 0.3.0'
  printf '%s\n' "$d"
}

# Un dépôt neuf qui a repris la ressource, à chaque section : les dérives
# fabriquées ici ne doivent pas se transmettre d'un cas au suivant.
neuf() {
  local d="$BAC/$1"
  rm -rf "$d"
  "$CLIA" init "$d" >/dev/null 2>&1 || return 1
  ( cd "$d" && "$CLIA" extension add "$EXT" >/dev/null 2>&1 ) || return 1
  ( cd "$d" && "$CLIA" res activate labo >/dev/null 2>&1 ) || return 1
  printf '%s\n' "$d"
}

instance() {
  local d="$1" v="$2"
  mkdir -p "$d/.dev/labos"
  printf -- '---\ntype: labo\nid: LAB-001\nversion: %s\n---\n\nune instance\n' "$v" \
    > "$d/.dev/labos/LAB-001-essai.md"
}

# La version que l'inventaire donne à la ressource labo. Le type est
# comparé, et pas seulement le nom : l'extension du banc s'appelle labo elle
# aussi, et son entrée vient avant.
version_inventoriee() {
  awk '
    /^  - type: / { t = $0; sub(/^  - type: /, "", t); nom = "" }
    /^    nom: /  { nom = $0; sub(/^    nom: /, "", nom) }
    /^    version: / {
      v = $0; sub(/^    version: /, "", v)
      if (t == "ressource" && nom == "labo") { print v; exit }
    }
  ' "$1/.dev/clia.yaml"
}

# --------------------------------------------------------------------------

printf 'banc de USE-007 — la mise à jour des ressources et des extensions\n'
printf 'bac : %s\n' "$BAC"

EXT=$(fabriquer_extension) || { printf 'banc: fixture impossible\n' >&2; exit 1; }

titre 'res activate reprend ce que l'\''extension offre aujourd'\''hui'

P=$(neuf projet) || exit 1
clia() { ( cd "$P" && "$CLIA" "$@" ); }

rc  "la version est celle du travail"         0 test "$(version_inventoriee "$P")" = '0.3.0'
rc  "res version aboutit"                     0 clia res version labo
dit "il donne la version installée"           'installée *0.3.0'
dit "la provenance"                           'provenance *acme\.com/labo'
dit "ce qui est offert"                       'offerte *0\.3\.0'
dit "et l'état"                               'état *à jour'

titre 'La forme de USE-007 : la ressource avant le verbe'

rc  "clia res labo version"                   0 clia res labo version
dit "elle dit la même chose"                  'installée *0\.3\.0'
rc  "clia res labo version ls"                0 clia res labo version ls
dit "elle liste les versions"                 '0\.2\.0'

titre 'res version ls — l'\''historique de la provenance'

rc  "la liste aboutit"                        0 clia res version ls labo
dit "les trois versions y sont"               '0\.3\.0'
dit "la deuxième aussi"                       '0\.2\.0'
dit "et la première"                          '0\.1\.0'
dit "celle qui est installée est marquée"     '0\.3\.0.*installée'
dit "chaque version porte son commit"         '0\.1\.0  *[0-9a-f][0-9a-f]'

titre 'downgrade — la version précédente par défaut'

rc  "il aboutit"                              0 clia res downgrade labo
dit "il dit d'où et vers où"                  'labo : 0\.3\.0 -> 0\.2\.0'
dit "et de quelle provenance"                 'reprise de acme\.com/labo'
rc  "l'inventaire suit"                       0 test "$(version_inventoriee "$P")" = '0.2.0'
rc  "la définition posée est bien celle-là"   0 grep -q '^version: 0.2.0$' "$P/_ressources/labo/schemas/labo.yaml"
vrai "le gabarit de cette version aussi"      grep -q 'corps v2' "$P/_ressources/labo/templates/labo.template.md"

rc  "downgrade encore"                        0 clia res downgrade labo
dit "il descend d'un cran"                    'labo : 0\.2\.0 -> 0\.1\.0'
vrai "le gabarit est revenu à v1"             grep -q 'corps v1' "$P/_ressources/labo/templates/labo.template.md"
faux "et le script de migration a disparu"    test -f "$P/_ressources/labo/scripts/migrations/0.2.0.sh"

rc  "sous la plus ancienne, il refuse"        1 clia res downgrade labo
dit "il dit pourquoi"                         "aucune version.*antérieure à 0\.1\.0"

titre 'upgrade — la plus récente par défaut'

rc  "il aboutit"                              0 clia res upgrade labo
dit "il remonte tout en haut"                 'labo : 0\.1\.0 -> 0\.3\.0'
rc  "l'inventaire suit"                       0 test "$(version_inventoriee "$P")" = '0.3.0'
rc  "relancé, il ne fait rien"                0 clia res upgrade labo
dit "il le dit"                               'déjà en version 0\.3\.0'
dit "et rien n'a bougé"                       "rien n'a été modifié"

titre 'upgrade et downgrade ne vont que dans leur sens'

rc  "upgrade vers une antérieure refuse"      1 clia res upgrade labo 0.1.0
dit "il renvoie à l'autre verbe"              'clia res downgrade labo 0\.1\.0'
rc  "downgrade vers une postérieure refuse"   1 clia res downgrade labo 9.9.9
dit "il dit qu'elle n'est pas offerte"        "n'offre pas la version 9\.9\.9"

rc  "une version qui n'existe pas refuse"     1 clia res upgrade labo 0.9.9
dit "il renvoie au catalogue"                 'clia res version ls labo'
rc  "un semver mal formé est refusé"          2 clia res upgrade labo 0.9
dit "il dit la forme attendue"                'X\.Y\.Z'

titre 'Une copie modifiée sur place n'\''est pas écrasée'

M=$(neuf modifie) || exit 1
modif() { ( cd "$M" && "$CLIA" "$@" ); }
printf 'bricolage local\n' >> "$M/_ressources/labo/schemas/labo.yaml"
EMPREINTE_M=$(sha1sum "$M/_ressources/labo/schemas/labo.yaml")

rc  "l'upgrade est refusé"                    1 modif res downgrade labo 0.1.0
dit "il dit ce qu'il a constaté"              'a été modifiée dans ce dépôt'
dit "il dit pourquoi c'est bloquant"          'ne se fusionne pas'
dit "et comment passer outre"                 '--force'
vrai "le fichier modifié est intact"          test "$(sha1sum "$M/_ressources/labo/schemas/labo.yaml")" = "$EMPREINTE_M"
rc  "l'inventaire n'a pas bougé"              0 test "$(version_inventoriee "$M")" = '0.3.0'

rc  "--force passe outre"                     0 modif res downgrade labo 0.1.0 --force
dit "et le dit comme une reprise"             'labo : 0\.3\.0 -> 0\.1\.0'
faux "le bricolage est perdu, comme annoncé"  grep -q 'bricolage local' "$M/_ressources/labo/schemas/labo.yaml"

titre 'migrate — les instances suivent le type'

G=$(neuf migre) || exit 1
migre() { ( cd "$G" && "$CLIA" "$@" ); }
instance "$G" 0.1.0

rc  "res version compte ce qui est en retard" 0 migre res version labo
dit "il le dit"                               'à migrer *1'

rc  "migrate --all aboutit"                   0 migre res migrate labo --all
dit "il nomme l'instance migrée"              'migrée *: LAB-001-essai\.md'
dit "et le chemin parcouru"                   '0\.1\.0 -> 0\.3\.0'
dit "le bilan compte une migration"           '1 migrée'
rc  "le script a été appliqué"                0 grep -q '^statut: actif$' "$G/.dev/labos/LAB-001-essai.md"
rc  "et le marqueur est avancé"               0 grep -q '^version: 0.3.0$' "$G/.dev/labos/LAB-001-essai.md"

rc  "relancé, il ne refait rien"              0 migre res migrate labo --all
dit "l'instance est comptée inchangée"        '1 inchangée'

# SPC-001 S3 n'admet que onze emplacements sous une ressource : les scripts de
# migration vivent donc sous scripts/, et leur sous-répertoire les tient hors
# de scripts/*.sh, que le dispatcher balaie pour trouver les commandes.
vrai "ils vivent sous un emplacement admis"   test -d "$G/_ressources/labo/scripts/migrations"
rc  "le CLI liste ses commandes"              0 migre --help
ne_dit_pas "sans y exposer une migration"     '0\.2\.0'

titre 'migrate — une instance nommée, et rien qu'\''elle'

H=$(neuf nommee) || exit 1
nommee() { ( cd "$H" && "$CLIA" "$@" ); }
instance "$H" 0.1.0
printf -- '---\ntype: labo\nid: LAB-002\nversion: 0.1.0\n---\n\nautre\n' \
  > "$H/.dev/labos/LAB-002-autre.md"

rc  "migrate accepte un identifiant"          0 nommee res migrate labo LAB-001
dit "il ne migre que celle-là"                '1 migrée'
rc  "la première est à jour"                  0 grep -q '^version: 0.3.0$' "$H/.dev/labos/LAB-001-essai.md"
rc  "la seconde n'a pas bougé"                0 grep -q '^version: 0.1.0$' "$H/.dev/labos/LAB-002-autre.md"

rc  "une instance inconnue est refusée"       1 nommee res migrate labo LAB-404
dit "il le dit"                               'aucune instance de labo'
rc  "migrate sans instance ni --all refuse"   2 nommee res migrate labo
dit "il rappelle les deux formes"             '\-\-all'

titre 'migrate ne redescend pas une instance'

D=$(neuf descend) || exit 1
descend() { ( cd "$D" && "$CLIA" "$@" ); }
instance "$D" 0.3.0
rc  "le downgrade du type aboutit"            0 descend res downgrade labo 0.1.0
rc  "migrate --all aboutit"                   0 descend res migrate labo --all
dit "mais laisse l'instance en arrière"       'aucun script ne redescend'
rc  "elle garde sa version"                   0 grep -q '^version: 0.3.0$' "$D/.dev/labos/LAB-001-essai.md"

titre 'upgrade --migrate enchaîne les deux'

E=$(neuf enchaine) || exit 1
enchaine() { ( cd "$E" && "$CLIA" "$@" ); }
rc  "on redescend d'abord"                    0 enchaine res downgrade labo 0.1.0
instance "$E" 0.1.0
rc  "upgrade --migrate aboutit"               0 enchaine res upgrade labo --migrate
dit "la ressource est reprise"                'labo : 0\.1\.0 -> 0\.3\.0'
dit "et l'instance migrée dans la foulée"     '1 migrée'
rc  "l'instance porte la nouvelle version"    0 grep -q '^version: 0.3.0$' "$E/.dev/labos/LAB-001-essai.md"

titre 'Une ressource née ici n'\''a pas de provenance à interroger'

N=$(neuf native) || exit 1
native() { ( cd "$N" && "$CLIA" "$@" ); }
rc  "elle se crée"                            0 native res new ZZZ maison 'Née ici.'
rc  "version la donne quand même"             0 native res version maison
dit "elle est installée"                      'installée *0\.1\.0'
dit "sa provenance est celle du dépôt"        'provenance *<publisher>/native'
dit "et l'état le dit sans détour"            'née dans ce dépôt'
rc  "upgrade refuse, et dit pourquoi"         1 native res upgrade maison
dit "elle est née ici"                        'née dans ce dépôt'
dit "et sa version se change à la main"       'schemas/maison\.yaml'

titre 'Une ressource absente du dépôt'

rc  "version refuse"                          1 native res version fantome
dit "il dit comment la reprendre"             'clia res activate fantome'
rc  "upgrade refuse aussi"                    1 native res upgrade fantome
dit "de la même façon"                        'clia res activate fantome'
rc  "version sans nom est mal formée"         2 native res version
dit "il rappelle l'usage"                     'clia res version'

titre 'clia check reste satisfait de ce que la mise à jour laisse'

# Avant que le banc ne casse le clone de l'extension : une reprise qui
# n'aurait pas réinscrit sa version se verrait ici, en C5 comme en C4.
rc  "le dépôt migré est conforme"             0 migre check
dit "il le dit"                               'conforme'
ne_dit_pas "sans avertissement"               'avert'

titre 'extension upgrade — le clone suit son dépôt'

X=$(neuf extension) || exit 1
ext() { ( cd "$X" && "$CLIA" "$@" ); }

rc  "sans rien de neuf, il le dit"            0 ext extension upgrade
dit "l'extension est à jour"                  'déjà à jour'
dit "et rien n'est en retard"                 "rien de ce qui en vient n'est en retard"

# L'extension avance : sa ressource, et le dépôt qui la porte.
sed -i 's|^version: 0.3.0$|version: 0.4.0|' "$EXT/_ressources/labo/schemas/labo.yaml"
sed -i 's|^version: .*|version: 0.5.0|' "$EXT/.dev/clia.yaml"
commiter "$EXT" 'labo 0.4.0'

rc  "upgrade rapporte l'avancée"              0 ext extension upgrade
dit "la version de l'extension a bougé"       'acme\.com/labo : 0\.1\.0 -> 0\.5\.0'
dit "et il nomme ce qui est en retard"        'en retard : labo (0\.3\.0 -> 0\.4\.0)'
dit "avec la commande qui le reprend"         'clia res upgrade labo'
rc  "l'inventaire porte la version du clone"  0 grep -q '^    version: 0.5.0$' "$X/.dev/clia.yaml"

rc  "la ressource n'a pas été reprise d'office" 0 test "$(version_inventoriee "$X")" = '0.3.0'
rc  "on la reprend explicitement"             0 ext res upgrade labo
dit "elle passe à la version offerte"         'labo : 0\.3\.0 -> 0\.4\.0'
rc  "et l'extension n'a plus rien à signaler" 0 ext extension upgrade
dit "elle est à jour"                         'déjà à jour'

titre 'extension upgrade — les cas d'\''erreur'

rc  "un namespace inconnu est refusé"         1 ext extension upgrade acme.com/nulle-part
dit "il renvoie à la liste"                   'clia extension ls'
rc  "deux namespaces sont refusés"            2 ext extension upgrade a b

rm -rf "$XDG_CACHE_HOME/clia/extensions/acme.com/labo"
rc  "un clone disparu est signalé"            1 ext extension upgrade
dit "il dit comment le rétablir"              'clia extension add'
rc  "et res upgrade le dit à son tour"        1 ext res upgrade labo
dit "la provenance n'est pas joignable"       "n'est pas joignable"

titre 'Le dépôt réel n'\''est pas touché'

vrai "aucun changement de fichier"            test "$(cd "$RACINE" && git status --porcelain 2>/dev/null | sort)" = "$EMPREINTE_SOURCE"
vrai "HEAD n'a pas bougé"                     test "$(cd "$RACINE" && git rev-parse HEAD 2>/dev/null || printf '')" = "$TETE_REELLE"

# --------------------------------------------------------------------------

bilan
