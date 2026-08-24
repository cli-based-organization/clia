---
type: usage
version: 0.1.0
title: "Élever un dépôt équipé à une version plus récente"
status: proposé
date: 2026-07-29
acteur-principal: ACT-003
niveau: but-utilisateur
---

# USE-004 - Élever un dépôt équipé à une version plus récente

## En-tête

- **Portée** : le système d'augmentation et le dépôt cible, considérés comme boîte noire.
- **Parties prenantes et intérêts** : [`ACT-001`](../acteurs/ACT-001-operateur-du-depot.md), dont le travail en cours ne doit pas être altéré ; [`ACT-004`](../acteurs/ACT-004-mainteneur-du-systeme-augmentation.md), qui veut que ses évolutions atteignent effectivement les dépôts équipés.
- **Préconditions** : l'outil d'augmentation est disponible ([`USE-001`](USE-001-rendre-l-outil-disponible-sur-son-poste.md)) ; le dépôt cible est équipé et porte une marque de version ; la version visée est disponible ([`USE-003`](USE-003-connaitre-les-versions-disponibles.md)) et **strictement supérieure** à celle installée.
- **Garantie de succès** : le dépôt cible porte la version visée du système d'augmentation ; son contenu de domaine et sa conception propre sont inchangés ; la nouvelle version est enregistrée dans le dépôt.
- **Garantie minimale** : en cas d'échec, le dépôt reste dans sa version antérieure, cohérente et utilisable ; aucun état mixte n'est laissé sans être signalé.

## Flux nominal

1. L'acteur désigne la version visée pour le dépôt courant.
2. Le système établit la version installée et vérifie que la version visée lui est strictement supérieure.
3. Le système établit la liste des différences à appliquer, ressource par ressource, entre l'état installé et l'état visé.
4. Le système présente cette liste à l'acteur avant d'agir.
5. Le système applique les changements aux seuls fichiers du système d'augmentation.
6. Le système enregistre dans le dépôt la nouvelle version installée.
7. Le système rend compte de ce qui a changé.

## Flux alternatifs et d'échec

- **2a. Le dépôt n'est pas équipé** : le système refuse et oriente vers [`USE-002`](USE-002-creer-un-depot-neuf-deja-equipe.md).
- **2b. Le dépôt ne porte aucune marque de version** : le système refuse d'agir à l'aveugle et le signale comme un état à régulariser.
- **2c. La version visée est égale à la version installée** : le système le constate et n'écrit rien ; succès sans changement.
- **2d. La version visée est inférieure à la version installée** : le système refuse et oriente vers [`USE-005`](USE-005-ramener-un-depot-a-une-version-anterieure.md). La direction du mouvement est un garde-fou, pas une déduction.
- **2e. La version visée n'existe pas** : le système refuse et oriente vers [`USE-003`](USE-003-connaitre-les-versions-disponibles.md).
- **3a. Une ressource d'augmentation a été modifiée localement dans le dépôt cible** : le système ne l'écrase pas silencieusement. Il signale le conflit et laisse l'acteur trancher.
- **5a. L'application échoue en cours de route** : le système s'arrête et signale précisément ce qui a été appliqué et ce qui ne l'a pas été. Il ne laisse pas croire au succès.
- **4a. L'acteur veut seulement savoir ce qui changerait** : il demande la présentation sans l'application ; le parcours s'arrête au pas 4 et n'écrit rien.

## Critères d'acceptation

- Le contenu de domaine du dépôt cible est identique avant et après.
- Les ressources de conception propres au dépôt cible sont identiques avant et après.
- La marque de version du dépôt reflète la version visée après un succès, et la version antérieure après un échec.
- Une demande de mouvement descendant est refusée par ce parcours.
- Une demande vers la version déjà installée n'écrit rien et ne signale pas d'erreur.
- Une ressource modifiée localement n'est jamais écrasée sans que le conflit soit signalé.
- La présentation préalable des changements est possible sans effet de bord.

## Relations

- **Acteur** : [`ACT-003`](../acteurs/ACT-003-installateur.md) utilise ce parcours pour faire évoluer un dépôt équipé.
- **Suppose** : [`USE-001`](USE-001-rendre-l-outil-disponible-sur-son-poste.md), [`USE-003`](USE-003-connaitre-les-versions-disponibles.md).
- **Symétrique de** : [`USE-005`](USE-005-ramener-un-depot-a-une-version-anterieure.md).
- **Satisfait par** : aucune exigence à ce jour. Le mécanisme de réconciliation est cadré par [`ADR-010`](../adr/ADR-010-clia-setup-commandes-modes-installation.md) (décisions D6 et D7), dont la source de version est à réviser (voir [`ANL-015`](../analyses/ANL-015-faisabilite-installation-et-versions.md)).
- **Source** : cas d'usage 4 de la tâche 38 de `.dev/session.md`.
