# Ce qui a été fait, tâche 15

## Livrables

| Fichier | Contenu |
|---|---|
| `.dev/analyses/ANL-004-verbosite-justificative-des-definitions-de-type.md` | Diagnostic, 3 mesures, 7 constats, 3 causes, 5 correctifs |
| `.dev/plans/PLN-002-remediation-de-la-verbosite-justificative.md` | 5 chantiers, 3 points d'arrêt, 4 objections |

## Le diagnostic, en chiffres

| Mesure | Valeur |
|---|---|
| Mots dans le corps des trente définitions | 17 922 |
| Mots en rubrique méta-justificative | **3 724, soit 20,8 pour cent** |
| Marqueurs lexicaux de justification | **146**, densité 6,6 pour mille mots |
| Définitions portant `Statut de ce document` | **30 sur 30** |
| Définitions portant `Points ouverts` | **30 sur 30** |
| Définitions portant `Frontière avec les types voisins`, déclarée non optionnelle | **1 sur 30** |
| Types ayant un `ADR` qui décide leur adoption | **1 sur 30** |

Les cinq définitions les plus atteintes : `RES-007` à 29,3 pour cent, `RES-006` à 25,0, `RES-009` à 24,3, `RES-008` à 23,9, `RES-003` à 22,5.

`RES-009` a été produit le jour même, à la tâche 14.

## La cause

**Le harnais prescrit ce qu'il reproche.**

La mesure décisive est M3, le taux de reprise du gabarit `skl-001` B3.

| Nature de la rubrique | Reprise du titre exact |
|---|---|
| Méta : `Statut de ce document`, `Points ouverts` | **30/30** |
| Descriptives : sept rubriques | **1/30 à 13/30** |

Le harnais est suivi là où il justifie et reformulé là où il prescrit. L'agent ne dévie pas : il applique.

Trois causes, par ordre de force.

**Cause 1, directe.** `skl-001` B3 prescrit deux rubriques méta dans le gabarit de toute définition.

**Cause 2, structurelle.** `skl-001` B1 assigne le pourquoi à l'`ADR`. Vingt-neuf types sur trente n'ont pas d'`ADR` d'adoption ; vingt-trois pointent vers `ADR-005`, qui décide le regroupement en familles. Le foyer désigné par le harnais n'existe pas.

**Cause 3, permissive.** `skl-001` A3 porte cinq règles d'écriture : trois de typographie, deux de fond. Aucune ne porte sur le registre.

### La contradiction interne

`skl-001` B1, ligne 122 : « Pourquoi il a été adopté → la décision, `ADR` ».

`skl-001` B3, ligne 168 : « `## Le problème que ce type résout` ».

Quarante-cinq lignes d'écart, même document, aucun arbitrage.

## Le correctif

| Réf | Action |
|---|---|
| F1 | Retirer `Statut de ce document` et `Le problème que ce type résout` du gabarit B3 |
| F2 | Aligner B3 sur B1 : onze rubriques, toutes descriptives |
| F3 | Créer le foyer de la justification, six `ADR` de famille ou un `ADR` unique |
| F4 | Ajouter la règle de registre `A6`, avec bibliographie numérotée pour les références externes |
| F5 | Ajouter le contrôle `V10`, liste noire de rubriques, exécutable par `grep` |

`Points ouverts` est conservé, réduit à une table de deux colonnes. Une lacune n'est pas une justification, et `RES-004` en dépend.

## Le plan

Cinq chantiers, trois points d'arrêt.

```
A ──> B
│
└──> C (décision humaine) ──> D1 ──> [mesure] ──> D2 ──> D3

E, indépendant
```

| Chantier | Objet | Coût |
|---|---|---|
| A | Corriger `skl-001` | 1 document, 7 éditions |
| B | Corriger le gabarit et le champ `sections` | 3 artefacts, 1 point à trancher |
| C | **Ouvrir le foyer de la justification** | 6 documents, ou 1 |
| D | Réécrire les trente définitions, en trois vagues | 30 documents |
| E | Étendre la mesure aux `ADR`, `MET`, `NON` | 1 mesure |

**C bloque D.** Le chantier C exige une décision de l'humain entre six `ADR` de famille et un `ADR` unique. La recommandation de l'agent est six.

**Arrêt après D1.** La première définition réécrite est `RES-009`, la plus atteinte en volume. Son coût réel fixe l'engagement des vagues D2 et D3.

## Deux défauts connexes trouvés

Aucun n'a de rapport avec la verbosité. Les deux sont dans `skl-001` B3.

**Le gabarit prescrit `id: RES-<slug>`**, forme abolie par `ADR-007` le 2026-08-09. Troisième trace de la migration de la tâche 13 restée en place, avec les deux régressions de `clia res new`.

**Le gabarit montre quatorze champs** là où `RES-001` en déclare seize obligatoires. Manquent `famille` et `sections`.

## Ce qui n'a pas été fait

Aucun chantier n'est engagé. `PLN-002` porte `statut-plan: propose`.

Aucune définition n'est réécrite.

Aucune mesure n'est produite sur les autres familles.

`PLN-001`, en attente depuis le 2026-08-09, n'est pas touché. Deux plans non exécutés coexistent.
