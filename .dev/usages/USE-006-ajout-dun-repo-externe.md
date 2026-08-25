Un utilisateur peut ajouter un repo externe afin d'y utiliser des ressources, des features etc.

EXTENSION_PUBLISHER := utilisateur ayant publié l'extension
EXTENSION_NAME := nom du repo de l'extension
EXTENSION_NAMESPACE := EXTENSION_PUBLISHER/EXTENSION_NAME


```sh
clia init my_new_project
cd my_new_project

# ajoute une source 
clia extension add VALID_GIT_REPO_URI

# affiche la liste des extentions => EXTENSION_NAMESPACE STATUS (installed/not installed)
clia extension ls

# affiche les ressources de cette extension
clia res ls --remote EXTENSION_NAMESPACE

# installe une ressource
clia res activate EXTENSION_NAMESPACE RESSOURCE

# installe toutes les ressources, les skills, les scripts et les fonctionnalitées par défaut de l'extension
clia extention install EXTENSION_NAMESPACE
```

