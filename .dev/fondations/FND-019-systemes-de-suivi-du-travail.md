---
type: fondation
version: 0.1.0
title: "systemes-de-suivi-du-travail - Systèmes, frameworks et méthodes de gestion du travail en développement logiciel, et systèmes de suivi des demandes"
status: actif
date: 2026-08-02
---

# FND-019-systemes-de-suivi-du-travail - Gestion du travail et suivi des demandes

- **Objectif** : établir une base factuelle et sourcée sur les systèmes de gestion du travail en développement logiciel, et en particulier sur les **systèmes de gestion de l'information de travail** (bug trackers, issue trackers, trackers distribués fondés sur fichiers). Couvrir leur histoire, leur modèle de données, leurs relations structurelles, leurs critiques établies, et ce que l'agent IA y change.
- **Complémentarité** : cette fondation traite du **contenant** (la ressource de suivi, son modèle, son cycle de vie, sa structure relationnelle). [`FND-018`](FND-018-cas-usage-besoins-utilisateurs.md) traite du **contenu descriptif** (cas d'utilisation, user stories, critères d'acceptation) et de la **priorisation de backlog** (section 8.2), qui ne sont donc pas repris ici. [`FND-015`](FND-015-requis-et-specification.md) traite du couple requis / spécification.

## 1. Note de rigueur

Les sources primaires sont nommées quand elles existent et sont identifiables : Chillarege et al. (1992) pour l'ODC, IEEE 1044-2009 pour la classification normative des anomalies, Spolsky (2000) pour la doctrine du tracker minimal, Goldratt (1984, 1997) pour la théorie des contraintes, van Lamsweerde et Dardenne pour KAOS, Yu (1995) pour i\*, Allen (2001) pour GTD, Holub pour la critique du suivi, et les journaux de publication de GitHub pour l'évolution récente du modèle des issues.

Quatre précautions de lecture.

