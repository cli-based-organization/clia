---
type: ressource
id: RES-018
title: "Skill"
version: 0.1.0
status: draft
maturity: conception
adoption: propose
activated: true
domain-status: "actif"
prefixe: skl
emplacement: ".dev/skills/skl-<SEQ>-<nom>/SKILL.md"
cycle-de-vie: vivant
edition: ia
famille: controle
champs-obligatoires: [type, id, name, version, status, description]
relations-admissibles: [skill, ressource, methodologie, principe]
sections: [Quand invoquer, Procédure, Gabarit, Validation, Erreurs fréquentes, Relations]
skill: skl-005-ressource-de-controle
adr: ADR-012
statut: actif
---

# RES-018 - Skill

> Un skill encadre la production d'une ressource : il dit comment on la fait, et comment on vérifie qu'elle est bien faite. Il ne dit ni ce qu'elle est, ni pourquoi elle existe.

## Objet

Définit le type `skill`. C'est le troisième terme du triplet qui accompagne un type de ressource, aux côtés de la définition et de la décision.

## Ce qu'un skill porte

Cinq choses. Quand l'invoquer, et quand ne pas l'invoquer. La procédure, en étapes ordonnées. Un gabarit. Des contrôles de validation, exécutables si possible. Et les erreurs fréquentes, chacune rattachée au contrôle qui l'aurait détectée.

La dernière rubrique est ce qui fait qu'un skill survit : un contrôle sans motif ne résiste pas à la première fois où il dérange.

## Le skill est attaché à la famille, non au type

Décision de `ADR-005` D4, et c'est la propriété la plus importante de ce type. Trois niveaux portent le processus : `skl-001` porte les règles communes à toute ressource, un skill par famille porte le processus commun à la famille, la définition du type porte les spécificités.

Un type ne reçoit un skill propre que si son processus s'écarte de celui de sa famille.

## Le champ name plutôt que title

Un skill porte un champ `name` et non un champ `title`, seule exception du modèle. La convention est imposée par l'outil qui charge les skills, non par ce dépôt.

C'est un deuxième point, après l'emplacement, où ce type échappe aux règles communes. `NON-011` Q5 demande à bon droit si un objet dont l'emplacement et le frontmatter échappent tous deux à la règle est encore une ressource.

## Emplacement particulier

Un skill vit dans un répertoire, `skl-<SEQ>-<nom>/SKILL.md`, convention imposée par l'outil et non par ce dépôt. Son identité dérive du nom du répertoire, ce qui fait de lui l'exception que le contrôle V7 de `skl-001` doit prévoir.

## Cycle de vie et édition

`vivant`, `co-edition`. Un skill est un accord sur une manière de faire.


## Cycle de vie métier : `domain-status`

`DCN-016` pose que `domain-status` porte le cycle de vie métier du type, et que chaque définition en déclare l'énumération.

**Aucune.** Ce type n'a pas de cycle de vie métier propre : son état est entièrement décrit par les trois champs universels `maturity`, `adoption` et `activated`.

## Relations

- `reference` [RES-001](RES-001-ressource.md)
- `reference` [RES-013](RES-013-methodologie.md)
- `reference` [ADR-005](../adr/ADR-005-regroupement-fonctionnel-des-ressources.md)

## Points ouverts

| Question | Objection |
|---|---|
| Un skill est-il une ressource, alors que son emplacement échappe à la règle | `NON-011` Q5 |
| Où passe la frontière entre skill et méthodologie | `NON-017` |
