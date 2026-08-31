# RQF-006 — Le système répond à « que dois-je faire maintenant ? », pour un acteur donné

## Ce que le système doit savoir faire

Agréger ce qui est dispersé dans le dépôt et le **projeter selon l'acteur qui
demande**, en nommant des gestes plutôt que des états.

## Ce qui est attendu, point par point

| # | Le système… |
|---|---|
| a | prend l'acteur en paramètre, et n'a pas de file unique |
| b | ne lit que ce qui existe déjà : aucun type, aucun document, aucun registre n'est créé pour lui |
| c | rend un **geste**, avec ce sur quoi il porte et par qui il est fait |
| d | présente tout blocage avec **ce qui le lèverait** |
| e | trie par ce qui débloque le plus, non par date ni par identifiant |
| f | rend « rien ne vous attend » comme une réponse pleine, en une ligne |
| g | tient dans un écran |

## À quoi on constate que c'est tenu

- Deux acteurs qui demandent obtiennent deux réponses différentes, et chacune
  ne contient que ce qui le concerne.
- Le rapport d'un travail et cette projection ne se contredisent jamais : la
  seconde est la seule autorité sur « quoi ensuite ».
- Le nombre d'items projetés décroît quand le travail avance (`RQF-003`).

## Ce qui est explicitement hors de ce requis

Toute production. Ce requis n'écrit rien : c'est une lecture.

## Motivé par

`CAS-005`.

## Origine

G2 a livré cette capacité et a échoué de façon documentée : `ANL-013` établit
qu'elle affichait trois des vingt-six suites destinées à l'humain, parce
qu'une file unique servait deux acteurs. Le point (b) est le correctif de la
seconde erreur de G2 — répondre à un manque de lisibilité par un type de plus.
`PDC-005`, principe P7.
