# Ce qui a été fait, tâche 18

## En un coup d'oeil

| Mesure | Valeur |
|---|---|
| Réponses de l'humain traitées | **12 sur 12** |
| Ressources créées | 4 |
| Ressources modifiées | 5 |
| Décisions abrogées | **2 sur 5** de `ADR-007` |
| Fichiers renommés | **0** |
| Renvois réécrits | **0** |
| Ressources validant leur schéma | **97 sur 99** |
| Tests du CLI | 91, tous verts |

## Livrables

| Fichier | Nature |
|---|---|
| `.dev/decisions/DCN-008-regime-d-identification-a-deux-niveaux.md` | Créé. Enregistre les douze réponses |
| `.dev/adr/ADR-008-regime-d-identification-a-deux-niveaux.md` | Créé. Sept décisions |
| `.dev/principes/PDC-002-ergonomie-de-l-identification-interne.md` | Créé. Trois contraintes vérifiables |
| `.dev/objections/NON-023-consequences-du-regime-a-deux-niveaux.md` | Créé. Six questions |
| `.dev/ressources/RES-001-ressource.md` | Modifié. **v1.0.0 vers v2.0.0** |
| `.dev/objections/NON-001-identite-et-nommage.md` | Modifié. `repondue`, effet `informatif` |
| `.dev/adr/ADR-007-identifiant-relatif-par-sequence.md` | Modifié. D1 et D2 marqués abrogés |
| `.dev/skills/skl-001-ressource/SKILL.md` | Modifié. Règle A2 corrigée |
| `.dev/ressources/index.md` | Modifié. Ligne d'apport corrigée |

## La correction principale

`<PREFIX>-<SEQ>` n'est pas l'identité d'une ressource. C'est son **alias interne**.

L'humain l'écrit deux fois. Sous Q1 : « non. voir FRG-001. » Et en Q4 : « `<PREFIX>-<SEQ>` est l'implémentation par défaut de l'id-interne/alias de l'identifiant. »

`FRG-001` porte le cadre : deux régimes d'identification, interne et externe, et un système hybride fondé sur « un système d'alias auto-cohérent facilement utilisable en interne » et « des identifiants complets ».

**Ce qui change est le statut de la forme, non sa valeur.** Q11 confirme `PREFIX-SEQ` comme format par défaut. Aucun fichier n'est renommé, aucun renvoi n'est réécrit.

## Ce que la correction entraîne

`ADR-007` D2 interdisait la renumérotation, avec pour motif écrit : « C'est ce qui rend D1 possible. » D1 tombe, D2 perd son motif.

Q5 le remplace par son contraire conditionnel : « les modifications internes de l'alias/identifiant doit modifier du même coup toutes les références. »

| `ADR-007` | Sort |
|---|---|
| D1, l'identité est `<PREFIX>-<SEQ>` | **abrogée** |
| D2, renuméroter est interdit | **abrogée** |
| D3, le slug porte le libellé | confirmée par Q6 et Q12 |
| D4, le nommage daté est aboli | inchangée |
| D5, l'identifiant est relatif au dépôt | confirmée par Q4 |

D2 était un ajout de l'agent, signalé comme tel dans le journal de la tâche 13. Il est retiré avec la prémisse qui le portait.

## Les sept décisions de ADR-008

| Réf | Décision |
|---|---|
| D1 | Deux régimes d'identification, interne et externe |
| D2 | `<PREFIX>-<SEQ>` est l'alias interne, non l'identité. Abroge `ADR-007` D1 |
| D3 | Renuméroter est permis, à condition de propager. Abroge `ADR-007` D2 |
| D4 | Le slug est libre, sans filiation à déclarer |
| D5 | L'identité désigne l'oeuvre ; la version relève de la publication externe |
| D6 | L'identifiant intrinsèque est fourni par git |
| D7 | L'identifiant externe reste ouvert |

## Deux raccords avec les tâches précédentes

**Q9 confirme `ANL-005`.** L'humain répond que l'identifiant intrinsèque sert à suivre l'historique et attester les modifications, par git. `ANL-005` l'établit par mesure et recommandait de ne rien construire par-dessus. D6 retient la recommandation, et les six contraintes T1 à T6 de `ANL-005` passent du statut de recommandation à celui de condition du régime d'identification.

