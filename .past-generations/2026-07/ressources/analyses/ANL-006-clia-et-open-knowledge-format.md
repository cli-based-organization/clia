---
type: analyse
version: 0.1.0
title: "clia face à l'Open Knowledge Format : opportunité et impact"
date: 2026-07-18
---

# ANL-006 - clia face à l'Open Knowledge Format : opportunité et impact

- **Périmètre** : le système de ressources livrables **documentaires** de `clia` (`.dev/plans`, `.dev/fondations`, `.dev/analyses`, `.dev/adr`, `.dev/specs`, `.dev/requis`, `.dev/bugs`, `.dev/principes`, `.dev/logs/ia-output`, `.dev/ressources.yaml`), confronté au Google Open Knowledge Format (OKF). Ressources mobilisées : `ADR-004` (typologie/versionnage), `ADR-005` (généricité), `ADR-007` (architecture), `CLAUDE.md`/`CONSTITUTION.md` (interface fichiers), `ANL-010-principes-de-conception-du-repo` (principes P1..P10). Exclusions : contenu métier.
- **Référence** : `FND-012-llm-wiki-okf-gestion-connaissance`.

## Objet

Analyser de façon critique `clia`, en lien avec ses ressources documentaires, au regard du savoir sur le LLM Wiki, l'OKF et les systèmes sémantiques. Dire s'il est une bonne idée d'adopter l'OKF de Google, quel impact (modifications nécessaires) cela aurait, et terminer par des recommandations. L'analyse recommande ; elle n'exécute aucun changement.

## Périmètre et méthode

Grille : (1) situer `clia` dans le paysage LLM Wiki / OKF / ontologies (`FND`) ; (2) comparer, dimension par dimension (représentation, typage, métadonnées, cross-références, index/historique, versionnage, validation, interopérabilité), l'existant de `clia` aux conventions OKF ; (3) évaluer l'opportunité d'adoption et son impact ; (4) confronter aux principes de conception du dépôt (`ANL-010-principes-de-conception-du-repo`).

## Constats

**C1. `clia` est déjà, de fait, une instance du pattern LLM Wiki.** Ses ressources sont un **répertoire de fichiers markdown curés, typés, versionnés et maintenus directement par l'agent**, avec l'**interface = fichiers, pas conversation** comme principe (`CONSTITUTION.md`, principe P4). C'est exactement la définition du LLM Wiki (`FND` §1) : une base de connaissances markdown lue dans le contexte, tenue à jour par le LLM. `clia` n'a pas « à adopter » le pattern : il l'incarne déjà.

**C2. `clia` dépasse déjà l'OKF sur le plan sémantique.** OKF v0.1 n'exige qu'un champ `type` et laisse la sémantique aux producteurs (`FND` §3, interop **structurelle** seulement). Or `clia` possède un **modèle sémantique riche** : typologie à six axes et cycle de vie (`ADR-004`), un **skill par type** faisant office de spécification vivante, versionnage semver par ensembles, validation de format (`ses check`). `clia` est donc **plus formalisé** que le socle OKF ; il se situe plus haut sur le spectre de la `FND` (§4), entre le markdown typé et l'ontologie.

