# Résultat de la validation, tâche 25

## Bilan

| Contrôle | Résultat |
|---|---|
| Schéma des trois définitions | **3 sur 3 conformes** |
| Rubriques méta, `V10` | **0** |
| `cue vet` sur les six schémas | **passe** |
| Types reconnus par `clia res ls` | **3 sur 3** |
| Skills portant la rubrique de journalisation | **7 sur 7** |
| Logs de l'ancien format modifiés ou supprimés | **0** |
| Tests du CLI | **124 réussis, 0 échoué** |
| Schéma, dépôt entier | **125 conformes, 5 non conformes** |

Les cinq non-conformités sont les gabarits en attente de l'humain, inchangées : `DCN-011`, `DCN-012`, `DCN-013`, `FRG-001`, `NON-013`.

## L'auto-application, contrôles 13 à 16

C'est le contrôle décisif : la tâche prescrit un format, et son journal doit le respecter.

```
TSK-025-systeme-de-journalisation/
    TSK-01-demande_2026-08-11-09-06_systeme-de-journalisation.md
    TSK-02-analyse_2026-08-11-09-07_conception-des-trois-types.md
    TSK-03-fait_2026-08-11-09-13_trois-definitions.md
    TSK-03-fait_2026-08-11-09-16_artefacts-methodologie-et-skills.md
    TSK-04-validation_2026-08-11-09-30_demarche-prevue.md
```

| Vérification | Résultat |
|---|---|
| Répertoire propre, ne contenant que les logs de cette tâche | conforme |
| Nommage `TSK-<SEQ>-<TYPE>_<horodatage>_<slug>.md` | conforme, 5 fichiers sur 5 |
| **Horodatages distincts et croissants** | **09:06, 09:07, 09:13, 09:16, 09:30** |
| Log rapportant une autre tâche | aucun |

**Les cinq horodatages sont distincts.** C'est la trace d'une écriture au fil de l'eau, et c'est ce que le contrôle de `MET-003` cherche : sept horodatages identiques auraient signalé une reconstruction.

**Le log `fait` porte deux versements**, à 09:13 et 09:16, ce que `MET-003` étape 3 prescrit et que la pratique antérieure ne faisait pas.

## Un faux positif du contrôle 3

Le contrôle cherchait l'absence de champ `version` dans `RES-032`. Il en trouve un.

Vérification faite, c'est le champ `version` de la **définition elle-même**, qui est une instance du type `ressource`, lequel est `vivant`. Les **instances** de `LOG` n'en portent pas : `champs-obligatoires` ne le liste pas.

Le contrôle était mal formulé, pas la définition.

## Ce que la validation établit sur MET-003

Contrôles 9 à 11.

Les sept étapes portent chacune leur moment d'écriture, ce qui est l'apport de la méthodologie : le procédé existait, le moment n'était pas fixé.

Les six modes d'échec citent des cas **mesurés** du journal existant : onze tâches journalisées en bloc, trois fichiers combinant plusieurs tâches, une démarche de validation écrite après les contrôles, un nommage sans date. Aucun n'est imaginé.

`MET-003` est déclarée ressource source dans `RES-032`, sous une rubrique dédiée, conformément à `NON-026` Q5.

## Portée respectée

Contrôle 17. Aucun log de l'ancien format n'a été migré, renommé ou supprimé. Les 116 fichiers du répertoire daté sont intacts.

Contrôle 18. Aucun code n'a été touché ; la suite de tests est verte sans modification.

## Ce que la validation n'établit pas

**Que la règle centrale soit vérifiable.** `MET-003` exige l'écriture au moment de l'exécution. Les horodatages de cette tâche sont distincts, ce qui est cohérent avec la règle, mais ils sont **déclaratifs** : rien n'empêche de les antidater. `NON-028` Q2 le porte.

**Que le format tienne sur une tâche longue.** Cette tâche a duré une demi-heure. Une tâche longue et ramifiée est le vrai test, et il n'a pas eu lieu.

**Que le dépôt soit cohérent.** Il porte désormais deux formats de journal et deux répertoires de session, l'un daté et l'autre numéroté. `NON-028` Q1 le porte.
