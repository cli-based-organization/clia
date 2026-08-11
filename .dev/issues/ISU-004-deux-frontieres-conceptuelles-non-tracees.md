---
type: issue
id: ISU-004
title: "Deux frontières conceptuelles ne sont pas tracées"
status: draft
initiateur: agent
etat: ouverte
ouverture: 2026-08-11
---

# ISU-004 - Deux frontières conceptuelles ne sont pas tracées

> Information contre savoir, et concept contre relation. Les deux sont demandées par les réponses à `NON-004`, et aucune ne peut être tracée sans l'ontologie qui les porterait.

## Journal

- 2026-08-11 : ouverte par l'agent, tâche 29, comme thématique T3 de la réévaluation de `PLN-005`.

## La problématique

Deux frontières sont demandées, et elles se tiennent l'une l'autre.

**Information contre savoir.** Réponse Q3 : « il faudrait bien définir la frontière entre information et savoir. le savoir est une forme particulière de relation entre un acteur et une information ». La définition est donnée ; sa portée sur le modèle ne l'est pas.

**Concept contre relation.** Réponse Q2 : « il faudrait au préalable définir la frontière entre concept et relation. La relation est probablement un type de concept avec un ensemble de propriétés particulières ?... » Le point d'interrogation est dans la réponse.

Trois chantiers de `PLN-005` en dépendent : B3, B4 et F.

## Ce qui la rend difficile

**L'ordre est circulaire.** Les frontières doivent vivre dans `ONT-001`, et `ONT-001` doit les employer pour se définir. Les tracer ailleurs produirait la source parallèle que `NON-004` reprochait déjà à `RES-001`.

**La seconde frontière commande un type.** Si la relation est un concept aux propriétés particulières, elle n'a pas besoin de type propre. Si elle n'en est pas un, il en faut un. Le dépôt emploie neuf relations sans qu'aucune ne soit définie.

**La première frontière touche à ce qu'est une ressource.** Si le savoir est une relation entre un acteur et une information, une ressource ne porte que de l'information. Elle ne devient savoir que rapportée à un acteur, ce qu'aucun mécanisme ne représente.

**Le type technote en dépend.** `PLN-005` chantier F le prévoit avec trois déclinaisons possibles selon l'acteur. La déclinaison par acteur est exactement ce que la frontière information contre savoir décrit.

## Ce qui a été tenté

**Le vocabulaire de relations vit dans `RES-001`** depuis le 2026-08-09, déclaré provisoire. Neuf relations, employées par trente-cinq définitions.

`NON-004` Q2 en faisait une contradiction interne du modèle : une source parallèle, exactement le défaut que le modèle prétend éviter.

## Pistes

**P1. Écrire `ONT-001` d'abord, avec les frontières comme entrées.** L'ordre circulaire se rompt en acceptant que la première version soit imparfaite.

**P2. Tracer les frontières dans une `FND`.** Les deux questions ont une littérature : la distinction donnée-information-connaissance en sciences de l'information, et la théorie des relations en ontologie formelle.

**P3. Ne tracer que la seconde.** Concept contre relation est une question de modèle, tranchable sans littérature. Information contre savoir est une question de fond.

**P4. Reporter les deux, et faire vivre le vocabulaire dans `RES-001` en le déclarant définitif.** Le moins coûteux, et il maintient la contradiction.

## Ce qui la clôturerait

Une décision sur la seconde frontière, qui commande l'existence d'un type.

La première peut rester ouverte plus longtemps : elle n'empêche aucun chantier, elle les prive seulement d'un fondement.

## Relations

- `objecte-a` [NON-032](../objections/NON-032-frontieres-non-tracees.md)
- `reference` [PLN-005](../plans/PLN-005-ajustement-au-savoir-relationnel.md)
- `reference` [RES-006](../ressources/RES-006-ontologie.md)
