# PLN-012 - Livrables d'installation : `init` d'un nouveau repo et `update`/`rollback` des ressources `clia`

**Statut : remplacé par PLN-016**

> Ce plan est remplacé par `PLN-016-installation-cycle-de-vie-clia` (tâche 29), qui combine `PLN-012` et `PLN-013` et refond leur contenu sur le nouveau modèle de ressources (`PLN-014`). Conservé pour traçabilité ; ne pas exécuter tel quel.

## Intention

Produire le plus rapidement possible les deux livrables attendus de la session (voir `.dev/session.md`, « Livrables attendus ») :

1. une commande CLI permettant de **créer un nouveau repo git et de l'initialiser** avec le système d'augmentation `clia` ;
2. des commandes CLI permettant d'**update / rollback les ressources `clia` dans un repo existant**.

L'intention de haut niveau est : « fournir les fonctionnalités de base pour une installation dans un nouveau repo ». Ce plan vise un **squelette fonctionnel minimal** (walking skeleton) atteint par le chemin le plus court, sans sacrifier la séquentialité imposée par la gouvernance.

## Contexte

Demande de la tâche 8 de `session.md` : « Proposer un plan permettant de produire le plus rapidement les livrables attendus ». Le livrable de la tâche 8 est **ce plan** (et son log) ; rien n'est exécuté ici.

Contraintes de gouvernance mobilisées :

- **Ordre séquentiel de travail** (acté tâche 2, objection 2, et `ADR-007`) : 0. recherches (FND/ANL) → 1. conception (documents de conception) → 2. méthodologie (harness et SKILLs) → 3. implémentation (`clia`). « Le plus rapidement » signifie minimiser le périmètre à **chaque** couche, pas court-circuiter une couche.
- **Cible d'exécution** : Debian 12, bash 5.2 ; `clia` déterministe ; `yq` (mikefarah) dépendance déclarée (tâches 5-6, `PLN-011`).
- **Séparation méthode / domaine** : le harnais et `clia` sont génériques (aucune information de domaine, `ADR-005`) ; l'humain seul édite `INTENTION.md`, `session.md`, `.dev/sessions/*`.

État de l'existant pertinent :

- `clia` expose aujourd'hui deux groupes (`res` inspection, `ses` sessions) et **résout sa racine via `BASH_SOURCE`** (`REQ-002-NF2`) : il opère donc **sur son propre dépôt d'installation**. Aucune commande `init`, `update` ni `rollback` n'existe dans `SPEC-002`/`REQ-002`/le code.
- `.dev/ressources.yaml` versionne déjà les trois **ensembles vivants** du système d'augmentation (`harness-files`, `documents-de-conception`, `clia`) et leurs membres (`ADR-004`, `ADR-007`). C'est le socle naturel du versionnage d'`update`/`rollback`.
- `PLN-008` (installeur `setup.sh`, non exécuté) prépare l'installation **de `clia` lui-même** ; sa décision ouverte (OBJECTION A : mono-dépôt vs outil global) est directement engagée par le présent plan (voir objections).

Acquis de recherche **suffisant** (gain de vitesse) : `FND-2026-07-10-installateurs-packaging` (idempotence, réversibilité, mise à jour réconciliante, effets de bord bornés, semver), `FND-2026-07-10-conventions-cli`, `ANL-2026-07-10-setup-installation`, `ANL-2026-07-10-usage-ressources-livrables`, `ANL-2026-07-10-etat-clis-existants`. **Aucune nouvelle fondation n'est requise** ; la phase 0 est considérée close.

## Spécification du livrable

Livrable de la tâche 8 : le présent plan `PLN-012` et son log. Livrables de son **exécution ultérieure** (par phases ci-dessous) :

- amendements de conception : un `ADR` sur la racine cible et le paquet distribuable, et amendements de `SPEC-002`/`REQ-002` (commandes `init`, `update`, `rollback`) ;
- amendement de méthodologie : `skl-011` (et, si nécessaire, mention dans `CLAUDE.md`) ;
- implémentation `clia` : résolution de racine cible, `cmd_init`, `cmd_update`, `cmd_rollback`, entrées `clia.doc.yaml`, harnais de test en bac à sable ;
- bumps atomiques dans `.dev/ressources.yaml`.

