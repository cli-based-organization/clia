---
type: ressource
id: RES-007
title: "Concept"
version: 0.1.0
status: draft
maturity: conception
adoption: propose
activated: true
domain-status: "actif"
prefixe: CPT
emplacement: ".dev/concepts/CPT-<SEQ>-<SLUG>.md"
cycle-de-vie: vivant
edition: co-edition
famille: fondamentale
champs-obligatoires: [type, id, title, version, status, terme-ontologique, origine, emplois-attestes]
relations-admissibles: [concept, ontologie, fondation, analyse, intention]
sections: [Ce que nomme ce concept, Origine, Ce qu'il permet de voir, Ce qu'il exclut, Emplois attestés, Limites et cas frontières, Relations]
skill: skl-002-ressource-fondamentale
adr: ADR-009
statut: actif
---

# RES-007 - Concept

> Un concept élabore une idée : ce qu'elle nomme, d'où elle vient, ce qu'elle permet de voir, ce qu'elle exclut, et à quoi elle sert. C'est une élaboration propre, ni compilation de sources, ni observation d'un existant, ni entrée de lexique.

## Objet

Ce document définit le type `concept`. Sa fonction est de conserver les idées que le travail produit, afin qu'elles cessent d'être perdues avec le dépôt qui les portait.

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

**Un critère unique**, fixé par `NON-004` Q6 : la **compatibilité** du concept avec `clia`, ou avec le système où `clia` est employé.

C'est l'humain qui crée le concept qui détermine s'il est pertinent.

**Ce qui est écarté.** Le seuil à trois conditions du premier jet, qui exigeait un emploi attesté dans deux ressources, une élaboration dépassant cinq lignes, et un effet sur une décision. La première condition posait un problème d'amorçage : un concept nouveau n'a aucun emploi au moment où on l'écrit.

**Ce que le critère unique déplace.** La pertinence n'est pas mesurable par observation. Elle est décidée, et elle est contextuelle : un concept compatible avec un dépôt peut ne pas l'être avec un autre.

**Ce qui subsiste du premier jet.** Un concept qui se réduit à cinq lignes vit dans une `ONT`, et non dans un fichier propre. Ce n'est plus une condition d'admission mais un choix de forme, fixé par `NON-004` Q1 : un `CPT` sert aux concepts réutilisés à plusieurs endroits.

## Critère de clôture

La longueur est bornée.

Un concept est **clos** quand il énonce ses limites et ses cas frontières. Ce n'est pas quand le sujet est épuisé : un sujet ne s'épuise pas.

Longueur indicative : une à trois pages. Au-delà, deux hypothèses sont plus probables qu'une troisième page : soit le document est en réalité une recherche de fondation, soit il élabore deux concepts distincts.

## Frontière avec les types voisins

`NON-004` porte la question dans son ensemble.

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

Aucune instance n'existe. Les sept concepts orphelins recensés plus haut sont les candidats, dont trois dont le système dépend sans les avoir écrits : `extreme-smart`, `distillation` et `objection sociocratique`.

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

## Cycle de vie métier : `domain-status`

`DCN-016` pose que `domain-status` porte le cycle de vie métier du type, et que chaque définition en déclare l'énumération.

**Aucune.** Ce type n'a pas de cycle de vie métier propre : son état est entièrement décrit par les trois champs universels `maturity`, `adoption` et `activated`.

## Relations
```

## Relations

- `reference` [RES-001](RES-001-ressource.md)
- `derive-de` [RES-006](RES-006-ontologie.md)

## Points ouverts

| Question | Objection |
|---|---|
| Le concept est-il un type distinct, ou une entrée d'ontologie développée | `NON-004` |
| Le critère de compatibilité est-il vérifiable, ou seulement déclaratif | `NON-002` |
| Un concept doit-il être partagé entre dépôts, et par quel mécanisme | `NON-006` |
| Que faire des sept concepts orphelins du corpus | `NON-004` |
