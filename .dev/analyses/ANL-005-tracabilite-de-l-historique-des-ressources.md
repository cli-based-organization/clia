---
type: analyse
id: ANL-005
title: "Traçabilité de l'historique des ressources : ce que git fournit, à quelles conditions"
status: draft
date: 2026-08-10
sujet: "Historique individuel d'un fichier et d'un répertoire à partir de git, contraintes, et options d'ancrage"
generated:
  by: claude-opus-5
  at: 2026-08-10
---

# ANL-005 - Traçabilité de l'historique des ressources

> Git fournit déjà la chaîne d'identités de contenu et le diff entre versions, pour un fichier comme pour un répertoire, sans outil externe. Six contraintes d'écriture conditionnent cette traçabilité. Une seule les rend inopérantes, et elle est aujourd'hui absente du dépôt : la signature.

## Objet

Répondre à trois questions de la tâche 16 de la session du 2026-08-09.

1. L'historique d'un fichier et celui d'un répertoire sont-ils conservables à partir des informations de git, prises à la racine du dépôt qui contient la ressource ?
2. Quelles contraintes garantissent le suivi de l'historique individuel de chaque ressource ?
3. Quelles autres options donnent une chaîne de modifications et le diff entre versions ?

Terminer par des recommandations.

## Méthode

Onze expériences, notées A à R, exécutées le 2026-08-10 avec git 2.39.5. Sept portent sur un dépôt jetable construit pour l'occasion ; quatre portent sur ce dépôt.

| Expérience | Ce qu'elle établit | Support |
|---|---|---|
| A, B, C | Portée de `git log --follow` sur fichier et sur répertoire | Ce dépôt |
| D | Existence d'une identité de contenu par chemin | Ce dépôt |
| G, H | Détection de renommage, seuil en vigueur | Ce dépôt |
| I | Effet de l'abaissement du seuil de similarité | Labo |
| J | Effet de la séparation renommage / réécriture en deux commits | Labo |
| K | Effet du renommage d'un répertoire | Labo |
| L, M | Chaîne des identités de répertoire, et diff entre deux d'entre elles | Labo |
| O, R | Déterminisme de l'identité de répertoire | Labo |
| P | Effet d'un écrasement de commits | Labo |
| Q | Disponibilité des moyens de signature | Machine |

Toutes les commandes sont reproductibles. Les mesures qui suivent sont des sorties, non des estimations.

## Constats

### C1 - Un fichier est suivi à travers les renommages

`git log --follow` traverse un déplacement massif réel. Mesure sur `ANL-006`, déplacé par le commit `2373ec7`, « drastic refactor: archive almost everything » :

| Commande | Commits retournés |
|---|---|
| `git log -- <chemin>` | 1 |
| `git log --follow -- <chemin>` | **3** |

Le dernier commit de ce dépôt, `c2c4d52`, porte **215 renommages** détectés. La détection fonctionne à l'échelle du dépôt.

### C2 - Un répertoire n'est pas suivi

La documentation de git est explicite [1] :

> `--follow` : Continue listing the history of a file beyond renames (**works only for a single file**).

Sur un répertoire, l'option est acceptée sans erreur et sans effet.

| Cas | Avec `--follow` | Sans |
|---|---|---|
| `.dev/ressources/`, ce dépôt | 5 commits | 5 commits |
| Répertoire renommé, labo K | **1 commit** | 1 commit |
| Un fichier dans ce répertoire renommé | **4 commits** | 1 commit |

Après renommage d'un répertoire, son historique par chemin est vide au-delà du renommage. Celui de chacun de ses fichiers reste entier.

### C3 - Renommer et réécrire dans le même commit coupe l'histoire

Expérience du labo : quatre commits, un fichier créé, modifié, renommé, puis renommé et réécrit à 100 pour cent dans le même commit.

| Requête sur le fichier final | Commits retournés |
|---|---|
| `git log --follow` | **1** |
| `git log --follow --find-renames=10%` | 1 |
| `git log --follow --find-renames=1%` | **1** |

La perte est définitive. Abaisser le seuil de similarité ne récupère rien : git ne stocke pas les renommages, il les recalcule par comparaison de contenu, et deux contenus sans recouvrement ne se relient à aucun seuil.

Le seuil en vigueur dans ce dépôt est le défaut, 50 pour cent.

