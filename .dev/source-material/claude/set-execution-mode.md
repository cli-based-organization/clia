Deux choses différentes bloquent l'exécution autonome : les demandes de permission d'outils, et les questions du modèle. Il faut traiter les deux.

La commande de base

claude -p "Exécuter la tâche 4"

-p (--print) affiche la réponse et sort. Le dialogue de confiance de l'espace de travail est sauté automatiquement en mode non interactif.

Les permissions — du plus sûr au plus permissif

# 1. Liste blanche explicite — recommandé
claude -p "..." --allowedTools "Read" "Edit" "Bash(git status:*)" "Bash(bash tests/*)"

# 2. Par mode
claude -p "..." --permission-mode acceptEdits     # accepte les éditions, demande le reste
claude -p "..." --permission-mode dontAsk         # ne demande rien, refuse ce qui n'est pas permis
claude -p "..." --permission-mode bypassPermissions  # ne vérifie rien

# 3. Court-circuit total
claude -p "..." --dangerously-skip-permissions

Les modes disponibles dans votre version (2.1.228) : acceptEdits, auto, bypassPermissions, manual, dontAsk, plan.

dontAsk est le bon compromis pour de l'automatisation : rien n'est demandé, mais ce qui n'est pas autorisé est refusé plutôt qu'exécuté — l'échec est visible au lieu d'être silencieusement contourné. bypassPermissions et --dangerously-skip-permissions n'ont de sens que dans un conteneur jetable.

Plus durable que les flags : .claude/settings.json avec permissions.allow et permissions.deny, qui vaut pour toutes les invocations du dépôt.

Pour que le modèle ne pose pas de questions

En -p, il n'y a personne pour répondre. Ajoutez la consigne explicitement :

claude -p "..." --append-system-prompt "Aucune question. En cas d'ambiguïté, choisis l'option la plus prudente, exécute, et consigne l'hypothèse retenue dans le journal."

Sortie exploitable par un script

claude -p "..." --output-format json | jq -r '.result'

Le piège dans ce dépôt

Vos propres gardes vont bloquer une exécution autonome. clia_acteur_est_agent (dans lib/clia/core.sh:76) détecte CLAUDECODE, qui est posé même en -p. Donc clia git save, clia ses new, close et switch refuseront avec le code 3, quelles que soient les permissions Claude Code accordées.

C'est voulu — CONSTITUTION.md C2 et C3. Mais si vous cherchez un pipeline qui va jusqu'au commit, il faudra soit poser CLIA_ACTOR=human (ce qui est une transgression de C2, pas un contournement prévu), soit décider explicitement qu'un agent non interactif est un acteur distinct. C'est une question de gouvernance, pas de configuration — et elle mériterait une DCN.

Pour les tâches longues

claude --bg "Exécuter les tâches 4 à 8"   # rend la main immédiatement
claude agents


Politique en place. Trois fichiers, tous versionnables (.claude/ n'est pas ignoré).

Ce qui a changé par rapport à ce que je vous avais proposé

Le deny que je vous avais montré ne marche pas. Je l'ai mesuré : deny: ["Bash(git commit:*)"] bloque git commit, mais git -C . commit crée le commit. Une règle deny ne compare que le début de la ligne. La seule règle qui tienne est Bash(git:*), qui interdit aussi status, log, diff — et comme deny l'emporte sur allow, impossible de rouvrir la lecture.

C2 est donc portée par un hook PreToolUse, qui lit la ligne entière. Une expression régulière n'a pas suffi non plus : la sous-commande git n'est pas le deuxième mot de la ligne, c'est le premier mot qui n'est ni une option globale ni la valeur d'une option globale. C'est un pa