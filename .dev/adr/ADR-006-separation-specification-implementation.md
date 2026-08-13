---
type: adr
id: ADR-006
title: "Séparation stricte de la spécification et de l'implémentation"
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
  - "workspace/session.md, tâche 10 du 2026-08-09"
  - ANL-002
  - ADR-003
  - ANL-001-observation-corpus-repos-et-pratiques
definition-associee: RES-001
skill-associe: skl-006-ressource-de-preparation
---

# ADR-006 - Séparation stricte de la spécification et de l'implémentation

> Acte que le système `clia` se compose de deux corpus distincts et non substituables : une **spécification**, qui dit ce que le système est et doit faire sans nommer aucune technologie, et une **implémentation**, qui le réalise. La spécification doit survivre à la suppression de l'implémentation, et plusieurs implémentations doivent pouvoir la satisfaire.

## Statut de cette décision

`propose` quant à sa rédaction. La décision de fond est prise par l'humain dans la tâche 10 de la session du 2026-08-09, qui demande de distinguer de manière stricte la spécification du système de son implémentation.

## Contexte

### Le fait qui rend la décision nécessaire

`ANL-001` mesure que le corpus a réinventé **onze CLI en vingt-et-un mois**, dont neuf abandonnés, un archivé, et un jamais commité malgré trente fichiers et un CLI Go fonctionnel.

Chacun de ces onze outils emportait sa propre conception. Aucun ne laissait derrière lui une spécification réutilisable. Le douzième, `clia`, est en train de refaire le même chemin : `ANL-002` établit qu'il n'existe aucune spécification du système, et `ADR-003` reporte à une session d'outillage la grammaire des commandes, le langage, le mécanisme d'extension et le format des sorties.

Le coût de cette absence est direct. Réimplémenter `clia` dans un autre langage exigerait aujourd'hui de relire son code bash, parce que rien d'autre ne dit ce qu'il doit faire.

### Ce que le corpus a déjà su faire, et perdu

Le dépôt `disruptiva-dev/comm-cli` est le contre-exemple utile. Il contient une spécification complète d'un système de communication : une constitution de deux cent trente lignes, trois ADR, neuf spécifications de ressources classées par nature, trois essais de fondation. **Et aucune ligne de code.**

`ANL-001` le classe parmi les échecs, parce que la conception y allait plus vite que la réalisation. C'est vrai, et cela n'enlève rien à ce que le dépôt démontre : une spécification peut exister seule, être complète, et se lire trois mois plus tard.

### Où passe la frontière aujourd'hui

Nulle part de manière déclarée. `ADR-003` D4 pose une frontière interne à trois zones, harnais à la racine, méthode dans `.dev/`, outil dans un emplacement dédié. Cette frontière sépare la **méthode** de l'**outil**, ce qui n'est pas la même distinction : la méthode contient à la fois de la spécification et des artefacts d'implémentation.

Le cas le plus net est celui des soixante schémas CUE et des vingt-neuf gabarits produits le 2026-08-10. Ils vivent dans `.dev/`, avec la méthode, et ils sont de l'implémentation : ils sont générés, jetables, régénérables, et ils nomment une technologie.

## Décision, en une phrase

> Le système se compose de deux corpus distincts. La **spécification** dit ce que le système est et ce qu'il doit faire, sans nommer aucune technologie ni aucun langage. L'**implémentation** le réalise, et déclare ce qu'elle implémente. La spécification est première : elle doit survivre à la suppression de l'implémentation, et plusieurs implémentations doivent pouvoir la satisfaire.

## Décisions détaillées

### D1 - Deux corpus, et un critère de départage en une question

**Décision.** Tout artefact du système appartient à l'un des deux corpus. Le critère est une question unique.

> **Cet artefact reste-t-il vrai si l'on change de langage d'implémentation ?**

Si oui, il appartient à la spécification. Si non, à l'implémentation.

**Application aux types existants.**

| Corpus | Types |
|---|---|
| **Spécification** | Toute la famille fondamentale, toute la famille conception, toute la famille préparation, et les harnais de la famille contrôle |
| **Implémentation** | Code `CDE`, les schémas dérivés, les gabarits dérivés, et les skills |
| **Ni l'un ni l'autre** | La famille contenu, qui apporte de la matière, et les traces |

**Le cas des skills est le plus discutable.** Un skill décrit comment on produit une ressource, ce qui est indépendant du langage. Il nomme cependant des commandes concrètes : `skl-001-ressource` fournit neuf contrôles écrits en bash et en Python. Il est donc rangé en implémentation, et sa partie normative, ce qu'il faut vérifier, devrait remonter en spécification. Voir `NON-018`.

### D2 - La spécification ne nomme aucune technologie

**Décision.** Aucun document de la spécification ne nomme un langage, une bibliothèque, un format de fichier concret ni une commande.

Ce que la spécification nomme à la place : des propriétés, des comportements observables, des contraintes vérifiables.

**Motif.** C'est la garde d'agnosticisme que `RES-020` porte déjà pour le type spécification, étendue à tout le corpus. Son motif y est écrit : une spécification qui nomme une technologie devient fausse quand la technologie change, alors que le comportement attendu ne change pas.

**Conséquence immédiate, et elle est gênante.** Plusieurs documents actuels violent cette règle. `ADR-001` D2 décide que la ressource est un fichier markdown à frontmatter YAML, ce qui nomme deux formats. `ADR-003` D3 décide un modèle orienté ressources en s'appuyant sur des outils nommés. `RES-026` décrit le code en citant bash.

