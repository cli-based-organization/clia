---
type: requis
version: 0.3.0
title: "Requis du CLI `clia`"
date: 2026-07-10
---

# REQ-002 - Requis du CLI `clia`

- **Sources** : `PLN-006`, tâches 17 et 18 de `session.md`, `ADR-006`, `ADR-007`
- **Convention de priorité** : MUST | SHOULD | MAY

## Objet et périmètre

Exigences du CLI `clia`, outil déterministe de gestion des sessions et d'inspection des ressources livrables et de leurs versions. `clia` hérite des exigences de `REQ-001` (convention CLI bash). Hors périmètre : la logique de rédaction des contenus (relève de l'agent IA), la convention CLI générique elle-même (`REQ-001`).

## Exigences fonctionnelles

### Généralités

- **REQ-002-F1** (MUST) : `clia` hérite de toutes les exigences de `REQ-001`, y compris la découvrabilité (F7), l'uniformité et la source de vérité documentaire YAML générée à la volée (F8), la cohérence dispatch/documentation (F9) et la grammaire des options globales (F10). Son aide provient d'une source YAML compagnon (`clia.doc.yaml`).
  - Vérification : dérouler la table de `REQ-001` sur `clia` ; `clia -h` liste `res` et `ses`, `clia res -h`/`clia ses -h` décrivent leurs sous-commandes.
- **REQ-002-F2** (MUST) : `clia --version` affiche la version du domaine métier (repo) lue dans `version.yaml`.
  - Vérification : `clia --version` imprime la valeur de `version:` de `version.yaml` et sort 0.
- **REQ-002-F3** (MUST) : `clia --version --long` affiche la version métier et les versions de tous les ensembles vivants (`.dev/ressources.yaml`).
  - Vérification : la sortie liste métier + ensembles (harness-files, documents-de-conception, clia).
- **REQ-002-F3b** (SHOULD) : `clia --config` affiche la racine détectée et les chemins de travail (`.dev/`, `logs/`, `.dev/sessions/`, template).
  - Vérification : `clia --config` imprime les chemins résolus.
- **REQ-002-F3c** (MUST) : `clia --man` affiche l'aide longue (format manpage), générée depuis la même source documentaire que l'aide courte.
  - Vérification : `clia --man` produit une sortie structurée en sections, cohérente avec `clia -h`.
- **REQ-002-F3d** (MUST) : `clia` reconnaît l'option globale `--debug`, qui émet des informations de débogage sur stderr sans altérer la sortie utile.

