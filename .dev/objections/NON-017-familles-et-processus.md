---
type: objection
id: NON-familles-et-processus
title: "Familles fonctionnelles, attribution et processus par famille"
status: draft
initiateur: agent
effet: bloquant
etat: ouverte
porte-sur: [RES-ressource, ADR-regroupement-fonctionnel-des-ressources]
---

# NON-017 - Familles fonctionnelles, attribution et processus par famille

> `ADR-005` D4 attache le processus de production à la famille et non au type, ce qui réduit le travail de vingt-neuf skills à six. C'est une proposition de l'agent, non une décision de l'humain, et la tâche 8 demandait littéralement un skill par ressource.

## Journal

- 2026-08-10 : ouverte par l'agent, aux tâches 8 et 9 de la session du 2026-08-09.

## Ce qui est contesté

Trois choses, de poids décroissant.

**L'écart avec la demande.** La tâche 8 demande, pour toute ressource, un skill, un schéma CUE de frontmatter, un gabarit, et un schéma CUE d'entrée de gabarit. Les trois derniers ont été produits pour les trente types, par dérivation mécanique des définitions. Le premier ne l'a pas été : six skills de famille ont été écrits au lieu de vingt-neuf skills de type.

**Cinq arbitrages d'attribution.** `ADR-005` D3 range les types dans les six familles, alors que l'énoncé de la tâche 8 ne donne que quatre exemples. Cinq arbitrages sont signalés : l'entrevue en contenu plutôt qu'en implémentation, le plan en préparation bien qu'absent de `CLAUDE.md`, l'ADR en préparation bien que discutable, le préfixe `CDE` retenu contre le `COD` de la demande, et les traces dans aucune famille.

**L'hypothèse de D4 n'est pas vérifiée partout.** Elle suppose un processus commun par famille. C'est vrai pour la conception ; `ADR-005` D4 reconnaît que c'est douteux pour l'implémentation, où un code et une présentation n'ont rien en commun.

## Pourquoi cela ne peut pas rester implicite

Deux raisons.

**Le volume est la question, et elle est mesurée.** Vingt-neuf skills de type auraient produit vingt-neuf documents dont la majeure partie serait identique. `ANL-001` mesure au défaut D2 ce que devient une duplication non tenue : trente-trois `CLAUDE.md` pour dix-huit contenus distincts. Écrire vingt-neuf skills serait reproduire ce défaut volontairement.

**Mais l'écart avec la demande reste un écart.** Il est motivé, réversible et déclaré, et il n'a pas été autorisé. L'humain peut légitimement exiger les vingt-neuf.

## Questions

### Q1 - Le skill est-il attaché à la famille ou au type ?

Six skills de famille, comme `ADR-005` D4 le propose, ou vingt-neuf skills de type, comme la tâche 8 le demande. Une position intermédiaire existe : un skill de famille, plus un skill de type pour les seuls types dont le processus s'écarte.

**Réponse.**

### Q2 - L'entrevue appartient-elle à la famille contenu ou implémentation ?

`CLAUDE.md` la place en implémentation. `ADR-005` D3 la range en contenu, au motif que la tâche 8 la cite elle-même parmi les mécanismes d'entrée.

**Réponse.**

### Q3 - Le préfixe du code est-il `CDE` ou `COD` ?

`CLAUDE.md` écrit `CDE`, la tâche 8 écrit `COD`. `CDE` a été retenu par conformité au harnais.

**Réponse.**

### Q4 - L'ADR appartient-il à la famille préparation ?

`CLAUDE.md` l'y place. Un ADR acte une décision plutôt qu'il ne prépare une réalisation, et sa proximité avec la `DCN`, rangée en contenu, mérite examen.

**Réponse.**

### Q5 - Où rangent les traces, log et session ?

`ADR-005` D5 constate que les six familles ne les accueillent pas et refuse de les y ranger par commodité. La question recoupe `NON-011` Q6.

**Réponse.**

### Q6 - Faut-il produire une `DCN` pour les ADR qui n'existent pas ?

La tâche 8 demande une `DCN` pour les ADR-001 à ADR-014. Le dépôt en compte cinq. Trois `DCN` ont été produites pour les trois ADR antérieurs, au statut `proposee` puisqu'aucun n'est acté. Rien n'a été produit pour ADR-006 à ADR-014.

**Réponse.**

### Q7 - Les quatre principes de `linux-inspect` doivent-ils devenir des `PDC` ?

Universalité, adaptabilité, non-intrusivité, réflexivité. `ANL-001` relève qu'ils sont plus opérationnels que la plupart des principes produits ensuite et qu'ils n'ont jamais été promus. `RES-012` existe désormais pour les accueillir.

**Réponse.**

## Ce qui lèverait cette objection

Une réponse à Q1. Elle décide si le travail restant est de six documents ou de vingt-neuf, et aucune autre question de cette objection n'a ce poids.

L'effet est `bloquant` pour cette raison : produire vingt-trois skills supplémentaires avant de savoir s'ils sont voulus serait exactement le coût que `NON-002` conteste.

## Relations

- `objecte-a` [ADR-005](../adr/ADR-005-regroupement-fonctionnel-des-ressources.md)
- `reference` [NON-002](NON-002-cout-du-modele.md)
- `reference` [NON-011](NON-011-types-employes-sans-definition.md)
