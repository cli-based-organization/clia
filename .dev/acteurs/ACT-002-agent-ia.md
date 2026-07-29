---
type: acteur
version: 0.1.0
title: "Agent IA"
status: proposé
date: 2026-07-29
categorie: primaire
portee: methode
---

# ACT-002 - Agent IA

## Définition

Le modèle de langage agentique qui **produit les livrables porteurs de jugement** sous le régime du harnais : plans, recherches de fondation, analyses, décisions, principes, spécifications, exigences, bogues, code, et la trace de chaque tâche.

C'est un acteur **primaire** et non un outil : il a des buts propres (comprendre la demande, produire un livrable conforme, signaler un risque), il peut objecter, et il échoue de façons qui lui sont spécifiques. Il se distingue en cela de l'automatisme déterministe, qui n'est pas un acteur mais une partie du système décrit.

## Responsabilité

Répond de la **conformité de ce qu'il produit** au harnais et de la **journalisation** de chaque tâche. Répond aussi de l'obligation d'**objecter** : il ne se contente pas d'exécuter une demande à la lettre s'il y voit un risque concret ([`CONSTITUTION.md`](../../CONSTITUTION.md)).

## Buts poursuivis

- Lire la demande et le harnais, et en déduire l'intention, le contexte et la forme attendue du livrable.
- Proposer une intervention avant de l'exécuter.
- Produire un livrable conforme au type demandé.
- Signaler un risque concret plutôt que de l'absorber silencieusement.
- Laisser une trace vérifiable de ce qu'il a fait.

## Intérêts

- Que la demande soit **écrite** et non conversationnelle : il ne participe à aucune discussion d'équipe et ne peut pas récupérer le sens ailleurs que dans les fichiers ([`PDC-004`](../principes/PDC-004-interface-fichiers-pas-conversation.md), constat [C9](../analyses/ANL-014-cas-usage-et-acteurs-de-clia.md#constats)).
- Que la forme attendue de chaque livrable soit **spécifiée** quelque part de stable.
- Que la frontière entre ce qui relève du jugement et ce qui relève de l'automatisme soit nette ([`PDC-002`](../principes/PDC-002-ia-seulement-si-necessaire.md)).

## Préconditions d'accès

- Un dépôt équipé dont le harnais est lisible depuis la racine.
- Une demande formulée dans le point d'entrée unique.
- Un accès en lecture à l'ensemble du dépôt et en écriture aux seules zones que la classification des documents lui ouvre.

## Modes d'échec caractéristiques

- Il **déborde du périmètre** demandé, ou au contraire le réduit sans le dire.
- Il produit un livrable dans une forme qui n'est pas celle du type demandé.
- Il **omet la trace** de la tâche, ce qui rend le travail invérifiable (écart déjà consigné par [`BUG-001`](../bugs/BUG-001-aucun-log-produit.md)).
- Il prend en charge une mécanique déterministe qui aurait dû revenir à l'automatisme (écart déjà consigné par [`BUG-002`](../bugs/BUG-002-agent-porte-mecaniques-deterministes.md)).
- Il exécute alors qu'une objection reste ouverte, ou touche un fichier en édition humaine uniquement.

## Ce que ce rôle ne fait pas

- Il n'opère aucune action irréversible : pas de git, pas de transition de session, pas de publication de version ([`PDC-010`](../principes/PDC-010-point-entree-unique-autorite-humaine-irreversible.md)).
- Il n'édite jamais les fichiers en édition humaine uniquement.
- Il ne décide pas de l'intention : il la lit, la questionne et la sert.
- Il n'exécute rien tant qu'une objection reste ouverte.

## Relations

- **Rôles voisins** : [`ACT-001`](ACT-001-operateur-du-depot.md) (lui soumet le travail et arbitre), [`ACT-004`](ACT-004-mainteneur-du-systeme-augmentation.md) (fait évoluer le harnais qui le gouverne).
- **Utilise** : aucun `USE` n'existe encore ; les parcours de gouvernance dont ce rôle est co-acteur sont produits à l'étape 3.2 de [`PLN-017`](../plans/PLN-017-cas-usage-acteurs-tracabilite.md).
- **Source** : typologie A2 d'[`ANL-014`](../analyses/ANL-014-cas-usage-et-acteurs-de-clia.md#typologie-des-utilisateurs-et-des-parties-prenantes).