**Q8 tranche une question ouverte depuis `FND-002`.** L'identité désigne l'oeuvre. `FND-002` établissait que tout identifiant qui ne déclare pas son niveau FRBR confond l'oeuvre et le fichier.

## PDC-002, demandé par Q11

« L'ergonomie interne est une exigence non négociable. »

Trois contraintes vérifiables, plutôt qu'un énoncé général.

| Réf | Contrainte | Seuil |
|---|---|---|
| E1 | Lisible | Préfixe alphabétique signifiant |
| E2 | Retenable | Au plus 8 caractères |
| E3 | Tapable | ASCII, majuscules, chiffres, un trait d'union |

Mesure de conformité du 2026-08-10 : **92 alias sur 99 conformes**. Les sept écarts sont les atomes de `ANL-001`, à 10 caractères, déjà contestés par `NON-019` Q3.

## La lacune rencontrée en écrivant

`DCN-008` corrige une partie de `DCN-007`. Aucun mécanisme du dépôt ne sait le dire.

| Mécanisme | Pourquoi il échoue |
|---|---|
| Relation `remplace` | Vaut pour un document entier. Ferait disparaître trois décisions en vigueur |
| Champ `effet: remplacee` | Même défaut à l'échelle de la `DCN` |
| `MET-002` étape 6 | Ne connaît que le revirement complet |

**C'est la première application réelle de `MET-002`.** Le document, écrit à la tâche 14, déclarait son mécanisme central non éprouvé : aucune `DCN` n'en remplaçait une autre. La tâche 18 fournit le premier cas, et il ne rentre pas dans le mécanisme, pour un motif que `MET-002` n'avait pas prévu.

Traitement retenu : `DCN-007` conserve `effet: en-vigueur`, `DCN-008` déclare `reference`, et l'abrogation est marquée décision par décision dans le texte de `ADR-007`. La lacune est portée par `NON-023` Q5.

## Propagation de la correction

Trois documents affirmaient la position abrogée comme si elle était en vigueur.

| Document | Correction |
|---|---|
| `skl-001` A2 | La règle qui commande l'agent disait « jamais modifiée : renuméroter est un changement d'identité ». Réécrite, avec les deux précautions de propagation établies par la migration de la tâche 13 |
| `.dev/ressources/index.md` | Portait encore `<PREFIXE>-<SLUG>`, périmé depuis la tâche 13 |
| `RES-001` | Section « Identité » réécrite, invariant I1 corrigé, versionnage annoté |

`FND-003` porte la position abrogée dans son étape 6. Elle n'est pas corrigée : une fondation est un point fixe qui rapporte l'état de son jour.

`ADR-007` conserve son résumé et sa décision en une phrase, avec un avertissement d'abrogation partielle en tête. Une décision enregistrée ne se réécrit pas.

## NON-001 est levée

Douze questions, douze réponses. L'état passe de `partiellement-repondue` à `repondue`, l'effet de `bloquant` à `informatif`.

C'est la **première objection du dépôt à recevoir une réponse complète**, sur vingt-deux. Elle était ouverte depuis le 2026-08-09.

Six objections bloquantes subsistent : `NON-002`, `NON-005`, `NON-009`, `NON-014`, `NON-017` et `NON-018`. `NON-014` porte sur le même sujet que celle qui vient d'être levée, le trilemme de nommage, et n'a pas été relue à cette occasion.

## Ce qui n'a pas été fait

La réponse Q10 n'est pas retenue comme décision : son auteur la déclare non définitive. Elle est enregistrée comme orientation par `ADR-008` D7, et ses quatre inconnues sont portées par `NON-023` Q6.

La propagation d'alias n'est pas outillée. `ADR-008` D3 en fait une obligation ; aucune commande ne l'exécute, aucun contrôle ne la vérifie. Sixième règle écrite et non tenue.

`RES-001` conserve ses deux rubriques méta. Leur retrait est le chantier D de `PLN-002`, non engagé.

Aucune question de `NON-019` ni de `NON-022` ne reçoit de réponse.