Deux lectures sont possibles et la décision ne tranche pas. Soit ces documents sont de l'implémentation déguisée en spécification, et il faut les scinder. Soit le format est une propriété de la spécification, ce qui affaiblit D2. Voir `NON-018`.

### D3 - L'implémentation déclare ce qu'elle implémente

**Décision.** Tout artefact d'implémentation déclare, dans son en-tête, la ou les décisions de spécification qu'il réalise.

**Motif.** C'est la seule manière de rendre la frontière vérifiable dans le sens utile : de l'implémentation vers la spécification. Sans cette déclaration, on ne peut pas savoir si une décision est implémentée, ni ce qui casse quand elle change.

**Ce qui est déjà fait.** Les cinq fichiers de code de `clia` déclarent nommément les décisions de `ADR-003` qu'ils appliquent, depuis la tâche 6. Les soixante schémas déclarent la définition dont ils sont dérivés et la décision `ADR-003` D7 qui l'exige.

**Ce qui manque.** Le sens inverse. Aucune décision de spécification ne dit si elle est implémentée. `NON-018` porte la question de savoir s'il faut une trace bidirectionnelle.

### D4 - La spécification survit à la suppression de l'implémentation

**Décision.** Le test de la frontière est celui-ci : supprimer `bin/`, `lib/`, `tests/`, `.dev/schemas/` et `.dev/templates/` ne doit rien retirer à la compréhension du système. Ce qui reste doit permettre de le réimplémenter.

**Motif.** C'est le test que le corpus a échoué onze fois. C'est aussi celui que le refactor du 2026-08-08 a fait subir à ce dépôt sans le vouloir : il a archivé `setup.sh` et les tests, et le système a survécu, ce qui est le seul point positif de cet incident.

**État actuel du test, et il est défavorable.** Appliqué aujourd'hui, le test échoue sur un point précis : la grammaire des commandes de `clia`, l'ordre nom puis verbe, la forme des identifiants acceptés, le format des sorties, n'existent que dans le code et dans son aide. `ADR-003` les a explicitement reportés. Aucune spécification ne les porte.

### D5 - Une spécification manquante est une dette nommée

**Décision.** Lorsqu'une implémentation existe sans spécification, l'écart est inscrit comme dette explicite et non toléré en silence.

**Application immédiate.** `clia` implémente une spécification qui n'existe pas. Les types `SPC`, `RQF`, `RQNF`, `USE` et `CMP` sont définis depuis le 2026-08-10 et n'ont **aucune instance**. Le CLI compte 1 600 lignes de bash, quatre-vingt-onze tests, et zéro spécification.

C'est la dette la plus mesurable du système, et elle était invisible avant cette décision.

### D6 - Les artefacts dérivés sont de l'implémentation

**Décision.** Les soixante schémas CUE et les vingt-neuf gabarits appartiennent à l'implémentation, bien qu'ils vivent dans `.dev/` avec la spécification.

**Motif.** Ils nomment une technologie, ils sont générés, ils sont jetables. Chacun porte déjà l'avertissement de ne pas l'éditer à la main.

**Conséquence.** Leur emplacement contredit leur nature, et le déplacement est reporté : `ANL-001` mesure qu'un simple changement de préfixe a coûté six corrections manuelles, et déplacer quatre-vingt-neuf fichiers pour un gain de rangement serait disproportionné. La contradiction est déclarée plutôt que corrigée.

### D7 - Ce que la décision ne fait pas

**Décision.** Cette décision ne crée aucun répertoire, ne déplace aucun fichier, et ne rend aucun type obligatoire.

**Motif.** Elle est une décision de **nature**, non de rangement. `ADR-005` D6 a déjà tranché le même point pour les familles : une propriété se déclare, elle ne commande pas un chemin.

## Conséquences

### Ce que la décision apporte

Une réimplémentation devient concevable. C'est ce que le corpus n'a jamais pu faire : onze CLI, onze conceptions perdues.

La dette de spécification devient mesurable. Cinq types de préparation sans instance, face à 1 600 lignes de code, est un chiffre qu'on peut opposer.

Le test de D4 est exécutable. On peut vérifier, à tout moment, ce qu'il reste du système sans son implémentation.

### Ce que la décision coûte

Des spécifications à écrire, qui n'existent pas. Au moins une pour la grammaire du CLI, une pour le modèle de ressources, une pour la validation.

Une discipline de déclaration dans les deux sens, dont un seul est aujourd'hui tenu.

Un risque nommé, et le corpus en donne l'exemple : `comm-cli` est mort d'avoir spécifié sans implémenter. Une décision qui valorise la spécification doit se garder de ce travers.

### Ce que la décision ne règle pas

Le statut des skills, rangés en implémentation par défaut et discutables.

La contradiction entre la nature des artefacts dérivés et leur emplacement.

La violation de D2 par plusieurs documents existants, dont `ADR-001` D2.

## Objections ouvertes sur cette décision

| Objection | Effet | Décisions concernées |
|---|---|---|
| [NON-018](../objections/NON-018-specification-et-implementation.md) | bloquant | D1, D2, D3, D5 |
| [NON-002](../objections/NON-002-cout-du-modele.md) | bloquant | D5, qui ajoute des documents à écrire |
| [NON-006](../objections/NON-006-portee-du-systeme.md) | conditionnel | D2, sur le statut du format |

## Relations

- `derive-de` [DCN-006](../decisions/DCN-006-separation-specification-implementation.md)
- `reference` [ADR-003](ADR-003-adoption-de-l-usage-de-clia.md)
- `reference` [ANL-002](../analyses/ANL-002-localisation-du-cli-clia.md)
- `reference` [RES-020](../ressources/RES-020-specification.md)
