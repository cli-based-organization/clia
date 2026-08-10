---
type: adr
id: ADR-adoption-de-l-usage-de-clia
title: "Adoption de l'usage d'un CLI extensible, clia"
version: 0.1.0
status: draft
statut-decision: propose
date: 2026-08-09
decideurs: ["human:jvtrudel (à statuer)", "claude-opus-5 (rédaction)"]
sources:
  - FND-usage-des-cli-et-leur-renouveau
  - ANL-localisation-du-cli-clia
  - ANL-001-observation-corpus-repos-et-pratiques
  - ADR-adoption-du-processus-de-travail
  - "CONSTITUTION.md et resource-types.yaml, archivés dans .dev/archives/"
definition-associee: aucune
skill-associe: aucun
---

# ADR-003 - Adoption de l'usage d'un CLI extensible, clia

> Acte l'adoption d'un CLI comme troisième agent du système : ce qu'il est, ce qu'il fait, ce qu'il ne fait pas, où il vit, et à quelles conditions il en sortira. Ce document décide de l'**usage** de `clia`, pas de sa spécification : la session en cours annonce que l'outillage fera l'objet d'une session dédiée.

## Statut de cette décision

`propose`. La décision D4 sur la localisation est celle qui engage le plus, et elle est réversible par construction : elle porte son propre critère de renversement.

## Portée de ce document

Ce document décide **que** le système comporte un CLI, **pourquoi**, et **selon quel modèle**. Il ne décide pas de la grammaire exacte des commandes, du langage d'implémentation, du format des sorties ni du découpage des sous-commandes. Ces questions appartiennent à la session d'outillage annoncée par `workspace/session.md`.

La frontière est tenue volontairement : `ANL-001` établit au défaut D8 que le harnais actuel prescrit sept commandes `clia` dans un dépôt sans exécutable. Décrire une interface avant de l'avoir est précisément l'erreur à ne pas répéter.

## Contexte

### Le corpus a réinventé onze CLI en vingt-et-un mois

`ANL-002` en dresse la liste. Onze outils, dont neuf abandonnés, un archivé, un jamais commité malgré trente fichiers et un CLI Go fonctionnel. Un dépôt, `noumanity-dev/cli-convention`, a été créé pour établir une convention commune entre eux : il est vide.

Le seul qui ait réellement fonctionné est `tda`, qui a équipé au moins huit dépôts du corpus. Il avait trois propriétés que les dix autres n'avaient pas : un dépôt avec remote, un `setup.sh` documenté à trois modes, et une commande d'installation dans un dépôt tiers.

### Le renouveau des CLI n'est pas une préférence esthétique

`FND-001` établit cinq causes datées, dont trois pèsent directement ici.

Le modèle **orienté ressources** s'est imposé pour les outils qui manipulent des objets typés : on modélise des ressources nommées individuellement et on expose un petit ensemble de verbes standard, ce qui rend l'outil extensible par type sans le modifier.

Le CLI est devenu la **surface d'outillage préférée des agents IA**, pour quatre raisons convergentes : interface stable et déjà authentifiée, composabilité sans intégration, divulgation progressive qui économise le contexte, et gain mesuré de l'ordre de deux magnitudes sur la consommation de jetons dans un cas rapporté.

Le **déterminisme** permet un partage de responsabilité : ce que l'outil garantit, l'agent n'a plus à le garantir. C'est le seul moyen connu de rendre vérifiable une partie du travail d'un agent non déterministe.

### Ce que le système ne peut pas garantir aujourd'hui

`ANL-001` établit au défaut D2 que rien ne propage et rien ne valide, avec trois mesures : trente-trois `CLAUDE.md` pour dix-huit contenus distincts, un `CONSTITUTION.md` de zéro octet jamais détecté, trois `INTENTION.md` identiques désignant le mauvais client accompagnés de dix-huit logs recopiés.

Aucun de ces défauts n'est une faute de rédaction. Tous sont l'absence d'un mécanisme déterministe.

### Et le dépôt a perdu le sien

Le refactor `2373ec7` du 2026-08-08 a archivé `setup.sh` et les tests. Au matin du 2026-08-09, le dépôt ne contenait aucun exécutable et aucun moyen d'être installé ni vérifié, alors que son `INTENTION.md` promet un cadre de collaboration entre humain, automatismes et agent IA. La promesse d'automatisme n'a pas d'objet.

