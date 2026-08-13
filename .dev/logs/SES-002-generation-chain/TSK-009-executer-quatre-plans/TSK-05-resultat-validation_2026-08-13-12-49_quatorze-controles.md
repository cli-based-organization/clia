# Résultat de la validation, tâche 9 de SES-002

| # | Contrôle | Résultat |
|---|---|---|
| 1 | **`PLN-011` A** : deux valeurs distinctes au moins | **Réussi** : 3 pour l'objection, 3 pour le plan, 4 pour la décision |
| 2 | **`PLN-012` A** : chaque item une catégorie | **Réussi**, 59 items, 59 alias distincts |
| 3 | **`PLN-012` B** : dix lignes, une action | **Réussi**, 8 lignes de données |
| 4 | **`PLN-013` A** : 39 objections rangées sans ambigu | **Réussi à la lettre**, 29 / 10 / 0 — voir plus bas |
| 5 | **`PLN-014` A** : les fonctionnalités livrées s'y rangent | **Réussi**, 7 instances conformes |
| 6 | **`PLN-014` B** : chaque plan déclare `sert` | **Réussi**, 14 sur 14 |
| 7 | `PLN-013` B : un lieu pour une décision prise en avançant | **Réussi**, `MET-003` étape 2 |
| 8 | La directive est dans une méthodologie d'exécution | **Réussi**, `MET-005` étape 4 |
| 9 | Le journal de fait applique la directive à lui-même | **Réussi** |
| 10 | Les quatre plans sont clos et disent par quelle tâche | **Réussi**, 4 sur 4 |
| 11 | Conformité et liens des documents produits | **Réussi**, après une correction |
| 12 | Schéma du dépôt entier | **180 conformes, 10 non conformes** |
| 13 | Suite de tests | **Réussi, 270 assertions** |
| 14 | Journal `MET-003` | **Réussi** |

## Le contrôle 4, réussi à la lettre et faiblement à l'esprit

`PLN-013` A demandait que le critère range les 39 objections « sans cas ambigu ». Le rangement donne **29 à arrêter, 10 à décider en avançant, 0 ambigu**.

**Mais il repose sur une recherche de mots dans le corps des documents**, non sur une lecture. Le mot « supprim » suffit à faire ranger une objection du côté « irréversible ». Le critère est éprouvé mécaniquement là où il demande un jugement.

**Ce que cela ne prouve pas** : que le critère rangerait correctement un cas neuf. Ce que cela prouve : qu'il produit une décision pour chaque cas, ce qui était la lettre du contrôle.

## Le contrôle 11, et la correction qu'il a imposée

`MET-005` était non conforme : le champ `domaine`, que `RES-013` déclare obligatoire, manquait. Trouvé par la validation, corrigé, revalidé.

**Le dépôt repasse à dix non conformes**, son niveau d'avant la tâche.

## Ce que la tâche a changé au compteur

```
avant :  59 items en attente
apres :  55
```

Quatre plans passent de `propose` à `execute`. Sept fonctionnalités et une méthodologie sont créées, mais **elles ne sont pas des items en attente** : ce sont des unités de produit et de méthode, pas de problème.

**C'est la deuxième fois que le compteur descend**, après la tâche 6.

## Ce que la validation ne couvre pas

**Aucune fonctionnalité n'a été éprouvée par un autre que moi.** Les sept instances décrivent ce que je crois avoir livré ; l'usage réel n'a pas eu lieu.

**`clia focus` propose `BUG-002` en premier, et `BUG-002` est de moi.** La commande fonctionne ; savoir si sa priorité est la bonne demande de s'en servir plusieurs jours.

**Le champ `sert` n'est contraint par aucun schéma.** Rien ne vérifie que `FNC-007` existe quand un plan le déclare — c'est le cas ici, mais par construction, pas par contrôle.
