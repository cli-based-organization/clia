---
name: skl-002-recherche-de-fondation
description: >-
  Produire un document de fondation (`.dev/fondations/FND-<XYZ>-<slug>.md`) : recherche en profondeur,
  exhaustive et sourcée, sur un sujet théorique ou méthodologique. À utiliser quand une tâche
  demande d'établir une base factuelle réutilisable.
---

# Skill - Recherche de fondation (recherche en profondeur)

> Une synthèse de recherche rigoureuse et sourcée sur un sujet théorique ou méthodologique. Sert de socle factuel réutilisable par d'autres tickets et par un agent IA.

## Quand l'utiliser

Quand la tâche demande d'explorer en profondeur un sujet (état de l'art, panorama, analyse critique) pour produire un document de référence durable, distinct d'un simple artefact de tâche.

Ne pas utiliser pour analyser un corpus concret de fichiers présents sur un système de fichiers (scripts, dépôts, documents) : ce cas relève de `skl-012-analyse-corpus` (livrable de type « analyse », voir `ADR-001-type-livrable-analyse`). La recherche de fondation part de la littérature ; l'analyse part d'un existant matériel.

## Processus

1. Cadrer la question et délimiter le périmètre (dans / hors sujet).
2. Recherche exhaustive multi-sources ; privilégier les sources primaires.
3. Synthèse structurée par thèmes ; comparer, hiérarchiser, trancher les ambiguïtés.
4. Rattacher chaque affirmation factuelle importante à une source.
5. Dater et noter la péremption.
6. Inclure une analyse critique et des recommandations si pertinent.

## Critères de qualité

- Rigueur : chaque fait clé est sourcé.
- Exhaustivité du périmètre annoncé.
- Daté et revalidable.
- Neutre et factuel ; les opinions sont signalées.
- Navigable : sections numérotées.
- Markdown strict (voir CLAUDE.md).

## Structure du livrable

- **Emplacement** : `.dev/fondations/FND-<XYZ>-<slug>.md`.

**Cadre invariant (dans cet ordre)** :

1. En-tête - titre + statut, date, objectif.
2. Note de rigueur - qualité des sources, niveau d'exigence.
3. Cadrage / Thèse - question, périmètre, définitions.
4. Corps (voir menu ci-dessous).
5. Synthèse - ce qu'il faut retenir.
6. Limites - non-couvert et péremption.
7. Sources - obligatoire.

**Menu du corps (choisir selon le sujet)** : historique, revue de littérature, panorama/taxonomie, analyse critique, outils et instrumentation, tendances, comparaison, application au projet.
