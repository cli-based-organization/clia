---
type: plan
version: 0.5.0
title: "Implémentation : rendre l'outil disponible, créer un dépôt équipé, connaître les versions (USE-001 à USE-003)"
status: exécuté
---

# PLN-019 - Implémentation (USE-001 à USE-003)

## Changelog

- **Révision 5 (2026-07-29, tâche 45)** : **segments 2, 3 et 4 exécutés**, plan `exécuté`. Reprise après le BREAKPOINT 1 sur demande humaine, formulée comme un bogue (« pourquoi `clia setup CMD` n'est pas documenté ? »), tracé par [`BUG-008`](../bugs/BUG-008-groupe-setup-non-documente.md). Livré : `src/lib/setup.sh` (délégation à l'extension, vérification de contrat, propagation du code de retour), `setup.sh` étendu de `init` et `versions` (reconnaissance des quatre états d'une cible, matérialisation par zones et `type`, création du dépôt, marque d'installation, énumération des versions), entrées documentaires du groupe `setup`, dispatch, et 33 scénarios de test supplémentaires. Le harnais de test du segment 4 est constitué par extension de `test/test_setup.sh` plutôt que par un fichier distinct : les scénarios des trois parcours partagent le même bac à sable, ce que demandait le contexte de session (tests qui se cumulent). Suites : `test_setup.sh` 59 assertions, `test_clia.sh` 8 assertions, aucun échec.

- **Révision 4 (2026-07-29, tâche 43)** : exécution autorisée, statut `résolu` vers `approuvé`. **Segment 1 exécuté** (étapes 1.1 à 1.4) : `setup.sh` v0.2.0 expose `install`, `--check`, `--uninstall` et `--contract-version`, avec bloc marqué, idempotence réconciliante, vérification préalable des dépendances et de l'accès en écriture, écriture atomique et retrait exact ; `test/test_setup.sh` couvre les neuf scénarios de `USE-001` en bac à sable et passe (27 assertions). La surface de la couche 2 devient le groupe `clia setup` (`ADR-010` v0.3.0, D3) : les étapes du segment 2 sont à lire avec cette surface. **Arrêt au BREAKPOINT 1.**

- **Révision 3 (2026-07-29, tâche 41)** : objection humaine, **résolue par amendement**. L'outil ne fait pas partie de ce qui est installé dans un dépôt cible : il est installé une fois, globalement, s'utilise depuis n'importe où, et **détecte** si le répertoire courant est un dépôt compatible, sur le modèle de `tda`. Trois conséquences sur ce plan :
  - le moteur de matérialisation (2.3) pose le **harnais et ses actifs seulement** ; l'outil et sa source documentaire sont retirés de ce qu'il écrit ;
  - une étape nouvelle (2.2) implémente la **détection d'un dépôt compatible**, dont trois parcours dépendent ;
  - la réserve tracée à la révision 2 sur la coexistence de deux copies de l'outil **disparaît** : il n'y en a plus qu'une.

- **Révision 2 (2026-07-29, tâche 40)** : traitement des trois objections de l'agent, toutes **résolues** par les résolutions humaines de la tâche 40.
  - **objection 1 (tests)** : levée par amendement de la directive. Les tests sont **implémentés et exécutés** ; ce qui était demandé était de ne pas formaliser prématurément le **processus** de test. Le segment 3 est donc maintenu et devient non négociable, tout en restant un harnais de scénarios et non une méthodologie ;
  - **objection 2 (contenu du paquet)** : levée par décision. Le paquet inclut l'outil **et** le mode dev pointe vers l'arbre source, les deux à la fois. La duplication de comportement est évitée autrement : la commande de l'outil **n'est pas une réimplémentation** du script d'amorçage, elle l'**invoque** en tant qu'extension. Le segment 2 est restructuré en conséquence ;
  - **objection 3 (marque illisible)** : levée par élargissement de portée. [`USE-003`](../usages/USE-003-connaitre-les-versions-disponibles.md) entre dans le plan : la connaissance de la version est déclarée essentielle, et le mécanisme de découverte est implémenté ici. La marque cesse donc d'être écrite sans lecteur.
- **Révision 1 (2026-07-29, tâche 39)** : création, avec trois objections ouvertes.

## Intention

