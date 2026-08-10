# Interprétation de la demande, tâche 6

## Demande

Tâche 6 de `workspace/session.md`, intitulée `[implémentation] clia resource CMD ...`. Deux jeux de commandes spécifiés en bash, plus une consigne d'exécution.

Ressource `resource`, avec les alias `res` et `r` : `ls` sans argument pour la liste des ressources connues, `ls RESOURCE` pour les instances avec `id(<PREFIX>-<SEQ>) DESCRIPTION STATUS`, `new RESOURCE DESCRIPTION` avec slug dérivé de la description, `show ID`, `edit ID` avec `CLIA_EDITOR`.

Ressource `configuration`, avec les alias `config` et `c` : `ls`, `set KEY VALUE` assignant `CLIA_KEY` ou `KEY`, `edit`.

Et : implémenter immédiatement un premier jet de `clia` et de `setup.sh` en bash, en prenant les meilleures décisions selon les meilleures pratiques et les conventions des systèmes Linux.

## Intention

Sortir du documentaire. Le critère de convergence de la session exige que le concept de ressource soit défini, utilisable **et instrumenté** ; les cinq premières tâches ont couvert les deux premiers termes. `ADR-003` D8 posait par ailleurs que restaurer un moyen d'installation est la première tâche d'outillage, avant toute fonctionnalité.

## Portée retenue

Les neuf commandes demandées, plus quatre ajouts que les conventions imposent et que la demande n'interdit pas : `clia --version`, `clia --help`, `clia --context`, et `clia config path`. Les trois premières relèvent de la réflexivité, principe emprunté à `linux-inspect` et repris par `FND-001` section 6 sous le nom de découvrabilité. La quatrième évite de deviner où vit la configuration.

`setup.sh` couvre `activate`, `deactivate`, `check`, `install`, `uninstall`, `help`. Seul `activate` était demandé ; les cinq autres suivent la doctrine d'installation de `linux-inspect`, qui distingue l'activation éphémère de l'installation permanente et exige que celle-ci soit explicite.

Une suite de tests a été écrite, sans que la demande la mentionne. Motif : `ADR-003` D8 exige que le dépôt porte à tout moment un moyen de vérifier que l'installation fonctionne, et `ANL-001` établit que le refactor du 2026-08-08 a archivé les tests sans que personne ne s'en aperçoive.

## Décisions d'implémentation prises, et ce qui les fonde

| Décision | Fondement |
|---|---|
| Grammaire nom puis verbe | La demande l'emploie. `FND-001` section 5.1 documente les deux ordres et note que celui-ci se prête mieux à l'extensibilité. Tranche la question que `ADR-003` D3 reportait |
| `CLIA_HOME` distinct du dépôt courant, résolu à l'exécution | Bogue constaté dans ce dépôt le 2026-07-31 : le dépôt de référence était le même quel que soit le répertoire de lancement |
| Configuration selon la convention XDG, jamais exécutée | Conventions Linux. Un fichier de configuration ne doit pas pouvoir exécuter du code |
| Messages sur `stderr`, données sur `stdout` | `FND-001` section 6 : la sortie doit servir un humain et un programme. `ADR-003` D9 en ajoute un troisième, l'agent |
| `res new` refuse un type sans définition | `skl-001-ressource` règle A5 : une première instance ferait précédent. Répond de fait à `NON-011` Q7 |
| `res new` ne rédige aucun contenu | `ADR-003` D5 : `clia` garantit, l'agent interprète |
| Nommage dérivé du cycle de vie déclaré | `RES-001` : séquence pour vivant et travail, date pour point-fixe |
| `res ls` affiche les types employés sans définition | La dette de `NON-011` doit être visible dans l'outil, non seulement dans une objection |
| Archives exclues des parcours, par variable configurable | Bogue trouvé au premier essai : quatorze ADR archivés étaient comptés parmi les trois ADR actifs |
| Tolérance du singulier et du pluriel | `FND-001` section 6, découvrabilité. Le nom exact du champ `title` ne doit pas être une devinette |
| Aucune opération git | Harnais actuel. La règle est contestée par `NON-010` Q6, non levée |

## Ambiguïtés et incohérences identifiées, signalées comme le processus l'exige

**L'identifiant.** La demande décrit l'identifiant d'une instance comme `<PREFIX>-<SEQ>`. `ADR-001` D3 pose que l'identité est `<PREFIXE>-<SLUG>` et que le numéro n'est qu'un rang. L'implémentation a permis d'éprouver la question : `clia res show 002` est ambigu dès que deux types portent un rang 002. La preuve est consignée dans `NON-001`, dont le journal est mis à jour.

**La granularité de la ressource.** `RES-001` pose qu'une ressource est un fichier. `ANL-001` est un répertoire de neuf fichiers, format imposé par la tâche 1. `clia res ls` compte donc neuf analyses là où il y en a deux. Nouvelle objection `NON-012`.

**Les répertoires du code.** `ARCHITECTURE.md` prévoit `src/` et `tests/` et ne mentionne ni `bin/` ni `lib/`. L'implémentation emploie `bin/clia` et `lib/clia/*.sh`, qui sont les emplacements conventionnels pour du bash exécutable et sourcé. Écart signalé ici, sans objection : il porte sur un harnais à préciser, non sur une décision de conception.

## Directives inexécutables constatées

| Directive | État | Traitement |
|---|---|---|
| `CLAUDE.md` documente sept commandes `clia` | Aucune n'existait | Trois des sept sont désormais implémentées : `clia -h`, `clia -v`, `clia -c`. `clia config` et `clia ls` le sont sous une autre forme. `clia ses` et `clia setup` ne le sont pas |
| Un skill encadre le codage de CLI bash | `skl-011-codage-cli-bash` existe dans les archives, pas dans le dépôt actif | Conventions tirées de `FND-001` section 6 et de `linux-inspect` |
| `ARCHITECTURE.md` donne la carte du système | Réduit à une liste de répertoires | Non utilisable. Écart signalé ci-dessus |

## Ce qui n'a pas été fait

Aucune commande hors de celles demandées et des quatre ajouts de réflexivité. En particulier, pas de `clia validate` : les neuf contrôles de `skl-001-ressource` en sont le cahier des charges, `ADR-003` D9 le dit, et la session d'outillage est annoncée.

Aucun contenu de ressource produit par l'outil. `res new` crée un squelette.

Aucune modification de `CLAUDE.md`, `ARCHITECTURE.md` ni `INTENTION.md`.
