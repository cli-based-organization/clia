# Le cli `clia` et son installation

## Ce qu'est le cli `clia`

**clia** est un système d'information (SI) collaboratif entre humains + automatismes + agents IA. Consultez l'[INTENTION ultime de ce repo](../../INTENTION.md) 

Le cli `clia` est un programme en ligne de commandes (CLI) exposant des automatismes qui respectent les conventions et concepts du SI clia. 

## installation de clia

L'installation permet de rendre disponible le cli `clia` à des utilisateurs dans un certain environnement.

Un utilisateur/développeur installe clia à partir du repo:

```sh
# dans le repo

. setup.sh install --activate  # active le repo clia de dev. clia est seulement utilisable dans ce repo et dans cette session
# ou bien
. setup.sh activate  # raccourci de `install --activate`

. setup.sh install --dev # active le repo clia de dev. clia est disponible seulement 
```

**pré-conditions**: 

- scénario 1: la commande `clia` n'est pas disponible.
- scénario 2: la commande `clia` est disponible.

**post-condition**: 

- scénario 1: la commande `clia` est disponible.
- scénario 2: aucune modification. Avise que la commande existe. Et dit si l'installation impliquerait une nouvelle autre configuration (ou autre version, ou autre emplacement). Sortie en erreur.

L'option `--force` permet une installation dans le scénario 2 (clia déjà installé).

**Le mode --dev** implique que l'exécutable `clia` utilise le repo clia en cours de développement. Dans ce mode, l'exécution de clia se fait dans le repo git courant.

**Le mode --activate** rend également disponible le cli `clia`. Mais seul une exécution sur le repo source en développement est permis.

## fonctionnalité inverse => uninstall

Le cli `clia` expose une fonctionnalité de désinstallation:

```sh
clia setup uninstall  # désinstallation

clia -h  # => clia n'est pas accessible
```

