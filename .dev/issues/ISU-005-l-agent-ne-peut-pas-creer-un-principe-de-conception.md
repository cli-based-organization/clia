---
type: issue
id: ISU-005
title: "L'agent ne peut pas créer un principe de conception"
status: draft
initiateur: agent
etat: ouverte
ouverture: 2026-08-11
---

# ISU-005 - L'agent ne peut pas créer un principe de conception

> `CONSTITUTION.md` C1 réserve la création d'un `PDC` à l'humain. Un chantier de `PLN-005` en demande un. `PDC-003` a pourtant été produit par l'agent et déclaré non actif, sur une analogie que rien ne fonde.

## Journal

- 2026-08-11 : ouverte par l'agent, tâche 29, comme thématique T4 de la réévaluation de `PLN-005`.

## La problématique

Le chantier E de `PLN-005` demande un `PDC` sur la distillation, à la demande de la réponse Q4 de `NON-004`.

`CONSTITUTION.md` C1 l'interdit : « Un agent IA ne crée ni ne modifie une décision (`DCN`) ni un principe de conception (`PDC`). »

Le chantier est donc bloqué, non par un manque technique, mais par une règle.

## Ce qui la rend difficile

**Un précédent existe et il n'est pas régularisé.** `PDC-003` a été produit par l'agent à la tâche 23, sur demande explicite de l'humain, et déclaré non actif par analogie avec le régime que `DCN-013` fixe pour les décisions.

Cette analogie n'est écrite nulle part. `NON-027` Q1 la porte depuis le 2026-08-11.

**`DCN-013` est plus permissive que C1, et elle lui est supérieure.** Elle autorise l'agent à rédiger un premier jet de décision, suspendu jusqu'à approbation. C1 interdit les deux types sans distinguer.

`ANL-006` C2 établit ce conflit, et `PLN-003` chantier A propose de l'aligner. Aucun n'est exécuté.

**Le blocage est asymétrique.** L'agent peut produire le gabarit, ce qui ne sert à rien pour un principe : ce qui compte est le contenu.

## Ce qui a été tenté

**`PDC-003`, à la tâche 23.** Produit, déclaré non actif, signalé par une objection. L'humain n'a pas tranché.

**Deux gabarits vides de `DCN`, aux tâches 21 et 22.** La conduite stricte, appliquée aux décisions. Elle a produit deux formulaires à remplir plutôt que deux brouillons à approuver.

`ANL-006` C2 relève que sous `DCN-013`, l'agent aurait pu les rédiger.

## Pistes

**P1. Exécuter le chantier A de `PLN-003`.** Aligner C1 sur `DCN-013` : la création est réservée à l'humain, la rédaction est permise à l'agent, le résultat est suspendu. Un fichier, trois éditions.

**P2. Étendre le régime aux `PDC` explicitement.** C1 nomme les deux types dans la même phrase ; `DCN-013` ne parle que des décisions. Étendre demande une décision.

**P3. Maintenir l'interdit strict.** `PDC-003` est alors à retirer et à réécrire par l'humain, et le chantier E attend.

**P4. Distinguer selon que l'humain a demandé.** Une demande explicite lèverait l'interdit. C'est ce que l'agent a fait à la tâche 23 sans y être autorisé.

## Ce qui la clôturerait

Une réponse à `NON-027` Q1.

Elle règle le cas de `PDC-003`, débloque le chantier E, et fixe la conduite pour les prochains.

## Relations

- `objecte-a` [NON-033](../objections/NON-033-autorite-de-creation-des-principes.md)
- `reference` [PLN-005](../plans/PLN-005-ajustement-au-savoir-relationnel.md)
- `reference` [PDC-003](../principes/PDC-003-smart-et-extreme-smart.md)
