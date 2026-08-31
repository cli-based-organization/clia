---
type: bug
version: 0.1.0
title: "`clia` ignore le contexte-répertoire : tous les chemins de travail pointent vers l'arbre de l'outil"
status: diagnostiqué
date: 2026-07-31
---

# BUG-009 - `clia` ignore le contexte-répertoire : tous les chemins de travail pointent vers l'arbre de l'outil

- **Origine** : humain, `.dev/session.md` tâche 1 (session du 2026-07-31)
- **Tâche liée** : [`LOG-2026-07-31-task-01.md`](../logs/ia-output/LOG-2026-07-31-task-01.md)
- **Remédiation proposée** : [`PLN-020`](../plans/PLN-020-double-racine-contexte-repertoire.md)

## Rapport

Symptôme : quel que soit le répertoire d'où `clia` est lancé, l'outil opère sur le dépôt qui contient son propre code source, jamais sur le dépôt courant.

Attendu, lorsque `clia` s'exécute dans un dépôt équipé du système d'augmentation :

- seules la **racine de l'outil** (code, source documentaire, extension d'amorçage) et les **gabarits** se rapportent à l'arbre d'installation de l'outil ;
- tout le reste de la configuration résolue (`repo-root`, `dev-dir`, `logs-dir`, `sessions-dir`, `session-file`, `ressources`, `version-file`) se rapporte au **dépôt courant**.

Observé (reproduit le 2026-07-31 depuis un dépôt versionné tiers, vide de harnais) :

| Invocation | Comportement observé | Écart |
|---|---|---|
| `clia --config` | les huit chemins pointent vers l'arbre de l'outil, aucun ne dépend du répertoire d'appel | la configuration ignore le contexte-répertoire |
| `clia ses status` | `session active : oui (.dev/session.md)` et `sessions archivées : 3` | l'état rapporté est celui du dépôt de l'outil, pas du dépôt courant |
| `clia res ls PLN` | énumère les plans du dépôt de l'outil | l'inventaire rapporté n'est pas celui du dépôt courant |

La commande n'échoue pas et n'émet aucun diagnostic : elle rend un résultat plausible mais faux. Une commande d'inspection lancée dans un dépôt tiers renseigne sur un autre dépôt sans le signaler.

**Portée du risque**, au-delà de l'inspection : les commandes mutantes de session (`ses plan/open/close/new`), opérées par l'humain, écrivent elles aussi dans l'arbre de l'outil. Une ouverture ou une fermeture de session lancée depuis un dépôt équipé tiers agit sur le point d'entrée et les archives du dépôt de l'outil. De même, `clia release` incrémente la version métier de l'arbre de l'outil au lieu de celle du dépôt courant. Le défaut n'est donc pas seulement un défaut d'affichage : il permet la mutation d'un dépôt que l'opérateur n'a pas désigné.

Contexte d'apparition : préparation de la version 0.1.0 présentable, tâche 1 de la session du 2026-07-31, sur constat de l'écart au comportement du CLI de référence.

## Diagnostic

### Cause immédiate

`src/bin/clia:8-21` dérive **tous** les chemins d'un unique point d'ancrage, l'emplacement du script :

```
CLIA_BIN="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"
CLIA_SRC="$(dirname "$CLIA_BIN")"
REPO_ROOT="$(dirname "$CLIA_SRC")"
DEV_DIR="$REPO_ROOT/.dev"
...
```

Le répertoire courant n'est lu nulle part dans ce bloc. `REPO_ROOT` désigne l'arbre d'installation de l'outil, et les sept chemins de travail en dérivent mécaniquement.

### Cause racine : une seule variable pour deux notions distinctes

`REPO_ROOT` porte deux préoccupations que le système a depuis séparées :

1. la **racine de l'outil** : là où vivent `src/lib/*`, `src/clia.doc.yaml` et le script d'amorçage `setup.sh` invoqué comme extension. Sa résolution par `BASH_SOURCE` est correcte et doit le rester ;
2. la **racine du dépôt de travail** : le corpus documentaire sur lequel l'outil agit (`.dev/`, `version.yaml`). Sa résolution doit partir du répertoire courant.

Tant que l'outil vivait dans le dépôt qu'il opérait, les deux racines coïncidaient et une seule variable suffisait. C'est l'état dans lequel `clia` a été écrit, et rien dans le code n'a marqué la distinction lorsque l'hypothèse a cessé d'être vraie.

### Cause systémique 1 : une décision prise, appliquée à un seul chemin de code

