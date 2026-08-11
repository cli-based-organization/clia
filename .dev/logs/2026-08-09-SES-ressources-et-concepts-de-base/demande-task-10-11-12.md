# Interprétation de la demande, tâches 10, 11 et 12

## Demande

Trois tâches indépendantes, exécutées ensemble.

**Tâche 10.** Distinguer de manière stricte la spécification du système `clia` de son implémentation. Une DCN en `draft` et un premier jet d'ADR.

**Tâche 11.** Consulter `ANL-001` pour définir la meilleure méthodologie de recherche de fondation. Le prompt de la tâche 7 est la version la plus aboutie, mais `FND-002` n'est pas assez long ni exhaustif et ses citations ne sont pas au niveau attendu d'une recherche universitaire. Produire un MET décrivant le procédé, l'entrée requise et optionnelle, et le résultat attendu.

**Tâche 12.** Le CLI doit être utilisable par n'importe qui et ses fonctionnalités découvrables. Or `clia res new -h` répond « description manquante ». Corriger ce bogue, et mettre l'auto-découvrabilité dans les principes fondamentaux.

## Ordre d'exécution

La tâche 12 a été traitée en premier, parce qu'elle est vérifiable immédiatement et que son principe est invocable par les deux autres. Les tâches 10 et 11 ont suivi.

## Ce que la tâche 12 révèle de plus large que le cas signalé

L'humain signale un cas : `clia res new -h`. Le relevé montre que **six verbes sur sept** étaient atteints.

| Commande | Réponse avant correction |
|---|---|
| `clia res new -h` | `description manquante` |
| `clia res ls -h` | `type inconnu : -h` |
| `clia res show -h` | `introuvable : -h` |
| `clia res edit -h` | `introuvable : -h` |
| `clia config set -h` | `valeur manquante pour -h` |
| `clia config ls -h` | affichait la configuration, sans aide |
| `clia config path -h` | affichait le chemin, sans aide |

La cause est unique : chaque verbe validait ses arguments avant de reconnaître une demande d'aide. La correction est donc générique, non ponctuelle.

## Ce que la tâche 11 dit de mon propre travail

La critique de `FND-002` est fondée, et elle est reprise telle quelle dans `MET-001` avec des mesures.

Deux cent soixante-sept lignes pour huit questions de recherche, soit environ trente lignes par question, là où une revue universitaire en consacre plusieurs pages. Trente-deux sources pour huit questions, soit quatre par question, là où le seuil raisonnable est de dix. Et des citations par lien markdown à libellé court, sans auteur exact, sans titre complet, sans pagination, sans identifiant pérenne, sans date de consultation par source.

`MET-001` porte donc un tableau qui compare le seuil attendu à ce que `FND-002` a atteint, ligne par ligne. Le document est dérivé d'un échec, non d'une réussite, et il le déclare.

## Ambiguïtés et écarts signalés

**« mettre dans les principes fondamentaux ».** L'expression désigne le type `PDC`, principe de conception, défini par `RES-012` à la tâche 8. Il n'existait aucune instance ; `PDC-001` est la première. Une autre lecture était possible, la famille fondamentale au sens de `ADR-005`, mais un principe n'est pas un type de ressource.

**Le test que `ADR-006` définit échoue immédiatement.** La décision de la tâche 10 exige que la spécification survive à la suppression de l'implémentation. Appliqué aujourd'hui, le test échoue : `clia` compte 1 600 lignes de code face à zéro spécification. Porté par `NON-018`.

**`ADR-006` D2 est violé par `ADR-001` D2.** La nouvelle règle interdit de nommer une technologie dans la spécification ; `ADR-001` D2 nomme le markdown et le YAML. L'un des deux doit céder. Porté par `NON-018` Q2.

## Directives inexécutables constatées

| Directive | État | Traitement |
|---|---|---|
| Un skill encadre la production d'un principe et d'une méthodologie | `skl-003` et `skl-006` existent depuis la tâche 8, au niveau de la famille | Employés |
| Les types `SPC`, `RQF`, `RQNF`, `USE`, `CMP` sont instanciés | Aucun ne l'est | La dette est nommée par `ADR-006` D5 plutôt que comblée |

## Ce qui n'a pas été fait

Aucune spécification écrite. `ADR-006` D5 en fait une dette nommée, et `NON-018` Q1 demande dans quel ordre les écrire.

Aucun déplacement de fichier, bien que `ADR-006` D6 range les schémas et gabarits dérivés du côté implémentation alors qu'ils vivent avec la spécification. La contradiction est déclarée.

Aucune nouvelle fondation produite selon `MET-001`. La méthodologie n'a jamais été éprouvée telle quelle, et elle le dit.
