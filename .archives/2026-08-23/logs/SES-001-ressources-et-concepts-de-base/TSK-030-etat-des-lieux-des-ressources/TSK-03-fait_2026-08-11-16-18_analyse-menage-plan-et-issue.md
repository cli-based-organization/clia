# Ce qui a été fait, tâche 30

`MET-003` étape 3.

## L1 et L2 : l'inventaire et la synthèse

`ANL-009`.

| Mesure | Valeur |
|---|---|
| Documents actifs | 150 |
| Traitant des ressources | **136**, soit 91 pour cent |

**Le compte est le résultat.** Presque tout le dépôt parle des ressources, donc l'inventaire brut n'apprend rien. Ce qui compte est l'angle, d'où les axes.

## Neuf axes

| Axe | État |
|---|---|
| A1 Identité | **réglé** |
| A2 Forme | partiel |
| A3 Cycle de vie | ouvert |
| A4 Autorité | **ouvert, bloquant** |
| A5 Dérivation | **ouvert, bloquant** |
| A6 Typage | **réglé** |
| A7 Validation | **ouvert, bloquant** |
| A8 Frontières | partiel |
| A9 Portée | ouvert |

**La synthèse tient en six énoncés**, et les six datent du 2026-08-11. La notion a plus changé en trois jours qu'en un an de corpus.

Une ressource est un ensemble identifiable et auto-cohérent d'informations, composable, portant un alias interne et non une identité, réceptacle matérialisé d'une idée, au cycle de vie collectif, portant de l'information et non du savoir, source ou générée selon le contexte.

## L6 : le ménage

Cinq interventions, aucune ne ferme une objection.

| Réf | Fait |
|---|---|
| I1 | `NON-026` passe à `repondue` : cinq questions, cinq réponses, et elle restait ouverte |
| I2 | `NON-025` et `NON-030` se citent : la seconde reprend Q1 et Q2 de la première, élargies aux trois familles |
| I3 | `NON-027` Q1 et `NON-033` Q1 se citent : même question depuis la tâche 23 |
| I4 | `NON-014` et `NON-011` portent ce que les décisions ont changé, sans être fermées |
| I5 | Les cinq plans déclarent que leur limite de temps manque |

**Le dépôt compte vingt-neuf objections ouvertes après comme avant.** Le ménage corrige des états et croise des doublons ; il ne réduit pas le compte.

**I4 mérite d'être noté.** `NON-014` a été écrite avant que `ADR-008` tranche l'identité, et `NON-011` quand sept types existaient contre trente-six. Leur objet a changé, leur question subsiste. Les fermer aurait été décider à la place de l'humain.

## L3 et L4 : le plan

`PLN-006`, cinq chantiers, tous exécutés.

Il ne porte **que ce qui satisfait `PDC-003`** : chaque intervention a un livrable unique, un critère vérifiable, aucune dépendance et aucun outil requis.

**La contradiction de l'énoncé a été tranchée.** « Créer un plan que ne contient que les éléments non implémentables » aurait produit un plan inexécutable et une issue portant l'implémentable, les deux types échangeant leur fonction. `PDC-003` et `MET-004` imposent l'inverse.

## L5 : l'issue

`ISU-007`, pour les deux axes qui n'avaient aucune issue.

| Axe | Ce qui manque |
|---|---|
| **A7 Validation** | Six sources réclament des contrôles, aucun n'est outillé, et quatre obligations de propagation en dépendent |
| **A9 Portée** | Les critères de conformité d'un dépôt, et un critère de classement des deux catégories de ressources |

**Quatre axes ouverts avaient déjà leur issue** depuis la tâche 29 : `ISU-002` à `ISU-005`. Ouvrir une sixième issue par axe aurait produit des doublons, ce que `MET-004` nomme comme premier mode d'échec.

## Ce que la tâche établit sur le dépôt

**Trois axes bloquent, et le plus lourd est A5.** Trente-trois documents sont déclarés dérivés depuis le 2026-08-11 et rien ne les dérive, dont `skl-001` que l'agent lit avant d'écrire toute ressource.

**A7 est réclamé depuis huit jours.** Chaque tâche ajoute un contrôle à la liste, aucune ne l'implémente. Le coût individuel est faible ; c'est l'accumulation qui n'a pas de porteur.

**Quatre obligations de propagation n'ont aucun contrôle.** Alias, décisions remplacées, savoir vers ressources générées, registres saisis.
