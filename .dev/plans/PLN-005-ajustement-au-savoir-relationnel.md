---
type: plan
id: PLN-005
title: "Ajustement de clia aux réponses de NON-004"
status: draft
statut-plan: propose
date: 2026-08-11
initiateur: agent
sert: []  # ajustement du modèle de ressources : documentaire
porte-sur: [RES-007, RES-010, skl-001, ONT-001]
---

# PLN-005 - Ajustement de clia aux réponses de NON-004

> Neuf chantiers. Le chantier A ne produit aucun document : il corrige une règle de méthode que trois réponses reprochent à l'agent. Le chantier B, l'ontologie, conditionne trois autres. Ce plan n'est pas exécuté.

## Statut

`propose`. **Réévalué le 2026-08-11 par `MET-004`**, tâche 29.

| Livrable | Verdict |
|---|---|
| A1, A2 règles de méthode | **implémenté** |
| C1, C2 seuil d'admission de `RES-007` | **implémenté** |
| I1 distinction des deux catégories | **implémenté** |
| D1 type `REG` | **fait à la tâche 28** |
| C3, C4, D2 à D4, I2 | SMART, préalable ouvert |
| A3, B, E, F, G, H | non-SMART, sortis du plan |

**Six livrables sont sortis du plan** et vivent désormais dans cinq issues, `ISU-002` à `ISU-006`, chacune avec son objection.

**Aucun chantier ne déclarait de limite de temps**, ce que `PDC-003` V-S3 exige au régime extrême SMART. Le défaut porte sur le plan entier.

L'interprétation et les mesures sont dans `ANL-008`, qui remplace `ANL-007`.

Remplace `PLN-004`, fondé sur une seule réponse.

**Limite de temps.** Non déclarée. `PDC-003` V-S3 l'exige au régime extrême SMART, et les cinq plans du dépôt échouent à ce contrôle. Le défaut porte sur le plan entier, non sur un chantier ; il est constaté ici plutôt que corrigé, faute de base pour estimer une durée.

## Intention

Ajuster `clia` aux sept réponses de `NON-004`, et corriger la méthode de l'agent que trois d'entre elles mettent en cause.

Cible mesurable : les six productions demandées existent, et `RES-007` et `RES-010` ne contredisent plus les réponses.

## Chantiers

### Chantier A - Corriger la méthode, pas les documents

**Premier, et il ne produit aucun livrable nouveau.**

Trois réponses reprochent à l'agent un même défaut : confondre ce qui est constaté avec ce qui fait autorité. Tant qu'il n'est pas corrigé, chaque chantier suivant le reproduit.

| Étape | Action | Cible |
|---|---|---|
| A1 | Écrire la règle : **une observation est une hypothèse, non une norme**. La source de vérité est contextuelle et déterminée par l'humain via `INT` et `DCN` | `skl-001`, partie A |
| A2 | Écrire la règle : **un écart entre une intention et son implémentation n'est pas un démenti** | `skl-001`, ou `RES-003` |
| A3 | Retirer des documents actifs les formulations qui traitent `ANL-001` comme normative | à mesurer |

**Coût.** Deux règles, plus une relecture dont le volume n'est pas mesuré.

**Ce que A3 suppose.** Un inventaire des passages où un constat de `ANL-001` est employé comme fondement plutôt que comme observation. Le dépôt cite `ANL-001` dans un grand nombre de documents, et distinguer les deux emplois demande une lecture.

**Dépend de.** Rien.

### Chantier B - ONT-001, l'ontologie des concepts fondamentaux

**Demandé explicitement.** Réponse Q2 : « Commençons par créer une ontologie ONT-001 définissant les concepts fondamentaux de clia et leurs relations. »

| Étape | Action |
|---|---|
| B1 | Produire `ONT-001` : concepts fondamentaux de `clia` et leurs relations |
| B2 | Y porter le vocabulaire de relations, aujourd'hui dans `RES-001` par défaut |
| B3 | Y tracer la frontière **information contre savoir**, demande D5 |
| B4 | Y tracer la frontière **concept contre relation**, demande D4 |

**Ce que B2 règle.** La contradiction interne que `NON-004` nommait : neuf relations employées par trente-quatre définitions, définies dans `RES-001`, ce qui est une source parallèle.

**Ce que B4 laisse ouvert.** La réponse Q2 pose la question sans la trancher : « il serait probablement logique de créer une ressource RES de type relation. Quoique il faudrait au préalable définir la frontière entre concept et relation. La relation est probablement un type de concept avec un ensemble de propriétés particulières ? »

