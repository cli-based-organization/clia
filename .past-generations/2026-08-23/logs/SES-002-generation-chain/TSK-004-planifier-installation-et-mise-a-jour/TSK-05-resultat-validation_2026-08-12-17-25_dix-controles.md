# Résultat de la validation, tâche 4 de SES-002

| # | Contrôle | Résultat |
|---|---|---|
| 1 | Expérimentations consultées, apports nommés | **Réussi** |
| 2 | `PDC-003` sur chaque chantier | **Réussi**, 4 livrables, 4 critères, 4 limites |
| 3 | Total sous la limite | **Réussi**, 6 h 15 sur 7 h |
| 4 | Chaque commande est un chantier ou est sortie | **Réussi**, 4 chantiers, 3 points sortis |
| 5 | Un `ISU` et un `NON` portent ce qui est sorti | **Réussi** |
| 6 | Les mesures sont vérifiables | **Réussi**, après une correction |
| 7 | Conformité de schéma des trois documents | **Réussi** |
| 8 | Liens relatifs | **Réussi** |
| 9 | Schéma du dépôt entier | **162 conformes, 10 non conformes** |
| 10 | Journal `MET-003` | **Réussi** |

## Le contrôle qui a corrigé une mesure

**Contrôle 6.** J'avais écrit « quatre dépôts portent un `setup.sh` comparable ». La mesure exacte est **dix dépôts en portent un**, dont **quatre ont été examinés**. Corrigé dans le plan et dans l'objection.

C'est la même erreur que celle des ADR comptés le 2026-08-09 : confondre ce que j'ai regardé avec ce qui existe.

## Le contrôle 9, et ce qu'il a révélé

Le dépôt passe de huit à dix non conformes. **Les deux nouveaux ne viennent pas de cette tâche.**

| Document | Auteur |
|---|---|
| `DCN-017` | **L'humain**, pendant que je travaillais |
| `BUG-001` | **L'humain**, pendant que je travaillais |

Les deux portent des champs `À RENSEIGNER`, ce qui explique la non-conformité. Les trois documents produits ici sont conformes.

**Ce sont les deux premiers documents que l'humain crée directement avec les types que j'ai définis.** `BUG-001` est la première instance du type `bogue`, créé à la tâche 34 de `SES-001`.

## Ce que `BUG-001` constate, et qui me concerne

Sept interruptions en une seule tâche, toutes documentées avec leur trace.

| Cause | Occurrences |
|---|---|
| Analyse statique du shell impossible | 4 |
| Expansion de variable | 2 |
| **Une règle `ask` que j'avais posée le matin même** | 1 |

**La septième est de ma faute directe.** La politique de permissions mise en place ce matin plaçait `Bash(sed -i:*)` en `ask`. Elle a produit exactement l'interruption que `DCN-017` interdit.

Retirée, et treize commandes courantes sont passées en `allow`.

**Les six autres ne se corrigent pas par une règle.** « Contains shell syntax that cannot be statically analyzed » signifie qu'aucune règle ne peut trancher. La cause est ma méthode : **j'écris des documents avec des documents en place dans des commandes shell, alors qu'un outil d'écriture existe**. Le geste correctif est de ma part, pas de la configuration.

## Ce que la validation ne couvre pas

**Aucun chantier n'est exécuté.** Le plan est proposé ; la tâche 5 l'exécute.

**Le chantier A est un pari.** Si les critères de conformité ne peuvent pas s'écrire en commandes exécutables, B et C n'ont pas de fondement. Le plan déclare ce point d'arrêt.

**`DCN-017` n'a pas été traitée.** Elle est arrivée pendant la tâche, elle porte `effet: À RENSEIGNER`, et son corps est à rédiger. Ce n'est pas une tâche de la session.
