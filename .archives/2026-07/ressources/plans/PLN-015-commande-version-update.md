---
type: plan
version: 0.1.0
title: "Commande `clia release (major|minor|patch)`"
status: exécuté
---

# PLN-015 - Commande `clia release (major|minor|patch)`


## Changelog

- **Exécution (2026-07-21, tâche 30)** : commande `clia release (major|minor|patch)` implémentée. `cmd_release` ajouté à `src/lib/version.sh` (bump semver de `version.yaml`, réécriture atomique, `--dry-run`, codes 0/1/2, aucune opération git) ; dispatch `release` dans `src/bin/clia` ; entrée dans `src/clia.doc.yaml` (découvrable, `clia -h` et `clia release -h`) ; `SPEC-002` (0.2.0) et `REQ-002` (0.2.0, `REQ-002-F-release`) amendés ; premier test du dépôt `test/test_clia.sh` (8 cas, verts). Statut approuvé -> exécuté.

- **Révision 2 (2026-07-21)** : incorporation de la **tâche 28** de `session.md` (« [résolution des objections] »). Les cinq objections sont résolues. Décisions : (1) cible confirmée `version.yaml` (métier) ; (2) la commande n'est **plus** un groupe `version` avec sous-commande `update`, mais une **commande de premier niveau `clia release (major|minor|patch)`**, ce qui lève la confusion avec l'option globale de lecture `--version` ; (3) `ressources.yaml` est aboli (cohérent avec `PLN-014`) et la commande cible `version.yaml` ; (4) l'interdiction git vise **l'agent IA**, pas `clia` (déterministe, opéré par l'humain) ni le canal horizon IA, donc la contrainte « ne jamais toucher git » du plan initial est corrigée ; (5) amender tous les documents de conception nécessaires. Statut passé à **approuvé**. Le nom de fichier du plan est conservé (`...-commande-version-update.md`) pour ne pas orpheliner la référence du log de la tâche 27, trace immuable.
- **Révision 1 (2026-07-21)** : création (tâche 27), commande initialement nommée `clia version update`, statut objection.

## Intention

Ajouter à `clia` une commande de passage à une nouvelle version, demandée par la tâche 27 de `session.md` et précisée par la tâche 28 :

```
clia release (major|minor|patch)
```

Elle incrémente la version métier (`version.yaml`) selon la règle semver choisie (`major`, `minor` ou `patch`), de façon déterministe et opérée par l'humain, en cohérence avec le rôle de `clia` (gardien déterministe de l'intégrité, `CONSTITUTION.md`).

## Contexte

- **État actuel de `clia`** : `--version` est une **option globale de lecture** qui affiche la version métier (`version.yaml`) et, avec `--long`, les versions des ensembles vivants (`.dev/ressources.yaml`). Il n'existe pas encore de commande de mutation de version. Le dispatch (`src/bin/clia`) valide chaque commande contre la source documentaire `src/clia.doc.yaml` ; les commandes vivent dans `src/lib/*.sh` (`version.sh` porte `cmd_version`). Aucun test n'est présent dans le dépôt.
- **Conventions applicables** : `ADR-002`, `SPEC-001`/`REQ-001`, `SPEC-002`/`REQ-002`, `skl-011`. Toute commande doit être documentée dans `clia.doc.yaml` (source unique) pour rester découvrable et uniforme (`PDC-007`).
- **Deux domaines de version** (`ADR-007`) : version **métier** (`version.yaml`) et versions du **système d'augmentation** (`.dev/ressources.yaml`). `PLN-014` (approuvé) **abolit `ressources.yaml`** et porte la version de chaque ressource en frontmatter, sans toucher `version.yaml`. `clia release`, qui cible `version.yaml`, est donc **indépendante** de `PLN-014`.
- **Contrainte git (précisée par la tâche 28)** : l'interdiction d'agir sur git vise **l'agent IA**, pas `clia`. `clia` étant déterministe et **opéré par l'humain**, une éventuelle étape git de `clia release` serait l'humain agissant via son outil, ce qui est permis (même logique que la mutation des fichiers de session par `clia`). L'agent IA, lui, n'exécute jamais git.
- **Autres contraintes** : généricité du harnais (`ADR-005`), déterminisme (`PDC-001`), source documentaire unique (`PDC-006`, `PDC-007`).

## Spécification du livrable

Le livrable **des tâches 27 et 28** est ce plan (approuvé). L'**exécution** (implémentation) est une tâche distincte (comme tâche 3 après tâche 2). Les livrables d'exécution seront : mise à jour des documents de conception (`SPEC-002`, `REQ-002`, et `ADR` si nécessaire), entrée dans `src/clia.doc.yaml`, implémentation dans `src/lib/version.sh` et le dispatch de `src/bin/clia`, et un test. Aucun code n'est produit par le présent plan.

