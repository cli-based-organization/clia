---
type: plan
version: 0.1.0
title: "Typologie des ressources livrables et versionnage atomique"
status: exécuté
---

# PLN-005 - Typologie des ressources livrables et versionnage atomique


## Changelog

- **v1 (tâche-12)** : première proposition. Typologie par cycle de vie, mécanisme de versionnage, six objections.
- **v2 (tâche-14)** : intégration des réponses aux six objections et de quatre objections humaines (ADR scope de CONSTITUTION, manifeste YAML, nommage daté des ressources point fixe, axes d'analyse multiples). Trois objections résiduelles (7, 8, 9).
- **v3 (tâche-15)** : résolution des objections 7, 8, 9. Ajout d'un principe majeur : le **harnais doit être générique et réutilisable dans tout dépôt**, sans information de domaine ni spécifique au repo. `INTENTION.md` n'est pas un fichier de harnais. Ajout de livrables : règle de généricité dans tous les skills, audit de généricité du harnais, renommage des logs à la convention du système.
- **v4 (tâche-16, exécution)** : plan exécuté. Voir « Travail effectué ».

## Intention

Formaliser une compréhension multi-axes des **ressources livrables**, un **mécanisme de versionnage atomique**, la **fonction et le scope du harnais** (y compris son principe de réutilisabilité inter-dépôts), et une **convention de nommage** cohérente. Le tout acté dans des ADR, un manifeste YAML, et des amendements de harnais, après une analyse de l'usage réel des ressources.

## Contexte

Demande : tâche 12 de `session.md`. Précisions et objections : tâches 14 et 15.

Typologie par cycle de vie (tâche 12) :
1. **Point fixe** (produit une fois, non modifié) : `FND`, `ANL`, `.dev/logs/ia-output/*`, `publications/*`.
2. **Vivant** (semver) : `ADR`, `REQ`, `SPEC`, `skl`, base de code, `BUG`.
3. **Travail** (sans version) : `PLN`.

Décisions de l'humain (tâches 14 et 15) :
- Un ADR définit la **fonction et le scope du harnais** (dont `CONSTITUTION.md`) (tâche 14, obj. 1).
- Manifeste de versions au format **YAML** : `.dev/ressources.yaml` (tâche 14, obj. 2).
- Ressources « point fixe » nommées **`<PREFIX>-<DATE[-HEURE]>-<SLUG>.<EXT>`** (sans séquence ; heure si plusieurs par jour) ; appliqué à tous les documents datés (tâche 14, obj. 3).
- L'ADR présente les **axes d'analyse multiples** des ressources, identifiés par une analyse d'usage (tâche 14, obj. 4).
- L'**ADR est un document vivant** ; trace décisionnelle préservée par historique et versionnage consistant (tâche 14, réponse agent-2).
- **Deux ensembles versionnés** : `harness-files` et `documents-de-conception` (tâche 14, réponse agent-3).
- Version initiale **`0.1.0`** (tâche 14, réponse agent-4).
- Écart d'immuabilité (logs édités tâche 7) **toléré en phase de conception** (tâche 14, réponse agent-5).
- Cas `publications/*` **documenté dans l'ADR** (tâche 14, réponse agent-6).
- Les **skills font partie du harnais** (tâche 15, obj. 7).
- `INTENTION.md` **ne fait pas partie du harnais**. Le harnais ne doit contenir **aucune information de domaine métier ni spécifique au repo**, afin d'être **réutilisable dans n'importe quel dépôt** (objectif central). À documenter dans l'ADR et à **forcer par une règle dans tous les skills**, pour toutes les ressources de harnais (tâche 15, obj. 8).
- Les **logs respectent la convention de nommage du système** et les logs déjà produits sont **corrigés** (tâche 15, obj. 9).

## Spécification du livrable

À produire après approbation :

1. **Analyse d'usage** - `.dev/analyses/ANL-<DATE>-usage-ressources-livrables.md` (`skl-012`) : inventaire des types de ressources et identification des axes d'analyse.
2. **ADR-004** - `.dev/adr/ADR-004-ressources-livrables.md` (`skl-006`) : ressource / livrable / document, axes d'analyse, typologie cycle de vie, convention de nommage datée, mécanisme de versionnage atomique, cas `publications/*`.
3. **ADR-005** - `.dev/adr/ADR-005-fonction-scope-harnais.md` (`skl-006`) : fonction et scope du harnais (`CLAUDE.md`, `CONSTITUTION.md`, skills) ; **principe de réutilisabilité** (aucune information de domaine ou spécifique au repo dans le harnais) ; place respective de `CONSTITUTION.md`, `CLAUDE.md` et des ADR ; statut de `INTENTION.md` (hors harnais).
4. **Manifeste** - `.dev/ressources.yaml` : deux ensembles (`harness-files` = `CLAUDE.md`, `CONSTITUTION.md`, `skl-*` ; `documents-de-conception` = `ADR-*`, `SPEC-*`, `REQ-*`), membres et versions à `0.1.0`. `INTENTION.md` exclu (hors harnais, édition humaine).
5. **Convention de nommage** : amendement de la nomenclature de `CLAUDE.md` : ressources point fixe datées (`<PREFIX>-<DATE[-HEURE]>-<SLUG>.<EXT>`) vs ressources vivantes/travail séquencées (`<PREFIX>-<SEQ>-<SLUG>.md`). Les logs adoptent `LOG-<DATE>-task-<NN>.md`.
6. **Règle de généricité dans les skills** : ajouter à chaque skill (et à `skl-004-harnais`, `skl-001-skill-writer`) une règle forçant qu'une ressource de harnais ne contienne aucune information de domaine ni spécifique au repo.
7. **Audit et correction de généricité du harnais** : repérer et retirer toute information de domaine dans les ressources de harnais existantes. Cas connu : l'exemple de `skl-008` cite « Commission scolaire de la Capitale-Nationale » et doit être rendu générique.
8. **Correction des ressources existantes** : renommer les ressources point fixe séquencées au format daté (`FND-007-conventions-cli` -> `FND-<DATE>-conventions-cli` ; `ANL-001-etat-clis-existants` -> `ANL-<DATE>-etat-clis-existants`) ; renommer les 12 logs existants au format `LOG-<DATE>-task-<NN>.md` ; mettre à jour toutes les références ; peupler `.dev/ressources.yaml`.
9. **Amendements du harnais** (`skl-004`) : `CLAUDE.md` (nomenclature, renvois manifeste et ADR) ; `CONSTITUTION.md` selon ce que tranche `ADR-005`.

## Axes candidats d'analyse des ressources (à confirmer par l'analyse)

- **Cycle de vie** : point fixe / vivant / travail.
- **Droits d'édition (permissions et rôles)** : humain-only / IA-only / co-édition.
- **Fonction / finalité** : gouvernance, conception, recherche, analyse, trace-audit (log), suivi de bogue, intention.
- **Appartenance au harnais** : harnais (générique, réutilisable) vs ressource propre au repo (domaine).
- **Nommage** : daté (point fixe) vs séquencé (vivant/travail).
- **Granularité / composition** : fichier individuel vs ensemble versionné.
- **Producteur** : humain / agent / co-production.

## Mécanisme de versionnage atomique

- **Catégorie 1 (point fixe)** : pas de semver. Identité = `<PREFIX>-<DATE[-HEURE]>-<SLUG>`. Modification = nouvelle instance datée.
- **Catégorie 2 (vivant)** : semver `MAJEUR.MINEUR.CORRECTIF`. MAJEUR = incompatible ; MINEUR = ajout rétrocompatible ; CORRECTIF = clarification. ADR vivant, trace préservée par historique.
- **Catégorie 3 (travail)** : pas de version ; `Changelog` du plan.
- **Deux ensembles versionnés** : `harness-files` (CLAUDE, CONSTITUTION, skills) et `documents-de-conception` (ADR, SPEC, REQ). `INTENTION.md` exclu.
- **Manifeste** `.dev/ressources.yaml` : version de chaque ensemble et de chaque membre ; toute modification d'un membre vivant bumpe atomiquement le membre et son ensemble. Piloté par fichiers, pas par tags git.

## Plan proposé

### 1. Produire l'analyse d'usage
`ANL-<DATE>-usage-ressources-livrables` : inventaire et confirmation des axes.

### 2. Rédiger ADR-005 (fonction, scope et réutilisabilité du harnais)
Définir le harnais, le principe de généricité (aucune information de domaine), la place de `CONSTITUTION.md`/`CLAUDE.md`/ADR, le statut hors-harnais de `INTENTION.md`.

### 3. Rédiger ADR-004 (ressources livrables)
Définitions, axes, typologie, nommage daté, versionnage, `publications/*`.

### 4. Créer `.dev/ressources.yaml`
Deux ensembles, membres et versions à `0.1.0`.

### 5. Généricité du harnais
Ajouter la règle de généricité dans tous les skills ; auditer et corriger les ressources de harnais (dont l'exemple de `skl-008`).

### 6. Convention de nommage et corrections
Amender la nomenclature (`CLAUDE.md`) ; renommer `FND`/`ANL` au format daté et les logs au format `LOG-<DATE>-task-<NN>` ; mettre à jour les références ; peupler le manifeste.

### 7. Amender CONSTITUTION.md selon ADR-005 et cohérence croisée
Placer dans `CONSTITUTION.md` uniquement ce que son scope justifie ; vérifier la non-contradiction et la validité des références après renommage.

## Objections de l'agent IA

Toutes les objections (agent v1 et résiduelles 7, 8, 9) sont **résolues** par les réponses de l'humain (tâches 14 et 15) :
- OBJECTION-7 (skills) : résolue, les skills font partie du harnais (ensemble `harness-files`).
- OBJECTION-8 (INTENTION.md, versionnage) : résolue, `INTENTION.md` est hors harnais et hors versionnage géré par l'agent ; principe de généricité du harnais acté.
- OBJECTION-9 (nommage des logs) : résolue, les logs suivent la convention du système et sont renommés.

Aucune objection ouverte. Le plan est prêt à exécuter.

## Travail effectué

Exécuté à la tâche 16 :

- `.dev/analyses/ANL-003-usage-ressources-livrables.md` : analyse d'usage confirmant six axes.
- `.dev/adr/ADR-005-fonction-scope-harnais.md` : fonction, scope et réutilisabilité du harnais ; `INTENTION.md` hors harnais.
- `.dev/adr/ADR-004-ressources-livrables.md` : vocabulaire, six axes, typologie cycle de vie, nommage, versionnage atomique, cas `publications/*`.
- `.dev/ressources.yaml` : manifeste YAML, deux ensembles (`harness-files`, `documents-de-conception`) et `BUG-001`, versions à `0.1.0`.
- Généricité : règle ajoutée dans les onze skills ; exemple de `skl-008` rendu générique (retrait de la mention de domaine).
- Nommage : `CLAUDE.md` amendé (nommage daté vs séquencé, renvois ADR et manifeste) ; `CONSTITUTION.md` et `skl-008` mis à jour pour le format des logs et les renvois ADR.
- Renommages : `FND-001-conventions-cli` -> `FND-007-conventions-cli` ; `ANL-001-etat-clis-existants` -> `ANL-001-etat-clis-existants` ; 14 logs -> `LOG-2026-07-09-task-NN.md` ; toutes les références mises à jour (aucune résiduelle).

Décision de nommage (heure) : les ressources datées produites le même jour sont distinguées par leur slug ; l'heure n'est ajoutée qu'en cas de collision date + slug. Choix documenté dans `ADR-004` (amendable).

## Note sur les objections humaines

Conformément à la gouvernance, les objections de l'humain sur ce plan ne sont pas consignées ici mais dans `.dev/session.md`.
