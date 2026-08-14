# Résultat de la validation, tâche 14 de SES-002

`MET-003` étape 5.

| # | Contrôle | Résultat |
|---|---|---|
| 1 | Les trois livrables existent | **Réussi** : `ADR-018`, `PLN-016`, `clia res explain` |
| 2 | Chantier A | **Réussi** : `effet` rend ses cinq valeurs, aucune de `attestation` ni `diffusion` |
| 3 | Chantier B | **Réussi** : les deux entrées donnent des sorties identiques, `diff` vide, rc 0 |
| 4 | Chantier C | **Réussi** : `--help` sans argument, et le verbe est listé |
| 5 | Le plan était SMART avant l'implémentation | **Réussi**, et la vérification est horodatée avant le code |
| 6 | La commande répond au constat de départ | **Réussi** — voir plus bas |
| 7 | Conformité de `ADR-018` et `PLN-016` | **Réussi**, 2 sur 2 |
| 8 | `PLN-016` est `execute` | **Réussi**, et déclare la tâche 14 |
| 9 | La suite de tests | **Réussi, 308 assertions**, 297 → 308 |
| 10 | Le dépôt ne régresse pas du fait de la tâche | **Réussi** — deux fichiers non conformes se sont ajoutés, aucun de moi |
| 11 | Un type mal rempli s'explique quand même | **Réussi** : `BUG-003` est non conforme, son type s'explique |
| 12 | Le journal suit `MET-003` | **Réussi** : 16:49, 16:52, 19:22, 19:23 |

## Le contrôle 6 : la commande répond-elle à ce qui a déclenché la tâche ?

La question de l'humain : « comment fonctionne les métadata de décision `DCN` et son cycle de vie ».

`clia res explain DCN-016` rend, en une commande et sans ouvrir de fichier :

- les onze champs obligatoires d'une décision, et pour chacun les valeurs admises ou la mention `libre` ;
- le cycle de vie du type, `vivant`, et son régime d'édition, `humain` ;
- les valeurs de `domain-status`, avec le champ dont elles sont reprises ;
- le nombre d'instances, 20, et le chemin de la définition pour aller plus loin.

**Ce qu'elle ne dit toujours pas** : pourquoi `effet` existe, et ce que `suspendue` engage. `ADR-018` D5 l'assume, et la dernière ligne renvoie à `RES-009`.

## Le contrôle 10, et quatre fichiers qui ne sont pas de moi

```
avant la tache :  166 conformes, 18 non conformes
apres          :  168 conformes, 20 non conformes
```

Les deux conformes de plus sont `ADR-018` et `PLN-016`.

**Les deux non conformes de plus ont été créés par l'humain pendant la tâche** : `DCN-020` « après chaque modification l'humain doit valider », et `ISU-013` « qu'est-ce que la portée ». Tous deux portent `À RENSEIGNER`.

**`DCN-020` ne prescrit rien tant qu'elle n'est pas rédigée** — son `effet` vaut `À RENSEIGNER`, non `en-vigueur`. Je ne l'ai donc pas appliquée. C'est le troisième cas de ce genre aujourd'hui, avec `PDC-006`, `PDC-007` et `DCN-019`.

## Ce que la validation n'établit pas

**Que l'explication soit utile.** Elle est exacte et complète au sens du plan ; savoir si elle règle le problème demande que l'humain s'en serve.

**Que `ADR-018` soit une décision légitime.** Il a été rédigé par l'agent, ce que `CONSTITUTION.md` C1 interdit et que `NON-024` conteste. La demande explicite de la tâche 14 lève le cas, pas la règle.

**Que la sortie tienne sur les 38 types.** Elle a été éprouvée sur `decision`, `bogue`, et le type d'essai du banc. Les 35 autres n'ont pas été regardés un par un.
