---
type: ressource
id: RES-034
title: "Session"
status: draft
version: 0.1.0
prefixe: SES
emplacement: ".dev/logs/SES-<SEQ>-<SLUG>/"
cycle-de-vie: travail
edition: hybride
famille: preparation
champs-obligatoires: [type, id, title, status, ouverture, etat]
relations-admissibles: [session, tache, ressource, intention, objection]
sections: [Contexte, Intention, Critère de convergence, Tâches, Relations]
skill: skl-006-ressource-de-preparation
adr: ADR-013
statut: actif
---

# RES-034 - Session

> Une session est un segment de travail borné par une intention et un critère de convergence. Elle est un **répertoire** contenant les tâches qui la composent.

## Objet

Ce document définit le type `session`. Sa fonction est de donner au travail une unité plus grande que la tâche et plus petite que le dépôt.

## Ce qu'est une session

Une ressource composite. Son répertoire contient un répertoire par tâche.

| Elle porte | Rôle |
|---|---|
| **Le contexte** | La situation dans laquelle le travail s'ouvre |
| **L'intention** | Ce que la session vise |
| **Le critère de convergence** | Ce qui permet de la clore. Il n'a pas à être défini à l'ouverture |
| **Les tâches** | Ce qui est demandé, dans l'ordre où l'humain l'écrit |

## Ce qu'une session n'est pas

| Ce n'est pas | Différence |
|---|---|
| `workspace/session.md` | Le fichier de session est le point d'entrée **vivant**, en édition humaine. Une `SES` est son enregistrement |
| Une **tâche** | La session contient des tâches |
| Une **intention** | L'intention d'une session est bornée. `INT` porte l'intention ultime du dépôt |

## Champs propres

| Champ | Valeurs | Rôle |
|---|---|---|
| `ouverture` | Date ISO | Quand la session a été ouverte |
| `etat` | `ouverte`, `close`, `abandonnee` | Où en est la session |

Le critère de convergence n'est pas un champ obligatoire : `ADR-002` pose qu'il n'a pas à être défini au démarrage.

## Test d'admission

Une session existe dès que l'humain écrit dans `workspace/session.md`.

## Cycle de vie et versionnage

`travail`. Pas de champ `version`.

## Régime d'édition

`hybride`, avec propriété par bloc.

| Bloc | Propriétaire |
|---|---|
| Le contexte, l'intention, le critère de convergence, les tâches | L'humain seul |
| L'état | Les deux |

L'agent ne réécrit jamais l'énoncé d'une tâche ni l'intention d'une session.

## Frontière avec les types voisins

| Voisin | Ce qui départage |
|---|---|
| `TSK` | Le contenant contre l'unité de travail |
| `INT` | Une intention bornée contre l'intention ultime du dépôt |
| `CTX` | Le contexte d'une session contre un contexte réutilisable |

## Structure attendue d'une instance

Un répertoire.

```
SES-<SEQ>-<SLUG>/
    TSK-001-<slug>/
    TSK-002-<slug>/
    ...
```

## Relations

- `reference` [RES-001](RES-001-ressource.md)
- `reference` [RES-033](RES-033-tache.md)
- `reference` [RES-003](RES-003-intention.md)

## Points ouverts

| Question | Objection |
|---|---|
| Le fichier de session vivant devient-il une `SES` à sa clôture, et par quel geste | `NON-028` |
| Le répertoire de session actuel porte une date, la nouvelle forme un numéro | `NON-028` |
