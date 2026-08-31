# Résultat de la validation, tâche 2

## Forme : conforme

Aucun tiret cadratin ni demi-cadratin dans les seize fichiers. Aucun filet `---` hors clôture de frontmatter. Les seize frontmatter sont analysables par un parseur YAML et portent `type` et `id`. Les huit définitions portent quatorze champs, les huit objections en portent huit.

## Cohérence interne : conforme

Les liens relatifs des seize fichiers résolvent tous vers un fichier existant, y compris les renvois croisés entre `.dev/ressources/` et `.dev/objections/` et le renvoi de `NON-004` vers `INTENTION.md` à la racine.

Les seize `id` sont distincts. Les huit objections déclarent leur champ `porte-sur`. Les sept définitions renvoient chacune aux objections qui portent sur elles, de cinq à quatorze renvois.

Les huit objections portent sept questions chacune, cinquante-six au total, chacune suivie d'un bloc de réponse vide appartenant à l'humain.

## Auto-application : conforme

Les huit objections respectent la structure définie par `RES-004` : journal, objet de la contestation, motif de non-implicitation, questions numérotées avec bloc de réponse, condition de levée, relations.

`RES-001` porte les quatorze champs qu'elle déclare obligatoires, vit à `.dev/ressources/RES-001-ressource.md` comme elle le déclare, et suit la nomenclature qu'elle fixe.

## Fondation : conforme

Les cinq apports de conception renvoient chacun à une mesure de `ANL-001`, et les trois écarts avec l'état de l'art sont motivés par une mesure et non par une préférence.

## Réserve à signaler

Une **contradiction interne subsiste et est assumée**. Les sept définitions emploient six relations (`derive-de`, `remplace`, `est-remplacee-par`, `reference`, `objecte-a`, `repond-a`, `specifie`) dont le vocabulaire est déclaré dans `RES-001`. Or `RES-006` établit que ce vocabulaire relève de l'ontologie. Tant que `ONT-001` n'existe pas, `RES-001` est une source parallèle, exactement le défaut que le modèle prétend éviter.

Cette contradiction n'a pas été masquée : elle est écrite dans `RES-006`, sous le titre « Articulation avec le modèle de ressources », et portée par la question Q2 de `NON-004`.

## Écart de journalisation à signaler

Le harnais prescrit un répertoire de journalisation par requête, nommé `<DATE>-SES-<SLUG>`, sans dire comment journaliser deux tâches d'une même session. Les fichiers de la tâche 2 portent donc un suffixe `-task-02` dans le répertoire de session existant, tandis que ceux de la tâche 1 n'en portent pas. Le nommage est asymétrique. Aucun fichier de la tâche 1 n'a été déplacé : le remaniement de livrables déjà validés n'était pas demandé.
