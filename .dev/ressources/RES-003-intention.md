---
type: ressource
id: RES-003
title: "Intention"
version: 0.1.0
status: draft
prefixe: INT
emplacement: ".dev/intentions/INT-<SEQ>-<SLUG>.md, sauf INT-001 qui vit à INTENTION.md"
cycle-de-vie: vivant
edition: humain
famille: fondamentale
champs-obligatoires: [type, id, title, version, status, portee, critere-de-satisfaction, critere-de-trahison]
relations-admissibles: [intention, contexte, concept]
sections: [Le but, La raison, Critère de satisfaction, Critère de trahison, Ce que cette intention exclut, Relations]
skill: skl-002-ressource-fondamentale
adr: ADR-009
statut: actif
---

# RES-003 - Intention

> Une intention énonce un but poursuivi, et les deux critères qui permettent de dire s'il est atteint ou s'il est trahi. Sans ces critères, une intention est un souhait et l'agent ne peut pas objecter en son nom.

## Objet

Ce document définit le type `intention`, premier des trois ingrédients de toute demande selon `CLAUDE.md`, et référence de l'objection : « SI IL Y A CONFLIT entre l'intention d'une tâche et l'intention ultime, émettre des objections ».

## Ce qu'est une intention

Une intention est une ressource vivante, en édition humaine, qui énonce un but et le rend **opposable**.

Elle porte quatre choses.

| Elle porte | Rôle |
|---|---|
| **Le but** | Ce qui est poursuivi, en une phrase qui tient debout seule |
| **La raison** | Pourquoi ce but plutôt qu'un autre. Ce qui a rendu le but nécessaire |
| **Le critère de satisfaction** | À quoi on reconnaîtra que le but est atteint |
| **Le critère de trahison** | Ce qui, s'il arrivait, signifierait que l'intention est trahie, même si le travail avance |

Les deux derniers champs sont obligatoires. Le critère de satisfaction permet de clore. Le critère de trahison permet d'objecter, ce qui est la fonction que `CLAUDE.md` assigne à l'intention.

Un critère de trahison bien écrit est spécifique et vérifiable. Exemple, pour l'intention de `clia` : « le système coûte plus de temps qu'il n'en fait gagner », qui est mesurable par le rapport entre les ressources de méthode produites et le travail métier accompli, rapport que `ANL-001` a précisément mesuré comme se dégradant.

## Portées

Deux portées seulement, déclarées par le champ `portee`.

| Portée | Nombre par dépôt | Emplacement | Rôle |
|---|---|---|---|
| `ultime` | Exactement une | `INTENTION.md` à la racine | La raison d'être du dépôt. Référence de toute objection |
| `derivee` | Autant que nécessaire | `.dev/intentions/INT-<SEQ>-<SLUG>.md` | Un but subordonné, qui doit déclarer `derive-de` vers l'intention ultime |

Toute intention dérivée doit pouvoir être rattachée à l'intention ultime par une chaîne de `derive-de`. Une intention dérivée qui ne s'y rattache pas est le signe soit d'un travail hors périmètre, soit d'une intention ultime incomplète. Les deux cas méritent une objection.

## Le cas de INTENTION.md

`INTENTION.md` occupe une position particulière et disputée : c'est le seul fichier qui soit à la fois une ressource par sa nature et un fichier à nom fixe par sa fonction.

**`INTENTION.md` est l'instance `INT-001`.** Son emplacement à la racine est une propriété déclarée du type, non une exception tacite.

La conséquence est que `INTENTION.md` doit porter un frontmatter, ce qu'aucun `INTENTION.md` du corpus ne fait aujourd'hui. C'est un changement visible, à arbitrer : voir `NON-003`.

Une position concurrente est tenable : `INTENTION.md` reste hors du système de types, et les intentions typées sont toutes dérivées. Elle a l'avantage de ne rien changer et l'inconvénient de laisser sans modèle le document le plus important du dépôt.

## Régime d'édition

`humain`, strictement. L'agent lit, cite, commente, objecte, et ne modifie jamais.

Cette règle est née d'un dégât documenté : le premier log du dépôt `commission-scolaire-de-la-capitale` consiste à réparer un `INTENTION.md` écrasé par l'agent avec du contenu générique.

Le régime `humain` n'est aujourd'hui protégé par rien d'autre que la règle elle-même. Un fichier en édition humaine exclusive qui a été écrasé une fois et copié à l'identique dans trois dépôts n'est pas protégé : voir `NON-005`.

## Cycle de vie et changement de cap

`vivant`, versionné en semver, avec une règle propre à ce type.

Un changement **majeur** de l'intention ultime est un changement de cap. Toute révision majeure de `INT-001` exige une trace écrite de la décision : un ADR, ou à défaut une section de journal dans l'intention elle-même.

Cette règle répond au défaut D3 de `ANL-001` : le corpus compte quatre-vingt-neuf ADR et aucun sur les quatre ruptures de cap majeures des douze derniers mois. Un lecteur ne peut reconstituer ni pourquoi `tda` a été abandonné pour `clia`, ni pourquoi la validation par schéma a été perdue.

## Les trois formes essayées

Le corpus a essayé trois formes d'intention. La deuxième est retenue, la troisième reste ouverte.

| Forme | Exemple | Sort |
|---|---|---|
| Prose libre, une phrase à une page | Majoritaire, dont `clia` | Insuffisante : ne porte aucun critère |
| Sections nommées | `ticket-driven-ai`, cinq sections ; `intentional-doers-governance`, qui numérote `INT-001` | **Retenue**, augmentée des deux critères |
| Machine-lisible | `nou-scripts-ia-support` et `poc-formulaire-offline-first`, avec `apiVersion` et `kind: Intention` | Abandonnée sans décision écrite. Question rouverte par `NON-006` |

La troisième forme mérite attention. Elle répond directement au besoin que `CLAUDE.md` exprime, à savoir que l'outil puisse lire l'intention pour objecter. Elle a été abandonnée en avril 2026 sans trace, ce qui est exactement le défaut que ce type entend corriger.

## Structure attendue d'une instance

```
# INT-<SEQ> - <Titre>

> Le but, en une phrase qui tient debout seule.

## Le but
## La raison
## Critère de satisfaction
## Critère de trahison
## Ce que cette intention exclut
## Relations
```

La rubrique « Ce que cette intention exclut » est facultative et utile : les deux dépôts qui portent l'intention de `clia` comme intention métier n'auraient pas pu le faire si cette intention avait déclaré ce qu'elle exclut.

## Relations

- `reference` [RES-001](RES-001-ressource.md)
- `reference` [RES-002](RES-002-contexte.md)

## Points ouverts

| Question | Objection |
|---|---|
| `INTENTION.md` est-il l'instance `INT-001` ou reste-t-il hors du modèle | `NON-003` |
| Faut-il rouvrir la forme machine-lisible de l'intention | `NON-006` |
| Comment protéger effectivement un fichier en édition humaine exclusive | `NON-005` |
| Les critères de satisfaction et de trahison sont-ils exigibles, ou dissuasifs | `NON-002` |
