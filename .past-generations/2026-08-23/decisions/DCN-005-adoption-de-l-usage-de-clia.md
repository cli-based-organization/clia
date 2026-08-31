---
type: decision
id: DCN-005
title: "Adoption de l'usage d'un CLI extensible"
version: 0.1.0
status: draft
maturity: conception
adoption: propose
activated: true
domain-status: "proposee"
instance: "aucune : décision non actée"
date-de-decision: 2026-08-09
portee: systeme
effet: proposee
attestation: interne
diffusion: public
---

# DCN-005 - Adoption de l'usage d'un CLI extensible

> Enregistrement de la décision formulée par [ADR-003](../adr/ADR-003-adoption-de-l-usage-de-clia.md). **Cette décision n'est pas prise** : l'ADR porte le statut `propose` et attend l'acte de l'humain.

## Objet

Donner à l'humain un document court à approuver, plutôt qu'un ADR à lire en entier, pour chacune des décisions que la session a formulées sans les acter.

Ce document est produit à la demande de la tâche 8 de la session du 2026-08-09, qui demande une DCN pour les ADR-001 à ADR-014. Deux réserves s'appliquent, exposées dans la rubrique finale.

## La décision

Le système comporte un CLI déterministe et générique, `clia`, troisième agent aux côtés de l'humain et de l'agent IA. Il est conçu selon le modèle orienté ressources et extensible par type. Sa fonction est de garantir ce qui doit être garanti : l'intégrité du système d'information, les transitions d'état, l'installation, la validation. Il reste dans ce dépôt tant que la méthode et l'outil changent ensemble, et il en sortira selon un critère écrit.

Neuf décisions détaillées, D1 à D9, dont D4 porte son propre critère de renversement.

## Motivation du changement

Sans objet, cette décision n'en remplace aucune.

## Qui a décidé

**Personne encore.** L'ADR est au statut de décision `propose`, et le champ `effet` de cette DCN vaut `proposee`.

Ce qui manque pour que la décision existe : la réponse à l'objection `NON-011` sur les types employés sans définition, et une prise de position sur la localisation décidée en D4

## Portée

`systeme`, si la décision est actée.

## Conséquences

Les conséquences sont instruites dans [ADR-003](../adr/ADR-003-adoption-de-l-usage-de-clia.md), section « Conséquences ». Elles ne se produisent pas tant que l'effet vaut `proposee`.

## Ce que la décision ne dit pas

Voir la section « Ce que la décision ne règle pas » de [ADR-003](../adr/ADR-003-adoption-de-l-usage-de-clia.md).

## Réserve sur la production de ce document

Deux réserves, signalées à l'humain plutôt que passées sous silence.

**Une DCN enregistre normalement une décision prise.** `RES-009` le pose ainsi. Enregistrer une décision non actée a exigé d'ajouter la valeur `proposee` au champ `effet`, ce qui est un écart à la définition du type, assumé et justifié dans `RES-009`.

**Les ADR-006 à ADR-014 n'existent pas.** La demande porte sur les ADR-001 à ADR-014 ; le dépôt en compte cinq au 2026-08-10. Aucune DCN n'a été produite pour des ADR inexistants. Voir `NON-017`.

## Relations

- `specifie` [ADR-003](../adr/ADR-003-adoption-de-l-usage-de-clia.md)
