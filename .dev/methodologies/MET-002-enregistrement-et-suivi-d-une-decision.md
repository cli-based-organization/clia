---
type: methodologie
id: MET-002
title: "Enregistrement et suivi d'une décision"
version: 0.1.0
status: draft
maturity: conception
adoption: propose
activated: true
domaine: "traçabilité des décisions qui contraignent le travail"
---

# MET-002 - Enregistrement et suivi d'une décision

> Comment enregistrer une décision, comment la changer, et comment vérifier qu'elle est fidèle. Ce document est dérivé de `FND-003`, qui établit que le mécanisme le plus répandu, le champ de statut, n'est pas tenu, et que le seul mécanisme robuste connu est l'acte motivé.

## Objet

Cette méthodologie fixe le procédé de travail avec le type `decision`, `RES-009`.

Elle est la réponse à la partie de la tâche 14 que l'énoncé désigne comme principale : « afin d'enrichir la ressource DCN et, **surtout**, nos méthodologies de travail avec cette ressource ».

`RES-009` dit ce qu'est une `DCN` valide. Ce document dit comment on en produit une, comment on la change, et à quoi on reconnaît que le travail a échoué.

## Ce que la fondation impose à ce procédé

Trois résultats de `FND-003` contraignent tout ce qui suit. Ils sont énoncés ici pour que le procédé se lise comme une conséquence et non comme une préférence.

**La capture qui interrompt échoue.** Horner et Atwood analysent trente-cinq ans de tentatives de capture du raisonnement décisionnel et concluent que l'intrusion est le facteur décisif : intégrer la capture au travail rendrait le raisonnement un produit dérivé de l'activité, et réduirait l'intrusion. Le procédé ci-dessous est donc bâti sur la dérivation, jamais sur la saisie dédiée.

**Le champ de statut n'est pas tenu.** C'est pourquoi l'étape 6 remplace la mise à jour d'un état par la production d'un acte.

**Le consensus est l'absence d'objection technique non traitée, non l'accord d'une majorité.** RFC 7282 le pose, et note que l'IETF elle-même s'en éloigne. C'est la règle de clôture de l'étape 8, et elle correspond au dispositif d'objection que `clia` possède déjà.

## Quand l'employer

**À employer** dès qu'une décision contraint le travail et qu'elle n'est pas décidée dans le dépôt : un texte réglementaire, un contrat, une délibération d'instance, un arbitrage de l'humain sur le cap du système.

**À employer aussi** lorsqu'un ADR est accepté : la `DCN` correspondante est produite par dérivation, voir l'étape 3.

**À ne pas employer** dans quatre cas, qui sont ceux où un autre type convient mieux.

| Situation | Type qui convient |
|---|---|
| Le dépôt décide lui-même d'une architecture | `ADR`, et la `DCN` suit si la décision est actée |
| L'énoncé est vérifiable et non voulu | `FCT` |
| L'énoncé est un but poursuivi, non une contrainte acquise | `INT` |
| Le matériau est un texte capté dont on ne sait pas encore quoi faire | `FRG` |

**Cas fréquent et mal tranché :** l'humain répond à une objection. La réponse écrite dans l'objection suffit tant qu'elle ne change pas une décision antérieure. Dès qu'un cap est modifié, une `DCN` est requise. La frontière est contestée par `NON-015`.

## Le procédé

Neuf étapes. Les étapes 1 à 5 produisent l'enregistrement, l'étape 6 le change, les étapes 7 à 9 le vérifient et le closent.

Chaque étape porte, quand il existe, le **contrôle** qui permet de vérifier qu'elle a été faite. Quand aucun contrôle n'existe, l'étape le déclare : c'est une exigence de cette méthodologie, parce que le dépôt accumule des règles écrites et non tenues, ce que `NON-005` conteste depuis le 2026-08-09.

### 1. Vérifier qu'une décision a bien été prise

Trois questions, dans cet ordre.

**Quelqu'un a-t-il décidé ?** Une orientation, un consensus mou, une préférence exprimée ne sont pas des décisions. S'il n'y a pas d'acte, il n'y a pas de `DCN`.

