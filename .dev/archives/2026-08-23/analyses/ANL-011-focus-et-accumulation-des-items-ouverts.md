---
type: analyse
id: ANL-011
title: "Focus et accumulation des items ouverts"
status: draft
maturity: conception
adoption: propose
activated: true
date: 2026-08-13
sujet: "Pourquoi le nombre de choses à faire augmente à mesure qu'on travaille, et ce qui le ferait diminuer"
generated:
  by: claude-opus-5
  at: 2026-08-13
---

# ANL-011 - Focus et accumulation des items ouverts

> L'humain répond à 98 % des questions qu'on lui pose. Trente et un des documents qu'il a entièrement traités sont toujours comptés comme ouverts. Le problème n'est pas qu'il ne réponde pas : c'est que **rien, dans le système, ne ferme quoi que ce soit**.

## Objet

Répondre aux quatre questions de la tâche 6 de `SES-002`, dont la dernière commande les trois autres : comment faire que plus on travaille, plus le nombre d'items à faire diminue ?

## Méthode

Dénombrement de tous les documents appelant une décision ou une action, par type, par état, et par date de création tirée de l'historique git. Puis comptage des questions posées et des réponses reçues, document par document.

**Une observation n'est pas une norme.** `skl-001` A7. Ce qui suit est un constat sur ce dépôt, non une règle générale.

## Constats

### C1 - L'humain répond, massivement

| Mesure | Valeur |
|---|---|
| Questions posées dans les objections | **217** |
| Réponses reçues | **213** |
| Taux de réponse | **98 %** |
| Objections entièrement répondues | **36 sur 38** |
| Objections sans aucune réponse | **2** |

**Le goulot n'est pas l'humain.** L'hypothèse implicite de mes journaux — « en attente d'une réponse de l'humain » — est fausse dans la quasi-totalité des cas.

### C2 - Rien ne se ferme

| Type | Total | Fermés |
|---|---|---|
| Objections | 39 | **5** portent `repondue`, aucune n'est close |
| Issues | 12 | **0** |
| Plans | 9 | 4 exécutés, 4 jamais engagés, 1 abandonné |

**Trente et une objections sont entièrement répondues et portent toujours `etat: ouverte`.**

C'est le constat central. Le travail de l'humain est fait, et le compteur ne le sait pas.

### C3 - Les états sont définis, et personne ne les emploie

**Correction d'une mesure erronée faite en cours d'analyse.** J'ai d'abord écrit que `RES-004` ne déclarait aucune valeur d'état. C'est faux : il en déclare **sept**, avec leur sens, et la rubrique est soignée.

| État déclaré | Instances qui le portent |
|---|---|
| `ouverte` | 33 |
| `repondue` | 5 |
| `partiellement-repondue` | **0** |
| `resolue` | **0** |
| `levee-par-decision` | **0** |
| `differee` | **0** |
| `caduque` | **0** |

**Deux valeurs sur sept sont employées.** Les cinq autres décrivent exactement les situations que le dépôt vit — une objection dont l'humain a décidé de passer outre, une dont l'objet a disparu — et aucune n'a jamais servi.

| Élément | État |
|---|---|
| Valeurs déclarées par `RES-004` | 7, avec leur sens |
| Contrainte dans `objection.cue` | `etat: string & !=""` — **aucune** |
| Geste qui fait passer d'un état à l'autre | **Aucun** |

**Le défaut n'est pas une définition manquante : c'est une définition excellente que rien ne fait respecter.** C'est le sujet de `NON-005`, ouverte le 2026-08-09 et toujours d'actualité quatre jours plus tard.

`RES-031` déclare quatre valeurs pour l'issue — et zéro issue est fermée.

### C4 - L'état affiché n'est pas l'état qui compte

```
ID       DESCRIPTION                                    STATUS
NON-001  Identité, nommage et préfixes des ressources   draft
NON-005  Validation mécanique et règles écrites...      draft
```

`clia res ls` affiche `status`, qui vaut `draft` dans les 163 instances du dépôt. Il n'affiche jamais `etat`, qui est le seul champ qui varie.

