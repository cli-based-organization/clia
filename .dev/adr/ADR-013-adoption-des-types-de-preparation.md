---
type: adr
id: ADR-013
title: "Adoption des sept types de la famille préparation"
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
definition-associee: RES-019
---

# ADR-013 - Adoption des sept types de la famille préparation

> Acte l'adoption des sept types qui préparent une implémentation : décision d'architecture, spécification, requis fonctionnel, requis non fonctionnel, cas d'usage, comportement attendu et plan de travail.

## Statut

`propose`. Les sept types sont définis depuis le 2026-08-10 ; leur adoption n'avait jamais été actée.

Créé par le chantier C de `PLN-002`.

## Contexte

C'est la famille la plus inégalement instanciée du dépôt.

| Type | Instances ici | Dans le corpus |
|---|---|---|
| Décision d'architecture, `ADR` | **13** | **89** |
| Plan de travail, `PLN` | 2 | 37 |
| Spécification, `SPC` | 0 | 12 |
| Requis fonctionnel, `RQF` | 0 | 13 requis de toutes natures |
| Requis non fonctionnel, `RQNF` | 0 | 0 |
| Cas d'usage, `USE` | 0 | 0 |
| Comportement attendu, `CMP` | 0 | 0, **et pourtant le plus employé de fait** |

## Décision en une phrase

Sept types de préparation sont adoptés, dont quatre n'ont aucune instance nulle part, et le dépôt assume ce pari sur la base du défaut D3 de `ANL-001` : ce qui n'a pas de type ne se décide pas, il se subit.

## Décisions détaillées

### D1 - Décision d'architecture, `ADR`

**Problème résolu.** Acter un choix de conception, avec ses alternatives écartées et ses conséquences.

**Assise.** Le type le plus employé du corpus après les traces et les tickets, avec quatre-vingt-neuf instances.

**Mode de défaillance mesuré.** `ANL-001` établit au défaut D3 que les quatre-vingt-neuf `ADR` du corpus portent sur des questions internes de forme, et **aucun** sur les quatre ruptures de cap réelles. Un type très employé peut manquer entièrement son objet.

**Correction retenue.** Le type `DCN` prend en charge les décisions prises ailleurs, `ADR-010` D2. L'`ADR` reste le lieu du **pourquoi** d'un choix de conception, ce que `skl-001` B1 pose et que `ANL-004` a établi comme non tenu jusqu'au 2026-08-10.

### D2 - Spécification, `SPC`

**Problème résolu.** Décrire ce qu'un composant doit faire, indépendamment de son implémentation.

**Assise.** Douze instances dans le corpus. Le type est éprouvé dans `ticket-driven-ai`, qui en fait un livrable outillé avec sa garde propre.

**Contrainte particulière.** `ADR-006` pose la séparation stricte entre la spécification du système et son implémentation. Ce type en est le support.

### D3 - Requis fonctionnel, `RQF`

**Problème résolu.** Énoncer une exigence vérifiable sur ce que le système fait.

**Assise.** Treize requis de toutes natures dans le corpus, aucun typé.

### D4 - Requis non fonctionnel, `RQNF`

**Problème résolu.** Énoncer une exigence sur la manière dont le système se comporte : performance, ergonomie, sécurité.

**Assise.** Aucune, nulle part.

**Ce qui l'a rendu nécessaire.** `PDC-002` fixe l'ergonomie interne comme exigence non négociable avec trois contraintes chiffrées. Ce contenu appartient au requis non fonctionnel autant qu'au principe, et la frontière n'est pas tranchée.

### D5 - Cas d'usage, `USE`

**Problème résolu.** Décrire une interaction du point de vue de celui qui l'accomplit.

**Assise.** Aucune. Le type était prévu par le `resource-types.yaml` archivé, avec un champ `acteur-principal`, un champ `niveau`, et trois relations typées : `utilise`, `satisfait`, `realise`.

### D6 - Comportement attendu, `CMP`

**Problème résolu.** Fixer ce que le système doit faire dans un cas donné, sous une forme qui puisse devenir un test.

**Assise.** Aucune instance typée, et pourtant **le type le plus employé de fait** : les assertions de `tests/test_clia.sh` sont des comportements attendus, écrits directement en bash sans passer par une ressource. Elles sont quatre-vingt-onze au 2026-08-10.

**Ce que cet écart signifie.** Le dépôt pratique le type sans le nommer. C'est la situation que `ANL-001` appelle **latente**, et elle est ici mesurable à quatre-vingt-onze occurrences.

### D7 - Plan de travail, `PLN`

**Problème résolu.** Ordonner des chantiers, nommer leurs dépendances et leurs points d'arrêt, sans les exécuter.

**Assise.** Trente-sept instances dans le corpus, avec une définition et un skill éprouvés dans `micrologic-clients`.

**Ce que l'usage établit ici.** `PLN-001` a été produit à la tâche 4 alors que le type n'avait aucune définition. `PLN-002` a produit la remédiation exécutée par la tâche 17. Les deux portent la rubrique « Objections de l'agent », qui est ce qui distingue un plan d'une liste de tâches.

## Conséquences

Les sept définitions retirent leur rubrique `Statut de ce document` : son contenu est ici.

Le champ `adr` des sept définitions passe de `ADR-005` à `ADR-013`.

**Ce que la décision assume.** Quatre types sur sept n'ont aucune instance nulle part. `NON-002` conteste cette prolifération, et l'argument le plus fort contre elle est le compte : trente types définis, dix-neuf sans aucune instance.

## Objections ouvertes

`NON-002`, bloquante, sur le coût du modèle et la prolifération des types.

`NON-011`, sur les types employés sans définition, dont `CMP` est le cas le plus net.

`NON-018`, bloquante, sur la frontière entre spécification et implémentation.

## Relations

- `derive-de` [ANL-001](../analyses/ANL-001-observation-corpus-repos-et-pratiques/index.md)
- `specifie` [RES-019](../ressources/RES-019-adr.md)
- `reference` [ADR-005](ADR-005-regroupement-fonctionnel-des-ressources.md)
- `reference` [ADR-006](ADR-006-separation-specification-implementation.md)
