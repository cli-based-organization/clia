---
type: plan
id: PLN-007
title: "Mise en oeuvre des quatre champs d'état"
status: draft
statut-plan: propose
date: 2026-08-11
initiateur: agent
sert: [FNC-001]  # changerait ce que clia res ls affiche
porte-sur: [RES-001, DCN-016, lib/clia/resource.sh]
---

# PLN-007 - Mise en oeuvre des quatre champs d'état

> Sept chantiers, chacun à livrable unique, critère exécutable et **limite de temps déclarée**. C'est le premier plan du dépôt à satisfaire les trois contrôles de `PDC-003`. Deux chantiers sont bloqués et sortis du plan.

## Statut

`propose`. Aucun chantier n'est engagé.

Les mesures sont dans `NON-035` et `DCN-016`.

**Limite de temps globale : douze heures**, réparties par chantier. C'est la timebox du modèle extrême SMART d'origine, reprise par `PDC-003` E3.

**Les durées sont des estimations déclarées comme telles.** Le dépôt n'a mesuré la durée d'aucun chantier ; aucune base ne permet de les fonder.

## Intention

Remplacer les champs d'état du modèle par les quatre champs que `DCN-016` déclare.

Cible mesurable : `clia res ls TYPE` affiche un état qui varie d'une instance à l'autre.

## Chantiers

### Chantier A - Déclarer les quatre champs dans RES-001

| Élément | Valeur |
|---|---|
| **Livrable** | `RES-001`, section « Frontmatter » |
| **Critère de réussite** | `RES-001` déclare les quatre champs, leurs valeurs, et lequel est propre au type |
| **Limite de temps** | 1 heure |
| **Dépend de** | rien |

**Contrôle exécutable.** `grep -c 'maturity\|adoption\|activated\|domain-status' RES-001` retourne au moins 4.

### Chantier B - Porter les quatre champs dans commun.cue

| Élément | Valeur |
|---|---|
| **Livrable** | `.dev/schemas/commun.cue` |
| **Critère de réussite** | `cue vet` passe, et un frontmatter sans les quatre champs échoue |
| **Limite de temps** | 1 heure |
| **Dépend de** | A |

**Contrôle exécutable.** Valider un frontmatter d'essai amputé d'un champ : `cue vet` doit refuser.

**Point à trancher avant B.** Le sort de `status`, que `DCN-016` laisse ouvert. Si `status` est préservé, `commun.cue` porte cinq champs d'état ; sinon quatre.

### Chantier C - Déclarer les valeurs de domain-status dans les trente-six définitions

| Élément | Valeur |
|---|---|
| **Livrable** | Les 36 fichiers `RES-*` |
| **Critère de réussite** | Chaque définition déclare l'énumération de son `domain-status`, ou déclare n'en avoir aucune |
| **Limite de temps** | 3 heures |
| **Dépend de** | A |

**Ce que le chantier reprend.** Les valeurs existent déjà pour huit types : `effet` de la décision, `etat` de l'objection et de l'issue, `statut-plan`, `statut-decision`, `statut` de la définition, `exploitation`, `tenue`. Elles sont reportées, non réinventées.

**Ce qu'il crée.** Les valeurs des sept types qui n'en ont aucune : analyse, skill, fondation, méthodologie, principe, fait, comportement attendu.

### Chantier D - Poser les quatre champs sur les cent cinquante-sept instances

| Élément | Valeur |
|---|---|
| **Livrable** | Les 157 instances |
| **Critère de réussite** | `cue vet` passe sur les 157, et `domain-status` reprend la valeur du champ supprimé |
| **Limite de temps** | 4 heures |
| **Dépend de** | B, C |

**Ce qui est mécanique.** `domain-status` reprend la valeur du champ propre existant, pour les 119 instances qui en ont un.

**Ce qui ne l'est pas.** `maturity` et `adoption` demandent un jugement par instance, et `activated` aussi.

**Ce que le chantier ne peut pas décider.** La valeur d'`adoption` pour les dix-sept `DCN` et `PDC` que `FCT-001` relève comme rédigés par l'agent et non approuvés. Elle vaut `propose` par constat, et `NON-024` conteste cet état.

### Chantier E - Supprimer les cent cinquante-quatre champs d'état anciens

| Élément | Valeur |
|---|---|
| **Livrable** | Les 157 instances et les 62 schémas |
| **Critère de réussite** | `grep -c 'effet:\|etat:\|statut:' ` sur le dépôt actif retourne 0 |
| **Limite de temps** | 2 heures |
| **Dépend de** | D |

**Ordre impératif.** La suppression suit la pose, jamais l'inverse : supprimer d'abord perdrait les valeurs que `domain-status` doit reprendre.

