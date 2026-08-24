---
type: adr
id: ADR-016
title: "Le système est structuré par la ressource, non par la notion de type"
version: 0.1.0
status: draft
maturity: conception
adoption: propose
activated: true
domain-status: "propose"
statut-decision: propose
date: 2026-08-11
decideurs: ["human:jvtrudel (décideur)", "claude-opus-5 (rédaction)"]
sources:
  - "NON-002, réponses Q1 à Q7 du 2026-08-10"
  - ANL-001
  - "workspace/session.md, tâche 21"
definition-associee: RES-001
---

# ADR-016 - Le système est structuré par la ressource, non par la notion de type

> Instruit les sept réponses de l'humain à `NON-002`. Le clivage structurant n'est pas le type mais **ressource ou non-ressource**. Les skills cessent de faire autorité et deviennent dérivables. La source de vérité est le fichier `RES`.

## Statut

`propose`.

L'enregistrement des réponses appartient à l'humain : `CONSTITUTION.md` C1 réserve la création d'une `DCN` à l'humain, et le gabarit `DCN-011` a été produit et laissé à renseigner. Cet `ADR` instruit les conséquences ; il ne les acte pas.

## Contexte

`NON-002`, ouverte le 2026-08-09, contestait la structure de coût du modèle : le triplet définition, décision, processus pour chaque type, vingt-sept types dont vingt-et-un sans instance, et quatorze champs de frontmatter par définition.

Les sept réponses de l'humain, du 2026-08-10, ne défendent pas le modèle contesté. Elles déplacent le problème : « le triplet n'était qu'une tentative », et « la notion de type n'est pas le bon concept ».

## Décision en une phrase

Ce qui structure le système est la distinction entre une ressource et ce qui n'en est pas une ; tout le reste, y compris les skills, en dérive.

## Décisions détaillées

### D1 - Le clivage structurant est ressource ou non-ressource

**Décision.** La notion de type cesse d'être le concept organisateur. Ce qui structure le système est le clivage **`RES` ou non-`RES`**.

**Citation de la réponse Q1.** « La notion de type n'est pas le bon concept. Ce qui est structurant, c'est : ressource (RES) ou non-RES. Tout le système est structuré autour de la manipulation conforme des ressources. »

**Ce qui change.** Un « type » est désormais un **type de ressource**, défini par un fichier `RES`. Le mot type, employé seul, cesse d'être une catégorie du système.

**Ce qui ne change pas.** Les trente définitions existantes restent valides. Elles sont des types de ressource, ce qu'elles étaient déjà en fait.

### D2 - La source de vérité est le fichier RES

**Décision.** Les fichiers `RES` sont la source de vérité des ressources. Aucun autre document ne déclare ce qu'est un type de ressource.

**Citation de la réponse Q6.** « La source de vérité des ressources sont les fichiers RES. Dans le harnais IA, seul un skill d'interprétation des demandes devrait expliquer comment identifier la RES livrable. »

**Conséquence sur `CLAUDE.md`.** Sa table des types cesse d'être une source. Le harnais opératoire ne porte plus que ce qui sert à interpréter une demande et à identifier le livrable.

**Conséquence sur `.dev/ressources/index.md`.** Il devient une vue dérivée, ce qu'il déclare déjà être.

Cette décision règle le mode de défaillance dominant que `ANL-001` mesure : trente-trois `CLAUDE.md` pour dix-huit contenus, trois `INTENTION.md` identiques désignant le mauvais client. Une information portée à deux endroits dérive.

### D3 - Les skills ne font pas autorité et sont dérivables

**Décision.** Un skill est une ressource **générée**. Il ne fait pas autorité et il est entièrement dérivable de `RES`, `ADR`, `SPC` et `RQF`.

**Citation de la réponse Q1.** « Les skills encadrent la manipulation spécialisée des ressources. Si un traitement générique est possible, on peut se contenter d'un skill commun à une catégorie de ressource. En fait, les skills sont des ressources générés ils ne font pas autorité et sont entièrement dérivables de RES, ADR, SPC et REQ. »

**C'est un renversement.** `skl-001` est aujourd'hui un harnais qui commande le comportement de l'agent, et la tâche 17 vient d'y écrire une règle de registre et un contrôle. Sous cette décision, ces règles n'ont pas leur place dans un skill : elles appartiennent à `RES-001` ou à un `ADR`, et le skill les reprend par dérivation.

**Ce que la décision n'a pas encore.** Le générateur. Aucun outil ne dérive un skill de sa définition, et les sept skills du dépôt sont écrits à la main. La décision est donc prise et non appliquée : `NON-025` le porte.

