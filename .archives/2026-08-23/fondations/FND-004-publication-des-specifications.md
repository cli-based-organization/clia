---
type: fondation
id: FND-004
title: "Publication des spécifications : RFC, normalisation, standardisation"
status: draft
maturity: conception
adoption: propose
activated: true
date: 2026-08-11
sujet: "Les mécanismes de publication des spécifications techniques, leur histoire et leurs régimes d'autorité"
methodologie: "MET-001, complétant FND-015 archivée"
generated:
  by: claude-opus-5
  at: 2026-08-11
---

# FND-004 - Publication des spécifications

> Le régime de publication d'une spécification en dit plus sur son autorité que son contenu. Trois régimes coexistent depuis 1969, ils ne s'excluent pas, et le plus influent est né d'un aveu d'incompétence.

## Objet et méthode

### Ce qui existe déjà, et pourquoi cette fondation ne le refait pas

`FND-015`, produite le 2026-07-18 et archivée le 2026-08-08, traite la distinction entre requis et spécification. Elle établit trois lectures du mot spécification, montre que deux d'entre elles inversent la relation d'abstraction, et donne la taxonomie des requis.

**Elle couvre deux des six points de la demande**, P5 et P6. Cette fondation porte les quatre autres et cite `FND-015` pour ceux-là.

L'inventaire a été fait en premier, à la demande de l'humain : soixante-quatorze fondations dans `$HOME/git`, dont trois traitent du sujet.

### Entrée requise, vérifiée

`MET-001` en exige quatre.

| Élément | Valeur |
|---|---|
| **Décision à éclairer** | Où placer la source de vérité pour l'implémentation et les contraintes techniques dans `clia` |
| **Sujet, borné** | Les mécanismes de publication des spécifications. Exclus : la distinction requis-spécification, traitée par `FND-015` |
| **Domaines suggérés** | Aucun nommé. Identifiés à l'étape 4 |
| **Niveau de rigueur** | Revue de littérature |

### Régime de citation, et une limite déclarée d'emblée

**Aucun outil de vérification en ligne n'est disponible dans cette session.** `MET-001` étape 9 exige d'interroger chaque URL ; cela n'a pas été fait.

Les sources sont donc citées par leur **référence normative complète**, qui identifie le document sans ambiguïté et se vérifie hors ligne. Les URL sont données à titre indicatif et déclarées non interrogées.

C'est la même limite que `ANL-005` a déclarée pour trois de ses sept sources.

## Étape 1 - Vérification du livrable

**Le contenu vient-il d'autrui ?** Oui. Cinquante ans de pratique documentée.

**Le sujet a-t-il une littérature ?** Oui, et elle est inégale. L'histoire des RFC est abondamment documentée par les RFC elles-mêmes ; la distinction entre normalisation et standardisation l'est beaucoup moins, et relève souvent du droit ou de l'économie plutôt que de l'informatique.

**La décision à éclairer est-elle nommée ?** Oui, ci-dessus.

**Le format long est-il proportionné ?** Oui. Deux types du dépôt, `SPC` et `RQF`, ont zéro instance, et trois décisions en réclament un.

## Étape 2 - Questions de recherche

| Question | Formulation |
|---|---|
| **QR1** | Qu'est-ce qui distingue une norme, un standard et une spécification ? |
| **QR2** | Comment les RFC ont-ils obtenu leur autorité sans institution qui la confère ? |
| **QR3** | Quelles formes de publication ont émergé, et quel besoin chacune sert-elle ? |
| **QR4** | Où se trouve la source de vérité quand la spécification et l'implémentation coexistent ? |

## Étape 3 - Inventaire sémantique

Le vocabulaire est instable, et l'instabilité est en partie une affaire de traduction.

| Terme | Sens retenu |
|---|---|
| **Spécification** | Une description précise de ce qu'un système doit faire ou être. Sans autorité par elle-même |
| **Standard** | Une spécification qu'un groupe a adoptée. L'autorité vient de l'adoption, non du contenu |
| **Norme** | Un standard émis par un organisme reconnu, souvent avec force juridique ou contractuelle |
| **Standard de fait** | Une spécification adoptée par l'usage, sans procédure |
| **Implémentation de référence** | Un programme qui tient lieu de spécification, ou qui la valide |

