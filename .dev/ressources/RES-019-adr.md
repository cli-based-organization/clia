---
type: ressource
id: RES-019
title: "Décision d'architecture"
version: 0.1.0
status: draft
maturity: conception
adoption: propose
activated: true
domain-status: "actif"
prefixe: ADR
emplacement: ".dev/adr/ADR-<SEQ>-<SLUG>.md"
cycle-de-vie: vivant
edition: ia
famille: preparation
champs-obligatoires: [type, id, title, version, status, statut-decision, date, decideurs]
relations-admissibles: [adr, decision, ressource, objection, analyse, fondation, fragment]
sections: [Statut, Contexte, Décision en une phrase, Décisions détaillées, Conséquences, Objections ouvertes, Relations]
skill: skl-006-ressource-de-preparation
adr: ADR-013
statut: actif
---

# RES-019 - Décision d'architecture

> Une décision d'architecture est la **justification raisonnée** d'un choix de conception, générée à partir d'une ou plusieurs décisions et d'un ou plusieurs fragments. Elle dit pourquoi, jamais ce qu'est ni comment on produit. Elle ne décide pas.

## Objet

Définit le type `adr`. Sa fonction est de rendre lisible le raisonnement qui relie une décision à ses conséquences.

## Ce qu'un ADR n'est plus

`NON-003` Q3 : « les décisions relèvent de DCN et non pas de ADR. L'ADR est une justification raisonnée générée à partir d'un ou plusieurs DCN et un ou plusieurs FRG. »

L'acte de décider appartient à `DCN`, en édition humaine par `CONSTITUTION.md` C1. L'ADR **dérive** de cet acte ; il ne le porte pas.

| Avant le 2026-08-11 | Depuis |
|---|---|
| L'ADR décide, la `DCN` enregistre une décision prise ailleurs | La `DCN` porte l'acte, l'ADR en dérive la justification |
| `co-edition` | `ia`, un document généré n'est pas co-édité |
| Source : le raisonnement de l'agent | Sources : une ou plusieurs `DCN`, un ou plusieurs `FRG` |

C'est le même mouvement que `ADR-016` D3 applique aux skills : ce qui se dérive n'a pas d'autorité propre.

**Non outillé.** Aucun générateur ne dérive un ADR de ses sources, et les seize ADR du dépôt ont été écrits à la main comme des actes de décision. `NON-026` le porte.

## Ce qu'un ADR porte

Six choses. Un statut de décision, distinct du statut de maturité du document. Le contexte, avec les faits qui contraignent. La décision en une phrase. Les décisions détaillées, chacune avec son motif et ses alternatives écartées. Les conséquences, y compris ce que la décision coûte et ne règle pas. Et les objections ouvertes.

**La porte de sortie est la rubrique qui manque le plus souvent.** Elle dit à quelles conditions la décision serait révisée. Sans elle, une décision devient un dogme, et le corpus montre ce qui arrive alors : on ne la révise pas, on l'abandonne en silence.

## Ce qu'un ADR n'est pas

| Ce n'est pas | Différence |
|---|---|
| Une **décision** au sens `DCN` | La `DCN` porte l'acte, l'ADR en dérive la justification. Un ADR sans `DCN` source est un raisonnement sans décision |
| Une **définition** | La définition dit ce qu'est le type. `ADR-008` du corpus documente le dégât inverse : six ADR sur sept y servaient de définition, et deux ont dû être amendés le jour de leur création |
| Un **plan** | Le plan propose une intervention, l'ADR justifie un choix déjà acté par une `DCN` |

## Deux statuts distincts

Le champ `status` porte la maturité du document, `draft` ou `stable`. Le champ `statut-decision` porte l'état de la décision, `propose`, `accepte`, `remplacee` ou `abandonnee`.

Les cinq ADR de ce dépôt sont tous au statut `propose`. Un ADR qui se déclarerait accepté sans l'être aggraverait le défaut D3.

## Cycle de vie et édition

`vivant`, `ia`. Un ADR est généré à partir de ses sources ; il se régénère quand elles changent.

L'humain lit, commente et objecte. Il ne co-édite pas un document dérivé : il corrige la source.


## Cycle de vie métier : `domain-status`

`DCN-016` pose que `domain-status` porte le cycle de vie métier du type, et que chaque définition en déclare l'énumération.

| Valeur | Reprise de |
|---|---|
| `propose` | `statut-decision` |
| `accepte` | `statut-decision` |
| `remplacee` | `statut-decision` |
| `abandonnee` | `statut-decision` |

Ces valeurs sont **reprises du champ `statut-decision`**, que `DCN-016` supprime. Elles ne sont pas nouvelles : le type les portait déjà.

## Relations

- `reference` [RES-001](RES-001-ressource.md)
- `reference` [RES-009](RES-009-decision.md)

## Points ouverts

| Question | Objection |
|---|---|
| L'ADR appartient-il à la famille préparation ou à une autre | `NON-017` |
| Que deviennent les seize ADR écrits comme des actes de décision | `NON-026` |
| Le générateur qui dériverait un ADR de ses sources n'existe pas | `NON-026` |
