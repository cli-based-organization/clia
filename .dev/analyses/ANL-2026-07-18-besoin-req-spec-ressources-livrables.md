# ANL-2026-07-18 - Besoin de REQ/SPEC pour les ressources livrables

- **Date** : 2026-07-18
- **Périmètre** : le système des ressources livrables de ce dépôt : `ADR-004`, les skills producteurs (`.dev/skills/skl-*`), la table des livrables de `CLAUDE.md`, `.dev/ressources.yaml`, les `SPEC`/`REQ` existants, et le mécanisme de lecture de `clia` (`src/lib/resource.sh`). Exclusions : contenu métier, `.git/`.
- **Référence** : `ADR-004-ressources-livrables` (état courant et amendement prévu en `PLN-013` B.2) ; modèle `SPEC-003` + `clia ses check` comme précédent de format documentaire validé.

## Objet

Déterminer si les **ressources livrables** requièrent des `REQ` et/ou des `SPEC` propres, au-delà de ce que couvrent déjà `ADR-004` et les skills producteurs. Cette analyse est le dernier livrable de la Phase A de `PLN-013` avant le **breakpoint** : elle alimente la décision de l'humain sur la suite de la conception (Phase B). Elle recommande, elle ne tranche pas.

## Périmètre et méthode

Corpus parcouru : `.dev/adr/ADR-004`, `.dev/skills/skl-*/SKILL.md` (11 skills), `CLAUDE.md` (table des livrables et nomenclature), `.dev/ressources.yaml`, `.dev/specs/SPEC-*`, `.dev/requis/REQ-*`, `.dev/templates/session.template.md`, `src/lib/resource.sh` et `src/lib/session.sh`.

Grille d'analyse (cinq dimensions, appliquées à chaque type de ressource) :

1. **Source de vérité** : qu'est-ce qui définit ce qu'est une instance valide de ce type ?
2. **Format** : forme matérielle (markdown, YAML, bash, autre).
3. **Template** : existe-t-il un patron de production, et où vit-il ?
4. **Validation** : existe-t-il un moyen de vérifier la conformité d'une instance, et est-il automatisable ?
5. **REQ/SPEC** : ce type dispose-t-il aujourd'hui d'exigences (`REQ`) ou d'une spécification d'interface (`SPEC`) formelles ?

## Inventaire

Types de ressources livrables et leur skill producteur (source : table des livrables de `CLAUDE.md`) :

- Plan (`PLN`) → `skl-003` ; Fondation (`FND`) → `skl-002` ; Analyse (`ANL`) → `skl-012` ; ADR (`ADR`) → `skl-006` ; Spécification (`SPEC`) → `skl-009` ; Requis (`REQ`) → `skl-010` ; Rapport de bogue (`BUG`) → `skl-013` ; Log (`LOG`) → `skl-008` ; Skill (`skl`) → `skl-001` ; Harnais (`CLAUDE.md`, `CONSTITUTION.md`) → `skl-004` ; script CLI bash → `skl-011`.
- Ressources support non couvertes par un skill dédié : `.dev/ressources.yaml` (manifeste YAML), `version.yaml` (version métier), `.dev/templates/session.template.md` (template), les fichiers de session (`session.md`, format spécifié par `SPEC-003`).

Bruit exclu : contenu métier, `.git/`, artefacts temporaires.

## Constats

**C1. Les skills tiennent déjà lieu de spécification/exigence vivante par type.** `CLAUDE.md` l'affirme explicitement : « Chaque type de livrable a un skill associé qui encadre sa production : une spécification/exigence vivante à consulter avant de produire ou modifier ce type de livrable. » Chaque `SKILL.md` porte une section « Structure du livrable » (template inline), des « Critères de qualité » (exigences de conformité) et un emplacement normé. La fonction « source de vérité + template + exigences » est donc **déjà remplie**, par type, au niveau des skills.

**C2. `ADR-004` couvre le concept transverse, pas la validation ni le format par type.** `ADR-004` définit ce qu'est une ressource, ses six axes, le cycle de vie, le nommage et le versionnage atomique. Il ne traite pas la **source de vérité documentaire**, le **format variable** par type, le **template** comme artefact, ni la **validation** ; ces axes sont précisément ceux que `PLN-013` B.2 prévoit d'y intégrer par amendement (décision de la tâche 10).

