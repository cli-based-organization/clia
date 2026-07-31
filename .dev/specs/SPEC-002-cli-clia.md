---
type: specification
version: 0.3.0
title: "Interface du CLI `clia`"
date: 2026-07-10
---

# SPEC-002 - Interface du CLI `clia`

- **Requis couverts** : `REQ-002-cli-clia`, `REQ-001-convention-cli-bash`
- **Décisions applicables** : `ADR-002`, `ADR-006`, `ADR-007`, `SPEC-001`, `SPEC-003`

## Objet et périmètre

Spécifie l'interface complète de `clia` : commandes, options, sorties (stdout/stderr), codes de retour, alias. Hors périmètre : l'implémentation ligne à ligne (voir le code sous `src/`, produit via `skl-011`).

## Comportement

`clia` suit le squelette conforme de `SPEC-001` : shebang `#!/usr/bin/env bash`, `set -euo pipefail`, racine résolue via `BASH_SOURCE`, helpers `_info/_warn/_err` sur stderr, dispatch par `case`, `trap` de nettoyage.

Grammaire : `clia [GLOBAL_OPTIONS] COMMAND|GROUP [OPTIONS]`. Les options globales sont traitées avant le dispatch. `clia` seul avec des options globales est une commande d'information système (`--version`, `--config`, `--help`, `--man`).

Documentation : l'aide courte (`-h` à tous les niveaux) et l'aide longue (`--man`) sont générées à la volée depuis une source de vérité documentaire YAML compagnon (`clia.doc.yaml`, documentation atomique par commande et sous-commande), via `yq` (implémentation mikefarah, dépendance déclarée et vérifiée au runtime, `REQ-002-NF6`). Le dispatch valide chaque commande contre cette source (cohérence, `REQ-001-F9`).

Convention de langue : commandes, sous-commandes et options en anglais ; aide et messages en français.

Codes de sortie : `0` succès ; `2` erreur d'usage (commande inconnue, argument invalide) ; `1` erreur applicative (précondition non remplie, fichier manquant).

## Interfaces

### Options globales

| Invocation | Effet | Sortie | Code |
|---|---|---|---|
| `clia`, `clia -h`, `clia --help` | aide courte (générée depuis `clia.doc.yaml`) | stdout | 0 |
| `clia --man` | aide longue, même source documentaire | stdout | 0 |
| `clia --version` | version métier (`version.yaml`) | stdout | 0 |
| `clia --version --long` | version métier + versions des ensembles (`.dev/ressources.yaml`) | stdout | 0 |
| `clia --config` | racine détectée et chemins de travail | stdout | 0 |
| `clia --debug COMMAND` | exécute COMMAND en émettant des traces sur stderr | stdout + stderr | 0 |
| `clia --dry-run COMMAND` | affiche le plan d'exécution de COMMAND sans effet de bord | stdout | 0 |

### Groupe `res` (alias `resource`)

| Invocation | Effet | Sortie |
|---|---|---|
| `clia res ls` | liste des types de ressources connus (PREFIX, nom, emplacement) | stdout |
| `clia res ls --version` | idem + version d'ensemble courante | stdout |
| `clia res ls PREFIX` | instances du type : `ID \| STATE \| VERSION` | stdout |
| `clia res ls PREFIX --long` | idem avec colonnes détaillées | stdout |

`STATE` : statut lu dans le fichier (ex. plan `proposé/exécuté`, bug `ouvert/résolu`) ou `-` pour un point fixe. `VERSION` : version du manifeste pour un vivant, date pour un point fixe.

### Groupe `ses` (alias `session`)

| Invocation | Effet | Code succès / échec |
|---|---|---|
| `clia ses status` | session active ? nombre d'archives | 0 |
| `clia ses check` | valide `session.md` contre `SPEC-003` | 0 conforme / 1 non conforme |
| `clia ses plan [x<SEQ>]` | crée `.dev/session-x<YZ>.md` depuis le template | 0 / 1 |
| `clia ses open [x<SEQ>]` | promeut planification ou template en `session.md`, écrit `start-at` | 0 / 1 si session déjà active |
| `clia ses close [SLUG]` | écrit `end-at`, archive en `SES-<DATE>-<HEURE>-<SLUG>.md` | 0 / 1 si aucune session active |
| `clia ses new [x<SEQ>]` | `close` (si actif) puis `open [x<SEQ>]` | 0 / 1 |

