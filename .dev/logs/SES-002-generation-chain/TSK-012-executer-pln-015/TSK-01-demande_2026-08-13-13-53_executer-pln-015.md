# La demande, tâche 12 de SES-002

`MET-003` étape 1. `MET-003` R1 : ce log ne rapporte que la tâche 12.

## L'énoncé, repris sans reformulation

> ## 12. [implémentation] exécute le PLN-015

## Ce que je comprends

Exécuter `PLN-015`, « Politique d'autorisation du dépôt », produit une heure plus tôt par la tâche 10.

Le type `[implémentation]` autorise l'exécution.

## Ce qui rend cette tâche différente

**C'est le premier plan de ce dépôt exécuté par une tâche distincte de celle qui l'a créé.** `BUG-002` a mesuré que deux plans sur trois avaient été exécutés dans leur propre tâche, et que les tâches d'exécution ultérieures avaient alors produit zéro livrable. `MET-005` étape 1 a écrit la règle ; la tâche 10 l'a tenue ; celle-ci est l'autre moitié de la démonstration.

**Le plan est de moi, et il déclare lui-même sa portée** : trois chantiers exécutables, deux points sortis faute de critère exécutable. J'exécute les trois, je ne comble pas les deux.

## Les trois chantiers, tels que le plan les déclare

| Chantier | Livrable | Dépend de |
|---|---|---|
| A | Un compte rendu de mesure : un hook peut-il autoriser ? | rien |
| B | La règle de conduite dans le harnais | rien |
| C | `clia config ia policy check` | A |

## Ce que je surveille

**Le chantier A peut faire tomber le plan.** Son critère est une mesure, et le plan déclare que si elle échoue, C n'a plus d'objet sous cette forme. Une exécution honnête doit accepter ce résultat, pas le contourner.

**`NON-040` est ouverte et bloquante.** Elle porte sur ce que la politique autorisera — donc sur les deux chantiers sortis du plan, pas sur les trois qui y sont. Exécuter A, B et C ne la préjuge pas. Je vérifie ce point avant de commencer plutôt qu'après.

**`MET-005` étape 4 s'applique** : cette tâche livre une fonctionnalité, et devra dire laquelle et comment s'en servir.

## Le livrable attendu

Un compte rendu de mesure, une section de méthodologie, et une commande. Le plan reste `propose` si un seul des trois n'aboutit pas.
