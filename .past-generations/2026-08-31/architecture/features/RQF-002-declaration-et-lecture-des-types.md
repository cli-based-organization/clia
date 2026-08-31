# RQF-002 — Un type est une donnée déclarative, et le système la lit

## Ce que le système doit savoir faire

Connaître les types de ressource d'un dépôt en **lisant leurs définitions**, et
non en portant leur liste dans son code.

Une définition est la seule source de ce que le type est : son nom, son préfixe,
où vivent ses instances, sous quel motif de nom, avec quel gabarit, quels
champs, quelles sections, quelles relations admissibles, qui l'écrit, et comment
il vieillit.

## Ce qui est attendu, point par point

| # | Le système… |
|---|---|
| a | reconnaît un type à la présence de sa définition, et à rien d'autre |
| b | découvre les définitions par balayage, sans catalogue central |
| c | rend lisible tout ce qu'une définition déclare, sans le réécrire ailleurs |
| d | dénombre les instances de chaque type à partir de l'emplacement déclaré |
| e | distingue un type **connu** d'un type **activé** dans ce dépôt |
| f | refuse de déclarer un attribut qu'aucune capacité ne fait tenir |

## À quoi on constate que c'est tenu

Ajouter une définition suffit à faire exister le type : il se liste, ses
instances se comptent, ses gabarits s'emploient. Aucune information du type
n'est écrite deux fois.

**Le point (f) se constate par l'inverse** : tout attribut présent dans une
définition est employé par au moins une capacité livrée. Un attribut qui ne
sert nulle part est retiré de la définition, non conservé en promesse.

## Ce qui est explicitement hors de ce requis

Le contenu d'une instance. Ce que le type déclare de la **forme** est vérifiable
(`RQF-003`) ; ce que l'instance dit relève du producteur.

## Motivé par

`CAS-003`, `CAS-006`.

## Origine

Convergence sur trois générations : catalogue central en G1, définitions en
markdown de cent cinquante lignes en G2, contrat déclaratif en G3
(`ANL-001` V3). Le point (f) est le correctif de M2 et l'application de P2.
