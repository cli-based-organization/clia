# Demande interprétée, tâche 5 de SES-002

Écrit avant l'exécution. `MET-003` étape 1.

## Ce que l'humain demande

« Exécuter le plan créé à la tâche précédente », soit `PLN-009`.

## Ce que cela recouvre

Quatre chantiers, dans l'ordre imposé par leurs dépendances.

| Chantier | Livrable | Durée déclarée |
|---|---|---|
| A | La spécification de conformité d'un dépôt `clia` | 2 h |
| B | `clia setup check [PATH]` | 1 h 30 |
| C | `clia setup init [PATH]` | 2 h |
| D | `. setup.sh install --dev` | 45 min |

**Le plan porte un point d'arrêt déclaré.** Après A : si la spécification ne peut pas s'écrire en critères exécutables, B et C n'ont pas de fondement et l'exécution s'arrête là.

## Ce qui n'est pas demandé

`clia setup upgrade` ne fait pas partie du plan. `ISU-012` porte pourquoi, et l'exécuter reviendrait à sortir du plan que la tâche demande d'exécuter.

## Ce que j'applique de ma propre initiative

**La recommandation Q3 de `NON-039` : poser un fichier de version dès le chantier C.**

C'est cinq lignes dans un chantier déjà prévu, et son absence obligerait à le rétro-ajouter à tout dépôt instrumenté entre-temps. Je le fais et je le déclare, plutôt que d'attendre une réponse qui coûterait une migration.

## Précaution

`init` écrit dans des dépôts tiers et peut en créer. **Tout est éprouvé en dépôt jetable**, et aucun dépôt réel de `$HOME/git` n'est touché.

**Le dépôt source ne doit pas être modifié** : c'est l'exigence 5 du mode développement, et le contrôle est de relever son empreinte avant et après.

## Une contrainte de méthode, tirée de BUG-001

Les documents s'écrivent avec l'outil d'écriture, non par document en place dans une commande shell. Quatre des sept interruptions relevées par `BUG-001` viennent de là.
