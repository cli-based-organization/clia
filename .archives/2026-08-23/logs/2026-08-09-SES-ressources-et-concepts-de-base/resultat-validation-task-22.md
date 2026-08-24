# Résultat de la validation, tâche 22

## Bilan

| Contrôle | Résultat |
|---|---|
| Décisions citant leur réponse source | **8 sur 8** |
| Blocs de réponse de `NON-003` modifiés | **0** |
| Affirmations résiduelles « l'ADR décide » dans les documents actifs | **0**, après une correction |
| Schéma, dépôt entier | **112 conformes, 4 non conformes** |
| Liens relatifs | **0 cassé** |
| `V10` sur les définitions | **0 en faute** |
| Tests du CLI | **124 réussis, 0 échoué** |
| `DCN` rédigées par l'agent | **0** |

## Les quatre non-conformités de schéma

Les quatre sont des gabarits en attente de leur initiateur.

| Fichier | Qui doit le renseigner |
|---|---|
| `DCN-011` | L'humain, par C1. Produit à la tâche 21 |
| `DCN-012` | L'humain, par C1. Produit à la tâche 22 |
| `FRG-001` | L'humain, son initiateur |
| `NON-013` | L'humain, son initiateur |

Deux des quatre sont **volontairement** non conformes : `CONSTITUTION.md` C1 interdit à l'agent de renseigner leurs champs.

## Contrôle 12, les affirmations résiduelles

Recherche de toute affirmation posant que l'ADR décide, dans les documents actifs.

| Occurrence | Traitement |
|---|---|
| `RES-019`, « le plan propose une intervention, l'ADR acte un choix » | **Corrigée**. L'ADR justifie un choix déjà acté par une `DCN` |
| `NON-003`, dans le texte de la question Q3 | **Conservée**. C'est la question posée avant la réponse, et la réécrire falsifierait l'objection |
| `ADR-017`, citant l'état antérieur de `RES-009` | **Conservée**. La citation est explicitement datée |
| `ANL-001`, analyse critique | **Conservée**. Point fixe qui rapporte l'état de son jour |

## Contrôle 13, l'irrégularité déclarée

`ADR-017` D5 fait de l'ADR un document dérivé d'une `DCN`. `ADR-017` n'a pas de `DCN` source.

Sa section Statut le déclare, et renvoie à `NON-026` Q3.

C'est le second cas en deux tâches où un document instruit une décision qu'il enfreint en existant : `ADR-016` D3 retire l'autorité aux skills, et la tâche 17 venait d'enrichir `skl-001`.

## Contrôle 14, les conséquences rétroactives

**`FCT-001` est à relire.** Produite hier, elle ne nomme aucun processus d'établissement de la véracité de ses dix faits. Sous D1, c'est désormais la première condition du test d'admission.

Elle n'a pas été corrigée : la tâche 22 traite les réponses à `NON-003`, et une relecture de `FCT-001` sous le nouveau critère est un travail distinct. Le constat est porté par le journal.

**`ANL-001` reste conforme.** Ses mesures sont des affirmations d'agent, ce que D1 admet explicitement.

## Portée respectée

Contrôles 19 à 21.

Aucune `DCN` rédigée. Le gabarit `DCN-012` porte ses cinq champs `À RENSEIGNER`.

Aucun ADR existant rattaché rétroactivement à une `DCN` : l'opération suppose seize `DCN` que seul l'humain peut écrire.

Le lien symbolique de `INTENTION.md` n'est pas posé.

## Ce que la validation n'établit pas

**Les seize ADR sont sans source.** Sous D5, un ADR tire son autorité de la `DCN` dont il dérive. Aucun n'en déclare. Combiné à `NON-024`, la chaîne d'autorité du dépôt ne repose sur aucun acte formellement approuvé.

**Deux décisions de dérivation sont sans outil.** `ADR-016` D3 pour les skills, `ADR-017` D5 pour les ADR. Aucun générateur n'existe, et deux des quatre sources nommées par la première, `SPC` et `RQF`, ont zéro instance.

**Le dépôt n'est pas conforme à sa propre prescription** sur le lien symbolique, écrite aujourd'hui dans `RES-003`.
