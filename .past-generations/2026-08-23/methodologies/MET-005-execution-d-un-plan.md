---
type: methodologie
id: MET-005
title: "Exécution d'un plan"
version: 0.1.0
status: draft
maturity: conception
adoption: propose
activated: true
domaine: "conduite de l'exécution d'un plan, de son autorisation à sa clôture"
---

# MET-005 - Exécution d'un plan

> Quand un plan s'exécute, ce qu'il faut rendre à la fin, et quand décider en avançant plutôt que d'ouvrir une objection.

## Objet

Cette méthodologie fixe le procédé d'exécution d'un plan.

Elle est demandée par la tâche 9 de `SES-002` : « Après chaque exécution de plan, dire les fonctionnalités qui ont été implémentés et comment l'utiliser. Mettre cette directive dans la méthodologie qui guide l'exécution des plans. »

Aucune méthodologie ne couvrait ce procédé : `MET-003` porte la journalisation, `MET-004` la réévaluation d'un plan par le régime SMART.

## Quand l'employer

Dès qu'une tâche exécute un ou plusieurs plans.

## Étape 1 - Vérifier que la tâche autorise l'exécution

**Le type déclaré de la tâche commande.**

| Type | Ce que la tâche produit | Peut-elle exécuter un plan ? |
|---|---|---|
| `[analyse]` | Une analyse | **Non** |
| `[planification]` | Un plan | **Non** |
| `[conception]` | Une définition, une spécification | **Non** |
| `[implémentation]` | Du code, des ressources | **Oui** |
| `[bogue]` | Un diagnostic, un correctif | Oui, si le correctif l'exige |

**Un plan produit par une tâche reste `propose`.** Son exécution appartient à une tâche ultérieure, que l'humain déclenche.

**Le motif est mesuré.** `BUG-002` : deux plans sur trois ont été exécutés dans la tâche qui les a créés, et les tâches d'exécution ultérieures ont produit zéro livrable. Le plan est l'objet qui permet à l'humain de décider **qui exécute et quand** ; l'exécuter d'avance supprime ce point de décision.

## Étape 2 - Décider en avançant, ou s'arrêter

Une incertitude rencontrée en exécutant se tranche par ce filtre. `PDC-005` pose le principe ; ce tableau le rend applicable.

| L'agent décide et avance quand | L'agent s'arrête et ouvre une objection quand |
|---|---|
| La décision est réversible | Le geste est irréversible ou coûteux à défaire |
| Elle touche du code ou un document d'agent | Elle touche un document en régime d'édition humaine |
| Une lecture raisonnable existe | Deux lectures mènent à des travaux incompatibles |
| Se tromper coûte une correction | Se tromper coûte une migration |

**Les quatre lignes se lisent ensemble.** Une seule colonne de droite qui s'applique suffit à arrêter.

**Une décision prise en avançant n'est pas une décision tue.** Elle est consignée dans le journal de la tâche, rubrique « ce qui a été décidé en avançant » du log d'analyse ou du log de fait. Elle change de lieu, pas de statut.

## Étape 3 - Exécuter chantier par chantier

Dans l'ordre que le plan déclare. Chaque chantier a un critère de réussite exécutable : **il est exécuté, pas supposé**.

**Un écart au plan décidé en l'exécutant se déclare.** Le plan a été écrit avant de connaître le terrain ; le corriger est normal, le corriger en silence ne l'est pas.

### Deux formes qui interrompent l'humain, et ce qui les remplace

**Sa portée dépasse l'exécution d'un plan.** La règle vaut pour tout travail de l'agent ; elle vit ici parce que c'est le lieu où l'agent agit, et `PLN-015` chantier B laissait le choix du lieu.

`BUG-001` a relevé quinze interruptions sur deux tâches. **Six venaient de la façon dont l'agent invoquait ses outils**, et six seulement : les autres sont hors de sa portée, `ANL-012` C2 le mesure.

