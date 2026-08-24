# Démarche de validation, tâche 1 de SES-002

Écrite avant les contrôles. `MET-003` étape 4.

Les six premiers contrôles sont les critères exécutables déclarés par `PLN-008`.

1. **Chantier A** : un énoncé neuf porte cinq rubriques dont `CRITÈRES DE CONVERGENCE`.
2. **Chantier B** : `clia ses ls` affiche toutes les sessions du dépôt.
3. **Chantier C** : après `new`, `readlink workspace/session.md` désigne l'énoncé neuf, et le lien est relatif.
4. **Chantier D** : `switch` change le lien et aucun champ `etat`.
5. **Chantier E** : `RES-032` déclare l'énoncé et le lien.
6. **Chantier F** : `clia ses status` sur ce dépôt n'affiche plus « session non enregistree ».
7. Le lien relatif survit au déplacement du dépôt.
8. Le point d'entrée ne s'écrase pas : un fichier ordinaire non vide est préservé.
9. Un lien cassé est signalé, non silencieux.
10. `switch` accepte l'alias, le numéro seul et le slug ; il refuse un agent, code 3.
11. Un énoncé sans frontmatter garde son numéro et déclare son état inconnu.
12. `PLN-008` satisfait les trois contrôles de `PDC-003` : livrable unique, critère exécutable, limite déclarée.
13. Tout ce qui n'est pas SMART tient dans **un seul** `NON`.
14. `PLN-008` et `NON-038` sont conformes à leur schéma, et leurs liens pointent sur des fichiers existants.
15. Validation de schéma du dépôt entier : le nombre de non conformes n'augmente pas.
16. Suite de tests complète.
17. Les écritures sont éprouvées en dépôt jetable ; le lien réel n'est pas touché.
18. Le journal suit `MET-003`.
