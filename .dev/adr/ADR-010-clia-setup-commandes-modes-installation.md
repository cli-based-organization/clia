---
type: adr
version: 0.3.0
title: "Commandes et modes d'installation de `clia` (deux couches, `clia setup`)"
status: Accepté
date: 2026-07-29
---

# ADR-010 - Commandes et modes d'installation de `clia` (deux couches)

- **Décideurs** : Jérémy Viau-Trudel (humain), agent IA
- **Sources** : version 0.1.0 (`PLN-016` segment 1, tâche 31) ; révision 0.2.0 : [`PLN-018`](../plans/PLN-018-preparation-installation-outil-et-depot.md) étape 1.1 (tâches 38 à 42 de `.dev/session.md`), [`ANL-015`](../analyses/ANL-015-faisabilite-installation-et-versions.md), [`ANL-002`](../analyses/ANL-002-setup-installation.md), [`FND-008`](../fondations/FND-008-installateurs-packaging.md)

> **Révision 0.2.0 (2026-07-29).** Quatre décisions amendées (D2, D3, D5, D6), trois conservées (D1, D4, D7 dans son principe), deux ajoutées (D8, D9), et la question de conception laissée ouverte par la version 0.1.0 tranchée. Motifs : les cinq parcours d'usage écrits aux tâches 38 et suivantes, et les résolutions humaines des tâches 40 et 41.
>
> **Révision 0.3.0 (2026-07-29, tâche 43).** La décision **D3 est rétablie dans sa forme d'origine** : la couche 2 est exposée par le groupe `clia setup`, non par des commandes de premier niveau. C'est le seul point sur lequel le feedback humain renverse la révision 0.2.0 ; les autres décisions sont **acceptées telles quelles**, et le statut passe de `Proposé` à `Accepté`.
>
> Les décisions amendées restent signalées comme telles, avec la raison de leur renversement : une décision dont on efface le motif d'origine devient impossible à réviser en connaissance de cause.

## Contexte

La session doit livrer trois capacités, écrites comme parcours d'acteur : rendre l'outil disponible sur un poste ([`USE-001`](../usages/USE-001-rendre-l-outil-disponible-sur-son-poste.md)), créer un dépôt neuf déjà équipé ([`USE-002`](../usages/USE-002-creer-un-depot-neuf-deja-equipe.md)), et connaître les versions disponibles et installée ([`USE-003`](../usages/USE-003-connaitre-les-versions-disponibles.md)). La mise à niveau et le retour en arrière ([`USE-004`](../usages/USE-004-elever-un-depot-a-une-version-plus-recente.md), [`USE-005`](../usages/USE-005-ramener-un-depot-a-une-version-anterieure.md)) restent hors de la portée immédiate, mais les décisions prises ici ne doivent pas les rendre impossibles.

Deux préoccupations distinctes se dégagent, qu'il faut nommer avant de spécifier quoi que ce soit :

1. rendre la commande disponible pour l'utilisateur sur sa machine (installation de l'outil) ;
2. poser et faire évoluer le système d'augmentation à l'intérieur d'un dépôt cible (installation du contenu d'augmentation dans un projet).

Le dépôt `ticket-driven-ai` traite déjà ces deux préoccupations et sert de modèle explicite (tâche 41). Son enseignement principal, vérifié dans son code : **le binaire n'est jamais copié dans la cible**. Seuls les fichiers de harnais et les compétences le sont.

Contraintes directrices : déterminisme de l'outil ([`ADR-007`](ADR-007-architecture-systeme-augmentation.md), [`PDC-001`](../principes/PDC-001-determinisme-de-clia.md)) ; harnais générique et réutilisable ([`ADR-005`](ADR-005-fonction-scope-harnais.md), [`PDC-003`](../principes/PDC-003-separation-methode-domaine-genericite-harnais.md)) ; autorité humaine sur l'irréversible ([`PDC-010`](../principes/PDC-010-point-entree-unique-autorite-humaine-irreversible.md)).

## Décision (résumé)

