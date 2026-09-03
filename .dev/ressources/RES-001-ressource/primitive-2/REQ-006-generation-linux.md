---
type: requis
id: REQ-006
titre: "La génération d'une ressource, sur Linux"
ordre: 2
source: SES-001 tâche 23
editeur: agent
---

# REQ-006 — La génération d'une ressource, sur Linux

SPC-002 dit ce qu'est le stade généré. Ce document dit comment il est
construit sur un système de fichiers Linux : le format des recettes, ce qui
décide de refaire une cible, où les politiques vivent, et ce qui se vérifie.

Il est de deuxième ordre : un agent l'a rédigé en écrivant le code, et un
humain le relit. Ce qu'il décrit est ce que `_scripts/lib/generation.sh` et
`_scripts/lib/cmd/make.sh` tiennent au 2026-09-03.

## 1. Ce que clia sait, et que make(1) ne sait pas

make connaît un domaine : des sources, une compilation, des cibles. clia en
connaît un autre — des primitives obtenues par une collaboration entre
humains, automatismes et agents, et des livrables qui en sont tirés.

```
une primitive        est un peu comme un fichier source
la génération        est un peu comme la compilation
un livrable          est un peu comme une cible
```

**« Un peu comme » n'est pas « pareil ».** Deux différences suffisent à
l'établir :

* une dépendance peut être **une ressource** plutôt qu'un fichier, et une
  ressource a une version ;
* un fichier compte par **son contenu**, non par sa date — un clone remet
  toutes les dates à la même, et make s'y perd.

**Décision.** SES-001 tâche 22 avait été comprise comme une délégation à
make(1) ; la tâche 23 corrige : clia s'inspire du fonctionnement d'un
makefile, et ne l'emploie pas. Ce document décrit ce qui a remplacé la
délégation.

## 2. Le format des recettes

Un fichier YAML, dans l'instance :

```
<instance>/generation.yaml
```

```yaml
recettes:
  - cible: genere/resume.md
    depuis: primitive-1/ENO-001-source.md primitive-2/SPC-001-forme.md
    ressources: ressource@0.1.0 session
    par: livrables/_scripts/resumer.sh
```

| Champ | Ce qu'il dit |
|---|---|
| `cible` | ce que la recette produit, relatif à l'instance |
| `depuis` | les fichiers dont elle dépend, séparés par des espaces |
| `ressources` | les ressources dont elle dépend : `nom` ou `nom@version` |
| `par` | le script qui construit, relatif à l'instance |

**Les listes sont des scalaires séparés par des espaces.** Le lecteur YAML de
clia — `_clia_bloc_yaml` — rend un champ par entrée, non une liste imbriquée.
Un chemin de clia ne contient pas d'espace, et la contrainte ne coûte donc
rien ici. Elle est réelle ailleurs, et REQ-002 dit la même chose des
signatures.

**Une cible peut nommer une autre cible dans `depuis` :** c'est ce qui fait
le graphe. Une dépendance qui n'est pas une cible est un fichier, et elle est
prête par nature.

`generation.yaml` est admis par C1 dans une instance — voir REQ-004 §3.

## 3. Le graphe

`_clia_g_ordre` trie les cibles, dépendances avant dépendants : on pose ce
dont toutes les dépendances internes sont déjà posées, et on recommence.

Ce qui reste après un tour sans progrès est dans un cycle. clia le **refuse**
et le nomme, plutôt que de boucler — une cible ne peut pas dépendre
d'elle-même, même par un détour.

Quand des cibles sont nommées sur la ligne de commande, `_clia_g_ferme` en
prend la fermeture transitive : la cible demandée, et tout ce dont elle
dépend. Ce qui dépend d'elle n'est pas construit — on a demandé une cible,
non un dépôt à jour.

## 4. Ce qui décide de refaire

Quatre états, et ils ne demandent pas la même chose :

```
à jour        rien à faire
à construire  la cible n'existe pas
à refaire     ses entrées ont changé depuis son dernier passage
à refaire     une cible dont elle dépend va être refaite
sans recette  rien ne dit comment la produire
```

### 4.1 L'empreinte des entrées

À chaque construction, clia enregistre ce que la cible a vu :

```
<instance>/.empreintes.yaml

empreintes:
  - cible: genere/resume.md
    entrees: 9f2b1c…
```

L'empreinte est le `sha256sum` de la concaténation :

* pour chaque `depuis`, `<chemin> <sha256 du contenu>` — un fichier absent
  vaut `absent` ;
* pour chaque `ressources`, sa signature (§4.2).

**Pourquoi le contenu, et non la date.** `git clone` et `git checkout`
donnent à tous les fichiers la même date, et une date ne dit pas ce qu'un
contenu dit. Un dépôt fraîchement cloné ne doit pas tout reconstruire, et un
`touch` ne doit rien déclencher.

**Ce que le fichier d'empreintes est.** Un constat, non une déclaration : le
modifier ne change rien à ce qui est, il change seulement ce que clia croit.
C'est la seule chose de ce système qui soit écrite par clia et relue par lui
— et c'est nécessaire, parce que « ce que la cible a vu » n'est inscrit nulle
part ailleurs.

Il commence par un point : la vérification C1 des zones ne le voit pas, et il
n'encombre pas une liste de répertoire.

### 4.2 La signature d'une ressource

Une dépendance de ressource ne se mesure pas comme un fichier.

