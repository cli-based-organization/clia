---
type: fondation
version: 0.1.0
title: "Ingénierie de conception, livrables et qualité documentaire"
status: actif
date: 2026-06-21
---

# FND-002 - Ingénierie de conception, livrables et qualité documentaire

- **Provenance** : rapatriée depuis `noumanity-dev/ticket-driven-ai/.dev/fondations/FND-002-ingenierie-livrables-qualite.md` (tâche 16, demande explicite). Le corps conserve ses références d'origine (`tda`, tickets, TKT-003, skills de ce dépôt-là), historiques et propres à `ticket-driven-ai`.
- **Objectif** : Établir le socle théorique et méthodologique couvrant l'ingénierie de conception, la définition de livrables, les caractéristiques de qualité, la documentation des spécifications et la production de requis techniques. Fondation pour les livrables SPC, REQ et SKILL-writer introduits dans TKT-003.

## Note de rigueur

Les sources mobilisées sont : standards IEEE et ISO/IEC/IEEE (29148, 25010, 15288, 42010), littérature académique en génie logiciel, et analyse de la pratique terrain dans les repos Noumanity. Les affirmations issues de sources primaires sont citées. Les synthèses et applications au contexte ticket-driven-ai sont des inférences de l'auteur, signalées comme telles.

## Cadrage

### Question directrice

Quels savoirs théoriques et méthodologiques fondent la conception rigoureuse de livrables documentaires, leur évaluation de qualité et leur production à l'aide d'agents IA ?

### Périmètre

Dans le périmètre : ingénierie de conception (principes fondamentaux), ontologie des livrables, caractéristiques de qualité documentaire, spécifications formelles, requis techniques, application à ticket-driven-ai.

Hors périmètre : gestion de projet, modélisation UML/SysML, test logiciel, déploiement.

### Définitions de base

**Livrable** : output concret et délimité produit par un processus de travail, destiné à une partie prenante définie, et évaluable contre des critères de complétude.

**Spécification** : document qui définit rigoureusement et de façon vérifiable ce qu'un système, composant ou objet doit faire, indépendamment de comment il le fait. Elle répond à la question "quoi ?".

**Requis technique** : document qui traduit une spécification en contraintes d'implémentation contextuelles (stack, environnement, performance). Il répond à "comment, ici, avec quoi ?".

**Qualité documentaire** : ensemble des propriétés d'un document qui déterminent son aptitude à remplir son usage prévu (complétude, exactitude, non-ambiguïté, traçabilité).

## Corps

### 1. Ingénierie de conception - principes fondamentaux

L'ingénierie de conception (design engineering) transforme des besoins en solutions réalisables. Elle se structure autour de quatre principes transversaux qui s'appliquent aussi bien aux systèmes logiciels qu'aux documents de travail.

**Séparation des préoccupations (Separation of Concerns - SoC)**

Dijkstra (1974) formule ce principe : "The ability to deal with things at a certain level of detail, without paying attention to the details at the next lower level." Appliqué aux livrables : un document qui traite le "quoi" ne doit pas mélanger le "comment". Une spécification qui parle de stack devient immédiatement fragile - elle couplera le besoin métier à un choix technologique.

**Abstraction et niveaux**

Tout système complexe s'analyse à plusieurs niveaux d'abstraction. Le niveau le plus haut (intention, besoin) est stable; les niveaux inférieurs (implémentation) sont variables. Une bonne architecture documentaire positionne chaque document au bon niveau d'abstraction : INTENTION.md (niveau intention), SPC (niveau comportement observable), REQ (niveau implémentation).

**Traçabilité bidirectionnelle**

ISO/IEC/IEEE 15288 (Systems and Software Engineering Life Cycle Processes, 2023) exige que chaque exigence soit traçable à sa source (en amont) et à sa vérification (en aval). Sans traçabilité, il est impossible de savoir si un changement de besoin impacte l'implémentation, ou si un test couvre bien une exigence donnée.

**Vérifiabilité**

