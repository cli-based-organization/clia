#!/usr/bin/env bash
# _scripts/tests/test_installation.sh — l'installation permanente.
#
# Éprouve SES-001 tâche 7.
#
# Une installation dev écrit sur le disque de l'utilisateur. Un banc qui la
# poserait vraiment détruirait celle de qui l'exécute. CLIA_BIN_DIR et
# XDG_CONFIG_HOME sont donc pointés vers un répertoire jetable pour chaque
# scénario, et le dernier titre vérifie que le poste réel n'a pas bougé.
#
# Les trois propriétés d'une installation dev — durée de vie permanente,
# source égale au dépôt installé, portée non bornée — sont vérifiées
# nommément, chacune par ce qui la distingue d'une activation.

set -uo pipefail

RACINE=$(cd -P "$(dirname "${BASH_SOURCE[0]}")/../.." && pwd)
SETUP="$RACINE/setup.sh"
CLIA="$RACINE/_scripts/bin/clia"

# shellcheck source=banc.sh
. "$RACINE/_scripts/tests/banc.sh"

BAC=$(mktemp -d)
trap 'rm -rf "$BAC"' EXIT

REEL_ETAT=$(git -C "$RACINE" status --porcelain | sort)
REEL_LIEN=$(ls -l "$HOME/.local/bin/clia" 2>/dev/null || printf '(absent)')
REEL_CONFIG=$(ls "$HOME/.config/clia" 2>/dev/null || printf '(absent)')

# --------------------------------------------------------------------------
# Outils
# --------------------------------------------------------------------------

BIN="$BAC/bin"
CONFIG="$BAC/config"
CONF_YAML="$CONFIG/clia/installation.yaml"
LIEN="$BIN/clia"

# scenario <code bash> — un shell neuf, sans installation héritée, dont les
# emplacements d'installation sont ceux du bac.
scenario() {
  env -u CLIA_INSTALLATION -u CLIA_SOURCE_DIR -u CLIA_PORTEE -u CLIA_WORK_DIR \
      CLIA_BIN_DIR="$BIN" XDG_CONFIG_HOME="$CONFIG" \
      bash -c "$1" 2>&1
}

rc_scenario() {
  local titre="$1" attendu="$2" code="$3" reel
  SORTIE=$(scenario "$code"); reel=$?
  if (( reel == attendu )); then
    ok "$titre"
  else
    echec "$titre" "code $reel, attendu $attendu — $(printf '%s' "$SORTIE" | tr '\n' '|' | cut -c1-140)"
  fi
}

# Remet le bac dans l'état « rien d'installé ».
table_rase() { rm -rf "$BIN" "$CONFIG"; }

depot() {
  local d="$BAC/$1"
  mkdir -p "$d"
  git -C "$d" init -q
  printf 'namespace: exemple.test/%s\nversion: 3.3.3\n' "$1" > "$d/clia.yaml"
  git -C "$d" -c user.email=t@t.invalid -c user.name=t add -A
  git -C "$d" -c user.email=t@t.invalid -c user.name=t commit -q -m init
  printf '%s\n' "$d"
}

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

PROJET=$(depot projet)
AUTRE=$(depot autre)

# ==========================================================================
titre 'La documentation des deux entrees'
# ==========================================================================

rc 'setup.sh help' 0 bash "$SETUP" help
dit 'la signature de install --dev y est' '\. setup.sh install --dev'
dit 'et install figure parmi les verbes' '^  install$'
dit 'et --dev parmi les options' '^  --dev$'
RESTE=$(bash "$SETUP" help 2>/dev/null | lignes_de_prose)
vrai 'et cette aide ne porte aucune prose' test -z "$RESTE"

rc 'le manuel de setup.sh' 0 bash "$SETUP" --man
dit 'documente install --dev' 'install --dev'
dit 'et nomme les deux natures d installation' 'Une installation dev est permanente'
dit 'et les fichiers qu elle laisse' 'installation.yaml'
LONGUES=$(bash "$SETUP" --man 2>/dev/null | lignes_trop_longues)
vrai 'et il tient dans la page' test -z "$LONGUES"

rc 'clia --help liste setup' 0 "$CLIA" --help
dit 'avec ce qu elle fait' 'setup  *L.installation de clia'
rc 'clia setup --help' 0 "$CLIA" setup --help
RESTE=$("$CLIA" setup --help 2>/dev/null | lignes_de_prose)
vrai 'sans prose' test -z "$RESTE"
rc 'le manuel de clia setup' 0 "$CLIA" setup --man
dit 'dit pourquoi activate n y est pas' 'ne peut modifier ni'
LONGUES=$("$CLIA" setup --man 2>/dev/null | lignes_trop_longues)
vrai 'et il tient dans la page' test -z "$LONGUES"

