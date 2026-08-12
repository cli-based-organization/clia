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



## x. [planification]