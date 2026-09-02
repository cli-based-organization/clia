#!/usr/bin/env bash
# Description: Ramène le dépôt à une version plus ancienne de clia.
# Périmètre: dépôt
# Signature: downgrade [--with-instances | --migrate] [--all] [--force] [VERSION]
# Option: downgrade --with-instances
# Option: downgrade --migrate
# Option: downgrade --all
# Option: downgrade --force
#
# Implémente SES-001 tâche 17.
#
# Le contraire de clia-upgrade(1), et rien d'autre : le travail est le même,
# et il est écrit une seule fois dans _scripts/lib/mise-a-jour.sh. Seul le
# sens exigé change — la cible doit être inférieure à la version suivie.
#
# Deux commandes plutôt qu'une option de sens, parce que SES-001 tâche 17 les
# nomme ainsi, et parce qu'un sens donné par une option se tape par
# distraction là où un nom se tape par intention.

set -euo pipefail

_CLIA_NOM='clia'
# shellcheck source=../commun.sh
. "$CLIA_SOURCE_DIR/_scripts/lib/commun.sh"
# shellcheck source=../texte.sh
. "$CLIA_SOURCE_DIR/_scripts/lib/texte.sh"
# shellcheck source=../version.sh
. "$CLIA_SOURCE_DIR/_scripts/lib/version.sh"
# shellcheck source=../maj.sh
. "$CLIA_SOURCE_DIR/_scripts/lib/maj.sh"
# shellcheck source=../mise-a-jour.sh
. "$CLIA_SOURCE_DIR/_scripts/lib/mise-a-jour.sh"

# --------------------------------------------------------------------------

manuel() {
  cat <<'EOF' | _clia_man clia-downgrade 1 "Manuel de l'utilisateur clia"
NOM
clia-downgrade - ramener un dépôt à une version plus ancienne de clia

SYNOPSIS
clia downgrade [--with-instances | --migrate] [--all] [--force] [VERSION]

DESCRIPTION
Le contraire de clia-upgrade(1). Le travail est le même — refaire
depuis la version visée les copies qu'un dépôt tient de clia — et
seul le sens exigé change : la cible doit être inférieure à la
version que le dépôt suit.

Tout ce qui décrit la mise à jour, la règle des copies éditées et
les options est dans clia-upgrade(1). Cette page ne redit que ce
qui lui est propre.

Sans version, clia prend la plus récente que le dépôt source
déclare — ce qui, pour un downgrade, sera refusé si le dépôt la
suit déjà ou la dépasse. Une version est donc presque toujours
donnée ici.

OPTIONS
--all, --with-instances, --migrate, --force
       Les mêmes que celles de clia-upgrade(1).

       Une migration en sens inverse enchaîne les sauts descendants
       et exige, comme l'autre, un script par saut. Une ressource
       qui n'en fournit que pour monter fait refuser la
       descente : la dire possible sans l'être serait pire.

SORTIE
Rien sur la sortie standard.

CODE DE RETOUR
0
       La demande est satisfaite.

1
       Refus : version inconnue, cible non inférieure à la version
       suivie, ou une ressource au moins n'a pas pu être ramenée.

2
       Demande mal formée.

FICHIERS
clia.yaml, .clia.yaml, .dev/clia.yaml
       La carte, et son champ « clia-version: ».

EXEMPLES
Revenir à une version antérieure :

       $ clia downgrade 0.9.0

VOIR AUSSI
clia(1), clia-upgrade(1), clia-setup(1)
EOF
}

# --------------------------------------------------------------------------

for _arg in "$@"; do
  [[ "$_arg" == '--man' ]] || continue
  manuel
  exit 0
done

_clia_mj_depot downgrade "$@"
