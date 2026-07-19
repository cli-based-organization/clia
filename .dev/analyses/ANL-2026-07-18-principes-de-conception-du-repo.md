# ANL-2026-07-18 - Principes de conception à l'œuvre dans le dépôt

- **Date** : 2026-07-18
- **Périmètre** : les principes de conception implicites et explicites du système d'augmentation de ce dépôt (`clia`), tels qu'inscrits dans `INTENTION.md` (lecture), `CLAUDE.md`, `CONSTITUTION.md`, `ADR-004`/`ADR-005`/`ADR-007`, `SPEC-001`/`REQ-001`, `SPEC-002`/`REQ-002`, et les analyses antérieures. Exclusions : contenu métier.
- **Référence** : `FND-2026-07-18-principes-de-conception-systemes-complexes` (nature d'un principe, intégrité conceptuelle).

## Objet

Identifier les principes de conception qui guident le design du système, les expliquer, préciser leur portée et leurs conséquences, et évaluer si l'implémentation actuelle les respecte. Fournir un tableau récapitulatif. Cette analyse alimente la définition du type de ressource « principe de conception » (`ADR-008`) et la future matérialisation de chaque principe en ressource dédiée.

## Périmètre et méthode

Corpus : les fichiers de harnais et de conception du dépôt. Grille, dérivée de la `FND` : pour chaque principe candidat, (1) énoncé ; (2) portée (à quoi il s'applique) ; (3) conséquences (ce qu'il impose/interdit) ; (4) source dans le dépôt ; (5) évaluation de conformité de l'implémentation actuelle (respecté / partiel / enfreint), avec justification. Un principe est retenu quand il **transcende** une décision ponctuelle et s'applique à tout le système (critère `FND` §3).

## Principes identifiés

**P1. Déterminisme du composant `clia`.** Énoncé : le CLI `clia` est 100 % déterministe (mêmes entrées, mêmes sorties, aucune improvisation). Portée : tout le code de `clia`. Conséquences : interdit toute heuristique dans `clia` ; garantit l'intégrité du système d'information. Source : `ADR-007`, `REQ-002-NF1`, `CONSTITUTION.md`. Conformité : **respecté** (clia est un script bash déterministe).

**P2. N'employer l'IA que lorsque c'est nécessaire ; automatiser le reste.** Énoncé : réserver l'IA aux tâches exigeant jugement/langage/généralisation ; tout ce qui est spécifiable et vérifiable est automatisé. Portée : la répartition des tâches humain / `clia` / agent. Conséquences : impose de déplacer vers `clia` les mécaniques déterministes. Source : intention de session, `ADR-007`, `FND-2026-07-18-capacites-modeles-ia-usage`. Conformité : **partiel** — l'agent porte encore des mécaniques déterministes (versionnage atomique, numérotation, gabarits) qui devraient être automatisées (`ANL-2026-07-18-usage-ia-projet`, C3).

**P3. Séparation méthode / domaine et généricité du harnais.** Énoncé : le harnais est générique et réutilisable, sans aucune information de domaine métier. Portée : tous les fichiers de harnais (CLAUDE, CONSTITUTION, skills) et `clia`. Conséquences : interdit toute donnée de domaine dans le harnais. Source : `ADR-005`. Conformité : **partiel** — respecté pour le harnais, mais des fondations de contenu business ont été rapatriées (tâches 15-17), signalées comme savoir importé, ce qui met sous tension la frontière si elles étaient traitées comme génériques.

**P4. L'interface de travail est des fichiers, pas la conversation.** Énoncé : la source de vérité est toujours le fichier markdown versionné ; les échanges textuels sont secondaires. Portée : toute production de l'agent. Conséquences : impose de matérialiser plans, logs, fondations, analyses en fichiers. Source : `CONSTITUTION.md`. Conformité : **respecté** (chaque tâche produit ses fichiers et son log).

**P5. Séparation des préoccupations.** Énoncé : chaque document/composant traite un aspect cohérent unique, sans mêler des préoccupations de natures différentes. Portée : tous les livrables et le harnais. Conséquences : impose de ne pas mélanger gouvernance et orchestration, spécification et implémentation, etc. Source : principe transverse (`FND-2026-06-21-ingenierie-livrables-qualite`, `FND-2026-07-18-...`), appliqué dans `ADR-005`, SPEC/REQ. Conformité : **enfreint** localement — `CONSTITUTION.md` mêle gouvernance et orchestration (`ANL-2026-07-18-critique-constitution`, `ANL-2026-07-18-corpus-constitutions...`), refactor en attente.

**P6. Source de vérité documentaire unique (anti-duplication).** Énoncé : la documentation d'un CLI provient d'une source unique, générée à la volée ; aucune duplication non synchronisée. Portée : la documentation de `clia` (et de tout CLI produit). Conséquences : impose `clia.doc.yaml` + templates ; interdit l'aide codée en dur ou extraite par plage de lignes. Source : `REQ-001-F8`, `SPEC-001`. Conformité : **partiel** — conçu et spécifié ; l'exécution complète (`PLN-011`) conditionne le respect effectif.

**P7. Découvrabilité et uniformité.** Énoncé : toute commande/sous-commande est découvrable et documentée de façon uniforme ; l'inventaire dispatché est identique à l'inventaire documenté. Portée : l'interface de `clia`. Conséquences : `clia -h` liste tout ; cohérence dispatch/doc vérifiée. Source : `REQ-001-F7/F8/F9`. Conformité : **partiel** — spécifié ; un bogue historique (`ses` absent de `-h`) a motivé la réconciliation, non entièrement exécutée.

**P8. Gouvernance objection-sociocratique (aucune exécution sous objection ouverte).** Énoncé : l'agent propose un plan et ne peut exécuter tant qu'une objection reste ouverte. Portée : tout le cycle de travail. Conséquences : impose plans, objections, breakpoints. Source : `CONSTITUTION.md`. Conformité : **respecté** (le cycle de session le suit).

**P9. Traçabilité et versionnage atomique.** Énoncé : chaque ressource vivante est versionnée ; modifier un membre bumpe atomiquement le membre et son ensemble. Portée : les ressources vivantes et leurs ensembles. Conséquences : impose la mise à jour de `.dev/ressources.yaml` à chaque changement. Source : `ADR-004`. Conformité : **respecté mais fragile** — appliqué manuellement par l'agent (donc en tension avec P2, qui voudrait l'automatiser).

