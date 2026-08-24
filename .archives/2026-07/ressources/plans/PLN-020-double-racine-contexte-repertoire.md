---
type: plan
version: 0.1.0
title: "Remédiation de BUG-009 : séparer la racine de l'outil de la racine du dépôt de travail"
status: proposé
---

# PLN-020 - Remédiation de BUG-009 (double racine et contexte-répertoire)

## Intention

Faire que `clia` opère sur le dépôt **où il est lancé**, et non sur le dépôt qui contient son code. La configuration résolue à l'exécution (`repo-root`, `dev-dir`, `logs-dir`, `sessions-dir`, `session-file`, `ressources`, `version-file`) doit dépendre du répertoire courant ; seules la racine de l'outil et les gabarits restent rattachés à l'arbre d'installation.

Cette intention sert l'objectif de session : une version 0.1.0 stable, présentable, dont le comportement est correct dans les principaux cas d'usage. Un outil installé une fois et utilisable partout qui agit toujours sur son propre dépôt n'est pas présentable.

## Contexte

- Bogue rapporté par l'humain à la tâche 1 de la session du 2026-07-31, diagnostiqué dans [`BUG-009`](../bugs/BUG-009-contexte-repertoire-ignore-par-clia.md).
- La directive de la tâche est explicite : ouvrir le bogue, expliquer, proposer un plan, **ne pas implémenter**. Le présent plan est donc `proposé` et n'autorise aucune exécution.
- La décision de fond existe déjà ([`ADR-010`](../adr/ADR-010-clia-setup-commandes-modes-installation.md) D4, D6, D9) : elle n'a été implémentée que dans le groupe `setup`. Le travail n'est pas d'inventer une conception mais de porter une décision existante au reste de l'outil, et de purger la contradiction laissée dans les documents normatifs.
- Le modèle de référence est déjà écrit et éprouvé dans `setup.sh` (racine) : résolution `-C` puis `git rev-parse --show-toplevel` puis `pwd`, et `_setup_target_state` pour les quatre états d'une cible. La remédiation reprend ce modèle plutôt que d'en produire un second ([`PDC-005`](../principes/PDC-005-separation-des-preoccupations.md)).
- Deux bogues voisins restent ouverts et ne sont **pas** traités ici : [`BUG-007`](../bugs/BUG-007-resource-sh-modele-abroge.md) (modèle de ressources abrogé dans `resource.sh`) et l'abolition du manifeste `.dev/ressources.yaml`. Le présent plan touche les mêmes fichiers ; l'ordre d'exécution des deux remédiations est une question ouverte (objection 3).

## Spécification du livrable

Livrables attendus, par segment :

1. une décision d'architecture tranchant la double racine, sa résolution et son comportement de repli (amendement d'`ADR-010` ou ADR nouveau, selon la résolution de l'objection 2) ;
2. les documents normatifs mis en cohérence : `REQ-002`, `SPEC-002`, et la précision de portée sur `REQ-001-NF3` / `SPEC-001` ;
3. le code corrigé : `src/bin/clia`, `src/lib/setup.sh`, et les modules consommateurs ; `src/clia.doc.yaml` mis à jour ;
4. les tests couvrant les six critères de vérification de `BUG-009`, dans `test/test_clia.sh` ;
5. `ARCHITECTURE.md` et `BUG-009` mis à jour, et le log de tâche.

## Plan proposé

### Segment 1 : décider

#### 1.1 Trancher la double racine (ADR)

Porter dans une décision d'architecture, avec son motif et ses conséquences :

- la distinction nommée entre **racine de l'outil** (résolue par `BASH_SOURCE`) et **racine du dépôt de travail** (résolue depuis le répertoire courant) ;
- l'ordre de résolution du dépôt de travail : option explicite, puis racine du dépôt versionné contenant le répertoire courant, puis répertoire courant, identique à `ADR-010` D4 ;
- le comportement de chaque commande selon l'état reconnu du dépôt courant (`ADR-010` D9), en particulier le refus et l'orientation hors dépôt équipé ;
- la provenance des gabarits (objection 1) ;
- l'existence ou non d'une option globale de désignation du dépôt de travail (`-C` global), aujourd'hui propre au groupe `setup`.

