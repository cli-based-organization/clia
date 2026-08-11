---
type: objection
id: NON-004
title: "Frontière entre Ontologie, Concept, Fondation et Analyse"
status: draft
initiateur: agent
effet: conditionnel
etat: ouverte
porte-sur: [RES-006, RES-007]
---

# NON-004 - Frontière entre Ontologie, Concept, Fondation et Analyse

> Quatre types portent du savoir et se recoupent. Le concept n'a aucune matière dans le corpus, l'ontologie du système n'existe pas alors que les définitions en dépendent, et la fondation est un format trop lourd pour le besoin observé.

## Journal

- 2026-08-09 : ouverte par l'agent, à la production du premier jet des ressources fondamentales.

## Ce qui est contesté

La répartition du savoir entre quatre types, et deux manques immédiats.

`RES-006` et `RES-007` proposent un départage en une question, d'où vient le contenu : d'autrui avec sources pour la fondation, d'un existant observé pour l'analyse, d'un accord sur les mots pour l'ontologie, de l'élaboration propre pour le concept. Ce critère est net sur le papier ; il n'a jamais été appliqué.

Le premier manque est une contradiction interne du jet : les sept définitions emploient des relations (`derive-de`, `remplace`, `reference`, `objecte-a`, `repond-a`, `specifie`) que rien ne définit. Le vocabulaire provisoire est écrit dans `RES-001`, ce qui en fait une source parallèle, exactement le défaut que le modèle prétend éviter. L'ontologie du système est nécessaire et absente.

Le second manque est de calibrage. `ANL-001` établit au défaut D6 que le savoir accumulé n'est pas mobilisable : onze dépôts de technotes dont six sans aucun fichier versionné, trois dépôts de notes IA vides dans trois groupes. La seule ressource de savoir outillée est la fondation, format long, exhaustif et sourcé. Le besoin observé est de conserver des notes de deux lignes, et le seul outil disponible en demande dix pages.

## Pourquoi cela ne peut pas rester implicite

Le corpus a perdu sept concepts en douze mois : topologie de style, phore, pilier de communication, distillation, extreme-smart, réflexivité, objection sociocratique. Trois d'entre eux sont des notions dont le système actuel dépend sans les avoir écrites.

En parallèle, il a produit cinquante-deux fondations et vingt-huit analyses. Le savoir n'est pas absent : il est mal réparti, et la forme légère manque.

L'`INTENTION.md` de `clia` affirme fournir nativement des capacités de mobilisation et d'utilisation du savoir. `ANL-001` conteste cette affirmation. Cette objection est le lieu où la conception doit y répondre, ou l'intention doit être révisée.

## Questions

### Q1 - Le concept est-il un type distinct, ou une entrée d'ontologie développée ?

`RES-007` le distingue par la forme : entrée de lexique contre document d'une à trois pages. La position concurrente est qu'une ontologie admette des entrées longues, ce qui économise un type. `ANL-001` note que le concept est le type sans aucune matière et le plus susceptible de proliférer.

**Réponse.**

L'ontologie est un ensemble de concepts et leurs relations.

Il faut comprendre ce qu'est clia: un système de manipulation avancé d'information.
L'usage d'aucune ressource n'est obligatoire. Ils sont utilisables au besoin.

Donc, CPT peut être utiliser pour des concepts importants qui seront utilisés et réutilisés à plusieurs endroits. Si ce n'est pas le cas, un CPT peut être définit dans un fichier ONT.

Conséquence => nous avons besoin de pouvoir définir une ressource dans un document ressource. Comment implémenter ce feature? documenter un ISU à propos de cette question

### Q2 - Où vit le vocabulaire de relations, en attendant `ONT-001` ?

Il est aujourd'hui dans `RES-001`, ce qui est une source parallèle assumée par défaut. Trois positions : produire `ONT-001` immédiatement ; laisser le vocabulaire dans `RES-001` et le déclarer comme provisoire daté ; renoncer aux relations typées jusqu'à ce qu'un outil les exploite.

**Réponse.**



### Q3 - Faut-il une forme légère de conservation du savoir, plus courte que la fondation ?

Le besoin est mesuré : six dépôts de technotes sans fichier versionné, parce que le seuil d'entrée est disproportionné pour deux commandes GPG. Candidats : une note (`NOT`), une entrée d'ontologie enrichie, ou un recueil par domaine sur le modèle du recueil de faits de `RES-005`. Ou bien : aucune, et le savoir léger reste hors du modèle.

**Réponse.**

### Q4 - Que faire des sept concepts orphelins du corpus ?

Trois sont critiques parce que le système en dépend : `extreme-smart`, `distillation`, `objection sociocratique`. Faut-il les écrire dans cette session, les inscrire à un registre de dette, ou les laisser où ils sont ?

**Réponse.**

### Q5 - La frontière fondation contre analyse est-elle tenue en pratique ?

`ADR-001` de `clia` la tranche : l'analyse porte sur un existant matériel, la fondation sur la littérature. Or `micrologic-clients` porte quatre fondations dont deux, sur la journalisation des faits privés et sur la persuasion, sont des élaborations propres autant que des recherches. Selon le critère de `RES-007`, ce sont des concepts. Faut-il reclasser, ou admettre que le critère est indicatif ?

**Réponse.**

### Q6 - Le seuil d'admission des concepts à trois conditions est-il applicable ?

`RES-007` exige qu'un concept soit employé dans deux ressources, qu'il ne se réduise pas à une entrée d'ontologie, et qu'il change une décision. La première condition crée un problème d'amorçage : un concept nouveau n'a aucun emploi attesté au moment où on l'écrit.

**Réponse.**

### Q7 - L'affirmation de `INTENTION.md` sur la mobilisation du savoir est-elle maintenue ?

`ANL-001` établit que rien dans le corpus ne la soutient. Trois positions : la maintenir et produire le mécanisme qui la justifie ; la reformuler comme une intention à atteindre plutôt qu'une propriété acquise ; la retirer. `INTENTION.md` est en édition humaine exclusive : seule l'humain peut trancher.

**Réponse.**

## Ce qui lèverait cette objection

Une réponse à Q2 et Q3. Q2 résorbe une contradiction interne du jet, Q3 répond au manque fonctionnel le plus mesuré du corpus.

Q7 est de la responsabilité exclusive de l'humain et ne bloque rien, mais elle reste ouverte tant qu'elle n'a pas reçu de réponse.

## Relations

- `objecte-a` [RES-006](../ressources/RES-006-ontologie.md)
- `objecte-a` [RES-007](../ressources/RES-007-concept.md)
- `objecte-a` [INTENTION.md](../../INTENTION.md)
- `derive-de` [ANL-001](../analyses/ANL-001-observation-corpus-repos-et-pratiques/analyse-critique.md)
