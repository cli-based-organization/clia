# PLN-006 - Développement du CLI bash `clia`

**Statut : exécuté** (tâche 19 ; objections bloquantes résolues en tâche 18 ; objections résiduelles non bloquantes tranchées par défaut)

## Sessions-tâches liées

- session `2026-07-09T07:50:14-04:00`, tâche 17 (planification initiale)
- session `2026-07-09T07:50:14-04:00`, tâche 18 (résolution des objections)
- session `2026-07-09T07:50:14-04:00`, tâche 19 (exécution)

## Intention

Développer `clia`, un CLI bash **100% déterministe** qui prend en charge les changements d'état du cycle de vie des fichiers du système d'information (sessions, ressources livrables) afin d'en garantir l'intégrité. `clia` outille la méthode de travail : gestion des sessions (planification, ouverture, archivage, vérification de format) et inspection des ressources livrables et de leurs versions.

`clia` n'est **pas** l'agent IA et n'est **pas** une ressource de harnais : c'est un **troisième composant** du système d'augmentation par IA, à côté des documents de conception et des fichiers de harnais (voir tâche 18, objections 3 et 6). `clia` est la première application concrète de la convention de CLI bash (`ADR-002`, `SPEC-001`, `REQ-001`) et se code via `skl-011`.

## Contexte

Demande : tâches 17 et 18 de `session.md`. La tâche 18 a résolu les sept objections de la première version du plan. Ce qui suit intègre ces réponses.

### Modèle du système d'augmentation (tâche 18, objection 6)

Le système DeepTech d'augmentation par IA comporte trois composants distincts :

- **conception** : FND, ANL, ADR, SPEC, REQ, BUG (documents vivants ou point fixe) ;
- **harness-files** : `CLAUDE.md`, `CONSTITUTION.md`, skills (`skl-*`) ;
- **clia** : le CLI déterministe.

Le harnais est une **implémentation** des documents de conception ; l'ADR (et les autres documents de conception) ne fait donc **pas** partie du harnais. Cette précision corrige `ADR-005`.

### Cycle de vie d'une session (tâche 18, objections 1, 2, 5)

Une seule session peut être active à la fois (invariant global). Le cycle de vie :

1. **sessions en planification** : `.dev/session-x<YZ>.md` (`YZ` sur deux chiffres) ; plusieurs permises en parallèle ;
2. **session active** : `.dev/session.md` ; une seule ;
3. **sessions terminées** : `.dev/sessions/SES-<DATE>-<HEURE_OUVERTURE>-<SLUG>.md` (point fixe daté, `ADR-004`).

À chaque transition, le fichier est **déplacé et renommé**. La date et l'heure d'ouverture sont inscrites dans l'en-tête de session à l'ouverture ; la date et l'heure de fermeture, à la fermeture.

### Jeu de commandes

```
clia [-h|--help]            aide (format court)
clia --man                  aide au format manpage
clia --version              version du domaine metier (repo)
clia --version --long       versions de tous les ensembles et ressources
clia --config               informations d'installation et de customisation

clia res ls                 liste des ressources livrables
clia res ls --version       liste + version courante
clia res ls PREFIX [--version] [--long]   instances d'une ressource : ID | STATE | VERSION

clia ses status             session ouverte ou non, nombre d'archives
clia ses check              verifie que session.md respecte le format markdown-clia-session
clia ses plan [x<SEQ>]      cree un squelette de session en planification .dev/session-x<YZ>.md
clia ses open [x<SEQ>]      ouvre une session (erreur si une session est deja ouverte)
clia ses close              archive la session en cours
clia ses new [x<SEQ>]       ferme la session en cours si elle existe, puis en ouvre une
```

Sémantique tranchée en tâche 18 :