```
nom@version   la version est épinglée      →  « nom@version », tel quel
nom           sous fixed-version           →  « nom@<version déclarée> »
nom           sous rolling-release         →  « nom@<version>+<sha de l'arbre> »
```

Une version épinglée **fige** la dépendance : elle ne bouge que si quelqu'un
la change dans la recette. C'est le mécanisme que SES-001 tâche 23 demande —
« une primitive qui est une ressource peut avoir sa version fixée ».

Une ressource introuvable vaut `nom@absente`. Elle ne fait pas échouer : elle
change l'empreinte, ce qui est exactement ce qu'il faut — la cible a été
construite avec, elle ne l'est plus.

## 5. Les politiques

Une seule aujourd'hui :

```
ressource.version   fixed-version | rolling-release
```

**`fixed-version` est le défaut.** SPC-001 §1.9 pose qu'une ressource
installée est figée ; une régénération déclenchée par ce qui bouge ailleurs
serait le contraire de figé. Un dépôt qui développe les ressources dont il se
sert demande l'autre.

### 5.1 Quatre niveaux

Du plus proche au plus lointain, et **le premier qui déclare l'emporte** :

| Niveau | Où | Comment |
|---|---|---|
| appel | `$CLIA_MAKE_POLICY_RESSOURCE_VERSION` | l'environnement |
| ressource | `<instance>/generation.yaml` | `clia <res> make policy set` |
| dépôt | la carte du dépôt | `clia make policy set` |
| utilisateur | `$XDG_CONFIG_HOME/clia/config.yaml` | `clia setup config set` |

Régler au plus près ne doit jamais être défait par plus loin : une politique
posée sur une ressource ne peut pas être annulée par une préférence
d'utilisateur.

La variable d'environnement se déduit du nom, comme celle d'une zone :
`CLIA_MAKE_POLICY_`, puis le nom en majuscules, points et tirets changés en
soulignés — REQ-005 §1 pour la même règle.

### 5.2 Un seul bloc, quatre fichiers

Les quatre niveaux emploient la même forme, sous le même nom de bloc :

```yaml
make-politiques:
  - nom: ressource.version
    valeur: rolling-release
```

Un seul lecteur — `_clia_g_politique_dans` — sert les quatre. La clé
d'utilisateur s'écrit `make.policy.ressource.version`, comme l'énoncé la
nomme ; `clia setup config` la traduit vers le même bloc, et la rend sous la
même forme.

## 6. Appliquer une recette

```sh
cd <instance> && bash <par>
```

L'environnement que la recette reçoit :

```
CLIA_CIBLE       ce qu'elle doit produire, relatif à l'instance
CLIA_DEPUIS      ses dépendances de fichiers
CLIA_RESSOURCES  ses dépendances de ressources
CLIA_INSTANCE    le répertoire de l'instance, absolu
CLIA_GENERE      <instance>/genere
```

plus `CLIA_SOURCE_DIR` et `CLIA_WORK_DIR`, qui viennent du point d'entrée.

Le script est lancé par `bash`, comme un script de ressource — REQ-002 §4 dit
pourquoi : le bit d'exécution n'est pas nécessaire, et le shebang n'est pas
suivi.

**Une recette est jugée sur ce qu'elle pose.** Une recette qui se termine
bien sans produire sa cible est un échec, et clia le dit. Un code de retour
nul n'est pas une preuve.

L'empreinte n'est écrite qu'après vérification que la cible existe : une
cible non produite ne doit pas passer pour à jour au prochain passage.

## 7. Ce qui se vérifie

1. Toucher un fichier sans le modifier ne déclenche rien.
2. Modifier son contenu déclenche, et le graphe propage.
3. Une cible nommée construit ce dont elle dépend, et rien de plus.
4. Un cycle est refusé et nommé.
5. Une recette sans `par`, introuvable, muette ou en échec est refusée, et
   chacune pour sa propre raison.
6. Sous `fixed-version`, une ressource qui bouge sans changer de version ne
   déclenche rien ; sous `rolling-release`, si ; une version épinglée ne
   bouge dans aucun des deux cas.
7. Les quatre niveaux de politique s'ordonnent, et le plus proche l'emporte.
8. `make ls` et `make --check` n'écrivent rien.

`_scripts/tests/test_generation.sh` les mesure — 100 cas.

## 8. Ce que ce document ne tranche pas

**Ce que le stade généré contient.** Rien ne vérifie que `genere/` ne porte
que des cibles déclarées. Un fichier qu'aucune recette ne produit y survit,
et clia ne le voit pas.

**La suppression d'une cible retirée.** Retirer une recette laisse sa cible
et son empreinte en place. Il faudrait un « make clean », et l'énoncé ne le
demande pas.

**Ce que fait l'absence de recette.** SES-001 tâche 23 s'interrompt sur
« si il n'y a pas de recette ». La phrase est incomplète, et clia ne l'a pas
comblée par une supposition : une cible sans `par` est rendue « sans
recette » et n'est pas construite ; une cible nommée qu'aucune recette ne
produit est refusée. Ce qui devrait se produire d'autre appartient à
l'humain.

**Les recettes d'une instance qui n'est pas écrite ici.** Générer demande une
instance ; une ressource seulement installée n'a rien à générer dans ce
dépôt. Ce que serait la génération d'un artéfact par une ressource installée
— le cas de CLAUDE.md — est la tâche suivante de l'énoncé.