[`ADR-010`](../adr/ADR-010-clia-setup-commandes-modes-installation.md) a rompu la coïncidence des deux racines :

- **D6** : l'outil n'est jamais copié dans un dépôt cible ; il est installé une fois, globalement ;
- **D4** : « la racine cible est distincte de la racine de l'outil [...] résolue dans l'ordre : option explicite, à défaut la racine du dépôt versionné contenant le répertoire courant, à défaut le répertoire courant. L'outil agit **toujours** sur cette cible résolue, jamais sur son propre arbre d'installation » ;
- **D9** : « l'outil, appelable depuis n'importe où, **reconnaît** l'état du répertoire où il s'exécute, et le fait **avant** d'agir », avec quatre états distingués (équipé et marqué, équipé sans marque, non équipé, hors de tout dépôt).

Ces décisions sont rédigées au sujet de « l'outil », sans restriction de commande. Leur implémentation, elle, a été confinée au **seul groupe `setup`** : la résolution de cible et la reconnaissance d'état vivent dans `setup.sh` (racine), invoqué comme extension. Le bloc de résolution de `src/bin/clia`, antérieur, n'a pas été révisé. Le dépôt possède donc deux modèles de résolution contradictoires selon la commande empruntée.

### Cause systémique 2 : une contradiction interne restée invisible dans les documents normatifs

[`REQ-002`](../requis/REQ-002-cli-clia.md) porte deux exigences incompatibles si on les lit toutes deux sans restriction de portée :

- **REQ-002-NF2** : « `clia` résout la racine du dépôt de façon robuste (via `BASH_SOURCE`), indépendamment du répertoire d'appel » ;
- **REQ-002-F15** : « `clia` résout la cible dans l'ordre : `-C`, puis racine du dépôt versionné contenant le répertoire courant, puis répertoire courant. La cible ne se confond jamais avec la racine de l'outil ».

`NF2` date de la période où les deux racines coïncidaient : elle confond « racine du script » (l'objet réel de [`REQ-001-NF3`](../requis/REQ-001-convention-cli-bash.md) et de [`SPEC-001`](../specs/SPEC-001-convention-cli-bash.md), une convention d'écriture de scripts bash) et « racine du dépôt de travail ». `F15` énonce la règle correcte mais est traçée, dans [`SPEC-002`](../specs/SPEC-002-cli-clia.md), sous le seul groupe `setup`.

