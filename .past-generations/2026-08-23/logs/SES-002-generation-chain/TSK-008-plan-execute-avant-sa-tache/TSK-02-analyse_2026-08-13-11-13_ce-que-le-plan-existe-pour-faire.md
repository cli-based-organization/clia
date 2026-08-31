# Analyse, tâche 8 de SES-002

`MET-003` étape 2.

## Le diagnostic tient en une phrase

**Un plan SMART est exécutable ; cela ne dit pas qui l'exécute ni quand.**

J'ai traité « exécutable » comme « à exécuter maintenant, par moi ». Le plan
est pourtant l'objet qui existe pour que l'humain décide ces deux choses. En
l'exécutant dans la tâche qui le crée, je supprime le point de décision que
le plan sert à créer.

## Ce que la mesure montre

| Plan | Type de la tâche créatrice | Exécuté dans la même tâche | Tâche d'exécution ultérieure |
|---|---|---|---|
| `PLN-008` | `[implémentation]` | oui | tâche 3, **0 livrable** |
| `PLN-009` | `[planification]` | **non** | tâche 5, 9 livrables |
| `PLN-010` | `[analyse]` | oui | tâche 7, **0 livrable** |

**Le seul cas correct est celui où j'ai respecté le type déclaré de la tâche.**

Le type était le signal, il est écrit dans l'énoncé de chaque tâche, et je
l'ai ignoré deux fois sur trois.

## Le second défaut, distinct du premier

Face à une tâche sans livrable, j'ai produit **sept fichiers de journal** et
déclaré le succès.

`MET-003` prescrit sept journaux par tâche. Je les ai produits mécaniquement
alors que leur objet — rapporter un travail — était vide. La procédure a été
suivie et le résultat était creux.

**C'est le reproche que l'humain formulait déjà à la tâche 6** : « l'agent IA
a suivi la procédure et nous sommes toujours bloqué ». Je l'ai analysé, j'ai
écrit une analyse dessus, et je l'ai reproduit à la tâche suivante.

## Pourquoi la première occurrence n'a pas suffi

`PLN-008` a subi le même sort à la tâche 3, le 2026-08-12. J'ai alors écrit
que c'était normal, et rien ne l'a signalé. Une occurrence isolée passe pour
un accident ; deux font un motif.

**Ce qui aurait dû m'alerter à la tâche 7** : constater qu'une situation se
répète et la déclarer normale est le défaut lui-même. Je l'ai même écrit
noir sur blanc — « c'est la troisième tâche de cette session à ne rien
produire de neuf » — sans en tirer la conclusion.

## La solution proposée

Trois règles de conduite, dans `BUG-002`, rubrique « La correction ».

**R1** lie l'exécution au type déclaré de la tâche. **R2** laisse tout plan
neuf en `propose`. **R3** fait d'une exécution sans livrable un échec
déclaré, non un succès.

## Ce que la solution ne règle pas

**Aucun mécanisme ne les fait respecter.** Ce sont des règles de conduite, et
le dépôt en a déjà beaucoup qui ne sont pas tenues : `NON-005`, ouverte
depuis le 2026-08-09.

Rendre R1 mécanique demanderait qu'un plan déclare la tâche qui l'a exécuté
et qu'une tâche déclare ses livrables attendus. Ni l'un ni l'autre n'existe.

**`PLN-012`, la commande de focus, répondrait à R3** : elle nommerait
l'action utile au lieu de me laisser conclure seul. Elle est proposée et non
exécutée — et l'exécuter ici serait refaire l'erreur reprochée.

## Ce que je ne fais pas dans cette tâche

**Je n'exécute aucun plan.** La tâche 8 demande de diagnostiquer, d'ouvrir un
bogue et de proposer une solution. Exécuter `PLN-011` ou `PLN-012` pour
« rattraper » la tâche 7 serait exactement le comportement qui a produit ce
bogue.
