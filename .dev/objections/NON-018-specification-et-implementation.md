---
type: objection
id: NON-018
title: "Frontière entre spécification et implémentation"
status: draft
maturity: conception
adoption: propose
activated: true
domain-status: "repondue"
initiateur: agent
effet: bloquant
etat: repondue
porte-sur: [ADR-006, ADR-001, RES-018]
---

# NON-018 - Frontière entre spécification et implémentation

> `ADR-006` acte la séparation stricte demandée par la tâche 10, et le test qu'il définit échoue immédiatement : `clia` compte 1 600 lignes de code face à zéro spécification, et plusieurs documents de spécification violent la règle d'agnosticisme qu'ils viennent de poser.

## Journal

- 2026-08-10 : ouverte par l'agent, à la production de `ADR-006`.
- 2026-08-13 : passe a `repondue` par `PLN-010`, chantier B. Critere mecanique : chaque question porte une reponse. Aucune reponse n'a ete interpretee.

## Ce qui est contesté

Quatre points, du plus mesurable au plus théorique.

**La dette de spécification est totale.** `clia` compte 1 600 lignes de bash et quatre-vingt-onze tests. Les types `SPC`, `RQF`, `RQNF`, `USE` et `CMP` sont définis depuis le 2026-08-10 et n'ont **aucune instance**. La grammaire des commandes, l'ordre nom puis verbe, les formes d'identifiant acceptées, le format des sorties : rien de tout cela n'existe hors du code et de son aide.

**Plusieurs documents de spécification nomment une technologie.** `ADR-006` D2 l'interdit. `ADR-001` D2 décide que la ressource est un fichier markdown à frontmatter YAML, ce qui nomme deux formats. `ADR-003` D3 s'appuie sur des outils nommés. `RES-026` cite bash.

**Le statut des skills est indéterminé.** `ADR-006` D1 les range en implémentation parce qu'ils nomment des commandes concrètes. Leur partie normative, ce qu'il faut vérifier, est pourtant de la spécification.

**Les artefacts dérivés sont au mauvais endroit.** Les soixante schémas et les vingt-neuf gabarits sont de l'implémentation selon D6, et ils vivent dans `.dev/` avec la spécification. La contradiction est déclarée et non corrigée.

## Pourquoi cela ne peut pas rester implicite

Trois raisons.

**Le test de D4 est le test que le corpus a échoué onze fois.** `ANL-001` mesure onze CLI réinventés en vingt-et-un mois, dont neuf abandonnés et un jamais commité malgré un CLI Go fonctionnel. Chacun emportait sa conception. Si le douzième fait de même, la décision de la tâche 10 n'aura servi à rien.

**Une règle violée par les documents qui la posent ne tient pas.** `ADR-006` D2 interdit de nommer une technologie dans la spécification, et `ADR-001` D2 en nomme deux. L'un des deux doit céder.

**Le risque symétrique est mortel et documenté.** `disruptiva-dev/comm-cli` a produit une spécification complète, constitution de deux cent trente lignes, trois ADR, neuf spécifications de ressources, et **aucune ligne de code**. Il est mort en deux jours. Valoriser la spécification sans garde-fou reproduit cet échec.

## Questions

### Q1 - Faut-il écrire les spécifications manquantes, et dans quel ordre ?

Trois candidates, par ordre d'urgence apparente : la grammaire du CLI, qui n'existe que dans le code ; le modèle de ressources, dont la spécification est dispersée dans trente définitions ; la validation, dont le cahier des charges est un skill.

**Réponse.**

### Q2 - Le format est-il une propriété de la spécification ou de l'implémentation ?

`ADR-006` D2 dit implémentation, donc `ADR-001` D2 est en faute. La position inverse est tenable : le markdown à frontmatter est une propriété observable du système, indépendante du langage qui le manipule, donc de la spécification.

Trancher dans un sens oblige à scinder `ADR-001` D2 ; dans l'autre, à affaiblir `ADR-006` D2.

**Réponse.**

### Q3 - De quel côté tombent les skills ?

`ADR-006` D1 les range en implémentation, avec réserve. Trois positions : implémentation entière ; spécification entière, en retirant les commandes concrètes ; ou scission, la partie normative en spécification et les commandes en implémentation.

**Réponse.**

### Q4 - Faut-il une trace bidirectionnelle ?

`ADR-006` D3 exige que l'implémentation déclare ce qu'elle implémente, et c'est fait. Le sens inverse manque : aucune décision de spécification ne dit si elle est implémentée. Sans lui, on ne peut pas savoir ce qui reste à faire.

**Réponse.**

### Q5 - L'absence de spécification interdit-elle d'implémenter ?

`ADR-006` D5 se contente d'en faire une dette nommée, ce qui est plus faible qu'une interdiction. Une interdiction aurait empêché la tâche 6 de produire le CLI, ce qui aurait été absurde.

Faut-il une règle intermédiaire, du type : une implémentation peut précéder sa spécification, à condition que la spécification soit écrite avant la deuxième implémentation ?

**Réponse.**

### Q6 - Comment se garder du travers inverse ?

`comm-cli` est mort d'avoir spécifié sans implémenter. Candidats : un délai maximal entre une spécification et sa première implémentation ; l'exigence qu'une spécification cite le besoin qui la motive ; ou aucune garde, en assumant le risque.

**Réponse.**

### Q7 - Les artefacts dérivés doivent-ils être déplacés ?

Ils sont de l'implémentation et vivent avec la spécification. Le déplacement porte sur quatre-vingt-neuf fichiers, tous régénérables, donc le coût est faible. `ADR-006` D6 l'a néanmoins reporté.

**Réponse.**

## Ce qui lèverait cette objection

Une réponse à Q1 et Q2.

Q1 décide si la dette est traitée ou nommée. Q2 résout une contradiction interne entre deux ADR, et la laisser ouverte rend la règle d'agnosticisme inapplicable.

L'effet est `bloquant` pour un motif précis : `ADR-006` pose un test que le système échoue aujourd'hui, et acter la décision sans savoir si l'on compte y répondre serait acter un constat d'échec.

## Relations

- `objecte-a` [ADR-006](../adr/ADR-006-separation-specification-implementation.md)
- `objecte-a` [ADR-001](../adr/ADR-001-adoption-de-la-notion-de-ressource.md)
- `reference` [ANL-002](../analyses/ANL-002-localisation-du-cli-clia.md)
- `reference` [RES-020](../ressources/RES-020-specification.md)