### C4 - Séparer les deux gestes préserve la chaîne

Même labo, un renommage seul suivi d'une réécriture seule, en deux commits.

| Requête | Commits retournés |
|---|---|
| `git log --follow` après renommage puis réécriture | **3** |

La chaîne remonte jusqu'au commit où elle avait été coupée par C3.

### C5 - Un répertoire a une identité de contenu native

Toute version d'un chemin, fichier ou répertoire, porte un identifiant de contenu [2].

```
git rev-parse HEAD:.dev/ressources/RES-001-ressource.md   ff8192a9a9dc...   blob
git rev-parse HEAD:.dev/ressources                        9bf090c9b4e1...   tree
```

Trois propriétés mesurées.

| Propriété | Mesure |
|---|---|
| **Déterministe** | Un contenu restauré à l'identique produit le même identifiant. Labo O : `a78e3babad2c` pour la version 1 et pour la version 3, qui rétablit son contenu |
| **Indépendante du chemin** | Un répertoire déplacé garde son identifiant. Labo R : `a78e3babad2c` avant et après déplacement dans un sous-répertoire |
| **Indépendante de l'histoire** | L'identifiant ne dépend d'aucun commit, seulement de l'arbre de contenus |

La suite des identifiants d'un chemin, prise commit par commit, **est** l'historique de la ressource. Labo L le produit pour un répertoire à travers sept commits, dont un renommage : l'identifiant est inchangé de part et d'autre du renommage, ce qui rend le déplacement lisible comme tel.

### C6 - Le diff entre deux versions ne passe pas par les commits

`git diff` accepte deux identifiants d'arbre.

```
git diff --stat 3f5d6c520e00 d494190cb4c1
 d.md | 80 ++++++++++++++++++-------
 1 file changed, 40 insertions(+), 40 deletions(-)
```

Le diff entre deux versions d'une ressource est donc obtenable à partir de deux identifiants de contenu seuls, sans connaître la branche, le commit ni le chemin.

### C7 - L'écrasement de commits détruit l'historique

Labo P, écrasement de la totalité d'une branche en un commit.

| Mesure | Avant | Après |
|---|---|---|
| Commits du dépôt | 8 | 2 |
| Commits retournés pour un fichier, avec `--follow` | 4 | **1** |

Les états intermédiaires ne sont plus atteignables par aucune requête. Les objets subsistent jusqu'à la prochaine collecte, sans référence qui les nomme.

### C8 - Aucun commit de ce dépôt n'est signé

| Mesure | Valeur |
|---|---|
| Commits vérifiés, sortie `%G?` | **N sur 8 sur 8**, aucune signature |
| `commit.gpgsign` | non configuré |
| Clé GPG de l'utilisateur | présente, **expirée le 2026-06-18** |
| Clé SSH | `id_ed25519.pub` et `id_rsa.pub` présentes |

La signature SSH est disponible immédiatement [3]. La voie GPG demande un renouvellement de clé.

### C9 - Git n'est pas une blockchain, et la différence porte sur trois points

La prémisse de la tâche est exacte sur le mécanisme et inexacte sur le nom. Git est un graphe orienté acyclique de Merkle [4] : chaque objet est nommé par le hachage de son contenu, chaque commit inclut le hachage de son arbre et de ses parents. Toute modification d'un contenu ancien change tous les identifiants qui en dépendent.

| Propriété | Blockchain | Git |
|---|---|---|
| Chaînage par hachage | oui | **oui** |
| Adressage par contenu | oui | **oui** |
| Consensus distribué | oui | **non** |
| Horodatage vérifiable | oui | **non**, la date d'un commit est déclarative et modifiable |
| Histoire non réécrivable | oui | **non**, C7 le mesure |

Les trois « non » ont la même conséquence : sans signature ni ancrage externe, l'historique de git atteste la **cohérence** d'une suite de versions, non la **date** ni l'**auteur** de chacune.

## Réponse à la question posée

### Q1 - L'historique d'un fichier et d'un répertoire est-il conservable depuis git ?

**Pour un fichier : oui, par deux voies.**

| Voie | Commande | Limite |
|---|---|---|
| Par le chemin | `git log --follow -- <chemin>` | Rompt si renommage et réécriture massive coïncident, C3 |
| Par le contenu | `git rev-parse <commit>:<chemin>` sur chaque commit | Aucune |

