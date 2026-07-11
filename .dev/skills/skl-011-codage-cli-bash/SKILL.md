---
name: skl-011-codage-cli-bash
description: >-
  Coder un CLI bash conforme à la convention du dépôt à partir d'un ADR, d'une spécification et de
  requis. À utiliser quand une tâche demande d'implémenter un script ou un outil bash respectant
  ADR-002, SPEC-001 et REQ-001.
---

# Skill - Codage d'un CLI bash

> Ce skill encadre l'écriture du code d'un CLI bash conforme à la convention du dépôt. Il part des livrables amont (décision `ADR-002`, spécification `SPEC-001`, requis `REQ-001`) et produit un script exécutable robuste, cohérent avec les conventions POSIX/GNU/clig.dev retenues (voir `FND-2026-07-10-conventions-cli`).

## Quand l'utiliser

Quand une tâche demande d'implémenter ou de refondre un CLI bash. Ne pas utiliser pour définir la convention elle-même (voir `ADR-002`, `SPEC-001`, `REQ-001`), ni pour un outil dans un autre langage. Suppose que la spécification et les requis du CLI cible existent (ou sont assez simples pour référencer directement SPEC-001).

## Processus

1. Rassembler les entrées : `ADR-002`, `SPEC-001`, `REQ-001`, et la spécification propre à l'outil si elle existe.
2. Partir du squelette de référence de `SPEC-001` (shebang, `set -euo pipefail`, résolution de racine, helpers de flux, `trap`, dispatch).
3. Implémenter le dispatch : `--help/-h` et `--version` d'abord, puis les sous-commandes par `case`, la branche par défaut renvoyant une erreur d'usage (exit 2).
4. Pour chaque sous-commande : sortie utile sur stdout, diagnostics sur stderr via les helpers, codes de sortie conformes (0/1/2 ou codes documentés).
5. Appliquer les garde-fous bash : quoting systématique, `${var:-defaut}` pour les variables optionnelles, `trap` de nettoyage des fichiers temporaires, aucune dépendance non vérifiée (tester par `command -v`).
6. Rédiger l'aide (usage) en tête de fichier, réutilisée par `_usage` ; documenter chaque sous-commande.
7. Vérifier la conformité aux requis (`REQ-001`) : dérouler la table de vérification ; corriger les écarts.
8. Rendre le fichier exécutable et, si l'outil est destiné au PATH, le nommer sans extension.

## Critères de qualité

- Le script passe les vérifications de `REQ-001` (aide, version, stderr/stdout, codes, robustesse).
- `set -euo pipefail` présent ; les cas d'échec attendu sont gérés explicitement (pas d'arrêt intempestif).
- Aucune variable non quotée ; racine résolue via `BASH_SOURCE`.
- stdout ne contient que des données ; tous les diagnostics sur stderr.
- L'aide est présente, à jour, et cohérente avec le comportement réel.
- Idéalement vérifié par `shellcheck` sans avertissement bloquant.
- Ressource de harnais : aucune information de domaine métier ni spécifique au repo (généricité inter-dépôts, voir `ADR-005`).
- Markdown strict pour toute doc associée (voir `CLAUDE.md`).

## Structure du livrable

- **Emplacement** : le script lui-même (entrypoint sans extension pour le PATH, ou `<nom>.sh` pour un script interne), à l'endroit prévu par l'outil (`scripts/`, `bin/`, etc.).

Le code suit le squelette de référence de `SPEC-001`. Le livrable n'est pas un document markdown mais un script exécutable ; sa conformité se mesure contre `REQ-001` et sa forme contre `SPEC-001`.
