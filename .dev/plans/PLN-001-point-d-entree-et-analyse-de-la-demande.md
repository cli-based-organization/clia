---
type: plan
id: PLN-001
title: "Réécriture du point d'entrée et écriture du skill d'analyse de la demande"
status: draft
statut-plan: propose
date: 2026-08-09
initiateur: agent
sert: []  # réécriture du harnais et d'un skill : gouvernance, pas produit
porte-sur: [CLAUDE.md, skl-analyse-de-la-demande]
---

# PLN-001 - Réécriture du point d'entrée et écriture du skill d'analyse de la demande

> Plan de deux chantiers demandés par le TODO de la tâche 4 : réécrire `CLAUDE.md` pour qu'il décrive ce qui est en vigueur plutôt qu'un système à venir, et écrire le skill qui encadre l'analyse d'une demande. Ce plan n'est pas exécuté.

## Avertissement sur le type de ce document

Ce document est une instance du type `plan`, préfixe `PLN`, qui **n'a aucune définition dans ce dépôt**. Le préfixe et la structure viennent du corpus, où le type est éprouvé (trente-sept instances, une définition `RES-002-plan` et un `skl-003-plan-de-travail` dans `micrologic-clients`).

La règle A5 de `skl-001-ressource` prescrit d'ouvrir une objection plutôt que de produire une instance d'un type non défini. L'objection est ouverte : `NON-010` Q3. Le document est néanmoins produit, parce que la tâche 4 le demande explicitement. Cette conduite est soumise à arbitrage par la même question.

## Statut

`propose`. Aucune exécution. Trois objections bloquantes conditionnent le premier chantier, et elles sont listées en tête de celui-ci.

**Limite de temps.** Non déclarée. `PDC-003` V-S3 l'exige au régime extrême SMART, et les cinq plans du dépôt échouent à ce contrôle. Le défaut porte sur le plan entier, non sur un chantier ; il est constaté ici plutôt que corrigé, faute de base pour estimer une durée.

## Intention

Deux chantiers, qui répondent à deux défauts mesurés distincts.

Le premier vise le défaut D8 de `ANL-001` : le harnais actuel prescrit un système qui n'existe pas. `CLAUDE.md` décrit vingt-sept types de ressources, sept commandes CLI, un mécanisme d'extensions et une journalisation à sept fichiers, dans un dépôt qui contenait quatre fichiers et aucun exécutable au matin du 2026-08-09. Un fichier de harnais qui décrit un état futur ne peut être ni obéi ni contesté utilement.

Le second vise le défaut le plus coûteux du corpus, mesuré au titre de D2 : trois dépôts de consultation portant le même `INTENTION.md` désignant le mauvais client, deux dépôts métiers portant l'intention du système lui-même, dix-huit logs recopiés d'un dépôt à l'autre. Aucun de ces défauts ne vient d'une faute de production ; tous viennent d'une demande mal cadrée. `ADR-002` D3 pose l'analyse de la demande comme obligatoire et n'en décrit pas la procédure.

## Chantier A - Réécriture de CLAUDE.md

### Prérequis bloquants

Ce chantier ne peut pas commencer avant trois réponses, parce qu'elles déterminent ce que le fichier doit dire.

| Question | Objection | Ce qu'elle détermine |
|---|---|---|
| L'identité est-elle le champ `id` ? Que devient un renvoi par numéro déjà écrit ? | `NON-001` Q1, Q5 | La forme des vingt-sept renvois de la table des types |
| La table des types vit-elle dans `CLAUDE.md` ou dans `.dev/ressources/index.md` ? | `NON-002` Q6 | Si la table reste ou devient un renvoi |
| Le point d'entrée est-il `workspace/session.md` ou `.dev/session.md` ? | `NON-009` Q7 | Une ligne, mais la plus lue du fichier |

### Diagnostic du fichier actuel

Sept défauts, tous vérifiables sur la version du 2026-08-09.

