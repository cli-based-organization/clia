---
type: decision
id: DCN-010
title: "clia opere le suivi de l historique des ressources"
version: 0.1.0
status: draft
instance: "human:jvtrudel"
date-de-decision: 2026-08-10
portee: systeme
effet: en-vigueur
attestation: interne
diffusion: public
---

# DCN-010 - clia opère le suivi de l'historique des ressources

> Décision de l'humain, tâche 19 : `clia` effectue désormais des opérations git. Trois commandes sont ajoutées, `git check`, `git save` et `git log`. Le cas où une ressource est un dépôt git n'est pas couvert.

## Objet

Enregistrer la décision qui lève une contrainte affichée du CLI et fonde l'implémentation du suivi d'historique.

## La décision

Reprise de la tâche 19 de `workspace/session.md` :

> Mettre en place la mécanique de suivi de l'historique des ressources.
>
> Se baser sur ANL-005. Ne pas couvrir le cas où une ressource est un repo.
>
> D'abord, fournir un script de vérification de l'état du repo :
>
> ```sh
> clia git check STATE  # vérifie que l'état du repo est conforme. STATE = clean | done
> clia git save  # commit les modifications en utilisant le fichier log: commit-message-task-<SEQ>.md
> clia git log RESSOURCE  # affiche l'historique de la ressource
> ```

## Motivation du changement

Cette décision ne remplace aucune `DCN`. Elle lève une contrainte que l'aide du CLI affichait depuis la tâche 6 :

> `clia` ne rédige aucun contenu, n'interprète aucune demande et n'effectue aucune opération git. Ces trois choses appartiennent à l'humain et à l'agent IA.

Ce que cette formulation tenait pour acquis et qui ne l'est plus : que toute opération git relève du jugement. Commiter un message déjà rédigé, vérifier un état, lire un historique sont des opérations déterministes.

**Les deux autres interdits subsistent.** `clia` ne rédige aucun contenu : `git save` lit le message que l'agent a préparé dans le journal, il ne l'écrit pas. `clia` n'interprète aucune demande.

## Qui a décidé

`human:jvtrudel`, propriétaire du dépôt.

Attestation `interne`. La trace est la tâche 19 de `workspace/session.md`, qui énonce les trois commandes et leur signature.

## Portée

`systeme`.

**Exclusion explicite de la demande** : le cas où une ressource est un dépôt git n'est pas couvert.

## Conséquences

| Conséquence | Où |
|---|---|
| Un module `lib/clia/git.sh` est ajouté | 4 verbes, 5 aides détaillées |
| L'aide du CLI ne déclare plus l'interdit git | `bin/clia` |
| Les contraintes T1, T3 et T4 de `ANL-005` deviennent des contrôles exécutables | `clia git check done` |
| L'historique d'une ressource est lisible par son identifiant de contenu | `clia git log` |
| Un quatrième verbe est ajouté au-delà de la demande | `clia git diff`, voir ci-dessous |

**Ce que l'implémentation ajoute à la demande.** Un verbe `diff`, qui compare deux versions par leur identifiant de contenu. `ANL-005` C6 établit que ce diff s'obtient de deux identifiants seuls, et `git log` affiche ces identifiants sans quoi ils ne serviraient à rien. L'ajout est signalé comme tel.

**Ce que l'implémentation a corrigé en s'écrivant.** La première version du contrôle T1 cherchait un statut de renommage et ne trouvait rien. Git ne signale pas ce cas comme un renommage : quand la réécriture dépasse le seuil de similarité, il affiche une suppression et une création. La détection porte donc sur l'alias : une ressource supprimée et une ressource créée qui portent le même `<PREFIX>-<SEQ>` sont la même ressource, renommée et réécrite.

## Ce que la décision ne dit pas

Elle ne dit pas si `clia` doit un jour pousser vers une référence distante. `git save` commite et ne pousse pas.

Elle ne dit pas quoi faire quand plusieurs messages de commit sont préparés. L'implémentation prend le plus récent.

Elle n'active pas la signature des commits. `git check done` la vérifie et échoue tant qu'elle est absente, ce qui est le cas au 2026-08-10.

Elle ne couvre pas le cas d'une ressource qui est un dépôt git, exclu par la demande.

## Relations

- `derive-de` [ANL-005](../analyses/ANL-005-tracabilite-de-l-historique-des-ressources.md)
- `reference` [ADR-008](../adr/ADR-008-regime-d-identification-a-deux-niveaux.md)
- `reference` [RES-026](../ressources/RES-026-code.md)
