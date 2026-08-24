---
type: objection
id: NON-001
title: "Identité, nommage et préfixes des ressources"
status: draft
maturity: conception
adoption: propose
activated: true
domain-status: "repondue"
initiateur: agent
effet: informatif
etat: repondue
porte-sur: [RES-001, RES-004, ADR-001]
---

# NON-001 - Identité, nommage et préfixes des ressources

> Le premier jet de `RES-001` décide que l'identité d'une ressource est le champ `id` et non son numéro de séquence. Cette décision engage tous les renvois du système et n'a pas été arbitrée.

## Journal

- 2026-08-09 : ouverte par l'agent, à la production du premier jet des ressources fondamentales.
- 2026-08-09 : preuve empirique ajoutée par l'implémentation de `clia`. La question Q1 n'est plus théorique, voir la section « Preuve produite par l'implémentation ».
- 2026-08-10 : cinq questions ajoutées, Q8 à Q12, à partir de `FND-002` et `ANL-003`. Le champ `porte-sur` est étendu.
- 2026-08-10 : deuxième preuve empirique. La collision de numéros annoncée par Q7 s'est produite en situation réelle, moins de vingt-quatre heures après avoir été posée. Voir la section « Deuxième preuve : la collision annoncée ».
- 2026-08-10 : **Q1 répondue par l'humain**, tâche 13, actée par `DCN-007` et `ADR-007`. L'identité est `<PREFIX>-<SEQ>`, ni le slug ni le chemin. Q7 est répondue de fait : c'est `clia` qui attribue le numéro. L'état passe à `partiellement-repondue` : Q2, Q4, Q6 et Q10 restent ouvertes.
- 2026-08-10 : **les onze questions restantes répondues par l'humain**, et Q1 corrigée par la mention « non. voir FRG-001. » Les douze questions portent une réponse. L'état passe à `repondue`.
- 2026-08-10 : traitement des réponses, tâche 18. Enregistrées par `DCN-008`, instruites par `ADR-008`. La correction principale porte sur Q1 : `<PREFIX>-<SEQ>` est l'**alias interne**, non l'identité. `ADR-007` D1 et D2 sont abrogés, D3 à D5 subsistent. Q11 produit `PDC-002`. Les conséquences non tranchées sont portées par `NON-023`.

## Ce qui est contesté

Deux choses.

D'abord, la proposition de `RES-001` : l'identité d'une ressource est le champ `id`, de la forme `<PREFIXE>-<SLUG>`, le numéro de séquence n'étant plus qu'un ordre d'apparition. Cette proposition s'écarte de l'état de l'art du corpus, `RES-001` de `micrologic-clients`, qui pose que l'identité d'une ressource est son chemin.

Ensuite, la coexistence de deux préfixes pour l'objection : `NON` demandé par `CLAUDE.md` et par la session, `OBJ` en usage dans `micrologic-clients` avec quatre instances et une définition.

## Pourquoi cela ne peut pas rester implicite

Le fait mesuré est établi par `ANL-001`, défaut D1 : dans le corpus, douze numéros de skill sur vingt portent plusieurs noms distincts selon le dépôt. `skl-004` désigne cinq skills différents, `skl-006` en désigne quatre. Un dépôt porte sept ADR dont trois paires de doublons de titre, jamais détectées.

`CLAUDE.md` désigne aujourd'hui chaque type de ressource par un triplet `ADR-XXX, RES-XXX, skl-XXX`. Si cette désignation est conservée, elle est fausse dès qu'un deuxième dépôt est équipé, et le système ne peut pas être partagé. Si elle est abandonnée, il faut décider par quoi elle est remplacée avant d'écrire des centaines de renvois.

Le coût de l'indécision est asymétrique : décider maintenant coûte un champ de frontmatter, décider dans six mois coûte la réécriture de tous les renvois du corpus.

## Preuve produite par l'implémentation

Ajoutée le 2026-08-09, à la tâche 6. La demande de la tâche décrivait l'identifiant d'une instance comme `<PREFIX>-<SEQ>`, ce qui est la position que Q1 conteste. L'implémentation de `clia res show` a permis de l'éprouver.

