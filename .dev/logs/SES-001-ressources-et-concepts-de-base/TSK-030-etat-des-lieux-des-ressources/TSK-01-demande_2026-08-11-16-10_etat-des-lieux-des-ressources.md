# Demande interprétée, tâche 30

Écrit le 2026-08-11 à 16:10, avant toute exploration. `MET-003` étape 1.

## Énoncé

Tâche 30, `[analyse]` : état des lieux de la définition et de l'instrumentation des ressources.

> Analyser l'ensemble des documents du repo et lister tous ceux qui traitent des ressources d'une manière ou d'une autre.
>
> Faire une synthèse de la notion de ressource. Définir des axes pertinents d'analyse selon les problématiques abordées.
>
> Regrouper ce qui est implémentable de manière smart et dire quel livrable ils modifient ou crée. Créer un plan que ne contient que les éléments non implémentables.
>
> Regrouper tout le reste dans un ISU et y mettre en relation les NON bloquants.
>
> Faire du ménage dans les NON.

## Cinq livrables demandés

| Réf | Livrable |
|---|---|
| L1 | L'inventaire des documents qui traitent des ressources |
| L2 | La synthèse de la notion de ressource, sur des axes d'analyse |
| L3 | Le regroupement de ce qui est implémentable, avec le livrable visé |
| L4 | Un plan |
| L5 | Un ou des `ISU`, avec les `NON` bloquants en relation |
| L6 | Le ménage dans les objections |

## Une contradiction dans l'énoncé

« Créer un plan que ne contient que les éléments **non implémentables**. »

La phrase précédente demande de regrouper ce qui **est** implémentable. La phrase suivante envoie « tout le reste » dans un `ISU`.

Si le plan porte le non-implémentable et que le reste va dans une issue, les deux se recouvrent et l'implémentable n'a nulle part où aller.

**Lecture retenue : le plan ne contient que ce qui est implémentable.**

Trois raisons. `PDC-003`, que l'humain a demandé à la tâche 23, place les plans au régime extrême SMART. `MET-004`, écrit à la tâche 29 sur demande de l'humain, prescrit exactement le mouvement inverse de celui que la phrase littérale décrirait : le non-SMART sort du plan et devient une issue. Et `RES-031` pose que l'issue est non-SMART par construction.

L'ambiguïté est signalée et portée par une objection.

## Ce que je sais avant d'explorer

La notion de ressource est le socle du système : `RES-001` la définit, et trente-cinq définitions en dérivent.

Elle a été révisée plusieurs fois depuis le 2026-08-09 : composition et atomicité par `ADR-004`, identité par `ADR-008`, registre directif par `ADR-015`, et le savoir comme relation par les réponses à `NON-004`.

Le dépôt compte trente-quatre objections. « Faire du ménage » suppose d'établir lesquelles sont répondues, lesquelles font doublon, et lesquelles portent sur un état révolu.

## Ce que je vérifierai

Combien de documents traitent des ressources, et sous quels angles. C'est L1, et il commande L2.

L'état de chacune des trente-quatre objections : effet, état, et si la question qu'elle pose a reçu une réponse ailleurs.

## Ce que je ne ferai pas

**Fermer une objection sans réponse écrite.** Le ménage consiste à constater ce qui est répondu, non à décider que ce ne l'est plus.
