---
type: ressource
id: RES-000
title: "Couche type du dépôt"
version: 0.1.0
status: draft
prefixe: RES
emplacement: ".dev/ressources/index.md"
cycle-de-vie: vivant
edition: co-edition
famille: fondamentale
champs-obligatoires: [type, id, title, version, status]
relations-admissibles: [ressource]
sections: [Statut, Les ressources fondamentales, Objections ouvertes, Relations]
skill: aucun
adr: aucun
statut: actif
---

# Couche type du dépôt

> Table des types de ressources de `clia`. Ce fichier est une **vue** dérivée des définitions, non une définition de type : son frontmatter porte les champs du type `ressource` par commodité, ce que `NON-016` conteste.
>
> Table des types de ressources de `clia`. Chaque type est décrit par sa définition et par elle seule ; cette table est une vue, non une source parallèle.

## Statut

Premier jet du 2026-08-09, produit par la tâche 2 de la session `ressources-et-concepts-de-base`, à partir des constats de `ANL-001-observation-corpus-repos-et-pratiques`.

Les trente définitions sont en `status: draft`.

Le triplet est complet pour un seul type. La tâche 3 de la même session a produit `ADR-001-adoption-de-la-notion-de-ressource`, au statut de décision `propose`, et `skl-001-ressource`, qui porte les règles communes à toute ressource et la procédure de production d'une définition de type. Les six autres définitions déclarent encore `skill: aucun` et `adr: aucun` : c'est délibéré et signalé, non oublié.

Cette progression type par type est elle-même une décision, actée par `ADR-001` D6. Elle répond au défaut D4 de `ANL-001` : exiger le triplet complet à l'introduction de chaque type rendrait l'extensibilité prohibitive.

## Les types de ressources

Trente types, regroupés en six familles par `ADR-005`. L'identité d'un type est son `id`, de la forme `<PREFIX>-<SEQ>` depuis `ADR-007` ; le slug de son nom de fichier porte le **nom canonique** que le champ `type` de ses instances doit prendre.

### Famille fondamentale

| Id | Définition | Type | Nom canonique | Préfixe | Cycle | Édition | Skill | Statut |
|---|---|---|---|---|---|---|---|---|
| `RES-001` | [RES-001-res](RES-001-ressource.md) | Ressource | `ressource` | `RES` | vivant | co-edition | `skl-001-ressource` | actif |
| `RES-002` | [RES-002-con](RES-002-contexte.md) | Contexte | `contexte` | `CTX` | vivant | hybride | `skl-002-ressource-fondamentale` | actif |
| `RES-003` | [RES-003-int](RES-003-intention.md) | Intention | `intention` | `INT` | vivant | humain | `skl-002-ressource-fondamentale` | actif |
| `RES-004` | [RES-004-obj](RES-004-objection.md) | Objection | `objection` | `NON` | travail | hybride | `skl-002-ressource-fondamentale` | actif |
| `RES-005` | [RES-005-fai](RES-005-fait.md) | Faits | `fait` | `FCT` | point-fixe | hybride | `skl-002-ressource-fondamentale` | actif |
| `RES-006` | [RES-006-ont](RES-006-ontologie.md) | Ontologie | `ontologie` | `ONT` | vivant | co-edition | `skl-002-ressource-fondamentale` | actif |
| `RES-007` | [RES-007-con](RES-007-concept.md) | Concept | `concept` | `CPT` | vivant | co-edition | `skl-002-ressource-fondamentale` | actif |

### Famille conception

| Id | Définition | Type | Nom canonique | Préfixe | Cycle | Édition | Skill | Statut |
|---|---|---|---|---|---|---|---|---|
| `RES-010` | [RES-010-ana](RES-010-analyse.md) | Analyse | `analyse` | `ANL` | point-fixe | ia | `skl-003-ressource-de-conception` | actif |
| `RES-011` | [RES-011-fon](RES-011-fondation.md) | Recherche de fondation | `fondation` | `FND` | point-fixe | ia | `skl-003-ressource-de-conception` | actif |
| `RES-012` | [RES-012-pri](RES-012-principe-de-conception.md) | Principe de conception | `principe-de-conception` | `PDC` | vivant | co-edition | `skl-003-ressource-de-conception` | actif |
| `RES-013` | [RES-013-met](RES-013-methodologie.md) | Méthodologie | `methodologie` | `MET` | vivant | ia | `skl-003-ressource-de-conception` | actif |

