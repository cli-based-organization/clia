---
type: session
id: SES-002
titre: "instrumente les ressources"
etat: ouverte
ouverture: 2026-09-03
---

# SES-002 — instrumente les ressources

## CONTEXTE

Nous avons beacoup avancé sur les principes de base de clia. Et aussi, sur la définition de ce qu'est une ressource clia et de comment l'utiliser.

## INTENTION

Il est temps maintenant de rendre les ressources utilisable.

## LIVRABLES

- la ressource RES contient toutes les commandes essentielles
- la ressource RES est utilisable
- une ressource 

## CRITÈRES DE CONVERGENCE

On est capable de créer un nouveau repo clia, d'y ajouter de nouvelles ressources, de les programmer et d'utiliser ces nouvelles ressources dans un autre repo.

## Tâches


### 1. [enhancement] le status d'un repo clia: ressources installés

Réécrire les fonctionnalités de base de clia en fonction des directives suivantes =>


**Quels sont les ressources installées?**

```sh
clia ls  # affiche la liste des ressources installées dans ce repo
# colones => PREFIX  NAME SOURCE VERSION STATE ACTIVE
```

STATE possibles: "à jour" ou "en retard" par rapport au repo source

ACTIVE possible:  "actif" ou "inactif". Les ressources inactives ne peuvent pas être désactivés

La source est le namespace identifiant le repo de l'extension d'où vient cette ressource

**Quelle version de cette ressource est installée?**

```sh
clia version RESSOURCE
```

**Quels sont les ressources qui doivent être mise à jour?**

```sh
clia update  # liste les ressources installés à mettre à jour
# colonnes => PREFIX NAME SOURCE ACTUAL_VERSION LATEST_AVAILABLE_VERSION
```

**Quels versions sont disponibles pour cette ressource-ci

```sh
clia update RESSOURCE # affiche la liste de toutes les versions vers lesquelles on peut mettre à jour
```

**Mettre à jour une ressource**

```sh
clia upgrade RESSOURCE [VERSION]
```

**Afficher toutes les version d'une ressource**

```sh
clia version RESSOURCE
```

**Revenir à une version précédente**

```sh
clia downgrade RESSOURCE VERSION
```

### 2. [bug] status des ressources installées


Une source est à jour ou en retard.

si elle n'est pas dans un de ces 2 états, une ressource est **brisée** et ne DOIT PAS être actif.

aussi, une état en avance 

```
$ clia ls
PREFIX  NAME        SOURCE                      VERSION  STATE    ACTIVE
HRN     harness-ia  clia.noumanity.com/clia     0.1.0    à jour   actif
LOG     journal     session.clia.noumanity.com  0.1.0    inconnu  actif
RES     ressource   clia.noumanity.com/clia     0.2.0    à jour   actif
SES     session     session.clia.noumanity.com  0.1.0    inconnu  actif
      ce qui est à mettre à jour : clia update
```

"inconnu" n'est pas un état acceptable

Qu'est-ce que ça veut dire jointe?

### 3. [feature] exécution de clia à distance

```sh
clia -C ROOT_PATH CMD...
```

l'option `-C ROOT_PATH` permet d'exécuter clia en utilisant ROOT_PATH comme répertoire d'exécution.


### 4. [enhancement] améliore la lisibilité des listes pour les humains et pour les automatismes

Utiliser le même gabarit pour toutes les listes.

Seul le header et le contenu des colonnes est autorisé.

N'ajouter **aucun autre commentaire** dans les listes.

Le header est envoyé dans le canal 2 (stderr) afin qu'il ne soit pas transférer via un pipe. 

La première colone du tableau est toujours un identifiant utilisable.

Les détails de **tout élément de la liste** sont consultables avec la commande `... ls LINE_IDENTIFIANT`


TODO =>

- Documenter ceci dans des fichier SPC, REQ et NFR de @primitive-2/
- implémenter



### 6. [enhancement] status d'un repo cli

```sh
clia status
```

Dit:

- est-ce que le repo est une ressource clia? (en rouge si non, en vert si oui)
- est-ce que le repo est propre? (en rouge si non, en vert si oui)
- y a-t-il des fichiers qui n'appartiennent à une ressource? (en rouge si oui, en vert si non)
- est-ce que des fichiers appartenant à une ressource installé



Pour tous les fichiers concernés afficher le nom en couleur.



### x. [feature] instances de ressources:  exemple des harnais CLAUDE.md et CONSTITUTION.md


Une ressource informationelle clia fournit des fonctionnalités qui permettent de manipuler des informations et de produire des livrables de manière reproductible et évolutive <- todo: garder cette définition (RES-001/prim-2/SPC-002)

Une instance d'une ressource est également une ressource.


```sh
# définit la zone où seront déposer les ressources harnais de ce repo
clia HRN zone set @harnais


# dans ce repo, il y a plusieurs type de harnais
clia HRN release policy set typology CLAUDE,CONSTITUTION
clia 


clia HRN release config set CLAUDE

#génère un harnais

```


### x. [implementation] Extension d'architecture système 

Implémenter une extension architecture.clia.noumanity.com qui fournit les ressources suivantes:

- DIA: diagrammes d'architecture
- SPC: spécification abstraite
- REQ: requis fonctionnel
- NFR: requis non-fonctionnel
- CAS: cas d'usage





### x. [refactor] ce que `clia init` installe
 