**C'est `ISU-008`, ouverte le 2026-08-11 à la demande de l'humain, et jamais corrigée.** `PLN-007` chantier F la porte ; `PLN-007` est bloqué par une décision suspendue. L'humain redemande la même chose deux jours plus tard.

### C5 - La courbe est monotone croissante

| Jour | Créés | Cumul |
|---|---|---|
| 2026-08-09 | 12 | 12 |
| 2026-08-10 | 13 | 25 |
| 2026-08-11 | 28 | **53** |
| 2026-08-12 | 4 | 57 |
| 2026-08-13 | 4 | **61** |

**Soixante et un items en cinq jours, aucun retrait.** La pente s'infléchit, elle ne s'inverse jamais.

Le 11 est le pic : vingt-huit items en un jour, dont neuf issues créées d'un coup en réévaluant un plan.

### C6 - La moitié des réponses ne produit rien de visible

Sur les 36 objections entièrement répondues, **24 ont une suite identifiable** dans un journal de tâche. Douze n'en ont aucune.

**Une réponse humaine sans suite est un travail perdu deux fois** : l'humain a réfléchi, et l'agent n'en a rien fait.

### C7 - Rien ne relie un plan à ce qu'il produit

Neuf plans, et aucun ne déclare quelle fonctionnalité il livre. Pour savoir ce que `PLN-006` implémente, il faut le lire en entier.

L'humain le formule ainsi : « on ne sait pas les fonctionnalités que vont implémenter PLN et si ils sont exécutés ou non, SMART ou non ».

## Réponse aux quatre questions

### Pourquoi le nombre d'items augmente

**Parce que le système a un mécanisme d'ouverture et aucun mécanisme de fermeture.**

Trois causes, dans l'ordre de leur poids.

| Cause | Mesure |
|---|---|
| Les états sont définis mais rien ne les impose ni ne les applique | 31 documents traités et comptés ouverts, 5 valeurs sur 7 jamais employées |
| Aucune commande ne ferme quoi que ce soit | 0 verbe de clôture dans le CLI |
| Ma méthode ouvre une objection par tâche, par habitude | 39 objections en 5 jours |

**La troisième est de moi.** Les deux premières sont structurelles ; celle-là est une pratique que j'ai installée sans qu'aucune règle ne la prescrive. `PDC-005`, écrit hier, la corrige explicitement.

### Comment obtenir du focus

**Une seule commande qui répond à « que dois-je faire maintenant ? »**, et qui range par ce qui débloque le plus.

Le dépôt a tout ce qu'il faut pour la calculer : les objections répondues attendent une clôture, les objections sans réponse attendent l'humain, les plans proposés attendent une exécution, les issues attendent un travail.

**Ce qui manque n'est pas l'information : c'est son agrégation.** Elle est dispersée dans 61 fichiers.

### Comment implémenter malgré l'incertitude

`PDC-005` le dit déjà. Ce qui manque est le **critère de départage** entre ce qui se décide en avançant et ce qui doit s'arrêter.

**Proposition, tirée de ce que le dépôt a vécu.**

| L'agent décide et avance quand | L'agent s'arrête quand |
|---|---|
| La décision est réversible | Le geste est irréversible ou coûteux à défaire |
| Elle touche du code ou un document d'agent | Elle touche un document en régime humain |
| Une lecture raisonnable existe | Deux lectures mènent à des travaux incompatibles |
| Se tromper coûte une correction | Se tromper coûte une migration |

**Les objections que j'ai ouvertes ne passent pas ce filtre.** Sur les 39, une lecture raisonnable existait dans la plupart des cas : j'aurais dû décider, documenter dans le journal de la tâche, et continuer.

### Comment garder les objections importantes

**En les rendant rares.** Une objection qui arrive une fois par semaine est lue ; une qui arrive deux fois par jour est ignorée.

Le filtre ci-dessus suffit. Il n'a pas besoin d'un mécanisme neuf.

## Recommandations

Cinq, ordonnées par effet immédiat sur le compteur.

