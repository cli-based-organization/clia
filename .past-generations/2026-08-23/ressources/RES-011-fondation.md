---
type: ressource
id: RES-011
title: "Recherche de fondation"
version: 0.1.0
status: draft
maturity: conception
adoption: propose
activated: true
domain-status: "actif"
prefixe: FND
emplacement: ".dev/fondations/FND-<SEQ>-<SLUG>.md"
cycle-de-vie: point-fixe
edition: ia
famille: conception
champs-obligatoires: [type, id, title, status, date, sujet, methodologie]
relations-admissibles: [fondation, analyse, concept, ontologie, ressource]
sections: [Objet et méthode, Corps de la revue, Ce que la recherche établit, Sources, Limites, Relations]
skill: skl-003-ressource-de-conception
adr: ADR-011
statut: actif
---

# RES-011 - Recherche de fondation

> Une recherche de fondation établit ce que d'autres ont déjà établi, avec ses sources et le degré de crédibilité de chacune. Elle ne conclut pas pour le dépôt : elle fournit le socle sur lequel une analyse ou une décision s'appuiera.

## Objet

Définit le type `fondation`. Sa fonction est de faire entrer du savoir extérieur dans le système sous une forme citable et vérifiable.

## Ce qu'est une fondation

Elle porte cinq choses. Une question de recherche, formulée de manière réfutable. Une méthode déclarée, y compris la hiérarchie de crédibilité employée. Un corps sourcé, où chaque affirmation empruntée porte sa référence. Des propositions, distinctes des affirmations sourcées. Et ses limites, y compris ce que la littérature ne traite pas.

## Ce qu'une fondation n'est pas

| Ce n'est pas | Différence |
|---|---|
| Une **analyse** | L'analyse observe un existant matériel. La fondation lit ce que d'autres ont écrit |
| Un **concept** | Le concept est une élaboration propre. La fondation compile et évalue |
| Un **article** | L'article est destiné à la publication. La fondation est un instrument interne |

## Le sourçage, qui est la propriété définitionnelle

Une affirmation sans source n'a sa place dans une fondation que si elle est d'une des trois natures déclarées : définition posée par le document, raisonnement propre signalé comme tel, ou fait établi ailleurs dans le dépôt.

La hiérarchie de crédibilité doit être déclarée, et chaque écart signalé à l'endroit où il se produit. Une fondation qui cite un billet de blogue à côté d'une norme ISO sans le dire trompe son lecteur.

## Cycle de vie

`point-fixe`. Une source consultée l'a été à une date, et le champ de la validité des URL le rend sensible : `FND-002` consigne l'état de vérification de ses trente-deux références avec sa date.

## Régime d'édition

`ia`.

## Structure attendue d'une instance

```
# FND-<SEQ> - <Titre>

> Ce que la recherche établit, en une phrase.

## Objet et méthode
## <corps, structuré selon la méthodologie déclarée>
## Ce que la recherche établit
## Sources
## Limites

## Cycle de vie métier : `domain-status`

`DCN-016` pose que `domain-status` porte le cycle de vie métier du type, et que chaque définition en déclare l'énumération.

**Aucune.** Ce type n'a pas de cycle de vie métier propre : son état est entièrement décrit par les trois champs universels `maturity`, `adoption` et `activated`.

## Relations
```

Les rubriques « Sources » et « Limites » sont obligatoires.

## Relations

- `reference` [RES-001](RES-001-ressource.md)
- `reference` [RES-010](RES-010-analyse.md)

## Points ouverts

| Question | Objection |
|---|---|
| Faut-il une forme plus légère pour le savoir de petite taille | `NON-004` Q3 |
| Les URL doivent-elles être vérifiées à chaque relecture | `NON-015` |