Forme : amendement d'`ADR-010` (D4 et D9 étendus explicitement à toutes les commandes) ou ADR nouveau. À trancher par l'humain (objection 2).

#### 1.2 Écrire le cas d'usage manquant

Produire le parcours du travail courant dans un dépôt équipé (`USE-006`), aujourd'hui absent du corpus : c'est le parcours que le bogue traverse, et son absence explique qu'aucun test ne l'exerce. Acteur : [`ACT-001`](../acteurs/ACT-001-operateur-du-depot.md).

**BREAKPOINT 1.** Arrêt après le segment 1. L'humain vérifie que la décision correspond à son intention, notamment sur les deux objections ouvertes, avant que les exigences et le code n'en dépendent.

### Segment 2 : mettre les documents normatifs en cohérence

#### 2.1 `REQ-002`

- Reformuler `NF2` : la robustesse visée est la localisation du **script** ; elle n'a jamais eu vocation à fixer la racine du dépôt de travail. Supprimer l'ambiguïté qui rend `NF2` et `F15` contradictoires.
- Porter `F15` et `F16` en exigences de portée générale (toutes les commandes), et non plus sous le seul groupe `setup`.
- Ajouter l'exigence de refus explicite et d'orientation hors dépôt équipé, et l'exigence que `--config` distingue les deux racines.

#### 2.2 `SPEC-002`

- Section « Comportement » (l.19) et « Contraintes et garanties » (l.119) : remplacer l'affirmation héritée par l'énoncé des deux racines.
- Remonter la règle de résolution et le tableau de reconnaissance d'état hors de la section `setup`, où ils sont aujourd'hui confinés (l.84-93), vers une section transverse.
- Étendre la ligne `--config` de la table (l.39) et la table de traçabilité (l.163).

#### 2.3 `REQ-001` / `SPEC-001`

Préciser que `NF3` porte sur la résolution robuste de la racine **du script**, et ajouter la mise en garde : pour un outil installé une fois et utilisé partout, la racine du script ne désigne pas le dépôt de travail. La convention reste inchangée sur le fond ; seule sa portée est explicitée, ce qui évite que le prochain CLI reproduise la confusion.

#### 2.4 `src/clia.doc.yaml`

Mettre à jour la description de `--config` et, si l'ADR le retient, documenter l'option globale de désignation du dépôt. C'est la seule source à éditer pour la documentation (`PDC-006`).

### Segment 3 : corriger le code

#### 3.1 Scinder l'ancrage dans `src/bin/clia`

