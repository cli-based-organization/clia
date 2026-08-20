# Résultat de la validation, tâche 16 de SES-002

`MET-003` étape 5.

| # | Contrôle | Résultat |
|---|---|---|
| 1 | Chantier A : `harnais.yaml` | **Réussi** : 4 harnais, `ARCHITECTURE.md` optionnel, `CONSTITUTION.md` obligatoire |
| 2 | Chantier B, critère corrigé | **Réussi** : les deux essais symétriques passent, et sont au banc |
| 3 | Le fichier racine de `clia` ressort intact | **Réussi**, `diff` vide, assertion dédiée |
| 4 | Chantier C : lien, contenu propre, conformité | **Réussi**, `cue vet` passe sur `INT-001` |
| 5 | Chantier C, six sections | **Réussi**, `Relations` comprise |
| 6 | Chantier D : migration fidèle | **Réussi**, trois cas, contenu identique |
| 7 | Le régime lié tient | **Réussi** : gabarit pour les harnais, instance locale pour l'intention |
| 8 | `PLN-017` est `execute` | **Réussi**, écart déclaré dans le corps |
| 9 | `BUG-007` conforme et réel | **Réussi** |
| 10 | La suite de tests | **Réussi, 322 assertions**, 308 → 322 |
| 11 | Le dépôt ne régresse pas | **Réussi** : les 20 non conformes après la tâche sont exactement ceux d'avant, `diff` vide entre les deux listes |
| 12 | `clia setup check` reste conforme | **Réussi** |
| 13 | Le journal suit `MET-003` | **Réussi** : 21:11, 21:32, 21:49, 21:50, croissants |

## Ce que le contrôle 3 a failli ne pas attraper

Le premier jet du test du chantier B a laissé `CLAUDE.md` du dépôt `clia` modifié d'un octet — un saut de ligne perdu par une restauration passant par une variable shell plutôt que par `cp`. `git status`, lancé par réflexe après le premier passage du banc, l'a montré avant que quoi que ce soit ne soit committé.

**C'est la même famille de défaut que celle relevée aux tâches 9, 12 et 14** : un mécanisme qui a l'air correct et qui perd un détail à la marge — ici un octet, là un dernier élément de liste, ailleurs une valeur de retour dans un sous-shell. Le contrôle 3 existe maintenant pour que cette classe d'erreur ne puisse plus repasser inaperçue sur ce chemin précis.

## Ce que la validation ne couvre pas

**Le contrôle 5 vérifie six sections sur un seul type**, `intention`. La même boucle, désormais gardée, n'a pas été rejouée sur les 36 autres types du dépôt.

**`clia-repos` n'est pas repris.** Le mécanisme est prouvé sur des dépôts jetables ; l'appliquer au dépôt réel de l'humain reste son geste, comme `PLN-017` le déclarait déjà.

**`BUG-007` reste ouvert**, documenté et non corrigé. Trois instances du dépôt — `DCN-019`, `DCN-020`, `ISU-013` — restent non conformes pour cette raison précise.
