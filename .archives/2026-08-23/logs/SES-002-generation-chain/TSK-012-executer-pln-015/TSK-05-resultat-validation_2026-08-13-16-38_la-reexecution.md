# Résultat de la validation, tâche 12 — réexécution

`MET-003` étape 5. `derive-de` `TSK-05-resultat-validation_2026-08-13-15-36_treize-controles.md`.

**Démarche** : le critère du chantier C est unique et exécutable ; il a été lancé tel qu'il est écrit dans le plan, avant d'écrire ces résultats.

| # | Contrôle | Résultat |
|---|---|---|
| 1 | Les quatre mécanismes sont affichés | **Réussi** : `allow`, `deny`, `ask`, `hooks` |
| 2 | Au moins un point manquant est nommé | **Réussi** : `autorisation impossible` |
| 3 | Sortie 1 quand il manque un point | **Réussi**, `rc=1` |
| 4 | La commande ne modifie rien | **Réussi**, et son aide le déclare |
| 5 | `apply` n'existe pas et le dit | **Réussi**, sort en 2 en renvoyant à `NON-040` |
| 6 | La suite de tests | **Réussi, 297 assertions** |
| 7 | `PLN-015` reste `propose` | **Réussi** : `MET-005` étape 5, les trois chantiers sont faits mais deux points restent sortis du plan |

## Le défaut trouvé en éprouvant, et ce qu'il coûtait

**Le premier jet affichait « politique complète » avec cinq manques et sortait en 0.**

Le décompte se faisait à l'intérieur d'un bloc redirigé vers `column`, donc dans un sous-shell : la variable était incrémentée puis perdue à la sortie du pipe.

**C'est le même piège que le `grep -c` de la tâche 9** : une sortie qui a l'air juste, et un code de retour qui ment. Un contrôle qui n'aurait regardé que l'affichage l'aurait laissé passer.

## Ce que la réexécution corrige au premier passage

Le premier passage déclarait le chantier C « hors d'atteinte » parce qu'il dépendait de A, et que A avait échoué.

**Le raisonnement était faux.** A n'a pas échoué à produire une connaissance : il a établi qu'un hook refuse et n'autorise pas. Le diagnostic a un objet précis, et sa cinquième ligne porte exactement cette mesure.

**Ce que j'ai confondu** : « le critère du chantier A n'est pas satisfait » et « le chantier A n'apprend rien ». Les deux sont différents, et le second était faux.

## Ce que la validation n'établit pas

**Que le diagnostic soit utile.** Il dit vrai ; savoir s'il aide demande de s'en servir.

**Que `PLN-015` puisse être clos.** Deux points restent hors du plan — le hook qui autorise, et `apply` — et ils attendent `NON-040` et un mécanisme non démontré. Le plan reste `propose`, ses trois chantiers exécutés.
