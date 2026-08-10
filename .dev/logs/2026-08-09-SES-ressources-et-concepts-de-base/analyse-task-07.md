# Analyse préalable, tâche 7

## Ce que la méthodologie imposée change

La demande impose une revue de la littérature avec référence après chaque affirmation. Cette contrainte a un effet que je n'anticipais pas : elle interdit les affirmations que je crois vraies sans pouvoir les rattacher.

Trois passages ont été retirés en cours de rédaction faute de source. Une comparaison des coûts de gouvernance entre registres. Une affirmation sur l'échec des identifiants persistants dans le temps long. Une généralisation sur la lisibilité des identifiants courts. Toutes trois étaient plausibles et aucune n'était sourçable.

L'effet secondaire est que les lacunes de la littérature deviennent visibles au lieu d'être comblées par du raisonnement présenté comme du savoir. La plus importante est nommée à l'étape 6 : personne n'étudie l'ergonomie de saisie des identifiants, alors que c'est la première exigence de la demande.

## L'ordre des sept étapes n'est pas cosmétique

Poser les questions de recherche avant de mobiliser les domaines a produit une différence concrète. La question QR8, sur la traversée de la frontière interne vers externe, n'était dans aucun de mes domaines de départ. Elle a fait chercher dans deux directions inattendues, l'indirection de l'ARK et la structure en qualificateurs du SWHID, et c'est de là que vient la proposition la plus utile du document.

L'inventaire sémantique, étape 2, a aussi eu un effet mesurable : il a fait apparaître que trois distinctions du champ, nom contre localisateur, intrinsèque contre extrinsèque, oeuvre contre manifestation, suffisent à structurer les huit questions. Sans cette étape, j'aurais traité chaque question isolément.

## Les trois résultats que la revue apporte, et que je n'avais pas

**Le trilemme est le cadre, et il tient.** Le triangle de Zooko énonce exactement la contrainte que pose la première exigence de la demande : lisible, unique, sans autorité, deux sur trois. Sa réfutation présumée par les systèmes fondés sur des chaînes de blocs repose sur une source encyclopédique et suppose un consensus coûteux. Pour un système à un acteur, la position prudente est que le trilemme tient.

**Il n'existe pas d'identifiant unique satisfaisant, et les systèmes qui marchent portent une famille.** Le SWHID le montre en un seul objet : un coeur intrinsèque, plus des qualificateurs extrinsèques. Software Heritage conclut explicitement à la complémentarité de l'intrinsèque et de l'extrinsèque. C'est la réponse à QR2, et elle rend inutile la recherche de la forme parfaite.

**La traversée de frontière se fait par extension, jamais par remplacement.** Deux mécanismes attestés le montrent, et aucun n'a été conçu pour cette question. C'est ce qui rend la proposition sûre : un renvoi déjà écrit ne casse pas.

## Ce que l'analyse a fait de ces résultats

`ANL-003` place `clia` sur les quatorze axes et le résultat est net : cinq positions justes, six indéterminées, trois fausses. Les trois fausses, la portée d'unicité, la granularité et la vérifiabilité, sont exactement celles qui empêchent la réutilisation hors du dépôt.

Deux décisions de méthode ont guidé les suggestions.

**Protéger ce qui marche avant d'améliorer ce qui manque.** La lisibilité et l'ergonomie sont les deux seuls axes où `clia` fait mieux que les systèmes de la littérature, et chaque amélioration d'unicité les menace. La suggestion S8 propose d'écrire l'ergonomie comme exigence, précisément parce qu'une exigence non écrite perd tous les arbitrages.

**Classer les suggestions par rapport entre effet et coût, non par importance théorique.** Les cinq premières ne demandent aucun code et règlent trois questions ouvertes. Les cinq suivantes sont soit différées, soit déjà décidées.

## Pourquoi une objection nouvelle plutôt que des questions ajoutées

La demande dit de compléter les objections existantes et d'en ouvrir de nouvelles au besoin. Dix questions ont été ajoutées à trois objections existantes, ce qui est le geste le moins coûteux et il couvre l'essentiel.

Une objection nouvelle était néanmoins nécessaire, et pour une raison de fond : `NON-014` ne porte pas sur une question de conception mais sur un **choix non fait**. Le système a abandonné l'unicité globale par construction, personne ne l'a décidé, et l'`INTENTION.md` promet ce que cet abandon rend impossible. Aucune objection existante ne pouvait accueillir cela sans changer d'objet.

Son effet est déclaré `bloquant` parce que les dix suggestions de `ANL-003` ne peuvent pas être arbitrées sans savoir quelle propriété le système accepte de perdre.

## L'incident de numérotation, et ce qu'il vaut

En déposant l'objection, `clia` lui a attribué le numéro 013, déjà pris par une objection que l'humain avait créée la veille avec le même outil. Le fichier n'étant pas commité, il n'était pas dans l'état que j'avais relevé.

C'est la collision que la question Q7 de `NON-001` annonçait, survenue moins de vingt-quatre heures après avoir été posée, et dans les conditions exactes qu'elle décrivait : deux travaux avançant en parallèle.

Trois choses méritent d'être notées.

**L'outil n'a pas échoué.** `clia res new` a pris le maximum plus un, correctement. Le défaut est que le numéro s'obtient par observation d'un état, et qu'un état observé deux fois donne deux résultats.

**La résolution a suivi le régime d'édition, pas la chronologie de production.** L'objection de l'humain est conservée parce qu'il en est l'initiateur, et `RES-004` pose qu'aucune partie ne réécrit les blocs de l'autre. J'ai renuméroté la mienne.

**L'incident renforce Q1 plus que Q7.** Une identité fondée sur le slug n'aurait pas collisionné : les deux objections portent sur des sujets distincts, donc sur des slugs distincts. La collision ne concerne que le numéro, ce qui est exactement l'argument de la distinction entre adresse et identité.

## Ce qui a été refusé

Toute décision. La demande demande une recherche, une analyse et des objections. Les dix suggestions sont des suggestions.

Toute modification de `RES-001` et de `ADR-001`, que plusieurs suggestions visent. Les cinq premières suggestions consistent précisément à écrire dans ces documents ; les écrire maintenant aurait tranché à la place de l'humain.

Toute modification du `NON-013` de l'humain, y compris pour le rédiger. Il porte « À rédiger » et son initiateur est l'humain.

Un ADR sur le système d'identifiants. Il viendra quand `NON-014` Q1 et Q3 auront reçu réponse, et il aura alors quelque chose à acter.
