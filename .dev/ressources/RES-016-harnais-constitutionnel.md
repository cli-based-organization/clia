---
type: ressource
id: RES-016
title: "Harnais constitutionnel"
version: 0.1.0
status: draft
prefixe: aucun
emplacement: "CONSTITUTION.md"
cycle-de-vie: vivant
edition: co-edition
famille: controle
champs-obligatoires: [type, version, title, status]
relations-admissibles: [harnais, ressource, decision, objection]
sections: [Principe, Règles impératives, Classification des documents, Arbitrage]
skill: skl-005-ressource-de-controle
adr: ADR-012
statut: non-installe
---

# RES-016 - Harnais constitutionnel

> Le harnais constitutionnel porte les règles impératives qui ont préséance sur toute autre consigne. Il est court par nécessité : une constitution longue n'est pas lue.

## Objet

Définit le type du fichier `CONSTITUTION.md`. Sa fonction est de porter le petit nombre de règles qu'aucune autre consigne ne peut lever.

## Ce que le corpus enseigne sur ce type

`ANL-001` fournit une mesure et un contre-exemple.

La mesure : trente-deux `CONSTITUTION.md` dans le corpus portent quinze contenus distincts, dont un de zéro octet jamais détecté.

Le contre-exemple : la constitution de `ticket-driven-ai` tient en **deux règles**, l'agent ne modifie jamais un ticket, et les harnais sont la source de vérité permanente. Celle de ce dépôt en comptait cent quatorze lignes. La première est un modèle de sobriété que la seconde a perdu.

## Ce qu'un harnais constitutionnel porte

Les règles impératives, numérotées, chacune avec ce qu'elle interdit et ce qu'elle autorise. La classification des documents par droits d'édition. Le mécanisme d'arbitrage en cas de conflit.

Une règle qui peut être levée par une instruction ordinaire n'est pas constitutionnelle et n'a pas sa place ici.

## Cycle de vie et édition

`vivant`, nom fixe à la racine, `co-edition`.

## Relations

- `reference` [RES-014](RES-014-harnais-operatoire.md)
- `reference` [ADR-002](../adr/ADR-002-adoption-du-processus-de-travail.md)

## Points ouverts

| Question | Objection |
|---|---|
| Ce dépôt doit-il rétablir un `CONSTITUTION.md`, ou `ADR-002` suffit-il | `NON-017` |
