
<!-- BEGIN session feature -->

## Fonctionnalité : session

Le dépôt tient un fichier de session dans `.dev/session.md`. Il décrit le contexte de travail en cours et une liste de tâches numérotées. Quand l'utilisateur demande d'exécuter une tâche — « exécute la tâche 2 », « fais la tâche suivante », « exécute les tâches restantes » — c'est de ce fichier qu'il parle.

### Structure du fichier de session

```
# SES-NNN                    identifiant de la session
## CONTEXTE                  pourquoi ce travail existe
## INTENTION                 ce que la session cherche à apprendre ou produire
## LIVRABLES attendus        liste des sorties visées
## Tâches
### N. [type] titre          une tâche, numérotée ; type = implémentation, refactor, primitive, fix…
```

Le corps d'une tâche peut contenir des blocs de code montrant la commande ou l'API visée : ils décrivent l'**intention d'usage**, pas forcément une implémentation littérale.

### Procédure

1. **Lis le fichier en entier** avant d'agir, pas seulement la tâche visée : le CONTEXTE et l'INTENTION conditionnent les choix d'implémentation, et les autres tâches indiquent où l'architecture doit pouvoir aller.
2. **Identifie la tâche demandée** par son numéro. Si la demande est ambiguë (« la tâche suivante » alors que plusieurs sont inachevées), demande laquelle plutôt que de deviner.
3. **Si l'énoncé est incomplet ou contradictoire, pose la question** au lieu de combler le vide par une hypothèse. Un énoncé de tâche est une intention résumée, pas une spécification.
4. **Exécute la tâche** en respectant les conventions de ce fichier (`CLAUDE.md`) et les principes du dépôt.
5. **Vérifie réellement** le résultat avant de le déclarer terminé : exécute les commandes concernées, teste les cas d'erreur, et contrôle qu'un cycle installation/désinstallation laisse le dépôt dans son état initial. Ne rapporte jamais un succès non vérifié.
6. **Nettoie les artefacts de test** (fichiers temporaires, skills ou fonctionnalités installés pour l'essai) avant de conclure, et vérifie que le dépôt est propre.
7. **Rapporte** ce qui a été fait, ce qui a été vérifié, et ce qui reste en suspens — y compris les problèmes rencontrés en chemin.

### Règles

* **Ne modifie jamais `.dev/session.md` de ta propre initiative.** C'est le document de travail de l'utilisateur : n'y coche pas de tâche, n'y ajoute pas de statut, ne le réordonne pas sans demande explicite.
* **Une tâche à la fois**, sauf demande contraire. Ne prends pas d'avance sur les tâches suivantes.
* **Anticipe sans implémenter** : si une tâche ultérieure impose une contrainte d'architecture, choisis une structure qui la rendra possible, mais n'écris pas son code maintenant.
* Les fichiers `BUGS.md` et `ENHANCEMENT.md` à la racine collectent les anomalies et améliorations repérées hors tâche courante. Consulte-les pour le contexte, signale ce que tu y vois de pertinent, mais ne les traite pas sans demande.

<!-- END session feature -->
