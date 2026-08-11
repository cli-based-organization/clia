---
type: plan
id: PLN-004
title: "Ajustement de clia aux réponses de NON-004"
status: draft
statut-plan: abandonne
date: 2026-08-11
initiateur: agent
porte-sur: [RES-006, RES-007, ISU-001, NON-004]
---

# PLN-004 - Ajustement de clia aux réponses de NON-004

> Six chantiers, dont deux seulement dérivent d'une réponse reçue. Les quatre autres attendent des réponses qui n'ont pas été écrites, et deux d'entre elles conditionnent la levée de l'objection. Ce plan n'est pas exécuté.

## Statut

`abandonne` le 2026-08-11, **remplacé par `PLN-005`**.

Ce plan a été produit quand une seule des sept questions de `NON-004` portait une réponse. Les sept en portent une désormais, et six changent ce que le plan ordonnait.

Il est conservé comme trace de ce qui était planifiable à ce moment. Aucun de ses chantiers n'a été engagé.

L'interprétation et les mesures sont dans `ANL-007`. Ce plan ordonne l'ajustement.

**Une réserve sur la portée.** `NON-004` porte sept questions et une seule a une réponse. Les chantiers C à F sont donc des chantiers **en attente d'arbitrage**, décrits pour que leur coût soit connu, non pour être exécutés.

## Intention

Ajuster `clia` à ce que la réponse Q1 de `NON-004` établit, et rendre exécutables les quatre chantiers qui attendent une réponse.

Cible mesurable : **zéro contradiction** entre `RES-006`, `RES-007` et la réponse reçue.

## Chantiers

### Chantier A - Réécrire la frontière concept contre ontologie

Le seul chantier entièrement fondé sur une réponse reçue.

`RES-007` départage le concept de l'entrée d'ontologie par la **forme** : une entrée de lexique contre un document d'une à trois pages. La réponse Q1 déplace le critère sur l'**usage attendu**.

| Étape | Action | Cible |
|---|---|---|
| A1 | Réécrire la frontière sur le critère de l'usage attendu | `RES-007`, rubrique Frontière |
| A2 | Poser que l'ontologie est un ensemble de concepts et de leurs relations | `RES-006` |
| A3 | Déclarer les deux formes du concept, fichier ou entrée d'ontologie | `RES-006` et `RES-007` |
| A4 | Retirer la condition d'amorçage du seuil d'admission | `RES-007` |

**Coût.** Deux définitions, quatre éditions.

**Dépend de.** Rien.

**A4 mérite une note.** La réponse Q1 ne dit pas de retirer cette condition. Elle la rend caduque en déplaçant le critère : un concept se juge à son usage **attendu**, ce qui est prospectif, alors que la condition exige un usage **attesté**. C'est une déduction de l'agent, signalée dans `ANL-007` C3.

### Chantier B - Instruire la question technique

`ISU-001` est ouverte, à la demande explicite de la réponse Q1.

| Étape | Action |
|---|---|
| B1 | Trancher entre les quatre pistes de `ISU-001` |
| B2 | Décider si une ressource imbriquée est une ressource de plein droit ou une entrée |
| B3 | Fixer la forme de l'adresse |
| B4 | Implémenter la résolution dans `clia res show` et le décompte dans `clia res ls` |

**Dépend de.** Une décision humaine sur B1 et B2.

**Coût de B4.** Trois points de l'outillage couplent l'identité au fichier : `res ls` compte des fichiers, `res show` résout vers un chemin, `res new` crée un fichier.

**Ce que le dépôt possède déjà.** Le mécanisme du recueil de faits, en usage dans `FCT-001` avec dix entrées adressées `FCT-001#F<NN>`. Il fonctionne et ne donne pas de frontmatter à l'entrée.

### Chantier C - Sortir le vocabulaire de relations de RES-001

**En attente de la réponse Q2.**

Neuf relations sont employées par trente-et-une définitions, et définies dans `RES-001` par défaut. C'est une source parallèle, exactement le défaut que le modèle prétend éviter.

| Option | Ce qu'elle demande |
|---|---|
| Produire `ONT-001` | La première instance d'un type qui n'en a aucune |
| Laisser dans `RES-001`, en le datant comme provisoire | Une ligne |
| Renoncer aux relations typées | Réécrire 31 définitions |

**Recommandation de l'agent.** Produire `ONT-001`. Le vocabulaire existe, il est stable depuis trois jours, et il tient en neuf entrées.

### Chantier D - La forme légère de savoir

**En attente de la réponse Q3.**

