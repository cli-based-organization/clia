---
type: ressource
id: RES-010
title: "Analyse"
version: 0.1.0
status: draft
prefixe: ANL
emplacement: ".dev/analyses/ANL-<SEQ>-<SLUG>.md"
cycle-de-vie: point-fixe
edition: ia
famille: conception
champs-obligatoires: [type, id, title, status, date, sujet]
relations-admissibles: [analyse, fondation, fait, contexte, objection, ressource]
sections: [Objet, Méthode, Constats, Réponse à la question posée, Limites, Relations]
skill: skl-003-ressource-de-conception
adr: ADR-005
statut: actif
---

# RES-010 - Analyse

> Une analyse porte sur un existant matériel, à une date donnée, et en tire des constats. Elle répond à une question posée, ou elle n'a pas d'objet.

## Objet

Définit le type `analyse`. Sa fonction est de produire du savoir sur ce qui est, par opposition à la fondation qui produit du savoir sur ce que d'autres ont établi.

## Statut de ce document

Premier jet du 2026-08-10. Le type est le mieux éprouvé de la famille : trois instances dans ce dépôt, vingt-huit dans le corpus, et une décision antérieure qui le sépare de la fondation.

## Ce qu'est une analyse

Elle porte quatre choses. Un objet matériel observé, nommé et daté. Une méthode reproductible, dont les mesures peuvent être refaites. Des constats, distincts des interprétations. Et une réponse à la question qui l'a motivée.

Une analyse sans question posée est une description, et elle ne sert à rien.

## Ce qu'une analyse n'est pas

| Ce n'est pas | Différence |
|---|---|
| Une **fondation** | La fondation porte sur la littérature, l'analyse sur un existant matériel. Décision reprise de `ADR-001-type-livrable-analyse` du corpus |
| Un **fait** | Un fait est un énoncé atomique vérifiable. Une analyse en emploie et les interprète |
| Un **rapport de recherche** | Le rapport est destiné à sortir du dépôt. L'analyse est un instrument de travail interne |

## Cycle de vie

`point-fixe`, nommage séquencé comme tous les types selon `RES-001`. Le nommage effectif de ce dépôt est séquencé, non-conformité portée par `NON-011` Q2, et le cas de `ANL-001` montre par ailleurs qu'une analyse est révisée après production, ce qui contredit l'immuabilité.

## Régime d'édition

`ia`. L'humain lit, commente, et objecte.

## Structure attendue d'une instance

```
# ANL-<SEQ> - <Titre>

> Ce que l'analyse établit, en une phrase.

## Objet
## Méthode
## Constats
## Réponse à la question posée
## Limites
## Relations
```

La rubrique « Limites » est obligatoire. Une analyse qui ne dit pas ce qu'elle n'a pas pu établir se lit comme complète.

## Relations

- `reference` [RES-001](RES-001-ressource.md)
- `reference` [RES-011](RES-011-fondation.md)

## Points ouverts

| Question | Objection |
|---|---|
| Nommage daté ou séquencé | `NON-011` Q2 |
| Une analyse en bundle est-elle une ressource ou plusieurs | `NON-012`, tranchée par `ADR-004` |
