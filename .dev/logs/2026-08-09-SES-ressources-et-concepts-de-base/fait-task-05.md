# Ce qui a été fait, tâche 5

## Livrables produits

| Fichier | Lignes | Contenu |
|---|---|---|
| `.dev/fondations/FND-001-usage-des-cli-et-leur-renouveau.md` | 233 | Recherche sourcée, 14 sources, 5 causes datées du renouveau, modèle orienté ressources, transposition à `clia` séparée de la recherche |
| `.dev/analyses/ANL-002-localisation-du-cli-clia.md` | 188 | 8 faits du corpus, 4 options, 7 critères, réponse et critère de renversement |
| `.dev/adr/ADR-003-adoption-de-l-usage-de-clia.md` | 209 | 9 décisions, alternatives écartées, portes de sortie |
| `.dev/objections/NON-011-types-employes-sans-definition.md` | 126 | 7 questions, effet `conditionnel` |

## FND-001, ce que la recherche établit

Cinq causes datées du renouveau des CLI.

| Cause | Date | Fait vérifié |
|---|---|---|
| Le cloud transforme l'infrastructure en API | 2013-09-02 | Mise à disposition générale de l'AWS CLI version 1 |
| Le déclaratif et le modèle orienté ressources | années 2010 | `kubectl apply` idempotent, calcul du diff ; AIP-121 sur la conception orientée ressources |
| Le CLI comme surface produit | 2020-09-17 | GitHub CLI 1.0 ; 250 000 pull requests et 350 000 fusions depuis le terminal pendant la bêta |
| La conception se formalise | 2010-2020 | Les 12 facteurs des applications CLI ; les Command Line Interface Guidelines |
| L'agent IA préfère le CLI à l'API | 2024-2026 | Interface stable et authentifiée, composabilité, divulgation progressive, gain rapporté de 150 000 à 2 000 jetons |

Trois apports n'étaient pas anticipés et ont modifié l'ADR.

La grammaire d'un CLI orienté ressources est un produit cartésien de ressources et de verbes : un nouveau type hérite des verbes existants sans que l'outil change. C'est l'invariant d'extensibilité de `RES-001`, formalisé indépendamment par la littérature de conception d'API.

La frontière entre l'outil et l'agent passe plus haut ici que dans les CLI d'infrastructure : créer une ressource y est mécanique, ici c'est un travail de rédaction. Devenu `ADR-003` D3 et D5.

Le déterminisme est un partage de responsabilité, et c'est la pratique qui s'impose et non une intuition locale. `ADR-002` D1 en est renforcé.

La recherche déclare aussi ce qu'elle n'établit pas : aucune source ne traite d'un CLI dont les ressources sont des documents rédigés, ni de la localisation d'un outil par rapport au système qu'il outille.

## ANL-002, la réponse à la question posée

**`clia` reste dans ce dépôt, avec une frontière interne stricte, et l'extraction est préparée plutôt que faite.**

Quatre options évaluées sur sept critères. Le monolithe indifférencié est écarté parce qu'il interdit tout cycle de release. Trois dépôts sont écartés parce que c'est la configuration la plus exposée à la mortalité dans un corpus où 94 dépôts sur 166 sont sans remote. Deux dépôts est la bonne cible et le mauvais moment.

Trois raisons, par ordre de poids.

La méthode et l'outil changent ensemble : quatre tâches d'une journée ont produit trois mises en cohérence entre documents de méthode, et les contrôles de `skl-001` sont déjà le cahier des charges d'une commande du CLI.

L'urgence est ailleurs : le dépôt n'est ni installable ni vérifiable depuis le 2026-08-08, et ce défaut est identique dans les quatre options.

Le précédent `tda` situe le bon moment : il a été extrait quand la méthode était consolidée, pas pendant sa conception.