Un dépôt d'essai contenant deux types, `CHO` et `RES`, chacun avec une instance numérotée 002 :

```
$ clia res show 002
clia: identifiant ambigu : 002
      .dev/choses/CHO-002-deuxieme-chose.md
      .dev/ressources/RES-002-traces.md
```

Le numéro de séquence ne désigne pas une ressource : il désigne un rang dans une série, et les séries coexistent. L'ambiguïté n'est pas un défaut de l'outil, c'est une propriété du numéro.

Trois conséquences pour cette objection.

Le champ `id` de la forme `<PREFIXE>-<SLUG>`, proposé par `RES-001` et acté par `ADR-001` D3, résout l'ambiguïté sans mécanisme supplémentaire : `CHO-deuxieme-chose` et `RES-traces` ne collisionnent pas.

La forme `<PREFIXE>-<SEQ>` reste utile comme **adresse**, parce qu'elle est courte et qu'elle se lit dans le nom de fichier. `clia` l'affiche pour cette raison dans la colonne `ID` de `res ls`. Adresse et identité sont deux choses, et les nommer pareil est ce qui a produit la confusion.

Le CLI accepte les deux formes en entrée, plus le numéro seul, et refuse en nommant les candidats quand la résolution est ambiguë. C'est une réponse d'implémentation à une question non tranchée, et elle est réversible.

## Deuxième preuve : la collision annoncée

Ajoutée le 2026-08-10. La question Q7 posait que l'attribution du numéro par déduction du contenu du répertoire produit des collisions dès que deux travaux avancent en parallèle. Le cas s'est produit.

L'humain a créé, le 2026-08-09, une objection `NON-013-ce-qu-est-une-ressource.md` au moyen de `clia res new`. L'agent a produit, le 2026-08-10, une objection distincte à laquelle `clia` a attribué le même numéro, le fichier de l'humain n'étant pas encore commité au moment où l'agent avait relevé l'état du répertoire.

Deux constats.

**La collision n'est pas due à un défaut de l'outil.** `clia res new` a correctement pris le maximum existant plus un. Le défaut est que le numéro est attribué par observation d'un état, et qu'un état observé à deux moments différents donne deux résultats. Aucun mécanisme de réservation n'existe, et aucun n'est possible sans coordination.

**La résolution a été manuelle et asymétrique.** L'objection de l'agent a été renumérotée en `NON-014`, celle de l'humain conservée. Le choix suit le régime d'édition : l'humain est l'initiateur de sa propre objection, et `RES-004` pose qu'aucune partie ne réécrit les blocs de l'autre.

Ce que cela ajoute à l'objection : la question Q7 n'est plus prospective. Et elle renforce Q1, puisqu'une identité fondée sur le slug n'aurait pas collisionné, les deux objections portant sur des sujets distincts.

## Questions

### Q1 - L'identité d'une ressource est-elle le champ `id`, ou reste-t-elle le chemin ?

`RES-001` propose le champ `id`. La position concurrente, celle de `micrologic-clients`, est que l'identité est le chemin, ce qui ne coûte rien mais rend tout reclassement destructeur.

**Réponse, du 2026-08-10, par l'humain.** Ni l'un ni l'autre : l'identité est le champ `id` de forme `<PREFIX>-<SEQ>`.

La prémisse de l'agent était fausse sur un point de fait. Il supposait la renumérotation possible, donc le numéro instable. Elle ne l'est pas si l'on décide qu'elle ne l'est pas, et `ADR-007` D2 l'interdit. Le fragment `FRG-001` fournit le critère : ce qui persiste par-delà les modifications est l'identité. Le numéro est attribué à la création et persiste ; le slug suit un titre révisable.

Cette réponse est actée par `DCN-007` et instruite par `ADR-007`. Les conséquences qu'elle laisse ouvertes sont portées par `NON-019`.

non. voir FRG-001.


### Q2 - Si l'identité est `<PREFIXE>-<SLUG>`, que se passe-t-il quand deux dépôts emploient le même `id` pour des choses différentes ?

Exemple concret : `INT-intention-ultime` dans quinze dépôts désigne quinze intentions différentes. Faut-il un espace de noms, par exemple `<depot>:<PREFIXE>-<SLUG>`, ou l'identité est-elle locale au dépôt par construction, avec les renvois inter-dépôts traités autrement ?

