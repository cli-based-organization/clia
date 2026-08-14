---
type: adr
id: ADR-018
title: "La documentation d'un type est fournie par le CLI"
version: 0.1.0
status: draft
maturity: conception
adoption: propose
activated: true
domain-status: "propose"
statut-decision: propose
date: 2026-08-13
decideurs: ["human:jvtrudel (demandeur)", "claude-opus-5 (rédaction)"]
---

# ADR-018 - La documentation d'un type est fournie par le CLI

> Comprendre ce qu'est une décision `DCN` demande aujourd'hui d'ouvrir trois fichiers, dont un schéma `cue` qui n'est pas fait pour être lu. Le modèle de ressources est une fonction du système, et `PDC-001` exige qu'une fonction du système soit découvrable depuis le système lui-même.

## Statut

`propose`. Demandé par la tâche 14 de `SES-002` : « Ajouter un ADR qui impose de fournir la documentation des ressources à partir du cli pour satisfaire à PDC-001 ».

**Rédigé par l'agent à la demande explicite de l'humain.** `CONSTITUTION.md` C1 réserve les décisions à l'humain et `NON-024` conteste la pratique ; la demande lève l'objection pour ce cas, non en général.

## Contexte

**Le constat qui l'a déclenché**, dans les mots de l'humain : « c'est difficile de comprendre comment fonctionne les métadata de décision DCN et son cycle de vie également ».

Tout ce qu'il cherchait est écrit, et dispersé.

| Ce qu'il faut savoir | Où c'est écrit | Lisible ? |
|---|---|---|
| Les champs d'une `DCN` | `RES-009`, frontmatter | Oui, noyé dans plusieurs centaines de lignes |
| Leurs valeurs admises | `.dev/schemas/decision.cue` | **Non**, ce fichier n'est pas fait pour être lu |
| Le cycle de vie | `RES-009`, deux endroits distincts | Partiellement |
| Combien d'instances existent | Nulle part | **Non** |

**`clia res show RES-009` exécute `cat`.** Il rend un document, il ne répond pas à une question.

**`PDC-001` est violé.** Le principe exige trois gestes pour découvrir une fonction du système ; ici, aucun nombre de gestes ne suffit, parce que la commande n'existe pas.

## Décision en une phrase

**Tout type de ressource déclaré dans un dépôt `clia` est explicable par le CLI, sans ouvrir aucun fichier.**

## Décisions détaillées

**D1. Le CLI porte un verbe d'explication d'un type.** `clia res explain <ID>`, avec `help` pour synonyme. Il rassemble ce que le type déclare et ce que son schéma contraint.

**D2. L'explication est dérivée, jamais rédigée.** Ses sources sont le frontmatter de la définition et le schéma `cue` du type. Aucune prose n'est écrite pour elle : une documentation rédigée à part se périme, une dérivation ne le peut pas.

C'est la même règle que `ADR-003` D7 pose pour la couche machine-lisible : ce qui est dérivable est dérivé.

**D3. L'explication accepte un type ou une instance.** `clia res explain RES-009` et `clia res explain DCN-016` expliquent tous deux le type `decision`. L'humain qui bute sur une décision a `DCN-016` sous les yeux, pas `RES-009` : lui demander la conversion serait le renvoyer au problème.

**D4. L'explication dit ce qu'elle ne sait pas.** Un champ obligatoire dont le schéma ne contraint pas les valeurs est affiché comme tel — `libre` — plutôt qu'omis. Un type sans schéma le déclare.

**D5. Ce que la commande ne fait pas.** Elle ne remplace pas la définition : `RES-009` porte le sens, les frontières, les objections. L'explication porte la forme. Le lien vers la définition est affiché pour que le passage de l'une à l'autre soit immédiat.

## Conséquences

| Conséquence | Effet |
|---|---|
| Un type neuf est explicable sans travail supplémentaire | La dérivation le couvre dès sa définition écrite |
| Une définition mal remplie se voit | L'explication affiche `À RENSEIGNER` au lieu de le masquer |
| Le schéma `cue` gagne un second lecteur | Il servait à valider ; il documente aussi |
| **La qualité de l'explication dépend de celle des définitions** | Une définition pauvre donne une explication pauvre, et c'est le bon signal |

**Ce que la décision coûte** : un verbe de plus dans une commande qui en a six. `PDC-001` l'exige, `NON-002` conteste la prolifération — mais il s'agit ici d'un verbe, non d'un type.

## Objections ouvertes

**L'agent rédige un ADR, ce que `CONSTITUTION.md` C1 interdit.** La demande explicite de l'humain lève le cas, pas la règle. `NON-024` reste ouverte.

**La dérivation ne rend pas ce que la prose porte.** `clia res explain RES-009` dira quels champs une décision porte et quelles valeurs ils admettent. Il ne dira pas pourquoi le champ `effet` existe, ni ce que `suspendue` engage. `D5` le déclare ; l'humain qui veut le sens doit ouvrir la définition.

## Relations

- `derive-de` [PDC-001](../principes/PDC-001-auto-decouvrabilite.md)
- `reference` [RES-001](../ressources/RES-001-ressource.md)
- `reference` [PLN-016](../plans/PLN-016-commande-d-explication-d-un-type.md)
