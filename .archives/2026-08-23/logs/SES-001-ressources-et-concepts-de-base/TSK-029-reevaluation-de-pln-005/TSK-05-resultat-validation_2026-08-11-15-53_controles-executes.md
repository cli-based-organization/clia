# Résultat de la validation, tâche 29

## Bilan

| Contrôle | Résultat |
|---|---|
| Issues ouvertes, une par thématique | **5 sur 5** |
| Objections, une par issue | **5 sur 5** |
| Relations croisées `objecte-a` et `repond-a` | **5 sur 5**, dans les deux sens |
| Chaque `ISU` référence `PLN-005` | **5 sur 5** |
| `PLN-005` référence les cinq issues | **5** |
| Sections manquantes | **0** |
| Liens cassés | **0** |
| Schéma, dépôt entier | **142 conformes, 7 non conformes** |
| Tests du CLI | **144 réussis, 0 échoué** |

## Les relations croisées

| Issue | Objection | Retour `repond-a` | Référence `PLN-005` |
|---|---|---|---|
| `ISU-002` | `NON-030` | oui | oui |
| `ISU-003` | `NON-031` | oui | oui |
| `ISU-004` | `NON-032` | oui | oui |
| `ISU-005` | `NON-033` | oui | oui |
| `ISU-006` | `NON-034` | oui | oui |

C'est ce que `MET-004` étape 5 prescrit, et la première fois que le dépôt produit un tel croisement systématique.

## Les sept non-conformités de schéma

Six sont connues : `DCN-011`, `DCN-012`, `DCN-013`, `FRG-001`, `FRG-2026-08-11`, `NON-013`.

**La septième est nouvelle et elle est un bon signe.** `DCN-014`, créée par l'humain pendant l'exécution de la tâche, porte des champs `À RENSEIGNER`. Son nom est **séquencé** et non daté : le bogue corrigé à la tâche 28 ne se reproduit pas.

## L'implémentation

| Réf | Vérification | Résultat |
|---|---|---|
| A1, A2 | `skl-001` porte A7 et A8, sans collision de numérotation | conforme |
| C1, C2 | `RES-007` ne porte plus le seuil à trois conditions | conforme |
| I1 | `RES-001` porte la distinction des deux catégories | conforme |

**Aucun livrable à préalable ouvert n'a été implémenté.** C3, C4, D2 à D4 et I2 sont SMART et restent en attente : le vocabulaire pour les premiers, `NON-029` Q1 pour les registres, un critère de classement pour le dernier.

C'est le quatrième mode d'échec que `MET-004` nomme, et il a été évité.

## Portée respectée

`PLN-005` n'est pas réécrit. Son statut porte la réévaluation ; ses neuf chantiers restent intacts. Le type est `travail`.

`DCN-014` n'est ni modifiée ni renseignée : `CONSTITUTION.md` C1 réserve son contenu à l'humain.

## Ce que la validation n'établit pas

**Que le regroupement en cinq thématiques soit le bon.** L'étape 3 de `MET-004` demande du jugement, et `MET-004` le déclare dans sa rubrique d'épreuve : deux thématiques auraient pu être fusionnées, l'absence de générateur et l'absence de frontières ayant en commun qu'un préalable manque.

**Que le cycle fonctionne.** `MET-004` prévoit que la réévaluation se rejoue à chaque apport d'information. Aucun apport n'a eu lieu : `DCN-014` est un gabarit vide, donc un signal et non une information.

**Que les deux règles A7 et A8 corrigent quoi que ce soit.** Elles sont écrites. Rien ne vérifie qu'un constat n'est pas employé comme norme, et `ISU-006` porte la question du nettoyage de l'existant.
