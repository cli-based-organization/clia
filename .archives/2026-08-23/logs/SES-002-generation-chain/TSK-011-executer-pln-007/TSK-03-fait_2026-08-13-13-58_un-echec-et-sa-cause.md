# Ce qui a été fait, tâche 11 de SES-002

`MET-003` étape 3.

## L'exécution a échoué, et voici ce que cela veut dire

**Zéro chantier de `PLN-007` exécuté.** Ce n'est pas le résultat attendu : c'est un échec, et `MET-005` prescrit de le nommer comme tel plutôt que de clore la tâche en la déclarant réussie.

| Chantier | État |
|---|---|
| A à E | Bloqués : ils appliquent `DCN-016`, `effet: suspendue` |
| F | Déjà satisfait, par `PLN-011` à la tâche 9 |
| G | Déjà satisfait, par la tâche 2 |

**Le chantier A est le seul à ne dépendre de rien**, et je ne l'ai pas exécuté : il ferait déclarer par `RES-001` quatre champs qu'aucun schéma ne porte, qu'aucune instance ne renseigne, qu'aucune commande ne lit. `NON-005` nomme ce défaut — « une règle écrite et non tenue est pire que son absence ».

## La cause, et pourquoi elle méritait un bogue

**`PLN-007` satisfait `PDC-003` et n'est pas exécutable.** Les deux propriétés coexistent, et rien dans le système ne les distinguait.

`clia focus` le rangeait en `A EXECUTER`, deuxième priorité du dépôt, depuis quatre tâches. Son critère compte les `**Livrable**` et les `**Critère de réussite**` du fichier : `PLN-007` en a sept de chaque.

**L'information manquante était écrite en clair.** Le plan cite `DCN-016` dans son frontmatter, dans ses relations et dans ses objections ; `DCN-016` porte `effet: suspendue` depuis le 2026-08-11. Le lien était déclaré, personne ne le suivait.

**Ce n'est pas `BUG-002`.** Celui-là porte sur un plan exécuté par la tâche qui l'a créé. Ici le plan n'a jamais été exécutable, et le système le présentait comme prêt. Même symptôme, causes distinctes.

---

# Ce qui a été livré, et comment s'en servir

`MET-005` étape 4.

## `clia focus` ne propose plus un plan bloqué — `FNC-007` étendue

**Ce qui a été livré.** Un plan dont le corps cite une décision portant `effet: suspendue` n'est plus rangé à exécuter. Il va à défricher, avec son préalable nommé.

**Comment s'en servir.** Rien à apprendre, la commande est la même.

```sh
clia focus --tout
```

```
A DEFRICHER
  PLN-007   Mise en oeuvre des quatre champs d'état (prealable suspendu : DCN-016)
```

**Ce que la file d'attente devient.** `A EXECUTER` passe de deux plans à un seul — `PLN-015`, qui n'attend rien ni personne.

**Ce qui ne marche pas encore.** La détection ne suit que les décisions suspendues. Un plan bloqué par une issue ouverte, ou par un point d'arrêt écrit en prose comme celui du chantier B de `PLN-007` — « le sort de `status` doit être tranché » — passe toujours pour prêt.

**Ce qu'elle détecte, exactement** : toute mention d'un alias `DCN` dans le corps du plan. C'est large à dessein : un faux positif range le plan à défricher avec son motif visible, un faux négatif est ce que ce bogue constate. Aucun faux positif sur les quatorze plans du dépôt.

---

## Décidé en avançant

**Rendre le défaut mécanique plutôt que de seulement l'écrire.** `MET-004` étape 6 pose déjà « ne pas implémenter un livrable dont le préalable est ouvert, même s'il est SMART ». La règle existait et n'était tenue par rien — c'est la définition du défaut que `NON-005` décrit. Corriger `clia focus` est du code, réversible, une lecture raisonnable : le filtre range du côté « avancer ».

## Écarté

**Réévaluer `PLN-007` par `MET-004` et le scinder.** Ce serait de la planification ; la tâche est `[implémentation]`.

**Approuver `DCN-016`.** `CONSTITUTION.md` C1, et `DCN-013` pose l'approbation manuelle.

## Livrables

| Fichier | Nature |
|---|---|
| `.dev/bogues/BUG-004-...md` | Création |
| `lib/clia/focus.sh` | Détection du préalable suspendu |
| `tests/test_clia.sh` | **4 assertions**, 275 → 279 |
| `.dev/plans/PLN-007-...md` | Section « Statut » : l'état réel des sept chantiers |