## Chemin le plus court (principe directeur)

Un seul **prérequis transversal** conditionne les deux livrables : `clia` doit pouvoir **agir sur un repo cible distinct de son propre arbre d'installation**. Une fois ce prérequis conçu et implémenté, `init` et `update`/`rollback` sont des variantes de la même opération : **matérialiser / réconcilier un ensemble de ressources versionnées depuis un arbre de référence vers un repo cible**. On conçoit donc ce socle **une fois**, puis on livre `init` (D1) comme squelette le plus mince, avant `update`/`rollback` (D2) qui réutilisent le même moteur de copie/versionnage.

## Plan proposé

### Phase 0 : Cadrage (aucune exécution nouvelle, décisions par défaut)

**0.1** Acter que les fondations existantes suffisent (voir Contexte) : pas de nouvelle FND/ANL.

**0.2** Retenir, à valider par l'humain via `session.md`, les **décisions par défaut** (les moins risquées, alignées sur l'acquis) qui débloquent l'exécution. Elles font l'objet des objections ci-dessous et sont récapitulées là.

### Phase 1 : Conception

**1.1 Nouvel `ADR` : racine cible et paquet distribuable (bump `documents-de-conception`).** Décider et documenter :

- `clia` distingue sa **racine d'installation** (où vit son code, via `BASH_SOURCE`) de la **racine cible** sur laquelle agissent `init`/`update`/`rollback` (répertoire fourni en argument, ou racine git du répertoire courant). `REQ-002-NF2` évolue : la résolution `BASH_SOURCE` reste valide pour les commandes agissant sur le propre dépôt de `clia`, mais les nouvelles commandes résolvent une **cible au runtime**.
- Définition du **paquet distribuable `clia`** : l'ensemble des ressources de méthode qui constituent le système d'augmentation (harness-files, documents-de-conception, `clia`, plus le squelette `.dev/` et les templates), par opposition au **contenu de domaine** du repo (jamais touché : `INTENTION.md`, `session.md`, `.dev/sessions/*`, `logs/*`, contenu métier). Un **manifeste d'appartenance** déclare ce qui appartient au paquet ; `.dev/ressources.yaml` en est le point de départ (versions par ensemble et par membre).

**1.2 Amender `SPEC-002` et `REQ-002` (bump `documents-de-conception`).** Ajouter les commandes, en réutilisant la grammaire et les conventions déjà actées (`clia [GLOBAL_OPTIONS] COMMAND [OPTIONS]`, codes 0/1/2, `--dry-run`, `--debug`) :

- `clia init [-C <dir>|<dir>]` : crée le répertoire cible (si absent), `git init`, matérialise le squelette d'augmentation depuis l'arbre de référence, écrit `.dev/ressources.yaml` et `version.yaml` initiaux, dépose le template de session. **Idempotent** (n'écrase pas un repo déjà initialisé sans le signaler), **réversible dans le sens où il n'écrit que des fichiers de méthode**, **`--dry-run`** décrit sans écrire.
- `clia update [-C <dir>]` : réconcilie les ressources de méthode du repo cible vers les versions portées par l'arbre de référence installé ; **ne touche jamais** le contenu de domaine ; rapporte le différentiel (membres mis à jour, versions avant/après) ; bump du `.dev/ressources.yaml` cible ; `--dry-run` obligatoire pour prévisualiser.
- `clia rollback [-C <dir>] [<version|ensemble>]` : restaure l'état antérieur des ressources de méthode (mécanisme à trancher, objection 3).
- Statut lecture seule vs mutant : `init`/`update`/`rollback` sont **mutants** (`REQ-002-NF4` : échec sans effet de bord si précondition non remplie, opérations atomiques `tmpfile` + `mv`, `FND` §5).
- Ajouter les entrées documentaires dans la source de vérité (`clia.doc.yaml`) pour la découvrabilité et l'uniformité (`REQ-001-F5/F7/F8/F9`).

### Phase 2 : Méthodologie

**2.1 `skl-011` (bump `harness-files`).** Étendre le skill de codage CLI bash pour couvrir le patron d'une commande **agissant sur un repo cible** (résolution de cible, garde-fous méthode/domaine, idempotence réconciliante, atomicité). Générique, sans information de domaine.

**2.2 `CLAUDE.md` si nécessaire (bump `harness-files`).** Mentionner, dans « Sessions et `clia` » ou une section installation, que `clia` peut initialiser et mettre à jour le système d'augmentation d'un repo cible ; rappeler que ces commandes ne touchent pas le contenu de domaine. À faire **seulement** si le comportement de l'agent en dépend (sinon, s'abstenir pour rester minimal).

