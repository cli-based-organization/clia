---
type: analyse
version: 0.1.0
title: "Faisabilité des parcours d'installation et de gestion des versions (USE-001 à USE-005)"
date: 2026-07-29
---

# ANL-015 - Faisabilité des parcours d'installation et de gestion des versions

- **Périmètre** : le dépôt `clia` au 2026-07-29 (`setup.sh`, `src/`, `version.yaml`, [`.dev/resource-types.yaml`](../resource-types.yaml), les ADR, spécifications, exigences et plans relatifs à l'installation, et les cinq cas d'usage produits ce jour). Exclus : `.git/`, `doc/`, les traces (`.dev/logs/`, `.dev/sessions/`).
- **Référence** : [`ADR-010`](../adr/ADR-010-clia-setup-commandes-modes-installation.md) (commandes et modes d'installation), [`ADR-004`](../adr/ADR-004-ressources-livrables.md) (modèle de ressources et versionnage), [`ADR-007`](../adr/ADR-007-architecture-systeme-augmentation.md) (versionnage à deux domaines), [`PLN-016`](../plans/PLN-016-installation-cycle-de-vie-clia.md), [`REQ-002`](../requis/REQ-002-cli-clia.md) et [`SPEC-002`](../specs/SPEC-002-cli-clia.md).

## Objet

Évaluer la faisabilité et la difficulté d'implémentation des cinq parcours énoncés à la tâche 38 de `.dev/session.md` et écrits ce jour en [`USE-001`](../usages/USE-001-rendre-l-outil-disponible-sur-son-poste.md) à [`USE-005`](../usages/USE-005-ramener-un-depot-a-une-version-anterieure.md), puis formuler des recommandations d'implémentation et lister les décisions que l'humain doit trancher avant que l'implémentation puisse commencer.

L'analyse porte sur un existant matériel (le code et les documents de conception présents dans le dépôt) confronté à une intention nouvelle (la surface de commandes énoncée à la tâche 38). Sa conclusion tient en une phrase : les cinq parcours sont **techniquement faciles**, et **trois d'entre eux sont bloqués** par une notion qui n'existe pas encore dans le modèle du dépôt.

## Périmètre et méthode

Grille d'analyse appliquée à chacun des cinq parcours :

| Dimension | Question posée |
|---|---|
| D1. Faisabilité technique | l'environnement cible (bash, Debian 12, `yq`, git) permet-il l'opération, et à quel prix ? |
| D2. Écart à la conception actée | l'énoncé contredit-il une décision déjà prise, et laquelle ? |
| D3. Déterminisme et effet de bord | l'opération est-elle reproductible, et laisse-t-elle l'environnement dans un état prévisible ([`PDC-001`](../principes/PDC-001-determinisme-de-clia.md)) ? |
| D4. Réversibilité et sûreté | la garantie minimale du parcours est-elle tenable ? |
| D5. Coût et dépendances | qu'est-ce qui doit exister avant, et quel volume de code représente l'opération ? |

Toutes les invocations citées comme « constatées » ont été exécutées sur le dépôt à la date de l'analyse.

## Inventaire

État de l'existant, parcours par parcours.

| Parcours | Ce qui existe aujourd'hui | Ce qui manque |
|---|---|---|
| [`USE-001`](../usages/USE-001-rendre-l-outil-disponible-sur-son-poste.md) rendre l'outil disponible | `setup.sh` (34 lignes) n'expose qu'un mode `activate` qui modifie le `PATH` de la session courante et vérifie `yq` | toute persistance (aucune écriture de configuration), `--check`, `--uninstall`, les marqueurs de bloc, le mode multi-utilisateur |
| [`USE-002`](../usages/USE-002-creer-un-depot-neuf-deja-equipe.md) créer un dépôt équipé | rien | la totalité : création du dépôt, matérialisation du paquet, marque de version |
| [`USE-003`](../usages/USE-003-connaitre-les-versions-disponibles.md) lister les versions | `clia --version` (lit `version.yaml`), `clia release` (incrémente `version.yaml`) | la notion même de version du système d'augmentation ; **aucun tag git n'existe dans le dépôt** (`git tag -l` retourne 0 entrée) |
| [`USE-004`](../usages/USE-004-elever-un-depot-a-une-version-plus-recente.md) élever | rien ; `src/lib/resource.sh` sait lister des ressources mais sur un modèle abrogé ([`BUG-007`](../bugs/BUG-007-resource-sh-modele-abroge.md)) | le moteur de réconciliation, la marque de version installée, la détection de modification locale |
| [`USE-005`](../usages/USE-005-ramener-un-depot-a-une-version-anterieure.md) ramener | rien | idem, plus la matérialisation d'un état source antérieur |

Le dépôt possède en revanche déjà : le squelette de CLI conforme ([`SPEC-001`](../specs/SPEC-001-convention-cli-bash.md), `SPEC-002`), la documentation générée depuis une source unique (`src/clia.doc.yaml`), la résolution de racine par `BASH_SOURCE`, le motif de bac à sable de test, et la définition du paquet distribuable ([`ADR-010`](../adr/ADR-010-clia-setup-commandes-modes-installation.md), décision D6). Le socle n'est pas à construire.

## Constats

**C1. La version du système d'augmentation n'existe pas.** C'est le constat central. Trois parcours sur cinq (`USE-003`, `USE-004`, `USE-005`) manipulent un objet nommé `VERSION` qui n'a **aujourd'hui aucun référent** dans le modèle du dépôt :

- `version.yaml` porte la version du **domaine métier**, explicitement séparée du système d'augmentation ([`ADR-007`](../adr/ADR-007-architecture-systeme-augmentation.md)) ;
- depuis [`ADR-004`](../adr/ADR-004-ressources-livrables.md) v0.2.0, chaque ressource porte **sa propre** version en frontmatter et le manifeste central est aboli : il n'existe donc plus aucune version d'ensemble ;
- aucun tag git n'existe.

Une commande « élève le dépôt à la version X » suppose un ensemble versionné comme un tout. Le modèle actuel versionne des pièces, pas le paquet. Ce n'est pas un manque d'implémentation, c'est un **manque de modèle**, et il bloque trois parcours.

**C2. Le dépôt cible ne conserve aucune trace de ce qui y a été installé.** Corollaire de C1, et tout aussi bloquant : même si une version d'ensemble existait, rien dans un dépôt équipé ne dirait laquelle y est posée. `USE-004` et `USE-005` ne peuvent pas savoir d'où ils partent, et `USE-003` ne peut pas distinguer l'installé du disponible. C'est le motif des flux d'échec `3b` de `USE-003` et `2b` de `USE-004`.

**C3. La surface de commandes proposée contredit frontalement `ADR-010`.** L'ADR décide en D3 le groupe `clia setup <init|upgrade|downgrade>` et **écarte explicitement** les commandes de premier niveau, avec sa raison : « le regroupement `setup` isole clairement la couche 2 et laisse `clia` cohérent avec ses autres groupes (`res`, `ses`) ». La tâche 38 demande exactement ce que l'ADR a écarté : `clia init`, `clia upgrade VERSION`, `clia downgrade VERSION`, `clia version ls`. L'écart est net et assumable, mais il doit être **acté par une révision d'ADR** et non appliqué en silence, sans quoi la conception et l'implémentation divergent dès le premier jour.

**C4. Les parcours réintroduisent git dans l'outil, ce que `ADR-010` avait exclu.** La décision D5 pose que l'outil « n'exécute aucune opération git (ni `init`, ni `commit`, ni `checkout`, ni tag) », en résolution de l'objection 4 de la tâche 31. Or `USE-002` demande la création d'un dépôt versionné et `USE-003` propose de lire des tags git.

Cet écart ne heurte **aucun principe** : la [`CONSTITUTION.md`](../../CONSTITUTION.md) interdit git à l'**agent**, pas à l'outil déterministe opéré par l'humain, et la tâche 28 (objection 4) l'avait déjà explicité. C'est donc `ADR-010` qui doit être révisé, pas la gouvernance. Il faut cependant distinguer deux usages très différents de git :

- **lire** (énumérer des tags, extraire un arbre à un tag) : sans effet de bord, déterministe, sans risque ;
- **écrire** (créer un dépôt, committer, poser un tag, changer de révision) : effet de bord sur le travail de l'humain, à cadrer strictement.

**C5. `ADR-010` avait laissé une question ouverte ; `USE-002` la tranche.** L'ADR notait que la création du dépôt versionné revenait « soit à une étape humaine préalable, soit à la couche 1 ». La tâche 38 la confie à l'outil lui-même, dont le comportement est calqué sur celui de la commande de création de dépôt. La question ouverte est donc résolue, dans le sens que D5 excluait.

**C6. Le mode multi-utilisateur se heurte à un obstacle de droits, et au mode dev lui-même.** L'option d'installation pour une liste d'utilisateurs suppose d'écrire dans la configuration d'environnement d'autrui, ce qui exige des privilèges élevés. Cela contredit la décision D2 de `ADR-010` (« installation per-user, sans `sudo` »).

Un second obstacle, moins visible, est plus contraignant : le mode dev fait pointer l'exécution vers **l'arbre source**, qui réside typiquement dans le répertoire personnel de l'installateur. Les autres utilisateurs n'y ont pas nécessairement accès en lecture. Un mode dev partagé suppose donc un arbre source placé hors du répertoire personnel, ce qui est une décision d'installation à part entière.

**C7. Trois notions de version cohabiteraient sous des noms voisins.** Après implémentation, l'outil exposerait : `--version` (version du domaine métier), `release` (incrémente cette même version), et `version ls` (versions du système d'augmentation). Deux objets distincts, trois noms qui se ressemblent. C'est un risque direct pour l'uniformité et la découvrabilité ([`PDC-007`](../principes/PDC-007-decouvrabilite-et-uniformite.md)), déjà consignée comme non pleinement implémentée par [`BUG-006`](../bugs/BUG-006-decouvrabilite-uniformite-non-implementee.md).

