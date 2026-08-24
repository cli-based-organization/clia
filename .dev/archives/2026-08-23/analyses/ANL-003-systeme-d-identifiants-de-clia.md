---
type: analyse
id: ANL-003
title: "Système d'identifiants des ressources clia : analyse et suggestions"
status: draft
maturity: conception
adoption: propose
activated: true
date: 2026-08-10
sujet: "Position de clia sur les axes de conception d'identifiants, et suggestions fondées"
generated:
  by: claude-opus-5
  at: 2026-08-10
---

# ANL-003 - Système d'identifiants des ressources clia : analyse et suggestions

> Confrontation du système d'identifiants actuel de `clia` aux quatorze axes de `FND-002` et aux faits mesurés par `ANL-001`. Conclusion : le système actuel est juste sur cinq axes, indéterminé sur six, et faux sur trois. Dix suggestions, ordonnées par rapport entre ce qu'elles apportent et ce qu'elles coûtent.

## Objet

`FND-002` établit qu'un système d'identifiants viable est une famille, non un identifiant unique, et fournit quatorze axes pour décrire une position de conception. Cette analyse place `clia` sur chacun, mesure les écarts, et propose.

Elle s'appuie sur trois sources de faits : les mesures de `ANL-001` sur le corpus de cent soixante-six dépôts, les propositions de `FND-002`, et ce que l'implémentation de la tâche 6 a démontré à l'usage.

## L'état actuel

Trois décisions ont été prises, et une a été démontrée fausse.

`ADR-001` D3 pose que l'identité d'une ressource est le champ `id`, de la forme `<PREFIXE>-<SLUG>`, le numéro de séquence n'étant qu'un rang.

`RES-001` fait dépendre le nom de fichier du cycle de vie : `<PREFIXE>-<SEQ>-<SLUG>.md` pour les cycles vivant et travail, `<PREFIXE>-<DATE>-<SLUG>.md` pour le cycle point fixe.

Le préfixe est déclaré par la définition du type, et `clia` le lit dans son frontmatter. Il n'existe aucune portée au-delà du dépôt, aucune information de fixité, et aucun mécanisme de dérivation inter-dépôts.

**Ce que l'implémentation a démontré.** La tâche 6 a produit, sans le chercher, la réfutation de la position implicite de la demande, qui décrivait l'identifiant comme `<PREFIX>-<SEQ>` :

```
$ clia res show 002
clia: identifiant ambigu : 002
      .dev/choses/CHO-002-deuxieme-chose.md
      .dev/ressources/RES-002-traces.md
```

Le numéro de séquence désigne un rang dans une série, et les séries coexistent. La distinction produite à cette occasion, entre l'**adresse** et l'**identité**, est le point de départ de cette analyse.

## Position de clia sur les quatorze axes

| Axe | Position actuelle | Verdict |
|---|---|---|
| **A1 Assignation** | Extrinsèque : le slug est choisi par l'auteur, le numéro attribué par `clia` | **Juste**, et incomplet : aucun identifiant intrinsèque n'existe |
| **A2 Autorité** | Aucune : le dépôt local alloue | **Juste** pour l'échelle actuelle |
| **A3 Lisibilité** | Mnémonique, sur les deux registres | **Juste**, et c'est l'atout principal du système |
| **A4 Portée d'unicité** | Le répertoire de type, pour le numéro. Le dépôt, pour l'`id` | **Faux** : rien ne garantit l'unicité entre dépôts |
| **A5 Granularité** | Non déclarée | **Faux** : le modèle ne dit pas si un `id` désigne une oeuvre ou une version |
| **A6 Stabilité** | Le slug est stable, le numéro peut bouger | **Juste**, mais non appliqué : le corpus renvoie par numéro |
| **A7 Résolvabilité** | Résoluble localement par `clia res show` | **Juste** pour l'usage interne |
| **A8 Vérifiabilité** | Aucune | **Faux** : rien ne permet de vérifier qu'une ressource citée est celle qu'on lit |
| **A9 Coût de gouvernance** | Nul | **Juste**, et c'est un choix à préserver |
| **A10 Traversée de frontière** | Indéterminée | Angle mort, comme dans la littérature |
| **A11 Dérivation** | Relations `remplace` et `est-remplacee-par` déclarées, non outillées | Indéterminée |
| **A12 Concurrence** | Non traitée : deux travaux parallèles produisent le même numéro | Indéterminée, et déjà signalée par `NON-001` Q7 |
| **A13 Longévité** | Le fichier survit sans `clia`, ce qui est acquis par le choix du markdown | **Juste** |
| **A14 Ergonomie** | Bonne : identifiants courts, lisibles, dictables | **Juste**, et c'est ce qu'il faut protéger |

