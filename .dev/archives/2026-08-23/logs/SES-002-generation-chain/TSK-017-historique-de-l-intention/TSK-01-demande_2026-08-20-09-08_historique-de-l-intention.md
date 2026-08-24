# La demande, tâche 17 de SES-002

`MET-003` étape 1. Écrit avant toute exploration du sujet.

## L'énoncé, repris sans reformulation

> ## 17. [analyse] Où historique de la ressource intention
>
> Parcourir les repos historiques ( $HOME/git/*) afin de reconstituer l'historique de développement de la notion d'intention.
>
> Dire quels repos utilisisent la notion d'intention et quels documents discutent de ce concept.

## Ce que je comprends

**L'intention** est demandée. Deux livrables distincts sont explicitement nommés :

1. Quels repos, parmi `$HOME/git/*`, utilisent la notion d'intention (au sens `INTENTION.md`, `INT-`, ou concept voisin) ;
2. Quels documents, dans ces repos, discutent du concept lui-même (le définissent, le justifient, en débattent) — pas seulement les fichiers qui l'emploient sans le questionner.

Le tout doit reconstituer un **historique de développement** : une chronologie de comment la notion a émergé, évolué, et pris sa forme actuelle dans `clia` (`ADR-003`, `RES-003`, `skl-003`, `INTENTION.md`, tâche 15 de cette session sur le symlink `.dev/intentions/INT-001.md`).

## Le livrable

Une **analyse (`ANL`)**, prochain identifiant disponible : `ANL-014`.

## Contexte

`$HOME/git/*` contient plus de 50 répertoires de premier niveau, la plupart eux-mêmes des espaces regroupant plusieurs dépôts (`noumanity-dev`, `jvtrudel`, `disruptiva-dev`, `archive`, etc.). Le volume est trop grand pour une lecture exhaustive manuelle ; je vais procéder par recherche ciblée (grep sur les termes `intention`, `INTENTION`, `INT-00`) puis lecture des documents pertinents trouvés.

## Ambiguïté que je tranche sans objection

**« Repos historiques » n'est pas défini strictement.** Je le lis comme : tout dépôt git sous `$HOME/git/`, y compris les dépôts archivés, à l'exclusion des répertoires qui ne sont pas eux-mêmes ou ne contiennent pas de dépôt git (fichiers isolés comme `jvtrudel.tar`, `.ovpn`). Lecture raisonnable, se tromper coûte un ajustement de portée — `MET-005` étape 2.

## Ce que je surveille

Ne pas produire une liste brute de résultats `grep` sans reconstituer la chronologie demandée : le livrable est un historique de développement du **concept**, pas un index de fichiers.