- Introduire `CLIA_ROOT` (racine de l'outil, via `BASH_SOURCE`) et réserver `REPO_ROOT` au dépôt de travail résolu.
- Implémenter la résolution du dépôt de travail et la reconnaissance de son état en réutilisant le modèle de `setup.sh` (`-C`, `git rev-parse --show-toplevel`, `pwd` ; quatre états). Extraire ce mécanisme dans un module partagé plutôt que le dupliquer.
- Ancrer `DOC_FILE` et l'extension d'amorçage sur `CLIA_ROOT`, et les sept chemins de travail sur `REPO_ROOT`.
- Traiter l'option globale de désignation du dépôt si l'ADR la retient, avant le dispatch (`REQ-001-F10`).

#### 3.2 Reprendre `src/lib/setup.sh`

Substituer `CLIA_ROOT` à `REPO_ROOT` dans `_setup_ext` (`src/lib/setup.sh:14`), qui lit aujourd'hui la variable au sens « arbre de l'outil ». Sans cette reprise, la redéfinition de `REPO_ROOT` fait chercher l'extension dans le dépôt de travail.

#### 3.3 Poser les gardes dans les modules consommateurs

Dans `session.sh`, `resource.sh` et `version.sh`, refuser avec un diagnostic d'orientation et un code de retour non nul lorsque le dépôt courant n'est pas équipé, plutôt que d'opérer sur des chemins inexistants ou de retomber sur l'arbre de l'outil. Ancrer `TEMPLATE_FILE` selon la résolution de l'objection 1.

#### 3.4 Étendre `cmd_config`

Rapporter les deux racines, l'état reconnu du dépôt courant et l'origine de la résolution (option explicite, dépôt versionné, ou répertoire courant). `--config` devient l'outil de diagnostic de ce bogue et de ses éventuelles récidives.

### Segment 4 : vérifier

#### 4.1 Tests

Ajouter à `test/test_clia.sh`, en bac à sable, les six critères de vérification de `BUG-009` : dépôt équipé tiers (configuration, `ses status`, `res ls`), dépôt non équipé, hors de tout dépôt, arbre de l'outil (non-régression), et non-régression de `test/test_setup.sh`.

#### 4.2 Clôture documentaire

Mettre à jour `ARCHITECTURE.md` (cartographie : les deux racines), passer `BUG-009` à `résolu` avec sa section « Solution appliquée » renseignée des fichiers réellement modifiés, et produire le log de tâche (`skl-008`).

## Objections de l'agent IA

- **Objection 1 (provenance des gabarits)** : la tâche demande que les gabarits restent rattachés à l'arbre de l'outil. Or `clia setup init` **copie** `.dev/templates/` dans chaque dépôt équipé (`ADR-010` D6), précisément pour que la cible soit autonome. Si ce plan est exécuté tel quel, un dépôt équipé contiendra un gabarit de session que `clia` n'utilisera jamais : toute personnalisation locale du gabarit sera silencieusement sans effet, et le dépôt cessera d'être autonome pour ses propres sessions (il se casse si l'arbre de l'outil est déplacé). Trois issues possibles, à trancher par l'humain : (a) gabarit toujours pris dans l'outil, et `setup init` cesse de le copier, ce qui amende `ADR-010` D6 ; (b) gabarit pris dans le dépôt de travail, avec repli sur l'outil s'il est absent, ce qui préserve l'autonomie et la personnalisation mais contredit la formulation de la tâche ; (c) préséance inverse, gabarit de l'outil sauf si le dépôt en déclare un. Aucune ne peut être choisie par l'agent : elle engage le modèle de distribution.

- **Objection 2 (comportement hors dépôt équipé)** : la tâche décrit le comportement attendu « lorsque l'exécution a lieu dans un repo clia-valide » et laisse ouvert le cas contraire. Si ce plan est exécuté sans trancher, l'implémentation choisira seule entre refuser et retomber sur l'arbre de l'outil. Or le repli silencieux est exactement le défaut rapporté, et il est dangereux pour les commandes mutantes : `ses open`, `ses close` et `release` muteraient un dépôt que l'opérateur n'a pas désigné. L'agent recommande le refus avec orientation (`ADR-010` D9, `REQ-002-F16`), mais la question engage l'ergonomie de l'outil et revient à l'humain. Elle englobe le cas particulier du dépôt **équipé sans marque**, dont `ADR-010` D9 dit qu'il n'est « ni refusé ni accepté en silence ».

- **Objection 3 (collision avec BUG-007)** : `resource.sh` et `version.sh` sont modifiés par ce plan et par la remédiation de `BUG-007`, qui reste ouverte et qui reconstruit la table des types et la lecture des états. Si les deux remédiations sont menées indépendamment, l'une réécrira le travail de l'autre. L'agent propose de traiter `BUG-009` d'abord (il conditionne le chemin d'accès aux fichiers que `BUG-007` doit lire correctement), mais l'ordonnancement est une décision de session.

- **Objection 4 (portée du refactor pour une version 0.1.0)** : le segment 3 touche le point d'ancrage dont dépend l'ensemble de l'outil, et le segment 2 amende quatre documents normatifs. Si ce plan est exécuté sans le filet du segment 4, une régression sur les transitions de session ne serait détectée qu'à l'usage, sur des fichiers en édition humaine uniquement. L'agent objecte à toute exécution partielle qui livrerait le segment 3 sans le segment 4 ; les tests ne sont pas une étape facultative de fin de plan.

## Note sur les objections humaines

Les objections de l'humain sur ce plan ne sont pas consignées ici mais dans `.dev/session.md`.
