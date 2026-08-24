# Ce qui a été fait, tâche 13

## La migration

| Opération | Portée |
|---|---|
| Identifiants convertis | **83**, dans 83 fichiers |
| Fichier renommé | 1, `FRG-2026-08-10-...` devenu `FRG-001-...` |
| Définitions dont le nommage change | 8, le nommage daté est aboli |
| Prescriptions `<PREFIX>-<DATE>` restantes | **0** |
| Identifiants à slug restants | **0** |
| Ressources validant leur schéma | **85 sur 87** |
| Tests du CLI | 91, tous verts |

Les deux échecs de validation sont `FRG-001` et `NON-013`, tous deux créés par l'humain avec `clia res new` et portant des champs `À RENSEIGNER`. Ils n'ont pas été complétés.

## Livrables

| Fichier | Contenu |
|---|---|
| `.dev/adr/ADR-007-identifiant-relatif-par-sequence.md` | Cinq décisions, dont le renversement de `ADR-001` D3 |
| `.dev/decisions/DCN-007-identifiant-relatif-par-sequence.md` | Enregistrement de la décision, `effet: en-vigueur` |
| `.dev/objections/NON-019-identifiant-par-sequence.md` | 7 questions, effet `conditionnel` |

## Ce que la décision renverse, et pourquoi le renversement est fondé

`ADR-001` D3 posait que l'identité est `<PREFIXE>-<SLUG>`, le numéro n'étant qu'un rang. Le fondement était solide : `ANL-001` mesure douze numéros de skill sur vingt portant plusieurs noms selon le dépôt, et l'implémentation avait démontré que `clia res show 002` est ambigu.

Le raisonnement était : le numéro se renumérote, donc il ne peut pas porter l'identité.

**La prémisse était fausse.** Le fragment `FRG-001` fournit le critère : ce qui persiste par-delà les modifications est l'identité. Le numéro est attribué à la création et n'a aucune raison de changer ; le slug dérive d'un titre, et un titre se corrige. La renumérotation n'était pas un fait mais une permission tacite, et `ADR-007` D2 la retire.

C'est la première fois de cette session qu'une décision de l'agent est renversée par l'humain sur un point de raisonnement et non de préférence.

## Les cinq décisions de ADR-007

| Décision | Contenu |
|---|---|
| D1 | L'identité est `<PREFIX>-<SEQ>`, avec `<PREFIX>-<SEQ>-<NN>` pour un atome de composite |
| D2 | Renuméroter est interdit : c'est un changement d'identité, jamais une réécriture silencieuse |
| D3 | Le slug porte le libellé et, pour une définition, le nom canonique du type |
| D4 | Le nommage daté est aboli ; le cycle de vie ne commande plus que le versionnage |
| D5 | L'identifiant est relatif au dépôt, sans prétention d'unicité globale |

D2 est un ajout de l'agent : la demande ne le dit pas, et sans lui la décision perd son fondement.

## Deux objections reçoivent une réponse

**`NON-001` Q1**, bloquante depuis le 2026-08-09, demandait si l'identité est le champ `id` ou le chemin. La réponse est ni l'un ni l'autre : c'est la séquence. L'état de l'objection passe à `partiellement-repondue` ; Q2, Q4, Q6 et Q10 restent ouvertes. Sa Q7, sur qui attribue le numéro, est répondue de fait par l'implémentation.

**`NON-011` Q2**, sur le nommage daté ou séquencé des types point fixe, est répondue par D4 : séquencé pour tous. La non-conformité que cette question portait depuis le 2026-08-09 disparaît, non par correction des fichiers mais par alignement de la règle sur la pratique.

## Ce que la migration a touché dans le code

Trois mécanismes du CLI et de la chaîne de génération ont dû être inversés.

**La dérivation du nom canonique.** Elle venait de l'`id` depuis la tâche 8 ; devenu numérique, l'`id` ne peut plus le porter. Elle vient du slug du nom de fichier, ce qui est plus simple et ne dépend pas du frontmatter.

**Le schéma d'identité.** `#Id` passe de `^[A-Za-z]{2,4}-[a-z0-9]+(-[a-z0-9]+)*$` à `^[A-Za-z]{2,4}-[0-9]{3}(-[0-9]{2})?$`, la seconde forme couvrant les atomes.

**Le nom des définitions CUE.** Elles étaient nommées depuis l'`id` ; `#RES_001` ne se lit pas, `#RES_adr` se lit. Elles viennent du slug.

## Trois bogues du générateur trouvés pendant la migration

La chaîne de génération a été réexécutée quatre fois avant d'être juste, et chaque échec était instructif.

| Bogue | Symptôme | Cause |
|---|---|---|
| Nom de définition CUE | `reference "#RES_adr" not found` | La définition était nommée depuis l'`id`, devenu numérique |
| Valeur du champ `type` | `conflicting values "019" and "adr"` | Le générateur dérivait le type de l'`id` au lieu du slug |
| Énumération du champ `effet` | Les décisions recevaient l'énumération des objections | La condition portait sur l'ancien `id`, `RES-decision` |

Les trois ont la même cause racine : **le générateur dépendait de l'`id`**, dont la forme venait de changer. C'est la cinquième manifestation, dans cette session, d'un couplage à une valeur d'affichage ou d'identité qui n'aurait pas dû porter cette information.

## Ce qui reste ouvert

`NON-019` porte sept questions, dont quatre conséquences directes de la décision.

Le champ `id` est redondant : il vaut `<PREFIX>-<SEQ>`, entièrement déductible du nom de fichier.

L'interdiction de renuméroter n'est vérifiée par rien, alors que c'est elle qui fait du numéro une identité.

Les atomes de composite portent `<PREFIX>-<SEQ>-<NN>`, une seconde forme que la demande ne prévoyait pas.

L'ambiguïté de `clia res show 002` demeure et est déclarée acceptable, non réfutée.
