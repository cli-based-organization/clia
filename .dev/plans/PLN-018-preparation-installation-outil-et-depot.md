---
type: plan
version: 0.1.0
title: "Préparation avant implémentation : rendre l'outil disponible et créer un dépôt équipé (USE-001, USE-002)"
status: résolu
---

# PLN-018 - Préparation avant implémentation (USE-001, USE-002)

## Intention

Lever **tout ce qui bloque** l'implémentation des deux premiers parcours d'installation, et rien de plus. [`ANL-015`](../analyses/ANL-015-faisabilite-installation-et-versions.md) établit que ces parcours ne butent sur aucun obstacle technique : ce qui manque, ce sont des **décisions** et les documents de conception qui en découlent. Ce plan produit ces décisions et ces documents. L'écriture de code relève de [`PLN-019`](PLN-019-implementation-installation-outil-et-depot.md).

Périmètre restreint par la tâche 39 de `.dev/session.md` à [`USE-001`](../usages/USE-001-rendre-l-outil-disponible-sur-son-poste.md) (rendre l'outil disponible sur son poste) et [`USE-002`](../usages/USE-002-creer-un-depot-neuf-deja-equipe.md) (créer un dépôt neuf déjà équipé). Les parcours de version ([`USE-003`](../usages/USE-003-connaitre-les-versions-disponibles.md), [`USE-004`](../usages/USE-004-elever-un-depot-a-une-version-plus-recente.md), [`USE-005`](../usages/USE-005-ramener-un-depot-a-une-version-anterieure.md)) sont hors portée.

## Contexte

### État des plans (vérification du 2026-07-29)

La tâche 39 demande de vérifier tous les plans. Les dix-sept plans du dépôt ont été relus ; le tableau ne retient que ce qui reste à faire et ce qui est faux.

| Plan | Statut déclaré | Constat |
|---|---|---|
| `PLN-001` à `PLN-005`, `PLN-007`, `PLN-009`, `PLN-010`, `PLN-015` | `exécuté` | rien à faire, statut exact |
| [`PLN-006`](PLN-006-cli-clia.md) | **absent** | le frontmatter ne porte aucun champ `status` ; le plan est pourtant exécuté (le CLI existe) |
| [`PLN-008`](PLN-008-installation-clia.md) | `proposé` | **périmé** : couvre l'installation de l'outil, sujet repris par `PLN-012`, `PLN-013` puis `PLN-016`, et désormais par le présent plan |
| [`PLN-011`](PLN-011-reconciliation-clia-documentation.md) | `résolu` | **statut faux** : exécuté à la tâche 7 (la source `src/clia.doc.yaml` et l'aide générée existent) |
| [`PLN-012`](PLN-012-livrables-init-update-rollback.md), [`PLN-013`](PLN-013-conception-clia-setup.md) | `remplacé par PLN-016` | exact |
| [`PLN-014`](PLN-014-adoption-conventions-okf.md) | `approuvé (Segment 1 exécuté, au breakpoint)` | **statut faux** : le segment 2 a été exécuté à la tâche 30 (frontmatter généralisé, `ressources.yaml` supprimé, `logs` rapatriés) |
| [`PLN-016`](PLN-016-installation-cycle-de-vie-clia.md) | `résolu` | **partiellement exécuté** : l'étape 1.1 a produit [`ADR-010`](../adr/ADR-010-clia-setup-commandes-modes-installation.md) et l'étape 1.2 y est absorbée (décision D6). Restent : 1.3 (extension à des scripts externes), 1.4 (type de ressource « interface CLI »), et tout le segment 2 |
| [`PLN-017`](PLN-017-cas-usage-acteurs-tracabilite.md) | `approuvé` | en cours : segment 1 exécuté, étapes 3.1 et 3.2 partiellement exécutées ; restent le segment 2 (skills, harnais), la fin du catalogue et le segment 4 |

Quatre statuts sont faux ou absents. Ce n'est pas anodin : le statut d'un plan est ce qui autorise ou interdit son exécution ([`CONSTITUTION.md`](../../CONSTITUTION.md)). L'étape 3.2 les corrige.

### Ce qui est acquis pour les deux parcours

- Le **socle de CLI** : squelette conforme ([`SPEC-001`](../specs/SPEC-001-convention-cli-bash.md)), dispatch, options globales, aide générée depuis une source unique (`src/clia.doc.yaml`), résolution de racine par `BASH_SOURCE`.
- La **définition du paquet distribuable** par zones et champ `type`, sans manifeste ([`ADR-010`](../adr/ADR-010-clia-setup-commandes-modes-installation.md), décision D6).
- La **résolution de la racine cible**, distincte de la racine de l'outil (décision D4).
- Le **motif d'installation** analysé et ses cinq fragilités connues ([`ANL-002`](../analyses/ANL-002-setup-installation.md)).
- Les **deux parcours écrits**, avec leurs flux d'échec et leurs critères d'acceptation observables.

### Ce qui bloque, et pourquoi

Trois manques, tous de conception, tous établis par [`ANL-015`](../analyses/ANL-015-faisabilite-installation-et-versions.md) :

1. le pas 5 de [`USE-002`](../usages/USE-002-creer-un-depot-neuf-deja-equipe.md) exige d'enregistrer dans le dépôt créé **la version du système d'augmentation posée** ; or cette version n'existe pas dans le modèle (constat C1) et rien dans un dépôt équipé n'en garde trace (constat C2) ;
2. la surface de commandes énoncée par la tâche 38 **contredit quatre des sept décisions** d'`ADR-010` (constats C3, C4, C5, C6) ;
3. aucune exigence ni spécification ne couvre les deux parcours : la chaîne `USE` vers `REQ` vers `SPEC` vers code est ouverte à son premier maillon.

### Autorité de ce plan

`PLN-018` et [`PLN-019`](PLN-019-implementation-installation-outil-et-depot.md) prennent **autorité sur les parcours `USE-001` et `USE-002`**, selon le précédent par lequel `PLN-016` avait pris autorité sur `PLN-012` et `PLN-013`. [`PLN-016`](PLN-016-installation-cycle-de-vie-clia.md) conserve ce qui reste hors de cette portée : les parcours de version, l'extension à des scripts externes (étape 1.3) et le type de ressource « interface CLI » (étape 1.4). Le breakpoint de validation d'`ADR-010` ouvert dans `.dev/session.md` est absorbé par le breakpoint 1 du présent plan, qui porte sur la révision du même ADR.

### Contraintes

Ordre de travail imposé ([`ADR-007`](../adr/ADR-007-architecture-systeme-augmentation.md)) : conception, puis méthodologie, puis implémentation. Déterminisme de l'outil ([`PDC-001`](../principes/PDC-001-determinisme-de-clia.md)) ; généricité du harnais ([`ADR-005`](../adr/ADR-005-fonction-scope-harnais.md), [`PDC-003`](../principes/PDC-003-separation-methode-domaine-genericite-harnais.md)) ; source de vérité unique ([`PDC-006`](../principes/PDC-006-source-de-verite-documentaire-unique.md)) ; autorité humaine sur l'irréversible ([`PDC-010`](../principes/PDC-010-point-entree-unique-autorite-humaine-irreversible.md)) ; l'agent n'opère aucune action git.

## Spécification du livrable

L'exécution de ce plan produira :

- `ADR-010` **v0.2.0** (révision ciblée : quatre décisions amendées, trois conservées) ;
- un **ADR** nouveau définissant la version du système d'augmentation et la marque d'installation ;
- un **REQ** couvrant les deux parcours ;
- une **SPEC** couvrant les deux commandes ;
- le rattachement amont des deux `USE` aux exigences produites ;
- l'amendement de [`ACT-003`](../acteurs/ACT-003-installateur.md) et la correction des statuts de plans erronés.

Aucun code n'est écrit par ce plan.

## Plan proposé

### Segment 1 : Décisions (R1, R2, R3, R4)

#### 1.1 Réviser `ADR-010` en v0.2.0

Amender quatre décisions, en conservant D1 (deux couches), D4 (résolution de la cible) et D6 (paquet distribuable) inchangées :

- **D3, surface de commandes** : passer du groupe `clia setup <init|upgrade|downgrade>` aux commandes de premier niveau demandées à la tâche 38. Motiver le renversement plutôt que le taire : l'ADR avait écarté cette option pour préserver la cohérence avec les groupes `res` et `ses` ; la directive humaine prévaut, et la raison écartée doit rester lisible.
- **D5, git** : lever l'interdiction totale au profit d'une **frontière lecture / écriture**. Lecture autorisée sans réserve (énumérer des révisions, extraire un arbre à une révision). Écriture limitée à un seul geste : **créer un dépôt à un emplacement qui n'en contient pas**. Aucun enregistrement, aucune étiquette, aucun changement de révision sur un dépôt existant. Justifier par [`CONSTITUTION.md`](../../CONSTITUTION.md), qui interdit git à l'agent et non à l'outil déterministe opéré par l'humain, et par [`PDC-010`](../principes/PDC-010-point-entree-unique-autorite-humaine-irreversible.md), qui réserve l'irréversible à l'humain.
- **Question de conception laissée ouverte** : elle est tranchée. La création du dépôt versionné revient à l'outil, comme conséquence de la nouvelle D5 et du pas 3 de [`USE-002`](../usages/USE-002-creer-un-depot-neuf-deja-equipe.md).
- **D2, périmètre d'installation** : statuer sur le mode multi-utilisateur (recommandation R4 d'`ANL-015`). Trois options documentées, la recommandation étant de le sortir du périmètre immédiat : il ne sert aucun des deux parcours retenus, il exige des privilèges élevés, et il se heurte au mode dev, dont l'exécution pointe vers un arbre source situé dans le répertoire personnel de l'installateur.

Trois points de surface restent à fixer dans cette révision, faute de quoi l'implémentation les fixerait par défaut :

- le **nom de la commande d'amorçage** : l'énoncé de la tâche 38 dit `install` au cas d'usage 1 et `init` en introduction (constat C8 d'`ANL-015`) ;
- l'**appartenance de l'outil au paquet distribuable** : la décision D6 inclut `src/` dans le paquet, tandis que la couche 1 en mode dev fait pointer l'exécution vers l'arbre source. Un dépôt équipé recevrait donc une copie de l'outil qui ne s'exécute jamais. Trancher entre distribuer le harnais seul, distribuer l'outil aussi, ou rendre l'inclusion optionnelle ;
- le **comportement devant une cible non vide** (flux `2c` de `USE-002`) : refus par défaut, et sous quelle condition explicite le passer outre.

