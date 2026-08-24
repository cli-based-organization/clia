# Démarche de validation, tâche 35

Écrite avant les contrôles. `MET-003` étape 4.

1. Les six formes demandées existent et répondent.
2. L'aide est atteignable sur chaque verbe, y compris ceux qui exigent un argument.
3. La garde refuse `new`, `close` et `todo` à un agent, code 3, et ne crée rien.
4. `CLIA_ACTOR=human` lève la garde.
5. Le cycle complet fonctionne : `new`, `todo`, `ls`, `new` qui ferme, `close`.
6. `status` compte juste sur le dépôt réel, vérifié tâche par tâche à la main.
7. Une tâche sans message de commit n'est pas comptée faite.
8. Une rubrique de session n'est pas comptée comme tâche.
9. Une tâche écrite sans point après le numéro est comptée.
10. Les six tests de `clia git save` passent inchangés après le déplacement de la garde.
11. `RES-034` et `NON-037` sont conformes à leur schéma.
12. `cue vet` passe sur les schémas de session.
13. Les liens relatifs des deux documents pointent sur des fichiers existants.
14. Validation de schéma du dépôt entier : le nombre de non conformes n'augmente pas.
15. Suite de tests complète.
16. Les écritures sont éprouvées dans un dépôt jetable, jamais sur le dépôt réel.
17. Le journal suit `MET-003`.
