---
type: adr
version: 0.2.0
title: "Ressources livrables : modèle unifié, zones, métadonnées et versionnage"
status: accepté
date: 2026-07-21
---

# ADR-004 - Ressources livrables : modèle unifié, zones, métadonnées et versionnage

- **Décideurs** : Jérémy Viau-Trudel (humain), agent IA
- **Sources** : `PLN-014-adoption-conventions-okf` (tâches 24, 25, 26 de `.dev/session.md`), `ANL-006-clia-et-open-knowledge-format`, `ANL-013-usage-semantique-ontologie-repos`, `FND-012-llm-wiki-okf-gestion-connaissance`, `FND-016-ontologie-et-semantique`. Remplace la version 0.1.0 (typologie à triple cycle de vie et manifeste `ressources.yaml`).

> Réécriture (première passe) décidée par `PLN-014`. Ce document est produit au **Segment 1** de `PLN-014` ; la migration mécanique de l'existant conforme à ce modèle (frontmatter partout, renommage, suppression du manifeste) relève du **Segment 2**, après le breakpoint. Durant cet intervalle, l'existant peut ne pas encore refléter le présent modèle.

## Contexte

La version 0.1.0 classait les ressources selon **trois cycles de vie** (point fixe immuable et daté ; vivant versionné et séquencé ; travail non versionné) et suivait les versions dans un **manifeste central** `.dev/ressources.yaml` avec deux ensembles composites atomiques. Les tâches 24 à 26 de `session.md` ont décidé de **simplifier et unifier** ce modèle : abolir l'immuabilité comme catégorie de ressource livrable, adopter sélectivement les conventions de l'Open Knowledge Format (frontmatter `type`, références croisées formalisées), et clarifier les zones du dépôt. Le savoir mobilisé (`ANL-013-usage-semantique-ontologie-repos`) établit que la typologie de ressources de `clia` est une **ontologie légère de facto** : ce document l'explicite en restant léger (pas de RDF/OWL).

## Décision (résumé)

> Il existe désormais **une seule catégorie de ressources livrables : vivantes**, chacune portant sa `version` (semver) et ses métadonnées dans un **frontmatter YAML** (qui remplace les puces d'en-tête), typée par un champ `type`. Les **traces** (logs, archives de session) ne sont **pas** des ressources livrables : ce sont des métadonnées horodatées **immuables**. Le **manifeste `ressources.yaml` est aboli** ; la version vit dans le frontmatter de chaque ressource. Le dépôt s'organise en **zones** (`@.` contenu de domaine, `@.dev` développement et augmentation, `doc/` inchangé) ; il n'y a pas de zone `.knowledge` pour l'instant. Les ressources livrables sont **nommées de façon séquencée** ; les traces conservent un nommage horodaté. Les références croisées sont des **liens** appartenant à un petit vocabulaire de relations, validables par `clia`.

## Décisions détaillées

### Vocabulaire

- **Ressource livrable** : document ou fichier **vivant** et **versionné**, produit en réponse à une demande, source de vérité (par opposition aux échanges conversationnels). Concernées : `FND`, `ANL`, `ADR`, `SPEC`, `REQ`, `PDC`, `skl`, `BUG`, `PLN`, et les harnais (`CLAUDE.md`, `CONSTITUTION.md`, `ARCHITECTURE.md`).
- **Trace** : métadonnée horodatée **immuable**, qui documente l'activité sans être un livrable. Concernées : `.dev/logs/ia-output/*` (traces d'audit par tâche) et `.dev/sessions/*` (archives de séance). Une trace ne se révise pas ; sa valeur est probante (`PDC-009`).

### Cycle de vie unifié

- La distinction point fixe / vivant / travail est **abolie**. Toute ressource livrable est **vivante** : elle évolue et porte une version. La catégorie « travail » est supprimée (les `PLN` sont vivants).
- Les **traces** restent **immuables** : elles ne sont pas des ressources livrables et ne sont pas versionnées en semver.

### Zones

- `@.` (racine) : **zone de contenu**, artefacts de domaine du projet.
- `@.dev` : **zone de développement et d'augmentation**, qui héberge toutes les ressources livrables de méthode et les traces. Les `logs` y sont rapatriés (`.dev/logs/ia-output/`).
- `doc/` : documentation utilisateur, **inchangée**, laissée à la racine.
- Pas de zone `.knowledge` pour l'instant.

### Métadonnées : frontmatter

- Chaque ressource livrable porte un **frontmatter YAML** qui **remplace** les puces d'en-tête (pas de duplication, `PDC-006`). Champs : `type` (obligatoire), `version` (obligatoire), `title`, `status` le cas échéant, plus champs réservés utiles (`description`, `tags`). Les traces portent `type` et un horodatage, sans `version` semver.
- Le champ `type` rattache l'instance à sa classe : c'est la **couche type** (ontologie légère). Le vocabulaire contrôlé des `type` et le schéma sont la source de vérité machine-lisible (voir `.dev/resource-types.yaml`) ; la table des livrables de `CLAUDE.md` en est une **vue**, non une source parallèle (`PDC-006`).

