# Ce qui a été fait, tâche 32

`MET-003` étape 3.

## La mesure qui établit le bogue

| Mesure | Valeur |
|---|---|
| Instances du dépôt | 154 |
| Portant `status: draft` | **154** |
| Portant une autre valeur | **0** |

**Le champ a une seule valeur dans tout le dépôt.** Afficher une colonne dont toutes les cases sont identiques revient à ne rien afficher.

L'illustration est immédiate.

```
$ clia res ls issue
ID       DESCRIPTION                                        STATUS
ISU-001  Définir une ressource dans un document ressource   draft
ISU-002  Aucun générateur de ressources dérivées n'existe   draft
ISU-003  Le cycle de vie collectif n'est pas modélisable    draft
```

Les neuf issues portent un champ `etat` valant `ouverte` ou `close`. Aucune ne le montre.

## Ce qui existe et n'est pas affiché

Huit types portent un champ d'état propre, et **cent seize instances en portent un**.

| Type | Champ | Instances |
|---|---|---|
| `ressource` | `statut` | 36 |
| `objection` | `etat`, `effet` | 33 |
| `adr` | `statut-decision` | 17 |
| `decision` | `effet` | 14 |
| `issue` | `etat` | 7 |
| `plan` | `statut-plan` | 6 |
| `fragment` | `exploitation` | 2 |
| `registre` | `tenue` | 1 |

`clia_resource_ls_instances` lit `status` et rien d'autre.

## Trois défauts, non un

| Réf | Défaut | Où il se corrige |
|---|---|---|
| D1 | Le mauvais champ est affiché | Le CLI, sans toucher aux ressources |
| D2 | 38 instances n'ont aucun champ d'état propre | Leur définition de type |
| D3 | Le champ `status` n'a jamais servi | Le modèle |

**D3 est le plus profond.** Aucune ressource n'est passée à `stable` en trois jours et cent cinquante-quatre instances. Un champ obligatoire à valeur unique n'a pas dérivé : il n'a jamais bougé.

## Les deux livrables demandés

| Réf | Livrable | Ce qu'il porte |
|---|---|---|
| L1 | `ISU-008` | Le bogue, D1 et D3, avec **six pistes** |
| L2 | `ISU-009` | La révision du modèle de frontmatter, D2 et D3, avec **six pistes** |

Plus `NON-035`, qui porte les quatre questions à trancher, effet **bloquant**.

**Pourquoi bloquant.** `PDC-001` pose l'auto-découvrabilité, `RES-012` pose que le non-respect d'un principe est un bogue, et le défaut se propage : cinq types créés depuis le 2026-08-11 héritent tous de `status` obligatoire.

## Le correctif de D1, décrit et non appliqué

**Piste P1 de `ISU-008`.** Afficher le champ d'état propre du type quand la définition en déclare un, et retomber sur `status` sinon. La définition de chaque type porte déjà `champs-obligatoires`, où le champ figure.

**Ce qu'il corrige.** 116 instances sur 154.

**Pourquoi il n'est pas appliqué.** La demande dit « ouvrir un bogue qui contient des **pistes de solutions** ». `RES-031` pose que les pistes ne sont pas des décisions : elles sont notées pour ne pas être redécouvertes.

Il est signalé comme immédiatement implémentable, sans dépendance ni préalable.

## Un type qui manque

« Ouvrir un bogue » suppose un type que le dépôt n'a pas. `PLN-005` chantier D prévoit un registre de bogues, jamais créé.

Les deux livrables sont des `ISU`, dont la rubrique « Pistes » correspond exactement à ce que la demande réclame. La question d'un type propre est signalée.

## Ce qui n'a pas été fait

Le correctif de D1, décrit en piste.

Aucune modification du modèle : `commun.cue` est inchangé, et les cent cinquante-quatre instances aussi.
