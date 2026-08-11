---
type: adr
id: ADR-008
title: "Régime d'identification à deux niveaux : alias interne et identifiant externe"
version: 0.1.0
status: draft
statut-decision: propose
date: 2026-08-10
decideurs: ["human:jvtrudel (décideur)", "claude-opus-5 (rédaction)"]
sources:
  - "NON-001, réponses Q1 à Q12 du 2026-08-10"
  - FRG-001
  - DCN-008
  - ADR-007
definition-associee: RES-001
---

# ADR-008 - Régime d'identification à deux niveaux

> Instruit les onze réponses de `DCN-008`. `<PREFIX>-<SEQ>` cesse d'être l'identité d'une ressource pour devenir son alias interne. `ADR-007` D1 et D2 sont abrogés ; D3, D4 et D5 subsistent.

## Statut

`propose`. Aucune approbation formelle n'a été donnée à ce document ; les décisions qu'il instruit sont en vigueur par `DCN-008`.

## Contexte

`ADR-007`, du 2026-08-10, pose que l'identité d'une ressource est `<PREFIX>-<SEQ>` et que renuméroter est interdit. Ces deux décisions résolvaient `NON-001` Q1.

L'humain a répondu aux onze questions restantes le 2026-08-10, et a ajouté sous Q1 la mention « non. voir FRG-001. »

`FRG-001` distingue deux régimes d'identification et pose un système hybride : « un système d'alias auto-cohérent facilement utilisable en interne » et « des identifiants complets ». Q4 le confirme : `<PREFIX>-<SEQ>` est « l'implémentation par défaut de l'id-interne/alias de l'identifiant ».

L'écart entre `ADR-007` et ces réponses porte sur un mot. `ADR-007` appelle identité ce que l'humain appelle alias.

### Pourquoi l'écart compte

Un alias et une identité n'ont pas les mêmes propriétés.

Une identité ne change pas : c'est ce qui la définit, et `FRG-001` le pose, « ce qui persiste par-delà des modifications est l'identité ».

Un alias peut changer. `FRG-001` l'écrit : les identifiants internes « peuvent même changer, tant que toutes les références internes sont adaptées de manières cohérentes ». Q5 le reprend comme obligation.

`ADR-007` D2 interdisait la renumérotation parce que D1 faisait du numéro l'identité. Le motif tombe avec la prémisse.

### Ce que l'agent avait ajouté de lui-même

`ADR-007` D2 ne figurait pas dans la demande de la tâche 13. Le journal de cette tâche le signale : c'est un ajout de l'agent, sans lequel D1 perdait son fondement.

L'ajout était cohérent avec D1 et il est retiré avec lui.

## Décision en une phrase

L'identification d'une ressource se fait à deux niveaux : un alias interne, relatif au dépôt, ergonomique et modifiable sous condition de propagation ; et un identifiant externe, complet, dont la forme reste à fixer.

## Décisions détaillées

### D1 - Deux régimes d'identification

**Décision.** Le système distingue le régime interne et le régime externe.

| Régime | Portée | Contrainte | Porteur |
|---|---|---|---|
| **Interne** | Le dépôt | Relatif et auto-cohérent | L'alias, `<PREFIX>-<SEQ>` par défaut |
| **Externe** | Hors du dépôt | Complet, non contrôlé par le dépôt | À fixer, voir D7 |

**Motif.** `FRG-001` : « On distingue 2 régimes d'identification : interne ou relatif, externe. » Le motif y est donné : « Ce qui est difficile avec le monde extérieur, c'est qu'on ne contrôle pas les références que le monde garde de notre système, ni l'usage qu'ils en font. »

Un dépôt contrôle ses propres renvois et peut les mettre à jour. Il ne contrôle pas ceux d'un tiers. Les deux régimes n'ont donc pas la même exigence de stabilité, et les confondre impose au régime interne une rigidité qu'il n'a pas besoin de porter.

### D2 - `<PREFIX>-<SEQ>` est l'alias interne, non l'identité

