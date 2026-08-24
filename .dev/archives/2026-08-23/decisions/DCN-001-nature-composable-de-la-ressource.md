---
type: decision
id: DCN-001
title: "La ressource est un ensemble composable et atomique d'informations"
version: 0.1.0
status: draft
maturity: conception
adoption: adopte
activated: true
domain-status: "en-vigueur"
instance: "human:jvtrudel"
date-de-decision: 2026-08-09
portee: systeme
effet: en-vigueur
attestation: interne
diffusion: public
---

# DCN-001 - La ressource est un ensemble composable et atomique d'informations

> Décision de l'humain, prise le 2026-08-09 dans la tâche 9 de la session : la ressource se définit par ses propriétés et non par son support, et elle est composable, chaque composant étant lui-même une ressource.

## Objet

Enregistrer une décision qui change la définition centrale du système, afin qu'elle soit citable indépendamment de l'ADR qui l'instruit.

Ce document constate ; il ne décide pas. Le raisonnement, les alternatives écartées et les portes de sortie vivent dans `ADR-004`.

## La décision

Trois énoncés, repris de la tâche 9 de `workspace/session.md`.

**Sur la nature.** Une ressource est un ensemble identifiable et auto-cohérent d'informations. L'implémentation spécifique n'est pas importante : une ressource peut être un fichier, un répertoire contenant plusieurs fichiers, un dépôt git ou toute autre forme.

**Sur la composition.** Une ressource est composable et atomique. On peut construire une ressource à partir d'un assemblage d'autres ressources, et chaque composant d'une ressource est un atome, c'est-à-dire une petite ressource qui fait partie d'une autre.

**Sur la propriété holographique.** Le titre de la tâche nomme une propriété holographique des ressources sans la définir. `ADR-004` D4 en retient la lecture suivante : chaque atome est auto-cohérent au même titre que le composite, donc lisible seul. Cette lecture est une interprétation de l'agent, et elle est signalée comme telle dans l'ADR et portée par `NON-016`.

## Motivation du changement

Sans objet, cette décision n'en remplace aucune.

## Qui a décidé

`human:jvtrudel`, propriétaire du dépôt, dans la tâche 9 de la session ouverte le 2026-08-09.

La décision est formulée à l'impératif dans la demande, sous la forme « Décision : une ressource est composable / atomique », et accompagnée de l'instruction d'en produire un ADR. Elle n'est donc pas une proposition soumise à l'agent.

## Portée

`systeme`. La décision porte sur la notion de ressource, qui est le socle du système `clia`, et non sur un domaine métier ni sur un dépôt particulier.

Elle s'applique à tous les types de ressources, existants et à venir.

## Conséquences

| Conséquence | Où elle est instruite |
|---|---|
| La définition de la ressource par le fichier markdown est abrogée en tant que définition | `ADR-004` D1 |
| Le markdown reste le format par défaut, comme choix de mise en oeuvre et non comme définition | `ADR-004` D1 |
| Deux relations sont ajoutées au vocabulaire : `compose` et `fait-partie-de` | `ADR-004` D3 |
| Un composite et ses atomes portent des identités distinctes | `ADR-004` D5 |
| Le décompte des instances compte les ressources et non les fichiers | `ADR-004` D6 |
| `RES-001` passe en version 0.3.0 | Modification de la définition |
| `clia res ls` produit un décompte faux jusqu'à sa mise à jour | Implémentation à faire |
| `ANL-001` doit être mis en conformité : ses huit atomes déclarent leur appartenance | Travail de mise en conformité |

**Conséquence sur une objection ouverte.** `NON-012`, ouverte le 2026-08-09 sur la granularité de la ressource, reçoit une réponse par le haut : sa question Q1 est tranchée, une ressource peut être un répertoire. Ses questions Q4 et Q5 restent ouvertes.

**Conséquence sur une suggestion.** La suggestion S9 de `ANL-003`, qui proposait de traiter le bundle comme un cas particulier à index, est dépassée par une décision plus générale. Elle n'est pas rejetée : sa convention d'entrée par `index` est reprise par `ADR-004` D5.

## Ce que la décision ne dit pas

Elle ne dit pas quelle est la granularité minimale utile d'un atome.

Elle ne dit pas comment un composite est reconnu mécaniquement, sinon par la convention d'entrée que l'ADR retient.

Elle ne dit pas ce que devient un atome dont le composite est supprimé.

Elle ne dit pas si la propriété holographique impose une redondance d'information entre atome et composite. L'ADR retient la lecture faible et le signale.

Elle ne dit rien des ressources non textuelles, qu'elle rend possibles sans les modéliser.

## Relations

- `specifie` [ADR-004](../adr/ADR-004-nature-composable-de-la-ressource.md)
- `reference` [RES-001](../ressources/RES-001-ressource.md)
- `reference` [NON-012](../objections/NON-012-granularite-de-la-ressource.md)
