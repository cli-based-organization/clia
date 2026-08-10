# Interprétation de la demande, tâches 8 et 9

## Demande

Deux tâches exécutées ensemble, à la demande de l'humain. La tâche 9 a été traitée en premier : elle change la définition de la ressource, donc tout ce que la tâche 8 produit en dépend.

**Tâche 9.** Une ressource est un ensemble identifiable et auto-cohérent d'informations, l'implémentation important peu. Une ressource est composable et atomique. Écrire une DCN et un ADR pour cette décision.

**Tâche 8.** Étendre les entrées possibles provenant de l'humain. Vérifier s'il existe d'autres mécanismes d'entrée que `source-material`, les objections et les entrevues. Ajouter les types Fragment `FRG` et Décision `DCN`. Écrire une DCN pour les ADR-001 à ADR-014. Acter le regroupement des ressources par fonction en six familles, par une DCN et un ADR. Décrire toutes les ressources annoncées par `CLAUDE.md` et non encore décrites. Et, pour toute ressource, fournir un skill, un schéma CUE de frontmatter, un gabarit markdown, et un schéma CUE des données du gabarit.

## Portée retenue, et l'écart assumé

La demande représente, prise littéralement, environ cent quarante-cinq fichiers : trente définitions, trente skills, soixante schémas, trente gabarits.

Trois choix ont borné le travail, tous déclarés et objectés.

**Les trois artefacts mécaniques sont générés, non rédigés.** Les soixante schémas CUE et les vingt-neuf gabarits sont **dérivés des définitions** par un script, à partir des champs `champs-obligatoires` et `sections` que chaque définition déclare. C'est l'application directe de `ADR-003` D7 : la couche machine-lisible est dérivée, jamais écrite à la main. Ils sont donc complets, cohérents par construction, et régénérables.

**Le skill est attaché à la famille, non au type.** Six skills de famille au lieu de vingt-neuf skills de type. C'est un écart avec la lettre de la demande, motivé par le regroupement fonctionnel que la tâche 8 demande justement d'acter, et porté par `NON-017` Q1 dont l'effet est bloquant. Vingt-neuf skills auraient produit vingt-neuf documents dont la majeure partie serait identique, ce qui est le défaut D2 que `ANL-001` mesure.

**Les définitions sont denses plutôt que longues.** Vingt-et-une définitions nouvelles ont été écrites, de quarante à soixante-dix lignes chacune, contre cent quarante pour les sept fondamentales de la tâche 2. Chacune porte son frontmatter complet, ce qu'est le type, ce qu'il n'est pas, son cycle de vie, son régime d'édition et ses points ouverts.

## Ambiguïtés et incohérences signalées

**Les ADR-006 à ADR-014 n'existent pas.** La demande porte sur les ADR-001 à ADR-014 ; le dépôt en comptait trois avant cette tâche, cinq après. Trois DCN ont été produites pour les trois ADR antérieurs, et aucune pour les inexistantes. Porté par `NON-017` Q6.

**Aucun ADR n'est acté.** Une DCN enregistre normalement une décision prise. Les cinq ADR portent le statut `propose`. La valeur `proposee` a été ajoutée au champ `effet` de `RES-009` pour permettre l'enregistrement d'une décision en attente, écart justifié dans la définition elle-même.

**Le mot « holographique » n'est pas défini.** Le titre de la tâche 9 le nomme, son corps ne l'explique pas. `ADR-004` D4 retient la lecture faible, chaque atome étant auto-cohérent, et le signale. Porté par `NON-016` Q1.

**Le préfixe du code.** La demande écrit `COD`, `CLAUDE.md` écrit `CDE`. `CDE` retenu par conformité au harnais. Porté par `NON-017` Q3.

**« Mettre â aussi dans la DCN et l'ADR ».** Phrase de la tâche 9, dont le mot central est illisible. Interprétée comme « mettre ça aussi », c'est-à-dire inclure la décision de composition dans les deux documents, ce qui est fait.

## Réponse à la question que la tâche 8 pose

La tâche demande de vérifier s'il existe d'autres mécanismes d'entrée. **Le relevé en trouve sept, dont trois n'étaient pas dans la liste de l'humain.** Le plus notable est la **réponse à une question d'objection** : cent une questions attendent une réponse écrite, ce qui en fait le mécanisme d'entrée le plus actif du dépôt, et il n'est pas modélisé. Le second est `source-material`, employé dans dix dépôts du corpus sans aucun type. Porté par `NON-015`.
