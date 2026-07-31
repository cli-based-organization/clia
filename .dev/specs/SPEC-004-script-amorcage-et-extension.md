---
type: specification
version: 0.1.0
title: "Interface du script d'amorçage et du contrat d'extension"
date: 2026-07-29
---

# SPEC-004 - Interface du script d'amorçage et du contrat d'extension

- **Requis couverts** : [`REQ-003`](../requis/REQ-003-installation-et-extension.md), [`REQ-001`](../requis/REQ-001-convention-cli-bash.md)
- **Décisions applicables** : [`ADR-010`](../adr/ADR-010-clia-setup-commandes-modes-installation.md), [`ADR-013`](../adr/ADR-013-version-augmentation-et-marque-installation.md), [`ADR-014`](../adr/ADR-014-contrat-extension-outil.md), [`SPEC-001`](SPEC-001-convention-cli-bash.md)

## Objet et périmètre

Spécifie l'interface de `setup.sh` : invocations, sorties, codes de retour, effets sur le système de fichiers, et la forme du contrat d'extension par lequel l'outil l'invoque. Hors périmètre : l'implémentation ligne à ligne, et les opérations de mise à niveau et de retour en arrière.

## Comportement

Le script suit le squelette conforme de [`SPEC-001`](SPEC-001-convention-cli-bash.md) : `#!/usr/bin/env bash`, `set -euo pipefail`, racine résolue via `BASH_SOURCE`, diagnostics sur stderr, dispatch par `case`, nettoyage par `trap`.

Grammaire : `setup.sh [OPTIONS] COMMANDE [ARGS]`.

Codes de sortie : `0` succès ; `1` erreur applicative (précondition non remplie) ; `2` erreur d'usage (commande inconnue, argument invalide).

Convention de langue : commandes et options en anglais, messages en français.

Le script s'exécute **avant** que l'outil existe dans l'environnement : il ne dépend d'aucune fonction de l'outil et ne l'invoque jamais.

## Interfaces

### Couche 1 : disponibilité de l'outil

| Invocation | Effet | Sortie | Code |
|---|---|---|---|
| `setup.sh install` | écrit le bloc marqué dans la configuration de shell, rattachant le nom de l'outil à l'arbre source | compte rendu + rappel d'activation (stderr) | 0 |
| `setup.sh install` déjà installé, même racine | aucune écriture | constat (stderr) | 0 |
| `setup.sh install` déjà installé, racine différente | met à jour le bloc | constat du déplacement (stderr) | 0 |
| `setup.sh install` dépendance absente | aucune écriture | nom de la dépendance manquante (stderr) | 1 |
| `setup.sh install` configuration non accessible en écriture | aucune écriture | diagnostic (stderr) | 1 |
| `setup.sh --check` | rend compte de l'état, **n'écrit rien** | état et racine rattachée (stderr) | 0 installé / 1 sinon |
| `setup.sh --uninstall` | retire le bloc marqué, et rien d'autre | compte rendu (stderr) | 0 |
| `setup.sh --uninstall` non installé | aucune écriture | constat (stderr) | 0 |
| `setup.sh -h`, `--help` | usage | stdout | 0 |
| `setup.sh <inconnue>` | commande inconnue | diagnostic (stderr) | 2 |
| `. setup.sh activate` | ajoute l'arbre source au `PATH` de la session courante, sans écriture | constat (stderr) | 0 |

**Bloc marqué** : une ligne d'ouverture et une ligne de fermeture explicites encadrent le contenu écrit. Le retrait supprime tout ce qui se trouve entre elles, marqueurs compris, et rien d'autre. Une réinstallation remplace le contenu entre marqueurs sans dupliquer la paire.

**Ordre des opérations d'`install`**, non négociable : vérifier les dépendances, vérifier l'accès en écriture, écrire dans un fichier temporaire, remplacer atomiquement, rendre compte. Toute défaillance avant le remplacement laisse la configuration inchangée.

**Mode dev** : le rattachement pointe vers l'arbre source résolu par `BASH_SOURCE`. Aucune copie, aucune construction.

### Couche 2 : matérialisation dans un dépôt cible

