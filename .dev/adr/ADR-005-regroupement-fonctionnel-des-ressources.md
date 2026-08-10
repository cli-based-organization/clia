---
type: adr
id: ADR-regroupement-fonctionnel-des-ressources
title: "Regroupement fonctionnel des ressources en six familles"
version: 0.1.0
status: draft
statut-decision: propose
date: 2026-08-10
decideurs: ["human:jvtrudel (décideur)", "claude-opus-5 (rédaction)"]
sources:
  - "workspace/session.md, tâche 8 du 2026-08-09"
  - ADR-adoption-de-la-notion-de-ressource
  - NON-cout-du-modele
  - ANL-001-observation-corpus-repos-et-pratiques
definition-associee: RES-ressource
skill-associe: skl-001-ressource
---

# ADR-005 - Regroupement fonctionnel des ressources en six familles

> Acte que les types de ressources sont regroupés selon leur fonction en six familles : fondamentale, conception, contrôle, contenu, préparation, implémentation. Et tire de ce regroupement la conséquence qui rend le modèle soutenable : le processus de production est attaché à la famille, non au type.

## Statut de cette décision

`propose` quant à sa rédaction. La décision de fond est prise par l'humain dans la tâche 8 de la session du 2026-08-09, qui l'énonce sous la forme « Nous décidons ceci ».

La conséquence D4, qui attache le skill à la famille plutôt qu'au type, est en revanche une proposition de l'agent et non une décision de l'humain. Elle est signalée comme telle et portée par une objection.

## Contexte

### Ce que la décision vient ranger

`CLAUDE.md` annonce vingt-sept types de ressources, déjà répartis en cinq groupes, avec des intitulés qui ne sont pas des noms de familles mais des sections d'un document. Le dépôt en a défini neuf au 2026-08-10.

`ANL-001` établit au défaut D4 que le système consacre une part croissante de son énergie à se décrire, avec trois mesures : cinq skills sur douze portaient déjà sur les fichiers de harnais eux-mêmes dans un dépôt antérieur ; sur les 585 instances de ressources typées du corpus, les traces d'exécution dominent les livrables ; et le harnais prescrit sept fichiers de journal pour des tâches dont la durée médiane est de trente minutes.

`NON-002` conteste précisément ce coût, et sa question Q1 demande si le triplet définition, décision, processus est exigible pour tous les types. La question est ouverte depuis le 2026-08-09 et n'a pas reçu de réponse.

### Pourquoi le regroupement compte plus qu'un rangement

Sans famille, chaque type est un cas isolé et exige son propre appareil complet. Vingt-neuf types font vingt-neuf skills, vingt-neuf schémas, vingt-neuf gabarits.

Avec des familles, ce qui est commun se déclare une fois. Le regroupement demandé par l'humain n'est donc pas seulement une taxinomie : c'est le levier qui rend le modèle soutenable. C'est l'objet de la décision D4.

## Décision, en une phrase

> Les types de ressources sont regroupés en **six familles** définies par leur fonction dans le travail : fondamentale, conception, contrôle, contenu, préparation, implémentation. Chaque type déclare sa famille. La famille porte le **processus de production**, le type porte ses **spécificités**, et le méta-type porte les **règles communes**.

## Décisions détaillées

### D1 - Six familles, définies par leur fonction

**Décision.** Six familles, et la fonction est ce qui les distingue.

| Famille | Fonction dans le travail | Question à laquelle la famille répond |
|---|---|---|
| **fondamentale** | Constitue le socle conceptuel du système | De quoi le travail est-il fait ? |
| **conception** | Produit du savoir en vue d'une décision | Que savons-nous, et que vaut ce savoir ? |
| **contrôle** | Encadre le comportement des agents | Comment travaille-t-on ici ? |
| **contenu** | Apporte de la matière dans le système | Qu'est-ce qui entre ? |
| **préparation** | Prépare et planifie une réalisation | Que va-t-on faire, et selon quelles contraintes ? |
| **implémentation** | Réalise et diffuse | Qu'est-ce qui sort ? |

**Motif.** La fonction est le seul critère qui ne dépende ni du format, ni de l'emplacement, ni du cycle de vie. Un classement par format aurait rangé ensemble tout le markdown ; un classement par emplacement aurait reproduit l'arborescence.