C'est le manque au coût mesuré le plus élevé : onze dépôts de technotes morts, dont six sans aucun fichier versionné, parce que le seul contenant disponible demandait dix pages pour deux commandes.

| Option | Ce qu'elle demande |
|---|---|
| Un type `NOT` | Une définition, un gabarit, deux schémas |
| Une entrée d'ontologie enrichie | Dépend du chantier B |
| Un recueil par domaine, sur le modèle de `RES-005` | Une définition |
| Aucune, le savoir léger reste hors du modèle | Rien, et le manque subsiste |

**Ce que la troisième option a pour elle.** Le mécanisme du recueil est le seul du dépôt qui soit éprouvé pour l'atomique, et il ne demande aucun outil nouveau.

### Chantier E - Les concepts orphelins

**En attente de la réponse Q4.**

Sept concepts perdus en douze mois. Trois sont critiques parce que le système en dépend.

| Concept | État au 2026-08-11 |
|---|---|
| `extreme-smart` | **Employé par douze documents actifs**, dont `PDC-003` |
| `objection sociocratique` | Employé, le dispositif d'objection repose dessus |
| `distillation` | Non employé |

`extreme-smart` satisfait désormais le seuil d'admission de `RES-007`, sans qu'aucune décision ne l'ait voulu. Il est le candidat naturel au premier `CPT` du dépôt.

**Coût.** Un document d'une à trois pages par concept écrit.

### Chantier F - L'affirmation de INTENTION.md

**En attente de la réponse Q7, et hors de portée de l'agent.**

`INTENTION.md` affirme que `clia` fournit nativement des capacités de mobilisation et d'utilisation du savoir. `ANL-001` établit que rien dans le corpus ne le soutient.

Le fichier est en édition humaine exclusive. L'agent ne peut ni le modifier, ni trancher.

Trois positions, énoncées par l'objection : maintenir et produire le mécanisme qui le justifie, reformuler comme intention à atteindre, ou retirer.

## Livrables attendus

| Chantier | Livrable | Nature |
|---|---|---|
| A | `RES-006`, `RES-007` | Modification |
| B | Une décision sur l'imbrication, puis `lib/clia/resource.sh` | Création, modification |
| C | `ONT-001`, ou une ligne dans `RES-001` | Création ou modification |
| D | Une définition de type, ou rien | Création |
| E | Un à trois `CPT` | Création |
| F | `INTENTION.md` | Modification, par l'humain seul |

## Ordre d'exécution

```
A, sans dépendance, exécutable immédiatement

B1, B2 (décision humaine) ──> B3 ──> B4
C (réponse Q2) ──> [ONT-001] ──> D, si l'option ontologie est retenue
D (réponse Q3)
E (réponse Q4)
F (réponse Q7, humain seul)
```

**Un seul chantier est exécutable en l'état.** Le chantier A, qui dérive de la seule réponse reçue.

**Deux points d'arrêt.**

Avant B3 : la nature de la ressource imbriquée appartient à l'humain.

Avant C, D, E et F : quatre réponses manquent.

## Objections de l'agent

**`NON-004` n'est pas levée, et ce plan ne la lève pas.** L'objection déclare qu'une réponse à Q2 et Q3 la lèverait. Les deux sont vides. L'effet `conditionnel` demeure.

**Le chantier A repose en partie sur une déduction.** A4 retire une condition que la réponse ne demande pas de retirer. La déduction est signalée, et elle peut être refusée sans que le reste du chantier tombe.

**Le chantier D traite le manque le plus mesuré du corpus, et il attend.** Six dépôts de technotes sans aucun fichier versionné est le chiffre le plus lourd que `ANL-001` produise sur le savoir. Rien ne bouge tant que Q3 est vide.

**Ce plan est le quatrième non exécuté.** `PLN-001` attend depuis le 2026-08-09, `PLN-003` depuis hier, et le chantier R2 de `ANL-005` depuis la tâche 16.

**Le premier `CPT` du dépôt existe par accident.** `extreme-smart` satisfait le seuil d'admission parce que les tâches 23 et 24 l'ont employé, non parce qu'une décision l'a voulu. C'est un effet de bord, et le signaler vaut mieux que le présenter comme un résultat.

## Relations

- `derive-de` [ANL-007](../analyses/ANL-007-interpretation-des-reponses-a-non-004.md)
- `est-remplacee-par` [PLN-005](PLN-005-ajustement-au-savoir-relationnel.md)
- `reference` [RES-006](../ressources/RES-006-ontologie.md)
- `reference` [RES-007](../ressources/RES-007-concept.md)
- `reference` [PLN-003](PLN-003-mise-en-conformite-avec-dcn-013.md)
