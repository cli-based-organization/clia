---
type: objection
id: NON-019
title: "Conséquences de l'identifiant par séquence"
status: draft
initiateur: agent
effet: conditionnel
etat: repondue
porte-sur: [ADR-007, RES-001]
---

# NON-019 - Conséquences de l'identifiant par séquence

> `ADR-007` fait de la séquence l'identité, ce qui règle `NON-001` Q1 et ouvre quatre conséquences que la décision ne traite pas : la redondance du champ `id`, la vérification de l'interdiction de renuméroter, le sort des atomes de composite, et la fixité des renvois déjà écrits.

## Journal

- 2026-08-10 : ouverte par l'agent, après application de la tâche 13.
- 2026-08-13 : passe a `repondue` par `PLN-010`, chantier B. Critere mecanique : chaque question porte une reponse. Aucune reponse n'a ete interpretee.

## Ce qui est contesté

Non pas la décision, qui est prise et appliquée, mais quatre conséquences qu'elle laisse indéterminées.

**Le champ `id` devient redondant.** Il vaut `<PREFIX>-<SEQ>`, et le nom de fichier porte `<PREFIX>-<SEQ>-<SLUG>`. L'`id` est donc entièrement déductible du nom de fichier. Un champ obligatoire qui ne porte aucune information nouvelle est un coût sans contrepartie.

**Rien ne vérifie l'interdiction de renuméroter.** `ADR-007` D2 en fait la condition qui rend la décision possible, et aucun contrôle ne la garantit. Un renommage de fichier suffirait à changer une identité en silence.

**Les atomes de composite ont une forme à part.** `ANL-001` porte huit atomes numérotés `ANL-001-01` à `ANL-001-07`, plus son index. Cette forme n'est pas `<PREFIX>-<SEQ>` mais `<PREFIX>-<SEQ>-<NN>`, et la tâche 13 exigeait que **toutes** les ressources soient référençables par `<PREFIX>-<SEQ>`.

**L'ambiguïté du numéro seul demeure.** `clia res show 002` reste ambigu quand deux types portent un rang 002. C'était l'argument principal de l'agent contre l'identité par séquence, et il n'est pas réfuté : il est déclaré acceptable.

## Pourquoi cela ne peut pas rester implicite

Trois raisons.

**La décision repose sur une interdiction non outillée.** `ADR-007` D2 pose que le numéro ne change jamais, et c'est ce qui fait du numéro une identité. Si l'interdiction n'est pas tenue, l'identité redevient instable et la décision perd son fondement.

**Un champ obligatoire redondant sera mal tenu.** `ANL-001` mesure ce que devient une information à tenir à la main : `completed` dans cinquante-deux logs et `complet` dans deux du même dépôt. Un `id` déductible et saisi à la main dérivera.

**La forme des atomes crée une exception que la demande excluait.** La tâche 13 dit « toutes les ressources ». Les atomes en sont, et ils ont une forme différente. Soit la règle admet une seconde forme, soit les atomes ne sont pas des ressources, ce qui contredirait `ADR-004` D3.

## Questions

### Q1 - Le champ `id` doit-il subsister ?

Trois positions. Le conserver, parce qu'un frontmatter autonome se lit sans son nom de fichier et parce que le schéma peut le contraindre. Le supprimer, parce qu'il est déductible et qu'un champ redondant dérive. Le rendre facultatif, en le déduisant quand il est absent.

**Réponse.**

### Q2 - Comment l'interdiction de renuméroter est-elle vérifiée ?

Candidats : un contrôle comparant l'`id` du frontmatter au numéro du nom de fichier, ce qui ne détecte qu'un renommage partiel ; une trace des identités attribuées, tenue par `clia` ; ou rien, en assumant que la règle suffit.

Le premier est le moins coûteux et il ne détecte que la moitié des cas.

**Réponse.**

### Q3 - Les atomes de composite sont-ils référençables par `<PREFIX>-<SEQ>` ?

Ils portent `<PREFIX>-<SEQ>-<NN>`. Faut-il admettre cette seconde forme comme conforme, donner aux atomes un numéro de plein droit dans leur propre type, ou reconnaître qu'un atome n'est pas référençable indépendamment de son composite ?

La troisième position contredirait `ADR-004` D3, qui fait de l'atome une ressource de plein droit.

**Réponse.**

### Q4 - L'ambiguïté du numéro seul est-elle acceptable ?

`clia res show 002` reste ambigu. `ADR-007` le déclare acceptable au motif qu'un identifiant complet porte son préfixe. C'est vrai, et cela signifie que le numéro seul n'est pas un identifiant : c'est une abréviation commode.

Faut-il que `clia` cesse d'accepter le numéro seul, ou conserver la commodité avec son refus explicite en cas d'ambiguïté ?

**Réponse.**

### Q5 - Que devient un numéro libéré par une suppression ?

`ADR-007` D2 pose qu'il n'est jamais réattribué et que la séquence a des trous. Rien ne conserve la mémoire des numéros retirés, donc rien n'empêche `clia res new` de réattribuer un numéro si le fichier a disparu, puisqu'il prend le maximum plus un.

Le cas se produit dès qu'on supprime la dernière ressource d'un type.

**Réponse.**

### Q6 - La forme du préfixe est-elle contrainte ?

Le schéma accepte deux à quatre lettres. Rien ne garantit l'unicité des préfixes entre types, et `NON-001` Q3 relevait déjà la coexistence de `NON` et `OBJ` pour l'objection.

**Réponse.**

### Q7 - Le renvoi inter-dépôts reste-t-il ouvert ?

`ADR-007` D5 assume que l'identifiant est relatif au dépôt et reporte la question. La suggestion S3 de `ANL-003` propose `<origine>:<PREFIX>-<SEQ>`, par extension du noyau. Elle est plus simple à appliquer maintenant que l'identité est courte.

**Réponse.**

## Ce qui lèverait cette objection

Une réponse à Q1 et Q2.

Q1 décide si un champ obligatoire redondant subsiste. Q2 outille l'interdiction sur laquelle toute la décision repose.

L'effet est `conditionnel` : la décision est appliquée, le dépôt est migré, et ce qui est produit reste valide. Les quatre conséquences sont des dettes, non des blocages.

## Relations

- `objecte-a` [ADR-007](../adr/ADR-007-identifiant-relatif-par-sequence.md)
- `objecte-a` [RES-001](../ressources/RES-001-ressource.md)
- `reference` [NON-001](NON-001-identite-et-nommage.md)
- `reference` [ADR-004](../adr/ADR-004-nature-composable-de-la-ressource.md)
