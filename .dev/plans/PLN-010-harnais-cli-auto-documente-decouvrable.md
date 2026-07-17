# PLN-010 - Harnais : CLI auto-documentés et découvrables

**Statut : exécuté**

## Changelog

Exécution (tâche 3 de `.dev/session.md`, « Exécution du plan PLN-010 »). Phases 1 et 2 réalisées : `REQ-001` (F5 promu MUST, ajout F7/F8), `SPEC-001` (squelette à table de commandes déclarative, comportement, interfaces, traçabilité), `ADR-002` (décision « Auto-documentation et découvrabilité », écart consigné), `ADR-007` (ordre séquentiel de travail en quatre phases), `skl-011` (étape 6 et critères de qualité). Versionnage atomique dans `.dev/ressources.yaml` (membres modifiés en 0.2.0 ; ensembles `documents-de-conception` et `harness-files` en 0.3.0 ; `version-manifeste` en 0.3.0). Squelette de référence vérifié par exécution (découvrabilité et uniformité effectives). Phase 3 (réconciliation de `clia`) non réalisée, hors périmètre.

Révision suite aux réponses de l'humain à mes objections (tâche 2 de `.dev/session.md`, « [Traitement des objections] PLN-010 »).

- **Objection 1 levée par amendement** : l'amélioration du code de `clia` (ex-étape 3) est retirée du périmètre. Ce plan n'améliore que le harnais.
- **Objection 2 levée par argumentation acceptée + amendement** : la non-conformité des CLI existants n'est pas un problème ; les documents de conception sont évolutifs pour améliorer les capacités du système, et c'est cela qui prime. La réconciliation du CLI est une phase ultérieure, effectuée une fois que le système a précisé comment il doit se comporter. Ajout de l'ordre séquentiel de travail en quatre phases, à documenter dans le harnais (voir étape 1.4).
- **Objection 3 levée par argumentation acceptée** : les exigences de documentation (découvrabilité, auto-documentation, uniformité) sont des fonctionnalités de cœur non négociables d'un système d'ingénierie logicielle professionnel. Ma suggestion d'exigence graduée / de forme minimale pour les outils triviaux est retirée : les exigences sont des MUST fermes pour tout CLI.
- **Périmètre réduit** : ce plan couvre uniquement le harnais générique. Phase 1 (conception) : `ADR-002`, `SPEC-001`, `REQ-001`, et l'amendement d'`ADR-007` pour l'ordre de travail. Phase 2 (méthodologie) : `skl-011`. La conception spécifique à `clia` (`SPEC-002`, `REQ-002`) et le code de `clia` sont déférés à la tâche de réconciliation ultérieure (phase 3, hors périmètre).

## Intention

Faire converger le harnais vers un comportement de documentation garanti pour tout CLI qu'il produit :

- **auto-documenté** : le CLI contient des commandes d'accès à sa propre documentation ;
- **découvrable** : toutes les commandes existantes apparaissent dans `outil -h` et toutes les sous-commandes apparaissent avec `outil COMMAND -h` ;
- **uniforme** : la documentation a la même forme partout, dans toutes les commandes et sous-commandes.

Ces propriétés sont des fonctionnalités de cœur, non négociables (voir Changelog, objection 3). Le symptôme déclencheur est `clia` (`clia session` absent de `clia -h`, `clia ses -h` non documentée), mais sa correction relève d'une phase ultérieure (voir Contexte).

## Contexte

Demande initiale : tâche 1 de `.dev/session.md`. Révision : tâche 2 (traitement des objections). Livrable attendu : un **plan d'amélioration du harnais**, pas l'exécution du correctif.

Modèle de travail séquentiel acté par l'humain (objection 2), en quatre phases ordonnées :

- **Phase 0 — Recherches préliminaires et préconception** : `FND`, `ANL`.
- **Phase 1 — Conception** : documents de conception (`ADR`, `SPEC`, `REQ`).
- **Phase 2 — Méthodologie** : fichiers de harnais, y compris les `SKILL`.
- **Phase 3 — Implémentation** : le CLI (`clia`).

La conception précise d'abord comment le système doit se comporter ; l'implémentation (le CLI) est réconciliée ensuite. La non-conformité temporaire de `clia` entre les phases est donc attendue et acceptable : la capacité conçue prime. Ce plan réalise les phases 1 et 2 pour la capacité « CLI auto-documentés et découvrables ». La phase 3 (réconciliation de `clia`) est explicitement hors périmètre et fera l'objet d'une tâche ultérieure.

Ressource de harnais : les changements doivent rester génériques et réutilisables inter-dépôts (aucune information de domaine, voir `ADR-005`).

## Diagnostic

Le diagnostic établi en tâche 1 reste valide et motive l'intervention. Résumé.

### Défaut 1 : découvrabilité du niveau supérieur cassée

`clia -h` omet le groupe `ses`/`session`. Cause directe : `_usage()` (`src/bin/clia`) fait `sed -n '2,9p'`, or la ligne d'en-tête décrivant `clia ses` est la ligne 10 : elle est tronquée. Cause de convention : le squelette de référence de `SPEC-001` (ligne 64) impose ce patron fragile `_usage() { sed -n 'A,Bp' ... }` qui couple la sortie d'aide à des numéros de ligne.

### Défaut 2 : documentation des sous-commandes appauvrie et manquante

