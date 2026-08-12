# Analyse, tâche 3 de SES-002

`MET-003` étape 2.

## Vérification des six critères de réussite déclarés par PLN-008

| Chantier | Critère déclaré | Vérifié |
|---|---|---|
| A | Un énoncé neuf porte cinq rubriques dont `CRITÈRES DE CONVERGENCE` | À reconfirmer |
| B | `clia ses ls` affiche toutes les sessions du dépôt | À reconfirmer |
| C | `readlink workspace/session.md` désigne l'énoncé neuf après `new` | À reconfirmer |
| D | `switch` change le lien et aucun champ `etat` | À reconfirmer |
| E | `RES-032` déclare l'énoncé et le lien | À reconfirmer |
| F | `clia ses status` n'affiche plus « session non enregistree » sur ce dépôt | À reconfirmer |

Tous ont été exécutés et contrôlés pendant la tâche 1, avant l'arrivée des réponses à `NON-037`. Les réponses ont fait évoluer `open` en `opened` et resserré `NON-038`, sans toucher aux six chantiers eux-mêmes. Une reconfirmation à froid, plutôt qu'une confiance dans le contrôle d'hier, est le geste correct : la valeur `etat` a changé depuis.

## Le défaut trouvé

`statut-plan: propose` dans le frontmatter, alors que la section « Statut » du corps affirme « exécuté dans la foulée ». Écart entre un champ et le texte qui l'accompagne, la définition même du type `bogue` créé à la tâche 34. Il n'est pas ouvert comme `BUG` ici : c'est une correction directe d'un document que j'ai moi-même produit hier, pas un écart tiers à consigner.