#### 1.2 Nouvel ADR : version du système d'augmentation et marque d'installation

Acter les recommandations R1 et R2 d'[`ANL-015`](../analyses/ANL-015-faisabilite-installation-et-versions.md), dans la portée réduite qu'impose la restriction aux deux premiers parcours :

- **la version du système d'augmentation** est un **troisième domaine de version**, distinct du domaine métier (`version.yaml`) et des versions par ressource ([`ADR-004`](../adr/ADR-004-ressources-livrables.md)), porté par les étiquettes du dépôt source. Écarter explicitement l'agrégation des versions de frontmatter (aucune sémantique d'ordre global) et la réintroduction d'un fichier de version d'ensemble dans le harnais (c'est le manifeste aboli). Amender [`ADR-007`](../adr/ADR-007-architecture-systeme-augmentation.md), qui n'énonce aujourd'hui que deux domaines ;
- **la marque d'installation** : un fichier d'état dans la zone de développement du dépôt cible, portant la version posée, la date de l'opération et l'empreinte des fichiers écrits. Dire explicitement en quoi il ne ressuscite pas le manifeste aboli : celui-ci centralisait les versions **de la source**, celui-là enregistre l'état **d'une installation** ; ni le même lieu, ni le même propriétaire, ni la même durée de vie ;
- **ce que l'empreinte sert** : détecter qu'une ressource d'augmentation a été modifiée localement, seul moyen d'éviter la perte de travail lors d'une mise à niveau ultérieure. Ce plan la fait **écrire** ; son exploitation relève des parcours de version, hors portée ;
- **le cas de l'arbre source sans étiquette** : que note la marque quand la source n'est à aucune version publiée ? Le dépôt n'en porte aucune aujourd'hui ; le cas est donc le cas courant et non l'exception.

