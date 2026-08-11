---
type: ressource
id: RES-004
title: "Objection"
version: 0.1.0
status: draft
prefixe: NON
emplacement: ".dev/objections/NON-<SEQ>-<SLUG>.md"
cycle-de-vie: travail
edition: hybride
famille: fondamentale
champs-obligatoires: [type, id, title, status, initiateur, effet, etat, porte-sur]
relations-admissibles: [objection, ressource, intention, contexte, fait, ontologie, concept, analyse]
sections: [Journal, Ce qui est contesté, Pourquoi cela ne peut pas rester implicite, Questions, Ce qui lèverait cette objection, Relations]
skill: skl-002-ressource-fondamentale
adr: ADR-009
statut: actif
---

# RES-004 - Objection

> Une objection est une contestation motivée qui suspend ou conditionne une avancée, formulée comme un faisceau de questions portant sur un même thème. Elle n'est pas un veto : elle se résout par réponse, non par autorité.

## Objet

Ce document définit le type `objection`, mécanisme central de la gouvernance de `clia`. `CLAUDE.md` en fait une obligation de l'agent : « SI IL Y A CONFLIT entre l'intention d'une tâche et l'intention ultime, émettre des objections ».

## Ce qu'est une objection

Une objection est une ressource de travail, à initiative partagée, qui rend explicite un désaccord ou un doute avant qu'il ne se transforme en dégât.

Elle porte quatre choses.

| Elle porte | Rôle |
|---|---|
| **Ce qui est contesté** | La cible : une ressource, une décision, une affirmation, un plan |
| **Pourquoi cela ne peut pas rester implicite** | Ce qui se passerait si l'objection n'était pas traitée |
| **Un faisceau de questions** | Plusieurs questions sur un même thème, numérotées, chacune répondable séparément |
| **Ce qui la lèverait** | La condition de résolution, énoncée par l'initiateur |

## L'objection est un faisceau de questions, pas un refus

C'est la propriété qui distingue ce type de l'objection au sens courant, et elle vient de la pratique observée.

Une objection ne dit pas « non ». Elle dit « voici ce qui n'est pas réglé, sous forme de questions auxquelles je ne peux pas répondre seul ». Cette forme a trois vertus.

Elle est **traitable par morceaux**. Une objection à sept questions peut voir cinq questions réglées et deux rester ouvertes, ce qui est l'état réel de la plupart des désaccords.

Elle **désigne un thème et non un incident**. Le corpus montre que les mêmes questions reviennent dans des dépôts différents : regrouper par thème permet de les traiter une fois.

Elle **inverse la charge sans agressivité**. L'initiateur ne prétend pas avoir raison, il établit qu'une décision est en attente.

Une conséquence pratique : un fichier d'objection porte un thème unique. Sept questions sur l'identité des ressources font une objection ; sept questions sur sept sujets font sept objections.

## Effet

Toutes les objections ne bloquent pas. Trois niveaux, déclarés par le champ `effet`.

| Effet | Conséquence sur le travail |
|---|---|
| `bloquant` | Le travail visé ne peut pas avancer avant résolution |
| `conditionnel` | Le travail peut avancer, mais ce qui est produit est réputé provisoire jusqu'à résolution |
| `informatif` | Le travail avance. L'objection est consignée pour mémoire et pour éviter que la question soit reperdue |

Cette gradation corrige une règle du `CLAUDE.md` archivé de `clia`, selon laquelle l'agent ne peut exécuter tant qu'une objection reste ouverte. Prise au mot, cette règle rend tout travail impossible dès la première objection sérieuse, ce que le même document tentait de compenser par un mécanisme de breakpoint et d'approbation partielle. Déclarer l'effet à l'ouverture est plus simple et plus honnête.

Le niveau `informatif` a une fonction propre, établie par `ANL-001` : dans le corpus, les questions ouvertes se perdent, et les mêmes idées sont réinventées jusqu'à cinq fois. Une objection informative est un dispositif de mémoire.

## États

