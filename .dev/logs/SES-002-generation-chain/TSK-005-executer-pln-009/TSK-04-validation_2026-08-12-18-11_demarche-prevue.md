# Démarche de validation, tâche 5 de SES-002

Écrite avant les contrôles. `MET-003` étape 4.

Les quatre premiers contrôles sont les critères de réussite déclarés par `PLN-009`.

1. **Chantier A** : chaque critère porte une référence, un énoncé vérifiable et un verdict binaire.
2. **Chantier B** : sur un emplacement inexistant, un dépôt vierge et ce dépôt-ci, trois diagnostics distincts.
3. **Chantier C** : après `init` en dépôt jetable, `check` répond « conforme ».
4. **Chantier D** : `install --dev` déclare le mode et ses cinq propriétés.
5. La cible mesurable du plan : `clia res ls` répond dans un dépôt instrumenté.
6. `SPC-001` P2 : un emplacement occupé est conservé et annoncé.
7. `SPC-001` P3 : l'empreinte du dépôt source est identique avant et après.
8. `SPC-001` P5 : un second `init` ne dégrade rien.
9. Le régime lié pose des liens relatifs, et le dépôt lié est utilisable.
10. `init` refuse le dépôt source comme cible, et refuse une option inconnue.
11. Un mode d'installation inconnu est refusé, code 2.
12. `SPC-001` est conforme à son schéma, et ses liens pointent sur des fichiers existants.
13. Ce dépôt-ci reste conforme à sa propre spécification.
14. Validation de schéma du dépôt entier : le nombre de non conformes n'augmente pas.
15. Suite de tests complète.
16. Toutes les écritures ont eu lieu en dépôt jetable ; aucun dépôt réel de `$HOME/git` n'est touché.
17. Le journal suit `MET-003`.
