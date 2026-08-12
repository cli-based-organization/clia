# Demande interprétée, tâche 34

Écrit le 2026-08-11 à 19:28, avant toute exploration. `MET-003` étape 1.

## Énoncé

Tâche 34, `[conception]` : créer une ressource de type bogue `BUG`.

L'énoncé tient en une ligne. Tout le reste est à déduire.

## Ce que la tâche 32 avait établi

Le manque a été constaté il y a deux tâches, et signalé trois fois.

> « Ouvrir un bogue » suppose un type que le dépôt n'a pas. `PLN-005` chantier D prévoit un registre de bogues, jamais créé.

Le journal de la tâche 32 le porte en dette nommée : « Aucun type bogue n'existe. Ouvrir un bogue a produit une `ISU`. »

**La tâche 34 comble ce manque.**

## Ce que je dois déduire, faute d'énoncé

| Élément | À déterminer |
|---|---|
| Le préfixe | `BUG` est donné |
| La famille | Six existent. Le bogue en préparation ou en contenu ? |
| Le cycle de vie | `travail` probablement, comme l'issue et l'objection |
| Le régime d'édition | Qui peut ouvrir un bogue |
| Les champs propres | Ce qui distingue un bogue d'une issue |
| Les sections | Ce qu'un bogue doit porter |

## La frontière à tracer, et elle est la difficulté

`RES-031` définit l'issue : « une problématique dans le but de la résoudre », **non SMART par construction**.

Un bogue est aussi une problématique à résoudre. **Qu'est-ce qui l'en distingue ?**

Deux pistes à vérifier contre le dépôt.

**Le bogue a un comportement attendu.** `RES-012` pose que le non-respect d'un principe de conception est un bogue : il y a une règle, et un écart mesurable à cette règle. Une issue n'a pas de règle de référence.

**Le bogue est reproductible.** Une issue porte un problème ouvert ; un bogue porte un écart constatable, donc vérifiable.

Si l'une de ces pistes tient, le bogue est **plus SMART** qu'une issue, ce qui le rapproche du comportement attendu et l'éloigne de l'issue.

## Ce que le dépôt porte déjà et qui compte

Le mot bogue est employé par l'humain comme **catégorie de tâche** depuis le 2026-08-09 : les tâches 13, 15, 26 et 32 sont classées `[bogue]`.

Quatre bogues réels ont été constatés et corrigés pendant la session, et aucun n'a de ressource.

## Ce que je vérifierai

Les bogues constatés dans le dépôt, pour que la définition repose sur des cas et non sur une idée.

Ce que `RES-024`, comportement attendu, dit déjà, puisque c'est le type le plus proche.

## Ce que je ne ferai pas

**Créer le registre de bogues.** `PLN-005` chantier D le porte, et `NON-029` Q1 laisse ouverte la question du type unique ou de la catégorie.
