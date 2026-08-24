# Ce qui a été fait, tâches 10, 11 et 12

## Livrables

| Fichier | Tâche | Contenu |
|---|---|---|
| `.dev/adr/ADR-006-separation-specification-implementation.md` | 10 | Sept décisions, un critère de départage en une question |
| `.dev/decisions/DCN-006-separation-specification-implementation.md` | 10 | Enregistrement de la décision, `effet: en-vigueur` |
| `.dev/methodologies/MET-001-recherche-de-fondation.md` | 11 | Dix étapes, format de citation, seuils mesurés |
| `.dev/principes/PDC-001-auto-decouvrabilite.md` | 12 | Le principe, ce qu'il exclut, comment le vérifier |
| `.dev/objections/NON-018-specification-et-implementation.md` | 10 | 7 questions, effet `bloquant` |
| `lib/clia/*.sh` | 12 | Aide par verbe sur les neuf verbes |
| `tests/test_clia.sh` | 12 | 24 assertions de plus, 91 au total |

Les cinq livrables documentaires valident leur schéma CUE. Les 91 tests passent.

## Tâche 12 : le défaut était six fois plus large que signalé

L'humain signale `clia res new -h`. Six verbes sur sept étaient atteints, tous par la même cause : la validation des arguments précédait la reconnaissance de l'aide.

**Correction générique.** Une fonction `clia_is_help` dans `core.sh`, appelée en première ligne de chaque verbe, avant toute validation. Neuf aides propres écrites, une par verbe, décrivant ce que le verbe fait, ce qu'il refuse et ses alias. L'usage général renvoie désormais vers l'aide détaillée.

**Vingt-quatre assertions de non-régression.** Les quatre verbes de `resource` et les quatre de `configuration` sont vérifiés sur `-h` et `--help`, avec le code de retour, et trois assertions vérifient que l'aide d'un verbe est propre à ce verbe, que l'aide passe avant la validation, et que l'usage général renvoie vers l'aide détaillée.

**`PDC-001`, premier principe de conception du dépôt.** Trois gestes doivent suffire à découvrir le système : invoquer sans argument, demander l'aide, demander l'aide d'un niveau plus fin. Le principe énonce quatre interdits reconnaissables sans jugement, dont celui qui a été violé : un message d'erreur qui constate sans orienter.

Deux des trois contrôles du principe sont automatisés.

## Deux bogues supplémentaires trouvés en chemin

**`clia res ls` comparait le titre au type.** Le décompte des instances comparait le titre lisible de la définition au champ `type` des instances, faisant apparaître deux lignes pour un seul type : « Principe de conception » à zéro instance, et « principe-de-conception » sans définition. C'est la **quatrième manifestation** de la confusion entre l'affichage et l'identité, après l'adresse contre l'identité à la tâche 6 et deux cas à la tâche 8.

**Les gabarits étaient comptés comme instances.** Un gabarit porte le champ `type` de son type, et `RES-001` place explicitement les gabarits hors du modèle. `templates` est désormais exclu par défaut, aux côtés de `archives`. C'est la réponse d'implémentation à la question Q6 de `NON-012`.

Après ces deux corrections, `clia res ls` n'affiche **plus aucun type sans définition** : les trente types employés par le dépôt sont tous définis.

## Tâche 10 : la séparation, et le test qu'elle fait échouer

`DCN-006` enregistre la décision, `ADR-006` l'instruit en sept décisions.

Le critère de départage tient en une question : **cet artefact reste-t-il vrai si l'on change de langage d'implémentation ?** Si oui, spécification ; si non, implémentation.

| Décision | Objet |
|---|---|
| D1 | Deux corpus, un critère en une question |
| D2 | La spécification ne nomme aucune technologie |
| D3 | L'implémentation déclare ce qu'elle implémente |
| D4 | La spécification survit à la suppression de l'implémentation |
| D5 | Une spécification manquante est une dette nommée |
| D6 | Les artefacts dérivés sont de l'implémentation |
| D7 | Décision de nature, non de rangement : aucun fichier déplacé |

