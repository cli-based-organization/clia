---
type: objection
id: NON-014
title: "Le choix du trilemme de nommage : quelle propriété clia abandonne"
status: draft
initiateur: agent
effet: bloquant
etat: repondue
porte-sur: [RES-001, ADR-001, INT-intention-ultime]
---

# NON-014 - Le choix du trilemme de nommage : quelle propriété clia abandonne

> `FND-002` établit qu'un identifiant ne peut être à la fois lisible par un humain, unique globalement et attribué sans autorité centrale. `clia` a de fait abandonné l'unicité globale. Ce choix n'a jamais été fait explicitement, et l'`INTENTION.md` du dépôt promet précisément ce qu'il rend impossible.

## Journal

- 2026-08-10 : ouverte par l'agent, à la production de `FND-002` et `ANL-003`.
- 2026-08-11 : **objet partiellement dépassé**, noté au ménage de la tâche 30. `ADR-008` a tranché l'identité depuis : `<PREFIX>-<SEQ>` est un alias interne, non l'identité, et l'ergonomie est fixée comme exigence opposable par `PDC-002`. Le trilemme se pose désormais entre l'alias interne, l'identifiant externe non fixé, et l'identité de l'oeuvre sans porteur. L'objection n'est pas levée : sa question subsiste sous cette forme.
- 2026-08-13 : passe a `repondue` par `PLN-010`, chantier B. Critere mecanique : chaque question porte une reponse. Aucune reponse n'a ete interpretee.

## Ce qui est contesté

