# Résultat de la validation, tâche 33

## Bilan

| Contrôle | Résultat |
|---|---|
| Schéma des trois documents créés | **conformes** |
| Chantiers satisfaisant V-S1, V-S2 et V-S3 | **7 sur 7** |
| Liens relatifs | **0 cassé** |
| Schéma, dépôt entier | **152 conformes, 8 non conformes** |
| Tests du CLI | **144 réussis, 0 échoué** |
| Chantiers exécutés | **0** |

Les huit non-conformités sont des gabarits en attente de l'humain, dont `DCN-015` créée pendant la tâche.

## PLN-007 satisfait les trois contrôles de PDC-003

C'est le premier plan du dépôt dans ce cas. Les six autres échouaient tous à V-S3.

| Chantier | V-S1 | V-S2 | V-S3 | Commande dans le critère |
|---|---|---|---|---|
| A à G | ok | ok | **ok** | 6 sur 7 |

Le chantier C, qui révise trente-six définitions, porte un critère vérifiable par lecture et non par commande. C'est le seul.

**Le dépassement de la timebox est traité par scission.** Treize heures estimées pour une limite de douze : le chantier G sort du plan, conformément à `PDC-003` E3.

## Ce que la contradiction sur OKF laisse ouvert

Deux sources du corpus se contredisent, et la vérification directe n'était pas possible.

| Source | Ce qu'elle dit de `status` |
|---|---|
| `RES-001` de `micrologic-clients` | Vient du format OKF, valeurs « au sens d'OKF » |
| `ANL-006`, archivée | Absent de la liste des champs réservés OKF |

**Le guess de l'humain est donc fondé sur une source réelle**, et contredit par une autre du même corpus.

`DCN-015`, créée pendant la tâche, pose que l'implémentation doit être compatible OKF. Son gabarit est vide : elle oriente sans trancher.

## Les réponses aux deux questions posées

### Est-ce suffisant pour fermer les issues ? Non.

| Issue | Critère de clôture | Atteint |
|---|---|---|
| `ISU-008` | Un listage qui donne l'état sans ouvrir les fichiers | **non** |
| `ISU-009` | Une décision sur le partage universel contre propre au type | **aux trois quarts** |

`clia res ls` affiche toujours `draft` sur cent cinquante-sept instances. Le chantier F le corrigerait ; il n'est pas exécuté.

`DCN-016` tranche le partage. Restent le sort de `status` et la langue des noms.

**Ce que la distinction établit.** Une réponse à une objection ne ferme pas l'issue liée. L'objection pose des questions et se répond ; l'issue porte un problème et se résout.

### Quelles objections restent ? Vingt-neuf ouvertes, huit bloquantes.

| Mesure | Avant la tâche | Après |
|---|---|---|
| Objections | 35 | 35 |
| Bloquantes non répondues | **9** | **8** |

`NON-035` passe de `bloquant` à `conditionnel` : trois de ses quatre questions sont répondues et instruites.

Les huit restantes : `NON-005`, `NON-009`, `NON-014`, `NON-017`, `NON-018`, `NON-024`, `NON-030`, `NON-033`.

**Quatre portent sur l'autorité**, trois sur l'outillage manquant, deux sur le modèle. Deux datent du 2026-08-09.

## Portée respectée

Aucun chantier de `PLN-007` n'est exécuté. `lib/` et `commun.cue` sont inchangés.

`DCN-015` n'est ni modifiée ni renseignée.

Aucune issue n'est fermée.

## Ce que la validation n'établit pas

**Que les sept durées soient justes.** Elles sont des estimations, et le dépôt n'a mesuré la durée d'aucun chantier. `PDC-003` V-S3 exige une déclaration, non une justification.

**Que `DCN-016` puisse être appliquée.** Elle porte `effet: suspendue` : c'est un premier jet d'agent en attente d'approbation. `PLN-007` l'objecte lui-même en dernière position.

**Que la rédaction de `DCN-016` par l'agent soit régulière.** `CONSTITUTION.md` C1 l'interdit, `DCN-013` l'autorise en régime suspendu, et `NON-033` porte le conflit depuis la tâche 29.
