# Résultat de la validation, tâche 1 de SES-002

| # | Contrôle | Résultat |
|---|---|---|
| 1 | **A** : cinq rubriques dont le critère de convergence | **Réussi** |
| 2 | **B** : `ls` affiche toutes les sessions | **Réussi**, 2 sur 2 |
| 3 | **C** : `new` pose un lien relatif vers l'énoncé neuf | **Réussi** |
| 4 | **D** : `switch` ne touche aucun `etat` | **Réussi**, relevé avant et après |
| 5 | **E** : `RES-032` déclare l'énoncé et le lien | **Réussi** |
| 6 | **F** : plus d'avertissement mensonger | **Réussi**, 0 occurrence |
| 7 | Le lien relatif survit au déplacement | **Réussi**, dépôt déplacé |
| 8 | Un fichier ordinaire non vide est préservé | **Réussi**, code 1 |
| 9 | Un lien cassé est signalé | **Réussi** |
| 10 | `switch` : alias, numéro, slug, refus d'agent | **Réussi** |
| 11 | Un énoncé sans frontmatter garde son numéro | **Réussi**, après correction |
| 12 | `PLN-008` satisfait `PDC-003` | **Réussi**, 6 livrables, 6 critères, 6 limites |
| 13 | Un seul `NON` pour le non-SMART | **Réussi** |
| 14 | Conformité et liens de `PLN-008` et `NON-038` | **Réussi**, après une correction |
| 15 | Schéma du dépôt entier | **157 conformes, 8 non conformes** |
| 16 | Suite de tests | **Réussi, 212 assertions** |
| 17 | Le lien réel n'est pas touché | **Réussi**, toujours absolu |
| 18 | Journal `MET-003` | **Réussi** |
| 19 | Les réponses à `NON-037`, arrivées en cours de tâche | **Réussi**, cinq prises en compte |
| 20 | `open` devient `opened` partout, instance comprise | **Réussi**, 17 occurrences |
| 21 | Les deux `ISU` demandés sont ouverts | **Réussi**, `ISU-010`, `ISU-011` |
| 22 | `CLAUDE.md` n'est pas modifié | **Réussi**, aucun diff |

## Ce que les contrôles ont trouvé

**Contrôle 11, avant d'être réussi.** `SES-001` porte un énoncé déposé à la main, sans frontmatter. Le module l'affichait comme `(vivant)` : mon repli d'identification supposait qu'un fichier sans `id` était forcément le fichier vivant.

**C'est la même erreur de raisonnement deux jours de suite** : supposer que ce que je n'ai pas prévu n'existe pas. Hier c'était le point après le numéro de tâche, aujourd'hui c'est un énoncé sans frontmatter.

**Contrôle 14.** `PLN-008` renvoyait à `PDC-003-regime-smart-des-plans.md` ; le fichier s'appelle `PDC-003-smart-et-extreme-smart.md`. Le plan affirmait aussi être « le sixième non exécuté » : quatre plans sur huit sont jamais engagés, `PLN-004` étant abandonné et deux exécutés.

**Contrôle 17.** Le lien réel reste absolu. Le convertir serait modifier le point d'entrée déclaré du système sans qu'on l'ait demandé. Il deviendra relatif au premier `new` ou `switch` de l'humain.

## Une régression que les contrôles ne signalent pas comme un échec

**L'avancement de `SES-001` s'affiche à 10 sur 35, alors que 32 tâches sont faites.**

Aucun contrôle ne l'attrape, parce que le comportement est **conforme à la conception** : un énoncé lit son propre répertoire de journal, et les tâches 1 à 24 vivent dans un second répertoire au format antérieur à `MET-003`.

**Hier le chiffre était juste par accident** : faute d'énoncé, le repli lisait tous les journaux du dépôt.

C'est déclaré dans `NON-038` Q2, avec la mesure.

## Ce que la validation ne couvre pas

**Aucun contrôle ne vérifie qu'un critère de convergence est écrit.** La rubrique est obligatoire ; `clia ses close` ferme sans la regarder. L'humain a répondu de ne pas l'implémenter maintenant : `ISU-010`.

**Le comportement en dépôt vierge n'est éprouvé que par les tests.** Aucun dépôt tiers n'a servi, alors que l'intention de `SES-002` est précisément l'usage dans n'importe quel dépôt.

## Un contrôle qui manquait à la démarche

**Je n'ai vérifié qu'une fois, au début, que `NON-037` ne portait pas de réponse.** Les cinq réponses sont arrivées pendant l'implémentation, et je ne les ai vues qu'à la clôture, en relevant l'état git.

Le contrôle manquant : **relire les objections concernées avant de clore**, pas seulement avant de commencer. Il est ajouté ici en tant que constat, pas en tant que règle : rien ne l'impose encore.
