---
type: specification
id: SPC-001
title: "Conformité d'un dépôt clia"
version: 0.1.0
status: draft
maturity: conception
adoption: propose
activated: true
---

# SPC-001 - Conformité d'un dépôt clia

> Deux questions, deux jeux de critères. Un dépôt peut être **instrumentable** sans être **instrumenté**, et les commandes qui l'installent ou le diagnostiquent ont besoin des deux réponses.

## Objet

Fixer ce qu'est un dépôt `clia` conforme, afin que `clia setup init` sache quoi produire et que `clia setup check` sache quoi vérifier.

`PLN-003` chantier G1 réclame ce document depuis le 2026-08-11 : « Sans les critères, `init` ne sait pas quoi produire et aucun contrôle ne sait quoi vérifier. »

**Cette spécification ne nomme aucune technologie.** `RES-020` en fait la propriété définitionnelle du type. Chaque critère énonce un état observable ; la manière de le constater appartient à l'implémentation.

## Comportement observable

### Les deux niveaux

| Niveau | Question | Préfixe |
|---|---|---|
| **Instrumentable** | Peut-on instrumenter ce dépôt sans altérer ce qu'il contient ? | `I` |
| **Instrumenté** | Ce dépôt est-il équipé, et conforme à la version qu'il déclare ? | `C` |

**Les deux niveaux ne s'excluent pas.** Un dépôt instrumenté reste instrumentable ; le second jeu s'applique alors en plus du premier.

### Critères d'instrumentabilité

| Réf | Énoncé | Verdict si faux |
|---|---|---|
| **I1** | L'emplacement désigné existe et est un répertoire | **Bloquant** |
| **I2** | L'emplacement est accessible en écriture | **Bloquant** |
| **I3** | L'emplacement est un dépôt de gestion de versions, ou peut le devenir | **Avertissement** |
| **I4** | Aucun des emplacements que l'instrumentation occupe n'est déjà pris | **Avertissement** |

**I3 n'est pas bloquant.** Un dépôt de gestion de versions peut être créé au moment de l'instrumentation. Ce qui serait bloquant est l'impossibilité d'en créer un.

**I4 n'est pas bloquant, et c'est délibéré.** Un emplacement déjà occupé est conservé tel quel, jamais écrasé. Le dépôt reste instrumentable ; l'instrumentation sera partielle, et elle doit le dire.

### Critères de conformité

| Réf | Énoncé | Verdict si faux |
|---|---|---|
| **C1** | Le dépôt porte un répertoire de développement | **Bloquant** |
| **C2** | Le dépôt porte un point d'entrée de harnais pour l'agent | **Bloquant** |
| **C3** | Le dépôt déclare son intention ultime | **Bloquant** |
| **C4** | Le dépôt porte un ensemble de définitions de types, non vide | **Bloquant** |
| **C5** | Le dépôt porte un point d'entrée des demandes | **Avertissement** |
| **C6** | Le dépôt déclare la version sous laquelle il a été instrumenté | **Avertissement** |
| **C7** | La version déclarée est celle du système qui l'interroge | **Avertissement** |

**Un dépôt est conforme quand aucun critère bloquant n'est faux.** Les avertissements ne rendent pas un dépôt non conforme : ils nomment ce qui manque.

### Ce que chaque critère protège

**C1** est ce qui distingue un dépôt équipé d'un dépôt quelconque. C'est aussi ce que la résolution du dépôt courant cherche en premier.

**C2 et C3** portent l'autorité. Sans point d'entrée de harnais, l'agent n'a pas de mode opératoire ; sans intention déclarée, il n'a pas de quoi arbitrer un conflit. `ANL-001` mesure que le fichier d'intention est le point où les erreurs d'installation deviennent visibles : deux dépôts métiers y portaient l'intention d'un autre système, et trois dépôts de consultation désignaient le mauvais client.

**C4** est ce qui rend le système utilisable. Un dépôt sans définitions de types répond « aucun type de ressource » à toute demande.

**C5** est le point d'entrée des demandes. Il est un avertissement et non un bloquant : un dépôt fraîchement instrumenté n'a pas encore de session, et le harnais reste lisible sans elle.

