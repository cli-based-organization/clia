---
type: principe-de-conception
id: PDC-002
title: "Ergonomie de l'identification interne"
version: 0.1.0
status: draft
maturity: conception
adoption: propose
activated: true
portee: systeme
---

# PDC-002 - Ergonomie de l'identification interne

> À l'interne, un humain désigne une ressource par une chaîne qu'il peut lire, retenir et taper. Aucun besoin d'unicité, de robustesse ou de traçabilité ne prévaut sur cette exigence.

## Objet

Fixer l'ergonomie de l'identification interne comme exigence opposable.

Demandé par `NON-001` Q11, répondue le 2026-08-10 : « L'ergonomie interne est une exigence non négociable. »

## Le principe

Un identifiant interne satisfait trois contraintes.

| Réf | Contrainte | Seuil |
|---|---|---|
| **E1** | Lisible : la chaîne dit à quel type appartient la ressource | Le préfixe est alphabétique et signifiant |
| **E2** | Retenable : la chaîne tient en mémoire de travail | Au plus 8 caractères |
| **E3** | Tapable : la chaîne se saisit sans copier-coller | Lettres majuscules, chiffres, un trait d'union. Aucun accent, aucune casse mixte, aucun caractère hors ASCII |

Le format par défaut est `<PREFIX>-<SEQ>`, fixé par `ADR-008` D2. Il satisfait les trois contraintes : `RES-001` compte sept caractères, se lit, se retient et se tape.

**Le principe est opposable.** Un arbitrage entre l'ergonomie interne et une autre propriété se tranche en faveur de l'ergonomie, ou produit une objection.

## Ce qu'il exclut

| Exclu | Motif |
|---|---|
| Un identifiant opaque comme identifiant interne, `UUID`, hachage, horodatage | Viole E1 et E2 |
| Une commande qui exige un identifiant externe complet | L'identifiant externe est fait pour les tiers, `ADR-008` D1 |
| Une commande qui exige un hachage de version pour désigner une ressource | Viole E2 et E3 |
| Un identifiant sensible à la casse ou aux accents | Viole E3 |
| Un allongement de l'identifiant au nom de l'unicité globale | L'unicité globale relève du régime externe |

**Ce qu'il n'exclut pas.** Que ces formes soient acceptées **en plus** de l'alias. Un `UUID` ou un hachage peuvent être des entrées valides ; ils ne peuvent pas être les seules.

## Comment le vérifier

Trois contrôles, tous exécutables.

**V-E1. Le jeu de caractères.** Tout alias du dépôt vérifie `^[A-Z]{2,4}-[0-9]{3}(-[0-9]{2})?$`. C'est le motif `#Id` de `commun.cue`, déjà appliqué à chaque frontmatter.

**V-E2. La longueur.** Aucun alias ne dépasse 8 caractères. Mesure du 2026-08-10, sur les alias des ressources du dépôt, hors gabarits et archives.

| Longueur | Alias | Forme |
|---|---|---|
| 7 | **92** | `<PREFIX>-<SEQ>`, conforme |
| 10 | **7** | `<PREFIX>-<SEQ>-<NN>`, atomes de `ANL-001`, **hors seuil** |

**V-E3. L'acceptation par le CLI.** Toute commande de `clia` qui prend une ressource en argument accepte `<PREFIX>-<SEQ>`. Vérifiable en appelant chaque commande avec un alias connu.

## Conséquence d'une violation

Une violation de E1, E2 ou E3 rend le système inutilisable sans copier-coller. C'est le seuil auquel un humain cesse de désigner une ressource et se met à la chercher.

Une commande qui viole ce principe est un défaut, non un choix d'implémentation. Elle se corrige, ou elle produit une objection qui expose l'arbitrage.

Le dépôt porte une violation connue : les sept atomes de composite en `<PREFIX>-<SEQ>-<NN>`, à 10 caractères, contestés par `NON-019` Q3 pour un autre motif. Quatre-vingt-douze alias sur quatre-vingt-dix-neuf sont conformes.

## Relations

- `derive-de` [ADR-008](../adr/ADR-008-regime-d-identification-a-deux-niveaux.md)
- `reference` [RES-001](../ressources/RES-001-ressource.md)
- `reference` [NON-001](../objections/NON-001-identite-et-nommage.md)
- `reference` [NON-019](../objections/NON-019-identifiant-par-sequence.md)