**C8. L'énoncé de la tâche 38 comporte trois ambiguïtés de surface.** Relevées sans jugement, elles doivent être tranchées avant écriture des exigences :

- l'introduction annonce `./setup.sh init` là où le cas d'usage 1 écrit `./setup.sh install --dev` : deux noms pour la même opération ;
- le cas d'usage 5 (diminuer la version) écrit `clia upgrade VERSION` là où l'introduction annonce `downgrade` : la présente analyse retient `downgrade`, seule lecture cohérente avec l'intention énoncée ;
- l'introduction mentionne « la commande d'installation du » sans complément : segment inachevé, non interprété ici.

**C9. Le mécanisme de comparaison décidé en D7 ne répond pas à la question posée.** `ADR-010` (D7) compare la version de frontmatter de **chaque ressource** entre la cible et l'arbre source, et déduit la direction. Une commande « va à la version X » ne se résout pas ainsi : il faut d'abord **matérialiser** l'état du paquet à la version X, puis réconcilier fichier par fichier. La comparaison par frontmatter reste utile, mais à un autre poste : détecter qu'une ressource de la cible a été **modifiée localement** avant de l'écraser (flux `3a` de `USE-004`).

**C10. Le retour en arrière exige d'extraire un état source antérieur sans toucher au travail en cours.** C'est le seul point techniquement délicat des cinq parcours. Placer l'arbre source à la révision voulue par un changement de révision aurait un effet de bord sur le travail de l'humain, en contradiction avec le déterminisme et avec l'autorité humaine sur l'irréversible ([`PDC-010`](../principes/PDC-010-point-entree-unique-autorite-humaine-irreversible.md)). Deux mécanismes d'extraction laissent l'arbre de travail intact : l'export d'archive d'une révision, et l'ajout d'un arbre de travail détaché dans un répertoire temporaire. Les deux sont en lecture seule vis-à-vis de l'état courant du dépôt source.

