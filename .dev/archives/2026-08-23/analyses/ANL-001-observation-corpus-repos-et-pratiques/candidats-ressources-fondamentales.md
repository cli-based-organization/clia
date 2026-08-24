---
type: analyse
id: ANL-001-02
title: "Matière disponible pour le premier jet des ressources fondamentales"
version: 0.1.0
status: draft
date: 2026-08-09
sujet: "Matière disponible par ressource fondamentale annoncée"
generated:
  by: claude-opus-5
  at: 2026-08-09
---

# Matière disponible pour le premier jet des ressources fondamentales

> Ce que le corpus offre déjà pour chacune des ressources annoncées par le `CLAUDE.md` de `clia`, et ce qui manque. Ce document ne tranche rien et ne produit aucune ressource : il dresse l'état de la matière première.

## Comment lire ce document

Le `CLAUDE.md` de `clia` annonce sept ressources fondamentales et quatre ressources de conception, chacune devant recevoir un ADR, une définition de ressource et un skill. Le corpus contient, à des degrés très inégaux, de la matière pour huit d'entre elles et rien pour trois.

Le niveau de maturité est évalué sur quatre crans.

| Cran | Signification |
|---|---|
| **Mûr** | Une définition de type existe, avec des instances éprouvées et un skill |
| **Amorcé** | Des instances existent, sans définition de type ni skill stabilisé |
| **Latent** | Le concept est actif dans la pratique mais n'a jamais été réifié |
| **Absent** | Rien dans le corpus |

## Tableau d'ensemble

| Ressource annoncée | Maturité | Instances dans le corpus | Meilleure source |
|---|---|---|---|
| Ressource (RES) | Mûr | 14 définitions de types | `micrologic-clients/.dev/ressources/RES-001-ressource.md` |
| Ontologie (ONT) | Amorcé | 1 instance, 1 définition, 1 skill | `micrologic-clients`, plus `nty` et `comm-cli` pour la théorie |
| Objection (NON) | Amorcé | 4 instances, 1 définition, 1 skill | `micrologic-clients/.dev/objections/` |
| Intention (INT) | Latent | Une vingtaine de fichiers, aucun typé | `intentional-doers-governance/INTENTION.md`, plus deux variantes YAML |
| Faits (FCT) | Latent | Zéro instance, un répertoire vide, deux essais de fondation | `micrologic-clients/.dev/fondations/FND-2026-08-08-journalisation-et-preuve-des-faits-prives.md` |
| Contexte (CTX) | Latent | Zéro instance, présent comme section de session | Règle des trois ingrédients, `intentional-doers-governance` |
| Concept (CPT) | Absent | Rien | Rien |
| Analyse critique (ANL) | Mûr | 28 instances, 1 définition, 1 skill | `clia` archivé et `micrologic-clients` |
| Recherche de fondation (FND) | Mûr | 52 instances, 1 définition, 1 skill | `clia` archivé, `skl-002-recherche-de-fondation` |
| Principes de conception (PDC) | Amorcé | 3 répertoires, 1 skill | `clia` archivé, plus les quatre principes de `linux-inspect` |
| Méthodologie (MET) | Amorcé | 3 instances, 1 définition, 1 skill | `micrologic-clients/.dev/methodologies/` |

## Ressources fondamentales

### Ressource (RES)

**Ce qui existe.** `RES-001-ressource.md` de `micrologic-clients` est le document le plus abouti du corpus. Il définit la ressource comme un fichier markdown typé et versionné, se prend lui-même pour objet, fixe treize champs de frontmatter obligatoires pour toute définition de type, pose trois classes de cycle de vie (point fixe, vivant, travail), quatre régimes d'édition (humain, ia, hybride, co-édition), et un critère de départage entre définition, ADR et skill. Il est accompagné de treize autres définitions, `RES-002` à `RES-014`, d'un `index.md` qui se déclare source de vérité unique, et d'un `skl-020-ressource`.

Deux couches antérieures existent aussi : `resource-types.yaml` de `clia`, qui est la même modélisation en YAML machine-lisible avec un vocabulaire de relations typées, et l'ADR `0001_modele_de_ressources_relations_et_cycle_de_vie` de `comm-cli`, qui posait déjà le trio ressource, relation, cycle de vie en mai 2026.

