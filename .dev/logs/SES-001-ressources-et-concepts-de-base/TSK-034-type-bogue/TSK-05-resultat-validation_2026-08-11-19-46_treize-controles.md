# Résultat de la validation, tâche 34

| # | Contrôle | Résultat |
|---|---|---|
| 1 | Définition tirée de cas réels | **Réussi**, sept écarts cités |
| 2 | Frontière avec `ISU`, `CMP`, `NON` | **Réussi**, écrite, sans recoupement |
| 3 | Gabarit `skl-001` B3, sans rubrique méta | **Réussi**, 0 rubrique méta |
| 4 | Schéma de `RES-036` et `NON-036` | **Réussi** |
| 5 | `cue vet` sur les deux schémas | **Réussi** |
| 6 | Type reconnu par `clia res ls` | **Réussi** |
| 7 | `clia res new bogue` produit 7 champs et 7 sections | **Réussi** |
| 8 | Numéro 001 libre | **Réussi**, `.dev/bogues/` vide |
| 9 | Choix du modèle déclaré | **Réussi**, avec motif |
| 10 | Liens relatifs | **Réussi** |
| 11 | Schéma du dépôt entier | **154 conformes, 8 non conformes** |
| 12 | Suite de tests | **Réussi**, 144 assertions |
| 13 | Journal `MET-003` | **Réussi**, sept fichiers |

## Le seul contrôle qui signale quelque chose

Les huit non conformes sont **antérieurs à cette tâche**. Ce sont les `DCN` rédigées par l'humain qui portent `À RENSEIGNER` sur `attestation`, `diffusion` et `effet`.

**Les deux documents produits ici sont conformes.** Le nombre de non conformes est le même qu'avant la tâche.

## Ce que la validation ne couvre pas

**Aucun contrôle ne vérifie que la frontière tient à l'usage.** Elle est écrite ; rien ne dit qu'un défaut réel se rangera sans hésitation d'un côté. `NON-036` Q1 porte le cas limite : un défaut sans règle écrite.

**Le type n'a aucune instance.** Sept écarts réels existent, et aucun n'est consigné : le type n'a jamais servi.
