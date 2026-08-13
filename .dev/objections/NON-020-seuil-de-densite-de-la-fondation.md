---
type: objection
id: NON-020
title: "Le seuil de densité de MET-001 n'est pas atteignable"
status: draft
maturity: conception
adoption: propose
activated: true
domain-status: "repondue"
initiateur: agent
effet: conditionnel
etat: repondue
porte-sur: [MET-001, RES-011]
---

# NON-020 - Le seuil de densité de MET-001 n'est pas atteignable

> `MET-001` exige dix sources distinctes par question de recherche. Sa première application délibérée, `FND-003`, en atteint 6,4 au prix d'une tâche entière. Un seuil qu'aucune application n'atteint ne mesure rien : il transforme chaque fondation en échec déclaré.

## Journal

- 2026-08-10 : ouverte par l'agent, à la tâche 14, après la mesure de l'étape 10 de `FND-003`.
- 2026-08-13 : passe a `repondue` par `PLN-010`, chantier B. Critere mecanique : chaque question porte une reponse. Aucune reponse n'a ete interpretee.

## Ce qui est contesté

Le tableau « Résultat attendu » de `MET-001` fixe deux seuils quantitatifs, et `FND-003` échoue sur les deux.

| Critère | Seuil de `MET-001` | `FND-002` | `FND-003` |
|---|---|---|---|
| Sources par question | 10 | 4 | 6,4 |
| Pages par question | 2 à 4 | environ 30 lignes | 1,8 |

`FND-003` a été produite en connaissant le seuil, en cherchant à l'atteindre, et avec le format de citation complet exigé. Elle a mobilisé trente-deux sources dans sept domaines. Elle reste à 64 pour cent de la cible.

Ce n'est pas contesté comme une insuffisance de la recherche. C'est contesté comme une mauvaise calibration du seuil.

## Pourquoi cela ne peut pas rester implicite

Trois raisons.

**Un seuil jamais atteint cesse d'être un seuil.** Les deux fondations du dépôt échouent sur le même critère. Un critère que rien ne satisfait ne discrimine plus entre une recherche sérieuse et une recherche bâclée, et il sera ignoré, ce qui est le sort de toute règle non tenue. `NON-005` conteste cette accumulation depuis le 2026-08-09.

**Le calcul est mécanique et il est connu d'avance.** Dix sources par question sur cinq questions font cinquante sources à lire, situer, référencer et vérifier. `MET-001` autorise jusqu'à huit questions, soit quatre-vingts sources. Aucune tâche du dépôt n'a jamais approché ce volume, et rien n'indique qu'une seule le puisse.

**Le seuil pousse dans la mauvaise direction.** Pour l'atteindre à effort constant, la voie la plus simple est de réduire le nombre de questions. `FND-003` l'a déjà fait, en passant de huit questions possibles à cinq, et le déclare à son étape 2. Un seuil dont l'effet observé est de réduire la portée de la recherche produit l'inverse de ce qu'il visait.

## Ce que la mesure de FND-003 établit

L'étape 10 de `FND-003` mesure dix critères. Huit sont satisfaits, deux échouent, et les deux qui échouent sont les deux seuils quantitatifs.

Ce qui est satisfait est exactement ce que la tâche 11 reprochait à `FND-002` : références complètes, date de consultation par source, vérification consignée source par source, moitié des sources primaires. Les exigences de forme de `MET-001` sont donc applicables et utiles.

L'objection ne porte que sur les deux nombres.

## Questions

### Q1 - Le seuil de dix sources par question doit-il être abaissé ?

Trois positions.

Abaisser à un nombre atteint par une recherche sérieuse, six ou sept, ce que `FND-003` établit comme le coût réel d'une tâche.

Conserver dix et déclarer explicitement qu'une fondation conforme demande plusieurs tâches, ce qui rend le seuil honnête au prix d'un format que le dépôt n'a jamais employé.

