---
type: issue
id: ISU-002
title: "Aucun générateur de ressources dérivées n'existe"
status: draft
maturity: conception
adoption: propose
activated: true
domain-status: "ouverte"
initiateur: agent
etat: ouverte
ouverture: 2026-08-11
---

# ISU-002 - Aucun générateur de ressources dérivées n'existe

> Trois familles de documents sont déclarées dérivées, et rien ne les dérive. Le mécanisme est spécifié en cinq étapes, dont deux existent et trois manquent.

## Journal

- 2026-08-11 : ouverte par l'agent, tâche 29, comme thématique T1 de la réévaluation de `PLN-005`.

## La problématique

Trois décisions rendent des types dérivés. Aucune n'a d'outil.

| Décision | Type devenu dérivé | Date |
|---|---|---|
| `ADR-016` D3 | Skill | 2026-08-11 |
| `ADR-017` D5 | ADR | 2026-08-11 |
| `NON-004` Q5 | Analyse | 2026-08-11 |

Un document dérivé sans générateur reste écrit à la main. Il continue de faire autorité en pratique, ce que la décision lui retire en droit.

Le dépôt compte sept skills, dix-sept ADR et huit analyses dans cet état.

## Ce qui la rend difficile

**Le mécanisme est spécifié, et il est hybride.** `NON-026` Q5 le décrit en cinq étapes, et distingue la génération déterministe par gabarit de la génération non déterministe par IA.

| Étape | État |
|---|---|
| 1. Analyse des ressources sources | **manque** |
| 2. Émission d'objections au besoin | **manque** |
| 3. Fichier de contenu intermédiaire en YAML | **manque** |
| 4. Validation du YAML par une référence cuelang | existe, les `*.input.cue` |
| 5. Fichier final par YAML et gabarit | existe, les trente gabarits |

Les deux étapes qui existent sont déterministes. Les trois qui manquent sont la part non déterministe, celle qui demande une interprétation.

**Deux des quatre sources nommées n'ont aucune instance.** `ADR-016` D3 nomme `RES`, `ADR`, `SPC` et `RQF`. Le dépôt compte zéro `SPC` et zéro `RQF`.

**Les règles propres des skills ne se dérivent de rien.** `skl-001` porte trois interdits typographiques, cinq interdits de registre et dix contrôles de validation. Aucun n'est déductible d'une définition.

**Le nom des deux mécanismes n'est pas trouvé.** `NON-026` Q5 le demande explicitement.

## Ce qui a été tenté

**Rien.** Aucune tentative d'implémentation n'a eu lieu.

Les `*.input.cue` ont été produits à la tâche 8 sans qu'aucun document ne dise à quoi ils servaient. `NON-026` Q5 leur a donné leur fonction rétroactivement : ils sont le contrat de l'étape 4.

## Pistes

**P1. Écrire la `SPC` avant l'outil.** `ADR-006` sépare strictement la spécification de l'implémentation. Ce serait la première instance d'un type défini et jamais éprouvé.

**P2. Implémenter l'étape 3 seule.** Le fichier intermédiaire YAML est le pivot : une fois produit, les étapes 4 et 5 fonctionnent déjà. Le générateur se réduirait à produire ce YAML.

**P3. Commencer par un seul type.** Le skill est le candidat le plus simple : sa structure est régulière, et les sept instances existantes servent de cas d'épreuve.

**P4. Ne rien générer, et retirer les trois décisions.** Le coût de l'écriture à la main est connu et supportable ; celui du générateur ne l'est pas.

## Ce qui la clôturerait

Un générateur qui produise un skill à partir de sa définition, et dont le résultat soit comparable à ce qui existe.

## Relations

- `objecte-a` [NON-030](../objections/NON-030-generateur-absent.md)
- `reference` [PLN-005](../plans/PLN-005-ajustement-au-savoir-relationnel.md)
- `reference` [RES-018](../ressources/RES-018-skill.md)
- `reference` [RES-019](../ressources/RES-019-adr.md)