**Pour un répertoire : oui, mais pas par `--follow`.** C2 l'établit. La voie qui fonctionne est celle du contenu : la suite des identifiants d'arbre, C5, complétée par le diff entre deux d'entre eux, C6.

**Une ressource qui est un dépôt git** est le cas déjà résolu par la tâche : la racine du dépôt est elle-même un arbre, et son historique est celui du dépôt.

Les trois formes d'implémentation de `ADR-004` sont donc couvertes par un même mécanisme, l'identité de contenu, et par un seul type de requête.

### Q2 - Quelles contraintes respecter ?

Six contraintes. Les trois premières conditionnent la traçabilité ; les trois suivantes conditionnent sa valeur de preuve.

| Réf | Contrainte | Constat qui la fonde |
|---|---|---|
| **T1** | Un commit ne renomme pas et ne réécrit pas la même ressource | C3, C4 |
| **T2** | Un renommage passe par `git mv`, jamais par suppression puis création | C1, C3 |
| **T3** | L'historique de la branche principale n'est jamais réécrit : ni `rebase`, ni `amend`, ni `squash`, ni `push --force` | C7 |
| **T4** | Tout commit est signé | C8 |
| **T5** | Un commit ne touche qu'une ressource, ou déclare celles qu'il touche | C2, granularité |
| **T6** | Une ressource ne change pas de forme d'implémentation sans commit dédié | C3, un fichier devenu répertoire n'a aucune similarité détectable |

T1 et T5 sont des règles de découpage. T2 est une règle de geste. T3 est une règle de branche. T4 est une configuration. T6 est propre à `ADR-004`, qui autorise une ressource à être un fichier, un répertoire ou un dépôt.

**T3 est la seule contrainte dont la violation est irréversible.** C7 mesure la perte : quatre versions d'un fichier deviennent une.

**T4 est la seule contrainte aujourd'hui non tenue.** C8 mesure : zéro commit signé sur huit.

### Q3 - Autres options pour une chaîne de modifications et le diff entre versions

Sept options, classées par ce qu'elles ajoutent à git.

| Option | Ce qu'elle ajoute | Coût | Verdict |
|---|---|---|---|
| **Commits signés SSH** [3] | L'auteur de chaque version | Une ligne de configuration, clé déjà présente | **À retenir** |
| **Tags signés par version publiée** | Un point de référence stable et attesté | Un tag par version | À retenir pour les versions publiées |
| **`git notes`** [5] | Des métadonnées attachées après coup, sans modifier le commit | Espace de noms séparé, non poussé par défaut | Utile pour annoter, inapte à prouver |
| **Manifeste de version par ressource** | Un fichier listant les identifiants de contenu de chaque version | Un fichier de plus par ressource, à tenir | Redondant avec C5, et sujet à la dérive que `ANL-001` mesure |
| **OpenTimestamps** [6] | Une preuve d'antériorité ancrée dans Bitcoin, vérifiable hors ligne | Un fichier `.ots` par ancrage, gratuit | **À retenir si opposabilité à un tiers** |
| **Sigstore, `gitsign` et Rekor** [7] | Une signature sans clé longue durée, journal de transparence public | Dépendance à un service en ligne, journal public | À écarter tant que le dépôt est privé |
| **Adressage externe, IPFS** | Un identifiant de contenu partageable hors du dépôt | Duplication complète du stockage | À écarter, git fournit déjà l'adressage par contenu |

**Aucune option ne remplace git pour la chaîne et le diff.** C5 et C6 établissent que les deux existent nativement. Les options utiles ajoutent l'auteur, T4, et la date, l'ancrage externe.

### Recommandations

**R1. Ne pas construire de mécanisme de versionnage par-dessus git.** L'identité de version d'une ressource est `git rev-parse <commit>:<chemin>`. C5 et C6 établissent qu'elle est déterministe, indépendante du chemin, et suffisante pour produire un diff.

**R2. Inscrire T1 à T6 dans un harnais.** Les six contraintes sont des règles d'écriture de commit, non des règles de rédaction. Leur place est dans le harnais opératoire, `RES-014`, ou dans un skill de commit qui n'existe pas.

**R3. Activer la signature SSH.** Contrainte T4, seule contrainte non tenue, résolue par configuration. La clé existe. La voie GPG est fermée jusqu'au renouvellement de la clé expirée.

