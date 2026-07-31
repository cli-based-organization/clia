---
type: adr
version: 0.1.1
title: "Contrat d'extension de l'outil par des scripts externes"
status: Accepté
date: 2026-07-29
---

# ADR-014 - Contrat d'extension de l'outil par des scripts externes

- **Décideurs** : Jérémy Viau-Trudel (humain), agent IA
- **Sources** : [`PLN-018`](../plans/PLN-018-preparation-installation-outil-et-depot.md) étape 1.3 (reprise de l'étape 1.3 de [`PLN-016`](../plans/PLN-016-installation-cycle-de-vie-clia.md)), tâche 31 de `.dev/session.md` (objection 5 : « mettre en place un contrat strict et versionné d'interface »), résolution de l'objection 2 à la tâche 40

## Contexte

La décision D8 d'[`ADR-010`](ADR-010-clia-setup-commandes-modes-installation.md) pose que la couche 2 de l'installation ne réimplémente pas la couche 1 : elle **invoque** le script d'amorçage. Le script devient donc une **extension** de l'outil, c'est-à-dire du code exécuté par l'outil sans faire partie de son corps.

Sans contrat, cette invocation serait un appel improvisé vers un script externe : l'outil perdrait la garantie que ce qu'il appelle respecte ses conventions de sortie, de codes de retour et de documentation, et la commande ainsi exposée échapperait au contrôle de cohérence entre dispatch et documentation ([`REQ-001-F9`](../requis/REQ-001-convention-cli-bash.md)). La tâche 31 avait explicitement refusé cette voie en exigeant un contrat strict et versionné.

Le besoin est aujourd'hui **d'une seule extension**, livrée avec l'outil. Le contrat est dimensionné pour ce cas, non pour un écosystème d'extensions tierces.

## Décision (résumé)

