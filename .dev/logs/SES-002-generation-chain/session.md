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


