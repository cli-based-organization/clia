# Analyse préalable, tâche 4

## La difficulté principale : le processus existe déjà et n'est plus en vigueur

Le `CONSTITUTION.md` archivé porte un processus complet et éprouvé : gouvernance objection-sociocratique, cycle de vie du plan en cinq états, canaux d'objection séparés, règle absolue de non-exécution sous objection ouverte, breakpoint et approbation partielle, classification des documents par droits d'édition, interface par fichiers, et rôle de `clia` comme gardien déterministe.

Ce document a été archivé le 2026-08-08 avec la quasi-totalité du dépôt. Le processus a donc continué d'être pratiqué sans document en vigueur : les trois premières tâches de cette session l'ont suivi de mémoire et par imitation du corpus.

`ADR-002` ne pouvait donc pas être écrit à neuf. Il devait faire trois choses distinctes : reprendre ce qui a été éprouvé, écarter ce qui ne l'a pas été, et acter les ruptures que la pratique a déjà consommées sans les déclarer.

## Ce qui a été repris tel quel

Le rôle de `clia` comme délégué de l'humain. La formulation archivée est meilleure que ce qu'on écrirait à neuf : parce qu'il est déterministe et opéré par l'humain, `clia` peut légitimement muter des fichiers en édition humaine exclusive, car c'est l'humain qui agit via son outil. C'est ce qui distingue un automatisme d'un agent : `clia` n'a pas de volonté propre, donc il n'a pas besoin de droits propres.

L'interface par fichiers plutôt que par conversation.

L'obligation de journalisation sans exception, y compris pour une tâche dont le seul livrable est un plan.

## Ce qui a été rompu, et pourquoi la rupture est actée

**La règle absolue de non-exécution sous objection ouverte** est remplacée par la déclaration d'effet de `RES-004`, à trois niveaux. Deux motifs. Prise au mot, la règle absolue aurait interdit les tâches 3 et 4 de cette session, puisque trois objections bloquantes ont été ouvertes le matin du 2026-08-09. Et son mécanisme de compensation, breakpoint plus segments plus objections différées, demande de tenir un état à trois dimensions que rien ne vérifie.

Ce que la rupture perd est nommé dans `ADR-002` D6 : le breakpoint offrait à l'humain un point d'arrêt déclaré à l'avance, que la déclaration d'effet ne donne pas.

`ANL-001` établit au défaut D3 que le corpus n'a jamais tracé aucune de ses quatre ruptures de cap. Celle-ci est tracée, avec sa perte et sa porte de sortie. C'est le seul point où ce document fait mieux que le corpus par construction et non par hasard.

## Ce qui a été signalé plutôt que corrigé

Deux écarts entre le processus écrit et le processus pratiqué, tous deux constatés dans cette session même.

**Aucun plan n'a précédé l'exécution des trois premières tâches**, alors que le processus antérieur l'exigeait. Ni l'humain ni l'agent ne l'ont relevé sur le moment. Cet écart n'est pas neutre : il retire à l'humain le point de contrôle qui précède la production.

**Les réponses conversationnelles ont largement dépassé la phrase prescrite.**

Ces deux écarts sont signalés dans `ADR-002` et portés par `NON-010` Q4 et Q5. Les corriger de ma propre initiative aurait été trancher à la place de l'humain une question de gouvernance.

## Pourquoi une section de mesures dans l'ADR

`ADR-002` porte une section « Ce que ce processus a déjà produit », avec sept mesures prises sur les trois premières tâches de la session : 3 tâches traitées, 25 fichiers, 3 journaux, 10 objections dont 3 bloquantes, 0 objection humaine, 3 ambiguïtés signalées, 2 ADR au statut `propose`.

Le motif est méthodologique. Un ADR sur un processus court le risque de décrire un processus idéal. Le corpus en donne la mesure : quatre-vingt-neuf ADR, dont aucun sur les ruptures réelles. Adosser la décision à ce que le processus vient effectivement de produire, écarts compris, est le seul garde-fou disponible.

La mesure la plus parlante est celle qui vaut zéro : aucune objection émise par l'humain. Le dispositif fonctionne pour l'instant à sens unique.

## Le plan : deux chantiers de nature différente

Le chantier A, réécriture de `CLAUDE.md`, est **suspendu** à trois réponses : `NON-001` Q1 et Q5 sur la forme des renvois, `NON-002` Q6 sur la source de vérité de la table des types, `NON-009` Q7 sur l'emplacement du point d'entrée. Le commencer avant serait produire un fichier de harnais qu'il faudrait réécrire une seconde fois. Le plan le déclare et pose un point d'arrêt après le classement des directives.

Le chantier B, skill d'analyse de la demande, n'a **aucun prérequis bloquant**, parce que `ADR-002` D3 en pose déjà les cinq temps. Son risque est autre : écrire un skill qui décrit ce que l'agent a fait plutôt que ce qu'il devrait faire. L'étape B8 est conçue contre cela, en confrontant le skill aux trois demandes réelles de cette session, y compris à leurs échecs.

## Le contrôle V8 a encore été corrigé

Le contrôle de marqueurs de gabarit de `skl-001-ressource` signalait `PLN-001` comme non conforme, pour trois mentions du mot `TODO` désignant la note de la demande à laquelle le plan répond.

Le défaut était dans le contrôle : le motif cherchait `TODO` partout, sans distinguer un TODO laissé par l'auteur d'une mention du mot. Le motif ne se cherche désormais qu'en tête de ligne, en tête de puce, ou suivi de deux points. Une contre-épreuve sur un fichier portant un vrai reste de gabarit confirme que le contrôle détecte toujours ce qu'il doit détecter.

C'est la deuxième correction du même skill par son propre usage, après celle de la tâche 3 sur les blocs de code. Les deux relèvent de la même cause, énoncée dans la règle d'exclusion du skill : un contrôle qui ne distingue pas une mention d'un emploi est inutilisable sur un document de méthode.

## Ce qui a été refusé

L'exécution de l'un ou l'autre chantier du plan. La note demande un plan.

La correction des deux écarts de processus constatés. Signaler relève de l'agent, décider relève de l'humain.

La modification de `workspace/session.md` pour compléter la remarque tronquée. Le fichier est en édition humaine exclusive.