Toute sous-commande inconnue d'un groupe, ou un groupe inconnu, produit un diagnostic sur stderr et sort 2. `clia -h` énumère tous les groupes (`res`, `ses`, `setup`) et commandes (`release`) ; `clia res -h` et `clia ses -h` énumèrent et décrivent toutes leurs sous-commandes ; chaque sous-commande dispose de sa propre aide (`clia ses status -h`, etc.), le tout généré depuis `clia.doc.yaml` (`REQ-001-F5/F7/F8`).

### Groupe `setup`

Ajouté en v0.3.0 (`PLN-018` étape 2.2). Couvre `REQ-002-F13` à `F19`. Décisions applicables : `ADR-010` (D3, D4, D5, D6, D8, D9), `ADR-013`, `ADR-014`.

| Invocation | Effet | Sortie | Code |
|---|---|---|---|
| `clia setup init [-C CIBLE] [NOM]` | crée le dépôt si absent, matérialise le harnais et ses actifs, écrit la marque d'installation | compte rendu (stdout) | 0 |
| `clia setup init` sur cible déjà équipée | refus, orientation vers la mise à niveau | diagnostic (stderr) | 1 |
| `clia setup init` sur emplacement non vide | refus sauf demande explicite | diagnostic (stderr) | 1 |
| `clia --dry-run setup init` | affiche ce qui serait posé, sans écrire | plan (stdout) | 0 |
| `clia setup versions` | versions disponibles, marquage de l'installée et de la plus récente | table (stdout) | 0 |
| `clia setup versions` hors dépôt équipé | énumère les disponibles, signale qu'aucune n'est installée ici | table + note (stdout) | 0 |
| `clia setup versions` sur dépôt équipé sans marque | signale un état à régulariser | table + diagnostic (stderr) | 1 |
| `clia setup <inconnue>` | sous-commande inconnue | diagnostic (stderr) | 2 |

`upgrade` et `downgrade` sont **réservées** et non implémentées à ce stade ; leur invocation sort en 2 comme toute sous-commande inconnue.

**Résolution de la cible** : option `-C CIBLE`, à défaut racine du dépôt versionné contenant le répertoire courant, à défaut répertoire courant. Jamais confondue avec la racine de l'outil (`BASH_SOURCE`).

**Reconnaissance de la cible**, préalable à toute action (`ADR-010` D9) :

| État | Détection | Traitement |
|---|---|---|
| équipé et marqué | `.dev/installation.yaml` présent et lisible | nominal |
| équipé sans marque | fichiers de harnais présents, marque absente | signalé comme à régulariser, ni refusé ni accepté en silence |
| non équipé | dépôt sans fichiers de harnais | `init` procède ; les autres orientent |
| hors de tout dépôt | aucune racine résolue | `init` avec un nom explicite procède ; les autres refusent |

**Délégation** (`ADR-010` D8, `ADR-014`) : `setup init` **n'implémente pas** la matérialisation. Il invoque le script d'amorçage déclaré comme extension, lui transmet les options globales dont il doit tenir compte (`--debug`, `--dry-run`), et **propage son code de retour tel quel**. Une extension dont la version majeure de contrat diffère n'est pas invoquée : refus explicite, code 1.

### Commande `release`

| Invocation | Effet | Sortie | Code |
|---|---|---|---|
| `clia release major` | version métier `X.Y.Z` -> `X+1.0.0` dans `version.yaml` | nouvelle version (stdout) | 0 |
| `clia release minor` | version métier -> `X.Y+1.0` | nouvelle version | 0 |
| `clia release patch` | version métier -> `X.Y.Z+1` | nouvelle version | 0 |
| `clia --dry-run release <lvl>` | affiche `ancienne -> nouvelle` sans écrire | plan (stdout) | 0 |
| `clia release` / `clia release <autre>` | argument manquant ou hors `{major,minor,patch}` | diagnostic (stderr) | 2 |