Le point d'interrogation est dans la réponse. B4 trace la frontière ; il ne crée pas le type.

**Dépend de.** Chantier A. Une ontologie écrite sous le défaut que A corrige inscrirait des observations comme des définitions.

**Ce chantier conditionne D, E et H.**

### Chantier C - Ajuster RES-007 et RES-010

Les deux définitions que les réponses contredisent directement.

| Étape | Action | Réponse |
|---|---|---|
| C1 | Retirer le test d'admission à trois conditions de `RES-007` | Q6 |
| C2 | Le remplacer par le critère unique : compatibilité avec `clia` ou avec le système qui l'emploie, décidée par l'humain qui crée le concept | Q6 |
| C3 | Réviser `RES-010` : l'analyse est une **réflexion sur une question précise**, ressource **générée** à partir de `FND`, d'une question et de toute information pertinente | Q5 |
| C4 | Réviser `RES-011` : la fondation **mobilise le savoir existant et accessible** | Q5 |

**Coût.** Trois définitions, quatre éditions.

**Dépend de.** Rien pour C1 et C2. C3 et C4 gagnent à suivre B, qui fixe le vocabulaire.

### Chantier D - Le type Registre et ses trois instances

**Demandé.** Réponse Q4 : « Le registre de dette est une bonne idée ! Créer une ressource registre puis une instance registre de dette. Également, registre de bogues et registre de tâches à faire prochainement. »

| Étape | Action |
|---|---|
| D1 | Définir le type `REG`, avec ses artefacts |
| D2 | `REG-001`, registre de dette |
| D3 | `REG-002`, registre de bogues |
| D4 | `REG-003`, registre de tâches à faire prochainement |

**Ce que le dépôt possède déjà et qui alimenterait D2.** La rubrique `dette_nommee` de chaque log `next`, tenue depuis la tâche 13. Dix règles écrites et non tenues y sont recensées, plus une dizaine d'autres dettes.

**Ce que D3 alimenterait.** Les bogues connus et non corrigés, dont ceux que les journaux portent.

**Point à trancher.** Un registre est-il un composite dont chaque entrée est une ressource, ou un document unique à entrées numérotées sur le modèle du recueil de faits ? La question rejoint `ISU-001`.

**Dépend de.** Chantier B pour le vocabulaire.

### Chantier E - Le PDC sur la distillation

**Demandé.** Réponse Q4 : « Proposer un PDC qui traite de la distillation. La distillation est également le moteur du cycle de vie des ressources informationnelles. »

| Étape | Action |
|---|---|
| E1 | Écrire le concept de distillation, ou l'entrée d'ontologie correspondante |
| E2 | Écrire le `PDC` |

**Contrainte.** `CONSTITUTION.md` C1 réserve la création d'un `PDC` à l'humain. `NON-027` Q1 demande si l'agent peut en produire un premier jet non actif, et la question est ouverte.

**Dépend de.** Chantiers A et B.

### Chantier F - Le type Technote

Réponse Q3 distingue la technote de la fondation par l'usage et l'acteur, non par la taille.

| Étape | Action |
|---|---|
| F1 | Définir le type, orienté vers l'action concrète d'un acteur |
| F2 | Décider si les trois déclinaisons, absolu, acteur humain, acteur IA, sont trois types, un champ, ou trois sections |

**Ce que ce chantier corrige.** La proposition d'un type `NOT` défini comme « plus court », que la réponse Q3 invalide.

**Dépend de.** Chantier B, pour la frontière information contre savoir.

### Chantier G - Le rôle contextuel source ou générée

Réponse Q3 : une ressource peut être hybride ; dans un contexte d'usage donné, elle n'a qu'un rôle à la fois.

| Étape | Action |
|---|---|
| G1 | Faire de la qualité source ou générée un **rôle contextuel**, non une propriété du type |
| G2 | Écrire l'obligation de propagation : une mise à jour du savoir mobilisé met à jour les ressources générées à partir de lui |
| G3 | Outiller G2 |

**G2 est la troisième obligation de propagation du dépôt**, après celle des alias et celle du remplacement des décisions. Les trois sont non outillées.

**Dépend de.** `NON-026` Q5, dont le mécanisme de génération n'est pas implémenté.

### Chantier H - Le cycle de vie collectif

Réponse Q4 : « le cycle de vie des ressources informationnelles n'est pas individuel, il est collectif ».

`RES-001` attribue à chaque ressource un cycle individuel, `vivant`, `point-fixe` ou `travail`.

