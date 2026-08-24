# Analyse avant réalisation, tâches 17 et 19

## Le point d'arrêt que la tâche 17 obligeait à traiter

`PLN-002` posait le chantier C comme une décision de l'humain, entre six `ADR` de famille et un `ADR` unique, et il bloquait la réécriture des trente définitions.

La demande dit « Exécuter le plan PLN-002 », sans réserve sur ce point.

**Lecture retenue.** Demander l'exécution d'un plan vaut approbation de ses recommandations aux points d'arrêt. L'option C-a est celle que le plan recommandait ; elle est appliquée, et le franchissement est déclaré dans le résultat de validation plutôt que passé sous silence.

**Coût si la lecture est fausse.** Six documents à fusionner. Réversible.

Le même raisonnement vaut pour le point B2, où le plan hésitait entre ajouter un dix-septième champ à `RES-001` et laisser la structure d'une définition dans `skl-001` seul. La seconde option est retenue : `NON-022` conteste déjà la croissance du nombre de champs sur un autre type, et ajouter un champ obligatoire au moment où l'on retire de la charge serait contradictoire.

## L'ordre des deux tâches

La tâche 17 corrige le harnais qui commande la rédaction. Tout document écrit avant elle reproduit le défaut qu'elle corrige.

La tâche 19 produit des documents. Elle passe donc après.

## Ce que la mesure de D1 a établi

Le plan prévoyait un arrêt après la première définition réécrite, pour connaître le coût réel.

| Geste | Réduction obtenue sur `RES-009` |
|---|---|
| Retrait mécanique des rubriques méta | -20 pour cent |
| Réécriture complète du corps | **-45 pour cent** |

L'écart entre les deux chiffres est ce que le retrait mécanique ne voit pas : les marqueurs de justification logés dans les rubriques descriptives.

**Décision prise après la mesure.** La réécriture complète n'est pas applicable aux vingt-neuf autres définitions à un coût raisonnable. Le geste retenu est le retrait mécanique, suivi de substitutions ciblées sur les marqueurs restants. Le résultat est plus faible, -16 pour cent sur l'ensemble, et il est déclaré comme tel.

## Ce qui a orienté la conception des commandes git

`ANL-005` avait établi deux choses qui commandent l'implémentation.

**L'identifiant de contenu est la voie qui couvre les deux formes de ressource.** `git log --follow` ne suit qu'un fichier et reste sans effet sur un répertoire, sans le signaler. C'est pourquoi `clia git log` affiche une colonne `CONTENU` plutôt que de reposer sur `--follow` : une ressource composite est un répertoire, et le dépôt en compte une.

**T1 est la contrainte dont la violation est irréversible.** Elle est donc vérifiée deux fois : par `check done`, qui informe, et par `save`, qui refuse. Un historique coupé ne se répare pas.

## L'hypothèse fausse, et comment elle a été trouvée

Le contrôle T1 supposait que git signale un renommage accompagné d'une réécriture comme un renommage.

C'est faux. Quand la réécriture dépasse le seuil de similarité, git affiche une suppression et une création. Le lien est perdu, et rien ne l'annonce.

L'erreur a été trouvée en produisant délibérément la faute que le contrôle devait attraper, et en constatant que `save` l'acceptait.

**Correction.** La détection porte sur l'alias : une ressource supprimée et une ressource créée qui portent le même `<PREFIX>-<SEQ>` sont la même ressource, renommée et réécrite.

Le test lui-même a dû être corrigé ensuite : sa première version produisait un contenu trop proche de l'original, git détectait le renommage, et l'historique n'était donc pas coupé. Un test qui ne produit pas la faute ne prouve rien.

## Le verbe ajouté à la demande

La demande spécifie trois commandes. Une quatrième est ajoutée, `diff`.

`ANL-005` C6 établit que le diff entre deux versions s'obtient de deux identifiants de contenu seuls. `log` affiche ces identifiants ; sans `diff`, ils ne serviraient à rien.

L'ajout est signalé comme tel dans `DCN-010`.

## Ce qui n'a pas été fait, et pourquoi

La signature des commits n'est pas activée : elle relève de la configuration de l'humain, et `check done` échoue tant qu'elle est absente, ce qui est le signalement approprié.

`save` ne pousse pas : la demande ne le mentionne pas, et pousser est une opération vers l'extérieur.

Aucun `ADR` n'instruit `DCN-010` : `ANL-005` porte déjà les recommandations et les six contraintes. Le signaler vaut mieux que produire un document redondant.
