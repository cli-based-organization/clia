---
type: ressource
id: RES-cas-d-usage
title: "Cas d'usage"
version: 0.1.0
status: draft
prefixe: USE
emplacement: ".dev/usages/USE-<SEQ>-<SLUG>.md"
cycle-de-vie: vivant
edition: co-edition
famille: preparation
champs-obligatoires: [type, id, title, version, status, acteur-principal, niveau]
relations-admissibles: [usage, acteur, requis, specification, comportement]
sections: [Objet, Acteur et but, Déroulement nominal, Variantes et échecs, Relations]
skill: skl-006-ressource-de-preparation
adr: ADR-regroupement-fonctionnel-des-ressources
statut: actif
---

# RES-023 - Cas d'usage

> Un cas d'usage décrit ce qu'un acteur cherche à obtenir du système et comment il l'obtient. Il part du but de l'acteur, jamais des fonctions du système.

## Objet

Définit le type `usage`. Sa fonction est d'ancrer la conception dans un but réel plutôt que dans une liste de fonctions.

## Statut de ce document

Premier jet du 2026-08-10. Aucune instance dans ce dépôt. Le type était prévu par le `resource-types.yaml` archivé, avec un champ `acteur-principal` et un champ `niveau`, et trois relations typées le concernant : `utilise`, `satisfait`, `realise`.

## Ce qu'un cas d'usage porte

L'acteur et son but, au niveau du but utilisateur. Le déroulement nominal, en étapes. Les variantes et les échecs, qui sont la partie utile.

Un cas d'usage sans échec décrit une démonstration, pas un usage.

## La dépendance à un type absent

Le champ `acteur-principal` renvoie à un type Acteur qui n'existe pas et qui était prévu par les archives. Tant qu'il manque, le champ porte du texte libre. `NON-003` Q4 pose la question de savoir si l'acteur doit être un type ou une rubrique du contexte.

## Cycle de vie et édition

`vivant`, `co-edition`.

## Relations

- `reference` [RES-020](RES-020-specification.md)
- `reference` [RES-002](RES-002-contexte.md)

## Points ouverts

| Question | Objection |
|---|---|
| Faut-il un type Acteur | `NON-003` Q4 |
