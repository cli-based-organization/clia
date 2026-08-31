# Résultat de la validation, tâches 10, 11 et 12

## Tâche 12 : conforme, et le défaut était six fois plus large

**Avant correction**, six verbes sur sept répondaient à `-h` par une erreur d'argument. `clia config ls -h` affichait la configuration sans aide, ce qui est un septième cas d'une nature différente.

**Après correction**, les neuf verbes répondent par leur usage propre, avec un code de retour nul.

| Vérification | Résultat |
|---|---|
| Les neuf verbes répondent à `-h` et `--help` | conforme |
| Le code de retour d'une demande d'aide est 0 | conforme |
| L'aide d'un verbe est propre à ce verbe | conforme |
| L'aide est reconnue avant la validation des arguments | conforme |
| L'usage général renvoie vers l'aide détaillée | conforme |
| Assertions de non-régression | 24 ajoutées, 91 au total, toutes vertes |

## Deux bogues supplémentaires trouvés pendant la validation

**`clia res ls` comparait le titre au type.** Deux lignes apparaissaient pour un seul type. Corrigé : le décompte compare désormais le nom canonique. Quatrième manifestation de la confusion entre l'affichage et l'identité dans cette session.

**Les gabarits étaient comptés comme instances.** `RES-001` les place hors du modèle. `templates` est désormais exclu par défaut. C'est la réponse d'implémentation à `NON-012` Q6.

**Conséquence mesurable des deux corrections** : `clia res ls` n'affiche plus aucun type sans définition. Les trente types employés sont tous définis, ce qui n'était pas le cas au début de la journée.

## Validation de schéma : conforme

Les cinq livrables documentaires valident leur schéma CUE. Un défaut a été trouvé et corrigé pendant la validation : `PDC-001` portait `type: principe` alors que le type canonique de `RES-012` est `principe-de-conception`.

## Forme : conforme, après une correction

Un faux positif a été trouvé et corrigé dans `MET-001` : l'exemple de format de citation contenait un lien markdown factice `(url)`, que le contrôle V5 signalait comme lien cassé. L'exemple a été reformulé sans lien.

## Tâche 10 : conforme, avec un test qui échoue et c'est le résultat

`ADR-006` porte sept décisions, chacune avec son motif. Le test de D4 a été appliqué à l'état actuel du dépôt : **il échoue**, la grammaire du CLI n'existant que dans le code.

Cet échec est le résultat de la validation, non son défaut. Une décision de séparation stricte dont le test réussirait immédiatement n'aurait rien mesuré.

La contradiction entre `ADR-006` D2, qui interdit de nommer une technologie dans la spécification, et `ADR-001` D2, qui nomme le markdown et le YAML, est déclarée dans les deux documents et portée par `NON-018` Q2. Elle n'est pas tranchée.

La dette de spécification est chiffrée : 1 600 lignes de code, 91 tests, zéro spécification, cinq types de préparation définis sans aucune instance.

## Tâche 11 : conforme

Les trois critiques de l'humain sont reprises avec une mesure chacune : trente lignes par question, quatre sources par question, zéro référence complète.

Le tableau de résultat attendu compare le seuil à l'obtenu sur dix critères. `FND-002` échoue sur deux : la densité et le format de citation. Il satisfait les huit autres.

Les six modes d'échec distinguent les quatre observés dans ce dépôt des deux seulement possibles.

La rubrique « Éprouvé sur » déclare que la méthodologie n'a jamais été employée telle quelle et qu'elle est dérivée d'un échec. C'était la seule rédaction honnête.

## Réserve d'ensemble

Trois décisions de cette journée portent des tests ou des règles que le système ne satisfait pas encore : le test de `ADR-006` D4, l'exigence d'agnosticisme de `ADR-006` D2, et le contrôle manuel des harnais de `PDC-001`.

Les trois échecs sont déclarés là où ils se produisent. C'est préférable à des règles calibrées pour être satisfaites, mais cela porte le nombre de règles écrites et non tenues, ce que `NON-005` conteste depuis le 2026-08-09.
