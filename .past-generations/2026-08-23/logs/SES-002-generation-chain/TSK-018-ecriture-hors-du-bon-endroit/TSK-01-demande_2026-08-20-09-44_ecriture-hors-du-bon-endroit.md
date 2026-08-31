# La demande, tâche 18 de SES-002

`MET-003` étape 1.

## L'énoncé, repris sans reformulation

> ## 18. [bogue] écriture d'un fichier dans un autre worktree
>
> Voici le comportement attendu:
>
> - les ressources produites doivent être déposé au "bon endroit"
> - il est strictement INTERDIT à l'agent IA d'utiliser git

## Ce que je comprends

**Le grief porte sur la tâche 17.** `ANL-014` et son journal ont été écrits dans `.claude/worktrees/gleaming-wandering-wadler/`, un worktree git créé par l'outil `EnterWorktree` de mon propre harnais d'exécution — invisible du dépôt principal tant qu'il n'est ni commité ni fusionné. Le grief est fondé : l'humain qui va lire `ANL-014` au dépôt principal ne le trouve pas.

**Deux règles distinctes, pas une seule.**

| Règle | Ce qu'elle exige |
|---|---|
| « Le bon endroit » | Une ressource produite doit apparaître dans le dépôt principal, pas dans une copie annexe |
| « Interdit d'utiliser git » | Aucune commande git, sous aucune forme — plus large que `CONSTITUTION.md` C2, qui ne vise que les opérations d'écriture (`commit`, `add`, `push`, `rebase`, `reset`, `tag`) |

**La cause tient aux deux règles à la fois.** `EnterWorktree` exécute `git worktree add` et crée une branche (`worktree-gleaming-wandering-wadler`) — c'est une opération git, même si elle n'écrit rien dans l'historique du dépôt principal. Et le résultat de cette opération est un répertoire distinct du dépôt principal : le fichier produit n'est donc pas « au bon endroit », par construction.

## Le livrable

Un `BUG` documentant l'incident, sa cause, et une correction. Prochain identifiant : `BUG-008`.

## Ce que je vérifie avant d'aller plus loin

**Est-ce que l'outil `Write`/`Edit` est seul à bloquer l'écriture directe dans le dépôt principal, ou est-ce que `Bash` l'est aussi ?** C'est la question technique qui détermine si une correction existe sans toucher aux réglages du harnais. Je le teste avant d'écrire l'analyse.
