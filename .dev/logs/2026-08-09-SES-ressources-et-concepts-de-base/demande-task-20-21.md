# Demande interprétée, tâches 20 et 21

## Énoncés

**Tâche 20**, `[bogue]` : « seul les humains peuvent prendre des décisions ».

> Interdire (CONSTITUTION.md) aux agents IA de créer ou de modifier une décision. Les agents IA peuvent faire des recommandations, mais c'est uniquement les humains qui peuvent prendre des décisions. Le cli clia génère un template. L'humain l'édite. L'historique est suivie par git grâce à clia git save. Interdire aux agents IA d'utiliser la commande `clia git save`. Également valide pour les principes de conception : seuls les humains peuvent créer des ressources PDC.

**Tâche 21**, `[traitement des objections]` : prendre en compte les réponses à `NON-002`.

## Ce que la tâche 20 constate

Le classement en `[bogue]` désigne un défaut existant, non une orientation future. Le défaut est mesurable : les dix `DCN` et les deux `PDC` du dépôt ont toutes été rédigées par l'agent, dont quatre au cours des trois dernières tâches.

**Une règle perdue.** La constitution archivée le 2026-08-08 interdisait déjà à l'agent toute opération git. Le refactor l'a archivée, et aucun document actif ne la portait plus. La tâche 19 a construit `clia git save` dans cet intervalle.

## Ce que les réponses à NON-002 changent

Sept réponses de l'humain. Trois sont structurantes.

| Réponse | Ce qu'elle pose |
|---|---|
| Q1 | La notion de type n'est pas le bon concept. Le clivage structurant est **ressource ou non-ressource**. Les skills sont **dérivables et ne font pas autorité** |
| Q6 | La **source de vérité est le fichier `RES`**. `CLAUDE.md` ne porte plus qu'un skill d'interprétation de la demande |
| Q3 | La contestation sur le nombre de types est **rejetée** |

Q2, Q4, Q5 et Q7 sont des ajustements : le type se crée sous le besoin, le frontmatter reste à travailler, le coût de la journalisation est assumé, le critère de trahison devient facultatif.

## Contrainte croisée entre les deux tâches

La tâche 20 interdit à l'agent de créer une `DCN`. Le processus habituel de traitement d'une objection produit une `DCN` qui enregistre les réponses.

**Conduite retenue.** Le gabarit `DCN-011` est produit par `clia res new decision` et laissé à l'humain, avec ses champs `À RENSEIGNER`. Les conséquences sont instruites par `ADR-016`, dont le régime d'édition reste `co-edition`.

C'est la première application de la règle, et elle s'applique au document qui l'aurait enregistrée.

## Ressources livrables

| Livrable | Tâche | Nature |
|---|---|---|
| `CONSTITUTION.md` | 20 | Création, six règles |
| `RES-009`, `RES-012` | 20 | Régime d'édition vers `humain` |
| `RES-016` | 20 | Statut `non-installe` vers `actif` |
| `lib/clia/git.sh` | 20 | Garde C2 sur `save` |
| `skl-003`, `skl-004` | 20 | Règle d'édition humaine |
| `FCT-001` | 20 | Création, relevé de l'existant |
| `NON-024` | 20 | Création, sort des douze instances |
| `ADR-016` | 21 | Création, huit décisions |
| `RES-003`, `RES-018` | 21 | Champ facultatif, régime `ia` |
| `NON-002` | 21 | Passage à `repondue` |
| `NON-025` | 21 | Création, ce que D3 laisse ouvert |
| `DCN-011` | 21 | Gabarit, laissé à l'humain |

## Ordre

La tâche 20 d'abord : elle fixe qui a le droit d'écrire quoi, donc elle conditionne la manière dont la tâche 21 est traitée.
