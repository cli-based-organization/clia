---
type: acteur
version: 0.1.0
title: "Mainteneur du système d'augmentation"
status: proposé
date: 2026-07-29
categorie: primaire
portee: methode
---

# ACT-004 - Mainteneur du système d'augmentation

## Définition

L'humain qui **fait évoluer le système d'augmentation lui-même** : le harnais, les skills, les documents de conception et l'automatisme. Il travaille **sur** le système, quand les autres rôles travaillent **avec** lui.

## Responsabilité

Répond de la **cohérence du système** dans la durée : conformité aux principes de conception, non-duplication des sources de vérité, généricité du harnais, et versionnage de chaque ressource qu'il touche.

## Buts poursuivis

- Ajouter, modifier ou retirer un type de ressource.
- Faire évoluer une convention et propager le changement à tout ce qui en dépend.
- Qualifier un écart constaté et le corriger de façon tracée.
- Vérifier que l'implémentation est conforme à ce que la conception énonce.

## Intérêts

- Que la **frontière méthode / domaine** tienne : ce qui est générique doit rester transposable à tout dépôt hôte ([`PDC-003`](../principes/PDC-003-separation-methode-domaine-genericite-harnais.md), tension déjà consignée par [`BUG-003`](../bugs/BUG-003-frontiere-methode-domaine-sous-tension.md)).
- Qu'une décision soit **tracée** et retrouvable, pas seulement appliquée.
- Qu'un changement de conception **signale** ce qu'il rend obsolète, plutôt que de laisser l'écart silencieux (cause systémique de [`BUG-007`](../bugs/BUG-007-resource-sh-modele-abroge.md)).
- Que le coût d'ajout d'un type de ressource reste proportionné.

## Préconditions d'accès

- La connaissance du corpus de conception du système, ou les moyens de le parcourir.
- Un accès en écriture aux ressources de méthode et à l'outillage.
- L'ordre de travail établi : recherche et préconception, conception, méthodologie, implémentation ([`ADR-007`](../adr/ADR-007-architecture-systeme-augmentation.md)).

## Modes d'échec caractéristiques

- Il modifie la conception sans réconcilier l'implémentation qui en dépend, et l'écart reste invisible ([`BUG-007`](../bugs/BUG-007-resource-sh-modele-abroge.md)).
- Il introduit une **seconde source de vérité** pour une information qui en avait déjà une ([`PDC-006`](../principes/PDC-006-source-de-verite-documentaire-unique.md)).
- Il laisse entrer de l'information de domaine dans une ressource de harnais, qui cesse d'être transposable.
- Il ajoute un type de ressource sans le skill ni la vue de harnais correspondants, et le type reste inutilisable en pratique.
- Il corrige un symptôme sans qualifier la cause, si bien que l'écart se reproduit.

## Ce que ce rôle ne fait pas

- Il ne conduit pas le travail de domaine dans un dépôt équipé ([`ACT-001`](ACT-001-operateur-du-depot.md)).
- Il ne déploie pas le système dans les dépôts hôtes ([`ACT-003`](ACT-003-installateur.md)).
- Il ne décide pas seul : ses propositions passent par le même cycle d'objection que les autres.

## Relations

- **Rôles voisins** : [`ACT-003`](ACT-003-installateur.md) (déploie ce qu'il produit), [`ACT-002`](ACT-002-agent-ia.md) (gouverné par le harnais qu'il maintient), [`ACT-008`](ACT-008-collaborateur-futur.md) (héritera de ses choix).
- **Utilise** : aucun `USE` n'existe encore ; les parcours d'inspection dont ce rôle est co-acteur sont produits à l'étape 3.2 de [`PLN-017`](../plans/PLN-017-cas-usage-acteurs-tracabilite.md).
- **Source** : typologie A4 d'[`ANL-014`](../analyses/ANL-014-cas-usage-et-acteurs-de-clia.md#typologie-des-utilisateurs-et-des-parties-prenantes).