- `clia ses plan` : crée un squelette de session en planification `.dev/session-x<YZ>.md` à partir du template. `YZ` est un numéro séquentiel incrémenté de +1 à partir de la session en planification la plus élevée.
- `clia ses open x01` : promeut la session en planification `.dev/session-x01.md` en `.dev/session.md` (au lieu de partir du template). Sans argument, part du template. Inscrit la date et l'heure d'ouverture dans l'en-tête.
- `clia ses close` : inscrit la date et l'heure de fermeture, puis déplace/renomme vers `.dev/sessions/SES-<DATE>-<HEURE_OUVERTURE>-<SLUG>.md`.
- `clia ses new [x<SEQ>]` : `close` (si session active) puis `open [x<SEQ>]`.

Conventions :

- **Langue** : les noms de commandes, sous-commandes et options sont en anglais ; l'aide et les messages sont en français.
- **Alias court/long** : `res`/`resource`, `ses`/`session`.

### Rôle de `clia` vis-à-vis des fichiers en édition humaine (tâche 18, objection 3)

`session.md`, `.dev/session-x*.md` et `.dev/sessions/*` portent le domaine et relèvent de l'humain. `clia` est l'outil **déterministe** qui prend en charge leurs transitions d'état pour garantir l'intégrité du système d'information. L'**agent IA n'invoque jamais** `clia ses plan/open/close/new` et n'édite jamais ces fichiers ; seul l'humain opère `clia`. Ce rôle doit être documenté dans `CONSTITUTION.md`.

### Versionnage (tâche 18, objection 4)

Le contenu **métier** du dépôt est indépendant du harnais et de `clia` : chacun a sa propre version, incrémentée indépendamment.

- `version.yaml` (racine) : version du **domaine métier** (repo). C'est ce que renvoie `clia --version`.
- `.dev/ressources.yaml` : versions des ensembles vivants du système d'augmentation (conception, harness-files, et `clia`) et de leurs membres. C'est la source de `clia --version --long`.

Modifier le harnais ou `clia` n'incrémente pas la version métier, et inversement.

### Arborescence et activation (tâche 18, objection 7)

- Supprimer l'`activate` existant et le répertoire `scripts/` (infra de présentation, non retenue).
- Fournir `setup.sh` à la racine et une arborescence `src/{bin,lib,...}` selon les conventions de filesystem Linux (`bin` exécutables, `lib` fonctions partagées, etc.).
- `. setup.sh activate` configure l'environnement in-repo sans modifier de fichier (ajout de `src/bin` au PATH).

## Spécification du livrable

À produire après approbation :

1. **Correction `ADR-005`** (`skl-006`) : préciser que l'ADR et les autres documents de conception ne font pas partie du harnais ; le harnais est une implémentation de la conception. Bump de version.
2. **ADR-007** - `.dev/adr/ADR-007-architecture-systeme-augmentation.md` (`skl-006`) : les trois composants du système (conception, harness-files, clia), leurs frontières, et le rôle déterministe de `clia`.
3. **ADR-006** - `.dev/adr/ADR-006-gestion-des-sessions.md` (`skl-006`) : cycle de vie d'une session (planification `x<YZ>` / active / archivée), invariant de session active unique, transitions (déplacement + renommage), horodatage ouverture/fermeture, nommage des archives.
4. **SPEC-003** - `.dev/specs/SPEC-003-format-markdown-clia-session.md` (`skl-009`) : le format `markdown-clia-session` (Intention / Contexte / Tâches ; règles vérifiables par `clia ses check`) et le template.
5. **REQ-002** - `.dev/requis/REQ-002-cli-clia.md` (`skl-010`) : exigences fonctionnelles et non fonctionnelles de `clia` (dont conformité à `REQ-001`).
6. **SPEC-002** - `.dev/specs/SPEC-002-cli-clia.md` (`skl-009`) : interface complète (chaque commande, options, sorties stdout/stderr, codes de retour, alias court/long).
7. **Code `clia`** (`skl-011`) : arborescence `src/{bin,lib,...}` + `setup.sh` (`. setup.sh activate`). Conforme à `ADR-002`/`SPEC-001`/`REQ-001`. Suppression d'`activate` et `scripts/`.
8. **Template de session** : `.dev/templates/session.template.md`, réutilisé par `clia ses plan/open/new`.
9. **`version.yaml`** (racine) : version du domaine métier ; mise à jour de `.dev/ressources.yaml` pour intégrer `clia` comme ensemble vivant et documenter la séparation des domaines de version.
10. **Amendements du harnais** (`skl-004`) : dans `CLAUDE.md`, convention de langue (code en anglais, doc en français), nommage `SES-<DATE>-<HEURE>-<SLUG>`, emplacement du template, séparation des versions ; dans `CONSTITUTION.md`, le rôle déterministe de `clia`.