**Conséquence sur le régime d'édition.** `RES-018` passe de `co-edition` à `ia` : un document généré n'est pas co-édité.

### D4 - Un type de ressource se crée sous le besoin

**Décision.** Aucun seuil d'admission n'est fixé pour les types de ressource. Un nouveau type est créé lorsque le besoin s'en fait sentir.

**Citation de la réponse Q2.** « Le type n'est pas le bon concept. C'est un type de ressource. Un nouveau type de ressource est créé lorsque le besoin s'en fait ressentir. »

**Ce qui est écarté.** La proposition de `NON-002` Q2 d'un test d'admission pour les types, sur le modèle de celui que `RES-007` impose aux concepts.

### D5 - La contestation sur le nombre de types est close

**Décision.** Les types de ressource demandés sont produits sans être contestés.

**Citation de la réponse Q3.** « Faire les types de ressource demandé et ne pas contester. clia est un système de gestion de ressource de différent types. Les types vont évoluer... mais il y aura toujours autant de types nécessaire pour y encoder les contenus informationnels dont nous avons besoin de manipuler. »

**Ce que cela règle.** Le grief principal de `NON-002`, la prolifération, est rejeté. L'argument retenu est que le nombre de types suit le nombre de natures de contenu à manipuler, non une préférence de conception.

### D6 - Le triplet est abandonné comme prescription

**Décision.** Le triplet définition, décision, processus n'est plus exigible pour chaque type de ressource.

**Motif.** Il tombe par conséquence de D3 : si le skill est dérivable, il n'est pas un livrable à produire. Et la réponse Q1 le dit directement : « le triplet n'était qu'une tentative ».

**Ce qui subsiste.** La définition `RES` est obligatoire, par D2. L'`ADR` reste le foyer du pourquoi, comme `ADR-015` D4 l'a établi.

### D7 - Le critère de trahison devient facultatif

**Décision.** `RES-003` retire `critere-de-trahison` de ses champs obligatoires. Le champ reste dans le gabarit de génération.

**Citation de la réponse Q7.** « Le critère de trahison est intéressant. à garder dans le template de génération de RES-003. Mais ce n'est pas obligatoire. »

**Motif.** Celui que la question posait elle-même : un critère de trahison renseigné pour la forme est pire que son absence.

### D8 - Le coût de la journalisation est assumé

**Décision.** La journalisation à sept fichiers par requête reste exigible, sans seuil.

**Citation de la réponse Q5.** « La traçabilité et la lisibilité des agents IA est une caractéristique centrale du système. À terme ce coût génère une ressource plus importante que ce qu'elle coute. »

Cette décision est reprise par `CONSTITUTION.md` C5.

## Conséquences

| Document | Effet |
|---|---|
| `RES-003` | `critere-de-trahison` retiré des champs obligatoires, `intention.cue` aligné |
| `RES-018` | Régime d'édition `co-edition` vers `ia`, le skill devient dérivé |
| `NON-002` | Passe à `repondue`, effet `bloquant` vers `informatif` |
| `CLAUDE.md` | Sa table des types cesse d'être une source, par D2 |
| `skl-001` à `skl-007` | Deviennent des documents dérivés, sans générateur qui les dérive |

**Ce que la décision assume.** D3 est prise et non applicable : aucun générateur n'existe. Les sept skills du dépôt continuent de faire autorité en pratique, y compris `skl-001` que la tâche 17 vient d'enrichir.

**Ce que la décision ne dit pas.** Si les logs sont des ressources. La réponse Q1 le pose comme une question ouverte : « est-ce que les logs sont des ressources ? J'aurais tendance à dire oui. Mais je n'en suis pas certain. »

## Objections ouvertes

`NON-025`, ouverte avec cette décision : quatre questions sur ce que D3 laisse indéterminé, dont le générateur qui n'existe pas et le statut des logs.

`NON-024`, bloquante, sur le sort des douze ressources d'autorité rédigées par l'agent.

`NON-005`, bloquante, sur les règles écrites et non tenues. D3 en ajoute une.

## Relations

- `repond-a` [NON-002](../objections/NON-002-cout-du-modele.md)
- `specifie` [RES-001](../ressources/RES-001-ressource.md)
- `derive-de` [ANL-001](../analyses/ANL-001-observation-corpus-repos-et-pratiques/index.md)
- `reference` [ADR-015](ADR-015-registre-directif-et-gabarit-des-definitions.md)
