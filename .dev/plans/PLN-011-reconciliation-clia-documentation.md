# PLN-011 - Réconciliation de `clia` avec la convention de documentation

**Statut : résolu**

## Changelog

Révision suite aux réponses de l'humain à mes trois nouvelles objections (tâche 6 de `.dev/session.md`, « [traitement des objections] »).

- **Objection 1 levée par amendement** : la garantie de cohérence entre commandes dispatchées et commandes documentées est intégrée **explicitement** à `REQ-001` (nouvelle exigence `REQ-001-F9`, MUST), au lieu d'un simple ajustement de F8.
- **Objection 2 levée par amendement** : `yq` est **ajouté aux dépendances** de `clia`. Le parsing YAML s'appuie sur `yq` (dépendance déclarée et vérifiée), ce qui lève la contrainte de sous-ensemble plat awk.
- **Objection 3 levée par confirmation** : le mécanisme documentaire (YAML + templates + génération à la volée) est **générique**, destiné à la production de tous les CLI (`SPEC-001`, `REQ-001`), pas seulement `clia`.
- Précision de mise en œuvre (non bloquante) reportée dans le plan : `yq` doit être épinglé sur une implémentation précise (mikefarah/yq) et vérifié au runtime, deux outils `yq` incompatibles existant.

Révision suite aux réponses de l'humain à mes objections (tâche 5 de `.dev/session.md`, « [traitement des objections] Refactor du cli »).

- **Objection 1 levée par argumentation acceptée** : la résilience à l'environnement d'exécution n'est pas un requis ; cible unique = Debian 12 (bash 5.2). La contrainte de compatibilité bash 3.2 est abandonnée ; tableaux associatifs, namerefs et bash moderne sont autorisés.
- **Objection 2 levée par amendement (mécanisme imposé)** : la documentation courte et longue, l'uniformité et la couverture de toutes les commandes se réalisent par une **source de vérité documentaire YAML atomique** (une entrée par commande/sous-commande) + **deux templates** (format court, format long) + **génération à la volée**. Ce mécanisme remplace le squelette à table associative bash comme mécanisme documentaire.
- **Objection 3 levée par amendement (grammaire + options globales)** : la grammaire est `clia [GLOBAL_OPTIONS] COMMAND|GROUP [OPTIONS]`. `clia` seul avec options est une commande d'information système (`--version`, `--config`, `--help` court, `--man` long). Deux options globales sont ajoutées aux documents de conception : `--debug` (information de débogage) et `--dry-run` (affiche le plan d'exécution de la commande sans l'exécuter).
- **Périmètre élargi** : la révision introduit des changements de conception (mécanisme documentaire, grammaire, options globales). Le plan est donc restructuré selon l'ordre séquentiel d'`ADR-007` (conception → méthodologie → implémentation), au lieu de la seule phase 3 initiale.

## Intention

Réconcilier le CLI `clia` avec les exigences de documentation (`REQ-001-F5/F7/F8`) en adoptant le mécanisme documentaire retenu par l'humain : source YAML atomique + templates court/long + génération à la volée. À l'issue, `clia` est auto-documenté, découvrable et uniforme, et expose la grammaire `clia [GLOBAL_OPTIONS] COMMAND|GROUP [OPTIONS]` avec les options globales `--version`, `--config`, `--help`, `--man`, `--debug`, `--dry-run`.

## Contexte

Demande initiale : tâche 4 (planification de la réconciliation). Révision : tâche 5 (traitement des objections). Les réponses de l'humain (voir Changelog) imposent un mécanisme documentaire précis et ajoutent des éléments de conception (grammaire, options globales), ce qui fait déborder le plan de la seule implémentation vers la conception puis la méthodologie.

Cible d'exécution : **Debian 12** (bash 5.2). Aucune contrainte de portabilité multi-OS. `clia` reste **déterministe** ; `yq` est désormais une **dépendance déclarée** (décision de l'humain, tâche 6), donc autorisée à condition d'être vérifiée au runtime (`command -v yq`, diagnostic clair si absent) et épinglée sur l'implémentation mikefarah/yq (deux outils `yq` incompatibles coexistent). Le parsing YAML de la source documentaire s'appuie sur `yq`.

## État actuel (défauts à corriger)

- `clia -h` omet `ses`/`session` (`_usage` = `sed -n '2,9p'`, la ligne le décrivant est la 10 : couplage aux numéros de ligne).
- `clia res -h` et `clia ses -h` n'énumèrent ni ne décrivent leurs sous-commandes.
- Aucune aide par sous-commande.
- Documentation dupliquée sur trois sources non synchronisées (`_usage`, `_man`, aide de groupe codée en dur).

## Spécification du livrable

Le livrable de cette tâche est le présent plan (`PLN-011`) révisé. Son exécution ultérieure produira les modifications de conception, de méthodologie et de code ci-dessous. Rien n'est exécuté dans le cadre de cette tâche de planification.

## Plan proposé

### Phase 1 : Conception

