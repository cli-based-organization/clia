---
type: ressource
id: RES-032
title: "Log"
status: draft
maturity: conception
adoption: propose
activated: true
domain-status: "actif"
version: 0.1.0
prefixe: LOG
emplacement: ".dev/logs/SES-<SEQ>-<SLUG>/TSK-<SEQ>-<SLUG>/TSK-<SEQ_TYPE>-<TYPE_LOG>_<YYYY-MM-DD-HH-MM>_<SLUG>.md"
cycle-de-vie: point-fixe
edition: ia
famille: contenu
champs-obligatoires: [type, id, title, status, tache, type-log, ecrit-le]
relations-admissibles: [log, ressource, analyse, objection, decision]
sections: [Relations]
skill: skl-004-ressource-de-contenu
adr: ADR-010
statut: actif
---

# RES-032 - Log

> Un log est une information de journal, écrite **au moment où le travail qu'elle rapporte est fait**. Il constate, il ne reconstruit pas.

## Objet

Ce document définit le type `log`. Sa fonction est de rendre le travail de l'agent traçable et relisible, ce que `ADR-016` D8 déclare comme une caractéristique centrale du système.

## Ce qu'est un log

Une information de journal, d'un type déclaré, produite pendant une tâche et rattachée à elle.

Sept types de log existent, et leur numéro est **fixe pour toutes les tâches**.

| `SEQ` | Type | Quand il s'écrit |
|---|---|---|
| 01 | `demande` | Avant tout travail, à la lecture de la tâche |
| 02 | `analyse` | Avant de produire, après avoir établi le contexte |
| 03 | `fait` | Pendant, à mesure que chaque livrable est produit |
| 04 | `validation` | Avant de valider, la démarche prévue |
| 05 | `resultat-validation` | Après exécution des contrôles |
| 06 | `next` | À la clôture |
| 07 | `commit-message` | À la clôture |

Le numéro estime l'ordre de génération. Il n'oblige pas : une tâche peut ne produire que certains types.

## Ce qu'un log n'est pas

| Ce n'est pas | Différence |
|---|---|
| Une **tâche** | La tâche est ce qui est demandé, le log est ce qui a été fait |
| Une **analyse** | L'analyse porte sur un objet extérieur. Le log porte sur le travail lui-même |
| Une **décision** | Un log constate, il n'arrête aucun choix |
| Un **fait** | Un `FCT` porte un énoncé dont la véracité est établie par un processus normé. Un log rapporte ce qui a été fait, sans autre vérification |

## Champs propres

| Champ | Valeurs | Rôle |
|---|---|---|
| `tache` | `TSK-<SEQ>` | La tâche que ce log rapporte |
| `type-log` | `demande`, `analyse`, `fait`, `validation`, `resultat-validation`, `next`, `commit-message` | Le type d'information |
| `ecrit-le` | Horodatage `YYYY-MM-DD HH:MM` | Quand l'information a été écrite |

Le champ `ecrit-le` porte le moment de l'écriture, jamais celui de la clôture de la tâche. C'est ce qui rend la règle d'écriture au fil de l'eau vérifiable par lecture.

## Test d'admission

Un log est produit si les deux conditions sont réunies.

1. Il rapporte un travail **effectivement fait**, au moment où il est fait.
2. Il rattache ce travail à une tâche.

Un log écrit après coup ne satisfait pas la première condition. Il est une reconstruction, et il doit le déclarer.

## Cycle de vie et versionnage

`point-fixe`. Un log constate un moment ; le modifier serait falsifier.

Il ne porte pas de champ `version`. Une correction produit un log nouveau qui déclare `derive-de` vers le précédent.

## Régime d'édition

`ia`. L'agent écrit, l'humain lit et commente.

Un log rapporte le travail de l'agent. L'humain qui le corrige corrige un constat, ce qui est le geste que le cycle `point-fixe` interdit.

## Frontière avec les types voisins

