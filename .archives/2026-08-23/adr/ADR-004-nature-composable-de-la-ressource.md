---
type: adr
id: ADR-004
title: "Nature composable et atomique de la ressource"
version: 0.1.0
status: draft
maturity: conception
adoption: propose
activated: true
domain-status: "propose"
statut-decision: propose
date: 2026-08-10
decideurs: ["human:jvtrudel (décideur)", "claude-opus-5 (rédaction)"]
sources:
  - "workspace/session.md, tâche 9 du 2026-08-09"
  - ADR-001
  - RES-001
  - NON-012
  - ANL-003
definition-associee: RES-001
skill-associe: skl-001-ressource
---

# ADR-004 - Nature composable et atomique de la ressource

> Acte que la ressource est un ensemble identifiable et auto-cohérent d'informations, indépendamment de son implémentation, et qu'elle est composable : une ressource peut être un assemblage d'autres ressources, chaque composant étant lui-même une ressource. Cette décision abroge la définition par le fichier posée par `ADR-001` D2.

## Statut de cette décision

`propose` quant à sa rédaction, et la décision de fond est prise par l'humain : la tâche 9 de la session du 2026-08-09 l'énonce et demande de l'acter. L'agent en rédige la forme et les conséquences, et signale par objection ce que l'énoncé laisse indéterminé.

## Contexte

### Ce que la définition antérieure disait

`ADR-001` D2 pose qu'une ressource est un fichier markdown portant un frontmatter YAML, et écarte trois alternatives : la base de données, le YAML pur, le schéma exécutable. `RES-001` reprend cette formulation.

Le motif était bon : le markdown se lit sans outil, se versionne par git, et le frontmatter donne une prise machine sans sacrifier la lisibilité.

### Ce que cette définition ne couvrait pas

Trois faits, dont le premier est un défaut mesuré.

**Une ressource de ce dépôt est déjà un répertoire.** `ANL-001-observation-corpus-repos-et-pratiques` compte neuf fichiers, format que la tâche 1 imposait. `NON-012` en mesure la conséquence : `clia res ls` compte neuf analyses là où il y en a deux, parce qu'il compte des fichiers.

**La question s'était déjà posée dans le corpus.** Le dépôt `micrologic-clients` emploie un format de bundle avec un `index.md` en racine, formalisé par son `ADR-001-compatibilite-okf`. `RES-001` de ce dépôt a repris l'essentiel de ce travail sans reprendre cette notion.

**La littérature apporte le cadre manquant.** `FND-002` établit que le modèle FRBR de l'IFLA distingue l'oeuvre de ses réalisations, et que c'est le meilleur outil disponible pour décider ce qu'un identifiant identifie. Un système qui n'identifie que des fichiers ne peut pas désigner une oeuvre composée.

### Ce que la tâche 9 apporte

L'humain élargit la définition et va plus loin que la réponse que `ANL-003` proposait en suggestion S9. Là où S9 proposait le bundle à index, cas particulier, la tâche 9 pose une propriété générale : la ressource est composable, et ses composants sont des ressources.

C'est un renversement de niveau. Le bundle cesse d'être une exception à traiter pour devenir un cas d'une règle.

## Décision, en une phrase

> Une ressource est un **ensemble identifiable et auto-cohérent d'informations**. Son implémentation est indifférente : fichier, répertoire de fichiers, dépôt git, ou toute autre forme. Une ressource est **composable** : elle peut être construite par assemblage d'autres ressources. Chaque composant d'une ressource est un **atome**, c'est-à-dire une ressource de plein droit qui fait partie d'une autre.

## Décisions détaillées

### D1 - La ressource est définie par ses propriétés, non par son support

**Décision.** Une ressource est un ensemble d'informations qui possède deux propriétés : elle est **identifiable**, donc porte une identité au sens de `ADR-001` D3 ; elle est **auto-cohérente**, donc se lit sans supplément.

Le support est indifférent. Un fichier, un répertoire, un dépôt git, une base de données, ou une forme non encore employée, peuvent tous porter une ressource.

**Motif.** Une définition par le support confond la chose et son rangement. `FND-002` établit que la confusion entre l'oeuvre et la manifestation est la difficulté que la bibliothéconomie a mis un siècle à démêler, et qu'elle reste peu appliquée par les systèmes techniques.

