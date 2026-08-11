# Analyse avant réalisation, tâche 14

## Le point de départ : sept apports, et un qui commande les autres

`FND-003` clôt sur une table de sept apports. Ils ne sont pas de même poids, et les traiter à égalité produirait une définition alourdie sans que le défaut principal soit corrigé.

| Apport | Poids | Ce qu'il change |
|---|---|---|
| Le changement est un acte, non un état | **Structurant** | Refonte du mécanisme de changement de `RES-009` |
| L'authenticité doit être attestée | Fort | Un champ manque |
| Le facteur politique n'a pas de solution technique | Fort | Un champ manque |
| Séparer la décision de sa délibération | Moyen | Une frontière à écrire, pas de champ |
| La capture doit être un produit dérivé | Moyen | Une méthodologie, pas une définition |
| Le consensus est l'absence d'objection non traitée | Moyen | Fonde une règle de clôture |
| La charge est la cause d'abandon | **Contraignant** | Limite ce que les six autres peuvent coûter |

Le dernier est en tension avec les deux « fort » : ils ajoutent des champs, il dit que les champs tuent l'adoption. Cette tension est réelle et ne se dissout pas. Elle est arbitrée ci-dessous et l'arbitrage est porté par une objection plutôt que caché.

## Le défaut principal de RES-009

`RES-009` traite le changement d'une décision par un champ `effet` à cinq valeurs, dont `remplacee`. La littérature établit deux choses qui condamnent ce mécanisme.

Konishi le dit directement : dans un fichier markdown, « remplacé » signifie que quelqu'un se souvient de mettre à jour le champ de statut, ce que personne ne fait. La source est un billet technique et `FND-003` la signale comme secondaire, mais elle est corroborée par l'étude d'adoption de Rösch et al., et surtout elle décrit exactement ce que `ANL-001` a déjà mesuré dans ce corpus : `completed` dans cinquante-deux logs et `complet` dans deux du même dépôt. Un champ tenu à la main dérive. C'est un fait établi sur ce corpus, pas seulement une affirmation empruntée.

Le droit fournit l'alternative, et `FND-003` la formule ainsi : **un état se met à jour ou s'oublie ; un acte laisse une trace même s'il est incomplet.**

La correction retenue est donc : un revirement ne se fait pas en éditant le champ `effet` de l'ancienne décision, mais en produisant une nouvelle `DCN` qui déclare `remplace` et qui **motive** le changement. Le champ `effet` de l'ancienne devient une conséquence dérivable de l'existence de cette nouvelle `DCN`, donc vérifiable par machine, et non une information à tenir.

C'est exactement le mouvement que `ADR-003` D7 prescrit déjà pour la couche machine-lisible : dérivée, jamais écrite. La correction ne fait qu'appliquer un principe que le dépôt s'est donné.

## L'arbitrage sur les deux champs ajoutés

Deux champs manquent, `attestation` et `diffusion`. Les ajouter porte `RES-009` de neuf à onze champs obligatoires, alors que l'apport 7 identifie la charge comme la cause d'abandon mesurée.

Trois positions étaient possibles.

**Ne rien ajouter**, au nom de la charge. Écarté : `FND-003` établit que l'authenticité est le cinquième élément exigé par l'archivistique et négligé partout ailleurs, et que le facteur politique est réel et sans solution technique. Une décision enregistrée sans son régime de diffusion est ce que `RES-005` nomme une fuite en attente.

**Ajouter les deux comme obligatoires.** Retenu, avec deux atténuations : les deux champs sont énumérés et courts, donc leur coût de saisie est d'un mot chacun, et les deux ont une valeur par défaut évidente pour une décision interne, `interne` et `public`.

**Ajouter les deux comme facultatifs.** Écarté : un champ facultatif sur un régime de confidentialité produit exactement le silence qu'il devrait interdire. Le champ `diffusion` de `RES-005` est obligatoire pour cette raison, et il n'y a pas de raison qu'une décision soit moins exposée qu'un fait.

La tension avec l'apport 7 subsiste. Elle est portée par `NON-022` avec le compte exact des champs, plutôt que déclarée résolue.

## Ce qui va dans la définition et ce qui va dans la méthodologie

La question s'est posée pour trois apports, et la frontière retenue suit `RES-013` : une définition dit ce qu'est une ressource valide, une méthodologie dit comment conduire le travail.

| Apport | Où il va | Pourquoi |
|---|---|---|
| Séparer la décision de sa délibération | `RES-009`, section « Ce qu'une décision n'est pas » | C'est une frontière de type |
| Le changement est un acte | `RES-009` pour la règle, `MET-002` pour le procédé | La règle contraint la validité, le procédé décrit les gestes |
| La capture est un produit dérivé | `MET-002` seulement | C'est une manière de travailler, pas un critère de validité |
| Le consensus est l'absence d'objection | `MET-002` seulement | C'est une règle de clôture, elle relève du procédé |
| L'authenticité attestée | `RES-009` pour le champ, `MET-002` pour la vérification | Le champ est structurel, la vérification est un geste |

## Le risque principal de cette tâche

Produire une définition et une méthodologie plus longues et plus exigeantes, dans une session qui a déjà produit quatre règles écrites et non tenues, recensées par `next-task-13.yaml` et contestées par `NON-005` depuis le 2026-08-09.

`MET-002` doit donc être écrite avec cette contrainte : **aucune règle qu'un contrôle ne puisse vérifier, ou alors la règle déclare qu'elle n'est pas outillée.** Chaque étape du procédé porte, quand elle existe, la vérification correspondante.

## Les deux corrections à FND-003

La relecture en trouve deux, toutes deux internes au document, ce qui les rend vérifiables sans consulter les sources.

**Les chiffres de la section « Limites » contredisent l'étape 10.** L'étape 10 mesure 6,4 sources par question et 1,8 page par question ; la section « Limites » écrit 4,8 et « une page ». L'étape 10 est la mesure, la section « Limites » en est le report, donc c'est le report qui est faux.

**La limite sur la source fondatrice contredit l'étape 9.** La section « Limites » écrit que le billet de Nygard de 2011 est cité par une source secondaire ; l'étape 9 relate que l'archive du web l'a rendu consultable directement et que sa lecture a produit une section entière. La bibliographie, entrée 6, porte « consultée directement ». La limite est un vestige de rédaction, antérieure à l'étape 9.

Ces corrections ne touchent aucune affirmation sourcée, seulement la cohérence interne du document avec ses propres mesures.

## Ce que cette tâche ne fera pas

Elle ne répond à aucune question de `NON-019`, qui appartiennent à l'humain.

Elle ne change pas le `status` de `FND-003`, qui reste `draft` : aucune approbation humaine n'a eu lieu.

Elle n'ajoute pas de contrôle outillé dans `clia`. La vérification du champ `effet` dérivable est spécifiée dans `MET-002` et signalée comme non outillée, ce qui la place dans la dette nommée plutôt que dans les règles tenues.
