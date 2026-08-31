---
type: acteur
version: 0.1.0
title: "Collaborateur futur"
status: À réviser
date: 2026-07-29
categorie: partie-prenante
portee: methode
---

# ACT-008 - Collaborateur futur

## Définition

L'humain qui **rejoint un dépôt équipé après coup**, sans avoir participé à sa construction et sans accès à son auteur. Il devra comprendre le système par ses seuls fichiers, puis y travailler.

Partie prenante **hors scène** au moment où le système est conçu, mais rôle décisif : c'est lui qui mesure, à son arrivée, si le système est réellement compréhensible ou seulement familier à ceux qui l'ont écrit.

## Responsabilité

Aucune tant qu'il n'est pas arrivé. Une fois arrivé, il tient l'un des rôles primaires du catalogue et cesse d'être une partie prenante.

## Buts poursuivis

Aucun dans le système avant son arrivée. Ce rôle sert de **critère d'évaluation** appliqué à la conception : ce qui n'est compréhensible que par son auteur ne satisfait pas ce rôle.

## Intérêts

- La **découvrabilité** : trouver ce qui existe sans savoir déjà que ça existe ([`PDC-007`](../principes/PDC-007-decouvrabilite-et-uniformite.md)).
- L'**uniformité** : que deux choses semblables se présentent de la même façon, ce qui permet d'inférer plutôt que d'apprendre par coeur.
- La possibilité de **remonter le pourquoi** d'une décision, pas seulement de constater son résultat.
- Une documentation qui décrit **ce dépôt-ci**, et non un autre.

## Préconditions d'accès

- Un accès au dépôt.
- Aucune connaissance préalable du système : c'est précisément l'hypothèse de ce rôle.

## Modes d'échec caractéristiques

- Il lit une documentation qui décrit **un autre système** que celui qu'il a sous les yeux, vestige d'un dépôt d'origine (constat [C7](../analyses/ANL-014-cas-usage-et-acteurs-de-clia.md#constats)).
- Il ne découvre pas une capacité existante parce que rien ne la mentionne là où il regarde (écart déjà consigné par [`BUG-006`](../bugs/BUG-006-decouvrabilite-uniformite-non-implementee.md)).
- Il trouve deux énoncés contradictoires de la même règle et ne sait pas lequel fait autorité.
- Il comprend ce que fait le système sans comprendre **pourquoi**, et défait par ignorance une décision délibérée.

## Ce que ce rôle ne fait pas

- Il ne participe à aucun parcours tant qu'il n'a pas rejoint le dépôt.
- Il ne se confond pas avec le destinataire des livrables ([`ACT-007`](ACT-007-destinataire-des-livrables.md)), qui reste à l'extérieur.

## Relations

- **Rôles voisins** : [`ACT-001`](ACT-001-operateur-du-depot.md), [`ACT-004`](ACT-004-mainteneur-du-systeme-augmentation.md) (rôles qu'il tiendra), [`ACT-007`](ACT-007-destinataire-des-livrables.md).
- **Intérêt servi par** : les exigences de découvrabilité et d'uniformité ([`PDC-007`](../principes/PDC-007-decouvrabilite-et-uniformite.md)) et la traçabilité des décisions ([`PDC-009`](../principes/PDC-009-tracabilite-et-versionnage-atomique.md)).
- **Source** : typologie P2 d'[`ANL-014`](../analyses/ANL-014-cas-usage-et-acteurs-de-clia.md#typologie-des-utilisateurs-et-des-parties-prenantes).
