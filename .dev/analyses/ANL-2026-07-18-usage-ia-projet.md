# ANL-2026-07-18 - Usage de l'IA dans le projet au regard du principe de nécessité

- **Date** : 2026-07-18
- **Périmètre** : la répartition des tâches entre l'humain, `clia` (automatisme déterministe) et l'agent IA dans ce dépôt, telle qu'inscrite dans le harnais (`CLAUDE.md`, `CONSTITUTION.md`), les décisions (`ADR-004`, `ADR-006`, `ADR-007`), les skills, et le code de `clia` (`src/`). Exclusions : contenu métier, `.git/`.
- **Référence** : `FND-2026-07-18-capacites-modeles-ia-usage` (critère IA vs automatisation) ; principe de session « n'utiliser l'IA que lorsque c'est absolument nécessaire ; le reste => automatiser ; permettre à l'humain d'exécuter à la demande ou d'inspecter n'importe quelle étape ».

## Objet

Évaluer si le projet respecte son principe directeur : IA seulement quand nécessaire, automatisation du reste, inspection/exécution humaine possible à chaque étape. Confronter la répartition actuelle des rôles au critère de la fondation, mesurer les écarts, et recommander des ajustements. L'analyse recommande ; elle n'exécute aucun changement.

## Périmètre et méthode

Corpus : les trois acteurs du système d'augmentation (`ADR-007`) et la frontière de leurs responsabilités. Grille d'analyse, dérivée de la `FND` (section 5) : pour chaque tâche du système, déterminer si elle est **spécifiable et vérifiable** (donc à automatiser) ou si elle exige **jugement / langage naturel / généralisation** (donc IA nécessaire), puis vérifier à quel acteur elle est effectivement confiée. Troisième dimension : l'**inspectabilité / exécutabilité humaine** de chaque étape.

## Inventaire

Répartition actuelle des responsabilités :

- **Humain** : point d'entrée unique (`session.md`), objections, décisions, opérations git, opération de `clia`.
- **`clia` (déterministe, `ADR-007`, `SPEC-002`)** : transitions d'état des sessions (`ses plan/open/close/new`), inspection des ressources et versions (`res ls`, `ses status`, `--version`, `--config`), validation de format (`ses check` contre `SPEC-003`). L'agent **n'invoque jamais** les commandes mutantes de session.
- **Agent IA** : production des livrables porteurs de jugement (plans, fondations, analyses, ADR, spécifications, requis, harnais), rédaction des logs, et opérations d'intendance associées (nommage, numérotation de séquence, bumps de version dans `.dev/ressources.yaml`).

## Constats

**C1. Le partage de principe est déjà posé, et il est correct.** `ADR-007` sépare explicitement un composant **déterministe** (`clia`) d'un composant **IA** (l'agent), et `CONSTITUTION.md` interdit à l'agent de muter les sessions ou de faire du git. C'est exactement le découpage recommandé par la `FND` (section 2) : les opérations spécifiables, vérifiables et à intégrité garantie (transitions de fichiers, validation, versions) relèvent du déterministe ; la production porteuse de jugement relève de l'IA. Le principe « automatiser le reste » est donc **structurellement inscrit**, pas seulement affiché.

**C2. Les tâches confiées à l'IA sont, pour l'essentiel, de vraies tâches d'IA.** Rédiger un plan, arbitrer des objections, concevoir une spécification, analyser un corpus, faire évoluer le harnais : toutes exigent langage naturel, jugement ou généralisation (critère `FND` section 5). L'emploi de l'IA y est **nécessaire**, conforme au principe.

**C3. Des mécaniques déterministes sont encore portées par l'agent, en tension avec le principe.** Plusieurs opérations que l'agent réalise « à la main » sont entièrement spécifiables et vérifiables, donc candidates à l'automatisation par `clia` :
   - **le versionnage atomique** de `.dev/ressources.yaml` (bumper le membre et son ensemble, `ADR-004`) : règle déterministe, exécutée manuellement par l'agent à chaque modification, avec risque d'erreur ou d'oubli ;
   - **l'allocation des numéros de séquence** (`PLN-<SEQ>`, `ADR-<SEQ>`, etc.) et la **construction des noms datés** (`FND`/`ANL`/`LOG`) : purement calculables ;
   - **le squelette des logs** (`LOG-<DATE>-task-<NN>.md`) et des livrables : structure fixe, gabarit connu ;
   - **la cohérence de format** des ressources vivantes (lignes « Statut : » / « Version : » lues par `clia`, voir `ANL-2026-07-18-besoin-req-spec-ressources-livrables`) : vérifiable par machine.
   Faire porter ces tâches par l'IA, c'est employer un composant variable et coûteux là où le déterministe serait plus sûr, reproductible et gratuit (`FND` section 2) : un écart au principe « le reste => automatiser ».

