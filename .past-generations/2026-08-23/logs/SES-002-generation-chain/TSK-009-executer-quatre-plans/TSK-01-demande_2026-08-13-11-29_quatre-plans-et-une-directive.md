# Demande interprétée, tâche 9 de SES-002

Écrit avant toute exploration. `MET-003` étape 1.

## Ce que l'humain demande

**Exécuter quatre plans** : `PLN-011`, `PLN-012`, `PLN-013`, `PLN-014`.

Et une directive de méthode :

> Après chaque exécution de plan, dire les fonctionnalités qui ont été implémentés et comment l'utiliser. Mettre cette directive dans la méthodologie qui guide l'exécution des plans.

## Ce que la tâche autorise, et que la précédente interdisait

**Elle est déclarée `[implémentation]`.** `BUG-002` R1, écrit à la tâche 8 : une tâche n'exécute un plan que si son type le demande. Celle-ci le demande explicitement, et nomme les quatre plans.

C'est le cas de figure correct, et le premier depuis `PLN-009`.

## Les huit chantiers en jeu

| Plan | Chantiers | Ce qu'il livre |
|---|---|---|
| `PLN-011` | 1 | `clia res ls TYPE` affiche l'état qui varie |
| `PLN-012` | 2 | Un classement des items ouverts, puis `clia focus` |
| `PLN-013` | 2 | Le critère de départage des objections, et où loger ce qui n'en est plus une |
| `PLN-014` | 2 | Le type `Fonctionnalité`, puis le rattachement des plans |

## La directive, et ce qu'elle change

**Elle porte sur ce que je rends à l'humain, pas sur ce que je produis.**

Aujourd'hui, un plan exécuté laisse un journal de fait et un message de commit. Aucun des deux ne dit **comment se servir** de ce qui vient d'être livré. L'humain doit lire le code ou l'aide pour le découvrir.

**C'est la même plainte que la tâche 6** : « on ne sait pas les fonctionnalités que vont implémenter PLN ». La tâche 6 l'a traitée en amont, par le type `Fonctionnalité` ; celle-ci la traite en aval, par ce que l'exécution rend.

## Ce qui reste à établir

**Quelle méthodologie guide l'exécution des plans.** `MET-003` porte la journalisation, `MET-004` la réévaluation d'un plan par le régime SMART. Je ne sais pas encore s'il en existe une pour l'exécution ; si non, la directive devra trouver son lieu.

## Ce que je surveille

**Le défaut de `BUG-002` est encore chaud.** Quatre plans à exécuter, huit chantiers, et la tentation d'en faire plus que demandé. Ce qui n'est pas dans ces quatre plans n'est pas dans cette tâche.
