---
type: adr
version: 0.1.0
title: "Définition du type de livrable « analyse »"
status: Accepté
date: 2026-07-10
---

# ADR-001 - Définition du type de livrable « analyse »

- **Décideurs** : Jérémy Viau-Trudel (humain), agent IA
- **Sources** : PLN-004 (tâche 9 et 10 de `session.md`)

## Contexte

Le dépôt distingue déjà la **recherche de fondation** (`FND`, `skl-002`) : une recherche théorique large, sourcée, fondée sur la littérature scientifique, à péremption lente. À la tâche 10, l'humain a constaté qu'un besoin distinct existe : analyser un **corpus concret de documents présents sur un système de fichiers** (par exemple l'ensemble des scripts CLI des dépôts locaux) pour en tirer un état des lieux descriptif et critique. Ce besoin n'est pas une recherche de fondation : il ne part pas de la littérature, mais d'un existant matériel, et son résultat se périme au rythme de cet existant.

Sans type dédié, ce livrable serait rangé à tort parmi les fondations, brouillant la définition de ces dernières.

## Décision (résumé)

> On crée un type de livrable **« analyse »** (préfixe `ANL`), distinct de la recherche de fondation : un examen structuré d'un corpus de documents sur système de fichiers, produisant un état des lieux descriptif et critique, confronté le cas échéant à une référence (fondation, convention). Emplacement : `.dev/analyses/ANL-<SEQ>-<SLUG>.md`. Production encadrée par `skl-012-analyse-corpus`.

## Décisions détaillées

### Objet et frontière

- **Décision** : une « analyse » porte sur un corpus **existant et localisable** (fichiers sur disque, dépôts). Elle inventorie, catégorise, évalue, et met en évidence écarts, bonnes pratiques et anti-patterns.
- *Alternatives écartées* :
  - étendre la recherche de fondation (`skl-002`) à ce cas : rejeté, cela dénature la fondation (théorique et littéraire) et rend sa définition ambiguë ;
  - traiter l'analyse comme une simple section d'un plan : rejeté, l'analyse est un livrable réutilisable au-delà d'un plan unique.

### Emplacement et nomenclature

- **Décision** : `.dev/analyses/ANL-<SEQ>-<SLUG>.md`, suivant la nomenclature générale `.dev/<type>/<PREFIX>-<SEQ>-<SLUG>.md`.

### Propriétaire et cycle

- **Décision** : produite par l'agent IA (type « édition par IA uniquement », comme les fondations et les ADR). Datée ; révisable quand le corpus évolue.

## Conséquences

**Positives**
- La recherche de fondation retrouve une définition nette (théorique, littéraire).
- Les états des lieux empiriques disposent d'un réceptacle réutilisable et versionné.
- Le harnais gagne un type explicite, encadré par un skill dédié.

**Négatives / risques**
- Un type de plus à maintenir (harnais, skill).
- Frontière fondation/analyse à surveiller quand un livrable mêle théorie et corpus ; en cas de mélange, scinder en deux livrables.

## Migration / porte de sortie

Si l'usage montrait que « analyse » et « fondation » se recouvrent trop, ce type pourrait être fusionné ou renommé via un ADR ultérieur. Les livrables `ANL-*` existants seraient alors migrés.

## Références

- `PLN-004-recherche-analyse-clis.md`
- `skl-012-analyse-corpus` (skill de production)
- `skl-002-recherche-de-fondation` (type voisin, à distinguer)
