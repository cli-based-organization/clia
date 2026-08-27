# Mise à jour des ressources

Une ressource possède son propre numéro de version

```sh
# affiche le numéro de version de RESSOURCE
clia r|res|ressource RESSOURCE version


# affiche la liste des versions disponibles
clia res RESSOURCE version ls



# mettre à jour la version (passer à la dernière version)
clia res RESSOURCE upgrade

# passe à la version supérieur X.Y.Z
clia res RESSOURCE upgrade X.Y.Z

# revenir à une version précédente
clia res RESSOURCE downgrade

# revenir à la version précédente X.Y.Z
clia res RESSOURCE downgrade X.Y.Z


# mettre à jour la version et migrer les données
clia res RESSOURCE upgrade --migrate

# met à jour la version de INSTANCE
clia res RESSOURCE migrate INSTANCE

# met à jour la version de toutes les instances
clia res RESSOURCE migrate --all

```

L'option "--migrate" permet d'adapter les formats de données lors d'un upgrade/downgrade

## Ce qui est livré

Les deux ordres se valent : `clia res version labo` et `clia res labo version`
désignent la même demande. Le verbe d'abord est la forme des autres commandes,
le nom d'abord est celle écrite ci-dessus ; aucune ressource ne peut porter le
nom d'un verbe, la lecture est donc sans ambiguïté.

```sh
clia res version RESSOURCE           installée, offerte, et l'écart
clia res version ls RESSOURCE        les versions disponibles
clia res upgrade RESSOURCE [X.Y.Z] [--migrate] [--force]
clia res downgrade RESSOURCE [X.Y.Z] [--migrate] [--force]
clia res migrate RESSOURCE INSTANCE | --all [--to X.Y.Z]
clia extension upgrade [NAMESPACE]   met à jour le clone d'une extension
```

**Trois versions, et il faut les tenir séparées.** L'*installée* est celle que
l'inventaire de `.dev/clia.yaml` inscrit pour cette ressource. L'*offerte* est
celle que la provenance déclare aujourd'hui dans son propre
`_ressources/NOM/schemas/NOM.yaml`. Les *disponibles* sont celles que
l'historique git de la provenance garde.

**D'où viennent les versions disponibles.** De `git log` sur le répertoire de
la ressource chez la provenance, la version étant lue dans la définition à
chaque commit. Aucun registre n'est tenu à côté — même choix que pour la
version du dépôt (`clia release ls`), et pour la même raison : un registre
parallèle finit par mentir. Le répertoire de travail de la provenance vient en
tête sous le commit `travail` quand il diffère de HEAD : c'est ce qu'elle offre
aujourd'hui, et c'est ce que `clia res activate` copie.

**Une reprise remplace, elle ne fusionne pas.** Une ressource est un ensemble
de fichiers repris, non un fichier que deux mains éditent. Une copie modifiée
sur place serait donc perdue : la commande la détecte — en comparant
l'installé à ce que la provenance avait à cette version — et refuse, sauf
`--force`. Quand la version installée n'est plus au catalogue, la comparaison
est impossible et la commande le dit avant de continuer.

**Les skills et fonctionnalités ne suivent pas d'office.** Ils ont été *posés*
dans le harnais, ailleurs que dans le répertoire de la ressource. La reprise
les met à jour dans `_ressources/`, dit combien la ressource en porte, et
laisse `clia skill install` / `clia feature install` les reposer.

**La migration des instances.** Une instance déclare sa version dans son
frontmatter — les gabarits posent ce champ. Ce que le type dit du passage vit
dans `_ressources/NOM/scripts/migrations/X.Y.Z.sh` : un script qui amène
**une** instance à la version X.Y.Z, et qui la reçoit en premier argument.
Sous `scripts/` et non dans un emplacement à eux : `SPC-001` S3 n'en admet que
onze, et un script de migration est un script qui instrumente la ressource ;
le sous-répertoire les tient hors de `scripts/*.sh`, où le dispatcher cherche
les commandes. Une version
sans script n'a pas changé le format de ses instances : clia avance alors le
seul marqueur. La migration ne redescend pas — aucun script ne dit comment
défaire un passage, et l'inventer reviendrait à décider du format à la place
de qui l'a écrit ; un downgrade laisse donc les instances telles quelles, et
le dit.

**Une ressource née dans le dépôt** n'a pas de provenance à interroger. Sa
version se change dans sa définition, et `clia res upgrade` le dit plutôt que
d'aller chercher ailleurs une ressource qui porterait le même nom.

**Une extension** est un dépôt, et un dépôt avance. `clia extension upgrade`
remet le clone à jour, réinscrit sa version à l'inventaire, et nomme ce que le
dépôt tient d'elle qui est resté en arrière. Il ne reprend rien de lui-même :
une ressource installée peut avoir été modifiée sur place, et `clia res
upgrade` est le seul endroit qui sache le vérifier.

## Codes de retour

