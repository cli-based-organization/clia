---
type: acteur
version: 0.1.0
title: "Opérateur du dépôt"
status: proposé
date: 2026-07-29
categorie: primaire
portee: methode
---

# ACT-001 - Opérateur du dépôt

## Définition

L'humain qui **travaille au quotidien dans un dépôt déjà équipé** du système d'augmentation. Il énonce l'intention, dirige le travail, arbitre les propositions de l'agent et opère seul ce qui est irréversible. C'est le rôle par défaut de l'humain dans une séance de travail ordinaire.

Ce n'est pas celui qui équipe un dépôt ([`ACT-003`](ACT-003-installateur.md)), ni celui qui fait évoluer le système d'augmentation lui-même ([`ACT-004`](ACT-004-mainteneur-du-systeme-augmentation.md)). Une même personne tient couramment les trois rôles ; leurs buts, leurs préconditions et leurs modes d'échec diffèrent.

## Responsabilité

Répond de **l'intention** (ce qui doit être fait et pourquoi) et de **toute action irréversible** : transitions de session, versionnage du domaine, opérations git. Répond aussi de la levée ou du maintien des objections, sans quoi rien ne s'exécute ([`CONSTITUTION.md`](../../CONSTITUTION.md), règle absolue).

## Buts poursuivis

- Soumettre un problème et obtenir une proposition d'intervention.
- Objecter à une proposition et faire amender le plan.
- Ouvrir une séance de travail, la conduire, la clore.
- Savoir à tout moment dans quel état est le système.
- Publier une version du contenu produit.

## Intérêts

- Que **rien d'irréversible** ne se produise sans son geste explicite ([`PDC-010`](../principes/PDC-010-point-entree-unique-autorite-humaine-irreversible.md)).
- Que le travail produit soit **tracé** et relisible plus tard, y compris par quelqu'un d'autre.
- Que le coût d'usage quotidien reste faible : un point d'entrée, pas une procédure.
- Que ce qu'il a demandé ne se **perde pas** entre l'énoncé et le livrable.

## Préconditions d'accès

- Un dépôt déjà équipé du système d'augmentation.
- Un accès en écriture au dépôt et l'outil d'automatisme disponible dans l'environnement.
- Aucune compétence sur le fonctionnement interne du système n'est requise : c'est un critère, pas une hypothèse.

## Modes d'échec caractéristiques

- Il demande une transition d'état impossible dans l'état courant (ouvrir alors qu'une séance est déjà ouverte, clore alors qu'aucune ne l'est) et doit savoir quoi faire ensuite.
- Sa demande est ambiguë et produit un livrable hors intention ; il le découvre après coup.
- Son besoin est correctement traité mais **disparaît** avec la séance qui l'a porté, alors que les décisions qu'il a produites subsistent (constat [C8](../analyses/ANL-014-cas-usage-et-acteurs-de-clia.md#constats)).
- Il ne trouve pas la commande ou le document dont il a besoin, faute de découvrabilité ([`PDC-007`](../principes/PDC-007-decouvrabilite-et-uniformite.md)).

## Ce que ce rôle ne fait pas

- Il n'écrit pas les livrables porteurs de jugement : il les demande, les conteste et les valide.
- Il n'installe ni ne met à niveau le système d'augmentation ([`ACT-003`](ACT-003-installateur.md)).
- Il ne modifie ni le harnais, ni les documents de conception, ni l'outillage ([`ACT-004`](ACT-004-mainteneur-du-systeme-augmentation.md)).

## Relations

- **Rôles voisins** : [`ACT-003`](ACT-003-installateur.md) (équipe le dépôt), [`ACT-004`](ACT-004-mainteneur-du-systeme-augmentation.md) (fait évoluer le système), [`ACT-002`](ACT-002-agent-ia.md) (produit ce qu'il demande).
- **Utilise** : aucun `USE` n'existe encore. Les parcours de session, de gouvernance et d'inspection dont ce rôle est l'acteur principal sont produits à l'étape 3.2 de [`PLN-017`](../plans/PLN-017-cas-usage-acteurs-tracabilite.md).
- **Source** : typologie A1 d'[`ANL-014`](../analyses/ANL-014-cas-usage-et-acteurs-de-clia.md#typologie-des-utilisateurs-et-des-parties-prenantes).
