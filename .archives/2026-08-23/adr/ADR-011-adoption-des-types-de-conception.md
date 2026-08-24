---
type: adr
id: ADR-011
title: "Adoption des quatre types de la famille conception"
version: 0.1.0
status: draft
maturity: conception
adoption: propose
activated: true
domain-status: "propose"
statut-decision: propose
date: 2026-08-10
decideurs: ["claude-opus-5 (rédaction)", "human:jvtrudel (à approuver)"]
sources:
  - ANL-001
  - PLN-002
definition-associee: RES-010
---

# ADR-011 - Adoption des quatre types de la famille conception

> Acte l'adoption d'Analyse, Recherche de fondation, Principe de conception et Méthodologie, les quatre types par lesquels le système produit du savoir avant de décider.

## Statut

`propose`. Les quatre types sont en usage depuis le 2026-08-10 ; leur adoption n'avait jamais été actée.

Créé par le chantier C de `PLN-002`.

## Contexte

Les quatre types couvrent l'espace entre l'observation et la décision. Ils ont la meilleure assise du dépôt après la famille fondamentale.

| Type | Instances dans ce dépôt | Dans le corpus |
|---|---|---|
| Analyse, `ANL` | 5 | **28** |
| Recherche de fondation, `FND` | 3 | **52** |
| Principe de conception, `PDC` | 2 | 3 répertoires, aucun type |
| Méthodologie, `MET` | 2 | 3, dans `micrologic-clients` |

`FND` est le type le plus employé du corpus après les traces.

## Décision en une phrase

Quatre types sont adoptés pour produire du savoir en amont d'une décision, avec une frontière explicite entre eux : l'analyse conclut sur un cas, la fondation mobilise la littérature, le principe contraint, la méthodologie procède.

## Décisions détaillées

### D1 - Analyse, `ANL`

**Problème résolu.** Répondre à une question posée, sur un cas donné, avec une méthode déclarée et des limites écrites.

**Assise.** La meilleure de la famille : le type est le mieux éprouvé, avec vingt-huit instances dans le corpus et une décision antérieure qui le sépare de la fondation.

**Frontière.** L'analyse porte sur un cas et conclut. La fondation mobilise un savoir externe et n'est pas tenue de conclure.

### D2 - Recherche de fondation, `FND`

**Problème résolu.** Mobiliser un savoir produit ailleurs, avec ses sources, avant de trancher une question que le dépôt ne peut pas trancher seul.

**Assise.** Cinquante-deux instances dans le corpus.

**Mode de défaillance connu.** `ANL-001` mesure que le format long a tué onze dépôts de savoir : le seuil d'entrée était disproportionné pour le besoin courant. La méthodologie `MET-001` en tire son étape 1, qui vérifie qu'une fondation est bien le livrable qu'il faut.

### D3 - Principe de conception, `PDC`

**Problème résolu.** Rendre une exigence opposable. Une exigence non écrite perd tous les arbitrages.

**Assise.** Aucune instance typée dans le corpus. La meilleure matière n'y est pas typée : les quatre principes directeurs de `linux-inspect`, universalité, adaptabilité, non-intrusivité, réflexivité, sont plus opérationnels que la plupart des principes produits ensuite et n'ont jamais été promus.

**Conséquence sur la définition.** Un principe porte ses contrôles. `PDC-001` et `PDC-002` en portent trois chacun.

### D4 - Méthodologie, `MET`

**Problème résolu.** Conserver un procédé qui a fonctionné, afin qu'il soit rejouable.

**Assise.** Trois instances dans `micrologic-clients` : entrevue de CV, analyse de fit, entrevue de journalisation.

**Frontière disputée.** Un skill encadre la production d'un type de ressource ; une méthodologie porte sur le fond d'un travail métier. La frontière est la question la plus contestée de ce type. `NON-017`.

**Conséquence sur la définition.** La rubrique « Éprouvé sur » est obligatoire. C'est ce qui distingue une méthodologie d'une idée de méthode, et les deux méthodologies du dépôt y déclarent leur épreuve comme faible.

## Conséquences

Les quatre définitions retirent leur rubrique `Statut de ce document` : son contenu est ici.

Le champ `adr` des quatre définitions passe de `ADR-005` à `ADR-011`.

## Objections ouvertes

`NON-017`, bloquante, sur la frontière entre méthodologie et skill.

`NON-020`, sur le seuil de densité de `MET-001`, qu'aucune des trois fondations du dépôt n'a atteint, et sur le conflit entre les sections déclarées par `RES-011` et la structure imposée par `MET-001`.

`NON-021`, sur l'absence de recherche préalable à une décision.

## Relations

- `derive-de` [ANL-001](../analyses/ANL-001-observation-corpus-repos-et-pratiques/index.md)
- `specifie` [RES-010](../ressources/RES-010-analyse.md)
- `reference` [ADR-005](ADR-005-regroupement-fonctionnel-des-ressources.md)
