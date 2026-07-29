---
type: plan
version: 0.1.0
title: "Implémentation : rendre l'outil disponible et créer un dépôt équipé (USE-001, USE-002)"
status: objection
---

# PLN-019 - Implémentation (USE-001, USE-002)

## Intention

Écrire le code des deux premiers parcours d'installation : rendre l'outil disponible sur le poste de l'installateur ([`USE-001`](../usages/USE-001-rendre-l-outil-disponible-sur-son-poste.md)), et créer un dépôt neuf déjà équipé du système d'augmentation ([`USE-002`](../usages/USE-002-creer-un-depot-neuf-deja-equipe.md)). Ce sont les deux capacités attendues de la session qui sont à portée immédiate.

## Contexte

- **Source de la demande** : tâche 39 de `.dev/session.md`, qui demande un plan d'implémentation distinct du plan de préparation, avec une portée restreinte à `USE-001` et `USE-002`.
- **Précondition stricte** : [`PLN-018`](PLN-018-preparation-installation-outil-et-depot.md) exécuté. Ce plan implémente un contrat ; tant que ce contrat n'est pas écrit (surface de commandes, frontière git, marque d'installation, exigences, spécifications), il n'y a rien à implémenter. Voir l'objection 1.
- **Ordre de travail** ([`ADR-007`](../adr/ADR-007-architecture-systeme-augmentation.md)) : l'implémentation vient après la conception et la méthodologie. Ce plan est le dernier maillon.
- **État du code** : `setup.sh` compte 34 lignes et n'expose qu'un mode d'activation de session, sans aucune écriture persistante. Aucune commande d'installation n'existe dans l'outil. Le socle est en revanche complet : dispatch, options globales, aide générée depuis `src/clia.doc.yaml`, résolution de racine, helpers de sortie et codes de retour uniformes ([`SPEC-001`](../specs/SPEC-001-convention-cli-bash.md), [`SPEC-002`](../specs/SPEC-002-cli-clia.md)).
- **Portée exclue** : les parcours de version ([`USE-003`](../usages/USE-003-connaitre-les-versions-disponibles.md) à [`USE-005`](../usages/USE-005-ramener-un-depot-a-une-version-anterieure.md)), l'extension à des scripts externes et le type de ressource « interface CLI », qui restent à [`PLN-016`](PLN-016-installation-cycle-de-vie-clia.md).
- **Contraintes** : déterminisme ([`PDC-001`](../principes/PDC-001-determinisme-de-clia.md)) ; conformité à la convention de codage ([`skl-011`](../skills/skl-011-codage-cli-bash/SKILL.md), [`REQ-001`](../requis/REQ-001-convention-cli-bash.md)) ; cohérence entre dispatch et documentation générée ; cible Debian 12 et bash uniquement ; l'agent n'exécute aucune opération git.

## Spécification du livrable

- `setup.sh` étendu : installation persistante, vérification, retrait.
- Un module de matérialisation dans `src/lib/`, et la commande correspondante câblée au dispatch.
- Les entrées de documentation dans `src/clia.doc.yaml`, sans lesquelles la commande existerait sans être découvrable.
- Un harnais de test en bac à sable couvrant les deux parcours.

## Plan proposé

### Segment 1 : Couche 1, rendre l'outil disponible (`USE-001`)

#### 1.1 Installation persistante

Étendre `setup.sh` d'un mode d'installation qui écrit un bloc **délimité par des marqueurs d'ouverture et de fermeture explicites** dans la configuration de shell de l'utilisateur, rattachant le nom de l'outil à l'arbre source. Corriger d'emblée les fragilités relevées par [`ANL-002`](../analyses/ANL-002-setup-installation.md) :

- **idempotence réconciliante** : si le bloc existe et pointe ailleurs, le mettre à jour et le dire, au lieu d'annoncer que tout est déjà fait (flux `3b` de `USE-001`) ;
- **vérification avant écriture** : dépendances et accès en écriture contrôlés d'abord, aucune écriture partielle ensuite (flux `2a` et `2b`) ;
- **écriture atomique** : fichier temporaire puis remplacement, jamais d'édition en place.

#### 1.2 Vérification et retrait

Deux modes complémentaires : un mode de **vérification** qui rend compte de l'état d'installation sans rien écrire, et un mode de **retrait** qui supprime exactement ce que l'installation a posé, ce que les marqueurs explicites rendent déterministe. Le retrait est ce qui rend l'installation acceptable.

#### 1.3 Message de fin

Le pas 4 de `USE-001` exige que l'acteur sache comment activer le changement dans sa session courante. C'est la cause du seul flux d'échec restant après un succès (`5a`).

**BREAKPOINT 1.** Arrêt après 1.3. Le segment 1 modifie la configuration de shell de l'humain : il doit pouvoir l'éprouver sur son poste, et retirer l'installation, avant que l'implémentation ne se poursuive.

### Segment 2 : Couche 2, créer un dépôt équipé (`USE-002`)

#### 2.1 Résolution de la cible

Implémenter la résolution décidée par [`ADR-010`](../adr/ADR-010-clia-setup-commandes-modes-installation.md) (décision D4), en y ajoutant le cas nouveau de `USE-002` : une cible **qui n'existe pas encore**. La racine de la cible ne se confond jamais avec la racine de l'outil.

#### 2.2 Moteur de matérialisation