## Plan proposé

### 1. ADR : cadre décisionnel
Corriger `ADR-005` (scope du harnais) ; produire `ADR-007` (architecture des trois composants et rôle de `clia`) ; produire `ADR-006` (modèle de session).

### 2. SPEC-003 - format markdown-clia-session
Formaliser le format à partir du template ; définir les règles vérifiables (`clia ses check`).

### 3. REQ-002 - requis de clia
Exigences vérifiables, dont l'héritage de `REQ-001` (aide, version, stderr/stdout, codes, robustesse).

### 4. SPEC-002 - interface de clia
Spécifier chaque commande : entrées, sorties, codes de retour, alias, comportements d'erreur, transitions de session.

### 5. Versionnage
Créer `version.yaml` (racine) ; mettre à jour `.dev/ressources.yaml` (ajout de l'ensemble `clia`, note sur la séparation des domaines de version).

### 6. Coder clia + setup.sh
Implémenter selon `skl-011` et le squelette de `SPEC-001` ; arborescence `src/{bin,lib,...}` ; activation par `. setup.sh activate` ; supprimer `activate` et `scripts/`.

### 7. Template de session et amendements de harnais
Créer `.dev/templates/session.template.md` ; amender `CLAUDE.md` et `CONSTITUTION.md`.

### 8. Cohérence croisée et vérification
Dérouler `REQ-002` sur le code ; vérifier avec `shellcheck` ; contrôler la non-régression et la généricité du harnais (`skl-004`).

## Décisions de premier jet (meilleures pratiques, amendables)

- **`clia res ls`** lit les types depuis la table des livrables de `CLAUDE.md` et le manifeste `.dev/ressources.yaml` ; `STATE` = statut du fichier (plan : `proposé/exécuté` ; bug : `ouvert/résolu` ; point fixe : `-`) ; `VERSION` = version du manifeste (vivant) ou date (point fixe).
- **`--man`** génère une sortie manpage à partir de l'aide ; **`--config`** affiche la racine du dépôt détectée, les chemins (`.dev/`, `logs/`, `.dev/sessions/`, `src/`) et le fichier de config s'il existe.
- **`SES` SLUG** : dérivé du titre de l'Intention de la session, ou fourni en argument (`clia ses close <slug>`).

## Objections résiduelles (non bloquantes, tranchées par défaut)

### [OBJECTION-A] Contenu exact de `clia --version` vs `--long`
`clia --version` renvoie la version métier (`version.yaml`) ; `--version --long` agrège les ensembles de `.dev/ressources.yaml` (conception, harness-files, clia). **Défaut retenu** : `--version` = version métier seule ; `--long` = tous les domaines (métier + les trois ensembles). Amendable à l'exécution si l'humain préfère que `--version` affiche aussi les versions harnais/clia en résumé.

### [OBJECTION-B] Emplacement de la version propre de `clia`
`clia` a sa propre version (objection 4). **Défaut retenu** : `clia` figure comme ensemble vivant dans `.dev/ressources.yaml`, au même titre que `harness-files` et `documents-de-conception`. Amendable si l'humain préfère une version portée dans le code (`src/lib/version`).

### [OBJECTION-C] Opportunité d'`ADR-007`
La documentation du modèle à trois composants (objection 6) est traitée par un nouvel `ADR-007` distinct de la correction d'`ADR-005`. **Défaut retenu** : deux ADR séparés (correction de scope dans `ADR-005`, architecture d'ensemble dans `ADR-007`). Amendable si l'humain préfère tout regrouper dans `ADR-005`.

## Note sur les objections humaines

Conformément à la gouvernance, les objections de l'humain sur ce plan sont consignées dans `.dev/session.md` (tâches 17 et 18), pas ici.