| Voisin | Ce qui départage |
|---|---|
| `TSK` | Ce qui est demandé contre ce qui a été fait |
| `SES` | Le contenant d'une session contre une information d'une tâche |
| `ANL` | Un objet extérieur contre le travail lui-même |
| `FCT` | Une véracité établie contre un constat rapporté |

## Structure attendue d'une instance

La structure dépend du type de log. Aucune rubrique n'est imposée hors `Relations`, qui reste facultative pour un log.

Le nom de fichier porte l'essentiel du contexte.

```
TSK-<SEQ_TYPE>-<TYPE_LOG>_<YYYY-MM-DD-HH-MM>_<SLUG>.md
```

Exemple : `TSK-01-demande_2026-08-11-09-06_systeme-de-journalisation.md`

## Le répertoire de journal, et la chaîne de session

Le répertoire de journal d'une session contient **l'énoncé de cette session** en plus des répertoires de tâches.

```
.dev/logs/SES-<SEQ>-<SLUG>/
    session.md              l'énoncé de la session
    TSK-001-<slug>/         le journal d'une tâche
    TSK-002-<slug>/
```

**L'énoncé se nomme `session.md`, non `SES-<SEQ>.md`.** Le répertoire porte déjà le numéro ; le répéter dans le nom du fichier n'ajoute rien.

### Le point d'entrée est un lien

`workspace/session.md` n'est pas un fichier : c'est un **lien symbolique** vers l'énoncé de la session en cours.

| Ce que le lien permet | Pourquoi cela compte |
|---|---|
| Le point d'entrée ne bouge pas | `CLAUDE.md` en fait le seul point d'entrée des demandes |
| La session change sans que rien d'autre change | Aucun document de harnais n'est à réécrire |
| Les sessions antérieures restent lisibles | Elles ne sont ni déplacées ni archivées |

**Le lien est relatif.** Un lien absolu casse au clone du dépôt, à son déplacement, et dans tout dépôt dont le chemin diffère.

**Le lien fait autorité.** Ce qu'il désigne est la session en cours, même si l'énoncé pointé porte un état autre qu'`open` : `clia ses switch` déplace le lien sans toucher aucun état.

`ADR-017` D3 emploie déjà ce mécanisme pour `INTENTION.md`.

### Ce que les commandes en font

| Commande | Effet sur le lien |
|---|---|
| `clia ses new DESCRIPTION` | Le fait pointer sur l'énoncé neuf |
| `clia ses switch SESSION` | Le fait pointer ailleurs, **et rien d'autre** |
| `clia ses close`, `status`, `ls`, `todo` | Aucun |

La commande refuse d'écraser un `workspace/session.md` qui serait un fichier ordinaire non vide : il porte peut-être le seul exemplaire de son contenu.

## Ressources sources et méthode de génération

| Élément | Valeur |
|---|---|
| Méthode de génération | `MET-003` |
| Ressources sources | La tâche `TSK`, et le travail effectivement produit |

Conformément à `NON-026` Q5, une ressource générée déclare ses sources et sa méthode.


## Cycle de vie métier : `domain-status`

`DCN-016` pose que `domain-status` porte le cycle de vie métier du type, et que chaque définition en déclare l'énumération.

**Aucune.** Ce type n'a pas de cycle de vie métier propre : son état est entièrement décrit par les trois champs universels `maturity`, `adoption` et `activated`.

## Relations

- `reference` [RES-001](RES-001-ressource.md)
- `reference` [RES-033](RES-033-tache.md)
- `reference` [RES-034](RES-034-session.md)

## Points ouverts

| Question | Objection |
|---|---|
| Rien ne vérifie qu'un log a été écrit au moment qu'il déclare | `NON-028` |
| Le préfixe `TSK` du nom de fichier désigne un type de log, non une tâche | `NON-028` |
| Les 116 logs de l'ancien format ne sont pas migrés | `NON-028` |
