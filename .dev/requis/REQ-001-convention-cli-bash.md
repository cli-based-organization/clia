# REQ-001 - Requis d'un CLI bash conforme

- **Date** : 2026-07-10
- **Sources** : `FND-2026-07-10-conventions-cli`, `ANL-2026-07-10-etat-clis-existants`, `ADR-002-convention-cli-bash`
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
- **REQ-001-F8** (MUST) : la documentation est auto-documentée, uniforme et alimentée par une source de vérité unique. Une seule structure déclarative (table de commandes) pilote à la fois le dispatch et le rendu de l'aide à tous les niveaux ; l'aide n'est jamais extraite par plage de numéros de ligne. Le format d'aide est identique au niveau supérieur, au niveau des groupes et au niveau des sous-commandes.
  - Vérification : ajouter une commande ou une sous-commande met à jour l'aide sans édition d'une plage de lignes codée en dur ; les trois niveaux d'aide partagent le même format.

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
- REQ-001-F5/F7/F8 (aide par sous-commande, découvrabilité, uniformité et source unique) sont des exigences de cœur non négociables : elles caractérisent un CLI professionnel et robuste, et priment sur la simplicité d'un outil trivial. Elles se satisfont ensemble via la table de commandes déclarative de `SPEC-001` (une seule source pilote dispatch et aide), ce qui évite la dérive entre code et documentation.
- REQ-001-NF6 (couleur) est optionnel au premier jet ; à promouvoir si les CLI produisent de la sortie riche.
