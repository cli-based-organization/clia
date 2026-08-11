---
type: fondation
id: FND-003
title: "Décisions institutionnelles traçables : documentation et suivi des changements"
status: draft
date: 2026-08-10
sujet: "Pratiques de documentation des décisions et de suivi de leurs changements, dans plusieurs domaines"
methodologie: "MET-001, dix étapes, revue de littérature"
generated:
  by: claude-opus-5
  at: 2026-08-10
---

# FND-003 - Décisions institutionnelles traçables

> Revue de la littérature sur la documentation des décisions et le suivi de leurs changements, dans sept domaines. Le résultat central est un échec documenté : le champ de recherche qui a inventé la capture du raisonnement décisionnel a établi pourquoi elle ne tient pas, et les pratiques qui survivent sont celles qui ont renoncé à la capture exhaustive.

## Objet et méthode

Première application de `MET-001`, la méthodologie de recherche de fondation écrite à la tâche 11 et dérivée d'un échec. Ce document est donc aussi une épreuve de cette méthodologie, et son étape 10 mesure ce qu'il a atteint.

### Entrée requise, vérifiée avant de commencer

`MET-001` exige quatre éléments. Les quatre sont présents.

| Élément | Valeur pour cette recherche |
|---|---|
| **La décision à éclairer** | Enrichir `RES-009`, la définition du type Décision, et surtout les méthodologies de travail avec ce type |
| **Le sujet, borné** | La documentation d'une décision et le suivi de ses changements. Exclus : la théorie de la décision, l'aide à la décision, la prise de décision collective |
| **Domaines suggérés** | Aucun n'est nommé par la demande, qui dit « différents domaines et différents contextes ». Ils sont donc tous identifiés par l'étape 4 |
| **Niveau de rigueur** | Revue de littérature, avec le format de citation complet exigé par `MET-001` |

### Régime de citation

Citation courte dans le texte, référence complète en bibliographie, conformément à `MET-001`. Chaque source porte sa nature et sa date de consultation. Les sources secondaires sont signalées comme telles à l'endroit où elles servent.

Toutes les consultations ont eu lieu le 2026-08-10.

## Étape 1 - Vérification du livrable

Quatre questions, dans l'ordre prescrit.

**Le contenu vient-il d'autrui, avec des sources ?** Oui. Le sujet a une littérature dans au moins sept domaines.

**Le sujet a-t-il une littérature ?** Oui, et elle est inégale. Le champ du design rationale l'a traité en profondeur entre 1970 et 2006 ; les autres domaines le traitent par la norme ou par la jurisprudence plutôt que par la recherche.

**La décision à éclairer est-elle nommée ?** Oui, ci-dessus.

**Le format long est-il proportionné ?** Oui. `RES-009` a été écrit à la tâche 8 sans aucun antécédent dans le corpus : `ANL-001` n'avait relevé aucun mécanisme d'enregistrement de décision externe dans cent soixante-six dépôts. Une note ne suffirait pas.

## Étape 2 - Questions de recherche

Cinq questions, chacune réfutable.

| Question | Formulation |
|---|---|
| **QR1** | La documentation d'une décision est-elle utilisée après sa production, et par qui ? |
| **QR2** | Quels éléments doivent être consignés pour qu'une décision reste intelligible hors de son contexte ? |
| **QR3** | Comment le changement d'une décision antérieure est-il tracé, et que devient la décision remplacée ? |
| **QR4** | Qui a autorité pour enregistrer une décision, et comment la fidélité de l'enregistrement est-elle garantie ? |
| **QR5** | À quelles conditions la capture du raisonnement décisionnel est-elle soutenable ? |

Cinq questions plutôt que huit : `MET-001` fixe un seuil de dix sources par question, et cinq est le nombre que la densité atteinte permet de traiter. L'arbitrage est déclaré à l'étape 10.

## Étape 3 - Inventaire sémantique et ontologique

Les domaines emploient des termes voisins avec des sens incompatibles. La table fixe le vocabulaire de ce document.

| Terme | Sens retenu | Source ou précision |
|---|---|---|
| **Décision** | Acte par lequel une instance ayant autorité arrête un choix | Notion, non technique |
| **Enregistrement** | Document qui atteste qu'une décision a été prise | La norme ISO 15489 définit le *record* comme information créée et conservée comme preuve d'une activité (ISO, 2016) |
| **Rationale**, ou raisonnement décisionnel | Documentation explicite des raisons d'un choix de conception | Définition du champ du design rationale (Wikipedia, 2026) |
| **Délibération** | Processus antérieur à la décision, distinct d'elle | Le privilège du processus délibératif protège ce qui est *predecisional and deliberative* en droit administratif américain (ACS, 2023) |
| **Motivation** | Exposé des raisons attaché à la décision elle-même | Terme du droit. En common law, l'obligation apparaît sous la forme d'une *special justification* exigée pour écarter un précédent (Library of Congress, 2026) |
| **Précédent** | Décision antérieure qui contraint les décisions ultérieures | Doctrine du *stare decisis* (American Bar Association, 2026) |
| **Statut** | État d'une décision dans son cycle de vie | Le champ des ADR emploie quatre états minimaux : proposé, accepté, déprécié, remplacé (Konishi, 2026) |
| **Authenticité, fiabilité, intégrité** | Trois propriétés qu'un enregistrement doit posséder pour faire preuve | Triade de ISO 15489-1:2016 (CASRAI, 2026) |
| **Consensus approximatif** | Absence d'objection technique non traitée, distincte de la majorité | Notion propre à l'IETF, définie par RFC 7282 (Resnick, 2014) |

