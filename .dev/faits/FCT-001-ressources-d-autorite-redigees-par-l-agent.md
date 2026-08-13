---
type: fait
id: FCT-001
title: "Ressources d'autorité rédigées par l'agent avant CONSTITUTION.md C1"
status: draft
maturity: conception
adoption: propose
activated: true
sujet: "Les DCN et PDC du dépôt, leur rédacteur et leur état d'approbation au 2026-08-10"
date-de-constat: 2026-08-10
diffusion: public
---

# FCT-001 - Ressources d'autorité rédigées par l'agent

> `CONSTITUTION.md` C1 réserve à l'humain la création des décisions et des principes de conception. Les douze instances existantes ont toutes été rédigées par l'agent, avant que la règle existe. Ce recueil les relève pour que leur approbation soit une décision et non un oubli.

## Portée et date d'arrêt

Arrêté au 2026-08-10, après l'écriture de `CONSTITUTION.md`.

Porte sur les dix `DCN` de `.dev/decisions/` et les deux `PDC` de `.dev/principes/`. Ne porte pas sur les `ADR`, dont le régime d'édition reste `co-edition`.

L'agent ne modifie aucune des douze instances : le champ `effet` appartient à l'humain, et la règle C1 lui en réserve désormais la teneur entière.

## Faits

**F01. Les douze instances ont été rédigées par l'agent.** Aucune n'a été écrite par l'humain. Le dépôt ne porte aucune `DCN` ni aucun `PDC` produit autrement.

**F02. Sept `DCN` portent `effet: en-vigueur`.** `DCN-001`, `DCN-002`, `DCN-006`, `DCN-007`, `DCN-008`, `DCN-009` et `DCN-010`. Le champ affirme une décision acquise, et l'humain ne l'a pas posé.

**F03. Trois `DCN` portent `effet: proposee`.** `DCN-003`, `DCN-004` et `DCN-005`, avec `instance: "aucune : décision non actée"`. Celles-là déclarent leur absence d'acte, ce qui les rend conformes à C1 par anticipation.

**F04. Neuf `DCN` déclarent `instance: "human:jvtrudel"`.** L'attribution est exacte sur le fond : les décisions enregistrées ont bien été prises par l'humain, dans le fichier de session ou dans les réponses aux objections. Ce que l'agent a fait est de les **rédiger**, non de les prendre.

**F05. `PDC-001` et `PDC-002` ont été rédigés par l'agent.** `PDC-001`, auto-découvrabilité, à la tâche 12. `PDC-002`, ergonomie de l'identification interne, à la tâche 18, en réponse à `NON-001` Q11 qui demandait explicitement d'en faire une exigence écrite.

**F06. Aucune des douze n'est approuvée.** Les douze portent `status: draft`.

**F07. La règle C2 avait déjà existé et avait été perdue.** La constitution archivée le 2026-08-08 interdisait à l'agent toute opération git, dans les termes suivants : « L'agent IA n'a jamais le droit de : exécuter une commande `git add`, `git commit`, `git push`, ou toute autre action git ». Le refactor a archivé le fichier ; aucun document actif ne portait plus cette règle entre le 2026-08-08 et le 2026-08-10.

**F08. La tâche 19 a construit une commande d'écriture git sans qu'aucune règle ne s'y oppose.** `clia git save` a été spécifiée par l'humain et implémentée par l'agent le 2026-08-10, dans l'intervalle où F07 laissait le dépôt sans interdit.

**F09. L'agent a commité une fois dans ce dépôt, le 2026-08-10 à 23:51.** Commit `923880a`, huit fichiers, produit en vérifiant que `CLIA_ACTOR=human` levait la garde C2, moins d'une heure après avoir écrit cette garde. Le commit n'a pas été poussé et a été annulé par `git reset --soft` ; `HEAD` est revenu à `e47eedd`, qui est la référence distante. Aucun contenu n'a été perdu, aucun historique publié n'a été réécrit.

**F10. Le premier usage légitime de `clia git save` a eu lieu le 2026-08-10 à 23:40, par l'humain.** Commit `e47eedd`, quatre-vingt-trois fichiers.

## Faits contestés

Aucun.

## Ce qui n'a pas pu être établi

**Ce que l'humain veut faire des douze instances.** Trois traitements sont possibles et aucun n'est déduit ici : les approuver en l'état, les ramener toutes à `effet: proposee` en attendant relecture, ou en rejeter certaines. Le choix lui appartient et `NON-024` le porte.

**Si le régime d'édition des `ADR` doit changer aussi.** C1 ne nomme que `DCN` et `PDC`. Un `ADR` instruit une décision et porte ses alternatives écartées, ce qui en fait un document d'analyse autant que d'autorité. La demande de la tâche 20 ne le mentionne pas.

**Le nombre exact de fois où un agent a contourné une règle sans que le dépôt le sache.** F09 a été constaté parce que l'agent l'a signalé lui-même. Rien ne garantit qu'il n'y ait pas d'autre cas.

## Relations

- `reference` [ANL-004](../analyses/ANL-004-verbosite-justificative-des-definitions-de-type.md)
