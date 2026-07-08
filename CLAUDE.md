# CLAUDE.md

> Mode opératoire de l'agent IA dans ce dépôt. Fichier de harnais — vivant, sujet à évolution (voir `skl-004-harnais`).

## Règle des 3 ingrédients

Pour toute demande, tenir compte de :

1. l'**intention** (le pourquoi) — voir `INTENTION.md` pour l'intention globale du dépôt ;
2. le **contexte** (les contraintes, la façon de collaborer) — voir `CONSTITUTION.md` pour le processus de gouvernance ;
3. la **spécification du livrable** (la forme attendue du résultat) — voir la table des livrables ci-dessous.

## Gouvernance

- L'humain n'a qu'**un seul point d'entrée** : `.dev/session.md`.
- Le cycle de travail est **objection-sociocratique** : l'agent propose un plan avant d'exécuter, et ne peut exécuter tant qu'une objection reste ouverte. Détails complets dans `CONSTITUTION.md`.
- Les objections de l'humain sont consignées dans `.dev/session.md` ; celles de l'agent, dans le plan concerné.

## Types de livrables

| Livrable | Emplacement | Skill de production |
|---|---|---|
| Plan de travail | `.dev/plans/PLN-<SEQ>-<SLUG>.md` | `skl-003-plan-de-travail` |
| Recherche de fondation | `.dev/fondations/FND-<SEQ>-<SLUG>.md` | `skl-002-recherche-de-fondation` |
| Harnais | `CLAUDE.md`, `CONSTITUTION.md`, `INTENTION.md` | `skl-004-harnais` |
| Skill | `.dev/skills/skl-<SEQ>-<nom>/SKILL.md` | `skl-001-skill-writer` |
| ADR | `.dev/adr/ADR-<SEQ>-<SLUG>.md` | `skl-006-adr` |
| README de présentation | `README.md` (racine du dépôt de la présentation concernée) | `skl-005-readme-presentation` |
| pdf de présentation | `dist/<SLUG>.pdf` (racine du dépôt de la présentation concernée ; généré par le CLI encadré par ce skill) | `skl-007-script-pdf-presentation` |

Chaque type de livrable a un skill associé qui encadre sa production : une spécification/exigence vivante à consulter avant de produire ou modifier ce type de livrable.

Cas particulier : le **rapport de recherche** demandé pour une présentation est une **recherche de fondation** au sens de la table ci-dessus — il n'a pas de type ni de skill distinct, il se produit avec `skl-002-recherche-de-fondation` (`.dev/fondations/FND-<SEQ>-<SLUG>.md`).

## Nomenclature

Les livrables de type « artefact-de-travail » (plans, fondations, ADR) suivent :

```
.dev/<type>/<TYPE_PREFIX>-<SEQ>-<SLUG>.md
```

Exceptions à contrainte fixe :
- les **skills** suivent la convention Claude Code (`.dev/skills/skl-<SEQ>-<nom>/SKILL.md`) ;
- le **harnais** utilise des noms de fichiers fixes à la racine (`CLAUDE.md`, `CONSTITUTION.md`, `INTENTION.md`) — pas de séquence, un fichier = un rôle ;
- le **README de présentation** et le **pdf de présentation** sont des livrables *par dépôt de présentation*, sans séquence globale : `README.md` et `dist/<slug>.pdf` à la racine du dépôt de la présentation concernée.

## Conventions transverses

- Markdown strict : pas de filet `---` hors frontmatter, pas de tiret cadratin.
- Le CLI de génération du pdf de présentation (`scripts/dev.sh`) impose une stack technologique exclusive, actée dans `ADR-001-cli-generation-pdf-presentation.md` — jamais Python, jamais pandoc, y compris pour un outillage ponctuel non commité (diagnostic, script d'analyse jetable) touchant ce périmètre. Voir `skl-007-script-pdf-presentation`.
