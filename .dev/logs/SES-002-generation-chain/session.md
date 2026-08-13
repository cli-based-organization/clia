---
type: session
id: SES-002
title: "generation chain"
status: draft
ouverture: 2026-08-11
etat: opened
---

# SES-002 - generation chain

> Rendre le système utilisable dans n'importe quel repo

# 1. INTENTION

Faire en sorte que le créateur puisse travailler sur différents projet même si la méthodologie clia n'est pas aboutit et doit 

# 2. CONTEXTE

À rédiger.

# 3. LIVRABLES

À rédiger.

# 4. CRITÈRES de convergences

Le créateur est capable de travailler simultannément sur le développement de clia et sur une multitude d'autres projets en utilisant clia.

La mise à jour de clia et la migration des données est 1. possible et 2. facile.

# 5. TÂCHES

## 1.  [implémentation] Ajuster le comportement de `clia ses`


- 1. prendre en compte les réponses et précisions à NON-037
- 2. Rétablir le champs "CRITÈRE de convergence" comme section obligatoire du template de session.

L'état actuel a été ajuster à la main:
- le fichier session.md vit dans @.dev/logs/SES-002-generation-chain/session.md
- le fichier @workdir/session.md n'est qu'un lien symbolique

C'est ce que l'on veut avoir. Documenter ça dans RES-032
Il faut que `clia ses new DESCRIPTION` modifie le lien symbolique vers la nouvelle session.

Aussi, `clia ses switch SESSION_ALIAS` ne fait que modifier le lien symbolique


TODO: 

Faire un plan SMART. Tout ce qui n'est pas smart doit faire l'objet d'un seul NON.

## 2. [implémentation] Exécuter les plans PLN-007

## 3. [implémentation] Exécuter les plans PLN-008

## 4. [planification] Préparer l'implémentation des commandes d'installation et de mise à jour

Consulter ce qui a été fait dans les expérimentations précédentes => ANL-001 et $HOME/git


Préparer un plan d'implémentation SMART pour les commandes suivantes:

```sh
. setup.sh install --dev # Installation en mode dev

clia setup init [...] # même interface cli que la commande git cli. instrumente un repo git avec système clia. ET crée un repo git si le repo n'existe pas.
clia setup check [PATH] # vérifie si le repo PATH ou $PWD (défaut) est compatible avec clia. Répond à la questoin peut-on instrumenter ce repo avec clia sans impacter le repo existant?
clia setup check [PATH] # vérifie si le repo PATH ou $PWD (défaut) est instrumenté avec clia et est conforme à la version déclarée

clia setup upgrade [VERSION] # met à jour ce repo en compatibilité avec la version latest ou VERSION
```

Installation en mode dev => 1. seulement accessible par l'utilisateur. 2. une fois installé, clia est utilisable sur n'importe quel repo git, 3. remote == repo git local dans un répertoire au choix accessible par l'utilisateur, 4. le code utiliser est le repo de dev (remote), 5. aucune modification du remote n'est nécessaire.

Créer un ISU + NON pour tout ce qui n'est pas SMART

## 5. [implémentation] exécuter le plan créé à la tâche précédente


## 6. [analyse] L'humain ne comprend pas ce qui a été fait et ce qui n'a pas été fait

Faire une analyse de l'historique de travail dans ce repo. Plusieurs demandes de l'humain ont été formulés par l'humain, mais n'ont pas été exécutés. 

Ceci est le comportement attendu. Seul les plans SMARTs doivent être exécutés. Et les objections sont nécessaires.

Cependant... il difficile d'avancer et un humain de se retrouve pas.

Un humain a besoin de focus et d'une seule action claire à prendre pour pouvoir agir.
Il y a trop d'informations et elles sont trop dispersés.

Voici ce qui est bien =>

- La commande `clia res ls RESSOURCE` est très utile pour avoir une vue d'ensemble rapide
- Les NON sont cruciaux et incontournable pour regrouper les aspects que l'humain doit préciser/clarifier à l'IA
- les PLN SMART sont ce qu'il nous faut pour planifier et décider ce que doit implémenter les agents IA
- Les ISU ont un grand potentiel pour organiser les sujets thématiques qui demandent réflexion, essaie et recherche avant implémentation

Voici ce qu'il manque =>

- la commande `clia res ls RESSOURCE` ne donne pas d'information utile sur l'état de chaque ressources de la liste
- il y a trop de NON et on ne sait pas où focuser l'effort de travail de l'humain
- on ne sait pas les fonctionnalités que vont implémenter PLN et si ils sont exécutés ou non, SMART ou non
- C'est pas clair comment les ISU règlent le problème de focus ... ils ne sont pas concrètement utilisables.

Voici pourquoi c'est difficile d'avancer en moment =>

l'humain a demandé l'implémentation de plusieurs de fonctionnalités clefs. Mais l'agent IA a suivi la "procédure" et

- 1. nous sommes toujours bloqué
- 2. les ressources et les choses à faire s'accumulent ce qui empire la situation

Question de l'humain:

Comment faire pour:

- permettre un meilleur focus sur le développement d'une ou un groupe de fonctionnalité?
- comment faire pour que l'agent IA implémente ce qui est demandé malgré l'incertitude (mode best effort avec décision documenté)?
- comment faire pour que, malgré l'avancement en mode "best effort documenté", l'agent IA soulève les objections importantes et ne produise+exécute que des PLN SMART?
- comment faire pour que plus on travaille plus le nombre d'items à faire diminuent? (actuellement il augmente)

Bref... on aurait besoin d'un peut plus de philosophie "Get things done" dans nos méthodologies.

TODO => Produire une analyse de la situation incluant des recommandations et un plan SMART pour chaque recommandation. Émettre des NON, mais uniquement pour ce qui ne peut pas être géré en mode "best effort documenté"


Appliquer le PDC-005. 
Évaluer la pertinence d'introduire les ressources suivante:
- Fonctionnalité: description d'une fonctionnalité
- Note d'implémentation: ressource documentaire produite par les agent IA qui explique les décisions prise et le détail de ce qu'ils ont implémenté et pourquoi

Les notes d'implémentation seront utiles pour produire les releases notes.
Mais il semble y avoir un recoupement avec les commit-message. Or, le commit message devrait être plus succint et les détails devraient se trouver dans les notes implémentation.

## 7. [implémentation] Exécuter le plan PLN-010