Une exigence non vérifiable n'est pas une exigence : c'est un voeu. "Le système doit être rapide" n'est pas vérifiable. "Le système doit répondre en moins de 200ms pour 95% des requêtes sous charge de 500 utilisateurs simultanés" l'est. Ce principe s'applique aux documents : chaque section d'une spec doit pouvoir donner lieu à un test d'acceptation.

### 2. Ontologie et taxonomie des livrables documentaires

**La distinction document/artefact/livrable**

Ces termes sont souvent confondus. Un **artefact** est tout output d'une activité (code, image, note, email). Un **document** est un artefact textuel structuré. Un **livrable** est un document (ou artefact) formel, délimité, destiné à être remis et évalué. Tout livrable est un document, mais tout document n'est pas un livrable.

**Cycle de vie : instable vers stable**

Un livrable passe par plusieurs états. La notation courante dans les systèmes d'ingénierie distingue : draft (ébauche) - under review (en révision) - approved (approuvé) - published (publié). Ticket-driven-ai reprend ce principe avec ses zones (`.dev/` pour l'instable, `doc/` pour le stable).

**Taxonomie par finalité**

On peut classer les livrables documentaires selon leur finalité :

| Classe | Finalité | Exemples |
|---|---|---|
| Gouvernance | Régir les comportements et décisions | CLAUDE.md, CONSTITUTION.md, ADR |
| Intention | Orienter le travail | INTENTION.md |
| Connaissance | Constituer un savoir réutilisable | FND (essai de fondation) |
| Prescription | Définir ce que doit faire un système | SPC (spécification) |
| Contrainte | Définir comment l'implémenter ici | REQ (requis technique) |
| Playbook | Guider la production d'un livrable | SKILL |
| Trace | Documenter ce qui a été fait | Artefact de travail, commit message |

Cette taxonomie n'est pas exhaustive, mais elle couvre les besoins de ticket-driven-ai. Chaque classe a un positionnement distinct dans le graphe de dépendances : la Gouvernance a autorité sur tout ; l'Intention oriente la Prescription ; la Prescription fonde les Contraintes.

**Propriétés structurantes d'un livrable bien défini**

