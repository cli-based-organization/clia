# Résultat de la validation, tâche 4

## Contrôles V1, V2, V4 à V8 : conformes

Les quatre livrables et les deux fichiers modifiés passent les sept contrôles applicables. Aucun fichier vide, frontmatter analysables portant `type` et `id`, aucun tiret cadratin ni filet hors exclusions, tous les liens relatifs résolvent, `id` uniques sur tout `.dev/` et cohérents avec leur nom de fichier, aucun marqueur de gabarit résiduel.

## V3 non applicable, et c'est une lacune du modèle

Le contrôle des champs obligatoires ne s'applique ni aux ADR, ni aux objections, ni au plan : aucun de ces trois types n'a de définition qui déclare ses champs obligatoires. Seul le type `ressource` en a une, produite par la tâche 2.

Trois des quatre livrables de cette tâche appartiennent donc à des types non définis. Pour l'objection, `RES-004` existe et déclare ses champs, ce qui rend le contrôle possible en pratique mais pas automatiquement, faute d'un chemin de définition standardisé. Pour l'ADR et le plan, rien.

C'est le même défaut que celui déjà signalé pour le plan par `NON-010` Q3, et il est plus large qu'on ne le croyait : la moitié des types que ce dépôt emploie effectivement n'ont pas de définition.

## Un faux positif de V8 corrigé, avec contre-épreuve

Le contrôle signalait `PLN-001` comme non conforme, pour trois occurrences du mot `TODO` dans des phrases qui désignent la note `TODO` de la demande à laquelle le plan répond.

Diagnostic : le défaut était dans le contrôle. Le motif cherchait `TODO` partout, sans distinguer un TODO laissé par l'auteur d'une mention du mot.

Correction : le motif ne se cherche plus qu'en tête de ligne, en tête de puce, ou suivi de deux points. Le motif `FIXME` est ajouté par symétrie.

Contre-épreuve exécutée sur un fichier de test portant une puce `- TODO: compléter cette section` et un motif `<SLUG>` en clair : les deux sont détectés. Le contrôle n'a pas été affaibli, il a été précisé.

Les vingt-neuf fichiers markdown produits par les quatre tâches de la session passent le contrôle corrigé.

## Contrôles de cohérence propres à la tâche

Les six axes de la demande sont chacun couverts par une décision identifiée : D3 analyse de la demande, D7 journalisation, D4 ressources typées, D5 harnais conventionnés, D6 objection par les deux agents, D2 segmentation par sessions.

Les trois remarques sont intégrées : signalement immédiat des ambiguïtés dans D6, critère de convergence différable dans D2, journalisation obligatoire dans D7.

Les quatre ambiguïtés et incohérences identifiées dans la demande sont chacune portées par une question d'objection, comme la demande l'exige.

Les liens croisés entre `ADR-002`, `NON-009`, `NON-010` et `PLN-001` résolvent dans les deux sens.

## Réserve sur le fondement des décisions

Sept décisions de `ADR-002` sur huit portent un motif renvoyant à une mesure de `ANL-001`, à un fait du corpus, ou à un constat de la session en cours.

La huitième, D4 sur le centrage de la production sur les ressources typées, renvoie à `ADR-001` D1 sans reprendre son motif. Ce n'est pas un défaut de fondement mais une conséquence du critère de départage : recopier le motif de `ADR-001` dans `ADR-002` créerait une source parallèle. La réserve est signalée pour que le renvoi soit lu comme intentionnel.

## Écart de journalisation, inchangé

Les fichiers des tâches 2, 3 et 4 portent un suffixe de tâche, ceux de la tâche 1 n'en portent pas. Le harnais ne dit pas comment journaliser plusieurs tâches d'une même session. L'asymétrie reste ; aucun fichier de la tâche 1 n'a été déplacé.
