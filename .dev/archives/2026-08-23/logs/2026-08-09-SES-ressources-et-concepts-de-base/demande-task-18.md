# Demande interprétée, tâche 18

## Énoncé

Tâche 18 de `workspace/session.md` :

> [traitement des objections] prendre en compte des réponses à NON-001

## État constaté

`NON-001` porte douze questions. Q1 avait été répondue le 2026-08-10 à la tâche 13. Les onze autres portent désormais une réponse écrite par l'humain.

Q1 porte en outre une seconde mention de l'humain, ajoutée sous la réponse de la tâche 13 : « non. voir FRG-001. »

## Ce que « non » corrige

La réponse consignée à la tâche 13 disait : l'identité est le champ `id` de forme `<PREFIX>-<SEQ>`.

`FRG-001`, section « Système d'identité : autorité, alias et mécanisme de traçabilité », pose deux régimes d'identification, interne et externe, et un système hybride fondé sur « un système d'alias auto-cohérent facilement utilisable en interne » et « des identifiants complets ».

Q4 le confirme : « `<PREFIX>-<SEQ>` est l'implémentation par défaut de l'id-interne/alias de l'identifiant ».

`<PREFIX>-<SEQ>` est donc un **alias**, non l'identité. `ADR-007` D1 et `RES-001` disent le contraire.

## Les onze réponses, et ce qu'elles engagent

| Question | Réponse de l'humain | Engage |
|---|---|---|
| Q1 | L'identité n'est pas l'alias. Voir `FRG-001` | `ADR-007` D1, `RES-001` |
| Q2 | L'identité n'est pas `<PREFIXE>-<SLUG>` | rien de neuf |
| Q3 | `NON` comme préfixe d'objection | acquis, aucun `OBJ` actif |
| Q4 | L'identifiant interne doit être relatif et auto-cohérent. `<PREFIX>-<SEQ>` en est l'implémentation par défaut | `RES-001` |
| Q5 | Identifiant plus robuste à l'externe. Une modification d'alias met à jour toutes les références | **`ADR-007` D2** |
| Q6 | Le slug n'a rien à voir avec l'identifiant, il change sans conséquence | `RES-001` |
| Q7 | `clia res new TYPE DESCRIPTION` attribue le numéro | acquis |
| Q8 | L'identité désigne l'**oeuvre**. La version vient de la publication externe ; à l'interne, l'historique trace | `RES-001` cycle de vie |
| Q9 | L'identifiant intrinsèque sert à suivre l'historique et attester les modifications, par git | confirme `ANL-005` |
| Q10 | Identifiant externe, forme proposée et **non définitive** | ouvert |
| Q11 | L'ergonomie interne est une **exigence non négociable**. Format par défaut `PREFIX-SEQ` | principe à écrire |
| Q12 | Un changement de slug ne change pas l'identité | `RES-001` |

## Intention

Enregistrer les décisions, instruire leurs conséquences, et corriger les documents qui portent la position renversée.

## Ce que la demande ne dit pas

Elle ne dit pas quoi produire. Le précédent est la tâche 13, qui a traité la réponse à Q1 par une `DCN`, un `ADR`, une objection de suivi et la correction des documents concernés.

Elle ne demande pas de migration de fichiers. Q11 fixe `PREFIX-SEQ` comme format par défaut : aucun nom de fichier ne change.

## Ressources livrables

| Livrable | Nature |
|---|---|
| `DCN-008` | Création. Enregistre les onze réponses |
| `ADR-008` | Création. Instruit le régime d'identification à deux niveaux |
| `PDC-002` | Création. L'ergonomie interne, demandée par Q11 |
| `NON-023` | Création. Ce que les réponses laissent ouvert |
| `NON-001` | Modification. Journal et état |
| `RES-001` | Modification. Identité, cycle de vie |
| `ADR-007` | Modification. D1 précisé, D2 abrogé |

## Ordre de travail

| Type | Travail | Skill |
|---|---|---|
| `DCN` | Création | `skl-004`, procédé `MET-002` |
| `ADR`, `NON` | Création | `skl-006`, `skl-002` |
| `PDC` | Création | `skl-003` |
| `RES` | Modification | `skl-001`, `skl-002` |

## Contrainte de rédaction

Registre directif pour `RES-001`, `PDC-002` et `NON-023`, conformément à la tâche 15.

`ADR-008` porte les motifs : `skl-001` B1 assigne le pourquoi à l'ADR.
