# PLN-007 - Analyse du setup et de l'installation d'un CLI de référence

**Statut : exécuté**

## Intention

Éclairer l'intention de session (« fournir un CLI installable pour un utilisateur ») en analysant, sur un existant matériel de référence, comment le setup et surtout l'installation d'un CLI sont réalisés. Le corpus de référence est le script `setup.sh` du dépôt `ticket-driven-ai`, qui installe le CLI `tda`. Objectif : décrire ses fonctionnalités de setup, en particulier le mécanisme d'installation, pour éclairer la conception de l'installation de `clia`.

## Contexte

Demande de la tâche 1 de `session.md`. Contexte de session : les tests d'installation sont actuellement fragmentés et ne se cumulent pas ; l'analyse fixe un point de référence documenté. Travail en **premier jet** : lecture seule sur un dépôt tiers, aucune modification hors de ce dépôt. Le livrable est une **analyse de corpus** (`skl-012`, `ADR-001`), pas une recherche de fondation.

## Spécification du livrable

- **ANL-2026-07-10-setup-installation** - `.dev/analyses/ANL-2026-07-10-setup-installation.md` : analyse descriptive et critique de `setup.sh` (dépôt `ticket-driven-ai`), centrée sur l'installation, produite par `skl-012`. Périmètre : `setup.sh` et le rôle de `bin/tda`. Référence : aucune formellement fournie par la tâche ; la synthèse orientera les constats vers l'installation de `clia`.

## Plan proposé

### 1. Cadrer le périmètre
Racine du corpus : `../../noumanity-dev/ticket-driven-ai`. Corpus pertinent : `setup.sh` (script d'installation) et `bin/tda` (artefact installé). Bruit exclu : `.git/`, `skills/`, `doc/`, `.dev/`, `BRAINDUMP*`.

### 2. Inventorier et décrire les fonctionnalités de setup
Dispatch des sous-commandes/options (`-h`, `--help`, `--version`, `--check`, `--uninstall`, install par défaut), utilitaires de journalisation, aide courte/longue.

### 3. Décrire le mécanisme d'installation (focus)
Modèle « dev + permanent + local » : ajout d'un bloc `TDA_HOME`/`PATH` dans `~/.bashrc`, idempotence par marqueur, prérequis (`bin/tda`), activation (`source ~/.bashrc`), désinstallation.

### 4. Constats critiques
Robustesse (`set -euo pipefail`, `readonly`, tmpfile+mv, confirmation), ergonomie, et fragilités concrètes localisées (idempotence sur déplacement du dépôt, awk de désinstallation, shell unique bash, incohérence de commande `install`/`init` entre `setup.sh` et `README.md`).

### 5. Synthèse orientée `clia`
Ce qui est réutilisable pour l'installation de `clia`, et les écueils à éviter.

## Objections de l'agent IA

Aucune objection bloquante. Analyse en lecture seule sur un existant matériel ; aucun risque d'effet de bord. Point de vigilance non bloquant : la tâche ne fournit pas de référence formelle (ex. `SPEC-001`/`REQ-001`) ; l'analyse reste donc descriptive et n'opère pas de confrontation normée. Une confrontation à `SPEC-001` pourrait faire l'objet d'une tâche dédiée si l'humain le souhaite.

## Note sur les objections humaines

Conformément à la gouvernance, les objections de l'humain sur ce plan ne sont pas consignées ici mais dans `.dev/session.md`.
