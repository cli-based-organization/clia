---
type: ressource
id: RES-requis-non-fonctionnel
title: "Requis non fonctionnel"
version: 0.1.0
status: draft
prefixe: RQNF
emplacement: ".dev/requis/RQNF-<SEQ>-<SLUG>.md"
cycle-de-vie: vivant
edition: co-edition
famille: preparation
champs-obligatoires: [type, id, title, version, status, qualite, specification-parente]
relations-admissibles: [requis, specification, principe, code]
sections: [Objet, Le requis, Qualité visée, Comment le mesurer, Relations]
skill: skl-006-ressource-de-preparation
adr: ADR-regroupement-fonctionnel-des-ressources
statut: actif
---

# RES-022 - Requis non fonctionnel

> Un requis non fonctionnel énonce une qualité que le système doit présenter : performance, sécurité, portabilité, ergonomie. Il porte sur la manière d'être, non sur ce que le système fait.

## Objet

Définit le type `requis non fonctionnel`. Sa fonction est de rendre exigible une qualité qui, sans lui, reste une intention.

## Statut de ce document

Premier jet du 2026-08-10. Aucune instance dans ce dépôt.

## La mesurabilité, qui est la difficulté propre du type

Un requis non fonctionnel non mesurable est un souhait. La rubrique « Comment le mesurer » est obligatoire, et elle peut valoir « aucun moyen aujourd'hui », ce qui est un aveu utile.

`FND-002` en donne un exemple directement applicable à ce dépôt : l'ergonomie de saisie des identifiants n'a aucune littérature et aucun instrument de mesure, alors que c'est une exigence de premier rang du système. Un requis non fonctionnel serait le lieu de l'écrire.

## Ce qu'il porte

La qualité visée, nommée. Le requis, formulé de manière à être contesté. Le moyen de le mesurer. Et sa spécification parente, quand elle existe.

## Cycle de vie et édition

`vivant`, `co-edition`.

## Relations

- `reference` [RES-021](RES-021-requis-fonctionnel.md)
- `reference` [RES-012](RES-012-principe-de-conception.md)

## Points ouverts

| Question | Objection |
|---|---|
| Qu'est-ce qui distingue un requis non fonctionnel d'un principe de conception | `NON-017` |
| L'ergonomie doit-elle devenir un requis non fonctionnel écrit | `NON-014` Q3 |