Cinq positions justes, six indéterminées, trois fausses. Les trois fausses, A4, A5 et A8, sont exactement celles qui bloquent la réutilisation hors du dépôt.

## Ce que les faits du corpus imposent

`ANL-001` fournit quatre mesures qui contraignent toute proposition.

**Le numéro n'a jamais été un identifiant, et le corpus le prouve depuis un an.** Douze numéros de skill sur vingt portent plusieurs noms selon le dépôt, `skl-004` en portant cinq. Un dépôt porte sept ADR dont trois paires de titres dupliqués, jamais détectées. Ce que la tâche 6 a démontré sur un dépôt d'essai est déjà vrai à l'échelle du corpus.

**Le renommage coûte cher et il est manuel.** Le passage d'un préfixe `RES` à `DOS` dans un dépôt voisin a demandé six corrections à la main. Toute proposition qui multiplie les renommages est disqualifiée.

**Il n'y a pas d'adresse stable pour la majorité des dépôts.** Quatre-vingt-quatorze dépôts sur cent soixante-six n'ont aucun remote. Plusieurs remotes ne correspondent pas au nom du répertoire local. La stratégie des modules Go, qui emploie l'emplacement comme nom, se heurte donc à un obstacle mesuré : dans ce corpus, l'emplacement n'existe pas ou il ment.

**Le travail se fait par vagues, avec des creux de quatre mois.** Un identifiant qu'il faut comprendre avant de s'en servir sera mal employé à la reprise. C'est un argument de poids en faveur de la lisibilité, donc contre l'adressage par contenu comme identifiant principal.

## Suggestions

Dix suggestions, chacune rattachée à une proposition de `FND-002` et à un fait de `ANL-001`, avec son coût.

### S1 - Nommer les deux registres qui existent déjà

**Proposition.** Reconnaître explicitement deux identifiants de natures distinctes, au lieu de laisser croire qu'il n'y en a qu'un.

| Registre | Forme | Portée | Usage |
|---|---|---|---|
| **Adresse** | `<PREFIXE>-<SEQ>` | Un répertoire de type | Ligne de commande, conversation, coup d'oeil |
| **Identité** | `<PREFIXE>-<SLUG>` | Le dépôt | Renvois entre ressources, frontmatter |

**Fondement.** `FND-002` proposition 2 : les familles qui fonctionnent portent plusieurs identifiants. Les systèmes de petnames formalisent exactement ce partage entre noms locaux et noms globaux.

**Coût.** Nul. Les deux existent déjà ; seul leur statut n'est pas écrit. `clia res ls` affiche l'adresse, le frontmatter porte l'identité.

**Ce que cela règle.** L'ambiguïté conceptuelle qui a produit la contradiction entre `ADR-001` D3 et la demande de la tâche 6.

### S2 - Déclarer le niveau de granularité de l'identité

**Proposition.** Écrire que l'`id` désigne une **oeuvre** au sens de FRBR, c'est-à-dire ce qui persiste à travers les révisions, et non une version.

**Fondement.** `FND-002` proposition 3 : un identifiant qui ne dit pas à quel niveau il s'applique confond l'oeuvre et le fichier. FRBR distingue quatre niveaux.

**Coût.** Une section dans `RES-001`.

**Ce que cela règle.** L'axe A5, faux aujourd'hui. Et cela rend intelligible pourquoi le slug est stable alors que le contenu change : le slug nomme l'oeuvre.