> L'installation s'organise en **deux couches**. La **couche 1** (installation de l'outil) est un script d'amorçage `setup.sh`, en mode **dev + permanent + local**, corrigé selon [`ANL-002`](../analyses/ANL-002-setup-installation.md). La **couche 2** (installation du contenu d'augmentation dans un dépôt cible) est exposée par le groupe **`clia setup <init|versions>`**, qui **n'en réimplémente pas la logique** mais **invoque** le script d'amorçage en tant qu'**extension**. Le **paquet distribuable** est le **harnais et ses actifs seulement** : l'outil n'est **jamais** copié dans une cible. Installé une fois et globalement, il **détecte** si le répertoire courant est un dépôt équipé. La comparaison de versions et la source de distribution restent celles de la version 0.1.0, précisées par [`ADR-013`](ADR-013-version-augmentation-et-marque-installation.md).

## Décisions détaillées

### D1 - Deux couches distinctes (conservée)

- **Décision** : séparer explicitement l'installation de l'outil (couche 1) et l'installation du contenu d'augmentation dans un dépôt (couche 2).
  - **Couche 1 (outil)** : script `setup.sh` à la racine du dépôt source, exécuté une fois par utilisateur, qui rend la commande appelable.
  - **Couche 2 (contenu)** : commandes de l'outil, exécutées sur un dépôt cible, qui posent les fichiers d'augmentation.
- *Alternatives écartées* : tout confier à l'outil, y compris l'amorçage de la commande elle-même : rejeté, l'amorçage précède l'existence de la commande dans le `PATH`, il lui faut un script autonome.

### D2 - Couche 1 : modes dev, permanent et local (amendée)

- **Décision** : reproduire le socle analysé par [`ANL-002`](../analyses/ANL-002-setup-installation.md) : installation **per-user, sans privilèges élevés** ; **dev** (l'exécution pointe vers le dépôt source, aucune copie, toute modification immédiatement active) ; **permanent** (bloc marqué dans la configuration de shell, survit aux sessions) ; **local** (utilisateur courant uniquement). Appliquer les corrections d'`ANL-002` : **idempotence réconciliante** (à la réinstallation, si le bloc existe mais que la racine a changé, mettre à jour le bloc au lieu d'afficher « déjà installé ») ; **marqueurs d'ouverture et de fermeture explicites** pour un retrait déterministe ; **bash uniquement** sur cible Debian 12 ; noms de commandes fixés tôt et synchronisés avec l'aide.
- **Amendement** : le **mode multi-utilisateur** (installer pour une liste d'utilisateurs, énoncé à la tâche 38) est **hors portée**. Trois motifs : il ne sert aucun des trois parcours retenus ; il exige d'écrire dans la configuration d'autrui, donc des privilèges élevés, ce que la présente décision exclut ; et il se heurte au mode dev, dont l'exécution pointe vers un arbre source situé dans le répertoire personnel de l'installateur, auquel les autres utilisateurs n'ont pas nécessairement accès.
- *Alternatives documentées pour plus tard* : installation partagée par fragment de profil système et lien dans un répertoire de binaires partagé (exige des privilèges une fois) ; mode dev partagé (exige en plus de déplacer l'arbre source hors du répertoire personnel).
- **Nom de la commande d'amorçage** : `install`. La tâche 38 emploie `install` dans son énoncé opératoire et `init` dans son introduction. `install` est retenu, `init` désignant déjà la commande de couche 2 : deux sens pour un même mot dans le même système est une source d'erreur durable.

### D3 - Couche 2 : le groupe `clia setup` (conservée de la v0.1.0)

- **Décision** : exposer la couche 2 par le **groupe `setup`**, avec une sous-commande par opération :
  - `clia setup init` : matérialiser le système d'augmentation dans un dépôt cible qui n'en a pas ;
  - `clia setup versions` : énumérer les versions disponibles et dire laquelle est installée ;
  - `clia setup upgrade` et `clia setup downgrade` : **réservées**, hors de la portée immédiate.
- **Histoire de cette décision** : la version 0.1.0 avait retenu le groupe `setup`. La révision 0.2.0 l'avait renversé au profit de commandes de premier niveau, sur la foi de l'énumération de la tâche 38 et de la parité avec le modèle de référence. Le feedback humain de la tâche 43 rétablit le groupe. La décision d'origine est donc restaurée, et son motif d'origine avec elle : le regroupement isole clairement la couche 2 et laisse l'outil cohérent avec ses autres groupes (`res`, `ses`).
- **Nom de la sous-commande de versions** : `versions`, et non `version ls`. Motif : aucune commande de l'outil n'a aujourd'hui trois niveaux, et `clia setup version ls` en aurait trois. `versions` reste à un seul niveau, cohérent avec `clia setup init`. Il évite en outre la collision avec l'option globale `--version` et la commande `release`, qui portent sur la version du domaine métier et non sur celle du système d'augmentation ([`ANL-015`](../analyses/ANL-015-faisabilite-installation-et-versions.md), constat C7).
- *Alternative écartée* : commandes de premier niveau (`clia init`, `clia versions`) : rejetée par le feedback de la tâche 43.
- **Grammaire** : `clia [OPTIONS_GLOBALES] setup SOUS-COMMANDE [OPTIONS]`, conforme à [`SPEC-002`](../specs/SPEC-002-cli-clia.md), avec aide générée depuis la source documentaire unique.

### D4 - Résolution de la racine cible (conservée, étendue)

- **Décision** : la racine cible de la couche 2 est distincte de la racine de l'outil. Elle est résolue dans l'ordre : option explicite, à défaut la racine du dépôt versionné contenant le répertoire courant, à défaut le répertoire courant. L'outil agit toujours sur cette cible résolue, jamais sur son propre arbre d'installation.
- **Extension** : la création d'un dépôt neuf ajoute le cas d'une cible **qui n'existe pas encore**, désignée par un nom plutôt que trouvée.

### D5 - Frontière lecture / écriture pour git (amendée)

- **Décision** : la version 0.1.0 interdisait à l'outil **toute** opération git. Cette interdiction est remplacée par une **frontière** :
  - **lecture autorisée sans réserve** : énumérer les révisions et les étiquettes, extraire un arbre à une révision. Sans effet de bord, déterministe, hors ligne. C'est ce dont [`USE-003`](../usages/USE-003-connaitre-les-versions-disponibles.md) a besoin ;
  - **écriture limitée à un seul geste** : **créer un dépôt à un emplacement qui n'en contient pas**. Aucun enregistrement, aucune étiquette, aucun changement de révision, aucune opération sur un dépôt existant.
- **Motif du renversement** : l'interdiction de 0.1.0 venait de la tâche 31. Elle reposait sur une confusion que la tâche 28 avait déjà levée : ce que la gouvernance interdit, c'est **l'agent** qui opère git, non l'outil déterministe opéré par l'humain ([`CONSTITUTION.md`](../../CONSTITUTION.md)). La frontière retenue préserve ce qui était réellement visé, l'autorité humaine sur l'historique ([`PDC-010`](../principes/PDC-010-point-entree-unique-autorite-humaine-irreversible.md)), sans interdire une lecture inoffensive.
- **Question de conception ouverte en 0.1.0 : tranchée.** La création du dépôt versionné revient à **l'outil**, comme conséquence directe de la présente décision et du parcours [`USE-002`](../usages/USE-002-creer-un-depot-neuf-deja-equipe.md).
- **Conséquence maintenue** : l'outil échoue sans effet de bord si une précondition n'est pas remplie (écriture atomique par fichier temporaire puis remplacement), laissant le dépôt dans un état propre pour que l'humain décide de l'enregistrer ou non.

### D6 - Le paquet distribuable exclut l'outil (amendée)

- **Décision** : le paquet posé dans un dépôt cible est le **harnais et ses actifs**, et rien d'autre :
  - **inclus** : fichiers de harnais racine, gabarit d'intention à personnaliser, compétences, gabarits, couche type machine-lisible, squelette de version du domaine, et répertoires de ressources **vides**, prêts à accueillir la conception propre au dépôt cible ;
  - **exclus** : **l'outil et sa source documentaire** ; les instances de ressources de conception propres au dépôt source ; les traces ; le point d'entrée de session.
- **Motif du renversement** : la version 0.1.0 incluait l'outil dans le paquet. L'objection humaine de la tâche 41 l'écarte : l'outil est installé **une fois, globalement**, par la couche 1, et s'utilise depuis n'importe quel répertoire. C'est le modèle vérifié de `ticket-driven-ai`, dont le script de couche 2 ne copie que les fichiers de harnais et les compétences.
- **Conséquence** : une cible équipée ne contient **aucun exécutable**. Il n'existe qu'une copie de l'outil, celle qu'a rendue disponible la couche 1 ; la question d'une divergence entre deux copies ne se pose plus.
- **L'appartenance au paquet se déduit des zones et du champ `type`**, jamais d'une liste codée en dur : c'est la seule forme compatible avec la source de vérité unique ([`PDC-006`](../principes/PDC-006-source-de-verite-documentaire-unique.md)), et la seule qui n'exige aucune modification de code lors de l'ajout d'un type de ressource.
- **Mode de pose** : **copie** par défaut, ce qui rend la cible autonome. Un mode **lien** vers l'arbre source est offert en complément lorsque l'outil est installé en mode dev : toute évolution du harnais devient alors immédiatement effective dans les dépôts équipés, au prix d'une cible qui n'est plus autonome et se casse si l'arbre source est déplacé. La copie est le défaut parce qu'elle est la seule forme sûre pour un dépôt destiné à vivre sa propre vie.

### D7 - Comparaison de versions et source de distribution (conservée dans son principe)

- **Décision** : la source des versions est l'**arbre local**, jamais le réseau. La distribution distante reste hors périmètre.
- **Renvoi** : la définition de la version du système d'augmentation, sa découverte et la marque d'installation sont traitées par [`ADR-013`](ADR-013-version-augmentation-et-marque-installation.md), qui remplace le mécanisme de comparaison esquissé en 0.1.0. Le motif est établi par [`ANL-015`](../analyses/ANL-015-faisabilite-installation-et-versions.md) (constat C9) : comparer les versions de frontmatter ressource par ressource ne répond pas à la question « va à la version X », qui suppose d'abord de matérialiser un état d'ensemble. La comparaison par frontmatter reste utile, mais comme contrôle de cohérence, pas comme moteur.

### D8 - La couche 2 n'est pas une réimplémentation de la couche 1 (nouvelle)

- **Décision** : la commande de couche 2 **invoque** le script d'amorçage plutôt que de dupliquer sa logique. Le script devient une **extension** de l'outil, encadrée par le contrat d'[`ADR-014`](ADR-014-contrat-extension-outil.md).
- **Motif** : une seule implémentation de la logique d'installation, donc un seul endroit à corriger et à éprouver. Directive de la tâche 40.
- **Conséquence sur le script** : il doit fonctionner **de façon autonome** (avant que l'outil existe dans l'environnement, ce qui est le cas du parcours de couche 1) **et** comme extension invoquée. Deux points d'entrée, un seul corps de code.
- *Alternative écartée* : implémenter la matérialisation dans l'outil et n'appeler le script que pour l'amorçage : rejeté, cela recrée deux implémentations de la même opération, l'une pour l'humain qui lance le script, l'autre pour celui qui passe par l'outil.

### D9 - Détection d'un dépôt compatible (nouvelle)

- **Décision** : l'outil, appelable depuis n'importe où, **reconnaît** l'état du répertoire où il s'exécute, et le fait **avant** d'agir. Quatre états distingués :
  - **équipé et marqué** : la marque d'installation est présente et lisible ([`ADR-013`](ADR-013-version-augmentation-et-marque-installation.md)) ;
  - **équipé sans marque** : les fichiers de harnais sont là, la marque n'y est pas. État **à régulariser**, ni refusé ni accepté en silence : c'est le cas d'un dépôt équipé avant l'existence de la marque, ou d'un harnais posé à la main ;
  - **non équipé** : un dépôt sans fichiers de harnais ;
  - **hors de tout dépôt**.
- **Motif** : contrepartie directe de D6. Puisque l'outil n'est pas distribué avec le contenu, rien dans le répertoire courant ne le renseigne implicitement : il doit chercher.
- **Comportement** : une commande qui exige un dépôt équipé refuse sur les deux derniers états et **oriente** vers le parcours approprié plutôt que d'échouer sèchement. Les flux `2b` de `USE-002` et `3a` de `USE-003` en dépendent.

## Conséquences

**Positives**

- Frontière nette entre installation de l'outil et installation du contenu, reprenant un modèle éprouvé et corrigeant ses fragilités connues.
- Une seule copie de l'outil existe, et une seule implémentation de la logique d'installation : ni divergence de fichiers, ni divergence de comportement.
- L'outil garde son déterminisme et l'humain la maîtrise entière de l'historique de versions.
- Le paquet se déduit des zones et du `type` : rien à tenir à jour lorsqu'un type de ressource est ajouté.

**Négatives / risques**

- Un dépôt équipé **dépend d'un outil qu'il ne contient pas**. Le recevoir ne suffit pas à s'en servir : il faut avoir installé l'outil séparément. C'est le prix assumé de D6, et il doit être dit dans la documentation d'accueil d'un dépôt équipé.
- La couche 1 en mode dev couple l'installation à la configuration de shell de l'utilisateur et à bash sur Debian 12 : non portable hors de cette cible, choix assumé.
- Le mode lien (D6) crée une cible non autonome, qui se casse silencieusement si l'arbre source est déplacé. C'est pourquoi il n'est pas le défaut.
- La détection (D9) introduit un état « équipé sans marque » qu'il faut savoir régulariser ; sans commande pour le faire, cet état reste un cul-de-sac. La régularisation relève des parcours de version, hors portée immédiate.

## Migration / porte de sortie

Décision révisable si la distribution distante entre dans le périmètre (elle imposerait alors une vérification d'intégrité par signature, [`FND-008`](../fondations/FND-008-installateurs-packaging.md)), ou si le mode multi-utilisateur devient nécessaire, auquel cas les deux alternatives documentées en D2 sont le point de départ. Les exigences et spécifications des trois parcours relèvent du segment 2 de [`PLN-018`](../plans/PLN-018-preparation-installation-outil-et-depot.md) ; cet ADR fixe le cadre.

## Références

- [`PLN-018-preparation-installation-outil-et-depot`](../plans/PLN-018-preparation-installation-outil-et-depot.md) (plan d'exécution de cette révision)
- [`ADR-013-version-augmentation-et-marque-installation`](ADR-013-version-augmentation-et-marque-installation.md), [`ADR-014-contrat-extension-outil`](ADR-014-contrat-extension-outil.md)
- [`USE-001`](../usages/USE-001-rendre-l-outil-disponible-sur-son-poste.md), [`USE-002`](../usages/USE-002-creer-un-depot-neuf-deja-equipe.md), [`USE-003`](../usages/USE-003-connaitre-les-versions-disponibles.md)
- [`ANL-015-faisabilite-installation-et-versions`](../analyses/ANL-015-faisabilite-installation-et-versions.md), [`ANL-002-setup-installation`](../analyses/ANL-002-setup-installation.md)
- [`FND-008-installateurs-packaging`](../fondations/FND-008-installateurs-packaging.md)
- [`ADR-004-ressources-livrables`](ADR-004-ressources-livrables.md), [`ADR-005-fonction-scope-harnais`](ADR-005-fonction-scope-harnais.md), [`ADR-007-architecture-systeme-augmentation`](ADR-007-architecture-systeme-augmentation.md)
- [`SPEC-002-cli-clia`](../specs/SPEC-002-cli-clia.md), [`REQ-002-cli-clia`](../requis/REQ-002-cli-clia.md), [`REQ-001-convention-cli-bash`](../requis/REQ-001-convention-cli-bash.md)
- [`CONSTITUTION.md`](../../CONSTITUTION.md) (git : responsabilité de l'humain)
