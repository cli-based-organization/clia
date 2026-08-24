# Démarche de validation, tâche 15

## Validation des mesures

1. M1 recalculé sur les trente définitions : découpage par titre de niveau 2, somme des mots par rubrique, classement méta déclaré en Méthode de `ANL-004`.
2. M2 recalculé : quatorze motifs, comptage lexical, total et densité pour mille mots.
3. M3 recalculé : présence du titre exact de chacune des douze rubriques de `skl-001` B3.
4. Vérification que les trois mesures portent sur le même ensemble de trente fichiers, sans exclusion.
5. Vérification du champ `adr` des trente définitions par comptage direct, et vérification de ce que `ADR-005` décide réellement par lecture.
6. Vérification des deux citations de `skl-001`, B1 ligne 122 et B3 ligne 168, par lecture du fichier aux lignes indiquées.

## Validation de forme des livrables

7. Validation de schéma de `ANL-004` et de `PLN-002` contre `analyse.cue` et `plan.cue`.
8. Comparaison des sections présentes avec celles déclarées par `RES-010` et `RES-025`.
9. Vérification des liens relatifs des deux livrables.
10. Vérification qu'aucun des deux livrables ne porte de rubrique méta, contrôle V10 proposé appliqué à ses propres livrables.

## Validation du registre, auto-application

11. Application de M2 aux deux livrables produits.
12. Vérification que chaque occurrence détectée est soit une citation d'un marqueur mesuré, soit le mot « justification » comme sujet du document, et non un usage.

## Validation des affirmations chiffrées du plan

13. Vérification du décompte des champs obligatoires de `RES-001`, seize, et de ceux montrés par le gabarit `skl-001` B3, quatorze.
14. Vérification que le gabarit B3 porte bien `id: RES-<slug>`, forme abolie par `ADR-007`.
15. Vérification que le gabarit `.dev/templates/ressource.template.md` porte les huit rubriques que `RES-001` déclare pour ses instances.

## Validation de portée

16. Vérification qu'aucun harnais n'a été modifié : la demande porte sur un diagnostic et un plan.
17. Vérification qu'aucune définition `RES` n'a été modifiée.
18. Vérification que la suite de tests du CLI reste verte, aucun code n'ayant été touché.
