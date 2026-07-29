---
type: usage
version: 0.1.0
title: "Connaître les versions disponibles du système d'augmentation"
status: proposé
date: 2026-07-29
acteur-principal: ACT-003
niveau: but-utilisateur
---

# USE-003 - Connaître les versions disponibles du système d'augmentation

## En-tête

- **Portée** : le système d'augmentation, considéré comme boîte noire, et le dépôt cible s'il en existe un.
- **Parties prenantes et intérêts** : [`ACT-004`](../acteurs/ACT-004-mainteneur-du-systeme-augmentation.md), qui publie les versions et veut qu'elles soient visibles ; [`ACT-001`](../acteurs/ACT-001-operateur-du-depot.md), qui veut savoir s'il travaille sur une version à jour.
- **Préconditions** : l'outil d'augmentation est disponible sur le poste ([`USE-001`](USE-001-rendre-l-outil-disponible-sur-son-poste.md)).
- **Garantie de succès** : l'acteur connaît la liste des versions du système d'augmentation qu'il peut atteindre, et sait laquelle est installée dans le dépôt courant.
- **Garantie minimale** : le parcours est en lecture seule ; aucun état n'est modifié, quel que soit son issue.

## Flux nominal

1. L'acteur demande la liste des versions disponibles.
2. Le système énumère les versions publiées du système d'augmentation, dans un ordre déterminé.
3. Le système indique laquelle est actuellement installée dans le dépôt courant, et laquelle est la plus récente disponible.
4. L'acteur choisit sa cible et enchaîne, s'il le souhaite, sur [`USE-004`](USE-004-elever-un-depot-a-une-version-plus-recente.md) ou [`USE-005`](USE-005-ramener-un-depot-a-une-version-anterieure.md).

## Flux alternatifs et d'échec

- **2a. Aucune version n'est publiée** : le système le dit explicitement plutôt que de rendre une liste vide sans explication.
- **3a. Le répertoire courant n'est pas un dépôt équipé** : le système énumère les versions disponibles et signale qu'aucune n'est installée ici, sans traiter le cas comme une erreur.
- **3b. Le dépôt courant est équipé mais ne porte aucune marque de version** : le système le signale comme un état à régulariser, parce que les parcours de mise à niveau ne peuvent pas savoir d'où ils partent.
- **3c. La version installée ne correspond à aucune version publiée** : le système la présente comme telle plutôt que de la taire ; c'est le cas d'un dépôt équipé depuis un état de travail intermédiaire.

## Critères d'acceptation

- Le parcours n'écrit rien, en aucune circonstance.
- La liste rendue est ordonnée de façon déterministe et deux exécutions successives sans changement d'état produisent le même résultat.
- La version installée dans le dépôt courant est distinguée des versions simplement disponibles.
- Hors d'un dépôt équipé, le parcours réussit et le dit.
- Un dépôt équipé sans marque de version est signalé comme tel.

## Relations

- **Acteur** : [`ACT-003`](../acteurs/ACT-003-installateur.md) utilise ce parcours pour choisir une cible avant de faire évoluer un dépôt.
- **Suppose** : [`USE-001`](USE-001-rendre-l-outil-disponible-sur-son-poste.md).
- **Précède** : [`USE-004`](USE-004-elever-un-depot-a-une-version-plus-recente.md), [`USE-005`](USE-005-ramener-un-depot-a-une-version-anterieure.md).
- **Satisfait par** : aucune exigence à ce jour. Ce parcours **présuppose une notion de version du système d'augmentation** qui n'existe pas dans le modèle actuel ; c'est le premier point d'[`ANL-015`](../analyses/ANL-015-faisabilite-installation-et-versions.md).
- **Source** : cas d'usage 3 de la tâche 38 de `.dev/session.md`.
