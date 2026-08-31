# Demande interprétée, tâche 6 de SES-002

Écrit avant toute exploration. `MET-003` étape 1.

## Ce que l'humain demande

Une **analyse de l'historique de travail**, avec recommandations, un plan SMART par recommandation, et des `NON` **uniquement** pour ce qui ne peut pas être traité en mode best effort documenté.

Plus deux évaluations : la pertinence d'un type `Fonctionnalité` et d'un type `Note d'implémentation`.

Et l'application de `PDC-005`, qui vient d'être écrit.

## Ce que l'humain constate

Il le formule sans détour, et je le reprends tel quel plutôt que de l'adoucir.

> l'humain a demandé l'implémentation de plusieurs de fonctionnalités clefs. Mais l'agent IA a suivi la "procédure" et
> 1. nous sommes toujours bloqué
> 2. les ressources et les choses à faire s'accumulent ce qui empire la situation

**C'est une critique de ma méthode, pas du système.** Les documents qui s'accumulent, c'est moi qui les produis. À chaque tâche exécutée, j'ouvre un ou deux documents qui appellent une décision humaine, et je clos rarement quoi que ce soit.

## Ce que l'humain garde et ce qu'il veut

| Ce qui marche | Ce qui manque |
|---|---|
| `clia res ls RESSOURCE` pour la vue d'ensemble | Il ne dit rien de l'état de chaque ressource |
| Les `NON` pour regrouper ce qu'il doit clarifier | Il y en a trop, et rien ne dit où porter l'effort |
| Les `PLN` SMART pour décider quoi implémenter | On ne sait pas ce qu'ils implémentent, ni s'ils sont exécutés |
| Les `ISU` pour les sujets à réflexion | Ils ne sont pas concrètement utilisables |

**Le besoin est nommé** : « Un humain a besoin de focus et d'une seule action claire à prendre pour pouvoir agir. »

## Les quatre questions

1. Comment permettre un meilleur focus sur une fonctionnalité ou un groupe ?
2. Comment faire que l'agent implémente malgré l'incertitude, en mode best effort documenté ?
3. Comment garder, dans ce mode, les objections importantes et les plans SMART ?
4. **Comment faire que plus on travaille, plus le nombre d'items à faire diminue ?**

**La quatrième est la vraie question.** Les trois autres en découlent.

## Ce que `PDC-005` change pour cette tâche même

`PDC-005` dit que l'agent décide et procède, et documente sa décision. Il exclut les risques importants : trop coûteux, ou aux conséquences graves prévisibles.

**Appliqué ici** : je produis l'analyse, les plans et les recommandations sans attendre de réponse, et je n'ouvre de `NON` que pour ce qui ne peut pas être décidé en avançant.

**Une tension à surveiller.** `PDC-005` demande de documenter chaque décision dans un `NON` ; la tâche demande des `NON` **uniquement** pour ce qui ne peut pas être traité en best effort. Les deux ne disent pas la même chose. La tâche est plus récente et plus précise : je la suis, et je le signale.

## Le livrable

Une `ANL`, un `PLN` SMART par recommandation, et le minimum de `NON`.

**Ce qui serait contradictoire** : produire une analyse sur l'accumulation de documents en produisant dix documents. Le nombre de livrables est lui-même un critère de réussite de cette tâche.

## Ce qui reste à établir

Les mesures. Combien de `NON` ouverts, combien de `PLN` jamais engagés, combien d'items créés par tâche exécutée, et comment ces nombres ont évolué. Je n'ai encore rien compté.
