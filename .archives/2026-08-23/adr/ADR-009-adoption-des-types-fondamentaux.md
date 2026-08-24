---
type: adr
id: ADR-009
title: "Adoption des sept types de la famille fondamentale"
version: 0.1.0
status: draft
maturity: conception
adoption: propose
activated: true
domain-status: "propose"
statut-decision: propose
date: 2026-08-10
decideurs: ["claude-opus-5 (rédaction)", "human:jvtrudel (à approuver)"]
sources:
  - ANL-001
  - "workspace/session.md, tâche 2 du 2026-08-09"
  - PLN-002
definition-associee: RES-001
---

# ADR-009 - Adoption des sept types de la famille fondamentale

> Acte l'adoption de Ressource, Contexte, Intention, Objection, Faits, Ontologie et Concept, et porte pour chacun le problème qu'il résout et l'état de la matière sur laquelle il repose.

## Statut

`propose`. Les sept types sont en usage depuis le 2026-08-09 ; leur adoption n'avait jamais été actée.

Créé par le chantier C de `PLN-002`, qui établit que vingt-neuf types sur trente n'avaient aucun `ADR` d'adoption, et que la justification retirée des définitions n'avait donc nulle part où aller.

## Contexte

Les sept types ont été produits à la tâche 2 de la session du 2026-08-09, à partir de `ANL-001`, qui observe cent soixante-six dépôts.

Ils n'ont pas la même assise. `ANL-001` classe chaque notion selon son état dans le corpus, et l'écart va d'un mécanisme éprouvé pendant un an à une notion que rien n'a jamais employée.

| Type | État dans le corpus | Matière disponible |
|---|---|---|
| Ressource | **éprouvé** | Une définition, un skill, un usage réel dans `micrologic-clients` |
| Objection | **éprouvé** | Institué par `intentional-doers-governance` en juillet 2026, réifié dans `micrologic-clients` avec définition, quatre instances, skill, gabarit et régime hybride |
| Ontologie | **amorcé** | Une instance, `ONT-001-ontologie-du-patrimoine`. Théorie antérieure dans `nty` et `comm-cli` |
| Intention | **latent** | Présent dès février 2022 dans `noumanity/imagen`, dans une vingtaine de dépôts. Aucune instance typée |
| Contexte | **latent** | Actif depuis un an comme rubrique du fichier de session. Aucune instance typée |
| Faits | **latent** | Zéro instance. Un répertoire `.dev/fait` vide dans `comm-cli`, deux essais de fondation datés du 2026-08-08 |
| Concept | **absent** | Aucune instance, aucun répertoire, aucun skill, aucune mention hors du `CLAUDE.md` de `clia` |

Quatre des sept types sont donc des **réifications** d'une pratique non typée, et un est une proposition que rien n'a éprouvée.

## Décision en une phrase

Les sept types fondamentaux sont adoptés, avec un degré de confiance qui varie selon la matière du corpus, et le type le plus fragile porte un seuil d'admission strict pour compenser.

## Décisions détaillées

### D1 - Ressource, `RES`

**Problème résolu.** Déplacer la vérité du travail hors de la conversation, qui est volatile, vers un objet versionné qui persiste. `ANL-001` mesure des creux de travail allant jusqu'à quatre mois : un système qui suppose la mémoire de la session est inutilisable dans ce régime.

**Assise.** La meilleure du corpus. `RES-001` de `micrologic-clients` est repris et amendé.

**Auto-application.** La définition est une instance du type qu'elle définit : elle porte les seize champs obligatoires, vit à l'emplacement qu'elle déclare, suit la nomenclature qu'elle fixe. Un modèle dont le document central échappe à ses propres règles n'est pas un modèle.

### D2 - Contexte, `CTX`

**Problème résolu.** Le contexte existe comme rubrique du fichier de session, où il est réellement renseigné. Mais la session est éphémère par destination, alors que ce qu'on y écrit est durable : un historique d'un an, des parties prenantes, un état de système. À chaque session, l'humain réécrit une partie du même contexte et l'agent redécouvre le reste.

**Assise.** Latente. La pratique existe depuis un an, la réification est neuve.

### D3 - Intention, `INT`

