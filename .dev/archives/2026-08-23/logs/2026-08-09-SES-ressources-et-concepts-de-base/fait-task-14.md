# Ce qui a été fait, tâche 14

## En un coup d'oeil

| Mesure | Valeur |
|---|---|
| Fondation produite, avant reprise | `FND-003`, 418 lignes, 32 sources, 7 domaines |
| Définition enrichie | `RES-009`, v0.1.0 → **v0.2.0** |
| Méthodologie créée | `MET-002`, 9 étapes, 7 modes d'échec |
| Objections ouvertes | **3**, `NON-020` à `NON-022`, 13 questions |
| `DCN` migrées | **7 sur 7** |
| Artefacts réalignés | 3, le schéma, le schéma d'entrée, le gabarit |
| Ressources validant leur schéma | **90 sur 92** |
| Tests du CLI | 91, tous verts |
| Liens relatifs vérifiés | 14 fichiers, **0 cassé** |
| Bogue trouvé pendant la validation | **1**, dans `clia res new`, non corrigé |

## Livrables

| Fichier | Nature |
|---|---|
| `.dev/ressources/RES-009-decision.md` | Modifié, v0.2.0 |
| `.dev/methodologies/MET-002-enregistrement-et-suivi-d-une-decision.md` | Créé |
| `.dev/objections/NON-020-seuil-de-densite-de-la-fondation.md` | Créé, 5 questions |
| `.dev/objections/NON-021-recherche-prealable-a-la-decision.md` | Créé, 4 questions |
| `.dev/objections/NON-022-charge-et-tenue-du-type-decision.md` | Créé, 4 questions |
| `.dev/fondations/FND-003-...md` | Corrigé, deux incohérences internes |
| `.dev/schemas/decision.cue`, `decision.input.cue` | Réalignés sur v0.2.0 |
| `.dev/templates/decision.template.md` | Réaligné sur v0.2.0 |
| `.dev/skills/skl-004-ressource-de-contenu/SKILL.md` | Contrôle propre au type `DCN` ajouté |
| `.dev/decisions/DCN-001` à `DCN-007` | Migrés |

## Ce qui change dans RES-009

Sept apports de `FND-003`, tous traités, dont un renverse le mécanisme central du premier jet.

### Le changement d'une décision devient un acte

C'est la modification principale. Le premier jet traitait un revirement par le passage de l'ancienne décision à `effet: remplacee`, donc par l'édition d'un état.

`FND-003` établit que ce mécanisme échoue, par deux voies indépendantes. Par la littérature : dans un fichier markdown, « remplacé » signifie que quelqu'un se souvient de mettre à jour le champ, ce que personne ne fait. Et par ce corpus : `ANL-001` mesure `completed` dans cinquante-deux logs et `complet` dans deux du même dépôt.

Le droit fournit l'alternative, la *special justification* du *stare decisis*. Trois règles la transposent.

| Règle | Énoncé |
|---|---|
| **R1** | Un revirement produit une nouvelle `DCN`, qui déclare `remplace` |
| **R2** | Cette `DCN` motive le changement, dans une section obligatoire |
| **R3** | `effet: remplacee` est **dérivable** : une décision est remplacée si et seulement si une autre déclare `remplace` vers elle |

R3 n'introduit aucun principe nouveau : `ADR-003` D7 pose déjà que la couche machine-lisible est dérivée, jamais écrite. La règle corrige une exception.

### Deux champs ajoutés

| Champ | Valeurs | Fondement |
|---|---|---|
| `attestation` | `interne`, `source-primaire`, `source-rapportee`, `temoignage` | La triade authenticité, fiabilité, intégrité d'ISO 15489, cinquième élément exigé par l'archivistique et négligé partout ailleurs |
| `diffusion` | `public`, `prive`, `confidentiel` | Le facteur politique de Horner et Atwood, et le privilège du processus délibératif |

### Une frontière ajoutée

La décision n'est pas sa délibération. Le droit administratif américain les sépare et protège la seconde ; le design rationale les confond. Ce type retient la séparation, pour une raison qui n'est pas seulement juridique : un document unique force un régime de diffusion unique, et le plus restrictif l'emporte toujours. La décision, qui devrait être opposable, deviendrait aussi confidentielle que ce qui l'a précédée.

## Ce que MET-002 apporte

La demande désignait la méthodologie comme le livrable principal : « afin d'enrichir la ressource DCN et, **surtout**, nos méthodologies de travail avec cette ressource ».

Neuf étapes, dont chacune porte son contrôle **ou déclare qu'elle n'en a pas**. Cette exigence est propre à ce document et vient du constat de `next-task-13.yaml` : quatre règles écrites et non tenues avaient été ajoutées en deux jours.

| Étape | Ce qu'elle fixe | Contrôle |
|---|---|---|
| 1 | Vérifier qu'une décision a bien été prise | aucun, jugement humain |
| 2 | Séparer le dispositif de la délibération | relecture, la délibération se reconnaît à sa forme narrative |
| 3 | **Produire par dérivation**, jamais par saisie dédiée | `derive-de` absent doit être justifié |
| 4 | Consigner les six éléments, dont l'attestation | schéma pour le champ, manuel pour la section |
| 5 | Déclarer la diffusion, écrire les silences | comparaison avec les `sections` de la définition |
| 6 | **Changer par un acte, jamais par un état** | spécifié, **non outillé** |
| 7 | Vérifier la fidélité | manuel, à consigner |
| 8 | Clore par l'absence d'objection, non par l'accord | lister les objections `bloquant` et `ouverte` |
| 9 | Constater les conséquences, plus tard | aucun, geste opportuniste |

