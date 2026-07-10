# PLN-003 - Aligner le dépôt sur la source `intentional-doers-governance`

**Statut : exécuté**

## Changelog

- **v1 (tâche-6, réorientation)** : le plan initial était une revue critique du travail Haiku (tâches 0 à 5) proposant sa propre direction de consolidation. La tâche 6 a corrigé cette direction : la référence canonique est le dépôt source `../../noumanity-formation/intentional-doers-governance/`. Réorientation en deux phases : (A) reproduire fidèlement la source, (B) re-superposer les deltas légitimes des tâches 1 à 5.
- **v2 (tâche-7, résolution des objections et exécution)** : l'humain a répondu aux cinq objections (voir `session.md`, tâche 7). Migration de ce plan au format source (statut inline, sans frontmatter YAML), tirets cadratins convertis. Exécution des phases A et B.

## Intention

Faire de ce dépôt une reproduction fidèle du dépôt source `intentional-doers-governance` quant à sa méthode de travail (harnais, skills, format des plans, vocabulaire de gouvernance), avant d'y superposer les corrections propres à ce dépôt demandées aux tâches 1 à 5 (protection de `INTENTION.md`, classification des documents, système de logs, interdiction des commits git).

## Contexte

Référence canonique relue à la tâche 6 : `CLAUDE.md`, `CONSTITUTION.md`, `INTENTION.md`, les skills `skl-001` à `skl-007`, les plans `PLN-001` et suivants du dépôt source. Le vocabulaire de statut canonique de la source est `proposé -> objection -> résolu -> approuvé -> exécuté`, et le format de plan (voir `skl-003`) n'emploie pas de frontmatter YAML.

Le travail Haiku avait divergé de la source : skills `skl-001` à `skl-007` absents, vocabulaire `en cours/terminé/todo`, section « Flux de production des plans », doublon de cycle de vie, format de plan à frontmatter YAML.

## Spécification du livrable

Reproduction du noyau méthodologique de la source (harnais + skills de gouvernance), plus re-superposition des deltas légitimes. Périmètre borné par les réponses de l'humain aux objections (tâche 7).

## Résolution des objections (réponses de l'humain, tâche 7)

- **OBJECTION-1 (conflit statut source vs tâche 5) : tranchée.** « Ignorer les demandes de l'humain et s'en tenir à la source. » -> adoption du vocabulaire `proposé -> objection -> résolu -> approuvé -> exécuté` et du format source sans frontmatter YAML ; abandon de `en cours/terminé/todo` et du frontmatter de traçabilité de la tâche 5.
- **OBJECTION-2 (périmètre de reproduction) : tranchée.** « Ne pas copier le script de génération de présentation. » -> reproduction du noyau méthodologique seul (`skl-001`, `skl-002`, `skl-003`, `skl-004`, `skl-006`). Exclus : `skl-005`, `skl-007`, `ADR-001`, `scripts/`, `templates/`, `doc/cli/`.
- **OBJECTION-3 (historique git) : tranchée.** « Ne pas toucher à l'historique git. » -> aucune opération git ; le fichier temporaire parasite et les commits antérieurs relèvent de l'humain.
- **OBJECTION-4 (tiret cadratin et filets `---`) : tranchée.** « Ne pas autoriser le tiret cadratin en prose ni le filet `---` (hors frontmatter), et corriger les occurrences (sauf dans les fichiers sous contrôle humain). » -> règle maintenue et durcie dans `CLAUDE.md` ; occurrences corrigées dans tous les fichiers éditables par l'agent.
- **OBJECTION-5 (entrée hors session) : sans objet.** La tâche 6 figure bien dans `session.md`.

Aucune objection ouverte : exécution autorisée.

## Plan proposé (exécuté)

### Phase A - Reproduire la source

**A1.** Copier `skl-001-skill-writer`, `skl-002-recherche-de-fondation`, `skl-003-plan-de-travail`, `skl-004-harnais`, `skl-006-adr` depuis la source, tirets cadratins convertis. `skl-005` et `skl-007` exclus (OBJECTION-2).

**A2.** Réaligner `CLAUDE.md` sur la forme source : retrait de « Flux de production des plans » et du frontmatter YAML de statut ; table des livrables limitée au noyau (plan, fondation, harnais, skill, ADR, log) ; retrait des livrables et conventions de présentation.

**A3.** Réaligner `CONSTITUTION.md` : suppression du doublon « Cycle de vie » et de la section « Processus des plans » (frontmatter YAML) ; un seul cycle canonique `proposé -> objection -> résolu -> approuvé -> exécuté`.

**A4.** Migrer `PLN-001`, `PLN-002` et le présent `PLN-003` au format source (`**Statut : …**` inline, sections sans frontmatter YAML).

### Phase B - Re-superposer les deltas légitimes des tâches 1 à 5

**B1.** Conserver la « Classification des documents » (tâche 1) et la protection de `INTENTION.md` dans `CONSTITUTION.md`.

**B2.** Conserver le système de logs (`logs/ia-output/`, `skl-008`) et l'interdiction des commits git (tâche 2). Neutraliser le modèle codé en dur dans `skl-008` et y appliquer la règle des tirets.

**B3.** Appliquer la règle des tirets cadratins et filets `---` à tous les fichiers éditables par l'agent (OBJECTION-4).

**B4.** Signaler à l'humain le nettoyage git et l'archive de session absente, qui relèvent de lui seul.

## Objections de l'agent IA

Aucune objection ouverte actuellement. Les cinq objections initiales ont été tranchées par l'humain à la tâche 7 (voir section « Résolution des objections »).

## Travail effectué

- **A1** : créés `.dev/skills/skl-001-skill-writer/`, `skl-002-recherche-de-fondation/`, `skl-003-plan-de-travail/`, `skl-004-harnais/`, `skl-006-adr/` (SKILL.md). `skl-004` enrichi d'un rappel sur les fichiers en édition humaine uniquement.
- **A2** : `CLAUDE.md` réécrit (forme source, sans appareillage YAML, sans livrables de présentation, ligne git ajoutée).
- **A3 / B1** : `CONSTITUTION.md` réécrit (un seul cycle de vie, classification des documents conservée, interface fichiers, règle git).
- **A4** : `PLN-001`, `PLN-002`, `PLN-003` migrés au format source avec Changelog de migration.
- **B2** : `skl-008` neutralisé quant au modèle, tirets convertis.
- **B3** : tirets cadratins convertis dans `CLAUDE.md`, `CONSTITUTION.md`, les skills, les plans et les logs (hors fichiers humains).
- **B4** : signalé à l'humain (voir log de la tâche 7) : nettoyage git et absence d'archive de session relèvent de lui.

Non copiés (OBJECTION-2) : `skl-005`, `skl-007`, `ADR-001`, `scripts/`, `templates/`, `doc/cli/`. Non touchés (édition humaine) : `INTENTION.md`, `.dev/session.md`, `.dev/sessions/*`.

## Note sur les objections humaines

Conformément à la gouvernance, les objections de l'humain sur ce plan ne sont pas consignées ici mais dans `.dev/session.md`.