**C6 et C7** portent la mise à jour. Ils sont des avertissements aujourd'hui parce que le mécanisme de mise à jour n'existe pas : `ISU-012` le porte. Ils deviendront bloquants quand il existera.

### Ce que le diagnostic doit rendre

| Élément | Exigence |
|---|---|
| Le niveau constaté | Le diagnostic dit lequel des deux jeux s'applique, avant de rendre son verdict |
| Le verdict par critère | Chaque critère évalué apparaît avec sa référence et son résultat |
| Le verdict d'ensemble | Un seul mot : conforme, non conforme, ou instrumentable |
| La distinction bloquant et avertissement | Un avertissement ne fait pas échouer le verdict d'ensemble |

**Le diagnostic ne modifie rien.** Aucun critère ne s'évalue en écrivant.

### Ce que l'instrumentation doit produire

| Exigence | Énoncé |
|---|---|
| **P1** | Après instrumentation, tous les critères de conformité bloquants sont vrais |
| **P2** | Aucun emplacement déjà occupé n'est écrasé ni modifié |
| **P3** | Le dépôt source de l'instrumentation n'est pas modifié |
| **P4** | Un emplacement conservé est annoncé, non tu |
| **P5** | L'instrumentation est rejouable : la relancer sur un dépôt déjà instrumenté ne dégrade rien |

**P3 est une exigence de l'humain**, énoncée dans la tâche 4 de `SES-002` : « aucune modification du remote n'est nécessaire ».

**P5 est ce qui rend l'instrumentation sûre.** Un utilisateur qui doute relance ; la commande doit le supporter.

### Les deux régimes d'instrumentation

| Régime | Ce que les fichiers de harnais deviennent dans le dépôt cible |
|---|---|
| **Lié** | Des renvois vers le dépôt source. Une modification du source est immédiatement visible |
| **Copié** | Des exemplaires indépendants. Le dépôt cible survit à la disparition du source |

**Le régime lié sert le développement**, le régime copié sert l'usage. Le choix appartient à l'appelant, et le régime employé est déclaré à l'instrumentation.

## Interfaces

### Entrées

| Entrée | Rôle | Défaut |
|---|---|---|
| L'emplacement cible | Le dépôt à diagnostiquer ou à instrumenter | Le répertoire courant |
| Le régime | Lié ou copié | Copié |

### Sorties

| Sortie | Destination |
|---|---|
| Le verdict par critère et le verdict d'ensemble | La sortie de données |
| Les explications et les conseils | La sortie d'erreur |

`ADR-003` D9 : la sortie sert un humain, un agent et un programme. Séparer les deux flux rend le verdict analysable sans filtrage.

### Codes de retour

| Code | Signification |
|---|---|
| 0 | Le verdict est favorable : conforme, ou instrumentable |
| 1 | Le verdict est défavorable : un critère bloquant est faux |
| 2 | La demande est mal formée |

## Ce qui est hors périmètre

**La mise à jour d'un dépôt instrumenté.** `ISU-012` porte les quatre livrables qui lui manquent. C6 et C7 préparent le terrain en rendant la version observable, sans dire ce qu'on en fait.

**Le contenu des définitions de types.** C4 exige qu'il en existe, non qu'elles soient correctes. Valider une définition est le travail que `ISU-007` réclame sous le nom d'un outil de validation.

**La conformité des instances.** Un dépôt conforme peut contenir des ressources non conformes. Les deux niveaux sont distincts, et le second n'est pas spécifié ici.

**Le nombre et le nom exacts des emplacements occupés.** L'implémentation les déclare ; les changer ne change pas cette spécification.

## Relations

- `derive-de` [PLN-009](../plans/PLN-009-commandes-d-installation-et-d-instrumentation.md)
- `reference` [RES-020](../ressources/RES-020-specification.md)
- `reference` [ISU-012](../issues/ISU-012-la-mise-a-jour-d-un-depot-instrumente-n-a-pas-d-objet.md)
- `reference` [NON-039](../objections/NON-039-ce-que-les-commandes-d-installation-laissent-ouvert.md)
