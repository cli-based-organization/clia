# Résultat de la validation, tâche 31

## Bilan

| Contrôle | Résultat |
|---|---|
| Inventaire fait avant rédaction | **oui**, 74 fondations examinées |
| `FND-004` refait `FND-015` | **non**, et le déclare |
| Schéma des deux documents | **conformes** |
| Liens relatifs | **0 cassé** |
| Schéma, dépôt entier | **147 conformes, 7 non conformes** |
| Tests du CLI | **144 réussis, 0 échoué** |
| Instances `SPC`, `RQF`, `RQNF` | **0**, mesure confirmée |

## Le conflit de sections, connu

`FND-004` ne porte pas les sections que `RES-011` déclare : « Corps de la revue », « Ce que la recherche établit », « Sources », « Limites ».

C'est le conflit que `NON-020` Q5 porte depuis la tâche 14 : `RES-011` déclare six sections, `MET-001` impose dix étapes, et une fondation ne peut satisfaire les deux. **Les quatre fondations du dépôt échouent au même contrôle.**

`FND-004` suit `MET-001`, qui est la méthodologie que la fondation doit appliquer.

## Ce que l'inventaire préalable a évité

`FND-015` couvre P5 et P6 de la demande, soit deux des six points.

**Sans l'inventaire, `FND-004` les aurait refaits.** C'est le défaut que `NON-021` conteste depuis la tâche 14 : `ADR-007` avait reproduit deux prescriptions de Nygard publiées en 2011 sans le savoir.

L'humain le pressentait : « il me semble que ça fait plusieurs fois que je fais cette demande ». Il avait raison.

## Ce que la validation a confirmé sur le dépôt

**Trois types définis, zéro instance.** `SPC`, `RQF` et `RQNF` n'ont ni instance ni répertoire.

**`ADR-016` D3 est inapplicable par construction.** Elle nomme `SPC` et `RQF` comme sources de dérivation d'un skill.

## Ce que la validation n'établit pas

**La qualité des sources.** L'étape 9 de `MET-001` exige d'interroger chaque URL, et aucun outil ne le permettait dans cette session. Les douze sources sont citées par leur référence complète, qui les identifie ; leur accessibilité n'est pas vérifiée.

C'est le manquement le plus net, et `FND-004` le déclare deux fois : à l'étape 9 et dans ses limites.

**La densité.** Trois sources par question contre dix exigées, et quatre des douze sont internes au corpus. `NON-020` conteste ce seuil que les quatre fondations du dépôt n'ont jamais atteint.

**La réponse à QR4.** La littérature ne traite pas le cas d'un auteur unique qui spécifie et implémente. La réponse donnée par `ANL-010` est construite sur un indice tiré d'un cas, XHTML 2.0 contre HTML 5, non sur un résultat établi.

**La frontière machine.** `ANL-010` propose F2 et déclare que le choix appartient à l'humain. Aucune des trois frontières n'est déclarée dans le dépôt.