**Réponse.**

l'identité n'est pas <PREFIXE>-<SLUG>

### Q3 - `NON` ou `OBJ` pour l'objection, et qui paie la migration ?

`CLAUDE.md` dit `NON`. L'usage établi dit `OBJ`. `ANL-001` mesure qu'un changement de préfixe a déjà coûté six corrections manuelles dans un seul dépôt. Trois positions : imposer `NON` partout, revenir à `OBJ`, ou déclarer que `NON` est le préfixe de `clia` et `OBJ` un synonyme écarté inscrit à l'ontologie.

**Réponse.**

utiliser NON comme préfix pour les objections

### Q4 - Le numéro de séquence doit-il rester dans le nom de fichier ?

S'il ne porte plus l'identité, il ne sert plus qu'à l'ordre de lecture et à l'ancienneté. Deux positions : le conserver, parce qu'il donne un ordre gratuit et une trace de chronologie ; le supprimer, parce que sa présence invite à s'en servir comme identifiant, ce qui est précisément le défaut à corriger.

**Réponse.**

Le système d'identifiant interne n'a besoin que d'être relatif et auto-cohérent.

<PREFIX>-<SEQ> est l'implémentation par défaut de l'id-interne/alias de l'identifiant.

### Q5 - Que devient un renvoi par numéro déjà écrit ?

`CLAUDE.md` en contient vingt-sept triplets. Les archives de `clia` en contiennent des centaines. Faut-il les migrer, les laisser en place comme renvois historiques assumés, ou les traiter au fil de l'eau lorsqu'un document est touché ?

**Réponse.**

Pour les références externe, nous allons utiliser un identifiant plus "robuste". Mais les modifications internes de l'alias/identifiant doit modifier du même coup toutes les références

### Q6 - Un renommage de slug est-il un changement d'identité ou une correction ?

`RES-001` propose de le traiter comme un changement d'identité, avec `remplace` et `est-remplacee-par`. C'est rigoureux et coûteux : corriger une faute de frappe dans un slug crée alors une ressource morte. Faut-il une tolérance, par exemple un champ `id-anterieurs` qui conserve les identités abandonnées sans créer de ressource ?

**Réponse.**

Le slug n'a rien à voir avec l'identifiant, il n'est là que pour aider les humains à se repérer. On peut changer le slug sans conséquense. D'autant plus que le slug n'est jamais utilisé dans le iid.

### Q7 - Qui attribue le numéro de séquence ?

Aujourd'hui, personne : l'agent le déduit du contenu du répertoire, ce qui produit des collisions dès que deux travaux avancent en parallèle. Faut-il que ce soit `clia`, ce qui reporte la question à la session d'outillage, ou l'humain, ou une règle qui rende les collisions inoffensives ?

**Réponse.**

le cli clia avec `clia res new TYPE DESCRIPTION`

### Q8 - L'identité désigne-t-elle l'oeuvre, ou la version ?

Ajoutée le 2026-08-10. `FND-002` établit que FRBR distingue quatre niveaux, oeuvre, expression, manifestation, exemplaire, et qu'un identifiant qui ne déclare pas son niveau confond l'oeuvre et le fichier. `RES-001` ne le déclare pas.

La suggestion S2 de `ANL-003` propose que l'`id` désigne l'oeuvre, le champ `version` l'expression, et une empreinte la manifestation. C'est cohérent et c'est une lecture rétrospective : rien ne garantit que les seize identités déjà écrites aient été choisies avec ce sens.

**Réponse.**

l'oeuvre. La version est défini par le mécanisme de publication externe. À l'interne, les modifications sont traçables par l'historique.

### Q9 - Faut-il un identifiant intrinsèque, et pour quel usage exactement ?

Ajoutée le 2026-08-10. `FND-002` établit que seul l'identifiant intrinsèque, calculable depuis l'objet, est vérifiable sans son émetteur, et que la citation exige une information de fixité portée à côté du nom.

`clia` n'a aucun identifiant intrinsèque. La suggestion S4 de `ANL-003` propose une empreinte calculable à la demande et non stockée, employée pour la vérification et jamais pour la désignation. La distinction entre les deux usages est le point à trancher.

