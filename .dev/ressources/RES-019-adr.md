---
type: ressource
id: RES-019
title: "Décision d'architecture"
version: 0.1.0
status: draft
prefixe: ADR
emplacement: ".dev/adr/ADR-<SEQ>-<SLUG>.md"
cycle-de-vie: vivant
edition: co-edition
famille: preparation
champs-obligatoires: [type, id, title, version, status, statut-decision, date, decideurs]
relations-admissibles: [adr, decision, ressource, objection, analyse, fondation]
sections: [Statut, Contexte, Décision en une phrase, Décisions détaillées, Conséquences, Objections ouvertes, Relations]
skill: skl-006-ressource-de-preparation
adr: ADR-005
statut: actif
---

# RES-019 - Décision d'architecture

> Une décision d'architecture acte un choix de conception, avec ses motifs, les alternatives écartées et les conditions de sa révision. Elle dit pourquoi, jamais ce qu'est ni comment on produit.

## Objet

Définit le type `adr`. C'est le deuxième terme du triplet qui accompagne un type de ressource.

## Statut de ce document

Premier jet du 2026-08-10. Cinq instances dans ce dépôt, quatre-vingt-neuf dans le corpus. C'est le type le plus employé du corpus après les traces et les tickets, et `ANL-001` établit au défaut D3 son mode de défaillance : les quatre-vingt-neuf ADR du corpus portent sur des questions internes de forme, et aucun sur les quatre ruptures de cap réelles.

## Ce qu'un ADR porte

Six choses. Un statut de décision, distinct du statut de maturité du document. Le contexte, avec les faits qui contraignent. La décision en une phrase. Les décisions détaillées, chacune avec son motif et ses alternatives écartées. Les conséquences, y compris ce que la décision coûte et ne règle pas. Et les objections ouvertes.

**La porte de sortie est la rubrique qui manque le plus souvent.** Elle dit à quelles conditions la décision serait révisée. Sans elle, une décision devient un dogme, et le corpus montre ce qui arrive alors : on ne la révise pas, on l'abandonne en silence.

## Ce qu'un ADR n'est pas

| Ce n'est pas | Différence |
|---|---|
| Une **décision** au sens `DCN` | Un ADR décide, une DCN enregistre une décision prise ailleurs |
| Une **définition** | La définition dit ce qu'est le type. `ADR-008` du corpus documente le dégât inverse : six ADR sur sept y servaient de définition, et deux ont dû être amendés le jour de leur création |
| Un **plan** | Le plan propose une intervention, l'ADR acte un choix |

## Deux statuts distincts

Le champ `status` porte la maturité du document, `draft` ou `stable`. Le champ `statut-decision` porte l'état de la décision, `propose`, `accepte`, `remplacee` ou `abandonnee`.

Les cinq ADR de ce dépôt sont tous au statut `propose`. Un ADR qui se déclarerait accepté sans l'être aggraverait le défaut D3.

## Cycle de vie et édition

`vivant`, `co-edition`. Une décision datée ne se réécrit pas, mais son statut évolue et ses conséquences se constatent.

## Relations

- `reference` [RES-001](RES-001-ressource.md)
- `reference` [RES-009](RES-009-decision.md)

## Points ouverts

| Question | Objection |
|---|---|
| L'ADR appartient-il à la famille préparation ou à une autre | `NON-017` |
| Manque-t-il un type pour la décision de cap, distincte de l'architecture | `NON-003` Q3 |
