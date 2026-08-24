---
type: adr
id: ADR-007
title: "L'identifiant d'une ressource est relatif au dépôt et porté par sa séquence"
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
  - "workspace/session.md, tâche 13 du 2026-08-09"
  - FRG-001
  - NON-001
  - ADR-001
definition-associee: RES-001
skill-associe: skl-001-ressource
---

# ADR-007 - L'identifiant d'une ressource est relatif au dépôt et porté par sa séquence

> Acte que l'identité d'une ressource est `<PREFIX>-<SEQ>`, relative au dépôt, attribuée à la création et jamais modifiée. Cette décision **renverse** `ADR-001` D3, qui faisait de l'identité le couple préfixe et slug, et abolit le nommage daté.

> **Abrogation partielle du 2026-08-10.** `ADR-008` abroge D1 et D2 : `<PREFIX>-<SEQ>` est l'alias interne et non l'identité, et un alias peut changer à condition de propager. D3, D4 et D5 subsistent. Ce résumé et la section « Décision, en une phrase » décrivent l'état antérieur ; ils sont conservés tels quels, une décision enregistrée ne se réécrivant pas.

## Statut de cette décision

`propose` quant à sa rédaction. La décision de fond est prise par l'humain dans la tâche 13, classée `[bogue]`, dont l'énoncé est direct : à l'interne d'un dépôt `clia`, toutes les ressources doivent être référençables par `<PREFIX>-<SEQ>`, et toute référence à `<PREFIX>-<DATE>` et `<PREFIX>-<SLUG>` doit être éliminée.

C'est la **réponse à la question Q1 de `NON-001`**, ouverte le 2026-08-09, dont l'effet était bloquant. Elle va contre la proposition de l'agent.

## Contexte

### Ce que l'agent avait proposé, et sur quel fondement

`ADR-001` D3 posait que l'identité est le champ `id`, de la forme `<PREFIXE>-<SLUG>`, le numéro n'étant qu'un ordre d'apparition.

Le fondement était une mesure de `ANL-001` : douze numéros de skill sur vingt portent plusieurs noms selon le dépôt, `skl-004` en portant cinq. L'implémentation avait confirmé par un cas d'usage, `clia res show 002` étant ambigu dès que deux types portent un rang 002.

Le raisonnement était : le numéro se renumérote, donc il ne peut pas porter l'identité.

### Ce que l'humain apporte, et qui renverse le raisonnement

Le fragment `FRG-001`, capté le 2026-08-10, contient la prémisse qui manquait :

> À sa création, la ressource informationnelle a une identité qui la définit et permet de retracer son évolution et ses transformations. **Ce qui persiste par-delà des modifications est l'identité.**

Appliqué au cas : le numéro est attribué **à la création** et n'a aucune raison de changer. Le slug, lui, dérive du titre, et un titre se corrige. Ce qui persiste est donc le numéro, non le slug.

La prémisse de l'agent était fausse sur un point de fait : il supposait la renumérotation possible. Elle ne l'est pas si l'on décide qu'elle ne l'est pas.

### Ce que le mot « relatif » ajoute

Le titre de la tâche 13 parle d'identifiants **relatifs**. L'identité de `RES-001` ne vaut que dans un dépôt donné : c'est une propriété assumée, non une limite subie.

Elle est cohérente avec `NON-014`, qui constate que `clia` a abandonné l'unicité globale au profit de la lisibilité et de l'absence d'autorité. Un identifiant relatif est exactement ce que ce choix implique.

## Décision, en une phrase

> L'identité d'une ressource est le champ `id`, de la forme `<PREFIX>-<SEQ>`. Elle est **relative au dépôt**, **attribuée à la création** et **jamais modifiée**. Le slug du nom de fichier porte le libellé, non l'identité. Le nommage daté est aboli : tous les types se nomment `<PREFIX>-<SEQ>-<SLUG>.md`, quel que soit leur cycle de vie.

## Décisions détaillées

### D1 - L'identité est `<PREFIX>-<SEQ>`

> **Abrogé le 2026-08-10 par `ADR-008` D2.** `<PREFIX>-<SEQ>` est l'alias interne d'une ressource, non son identité. La forme et son emploi comme cible de tout renvoi interne sont conservés ; seul son statut change. Motif dans `DCN-008`, réponses Q1 et Q4.

**Décision.** Le champ `id` prend la forme `<PREFIX>-<SEQ>`, où `<SEQ>` est une séquence à trois chiffres. Un atome de composite prend la forme `<PREFIX>-<SEQ>-<NN>`.

**Motif.** Reprise de `FRG-001` : ce qui persiste est l'identité. Le numéro est attribué une fois, le slug suit un titre révisable.

**Ce que la décision abroge.** `ADR-001` D3, entièrement.

### D2 - Renuméroter est interdit

> **Abrogé le 2026-08-10 par `ADR-008` D3.** Renuméroter est permis, à condition que le changement propage la mise à jour à toutes les références internes. Cette décision était un ajout de l'agent, et son motif tombe avec D1. La conséquence sur les numéros libérés tombe avec elle : voir `NON-023` Q2.

**Décision.** Une ressource ne change jamais de numéro. Une renumérotation est un changement d'identité, traité par `remplace` et `est-remplacee-par`, jamais par une réécriture silencieuse.

