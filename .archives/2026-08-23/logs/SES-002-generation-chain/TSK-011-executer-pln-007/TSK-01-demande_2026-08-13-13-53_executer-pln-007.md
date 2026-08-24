# La demande, tâche 11 de SES-002

`MET-003` étape 1. Écrit avant d'ouvrir `PLN-007`.

## L'énoncé, repris sans reformulation

> ## 11. [implémentation] exécute le PLN-007

## Ce que je comprends

Exécuter les chantiers de `PLN-007`, « Mise en œuvre des quatre champs d'état ».

Le type `[implémentation]` autorise l'exécution : `MET-005` étape 1.

## Ce que je sais déjà, et qui m'inquiète

**`PLN-007` a déjà fait l'objet de la tâche 2 de cette session**, qui n'en a exécuté qu'un chantier — le G. Le journal de cette tâche s'intitule « ce qui peut avancer sans DCN-016 ».

**`PLN-011` déclare, le 2026-08-13** : « `PLN-007` chantier F y était lié et bloqué depuis deux jours ». Un plan proposé dont un chantier attend une décision suspendue.

**`clia focus` le range pourtant en `A EXECUTER`**, parce que le critère mécanique ne regarde que la présence d'un livrable et d'un critère par chantier.

## Ce que je surveille

**Le risque est celui de `BUG-002`, dans sa seconde forme** : une exécution qui ne produit rien et se déclare réussie. `MET-005` le nomme comme le plus grave des deux défauts.

Si des chantiers sont bloqués, je dois exécuter ceux qui ne le sont pas, dire lesquels ne l'ont pas été, et **laisser le plan en `propose`** — `MET-005` étape 5 : un plan partiellement exécuté ne passe pas à `execute`.

Si aucun chantier n'est exécutable, c'est un échec et je le déclare comme tel, sans clore la tâche en la disant réussie.

## Le livrable attendu

Ce que les chantiers de `PLN-007` déclarent. Je ne le sais pas encore : je n'ai pas ouvert le plan.
