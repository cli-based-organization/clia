# Analyse avant réalisation, tâche 29

`MET-003` étape 2.

## La réévaluation, chantier par chantier

Chaque chantier de `PLN-005` est confronté aux trois contrôles de `PDC-003`.

| Chantier | V-S1 livrable unique | V-S2 critère exécutable | V-S3 limite de temps | Verdict |
|---|---|---|---|---|
| A1, A2 règles de méthode | oui, `skl-001` | oui, les deux règles y sont ou non | non | **SMART sauf T** |
| A3 nettoyage des formulations | non, volume inconnu | non, « à mesurer » | non | **non-SMART** |
| B `ONT-001` | oui | partiellement | non | **non-SMART** |
| C1, C2 `RES-007` | oui | oui | non | **SMART sauf T** |
| C3, C4 `RES-010`, `RES-011` | oui | oui | non | **SMART sauf T**, dépend de B |
| D1 type `REG` | oui | oui | non | **fait à la tâche 28** |
| D2 à D4 trois registres | non, trois livrables | oui | non | **SMART si scindé** |
| E `PDC` distillation | oui | oui | non | **bloqué**, `CONSTITUTION.md` C1 |
| F type technote | oui | non, F2 non tranché | non | **non-SMART** |
| G rôle contextuel et propagation | non, deux livrables | non, G3 « outiller » | non | **non-SMART** |
| H cycle de vie collectif | non, une recherche | non | non | **non-SMART** |
| I deux catégories de ressources | non, deux livrables | oui pour I1 | non | **SMART si scindé** |

**Aucun chantier ne déclare de limite de temps.** V-S3 échoue partout, ce que `PDC-003` mesurait déjà sur `PLN-001` et `PLN-002`. C'est un défaut du plan entier, non d'un chantier.

## Cinq thématiques de problème

Les échecs ne sont pas indépendants. Ils se regroupent.

| Thématique | Chantiers touchés | Nature du blocage |
|---|---|---|
| **T1. Aucun générateur n'existe** | G, et les trois familles dérivées | Un outil manque, sa spécification aussi |
| **T2. Le cycle de vie collectif n'est pas modélisable** | H | Aucune réponse ne dit par quoi remplacer |
| **T3. Deux frontières conceptuelles ne sont pas tracées** | B3, B4, F | Le vocabulaire manque, et B doit le produire |
| **T4. L'agent ne peut pas créer un `PDC`** | E | Une règle bloque, une question est ouverte |
| **T5. Le volume du nettoyage est inconnu** | A3 | Rien n'a été mesuré |

**Une `ISU` par thématique**, comme la demande le prescrit. Cinq issues.

## Ce que la tâche 28 a déjà réglé

Le chantier D1, le type `REG`, existe depuis hier. Il ne reste que les trois instances.

C'est le premier chantier de `PLN-005` exécuté, et il l'a été par une autre tâche.

## Ce qui reste implémentable

Après le retrait des cinq thématiques bloquantes.

| Réf | Ce qui est fait | Pourquoi c'est possible |
|---|---|---|
| A1, A2 | Deux règles dans `skl-001` | Le texte des règles est déterminé par les réponses de `NON-004` |
| C1, C2 | Le test d'admission de `RES-007` remplacé | La réponse Q6 donne le critère exact |
| I1 | La distinction entre les deux catégories de ressources | La réponse Q2 la formule |

**Trois interventions, sur trois documents.** Chacune a un livrable unique et un critère vérifiable.

**Ce que je n'implémente pas.** C3, C4 et D2 à D4, qui sont SMART mais dépendent d'un préalable non tranché : le vocabulaire pour les premiers, `NON-029` Q1 pour les seconds.

## L'ordre retenu

1. Les cinq `ISU`, une par thématique.
2. Les cinq `NON`, une par `ISU`, avec relations croisées.
3. La `MET` de la procédure, demandée par le `TODO`.
4. L'implémentation de A1, A2, C1, C2 et I1.
5. La mise à jour de `PLN-005`, qui est `travail` : son statut évolue, son contenu reste.

## Ce que la procédure demandée apporte

Elle donne au non-SMART un endroit où vivre.

Sans elle, un chantier non implémentable reste dans le plan et le fait échouer entier. Avec elle, il sort du plan, devient une `ISU`, et le plan retrouve un contenu net.

C'est le seuil de bascule que `PDC-003` décrit : « une planification qui ne satisfait pas S, M et T n'est pas produite. Elle devient une `ISU`. »
