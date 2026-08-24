# Démarche de validation, tâche 11 — réexécution

`MET-003` étape 4. Écrite avant les contrôles.

1. **Le déblocage est réel** : `DCN-016` porte bien `effet: en-vigueur`.
2. **Chantier A** : `RES-001` déclare les quatre champs, au moins 4 occurrences.
3. **Chantier B** : un frontmatter amputé d'un des quatre champs échoue à `cue vet` ; un frontmatter complet passe.
4. **Chantier C** : les 37 définitions déclarent leur `domain-status`, ou déclarent n'en avoir aucune.
5. **Chantier C, fidélité** : les énumérations sont **reprises** des champs existants, non inventées.
6. **Chantier D** : `cue vet` passe sur les instances, et le dépôt ne régresse pas.
7. **Chantier D, fidélité** : `domain-status` porte bien la valeur du champ propre de chaque instance.
8. **Le chantier E n'a pas été exécuté**, et ses trois motifs de blocage sont mesurés, non affirmés.
9. **`PLN-007` reste `propose`** : `MET-005` étape 5.
10. **La suite de tests passe.**
11. **`clia focus` reflète le changement** : `DCN-016` n'est plus `A APPROUVER`, et `PLN-007` n'est plus « préalable suspendu ».
12. **Le journal suit `MET-003`**, avec les versements de la réexécution distincts de ceux du premier passage.
