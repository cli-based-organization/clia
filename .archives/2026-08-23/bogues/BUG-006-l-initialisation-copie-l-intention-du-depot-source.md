---
type: bogue
id: BUG-006
title: "L'initialisation copie l'intention du dépôt source"
status: draft
maturity: conception
adoption: propose
activated: true
domain-status: "ouvert"
regle: "Un dépôt instrumenté déclare sa propre intention, et reçoit les harnais que clia prescrit"
constate-le: 2026-08-13
etat: ouvert
---

# BUG-006 - L'initialisation copie l'intention du dépôt source

> `clia setup init` copie `INTENTION.md` depuis le dépôt source. Un dépôt neuf hérite donc de l'intention de `clia`, mot pour mot, et rien ne le signale. Deux harnais manquent par ailleurs à la liste.

## Journal

- 2026-08-13 : rapporté par l'humain, tâche 15 de `SES-002`, après l'initialisation de `~/git/cli-based-organization/clia-repos`.

**L'énoncé du rapport** :

> - Il n'y a pas de harnais IA CONSTITUTION.md
> - Le fichier INTENTION.md a été peuplé avec le fichier intention du repo clia

## L'écart

**Le comportement attendu.** Un dépôt instrumenté déclare sa propre intention, et reçoit les harnais que `clia` prescrit.

**Le comportement constaté**, mesuré sur le dépôt réel :

| Mesure | Résultat |
|---|---|
| `CONSTITUTION.md` présent | **Non** |
| `ARCHITECTURE.md` présent | **Non** |
| `diff INTENTION.md` contre celui de `clia` | **Vide : les deux fichiers sont identiques** |
| `diff CLAUDE.md` contre celui de `clia` | **Vide** — même défaut, non relevé par l'humain |
| `INTENTION.md` est un lien | Non, fichier réel, date du 2026-08-09 préservée |
| `.dev/intentions/` existe | **Non** |

**Le dépôt neuf contient quatre entrées** : `CLAUDE.md`, `INTENTION.md`, `.dev/`, `workspace/`.

## La règle enfreinte

**Un dépôt instrumenté déclare sa propre intention, et reçoit les harnais que `clia` prescrit.**

Elle n'était écrite nulle part. `SPC-001` fixe la conformité d'un dépôt `clia` ; elle ne dit pas ce qu'un harnais doit contenir, ni qu'une intention est propre au dépôt.

## Comment le reproduire

1. `clia setup init CIBLE` sur un dépôt neuf.
2. `diff CIBLE/INTENTION.md INTENTION.md` depuis le dépôt `clia`.
3. Constater que la sortie est vide.

**Reproduit une fois**, sur `clia-repos`.

## La cause

**`clia_setup_poser` copie le fichier du dépôt source**, et `clia_setup_fichiers_harnais` n'en déclare que deux.

```sh
cp -p "$source" "$cible"
```

**Le mécanisme ne distingue pas un harnais d'un contenu.** `CLAUDE.md` décrit un mode opératoire : le copier se défend. `INTENTION.md` porte ce que le dépôt veut accomplir : aucun dépôt ne partage l'intention d'un autre.

**Le régime lié aggraverait le cas.** En `--dev`, la fonction pose un lien symbolique vers le dépôt source : le dépôt neuf pointerait sur l'intention de `clia`, et la modifier modifierait `clia`.

**Deux harnais manquent simplement à la liste** : `CONSTITUTION.md` et `ARCHITECTURE.md`.

## La correction

**Non appliquée.** La tâche 15 est un plan de rémédiation : elle produit `PLN-017`, elle ne l'exécute pas — `MET-005` étape 1.

Ce que le plan porte, dans les termes de l'humain :

| Ce qu'il faut | Chantier de `PLN-017` |
|---|---|
| Les harnais viennent d'un YAML et d'un gabarit | A, B |
| Fournir une constitution | B |
| `ARCHITECTURE.md` optionnel | B |
| `INTENTION.md` → lien vers `.dev/intentions/INT-001.md` | C |
| `INTENTION.md` est un gabarit vide | C |
| Un `INTENTION.md` existant est déplacé puis lié | D |

**Le bogue reste ouvert** jusqu'à ce qu'un `clia setup init` sur un dépôt neuf produise une intention vide et une constitution.

## Relations

- `porte-sur` [PLN-009](../plans/PLN-009-commandes-d-installation-et-d-instrumentation.md)
- `reference` [PLN-017](../plans/PLN-017-harnais-generes-et-intention-par-ressource.md)
- `reference` [SPC-001](../specs/SPC-001-conformite-d-un-depot-clia.md)
- `reference` [RES-003](../ressources/RES-003-intention.md)