**1.1 Grammaire et options globales génériques (`SPEC-001`, `REQ-001`, bump vivant).** Documenter la grammaire `outil [GLOBAL_OPTIONS] COMMAND|GROUP [OPTIONS]` : distinction entre options globales (s'appliquant à toute commande) et options propres à une commande/groupe. Reconnaître `--debug` et `--dry-run` comme options globales standard (au moins MAY au niveau générique).

**1.2 Mécanisme documentaire générique (`SPEC-001`, `REQ-001`, bump vivant).** Ce mécanisme est **générique**, destiné à la production de tous les CLI (décision de l'humain, tâche 6). Remplacer, comme mécanisme de référence satisfaisant `REQ-001-F5/F7/F8`, la table associative bash par : une **source YAML atomique** (une entrée documentaire par commande/sous-commande : nom, description courte, description longue, usage, options), deux **templates** (court, long), et une **génération à la volée** (parsing par `yq`). Fournir le nouveau squelette/patron de référence dans `SPEC-001`.

**1.2b Cohérence dispatch / documentation (`REQ-001`, bump vivant).** Ajouter une exigence explicite `REQ-001-F9` (MUST) : l'inventaire des commandes et sous-commandes dispatchées doit être identique à l'inventaire documenté dans la source de vérité ; aucune commande implémentée n'est absente de la documentation, ni l'inverse. Vérification : un contrôle de cohérence (dispatch dérivé de la source, ou auto-test comparant les deux inventaires) est fourni et passe.

**1.3 Conception spécifique à `clia` (`SPEC-002`, `REQ-002`, bump vivant).** Acter pour `clia` : la grammaire `clia [GLOBAL_OPTIONS] COMMAND|GROUP [OPTIONS]` ; `clia` seul + options = information système ; les options globales `--debug` (débogage) et `--dry-run` (plan d'exécution sans effet) en plus de `--version/--config/--help/--man` ; l'aide générée depuis la source YAML de `clia`. Mettre à jour les tables d'interface et de traçabilité (F5/F7/F8, nouvelles options).

### Phase 2 : Méthodologie

**2.1 `skl-011` (bump harnais).** Aligner le skill sur le mécanisme YAML + templates + génération à la volée : décrire l'obtention d'une aide découvrable et uniforme par ce moyen, la garantie de cohérence dispatch/documentation, et la gestion des options globales. Mettre à jour l'étape 6 et les critères de qualité.

### Phase 3 : Implémentation (`clia`)

**3.0** Déclarer `yq` (implémentation mikefarah/yq) comme dépendance : vérification au runtime (`command -v yq` + contrôle de l'implémentation) avec diagnostic clair si absent, et déclaration dans `setup.sh` / la documentation d'installation.
**3.1** Créer la source YAML de documentation de `clia` (entrées atomiques pour options globales, groupes `res`/`ses` et leurs sous-commandes), parsée par `yq`.
**3.2** Ajouter à `src/lib/` un module de rendu (templates court/long + génération à la volée depuis le YAML via `yq`), réutilisé à tous les niveaux pour l'uniformité.
**3.3** Refondre le dispatch de `src/bin/clia` : parsing des `GLOBAL_OPTIONS` (`--version`, `--config`, `--help`, `--man`, `--debug`, `--dry-run`) avant la commande/groupe ; supprimer `_usage` (plage `sed`) et reconstruire `_man` comme rendu long depuis le YAML.
**3.4** `cmd_res` (`resource.sh`) et `cmd_ses` (`session.sh`) : aide de groupe et aide par sous-commande générées depuis le YAML ; `clia -h` liste `res` et `ses` ; `clia res -h`/`clia ses -h` décrivent leurs sous-commandes ; `clia GROUPE SOUS -h` existe.
**3.5** Implémenter `--dry-run` pour les commandes mutantes (`ses plan/open/close/new`) : afficher le plan d'exécution sans effet de bord ; `--debug` : traces sur stderr.

### Versionnage atomique (`.dev/ressources.yaml`)

Bumper : membres de `clia` modifiés (`src/bin/clia`, `src/lib/resource.sh`, `src/lib/session.sh`, module de rendu ajouté, éventuellement `common.sh`) + ensemble `clia` ; `SPEC-001`, `REQ-001`, `SPEC-002`, `REQ-002` + ensemble `documents-de-conception` ; `skl-011` + ensemble `harness-files` ; `version-manifeste`.

### Vérification

- `clia -h` (court) et `clia --man` (long) générés depuis la même source YAML ; `clia -h` liste `res` et `ses` ; `clia res -h`/`clia ses -h` et `clia GROUPE SOUS -h` décrivent les sous-commandes ; format uniforme.
- Cohérence dispatch/documentation vérifiée (`REQ-001-F9` : aucune commande dispatchée absente du YAML, et inversement).
- `yq` (mikefarah) présent et vérifié au runtime ; diagnostic clair si absent.
- `--debug` et `--dry-run` opérants ; `--dry-run` n'a aucun effet de bord sur les commandes mutantes.
- Non-régression des commandes d'inspection et mutantes (`REQ-002-NF3/NF4`) ; `shellcheck` sans avertissement bloquant ; dérouler `REQ-001` et `REQ-002` sur `clia`.

## Objections de l'agent IA

Aucune objection ouverte actuellement. Mes trois objections issues de la tâche 5 ont été traitées par l'humain en tâche 6 : cohérence dispatch/documentation intégrée explicitement à `REQ-001` (nouvelle `REQ-001-F9`) ; parsing YAML résolu par l'ajout de `yq` aux dépendances ; portée du mécanisme confirmée générique. Le détail figure dans le Changelog.

Précision de mise en œuvre non bloquante (traitée dans le plan, pas une objection) : `yq` doit être épinglé sur l'implémentation mikefarah/yq et vérifié au runtime, deux outils `yq` de syntaxes incompatibles coexistant.

## Note sur les objections humaines

Conformément à la gouvernance, les objections de l'humain sur ce plan ne sont pas consignées ici mais dans `.dev/session.md`.
