---
type: objection
id: NON-identite-et-nommage
title: "Identité, nommage et préfixes des ressources"
status: draft
initiateur: agent
effet: bloquant
etat: ouverte
porte-sur: [RES-ressource, RES-objection]
---

# NON-001 - Identité, nommage et préfixes des ressources

> Le premier jet de `RES-001` décide que l'identité d'une ressource est le champ `id` et non son numéro de séquence. Cette décision engage tous les renvois du système et n'a pas été arbitrée.

## Journal

- 2026-08-09 : ouverte par l'agent, à la production du premier jet des ressources fondamentales.

## Ce qui est contesté

Deux choses.

D'abord, la proposition de `RES-001` : l'identité d'une ressource est le champ `id`, de la forme `<PREFIXE>-<SLUG>`, le numéro de séquence n'étant plus qu'un ordre d'apparition. Cette proposition s'écarte de l'état de l'art du corpus, `RES-001` de `micrologic-clients`, qui pose que l'identité d'une ressource est son chemin.

Ensuite, la coexistence de deux préfixes pour l'objection : `NON` demandé par `CLAUDE.md` et par la session, `OBJ` en usage dans `micrologic-clients` avec quatre instances et une définition.

## Pourquoi cela ne peut pas rester implicite

Le fait mesuré est établi par `ANL-001`, défaut D1 : dans le corpus, douze numéros de skill sur vingt portent plusieurs noms distincts selon le dépôt. `skl-004` désigne cinq skills différents, `skl-006` en désigne quatre. Un dépôt porte sept ADR dont trois paires de doublons de titre, jamais détectées.

`CLAUDE.md` désigne aujourd'hui chaque type de ressource par un triplet `ADR-XXX, RES-XXX, skl-XXX`. Si cette désignation est conservée, elle est fausse dès qu'un deuxième dépôt est équipé, et le système ne peut pas être partagé. Si elle est abandonnée, il faut décider par quoi elle est remplacée avant d'écrire des centaines de renvois.

Le coût de l'indécision est asymétrique : décider maintenant coûte un champ de frontmatter, décider dans six mois coûte la réécriture de tous les renvois du corpus.

## Questions

### Q1 - L'identité d'une ressource est-elle le champ `id`, ou reste-t-elle le chemin ?

`RES-001` propose le champ `id`. La position concurrente, celle de `micrologic-clients`, est que l'identité est le chemin, ce qui ne coûte rien mais rend tout reclassement destructeur.

**Réponse.**

### Q2 - Si l'identité est `<PREFIXE>-<SLUG>`, que se passe-t-il quand deux dépôts emploient le même `id` pour des choses différentes ?

Exemple concret : `INT-intention-ultime` dans quinze dépôts désigne quinze intentions différentes. Faut-il un espace de noms, par exemple `<depot>:<PREFIXE>-<SLUG>`, ou l'identité est-elle locale au dépôt par construction, avec les renvois inter-dépôts traités autrement ?

**Réponse.**

### Q3 - `NON` ou `OBJ` pour l'objection, et qui paie la migration ?

`CLAUDE.md` dit `NON`. L'usage établi dit `OBJ`. `ANL-001` mesure qu'un changement de préfixe a déjà coûté six corrections manuelles dans un seul dépôt. Trois positions : imposer `NON` partout, revenir à `OBJ`, ou déclarer que `NON` est le préfixe de `clia` et `OBJ` un synonyme écarté inscrit à l'ontologie.

**Réponse.**

### Q4 - Le numéro de séquence doit-il rester dans le nom de fichier ?

S'il ne porte plus l'identité, il ne sert plus qu'à l'ordre de lecture et à l'ancienneté. Deux positions : le conserver, parce qu'il donne un ordre gratuit et une trace de chronologie ; le supprimer, parce que sa présence invite à s'en servir comme identifiant, ce qui est précisément le défaut à corriger.

**Réponse.**

### Q5 - Que devient un renvoi par numéro déjà écrit ?

`CLAUDE.md` en contient vingt-sept triplets. Les archives de `clia` en contiennent des centaines. Faut-il les migrer, les laisser en place comme renvois historiques assumés, ou les traiter au fil de l'eau lorsqu'un document est touché ?

**Réponse.**

### Q6 - Un renommage de slug est-il un changement d'identité ou une correction ?

`RES-001` propose de le traiter comme un changement d'identité, avec `remplace` et `est-remplacee-par`. C'est rigoureux et coûteux : corriger une faute de frappe dans un slug crée alors une ressource morte. Faut-il une tolérance, par exemple un champ `id-anterieurs` qui conserve les identités abandonnées sans créer de ressource ?

**Réponse.**

### Q7 - Qui attribue le numéro de séquence ?

Aujourd'hui, personne : l'agent le déduit du contenu du répertoire, ce qui produit des collisions dès que deux travaux avancent en parallèle. Faut-il que ce soit `clia`, ce qui reporte la question à la session d'outillage, ou l'humain, ou une règle qui rende les collisions inoffensives ?

**Réponse.**

## Ce qui lèverait cette objection

Une réponse aux questions Q1, Q2 et Q3, qui sont les trois qui engagent la forme des renvois. Q4 à Q7 peuvent rester ouvertes sans bloquer, à condition que Q1 soit tranchée.

Si Q1 est tranchée en faveur du champ `id`, l'objection passe en `conditionnel` et les sept définitions restent valides. Si Q1 est tranchée en faveur du chemin, les sept définitions doivent être révisées et leur champ `id` retiré.

## Relations

- `objecte-a` [RES-001](../ressources/RES-001-ressource.md)
- `objecte-a` [RES-004](../ressources/RES-004-objection.md)
- `derive-de` [ANL-001](../analyses/ANL-001-observation-corpus-repos-et-pratiques/analyse-critique.md)
