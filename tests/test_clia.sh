#!/usr/bin/env bash
# tests/test_clia.sh — banc de vérification de USE-001, installer clia.
#
# Le banc n'installe rien dans le compte de l'utilisateur : il se donne un
# HOME jetable, un PATH réduit, et un second dépôt git pour éprouver le
# périmètre d'exécution. Le dépôt source, lui, est le dépôt réel — l'usage
# exige que rien n'y soit écrit, et c'est vérifié.
#
# Lancement :  bash tests/test_clia.sh

set -uo pipefail

RACINE=$(cd -P "$(dirname "${BASH_SOURCE[0]}")/.." >/dev/null 2>&1 && pwd)

# --------------------------------------------------------------------------
# Le bac
# --------------------------------------------------------------------------

for outil in git grep sed awk mktemp readlink; do
  command -v "$outil" >/dev/null 2>&1 || {
    printf 'banc: outil absent : %s\n' "$outil" >&2
    exit 1
  }
done

BAC=$(mktemp -d) || exit 1
trap 'rm -rf "$BAC"' EXIT

export HOME="$BAC/home"
export XDG_CONFIG_HOME="$HOME/.config"
mkdir -p "$HOME"
unset CLIA_HOME CLIA_MODE CLIA_BIN_DIR

BINDIR="$HOME/.local/bin"
LIEN="$BINDIR/clia"
CONF="$XDG_CONFIG_HOME/clia/install.conf"

# PATH réduit : un clia déjà installé sur la machine fausserait tous les cas
# qui portent sur « la commande clia est-elle disponible ».
CHEMIN_GIT=$(dirname "$(command -v git)")
export PATH="$BINDIR:/usr/local/bin:/usr/bin:/bin:$CHEMIN_GIT"

AUTRE="$BAC/autre-depot"
mkdir -p "$AUTRE"
git -C "$AUTRE" init -q >/dev/null 2>&1 || { printf 'banc: git init a échoué\n' >&2; exit 1; }

VERSION=$(bash "$RACINE/setup.sh" version)
EMPREINTE_SOURCE=$(cd "$RACINE" && git status --porcelain 2>/dev/null | sort)

# --------------------------------------------------------------------------
# Assertions
# --------------------------------------------------------------------------

# shellcheck source=banc.sh
. "$(dirname "${BASH_SOURCE[0]}")/banc.sh"

# Sourcer setup.sh depuis un shell neuf, et rendre son code de retour.
sourcer() {
  local script="$*"
  bash -c ". \"\$1/setup.sh\" $script" banc "$RACINE"
}

# --------------------------------------------------------------------------

printf 'banc de USE-001 — installer clia (version %s)\n' "$VERSION"
printf 'bac : %s\n' "$BAC"

titre 'Demandes mal formées'

rc  "setup.sh help répond"                    0 bash "$RACINE/setup.sh" help
dit "l'aide nomme le mode --activate"         '--activate'
dit "l'aide nomme le mode --dev"              '--dev'
rc  "setup.sh version rend la version"        0 bash "$RACINE/setup.sh" version
vrai "la version est celle du CLI"            test "$SORTIE" = "$VERSION"
rc  "activate non sourcé est refusé"          2 bash "$RACINE/setup.sh" activate
dit "et il dit comment le sourcer"            '\. setup.sh activate'
rc  "install sans mode est refusé"            2 sourcer install
dit "et il nomme les deux modes"              'toute session, tout dépôt git'
rc  "option inconnue est refusée"             2 sourcer install --bidon
rc  "commande inconnue est refusée"           2 bash "$RACINE/setup.sh" bidon

titre 'Scénario 1 — la commande clia n'\''est pas disponible'

faux "clia est absent au départ"              command -v clia
rc  "install --dev aboutit"                   0 sourcer install --dev
vrai "le lien est posé"                       test -L "$LIEN"
vrai "il pointe sur bin/clia du dépôt source" test "$(readlink "$LIEN")" = "$RACINE/bin/clia"
vrai "la configuration est écrite"            test -f "$CONF"
vrai "clia est disponible"                    bash -c 'command -v clia >/dev/null'