### Famille controle

| Id | Définition | Type | Nom canonique | Préfixe | Cycle | Édition | Skill | Statut |
|---|---|---|---|---|---|---|---|---|
| `RES-014` | [RES-014-har](RES-014-harnais-operatoire.md) | Harnais opératoire | `harnais-operatoire` | `aucun` | vivant | co-edition | `skl-005-ressource-de-controle` | actif |
| `RES-015` | [RES-015-har](RES-015-harnais-d-architecture.md) | Harnais d'architecture | `harnais-d-architecture` | `aucun` | vivant | co-edition | `skl-005-ressource-de-controle` | actif |
| `RES-016` | [RES-016-har](RES-016-harnais-constitutionnel.md) | Harnais constitutionnel | `harnais-constitutionnel` | `aucun` | vivant | co-edition | `skl-005-ressource-de-controle` | non-installe |
| `RES-017` | [RES-017-har](RES-017-harnais-de-gouvernance.md) | Harnais de gouvernance | `harnais-de-gouvernance` | `aucun` | vivant | co-edition | `skl-005-ressource-de-controle` | non-installe |
| `RES-018` | [RES-018-ski](RES-018-skill.md) | Skill | `skill` | `skl` | vivant | co-edition | `skl-005-ressource-de-controle` | actif |

### Famille contenu

| Id | Définition | Type | Nom canonique | Préfixe | Cycle | Édition | Skill | Statut |
|---|---|---|---|---|---|---|---|---|
| `RES-008` | [RES-008-fra](RES-008-fragment.md) | Fragment | `fragment` | `FRG` | point-fixe | hybride | `skl-004-ressource-de-contenu` | actif |
| `RES-009` | [RES-009-dec](RES-009-decision.md) | Décision | `decision` | `DCN` | vivant | hybride | `skl-004-ressource-de-contenu` | actif |
| `RES-030` | [RES-030-ent](RES-030-entrevue.md) | Entrevue | `entrevue` | `ENT` | travail | hybride | `skl-004-ressource-de-contenu` | actif |

### Famille preparation

| Id | Définition | Type | Nom canonique | Préfixe | Cycle | Édition | Skill | Statut |
|---|---|---|---|---|---|---|---|---|
| `RES-019` | [RES-019-adr](RES-019-adr.md) | Décision d'architecture | `adr` | `ADR` | vivant | co-edition | `skl-006-ressource-de-preparation` | actif |
| `RES-020` | [RES-020-spe](RES-020-specification.md) | Spécification | `specification` | `SPC` | vivant | co-edition | `skl-006-ressource-de-preparation` | actif |
| `RES-021` | [RES-021-req](RES-021-requis-fonctionnel.md) | Requis fonctionnel | `requis-fonctionnel` | `RQF` | vivant | co-edition | `skl-006-ressource-de-preparation` | actif |
| `RES-022` | [RES-022-req](RES-022-requis-non-fonctionnel.md) | Requis non fonctionnel | `requis-non-fonctionnel` | `RQNF` | vivant | co-edition | `skl-006-ressource-de-preparation` | actif |
| `RES-023` | [RES-023-cas](RES-023-cas-d-usage.md) | Cas d'usage | `cas-d-usage` | `USE` | vivant | co-edition | `skl-006-ressource-de-preparation` | actif |
| `RES-024` | [RES-024-com](RES-024-comportement-attendu.md) | Comportement attendu | `comportement-attendu` | `CMP` | vivant | co-edition | `skl-006-ressource-de-preparation` | actif |
| `RES-025` | [RES-025-pla](RES-025-plan.md) | Plan de travail | `plan` | `PLN` | travail | ia | `skl-006-ressource-de-preparation` | actif |