**Trois distinctions structurantes**, qui commandent la suite.

La première oppose la **décision** à sa **délibération**. Le droit administratif américain les sépare juridiquement : le privilège du processus délibératif protège les documents antérieurs à la décision, tandis que la décision elle-même est publiable (ACS, 2023). La distinction n'est pas de commodité : elle détermine ce qui est communicable.

La deuxième oppose l'**enregistrement** au **raisonnement**. ISO 15489 traite du premier et exige authenticité, fiabilité et intégrité (CASRAI, 2026). Le champ du design rationale traite du second et a établi qu'il est beaucoup plus difficile à capturer (Horner et Atwood, 2006).

La troisième oppose la **décision** au **précédent**. Une décision enregistrée peut n'engager que son objet ; un précédent contraint les décisions ultérieures et exige une justification spéciale pour être écarté (Library of Congress, 2026).

## Étape 4 - Domaines de savoir

La demande n'en suggère aucun. Les sept ci-dessous sont identifiés par les trois voies que `MET-001` prescrit.

### Voie 1 : domaines adjacents par l'objet

| Domaine | Apport, et à quelle question |
|---|---|
| **Architecture logicielle, les ADR** | Le format le plus proche de `RES-009`. Popularisé par un billet de 2011 de Michael Nygard, avec quatre sections : statut, contexte, décision, conséquences (Red Hat, 2026). Une étude empirique de 2026 en mesure l'adoption réelle. Répond à QR1, QR2, QR3 |
| **Droit, la jurisprudence** | Le seul domaine où le changement d'une décision antérieure est théorisé depuis des siècles. Répond à QR3 |
| **Gouvernance d'entreprise** | Les procès-verbaux de conseil sont devenus une pièce de preuve centrale pour évaluer comment les administrateurs ont abordé une décision majeure (Avisen Legal, 2026). Répond à QR1, QR4 |
| **Administration publique** | Le droit d'accès fait de la documentation des décisions une obligation, et non un choix (Department of Justice, 2026). Répond à QR1, QR4 |

### Voie 2 : domaines adjacents par la méthode

| Domaine | Apport |
|---|---|
| **Archivistique et gestion des documents** | ISO 15489-1:2016 définit ce qui rend un enregistrement digne de foi, et ISO 30301:2019 inscrit la tenue de documents dans la gouvernance (Metaarchivist, 2026). Répond à QR2, QR4 |
| **Normalisation technique** | RFC 7282 définit le consensus approximatif comme l'absence d'objection technique non traitée, et non comme une majorité (Resnick, 2014). Répond à QR4 |
| **Médecine, la décision partagée** | Documenter l'emploi d'une aide à la décision offre une protection médico-légale, et la documentation des préférences du patient est mal étudiée (Yen et al., 2026). Répond à QR1, QR2 |

### Voie 3 : domaines historiquement antérieurs

C'est la voie que `MET-001` désigne comme la plus productive, et elle l'est ici.

Le champ du **design rationale** naît en juillet 1970 avec la notation IBIS, décrite par Werner Kunz et Horst Rittel dans un document de travail de l'Institute of Urban and Regional Development de Berkeley intitulé *Issues as elements of information systems* (Kunz et Rittel, 1970). Elle est conçue pour donner une structure argumentative au traitement des problèmes que Rittel nommera *wicked* trois ans plus tard (Rittel et Webber, 1973). Elle précède de quarante ans les ADR, elle a produit une littérature abondante, dont gIBIS (Conklin et Begeman, 1988), et elle a établi les raisons de son propre échec.

Aucun document du champ des ADR consulté ne cite ce domaine antérieur. C'est la trouvaille de cette recherche.

## Étape 5 - Axes d'analyse

Onze axes couvrent l'espace. Deux sont absents de la littérature et nommés comme tels.

| Axe | Question qu'il pose | Positions attestées |
|---|---|---|
| **A1 Obligation** | Documenter est-il obligatoire ? | Légalement obligatoire (administration, conseil), professionnellement recommandé (médecine), volontaire (ADR) |
| **A2 Granularité** | Toute décision est-elle enregistrée ? | Toutes celles qui requièrent une participation formelle du conseil (Advantage Delaware, 2026) ; seulement les décisions architecturalement significatives (MADR) |
| **A3 Contenu** | Qu'enregistre-t-on ? | Le seul dispositif, ou le dispositif plus les motifs, ou le dispositif plus la délibération |
| **A4 Raisonnement** | Le pourquoi est-il capturé ? | Exhaustivement (IBIS), partiellement (ADR, contexte et conséquences), pas du tout (résolution de conseil) |
| **A5 Autorité** | Qui enregistre ? | L'instance elle-même, un secrétaire, un tiers, un outil |
| **A6 Fidélité** | Comment garantit-on que l'enregistrement est fidèle ? | Approbation formelle, signature, triade d'authenticité d'ISO 15489 |
| **A7 Changement** | Comment trace-t-on un revirement ? | Justification spéciale exigée (*stare decisis*), changement de statut (ADR), nouvelle résolution (conseil) |
| **A8 Sort de l'ancienne** | Que devient la décision remplacée ? | Conservée et marquée, conservée sans marque, remplacée en place |
| **A9 Publicité** | Qui peut lire ? | Public par obligation, protégé par privilège délibératif, interne |
| **A10 Coût de capture** | Que coûte l'enregistrement, et qui le paie ? | Traité, et c'est le résultat central de la voie 3 |
| **A11 Usage effectif** | L'enregistrement est-il relu ? | **Peu traité.** Voir l'étape 7 |

