# Résultat de la validation, tâche 3

## Contrôles V1 à V8 : conformes

Les dix fichiers de `.dev/adr/`, `.dev/skills/` et `.dev/ressources/` passent les huit contrôles. Aucun fichier vide, dix frontmatter analysables portant `type` et `id`, champs obligatoires présents, aucun tiret cadratin ni filet hors exclusions, tous les liens relatifs résolvent, dix `id` uniques et cohérents avec leur nom de fichier, aucun marqueur de gabarit résiduel.

Le contrôle V9, par empreinte, n'a pas d'objet ici : les trois fichiers sont nouveaux et propres à ce dépôt.

## Un défaut réel trouvé et corrigé pendant la validation

À la première exécution, V4 et V5 signalaient `skl-001-ressource/SKILL.md` comme non conforme : deux tirets cadratins et deux filets détectés, plus trois liens jugés cassés.

Diagnostic : les occurrences se trouvaient toutes dans les blocs de code du skill, soit dans les commandes de contrôle elles-mêmes, soit dans le gabarit de la partie B, soit dans les exemples de renvoi de la règle A4. Le défaut était dans les contrôles, non dans le document.

Le défaut est réel et non un artefact : un contrôle textuel qui ne distingue pas une mention d'un emploi est inutilisable sur un document de méthode, c'est-à-dire sur le type de document que ce système produit le plus.

Correction appliquée : V4, V5 et V8 excluent désormais le frontmatter, les blocs de code délimités par trois accents graves, et le code inline. La règle d'exclusion est énoncée en tête de la section de validation du skill, avec l'incident qui l'a fondée. Les contrôles corrigés ont été réexécutés sur les vingt-cinq fichiers markdown produits par les trois tâches de la session : tous conformes.

## Contrôles de cohérence propres à la tâche : conformes, avec une réserve

Les liens croisés entre `RES-001`, `ADR-001` et `skl-001` résolvent dans les trois sens.

Les champs `skill` et `adr` de `RES-001` pointent vers des fichiers existants, vérifié par résolution de chemin pour le skill et par comparaison d'`id` pour l'ADR.

Le critère de départage est tenu : le cycle de vie et le régime d'édition apparaissent dans `RES-001` comme propriétés, dans `ADR-001` comme motifs et alternatives écartées, dans `skl-001` comme ordre de décision. Aucun des trois ne recopie les deux autres.

**Réserve.** Sur les neuf décisions de `ADR-001`, huit portent un motif renvoyant à une mesure de `ANL-001` ou à un fait du corpus. La neuvième, D7 sur l'auto-application du méta-type, repose sur un argument logique et non empirique : un modèle dont le document central échappe à ses propres règles n'est pas un modèle. C'est assumé et signalé plutôt que masqué par une mesure forcée.

## Écart de journalisation, inchangé

Les fichiers des tâches 2 et 3 portent un suffixe de tâche, ceux de la tâche 1 n'en portent pas. Le harnais ne dit pas comment journaliser plusieurs tâches d'une même session. L'asymétrie reste, aucun fichier de la tâche 1 n'a été déplacé.
