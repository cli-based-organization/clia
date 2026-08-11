# Résultat de la validation, tâche 27

## Bilan

| Contrôle | Résultat |
|---|---|
| Schéma, dépôt entier | **127 conformes, 5 non conformes** |
| Liens relatifs des quatre documents touchés | **0 cassé** |
| Rubriques méta, `V10` | **0** |
| Tests du CLI | **125 réussis, 0 échoué** |
| `ANL-007` réécrite | **non**, le type est `point-fixe` |
| Blocs de réponse de `NON-004` modifiés | **0** |
| Chantiers de `PLN-005` exécutés | **0** |

Les cinq non-conformités sont les gabarits en attente de l'humain, inchangées.

## Le remplacement, contrôles 5 à 8

| Vérification | Résultat |
|---|---|
| `ANL-007` non réécrite | conforme, aucune modification |
| `ANL-008` déclare `remplace` et `derive-de` | conforme |
| `PLN-004` passe à `abandonne`, chantiers intacts | conforme |
| `PLN-004` déclare `est-remplacee-par` | conforme |
| `PLN-005` déclare `remplace` | conforme |

**Le mécanisme employé diffère selon le cycle de vie.** `ANL` est `point-fixe` : une analyse périmée est remplacée par une nouvelle. `PLN` est `travail` : son statut évolue, son contenu reste.

C'est la première fois que le dépôt applique `remplace` entre deux ressources du même type.

## L'objection, contrôles 9 à 11

Les sept questions portent une réponse. `NON-004` passe à `repondue`, effet `informatif`.

La section « Ce qui lèverait cette objection » dit ce que Q2 et Q3 ont répondu, et signale que trois réponses portent un reproche de méthode plutôt qu'une décision de conception.

## L'auto-application, contrôles 17 et 18

```
TSK-01-demande_2026-08-11-10-39
TSK-02-analyse_2026-08-11-10-41
TSK-03-fait_2026-08-11-10-43
TSK-04-validation_2026-08-11-10-49
```

Quatre horodatages distincts et croissants, plus les versements suivants. Le log `demande` a été écrit **avant toute exploration du dépôt**, ce qui est la première fois que cette étape est tenue à la lettre.

Aucun log ne rapporte une autre tâche.

**Ce que l'auto-application a produit d'utile.** Le log `demande` déclarait ne pas savoir si `NON-004` avait de nouvelles réponses, et posait les deux issues possibles. L'exploration a tranché pour la seconde. Écrit après coup, ce log aurait présenté la conclusion comme évidente.

## Portée respectée

Contrôles 19 à 21. Aucun chantier de `PLN-005` n'est exécuté. Aucune des six productions demandées n'est produite : ni `ONT-001`, ni le type `REG`, ni le `PDC` sur la distillation.

Aucun `PDC` n'est créé. `CONSTITUTION.md` C1 le réserve à l'humain, et `NON-027` Q1 reste ouverte.

## Ce que la validation n'établit pas

**Que la lecture des trois reproches soit juste.** `ANL-008` C1 propose qu'ils relèvent d'un même défaut. C'est une interprétation de l'agent, signalée comme telle, et elle ramène trois critiques distinctes à une seule.

**Que le chantier A soit suffisant.** Deux règles écrites dans `skl-001` ne corrigent pas une disposition. Rien ne vérifie qu'un constat n'est pas employé comme norme.

**Le volume du chantier A3.** Retirer des documents actifs les formulations qui traitent `ANL-001` comme normative demande une lecture dont l'ampleur n'est pas mesurée.