**Cette personne ou cette instance en avait-elle le pouvoir ?** Sinon, l'enregistrement fabrique une autorité qui n'existe pas. C'est le mode d'échec le plus grave de ce type.

**La décision contraint-elle le travail ?** Une décision sans portée sur le dépôt n'a pas à y entrer.

*Contrôle :* aucun automatique. C'est un jugement, et il appartient à l'humain lorsqu'un doute subsiste.

### 2. Séparer le dispositif de la délibération

Le dispositif est ce qui a été décidé. La délibération est le chemin qui y a mené.

Seul le dispositif entre dans la `DCN`. La délibération, quand elle mérite d'être conservée, va dans un ADR, une objection ou un fragment, qui portent chacun leur propre régime de diffusion.

Le motif est établi par `FND-003` : confondre les deux force un régime de diffusion unique, et le plus restrictif l'emporte toujours. La décision, qui devrait être opposable, devient alors aussi confidentielle que ce qui l'a précédée.

*Contrôle :* relire la section « La décision » et vérifier qu'aucune phrase n'y commence par « après avoir considéré », « il a été débattu que », ou une formule équivalente. La délibération se reconnaît à sa forme narrative.

### 3. Produire l'enregistrement par dérivation

C'est l'étape qui rend le procédé soutenable, et elle vient directement du résultat central de `FND-003` : ce qui échoue n'est pas la capture, c'est la capture qui interrompt.

Une `DCN` n'est presque jamais saisie de zéro. Quatre sources de dérivation, par ordre de fréquence attendue.

| Source | Ce qu'on en tire | Ce qu'on n'en tire pas |
|---|---|---|
| Un **ADR** accepté | Le dispositif, la date, les conséquences | Les alternatives écartées, les portes de sortie : c'est de la délibération |
| Une **objection** tranchée | Le dispositif, l'instance, la date de la réponse | L'argumentation de l'objection |
| Un **fragment** capté | La teneur, quand l'humain y a formulé un arbitrage | Le reste du fragment |
| Un **document externe** | Le dispositif, cité, et son renvoi | La reformulation, qui est interdite |

La `DCN` déclare alors `derive-de` vers sa source. Le coût de production tombe à la mise en forme, ce qui est le seul régime que la littérature donne pour soutenable.

*Contrôle :* toute `DCN` dont la relation `derive-de` est absente doit justifier, dans « Qui a décidé », pourquoi elle n'a pas de source dérivable.

### 4. Consigner les six éléments

`RES-009` en exige six : la décision, l'instance, la date, la portée, les conséquences, l'attestation.

Les cinq premiers font consensus dans la littérature. Le sixième est celui qu'on oublie, et il commande la façon de rédiger « Qui a décidé ».

| `attestation` | Ce que « Qui a décidé » doit alors porter |
|---|---|
| `interne` | Le renvoi vers la trace dans le dépôt : session, objection, ADR, commit |
| `source-primaire` | Le renvoi vers le document consulté, avec la date de consultation |
| `source-rapportee` | L'intermédiaire, nommé, et la mention explicite du caractère rapporté |
| `temoignage` | Qui témoigne, et quand |

Une décision `source-rapportee` reste citable. Elle ne peut jamais être présentée comme établie, exactement comme une source secondaire dans `MET-001`.

*Contrôle :* la validation de schéma vérifie la présence et l'énumération. Elle ne vérifie pas que la section « Qui a décidé » porte ce que la valeur exige : ce contrôle est manuel.

### 5. Déclarer la diffusion, et écrire les silences

Deux gestes que rien ne rappellera si on les oublie.

**La diffusion** est `public`, `prive` ou `confidentiel`. Elle appartient à l'humain. Un agent ne l'assigne jamais autrement qu'en reprenant celle de la source, et signale le cas dans « Ce que la décision ne dit pas ».

**Les silences** vont dans la rubrique « Ce que la décision ne dit pas ». Une décision enregistrée sans ses silences se lit comme plus large qu'elle n'est. Trois questions à se poser : sur quoi ne se prononce-t-elle pas, quelles conséquences n'a-t-elle pas tranchées, et qu'est-ce qui a été volontairement laissé ouvert ?

*Contrôle :* les deux rubriques sont dans la liste `sections` de `RES-009`, donc leur absence est détectable par comparaison entre le fichier et la définition.

