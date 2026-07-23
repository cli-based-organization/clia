---
type: plan
version: 0.1.0
title: "Installation et cycle de vie de `clia` : plan combiné (remplace PLN-012 et PLN-013)"
status: objection
---

# PLN-016 - Installation et cycle de vie de `clia` : plan combiné (remplace PLN-012 et PLN-013)

## Changelog

- **Révision 2 (2026-07-21, tâche 30)** : `PLN-014` (refonte des ressources) et `PLN-015` (`clia release`) sont désormais **exécutés**. Conséquences pour ce plan : le modèle de ressources est **stabilisé** (versions en frontmatter, plus de manifeste, zones `.dev`) ; l'**objection 1** (dépendance à l'exécution de `PLN-014`) est **résolue** ; le moteur de matérialisation/réconciliation se conçoit désormais directement sur le modèle frontmatter ; `clia release` fournit déjà la gestion de la version métier. Restent ouvertes les objections 2 à 6 (surface de commandes, modes d'installation, rollback, source de distribution, scripts externes). Statut maintenu à **objection** (ces cinq objections bloquent encore).
- **Révision 1 (2026-07-21, tâche 29)** : création (combine et remplace `PLN-012` et `PLN-013`).

## Intention

Réévaluer, à la lumière des travaux de conception réalisés depuis (tâches 12 à 28), ce qui reste pertinent dans `PLN-012` (init / update / rollback) et `PLN-013` (conception `clia setup` init / upgrade / downgrade), et proposer **un plan unique combinant les deux** (tâche 29 de `session.md`). L'objectif final reste inchangé : livrer les deux fonctionnalités attendues de la session, à savoir **créer et initialiser un nouveau repo** avec le système d'augmentation `clia`, et **mettre à niveau / revenir en arrière** sur les ressources `clia` d'un repo existant. La nouveauté est que ces livrables doivent désormais être conçus **sur le nouveau modèle de ressources** décidé par `PLN-014` (approuvé), et intégrer les décisions prises depuis.

## Contexte

- **`PLN-012`** (statut objection, jamais exécuté) : squelette fonctionnel `init` / `update` / `rollback`, où `clia` agit sur un repo cible distinct de son arbre d'installation, en matérialisant / réconciliant des ressources versionnées. Son moteur de versionnage reposait sur le manifeste `.dev/ressources.yaml` et sur la comparaison de versions par ensembles.
- **`PLN-013`** (statut objection, Phase A exécutée au breakpoint) : conception seule de `clia setup` (init / upgrade / downgrade), inspirée du `setup.sh` de `ticket-driven-ai`. Phase A produite : introduction de la notion de **breakpoint** dans le harnais et `ANL-005-besoin-req-spec-ressources-livrables`. Phase B suspendue ; objections 4 (frontière `setup.sh` / `clia setup`, deux couches) et 5 (extension à des scripts externes) restées ouvertes. `PLN-013` fait autorité sur `PLN-012` pour la conception (objection 1 résolue).
- **Travaux de conception intervenus depuis, qui changent la donne** :
  - **`PLN-014` (approuvé)** refond le modèle des ressources : abolition de la distinction vivant / point fixe (une seule catégorie de ressources livrables vivantes versionnées, plus des traces immuables), **abolition de `.dev/ressources.yaml`**, **version portée par le frontmatter** de chaque ressource, zones simplifiées (tout dans `.dev`, `logs` rapatriés dans `.dev`, pas de `.knowledge`, `doc` inchangé), frontmatter `type` et références croisées en liens, renommage daté vers séquencé, **première réécriture d'`ADR-004`**.
  - **`PLN-015` (approuvé)** ajoute `clia release (major|minor|patch)` (bump de `version.yaml` métier), et clarifie que l'interdiction git vise **l'agent IA**, pas `clia` (déterministe, opéré par l'humain) : `clia` peut donc légitimement faire du git.
  - Nouveaux invariants et cartographie : `PDC-001` à `PDC-010`, `ARCHITECTURE.md`, `ADR-008`/`ADR-009`.
  - **Directives humaines** (`session.md`, recadrages) : « nous étendons les modes d'installation supportés » et « ajouter un ADR décrivant les commandes d'installations ».
- **Contraintes de gouvernance** : ordre séquentiel recherche -> conception -> méthodologie -> implémentation (`ADR-007`, tâche 2) ; harnais générique sans information de domaine (`ADR-005`) ; frontière méthode / domaine et fichiers en édition humaine uniquement (`CONSTITUTION.md`) ; `clia` déterministe (`REQ-002-NF1`, `PDC-001`).

## Réévaluation de la pertinence

| Élément d'origine | Verdict | Motif |
|---|---|---|
| PLN-012 : `clia` agit sur un repo cible distinct de son arbre d'installation | **Conservé** (socle) | Prérequis inchangé des deux livrables |
| PLN-012 : init/update/rollback = matérialiser / réconcilier des ressources versionnées | **Conservé, refondé** | Le principe tient ; le mécanisme de versionnage change (voir ci-dessous) |
| PLN-012 : versionnage et comparaison via `.dev/ressources.yaml` | **Obsolète** | `PLN-014` abolit le manifeste ; les versions vivent en frontmatter |
| PLN-012 : « paquet distribuable » défini par le manifeste | **Refondé** | À redéfinir par les **zones** (`.dev` = augmentation) et le frontmatter |
| PLN-012 : frontière méthode / domaine (objection 2) | **Conservé, clarifié** | Les zones de `PLN-014` donnent une frontière nette (`.dev` vs `.` vs `doc`) |
| PLN-012 : rollback via git vs instantanés (objection 3) | **Rouvert, simplifié** | `PLN-015` clarifie que `clia` (opéré par l'humain) peut faire du git : rollback via historique git redevient viable |
| PLN-013 : notion de breakpoint (A.1) | **Fait** | Exécuté en Phase A, intégré au harnais |
| PLN-013 : ANL besoin REQ/SPEC ressources (A.2) | **Fait** | `ANL-005-besoin-req-spec-ressources-livrables` produite |
| PLN-013 : amender `ADR-004` (B.2) | **Absorbé** | Repris par la réécriture d'`ADR-004` de `PLN-014` |
| PLN-013 : ADR modèle `setup`, deux couches (B.3, objection 4) | **Conservé, priorisé** | Devient l'« ADR des commandes d'installation » demandé par l'humain |
| PLN-013 : extension à des scripts externes (B.4, objection 5) | **Conservé** | Toujours ouvert, à concevoir |
| PLN-013 : REQ/SPEC de `setup` (B.5) | **Conservé** | Selon le verdict de l'ANL |
| PLN-013 : ressource « interface CLI » (B.6) | **Conservé** | Nouveau type de ressource + skill |
| Vocabulaire init/update/rollback (012) vs setup init/upgrade/downgrade (013) | **À unifier** | Objet d'une décision (ADR des commandes d'installation) |

## Spécification du livrable

Le livrable **de la tâche 29** est ce plan combiné. Il **remplace** `PLN-012` et `PLN-013` (dont la Phase A reste acquise). L'exécution est une (ou plusieurs) tâche(s) ultérieure(s). Livrables d'exécution : un ADR des commandes et modes d'installation, l'ADR/REQ/SPEC de l'extension à des scripts externes, les REQ/SPEC des commandes d'installation, le nouveau type de ressource « interface CLI » (ADR + skill + harnais), l'amendement de `SPEC-002`/`REQ-002`, les entrées `clia.doc.yaml`, l'implémentation `clia` (résolution de cible, moteur de matérialisation/réconciliation sur le nouveau modèle, commandes, dispatch), et un harnais de test cumulatif en bac à sable.

## Plan proposé (PLN-014 et PLN-015 désormais exécutés)

### Segment 1 : Conception (avant breakpoint)

**1.1 ADR des commandes et modes d'installation** (`skl-006`, demandé par l'humain). Décider et documenter : les **deux couches** (installer l'outil `clia` pour l'utilisateur, à la `setup.sh` de `tda` ; puis gérer le système d'augmentation dans un repo cible), les **modes d'installation étendus** (par exemple dev / permanent / local, mono-repo vs outil global), la **surface de commandes** unifiée (trancher init/update/rollback vs `setup` init/upgrade/downgrade), la résolution de la **racine cible** (`-C <dir>` ou racine git du cwd) distincte de `BASH_SOURCE`, et les propriétés d'installateur robuste (idempotence, réversibilité, effets de bord bornés, atomicité, `FND-008-installateurs-packaging`). Résout les objections 4 de `PLN-013` et 1 de `PLN-012`.

**1.2 Définition du paquet distribuable sur le nouveau modèle.** Sur la base des **zones** (`.dev` = système d'augmentation, `.` = contenu de domaine, `doc` inchangé) et du **frontmatter** (`type`, `version`), définir ce qui appartient au paquet `clia` et comment comparer les versions **sans manifeste** (lecture des `version:` de frontmatter). Remplace le socle `ressources.yaml` de `PLN-012`.

**1.3 ADR + REQ/SPEC de l'extension à des scripts externes** (objection 5 de `PLN-013`) : contrat d'interface (conformité `REQ-001`), découverte des commandes, intégration à `clia.doc.yaml` et au dispatch validé (`REQ-001-F9`), garde-fous de déterminisme et de sécurité.

**1.4 Type de ressource « interface CLI »** (B.6 de `PLN-013`) : ADR actant le type, skill de production (`skl-001` comme méta-skill), adaptation du harnais.

**BREAKPOINT.** Arrêt après la conception. L'humain valide la surface de commandes, les modes d'installation, le mécanisme de rollback et le contrat d'extension avant l'implémentation.

### Segment 2 : Méthodologie et implémentation (après breakpoint)

**2.1 Méthodologie** : étendre `skl-011` au patron d'une commande agissant sur un repo cible (résolution de cible, frontière méthode/domaine, idempotence réconciliante, atomicité) ; ajuster `CLAUDE.md` si le comportement de l'agent en dépend.

**2.2 Documents de conception d'interface** : amender `SPEC-002`/`REQ-002` et produire les REQ/SPEC des commandes d'installation (selon le verdict de `ANL-005-besoin-req-spec-ressources-livrables`).

**2.3 Implémentation `clia`** : résolution de racine cible ; moteur de matérialisation / réconciliation lisant les versions en frontmatter (nouveau modèle, pas de manifeste) ; commandes d'installation (init d'abord comme squelette le plus mince, puis upgrade/downgrade) ; rollback selon le mécanisme retenu en 1.1 ; dispatch + `clia.doc.yaml` (découvrabilité, `REQ-001-F9`).

**2.4 Harnais de test cumulatif** en bac à sable isolé (répond au contexte de session « tests fragmentés ») : scénario `init` -> `upgrade` (no-op puis mise à jour) -> `downgrade` -> vérifications, plus erreurs d'usage ; jamais d'écriture hors bac à sable ; premier test du dépôt (à mutualiser avec le test de `PLN-015`).

## Objections de l'agent IA

1. **Dépendance à l'exécution de `PLN-014`. RÉSOLUE (tâche 30).** `PLN-014` est exécuté : le modèle de ressources est stabilisé (versions en frontmatter, plus de manifeste, zones `.dev`). Le moteur de matérialisation/réconciliation se conçoit et s'implémente désormais directement sur ce modèle. Conséquence pratique : la comparaison de versions lit les frontmatters (et non un manifeste), et le « paquet distribuable » se définit par les zones et le champ `type` (`.dev/resource-types.yaml`).

2. **Surface de commandes et vocabulaire à unifier.** `PLN-012` disait `init`/`update`/`rollback` ; `PLN-013` disait `setup init/upgrade/downgrade`. Sans décision, l'implémentation serait incohérente. Neutralisation : trancher dans l'ADR 1.1 (défaut proposé : un groupe `clia setup <init|upgrade|downgrade>` cohérent avec l'inspiration `tda`, à confirmer face à l'option de commandes de premier niveau).

3. **Modes d'installation étendus (sous-spécifiés).** La directive « étendre les modes d'installation » ne précise pas lesquels. Neutralisation : énumérer et trancher les modes dans l'ADR 1.1 (par exemple dev / permanent / local, mono-repo / outil global), en s'appuyant sur `ANL-002-setup-installation` et `FND-008-installateurs-packaging`.

4. **Mécanisme de rollback.** Depuis la clarification git (`PLN-015`, tâche 28), `clia` (opéré par l'humain) peut utiliser l'historique git, ce qui simplifie le rollback ; l'alternative (instantanés gérés par `clia`) reste possible. Neutralisation : trancher en 1.1 (défaut proposé : rollback via git de la cible, `clia` agissant comme outil de l'humain, avec repli sur instantané si la cible n'est pas propre).

5. **Source de distribution.** `upgrade` tire-t-il les versions de l'arbre `clia` installé localement (déterministe, hors ligne) ou d'une release distante (réseau, signatures, risques `curl | bash`) ? Neutralisation : défaut proposé, arbre local uniquement ; distribution distante hors périmètre.

6. **Extension à des scripts externes vs déterminisme et sécurité (objection 5 de `PLN-013`, toujours ouverte).** Ouvrir `clia` à du code tiers touche le déterminisme (`REQ-002-NF1`), la cohérence dispatch/documentation (`REQ-001-F9`) et la sécurité. Neutralisation : contrat d'interface strict conçu en 1.3 avant toute implémentation.

## Note sur le remplacement de PLN-012 et PLN-013

Ce plan remplace `PLN-012` et `PLN-013`. La Phase A de `PLN-013` (breakpoint, ANL) reste acquise et n'est pas refaite. Les deux plans d'origine portent une bannière de renvoi vers `PLN-016`.

## Note sur les objections humaines

Les objections de l'humain sur ce plan ne sont pas consignées ici mais dans `.dev/session.md`.
