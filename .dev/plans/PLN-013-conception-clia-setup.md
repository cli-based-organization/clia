# PLN-013 - Conception de la commande `clia setup` (init / upgrade / downgrade)

**Statut : remplacé par PLN-016 (Phase A acquise)**

> Ce plan est remplacé par `PLN-016-installation-cycle-de-vie-clia` (tâche 29), qui combine `PLN-012` et `PLN-013`. La **Phase A reste acquise** (breakpoint introduit dans le harnais ; `ANL-2026-07-18-besoin-req-spec-ressources-livrables` produite). La Phase B non exécutée est reprise et refondée dans `PLN-016`. Conservé pour traçabilité.

## Changelog

Exécution de la Phase A jusqu'au breakpoint (tâche 11 de `.dev/session.md`, « [exécution] Exécute PLN-013 jusqu'au breakpoint »).

- **A.1 exécutée** : notion de « breakpoint » introduite dans le harnais (`CONSTITUTION.md` section « Breakpoint et exécution segmentée », mention dans `CLAUDE.md`, étape ajoutée à `skl-003`) ; bumps atomiques dans `.dev/ressources.yaml`.
- **A.2 exécutée** : `ANL-2026-07-18-besoin-req-spec-ressources-livrables` produite.
- **Breakpoint atteint** : l'exécution s'arrête. La Phase B (B.1 résolution des objections 4 et 5, puis B.2 à B.6) reste suspendue jusqu'à la revue de l'ANL par l'humain et son autorisation de reprise.

Révision suite aux réponses de l'humain à mes cinq objections (tâche 10 de `.dev/session.md`, « [Résolution des objections] pour PLN-013 »).

- **Objection 1 levée par confirmation** : `PLN-013` est exécuté **en premier** et **fait autorité** sur la phase de conception de ce sous-système, au-dessus de `PLN-012`. Mon défaut proposé est confirmé ; l'étape de cadrage/réconciliation devient une simple prise d'acte.
- **Objection 2 levée par amendement (mécanisme imposé)** : **tous les éléments des ressources livrables** (source de vérité, format variable, template, validation) sont **intégrés à `ADR-004`** par amendement. Il n'y a **pas** de nouvel ADR sur les ressources livrables ; l'ancienne étape 3 devient un amendement d'`ADR-004`.
- **Objection 3 levée par amendement (introduction d'un breakpoint)** : la séquence effectue l'`ANL` **puis s'arrête (breakpoint)** pour laisser l'humain consulter l'analyse et décider de la suite. Ceci introduit la notion de **« breakpoint »**, à formaliser dans les documents de conception et les fichiers de harnais (TODO de `session.md`). Le plan est donc **segmenté** : Phase A (jusqu'au breakpoint) et Phase B (après).
- **Objections 4 et 5 différées par décision humaine** : leur résolution est **reportée après le breakpoint** (voir `session.md`, « on se garde la résolution des objections 4 et 5 après le breakpoint »). Elles restent **ouvertes** et **bloquent la Phase B**, mais **pas la Phase A**.

Conséquence sur l'exécution : la Phase A est approuvée et peut être exécutée (production de l'introduction du breakpoint puis de l'`ANL`) ; la Phase B reste suspendue tant que les objections 4 et 5 ne sont pas traitées après le breakpoint.

## Intention

Planifier la **conception** (documents uniquement, aucune implémentation) de la commande `clia setup`, qui prend en charge les opérations de gestion du cycle de vie du système d'augmentation `clia` dans un repo : `init` (installer dans un repo neuf), `upgrade` (mettre à niveau les ressources d'un repo existant), `downgrade` (revenir à un état antérieur). Le modèle s'inspire du `setup.sh` de `ticket-driven-ai` (`tda`).

Le livrable de la tâche 9 est ce plan ; celui de la tâche 10 est cette **révision** et son log. Conformément à la demande initiale, **l'implémentation n'est pas incluse** : le plan s'arrête à la couche conception (et à la couche méthodologie pour les SKILLs/harnais), sans code `clia`.

## Contexte

Demande initiale : tâche 9 de `.dev/session.md`. Révision : tâche 10 (réponses aux objections, voir Changelog). L'humain fournit la séquence des livrables de conception et la référence d'inspiration `@../../noumanity-dev/ticket-driven-ai/setup.sh`.

Ce que montre l'inspiration `tda` : deux couches distinctes. (1) `setup.sh` installe la commande pour l'utilisateur (dev + permanent + local, avec `--check`/`--uninstall`). (2) Une fois l'outil sur le `PATH`, `tda -C <repo> install` pose la méthodologie **dans un repo cible**. `clia setup` doit clarifier l'équivalent de ces deux couches (objection 4, différée).

Éléments existants pertinents :