**Le fait qui fonde la décision.** `ANL-001` mesure onze CLI réinventés en vingt-et-un mois, dont neuf abandonnés et un jamais commité malgré un CLI Go fonctionnel. Chacun emportait sa conception ; aucun ne laissait de spécification réutilisable. Le douzième refait le même chemin.

**Le test de D4 échoue aujourd'hui.** Supprimer `bin/`, `lib/`, `tests/`, `.dev/schemas/` et `.dev/templates/` retirerait la grammaire des commandes, les formes d'identifiant acceptées et le format des sorties, qui n'existent que dans le code. Le test est écrit pour être exécutable, et son échec est déclaré.

**La dette devient mesurable.** 1 600 lignes de bash et 91 tests, face à zéro spécification. Les types `SPC`, `RQF`, `RQNF`, `USE` et `CMP` sont définis depuis la tâche 8 et n'ont aucune instance. Ce chiffre était invisible avant cette décision.

**Une contradiction interne est ouverte.** `ADR-006` D2 interdit de nommer une technologie dans la spécification ; `ADR-001` D2 nomme le markdown et le YAML. Porté par `NON-018` Q2.

**Le risque symétrique est nommé.** `disruptiva-dev/comm-cli` a produit une spécification complète et aucune ligne de code, et il est mort en deux jours. Valoriser la spécification sans garde-fou reproduirait cet échec. `NON-018` Q6 demande quelle garde poser.

## Tâche 11 : la méthodologie, dérivée d'un échec

`MET-001` reprend la critique de l'humain avec des mesures, et en tire dix étapes.

**Les trois constats, chiffrés.** Deux cent soixante-sept lignes pour huit questions, soit trente lignes par question là où une revue universitaire en consacre plusieurs pages. Trente-deux sources, soit quatre par question là où le seuil est de dix. Et des citations sans auteur exact, sans titre complet, sans pagination, sans identifiant pérenne, sans date de consultation par source.

**Les sept étapes de la tâche 7 sont conservées** : vérification du livrable, questions de recherche réfutables, inventaire sémantique, tous les domaines, tous les axes, revue historique par vagues, analyse critique.

**Trois étapes sont ajoutées**, et elles répondent aux trois défauts. Répondre aux questions en séparant l'établi de l'interprété. Vérifier les références en distinguant l'URL morte, l'URL bloquée localement et l'URL refusant les requêtes automatisées. Et mesurer la densité, en disant ce qui manque plutôt qu'en laissant croire à l'exhaustivité.

**Un format de citation par nature de source.** Cinq natures, chacune avec ses éléments requis. Une source secondaire porte obligatoirement la mention de son caractère secondaire.

**Un tableau de résultat attendu**, qui compare le seuil à ce que `FND-002` a atteint, ligne par ligne. Le tableau dit ce qui manque : la densité et le format de citation. Le reste du procédé tient.

**Six modes d'échec, dont quatre observés dans ce dépôt.** Survoler au lieu d'établir, citer sans référencer, prendre une source secondaire pour une primaire, et produire un format long pour un besoin court.

**Rubrique « Éprouvé sur ».** Deux cas, tous deux avec leurs défauts. La méthodologie n'a jamais été employée telle quelle et le déclare.

## Ce qui n'a pas été fait

Aucune spécification. `ADR-006` D5 en fait une dette nommée ; `NON-018` Q1 demande dans quel ordre les écrire.

Aucun déplacement des quatre-vingt-neuf artefacts dérivés, bien que `ADR-006` D6 les range du côté implémentation.

Aucune nouvelle fondation produite selon `MET-001`.

Aucune modification de `CLAUDE.md`, dont `ANL-001` mesure au défaut D8 qu'il documente sept commandes `clia` dont deux n'existent toujours pas.