| Invocation | Effet | Sortie | Code |
|---|---|---|---|
| `setup.sh init [-C CIBLE] [NOM]` | crée le dépôt si absent, pose le harnais et ses actifs, écrit la marque d'installation | compte rendu (stdout) | 0 |
| `setup.sh init` cible déjà équipée | refus, orientation | diagnostic (stderr) | 1 |
| `setup.sh init` emplacement non vide sans demande explicite | refus | diagnostic (stderr) | 1 |
| `setup.sh init --dry-run` | énumère ce qui serait posé | plan (stdout) | 0 |
| `setup.sh versions` | versions disponibles et version installée dans la cible | table (stdout) | 0 |

**Contenu posé** : déterminé par les zones et le champ `type` de la couche type, jamais par une liste codée en dur. Inclut les fichiers de harnais racine, le gabarit d'intention, les compétences, les gabarits, la couche type, le squelette de version du domaine, et les répertoires de ressources vides. **Exclut l'outil et sa source documentaire** ([`ADR-010`](../adr/ADR-010-clia-setup-commandes-modes-installation.md), D6).

**Marque d'installation** : `.dev/installation.yaml` dans la cible, contenant la version posée ou la mention d'un état de travail, l'identifiant de révision source, la date, le mode de pose et les empreintes. Si elle ne peut pas être déterminée, le parcours échoue **avant** toute écriture.

**Atomicité** : chaque fichier est écrit dans un temporaire puis déplacé. Un échec en cours de route est signalé avec la liste de ce qui a été posé et de ce qui ne l'a pas été ; aucun état intermédiaire n'est présenté comme un succès.

## Contrat d'extension

Version du contrat : **1.0.0**.

| Élément | Forme |
|---|---|
| Déclaration | entrée dans la source documentaire de l'outil ; aucune découverte par balayage |
| Emplacement | dans l'arbre source de l'outil ; jamais dans un dépôt cible |
| Invocation | `<script> <sous-commande> [args]`, arguments transmis tels quels |
| Options globales transmises | `--debug`, `--dry-run` |
| Version de contrat | annoncée par l'extension ; l'outil refuse si la version **majeure** diffère de la sienne |
| Flux | diagnostics sur stderr, résultat exploitable sur stdout |
| Codes de retour | `0`, `1`, `2` selon [`SPEC-001`](SPEC-001-convention-cli-bash.md), **propagés tels quels** par l'outil |
| Aide | l'extension accepte `-h` et `--help` ; son entrée documentaire conditionne son exposition |

**Garde-fous** : l'extension est soumise au même déterminisme et à la même frontière lecture / écriture pour le versionnage que l'outil. Être invoquée comme extension ne confère aucun droit supplémentaire.

## Contraintes et garanties

- `--check` et `versions` sont en lecture seule.
- `install` et `--uninstall` sont idempotents : rejouer l'un ou l'autre à l'identique n'ajoute aucun effet.
- Aucune écriture dans la configuration d'un autre utilisateur ; aucun privilège élevé requis.
- Aucune opération de versionnage hors de la création d'un dépôt à un emplacement qui n'en contient pas.
- Les scénarios de vérification s'exécutent dans un bac à sable isolé et n'écrivent jamais dans la configuration de shell réelle.

## Exemples

```
$ ./setup.sh --check
[WARN] clia n'est pas installé dans /home/u/.bashrc
# code 1

$ ./setup.sh install
[OK] bloc écrit dans /home/u/.bashrc (racine : /home/u/git/clia)
[INFO] activez avec : source ~/.bashrc

$ ./setup.sh install
[OK] déjà installé depuis la même racine, rien à faire

$ ./setup.sh --uninstall
[OK] bloc retiré de /home/u/.bashrc
```

## Traçabilité

| Élément spécifié | Requis satisfait |
|---|---|
| `install`, bloc marqué, idempotence réconciliante | REQ-003-F1, F2, F3 |
| mode dev | REQ-003-F4 |
| `--check`, `--uninstall` | REQ-003-F5, F6 |
| ordre des opérations et atomicité | REQ-003-F7, F13 |
| rappel d'activation | REQ-003-F8 |
| absence de privilèges élevés | REQ-003-F9, NF4 |
| contenu posé, exclusion de l'outil, non-altération du domaine | REQ-003-F10, F11, F12 |
| création du dépôt versionné, refus, marque | REQ-003-F14, F15, F16 |
| contrat d'extension | REQ-003-F18 à F22 |
| bac à sable des scénarios | REQ-003-NF5 |