**Conséquence à accepter.** Si l'`id` désigne l'oeuvre, alors le champ `version` du frontmatter désigne l'expression, et une empreinte désignerait la manifestation. Les trois niveaux sont alors portés par trois champs distincts, ce qui est cohérent.

### S3 - Ajouter une portée de dépôt, par extension et non par remplacement

**Proposition.** L'identité globale d'une ressource est `<origine>:<PREFIXE>-<SLUG>`, où `<origine>` identifie le dépôt. L'identité locale reste inchangée et demeure la forme employée à l'intérieur du dépôt.

**Fondement.** `FND-002` proposition 5 : la traversée de la frontière se fait par extension du noyau, jamais par remplacement. C'est le mécanisme du SWHID, dont le coeur reçoit des qualificateurs contextuels, et celui du GroupVersionKind de Kubernetes, où le groupe qualifie la sorte.

**Coût.** Faible, et différé : rien ne change tant qu'aucun renvoi inter-dépôts n'existe.

**Ce que cela règle.** L'axe A4, et la question QR8 que la littérature laisse ouverte.

**Difficulté mesurée.** Que vaut `<origine>` ? La stratégie des modules Go emploie l'URL du dépôt, mais `ANL-001` établit que quatre-vingt-quatorze dépôts sur cent soixante-six n'en ont pas. Trois options, par coût croissant : le nom du répertoire local, qui est gratuit et fragile ; un identifiant déclaré dans un fichier du dépôt, qui coûte une convention ; l'URL du remote, qui est la plus juste et qui n'existe pas pour la majorité des dépôts. La deuxième est recommandée, et elle recoupe le fichier d'état d'installation que `ADR-002` réclame déjà sans qu'il existe.

### S4 - Rendre l'empreinte calculable, sans la stocker

**Proposition.** `clia` sait calculer et vérifier une empreinte de contenu à la demande. L'empreinte n'est pas stockée dans le frontmatter.

**Fondement.** `FND-002` QR4 : la citation doit permettre de vérifier que ce qui est récupéré est ce qui a été cité, ce qui suppose de porter la fixité **à côté** du nom. Et `FND-002` proposition 4 : seul l'identifiant intrinsèque est vérifiable sans son émetteur.

**Coût.** Une commande. Le stockage est refusé délibérément : une empreinte inscrite dans un fichier devient fausse à la première modification, et le corpus a montré ce que devient une information qui doit être tenue à jour à la main.

**Ce que cela règle.** L'axe A8, faux aujourd'hui. Cela donne à `clia` le seul identifiant intrinsèque du système, employé pour la vérification et non pour la désignation.

### S5 - Faire de clia l'attributeur du numéro, et accepter que le numéro soit local

**Proposition.** Confirmer que `clia` attribue le numéro, ce que l'implémentation de la tâche 6 fait déjà, et écrire que le numéro est unique dans un répertoire de type, non dans le dépôt.

**Fondement.** `ANL-001` D1, et la démonstration de la tâche 6.

**Coût.** Nul, la fonction existe.

**Ce que cela ne règle pas.** Deux travaux parallèles produiront le même numéro. C'est acceptable si le numéro n'est qu'une adresse, et inacceptable s'il sert d'identité. C'est un argument supplémentaire pour S1.

### S6 - Traiter la dérivation par relation, jamais par l'identifiant

**Proposition.** Conserver les relations `derive-de`, `remplace` et `est-remplacee-par`, et refuser d'encoder la filiation dans l'identifiant.

**Fondement.** `FND-002` QR7 : encoder la filiation dans l'identifiant produit des identifiants qui s'allongent à chaque dérivation, alors que la déclarer à côté la rend interrogeable. Le champ du versionnage des données modélise la provenance par PROV-O et PAV.

**Coût.** Nul, la décision est déjà prise par `RES-001`.

**Ce que cela ajoute.** Une conséquence forte que `RES-001` n'écrit pas : une oeuvre dérivée reçoit une **identité propre** et déclare sa filiation. Un fork n'hérite pas de l'identifiant de son origine, sans quoi deux oeuvres au sens de FRBR seraient confondues.

