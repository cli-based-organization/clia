# Instrumenter les ressources

RES_PREFIX := RES est le préfix de la ressource "ressource"
RES_NAME := ressource
RES_PLURAL_NAME := ressources
RES_NAMESPACE := namespace où la ressource est définie
RES_VERSION := 


## Afficher la liste des ressources

```sh
# afficher toutes les ressources activés => RES_PREFIX RES_NAME RES_INSTANCES_NUMER RES_NAMESPACE 
clia res|ressource ls

# afficher les ressources activés appartenant au namespace NAMESPACE => RES_PREFIX RES_NAME RES_INSTANCES_NUMER
clia res ls NAMESPACE

# affiche toutes les informations associée à une ressource, notamment les informations à propos de la maturité et de la génération 
clia res info [NAMESPACE]


# affiche les ressource activées et non activés => RES_PREFIX RES_NAME RES_INSTANCES_NUMER RES_NAMESPACE 
clia res ls --remote

```

si le namespace n'est pas spécifié et que l'on en a besoin, on utilise, par défaut, le namespace du projet courant.

**notes**

On introduit ici la notion de namespace qui est dépendante du (publisher|user)/repo_name.

On va repousser à plus tard le problème de l'unicité et du contrôle des namespaces.

Mais on ne peut pas reporter celui de sa déclaration.

On le définit dans le fichier @.dev/clia.yaml =>

```yaml
namespace: noumanity.com/clia
version: 0.1.0
maturity: unstable
generation: 3
```


## Un utilisateur veut créer une nouvelle ressource.

```sh
# affiche la liste des ressources connus =>  RES_PREFIX RES_NAME RES_NAMESPACE

# générer une nouvelle ressource
clia res|resource new [--category RES_CATEGORY] RESOURCE_PREFIX RESOURCE_NAME [RESSOURCE_DESCRIPTION]

```

Ceci crée une nouvelle ressource dans @RESSOURCES_ZONE/RESSOURCE ou @_ressources/CATEGORY/RESSOURCE


## Autres commandes de coeur sur les ressources

... à définir (au besoin) plus tard







