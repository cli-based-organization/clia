#!/usr/bin/env bash
# Description: Amène le dépôt à une version plus récente de clia.
# Périmètre: dépôt
# Signature: upgrade [--with-instances | --migrate] [--all] [--force] [VERSION]
# Option: upgrade --with-instances
# Option: upgrade --migrate
# Option: upgrade --all
# Option: upgrade --force
#
# Implémente SES-001 tâche 17.
#
# Le travail est dans _scripts/lib/mise-a-jour.sh, que clia-downgrade(1)
# partage : les deux commandes font la même chose et ne diffèrent que par le
# sens exigé. Une écriture unique, et un « exactement pareil » garanti plutôt
# que ressemblant.

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
  cat <<'EOF' | _clia_man clia-upgrade 1 "Manuel de l'utilisateur clia"
NOM
clia-upgrade - amener un dépôt à une version plus récente de clia

SYNOPSIS
clia upgrade [--with-instances | --migrate] [--all] [--force] [VERSION]

DESCRIPTION
Un dépôt instrumenté tient de clia des copies : ses fichiers
harnais, les ressources qu'il a reprises, les skills posés sous
.claude, et le texte des fonctionnalités posées dans son harnais.

Mettre à jour, c'est refaire ces copies depuis la version visée.
Sans version, la plus récente que le dépôt source de clia déclare.

La version qu'un dépôt suit est inscrite dans sa carte, sous
« clia-version: ». Sans elle, le sens d'une mise à jour ne se
vérifierait pas : clia le dit, aligne quand même, et pose le champ.

clia-downgrade(1) fait la même chose en sens inverse.

LA REGLE DES COPIES EDITEES
Une copie identique à ce dont elle vient est remplacée sans rien
dire : personne ne perd rien.

Une copie qui en diffère est signalée et laissée. Quelqu'un l'a
touchée, et clia ne sait pas si cela comptait. L'option --force la
remplace quand même.

Ce que l'humain édite, ce sont les primitives — celles de la
ressource qui les publie. Un fichier posé qui diverge est donc un
écart à signaler, non un travail à préserver indéfiniment.

C'est la même règle pour le harnais et pour les skills. Une règle
par nature de fichier aurait obligé à se souvenir de laquelle
s'applique où.

CE QUI EST MIS A JOUR
Les fichiers harnais, depuis les primitives que clia portait à la
version visée.

Les ressources qui viennent de clia, chacune à la version que clia
déclarait pour elle à ce moment-là — et non à sa dernière. C'est ce
qui fait qu'un dépôt aligné tient un ensemble cohérent, et non un
mélange.

Les fonctionnalités et les skills des ressources mises à jour sont
reposés. Une fonctionnalité l'est toujours : la zone gérée du
harnais n'appartient qu'à clia. Un skill suit la règle des copies.

OPTIONS
--all
       Met à jour toutes les ressources du dépôt, et non les seules
       ressources de clia. Chacune est reprise de l'extension dont
       elle vient, à la dernière version que celle-ci déclare.

--with-instances, --migrate
       Fait franchir aux instances les sauts de version, en lançant
       les scripts que chaque ressource porte sous migrations/.

       Un saut sans script fait refuser la mise à jour de cette
       ressource avant qu'aucun fichier ne soit posé : une
       migration à moitié faite laisserait des instances dans un
       état que rien ne nomme.

--force
       Remplace les copies qui diffèrent de ce dont elles viennent.
       Ce qui avait été écrit sur place est perdu.

SORTIE
Rien sur la sortie standard : ce qui est rapporté est un compte
rendu, et il va sur la sortie d'erreur.

CODE DE RETOUR
0
       La demande est satisfaite, même si tout était déjà à jour.

1
       Refus : version inconnue, sens inverse de celui demandé, ou
       une ressource au moins n'a pas pu être mise à jour.

2
       Demande mal formée.

FICHIERS
clia.yaml, .clia.yaml, .dev/clia.yaml
       La carte. Son champ « clia-version: » dit quelle version de
       clia le dépôt suit ; son bloc « use: extensions: » dit d'où
       viennent ses ressources et sous quelle version.

<instance>/livrables/migrations/<de>-<vers>.sh
       Le script d'un saut de version, lancé par --migrate. Il
       reçoit le dépôt, le nom de la ressource, et les deux
       versions du saut.

EXEMPLES
Voir les versions offertes, puis aligner le dépôt :

       $ clia setup version ls
       $ clia upgrade

Aligner sur une version précise, ressources comprises :

       $ clia upgrade --all 0.9.0

Mettre à jour une seule ressource, instances comprises :

       $ clia ses upgrade --migrate

VOIR AUSSI
clia(1), clia-downgrade(1), clia-setup(1), clia-extension(1),
clia-version(1)
EOF
}

# --------------------------------------------------------------------------

for _arg in "$@"; do
  [[ "$_arg" == '--man' ]] || continue
  manuel
  exit 0
done

_clia_mj_depot upgrade "$@"