**Décision.** `<PREFIX>-<SEQ>` est l'implémentation par défaut de l'identifiant interne. Il désigne une ressource sans être son identité.

**Ce qui est abrogé.** `ADR-007` D1, qui pose « l'identité d'une ressource est le champ `id`, de la forme `<PREFIX>-<SEQ>` ».

**Ce qui est conservé.** La forme elle-même, confirmée par Q11 comme format par défaut, et son emploi comme cible de tout renvoi interne. Aucun fichier n'est renommé.

**Motif.** Q4, mot pour mot : « Le système d'identifiant interne n'a besoin que d'être relatif et auto-cohérent. `<PREFIX>-<SEQ>` est l'implémentation par défaut de l'id-interne/alias de l'identifiant. »

**Ce que la décision laisse ouvert.** Ce qui porte l'identité de l'oeuvre à l'interne, si l'alias ne la porte pas. Aucune réponse ne le dit. Porté par `NON-023`.

### D3 - Renuméroter est permis, à condition de propager

**Décision.** Un alias peut changer. Tout changement d'alias met à jour, dans le même geste, toutes les références internes qui le citent.

**Ce qui est abrogé.** `ADR-007` D2, « Renuméroter est interdit ».

**Motif.** Q5 : « les modifications internes de l'alias/identifiant doit modifier du même coup toutes les références ». `FRG-001` en donne la condition générale : les identifiants internes peuvent changer « tant que toutes les références internes sont adaptées de manières cohérentes ».

**Conséquence sur la séquence.** `ADR-007` D2 posait qu'un numéro libéré n'est jamais réattribué et que la séquence a des trous. Cette conséquence tombe avec la décision qui la portait. Rien ne remplace la règle : la réattribution d'un numéro libéré n'est ni interdite ni permise. Porté par `NON-023`.

**Ce qui manque.** La propagation n'est outillée par rien. Une obligation non outillée est ce que `NON-005` conteste depuis le 2026-08-09, et ce que `ANL-004` mesure sur un autre sujet. La commande qui l'exécuterait n'existe pas.

### D4 - Le slug est libre

**Décision.** Le slug du nom de fichier porte un libellé destiné aux humains. Il se corrige sans aucune conséquence, et sans déclaration de filiation.

**Ce qui est confirmé.** `ADR-007` D3, inchangé.

**Ce qui est écarté.** La proposition de `RES-001` de traiter tout renommage de slug comme un changement d'identité, avec `remplace` et `est-remplacee-par`. Écartée par Q6 et Q12.

**Motif.** Q6 : « Le slug n'a rien à voir avec l'identifiant, il n'est là que pour aider les humains à se repérer. On peut changer le slug sans conséquense. D'autant plus que le slug n'est jamais utilisé dans le iid. »

Le champ `id-anterieurs` proposé par la suggestion S7 de `ANL-003` devient sans objet.

### D5 - L'identité désigne l'oeuvre

**Décision.** L'identité d'une ressource désigne l'oeuvre. La version relève du mécanisme de publication externe. À l'interne, l'historique trace les modifications.

**Motif.** Q8 : « l'oeuvre. La version est défini par le mécanisme de publication externe. À l'interne, les modifications sont traçables par l'historique. »

Cette décision tranche la question que `FND-002` posait par le modèle FRBR : un identifiant qui ne déclare pas son niveau confond l'oeuvre et le fichier.

**Conséquence sur le versionnage.** Le champ `version` du frontmatter perd sa fonction interne. Il ne devient utile qu'à la publication. Sa présence dans les champs obligatoires de la plupart des types n'est pas révisée par cette décision, et la question est portée par `NON-023`.

### D6 - L'identifiant intrinsèque est fourni par git

**Décision.** Le suivi de l'historique et l'attestation des modifications reposent sur les identifiants de contenu de git. Aucun mécanisme d'empreinte propre n'est construit.

**Motif.** Q9 : « l'identifiant intrinsèque est utile pour suivre l'historique et attester des modificaitons. (git) »

