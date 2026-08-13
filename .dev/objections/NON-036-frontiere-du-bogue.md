---
type: objection
id: NON-036
title: "Frontière du bogue et sort des sept écarts constatés"
status: draft
initiateur: agent
effet: conditionnel
etat: repondue
porte-sur: [RES-036, RES-031]
---

# NON-036 - Frontière du bogue et sort des sept écarts constatés

> Le bogue se définit par la règle qu'il enfreint. Sept écarts ont été constatés en trois jours, six sont corrigés et aucun n'a de ressource. Et le type naît sous un modèle de frontmatter que `DCN-016` s'apprête à remplacer.

## Journal

- 2026-08-11 : ouverte par l'agent, tâche 34, avec `RES-036`.
- 2026-08-13 : passe a `repondue` par `PLN-010`, chantier B. Critere mecanique : chaque question porte une reponse. Aucune reponse n'a ete interpretee.

## Ce qui est contesté

Quatre points.

**Un défaut sans règle écrite n'a pas de type.** `RES-036` pose qu'un bogue enfreint une règle identifiable. Un comportement qui déplaît sans enfreindre aucune règle tombe alors dans l'issue, ou dans une objection contre la règle absente. Rien ne dit lequel.

**Sept écarts sont constatés et aucun n'a de ressource.** Six sont corrigés, un subsiste. Ils vivent dans des commentaires de code et des journaux.

**Le type naît sous un modèle en sursis.** `DCN-016`, produite hier, remplace `status` et les huit champs propres par quatre champs. Elle porte `effet: suspendue`. `RES-036` suit le modèle en vigueur et devra migrer.

**`accepte` est une décision, et l'agent peut la constater sans la prendre.** `RES-036` réserve cette valeur à l'humain, et rien ne l'empêche techniquement.

## Pourquoi cela ne peut pas rester implicite

**La frontière avec l'issue décide du volume.** Si tout défaut est un bogue, le type prolifère. S'il faut une règle écrite, la plupart des défauts constatés dans ce dépôt n'en sont pas : `NON-005` mesure que les règles s'accumulent sans être tenues, donc sans être écrites au moment où le défaut apparaît.

**Le type est créé au moment où le modèle change.** Cinq types ont été créés depuis le 2026-08-11 et les cinq portent `status` obligatoire, que `NON-035` a mesuré comme inutile. Celui-ci est le sixième.

## Questions

### Q1 - Un défaut sans règle écrite est-il une issue, ou une règle manquante ?

Trois positions.

C'est une issue : le défaut est un problème ouvert, sans référence.

C'est une objection : l'absence de règle est le vrai défaut, et le constat en est le symptôme.

C'est un bogue quand même, et la règle est écrite après coup. Le plus commode et le moins rigoureux : il autorise à qualifier de bogue tout ce qui déplaît.

**Réponse.**

### Q2 - Les sept écarts constatés doivent-ils devenir des instances ?

Six sont corrigés. `RES-031` pose qu'on ne consigne que ce qui risque d'être perdu ou contesté ; leur correction est documentée dans les journaux et les commentaires de code.

Le septième subsiste : le statut affiché qui n'apprend rien, porté par `ISU-008`.

**Réponse.**

### Q3 - Qui peut passer un bogue à `accepte` ?

`RES-036` le réserve à l'humain : accepter un écart est une décision. Rien ne l'empêche techniquement, comme rien n'empêche l'agent de commiter.

Faut-il une garde, comme celle de `clia git save` ?

**Réponse.**

### Q4 - Le type doit-il attendre `DCN-016` ?

`RES-036` porte `status` et un champ `etat` propre, que `DCN-016` remplacerait par quatre champs.

Créer le type maintenant ajoute une instance à migrer. Attendre laisse le manque ouvert, constaté depuis la tâche 32.

**Réponse.**

## Ce qui lèverait cette objection

Une réponse à Q1, qui fixe la frontière et donc le volume du type.

L'effet est `conditionnel` : le type est utilisable, et rien de ce qui existe n'est invalidé.

## Relations

- `objecte-a` [RES-036](../ressources/RES-036-bogue.md)
- `objecte-a` [RES-031](../ressources/RES-031-issue.md)
- `reference` [NON-035](NON-035-le-champ-status-ne-sert-a-rien.md)
- `reference` [NON-005](NON-005-validation-et-regles-non-tenues.md)
