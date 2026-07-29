---
type: plan
version: 0.2.0
title: "Cas d'usage, acteurs et traçabilité amont (mise en oeuvre d'ANL-014)"
status: résolu
---

# PLN-017 - Cas d'usage, acteurs et traçabilité amont

## Changelog

- **Révision 2 (2026-07-29, tâche 35)** : traitement des objections humaines consignées à la tâche 35 de `.dev/session.md`. Les six objections de l'agent sont **résolues** et la portée du plan est resserrée :
  - **portée** : les tests et la mesure de couverture sortent du plan (objection humaine générale). R5 est retirée, R4 est réduite à son volet amont. Le plan s'arrête à la conception, à la méthodologie et aux catalogues ;
  - **objection 1** : [`BUG-007`](../bugs/BUG-007-resource-sh-modele-abroge.md) est ouvert pour l'écart de `src/lib/resource.sh` au modèle de ressources, et le plan continue sans autre modification. L'ancienne étape 4.0 (réconciliation du module) est **supprimée** ;
  - **objection 2** : forme **provisoire** assumée pour les relations, avec dette nommée. L'inauguration de la couche relations pour tout le corpus n'est pas entreprise ici ;
  - **objection 3** : `PLN-017` est traité en priorité et fait autorité sur le modèle ; [`PLN-016`](PLN-016-installation-cycle-de-vie-clia.md) est ajusté en conséquence (nouvelle étape 3.3). La collision disparaît par ailleurs d'elle-même, les tests sortant de ce plan ;
  - **objection 4** : une ressource est **indépendante des outils qui la manipulent**. Un `USE` ne dépend donc pas de `clia`, et le cas d'usage du parcours d'installation **réintègre** le catalogue initial : il décrit un but d'acteur, pas des commandes. La dépendance à [`ADR-010`](../adr/ADR-010-clia-setup-commandes-modes-installation.md) tombe. Le gabarit est purgé de ses éléments liés à l'outil (codes de retour) ;
  - **objection 5** : les acteurs ne vont pas dans `ARCHITECTURE.md` mais dans un **nouveau type de ressource indépendant** `ACT`. Le plan produit donc deux types (`ACT` et `USE`), deux ADR et deux skills ;
  - **objection 6** : `ARCHITECTURE.md` est **hors portée**. Toutes les étapes qui le touchaient sont supprimées.
  - **forme** : application de la convention de références croisées de la tâche 34 (toute citation d'un autre document porte un lien markdown vers ce document, section quand elle est identifiable).
- **Révision 1 (2026-07-28, tâche 34)** : création, en mise en oeuvre des sept recommandations d'[`ANL-014`](../analyses/ANL-014-cas-usage-et-acteurs-de-clia.md).

## Intention

Mettre en oeuvre les recommandations d'[`ANL-014-cas-usage-et-acteurs-de-clia`](../analyses/ANL-014-cas-usage-et-acteurs-de-clia.md) retenues par l'humain. L'analyse établit que la chaîne de conception du dépôt est rigoureuse en son milieu (`ADR` vers `REQ` vers `SPEC` vers code) mais **amputée en amont** : rien ne dit qui veut quoi et pourquoi. Le besoin n'entre aujourd'hui dans le système que par `.dev/session.md`, fichier éphémère archivé sans index d'usages, si bien que l'énoncé du besoin se perd à la clôture de session (constat [C8](../analyses/ANL-014-cas-usage-et-acteurs-de-clia.md#constats)).

Le but de ce plan est d'ajouter les **deux maillons manquants de la couche type**, l'acteur (`ACT`) et le cas d'usage (`USE`), de constituer leurs catalogues initiaux depuis l'existant, et de **rattacher l'amont** de la chaîne de conception à ces maillons. Le volet aval (tests d'acceptation, mesure de couverture) est explicitement remis à plus tard.

## Contexte

