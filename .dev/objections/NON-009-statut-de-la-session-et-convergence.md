---
type: objection
id: NON-statut-de-la-session-et-convergence
title: "Statut de la session et critère de convergence"
status: draft
initiateur: agent
effet: bloquant
etat: ouverte
porte-sur: [ADR-adoption-du-processus-de-travail, ADR-adoption-de-la-notion-de-ressource, RES-intention]
---

# NON-009 - Statut de la session et critère de convergence

> `ADR-001` D8 exclut la session du modèle de ressources, au motif qu'elle est éphémère. `ADR-002` D2 en fait l'unité de segmentation du travail, porteuse d'une intention, de livrables et d'un critère de convergence. Les deux ne peuvent pas être vrais ensemble.

## Journal

- 2026-08-09 : ouverte par l'agent, à la production de `ADR-002`.

## Ce qui est contesté

Trois choses, liées.

Le **statut de la session**. `ADR-001` D8 la place hors du modèle avec les gabarits et le matériel source, au motif qu'elle est « éphémère par destination ». `ADR-002` D2 lui confie ce qu'un dépôt a de plus durable : son intention de travail, ses livrables et son critère d'achèvement.

Le **critère de convergence**, introduit par la tâche 4 de la session du 2026-08-09 et par la section `# CRITÈRE DE CONVERGENCE` de `workspace/session.md`. Il n'a ni définition, ni type, ni place dans le modèle, et il ressemble beaucoup à un champ que `RES-003` a déjà défini sous un autre nom.

L'**emplacement du point d'entrée**. Deux fichiers coexistent aujourd'hui sur le disque avec des contenus différents : `workspace/session.md`, désigné par `CLAUDE.md`, et `.dev/session.md`, utilisé par tout l'historique du dépôt. Aucune objection formelle n'avait encore été ouverte là-dessus, alors que le point est signalé depuis l'ouverture de la session.

## Pourquoi cela ne peut pas rester implicite

Une session qui porte l'intention d'un chantier de deux semaines et son critère d'achèvement n'est pas éphémère : c'est le document le plus consulté du dépôt pendant toute sa durée. Le corpus le confirme, avec quatre sessions archivées de 37 heures à 14 jours, dont une portant quarante-quatre tâches.

Si la session n'est pas une ressource, alors elle échappe au frontmatter, au typage, à la validation et au versionnage, et l'information la plus structurante du travail vit dans un document non modélisé. `ANL-001` mesure ce que produit une telle exception : `INTENTION.md`, autre fichier hors modèle en édition humaine exclusive, a été écrasé une fois par l'agent et copié à l'identique dans trois dépôts en désignant le mauvais client.

Si la session est une ressource, alors `ADR-001` D8 doit être révisé, et il faut décider ce qui reste hors du modèle et pourquoi.

Sur le critère de convergence, le risque est différent et plus discret : celui d'un troisième nom pour la même chose. `ANL-001` mesure une dérive lexicale non contrôlée dans le corpus, avec cinq mots pour un même objet dans cinq dépôts. Introduire « critère de convergence » à côté du « critère de satisfaction » de `RES-003` sans dire ce qui les distingue est exactement le geste qui produit cette dérive.

## Questions

### Q1 - La session est-elle une ressource ?

Trois positions. Elle en est une, et `ADR-001` D8 doit être révisé. Elle n'en est pas une, et `ADR-002` D2 doit expliquer comment un objet hors modèle peut porter l'intention du travail. Ou bien il faut distinguer le fichier de session, éphémère, de la session comme objet du processus, qui serait la ressource.

**Réponse.**

### Q2 - Le critère de convergence est-il un champ de la session ou une ressource distincte ?

S'il est un champ, il disparaît avec le fichier de session, ce qui contredit sa fonction : il est justement ce qui permet de dire, plus tard, si le travail a abouti. S'il est une ressource, il en faut le type.

**Réponse.**

### Q3 - Quel est le rapport entre critère de convergence et critère de satisfaction de `RES-003` ?

`RES-003` rend obligatoires deux critères sur toute intention : un critère de satisfaction, qui dit à quoi on reconnaîtra que le but est atteint, et un critère de trahison. Le critère de convergence d'une session semble être le critère de satisfaction de l'intention de cette session. Sont-ils la même chose sous deux noms, ou y a-t-il une distinction à tenir ?

**Réponse.**

### Q4 - Qui déclare la convergence, et sur quelle base ?

Le critère est écrit par l'humain. Sa satisfaction est-elle constatée par l'humain, par l'agent, ou par `clia` s'il devient vérifiable ? Le critère de la session en cours, « le concept de ressource est bien défini, utilisable et instrumenté », n'est pas mécaniquement vérifiable en l'état.

**Réponse.**

### Q5 - Que devient une session qui ne converge pas ?

Le corpus n'a aucun exemple de session déclarée non convergée : les quatre sessions archivées sont toutes closes. Or `ANL-001` mesure que vingt-deux pour cent des tâches journalisées sont déclarées partielles. Une session peut-elle se clore en déclarant que son critère n'est pas atteint, et où cela s'écrit-il ?

**Réponse.**

### Q6 - Une session archivée est-elle une trace immuable ?

`resource-types.yaml` classait les sessions comme traces immuables en édition humaine, mutées par `clia`. La règle d'immuabilité n'est tenue nulle part dans le corpus, ce que `NON-005` Q2 porte déjà. La question propre à la session est autre : si le critère de convergence est ajouté en cours de route, comme il l'a été le 2026-08-09, la session n'est pas immuable pendant sa vie, et son archivage est le seul moment où elle le devient.

**Réponse.**

### Q7 - Le point d'entrée est-il `workspace/session.md` ou `.dev/session.md` ?

Les deux fichiers existent avec des contenus différents. `CLAUDE.md` désigne le premier, l'historique du dépôt et les quatre sessions archivées utilisent le second. `ANL-001` relève par ailleurs une troisième variante dans le corpus, `session.md` à la racine, dans `ontpe/dossier-president`. Tant que la question n'est pas tranchée, chaque session s'ouvre sur une ambiguïté.

**Réponse.**

## Ce qui lèverait cette objection

Une réponse à Q1, Q3 et Q7.

Q1 résout la contradiction entre les deux ADR. Q3 évite un troisième nom pour la même chose. Q7 est une correction matérielle qui ne demande aucune théorie.

L'effet est déclaré `bloquant` pour une raison précise : `ADR-002` D2 fait de la session l'unité du travail, et il n'est pas tenable d'acter cette décision alors que le statut et l'emplacement de la session sont tous deux indéterminés.

## Relations

- `objecte-a` [ADR-002](../adr/ADR-002-adoption-du-processus-de-travail.md)
- `objecte-a` [ADR-001](../adr/ADR-001-adoption-de-la-notion-de-ressource.md)
- `reference` [RES-003](../ressources/RES-003-intention.md)
- `reference` [NON-008](NON-008-regime-de-travail.md)