**Ce qui manque.** L'identité stable, écartée explicitement par `RES-001` (voir `analyse-critique.md`, D1). La validation mécanique, absente et reconnue comme lacune. La couche relations, déclarée dans `resource-types.yaml` et jamais instanciée. Et la localisation : ce travail vit dans un dépôt de candidature sans remote.

**Questions ouvertes.** Le renoncement à l'identité stable tient-il pour un système multi-dépôts ? Faut-il une couche machine-lisible en plus des définitions markdown, comme `resource-types.yaml`, ou l'une des deux est-elle redondante ? La classification à cinq natures de `comm-cli` (contextuelle, stratégique, tactique, opérationnelle, stylistique) apporte-t-elle quelque chose que les trois cycles de vie n'apportent pas ?

### Contexte (CTX)

**Ce qui existe.** Le contexte est le deuxième des trois ingrédients de la règle fondatrice, énoncée dans `INT-001` de `intentional-doers-governance` et reprise dans tous les `CLAUDE.md` de la lignée B : intention, contexte, spécification du livrable. Le `CLAUDE.md` de `clia` en fait la deuxième étape de l'interprétation de la demande, et demande explicitement de comprendre la situation actuelle, l'historique, les parties prenantes et l'état émotionnel de l'humain.

Le contexte apparaît comme section obligatoire du fichier de session, et les sessions archivées de `clia` montrent qu'il est réellement renseigné : la session du 2026-07-31 explique en trois phrases l'historique d'un an, l'état d'usage minimal actuel et l'objectif de stabilisation.

**Ce qui manque.** Tout, sauf l'usage. Zéro instance typée, aucune définition, aucun skill. Le contexte n'existe que comme rubrique de session, donc il naît et meurt avec la session, alors que le harnais lui demande de porter l'historique et les parties prenantes, qui sont par nature durables.

**Questions ouvertes.** La tension centrale : le contexte est-il une ressource durable ou une rubrique de session ? Si durable, comment se met-il à jour, et par qui ? Si le contexte contient les parties prenantes, recoupe-t-il la ressource Acteur (`ACT`) déjà prévue par `resource-types.yaml` avec un `skl-016-acteur` et un `ADR-011` ? Et où va l'état émotionnel de l'humain, qui est demandé par le harnais et qui n'a aucune place dans une ressource versionnée et partageable ?

### Intention (INT)

**Ce qui existe.** Le concept est le plus ancien du corpus : `noumanity/imagen` porte un `INTENTION.md` dès février 2022. Une vingtaine de dépôts en portent un aujourd'hui. Trois formes distinctes ont été essayées.

La forme en prose libre, une phrase à une page, majoritaire. La forme structurée en sections numérotées, la plus aboutie étant celle de `ticket-driven-ai` avec cinq sections (opportunité, intention profonde, modèle de travail, contenu du dépôt, objectif) et celle de `intentional-doers-governance` qui numérote son intention `INT-001`, seule occurrence d'une intention identifiée comme instance. Et la forme machine-lisible, dans `nou-scripts-ia-support` et `poc-formulaire-offline-first`, avec un `INTENTION.md` en YAML portant `apiVersion: ia.noumanity.com/v1alpha1` et `kind: Intention`.

Le corpus fournit aussi la meilleure preuve pratique de l'utilité du concept : deux dépôts métiers portent comme intention celle du système lui-même, et trois dépôts de consultation partagent une intention désignant le mauvais client. Le fichier d'intention est donc le point où les erreurs d'installation deviennent visibles.

**Ce qui manque.** Une définition de type. Un régime clair : `INTENTION.md` est déclaré en édition humaine exclusive, et cette exclusivité a été violée au moins une fois, avec un log qui le documente. La distinction entre l'intention ultime du dépôt et les intentions locales, que `intentional-doers-governance` énonce dans sa citation d'en-tête, n'a jamais été outillée : les intentions locales vivent dans les plans.

