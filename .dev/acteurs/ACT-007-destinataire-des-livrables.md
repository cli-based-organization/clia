---
type: acteur
version: 0.1.0
title: "Destinataire des livrables"
status: proposé
date: 2026-07-29
categorie: partie-prenante
portee: methode
---

# ACT-007 - Destinataire des livrables

## Définition

Celui à qui sont destinés les **livrables de domaine** produits dans un dépôt équipé : client, lecteur, commanditaire du contenu. Il ne participe à aucun parcours du système d'augmentation et n'en connaît généralement pas l'existence, mais c'est **pour lui** que le contenu est produit.

Partie prenante **hors scène** : il a un intérêt au résultat sans intervenir dans le déroulé.

## Responsabilité

Aucune vis-à-vis du système d'augmentation. Ce rôle existe dans le catalogue parce qu'il porte le critère de valeur ultime : un système de production de livrables dont personne n'attend les livrables n'a pas de raison d'être.

## Buts poursuivis

Aucun dans le système d'augmentation. Ses buts portent sur le contenu produit, qui relève du dépôt hôte.

## Intérêts

- La **qualité** du livrable qu'il reçoit.
- La **traçabilité** de sa production : pouvoir savoir d'où vient une affirmation, sur quoi elle s'appuie et quand elle a été établie.
- La **cohérence** entre livrables successifs.
- Le fait qu'un livrable ne soit pas contredit par un autre document du dépôt qui l'a produit.

## Préconditions d'accès

Aucune. Ce rôle n'accède pas au dépôt.

## Modes d'échec caractéristiques

- Il reçoit un livrable **invérifiable** : rien ne permet de remonter à ce qui le fonde.
- Il reçoit un livrable **périmé** ou contredit par une décision plus récente non propagée.
- Il ne peut pas distinguer ce qui a été établi de ce qui a été supposé.

## Ce que ce rôle ne fait pas

- Il n'opère rien dans le dépôt, ne soumet aucune demande, n'objecte à rien.
- Il ne se confond pas avec le collaborateur futur ([`ACT-008`](ACT-008-collaborateur-futur.md)), qui entre dans le dépôt et travaille avec le système.

## Relations

- **Rôles voisins** : [`ACT-001`](ACT-001-operateur-du-depot.md) (produit pour lui), [`ACT-008`](ACT-008-collaborateur-futur.md) (autre bénéficiaire de la traçabilité, mais de l'intérieur).
- **Intérêt servi par** : les exigences de traçabilité et de versionnage ([`PDC-009`](../principes/PDC-009-tracabilite-et-versionnage-atomique.md)).
- **Source** : typologie P1 d'[`ANL-014`](../analyses/ANL-014-cas-usage-et-acteurs-de-clia.md#typologie-des-utilisateurs-et-des-parties-prenantes).
