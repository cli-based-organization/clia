---
type: adr
id: ADR-014
title: "Adoption des quatre types de la famille implémentation"
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
definition-associee: RES-026
---

# ADR-014 - Adoption des quatre types de la famille implémentation

> Acte l'adoption de Code, Rapport de recherche, Article et Présentation, les quatre types qui portent ce que le système livre effectivement.

## Statut

`propose`. Les quatre types sont définis depuis le 2026-08-10 ; leur adoption n'avait jamais été actée.

Créé par le chantier C de `PLN-002`.

## Contexte

Cette famille porte les livrables qui sortent du système. Trois des quatre types n'ont aucune instance dans ce dépôt, et le corpus en offre les meilleurs cas.

| Type | Instances ici | Meilleur cas du corpus |
|---|---|---|
| Code, `CDE` | `bin/clia`, trois modules, la suite de tests, soit 1 596 lignes de bash | |
| Rapport de recherche, `RPT` | 0 | aucun |
| Article, `ART` | 0 | `jvtrudel/ecrits`, treize fichiers, un article publié sur LinkedIn en novembre 2025 |
| Présentation, `PRS` | 0 | trois dépôts avec chaînes LaTeX, jusqu'à trente-deux sources et onze PDF |

## Décision en une phrase

Quatre types de livrable sont adoptés, et le constat qui les fonde est que le seul dépôt de savoir du corpus qui fonctionne est celui qui est orienté publication.

## Décisions détaillées

### D1 - Code, `CDE`

**Problème résolu.** Traiter le code comme une ressource du système plutôt que comme ce qui échappe au système.

**Assise.** Le type est instancié depuis la tâche 6 : `bin/clia`, trois modules sous `lib/clia/`, et `tests/test_clia.sh`.

**Contrainte particulière.** `ADR-006` sépare strictement la spécification du système de son implémentation. Le type `CDE` est du côté de l'implémentation, et une définition ne doit jamais dépendre de lui.

### D2 - Rapport de recherche, `RPT`

**Problème résolu.** Livrer un résultat de recherche à un destinataire, avec sa méthode et ses limites.

**Assise.** Aucune, ici comme dans le corpus.

**Frontière.** La fondation mobilise le savoir d'autrui pour éclairer une décision interne. Le rapport livre un résultat à un tiers. Les deux se confondent facilement.

### D3 - Article, `ART`

**Problème résolu.** Porter un texte destiné à publication, avec son destinataire, sa date et son lien.

**Assise.** `jvtrudel/ecrits`, treize fichiers dont un article publié sur LinkedIn en novembre 2025, avec son lien de publication.

**Le constat qui fonde ce type.** `ANL-001` relève que c'est le **seul dépôt de savoir du corpus qui fonctionne**, et qu'il fonctionne précisément parce qu'il est orienté publication : le livrable a un destinataire, une date et un lien. Les onze dépôts de technotes morts n'avaient aucun des trois.

C'est l'observation la plus transposable de tout le corpus, et elle vaut au-delà de ce type.

### D4 - Présentation, `PRS`

**Problème résolu.** Porter un support destiné à être présenté, avec sa chaîne de rendu.

**Assise.** Plusieurs cas dans le corpus, tous instructifs : `linux-and-quantum-computers` avec dix-huit sources LaTeX et dix PDF, `noumanity-quantum-roadmap` avec trente-deux sources et onze PDF, `intentional-doers-governance` avec sa chaîne de rendu en Lua.

**Ce que ces cas montrent.** Une présentation est une ressource composite : sources, chaîne de rendu, artefacts produits. `ADR-004` D3 rend cette forme modélisable.

## Conséquences

Les quatre définitions retirent leur rubrique `Statut de ce document` : son contenu est ici.

Le champ `adr` des quatre définitions passe de `ADR-005` à `ADR-014`.

**Ce que la décision retient de `ANL-001`.** Un livrable sans destinataire, sans date et sans lien ne se termine pas. Le constat est mesuré sur onze dépôts morts et un dépôt vivant, et il devrait contraindre les autres familles.

## Objections ouvertes

`NON-002`, bloquante, sur le coût du modèle.

`NON-006`, sur la portée du système : les assets binaires et les PDF générés sont rendus possibles par `ADR-004` D1 sans être modélisés.

`NON-018`, bloquante, sur la frontière entre spécification et implémentation.

## Relations

- `derive-de` [ANL-001](../analyses/ANL-001-observation-corpus-repos-et-pratiques/index.md)
- `specifie` [RES-026](../ressources/RES-026-code.md)
- `reference` [ADR-005](ADR-005-regroupement-fonctionnel-des-ressources.md)
- `reference` [ADR-006](ADR-006-separation-specification-implementation.md)