- `setup.sh` de `clia` ne fait aujourd'hui qu'un `activate` in-repo (ajout de `src/bin` au `PATH` de la session, sourcé, sans persistance).
- `clia` expose `res` et `ses`, résout sa racine via `BASH_SOURCE` (`REQ-002-NF2`) et valide son dispatch contre `clia.doc.yaml` (`REQ-001-F9`). Aucune capacité d'extension à des scripts externes (objection 5, différée).
- `ADR-004-ressources-livrables` couvre déjà « ce que c'est, cycle de vie, versionnage ». Par décision de la tâche 10 (objection 2), les axes complémentaires (source de vérité, format variable, template, validation) y sont **intégrés par amendement**, et non dans un nouvel ADR.
- `PLN-012` (init / update / rollback) est **subordonné** à ce plan pour la conception (objection 1). Sa révision (tâche « x ») alignera son vocabulaire et son périmètre.

Contraintes de gouvernance : ordre séquentiel `ADR-007` (recherche → conception → méthodologie → implémentation) ; ce plan couvre conception + méthodologie, pas l'implémentation. Fonctionnalités de cœur non négociables (tâche 2, objection 3). Harnais générique, aucune information de domaine (`ADR-005`). `clia` déterministe (`REQ-002-NF1`).

## Spécification du livrable

Livrable de la tâche 10 : la présente révision de `PLN-013` et son log. Livrables de l'**exécution ultérieure**, tous des documents de conception / méthodologie (aucun code), répartis de part et d'autre du breakpoint :

Phase A (avant breakpoint) :
1. l'introduction de la notion de **« breakpoint »** dans les documents de conception et les fichiers de harnais ;
2. une **analyse** (`ANL`) déterminant s'il faut des `REQ`/`SPEC` pour les ressources livrables.