- **REQ-002-F-release** (MUST) : `clia release (major|minor|patch)` incrémente la version métier (`version.yaml`) selon semver et affiche la nouvelle version ; `--dry-run` affiche le changement sans écrire ; un argument manquant ou invalide sort en code 2 ; l'écriture est atomique ; aucune opération git n'est effectuée (l'humain gère tout tag/commit).
  - Vérification : `clia --debug ses status` produit les mêmes données que `clia ses status`, plus des traces sur stderr.
- **REQ-002-F3e** (MUST) : `clia` reconnaît l'option globale `--dry-run`, qui affiche le plan d'exécution d'une commande sans produire d'effet de bord ; elle s'applique notamment aux commandes mutantes de session.
  - Vérification : `clia --dry-run ses open` décrit l'action sans créer, déplacer ni modifier aucun fichier.

### Ressources

- **REQ-002-F5** (MUST) : `clia res ls` liste les types de ressources livrables connus ; `clia res ls PREFIX` liste les instances d'un type sous forme `ID | STATE | VERSION`.
  - Vérification : `clia res ls PLN` liste les fichiers `PLN-*` avec identifiant, état et version.
- **REQ-002-F6** (SHOULD) : `res` accepte l'alias long `resource` ; `ses` accepte l'alias long `session`.
  - Vérification : `clia session status` équivaut à `clia ses status`.

### Sessions

- **REQ-002-F7** (MUST) : `clia ses check` vérifie que le fichier session courant respecte `SPEC-003` (format markdown-clia-session) ; retourne 0 si conforme, non nul sinon.
  - Vérification : un fichier valide -> 0 ; une section manquante -> code non nul + diagnostic stderr.
- **REQ-002-F8** (MUST) : `clia ses status` indique si une session est active et combien de sessions sont archivées.
  - Vérification : la sortie reflète la présence de `session.md` et le nombre de `SES-*` dans `.dev/sessions/`.
- **REQ-002-F9** (MUST) : `clia ses plan [x<SEQ>]` crée un squelette de session en planification `.dev/session-x<YZ>.md` à partir du template, `YZ` séquentiel (+1 sur la plus élevée).
  - Vérification : le fichier créé existe, est numéroté correctement et respecte S1/S2 de `SPEC-003`.
- **REQ-002-F10** (MUST) : `clia ses open [x<SEQ>]` promeut une session en planification (ou le template) en `.dev/session.md`, inscrit `start-at`, et **échoue avec un code non nul** si une session est déjà active.
  - Vérification : ouverture sans session active -> `session.md` créé avec `start-at` ; ouverture avec session active -> erreur, aucun écrasement.
- **REQ-002-F11** (MUST) : `clia ses close` inscrit `end-at` puis déplace et renomme `session.md` en `.dev/sessions/SES-<DATE>-<HEURE_OUVERTURE>-<SLUG>.md`.
  - Vérification : après `close`, `session.md` n'existe plus et l'archive datée existe.
- **REQ-002-F12** (SHOULD) : `clia ses new [x<SEQ>]` ferme la session active si elle existe, puis en ouvre une.
  - Vérification : `new` sur un dépôt avec session active produit une archive et une nouvelle session active.

### Installation (groupe `setup`)

Ajouté en v0.3.0 (`PLN-018` étape 2.1). Usages satisfaits : [`USE-002`](../usages/USE-002-creer-un-depot-neuf-deja-equipe.md) et [`USE-003`](../usages/USE-003-connaitre-les-versions-disponibles.md). Décisions applicables : [`ADR-010`](../adr/ADR-010-clia-setup-commandes-modes-installation.md), [`ADR-013`](../adr/ADR-013-version-augmentation-et-marque-installation.md), [`ADR-014`](../adr/ADR-014-contrat-extension-outil.md).

- **REQ-002-F13** (MUST) : `clia setup init [-C CIBLE] [NOM]` matérialise le système d'augmentation dans un dépôt cible et crée ce dépôt s'il n'existe pas. La commande **n'implémente pas** l'opération : elle **invoque** le script d'amorçage déclaré comme extension ([`ADR-010`](../adr/ADR-010-clia-setup-commandes-modes-installation.md) D8, [`REQ-003`](REQ-003-installation-et-extension.md)).
  - Vérification : l'effet produit et le code de retour sont identiques à ceux de l'invocation directe du script.
- **REQ-002-F14** (MUST) : `clia setup versions` énumère les versions disponibles du système d'augmentation et indique laquelle est installée dans la cible. Commande en **lecture seule**.
  - Vérification : deux exécutions successives sans changement d'état produisent la même sortie ; aucun fichier n'est modifié.
- **REQ-002-F15** (MUST) : `clia` **résout la cible** dans l'ordre : option explicite `-C`, puis racine du dépôt versionné contenant le répertoire courant, puis répertoire courant. La cible ne se confond jamais avec la racine de l'outil ([`ADR-010`](../adr/ADR-010-clia-setup-commandes-modes-installation.md) D4).
  - Vérification : `clia --config` depuis un sous-répertoire d'un dépôt cible rapporte la racine de ce dépôt, non celle de l'outil.
- **REQ-002-F16** (MUST) : `clia` **reconnaît l'état** de la cible avant d'agir et distingue quatre cas : équipé et marqué, équipé sans marque, non équipé, hors de tout dépôt ([`ADR-010`](../adr/ADR-010-clia-setup-commandes-modes-installation.md) D9, [`ADR-013`](../adr/ADR-013-version-augmentation-et-marque-installation.md) D5). Une commande qui exige un dépôt équipé refuse sur les deux derniers cas et **oriente** vers le parcours approprié.
  - Vérification : chacun des quatre états produit un diagnostic distinct et un code de retour conforme.
- **REQ-002-F17** (MUST) : `clia` **propage tel quel** le code de retour d'une extension, sans le réinterpréter, et lui transmet les options globales dont elle doit tenir compte ([`ADR-014`](../adr/ADR-014-contrat-extension-outil.md) D3).
- **REQ-002-F18** (MUST) : `clia` **refuse d'invoquer** une extension dont la version majeure de contrat diffère de la sienne, et le dit explicitement plutôt que de tenter l'appel ([`ADR-014`](../adr/ADR-014-contrat-extension-outil.md) D5).
- **REQ-002-F19** (MUST) : les sous-commandes du groupe `setup`, extensions comprises, sont soumises au même contrôle de cohérence dispatch et documentation que les commandes internes ([`REQ-001-F9`](REQ-001-convention-cli-bash.md)). Une extension non déclarée dans la source documentaire n'est pas exposée.
  - Vérification : `clia setup -h` énumère toutes les sous-commandes réellement dispatchées, et rien d'autre.

## Exigences non fonctionnelles

- **REQ-002-NF1** (MUST) : `clia` est **100% déterministe** (mêmes entrées, mêmes sorties ; aucune heuristique).
  - Vérification : deux exécutions identiques produisent des sorties identiques (hors horodatage courant).
- **REQ-002-NF2** (MUST) : `clia` résout la racine du dépôt de façon robuste (via `BASH_SOURCE`), indépendamment du répertoire d'appel.
  - Vérification : `clia` fonctionne appelé depuis n'importe quel sous-répertoire.
- **REQ-002-NF3** (MUST) : les commandes d'inspection (`--version`, `--config`, `res ls`, `ses status`, `ses check`) sont en **lecture seule**.
  - Vérification : aucune de ces commandes ne modifie de fichier.
- **REQ-002-NF4** (MUST) : les commandes mutantes (`ses plan/open/close/new`) déplacent et renomment sans perte ni doublon ; en cas de précondition non remplie, elles échouent sans effet de bord.
  - Vérification : un `open` refusé ne laisse aucune trace ; un `close` produit exactement une archive.
- **REQ-002-NF5** (SHOULD) : `clia` est générique et réutilisable (aucune information de domaine métier), activable par `. setup.sh activate`.
  - Vérification : `clia` ne contient aucun nom de client ni sujet ; `. setup.sh activate` ajoute `clia` au PATH.
- **REQ-002-NF6** (MUST) : `clia` dépend de `yq` (implémentation mikefarah) pour lire sa source documentaire YAML ; la dépendance est vérifiée au runtime (`command -v yq`) avec un diagnostic clair si elle est absente, et déclarée à l'installation.
  - Vérification : sans `yq`, une commande nécessitant l'aide générée échoue avec un diagnostic explicite ; avec `yq`, l'aide est produite.

## Tensions et dépendances

- REQ-002-NF3 (lecture seule) vs REQ-002-F7-F12 : séparer nettement inspection et mutation dans le dispatch.
- REQ-002-F2/F3 dépendent de la présence de `version.yaml` et `.dev/ressources.yaml` (absence gérée par un diagnostic, pas un crash).
- L'agent IA n'invoque jamais les commandes mutantes de session (`ADR-007`, `CONSTITUTION.md`) ; cette contrainte de gouvernance encadre l'usage, pas le code.
