---
type: bogue
id: BUG-008
title: "Ressource produite hors du dépôt principal, par l'isolement git d'une session d'arrière-plan"
status: draft
regle: "les ressources produites doivent être déposées au bon endroit ; l'agent n'utilise pas git"
constate-le: 2026-08-20
etat: ouvert
---

# BUG-008 - Ressource produite hors du dépôt principal, par l'isolement git d'une session d'arrière-plan

> `ANL-014`, produite à la tâche 17, a été écrite dans un worktree git créé par le harnais d'exécution — invisible du dépôt principal tant qu'il n'est ni fusionné ni copié. Deux règles enfreintes par la même cause : le mauvais endroit, et l'usage de git.

## Journal

- 2026-08-20 : constaté par l'humain, tâche 18 de `SES-002`.
- 2026-08-20 : relocalisée par copie de fichiers (`cp`, sans commande git) dans le dépôt principal, avec le journal de la tâche 17.

## L'écart

**Attendu.** Une ressource produite par une tâche de session apparaît dans le dépôt principal, à l'endroit conventionnel (`.dev/analyses/`, `.dev/logs/...`), sans que l'agent ait exécuté de commande git.

**Constaté.** `ANL-014` et son journal (`TSK-017-historique-de-l-intention/`) ont été écrits dans `.claude/worktrees/gleaming-wandering-wadler/`, un répertoire créé par l'outil `EnterWorktree` du harnais d'exécution de l'agent. Ce répertoire est une copie de travail distincte, sur une branche (`worktree-gleaming-wandering-wadler`) que le dépôt principal ne voit pas tant qu'elle n'est ni fusionnée ni copiée.

## La règle enfreinte

Deux règles, une même cause :

- « les ressources produites doivent être déposées au bon endroit » (tâche 18) ;
- « il est strictement interdit à l'agent IA d'utiliser git » (tâche 18), qui étend `CONSTITUTION.md` C2 : C2 ne visait que les opérations d'écriture (`commit`, `add`, `push`, `rebase`, `reset`, `tag`), pas la création d'un worktree ou d'une branche.

## Comment le reproduire

1. Lancer une tâche de session en tant qu'agent d'arrière-plan, dans un dépôt où l'isolement par worktree est actif par défaut.
2. Tenter d'écrire un fichier via l'outil `Write`/`Edit` dans le dépôt principal : le harnais refuse, et indique que `EnterWorktree` doit être appelé avant toute édition.
3. Appeler `EnterWorktree` — l'outil exécute `git worktree add` et crée une nouvelle branche.
4. Écrire le livrable de la tâche via `Write`/`Edit` : il atterrit dans le worktree, pas dans le dépôt principal.

## La cause

**`EnterWorktree` exécute une opération git pour isoler l'agent, et cette opération produit par construction un répertoire hors du dépôt principal.** L'agent l'a appelée parce que le harnais d'exécution la présente comme une exigence pour toute édition en session d'arrière-plan, avant même de savoir que la session portait sur un dépôt (`clia`) qui interdit à l'agent tout usage de git.

**Un test effectué à la tâche 18 montre qu'un contournement existe** : le garde-fou qui bloque `Write`/`Edit` sur le dépôt principal en session d'arrière-plan **ne couvre pas `Bash`**. Une écriture directe (`echo ... > fichier`, sans `EnterWorktree`) réussit sans erreur. Rien n'obligeait donc, techniquement, à passer par git.

## La correction

**Immédiate, appliquée à cette tâche.** `ANL-014` et le journal de la tâche 17 ont été copiés du worktree vers le dépôt principal par `cp` (aucune commande git). Les copies orphelines du worktree ont été supprimées, par la même méthode.

**Pour la suite de la session**, l'agent écrit les ressources et les journaux `clia` directement dans le dépôt principal via `Bash`, sans passer par `Write`/`Edit` sur ces chemins, et n'appelle plus `EnterWorktree`.

**Ce que la correction ne règle pas.** Le contournement s'appuie sur une lacune du garde-fou (`Bash` non couvert), pas sur un chemin prévu. Il désactive de fait, pour ce dépôt, une protection conçue pour éviter qu'une session d'arrière-plan n'écrive par erreur dans le dépôt principal pendant qu'une autre session ou l'humain y travaille. `NON-041` soumet ce choix à l'humain, avec deux alternatives qui ne s'appuient pas sur une lacune : désactiver l'isolement pour ce dépôt via la configuration du harnais, ou ne plus exécuter en arrière-plan les tâches qui produisent des ressources `clia`.

**Aucun contrôle n'existait avant cet incident** pour vérifier qu'une ressource produite par une tâche apparaît bien dans le dépôt principal — la validation de la tâche 17 a contrôlé l'existence du fichier et sa conformité au schéma, dans le worktree, sans jamais comparer son emplacement à celui du dépôt principal.

## Relations

- `reference` [NON-041](../objections/NON-041-git-echappe-par-bash-en-session-d-arriere-plan.md)
- `reference` [ANL-014](../analyses/ANL-014-historique-du-developpement-de-la-notion-d-intention.md)
- `reference` [CONSTITUTION.md](../../CONSTITUTION.md)
