---
type: issue
id: ISU-007
title: "Validation et portée des ressources"
status: draft
maturity: conception
adoption: propose
activated: true
domain-status: "ouverte"
initiateur: agent
etat: ouverte
ouverture: 2026-08-11
---

# ISU-007 - Validation et portée des ressources

> Deux axes de `ANL-009` n'ont aucune issue : la validation, réclamée par six sources depuis huit jours, et la portée, qui décide de ce qui se partage entre dépôts. Les quatre autres axes ouverts sont déjà couverts.

## Journal

- 2026-08-11 : ouverte par l'agent, tâche 30, pour les axes A7 et A9 de `ANL-009`.

## La problématique

`ANL-009` établit neuf axes. Quatre sont ouverts, et deux n'ont aucune issue.

**A7, la validation.** `skl-001` porte dix contrôles, `V1` à `V10`, tous exécutables à la main et aucun outillé. Six sources réclament des contrôles supplémentaires.

| Origine | Contrôle réclamé |
|---|---|
| `skl-001` | `V1` à `V10` |
| `MET-002` étape 6 | Dérivation du champ `effet` |
| `PDC-002` | Jeu de caractères et longueur des alias |
| `RES-035` | Cohérence des registres |
| `MET-004` | Croisement des relations `ISU` et `NON` |
| `MET-003` | Horodatages distincts d'un journal |

La chaîne de validation tourne dans un script jeté, réécrit à chaque session.

**A9, la portée.** `ADR-008` D7 laisse l'identifiant externe ouvert. `NON-006` porte la question du travail multi-dépôts depuis le 2026-08-09. `NON-026` Q4 demande les critères de conformité d'un dépôt `clia`, et `RES-001` porte depuis aujourd'hui la distinction entre ressource de système et ressource de dépôt, sans qu'aucune ressource ne soit classée.

**Ce que les deux axes partagent.** Ils décident de ce qui rend une ressource utilisable ailleurs : conforme, et transportable.

## Ce qui la rend difficile

**A7 est réclamé depuis huit jours et n'a jamais été priorisé.** Chaque tâche ajoute un contrôle à la liste et aucune ne l'implémente. Le coût individuel de chaque contrôle est faible ; c'est leur accumulation qui n'a pas de porteur.

**Quatre obligations de propagation dépendent de A7.** `ANL-009` C8 les mesure : alias, décisions remplacées, savoir vers ressources générées, registres saisis. Aucune n'a de contrôle, et toutes en demandent un.

**A9 dépend d'une décision non prise.** Les critères de conformité d'un dépôt sont un livrable de type `SPC`, qui n'a aucune instance. `PLN-003` chantier G1 les porte.

**Le classement des ressources n'a pas de critère.** `RES-001` distingue les deux catégories ; rien ne dit comment ranger une ressource existante dans l'une ou l'autre.

## Ce qui a été tenté

**Pour A7.** Un script de validation par schéma, réécrit à chaque session dans un répertoire temporaire. Il fonctionne, il a trouvé un bogue du CLI à la tâche 28, et il disparaît à chaque fois.

**Pour A9.** Rien. `NON-006` est ouverte depuis le 2026-08-09 sans traitement.

## Pistes

**P1. Implémenter `clia validate` avec les seuls contrôles de schéma.** Le script existe, le porter dans le CLI est mécanique. Les dix contrôles `V1` à `V10` viendraient après.

**P2. Écrire la `SPC` des critères de conformité d'abord.** Elle sert à A9 et donne un cahier des charges à A7 : un dépôt conforme est un dépôt qui passe les contrôles.

**P3. Traiter A7 par accumulation.** Chaque tâche qui réclame un contrôle l'implémente. Le coût se répartit et rien ne garantit la cohérence.

**P4. Classer les ressources par leur emplacement.** Ce qui vit dans `.dev/ressources` est de système, le reste est de dépôt. Simple, faux pour les harnais et les méthodologies.

## Ce qui la clôturerait

Pour A7 : une commande qui exécute les contrôles, quels qu'ils soient.

Pour A9 : les critères de conformité écrits, et un critère de classement.

## Relations

- `objecte-a` [NON-005](../objections/NON-005-validation-et-regles-non-tenues.md)
- `objecte-a` [NON-006](../objections/NON-006-portee-du-systeme.md)
- `derive-de` [ANL-009](../analyses/ANL-009-etat-des-lieux-de-la-notion-de-ressource.md)
- `reference` [ISU-002](ISU-002-aucun-generateur-de-ressources-derivees.md)
