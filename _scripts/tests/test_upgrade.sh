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
#
# Le dépôt de l'extension avance en même temps que sa ressource : sa propre
# version passe de 0.1.0 à 0.3.0. Sans cela, « clia upgrade NAMESPACE X.Y.Z »
# n'aurait aucune version de provenance à résoudre.
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
  poser_skill_et_feature "$d" 0.1.0
  commiter "$d" 'labo 0.1.0'

  sed -i 's|^version: 0.1.0$|version: 0.2.0|' "$d/_ressources/labo/schemas/labo.yaml"
  sed -i 's|^version: .*|version: 0.2.0|' "$d/.dev/clia.yaml"
  printf -- '---\ntype: labo\nid: LAB-{{seq}}\nversion: 0.2.0\nstatut: actif\n---\n\ncorps v2\n' \
    > "$d/_ressources/labo/templates/labo.template.md"
  mkdir -p "$d/_ressources/labo/scripts/migrations"
  cat > "$d/_ressources/labo/scripts/migrations/0.2.0.sh" <<'EOF'
#!/usr/bin/env bash
# Ajoute le champ statut au frontmatter d'une instance de labo.
set -euo pipefail
grep -q '^statut:' "$1" || sed -i '2i statut: actif' "$1"
EOF
  poser_skill_et_feature "$d" 0.2.0
  commiter "$d" 'labo 0.2.0'

  sed -i 's|^version: 0.2.0$|version: 0.3.0|' "$d/_ressources/labo/schemas/labo.yaml"
  sed -i 's|^version: .*|version: 0.3.0|' "$d/.dev/clia.yaml"
  poser_skill_et_feature "$d" 0.3.0
  commiter "$d" 'labo 0.3.0'
  printf '%s\n' "$d"
}

# Un skill et une fonctionnalité, dont le corps porte la version : ce qui a
# été posé hors du répertoire de la ressource doit suivre quand elle bouge, et
# c'est la seule façon de le constater.
poser_skill_et_feature() {
  local d="$1" v="$2"
  mkdir -p "$d/_ressources/labo/skills" "$d/_ressources/labo/features"
  printf -- '---\nname: labo-skill\ndescription: Skill du labo, en %s.\n---\n\nCorps %s.\n' \
    "$v" "$v" > "$d/_ressources/labo/skills/labo-skill.md"
  printf -- '---\nname: labo-feat\ndescription: Fonctionnalité du labo, en %s.\n---\n\nDirective %s.\n' \
    "$v" "$v" > "$d/_ressources/labo/features/labo-feat.md"
}

