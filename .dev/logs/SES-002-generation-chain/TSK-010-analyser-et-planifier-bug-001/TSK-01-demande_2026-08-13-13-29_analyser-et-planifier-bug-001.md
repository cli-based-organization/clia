# La demande, tâche 10 de SES-002

`MET-003` étape 1. Écrit avant toute exploration du dépôt : `BUG-001` n'est pas encore lu.

## L'énoncé, repris sans reformulation

> ## 10. [plan de rémédiation] analyse, diagnostique et planification pour BUG-001
>
> L'humain a rapporté le bogue BUG-001.
>
> Analysez-le. Inclure dans ANL produit le diagnostique et des pistes de correctifs. Émettre des objections pour toute ambiguité ou demande de clarification à fournir par l'humain.
>
> Choisir l'option de rémédiation la plus prometteuse et proruire un plan SMART.

## Ce que je comprends

Un bogue rapporté par l'humain — donc constaté dans l'usage, non dans une relecture de l'agent. La tâche demande la chaîne complète qui va du symptôme au plan : **analyser, diagnostiquer, proposer plusieurs correctifs, en choisir un, le rendre exécutable.**

L'ordre des mots compte. « Choisir l'option la plus prometteuse » est demandé à l'agent : c'est un jugement délégué, pas une question renvoyée à l'humain.

## Les livrables identifiés

| Livrable | Ce qu'il porte | Obligatoire |
|---|---|---|
| Une `ANL` | Le diagnostic et les pistes de correctif | Oui, nommée par l'énoncé |
| Un `PLN` SMART | L'option retenue, en chantiers exécutables | Oui |
| Des `NON` | Ce qui ne peut pas être tranché sans l'humain | **Si et seulement si** le filtre de `MET-005` étape 2 l'exige |

## Le type de tâche, et ce qu'il autorise

`[plan de rémédiation]` ne figure pas dans le tableau de `MET-005` étape 1. Je le range avec `[planification]` : **la tâche produit un plan, elle ne l'exécute pas.** Le plan produit ici restera `propose`.

C'est exactement ce que `BUG-002` reproche : un plan exécuté par la tâche qui le crée supprime le point où l'humain décide qui exécute et quand. La tâche 10 est le premier cas d'application de la règle depuis qu'elle est écrite.

## Ce que je surveille

**La tâche 9 vient d'établir que 31 % des objections ouvertes n'avaient pas lieu d'être.** L'énoncé dit « émettre des objections pour toute ambiguïté » — et la session dit ailleurs de n'en émettre que pour ce qui ne peut pas être géré en best effort documenté. Je tiens les deux : le filtre de `MET-005` étape 2 tranche, et ce qui passe du côté « avancer » est consigné dans le journal, pas ouvert en `NON`.

**`BUG-001` porte `etat: À RENSEIGNER`.** Constaté à la tâche 9. Le bogue n'a jamais été qualifié ; l'analyse devra dire s'il est reproductible avant de planifier quoi que ce soit.

## Ce que je ne sais pas encore

Le contenu de `BUG-001`. Son titre — « exécution de claude cli sans interruption » — laisse attendre un sujet d'automatisation, mais je n'ai pas lu le corps et je ne préjuge pas de ce qu'il décrit.
