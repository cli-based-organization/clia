# Ce qui a été fait, tâche 6

## Livrables produits

| Fichier | Lignes | Contenu |
|---|---|---|
| `setup.sh` | 263 | activate, deactivate, check, install, uninstall, help |
| `bin/clia` | 148 | Point d'entrée, résolution de contexte, dispatch, réflexivité |
| `lib/clia/core.sh` | 337 | Contexte-répertoire, configuration, frontmatter, slug, dérivation des types |
| `lib/clia/resource.sh` | 326 | ls, ls TYPE, new, show, edit |
| `lib/clia/config.sh` | 155 | ls, set, edit, path |
| `tests/test_clia.sh` | 367 | 66 assertions, dépôt et configuration temporaires |
| `.dev/objections/NON-012-granularite-de-la-ressource.md` | 91 | 7 questions, effet conditionnel |

1 596 lignes de bash. 66 tests, tous verts. `shellcheck -S warning` ne signale rien.

## Les commandes demandées, toutes implémentées

```
clia resource|res|r ls              types connus du dépôt
clia res ls RESOURCE                instances : ID DESCRIPTION STATUS
clia res new RESOURCE DESCRIPTION   crée, slug dérivé de la description
clia res show ID                    affiche
clia res edit ID                    ouvre avec CLIA_EDITOR

clia configuration|config|c ls      variables, valeurs, origines
clia config set KEY VALUE           assigne CLIA_KEY, avec ou sans le préfixe
clia config edit                    ouvre le fichier de configuration

. setup.sh activate                 active clia dans le shell courant
```

Quatre ajouts de réflexivité, non demandés et conformes aux conventions : `clia --version`, `clia --help`, `clia --context`, `clia config path`. Cinq commandes de `setup.sh` au-delà d'`activate` : `deactivate`, `check`, `install`, `uninstall`, `help`.

## Ce que l'outil applique des décisions écrites

| Décision | Application |
|---|---|
| `ADR-003` D1, déterminisme | Aucune improvisation, aucun appel réseau, aucune écriture hors des chemins déclarés |
| `ADR-003` D2, généricité | Aucun contenu de domaine dans le code. Les types viennent des définitions du dépôt courant |
| `ADR-003` D3, orienté ressources | Grammaire nom puis verbe. Ajouter un type ne demande aucune modification du code |
| `ADR-003` D5, frontière | `res new` crée le fichier, pose le frontmatter, attribue le numéro, et s'arrête |
| `ADR-003` D7, source dérivée | Les types sont lus dans les frontmatter des définitions, à chaque appel, sans fichier intermédiaire |
| `ADR-003` D9, trois publics | Données sur `stdout`, messages sur `stderr`. `res new` n'écrit qu'un chemin sur `stdout` |
| `RES-001`, cycles de vie | Nommage séquencé pour vivant et travail, daté pour point-fixe. Version présente pour les seuls types versionnés |
| `skl-001` règle A5 | `res new` refuse un type sans définition, en expliquant qu'une première instance ferait précédent |

## Le bogue de 2026-07-31 est évité, et testé

`ANL-001` documente qu'une version antérieure de `clia` prenait toujours le même dépôt pour référence, quel que soit le répertoire de lancement.

Le code sépare `CLIA_HOME`, résolu depuis l'emplacement réel du fichier exécuté, de `CLIA_REPO_ROOT_RESOLVED`, résolu à chaque exécution depuis le répertoire courant. Trois tests portent sur cette séparation, dont un vérifie explicitement que `CLIA_HOME` n'est pas pris pour le dépôt courant.

Vérifié à la main depuis un dépôt d'essai hors de `CLIA_HOME` : le contexte affiche les deux racines et signale qu'elles diffèrent.

## Trois bogues trouvés et corrigés par les tests

