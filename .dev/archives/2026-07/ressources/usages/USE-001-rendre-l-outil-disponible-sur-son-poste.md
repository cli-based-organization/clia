---
type: usage
version: 0.1.1
title: "Rendre l'outil d'augmentation disponible sur son poste"
status: proposé
date: 2026-07-29
acteur-principal: ACT-003
niveau: but-utilisateur
---

# USE-001 - Rendre l'outil d'augmentation disponible sur son poste

## En-tête

- **Portée** : le poste de travail et l'arbre source du système d'augmentation, considérés comme boîte noire.
- **Parties prenantes et intérêts** : [`ACT-004`](../acteurs/ACT-004-mainteneur-du-systeme-augmentation.md), qui veut que l'outil exécuté soit celui de l'arbre source, sans copie divergente ; [`ACT-006`](../acteurs/ACT-006-dependances-externes.md), dont l'absence fait échouer le parcours.
- **Préconditions** : l'acteur dispose de l'arbre source du système d'augmentation sur son poste et d'un accès en écriture à sa propre configuration d'environnement.
- **Garantie de succès** : l'outil d'augmentation est appelable par son nom depuis n'importe quel répertoire, dans toute nouvelle session de travail, et l'exécution mobilise l'arbre source lui-même plutôt qu'une copie.
- **Garantie minimale** : en cas d'échec, la configuration d'environnement de l'acteur est inchangée, et il sait ce qui manque.

## Flux nominal

1. L'acteur demande au système de rendre l'outil disponible sur son poste.
2. Le système vérifie que les dépendances requises sont présentes et que la configuration d'environnement est accessible en écriture.
3. Le système enregistre de façon durable le rattachement entre le nom de l'outil et l'arbre source.
4. Le système indique à l'acteur ce qui a été fait et comment activer le changement dans la session courante.
5. L'acteur constate que l'outil répond depuis un répertoire quelconque.

## Flux alternatifs et d'échec

- **2a. Une dépendance requise est absente** : le système s'arrête avant toute écriture, nomme la dépendance manquante et n'altère rien. L'acteur l'installe et reprend au pas 1.
- **2b. La configuration d'environnement n'est pas accessible en écriture** : le système s'arrête sans effet et le signale.
- **3a. L'outil est déjà rattaché, au même arbre source** : le système le constate et n'écrit rien ; le parcours est un succès sans changement.
- **3b. L'outil est déjà rattaché, à un autre arbre source** : le système **met à jour** le rattachement plutôt que de déclarer l'opération déjà faite, puis signale le déplacement.
- **4a. L'acteur veut rendre l'outil disponible à d'autres utilisateurs du poste** : le système ne peut agir sur la configuration d'un autre utilisateur sans privilèges élevés. Le déroulé de cette variante n'est pas décidé ; voir la recommandation correspondante de [`ANL-015`](../analyses/ANL-015-faisabilite-installation-et-versions.md).
- **5a. L'outil ne répond pas après l'opération** : la session en cours n'a pas rechargé sa configuration. Le système l'a annoncé au pas 4 ; l'acteur ouvre une nouvelle session ou recharge la configuration.

## Critères d'acceptation

- Après le parcours, l'outil répond depuis un répertoire quelconque, dans une session nouvellement ouverte.
- L'outil exécuté est celui de l'arbre source : une modification de l'arbre source est immédiatement effective, sans réinstallation.
- Rejouer le parcours à l'identique ne produit aucun changement supplémentaire et n'échoue pas.
- Rejouer le parcours depuis un arbre source déplacé met le rattachement à jour.
- Quand une dépendance manque, rien n'est écrit et le message nomme ce qui manque.
- Le rattachement posé est identifiable et retirable sans ambiguïté.

## Relations

- **Acteur** : [`ACT-003`](../acteurs/ACT-003-installateur.md) utilise ce parcours pour disposer de l'outil sur son poste. Note : la définition d'`ACT-003` porte sur l'équipement d'un dépôt ; ce parcours porte sur l'équipement d'un poste, qui en est la précondition (voir [`ANL-015`](../analyses/ANL-015-faisabilite-installation-et-versions.md)).
- **Précède** : [`USE-002`](USE-002-creer-un-depot-neuf-deja-equipe.md), [`USE-003`](USE-003-connaitre-les-versions-disponibles.md), [`USE-004`](USE-004-elever-un-depot-a-une-version-plus-recente.md), [`USE-005`](USE-005-ramener-un-depot-a-une-version-anterieure.md), qui supposent tous l'outil disponible.
- **Satisfait par** : [`REQ-003`](../requis/REQ-003-installation-et-extension.md) (F1 à F9, NF1 à NF5), spécifié par [`SPEC-004`](../specs/SPEC-004-script-amorcage-et-extension.md). Cadre décidé par [`ADR-010`](../adr/ADR-010-clia-setup-commandes-modes-installation.md) (D1, D2).
- **Source** : cas d'usage 1 de la tâche 38 de `.dev/session.md`.
