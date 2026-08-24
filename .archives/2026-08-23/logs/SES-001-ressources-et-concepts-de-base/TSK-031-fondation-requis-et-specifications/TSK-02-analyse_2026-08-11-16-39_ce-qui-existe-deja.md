# Analyse avant réalisation, tâche 31

`MET-003` étape 2.

## L'humain avait raison

« Il me semble que ça fait plusieurs fois que je fais cette demande. »

L'inventaire le confirme. Soixante-quatorze fondations existent dans `$HOME/git`, et l'une d'elles répond à la moitié de la demande.

| Fondation | Ce qu'elle couvre |
|---|---|
| **`FND-015`, archivée le 2026-07-18** | La distinction requis contre spécification, sa taxonomie, et pourquoi deux équipes rigoureuses divergent |
| `FND-002`, ingénierie des livrables | La qualité documentaire et les formes de revue |
| `FND-018`, cas d'usage | Cas d'utilisation, user stories, INVEST et SMART |

**`FND-015` est solide.** Elle établit trois lectures du mot spécification, montre que deux d'entre elles **inversent** la relation d'abstraction, et s'appuie sur des sources primaires normatives et académiques.

## Ce que la demande couvre et que FND-015 ne couvre pas

| Réf | Demandé | Dans `FND-015` |
|---|---|---|
| P1 | Historique des RFC et mécanismes de publication | **non** |
| P2 | Normalisation, standardisation, spécification | **non** |
| P3 | Exemples archétypaux et historiques | **non** |
| P4 | Évolution des formes de publication | **non** |
| P5 | Types de spécifications et de requis | **oui**, sections 5 et 6 |
| P6 | Distinction requis contre spécification | **oui**, sections 1 à 7 |

**La nouvelle fondation porte P1 à P4 et cite `FND-015` pour P5 et P6.**

Refaire P5 et P6 serait exactement le défaut que `NON-021` conteste depuis la tâche 14 : produire sans chercher ce qui existe.

## La contrainte que je dois déclarer

`MET-001` étape 9 exige de vérifier chaque URL citée.

**Aucun outil de vérification en ligne n'est disponible dans cette session.** Les sources seront citées par leur référence normative complète, qui est vérifiable hors ligne, et les URL seront déclarées non interrogées.

C'est la même limite que `ANL-005` a déclarée pour trois de ses sept sources. La déclarer vaut mieux que laisser croire à une vérification.

## Ce que l'analyse doit trancher

« Où doit se trouver la source de vérité pour la description de l'implémentation et des contraintes, choix techniques ? »

Quatre éléments du dépôt se croisent sur cette question, et aucun ne la règle.

| Élément | Ce qu'il pose |
|---|---|
| `ADR-006` | La spécification est strictement distincte de l'implémentation |
| `ADR-014` D1 | Le code est une ressource, du côté de l'implémentation |
| `NON-004` Q3 | Une ressource est source ou générée selon le contexte |
| `ANL-009` | `SPC` et `RQF` ont **zéro instance** |

**Le dépôt a défini deux types qu'il n'a jamais employés**, et trois décisions en réclament un sans qu'aucun n'existe : `ISU-007` pour les critères de conformité, `PLN-003` G1, et `NON-030` Q2 pour le générateur.

## La difficulté propre à clia

`FND-015` recommande de « choisir explicitement une lecture, fixer la frontière machine, et nommer sans ambiguïté l'artefact concret ».

`clia` complique le problème d'un cran : **le code est une ressource générée**, et `NON-004` Q3 pose qu'une ressource peut être source ou générée selon le contexte.

Si le code est généré à partir d'une spécification, la source de vérité est la spécification. Si le code est source, la spécification le décrit après coup et dérive de lui.

**Les deux régimes coexistent dans le dépôt aujourd'hui.** `lib/clia/git.sh` a été écrit à partir de `ANL-005`, donc généré au sens large. `lib/clia/resource.sh` a été écrit d'abord, et aucune spécification ne le décrit.

## L'ordre retenu

1. `FND-004` : P1 à P4, en citant `FND-015` pour P5 et P6.
2. `ANL-010` : l'approche compatible avec `clia`, et la source de vérité.

## Ce que je ne ferai pas

**Refaire `FND-015`.** Elle est archivée, non périmée. Son statut d'archive tient au refactor du 2026-08-08, non à un défaut de contenu.

**Écrire une `SPC`.** La tâche demande une fondation et une analyse.
