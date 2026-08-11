# Ce qui a été fait, tâche 31

`MET-003` étape 3.

## Ce que l'inventaire préalable a trouvé

L'humain demandait de puiser d'abord dans les fondations existantes. Soixante-quatorze fondations dans `$HOME/git`.

**`FND-015` répond déjà à la moitié de la demande.** « Requis et spécification : notions, distinctions et relation », produite le 2026-07-18 et archivée le 2026-08-08.

| Point demandé | Dans `FND-015` |
|---|---|
| P5 Types de spécifications et de requis | **oui**, sections 5 et 6 |
| P6 Distinction requis contre spécification | **oui**, sections 1 à 7 |
| P1 à P4 Histoire, régimes, exemples, évolution | non |

**`FND-004` porte P1 à P4 et cite `FND-015` pour le reste.** Refaire les deux points couverts aurait été exactement le défaut que `NON-021` conteste depuis la tâche 14.

## FND-004, quatre régimes de publication

| Régime | Depuis | Autorité par | Ce qu'il sacrifie |
|---|---|---|---|
| La norme | 1906, 1947 | procédure | vitesse et accès |
| Le RFC | 1969 | adoption | stabilité |
| Le consortium | années 1990 | compromis | adhésion |
| La spécification exécutable | années 2010 | vérification | expressivité |

**Le régime le plus influent est né sans autorité.** Steve Crocker a nommé le premier document « Request for Comments » en 1969 parce qu'il craignait de paraître présomptueux : le groupe n'avait aucune autorité pour édicter des règles. Le nom est resté pour tous les suivants, y compris ceux devenus des standards obligatoires.

**Le résultat central.** RFC 2026 exige des implémentations interopérables pour qu'un texte avance dans l'échelle de maturité. Le code qui tourne fait partie du critère d'acceptation : une spécification n'est pas un document qui précède le code, c'est un document qui co-évolue avec lui.

**L'angle mort déclaré.** Toute la littérature suppose que celui qui spécifie et celui qui implémente sont deux parties. Le cas d'un auteur unique n'est traité nulle part, et c'est exactement celui de `clia`.

## ANL-010, la source de vérité

### Ce que le dépôt pratique sans l'avoir déclaré

`ADR-006` et `RES-020` adoptent **la lecture C** de `FND-015` : la spécification décrit le quoi agnostique, le requis porte les contraintes contextuelles.

`FND-015` établit que cette lecture est **minoritaire**, et qu'elle demande une précaution : nommer explicitement le requis comme document de contraintes d'implémentation. `RES-021` et `RES-022` ne le font pas.

### Trois emplacements, non un

| Ce qui est décrit | Source de vérité |
|---|---|
| Ce que le système doit faire | La `SPC`, agnostique au stack |
| Les contraintes de mise en oeuvre | Le `RQF` ou le `RQNF` |
| Les choix techniques pris en implémentant | **Le code, et un `ADR`** |

**Le critère de départage.** Un choix qui survivrait à une réécriture complète appartient à la spécification. Un choix qui disparaîtrait avec le code appartient au code.

### Ce que le code porte déjà et qu'aucun document ne porte

Quatre décisions techniques, mesurées sur les modules du CLI : le mécanisme de détection T1, les codes de retour, le format des noms produits, les motifs de recherche des messages.

**Trois ont été prises en écrivant le code.** La quatrième a produit un bogue de deux jours : le format des noms a divergé de `ADR-007` D4 parce qu'aucun document ne reliait la décision au générateur.

### L'ordre recommandé

**Écrire d'abord la `SPC` descriptive de ce qui existe**, non la `SPC` prescriptive de ce qui manque.

`resource.sh` porte quatre décisions non documentées et a produit deux bogues en trois jours. Le décrire coûte une lecture ; le spécifier avant de le réécrire coûterait une réécriture.

C'est aussi ce que l'histoire suggère : XHTML 2.0 avait la procédure et pas les implémentations, il est mort ; HTML 5 avait les implémentations et pas la procédure, il a gagné.

## Deux constats sur l'état du dépôt

**`ADR-016` D3 est inapplicable par construction.** Elle nomme `SPC` et `RQF` comme sources de dérivation d'un skill, et les deux types ont zéro instance.

**La frontière machine n'est pas fixée.** `FND-015` établit que l'opposition quoi contre comment ne départage qu'une fois cette frontière posée. `clia` en a trois possibles ; `ANL-010` propose la deuxième et déclare que le choix appartient à l'humain.

## Ce qui n'a pas été fait

**Aucune `SPC` n'est écrite.** La tâche demande une fondation et une analyse.

**La vérification des URL n'a pas eu lieu.** Aucun outil en ligne n'était disponible. `FND-004` le déclare à son étape 9, et c'est un manquement à `MET-001`.
