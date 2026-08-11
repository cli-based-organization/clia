---
type: ressource
id: RES-007
title: "Concept"
version: 0.1.0
status: draft
prefixe: CPT
emplacement: ".dev/concepts/CPT-<SEQ>-<SLUG>.md"
cycle-de-vie: vivant
edition: co-edition
famille: fondamentale
champs-obligatoires: [type, id, title, version, status, terme-ontologique, origine, emplois-attestes]
relations-admissibles: [concept, ontologie, fondation, analyse, intention]
sections: [Ce que nomme ce concept, Origine, Ce qu'il permet de voir, Ce qu'il exclut, Emplois attestés, Limites et cas frontières, Relations]
skill: skl-002-ressource-fondamentale
adr: aucun
statut: actif
---

# RES-007 - Concept

> Un concept élabore une idée : ce qu'elle nomme, d'où elle vient, ce qu'elle permet de voir, ce qu'elle exclut, et à quoi elle sert. C'est une élaboration propre, ni compilation de sources, ni observation d'un existant, ni entrée de lexique.

## Objet

Ce document définit le type `concept`. Sa fonction est de conserver les idées que le travail produit, afin qu'elles cessent d'être perdues avec le dépôt qui les portait.

## Statut de ce document

Premier jet, et le plus fragile des sept. `ANL-001` classe le concept comme **absent** : aucune instance, aucun répertoire, aucun skill, aucune mention dans le corpus hors du `CLAUDE.md` de `clia`. Ce jet ne consolide rien ; il propose un type que rien n'a éprouvé.

Une prudence particulière s'impose donc, et elle est intégrée à la définition sous la forme d'un seuil d'admission strict.

## Le problème que ce type résout

Le corpus produit des concepts en abondance et les perd. `ANL-001` en relève sept, tous formulés dans un dépôt, tous employés, aucun n'ayant de document propre.

| Concept | Origine | État aujourd'hui |
|---|---|---|
| Topologie de style | `la-isla-disruptiva/ptyle`, 2023 | Plus cité nulle part |
| Phore | `disruptiva-dev/nty`, 2026-03 | Plus cité nulle part |
| Pilier de communication | `disruptiva-dev/comm-cli`, 2026-05 | Spécifié dans un dépôt jamais implémenté, absent du dépôt qui porte son nom |
| Distillation | `noumanity-dev/ticket-driven-ai`, 2026-06 | Cité dans une table de zones, non élaboré |
| Extreme-smart | `nou-methodologies-ia`, 2026-03 | Un ADR y renvoie, la notion elle-même n'est pas écrite |
| Réflexivité | `cli-based-organization/linux-inspect`, 2026-06 | Un des quatre principes directeurs, jamais promu |
| Objection sociocratique | `intentional-doers-governance`, 2026-07 | Mécanisme central de la méthode, adopté sans essai de fondation dédié |

Ces sept idées vivent dans un README, une section de constitution ou un titre d'ADR. Elles ne sont ni citables, ni contestables, ni réutilisables. Le type `concept` existe pour cela.

## Ce qu'est un concept

Un concept est une ressource vivante qui élabore une idée employée par le travail. Il porte six choses.

| Il porte | Rôle |
|---|---|
| **Ce qu'il nomme** | L'idée en une phrase, sans jargon et sans renvoi |
| **Son origine** | Où et quand l'idée est apparue, et de quoi elle procède |
| **Ce qu'il permet de voir** | Ce qui devient visible ou décidable une fois l'idée admise |
| **Ce qu'il exclut** | Ce que l'idée n'est pas, en particulier les confusions probables |
| **Ses emplois attestés** | Où le concept est effectivement employé, avec les renvois |
| **Ses limites** | Où l'idée cesse de valoir, et ce qu'elle ne règle pas |

Les deux dernières rubriques sont obligatoires, et elles sont ce qui distingue un concept d'un essai.

## Seuil d'admission

C'est la partie normative de ce document, et elle existe parce que `ANL-001` établit au défaut D4 que le système consacre une part croissante de son énergie à se décrire. `CPT` est, de tous les types annoncés, le plus susceptible de proliférer : rien ne borne naturellement le nombre d'idées qu'on peut élaborer.