**Ce que la décision abroge.** `ADR-001` D2, en tant qu'il **définit** la ressource par le fichier markdown. Ce qu'il conserve : le markdown reste le format **par défaut**, pour les motifs que D2 énonçait et qui restent valables. La différence est que ce n'est plus une définition mais un choix de mise en oeuvre, révisable sans toucher à la notion.

**Alternative écartée.** Conserver la définition par le fichier et traiter le répertoire comme une exception, ce qui était la suggestion S9 de `ANL-003`. Écartée parce qu'une exception se multiplie : le corpus contient déjà des dépôts de données, des chaînes de production LaTeX et des collections d'assets qui seraient chacun une exception de plus.

### D2 - La ressource est composable

**Décision.** Une ressource peut être construite par assemblage d'autres ressources. Une telle ressource est dite **composite**.

Un composite porte sa propre identité, distincte de celles de ses composants. Il porte aussi ce qui fait de lui un tout : ce que l'assemblage produit et que les composants séparés ne produisent pas.

**Motif.** C'est ce que le travail fait déjà. `ANL-001` est un composite dont l'`index.md` porte la méthode et la synthèse, tandis que les huit autres fichiers portent chacun un angle. La synthèse n'est dans aucun des huit.

**Alternative écartée.** Interdire la composition et exiger qu'une ressource tienne dans un fichier. Écartée par un fait : une analyse de cent soixante-six dépôts ne tient pas dans un fichier lisible, et le besoin se reproduira.

### D3 - Un composant est un atome, et un atome est une ressource

**Décision.** Chaque composant d'un composite est un **atome**. Un atome est une ressource de plein droit : il est identifiable, auto-cohérent, typé, et il déclare son appartenance à son composite.

Un atome peut lui-même être composite. La composition n'a pas de profondeur imposée.

**Motif.** L'alternative serait de faire des composants des sous-objets non identifiables, ce qui interdirait de les citer. Or la pratique de cette session cite déjà des parties de `ANL-001`, sous la forme `ANL-001, D4` ou en nommant un fichier du bundle. `FND-002` relève que le champ de la citation des données nomme cette pratique la citation profonde, et qu'elle exige une manière d'identifier les parties.

**Conséquence.** La relation d'appartenance doit être déclarée. Le vocabulaire de relations de `RES-001` s'enrichit de deux entrées symétriques : `compose` et `fait-partie-de`.

### D4 - Propriété holographique : un atome est lisible seul

**Décision.** Tout atome est auto-cohérent au même titre que le composite qui le contient. Il se lit sans son composite, et il porte assez de contexte pour être compris seul.

**Interprétation, et elle est signalée comme telle.** Le titre de la tâche 9 emploie le mot « holographique » et son corps ne le définit pas. La lecture retenue est celle de l'analogie optique : dans un hologramme, chaque fragment contient l'information de l'ensemble. Transposé, chaque atome porte de quoi se comprendre, et non seulement un morceau inintelligible du tout.

Cette lecture est cohérente avec la définition que la tâche 9 donne par ailleurs, puisqu'elle emploie « auto-cohérent » pour la ressource, et que D3 fait de l'atome une ressource. Une lecture plus forte serait possible, où chaque atome porterait l'information du tout, ce qui imposerait une redondance dont l'intérêt n'est pas établi. `NON-016` porte la question.

**Ce que la propriété exige en pratique.** Un atome porte son propre frontmatter, son propre titre, et une phrase de résumé qui tient seule. Un fichier qui ne se comprend qu'en ayant lu l'index de son composite n'est pas un atome : c'est une section mal découpée.

### D5 - L'identité d'un composite et celle de ses atomes

**Décision.** Un composite et ses atomes portent des identités distinctes. L'identité de l'atome n'est pas dérivée de celle du composite par concaténation.

Un atome cite son composite par la relation `fait-partie-de`. Un composite peut citer ses atomes par `compose`, sans y être obligé : la relation inverse suffit à reconstituer l'ensemble.

**Motif.** `FND-002` QR7 établit qu'encoder une relation dans l'identifiant produit des identifiants qui s'allongent, alors que la déclarer à côté la rend interrogeable. La règle est la même pour l'appartenance que pour la filiation.

**Conséquence pour l'implémentation.** L'entrée d'un composite est conventionnellement nommée `index`, ce qui reprend le format éprouvé dans `micrologic-clients`. Cette convention porte sur le nom du fichier d'entrée, non sur l'identité, qui reste celle du composite.