# ==========================================================================
titre 'Sans installation'
# ==========================================================================

table_rase
rc_scenario 'setup.sh status rend 1' 1 "bash '$SETUP' status"
dit 'et nomme les deux façons d installer' 'setup.sh install --dev'
rc_scenario 'clia setup status rend 1 aussi' 1 "'$CLIA' setup status"
rc_scenario 'clia setup uninstall reste satisfait' 0 "'$CLIA' setup uninstall"
dit "et dit qu'il n y a rien à retirer" "rien à retirer"

# ==========================================================================
titre 'install --dev : ce qui est pose'
# ==========================================================================

table_rase
rc_scenario 'une installation dev est satisfaite' 0 "
  cd '$RACINE' && . '$SETUP' install --dev"
dit 'et elle nomme le dépôt source' "depuis $RACINE"
dit 'et la portée' "n'importe quel dépôt git"

vrai 'le lien est posé' test -L "$LIEN"
vrai 'et il mène à l exécutable du dépôt source' \
  test "$(readlink -f "$LIEN")" = "$RACINE/_scripts/bin/clia"
vrai 'la configuration est posée' test -f "$CONF_YAML"
vrai 'elle déclare la nature' grep -q '^nature: dev$' "$CONF_YAML"
vrai 'elle déclare la source' grep -q "^source: $RACINE\$" "$CONF_YAML"
vrai 'elle déclare le lien' grep -q "^lien: $LIEN\$" "$CONF_YAML"

SORTIE=$(scenario "bash '$SETUP' status")
dit 'status rapporte la nature' '^installation   dev$'
dit 'et une durée de vie permanente' '^durée de vie   permanente'
dit 'et la source' "^source         $RACINE\$"
dit 'et une portée non bornée' "^portée         n'importe quel dépôt git\$"

vrai 'clia setup status dit la même chose que setup.sh status' \
  test "$(scenario "'$CLIA' setup status")" = "$(scenario "bash '$SETUP' status")"

# ==========================================================================
titre 'Les trois proprietes'
# ==========================================================================

# Durée de vie permanente : un shell neuf, qui n'a rien hérité, voit la
# commande — c'est ce qui la distingue d'une activation.
SORTIE=$(scenario "PATH='$BIN:/usr/bin:/bin' bash -c \"cd '$PROJET' && clia version\"")
vrai 'permanence : un shell neuf voit la commande' test "$SORTIE" = '3.3.3'

# Portée non bornée : deux dépôts différents, sans réinstaller.
SORTIE=$(scenario "PATH='$BIN:/usr/bin:/bin' bash -c \"cd '$AUTRE' && clia version\"")
vrai 'portée : la commande répond dans un autre dépôt' test "$SORTIE" = '3.3.3'
rc_scenario 'et elle y est satisfaite' 0 "
  PATH='$BIN:/usr/bin:/bin' bash -c \"cd '$AUTRE' && clia version\""

# Source : c'est le dépôt d'où setup.sh a été lancé, quel qu'il soit.
COPIE="$BAC/copie-de-clia"
mkdir -p "$COPIE"
cp -r "$RACINE/_scripts" "$RACINE/_ressources" "$RACINE/setup.sh" "$COPIE/"
table_rase
scenario "cd '$COPIE' && . '$COPIE/setup.sh' install --dev" >/dev/null
vrai 'source : le lien mène au dépôt d où setup.sh a été lancé' \
  test "$(readlink -f "$LIEN")" = "$COPIE/_scripts/bin/clia"
vrai 'et la configuration le déclare' grep -q "^source: $COPIE\$" "$CONF_YAML"
vrai 'c est un lien, non une copie' test -L "$LIEN"

# ==========================================================================
titre 'Reinstaller, et refuser'
# ==========================================================================

table_rase
scenario "cd '$RACINE' && . '$SETUP' install --dev" >/dev/null
rc_scenario 'réinstaller reste satisfait' 0 "cd '$RACINE' && . '$SETUP' install --dev"
vrai 'et le répertoire ne porte qu un lien' test "$(ls "$BIN" | wc -l)" -eq 1

rc_scenario 'installer sans mode est une demande mal formée' 2 "
  cd '$RACINE' && . '$SETUP' install"
dit 'et le mode attendu est nommé' 'install attend un mode : --dev'
rc_scenario 'un mode inconnu est une demande mal formée' 2 "
  cd '$RACINE' && . '$SETUP' install --prod"