**Ce qui rend le chantier risqué.** `ANL-005` T1 : un renommage accompagné d'une réécriture coupe l'historique. Ici les deux gestes portent sur le même fichier, et le contrôle T1 ne les détecte pas, parce qu'aucun fichier n'est renommé.

### Chantier F - Afficher le bon champ dans le CLI

| Élément | Valeur |
|---|---|
| **Livrable** | `lib/clia/resource.sh` |
| **Critère de réussite** | `clia res ls objection` affiche des valeurs différentes selon l'instance |
| **Limite de temps** | 1 heure |
| **Dépend de** | D |

**Ce que le chantier corrige.** `ISU-008` D1. C'est le seul chantier dont le résultat est visible par l'utilisateur.

**Ce qu'il affiche.** Le choix entre les quatre champs n'est pas décidé par `DCN-016`. Le plus utile pour « savoir ce qu'il reste à faire » est `domain-status`, et `activated` le complète.

### Chantier G - Ajouter le contrôle de valeur unique

| Élément | Valeur |
|---|---|
| **Livrable** | Un contrôle, dans `clia validate` ou dans le script de validation |
| **Critère de réussite** | Le contrôle signale un champ obligatoire dont toutes les instances portent la même valeur |
| **Limite de temps** | 1 heure |
| **Dépend de** | rien |

**Ce que le chantier évite.** Que le défaut se reproduise. `status` a valu `draft` pendant trois jours et cent cinquante-sept instances sans que rien ne le signale.

## Ce qui est sorti du plan

Deux chantiers ne satisfont pas `PDC-003` et vivent ailleurs.

| Chantier écarté | Motif | Où il vit |
|---|---|---|
| Trancher le sort de `status` | Préalable non vérifiable : deux sources se contredisent et OKF n'est pas consultable | `ISU-009` |
| Trancher la langue et le nom du quatrième champ | `status-metier` en Q1, `domain-status` en Q3, et trois champs anglais dans un frontmatter français | `ISU-009` |

`MET-004` étape 6 : ne pas implémenter un livrable dont le préalable est ouvert, même s'il est SMART.

## Livrables attendus

| Chantier | Livrable | Durée |
|---|---|---|
| A | `RES-001` | 1 h |
| B | `commun.cue` | 1 h |
| C | 36 définitions | 3 h |
| D | 157 instances | 4 h |
| E | 157 instances, 62 schémas | 2 h |
| F | `lib/clia/resource.sh` | 1 h |
| G | Un contrôle | 1 h |
| | **Total** | **13 h** |

**Le total dépasse la limite de douze heures.** Le chantier G est indépendant et peut sortir : le plan tient alors en douze heures.

C'est exactement ce que `PDC-003` E3 prescrit : « une planification qui dépasse sa limite ne s'étend pas : elle se scinde ».

## Ordre d'exécution

```
A ──> B ──> D ──> E
│           │
└──> C ─────┘     D ──> F

G, indépendant, hors timebox
```

**Un point d'arrêt.** Avant B : le sort de `status` doit être tranché, sinon `commun.cue` est à refaire.

## Objections de l'agent

**Ce plan est le premier du dépôt à déclarer une limite de temps, et elle n'est fondée sur rien.** Les sept durées sont des estimations. Le dépôt n'a mesuré la durée d'aucun chantier, et `PDC-003` V-S3 exige une déclaration, non une justification.

**Le chantier D demande un jugement sur cent cinquante-sept instances.** Décider si `ADR-008` est `mature` ou en `conception` n'est pas mécanique, et rien ne dit qui en juge.

**Le chantier E est irréversible et mal protégé.** `ANL-005` T1 détecte un renommage accompagné d'une réécriture ; ici rien n'est renommé, donc le contrôle ne s'applique pas. Une erreur de reprise perdrait les valeurs des huit champs supprimés.

**`adoption` fait constater par l'agent ce que `NON-024` conteste.** Dix-sept ressources d'autorité valent `propose` parce que l'agent les a rédigées. Poser cette valeur est un constat, et il touche des documents que `CONSTITUTION.md` C1 lui interdit de modifier.

**Le plan applique une décision suspendue.** `DCN-016` porte `effet: suspendue` : c'est un premier jet d'agent en attente d'approbation. Exécuter ce plan avant l'approbation reviendrait à appliquer une décision qui n'en est pas une.

## Relations

- `derive-de` [DCN-016](../decisions/DCN-016-quatre-champs-d-etat-pour-toute-ressource.md)
- `repond-a` [NON-035](../objections/NON-035-le-champ-status-ne-sert-a-rien.md)
- `reference` [ISU-008](../issues/ISU-008-le-statut-affiche-n-apprend-rien.md)
- `reference` [ISU-009](../issues/ISU-009-revision-du-modele-de-frontmatter.md)
