# Interprétation de la demande, tâche 2

## Demande

Tâche 2 de `workspace/session.md`, intitulée `[conception] premier jet ressources fondamentales` :

1. à partir des constats de `ANL-001`, produire un premier jet de description des ressources fondamentales `RES-<SEQ>` pour sept types : Ressource, Contexte (CTX), Intention (INT), Objection (NON), Faits (FCT), Ontologie (ONT), Concept (CPT) ;
2. puis émettre une série d'objections, sous forme d'un fichier `NON-xyz` par thématique, chacun contenant plusieurs questions sur un même sujet.

## Intention

Sortir les sept notions fondamentales de l'état de mention dans un fichier de harnais, et leur donner une définition opposable, fondée sur ce que l'observation du corpus a établi.

## Lecture de portée

La liste de la tâche associe à chaque type un triplet `ADR-00X, RES-00X, skl-00X`. La demande explicite ne porte que sur les `RES` : « produire un premier jet de description des ressources fondamentales (RES-<SEQ>) ». Les ADR et les skills ne sont donc pas produits, et la numérotation de la liste est reprise telle quelle pour fixer l'ordre des sept définitions.

Cette lecture restrictive est aussi la plus prudente au regard de `ANL-001`, défaut D4 : produire vingt-et-un documents plutôt que sept engagerait un coût que rien ne justifie encore. L'objection `NON-002` porte cette question à l'humain.

## Directives inexécutables constatées et traitement retenu

| Directive de `CLAUDE.md` | État | Traitement |
|---|---|---|
| `skl-001` à `skl-007` encadrent la production des ressources | Aucun n'existe | Forme dérivée de l'état de l'art observé, `RES-001` de `micrologic-clients`. Chaque définition déclare `skill: aucun` |
| `ADR-001` à `ADR-007` actent les types | Aucun n'existe | Chaque définition déclare `adr: aucun`. Les décisions restent à acter par l'humain |
| Ressources fondamentales désignées par triplet de numéros | Le mode de désignation est invalidé par `ANL-001`, D1 | Un mécanisme d'identité par champ `id` est proposé dans `RES-001` et soumis à `NON-001` |
| `ARCHITECTURE.md` donne les répertoires conventionnels | Le fichier liste `$ZONE/ressources/` sans plus de détail | `.dev/ressources/` et `.dev/objections/` retenus, par analogie avec `.dev/analyses/` imposé par la tâche 1 |
| Journalisation par répertoire `<DATE>-SES-<SLUG>` | Le harnais ne dit pas comment journaliser deux tâches d'une même session | Fichiers suffixés `-task-02` dans le répertoire de session existant. Incohérence signalée |

## Objections émises

Huit objections, une par thématique, portant au total cinquante-six questions. Trois sont déclarées `bloquant` : `NON-001` identité et nommage, `NON-002` coût du modèle, `NON-005` validation et règles non tenues.
