---
type: analyse
version: 0.1.0
title: "Architecture effective du dépôt : constats et recommandations"
date: 2026-07-18
---

# ANL-004 - Architecture effective du dépôt : constats et recommandations

- **Périmètre** : l'architecture effective du système d'augmentation de ce dépôt (`clia`), telle qu'inscrite dans `ADR-004`, `ADR-005`, `ADR-006`, `ADR-007`, `CONSTITUTION.md`, `CLAUDE.md`, `INTENTION.md` (lecture), les PDC (`.dev/principes`), et la structure `src/` de `clia`. Exclusions : contenu métier.
- **Référence** : `FND-009-architecture-systemes-complexes` ; `FND-014-principes-de-conception-systemes-complexes`.

## Objet

Faire une analyse critique de l'architecture effective du dépôt au regard du savoir mobilisé : quels constats, pourquoi l'implémentation actuelle est sous-optimale, et quelle architecture (au sens de sa **description**) adopter, comment y parvenir et pourquoi. L'analyse recommande ; elle n'exécute aucun changement de structure de `clia`.

## Périmètre et méthode

Grille, dérivée de la `FND` : (1) reconstituer l'architecture effective (composants, relations, vues, décisions) telle qu'elle existe **dispersée** dans les documents ; (2) la confronter aux artefacts et bonnes pratiques (description 42010, ADR, C4, ARCHITECTURE.md ; anti-patterns) ; (3) diagnostiquer les sous-optimalités ; (4) recommander.

## L'architecture effective, telle qu'elle existe aujourd'hui

Reconstituée à partir des documents, l'architecture du système est en réalité **claire et cohérente**, mais **jamais décrite en un seul endroit** :

- **Composants (niveau « conteneur » façon C4)** : trois ensembles vivants (`ADR-007`) — **harness-files** (méthode : CLAUDE, CONSTITUTION, INTENTION, skills), **documents-de-conception** (ADR, SPEC, REQ, PDC), **clia** (CLI bash déterministe) — plus les **ressources point-fixe** (FND, ANL, LOG, SES : savoir et traces).
- **Acteurs** : humain, agent IA, `clia` (automatisme déterministe), avec une répartition des rôles gouvernée (`CONSTITUTION.md`, `PDC-002`, `PDC-010`).
- **Structure interne de `clia` (niveau « composant »)** : `src/bin/clia` (dispatch) ; `src/lib/` (`common.sh`, `version.sh`, `resource.sh`, `session.sh`, `doc.sh`) ; source documentaire `clia.doc.yaml`.
- **Flux principal (vue « scénario »/processus)** : l'humain soumet via `session.md` ; l'agent produit plans, livrables et logs (fichiers) ; `clia`, opéré par l'humain, opère les transitions de session et l'inspection.
- **Décisions d'architecture** : capturées par des **ADR** (bonne pratique respectée) — notamment `ADR-007` (les trois composants et le versionnage à deux domaines).
- **Invariants** : formalisés en **principes de conception** (`PDC-001..010`) depuis les tâches 19-21.

## Constats

**C1. Les décisions sont bien documentées (ADR), mais la description d'architecture n'existe pas.** Le dépôt respecte la bonne pratique « documenter les décisions » (`FND` §3, §4) via ses ADR. En revanche, il n'a **aucune description d'architecture consolidée** (au sens 42010 ni au sens ARCHITECTURE.md) : la carte du système est **dispersée** entre `ADR-007`, `ADR-004`, `CONSTITUTION.md`, `CLAUDE.md` et les PDC. Il manque la **vue d'ensemble unique**.

**C2. L'architecture effective est saine, mais tacite.** Contrairement au Big Ball of Mud, la structure est réelle et cohérente (séparation nette des trois composants, quasi-décomposabilité, séparation déterministe/IA). Le problème n'est pas l'architecture **elle-même**, mais son **absence de description** : elle est **tacite**, reconstituable seulement en lisant une dizaine de documents.

**C3. Sous-optimalité principale : le coût d'orientation.** Sans `ARCHITECTURE.md`, un nouveau venu — humain **ou agent IA** — ne peut obtenir la carte du système en un endroit. Or la `FND` (§5) rappelle que les agents sont « architecturalement ignorants tant qu'on ne leur dit pas », et que l'endroit où ils regardent toujours est le dépôt. L'implémentation actuelle est donc sous-optimale précisément là où le projet est le plus exigeant : rendre le système **compréhensible et gouvernable par un agent**.