**BREAKPOINT 1.** Arrêt après 1.2. L'humain valide les deux ADR. Ce qui suit en dépend entièrement : les exigences et spécifications du segment 2 énoncent le contrat de ce que ces deux décisions posent, et [`PLN-019`](PLN-019-implementation-installation-outil-et-depot.md) l'implémente.

### Segment 2 : Exigences et spécifications

#### 2.1 Exigences des deux parcours

Produire les exigences ([`skl-010`](../skills/skl-010-requis/SKILL.md)) couvrant `USE-001` et `USE-002`, dérivées de leurs critères d'acceptation : idempotence réconciliante, retrait déterministe, vérification préalable des dépendances, refus sans effet de bord, atomicité de l'écriture, non-altération du contenu de domaine de la cible, écriture de la marque d'installation. Chaque exigence déclare le parcours qu'elle satisfait.

Trancher à cette étape entre amender [`REQ-002`](../requis/REQ-002-cli-clia.md) et produire un requis distinct. Recommandation : un requis distinct pour la couche 1 (le script d'amorçage n'est pas l'outil et ne relève pas de `REQ-002`), un amendement de `REQ-002` pour la couche 2.

#### 2.2 Spécifications d'interface

Produire les spécifications ([`skl-009`](../skills/skl-009-specification/SKILL.md)) : grammaire d'invocation, sorties, codes de retour, effets sur le système de fichiers, conditions d'échec. Amender [`SPEC-002`](../specs/SPEC-002-cli-clia.md) pour la commande de création de dépôt, produire une spécification distincte pour le script d'amorçage. Prolonger la table de traçabilité existante vers l'amont.

#### 2.3 Rattachement amont

Renseigner la relation `satisfait` dans [`USE-001`](../usages/USE-001-rendre-l-outil-disponible-sur-son-poste.md) et [`USE-002`](../usages/USE-002-creer-un-depot-neuf-deja-equipe.md), qui déclarent aujourd'hui qu'aucune exigence ne les sert. Forme provisoire décidée par [`ADR-012`](../adr/ADR-012-ressource-cas-d-usage.md) : liens markdown dans la section `## Relations`.

### Segment 3 : Cohérence

#### 3.1 Amender `ACT-003`

Recommandation R9 d'`ANL-015` : la définition de [`ACT-003`](../acteurs/ACT-003-installateur.md) porte sur l'équipement d'un dépôt, alors que `USE-001` porte sur l'équipement d'un poste, qui en est la précondition. Une phrase suffit.

#### 3.2 Corriger les statuts de plans erronés

D'après le tableau du contexte : ajouter le champ `status` manquant à `PLN-006` ; passer `PLN-011` à `exécuté` ; passer `PLN-014` à `exécuté` ; passer `PLN-008` à `remplacé par PLN-018 et PLN-019` ; mettre à jour `PLN-016` pour refléter son exécution partielle et la portée que le présent plan lui retire. Aucune autre modification de ces fichiers.

## Objections de l'agent IA

Aucune objection ouverte actuellement. Les trois tensions identifiées lors de la préparation de ce plan (nom de la commande d'amorçage, appartenance de l'outil au paquet distribuable, comportement devant une cible non vide) ne sont pas des objections mais des **décisions à prendre**, inscrites comme telles à l'étape 1.1 et soumises à l'humain au breakpoint 1.

## Relations

- **Réalise** : [`USE-001`](../usages/USE-001-rendre-l-outil-disponible-sur-son-poste.md) et [`USE-002`](../usages/USE-002-creer-un-depot-neuf-deja-equipe.md), en préparant leur implémentation.
- **Suivi de** : [`PLN-019`](PLN-019-implementation-installation-outil-et-depot.md), qui implémente ce que ce plan décide.
- **Dérive de** : [`ANL-015`](../analyses/ANL-015-faisabilite-installation-et-versions.md) (recommandations R1, R2, R3, R4, R8, R9).
- **Réduit la portée de** : [`PLN-016`](PLN-016-installation-cycle-de-vie-clia.md).

## Note sur les objections humaines

Les objections de l'humain sur ce plan ne sont pas consignées ici mais dans `.dev/session.md`.