L'étape 3 est celle qui rend le procédé soutenable, et elle vient du résultat central de `FND-003` : ce qui échoue n'est pas la capture, c'est la capture qui interrompt. Une `DCN` se dérive d'un ADR accepté, d'une objection tranchée, d'un fragment ou d'un document externe.

**L'épreuve est déclarée faible.** Les étapes 1 à 5 décrivent ce que le dépôt fait déjà, ce qui est bon pour leur applicabilité et mauvais pour leur nouveauté. L'étape 6, qui est l'apport, ne repose sur aucun cas : aucune `DCN` n'en remplace une autre.

## Les trois objections

| Objection | Ce qu'elle conteste | Effet |
|---|---|---|
| `NON-020` | Le seuil de dix sources par question de `MET-001`, qu'aucune des deux fondations n'a jamais approché. `FND-003` atteint 6,4 au prix d'une tâche entière | `conditionnel` |
| `NON-021` | Le processus de travail n'exige aucune recherche préalable à une décision. `ADR-007` et `RES-009` reproduisent deux prescriptions de Nygard, 2011, découvertes par hasard le lendemain | `conditionnel` |
| `NON-022` | `RES-009` v0.2.0 alourdit le type de 22 pour cent au nom d'une source qui dit que la charge est la cause d'abandon, et son contrôle central n'est pas outillé | `conditionnel` |

`NON-022` est ouverte par l'agent contre son propre livrable, dans le mouvement qui le produit. C'est la conduite que `ADR-002` prescrit.

Une cinquième question a été ajoutée à `NON-020` pendant la validation, sur un conflit mesuré : `RES-011` déclare six sections que la structure en dix étapes de `MET-001` rend impossibles à porter. Les trois fondations du dépôt échouent au même contrôle.

## Les deux corrections à FND-003

Toutes deux internes, donc vérifiables sans consulter les sources.

**Les chiffres de la section « Limites » contredisaient l'étape 10.** Elle annonçait 4,8 sources et une page par question là où la mesure donne 6,4 et 1,8. La mesure fait foi.

**La limite sur la source fondatrice contredisait l'étape 9.** Elle affirmait que le billet de Nygard de 2011 n'avait pas été consulté directement, alors que l'étape 9 relate que l'archive du web l'a rendu consultable et que sa lecture a produit une section entière. La limite a été remplacée par celle qui est exacte : trois sources primaires n'ont pas été consultées directement, le document de 1970 de Kunz et Rittel, la norme ISO 15489 et l'article de 1988 sur gIBIS.

## La migration des sept DCN

Deux champs ajoutés, `attestation: interne` et `diffusion: public`, et une section « Motivation du changement » insérée avant « Qui a décidé ».

Les sept sont internes au dépôt, d'où `interne` pour toutes. Six portent la formule `Sans objet, cette décision n'en remplace aucune`.

**`DCN-007` fait exception** et a reçu une motivation rédigée. Elle ne remplace aucune `DCN`, mais elle renverse `ADR-001` D3. La section dit ce que la position antérieure tenait pour acquis et qui ne l'est plus : que le numéro de séquence se renumérote. Le renversement ne conteste pas la mesure de `ANL-001` qui fondait cette position ; il interdit la renumérotation, ce qui rend le numéro stable.

## Un bogue trouvé, et non corrigé

Constaté le 2026-08-10 en éprouvant `clia res new decision` dans une copie du dépôt, pour vérifier que le gabarit produit bien les nouveaux champs. Il les produit. Mais le frontmatter généré porte deux valeurs fausses.

```
type: 009                                    ← attendu : decision
id: DCN-essai-de-conformite-du-gabarit       ← attendu : DCN-008
```

| Emplacement | Cause |
|---|---|
| `lib/clia/resource.sh:298` | Le type est dérivé de l'`id` de la définition. Depuis `ADR-007`, cet `id` vaut `RES-009` et son suffixe est `009`, non `decision`. Le commentaire des lignes 295-296, « l'id porte le slug canonique », est devenu faux le 2026-08-09 |
| `lib/clia/resource.sh:310` | L'`id` est composé du slug et non du discriminant, ce qui produit la forme `<PREFIX>-<SLUG>` que `DCN-007` abolit |

Ce sont deux régressions de la tâche 13 : la migration a changé la forme des identifiants, `clia res new` ne l'a pas suivie. La conséquence est que **toute ressource créée depuis le 2026-08-10 est non conforme dès sa création**, ce qui explique en partie l'état de `FRG-001` et de `NON-013`.

Le bogue n'est pas corrigé : la tâche 14 est une recherche de fondation et son exploitation, non un correctif du CLI. Il est porté par `next-task-14.yaml` avec son diagnostic et l'emplacement exact.

## Ce qui n'a pas été fait

Aucune question de `NON-019` n'a reçu de réponse : elles appartiennent à l'humain.

`FND-003` reste en `status: draft`, aucune approbation humaine n'ayant eu lieu.

Le contrôle de dérivation de `effet: remplacee` n'est pas implémenté. Il est spécifié en toutes lettres dans `MET-002` étape 6, et compté comme dette dans `NON-022` Q3.

`FRG-001` et `NON-013` restent non conformes. Leurs champs `À RENSEIGNER` appartiennent à leur initiateur.
