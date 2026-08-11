# Demande interprétée, tâche 14

## Énoncé

Tâche 14 de `workspace/session.md`, classée `[recherche de fondation]` :

> Faire une recherche de fondation (en utilisant MET-001) portant sur la documentation des décisions.
>
> L'objectif de cette recherche est de mieux comprendre les pratiques de documentation des décisions et de suivi des changements décision dans différents domaines et différents contextes.
>
> Afin d'enrichir la ressource DCN introduit à la tâche 8 et, surtout, nos méthodologies de travail avec cette ressource.

## État constaté avant reprise

La tâche avait été engagée puis interrompue. Le constat est fait le 2026-08-10 à la reprise.

| Élément | État |
|---|---|
| `FND-003`, la recherche elle-même | **Produite**, 418 lignes, 32 sources, horodatée 20:30 |
| Journal de la tâche 14 | **Absent**, aucun fichier `*-task-14.*` |
| `RES-009`, la définition du type Décision | **Non enrichie**, horodatée 17:25, soit avant la recherche |
| Méthodologie de travail avec les `DCN` | **Inexistante**, `MET-001` est la seule méthodologie du dépôt |
| `NON-020` et `NON-021` | **Citées par `FND-003`** aux lignes 198 et 327, et **inexistantes** |

La partie recherche est donc faite ; la partie exploitation, qui est l'objet déclaré de la demande, ne l'est pas.

## Intention

L'énoncé porte son propre ordre de priorité, et il est explicite : « afin d'enrichir la ressource DCN et, **surtout**, nos méthodologies de travail avec cette ressource ». La recherche n'est pas le livrable, elle est le moyen. Le livrable est ce qui change dans le travail une fois la recherche faite.

L'intention retenue est donc : **faire descendre les résultats de `FND-003` dans les documents qui commandent le travail quotidien**, et non produire un second document de savoir.

## Contexte

`RES-009` a été écrit à la tâche 8 sans aucun antécédent : `ANL-001` n'avait relevé aucun mécanisme d'enregistrement de décision externe dans les cent soixante-six dépôts observés. Le type est donc le seul du dépôt à avoir été défini sans matériau d'observation. C'est précisément ce que la tâche 14 corrige, avec quinze ans de littérature à la place du corpus manquant.

Le dépôt compte sept `DCN`, toutes internes, toutes en `status: draft`. Aucune n'a encore été remplacée, ce qui signifie que le mécanisme de changement de `RES-009` n'a jamais été éprouvé.

## Ressources livrables

| Livrable | Nature du travail | Fondement dans `FND-003` |
|---|---|---|
| `RES-009` v0.2.0 | Modification | Les sept apports de la section « Ce que cette recherche apporte » |
| `MET-002` | Création | La demande, « surtout nos méthodologies de travail avec cette ressource » |
| `NON-020` | Création | Citée par `FND-003` étape 10, seuil de densité de `MET-001` inatteignable |
| `NON-021` | Création | Citée par `FND-003` étape 6, deux prescriptions de 2011 réinventées |
| `NON-022` | Création | Apport 7, la charge documentaire comme cause d'abandon |
| `FND-003` | Correction | Deux incohérences internes entre l'étape 10 et la section « Limites » |
| Artefacts du type `decision` | Modification | Dérivés de `RES-009`, à réaligner |
| Les sept `DCN` existantes | Migration | Deux champs obligatoires ajoutés |

## Ordre de travail

| Type de livrable | Type de travail | Skill |
|---|---|---|
| `RES` | Modification | `skl-001-ressource`, `skl-002-ressource-fondamentale` |
| `MET` | Création | `skl-003-ressource-de-conception` |
| `NON` | Création | `skl-002-ressource-fondamentale` |
| `FND` | Correction | `skl-003-ressource-de-conception` |
| `DCN` | Migration de frontmatter | `skl-004-ressource-de-contenu` |

## Conformité de la demande

Conforme. La tâche est inscrite au fichier de session, elle est engagée, et la reprise a été confirmée par l'humain le 2026-08-10.

## Ce que la demande ne dit pas

Elle ne dit pas si l'enrichissement de `RES-009` doit préserver la compatibilité des `DCN` déjà écrites. La réponse retenue est non : deux champs obligatoires sont ajoutés et les sept `DCN` sont migrées dans le même mouvement, ce qui est le seul moyen de ne pas laisser un corpus non conforme derrière soi.

Elle ne dit pas combien de méthodologies produire. Une seule est produite, `MET-002`, qui couvre l'enregistrement, le changement et la vérification.