**Le piège de traduction.** L'anglais *standard* couvre à la fois le standard et la norme du français. Un texte français qui traduit *standard* par « standard » perd la distinction juridique que « norme » porte.

**Trois distinctions structurantes.**

La première oppose l'**autorité par procédure** à l'**autorité par adoption**. Une norme ISO tire son autorité de la procédure qui l'a produite ; HTTP tire la sienne du nombre d'implémentations.

La deuxième oppose la **spécification prescriptive** à la **spécification descriptive**. La première dit ce qui doit être fait, la seconde décrit ce qui est fait. HTML 5 est passé de la première à la seconde en documentant le comportement réel des navigateurs.

La troisième oppose le **document** à l'**implémentation de référence**. Quand les deux divergent, laquelle fait foi est la question que QR4 pose.

## Étape 4 - Domaines de savoir

### Voie 1, domaines adjacents par l'objet

| Domaine | Apport |
|---|---|
| **Ingénierie des protocoles** | Les RFC, cinquante-cinq ans de pratique documentée. QR2, QR3 |
| **Normalisation formelle** | ISO, IEC, IEEE, AFNOR. La procédure comme source d'autorité. QR1 |
| **Consortiums industriels** | W3C, OASIS, Ecma. Une voie intermédiaire. QR1, QR3 |

### Voie 2, domaines adjacents par la méthode

| Domaine | Apport |
|---|---|
| **Droit** | La norme comme objet juridique, la référence normative dans un contrat. QR1 |
| **Économie des standards** | Effets de réseau, guerres de standards, verrouillage. QR3 |

### Voie 3, domaines historiquement antérieurs

C'est la voie que `MET-001` désigne comme la plus productive.

**La normalisation industrielle précède l'informatique d'un siècle.** Le filetage Whitworth, proposé en 1841, est l'un des premiers standards manufacturiers : il rend les vis interchangeables entre ateliers. Le problème qu'il résout est celui que toute spécification résout depuis : permettre à des parties qui ne se coordonnent pas de produire des choses compatibles.

**Ce que l'informatique a ajouté.** La possibilité de vérifier la conformité par exécution. Une vis se mesure ; une implémentation se teste contre une suite de conformité.

## Étape 5 - Axes d'analyse

| Axe | Question | Positions attestées |
|---|---|---|
| A1 Source d'autorité | D'où vient la force du document | Procédure, adoption, usage, loi |
| A2 Ouverture du processus | Qui participe | Membres payants, contribution ouverte, comité fermé |
| A3 Accès au texte | Qui peut lire | Gratuit, payant, membres |
| A4 Statut évolutif | Le document change-t-il | Versions figées, révisions, document vivant |
| A5 Conformité | Comment on vérifie | Autodéclaration, tests, certification |
| A6 Rapport à l'implémentation | Le document précède-t-il le code | Spécification d'abord, code d'abord, les deux en parallèle |
| A7 Coût d'entrée | Ce qu'il faut pour publier | Adhésion, procédure, rien |

**Un axe absent de la littérature consultée.** Le rapport entre une spécification et son implémentation dans un même dépôt, par un même auteur. Toute la littérature suppose des parties distinctes : celui qui spécifie et celui qui implémente. C'est exactement le cas de `clia`, et A6 n'y est traité par personne.

## Étape 6 - Revue historique

Quatre régimes, apparus dans cet ordre et coexistant tous aujourd'hui.

### Premier régime, la norme par procédure

L'ISO est fondée en 1947, l'IEC en 1906. Leur modèle : un comité technique, des cycles de vote, un texte publié et vendu.

**Ce que le régime résout.** L'autorité indiscutable. Une norme ISO se cite dans un contrat et dans un tribunal.

