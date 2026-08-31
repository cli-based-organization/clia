---
type: usage
version: 0.1.0
title: "Ramener un dépôt équipé à une version antérieure"
status: proposé
date: 2026-07-29
acteur-principal: ACT-003
niveau: but-utilisateur
---

# USE-005 - Ramener un dépôt équipé à une version antérieure

## En-tête

- **Portée** : le système d'augmentation et le dépôt cible, considérés comme boîte noire.
- **Parties prenantes et intérêts** : [`ACT-001`](../acteurs/ACT-001-operateur-du-depot.md), qui veut pouvoir revenir en arrière quand une évolution le gêne ; [`ACT-004`](../acteurs/ACT-004-mainteneur-du-systeme-augmentation.md), pour qui la réversibilité est ce qui rend une évolution acceptable.
- **Préconditions** : l'outil d'augmentation est disponible ([`USE-001`](USE-001-rendre-l-outil-disponible-sur-son-poste.md)) ; le dépôt cible est équipé et porte une marque de version ; la version visée est disponible ([`USE-003`](USE-003-connaitre-les-versions-disponibles.md)) et **strictement inférieure** à celle installée.
- **Garantie de succès** : le dépôt cible porte la version visée du système d'augmentation ; son contenu de domaine et sa conception propre sont inchangés ; la version installée est enregistrée.
- **Garantie minimale** : en cas d'échec, le dépôt reste dans sa version antérieure, cohérente et utilisable.

## Flux nominal

1. L'acteur désigne la version antérieure visée pour le dépôt courant.
2. Le système établit la version installée et vérifie que la version visée lui est strictement inférieure.
3. Le système établit la liste des différences à appliquer, ressource par ressource.
4. Le système présente cette liste à l'acteur, en signalant ce qui sera **retiré** et non seulement remplacé.
5. Le système applique les changements aux seuls fichiers du système d'augmentation.
6. Le système enregistre dans le dépôt la version installée.
7. Le système rend compte de ce qui a changé.

## Flux alternatifs et d'échec

- **2a. Le dépôt n'est pas équipé, ou ne porte aucune marque de version** : le système refuse, comme en [`USE-004`](USE-004-elever-un-depot-a-une-version-plus-recente.md).
- **2b. La version visée est supérieure à la version installée** : le système refuse et oriente vers [`USE-004`](USE-004-elever-un-depot-a-une-version-plus-recente.md).
- **2c. La version visée n'est pas atteignable localement** : le système refuse plutôt que d'approximer, et dit ce qui manque pour l'atteindre.
- **3a. Une ressource existe dans la version installée et pas dans la version visée** : le retour en arrière implique de la **retirer**. Le système ne le fait pas silencieusement : le retrait est annoncé au pas 4.
- **3b. Une ressource de conception du dépôt cible référence une ressource d'augmentation que le retour en arrière retire** : le système signale la référence qui va devenir pendante, et laisse l'acteur trancher.
- **5a. L'application échoue en cours de route** : le système s'arrête et signale ce qui a été appliqué et ce qui ne l'a pas été.

## Critères d'acceptation

- Le contenu de domaine et la conception propre du dépôt cible sont identiques avant et après.
- La marque de version du dépôt reflète la version visée après un succès.
- Une demande de mouvement ascendant est refusée par ce parcours.
- Tout retrait de ressource est annoncé avant d'être appliqué.
- Un retour en arrière suivi d'une remontée à la version de départ restitue le même état du système d'augmentation.
- Quand la version visée n'est pas atteignable, rien n'est écrit et le message dit ce qui manque.

## Relations

- **Acteur** : [`ACT-003`](../acteurs/ACT-003-installateur.md) utilise ce parcours pour revenir à un état antérieur du système d'augmentation.
- **Suppose** : [`USE-001`](USE-001-rendre-l-outil-disponible-sur-son-poste.md), [`USE-003`](USE-003-connaitre-les-versions-disponibles.md).
- **Symétrique de** : [`USE-004`](USE-004-elever-un-depot-a-une-version-plus-recente.md).
- **Satisfait par** : aucune exigence à ce jour. La re-matérialisation depuis l'arbre source est cadrée par [`ADR-010`](../adr/ADR-010-clia-setup-commandes-modes-installation.md) (décision D7), dont les conséquences pour ce parcours sont analysées par [`ANL-015`](../analyses/ANL-015-faisabilite-installation-et-versions.md).
- **Source** : cas d'usage 5 de la tâche 38 de `.dev/session.md`.