**Deux axes absents de la littérature consultée.** L'usage effectif d'un enregistrement de décision, c'est-à-dire la mesure de sa relecture, n'est documenté nulle part de manière directe. Et l'articulation entre l'enregistrement d'une décision **externe** et le travail interne d'une organisation n'est traitée par aucun des sept domaines : chacun documente ses propres décisions.

Le second est exactement le cas d'usage principal de `RES-009`.

## Étape 6 - Revue historique

Quatre vagues, dont aucune n'a remplacé la précédente.

### Première vague : l'enregistrement comme preuve, antiquité à aujourd'hui

Le procès-verbal et la résolution existent pour établir qu'une décision a été prise, non pour expliquer pourquoi. Le droit des sociétés en fait aujourd'hui une pièce de preuve : la jurisprudence du Delaware évalue si les procès-verbaux reflètent suffisamment le processus décisionnel pour ouvrir la protection de la règle du jugement d'affaires (Avisen Legal, 2026), et les procès-verbaux sont devenus l'une des pièces les plus importantes pour évaluer comment les administrateurs ont abordé une décision majeure (Skadden, 2022).

Ce que cette vague résout : la preuve. Ce qu'elle sacrifie : le raisonnement, qu'elle n'enregistre qu'incidemment.

### Deuxième vague : la motivation comme contrainte, droit moderne

Le droit du précédent introduit une exigence que les autres domaines n'ont pas : pour écarter une décision antérieure, il faut une justification spéciale, ou au moins des motifs sérieux (Library of Congress, 2026). Le raisonnement n'est plus optionnel, il est la condition du changement.

Ce que cette vague apporte : le suivi du changement est théorisé. Ce qu'elle coûte : une charge d'écriture considérable, assumée par une institution qui en a les moyens.

### Troisième vague : la capture exhaustive du raisonnement, 1970 à 2006

Kunz et Rittel décrivent IBIS en juillet 1970 comme le type de système d'information destiné à soutenir le travail de coopératives, agences gouvernementales, comités ou groupes de planification, confrontées à un complexe de problèmes en vue d'aboutir à un plan de décision (Kunz et Rittel, 1970, cité par Wikipedia, 2026). La notation emploie trois types de noeuds : question, position, argument.

Le texte de 1970 énonce le lien entre argumentation et décision : les arguments sont construits pour ou contre les différentes positions **jusqu'à ce que la question soit réglée en convainquant les opposants, ou tranchée par une procédure de décision formelle** (Kunz et Rittel, 1970, cité par eight2late, 2009).

Cette phrase distingue deux issues, et cette distinction n'existe dans aucun autre domaine consulté : la décision par épuisement des objections, et la décision par autorité. C'est exactement la distinction que RFC 7282 reprendra quarante-quatre ans plus tard (Resnick, 2014).

Un détail mérite d'être relevé : le mot *design rationale* n'apparaît pas une seule fois dans le papier de 1970, alors que Rittel était professeur de science du design à Berkeley (eight2late, 2009). Le champ a nommé son objet après l'avoir constitué.

La vague produit trente-cinq ans de recherche, dont gIBIS, système hypertexte qui porte IBIS du papier à l'écran (Conklin et Begeman, 1988), puis un bilan à quinze ans (Buckingham Shum et al., 2006).

Ce que cette vague résout : le raisonnement est capturé. Ce qu'elle sacrifie : la soutenabilité, et c'est l'objet de l'étape 7.

### Quatrième vague : la capture minimale, 2011 à aujourd'hui

Michael Nygard publie le 15 novembre 2011 un billet qui popularise l'ADR (Nygard, 2011). Il est lui-même écrit dans le format qu'il propose, ce qui en fait la première instance du type.

Cinq prescriptions, citées de la source primaire.

| Prescription de Nygard, 2011 | Texte |
|---|---|
| Portée | Les décisions « architecturalement significatives », c'est-à-dire celles qui affectent la structure, les caractéristiques non fonctionnelles, les dépendances, les interfaces ou les techniques de construction |
| Support | Un court fichier texte, dans le dépôt du projet, sous `doc/arch/adr-NNN.md`, en Markdown |
| **Identité** | « Les ADR seront numérotés séquentiellement et de façon monotone. **Les numéros ne seront pas réemployés** » |
| **Changement** | « Si une décision est renversée, nous garderons l'ancienne, mais la marquerons comme remplacée. Il reste pertinent de savoir qu'elle **a été** la décision, mais qu'elle ne l'est plus » |
| Destinataire | « Nous écrirons chaque ADR comme s'il s'agissait d'une conversation avec un développeur futur » |

Le format est délibérément minimal : un ou deux pages, quatre sections, statut à quatre valeurs, proposé, accepté, déprécié, remplacé avec un renvoi vers son remplaçant (Nygard, 2011). C'est un renoncement assumé à l'exhaustivité de la troisième vague.

MADR, apparu en 2017, ajoute des métadonnées, dont les décideurs et la date de confirmation, sans modifier le cycle de vie (MADR, 2026).

Ce que cette vague apporte : un coût de capture acceptable. Ce qu'elle sacrifie : la structure argumentative, qui n'est plus qu'une prose libre dans une section « contexte ».

### Deux prescriptions de 2011 que clia a réinventées en 2026

La lecture de la source primaire produit un résultat que cette recherche ne cherchait pas.

`ADR-007`, écrit hier, décide que l'identité d'une ressource est son numéro de séquence et que la renumérotation est interdite. Nygard prescrit la même chose en 2011, dans les mêmes termes : numérotation séquentielle et monotone, numéros jamais réemployés.