`ANL-005` établit par mesure ce que git fournit : tout chemin, fichier ou répertoire, porte un identifiant de contenu, déterministe, indépendant du chemin et de l'histoire ; le diff entre deux versions s'obtient de deux identifiants seuls. Sa recommandation R1 était de ne rien construire par-dessus. Cette décision la retient.

**Conséquence.** Les six contraintes T1 à T6 de `ANL-005` deviennent des conditions du régime d'identification, et non des recommandations. T4, la signature des commits, reste non tenue : zéro commit signé sur huit.

### D7 - L'identifiant externe reste ouvert

**Décision.** Aucune forme d'identifiant externe n'est arrêtée.

**Orientation enregistrée.** Q10, déclarée non définitive par son auteur :

```
clia://<author|personne qui partage>@<repo>/<origin>:<PREFIX>-<UUID>/<hash-version>
```

**Ce que la forme suppose.** Un identifiant par instance de dépôt, qualifié d'éphémère par l'humain. Un `UUID` par ressource, distinct de l'alias `<SEQ>`. Un hachage de version, que D6 rend disponible.

**Ce qui n'est pas décidé.** Tout le reste : ce qu'est une instance de dépôt, ce que « éphémère » implique, où vit l'`UUID`, et à quel moment il est attribué. Porté par `NON-023`.

## Conséquences

| Document | Effet |
|---|---|
| `ADR-007` D1 | Abrogé par D2 |
| `ADR-007` D2 | Abrogé par D3 |
| `ADR-007` D3, D4, D5 | Inchangés |
| `RES-001`, section Identité | Réécrite |
| `RES-001`, cycle de vie et versionnage | Réserve ajoutée par D5 |
| `NON-001` | Passe à `repondue`, ses douze questions portant une réponse |
| `NON-019` Q2 | Change d'objet : l'interdiction est levée, la propagation la remplace |
| `PDC-002` | Créé, à la demande de Q11 |
| `ANL-005` | Ses six contraintes deviennent des conditions, par D6 |

**Aucune migration.** Aucun fichier n'est renommé, aucun renvoi n'est réécrit. La correction porte sur le statut de la forme `<PREFIX>-<SEQ>`, non sur sa valeur.

**La relation vers `ADR-007` est `reference` et non `remplace`.** Deux de ses cinq décisions sont abrogées, trois subsistent. Le vocabulaire de relations de `RES-001` ne connaît que le remplacement entier, et l'employer ici ferait disparaître trois décisions en vigueur. La lacune est portée par `NON-023`.

**Ce que le dépôt gagne.** Une distinction que `ADR-007` ne portait pas : la stabilité exigée d'un renvoi interne n'est pas celle exigée d'un renvoi externe. Le régime interne redevient modifiable, ce qui lève la rigidité que D2 imposait.

**Ce que le dépôt perd.** La garantie qu'un renvoi interne reste valide sans intervention. Elle est remplacée par une obligation de propagation, que rien n'outille.

## Objections ouvertes

`NON-023`, ouverte avec cette décision. Cinq questions : ce qui porte l'identité de l'oeuvre à l'interne, le sort d'un numéro libéré, la vérification de la propagation, le devenir du champ `version`, et les inconnues de l'identifiant externe.

`NON-019` Q1 reste ouverte : le champ `id` est déductible du nom de fichier, et cette décision ne le tranche pas.

`NON-005` reste ouverte, et cette décision ajoute une obligation non outillée à celles qu'elle recense.

## Relations

- `derive-de` [DCN-008](../decisions/DCN-008-regime-d-identification-a-deux-niveaux.md)
- `reference` [ADR-007](ADR-007-identifiant-relatif-par-sequence.md)
- `specifie` [RES-001](../ressources/RES-001-ressource.md)
- `repond-a` [NON-001](../objections/NON-001-identite-et-nommage.md)
- `reference` [ANL-005](../analyses/ANL-005-tracabilite-de-l-historique-des-ressources.md)
