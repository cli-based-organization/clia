---
type: objection
id: NON-025
title: "Conséquences de la dérivabilité des skills"
status: draft
initiateur: agent
effet: conditionnel
etat: repondue
porte-sur: [RES-018, RES-001, ADR-016]
---

# NON-025 - Conséquences de la dérivabilité des skills

> `ADR-016` D3 pose que les skills sont des ressources générées, qu'ils ne font pas autorité et qu'ils sont entièrement dérivables de `RES`, `ADR`, `SPC` et `RQF`. Aucun générateur n'existe, et les sept skills du dépôt continuent de commander le comportement de l'agent.

## Journal

- 2026-08-11 : ouverte par l'agent, à la tâche 21, avec `ADR-016`.
- 2026-08-11 : **doublon signalé au ménage de la tâche 30.** `NON-030` pose la même question, élargie aux trois familles dérivées et non aux seuls skills. Les questions Q1 et Q2 de cette objection sont reprises par `NON-030` Q1 et Q2. Cette objection reste ouverte pour ses Q3 et Q4, propres aux skills.
- 2026-08-13 : passe a `repondue` par `PLN-010`, chantier B. Critere mecanique : chaque question porte une reponse. Aucune reponse n'a ete interpretee.

## Ce qui est contesté

Non pas la décision, qui est une réponse de l'humain. Quatre conséquences qu'elle laisse indéterminées.

**La décision est prise et inapplicable.** Aucun outil ne dérive un skill de sa définition. Les sept skills sont écrits à la main, et la tâche 17 vient d'en enrichir un avec une règle de registre et un contrôle.

**Ce qui ne se dérive de rien reste sans foyer.** `skl-001` porte des règles que ni `RES-001`, ni un `ADR`, ni une `SPC` ne portent : les trois interdits typographiques d'`A3`, les cinq interdits de registre d'`A6`, les dix contrôles `V1` à `V10`. Si le skill est dérivé, ces règles doivent vivre ailleurs, et cet ailleurs n'existe pas.

**Les types cités comme sources n'existent pas tous.** `ADR-016` D3 nomme `SPC` et `RQF` comme sources de dérivation. Le dépôt compte zéro instance de l'un et de l'autre.

**Le statut des logs n'est pas tranché.** La réponse Q1 le pose comme une question ouverte : « est-ce que les logs sont des ressources ? J'aurais tendance à dire oui. Mais je n'en suis pas certain. »

## Pourquoi cela ne peut pas rester implicite

Trois raisons.

**Une décision inapplicable est une règle non tenue de plus.** `NON-005` conteste cette accumulation depuis le 2026-08-09. `ADR-016` D3 en ajoute une, et elle porte sur les sept documents qui commandent l'agent.

**L'écart s'aggrave à chaque tâche.** La tâche 17 a écrit dans `skl-001` une règle `A6` et un contrôle `V10` que rien ne dérive. Chaque enrichissement d'un skill creuse la distance avec la décision.

**Le statut des logs commande le volume.** Le dépôt en produit sept par tâche. S'ils sont des ressources, ils ont besoin d'un type, d'un schéma et d'un emplacement conventionnel. S'ils n'en sont pas, ils échappent au modèle et `ADR-016` D1 ne les couvre pas.

## Questions

### Q1 - Où vivent les règles qu'aucune source ne porte ?

`skl-001` porte trois interdits typographiques, cinq interdits de registre, et dix contrôles de validation. Aucun n'est déductible d'une définition `RES`.

Trois positions. Les remonter dans `RES-001`, qui deviendrait le porteur des règles d'écriture de toute ressource. Les porter dans un `ADR` de méthode, ce qui les rend décidées et non dérivées. Ou admettre qu'un skill porte une part irréductible, ce qui contredit « entièrement dérivables ».

**Réponse.**

### Q2 - Que dérive-t-on tant que `SPC` et `RQF` n'ont aucune instance ?

`ADR-016` D3 nomme quatre sources : `RES`, `ADR`, `SPC`, `RQF`. Les deux dernières ont zéro instance dans le dépôt.

Faut-il produire les `SPC` et `RQF` manquants avant de dériver, ou la dérivation se contente-t-elle des deux premières sources ?

**Réponse.**

### Q3 - Les logs sont-ils des ressources ?

Question de l'humain, laissée ouverte dans sa réponse Q1 de `NON-002`.

Le dépôt en produit sept par tâche, soit plus de cent au 2026-08-11. Ils portent une structure conventionnelle, ils sont cités, ils survivent aux sessions. Ce sont les critères d'une ressource.

Ils n'ont ni type, ni schéma, ni frontmatter, et `ADR-001` D8 place le journal hors du modèle au même titre que les harnais.

**Réponse.**

### Q4 - Que devient l'autorité de `skl-001` en attendant ?

`ADR-016` D3 pose que les skills ne font pas autorité. `skl-001` est aujourd'hui le document que l'agent lit avant d'écrire toute ressource, et le seul qui porte les contrôles de validation.

Faut-il suspendre D3 jusqu'à ce que le générateur existe, ou déclarer que `skl-001` fait autorité par exception, ou accepter l'écart en le nommant ?

**Réponse.**

## Ce qui lèverait cette objection

Une réponse à Q1 et Q4.

Q1 dit où vont les règles qui n'ont pas de source. Q4 dit ce qui commande l'agent d'ici là.

L'effet est `conditionnel` : la décision est prise, rien de ce qui existe n'est invalidé, et les sept skills continuent de fonctionner. Ce qui est en cause est l'écart entre la décision et l'outillage.

## Relations

- `objecte-a` [RES-018](../ressources/RES-018-skill.md)
- `objecte-a` [RES-001](../ressources/RES-001-ressource.md)
- `derive-de` [NON-002](NON-002-cout-du-modele.md)
- `reference` [NON-005](NON-005-validation-et-regles-non-tenues.md)
- `reference` [NON-030](NON-030-generateur-absent.md)
