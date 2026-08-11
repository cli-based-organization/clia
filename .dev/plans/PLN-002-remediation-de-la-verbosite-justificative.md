---
type: plan
id: PLN-002
title: "Remédiation de la verbosité justificative des définitions de type"
status: draft
statut-plan: propose
date: 2026-08-10
initiateur: agent
porte-sur: [skl-001-ressource, RES-001, ressource.template.md]
---

# PLN-002 - Remédiation de la verbosité justificative des définitions de type

> Cinq chantiers pour retirer la justification des trente définitions `RES` et empêcher son retour. Le chantier C exige une décision de l'humain et bloque le chantier D. Ce plan n'est pas exécuté.

## Statut

`propose`. Aucun chantier n'est engagé.

Le diagnostic, les mesures et le correctif sont dans `ANL-004`. Ce plan ordonne l'application du correctif.

## Intention

Ramener les définitions `RES` au registre directif et factuel exigé par la tâche 15.

Cible mesurable : **zéro rubrique méta** dans les trente définitions, contrôlée par V10.

Cible secondaire : la justification retirée est conservée, déplacée vers le type qui la porte.

## Chantiers

### Chantier A - Corriger skl-001

Le harnais qui prescrit le défaut. À faire en premier : tout chantier ultérieur qui écrit une définition sans ce correctif reproduit le défaut.

| Étape | Action | Cible |
|---|---|---|
| A1 | Retirer `Statut de ce document` et `Le problème que ce type résout` du gabarit B3 | `skl-001` lignes 167-168 |
| A2 | Réduire `Points ouverts` à une table de deux colonnes, question et objection | `skl-001` B3 |
| A3 | Corriger la ligne 180, qui déclare non optionnelles des rubriques dont une seule définition sur trente porte le titre | `skl-001` B3 |
| A4 | Ajouter la règle de registre `A6` : directif et factuel, bibliographie numérotée pour les références externes | `skl-001` A3 |
| A5 | Ajouter le contrôle `V10` : aucune rubrique méta | `skl-001` Validation |
| A6 | Aligner le frontmatter du gabarit B3 sur `RES-001`, qui déclare seize champs obligatoires là où B3 en montre quatorze. Manquent `famille` et `sections` | `skl-001` B3 |
| A7 | Corriger `id: RES-<slug>` du gabarit B3, forme abolie par `ADR-007` le 2026-08-09 | `skl-001` B3 ligne 147 |

**Coût.** Un document, sept éditions.

**Défaut connexe.** A7 est indépendant de la verbosité. Le gabarit B3 prescrit une forme d'identifiant abolie, ce qui en fait la troisième trace de la migration de la tâche 13 restée en place, avec les deux régressions de `clia res new` portées par `next-task-14.yaml`.

**Vérification.** `skl-001` B1 et B3 ne se contredisent plus. Le gabarit ne porte que des rubriques descriptives.

### Chantier B - Corriger le gabarit et le champ sections

Le gabarit `.dev/templates/ressource.template.md` porte les huit rubriques que `RES-001` déclare pour ses instances. Une définition produite par `clia res new ressource` reçoit donc la structure d'une instance de `RES-001`, non celle d'une définition.

| Étape | Action |
|---|---|
| B1 | Aligner `ressource.template.md` sur le gabarit B3 corrigé |
| B2 | Ajouter au type `ressource` un champ portant la structure de la définition elle-même, distinct de `sections` qui porte celle des instances |
| B3 | Régénérer `ressource.cue` et `ressource.input.cue` depuis `RES-001` |

**Dépend de.** Chantier A.

**Point à trancher.** B2 ajoute un dix-septième champ obligatoire à `RES-001`. `NON-022` conteste déjà la croissance du nombre de champs sur un autre type. Deux options : un champ obligatoire, ou la structure de la définition portée par `skl-001` seul, sans donnée machine-lisible.

**Coût.** Trois artefacts. Le générateur n'existe pas dans le dépôt : les artefacts sont édités à la main, ce que leur propre en-tête interdit. Dette portée par `next-task-14.yaml`.

### Chantier C - Ouvrir le foyer de la justification

**Bloquant pour le chantier D.** Sans ce chantier, le texte retiré des définitions est perdu ou revient.

`ANL-004` C5 mesure : vingt-neuf types sur trente n'ont aucun `ADR` qui décide leur adoption. Vingt-trois pointent vers `ADR-005`, qui décide le regroupement en familles et non l'adoption.

Deux options, à trancher par l'humain.

| Option | Documents à produire | Ce qui va dedans | Effet sur le champ `adr` |
|---|---|---|---|
| **C-a** | Six `ADR`, un par famille | Le problème que les types de la famille résolvent, les alternatives écartées, le statut de chaque type | Chaque définition pointe vers l'`ADR` de sa famille |
| **C-b** | Un `ADR` unique d'adoption des trente types | Le même contenu, en un document | Les trente pointent vers le même `ADR` |

