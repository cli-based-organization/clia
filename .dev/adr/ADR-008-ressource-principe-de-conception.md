---
type: adr
version: 0.1.0
title: "Ressource « principe de conception »"
status: Accepté
date: 2026-07-18
---

# ADR-008 - Ressource « principe de conception »

- **Décideurs** : Jérémy Viau-Trudel (humain), agent IA
- **Sources** : tâche 19 de `.dev/session.md`, `FND-014-principes-de-conception-systemes-complexes`, `ANL-010-principes-de-conception-du-repo`

## Contexte

Le système est gouverné par une dizaine de principes de conception (déterminisme, séparation méthode/domaine, séparation des préoccupations, interface fichiers, source de vérité unique, etc.), identifiés dans `ANL-010-principes-de-conception-du-repo`. Jusqu'ici, ces principes vivaient **dispersés et implicites** dans le harnais et les ADR : impossible de les consulter comme un corpus, de vérifier qu'un élément les respecte, ou de qualifier précisément une violation.

Or, selon `FND-014-principes-de-conception-systemes-complexes`, un principe de conception est un **énoncé normatif durable et transverse** qui guide le design de haut niveau et auquel **tout élément du système doit se conformer** pour préserver l'intégrité conceptuelle (Brooks). Un principe se distingue d'une décision (ADR, ponctuelle) et d'une exigence (REQ, propre à un système donné) : il est au-dessus d'elles et sert de critère pour juger leur cohérence.

Il faut donc un **type de ressource dédié** pour matérialiser chaque principe, l'encadrer par un skill, et articuler son non-respect avec la gestion des bogues.

## Décision (résumé)

> On crée un type de ressource livrable **principe de conception**, préfixe **`PDC`**, emplacement `.dev/principes/PDC-<SEQ>-<SLUG>.md`. C'est un **document vivant** (séquencé, versionné en semver), membre de l'ensemble `documents-de-conception`. Un PDC énonce un principe durable de haut niveau (énoncé, justification, portée, implications, critères de conformité) auquel tout élément du système doit se conformer. Sa production est encadrée par `skl-014-principe-de-conception`. Le **non-respect d'un principe de conception est un bogue** (voir `ADR-003` amendé).

## Décisions détaillées

### Nature, place et distinction

- **Décision** : un PDC est une ressource **de conception, transverse et durable**. Il guide le design de haut niveau ; tout élément du système (harnais, `clia`, documents de conception, livrables) doit lui être cohérent.
- **Distinction** (d'après `FND` §3) :
  - vs **ADR** : un ADR tranche une décision ponctuelle ; un PDC énonce un principe durable qui **cadre** les décisions (un ADR doit respecter les PDC).
  - vs **REQ/SPEC** : un requis/une spécification portent sur un système donné ; un PDC s'applique à **tout** le système et sert de critère de cohérence pour les requis et spécifications eux-mêmes.
- *Alternatives écartées* : consigner les principes dans `CONSTITUTION.md` (rejeté : mêlerait principes de conception et gouvernance, contraire à la séparation des préoccupations — voir `ANL-008-critique-constitution`) ; les laisser implicites dans les ADR (rejeté : non consultables, non vérifiables, cause de l'absence de qualification des violations).

### Cycle de vie, nomenclature, versionnage

- **Décision** : PDC est un document **vivant** (catégorie « vivant » de `ADR-004`) : il mûrit et se précise. Statuts : `proposé` / `accepté` / `déprécié` / `remplacé par PDC-XXX`.
- **Nomenclature** : `.dev/principes/PDC-<SEQ>-<SLUG>.md` (séquence globale incrémentale), conforme à `.dev/<type>/<PREFIX>-<SEQ>-<SLUG>.md` (`ADR-004`).
- **Versionnage** : semver, **membre de l'ensemble `documents-de-conception`** (aux côtés des ADR/SPEC/REQ). Toute modification bumpe atomiquement le membre et l'ensemble (`ADR-004`).

### Droits d'édition

- **Décision** : PDC est **produit par l'agent, validé par l'humain** (édition IA, comme les ADR dans la « Classification des documents » de `CONSTITUTION.md`), car un principe de conception a une **haute autorité** : l'humain valide via `session.md`. Un PDC n'est pas un fichier en édition humaine uniquement, mais son adoption engage fortement la direction du système ; l'agent le propose, l'humain l'entérine.

### Structure d'un PDC

- **Décision** : un PDC bien formé comporte : **Énoncé** (le principe, une phrase normative) ; **Justification** (pourquoi, rationale) ; **Portée** (à quoi il s'applique) ; **Implications** (ce qu'il impose ou interdit concrètement) ; **Critères de conformité** (comment vérifier qu'un élément le respecte) ; **Tensions** (avec d'autres principes) ; **Références**. Forme inspirée du principe directeur de la `FND` (§3 : énoncé + justification + implications).

### Articulation avec les bogues

- **Décision** : le **non-respect d'un principe de conception est un bogue** au sens de `ADR-003`. Les **critères de conformité** d'un PDC définissent ce qu'est un respect ; un écart avéré se consigne, se diagnostique et se corrige via une ressource `BUG` (`skl-013`). `ADR-003` et `skl-013` sont amendés pour l'indiquer explicitement.

### Skill de production

- **Décision** : la production d'un PDC est encadrée par **`skl-014-principe-de-conception`** (ajouté aux fichiers de harnais, ensemble `harness-files`).

## Conséquences

**Positives**
- Les principes deviennent un **corpus consultable, vérifiable et versionné**, au lieu d'être implicites et dispersés.
- La cohérence du système (intégrité conceptuelle) gagne un critère explicite : conformité aux PDC.
- Les violations sont **qualifiables** (bogue) et donc corrigibles de façon tracée.

**Négatives / risques**
- Un type de ressource de plus à maintenir.
- Risque de recouvrement avec les ADR (principe vs décision) et avec `CONSTITUTION.md` (principe de conception vs principe de gouvernance) ; la distinction est posée ci-dessus mais demande de la discipline.
- Risque de prolifération : à réserver aux principes réellement transverses et durables (critère `FND` §3), pas à toute préférence.

## Migration / porte de sortie

Premier jet. Les principes déjà identifiés (`ANL-010-principes-de-conception-du-repo`, P1..P10) seront matérialisés en PDC dans une exécution ultérieure. Si l'usage montre un recouvrement excessif PDC/ADR ou PDC/CONSTITUTION, un ADR ultérieur affinera la frontière.

## Références

- `FND-014-principes-de-conception-systemes-complexes` (nature d'un principe, intégrité conceptuelle)
- `ANL-010-principes-de-conception-du-repo` (principes du dépôt, P1..P10)
- `skl-014-principe-de-conception` (skill de production)
- `ADR-004-ressources-livrables` (typologie, cycle de vie, versionnage)
- `ADR-003-gestion-des-bogues` (amendé : violation d'un principe = bogue)
- `ADR-005-fonction-scope-harnais` (généricité)
