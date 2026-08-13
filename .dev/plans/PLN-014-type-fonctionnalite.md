---
type: plan
id: PLN-014
title: "Type fonctionnalité"
status: draft
statut-plan: propose
date: 2026-08-13
initiateur: agent
porte-sur: [RES-001, .dev/ressources]
---

# PLN-014 - Type fonctionnalité

> Neuf plans, et aucun ne dit ce qu'il livre. Le dépôt n'a que des unités de problème — plans, issues, objections — et aucune unité de produit. « Travailler sur une fonctionnalité » est une phrase qu'il ne peut pas exprimer.

## Statut

`propose`.

## Intention

Donner au dépôt l'unité de focus qui lui manque.

**Cible mesurable.** `clia res ls fonctionnalite` affiche ce que le système fait, et chaque plan déclare la fonctionnalité qu'il sert.

## Chantiers

### Chantier A - Définir le type

| Élément | Valeur |
|---|---|
| **Livrable** | Une définition `RES`, son schéma, son gabarit |
| **Critère de réussite** | Les fonctionnalités déjà livrées du CLI se rangent dans le type sans forcer |
| **Limite de temps** | 1 heure 30 |
| **Dépend de** | rien |

**Le test d'admission proposé.** Une fonctionnalité est ce dont un utilisateur peut dire qu'il s'en sert. `clia setup init` en est une ; « le champ `etat` est énuméré » n'en est pas une.

**Ce qui la départage de ses voisins.** Le plan dit comment on la construit ; la spécification dit ce qu'elle doit faire ; la fonctionnalité dit **qu'elle existe et à quoi elle sert**.

### Chantier B - Rattacher les plans

| Élément | Valeur |
|---|---|
| **Livrable** | Les 14 plans, champ `porte-sur` |
| **Critère de réussite** | Chaque plan déclare la fonctionnalité qu'il sert, ou déclare n'en servir aucune |
| **Limite de temps** | 1 heure |
| **Dépend de** | A |

**Ce que le rattachement rend possible.** Répondre à « où en est telle fonctionnalité » en lisant une ligne au lieu de neuf plans.

## Ce qui est écarté

**Le type `Note d'implémentation` n'est pas créé.** `ANL-011` le motive : son contenu existe déjà dans les quarante-quatre journaux de fait, et il recouperait à la fois ces journaux et les messages de commit.

**Ce qui manque à la place est une sortie, non un type** : dériver les notes de version des journaux existants. Ce n'est pas dans ce plan.

## Objections de l'agent

**Un type de plus dans un dépôt qui en a trente-sept.** `NON-002` conteste la prolifération depuis le 2026-08-09, et cette analyse dit que le nombre d'items doit descendre.

**Ce qui le justifie malgré tout** : c'est le seul type qui retire de la charge au lieu d'en ajouter, en agrégeant neuf plans sous quelques fonctionnalités nommées.

## Relations

- `derive-de` [ANL-011](../analyses/ANL-011-focus-et-accumulation-des-items-ouverts.md)
- `reference` [NON-002](../objections/NON-002-cout-du-modele.md)