### Phase 3 : Implémentation (`clia`)

**3.1 Socle commun (moteur).** Ajouter à `src/lib/` la résolution de **racine cible** (`-C <dir>` ou racine git du cwd) et un module de **matérialisation/réconciliation** : copie atomique d'un membre depuis l'arbre de référence vers la cible, comparaison de versions via `yq` sur `.dev/ressources.yaml`, filtre d'appartenance (méthode uniquement, jamais le domaine).

**3.2 `cmd_init`** (livrable D1, le squelette le plus mince, livré en premier) : `git init` + matérialisation + `ressources.yaml`/`version.yaml` initiaux + template de session ; idempotent ; `--dry-run`.

**3.3 `cmd_update`** (livrable D2) : réconciliation cible ← référence, rapport de différentiel, bump du manifeste cible ; `--dry-run` ; refus sans effet si la cible n'est pas un repo `clia` valide.

**3.4 `cmd_rollback`** (livrable D2) : restauration selon le mécanisme retenu (objection 3).

**3.5 Dispatch + doc.** Enregistrer `init`/`update`/`rollback` dans le dispatch de `src/bin/clia` et dans `clia.doc.yaml` (cohérence dispatch/documentation, `REQ-001-F9`).

**3.6 Harnais de test cumulatif** (répond au contexte de session « tests fragmentés qui ne se cumulent pas ») : bac à sable isolé (répertoire temporaire, faux `$HOME`), scénario cumulatif `init` → `update` (no-op puis mise à jour) → `rollback` → vérifications, plus erreurs d'usage. Jamais d'écriture hors bac à sable.

### Versionnage atomique (`.dev/ressources.yaml`)

À l'exécution, bumper atomiquement : membres `clia` modifiés (`src/bin/clia`, modules ajoutés à `src/lib/`, `src/clia.doc.yaml`) + ensemble `clia` ; `SPEC-002`, `REQ-002`, nouvel `ADR` + ensemble `documents-de-conception` ; `skl-011` (+ `CLAUDE.md` le cas échéant) + ensemble `harness-files` ; `version-manifeste`. Aucun impact sur la version du domaine métier (`version.yaml`, `ADR-007`).

### Vérification

- `clia init` sur un répertoire vide produit un repo git initialisé, doté du squelette d'augmentation, dont `clia ses status`/`clia res ls` fonctionnent depuis la cible.
- `clia update` met à jour uniquement les ressources de méthode ; un fichier de domaine modifié (ex. `INTENTION.md`, `session.md`) reste **intact** ; `--dry-run` n'écrit rien.
- `clia rollback` restaure l'état antérieur des ressources de méthode.
- Toutes les commandes sont découvrables et uniformes (`clia -h` liste `init`/`update`/`rollback`, chacune a son aide) ; cohérence dispatch/documentation (`REQ-001-F9`).
- Échec sans effet de bord si précondition non remplie (`REQ-002-NF4`) ; `shellcheck` sans avertissement bloquant ; harnais de test cumulatif vert.

## Objections de l'agent IA

