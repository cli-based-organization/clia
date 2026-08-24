# Demande interprétée, tâche 35

Écrit avant toute exploration. `MET-003` étape 1.

## Ce que l'humain demande, mot pour mot

```sh
clia session|ses|s  [--help|-h]  # affiche l'aide
clia ses status   # état de la session en cours, # taches, # taches faites, temps depuis l'ouverture
clia ses ls       # liste les sessions (fermées, ouverte, en planification)
clia ses new DESCIPTION   # nouvelle session. ferme la session ouverte. ouvre celle-ci
clia ses close    # ferme la session
clia ses todo DESCRIPTION  # ouvre session dans état todo
```

Cycle de vie : `todo => open => closed`.

Sections : 1. INTENTION, 2. CONTEXTE, 3. LIVRABLES, 4. TÂCHES.

## L'intention derrière

**Que la session cesse d'être un fichier tenu à la main.** `workspace/session.md` porte trente-cinq tâches écrites depuis trois jours, et rien ne dit combien sont faites ni depuis quand la session est ouverte. `clia ses status` demande exactement ces trois mesures.

## Ce que la demande contredit

`RES-034` définit déjà la session. Trois écarts, à vérifier :

| Élément | `RES-034` actuel | Demandé |
|---|---|---|
| `etat` | `ouverte`, `close`, `abandonnee` | `todo`, `open`, `closed` |
| Sections | Contexte, Intention, Critère de convergence, Tâches, Relations | INTENTION, CONTEXTE, LIVRABLES, TÂCHES |
| Ordre | Contexte d'abord | Intention d'abord |

**La demande de l'humain prévaut.** `CONSTITUTION.md` C3 et `DCN-013` : l'humain est l'autorité. `RES-034` a été rédigée par l'agent.

**Le critère de convergence disparaît, `LIVRABLES` apparaît.** À vérifier : le critère de convergence est nommé dans `workspace/session.md` et dans `ADR-005`. Sa disparition n'est peut-être pas voulue.

## Ce qui est à décider et que la demande ne dit pas

**Où vivent les sessions.** Aucune instance `SES-*` n'existe dans le dépôt ; seul le répertoire de journal `SES-001-*` porte ce nom.

**Ce que `status` lit.** Le fichier de session, le répertoire de journal, ou les deux.

**Ce que devient `workspace/session.md`.** C'est le point d'entrée déclaré par `CLAUDE.md`, et il est en régime d'édition humaine.

## Le livrable

Le module `lib/clia/session.sh`, son branchement, ses tests, et la révision de `RES-034`.

## Conformité

Tâche 35 de `workspace/session.md`, qui est le seul point d'entrée admis.

**Une garde s'applique.** `close` et `new` écrivent dans un fichier de régime humain. Question à trancher à l'analyse.