`clia ses -h` et `clia res -h` n'impriment qu'une ligne d'usage codée en dur, sans décrire les sous-commandes, et il n'existe pas d'aide par sous-commande. Cause de convention : `REQ-001-F5` (aide par sous-commande) n'est que SHOULD, et rien n'exige que l'aide d'un groupe énumère ses sous-commandes.

### Défaut 3 : documentation non uniforme et dupliquée

Trois sources hand-maintenues et indépendantes (`_usage`, `_man`, aide de groupe) sans source de vérité unique : elles divergent, ce qui a produit le défaut 1. Cause de convention : aucune exigence d'uniformité ni de source de vérité unique.

### Cause racine profonde

Le harnais (`ADR-002` / `SPEC-001` / `REQ-001` / `skl-011`) autorise, et via son squelette de référence encourage activement, un système d'aide couplé aux numéros de ligne, fragmenté sur plusieurs sources, n'exigeant la découvrabilité, l'uniformité et l'aide par sous-commande que faiblement (SHOULD) ou pas du tout. Un CLI peut être « conforme » tout en étant non découvrable. La correction doit se faire dans la convention, en amont.

## Spécification du livrable

Le livrable de cette tâche est le présent plan (`PLN-010`). Une fois approuvé, son exécution produira les modifications des phases 1 et 2 ci-dessous. Aucune n'est exécutée dans le cadre de la tâche de planification.

## Plan proposé

### Phase 1 : Conception (documents de conception)

**1.1 `REQ-001-convention-cli-bash`** (bump vivant). Durcir et compléter les exigences de documentation, en MUST fermes pour tout CLI (aucune exemption pour outils triviaux) :
- promouvoir `REQ-001-F5` (aide par sous-commande) de SHOULD à MUST ;
- ajouter `REQ-001-F7` (MUST, découvrabilité) : `outil -h` liste toutes les commandes/groupes ; `outil COMMAND -h` liste toutes les sous-commandes. Vérification : toute commande/sous-commande existante apparaît dans l'aide correspondante ;
- ajouter `REQ-001-F8` (MUST, uniformité et source unique) : une seule structure déclarative alimente l'aide de tous les niveaux ; aucune extraction d'aide par plage de numéros de ligne. Vérification : ajouter une commande met à jour l'aide sans édition d'une plage codée en dur.

**1.2 `SPEC-001-convention-cli-bash`** (bump vivant). Remplacer le squelette de référence : substituer `_usage() { sed -n 'A,Bp' ... }` par un patron à **table de commandes déclarative** (tableau associatif ou fonction dédiée) qui pilote simultanément le dispatch `case` et le rendu de l'aide aux trois niveaux (supérieur, groupe, sous-commande). Mettre à jour la table de traçabilité vers `REQ-001-F5/F7/F8`.

**1.3 `ADR-002-convention-cli-bash`** (bump vivant). Ajouter une décision détaillée « Auto-documentation et découvrabilité » érigeant en principe non négociable : aide de niveau supérieur énumérant tous les groupes ; aide de groupe énumérant et décrivant toutes ses sous-commandes ; source de vérité unique (pas de couplage aux numéros de ligne) ; aide par sous-commande. Consigner l'écart avec la décision antérieure dans « Conséquences ».

**1.4 `ADR-007-architecture-systeme-augmentation`** (bump vivant). Documenter l'ordre séquentiel de travail en quatre phases (0 recherche → 1 conception → 2 méthodologie → 3 implémentation), en extension explicite de la relation déjà présente « une décision passe d'abord par la conception, puis le harnais ». Acter que l'implémentation (le CLI) est réconciliée après la conception, et que la non-conformité temporaire est attendue.

### Phase 2 : Méthodologie (fichiers de harnais, SKILLs)

**2.1 `skl-011-codage-cli-bash`** (bump harnais). Réécrire l'étape 6 du processus pour imposer une aide découvrable et auto-documentée pilotée par une source unique (la table déclarative de `SPEC-001` mise à jour). Ajouter aux critères de qualité : découvrabilité de toutes les commandes et sous-commandes, uniformité, absence de couplage aux numéros de ligne. Pointer vers le nouveau squelette.

### Gestion des versions

Versionnage atomique dans `.dev/ressources.yaml` (voir `ADR-004`, `ADR-007`) pour les seuls membres modifiés par ce plan et leurs ensembles : `documents-de-conception` (`REQ-001`, `SPEC-001`, `ADR-002`, `ADR-007`) et `harness-files` (`skl-011`), plus `version-manifeste`. L'ensemble `clia` n'est pas touché par ce plan.

### Hors périmètre (phase 3, tâche ultérieure)

Réconciliation de `clia` avec la convention améliorée : mise à jour de `SPEC-002`/`REQ-002` (conception spécifique à `clia`), refonte de l'aide de `clia` autour d'une source unique, correction de `clia -h` (liste `ses`) et de `clia GROUPE -h` (décrit les sous-commandes), bump de l'ensemble `clia` dans `.dev/ressources.yaml`.

## Objections de l'agent IA

Aucune objection ouverte actuellement. Mes trois objections initiales ont été traitées par l'humain en tâche 2 : objection 1 levée par amendement (retrait de `clia`), objection 2 levée par argumentation acceptée (conception évolutive prioritaire, réconciliation différée), objection 3 levée par argumentation acceptée (exigences de cœur non négociables). Le détail figure dans le Changelog.

## Note sur les objections humaines

Conformément à la gouvernance, les objections de l'humain sur ce plan ne sont pas consignées ici mais dans `.dev/session.md`.