> Un script externe peut être exposé comme commande de l'outil s'il respecte un **contrat versionné** : il est **déclaré** (jamais découvert par balayage d'un répertoire), il **déclare la version de contrat** qu'il implémente, il respecte les conventions de flux et de codes de retour du dépôt, et il **fournit sa documentation** à la source documentaire unique, sans quoi il n'est pas exposé. L'outil refuse d'invoquer une extension dont la version de contrat lui est inconnue. Le contrat couvre les extensions **livrées avec l'outil** ; les extensions tierces sont hors périmètre.

## Décisions détaillées

### D1 - Déclaration explicite, pas découverte

- **Décision** : une extension est **déclarée** dans la source documentaire unique de l'outil, qui devient aussi le registre des extensions. Aucune découverte par balayage d'un répertoire, aucune convention de nommage magique.
- **Motif** : le déterminisme ([`PDC-001`](../principes/PDC-001-determinisme-de-clia.md)) exige que l'ensemble des commandes ne dépende pas du contenu d'un répertoire au moment de l'exécution. Une découverte par balayage rendrait la surface de l'outil variable selon ce qui traîne sur le disque, et ferait échouer le contrôle de cohérence entre dispatch et documentation.
- **Conséquence** : ajouter une extension est une modification de la source documentaire, donc un geste tracé et versionné, jamais un effet de bord d'une copie de fichier.

### D2 - Une extension est un CLI conforme

- **Décision** : une extension respecte les mêmes conventions que l'outil lui-même ([`SPEC-001`](../specs/SPEC-001-convention-cli-bash.md), [`REQ-001`](../requis/REQ-001-convention-cli-bash.md)) :
  - **flux** : les diagnostics sur la sortie d'erreur, le résultat exploitable sur la sortie standard ;
  - **codes de retour** : `0` succès, `1` échec d'exécution, `2` invocation invalide, conformément à [`REQ-001-F4`](../requis/REQ-001-convention-cli-bash.md) ;
  - **aide** : l'extension accepte `-h` et `--help` et fournit sa propre aide.
- **Motif** : une extension qui n'obéit pas aux mêmes conventions produit une expérience inégale selon la commande invoquée, ce que [`PDC-007`](../principes/PDC-007-decouvrabilite-et-uniformite.md) proscrit. L'utilisateur ne doit pas avoir à savoir qu'une commande est une extension.

### D3 - Propagation transparente

- **Décision** : l'outil **transmet** à l'extension les arguments qui la concernent, et **propage** son code de retour tel quel, sans le réinterpréter. Les options globales de l'outil sont traitées avant le dispatch et ne sont pas retransmises, sauf celles dont l'extension doit tenir compte (`--debug`, `--dry-run`, [`REQ-001-F10`](../requis/REQ-001-convention-cli-bash.md)), qui lui sont passées explicitement.
- **Motif** : réinterpréter un code de retour reviendrait à masquer la cause réelle d'un échec. Ne pas transmettre `--dry-run` reviendrait à ce qu'une option globale ne soit pas globale.

### D4 - La documentation conditionne l'exposition

- **Décision** : une extension qui ne fournit pas son entrée dans la source documentaire unique (nom, description courte, description longue, usage, options) **n'est pas exposée**. Le contrôle de cohérence entre dispatch et documentation ([`REQ-001-F9`](../requis/REQ-001-convention-cli-bash.md)) traite les extensions exactement comme les commandes internes.
- **Motif** : une commande non documentée existe sans être découvrable, écart déjà consigné par [`BUG-006`](../bugs/BUG-006-decouvrabilite-uniformite-non-implementee.md). Faire de la documentation une condition d'exposition, et non une obligation morale, est le seul moyen de rendre la règle effective.

### D5 - Contrat versionné et incompatibilité

- **Décision** : le contrat porte une **version semver**. Une extension déclare la version de contrat qu'elle implémente. L'outil **refuse d'invoquer** une extension dont la version majeure diffère de la sienne, et le dit explicitement plutôt que de tenter l'appel.
- **Motif** : c'est la demande de la tâche 31 (« contrat strict et **versionné** »). Une extension appelée avec un contrat qu'elle n'implémente pas produit un échec dont la cause est invisible ; le refus préalable rend la cause lisible.
- **Règle d'évolution** : un ajout rétrocompatible au contrat incrémente la version mineure ; un changement de la forme d'invocation, des flux ou des codes de retour incrémente la version majeure.

### D6 - Garde-fous

- **Décision** :
  - **déterminisme** : une extension est soumise à la même exigence que l'outil ([`PDC-001`](../principes/PDC-001-determinisme-de-clia.md)) ; elle n'improvise pas et ne dépend pas de l'état du réseau ;
  - **frontière git** : une extension est soumise à la même frontière lecture / écriture que l'outil ([`ADR-010`](ADR-010-clia-setup-commandes-modes-installation.md), décision D5). Être une extension ne donne aucun droit supplémentaire ;
  - **emplacement** : une extension livrée avec l'outil réside dans l'arbre source de l'outil. L'outil n'invoque pas de script situé dans un dépôt cible, ce qui reviendrait à exécuter du code fourni par le contenu qu'il manipule.
- **Motif du dernier point** : c'est la seule limite qui empêche qu'équiper un dépôt ne devienne un moyen de faire exécuter du code arbitraire à l'outil de quiconque l'utilise ensuite.

### D7 - Périmètre : extensions livrées, pas extensions tierces

- **Décision** : le présent contrat couvre les extensions **livrées avec l'outil**. L'ouverture à des extensions **tierces** est hors périmètre : elle poserait des questions de confiance et d'exécution de code non maîtrisé que ce contrat ne traite pas.
- **Cas d'épreuve** : le script d'amorçage est la première et, à ce jour, la seule extension. Le contrat est délibérément dimensionné pour ce cas ; il sera éprouvé par lui avant d'être étendu.

## Conséquences

**Positives**

- Une seule implémentation de la logique d'installation, exposée par deux points d'entrée, sans duplication de comportement.
- Les extensions ne créent aucune zone d'ombre : elles sont déclarées, documentées, uniformes et soumises aux mêmes garde-fous que le reste.
- Le contrôle de cohérence entre dispatch et documentation continue de valoir pour la totalité de la surface de l'outil.

**Négatives / risques**

- Un mécanisme d'indirection de plus : lire le code d'une commande demande de savoir qu'elle est une extension et où elle réside.
- Le script d'amorçage doit fonctionner **de deux façons** : en autonome, avant que l'outil existe dans l'environnement, et comme extension invoquée. Deux points d'entrée pour un seul corps de code demandent de la discipline, et c'est le risque principal de cette décision.
- Le contrat est écrit pour un cas unique. Le généraliser plus tard à des extensions tierces exigera de le reprendre, notamment sur la confiance et l'isolement.

## Migration / porte de sortie

Aucune migration : aucune extension n'existe. Si l'ouverture à des extensions tierces devient nécessaire, un ADR ultérieur traitera la confiance, la vérification d'intégrité et l'isolement d'exécution, sujets que le présent contrat laisse entiers.

## Références

- [`PLN-018-preparation-installation-outil-et-depot`](../plans/PLN-018-preparation-installation-outil-et-depot.md) (étape 1.3)
- [`ADR-010-clia-setup-commandes-modes-installation`](ADR-010-clia-setup-commandes-modes-installation.md) (décisions D5 et D8)
- [`REQ-001-convention-cli-bash`](../requis/REQ-001-convention-cli-bash.md) (F4, F7, F8, F9, F10), [`SPEC-001-convention-cli-bash`](../specs/SPEC-001-convention-cli-bash.md)
- [`PDC-001-determinisme-de-clia`](../principes/PDC-001-determinisme-de-clia.md), [`PDC-007-decouvrabilite-et-uniformite`](../principes/PDC-007-decouvrabilite-et-uniformite.md)
- [`BUG-006-decouvrabilite-uniformite-non-implementee`](../bugs/BUG-006-decouvrabilite-uniformite-non-implementee.md)