**C4. Risque de dérive et de re-découverte.** Une architecture tacite se re-découvre à chaque session (coût récurrent) et **dérive** silencieusement, faute de référence unique contre laquelle juger la conformité. Cela rejoint l'écart déjà consigné sur la séparation des préoccupations (`BUG-004` : `CONSTITUTION.md` mêle gouvernance et orchestration) : sans vue d'architecture, de tels mélanges passent inaperçus plus longtemps.

**C5. Le dépôt n'est ni « ivory tower » ni « mud ».** Il n'y a pas de sur-conception rigide hors-sol (l'architecture a émergé par ADR successifs, ancrés dans l'usage), ni d'absence de structure. La bonne cible n'est donc **pas** un framework lourd (TOGAF), mais une **description légère et stable** (ARCHITECTURE.md), proportionnée à la taille du système et à son public (l'agent).

**C6. Vues pertinentes déjà implicites.** Les vues de la `FND` (§1-3) existent déjà en germe : vue **composants** (`ADR-007`), vue **acteurs/gouvernance** (`CONSTITUTION.md`), vue **processus** (cycle de session, `ADR-006`), vue **décisions** (ADR), vue **invariants** (PDC). Il « suffit » de les **consolider et cartographier**, pas de les inventer.

## Confrontation à la référence

- **Artefacts (`FND` §3)** : le dépôt a les ADR (pourquoi) et, depuis peu, les PDC (invariants), mais **pas** la description d'architecture (42010) ni la carte d'orientation (ARCHITECTURE.md). L'artefact manquant est identifié.
- **Bonnes pratiques (`FND` §4)** : intégrité conceptuelle et séparation des préoccupations sont **visées** (PDC), décisions documentées **respectées** ; « doc d'architecture courte et stable » **absente**.
- **IA et architecture (`FND` §5-6)** : le dépôt, dont le public premier est un agent, n'a pas encore adopté la convention (`ARCHITECTURE.md`) qui répond exactement à son besoin d'orientation d'agent. C'est l'écart le plus significatif au regard de la nature du projet.

## Recommandations

**Meilleure architecture à adopter (au sens de sa description)** : une **description d'architecture légère, stable et versionnée dans le dépôt**, sous la forme d'un **`ARCHITECTURE.md`** (harnais IA), consolidant les vues déjà implicites. Pas de framework lourd ; le C4 fournit un **vocabulaire** utile (contexte / conteneurs / composants) et l'ISO 42010 la **discipline des vues**, sans en adopter tout l'appareil.

Comment y parvenir, et pourquoi :
1. **Créer le harnais `ARCHITECTURE.md`** (type défini par un ADR dédié et produit par un skill dédié) : c'est l'artefact manquant qui répond au coût d'orientation (C3) et au risque de dérive (C4). Pourquoi : c'est l'endroit que l'agent lit toujours (`FND` §5-6).
2. **Consolider les vues existantes** dans `ARCHITECTURE.md` : vue d'ensemble (problème résolu d'abord), composants (trois ensembles + `clia`), acteurs/rôles, flux principal, invariants (renvoi aux PDC), et une **carte « où est la chose qui fait X ? »** vers `src/lib/*`. Pourquoi : matklad — vue d'oiseau d'abord, cartographier le code.
3. **Garder le document court et stable** : n'y décrire que le durable, ne pas le synchroniser ligne à ligne, renvoyer aux ADR/PDC pour le détail et le *pourquoi*. Pourquoi : éviter la doc qui pourrit (`FND` §4, §6).
4. **Articuler avec les autres harnais** : `INTENTION.md` (pourquoi), `CONSTITUTION.md`/processus (gouvernance/orchestration), `ARCHITECTURE.md` (structure), `CLAUDE.md` (mode opératoire) — chacun une préoccupation, cohérent avec `PDC-005`. Pourquoi : séparation des préoccupations.
5. **Traiter la dérive comme un bogue** : un écart entre `ARCHITECTURE.md` et l'architecture effective (ou entre l'architecture et les principes) est un défaut au sens de `ADR-003` / `PDC`.

Pourquoi l'implémentation actuelle est sous-optimale, en une phrase : l'architecture du système est **bonne mais tacite** ; en l'absence d'une description consolidée et lisible par l'agent, le projet paie un coût d'orientation récurrent, s'expose à la dérive, et se prive de l'artefact le plus utile à un système dont le premier lecteur est une IA.

## Portée et péremption

Couverture : l'architecture reconstituée à partir des documents au 2026-07-18 (harness-files 0.5.0). Limites : l'analyse porte sur la **description** de l'architecture, pas sur une refonte de la structure de `clia` (jugée saine) ; elle ne produit pas les diagrammes C4, laissés à `ARCHITECTURE.md` ou à un artefact ultérieur. Péremption : la création d'`ARCHITECTURE.md` et l'évolution du système rendront cet état des lieux caduc.