**C3. Ce qu'OKF apporterait néanmoins à `clia` : l'interopérabilité structurelle et l'outillage.** OKF standardise une couche que `clia` implémente aujourd'hui de façon **bespoke** :
- un **frontmatter YAML uniforme avec `type`** (et champs réservés `title`, `description`, `tags`, `timestamp`) sur **chaque** ressource, parsable par tout agent OKF sans connaître les conventions maison ;
- des **cross-références en liens markdown** formant un **graphe** consommable et visualisable (visualiseur HTML statique d'OKF) ;
- la **portabilité** : un dossier `.dev/` conforme OKF serait consommable par d'autres agents/outils OKF, hors de Claude Code.
`clia` ne bénéficie de rien de tout cela aujourd'hui : ses métadonnées vivent en **puces d'en-tête** hétérogènes (sauf les logs, en frontmatter), et ses cross-références sont des **mentions par nom** (« `ADR-004` »), pas des liens markdown.

**C4. Écarts structurels de `clia` vs OKF.**
- **Métadonnées non uniformes** : les logs utilisent un frontmatter YAML ; les autres ressources portent leurs métadonnées en puces (`Statut`, `Version`, `Date`, `Objectif`). OKF voudrait un frontmatter YAML partout, avec `type` explicite (aujourd'hui implicite via le préfixe de nom et le titre H1).
- **Cross-références** : par nom, non par lien markdown → pas de graphe navigable automatiquement.
- **Index / historique** : `clia` a `.dev/ressources.yaml` (manifeste de versions) et `.dev/logs/ia-output` (traces) là où OKF prévoit `index.md` (par répertoire) et `log.md` (par concept) — **recouvrement fonctionnel** à arbitrer, pas simple équivalence.

**C5. Impact d'une adoption (modifications nécessaires).** Adopter l'OKF n'est pas trivial :
- **Amender tous les skills** (structure du livrable) pour émettre un **frontmatter OKF** (`type` + champs réservés) sur chaque type de ressource, en plus (ou à la place) des puces d'en-tête actuelles.
- **Migrer les ressources existantes** vers ce frontmatter (opération mécanique mais massive ; les ressources point fixe déjà produites posent la question de l'immuabilité, `ADR-004`).
- **Formaliser les cross-références en liens markdown** dans les templates et, idéalement, l'existant.
- **Décider du mapping** entre le modèle `clia` et OKF : `type` OKF ↔ préfixe/typologie `clia` ; puces d'en-tête ↔ frontmatter ; `ressources.yaml`/logs ↔ `index.md`/`log.md`. Sans ce mapping, on duplique.
- Cet effort relève de la **réécriture d'`ADR-004`** déjà prévue (recadrage humain « Ressources livrables »), à laquelle cette analyse est directement pertinente.

**C6. Tensions et cohérence avec les principes de conception.**
- **Généricité (P3, `ADR-005`)** : OKF est « format, pas plateforme », sans SDK ni domaine → **compatible** avec la généricité du harnais ; faible verrou.
- **Interface fichiers (P4)** : OKF **renforce** ce principe (il le standardise).
- **Source de vérité unique (P6)** : attention au recouvrement `ressources.yaml`/logs vs `index.md`/`log.md` — adopter les deux créerait une **duplication** contraire à P6 ; il faut choisir/mapper.
- **IA-si-nécessaire / simplicité (P2, KISS)** : le frontmatter OKF ajoute un coût, mais faible, et l'agent le tient à jour (les LLM sont bons à cette tenue de livre, `FND` §1) → aligné avec le pattern, à condition de ne pas empiler OKF **par-dessus** les puces existantes (dédupliquer).
- **Maturité** : OKF est **v0.1**, interop sémantique déférée ; adopter tout maintenant, c'est parier sur un standard mouvant. Le bas coût (frontmatter `type`, liens) est peu risqué ; le reste peut attendre.

## Est-ce une bonne idée d'adopter l'OKF ?

**Réponse nuancée : oui, de façon sélective ; non, de façon totale ou remplaçante.**

- **Oui** pour la **couche d'interopérabilité structurelle** : un frontmatter YAML avec `type` (+ champs réservés) et des cross-références en liens markdown. Gains réels : portabilité inter-agents, alignement sur un standard émergent, outillage graphe, uniformité des métadonnées. Coût maîtrisé, cohérent avec P3/P4.
- **Non** pour un **remplacement** du modèle de `clia` par le minimalisme OKF : `clia` possède déjà une sémantique (typologie, versionnage, validation) **supérieure** à OKF v0.1 ; l'abandonner pour « juste `type` » serait une régression. OKF doit se poser **par-dessus** le modèle sémantique de `clia`, comme couche d'échange, pas à sa place.

## Recommandations

1. **Traiter l'OKF comme une couche d'interop structurelle, non comme le modèle sémantique.** `clia` conserve sa typologie (`ADR-004`), ses skills-spécifications et son versionnage ; OKF ajoute la portabilité.
2. **Uniformiser les métadonnées en frontmatter YAML** avec un champ `type` explicite (mappé sur le préfixe/typologie `clia`) et les champs réservés utiles (`title`, `description`, `tags`, `timestamp`), en **remplaçant** les puces d'en-tête (pas en les doublant, pour respecter P6). À décider et cadrer dans la **réécriture d'`ADR-004`** (recadrage humain à venir).
3. **Formaliser les cross-références en liens markdown** pour constituer un graphe navigable (et exploiter l'outillage OKF).
4. **Arbitrer le recouvrement** `ressources.yaml`/`logs` vs `index.md`/`log.md` : décider si `clia` conserve son manifeste + logs (recommandé, car plus riches et déterministes) et **mappe** vers OKF à l'export, plutôt que d'adopter `index.md`/`log.md` en doublon.
5. **Adopter par étapes vu la v0.1** : d'abord le bas coût (frontmatter `type` + liens), différer toute dépendance à des conventions OKF non stabilisées (interop sémantique). Réévaluer à la maturation d'OKF.
6. **Trancher par ADR** (lié à `ADR-004`) : la décision d'adoption sélective et le mapping `clia ↔ OKF` méritent une décision tracée, d'autant que l'export OKF pourrait servir les futurs livrables multi-dépôts (`PLN-012`/`PLN-013`).

## Portée et péremption

Couverture : l'état des ressources documentaires de `clia` au 2026-07-18 (harness-files 0.5.0) confronté à OKF v0.1. Limites : l'analyse porte sur l'opportunité et l'impact de principe, pas sur une migration détaillée ni sur un banc d'essai OKF réel. Péremption : OKF v0.1 est mouvant ; la réécriture d'`ADR-004` et l'évolution du standard rendront cet état des lieux caduc.
