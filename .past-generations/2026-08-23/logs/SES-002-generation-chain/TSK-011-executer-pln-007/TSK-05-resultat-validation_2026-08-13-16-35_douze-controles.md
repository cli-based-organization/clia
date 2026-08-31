# Résultat de la validation, tâche 11 — réexécution

`MET-003` étape 5. `derive-de` `TSK-05-resultat-validation_2026-08-13-14-01_douze-controles.md`.

| # | Contrôle | Résultat |
|---|---|---|
| 1 | Le déblocage est réel | **Réussi**, `effet: en-vigueur` |
| 2 | Chantier A | **Réussi**, 7 occurrences pour 4 exigées |
| 3 | Chantier B | **Réussi** : amputé, `cue vet` signale `maturity`, `adoption` et `activated` ; complet, il passe |
| 4 | Chantier C | **Réussi**, 37 sur 37 — 12 énumérations, 25 « aucune » |
| 5 | Chantier C, fidélité | **Réussi** : chaque valeur déclare le champ dont elle est reprise |
| 6 | Chantier D | **Réussi**, 183 instances, dépôt sans régression |
| 7 | Chantier D, fidélité | **Réussi** : `PLN-007` → `propose`, `DCN-016` → `en-vigueur`, `BUG-004` → `ouvert` |
| 8 | Le chantier E et ses motifs | **Réussi**, les trois sont mesurés — voir plus bas |
| 9 | `PLN-007` reste `propose` | **Réussi** |
| 10 | La suite de tests | **Réussi, 297 assertions**, 289 → 297 |
| 11 | `clia focus` reflète le changement | **Réussi** : `A APPROUVER` est vide, `PLN-007` repasse en `A EXECUTER` sans mention de blocage |
| 12 | Le journal suit `MET-003` | **Réussi**, versements distincts du premier passage |

## Le contrôle 8 : trois motifs, trois mesures

| Motif | Mesure |
|---|---|
| Irréversible | **191 champs** seraient supprimés dans les instances |
| Casserait le CLI | **10 lectures** de `etat`, `effet`, `statut-plan` dans `lib/` |
| Dépend d'`ISU-009` | Le critère porte sur `statut:`, et `ISU-009` est `ouverte` |

**Le deuxième motif n'existait pas quand le plan a été écrit.** `PLN-007` date du 2026-08-11 ; `clia focus` n'existait pas.

## Ce que le chantier D a produit, et ce qu'il faut en dire

**366 valeurs posées sans jugement par instance.** `maturity: conception` et `adoption: propose` sur 183 instances, avec 8 exceptions — les décisions `en-vigueur`, adoptées par l'humain.

**`maturity` vaut `conception` partout, exactement comme `status` valait `draft` partout.** C'est le défaut que `DCN-016` corrigeait, et il est reproduit sur un champ neuf. La différence est que le champ peut varier ; il ne varie pas encore.

**`domain-status` échappe à ce reproche** : 152 instances, 12 énumérations distinctes, chaque valeur reprise d'un champ existant.

## Ce que la validation n'établit pas

**Que les valeurs de `maturity` et `adoption` soient justes.** Elles sont défendables — le dépôt a cinq jours — et elles n'ont été jugées par personne.

**Que le dépôt soit prêt pour le chantier E.** Il ne l'est pas : dix lectures du CLI doivent d'abord lire `domain-status`.

## Deux fichiers qui ne sont pas de moi

`PDC-006`, `PDC-007` et maintenant **`DCN-019`** — « à la validation, chaque ressource modifiée incrémente sa version » — ont été créés par l'humain pendant la session.

**`DCN-019` porte `effet: À RENSEIGNER`** : elle ne prescrit rien tant qu'elle n'est pas rédigée. Je ne l'ai donc pas appliquée. Le compte de non conformes passe de 17 à 18 pour cette seule raison.