**Alternative écartée.** Les cinq groupes de `CLAUDE.md`. Écartée parce qu'ils ne distinguent pas la matière qui entre de ce que le système produit, ce qui est précisément la distinction que la tâche 8 introduit en créant la famille contenu.

### D2 - Un type appartient à exactement une famille

**Décision.** Chaque définition de type déclare un champ `famille` obligatoire, à valeur unique.

**Motif.** Une appartenance multiple rendrait la famille inutilisable comme critère de rattachement d'un processus, ce que D4 en fait.

**Difficulté assumée.** Certains types sont à la frontière, et le classement retenu en D3 tranche là où l'énoncé de la tâche est muet. Chaque arbitrage est signalé.

### D3 - Attribution des types

**Décision.** L'attribution suivante, qui reprend les groupes de `CLAUDE.md` et les complète.

| Famille | Types |
|---|---|
| fondamentale | Ressource `RES`, Contexte `CTX`, Intention `INT`, Objection `NON`, Faits `FCT`, Ontologie `ONT`, Concept `CPT` |
| conception | Analyse `ANL`, Fondation `FND`, Principe de conception `PDC`, Méthodologie `MET` |
| contrôle | Harnais opératoire, Harnais d'architecture, Harnais constitutionnel, Harnais de gouvernance, Skill |
| contenu | Fragment `FRG`, Décision `DCN`, Entrevue `ENT` |
| préparation | Décision d'architecture `ADR`, Spécification `SPC`, Requis fonctionnel `RQF`, Requis non fonctionnel `RQNF`, Cas d'usage `USE`, Comportement attendu `CMP`, Plan `PLN` |
| implémentation | Code `CDE`, Rapport de recherche `RPT`, Article `ART`, Présentation `PRS` |

**Cinq arbitrages, chacun signalé.**

`ENT`, l'entrevue, est rangée en **contenu** et non en implémentation où `CLAUDE.md` la place. Motif : la tâche 8 la cite elle-même parmi les mécanismes d'entrée existants, aux côtés de `source-material` et des objections. Une entrevue apporte de la matière, elle ne réalise rien.

`PLN`, le plan, est rangé en **préparation** bien qu'absent de `CLAUDE.md`. Le type est employé, avec une instance produite à la tâche 4.

`ADR` reste en **préparation** conformément à `CLAUDE.md`, et le classement est discutable : un ADR acte une décision plutôt qu'il ne prépare une réalisation. Sa proximité avec `DCN`, rangée en contenu, mérite examen. Voir `NON-017`.

Le préfixe du code est retenu comme `CDE`, conformément à `CLAUDE.md`, alors que la tâche 8 écrit `COD`. Écart signalé, arbitrage à l'humain.

`LOG`, le log de sortie, **n'est dans aucune famille**, et c'est l'objet de D5.

### D4 - La famille porte le processus, le type porte ses spécificités

**Décision.** Le processus de production d'une ressource est attaché à sa **famille**, sous la forme d'un skill par famille. Un type ne reçoit un skill propre que si son processus s'écarte de celui de sa famille.

Trois niveaux, du général au particulier.

| Niveau | Porte | Où |
|---|---|---|
| Méta-type | Les règles communes à toute ressource | `skl-001-ressource`, partie A |
| Famille | Le processus commun à la famille | Un skill par famille |
| Type | Les spécificités, les champs, les sections, les frontières | La définition `RES` du type |

**Motif.** C'est la conséquence qui rend le modèle soutenable, et elle répond à une objection ouverte. `NON-002` Q1 demande si le triplet complet est exigible pour tous les types ; `ADR-001` D6 avait déjà décidé que le triplet se complète type par type. Cette décision va plus loin : elle réduit le nombre de processus à écrire de vingt-neuf à six, plus les exceptions.

Le gain est mesurable. Vingt-neuf types auraient demandé vingt-neuf skills ; six familles en demandent six, plus `skl-001` qui existe. Le rapport entre l'outillage produit et le travail accompli, que `ANL-001` mesure comme se dégradant, s'améliore d'un facteur quatre sur ce poste.

