# Résultat de la validation, tâche 7

## Méthodologie imposée : respectée

Les sept étapes sont présentes, dans l'ordre, et nommées. Huit questions de recherche, chacune répondue à l'étape 7. Quatorze domaines de savoir, dont les sept suggérés et sept ajoutés avec leur motif de pertinence. Quatorze axes d'analyse.

Une exigence de la demande n'a pas pu être satisfaite littéralement : identifier **tous** les axes d'analyse pertinents. Quatorze sont proposés et un quinzième est nommé comme absent de la littérature, l'ergonomie de saisie. Rien ne garantit l'exhaustivité, et le document ne la revendique pas.

## Références : 32 URL, toutes interrogées

| Résultat | Nombre | Traitement |
|---|---|---|
| Répondent normalement | 28 | |
| Bloquées par un obstacle local | 2 | `softwareheritage.org`, chaîne de certificats du poste. Vérifiées sans validation TLS, elles répondent 200. Valides |
| Refusent les requêtes automatisées | 1 | Éditeur académique. Doublée d'un miroir accessible et vérifié |
| URL mortes | **0** | |

Deux améliorations ont été faites pendant la validation, et elles portent sur la crédibilité.

Une affirmation sur le versionnage sémantique reposait sur un billet de blogue. Elle renvoie désormais à la spécification elle-même.

L'article de Philipson sur les identifiants pérennes et FAIR n'était accessible que chez un éditeur qui refuse les requêtes automatisées. Il est désormais doublé d'un miroir vérifié, la notice de l'éditeur restant citée.

L'état de vérification est consigné dans le document, avec sa date.

## Contenu : conforme, avec une réserve nommée

Chaque question reçoit une réponse. Chacune des cinq propositions de conclusion est rattachée à au moins une source.

Les quatre controverses du champ sont présentées comme telles. La plus importante, la réfutation présumée du trilemme de Zooko, reçoit une réserve méthodologique explicite : la source est une encyclopédie collaborative, la réfutation d'une conjecture de conception est un jugement et non un fait, et la conjecture elle-même n'a jamais été démontrée formellement. Le document en tire la position prudente et le dit.

**Réserve.** La proposition 1 est la plus exposée du document : elle repose sur une conjecture énoncée sur une liste de diffusion en 2001. Elle sert néanmoins de cadre à l'objection `NON-014`, dont l'effet est déclaré bloquant. Cette dépendance est signalée dans les limites de `FND-002`.

## Analyse : conforme

`clia` est positionné sur les quatorze axes, avec un verdict par axe : cinq justes, six indéterminés, trois faux.

Chacune des dix suggestions est rattachée à une proposition de `FND-002` et à un fait de `ANL-001`, avec son coût. Elles sont ordonnées par rapport entre effet et coût. Cinq refus sont motivés.

Quatre objections que l'analyse porte contre elle-même sont écrites, dont la plus gênante : dix suggestions sont beaucoup pour un système qui n'a pas de deuxième utilisateur, et rien ne prouve que ce travail soit nécessaire maintenant.

## Objections : conformes

Chaque question ajoutée porte sa date et le document qui la fonde. Les journaux de `NON-001`, `NON-006` et `NON-012` sont mis à jour.

Le `NON-013` de l'humain n'a subi aucune modification, y compris pour être rédigé. Il porte « À rédiger » et son initiateur est l'humain, ce que le régime hybride de `RES-004` protège.

## L'incident de numérotation, et sa résolution

`clia res new` a attribué le numéro 013 à l'objection de l'agent, alors qu'une objection de l'humain le portait déjà, créée la veille avec le même outil et non commitée.

Diagnostic : l'outil n'a pas échoué, il a pris le maximum plus un correctement. Le défaut est de conception, le numéro s'obtenant par observation d'un état, et un état observé à deux moments donnant deux résultats.

Résolution : l'objection de l'agent est renumérotée en `NON-014`, celle de l'humain est conservée, l'index est corrigé, et le titre interne du fichier renuméroté est mis à jour. Vérifié par `clia res ls objection`, qui affiche désormais quatorze objections aux numéros distincts.

L'incident est consigné comme deuxième preuve empirique dans le journal de `NON-001`, dont la question Q7 l'avait annoncé la veille.

## Forme : conforme

Les trois livrables produits et les quatre fichiers modifiés passent les contrôles V1, V2, V4, V5, V6 et V8 de `skl-001-ressource`. Les identifiants restent uniques sur tout `.dev/`.

## Écart de nommage, inchangé

`FND-002` et `ANL-003` sont nommés par séquence alors que `RES-001` prescrit un nommage daté pour les types au cycle point fixe. Le choix suit la cohérence locale, `ANL-001` ayant été nommé par séquence sur demande de l'humain à la tâche 1. Non-conformité déjà portée par `NON-011` Q2, et non aggravée : elle concerne désormais cinq fichiers au lieu de trois.
