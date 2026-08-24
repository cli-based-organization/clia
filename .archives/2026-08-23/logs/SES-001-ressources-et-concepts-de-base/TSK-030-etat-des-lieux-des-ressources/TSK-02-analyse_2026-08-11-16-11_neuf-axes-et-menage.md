# Analyse avant réalisation, tâche 30

`MET-003` étape 2.

## Ce que l'inventaire donne

| Mesure | Valeur |
|---|---|
| Documents actifs du dépôt | 150 |
| Documents traitant des ressources | **136**, soit 91 pour cent |
| Objections | **34** |

**Le compte est le résultat.** Presque tout le dépôt parle des ressources. L'inventaire brut n'apprend donc rien : ce qui compte est de savoir **sous quel angle** chacun en parle.

D'où les axes.

## Neuf axes, tirés des problématiques abordées

Chaque axe regroupe les documents qui traitent d'une même question sur la ressource.

| Axe | Question | Documents structurants |
|---|---|---|
| A1 Identité | Qu'est-ce qui désigne une ressource | `ADR-007`, `ADR-008`, `PDC-002` |
| A2 Forme | Fichier, répertoire, dépôt, ou entrée dans un autre document | `ADR-004`, `ISU-001` |
| A3 Cycle de vie | Individuel ou collectif | `RES-001`, `DCN-014` |
| A4 Autorité | Qui peut créer, rédiger, approuver | `CONSTITUTION.md`, `DCN-013` |
| A5 Dérivation | Ce qui est source, ce qui est généré | `ADR-016`, `ADR-017`, `NON-004` Q3 |
| A6 Typage | Combien de types, comment on les regroupe | `ADR-005`, `ADR-009` à `ADR-014` |
| A7 Validation | Comment on vérifie la conformité | `skl-001` V1 à V10 |
| A8 Frontières | Ce qui départage deux types voisins | `NON-003`, `NON-004`, `NON-032` |
| A9 Portée | Ce qui vaut dans un dépôt, ce qui se partage | `ADR-008` D7, `NON-006` |

**Trois axes sont réglés**, A1, A6 et A8 partiellement. **Quatre sont ouverts et bloquants** : A3, A4, A5, A7.

## L'état des objections, mesuré

| Effet | Nombre |
|---|---|
| bloquant | **8** |
| conditionnel | 19 |
| informatif | 6 |
| sans frontmatter valide | 1 |

| État | Nombre |
|---|---|
| repondue | 4 |
| ouverte | 29 |

## Ce que le ménage doit corriger

Trois catégories, et aucune ne consiste à fermer une objection sans réponse.

**Un état faux.** `NON-026` porte cinq questions et cinq réponses, et reste `ouverte`. Elle a été traitée à la tâche 24 par `ANL-006` et `PLN-003`.

**Des doublons.** Deux paires posent la même question dans les mêmes termes.

| Paire | Question commune |
|---|---|
| `NON-025` et `NON-030` | Les skills sont dérivables et rien ne les dérive |
| `NON-027` Q1 et `NON-033` Q1 | Un agent peut-il rédiger un `PDC` |

**Des objections dont l'objet a changé.** `NON-014` porte sur le trilemme de nommage ; `ADR-008` a tranché l'identité depuis. `NON-011` porte sur les types employés sans définition ; trente-cinq types sont définis depuis.

Ces deux-là ne se ferment pas : leur question subsiste sous une autre forme. Le ménage consiste à le **noter dans leur journal**, non à décider qu'elles sont réglées.

## La contradiction de l'énoncé, et ce qu'elle change

« Créer un plan que ne contient que les éléments non implémentables. »

Retenu : le plan ne contient que ce qui est **implémentable**. `PDC-003` place les plans au régime extrême SMART, et `MET-004` prescrit que le non-SMART sorte du plan.

**Ce que la lecture littérale produirait.** Un plan dont aucun chantier ne peut être exécuté, et une issue qui porterait l'implémentable. Les deux types échangeraient leur fonction.

## L'ordre retenu

1. `ANL-009` : l'inventaire, les neuf axes, la synthèse.
2. Le ménage dans les objections.
3. `PLN-006` : ce qui est implémentable, avec le livrable visé.
4. `ISU-007` : le reste, avec les objections bloquantes en relation.

`MET-004` s'applique : les axes ouverts et bloquants sont des thématiques, et elles ont déjà leurs issues depuis la tâche 29.

## Ce que je ne referai pas

**Ouvrir une issue par axe bloqué.** Cinq issues existent depuis hier, `ISU-002` à `ISU-006`, et elles couvrent A5, A3, A8 et A4. Une sixième issue serait un doublon.

`ISU-007` ne portera que ce qui n'est couvert par aucune des cinq.
