---
type: bogue
id: BUG-005
title: "Aucune directive actionnable à la fin d'une exécution"
status: draft
maturity: conception
adoption: propose
activated: true
domain-status: "ouvert"
regle: "Une tâche rend à l'humain un geste unique, exécutable, et cohérent avec clia focus"
constate-le: 2026-08-13
etat: ouvert
---

# BUG-005 - Aucune directive actionnable à la fin d'une exécution

> Deux plans exécutés, deux échecs déclarés, treize journaux produits — et l'humain ne sait pas quoi faire. Le geste qui débloque cinq chantiers n'apparaît dans aucune commande du système.

## Journal

- 2026-08-13 : rapporté par l'humain, tâche 13 de `SES-002`, après les tâches 11 et 12.

**L'énoncé du rapport**, repris tel quel :

> Les plans PLN-015 et PLN-017 ont été exécutés pendant 8 minutes mais ils ont échoué ou n'ont rien produit ou n'ont pas bien rapporter le problème. Aucune directive claire et compréhensible pour l'humain n'a été fournit pour avancer et débloquer la situation. Ce n'est pas un comportement acceptable.

*`PLN-017` n'existe pas ; les plans exécutés aux tâches 11 et 12 sont `PLN-007` et `PLN-015`.*

## L'écart

**Le comportement attendu.** Une tâche se termine sur un geste que l'humain peut exécuter.

**Le comportement constaté.**

| Mesure | Valeur |
|---|---|
| Suites proposées sur treize tâches | **51**, dont 26 pour l'humain |
| Items en attente | **61** |
| Items destinés à l'humain que `clia focus` affiche | **3** |
| Décisions suspendues visibles dans `clia focus` | **0** |
| Position du geste débloquant dans ce qui a été rendu | **dernière ligne**, après le rapport |
| Réponses différentes à « que dois-je faire » | **2**, celle de l'agent et celle de `clia focus` |

**`DCN-016` débloque cinq chantiers de `PLN-007`, et n'est un item pour personne.** La commande ne le mentionne que comme motif d'un plan rangé à défricher.

## La règle enfreinte

**Une tâche rend à l'humain un geste unique, exécutable, et cohérent avec `clia focus`.**

Elle n'était écrite nulle part. `MET-005` prescrivait seulement « propose l'action utile », sans dire où, sous quelle forme, ni combien. **Une règle sans format ni contrôle ne tient pas** — c'est le défaut que `NON-005` décrit.

## Comment le reproduire

1. Exécuter un plan bloqué par une décision suspendue.
2. Constater l'échec, le journaliser selon `MET-003`.
3. Lancer `clia focus`.
4. Constater qu'il désigne un travail d'agent, et jamais la décision à approuver.

**Reproduit deux fois**, tâches 11 et 12.

## La cause

Trois défauts s'additionnent, détaillés dans `ANL-013`.

| Réf | Défaut |
|---|---|
| D1 | `clia focus` répond à « quelle est la priorité du dépôt », non à « que dois-je faire, moi » |
| D2 | Le geste qui débloque un plan n'est modélisé nulle part |
| D3 | Rien ne dit où va la directive, sous quelle forme, ni combien il y en a |

**D2 est le prolongement de `BUG-004`** : l'exécutabilité d'un plan n'est pas modélisée, son déblocage non plus.

## La correction

**Appliquée le 2026-08-13, tâche 13.**

| Réf | Correction |
|---|---|
| S1 | Une décision `suspendue` devient un item : catégorie `A APPROUVER`, destinataire humain |
| S2 | Ce qui débloque des chantiers passe devant ce que personne n'attend |
| S3 | `clia focus --humain` et `--agent` filtrent sur le destinataire |
| S4 | `MET-005` porte le format de la directive et la règle de cohérence avec `clia focus` ; `skl-006` impose qu'un plan bloqué déclare par quel geste il se lève |

## Ce que la correction ne fait pas

**Elle ne fait pas descendre le compteur.** `S1` l'augmente même d'un item. Ce qui change est que l'humain voit lequel prendre.

**Elle ne garantit pas que la directive soit la bonne**, seulement qu'il y en ait une, unique et exécutable.

**Le bogue reste ouvert** jusqu'à ce qu'une tâche suivante se termine sur un geste que l'humain exécute sans demander de précision. C'est la seule mesure qui compte, et elle appartient à l'humain.

## Relations

- `derive-de` [ANL-013](../analyses/ANL-013-pourquoi-l-humain-ne-peut-pas-agir.md)
- `reference` [BUG-004](BUG-004-un-plan-smart-n-est-pas-executable-et-rien-ne-le-signale.md)
- `reference` [MET-005](../methodologies/MET-005-execution-d-un-plan.md)
