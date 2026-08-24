# Ce qui a été fait, tâche 2 de SES-002

`MET-003` étape 3.

## Chantier G seul, chantiers A à F non exécutés

**Le blocage de `DCN-016` suspendue n'a pas été levé unilatéralement.** Les chantiers A à F de `PLN-007` ne sont pas exécutés : ils appliqueraient au dépôt entier une décision que le système lui-même tient pour non active.

## `clia resource check`, verbe neuf

Signale un champ obligatoire constant sur toutes les instances d'un type, à deux instances ou plus.

```
$ clia res check
TYPE       CHAMP     VALEUR  INSTANCES
ressource  status    draft   36
objection  status    draft   38
...
issue      etat      ouverte 11
```

**Il retrouve le défaut mesuré à la main par `NON-035`**, et plusieurs autres du même ordre : `initiateur` toujours `agent` sur les huit plans, `etat` toujours `ouverte` sur les onze issues, `statut-decision` toujours `propose` sur les dix-sept ADR.

**Aucun de ces défauts n'était visible avant ce contrôle**, hors celui que `NON-035` avait mesuré à la main un par un.

Code de retour 1 si un champ constant est trouvé, 0 sinon : la commande peut servir de garde dans un script, à défaut de `clia validate`, que `ISU-007` réclame séparément.

## Ce qui n'a pas été fait, et pourquoi

**Les chantiers A, B, C, D, E, F.** Ils appliquent `DCN-016`, décision suspendue. Le plan porte lui-même l'objection : l'exécuter avant approbation reviendrait à traiter un premier jet comme une décision.

## Livrables

| Fichier | Nature |
|---|---|
| `lib/clia/resource.sh` | Verbe `check`, aide |
| `tests/test_clia.sh` | **7 assertions**, 212 → 219 |
