# Résultat de la validation, tâches 8 et 9

## Validation mécanique : le premier contrôle de fond de ce dépôt

`cue vet` sur les soixante schémas : **aucune erreur**.

Validation des ressources contre leur schéma : **68 valides sur 69**.

Le seul échec est `NON-013-ce-qu-est-une-ressource.md`, créé par l'humain le 2026-08-09 avec `clia res new`. Il n'a pas été corrigé : son initiateur est l'humain, et le régime hybride de `RES-004` protège ses blocs. L'échec est le signalement, non un défaut à masquer.

## Dix-sept non-conformités trouvées, seize corrigées

| Défaut | Nombre | Corrigé |
|---|---|---|
| `statut` en octal, bogue de mon générateur | 5 | oui |
| Champs `id`, `date`, `sujet` absents sur les atomes de `ANL-001` | 8 | oui |
| `methodologie` absent de `FND-001` | 1 | oui |
| `title` exigé pour un skill, qui porte `name` | 1 | oui, dans le schéma commun |
| Champs propres absents de `NON-013` | 1 | non, fichier de l'humain |

Le défaut du `statut` en octal mérite d'être noté : `statut: $13` en bash produisait `0153`, que YAML lit comme un nombre octal. Sans validation, cinq définitions auraient porté un statut numérique absurde indéfiniment. C'est exactement ce que `NON-005` annonçait en constatant que rien ne vérifiait un champ mal orthographié ou mal typé.

## Trois bogues du CLI, trouvés par la validation

Valider le fichier de l'humain a mis en cause l'outil qui l'a produit.

| Bogue | Cause | Correction |
|---|---|---|
| `res new` posait une liste fixe de cinq champs | La commande ne lisait pas la définition du type | Elle lit `champs-obligatoires` et `sections` |
| Le champ `type` venait du titre lisible | `Décision d'architecture` donnait `décision-d-architecture` au lieu de `adr` | Il vient de l'identifiant, qui porte le slug canonique |
| La résolution échouait sur les accents | `clia res ls decision` ne trouvait pas « Décision » | Une huitième colonne porte le nom canonique |

Les trois ont la même cause : l'outil dérivait de l'affichage plutôt que de l'identité. C'est la troisième fois de cette session que cette confusion produit un défaut, après l'adresse contre l'identité à la tâche 6.

## Non-régression : conforme

Soixante-sept assertions, toutes vertes, après les trois corrections du CLI. Deux tests ont été ajustés : le dépôt d'essai déclarait des types à trois champs obligatoires, et `res new` ne pose désormais que ce que la définition déclare, ce qui est le comportement voulu. Une assertion a été ajoutée pour vérifier que les sections déclarées sont posées.

`clia res ls` voit les trente types définis.

## Forme : conforme

Les trente définitions, les cinq ADR, les cinq DCN, les sept skills, les trois objections nouvelles et l'index passent les contrôles V2, V4, V5, V6 et V8 de `skl-001-ressource`. Les identifiants restent uniques sur tout `.dev/`.

## Cohérence du modèle : conforme, avec deux réserves

Les trente définitions déclarent une famille parmi les six, des `sections` dont le gabarit est dérivé, et le skill de leur famille.

`ANL-001` est mis en conformité avec `ADR-004` D3 : ses huit atomes portent un identifiant, un sujet, une date et une relation `fait-partie-de`.

**Première réserve.** L'index des définitions, `.dev/ressources/index.md`, porte `type: ressource` alors qu'il n'est pas une définition de type mais une vue. Il a fallu lui ajouter les champs du type pour qu'il valide, ce qui est un contournement assumé et porté par `NON-016` Q6.

**Seconde réserve.** `RES-026-code` déclare n'avoir aucun frontmatter, donc aucun schéma ne le contraint. Le modèle a désormais deux régimes de validation, l'un par schéma pour les ressources textuelles, l'autre par tests pour le code, et il ne le dit nulle part. Porté par `NON-016` Q5.

## Écart avec la demande, déclaré et objecté

Six skills de famille au lieu de vingt-neuf skills de type. L'écart est motivé par `ADR-005` D4, il vaut vingt-trois documents, et il est porté par `NON-017` Q1 dont l'effet est bloquant.

C'est le seul endroit de ces deux tâches où la lettre de la demande n'est pas suivie. Il est signalé dans l'ADR, dans son statut, dans l'objection, et ici.