C-a suit le découpage de `ADR-005` et donne six documents de taille moyenne. C-b donne un document long et un seul point de mise à jour.

**Coût.** Six documents pour C-a, un pour C-b. Le volume à déplacer est d'au moins 3 724 mots, mesure `ANL-004` M1, et davantage si la justification diffuse est extraite.

**Recommandation de l'agent.** C-a. Le découpage par famille existe déjà et un `ADR` unique de trente types serait relu par personne.

### Chantier D - Réécrire les trente définitions

**Dépend de.** Chantiers A et C.

Ordre en trois vagues.

| Vague | Définitions | Nombre | Raison de l'ordre |
|---|---|---|---|
| D1 | `RES-009` | 1 | Épreuve du correctif sur le cas le plus atteint en volume |
| D2 | `RES-001` à `RES-008` | 8 | Les fondamentales, dont dépendent toutes les autres |
| D3 | `RES-010` à `RES-030` | 21 | Le reste, par famille |

**Geste par définition.**

1. Retirer les rubriques méta.
2. Déplacer leur contenu vers l'`ADR` de la famille, sans le réécrire.
3. Convertir `Points ouverts` en table.
4. Retirer les marqueurs de justification du corps, mesure `ANL-004` M2.
5. Renommer les rubriques descriptives selon les titres exacts du gabarit B3 corrigé.
6. Contrôles V1 à V10.

**Arrêt après D1.** L'épreuve sur `RES-009` fixe le coût réel par définition et le taux de réduction atteint. Les vagues D2 et D3 sont engagées après cette mesure.

**Coût estimé.** Trente documents. La réduction attendue est de 20,8 pour cent du volume au minimum, mesure M1, sans compter la justification diffuse.

### Chantier E - Étendre la mesure aux autres familles

Hors de la portée de la tâche 15, qui vise les définitions `RES`.

`ANL-004` déclare le même défaut repéré sans mesure dans les `ADR`, les `MET` et les `NON`. Le chantier applique M1, M2 et M3 à ces trois types et produit le chiffre.

**Dépend de.** Rien. Peut être fait en parallèle.

**Coût.** Une mesure, pas de réécriture.

## Livrables attendus

| Chantier | Livrable | Nature |
|---|---|---|
| A | `skl-001` v suivante | Modification |
| A | `DCN` et `ADR` actant le changement de gabarit | Création |
| B | `ressource.template.md`, `ressource.cue`, `ressource.input.cue` | Modification |
| B | `RES-001`, si B2 est retenu | Modification |
| C | Six `ADR` d'adoption, ou un | Création |
| C | Les trente définitions, champ `adr` corrigé | Modification |
| D | Les trente définitions, corps réécrit | Modification |
| E | Mesure sur `ADR`, `MET`, `NON` | Création, une analyse |

## Ordre d'exécution

```
A ──> B
│
└──> C (décision humaine) ──> D1 ──> [mesure] ──> D2 ──> D3

E, indépendant
```

**Trois points d'arrêt.**

Après A : le harnais ne prescrit plus le défaut.

Avant D : la décision C-a ou C-b appartient à l'humain.

Après D1 : le coût réel par définition est connu.

## Objections de l'agent

**Le correctif retire un contenu qui a une valeur.** Les rubriques `Statut de ce document` portent la date de production et le numéro de la tâche qui a produit chaque définition. Cette information n'existe nulle part ailleurs sous forme structurée. Le chantier C la conserve dans les `ADR`. Si C n'est pas fait, elle est perdue.

**V10 est un contrôle par liste noire.** Il détecte les rubriques nommées. Il ne détecte pas une justification écrite dans une rubrique descriptive. `ANL-004` mesure 146 marqueurs, dont la plupart sont hors des rubriques méta.

**Le champ `adr` des définitions est faux depuis le 2026-08-10.** Vingt-trois définitions pointent vers `ADR-005`, qui ne décide pas leur adoption. Ce défaut est indépendant de la verbosité et sera corrigé par le chantier C. Il n'a fait l'objet d'aucune objection avant ce plan.

**Ce plan ajoute au chantier suspendu.** `PLN-001` est en attente depuis le 2026-08-09. Deux plans non exécutés coexistent désormais.

## Relations

- `derive-de` [ANL-004](../analyses/ANL-004-verbosite-justificative-des-definitions-de-type.md)
- `reference` [RES-001](../ressources/RES-001-ressource.md)
- `reference` [PLN-001](PLN-001-point-d-entree-et-analyse-de-la-demande.md)
- `reference` [NON-005](../objections/NON-005-validation-et-regles-non-tenues.md)