**C11. Un écart d'implémentation déjà tracé bloque la mesure des versions.** [`BUG-007`](../bugs/BUG-007-resource-sh-modele-abroge.md) constate que le module d'inspection des ressources lit les versions selon un modèle abrogé (colonne vide pour les fondations, type inconnu pour les principes, manifeste supprimé encore recherché). Tout moteur de réconciliation bâti par-dessus hériterait de ces données fausses. Détail supplémentaire relevé ici : l'en-tête de `version.yaml` décrit encore `.dev/ressources.yaml` comme la source des versions du système d'augmentation, alors que ce fichier est aboli ; ce vestige documentaire relève du même bogue.

## Confrontation à la référence

Écarts mesurés entre l'énoncé de la tâche 38 et [`ADR-010`](../adr/ADR-010-clia-setup-commandes-modes-installation.md), seule décision actée sur le sujet.

| Décision `ADR-010` | Ce qu'elle pose | Ce que la tâche 38 demande | Écart |
|---|---|---|---|
| D1 (deux couches) | couche 1 script d'amorçage, couche 2 dans l'outil | identique | **aucun** |
| D2 (per-user, sans `sudo`) | installation locale, mode dev | ajoute une installation pour d'autres utilisateurs | **majeur** (C6) |
| D3 (surface `clia setup ...`) | groupe `setup`, commandes de premier niveau écartées | commandes de premier niveau | **majeur** (C3) |
| D4 (résolution de la cible) | option explicite, puis racine git, puis répertoire courant | identique, plus le cas de la cible inexistante | **mineur** |
| D5 (aucune opération git) | l'outil ne fait aucun git | l'outil crée un dépôt et lit des tags | **majeur** (C4, C5) |
| D6 (paquet distribuable) | défini par zones et `type`, sans manifeste | identique | **aucun** |
| D7 (source des versions) | comparaison par frontmatter, arbre source local | version d'ensemble désignée par tag | **majeur** (C1, C9) |

