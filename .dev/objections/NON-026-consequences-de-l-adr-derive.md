---
type: objection
id: NON-026
title: "Conséquences de l'ADR dérivé et du lien symbolique d'intention"
status: draft
initiateur: agent
effet: informatif
etat: repondue
porte-sur: [RES-019, RES-003, ADR-017]
---

# NON-026 - Conséquences de l'ADR dérivé et du lien symbolique d'intention

> `ADR-017` D5 fait de l'ADR une justification générée à partir de `DCN` et de `FRG`. Seize ADR existent, tous écrits à la main comme des actes de décision, et aucun ne dérive de quoi que ce soit. D3 prescrit un lien symbolique qu'aucune commande ne pose.

## Journal

- 2026-08-11 : ouverte par l'agent, à la tâche 22, avec `ADR-017`.
- 2026-08-11 : **les cinq questions répondues par l'humain.** Traitées à la tâche 24 par `ANL-006` et `PLN-003`.
- 2026-08-11 : état corrigé au ménage de la tâche 30. L'objection était restée `ouverte` alors que ses cinq questions portaient une réponse.

## Ce qui est contesté

Non pas les réponses, qui sont des décisions de l'humain. Cinq conséquences qu'elles laissent indéterminées.

**Seize ADR ne dérivent de rien.** Ils ont été écrits comme des actes de décision, ce qu'ils ne sont plus. Aucun ne déclare de `DCN` ni de `FRG` source.

**Le document qui instruit la décision est lui-même dans le cas qu'il décrit.** `ADR-017` devrait dériver d'une `DCN` qui n'existe pas : `CONSTITUTION.md` C1 en réserve la rédaction à l'humain, et seul le gabarit `DCN-012` a été produit.

**Aucun générateur n'existe.** C'est la deuxième décision de dérivation non outillée en deux jours, après `ADR-016` D3 sur les skills. Deux des trois familles de documents de méthode sont déclarées dérivées, et rien ne les dérive.

**Le lien symbolique n'est posé par rien.** `setup.sh` n'a aucun verbe d'initialisation de dépôt, et `INTENTION.md` reste un fichier ordinaire à la racine.

**Le régime d'édition `ia` de l'ADR a une conséquence non traitée.** Un document généré n'est pas co-édité : l'humain corrige la source. Or l'humain a écrit des réponses directement dans les objections, et ces objections sont des sources d'ADR. La boucle n'est pas décrite.

## Pourquoi cela ne peut pas rester implicite

Trois raisons.

**L'autorité des seize ADR est suspendue.** Sous D5, un ADR tire son autorité de la `DCN` dont il dérive. Aucun n'en a. Combiné à `NON-024`, qui établit que les douze `DCN` du dépôt ont été rédigées par l'agent et ne sont pas approuvées, la chaîne d'autorité du dépôt ne repose sur rien de formellement acté.

**L'écart se creuse à chaque tâche.** Les tâches 21 et 22 ont produit deux ADR, `ADR-016` et `ADR-017`, tous deux écrits à la main, tous deux instruisant des décisions de dérivation qu'ils enfreignent en existant.

**La prescription du lien symbolique est datable et non faite.** Elle est écrite dans `RES-003` depuis aujourd'hui, et le dépôt sur lequel elle s'applique n'y est pas conforme.

## Questions

### Q1 - Que deviennent les seize ADR écrits comme des actes de décision ?

Trois positions. Les laisser tels quels et déclarer que D5 ne vaut que pour l'avenir. Les rattacher rétroactivement à des `DCN`, ce qui suppose que l'humain écrive les `DCN` manquantes. Ou les régénérer quand le générateur existera, en acceptant que leur teneur change.

La deuxième est la plus juste et la plus coûteuse : elle demande une `DCN` par ADR sans source, et `CONSTITUTION.md` C1 réserve leur rédaction à l'humain.

**Réponse.**

Rendre les ADR non-active.

Planifier une mise en conformité à DCN-013

Identifier toutes les décisions implicites et explicites dans les ADR et en proposer une formulation dans un document ANL. Faire la même chose pour les FRG.



### Q2 - Un ADR peut-il exister sans `DCN` source ?

`ADR-017` D5 dit qu'un ADR est généré à partir d'une ou plusieurs `DCN` et d'un ou plusieurs `FRG`. Le dépôt compte un seul `FRG`.

Si la réponse est non, seize ADR sont irréguliers et aucun nouvel ADR ne peut être écrit avant que l'humain n'ait rédigé la `DCN` correspondante. Si la réponse est oui, la dérivation est une recommandation et non une définition.

**Réponse.**

Non. Les ressources générés tirent leur contenu de ressources sources qui font autorité. Un humain ne modifie jamais une ADR, il modifie les documents.

