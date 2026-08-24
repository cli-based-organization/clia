# Démarche de validation, tâches 20 et 21

## Validation de la règle

1. Vérification que `CONSTITUTION.md` porte les deux interdits demandés, sur les décisions et sur `clia git save`, et l'extension aux principes de conception.
2. Vérification que `RES-009` et `RES-012` déclarent `edition: humain`, et que leur section de régime d'édition dit qui fait quoi.
3. Vérification que les commentaires des schémas dérivés sont alignés.
4. Vérification que `RES-016` passe à `actif`, le fichier existant désormais.
5. Vérification que `skl-003` et `skl-004` portent la règle.

## Validation de la garde C2

6. Épreuve de `clia git save` avec un marqueur d'environnement d'agent : refus attendu, code 3.
7. Épreuve avec `CLIA_ACTOR=agent` : même refus.
8. Épreuve de `clia git log` et `clia git check` dans le même environnement : permis attendu.
9. Vérification que `clia git save --help` déclare la réserve à l'humain.
10. Vérification que les six épreuves tournent dans un dépôt jetable, jamais sur le dépôt du projet.

## Validation du relevé de l'existant

11. Décompte des `DCN` et `PDC` du dépôt, et de leur champ `effet`.
12. Vérification de la citation de la constitution archivée, par lecture du fichier.
13. Vérification que l'agent n'a modifié aucune des douze instances existantes.
14. Vérification que le commit accidentel a bien été annulé et que `HEAD` égale la référence distante.

## Validation du bogue corrigé

15. Régénération d'un gabarit après correction, contrôle du champ `type` et du champ `id`.
16. Vérification que la dérivation du nom canonique fonctionne pour un type à nom composé.
17. Suite de tests complète, y compris les deux tests périmés alignés sur `ADR-008`.

## Validation de la tâche 21

18. Vérification que chaque décision de `ADR-016` cite la réponse de l'humain qui la fonde.
19. Vérification que `RES-003` retire le champ des obligatoires et que `intention.cue` est aligné.
20. Vérification que `RES-018` passe en `edition: ia`.
21. Vérification que `NON-002` passe à `repondue` sans que ses blocs de réponse soient modifiés.
22. Vérification qu'aucune `DCN` n'a été rédigée par l'agent, et que le gabarit `DCN-011` porte ses champs `À RENSEIGNER`.

## Validation d'ensemble

23. Validation de schéma du dépôt entier.
24. Vérification des liens relatifs des documents créés et modifiés.
25. Contrôle `V10` sur les définitions touchées.
