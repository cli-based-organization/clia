---
type: principe-de-conception
id: PDC-001
title: "Auto-découvrabilité"
version: 0.1.0
status: draft
portee: systeme
---

# PDC-001 - Auto-découvrabilité

> Toute fonction du système doit être découvrable depuis le système lui-même, sans documentation externe et sans connaissance préalable. Un système utilisable par n'importe qui est un système qui se laisse explorer.

## Objet

Ce principe est demandé par la tâche 12 de la session du 2026-08-09, à la suite d'un défaut constaté : `clia res new -h` répondait « description manquante » au lieu d'afficher son usage.

Il porte sur `clia`, sur les harnais, et sur le modèle de ressources. C'est un principe transverse au sens de `RES-012` : sa violation est un défaut, non une préférence contrariée.

## Le principe

Un utilisateur qui ne connaît rien du système doit pouvoir en découvrir les fonctions par trois gestes seulement.

| Geste | Ce qu'il doit obtenir |
|---|---|
| Invoquer sans argument | La liste de ce qui est possible |
| Demander l'aide, par `-h` ou `--help` | L'usage du niveau où l'on se trouve |
| Demander l'aide d'un niveau plus fin | L'usage de ce niveau, propre et complet |

Trois exigences en découlent.

**L'aide est reconnue avant toute validation.** Une demande d'aide n'est jamais un argument invalide. C'est la règle qui a été violée : six verbes sur sept validaient leurs arguments avant de reconnaître `-h`.

**Chaque niveau a son aide.** L'aide de la commande, l'aide de la ressource, l'aide du verbe. Une aide générale ne remplace pas l'aide d'un verbe : elle ne dit ni ce que le verbe fait, ni ce qu'il refuse.

**Une invocation nue n'est jamais destructrice.** Sans argument, le système affiche ce qu'il sait faire.

## Ce qu'il exclut

Le principe interdit quatre choses, et chacune se reconnaît sans jugement.

| Interdit | Comment le reconnaître |
|---|---|
| Une fonction dont l'existence ne s'apprend qu'en lisant le code | Elle n'apparaît dans aucune aide |
| Une aide qui décrit un état futur | Elle nomme une commande ou un fichier qui n'existe pas |
| Un message d'erreur qui ne dit pas quoi faire | Il constate sans orienter |
| Une convention qui n'est écrite que dans un exemple | Aucune aide ni aucune définition ne l'énonce |

Le troisième point est le moins évident et le plus fréquent. « description manquante » est vrai et inutile ; « description manquante, voir clia res new --help » oriente.

## Comment le vérifier

Trois contrôles, dont deux sont automatisés depuis le 2026-08-10.

**Pour `clia`, automatisé.** La suite de tests vérifie que les neuf verbes répondent à `-h` et à `--help` par leur usage propre, avec un code de retour nul, et que l'aide est reconnue avant la validation des arguments. Seize assertions y sont consacrées.

**Pour le modèle de ressources, automatisé.** `clia res ls` sans argument liste les types connus, y compris ceux employés sans définition. C'est la découvrabilité appliquée au modèle : ce que le dépôt contient s'apprend en le demandant.

**Pour les harnais, manuel.** Chaque directive doit renvoyer au document qui la détaille. Le contrôle est une relecture, et il échoue aujourd'hui : `ANL-001` établit au défaut D8 que `CLAUDE.md` documente sept commandes `clia` dont deux n'existent pas.

## Conséquence d'une violation

C'est un défaut, au sens de `RES-012`. Trois conséquences dans l'ordre.

Une fonction non découvrable est réputée inexistante : personne ne peut être tenu de la connaître.

Le défaut est corrigé avant toute nouvelle fonctionnalité. Ajouter une commande indécouvrable à un système qui en compte déjà une aggrave le défaut.

Un test de non-régression est ajouté. C'est ce qui a été fait pour le défaut du 2026-08-10 : seize assertions garantissent qu'il ne reviendra pas.

## Ce que ce principe coûte

Une aide par verbe, à écrire et à maintenir en cohérence avec le comportement. C'est un coût réel, et `FND-001` section 6 établit qu'il est admis par la pratique : l'aide fait partie de l'outil, non de sa documentation.

## Relations

- `reference` [RES-012](../ressources/RES-012-principe-de-conception.md)
- `reference` [ADR-003](../adr/ADR-003-adoption-de-l-usage-de-clia.md)
- `reference` [FND-001](../fondations/FND-001-usage-des-cli-et-leur-renouveau.md)