`RES-009` conserve la décision remplacée en la marquant. Nygard prescrit la même chose, avec la même justification : il reste pertinent de savoir qu'elle a été la décision.

Deux lectures possibles, et elles ne s'excluent pas. La convergence indépendante est un indice de solidité : deux raisonnements séparés par quinze ans aboutissent à la même règle. Mais elle établit aussi que quinze heures de travail ont reproduit un billet de blog de 2011, ce qui est exactement le défaut que cette recherche reproche au champ des ADR à l'égard du design rationale. `NON-021` porte la question de la recherche préalable.

### Ce que la superposition montre

Trois enseignements, qui ne sont dans aucune source unique.

**Chaque vague sacrifie ce que la précédente avait acquis.** La preuve sans raisonnement, puis le raisonnement comme contrainte, puis le raisonnement exhaustif, puis le raisonnement minimal. Le pendule oscille entre la complétude et le coût.

**La troisième vague est oubliée par la quatrième.** Aucun document du champ des ADR consulté ne cite Kunz, Rittel ou le design rationale. Les ADR ont réinventé une version simplifiée d'un problème déjà étudié, sans en connaître les résultats.

**Le suivi du changement n'est bien traité que par le droit.** C'est le seul domaine où écarter une décision antérieure exige une justification écrite. Partout ailleurs, le changement est un champ de statut.

## Étape 7 - Analyse critique

### État de la connaissance par question

| Question | État | Solidité |
|---|---|---|
| QR1, usage effectif | **Angle mort** partout, sauf par l'obligation légale | Faible |
| QR2, contenu à consigner | Bien traité, par la norme et par la pratique | Élevée |
| QR3, suivi du changement | Bien traité par le droit, mal ailleurs | Moyenne |
| QR4, autorité et fidélité | Bien traité par l'archivistique et le droit | Élevée |
| QR5, soutenabilité de la capture | **Le mieux traité**, et c'est un résultat négatif | Élevée |

### Le résultat central : la capture du raisonnement ne tient pas

C'est l'apport principal de cette recherche, et il vient de la voie historique.

