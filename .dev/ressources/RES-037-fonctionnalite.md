---
type: ressource
id: RES-037
title: "Fonctionnalité"
status: draft
version: 0.1.0
prefixe: FNC
emplacement: ".dev/fonctionnalites/FNC-<SEQ>-<SLUG>.md"
cycle-de-vie: vivant
edition: hybride
famille: preparation
champs-obligatoires: [type, id, title, version, status, etat, usage]
relations-admissibles: [fonctionnalite, plan, specification, code, bogue, issue]
sections: [Ce qu'elle fait, Comment s'en servir, Ce qu'elle ne fait pas, Ce qui la porte, Relations]
skill: skl-006-ressource-de-preparation
adr: ADR-013
statut: actif
---

# RES-037 - Fonctionnalité

> Une fonctionnalité est ce dont un utilisateur peut dire qu'il s'en sert. C'est la seule unité de **produit** du système : tout le reste — plan, issue, objection, bogue — est une unité de **problème**.

## Objet

Ce document définit le type `fonctionnalite`. Sa fonction est de donner au dépôt de quoi répondre à « qu'est-ce que ce système fait, et où en est-on ».

## Le manque qu'elle comble

`ANL-011` C7 le mesure : quatorze plans, et aucun ne déclare ce qu'il livre. Pour savoir ce que `PLN-006` implémente, il faut le lire en entier.

L'humain le formule ainsi, tâche 6 de `SES-002` : « on ne sait pas les fonctionnalités que vont implémenter PLN et si ils sont exécutés ou non ».

**Le dépôt n'avait aucune unité de produit.** « Travailler sur une fonctionnalité » est une phrase qu'il ne pouvait pas exprimer : il n'avait que des plans, des issues et des objections, qui nomment tous un problème, jamais un acquis.

## Test d'admission

**Une fonctionnalité est ce dont un utilisateur peut dire qu'il s'en sert.**

| C'en est une | Ce n'en est pas une |
|---|---|
| `clia setup init` instrumente un dépôt | Le champ `etat` est énuméré dans le schéma |
| `clia ses switch` change de session | `find -L` suit les liens symboliques |
| La garde qui refuse un commit à l'agent | `RES-004` déclare sept états |

**Le départage tient à qui en parle.** Si seul un développeur du système peut en parler, c'est une décision technique, pas une fonctionnalité.

## Champs propres

| Champ | Valeurs | Rôle |
|---|---|---|
| `etat` | `pressentie`, `en-cours`, `livree`, `retiree` | Où elle en est |
| `usage` | Une ligne | La commande ou le geste qui l'emploie |

**`usage` est obligatoire et tient en une ligne.** Une fonctionnalité dont on ne peut pas écrire l'usage en une ligne n'a pas été comprise, ou n'en est pas une.

**`pressentie` n'est pas `en-cours`.** Une fonctionnalité pressentie est nommée sans qu'aucun travail ne soit engagé : c'est ce qui permet de déclarer une intention de produit sans ouvrir un plan.

## Ce qu'une fonctionnalité n'est pas

| Ce n'est pas | Différence |
|---|---|
| Un **plan** | Le plan dit comment on la construit, et il est jetable. La fonctionnalité lui survit |
| Une **spécification** | La spécification dit ce que le système doit faire ; la fonctionnalité dit ce qu'il fait |
| Un **cas d'usage** | Le cas d'usage décrit un parcours ; la fonctionnalité décrit une capacité |
| Une **issue** | L'issue est un problème à défricher ; la fonctionnalité est un acquis |

## Cycle de vie et versionnage

`vivant`. Une fonctionnalité change avec le système : elle porte un `version` en semver.

Elle n'est pas supprimée quand elle disparaît du produit : elle passe à `retiree`, et son document dit depuis quelle version.

## Régime d'édition

`hybride`.

| Bloc | Propriétaire |
|---|---|
| Ce qu'elle fait, ce qu'elle ne fait pas | Les deux |
| Comment s'en servir | L'agent, qui l'a implémentée |
| L'état | L'agent, qui constate ; l'humain, qui décide de `retiree` |

## Structure attendue d'une instance

Cinq rubriques.

| Rubrique | Ce qu'elle porte |
|---|---|
| **Ce qu'elle fait** | En trois phrases au plus |
| **Comment s'en servir** | La commande, avec un exemple qui s'exécute |
| **Ce qu'elle ne fait pas** | Les limites connues, et les bogues ouverts qui la touchent |
| **Ce qui la porte** | Le code, les plans qui l'ont livrée, la spécification s'il y en a une |
| **Relations** | Les renvois |

**« Comment s'en servir » est la rubrique qui justifie le type.** Sans elle, une fonctionnalité n'est qu'un titre dans une liste.

## Frontière avec les types voisins

| Voisin | Ce qui départage |
|---|---|
| `PLN` | Le chemin contre la destination |
| `SPC` | Ce qui doit être contre ce qui est |
| `CDE` | L'implémentation contre ce qu'elle rend possible |
| `BUG` | Un écart dans une fonctionnalité contre la fonctionnalité elle-même |

## Points ouverts

| Question | Où |
|---|---|
| Un type de plus dans un dépôt qui en compte trente-sept | `NON-002` |
| Le rattachement des plans existants est-il rétroactif | `PLN-014` chantier B |

## Relations

- `reference` [RES-001](RES-001-ressource.md)
- `reference` [RES-025](RES-025-plan.md)
- `reference` [RES-020](RES-020-specification.md)
- `derive-de` [ANL-011](../analyses/ANL-011-focus-et-accumulation-des-items-ouverts.md)