- **[OBJECTION 1 - racine cible vs `BASH_SOURCE`, à trancher avant exécution]** Les deux livrables supposent que `clia` agisse sur un repo **différent de son propre arbre d'installation**, ce que le modèle actuel (`REQ-002-NF2`, racine via `BASH_SOURCE`) ne permet pas. Si le plan est exécuté sans trancher, l'implémentation partira soit sur une base incohérente, soit sur des allers-retours de conception coûteux.
  - Impact : détermine l'architecture même de `clia` et engage la décision restée ouverte dans `PLN-008` (OBJECTION A, mono-dépôt vs outil global).
  - Suggestion (défaut proposé) : adopter le **modèle « outil installé une fois + cible résolue au runtime »** (racine git du cwd ou `-C <dir>`), et amender `REQ-002-NF2` en conséquence. C'est le seul modèle qui rend les livrables réalisables ; il aligne aussi `PLN-008` sur le modèle B.

- **[OBJECTION 2 - frontière méthode / domaine, risque d'écrasement de travail humain]** `update`/`rollback` réécrivent des ressources dans un repo existant. Sans manifeste d'appartenance **explicite**, ces commandes pourraient écraser du contenu de domaine ou des fichiers en édition humaine uniquement (`INTENTION.md`, `session.md`, `.dev/sessions/*`, logs, contenu métier), c'est-à-dire détruire du travail non versionné par le manifeste.
  - Impact : perte de données ; violation de la classification des documents (`CONSTITUTION.md`).
  - Suggestion : faire du **manifeste d'appartenance** (phase 1.1) un livrable bloquant ; `update`/`rollback` n'agissent **que** sur les membres déclarés du paquet, jamais par balayage de répertoire. `--dry-run` obligatoire avant toute mutation.

- **[OBJECTION 3 - mécanisme de `rollback`, source des versions antérieures]** `rollback` exige une source d'états antérieurs. Deux mécanismes possibles, aux propriétés différentes : (a) s'appuyer sur l'historique git du repo cible (le repo est déjà versionné) ; (b) que `clia` gère ses propres instantanés de sauvegarde (répertoire d'état). Choisir (a) couple `rollback` à git ; choisir (b) ajoute un mécanisme d'état à maintenir.
  - Impact : détermine la complexité et la fiabilité de `rollback`, et son interaction avec la règle « l'agent ne fait jamais de git » (ici c'est `clia`, déterministe et opéré par l'humain, donc légitime, mais à acter).
  - Suggestion (défaut proposé) : pour la vitesse, viser d'abord `init` + `update` comme squelette livrable, et implémenter `rollback` via **instantané géré par `clia`** (mécanisme (b), autonome, déterministe, sans dépendance à l'état git de l'utilisateur). Trancher explicitement avant la phase 3.4.

- **[OBJECTION 4 - source de distribution]** D'où `update` tire-t-il les versions « plus récentes » : uniquement l'**arbre `clia` installé localement** (hors ligne, déterministe), ou une **release distante** (réseau, signatures) ? Une release distante rouvre les risques de sécurité documentés par la fondation (`curl | bash`, intégrité, signatures).
  - Impact : périmètre, sécurité, déterminisme.
  - Suggestion (défaut proposé) : se limiter à l'**arbre installé localement** comme source de vérité de distribution (déterministe, sans réseau, aligné `REQ-002-NF1`). La distribution distante est hors périmètre de ce plan (livrable ultérieur).

- **[OBJECTION 5 - tentation de court-circuiter la séquentialité pour aller vite]** « Le plus rapidement » ne doit pas conduire à coder `init`/`update` avant d'avoir amendé `SPEC-002`/`REQ-002` et le nouvel `ADR`. Sauter la conception produirait un code non spécifié, contraire à la tâche 2 (objection 3 : « fonctionnalités de cœur non négociables ») et à `ADR-007`.
  - Impact : dette de conception, code jetable, non-conformité de gouvernance.
  - Suggestion : conserver l'ordre phases 1 → 2 → 3, mais minimiser le périmètre de chaque phase (un seul ADR, amendements ciblés, `rollback` en second temps). C'est le compromis vitesse / robustesse retenu par ce plan.

## Note sur les objections humaines

Conformément à la gouvernance, les objections de l'humain sur ce plan ne sont pas consignées ici mais dans `.dev/session.md`.
