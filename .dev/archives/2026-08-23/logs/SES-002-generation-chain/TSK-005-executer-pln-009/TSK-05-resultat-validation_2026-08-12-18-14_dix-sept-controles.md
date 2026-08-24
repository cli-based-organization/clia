# Résultat de la validation, tâche 5 de SES-002

| # | Contrôle | Résultat |
|---|---|---|
| 1 | **A** : critères référencés et vérifiables | **Réussi**, 4 `I`, 7 `C`, 5 `P`, 23 renvois dans le code |
| 2 | **B** : trois diagnostics distincts | **Réussi** |
| 3 | **C** : `check` conforme après `init` | **Réussi** |
| 4 | **D** : le mode et ses cinq propriétés | **Réussi** |
| 5 | La cible mesurable : `res ls` répond | **Réussi** |
| 6 | P2 : un emplacement occupé est conservé | **Réussi** |
| 7 | P3 : le dépôt source est intact | **Réussi**, empreinte identique |
| 8 | P5 : rejouable | **Réussi**, `poses : 0` au second appel |
| 9 | Régime lié : liens relatifs et utilisables | **Réussi**, après correction |
| 10 | `init` refuse le source comme cible et l'option inconnue | **Réussi** |
| 11 | Mode d'installation inconnu refusé | **Réussi**, code 2 |
| 12 | `SPC-001` conforme, liens valides | **Réussi** |
| 13 | Ce dépôt conforme à sa propre spécification | **Réussi** |
| 14 | Schéma du dépôt entier | **163 conformes, 10 non conformes** |
| 15 | Suite de tests | **Réussi, 252 assertions** |
| 16 | Aucun dépôt réel de `$HOME/git` touché | **Réussi** |
| 17 | Journal `MET-003` | **Réussi** |

## Le contrôle 9, et le bogue qu'il a trouvé

**`check` déclarait conforme un dépôt inutilisable.**

En régime lié, `clia res ls` répondait « aucun type de ressource » sur un dépôt que `check` venait de déclarer conforme. Les deux avaient tort de la même manière : `find -type f` ne suit pas les liens symboliques.

**Le défaut ne venait pas du code neuf.** Il dormait dans `core.sh`, `resource.sh` et `registre.sh` depuis leur écriture. Aucun dépôt ne portait de ressources liées, donc rien ne le révélait.

**Sept emplacements corrigés.** Sans cela, le régime lié — celui que la demande décrit comme le mode de développement — était inutilisable.

**Ce que cela dit du contrôle 3.** Il passait au vert avant la correction, parce qu'il ne vérifiait que `check`. C'est le contrôle 5, qui vérifie l'usage réel, qui a trouvé le défaut. **Un critère de conformité qui ne s'éprouve pas à l'usage ne prouve rien.**

## Un écart au plan, assumé

Le chantier A demandait des commandes shell dans la spécification. `RES-020` l'interdit : la garde d'agnosticisme est la propriété définitionnelle du type.

**La spécification énonce l'état observable, le code dit comment le constater.** Chaque critère porte une référence, et les 23 renvois du code les relient.

C'est une correction du plan faite en l'exécutant, et non un contournement silencieux.

## Le contrôle 14, et ce qu'il ne signale pas

Dix non conformes, comme avant cette tâche. **Les documents produits ici sont tous conformes**, `SPC-001` compris, vérifié séparément.

Les dix sont les `DCN` et `FRG` de l'humain portant des champs `À RENSEIGNER`, plus `DCN-017` et `BUG-001` créés hier.

## Ce que la validation ne couvre pas

**Aucun dépôt réel n'a été instrumenté.** Tout est éprouvé en dépôt jetable. L'intention de `SES-002` est l'usage dans une multitude d'autres projets, et cet usage n'a pas eu lieu.

**Le régime lié n'a pas été éprouvé dans la durée.** Un lien survit à un déplacement du dépôt cible ; rien n'a vérifié ce qui arrive quand le dépôt **source** se déplace, ce qui casserait tous les dépôts liés à la fois.

**`C6` et `C7` sont vérifiés mais sans conséquence.** La version est posée et comparée ; rien n'en fait usage tant que `ISU-012` reste ouverte.