### S7 - Séparer le renommage de la correction

**Proposition.** Distinguer deux opérations que `RES-001` traite aujourd'hui de la même manière. Corriger une faute de frappe dans un slug est une correction, qui conserve l'identité et enregistre l'ancienne forme. Changer le sujet d'une ressource est un changement d'identité, qui produit `remplace` et `est-remplacee-par`.

**Fondement.** `ANL-001` : le changement de préfixe a coûté six corrections manuelles, et `RES-001` reconnaît que l'identité est ce qui coûte le plus cher à changer. `FND-002` QR7 pose que la dérivation se déclare.

**Coût.** Un champ facultatif `id-anterieurs`, et une règle dans `RES-001`.

**Ce que cela règle.** La question Q6 de `NON-001`, qui posait exactement ce problème : traiter toute correction de slug comme un changement d'identité crée une ressource morte à chaque coquille.

### S8 - Écrire l'ergonomie comme une exigence, puisque la littérature ne la traite pas

**Proposition.** Inscrire dans `RES-001` que l'identité doit rester dictable et reconnaissable à l'oeil, et en tirer trois contraintes vérifiables : un slug de trois à cinq mots, sans accent, et distinct des autres slugs du même type au premier coup d'oeil.

**Fondement.** `FND-002` axe A14 : aucune littérature ne traite l'ergonomie de saisie, alors que c'est la première exigence de la demande. Et `ANL-001` : le travail se fait par vagues avec des creux de quatre mois, donc l'identifiant doit être compréhensible sans effort à la reprise.

**Coût.** Trois lignes, et un contrôle à ajouter à `skl-001-ressource`.

**Ce que cela protège.** L'axe A3 et l'axe A14, les deux seuls sur lesquels `clia` est meilleur que les systèmes de la littérature. C'est un avantage à défendre explicitement, parce que chaque amélioration d'unicité le menace.

### S9 - Traiter le bundle comme une ressource unique, à index

**Proposition.** Une ressource peut être un répertoire portant un `index.md`. L'identité est celle de l'`index.md`. Les fichiers internes ne portent pas de type de ressource autonome.

**Fondement.** `FND-002` proposition 3 sur la granularité, et le format de bundle avec `index.md` en racine, éprouvé dans un dépôt voisin du corpus.

**Coût.** Une règle dans `RES-001`, et le retrait du frontmatter typé sur huit fichiers de `ANL-001`.

**Ce que cela règle.** `NON-012`, ouverte par la tâche 6 : `clia res ls` compte neuf analyses là où il y en a deux.

### S10 - Ne rien décider sur l'échelle globale avant qu'un deuxième dépôt existe

**Proposition.** Suspendre toute décision sur l'espace de noms global, la résolution inter-dépôts et le format de `<origine>` jusqu'à ce qu'un deuxième dépôt consomme `clia`.

**Fondement.** `ANL-002` a déjà retenu ce critère pour la localisation du CLI, et il vaut ici pour la même raison. `FND-002` établit par ailleurs que toutes les stratégies de gouvernance documentées sont disproportionnées pour un système à un acteur.

**Coût.** Nul, et un risque : décider plus tard coûte plus cher si des renvois inter-dépôts ont été écrits entre-temps. S3 est conçue pour que ce risque soit nul, l'extension du noyau ne cassant rien.

## Ordre recommandé

| Rang | Suggestion | Motif |
|---|---|---|
| 1 | S1, nommer les deux registres | Coût nul, règle la contradiction la plus visible |
| 2 | S2, déclarer la granularité | Coût d'une section, débloque S4 et S9 |
| 3 | S7, séparer renommage et correction | Répond à une question déjà posée, coût faible |
| 4 | S8, écrire l'exigence d'ergonomie | Protège le seul avantage du système |
| 5 | S9, le bundle | Règle une objection ouverte |
| 6 | S5, l'attribution du numéro | Confirme un état de fait |
| 7 | S6, la dérivation | Confirme et complète une décision prise |
| 8 | S4, l'empreinte calculable | Demande une commande, donc du temps d'outillage |
| 9 | S3, la portée de dépôt | À écrire maintenant, à appliquer plus tard |
| 10 | S10, suspendre le reste | Décision de ne pas décider |