**P10. Point d'entrée humain unique et autorité humaine sur l'irréversible.** Énoncé : l'humain n'a qu'un point d'entrée (`session.md`) ; les opérations irréversibles (git, mutations de session) restent à l'humain / à `clia` opéré par l'humain. Portée : la gouvernance des acteurs. Conséquences : l'agent ne fait jamais de git ni de mutation de session. Source : `CONSTITUTION.md`, `ADR-006`, `ADR-007`. Conformité : **respecté**.

## Confrontation à la référence

- Les principes identifiés relèvent bien de la catégorie « principe » de la `FND` (§3) : ils **transcendent** les décisions ponctuelles (ADR) et les exigences (REQ) et s'appliquent à tout le système.
- Plusieurs sont directement issus des propriétés de Simon et de la séparation des préoccupations (P5, P6, P9) et de l'intégrité conceptuelle de Brooks (l'ensemble vise la cohérence du système).
- L'évaluation de conformité révèle un système **globalement cohérent mais avec des écarts identifiés** (P2, P3, P5, P6, P7), déjà documentés par les analyses antérieures. Au sens de la `FND` (§4), ces écarts sont des **défauts** : chacun érode localement l'intégrité conceptuelle et justifie un traitement comme bogue (voir `ADR-003` amendé).

## Tableau récapitulatif

| # | Principe | Portée | Source | Conformité |
|---|---|---|---|---|
| P1 | Déterminisme de `clia` | code de `clia` | ADR-007, REQ-002-NF1 | respecté |
| P2 | IA seulement si nécessaire ; automatiser le reste | répartition humain/clia/agent | ADR-007, FND capacités | partiel |
| P3 | Séparation méthode/domaine, généricité du harnais | harnais + clia | ADR-005 | partiel |
| P4 | Interface = fichiers, pas conversation | production de l'agent | CONSTITUTION | respecté |
| P5 | Séparation des préoccupations | tous livrables + harnais | ADR-005, FND | enfreint (CONSTITUTION mixte) |
| P6 | Source de vérité documentaire unique | doc de clia | REQ-001-F8, SPEC-001 | partiel |
| P7 | Découvrabilité et uniformité | interface de clia | REQ-001-F7/F8/F9 | partiel |
| P8 | Gouvernance objection-sociocratique | cycle de travail | CONSTITUTION | respecté |
| P9 | Traçabilité / versionnage atomique | ressources vivantes | ADR-004 | respecté mais fragile |
| P10 | Point d'entrée unique + autorité humaine sur l'irréversible | gouvernance des acteurs | CONSTITUTION, ADR-006/007 | respecté |

## Synthèse et recommandations

**Constat central** : le dépôt est gouverné par une dizaine de principes de conception cohérents, majoritairement respectés, avec cinq écarts identifiés (P2, P3, P5, P6, P7) déjà connus des analyses antérieures. Aucun de ces principes n'était jusqu'ici matérialisé comme **ressource dédiée** : ils vivaient dispersés dans le harnais et les ADR, ce qui rend leur respect difficile à vérifier et leur violation difficile à qualifier.

Recommandations :
1. **Matérialiser chaque principe** (P1..P10) en ressource « principe de conception » dédiée (type défini par `ADR-008`), une fois le type et le skill validés. Chaque ressource portera énoncé, portée, implications et critères de conformité (`skl-014`).
2. **Traiter les écarts (P2, P3, P5, P6, P7) comme des bogues** au sens de `ADR-003` amendé : un non-respect de principe est un défaut à consigner et corriger.
3. **Prioriser P5** (séparation gouvernance/orchestration dans `CONSTITUTION.md`) : c'est l'écart le plus structurant, déjà cadré par les analyses des tâches 12 et 14, et objet d'un recadrage humain à venir.
4. **Résorber P2/P9** en automatisant les mécaniques déterministes dans `clia` (versionnage, numérotation), conformément à `ANL-2026-07-18-usage-ia-projet`.

## Portée et péremption

Couverture : les principes lisibles dans le harnais et les documents de conception au 2026-07-18 (harness-files 0.4.0). Limites : l'inventaire est celui des principes **actuellement** discernables ; d'autres pourront émerger. L'évaluation de conformité s'appuie sur les analyses antérieures, non sur une exécution/vérification exhaustive du code. Péremption : la matérialisation des principes en ressources et les refactors à venir (P5, P2) rendront cet état des lieux caduc.
