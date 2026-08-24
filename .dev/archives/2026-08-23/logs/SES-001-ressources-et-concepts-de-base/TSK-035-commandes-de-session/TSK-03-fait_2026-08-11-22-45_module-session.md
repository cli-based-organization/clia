# Ce qui a été fait, tâche 35

`MET-003` étape 3.

## Les six formes demandées, et rien de plus

| Commande | Ce qu'elle fait | Qui peut |
|---|---|---|
| `clia ses --help` | L'aide, et l'aide de chaque verbe | tous |
| `clia ses status` | Tâches, avancement, durée | tous |
| `clia ses ls` | Toutes les sessions, quel que soit l'état | tous |
| `clia ses new DESCRIPTION` | Ferme l'ouverte, ouvre la neuve | **humain** |
| `clia ses close` | Ferme l'ouverte | **humain** |
| `clia ses todo DESCRIPTION` | Crée en planification | **humain** |

Aucun verbe non demandé n'a été ajouté.

## Ce que la commande dit du dépôt aujourd'hui

```
session           (vivant)
titre             ressources et concepts de base
etat              open
taches            35
taches faites     32
taches restantes  3
ouverture         2026-08-09T20:00:24-04:00
depuis            2 j 2 h
```

**C'est la première mesure de l'avancement de cette session.** Les trois tâches restantes sont la 1, la 26 et la 35.

## Trois décisions que le code a dû prendre

### Ce qui compte une tâche faite

Le journal porte `TSK-07-commit-message`, septième et dernière étape de `MET-003`.

**Trois critères ont été pesés.** Une marque dans l'énoncé : aucune tâche n'en porte, et l'énoncé est de régime humain. Un répertoire de journal existe : trop faible, il est créé à l'étape 1 avant tout travail. Le message de commit : retenu.

**Le critère ne dit pas qu'une tâche est bien faite.** Il dit qu'elle est journalisée jusqu'au bout, ce qui est vérifiable.

### Deux journaux pour une session

Le dépôt porte `2026-08-09-SES-<slug>` **et** `SES-001-<slug>`, séquelle du renommage du 2026-08-11. Les tâches 1 à 24 sont dans le premier, sous un format plat antérieur à `MET-003`.

**Ne lire que le plus récent affichait huit tâches faites sur trente-trois.** Vingt-cinq l'étaient. Le module lit donc tous les répertoires de journal quand la session est le fichier vivant, et reconnaît la forme plate `commit-message-task-20-21.yaml`, qui couvre deux tâches à la fois.

**C'est de la dette, et elle est déclarée comme telle** dans le code et dans `NON-037`.

### Le point après le numéro est facultatif

`## 32 [bogue] ...` et `## 35 [implémentation] ...` s'écrivent sans point dans le fichier vivant. Une première version stricte les ratait, et comptait trente-trois tâches sur trente-cinq.

**Le défaut a été trouvé en confrontant le chiffre au fichier**, non par un test.

## Ce qui distingue une rubrique d'une tâche

Le **niveau de titre**, et rien d'autre.

| Forme | Ce que c'est |
|---|---|
| `# 1. INTENTION` | Une rubrique de session |
| `## 12. [bogue] ...` | Une tâche |

C'est la forme du fichier vivant et celle des quatre sessions archivées. Une première version du gabarit mettait les rubriques en niveau deux : les quatre rubriques auraient été comptées comme des tâches.

## La garde

`new`, `close` et `todo` refusent de s'exécuter pour un agent, code 3.

**Le mécanisme n'est pas neuf** : c'est celui de `clia git save`, déplacé de `git.sh` vers `core.sh` pour servir aux deux. Une garde dupliquée est une garde qui divergera. L'ancien nom reste valide, et les six tests de `git save` passent inchangés.

## RES-034 révisée

| Élément | Avant | Après |
|---|---|---|
| `etat` | `ouverte`, `close`, `abandonnee` | `todo`, `open`, `closed` |
| Sections | Contexte, Intention, Critère de convergence, Tâches, Relations | INTENTION, CONTEXTE, LIVRABLES, TÂCHES |
| Ordre | Contexte d'abord | Intention d'abord |

**L'ordre demandé est celui des quatre sessions archivées.** Leur frontmatter porte `start-at` et `end-at`, et leurs rubriques sont Intention, Contexte, Tâches. La définition avait dévié sans motif écrit ; la demande la ramène.

`session.cue`, `session.input.cue` et `session.template.md` suivent. `session.input.cue` ne déclarait ni `ouverture` ni `etat`, que le gabarit employait : corrigé au passage.

## Livrables

| Fichier | Nature |
|---|---|
| `lib/clia/session.sh` | Création, 500 lignes |
| `lib/clia/core.sh` | Garde partagée |
| `lib/clia/git.sh` | La garde devient un renvoi |
| `bin/clia` | Dispatch et aide |
| `RES-034` | Révision |
| `session.cue`, `session.input.cue`, `session.template.md` | Révision |
| `tests/test_clia.sh` | **43 assertions**, 144 → 187 |
| `NON-037` | Création, 5 questions |

## Ce qui n'a pas été fait, et pourquoi

**L'énoncé de la session en cours.** `SES-001.md` reprendrait le contenu de `workspace/session.md`, document de régime humain, et l'ouverture d'une session est un acte de l'humain par la garde même que cette tâche pose. `NON-037` Q4.

**Le lien symbolique de `workspace/session.md`.** C'est la forme qui supprimerait tout repli, et elle touche le point d'entrée déclaré par `CLAUDE.md`. `NON-037` Q5.

**Le critère de convergence n'a pas été conservé d'office.** La demande ne le nomme pas ; `ADR-002` si. L'agent applique la demande et pose la question plutôt que de trancher à la place de l'humain. `NON-037` Q1.
