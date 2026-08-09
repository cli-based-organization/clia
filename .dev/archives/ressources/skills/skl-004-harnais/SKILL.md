---
type: skill
version: 0.1.0
name: skl-004-harnais
description: >-
  Produire ou faire évoluer un fichier de harnais (`CLAUDE.md`, `CONSTITUTION.md` ou
  `INTENTION.md`, à la racine du dépôt). À utiliser quand un changement de comportement de
  l'agent, de processus de gouvernance ou d'intention globale doit être reflété dans un de ces
  trois fichiers vivants.
---

# Skill - Évolution d'un fichier de harnais

> Le harnais (`CLAUDE.md`, `CONSTITUTION.md`, `INTENTION.md`) n'est pas écrit une fois : ce sont des livrables vivants qui évoluent pour corriger le comportement de l'agent ou faire évoluer le concept méthodologique, même si leur cycle de vie est plus lent que les autres livrables. Ce skill encadre aussi bien leur création initiale que leur modification ultérieure.

## Quand l'utiliser

Quand une tâche demande de créer ou de modifier `CLAUDE.md`, `CONSTITUTION.md` ou `INTENTION.md`, que ce soit pour corriger un comportement observé, ajouter une convention, ou refléter une décision de gouvernance déjà actée ailleurs (ex. un plan approuvé). Ne pas utiliser pour un plan (`skl-003`) ou une fondation (`skl-002`) : le harnais encode des règles durables, pas une intervention ponctuelle.

Cas particulier : `INTENTION.md` et les fichiers de session (`.dev/session.md`, `.dev/sessions/*`) sont en édition humaine uniquement (voir `CONSTITUTION.md`, « Classification des documents »). L'agent peut les lire, les commenter, proposer des amendements, mais ne doit jamais les modifier lui-même.

## Processus

1. Identifier lequel des trois fichiers est concerné par le rôle du contenu à ajouter/modifier : `INTENTION.md` = pourquoi global et stable ; `CONSTITUTION.md` = processus de décision et gouvernance ; `CLAUDE.md` = mode opératoire concret de l'agent (règles, conventions, renvois).
2. Si la modification touche un concept référencé par un autre fichier de harnais (ex. les états du cycle d'objection, la table des livrables), vérifier et mettre à jour la cohérence croisée entre les trois fichiers avant de conclure.
3. Rédiger la modification directement dans le fichier cible, pas de nouvelle version numérotée : le fichier lui-même est la source de vérité courante.
4. Vérifier que tout skill ou plan existant qui référence explicitement le contenu modifié (ex. une convention de nommage, un état de cycle) reste valide ; signaler dans la réponse à l'humain si une incohérence subsiste ailleurs dans le dépôt.
5. Si la modification est motivée par une demande dans `session.md`, s'assurer qu'aucune objection (agent ou humaine) n'est ouverte sur cette demande avant d'exécuter, conformément à `CONSTITUTION.md`.
6. Ne jamais modifier un fichier en édition humaine uniquement (`INTENTION.md`, `.dev/session.md`, `.dev/sessions/*`) ; s'y limiter à la lecture et à la suggestion.

## Critères de qualité

- Le fichier modifié reste cohérent avec les deux autres fichiers de harnais (pas de contradiction sur les mêmes concepts).
- Toute référence croisée entre harnais (ex. `CLAUDE.md` renvoyant vers `CONSTITUTION.md`) reste exacte après modification.
- Le contenu ajouté est placé dans le fichier dont le rôle correspond (pas de règle de gouvernance dans `INTENTION.md`, par exemple).
- Aucun fichier en édition humaine uniquement n'est modifié par l'agent.
- Ressource de harnais : aucune information de domaine métier ni spécifique au repo (généricité inter-dépôts, voir `ADR-005`). Vérifier cette généricité à chaque évolution du harnais.
- Markdown strict (voir `CLAUDE.md`).
- Aucune modification exécutée si une objection reste ouverte.

## Structure du livrable

- **Emplacement** : `CLAUDE.md`, `CONSTITUTION.md` ou `INTENTION.md`, à la racine du dépôt (pas de séquence, un fichier = un rôle fixe).

Chaque fichier garde une structure Markdown libre adaptée à son rôle (voir les fichiers existants), mais commence toujours par un bloc de citation en tête rappelant son rôle et le fait qu'il s'agit d'un fichier de harnais vivant.