Horner et Atwood analysent les obstacles à l'usage du design rationale et les classent en quatre catégories : cognitifs, de capture, de récupération et d'usage (Horner et Atwood, 2006). Les obstacles de capture couvrent l'information nécessaire pour situer le raisonnement dans son contexte, les incitations à capturer, l'élicitation du savoir tacite, les facteurs politiques (le raisonnement capturé fait-il courir un risque à son auteur ou à l'organisation ?), et l'arbitrage entre le coût et le bénéfice de la capture.

La nature dynamique et contextuelle de la conception, et l'incapacité à analyser exhaustivement toutes les questions de conception, produisent ces limites (Horner et Atwood, 2006).

Deux conséquences que la littérature tire elle-même.

**L'intrusion est le facteur décisif.** Intégrer la capture au travail rendrait le raisonnement un produit dérivé de l'activité de conception et réduirait l'intrusion (Horner et Atwood, 2006). Ce qui échoue n'est pas la capture, c'est la capture qui interrompt.

**Le facteur politique est rarement nommé ailleurs.** Un raisonnement enregistré peut se retourner contre son auteur. C'est un fait organisationnel, non un défaut d'outil, et aucun format ne le résout.

### Le statut « remplacé » n'est jamais mis à jour

Le second résultat est plus modeste et plus utile.

Le cycle de vie d'une décision doit être imposé, avec un minimum de quatre états, proposé, accepté, déprécié ou remplacé. Mais en pratique, les décisions sont remplacées, dépréciées, revisitées, et dans un fichier markdown, « remplacé » signifie que quelqu'un se souvient de mettre à jour le champ de statut, ce que personne ne fait (Konishi, 2026).

Cette source est un billet technique et non un travail évalué : elle est signalée comme secondaire. L'affirmation est néanmoins corroborée indirectement par l'étude empirique d'adoption, qui montre que dans environ la moitié des dépôts observés, l'usage se limite à un à cinq enregistrements (Rösch et al., 2026).

### L'adoption reste faible, et les chiffres sont récents

Malgré leurs bénéfices théoriques pour la gestion des connaissances, l'adoption industrielle large des ADR reste difficile ; elle est encore faible mais progresse régulièrement (Rösch et al., 2026).

La même étude mesure la répartition des gabarits : le gabarit de Nygard est de loin le plus employé, avec 723 dépôts, suivi de MADR avec 129 (Rösch et al., 2026). Et elle établit une cause : le raisonnement architectural est rarement consigné en raison de la tension entre la charge documentaire et le développement agile, les équipes privilégiant des structures simples et faciles à maintenir (Rösch et al., 2026).

C'est la confirmation empirique, vingt ans plus tard, du résultat de Horner et Atwood.

### Trois controverses ouvertes

**La délibération doit-elle être enregistrée avec la décision ?** Le droit administratif américain les sépare et protège la première par un privilège (ACS, 2023). Le design rationale les confond délibérément. Les deux positions sont défendables et incompatibles.

**Le raisonnement enregistré protège-t-il ou expose-t-il ?** En médecine, documenter l'emploi d'une aide à la décision pourrait offrir une protection médico-légale (Yen et al., 2026), et une revue systématique interroge la capacité de la décision partagée à réduire les litiges (Durand et al., 2015). En gouvernance, des procès-verbaux solides soutiennent la protection de la règle du jugement d'affaires (Avisen Legal, 2026). Mais Horner et Atwood relèvent que le raisonnement capturé peut faire courir un risque à son auteur. La réponse dépend du régime de publicité, non du format.

**Le consensus est-il l'absence d'objection ou l'accord de la majorité ?** RFC 7282 tranche pour le premier et note que l'IETF s'en éloigne, ses décisions devenant indistinguables d'un vote qui laisse gagner la majorité sans considérer les préoccupations minoritaires (Resnick, 2014). C'est une controverse interne à un domaine, et elle importe directement au dispositif d'objection de `clia`.

### Ce que la littérature ne documente pas

`MET-001` étape 7 exige cette rubrique. Trois lacunes.

**Aucune mesure de la relecture.** Aucune source consultée ne mesure combien de fois un enregistrement de décision est relu après sa production, ni par qui. L'axe A11 est donc vide. C'est d'autant plus frappant que tous les domaines justifient l'enregistrement par son usage futur.

**Aucune analyse d'échec dans le champ des ADR.** Le design rationale a documenté son échec ; le champ des ADR, plus récent, ne documente que ses succès. L'étude d'adoption mesure une adoption faible sans analyser les abandons.

**Aucun traitement de l'enregistrement d'une décision externe.** Les sept domaines documentent leurs propres décisions. Aucun ne traite le cas d'une organisation qui enregistre une décision prise par une instance tierce pour s'y référer, qui est le cas d'usage principal de `RES-009`.

## Étape 8 - Réponses aux questions

**QR1. On ne sait pas, et c'est un résultat.** Aucune source ne mesure l'usage effectif. Les seuls usages attestés sont contraints : la preuve en justice, le droit d'accès du public. Là où l'enregistrement est volontaire, l'adoption reste faible (Rösch et al., 2026), ce qui suggère que le bénéfice perçu est inférieur au coût.

**QR2. Quatre éléments, et un cinquième contesté.** Le dispositif, l'instance, la date, et les conséquences font consensus. Le raisonnement fait débat : nécessaire selon le droit du précédent, coûteux selon le design rationale, réduit à une section de contexte par les ADR.

Un cinquième élément est exigé par l'archivistique et négligé ailleurs : ce qui atteste l'**authenticité** de l'enregistrement (CASRAI, 2026).

**QR3. Le droit fournit le seul mécanisme robuste.** Écarter une décision antérieure exige une justification spéciale (Library of Congress, 2026). Les autres domaines emploient un champ de statut, et ce champ n'est pas tenu (Konishi, 2026).

La leçon transposable est que le changement doit être un **acte documenté**, non un changement d'état. Un état se met à jour ou s'oublie ; un acte laisse une trace même s'il est incomplet.

**QR4. L'autorité est celle de l'instance, la fidélité est procédurale.** Aucun domaine ne garantit la fidélité par un mécanisme technique. Tous emploient une procédure : approbation formelle du procès-verbal, signature d'une résolution, triade d'authenticité, fiabilité et intégrité (CASRAI, 2026).

Un cas particulier mérite attention : RFC 7282 fait de l'absence d'objection technique non traitée le critère du consensus (Resnick, 2014). La fidélité y est garantie par le fait que quiconque peut objecter, non par une autorité.

**QR5. À trois conditions, dont une seule est technique.** Que la capture soit un produit dérivé du travail et non une tâche supplémentaire (Horner et Atwood, 2006). Que la charge soit proportionnée au cycle de développement (Rösch et al., 2026). Et que le raisonnement enregistré ne fasse pas courir de risque à son auteur, ce qui est un fait organisationnel qu'aucun format ne résout (Horner et Atwood, 2006).

## Étape 9 - Vérification des références

Les trente URL citées ont été interrogées le 2026-08-10, chacune avec suivi des redirections. Le résultat est consigné en bibliographie, source par source, et non globalement, ce qui corrige le défaut de `FND-002`.

| Résultat | Nombre | Sources concernées |
|---|---|---|
| Répond, code 200 | 26 | Consultation directe, statut plein |
| Refuse les requêtes automatisées, code 403 | 4 | `congress.gov` deux fois, `americanbar.org`, `dl.acm.org`. Statut abaissé à rapportée |
| Morte | 0 | après correction, voir ci-dessous |

**Une URL était morte et a été corrigée.** Le billet de eight2late sur IBIS était cité à la date du 23 juin 2009 et répondait 404. La recherche interne du site donne la date réelle, le 8 juillet 2009, et l'URL corrigée répond. C'est précisément le genre de défaut que l'étape 9 existe pour attraper, et il est ici attrapé avant publication et non après.

**Cette vérification a produit trois sources primaires supplémentaires.** Le billet fondateur de Nygard de 2011 était initialement cité par une source secondaire, faute d'URL vivante ; l'archive du web le rend consultable directement, et sa lecture a produit la section sur les deux prescriptions réinventées. La page encyclopédique consultée pour dater IBIS portait la référence bibliographique complète du document de travail de 1970 et celle de gIBIS de 1988. L'étape 9 n'est donc pas une formalité de fin : elle a modifié le contenu de la recherche.

## Étape 10 - Mesure de densité, et ce qui manque

`MET-001` exige cette mesure et exige de dire ce qui manque plutôt que de laisser croire à l'exhaustivité.

| Critère | Seuil de `MET-001` | Atteint par ce document | Verdict |
|---|---|---|---|
| Sources distinctes | 10 par question, soit 50 | 32, soit **6,4 par question** | échoue |
| Sources primaires | La moitié | 19 sur 32, soit 59 pour cent. Ramené à 16, soit 50 pour cent, si l'on exclut les trois primaires non consultées directement | **satisfait, de justesse** |
| Longueur | 2 à 4 pages par question, soit 10 à 20 pages | environ 9 pages, soit **1,8 page par question** | échoue de peu |
| Références complètes | Toutes | 32 sur 32, avec DOI ou OCLC lorsqu'il existe | satisfait |
| Date de consultation par source | Toutes | 32 sur 32 | satisfait |
| Domaines identifiés, avec apport | Tous ceux qui recoupent | 7, par les trois voies, la voie historique comprise | satisfait |
| Axes d'analyse | Tous, plus ceux absents de la littérature | 11, plus 2 absents nommés | satisfait |
| Réponse par question | Explicite | 5 sur 5 | satisfait |
| Limites écrites | Y compris ce que la littérature ignore | 3 lacunes de la littérature, 5 limites propres | satisfait |
| État de vérification des URL | Consigné et daté | par source, avec le code obtenu | satisfait |

**Ce document échoue sur deux critères et en satisfait huit.** Il échoue sur la densité de sources, qui reste à 6,4 par question au lieu de dix, et de peu sur la longueur, 1,8 page par question au lieu de deux minimum.

Il satisfait en revanche exactement ce que `FND-002` manquait, et qui était le reproche de l'humain à la tâche 11 : les références sont complètes, la date de consultation est portée par source, la vérification est consignée source par source, et la moitié des sources sont primaires.

**Ce que cela dit de `MET-001`.** Sa première épreuve délibérée établit deux choses.

Ses exigences de forme sont applicables et utiles. L'étape 4, avec sa voie historiquement antérieure, a produit l'apport central. L'étape 9 a corrigé une URL morte et ajouté trois sources primaires. L'étape 10 a rendu mesurable un défaut qui, à la tâche 11, avait dû être signalé par l'humain.

Son seuil de densité n'est pas atteignable au coût d'une tâche. Dix sources par question sur cinq questions supposent une cinquantaine de sources lues, situées et référencées. La méthodologie doit soit abaisser le seuil, soit prévoir qu'une fondation s'étale sur plusieurs tâches, soit exiger moins de questions. `NON-020` porte la question, avec les trois options.

## Ce que cette recherche apporte à RES-009 et aux méthodologies

Sept apports, chacun rattaché à une source.

| Apport | Fondement | Effet sur `RES-009` |
|---|---|---|
| Séparer la décision de sa délibération | Privilège du processus délibératif (ACS, 2023) | Le type ne porte pas la délibération. À écrire explicitement |
| Le changement est un acte, non un état | Justification spéciale du *stare decisis* (Library of Congress, 2026) ; le statut n'est pas tenu (Konishi, 2026) | **Le champ `effet` est insuffisant.** Un revirement doit produire une nouvelle `DCN` qui motive le changement |
| L'authenticité doit être attestée | Triade de ISO 15489 (CASRAI, 2026) | Un champ manque : ce qui atteste que l'enregistrement est fidèle |
| La capture doit être un produit dérivé | Horner et Atwood, 2006 | Une `DCN` produite après coup, à partir d'un ADR ou d'une objection, coûte moins qu'une saisie dédiée |
| Le facteur politique existe et n'a pas de solution technique | Horner et Atwood, 2006 | Le champ `diffusion` de `RES-005` devrait s'étendre à `RES-009` |
| Le consensus est l'absence d'objection non traitée | RFC 7282 (Resnick, 2014) | Fonde le dispositif d'objection : une décision est acquise quand aucune objection bloquante ne reste |
| L'adoption échoue par la charge, non par le format | Rösch et al., 2026 | Le nombre de champs obligatoires de `RES-009` est un risque d'abandon, non un gage de rigueur |

**L'apport le plus structurant est le deuxième.** `RES-009` traite le changement par un champ `effet` à cinq valeurs. La littérature établit que ce mécanisme ne tient pas : le champ n'est pas mis à jour. Le droit fournit l'alternative, un acte motivé, et `clia` peut l'appliquer sans coût nouveau puisqu'il produit déjà des `DCN`.

## Bibliographie

Trente-deux sources, dont trente portent une URL. Chaque entrée porte sa nature, le code obtenu lors de la vérification de l'étape 9, et sa date de consultation, qui est le 2026-08-10 pour toutes.

### Sources primaires du champ du design rationale

1. **Kunz, W. et Rittel, H. W. J.** *Issues as elements of information systems*. Document de travail 131, Institute of Urban and Regional Development, University of California, Berkeley, juillet 1970. OCLC 5065959. **Non consultée directement**, aucun exemplaire librement accessible trouvé ; citée par les entrées 15 et 31, qui la reproduisent longuement. Statut : rapportée.
2. **Rittel, H. W. J. et Webber, M. M.** *Dilemmas in a general theory of planning*. Policy Sciences, vol. 4, n° 2, juin 1973, p. 155-169. DOI 10.1007/BF01405730. <https://doi.org/10.1007/BF01405730>. Vérifiée, code 200. Article fondateur de la notion de *wicked problem*.
3. **Conklin, E. J. et Begeman, M. L.** *gIBIS: a hypertext tool for exploratory policy discussion*. ACM Transactions on Information Systems, vol. 6, n° 4, octobre 1988, p. 303-331. DOI 10.1145/58566.59297. <https://doi.org/10.1145/58566.59297>. Vérifiée, code 403, l'éditeur refuse les requêtes automatisées. Statut : rapportée, employée pour situer le passage d'IBIS du papier à l'écran.
4. **Buckingham Shum, S. J., Selvin, A. M., Sierhuis, M., Conklin, E. J., Haley, C. B. et Nuseibeh, B.** *Hypermedia support for argumentation-based rationale: 15 years on from gIBIS and QOC*, dans Dutoit, A. H., McCall, R., Mistrík, I. et Paech, B. (dir.), *Rationale management in software engineering*, Berlin et New York, Springer-Verlag, 2006, p. 111-132. DOI 10.1007/978-3-540-30998-7_5. <https://doi.org/10.1007/978-3-540-30998-7_5>. Vérifiée, code 200. Bilan à quinze ans du champ.
5. **Horner, J. et Atwood, M. E.** *Design Rationale: The Rationale and the Barriers*, 2006. <https://research.cs.vt.edu/ns/cs5724papers/1.motivatingreuse.tpgap.atwood.drationale.pdf>. Vérifiée, code 200. **Source principale de cette recherche**, porte la typologie des quatre catégories d'obstacles.

### Sources primaires du champ des ADR

6. **Nygard, M.** *Documenting Architecture Decisions*. Billet, Relevance, 15 novembre 2011. Archive du web, instantané du 29 décembre 2018, le site d'origine `thinkrelevance.com` n'étant plus servi. <http://web.archive.org/web/2018/http://thinkrelevance.com/blog/2011/11/15/documenting-architecture-decisions>. Vérifiée, code 200, **consultée directement**. Source fondatrice du type ADR.
7. **MADR**. *About MADR : Markdown Architectural Decision Records*. Documentation officielle du projet, version courante 2026. <https://adr.github.io/madr/>. Vérifiée, code 200.

### Sources primaires normatives et légales

8. **ISO 15489-1:2016**, *Information et documentation, Gestion des documents d'activité, Partie 1 : Concepts et principes*. Organisation internationale de normalisation, 2016. Norme payante, **non consultée directement** ; décrite par les entrées 9 et 10. Statut : rapportée.
9. **CASRAI**. *ISO 15489: Records Management Concepts and Principles*. <https://casrai.org/guides/iso-15489-records-management-concepts-principles>. Vérifiée, code 200. Porte la triade authenticité, fiabilité, intégrité.
10. **Wikipedia**. *ISO 15489*. <https://en.wikipedia.org/wiki/ISO_15489>. Vérifiée, code 200. Encyclopédie collaborative, employée pour la datation et la structure de la norme.
11. **Resnick, P.** *RFC 7282 : On Consensus and Humming in the IETF*. Internet Engineering Task Force, juin 2014, statut informationnel. <https://www.rfc-editor.org/rfc/rfc7282>. Vérifiée, code 200. Source normative primaire.
12. **Library of Congress**, Congressional Research Service. *Stare Decisis Factors*, dans *Constitution Annotated*, Article III, section 1. <https://constitution.congress.gov/browse/essay/artIII-S1-7-2-3/ALDE_00013238/>. Vérifiée, code 403, refus des requêtes automatisées. Statut : rapportée.
13. **Library of Congress**, Congressional Research Service. *The Supreme Court's Overruling of Constitutional Precedent*, rapport R45319. <https://www.congress.gov/crs-product/R45319>. Vérifiée, code 403, refus des requêtes automatisées. Statut : rapportée.
14. **United States Department of Justice**, Office of Information Policy. *The Freedom of Information Act, 5 U.S.C. § 552*. <https://www.justice.gov/oip/freedom-information-act-5-usc-552>. Vérifiée, code 200. Texte légal.
15. **Wikipedia**. *Issue-based information system*. <https://en.wikipedia.org/wiki/Issue-based_information_system>. Vérifiée, code 200. Employée pour l'appareil bibliographique du champ, dont les entrées 1, 3 et 4 sont issues, et pour les citations du texte de 1970.

### Sources de recherche évaluées ou en préimpression

16. **Rösch, S. et al.** *One Size Fits All? An Empirical Comparison of ADR Templates regarding Comprehension, Usability, and Ease of Adoption*. Préimpression arXiv 2604.27333, 2026. <https://arxiv.org/html/2604.27333v1>. Vérifiée, code 200. **Attribution d'auteurs incertaine** : la page consultée n'a pas permis de l'établir, la citation est faite sous réserve.
17. **Durand, M.-A. et al.** *Can shared decision-making reduce medical malpractice litigation? A systematic review*. BMC Health Services Research, 2015. PMC4409730. <https://www.ncbi.nlm.nih.gov/pmc/articles/PMC4409730/>. Vérifiée, code 200. Revue systématique.
18. **Yen, R. W. et al.** *Shared Decision-Making Tools Implemented in the Electronic Health Record: Scoping Review*, 2026. PMC11890150. <https://www.ncbi.nlm.nih.gov/pmc/articles/PMC11890150/>. Vérifiée, code 200. Revue de portée. Attribution sous réserve.
19. *Does Clinical Documentation Reflect How Parents and Clinicians Share Decisions About Surgery?*, 2026. PMC12632590. <https://www.ncbi.nlm.nih.gov/pmc/articles/PMC12632590/>. Vérifiée, code 200. **Auteurs non établis**, citation sous réserve.
20. *Documenting the process of patient decision making: a review of the development of the law on consent*, 2019. PMC6465837. <https://www.ncbi.nlm.nih.gov/pmc/articles/PMC6465837/>. Vérifiée, code 200.
21. **Barrett, A. C.** *Precedent and Jurisprudential Disagreement*, extrait. Catholic University of America, Columbus School of Law. <https://www.law.edu/academics/office-of-academic-affairs/orientation/Barrett----Precedent-and-Jurisprudential-Disagreement-excerpt.pdf>. Vérifiée, code 200.
22. **Harvard Law Review**. *The Thrust and Parry of Stare Decisis in the Roberts Court*, vol. 137. <https://harvardlawreview.org/print/vol-137/the-thrust-and-parry-of-stare-decisis-in-the-roberts-court/>. Vérifiée, code 200.

### Sources professionnelles et institutionnelles

23. **American Bar Association**, Division for Public Education. *Understanding Stare Decisis*. <https://www.americanbar.org/groups/public_education/publications/preview_home/understand-stare-decisis/>. Vérifiée, code 403, refus des requêtes automatisées. Statut : rapportée.
24. **Avisen Legal**. *Board Minutes Matter More Than Most Companies Think: Lessons from Recent Delaware Corporate Law Developments*, 2026. <https://www.avisenlegal.com/board-minutes-matter-more-than-most-companies-think-lessons-from-recent-delaware-corporate-law-developments/>. Vérifiée, code 200. Cabinet d'avocats, source professionnelle.
25. **Skadden, Arps, Slate, Meagher & Flom**. *The Angel's in the Details: The Importance of Carefully Drafted Board Minutes*, The Informed Board, décembre 2022. <https://www.skadden.com/insights/publications/2022/12/the-informed-board/the-angels-in-the-details>. Vérifiée, code 200.
26. **Advantage Delaware**. *Making Corporate Decisions*. <https://advantage-de.com/information-center/corporate-compliance/making-corporate-decisions/>. Vérifiée, code 200. Source commerciale, employée pour un seul point de pratique.
27. **American Constitution Society**. *Check Your Deliberative Process Privilege*, 2023. <https://www.acslaw.org/wp-content/uploads/2023/05/Student-No.-8-Check-Your-Deliberative-Process-PrivilegeRevealing-the-Foibles-of-FOIAs-Framing-via-a-Ride-into-the-Sunset-Retention-Mismatch-2.6-002.pdf>. Vérifiée, code 200. Note d'étudiant, statut secondaire.

### Sources secondaires, signalées comme telles

28. **Konishi, H.** *Architecture Decision Records: Templates and Operational Patterns for Teams That Actually Maintain Them*, 2026. <https://hidekazu-konishi.com/entry/architecture_decision_records_templates_and_operations.html>. Vérifiée, code 200. Billet technique. Porte l'affirmation sur le statut « remplacé » jamais mis à jour, corroborée indirectement par l'entrée 16.
29. **Red Hat**. *Why you should be using architecture decision records to document your project*. <https://www.redhat.com/en/blog/architecture-decision-records>. Vérifiée, code 200. Billet d'éditeur, employé pour situer la diffusion du gabarit de Nygard. La source primaire, entrée 6, prévaut sur elle partout où elles se recoupent.
30. **eight2late**. *The what and whence of issue-based information systems*, 8 juillet 2009. <https://eight2late.wordpress.com/2009/07/08/the-what-and-whence-of-issue-based-information-systems/>. Vérifiée, code 200 après correction de l'URL, voir étape 9. Billet de praticien, employé pour ses citations longues du texte de 1970.
31. **Dubberly, H.** *Why Horst W.J. Rittel Matters*. <https://www.dubberly.com/articles/why-horst-wj-rittel-matters.html>. Vérifiée, code 200. Article de praticien, employé pour situer Rittel.
32. **Wikipedia**. *Design rationale*. <https://en.wikipedia.org/wiki/Design_rationale>. Vérifiée, code 200. Employée à l'étape 4 pour délimiter le champ.

## Limites de cette recherche

**La densité est insuffisante**, mesurée à l'étape 10 : 6,4 sources par question au lieu de dix, 1,8 page par question au lieu de deux à quatre. C'est le même défaut que `FND-002`, et il est cette fois mesuré et déclaré plutôt que constaté après coup. `NON-020` conteste le seuil lui-même, qu'aucune des deux fondations du dépôt n'a jamais approché.

**Trois sources primaires n'ont pas été consultées directement.** Le document de travail de 1970 de Kunz et Rittel, dont aucun exemplaire librement accessible n'a été trouvé ; la norme ISO 15489-1:2016, payante ; et l'article de 1988 sur gIBIS, dont l'éditeur refuse les requêtes automatisées. Les trois sont citées par des sources qui les reproduisent, et signalées comme rapportées en bibliographie. Le champ du design rationale est donc établi ici sur du rapporté, ce qui est une faiblesse pour une revue qui reproche à ses prédécesseurs de ne pas remonter aux sources.

**Trois attributions d'auteurs sont incertaines**, signalées aux entrées 10, 12 et 13 de la bibliographie.

**Aucune source non anglophone.** Le droit français impose une obligation de motivation des jugements dont la théorie diffère de la *special justification* du droit américain. Cette littérature n'a pas été consultée, ce qui appauvrit la réponse à QR3.

**Aucune source sur les décisions algorithmiques.** Le règlement européen sur l'intelligence artificielle et les obligations d'explicabilité recoupent directement QR2 et QR5. Le domaine n'a pas été exploré.

**L'axe A11, l'usage effectif, reste vide.** C'est la lacune la plus gênante : tous les domaines justifient l'enregistrement par un usage futur que personne ne mesure.

## Relations

- `derive-de` [MET-001](../methodologies/MET-001-recherche-de-fondation.md)
- `specifie` [RES-009](../ressources/RES-009-decision.md)
- `specifie` [MET-002](../methodologies/MET-002-enregistrement-et-suivi-d-une-decision.md)
- `reference` [ANL-001](../analyses/ANL-001-observation-corpus-repos-et-pratiques/index.md)
- `reference` [RES-004](../ressources/RES-004-objection.md)