Le trilemme de Zooko énonce trois propriétés désirables d'un identifiant dans un protocole en réseau : être porteur de sens et mémorisable pour les utilisateurs, limiter le dommage qu'une entité malveillante peut causer, et se résoudre correctement sans autorité centrale. La conjecture est qu'aucun type de nom n'atteint plus de deux de ces propriétés ([Wikipédia](https://en.wikipedia.org/wiki/Zooko%27s_triangle)).

Appliqué à `clia`, le constat est net. L'identité `<PREFIXE>-<SLUG>` est **lisible** et s'attribue **sans autorité**. La troisième propriété est donc abandonnée : rien ne garantit qu'un `RES-001` d'un dépôt ne désigne pas autre chose qu'un `RES-001` d'un autre.

Ce que cette objection contredit n'est pas ce choix, qui est probablement le bon. C'est le fait qu'il n'ait jamais été fait, ni écrit, ni assumé.

## Pourquoi cela ne peut pas rester implicite

Trois raisons, de poids croissant.

**Le corpus paie déjà le prix de ce choix non fait.** `ANL-001` mesure au défaut D1 que douze numéros de skill sur vingt portent plusieurs noms selon le dépôt, `skl-004` en portant cinq. Ce n'est pas un accident de discipline : c'est exactement ce que produit un système lisible et sans autorité, employé dans plusieurs dépôts. La collision était prévisible, et rien ne la prévoyait.

**L'`INTENTION.md` du dépôt promet ce que le système d'identifiants ne peut pas tenir.** Il annonce des ressources bien définies, un cadre de collaboration entre humain, automatismes et agent IA, et des capacités de mobilisation et d'utilisation du savoir. Or `FND-002` établit que la réutilisation par une autre personne exige une résolution indépendante de l'émetteur, et que la réutilisation dans un autre projet exige une portée d'unicité qui dépasse le projet. Aucune des deux n'est disponible.

**Chaque amélioration d'unicité menace le seul avantage acquis.** `ANL-003` place `clia` sur quatorze axes et conclut que la lisibilité et l'ergonomie sont les deux seuls où le système fait mieux que ceux de la littérature. `FND-002` relève par ailleurs que l'ergonomie de saisie n'a aucune littérature : personne n'étudie le coût de taper un identifiant à la main. Cet avantage n'est donc défendu par rien, et il sera perdu au premier arbitrage s'il n'est pas écrit.

## Questions

### Q1 - L'abandon de l'unicité globale est-il assumé ?

Trois positions. L'assumer et l'écrire, ce qui est le geste le moins coûteux et rend les collisions attendues plutôt que subies. Le contester, en soutenant que le système doit garantir l'unicité globale, ce qui oblige à sacrifier la lisibilité ou à introduire une autorité. Ou ne rien dire, ce qui est l'état actuel et laisse le prochain défaut D1 se produire.

**Réponse.**

### Q2 - Si l'unicité globale devient nécessaire, laquelle des deux autres propriétés sacrifie-t-on ?

La question est prospective et elle doit être répondue avant d'être urgente. Deux chemins seulement.

Sacrifier la lisibilité, en adoptant un identifiant intrinsèque ou généré. `FND-002` établit que c'est la réponse de l'adressage par contenu, retenue par git, IPFS et le SWHID.

Sacrifier l'absence d'autorité, en déléguant à un espace de noms existant. La stratégie de Maven Central, qui emploie le nom de domaine inversé, délègue la gouvernance du nommage au DNS.

La suggestion S3 de `ANL-003` propose une troisième voie, qui n'est pas une échappatoire au trilemme mais un report : l'unicité globale n'est obtenue que dans l'identité étendue `<origine>:<PREFIXE>-<SLUG>`, l'identité locale restant lisible et sans autorité.

**Réponse.**

### Q3 - L'ergonomie est-elle une propriété de premier rang, opposable à une amélioration d'unicité ?

`FND-002` constate que l'axe de l'ergonomie n'a aucune littérature. Si elle n'est pas écrite comme exigence dans `RES-001`, elle n'existe pas comme argument.

La question est de savoir si une proposition future qui rendrait les identifiants plus sûrs mais moins dictables doit pouvoir être refusée pour ce seul motif.

**Réponse.**

### Q4 - L'affirmation de l'`INTENTION.md` sur la mobilisation du savoir tient-elle compte de cette limite ?

Question déjà posée sous une autre forme par `NON-004` Q7, et reprise ici avec un argument nouveau. `NON-004` la posait par une mesure sur le corpus, en relevant que le savoir accumulé n'est ni indexé ni relié. Cette objection la pose par une contrainte théorique : la réutilisation hors du dépôt exige des propriétés d'identifiant que le système a délibérément écartées.

`INTENTION.md` est en édition humaine exclusive. Seule l'humain peut trancher.

**Réponse.**

### Q5 - Faut-il un identifiant intrinsèque, et pour la vérification seulement ?

`FND-002` établit que seul l'identifiant intrinsèque est vérifiable sans son émetteur, et que la citation exige une information de fixité portée à côté du nom. La suggestion S4 de `ANL-003` propose une empreinte calculable à la demande, non stockée, employée pour la vérification et jamais pour la désignation.

Ce partage est la seule manière connue de gagner la vérifiabilité sans perdre la lisibilité. Est-il accepté ?

**Réponse.**

### Q6 - Que devient l'identité d'une ressource supprimée ?

Aucun document ne le dit, et la question est une conséquence directe du choix de l'identité par slug. Trois positions : l'identité est libérée et réattribuable, ce qui rend les renvois anciens trompeurs ; elle est retirée définitivement, ce qui suppose de tenir un registre des identités mortes ; ou une ressource ne se supprime pas et passe en `deprecated`, ce que `RES-004` prescrit déjà pour les objections.

**Réponse.**

### Q7 - Qui a autorité sur le slug ?

Le slug porte l'identité, donc la personne qui le choisit décide de l'identité. Aujourd'hui, c'est l'agent qui le dérive de la description fournie par l'humain, et `clia res new` applique cette dérivation mécaniquement.

Deux conséquences non traitées. Une description mal formulée produit une identité durable et mauvaise. Et deux descriptions différentes du même sujet produisent deux identités pour une seule oeuvre, ce qui est le mode de défaillance que `ANL-001` mesure sous le nom de réinvention, avec cinq occurrences de la même idée dans le corpus.

**Réponse.**

## Ce qui lèverait cette objection

Une réponse à Q1 et Q3.

Q1 transforme une propriété perdue par inadvertance en une propriété écartée par décision. Q3 protège la seule propriété que le système possède réellement.

L'effet est déclaré `bloquant` pour un motif précis : `ANL-003` propose dix suggestions dont plusieurs modifient le système d'identifiants, et aucune ne peut être arbitrée sans savoir quelle propriété le système accepte de perdre.

## Relations

- `objecte-a` [RES-001](../ressources/RES-001-ressource.md)
- `objecte-a` [ADR-001](../adr/ADR-001-adoption-de-la-notion-de-ressource.md)
- `objecte-a` [INTENTION.md](../../INTENTION.md)
- `derive-de` [FND-002](../fondations/FND-002-identifiants-dans-les-systemes-decentralises.md)
- `derive-de` [ANL-003](../analyses/ANL-003-systeme-d-identifiants-de-clia.md)
- `reference` [NON-001](NON-001-identite-et-nommage.md)
- `reference` [NON-004](NON-004-frontiere-savoir.md)
