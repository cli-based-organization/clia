---
type: plan
version: 0.4.0
title: "Préparation avant implémentation : rendre l'outil disponible, créer un dépôt équipé, connaître les versions (USE-001 à USE-003)"
status: exécuté
---

# PLN-018 - Préparation avant implémentation (USE-001 à USE-003)

## Changelog

- **Révision 5 (2026-07-29, tâche 43)** : **plan exécuté en entier**, statut `approuvé` vers `exécuté`. Reprise après le BREAKPOINT 1 sur feedback humain : les propositions du segment 1 sont **acceptées**, à une exception près, la surface de commandes, qui redevient le groupe `clia setup` (`ADR-010` v0.3.0, D3). Segments 2 et 3 exécutés : `REQ-003` et `SPEC-004` produits, `REQ-002` v0.3.0 et `SPEC-002` v0.3.0 amendés du groupe `setup`, rattachement amont renseigné dans les trois `USE`, `ACT-003` amendé, cinq statuts de plans corrigés.

- **Révision 4 (2026-07-29, tâche 42)** : exécution autorisée, statut `résolu` vers **`approuvé`**. **Segment 1 exécuté** : [`ADR-010`](../adr/ADR-010-clia-setup-commandes-modes-installation.md) v0.2.0 (étape 1.1), [`ADR-013`](../adr/ADR-013-version-augmentation-et-marque-installation.md) (étape 1.2), [`ADR-014`](../adr/ADR-014-contrat-extension-outil.md) (étape 1.3), plus les deux conséquences que ces décisions entraînent : amendement d'[`ADR-007`](../adr/ADR-007-architecture-systeme-augmentation.md) en v0.3.0 et déclaration du fichier d'état dans [`.dev/resource-types.yaml`](../resource-types.yaml) v0.3.0. **Arrêt au BREAKPOINT 1** : les segments 2 et 3 ne sont pas exécutés, et [`PLN-019`](PLN-019-implementation-installation-outil-et-depot.md) ne peut pas commencer, sa précondition étant l'exécution complète du présent plan. Les six points laissés à l'arbitrage humain ont reçu une **position motivée** dans les ADR, au statut `Proposé` : un ADR qui dit « à décider » n'est pas un ADR. Le breakpoint sert à les confirmer ou à les renverser.

- **Révision 3 (2026-07-29, tâche 41)** : objection humaine sur le contenu du paquet distribuable, qui **renverse** la moitié de la résolution de la tâche 40.
  - **l'outil n'est pas distribué** : il est installé une fois, globalement, et s'utilise depuis n'importe où. Il **détecte** si le répertoire courant est un dépôt compatible, sur le modèle de `tda`. La décision D6 est amendée en conséquence : le paquet ne contient que le harnais et les actifs, jamais l'outil ni sa source documentaire. Le « les 2 à la fois » de la révision 2 ne vaut donc plus que pour sa seconde moitié (le mode dev pointe vers l'arbre source) ;
  - **conséquence sur D8** : la décision de ne pas réimplémenter la couche 1 dans la couche 2 est **maintenue**, mais sa justification change. La révision 2 la motivait par la nécessité de borner une divergence entre deux copies de l'outil ; cette divergence n'existe plus, puisqu'il n'y a plus qu'une copie. D8 tient désormais sur son propre motif, énoncé par la tâche 40 : une seule implémentation de la logique d'installation ;
  - **décision nouvelle à prendre** : ce qui fait qu'un dépôt est **compatible**, c'est-à-dire ce que l'outil cherche pour le reconnaître (étape 1.2) ;
  - **décision nouvelle à prendre** : le paquet est-il **copié** ou **lié** dans la cible en mode dev, `tda` offrant les deux (étape 1.1).
  - Note : les trois `USE` n'ont eu besoin d'aucune correction. Écrits sans nommer d'outil, ils sont indifférents à ce renversement, qui ne touche que les décisions d'outillage. C'est la première mise à l'épreuve de la règle d'indépendance d'[`ADR-012`](../adr/ADR-012-ressource-cas-d-usage.md), et elle tient.