## Plan proposé

### 1. Conception : périmètre et sémantique (décidés)

- **Commande** : `clia release (major|minor|patch)`, commande de **premier niveau** (pas un groupe `version`). L'option globale `--version` (lecture) est conservée telle quelle.
- **Cible** : `version.yaml` (version métier), lue par `--version`.
- **Sémantique** : lecture de la version courante (`X.Y.Z`), incrément selon l'argument (`major` -> `X+1.0.0`, `minor` -> `X.Y+1.0`, `patch` -> `X.Y.Z+1`), réécriture déterministe du champ `version:` de `version.yaml`. Sortie stdout : nouvelle version (ou plan si `--dry-run`). Argument obligatoire dans `{major, minor, patch}` sinon erreur d'usage (code 2) ; `version.yaml` absent ou mal formé -> erreur applicative (code 1).
- **Git (optionnel, hors MVP)** : `clia release` pouvant légitimement inclure une étape git (par exemple un tag) puisqu'opéré par l'humain, cette possibilité est **permise** mais non incluse par défaut. Si l'humain la souhaite, elle sera spécifiée explicitement (tag/commit du bump). Par défaut, `release` n'édite que `version.yaml`.

### 2. Amender les documents de conception

Amender `SPEC-002` (interface : nouvelle commande de premier niveau `release`, cible `version.yaml`, sémantique, codes de sortie) et `REQ-002` (requis correspondant). Documenter, le cas échéant, la clarification sur la frontière git agent / `clia` (renvoi à `CONSTITUTION.md`). Respecte l'ordre conception avant implémentation (tâche 2).

### 3. Documentation atomique

Ajouter l'entrée `release` dans `src/clia.doc.yaml` : nom, court, usage `clia release (major|minor|patch)`, long. La commande apparaît alors dans `clia -h` et `clia release -h` (découvrabilité et uniformité, `PDC-007`).

### 4. Implémentation

- Ajouter `cmd_release` dans `src/lib/version.sh` (ou un module dédié) : parse de l'argument, lecture et bump semver, réécriture atomique de `version.yaml` (fichier temporaire puis renommage), respect de `--dry-run` (plan sans écriture) et `--debug`.
- Ajouter le dispatch `release) cmd_release "$@" ;;` dans `src/bin/clia`, validé contre `clia.doc.yaml`.
- Garde-fous `skl-011` : quoting, `set -euo pipefail`, stdout = données, diagnostics sur stderr, codes 0/1/2, dépendances vérifiées. L'agent IA n'exécute aucune commande git lors de l'implémentation ni des tests.

### 5. Test

Test fonctionnel du bump (les trois cas `major|minor|patch` sur une `version.yaml` de fixture) et auto-test de cohérence dispatch/documentation (`skl-011`). Premier test du dépôt : proposer un emplacement (`test/` ou `src/test/`).

## Note de dépendance sur `PLN-014`

`clia release` cible `version.yaml` et est indépendante de `PLN-014`. En revanche, `PLN-014` abolit `ressources.yaml`, ce qui affectera `clia --version --long` et `clia res ls --version` (qui le lisent aujourd'hui) : leur **réconciliation** (lire les versions depuis le frontmatter) est un chantier d'implémentation distinct, à mener lors de l'exécution de `PLN-014` et de la réconciliation de `clia`. Elle ne bloque pas `clia release`.

## Objections de l'agent IA

Aucune objection ouverte actuellement. Les cinq objections des révisions précédentes sont résolues par la tâche 28 de `session.md` :

1. Cible du bump. **Résolue** : `version.yaml` (version métier).
2. Coexistence `--version` / groupe `version` et périmètre. **Résolue** : la commande devient `clia release` de premier niveau ; plus de groupe `version` ; `--version` reste l'unique lecture.
3. Séquencement avec `PLN-014`. **Résolue** : `ressources.yaml` aboli (via `PLN-014`), `clia release` cible `version.yaml` et en est indépendante.
4. Interdiction git. **Résolue** : la contrainte vise l'agent IA, pas `clia` (opéré par l'humain) ni horizon IA ; l'étape git est permise pour `clia release` mais hors MVP par défaut.
5. Portée des documents de conception. **Résolue** : amender tout ce qui doit l'être (`SPEC-002`, `REQ-002`, doc atomique, et `ADR` au besoin).

## Note sur les objections humaines

Les objections et résolutions de l'humain vivent dans `.dev/session.md` (tâches 27, 28), pas dans ce plan.
