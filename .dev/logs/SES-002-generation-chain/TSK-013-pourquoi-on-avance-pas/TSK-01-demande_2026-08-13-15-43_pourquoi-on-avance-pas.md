# La demande, tâche 13 de SES-002

`MET-003` étape 1. Écrit avant toute exploration.

## L'énoncé, repris sans reformulation

> ## 13. [rapport de bogue] Pourquoi on avance pas
>
> Les plans PLN-015 et PLN-017 ont été exécutés pendant 8 minutes mais ils ont échoué ou n'ont rien produit ou n'ont pas bien rapporter le problème.
>
> Aucune directive claire et compréhensible pour l'humain n'a été fournit pour avancer et débloquer la situation.
>
> Ce n'est pas un comportement acceptable. Consigner cet incident dans un rapport BUG.
>
> Dire pourquoi dans une analyse ANL. Proposer une solution.
>
> Réécrire les skills et les méthodes d'exécution et d'écriture de plans pour que cette situation ne se produise pas.

## Ce que je comprends

**Le grief porte sur mon travail des deux tâches précédentes, et il est fondé.** Je l'accepte tel qu'il est énoncé.

Trois reproches distincts, et le troisième est le vrai :

| Reproche | Ce qu'il vise |
|---|---|
| Les plans ont échoué ou n'ont rien produit | Le résultat |
| Ils n'ont pas bien rapporté le problème | La restitution |
| **Aucune directive claire pour débloquer** | **Ce qui rend l'humain incapable d'agir** |

**Les deux premiers, je les ai déclarés moi-même.** Zéro chantier sur sept pour `PLN-007`, chantier A échoué pour `PLN-015` — c'est écrit dans les journaux et dans ce que j'ai rendu. Ce n'est donc pas là que le système a manqué.

**Le troisième est celui qui compte.** J'ai nommé des gestes — « statuer sur `DCN-016` » — mais en fin de message, après quarante lignes de rapport technique, sans dire **comment** on statue, ni ce que cela change. Une action nommée n'est pas une directive.

## Une ambiguïté que je tranche sans objection

**`PLN-017` n'existe pas.** Le dépôt s'arrête à `PLN-015`. Les deux plans exécutés aux tâches 11 et 12 sont `PLN-007` et `PLN-015`, et le grief leur correspond exactement : l'un n'a rien produit, l'autre a échoué sur son premier chantier.

Je lis donc « `PLN-015` et `PLN-017` » comme « `PLN-007` et `PLN-015` ». Une lecture raisonnable existe, se tromper coûte une correction : le filtre de `MET-005` étape 2 range du côté « décider et avancer ».

## Les livrables

| Livrable | Ce qu'il porte | Prescrit par |
|---|---|---|
| Un `BUG` | L'incident consigné | « Consigner cet incident dans un rapport BUG » |
| Une `ANL` | Pourquoi, et la solution proposée | « Dire pourquoi dans une analyse ANL » |
| Les méthodes réécrites | Ce qui empêche la récidive | « Réécrire les skills et les méthodes » |

**Le troisième livrable est une modification, pas une création** : `MET-005` porte l'exécution d'un plan, `MET-004` sa réévaluation. Je ne sais pas encore ce qui existe côté skills.

## Ce que je surveille

**Ne pas répondre au grief par ce qui l'a causé.** Le reproche est qu'il y a trop de rapport et pas assez de directive. Produire une analyse de plus, longue et complète, serait la pire réponse possible si elle ne se termine pas par un geste unique, écrit pour être exécuté.

**Ne pas ouvrir d'objection.** La session demande de n'en émettre que pour ce qui ne peut pas être géré en best effort. Ce qui est demandé ici est clair.

**Le compteur.** Trois livrables de plus, dont un bogue ouvert. L'humain se plaint que rien n'avance ; ajouter des items sans en retirer serait aggraver le mal que la tâche dénonce.
