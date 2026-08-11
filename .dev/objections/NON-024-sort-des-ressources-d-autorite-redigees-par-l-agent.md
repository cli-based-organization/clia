---
type: objection
id: NON-024
title: "Sort des douze ressources d'autorité rédigées par l'agent"
status: draft
initiateur: agent
effet: bloquant
etat: ouverte
porte-sur: [RES-009, RES-012, RES-019]
---

# NON-024 - Sort des douze ressources d'autorité rédigées par l'agent

> `CONSTITUTION.md` C1 réserve à l'humain la création des décisions et des principes de conception. Les dix `DCN` et les deux `PDC` du dépôt ont toutes été rédigées par l'agent, et sept affirment `effet: en-vigueur` sans que l'humain ait posé ce champ.

## Journal

- 2026-08-10 : ouverte par l'agent, à la tâche 20, avec `CONSTITUTION.md`.

## Ce qui est contesté

Non pas la règle, qui est une décision de l'humain et qui est appliquée. L'état dans lequel elle laisse les douze instances existantes.

**Sept `DCN` affirment une décision acquise que l'humain n'a pas actée.** `FCT-001` F02. Le champ `effet: en-vigueur` a été posé par l'agent. Il dit que la décision est en vigueur ; rien n'établit que l'humain l'ait voulu.

**L'agent ne peut plus les corriger.** C1 lui réserve désormais la teneur entière de ces types. Les ramener à `effet: proposee` serait une modification, donc une violation de la règle qui vient d'être écrite.

**Le dépôt est donc figé dans un état non conforme.** Douze ressources d'autorité, aucune approuvée, aucune modifiable par l'agent, et sept qui se présentent comme en vigueur.

## Pourquoi cela ne peut pas rester implicite

Trois raisons.

**Les sept `DCN` sont citées comme des décisions acquises.** `ADR-008`, `ADR-015` et six `ADR` d'adoption s'appuient sur elles. Si l'une n'est pas approuvée, ce qui en dérive tombe.

**Le fond est probablement bon, et c'est ce qui rend le cas insidieux.** `FCT-001` F04 : les décisions enregistrées ont bien été prises par l'humain, dans le fichier de session ou dans les réponses aux objections. Ce que l'agent a fait est de les rédiger. Un lecteur qui vérifie le fond ne verra rien d'anormal, et le défaut est de forme.

**La règle n'a d'effet que si l'existant est traité.** Une règle qui ne vaut que pour l'avenir laisse douze précédents contraires en place.

## Questions

### Q1 - Que faire des sept `DCN` qui portent `effet: en-vigueur` ?

Trois positions.

Les approuver en bloc : l'humain relit et confirme, et le champ devient exact rétroactivement.

Les ramener à `effet: proposee` : l'état devient exact, et huit `ADR` qui en dérivent se retrouvent adossés à des décisions non actées.

Les laisser telles quelles en déclarant que C1 ne vaut que pour l'avenir : le plus économique, et il laisse douze précédents contraires.

**Réponse.**

### Q2 - Qui corrige, puisque l'agent ne peut plus toucher ces fichiers ?

C1 interdit à l'agent de modifier une `DCN` ou un `PDC`. Si la réponse à Q1 demande une correction, elle est à la main de l'humain, sur douze fichiers.

Une exception ponctuelle et écrite peut-elle être accordée à l'agent pour cette correction précise, ou l'interdit est-il absolu dès maintenant ?

**Réponse.**

### Q3 - Le régime des `ADR` doit-il changer aussi ?

C1 nomme `DCN` et `PDC`. Les `ADR` restent en `co-edition`, et le dépôt en compte quinze, tous rédigés par l'agent.

Un `ADR` porte des alternatives écartées et un raisonnement, ce qui en fait un document d'analyse. Il porte aussi des décisions numérotées qui font autorité, ce qui en fait un document de décision. La demande de la tâche 20 ne le tranche pas.

**Réponse.**

### Q4 - `clia res new` doit-il refuser à un agent de créer une `DCN` ou un `PDC` ?

C1 autorise l'agent à produire le gabarit. La commande ne fait aucune distinction aujourd'hui.

Deux positions : laisser l'agent produire le gabarit, ce que C1 prévoit, ou lui refuser aussi la création pour que le geste entier appartienne à l'humain.

**Réponse.**

## Ce qui lèverait cette objection

Une réponse à Q1.

L'effet est `bloquant` : huit `ADR` du dépôt dérivent de `DCN` dont le statut d'approbation n'est pas établi. Produire davantage de documents qui en dépendent aggraverait la dette.

## Relations

- `objecte-a` [RES-009](../ressources/RES-009-decision.md)
- `objecte-a` [RES-012](../ressources/RES-012-principe-de-conception.md)
- `objecte-a` [RES-019](../ressources/RES-019-adr.md)
- `derive-de` [FCT-001](../faits/FCT-001-ressources-d-autorite-redigees-par-l-agent.md)