**C4. L'inspectabilité humaine est bien servie, mais l'exécution à la demande reste partielle.** L'interface « fichiers, pas conversation » (`CONSTITUTION.md`) rend chaque étape inspectable ; `clia` offre des commandes d'inspection en lecture seule ; le **breakpoint** récemment introduit (voir `PLN-013`, tâche 11) permet à l'humain de consulter et de décider entre deux segments. En revanche, il n'existe pas encore de validation générique inspectable des ressources (pas de `clia res check`), ni de `--dry-run` généralisé permettant de prévisualiser une étape mutante avant de l'exécuter (prévu en conception, non implémenté).

**C5. Aucune sur-utilisation manifeste de l'IA sur des tâches triviales.** Le dépôt ne confie pas à l'IA de tâches de pur calcul, de tri ou de validation formelle qui seraient mieux scriptées ; le principal écart (C3) concerne l'intendance déterministe adjacente à la production IA, pas un recours abusif à l'IA pour des tâches simples.

## Confrontation à la référence

Face à la `FND-2026-07-18` et au principe de session :

- **Conforme** : la frontière `clia` (déterministe) / agent (IA) suit le critère de la fondation (C1) ; les tâches IA sont nécessaires (C2) ; l'inspectabilité par fichiers et commandes en lecture seule est en place (C4).
- **Écart** : des opérations **spécifiables et vérifiables** (versionnage, numérotation, gabarits, validation de format) restent portées par l'agent alors que le principe commande de les automatiser (C3). Écart d'ampleur modérée mais récurrent, car ces opérations se répètent à chaque tâche.
- **Écart partiel** : l'« exécution à la demande / inspection de n'importe quelle étape » est bien avancée côté inspection, mais l'exécution prévisualisable (`--dry-run`) et la validation générique (`res check`) manquent encore (C4).

## Synthèse et recommandations

**Constat central** : le projet respecte le principe dans sa structure (séparation déterministe/IA, IA employée là où elle est nécessaire, inspection par fichiers), mais laisse encore l'agent porter des mécaniques déterministes qui, selon la fondation, devraient être automatisées par `clia`.

Recommandations, par priorité (à trancher par l'humain) :

1. **(Prioritaire) Déplacer le versionnage atomique de l'agent vers `clia`.** Une commande déterministe (par ex. `clia res bump <membre>` ou un contrôle de cohérence de `.dev/ressources.yaml`) retirerait à l'IA une tâche purement spécifiable et éliminerait une source d'erreur récurrente. Application directe de « le reste => automatiser ».
2. **(Prioritaire) Automatiser la numérotation de séquence et les noms datés** (allocation du prochain `<SEQ>`, construction des noms `FND`/`ANL`/`LOG`) via `clia`, plutôt que par calcul manuel de l'agent.
3. **(Recommandé) Générer les squelettes déterministes** (log, en-têtes de livrables) par gabarit `clia`, en ne laissant à l'IA que le contenu porteur de jugement.
4. **(Recommandé) Compléter l'inspectabilité/exécutabilité** : fournir une validation générique inspectable des ressources (`clia res check`, sur le modèle de `ses check`) et généraliser `--dry-run` aux commandes mutantes, pour que l'humain puisse prévisualiser toute étape avant exécution.
5. **(À confirmer) Statuer sur ce qui doit rester à l'IA.** Confirmer que la production porteuse de jugement (plans, conception, analyses, harnais, arbitrage d'objections) reste du ressort de l'IA : c'est là que sa capacité est nécessaire (`FND` section 5). Ne pas chercher à « automatiser » ces tâches serait aligné, pas contraire, au principe.

Ces recommandations affinent l'application du principe ; elles ne remettent pas en cause l'architecture à deux domaines d'`ADR-007`, qu'elles renforcent.

## Portée et péremption

Couverture : la répartition des rôles au 2026-07-18 (harness-files 0.4.0), y compris l'introduction récente du breakpoint. Limites : l'analyse ne quantifie pas le temps ou le coût réel imputables à l'IA sur les tâches d'intendance (C3) ; une mesure serait à faire avant d'arbitrer l'effort d'automatisation. Péremption : liée à l'évolution de `clia` et du harnais ; toute automatisation des mécaniques citées rend cet état des lieux caduc.