**Ce que la décision suppose.** Que les types d'une même famille se produisent effectivement de la même manière. C'est vrai pour la famille conception, où une analyse, une fondation et une méthodologie suivent le même mouvement de recherche, de rédaction et de sourçage. C'est moins évident pour la famille implémentation, où un code et une présentation n'ont pas de processus commun. Voir `NON-017`.

**Statut de cette décision.** Elle est une proposition de l'agent, non une décision de l'humain. La tâche 8 demande un skill pour toute ressource ; cette décision propose un skill par famille. L'écart est délibéré, motivé, et soumis à arbitrage.

**Alternative écartée.** Un skill par type, comme la tâche 8 le demande littéralement. Écartée parce qu'elle produirait vingt-neuf documents de processus dont la majeure partie serait identique, ce qui est exactement le mode de défaillance que `ANL-001` mesure au défaut D2 : trente-trois `CLAUDE.md` pour dix-huit contenus distincts, faute de mécanisme de mise en facteur.

### D5 - Les traces ne sont pas une famille de ressources

**Décision.** Le log de sortie et la session ne sont dans aucune des six familles, parce qu'ils ne sont pas des ressources livrables mais des traces.

**Motif.** Le `resource-types.yaml` archivé distinguait déjà les ressources livrables des traces, catégorie non versionnée et sans skill de production. `ADR-001` D8 place la session hors du modèle. `RES-001` ne reprend pas cette distinction et ne connaît que trois cycles de vie.

Cette décision ne tranche pas le statut des traces, que `NON-011` Q6 porte déjà. Elle constate que les six familles ne les accueillent pas, et refuse de les y ranger par commodité.

### D6 - La famille est déclarée, elle ne commande pas l'emplacement

**Décision.** La famille est une propriété déclarée dans le frontmatter de la définition de type. Elle ne détermine pas le chemin des instances.

**Motif.** Faire dépendre l'emplacement de la famille imposerait de déplacer toutes les instances existantes, et `ANL-001` mesure qu'un simple changement de préfixe a déjà coûté six corrections manuelles dans un dépôt voisin. Le bénéfice serait cosmétique.

**Conséquence.** Un répertoire ne dit pas la famille de ce qu'il contient. C'est `clia res ls` qui doit l'afficher, ce qui suppose une colonne de plus.

## Conséquences

### Ce que la décision apporte

Le nombre de processus à écrire passe de vingt-neuf à six. C'est le seul effet de cette décision qui change l'ordre de grandeur du travail restant.

La famille contenu introduit une distinction que le modèle n'avait pas : ce qui entre dans le système, distinct de ce qu'il produit. C'est la réponse structurelle à la contrainte du point d'entrée unique que la tâche 8 met en cause.

Chaque type reçoit une place, y compris ceux que `CLAUDE.md` laissait avec des marque-places.

### Ce que la décision coûte

Un champ de plus dans le frontmatter de chaque définition de type.

Une colonne de plus dans `clia res ls`.

Six skills à écrire, plus les exceptions par type qui apparaîtront à l'usage.

### Ce que la décision ne règle pas

Le statut des traces, constaté et non tranché en D5.

Le classement de `ADR`, retenu par conformité à `CLAUDE.md` et discutable.

L'hypothèse de D4, qui suppose un processus commun par famille et n'est pas vérifiée pour la famille implémentation.

## Objections ouvertes sur cette décision

| Objection | Effet | Décisions concernées |
|---|---|---|
| [NON-017](../objections/NON-017-familles-et-processus.md) | bloquant | D3, D4 |
| [NON-002](../objections/NON-002-cout-du-modele.md) | bloquant | D4, qui lui apporte une réponse partielle |
| [NON-011](../objections/NON-011-types-employes-sans-definition.md) | conditionnel | D5, sur le statut des traces |

## Relations

- `derive-de` [DCN-002](../decisions/DCN-002-regroupement-fonctionnel-des-ressources.md)
- `specifie` [RES-001](../ressources/RES-001-ressource.md)
- `reference` [ADR-001](ADR-001-adoption-de-la-notion-de-ressource.md)
- `reference` [NON-002](../objections/NON-002-cout-du-modele.md)