rc  "clia -h répond"                          0 clia -h
dit "l'aide liste la commande setup"          '^  setup '
rc  "clia setup --help répond"                0 clia setup --help
dit "et il nomme le verbe uninstall"          'uninstall'
rc  "clia --version rend la version"          0 clia --version
vrai "la version est celle du dépôt"          test "$SORTIE" = "$VERSION"
rc  "clia setup status répond"                0 clia setup status
dit "le mode constaté est dev"                '^mode  *dev$'
dit "le lien est rapporté"                    "$LIEN"
rc  "clia commande inconnue est refusée"      2 clia bidon

titre 'Scénario 2 — la commande clia est déjà disponible'

CONF_AVANT=$(cat "$CONF")
rc  "install --dev est refusé"                1 sourcer install --dev
dit "il dit que rien n'a été modifié"         "rien n'a été modifié"
dit "il dit où la commande a été trouvée"     "$LIEN"
dit "il indique --force"                      '--force'
vrai "la configuration est intacte"           test "$(cat "$CONF")" = "$CONF_AVANT"
rc  "activate est refusé lui aussi"           1 sourcer activate
rc  "--force lève le refus"                   0 sourcer install --dev --force

titre 'Non-intrusivité'

rm -f "$LIEN"
printf '#!/bin/sh\necho pas clia\n' > "$LIEN"
chmod +x "$LIEN"
rc  "--force n'écrase pas un fichier étranger" 1 sourcer install --dev --force
dit "et il dit pourquoi"                      "clia ne remplace pas un fichier qu'il n'a pas posé"
vrai "le fichier étranger est intact"         grep -q 'pas clia' "$LIEN"
rm -f "$LIEN"
rc  "l'installation reprend une fois retiré"  0 sourcer install --dev --force

titre 'Périmètre d'\''exécution — mode dev'

rc  "context répond depuis le dépôt source"   0 bash -c 'cd "$1" && clia context' banc "$RACINE"
dit "il rapporte le mode dev"                 '^mode  *dev$'
rc  "context répond depuis un autre dépôt"    0 bash -c 'cd "$1" && clia context' banc "$AUTRE"
dit "le dépôt courant est l'autre dépôt"    "dépôt courant   $AUTRE"
dit "le code employé reste celui du source"   "dépôt source    $RACINE"
rc  "hors dépôt git, context refuse"          1 bash -c 'cd "$1" && clia context' banc "$BAC"
dit "et il dit pourquoi"                      "n'est pas dans un dépôt git"

titre 'Désinstallation'

rc  "clia setup uninstall aboutit"            0 clia setup uninstall
dit "il nomme le lien retiré"                 "$LIEN"
faux "le lien a disparu"                      test -e "$LIEN"
faux "la configuration a disparu"             test -e "$CONF"
faux "clia n'est plus accessible"             bash -c 'hash -r; command -v clia >/dev/null'
rc  "uninstall est idempotent"                0 bash "$RACINE/bin/clia" setup uninstall
dit "et il le dit"                            'aucune installation'

titre 'Une installation que clia n'\''a pas posée'

# Un clia venu d'ailleurs : un PATH modifié à la main, ou une version
# antérieure installée autrement. Le scénario 2 s'applique, mais aucune des
# deux commandes de retrait de clia ne s'y applique — et le dire est le seul
# comportement honnête.
FAUX="$BAC/faux-bin"
mkdir -p "$FAUX"
printf '#!/bin/sh\necho 0.0.1\n' > "$FAUX/clia"
chmod +x "$FAUX/clia"