| État | Sens |
|---|---|
| `ouverte` | Posée, aucune réponse |
| `partiellement-repondue` | Certaines questions ont reçu réponse, d'autres non |
| `repondue` | Toutes les questions ont reçu réponse, l'initiateur n'a pas encore statué |
| `resolue` | L'initiateur reconnaît que les réponses la lèvent |
| `levee-par-decision` | Non résolue sur le fond, mais l'humain a décidé de passer outre. La décision est tracée |
| `differee` | Reconnue légitime, traitement reporté. Un motif et, si possible, une échéance sont inscrits |
| `caduque` | L'objet de l'objection a disparu |

L'état `levee-par-decision` est nécessaire et doit rester visible. Une objection écartée par décision n'est pas une objection résolue, et confondre les deux fabrique une fausse mémoire.

## Initiative et propriété par bloc

Le champ `initiateur` prend `humain` ou `agent`. Le régime d'édition est `hybride`, avec propriété par bloc.

| Bloc | Propriétaire |
|---|---|
| Objet de la contestation, questions, condition de levée | L'initiateur |
| Réponses aux questions | L'autre partie |
| Journal, changements d'état | Les deux, en append |

Aucune partie ne réécrit les blocs de l'autre. Une réponse jugée insuffisante ne s'efface pas : l'initiateur ajoute une relance sous la réponse, et la question reste ouverte.

Cette règle vaut dans les deux sens. Une objection émise par l'agent appartient à l'agent, et l'humain n'en réécrit pas l'énoncé : il y répond. C'est ce qui rend l'objection de l'agent autre chose qu'une politesse.

## Source de vérité

Reprise d'une décision de `micrologic-clients`, dont la formulation est meilleure que ce qu'on écrirait à neuf : la ressource Objection est la source de vérité des objections et de leur traitement, quelle qu'en soit l'origine. Un plan, une analyse ou une session peut mentionner une objection et, au plus, la résumer. En cas de divergence, la ressource fait foi.

## Cycle de vie

`travail`. Pas de semver : une objection n'a pas de versions, elle a une histoire. Un journal en tête du document, en append, porte les changements d'état avec leur date.

Une objection n'est jamais supprimée, même caduque. La supprimer, c'est perdre la trace d'une question qui a été jugée digne d'être posée.

## Le préfixe

Le préfixe est `NON`, fixé par `DCN-008`, réponse Q3.

Un écart est à signaler : l'usage établi dans le corpus est `OBJ`, avec quatre instances existantes dans `micrologic-clients` et une définition `RES-011-objection`. `ANL-001` établit par ailleurs qu'un changement de préfixe coûte cher, et donne le cas mesuré du passage de `RES` à `DOS` qui a demandé six corrections manuelles.

Le mécanisme d'identité proposé par `RES-001`, où l'identité est le couple préfixe et slug, ne protège pas contre un changement de préfixe : il le rend simplement visible. La question est portée par `NON-001`.

## Structure attendue d'une instance

```
# NON-<SEQ> - <Thème>

> Le thème contesté, en une phrase.

## Journal
## Ce qui est contesté
## Pourquoi cela ne peut pas rester implicite
## Questions
### Q1 - <question>
**Réponse.**
### Q2 - <question>
**Réponse.**
## Ce qui lèverait cette objection
## Relations
```

## Relations

- `reference` [RES-001](RES-001-ressource.md)
- `derive-de` [RES-011-objection de micrologic-clients](../analyses/ANL-001-observation-corpus-repos-et-pratiques/candidats-ressources-fondamentales.md)

## Points ouverts

| Question | Objection |
|---|---|
| `NON` ou `OBJ` ; coût du changement de préfixe | `NON-001` |
| Faut-il un type distinct pour la réponse, ou la propriété par bloc suffit-elle | `NON-002` |
| Qui arbitre lorsque l'agent maintient une objection que l'humain lève | `NON-008` |
| Rien ne vérifie mécaniquement la propriété par bloc | `NON-005` |