Écrire le code des trois premiers parcours d'installation : rendre l'outil disponible sur le poste de l'installateur ([`USE-001`](../usages/USE-001-rendre-l-outil-disponible-sur-son-poste.md)), créer un dépôt neuf déjà équipé ([`USE-002`](../usages/USE-002-creer-un-depot-neuf-deja-equipe.md)), et connaître les versions disponibles et installée ([`USE-003`](../usages/USE-003-connaitre-les-versions-disponibles.md)).

## Contexte

- **Source de la demande** : tâches 39 et 40 de `.dev/session.md`.
- **Précondition stricte** : [`PLN-018`](PLN-018-preparation-installation-outil-et-depot.md) exécuté. Ce plan implémente un contrat ; tant que ce contrat n'est pas écrit (surface de commandes, frontière git, contrat d'extension, notion de version et marque d'installation, exigences, spécifications), il n'y a rien à implémenter.
- **Ordre de travail** ([`ADR-007`](../adr/ADR-007-architecture-systeme-augmentation.md)) : l'implémentation vient après la conception et la méthodologie. Ce plan est le dernier maillon.
- **État du code** : `setup.sh` compte 34 lignes et n'expose qu'un mode d'activation de session, sans aucune écriture persistante. Aucune commande d'installation n'existe dans l'outil, ni aucun mécanisme d'extension. Le socle est en revanche complet : dispatch, options globales, aide générée depuis `src/clia.doc.yaml`, résolution de racine, helpers de sortie et codes de retour uniformes ([`SPEC-001`](../specs/SPEC-001-convention-cli-bash.md), [`SPEC-002`](../specs/SPEC-002-cli-clia.md)).
- **L'outil n'est pas distribué** (décision D6 amendée, attendue de `PLN-018`) : il est installé une fois, globalement, par le segment 1, et s'utilise depuis n'importe quel répertoire. Ce qu'un dépôt cible reçoit, c'est le harnais et ses actifs, jamais l'outil. En contrepartie, l'outil doit **reconnaître** un dépôt équipé quand il en rencontre un (décision D9).
- **Principe structurant** (décision D8 attendue de `PLN-018`) : **une seule implémentation**. Le script d'amorçage porte la logique d'installation ; l'outil l'expose en l'invoquant comme extension. Cela impose une contrainte au script : il doit fonctionner **de façon autonome** (avant que l'outil existe dans l'environnement, ce qui est le cas du parcours `USE-001`) **et** comme extension invoquée (parcours `USE-002`). Ces deux modes d'appel partagent le même code et ne diffèrent que par leur point d'entrée.
- **Portée exclue** : la mise à niveau et le retour en arrière ([`USE-004`](../usages/USE-004-elever-un-depot-a-une-version-plus-recente.md), [`USE-005`](../usages/USE-005-ramener-un-depot-a-une-version-anterieure.md)), et le type de ressource « interface CLI », qui restent à [`PLN-016`](PLN-016-installation-cycle-de-vie-clia.md).
- **Contraintes** : déterminisme ([`PDC-001`](../principes/PDC-001-determinisme-de-clia.md)) ; conformité à la convention de codage ([`skl-011`](../skills/skl-011-codage-cli-bash/SKILL.md), [`REQ-001`](../requis/REQ-001-convention-cli-bash.md)) ; cohérence entre dispatch et documentation générée ; cible Debian 12 et bash uniquement ; l'agent n'exécute aucune opération git.

## Spécification du livrable

- `setup.sh` étendu : installation persistante, vérification, retrait, matérialisation dans un dépôt cible.
- Le mécanisme d'extension dans `src/lib/`, et les commandes correspondantes câblées au dispatch.
- La lecture des versions disponibles et de la version installée.
- Les entrées de documentation dans `src/clia.doc.yaml`, sans lesquelles les commandes existeraient sans être découvrables.
- Un harnais de test en bac à sable couvrant les trois parcours.

## Plan proposé

### Segment 1 : Rendre l'outil disponible (`USE-001`)

#### 1.1 Installation persistante

Étendre `setup.sh` d'un mode d'installation qui écrit un bloc **délimité par des marqueurs d'ouverture et de fermeture explicites** dans la configuration de shell de l'utilisateur, rattachant le nom de l'outil à l'arbre source. Corriger d'emblée les fragilités relevées par [`ANL-002`](../analyses/ANL-002-setup-installation.md) :

- **idempotence réconciliante** : si le bloc existe et pointe ailleurs, le mettre à jour et le dire, au lieu d'annoncer que tout est déjà fait (flux `3b` de `USE-001`) ;
- **vérification avant écriture** : dépendances et accès en écriture contrôlés d'abord, aucune écriture partielle ensuite (flux `2a` et `2b`) ;
- **écriture atomique** : fichier temporaire puis remplacement, jamais d'édition en place.