# L'extension avance : sa ressource, son skill, sa fonctionnalité et sa propre
# version, en un commit.
avancer() {
  local vres="$1" vdepot="$2"
  sed -i -E "s|^version: [0-9]+\.[0-9]+\.[0-9]+\$|version: $vres|" \
    "$EXT/_ressources/labo/schemas/labo.yaml"
  sed -i -E "s|^version: .*|version: $vdepot|" "$EXT/.dev/clia.yaml"
  poser_skill_et_feature "$EXT" "$vres"
  commiter "$EXT" "labo $vres"
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

# --------------------------------------------------------------------------
# La seconde moitié de USE-007 : les mêmes verbes, appliqués au dépôt entier.
# --------------------------------------------------------------------------

titre 'clia upgrade — le dépôt reprend ce que ses provenances offrent'

U=$(neuf maj) || exit 1
maj() { ( cd "$U" && "$CLIA" "$@" ); }

# Le dépôt est mis en retard exprès, skill et fonctionnalité posés à cette
# version-là : c'est le seul moyen de constater qu'une reprise les repose.
rc  "on redescend la ressource"               0 maj res downgrade labo 0.1.0
rc  "le skill de cette version est posé"      0 maj skill install labo-skill
rc  "la fonctionnalité aussi"                 0 maj feature install labo-feat
vrai "le skill posé porte le corps de 0.1.0"  grep -q 'Corps 0.1.0' "$U/.claude/skills/labo-skill/SKILL.md"
vrai "la fonctionnalité aussi"                grep -q 'Directive 0.1.0' "$U/CLAUDE.md"
instance "$U" 0.1.0

rc  "upgrade --migrate aboutit"               0 maj upgrade --migrate
dit "il nomme le dépôt qu'il met à jour"      "$U"
dit "l'extension est déjà à jour"             'à jour *extension acme\.com/labo'
dit "la ressource est reprise"                'repris *ressource labo : 0\.1\.0 -> 0\.3\.0'
dit "le skill est reposé"                     'reposé *skill labo-skill'
dit "la fonctionnalité aussi"                 'reposé *fonctionnalité labo-feat'
dit "et les instances migrées dans la foulée" 'migré *instances de labo'
vrai "le skill posé a suivi la ressource"     grep -q 'Corps 0.3.0' "$U/.claude/skills/labo-skill/SKILL.md"
vrai "la fonctionnalité aussi"                grep -q 'Directive 0.3.0' "$U/CLAUDE.md"
rc  "l'inventaire suit"                       0 test "$(version_inventoriee "$U")" = '0.3.0'
rc  "l'instance porte la version du type"     0 grep -q '^version: 0.3.0$' "$U/.dev/labos/LAB-001-essai.md"

rc  "relancé, il ne fait rien"                0 maj upgrade
dit "il le dit"                               'rien à faire'
ne_dit_pas "et ne repose rien"                'reposé'

titre 'La version demandée est celle de la provenance, non de la ressource'

rc  "downgrade jusqu'à sa version 0.1.0"      0 maj downgrade acme.com/labo 0.1.0
dit "la ressource revient à ce qu'elle était" 'repris *ressource labo : 0\.3\.0 -> 0\.1\.0'
rc  "l'inventaire suit"                       0 test "$(version_inventoriee "$U")" = '0.1.0'
vrai "le gabarit est celui de v1"             grep -q 'corps v1' "$U/_ressources/labo/templates/labo.template.md"

rc  "upgrade jusqu'à sa version 0.2.0"        0 maj upgrade acme.com/labo 0.2.0
dit "la ressource avance jusque-là"           'repris *ressource labo : 0\.1\.0 -> 0\.2\.0'
rc  "l'inventaire suit"                       0 test "$(version_inventoriee "$U")" = '0.2.0'

rc  "upgrade vers une version antérieure"     0 maj upgrade acme.com/labo 0.1.0
dit "il saute plutôt que de reculer"          'sauté *ressource labo'
dit "et renvoie à l'autre verbe"              'clia downgrade'
rc  "la ressource n'a pas bougé"              0 test "$(version_inventoriee "$U")" = '0.2.0'

rc  "downgrade vers une version postérieure"  0 maj downgrade acme.com/labo 0.3.0
dit "il saute là aussi"                       'sauté *ressource labo'
dit "et renvoie à l'autre verbe"              'clia upgrade'

titre 'clia upgrade — la demande mal formée ou impossible'

rc  "une version que la provenance n'a pas"   1 maj upgrade acme.com/labo 9.9.9
dit "il le dit"                               "ne s'est jamais déclaré en version 9\.9\.9"
dit "et nomme celles qu'elle a publiées"      '  0\.3\.0'
rc  "un namespace inconnu est refusé"         1 maj upgrade nulle-part
dit "il nomme les provenances du dépôt"       'acme\.com/labo'
rc  "un semver mal formé est refusé"          2 maj upgrade 0.9
dit "il dit la forme attendue"                'X\.Y\.Z'
rc  "--migrate n'a de sens qu'avec upgrade"   2 maj downgrade --migrate
rc  "--to n'a de sens qu'avec migrate"        2 maj upgrade --to 0.1.0
dit "il rappelle la forme sans option"        'clia upgrade X\.Y\.Z'
rc  "une option inconnue est refusée"         2 maj upgrade --tout
rc  "l'aide de chaque verbe existe"           0 maj downgrade --help
dit "et parle bien de celui-là"               'clia downgrade'

titre 'clia migrate — les instances du dépôt entier'

W=$(neuf balaye) || exit 1
bal() { ( cd "$W" && "$CLIA" "$@" ); }
rc  "on redescend le type"                    0 bal res downgrade labo 0.1.0
instance "$W" 0.1.0
rc  "on remonte le type sans migrer"          0 bal res upgrade labo
rc  "l'instance est restée en arrière"        0 grep -q '^version: 0.1.0$' "$W/.dev/labos/LAB-001-essai.md"

# Une seconde ressource, sans aucune instance : le balayage ne doit pas la
# nommer, et la demande explicite doit au contraire le dire.
rc  "une ressource sans instance existe"      0 bal res new ZZZ maison 'Née ici.'

rc  "migrate sans argument aboutit"           0 bal migrate
dit "il nomme la ressource migrée"            'migré *instances de labo'
ne_dit_pas "sans énumérer celles sans instance" 'instances de maison'
rc  "l'instance a suivi"                      0 grep -q '^version: 0.3.0$' "$W/.dev/labos/LAB-001-essai.md"

rc  "relancé, il ne refait rien"              0 bal migrate
dit "il le dit"                               'rien à faire'

rc  "une ressource nommée sans instance"      0 bal migrate maison
dit "il le dit plutôt que de se taire"        'instances de maison : aucune'
rc  "une ressource absente est refusée"       1 bal migrate fantome
dit "il renvoie à la liste"                   'clia res ls'
rc  "--force n'a pas de sens ici"             2 bal migrate --force

titre 'clia upgrade signale le harnais en retard, sans le réécrire'

V=$(neuf harnais) || exit 1
har() { ( cd "$V" && "$CLIA" "$@" ); }
EMPREINTE_V=$(sha1sum "$V/CLAUDE.md" | awk '{print $1}')
# L'inventaire fait dire au harnais une version qu'il n'a pas : c'est l'écart
# que la commande doit signaler sans y toucher.
sed -i '/^  - type: harness$/,/^    version: /s/^    version: .*/    version: 0.0.1/' \
  "$V/.dev/clia.yaml"
rc  "upgrade aboutit"                         0 har upgrade
dit "le harnais est signalé"                  'signalé *harnais en 0\.0\.1'
dit "avec la commande qui le régénère"        'clia harness-ia init --force'
vrai "et CLAUDE.md n'a pas été touché"        test "$(sha1sum "$V/CLAUDE.md" | awk '{print $1}')" = "$EMPREINTE_V"

titre 'clia upgrade sur un dépôt sans rien repris d'\''ailleurs'

S="$BAC/solitaire"
rm -rf "$S"
rc  "un dépôt neuf s'instrumente"             0 "$CLIA" init "$S"
seul() { ( cd "$S" && "$CLIA" "$@" ); }
rc  "upgrade aboutit sans rien faire"         0 seul upgrade
dit "il le dit"                               "n'a rien repris d'ailleurs"
rc  "et une version demandée est refusée"     1 seul upgrade 0.1.0
dit "il dit qu'il n'a pas de provenance"      "n'en a aucune"

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
dit "la version de l'extension a bougé"       'acme\.com/labo : 0\.3\.0 -> 0\.5\.0'
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
