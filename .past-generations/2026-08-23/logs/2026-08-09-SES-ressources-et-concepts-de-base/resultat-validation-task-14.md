# Résultat de la validation, tâche 14

## Bilan

| Contrôle | Résultat |
|---|---|
| Schéma, dépôt entier | **90 conformes, 2 non conformes** |
| Schéma, les treize livrables de la tâche | **13 sur 13 conformes** |
| Tests du CLI | **91 réussis, 0 échoué** |
| Liens relatifs, 14 fichiers touchés | **0 cassé** |
| Sections déclarées et présentes | 4 fichiers non conformes, **aucun produit par cette tâche** |
| Teneur des `DCN` migrées | **46 insertions, 0 suppression** |
| Numéros consommés par l'épreuve du CLI | **0** |

## Les deux non-conformités de schéma

Inchangées depuis la tâche 13, et connues.

| Fichier | Cause |
|---|---|
| `FRG-001` | Champ `exploitation` à `À RENSEIGNER` |
| `NON-013` | Champs `effet`, `etat` et `initiateur` à `À RENSEIGNER` |

Les deux ont été créés par l'humain avec `clia res new`. Leurs champs appartiennent à leur initiateur et n'ont pas été complétés. Le bogue trouvé au contrôle 11 en donne d'ailleurs la cause partielle : la commande produit un frontmatter incomplet et, depuis le 2026-08-09, deux valeurs fausses.

## Le conflit de sections, mesuré

Le contrôle 5 mesure quatre non-conformités de forme, dont **aucune n'est produite par cette tâche**. Trois d'entre elles relèvent d'un même conflit, et il est structurel.

| Fichier | Sections manquantes |
|---|---|
| `FND-001` | Objet et méthode, Corps de la revue, Ce que la recherche établit, Limites |
| `FND-002` | Corps de la revue, Ce que la recherche établit, Sources, Limites |
| `FND-003` | Corps de la revue, Ce que la recherche établit, Sources, Limites |
| `MET-001` | Quand l'employer |

**Les trois fondations du dépôt échouent au même contrôle.** `RES-011` déclare six sections ; `MET-001` impose une structure en dix étapes numérotées plus une bibliographie. Une fondation ne peut pas satisfaire les deux : `FND-003`, qui suit `MET-001` scrupuleusement, porte « Bibliographie » là où la définition attend « Sources ».

Ce n'est pas un défaut de rédaction mais une contradiction entre la définition d'un type et la méthodologie qui le produit. Elle n'a pas été corrigée : la corriger suppose de trancher si le champ `sections` d'un type est une structure imposée ou un minimum, ce qui vaut pour les trente types et non pour celui-ci seul. La question est ajoutée à `NON-020` comme Q5.

`MET-001` à qui manque « Quand l'employer » est une non-conformité simple, préexistante, et sans rapport avec ce conflit. Elle est signalée dans `next-task-14.yaml`.

## Le bogue de clia res new

Contrôle 11. La commande produit bien les deux nouveaux champs et la nouvelle section, ce qui valide la chaîne définition → gabarit. Elle produit aussi deux valeurs fausses, sans rapport avec cette tâche.

```
type: 009                                 attendu : decision
id: DCN-essai-de-conformite-du-gabarit    attendu : DCN-008
```

Diagnostic complet dans `fait-task-14.md`, emplacements `lib/clia/resource.sh:298` et `:310`. Deux régressions de la tâche 13. Non corrigées, portées par `next-task-14.yaml`.

L'épreuve a été conduite dans une copie du dépôt, précisément pour éviter de consommer le numéro 008 : `ADR-007` D2 interdit la réattribution d'un numéro libéré, et `NON-019` Q5 relève déjà que rien n'en garde la mémoire. Le contrôle 12 confirme que le dépôt réel compte toujours sept `DCN`.

## Ce que la validation de fond établit

**Les sept apports sont traités**, contrôle 13, et la table de correspondance figure dans `RES-009` sous « Ce que la fondation a changé ». Quatre vont dans la définition, deux dans la méthodologie, un dans les deux.

**Chaque affirmation nouvelle renvoie à sa source**, contrôle 14. Les règles R1 à R3 de `RES-009` sont fondées sur le *stare decisis* et sur le constat de Konishi corroboré par `ANL-001` ; le champ `attestation` sur ISO 15489 ; le champ `diffusion` sur Horner et Atwood ; l'étape 3 de `MET-002` sur le résultat central de la fondation ; l'étape 8 sur RFC 7282.

**Les corrections à `FND-003` ne touchent aucune affirmation sourcée**, contrôle 15. Les deux corrigent le document contre ses propres mesures.

**`MET-002` déclare ses trous**, contrôle 16. Sur neuf étapes, deux n'ont aucun contrôle et le disent, une a un contrôle spécifié et non outillé et le dit, six ont un contrôle applicable.

**L'objection contre le livrable porte des chiffres**, contrôle 17. `NON-022` mesure la croissance de la charge à 22 pour cent, situe le dépôt dans la zone d'abandon mesurée par Rösch et al., et nomme sa propre atténuation comme faible.

## Ce qui n'a pas été validé, faute de cas

L'étape 6 de `MET-002`, qui est l'apport central de la tâche, **n'a pas pu être éprouvée** : aucune `DCN` du dépôt n'en remplace une autre. Le mécanisme est écrit, cohérent avec `ADR-003` D7, et non testé.

Son contrôle est spécifié et non implémenté. Tant qu'il ne l'est pas, le mécanisme neuf a en pratique le défaut de l'ancien, avec un document de plus pour l'expliquer. C'est `NON-022` Q3.
