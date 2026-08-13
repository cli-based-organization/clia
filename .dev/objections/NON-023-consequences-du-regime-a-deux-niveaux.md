---
type: objection
id: NON-023
title: "Conséquences du régime d'identification à deux niveaux"
status: draft
initiateur: agent
effet: conditionnel
etat: repondue
porte-sur: [ADR-008, RES-001, RES-009, MET-002]
---

# NON-023 - Conséquences du régime d'identification à deux niveaux

> `ADR-008` sépare l'alias de l'identité et lève l'interdiction de renuméroter. Six conséquences restent indéterminées, dont deux qui laissent une règle sans remplaçant et une qui empêche d'écrire correctement la décision elle-même.

## Journal

- 2026-08-10 : ouverte par l'agent, à la tâche 18, avec `DCN-008` et `ADR-008`.
- 2026-08-13 : passe a `repondue` par `PLN-010`, chantier B. Critere mecanique : chaque question porte une reponse. Aucune reponse n'a ete interpretee.

## Ce qui est contesté

Non pas les onze réponses de l'humain, qui sont des décisions. Six conséquences que `ADR-008` laisse ouvertes, et une lacune de modélisation qu'il a rencontrée en s'écrivant.

**L'identité de l'oeuvre n'a pas de porteur.** `ADR-008` D5 pose que l'identité désigne l'oeuvre. D2 pose que l'alias ne la porte pas. Rien ne dit ce qui la porte à l'interne.

**Une règle est retirée sans remplaçant.** `ADR-007` D2 posait qu'un numéro libéré par une suppression n'est jamais réattribué. `ADR-008` D3 abroge la décision qui portait cette règle. La réattribution n'est désormais ni interdite ni permise.

**Une obligation nouvelle n'est outillée par rien.** `ADR-008` D3 exige que tout changement d'alias propage la mise à jour à toutes les références internes. Aucune commande ne le fait, aucun contrôle ne le vérifie.

**Le champ `version` perd sa fonction sans être retiré.** `ADR-008` D5 renvoie le versionnage à la publication externe. Le champ reste obligatoire dans la plupart des types.

**L'identifiant externe est une forme sans définition.** `ADR-008` D7 enregistre la proposition de Q10 en la déclarant non définitive, ce que son auteur a écrit lui-même.

**Le remplacement partiel d'une décision n'est pas modélisé.** `ADR-008` abroge deux des cinq décisions de `ADR-007` et en conserve trois. Le vocabulaire de relations de `RES-001` ne connaît que `remplace`, qui vaut pour un document entier.

## Pourquoi cela ne peut pas rester implicite

Trois raisons.

**Deux règles disparaissent en silence.** La non-réattribution d'un numéro et la stabilité d'un renvoi interne étaient garanties par `ADR-007` D2. Elles ne le sont plus, et aucune décision ne dit ce qui les remplace. Un dépôt dont les renvois peuvent être invalidés sans que rien ne le détecte est dans l'état que `ANL-001` mesure sur le corpus, où douze numéros de skill sur vingt désignent plusieurs choses.

**L'obligation de propagation est la sixième règle écrite et non tenue.** `next-task-14.yaml` en recensait cinq. `NON-005` conteste l'accumulation depuis le 2026-08-09.

**La lacune de modélisation s'est manifestée à la première application.** `MET-002`, écrit à la tâche 14, n'a jamais été éprouvé : aucune `DCN` n'en remplaçait une autre. La tâche 18 fournit le premier cas, et il ne rentre pas dans le mécanisme : `DCN-008` corrige une partie de `DCN-007` sans la remplacer. Le mécanisme central de `MET-002` échoue à sa première épreuve, pour un motif qu'il n'avait pas prévu.

## Questions

### Q1 - Qu'est-ce qui porte l'identité de l'oeuvre à l'interne ?

`ADR-008` D5 pose que l'identité désigne l'oeuvre, D2 pose que l'alias ne la porte pas.

Trois positions. L'identité est portée par un champ nouveau, un `UUID` attribué à la création, ce que la forme de Q10 suppose. L'identité n'est pas représentée à l'interne et n'apparaît qu'à la publication externe. Ou l'alias porte l'identité de fait, tant qu'il ne change pas, ce qui revient à `ADR-007` D1 sous un autre nom.

La deuxième position est la moins coûteuse et laisse le dépôt sans moyen de reconnaître deux copies d'une même oeuvre.

**Réponse.**

### Q2 - Que devient un numéro libéré par une suppression ?

`ADR-007` D2 posait qu'il n'est jamais réattribué et que la séquence a des trous. `ADR-008` D3 abroge la décision qui portait cette règle sans la reconduire.

