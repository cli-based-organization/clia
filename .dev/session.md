---
start-at: 2026-07-09T07:50:14-04:00
---
# Intention
  
  Rédaction d'une offre de service pour la Commision scolaire de la Capitale-Nationale


# Contexte

On doit d'abord mettre en place un environnement de collaboration humain-IA

# Tâches

## 0. demande initiale hors session

Analyser le repo @../../noumanity-formation/intentional-doers-governance/
Copier la structure et les fonctionnalités dans ce repo. Ne pas copier le contenu, uniquement les fichiers utilitaires (harness-files et scripts bash + documentation user + documentation design ex @../../noumanity-formation/intentional-doers-governance/dist/presentation.pdf

## 1. [rapport de bogue] Mauvais comportement

Le prompt précédent

> Analyser le repo @../../noumanity-formation/intentional-doers-governance/
> Copier la structure et les fonctionnalités dans ce repo. Ne pas copier le contenu, uniquement les fichiers utilitaires (harness-files et scripts bash + documentation user + documentation design ex @../../noumanity-formation/intentional-doers-governance/dist/presentation.pdf

a remplacé le contenu du fichier INTENTION.md. 

Ce n'est pas le comportement attendu et ce n'est pas un comportement acceptable.

Le fichier INTENTION.md est le coeur de la motivation de l'humain. En aucun cas l'agent IA ne doit le modifier.

Apporter les modifications harness-files, notamment à CONSTITUTION.md pour 

- dire que tous les documents font partie d'une des 3 catégories suivante: 
  - édition par humain uniquement
  - édition par IA uniquement
  - co-édition humain et IA
- le fichier INTENTION.md et les fichiers de sessions (@.dev/session*) sont dans la catégorie édition par humain uniquement
  - l'agent IA peut les lire, les commenter et faire des suggestion
  - en aucun cas, l'IA ne doit les modifier

Également, remettre en place l'ancien contenu

## 2. [amélioration harness-ia] log des réponses de l'agent IA et aucun git commit

Actuellement, l'agent résume son travail dans stdout.

Mettre également ce contenu dans un fichier markdown, un pour chaque tâche de chaque session.
mettre le tout dans le répertoire @logs/ia-output

Écrire un skill qui encadre la production de ce livrable. Celui-ci doit être en markdown valide et comprendre une section `commit message proposé`

Produire le log pour la tâche 1

Modifier les harness-file au besoin pour prendre en compte ce comportement attendu

Ajouter également au harness-file que l'agent de doit jamais tenté ou proposer de faire un git commit

produire le log pour cette tâche

## 3. [bogue harness-ia] poduire un plan en tout temps

Tu ne semble pas avoir compris la méthodologie attendu.

Il s'agit d'une méthode de collaboration humain/agents IA.

L'agent ne doit pas exécuter tout ce que l'on dit. L'agent IA DOIT:
- analyser l'intention de l'humain et trouver le contexte pertinent
- construire un plan PLN-XYZ pour aviser l'humain de ce qu'il va faire.
- proposer des objections-sociocratiques: 
  - définir quel livrables seront produits
  - émettre des critiques constructives concernant l'intention
  - relever des ambiguités ou un manque d'information (intention, contexte)
  - ne pas improviser ou inventer, si la marche à suivre n'est pas claire, émettre une objection-sociocratique

Apportez les modifications appropriés aux harness pour forcer ce comportement

## 4. [bogue harness-ia] Écrire le plan dans un fichier

le plan a été écrit dans stdout. Ce n'est pas le comportement attendu.

Nous construisons un système de travail sur un corpus de textes. L'interface input/output est également des fichiers markdown.

Le plan DOIT être écrit dans @.dev/plans/PLN-<XYZ>-<SLUG>.md tel que mentionné dans CLAUDE.md

modifier les harnais-ia de tel sorte à que ce comportement soit forcé.

## 5. réponse aux objections

### objection 1 

Je ne comprends pas cette objection telle quelle est exprimé. Qui sera confu? humain ou agent?

### objection 2 

La séquense de numérotation est séquentielle avec incrément +1, PLN-001 => PLN-002
S'il n'y a pas de plan de travail en cours, on en crée un nouveau avec status "en cours".
Une fois le travaille terminé, on met le status "terminé".
Les plans qui ne sont ni "en cours", ni "terminé" on le status "todo" et ont un X en début de séquence. exemple PLN-X01-<SLUG>
les plans todo de la série X ont une numérotation intépendante

### objection 3

dans le plan , inclure une liste des session-tâche en lien avec ce plan

l'ID unique d'une session est sa date+heure d'ouverture et l'id unique d'une tache est date+heure de session & numéro de tâche

Terminer le travail demandé dans les tâches 3, 4 et 5

## 6. Adapter PLN-003 pour se coller à la source

La source de départ est le repo @../../noumanity-formation/intentional-doers-governance/

Relire et analyser ce repo. 

Il faut d'abord reproduire le comportement de ce repo.

## 7. répondre aux objections

### Objection 1

Ignorer les demandes de l'humain et s'en tenir à la source

### objection 2

ne pas copier le script de génération de présentation

### objection 3

ne pas toucher à l'historique git.

### objection 4

ne pas autoriser — en prose et --- (hors frontmatter)

Et corriger les occurences (sauf dans les fichiers sous contrôle humain)


## 8. Reste-t-il des objections? si non, exécurer le plan

## 9. Recherche et analyse des clis

1. Faire une recherche de fondation à propos des interfaces (commandes, flags, options, stdout, stderr) et des conventions pour les CLI.

2. Rechercher récursivement dans tous les repos à partir de @../.. et trouver les scripts bash et autres CLI

3. Analyser chaque collection de scripts trouvés et autres CLI au regard de la recherche de fondation

4. proposer un skill (premier jet) spécialisé dans la rédaction de spécification
5. proposer un skill (premier jet) spécialisé dans la rédaction de requis

6. proposer une convention de cli bash et en écrire l'ADR, la spécification et les requis

7. proposer un premier jet de skill spécialisé dans le codage de cli bash à partir de ADR, spécification et requis.

Nous faisons un premier jet de tous ces documents. Donc, lorsqu'il manque de l'information pour trancher, faire un choix en fonction des meilleurs pratiques. N'émettre une objection que si elle est bloquant

## 10. objections à PLN-004

Il y a confusion sur ce qu'est une recherche de fondation: c'est une recherche théorique large à partir de la littérature scientifiques.

le FND-002 n'est pas une recherche de ce type. C'est l'analyse d'un corpus de documents sur un filesystem.

Créer un skill spécialisé dans l'analyse d'un corpus de texte sur file système et produisant un livrable de type analyse. Définir le livrable de type analyse dans un ADR 

Prendre en compte ces objections et réviser le plan en conséquence

## 11. exécuter le plan

## 12. [plan] typologie des ressources livrables sur l'axes d'analyse "cycle de vie"

Parmis les documents sous gestion de l'IA, il y a 3 catégories sur l'axe d'analyse du cycle de vie:

- 1. document qui représentent un point fixe dans le temps: FND, ANL, @logs et autres documents publiés (dans @publications/*). Ces documents sont produit une fois et ne doivent pas être modifiés
- 2. documents "vivant" qui sont appelés à évoluer et à prendre de la maturité sur un cycle long: ADR, REQ, skl, SPEC, code base. Ces documents sont versionnés avec semantic versionning.
- 3. documents de travail: PLN. Modification sur un cycle court. pas de suivie de version

Proposer un mécanisme pour le versionage atomique des ressources livrables.

Exemple: l'ensemble des fichiers harness-files a une version. Et chaque fichier quelle contient (CLAUDE.md, CONSTITUTION.md, chaque skill...) ont également une version. 

Produire un ADR sur les ressources livrables (ressources, livrables, documents).

Produire un plan 

## 13. [bogue] aucun log n'a été produit

Le comportement attendu est le suivant: 
- TOUTE tâche exécutée doit produire un log dans un mifhier markdown

Or, l'exécution de la tâche précédente n'a pas produit de log

Analyser le problème, faire un diagnostique.

Corriger en ajustant les harness-files approprié.

Ensuite:
- produire un ADR à propos de la gestion des bogues.
- décrire BUG, une ressource livrable de type "document vivant" qui permet de:
  - rapporter les bogues,
  - documenter le diagnostique
  - documenter la solution appliquée
- produire un skill qui produit la ressource BUG  
- produire la ressource BUG pour ce bogue