```
0  la demande est satisfaite
1  refus : ressource absente, version inconnue, copie modifiée, provenance
   injoignable, ou script de migration en échec
2  demande mal formée
```

# Mise à jour du SI clia

La mise à jour du Système d'Information se fait de monière analogue avec les commandes `clia upgrade|downgrade|migrate`

 ```sh
# affiche le numéro de version
clia version

# affiche la liste des versions disponibles
clia version ls

# mettre à jour la version (passer à la dernière version)
clia upgrade

# passe à la version supérieur X.Y.Z
clia upgrade X.Y.Z

# revenir à une version précédente
clia downgrade

# revenir à la version précédente X.Y.Z
clia downgrade X.Y.Z

# mettre à jour la version et migrer les données
clia upgrade --migrate

# met à jour la version d'une instance 
clia migrate RESSOURCE_PREFIX-INSTANCE

# met à jour la version de toutes les instances
clia res RESSOURCE migrate --all

```

## Ce qui est livré

**Ce que ces trois verbes mettent à jour, c'est le dépôt courant** : ce qui y
est installé, repris de l'installation de clia et des dépôts d'extension. Ils
ne déplacent pas clia lui-même — l'installation appartient à `setup.sh`, et un
dépôt ne réécrit pas le code qui l'instrumente.

```sh
clia upgrade   [NAMESPACE] [X.Y.Z] [--migrate] [--force]
clia downgrade [NAMESPACE] [X.Y.Z] [--force]
clia migrate   [RESSOURCE] [--to X.Y.Z]
```

**`clia upgrade` est `clia res upgrade` appliqué à tout ce que le dépôt tient
d'ailleurs**, dans l'ordre où l'un dépend de l'autre :

1. les clones d'extension sont remis à jour — sans quoi la suite reprendrait
   d'un état périmé ;
2. chaque ressource installée est reprise à la version offerte ;
3. les skills et fonctionnalités des ressources reprises sont reposés ;
4. le harnais est signalé s'il est en retard, jamais réécrit.

**Aucune garde ne lui est propre.** Chaque geste est délégué à la commande qui
le porte déjà — `clia res upgrade`, `clia extension upgrade`, `clia skill
install`. Le refus d'écraser une copie modifiée, la reprise à la bonne
version, l'inscription à l'inventaire vivent donc à un seul endroit :
`clia upgrade` ordonne et rapporte, il ne réimplémente rien. Une ressource
modifiée sur place est sautée et nommée, non écrasée ; `--force` passe outre,
avec les mêmes conséquences qu'à l'unité.

**`X.Y.Z` est la version d'une provenance, non celle d'une ressource.**
`clia upgrade acme.com/outils 0.4.0` reprend les ressources d'`acme.com/outils`
telles qu'elles étaient quand ce dépôt-là se déclarait en `0.4.0` — c'est la
seule lecture qui ait un sens pour plusieurs ressources à la fois, puisqu'elles
ont chacune leur numéro. La version demandée est cherchée dans l'historique de
`.dev/clia.yaml` de la provenance, comme `clia release ls` le fait pour le
dépôt courant. Avec plusieurs provenances, le namespace est exigé plutôt que
choisi au hasard. Une ressource pour qui le déplacement irait dans l'autre sens
est sautée, et le rapport renvoie à l'autre verbe.

**`clia downgrade` ne touche pas les clones d'extension.** Reculer ne demande
rien de neuf, et tirer le dépôt d'origine pour ensuite reculer serait un geste
qui se contredit.

**Une ressource née dans le dépôt n'a pas de provenance** : elle n'est pas
touchée. Le harnais IA non plus — hors de ses deux zones gérées, son corps
appartient au dépôt, et seul `clia harness-ia init --force` le régénère. C'est
une décision, et elle reste à l'humain (PDC-002).

**`clia migrate` balaie les instances du dépôt.** Sans argument, toutes les
ressources ; avec un nom, celle-là seule. Une ressource sans instance n'est
nommée que si elle a été demandée : dans un balayage, elle se tait.

### Ce qui distingue de `clia check`

`clia check` constate le retard (C7, voir USE-008) et ne reprend rien ;
`clia upgrade` reprend. `clia check --fix` fait le pont, en déléguant à
`clia res upgrade` ressource par ressource.

### `clia version`

Il n'y a pas de commande `clia version` : la version du dépôt est déjà
gouvernée par `clia release` — `clia release ls` donne les versions publiées et
la version effective, `clia release major|minor|patch` l'incrémente. Un second
nom pour la même chose ferait deux commandes là où il n'y a qu'un concept.
`clia --version` reste celle de l'installation de clia.

## Codes de retour de la seconde moitié

```
0  la demande est satisfaite, même s'il n'y avait rien à faire
1  refus : pas de .dev/clia.yaml, namespace ou version inconnus de ce dépôt,
   ou au moins un geste en échec
2  demande mal formée
```