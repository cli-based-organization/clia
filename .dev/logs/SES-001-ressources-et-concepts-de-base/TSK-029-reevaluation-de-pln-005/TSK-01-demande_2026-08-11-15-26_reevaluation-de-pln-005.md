# Demande interprétée, tâche 29

Écrit le 2026-08-11 à 15:26, avant toute exploration. `MET-003` étape 1.

## Énoncé

Tâche 29, `[implémentation]` : PLN-005.

> Réévaluer PLN-005 au regard de PDC-003.
>
> Partir de la liste des livrables identifiés. Si il y a des problématiques non-smart, ouvrir un issue pour chaque thématique de problème.
>
> Pour chaque issue ouvert, décrire la problématique dans l'issue. Pour chaque ISU, ouvrir des objections dans une ressource NON, et établir une relation entre ISU et NON.
>
> Également, établir une relation entre ISU et les livrables bloqués ou impactés.
>
> L'humain peut apporter des informations à un ISU en lui écrivant des FRG à l'intérieur de ISU. Ou bien en y liant un FRG ou n'importe quelle autre ressource.
>
> À chaque nouvelle information, on peut réévaluer l'implémentabilité ou le caractère smart des livrables cibles.
>
> TODO : écrire cette procédure dans une nouvelle MET.
>
> Une fois que tous les ISU et les objections émises ont été créés, implémenter ce qui peut être implémenté de PLN-005.

## La procédure, en cinq temps

| Temps | Ce qu'il produit |
|---|---|
| 1 | La réévaluation des livrables de `PLN-005` au regard de `PDC-003` |
| 2 | Une `ISU` par **thématique de problème** non-SMART |
| 3 | Une `NON` par `ISU`, avec relation entre les deux |
| 4 | Une relation entre chaque `ISU` et les livrables qu'elle bloque ou impacte |
| 5 | L'implémentation de ce qui reste implémentable |

Plus une `MET` qui écrit cette procédure, demandée par un `TODO`.

## Ce que je sais avant d'explorer

`PDC-003` place les plans au régime **extrême SMART** : livrable unique, critère de réussite exécutable, limite de temps contraignante.

Il porte déjà une mesure : les deux plans du dépôt au 2026-08-11, `PLN-001` et `PLN-002`, échouaient à ses trois contrôles. `PLN-005` a neuf chantiers et aucune limite de temps ; il échouera probablement aussi.

**Ce que cela signifie.** La réévaluation ne va pas dire si `PLN-005` est bon. Elle va séparer ce qui est assez net pour être fait de ce qui ne l'est pas, et donner au second un endroit où vivre : l'`ISU`, dont `RES-031` pose qu'elle est non-SMART par construction.

## Un mécanisme demandé qui n'existe pas

« L'humain peut apporter des informations à un ISU en lui écrivant des FRG **à l'intérieur de** ISU. »

C'est exactement `ISU-001`, ouverte à la tâche 26 : définir une ressource dans un document ressource. Rien ne l'implémente.

La seconde voie, « en y liant un FRG », fonctionne dès aujourd'hui par les relations.

## Ce que je vérifierai

Les neuf chantiers de `PLN-005`, un par un, contre les trois contrôles de `PDC-003`.

Ce que la tâche 28 a déjà produit : le chantier D prévoyait le type registre, et il existe depuis hier.

## Ce que je ne ferai pas

**Réécrire `PLN-005`.** Le type est `travail` : son statut évolue, son contenu reste. La réévaluation s'ajoute, elle ne remplace pas.