| Bogue | Symptôme | Cause | Correction |
|---|---|---|---|
| SIGPIPE | `clia res ls objection` échouait sur un type existant, code 141 | Un `awk` sortait au premier résultat, fermant le tube, ce que `pipefail` transforme en échec | L'`awk` lit toute son entrée et n'imprime qu'à la fin |
| Archives comptées | 17 ADR annoncés là où le dépôt en a 3 | Le parcours incluait `.dev/archives/`, qui en contient 14 | Exclusion par défaut, configurable par `CLIA_EXCLUDE_DIRS` |
| Valeur à espace scindée | Deux lignes `harnais` dans le décompte | `type: harnais IA` reformaté après `uniq -c` | Décompte en `awk` sur la ligne entière |

Le même piège d'`awk` a produit le premier bogue et deux faux échecs dans les tests censés le trouver : un bloc `END` qui écrase le code de sortie du bloc précédent.

Une friction d'usage a aussi été corrigée : le type nommé `Faits` ne répondait pas à `fait`. Tolérance du singulier et du pluriel ajoutée, comme `kubectl` répond à `pod` et à `pods`.

## Ce que l'implémentation a révélé du modèle

**Le numéro de séquence n'est pas un identifiant, et c'est désormais prouvé.**

```
$ clia res show 002
clia: identifiant ambigu : 002
      .dev/choses/CHO-002-deuxieme-chose.md
      .dev/ressources/RES-002-traces.md
```

La question Q1 de `NON-001` cesse d'être théorique. La preuve est consignée dans son journal, avec une distinction que les documents n'avaient pas faite : `<PREFIXE>-<SEQ>` est une **adresse**, `<PREFIXE>-<SLUG>` est une **identité**. Les nommer pareil est ce qui a produit la confusion, y compris dans la demande de cette tâche.

**Le modèle ne connaît pas le bundle.** `clia res ls` compte neuf analyses là où il y en a deux : `ANL-001` est un répertoire de neuf fichiers, format imposé par la tâche 1, et `RES-001` pose qu'une ressource est un fichier. Nouvelle objection `NON-012`.

**La tension de `ADR-003` D7 n'existait pas.** D7 signalait une circularité : la source machine-lisible des types doit être dérivée des définitions, et la dérivation est un travail de `clia`, dont l'existence en dépend. L'implémentation la dissout en dérivant à la lecture, sans fichier intermédiaire.

## Deux réponses de fait à des objections ouvertes

`NON-011` Q7, sur ce que `clia` doit faire d'un type inconnu : l'outil distingue la lecture de l'écriture. En lecture, `res ls` affiche les types sans définition avec la mention `aucune`. En écriture, `res new` refuse.

`NON-001` Q7, sur qui attribue le numéro de séquence : `clia`, par maximum plus un. Les collisions entre travaux parallèles restent non traitées.

## Sur le critère de convergence de la session

« Le concept de ressource est bien défini, utilisable et instrumenté. » Défini par `RES-001`. Utilisable par `skl-001-ressource`. Instrumenté depuis cette tâche : `clia res ls` lit les définitions du dépôt et `clia res new` produit une instance conforme au cycle de vie déclaré.

Ce qui n'est pas instrumenté : la validation. Les neuf contrôles de `skl-001` restent des commandes à exécuter à la main.

## Ce qui n'a pas été fait

Aucune commande de validation. `ADR-003` D9 en fait le cahier des charges d'une future commande, la session d'outillage est annoncée, et la demande ne la mentionne pas.

Aucune écriture de contenu par l'outil.

Aucune opération git, y compris le signalement d'état que `NON-010` Q6 propose : la question est ouverte, non tranchée.

Aucune modification de `CLAUDE.md`, `ARCHITECTURE.md` ni `INTENTION.md`.

Un écart signalé sans objection : `ARCHITECTURE.md` prévoit `src/` et `tests/` et ne mentionne ni `bin/` ni `lib/`, que l'implémentation emploie parce que ce sont les emplacements conventionnels du bash exécutable et sourcé.
