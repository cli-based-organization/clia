---
type: ressource
id: RES-index
title: "Couche type du dépôt"
version: 0.1.0
status: draft
prefixe: RES
emplacement: ".dev/ressources/index.md"
cycle-de-vie: vivant
edition: co-edition
champs-obligatoires: [type, id, title, version, status]
relations-admissibles: [ressource]
skill: aucun
adr: aucun
statut: actif
---

# Couche type du dépôt

> Table des types de ressources fondamentales de `clia`. Chaque type est décrit par sa définition et par elle seule ; cette table est une vue, non une source parallèle.

## Statut

Premier jet du 2026-08-09, produit par la tâche 2 de la session `ressources-et-concepts-de-base`, à partir des constats de `ANL-001-observation-corpus-repos-et-pratiques`.

Les sept définitions sont en `status: draft`.

Le triplet est complet pour un seul type. La tâche 3 de la même session a produit `ADR-001-adoption-de-la-notion-de-ressource`, au statut de décision `propose`, et `skl-001-ressource`, qui porte les règles communes à toute ressource et la procédure de production d'une définition de type. Les six autres définitions déclarent encore `skill: aucun` et `adr: aucun` : c'est délibéré et signalé, non oublié.

Cette progression type par type est elle-même une décision, actée par `ADR-001` D6. Elle répond au défaut D4 de `ANL-001` : exiger le triplet complet à l'introduction de chaque type rendrait l'extensibilité prohibitive.

## Les sept ressources fondamentales

| Définition | Type | Préfixe | Emplacement | Cycle de vie | Édition | Skill | ADR |
|---|---|---|---|---|---|---|---|
| [RES-001](RES-001-ressource.md) | Ressource | `RES` | `.dev/ressources/` | vivant | co-édition | [skl-001](../skills/skl-001-ressource/SKILL.md) | [ADR-001](../adr/ADR-001-adoption-de-la-notion-de-ressource.md) |
| [RES-002](RES-002-contexte.md) | Contexte | `CTX` | `.dev/contextes/` | vivant | hybride | aucun | aucun |
| [RES-003](RES-003-intention.md) | Intention | `INT` | `INTENTION.md` et `.dev/intentions/` | vivant | humain | aucun | aucun |
| [RES-004](RES-004-objection.md) | Objection | `NON` | `.dev/objections/` | travail | hybride | aucun | aucun |
| [RES-005](RES-005-fait.md) | Faits | `FCT` | `.dev/faits/` | point-fixe | hybride | aucun | aucun |
| [RES-006](RES-006-ontologie.md) | Ontologie | `ONT` | `.dev/ontologies/` | vivant | co-édition | aucun | aucun |
| [RES-007](RES-007-concept.md) | Concept | `CPT` | `.dev/concepts/` | vivant | co-édition | aucun | aucun |

Sept types, sept préfixes distincts.

## Ce que ce jet apporte de neuf

Cinq propositions de conception ne sont pas des reprises de l'état de l'art, et chacune est fondée sur une mesure de `ANL-001`.

| Apport | Où | Fondé sur |
|---|---|---|
| L'identité est le champ `id`, de la forme `<PREFIXE>-<SLUG>`, et non le numéro de séquence | `RES-001` | D1 : douze numéros de skill sur vingt portent plusieurs noms |
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

## Relations

- `derive-de` [ANL-001](../analyses/ANL-001-observation-corpus-repos-et-pratiques/index.md)
