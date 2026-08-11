---
type: ressource
id: RES-024
title: "Comportement attendu"
version: 0.1.0
status: draft
prefixe: CMP
emplacement: ".dev/comportements/CMP-<SEQ>-<SLUG>.md"
cycle-de-vie: vivant
edition: co-edition
famille: preparation
champs-obligatoires: [type, id, title, version, status, verifie]
relations-admissibles: [comportement, requis, specification, usage, code, bug]
sections: [Objet, Situation, Comportement attendu, Comment le vérifier, Relations]
skill: skl-006-ressource-de-preparation
adr: ADR-013
statut: actif
---

# RES-024 - Comportement attendu

> Un comportement attendu décrit, pour une situation donnée, ce que le système doit faire. C'est un cas de test exprimé en langage naturel, avant d'être un test exécutable.

## Objet

Définit le type `comportement`. Sa fonction est de rendre vérifiable une exigence, en la ramenant à un cas concret.

## Ce qu'il porte

La situation, décrite de manière reproductible. Le comportement attendu, formulé de manière binaire : il se produit ou non. Le moyen de le vérifier. Et ce qu'il vérifie, par le champ `verifie` qui renvoie à un requis ou à une spécification.

## La question que le type pose immédiatement

Les assertions de la suite de tests existent et fonctionnent. Un comportement attendu ne double pas un test : il n'est produit que lorsqu'il porte une exigence que le test seul ne dit pas, son motif et son rattachement à un requis.

C'est l'application du même critère que celui du fait : on ne consigne que ce qui est réutilisé ou contesté.

## Cycle de vie et édition

`vivant`, `co-edition`.

## Relations

- `reference` [RES-021](RES-021-requis-fonctionnel.md)
- `reference` [RES-026](RES-026-code.md)

## Points ouverts

| Question | Objection |
|---|---|
| Un test exécutable rend-il la ressource inutile | `NON-002` Q2 |
