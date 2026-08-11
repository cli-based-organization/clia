# Résultat de la validation, tâche 15

## Bilan

| Contrôle | Résultat |
|---|---|
| Schéma des deux livrables | **2 sur 2 conformes** |
| Sections déclarées et présentes | **0 manquante** dans les deux |
| Liens relatifs | **0 cassé** |
| Rubriques méta dans les livrables, V10 proposé | **0** |
| Marqueurs de justification en usage, M2 auto-appliqué | **0** |
| Tests du CLI | **91 réussis, 0 échoué** |
| Harnais modifiés par cette tâche | **0** |
| Définitions `RES` modifiées par cette tâche | **0** |

## Les mesures recalculées

Les trois mesures de `ANL-004` ont été refaites après rédaction. Aucun écart.

| Mesure | Valeur |
|---|---|
| M1, part méta | 3 724 mots sur 17 922, soit 20,8 pour cent |
| M2, marqueurs | 146, densité 6,6 pour mille mots |
| M3, reprise du gabarit | méta 30/30, descriptives 1/30 à 13/30 |

## Les citations vérifiées

Contrôle 6. Les deux citations de `skl-001` sont exactes et aux lignes indiquées.

| Ligne | Texte |
|---|---|
| 122 | « **Pourquoi** il a été adopté \| La décision, `ADR` » |
| 168 | « `## Le problème que ce type résout` » |

La contradiction est établie par lecture, non par interprétation.

Contrôle 5. `ADR-005` porte le titre « Regroupement fonctionnel des ressources ». Il décide la répartition des types en six familles. Il ne décide l'adoption d'aucun type. Les vingt-trois définitions qui le désignent comme leur `ADR` désignent une décision qui ne les adopte pas.

## L'auto-application du correctif

Contrôles 10 à 12. Le correctif proposé a été appliqué aux livrables qui le proposent.

**Aucune rubrique méta.** V10, tel que `ANL-004` F5 le définit, passe sur les deux livrables.

**Aucun marqueur en usage.** M2 détecte 28 occurrences dans `ANL-004` et 10 dans `PLN-002`. Vérification faite, aucune n'est un usage.

| Origine | ANL-004 | PLN-002 |
|---|---|---|
| Le mot « justification », sujet du document | 23 | 10 |
| Citations de marqueurs mesurés, tableau C2 | 5 | 0 |
| **Usages réels** | **0** | **0** |

L'unique « parce que » de `ANL-004` est à la ligne 70, dans la colonne d'un tableau qui liste les marqueurs comptés.

## Les affirmations chiffrées du plan

Contrôles 13 à 15, toutes vérifiées.

| Affirmation | Vérification |
|---|---|
| `RES-001` déclare seize champs obligatoires | 16, comptés dans le frontmatter |
| Le gabarit `skl-001` B3 en montre quatorze | 14. Manquent `famille` et `sections` |
| Le gabarit B3 porte `id: RES-<slug>` | Confirmé, ligne 147. Forme abolie par `ADR-007` |
| `ressource.template.md` porte huit rubriques | 8, celles que `RES-001` déclare pour ses instances |

## Portée respectée

Contrôles 16 à 18. Le dépôt porte trois fichiers modifiés dans `.dev/skills`, `.dev/ressources` et `.dev/templates` : `RES-009`, `skl-004` et `decision.template.md`. Les trois sont les livrables de la tâche 14, non de la tâche 15.

La tâche 15 n'a modifié aucun harnais, aucune définition, aucun code. Elle a produit deux fichiers neufs.

`PLN-002` porte `statut-plan: propose`. Aucun chantier n'est engagé.

## Ce que la validation n'établit pas

**Le correctif n'a été appliqué à aucune définition `RES`.** Il a été appliqué à deux documents neufs, qui ne sont pas des définitions et qui n'avaient pas de dette à corriger. Le coût réel de réécriture d'une définition existante reste inconnu. `PLN-002` place cette mesure au chantier D1.

**M2 sous-estime, et le taux de sous-estimation n'est pas mesuré.** Le comptage est lexical. Une justification sans marqueur passe. Aucun contrôle proposé ne la détecte, ce que `PLN-002` porte comme deuxième objection.

**Le classement des rubriques méta n'est pas mécanique.** Six rubriques sont classées méta par jugement. Le classement est déclaré et vérifiable ; il n'est pas dérivé d'une règle.
