# SPC-002 — Le modèle de ressource : type, instance, provenance

**Répond à** `RQF-002`, `RQF-005`.
**Contrainte par** `RQN-004`, `RQN-006`.

## Objet

Fixer les quatre entités du modèle et ce qui les distingue. C'est le vocabulaire
dont tout le reste dépend, et `RQN-004` exige qu'il soit établi à un seul
endroit : celui-ci.

## S1 — Quatre entités, et pas une de plus

| Entité | Ce que c'est | Exemple |
|---|---|---|
| **Type** | ce qu'une catégorie de ressources est : forme, emplacement, régime | « analyse » |
| **Instance** | un objet de ce type, existant, adressable | l'analyse numéro 1 de ce dépôt |
| **Dépôt** | l'unité qui déclare ce qu'elle est et ce qu'elle tient | ce dépôt-ci |
| **Provenance** | le dépôt d'où une chose a été reprise | le dépôt de l'outil |

**Rien d'autre n'est une ressource.** Une commande, une extension, une catégorie
de rangement, une fonctionnalité : ce sont des concepts *de* quelque chose, et
non des choses en soi. Le test est simple et il tranche : *si l'objet n'existe
que « de » quelque chose, ce n'est pas une ressource.*

## S2 — Le type est une donnée, jamais du code

Un type est déclaré par une **définition**, et une définition est une donnée
lue par l'outil. Le code ne connaît aucun type.

Un répertoire est reconnu comme portant un type **parce qu'il porte une
définition**, et pour aucune autre raison. C'est le seul critère, et il rend
l'ajout d'un type identique à l'ajout d'un fichier.

Une définition déclare, au minimum :

| Champ | Ce qu'il fixe |
|---|---|
| nom, titre, préfixe | comment le type se nomme et comment ses instances s'adressent |
| version | la version de la définition elle-même |
| emplacement | où vivent les instances, motif de nom compris |
| gabarit | la structure d'une instance neuve |
| régime d'édition | qui écrit : l'humain, l'agent, ou les deux |
| cycle de vie | comment le type vieillit, et quels états ses instances portent |
| structure attendue | champs et sections d'une instance |
| relations admissibles | vers quels types une instance peut renvoyer |

**Tout champ déclaré est employé par une capacité livrée.** Un champ que rien
n'exploite est retiré de la définition (`RQF-002` f, principe P2). C'est la
règle la plus contraignante de cette spécification, et celle qui empêche la
dérive mesurée en G2 et en G3.

## S3 — L'adresse d'une instance est locale et jetable

Une instance porte une adresse de la forme `<PRÉFIXE>-<SÉQUENCE>`, courte et
tapable sans copier-coller.

**Cette adresse n'est pas une identité.** Elle vaut à l'intérieur d'un dépôt.
Corriger le nom lisible d'un fichier n'a donc aucune conséquence, et déplacer un
fichier ne casse aucun renvoi.

**Conséquence à assumer :** deux dépôts peuvent porter la même adresse pour deux
choses différentes. Une identité valable hors du dépôt reste à concevoir
(`ANL-001` D7), et l'absence est déclarée ici plutôt que comblée.

## S4 — Une ressource est composable, et son support est indifférent

Une ressource peut être un fichier, un répertoire de fichiers, ou un dépôt
entier. Chaque atome d'un composite est une ressource de plein droit, **qui se
lit seule**.

Le test d'un mauvais découpage : *un fichier qui ne se comprend qu'après avoir
lu son composite n'est pas un atome, c'est une section mal placée.*

Une ressource n'est ni sa représentation, ni son support, ni son format. La même
ressource peut être rendue sous plusieurs formes. Ce qui découle de ce principe
— la transformation d'une forme à une autre — n'est pas spécifié ici, et aucune
génération ne l'a engagé (`ANL-001` D9).

## S5 — Le dépôt déclare ce qu'il est et ce qu'il tient

Chaque dépôt porte une **déclaration** versionnée avec lui, qui dit :

- ce que le dépôt est : sa provenance, sa version, sa maturité, sa génération ;
- ce qu'il tient d'ailleurs : pour chaque chose, quoi, d'où, en quelle version.

Cette déclaration est l'état voulu de `SPC-003`. Elle est la **seule** source de
ce qui est installé : aucun registre parallèle n'est tenu, parce qu'un registre
parallèle finit par mentir.

## S6 — Provenance et catégorie ne sont pas la même chose

| Notion | Ce qu'elle fait | Ce qu'elle ne fait pas |
|---|---|---|
| **Provenance** | désigne d'où une chose vient ; propre au dépôt, déclarée une fois | ranger |
| **Catégorie** | range des types dans un répertoire | qualifier une provenance |

Toutes les ressources d'un dépôt partagent sa provenance, quelle que soit leur
catégorie. La confusion des deux a été commise puis corrigée dans la génération
courante, et ses traces subsistent dans les données de production
(`ANL-001` C11).

**La profondeur de rangement s'arrête à deux niveaux.** Un troisième ne ferait
que déplacer la question de savoir où chercher.

## S7 — Aucun catalogue central

Ce qui se rattache à un type vit **sous ce type**, et l'outil le trouve par
balayage.

**Ce que cela coûte :** plusieurs motifs de recherche au lieu d'un.
**Ce que cela évite :** un catalogue qui ne dit pas de quoi chaque entrée relève,
et qu'il faut maintenir en plus des choses elles-mêmes.

Le même arbitrage a été tranché dans le même sens pour les commandes
(`SPC-001` S3), et c'est le même principe : *le noyau trouve, il n'énumère pas*.

## S8 — Aucun emplacement vide

Un emplacement n'existe que s'il porte quelque chose. Les emplacements admis
sont **admis**, non **exigés**.

Motif : une arborescence de répertoires vides oblige le lecteur à les ouvrir un
par un pour découvrir qu'il n'y a rien. Ce qui existe se voit ; ce qui est
possible se lit dans cette spécification.

## Origine

`SPC-001` et `REQ-003` de la génération courante, dont S1, S6, S7 et S8 sont la
reprise. S2 dernier alinéa et S3 dernier alinéa sont nouveaux :
ils appliquent le principe P2 de `ANL-001` au modèle lui-même.