`release` cible **uniquement** la version métier (`version.yaml`, `ADR-007`) ; elle ne touche pas les versions des ressources (portées par leur frontmatter). Réécriture atomique (`tmpfile` + `mv`). Elle **n'effectue aucune opération git** : le tag ou le commit éventuel du bump relève de l'humain (l'interdiction git vise l'agent IA, pas `clia` opéré par l'humain ; voir `CONSTITUTION.md`).

### Transitions de session (détail)

- `open` sans argument part de `.dev/templates/session.template.md` ; avec `x<SEQ>`, part de `.dev/session-x<SEQ>.md` (erreur 1 si absent). Dans les deux cas, `clia` injecte le frontmatter `start-at` (ISO 8601 avec fuseau) puis écrit `.dev/session.md`. Échoue (code 1, aucun effet) si `.dev/session.md` existe déjà.
- `close` lit `start-at` de `session.md`, ajoute `end-at`, dérive `SLUG` de l'Intention (ou de l'argument), calcule `HEURE_OUVERTURE` à partir de `start-at`, déplace vers `.dev/sessions/`. Échoue (code 1) si aucune session active.
- `plan` calcule `YZ` = (numéro `x` le plus élevé parmi `.dev/session-x*.md`) + 1, sur deux chiffres, à défaut `01`.

## Contraintes et garanties

- Commandes d'inspection en lecture seule (`REQ-002-NF3`).
- Commandes mutantes : déplacement + renommage sans doublon ; échec sans effet de bord si précondition non remplie (`REQ-002-NF4`).
- Racine résolue via `BASH_SOURCE` : `clia` fonctionne depuis n'importe quel répertoire.
- Sourcé (`. setup.sh activate`) sans effet de bord d'exécution : `clia` ne lance `main` que s'il est exécuté, pas sourcé.

## Exemples

```
$ clia --version
0.1.0

$ clia ses status
session active : oui (session.md)
sessions archivées : 0

$ clia res ls PLN
PLN-004 | exécuté | -
PLN-005 | exécuté | -
PLN-006 | proposé | -

$ clia ses open
[ERR] une session est déjà active : .dev/session.md
# code 1
```

## Traçabilité

| Élément spécifié | Requis satisfait |
|---|---|
| `--help/-h`, `--man` (générés depuis `clia.doc.yaml`) | REQ-001-F1/F5/F7/F8, REQ-002-F3c |
| cohérence dispatch/documentation | REQ-001-F9 |
| grammaire `[GLOBAL_OPTIONS] COMMAND [OPTIONS]` | REQ-001-F10 |
| `--debug`, `--dry-run` | REQ-002-F3d, REQ-002-F3e |
| dépendance `yq` vérifiée au runtime | REQ-002-NF6 |
| groupe `setup` (`init`, `versions`) | REQ-002-F13, F14 |
| résolution et reconnaissance de la cible | REQ-002-F15, F16 |
| délégation à l'extension et propagation du code de retour | REQ-002-F17, F18 |
| cohérence dispatch/documentation étendue aux extensions | REQ-002-F19, REQ-001-F9 |
| `--version`, `--version --long` | REQ-002-F2, REQ-002-F3 |
| `--config` | REQ-002-F3b |
| `res ls [PREFIX]` | REQ-002-F5 |
| alias `resource`/`session` | REQ-002-F6 |
| `ses check` contre SPEC-003 | REQ-002-F7 |
| `ses status` | REQ-002-F8 |
| `ses plan/open/close/new` | REQ-002-F9 à F12 |
| dispatch, codes 0/1/2, stderr | REQ-001-F3/F4, REQ-002-NF4 |
| racine via BASH_SOURCE | REQ-002-NF2 |
