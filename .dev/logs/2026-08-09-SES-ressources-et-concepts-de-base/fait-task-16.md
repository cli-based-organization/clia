# Ce qui a été fait, tâche 16

## Livrable

| Fichier | Contenu |
|---|---|
| `.dev/analyses/ANL-005-tracabilite-de-l-historique-des-ressources.md` | 9 constats, 11 expériences, 6 contraintes, 7 options, 7 recommandations, 7 sources |

## Les trois réponses

### L'historique est conservable pour les deux formes

| Forme | Par le chemin | Par le contenu |
|---|---|---|
| Fichier | `git log --follow`, rompt dans un cas | `git rev-parse <commit>:<chemin>`, sans limite |
| Répertoire | **inopérant** | `git rev-parse <commit>:<chemin>`, sans limite |
| Dépôt git | l'historique du dépôt | idem |

`--follow` ne fonctionne que pour un fichier unique, ce que la documentation de git énonce explicitement. Sur un répertoire, l'option est acceptée sans erreur et sans effet : 5 commits avec, 5 sans, sur `.dev/ressources/`. Après renommage d'un répertoire, son historique par chemin tombe à 1 commit tandis que celui de chacun de ses fichiers en garde 4.

**La voie qui fonctionne pour les trois formes est l'identité de contenu.** Tout chemin porte un identifiant : `blob` pour un fichier, `tree` pour un répertoire.

```
git rev-parse HEAD:.dev/ressources/RES-001-ressource.md   ff8192a9a9dc   blob
git rev-parse HEAD:.dev/ressources                        9bf090c9b4e1   tree
```

Trois propriétés mesurées : déterministe, un contenu restauré produit le même identifiant ; indépendante du chemin, un répertoire déplacé garde le sien ; indépendante de l'histoire.

Le diff entre deux versions s'obtient de deux identifiants seuls, sans commit ni chemin : `git diff <tree1> <tree2>`.

### Six contraintes

| Réf | Contrainte | Statut dans le dépôt |
|---|---|---|
| T1 | Un commit ne renomme pas et ne réécrit pas la même ressource | non écrite |
| T2 | Un renommage passe par `git mv` | non écrite |
| T3 | L'historique de la branche principale n'est jamais réécrit | non écrite, **violation irréversible** |
| T4 | Tout commit est signé | **non tenue**, 0 signature sur 8 commits |
| T5 | Un commit ne touche qu'une ressource, ou déclare celles qu'il touche | non écrite |
| T6 | Un changement de forme d'implémentation a son commit dédié | non écrite, **déduite et non mesurée** |

### Sept options, deux retenues

| Option | Verdict |
|---|---|
| Commits signés SSH | **retenue**, clé déjà présente |
| Tags signés par version publiée | retenue pour les versions publiées |
| OpenTimestamps | **retenue si opposabilité à un tiers**, décision humaine |
| `git notes` | utile pour annoter, inapte à prouver |
| Manifeste de version par ressource | redondant avec l'identité de contenu |
| Sigstore, `gitsign`, Rekor | écartée tant que le dépôt est privé |
| IPFS | écartée, git adresse déjà par contenu |

Aucune option ne remplace git pour la chaîne et le diff. Les options utiles ajoutent l'auteur et la date.

## Les mesures qui ont tranché

Onze expériences, sept sur un dépôt jetable, quatre sur ce dépôt.

| Mesure | Résultat |
|---|---|
| `--follow` sur `ANL-006`, déplacé par le refactor massif | 3 commits, contre 1 sans l'option |
| Renommages détectés dans le commit `c2c4d52` | **215** |
| Renommage plus réécriture à 100 pour cent, même commit | historique réduit à **1 commit sur 4** |
| Même cas, seuil abaissé à 1 pour cent | **1 commit**, la perte est définitive |
| Renommage puis réécriture, deux commits | **3 commits**, chaîne préservée |
| Écrasement de commits | 8 commits deviennent 2, historique du fichier 4 devient **1** |
| Identifiant d'un répertoire déplacé | **inchangé** |
| Commits signés dans ce dépôt | **0 sur 8** |

## Deux hypothèses réfutées par la mesure

**Abaisser le seuil de similarité récupérerait un historique rompu.** Faux. À 10 pour cent comme à 1 pour cent, un commit au lieu de quatre. Git ne stocke pas les renommages, il les recalcule ; deux contenus sans recouvrement ne se relient à aucun seuil.

**Le renommage d'un répertoire changerait son identité.** Faux. Identifiant inchangé de part et d'autre du déplacement. Le chemin ne fait pas partie de l'identité d'un arbre.

## La prémisse de l'énoncé

L'énoncé fonde son raisonnement sur « git est un blockchain ». Exact sur le mécanisme, inexact sur le nom.

| Propriété | Blockchain | Git |
|---|---|---|
| Chaînage par hachage | oui | oui |
| Adressage par contenu | oui | oui |
| Consensus distribué | oui | **non** |
| Horodatage vérifiable | oui | **non** |
| Histoire non réécrivable | oui | **non**, mesuré |

Ce que git partage suffit à la chaîne et au diff. Ce qui lui manque est ce qui transforme une chaîne cohérente en preuve. Sans signature ni ancrage, l'historique atteste la cohérence d'une suite de versions, non l'auteur ni la date de chacune.

## Sept recommandations

| Réf | Recommandation |
|---|---|
| R1 | Ne pas construire de mécanisme de versionnage par-dessus git |
| R2 | Inscrire T1 à T6 dans un harnais, ou dans un skill de commit qui n'existe pas |
| R3 | Activer la signature SSH, seule contrainte non tenue résoluble par configuration |
| R4 | Outiller la lecture : `clia res log <ID>` et `clia res diff <ID> <v1> <v2>` |
| R5 | Contrôler T1 et T3 plutôt que les écrire |
| R6 | Reporter l'ancrage externe, décision humaine |
| R7 | Ne pas revendiquer que git est une blockchain |

## Ce qui n'a pas été fait

Aucune recommandation n'est appliquée. La signature n'est pas activée, aucun harnais n'est modifié, aucune commande n'est implémentée.

Le changement de forme d'une ressource n'est pas mesuré : T6 est déduite.

La compatibilité OKF n'est pas traitée. L'énoncé la donne comme motif, non comme question. `ANL-006`, archivée, relève qu'OKF prévoit un `log.md` par concept dont le recouvrement avec l'historique git n'est pas arbitré.
