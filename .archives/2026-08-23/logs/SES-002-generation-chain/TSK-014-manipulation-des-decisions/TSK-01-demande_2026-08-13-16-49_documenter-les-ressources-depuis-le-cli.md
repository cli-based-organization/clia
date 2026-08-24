# La demande, tâche 14 de SES-002

`MET-003` étape 1. Écrit avant toute exploration.

## L'énoncé, repris sans reformulation

> ## 14. [conception etc.] manipulation des décisions
>
> Actuellement, c'est difficile de comprendre comment fonctionne les métadata de décision DCN et son cycle de vie également.
>
> Ajouter un ADR qui impose de fournir la documentation des ressources à partir du cli pour satisfaire à PCD-001: `clia res explain|help RES-<SEQ>`
>
> Faire un plan d'exécution. et si ce plan est SMART, implémenter la commande.

## Ce que je comprends

**Le constat est particulier, la demande est générale.** L'humain bute sur les métadonnées de la décision `DCN` ; ce qu'il demande vaut pour **tous** les types.

**Le besoin réel** : pouvoir demander au CLI « qu'est-ce que ce type, quels champs porte-t-il, que valent-ils, quel est son cycle de vie ? » — sans ouvrir un fichier de définition et le lire en entier.

`PDC-001` est nommé : l'auto-découvrabilité. Le système doit se faire connaître par lui-même.

## Les livrables

| Livrable | Ce qu'il porte | Prescrit par |
|---|---|---|
| Un `ADR` | La décision : la documentation d'un type est fournie par le CLI | « Ajouter un ADR qui impose… » |
| Un `PLN` | L'exécution, en chantiers SMART | « Faire un plan d'exécution » |
| La commande | `clia res explain\|help RES-<SEQ>` | « si ce plan est SMART, implémenter » |

## Un écart à `MET-005` étape 1, autorisé explicitement

**Le type `[conception]` ne permet pas d'exécuter un plan**, et `BUG-002` est né de cette transgression.

**Ici l'humain l'autorise en toutes lettres** : « si ce plan est SMART, implémenter la commande ». Le mot *si* pose la condition, et c'est lui qui rend l'autorisation acceptable — le plan doit d'abord satisfaire `PDC-003`.

**Je le déclare plutôt que de l'appliquer en silence.** Si le plan n'est pas SMART, je ne l'implémente pas.

## Ce que je surveille

**Ne pas confondre `explain` et `show`.** `clia res show` affiche déjà une instance. Ce qui est demandé porte sur le **type** : ses champs, leurs valeurs admises, son cycle de vie. Si les deux se recouvrent, la commande neuve n'apporte rien.

**Le constat de départ est un test.** Après implémentation, `clia res explain RES-009` doit répondre à la question que l'humain n'arrive pas à résoudre aujourd'hui : comment fonctionnent les métadonnées de `DCN` et son cycle de vie. C'est le critère le plus honnête que je puisse écrire.

**`MET-005` étape 6** : la tâche se terminera sur une directive unique, cohérente avec `clia focus`.

## Ce que je ne fais pas

**La tâche « x »**, sur l'initialisation d'un dépôt, n'est pas demandée.