Phase B (après breakpoint, une fois les objections 4 et 5 traitées) :
3. l'**amendement d'`ADR-004`** intégrant source de vérité, format variable, template et validation des ressources livrables ;
4. un `ADR` décrivant `setup` (`init`, `upgrade`, `downgrade`) : modèle d'installation, deux couches, cycle de vie des opérations (dépend de l'objection 4) ;
5. la conception de la **capacité d'extension à des scripts externes** (dépend de l'objection 5) ;
6. un `REQ` puis une `SPEC` de `setup` (selon le verdict de l'`ANL`) ;
7. une **ressource livrable décrivant une interface CLI** (nouvel `ADR` + nouveau `SKILL` + adaptation des fichiers de harnais).

## Plan proposé (séquence de conception segmentée)

### Phase A - jusqu'au breakpoint (approuvée)

**A.1 Introduire la notion de « breakpoint » (documents de conception + harnais).** Formaliser le mécanisme par lequel un plan peut être exécuté en segments, avec un **arrêt de revue humaine** entre deux segments : un breakpoint suspend l'exécution après un livrable donné, l'humain consulte le résultat et décide de la suite (poursuivre, amender, réorienter). Introduire cette notion là où elle fait autorité (par exemple `CONSTITUTION.md` pour le cycle de vie d'un plan, et mention dans `CLAUDE.md`), en cohérence avec le cycle `proposé → objection → résolu → approuvé → exécuté` et avec la règle de non-exécution sous objection ouverte (un breakpoint permet une **approbation partielle** explicite). Ressource(s) de harnais amendée(s) et bump atomique.

**A.2 `ANL` sur les ressources livrables.** Analyse (`skl-012`) déterminant si les ressources livrables requièrent des `REQ`/`SPEC` propres (au-delà d'`ADR-004` amendé) et cadrant les notions de source de vérité, format variable, template et validation. Cette analyse est le **dernier livrable avant le breakpoint** : elle alimente la décision humaine.

### Breakpoint (arrêt de revue humaine)

Après l'`ANL`, **l'exécution s'arrête**. L'humain consulte l'analyse et décide de la suite, notamment le sort des objections 4 et 5 (voir ci-dessous) et le périmètre des `REQ`/`SPEC` des ressources livrables. Aucune ressource de Phase B n'est produite avant la reprise autorisée par l'humain.

### Phase B - après le breakpoint (suspendue tant que les objections 4 et 5 sont ouvertes)

**B.1 Résolution des objections 4 et 5** par l'humain (via `session.md`) : frontière `setup.sh` / `clia setup` (objection 4) et capacité d'extension à des scripts externes (objection 5). Prérequis au reste de la Phase B.

**B.2 Amender `ADR-004`** (objection 2) : y intégrer source de vérité, format variable, template et validation des ressources livrables, en cohérence avec le verdict de l'`ANL`.

**B.3 `ADR` du modèle `setup`** (`skl-006`) : deux couches (installer l'outil `clia` pour l'utilisateur vs gérer le système d'augmentation dans un repo cible), résolution de la racine cible (`-C <dir>` ou racine git du cwd) distincte de `BASH_SOURCE`, sémantique de `init`/`upgrade`/`downgrade`, propriétés d'installateur robuste (idempotence, réversibilité, effets de bord bornés, atomicité, moindre privilège, `FND-2026-07-10-installateurs-packaging`), frontière méthode / domaine. Dépend de B.1 (objection 4).

**B.4 Conception de la capacité d'extension à des scripts externes** : `ADR` dédié (plus `REQ`/`SPEC` selon B.2/l'`ANL`) décrivant la découverte des commandes externes, le contrat d'interface (conformité `REQ-001`, entrées/sorties/codes), l'intégration à `clia.doc.yaml` et au dispatch validé (`REQ-001-F9`), et les garde-fous de déterminisme (`REQ-002-NF1`) et de sécurité. Dépend de B.1 (objection 5).

**B.5 `REQ` puis `SPEC` de `setup`** (`skl-010`, `skl-009`) : exigences et interface complète (`init`/`upgrade`/`downgrade`, `--dry-run`, idempotence, réversibilité, frontière méthode/domaine, codes de retour, entrées `clia.doc.yaml`), traçabilité mutuelle. Dépend de B.3 et B.4.

**B.6 Ressource livrable « interface CLI »** : nouvel `ADR` actant ce type de ressource vivante, nouveau `SKILL` (`skl-001` comme méta-skill) encadrant sa production, et adaptation des fichiers de harnais (table des livrables de `CLAUDE.md`, `.dev/ressources.yaml`).

### Versionnage atomique (à l'exécution)

Chaque document produit ou amendé bumpe atomiquement son membre et son ensemble dans `.dev/ressources.yaml` : harnais amendé pour le breakpoint (Phase A) et pour l'interface CLI (Phase B) + ensemble `harness-files` ; `ADR-004` amendé, ADR/REQ/SPEC nouveaux + ensemble `documents-de-conception` ; `version-manifeste`. L'`ANL` est point fixe (datée, non versionnée). Aucun impact sur la version métier (`version.yaml`). Aucun code `clia`.

### Vérification (à l'exécution)

- Phase A : la notion de breakpoint est documentée de façon cohérente (harnais) ; l'`ANL` existe, conforme à `skl-012`, et conclut clairement sur le besoin de `REQ`/`SPEC`.
- Breakpoint respecté : aucune ressource de Phase B produite avant reprise autorisée.
- Phase B (après reprise) : `ADR-004` amendé sans duplication ; ADR/REQ/SPEC `setup` mutuels et tracés ; vocabulaire `init`/`upgrade`/`downgrade` uniforme ; nouveau type « interface CLI » reflété dans `CLAUDE.md` et `.dev/ressources.yaml`.
- Aucune ligne de code `clia` produite (implémentation hors périmètre, tâche 9).

## Objections de l'agent IA

- **[OBJECTION 1 - recouvrement avec `PLN-012`] : LEVÉE (confirmation).** L'humain confirme que `PLN-013` est exécuté en premier et fait autorité sur la conception de ce sous-système. `PLN-012` lui est subordonné et sera réaligné par la tâche « x ».

- **[OBJECTION 2 - duplication possible avec `ADR-004`] : LEVÉE (amendement).** Décision : intégrer tous les éléments des ressources livrables **dans** `ADR-004` (source de vérité, format variable, template, validation). Pas de second ADR. Traité en B.2.

- **[OBJECTION 3 - séquencement ANL/breakpoint] : LEVÉE (amendement).** Décision : `ANL` puis **breakpoint** de revue humaine. La notion de breakpoint est formalisée en A.1. La séquence est segmentée en Phases A et B.

- **[OBJECTION 4 - `clia setup` (commande) vs `setup.sh` (script), frontière des deux couches] : OUVERTE, DIFFÉRÉE après le breakpoint.** Par décision de l'humain (tâche 10), sa résolution est reportée après le breakpoint. Elle **bloque la Phase B** (prérequis de B.3) mais **pas la Phase A**. Rappel du risque : sans trancher, la conception de `setup` pourrait mêler l'installation de l'outil `clia` lui-même et la gestion du système d'augmentation dans un repo cible.

- **[OBJECTION 5 - capacité d'extension à des scripts externes] : OUVERTE, DIFFÉRÉE après le breakpoint.** Par décision de l'humain (tâche 10), reportée après le breakpoint. Elle **bloque la Phase B** (prérequis de B.4) mais **pas la Phase A**. Rappel du risque : ouvrir `clia` à du code tiers touche le déterminisme (`REQ-002-NF1`), la cohérence dispatch/documentation (`REQ-001-F9`), la généricité et la sécurité ; à traiter dans un ADR dédié avec contrat d'interface strict.

Précision non bloquante (pas une objection) : l'introduction de la notion de « breakpoint » (A.1) est une addition de gouvernance transverse, plus large que la seule conception de `clia setup`. Elle est traitée ici parce que rattachée par l'humain à cette révision (TODO de `session.md`) ; elle pourrait alternativement relever d'un plan de harnais dédié si son périmètre s'élargit.

## Note sur les objections humaines

Conformément à la gouvernance, les objections de l'humain sur ce plan ne sont pas consignées ici mais dans `.dev/session.md`.
