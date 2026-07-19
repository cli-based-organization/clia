---
name: skl-015-architecture-harnais
description: >-
  Produire ou faire évoluer le fichier de harnais `ARCHITECTURE.md` (racine du dépôt) : une
  description d'architecture légère, stable et versionnée donnant la carte de haut niveau du
  système (problème, composants, acteurs, flux, invariants, cartographie du code). À utiliser
  quand la structure du système doit être décrite ou mise à jour. Type défini dans `ADR-009`.
---

# Skill - Rédaction du harnais ARCHITECTURE.md

> `ARCHITECTURE.md` est le fichier de harnais qui donne la **carte de haut niveau** du système à un nouveau venu, humain ou agent IA. Il décrit la **structure** (le *quoi*), en complément d'`INTENTION.md` (le pourquoi), de la gouvernance/orchestration (`CONSTITUTION.md`) et du mode opératoire (`CLAUDE.md`). Il renvoie aux ADR pour le *pourquoi* des décisions et aux PDC pour les invariants, sans les dupliquer. Court et stable. Type défini dans `ADR-009`.

## Quand l'utiliser

Quand la structure du système doit être **décrite pour la première fois** ou **mise à jour** parce qu'un changement durable a modifié les composants, leurs relations ou le flux principal. Ne pas utiliser pour :
- une décision d'architecture ponctuelle (`skl-006-adr`) ;
- un invariant transverse (`skl-014-principe-de-conception`) ;
- l'intention globale (`INTENTION.md`, édition humaine) ni le mode opératoire (`skl-004-harnais` pour `CLAUDE.md`).

## Processus

1. Lire l'intention (`INTENTION.md`), l'architecture décidée (`ADR-007` et ADR liés) et les invariants (`.dev/principes/PDC-*`) : `ARCHITECTURE.md` **consolide et cartographie**, il ne décide pas.
2. Rédiger la **vue d'oiseau** d'abord : le problème que le système résout, avant toute solution.
3. Décrire les **composants** (niveau conteneur, vocabulaire C4 utile) : les grands blocs, leurs responsabilités et leurs relations. Rester au niveau durable.
4. Décrire les **acteurs** et leur répartition de rôles, et le **flux principal** (scénario nominal de bout en bout).
5. Fournir une **cartographie du code** : « où est la chose qui fait X ? » vers les fichiers/répertoires clés (sans synchroniser ligne à ligne).
6. Renvoyer aux **invariants** (PDC) et aux **décisions** (ADR) plutôt que de les recopier ; nommer explicitement ce qui est **hors périmètre**.
7. Fixer un **statut** et une **version** ; bumper atomiquement le membre et l'ensemble `harness-files` dans `.dev/ressources.yaml` (`ADR-004`, `PDC-009`).
8. Vérifier la **stabilité** : ne conserver que ce qui change peu ; déplacer les détails volatils hors du document.

## Critères de qualité

- Le document commence par le **problème résolu** (vue d'oiseau), pas par la solution.
- Les composants, acteurs et le flux principal sont décrits au **niveau durable** (pas de détail d'implémentation volatil).
- Une **cartographie « où est X ? »** oriente vers les fichiers/répertoires clés.
- Les invariants (PDC) et décisions (ADR) sont **référencés**, non dupliqués (`PDC-006`).
- Le périmètre et les **frontières** (ce qui n'en fait pas partie) sont explicites.
- Le document est **court et stable** ; il ne prétend pas être synchronisé ligne à ligne avec le code.
- Statut et version présents ; versionnage atomique effectué.
- Ressource de harnais : aucune information de domaine métier (généricité inter-dépôts, `ADR-005`, `PDC-003`).
- Markdown strict (voir `CLAUDE.md`).

## Structure du livrable

- **Emplacement** : `ARCHITECTURE.md` (racine du dépôt, nom fixe)

```markdown
# ARCHITECTURE

- **Statut** : <proposé|accepté>
- **Version** : <X.Y.Z>
- **Date** : <AAAA-MM-JJ>

> Carte de haut niveau du système. Court et stable : ne décrit que le durable, ne se synchronise pas ligne à ligne avec le code (voir `ADR-009`). Renvoie aux ADR (décisions) et aux PDC (invariants).

## Problème résolu (vue d'oiseau)

<Ce que le système résout, avant toute solution.>

## Vue d'ensemble des composants

<Les grands blocs, leurs responsabilités, leurs relations. Vocabulaire C4 utile (conteneurs/composants).>

## Acteurs et rôles

<Qui agit, avec quelles responsabilités et frontières.>

## Flux principal

<Le scénario nominal de bout en bout.>

## Cartographie du code (« où est la chose qui fait X ? »)

<Renvois vers les fichiers/répertoires clés.>

## Invariants et décisions

<Renvois aux PDC (invariants) et aux ADR (décisions), sans duplication.>

## Hors périmètre

<Ce qui ne fait pas partie de cette architecture.>

## Références

<ADR, PDC, fondations pertinents.>
```
