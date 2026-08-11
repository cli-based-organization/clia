# Résultat de la validation, tâches 23 et 24

## Bilan

| Contrôle | Résultat |
|---|---|
| Schéma, dépôt entier | **117 conformes, 5 non conformes** |
| Schéma, les cinq documents produits | **5 sur 5 conformes** |
| Liens relatifs | **0 cassé** |
| `RES-031` contre le gabarit `skl-001` B3 | **conforme**, 11 rubriques |
| `V10` sur `RES-031` | **0 rubrique méta** |
| Tests du CLI | **124 réussis, 0 échoué** |
| Chantiers de `PLN-003` exécutés | **0** |
| `DCN` rédigées par l'agent | **0** |

## Les cinq non-conformités de schéma

Toutes sont des gabarits en attente de leur initiateur.

| Fichier | Origine |
|---|---|
| `DCN-011`, `DCN-012` | Gabarits laissés par l'agent aux tâches 21 et 22, par C1 |
| `DCN-013` | **Écrite par l'humain**, cinq champs `À RENSEIGNER` dont son propre `effet` |
| `FRG-001`, `NON-013` | Fichiers de l'humain, inchangés depuis la tâche 13 |

`DCN-013` est le cas notable : la décision qui fait de la `DCN` l'autorité ultime ne déclare pas son propre état. `PLN-003` chantier C lui est applicable en premier.

## Le type ISU

Contrôles 1 à 6.

`clia res ls` affiche le type avec ses propriétés : `ISU`, cycle `travail`, édition `hybride`, définition `RES-031-issue`.

`clia res new issue` produit un frontmatter à sept champs et les sept sections déclarées. L'instance d'essai a été supprimée : le numéro 001 reste libre.

Le type ne porte pas de champ `version`, son cycle étant `travail`. C'est le troisième type dans ce cas, avec l'objection et le plan.

## PDC-003

Contrôles 7 à 10.

Le document déclare son régime non actif dans son deuxième paragraphe de tête, avant toute autre lecture.

Les cinq critères portent chacun leur régime. Deux sont contraints dans les deux régimes, un l'est dans l'extrême seulement, un est mesuré sans bloquer, et un est **sans objet** en régime SMART, ce qui était exactement le reproche de l'objection archivée.

**La mesure sur les plans est vérifiée.** `PLN-001` et `PLN-002` ne déclarent aucune limite de temps, portent respectivement deux et huit livrables, et leurs critères de réussite demandent une lecture. Les deux échouent aux trois contrôles.

La résolution archivée contraire, `ANL-016`, est citée dans `NON-027` Q2 avec son texte.

## Les mesures d'ANL-006, recomptées

Contrôle 11. Trois affirmations de la première rédaction étaient fausses et ont été corrigées.

| Affirmation initiale | Mesure vérifiée |
|---|---|
| 5 ADR déclarant une source | **6** |
| 32 gabarits | **30** |
| « environ 40 renvois » | **248**, dans 58 fichiers |

La dernière correction est d'un facteur six. Elle change la lecture du chantier E de `PLN-003`, qui passe d'un travail de relecture à une migration comparable à celle de la tâche 13.

Les autres mesures sont confirmées : 17 ADR, 62 schémas, 31 définitions, 13 instances `DCN`.

## Les citations

Contrôle 12. Les citations de `DCN-013` et des cinq réponses de `NON-026` sont exactes, y compris leurs fautes de frappe, reproduites telles quelles.

Contrôle 13. Trois interprétations de l'agent sont signalées comme telles dans `ANL-006` : la protection portant sur l'intention plutôt que sur la rédaction, la lecture du champ manquant comme motif d'inactivité, et la fonction rétroactive des fichiers `*.input.cue`.

Contrôle 14. Les limites déclarent que la réponse Q3 est inachevée : elle ouvre une énumération et s'arrête au point 2, et porte elle-même un `todo`.

## Le conflit d'intérêt, déclaré

Contrôle 17. `PLN-003` porte en première objection que son chantier A lève un interdit qui vise l'agent, et que c'est l'agent qui le propose.

`ANL-006` le porte aussi dans ses limites : trois des huit implications élargissent ce que l'agent peut faire, et l'agent est celui qui les interprète.

## Portée respectée

Contrôles 22 à 24.

Aucun chantier de `PLN-003` n'est exécuté. `CONSTITUTION.md` n'est pas modifié, et le conflit avec `DCN-013` reste actif.

Aucune `DCN` n'a été rédigée.

Ni `PLN-001` ni `PLN-002` n'ont été mis en conformité avec `PDC-003`.

## Ce que la validation n'établit pas

**Si `PDC-003` pouvait être produit.** L'analogie avec `DCN-013` n'est fondée par aucun texte. `NON-027` Q1 la porte.

**Si le chantier E est réalisable.** Il suppose onze `DCN` que seul l'humain peut créer, et une table de correspondance qui n'existe pas.

**Le coût de la mise en conformité.** Aucune estimation n'est produite, faute de base de comparaison.