Un livrable est suffisamment défini quand on peut répondre à ces sept questions :
1. Quoi ? (objet : qu'est-ce que ce document décrit ou prescrit ?)
2. Pour qui ? (destinataire principal)
3. Quand ? (à quel moment du processus de travail est-il produit ?)
4. Par qui ? (humain, agent IA, CLI ?)
5. Où ? (emplacement dans le repo)
6. Comment sait-on qu'il est terminé ? (critères de complétude)
7. Comment évolue-t-il ? (cycle de vie, stabilité)

### 3. Caractéristiques de qualité documentaire

**Le modèle SQuaRE (ISO/IEC 25010:2011)**

Bien que conçu pour la qualité logicielle, SQuaRE fournit un vocabulaire de qualité transférable aux documents. Les caractéristiques pertinentes pour les livrables documentaires :

- **Complétude fonctionnelle** : le document couvre tous les cas dans son périmètre déclaré.
- **Exactitude** : chaque affirmation est correcte.
- **Cohérence** : pas de contradictions internes.
- **Traçabilité** : les sources sont citées et les dépendances identifiées.
- **Maintenabilité** : le document peut être modifié sans introduire d'incohérences.
- **Utilisabilité** : le document est navigable et compréhensible par son destinataire cible.

**Les attributs spécifiques des spécifications (ISO/IEC/IEEE 29148:2018)**

La norme 29148 (Requirements Engineering) définit six attributs pour une bonne exigence individuelle :

1. Nécessaire (necessary) : l'exigence est essentielle ; la supprimer dégrade le système.
2. Appropriée (appropriate) : le niveau d'abstraction correspond au niveau du document.
3. Non ambiguë (unambiguous) : une seule interprétation possible pour tout lecteur compétent.
4. Complète (complete) : toutes les conditions sont spécifiées, y compris les cas d'erreur.
5. Singulière (singular) : une seule exigence par énoncé.
6. Vérifiable (verifiable) : il existe au moins une méthode de vérification.

Pour un ensemble d'exigences, la norme ajoute : cohérent (pas de contradictions entre exigences), faisable (réalisable), limité (dans le périmètre).

**Procédés d'évaluation**

Les méthodes d'évaluation se classent en deux familles :

Méthodes humaines :
- **Walkthrough** : l'auteur guide des réviseurs à travers le document ; objectif = compréhension partagée.
- **Peer review** : révision indépendante par un pair ; objectif = détection d'erreurs.
- **Inspection formelle (Fagan)** : processus structuré en phases (planning, overview, preparation, inspection, rework, follow-up) ; objectif = élimination systématique des défauts.
- **Checklist-based review** : liste de vérification explicite ; objectif = conformité aux standards.

Méthodes automatisées :
- **Linting** : vérification de format (markdown strict, conventions de nommage).
- **Consistency checks** : détection de références cassées ou de contradictions.
- **Traceability matrices** : vérification que chaque exigence est couverte.

Pour ticket-driven-ai, la revue est principalement checklist-based (directives de garde-fou dans CLAUDE.md) et automatisée via les hooks. La Fagan inspection n'est pas adaptée à la cadence des tickets Extreme-SMART.

### 4. Documentation des spécifications

**Qu'est-ce qu'une spécification formelle ?**

Une spécification formelle décrit le comportement observable d'un système ou d'un composant en termes de : entrées, sorties, états, transitions, et contraintes invariantes. Elle répond à "que fait le système dans tous les cas ?" sans dire comment il le fait.

L'adjectif "agnostique au stack" dans la définition du ticket signifie exactement cela : une spec qui dit "le système authentifie les utilisateurs par un mécanisme de token à durée limitée" est valide pour JWT, OAuth, session cookie ou n'importe quelle implémentation. Une spec qui dit "le système utilise JWT RS256 avec expiry de 15 minutes" n'est plus une spécification : c'est un requis.

**Structure standard d'une spécification (IEEE 29148 / SRS)**

La structure recommandée par ISO/IEC/IEEE 29148 pour un Software Requirements Specification (SRS) est :

1. Introduction (portée, public cible, définitions, références)
2. Description générale (contexte, fonctions, caractéristiques des utilisateurs, contraintes générales, hypothèses)
3. Exigences spécifiques (fonctionnelles, qualité, d'interface, de contrainte)
4. Appendices (modèles, glossaire, index)

Pour les livrables de ticket-driven-ai (SPC), cette structure peut être adaptée :
1. Objet (quel système ou composant est spécifié ?)
2. Contexte (pourquoi cette spec existe, quelle intention elle sert)
3. Périmètre (ce qui est dans / hors scope)
4. Comportement (ce que le système fait : fonctions, états, transitions)
5. Interfaces (ce que le système reçoit et produit)
6. Contraintes (ce qui ne peut pas être compromis, indépendamment de l'implémentation)
7. Critères de vérification (comment savoir si le système satisfait cette spec)
8. Glossaire

**Le piège du glissement vers les requis**

Le défaut le plus courant dans la rédaction de spécifications est le glissement vers les requis : l'auteur commence à décrire le "quoi" et dérive vers le "comment". Indicateurs d'alerte :
- Noms de technologie (Node.js, PostgreSQL, REST, JWT)
- Métriques de ressources (mémoire, CPU, nombre de cœurs)
- Détails de déploiement (port, endpoint, chemin de fichier)
- Frameworks ou bibliothèques spécifiques

Chaque fois qu'un de ces éléments apparaît dans une spec, la question à poser est : "est-ce une contrainte invariante du comportement, ou un choix d'implémentation qui pourrait changer ?" Si c'est un choix, cela appartient au REQ.

### 5. Production de requis techniques

**Distinction requis fonctionnels / non-fonctionnels**

Les requis techniques se subdivisent en deux familles classiques :

**Requis fonctionnels** : ce que le système fait, exprimé au niveau de l'implémentation. Exemple : "L'API expose un endpoint POST /auth/token qui accepte un body JSON avec les champs `username` et `password`."

**Requis non-fonctionnels** (aussi appelés quality attributes ou cross-cutting concerns) : contraintes sur comment le système se comporte, à travers toutes ses fonctions. Exemples : performance (latence < 100ms pour le p99), sécurité (authentification requise pour toutes les routes /api/*), disponibilité (99.9% uptime).

ISO/IEC 25010 offre une taxonomie des attributs de qualité : fonctionnalité, fiabilité, performance et efficience, compatibilité, utilisabilité, sécurité, maintenabilité, portabilité.

**Processus de production d'un requis technique**

Un bon processus de production de REQ suit ces étapes :

1. **Partir de la spec** : chaque requis doit être traçable à une ou plusieurs exigences de la spec.
2. **Analyser le contexte d'opération** : infrastructure disponible, contraintes organisationnelles, standards d'entreprise.
3. **Recenser les contraintes imposées** : legacy systems, réglementations, SLA des services tiers.
4. **Effectuer les choix techniques** : pour chaque exigence de la spec, identifier les options d'implémentation disponibles et choisir en documentant le rationale.
5. **Spécifier les critères de vérification** : pour chaque requis, définir comment le tester en environnement d'intégration ou de production.
6. **Gérer les dépendances** : identifier les requis qui en impliquent d'autres (ex: choix du ORM implique le choix de la base de données).

**Les use cases prioritaires comme entrée**

Le ticket mentionne "use cases prioritaires" dans la description du REQ. Les use cases fournissent une perspective centrée utilisateur qui complète la perspective système de la spec. Ils permettent de prioriser les requis en fonction de leur impact sur les scénarios d'usage les plus fréquents ou les plus critiques. Un use case non couvert par un requis révèle un gap.

**Traçabilité spec-requis**

La matrice de traçabilité est l'outil central : chaque ligne de la spec a une ou plusieurs lignes correspondantes dans le REQ. Cette matrice permet de répondre à :
- "Si cette exigence de la spec change, quels requis sont impactés ?"
- "Ce requis, à quelle exigence de la spec correspond-il ?"
- "Y a-t-il des exigences de la spec sans requis associé ?" (gap)
- "Y a-t-il des requis sans exigence spec ? (gold-plating, à éliminer)

### 6. La séparation spécification/requis - enjeu central pour ticket-driven-ai

La séparation SPC/REQ reproduit, au niveau documentaire, le principe de séparation des préoccupations de Dijkstra. Elle a des conséquences pratiques directes.

**Réutilisabilité**

Une spec agnostique peut être instanciée dans plusieurs contextes techniques. L'intention "un système de gestion de tickets" peut avoir une implémentation en CLI bash (ce repo), une en API REST, une en application web. La spec est la même; les REQ divergent.

**Évolutivité**

Le remplacement d'un composant technique (migration de base de données, changement de framework) implique une révision du REQ, pas de la spec. Si la spec change, c'est le comportement attendu qui change - décision de niveau intention, pas de niveau technique.

**Division du travail IA/humain**

Dans un workflow ticket-driven-ai, la répartition naturelle est :
- La spec est co-produite par l'humain et l'agent IA, avec l'humain comme décideur final sur le "quoi".
- Le REQ est majoritairement produit par l'agent IA à partir de la spec et du contexte technique documenté, avec validation humaine.

**Application au contexte Noumanity**

Les repos Noumanity couvrent des domaines variés (présentation, DevOps, plan stratégique). Une spec de "document de présentation" est réutilisable entre projets. Les REQ (outil de présentation, format de sortie, contraintes de publication) varient. La séparation SPC/REQ permet de capitaliser sur les specs tout en adaptant les REQ par contexte.

### 7. Application aux trois nouveaux livrables de TKT-003

**SPC - Spécification**

La définition dans le ticket est conforme aux principes : stable, préfixe SPC, dans `doc/specs/`, agnostique au stack. La structure recommandée (Section 4 ci-dessus) peut directement alimenter le template du skill `skl-deliverable-spec-writer`.

Point d'attention : "agnostique au stack" doit être un critère de qualité explicite dans le skill (checklist de review). Sans ce garde-fou, la dérive vers les requis est naturelle et rapide.

**REQ - Requis technique**

La définition dans le ticket est également conforme : stable, préfixe REQ, dans `doc/requirements/`, inclut les détails d'implémentation. Le skill `skl-deliverable-requirement-writer` devrait inclure le processus de traçabilité (liens vers la spec de référence) et les critères de vérification.

La mention "use cases prioritaires" est précieuse : elle ancre le REQ dans la réalité des usages, évitant les requis abstraits ou orphelins.

**SKILL - Playbook de livrable**

Ce livrable est un meta-livrable : un skill qui produit des skills. La difficulté spécifique est la récursivité : pour écrire un bon skill, il faut comprendre ce qu'est un bon skill (FND-001). La fondation FND-001 est donc un prérequis direct pour le skill `skl-deliverable-skill-writer`.

Le template d'un skill (frontmatter + sections standardisées) est lui-même une forme de spécification : il définit le "quoi" d'un skill bien formé, indépendamment du domaine que le skill couvre.

## Synthèse

La séparation entre spécification (le quoi, agnostique au stack) et requis technique (le comment, contexte-spécifique) est le principe central de cette fondation. Elle découle directement du principe de séparation des préoccupations (Dijkstra) et est formalisée par ISO/IEC/IEEE 29148.

Les caractéristiques de qualité documentaire (complétude, exactitude, non-ambiguïté, traçabilité, vérifiabilité) s'appliquent aussi bien aux specs qu'aux requis. Elles constituent les critères naturels des sections "Critères de qualité" dans les skills SPC et REQ.

Le troisième livrable (SKILL) ferme la boucle : les skills sont le vecteur d'encodage de toute cette méthodologie dans le comportement de l'agent IA. Un skill de rédaction de spec incarne cette fondation théorique en instructions opérationnelles.

## Limites

- L'ISO/IEC/IEEE 29148:2018 est la version en vigueur au moment de la rédaction ; une révision pourrait modifier certains attributs.
- Les modèles de qualité (SQuaRE) sont conçus pour les systèmes logiciels ; leur transfert aux documents est une adaptation, pas une application directe.
- La distinction fonctionnel/non-fonctionnel pour les requis est critiquée dans la littérature récente (Glinz, 2007 : "On Non-Functional Requirements") ; elle reste opérationnellement utile.
- La pratique terrain Noumanity peut révéler des contraintes non couvertes par ces standards.

## Sources

1. Dijkstra, E.W. (1974). "On the role of scientific thought." EWD447. - Principe de séparation des préoccupations.
2. ISO/IEC/IEEE 29148:2018. "Systems and Software Engineering - Life Cycle Processes - Requirements Engineering." - Attributs des exigences, structure SRS.
3. ISO/IEC 25010:2011. "Systems and Software Engineering - Systems and Software Quality Requirements and Evaluation (SQuaRE)." - Caractéristiques de qualité.
4. ISO/IEC/IEEE 15288:2023. "Systems and Software Engineering - System Life Cycle Processes." - Traçabilité, processus d'ingénierie.
5. IEEE Std 830-1998 (obsolète, remplacé par 29148). "Recommended Practice for Software Requirements Specifications." - Structure SRS historique.
6. Glinz, M. (2007). "On Non-Functional Requirements." 15th IEEE International Requirements Engineering Conference. - Discussion critique de la distinction fonctionnel/non-fonctionnel.
7. FND-001 (ce repo). "Le système de skills Claude Code (Anthropic)." - Fondation sur les skills, prérequis pour SKILL livrable.
8. Fagan, M. (1976). "Design and code inspections to reduce errors in program development." IBM Systems Journal. - Inspection formelle.
9. Ticket TKT-003 (ce repo). "aide à conception de livrables." - Spécification des livrables SPC, REQ, SKILL.
10. INTENTION.md (ce repo). "Raison d'être de ticket-driven-ai." - Contexte de la méthodologie.
