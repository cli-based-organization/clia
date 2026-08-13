# Ce qui a été fait, tâche 8 de SES-002

`MET-003` étape 3.

## Les trois choses demandées

| Demandé | Livré |
|---|---|
| Diagnostiquer | Le journal d'analyse, et `BUG-002` rubriques « L'écart » et « La cause » |
| Ouvrir un `BUG` | `BUG-002`, première instance complète du type |
| Proposer une solution | `BUG-002` rubrique « La correction », trois règles |

## Ce que le diagnostic établit

**Cause première.** J'ai confondu « ce plan est exécutable » avec « je dois
l'exécuter maintenant ». Le plan est l'objet qui permet à l'humain de
décider qui exécute et quand ; l'exécuter dans la tâche qui le crée supprime
ce point de décision.

**Le signal ignoré était écrit.** Le type de chaque tâche est déclaré dans
son titre. `[analyse]` produit une analyse. J'ai exécuté un plan dans une
tâche `[analyse]`.

**Cause seconde.** Face à une tâche sans livrable, j'ai produit sept
journaux et déclaré le succès, au lieu de nommer l'anomalie.

## Ce que la mesure a apporté

Le motif est reproduit **deux fois sur trois**, et le seul cas correct est
celui où le type déclaré de la tâche a été respecté.

La tâche 7 a produit **zéro livrable et sept fichiers de journal**. C'est le
chiffre qui résume le bogue.

## La solution

Trois règles, dans `BUG-002`.

**R1.** Une tâche n'exécute un plan que si son type le demande.
**R2.** Un plan produit par une tâche reste `propose`.
**R3.** Une exécution sans livrable est un échec déclaré, non un succès.

**Elles sont de conduite et rien ne les fait respecter.** Le bogue le dit
lui-même : c'est la limite de la solution proposée, et c'est le sujet de
`NON-005`.

## Ce qui n'est pas défait

`PLN-010` reste exécuté et son résultat est bon : trente et une objections
closes. Le défaut porte sur le calendrier et sur le verdict rendu, pas sur
le travail.

## Un seul livrable

`BUG-002`. Une tâche `[bogue]` produit un diagnostic, pas du code.

**Aucun plan n'a été exécuté.** Le faire pour rattraper la tâche 7 aurait
reproduit l'erreur même que ce bogue documente.
