# Interprétation de la demande, tâche 5

## Demande

Tâche 5 de `workspace/session.md`, intitulée `[conception] Adoption de l'usage d'un cli exensible => clia`. Trois livrables enchaînés.

1. Une recherche de fondation (FND) sur l'usage des CLI et son renouveau à l'ère du cloud computing et du contrôle et de la manipulation de ressources.
2. Une analyse (ANL) tenant compte de `ANL-001` et du FND précédent, répondant à la question : `clia` doit-il appartenir à ce dépôt ou être développé dans un dépôt indépendant ?
3. Un premier jet d'ADR à propos de l'usage de `clia`.

## Intention

Fonder l'adoption d'un CLI sur autre chose qu'une préférence. La chaîne demandée est méthodologiquement juste : la recherche établit les faits, l'analyse tranche une question locale à partir de ces faits et de ceux du corpus, l'ADR décide et trace ce qui a été écarté.

## Portée retenue

**La recherche est sourcée.** Le corpus définit une fondation comme une recherche en profondeur, exhaustive et sourcée. Cinq recherches web ont été menées pour vérifier les faits datés plutôt que de les tirer de mémoire : conception orientée ressources, guides de conception de CLI, dates de mise à disposition d'outils, arguments sur les CLI comme surface d'outillage des agents. Quatorze sources sont listées en fin de document, avec leur autorité inégale signalée.

**L'analyse répond, elle ne survole pas.** La question posée est fermée et attend une réponse. Quatre options sont évaluées sur sept critères, chacun rattaché à un fait mesuré, et la réponse est donnée avec son critère de renversement.

**L'ADR décide de l'usage, pas de la spécification.** La session annonce qu'une prochaine session sera dédiée à l'outillage. L'ADR décide donc que le CLI existe, pourquoi, selon quel modèle, où il vit et ce qu'il ne fait pas. Il ne décide ni de la grammaire des commandes, ni du langage, ni du mécanisme d'extension. Cette borne est déclarée dans le document, et elle est motivée : `ANL-001` établit au défaut D8 que le harnais actuel prescrit sept commandes `clia` dans un dépôt sans exécutable, et décrire une interface avant de l'avoir est l'erreur à ne pas répéter.

## Ambiguïtés et non-conformités identifiées, signalées comme le processus l'exige

**Quatre types employés sans définition.** Les trois livrables de cette tâche appartiennent à des types qui n'ont aucune définition dans ce dépôt : `fondation`, `analyse`, `adr`. Le contrôle V3 de `skl-001-ressource`, qui vérifie les champs obligatoires déclarés par un type, leur est donc inapplicable. Combiné aux constats de la tâche 4, cela fait sept types employés sans définition sur neuf. Signalé par `NON-011`.

**Deux instances nommées en contradiction avec RES-001.** `RES-001` déclare que les types au cycle `point-fixe`, dont les analyses et les fondations, se nomment par date. `FND-001` et `ANL-002` sont nommés par séquence. Le choix a été fait sciemment, pour ne pas faire cohabiter deux conventions dans le même répertoire, `ANL-001` ayant été nommé par séquence sur demande de la tâche 1. Non conforme et déclaré. Signalé par `NON-011` Q2.

## Directives inexécutables constatées et traitement retenu

| Directive | État | Traitement |
|---|---|---|
| Un skill encadre la production d'une fondation | N'existe pas ici. `skl-002-recherche-de-fondation` existe dans le corpus | Structure dérivée du corpus, sources et limites explicitées |
| Un skill encadre la production d'une analyse de corpus | N'existe pas ici | Structure dérivée de `ANL-001`, produit à la tâche 1 |
| Les types `fondation`, `analyse`, `adr` ont une définition | Aucune | Instances produites avec objection ouverte. Voir ci-dessus |
| Les ressources `point-fixe` sont nommées par date | Contredit par l'usage du dépôt | Séquence retenue pour la cohérence locale, non-conformité déclarée |
| `clia` valide les ressources produites | Aucun exécutable | Contrôles manuels de `skl-001-ressource` |

## Ce que la tâche ne demandait pas et qui n'a pas été fait

Aucune spécification de commande, aucun code, aucun `setup.sh`. `ADR-003` D8 pose que restaurer le `setup.sh` archivé est la première tâche d'outillage, sans la faire.

Aucun dépôt créé ni aucun fichier déplacé : `ADR-003` D4 décide que `clia` reste ici et que l'extraction est préparée, non faite.
