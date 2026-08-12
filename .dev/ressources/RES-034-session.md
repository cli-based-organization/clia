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
sections: [INTENTION, CONTEXTE, LIVRABLES, CRITÈRES DE CONVERGENCE, TÂCHES]
skill: skl-006-ressource-de-preparation
adr: ADR-013
statut: actif
---

# RES-034 - Session

> Une session est un segment de travail borné par une intention. Elle est un **répertoire** : son énoncé, et le journal des tâches qui la composent.

## Objet

Ce document définit le type `session`. Sa fonction est de donner au travail une unité plus grande que la tâche et plus petite que le dépôt.

## Ce qu'est une session

Une ressource composite. Son répertoire contient un répertoire par tâche.

Cinq rubriques, dans cet ordre.

| Rubrique | Rôle |
|---|---|
| **1. INTENTION** | Ce que la session vise |
| **2. CONTEXTE** | La situation dans laquelle le travail s'ouvre |
| **3. LIVRABLES** | Ce que la session produit |
| **4. CRITÈRES DE CONVERGENCE** | Ce qui permet de clore la session |
| **5. TÂCHES** | Ce qui est demandé, dans l'ordre où l'humain l'écrit |

L'ordre n'est pas indifférent : l'intention vient avant le contexte, comme dans les quatre sessions archivées du dépôt. Une tâche est une rubrique de **niveau deux**, ouverte par son numéro : `## 12. [bogue] ...`. Le niveau suffit à la distinguer d'une rubrique de session.

**`LIVRABLES` est ce que la définition n'avait pas.** La session déclare ce qu'elle produit, ce que `PDC-003` V-S1 exige d'un plan.

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
| `etat` | `todo`, `opened`, `closed` | Où en est la session |

Le cycle est `todo => opened => closed`. Une session `todo` est planifiée et n'a pas de date d'ouverture.

**Le critère de convergence est une rubrique obligatoire.** Il l'avait perdue le 2026-08-11, et l'humain l'a rétabli le lendemain : `ADR-002` fonde la segmentation du travail sur l'intention, le livrable et le critère de convergence, et les trois ont désormais leur rubrique.

Il n'a pas à être défini à l'ouverture. `ADR-002` le pose, et la rubrique peut rester `À rédiger`.

L'état `abandonnee` n'existe plus : une session abandonnée est `closed`, indistinguable d'une session aboutie. `ISU-011` porte l'écart, à la demande de l'humain.

## Test d'admission

Une session existe dès que l'humain écrit dans `workspace/session.md`.

## Cycle de vie et versionnage

`travail`. Pas de champ `version`.

## Régime d'édition

`hybride`, avec propriété par bloc.

| Bloc | Propriétaire |
|---|---|
| Les quatre rubriques | L'humain seul |
| L'état | L'humain, ou le cli agissant pour lui |

L'agent ne réécrit jamais l'énoncé d'une tâche ni l'intention d'une session.

**Ouvrir et fermer sont des actes de l'humain.** `clia ses new`, `clia ses close` et `clia ses todo` refusent de s'exécuter pour un agent, code de retour 3. Ils décident de ce sur quoi le dépôt travaille : `ADR-002` en fait un acte de l'humain, et `CONSTITUTION.md` C3 place l'énoncé en régime d'édition humaine.

`clia ses status` et `clia ses ls` lisent : ils sont libres.

## Frontière avec les types voisins

| Voisin | Ce qui départage |
|---|---|
| `TSK` | Le contenant contre l'unité de travail |
| `INT` | Une intention bornée contre l'intention ultime du dépôt |
| `CTX` | Le contexte d'une session contre un contexte réutilisable |

## Structure attendue d'une instance

Un répertoire.

```
.dev/logs/SES-<SEQ>-<SLUG>/
    SES-<SEQ>.md          l'énoncé
    TSK-001-<slug>/       le journal d'une tâche
    TSK-002-<slug>/
    ...
```

## Ce qui compte une tâche faite

Une tâche est **faite quand son journal porte le message de commit**, septième et dernière étape de `MET-003`. Sa présence atteste que les six autres ont été écrites.

**Le critère ne dit pas qu'une tâche est bien faite.** Il dit qu'elle est journalisée jusqu'au bout, ce qui est vérifiable, là où « bien faite » ne l'est pas.

## Le fichier de session vivant

`workspace/session.md` est le point d'entrée déclaré par `CLAUDE.md`. Tant qu'aucun énoncé ne porte `etat: open`, **c'est lui la session en cours**, et les commandes de lecture le traitent comme tel.

Il ne peut pas être fermé : il ne porte pas de frontmatter. L'enregistrer comme énoncé est un geste de l'humain.

## Relations

- `reference` [RES-001](RES-001-ressource.md)
- `reference` [RES-033](RES-033-tache.md)
- `reference` [RES-003](RES-003-intention.md)

## Points ouverts

| Question | Objection |
|---|---|
| Le fichier de session vivant devient-il une `SES` à sa clôture, et par quel geste | `NON-028` |
| Le répertoire de session actuel porte une date, la nouvelle forme un numéro | `NON-028` |
| Aucun geste ne consulte le critère de convergence | `ISU-010` |
| Une session abandonnée est indistinguable d'une session aboutie | `ISU-011` |
| Un lien pointant une session non ouverte s'affiche comme session en cours | `NON-038` |
