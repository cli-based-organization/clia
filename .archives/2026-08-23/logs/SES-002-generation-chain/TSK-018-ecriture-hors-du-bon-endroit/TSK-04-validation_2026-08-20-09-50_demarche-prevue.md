# Démarche de validation, tâche 18 de SES-002

`MET-003` étape 4. Écrite avant l'exécution des contrôles.

1. `ANL-014` et le journal `TSK-017` existent dans le dépôt principal (`.dev/analyses/`, `.dev/logs/SES-002-generation-chain/`), pas seulement dans le worktree.
2. Le worktree ne contient plus de copie orpheline de ces fichiers (`git status` y est propre).
3. `BUG-008` et `NON-041` existent dans le dépôt principal, respectent leur schéma (frontmatter, sections requises), et leurs liens croisés pointent l'un vers l'autre.
4. `clia res ls BUG` et `clia res ls NON` affichent les deux nouvelles ressources, depuis le dépôt principal.
5. Aucune commande git n'a été exécutée pour produire ou déplacer ces fichiers — seulement `mkdir`, `cp`, `rm`, `cat`.
6. Le journal de la tâche 18 suit `MET-003` : horodatages distincts et croissants, tous dans le dépôt principal.