### 6. Changer une décision : produire un acte, jamais éditer un état

C'est l'étape la plus importante de ce procédé, et celle que la littérature établit le plus solidement.

**Ce qu'il ne faut pas faire.** Ouvrir la `DCN` existante et passer son `effet` à `remplacee`. C'est ce que le premier jet de `RES-009` prescrivait, et `FND-003` établit que ce geste n'est pas tenu : dans un fichier markdown, « remplacé » signifie que quelqu'un se souvient de mettre à jour le champ, ce que personne ne fait.

**Ce qu'il faut faire.** Quatre gestes, dans cet ordre.

1. Produire une **nouvelle `DCN`**, avec son propre numéro.
2. Y déclarer la relation `remplace` vers l'ancienne.
3. Remplir la section **« Motivation du changement »** : ce que la décision antérieure tenait pour acquis et qui ne l'est plus. C'est la *special justification* du droit du précédent, transposée. Une nouvelle décision qui ne dit pas pourquoi l'ancienne ne tient plus est un revirement subi, non décidé.
4. Reporter `effet: remplacee` sur l'ancienne, en sachant que ce report est **dérivable** et non porteur d'information.

Le quatrième geste est celui qu'on oublie, et c'est pourquoi il ne porte rien : une décision est remplacée si et seulement si une autre déclare `remplace` vers elle. Le champ est le report d'un fait lisible ailleurs.

*Contrôle, spécifié et non outillé.* Pour chaque `DCN` du dépôt, l'ensemble des cibles des relations `remplace` doit être exactement l'ensemble des `DCN` portant `effet: remplacee`. Une différence dans un sens signale un report oublié ; dans l'autre, un `effet` posé à la main sans acte correspondant.

Ce contrôle n'existe dans aucun outil au 2026-08-10. Il est écrit ici en toutes lettres pour être implémentable sans relire `RES-009`, et il est compté dans la dette de `NON-022`.

### 7. Vérifier la fidélité

Aucun domaine consulté par `FND-003` ne garantit la fidélité par un mécanisme technique. Tous emploient une procédure. Celle-ci en est une, et elle est modeste.

**Pour une décision externe.** Relire la section « La décision » en regard de la source, et vérifier qu'aucune phrase n'a été reformulée. Le doute se tranche en citant plutôt qu'en résumant.

**Pour une décision interne.** Vérifier que la trace existe et qu'elle dit bien ce que la `DCN` lui fait dire. Une `DCN` `interne` dont le renvoi pointe vers un fichier qui ne contient pas la décision est une fabrication d'autorité, même involontaire.

**Dans les deux cas.** Vérifier que la date est celle de la décision et non celle de l'enregistrement. C'est la confusion la plus commune, et elle rend la chronologie du dépôt fausse.

*Contrôle :* manuel. Il peut être fait par un agent, mais son résultat doit être consigné, sans quoi il n'a pas eu lieu.

### 8. Clore par l'absence d'objection, non par l'accord

RFC 7282 pose que le consensus est l'absence d'objection technique non traitée, et non l'accord d'une majorité. `FND-003` relève que c'est la distinction que Kunz et Rittel formulaient déjà en 1970, en séparant la question réglée en convainquant les opposants de la question tranchée par une procédure formelle.

Transposé ici : une `DCN` est acquise quand aucune objection bloquante ne porte sur elle. Elle n'a pas besoin d'être approuvée par tous ; elle a besoin qu'aucune objection ne reste sans réponse.

Le dispositif existe déjà dans le dépôt : `RES-004` distingue les effets `bloquant` et `conditionnel`. Cette étape ne fait que le raccorder au type `decision`.

*Contrôle :* lister les objections dont le champ `porte-sur` contient l'identifiant de la `DCN`, et vérifier qu'aucune n'a `effet: bloquant` et `etat: ouverte`.

### 9. Constater les conséquences, plus tard

Une `DCN` est vivante par ses conséquences, non par sa teneur. La section « Conséquences » s'enrichit en append, par les deux agents, à mesure que la décision produit ses effets.

C'est la seule partie du document qu'un agent peut modifier après coup sans autorisation. Il ne modifie jamais la teneur.

