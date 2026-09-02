# Conventions pour les agents

Ce dépôt est instrumenté par **clia**, un système d'information pour la
coopération entre humains, automatismes et agents IA.

Ce fichier est le harnais IA principal : il dit comment travailler ici.
`CONSTITUTION.md` dit qui a le droit de quoi, et prime sur ce fichier.

## Ce que clia tient, et ce qu'il ne tient pas

clia est un automatisme : il est déterministe, et ce qu'il garantit, vous
n'avez plus à le garantir. Il pose un fichier, un nom, une version, une
structure. **Il ne rédige rien.** Ce qu'il y a à dire vous appartient.

La frontière passe exactement là. Ne demandez pas à clia ce qui demande du
jugement, et n'écrivez pas à la main ce que clia sait poser.

## Trouver ce que l'outil sait faire

L'aide est une partie de l'outil, pas de sa documentation. Elle est
disponible à tous les niveaux, et à jour par construction — elle est composée
à partir de ce qui existe.

```sh
clia --help                 les commandes, leurs signatures, leurs options
clia <commande> --help      la même chose, pour un niveau
clia --man                  le manuel complet
clia <commande> --man       le manuel d'une commande
```

**Lisez `clia --help` avant de supposer qu'une commande n'existe pas.** Le
CLI n'a pas de liste écrite de ses commandes : il les découvre, et l'aide ne
peut donc ni en taire une, ni en annoncer une qui n'existe pas.

## Les ressources

Une ressource informationnelle dit comment produire des livrables d'une
nature précise, et contient les primitives à partir desquelles ils sont
produits. Une primitive peut venir d'un humain, d'un agent, d'un automatisme
ou d'une source externe ; ce qui compte est qu'elle soit dans le dépôt.

**Un livrable reproductible est un livrable dont toutes les entrées sont
là.** C'est le critère, et il se vérifie.

```sh
clia res ls                 ce que le dépôt porte
clia res version RESSOURCE  où en est une ressource
```

## Les ressources générées

Une ressource générée provient de ses primitives. **On ne modifie pas une
ressource générée : on modifie ses primitives, puis on la régénère.**

Ce fichier en est un exemple. Sa primitive vit dans le dépôt source de clia,
sous la ressource `harness-ia`. Hors de ce cadre, son contenu appartient à ce
dépôt : écrivez-y vos conventions.

## Les versions

La source de vérité d'une version est le commit ; l'alias lisible inscrit
dans le fichier d'état est commode et faillible. Quand il s'agit de valider,
c'est l'empreinte qui fait foi.

```sh
clia version                l'alias lisible du dépôt
clia version --true         l'empreinte exacte
```

## Le cadre de travail

* **Chacun agit dans son registre.** L'humain décide, l'automatisme exécute
  ce qui est déterministe, l'agent produit ce qui demande du jugement.
* **Ce qui est incertain se dit.** Une hypothèse annoncée vaut mieux qu'un
  fait inventé. Ne comblez jamais un énoncé incomplet par une supposition
  silencieuse — posez la question, et poursuivez ce qui n'en dépend pas.
* **Ce qui est fait se vérifie.** Ne rapportez jamais un succès non constaté.
* **Ce qui est écrit s'adresse à un lecteur.** Un message dit ce qui s'est
  produit, puis ce que le lecteur peut faire ensuite.

<!-- CLIA:FOCUS:BEGIN -->

<!-- BEGIN focus attention -->
## Le focus

Ce dépôt porte un focus : le répertoire `focus/` désigne les documents qui
comptent pour le travail en cours. Par défaut, ne prenez en compte qu'eux.

Ce qui est hors du focus n'est pas interdit — il est hors de la question
posée. Si le travail demande d'en sortir, dites-le plutôt que de le faire en
silence.

```sh
clia focus ls               ce que le focus porte
```
<!-- END focus attention -->
<!-- CLIA:FOCUS:END -->