### Famille implementation

| Id | Définition | Type | Nom canonique | Préfixe | Cycle | Édition | Skill | Statut |
|---|---|---|---|---|---|---|---|---|
| `RES-026` | [RES-026-cod](RES-026-code.md) | Code | `code` | `CDE` | vivant | ia | `skl-007-ressource-d-implementation` | actif |
| `RES-027` | [RES-027-rap](RES-027-rapport-de-recherche.md) | Rapport de recherche | `rapport-de-recherche` | `RPT` | point-fixe | ia | `skl-007-ressource-d-implementation` | actif |
| `RES-028` | [RES-028-art](RES-028-article.md) | Article | `article` | `ART` | point-fixe | ia | `skl-007-ressource-d-implementation` | actif |
| `RES-029` | [RES-029-pre](RES-029-presentation.md) | Présentation | `presentation` | `PRS` | point-fixe | ia | `skl-007-ressource-d-implementation` | actif |

Trente types, trente préfixes distincts, six familles.

Chaque type porte quatre artefacts dérivés de sa définition : un schéma CUE de frontmatter dans `.dev/schemas/`, un gabarit markdown dans `.dev/templates/`, un schéma CUE des données du gabarit, et un skill de famille dans `.dev/skills/`. Les trois premiers sont **générés** depuis la définition et ne doivent pas être édités à la main.
## Ce que ce jet apporte de neuf

Cinq propositions de conception ne sont pas des reprises de l'état de l'art, et chacune est fondée sur une mesure de `ANL-001`.

| Apport | Où | Fondé sur |
|---|---|---|
| L'identification se fait à deux niveaux : un alias interne `<PREFIX>-<SEQ>`, et un identifiant externe non fixé | `RES-001` | D1 : douze numéros de skill sur vingt portent plusieurs noms. Forme arrêtée par `ADR-008` |
| L'intention porte un critère de satisfaction **et** un critère de trahison | `RES-003` | L'objection pour conflit d'intention est aujourd'hui impossible à instruire |
| L'objection déclare son effet : bloquant, conditionnel ou informatif | `RES-004` | La règle « aucune exécution tant qu'une objection est ouverte » rend le travail impossible |
| L'unité de fichier des faits est le recueil par sujet, l'unité de sens le fait atomique | `RES-005` | Zéro instance `FCT` dans le corpus, malgré un besoin théorisé : la granularité était l'obstacle |
| Le concept porte un seuil d'admission à trois conditions | `RES-007` | D4 : le système consacre une part croissante de son énergie à se décrire |

## Ce que ce jet ne produit pas

| Non produit | Raison |
|---|---|
| Les ADR `ADR-002` à `ADR-007` | La tâche 2 demandait les définitions. `ADR-001` a été produit par la tâche 3, au statut `propose` |
| Les skills `skl-002` à `skl-007` | Idem. `skl-001-ressource` a été produit par la tâche 3 et porte les règles communes à tous les types, auxquelles les skills à venir renverront |
| `ONT-001`, l'ontologie du système | Nécessaire et manquante : les définitions emploient des relations que rien ne définit. Voir `NON-004` |
| Toute instance des sept types | Ce jet définit, il n'instancie pas |
| Les répertoires `.dev/contextes/`, `.dev/intentions/`, `.dev/faits/`, `.dev/concepts/`, `.dev/ontologies/` | Non créés tant qu'ils sont vides. Le corpus montre le coût des arborescences peuplées de `.gitkeep` |

## Écarts avec CLAUDE.md à signaler

`CLAUDE.md` annonce une table de vingt-sept types répartis en cinq familles, dont les sept ressources fondamentales traitées ici. Trois écarts doivent être portés à la connaissance de l'humain.

