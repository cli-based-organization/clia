# Interprétation de la demande, tâche 7

## Demande

Tâche 7 de `workspace/session.md`, intitulée `[conception] identifiants dans les systèmes décentralisées`. Trois livrables, et une méthodologie imposée pour le premier.

**Recherche de fondation**, de type revue de la littérature scientifique. Chaque affirmation doit être supportée par un URL valide, les références insérées dans le texte après chaque affirmation comme dans un article scientifique, en préférant les sources à haute crédibilité. Processus d'analyse en sept étapes : questions de recherche, inventaire sémantique et ontologique, cadres théoriques et méthodologiques avec identification de **tous** les domaines dont l'ontologie recoupe les questions, **tous** les axes d'analyse, revue historique, analyse critique des champs et de leurs limites, réponse aux questions.

**Analyse**, au regard de `ANL-001` et de la fondation, avec suggestions pour la conception du système d'identifiants des ressources `clia`.

**Objections**, en complétant les existantes par de nouvelles questions et en ouvrant de nouvelles au besoin.

## Intention posée par la demande

Produire un document de référence sur les enjeux d'un système d'identifiants qui soit facile d'utilisation, qui distingue les contextes interne et externe, et qui repose sur la notion de ressource partageable et réutilisable. Avec quatre modalités de réutilisation nommées : dans un autre projet, par une autre personne, en édition collaborative, en oeuvre dérivée par branche ou fork.

## Portée retenue

Les sept étapes sont traitées dans l'ordre et nommées comme telles dans le document.

Les sept domaines de savoir suggérés sont mobilisés. Sept autres sont ajoutés, dont l'ontologie recoupe les questions : théorie du nommage en systèmes distribués, sciences de l'information et bibliothéconomie, identifiants pérennes de la recherche, science ouverte et principes FAIR, citation de données et de logiciels, réplication et édition collaborative, gestion de paquets et espaces de noms, identifiants générés localement, provenance et versionnage.

Quatorze axes d'analyse sont identifiés. Un quinzième aurait été souhaitable et n'a pas de littérature : l'ergonomie de saisie.

Huit questions de recherche sont formulées, dérivées de l'intention posée, et chacune reçoit une réponse à l'étape 7.

## Régime de citation appliqué

Chaque affirmation empruntée porte une référence entre parenthèses avec lien. Les affirmations sans référence sont soit des définitions posées par le document, soit des raisonnements propres, soit des faits établis par `ANL-001`.

Une hiérarchie de crédibilité est déclarée en tête et chaque écart est signalé à l'endroit où il se produit. Sont primaires : les spécifications IETF et W3C, la documentation de Software Heritage, les documents de l'IFLA et de la Bibliothèque du Congrès, les déclarations de FORCE11. Sont secondaires et signalées comme telles : la description du CID, la pratique du semver dans les API, la synthèse comparative des espaces de noms, et surtout la réfutation du trilemme de Zooko.

Neuf recherches ont été menées et quatre sources critiques ont été vérifiées par consultation directe, dont deux qui ont fourni des précisions que les résultats de recherche ne donnaient pas : la syntaxe exacte du SWHID et le statut de la conjecture de Zooko.

## Ambiguïtés et incohérences identifiées, signalées comme le processus l'exige

**Le système abandonne une propriété sans l'avoir décidé.** `FND-002` établit qu'un identifiant ne peut être lisible, unique globalement et sans autorité à la fois. `clia` a retenu les deux premières et abandonné l'unicité globale, sans que ce choix soit écrit nulle part. Nouvelle objection, `NON-014`.

**L'`INTENTION.md` promet ce que le système d'identifiants ne peut pas tenir.** La réutilisation par une autre personne exige une résolution indépendante de l'émetteur, la réutilisation dans un autre projet exige une portée qui dépasse le projet. Aucune des deux n'est disponible. Porté par `NON-014` Q4, qui reprend `NON-004` Q7 avec un argument théorique là où celle-ci avait un argument empirique.

**Une collision de numéros s'est produite pendant la tâche.** Voir la section suivante.

## L'incident de numérotation

L'humain a créé le 2026-08-09, au moyen de `clia res new`, une objection `NON-013-ce-qu-est-une-ressource.md`. L'agent a produit le 2026-08-10 une objection distincte à laquelle `clia` a attribué le même numéro, le fichier de l'humain n'étant pas commité au moment du relevé.

C'est exactement la collision que la question Q7 de `NON-001` annonçait, moins de vingt-quatre heures après avoir été posée. Elle est consignée comme deuxième preuve empirique dans le journal de cette objection.

Résolution appliquée : l'objection de l'agent est renumérotée en `NON-014`, celle de l'humain est conservée. Le choix suit le régime d'édition hybride de `RES-004`, où l'initiateur possède ses blocs d'ouverture. Aucune modification n'a été apportée au fichier de l'humain.

## Directives inexécutables constatées

| Directive | État | Traitement |
|---|---|---|
| Un skill encadre la recherche de fondation | `skl-002-recherche-de-fondation` existe dans le corpus, pas ici | Méthodologie prise dans la demande, qui est plus exigeante que le skill du corpus |
| Les types `fondation`, `analyse`, `objection` ont une définition | Seul `objection` en a une, `RES-004` | Instances produites, non-conformité déjà portée par `NON-011` |
| Les ressources point fixe sont nommées par date | Contredit par l'usage | Séquence retenue pour `FND-002` et `ANL-003`, cohérence locale. `NON-011` Q2 |
| `clia validate` vérifie les livrables | N'existe pas | Contrôles manuels de `skl-001-ressource` |

## Ce qui n'a pas été fait

Aucune décision. La demande demande une recherche, une analyse et des objections, pas un ADR. Les dix suggestions de `ANL-003` sont des suggestions, et le document le dit.

Aucune modification de `RES-001` ni de `ADR-001`, que plusieurs suggestions visent. Les modifier avant arbitrage aurait tranché à la place de l'humain.

Aucune modification du `NON-013` de l'humain, y compris pour le rédiger.

Cinq domaines identifiés comme pertinents et non explorés faute de temps : l'identité auto-souveraine au-delà des DID, les identifiants auto-certifiants de type KERI, la gouvernance des méthodes DID, les identifiants de Wikidata, le droit des oeuvres dérivées. Ils sont nommés dans les limites de `FND-002`.
