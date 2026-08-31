---
type: ressource
id: RES-023
title: "Cas d'usage"
version: 0.1.0
status: draft
maturity: conception
adoption: propose
activated: true
domain-status: "actif"
prefixe: USE
emplacement: ".dev/usages/USE-<SEQ>-<SLUG>.md"
cycle-de-vie: vivant
edition: co-edition
famille: preparation
champs-obligatoires: [type, id, title, version, status, acteur-principal, niveau]
relations-admissibles: [usage, acteur, requis, specification, comportement]
sections: [Objet, Acteur et but, Déroulement nominal, Variantes et échecs, Relations]
skill: skl-006-ressource-de-preparation
adr: ADR-013
statut: actif
---

# RES-023 - Cas d'usage

> Un cas d'usage décrit ce qu'un acteur cherche à obtenir du système et comment il l'obtient. Il part du but de l'acteur, jamais des fonctions du système.

## Objet

Définit le type `usage`. Sa fonction est d'ancrer la conception dans un but réel plutôt que dans une liste de fonctions.

## Ce qu'un cas d'usage porte

L'acteur et son but, au niveau du but utilisateur. Le déroulement nominal, en étapes. Les variantes et les échecs, qui sont la partie utile.

Un cas d'usage sans échec décrit une démonstration, pas un usage.

## La dépendance à un type absent

Le champ `acteur-principal` renvoie à un type Acteur qui n'existe pas et qui était prévu par les archives. Tant qu'il manque, le champ porte du texte libre. `NON-003` Q4 pose la question de savoir si l'acteur doit être un type ou une rubrique du contexte.

## Cycle de vie et édition

`vivant`, `co-edition`.


## Cycle de vie métier : `domain-status`

`DCN-016` pose que `domain-status` porte le cycle de vie métier du type, et que chaque définition en déclare l'énumération.

**Aucune.** Ce type n'a pas de cycle de vie métier propre : son état est entièrement décrit par les trois champs universels `maturity`, `adoption` et `activated`.

## Relations

- `reference` [RES-020](RES-020-specification.md)
- `reference` [RES-002](RES-002-contexte.md)

## Points ouverts

| Question | Objection |
|---|---|
| Faut-il un type Acteur | `NON-003` Q4 |