Les cinq premières ne demandent aucun code et règlent trois des questions ouvertes.

## Ce que je ne recommande pas, et pourquoi

**Un identifiant décentralisé au sens du W3C.** Les DID offrent la preuve cryptographique du contrôle et la résolution sans agence émettrice, et supposent une méthode de résolution, donc une infrastructure. Pour un système documentaire à un acteur, le rapport est sans commune mesure.

**Une chaîne de blocs pour le nommage.** C'est la seule manière connue de contourner le trilemme de Zooko, et `FND-002` établit que le contournement suppose un consensus coûteux. Hors de proportion.

**Un UUID comme identité principale.** RFC 9562 garantit l'unicité sans coordination, et détruit la lisibilité. Ce serait sacrifier l'axe A3 et l'axe A14, les deux seuls où `clia` est bon. Un UUID resterait pertinent pour l'édition collaborative simultanée, qui n'est pas un cas d'usage actuel.

**Un identifiant adressé par contenu comme identité principale.** Même raison. L'empreinte a sa place en S4, pour la vérification, non pour la désignation.

**Encoder le type, la version et la filiation dans une seule chaîne.** La tentation est forte et le résultat est un identifiant illisible qui change à chaque modification. La littérature converge : le noyau reste stable, le contexte s'ajoute en qualificateurs.

## Les quatre modalités de réutilisation, appliquées à clia

| Modalité | Ce qui manque aujourd'hui | Suggestion |
|---|---|---|
| Dans un autre projet | Une portée qui dépasse le dépôt | S3 |
| Par une autre personne | Un moyen de vérifier ce qu'on a reçu | S4 |
| En édition collaborative | Rien : le cas n'existe pas encore | S10, et un UUID si le cas apparaît |
| En oeuvre dérivée | Une identité propre à la dérivée et une filiation déclarée | S6 |

## Objections que cette analyse soulève contre elle-même

**Dix suggestions, c'est beaucoup pour un système qui n'a pas de deuxième utilisateur.** `NON-002` conteste précisément le coût du modèle. Les cinq premières ne coûtent que de l'écriture, et les cinq suivantes sont soit différées, soit déjà faites. Mais l'objection tient : rien ne prouve que ce travail soit nécessaire maintenant.

**S3 suppose un identifiant de dépôt qui n'existe pas.** La difficulté est signalée dans la suggestion, et elle est réelle : la stratégie la plus juste est inapplicable dans un corpus où la majorité des dépôts n'ont pas d'adresse.

**S2 change le sens de ce qui existe.** Déclarer que l'`id` désigne une oeuvre est une lecture rétrospective. Rien ne garantit que les seize identités déjà écrites aient été choisies avec ce sens.

**L'analyse ne mesure rien.** Elle place `clia` sur quatorze axes par jugement, non par mesure. Le seul fait mesuré qu'elle produit est la démonstration d'ambiguïté de la tâche 6.

## Relations

- `derive-de` [FND-002](../fondations/FND-002-identifiants-dans-les-systemes-decentralises.md)
- `derive-de` [ANL-001](ANL-001-observation-corpus-repos-et-pratiques/analyse-critique.md)
- `reference` [ADR-001](../adr/ADR-001-adoption-de-la-notion-de-ressource.md)
- `reference` [RES-001](../ressources/RES-001-ressource.md)
- `reference` [NON-001](../objections/NON-001-identite-et-nommage.md)
- `reference` [NON-012](../objections/NON-012-granularite-de-la-ressource.md)

## Lacunes

**Aucun coût chiffré.** Les coûts sont qualifiés de nuls, faibles ou différés, sans estimation.

**Le cas de l'édition collaborative n'est pas travaillé.** `FND-002` QR6 y répond techniquement, et aucune des dix suggestions ne l'instrumente, faute de cas d'usage.

**La question de la révocation n'est pas posée.** Que devient l'identité d'une ressource supprimée ? Ni `RES-001`, ni cette analyse ne le disent.