*Contrôle :* aucun. C'est un geste opportuniste, à faire quand une conséquence se manifeste, pas une tâche à planifier.

## Ce qui peut échouer

Sept modes d'échec. Les quatre premiers sont attestés par `FND-003`, les trois derniers sont propres à ce dépôt et mesurés par `ANL-001`.

**Le statut n'est jamais mis à jour.** Signe : des `DCN` que d'autres remplacent et qui portent encore `en-vigueur`. C'est le mode d'échec dominant du domaine, et l'étape 6 existe pour lui.

**La charge fait abandonner.** Signe : le type cesse d'être employé, ou les `DCN` s'arrêtent à quelques unités. Rösch et al. mesurent qu'environ la moitié des dépôts observés en restent à cinq enregistrements. Ce dépôt en compte sept, ce qui le place exactement dans cette zone.

**Le raisonnement enregistré expose son auteur.** Signe : une réticence à écrire, ou des `DCN` vagues sur l'instance. C'est un fait organisationnel, sans solution technique. La seule contre-mesure disponible est le champ `diffusion`, et elle est partielle.

**L'enregistrement n'est jamais relu.** Signe : aucun. C'est le mode d'échec le plus inquiétant, parce que `FND-003` établit qu'aucune source ne mesure la relecture, alors que tous les domaines justifient l'enregistrement par un usage futur. L'axe reste vide dans la littérature ; il l'est aussi ici.

**On enregistre une décision qui n'a pas été prise.** Signe : une `instance` vague, du type « il a été convenu ». L'étape 1 existe pour cela. Le dépôt en porte déjà trois cas assumés, `DCN-003` à `DCN-005`, dont l'instance vaut « aucune : décision non actée » et l'effet `proposee`. C'est la bonne conduite : l'absence d'acte est déclarée plutôt que masquée.

**On reformule la teneur.** Signe : une `DCN` externe plus claire que sa source. C'est le piège de la famille contenu, décrit par `skl-004` : améliorer ce qu'on capte détruit la valeur de ce qu'on capte.

**On confond la décision et l'ADR.** Signe : une `DCN` qui porte des alternatives écartées. Un ADR décide, une `DCN` constate.

## Éprouvé sur

Cette méthodologie est écrite le 2026-08-10 et n'a jamais été employée pour produire une `DCN`. Elle est rétro-appliquée aux sept que le dépôt possède, ce qui est une épreuve faible mais réelle.

| Cas | Ce que la rétro-application montre |
|---|---|
| `DCN-001`, `DCN-002` | Dérivées d'ADR, conformes à l'étape 3. Attestation `interne`, renvoi présent |
| `DCN-003` à `DCN-005` | `effet: proposee`, instance « aucune : décision non actée ». L'étape 1 est respectée par anticipation : l'absence d'acte est déclarée |
| `DCN-006` | Dérivée de la tâche 10, conforme |
| `DCN-007` | Le meilleur cas du dépôt. Elle dérive d'un fragment, `FRG-001`, cite la phrase de l'humain qui porte la prémisse, déclare `repond-a` vers `NON-001`, et sa rubrique de silences porte quatre points qui ont directement produit `NON-019` |
| **Aucune** | L'étape 6 n'a jamais été éprouvée : aucune `DCN` n'en remplace une autre. Le mécanisme central de cette méthodologie est donc non testé |

**Ce que l'épreuve établit, et ce qu'elle n'établit pas.** Les étapes 1 à 5 décrivent ce que le dépôt fait déjà, ce qui est un bon signe pour leur applicabilité et un mauvais signe pour leur nouveauté. L'étape 6, qui est l'apport, ne repose sur aucun cas. Sa validité reste à établir au premier revirement, et c'est à ce moment qu'il faudra relire ce document.

## Relations

- `derive-de` [FND-003](../fondations/FND-003-decisions-institutionnelles-tracables.md)
- `specifie` [RES-009](../ressources/RES-009-decision.md)
- `reference` [MET-001](MET-001-recherche-de-fondation.md)
- `reference` [RES-004](../ressources/RES-004-objection.md)
- `reference` [skl-004-ressource-de-contenu](../skills/skl-004-ressource-de-contenu/SKILL.md)
