# Interprétation de la demande, tâche 13

## Demande

Tâche 13 de `workspace/session.md`, classée `[bogue]`, intitulée « identifiants relatif des ressources ».

> À l'interne d'un repo clia, toutes les ressources doivent être référençables (alias) par : `<PREFIX>-<SEQ>`.
>
> Pour les ressources RES, éliminer toute référence à `<PREFIX>-<DATE>` et `<PREFIX>-<SLUG>`.
>
> Corriger les noms de fichier et les références.

## Ce que la demande est, au-delà de son classement

Classée `[bogue]`, elle est en réalité la **réponse à la question Q1 de `NON-001`**, ouverte le 2026-08-09 avec un effet bloquant, et elle va contre la proposition de l'agent.

Le classement en bogue est significatif : pour l'humain, ce n'était pas une question ouverte mais un défaut à corriger. Cette lecture est retenue.

## Le fragment change la lecture de la demande

Le fichier ouvert dans l'éditeur au moment de la demande, `FRG-001`, contient la prémisse qui manquait à l'agent :

> À sa création, la ressource informationnelle a une identité qui la définit et permet de retracer son évolution et ses transformations. **Ce qui persiste par-delà des modifications est l'identité.**

Appliqué au cas, cela renverse le raisonnement de `ADR-001` D3. L'agent avait écarté le numéro parce qu'il le supposait renumérotable. Ce n'était pas un fait mais une permission tacite : le numéro est attribué à la création et n'a aucune raison de changer, alors qu'un slug suit un titre révisable.

Le fragment a donc été lu avant d'agir, et il a déterminé l'interprétation. Son texte n'a pas été touché, conformément à la règle absolue de `RES-008`.

## Portée retenue

**« toutes les ressources »** est pris au mot : les quatre-vingt-cinq ressources du dépôt, non seulement les définitions.

**« pour les ressources RES »** est lu comme désignant les définitions de types, qui sont les documents qui prescrivent les formes de nommage. Éliminer `<PREFIX>-<DATE>` y signifie abolir le nommage daté pour tous les types, et éliminer `<PREFIX>-<SLUG>` y signifie retirer au slug le statut d'identité.

**« corriger les noms de fichier et les références »** est pris comme une migration complète, non comme un principe.

## Ambiguïtés et écarts signalés

**Les atomes de composite ont une forme à part.** `ANL-001` porte huit atomes, qui ne peuvent pas recevoir un `<PREFIX>-<SEQ>` de plein droit sans entrer en collision avec la série des analyses. Ils reçoivent `ANL-001-01` à `ANL-001-07`, ce qui exprime leur appartenance et introduit une seconde forme d'identifiant. La demande disait « toutes les ressources » sans prévoir ce cas. Porté par `NON-019` Q3.

**Le champ `id` devient redondant.** Il vaut `<PREFIX>-<SEQ>`, entièrement déductible du nom de fichier. Un champ obligatoire sans information propre est un coût sans contrepartie. Porté par `NON-019` Q1.

**L'interdiction de renuméroter n'est vérifiée par rien.** C'est pourtant elle qui fait du numéro une identité. Porté par `NON-019` Q2.

**L'ambiguïté du numéro seul demeure.** `clia res show 002` reste ambigu si deux types portent un rang 002. C'était l'argument principal de l'agent, et il n'est pas réfuté : `ADR-007` le déclare acceptable, un identifiant complet portant toujours son préfixe. Porté par `NON-019` Q4.

## Ce que la demande ne dit pas et qui a été décidé

**L'interdiction de renuméroter.** La demande dit que l'identité est la séquence ; elle ne dit pas que la séquence est immuable. Or sans cette interdiction, la décision perd son fondement. `ADR-007` D2 l'ajoute, et c'est un ajout de l'agent.

**Le nom canonique du type passe au slug du nom de fichier.** L'`id` le portait depuis la tâche 8 ; devenu numérique, il ne peut plus. Le nom de fichier l'a toujours porté. `ADR-007` D3 le formalise.

## Ce qui n'a pas été fait

Le champ `id` n'a pas été supprimé, bien qu'il soit devenu redondant. `NON-019` Q1 le porte.

Les deux fichiers de l'humain restant non conformes, `FRG-001` et `NON-013`, n'ont pas été complétés : leurs champs `À RENSEIGNER` lui appartiennent. Seuls leur nom de fichier, leur `id` et leur titre ont été corrigés, ce que la demande exigeait explicitement.
