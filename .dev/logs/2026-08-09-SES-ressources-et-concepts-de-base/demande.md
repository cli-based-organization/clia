# Interprétation de la demande

## Contexte

Session ouverte le 2026-08-09 par `workspace/session.md`. Le dépôt `clia` sort d'un refactor drastique (commit `2373ec7`, 2026-08-08) qui a archivé la quasi-totalité de son contenu sous `.dev/archives/`. Ne subsistent que `CLAUDE.md`, `INTENTION.md`, `ARCHITECTURE.md` et le fichier de session.

L'humain déclare un travail de méthodologie mené depuis un an, presque abouti, dont il reste à clarifier les idées, la dynamique UX, et à mettre au propre pour une première version publique. La session est consacrée aux ressources et concepts de base ; l'outillage `clia` est reporté à une session suivante.

## Intention

Comprendre, par observation du corpus complet des dépôts de l'humain, le système d'augmentation construit depuis un an et la manière dont l'humain travaille, afin de disposer d'une matière fondée pour le premier jet des ressources fondamentales.

## Instruction de cadrage reçue

L'humain précise explicitement que le système est en construction et que les directives de `CLAUDE.md` ne sont pas toutes exécutables, les documents qu'elles mentionnent n'existant pas tous. Cette précision autorise l'exécution malgré les directives inapplicables.

## Directives inexécutables constatées et traitement retenu

| Directive de `CLAUDE.md` | État | Traitement |
|---|---|---|
| Point d'entrée `@workspace/session.md` | Le fichier existe depuis cette session ; l'historique du dépôt utilise `.dev/session.md`, qui existe aussi avec un contenu différent | `workspace/session.md` retenu comme source, conformément à la directive |
| Ressources fondamentales `ADR-XXX`, `RES-XXX`, `skl-XXX` | Aucune n'existe | Non invocables. Le skill `skl-012-analyse-corpus` n'existant pas, la forme de l'analyse suit le modèle observé dans le corpus |
| Journalisation `.dev/logs/<YYYY-MM-DD>-SES-<SLUG>/` | Le répertoire n'existait pas | Créé et renseigné |
| Commandes `clia` | Aucun exécutable dans le dépôt | Non utilisées ; relevé fait par git et outils unix |
| `ARCHITECTURE.md` comme description du système | Réduit à un titre et à une liste de répertoires | Non utilisable comme référence |

## Livrable produit

Analyse critique de corpus, en bundle : `.dev/analyses/ANL-001-observation-corpus-repos-et-pratiques/`, emplacement imposé par la tâche.

## Objection émise

Une objection est portée à l'`INTENTION.md` du dépôt : il affirme que le cadre est adapté au DeepTech parce qu'il fournit nativement des capacités de mobilisation et d'utilisation du savoir. L'observation ne soutient pas cette affirmation. Détail dans `analyse-critique.md`, section D6.
