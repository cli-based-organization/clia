---
type: ressource
id: RES-025
title: "Plan de travail"
version: 0.1.0
status: draft
maturity: conception
adoption: propose
activated: true
domain-status: "actif"
prefixe: PLN
emplacement: ".dev/plans/PLN-<SEQ>-<SLUG>.md"
cycle-de-vie: travail
edition: ia
famille: preparation
champs-obligatoires: [type, id, title, status, statut-plan, date, initiateur]
relations-admissibles: [plan, ressource, objection, adr, intention]
sections: [Statut, Intention, Chantiers, Livrables attendus, Objections de l'agent, Relations]
skill: skl-006-ressource-de-preparation
adr: ADR-013
statut: actif
---

# RES-025 - Plan de travail

> Un plan propose une intervention en réponse à un problème, avant de l'exécuter. Il porte ses propres objections, et il n'est pas une exécution.

## Objet

Définit le type `plan`. Sa fonction est de donner à l'humain un point de contrôle avant que la production commence.

## Ce qu'un plan porte

Cinq choses. Son statut dans le cycle. L'intention, c'est-à-dire le problème qu'il traite. Les chantiers, avec leurs étapes et leurs prérequis. Les livrables attendus. Et les objections de l'agent sur son propre plan.

La dernière rubrique est obligatoire et elle est ce qui distingue un plan d'une liste de tâches : l'agent qui propose doit dire ce qui, dans sa proposition, lui paraît discutable.

## Le point d'arrêt

Un plan peut déclarer des points d'arrêt, qui suspendent l'exécution après un livrable donné le temps que l'humain décide de la suite. `PLN-001` en pose deux.

Le mécanisme est hérité du `CONSTITUTION.md` archivé, où il s'appelait breakpoint et s'articulait à une règle absolue de non-exécution sous objection. `ADR-002` D6 a remplacé cette règle par la déclaration d'effet des objections, et note que la rupture perd le point d'arrêt déclaré à l'avance. Le conserver au niveau du plan est ce qui le rattrape.

## Un écart de pratique à signaler

`ADR-002` D8 constate que les sept premières tâches de la session du 2026-08-09 ont été exécutées **sans plan préalable**, alors que le processus antérieur l'exigeait. L'écart est porté par `NON-010` Q4 et non tranché.

## Cycle de vie et édition

`travail`, journalisé en tête plutôt que versionné. `ia` : le plan est produit par l'agent, l'humain y répond par objection ou par autorisation.


## Cycle de vie métier : `domain-status`

`DCN-016` pose que `domain-status` porte le cycle de vie métier du type, et que chaque définition en déclare l'énumération.

| Valeur | Reprise de |
|---|---|
| `propose` | `statut-plan` |
| `approuve` | `statut-plan` |
| `execute` | `statut-plan` |
| `abandonne` | `statut-plan` |

Ces valeurs sont **reprises du champ `statut-plan`**, que `DCN-016` supprime. Elles ne sont pas nouvelles : le type les portait déjà.

## Relations

- `reference` [RES-001](RES-001-ressource.md)
- `reference` [RES-004](RES-004-objection.md)
- `reference` [ADR-002](../adr/ADR-002-adoption-du-processus-de-travail.md)

## Points ouverts

| Question | Objection |
|---|---|
| Un plan doit-il précéder toute exécution | `NON-010` Q4 |