**Questions ouvertes.** L'intention doit-elle rester un fichier fixe à la racine, hors du système de ressources, ou devenir une ressource `INT-<SEQ>` numérotée comme `INT-001` le suggérait ? La piste machine-lisible abandonnée mérite-t-elle d'être reprise, sachant que `clia` a besoin de lire l'intention d'un dépôt pour objecter, ce que le `CLAUDE.md` lui demande explicitement ? Comment un fichier en édition humaine exclusive peut-il être protégé mécaniquement contre une copie erronée ?

### Objection (NON)

**Ce qui existe.** Le mécanisme est le plus éprouvé du corpus après la ressource. Institué par la gouvernance objection-sociocratique de `intentional-doers-governance`, il est réifié dans `micrologic-clients` sous la forme d'une définition `RES-011-objection`, de quatre instances `OBJ-001` à `OBJ-004`, d'un `skl-019-objection`, d'un gabarit `objection.template.md`, et d'un régime d'édition `hybride` avec propriété par bloc, l'initiateur possédant les blocs d'ouverture et l'autre partie les blocs de réponse.

Le `CLAUDE.md` de `micrologic-clients` va plus loin en désignant la ressource Objection comme source de vérité, quelle que soit l'origine de l'objection, le plan n'en portant au plus qu'un résumé.

La pratique est attestée dans les sessions : une tâche entière de la session du 2026-07-31 s'intitule `[traitement des objections] ANL-016` et répond à quatre objections numérotées. Une analyse de `micrologic-clients` est consacrée à la réévaluation des objections ouvertes.

**Ce qui manque.** `clia` ne porte aucune de ces pièces. Le régime hybride avec propriété par bloc est un mécanisme fin, et rien ne le vérifie. Le cycle complet, objection ouverte, réponse, réévaluation, clôture, n'a pas de représentation d'état lisible par la machine.

**Questions ouvertes.** Faut-il un type distinct pour la réponse à objection, ou la propriété par bloc suffit-elle ? Une objection non résolue doit-elle bloquer mécaniquement, comme le `CLAUDE.md` archivé de `clia` le prescrit en interdisant l'exécution tant qu'une objection reste ouverte, ou rester un blocage social ? Le nom du type est-il `NON`, comme l'annonce le `CLAUDE.md` de `clia`, ou `OBJ`, comme l'usage établi de `micrologic-clients` ? Le corpus a déjà payé le prix d'un changement de préfixe.

### Faits (FCT)

**Ce qui existe.** Aucune instance. Un répertoire `.dev/fait`, vide, dans `comm-cli`. Mais deux essais de fondation récents de `micrologic-clients` traitent précisément du sujet : `FND-2026-08-08-journalisation-et-preuve-des-faits-prives` et `FND-2026-08-08-persuasion-preuve-et-auditoires`, accompagnés de deux analyses, `ANL-2026-08-08-collecte-et-stockage-des-faits-dans-les-depots` et `ANL-2026-08-08-capacite-du-modele-a-prouver-le-fit`.

Le travail conceptuel sur les faits est donc le plus récent du corpus, daté de la veille de cette session, et il est né d'un besoin métier concret : prouver l'adéquation d'un candidat à un poste demande des faits, pas des affirmations.

**Ce qui manque.** Tout, sauf la fondation théorique. Ni définition, ni instance, ni skill, ni préfixe arrêté.

**Questions ouvertes.** Un fait est-il une ressource autonome ou un champ de provenance dans les autres ressources, ce que le format OKF adopté par `micrologic-clients` propose déjà avec la famille `sources` et la convention d'acteur `human:<id>` ? Un fait privé, non publiable, est-il de même nature qu'un fait sourcé publiquement ? Le lien entre fait et preuve, qui est le sujet des deux essais, appartient-il au type ou à la méthodologie qui l'emploie ?

### Ontologie (ONT)

**Ce qui existe.** Une définition `RES-008-ontologie`, une instance `ONT-001-ontologie-du-patrimoine`, un `skl-014-ontologie`, tous dans `micrologic-clients`. En amont, deux travaux plus anciens : `nty`, qui fait de l'ontologie un objet de première classe manipulable par CLI avec la notion de `phore` et d'assignation ontologique, et `comm-cli`, qui classe ses neuf ressources selon cinq natures.

