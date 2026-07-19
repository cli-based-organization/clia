# CLAUDE.md

> Mode opératoire de l'agent IA dans ce dépôt. Fichier de harnais, vivant, sujet à évolution (voir `skl-004-harnais`).

## Règle des 3 ingrédients

Pour toute demande, tenir compte de :

1. l'**intention** (le pourquoi) : voir `INTENTION.md` pour l'intention globale du dépôt ;
2. le **contexte** (les contraintes, la façon de collaborer) : voir `CONSTITUTION.md` pour le processus de gouvernance ;
3. la **spécification du livrable** (la forme attendue du résultat) : voir la table des livrables ci-dessous.

## Gouvernance

- L'humain n'a qu'**un seul point d'entrée** : `.dev/session.md`.
- Le cycle de travail est **objection-sociocratique** : l'agent propose un plan avant d'exécuter, et ne peut exécuter tant qu'une objection reste ouverte. Détails complets dans `CONSTITUTION.md`.
- Les objections de l'humain sont consignées dans `.dev/session.md` ; celles de l'agent, dans le plan concerné.
- Un plan peut déclarer un **breakpoint** : un point d'arrêt qui découpe l'exécution en segments et permet une **approbation partielle** (un segment approuvé s'exécute même si un segment ultérieur porte une objection différée). Arrivé au breakpoint, l'agent s'arrête jusqu'à autorisation humaine de reprise. Voir `CONSTITUTION.md`, « Breakpoint et exécution segmentée ».
- Les droits d'édition de chaque document sont fixés par la « Classification des documents » de `CONSTITUTION.md`. `INTENTION.md` et les fichiers de session sont en **édition humaine uniquement** : l'agent ne les modifie jamais.

## Journalisation obligatoire

**TOUTE tâche traitée produit un log**, sans exception, dans `logs/ia-output/LOG-<DATE>-task-<NN>.md` (voir `skl-008-log-ia-output`).

Cela inclut explicitement les tâches dont le seul livrable est un plan : **produire ou réviser un plan est une tâche** et se termine donc par un log, au même titre qu'une tâche d'exécution. Une tâche n'est pas terminée tant que son log n'est pas écrit.

## Types de livrables

| Livrable | Emplacement | Skill de production |
|---|---|---|
| Plan de travail | `.dev/plans/PLN-<SEQ>-<SLUG>.md` | `skl-003-plan-de-travail` |
| Recherche de fondation | `.dev/fondations/FND-<SEQ>-<SLUG>.md` | `skl-002-recherche-de-fondation` |
| Harnais | `CLAUDE.md`, `CONSTITUTION.md`, `INTENTION.md` | `skl-004-harnais` |
| Harnais ARCHITECTURE.md | `ARCHITECTURE.md` | `skl-015-architecture-harnais` |
| Skill | `.dev/skills/skl-<SEQ>-<nom>/SKILL.md` | `skl-001-skill-writer` |
| ADR | `.dev/adr/ADR-<SEQ>-<SLUG>.md` | `skl-006-adr` |
| Principe de conception | `.dev/principes/PDC-<SEQ>-<SLUG>.md` | `skl-014-principe-de-conception` |
| Rapport de bogue | `.dev/bugs/BUG-<SEQ>-<SLUG>.md` | `skl-013-rapport-de-bogue` |
| Analyse de corpus | `.dev/analyses/ANL-<SEQ>-<SLUG>.md` | `skl-012-analyse-corpus` |
| Spécification | `.dev/specs/SPEC-<SEQ>-<SLUG>.md` | `skl-009-specification` |
| Requis | `.dev/requis/REQ-<SEQ>-<SLUG>.md` | `skl-010-requis` |
| Log de sortie IA | `logs/ia-output/LOG-<DATE>-task-<NN>.md` | `skl-008-log-ia-output` |

Chaque type de livrable a un skill associé qui encadre sa production : une spécification/exigence vivante à consulter avant de produire ou modifier ce type de livrable.

Cas particulier : le **rapport de recherche** demandé pour une tâche est une **recherche de fondation** au sens de la table ci-dessus. Il n'a pas de type ni de skill distinct, il se produit avec `skl-002-recherche-de-fondation` (`.dev/fondations/FND-<SEQ>-<SLUG>.md`). À distinguer de l'**analyse de corpus** (`skl-012`), qui porte sur un existant matériel et non sur la littérature (voir `ADR-001-type-livrable-analyse`).

Cas particulier : `skl-011-codage-cli-bash` encadre la production d'un **script bash exécutable** (pas un document markdown) conforme à `ADR-002`, `SPEC-001` et `REQ-001`.

Cas particulier : un **principe de conception** (`skl-014-principe-de-conception`, `.dev/principes/PDC-<SEQ>-<SLUG>.md`, voir `ADR-008`) est une ressource **transverse et durable** qui guide le design de haut niveau du système : tout élément (harnais, `clia`, documents de conception, livrables) doit lui être conforme. Le **non-respect d'un principe de conception est un bogue** (voir `ADR-003` et `skl-013`).

Cas particulier : `ARCHITECTURE.md` (`skl-015-architecture-harnais`, voir `ADR-009`) est le **fichier de harnais** qui donne la **carte de haut niveau** de la structure du système (composants, acteurs, flux, cartographie du code). Court et stable, il consolide les vues éparses sans décider (les décisions restent aux ADR) ni recopier les invariants (renvoi aux PDC). Il complète la triade `INTENTION.md` (pourquoi) / `CONSTITUTION.md` (gouvernance/orchestration) / `CLAUDE.md` (mode opératoire) par la **structure**.

## Nomenclature

Le nommage dépend du cycle de vie de la ressource (voir `ADR-004-ressources-livrables`) :

- ressources **vivantes** et **de travail** (séquencées) : `.dev/<type>/<PREFIX>-<SEQ>-<SLUG>.md` (plans, ADR, principes de conception, spécifications, requis, bugs) ;
- ressources **point fixe** (datées) : `<PREFIX>-<DATE[-HEURE]>-<SLUG>.<EXT>` (fondations, analyses, publications) ; l'heure est ajoutée en cas de collision de date et de slug ;
- **logs de sortie IA** : `logs/ia-output/LOG-<DATE>-task-<NN>.md` (voir `skl-008-log-ia-output`) ;
- **skills** : convention Claude Code `.dev/skills/skl-<SEQ>-<nom>/SKILL.md` ;
- **archives de session** (point fixe daté) : `.dev/sessions/SES-<DATE>-<HEURE_OUVERTURE>-<SLUG>.md` (voir `ADR-006-gestion-des-sessions`) ;
- **harnais** : noms de fichiers fixes à la racine (`CLAUDE.md`, `CONSTITUTION.md`, `ARCHITECTURE.md`) plus les skills ; le harnais est **générique et réutilisable** (voir `ADR-005-fonction-scope-harnais`). `INTENTION.md` n'est **pas** un fichier de harnais : c'est le fichier d'intention de domaine (édition humaine uniquement).

## Versionnage à deux domaines

Le versionnage sépare deux domaines indépendants (voir `ADR-007-architecture-systeme-augmentation`) :

- **système d'augmentation** : les ensembles vivants (harness-files, documents-de-conception, `clia`) et leurs membres sont versionnés dans `.dev/ressources.yaml` (voir `ADR-004`). Toute modification d'un membre bumpe atomiquement le membre et son ensemble.
- **domaine métier** : le contenu du dépôt a sa propre version dans `version.yaml` (racine). Modifier le harnais ou `clia` n'incrémente pas la version métier, et inversement.

## Sessions et `clia`

Le point d'entrée humain (`session.md`) suit un cycle de vie à trois états (planification `.dev/session-x<YZ>.md` / active `.dev/session.md` / archivée `.dev/sessions/SES-*`), défini dans `ADR-006` et vérifié via le format `markdown-clia-session` (`SPEC-003`). Ces transitions sont opérées exclusivement par `clia`, un CLI déterministe (`ADR-007`, `SPEC-002`, `REQ-002`) : **l'agent n'invoque jamais** `clia ses plan/open/close/new` ni n'édite les fichiers de session (voir `CONSTITUTION.md`). Le squelette de session vit dans `.dev/templates/session.template.md`.

## Conventions transverses

- **Langue** : les noms de commandes, de sous-commandes, d'options et les identifiants de code sont en **anglais** ; l'aide, les messages et la documentation sont en **français**.

## Conventions transverses

- Markdown strict : pas de filet `---` hors frontmatter, pas de tiret cadratin. Cette règle s'applique à tous les documents éditables par l'agent ; les fichiers en édition humaine uniquement en sont exclus.
- L'agent ne réalise, ne propose et ne suggère **jamais** d'opération git (`add`, `commit`, `push`, stratégie de branche). La gestion de versions est la responsabilité exclusive de l'humain (voir `CONSTITUTION.md`, « Git commit : responsabilité de l'humain »).
