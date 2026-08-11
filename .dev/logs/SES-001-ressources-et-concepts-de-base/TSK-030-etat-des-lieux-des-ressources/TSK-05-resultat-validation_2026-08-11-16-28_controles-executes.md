# Résultat de la validation, tâche 30

## Bilan

| Contrôle | Résultat |
|---|---|
| Schéma des trois documents créés | **conformes** |
| Schéma, dépôt entier | **145 conformes, 7 non conformes** |
| Objections fermées par le ménage | **0** |
| Plans portant le constat de limite de temps | **6 sur 6** |
| Tests du CLI | **144 réussis, 0 échoué** |

Les sept non-conformités sont les gabarits en attente de l'humain, inchangées.

## Une mesure qui a bougé pendant la tâche

`ANL-009` mesure 150 documents actifs dont 136 traitant des ressources. Le recalcul après production donne **153 et 139**.

L'écart est exactement les trois documents que la tâche a produits : `ANL-009`, `PLN-006` et `ISU-007`.

**La mesure de l'analyse est donc datée d'avant sa propre production**, ce qui est correct pour un état des lieux et mérite d'être dit : une analyse qui se compterait elle-même mesurerait son effet, non l'état.

## Le ménage, vérifié

| Mesure | Avant | Après |
|---|---|---|
| Objections répondues | 4 | **5** |
| Objections ouvertes | 29 | **28** |
| Effet `conditionnel` | 19 | 18 |
| Effet `informatif` | 6 | 7 |

Le seul mouvement est `NON-026`, dont l'état était faux. **Aucune objection n'a été fermée.**

Les quatre autres interventions du ménage ajoutent des entrées de journal et des renvois croisés, sans changer aucun état.

## Ce que le ménage n'a pas fait, et pourquoi

**Fermer `NON-014` et `NON-011`.** Leur objet a changé depuis leur ouverture : `ADR-008` a tranché l'identité, et trente-six types sont définis contre sept. Leur question subsiste sous une autre forme, et les fermer aurait été décider à la place de l'humain.

**Fusionner les doublons.** `NON-025` et `NON-030` posent la même question, mais la première porte deux questions propres aux skills que la seconde ne reprend pas. Les croiser conserve les deux ; les fusionner en perdrait.

## Le plan et l'issue

`PLN-006` porte cinq chantiers, tous avec un livrable unique et un critère de réussite, et tous exécutés.

Il ne contient aucun chantier non implémentable, ce qui était le point à trancher de l'énoncé.

`ISU-007` porte les deux axes sans issue, A7 et A9, et aucun des quatre déjà couverts par `ISU-002` à `ISU-005`.

## Ce que la validation n'établit pas

**Que les neuf axes soient le bon découpage.** Ils sont tirés des problématiques observées, et `ANL-009` déclare que trois se recouvrent partiellement.

**Que le seuil de trois mentions soit pertinent.** Un document qui parle de la ressource une seule fois, de façon décisive, n'est pas compté.

**Que `PLN-006` serve à quelque chose.** Il est produit et exécuté dans la même tâche. Sa valeur est de dire ce qui a été laissé de côté, non ce qui a été fait, et son objection le déclare.

**Que le ménage suffise.** Vingt-huit objections restent ouvertes, dont huit bloquantes. Le ménage a corrigé des états, pas réduit la charge.