Le besoin est par ailleurs démontré négativement par la dérive lexicale mesurée dans le corpus : `livrable` contre `ressource`, `completed` contre `complet`, `améliorations` contre `issues` contre `tickets` contre `needs` contre `features`.

**Ce qui manque.** L'ontologie du système lui-même. La seule instance existante porte sur un domaine métier, le patrimoine d'un candidat. Le lexique du système, qui est le besoin le plus criant, n'a pas d'instance.

**Questions ouvertes.** L'ontologie sert-elle à fixer le lexique, à typer les relations entre ressources, ou les deux ? Si elle type les relations, quel est son rapport avec le vocabulaire de relations de `resource-types.yaml`, qui en énumère neuf, et avec le champ `relations-admissibles` de chaque définition de type ? `nty` avait une ontologie exécutable, validée mécaniquement ; faut-il y revenir ?

### Concept (CPT)

**Ce qui existe.** Rien. Aucune instance, aucun répertoire, aucun skill, aucune mention hors du `CLAUDE.md` de `clia`.

**Ce qu'on peut en dire malgré tout.** Le corpus produit des concepts en abondance et les perd. `topologie de style` de `ptyle`, `phore` de `nty`, `pilier de communication` de `comm-cli`, `distillation` et `extreme-smart` de `ticket-driven-ai`, `réflexivité` de `linux-inspect`, `objection sociocratique` de `intentional-doers-governance`. Aucun de ces concepts n'a de document propre. Ils vivent dans un README, une section de constitution ou un titre d'ADR, et disparaissent avec le dépôt qui les portait. Cinq d'entre eux ne sont plus cités nulle part.

**Questions ouvertes.** C'est la ressource dont la justification est la plus forte et la matière la plus faible. Un concept se distingue-t-il d'une entrée d'ontologie, ou l'ontologie suffit-elle ? Si un concept est un document, quel est son critère de clôture, sachant que le corpus a montré sa propension à produire des documents longs sur des sujets ouverts ? Le risque est identifié dans `analyse-critique.md`, D4 : vingt-sept types signifient quatre-vingt-un documents, et `CPT` est le type le plus susceptible de proliférer.

## Ressources de conception

### Analyse critique (ANL)

Vingt-huit instances dans le corpus, une définition `RES-004-analyse`, un `skl-012-analyse-corpus`, et une distinction déjà tranchée par `ADR-001-type-livrable-analyse` de `clia` : l'analyse porte sur un existant matériel, la fondation porte sur la littérature. Le présent document est une instance de ce type.

Le type est mûr. Une question reste : le cycle de vie déclaré est `point-fixe`, donc immuable, et `RES-001` reconnaît que la règle n'est pas tenue. Le nommage a par ailleurs changé de forme en cours de route, de daté `ANL-<DATE>-<SLUG>` dans `micrologic-clients` à séquencé `ANL-<SEQ>-<SLUG>` dans `clia`, sans que la migration soit faite partout.

### Recherche de fondation (FND)

Cinquante-deux instances, le type le plus employé du corpus après les traces. Une définition `RES-005-fondation`, un `skl-002-recherche-de-fondation`. Les meilleures instances sont substantielles : sur la viabilité du modèle BDFL de Linux, sur la notion de ressource et ses sept invariants, sur la persuasion et les auditoires, sur la communauté de pratique intentionnée.

Le type est mûr, et son défaut est un défaut de calibrage relevé dans `analyse-critique.md`, D6 : c'est un format long, exhaustif et sourcé, et il n'existe rien de plus léger. Le corpus a besoin de conserver des notes de deux lignes, et le seul outil disponible en demande dix pages.

### Principes de conception (PDC)

Trois répertoires `principes` dans le corpus, un `skl-014-principe-de-conception`, et une décision forte prise dans le `CLAUDE.md` archivé de `clia` : le non-respect d'un principe de conception est un bogue, avec renvoi à `ADR-003` et au type `BUG`.

