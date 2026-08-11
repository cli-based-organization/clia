---
type: decision
id: DCN-004
title: "Adoption du processus de travail collaboratif"
version: 0.1.0
status: draft
instance: "aucune : décision non actée"
date-de-decision: 2026-08-09
portee: systeme
effet: proposee
---

# DCN-004 - Adoption du processus de travail collaboratif

> Enregistrement de la décision formulée par [ADR-002](../adr/ADR-002-adoption-du-processus-de-travail.md). **Cette décision n'est pas prise** : l'ADR porte le statut `propose` et attend l'acte de l'humain.

## Objet

Donner à l'humain un document court à approuver, plutôt qu'un ADR à lire en entier, pour chacune des décisions que la session a formulées sans les acter.

Ce document est produit à la demande de la tâche 8 de la session du 2026-08-09, qui demande une DCN pour les ADR-001 à ADR-014. Deux réserves s'appliquent, exposées dans la rubrique finale.

## La décision

Le travail se fait par sessions portant chacune une intention, un ou plusieurs livrables et un critère de convergence. Toute demande y est d'abord analysée puis journalisée. La production est faite de ressources typées. Le comportement de l'agent IA est encadré par un ensemble conventionné de harnais. Tout désaccord, ambiguïté ou déviation par rapport à l'intention ultime est signalé au moment où il est identifié par une objection, que l'humain comme l'agent peuvent émettre. Et la journalisation est obligatoire, sans exception.

Huit décisions détaillées, D1 à D8. Sa décision D6 rompt avec la règle absolue de non-exécution sous objection ouverte héritée du `CONSTITUTION.md` archivé.

## Qui a décidé

**Personne encore.** L'ADR est au statut de décision `propose`, et le champ `effet` de cette DCN vaut `proposee`.

Ce qui manque pour que la décision existe : les réponses aux objections `NON-009` sur le statut de la session, qui est bloquante, et `NON-010` sur les rôles des agents

## Portée

`systeme`, si la décision est actée.

## Conséquences

Les conséquences sont instruites dans [ADR-002](../adr/ADR-002-adoption-du-processus-de-travail.md), section « Conséquences ». Elles ne se produisent pas tant que l'effet vaut `proposee`.

## Ce que la décision ne dit pas

Voir la section « Ce que la décision ne règle pas » de [ADR-002](../adr/ADR-002-adoption-du-processus-de-travail.md).

## Réserve sur la production de ce document

Deux réserves, signalées à l'humain plutôt que passées sous silence.

**Une DCN enregistre normalement une décision prise.** `RES-009` le pose ainsi. Enregistrer une décision non actée a exigé d'ajouter la valeur `proposee` au champ `effet`, ce qui est un écart à la définition du type, assumé et justifié dans `RES-009`.

**Les ADR-006 à ADR-014 n'existent pas.** La demande porte sur les ADR-001 à ADR-014 ; le dépôt en compte cinq au 2026-08-10. Aucune DCN n'a été produite pour des ADR inexistants. Voir `NON-017`.

## Relations

- `specifie` [ADR-002](../adr/ADR-002-adoption-du-processus-de-travail.md)
