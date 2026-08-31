# RQF-005 — Le système sait d'où vient chaque chose, et à quelle version

## Ce que le système doit savoir faire

Pour toute chose qu'un dépôt tient d'ailleurs : dire **d'où** elle vient, **en
quelle version** elle est ici, **quelle version** la provenance offre, et
**quelles versions** existent.

## Ce qui est attendu, point par point

| # | Le système… |
|---|---|
| a | déclare une provenance, et la distingue d'une copie de travail locale |
| b | inscrit, pour chaque chose reprise : quoi, d'où, en quelle version |
| c | tient séparées la version **installée**, la version **offerte** et les versions **disponibles**, et les nomme distinctement dans sa sortie |
| d | ne tient **aucun registre parallèle** : les versions se dérivent de l'historique de la provenance |
| e | reprend en **remplaçant**, jamais en fusionnant |
| f | détecte qu'une copie a été modifiée sur place, et refuse de la perdre |
| g | signale un retard sans l'imposer : un dépôt travaille avec la version qu'il a |
| h | traite une ressource née dans le dépôt comme sans provenance, et le dit |

## À quoi on constate que c'est tenu

- La déclaration du dépôt répond seule à « d'où vient ceci ».
- Aucune modification faite sur place n'est perdue sans un refus préalable, ni
  sans une option explicite pour passer outre.
- Le mot « version » n'apparaît jamais seul dans une sortie : il est toujours
  qualifié (`RQN-004`).

## Ce qui est explicitement hors de ce requis

L'unicité et le contrôle des espaces de nommage. Le besoin est réel et mesuré ;
sa conception est ouverte (`ANL-001` D7).

## Motivé par

`CAS-004`, `CAS-002`.

## Origine

`USE-007`. Le défaut à corriger est mesuré : trois formes d'espace de nommage
coexistent dans six dépôts, dont une non résolue et une provenance fausse
(`ANL-001` C11).