- **La littérature est majoritairement praticienne.** Hors de la classification des défauts (ODC, IEEE 1044) et de l'ingénierie des exigences orientée buts (GORE), il n'existe pas de corpus empirique solide comparant l'efficacité des systèmes de suivi. Les jugements comparatifs sont signalés comme des appréciations.
- **Les chiffres de coût circulant chez les éditeurs d'outils ne sont pas des données de recherche.** Les statistiques d'origine commerciale (perte de vélocité, coût d'un backlog non traité) sont rapportées avec leur provenance et ne doivent pas être traitées comme établies.
- **Le vocabulaire est instable.** « Issue », « ticket », « bug », « task », « story », « epic » désignent des objets différents selon l'outil et selon l'école. Les définitions employées ici sont attribuées à leur source.
- **La partie « agent IA » est récente et volatile.** Elle s'appuie sur un état de l'art de 2025 (arXiv 2510.08005), prospectif sur plusieurs points.

## 2. Cadrage et thèse

### 2.1 Questions traitées

1. Quels systèmes de gestion de l'information de travail existent, d'où viennent-ils, et quel est leur modèle de données commun ?
2. Qu'est-ce qui a changé avec les issues de GitHub, et pourquoi cette simplification a-t-elle compté dans l'adoption de la plateforme ?
3. Quelles **structures relationnelles** entre unités de travail la littérature connaît-elle (hiérarchie, dépendance, graphe d'objectifs, blocage), et que valent-elles ?
4. Quelles critiques établies pèsent sur la pratique du suivi, et quelles alternatives sont documentées ?
5. Que change la présence d'un agent IA dans la boucle ?

### 2.2 Périmètre

Dans le périmètre : les systèmes de suivi de défauts et de demandes, leur modèle de données et leur cycle de vie ; les taxonomies normatives de défauts ; les trackers distribués fondés sur des fichiers versionnés ; les structures de relation entre unités de travail (dépendance, blocage, raffinement de buts) ; les méthodes de conduite du travail dont la structure informe le suivi (GTD, Kanban, OKR, SMART) ; les critiques du suivi.

Hors périmètre : la priorisation de backlog (voir [`FND-018`](FND-018-cas-usage-besoins-utilisateurs.md) section 8.2) ; les formats de description du besoin (`FND-018` section 4) ; la distinction requis / spécification (`FND-015`) ; l'estimation et la planification prédictive ; la gestion de portefeuille ; l'évaluation commerciale des outils du marché.

### 2.3 Définitions de travail

- **Système de suivi** (*issue tracking system*) : système d'information qui persiste des **enregistrements de travail** identifiés, décrits, classés, datés, dotés d'un état, et interrogeables.
- **Défaut** (*bug*, *anomalie*) : écart entre un comportement observé et un comportement attendu. Cette définition, en apparence triviale, porte une conséquence lourde : **un défaut n'est constatable que si un comportement attendu est énonçable**. C'est le point d'articulation entre le suivi des défauts et l'ingénierie des exigences (section 8).
- **Demande** (*issue* au sens large) : tout élément d'information relatif à un travail à faire, indépendamment de sa maturité, de son caractère mesurable ou de son horizon.
- **Enregistrement de travail** : terme neutre employé ici pour ne pas trancher entre bug, issue, ticket et tâche.

### 2.4 Thèse

Trois constats structurent cette fondation.

1. **Le modèle de données du suivi est stable depuis trente ans** (identité, description, état, classification, imputation, historique) ; ce qui varie d'un système à l'autre, c'est le **nombre de champs obligatoires** et le **degré de contrainte du flux d'états**. Cette variation, et non le modèle, est ce qui détermine l'adoption.
2. **La liste plate est le mode d'organisation par défaut, et il est structurellement insuffisant.** Toute la difficulté de la gestion du travail vient de ce qu'une liste ordonnée ne représente ni le blocage, ni le raffinement d'un but, ni l'obsolescence par résolution amont. Les tentatives sérieuses de dépasser la liste (GORE, théorie des contraintes, dépendances d'issues) convergent toutes vers un **graphe orienté**.
3. **La critique la plus forte du suivi n'est pas qu'il est mal outillé, mais qu'il permet de ne pas décider.** Un enregistrement conservé est une décision différée à coût apparent nul et à coût réel non nul.

## 3. Historique des systèmes de suivi

Cinq époques, d'après la synthèse de Gnanasekaran et al. (2025) et les sources encyclopédiques.

**3.1 Ère du registre (années 1940 à 1970).** Les défauts sont consignés dans des cahiers de laboratoire, sans structure ni identité stable. L'épisode du papillon de nuit du Harvard Mark II (1947) appartient à cette période et illustre le régime documentaire de l'époque : le défaut est une anecdote consignée, pas un objet géré.

**3.2 Ère pré-Internet (années 1970 à 1980).** Le courriel et la disquette permettent la remontée à distance. Le support client transcrit manuellement les signalements dans des fichiers texte transmis aux développeurs. Le premier trait durable apparaît : **le rapporteur et le réparateur sont des personnes différentes**, ce qui fait du suivi un problème de communication autant que de mémoire.

**3.3 Ère des systèmes dédiés (années 1980 à 1990).** GNATS (projet GNU, vers 1990), Debbugs (Debian) et CMVC (IBM) introduisent une base structurée alimentée par courriel. Netscape formalise la **réunion de triage** (« bug council ») et une classification de sévérité à cinq niveaux : la classification devient un acte social, arbitré, et non une propriété intrinsèque du défaut.

**3.4 Ère du web (années 1998 à 2010).** Bugzilla (Netscape, 1998, en Perl) fixe les conventions que la génération suivante héritera : interface web, champs normalisés (sévérité, priorité, composant, version, plateforme), flux d'états configurable, recherche paramétrée. Mantis Bug Tracker (2000) en propose une version à l'ergonomie plus accessible et à flux personnalisable ; Trac y adjoint le wiki et l'intégration au dépôt ; Jira (Atlassian, 2003, en Java) y ajoute une architecture d'extensions et une configurabilité qui deviendra sa marque de fabrique et sa principale critique.

**3.5 Ère SaaS et DevOps (années 2010 à aujourd'hui).** GitHub Issues, GitLab Issues, YouTrack et Azure DevOps intègrent le suivi au dépôt, à l'intégration continue et au déploiement. Le fait marquant n'est pas technique mais **topologique** : l'enregistrement de travail cesse d'être dans un système tiers pour vivre au même endroit que le code.

**Lecture.** La trajectoire va de l'enregistrement isolé vers l'enregistrement **situé** : d'abord relié à une personne, puis à un composant, puis à un commit, puis à une exécution de pipeline. Chaque étape augmente la valeur de l'enregistrement et son coût de production.

## 4. Anatomie d'un enregistrement de travail

### 4.1 Le noyau commun

Tous les systèmes, du plus lourd au plus léger, portent le même noyau :

| Dimension | Contenu | Fonction |
|---|---|---|
| Identité | identifiant stable, titre | référence externe, citabilité |
| Description | résumé, corps | transmission de l'information |
| Classification | type, sévérité, priorité, composant, étiquettes | filtrage, agrégation, mesure |
| État | position dans un flux | savoir ce qui reste à faire |
| Imputation | rapporteur, assigné | responsabilité |
| Temporalité | création, modification, résolution | mesure de délai |
| Historique | fil de commentaires, journal des changements | reconstitution du raisonnement |
| Relations | doublon de, dépend de, sous-élément de | structure |

### 4.2 Le contenu minimal d'un rapport de défaut

La formulation la plus reprise est celle de Spolsky (2000) : tout rapport de défaut doit contenir exactement **trois** choses, et elles suffisent.

1. Les **étapes de reproduction**.
2. **Ce qu'on s'attendait à voir**.
3. **Ce qu'on a vu à la place**.

Ce triplet est repris quasi à l'identique par la littérature contemporaine, qui y ajoute l'**environnement** (système, version, configuration) comme quatrième élément quand le comportement en dépend. Sa propriété remarquable est d'être **auto-vérifiante** : un rapport qui ne peut pas énoncer le point 2 n'est pas un défaut, c'est une demande d'évolution. Le format sépare donc mécaniquement deux natures de travail que les taxonomies ultérieures peinent à séparer.

Spolsky en tire aussi trois règles de processus : n'importe qui peut ouvrir un défaut ; un défaut est assigné à **une seule** personne à la fois ; seul celui qui a ouvert peut fermer, le développeur pouvant seulement « résoudre ». La dernière règle sépare **la réparation** (acte technique) de **l'acceptation** (acte de constat), séparation que la plupart des flux d'états conservent.

### 4.3 La doctrine du champ rare

Spolsky formule une mise en garde devenue canonique : « éviter la tentation d'ajouter de nouveaux champs à la base de défauts ». L'argument est économique et non esthétique : chaque champ obligatoire augmente le coût marginal de saisie d'un enregistrement ; au-delà d'un seuil, **le coût de saisie dépasse la valeur perçue de l'enregistrement et les gens cessent de rapporter**. Le système devient alors une source d'information fausse, puisqu'il ne contient plus que les enregistrements assez importants pour justifier le rituel.

C'est la thèse centrale à retenir de cette section, parce qu'elle explique l'essentiel de l'histoire de la section 5 : **la qualité d'un système de suivi se mesure d'abord à son coût d'entrée, pas à sa richesse**.

### 4.4 Les taxonomies normatives

Deux référentiels structurent la classification des défauts.

**Orthogonal Defect Classification (ODC).** Développée par Ram Chillarege et son équipe chez IBM Research à la fin des années 1980 et au début des années 1990, l'ODC transforme l'information sémantique du flux de défauts en **mesure du procédé**. Elle repose sur un schéma à six dimensions : *type*, *source*, *impact*, *déclencheur* (*trigger*), *phase de découverte*, *sévérité*. La propriété revendiquée est l'**orthogonalité** : les dimensions sont indépendantes, ce qui rend les agrégations interprétables. L'ODC est indépendante du modèle de procédé, du langage et du domaine.

L'apport conceptuel décisif de l'ODC est la notion de **déclencheur** : ce qui a fait apparaître le défaut, distinct de ce qui l'a causé. Deux défauts de même cause mais de déclencheurs différents renseignent sur des lacunes de vérification différentes. C'est ce qui permet à la classification de dire quelque chose sur le **procédé** et pas seulement sur le produit.

**IEEE 1044-2009, Standard Classification for Software Anomalies.** La norme définit un vocabulaire commun pour parler des anomalies logicielles et un jeu d'attributs communs supportant l'analyse des données de défauts et de défaillances. Elle s'applique à tout logiciel et à toute phase du cycle de vie. Son intérêt ici est moins le détail des attributs que le principe : **le vocabulaire du défaut est un objet de normalisation**, parce que sans vocabulaire partagé, les données de défauts ne sont pas agrégeables.

**Lecture critique.** ODC et IEEE 1044 sont conçues pour des organisations qui **mesurent leur procédé sur de gros volumes**. Leur coût de classification n'est justifiable qu'à partir d'un volume où les agrégats deviennent statistiquement lisibles. En deçà, la classification fine produit du coût sans produire d'information : c'est le cas d'un dépôt tenu par une personne. La leçon transposable n'est donc pas d'adopter ces schémas, mais de retenir **une seule** de leurs distinctions, celle qui reste informative à faible volume : le déclencheur, c'est-à-dire ce qui a révélé l'écart.

## 5. Le cas des issues de GitHub : la simplification comme facteur d'adoption

Cette section répond à une question explicitement posée : en quoi les issues de GitHub ont-elles constitué un progrès de simplification par rapport aux bug trackers, et en quoi ce progrès a-t-il aidé l'adoption de la plateforme.

### 5.1 Ce qui a été retiré

Comparé au modèle établi par Bugzilla, le modèle initial des issues de GitHub **supprime** l'essentiel de la structure obligatoire :

| Bugzilla et sa descendance | Issues de GitHub (modèle initial) |
|---|---|
| Sévérité, priorité, plateforme, système, version, composant, cible de correction, en champs distincts | Aucun de ces champs. Un jeu d'**étiquettes** libres, non typées |
| Flux d'états configurable, transitions contraintes (unconfirmed, new, assigned, resolved, verified, closed) | **Deux** états : ouvert, fermé |
| Rôles multiples (rapporteur, assigné, QA contact, CC) | Un rapporteur, zéro ou plusieurs assignés |
| Recherche paramétrée sur un schéma relationnel | Recherche plein texte et filtre par étiquette |
| Compte sur un système tiers | Compte déjà détenu par quiconque utilise la plateforme |

### 5.2 Ce qui a été conservé et ce qui a été ajouté

Le noyau irréductible de la section 4.1 est conservé : identité, titre, corps, état binaire, assignation, fil de discussion, horodatage. Deux ajouts sont propres au contexte :

- l'**étiquette libre**, qui remplace tous les champs typés par un mécanisme unique, extensible sans administration et sans schéma. L'étiquette est un classement **facultatif et a posteriori**, là où le champ est obligatoire et a priori. Le coût de saisie tombe donc à zéro pour le rapporteur, et le classement devient une charge du mainteneur, c'est-à-dire de la personne qui a intérêt à le faire ;
- la **contiguïté avec le code** : l'issue vit dans le dépôt, se référence depuis un message de commit, se ferme automatiquement depuis une fusion. La traçabilité, qui était dans les systèmes antérieurs un travail supplémentaire, devient un **effet de bord de l'activité normale**.

### 5.3 L'argument d'adoption

L'argument, tel que le formule la littérature praticienne, tient en trois points.

1. **Le coût marginal d'ouverture d'une issue est proche de zéro** pour un utilisateur déjà authentifié sur la plateforme : un titre, un corps, aucun champ obligatoire. Rapporté à la doctrine du champ rare (section 4.3), c'est le point de fonctionnement optimal du modèle de Spolsky.
2. **Le coût d'installation et d'administration est nul** : il n'y a pas de serveur à déployer, pas de schéma à configurer, pas de flux d'états à définir avant de pouvoir rapporter le premier défaut. Bugzilla, Trac et Redmine exigent tous une installation ; Jira exige en plus une configuration.
3. **L'outil est là où sont déjà les gens.** Le suivi n'est pas un système à adopter, c'est une fonctionnalité déjà présente à côté du code que l'on consulte de toute façon.

Ces trois points font système : le tracker cesse d'être une décision d'outillage pour devenir un **acquis de la plateforme**. C'est ce déplacement, plus que la qualité intrinsèque du produit, qui explique la généralisation du modèle. La contrepartie est réelle et bien documentée : le modèle ne porte nativement ni sévérité, ni composant, ni chemin critique, et les projets qui en ont besoin le reconstruisent à coups de conventions d'étiquettes non vérifiées.

### 5.4 La reconstruction progressive de la structure

L'histoire récente est celle d'un retour partiel de ce qui avait été retiré, cette fois **par ajout facultatif** et non par obligation initiale :

- **types d'issue** et **sous-issues** (hiérarchie parent-enfant) ;
- **dépendances** : en public preview courant 2025, puis disponibles en général le 21 août 2025, les relations « est bloqué par » et « bloque » permettent de déclarer qu'un travail doit être terminé avant qu'un autre puisse commencer, avec une limite de 50 liens par type de relation. GitHub qualifie la fonctionnalité de « l'une des plus demandées » ;
- exposition de ces relations dans l'API, les webhooks et le CLI (`--blocked-by`, `--blocking`, et données de parent, sous-issue, type et dépendance dans `gh issue view` et `gh issue list`), annoncée le 10 juin 2026.

**Lecture.** Cette trajectoire est le fait empirique le plus instructif de la section : partie d'une liste plate à deux états, la plateforme la plus adoptée du monde a mis quinze ans à réintroduire la **relation de blocage**, et l'a fait sous la pression de la demande. Cela confirme le constat 2 de la thèse (section 2.4) : la liste plate ne suffit pas, et ce qui manque en premier n'est ni la sévérité ni la priorité, mais **la dépendance**.

## 6. Les trackers distribués fondés sur des fichiers

Cette famille est peu connue mais directement pertinente pour tout système dont l'interface de travail est constituée de fichiers versionnés.

### 6.1 Le principe

L'enregistrement de travail est un **fichier texte dans le dépôt**, versionné avec le code, donc : clonable, consultable hors ligne, modifiable avec un éditeur, fusionnable, et daté par l'historique du gestionnaire de versions. Le tracker n'est plus un service mais un **format plus des conventions**.

### 6.2 Les réalisations documentées

| Système | Trait distinctif |
|---|---|
| **Fossil** (D. Richard Hipp) | Gestionnaire de versions distribué intégrant nativement wiki, suivi de tickets et interface web. Le suivi n'est pas greffé : il fait partie du modèle de données du gestionnaire de versions. Les tickets sont locaux et synchronisés. |
| **Ditz** | Base d'issues sur disque, format ligne à ligne éditable à la main, conçue pour git, darcs, Mercurial et Bazaar. |
| **Bugs Everywhere** | Le plus abouti et le plus vivant de la génération des trackers distribués, selon les recensements comparatifs. |
| **bug** (driusan) | Écrit les signalements en fichiers texte simples ; revendique explicitement que l'on puisse **voir, éditer et comprendre les bogues sans l'outil**. |
| **GitIssius** | Stocke les bogues dans le dépôt du code, sur une branche dédiée qu'il n'est pas nécessaire d'extraire. |
| **TrackDown** | Suivi en Markdown pur, pensé pour de petites équipes distribuées et déconnectées, avec l'argument du « git clone pour vos tickets ». |

### 6.3 Ce que la famille a établi, et ce qu'elle n'a pas réussi

**Acquis conceptuels** :

1. **L'indépendance à l'outil est un critère de conception explicite** (formulé par `bug`) : le contenu doit rester lisible et modifiable sans le programme qui le gère. C'est ce qui distingue un format d'un logiciel.
2. **La colocalisation** de l'enregistrement et du code garantit que les deux évoluent dans le même commit, donc que la divergence est détectable mécaniquement. C'est le même argument que celui des *docs as code* ([`FND-018`](FND-018-cas-usage-besoins-utilisateurs.md) section 8.6).
3. **L'historique du gestionnaire de versions se substitue au journal d'audit** du tracker : qui a changé quoi, quand, est déjà porté par le dépôt. Le tracker n'a donc pas à réimplémenter cette couche.

**Échec d'adoption, et ses causes.** Aucun de ces systèmes n'a atteint une diffusion notable, à l'exception de Fossil dans sa niche. Les recensements comparatifs pointent des causes convergentes :

- **le conflit de fusion sur les métadonnées** : deux personnes qui modifient l'état du même enregistrement sur deux branches produisent un conflit sur un fichier que ni l'une ni l'autre ne considère comme du contenu ;
- **l'absence de point d'entrée pour le rapporteur externe** : un utilisateur qui n'a pas le dépôt ne peut pas rapporter, ce qui est rédhibitoire pour un projet ouvert et **sans objet pour un système à usage personnel ou en équipe restreinte** ;
- **le coût d'un outil de consultation** : sans interface, l'interrogation transverse (« que reste-t-il d'ouvert ? ») exige un programme, et écrire ce programme est le vrai coût du modèle.

**Lecture.** Les deux premières causes d'échec sont des propriétés du **contexte multi-contributeurs ouvert**, pas du modèle. Pour un dépôt à contributeur unique ou à équipe restreinte, le modèle fichier ne porte aucun de ces défauts, et conserve tous ses acquis. La seule difficulté qui subsiste est la troisième, et elle est bornée : c'est un problème d'outillage de lecture, pas de conception.

## 7. Structures relationnelles du travail

C'est le cœur théorique de cette fondation. Toutes les traditions ci-dessous répondent à la même question : **comment représenter que le travail n'est pas une liste ?**

### 7.1 L'ingénierie des exigences orientée buts (GORE)

Le GORE est la branche de l'ingénierie des exigences qui élicite les exigences à partir de **buts de haut niveau**. Ses cadres principaux sont KAOS, i\*, Tropos, GBRAM et le NFR Framework. Ils produisent tous un **graphe de buts** où les buts de haut niveau représentent l'état final à atteindre et les buts de bas niveau les moyens d'y parvenir.

**KAOS** (van Lamsweerde et al., Université catholique de Louvain) repose sur quatre éléments : les **buts** (objectifs que le système doit satisfaire), le **raffinement** (relation reliant un but à ses sous-buts), les **obstacles** (conditions susceptibles d'empêcher l'atteinte d'un but) et les **agents** (objets actifs qui réalisent). Deux mécanismes sont directement transposables.

1. **Le raffinement en graphe ET / OU.** Un but se décompose soit en une conjonction de sous-buts tous nécessaires (ET), soit en une disjonction d'alternatives (OU). La distinction ET / OU est structurante : elle dit si les branches sont **toutes requises** ou si elles sont des **chemins concurrents** vers le même but. Une liste, et même un arbre non typé, perdent cette information.
2. **La navigation bidirectionnelle par question.** Le raffinement se parcourt **de haut en bas en demandant « comment ? »** et **de bas en haut en demandant « pourquoi ? »**. C'est la propriété opérationnelle la plus utile du modèle : elle donne un protocole mécanique pour construire et vérifier le graphe, et elle garantit que tout élément du graphe justifie son existence par un chemin remontant jusqu'à un but racine.

**L'analyse d'obstacles.** KAOS anticipe les comportements exceptionnels pour dériver des exigences plus complètes et plus réalistes. Les obstacles se raffinent comme les buts, par décomposition ET / OU. Un obstacle est donc un objet de **première classe**, au même titre que le but : ce n'est pas un défaut du modèle, c'est un élément du modèle.

**Lecture.** Le GORE est le corpus académique le plus proche d'un « graphe d'intention ». Sa contribution transposable n'est pas la notation, qui est lourde et outillée pour des systèmes critiques, mais **trois invariants** : un but racine unique justifie tout le graphe ; toute arête est étiquetée d'une relation typée ; l'obstacle est un noeud du graphe, pas une annexe.

### 7.2 La théorie des contraintes et ses arbres

La théorie des contraintes (Goldratt, *The Goal*, 1984 ; *Critical Chain*, 1997) est une philosophie de gestion centrée sur l'identification de **la contrainte unique** qui limite la performance globale d'un système. Ses *Thinking Processes* comprennent cinq outils, dont trois importent ici :

- **l'arbre de la réalité actuelle** (*Current Reality Tree*), ensemble d'entités reliées par des flèches de cause à effet, destiné à analyser plusieurs problèmes à la fois et à remonter aux **causes racines communes** à la plupart d'entre eux ;
- **le nuage** (*Evaporating Cloud*), qui expose et brise le conflit sous-jacent au problème central ;
- **l'arbre des prérequis** (*Prerequisite Tree*), qui identifie les conditions préalables à satisfaire et répond à la question « comment provoquer le changement ? ».

**Lecture.** Deux apports transposables. D'abord, **la focalisation** : à tout instant, un système a une contrainte dominante, et travailler ailleurs n'améliore pas le débit global. C'est l'argument théorique le plus fort en faveur d'une **priorité unique** plutôt que d'un ordre total sur un backlog. Ensuite, **le prérequis comme relation première** : l'arbre des prérequis est structurellement un graphe de blocage, et il est construit à rebours depuis l'objectif, ce qui est exactement la navigation « pourquoi ? » du GORE appliquée à l'action.

### 7.3 Dépendance, blocage et chemin critique

La tradition de gestion de projet (PERT, méthode du chemin critique) formalise depuis les années 1950 le graphe orienté acyclique des tâches et la notion de **chemin critique** : la plus longue chaîne de dépendances, qui détermine la durée minimale de l'ensemble. Sa transposition au suivi logiciel est partielle, parce que le suivi logiciel ne dispose généralement pas d'estimations de durée fiables. Ce qui se transpose sans estimation, en revanche, c'est la **structure** : dans un graphe de dépendances, l'ensemble des noeuds **sans prédécesseur non résolu** est exactement l'ensemble des travaux immédiatement exécutables. Ce calcul ne demande aucune estimation, seulement des arêtes.

C'est cette propriété qui rend la relation de blocage plus utile qu'un champ de priorité : **la priorité est une opinion, le blocage est un fait vérifiable**.

### 7.4 La direction de la relation et l'obsolescence

Un point rarement traité par la littérature outillée mérite d'être relevé, parce qu'il est une conséquence logique du graphe orienté.

Si l'on pose la relation « la résolution de X débloque l'avancement de Y », alors X est un **moyen** et Y une **fin**. Deux conséquences en découlent.

1. **La relation n'est pas commutative** ; le graphe est orienté. C'est acquis partout (GitHub distingue « bloque » et « est bloqué par », KAOS oriente le raffinement).
2. **Un moyen peut cesser d'être nécessaire sans avoir été réalisé.** Si Y est atteint par un autre chemin, X devient sans objet. Ce n'est pas un cas dégénéré : c'est la conséquence directe du raffinement **OU** de KAOS, où plusieurs branches sont des chemins alternatifs vers le même but. La résolution d'une branche rend les autres obsolètes.

Cette seconde conséquence est théoriquement fondée et pratiquement absente des outils : les trackers savent fermer un enregistrement comme « résolu » ou « ne sera pas corrigé », mais aucun ne dérive mécaniquement l'obsolescence d'un moyen depuis l'atteinte de sa fin. Elle a une portée pratique considérable : **elle établit qu'il est normal qu'une part du travail enregistré ne soit jamais faite**, et fournit le critère qui distingue l'abandon raisonné de l'abandon par oubli. C'est la réponse structurelle au problème de l'enflure du backlog traité en section 9.

### 7.5 Note sur les cartographies d'intention

L'impact mapping (Adzic, 2012) et le story mapping (Patton, 2014) construisent également des structures reliant un but à des livrables. Ils sont traités en [`FND-018`](FND-018-cas-usage-besoins-utilisateurs.md) section 4.5 et ne sont pas repris ici. Un seul point est à retenir pour la présente fondation : ces techniques sont des **cartes d'atelier**, produites en séance et non maintenues comme un système d'information persistant. Elles ne fournissent donc pas de modèle de suivi, mais elles confirment la structure : but, acteur, impact, livrable, reliés par des arêtes typées.

## 8. Le comportement attendu comme objet documentaire

La définition du défaut (section 2.3) fait dépendre le suivi des défauts d'un **comportement attendu énonçable**. Où cet énoncé vit-il ? La littérature offre trois réponses, qui ne sont pas équivalentes.

1. **Dans le rapport lui-même** (modèle Spolsky) : l'attendu est le point 2 du triplet, énoncé au cas par cas par le rapporteur. Coût nul, mais l'attendu est **local, non partagé, non vérifiable** et potentiellement contradictoire d'un rapport à l'autre.
2. **Dans une spécification ou une exigence** : l'attendu est un énoncé normatif durable, dont le rapport de défaut se contente de citer la clause violée. Coût élevé en amont, mais l'attendu devient **arbitrable** : on peut trancher si le comportement observé est un défaut ou si c'est la spécification qui est fautive.
3. **Dans un exemple exécutable** (specification by example, Gherkin, tests d'acceptation) : l'attendu est un scénario `Given / When / Then` qui est à la fois documentation et test. Given établit le contexte et les préconditions, When décrit l'action, Then définit le résultat observable attendu. La propriété décisive est que **l'énoncé ne peut pas se périmer silencieusement** : s'il diverge du système, il échoue. Traité en détail en [`FND-018`](FND-018-cas-usage-besoins-utilisateurs.md) section 4.3.

**Lecture.** Ces trois réponses forment un gradient de coût et de garantie, et non des options exclusives : le rapport local est toujours nécessaire, le renvoi normatif est ce qui rend le défaut arbitrable, l'exemple exécutable est ce qui rend l'attendu non périssable. La question de savoir s'il faut une ressource documentaire **dédiée** au comportement attendu, distincte de l'exigence et du test, n'est pas tranchée par la littérature : la tradition normative (IEEE 29148) la place dans l'exigence, la tradition BDD la place dans le test. Aucune école établie ne défend une troisième ressource autonome. C'est un argument de prudence, pas une interdiction.

## 9. Méthodes de conduite du travail

Ces méthodes ne sont pas des systèmes de suivi, mais elles déterminent ce que le suivi doit représenter.

### 9.1 GTD et la capture

La méthode de David Allen (*Getting Things Done*, 2001) repose sur cinq étapes : capturer, clarifier, organiser, réfléchir, engager. Son idée fondatrice, reprise par tous les cadres de gestion de connaissance personnelle ultérieurs, est de **sortir tout de sa tête vers un système externe de confiance**, puis de traiter cette matière en actions concrètes. Deux mécanismes importent ici :

- **la prochaine action** (*next action*) : l'action physique concrète immédiatement exécutable, qui remplace une formulation vague ;
- **la liste « un jour peut-être »** (*someday / maybe*) : le réceptacle explicite de ce qui est retenu sans être engagé. Son existence est ce qui rend la capture sans culpabilité possible : on peut enregistrer sans s'engager.

**Lecture.** GTD répond précisément au besoin de « garder en mémoire ce qu'on pense devoir être fait ». Sa contribution n'est pas une structure mais une **discipline de séparation** : ce qui est capturé n'est pas encore du travail engagé, et confondre les deux est ce qui rend un backlog anxiogène. La distinction capture / engagement est orthogonale à la distinction défaut / évolution, et les deux doivent coexister.

### 9.2 Kanban, en-cours et loi de Little

Le Kanban impose une **limite d'en-cours** : achever avant d'entamer. La loi de Little relie en-cours, débit et délai : pour un système stable, le délai moyen est proportionnel à l'en-cours divisé par le débit. La conséquence est quantitative et non idéologique : **réduire l'en-cours réduit le délai**. À la limite, le flux pièce à pièce traite une unité à la fois. C'est la justification chiffrée de la focalisation, complémentaire de l'argument de la contrainte unique de la théorie des contraintes (section 7.2).

### 9.3 SMART, OKR, INVEST

- **SMART** (Doran, 1981 : Specific, Measurable, Assignable, Realistic, Time-related) est une liste de contrôle mnémotechnique pour rédiger des objectifs. Sa légitimation par la théorie de la fixation d'objectifs de Locke et Latham est partielle et contestée : Locke et Latham valorisent des objectifs **difficiles**, là où le « R » de SMART pousse au prudent. SMART est mal adapté au travail créatif ou exploratoire, ce que la recherche récente confirme.
- **OKR** (Grove chez Intel, diffusé par Doerr) découple un **objectif qualitatif et ambitieux** de **résultats clés quantitatifs**. Ce découplage est le meilleur analogue disponible d'une séparation entre un sujet ouvert et une unité mesurable.
- **INVEST** (Wake, 2003) qualifie une unité livrable et non un objectif ; ses critères *Small* et *Testable* sont le pendant livrable du S, du M et du T. Traité en [`FND-018`](FND-018-cas-usage-besoins-utilisateurs.md) section 4.2.

**Lecture.** La convergence de ces trois cadres, avec GTD et Kanban, tient en une phrase : **il faut deux régimes distincts**, l'un ouvert, durable et non mesurable pour le sujet, l'autre borné, mesurable et fermable pour l'unité de travail. Ce que ni SMART, ni OKR, ni INVEST ne fournissent, c'est la **structure de relation entre les sujets** : c'est ce que le graphe de la section 7 apporte.

## 10. Critiques établies de la pratique du suivi

### 10.1 La critique radicale : ne pas suivre, réparer

Allen Holub soutient qu'un système de suivi de défauts est le **symptôme** d'un problème plus profond, à savoir une attention insuffisante à la qualité. Sa proposition : corriger en heures ou en jours plutôt qu'en semaines ; prévenir par le développement piloté par les tests ; **jeter les signalements de plus d'un mois**, au motif que « si c'est important, ça reviendra » ; prévoir environ 30 % de temps de marge pour absorber l'imprévu. Il affirme que l'amélioration de la qualité **augmente** la vitesse de développement.

Cette position est minoritaire et argumentée principalement par l'expérience. Sa valeur ici n'est pas prescriptive mais diagnostique : elle identifie correctement que **la taille du stock d'enregistrements non traités est une mesure de la dette de décision**, et que le tracker peut fonctionner comme un dispositif d'évitement de la décision.

### 10.2 Le pourrissement du stock

Le constat le plus documenté est que les signalements se périment : le code change, et les détails du rapport (versions, chemins, étapes) deviennent faux. Un enregistrement ancien non traité n'est donc pas de l'information conservée, c'est de l'information **dégradée** dont le coût de revalidation peut dépasser le coût de reproduction du problème. Certains systèmes ont introduit un état `STALE` : un enregistrement qui n'est pas fermé mais qui disparaît des recherches par défaut, ce qui est un aveu du problème plutôt qu'une solution.

Des chiffres circulent chez les éditeurs d'outils (baisse de vélocité de 28 % sur six mois pour des équipes à backlog non géré, hausse de 35 % du coût de changement de contexte, cas client chiffré à 1,2 M$). Ils sont d'origine commerciale, non reproductibles, et rapportés ici comme illustration du discours du secteur, non comme donnée établie.

### 10.3 Les coûts de triage et de qualité de rapport

L'état de l'art de 2025 recense les défaillances structurelles suivantes :

- **qualité de rapport** : information incomplète ou vague exigeant des allers-retours ; absence de variables d'environnement et de sévérité, qualifiées de « *process smells* » ; difficulté des rapporteurs non techniques face aux formats structurés ;
- **reproductibilité** : les bogues non reproductibles représentent de 12,77 % à 24,26 % des signalements dans les grands projets (Goyal et Sardana, 2019) ;
- **triage** : classification manuelle laborieuse, subjectivité de la sévérité et de la priorité, stocks écrasants ;
- **traçabilité** : les développeurs omettent de relier les demandes de fusion aux enregistrements, ce qui perd le contexte ;
- **doublons et signalements invalides** : détection médiocre, difficulté à distinguer un vrai défaut d'une incompréhension ou d'une mauvaise configuration ;
- **latence de communication** : une étude ancienne (Korkala et al., 2006) associe une hausse des taux de défauts à une dépendance croissante aux outils asynchrones.

### 10.4 Anti-motifs de conception d'un système de suivi

Synthèse des sections précédentes, formulée en anti-motifs :

| Anti-motif | Mécanisme | Conséquence |
|---|---|---|
| Prolifération de champs | chaque partie prenante veut sa dimension | coût de saisie prohibitif, sous-déclaration, base non représentative |
| Flux d'états riche | transitions modélisées finement | états jamais employés, écart entre le modèle et l'usage |
| Liste plate | pas de relation typée entre enregistrements | impossible de calculer ce qui est exécutable maintenant |
| Priorité comme opinion | champ de priorité sans référentiel | inflation de la priorité haute, champ non informatif |
| Stock sans péremption | rien ne sort sans être fait | information dégradée, coût de relecture croissant |
| Confusion capture / engagement | tout enregistrement est un engagement | anxiété, réticence à capturer, perte d'information en amont |
| Classification à faible volume | ODC ou équivalent sur quelques dizaines d'éléments | coût de classement sans agrégat interprétable |
| Attendu implicite | aucun énoncé de comportement attendu | impossible d'arbitrer si c'est un défaut ou une évolution |

## 11. Ce que change l'agent IA

L'état de l'art prospectif de 2025 (Gnanasekaran et al.) propose un cadre où des agents fondés sur des LLM interviennent aux points de friction recensés en section 10.3 : rapport conversationnel guidé (extraction en temps réel du comportement observé, du comportement attendu et de l'environnement) ; complétion automatique des rapports incomplets avec conservation de l'original ; reproduction itérative par génération de cas de test ; classification prédictive de la sévérité et du type ; traçabilité automatique défaut vers fonctionnalité par génération augmentée de récupération ; évaluation de validité ; assignation assistée ; localisation sémantique ; génération et vérification de correctifs ; intégration au pipeline. Le cadre revendique explicitement un **humain dans la boucle** aux points de responsabilité, et se présente comme une augmentation et non un remplacement.

**Lecture critique, en trois points.**

1. **Le coût de saisie n'est plus le facteur limitant.** Toute l'histoire de la section 5 est gouvernée par le coût marginal de production d'un enregistrement pour un humain. Si un agent peut rédiger un enregistrement structuré et complet à partir d'une phrase, l'arbitrage de la doctrine du champ rare (section 4.3) se déplace. Cela ne signifie pas que la richesse redevient gratuite : le coût se déplace de la **saisie** vers la **lecture et la validation humaines**, qui restent des ressources rares. La contrainte de concision se justifie désormais par le coût de relecture, pas par le coût d'écriture.
2. **La structure lisible par un programme devient prioritaire sur l'ergonomie humaine.** Un agent exploite un graphe de dépendances typé bien mieux qu'un humain n'exploite un tableau de bord. Ce qui plaidait contre les relations formelles (le coût de leur maintien à la main) s'affaiblit ; ce qui plaidait pour (la calculabilité de ce qui est exécutable) se renforce.
3. **Le risque se déplace vers l'enflure.** Un agent qui produit des enregistrements sans coût peut saturer le stock plus vite qu'un humain ne peut le trier, ce qui aggrave mécaniquement les problèmes de la section 10.2. Le mécanisme d'obsolescence de la section 7.4 cesse alors d'être un raffinement théorique pour devenir une nécessité de conception.

## 12. Comparaison synthétique

| Tradition | Ce qu'elle qualifie | Apport structurel | Limite |
|---|---|---|---|
| Bug tracker web (Bugzilla et descendance) | un défaut | modèle de données canonique, flux d'états, classification | coût de saisie et d'administration, structure obligatoire |
| Issues de GitHub | une demande quelconque | coût d'entrée minimal, contiguïté au code, étiquette libre | liste plate, aucune sémantique native, relations tardives |
| Tracker distribué en fichiers | une demande quelconque | indépendance à l'outil, colocalisation, historique gratuit | pas d'entrée externe, conflits de fusion, outil de lecture à écrire |
| ODC et IEEE 1044 | un défaut classé | mesure du procédé, notion de déclencheur | coût injustifiable à faible volume |
| GORE (KAOS, i\*) | un but | raffinement ET / OU, navigation pourquoi / comment, obstacle de première classe | notation lourde, outillée pour le critique |
| Théorie des contraintes | une contrainte | focalisation sur une contrainte unique, arbre des prérequis | vocabulaire industriel, peu d'outillage logiciel |
| PERT et chemin critique | une tâche datée | dépendance, calcul de l'exécutable, chemin critique | exige des estimations peu fiables en logiciel |
| GTD | une action | capture sans engagement, prochaine action, « un jour peut-être » | pas de structure de relation |
| Kanban et loi de Little | un flux | justification quantitative de l'en-cours minimal | ne dit rien de ce qu'il faut faire |
| SMART, OKR, INVEST | un objectif ou une unité livrable | séparation des deux régimes, ouvert contre mesurable | aucune structure entre les sujets |
| Spécification par l'exemple | un comportement attendu | attendu non périssable car exécutable | coût d'écriture et d'exécution |

## 13. Synthèse

1. **Le modèle de données du suivi est un acquis stable** : identité, description, classification, état, imputation, temporalité, historique, relations. Ce qui distingue les systèmes n'est pas ce modèle mais le **degré d'obligation** qu'ils imposent à chaque dimension.
2. **Le coût marginal d'entrée gouverne l'adoption.** C'est la thèse de Spolsky (2000) et c'est l'explication du succès des issues de GitHub : suppression de tous les champs obligatoires, deux états, aucune installation, présence là où sont déjà les gens. La contrepartie est l'absence de sémantique native, reconstruite ensuite par conventions non vérifiées.
3. **Le triplet du rapport de défaut (reproduction, attendu, observé) est le minimum irréductible**, et il est auto-vérifiant : ce qui ne peut pas énoncer son attendu n'est pas un défaut.
4. **La liste plate est structurellement insuffisante, et ce qui manque en premier est la dépendance.** Le fait empirique décisif est la trajectoire de GitHub, qui a réintroduit les sous-issues puis les relations « bloque » et « est bloqué par » (disponibles en général le 21 août 2025), quinze ans après avoir supprimé toute structure.
5. **Les traditions sérieuses convergent vers un graphe orienté à arêtes typées** : raffinement ET / OU du GORE, arbre des prérequis de la théorie des contraintes, graphe de dépendances du chemin critique. Deux invariants sont transposables sans leur outillage : tout noeud se justifie par un chemin remontant vers un but racine (navigation « pourquoi ? ») ; l'ensemble des noeuds sans prédécesseur non résolu est exactement l'ensemble des travaux exécutables maintenant, calculable sans aucune estimation.
6. **L'obsolescence par résolution amont est une conséquence logique du graphe, et elle est absente de tous les outils.** Elle établit qu'il est normal qu'une part du travail enregistré ne soit jamais faite, et fournit le seul critère principiel connu pour distinguer l'abandon raisonné de l'oubli. C'est la réponse structurelle à l'enflure du stock.
7. **Deux régimes sont nécessaires** : le sujet ouvert, durable, non mesurable, et l'unité bornée, mesurable, fermable. C'est le point de convergence de OKR, GTD, INVEST et SMART. Aucun de ces cadres ne fournit la structure reliant les sujets entre eux.
8. **La capture doit être séparée de l'engagement.** C'est l'apport propre de GTD (liste « un jour peut-être ») et la condition pour que l'enregistrement d'une idée ne soit pas vécu comme une dette.
9. **Le modèle fichier versionné a des acquis conceptuels solides** (indépendance à l'outil, colocalisation, historique gratuit) et ses causes d'échec documentées sont propres au **contexte ouvert multi-contributeurs**, pas au modèle. Le coût résiduel est l'écriture de l'outil de lecture.
10. **L'agent IA déplace l'arbitrage.** Le coût de production d'un enregistrement structuré s'effondre ; le coût de relecture humaine et le risque d'enflure deviennent les contraintes dominantes. La structure calculable gagne en valeur ; la concision reste requise, mais pour une raison différente.

## 14. Limites et péremption

- **Non couvert** : l'estimation et la planification prédictive ; la gestion de portefeuille et le suivi multi-équipes ; l'évaluation comparative des outils du marché ; la fouille de dépôts de bogues (*mining software repositories*) au-delà des chiffres cités ; les aspects juridiques et de confidentialité du signalement ; la priorisation de backlog, traitée en [`FND-018`](FND-018-cas-usage-besoins-utilisateurs.md) section 8.2.
- **Sources primaires non lues directement** : Doran (1981), Locke et Latham (1990), Goldratt (1984, 1997), Allen (2001), Chillarege et al. (1992), IEEE 1044-2009 (norme payante). Les affirmations qui en dépendent passent par des sources secondaires ou encyclopédiques et sont à traiter comme une revue de cadrage.
- **Chiffres commerciaux non validés** : les statistiques de la section 10.2 proviennent de publications d'éditeurs et ne constituent pas une donnée de recherche.
- **Péremption** : la section 5.4 (évolution du modèle des issues de GitHub) et la section 11 (agent IA) évoluent vite ; à revalider dans les douze mois. Les sections 3, 4, 6, 7 et 9 portent sur des acquis stables ; horizon de revalidation de trois à cinq ans. La section 10.3 s'appuie sur un état de l'art de 2025 dont les chiffres de reproductibilité datent de 2019.

## 15. Sources

- Histoire et taxonomie du suivi de bogues, cycle de vie, problèmes recensés, perspective IA : [Past, Present, and Future of Bug Tracking in the Generative AI Era, arXiv:2510.08005 (2025)](https://arxiv.org/html/2510.08005v1)
- Histoire des systèmes de suivi (GNATS, Bugzilla 1998, Mantis 2000, Jira 2003) : [The history of issue tracking systems, PMRobot (2012)](http://blog.pmrobot.com/2012/02/history-of-issue-tracking-systems.html) ; [Bug tracking system, Wikipedia](https://en.wikipedia.org/wiki/Bug_tracking_system)
- Triplet du rapport de défaut, doctrine du champ rare, règles de processus : [Joel Spolsky, Painless Bug Tracking (2000)](https://www.joelonsoftware.com/2000/11/08/painless-bug-tracking/)
- Orthogonal Defect Classification (Chillarege et al., IBM Research) : [Orthogonal defect classification, Wikipedia](https://en.wikipedia.org/wiki/Orthogonal_defect_classification) ; [ODC, présentation JaSST (2011)](https://www.jasst.jp/archives/jasst11w/pdf/S3-1.pdf)
- IEEE 1044-2009, Standard Classification for Software Anomalies : [notice GlobalSpec](https://standards.globalspec.com/std/1233101/ieee-1044)
- Dépendances entre issues GitHub, disponibilité générale du 21 août 2025 : [Dependencies on issues, GitHub Changelog](https://github.blog/changelog/2025-08-21-dependencies-on-issues/) ; exposition CLI et API : [Manage sub-issues, types, and dependencies from GitHub CLI](https://github.blog/changelog/2026-06-10-manage-sub-issues-types-and-dependencies-from-github-cli/) ; demande historique : [Feature request: « is blocked by » link between issues](https://github.com/orgs/community/discussions/11973)
- Trackers distribués fondés sur fichiers : [Ditz](https://github.com/jashmenn/ditz) ; [bug (driusan)](https://github.com/driusan/bug) ; [GitIssius](https://github.com/glogiotatidis/gitissius) ; [TrackDown](https://github.com/mgoellnitz/trackdown) ; [Current State of the Distributed Issue Tracking (recensement comparatif)](https://matej.ceplovi.cz/blog/current-state-of-the-distributed-issue-tracking.html) ; [Other Distributed Issue Trackers (wiki deft)](https://github.com/npryce/deft/wiki/Other-Distributed-Issue-Trackers) ; [Fossil, discussion Lobsters](https://lobste.rs/s/y9adnv/fossil_distributed_vcs_with_wiki_issue)
- Ingénierie des exigences orientée buts, KAOS, i\*, raffinement ET / OU, analyse d'obstacles : [Lapouchnian, Goal-Oriented Requirements Engineering: An Overview of the Current Research (Toronto)](https://www.cs.utoronto.ca/~alexei/pub/Lapouchnian-Depth.pdf) ; [Chung, GORE : KAOS (UT Dallas)](https://www.utdallas.edu/~chung/SYSM6309/KAOS-AORE.pdf) ; [van Lamsweerde, Goal-Driven Requirements Engineering: the KAOS Approach (UCLouvain)](https://webperso.info.ucl.ac.be/~avl/gore.php)
- Théorie des contraintes, arbres de réflexion, arbre des prérequis : [Theory of Constraints, Scholarpedia](http://www.scholarpedia.org/article/Theory_of_Constraints) ; [Current reality tree, Wikipedia](https://en.wikipedia.org/wiki/Current_reality_tree_(theory_of_constraints)) ; [A Deep Dive into TOC Thinking Processes](https://www.a-dato.com/learning/a-deep-dive-into-toc-thinking-processes/)
- Critique du suivi, réparation immédiate, marge de 30 % : [Allen Holub, Don't track bugs, fix them](https://holub.com/bugs/)
- Pourrissement du stock, coûts de triage, chiffres d'origine commerciale : [Managing the Bug Backlog, Full Scale](https://fullscale.io/blog/managing-the-bug-backlog/) ; [Scaling Bug Tracking Across Engineering Teams, Bugzy](https://bugzy.io/blogs/scaling-bug-tracking-across-teams/)
- GTD, capture, prochaine action, liste « un jour peut-être » : [Getting Things Done: A Simple Step-By-Step Guide, Todoist](https://www.todoist.com/productivity-methods/getting-things-done) ; [Knowledge and Task Management Systems](https://bitsofchris.com/p/knowledge-task-management-systems-part-2)
- Comportement attendu en Given / When / Then, BDD, documentation vivante : [Given-When-Then Acceptance Criteria](https://www.parallelhq.com/blog/given-when-then-acceptance-criteria) ; [Gherkin User Stories Acceptance Criteria Guide](https://testquality.com/gherkin-user-stories-acceptance-criteria-guide/)
- Cadres de priorisation (renvoi, non repris ici) : [`FND-018`](FND-018-cas-usage-besoins-utilisateurs.md) section 8.2