**Réponse.**

l'identifiant intrinsèque est utile pour suivre l'historique et attester des modificaitons. (git)

### Q10 - Le format d'un identifiant de dépôt, et que faire quand le dépôt n'a pas d'adresse ?

Ajoutée le 2026-08-10. La suggestion S3 de `ANL-003` propose une identité globale de la forme `<origine>:<PREFIXE>-<SLUG>`, par extension du noyau et non par remplacement, ce qui est le mécanisme du SWHID et du GroupVersionKind de Kubernetes selon `FND-002`.

Reste à décider ce que vaut `<origine>`. Trois options : le nom du répertoire local, gratuit et fragile ; un identifiant déclaré dans un fichier du dépôt, qui coûte une convention ; l'URL du remote, la plus juste et absente pour quatre-vingt-quatorze dépôts sur cent soixante-six.

**Réponse.**

Il s'agit de l'identifiant externe.

C'est une question complexe pour laquelle je n'ai pas de solution définitive. Mais voici une tentative =>

clia://<author|personne qui partage>@<repo>/<origin>:<PREFIX>-<UUID>/<hash-version>

origine étant l'instance du repo.

Ceci implique que => chaque instance du repo doit avoir un identifiant (éphémère)


### Q11 - L'ergonomie est-elle une exigence opposable ?

Ajoutée le 2026-08-10. `FND-002` établit que l'ergonomie de saisie n'a aucune littérature : les identifiants sont conçus pour des machines et des institutions, jamais pour une personne qui tape au clavier. C'est pourtant la première exigence de la demande.

`ANL-003` note que la lisibilité et l'ergonomie sont les deux seuls axes sur lesquels `clia` fait mieux que les systèmes documentés, et que chaque amélioration d'unicité les menace. La suggestion S8 propose d'en faire une exigence écrite, avec trois contraintes vérifiables.

Une exigence non écrite est une exigence qui perd tous les arbitrages.

**Réponse.**

L'ergonomie interne est une exigence non négociable. Parce que nous concevont un CLI utilisable par un humain. Il est impensable de devoir manipuler des strings incompréhensibles pour un humain pour faire référence à une ressource. 

Le format par défaut est décidé: PREFIX-SEQ

### Q12 - Corriger un slug et changer de sujet sont-ils la même opération ?

Ajoutée le 2026-08-10, et elle précise Q6. `RES-001` traite tout renommage de slug comme un changement d'identité, avec `remplace` et `est-remplacee-par`. Corriger une coquille crée donc une ressource morte.

La suggestion S7 de `ANL-003` propose de séparer les deux : une correction conserve l'identité et enregistre l'ancienne forme dans un champ `id-anterieurs` ; un changement de sujet produit une nouvelle identité et déclare la filiation.

**Réponse.**

non. le slug n'a rien à voir avec l'identité. Donc, un changement de slug ne provoque pas de changement d'identité.

## Ce qui lèverait cette objection

**Levée le 2026-08-10.** Les douze questions portent une réponse de l'humain. Les réponses sont enregistrées par `DCN-008` et instruites par `ADR-008`.

L'effet passe de `bloquant` à `informatif` : l'objection ne bloque plus rien et reste lisible comme registre des questions posées et des réponses reçues.

Une réponse est déclarée non définitive par son auteur, celle de Q10 sur l'identifiant externe. Elle est enregistrée comme orientation par `ADR-008` D7, et ce qu'elle laisse ouvert est porté par `NON-023`, non par cette objection.

## Relations

- `objecte-a` [RES-001](../ressources/RES-001-ressource.md)
- `objecte-a` [RES-004](../ressources/RES-004-objection.md)
- `derive-de` [ANL-001](../analyses/ANL-001-observation-corpus-repos-et-pratiques/analyse-critique.md)
- `derive-de` [ANL-003](../analyses/ANL-003-systeme-d-identifiants-de-clia.md)
- `reference` [FND-002](../fondations/FND-002-identifiants-dans-les-systemes-decentralises.md)
- `reference` [NON-023](NON-023-consequences-du-regime-a-deux-niveaux.md)