La meilleure matière n'est pourtant pas typée : les quatre principes directeurs de `linux-inspect`, universalité, adaptabilité, non-intrusivité, réflexivité, sont plus opérationnels que la plupart des `PDC` produits ensuite, et ils n'ont jamais été promus. Le principe zéro trace dans le projet de `noumanity/devops-cli` a même été contredit sans être révoqué.

Question ouverte : si la violation d'un principe est un bogue, il faut un moyen de la détecter, et le corpus n'a aucune validation mécanique.

### Méthodologie (MET)

Trois instances, `MET-001-entrevue-de-cv`, `MET-002-analyse-de-fit`, `MET-003-entrevue-de-journalisation`, toutes dans `micrologic-clients`, avec une définition `RES-012-methodologie` et un `skl-018-methodologie`.

Le type est amorcé et son intérêt est net : il capture un mode opératoire métier réutilisable, distinct du skill qui encadre la production d'un livrable. Les trois instances existantes portent sur la conduite d'entrevues et l'analyse d'adéquation, c'est-à-dire du savoir-faire, pas de la forme documentaire.

Question ouverte : la frontière entre méthodologie et skill. Les deux décrivent un comment. Le critère de départage de `RES-001` distingue la définition, l'ADR et le skill, mais pas le skill et la méthodologie.

## Types présents dans le corpus et absents de la liste annoncée

Le `CLAUDE.md` de `clia` énumère vingt-sept types. Le corpus en contient plusieurs autres, éprouvés, que la liste n'inclut pas ou classe ailleurs.

| Type | Instances | Remarque |
|---|---|---|
| Publication (`PUB`) | 2, définition `RES-014` | Sans skill. Or le seul dépôt de savoir qui fonctionne, `jvtrudel/ecrits`, fonctionne parce qu'il publie. Le type le plus sous-estimé du corpus |
| Patrimoine (`PTM`) | 0, définition `RES-009` | Quatre objections ouvertes, jamais éprouvé. Concept métier, potentiellement généralisable à la mobilisation du savoir |
| Entrevue (`ENT`) | 0, définition `RES-010` | Régime hybride, jamais éprouvé. Le seul type conçu pour produire de la matière première par dialogue |
| Acteur (`ACT`) | 0, prévu par `resource-types.yaml` avec `ADR-011` | Recoupe la question des parties prenantes du Contexte |
| Cas d'usage (`USE`) | 0, prévu par `resource-types.yaml` avec `ADR-012` | Trois relations typées le concernent déjà : `utilise`, `satisfait`, `realise` |
| Issue ou ticket | 172 tâches de ticket, 20 issues | Le type le plus instancié du corpus, et le seul que `clia` a explicitement retiré. Voir `analyse-critique.md`, D9 |

## Recommandations de portée pour le premier jet

Ces recommandations ne décident rien ; elles proposent un ordre de traitement fondé sur la maturité observée.

**Rapatrier avant de créer.** `RES-001` et les treize définitions de `micrologic-clients` existent et sont de meilleure qualité que ce qu'une rédaction à neuf produirait. Le travail le plus rentable de cette session est un rapatriement critique, non une création. Le risque de perte est par ailleurs immédiat : dépôt sans remote, treize fichiers non commités.

**Traiter les trois latents ensemble.** Contexte, Intention et Faits posent la même question sous trois formes : quelle part de ce qui entoure le travail est durable et versionnée, et quelle part est éphémère. Les définir séparément produira trois réponses incohérentes.

**Ne pas définir Concept en premier.** C'est le type sans matière et le plus susceptible de proliférer. Il gagnerait à être défini après l'Ontologie, dont il est peut-être un cas particulier.

**Reprendre la question des issues avant d'ajouter des types.** C'est la seule lacune fonctionnelle qui bloque le travail réel, et le corpus contient trois réponses déjà éprouvées et jamais comparées.

**Décider du coût avant de décider des types.** Vingt-sept types multipliés par trois documents font quatre-vingt-un livrables de méthode. Le corpus montre que le rapport entre outillage et travail accompli se dégrade. Une décision explicite sur ce que coûte un type, et sur le seuil au-delà duquel il ne se justifie pas, conditionne tout le reste.

## Relations

- `fait-partie-de` [ANL-001](index.md)
