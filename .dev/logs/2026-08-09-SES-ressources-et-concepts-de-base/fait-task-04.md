# Ce qui a été fait, tâche 4

## Livrables produits

| Fichier | Lignes | Contenu |
|---|---|---|
| `.dev/adr/ADR-002-adoption-du-processus-de-travail.md` | 234 | Huit décisions, motifs mesurés, alternatives écartées, portes de sortie, plus une section de mesures sur les trois tâches déjà exécutées |
| `.dev/objections/NON-009-statut-de-la-session-et-convergence.md` | 97 | 7 questions, effet `bloquant` |
| `.dev/objections/NON-010-roles-des-agents-et-production.md` | 95 | 7 questions, effet `conditionnel` |
| `.dev/plans/PLN-001-point-d-entree-et-analyse-de-la-demande.md` | 162 | Deux chantiers, 17 étapes, 2 points d'arrêt, 4 objections de l'agent |

## ADR-002, les huit décisions

| Décision | Objet | Alternative écartée |
|---|---|---|
| D1 | Trois agents, trois rôles non interchangeables | Un modèle à deux agents, le cli comme simple outil |
| D2 | Le travail est segmenté en sessions, avec critère de convergence différable | Le couple issue non-smart plus ticket extreme-smart |
| D3 | Toute demande passe par une analyse en cinq temps | L'exécution directe avec analyse implicite |
| D4 | La production est faite de ressources typées | Renvoi à `ADR-001` D1 |
| D5 | Le comportement de l'agent est encadré par des harnais conventionnés | Placer les règles dans `.claude/` |
| D6 | L'objection est émise au moment de l'identification, par les deux agents | La règle absolue de non-exécution, remplacée |
| D7 | La journalisation est obligatoire | Une journalisation à discrétion |
| D8 | L'interface de travail est le fichier, pas la conversation | Aucune |

Les six axes de la demande sont couverts : analyse de la demande par D3, journalisation par D7, centrage sur les ressources par D4, harnais conventionnés par D5, objection par les deux agents par D6, segmentation par sessions par D2. Les trois remarques sont intégrées : signalement immédiat des ambiguïtés dans D6, critère de convergence différable dans D2, journalisation obligatoire dans D7.

## Une rupture actée avec le processus antérieur

`ADR-002` D6 remplace la règle absolue du `CONSTITUTION.md` archivé, selon laquelle aucune exécution n'est possible tant qu'une objection reste ouverte, par la déclaration d'effet de `RES-004` à trois niveaux.

Motifs : prise au mot, la règle absolue aurait interdit les tâches 3 et 4 de cette session, trois objections bloquantes ayant été ouvertes le matin ; et son mécanisme de compensation, breakpoint plus segments plus objections différées, demande de tenir un état à trois dimensions que rien ne vérifie.

Ce que la rupture perd est nommé : le breakpoint offrait un point d'arrêt déclaré à l'avance. Une porte de sortie est écrite : si le provisoire s'installe sur la base d'objections `conditionnel` jamais résolues, la règle absolue redevient préférable.

C'est la première rupture de cap tracée de ce corpus, dont `ANL-001` établit au défaut D3 que les quatre précédentes ne l'ont jamais été.

## Deux écarts entre processus écrit et processus pratiqué, signalés

**Aucun plan n'a précédé l'exécution des trois premières tâches de la session**, alors que le processus antérieur l'exigeait avec un cycle à cinq états. Ni l'humain ni l'agent ne l'ont relevé sur le moment. L'écart retire à l'humain le point de contrôle qui précède la production. Signalé dans `ADR-002` D8 et porté par `NON-010` Q4.

**Les réponses conversationnelles ont dépassé la phrase prescrite** par le `CONSTITUTION.md` archivé. Porté par `NON-010` Q5.

Ces écarts n'ont pas été corrigés de ma propre initiative : les signaler relève de l'agent, décider s'ils sont des fautes ou des révisions relève de l'humain.

## Mesures prises sur le processus en cours

`ADR-002` porte une section de mesures sur les trois premières tâches de la session, pour que la décision s'adosse à ce que le processus vient de produire plutôt qu'à un idéal.

| Mesure | Résultat |
|---|---|
| Tâches traitées | 3 |
| Ressources produites | 25 fichiers markdown, plus un inventaire de 166 dépôts |
| Tâches journalisées | 3 sur 3, 7 fichiers de journal chacune |
| Objections émises par l'agent | 10, dont 3 bloquantes |
| Objections émises par l'humain | 0 |
| Ambiguïtés de la demande signalées | 3 |
| Décisions actées | 2 ADR, tous deux au statut `propose` |

La mesure qui vaut zéro est la plus parlante : le dispositif d'objection fonctionne pour l'instant à sens unique.

## Quatre ambiguïtés de la demande signalées, comme la demande l'exige

| Ambiguïté ou incohérence | Où elle est portée |
|---|---|
| La remarque `- les ressources créés par`, inachevée | `NON-010` Q1 |
| `ADR-001` D8 exclut la session du modèle, la tâche 4 en fait l'unité du travail | `NON-009` Q1 |
| Le « critère de convergence » ressemble au « critère de satisfaction » de `RES-003` | `NON-009` Q3 |
| Le plan est produit sous un type sans définition | `NON-010` Q3 |

## Le contrôle V8 du skill a été corrigé une seconde fois

Le contrôle de marqueurs de gabarit signalait `PLN-001` à tort, pour trois mentions du mot `TODO` désignant la note de la demande. Le motif ne se cherche désormais qu'en tête de ligne, en tête de puce, ou suivi de deux points. Contre-épreuve faite sur un fichier portant un vrai reste de gabarit : le contrôle détecte toujours ce qu'il doit détecter.

Deuxième correction du même skill par son propre usage, même cause que la première : un contrôle qui ne distingue pas une mention d'un emploi est inutilisable sur un document de méthode.

## Mise à jour rendue nécessaire

`.dev/ressources/index.md` : la table des objections passe de huit à dix entrées, avec mention de leur origine par tâche.

## Ce qui n'a pas été fait

`CLAUDE.md` n'est pas réécrit : la note `TODO` demande un plan, pas son exécution. Le fichier est intact.

Le skill d'analyse de la demande n'est pas écrit : même raison. `PLN-001` en décrit le contenu attendu en cinq temps et pose un point d'arrêt après son épreuve sur les trois demandes réelles de cette session.

Aucun ADR ni skill pour les six autres types fondamentaux. Conforme à `ADR-001` D6.

La remarque tronquée n'a pas été complétée : `workspace/session.md` est en édition humaine exclusive.
