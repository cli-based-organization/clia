---
type: objection
id: NON-010
title: "Rôles des trois agents et conditions de production"
status: draft
initiateur: agent
effet: conditionnel
etat: ouverte
porte-sur: [ADR-002]
---

# NON-010 - Rôles des trois agents et conditions de production

> `ADR-002` répartit les rôles entre l'humain, l'agent IA et `clia`, mais quatre points de cette répartition sont indéterminés, et la demande qui l'a fait écrire contient une remarque tronquée qui porte précisément sur l'un d'eux.

## Journal

- 2026-08-09 : ouverte par l'agent, à la production de `ADR-002`.

## Ce qui est contesté

Une ambiguïté dans la demande, et quatre indéterminations du processus.

L'ambiguïté est matérielle. La tâche 4 de `workspace/session.md` porte, dans ses remarques, la ligne suivante, laissée inachevée :

```
- les ressources créés par
```

La phrase s'arrête là. Elle porte manifestement sur les ressources produites par un agent, sans que l'on sache lequel ni ce qui devait en être dit. `ADR-002` a donc été écrit sans cette remarque, et rien ne garantit qu'il ne la contredit pas.

Les quatre indéterminations portent sur les droits de `clia`, sur la production d'une ressource dont le type n'existe pas, sur l'exigence d'un plan préalable, et sur la forme de la réponse conversationnelle.

## Pourquoi cela ne peut pas rester implicite

La remarque tronquée est le cas d'école du dispositif que `ADR-002` D6 institue : une ambiguïté identifiée doit être signalée au moment où elle est identifiée, faute de quoi l'agent la résout en silence et sa résolution devient un fait accompli que personne n'a décidé.

Les quatre indéterminations ont un point commun : elles décident ce que l'agent peut faire sans autorisation. `ANL-001` mesure ce que produit le silence sur ce point. Un `INTENTION.md` écrasé par l'agent avec du contenu générique. Quatre-vingt-quatorze dépôts sur cent soixante-six sans remote, dans un système où l'agent n'a pas le droit de mentionner git. Trois tâches exécutées le 2026-08-09 sans le plan préalable que le processus antérieur exigeait, sans que personne ne le relève sur le moment.

## Questions

### Q1 - Que devait dire la remarque « les ressources créés par » ?

La phrase est tronquée dans la demande. Trois hypothèses, parmi d'autres : les ressources créées par l'agent appartiennent au dépôt et non à l'agent ; les ressources créées par `clia` ne sont pas des ressources mais des fichiers d'état ; les ressources créées par l'humain échappent au régime d'édition de leur type. Chacune conduirait à un `ADR-002` différent.

**Réponse.**

### Q2 - `clia` peut-il muter des fichiers en édition humaine exclusive ?

`ADR-002` D1 reprend la position du `CONSTITUTION.md` archivé : oui, parce que `clia` est déterministe et opéré par l'humain, donc c'est l'humain qui agit via son outil. Cette position est élégante et elle a une conséquence lourde : elle fait de `clia` le seul chemin par lequel un fichier protégé peut changer sans intervention manuelle. Est-elle confirmée ?

**Réponse.**

### Q3 - L'agent peut-il produire une ressource dont le type n'a pas de définition ?

Le cas est réel et il est présent dans cette tâche. `PLN-001` a été produit alors qu'aucune définition du type Plan n'existe dans ce dépôt : le préfixe `PLN` vient du corpus, la structure de l'imitation. La règle A5 de `skl-001-ressource` dit d'ouvrir une objection plutôt que de produire une instance non conforme qui ferait précédent ; l'agent a fait les deux, en produisant et en objectant. Est-ce la bonne conduite, ou fallait-il s'abstenir ?

**Réponse.**

### Q4 - Un plan doit-il précéder l'exécution ?

Le `CONSTITUTION.md` archivé l'exigeait, avec un cycle de vie à cinq états, proposé, objection, résolu, approuvé, exécuté. Les trois premières tâches de la session du 2026-08-09 ont été exécutées sans plan. `ADR-002` ne tranche pas et se contente de signaler l'écart. Cet écart retire à l'humain le point de contrôle qui précède la production.

**Réponse.**

### Q5 - La réponse conversationnelle de l'agent doit-elle se limiter à une phrase ?

Le `CONSTITUTION.md` archivé le prescrivait : chemin du fichier produit et résumé d'une phrase. La règle n'a pas été tenue le 2026-08-09. Deux lectures s'affrontent. Soit la règle est juste, et l'agent doit s'y plier. Soit la réponse conversationnelle a une fonction propre, rendre lisible ce qui vient d'être produit et porter les objections avant qu'elles soient écrites, et la règle doit être révisée.

**Réponse.**

### Q6 - L'agent doit-il pouvoir signaler l'état de versionnage sans y toucher ?

Le harnais interdit à l'agent de réaliser, proposer ou suggérer toute opération git. `ANL-001` mesure au défaut D5 le résultat de cette règle conjuguée à la pratique observée : quatre-vingt-quatorze dépôts sans remote, quarante-cinq sans aucun commit, soixante-et-un avec du travail non commité, dont le document de stratégie de l'entreprise et la théorie des ressources du système. La règle protège la responsabilité de l'humain et laisse son travail non protégé. Signaler un état, sans rien modifier ni rien suggérer, la violerait-il ?

**Réponse.**

### Q7 - Qui arbitre lorsque l'agent maintient une objection que l'humain lève ?

Question déjà posée par `NON-008` Q4 et reprise ici parce qu'elle appartient à la répartition des rôles. `RES-004` prévoit un état `levee-par-decision` mais ne dit pas si l'agent doit alors exécuter, refuser, ou exécuter en consignant son désaccord.

**Réponse.**

## Ce qui lèverait cette objection

Une réponse à Q1, qui est une simple complétion de la demande, et à Q4, qui décide si l'humain conserve un point de contrôle avant production.

Les autres questions peuvent rester ouvertes sans empêcher le travail. L'effet est `conditionnel` : `ADR-002` est utilisable en l'état, et ce qui est produit sur sa base est réputé provisoire jusqu'à résolution.

## Relations

- `objecte-a` [ADR-002](../adr/ADR-002-adoption-du-processus-de-travail.md)
- `reference` [RES-004](../ressources/RES-004-objection.md)
- `reference` [NON-008](NON-008-regime-de-travail.md)
- `reference` [PLN-001](../plans/PLN-001-point-d-entree-et-analyse-de-la-demande.md)
