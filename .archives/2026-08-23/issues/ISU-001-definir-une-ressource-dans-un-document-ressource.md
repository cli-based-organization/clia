---
type: issue
id: ISU-001
title: "Définir une ressource dans un document ressource"
status: draft
maturity: conception
adoption: propose
activated: true
domain-status: "ouverte"
initiateur: humain
etat: ouverte
ouverture: 2026-08-11
---

# ISU-001 - Définir une ressource dans un document ressource

> Une ressource doit pouvoir être définie à l'intérieur d'une autre, sans fichier propre. Un concept dans une ontologie en est le cas d'usage déclencheur. Rien n'implémente ce mécanisme, et son adresse, sa validation et sa promotion ne sont pas décidées.

## Journal

- 2026-08-11 : ouverte à la demande de l'humain, réponse Q1 de `NON-004` : « nous avons besoin de pouvoir définir une ressource dans un document ressource. Comment implémenter ce feature ? documenter un ISU à propos de cette question ».

## La problématique

Une ontologie est un ensemble de concepts et de leurs relations. Un concept important, employé à plusieurs endroits, mérite un fichier `CPT`. Un concept qui ne l'est pas doit pouvoir vivre **dans** le fichier `ONT`, sans cesser d'être une ressource.

Le besoin dépasse ce cas. Toute ressource devrait pouvoir en contenir une autre : un requis dans une spécification, un comportement attendu dans un cas d'usage, une décision dans un fragment.

Trois choses manquent.

**L'adresse.** Comment désigner une ressource qui n'a pas de fichier.

**La validation.** Comment vérifier son frontmatter, puisqu'un fichier n'a qu'un seul frontmatter en tête.

**La promotion.** Comment un concept qui devient important sort de son hôte pour prendre un fichier, sans casser les renvois qui le citaient.

## Ce qui la rend difficile

**L'identité et le fichier sont couplés dans l'outillage.** `clia res ls` compte des fichiers. `clia res show` résout un identifiant vers un chemin. `clia res new` crée un fichier. Les trois supposent qu'une ressource est un fichier.

**Le schéma cuelang porte sur un frontmatter unique.** La chaîne de validation extrait le bloc entre les deux premiers `---` du fichier. Une ressource imbriquée n'a pas cet emplacement.

**La promotion casse les renvois.** Si l'adresse d'un concept imbriqué dérive de son hôte, sortir le concept change son adresse. C'est exactement le défaut que `ADR-008` D3 traite pour les alias, avec une obligation de propagation que rien n'outille.

**Le décompte devient ambigu.** `ADR-004` pose qu'un composite compte pour une ressource. Une ontologie portant huit concepts compte-t-elle pour une, pour neuf, ou pour une et huit ?

## Ce qui a été tenté

**Le recueil de faits, `RES-005`.** C'est le seul précédent du dépôt, et il fonctionne. Un recueil `FCT` porte un sujet ; chaque fait y est numéroté `F<NN>` et porte une adresse citable de la forme `FCT-001#F03`.

Le mécanisme est en usage : `FCT-001` porte dix faits ainsi numérotés, et `ANL-006` en cite plusieurs.

**Sa limite.** Un fait n'a pas de frontmatter propre, pas de type déclaré, pas de cycle de vie. C'est une entrée, non une ressource au sens de `RES-001`.

**L'atome de composite, `ADR-004` D3.** Un composite est un répertoire, chaque atome est un fichier de plein droit. `ANL-001` en porte sept, adressés `ANL-001-01` à `ANL-001-07`.

**Sa limite.** L'atome reste un fichier. Le besoin est précisément de s'en passer, et `PDC-002` relève que la forme à dix caractères de ces adresses sort du seuil d'ergonomie.

## Pistes

Aucune n'est retenue. Elles sont notées pour ne pas être redécouvertes.

**P1. Le modèle du recueil, généralisé.** Une entrée numérotée dans le document hôte, adressée `<HOTE>#<PREFIX><NN>`. Simple, éprouvé, et ne donne pas de frontmatter à l'entrée.

**P2. Un frontmatter imbriqué.** Un bloc délimité dans le corps de l'hôte, portant son propre frontmatter YAML. Donne une vraie ressource, et demande un analyseur que le dépôt n'a pas.

**P3. Un champ de déclaration dans l'hôte.** L'hôte liste, dans son frontmatter, les ressources qu'il contient et leurs propriétés. La validation reste sur un frontmatter unique, au prix d'une duplication entre la déclaration et le corps.

**P4. Pas d'imbrication.** Une ressource est toujours un fichier ; ce qui vit dans un document est une entrée, non une ressource. C'est la position actuelle, implicite, et elle contredit la réponse Q1.

**Ce que P1 et P2 partagent.** Les deux demandent que `clia res show` sache résoudre une adresse à fragment, et que le décompte distingue les ressources des entrées.

## Ce qui la clôturerait

Une décision sur l'adresse et sur le statut de l'imbriqué : ressource de plein droit, ou entrée.

La question de la promotion peut rester ouverte : elle ne se pose qu'au premier concept promu.

## Relations

- `derive-de` [NON-004](../objections/NON-004-frontiere-savoir.md)
- `reference` [RES-006](../ressources/RES-006-ontologie.md)
- `reference` [RES-007](../ressources/RES-007-concept.md)
- `reference` [RES-005](../ressources/RES-005-fait.md)