### Versionnage

- Chaque ressource vivante porte sa `version` (semver) **dans son frontmatter**. Règles : MAJEUR = changement incompatible du sens/contrat ; MINEUR = ajout rétrocompatible ; CORRECTIF = clarification sans effet sémantique. Version initiale `0.1.0` (phase de conception).
- Le **manifeste `.dev/ressources.yaml` est aboli**, ainsi que les ensembles composites et le bump atomique par manifeste. Il n'y a plus de source de version centrale ; `clia` lit les versions depuis les frontmatters.
- Le versionnage reste **piloté par fichiers**, jamais par tags git.
- La version du **domaine métier** (`version.yaml`, racine) demeure séparée (`ADR-007`) et est incrémentée par `clia release` (`PLN-015`).

### Nommage

- Ressources livrables : **séquencées**, `<PREFIX>-<SEQ>-<SLUG>.md` (ex. `ADR-004`, `FND-<SEQ>-<SLUG>`). Le nommage est **découplé** du cycle de vie (il ne dépend plus d'une catégorie point fixe).
- Traces : nommage **horodaté** conservé, `LOG-<DATE>-task-<NN>.md` pour les logs ; archives de session `SES-<DATE>-<HEURE>-<SLUG>.md`.
- Harnais : noms fixes (`CLAUDE.md`, `CONSTITUTION.md`, `ARCHITECTURE.md`) ; skills en `.dev/skills/skl-<SEQ>-<nom>/SKILL.md`.

### Références croisées et relations

- Les références entre ressources sont des **liens** (formalisés en liens markdown lors du Segment 2) appartenant à un **vocabulaire de relations** explicite : `specifie`, `derive-de`, `remplace`, `reference`, `produit-par`, `viole`. Ce vocabulaire vit dans `.dev/resource-types.yaml`.
- `clia` peut valider l'**intégrité référentielle** (référence pendante = bogue, `ADR-003`) et la cohérence des `type`. L'implémentation de cette validation relève de la réconciliation ultérieure de `clia`.

### Droits d'édition et exemptions

- Les droits d'édition restent définis par la « Classification des documents » de `CONSTITUTION.md`. L'abolition de l'immuabilité **ne change pas** les droits d'édition : les fichiers en édition humaine uniquement (`INTENTION.md`, `.dev/session.md`, `.dev/session-x*.md`, `.dev/sessions/*`) ne sont **jamais** modifiés par l'agent et sont **exemptés** de la règle de frontmatter appliquée par l'agent.
- `INTENTION.md` reste hors harnais et hors versionnage géré par l'agent.

### Généricité

- Le modèle, les zones (défauts paramétrables) et le vocabulaire de `type` sont **génériques** (aucune information de domaine, `ADR-005`).

## Conséquences

**Positives**
- Modèle unifié plus simple (une catégorie de ressource livrable) ; métadonnées uniformes et machine-lisibles (frontmatter `type` + `version`) ; couche type explicite (ontologie légère) ; graphe de références validable ; suppression du couplage au manifeste.

**Négatives / risques**
- Migration mécanique de masse à mener (frontmatter partout, renommage daté vers séquencé, réparation des références, rapatriement des `logs`, suppression du manifeste) : couplage fort et difficilement réversible, gérée au Segment 2 de `PLN-014` sous revue humaine (breakpoint).
- Impact sur `clia` : la lecture des versions passe du manifeste au frontmatter (`clia --version --long`, `clia res ls`) ; réconciliation à mener lors d'un chantier `clia` distinct.
- Interim : tant que le Segment 2 n'est pas exécuté, l'existant coexiste en deux formats.

## Migration / porte de sortie

Migration exécutée au **Segment 2 de `PLN-014`** (après breakpoint) : frontmatter en remplacement des puces sur toutes les ressources livrables, renommage des `FND`/`ANL` en séquencé avec réparation des références, `type: log` sur les traces sans altérer leur immuabilité, rapatriement de `logs` sous `.dev`, suppression de `.dev/ressources.yaml`, amendement des skills et harnais. Un ADR ultérieur pourra affiner le vocabulaire de `type` et de relations si l'usage l'exige.

## Références

- `PLN-014-adoption-conventions-okf`
- `.dev/resource-types.yaml` (schéma de la couche type)
- `ADR-005-fonction-scope-harnais`, `ADR-007-architecture-systeme-augmentation`
- `PDC-006-source-de-verite-documentaire-unique`, `PDC-009-tracabilite-et-versionnage-atomique`
- `ANL-013-usage-semantique-ontologie-repos`, `FND-016-ontologie-et-semantique`