## Décision, en une phrase

> Le système comporte un **CLI déterministe et générique**, `clia`, troisième agent aux côtés de l'humain et de l'agent IA. Il est conçu selon le **modèle orienté ressources** et extensible par type. Sa fonction est de **garantir ce qui doit être garanti** : l'intégrité du système d'information, les transitions d'état, l'installation, la validation. Il **reste dans ce dépôt** tant que la méthode et l'outil changent ensemble, et il en sortira selon un critère écrit.

## Décisions détaillées

### D1 - clia est un agent, pas un accessoire

**Décision.** `clia` est le troisième agent du système, au sens de `ADR-002` D1. Il n'est ni l'agent IA, ni une ressource, ni un fichier de harnais : c'est un composant distinct dont la propriété définitionnelle est le déterminisme.

**Motif.** Reprise du `CONSTITUTION.md` archivé, dont la formulation reste la meilleure disponible : parce qu'il est déterministe et opéré par l'humain, `clia` peut légitimement muter des fichiers en édition humaine exclusive, car c'est l'humain qui agit via son outil. `clia` n'a pas de volonté propre, donc il n'a pas besoin de droits propres.

**Alternative écartée.** Traiter le CLI comme un simple utilitaire sans statut dans le modèle. Écartée parce que le déterminisme est la seule des trois propriétés d'agent qui permette de garantir quelque chose, et qu'une propriété de cette portée mérite d'être nommée.

### D2 - clia est générique et sans contenu de domaine

**Décision.** Aucune information propre à un dépôt, à un domaine métier ou à un client ne vit dans le code de `clia`. Le principe déjà écrit dans les archives sous le nom de généricité du harnais est étendu à l'outil.

**Motif.** C'est la condition pour que `clia` puisse équiper un dépôt tiers. `ANL-001` mesure ce que coûte sa violation : l'`INTENTION.md` de `clia` lui-même a été recopié comme intention métier dans deux dépôts, et trois dépôts de consultation partagent une intention désignant le mauvais client. Un outil qui embarque du contenu de domaine propage ce contenu à chaque installation.

### D3 - Le modèle est orienté ressources, extensible par type

**Décision.** `clia` est conçu selon le modèle établi par `FND-001` : des ressources nommées individuellement, d'un type déclaré, et un petit ensemble de verbes standard applicables par type. Ajouter un type de ressource n'exige pas de modifier les verbes existants.

**Motif.** Le modèle est directement transposable, parce que l'objet que `clia` manipule est exactement celui que le modèle décrit : une ressource typée, identifiée, localisée, au sens de `ADR-001`. Il soutient par ailleurs l'invariant d'extensibilité que `RES-001` retient et que `ADR-001` acte.

**Ce qui ne se transpose pas, et c'est important.** `FND-001` section 7.2 l'établit : dans les CLI d'infrastructure, créer une ressource est une opération mécanique. Ici, créer une ressource est un travail de rédaction encadré par un skill. `clia` peut créer le fichier, poser le frontmatter, attribuer le numéro et vérifier la conformité ; il ne peut pas produire le contenu. **La frontière entre l'outil et l'agent passe exactement là, et elle est plus haute que dans les CLI dont le modèle est emprunté.**

**Alternative écartée.** Une liste de commandes sans axe de ressources, comme dans les CLI de scripts du corpus. Écartée parce qu'elle rend l'ajout d'un type coûteux, ce qui décourage l'extensibilité.

**Reporté.** L'ordre des axes, verbe puis nom ou nom puis verbe, n'est pas tranché ici. `FND-001` section 5.1 documente les deux et note que le second se prête mieux à l'extensibilité. La décision appartient à la session d'outillage.

### D4 - clia reste dans ce dépôt, et l'extraction est préparée

**Décision.** `clia` est développé dans ce dépôt. Une frontière interne stricte sépare trois zones : le harnais à la racine, la méthode dans `.dev/`, l'outil dans un emplacement dédié avec ses sources et ses tests. L'extraction vers un dépôt indépendant est préparée mais non faite.

**Motif.** `ANL-002` répond à la question en détail. Trois raisons, dans l'ordre de leur poids.

