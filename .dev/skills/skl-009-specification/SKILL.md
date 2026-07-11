---
name: skl-009-specification
description: >-
  Produire une spécification (`.dev/specs/SPEC-<SEQ>-<SLUG>.md`) : la description concrète de la
  solution retenue pour répondre à des requis (comportement, interfaces, contraintes, structure),
  distincte des requis qui expriment le besoin. À utiliser quand une tâche demande de décrire
  précisément comment un système ou un livrable doit être réalisé.
---

# Skill - Rédaction d'une spécification

> Une spécification décrit **comment** un système répond à un besoin : son comportement observable, ses interfaces, ses contraintes, sa structure. Elle traduit des requis (`skl-010`) et des décisions (`skl-006`) en une description assez précise pour être implémentée sans ambiguïté. Le requis dit le « quoi » ; la spécification dit le « comment ».

## Quand l'utiliser

Quand une tâche demande de décrire précisément la forme et le comportement d'une solution (une CLI, un format, un composant) à partir de requis et/ou d'un ADR. Ne pas utiliser pour exprimer le besoin brut (voir `skl-010-requis`), pour acter une décision (voir `skl-006-adr`), ni pour coder (voir le skill de codage concerné).

## Processus

1. Rassembler les entrées : requis (`REQ-*`), décisions (`ADR-*`), fondations et analyses pertinentes.
2. Décrire le **comportement observable** : entrées, sorties, effets, cas nominaux et cas d'erreur.
3. Décrire les **interfaces** : signatures, arguments, options, formats d'entrée/sortie, codes de retour.
4. Énoncer les **contraintes** : invariants, limites, dépendances, garanties (ce qui est vrai avant/après).
5. Fournir des **exemples** concrets d'usage (commandes, entrées/sorties attendues).
6. Rattacher chaque élément de la spécification aux requis qu'il satisfait (traçabilité `SPEC -> REQ`).
7. Marquer explicitement ce qui est hors périmètre et les points laissés à l'implémentation.

## Critères de qualité

- Le comportement est décrit de façon observable et testable (cas nominaux et cas d'erreur).
- Les interfaces sont complètes (arguments, options, formats, codes de retour).
- Chaque élément spécifié est traçable vers un requis (`REQ-*`) ou une décision (`ADR-*`).
- Des exemples concrets illustrent l'usage.
- La spécification décrit la solution sans dériver vers le code d'implémentation ligne à ligne.
- Ressource de harnais : aucune information de domaine métier ni spécifique au repo (généricité inter-dépôts, voir `ADR-005`).
- Markdown strict (voir `CLAUDE.md`).

## Structure du livrable

- **Emplacement** : `.dev/specs/SPEC-<SEQ>-<SLUG>.md`

```markdown
# SPEC-<SEQ> - <Titre>

- **Date** : <AAAA-MM-JJ>
- **Requis couverts** : <REQ-XXX>
- **Décisions applicables** : <ADR-XXX>

## Objet et périmètre

<Ce qui est spécifié ; ce qui est hors périmètre.>

## Comportement

<Cas nominaux et cas d'erreur ; entrées, sorties, effets.>

## Interfaces

<Arguments, options, formats d'entrée/sortie, codes de retour.>

## Contraintes et garanties

<Invariants, limites, dépendances, pré/post-conditions.>

## Exemples

<Commandes et résultats attendus.>

## Traçabilité

<Table SPEC -> REQ : quel élément satisfait quel requis.>
```
