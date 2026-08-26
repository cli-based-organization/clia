---
type: objection
id: NON-001
titre: "Les ressources core déclarent plus que le système ne tient"
version: 0.1.0
initiateur: agent
porte-sur: SES-001 tâche 11
etat: ouverte
---

# NON-001 - Les ressources core déclarent plus que le système ne tient

> Les six définitions produites déclarent des propriétés — génération par IA,
> état d'instance, instrumentation — que rien dans le dépôt ne fait tenir.

## Ce qui est contesté

La tâche 11 de SES-001 (génération 3) demande de produire FND, ANL, NON, PLN, SES et LOG « en
respectant tous les principes PDC ». Les six définitions sont écrites, et
trois d'entre elles ne peuvent pas respecter les principes tant que quatre
questions restent ouvertes.

L'objection ne conteste pas les types. Elle constate que les déclarer suffit
à les rendre visibles à `clia res ls`, et ne suffit pas à les rendre
utilisables.

## Pourquoi cela ne peut pas rester implicite

Une définition qui déclare `edition: ia` sans que le prompt de génération
existe promet une génération que personne ne peut faire. Un dépôt qui adopte
ces types produira des instances à la main, chacune à sa façon, et la
définition deviendra une décoration.

Le coût de trancher maintenant est de quatre réponses. Le coût de ne pas
trancher est celui qu'`ANL-004` de la génération précédente avait mesuré :
des définitions qui décrivent un système que le système n'applique pas.

## Questions

### Q1 — Où vit le prompt de génération ?

`PDC-003` pose que toute ressource générée par IA provient de primitives et
d'un prompt de génération, et que l'ensemble des primitives « contient toutes
les informations essentielles ». FND, ANL, PLN et LOG déclarent `edition: ia`.
Aucun prompt n'existe : le catalogue de skills est vide.

Trois places sont possibles : `_ressources/<R>/skills/<R>.md` — un skill est
une procédure exécutable, et générer en est une ; `_ressources/<R>/primitives/`
— le prompt est une primitive, `PDC-003` le dit ; ou un champ `prompt:` de la
définition, qui évite un fichier de plus.

**Réponse.** *(à l'humain)*


Étendre 

### Q2 — Quel champ porte l'état d'une instance ?

Trois noms cohabitent dans ce qui vient d'être écrit : `status` pour fondation
et analyse, repris de la génération 2026-07 sur votre consigne ; `etat` pour
objection et plan, repris de 2026-08 ; et les quatre champs universels
`maturity`, `adoption`, `activated`, `domain-status` que `DCN-016` de la
génération précédente avait introduits pour remplacer les deux premiers.

Un seul régime doit valoir. Le troisième est le plus complet et le plus
coûteux ; le premier est le plus léger et ne distingue pas la maturité du
document de son adoption par le système.

**Réponse.** *(à l'humain)*

### Q3 — Une session est-elle un fichier ou un répertoire ?

La génération 2026-08 faisait de la session un répertoire,
`.dev/logs/SES-<SEQ>-<SLUG>/`, portant le journal des tâches ; le log y avait
un emplacement dérivé de la session et de la tâche.

Ce qui est écrit ici garde la session en un fichier, `.dev/session.md`, et
donne au log un emplacement indépendant, `.dev/logs/LOG-<SEQ>-<SLUG>.md`.
Motif : `PDC-006`, limiter puis étendre, et `PDC-007`, avancer par
itérations. Ce choix perd le rattachement mécanique d'un log à sa tâche.

**Réponse.** *(à l'humain)*

Ni l'un, ni l'autre. Une session est une ressource informationnelle. Elle peut être représentée sous forme de fichier, sous forme de répertoires + fichiers, sous forme de repo git, etc.

La génération 2026-08 mélangait les ressources de session et de log.

Aussi, il y avait une ambiguité au niveau des notions d'archivage vs d'espace actif. Finalement, selon le PDC-005, la notion d'espace actif est un mécanisme de focus que nous devrions privilégier dans le futur.

Aussi, il y a clairement une dépendance entre les ressources SES et LOG.

Une session peut existée sans log. Mais les logs pas sans input.

La ressource SES fournit un mécanisme d'input, mais ce n'est pas le seul mécanisme d'input.

Un repo doit avoir au moins un mécanisme d'input. Ceci implique qu'il peut également y en avoir plusieurs.



### Q4 — Comment crée-t-on une instance ?

`PDC-001` demande qu'une ressource soit instrumentable. `clia res new` crée
un **type**, non une instance : rien ne pose aujourd'hui un
`.dev/fondations/FND-001-....md` à partir du gabarit que la définition
déclare.

Il manque un verbe. `clia res instance new <type> <slug>` le dirait sans
ajouter de commande ; `clia new <type> <slug>` serait plus court à taper.

**Réponse.** *(à l'humain)*

## Ce qui lèverait cette objection

Quatre réponses, et les implémentations qui en découlent. Chacune se traite
séparément : répondre à Q4 seule rendrait déjà les six types utilisables.

## Journal

- 2026-08-25 — ouverte, à la production des six ressources core.
