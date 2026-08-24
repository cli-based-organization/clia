# Ce qui a été fait, tâche 18 de SES-002

`MET-003` étape 3.

## Le grief, corrigé dans l'immédiat

`ANL-014` et le journal de la tâche 17 (`TSK-017-historique-de-l-intention/`), écrits par erreur dans un worktree git à la tâche précédente, ont été relocalisés dans le dépôt principal par `cp` — aucune commande git. Les copies orphelines du worktree ont été supprimées, par la même méthode. `git status` dans le worktree ne rapporte plus aucun changement.

## Les livrables

**`BUG-008`**, dans `.dev/bogues/` : documente l'écart, sa cause (`EnterWorktree` exécute une opération git qui produit par construction un répertoire hors du dépôt principal) et la correction appliquée.

**`NON-041`**, dans `.dev/objections/` : soumet à l'humain le choix entre trois issues pour la suite — accepter l'écriture directe par `Bash` comme pratique, désactiver l'isolement pour ce dépôt via la configuration du harnais, ou ne plus exécuter en arrière-plan les tâches productrices de ressources `clia`. `effet: suspendue`, l'agent applique par défaut la première option en best-effort documenté jusqu'à arbitrage.

## Comment s'en servir

À partir de cette tâche, et jusqu'à ce que `NON-041` soit levée, l'agent écrit les ressources et journaux `clia` de cette session directement dans le dépôt principal via `Bash`, sans `Write`/`Edit` sur ces chemins, et sans appeler `EnterWorktree`.