Quatre écarts majeurs sur sept décisions. `ADR-010` reste **valide dans sa charpente** (deux couches, définition du paquet, résolution de la cible) et **caduc dans ses choix de surface et de source de version**. Une révision ciblée suffit ; une réécriture complète n'est pas justifiée.

## Faisabilité et difficulté, parcours par parcours

| Parcours | Faisabilité technique | Difficulté | Bloqué par | Volume estimé |
|---|---|---|---|---|
| `USE-001` rendre l'outil disponible | acquise : écriture d'un bloc délimité dans la configuration de shell, motif éprouvé et déjà analysé par [`ANL-002`](ANL-002-setup-installation.md) | **faible** | rien (sauf la variante multi-utilisateur, C6) | un script, une centaine de lignes |
| `USE-002` créer un dépôt équipé | acquise : création de dépôt, copie filtrée par zones et `type`, écriture de la marque de version | **moyenne** | décision sur git dans l'outil (C4), notion de version (C1) | un module, deux à trois cents lignes |
| `USE-003` lister les versions | acquise : énumération des tags d'un dépôt local, tri semver | **faible** une fois C1 tranché | notion de version (C1), marque installée (C2) | quelques dizaines de lignes |
| `USE-004` élever | acquise : extraction d'un état source, comparaison, écriture atomique | **moyenne à élevée** | C1, C2, C9, et [`BUG-007`](../bugs/BUG-007-resource-sh-modele-abroge.md) (C11) | le moteur de réconciliation, coeur du chantier |
| `USE-005` ramener | acquise, mais c'est le point le plus délicat : le retrait de ressources et les références devenues pendantes | **élevée** | tout ce qui précède, plus C10 | le même moteur, en sens inverse, plus la gestion des retraits |

Aucun des cinq parcours ne se heurte à un obstacle technique réel. La difficulté est **entièrement dans la conception** : ce qui manque, ce sont trois décisions, pas trois capacités.