`clia res new` prend le maximum existant plus un. Un numéro libéré par la suppression de la dernière ressource d'un type est donc réattribué, sans que rien ne le signale. Le cas est déjà relevé par `NON-019` Q5, et l'abrogation le rend actif.

**Réponse.**

### Q3 - Comment la propagation d'un changement d'alias est-elle vérifiée ?

`ADR-008` D3 exige la mise à jour de toutes les références internes dans le même geste.

La commande n'existe pas. Le contrôle non plus. La tâche 13 a fait ce travail à la main sur quatre-vingt-trois identifiants, avec deux précautions consignées dans son journal : traiter les identifiants du plus long au plus court, et employer une frontière de mot. Ces deux précautions sont le cahier des charges de la commande manquante.

Faut-il implémenter `clia res renumber` avant d'autoriser D3, ou accepter un intervalle où la règle est écrite et non tenue ?

**Réponse.**

### Q4 - Le champ `version` a-t-il encore une fonction interne ?

`ADR-008` D5 renvoie le versionnage à la publication externe et le suivi interne à l'historique.

Le champ `version` est obligatoire dans la majorité des types. Aucune `DCN` du dépôt n'a jamais dépassé `0.1.0`. `NON-022` Q1 proposait déjà de le retirer, pour un motif différent, la charge documentaire.

Trois positions : le retirer des champs obligatoires, le conserver pour la publication seule, ou le conserver tel quel et accepter qu'il ne soit pas tenu.

**Réponse.**

### Q5 - Le remplacement partiel d'une décision doit-il être modélisé ?

`DCN-008` corrige deux des cinq décisions de `ADR-007` et en conserve trois. Trois mécanismes existants échouent à le dire.

| Mécanisme | Pourquoi il échoue |
|---|---|
| La relation `remplace` | Vaut pour un document entier. L'employer ferait disparaître trois décisions en vigueur |
| Le champ `effet: remplacee` | Même problème, à l'échelle de la `DCN` |
| `MET-002` étape 6 | Ne connaît que le revirement complet |

Trois positions. Ajouter une relation `abroge-partiellement` avec la liste des décisions visées. Exiger qu'une `DCN` ne porte qu'une décision, ce qui rend le remplacement partiel impossible par construction. Ou considérer qu'un `ADR` est l'unité de remplacement et qu'une décision abrogée à l'intérieur d'un `ADR` se marque dans le texte, ce que `ADR-008` fait aujourd'hui.

La deuxième position a un coût mesurable : `ADR-007` aurait été cinq documents, `ADR-008` en serait sept.

**Réponse.**

### Q6 - L'identifiant externe : quatre inconnues

`ADR-008` D7 enregistre la forme proposée par Q10 sans la retenir.

```
clia://<author|personne qui partage>@<repo>/<origin>:<PREFIX>-<UUID>/<hash-version>
```

Quatre éléments n'ont pas de définition.

| Élément | Ce qui manque |
|---|---|
| `<origin>` | Ce qu'est une instance de dépôt, et ce que « éphémère » implique pour son identifiant |
| `<UUID>` | Où il vit, quand il est attribué, et son articulation avec `<SEQ>` |
| `<author>` | Si c'est le créateur, autorité première selon `FRG-001`, ou le diffuseur, autorité de second ordre |
| `<hash-version>` | Lequel des identifiants de contenu de `ANL-005`, celui du blob ou celui du tree |

Le quatrième a une réponse disponible : `ANL-005` établit que tout chemin, fichier ou répertoire, porte un identifiant de contenu, et que celui d'un répertoire survit à son déplacement.

**Réponse.**

## Ce qui lèverait cette objection

Une réponse à Q1 et Q3.

Q1 dit ce que le système identifie. Q3 outille l'obligation sur laquelle repose la souplesse que `ADR-008` D3 introduit.

L'effet est `conditionnel` : les onze réponses sont enregistrées, `ADR-008` est applicable, aucun fichier n'est renommé et rien de ce qui est produit ne devient invalide. Les six conséquences sont des dettes.

## Relations

- `objecte-a` [ADR-008](../adr/ADR-008-regime-d-identification-a-deux-niveaux.md)
- `objecte-a` [RES-001](../ressources/RES-001-ressource.md)
- `objecte-a` [RES-009](../ressources/RES-009-decision.md)
- `reference` [NON-019](NON-019-identifiant-par-sequence.md)
- `reference` [NON-022](NON-022-charge-et-tenue-du-type-decision.md)
- `reference` [NON-005](NON-005-validation-et-regles-non-tenues.md)
