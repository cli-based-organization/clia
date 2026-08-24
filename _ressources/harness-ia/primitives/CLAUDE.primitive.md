# Conventions pour les agents

Ce dépôt est instrumenté par [clia](https://github.com/cli-based-organization/clia) : un cadre de collaboration entre humains, automatismes (algorithmes déterministes) et intelligences artificielles (algorithmes non déterministes).

Ce fichier est le harnais IA du dépôt. Il est **généré** à partir d'une primitive du dépôt source de clia, par `clia harness-ia init`. Hors des deux zones gérées signalées plus bas, son contenu appartient à ce dépôt : écrivez-y vos conventions, elles ne seront pas réécrites sans `--force`.

## Le cadre de travail

* **Un acteur agit dans son registre.** L'humain décide, l'automatisme exécute ce qui est déterministe, l'agent produit ce qui demande du jugement. Un agent qui prend une décision à la place de l'humain sort de son registre — il pose la question à la place.
* **Ce qui est incertain se dit.** Une hypothèse annoncée vaut mieux qu'un fait inventé. Ne comblez jamais un énoncé incomplet par une supposition silencieuse.
* **Ce qui est fait se vérifie.** Une commande annoncée comme fonctionnelle a été exécutée ; un test annoncé comme passant a été lancé. Ne rapportez jamais un succès non constaté.
* **Ce qui est écrit s'adresse à un lecteur humain.** Un message dit ce qui s'est produit, puis ce que le lecteur peut faire ensuite. Un constat sans suite oblige à deviner.

## Les ressources générées

Une ressource générée provient de la combinaison de ses primitives et d'un prompt de génération. **On ne modifie pas une ressource générée : on modifie ses primitives, puis on la régénère.** Ce fichier en est un exemple — sa primitive vit dans le dépôt source de clia.

## Les commandes

```sh
clia --help              la liste des commandes disponibles
clia context             d'où vient le code employé, et sur quel dépôt il travaille
clia harness-ia status   l'état de ce fichier et de ses zones gérées
clia skill list          le catalogue des skills, et ceux installés ici
clia feature list        le catalogue des fonctionnalités, et celles actives ici
```

## Extensions installées

Les deux zones ci-dessous sont **gérées par la commande `clia`** (`clia skill …` pour les skills, `clia feature …` pour les fonctionnalités). Ne les éditez pas à la main : leur contenu est réécrit à chaque installation ou désinstallation, et `clia harness-ia init --force` les préserve telles quelles en régénérant le reste du fichier.

<!-- CLIA:SKILLS:BEGIN -->

<!-- CLIA:SKILLS:END -->

<!-- CLIA:FEATURES:BEGIN -->

<!-- CLIA:FEATURES:END -->
