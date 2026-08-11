# Analyse avant réalisation, tâche 33

`MET-003` étape 2.

## Les quatre questions ont une réponse

C'est la deuxième objection du dépôt à recevoir une réponse complète dès son premier traitement.

| Question | Réponse |
|---|---|
| Q1 | Quatre champs, et un premier jet de `DCN` à proposer |
| Q2 | Si OKF en a besoin, préserver ; sinon supprimer |
| Q3 | Oui, refactorer **toutes** les ressources |
| Q4 | Oui, supprimer tous les autres champs d'état |

## Le guess de l'humain se vérifie, et deux sources se contredisent

Q1 : « Mon guess est que `status` avec les 4 valeurs possibles provient de la décision d'être compatible avec le système OKD. »

**Le guess est fondé.** `RES-001` du dépôt `micrologic-clients`, d'où le modèle de `clia` est repris, le dit deux fois.

| Ligne | Ce qu'elle dit |
|---|---|
| 39 | « Trois classes, plus `status` et `stale_after` du **format OKF** » |
| 99 | « `status` : `draft`, `stable` ou `deprecated`, **au sens d'OKF** » |

**Mais une autre source du corpus le contredit.** `ANL-006`, l'analyse d'OKF archivée, énumère les champs réservés du format : `type`, `title`, `description`, `tags`, `timestamp`. **`status` n'y figure pas.**

**Je ne peux pas trancher.** La spécification OKF elle-même n'est pas consultable dans cette session, faute d'outil en ligne. C'est la même limite que `FND-004` a déclarée hier.

**Ce que cela change pour Q2.** La réponse est conditionnelle : « si OKF en a besoin, préserver ». La condition n'est pas vérifiable ici, donc la suppression ne peut pas être décidée par l'agent. Elle est portée au plan comme un chantier à préalable ouvert.

## Les quatre champs demandés

| Champ | Valeurs | Ce qu'il dit |
|---|---|---|
| `maturity` | conception, mature, fin-de-vie, obsolète | Où en est le document |
| `adoption` | proposé, adopté, contesté, obsolète | Ce que le système en fait |
| `activated` | true, false | Si on doit le considérer |
| `domain-status` | définies par le `RES` du type | Le cycle de vie métier |

**Ce que la répartition règle.** `ANL-009` C9 relevait que le dépôt confond deux natures d'état : la maturité documentaire et l'avancement du travail. Les quatre champs les séparent, et en ajoutent deux que personne n'avait nommées : l'adoption, et l'activation.

**Ce que `domain-status` reprend.** C'est le champ propre au type, que huit types portent déjà sous huit noms différents. Q4 demande de tous les supprimer au profit de celui-ci.

## Une incohérence de nommage à signaler

L'humain écrit **`status-metier`** dans le texte de Q1, puis **`domain-status`** dans la liste de Q3.

Deux noms pour le même champ, et deux langues : les trois autres champs sont en anglais, `maturity`, `adoption`, `activated`, alors que tout le frontmatter existant est en français, `statut`, `etat`, `effet`, `portee`, `cycle-de-vie`.

**Ce que cela pose.** Un frontmatter mêlant les deux langues est ce que `NON-004` Q2 nomme comme dérive lexicale, et l'ontologie qui la trancherait n'existe pas.

Le plan retient les noms de Q3, qui sont les plus précis, et signale la question.

## Le volume du refactor

| Champ | Occurrences |
|---|---|
| `status` | **158** |
| `effet` | 49 |
| `etat` | 43 |
| `statut` | 36 |
| `statut-decision` | 17 |
| `statut-plan` | 6 |
| `exploitation` | 2 |
| `tenue` | 1 |
| **Total** | **312** |

**Cent cinquante-sept instances reçoivent quatre champs**, soit 628 valeurs à poser. **Cent cinquante-quatre champs sont supprimés.**

C'est le plus gros refactor demandé depuis la migration de la tâche 13, qui avait converti 83 identifiants.

## Ce qui rend ce refactor plus dur que celui de la tâche 13

**Les valeurs ne sont pas déductibles.** Convertir un identifiant était mécanique. Décider si `ADR-008` est `mature` ou en `conception`, `adopté` ou `contesté`, demande un jugement par instance.

**`adoption` est en partie une décision humaine.** `FCT-001` établit que les quatorze `DCN` et trois `PDC` du dépôt ont été rédigés par l'agent et qu'aucun n'est approuvé. Leur `adoption` vaut donc `proposé`, et le poser revient à constater ce que `NON-024` conteste.

**`domain-status` demande de réviser trente-six définitions**, chacune devant déclarer ses valeurs propres.

**Aucun générateur n'existe** pour régénérer les soixante-deux schémas. `ISU-002` le porte.

## Ce que la demande impose sur la forme du plan

« Créer un plan avec livrables SMART. »

`PDC-003` place les plans au régime **extrême SMART**, et `ANL-009` mesure que les six plans du dépôt échouent tous à V-S3, la limite de temps.

**Ce plan doit donc déclarer une durée**, ce qu'aucun autre n'a fait. Le dépôt n'a mesuré la durée d'aucun chantier ; les durées seront des estimations déclarées comme telles.

## Sur la DCN demandée

Q1 : « Ajouter ces 4 champs dans DCN-004. Proposer un premier jet de DCN. »

**`DCN-004` existe et porte un autre sujet** : l'adoption du processus de travail collaboratif. Y ajouter les champs serait falsifier une décision enregistrée, ce que `RES-009` interdit.

**Lecture retenue.** « Proposer un premier jet de DCN » désigne une décision nouvelle. Le prochain numéro libre est `DCN-015`.

**Une tension à déclarer.** `CONSTITUTION.md` C1 interdit à l'agent de créer une `DCN`. `DCN-013`, qui lui est supérieure, autorise un premier jet suspendu jusqu'à approbation. L'humain demande explicitement un premier jet.

Le premier jet sera donc produit avec `effet: suspendue`, valeur que `RES-009` porte déjà, et la tension sera signalée comme elle l'a été pour `PDC-003` à la tâche 23.

## Ce que je vérifierai pour L3 et L4

Le critère de clôture de chaque issue, et si les réponses l'atteignent.

Le compte des objections ouvertes après ce traitement.
