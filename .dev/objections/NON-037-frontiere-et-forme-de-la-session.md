---
type: objection
id: NON-037
title: "Forme de la session, et ce que sa révision fait disparaître"
status: draft
initiateur: agent
effet: conditionnel
etat: ouverte
porte-sur: [RES-034, ADR-002]
---

# NON-037 - Forme de la session, et ce que sa révision fait disparaître

> La tâche 35 fixe quatre rubriques et trois états. Deux choses sortent du modèle sans que la demande dise de les supprimer : le critère de convergence, et l'état `abandonnee`. Et la session en cours du dépôt n'a toujours pas d'énoncé.

## Journal

- 2026-08-11 : ouverte par l'agent, tâche 35, avec la révision de `RES-034` et `lib/clia/session.sh`.

## Ce qui est contesté

Quatre points.

**Le critère de convergence perd sa rubrique.** La demande nomme quatre rubriques : `INTENTION`, `CONTEXTE`, `LIVRABLES`, `TÂCHES`. Elle ne mentionne pas le critère de convergence. `ADR-002` en fait un élément de la segmentation du travail, `workspace/session.md` en porte un, et `RES-034` en faisait ce qui permet de clore une session.

**Une session abandonnée devient indistinguable d'une session aboutie.** L'état `abandonnee` disparaît au profit de `closed`.

**Les états sont anglais dans un frontmatter français.** `todo`, `open`, `closed`, sous un champ nommé `etat`.

**La session en cours n'a pas d'énoncé.** Trente-cinq tâches, deux jours de travail, et le seul document est `workspace/session.md`, sans frontmatter et sans état.

## Pourquoi cela ne peut pas rester implicite

**Le critère de convergence est ce qui distingue une session d'une liste de tâches.** `ADR-002` fonde la segmentation du travail sur trois éléments : intention, livrable, critère de convergence. Deux subsistent. Sans le troisième, rien ne dit quand une session est finie, et `clia ses close` devient un geste sans critère.

**Le sort d'une session avortée est une information de valeur.** Une session close est une session dont on croit le travail abouti. Deux sessions archivées du dépôt sur quatre n'ont pas de `end-at` : elles n'ont jamais été closes, et rien ne dit si elles ont convergé ou été laissées.

**Le mélange de langues est le même défaut qu'ailleurs.** `DCN-016` introduit `maturity`, `adoption` et `activated` dans un frontmatter français ; `ISU-009` garde la question ouverte. Trois valeurs anglaises s'y ajoutent, sous un champ français.

**Sans énoncé, la mesure repose sur un repli.** `clia ses status` lit `workspace/session.md` faute d'énoncé, en déduit le titre du nom d'un répertoire de journal, et l'ouverture de la date de création du fichier dans git. Cela fonctionne, et rien de tout cela n'est déclaré par la session elle-même.

## Ce que l'agent a mesuré

| Mesure | Valeur |
|---|---|
| Tâches déclarées dans la session en cours | **35** |
| Tâches journalisées jusqu'au message de commit | **32** |
| Répertoires de journal pour cette seule session | **2** |
| Sessions archivées sans date de fin | **2 sur 4** |
| Instances `SES` actives | **0** |

**Deux répertoires de journal pour une session.** `2026-08-09-SES-<slug>` et `SES-001-<slug>`, séquelle du renommage du 2026-08-11. Le module lit les deux, et cette tolérance est de la dette.

## Questions

### Q1 - Le critère de convergence disparaît-il, ou change-t-il de place ?

Trois possibilités : il devient une rubrique de la session, il devient un champ du frontmatter, ou il est absorbé par `LIVRABLES`, un livrable produit valant critère.

La demande ne tranche pas. `ADR-002` suppose qu'il existe.

### Q2 - Une session abandonnée se distingue-t-elle d'une session aboutie ?

Si oui, il faut un quatrième état ou un champ qui porte le motif de la clôture. Si non, l'information est perdue au moment où elle est produite.

### Q3 - Les états restent-ils en anglais ?

`todo`, `open`, `closed`, ou `planifiee`, `ouverte`, `close`. La question est celle de `ISU-009`, appliquée à un champ de plus.

### Q4 - La session en cours reçoit-elle un énoncé, et par quel geste ?

`clia ses new` est réservé à l'humain, et la session en cours travaille depuis deux jours sans énoncé. L'enregistrer rétroactivement suppose de reprendre le contenu de `workspace/session.md`, document de régime humain.

**Cette question est celle de `NON-028` Q5**, restée ouverte depuis le 2026-08-11, et le module la rend concrète : sans énoncé, la moitié des informations affichées par `clia ses status` sont déduites plutôt que déclarées.

### Q5 - Le fichier de session vivant devient-il un lien vers l'énoncé ouvert ?

C'est la forme qui supprimerait tout repli : `workspace/session.md` pointerait vers l'énoncé de la session ouverte, et `CLAUDE.md` resterait valide sans changement. `ADR-017` D3 emploie déjà ce mécanisme pour `INTENTION.md`.

Le geste appartient à l'humain : il touche le point d'entrée déclaré du système.

## Ce que l'agent recommande

**Q1 : conserver le critère de convergence**, comme rubrique ou comme champ. C'est le seul point où l'agent tient la demande pour probablement incomplète plutôt que délibérée : `ADR-002` le nomme, et rien dans la tâche 35 ne dit de le retirer.

**Q4 avant Q5.** Un énoncé d'abord, le lien ensuite : le lien sans énoncé ne pointe sur rien.

## Relations

- `porte-sur` [RES-034](../ressources/RES-034-session.md)
- `reference` [NON-028](NON-028-consequences-du-systeme-de-journalisation.md)
- `reference` [ISU-009](../issues/ISU-009-revision-du-modele-de-frontmatter.md)
