# CAS-003 — Produire une instance d'un type, et la mener à son terme

## Acteur

**Le producteur** : l'humain ou l'agent qui doit écrire une analyse, une
fondation, un plan, une offre de service — n'importe quel document dont le
dépôt déclare le type.

## Situation avant

Le type existe et déclare tout ce qu'il faut : où vivent ses instances, sous
quel motif de nom, avec quel gabarit, quels champs, quelles sections, quelles
relations admissibles.

Et le producteur ouvre un éditeur, copie un fichier voisin, et recommence à la
main ce que la déclaration dit déjà.

## Ce qu'il veut

Que le type serve. Qu'une demande suffise à obtenir un document au bon endroit,
sous le bon nom, avec le bon numéro, la bonne structure — et qu'une autre
demande lui dise si ce qu'il a écrit est conforme à ce que le type annonce.

## Le récit

Il demande une instance d'un type. L'outil calcule le numéro suivant, pose le
fichier à l'emplacement déclaré, et le remplit du gabarit.

Il écrit. Quand il a fini, il demande la vérification : les champs déclarés
sont-ils là, les sections attendues sont-elles présentes, les renvois pointent-ils
vers des types admissibles et vers des instances qui existent ?

Puis il **clôt** l'instance. L'état change parce qu'une commande l'a changé, et
non parce que quelqu'un a lu le document.

```sh
# intention d'usage, non une interface
créer <type> <sujet>       # le numéro, l'emplacement et la structure sont dérivés
valider <alias>            # ce que le type déclare est-il tenu ?
clore <alias>              # l'état change, et la trace le dit
```

## À quoi il voit que c'est fait

- Il n'a jamais tapé un numéro de séquence ni un chemin.
- Un document non conforme est nommé comme tel, avec ce qui manque.
- **Le nombre d'items ouverts peut décroître**, et il le voit décroître.

## Ce qui doit échouer, et bien

| Situation | Ce que l'acteur doit obtenir |
|---|---|
| Le type déclare une génération par IA sans qu'un prompt existe | Un refus qui dit ce qui manque au type, non un fichier vide |
| L'emplacement est déjà occupé | Un refus, jamais un écrasement |
| Le type n'est pas activé dans ce dépôt | Le nom de la commande qui l'activerait |

## Ce que ce cas n'inclut pas

Créer un **type** est un autre geste, plus rare, et il appartient à `CAS-006`.

## Origine

`NON-001` Q1, Q2 et Q4, ouvertes le 2026-08-25 et sans réponse. C'est le défaut
central établi par `ANL-001` M1 : six types sur dix portent zéro instance, et
l'analyse qui l'établit a elle-même été écrite à la main contre un type qui
décrivait exactement sa forme.
