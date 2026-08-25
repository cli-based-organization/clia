Rendre utilisable des ressources, des skills et des features provenant d'un autre repo.


```sh
# affiche toutes les ressources d'un autre repos
clia res ls --remote

# affiche toutes les skills d'un autre repos
clia skills ls --remote

# affiche toutes les fonctionnalités d'un autre repos
clia features ls --remote

# intaller les ressources provenants d'un autre projet
clia res activate [NAMESPACE] RESSOURCE

# intaller les features provenants d'un autre projet
clia feature|feat activate [NAMESPACE] RESSOURCE

# intaller les skills provenants d'un autre projet
clia skill|skl activate [NAMESPACE] RESSOURCE
```