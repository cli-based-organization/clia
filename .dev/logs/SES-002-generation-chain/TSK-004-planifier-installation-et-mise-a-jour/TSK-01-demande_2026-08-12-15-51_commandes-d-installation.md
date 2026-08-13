# Demande interprétée, tâche 4 de SES-002

Écrit avant toute exploration. `MET-003` étape 1.

## Ce que l'humain demande

Un **plan d'implémentation SMART** pour cinq formes de commande, précédé de la consultation des expérimentations antérieures.

| Réf | Forme | Ce qu'elle doit faire |
|---|---|---|
| A | `. setup.sh install --dev` | Installation en mode développement |
| B | `clia setup init [...]` | Instrumenter un dépôt git, le créer s'il n'existe pas. Interface calquée sur celle du cli git |
| C | `clia setup check [PATH]` | Peut-on instrumenter ce dépôt sans l'impacter ? |
| D | `clia setup check [PATH]` | Ce dépôt est-il instrumenté et conforme à la version déclarée ? |
| E | `clia setup upgrade [VERSION]` | Mettre à jour vers `latest` ou vers `VERSION` |

**Le mode développement porte cinq exigences**, énoncées telles quelles : accessible au seul utilisateur ; une fois installé, `clia` utilisable sur n'importe quel dépôt git ; le distant est un dépôt git local dans un répertoire au choix ; le code employé est celui du dépôt de développement ; aucune modification du distant n'est nécessaire.

## Ce que je relève immédiatement

**C et D portent le même nom.** Deux sémantiques différentes sous `clia setup check` : l'une interroge un dépôt **non instrumenté**, l'autre un dépôt **déjà instrumenté**. Une commande ne peut pas répondre à deux questions sans les distinguer.

Je ne tranche pas ici : c'est le genre de point qui appartient à l'humain, et la demande prévoit explicitement où le loger.

## Ce que la demande impose à la méthode

**Un plan SMART**, au sens de `PDC-003` : livrable unique, critère de réussite exécutable, limite de temps déclarée.

**Et un traitement distinct de ce qui ne l'est pas** : « Créer un ISU + NON pour tout ce qui n'est pas SMART ». La tâche 1 demandait un seul `NON` ; celle-ci demande **un `ISU` et un `NON`**.

## L'intention derrière

`SES-002` vise à rendre le système utilisable dans n'importe quel dépôt. Ces cinq commandes sont **le chemin** vers ce critère de convergence : sans installation ni instrumentation, `clia` ne sort pas de son propre dépôt.

**Le second critère de convergence est engagé aussi** : « la mise à jour de clia et la migration des données est possible et facile ». `upgrade` le porte.

## Le livrable

Un `PLN`, un `ISU`, un `NON`. La tâche 5 exécutera le plan.

## Ce qui reste à établir

Ce que les expérimentations antérieures ont produit : `ANL-001` et les dépôts de `$HOME/git`. La demande commence par là, et je n'ai encore rien lu.
