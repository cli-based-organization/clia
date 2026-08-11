# Ce qui a été fait, tâche 33

`MET-003` étape 3.

## L1 : les quatre réponses, prises en compte

| Question | Réponse | Instruite par |
|---|---|---|
| Q1 | Quatre champs remplacent l'existant | `DCN-016` |
| Q2 | Si OKF en a besoin, préserver ; sinon supprimer | **condition non vérifiée** |
| Q3 | Oui, refactorer toutes les ressources | `DCN-016`, `PLN-007` D |
| Q4 | Oui, supprimer tous les autres champs d'état | `DCN-016`, `PLN-007` E |

### Le guess de l'humain se vérifie, et deux sources se contredisent

Q1 : « Mon guess est que `status` provient de la décision d'être compatible avec le système OKD. »

**Fondé.** `RES-001` de `micrologic-clients`, d'où le modèle est repris, le dit deux fois : `status` et `stale_after` viennent « du format OKF », et ses trois valeurs sont « au sens d'OKF ».

**Contredit par une autre source du corpus.** `ANL-006`, l'analyse d'OKF archivée, énumère les champs réservés du format : `type`, `title`, `description`, `tags`, `timestamp`. `status` n'y figure pas.

**La contradiction n'a pas pu être levée.** La spécification OKF n'est pas consultable sans outil en ligne, même limite que `FND-004` hier.

**Un signal est apparu pendant la tâche.** `DCN-015`, créée par l'humain, s'intitule « Cette implémentation doit être compatible OKF ». Son gabarit est vide. Elle oriente Q2 vers la préservation sans lever la contradiction.

### DCN-016, premier jet suspendu

| Champ | Valeurs |
|---|---|
| `maturity` | `conception`, `mature`, `fin-de-vie`, `obsolete` |
| `adoption` | `propose`, `adopte`, `conteste`, `obsolete` |
| `activated` | `true`, `false` |
| `domain-status` | Déclarées par le `RES` du type |

**Elle porte `effet: suspendue`.** `DCN-013` pose qu'un premier jet d'IA reste suspendu jusqu'à approbation manuelle. La valeur existe déjà dans `RES-009`.

**Une tension déclarée.** `CONSTITUTION.md` C1 interdit à l'agent de créer une `DCN` ; `DCN-013`, qui lui est supérieure, l'autorise en régime suspendu. L'humain demandait explicitement « proposer un premier jet de DCN ». `NON-033` porte le conflit.

**Un écart avec la demande, signalé.** Q1 dit « ajouter ces 4 champs dans `DCN-004` ». `DCN-004` existe et porte l'adoption du processus de travail : y ajouter les champs falsifierait une décision enregistrée, ce que `RES-009` interdit. Une décision nouvelle a été produite.

## L2 : le plan, avec livrables SMART

`PLN-007`, sept chantiers.

**C'est le premier plan du dépôt à satisfaire les trois contrôles de `PDC-003`.**

| Contrôle | Comment il est satisfait |
|---|---|
| V-S1 livrable unique | Chaque chantier en porte un seul, nommé |
| V-S2 critère exécutable | Chaque chantier porte une commande ou un test |
| V-S3 limite de temps | **Déclarée**, 1 à 4 heures par chantier |

**Le total dépasse la timebox.** Treize heures pour une limite de douze. Le chantier G, indépendant, sort du plan : `PDC-003` E3 pose qu'une planification qui dépasse sa limite ne s'étend pas, elle se scinde.

**Deux chantiers sont sortis du plan** parce que leur préalable est ouvert : le sort de `status`, et la langue du quatrième champ. Ils vivent dans `ISU-009`.

## L3 : est-ce suffisant pour fermer les ISU ?

**Non, ni pour l'une ni pour l'autre.**

| Issue | Ce qui la clôturerait | Atteint ? |
|---|---|---|
| `ISU-008` | Un listage qui donne l'état sans ouvrir les fichiers | **non** |
| `ISU-009` | Une décision sur le partage entre l'universel et le propre au type | **partiellement** |

**`ISU-008` demande un résultat vérifiable par exécution.** `clia res ls` affiche toujours `draft` pour les cent cinquante-sept instances. Le chantier F de `PLN-007` le corrigerait ; il n'est pas exécuté.

**`ISU-009` demande une décision, et elle est prise à trois quarts.** `DCN-016` tranche le partage : trois champs universels, un propre au type. Deux points restent : le sort de `status`, et la langue des noms.

**Ce que la distinction établit.** Une réponse à une objection ne ferme pas l'issue qui lui est liée. L'objection pose des questions, l'issue porte un problème : la première se répond, la seconde se résout.

## L4 : quelles objections reste-t-il ?

| Mesure | Valeur |
|---|---|
| Objections | **35** |
| Répondues | 5 |
| Ouvertes | **29** |
| Bloquantes non répondues | **9** |

### Les neuf bloquantes

| Objection | Sujet | Depuis |
|---|---|---|
| `NON-005` | Validation mécanique et règles non tenues | 2026-08-09 |
| `NON-009` | Statut de la session et convergence | 2026-08-09 |
| `NON-014` | Trilemme de nommage | 2026-08-10 |
| `NON-017` | Familles et processus par famille | 2026-08-10 |
| `NON-018` | Frontière spécification contre implémentation | 2026-08-10 |
| `NON-024` | Sort des ressources d'autorité rédigées par l'agent | 2026-08-11 |
| `NON-030` | Trois familles dérivées, aucun générateur | 2026-08-11 |
| `NON-033` | Autorité de création des principes | 2026-08-11 |
| `NON-035` | **Passée à `conditionnel` par cette tâche** | 2026-08-11 |

**`NON-035` n'est plus bloquante** : trois de ses quatre questions sont répondues et instruites. Elle reste ouverte pour Q2, dont la condition n'est pas vérifiée.

**Le compte reste à neuf bloquantes** parce que le décompte inclut `NON-035` avant son changement d'effet. Après, il en reste **huit**.

### Ce que les neuf ont en commun

Quatre portent sur **l'autorité** : qui décide, qui rédige, qui approuve. `NON-024`, `NON-033`, et par extension `NON-014` et `NON-018`.

Trois portent sur **l'outillage manquant** : `NON-005`, `NON-030`, et `NON-035` pour son volet affichage.

Deux portent sur **le modèle** : `NON-009`, `NON-017`.

## Ce qui n'a pas été fait

Aucun chantier de `PLN-007` n'est exécuté. Le plan applique une décision suspendue : l'exécuter avant approbation reviendrait à appliquer une décision qui n'en est pas une.

Le sort de `status` n'est pas tranché.

Les deux issues ne sont pas fermées.