Un concept ne s'ouvre que si les trois conditions sont réunies.

1. **Il est employé.** Le terme apparaît dans au moins deux ressources, ou dans deux dépôts. Un concept ouvert pour un emploi unique est un commentaire déguisé.
2. **Il ne se réduit pas à une entrée d'ontologie.** Si l'élaboration tient en cinq lignes, elle appartient à `ONT`.
3. **Il change une décision.** L'admettre ou le rejeter modifie ce qu'on fait. Une idée juste mais sans conséquence n'a pas besoin de ce type.

La première condition a une conséquence utile : elle rend le champ `emplois-attestes` non décoratif. Un concept dont les emplois attestés tombent à zéro passe en `status: deprecated`.

## Critère de clôture

Le corpus montre une propension à produire de longs documents sur des sujets ouverts. Ce jet borne donc explicitement.

Un concept est **clos** quand il énonce ses limites et ses cas frontières. Ce n'est pas quand le sujet est épuisé : un sujet ne s'épuise pas.

Longueur indicative : une à trois pages. Au-delà, deux hypothèses sont plus probables qu'une troisième page : soit le document est en réalité une recherche de fondation, soit il élabore deux concepts distincts.

## Frontière avec les types voisins

`NON-004` porte la question dans son ensemble. La proposition de ce jet :

| Type | Sur quoi il porte | Ce qu'il produit |
|---|---|---|
| `ONT` | Le mot, dans un système de mots | Une entrée de lexique |
| `CPT` | L'idée, élaborée pour elle-même | Une élaboration propre |
| `FND` | La littérature, les travaux d'autrui | Une recherche sourcée et exhaustive |
| `ANL` | Un existant matériel, à une date | Une observation critique, immuable |

Test pratique, en une question : d'où vient le contenu ?

S'il vient d'autrui, avec des sources, c'est une fondation. S'il vient d'un existant observé, c'est une analyse. S'il vient d'un accord sur les mots, c'est une ontologie. S'il vient de l'élaboration propre de celui qui écrit, c'est un concept.

Un concept peut naturellement s'appuyer sur une fondation ou sur une analyse. Il le déclare par une relation `derive-de`, ce qui évite de recopier leur contenu.

## Le rapport à l'ontologie

Tout concept a une entrée d'ontologie, déclarée par le champ `terme-ontologique`. La réciproque est fausse : la plupart des entrées d'ontologie n'ont pas de concept.

Ce rattachement obligatoire a une fonction précise : il empêche qu'un concept introduise un mot nouveau sans que ce mot soit inscrit au lexique. C'est le mode de défaillance observé dans le corpus, où sept concepts ont introduit sept termes dont aucun n'est inscrit nulle part.

## Régime d'édition

`co-edition`. L'agent peut élaborer, l'humain peut élaborer, et l'un comme l'autre peut contester par une objection. Un concept n'appartient à personne : c'est ce qui le distingue de l'intention.

## Instances candidates

Ce jet ne produit aucune instance. Les sept concepts orphelins recensés plus haut sont les candidats naturels, et trois d'entre eux paraissent prioritaires parce que le système en dépend aujourd'hui sans les avoir écrits : `extreme-smart`, `distillation` et `objection sociocratique`.

## Structure attendue d'une instance

```
# CPT-<SEQ> - <Nom du concept>

> L'idée en une phrase, sans jargon.

## Ce que nomme ce concept
## Origine
## Ce qu'il permet de voir
## Ce qu'il exclut
## Emplois attestés
## Limites et cas frontières
## Relations
```

## Relations

- `reference` [RES-001](RES-001-ressource.md)
- `derive-de` [RES-006](RES-006-ontologie.md)

## Points ouverts

| Question | Objection |
|---|---|
| Le concept est-il un type distinct, ou une entrée d'ontologie développée | `NON-004` |
| Le seuil d'admission à trois conditions est-il applicable, ou dissuasif | `NON-002` |
| Un concept doit-il être partagé entre dépôts, et par quel mécanisme | `NON-006` |
| Que faire des sept concepts orphelins du corpus | `NON-004` |