Le précédent est retourné plutôt qu'écarté : les huit dépôts équipés par `tda` renvoient encore à une méthode délaissée deux semaines après leur création. La séparation a rendu la diffusion possible et n'a protégé de rien. Elle dit quand séparer, pas s'il faut séparer.

**Critère de renversement, en trois conditions constatables.** Un deuxième dépôt consomme `clia` pour du travail réel ; ou le CLI a besoin d'une version publiée indépendante ; ou, sur les vingt derniers commits, moins de deux touchent à la fois la zone méthode et la zone outil. La troisième mesure exactement la raison invoquée pour ne pas séparer maintenant.

## ADR-003, les neuf décisions

| Décision | Objet | Alternative écartée |
|---|---|---|
| D1 | `clia` est un agent, pas un accessoire | Le CLI comme utilitaire sans statut |
| D2 | Générique, sans contenu de domaine | Aucune |
| D3 | Modèle orienté ressources, extensible par type | Une liste de commandes sans axe de ressources |
| D4 | Reste dans ce dépôt, extraction préparée | Deux dépôts immédiatement |
| D5 | `clia` garantit, l'agent interprète | Aucune |
| D6 | Extensible par ajout de types et de commandes | Aucune |
| D7 | Une source machine-lisible des types est nécessaire | Aucune |
| D8 | Doit être installable et vérifiable | Fonctionnalités d'abord, installation ensuite |
| D9 | La sortie sert trois publics | Aucune |

D5 énonce une règle unique dont le périmètre se déduit : `clia` fait ce qui doit être garanti, l'agent fait ce qui doit être interprété. Toute opération dont le résultat dépend d'un jugement sort du périmètre par construction.

D7 signale une tension non résolue : une source machine-lisible parallèle aux définitions recréerait le défaut de duplication, donc elle doit être dérivée des définitions, et cette dérivation est un travail de `clia`. L'outil qui doit produire la dérivation est celui dont l'existence en dépend.

## Portée volontairement bornée

`ADR-003` ne décide ni de la grammaire exacte des commandes, ni du langage, ni du mécanisme d'extension, ni du format des sorties. La session annonce une session dédiée à l'outillage.

La borne est motivée par un fait : `ANL-001` établit au défaut D8 que le harnais actuel décrit sept commandes `clia` dans un dépôt sans exécutable. Décrire une interface avant de l'avoir est l'erreur mesurée de ce dépôt.

## NON-011, ce que la tâche a révélé

Ce dépôt emploie neuf types de ressources et n'en a défini que deux.

| Type | Instances | Définition |
|---|---|---|
| `ressource`, `objection` | 8 et 11 | `RES-001`, `RES-004` |
| `adr`, `analyse`, `fondation`, `plan`, `skill`, `log`, `session` | 3, 2, 1, 1, 1, 28, 1 | **aucune** |

Conséquence : le contrôle V3, seul contrôle de fond du système, est inapplicable à la majorité des livrables. Les sept types sans définition sont produits par imitation du corpus.

Deux non-conformités déclarées de surcroît : `FND-001` et `ANL-002` sont nommés par séquence alors que `RES-001` prescrit un nommage daté pour les types au cycle `point-fixe`. Choix fait sciemment, pour ne pas faire cohabiter deux conventions dans le même répertoire, `ANL-001` ayant été nommé par séquence sur demande de la tâche 1.

`NON-011` propose la voie la moins coûteuse : rapatrier six définitions depuis `micrologic-clients`, ce que `ANL-001` recommandait déjà au titre du risque de perte.

## Ce qui n'a pas été fait

Aucune spécification de commande, aucun code, aucun `setup.sh` restauré. `ADR-003` D8 pose que c'est la première tâche d'outillage, sans la faire.

Aucun dépôt créé, aucun fichier déplacé.

Aucun renommage de `FND-001` ni de `ANL-002` pour se conformer à `RES-001`. Trois fichiers sont concernés, dont un nommé sur demande de l'humain. La question est portée par `NON-011` Q2.
