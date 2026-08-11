---
type: methodologie
id: MET-003
title: "Journalisation du travail"
version: 0.1.0
status: draft
domaine: "traçabilité du travail de l'agent, au fil de son exécution"
---

# MET-003 - Journalisation du travail

> Comment journaliser une tâche. La règle qui commande toutes les autres : **chaque information est écrite au moment où le travail qu'elle rapporte est fait**, jamais reconstruite à la clôture.

## Objet

Cette méthodologie fixe le procédé de journalisation d'une tâche.

Elle est la ressource source de `RES-032`, qui déclare `MET-003` comme sa méthode de génération.

## Quand l'employer

À chaque tâche, sans seuil. `ADR-016` D8 pose que la traçabilité est une caractéristique centrale du système et que son coût est assumé.

**À ne pas employer** pour un travail qui n'est pas une tâche du fichier de session. Une exploration, une réponse à une question, une vérification ponctuelle ne produisent pas de journal.

## Le procédé

Sept étapes, une par type de log. Chacune porte **son moment d'écriture**, qui est ce que cette méthodologie ajoute à la pratique antérieure.

### 1. `demande`, avant tout travail

Écrit à la lecture de la tâche, avant toute exploration du dépôt.

Porte l'énoncé repris sans reformulation, l'interprétation, les livrables identifiés, et les ambiguïtés relevées.

**Ce qui le rend utile.** Écrit avant, il enregistre ce que l'agent a compris **avant** de savoir si c'était juste. Écrit après, il enregistre ce qu'il aurait dû comprendre.

*Contrôle :* son horodatage précède celui de tous les autres logs de la tâche.

### 2. `analyse`, avant de produire

Écrit après l'exploration, avant le premier livrable.

Porte ce que le contexte a établi, ce qui a été écarté et pourquoi, et les hypothèses qui se sont révélées fausses en chemin.

*Contrôle :* son horodatage précède celui du premier livrable produit.

### 3. `fait`, pendant, à mesure

**C'est l'étape qui change le plus.** Le log de type `fait` n'est pas écrit une fois à la fin : il est **versé** à mesure que les livrables sortent.

Une tâche qui produit trois lots de livrables produit trois versements. Chacun est un fichier distinct, avec son horodatage et son slug.

```
TSK-03-fait_2026-08-11-09-13_trois-definitions.md
TSK-03-fait_2026-08-11-09-31_artefacts-et-methodologie.md
```

*Contrôle :* les horodatages des versements sont distincts et croissants.

### 4. `validation`, avant de valider

Écrit avant l'exécution des contrôles, jamais après.

Porte la démarche prévue, numérotée. Une démarche écrite après les contrôles est une justification des résultats obtenus.

*Contrôle :* son horodatage précède celui de `resultat-validation`.

### 5. `resultat-validation`, après les contrôles

Porte ce que les contrôles ont donné, y compris ce qui a échoué et ce qui n'a pas pu être établi.

*Contrôle :* aucun automatique. Un résultat qui ne rapporte que des succès est suspect.

### 6. `next`, à la clôture

Porte ce qui appartient à l'humain, ce qui est le plus rentable ensuite, et la dette nommée.

### 7. `commit-message`, à la clôture

Porte le message que l'humain emploiera. `clia git save` le lit ; `CONSTITUTION.md` C2 réserve le commit à l'humain.

## Le nommage

Une seule forme, et elle porte le contexte que `D1` exige.

```
.dev/logs/SES-<SEQ>-<SLUG>/TSK-<SEQ>-<SLUG>/TSK-<SEQ_TYPE>-<TYPE_LOG>_<YYYY-MM-DD-HH-MM>_<SLUG>.md
```

| Élément | Ce qu'il porte |
|---|---|
| `SES-<SEQ>-<SLUG>` | La session |
| `TSK-<SEQ>-<SLUG>` | La tâche, un répertoire par tâche |
| `<SEQ_TYPE>` | Le numéro du type de log, **fixe pour toutes les tâches** |
| `<YYYY-MM-DD-HH-MM>` | Le moment de l'écriture, à la minute |
| `<SLUG>` | Ce que ce log rapporte, en trois ou quatre mots |

**Le slug n'est pas décoratif.** C'est ce qui rend `D2` tenable : chercher `grep -rl "artefacts" .dev/logs` doit ramener les logs qui en parlent.

## Deux règles absolues

**R1. Un log ne rapporte qu'une tâche.** Un fichier qui en rapporte deux est un défaut, quelle que soit la proximité des deux tâches.

**R2. Un log ne se réécrit pas.** Le type est `point-fixe`. Une correction produit un log nouveau qui déclare `derive-de` vers celui qu'il corrige.

## Ce qui peut échouer

Six modes d'échec. Les quatre premiers ont été observés dans le journal de la session du 2026-08-09.

**Écrire les sept logs en bloc à la clôture.** Signe : sept horodatages identiques à la minute près. C'est le défaut `D4` que cette méthodologie corrige, et il a été commis sur onze tâches.

**Combiner les logs de plusieurs tâches.** Signe : un nom de fichier portant deux numéros de tâche. Observé trois fois, `fait-task-17-19`, `fait-task-20-21`, `fait-task-23-24`.

**Écrire la démarche de validation après les contrôles.** Signe : une démarche dont chaque étape a un résultat. Une démarche prévue porte des contrôles dont on ne connaît pas encore l'issue.

**Nommer sans dater.** Signe : `demande-task-14.md`. Le nom ne porte ni date, ni heure, ni session.

**Rapporter un travail non fait.** Un log constate. Un log qui décrit une intention est une analyse mal placée.

**Écrire un journal pour un travail qui n'est pas une tâche.** Le coût de la journalisation est assumé pour les tâches, pas pour toute interaction.

## Éprouvé sur

| Cas | Résultat |
|---|---|
| Tâche 25 de la session du 2026-08-09 | **Première application.** Les logs `demande`, `analyse` et le premier versement de `fait` ont été écrits avant, avant, et pendant. Leurs horodatages sont distincts |
| Tâches 14 à 24 | **Contre-exemple mesuré.** Onze tâches dont les sept logs ont été écrits en bloc à la clôture, et trois qui combinent plusieurs tâches |

**Ce que la première application établit.** Le procédé est applicable : écrire la demande avant d'explorer coûte quelques minutes et fixe l'interprétation avant qu'elle soit influencée par ce qu'on trouve.

**Ce qu'elle n'établit pas.** Sa tenue dans la durée. Une tâche courte se journalise facilement au fil de l'eau ; une tâche longue et ramifiée est le vrai test, et il n'a pas eu lieu.

## Relations

- `specifie` [RES-032](../ressources/RES-032-log.md)
- `reference` [RES-033](../ressources/RES-033-tache.md)
- `reference` [RES-034](../ressources/RES-034-session.md)
- `reference` [MET-002](MET-002-enregistrement-et-suivi-d-une-decision.md)