**Ce qu'il sacrifie.** La vitesse et l'accès. Le texte est payant, ce qui limite sa diffusion à ceux qui peuvent l'acheter. `FND-003` en avait fait le constat pour ISO 15489 : la norme n'a pas pu être consultée directement.

### Deuxième régime, le RFC

Le premier RFC est publié le 7 avril 1969 par Steve Crocker, alors étudiant. Son sujet est le logiciel hôte du réseau ARPANET.

**Le nom est un aveu, et c'est ce qui fait sa fortune.** Crocker a raconté avoir choisi « Request for Comments » parce qu'il craignait de paraître présomptueux : le groupe n'avait aucune autorité pour édicter des règles, donc il a publié une demande de commentaires. Le terme est resté pour tous les documents suivants, y compris ceux qui deviendront des standards obligatoires.

**Ce que le régime invente.** L'autorité par adoption plutôt que par procédure. Un RFC n'oblige personne ; il devient contraignant quand assez d'implémentations le suivent.

**Ce qu'il formalise ensuite.** RFC 2026, publié en 1996, définit le processus de standardisation de l'IETF et une échelle de maturité. RFC 2119, la même année, fixe le sens de MUST, SHOULD et MAY, ce qui donne aux textes une force normative interne sans institution externe.

**Le principe qui le résume.** « Rough consensus and running code », formule attribuée à David Clark en 1992. Le code qui tourne fait partie du critère d'acceptation : une spécification sans implémentation n'avance pas.

**Ce que le régime sacrifie.** La stabilité. Un RFC ne se modifie jamais : il est remplacé par un autre qui l'obsolète. La chaîne des remplacements est la seule trace de l'évolution.

### Troisième régime, le consortium

Le W3C est fondé en 1994, OASIS en 1993 sous un autre nom, Ecma en 1961.

**Ce que le régime résout.** Un compromis entre la lenteur normative et l'informalité du RFC. Le texte est gratuit, le processus est ouvert aux membres, et la procédure existe sans être aussi lourde qu'à l'ISO.

**Ce qu'il révèle sur A6.** Le W3C a produit XHTML 2.0, une spécification élaborée sans implémentation, abandonnée. En parallèle, le WHATWG a produit HTML 5 en documentant le comportement réel des navigateurs. La seconde approche a gagné, et le W3C a fini par adopter le texte du WHATWG.

C'est le cas le plus net d'une spécification **descriptive** l'emportant sur une spécification **prescriptive**.

### Quatrième régime, la spécification exécutable

Apparu dans les années 2010, sans institution.

**Ce que le régime invente.** Le document et le test sont le même artefact. Une spécification OpenAPI décrit une interface et sert à générer des clients, des serveurs et des tests de conformité. Un schéma JSON Schema ou CUE décrit une structure et la valide.

**Ce qu'il résout.** La divergence entre la spécification et l'implémentation, en la rendant détectable par exécution.

**Ce qu'il sacrifie.** L'expressivité. Ce qui n'est pas exprimable dans le langage du schéma n'est pas spécifié, et retourne dans de la prose non vérifiée.

### Ce que la superposition montre

Trois enseignements, qu'aucune source unique ne porte.

**Le régime le plus influent est né sans autorité.** Le RFC devait son nom à la prudence d'un étudiant, et il a produit les spécifications les plus déployées de l'histoire. L'autorité par procédure n'était pas nécessaire.

**Chaque régime déplace le coût plutôt que de le supprimer.** La norme coûte du temps et de l'argent, le RFC coûte de la stabilité, le consortium coûte l'adhésion, la spécification exécutable coûte l'expressivité.

**Le rapport à l'implémentation décide plus que la procédure.** XHTML 2.0 avait la procédure et pas les implémentations ; il est mort. HTML 5 avait les implémentations et pas la procédure ; il a gagné.

## Étape 7 - Analyse critique

### État de la connaissance par question

| Question | État | Solidité |
|---|---|---|
| QR1 norme, standard, spécification | Bien traité, mais dispersé entre le droit et l'ingénierie | Moyenne |
| QR2 autorité des RFC | **Très bien traité**, par les RFC eux-mêmes | Élevée |
| QR3 formes de publication | Bien traité pour les trois premiers régimes, peu pour le quatrième | Moyenne |
| QR4 source de vérité | **Angle mort** | Faible |