- **Révision 2 (2026-07-29, tâche 40)** : conséquences des résolutions humaines apportées aux objections de [`PLN-019`](PLN-019-implementation-installation-outil-et-depot.md). Trois changements de fond :
  - **portée élargie** à [`USE-003`](../usages/USE-003-connaitre-les-versions-disponibles.md) (résolution de l'objection 3 : « la connaissance de la version est essentielle »). La découverte des versions disponibles n'est plus reportée ;
  - **question du paquet distribuable tranchée** (résolution de l'objection 2 : « les 2 à la fois ») : le paquet inclut l'outil **et** le mode dev continue de pointer vers l'arbre source. Le risque de divergence n'est pas nié, il est neutralisé autrement : la couche 2 ne réimplémente pas la couche 1, elle l'**invoque**. Le script d'amorçage devient une **extension de l'outil**, ce qui fait entrer dans ce plan le contrat d'extension jusqu'ici réservé à [`PLN-016`](PLN-016-installation-cycle-de-vie-clia.md) (étape 1.3), désormais étape 1.3 du présent plan ;
  - **notion de version reprise** (résolution de l'objection 3) : dans le dépôt source, la version du domaine métier **est** la version du système d'augmentation. C'est une simplification importante par rapport à la révision 1, qui postulait un troisième domaine de version à créer.
- **Révision 1 (2026-07-29, tâche 39)** : création.

## Intention

Lever **tout ce qui bloque** l'implémentation des trois premiers parcours d'installation, et rien de plus. [`ANL-015`](../analyses/ANL-015-faisabilite-installation-et-versions.md) établit que ces parcours ne butent sur aucun obstacle technique : ce qui manque, ce sont des **décisions** et les documents de conception qui en découlent. Ce plan produit ces décisions et ces documents. L'écriture de code relève de [`PLN-019`](PLN-019-implementation-installation-outil-et-depot.md).

Périmètre fixé par les tâches 39 et 40 de `.dev/session.md` : [`USE-001`](../usages/USE-001-rendre-l-outil-disponible-sur-son-poste.md) (rendre l'outil disponible sur son poste), [`USE-002`](../usages/USE-002-creer-un-depot-neuf-deja-equipe.md) (créer un dépôt neuf déjà équipé) et [`USE-003`](../usages/USE-003-connaitre-les-versions-disponibles.md) (connaître les versions disponibles). Les parcours de mise à niveau et de retour en arrière ([`USE-004`](../usages/USE-004-elever-un-depot-a-une-version-plus-recente.md), [`USE-005`](../usages/USE-005-ramener-un-depot-a-une-version-anterieure.md)) restent hors portée.

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
| [`PLN-016`](PLN-016-installation-cycle-de-vie-clia.md) | `résolu` | **partiellement exécuté** : l'étape 1.1 a produit [`ADR-010`](../adr/ADR-010-clia-setup-commandes-modes-installation.md) et l'étape 1.2 y est absorbée (décision D6). Son étape 1.3 (extension à des scripts externes) est reprise par le présent plan. Restent : 1.4 (type de ressource « interface CLI ») et le segment 2 pour les parcours de version |
| [`PLN-017`](PLN-017-cas-usage-acteurs-tracabilite.md) | `approuvé` | en cours : segment 1 exécuté, étapes 3.1 et 3.2 partiellement exécutées ; restent le segment 2 (skills, harnais), la fin du catalogue et le segment 4 |

Quatre statuts sont faux ou absents. Ce n'est pas anodin : le statut d'un plan est ce qui autorise ou interdit son exécution ([`CONSTITUTION.md`](../../CONSTITUTION.md)). L'étape 3.2 les corrige.

### Ce qui est acquis pour les trois parcours

- Le **socle de CLI** : squelette conforme ([`SPEC-001`](../specs/SPEC-001-convention-cli-bash.md)), dispatch, options globales, aide générée depuis une source unique (`src/clia.doc.yaml`), résolution de racine par `BASH_SOURCE`.
- La **définition du paquet distribuable** par zones et champ `type`, sans manifeste ([`ADR-010`](../adr/ADR-010-clia-setup-commandes-modes-installation.md), décision D6).
- La **résolution de la racine cible**, distincte de la racine de l'outil (décision D4).
- Le **motif d'installation** analysé et ses cinq fragilités connues ([`ANL-002`](../analyses/ANL-002-setup-installation.md)).
- Une **version de domaine déjà gérée** : `version.yaml` et la commande qui l'incrémente selon semver (`PLN-015`, exécuté).
- Les **trois parcours écrits**, avec leurs flux d'échec et leurs critères d'acceptation observables.

### Ce qui bloque, et pourquoi

Trois manques, tous de conception, tous établis par [`ANL-015`](../analyses/ANL-015-faisabilite-installation-et-versions.md) et précisés par les résolutions de la tâche 40 :

1. **la version** : le pas 5 de [`USE-002`](../usages/USE-002-creer-un-depot-neuf-deja-equipe.md) exige d'enregistrer dans le dépôt créé la version du système d'augmentation posée, et [`USE-003`](../usages/USE-003-connaitre-les-versions-disponibles.md) exige de les énumérer. La résolution humaine de l'objection 3 lève l'essentiel du constat C1 (« la version du système d'augmentation n'existe pas ») en observant que, **dans le dépôt source, la version du domaine métier est la version du système d'augmentation** : le dépôt ne produit rien d'autre. Reste à décider ce qu'un dépôt **utilisateur** enregistre (constat C2) ;
2. **la surface** : la surface de commandes contredit quatre des sept décisions d'`ADR-010` (constats C3 à C6), et les tâches 38 et 40 en donnent deux formulations différentes (voir 1.1) ;
3. **le contrat d'extension** : la résolution de l'objection 2 fait du script d'amorçage une **extension** de l'outil. Aucun contrat d'extension n'existe ; sans lui, l'outil gagnerait un appel improvisé vers un script externe, ce que la tâche 31 (objection 5) avait explicitement refusé en exigeant « un contrat strict et versionné d'interface ».

### Autorité de ce plan

`PLN-018` et [`PLN-019`](PLN-019-implementation-installation-outil-et-depot.md) prennent **autorité sur les parcours `USE-001` à `USE-003`**, selon le précédent par lequel `PLN-016` avait pris autorité sur `PLN-012` et `PLN-013`. [`PLN-016`](PLN-016-installation-cycle-de-vie-clia.md) conserve ce qui reste hors de cette portée : les parcours de mise à niveau et de retour en arrière, et le type de ressource « interface CLI ». Le breakpoint de validation d'`ADR-010` ouvert dans `.dev/session.md` est absorbé par le breakpoint 1 du présent plan, qui porte sur la révision du même ADR.

### Contraintes

Ordre de travail imposé ([`ADR-007`](../adr/ADR-007-architecture-systeme-augmentation.md)) : conception, puis méthodologie, puis implémentation. Déterminisme de l'outil ([`PDC-001`](../principes/PDC-001-determinisme-de-clia.md)) ; généricité du harnais ([`ADR-005`](../adr/ADR-005-fonction-scope-harnais.md), [`PDC-003`](../principes/PDC-003-separation-methode-domaine-genericite-harnais.md)) ; source de vérité unique ([`PDC-006`](../principes/PDC-006-source-de-verite-documentaire-unique.md)) ; autorité humaine sur l'irréversible ([`PDC-010`](../principes/PDC-010-point-entree-unique-autorite-humaine-irreversible.md)) ; l'agent n'opère aucune action git.

## Spécification du livrable

L'exécution de ce plan produira :

- `ADR-010` **v0.2.0** (révision : quatre décisions amendées, trois conservées, plus la question ouverte tranchée) ;
- un **ADR** définissant la version du système d'augmentation, sa découverte et la marque d'installation ;
- un **ADR** et son **contrat d'interface** pour l'extension de l'outil par des scripts externes ;
- un **REQ** et une **SPEC** couvrant les trois parcours ;
- le rattachement amont des trois `USE` aux exigences produites ;
- l'amendement de [`ACT-003`](../acteurs/ACT-003-installateur.md) et la correction des statuts de plans erronés.

Aucun code n'est écrit par ce plan.

## Plan proposé

### Segment 1 : Décisions

#### 1.1 Réviser `ADR-010` en v0.2.0

Amender quatre décisions, en conservant D1 (deux couches), D4 (résolution de la cible) et D6 (paquet distribuable) dans leur principe :

- **D3, surface de commandes** : passer du groupe `clia setup <init|upgrade|downgrade>` à la surface demandée par la tâche 38. Motiver le renversement plutôt que le taire : l'ADR avait écarté les commandes de premier niveau pour préserver la cohérence avec les groupes `res` et `ses`, et cette raison doit rester lisible. **Point à trancher** : la tâche 38 écrit `clia init`, `clia upgrade`, `clia downgrade` et `clia version ls` (premier niveau), tandis que la résolution de l'objection 2 à la tâche 40 écrit `clia setup ...` (groupe). Les deux formulations sont incompatibles et l'ADR doit en retenir une.
- **D5, git** : lever l'interdiction totale au profit d'une **frontière lecture / écriture**. Lecture autorisée sans réserve (énumérer des révisions et des étiquettes, extraire un arbre à une révision), ce dont [`USE-003`](../usages/USE-003-connaitre-les-versions-disponibles.md) a désormais besoin. Écriture limitée à un seul geste : **créer un dépôt à un emplacement qui n'en contient pas**. Aucun enregistrement, aucune étiquette, aucun changement de révision sur un dépôt existant. Justifier par [`CONSTITUTION.md`](../../CONSTITUTION.md), qui interdit git à l'agent et non à l'outil déterministe opéré par l'humain, et par [`PDC-010`](../principes/PDC-010-point-entree-unique-autorite-humaine-irreversible.md).
- **Question de conception laissée ouverte** : elle est tranchée. La création du dépôt versionné revient à l'outil, comme conséquence de la nouvelle D5 et du pas 3 de [`USE-002`](../usages/USE-002-creer-un-depot-neuf-deja-equipe.md).
- **D6, contenu du paquet** : **tranchée par l'objection humaine de la tâche 41**. Le paquet distribuable est le **harnais et ses actifs**, et **rien d'autre** : fichiers de harnais racine, gabarit d'intention, compétences, gabarits, couche type, squelette de version du domaine, et répertoires de ressources vides. L'**outil en est exclu**, ainsi que sa source documentaire. L'outil est installé **une fois, globalement**, par la couche 1, et s'utilise depuis n'importe où ; il **détecte** si le répertoire courant est un dépôt compatible. C'est le modèle de `tda`, où seuls les fichiers de harnais et les compétences sont copiés dans la cible, jamais le binaire.
- **D8, nouvelle décision : la couche 2 n'est pas une réimplémentation de la couche 1.** La commande d'installation de l'outil **invoque** le script d'amorçage plutôt que de dupliquer sa logique. Le script devient une **extension** de l'outil (voir 1.3). Motif : une seule implémentation de la logique d'installation, donc un seul endroit à corriger et à éprouver.
- **D9, nouvelle décision : détection d'un dépôt compatible.** L'outil, appelable depuis n'importe où, doit savoir reconnaître un dépôt équipé de celui qui ne l'est pas, et le faire avant d'agir. Décider **ce qu'il cherche** (voir 1.2) et **ce qu'il fait** quand la réponse est non : refuser, ou proposer d'équiper. Trois parcours en dépendent (flux `2b` de `USE-002`, `3a` de `USE-003`, et les parcours de version hors portée).
- **Mode de pose des fichiers** : le paquet est-il **copié** dans la cible, ou **lié** à l'arbre source quand l'outil est en mode dev ? `tda` offre les deux, la seconde forme rendant toute évolution du harnais immédiatement effective dans les dépôts équipés, au prix d'une cible qui n'est plus autonome. Trancher, et si les deux sont retenues, dire laquelle est le défaut.
- **D2, périmètre d'installation** : statuer sur le mode multi-utilisateur (recommandation R4 d'`ANL-015`). Trois options documentées, la recommandation étant de le sortir du périmètre immédiat : il ne sert aucun des parcours retenus, il exige des privilèges élevés, et il se heurte au mode dev, dont l'exécution pointe vers un arbre source situé dans le répertoire personnel de l'installateur.

Deux points de surface restent à fixer dans cette révision, faute de quoi l'implémentation les fixerait par défaut : le **nom de la commande d'amorçage** (`install` au cas d'usage 1 de la tâche 38, `init` en introduction de la même tâche, constat C8 d'`ANL-015`) et le **comportement devant une cible non vide** (flux `2c` de `USE-002`).

#### 1.2 Nouvel ADR : version du système d'augmentation, découverte et marque d'installation

Acter la résolution de l'objection 3 à la tâche 40, qui simplifie sensiblement les recommandations R1 et R2 d'[`ANL-015`](../analyses/ANL-015-faisabilite-installation-et-versions.md) :

- **dans le dépôt source, la version du domaine métier est la version du système d'augmentation.** Le domaine de ce dépôt **est** le système d'augmentation : `version.yaml` en porte donc déjà la version, et la commande de publication existante l'incrémente. Aucun troisième domaine de version n'est à créer, contrairement à ce que postulait la révision 1 de ce plan. Amender [`ADR-007`](../adr/ADR-007-architecture-systeme-augmentation.md) pour énoncer cette coïncidence, qui vaut pour le dépôt source et **pour lui seul** : dans un dépôt utilisateur, les deux versions sont distinctes et sans rapport ;
- **la découverte des versions disponibles** ([`USE-003`](../usages/USE-003-connaitre-les-versions-disponibles.md)) : les versions publiées sont les **étiquettes** du dépôt source, chacune correspondant à un état de `version.yaml`. Traiter les cas que le parcours exige : aucune version publiée (le dépôt n'en porte aucune aujourd'hui), et arbre source à un état de travail ne correspondant à aucune version publiée, qui est donc le cas courant et non l'exception ;
- **la marque d'installation** dans un dépôt utilisateur : un fichier d'état dans la zone de développement de la cible, portant la version posée, la date de l'opération et l'empreinte des fichiers écrits. C'est la première des deux branches proposées par la résolution humaine ;
- **ce qui rend un dépôt compatible** (décision D9) : la marque d'installation est le candidat naturel, puisqu'elle n'existe que là où l'outil est passé. Traiter les deux cas qu'elle ne couvre pas : un dépôt équipé **avant** l'existence de la marque, et un dépôt dont les fichiers de harnais ont été posés à la main. Décider si la présence des fichiers de harnais vaut alors reconnaissance, ou si la marque seule fait foi et si son absence est un état à régulariser ;
- **la déduction depuis les frontmatters**, seconde branche proposée : la retenir non comme source de vérité mais comme **contrôle de cohérence**. Un ensemble de versions par ressource ne définit pas une version d'ensemble ([`ADR-004`](../adr/ADR-004-ressources-livrables.md) a aboli l'agrégat), mais il permet de détecter qu'un dépôt est dans un état mixte ou que sa marque ment. Les deux mécanismes sont donc complémentaires, non concurrents ;
- **ce que l'empreinte sert** : détecter qu'une ressource d'augmentation a été modifiée localement, seul moyen d'éviter la perte de travail lors d'une mise à niveau ultérieure. Ce plan la fait écrire et vérifier ; son exploitation en cas de conflit relève des parcours hors portée ;
- **pourquoi ce fichier ne ressuscite pas le manifeste aboli** : celui-ci centralisait les versions **de la source**, celui-là enregistre l'état **d'une installation**. Ni le même lieu, ni le même propriétaire, ni la même durée de vie. Le dire explicitement, faute de quoi l'objection reviendra à chaque relecture.

#### 1.3 Nouvel ADR : contrat d'extension de l'outil

Rendu nécessaire par la décision D8. Reprend l'étape 1.3 de [`PLN-016`](PLN-016-installation-cycle-de-vie-clia.md) et la directive de la tâche 31 (objection 5) : « mettre en place un contrat strict et versionné d'interface ».

Acter le **contrat minimal** qu'un script externe doit respecter pour être invoqué par l'outil : emplacement et mode de découverte, forme d'invocation et de passage des arguments, codes de retour et convention de flux de sortie ([`SPEC-001`](../specs/SPEC-001-convention-cli-bash.md), [`REQ-001`](../requis/REQ-001-convention-cli-bash.md)), déclaration de son aide dans la source documentaire pour rester découvrable ([`REQ-001`](../requis/REQ-001-convention-cli-bash.md), cohérence dispatch et documentation), version du contrat et comportement en cas d'incompatibilité, et garde-fous de déterminisme ([`PDC-001`](../principes/PDC-001-determinisme-de-clia.md)).

Le script d'amorçage est la **première extension** et sert de cas d'épreuve du contrat. Réserve à énoncer dans l'ADR : le contrat est conçu pour une extension livrée avec l'outil ; l'ouverture à des extensions tierces (confiance, exécution de code arbitraire) reste hors portée.

**BREAKPOINT 1.** Arrêt après 1.3. L'humain valide les trois ADR. Ce qui suit en dépend entièrement : les exigences et spécifications du segment 2 énoncent le contrat de ce que ces décisions posent, et [`PLN-019`](PLN-019-implementation-installation-outil-et-depot.md) l'implémente.

### Segment 2 : Exigences et spécifications

#### 2.1 Exigences des trois parcours

Produire les exigences ([`skl-010`](../skills/skl-010-requis/SKILL.md)) couvrant `USE-001`, `USE-002` et `USE-003`, dérivées de leurs critères d'acceptation : idempotence réconciliante, retrait déterministe, vérification préalable des dépendances, refus sans effet de bord, atomicité de l'écriture, non-altération du contenu de domaine de la cible, écriture de la marque d'installation, énumération déterministe et en lecture seule des versions. Chaque exigence déclare le parcours qu'elle satisfait.

Trancher à cette étape entre amender [`REQ-002`](../requis/REQ-002-cli-clia.md) et produire un requis distinct. Recommandation : un requis distinct pour le script d'amorçage et son contrat d'extension, un amendement de `REQ-002` pour les commandes de l'outil.

#### 2.2 Spécifications d'interface

Produire les spécifications ([`skl-009`](../skills/skl-009-specification/SKILL.md)) : grammaire d'invocation, sorties, codes de retour, effets sur le système de fichiers, conditions d'échec. Amender [`SPEC-002`](../specs/SPEC-002-cli-clia.md) pour les commandes de l'outil, produire une spécification distincte pour le script d'amorçage et le contrat d'extension. Prolonger la table de traçabilité existante vers l'amont.

#### 2.3 Rattachement amont

Renseigner la relation `satisfait` dans [`USE-001`](../usages/USE-001-rendre-l-outil-disponible-sur-son-poste.md), [`USE-002`](../usages/USE-002-creer-un-depot-neuf-deja-equipe.md) et [`USE-003`](../usages/USE-003-connaitre-les-versions-disponibles.md), qui déclarent aujourd'hui qu'aucune exigence ne les sert. Forme provisoire décidée par [`ADR-012`](../adr/ADR-012-ressource-cas-d-usage.md) : liens markdown dans la section `## Relations`.

### Segment 3 : Cohérence

#### 3.1 Amender `ACT-003`

Recommandation R9 d'`ANL-015` : la définition de [`ACT-003`](../acteurs/ACT-003-installateur.md) porte sur l'équipement d'un dépôt, alors que `USE-001` porte sur l'équipement d'un poste, qui en est la précondition. Une phrase suffit.

#### 3.2 Corriger les statuts de plans erronés

D'après le tableau du contexte : ajouter le champ `status` manquant à `PLN-006` ; passer `PLN-011` à `exécuté` ; passer `PLN-014` à `exécuté` ; passer `PLN-008` à `remplacé par PLN-018 et PLN-019` ; mettre à jour `PLN-016` pour refléter son exécution partielle et la portée que le présent plan lui retire. Aucune autre modification de ces fichiers.

## Objections de l'agent IA

Aucune objection ouverte actuellement. Les points restés indécis (formulation de la surface de commandes, nom de la commande d'amorçage, comportement devant une cible non vide, sort du mode multi-utilisateur) ne sont pas des objections mais des **décisions à prendre**, inscrites comme telles à l'étape 1.1 et soumises à l'humain au breakpoint 1.

## Relations

- **Réalise** : [`USE-001`](../usages/USE-001-rendre-l-outil-disponible-sur-son-poste.md), [`USE-002`](../usages/USE-002-creer-un-depot-neuf-deja-equipe.md) et [`USE-003`](../usages/USE-003-connaitre-les-versions-disponibles.md), en préparant leur implémentation.
- **Suivi de** : [`PLN-019`](PLN-019-implementation-installation-outil-et-depot.md), qui implémente ce que ce plan décide.
- **Dérive de** : [`ANL-015`](../analyses/ANL-015-faisabilite-installation-et-versions.md) (recommandations R1 à R4, R8, R9).
- **Réduit la portée de** : [`PLN-016`](PLN-016-installation-cycle-de-vie-clia.md), dont il reprend l'étape 1.3.

## Note sur les objections humaines

Les objections de l'humain sur ce plan ne sont pas consignées ici mais dans `.dev/session.md`.
