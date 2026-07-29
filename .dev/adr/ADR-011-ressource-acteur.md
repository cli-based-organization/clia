---
type: adr
version: 0.1.0
title: "Ressource « acteur » (`ACT`)"
status: Proposé
date: 2026-07-29
---

# ADR-011 - Ressource « acteur » (`ACT`)

- **Décideurs** : Jérémy Viau-Trudel (humain), agent IA
- **Sources** : tâche 36 de `.dev/session.md` (exécution de [`PLN-017`](../plans/PLN-017-cas-usage-acteurs-tracabilite.md), segment 1, étape 1.1), résolution de l'objection 5 à la tâche 35, [`ANL-014-cas-usage-et-acteurs-de-clia`](../analyses/ANL-014-cas-usage-et-acteurs-de-clia.md), [`FND-018-cas-usage-besoins-utilisateurs`](../fondations/FND-018-cas-usage-besoins-utilisateurs.md)

## Contexte

La chaîne de conception du dépôt commence à l'exigence (`REQ`). Rien, en amont, ne dit **qui** veut quelque chose du système. [`ANL-014`](../analyses/ANL-014-cas-usage-et-acteurs-de-clia.md#constats) mesure les conséquences de ce manque : aucune exigence ne nomme le bénéficiaire de la capacité qu'elle impose (constat C2) ; la seule description d'acteurs du dépôt est une répartition de responsabilités de gouvernance qui range le système lui-même parmi ses acteurs, et qui ignore l'installateur comme le collaborateur futur (écart D1, qualifié de majeur).

Or un cas d'usage sans acteur nommé dérive mécaniquement vers la description de fonctions ([`FND-018`](../fondations/FND-018-cas-usage-besoins-utilisateurs.md), anti-motif de la décomposition fonctionnelle). Nommer les acteurs est donc un prérequis de la ressource `USE` (voir [`ADR-012`](ADR-012-ressource-cas-d-usage.md)), et non un ornement documentaire.

Trois emplacements possibles ont été considérés par [`ANL-014`](../analyses/ANL-014-cas-usage-et-acteurs-de-clia.md#recommandations-priorisées) : une section d'ADR, une section du harnais `ARCHITECTURE.md`, ou un index de cas d'usage. La décision humaine (tâche 35, objection 5) écarte les trois au profit d'un **type de ressource autonome**.

## Décision (résumé)

> On crée un type de ressource livrable **acteur**, préfixe **`ACT`**, emplacement `.dev/acteurs/ACT-<SEQ>-<SLUG>.md`. Un `ACT` décrit **un rôle**, jamais une personne : sa responsabilité, ses buts, ses intérêts, ses préconditions d'accès et ses modes d'échec caractéristiques. C'est une ressource vivante et versionnée au sens d'[`ADR-004`](ADR-004-ressources-livrables.md), en co-édition, produite sous `skl-016-acteur`. Les acteurs se répartissent en trois catégories (primaire, secondaire, partie prenante hors scène) et deux portées (**méthode**, générique et fourni par le harnais ; **domaine**, propre au dépôt hôte). Le système décrit n'est jamais un acteur de lui-même.

## Décisions détaillées

### Nature : un rôle, pas une personne

- **Décision** : un `ACT` décrit un **rôle** défini par ce qu'il veut obtenir du système et ce dont il répond. Une même personne physique peut tenir plusieurs rôles simultanément, et un rôle peut être tenu successivement par des personnes différentes. Le document ne nomme donc jamais d'individu.
- **Justification** : le dépôt en fournit le cas d'école. [`ANL-014`](../analyses/ANL-014-cas-usage-et-acteurs-de-clia.md#typologie-des-utilisateurs-et-des-parties-prenantes) relève que l'opérateur, l'installateur et le mainteneur sont aujourd'hui la même personne, et que les distinguer reste nécessaire parce que leurs buts, leurs préconditions et leurs modes d'échec diffèrent, et parce que la finalité déclarée du système (être installable dans d'autres dépôts) implique qu'ils se sépareront.
- *Alternative écartée* : décrire des personas (profils incarnés avec traits et contexte). Rejeté : le persona sert la conception d'interfaces grand public et introduit de l'information inventée ; le rôle suffit ici et reste vérifiable.

### Pourquoi un type de ressource autonome

- **Décision** : l'acteur est une **ressource livrable adressable et versionnée**, pas une section d'un autre document.
- **Justification** : un acteur est cité par plusieurs types (`USE`, `REQ`, `PLN`) et par plusieurs instances de chacun. Lui donner un identifiant stable et un fichier unique satisfait la source de vérité unique ([`PDC-006`](../principes/PDC-006-source-de-verite-documentaire-unique.md)) et le versionnage atomique ([`PDC-009`](../principes/PDC-009-tracabilite-et-versionnage-atomique.md)) : préciser un rôle incrémente ce rôle, et rien d'autre.
- *Alternatives écartées* :
  - **catalogue dans un ADR** : un ADR acte une décision à une date ; il n'est pas destiné à être révisé au fil de l'évolution d'un rôle. Le catalogue y serait figé dans une décision plutôt que vivant.
  - **catalogue dans `ARCHITECTURE.md`** : le harnais donne une carte de haut niveau et n'est pas versionné par rôle ; y loger le catalogue produirait un fichier qui bouge à chaque précision d'un acteur. Cette option est de plus explicitement écartée par la décision humaine.
  - **index dans un `USE-000`** : ferait dépendre l'existence des acteurs du type `USE`, alors que l'acteur est cité aussi par les exigences et les plans.

