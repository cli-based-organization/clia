# Démarche de validation, tâche 2 de SES-002

1. `check` retrouve le défaut `status` mesuré par `NON-035` sur le dépôt réel.
2. `check` sur un type précis se limite à ce type.
3. `check` sur un type à moins de deux instances ne signale rien.
4. Un champ qui varie sort du rapport dès qu'une instance diffère.
5. Code de retour 1 si un champ constant est trouvé, 0 sinon.
6. `check` sur un type inconnu ne signale rien, code 0, sans erreur.
7. Le champ `type` n'est jamais signalé.
8. Le code de `check` ne nomme ni ne suppose aucun des quatre champs de `DCN-016`.
9. Aide atteignable sur le verbe.
10. Validation de schéma du dépôt entier : le nombre de non conformes n'augmente pas.
11. Suite de tests complète.
12. Le journal suit `MET-003`.