rc  "install --dev est refusé"                1 bash -c 'PATH="$2:$PATH"; . "$1/setup.sh" install --dev' banc "$RACINE" "$FAUX"
dit "il rapporte la version trouvée"          '0\.0\.1'
dit "il dit que clia ne la retirera pas"      "clia ne retire pas ce qu'il n'a pas posé"
ne_dit_pas "il n'oriente pas vers uninstall"  'clia setup uninstall'
rc  "uninstall ne prétend pas l'avoir fait"   0 bash -c 'PATH="$2:$PATH"; "$1/bin/clia" setup uninstall' banc "$RACINE" "$FAUX"
dit "il signale que clia reste disponible"    'reste pourtant disponible'
vrai "et le clia étranger est intact"         test -x "$FAUX/clia"

titre 'Mode activate — ce shell, et ce dépôt seulement'

rc  "activate aboutit"                        0 sourcer activate
rc  "il rend clia disponible dans ce shell"   0 bash -c '. "$1/setup.sh" activate >/dev/null 2>&1; command -v clia >/dev/null && clia --version' banc "$RACINE"
vrai "avec la bonne version"                  test "$SORTIE" = "$VERSION"
rc  "le mode constaté est activate"           0 bash -c '. "$1/setup.sh" activate >/dev/null 2>&1; clia setup status' banc "$RACINE"
dit "et rien n'est écrit sur le disque"       '^sur le disque   rien$'
faux "aucune configuration n'est créée"       test -e "$CONF"
faux "aucun lien n'est posé"                  test -e "$LIEN"

rc  "context est permis sur le dépôt source"  0 bash -c '. "$1/setup.sh" activate >/dev/null 2>&1; cd "$1" && clia context' banc "$RACINE"
dit "il rapporte le mode activate"            '^mode  *activate$'
rc  "context est refusé sur un autre dépôt"   1 bash -c '. "$1/setup.sh" activate >/dev/null 2>&1; cd "$2" && clia context' banc "$RACINE" "$AUTRE"
dit "et il dit que c'est hors périmètre"    'hors périmètre'
dit "et il indique --dev comme issue"         '--dev'

rc  "uninstall ne défait pas une activation"  1 bash -c '. "$1/setup.sh" activate >/dev/null 2>&1; clia setup uninstall' banc "$RACINE"
dit "il renvoie vers deactivate"              '\. setup\.sh deactivate'

rc  "deactivate retire clia du shell"         0 bash -c '. "$1/setup.sh" activate >/dev/null 2>&1
                                                          . "$1/setup.sh" deactivate >/dev/null 2>&1
                                                          command -v clia >/dev/null && exit 1
                                                          [[ -z "${CLIA_MODE:-}" && -z "${CLIA_HOME:-}" ]]' banc "$RACINE"
rc  "deactivate sans activation ne casse pas" 0 sourcer deactivate
dit "et il le dit"                            'aucune activation'

titre 'Le shell ne garde que ce qu'\''il a demandé'

rc  "aucune fonction _clia_ ne subsiste"      0 bash -c '. "$1/setup.sh" activate >/dev/null 2>&1
                                                          [[ -z "$(compgen -A function _clia_ 2>/dev/null)" ]]' banc "$RACINE"
rc  "aucune variable _clia_ ne subsiste"      0 bash -c '. "$1/setup.sh" activate >/dev/null 2>&1
                                                          [[ -z "$(compgen -v _clia_ 2>/dev/null)" ]]' banc "$RACINE"
rc  "mais CLIA_HOME et CLIA_MODE restent"     0 bash -c '. "$1/setup.sh" activate >/dev/null 2>&1
                                                          [[ -n "$CLIA_HOME" && "$CLIA_MODE" = activate ]]' banc "$RACINE"

titre 'Le dépôt source n'\''est pas modifié'

vrai "aucun changement dans le dépôt source"  test "$(cd "$RACINE" && git status --porcelain 2>/dev/null | sort)" = "$EMPREINTE_SOURCE"

# --------------------------------------------------------------------------

bilan