**R1. Un fichier s'écrit avec l'outil d'écriture, jamais par un document en place dans une commande shell.**

**R2. Un chemin qui ne sert qu'une fois s'écrit en toutes lettres, jamais par une variable.**

Les six cas, et la forme qui n'aurait rien déclenché :

| Interruption | Ce qui a été fait | Ce qu'il fallait faire |
|---|---|---|
| 1 | `cat > "$D/TSK-01-demande_${TS}_....md" <<'FIN'` | L'outil d'écriture, chemin complet en clair |
| 2 | `for f in .../setup.sh …; do … "$(wc -l < "$f")"; done` | Quatre commandes, quatre chemins littéraux |
| 3 | `R=/home/…/bin/tda ; grep -n -A45 '…' "$R"` | `grep -n -A45 '…' /home/…/bin/tda` |
| 5 | `H=.claude/hooks/… ; printf … \| python3 "$H"` | `printf … \| python3 .claude/hooks/…` |
| 7 | Deux `cat > "$D/…" <<'FIN'` dans un seul appel | Deux appels à l'outil d'écriture |
| 9 | `python3 - <<'PY'` remplaçant des chaînes dans deux fichiers | L'outil d'édition, un remplacement par appel |

**Le motif.** Une ligne contenant une variable, une substitution ou un document en place ne peut être comparée à aucune règle de permission : l'outil ne sait pas ce qu'elle fera, donc il demande. Les deux règles ci-dessus retirent le motif de la demande au lieu d'essayer d'y répondre.

**Ce que ces règles ne prétendent pas.** Elles suppriment six interruptions sur quinze. Les huit autres sont des scripts d'épreuve — créer un dépôt jetable, y lancer une commande, comparer une empreinte — qui ont besoin de variables pour être reproductibles. **Aucune discipline ne les rendra analysables statiquement**, et le chantier A de `PLN-015` a établi qu'un hook ne les autorise pas non plus.

## Étape 4 - Rendre les fonctionnalités livrées

**C'est la directive de la tâche 9, et elle porte sur ce qui est rendu à l'humain, non sur ce qui est produit.**

À la fin de l'exécution, le journal de fait déclare, pour chaque fonctionnalité touchée :

| Élément | Ce qu'il porte |
|---|---|
| **Ce qui a été livré** | La capacité neuve, en une phrase |
| **Comment s'en servir** | La commande, avec un exemple qui s'exécute |
| **Ce qui ne marche pas encore** | Les limites connues, et les items ouverts qui la touchent |

**Le même contenu alimente la ressource `FNC` correspondante.** Une fonctionnalité neuve reçoit une instance ; une fonctionnalité étendue voit sa rubrique « Comment s'en servir » mise à jour.

**Le motif.** Un plan exécuté laissait jusqu'ici un journal de fait et un message de commit, dont aucun ne dit comment se servir de ce qui vient d'être livré. L'humain devait lire le code ou l'aide pour le découvrir.

## Étape 5 - Clore le plan

`statut-plan` passe à `execute`, et la section « Statut » du corps dit quelle tâche l'a exécuté, à quelle date.

**Un plan partiellement exécuté ne passe pas à `execute`.** Il reste `propose`, et le journal dit quels chantiers ont été faits et lesquels ne l'ont pas été.

## Étape 6 - Rendre la directive

**Une tâche se termine sur un geste, pas sur un rapport.**

`BUG-005` : deux plans exécutés, deux échecs déclarés, treize journaux produits — et l'humain sans rien à faire. La prescription antérieure disait « propose l'action utile » sans dire où, sous quelle forme, ni combien. Une règle sans format ne tient pas.

### La forme

**Une directive, une seule, en tête de ce qui est rendu à l'humain.** Quatre éléments :

| Élément | Ce qu'il porte |
|---|---|
| **Le geste** | Une phrase à l'impératif |
| **La commande** | Ce qu'on tape, exactement, copiable telle quelle |
| **Ce qu'il débloque** | Combien de chantiers, quels plans |
| **Qui** | L'humain ou l'agent |

