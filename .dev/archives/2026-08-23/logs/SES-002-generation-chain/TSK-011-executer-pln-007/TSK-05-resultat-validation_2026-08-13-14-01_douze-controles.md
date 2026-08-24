# Résultat de la validation, tâche 11 de SES-002

`MET-003` étape 5.

| # | Contrôle | Résultat |
|---|---|---|
| 1 | Le blocage est réel | **Réussi** : `DCN-016` porte `effet: suspendue`, `ISU-009` est `ouverte` |
| 2 | Les deux chantiers satisfaits le sont | **Réussi** : `clia res check` signale 5 champs constants (G) ; `clia res ls objection` affiche 3 valeurs (F) |
| 3 | `PLN-007` n'est pas passé à `execute` | **Réussi**, `statut-plan: propose` |
| 4 | La correction fonctionne sur le cas réel | **Réussi** : `PLN-007 (prealable suspendu : DCN-016)` |
| 5 | Elle ne sur-déclenche pas | **Réussi** : les trois autres plans proposés gardent leur catégorie, `A EXECUTER` ne contient plus que `PLN-015` |
| 6 | Une décision en vigueur ne bloque rien | **Réussi**, éprouvé par le banc |
| 7 | La suite de tests | **Réussi, 279 assertions**, 275 → 279 |
| 8 | `BUG-004` conforme, liens valides | **Réussi**, 4 liens sur 4 |
| 9 | `BUG-004` se distingue de `BUG-002` | **Réussi** : tableau comparatif des causes |
| 10 | Le dépôt ne régresse pas | **Réussi** : 164 conformes, **17 non conformes, inchangé** |
| 11 | Le journal suit `MET-003` | **Réussi** : 13:53, 13:55, 13:58, 13:59, croissants |
| 12 | La tâche ne se déclare pas réussie | **Réussi** : le journal de fait ouvre sur l'échec |

## Ce que la file d'attente devient

```
avant :  A EXECUTER  2 plans  (PLN-007, PLN-015)
apres :  A EXECUTER  1 plan   (PLN-015)
```

**`PLN-007` quitte la deuxième place de la file de l'humain** pour se ranger là où il attend vraiment : une approbation de `DCN-016`.

**Le compteur d'items en attente ne bouge pas.** Le plan change de catégorie, il ne disparaît pas. C'est voulu : il reste du travail, seulement il n'est pas prêt.

## Ce que cette tâche n'a pas fait, et qui reste vrai

**`PLN-007` n'a pas avancé d'un chantier.** Cinq restent bloqués, et rien de ce qui a été livré aujourd'hui ne les débloque. La tâche a corrigé la façon dont le système présente ce blocage, pas le blocage lui-même.

**Le déblocage appartient à l'humain** : approuver `DCN-016`, ou la réviser. `DCN-013` pose l'approbation manuelle, `CONSTITUTION.md` C1 réserve les décisions.

**La détection reste partielle.** Un plan bloqué par une issue ouverte, ou par un point d'arrêt écrit en prose, passe toujours pour prêt. `BUG-004` reste `ouvert` pour cette raison, et le déclare.

**Un troisième bogue ouvert s'ajoute au dépôt.** `A CORRIGER` passe de 2 à 3. Le compteur monte encore — pour la même raison qu'à la tâche 9 : ce qui était invisible devient visible.