| Étape | Action |
|---|---|
| H1 | Établir ce qu'un cycle collectif implique pour le modèle |
| H2 | Décider si les trois cycles individuels subsistent, et sous quel rapport |
| H3 | Écrire la notion d'**espace actif**, que `CLAUDE.md` mentionne en une ligne sans la définir |

**Aucune réponse ne dit par quoi remplacer le modèle.** Ce chantier est une recherche, non une application.

**Dépend de.** Chantier B.

### Chantier I - Les deux catégories de ressources

Réponse Q2 : distinguer les ressources propres au dépôt `clia` de celles des dépôts qui l'emploient.

| Étape | Action |
|---|---|
| I1 | Écrire la distinction |
| I2 | Classer les ressources existantes dans l'une ou l'autre |

**Ce que cela recoupe.** `NON-026` Q4 demande les critères de conformité d'un dépôt `clia`, et `PLN-003` chantier G1 les porte. La distinction en est le préalable.

**Dépend de.** Rien.

## Livrables attendus

| Chantier | Livrable | Nature |
|---|---|---|
| A | `skl-001`, deux règles | Modification |
| B | `ONT-001` | Création |
| C | `RES-007`, `RES-010`, `RES-011` | Modification |
| D | Type `REG`, trois instances | Création |
| E | Un concept, un `PDC` | Création, par l'humain |
| F | Type technote | Création |
| G | `RES-001`, et un outil | Modification, implémentation |
| H | Une recherche, la notion d'espace actif | Création |
| I | La distinction, et un classement | Création |

## Ordre d'exécution

```
A ──> B ──> D
      │     E (humain)
      ├──> F
      └──> H

C1, C2 sans dépendance ; C3, C4 après B
G, après le mécanisme de génération de NON-026 Q5
I, sans dépendance
```

**Trois points d'arrêt.**

Après A : la méthode est corrigée, et les chantiers suivants ne reproduisent plus le défaut.

Après B : le vocabulaire est fixé, et cinq chantiers deviennent exécutables.

Avant E : `CONSTITUTION.md` C1 réserve le `PDC` à l'humain, et `NON-027` Q1 est ouverte.

**L'ajustement minimal est A, C1 et C2.** Deux règles de méthode et deux éditions dans une définition. Aucun outil.

## Objections de l'agent

**Le chantier A me vise, et c'est moi qui l'écris.** Trois réponses reprochent à l'agent une erreur de méthode, et c'est l'agent qui en tire les règles. `ANL-008` C1 propose que les trois relèvent d'un même défaut, ce qui a l'inconvénient de ramener trois critiques distinctes à une seule et de les rendre plus faciles à traiter.

**Le chantier H n'a pas de solution.** Aucune réponse ne dit par quoi remplacer le cycle de vie individuel. Le chantier est décrit pour que la question ne se perde pas, non pour être exécuté.

**Le chantier G ajoute la troisième obligation de propagation non outillée.** Les alias, le remplacement des décisions, et maintenant le savoir vers ses ressources générées. Aucune des trois n'a de contrôle.

**Ce plan est le quatrième non exécuté**, avec `PLN-001`, `PLN-003` et le chantier R2 de `ANL-005`. `PLN-004` est remplacé par celui-ci.

**Neuf chantiers pour sept réponses est beaucoup.** `NON-002` conteste le coût du modèle, et ce plan ajoute deux types, une ontologie, un principe et une recherche. Le nombre suit ce que les réponses demandent, et il ne le rend pas soutenable pour autant.

## Relations

- `derive-de` [ANL-008](../analyses/ANL-008-le-savoir-est-une-relation-entre-un-acteur-et-une-information.md)
- `remplace` [PLN-004](PLN-004-ajustement-du-savoir.md)
- `reference` [ISU-002](../issues/ISU-002-aucun-generateur-de-ressources-derivees.md)
- `reference` [ISU-003](../issues/ISU-003-le-cycle-de-vie-collectif-n-est-pas-modelisable.md)
- `reference` [ISU-004](../issues/ISU-004-deux-frontieres-conceptuelles-non-tracees.md)
- `reference` [ISU-005](../issues/ISU-005-l-agent-ne-peut-pas-creer-un-principe-de-conception.md)
- `reference` [ISU-006](../issues/ISU-006-le-volume-du-nettoyage-des-formulations-est-inconnu.md)
- `reference` [RES-007](../ressources/RES-007-concept.md)
- `reference` [PLN-003](PLN-003-mise-en-conformite-avec-dcn-013.md)