**Motif.** C'est ce qui rend D1 possible. La prémisse de l'agent, selon laquelle le numéro se renumérote, n'était pas un fait mais une permission tacite. La retirer suffit à faire du numéro une identité.

**Conséquence.** Un numéro libéré par une suppression n'est jamais réattribué. La séquence a des trous, et c'est correct.

### D3 - Le slug porte le libellé, et pour une définition le nom canonique du type

**Décision.** Le slug du nom de fichier porte un libellé lisible. Le corriger ne casse aucun renvoi, puisque les renvois ciblent l'`id`.

Pour une définition de type, le slug porte en outre le **nom canonique du type**, c'est-à-dire la valeur que le champ `type` de ses instances doit prendre. `RES-019-adr.md` définit le type `adr`.

**Motif.** L'`id` étant devenu numérique, il ne peut plus porter le nom canonique. Le nom de fichier est le seul endroit qui le porte, et il l'a toujours porté.

**Conséquence pour l'outil.** `clia` dérive désormais le nom canonique du nom de fichier et non de l'`id`. C'est un renversement du mécanisme mis en place à la tâche 8, et il est plus simple : il ne dépend pas du frontmatter.

### D4 - Le nommage daté est aboli

**Décision.** Tous les types se nomment `<PREFIX>-<SEQ>-<SLUG>.md`, quel que soit leur cycle de vie. La forme `<PREFIX>-<DATE>-<SLUG>` disparaît.

**Motif.** Trois raisons.

Le nommage daté empêchait la référence par `<PREFIX>-<SEQ>`, ce que la tâche 13 exige pour **toutes** les ressources.

Il n'a jamais été appliqué : les cinq fondations et analyses de ce dépôt étaient déjà nommées par séquence, non-conformité que `NON-011` Q2 portait depuis le 2026-08-09. La décision aligne la règle sur la pratique plutôt que l'inverse.

Il faisait dépendre le nommage du cycle de vie, ce qui mêlait deux questions distinctes. Le cycle de vie ne commande plus que le versionnage.

**Conséquence.** Un seul fichier était nommé par date, `FRG-2026-08-10-conception-des-ressources-et-de-sont-identite.md`, créé par l'humain avec `clia res new`. Il devient `FRG-001-conception-des-ressources-et-de-son-identite.md`.

### D5 - L'identifiant est relatif au dépôt

**Décision.** `RES-001` ne désigne la même ressource que dans un dépôt donné. Aucune unicité inter-dépôts n'est prétendue.

**Motif.** C'est la conséquence assumée du choix que `NON-014` constate : lisible et sans autorité, donc pas unique globalement. Le trilemme de Zooko, établi par `FND-002`, ne laisse pas d'autre issue à cette échelle.

**Ce que la décision ne règle pas.** La portée inter-dépôts. `NON-001` Q2 et Q10 restent ouvertes, et la suggestion S3 de `ANL-003`, qui proposait une identité étendue `<origine>:<PREFIX>-<SEQ>`, reste applicable : elle étend le noyau sans le remplacer.

## Conséquences

### Ce que la décision apporte

L'identité devient plus courte, plus dictable, plus reconnaissable à l'oeil. C'est un gain sur les deux axes où `ANL-003` établit que `clia` fait mieux que les systèmes documentés : la lisibilité et l'ergonomie.

Le nommage cesse de dépendre du cycle de vie. Une règle de moins, et l'alignement d'une règle sur une pratique déjà en vigueur.

Le renvoi devient uniforme. Une seule forme à retenir, employée dans le texte, dans le frontmatter et sur la ligne de commande.

### Ce que la décision coûte

Une migration, faite : quatre-vingt-trois identifiants convertis dans quatre-vingt-trois fichiers, un fichier renommé, le schéma d'identité modifié, le mécanisme de dérivation du nom canonique inversé dans le CLI.

L'interdiction de renuméroter, qui est une contrainte permanente. Rien ne la vérifie aujourd'hui.

Une ambiguïté résiduelle, connue et non réglée : `clia res show 002` reste ambigu si deux types portent un rang 002. La décision ne la supprime pas, elle la déclare acceptable, puisqu'un identifiant complet porte toujours son préfixe.

### Ce que la décision ne règle pas

La portée inter-dépôts, reportée par D5.

La vérification de l'interdiction de renuméroter.

Le sort du champ `id` lui-même : il devient déductible du nom de fichier, donc redondant. `NON-019` demande s'il doit subsister.

## Objections ouvertes sur cette décision

| Objection | Effet | Décisions concernées |
|---|---|---|
| [NON-019](../objections/NON-019-identifiant-par-sequence.md) | conditionnel | D1, D2, D5 |
| [NON-001](../objections/NON-001-identite-et-nommage.md) | Q1 **répondue** par cet ADR ; Q2, Q4, Q6, Q10 restent ouvertes | D1, D5 |
| [NON-011](../objections/NON-011-types-employes-sans-definition.md) | Q2 **répondue** par D4 | D4 |

## Relations

- `remplace` [ADR-001](ADR-001-adoption-de-la-notion-de-ressource.md), quant à sa décision D3
- `derive-de` [DCN-007](../decisions/DCN-007-identifiant-relatif-par-sequence.md)
- `derive-de` [FRG-001](../fragments/FRG-001-conception-des-ressources-et-de-son-identite.md)
- `specifie` [RES-001](../ressources/RES-001-ressource.md)
- `repond-a` [NON-001](../objections/NON-001-identite-et-nommage.md)
