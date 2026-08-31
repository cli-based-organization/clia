# SES-002

Extraction du savoir généré pour la conception du cli

## CONTEXTE

Nous avons fait plusieurs générations de clia afin de générer du savoir.

Une chose est claire, nous auorns besoin d'un cli, même si la forme exacte n'est pas connu

## INTENTION

Générer la documentation de conception du cli clia.


## Tâches

### 1. [analyse] le cli clia

Analyser le code de la génération actuelle de clia et des générations précédentes (@.archives) et de tout le code disponible dans $HOME/git/*

Produire une analyse sur le dévelopement, la conception et l'usage des cli jusqu'à maintenant. Et, en particulier, ce qui concerne clia.

Raconter l'histoire de l'évolution de clia. Qu'est-ce qui marche bien? Qu'est-ce qui marche moins bien? Quels sont les composants qui ont convergés et qui semblent stabilisé? Et qu'est-ce qui reste à découvrir/concevoir?

Sortir la liste des enjeux. Dire quels sont les principes de conceptions les plus prometteurs.

Produire un fichier ANL.

Également, produire la documentation d'architecture d'un cli idéal à développer lors de la prochaine génération et déposer ça dans :

- @docs/architecture/diagrammmes => diagrammes et plans d'architecture
- @docs/architecture/specs  => documentation de spécification (techno agnostique)
- @docs/architecture/features => requis fonctionnels
- @docs/architecture/requis => requis non-fonctionnels
- @docs/architecture/usage => description des Cas d'usage

Également, proposer une raison d'être et une spécification de ces 5 ressources informationnelles. Établir les relations entre ces 5 ressources: 1. diagrammes et plans architecturaux, 2. spécifications, 3. requis non-fonctionnels, 4. requis fonctionnels, 5. cas d'usage

### 2. [analyse] différence depuis la dernière génération


En ce qui concerne le cli, dire ce qui est différent:

- même chose
- ajouté
- enlevé
- modifié