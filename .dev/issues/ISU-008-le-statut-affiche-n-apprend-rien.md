---
type: issue
id: ISU-008
title: "Le statut affiché par clia res ls n'apprend rien"
status: draft
initiateur: humain
etat: ouverte
ouverture: 2026-08-11
---

# ISU-008 - Le statut affiché par clia res ls n'apprend rien

> Cent cinquante-quatre instances, cent cinquante-quatre `draft`. La colonne `STATUS` a une seule valeur dans tout le dépôt, alors que soixante-quinze pour cent des instances portent un champ d'état propre qui n'est jamais montré.

## Journal

- 2026-08-11 : ouverte à la demande de l'humain, tâche 32, classée `[bogue]`.

## La problématique

L'humain la formule ainsi : « on ne connaît pas l'état de la ressource, ni l'état du système par rapport à cette ressource. Donc on ne sait pas ce qu'il faut faire sans ouvrir et inspecter tous les fichiers : cela n'est pas acceptable. »

Le cas d'usage attendu est simple. Lister les instances d'un type doit donner trois choses : l'alias pour s'y référer, la description pour savoir de quoi il s'agit, et **un état pour savoir ce qu'il reste à faire**.

Les deux premières fonctionnent. La troisième affiche `draft`, toujours.

### La mesure

| Mesure | Valeur |
|---|---|
| Instances du dépôt | 154 |
| Portant `status: draft` | **154** |
| Portant une autre valeur | **0** |

**Le champ a une seule valeur.** Afficher une colonne dont toutes les cases sont identiques revient à ne rien afficher.

### Ce qui existe et n'est pas montré

Huit types portent un champ d'état propre, et **cent seize instances en portent un**.

| Type | Champ propre | Instances |
|---|---|---|
| `ressource` | `statut` | 36 |
| `objection` | `etat` et `effet` | 33 |
| `adr` | `statut-decision` | 17 |
| `decision` | `effet` | 14 |
| `issue` | `etat` | 7 |
| `plan` | `statut-plan` | 6 |
| `fragment` | `exploitation` | 2 |
| `registre` | `tenue` | 1 |

`clia_resource_ls_instances` lit `status` et rien d'autre.

## Ce qui la rend difficile

**Le défaut n'est pas un.** Trois se superposent, et les confondre produirait un correctif partiel présenté comme complet.

| Réf | Défaut | Où il se corrige |
|---|---|---|
| D1 | Le mauvais champ est affiché | Le CLI, sans toucher aux ressources |
| D2 | 38 instances n'ont aucun champ d'état propre | Leur définition de type, donc leur frontmatter |
| D3 | Le champ `status` n'a jamais servi | Le modèle |

**D2 touche sept types** : analyse (17 instances), skill (7), fondation (4), méthodologie (4), principe (4), fait (1), plus `NON-013` dont le frontmatter est incomplet.

**D3 est le plus profond.** Aucune ressource n'est passée à `stable` en trois jours et cent cinquante-quatre instances. Un champ obligatoire à valeur unique n'a pas dérivé : il n'a jamais bougé.

**L'état d'un type n'est pas l'état d'un autre.** `effet: en-vigueur` et `etat: close` ne se comparent pas. Afficher le champ propre rend la colonne hétérogène entre types, ce qui est acceptable pour un listage par type et ne l'est pas pour un listage global.

## Ce qui a été tenté

**Rien.** Le défaut est constaté pour la première fois.

Deux éléments du dépôt le côtoyaient sans le nommer. `clia res ls` sans argument affiche déjà une colonne du nombre d'instances par type, qui est le seul indicateur d'avancement disponible. Et `NON-022` conteste la charge des champs obligatoires sans relever que l'un d'eux ne sert à rien.

## Pistes

Aucune n'est retenue. `RES-031` : les pistes sont notées pour ne pas être redécouvertes.

**P1. Afficher le champ propre quand il existe.** La définition de chaque type déclare ses `champs-obligatoires`, où le champ d'état figure. Le CLI y lirait le nom du champ à afficher, et retomberait sur `status` sinon.

Corrige D1 seul. Ne demande aucune modification de ressource. **Immédiatement implémentable.**

**P2. Déclarer explicitement le champ d'état dans la définition du type.** Un champ `champ-etat` dans le frontmatter d'une `RES` dirait lequel afficher. Plus net que de le deviner, et ajoute un champ à trente-six définitions.

**P3. Donner un champ d'état aux sept types qui n'en ont pas.** Corrige D2. Ajoute un champ obligatoire à trente-huit instances, ce que `NON-022` conteste par ailleurs.

**P4. Retirer `status` du modèle.** Corrige D3. Le champ est dans `commun.cue`, donc dans les cent cinquante-quatre instances. Le retirer est une migration.

**P5. Redéfinir `status` pour qu'il serve.** Plutôt que la maturité du document, il porterait l'avancement du travail. Un seul champ pour tous les types, comparable entre eux, au prix de perdre la finesse des champs propres.

**P6. Afficher deux colonnes.** `status` et le champ propre. Le plus complet, et il élargit une sortie déjà large.

## Ce qui la clôturerait

Un listage qui donne l'état de travail sans ouvrir les fichiers.

P1 seul y parvient pour cent seize instances sur cent cinquante-quatre. Les trente-huit autres demandent D2, donc `ISU-009`.

## Relations

- `objecte-a` [NON-035](../objections/NON-035-le-champ-status-ne-sert-a-rien.md)
- `reference` [ISU-009](ISU-009-revision-du-modele-de-frontmatter.md)
- `reference` [RES-026](../ressources/RES-026-code.md)
- `reference` [PDC-001](../principes/PDC-001-auto-decouvrabilite.md)
