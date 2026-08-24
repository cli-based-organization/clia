@ := racine du repo

@.dev := zone de développement. par défaut, tout ce qui est "méta" ou pas mature se retrouve ici

_<ZONE_NAME> := contient des outils d'instrumentation

_scripts := scripts bash et autres utilitaires

_scripts/bin := exécutables
_scripts/lib := scripts utilitaires


_templates/<RESSOURCE|CATEGORY> := fichiers templates utilisés par `clia`

_ressources/<RESOURCE|CATEGORY/RESSOURCE>/templates/ := fichiers templates d'une ressource
_ressources/<RESOURCE|CATEGORY/RESSOURCE>/schemas/ := fichiers de définition ou de validation d'une ressource
_ressources/<RESOURCE|CATEGORY/RESSOURCE>/scripts/ := scripts utilitaires associées à une ressource
_ressources/<RESOURCE|CATEGORY/RESSOURCE>/primitives/ := fichiers primitives associés à une ressource
