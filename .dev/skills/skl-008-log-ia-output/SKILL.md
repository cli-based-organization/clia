---
name: skl-008-log-ia-output
description: Spécification pour la production des logs de réponses de l'agent IA
metadata:
  type: skill
---

# SKL-008 - Log des réponses de l'agent IA

> Encadre la production des transcriptions des interventions de l'agent IA, versionnées par session et par tâche. Les logs servent de trace d'audit et de documentation du travail effectué. **Aucun git commit ne doit être inclus dans ce log ou proposé par l'agent.**

## Objet du livrable

Chaque tâche exécutée par l'agent produit un fichier log markdown au format :
```
logs/ia-output/<SESSION_DATE>_task-<TASK_NUM>.md
```

où :
- `<SESSION_DATE>` = date de la session au format `YYYY-MM-DD` (ex: `2026-07-09`)
- `<TASK_NUM>` = numéro séquentiel de la tâche (ex: `01`, `02`)

## Structure du fichier log

Chaque log suit la structure suivante (obligatoire) :

```markdown
---
task: <TASK_NUM>
session-date: <YYYY-MM-DD>
status: completed|failed|partial
duration: <temps estimé ou réel>
---

# Résumé de la tâche

<Description synthétique de ce qui a été demandé et de l'intention (1-3 phrases)>

## Travail effectué

<Narration claire du travail réalisé, étapes clés, modifications apportées. Inclure :>
- Les fichiers modifiés ou créés (avec chemins relatifs)
- Les décisions prises (si ambiguïté dans la demande)
- Les limitations ou contraintes rencontrées

## Résultats

<Énumération des livrables produits ou de l'état final du travail>

## Commit message proposé

*Note: Ce message est fourni à titre informatif uniquement. C'est à l'humain de décider s'il doit être commité, rejeté, ou modifié. L'agent n'exécute jamais de git commit.*

\`\`\`
<titre court du commit (< 70 caractères)>

<description détaillée du commit, expliquant le « pourquoi » et le « quoi »>

Co-Authored-By: <modèle courant de l'agent> <noreply@anthropic.com>
\`\`\`

## Objections de l'agent (le cas échéant)

<Risques identifiés ou contraintes non résolues>

- [OBJECTION] <Description du risque>
  - Impact : <conséquences si non traitée>
  - Suggestion : <comment lever l'objection>

## Notes

<Contexte supplémentaire, hypothèses, ou informations utiles pour interpréter le log>
```

## Règles essentielles

1. **Markdown valide** : le fichier doit être parseable en markdown strict (pas de filet `---` hors frontmatter, pas de tiret cadratin).

2. **Traçabilité** : chaque log inclut la date de session et le numéro de tâche, permettant de relier le travail à la demande initiale dans `session.md`.

3. **Git commit interdit** : le log **propose** un message de commit à titre informatif, mais l'agent ne doit **jamais** :
   - exécuter `git add` ou `git commit` ;
   - proposer à l'humain de faire un commit ;
   - suggérer une stratégie de push ou de branche ;
   - discuter du moment ou de la façon de commiter.

   L'humain reste seul responsable de toute action git.

4. **Status** : à la fin du travail, le frontmatter inclut un `status` qui reflète le cycle :
   - `completed` : tâche achevée, aucune objection ouverte
   - `partial` : tâche partiellement achevée ou objections ouvertes
   - `failed` : tâche échouée ou bloquée

5. **Modèle** : la ligne `Co-Authored-By` du message de commit proposé reflète le modèle réellement utilisé au moment de l'exécution (pas de modèle codé en dur dans ce skill).

6. **Tonalité** : le log est factuel et technique, pas une narration conversationnelle.

## Exemple

```markdown
---
task: 01
session-date: 2026-07-09
status: completed
duration: 15 min
---

# Résumé de la tâche

Correction d'un bug identifié : la tâche précédente a écrasé INTENTION.md avec du contenu générique. Restauration du vrai contenu (« Rédaction offre pour la Commission scolaire de la Capitale-Nationale ») et extension de CONSTITUTION.md pour clarifier les droits d'édition des documents.

## Travail effectué

- **Fichier restauré** : `INTENTION.md`, contenu court et concis
- **Fichier modifié** : `CONSTITUTION.md`, ajout d'une section « Classification des documents » avec trois catégories (humain-only, IA-only, co-édition)
- **Décision** : la classification des documents est orthogonale au cycle de gouvernance existant et ne le modifie pas

## Résultats

- INTENTION.md contient à présent l'intention réelle du projet
- CONSTITUTION.md définit clairement que INTENTION.md et session.md sont en « édition par humain uniquement »
- La structure de gouvernance reste inchangée

## Commit message proposé

\`\`\`
Fix: Restaurer INTENTION.md et clarifier les droits d'édition des documents

La tâche précédente a écrasé INTENTION.md avec du contenu générique.
Restauration du vrai contenu et extension de CONSTITUTION.md pour préciser
la classification des documents (humain-only, IA-only, co-édition).

INTENTION.md est le coeur de la motivation humaine, l'IA ne doit jamais le modifier.

Co-Authored-By: <modèle courant de l'agent> <noreply@anthropic.com>
\`\`\`

## Objections de l'agent

Aucune.

## Notes

N/A
```
