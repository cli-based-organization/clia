---
type: ressource
id: RES-021
title: "Requis fonctionnel"
version: 0.1.0
status: draft
maturity: conception
adoption: propose
activated: true
domain-status: "actif"
prefixe: RQF
emplacement: ".dev/requis/RQF-<SEQ>-<SLUG>.md"
cycle-de-vie: vivant
edition: co-edition
famille: preparation
champs-obligatoires: [type, id, title, version, status, specification-parente]
relations-admissibles: [requis, specification, usage, comportement, code]
sections: [Objet, Le requis, Spécification parente, Critère de satisfaction, Relations]
skill: skl-006-ressource-de-preparation
adr: ADR-013
statut: actif
---

# RES-021 - Requis fonctionnel

> Un requis fonctionnel énonce ce que le système doit faire, dans un contexte donné, en traduisant une spécification en contrainte vérifiable.

## Objet

Définit le type `requis fonctionnel`. Sa fonction est de rendre une spécification exigible dans un contexte précis.

## La traçabilité obligatoire

Reprise du corpus : un requis ne peut exister sans une spécification parente. Le champ `specification-parente` est obligatoire pour cette raison.

Un requis orphelin est le signe soit d'une spécification manquante, soit d'une exigence inventée en cours de route. Les deux méritent une objection.

## Ce qu'un requis fonctionnel porte

Le requis, formulé de manière vérifiable et au singulier : un requis, une exigence. La spécification dont il découle. Le critère qui permet de dire s'il est satisfait.

## Ce qu'un requis fonctionnel n'est pas

| Ce n'est pas | Différence |
|---|---|
| Une **spécification** | Elle dit quoi, sans contexte ni technologie. Le requis dit quoi, ici, avec quoi |
| Un **requis non fonctionnel** | Celui-ci porte sur une qualité du système, non sur ce qu'il fait |
| Un **comportement attendu** | Celui-ci est un cas concret qui vérifie le requis |

## Cycle de vie et édition

`vivant`, `co-edition`.


## Cycle de vie métier : `domain-status`

`DCN-016` pose que `domain-status` porte le cycle de vie métier du type, et que chaque définition en déclare l'énumération.

**Aucune.** Ce type n'a pas de cycle de vie métier propre : son état est entièrement décrit par les trois champs universels `maturity`, `adoption` et `activated`.

## Relations

- `reference` [RES-020](RES-020-specification.md)
- `reference` [RES-022](RES-022-requis-non-fonctionnel.md)

## Points ouverts

| Question | Objection |
|---|---|
| Les requis fonctionnels et non fonctionnels partagent un répertoire, faut-il les séparer | `NON-017` |
