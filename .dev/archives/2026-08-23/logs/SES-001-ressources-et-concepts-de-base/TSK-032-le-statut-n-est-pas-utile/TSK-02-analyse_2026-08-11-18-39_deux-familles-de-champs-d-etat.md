# Analyse avant réalisation, tâche 32

`MET-003` étape 2.

## L'hypothèse est confirmée, et mesurée

| Mesure | Valeur |
|---|---|
| Instances du dépôt | 154 |
| Portant `status: draft` | **154** |
| Portant une autre valeur de `status` | **0** |

**Le champ `status` a une seule valeur dans tout le dépôt.** Il ne transporte aucune information : afficher une colonne dont toutes les cases sont identiques revient à ne rien afficher.

## Deux familles de champs d'état coexistent

| Famille | Ce qu'elle dit | Instances |
|---|---|---|
| `status`, universel | La maturité du document : `draft`, `stable`, `deprecated` | 154, toutes à `draft` |
| Champ propre au type | Ce qu'il reste à faire | **116** |

Huit types portent un champ d'état propre.

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

**Trente-huit instances n'ont aucun champ d'état propre** : dix-sept analyses, sept skills, quatre fondations, quatre méthodologies, quatre principes, un fait, et `NON-013` dont le frontmatter est incomplet.

## Le défaut, en une phrase

`clia res ls TYPE` affiche le champ **universel et vide de sens**, alors que soixante-quinze pour cent des instances portent un champ **propre et informatif** qui n'est jamais montré.

Le code le fait explicitement : `clia_resource_ls_instances` lit `status` et rien d'autre.

## Trois défauts distincts, qu'il ne faut pas confondre

**D1. Le mauvais champ est affiché.** Corrigeable dans le CLI, sans toucher aucune ressource.

**D2. Trente-huit instances n'ont aucun état à afficher.** Corrigeable seulement en modifiant leur définition de type, donc leur frontmatter.

**D3. Le champ `status` lui-même n'a jamais servi.** Aucune ressource n'est passée à `stable` en trois jours et cent cinquante-quatre instances. Un champ obligatoire à valeur unique est ce que `ANL-001` mesure comme dérivant : ici il n'a même pas dérivé, il n'a jamais bougé.

**Les deux livrables demandés se répartissent sur ces trois défauts.** Le bogue porte D1 et D3. L'issue sur le modèle de frontmatter porte D2 et D3.

## Ce que D1 rend immédiatement corrigeable

Une piste tient en peu de lignes : afficher le champ d'état propre du type quand la définition en déclare un, et retomber sur `status` sinon.

La définition de chaque type porte déjà `champs-obligatoires`, où le champ d'état figure. Rien à ajouter aux ressources.

**Ce que cela ne règle pas.** Les trente-huit instances sans champ propre continueraient d'afficher `draft`.

## Ce que la demande impose comme portée

« Ouvrir un bogue qui contient des **pistes de solutions**. »

Les pistes sont le livrable. Le correctif ne l'est pas, et `RES-031` pose que les pistes « ne sont pas des décisions » : elles sont notées pour ne pas être redécouvertes.

**Le correctif de D1 sera donc décrit et non appliqué**, et signalé comme immédiatement implémentable.

## Un type qui manque

« Ouvrir un bogue » suppose un type que le dépôt n'a pas. `PLN-005` chantier D prévoit un registre de bogues, jamais créé.

Les deux livrables seront des `ISU`, dont la rubrique « Pistes » correspond exactement à ce que la demande réclame.

La question d'un type propre au bogue est signalée dans l'issue.

## Ce que ce bogue met en cause plus largement

`PDC-001` pose l'auto-découvrabilité : « toute fonction du système doit être découvrable depuis le système lui-même, sans documentation externe ».

Un listage qui n'apprend rien sur l'état viole ce principe. L'humain le dit dans les mêmes termes : « on ne sait pas ce qu'il faut faire sans ouvrir et inspecter tous les fichiers ».

C'est donc un **bogue au sens de `RES-012`** : le non-respect d'un principe de conception.