**C3. La validation automatisée n'existe que pour un seul format.** `SPEC-003` spécifie le format `markdown-clia-session` et `clia ses check` le valide par machine (`REQ-002-F7`). C'est le **seul** couple format formel + validateur. Aucun autre type de ressource ne dispose d'une validation automatisable : la conformité repose sur les « Critères de qualité » du skill, évalués par jugement (agent/humain).

**C4. `clia` dépend d'un format implicite non spécifié pour les ressources vivantes.** `src/lib/resource.sh` extrait l'état et la version des ressources vivantes en cherchant des lignes `^[-* ]*statut[* ]*:` et `^[-* ]*version[* ]*:` (`_res_state`, `_res_version`). Ce **contrat de format** (une ligne « Statut : » et une ligne « Version : » en tête de fichier) n'est encodé nulle part comme spécification : il vit dans les templates des skills et dans le code de `clia`. C'est un couplage implicite, une régression silencieuse possible si un skill cesse d'émettre ces lignes.

**C5. Les `REQ`/`SPEC` existants ne portent que sur le CLI.** `REQ-001`/`SPEC-001` (convention CLI bash), `REQ-002`/`SPEC-002` (`clia`), `SPEC-003` (format session). Aucun `REQ`/`SPEC` ne porte sur les ressources de type document (PLN, ADR, FND, etc.) en tant que catégorie. Le système fonctionne aujourd'hui sans eux.

## Confrontation à la référence

Face à `ADR-004` (état courant + amendement prévu) et au précédent `SPEC-003` + `clia ses check` :

- Un `REQ`/`SPEC` **générique et monolithique** des « ressources livrables » **dupliquerait** les skills (C1) et l'`ADR-004` amendé (C2). Écart : redondance, sources de vérité concurrentes, coût de maintenance ; contraire au critère `skl-006` « un ADR = une décision, pas un fourre-tout » transposé aux REQ/SPEC.
- Le seul **écart réel non couvert** est la **validation automatisable** (C3, C4) : il n'existe ni format formel par type, ni validateur générique, alors que `clia` s'appuie déjà sur un format implicite. `SPEC-003` montre la forme que prendrait la couverture de cet écart : une `SPEC` de format **par document validable**, consommée par un validateur `clia` (un futur `clia res check` analogue à `clia ses check`).

## Synthèse et recommandations

**Constat central** : le besoin n'est **pas** un `REQ`/`SPEC` générique des ressources livrables (les skills + `ADR-004` amendé suffisent à définir, exiger et gabariter chaque type). Le besoin réel, s'il est retenu, est un **contrat de format validable** là où `clia` doit vérifier une ressource par machine.

Recommandations, par priorité (à trancher par l'humain au breakpoint) :

1. **(Recommandé) Pas de REQ/SPEC générique des ressources livrables.** Intégrer les axes manquants (source de vérité, format variable, template, validation) à `ADR-004` comme prévu (`PLN-013` B.2), et conserver les skills comme spécification/exigence vivante par type. Coût faible, aucune duplication.
2. **(Recommandé si la validation machine est voulue) Formaliser le contrat de format des ressources vivantes** que `clia` lit déjà implicitement (lignes « Statut : » / « Version : », C4), sur le modèle `SPEC-003`, et le valider par un futur `clia res check`. Cela lève le couplage implicite sans créer de REQ/SPEC par type documentaire complet : une `SPEC` de format **minimale et ciblée**, pas une refonte.
3. **(Optionnel, à la demande) SPEC de format par type seulement là où une validation automatique apporte une valeur** (ex. cohérence de `ressources.yaml`, en-têtes des ressources vivantes). Ne pas généraliser à tous les types documentaires : pour PLN, FND, ANL, ADR, la conformité par jugement via les « Critères de qualité » du skill reste adéquate.

Décision attendue de l'humain au breakpoint : retenir 1 seul (conception documentaire suffisante) ou 1 + 2 (ajouter un contrat de format validable), et le cas échéant cadrer la portée de 2/3. Cette décision conditionne l'étape `PLN-013` B.5 (produire ou non des `REQ`/`SPEC` de `setup` et, plus largement, des ressources livrables).

## Portée et péremption

Couverture : l'ensemble des types de ressources livrables actuels et les deux points d'appui de `clia` (`resource.sh`, `session.sh`) au 2026-07-18. Limites : n'anticipe pas les types futurs (ex. « interface CLI » prévue en `PLN-013` B.6, publications) ; la conclusion sur la validation implicite (C4) dépend de l'implémentation courante de `clia`, susceptible d'évoluer. À réévaluer si de nouveaux types validables par machine apparaissent ou si `clia` gagne une commande de validation générique des ressources.
