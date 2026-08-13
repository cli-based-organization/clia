---
type: plan
id: PLN-006
title: "Instrumentation des ressources : ce qui est implémentable"
status: draft
statut-plan: execute
date: 2026-08-11
initiateur: agent
sert: [FNC-001]  # a livré clia res
porte-sur: [NON-026, NON-025, NON-030, NON-027, NON-033, NON-014, NON-011]
---

# PLN-006 - Instrumentation des ressources : ce qui est implémentable

> Cinq interventions, toutes exécutées le 2026-08-11. Ce plan ne porte que ce qui satisfait `PDC-003`. Ce qui ne le satisfait pas vit dans `ISU-007` et dans les cinq issues de la tâche 29.

## Statut

`execute`, le 2026-08-11, tâche 30.

Les cinq interventions sont faites. Le plan est produit et exécuté dans la même tâche : chacune porte sur un document existant, sans dépendance et sans outil.

**Limite de temps.** Non déclarée. `PDC-003` V-S3 l'exige au régime extrême SMART. Ce plan est le sixième du dépôt à échouer à ce contrôle, et le constat est porté par `ISU-007`.

## Intention

Corriger ce que l'état des lieux de `ANL-009` a établi comme corrigeable sans arbitrage ni outil.

Cible mesurable : aucune objection ne porte un état faux, et aucun doublon n'est laissé sans renvoi croisé.

## Chantiers

### Chantier I1 - Corriger l'état de NON-026

**Livrable.** `NON-026`.

`ANL-009` C9 mesure : cinq questions, cinq réponses, et l'objection restait `ouverte`. Elle a été traitée à la tâche 24 par `ANL-006` et `PLN-003`.

**Critère de réussite.** `etat: repondue` et `effet: informatif`, et le journal porte la date du traitement.

**Fait.**

### Chantier I2 - Croiser NON-025 et NON-030

**Livrable.** Les deux objections.

Les deux posent la même question : les skills sont dérivables et rien ne les dérive. `NON-030` l'élargit aux trois familles.

**Critère de réussite.** Chaque objection cite l'autre dans son journal et dans ses relations, en disant laquelle reprend laquelle.

**Fait.** `NON-025` reste ouverte pour ses Q3 et Q4, propres aux skills.

### Chantier I3 - Croiser NON-027 Q1 et NON-033 Q1

**Livrable.** Les deux objections.

La même question depuis la tâche 23 : un agent peut-il rédiger un `PDC`. Ce qui a changé est qu'elle bloque désormais un chantier.

**Critère de réussite.** Chaque objection cite l'autre, et la réponse à l'une vaut pour l'autre.

**Fait.**

### Chantier I4 - Noter ce que les décisions ont changé dans NON-014 et NON-011

**Livrable.** Les deux objections.

Les deux ont été écrites avant les décisions qui ont déplacé leur objet. `NON-014` sur le trilemme de nommage, avant que `ADR-008` tranche l'identité. `NON-011` sur les types sans définition, quand sept types existaient contre trente-six.

**Ce que le chantier ne fait pas.** Les fermer. Leur question subsiste sous une autre forme, et le noter n'est pas y répondre.

**Critère de réussite.** Chaque journal porte une entrée datée qui dit ce que les décisions ont changé et ce qui subsiste.

**Fait.**

### Chantier I5 - Déclarer la limite de temps absente dans les plans

**Livrable.** Les cinq plans antérieurs.

`PDC-003` V-S3 exige une limite de temps au régime extrême SMART. Aucun plan du dépôt n'en déclare.

**Ce que le chantier ne fait pas.** Inventer une durée. Aucune base ne permet d'en estimer une : le dépôt n'a mesuré la durée d'aucun chantier.

**Critère de réussite.** Chaque plan porte le constat, et le renvoi vers le contrôle qui échoue.

**Fait.**

## Livrables attendus

| Chantier | Livrable | Nature |
|---|---|---|
| I1 | `NON-026` | Modification |
| I2 | `NON-025`, `NON-030` | Modification |
| I3 | `NON-027`, `NON-033` | Modification |
| I4 | `NON-014`, `NON-011` | Modification |
| I5 | `PLN-001` à `PLN-005` | Modification |

Douze documents, aucun créé.

## Ordre d'exécution

Aucun ordre. Les cinq chantiers sont indépendants, portent sur des documents distincts, et aucun ne demande d'outil ni d'arbitrage.

C'est ce qui les rend implémentables, et c'est le seul critère qui les a fait entrer dans ce plan.

## Objections de l'agent

**Ce plan est produit et exécuté dans la même tâche.** Un plan qui n'ordonne rien qu'on ne fasse aussitôt est un compte rendu déguisé. Il est écrit parce que la tâche 30 le demande, et sa valeur est de dire ce qui a été laissé de côté, non ce qui a été fait.

**Le ménage ne ferme aucune objection.** Trente-quatre objections existent, quatre sont répondues, et le ménage en corrige une cinquième. Le dépôt en compte donc vingt-neuf ouvertes après comme avant.

**I5 constate sans corriger.** Les cinq plans déclarent désormais que leur limite de temps manque. Ils échouent toujours au contrôle.

**Ce plan échoue lui-même à V-S3**, comme les cinq qu'il annote.

## Relations

- `derive-de` [ANL-009](../analyses/ANL-009-etat-des-lieux-de-la-notion-de-ressource.md)
- `reference` [ISU-007](../issues/ISU-007-validation-et-portee-des-ressources.md)
- `reference` [PDC-003](../principes/PDC-003-smart-et-extreme-smart.md)
