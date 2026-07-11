# ADR-007 - Architecture du système d'augmentation par IA

- **Statut** : Accepté
- **Version** : 0.1.0
- **Date** : 2026-07-10
- **Décideurs** : Jérémy Viau-Trudel (humain), agent IA
- **Sources** : `PLN-006`, tâche 18 de `session.md` (objections 3 et 6)

## Contexte

Le dépôt met en place un système de collaboration humain / agent IA. Jusqu'ici, deux notions coexistaient sans frontière nette : les documents de conception (ADR, SPEC, REQ...) et les fichiers de harnais (`CLAUDE.md`, `CONSTITUTION.md`, skills). L'introduction de `clia` (CLI déterministe, `PLN-006`) a rendu nécessaire une architecture explicite : `clia` n'est ni l'agent IA, ni un document de conception, ni une ressource de harnais. Il faut nommer les composants du système, leurs frontières et leurs rôles.

## Décision (résumé)

> Le système d'augmentation par IA se compose de **trois** composants distincts : (1) la **conception** (FND, ANL, ADR, SPEC, REQ, BUG) qui acte le quoi et le pourquoi ; (2) les **fichiers de harnais** (`CLAUDE.md`, `CONSTITUTION.md`, skills) qui implémentent la conception en mode opératoire de l'agent ; (3) **`clia`**, un CLI 100% déterministe qui prend en charge les transitions d'état du cycle de vie des fichiers pour garantir l'intégrité du système d'information. Ces trois composants ont des frontières, des rôles et des versions indépendantes.

## Décisions détaillées

### Les trois composants

- **Décision** :
  - **Conception** : FND, ANL, ADR, SPEC, REQ, BUG. Décrivent, décident, spécifient et exigent. Source de vérité des choix.
  - **Harness-files** : `CLAUDE.md`, `CONSTITUTION.md`, skills (`skl-*`). Implémentation opératoire des décisions de conception, à destination de l'agent IA. Générique et réutilisable (`ADR-005`).
  - **`clia`** : CLI bash déterministe. Exécute les tâches automatisables et sûres (transitions de session, inspection des ressources et versions) sans jugement.
- *Alternatives écartées* : fusionner conception et harnais : rejeté, cela confond la décision et son implémentation ; ranger `clia` dans le harnais : rejeté (tâche 18, objection 6), `clia` n'est pas un artefact lu par l'agent mais un outil opéré par l'humain.

### Le harnais implémente la conception

- **Décision** : le harnais ne décide rien de nouveau ; il traduit en règles opératoires ce que la conception a acté. Un changement de décision passe d'abord par un document de conception, puis se répercute dans le harnais. Cette relation d'implémentation est la raison pour laquelle la conception n'appartient pas au harnais (précision reportée dans `ADR-005`).

### Rôle et légitimité de `clia`

- **Décision** : `clia` est **100% déterministe** : mêmes entrées, mêmes sorties, aucune improvisation. Sa fonction est de prendre en charge les changements d'état du cycle de vie des fichiers (ouverture, archivage de sessions ; lecture des versions) afin d'assurer l'intégrité du système d'information. Parce qu'il est déterministe et opéré par l'humain, `clia` peut légitimement muter des fichiers en édition humaine uniquement (`session.md`, `.dev/sessions/*`) : c'est l'humain qui agit, via son outil. **L'agent IA n'invoque jamais** `clia ses plan/open/close/new`.
- *Alternatives écartées* : confier ces transitions à l'agent IA : rejeté, un agent non déterministe ne garantit pas l'intégrité et n'a pas le droit d'éditer les fichiers humains.

### Versions indépendantes

- **Décision** : chaque composant a sa version propre, incrémentée indépendamment (voir `ADR-004`). Le contenu **métier** du dépôt a lui aussi sa version, distincte des trois composants. Modifier `clia` ou le harnais n'incrémente pas la version métier, et inversement.

## Conséquences

**Positives**
- Frontières nettes : on sait où une décision se prend (conception), où elle s'applique (harnais), et ce qui l'automatise (`clia`).
- `clia` peut opérer sur les fichiers humains sans violer la gouvernance, car déterministe et opéré par l'humain.

**Négatives / risques**
- Trois domaines de version à tenir cohérents (`ADR-004`, `.dev/ressources.yaml`, `version.yaml`).
- Discipline requise : une décision doit passer par la conception avant le harnais.

## Migration / porte de sortie

Premier jet issu de `PLN-006`. Un ADR ultérieur pourra affiner les frontières si un quatrième composant émerge (ex. couche de publication).

## Références

- `ADR-004-ressources-livrables`
- `ADR-005-fonction-scope-harnais`
- `PLN-006-cli-clia`
- `CONSTITUTION.md` (rôle de `clia` dans la gouvernance)
