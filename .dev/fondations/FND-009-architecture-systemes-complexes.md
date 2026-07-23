---
type: fondation
version: 0.1.0
title: "Architecture des systèmes complexes : méthodes, visualisation, artefacts et pratiques"
status: actif
date: 2026-07-18
---

# FND-009 - Architecture des systèmes complexes : méthodes, visualisation, artefacts et pratiques

- **Objectif** : établir une base factuelle et sourcée sur l'architecture des systèmes (complexes) : les principales méthodes/frameworks/méthodologies, les techniques de visualisation, les artefacts documentaires, les bonnes pratiques et anti-patterns, la façon dont les méthodologies de travail avec l'IA traitent l'architecture, et les conventions des harnais IA en la matière. Sert de référence à l'analyse de l'architecture effective du dépôt et à la définition du harnais `ARCHITECTURE.md`.

## Note de rigueur

Fondation appuyée sur des sources primaires (norme ISO/IEC/IEEE 42010 ; le C4 model de Simon Brown ; le billet fondateur « ARCHITECTURE.md » d'Alex Kladov/matklad) et des sources secondaires de référence (comparatifs de frameworks, littérature sur les anti-patterns, guides C4). Les frameworks et normes sont **stables** ; les conventions IA (ARCHITECTURE.md pour agents) sont plus récentes et évolutives. Recherche menée le 2026-07-18.

## Cadrage / Thèse

**Question** : comment décrit-on, visualise-t-on et gouverne-t-on l'architecture d'un système, et comment le travail avec l'IA s'en saisit-il ?

**Périmètre** : méthodes, visualisation, artefacts, pratiques, et le rapport de l'IA à l'architecture. Hors périmètre : l'architecture d'un domaine technique particulier (microservices, cloud) au-delà des principes.

**Définitions** :
- **Architecture (d'un système)** : les concepts et propriétés fondamentaux d'un système dans son environnement, incarnés dans ses éléments, leurs relations et les principes de sa conception et de son évolution (esprit d'ISO/IEC/IEEE 42010).
- **Description d'architecture** : l'artefact documentaire qui exprime une architecture, organisé en vues répondant aux préoccupations de parties prenantes.

## 1. Méthodes, frameworks et méthodologies d'architecture

On distingue les **frameworks** (qui organisent l'information et les points de vue) des **méthodologies** (qui donnent un processus).

- **Zachman Framework** : une **ontologie** (matrice de classification) des artefacts d'architecture d'entreprise, croisant des perspectives de parties prenantes (du planificateur au constructeur). Organise, ne prescrit pas de processus.
- **TOGAF** : framework complet d'architecture d'entreprise, avec un **processus** (ADM, Architecture Development Method) pour planifier, concevoir et gouverner une architecture, plus des artefacts, guides et techniques.
- **Modèle 4+1 (Kruchten)** : décrit l'architecture par quatre vues (logique, processus, physique, développement) plus des **scénarios** (use cases) qui les relient.
- **C4 model (Simon Brown)** : terminologie concise pour la **structure statique** d'un logiciel, en quatre niveaux emboîtés et zoomables : **Context, Container, Component, Code**. Notation « boîtes et flèches » simple, adoptée en remplacement d'UML/ArchiMate jugés lourds.
- **ISO/IEC/IEEE 42010** : la norme de la **description d'architecture** (voir §3) : elle cadre les notions de vue, point de vue (viewpoint), partie prenante et préoccupation.
- **Méthodologies d'évaluation et de conception** : **ATAM** (Architecture Tradeoff Analysis Method) pour évaluer une architecture au regard des attributs de qualité ; **ADD** (Attribute-Driven Design) pour la concevoir en partant des attributs ; **DDD** (Domain-Driven Design) pour aligner l'architecture sur le domaine.

Les frameworks structurent (Zachman, 4+1, C4) ; les méthodologies donnent un processus (TOGAF/ADM, ADD, ATAM). C4 et 4+1 sont au **niveau système** (architectes/développeurs) ; Zachman et TOGAF au niveau **entreprise**.

## 2. Techniques de visualisation

- **Diagrammes C4** : les quatre niveaux (Context / Container / Component / Code) forment une carte **hiérarchique et zoomable** ; c'est aujourd'hui la référence « developer-friendly ».
- **UML** : diagrammes de classes (structure interne d'un composant), de séquence (comportement) ; utile en complément de C4 pour le détail.
- **ArchiMate** : langage de modélisation d'architecture d'entreprise ; mappable sur C4.
- **Vues 4+1** : logique, processus, physique, développement, illustrées par des scénarios.
- **« Boîtes et flèches »** : diagrammes simples, souvent préférés aux notations formelles.

Bonnes pratiques de visualisation (C4) : un **titre et une légende** sur chaque diagramme, un étiquetage clair et non ambigu, un niveau de détail adapté à l'audience, une cohérence visuelle (styles, couleurs), et une **mise à jour régulière**.

## 3. Artefacts documentaires de l'architecture

- **Description d'architecture (ISO/IEC/IEEE 42010)** : l'artefact central, organisé en **vues** conformes à des **points de vue**, chacune répondant aux **préoccupations** de **parties prenantes**. C'est le cadre normatif de « la doc d'archi ».
- **ADR (Architecture Decision Record)** : consigne une décision d'architecture (contexte, décision, conséquences, alternatives) ; capture le *pourquoi* des choix, durablement.
- **arc42** : gabarit pragmatique et répandu de documentation d'architecture (contexte, contraintes, vues, décisions, risques).
- **Diagrammes C4** : la carte visuelle (voir §2).
- **Software Architecture Document (SAD)** : document de synthèse (souvent structuré par 4+1 ou 42010).
- **ARCHITECTURE.md** : convention légère (voir §6) : une carte de haut niveau du dépôt, dans le dépôt lui-même.

Ces artefacts se complètent : ADR pour le *pourquoi* des décisions, C4 pour la *carte visuelle*, description 42010/arc42 pour la *vue structurée par préoccupations*, ARCHITECTURE.md pour l'*orientation rapide*.

## 4. Bonnes pratiques et anti-patterns

**Bonnes pratiques** :
- **Intégrité conceptuelle** (Brooks) : une vision unificatrice cohérente prime (voir `FND-014-principes-de-conception-systemes-complexes`).
- **Séparation des préoccupations** et **quasi-décomposabilité** (Simon) : structurer en modules à interfaces stables.
- **Documenter les décisions** (ADR) et non seulement l'état ; capturer le *pourquoi*.
- **Vues adaptées aux préoccupations** (42010) plutôt qu'un unique diagramme fourre-tout.
- **Documentation courte, stable et à jour** ; ne pas la synchroniser ligne à ligne avec le code (matklad).

**Anti-patterns** :
- **Big Ball of Mud** : absence de structure et de séparation des préoccupations, résultat de correctifs court-terme accumulés sans conception ; le code devient incompréhensible et incmaintenable.
- **Ivory Tower architecture** : conception rigide, descendante, totalitaire, par des architectes surestimant leur capacité à tout prévoir avant l'implémentation.
- **Complexité accidentelle** (par « avarice » d'abstraction) : ajouter de l'abstraction au-delà du nécessaire.
- **Golden hammer, stovepipe, analysis paralysis** : sur-appliquer une solution familière, empiler des silos, ou sur-analyser sans livrer.

La ligne de crête : ni **mud** (pas de structure), ni **ivory tower** (structure imposée hors-sol) ; investir dans la conception « une fois que le système atteint une certaine taille », en gardant la documentation légère.

## 5. Comment les méthodologies de travail avec l'IA traitent l'architecture

- **Développement piloté par les spécifications (Spec Kit)** : l'architecture est explicitée à la phase **Plan** (déclarer architecture, stack et contraintes ; l'agent propose un plan technique respectant les patterns organisationnels), après la constitution et la spécification, avant les tâches (voir `FND-011-documents-harness-ia`).
- **L'architecture comme contexte d'agent** : les agents de codage sont « confiants, rapides, et **architecturalement ignorants** de votre code tant qu'on ne le leur dit pas ». Sans description d'architecture, ils devinent la structure et l'intention. La parade consiste à **écrire l'intention architecturale à l'endroit où l'agent regarde toujours : le dépôt** (voir §6).
- **Architecture comme garde-fou** : une architecture documentée sert de critère de conformité pour juger le travail (humain ou agent) et éviter la dérive vers le Big Ball of Mud.

## 6. Conventions des harnais IA concernant l'architecture

- **ARCHITECTURE.md (matklad, 2021)** : convention consistant à placer, à la racine du dépôt (à côté de README/CONTRIBUTING), un fichier donnant aux nouveaux venus (humains **et** agents) une **carte mentale** du code. Principes clés :
  - **Vue d'oiseau d'abord** : commencer par le problème résolu, pas la solution.
  - **Cartographier le code** : répondre à « où est la chose qui fait X ? » et « que fait ce module ? ».
  - **Court et stable** : ne décrire que ce qui change peu, ne pas synchroniser ligne à ligne avec le code, réviser quelques fois par an.
  - Recommandé pour des projets de l'ordre de 10k à 200k lignes.
- **Variantes et outillage** : `DESIGN.md` (intention de conception pour agents) ; des **skills** dédiés (générateurs d'`ARCHITECTURE.md` pour Claude Code) ; des listes de bons exemples (awesome-architecture-md).
- **Fichiers d'instructions d'agent** (`CLAUDE.md`, `AGENTS.md`) : portent souvent une **vue d'ensemble d'architecture** ou un renvoi vers `ARCHITECTURE.md`, précisément parce que c'est le premier endroit lu par l'agent.

Le consensus émergent : une **description d'architecture légère, stable et versionnée dans le dépôt** est l'artefact le plus utile pour orienter un agent, complémentaire des ADR (décisions) et des diagrammes (carte visuelle).

## Synthèse

L'architecture se décrit par des **frameworks** (Zachman, 4+1, C4) et se gouverne par des **méthodologies** (TOGAF/ADM, ADD, ATAM) ; elle se **visualise** aujourd'hui surtout par le C4 (quatre niveaux zoomables) complété d'UML ; elle se **documente** par une description structurée en vues et préoccupations (ISO/IEC/IEEE 42010), des ADR pour le *pourquoi* des décisions, des diagrammes pour la carte, et un `ARCHITECTURE.md` pour l'orientation rapide. Les **bonnes pratiques** (intégrité conceptuelle, séparation des préoccupations, décisions documentées, doc courte et stable) s'opposent aux **anti-patterns** (Big Ball of Mud, Ivory Tower, complexité accidentelle). Le travail avec l'**IA** rend l'architecture **explicite** (phase Plan du SDD) et fait de sa description un **contexte d'agent** indispensable : la convention `ARCHITECTURE.md` répond exactement à ce besoin, en plaçant une carte de haut niveau, courte et stable, à l'endroit que l'agent lit toujours, le dépôt.

## Limites

- Panorama volontairement synthétique : chaque framework (TOGAF, arc42) a une profondeur non couverte ici.
- Les conventions IA (ARCHITECTURE.md pour agents) sont récentes et évolutives ; les faits sont datés (2026-07-18).
- La fondation ne tranche pas quel framework adopter : le choix dépend de l'échelle et des préoccupations du système.

## Sources

- ISO/IEC/IEEE 42010:2022, *Software, systems and enterprise — Architecture description* (référence normative).
- Simon Brown, C4 model : https://c4model.com/ ; Wikipedia : https://en.wikipedia.org/wiki/C4_model
- Comparatif des frameworks (TOGAF / Zachman / C4 / 4+1) : https://www.itar.pro/comparing-architecture-frameworks/
- A. Kladov (matklad), « ARCHITECTURE.md » (2021) : https://matklad.github.io/2021/02/06/ARCHITECTURE.md.html
- awesome-architecture-md (exemples) : https://github.com/noahbald/awesome-architecture-md
- Big Ball of Mud (Foote & Yoder) : https://www.laputan.org/mud/ ; synthèse : https://deviq.com/antipatterns/big-ball-of-mud/
- Anti-patterns d'architecture (synthèses) : https://www.matthewyancer.com/2023/10/09/architecture-anti-patterns.html
- « ARCHITECTURE.md » pour agents de codage (discussion) : https://apidog.com/blog/what-is-design-md-for-coding-agents/
- `FND-011-documents-harness-ia` (méthodologies et harnais IA, ce dépôt) ; `FND-014-principes-de-conception-systemes-complexes` (Simon, Brooks).