**Problème résolu.** `CLAUDE.md` fait de l'intention ultime la référence de l'objection, et l'agent ne peut pas s'en servir. L'`INTENTION.md` de `clia` énonce une affirmation, non un critère : rien n'y permet de décider si une tâche sert ou trahit cette intention. `ANL-001` a dû objecter à cette affirmation par une mesure externe, faute de pouvoir la confronter à elle-même.

**Démonstration négative.** Trois dépôts de consultation partagent le même `INTENTION.md` au bit près, désignant un client qui n'est pas le leur.

**Conséquence sur la définition.** Une intention porte un critère de satisfaction **et** un critère de trahison. Sans le second, l'objection pour conflit d'intention est impossible à instruire.

### D4 - Objection, `NON`

**Problème résolu.** Donner à l'humain et à l'agent un moyen commun de contester une avancée sans bloquer le travail.

**Assise.** La deuxième meilleure du corpus, après la ressource.

**Conséquence sur la définition.** L'objection déclare son effet : `bloquant`, `conditionnel` ou `informatif`. La règle « aucune exécution tant qu'une objection est ouverte », héritée de la gouvernance sociocratique, rend le travail impossible dès que le nombre d'objections croît.

### D5 - Faits, `FCT`

**Problème résolu.** Un besoin métier et concret : prouver l'adéquation d'un candidat à un poste demande des faits, pas des affirmations.

**Assise.** Latente, avec une base théorique récente : deux essais de fondation et deux analyses dans `micrologic-clients`, tous du 2026-08-08.

**Conséquence sur la définition.** L'unité de fichier est le recueil par sujet, l'unité de sens le fait atomique. Zéro instance `FCT` existe dans le corpus malgré un besoin théorisé : la granularité était l'obstacle.

### D6 - Ontologie, `ONT`

**Problème résolu.** Une dérive lexicale non contrôlée, établie par mesure et non par principe.

| La même chose s'appelle | Dans |
|---|---|
| `livrable` et `ressource` | Deux lignées du corpus |
| `completed` et `complet` | Cinquante-deux logs et deux logs du même dépôt |
| `améliorations`, `issues`, `tickets`, `needs`, `features` | Cinq dépôts pour un même objet |
| `session.md`, `.dev/session.md`, `workspace/session.md` | Trois emplacements pour le point d'entrée |
| `OBJ` et `NON` | Deux préfixes pour l'objection |

Aucun de ces écarts n'a été détecté au moment où il s'est produit. Ils ont été trouvés en comparant cent soixante-six dépôts.

### D7 - Concept, `CPT`

**Problème résolu.** Le corpus produit des concepts en abondance et les perd. `ANL-001` en relève sept, tous formulés dans un dépôt, tous employés, aucun n'ayant de document propre. Topologie de style, phore, pilier de communication, distillation, extreme-smart : plus cités nulle part, ou cités sans être élaborés.

**Assise.** La plus faible des sept. Le type est classé **absent** du corpus.

**Compensation.** Un seuil d'admission à trois conditions, écrit dans la définition. `ANL-001` D4 mesure que le système consacre une part croissante de son énergie à se décrire : un type sans seuil d'admission aggraverait ce défaut.

## Conséquences

Les sept définitions retirent leurs rubriques `Statut de ce document` et `Le problème que ce type résout` : leur contenu est ici.

Le champ `adr` des sept définitions passe de `ADR-005` à `ADR-009`. `ADR-005` décide le regroupement en familles, non l'adoption des types.

**Ce que la décision assume.** Quatre types sur sept réifient une pratique non typée, et un ne repose sur rien. Le risque est celui que `NON-002` conteste : un modèle plus coûteux que ce qu'il fait gagner.

## Objections ouvertes

`NON-002`, bloquante, sur le coût du modèle et la prolifération des types.

`NON-003`, sur la frontière entre contexte, intention et faits.

`NON-005`, bloquante, sur les règles écrites et non tenues.

`NON-011`, sur les types employés sans définition.

## Relations

- `derive-de` [ANL-001](../analyses/ANL-001-observation-corpus-repos-et-pratiques/index.md)
- `specifie` [RES-001](../ressources/RES-001-ressource.md)
- `reference` [ADR-005](ADR-005-regroupement-fonctionnel-des-ressources.md)
