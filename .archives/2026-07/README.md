# clia

Cadre de collaboration entre un humain, des automatismes et un agent IA, dans un dépôt versionné.

Le principe : l'interface de travail est **des fichiers markdown**, pas une conversation. L'humain soumet un problème dans un point d'entrée unique, l'agent propose un plan, aucune exécution n'a lieu tant qu'une objection reste ouverte, et chaque tâche laisse une trace. Ce qui est spécifiable et vérifiable est confié à `clia`, un CLI **100 % déterministe** ; ce qui exige du jugement reste à l'agent.

Voir `INTENTION.md` pour le pourquoi, `CONSTITUTION.md` pour la gouvernance, `ARCHITECTURE.md` pour la structure, et `CLAUDE.md` pour le mode opératoire de l'agent.

## Prérequis

| Dépendance | Rôle |
|---|---|
| `bash` | l'outil est écrit en bash ; cible **Debian 12**, aucun autre shell n'est supporté |
| `yq` (implémentation mikefarah) | lecture de la source documentaire dont l'aide est générée |
| `git` | résolution de la racine d'un dépôt et création d'un dépôt cible |

L'installation vérifie ces dépendances **avant** d'écrire quoi que ce soit et s'arrête en nommant ce qui manque.

## Installer `clia`

L'outil s'installe **une fois, pour votre compte utilisateur**, sans privilèges élevés. Il devient alors appelable depuis n'importe quel répertoire. Il n'est jamais copié dans les dépôts que vous équipez : il n'en existe qu'une seule copie, celle de cet arbre source.

```
git clone <url-du-depot> ~/git/clia
cd ~/git/clia
./setup.sh install
source ~/.bashrc
```

`clia` répond maintenant depuis n'importe où :

```
clia --version
clia -h
```

### Mode dev

L'installation rattache le nom de la commande à **cet arbre source** : aucune copie, aucune construction. Toute modification que vous faites ici est immédiatement active. Si vous déplacez l'arbre source, relancez `./setup.sh install` depuis son nouvel emplacement : le rattachement est mis à jour plutôt que dupliqué.

### Vérifier et désinstaller

```
./setup.sh --check       # état de l'installation, n'écrit rien ; 0 si installé, 1 sinon
./setup.sh --uninstall   # retire exactement ce que l'installation a posé
```

L'installation écrit un bloc encadré par deux marqueurs explicites dans `~/.bashrc`. Le retrait supprime ce bloc et rien d'autre : votre configuration retrouve son état d'origine à l'octet près.

### Activation ponctuelle, sans installation

Pour essayer sans rien écrire dans votre configuration :

```
. setup.sh activate
```

Ajoute `src/bin` au `PATH` de la session courante uniquement. Rien n'est persisté.

## Initialiser un nouveau dépôt

```
clia setup init mon-projet     # crée le dépôt et l'équipe
clia setup init .              # équipe le répertoire courant
clia setup init -C ~/git/parent mon-projet
clia --dry-run setup init mon-projet   # énumère ce qui serait posé, sans écrire
```

Ce qui sera posé dans la cible : les fichiers de harnais, le gabarit d'intention, les compétences, les gabarits, la couche type des ressources, le squelette de version, et les répertoires de ressources **vides**, prêts à recevoir la conception propre à votre projet.

Ce qui n'y sera **pas** posé : l'outil lui-même, sa documentation, et les ressources de conception propres à ce dépôt-ci. Un dépôt équipé ne contient aucun exécutable ; il suppose que vous avez installé `clia` séparément, comme décrit plus haut.

La commande refuse d'agir sur un dépôt déjà équipé, et sur un emplacement non vide sauf `--force`. Elle écrit dans la cible une marque (`.dev/installation.yaml`) indiquant quelle version du système d'augmentation y a été posée, depuis quelle révision, et l'empreinte de chaque fichier écrit.

```
clia setup versions            # versions disponibles et version installée ici
```

## Commandes disponibles aujourd'hui

```
clia -h              # aide courte
clia --man           # aide longue
clia --version       # version du contenu métier du dépôt
clia --config        # racine détectée et chemins de travail
```

Deux options globales s'appliquent à toute commande : `--debug` (traces sur la sortie d'erreur) et `--dry-run` (plan d'exécution sans effet de bord).

### Sessions

Une session est le point d'entrée unique de l'humain. Elle a trois états : en planification, active, archivée.

```
clia ses status      # une session est-elle active ? combien d'archives ?
clia ses check       # valide le format du fichier de session
clia ses plan        # crée une session en planification
clia ses open        # ouvre une session (échoue si une session est déjà active)
clia ses close       # archive la session active
clia ses new         # ferme puis ouvre
```

L'agent IA **n'invoque jamais** ces commandes mutantes : les transitions de session sont opérées par l'humain seul.

### Ressources et version

```
clia res ls          # types de ressources livrables connus
clia res ls PLN      # instances d'un type, avec état et version
clia release patch   # incrémente la version du contenu métier (major|minor|patch)
```

`release` ne touche que `version.yaml`, jamais les versions des ressources, qui vivent dans leur propre frontmatter. Aucune opération git n'est effectuée : commits et étiquettes restent votre décision.

## Organisation du dépôt

| Emplacement | Contenu |
|---|---|
| `CLAUDE.md`, `CONSTITUTION.md`, `ARCHITECTURE.md` | harnais : mode opératoire, gouvernance, structure |
| `INTENTION.md` | intention du dépôt, en édition humaine uniquement |
| `.dev/` | ressources d'augmentation : décisions, exigences, spécifications, principes, acteurs, cas d'usage, plans, analyses, fondations, bogues, compétences |
| `.dev/session.md` | point d'entrée unique de l'humain, en édition humaine uniquement |
| `.dev/logs/ia-output/` | trace immuable de chaque tâche |
| `src/` | l'outil `clia` et sa source documentaire |
| `test/` | scénarios exécutables, en bac à sable isolé |

## Tests

```
./test/test_clia.sh
./test/test_setup.sh
```

Les scénarios s'exécutent dans un répertoire temporaire isolé et n'écrivent jamais dans votre configuration de shell réelle.

## État du projet

Ce dépôt est en conception active. La couche 1 (rendre l'outil disponible) et la couche 2 (équiper un dépôt, connaître les versions) sont livrées et éprouvées. Les parcours de mise à niveau et de retour en arrière (`clia setup upgrade`, `clia setup downgrade`) sont conçus et réservés, mais **non implémentés** : les invoquer retourne « sous-commande inconnue ».

Note : le répertoire `doc/` contient encore la documentation d'un autre outil, héritée du dépôt d'origine. Elle ne décrit pas `clia` et ne doit pas être lue comme telle.
