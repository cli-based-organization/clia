# Analyse, tâche 11 de SES-002

`MET-003` étape 2.

## L'état des sept chantiers, chantier par chantier

Chacun a été confronté à l'état réel du dépôt, pas au journal du plan.

| Chantier | État | Mesure |
|---|---|---|
| A. Déclarer les 4 champs dans `RES-001` | **Bloqué** | Applique `DCN-016`, `effet: suspendue` |
| B. Porter les 4 champs dans `commun.cue` | **Bloqué** | Point d'arrêt déclaré par le plan : le sort de `status`, `ISU-009` ouverte |
| C. Déclarer `domain-status` dans 36 définitions | **Bloqué** | Dépend de A |
| D. Poser les 4 champs sur 157 instances | **Bloqué** | Dépend de B et C |
| E. Supprimer les 154 champs anciens | **Bloqué** | Dépend de D |
| F. Afficher le bon champ dans le CLI | **Fait autrement** | `clia res ls objection` affiche 3 valeurs distinctes, livré par `PLN-011` le 2026-08-13 |
| G. Contrôle de valeur unique | **Fait** | `clia res check` existe et signale 5 champs constants, exécuté par la tâche 2 |

**Deux chantiers sur sept sont déjà satisfaits. Cinq sont bloqués par le même préalable.**

## Le préalable, et pourquoi il tient

`DCN-016` porte `effet: suspendue`, et son propre corps l'explique : « Premier jet produit par l'agent, non actif. `DCN-013` pose qu'un premier jet d'IA reste suspendu jusqu'à approbation manuelle de l'humain. »

**`PLN-007` le déclare lui-même**, dans ses objections : « Exécuter ce plan avant l'approbation reviendrait à appliquer une décision qui n'en est pas une. »

Vérifié ce jour : `DCN-016` est toujours `suspendue`, `ISU-009` toujours `ouverte`.

## Pourquoi je n'exécute pas le chantier A malgré tout

C'est le seul qui ne dépende de rien, et il est réversible. Le mode best effort documenté pousserait à l'exécuter.

**Il produirait une règle écrite et non tenue.** `RES-001` déclarerait quatre champs qu'aucun schéma ne porte, qu'aucune instance ne renseigne, et qu'aucune commande ne lit. C'est exactement le défaut que `NON-005` nomme : « une règle écrite et non tenue est pire que son absence, parce qu'elle fait croire à une garantie. »

**Le filtre de `MET-005` étape 2 range ce cas du côté « s'arrêter »** par sa troisième ligne : deux lectures mènent à des travaux incompatibles, selon que `DCN-016` est approuvée telle quelle ou révisée.

## L'anomalie que cette tâche révèle

**`PLN-007` satisfait `PDC-003` et n'est pas exécutable.** Les deux propriétés coexistent, et rien dans le système ne les distingue.

`clia focus` le range en `A EXECUTER` — je l'ai constaté à chaque tâche depuis le 2026-08-13. Son critère ne regarde que la présence d'un livrable et d'un critère par chantier, ce que le plan a.

**C'est l'écart que l'humain a énoncé à la tâche 8** : « un plan SMART signifie qu'on peut exécuter le plan et qu'il produira les livrables planifiés ; sinon, c'est une ERREUR et il faut ouvrir un BUG ».

**Ce n'est pas `BUG-002`.** Celui-là porte sur un plan exécuté par la tâche qui le crée. Ici le plan n'a jamais été exécuté par personne : il est bloqué, et le système le présente comme prêt. Deux causes distinctes pour un même symptôme — une demande d'exécution qui ne produit rien.

## Ce que je fais

`MET-005`, rubrique « ce qui n'est pas fait » : nommer l'anomalie, en chercher la cause, proposer l'action utile — et ne pas clore la tâche en la déclarant réussie.

| Geste | Motif |
|---|---|
| Ouvrir `BUG-004` | La règle énoncée par l'humain est enfreinte, et la cause diffère de `BUG-002` |
| Rendre le défaut mécanique dans `clia focus` | Un plan dont un préalable est suspendu ne doit plus être proposé à l'exécution. C'est du code, réversible : le filtre range du côté « avancer » |
| Mettre à jour la section « Statut » de `PLN-007` | Deux chantiers sont satisfaits et le plan ne le dit pas |
| Laisser `PLN-007` en `propose` | `MET-005` étape 5 : un plan partiellement exécuté ne passe pas à `execute` |

**Ce que la correction de `clia focus` change concrètement** : le plan cesse d'occuper la deuxième place de la file d'attente de l'humain, et se range là où il attend vraiment — une approbation.

## Ce que j'écarte

**Réévaluer `PLN-007` par `MET-004` et le scinder.** Ce serait de la planification, et la tâche est `[implémentation]`. Le geste appartient à une tâche ultérieure, si l'humain le veut.

**Approuver `DCN-016` moi-même.** `CONSTITUTION.md` C1 réserve les décisions à l'humain, et `DCN-013` pose explicitement l'approbation manuelle.