`SPEC-002` reflète cette contradiction sans la signaler : la section « Comportement » (l.19) et « Contraintes et garanties » (l.119) affirment la règle héritée (« racine résolue via `BASH_SOURCE` : `clia` fonctionne depuis n'importe quel répertoire »), tandis que la section `setup` (l.84) affirme la règle correcte. Le code applique la première partout, la seconde nulle part hors `setup`.

### Cause systémique 3 : aucun cas d'usage ne couvre le travail courant dans un dépôt équipé

Les cas d'usage écrits ([`USE-001`](../usages/USE-001-rendre-l-outil-disponible-sur-son-poste.md) à `USE-005`) portent tous sur l'installation et les versions. Aucun ne décrit l'usage quotidien de `clia` par l'opérateur d'un dépôt équipé, qui est pourtant la raison d'être de l'outil. Le chemin de code défaillant n'est couvert par aucun parcours, donc par aucun test : `test/test_clia.sh` n'exécute jamais `clia` depuis un répertoire tiers.

### Écart aux principes

- [`PDC-005`](../principes/PDC-005-separation-des-preoccupations.md) (« chaque composant traite un aspect cohérent et unique ») : `REPO_ROOT` porte deux préoccupations distinctes, la localisation de l'outil et celle du corpus de travail.
- [`PDC-006`](../principes/PDC-006-source-de-verite-documentaire-unique.md) : deux règles de résolution coexistent dans les documents normatifs sans qu'aucune ne prévale.

## Composants impactés

**Responsable du défaut**

| Fichier | Élément | Rôle dans le défaut |
|---|---|---|
| `src/bin/clia:8-21` | bloc de résolution des chemins | seul point d'ancrage ; cause immédiate |
| `src/bin/clia:44-53` | `cmd_config` | rapporte les chemins fautifs sans distinguer les deux racines |

**Impactés par propagation** (consomment `REPO_ROOT` ou ses dérivés)

| Fichier | Élément | Racine attendue après correction |
|---|---|---|
| `src/lib/session.sh` | `DEV_DIR`, `SESSION_FILE`, `SESSIONS_DIR` (toutes les sous-commandes `ses`) | dépôt de travail |
| `src/lib/session.sh:104,120,135` | `TEMPLATE_FILE` | outil (à trancher, voir `PLN-020` objection 1) |
| `src/lib/resource.sh:79` | `absdir="$REPO_ROOT/$dir"` | dépôt de travail |
| `src/lib/version.sh` | `VERSION_FILE` (`--version`, `release`) | dépôt de travail |
| `src/lib/version.sh:63-71` | `RESSOURCES_FILE` | sans objet : manifeste aboli (voir [`BUG-007`](BUG-007-resource-sh-modele-abroge.md)) |
| `src/lib/setup.sh:14` | `_setup_ext() { printf '%s/setup.sh' "$REPO_ROOT"; }` | **outil** : ce module lit `REPO_ROOT` au sens « arbre de l'outil ». Toute redéfinition de la variable sans reprise de ce module fait pointer l'extension vers le dépôt de travail |

**Non impactés** (correctement ancrés sur l'outil)

- `src/bin/clia:21` (`DOC_FILE` via `CLIA_SRC`) et `src/lib/doc.sh` : la source documentaire appartient à l'outil.
- `setup.sh` (racine) : résout déjà sa cible par `-C`, puis `git rev-parse --show-toplevel`, puis `pwd`, et reconnaît les quatre états d'une cible (`_setup_target_state`). C'est le modèle de référence à reprendre.

**Documents à mettre en cohérence**

| Document | Élément |
|---|---|
| [`ADR-010`](../adr/ADR-010-clia-setup-commandes-modes-installation.md) | D4 et D9 : portée à étendre explicitement à toutes les commandes, ou décision nouvelle sur la double racine |
| [`REQ-002`](../requis/REQ-002-cli-clia.md) | `NF2` (reformulation), `F15`/`F16` (portée générale) |
| [`SPEC-002`](../specs/SPEC-002-cli-clia.md) | l.19, l.84, l.119, table `--config` (l.39), traçabilité (l.163) |
| [`REQ-001`](../requis/REQ-001-convention-cli-bash.md) / [`SPEC-001`](../specs/SPEC-001-convention-cli-bash.md) | `NF3` : préciser que `BASH_SOURCE` localise le **script**, pas le dépôt de travail |
| `src/clia.doc.yaml` | description de `--config` et, le cas échéant, d'une option globale de désignation du dépôt |
| [`ARCHITECTURE.md`](../../ARCHITECTURE.md) | cartographie du code : mention des deux racines |
| `test/test_clia.sh` | aucun scénario n'exerce `clia` depuis un répertoire tiers |
| `.dev/usages/` | aucun parcours ne couvre le travail courant dans un dépôt équipé |

## Solution appliquée

Non appliquée à ce stade. La tâche 1 de la session du 2026-07-31 demande explicitement le diagnostic et un plan de remédiation, sans implémentation.

La remédiation proposée est cadrée par [`PLN-020`](../plans/PLN-020-double-racine-contexte-repertoire.md) (statut `proposé`), qui porte deux objections ouvertes : la provenance des gabarits et le comportement attendu hors dépôt équipé. Aucune exécution n'est possible tant qu'elles ne sont pas résolues.

## Vérification

Critères de fermeture, à satisfaire après exécution de la remédiation :

1. depuis un dépôt équipé tiers, `clia --config` rapporte les chemins de travail de ce dépôt et une racine d'outil distincte ;
2. depuis ce même dépôt, `clia ses status` et `clia res ls PREFIX` rapportent l'état et l'inventaire **de ce dépôt** ;
3. depuis un dépôt non équipé ou hors de tout dépôt, les commandes qui exigent un dépôt équipé refusent avec un diagnostic d'orientation et un code de retour non nul, sans retomber silencieusement sur l'arbre de l'outil ;
4. depuis l'arbre de l'outil lui-même, qui est un dépôt équipé, le comportement antérieur est préservé (non-régression) ;
5. `clia setup init` continue de trouver son extension et de produire les mêmes résultats (non-régression de `test/test_setup.sh`) ;
6. les scénarios 1 à 5 sont couverts par `test/test_clia.sh` en bac à sable.

## Historique

- 2026-07-31 v0.1.0 : création. Bogue rapporté par l'humain (tâche 1), reproduit, diagnostiqué (cause immédiate, cause racine, trois causes systémiques), composants impactés inventoriés. Statut `diagnostiqué` ; remédiation cadrée par `PLN-020`, non exécutée.
