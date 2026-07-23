---
type: adr
version: 0.1.0
title: "Harnais ARCHITECTURE.md"
status: Accepté
date: 2026-07-18
---

# ADR-009 - Harnais ARCHITECTURE.md

- **Décideurs** : Jérémy Viau-Trudel (humain), agent IA
- **Sources** : tâche 22 de `.dev/session.md`, `FND-009-architecture-systemes-complexes`, `ANL-004-architecture-effective-du-repo`

## Contexte

L'architecture du système d'augmentation est saine mais **tacite** : elle est dispersée entre `ADR-007`, `ADR-004`, `CONSTITUTION.md`, `CLAUDE.md` et les PDC, sans **description consolidée** en un seul endroit (`ANL-004-architecture-effective-du-repo`). Il en résulte un **coût d'orientation récurrent** et un **risque de dérive**, d'autant plus critiques que le premier lecteur du dépôt est un **agent IA**, « architecturalement ignorant tant qu'on ne lui dit pas » (`FND-009-architecture-systemes-complexes`, §5-6).

La convention `ARCHITECTURE.md` (matklad) répond exactement à ce besoin : une carte de haut niveau, courte et stable, placée à l'endroit que l'agent lit toujours, le dépôt. Le dépôt possède déjà les **ADR** (décisions, le *pourquoi*) et les **PDC** (invariants) ; il lui manque l'artefact de **description d'architecture** (le *quoi structurel*, la carte).

## Décision (résumé)

> On crée un **fichier de harnais `ARCHITECTURE.md`** à la racine du dépôt : une **description d'architecture légère, stable et versionnée** qui donne une carte de haut niveau du système (problème résolu, composants, acteurs, flux principal, invariants, et cartographie « où est la chose qui fait X ? »). C'est un **document vivant co-édité** (produit par l'agent, validé par l'humain), membre de l'ensemble `harness-files`. Sa production est encadrée par `skl-015-architecture-harnais`. Il complète, sans les remplacer, les ADR (décisions), les PDC (invariants) et les autres harnais.

## Décisions détaillées

### Nature et place dans le harnais

- **Décision** : `ARCHITECTURE.md` est un **fichier de harnais** (nom fixe à la racine, comme `CLAUDE.md`, `CONSTITUTION.md`, `INTENTION.md`), qui décrit la **structure** du système. Il s'ajoute à la triade existante en respectant la séparation des préoccupations (`PDC-005`) :
  - `INTENTION.md` : le **pourquoi** (intention globale) ;
  - `CONSTITUTION.md` (et le futur document de processus) : la **gouvernance / l'orchestration** ;
  - `ARCHITECTURE.md` : la **structure** (composants, relations, carte) ;
  - `CLAUDE.md` : le **mode opératoire** de l'agent.
- *Alternatives écartées* : loger l'architecture dans `CLAUDE.md` (rejeté : mêlerait mode opératoire et structure, contraire à `PDC-005`) ; se contenter des ADR (rejeté : les ADR capturent des décisions ponctuelles, pas une carte d'ensemble consolidée) ; adopter un framework lourd type TOGAF (rejeté : disproportionné, risque d'« ivory tower » ; on retient un vocabulaire C4 et la discipline des vues 42010, pas leur appareil complet).

### Contenu et forme

- **Décision** : `ARCHITECTURE.md` suit les principes de la convention (matklad) : **vue d'oiseau d'abord** (le problème résolu avant la solution), **cartographie du code** (« où est la chose qui fait X ? »), **court et stable** (ne décrire que le durable, ne pas synchroniser ligne à ligne avec le code, réviser quelques fois par an). Il renvoie aux ADR pour le *pourquoi* et aux PDC pour les invariants, sans les dupliquer (`PDC-006`).

### Cycle de vie, versionnage, droits d'édition

- **Décision** : document **vivant**, membre de l'ensemble `harness-files` ; toute modification bumpe atomiquement le membre et l'ensemble (`ADR-004`, `PDC-009`). **Co-édition** : produit et maintenu par l'agent, validé par l'humain (comme `CLAUDE.md`/`CONSTITUTION.md` dans la « Classification des documents » de `CONSTITUTION.md`).

### Généricité

- **Décision** : `ARCHITECTURE.md` décrit l'architecture du **système d'augmentation générique** ; il ne contient aucune information de domaine métier (`PDC-003`, `ADR-005`). L'architecture du contenu métier d'un dépôt hôte, si elle est documentée, relève d'un autre artefact, hors harnais.

### Articulation avec la dérive (bogues)

- **Décision** : un écart entre `ARCHITECTURE.md` et l'architecture effective, ou entre l'architecture et un principe de conception, est un **bogue** (`ADR-003`, `PDC-005`). `ARCHITECTURE.md` sert de référence de conformité structurelle.

## Conséquences

**Positives**
- Le coût d'orientation (humain et agent) baisse : une carte unique remplace la lecture de dix documents.
- La dérive devient détectable (référence de conformité structurelle).
- La séparation des préoccupations des harnais est renforcée (pourquoi / gouvernance / structure / mode opératoire).

**Négatives / risques**
- Un fichier de harnais de plus à maintenir ; risque qu'il pourrisse s'il est trop détaillé ou synchronisé au code (mitigé par la règle « court et stable »).
- Risque de recouvrement avec les ADR (décisions) et `ADR-007` en particulier : `ARCHITECTURE.md` **consolide et cartographie**, il ne décide pas ; les ADR restent la source des décisions.

## Migration / porte de sortie

Premier jet. `ARCHITECTURE.md` de ce dépôt est produit dans la foulée (tâche 22). Si l'usage montre un recouvrement excessif avec les ADR ou une tendance à pourrir, un ADR ultérieur ajustera son périmètre (ex. en le réduisant à une pure carte d'orientation).

## Références

- `FND-009-architecture-systemes-complexes` (frameworks, artefacts, ARCHITECTURE.md, anti-patterns)
- `ANL-004-architecture-effective-du-repo` (constats, recommandations)
- `skl-015-architecture-harnais` (skill de production)
- `ADR-004-ressources-livrables` (versionnage), `ADR-005-fonction-scope-harnais` (généricité), `ADR-007-architecture-systeme-augmentation` (les trois composants)
- `PDC-003`, `PDC-005`, `PDC-006`, `PDC-009` ; `ADR-003-gestion-des-bogues` (dérive = bogue)