L'ADR est générée/dérivée de:
- DCN
- FRG
- SPC
- REQ
- USE (cas d'usage)
- éventuellement autre resource de conception et d'architecture

Conséquence => on doit ajouter une nouvelle catégorie de ressource: les ressources d'architecture.

Conséquence =>  une ressource peu appartenir à plusieurs catégories. Par exemple, ARCHITECTURE.md est une ressource de harnais IA ET une ressource d'architecture


la relation entre ADR et chacun des type de ressource source est N à N.

conséquence => la modification des ressources sources doit entrainer une génération modifiant le contenu des resources générés. Cette conséquences est applicable à toutes les ressources sources et générées

conséquence => toutes les ressources doivent être classifiée/qualifiée de soit "source", soit "générée"


### Q3 - Quel est l'ordre de travail quand seul l'humain peut écrire la source ?

L'agent ne peut plus écrire de `DCN`, par C1. L'ADR dérive de la `DCN`. Donc l'agent ne peut plus produire d'ADR régulier sans que l'humain ait écrit la source au préalable.

Trois positions : l'agent produit les deux gabarits et attend ; l'agent produit l'ADR à partir des réponses écrites dans les objections, en le déclarant provisoire ; ou l'humain rédige la `DCN` dans le même mouvement que sa réponse à l'objection.

La troisième est la plus fluide et suppose que l'humain accepte une charge d'écriture nouvelle.

**Réponse.**

on réintroduit le mécanisme de prédilection (todo: à consigner dans une ressource MET): 
- 1. l'humain inspire par des demandes vagues et incomplète
- 2. 

Dans le cas des décisions, nous avons absolument d'avoir l'attention pleine et complète de l'humain pour que les désicions soient conscientes.

Alors, nous ajoutons un mécanisme qui force l'action consciente de l'humain: les fichiers DCN doivent être créés par l'humain (via clia).

Idéalement, le contenu des DCN est écrit par un humain. 

Mais il peut être écrit ou modifié par un agent IA. Dans ce cas, la décision est suspendue jusqu'à ce que l'humain approuve manuellement cette modification.

### Q4 - Qui pose le lien symbolique de `INTENTION.md` ?

`ADR-017` D3 le prescrit à l'initialisation d'un dépôt. `setup.sh` n'a aucun verbe d'initialisation, et ce dépôt n'est pas conforme à sa propre prescription.

Faut-il un verbe `clia init`, un ajout à `setup.sh install`, ou la conversion manuelle du dépôt courant ?

**Réponse.**

L'humain va régulariser manuellement la situation pour ce repo.

Il faut rappeller que clia est destiné à générer:
- 1. fournir un cli (clia) applicable sur n'importe quel repo git
- 2. fournir un système de harnais IA à n'importe quel repo git

conséquence => une commande `clia [-C ROOT_PATH] setup init <.|[PATH/]REPO_NAME>` génère le nécessaire pour qu'un repo soit un repo conforme clia

conséquence => on doit définir les critères pour que clia soit un repo clia conforme


### Q5 - Le générateur est-il un livrable, et de quelle famille ?

Deux décisions de dérivation existent, `ADR-016` D3 pour les skills et `ADR-017` D5 pour les ADR. Aucune n'a d'outil.

Un générateur est du code, donc une ressource `CDE`. Sa spécification serait une `SPC`, type qui n'a aucune instance. Faut-il produire la spécification avant l'outil, ou l'outil d'abord, ce que `ADR-006` sur la séparation spécification-implémentation déconseille ?

**Réponse.**

skills et ADR sont effectivement des ressources générées, donc le système doit définir un mécanisme et une méthode de génération.

Il faut distinguer la génération par gabarit déterministes (templates) et la génération non-déterministe par IA. 

conséquence => il faut trouver un nom pour les 2 mécanismes différents

Dans le cas des ressources générées, nous avons besoin d'une génération non déterministe car une interprétation des ressources sources est nécessaire (c'est d'ailleur tout l'intérêt des ressources générées).

Cependant, les 2 approches ne sont pas exclusives. Et nous allons adopter un mécanisme hybride:

- dans la définition des ressources générées, on spécifie les ressources sources et la méthode MET de génération
- à la génération de la ressources généré, on 
  - 1. analyse des ressources sources pour en tirer les conséquences
  - 2. émission d'objections NON au besoin
  - 3. génération d'un fichier contenu intemédiaire au format yaml
  - 4. valider avec une référence cuelang que le yaml a un format valide
  - 5. produire le fichier final avec le yaml et un template "classique"

todo => Faire un premier jet de MET décrivant cette méthode

conséquence => il faudrait penser à inclure DANS la ressource RES l'ensemble des dépendances nécessaires à son usage. (répertoire RES plutôt que fichier + ressource composante d'une autre ressource) 




## Ce qui lèverait cette objection

Une réponse à Q2 et Q3.

Q2 dit si la dérivation est une définition ou une recommandation. Q3 dit comment travailler d'ici là.

L'effet est `conditionnel` : les seize ADR restent lisibles et utilisables, et rien de ce qui est produit ne devient invalide. Ce qui est en cause est leur autorité et la manière de produire les suivants.

## Relations

- `objecte-a` [RES-019](../ressources/RES-019-adr.md)
- `objecte-a` [RES-003](../ressources/RES-003-intention.md)
- `derive-de` [NON-003](NON-003-frontiere-contexte-intention-faits.md)
- `reference` [NON-024](NON-024-sort-des-ressources-d-autorite-redigees-par-l-agent.md)
- `reference` [NON-025](NON-025-consequences-de-la-derivabilite-des-skills.md)
