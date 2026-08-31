# Demande interprétée, tâche 22

## Énoncé

Tâche 22 de `workspace/session.md`, `[traitement des objections]` : prendre en compte les réponses à `NON-003`.

## Ce que les réponses portent

Sept réponses de l'humain, du 2026-08-10, aux sept questions de `NON-003`.

| Question | Ce que la réponse tranche |
|---|---|
| Q1 | `INTENTION.md` est un **lien symbolique** vers une instance `INT`, créé à l'initialisation d'un dépôt |
| Q2 | L'affect **entre** dans le contexte, déduit de `session.md` |
| Q3 | **Les décisions relèvent de `DCN`, non de `ADR`. L'ADR est une justification générée à partir de `DCN` et de `FRG`** |
| Q4 | Pas de type Acteur pour l'instant |
| Q5 | Un `FCT` est un fait **dont la véracité a été établie par un processus rigoureux et normé**. Le contexte affirme sans vérification |
| Q6 | `peremption` devient facultatif |
| Q7 | Trois types, aucun obligatoire sauf l'intention ultime |

## La réponse qui déborde sa question

Q3 demandait s'il manque un type pour la décision de cap. La réponse ne répond pas à cette question : elle redéfinit le rôle de l'ADR.

C'est la conséquence la plus lourde des sept, et elle touche seize documents du dépôt.

## Contrainte héritée de la tâche 20

`CONSTITUTION.md` C1 interdit à l'agent de créer une `DCN`. Le traitement d'une objection en produirait une.

**Conduite retenue**, identique à la tâche 21 : le gabarit `DCN-012` est produit et laissé à l'humain ; `ADR-017` instruit les conséquences sans les acter.

**Tension nouvelle.** Sous la réponse Q3, un ADR dérive d'une `DCN`. `ADR-017` instruit donc une décision qu'il enfreint en existant, puisque sa `DCN` source n'est pas rédigée. La tension est déclarée dans son statut et portée par `NON-026`.

## Ressources livrables

| Livrable | Nature |
|---|---|
| `ADR-017` | Création, huit décisions |
| `RES-002` | L'affect y entre, `peremption` facultatif, régime de fiabilité |
| `RES-003` | Lien symbolique, emplacement dérogatoire retiré |
| `RES-005` | Test d'admission à quatre conditions |
| `RES-009`, `RES-019` | Frontière avec l'ADR inversée, l'ADR devient dérivé |
| `contexte.cue`, `skl-001` | Alignement |
| `NON-003` | Passage à `repondue` |
| `NON-026` | Création, cinq questions |
| `DCN-012` | Gabarit, laissé à l'humain |