### D6 - Ce que l'on compte

**Décision.** Le décompte des instances d'un type compte les **ressources**, non les fichiers. Un composite compte pour une, quel que soit le nombre de ses atomes. Les atomes comptent dans le décompte de leur propre type.

**Motif.** C'est la réponse à la question Q4 de `NON-012`, et elle était indécidable avant cette décision : `clia` comptait des fichiers parce que le modèle disait qu'une ressource était un fichier.

**Conséquence pour l'outil.** `clia res ls` doit distinguer un composite de ses atomes. Le moyen le moins coûteux est de reconnaître l'entrée conventionnelle d'un composite et de ne pas descendre dans ses atomes pour le décompte du type du composite. Cette implémentation reste à faire et relève de la session d'outillage.

### D7 - Ce que la décision ne change pas

**Décision.** Trois choses restent inchangées, et il importe de le dire pour que la portée de cet ADR soit bornée.

Le markdown reste le format par défaut d'une ressource textuelle, avec frontmatter YAML.

L'identité reste le champ `id`, de la forme `<PREFIXE>-<SLUG>`, au sens de `ADR-001` D3.

Les trois cycles de vie et les quatre régimes d'édition restent ceux de `ADR-001` D4 et D5. Un composite et ses atomes peuvent porter des cycles de vie distincts, ce qui est nouveau et non contradictoire.

## Conséquences

### Ce que la décision apporte

Le bundle cesse d'être une exception. `NON-012` Q1 reçoit une réponse par le haut : une ressource peut être un répertoire parce qu'une ressource n'est pas définie par son support.

La citation d'une partie devient légitime. Les atomes sont des ressources, donc citables, ce que la pratique faisait déjà sans droit.

Le modèle cesse de dépendre du markdown. C'est la condition pour que la question de la portée, posée par `NON-006` Q1 et Q2 sur les assets et les livrables produits mécaniquement, puisse être tranchée sans changer la définition de la ressource.

### Ce que la décision coûte

Une révision de `RES-001`, dont la définition centrale change. La version passe en 0.3.0, ce qui est un changement majeur au sens du semver appliqué au sens, non à la syntaxe.

Deux relations de plus dans le vocabulaire, `compose` et `fait-partie-de`, alors que `NON-004` Q2 relève déjà que ce vocabulaire vit dans `RES-001` faute d'ontologie.

Une modification de `clia res ls`, dont le décompte devient faux d'une autre manière tant qu'elle n'est pas faite : il comptait des fichiers en croyant compter des ressources, il comptera des fichiers en sachant que c'est faux.

Un travail de mise en conformité sur `ANL-001` : ses huit atomes doivent déclarer `fait-partie-de`, et son `index.md` devient l'entrée du composite.

### Ce que la décision ne règle pas

La granularité minimale. Rien ne dit à partir de quand un découpage en atomes cesse d'être utile. `NON-016` porte la question.

Le cas des ressources non textuelles. D1 les rend possibles et rien ne les modélise.

La portée de la propriété holographique. L'interprétation retenue en D4 est signalée comme telle.

## Objections ouvertes sur cette décision

| Objection | Effet | Décisions concernées |
|---|---|---|
| [NON-016](../objections/NON-016-composition-et-atomicite.md) | conditionnel | D3, D4, D6 |
| [NON-012](../objections/NON-012-granularite-de-la-ressource.md) | conditionnel | D1, D6. Partiellement répondue par cet ADR |
| [NON-004](../objections/NON-004-frontiere-savoir.md) | conditionnel | D3, par le vocabulaire de relations |
| [NON-006](../objections/NON-006-portee-du-systeme.md) | conditionnel | D1, sur les ressources non textuelles |

## Relations

- `remplace` [ADR-001](ADR-001-adoption-de-la-notion-de-ressource.md), quant à sa décision D2
- `specifie` [RES-001](../ressources/RES-001-ressource.md)
- `derive-de` [DCN-001](../decisions/DCN-001-nature-composable-de-la-ressource.md)
- `reference` [FND-002](../fondations/FND-002-identifiants-dans-les-systemes-decentralises.md)
- `reference` [ANL-003](../analyses/ANL-003-systeme-d-identifiants-de-clia.md)
