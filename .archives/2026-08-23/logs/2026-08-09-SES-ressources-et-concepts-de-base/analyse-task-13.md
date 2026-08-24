# Analyse préalable, tâche 13

## Le fragment avant l'action

La demande est classée `[bogue]` et son énoncé est direct. J'aurais pu l'appliquer immédiatement : renommer, convertir, régénérer.

Le fichier ouvert dans l'éditeur au moment de la demande était `FRG-001`, un fragment que l'humain venait de capter sur la conception des ressources et de leur identité. Le lire d'abord a changé l'interprétation de la tâche.

Ce que j'y ai trouvé : « Ce qui persiste par-delà des modifications est l'identité. »

C'est le critère qui manquait à mon raisonnement. J'avais écarté le numéro de séquence en supposant qu'il se renumérote. Cette supposition n'était pas un fait mais une permission que j'avais accordée sans la nommer. Il suffit de la retirer pour que le numéro devienne ce qui persiste, et le slug ce qui varie, puisqu'il dérive d'un titre.

Sans le fragment, j'aurais appliqué la demande en la trouvant discutable. Avec lui, elle est fondée, et l'ADR peut expliquer pourquoi mon raisonnement antérieur était faux plutôt que simplement écarté.

## Ce que je devais ajouter à la demande

La demande dit que l'identité est la séquence. Elle ne dit pas que la séquence est immuable.

Or les deux sont indissociables : un numéro renumérotable ne peut pas être une identité, et c'est exactement l'objection que j'avais formulée. `ADR-007` D2 interdit donc la renumérotation, et cet ajout est signalé comme mien.

C'est le point où l'instruction de l'ADR apporte quelque chose à la décision plutôt que de la répéter.

## L'ordre de la migration

L'ordre importait, et je l'ai établi avant d'agir.

D'abord le renommage du fichier daté, avant de construire la table de correspondance, pour que son nouvel identifiant soit celui du nouveau nom.

Ensuite la table, dérivée mécaniquement du nom de fichier plutôt que saisie : quatre-vingt-trois entrées, sans intervention.

Puis le remplacement, du plus long identifiant au plus court, pour éviter qu'un identifiant court ne soit un préfixe d'un autre. `RES-fait` aurait été remplacé à l'intérieur de `RES-faits` si l'ordre avait été inverse.

Enfin les mécanismes qui dépendaient de la forme de l'identifiant : le schéma, le générateur, le CLI.

## Le cas que la demande ne prévoyait pas

`ANL-001` est un composite de huit atomes. Chacun est une ressource de plein droit depuis `ADR-004` D3, donc chacun a besoin d'un identifiant. Mais leur donner un `<PREFIX>-<SEQ>` de plein droit entrerait en collision avec la série des analyses : il y aurait onze analyses là où il y en a trois.

La forme `ANL-001-01` résout le cas et exprime l'appartenance. Elle introduit une seconde forme d'identifiant, ce que la demande, qui dit « toutes les ressources », ne prévoyait pas. C'est un écart, signalé et porté par `NON-019` Q3.

## Trois bogues du générateur, et une cause unique

La chaîne de génération a échoué quatre fois. Les trois causes étaient les mêmes : le générateur dépendait de l'`id`, dont la forme changeait.

Le nom des définitions CUE, la valeur du champ `type`, l'énumération du champ `effet` : les trois étaient dérivés de l'`id`, et les trois ont dû être redérivés du slug du nom de fichier.

C'est la cinquième fois de cette session qu'un mécanisme se révèle couplé à une valeur qui ne devait pas porter cette information. Les quatre précédentes portaient sur la confusion entre l'affichage et l'identité ; celle-ci porte sur la confusion entre l'identité et le nom canonique du type. Le motif est stable : **une valeur qui sert à deux fins finit par ne plus servir à aucune**.

Le fait que le générateur soit une dérivation mécanique a limité le coût : quatre régénérations complètes en quelques minutes, sans édition manuelle.

## Ce que j'ai refusé de faire

**Supprimer le champ `id`.** Il est devenu redondant, et le supprimer serait une décision de conception que la demande ne porte pas. `NON-019` Q1 la soumet.

**Compléter les champs `À RENSEIGNER` des deux fichiers de l'humain.** Ils lui appartiennent. Seuls le nom de fichier, l'`id` et le titre ont été corrigés, ce que la demande exigeait.

**Toucher au texte du fragment.** `RES-008` porte une règle absolue : l'agent ne modifie jamais le texte capté, y compris pour en corriger la langue. Le titre du fragment porte une coquille, « de sont identité », que j'ai corrigée dans le nom de fichier seulement, parce que la demande demandait de corriger les noms de fichier.

**Marquer `NON-001` comme résolue.** Sa Q1 est répondue, ses Q2, Q4, Q6 et Q10 ne le sont pas. L'état passe à `partiellement-repondue`, qui est prévu par `RES-004`.
