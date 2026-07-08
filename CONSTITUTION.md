# CONSTITUTION

> Processus de gouvernance entre l'humain et l'agent IA dans ce dépôt. Fichier de harnais — vivant, sujet à évolution (voir `skl-004-harnais`).

## Principe

La gouvernance suit un modèle **objection-sociocratique** :

- l'humain soumet un problème (via `session.md`, point d'entrée unique) ;
- l'agent propose une intervention sous forme d'un **plan** (`PLN-<SEQ>-<SLUG>.md`) ;
- avant toute exécution, des **objections raisonnées** peuvent être émises ;
- l'agent ne peut pas exécuter le plan tant que des objections restent **non résolues**.

## Cycle de vie d'un plan

```
proposé → objection → résolu → approuvé → exécuté
```

- **proposé** : le plan existe, aucune objection n'a encore été traitée.
- **objection** : au moins une objection (humaine ou agent) est ouverte.
- **résolu** : toutes les objections ont reçu une réponse (levée, amendement, ou argumentation acceptée).
- **approuvé** : plus aucune objection ouverte ; l'exécution est autorisée.
- **exécuté** : les livrables prévus par le plan ont été produits.

Le champ **Statut** en tête du fichier de plan reflète l'état courant du cycle.

## Objection raisonnée

Une objection est un **risque concret** identifié dans le plan proposé — pas une simple préférence esthétique. Elle doit pouvoir s'énoncer comme : « si ce plan est exécuté tel quel, [conséquence identifiable] va se produire ou est susceptible de se produire ».

Une objection est levée par :
- un amendement du plan qui neutralise le risque identifié, ou
- une argumentation qui convainc l'objecteur que le risque n'est pas réel ou est acceptable.

## Canaux d'objections (séparés)

| Origine | Consignée dans |
|---|---|
| Humain | `.dev/session.md` |
| Agent IA | le plan concerné (section « Objections de l'agent IA ») |

L'agent a l'obligation de soulever ses propres objections dans le plan qu'il propose — il ne se contente pas d'exécuter une demande à la lettre s'il y voit un risque.

## Règle absolue

Aucune exécution d'un plan tant qu'une objection — humaine ou agent — reste ouverte.