**Le reste du rapport vient après.** Un humain qui doit lire quarante lignes pour trouver quoi faire ne le trouve pas.

### La règle de cohérence

**La directive rendue est celle que `clia focus` désigne.**

Si les deux divergent, **la commande a raison**, et l'agent corrige la commande — non son message. Une divergence signale que le dépôt ne sait pas voir ce que l'agent a compris : c'est un défaut du système, pas une nuance à expliquer en prose.

C'est ce qui empêche le défaut de revenir. Aux tâches 11 et 12, l'agent écrivait « statuer sur `DCN-016` » pendant que `clia focus` disait « corriger `BUG-001` ». **Deux réponses à la même question, et un humain qui n'en exécute aucune.**

### Ce qui vaut aussi quand tout s'est bien passé

Une exécution réussie se termine également sur une directive. Le geste est alors « commiter », ou l'exécution du plan suivant — mais il est nommé, et il est unique.

## Ce qui n'est pas fait, et comment le dire

**Une exécution qui ne produit aucun livrable est un échec, et se déclare comme tel.**

L'agent ne clôt pas la tâche en la déclarant réussie : il nomme l'anomalie, en cherche la cause, et **rend la directive de l'étape 6**.

C'est le second défaut relevé par `BUG-002`, et le plus grave des deux : présenter une tâche vide comme un succès empêche l'humain de voir qu'il y a un problème.

**Un échec ne dispense pas de la directive — il la rend plus nécessaire.** C'est le cas où l'humain a le moins de moyens de deviner quoi faire.

## Éprouvé sur

| Cas | Résultat |
|---|---|
| Les 39 objections du dépôt, rangées une à une par le filtre de l'étape 2 | **26 devaient s'arrêter, 12 pouvaient avancer, 1 n'est pas une objection.** Douze sur trente-neuf n'avaient pas lieu d'être ouvertes |
| `NON-035` et `NON-036`, rangées du côté « avancer » | **Vérifié après coup** : traitées en avançant, `PLN-011` et le type `Bogue`, sans qu'aucune décision coûte de retour en arrière |
| `NON-013` | **Le filtre ne le range pas**, et c'est juste : un brouillon vide ne porte aucune incertitude à trancher |

**Ce que l'épreuve établit.** Le filtre départage, et il départage dans le sens qui réduit les objections : près d'un tiers des cas passés.

**Ce qu'elle n'établit pas.** Sa tenue sur des cas neufs. Le rangement porte sur trente-neuf objections déjà écrites, par celui-là même qui les a ouvertes.

## Comment vérifier que la méthodologie est suivie

| Contrôle | Ce qu'il regarde |
|---|---|
| Le type de la tâche autorisait-il l'exécution | L'énoncé de la tâche |
| Chaque critère de réussite a-t-il été exécuté | Le log de résultat de validation |
| Les fonctionnalités livrées sont-elles décrites avec leur usage | Le log de fait |
| Le plan déclare-t-il la tâche qui l'a exécuté | La section « Statut » du plan |
| **Une directive unique est-elle rendue, en tête** | Ce qui est rendu à l'humain |
| **Porte-t-elle une commande copiable telle quelle** | La même |
| **Désigne-t-elle le même geste que `clia focus`** | La sortie de la commande |

## Relations

- `derive-de` [BUG-002](../bogues/BUG-002-un-plan-est-execute-par-la-tache-qui-le-cree.md)
- `derive-de` [PLN-013](../plans/PLN-013-borner-l-ouverture-des-objections.md)
- `reference` [PDC-003](../principes/PDC-003-smart-et-extreme-smart.md)
- `reference` [PDC-005](../principes/PDC-005-mode-ia-best-effort-documente.md)
- `reference` [MET-003](MET-003-journalisation-du-travail.md)
- `reference` [MET-004](MET-004-reevaluation-d-un-plan-par-le-regime-smart.md)
