# Ce qui a été fait, tâche 2

## Les sept définitions

`.dev/ressources/`, huit fichiers, 1156 lignes.

| Fichier | Type | Préfixe | Cycle | Édition | Lignes |
|---|---|---|---|---|---|
| `index.md` | Table des types | | vivant | co-édition | 89 |
| `RES-001-ressource.md` | Ressource | `RES` | vivant | co-édition | 198 |
| `RES-002-contexte.md` | Contexte | `CTX` | vivant | hybride | 155 |
| `RES-003-intention.md` | Intention | `INT` | vivant | humain | 133 |
| `RES-004-objection.md` | Objection | `NON` | travail | hybride | 148 |
| `RES-005-fait.md` | Faits | `FCT` | point-fixe | hybride | 157 |
| `RES-006-ontologie.md` | Ontologie | `ONT` | vivant | co-édition | 133 |
| `RES-007-concept.md` | Concept | `CPT` | vivant | co-édition | 142 |

Les sept portent quatorze champs de frontmatter, dont `id`, `cycle-de-vie`, `edition`, `champs-obligatoires`, `relations-admissibles`, `skill`, `adr` et `statut`. Toutes sont en `status: draft`. Toutes déclarent `skill: aucun` et `adr: aucun`.

## Les huit objections

`.dev/objections/`, huit fichiers, 746 lignes, 56 questions au total, sept par objection.

| Objection | Thème | Effet | Porte sur |
|---|---|---|---|
| `NON-001` | Identité, nommage et préfixes | bloquant | `RES-001`, `RES-004` |
| `NON-002` | Coût du modèle et prolifération des types | bloquant | `RES-001`, `RES-007`, index |
| `NON-003` | Frontière contexte, intention, faits | conditionnel | `RES-002`, `RES-003`, `RES-005` |
| `NON-004` | Frontière ontologie, concept, fondation, analyse | conditionnel | `RES-006`, `RES-007`, `INTENTION.md` |
| `NON-005` | Validation mécanique et règles non tenues | bloquant | `RES-001`, `RES-003`, `RES-005`, `RES-006` |
| `NON-006` | Portée du système et multi-dépôts | conditionnel | cinq définitions |
| `NON-007` | Faits, preuve et confidentialité | conditionnel | `RES-005` |
| `NON-008` | Régime de travail, échelles et arbitrage | informatif | `RES-004`, `RES-003` |

Chaque objection suit la structure que `RES-004` définit : journal, ce qui est contesté, pourquoi cela ne peut pas rester implicite, questions numérotées avec un bloc de réponse vide appartenant à l'humain, et condition de levée.

## Cinq apports de conception, chacun fondé sur une mesure

| Apport | Où | Mesure qui le fonde |
|---|---|---|
| L'identité est le champ `id` de forme `<PREFIXE>-<SLUG>`, pas le numéro | `RES-001` | D1 : douze numéros de skill sur vingt portent plusieurs noms |
| L'intention porte un critère de satisfaction et un critère de trahison | `RES-003` | Aucun `INTENTION.md` du corpus ne permet d'instruire un conflit d'intention |
| L'objection déclare son effet : bloquant, conditionnel, informatif | `RES-004` | La règle « aucune exécution tant qu'une objection est ouverte » rend le travail impossible |
| L'unité de fichier des faits est le recueil par sujet, l'unité de sens le fait atomique | `RES-005` | Zéro instance `FCT` malgré un besoin théorisé : la granularité était l'obstacle |
| Le concept porte un seuil d'admission à trois conditions | `RES-007` | D4 : le système consacre une part croissante de son énergie à se décrire |

## Écarts assumés avec l'état de l'art

Trois écarts avec `RES-001-ressource.md` de `micrologic-clients`, qui est la référence du corpus.

L'invariant d'identité stable est **retenu** alors que la référence l'écarte. Motif : le calcul de la référence est valable pour un dépôt isolé et faux pour un système destiné à équiper plusieurs dépôts.

L'ontologie est en `co-edition` alors que la référence la déclare en `ia`. Motif : un lexique produit par l'agent seul ne sera pas tenu par l'humain, et un lexique produit par l'humain seul ne bénéficiera pas de ce que la comparaison mécanique détecte.

Le préfixe de l'objection est `NON` alors que la référence emploie `OBJ` avec quatre instances. Motif : `CLAUDE.md` et la session le demandent. L'écart et son coût sont portés par `NON-001`.

## Ce qui n'a pas été fait

Les sept ADR et les sept skills. La demande porte sur les `RES`. `NON-002` soumet à l'humain la question de savoir si le triplet complet est exigible.

`ONT-001`, l'ontologie du système. Elle est nécessaire et manquante : les sept définitions emploient six relations que rien ne définit, et le vocabulaire provisoire vit dans `RES-001`, ce qui en fait une source parallèle. Cette contradiction interne est signalée dans `RES-006` et portée par `NON-004`.

Toute instance des sept types. Ce jet définit, il n'instancie pas.

Les répertoires des cinq types sans instance. Non créés tant qu'ils sont vides.

`CLAUDE.md`. Non touché, bien que sa table des types duplique celle de l'index et que son mode de désignation par numéro soit contesté.
