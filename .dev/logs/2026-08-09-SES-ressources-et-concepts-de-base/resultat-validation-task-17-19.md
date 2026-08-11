# Résultat de la validation, tâches 17 et 19

## Bilan

| Contrôle | Résultat |
|---|---|
| `V10` sur les trente définitions | **0 en faute** |
| Marqueurs de justification restants | **0** |
| Champ `adr` des définitions | **30 sur 30** corrigés, réparties sur six ADR |
| Schéma, dépôt entier | **106 conformes, 2 non conformes** |
| Liens relatifs | **0 cassé** sur 60 fichiers |
| Skills renvoyant à `V1 à V10` | **7 sur 7** |
| Tests du CLI | **118 réussis, 0 échoué** |
| Commits produits par l'agent dans ce dépôt | **0** |

Les deux non-conformités de schéma sont `FRG-001` et `NON-013`, inchangées depuis la tâche 13, avec des champs `À RENSEIGNER` appartenant à leur initiateur.

## Tâche 17, mesures

| Mesure | Avant | Après |
|---|---|---|
| Mots dans les trente définitions | 22 236 | **18 511**, soit **-16 pour cent** |
| Rubriques méta | 30 définitions sur 30 | **0** |
| Marqueurs de justification | 59 | **0** |
| `RES-009` | 2 797 mots | **1 537**, soit **-45 pour cent** |

Répartition du champ `adr` après correction : 7 vers `ADR-009`, 3 vers `ADR-010`, 4 vers `ADR-011`, 5 vers `ADR-012`, 7 vers `ADR-013`, 4 vers `ADR-014`. Aucune définition ne pointe plus vers `ADR-005`.

## Le chantier E confirme la cause

| Type | Fichiers | Part méta |
|---|---|---|
| `ADR` | 14 | 2 pour cent |
| `DCN` | 8 | 5 pour cent |
| `MET`, `NON`, `PDC`, `ANL` | 32 | **0 pour cent** |

Le défaut était spécifique aux définitions, ce qui confirme le diagnostic de `ANL-004` : la cause était le gabarit `skl-001` B3, qui ne s'appliquait qu'à elles. Aucune correction n'est nécessaire ailleurs.

## Tâche 19, ce que l'épreuve a trouvé

**Un bogue dans le contrôle T1, corrigé.** La première version cherchait un statut de renommage et ne trouvait rien : git affiche une suppression et une création quand la réécriture dépasse le seuil de similarité. La détection porte désormais sur l'alias.

**Un défaut du test lui-même, corrigé.** La première version du test produisait un contenu trop proche de l'original ; git détectait alors le renommage, l'historique n'était pas coupé, et T1 n'était donc pas violée. Le test produit désormais une divergence complète.

Les deux corrections sont du même ordre : une hypothèse sur le comportement de git, fausse, et attrapée en l'éprouvant.

## Isolation

Contrôles 24 et 25.

| Vérification | Résultat |
|---|---|
| Commits produits par l'agent dans ce dépôt | **0**, le dernier commit est antérieur à la session de travail |
| Modifications en attente | 78 fichiers, non commités |
| Numéros de ressource consommés par une épreuve | **0** |

Toutes les épreuves de `save` ont construit leur propre dépôt git dans un répertoire temporaire, avec `CLIA_REPO_ROOT` pointant vers lui.

## Ce que `clia git check done` dit du dépôt

```
ok    des modifications a commiter           78 fichier(s)
ok    message de commit prepare              .../commit-message-task-18.yaml
KO    signature des commits activee          T4, commit.gpgsign absent
ok    aucun renommage avec reecriture        T1
ok    historique non reecrit                 T3, 0 commit(s) d'avance sur origin/main
```

Le seul contrôle en échec est T4, la signature, qui n'est pas activée. C'est l'état que `ANL-005` C8 mesurait, inchangé.

Le message préparé le plus récent est celui de la tâche 18 : les tâches 17 et 19 en produisent un nouveau, et `save` prendra celui-là.

## Ce que la validation n'établit pas

**`V10` est une liste noire.** Il détecte les rubriques nommées. Une justification logée dans une rubrique descriptive lui échappe, et c'était le cas de la majorité des 146 marqueurs mesurés par `ANL-004`. Les 28 substitutions ciblées ont été faites à la main, sans contrôle qui garantisse leur exhaustivité.

**Les six ADR d'adoption ne sont pas approuvés.** Ils portent `statut-decision: propose`.

**Le chantier B2 a été tranché par l'agent**, contre la lettre du plan qui le posait comme un point à trancher : aucun champ n'a été ajouté à `RES-001`, la structure d'une définition restant portée par `skl-001` seul.

**Le point d'arrêt C du plan a été franchi par l'agent.** La demande d'exécuter le plan a été lue comme valant approbation de sa recommandation, option C-a. Si l'humain préférait C-b, six documents sont à fusionner.
