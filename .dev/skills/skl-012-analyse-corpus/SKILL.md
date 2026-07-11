---
name: skl-012-analyse-corpus
description: >-
  Produire une analyse (`.dev/analyses/ANL-<SEQ>-<SLUG>.md`) : examen structuré d'un corpus de
  documents ou de fichiers présents sur un système de fichiers, produisant un état des lieux
  descriptif et critique. À utiliser quand une tâche demande d'inventorier et d'évaluer un
  existant matériel (scripts, dépôts, documents), distinct d'une recherche de fondation théorique.
---

# Skill - Analyse d'un corpus sur système de fichiers

> Une analyse est l'examen structuré d'un corpus concret de fichiers présents sur un système de fichiers : inventaire, catégorisation, évaluation, confrontation à une référence (fondation ou convention), et synthèse des écarts et recommandations. Elle porte sur un existant matériel, pas sur la littérature (voir `skl-002` pour la recherche de fondation théorique). Type défini dans `ADR-001-type-livrable-analyse`.

## Quand l'utiliser

Quand une tâche demande d'analyser un ensemble de documents ou de fichiers réels et localisables (ex. tous les scripts bash d'un ensemble de dépôts, un corpus de textes, une arborescence). Ne pas utiliser pour une recherche théorique fondée sur la littérature (`skl-002`), ni pour une décision d'architecture (`skl-006`), ni pour un plan (`skl-003`).

## Processus

1. Cadrer le périmètre : racine(s) du corpus, filtres d'inclusion et d'exclusion (ex. exclure `.git/`, `node_modules/`, dépendances vendored), critères de sélection.
2. Inventorier : parcourir le corpus, produire une liste structurée (chemin, appartenance, rôle apparent, taille/type si utile). Distinguer le corpus first-party du bruit.
3. Définir la grille d'analyse : dimensions évaluées (ex. structure, conventions, robustesse, ergonomie), explicites et reproductibles.
4. Analyser : appliquer la grille au corpus ; relever les régularités, les bonnes pratiques, les anti-patterns, les incohérences.
5. Confronter à une référence si fournie (fondation, convention, standard) : mesurer les écarts.
6. Synthétiser : ce qu'il faut retenir, recommandations actionnables, priorités.
7. Dater et noter la portée (quel corpus, à quelle date, quelle couverture) et la péremption (le corpus évolue).

## Critères de qualité

- Le périmètre (racines, filtres) est explicite et le corpus analysé est reproductible.
- L'inventaire distingue le corpus pertinent du bruit (vendored, dépendances, exemples tiers).
- La grille d'analyse est explicite, pas implicite.
- Chaque constat s'appuie sur des exemples concrets et localisables (chemins).
- Si une référence est fournie, les écarts sont mesurés, pas seulement décrits.
- La synthèse est actionnable et priorisée.
- Daté, avec portée et couverture annoncées.
- Ressource de harnais : aucune information de domaine métier ni spécifique au repo (généricité inter-dépôts, voir `ADR-005`).
- Markdown strict (voir `CLAUDE.md`).

## Structure du livrable

- **Emplacement** : `.dev/analyses/ANL-<SEQ>-<SLUG>.md`

```markdown
# ANL-<SEQ> - <Titre>

- **Date** : <AAAA-MM-JJ>
- **Périmètre** : <racines, filtres d'inclusion/exclusion>
- **Référence** : <fondation/convention/standard confronté, ou "aucune">

## Objet

<Ce qui est analysé et pourquoi, en une à trois phrases.>

## Périmètre et méthode

<Racines parcourues, filtres, grille d'analyse (dimensions évaluées).>

## Inventaire

<Liste structurée du corpus pertinent ; mention du bruit exclu.>

## Constats

<Régularités, bonnes pratiques, anti-patterns, incohérences, avec exemples (chemins).>

## Confrontation à la référence
<uniquement si une référence est fournie ; écarts mesurés>

## Synthèse et recommandations

<Ce qu'il faut retenir ; recommandations actionnables et priorisées.>

## Portée et péremption

<Couverture réelle, limites, rythme d'obsolescence.>
```
