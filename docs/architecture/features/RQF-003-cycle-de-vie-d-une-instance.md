# RQF-003 — Le système crée, valide et clôt les instances

## Ce que le système doit savoir faire

Ce qui manque aujourd'hui, et dont tout le reste dépend : **instrumenter les
instances**, et non seulement les types.

## Ce qui est attendu, point par point

| # | Le système… |
|---|---|
| a | crée une instance d'un type : emplacement, nom, numéro de séquence et structure sont **dérivés de la définition**, jamais saisis |
| b | refuse de créer là où quelque chose existe |
| c | valide une instance contre sa définition : champs, sections, relations admissibles, existence des cibles |
| d | fait changer l'état d'une instance **par un verbe**, et par rien d'autre |
| e | dénombre, pour un type, ses instances par état |
| f | migre une instance d'une version du type à la suivante |
| g | refuse de créer une instance d'un type dont la définition promet ce qu'elle ne tient pas |

## À quoi on constate que c'est tenu

Trois constats, dans cet ordre de valeur :

1. Aucun producteur ne tape un numéro de séquence ni un chemin.
2. Une instance non conforme est nommée comme telle, avec ce qui lui manque.
3. **Le nombre d'items ouverts d'un dépôt peut décroître**, et cette décroissance
   est le fait d'une commande.

Le troisième constat est le plus important : c'est la mesure directe de ce qui a
tué la génération 2.

## Ce qui est explicitement hors de ce requis

Le système ne rédige pas. Il pose le fichier, le nom, le numéro, la structure ;
ce qu'il y a à dire appartient au producteur — humain ou agent
(`ANL-001` E7, `RQN-004`).

## Motivé par

`CAS-003`, `CAS-005`.

## Origine

`NON-001` Q2 et Q4, sans réponse depuis le 2026-08-25. `ANL-001` M1, M5 : six
types sur dix portent zéro instance, et aucun verbe ne ferme quoi que ce soit.
`ANL-011` de G2 : soixante-et-un items ouverts en cinq jours, aucun fermé.
Principes P2 et P4.