La méthode et l'outil changent aujourd'hui ensemble : quatre tâches d'une seule journée ont produit trois mises en cohérence entre documents de méthode, et les contrôles de validation de `skl-001-ressource` sont déjà le cahier des charges d'une commande du CLI. Séparer un couple qui évolue ensemble crée une dette de synchronisation que rien, dans ce corpus, n'a jamais tenue.

L'urgence est ailleurs : le dépôt n'est ni installable ni vérifiable depuis le 2026-08-08, et ce défaut est identique dans les deux options.

Le précédent `tda` situe le bon moment de l'extraction : il a été extrait quand la méthode était consolidée, pas quand elle était en conception. `clia` n'y est pas, avec sept définitions en `draft`, trois ADR au statut `propose` et onze objections ouvertes.

**Alternative écartée.** Deux dépôts immédiatement, méthode ici et outil ailleurs. C'est la bonne cible et le mauvais moment. `ANL-002` retient d'ailleurs l'argument le plus solide en sa faveur, qui est de nature organisationnelle : un dépôt dédié aurait rendu visible la perte du `setup.sh`.

**Porte de sortie, écrite comme critère constatable.** L'extraction est déclenchée dès que l'une des trois conditions est remplie.

| Condition | Formulation |
|---|---|
| Diffusion | Un deuxième dépôt consomme `clia` pour produire des ressources dans un travail réel |
| Release | Le CLI a besoin d'une version publiée indépendante de l'état de la méthode |
| Découplage | Sur les vingt derniers commits, moins de deux touchent à la fois la zone méthode et la zone outil |

La troisième condition mesure exactement la raison invoquée pour ne pas séparer maintenant. Si la raison disparaît, la décision se renverse d'elle-même, sans débat.

### D5 - Le périmètre : ce que clia fait et ne fait pas

**Décision.** Le partage suit une règle unique : `clia` fait ce qui doit être **garanti**, l'agent IA fait ce qui doit être **interprété**.

| `clia` fait | `clia` ne fait pas |
|---|---|
| Les transitions d'état du cycle de vie des fichiers | Rédiger un contenu |
| L'inspection : lister, décrire, situer les ressources | Interpréter une demande |
| La validation de conformité | Décider d'une portée |
| L'installation et la mise à jour du harnais dans un dépôt | Résoudre une ambiguïté |
| L'attribution des numéros de séquence | Émettre une objection |

**Motif.** La règle découle du déterminisme. Toute opération dont le résultat dépend d'un jugement sort du périmètre par construction, sans qu'il faille l'énumérer.

**Deux conséquences concrètes.** L'attribution des numéros de séquence revient à `clia` : `NON-001` Q7 relève qu'aujourd'hui personne ne l'assure, ce qui produit des collisions dès que deux travaux avancent en parallèle. Et la validation revient à `clia` : les neuf contrôles de `skl-001-ressource` ont été écrits pour cela, `ADR-001` D9 le déclarant explicitement.

### D6 - clia est extensible

**Décision.** Une extension peut ajouter des types de ressources et des commandes à `clia`, sans modification de son noyau.

**Motif.** C'est la conséquence pratique de D3, et une nécessité observée : le corpus contient des types propres à des domaines, comme le patrimoine ou l'entrevue dans `micrologic-clients`, qui n'ont aucune raison de vivre dans un outil générique. Sans extension, chaque domaine forcerait une modification du noyau, et le noyau cesserait d'être générique, ce qui contredirait D2.

**Reporté.** Le mécanisme d'extension appartient à la session d'outillage.

### D7 - Une interface machine-lisible des types est nécessaire

**Décision.** `clia` lit la liste des types de ressources et leurs propriétés dans une source machine-lisible, distincte des documents rédigés pour un lecteur humain.

**Motif.** C'est la seule dépendance technique réelle de tout ce qui précède. Aujourd'hui, la liste des types vit dans `.dev/ressources/index.md`, document rédigé, et les propriétés de chaque type vivent dans le frontmatter de sa définition. Un outil peut lire le second, pas le premier.

Le `resource-types.yaml` archivé jouait exactement ce rôle, et son en-tête déclarait déjà que la table de `CLAUDE.md` en était une vue et non une source parallèle. Le rétablir est un prérequis, non une amélioration.

