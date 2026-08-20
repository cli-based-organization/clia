# La demande, tâche 16 de SES-002

`MET-003` étape 1. Écrit avant toute exploration.

## L'énoncé, repris sans reformulation

> ## 16. [impémentation] exécute le plan PLN-017

## Ce que je comprends

Exécuter les quatre chantiers de `PLN-017`, « Harnais générés et intention par ressource ».

Le type `[implémentation]` autorise l'exécution : `MET-005` étape 1. `PLN-017` a été produit par la tâche 15, qui ne l'a pas exécuté — c'est le cas correct que `MET-005` prescrit depuis `BUG-002`.

## Ce que je sais déjà du plan

Quatre chantiers, dépendances en chaîne partielle :

```
A ──> B
A ──> C ──> D
```

| Chantier | Critère, en un mot |
|---|---|
| A. `harnais.yaml` et les gabarits | Les quatre harnais déclarés, `ARCHITECTURE.md` optionnel |
| B. Générer au lieu de copier | `diff` **non vide** contre le dépôt source |
| C. L'intention devient une ressource | Lien relatif vers `.dev/intentions/INT-001-*.md`, cible vide |
| D. Migrer un dépôt existant | Contenu préexistant intact après déplacement |

**Le critère du chantier B est la mesure inverse de l'habitude** : il exige une différence, parce que c'est un `diff` vide qui constitue `BUG-006`.

## Ce que je surveille

**Le chantier B change le régime d'un mécanisme éprouvé.** `clia setup init` a été validé par la tâche 5. Le plan lui-même le déclare en objection : « remplacer la copie par la génération peut casser ce qui marche ; le critère l'éprouve sur un dépôt jetable, non sur un dépôt réel. » Je testerai sur un dépôt jetable avant de toucher quoi que ce soit d'autre.

**Le gabarit de `CONSTITUTION.md` est un document d'autorité.** `CONSTITUTION.md` C1 réserve les décisions à l'humain. Le plan précise que le chantier A produit un **gabarit**, non une constitution en vigueur — je m'y tiens : aucune règle que l'humain n'a pas déjà posée n'y entre.

**Neuf heures déclarées, aucune mesurée.** Je ne cherche pas à les respecter au chronomètre ; c'est une déclaration, pas un engagement, `PDC-003` V-S3.

**`MET-005` étape 6** : la tâche se terminera sur une directive unique, cohérente avec `clia focus`.

## Ce que je ne fais pas

**Reprendre `clia-repos`.** Le plan et sa propre section « Ce qui est écarté » le disent : le chantier D livre le mécanisme, l'appliquer à ce dépôt précis est un geste de l'humain sur son dépôt.

**Générer les skills.** Sorti du plan à la tâche 15, faute de règle de dérivation établie.