| Réf | Recommandation | Effet mesurable |
|---|---|---|
| **R1** | Imposer les états déjà déclarés, et fermer ce qui est répondu | **-31 items** |
| **R2** | Afficher l'état qui varie, non celui qui ne varie pas | L'humain voit où il en est |
| **R3** | Une commande de focus, une seule action à la fois | Le dépôt répond « fais ceci » |
| **R4** | Borner l'ouverture par un critère écrit | Moins d'objections, plus lues |
| **R5** | Un type `Fonctionnalité`, pour relier un plan à ce qu'il livre | On sait ce qu'un plan produit |

Chacune a son plan : `PLN-010` à `PLN-014`.

**R1 est exécutée dans cette tâche même.** Recommander de fermer sans fermer serait ajouter un item de plus.

## Les deux types proposés par l'humain

### Fonctionnalité : oui

**Elle répond à un manque mesuré**, C7 : neuf plans, aucun ne dit ce qu'il livre.

Elle donne aussi l'unité de focus qui manque. « Travailler sur une fonctionnalité » est une phrase que le dépôt ne peut pas exprimer aujourd'hui : il n'a que des plans, des issues et des objections, qui sont tous des unités de *problème*, jamais des unités de *produit*.

`PLN-014` le porte.

### Note d'implémentation : non, et voici pourquoi

**Le contenu existe déjà.** `MET-003` prescrit sept journaux par tâche, dont `TSK-03-fait`, qui est exactement « ce qui a été implémenté et pourquoi ». Le dépôt en compte quarante-quatre.

L'humain pressent le recoupement et le dit : « il semble y avoir un recoupement avec les commit-message ». Le recoupement est plus large que cela — il y en a trois : le journal du fait, le message de commit, et la note proposée.

**Ce qui manque n'est pas un type, c'est une sortie.** Les notes de version se dérivent des journaux existants ; aucune ressource neuve n'est nécessaire.

**Et créer un type coûte cher, c'est mesuré.** Chaque type demande une définition, deux schémas, un gabarit, et une entrée dans le harnais. `NON-002` conteste la prolifération des types depuis le 2026-08-09.

**Ce que je recommande à la place** : que le message de commit devienne bref, que le journal du fait reste le lieu du détail — c'est déjà le cas — et qu'une commande dérive les notes de version des journaux. C'est un chantier de `PLN-013`, pas un type de plus.

**Un type de moins créé est un item de moins.** C'est le sujet même de cette analyse.

## Limites

**Le taux de réponse de 98 % est peut-être trompeur.** Il compte les blocs de réponse, non leur substance : deux réponses disent « je ne comprends pas cette objection ».

**La mesure de C6 est faible.** « Une suite identifiable » signifie que l'identifiant apparaît dans un journal de fait, ce qui ne prouve pas que la réponse a été exploitée.

**Une mesure de cette analyse s'est révélée fausse en cours de route.** J'avais conclu que `RES-004` ne déclarait aucun état, en cherchant dans une rubrique qui n'existe pas sous ce nom. C3 porte la correction. Les autres mesures reposent sur des dénombrements de fichiers et de motifs, moins exposés à ce type d'erreur, mais je n'ai pas revérifié chacune de la même manière.

**Cette analyse ajoute un document à un dépôt qui en a trop.** Elle se justifie par ce qu'elle retire : R1 en retire trente et un, et le refus du type `Note d'implémentation` en évite quatre de plus.

**Le critère de départage proposé n'est pas éprouvé.** Il est construit après coup sur trente-neuf cas que j'ai moi-même produits, et je suis mal placé pour juger lesquels méritaient une objection.

## Relations

- `reference` [PDC-005](../principes/PDC-005-mode-ia-best-effort-documente.md)
- `reference` [ISU-008](../issues/ISU-008-le-statut-affiche-n-apprend-rien.md)
- `reference` [NON-002](../objections/NON-002-cout-du-modele.md)
- `reference` [MET-003](../methodologies/MET-003-journalisation-du-travail.md)