## Synthèse et recommandations

### Ce qu'il faut retenir

Les cinq parcours sont à portée : l'environnement les permet, le socle de CLI existe, le paquet distribuable est déjà défini, et le motif d'installation est déjà analysé. Ce qui bloque n'est pas l'implémentation mais **l'absence d'un objet dans le modèle** : le système d'augmentation n'a pas de version d'ensemble, et un dépôt équipé ne garde pas trace de ce qui y est posé. Tant que ces deux points ne sont pas tranchés, trois des cinq parcours ne peuvent pas même être spécifiés, et les exigences qu'on en tirerait porteraient sur un objet inexistant.

### Recommandations priorisées

**R1 (priorité 1, bloquante). Créer la notion de version du système d'augmentation, portée par les tags du dépôt source.**

Un tag semver sur le dépôt `clia` désigne un état complet du paquet distribuable. C'est le choix suggéré par la tâche 38, et c'est le bon : il ne crée aucun état à maintenir, il est déterministe et hors ligne, et il donne gratuitement l'énumération (`USE-003`) comme l'extraction (`USE-004`, `USE-005`).

Alternatives écartées : agréger les versions de frontmatter des ressources (aucune sémantique d'ordre global, deux dépôts pourraient porter le même agrégat pour des états différents) ; réintroduire un fichier de version d'ensemble dans le harnais (c'est le manifeste central que [`ADR-004`](../adr/ADR-004-ressources-livrables.md) a aboli, avec ses raisons).

Conséquence à assumer : la version du système d'augmentation devient un **troisième domaine de version**, à côté du domaine métier (`version.yaml`) et des versions par ressource. [`ADR-007`](../adr/ADR-007-architecture-systeme-augmentation.md) doit l'énoncer.

**R2 (priorité 1, bloquante). Inscrire dans le dépôt cible la version d'augmentation installée.**

Sans marque, aucun des trois parcours de version ne sait d'où il part (C2). Recommandation : un fichier d'état dédié dans la zone de développement du dépôt cible, portant au minimum la version installée, la date de l'opération et l'empreinte des fichiers posés.

L'empreinte n'est pas un ornement : c'est elle qui permet de détecter qu'une ressource d'augmentation a été **modifiée localement** et de ne pas l'écraser en silence (flux `3a` de `USE-004`, l'un des rares moyens de perdre du travail avec ces commandes).

Ce fichier n'est pas une résurrection du manifeste aboli : celui-ci centralisait les versions **de la source**, celui-ci enregistre l'état **d'une installation**. Les deux objets n'ont ni le même lieu, ni le même propriétaire, ni la même durée de vie. Il faut le dire explicitement dans l'ADR, faute de quoi l'objection tombera à chaque relecture.

**R3 (priorité 1, bloquante). Réviser `ADR-010` plutôt que le contourner.**

Quatre décisions à amender, dans une révision v0.2.0 : D3 (surface de premier niveau au lieu du groupe `setup`), D5 (git autorisé dans l'outil, avec la distinction lecture/écriture de C4), D7 (source de version par tag), et la question ouverte (tranchée par `USE-002`). D1, D4 et D6 sont conservées telles quelles.

Cadrer précisément ce que l'outil s'autorise en écriture git : **créer** un dépôt à un emplacement neuf, et rien d'autre. Pas de commit, pas de tag, pas de changement de révision sur un dépôt existant. Cette limite préserve l'autorité de l'humain sur l'historique ([`PDC-010`](../principes/PDC-010-point-entree-unique-autorite-humaine-irreversible.md)) tout en donnant à `USE-002` ce dont il a besoin.

**R4 (priorité 1). Trancher le mode multi-utilisateur, ou le retirer.**

Trois options, par coût croissant : le retirer du périmètre immédiat (recommandé, il ne sert aucun des livrables attendus de la session) ; l'implémenter en installation partagée par un fragment de profil système et un lien dans un répertoire de binaires partagé, ce qui exige des privilèges élevés une fois et contredit la décision D2 ; l'implémenter en mode dev partagé, ce qui exige en plus de déplacer l'arbre source hors du répertoire personnel (C6).

**R5 (priorité 2). Extraire l'état source par archive ou arbre de travail détaché, jamais par changement de révision.**

Un changement de révision sur le dépôt source aurait un effet de bord sur le travail en cours de l'humain. L'export d'archive et l'arbre de travail détaché dans un répertoire temporaire laissent l'état courant intact. C'est ce qui rend `USE-004` et `USE-005` compatibles avec [`PDC-001`](../principes/PDC-001-determinisme-de-clia.md).

**R6 (priorité 2). Corriger [`BUG-007`](../bugs/BUG-007-resource-sh-modele-abroge.md) avant d'écrire le moteur de réconciliation.**

Le moteur lira des versions de frontmatter. Le module qui le fait aujourd'hui rapporte des données fausses sur quatre des neuf types qu'il connaît. Corriger d'abord évite de bâtir sur une mesure erronée, et le correctif prévu (lecture depuis la couche type) rend au passage les nouveaux types `ACT` et `USE` connus sans code supplémentaire.

**R7 (priorité 2). Uniformiser le vocabulaire de version avant d'ajouter la troisième notion.**

Décider une fois pour toutes comment se nomment, dans l'interface, la version du domaine métier et la version du système d'augmentation, et rendre la distinction lisible dans l'aide générée. Sans cela, trois commandes voisines désigneront deux objets différents (C7).

**R8 (priorité 3). Ordonner l'implémentation par dépendance, pas par ordre d'énoncé.**

Ordre recommandé : décisions R1, R2, R3 ; puis `USE-001` (indépendant, livrable immédiatement) ; puis `USE-003` (peu de code une fois R1 acquis, et il rend les suivants observables) ; puis `USE-002` ; puis `USE-004` et enfin `USE-005`, qui partagent le même moteur et dont le second ajoute la gestion des retraits.

**R9 (priorité 3). Amender [`ACT-003`](../acteurs/ACT-003-installateur.md).**

Sa définition porte sur l'équipement d'un dépôt ; `USE-001` porte sur l'équipement d'un poste, qui en est la précondition. Un amendement d'une phrase suffit, à faire au moment où l'humain statuera sur le catalogue d'acteurs.

### Décisions à prendre par l'humain

1. La version du système d'augmentation est-elle portée par les tags git du dépôt source ? (R1)
2. Un dépôt équipé enregistre-t-il sa version installée, et avec quelle empreinte ? (R2)
3. La surface est-elle de premier niveau, au prix d'une révision de `ADR-010` ? (R3)
4. Que s'autorise l'outil en écriture git : création de dépôt uniquement, ou davantage ? (R3)
5. Le mode multi-utilisateur entre-t-il dans le périmètre immédiat ? (R4)
6. Le nom de la commande d'amorçage est-il `install` ou `init` ? (C8)
7. Que fait une mise à niveau devant une ressource d'augmentation modifiée localement : refuser, sauvegarder, ou demander ? (R2)

## Portée et péremption

- **Couverture** : intégralité des fichiers du dépôt relatifs à l'installation et au versionnage à la date du 2026-07-29, plus les cinq cas d'usage écrits le même jour. Les traces et `doc/` n'ont pas été évalués.
- **Limites** : l'analyse évalue la faisabilité, non le coût réel en temps ; les volumes de code annoncés sont des ordres de grandeur tirés de la taille des modules existants. Les cinq cas d'usage sont au statut `proposé` et non validés par l'humain ; toute correction de leur découpage se répercuterait ici.
- **Péremption** : les constats C1, C2 et C9 se périment dès que la notion de version d'ensemble est tranchée. Les constats C3, C4 et C5 se périment à la révision de `ADR-010`. Le constat C11 se périme à la résolution de `BUG-007`. Le constat C6 reste valide tant que le mode dev fait pointer l'exécution vers l'arbre source.
