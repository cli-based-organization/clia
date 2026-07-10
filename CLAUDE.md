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
- Les droits d'édition de chaque document sont fixés par la « Classification des documents » de `CONSTITUTION.md`. `INTENTION.md` et les fichiers de session sont en **édition humaine uniquement** : l'agent ne les modifie jamais.

## Journalisation obligatoire

**TOUTE tâche traitée produit un log**, sans exception, dans `logs/ia-output/<DATE>_task-<NN>.md` (voir `skl-008-log-ia-output`).

Cela inclut explicitement les tâches dont le seul livrable est un plan : **produire ou réviser un plan est une tâche** et se termine donc par un log, au même titre qu'une tâche d'exécution. Une tâche n'est pas terminée tant que son log n'est pas écrit.

## Types de livrables

| Livrable | Emplacement | Skill de production |
|---|---|---|
| Plan de travail | `.dev/plans/PLN-<SEQ>-<SLUG>.md` | `skl-003-plan-de-travail` |
| Recherche de fondation | `.dev/fondations/FND-<SEQ>-<SLUG>.md` | `skl-002-recherche-de-fondation` |
| Harnais | `CLAUDE.md`, `CONSTITUTION.md`, `INTENTION.md` | `skl-004-harnais` |
| Skill | `.dev/skills/skl-<SEQ>-<nom>/SKILL.md` | `skl-001-skill-writer` |
| ADR | `.dev/adr/ADR-<SEQ>-<SLUG>.md` | `skl-006-adr` |
| Rapport de bogue | `.dev/bugs/BUG-<SEQ>-<SLUG>.md` | `skl-013-rapport-de-bogue` |
| Analyse de corpus | `.dev/analyses/ANL-<SEQ>-<SLUG>.md` | `skl-012-analyse-corpus` |
| Spécification | `.dev/specs/SPEC-<SEQ>-<SLUG>.md` | `skl-009-specification` |
| Requis | `.dev/requis/REQ-<SEQ>-<SLUG>.md` | `skl-010-requis` |
| Log de sortie IA | `logs/ia-output/<DATE>_task-<NN>.md` | `skl-008-log-ia-output` |

Chaque type de livrable a un skill associé qui encadre sa production : une spécification/exigence vivante à consulter avant de produire ou modifier ce type de livrable.

Cas particulier : le **rapport de recherche** demandé pour une tâche est une **recherche de fondation** au sens de la table ci-dessus. Il n'a pas de type ni de skill distinct, il se produit avec `skl-002-recherche-de-fondation` (`.dev/fondations/FND-<SEQ>-<SLUG>.md`). À distinguer de l'**analyse de corpus** (`skl-012`), qui porte sur un existant matériel et non sur la littérature (voir `ADR-001-type-livrable-analyse`).

Cas particulier : `skl-011-codage-cli-bash` encadre la production d'un **script bash exécutable** (pas un document markdown) conforme à `ADR-002`, `SPEC-001` et `REQ-001`.

## Nomenclature

Les livrables de type « artefact-de-travail » (plans, fondations, ADR, bugs, analyses, spécifications, requis) suivent :

```
.dev/<type>/<TYPE_PREFIX>-<SEQ>-<SLUG>.md
```

Exceptions à contrainte fixe :
- les **skills** suivent la convention Claude Code (`.dev/skills/skl-<SEQ>-<nom>/SKILL.md`) ;
- le **harnais** utilise des noms de fichiers fixes à la racine (`CLAUDE.md`, `CONSTITUTION.md`, `INTENTION.md`) : pas de séquence, un fichier = un rôle ;
- les **logs de sortie IA** suivent `logs/ia-output/<DATE>_task-<NN>.md` (voir `skl-008-log-ia-output`).

## Conventions transverses

- Markdown strict : pas de filet `---` hors frontmatter, pas de tiret cadratin. Cette règle s'applique à tous les documents éditables par l'agent ; les fichiers en édition humaine uniquement en sont exclus.
- L'agent ne réalise, ne propose et ne suggère **jamais** d'opération git (`add`, `commit`, `push`, stratégie de branche). La gestion de versions est la responsabilité exclusive de l'humain (voir `CONSTITUTION.md`, « Git commit : responsabilité de l'humain »).
