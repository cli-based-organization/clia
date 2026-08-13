---
type: plan
id: PLN-013
title: "Borner l'ouverture des objections"
status: draft
statut-plan: execute
date: 2026-08-13
initiateur: agent
sert: []  # règle de conduite de l'agent : méthode
porte-sur: [MET-003, PDC-005, RES-004]
---

# PLN-013 - Borner l'ouverture des objections

> Trente-neuf objections en cinq jours, ouvertes par l'agent sans qu'aucune règle ne le prescrive. `PDC-005` corrige le principe ; il manque le critère qui départage ce qui se décide en avançant de ce qui doit s'arrêter.

## Statut

`execute`. Les deux chantiers ont été exécutés par la tâche 9 de `SES-002`, le 2026-08-13.

**Le critère a trouvé son lieu dans `MET-005`**, créée par la même tâche, plutôt que dans `MET-003` : aucune méthodologie ne guidait l'exécution d'un plan, et c'est là que le filtre s'applique. `MET-003` reçoit la rubrique du chantier B.

## Intention

Rendre les objections rares, donc lues.

**Cible mesurable.** Sur les dix tâches suivantes, le nombre d'objections ouvertes par l'agent est inférieur au nombre de tâches.

## Chantiers

### Chantier A - Écrire le critère de départage

| Élément | Valeur |
|---|---|
| **Livrable** | Une méthodologie, ou une section de `MET-003` |
| **Critère de réussite** | Le critère range les 39 objections existantes en deux tas sans cas ambigu |
| **Limite de temps** | 1 heure |
| **Dépend de** | rien |

**Le critère proposé**, tiré de `ANL-011`.

| L'agent décide et avance | L'agent s'arrête |
|---|---|
| Décision réversible | Geste irréversible ou coûteux à défaire |
| Touche du code ou un document d'agent | Touche un document en régime humain |
| Une lecture raisonnable existe | Deux lectures mènent à des travaux incompatibles |
| Se tromper coûte une correction | Se tromper coûte une migration |

**Le contrôle est un test rétrospectif.** Si le critère ne range pas les cas passés, il ne rangera pas les cas futurs.

### Chantier B - Le journal accueille ce qui n'est plus une objection

| Élément | Valeur |
|---|---|
| **Livrable** | `MET-003`, rubrique du journal d'analyse |
| **Critère de réussite** | Une décision prise en avançant a un endroit déclaré où être consignée |
| **Limite de temps** | 30 minutes |
| **Dépend de** | A |

**Ce que le chantier évite.** Que « moins d'objections » devienne « moins de traces ». Une décision prise en avançant reste une décision documentée : elle change de lieu, pas de statut.

## Objections de l'agent

**C'est l'agent qui écrit la règle qui limite ses propres objections.** Le conflit d'intérêt est le même que celui relevé dans `PLN-003` : l'agent y proposait d'élargir ce qu'il peut faire.

**Le critère est construit après coup sur trente-neuf cas que j'ai produits.** Je suis mal placé pour juger lesquels méritaient une objection.

## Relations

- `derive-de` [ANL-011](../analyses/ANL-011-focus-et-accumulation-des-items-ouverts.md)
- `reference` [PDC-005](../principes/PDC-005-mode-ia-best-effort-documente.md)
