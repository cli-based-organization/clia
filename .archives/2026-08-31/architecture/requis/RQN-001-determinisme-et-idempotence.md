# RQN-001 — Déterminisme et idempotence

## L'exigence

Le CLI est **entièrement déterministe** : mêmes entrées, même état de départ,
mêmes sorties et mêmes effets. Il n'improvise pas, il ne consulte aucun modèle,
il ne fait aucun choix qui varie d'une exécution à l'autre.

Toute commande qui modifie quelque chose est **idempotente** : l'exécuter une
seconde fois sur le résultat de la première ne produit aucun effet
supplémentaire, et le dit.

## Portée

Toutes les commandes, sans exception.

## Pourquoi c'est opposable

C'est ce qui rend le partage de responsabilité possible. L'agent est non
déterministe par nature ; **ce que le CLI garantit, l'agent n'a plus à le
garantir**. C'est la seule manière connue de rendre vérifiable une partie du
travail d'un agent.

L'idempotence, elle, est ce qui rend une commande sûre à relancer — donc
lançable souvent, donc réellement employée.

## Comment on le constate

- Deux exécutions successives d'une même commande mutante : la seconde ne
  modifie rien et l'annonce.
- Aucune sortie ne contient d'horodatage, d'ordre variable ou d'identifiant
  aléatoire, sauf demande explicite de l'appelant.
- Un banc rejoue une séquence complète et compare l'état final octet par octet.

## Ce qui est admis

Une commande peut **lire** l'état courant pour décider — c'est même la condition
de l'idempotence (`RQF-004`). Ce qu'elle ne peut pas, c'est en dépendre pour
produire un résultat différent à état identique.

## Origine

`PDC-001` de G1, `FND-001` de G2 section 4.5. C'est la seule propriété que
`FND-001` retenait comme argument décisif en faveur d'un CLI face à un agent.
