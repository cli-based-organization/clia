---
type: analyse
id: ANL-013
title: "Pourquoi l'humain ne peut pas agir"
status: draft
maturity: conception
adoption: propose
activated: true
date: 2026-08-13
sujet: "diagnostic de BUG-005 : le dépôt sait dire ce qui bloque, pas quoi faire pour débloquer"
---

# ANL-013 - Pourquoi l'humain ne peut pas agir

> Treize tâches, cinquante et une suites proposées, soixante et un items en attente. Et le geste qui débloque cinq chantiers n'apparaît dans aucune commande du système.

## Objet

Répondre à la question de la tâche 13 : **pourquoi deux exécutions consécutives laissent l'humain sans rien à faire.**

Et proposer ce qui empêche la récidive.

## Méthode

Trois sources, toutes vérifiables dans le dépôt.

**Les journaux `next` des treize tâches** de `SES-002`, comptés un par un : combien de suites, combien pour l'humain.

**La sortie de `clia focus`** au moment de l'analyse, comparée à ce que l'agent a rendu aux tâches 11 et 12.

**Le code de `lib/clia/focus.sh`**, pour établir ce que la commande lit et ce qu'elle ignore.

## Constats

### C1. La quantité de suites n'est pas le problème — leur destinataire l'est

| Mesure | Valeur |
|---|---|
| Suites proposées sur treize tâches | 51 |
| Dont destinées à l'humain | 26 |
| Items en attente | 61 |
| **Items destinés à l'humain que `clia focus` affiche** | **3** |

L'humain a reçu vingt-six propositions en treize tâches. **La commande censée les lui rappeler en montre trois.**

### C2. `clia focus` répond à la mauvaise question

Vérifié à l'instant : la commande affiche `qui: agent` et propose `BUG-001`.

**Elle répond à « quelle est la priorité du dépôt ? ».** L'humain qui la lance apprend ce que l'agent doit faire.

Sur 61 items, 36 sont `A CLORE` par l'agent, 3 `A CORRIGER` par l'agent, 1 `A EXECUTER` par l'agent. **La file est celle de l'agent, et l'humain la regarde par-dessus son épaule.**

### C3. Les décisions ne sont pas des items

`clia focus` lit quatre types : objections, plans, issues, bogues. **Il ne lit pas les décisions.**

`DCN-016` porte `effet: suspendue` depuis le 2026-08-11. `DCN-013` pose qu'un premier jet d'agent reste suspendu jusqu'à approbation manuelle de l'humain — **c'est donc une attente, adressée à l'humain, et le système ne la compte pas.**

Elle bloque cinq chantiers de `PLN-007`. La commande ne la mentionne que comme motif : `PLN-007 (prealable suspendu : DCN-016)`. **On peut lire ce motif et ne pas comprendre qu'il faut aller approuver quelque chose.**

### C4. Le geste qui débloque n'est modélisé nulle part

Un plan bloqué déclare son blocage en prose — objections, section « Statut ». Aucun champ ne porte **ce qui le débloquerait**.

La correction de la tâche 11 a appris à `clia focus` à détecter le blocage. Elle ne lui a pas appris à nommer le déblocage.

| Ce que le système sait dire | Ce qu'il ne sait pas dire |
|---|---|
| « `PLN-007` a un préalable suspendu » | « Approuvez `DCN-016` » |
| Décrire | Conduire |

**C'est le prolongement de `BUG-004`.** L'exécutabilité d'un plan n'est pas modélisée ; son déblocage non plus.

### C5. La directive n'a ni lieu, ni forme, ni nombre

`MET-005` prescrit, quand une exécution échoue : « il nomme l'anomalie, en cherche la cause, et propose l'action utile ».

**Rien ne dit où cette action va, sous quelle forme, ni combien il y en a.** Chaque tâche produit donc quatre à cinq suites et un rapport de plusieurs dizaines de lignes, avec le geste en dernière ligne.

C'est une règle écrite et non tenue — le défaut exact que `NON-005` nomme : elle fait croire à une garantie qui n'existe pas.

### C6. Deux sources se contredisent

Aux tâches 11 et 12, l'agent a écrit « statuer sur `DCN-016` ». `clia focus` disait au même moment « corriger `BUG-001` ».

**Deux réponses à la même question, et rien ne dit laquelle prime.** Un humain qui hésite entre deux directives n'en exécute aucune.

## Réponse à la question posée

**Le dépôt sait dire ce qui bloque. Il ne sait pas dire quoi faire pour débloquer.**

Tout le reste en découle : la file est celle de l'agent, les attentes adressées à l'humain ne sont pas comptées, le geste de déblocage n'existe pas comme objet, et la directive se dilue dans le rapport.

### Quatre corrections

Les trois premières retirent du travail à l'humain, la quatrième en retire à l'agent.

| Réf | Correction | Nature |
|---|---|---|
| **S1** | Une décision `suspendue` devient un item : catégorie `A APPROUVER`, destinataire humain | Code |
| **S2** | Ce qui débloque des chantiers passe devant ce que personne n'attend | Code |
| **S3** | `clia focus --humain` et `--agent` filtrent sur le destinataire | Code |
| **S4** | `MET-005` porte le format de la directive ; `skl-006` impose qu'un plan bloqué déclare par quel geste il se lève | Méthode |

### Le format de la directive, en quatre éléments

| Élément | Ce qu'il porte |
|---|---|
| **Le geste** | Une phrase à l'impératif, une seule |
| **La commande** | Ce qu'on tape, exactement |
| **Ce qu'il débloque** | Combien de chantiers, quels plans |
| **Qui** | L'humain ou l'agent |

**Et une règle de cohérence** : la directive rendue est celle que `clia focus` désigne. Si les deux divergent, la commande a raison, et l'agent corrige la commande plutôt que son message.

**C'est la règle qui empêche `C6` de se reproduire.** Sans elle, chaque correction du code laisse l'agent libre de dire autre chose.

## Limites

**Aucune des quatre corrections ne fait descendre le compteur.** `S1` l'augmente d'un item. Ce qui change est que l'humain voit lequel prendre — pas qu'il y en ait moins.

**La mesure qui compte n'a pas eu lieu.** Elle est simple : la prochaine tâche se termine-t-elle sur un geste que l'humain exécute sans demander de précision ? Elle appartient à l'humain qui la vit, et `BUG-005` reste ouvert jusque-là.

**Le poids de `S2` reste une heuristique.** « Ce qui débloque le plus » se calcule sur les liens déclarés entre un plan et sa décision. Un blocage écrit en prose n'est toujours pas compté.

**L'analyse porte sur treize tâches d'une seule session**, toutes conduites par le même agent. Ce qu'elle établit du système, elle l'établit sur un seul usage.

## Relations

- `specifie` [BUG-005](../bogues/BUG-005-aucune-directive-actionnable-a-la-fin-d-une-execution.md)
- `reference` [BUG-004](../bogues/BUG-004-un-plan-smart-n-est-pas-executable-et-rien-ne-le-signale.md)
- `reference` [ANL-011](ANL-011-focus-et-accumulation-des-items-ouverts.md)
- `reference` [MET-005](../methodologies/MET-005-execution-d-un-plan.md)
