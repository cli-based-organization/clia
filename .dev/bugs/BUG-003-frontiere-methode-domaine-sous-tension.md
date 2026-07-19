# BUG-003 - Fondations de contenu business rapatriées : frontière méthode/domaine sous tension (écart à PDC-003)

- **Statut** : diagnostiqué
- **Version** : 0.1.0
- **Date de rapport** : 2026-07-18
- **Origine** : session.md tâche 21 (généré depuis `ANL-2026-07-18-principes-de-conception-du-repo`, P3)
- **Tâche liée** : `logs/ia-output/LOG-2026-07-17-task-21.md`

## Rapport

Symptôme : des fondations de contenu **business** (CryptoSecOps) ont été rapatriées dans `.dev/fondations/` (tâches 16-17 : `FND-2026-06-19-intention-affaire-et-succes-entrepreneurial`, `FND-2026-06-24-prise-de-decision-et-influence`).
Attendu (PDC-003) : le harnais est générique, sans information de domaine ; toute ressource de contenu spécifique importée est signalée comme non générique.
Observé : les fondations sont bien signalées (ligne Provenance, « savoir importé »), mais leur présence dans le corpus de fondations met la frontière méthode/domaine sous tension si elles étaient traitées comme des ressources génériques du harnais.
Contexte : rapatriement demandé explicitement par l'humain (tâches 16-17), avec objection non bloquante consignée dans les logs.

## Diagnostic

Principe concerné : `PDC-003` (« séparation méthode/domaine et généricité du harnais »).
Cause immédiate : import volontaire de savoir de domaine dans un dépôt dont le harnais se veut générique.
Cause systémique : absence d'une distinction matérielle nette entre ressources de méthode (génériques) et savoir de domaine importé. Les fondations importées sont signalées mais cohabitent avec les fondations génériques sans séparation d'emplacement ou de statut formel.
Nuance : les fichiers de harnais eux-mêmes (`CLAUDE.md`, `CONSTITUTION.md`, skills, `clia`) restent génériques ; l'écart porte sur le corpus de fondations, non sur le harnais au sens strict. C'est donc une **tension** plus qu'une violation du harnais.

## Solution appliquée

Correctif non encore appliqué. Pistes de correctif (à trancher par l'humain) : (a) distinguer matériellement les fondations importées de domaine (emplacement ou statut dédié) des fondations génériques ; (b) préciser dans `PDC-003` / `ADR-005` que les fondations importées de domaine sont hors du périmètre de généricité ; (c) accepter la cohabitation en s'appuyant sur la ligne Provenance comme garde-fou suffisant.

## Vérification

Le bogue sera résolu quand la frontière sera explicite : soit séparation matérielle des ressources importées de domaine, soit règle documentée les excluant du périmètre de généricité, sans ambiguïté sur leur statut.

## Historique

- 2026-07-18 v0.1.0 : rapport et diagnostic (tension à PDC-003 identifiée en tâche 21).