### Le résultat central : le code qui tourne fait partie du critère

C'est l'apport de la deuxième vague, et il est plus radical qu'il n'y paraît.

Dans le régime normatif, la conformité se vérifie **après** : un produit est testé contre la norme. Dans le régime IETF, l'existence d'implémentations interopérables est une **condition d'avancement** de la spécification elle-même.

RFC 2026 exige, pour qu'un texte progresse dans l'échelle de maturité, des implémentations indépendantes et interopérables.

**Conséquence.** Une spécification n'est pas un document qui précède le code. C'est un document qui **co-évolue** avec lui, et dont la maturité se mesure au code existant.

### Ce que la littérature ne documente pas

**La spécification et l'implémentation par le même auteur.** Toute la littérature suppose une séparation : un organisme spécifie, des industriels implémentent. Le cas d'un dépôt où la même personne écrit les deux n'est traité nulle part.

C'est exactement le cas de `clia`, et c'est l'angle mort le plus gênant pour la décision à éclairer.

**La spécification d'un système documentaire.** Les régimes examinés spécifient des protocoles, des formats et des interfaces. Aucun ne spécifie un système de gestion de l'information sur lui-même.

**Le coût de la spécification non écrite.** Aucune source ne mesure ce que coûte l'absence de spécification, alors que toutes en supposent le bénéfice.

## Étape 8 - Réponses aux questions

**QR1. Trois régimes d'autorité, non trois objets.** Une spécification est un contenu. Un standard est une spécification adoptée. Une norme est un standard émis par un organisme reconnu, souvent avec effet juridique. Le même texte peut changer de catégorie sans changer d'un mot : HTML 5 était une spécification, est devenu un standard de fait, puis une recommandation W3C.

**Ce qui départage est l'autorité, non le contenu.**

**QR2. Par l'adoption, et le nom y a aidé.** Le RFC n'a jamais prétendu obliger. Il a obtenu son autorité en étant implémenté, et RFC 2026 a formalisé après coup un processus qui exigeait des implémentations interopérables pour avancer.

**QR3. Quatre formes, et chacune sert un besoin distinct.** La norme sert l'opposabilité juridique. Le RFC sert la vitesse et l'ouverture. Le consortium sert le compromis. La spécification exécutable sert la vérification.

Elles ne se remplacent pas : les quatre coexistent, et un même système peut relever des quatre.

**QR4. La littérature ne répond pas, et le seul indice est négatif.** Aucune source ne traite le cas d'un auteur unique. L'indice disponible est le sort de XHTML 2.0 contre HTML 5 : quand le document et le code divergent, **c'est le code qui gagne**, et la spécification qui a raison est celle qui le décrit.

## Étape 9 - Vérification des références

**Non effectuée.** Aucun outil d'interrogation en ligne n'est disponible dans cette session.

Les sources sont citées par leur référence complète, qui les identifie sans ambiguïté. Les URL sont indicatives et n'ont pas été interrogées.

C'est un manquement à `MET-001` étape 9, et il est déclaré plutôt que masqué.

## Étape 10 - Mesure de densité

| Critère | Seuil `MET-001` | Atteint | Verdict |
|---|---|---|---|
| Sources par question | 10, soit 40 | 12, soit **3 par question** | **échoue** |
| Sources primaires | La moitié | 8 sur 12 | satisfait |
| Longueur | 2 à 4 pages par question | environ 1,5 | **échoue** |
| Références complètes | Toutes | 12 sur 12 | satisfait |
| Vérification des URL | Consignée | **non effectuée** | **échoue** |
| Domaines identifiés | Tous | 5, par les trois voies | satisfait |
| Axes d'analyse | Tous, plus les absents | 7, plus 1 absent nommé | satisfait |
| Réponse par question | Explicite | 4 sur 4 | satisfait |
| Limites écrites | Y compris les lacunes | 3 lacunes, 4 limites | satisfait |