Le mode dev est conservé : l'exécution pointe vers l'arbre source, une modification de la source est immédiatement effective, sans copie ni réinstallation.

#### 1.2 Vérification et retrait

Deux modes complémentaires : un mode de **vérification** qui rend compte de l'état d'installation sans rien écrire, et un mode de **retrait** qui supprime exactement ce que l'installation a posé, ce que les marqueurs explicites rendent déterministe. Le retrait est ce qui rend l'installation acceptable.

#### 1.3 Message de fin

Le pas 4 de `USE-001` exige que l'acteur sache comment activer le changement dans sa session courante. C'est la cause du seul flux d'échec restant après un succès (`5a`).

#### 1.4 Test du segment

Écrire et exécuter les scénarios du segment dans le bac à sable défini au segment 3 : installation, réinstallation à l'identique, réinstallation depuis un arbre déplacé, dépendance absente, retrait. Aucun de ces scénarios n'écrit dans la configuration de shell réelle de l'humain.

Cette étape est **dans** le segment 1 et non reportée au segment 3 : le code de 1.1 modifie la configuration de shell, et il doit être éprouvé avant d'être exécuté pour de bon.

**BREAKPOINT 1.** Arrêt après 1.4. Le segment 1 est autonome et livrable : l'humain éprouve l'installation sur son poste, et son retrait, avant que l'implémentation ne se poursuive.

### Segment 2 : Créer un dépôt équipé (`USE-002`)

#### 2.1 Mécanisme d'extension

Implémenter le contrat d'extension décidé par `PLN-018` (étape 1.3) : découverte du script, invocation, passage des arguments, propagation des codes de retour, déclaration de l'aide dans la source documentaire. Le script d'amorçage est la première extension et la seule à ce stade.

C'est l'étape qui donne corps à la décision D8 : à partir d'ici, l'outil **n'implémente pas** l'installation, il l'expose.

#### 2.2 Résolution de la cible et détection d'un dépôt compatible

Implémenter la résolution décidée par [`ADR-010`](../adr/ADR-010-clia-setup-commandes-modes-installation.md) (décision D4), en y ajoutant le cas nouveau de `USE-002` : une cible **qui n'existe pas encore**. La racine de la cible ne se confond jamais avec la racine de l'outil.

Implémenter ensuite la **détection** décidée en D9 : l'outil, appelable depuis n'importe où, reconnaît un dépôt équipé à ce que `PLN-018` aura désigné comme marqueur, et sait dire les trois états qu'il peut rencontrer : dépôt équipé, dépôt non équipé, hors de tout dépôt. C'est la contrepartie du fait que l'outil n'est pas distribué, et trois parcours en dépendent (flux `2b` de `USE-002`, `3a` de `USE-003`, et les parcours de version hors portée).

#### 2.3 Moteur de matérialisation

Écrire, dans le script d'amorçage, le code qui pose le paquet distribuable dans la cible, en le déterminant par les **zones** et le champ **`type`** ([`ADR-010`](../adr/ADR-010-clia-setup-commandes-modes-installation.md), décision D6 amendée), sans liste codée en dur : c'est la seule forme compatible avec la source de vérité unique ([`PDC-006`](../principes/PDC-006-source-de-verite-documentaire-unique.md)), et la seule qui n'exige aucune modification lors de l'ajout d'un type de ressource.

Le paquet posé est le **harnais et ses actifs seulement**. L'outil et sa source documentaire en sont exclus : c'est l'objet de l'objection humaine de la tâche 41. Une cible équipée ne contient donc aucun exécutable, et la seule copie de l'outil est celle qu'a rendue disponible le segment 1.

Propriétés exigées : écriture atomique, refus sans effet de bord si une précondition manque, et aucun état intermédiaire présenté comme un succès (flux `4a` de `USE-002`).

#### 2.4 Création du dépôt versionné

Créer le dépôt à l'emplacement visé quand il n'en existe pas, dans la seule limite d'écriture git fixée par `PLN-018`. Traiter les trois cas de `USE-002` : dépôt versionné déjà présent mais non équipé (poursuivre sans recréer), dépôt déjà équipé (refuser et orienter vers la mise à niveau), emplacement non vide (refuser sauf demande explicite).

#### 2.5 Marque d'installation

