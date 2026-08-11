---
type: ressource
id: RES-031
title: "Issue"
version: 0.1.0
status: draft
prefixe: ISU
emplacement: ".dev/issues/ISU-<SEQ>-<SLUG>.md"
cycle-de-vie: travail
edition: hybride
famille: preparation
champs-obligatoires: [type, id, title, status, initiateur, etat, ouverture]
relations-admissibles: [issue, ressource, objection, analyse, plan, decision, intention]
sections: [Journal, La problématique, Ce qui la rend difficile, Ce qui a été tenté, Pistes, Ce qui la clôturerait, Relations]
skill: skl-006-ressource-de-preparation
adr: ADR-013
statut: actif
---

# RES-031 - Issue

> Une issue documente une problématique dans le but de la résoudre. Elle est **non SMART** : elle n'a ni livrable, ni échéance, ni critère de réussite mesurable. Son coût d'entrée est un titre et une phrase.

## Objet

Ce document définit le type `issue`. Sa fonction est d'accueillir un sujet de travail avant qu'il soit assez net pour être planifié.

## Ce qu'est une issue

Une ressource de travail qui porte cinq choses.

| Elle porte | Rôle |
|---|---|
| **La problématique** | Ce qui ne va pas, ou ce qui manque, formulé sans solution |
| **Ce qui la rend difficile** | Pourquoi elle n'est pas déjà réglée |
| **Ce qui a été tenté** | Les approches essayées et leur résultat |
| **Les pistes** | Des directions, sans engagement ni ordre |
| **Ce qui la clôturerait** | La condition de fermeture, qui peut être imprécise |

Une issue est **non SMART**, et c'est sa propriété définitoire. `PDC-003` fixe le régime SMART des ressources de planification ; l'issue en est exclue par construction.

| Critère SMART | Une issue |
|---|---|
| Spécifique | pas nécessairement |
| Mesurable | non |
| Atteignable | inconnu |
| Réaliste | inconnu |
| Temporel | aucune échéance |

Cette exclusion est ce qui rend son coût d'entrée minimal. Un sujet dont on ne sait encore ni la forme, ni l'effort, ni l'échéance a un endroit où être écrit.

## Ce qu'une issue n'est pas

| Ce n'est pas | Différence |
|---|---|
| Un **plan** | Le plan ordonne des chantiers et déclare ses points d'arrêt. L'issue n'ordonne rien |
| Une **objection** | L'objection conteste ce qui est produit ou décidé. L'issue constate un manque, sans contester personne |
| Un **fragment** | Le fragment est de la matière captée. L'issue est un problème formulé |
| Un **comportement attendu** | Le comportement dit ce que le système doit faire. L'issue dit ce qui ne va pas |
| Un **contexte** | Le contexte décrit une situation. L'issue nomme un problème dans cette situation |

## Champs propres

| Champ | Valeurs | Rôle |
|---|---|---|
| `initiateur` | `humain`, `agent` | Qui l'a ouverte |
| `etat` | `ouverte`, `en-cours`, `close`, `abandonnee` | Où elle en est |
| `ouverture` | Date ISO | Quand elle a été ouverte |

Une issue `abandonnee` n'est pas supprimée. Elle porte, dans son journal, la raison de l'abandon.

## Test d'admission

Une problématique mérite une issue si les deux conditions sont réunies.

1. Elle **survivra à la session** en cours. Sinon, une ligne dans le fichier de session suffit.
2. Elle n'est **pas assez nette** pour être planifiée. Sinon, c'est un plan ou un comportement attendu.

La seconde condition est celle qui évite la confusion avec la planification. Une problématique dont on connaît déjà le livrable, l'effort et l'échéance n'a pas besoin d'une issue : elle a besoin d'un plan.

## Cycle de vie et versionnage

`travail`. Une issue a une histoire, pas des versions. Son journal en tête porte les dates et les changements d'état.

Elle ne porte pas de champ `version`.

## Régime d'édition

`hybride`, avec propriété par bloc.

| Bloc | Propriétaire |
|---|---|
| La problématique | L'initiateur seul |
| Ce qui la rend difficile, ce qui a été tenté | Les deux, en append |
| Les pistes | Les deux |
| L'état et le journal | Les deux, en append |

L'agent ne reformule jamais l'énoncé de la problématique posé par l'humain.

## Frontière avec les types voisins

| Voisin | Ce qui départage |
|---|---|
| `PLN` | Un problème ouvert contre une intervention ordonnée |
| `NON` | Un manque constaté contre une contestation de ce qui est produit |
| `CMP` | Ce qui ne va pas contre ce que le système doit faire |
| `FRG` | Un problème formulé contre de la matière captée |

## Structure attendue d'une instance

```
# ISU-<SEQ> - <Titre>

> La problématique en une phrase.

## Journal
## La problématique
## Ce qui la rend difficile
## Ce qui a été tenté
## Pistes
## Ce qui la clôturerait
## Relations
```

La rubrique « Ce qui a été tenté » est obligatoire, même vide. Une issue rouverte sans mémoire des tentatives fait recommencer le même travail.

## Relations

- `reference` [RES-001](RES-001-ressource.md)
- `reference` [RES-025](RES-025-plan.md)
- `reference` [RES-004](RES-004-objection.md)

## Points ouverts

| Question | Objection |
|---|---|
| L'issue doit-elle être créée par l'humain seul, comme le corpus le posait | `NON-027` |
| Une issue close produit-elle un plan, ou disparaît-elle | `NON-027` |
| Le graphe issue vers plan vers livrable est-il modélisé | `NON-027` |
