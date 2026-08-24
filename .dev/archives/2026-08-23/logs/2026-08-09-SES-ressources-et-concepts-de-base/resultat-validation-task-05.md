# Résultat de la validation, tâche 5

## Forme et cohérence : conformes

Les quatre livrables passent V1, V2, V4, V5, V6 et V8. Aucun fichier vide, frontmatter analysables portant `type` et `id`, aucun tiret cadratin ni filet hors exclusions, tous les liens relatifs résolvent, `id` uniques sur tout `.dev/`, aucun marqueur de gabarit résiduel.

## Deux contrôles inapplicables, et c'est l'objet d'une objection

**V3, champs obligatoires.** Aucun des trois types produits, `fondation`, `analyse`, `adr`, n'a de définition déclarant ses champs obligatoires. Le contrôle est donc sans objet. Combiné aux constats de la tâche 4, sept types sur neuf employés par ce dépôt sont dans ce cas.

**V7, cohérence entre l'`id` et le nom de fichier.** Le contrôle ne sait pas quoi attendre : `RES-001` prescrit un nommage daté pour les types au cycle `point-fixe`, et `FND-001` comme `ANL-002` sont nommés par séquence.

Les deux constats sont portés par `NON-011`, ouverte pour cela.

## Non-conformité déclarée

`FND-001` et `ANL-002` violent la règle de nommage de `RES-001`. Le choix a été fait sciemment, pour ne pas faire cohabiter deux conventions de nommage dans le même répertoire, `ANL-001` ayant été nommé par séquence sur demande de la tâche 1.

Trois positions restent tenables et appartiennent à l'humain : corriger `RES-001`, renommer les trois fichiers, ou reconnaître que le cycle de vie de ces types n'est pas `point-fixe`. La troisième mérite examen, `ANL-001` ayant été relu et corrigé après sa production, ce qu'un point fixe ne devrait pas subir.

## Contrôles propres à la recherche de fondation : conformes

Quatorze sources listées, chacune consultable. Les faits datés avancés sont rattachés à une source primaire quand elle existe : documentation officielle AWS, billet d'annonce GitHub, documentation Kubernetes, spécifications AIP de Google.

L'autorité inégale des sources est déclarée en tête et en fin de document : sources primaires, guides communautaires dont l'autorité vient de l'adoption, billets d'analyse récents et commerciaux pour certains.

Trois affirmations sont signalées comme rapportées et non vérifiées à la source primaire, dont le gain de 150 000 à 2 000 jetons attribué à Anthropic par une source secondaire.

La section d'interprétation en vue de `clia` est séparée de la recherche, et la séparation est déclarée en tête de section.

Les limites sont écrites, y compris ce que la littérature ne traite pas : aucune source sur un CLI dont les ressources sont des documents rédigés, aucune sur la localisation d'un outil par rapport au système qu'il outille, et aucune documentation des CLI orientés ressources qui ont échoué.

## Contrôles propres à l'analyse : conformes

La question posée reçoit une réponse explicite en tête de section dédiée.

Les sept critères d'évaluation sont chacun rattachés à un fait mesuré de `ANL-001` ou à une contrainte établie par `FND-001`.

Les trois options écartées le sont avec leur motif, et l'option écartée la plus proche de la réponse retenue, deux dépôts immédiatement, voit son argument le plus solide repris et nommé.

La réponse porte un critère de renversement en trois conditions constatables, dont la troisième mesure exactement la raison invoquée pour ne pas séparer maintenant.

Trois objections contre l'analyse elle-même sont écrites, dont celle qui la fragilise le plus : le couplage invoqué est peut-être un artefact de la phase, et quatre tâches d'une journée ne font pas une tendance.

## Contrôles propres à l'ADR : conformes, avec une réserve

Huit décisions sur neuf portent un motif renvoyant à `FND-001`, à `ANL-002` ou à un fait du corpus.

La neuvième, D5 sur le périmètre, est fondée par déduction : la règle découle du déterminisme posé en D1, et toute opération dont le résultat dépend d'un jugement sort du périmètre par construction. Elle cite `NON-001` Q7 et `ADR-001` D9 comme conséquences, non comme motifs. C'est le même cas que D7 de `ADR-001`, et il est signalé plutôt que masqué par une mesure forcée.

Les quatre reports de décision sont déclarés avec leur lieu : ordre des axes de la grammaire, langage, mécanisme d'extension, format des sorties, tous renvoyés à la session d'outillage.

La chaîne de dérivation est tracée dans les deux sens : l'ADR renvoie à l'analyse et à la recherche, l'analyse renvoie à la recherche et au corpus, la recherche renvoie aux ADR qu'elle sert.

## Une tension signalée et non résolue

`ADR-003` D7 pose qu'une source machine-lisible des types est nécessaire à `clia`, et que la faire coexister avec les définitions recréerait le défaut de duplication porté par `NON-002` Q6. La seule position tenable est qu'elle soit dérivée des définitions, et que la dérivation soit un travail de `clia`.

La circularité est réelle : l'outil qui doit produire la dérivation est celui dont l'existence dépend de la dérivation. Elle est écrite dans D7 comme tension, non comme problème résolu.

## Écart de journalisation, inchangé

Les fichiers des tâches 2 à 5 portent un suffixe de tâche, ceux de la tâche 1 non. Le harnais ne dit pas comment journaliser plusieurs tâches d'une même session.
