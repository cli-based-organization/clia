---
type: ressource
id: RES-012
title: "Principe de conception"
version: 0.1.0
status: draft
prefixe: PDC
emplacement: ".dev/principes/PDC-<SEQ>-<SLUG>.md"
cycle-de-vie: vivant
edition: humain
famille: conception
champs-obligatoires: [type, id, title, version, status, portee]
relations-admissibles: [principe, ressource, adr, concept, objection]
sections: [Objet, Le principe, Ce qu'il exclut, Comment le vérifier, Conséquence d'une violation, Relations]
skill: skl-003-ressource-de-conception
adr: ADR-011
statut: actif
---

# RES-012 - Principe de conception

> Un principe de conception est une contrainte transverse et durable à laquelle tout élément du système doit se conformer. Sa violation est un défaut, non une préférence contrariée.

## Objet

Définit le type `principe`. Sa fonction est de rendre opposable une exigence qui traverse tous les types de ressources et tous les composants.

## Ce qu'est un principe

Il porte quatre choses. Un énoncé qui tient en une phrase. Ce qu'il exclut, formulé de manière à reconnaître une violation. Un moyen de vérifier, mécanique si possible. Et la conséquence d'une violation.

## Ce qu'un principe n'est pas

| Ce n'est pas | Différence |
|---|---|
| Un **ADR** | Un ADR décide une fois, pour un objet. Un principe contraint durablement, pour tous les objets |
| Une **intention** | L'intention énonce un but à atteindre. Le principe énonce une contrainte à respecter en chemin |
| Une **règle de forme** | Une règle de forme est locale à un type. Un principe est transverse |

## La violation est un défaut

Le non-respect d'un principe de conception est un bogue, règle reprise du `CLAUDE.md` archivé. Elle rend un principe opposable, et elle suppose un moyen de détecter la violation que ce dépôt n'a pas.

Un principe sans moyen de vérification est une exhortation. La rubrique « Comment le vérifier » est donc obligatoire, et elle peut valoir « aucun moyen aujourd'hui », ce qui est un aveu utile.

## Cycle de vie

`vivant`, versionné.

## Régime d'édition

`humain`. `CONSTITUTION.md` C1 : seuls les humains créent un principe de conception.

| Geste | Qui |
|---|---|
| Produire le gabarit, `clia res new principe-de-conception` | L'agent ou l'humain |
| Rédiger le principe, ses exclusions et ses contrôles | L'humain seul |
| Modifier une instance existante | L'humain seul |
| Recommander un principe | L'agent, dans une analyse, un plan ou une objection |

Un principe engage les deux parties : l'humain l'invoque pour refuser, l'agent l'invoque pour objecter. C'est ce qui interdit à l'agent de l'écrire : un principe qu'un agent se donne à lui-même ne contraint personne.

## Structure attendue d'une instance

```
# PDC-<SEQ> - <Titre>

> Le principe, en une phrase.

## Objet
## Le principe
## Ce qu'il exclut
## Comment le vérifier
## Conséquence d'une violation
## Relations
```

## Relations

- `reference` [RES-001](RES-001-ressource.md)

## Points ouverts

| Question | Objection |
|---|---|
| Un principe sans moyen de vérification a-t-il une valeur | `NON-005` Q1 |
| Faut-il promouvoir les quatre principes de `linux-inspect` | `NON-017` |
