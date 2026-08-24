# Ce qui a été fait, tâche 29

`MET-003` étape 3.

## La réévaluation

Douze livrables de `PLN-005`, confrontés aux trois contrôles de `PDC-003`.

| Verdict | Livrables |
|---|---|
| **Implémentés** | A1, A2, C1, C2, I1 |
| Déjà fait à la tâche 28 | D1, le type `REG` |
| SMART, préalable ouvert | C3, C4, D2 à D4, I2 |
| **Non-SMART, sortis du plan** | A3, B, E, F, G, H |

**Aucun chantier ne déclarait de limite de temps.** V-S3 échoue partout, ce que `PDC-003` avait déjà mesuré sur `PLN-001` et `PLN-002`. C'est un défaut du plan entier.

## Cinq thématiques, cinq issues, cinq objections

Les échecs se regroupent. Une thématique nomme un **manque**, non un livrable bloqué.

| Thématique | `ISU` | `NON` | Effet |
|---|---|---|---|
| Aucun générateur de ressources dérivées | `ISU-002` | `NON-030` | **bloquant** |
| Le cycle de vie collectif n'est pas modélisable | `ISU-003` | `NON-031` | conditionnel |
| Deux frontières conceptuelles non tracées | `ISU-004` | `NON-032` | conditionnel |
| L'agent ne peut pas créer un `PDC` | `ISU-005` | `NON-033` | **bloquant** |
| Volume du nettoyage inconnu | `ISU-006` | `NON-034` | informatif |

Chaque `ISU` déclare `objecte-a` vers sa `NON`, chaque `NON` déclare `repond-a` vers son `ISU`, et chaque `ISU` référence `PLN-005` et les ressources impactées.

**`NON-030` est la plus lourde.** Trente-deux documents sont déclarés dérivés et rien ne les dérive : sept skills, dix-sept ADR, huit analyses. `skl-001`, que l'agent lit avant d'écrire toute ressource, est dans ce cas.

## MET-004, la procédure

Demandée par le `TODO` de la tâche.

Six étapes : partir des livrables et non des chantiers, confronter aux trois contrôles, **regrouper les échecs par thématique**, ouvrir une issue par thématique, ouvrir une objection par issue avec relations croisées, implémenter ce qui reste.

**L'étape 3 est celle qui demande du jugement.** Une thématique nomme un manque. « Le générateur n'existe pas » en est une ; « le chantier G est bloqué » n'en est pas une.

**Le principe qui la fonde.** `PDC-003` pose le seuil de bascule, `RES-031` pose que l'issue est non-SMART par construction. Les deux se tiennent : le flou a un endroit où aller, et c'est ce qui permet au plan de rester net.

**Six modes d'échec**, dont le plus coûteux : implémenter un livrable SMART dont le préalable est ouvert, ce qui produit du travail à refaire.

## Ce qui a été implémenté

Trois interventions, sur trois documents.

| Réf | Fait |
|---|---|
| **A1** | `skl-001` A7 : une observation est une hypothèse, non une norme |
| **A2** | `skl-001` A8 : un écart entre une intention et son implémentation n'est pas un démenti |
| **C1, C2** | `RES-007` : le seuil à trois conditions est remplacé par le critère unique de compatibilité |
| **I1** | `RES-001` : la distinction entre ressource de système et ressource de dépôt |

**Les deux règles portent leur exemple.** A7 dit ce qu'elle interdit en pratique : « le corpus fait ainsi, donc c'est la bonne forme ». A8 interdit de proposer de retirer une intention parce que l'état présent ne la satisfait pas encore.

**Ce que C1 et C2 retirent.** La condition d'emploi attesté dans deux ressources, qui posait un problème d'amorçage. La pertinence n'est plus mesurable par observation : elle est décidée, et contextuelle.

## Ce qui n'a pas été implémenté, et pourquoi

| Réf | Motif |
|---|---|
| C3, C4 | Dépendent du vocabulaire que `ONT-001` doit fixer, et `ONT-001` est dans `ISU-004` |
| D2 à D4 | `NON-029` Q1 n'est pas tranchée : type unique ou catégorie de registres |
| I2 | Classer cent trente-sept ressources demande la distinction, écrite aujourd'hui, et un critère qui ne l'est pas |

**C'est le mode d'échec que `MET-004` nomme en quatrième.** Un livrable SMART dont le préalable est ouvert reste bloqué, et le confondre avec un livrable libre produit du travail à refaire.

## Un signal apparu pendant la tâche

`DCN-014`, intitulée « cycle de vie des ressources », a été créée par l'humain pendant l'exécution. Son gabarit est vide.

C'est le sujet exact de `ISU-003`. Le journal de l'issue le consigne : un signal, non une information. `MET-004` prévoit que la réévaluation se rejoue à chaque apport ; il n'y a rien à rejouer tant que le contenu manque.

**Le gabarit est bien nommé**, `DCN-014` et non `DCN-2026-08-11` : le bogue corrigé à la tâche 28 ne se reproduit pas.