| Défaut | Localisation | Gravité |
|---|---|---|
| Le point d'entrée désigné n'est pas celui qu'emploie l'historique du dépôt | Section « Session » | Bloquante : chaque session s'ouvre sur cette ambiguïté |
| Vingt-sept types annoncés, dont vingt-et-un sans aucune instance | Section « Core du système clia » | Le fichier prescrit un système absent |
| Quinze triplets sur vingt-sept portent des marque-places `ADR-0` ou `ADR-00` | Idem | Le lecteur ne peut pas distinguer un renvoi d'un espoir |
| Désignation des types par triplet de numéros | Idem | Invalidée par `ADR-001` D3 |
| Table des types dupliquant `.dev/ressources/index.md` | Idem | Source parallèle, le défaut dominant du corpus |
| Sept commandes `clia` documentées, aucun exécutable dans le dépôt | Section « Commandes cli » | Directive inexécutable |
| Aucun statut par section : rien ne distingue ce qui est en vigueur de ce qui est prévu | Tout le fichier | Cause commune des six défauts précédents |

### Étapes proposées

**A1. Inventorier et classer chaque directive.** Passer le fichier ligne à ligne et affecter à chaque directive l'un de trois états : `en-vigueur` si elle est exécutable aujourd'hui, `prevue` si elle décrit une cible, `abandonnee` si elle décrit un état révolu. Livrable : une table de classement, en annexe du plan ou dans le log.

**A2. Séparer le mode opératoire de la feuille de route.** Ne garder dans `CLAUDE.md` que les directives `en-vigueur`. Les directives `prevue` sortent du harnais : soit vers un document de feuille de route, soit vers les objections qui portent déjà leur question. Le critère est simple : un agent doit pouvoir obéir à chaque ligne du fichier.

**A3. Remplacer les tables dupliquées par des renvois.** La table des types renvoie à `.dev/ressources/index.md`, sous réserve de la réponse à `NON-002` Q6. Même traitement pour toute autre information portée en double.

**A4. Convertir les renvois par numéro en renvois par `id`.** Sous réserve de la réponse à `NON-001` Q1.

**A5. Trancher et corriger le point d'entrée.** Une ligne, sous réserve de `NON-009` Q7. Si `workspace/session.md` est retenu, `.dev/session.md` doit être supprimé ou archivé, faute de quoi l'ambiguïté persiste sur le disque.

**A6. Introduire un statut par section.** Chaque section du harnais porte son état, en réemployant le vocabulaire déjà en usage : `actif`, que `CLAUDE.md` applique déjà aux harnais sans se l'appliquer, ou `draft` et `stable` du frontmatter des ressources. C'est la mesure qui empêche le défaut de revenir.

**A7. Renseigner le frontmatter.** `CLAUDE.md` n'en porte aucun aujourd'hui, alors que la version archivée en portait un avec `type: harnais` et une version. Sans frontmatter, aucun contrôle de `skl-001` ne s'applique au fichier le plus important du dépôt.

**A8. Valider.** Contrôles V1, V4, V5 et V8 de `skl-001-ressource`, adaptés au fait qu'un harnais n'est pas une ressource.

### Point d'arrêt

Après A1 et A2. Le classement des directives et la décision de ce qui sort du harnais sont des choix que l'humain doit voir avant que le fichier soit réécrit.

### Ce que ce chantier ne fait pas

Il ne modifie pas `INTENTION.md`, qui est en édition humaine exclusive, et dont l'affirmation sur la mobilisation du savoir est contestée par `NON-004` Q7.

Il ne crée pas `ARCHITECTURE.md`, réduit aujourd'hui à un titre et à une liste de répertoires. Ce fichier mériterait son propre chantier.

## Chantier B - Skill d'analyse de la demande

### Prérequis

Aucun bloquant. `ADR-002` D3 pose déjà les cinq temps de l'analyse, et le skill les détaille.

Une dépendance faible : le format de journalisation dépend de `NON-002` Q5, qui porte sur le seuil de proportionnalité. Le skill peut être écrit avec un format provisoire.

### Ce que le skill doit couvrir

Les cinq temps que le TODO de la tâche 4 énumère, dans cet ordre.

**B1. Conformité et validité de la demande.** Le skill fournit une liste de contrôles de recevabilité, et dit quoi faire quand un contrôle échoue.

| Contrôle | Cas d'échec observé dans le corpus |
|---|---|
| La demande provient-elle du point d'entrée ? | Une demande formulée uniquement en conversation, dont il ne reste rien |
| Porte-t-elle sur une tâche existante du fichier de session ? | Le refus est prescrit par `CLAUDE.md` et a été appliqué le 2026-08-09 sur une demande vide |
| Est-elle exécutable dans l'état du dépôt ? | Les directives citant des documents absents, cas dominant de cette session |
| Le type de ressource attendu existe-t-il ? | `PLN-001` lui-même, produit sans définition de type |
| Contredit-elle l'intention ultime ? | À traiter par objection, `ADR-002` D6 |