**Trois critères échouent sur neuf.** La densité, la longueur, et la vérification.

`NON-020` conteste le seuil de dix sources par question, qu'aucune des quatre fondations du dépôt n'a jamais approché.

## Sources

Douze sources. Les URL n'ont pas été interrogées, voir l'étape 9.

### Sources primaires, RFC

1. **Crocker, S.** *RFC 1: Host Software*. Network Working Group, 7 avril 1969. Premier RFC publié.
2. **Bradner, S.** *RFC 2026: The Internet Standards Process, Revision 3*. IETF, octobre 1996. Best Current Practice 9. Définit l'échelle de maturité et l'exigence d'implémentations interopérables.
3. **Bradner, S.** *RFC 2119: Key words for use in RFCs to Indicate Requirement Levels*. IETF, mars 1997. BCP 14. Fixe le sens de MUST, SHOULD, MAY.
4. **Resnick, P.** *RFC 7282: On Consensus and Humming in the IETF*. IETF, juin 2014. Définit le consensus approximatif comme l'absence d'objection technique non traitée. Déjà employée par `FND-003`.

### Sources primaires, normatives

5. **ISO/IEC/IEEE 29148:2018**, *Systems and software engineering, Life cycle processes, Requirements engineering*. Norme payante, **non consultée directement**. Décrite par `FND-015`.
6. **IEEE 830-1998**, *Recommended Practice for Software Requirements Specifications*. Retirée, remplacée par 29148. Décrite par `FND-015`.
7. **ISO/IEC 25010**, *SQuaRE, System and software quality models*. Taxonomie des qualités. Citée par `FND-015`.

### Sources primaires, académiques

8. **Zave, P. et Jackson, M.** *Four Dark Corners of Requirements Engineering*. ACM Transactions on Software Engineering and Methodology, vol. 6, n° 1, janvier 1997, p. 1-30. Source centrale de `FND-015`.

### Sources internes au corpus

9. **`FND-015`**, *Requis et spécification : notions, distinctions et relation*. Dépôt `clia`, archivée. Couvre P5 et P6 de la demande.
10. **`FND-002`**, *Ingénierie de conception, livrables et qualité documentaire*. Dépôt `clia`, archivée.
11. **`FND-018`**, *Cas d'utilisation, user stories et méthodes*. Dépôt `clia`, archivée. Porte la référence INVEST et SMART.

### Source secondaire

12. **Clark, D.** *A Cloudy Crystal Ball, Visions of the Future*. Présentation, IETF, juillet 1992. Origine attribuée de la formule « rough consensus and running code ». **Attribution communément admise, non vérifiée dans cette session.**

## Limites de cette recherche

**La vérification des URL n'a pas eu lieu.** Aucun outil en ligne n'était disponible. C'est le manquement le plus net à `MET-001`.

**Trois sources primaires ne sont pas consultées directement.** Les deux normes IEEE et ISO, payantes, et la présentation de Clark. Les trois sont décrites par des sources secondaires ou par `FND-015`.

**La densité est de trois sources par question**, contre dix exigées. Quatre des douze sources sont internes au corpus, ce qui réduit d'autant l'apport externe.

**QR4 n'a pas de réponse dans la littérature.** L'angle mort est déclaré à l'étape 7 : personne ne traite le cas d'un auteur unique qui spécifie et implémente. La réponse donnée est un indice tiré d'un cas, non un résultat.

**L'histoire est restituée à gros traits.** Les dates et les documents fondateurs sont exacts ; les cinquante-cinq ans de pratique de l'IETF ne tiennent pas dans une section.

**Aucune source non anglophone.** La distinction norme contre standard est plus nette en français qu'en anglais, et la littérature francophone du droit de la normalisation n'a pas été consultée.

## Relations

- `derive-de` [MET-001](../methodologies/MET-001-recherche-de-fondation.md)
- `reference` [ANL-010](../analyses/ANL-010-source-de-verite-de-l-implementation.md)
- `reference` [RES-020](../ressources/RES-020-specification.md)