**Tension à signaler.** `ADR-001` fait de la définition de type la source de vérité. Une source machine-lisible parallèle recréerait le défaut de duplication que `NON-002` Q6 porte déjà. La seule position tenable est que la source machine-lisible soit **dérivée** des définitions, et non écrite à la main. Cette dérivation est un travail de `clia`.

### D8 - clia doit être installable et vérifiable

**Décision.** Le dépôt porte à tout moment un moyen d'installer `clia` et un moyen de vérifier que l'installation fonctionne. Restaurer le `setup.sh` archivé est la première tâche d'outillage, avant toute nouvelle fonctionnalité.

**Motif.** Trois faits convergent. Le dépôt a perdu cette capacité le 2026-08-08 sans que personne ne s'en aperçoive. Le seul CLI du corpus qui ait réellement équipé des dépôts, `tda`, la possédait avec un `setup.sh` à trois modes et une commande d'installation. Et `cli-based-organization/linux-inspect` porte déjà, dans son `INTENTION.md`, la meilleure doctrine d'installation du corpus, avec quatre principes nommés dont l'un, la réflexivité, exige que l'outil expose sa propre version et ses commandes.

**Alternative écartée.** Développer les fonctionnalités d'abord et l'installation ensuite. Écartée par l'observation : un outil non installable ne sort pas du dépôt où il naît, et neuf des onze CLI du corpus en sont morts.

### D9 - La sortie de clia sert trois publics

**Décision.** Toute sortie de `clia` est lisible par un humain et analysable par un programme. Dans ce système, le programme est le plus souvent l'agent IA.

**Motif.** `FND-001` section 6 en fait un principe établi de conception, pour deux publics. Le système en compte trois, et le troisième est le plus exigeant : `FND-001` section 4.5 établit que la divulgation progressive, c'est-à-dire le fait de ne retourner que ce qui est demandé, est ce qui rend un CLI supérieur à une API pour un agent, parce qu'elle traite le contexte comme la ressource rare qu'il est.

## Conséquences

### Ce que la décision apporte

Une partie du travail devient garantie plutôt que soignée. La conformité, la numérotation, l'installation cessent de dépendre de l'attention de l'agent.

Le partage de responsabilité devient net : ce que `clia` garantit, l'agent n'a plus à le garantir, et ce que l'agent interprète, `clia` n'a pas à l'approcher.

L'extensibilité est préservée sans que le noyau grossisse.

La question de la localisation est réglée avec son propre mécanisme de révision, ce qui évite de la rouvrir par opinion.

### Ce que la décision coûte

Un outil à écrire et à maintenir, par une personne travaillant par vagues avec des creux de plusieurs mois.

Une frontière interne à trois zones que rien ne vérifiera, comme rien ne vérifie les autres règles du système.

Une source machine-lisible des types à dériver et à maintenir cohérente avec les définitions.

### Ce que la décision ne règle pas

La grammaire des commandes, le langage d'implémentation, le mécanisme d'extension, le format des sorties. Tout cela appartient à la session d'outillage.

La propagation entre dépôts. `clia` en est le moyen, `NON-006` Q3 et Q4 en portent les questions ouvertes.

Le fait qu'aucune règle de ce document ne soit vérifiable avant que l'outil existe. C'est la situation circulaire que `NON-005` porte : l'outil qui doit valider est celui dont l'existence n'est pas encore garantie.

## Objections ouvertes sur cette décision

| Objection | Effet | Décisions concernées |
|---|---|---|
| [NON-011](../objections/NON-011-types-employes-sans-definition.md) | conditionnel | D3, D7 |
| [NON-005](../objections/NON-005-validation-et-regles-non-tenues.md) | bloquant | D5, D7, D8 |
| [NON-002](../objections/NON-002-cout-du-modele.md) | bloquant | D7 |
| [NON-006](../objections/NON-006-portee-du-systeme.md) | conditionnel | D2, D6 |
| [NON-001](../objections/NON-001-identite-et-nommage.md) | bloquant | D5, attribution des numéros |

## Relations

- `derive-de` [FND-001](../fondations/FND-001-usage-des-cli-et-leur-renouveau.md)
- `derive-de` [ANL-002](../analyses/ANL-002-localisation-du-cli-clia.md)
- `reference` [ADR-002](ADR-002-adoption-du-processus-de-travail.md)
- `reference` [ADR-001](ADR-001-adoption-de-la-notion-de-ressource.md)