**B2. Interprétation.** Le skill dit ce qu'il faut extraire : intention, contexte, livrables attendus avec leur type, portée exacte, ce qui est explicitement exclu, et les interdictions. Ce dernier point est important : `ANL-001` établit que les demandes de l'humain portent régulièrement des interdictions explicites, du type « ne pas implémenter le plan », et qu'elles sont aussi structurantes que les demandes.

**B3. Rédaction du log.** Le skill fixe le format et le moment. Le moment est avant l'exécution : un log d'interprétation écrit après coup est une justification, pas une interprétation. Le format reste à arbitrer, `NON-002` Q5.

**B4. Rédaction de la demande interprétée.** Le skill fournit un gabarit. La demande interprétée est un document que l'humain peut contredire, donc elle doit être courte, explicite sur ses hypothèses, et séparer ce qui est demandé de ce qui est déduit.

**B5. Validation de l'interprétation.** Le skill dit comment l'écart se traite : confirmation tacite si l'écart est nul, objection si l'écart porte sur la portée ou sur le livrable, question directe si l'ambiguïté est locale et bloque immédiatement.

### Étapes proposées

**B6.** Rédiger le skill selon la structure de `skl-001-ressource` : quand l'invoquer, procédure, gabarit, contrôles, erreurs fréquentes observées.

**B7.** Alimenter la section des erreurs fréquentes avec les cas mesurés par `ANL-001`, chacun rattaché au contrôle qui l'aurait détecté.

**B8.** Éprouver le skill sur les trois demandes de la session du 2026-08-09. C'est le seul jeu d'essai disponible, et il a l'avantage d'être documenté : trois demandes, trois interprétations écrites, trois ambiguïtés signalées.

**B9.** Valider par les contrôles de `skl-001-ressource`, dont le skill est lui-même justiciable.

### Point d'arrêt

Après B8. Si le skill ne rend pas compte des trois demandes réelles de cette session, il est faux, et il vaut mieux le constater avant de l'adopter.

## Livrables attendus

| Livrable | Chantier | Type |
|---|---|---|
| `CLAUDE.md` réécrit | A | Harnais, hors modèle de ressources |
| Table de classement des directives | A1 | Annexe de log |
| `skl-<SEQ>-analyse-de-la-demande/SKILL.md` | B | Skill |
| Gabarit de demande interprétée | B4 | Inclus dans le skill |

## Objections de l'agent sur ce plan

Quatre, dont deux nouvelles et deux qui renvoient à des objections déjà ouvertes.

**Le chantier A est suspendu à trois réponses.** Le commencer avant serait produire un fichier de harnais qu'il faudrait réécrire une deuxième fois. C'est le motif du point d'arrêt après A1 et A2.

**Le chantier B décrit une procédure que l'agent a déjà suivie trois fois sans skill.** Le risque est d'écrire un skill qui décrit ce que l'agent a fait plutôt que ce qu'il devrait faire. L'étape B8 est conçue pour le détecter, en confrontant le skill aux trois demandes réelles, y compris à leurs échecs : la remarque tronquée de la tâche 4 n'a pas été signalée avant la production, mais pendant.

**Ce plan est une instance d'un type sans définition.** `NON-010` Q3.

**Le plan lui-même n'a pas été demandé comme livrable typé.** Le TODO de la tâche 4 dit « faire un plan », sans préciser la forme. Ce document choisit la forme du corpus. Si l'humain attendait un plan dans le log ou dans la conversation, la portée a été élargie sans autorisation.

## Ce que ce plan ne fait pas

Il n'exécute rien. Aucun des deux chantiers n'est engagé, aucun fichier n'est modifié, `CLAUDE.md` est intact.

## Relations

- `derive-de` [ADR-002](../adr/ADR-002-adoption-du-processus-de-travail.md)
- `reference` [ANL-001](../analyses/ANL-001-observation-corpus-repos-et-pratiques/analyse-critique.md)
- `reference` [skl-001-ressource](../skills/skl-001-ressource/SKILL.md)
- `reference` [NON-010](../objections/NON-010-roles-des-agents-et-production.md)