### Catégories

- **Décision** : trois catégories, reprises de la [typologie d'`ANL-014`](../analyses/ANL-014-cas-usage-et-acteurs-de-clia.md#typologie-des-utilisateurs-et-des-parties-prenantes) et conformes à [`FND-018`](../fondations/FND-018-cas-usage-besoins-utilisateurs.md) :
  - **primaire** : le rôle dont le but déclenche un `USE` et qui en attend le résultat ;
  - **secondaire** : le rôle ou le service sollicité par le système pendant le déroulé, sans but propre ;
  - **partie prenante hors scène** : le rôle qui a un intérêt au résultat sans participer au déroulé.
- **Règle** : seul un acteur **primaire** peut être l'acteur principal d'un `USE`.

### Portée : méthode et domaine

- **Décision** : chaque `ACT` déclare sa portée, **méthode** ou **domaine**.
  - **méthode** : rôle du système d'augmentation lui-même (celui qui opère le dépôt, celui qui l'équipe, celui qui le fait évoluer, l'agent). Générique, transposable à tout dépôt équipé, fourni par le harnais.
  - **domaine** : rôle propre au métier du dépôt hôte. Jamais fourni par le harnais ; ajouté par le dépôt qui l'accueille.
- **Justification** : sans cette règle, un dépôt hôte mêlerait ses rôles métier aux rôles de méthode dans le même répertoire, et le harnais cesserait d'être transposable. C'est le risque déjà consigné par [`BUG-003`](../bugs/BUG-003-frontiere-methode-domaine-sous-tension.md) et exigé par [`ADR-005`](ADR-005-fonction-scope-harnais.md) et [`PDC-003`](../principes/PDC-003-separation-methode-domaine-genericite-harnais.md).
- **Conséquence opératoire** : une mise à niveau du système d'augmentation peut remplacer les `ACT` de portée méthode ; elle ne touche jamais ceux de portée domaine.

### Le système n'est pas un acteur

- **Décision** : le système décrit (ici l'outil `clia` et le harnais qu'il matérialise) **n'est pas** un acteur. Il est la boîte noire que les acteurs sollicitent.
- **Justification** : corrige la confusion relevée au constat [C2](../analyses/ANL-014-cas-usage-et-acteurs-de-clia.md#constats). Un système rangé parmi ses propres acteurs rend indécidable la frontière de ce qui est décrit.
- **Portée de la décision** : cette règle vaut pour le type `ACT`. La réconciliation du harnais `ARCHITECTURE.md`, qui porte encore la confusion, est **hors portée** de [`PLN-017`](../plans/PLN-017-cas-usage-acteurs-tracabilite.md) par décision humaine (voir Conséquences).

### Nomenclature, cycle de vie, versionnage, droits d'édition

- **Décision** : `.dev/acteurs/ACT-<SEQ>-<SLUG>.md`, séquence globale incrémentale, conforme au modèle unifié d'[`ADR-004`](ADR-004-ressources-livrables.md). Ressource **vivante**, versionnée en semver dans son frontmatter ; pas de manifeste. Statuts : `proposé`, `accepté`, `déprécié`, `remplacé par ACT-XXX`.
- **Droits d'édition** : **co-édition** (l'agent propose, l'humain amende via `.dev/session.md`), comme les autres documents de conception de [`.dev/resource-types.yaml`](../resource-types.yaml).

### Structure d'un `ACT`

- **Décision** : un `ACT` bien formé comporte :

```markdown
---
type: acteur
version: <X.Y.Z>
title: "<Nom du rôle>"
status: <proposé|accepté|déprécié|remplacé par ACT-XXX>
date: <AAAA-MM-JJ>
categorie: <primaire|secondaire|partie-prenante>
portee: <methode|domaine>
---

# ACT-<SEQ> - <Nom du rôle>

## Définition
<Le rôle en une ou deux phrases : ce qu'il est, ce qu'il n'est pas.>

## Responsabilité
<Ce dont ce rôle répond dans le système.>

## Buts poursuivis
<Ce que le rôle cherche à obtenir, en verbes à l'infinitif.>

## Intérêts
<Ce à quoi il tient dans le résultat, y compris quand il ne participe pas au déroulé.>

## Préconditions d'accès
<Ce qui doit être vrai pour que quelqu'un puisse tenir ce rôle.>

## Modes d'échec caractéristiques
<Ce qui va typiquement mal pour ce rôle, et qui doit être couvert par les flux d'échec des USE.>

## Ce que ce rôle ne fait pas
<Frontière avec les rôles voisins, pour prévenir le recouvrement.>

## Relations
<Liens markdown vers les USE que ce rôle utilise, et vers les rôles voisins.>
```

- **Justification du champ « ce que ce rôle ne fait pas »** : les rôles de ce système se recouvrent naturellement (même personne physique). La frontière explicite est le seul moyen de garder les rôles distincts à l'usage.

### Relations

- **Décision** : la relation **`utilise`** est ajoutée au vocabulaire de [`.dev/resource-types.yaml`](../resource-types.yaml) : un `ACT` **utilise** un `USE` pour atteindre un but. C'est la transcription littérale du premier énoncé demandé à la tâche 34 (objection C).
- **Forme provisoire** (résolution de l'objection 2 à la tâche 35) : les relations s'écrivent en **liens markdown dans une section `## Relations`**, pas en champs de frontmatter typés. Seuls `categorie` et `portee` sont en frontmatter, parce qu'ils classent la ressource plutôt qu'ils ne la relient. L'instanciation d'une couche de relations lisible par un programme reste une dette nommée par [`PLN-017`](../plans/PLN-017-cas-usage-acteurs-tracabilite.md).

### Skill de production

- **Décision** : la production d'un `ACT` est encadrée par **`skl-016-acteur`**, produit au segment 2 de [`PLN-017`](../plans/PLN-017-cas-usage-acteurs-tracabilite.md).

## Conséquences

**Positives**

- Le maillon amont de la chaîne de conception gagne son sujet : une exigence peut désormais nommer le rôle qu'elle sert.
- Les rôles deviennent adressables, versionnables et citables, au lieu d'être implicites et dispersés.
- La séparation méthode / domaine devient une propriété déclarée de chaque acteur, donc vérifiable, plutôt qu'une intention.

**Négatives / risques**

- Un type de ressource de plus à maintenir, et un répertoire de plus.
- **Duplication temporaire assumée** : `ARCHITECTURE.md` conserve une section « Acteurs et rôles » qui coexistera avec le catalogue `ACT`, avec la confusion du système rangé parmi ses acteurs. Sa réconciliation est hors portée de [`PLN-017`](../plans/PLN-017-cas-usage-acteurs-tracabilite.md) par décision humaine (tâche 35, objection 6). C'est un écart connu à [`PDC-006`](../principes/PDC-006-source-de-verite-documentaire-unique.md), à qualifier ultérieurement.
- Risque de prolifération : autant de fichiers que de nuances de rôle. Le champ « ce que ce rôle ne fait pas » et la règle de l'acteur primaire limitent le découpage, mais demandent de la discipline.
- Risque de rôle orphelin : un `ACT` qu'aucun `USE` n'utilise. Détectable mécaniquement le jour où la couche relations sera instanciée ; invisible d'ici là.

## Migration / porte de sortie

Premier jet. Le catalogue initial des acteurs de portée méthode est produit au segment 3 de [`PLN-017`](../plans/PLN-017-cas-usage-acteurs-tracabilite.md), après le breakpoint 1, à partir de la [typologie d'`ANL-014`](../analyses/ANL-014-cas-usage-et-acteurs-de-clia.md#typologie-des-utilisateurs-et-des-parties-prenantes). Si l'usage montre que la catégorie « partie prenante hors scène » ne porte aucun contenu vérifiable, elle pourra être fusionnée avec les intérêts déclarés dans les `USE` par un ADR ultérieur. Si la coexistence avec `ARCHITECTURE.md` produit des divergences, elle sera qualifiée en bogue et traitée.

## Références

- [`PLN-017-cas-usage-acteurs-tracabilite`](../plans/PLN-017-cas-usage-acteurs-tracabilite.md) (plan d'exécution, segment 1)
- [`ADR-012-ressource-cas-d-usage`](ADR-012-ressource-cas-d-usage.md) (le type qui consomme les acteurs)
- [`ANL-014-cas-usage-et-acteurs-de-clia`](../analyses/ANL-014-cas-usage-et-acteurs-de-clia.md) (constats C2, écart D1, typologie de départ)
- [`FND-018-cas-usage-besoins-utilisateurs`](../fondations/FND-018-cas-usage-besoins-utilisateurs.md) (acteurs, catégories, anti-motifs)
- [`ADR-004-ressources-livrables`](ADR-004-ressources-livrables.md) (modèle unifié, frontmatter, versionnage)
- [`ADR-005-fonction-scope-harnais`](ADR-005-fonction-scope-harnais.md), [`PDC-003-separation-methode-domaine-genericite-harnais`](../principes/PDC-003-separation-methode-domaine-genericite-harnais.md) (généricité)
- [`BUG-003-frontiere-methode-domaine-sous-tension`](../bugs/BUG-003-frontiere-methode-domaine-sous-tension.md) (risque adressé par la portée)
- [`.dev/resource-types.yaml`](../resource-types.yaml) (couche type)