**Le préfixe de l'objection.** `CLAUDE.md` et la session demandent `NON`. L'usage établi ailleurs dans le corpus est `OBJ`, avec quatre instances et une définition dans `micrologic-clients`. Ce jet retient `NON` et signale le coût du double vocabulaire. Voir `NON-001`.

**La désignation par triplet de numéros.** `CLAUDE.md` désigne chaque type par `ADR-XXX, RES-XXX, skl-XXX`. `RES-001` établit que ce mode de désignation n'est pas stable et propose de renvoyer par `id`. La table de `CLAUDE.md` devrait suivre, mais `CLAUDE.md` est un fichier de harnais et ce jet n'y touche pas.

**La source de vérité de la table.** Cette table et celle de `CLAUDE.md` portent la même information. `ANL-001` relève que la duplication non tenue est le mode de défaillance dominant du corpus. Une des deux doit devenir une vue déclarée de l'autre. Voir `NON-002`.

## Objections ouvertes

Les huit premières ont été ouvertes par la tâche 2 sur les définitions elles-mêmes, les deux suivantes par la tâche 4 sur le processus de travail, la onzième par la tâche 5 sur les types que ce dépôt emploie sans les avoir définis, la douzième par la tâche 6 sur ce que l'implémentation du CLI a rendu mesurable, la treizième par l'humain le 2026-08-09, la dernière par la tâche 7 sur la propriété de nommage que le système abandonne. Les tâches 6 et 7 ont aussi complété `NON-001`, `NON-006` et `NON-012` par dix questions nouvelles.

| Objection | Thème |
|---|---|
| [NON-001](../objections/NON-001-identite-et-nommage.md) | Identité, nommage et préfixes |
| [NON-002](../objections/NON-002-cout-du-modele.md) | Coût du modèle et prolifération des types |
| [NON-003](../objections/NON-003-frontiere-contexte-intention-faits.md) | Frontière entre Contexte, Intention et Faits |
| [NON-004](../objections/NON-004-frontiere-savoir.md) | Frontière entre Ontologie, Concept, Fondation et Analyse |
| [NON-005](../objections/NON-005-validation-et-regles-non-tenues.md) | Validation mécanique et règles écrites non tenues |
| [NON-006](../objections/NON-006-portee-du-systeme.md) | Portée du système et multi-dépôts |
| [NON-007](../objections/NON-007-faits-preuve-et-confidentialite.md) | Faits, preuve et confidentialité |
| [NON-008](../objections/NON-008-regime-de-travail.md) | Régime de travail et échelles |
| [NON-009](../objections/NON-009-statut-de-la-session-et-convergence.md) | Statut de la session et critère de convergence |
| [NON-010](../objections/NON-010-roles-des-agents-et-production.md) | Rôles des trois agents et conditions de production |
| [NON-011](../objections/NON-011-types-employes-sans-definition.md) | Types employés sans définition, et nommage non conforme |
| [NON-012](../objections/NON-012-granularite-de-la-ressource.md) | Granularité de la ressource et décompte des instances |
| [NON-013](../objections/NON-013-ce-qu-est-une-ressource.md) | Ce qu'est une ressource. Ouverte par l'humain, à rédiger |
| [NON-014](../objections/NON-014-choix-du-trilemme-de-nommage.md) | Le choix du trilemme de nommage : quelle propriété clia abandonne |
| [NON-015](../objections/NON-015-mecanismes-d-entree.md) | Mécanismes d'entrée de l'humain dans le système |
| [NON-016](../objections/NON-016-composition-et-atomicite.md) | Composition, atomicité et propriété holographique |
| [NON-017](../objections/NON-017-familles-et-processus.md) | Familles fonctionnelles, attribution et processus par famille |
| [NON-018](../objections/NON-018-specification-et-implementation.md) | Frontière entre spécification et implémentation |
| [NON-019](../objections/NON-019-identifiant-par-sequence.md) | Conséquences de l'identifiant par séquence |

## Relations

- `derive-de` [ANL-001](../analyses/ANL-001-observation-corpus-repos-et-pratiques/index.md)
