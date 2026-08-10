---
type: objection
id: NON-regime-de-travail
title: "Régime de travail, échelles et arbitrage"
status: draft
initiateur: agent
effet: informatif
etat: ouverte
porte-sur: [RES-objection, RES-intention]
---

# NON-008 - Régime de travail, échelles et arbitrage

> Les sept ressources fondamentales ne disent rien du régime de travail qui les emploie. Deux échelles de travail existent et une seule est modélisée, et le mécanisme d'objection ne dit pas qui arbitre en cas de désaccord persistant.

## Journal

- 2026-08-09 : ouverte par l'agent, à la production du premier jet des ressources fondamentales.

## Ce qui est contesté

Non pas le contenu des sept définitions, mais ce qu'elles présupposent et laissent hors champ.

Elles présupposent un régime de travail où une demande arrive, un travail se fait, une ressource est produite. Ce régime décrit bien la tâche de trente minutes. Il ne décrit pas le chantier de deux semaines à quarante-quatre tâches, qui est aussi une réalité mesurée.

Elles instituent un mécanisme d'objection sans dire qui arbitre lorsque l'objection est maintenue.

## Pourquoi cela ne peut pas rester implicite

`ANL-001` établit au défaut D9 que deux échelles cohabitent et qu'une seule est modélisée. Les quatre sessions archivées de `clia` couvrent respectivement 21 tâches en 37 heures, 4 tâches en 6,5 jours, 44 tâches en 14 jours, et 4 tâches en 2,7 jours. La durée médiane d'une tâche est de trente minutes ; vingt-deux pour cent des tâches journalisées sont déclarées partielles.

La session du 2026-07-31 formule elle-même le problème dans sa tâche 2 : il y a beaucoup à faire, il est impossible de tout faire en même temps même avec l'IA, et il faut un moyen de garder en mémoire ce qui doit être fait et de prioriser.

Le corpus contient trois réponses déjà éprouvées à cette question, et elles n'ont jamais été comparées : les répertoires `en-cours` et `todo` de `nty`, les sept fiches d'amélioration numérotées de `comm-cli`, et le couple issue non-smart plus ticket extreme-smart de `ticket-driven-ai`, ce dernier étant explicitement borné à un livrable et à une timebox de douze heures.

Sur l'arbitrage, `RES-004` institue un état `levee-par-decision` qui suppose que quelqu'un décide, sans dire qui ni comment. La gouvernance objection-sociocratique héritée de `intentional-doers-governance` n'a jamais reçu d'essai de fondation dédié : le mécanisme central de la méthode a été adopté avant d'être fondé.

## Questions

### Q1 - Faut-il un type pour l'échelle intermédiaire, entre la session et la tâche ?

La session est un contenant unique pour deux réalités. Un chantier de deux semaines n'a aucune structure interne. `clia` a retiré le ticket au profit de la session, et la souplesse a rouvert le problème.

**Réponse.**

### Q2 - Les trois réponses déjà éprouvées ont-elles été comparées, et si non, faut-il le faire avant d'en inventer une quatrième ?

Une analyse comparative des trois coûterait peu et manque. C'est la recommandation que `ANL-001` place en tête de ses lacunes fonctionnelles.

**Réponse.**

### Q3 - Pourquoi le ticket extreme-smart a-t-il été abandonné ?

C'est l'une des quatre ruptures de cap non actées du défaut D3. La réponse à cette question serait la première trace écrite de cette décision, et elle conditionne Q1 : si le ticket a été abandonné pour une bonne raison, il ne faut pas le réintroduire sous un autre nom.

**Réponse.**

### Q4 - Qui arbitre lorsque l'agent maintient une objection que l'humain lève ?

`RES-004` prévoit l'état `levee-par-decision` et exige que la décision soit tracée. Mais le mécanisme ne dit pas si l'agent doit alors exécuter, refuser, ou exécuter en consignant son désaccord. La position implicite du corpus est que l'humain décide, ce qui est cohérent avec la responsabilité, et devrait être écrit.

**Réponse.**

### Q5 - L'état partiel doit-il être représenté dans les ressources, ou seulement dans les traces ?

Vingt-deux pour cent des tâches journalisées sont déclarées partielles. C'est un état normal du travail, et aucun des sept types ne le représente : ils ont un `status` qui vaut `draft`, `stable` ou `deprecated`, ce qui décrit la maturité et non l'inachèvement.

**Réponse.**

### Q6 - Le coût de reprise après un creux de plusieurs mois est-il pris en compte par le modèle ?

`ANL-001` établit que le travail se fait par vagues séparées de creux allant jusqu'à quatre mois, avec trente-six pour cent des commits entre 21h et 6h. `RES-002` justifie le contexte par cette contrainte. Est-ce suffisant, ou faut-il un dispositif dédié à la reprise ?

**Réponse.**

### Q7 - La gouvernance objection-sociocratique doit-elle recevoir un essai de fondation ?

Elle est le mécanisme central de la méthode, adoptée en juillet 2026 sans travail de fondation dédié. `intentional-doers-governance` avait prévu un rapport de recherche sur le sujet, dans `PLN-007`. A-t-il été produit, et sinon, la méthode peut-elle être publiée sans lui ?

**Réponse.**

## Ce qui lèverait cette objection

Cette objection est déclarée `informatif` : elle ne bloque pas le travail sur les ressources fondamentales, qui est l'objet de la session en cours.

Sa fonction est de mémoire, au sens que `RES-004` donne à ce niveau d'effet : `ANL-001` établit que les questions ouvertes se perdent dans ce corpus, et que les mêmes idées y sont réinventées jusqu'à cinq fois. Q2 et Q3 sont les deux questions dont la perte serait la plus coûteuse.

## Relations

- `objecte-a` [RES-004](../ressources/RES-004-objection.md)
- `reference` [RES-002](../ressources/RES-002-contexte.md)
- `derive-de` [ANL-001](../analyses/ANL-001-observation-corpus-repos-et-pratiques/analyse-critique.md)
