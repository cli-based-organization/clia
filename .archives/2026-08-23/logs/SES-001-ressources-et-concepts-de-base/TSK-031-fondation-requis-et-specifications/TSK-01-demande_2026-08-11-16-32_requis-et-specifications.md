# Demande interprétée, tâche 31

Écrit le 2026-08-11 à 16:32, avant toute exploration. `MET-003` étape 1.

## Énoncé

Tâche 31, `[conception]` : recherche de fondation sur les artéfacts d'architecture, principalement les requis et les spécifications.

> Il me semble que ça fait plusieurs fois que je fais cette demande. Puiser d'abord dans les FND existants à partir de $HOME/git.
>
> Puis décrire l'historique des RFC et autres mécanismes de publication des spécifications. Parler de la différence entre normalisation, standardisation et spécification.
>
> Donner des exemples archétypaux et historiquement importants et dresser un portrait de l'évolution des formes de publication et de leurs raisons d'être, usage, intérêt.
>
> En particulier : quels sont les différents types de spécifications et de documentation des requis ? Et quelle est la distinction entre requis et spécification ?
>
> Faire une analyse sur la meilleure approche de documentation des requis et spécification d'architecture compatible avec le système clia. En particulier le fait qu'il y ait des ressources sources et des ressources générées (dont l'implémentation du code). Où doit se trouver la source de vérité pour la description de l'implémentation et des contraintes, choix techniques, etc.

## Deux livrables

| Réf | Livrable | Type |
|---|---|---|
| L1 | La recherche de fondation | `FND` |
| L2 | L'analyse sur l'approche compatible avec `clia` | `ANL` |

## Une remarque de l'humain qui commande la méthode

« Il me semble que ça fait plusieurs fois que je fais cette demande. Puiser d'abord dans les FND existants à partir de $HOME/git. »

**C'est une instruction de méthode, et elle vise un défaut.** Produire une fondation sans chercher ce qui existe déjà est exactement ce que `NON-021` conteste depuis la tâche 14 : le processus de travail ne prévoit aucune recherche préalable, et `ADR-007` a reproduit deux prescriptions publiées en 2011 sans le savoir.

La première étape est donc l'inventaire des fondations du corpus, avant toute recherche externe.

## Le programme de la fondation

| Réf | Ce qui est demandé |
|---|---|
| P1 | L'historique des RFC et des mécanismes de publication de spécifications |
| P2 | La différence entre normalisation, standardisation et spécification |
| P3 | Des exemples archétypaux et historiquement importants |
| P4 | L'évolution des formes de publication, leurs raisons d'être et leurs usages |
| P5 | Les types de spécifications et de documentation des requis |
| P6 | La distinction entre requis et spécification |

`MET-001` fixe le procédé d'une fondation en dix étapes. Il s'applique.

## La question que l'analyse doit trancher

« Où doit se trouver la source de vérité pour la description de l'implémentation et des contraintes, choix techniques ? »

Elle recoupe trois choses que le dépôt porte déjà et n'a pas réglées.

| Ce que le dépôt porte | Où |
|---|---|
| Une ressource peut être source ou générée selon le contexte | `NON-004` Q3 |
| Le code est une ressource, du côté de l'implémentation | `ADR-014` D1 |
| La spécification est strictement distincte de l'implémentation | `ADR-006` |
| Les types `SPC` et `RQF` ont **zéro instance** | `ANL-009` |

**Le dépôt a défini deux types qu'il n'a jamais employés**, et trois décisions qui en dépendent réclament une `SPC` sans qu'aucune n'existe.

## Ce que je vérifierai avant d'écrire

Les fondations existantes dans $HOME/git, comme l'humain le demande.

Ce que le dépôt dit déjà de `SPC` et de `RQF` : `RES-020`, `RES-021`, `RES-022`, `ADR-006`, `ADR-013`.

## Ce que je ne ferai pas

**Écrire la `SPC` des critères de conformité.** Elle est réclamée par `ISU-007` et `PLN-003`, et la tâche 31 demande une fondation et une analyse, non une spécification.
