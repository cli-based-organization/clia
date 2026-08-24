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

Faire en sorte que le créateur puisse travailler sur différents projets même si la méthodologie clia n'est pas aboutit. 

L'utilisateur de clia sur un autre repo que clia doit être en mesure de mettre à jour les fichiers sous la gestion de `clia`

# 2. CONTEXTE

À rédiger.

# 3. LIVRABLES

- ressources
- code
- et tout autres livrables nécessaires

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

## 8. [bogue] Plan smart qui refusent d'exécuter la demande

La tâche précédente demande l'exécution d'un plan sensé être smart...

Or, rien n'est exécuté... pire l'agent IA considère que c'est normal.

> Tâche 7 exécutée — sans rien produire de neuf, et c'est le résultat attendu.

Voici ce à quoi on s'attend:

- un plan SMART signifie qu'on peut exécuter le plan et qu'il produira les livrables planifiés
- sinon, c'est une ERREUR et il faut ouvrir un BUG

TODO => disagnostiquer. Ouvrir un BUG pour documenter cet incident. Proposer une solution.

## 9. [implémentation] Exécuter les plans => PLN-011 PLN-012 PLN-013 PLN-014

TODO => Après chaque exécuton de plan, dire les fonctionnalités qui ont été implémentés et comment l'utiliser

Mettre cette directive dans la méthodologie qui guide l'exécution des plans

## 10. [plan de rémédiation] analyse, diagnostique et planification pour BUG-001

L'humain a rapporté le bogue BUG-001.

Analysez-le. Inclure dans ANL produit le diagnostique et des pistes de correctifs. Émettre des objections pour toute ambiguité ou demande de clarification à fournir par l'humain. 

Choisir l'option de rémédiation la plus prometteuse et proruire un plan SMART.

## 11. [implémentation] exécute le PLN-007

## 12. [implémentation] exécute le PLN-015

## 13. [rapport de bogue] Pourquoi on avance pas

Les plans PLN-015 et PLN-017 ont été exécutés pendant 8 minutes mais ils ont échoué ou n'ont rien produit ou n'ont pas bien rapporter le problème.

Aucune directive claire et compréhensible pour l'humain n'a été fournit pour avancer et débloquer la situation.

Ce n'est pas un comportement acceptable. Consigner cet incident dans un rapport BUG.

Dire pourquoi dans une analyse ANL. Proposer une solution.

Réécrire les skills et les méthodes d'exécution et d'écriture de plans pour que cette situation ne se produise pas.

## 14. [conception etc.] manipulation des décisions

Actuellement, c'est difficile de comprendre comment fonctionne les métadata de décision DCN et son cycle de vie également.

Ajouter un ADR qui impose de fournir la documentation des ressources à partir du cli pour satisfaire à PCD-001: `clia res explain|help RES-<SEQ>`

Faire un plan d'exécution. et si ce plan est SMART, implémenter la commande.

## 15. [plan de rémédiation] initialisation d'un repo clia: comportement attendu

suite à l'initialisation du repo ~/git/cli-based-organization/clia-repos avec la commande `clia setup init --dev ... `, je constate les défauts suivant


- Il n'y a pas de harnais IA CONSTITUTION.md
- Le fichier INTENTION.md a été peuplé avec le fichier intention du repo clia

Ce qu'il faut faire =>

- tout les harnais générés (CLAUDE.md, SKILLs, CONSTITUTION.md, ARCHITECTURE.md ) proviennent de fichiers de source de vérité yaml + génération à partir d'un template
- fournir un fichier constitution.
- le fichier ARCHITECTURE.md est optionnel
- le fichier INTENTION.md est un symlink sur .dev/intentions/INT-001.md
- le fichier INTENTION.md est un template vide à remplir.
- si un fichier INTENTION.md existe déjà, le déplacer vers INT-001.md et en faire un symlink sur INTENTION.md

## 16. [impémentation] exécute le plan PLN-017

## 17. [analyse] Où historique de la ressource intention

Parcourir les repos historiques ( $HOME/git/*) afin de reconstituer l'historique de développement d ela notion d'intention.

Dire quels repos utilisisent la notion d'intention et quels documents discutent de ce concept.

## 18. [bogue] écriture d'un fichier dans un autre worktree

Voici le comportement attendu:

- les ressources produites doivent être déposé au "bon endroit"
- il est strictement INTERDIT à l'agent IA d'utiliser git