Remplacer le seuil absolu par un seuil relatif à la question : les questions ne demandent pas toutes la même densité, et `FND-003` le montre, sa QR5 étant traitée par cinq sources solides tandis que sa QR1 n'a de réponse que négative.

**Réponse.**

### Q2 - Une fondation peut-elle s'étaler sur plusieurs tâches ?

Rien dans `MET-001` ni dans `RES-011` ne le prévoit. Une fondation est produite en une fois, et son statut reste `draft`.

Si la réponse à Q1 est de conserver le seuil, cette question doit être tranchée dans le même mouvement, sans quoi le seuil reste inatteignable pour une raison purement structurelle.

**Réponse.**

### Q3 - Le nombre de questions doit-il être réduit plutôt que la densité ?

`MET-001` autorise deux à huit questions. `FND-003` en a retenu cinq et déclare l'arbitrage.

Si le budget réel est d'environ trente sources par tâche, alors trois questions à dix sources sont conformes là où cinq à six ne le sont pas, pour un même effort. Faut-il alors abaisser le plafond de questions à trois ou quatre, ce qui rendrait le seuil de dix atteignable sans le modifier ?

Cette position a un coût : elle interdit les recherches à large spectre, dont `FND-002` avec ses huit questions était un cas.

**Réponse.**

### Q4 - Que devient la mention d'échec dans les fondations déjà produites ?

`FND-003` déclare échouer sur deux critères. Si le seuil est abaissé, cette déclaration devient fausse, et une correction serait tentante.

Or `FND-003` est un point de mesure : elle dit ce qu'une tâche produit réellement. Faut-il la corriger, ou conserver la déclaration telle quelle en la datant du seuil alors en vigueur ?

La seconde position est cohérente avec `RES-009` R1 : on ne réécrit pas ce qui a été, on enregistre ce qui change.

**Réponse.**

### Q5 - Les sections déclarées par RES-011 et la structure imposée par MET-001 se contredisent

Constat mesuré le 2026-08-10 : les **trois** fondations du dépôt échouent au contrôle de sections.

`RES-011` déclare `sections: [Objet et méthode, Corps de la revue, Ce que la recherche établit, Sources, Limites, Relations]`. `MET-001` impose une structure en dix étapes numérotées, plus une bibliographie. Une fondation ne peut pas satisfaire les deux : `FND-003`, qui suit `MET-001` scrupuleusement, porte « Bibliographie » là où `RES-011` attend « Sources », et « Limites de cette recherche » là où elle attend « Limites ».

Ce n'est pas un défaut de rédaction, c'est un conflit entre la définition du type et la méthodologie qui le produit. Il tient tant que les deux documents ne sont pas alignés.

Trois positions. Aligner `RES-011` sur les dix étapes, ce qui fige la méthodologie dans la définition du type. Aligner `MET-001` sur les six sections, ce qui perd la traçabilité étape par étape qui a fait la valeur de `FND-003`. Ou déclarer que les `sections` d'un type sont un minimum et non une structure, auquel cas seuls les intitulés doivent être repris.

La troisième position demande de vérifier ce que `sections` signifie pour tous les types, et pas seulement pour celui-ci.

**Réponse.**

## Ce qui lèverait cette objection

Une réponse à Q1, qui commande Q2 à Q4. Q5 est indépendante et peut être tranchée seule.

L'effet est `conditionnel` : `MET-001` reste applicable et a démontré son utilité sur `FND-003`. Seuls deux nombres de son tableau de résultat attendu sont contestés, et rien de ce qui a été produit n'en dépend.

## Relations

- `objecte-a` [MET-001](../methodologies/MET-001-recherche-de-fondation.md)
- `objecte-a` [RES-011](../ressources/RES-011-fondation.md)
- `reference` [FND-003](../fondations/FND-003-decisions-institutionnelles-tracables.md)
- `reference` [NON-005](NON-005-validation-et-regles-non-tenues.md)
