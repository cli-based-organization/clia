---
type: ressource
id: RES-033
title: "Tâche"
status: draft
maturity: conception
adoption: propose
activated: true
domain-status: "actif"
version: 0.1.0
prefixe: TSK
emplacement: ".dev/logs/SES-<SEQ>-<SLUG>/TSK-<SEQ>-<SLUG>/"
cycle-de-vie: travail
edition: hybride
famille: preparation
champs-obligatoires: [type, id, title, status, session, categorie, etat]
relations-admissibles: [tache, session, log, ressource, objection, issue]
sections: [Énoncé, État, Livrables, Relations]
skill: skl-006-ressource-de-preparation
adr: ADR-013
statut: actif
---

# RES-033 - Tâche

> Une tâche est une unité de travail demandée par l'humain dans une session. Elle est un **répertoire** : elle contient tous les logs de son exécution, et rien d'autre.

## Objet

Ce document définit le type `tache`. Sa fonction est de rattacher un travail demandé à la trace de son exécution.

## Ce qu'est une tâche

Une ressource composite, au sens de `ADR-004` D3. Son répertoire porte l'énoncé et les logs produits pendant l'exécution.

| Elle porte | Rôle |
|---|---|
| **L'énoncé** | Ce que l'humain a demandé, repris sans reformulation |
| **La catégorie** | Le crochet du titre : `conception`, `bogue`, `implémentation`, `analyse`, `traitement des objections` |
| **L'état** | Où en est l'exécution |
| **Les logs** | Tous les logs de cette tâche, et uniquement les siens |

**Un répertoire par tâche.** Il contient tous les logs de cette tâche et aucun log d'une autre. Un fichier de log qui rapporte deux tâches est un défaut.

## Ce qu'une tâche n'est pas

| Ce n'est pas | Différence |
|---|---|
| Une **issue** | L'issue est un problème ouvert, non SMART. La tâche est un travail demandé |
| Un **plan** | Le plan ordonne des chantiers. La tâche est l'unité que l'humain demande |
| Un **log** | La tâche est ce qui est demandé, le log est ce qui a été fait |
| Une **session** | La session contient des tâches |

## Champs propres

| Champ | Valeurs | Rôle |
|---|---|---|
| `session` | `SES-<SEQ>` | La session qui porte cette tâche |
| `categorie` | Texte libre | Le crochet du titre dans le fichier de session |
| `etat` | `demandee`, `en-cours`, `faite`, `abandonnee` | Où en est l'exécution |

## Test d'admission

Une tâche existe si l'humain l'a écrite dans le fichier de session.

L'agent ne crée pas de tâche. Il en enregistre une qui a été demandée.

## Cycle de vie et versionnage

`travail`. Une tâche a une histoire, pas des versions. Elle ne porte pas de champ `version`.

## Régime d'édition

`hybride`, avec propriété par bloc.

| Bloc | Propriétaire |
|---|---|
| L'énoncé | L'humain seul, repris sans reformulation |
| L'état | Les deux |
| Les livrables | L'agent |

## Frontière avec les types voisins

| Voisin | Ce qui départage |
|---|---|
| `ISU` | Un travail demandé contre un problème ouvert |
| `PLN` | L'unité que l'humain demande contre un ordonnancement de chantiers |
| `LOG` | Ce qui est demandé contre ce qui a été fait |

## Structure attendue d'une instance

Un répertoire.

```
TSK-<SEQ>-<SLUG>/
    TSK-01-demande_<horodatage>_<slug>.md
    TSK-02-analyse_<horodatage>_<slug>.md
    ...
```

L'énoncé peut vivre dans le log de type `demande`, qui le reprend et l'interprète. Un fichier d'énoncé distinct n'est pas exigé.


## Cycle de vie métier : `domain-status`

`DCN-016` pose que `domain-status` porte le cycle de vie métier du type, et que chaque définition en déclare l'énumération.

| Valeur | Reprise de |
|---|---|
| `demandee` | `etat` |
| `en-cours` | `etat` |
| `faite` | `etat` |
| `abandonnee` | `etat` |

Ces valeurs sont **reprises du champ `etat`**, que `DCN-016` supprime. Elles ne sont pas nouvelles : le type les portait déjà.

## Relations

- `reference` [RES-001](RES-001-ressource.md)
- `reference` [RES-032](RES-032-log.md)
- `reference` [RES-034](RES-034-session.md)

## Points ouverts

| Question | Objection |
|---|---|
| Le répertoire suffit-il, ou faut-il un fichier d'énoncé distinct | `NON-028` |
| Qui pose l'état d'une tâche, et quand | `NON-028` |
