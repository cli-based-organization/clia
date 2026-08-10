# Résultat de la validation, tâche 6

## Code : conforme

`bash -n` passe sur les six fichiers. `shellcheck -S warning` ne signale rien sur les cinq fichiers de code et la suite de tests.

`tests/test_clia.sh` : **66 assertions, 66 réussies, 0 échouée**, code de retour nul.

Toutes les commandes demandées ont été essayées à la main, dans le dépôt de travail et dans un dépôt d'essai distinct de `CLIA_HOME`.

## Trois bogues trouvés, puis corrigés, puis revérifiés

Les tests ont trouvé trois bogues que les essais manuels n'avaient pas révélés, et un quatrième qui était une friction d'usage.

| Bogue | Statut |
|---|---|
| SIGPIPE sur `exit` prématuré dans un tube, code 141 | corrigé, test de non-régression en place |
| Archives comptées comme instances actives, 17 au lieu de 3 | corrigé, exclusion configurable, deux tests |
| Valeur de type comportant une espace, scindée au reformatage | corrigé |
| Le type `Faits` ne répondait pas à `fait` | corrigé, tolérance singulier et pluriel, deux tests |

## Six échecs de test qui n'étaient pas des bogues de code

À la première exécution, six assertions échouaient. Le diagnostic est instructif et mérite d'être consigné.

**Quatre étaient des tests mal ordonnés.** Ils vérifiaient `res ls TYPE` avant qu'aucune instance n'existe, et attendaient un tableau là où `clia` affiche à juste titre « aucune instance ». Les tests ont été déplacés après les créations, et un test a été ajouté pour le cas sans instance.

**Deux étaient le même piège d'`awk` que le bogue SIGPIPE** : un bloc `END { exit 1 }` qui écrase le code de sortie du bloc précédent. La méconnaissance qui a produit le bogue a aussi produit le faux échec du test censé le trouver. Corrigé par un drapeau.

Un septième échec, lui, portait sur le modèle et non sur le code : voir ci-dessous.

## Ce que la validation a établi sur le modèle

**`clia res show 002` est ambigu, et c'est correct.** Le test attendait un succès ; le comportement juste est le refus, avec la liste des candidats. Dans un dépôt à deux types, `CHO-002` et `RES-002` coexistent.

Ce n'est pas un défaut de l'outil, c'est une propriété du numéro de séquence, et c'est la démonstration à l'usage du défaut D1 de `ANL-001`. Le test a été réécrit pour vérifier le refus, et deux assertions supplémentaires vérifient que les candidats sont nommés. La preuve est consignée dans le journal de `NON-001`.

**Le décompte des instances est faux pour un type.** `clia res ls` annonce neuf analyses ; le dépôt en contient deux, dont une en bundle de neuf fichiers. Le décompte est juste au sens de `RES-001`, qui pose qu'une ressource est un fichier, et faux au sens du contenu. `NON-012` est ouverte pour cela, avec l'effet `conditionnel` : la commande reste utilisable et son décompte est faux pour un seul type.

## Sécurité : conforme

Le fichier de configuration n'est jamais sourcé, et un test le prouve en y écrivant une substitution de commande qui ne s'exécute pas.

`setup.sh install` demande confirmation, sauvegarde `~/.bashrc` et délimite son ajout. `activate` ne modifie aucun fichier. `config set` réécrit de manière atomique.

## Effet de bord constaté et nettoyé

Les essais manuels ont créé `~/.config/clia/config`, absent avant la tâche. Son contenu a été relu, puis le fichier et son répertoire ont été supprimés. Le poste est revenu à son état initial.

Les tests, eux, sont isolés par construction et `git status` ne montre aucun résidu après exécution.

## Livrables documentaires : conformes

`NON-012` et la mise à jour de `NON-001` passent les contrôles V1, V2, V4, V5, V6 et V8. V3 reste inapplicable au type `objection` faute de chemin standardisé vers sa définition, ce que `NON-011` porte.

## Écart signalé sans objection

`ARCHITECTURE.md` prévoit `src/` et `tests/` et ne mentionne ni `bin/` ni `lib/`. L'implémentation emploie `bin/clia` et `lib/clia/*.sh`, emplacements conventionnels du bash exécutable et sourcé. L'écart porte sur un harnais à préciser, non sur une décision de conception, et `ARCHITECTURE.md` est co-édité : le corriger relève d'une demande de l'humain.