**R4. Outiller la lecture avant d'outiller l'écriture.** Deux commandes rendent la traçabilité utilisable, et les deux sont des enveloppes de commandes existantes.

| Commande | Ce qu'elle fait |
|---|---|
| `clia res log <ID>` | La suite des identifiants de contenu de la ressource, par commit, avec l'auteur et l'état de signature |
| `clia res diff <ID> <v1> <v2>` | `git diff` entre deux identifiants d'arbre ou de blob |

**R5. Contrôler T1 et T3 plutôt que les écrire.** `ANL-004` et `NON-005` mesurent le sort des règles non outillées dans ce dépôt. Deux contrôles sont exécutables.

| Contrôle | Détection |
|---|---|
| Un commit portant un renommage et une modification de plus de 50 pour cent sur la même ressource | `git log --diff-filter=R --stat` |
| Une réécriture d'histoire | Comparaison de l'identifiant du commit racine et du nombre de commits avec la référence distante |

**R6. Reporter l'ancrage externe.** OpenTimestamps ne devient utile que lorsqu'une date doit être opposable à un tiers. Aucune ressource du dépôt n'est aujourd'hui dans ce cas. La décision appartient à l'humain.

**R7. Ne pas revendiquer que git est une blockchain.** C9 établit ce qui est vrai et ce qui ne l'est pas. Ce que le dépôt peut affirmer : les versions d'une ressource forment une chaîne de hachages vérifiable, et l'auteur de chaque version est attesté dès que T4 est tenue.

## Limites

**Aucune expérience sur une ressource qui change de forme.** T6 est déduite de C3, non mesurée. Le cas d'un fichier devenu répertoire n'a pas été construit.

**Aucune mesure de coût.** Le temps de calcul de `git rev-parse` sur chaque commit, pour une ressource et pour l'ensemble du dépôt, n'est pas mesuré. Le dépôt compte huit commits, ce qui rend toute mesure non représentative.

**Le comportement de `--follow` dépend de la version de git.** Les mesures valent pour 2.39.5. La détection de renommage a évolué et l'option `--find-renames` a des valeurs par défaut susceptibles de changer.

**Les options d'ancrage externe ne sont pas éprouvées.** Aucun des outils du tableau Q3 n'est installé sur la machine. Les verdicts reposent sur leur documentation, non sur un essai.

**La compatibilité OKF n'est pas traitée.** La tâche la donne comme motif de l'implémentation sur système de fichiers. `ANL-006`, archivée, relève qu'OKF prévoit un `log.md` par concept, dont le recouvrement avec l'historique git n'est pas arbitré.

## Sources

1. **git-log(1)**, documentation de l'option `--follow`. Vérifiée par `man git-log`, git 2.39.5, le 2026-08-10.
2. **gitglossary(7)** et **git-rev-parse(1)**, objets `blob`, `tree`, `commit`, et syntaxe `<rev>:<chemin>`. Vérifiées localement le 2026-08-10.
3. **git-config(1)**, `gpg.format=ssh` et `user.signingkey`, signature par clé SSH, disponible depuis git 2.34. Vérifiée localement le 2026-08-10.
4. **Git SCM Book**, chapitre 10, « Git Internals », modèle d'objets et graphe de Merkle. <https://git-scm.com/book/en/v2/Git-Internals-Git-Objects>. Non vérifiée en ligne lors de cette analyse.
5. **git-notes(1)**. Vérifiée localement le 2026-08-10.
6. **OpenTimestamps**, protocole d'horodatage ancré dans Bitcoin. <https://opentimestamps.org/>. Non vérifiée en ligne lors de cette analyse.
7. **Sigstore**, `gitsign` et journal de transparence Rekor. <https://www.sigstore.dev/>. Non vérifiée en ligne lors de cette analyse.

Les sources 4, 6 et 7 n'ont pas été interrogées. Les six premières affirmations qui en dépendent portent sur des mécanismes, non sur des chiffres.

## Relations

- `reference` [ANL-004](ANL-004-verbosite-justificative-des-definitions-de-type.md)
- `reference` [RES-001](../ressources/RES-001-ressource.md)
- `reference` [RES-014](../ressources/RES-014-harnais-operatoire.md)
- `reference` [NON-005](../objections/NON-005-validation-et-regles-non-tenues.md)
