---
type: bug
version: 0.1.0
title: "`clia setup` absent de l'aide et du dispatch (écart conception / implémentation)"
status: résolu
date: 2026-07-29
---

# BUG-008 - `clia setup` absent de l'aide et du dispatch

- **Origine** : `.dev/session.md` tâche 45 (« pourquoi `clia setup CMD` n'est pas documenté ? Corriger ce bogue »)
- **Tâche liée** : [`LOG-2026-07-17-task-45.md`](../logs/ia-output/LOG-2026-07-17-task-45.md)

## Rapport

**Symptôme** : `clia -h` n'énumérait pas le groupe `setup`, `clia setup -h` n'existait pas, et `clia setup init` retournait « commande inconnue » en code 2.

**Attendu** : le groupe `setup` est spécifié par [`ADR-010`](../adr/ADR-010-clia-setup-commandes-modes-installation.md) v0.3.0 (décision D3), exigé par [`REQ-002-F13`](../requis/REQ-002-cli-clia.md) et `F14`, et décrit par [`SPEC-002`](../specs/SPEC-002-cli-clia.md). L'aide de niveau supérieur doit énumérer tous les groupes et l'aide d'un groupe toutes ses sous-commandes ([`REQ-001-F7`](../requis/REQ-001-convention-cli-bash.md), [`PDC-007`](../principes/PDC-007-decouvrabilite-et-uniformite.md)).

**Observé** : `clia -h` listait `res`, `ses` et `release`. Aucune trace de `setup` dans `src/clia.doc.yaml` ni dans le dispatch de `src/bin/clia`.

**Contexte d'apparition** : la surface a été gravée aux tâches 42 et 43 (conception), l'implémentation s'est arrêtée au BREAKPOINT 1 de [`PLN-019`](../plans/PLN-019-implementation-installation-outil-et-depot.md), qui ne couvrait que la couche 1.

## Diagnostic

**Cause immédiate** : le groupe n'était pas implémenté. L'aide de `clia` étant **générée** depuis `src/clia.doc.yaml`, une commande absente de cette source est nécessairement absente de l'aide. Le mécanisme documentaire n'était donc pas en défaut ; il rapportait fidèlement l'état du code.

**Ce que le bogue n'est pas** : ce n'est pas une violation de la cohérence dispatch / documentation ([`REQ-001-F9`](../requis/REQ-001-convention-cli-bash.md)). Cette exigence demande que l'inventaire dispatché et l'inventaire documenté soient identiques ; ils l'étaient, `setup` n'étant ni l'un ni l'autre. Le contrôle `_doc_selfcheck` passait avant comme après.

**Cause racine** : un écart entre la couche conception et la couche implémentation. [`ADR-007`](../adr/ADR-007-architecture-systeme-augmentation.md) déclare cet écart attendu et acceptable : « un CLI peut être temporairement non conforme à une conception qui vient d'évoluer ». La conception avait avancé de trois ADR, deux exigences et deux spécifications ; le code était resté au segment 1.

**Cause systémique** : rien ne rend cet écart **visible depuis l'outil**. Un utilisateur qui lit `SPEC-002` ou le `README.md` y trouve `clia setup init` ; l'outil lui répond « commande inconnue » sans indiquer que la commande est spécifiée mais non encore livrée. La règle d'`ADR-007` protège le processus de conception, mais elle laisse l'utilisateur devant un silence. C'est ce silence qui a été perçu comme un bogue, et c'est une observation juste : une conception invisible depuis l'outil est indistinguable d'une conception absente.

## Solution appliquée

Le groupe est implémenté, ce qui le documente par construction. Fichiers modifiés :

- **`src/lib/setup.sh`** (créé) : `cmd_setup`, `cmd_setup_init`, `cmd_setup_versions`. Ce module **n'implémente aucune logique d'installation** : il vérifie la compatibilité de contrat de l'extension, transmet les options globales pertinentes et propage le code de retour tel quel ([`ADR-010`](../adr/ADR-010-clia-setup-commandes-modes-installation.md) D8, [`ADR-014`](../adr/ADR-014-contrat-extension-outil.md) D3 et D5).
- **`setup.sh`** : sous-commandes `init` et `versions`, reconnaissance des quatre états d'une cible ([`ADR-010`](../adr/ADR-010-clia-setup-commandes-modes-installation.md) D9), matérialisation du paquet par zones et champ `type`, création du dépôt versionné, écriture de la marque d'installation ([`ADR-013`](../adr/ADR-013-version-augmentation-et-marque-installation.md) D3), énumération des versions publiées.
- **`src/clia.doc.yaml`** : entrée `setup` avec ses deux sous-commandes, leurs usages et leurs descriptions longues.
- **`src/bin/clia`** : chargement du module et branche de dispatch.
- **`test/test_setup.sh`** : douze scénarios de plus, couvrant `USE-002` et `USE-003`.
- **`test/test_clia.sh`** : le contrôle de cohérence chargeait tous les modules de commandes sauf le nouveau ; il le charge désormais, sans quoi il aurait signalé à tort trois handlers manquants.
- **`README.md`** : la section d'initialisation d'un dépôt cesse d'annoncer une commande indisponible.

## Vérification

Reproductible sur le dépôt :

- `clia -h` énumère `setup` ; `clia setup -h` énumère `init` et `versions` ; `clia setup init -h` affiche sa propre aide ; une sous-commande inconnue sort en code 2.
- `test/test_clia.sh` : 8 assertions, dont le contrôle de cohérence dispatch / documentation, qui vérifie l'existence de `cmd_setup`, `cmd_setup_init` et `cmd_setup_versions`.
- `test/test_setup.sh` : 59 assertions, dont la non-distribution de l'outil dans une cible équipée, l'écriture de la marque d'installation, le refus sur cible déjà équipée ou emplacement non vide, et la lecture seule de `versions`.
- Les deux suites passent sans échec.

## Historique

- 2026-07-29 v0.1.0 : rapport, diagnostic et correction (tâche 45). Statut `résolu` : le correctif est appliqué et vérifié. La cause systémique, elle, n'est pas traitée (voir ci-dessous) ; elle est laissée à l'appréciation de l'humain.

## Reste ouvert

La cause systémique subsiste : rien, dans l'outil, ne distingue une commande **jamais conçue** d'une commande **conçue mais pas encore livrée**. Les sous-commandes `upgrade` et `downgrade` sont dans ce cas dès aujourd'hui : elles sont décidées par [`ADR-010`](../adr/ADR-010-clia-setup-commandes-modes-installation.md) et réservées par [`SPEC-002`](../specs/SPEC-002-cli-clia.md), et l'outil répondra « sous-commande inconnue » à qui les invoque. Le même symptôme se reproduira donc. Traiter la cause supposerait de décider comment l'outil annonce une capacité spécifiée et non livrée, ce qui dépasse la portée de ce bogue.
