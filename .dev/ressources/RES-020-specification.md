---
type: ressource
id: RES-specification
title: "Spécification"
version: 0.1.0
status: draft
prefixe: SPC
emplacement: ".dev/specs/SPC-<SEQ>-<SLUG>.md"
cycle-de-vie: vivant
edition: co-edition
famille: preparation
champs-obligatoires: [type, id, title, version, status]
relations-admissibles: [specification, requis, usage, comportement, adr]
sections: [Objet, Comportement observable, Interfaces, Ce qui est hors périmètre, Relations]
skill: skl-006-ressource-de-preparation
adr: ADR-regroupement-fonctionnel-des-ressources
statut: actif
---

# RES-020 - Spécification

> Une spécification définit le comportement observable d'un objet d'ingénierie, sans mentionner de technologie. Elle répond à la question « quoi », et jamais à « avec quoi ».

## Objet

Définit le type `specification`. Sa fonction est de fixer ce qu'un objet doit faire avant de décider comment il le fera.

## Statut de ce document

Premier jet du 2026-08-10. Aucune instance dans ce dépôt, douze dans le corpus. Le type est éprouvé dans `ticket-driven-ai`, qui en fait un livrable outillé avec sa garde propre.

## La garde d'agnosticisme

C'est la propriété définitionnelle du type, et elle vient du corpus : une spécification doit rester agnostique au stack, aucune technologie ni détail d'infrastructure. Le skill de production doit traquer les glissements vers les détails techniques.

Le motif est pratique : une spécification qui nomme une technologie devient fausse quand la technologie change, alors que le comportement attendu, lui, ne change pas.

## Ce qu'une spécification porte

Le comportement observable, formulé de manière vérifiable. Les interfaces, en termes d'entrées et de sorties. Et ce qui est explicitement hors périmètre.

## Ce qu'une spécification n'est pas

| Ce n'est pas | Différence |
|---|---|
| Un **requis** | Le requis traduit la spécification en contraintes d'implémentation contextuelles. Il répond à « comment, ici, avec quoi » |
| Un **cas d'usage** | Le cas d'usage part de l'acteur et de son but. La spécification part de l'objet et de son comportement |
| Un **comportement attendu** | Le comportement attendu est un cas de test. La spécification est la règle dont il vérifie l'application |

## Cycle de vie et édition

`vivant`, `co-edition`.

## Relations

- `reference` [RES-001](RES-001-ressource.md)
- `reference` [RES-021](RES-021-requis-fonctionnel.md)

## Points ouverts

| Question | Objection |
|---|---|
| Ce dépôt a-t-il besoin de ce type avant d'avoir un objet à spécifier | `NON-002` Q2 |
