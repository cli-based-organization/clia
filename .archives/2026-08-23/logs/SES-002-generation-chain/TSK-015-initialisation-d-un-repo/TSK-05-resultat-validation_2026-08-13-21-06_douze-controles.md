# Résultat de la validation, tâche 15 de SES-002

`MET-003` étape 5.

| # | Contrôle | Résultat |
|---|---|---|
| 1 | Les deux livrables existent | **Réussi** : `BUG-006`, `PLN-017` |
| 2 | Les défauts sont mesurés, non déduits | **Réussi** : cinq mesures sur le dépôt réel |
| 3 | Le troisième défaut est réel | **Réussi** : `diff` vide sur `CLAUDE.md` aussi |
| 4 | `PLN-017` satisfait `PDC-003` | **Réussi** : 4 chantiers, 4 livrables, 4 critères, 4 limites |
| 5 | Les critères sont exécutables | **Réussi** : chacun nomme une commande et une sortie |
| 6 | Les six exigences sont couvertes ou déclarées sorties | **Réussi**, 5 couvertes, 1 sortie avec son motif |
| 7 | Le plan n'est pas exécuté | **Réussi**, `statut-plan: propose` |
| 8 | Conformité et liens | **Réussi**, 2 sur 2, aucun lien cassé |
| 9 | La suite de tests | **Réussi, 308 assertions**, inchangé |
| 10 | Le dépôt ne régresse pas | **Réussi** : 170 conformes, **20 non conformes, inchangé** |
| 11 | `clia focus` voit les deux documents | **Réussi** : `BUG-006` à corriger, `PLN-017` à exécuter |
| 12 | Le journal suit `MET-003` | **Réussi** : 20:43, 20:47, 21:03, 21:05 |

## Le contrôle 6, exigence par exigence

| Exigence de l'humain | Où elle vit |
|---|---|
| Harnais depuis un YAML + gabarit | Chantiers A et B |
| Fournir une constitution | Chantier A, gabarit à écrire |
| `ARCHITECTURE.md` optionnel | Chantier A, déclaré dans le tableau des régimes |
| `INTENTION.md` → lien vers `INT-001` | Chantier C |
| `INTENTION.md` est un gabarit vide | Chantier C, dans le critère |
| Un `INTENTION.md` existant est déplacé puis lié | Chantier D |

**La septième — les skills — est sortie du plan**, avec son motif : `ADR-016` D3 les déclare dérivables, aucun générateur n'existe, et `ISU-002` porte ce manque depuis le 2026-08-11. Aucun critère exécutable ne peut être écrit tant que la règle de dérivation n'est pas établie.

## Ce que la mesure a ajouté au rapport de l'humain

**`CLAUDE.md` du dépôt neuf est identique à celui de `clia`**, exactement comme `INTENTION.md`. L'humain n'a relevé que le second.

C'est le même défaut et la même cause. Il entre dans le périmètre du bogue, et la remédiation demandée le couvre déjà : un harnais généré ne peut pas être identique à sa source.

## Ce que la validation n'établit pas

**Que le plan soit exécutable en neuf heures.** Aucune durée du dépôt n'a jamais été mesurée ; les quatre estimations sont déclarées telles quelles, comme celles de `PLN-007`.

**Que la génération ne casse pas ce qui marche.** `clia setup init` a été validé par la tâche 5 et fonctionne. Le chantier B change son régime ; son critère l'éprouve sur un dépôt jetable, non sur un dépôt réel.

**Que le gabarit de constitution soit légitime.** Une constitution est un document d'autorité, et `CONSTITUTION.md` C1 réserve les décisions à l'humain. Le chantier A produit un gabarit, non une constitution en vigueur — la distinction tient tant que le gabarit ne pose aucune règle que l'humain n'a pas voulue. C'est déclaré dans les objections du plan.

**Que `clia-repos` soit réparé.** Le plan livre le mécanisme ; l'appliquer à ce dépôt-là est un geste de l'humain, sur son dépôt.
