---
name: skl-003-plan-de-travail
description: >-
  Produire ou réviser un plan de travail (`.dev/plans/PLN-<SEQ>-<SLUG>.md`) proposant une
  intervention en réponse à un problème soumis par l'humain dans `session.md`. À utiliser quand
  une tâche demande de « proposer un plan », de l'« étendre » suite à des précisions, ou de
  répondre à des objections avant exécution.
---

# Skill - Rédaction d'un plan de travail

> Un plan de travail est la proposition d'intervention de l'agent en réponse à un problème soumis par l'humain, structurée par intention/contexte/spécification du livrable, et porteuse des objections de l'agent. Aucune exécution n'a lieu tant que ce plan porte une objection ouverte (voir `CONSTITUTION.md`).

## Quand l'utiliser

Quand `session.md` demande de proposer, réviser ou étendre un plan, ou quand une tâche répond à des objections consignées dans `session.md`. Ne pas utiliser pour exécuter le plan lui-même (l'exécution produit les livrables prévus par le plan, pas le plan) ni pour un document de fondation (`skl-002`).

## Processus

1. Lire `session.md` en entier (intention, contexte, spécification des livrables, tâches) : c'est l'unique source de la demande.
2. Si un plan `PLN-<SEQ>` existe déjà pour ce sujet, le réviser plutôt qu'en créer un nouveau ; consigner la révision dans un **Changelog** en tête de fichier.
3. Rédiger/mettre à jour les sections Intention, Contexte, Spécification du livrable à partir de l'état courant de `session.md`, pas d'une version mémorisée.
4. Décomposer l'intervention proposée en étapes numérotées, actionnables.
5. Soulever, dans une section **« Objections de l'agent IA »**, tout risque concret identifié dans la demande ou dans le plan lui-même ; ne pas trancher seul les questions ouvertes.
6. Ne jamais inscrire d'objection humaine dans le plan : elles vivent dans `session.md` (rappeler ce fait en fin de plan).
7. Fixer le champ **Statut** en tête de fichier selon l'état du cycle (`proposé` / `objection` / `résolu` / `approuvé` / `exécuté`, voir `CONSTITUTION.md`).
8. Si le plan doit être exécuté en segments avec revue humaine intermédiaire, déclarer explicitement le ou les **breakpoints** : le point d'arrêt, le livrable qui le précède, et ce que l'humain doit décider à la reprise. Une objection peut être différée à un segment postérieur au breakpoint : elle reste ouverte et bloque son segment sans bloquer les segments déjà approuvés (voir `CONSTITUTION.md`, « Breakpoint et exécution segmentée »).

## Critères de qualité

- Le fichier est déposé à `.dev/plans/PLN-<SEQ>-<SLUG>.md`.
- Le champ Statut en tête de fichier reflète l'état réel du cycle d'objections.
- Une révision porte un Changelog qui explique ce qui a changé et pourquoi.
- Chaque objection de l'agent est formulée comme un risque concret (« si ce plan est exécuté tel quel, [conséquence] »), pas une préférence.
- Aucune objection humaine n'est dupliquée dans le plan ; le plan renvoie vers `session.md` pour celles-ci.
- Ressource de harnais : aucune information de domaine métier ni spécifique au repo (généricité inter-dépôts, voir `ADR-005`).
- Markdown strict (voir `CLAUDE.md`).

## Structure du livrable

- **Emplacement** : `.dev/plans/PLN-<SEQ>-<SLUG>.md`

```markdown
# PLN-<SEQ> - <Titre>

**Statut : <proposé|objection|résolu|approuvé|exécuté>**

## Changelog
<uniquement si révision ; sinon omettre cette section>

## Intention
<le pourquoi, tiré de session.md>

## Contexte
<contraintes, façon de collaborer, tiré de session.md>

## Spécification du livrable
<forme attendue du ou des livrables concernés>

## Plan proposé

### 1. <Étape>
...

## Objections de l'agent IA
<liste des risques concrets ; "Aucune objection ouverte actuellement." si résolu>

## Note sur les objections humaines
Les objections de l'humain sur ce plan ne sont pas consignées ici mais dans `.dev/session.md`.
```