- **Source de la demande** : tâches 34 et 35 de `.dev/session.md`. La tâche 34 demande un plan de mise en oeuvre d'[`ANL-014`](../analyses/ANL-014-cas-usage-et-acteurs-de-clia.md) ; la tâche 35 en résout les objections et resserre la portée.
- **Recommandations couvertes** : [R1](../analyses/ANL-014-cas-usage-et-acteurs-de-clia.md#recommandations-priorisées) (créer le type `USE`), R2 (gabarit « but utilisateur », format court), R3 (catalogue d'acteurs, ici sous forme de type de ressource autonome), R4 **volet amont uniquement** (chaque `REQ` déclare le ou les `USE` qu'il sert), R6 (catalogue initial dérivé de l'existant), R7 (un plan déclare les `USE` qu'il réalise).
- **Recommandations écartées de ce plan** : R5 (tests d'acceptation dérivés des `USE`) et le volet aval de R4 (rattachement usage vers test, mesure de couverture). Motif : décision humaine de la tâche 35, cohérente avec l'objection A de la tâche 34 (« on est à l'étape de conception et de mise en place minimale des fonctionnalités permettant de tester `clia` en situation réelle, donc on remet à plus tard tout ce qui est aval »).
- **Priorité déclarée** : `init` et `upgrade`/`downgrade`, portés par [`PLN-016`](PLN-016-installation-cycle-de-vie-clia.md). Ce plan reste donc volontairement court et ne prescrit aucune modification de code.
- **Ordre de travail imposé** ([`ADR-007`](../adr/ADR-007-architecture-systeme-augmentation.md)) : recherche et préconception, puis conception, puis méthodologie (harnais et skills), puis implémentation. La segmentation ci-dessous respecte cet ordre.
- **Règle d'indépendance des ressources** (résolution humaine, objection 4 de la tâche 35) : une ressource est **indépendante des outils et des instruments qui la produisent, la manipulent ou l'exploitent**. Un `USE` décrit un but d'acteur et l'état du monde avant et après, jamais une invocation de `clia`. Cette règle est gravée en 1.2 et conditionne le gabarit.
- **État de la couche relations** (constaté le 2026-07-29) : [`.dev/resource-types.yaml`](../resource-types.yaml) déclare six relations, mais aucun frontmatter du dépôt n'en porte, et les références croisées sont écrites en texte. La résolution humaine retient une **forme provisoire** : les relations s'écrivent en clair dans les documents, sous forme de liens markdown, et l'instanciation d'une couche de relations lisible par un programme reste une **dette nommée**, hors portée de ce plan.
- **Dette assumée sur `ARCHITECTURE.md`** : ce harnais porte une section « Acteurs et rôles » qui range `clia` parmi les acteurs alors qu'il est le système décrit (constat [C2](../analyses/ANL-014-cas-usage-et-acteurs-de-clia.md#constats)). Sa correction et sa réconciliation avec le catalogue `ACT` sont **hors portée** par décision humaine (objection 6). Conséquence acceptée : deux descriptions d'acteurs coexisteront temporairement, l'une de gouvernance dans le harnais, l'autre de conception dans `.dev/acteurs`.
- **Contraintes de gouvernance** : généricité du harnais et absence d'information de domaine ([`ADR-005`](../adr/ADR-005-fonction-scope-harnais.md), [`PDC-003`](../principes/PDC-003-separation-methode-domaine-genericite-harnais.md)) ; source de vérité documentaire unique ([`PDC-006`](../principes/PDC-006-source-de-verite-documentaire-unique.md)) ; traçabilité et versionnage atomique ([`PDC-009`](../principes/PDC-009-tracabilite-et-versionnage-atomique.md)) ; l'agent n'édite jamais les fichiers en édition humaine uniquement et n'opère aucune action git.
- **Hors périmètre explicite** : correction de `doc/cli/` (constat [C7](../analyses/ANL-014-cas-usage-et-acteurs-de-clia.md#constats), relève d'un rapport de bogue distinct) ; correction de `src/lib/resource.sh` (tracée par [`BUG-007`](../bugs/BUG-007-resource-sh-modele-abroge.md)) ; toute modification de `ARCHITECTURE.md`, de `clia` et de `test/`.

## Spécification du livrable

L'exécution de ce plan produira :

- deux **ADR** : `ADR-011` définissant le type de ressource `ACT` (acteur), `ADR-012` définissant le type de ressource `USE` (cas d'usage), son gabarit et sa place dans la chaîne de conception ;
- deux entrées dans [`.dev/resource-types.yaml`](../resource-types.yaml) (`acteur` et `usage`) et les relations correspondantes ;
- deux **skills** : `skl-016-acteur` et `skl-017-cas-d-usage` ;
- l'amendement de [`CLAUDE.md`](../../CLAUDE.md) (table des livrables) et des skills producteurs concernés ([`skl-003`](../skills/skl-003-plan-de-travail/SKILL.md), [`skl-010`](../skills/skl-010-requis/SKILL.md), [`skl-009`](../skills/skl-009-specification/SKILL.md)) ;
- un **catalogue d'acteurs** dans `.dev/acteurs/` ;
- un **catalogue initial de cas d'usage** dans `.dev/usages/`, dérivé de l'existant ;
- le **rattachement amont** des exigences existantes aux cas d'usage qu'elles servent.

Aucun code n'est modifié par ce plan.

## Plan proposé

### Segment 1 : Conception (R1, R2, R3, R7)

#### 1.1 `ADR-011` : le type de ressource `ACT` (acteur)

Produire l'ADR ([`skl-006`](../skills/skl-006-adr/SKILL.md)) actant :

- **le type** : un `ACT` décrit **un rôle**, pas une personne : sa responsabilité, ses buts, ses préconditions d'accès, ses modes d'échec caractéristiques et ses intérêts. Une même personne peut tenir plusieurs rôles, ce que le dépôt vérifie déjà (constat [C2](../analyses/ANL-014-cas-usage-et-acteurs-de-clia.md#constats) et note de la [typologie d'`ANL-014`](../analyses/ANL-014-cas-usage-et-acteurs-de-clia.md#typologie-des-utilisateurs-et-des-parties-prenantes) : opérateur, installateur et mainteneur sont aujourd'hui la même personne, et se sépareront) ;
- **pourquoi un type autonome** plutôt qu'une section d'ADR ou de harnais : l'acteur est cité par les `USE`, les `REQ` et les `PLN` ; en faire une ressource adressable et versionnée lui donne un identifiant stable et une seule source de vérité ([`PDC-006`](../principes/PDC-006-source-de-verite-documentaire-unique.md)) ;
- **les catégories** : acteur primaire, acteur secondaire, partie prenante hors scène, reprises de la [typologie d'`ANL-014`](../analyses/ANL-014-cas-usage-et-acteurs-de-clia.md#typologie-des-utilisateurs-et-des-parties-prenantes) ;
- **la règle de séparation méthode / domaine** : les acteurs du **système d'augmentation** (opérateur, agent, installateur, mainteneur) sont génériques et transposables ; les acteurs **de domaine** d'un dépôt hôte sont propres à ce dépôt. La règle dit lesquels le harnais fournit et comment un dépôt hôte ajoute les siens sans les mélanger ([`ADR-005`](../adr/ADR-005-fonction-scope-harnais.md), [`PDC-003`](../principes/PDC-003-separation-methode-domaine-genericite-harnais.md), risque déjà consigné par [`BUG-003`](../bugs/BUG-003-frontiere-methode-domaine-sous-tension.md)) ;
- **le gabarit** : frontmatter (`type: acteur`, `version`, `title`, `status`, `date`) ; catégorie ; portée (méthode ou domaine) ; responsabilité ; buts poursuivis ; intérêts ; ce que l'acteur ne fait pas ; relations.

#### 1.2 `ADR-012` : le type de ressource `USE` (cas d'usage)

Produire l'ADR ([`skl-006`](../skills/skl-006-adr/SKILL.md)) actant :

- **le type** : un `USE` décrit un **but d'acteur atteint de bout en bout**, à la question *qui veut quoi et pourquoi*. Il ne se confond ni avec le `REQ` (*ce que le système doit garantir*) ni avec la `SPEC` (*comment l'interface se comporte*). Motiver le refus de la fusion dans `REQ` par [`FND-015`](../fondations/FND-015-requis-et-specification.md), [`FND-018`](../fondations/FND-018-cas-usage-besoins-utilisateurs.md) et le contre-exemple relevé par [`ANL-011`](../analyses/ANL-011-specs-reqs-livrables-tda-vs-clia.md) ;
- **sa place dans la chaîne** : `USE` en amont de `REQ`, au niveau des exigences de parties prenantes, aujourd'hui absent (constat [C1](../analyses/ANL-014-cas-usage-et-acteurs-de-clia.md#constats)) ;
- **la règle d'indépendance aux outils** (résolution humaine de la tâche 35) : un `USE` nomme le système comme boîte noire et l'état du monde avant et après ; il ne nomme **aucune commande, aucun script, aucun code de retour**. Conséquence directe : un `USE` reste valide quand l'outil change, et il peut être écrit avant que l'outil existe ;
- **le gabarit** (R2), format court par défaut : frontmatter (`type: usage`, `version`, `title`, `status`, `date`, acteur principal) ; en-tête (niveau, portée, parties prenantes et intérêts, préconditions, garantie de succès, garantie minimale) ; flux nominal numéroté ; flux alternatifs et d'échec avec issue observable pour l'acteur ; critères d'acceptation exprimés en état observable ; relations ;
- **les deux règles d'altitude** : titre en verbe à l'infinitif orienté but de l'acteur (« Ouvrir une session de travail », jamais « Commande `ses open` ») ; interdiction du niveau sous-fonction comme unité de fichier, pour prévenir l'anti-motif de décomposition fonctionnelle (constat [C3](../analyses/ANL-014-cas-usage-et-acteurs-de-clia.md#constats)) ;
- **la relation plan vers usage** (R7) : un `PLN` déclare le ou les `USE` qu'il réalise, de sorte que le besoin cesse de se perdre à la clôture de session (constat [C8](../analyses/ANL-014-cas-usage-et-acteurs-de-clia.md#constats)) ;
- **les non-décisions** reprises d'[`ANL-014`](../analyses/ANL-014-cas-usage-et-acteurs-de-clia.md#ce-que-la-présente-analyse-ne-recommande-pas) : pas de user stories, pas de Gherkin ni de cadre BDD, pas de fusion dans `REQ`.

#### 1.3 Couche type et forme provisoire des relations

Ajouter à [`.dev/resource-types.yaml`](../resource-types.yaml) :

- l'entrée `acteur` (prefix `ACT`, emplacement `.dev/acteurs`, nommage `sequence`, skill `skl-016-acteur`, édition `co`) ;
- l'entrée `usage` (prefix `USE`, emplacement `.dev/usages`, nommage `sequence`, skill `skl-017-cas-d-usage`, édition `co`) ;
- les deux relations manquantes au vocabulaire : `utilise` (un `ACT` utilise un `USE` pour atteindre un but) et `satisfait` (un `REQ` satisfait un `USE` d'un `ACT`). Ces deux relations transcrivent littéralement les deux énoncés demandés à la tâche 34 (objection C). Aucun type `FONCTIONNALITÉ` n'est créé : la fonctionnalité est déjà portée par le `REQ`, qui énonce ce que le système doit garantir.

**Forme provisoire retenue** (résolution humaine, objection 2) : les relations s'écrivent **dans le corps des documents**, en liens markdown, dans une section `## Relations` normalisée par les deux skills du segment 2, avec les deux tournures ci-dessus. Le frontmatter ne porte que l'acteur principal d'un `USE`. **Dette nommée** : la couche relations lisible par un programme (relations typées en frontmatter pour tout le corpus, validation des références pendantes) reste à instancier ; elle n'est ni conçue ni implémentée ici. Ce choix est un compromis assumé de vitesse de conception, à revoir quand la priorité `init` et `upgrade`/`downgrade` sera livrée.

**BREAKPOINT 1.** Arrêt après 1.3. L'humain valide le modèle (les deux types, les gabarits, la règle de séparation méthode / domaine, la règle d'indépendance aux outils et la forme provisoire des relations) avant toute production de masse. Ce qui suit crée deux répertoires, deux skills et une quinzaine de fichiers : ces effets sont coûteux à défaire si le modèle change.

### Segment 2 : Méthodologie (R2, R3, R7)

#### 2.1 `skl-016-acteur`

Produire le skill ([`skl-001`](../skills/skl-001-skill-writer/SKILL.md) comme méta-skill) : quand l'utiliser et quand ne pas l'utiliser, processus, critères de qualité, structure du livrable avec le gabarit décidé en 1.1. Graver comme critères vérifiables la règle de séparation méthode / domaine et l'interdiction de nommer une personne à la place d'un rôle. Skill générique, sans information de domaine ([`ADR-005`](../adr/ADR-005-fonction-scope-harnais.md)).

#### 2.2 `skl-017-cas-d-usage`

Produire le skill ([`skl-001`](../skills/skl-001-skill-writer/SKILL.md) comme méta-skill) avec le gabarit décidé en 1.2. Graver comme critères vérifiables : les deux règles d'altitude, la règle d'indépendance aux outils (aucun nom de commande dans un `USE`), l'obligation d'un acteur principal existant dans `.dev/acteurs`, et la forme de la section `## Relations`.

#### 2.3 Amendement des harnais et des skills producteurs

- [`CLAUDE.md`](../../CLAUDE.md) : deux lignes dans la table des livrables (`ACT` et `USE`), qui est une **vue** de [`.dev/resource-types.yaml`](../resource-types.yaml) et non une source parallèle ([`PDC-006`](../principes/PDC-006-source-de-verite-documentaire-unique.md)), et mention du maillon amont dans la chaîne de conception.
- [`skl-003-plan-de-travail`](../skills/skl-003-plan-de-travail/SKILL.md) : un plan déclare le ou les `USE` qu'il réalise (R7).
- [`skl-010-requis`](../skills/skl-010-requis/SKILL.md) : un `REQ` déclare le ou les `USE` qu'il satisfait, et pour quel acteur (R4 amont).
- [`skl-009-specification`](../skills/skl-009-specification/SKILL.md) : rappel que la table de traçabilité existante se prolonge désormais vers l'amont, via le `REQ`.
- `ARCHITECTURE.md` : **non modifié** (objection 6).

### Segment 3 : Catalogues initiaux (R3, R6)

#### 3.1 Catalogue d'acteurs

Produire les `ACT` du système d'augmentation, à partir de la [typologie d'`ANL-014`](../analyses/ANL-014-cas-usage-et-acteurs-de-clia.md#typologie-des-utilisateurs-et-des-parties-prenantes) : opérateur du dépôt, agent IA, installateur, mainteneur du système d'augmentation (acteurs primaires) ; système de fichiers et dépendances externes (acteurs secondaires) ; destinataire des livrables, collaborateur futur, éditeur du modèle d'agent, entreprise (parties prenantes). Chacun porte sa catégorie et sa portée (méthode ou domaine). `clia` n'est **pas** un acteur : c'est le système décrit.

#### 3.2 Catalogue de cas d'usage

Six à dix `USE` de niveau « but utilisateur » couvrent le système actuel. La matière existe déjà et n'attend qu'à être réorganisée par but : le flux principal d'`ARCHITECTURE.md` (lu, non modifié), les transitions d'[`ADR-006`](../adr/ADR-006-gestion-des-sessions.md), les conditions d'échec de [`SPEC-002`](../specs/SPEC-002-cli-clia.md) et de [`REQ-002`](../requis/REQ-002-cli-clia.md), et les deux capacités attendues énoncées dans `.dev/session.md`. Ordre de production, par valeur décroissante :

1. **parcours de session** (acteur : opérateur du dépôt) : ouvrir une session de travail, clore une session de travail, inspecter l'état courant ;
2. **parcours d'installation** (acteur : installateur) : équiper un dépôt du système d'augmentation, faire évoluer un dépôt équipé, revenir à l'état antérieur. Ces trois `USE` sont **réintégrés** au catalogue par la résolution humaine de l'objection 4 : décrits comme buts d'acteur, ils ne dépendent d'aucune décision de [`ADR-010`](../adr/ADR-010-clia-setup-commandes-modes-installation.md) et couvrent les deux livrables attendus de la session ;
3. **parcours de gouvernance** (acteurs : opérateur, agent IA) : soumettre un problème et obtenir un plan, objecter à un plan, reprendre après un breakpoint ;
4. **parcours d'inspection** (acteurs : opérateur, mainteneur) : inspecter les ressources et leurs versions, publier une version métier.

Chaque `USE` porte ses flux d'échec et ses critères d'acceptation en état observable, sans quoi le segment 4 n'a pas de matière.

#### 3.3 Conséquence sur `PLN-016`

`PLN-017` faisant autorité sur le modèle (résolution humaine, objection 3), réviser [`PLN-016`](PLN-016-installation-cycle-de-vie-clia.md) pour qu'il **déclare les `USE` du parcours d'installation qu'il réalise** (R7), sans changer sa portée ni ses décisions. La collision relevée à la révision 1 (deux harnais de test pour le même parcours) est **caduque** : les tests sont hors portée de `PLN-017`, et `PLN-016` conserve donc entièrement son segment de vérification.

**BREAKPOINT 2.** Arrêt après 3.3. L'humain valide les deux catalogues avant que les rattachements amont ne s'y accrochent : un `USE` mal découpé propage son défaut dans tout ce qui le cite.

### Segment 4 : Traçabilité amont (R4, volet amont)

#### 4.1 Rattachement amont des exigences

Renseigner, dans la forme décidée en 1.3, les relations des ressources existantes : chaque `REQ` déclare le ou les `USE` qu'il satisfait et pour quel acteur ; chaque `USE` déclare son acteur principal et les parties prenantes concernées. Périmètre : [`REQ-001`](../requis/REQ-001-convention-cli-bash.md) et [`REQ-002`](../requis/REQ-002-cli-clia.md).

Le volet aval (chaque `USE` déclare les tests qui le démontrent, chaque test nomme le `USE` couvert, mesure des deux couvertures) est **hors portée** et reste à planifier ultérieurement.

## Objections de l'agent IA

Aucune objection ouverte actuellement. Les six objections de la révision 1 sont résolues par la tâche 35 de `.dev/session.md` ; leur traitement est détaillé au Changelog ci-dessus. Deux points restent tracés hors de ce plan, par décision humaine et non par objection : [`BUG-007`](../bugs/BUG-007-resource-sh-modele-abroge.md) (écart de `src/lib/resource.sh` au modèle de ressources) et la dette nommée sur la couche relations (voir 1.3).

## Note sur les objections humaines

Les objections de l'humain sur ce plan ne sont pas consignées ici mais dans `.dev/session.md`.