rc_scenario 'install s exécute aussi sans être sourcé' 0 "
  cd '$RACINE' && bash '$SETUP' install --dev"

table_rase
mkdir -p "$BIN"
ln -s /bin/true "$LIEN"
rc_scenario 'un lien menant ailleurs n est pas écrasé' 1 "
  cd '$RACINE' && . '$SETUP' install --dev"
dit 'et clia dit où il mène' '/bin/true'
dit 'et comment procéder' 'clia setup uninstall'
vrai 'le lien étranger est intact' \
  test "$(readlink -f "$LIEN")" = "$(readlink -f /bin/true)"
vrai 'et aucune configuration n a été écrite' test ! -f "$CONF_YAML"

# ==========================================================================
titre 'Une activation par-dessus une installation dev'
# ==========================================================================

table_rase
scenario "cd '$RACINE' && . '$SETUP' install --dev" >/dev/null

SORTIE=$(scenario "
  cd '$RACINE' && . '$SETUP' install --dev >/dev/null 2>&1
  cd '$PROJET' && . '$SETUP' activate >/dev/null 2>&1
  bash '$SETUP' status")
dit 'l activation l emporte' '^installation   activation$'
dit 'et sa portée est le dépôt activé' "^portée         $PROJET\$"
dit 'et l installation dev est nommée comme masquée' 'est aussi en place, et masquée'
dit 'avec sa source' "^  source       $RACINE\$"

# ==========================================================================
titre 'clia setup uninstall'
# ==========================================================================

table_rase
scenario "cd '$RACINE' && . '$SETUP' install --dev" >/dev/null
rc_scenario 'le retrait est satisfait' 0 "'$CLIA' setup uninstall"
dit 'et il nomme ce qui a été retiré' 'installation retirée'
vrai 'le lien est retiré' test ! -e "$LIEN"
vrai 'la configuration est retirée' test ! -f "$CONF_YAML"
vrai 'et son répertoire vide aussi' test ! -d "$CONFIG/clia"

rc_scenario 'retirer une seconde fois reste satisfait' 0 "'$CLIA' setup uninstall"
dit "et dit qu'il n y a rien à retirer" "rien à retirer"

table_rase
SORTIE=$(scenario "
  cd '$RACINE' && . '$SETUP' install --dev >/dev/null 2>&1
  cd '$PROJET' && . '$SETUP' activate >/dev/null 2>&1
  '$CLIA' setup uninstall")
dit 'retirer pendant une activation retire bien l installation dev' 'installation retirée'
dit 'et dit que l activation reste' 'une activation reste en place'
dit 'en nommant le geste qui la défait' 'setup.sh deactivate'

# Un lien qui ne mène pas à un exécutable clia n'est pas retiré.
table_rase
scenario "cd '$RACINE' && . '$SETUP' install --dev" >/dev/null
ln -sfn /bin/true "$LIEN"
rc_scenario 'un lien qui ne mène pas à clia n est pas retiré' 1 "'$CLIA' setup uninstall"
dit 'et clia dit où il mène' '/bin/true'
vrai 'le lien est intact' \
  test "$(readlink -f "$LIEN")" = "$(readlink -f /bin/true)"
vrai 'et la configuration aussi' test -f "$CONF_YAML"

# ==========================================================================
titre 'Ce que clia setup ne peut pas faire'
# ==========================================================================

for verbe in activate deactivate install; do
  rc_scenario "clia setup $verbe refuse, faute de pouvoir" 1 "'$CLIA' setup $verbe"
  dit 'en disant pourquoi' 'processus fils ne modifie pas'
  dit 'et en nommant la bonne entrée' "\\. setup.sh $verbe"
done

rc_scenario 'un verbe inconnu est mal formé' 2 "'$CLIA' setup bidule"
rc_scenario 'clia setup sans verbe est mal formé' 2 "'$CLIA' setup"
rc_scenario 'status ne prend pas d argument' 2 "'$CLIA' setup status x"
rc_scenario 'uninstall ne prend pas d argument' 2 "'$CLIA' setup uninstall x"

# ==========================================================================
titre 'Le poste reel n a pas ete touche'
# ==========================================================================

vrai "le lien clia du poste est dans l'état du départ" \
  test "$(ls -l "$HOME/.local/bin/clia" 2>/dev/null || printf '(absent)')" = "$REEL_LIEN"
vrai "la configuration clia du poste est dans l'état du départ" \
  test "$(ls "$HOME/.config/clia" 2>/dev/null || printf '(absent)')" = "$REEL_CONFIG"
vrai 'et le dépôt réel non plus' \
  test "$(git -C "$RACINE" status --porcelain | sort)" = "$REEL_ETAT"

bilan
