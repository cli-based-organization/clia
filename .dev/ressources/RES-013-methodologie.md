---
type: ressource
id: RES-013
title: "Méthodologie"
version: 0.1.0
status: draft
prefixe: MET
emplacement: ".dev/methodologies/MET-<SEQ>-<SLUG>.md"
cycle-de-vie: vivant
edition: ia
famille: conception
champs-obligatoires: [type, id, title, version, status, domaine]
relations-admissibles: [methodologie, skill, concept, fondation, ressource]
sections: [Objet, Quand l'employer, Le procédé, Ce qui peut échouer, Éprouvé sur, Relations]
skill: skl-003-ressource-de-conception
adr: ADR-011
statut: actif
---

# RES-013 - Méthodologie

> Une méthodologie décrit un savoir-faire métier réutilisable : comment conduire une entrevue, comment évaluer une adéquation, comment mener une revue. Elle porte sur le fond du travail, non sur la forme d'un livrable.

## Objet

Définit le type `methodologie`. Sa fonction est de conserver un procédé qui a fonctionné, afin qu'il soit rejouable.

## Ce qu'est une méthodologie

Elle porte cinq choses. Le domaine où elle s'applique. Les conditions de son emploi, et celles où elle ne convient pas. Le procédé, en étapes ordonnées. Ce qui peut échouer, avec les signes de l'échec. Et les cas sur lesquels elle a été éprouvée.

La dernière rubrique est ce qui distingue une méthodologie d'une idée de méthode.

## Ce qu'une méthodologie n'est pas

| Ce n'est pas | Différence |
|---|---|
| Un **skill** | Un skill encadre la production d'un type de ressource. Une méthodologie porte sur le fond d'un travail métier. La frontière est la question la plus disputée de ce type |
| Un **principe** | Le principe contraint, la méthodologie procède |
| Un **plan** | Le plan est propre à un travail donné. La méthodologie est réutilisable |

## Cycle de vie

`vivant`. Une méthodologie se raffine par l'usage, et chaque emploi enrichit sa rubrique d'épreuve.

## Régime d'édition

`ia`, l'humain commentant. Le procédé est rédigé par l'agent à partir de ce qui a été fait.

## Structure attendue d'une instance

```
# MET-<SEQ> - <Titre>

> Le savoir-faire, en une phrase.

## Objet
## Quand l'employer
## Le procédé
## Ce qui peut échouer
## Éprouvé sur
## Relations
```

## Relations

- `reference` [RES-001](RES-001-ressource.md)
- `reference` [RES-018](RES-018-skill.md)

## Points ouverts

| Question | Objection |
|---|---|
| Où passe la frontière entre méthodologie et skill | `NON-017` |
