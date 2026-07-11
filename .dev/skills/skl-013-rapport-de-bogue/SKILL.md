---
name: skl-013-rapport-de-bogue
description: >-
  Produire et faire évoluer une ressource BUG (`.dev/bugs/BUG-<SEQ>-<SLUG>.md`) : un document
  vivant qui consigne un bogue de son rapport à sa résolution (symptôme, diagnostic, solution,
  vérification). À utiliser quand un comportement incorrect de l'agent ou du système doit être
  tracé, diagnostiqué et corrigé de façon structurée.
---

# Skill - Rapport de bogue

> Une ressource BUG est un document vivant qui suit un bogue sur tout son cycle de vie : le rapport (attendu vs observé), le diagnostic (cause racine), la solution appliquée (correctif, fichiers touchés) et la vérification. Elle est distincte du log de tâche (`skl-008`, trace immuable d'une intervention) et du plan (`skl-003`, cadrage d'une intervention). Type défini dans `ADR-003-gestion-des-bogues`.

## Quand l'utiliser

Quand un comportement incorrect est constaté (par l'humain via `session.md`, ou par l'agent) et doit être tracé, diagnostiqué et résolu. Utiliser aussi pour **faire évoluer** un BUG existant : le passer de `ouvert` à `diagnostiqué`, `résolu`, puis `fermé`. Ne pas utiliser pour journaliser une tâche (`skl-008`) ni pour cadrer une intervention complexe (`skl-003`).

## Processus

1. Créer ou rouvrir le fichier `.dev/bugs/BUG-<SEQ>-<SLUG>.md` (séquence globale incrémentale).
2. **Rapport** : décrire le symptôme, le comportement attendu et le comportement observé, la tâche ou le contexte où le bogue est apparu.
3. **Diagnostic** : analyser la cause racine (pas seulement le symptôme) ; distinguer cause immédiate et cause systémique (ex. lacune du harnais).
4. **Solution appliquée** : décrire le correctif, lister les fichiers modifiés (chemins), et si le harnais est en cause, l'amendement apporté.
5. **Vérification** : indiquer comment on sait que le bogue est résolu (test, observation reproductible).
6. Mettre à jour le **statut** (`ouvert -> diagnostiqué -> résolu -> fermé`) et l'**historique** (le BUG est vivant : consigner chaque évolution).
7. Rappeler que la tâche qui traite le bogue produit aussi un log (`skl-008`).

## Critères de qualité

- Le rapport distingue clairement attendu et observé.
- Le diagnostic identifie une cause racine, pas seulement le symptôme.
- La solution liste les fichiers réellement modifiés (chemins vérifiables).
- La vérification est concrète et reproductible.
- Le statut reflète l'état réel ; l'historique trace les évolutions (document vivant).
- Ressource de harnais : aucune information de domaine métier ni spécifique au repo (généricité inter-dépôts, voir `ADR-005`).
- Markdown strict (voir `CLAUDE.md`).

## Structure du livrable

- **Emplacement** : `.dev/bugs/BUG-<SEQ>-<SLUG>.md`

```markdown
# BUG-<SEQ> - <Titre>

- **Statut** : <ouvert|diagnostiqué|résolu|fermé>
- **Version** : <X.Y.Z>
- **Date de rapport** : <AAAA-MM-JJ>
- **Origine** : <session.md tâche N | agent>
- **Tâche liée** : <référence de tâche/log>

## Rapport

<Symptôme. Comportement attendu vs comportement observé. Contexte d'apparition.>

## Diagnostic

<Cause racine ; cause immédiate et cause systémique le cas échéant.>

## Solution appliquée

<Correctif ; fichiers modifiés (chemins) ; amendements de harnais si applicable.>

## Vérification

<Comment on constate que le bogue est résolu (test, observation).>

## Historique

- <AAAA-MM-JJ> vX.Y.Z : <évolution du document>
```