Écrire le module qui pose le paquet distribuable dans la cible, en le déterminant par les **zones** et le champ **`type`** ([`ADR-010`](../adr/ADR-010-clia-setup-commandes-modes-installation.md), décision D6), sans liste codée en dur : c'est la seule forme compatible avec la source de vérité unique ([`PDC-006`](../principes/PDC-006-source-de-verite-documentaire-unique.md)), et la seule qui n'exige aucune modification lors de l'ajout d'un type de ressource.

Propriétés exigées : écriture atomique, refus sans effet de bord si une précondition manque, et aucun état intermédiaire présenté comme un succès (flux `4a` de `USE-002`).

#### 2.3 Création du dépôt versionné

Créer le dépôt à l'emplacement visé quand il n'en existe pas, dans la seule limite d'écriture git fixée par `PLN-018`. Traiter les trois cas de `USE-002` : dépôt versionné déjà présent mais non équipé (poursuivre sans recréer), dépôt déjà équipé (refuser et orienter vers la mise à niveau), emplacement non vide (refuser sauf demande explicite).

#### 2.4 Marque d'installation

Écrire dans la cible le fichier d'état décidé par `PLN-018` : version posée, date, empreinte des fichiers écrits. C'est le pas 5 de `USE-002`, et son absence fait échouer le parcours avant toute écriture (flux `5a`) : sans marque, les parcours de version ultérieurs ne sauront pas d'où ils partent.

#### 2.5 Dispatch et documentation

Câbler la commande au dispatch et déclarer son aide dans `src/clia.doc.yaml`. Les deux vont ensemble : une commande absente de la source documentaire existe sans être découvrable, ce que le dépôt qualifie déjà d'écart ([`BUG-006`](../bugs/BUG-006-decouvrabilite-uniformite-non-implementee.md), [`PDC-007`](../principes/PDC-007-decouvrabilite-et-uniformite.md)).

### Segment 3 : Vérification

#### 3.1 Harnais de test en bac à sable

Étendre `test/` d'un scénario reproductible, dans un répertoire temporaire isolé, selon le motif déjà présent dans `test/test_clia.sh` (répertoire temporaire, copie de la source, nettoyage à la sortie). Couvrir, pour chaque parcours, le déroulé nominal et les flux d'échec écrits dans les `USE` : installation puis réinstallation à l'identique, réinstallation depuis un arbre déplacé, dépendance absente, retrait ; création sur emplacement vide, sur dépôt versionné non équipé, sur dépôt déjà équipé, sur emplacement non vide.

Aucune écriture hors du bac à sable, en particulier aucune écriture dans la configuration de shell réelle de l'humain. Cette contrainte est ce qui rend le segment 1 testable sans risque.

## Objections de l'agent IA

1. **Le segment 3 est ce qui rend le segment 1 sûr.** Les tâches antérieures ont écarté les tests à plusieurs reprises, et cette directive pourrait s'appliquer ici par continuité. Si ce plan est exécuté sans son segment 3, le code du segment 1 **écrit dans la configuration de shell de l'humain** sans qu'aucun scénario reproductible ne l'ait exercé : un bloc mal délimité, une écriture partielle ou un retrait incomplet se manifestent alors sur le poste de travail réel, à l'ouverture de la session shell suivante. Suggestion : conserver le segment 3 ; à défaut, exécuter le segment 1 d'abord dans un bac à sable jetable, ce qui revient à écrire le test sans le nommer ainsi.

2. **La commande de création dépend d'une décision non prise sur le contenu du paquet.** La décision D6 d'[`ADR-010`](../adr/ADR-010-clia-setup-commandes-modes-installation.md) inclut l'outil dans le paquet distribuable, tandis que la couche 1 en mode dev fait pointer l'exécution vers l'arbre source. Si ce plan est exécuté avant que [`PLN-018`](PLN-018-preparation-installation-outil-et-depot.md) ait tranché ce point (étape 1.1), chaque dépôt créé recevra une copie de l'outil qui ne s'exécutera jamais, et qui divergera silencieusement de celle qui s'exécute. Suggestion : ne pas exécuter le segment 2 avant la décision.

3. **Aucune commande d'inspection ne rendra la marque d'installation lisible.** Le segment 2 écrit la marque ; les parcours qui la lisent ([`USE-003`](../usages/USE-003-connaitre-les-versions-disponibles.md) à [`USE-005`](../usages/USE-005-ramener-un-depot-a-une-version-anterieure.md)) sont hors portée par restriction de la tâche 39. Si ce plan est exécuté tel quel, le dépôt produira donc un fichier d'état que rien ne sait lire, et dont la justesse ne sera constatée qu'au moment où les parcours de version seront implémentés, c'est-à-dire trop tard pour corriger sans migration. Suggestion : couvrir le contenu de la marque par le harnais de test du segment 3, qui devient alors son seul lecteur.

## Relations

- **Réalise** : [`USE-001`](../usages/USE-001-rendre-l-outil-disponible-sur-son-poste.md) et [`USE-002`](../usages/USE-002-creer-un-depot-neuf-deja-equipe.md).
- **Suppose** : [`PLN-018`](PLN-018-preparation-installation-outil-et-depot.md) exécuté.
- **Réduit la portée de** : [`PLN-016`](PLN-016-installation-cycle-de-vie-clia.md), pour la part qui concerne ces deux parcours.

## Note sur les objections humaines

Les objections de l'humain sur ce plan ne sont pas consignées ici mais dans `.dev/session.md`.
