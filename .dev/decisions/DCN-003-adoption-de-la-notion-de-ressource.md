---
type: decision
id: DCN-003
title: "Adoption de la notion de ressource"
version: 0.1.0
status: draft
instance: "aucune : décision non actée"
date-de-decision: 2026-08-09
portee: systeme
effet: proposee
attestation: interne
diffusion: public
---

# DCN-003 - Adoption de la notion de ressource

> Enregistrement de la décision formulée par [ADR-001](../adr/ADR-001-adoption-de-la-notion-de-ressource.md). **Cette décision n'est pas prise** : l'ADR porte le statut `propose` et attend l'acte de l'humain.

## Objet

Donner à l'humain un document court à approuver, plutôt qu'un ADR à lire en entier, pour chacune des décisions que la session a formulées sans les acter.

Ce document est produit à la demande de la tâche 8 de la session du 2026-08-09, qui demande une DCN pour les ADR-001 à ADR-014. Deux réserves s'appliquent, exposées dans la rubrique finale.

## La décision

`clia` adopte la ressource comme unité du travail : un fichier markdown à frontmatter YAML typé, dont un type déclaré gouverne la forme, dont l'identité est stable et indépendante de son emplacement, et qui fait foi par opposition à la conversation. Chaque type se définit dans une ressource dédiée, s'acte dans un ADR et se produit selon un skill, ces trois documents étant complétés type par type.

Neuf décisions détaillées, D1 à D9. Sa décision D2 est partiellement abrogée par `ADR-004`, qui définit la ressource par ses propriétés et non par son support.

## Motivation du changement

Sans objet, cette décision n'en remplace aucune.

## Qui a décidé

**Personne encore.** L'ADR est au statut de décision `propose`, et le champ `effet` de cette DCN vaut `proposee`.

Ce qui manque pour que la décision existe : les réponses aux objections `NON-001` sur l'identité, `NON-002` sur le coût du modèle, et `NON-005` sur la validation, dont les trois sont bloquantes et portent sur D3, D6, D4 et D9

## Portée

`systeme`, si la décision est actée.

## Conséquences

Les conséquences sont instruites dans [ADR-001](../adr/ADR-001-adoption-de-la-notion-de-ressource.md), section « Conséquences ». Elles ne se produisent pas tant que l'effet vaut `proposee`.

## Ce que la décision ne dit pas

Voir la section « Ce que la décision ne règle pas » de [ADR-001](../adr/ADR-001-adoption-de-la-notion-de-ressource.md).

## Réserve sur la production de ce document

Deux réserves, signalées à l'humain plutôt que passées sous silence.

**Une DCN enregistre normalement une décision prise.** `RES-009` le pose ainsi. Enregistrer une décision non actée a exigé d'ajouter la valeur `proposee` au champ `effet`, ce qui est un écart à la définition du type, assumé et justifié dans `RES-009`.

**Les ADR-006 à ADR-014 n'existent pas.** La demande porte sur les ADR-001 à ADR-014 ; le dépôt en compte cinq au 2026-08-10. Aucune DCN n'a été produite pour des ADR inexistants. Voir `NON-017`.

## Relations

- `specifie` [ADR-001](../adr/ADR-001-adoption-de-la-notion-de-ressource.md)
