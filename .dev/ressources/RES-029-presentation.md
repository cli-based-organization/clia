---
type: ressource
id: RES-029
title: "Présentation"
version: 0.1.0
status: draft
prefixe: PRS
emplacement: "publications/PRS-<SEQ>-<SLUG>/index.md"
cycle-de-vie: point-fixe
edition: ia
famille: implementation
champs-obligatoires: [type, id, title, status, date, auditoire, evenement]
relations-admissibles: [presentation, article, concept, fondation, publication]
sections: [Objet, Message principal, Déroulé, Sources, Relations]
skill: skl-007-ressource-d-implementation
adr: ADR-005
statut: actif
---

# RES-029 - Présentation

> Une présentation est un livrable composite : des sources, une chaîne de production, et un rendu. Elle est le premier type dont l'implémentation naturelle est un répertoire plutôt qu'un fichier.

## Objet

Définit le type `presentation`. Sa fonction est de rattacher au modèle un livrable dont la production est mécanique et le rendu binaire.

## Statut de ce document

Premier jet du 2026-08-10. Aucune instance dans ce dépôt. Le corpus en compte plusieurs, tous instructifs : `noumanity-formation/linux-and-quantum-computers` avec dix-huit sources LaTeX et dix PDF, `noumanity-quantum-roadmap` avec trente-deux sources et onze PDF, et `intentional-doers-governance` avec sa chaîne de rendu en Lua.

## Le composite, appliqué pour la première fois

Ce type est le meilleur cas d'application de `ADR-004`. Une présentation est un composite dont les atomes sont : le message, le déroulé, les sources de rendu, les assets, et le rendu produit.

Son entrée conventionnelle est `index.md`, conformément à `ADR-004` D5.

## La question que ce type pose au modèle

Le rendu produit mécaniquement doit-il être versionné aux côtés de ses sources ? `ANL-001` mesure que trois dépôts du corpus le font sans qu'aucune règle ne tranche. `NON-006` Q2 porte la question, et elle n'a pas de réponse.

Ce jet propose une position : la source et la recette sont des atomes de la présentation ; le rendu est une manifestation au sens FRBR, et il n'a pas à être versionné s'il est reproductible. Il doit l'être s'il a été diffusé, parce qu'alors il est ce que le destinataire a reçu.

## Cycle de vie et édition

`point-fixe`, nommage séquencé comme tous les types. Une présentation est donnée à une date, devant un auditoire.

## Relations

- `derive-de` [ADR-004](../adr/ADR-004-nature-composable-de-la-ressource.md)
- `reference` [RES-028](RES-028-article.md)

## Points ouverts

| Question | Objection |
|---|---|
| Un rendu produit mécaniquement est-il une ressource | `NON-006` Q2 |
| Les assets binaires entrent-ils dans le modèle | `NON-006` Q1 |
