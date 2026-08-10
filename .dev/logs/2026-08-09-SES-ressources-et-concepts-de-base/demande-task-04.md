# Interprétation de la demande, tâche 4

## Demande

Tâche 4 de `workspace/session.md`, intitulée `[conception] Adoption du processus de travail` :

> Écrire un premier jet d'ADR pour définir le mécanisme de travail collaboratif du système d'information : Humain + IA + cli

Six axes sont énumérés : analyse de la demande ; journalisation ; centrage sur la production de livrables-ressources bien définis ; encadrement de l'IA par un ensemble conventionné de harnais ; émission d'objection par l'agent IA et par l'agent humain ; segmentation des sessions autour d'un objectif précis défini par intention plus livrable plus critère de convergence.

Trois remarques les accompagnent, dont une inachevée. Puis une note `TODO` demandant un plan pour la réécriture du point d'entrée et pour l'écriture d'un skill d'analyse de la demande, avec cinq étapes énumérées.

## Intention

Donner au processus de travail le même traitement que la tâche 3 a donné à la notion de ressource : une décision écrite, avec ses motifs, ses alternatives écartées et ses portes de sortie. `ADR-001` décide de la nature de ce que le travail produit ; `ADR-002` décide de la manière dont il le produit.

## Portée retenue

Deux livrables principaux, plus deux objections.

L'ADR est le livrable explicitement demandé, précédé d'un tiret. Il couvre les six axes, intègre les trois remarques et acte les deux ruptures que la pratique a déjà consommées par rapport au `CONSTITUTION.md` archivé.

Le plan est demandé par la note `TODO`, qui emploie un verbe d'action et énumère cinq étapes. La note est indentée dans le corps de la tâche 4, au même niveau que les remarques, ce qui la rattache à cette tâche. Ne pas produire le plan aurait rétréci la portée sans autorisation. La lecture inverse est possible et signalée : `PLN-001` porte une objection sur le fait que la forme du plan n'a pas été spécifiée.

Les deux objections sont exigées par la demande elle-même : « toute ambiguïté et incohérence ou déviation par rapport à l'objectif ultime est signalé au moment de l'identification par une objection (NON) ».

## Ambiguïtés et incohérences identifiées, signalées comme la demande l'exige

**Une remarque tronquée.** La ligne `- les ressources créés par` s'arrête là. Elle porte sur les ressources produites par un agent, sans que l'on sache lequel ni ce qui devait en être dit. Signalée par `NON-010` Q1. L'ADR a été écrit sans cette remarque, et rien ne garantit qu'il ne la contredit pas.

**Une incohérence entre deux ADR.** `ADR-001` D8 exclut la session du modèle de ressources au motif qu'elle est éphémère. La tâche 4 en fait l'unité de segmentation du travail, porteuse d'une intention, de livrables et d'un critère de convergence. Les deux ne peuvent pas être vrais ensemble. Signalée par `NON-009` Q1.

**Un terme nouveau sans définition.** Le « critère de convergence » est introduit par la tâche 4 et par une section nouvelle de `workspace/session.md`. Il ressemble au « critère de satisfaction » que `RES-003` rend déjà obligatoire sur toute intention. `ANL-001` mesure une dérive lexicale non contrôlée dans le corpus, avec jusqu'à cinq mots pour un même objet. Signalé par `NON-009` Q3.

**Un type sans définition.** Le plan demandé est produit sous le type `plan`, préfixe `PLN`, qui n'a aucune définition dans ce dépôt. La règle A5 de `skl-001-ressource` prescrit d'ouvrir une objection plutôt que de produire une instance non conforme. L'agent a fait les deux : il a produit et il a objecté. Signalé par `NON-010` Q3.

## Directives inexécutables constatées et traitement retenu

| Directive | État | Traitement |
|---|---|---|
| Le processus de gouvernance vit dans `CONSTITUTION.md` | Fichier archivé le 2026-08-08, aucun document en vigueur ne le porte | Repris depuis `.dev/archives/CONSTITUTION.md`, en distinguant ce qui a été éprouvé de ce qui ne l'a pas été |
| L'agent propose un plan avant toute exécution, cycle à cinq états | Non tenu : les trois premières tâches de la session ont été exécutées sans plan | Écart constaté et signalé dans `ADR-002` D8 et par `NON-010` Q4. Non corrigé de ma propre initiative |
| La réponse textuelle de l'agent se limite au chemin du fichier et à une phrase | Non tenu dans cette session | Écart signalé, question portée par `NON-010` Q5 |
| Un skill encadre la production d'un ADR et d'un plan | Aucun n'existe | Format dérivé de `ADR-001` pour l'ADR, du corpus pour le plan |
| Le type `plan` a une définition | N'existe pas | Instance produite malgré tout, avec objection. Voir ci-dessus |

## Ce que la tâche ne demandait pas et qui n'a pas été fait

La réécriture de `CLAUDE.md` : la note demande un plan, pas son exécution. `CLAUDE.md` est intact.

L'écriture du skill d'analyse de la demande : même raison. `PLN-001` en décrit le contenu attendu en cinq temps.

La correction des écarts constatés entre processus écrit et processus pratiqué. Les signaler relève de l'agent ; décider s'ils sont des fautes ou des révisions relève de l'humain.