Écrire dans la cible le fichier d'état décidé par `PLN-018` : version posée, date, empreinte des fichiers écrits. C'est le pas 5 de `USE-002`, et son absence fait échouer le parcours avant toute écriture (flux `5a`).

#### 2.6 Dispatch et documentation

Câbler la commande au dispatch et déclarer son aide dans `src/clia.doc.yaml`. Les deux vont ensemble : une commande absente de la source documentaire existe sans être découvrable, ce que le dépôt qualifie déjà d'écart ([`BUG-006`](../bugs/BUG-006-decouvrabilite-uniformite-non-implementee.md), [`PDC-007`](../principes/PDC-007-decouvrabilite-et-uniformite.md)).

#### 2.7 Test du segment

Scénarios dans le bac à sable : création sur emplacement vide, sur dépôt versionné non équipé, sur dépôt déjà équipé, sur emplacement non vide ; vérification que le contenu de domaine d'une cible existante est intact ; vérification du contenu de la marque écrite.

**BREAKPOINT 2.** Arrêt après 2.7. L'humain éprouve la création d'un dépôt équipé sur un cas réel avant que la lecture des versions ne s'y adosse.

### Segment 3 : Connaître les versions (`USE-003`)

#### 3.1 Énumération des versions disponibles

Lire les versions publiées du système d'augmentation depuis les étiquettes du dépôt source, en lecture seule et dans un ordre déterministe (tri semver, pas alphabétique). Traiter les cas prévus par le parcours : aucune version publiée, et arbre source à un état de travail ne correspondant à aucune version publiée.

#### 3.2 Lecture de la version installée

Lire la marque d'installation de la cible et la distinguer des versions simplement disponibles. Traiter les trois flux d'échec du parcours : répertoire courant qui n'est pas un dépôt équipé, dépôt équipé sans marque, marque ne correspondant à aucune version publiée.

Dans le dépôt source lui-même, la version installée est la version du domaine métier : c'est la coïncidence actée par `PLN-018` (étape 1.2), et elle doit être traitée comme un cas nominal, pas comme une exception.

#### 3.3 Contrôle de cohérence par les frontmatters

Comparer les versions portées par les frontmatters des ressources d'augmentation installées à ce que la marque déclare. Sert à signaler un dépôt dans un état mixte ou une marque qui ment. Contrôle, jamais source de vérité.

#### 3.4 Dispatch, documentation et test

Câbler, documenter, et éprouver dans le bac à sable : liste sur un dépôt équipé, hors d'un dépôt équipé, sur un dépôt sans marque, et vérification qu'aucune écriture n'a lieu en aucun cas.

### Segment 4 : Harnais de test cumulatif

#### 4.1 Bac à sable partagé

Consolider les scénarios écrits aux étapes 1.4, 2.7 et 3.4 en un harnais unique dans `test/`, selon le motif déjà présent dans `test/test_clia.sh` (répertoire temporaire, copie de la source, nettoyage à la sortie). Aucune écriture hors du bac à sable, en particulier aucune écriture dans la configuration de shell réelle de l'humain.

Répond au contexte de session, qui relève que les tests sont « fragmentés et ne se cumulent pas ». Il s'agit d'un harnais de scénarios, pas d'une méthodologie de test : la formalisation du processus de test reste hors portée, conformément à la résolution de l'objection 1 à la tâche 40.

## Objections de l'agent IA

Aucune objection ouverte actuellement. Les trois objections de la révision 1 sont résolues par la tâche 40 de `.dev/session.md`, et l'objection humaine de la tâche 41 est résolue par amendement du plan ; leur traitement est détaillé au Changelog ci-dessus.

La réserve tracée à la révision 2 (deux copies de l'outil, l'une posée dans la cible, l'autre exécutée depuis l'arbre source) est **caduque** : l'outil n'est plus distribué, il n'en existe qu'une copie.

## Relations

- **Réalise** : [`USE-001`](../usages/USE-001-rendre-l-outil-disponible-sur-son-poste.md), [`USE-002`](../usages/USE-002-creer-un-depot-neuf-deja-equipe.md) et [`USE-003`](../usages/USE-003-connaitre-les-versions-disponibles.md).
- **Suppose** : [`PLN-018`](PLN-018-preparation-installation-outil-et-depot.md) exécuté.
- **Réduit la portée de** : [`PLN-016`](PLN-016-installation-cycle-de-vie-clia.md), pour la part qui concerne ces trois parcours.

## Note sur les objections humaines

Les objections de l'humain sur ce plan ne sont pas consignées ici mais dans `.dev/session.md`.
