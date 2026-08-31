# Analyse avant réalisation, tâche 27

## Ce que l'exploration a établi

Les sept questions de `NON-004` portent désormais une réponse. Au moment où `ANL-007` a été produite, une seule en avait une.

**`ANL-007` est périmée.** Elle le déclare elle-même : « Une réponse ajoutée à `NON-004` après le 2026-08-11 périme cette analyse. »

Le type `ANL` est `point-fixe`. Une analyse arrêtée ne se réécrit pas : elle produit une analyse nouvelle qui déclare sa filiation. D'où `ANL-008`.

## Trois reproches, et ils portent sur ma méthode

C'est la part la plus importante de ces réponses, et elle n'est pas une question de conception.

**R1, réponse Q3.** « Il y a ici méprise de la part de l'agent. L'agent revient souvent avec cette conception naïve à propos du savoir et cela m'agace beaucoup. »

Ce que j'ai fait : traiter le savoir comme un volume homogène, dont le seul problème serait le calibre du contenant. Ma question posait « faut-il une forme légère », comme si le savoir se distinguait par sa taille.

Ce que la réponse pose : le savoir n'est pas homogène. Il dépend du contexte sous plusieurs déclinaisons, dont l'acteur et son état, l'intention, les moyens, l'historique. Et surtout : **le savoir est une forme particulière de relation entre un acteur et une information**.

La différence entre technote et fondation n'est donc pas une différence de longueur, c'est une différence d'usage et d'acteur.

**R2, réponse Q5.** « prendre ce qui est observé pour une vérité. L'agent IA a tendance à sauter trop vite aux conclusions et à ne pas bien gérer l'incertitude et l'indétermination. »

Ce que j'ai fait : `ANL-001` observe cent soixante-six dépôts, et j'ai traité ses constats comme des normes. Ma question Q5 demandait s'il fallait « reclasser » quatre fondations d'un autre dépôt, comme si l'usage observé ailleurs devait faire loi ici.

Ce que la réponse pose : la source de vérité est **contextuelle**, propre au dépôt, et déterminée par l'humain via `INT` et `DCN`. Une observation est une hypothèse, pas un fait normatif.

**R3, réponse Q7.** « L'agent IA ne semble pas bien comprendre la notion d'intention. Également, l'agent IA ne semble pas bien comprendre le processus de construction et, en particulier, son temps caractéristique. »

Ce que j'ai fait : traiter l'écart entre l'intention déclarée de `INTENTION.md` et l'état du système comme une contradiction à résoudre. `ANL-001` « conteste » l'affirmation ; ma question proposait de la retirer.

Ce que la réponse pose : une intention est ce à quoi l'acteur veut parvenir. Un système en cours de conception présente **nécessairement** un écart avec son intention, et cet écart n'est pas une faute.

**Ce que les trois ont en commun.** Une confusion entre ce qui est constaté et ce qui fait autorité. C'est le même défaut sous trois angles : le savoir réduit à sa forme observable, l'usage observé pris pour une norme, l'écart présent pris pour un démenti.

## Ce que les réponses posent sur le fond

Six énoncés structurants, au-delà des questions posées.

| Énoncé | Réponse |
|---|---|
| **clia utilise clia** : le système est décrit par ses propres ressources | Q2 |
| Une ressource peut être **hybride, source et générée** ; son rôle dépend du contexte d'usage | Q3 |
| Une mise à jour du savoir mobilisé **doit propager** aux ressources générées | Q3 |
| Une ressource n'est qu'un **réceptacle matérialisé d'une idée** | Q4 |
| Le cycle de vie des ressources est **collectif**, non individuel | Q4 |
| L'**analyse est une ressource générée** à partir de fondations et d'une question | Q5 |

**Le plus lourd est le dernier.** Il fait de `ANL` un type dérivé, ce qui étend le mouvement de `ADR-016` D3 pour les skills et de `ADR-017` D5 pour les ADR. Trois familles de documents deviennent dérivées, et rien ne dérive.

Il s'applique au document que cette tâche produit : `ANL-008` devrait être générée à partir de fondations et d'une question, et elle est écrite à la main.

## Ce que les réponses demandent de produire

| Réf | Demande | Réponse |
|---|---|---|
| D1 | Créer `ONT-001`, ontologie des concepts fondamentaux de clia | Q2 |
| D2 | Une ressource « registre », puis trois instances : dette, bogues, tâches à faire | Q4 |
| D3 | Un `PDC` sur la distillation | Q4 |
| D4 | Définir la frontière entre concept et relation | Q2 |
| D5 | Définir la frontière entre information et savoir | Q3 |
| D6 | Un type pour la question dont l'analyse dérive, à évaluer | Q5 |

**Ce que la tâche demande.** Une analyse et un plan. Pas l'exécution.

Les six demandes vont donc au plan, y compris `ONT-001` que Q2 introduit par « Commençons par créer ».

## Ce que je ne ferai pas

**Réécrire `ANL-007`.** Le type est `point-fixe`. Elle reste comme trace de ce qui était connu quand une seule réponse existait.

**Traiter les trois reproches comme des questions de conception.** Ils portent sur la manière dont je travaille, et le plan doit en tirer des règles, non des documents.
