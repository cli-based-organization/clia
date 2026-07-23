---
type: requis
version: 0.2.0
title: "Requis d'un CLI bash conforme"
date: 2026-07-10
---

# REQ-001 - Requis d'un CLI bash conforme

- **Sources** : `FND-007-conventions-cli`, `ANL-001-etat-clis-existants`, `ADR-002-convention-cli-bash`
- **Convention de priorité** : MUST | SHOULD | MAY

## Objet et périmètre

Exigences que tout nouveau CLI bash du dépôt doit satisfaire. Hors périmètre : les scripts vendored, les scripts existants non refondus, les outils non écrits en bash.

## Exigences fonctionnelles

- **REQ-001-F1** (MUST) : le CLI accepte `--help` et `-h` et affiche un message d'usage.
  - Vérification : `outil --help` et `outil -h` impriment l'usage et sortent avec le code 0.
- **REQ-001-F2** (MUST) : le CLI accepte `--version` et affiche sa version.
  - Vérification : `outil --version` imprime une version et sort avec le code 0.
- **REQ-001-F3** (MUST) : un outil multi-fonctions expose ses opérations en sous-commandes `outil COMMANDE [options]`.
  - Vérification : chaque opération est invocable comme sous-commande ; une sous-commande inconnue produit une erreur d'usage.
- **REQ-001-F4** (MUST) : une invocation invalide (commande inconnue, argument manquant) affiche un diagnostic sur stderr et sort avec le code 2.
  - Vérification : `outil commande-bidon` écrit sur stderr et retourne 2.
- **REQ-001-F5** (MUST) : chaque sous-commande dispose de sa propre aide.
  - Vérification : `outil COMMANDE SOUS-COMMANDE --help` décrit la sous-commande.
- **REQ-001-F6** (SHOULD) : le CLI supporte les options longues GNU en plus des courtes, et `--` termine les options.
  - Vérification : les options longues fonctionnent ; `--` fait traiter la suite comme opérandes.
- **REQ-001-F7** (MUST) : le CLI est découvrable. L'aide de niveau supérieur (`outil -h`) énumère toutes les commandes et tous les groupes ; l'aide d'un groupe (`outil COMMANDE -h`) énumère toutes ses sous-commandes. Aucune commande ou sous-commande existante n'est absente de l'aide correspondante.
  - Vérification : pour chaque commande/sous-commande implémentée, elle apparaît dans l'aide du niveau qui la contient.
- **REQ-001-F8** (MUST) : la documentation est auto-documentée, uniforme et alimentée par une **source de vérité documentaire unique**. Cette source est un fichier YAML à documentation **atomique** (une entrée par commande et sous-commande : nom, description courte, description longue, usage, options). L'aide courte (`-h`) et l'aide longue (`--man`) sont **générées à la volée** depuis cette source via deux templates (court, long) ; l'aide n'est jamais extraite par plage de numéros de ligne. Le format d'aide est identique au niveau supérieur, au niveau des groupes et au niveau des sous-commandes.
  - Vérification : ajouter une entrée dans la source YAML met à jour l'aide courte et longue sans autre édition ; les trois niveaux d'aide partagent le même format.
- **REQ-001-F9** (MUST) : cohérence dispatch / documentation. L'inventaire des commandes et sous-commandes réellement dispatchées est identique à l'inventaire documenté dans la source de vérité : aucune commande implémentée n'est absente de la documentation, ni l'inverse.
  - Vérification : un contrôle de cohérence (dispatch dérivé de la source, ou auto-test comparant les deux inventaires) est fourni et passe ; ajouter une commande non documentée, ou documenter une commande non implémentée, fait échouer ce contrôle.
- **REQ-001-F10** (SHOULD) : le CLI suit la grammaire `outil [GLOBAL_OPTIONS] COMMAND|GROUP [OPTIONS]`. Les options globales s'appliquent à toute commande et sont traitées avant le dispatch ; les options propres à une commande ou un groupe ne s'appliquent qu'à elle. Les options globales standard reconnues incluent `--debug` (émet des informations de débogage sur stderr) et `--dry-run` (affiche le plan d'exécution de la commande sans produire d'effet de bord).
  - Vérification : `outil --debug COMMANDE` émet des traces sans changer le résultat ; `outil --dry-run COMMANDE` n'a aucun effet de bord.

## Exigences non fonctionnelles

- **REQ-001-NF1** (MUST) : le script commence par `#!/usr/bin/env bash` et `set -euo pipefail`.
  - Vérification : lecture de l'en-tête ; un échec en milieu de pipeline fait échouer le script.
- **REQ-001-NF2** (MUST) : les diagnostics (info, avertissements, erreurs) vont sur stderr ; stdout ne porte que les données exploitables.
  - Vérification : `outil ... 1>/dev/null` laisse voir les diagnostics ; `2>/dev/null` laisse voir les données.
- **REQ-001-NF3** (MUST) : les variables sont quotées et la racine du script est résolue de façon robuste (via `BASH_SOURCE`).
  - Vérification : le script fonctionne appelé depuis un autre répertoire et avec des chemins contenant des espaces.
- **REQ-001-NF4** (MUST) : le code de sortie est 0 en cas de succès, non nul et documenté sinon.
  - Vérification : succès -> 0 ; erreur d'usage -> 2 ; erreur applicative -> 1 ou code documenté.
- **REQ-001-NF5** (SHOULD) : un `trap` assure le nettoyage des ressources temporaires et/ou signale une terminaison anormale.
  - Vérification : une interruption libère les fichiers temporaires.
- **REQ-001-NF6** (MAY) : la sortie couleur respecte `NO_COLOR` et n'est pas émise si stdout n'est pas un terminal.
  - Vérification : `NO_COLOR=1 outil ...` ne produit pas de codes couleur.

## Tensions et dépendances

- REQ-001-NF1 (`set -e`) impose de gérer explicitement les commandes dont l'échec est attendu (sinon arrêt prématuré).
- REQ-001-F1/F2 (aide/version) dépendent du dispatch d'options ; les traiter avant toute autre logique.
- REQ-001-F5/F7/F8/F9 (aide par sous-commande, découvrabilité, uniformité et source unique, cohérence dispatch/doc) sont des exigences de cœur non négociables : elles caractérisent un CLI professionnel et robuste, et priment sur la simplicité d'un outil trivial. Elles se satisfont ensemble via la source de vérité documentaire YAML de `SPEC-001` (générée à la volée par templates), ce qui évite la dérive entre code et documentation. Le parsing de cette source suppose un lecteur YAML déclaré comme dépendance (`yq`, implémentation mikefarah).
- REQ-001-NF6 (couleur) est optionnel au premier jet ; à promouvoir si les CLI produisent de la sortie riche.
