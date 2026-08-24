# Ce qui a été fait, tâche 22

## En un coup d'oeil

| Mesure | Valeur |
|---|---|
| Réponses traitées | **7 sur 7** |
| Décisions instruites | 8, dans `ADR-017` |
| Définitions modifiées | 5 |
| Objection levée | `NON-003`, `conditionnel` vers `informatif` |
| Objection ouverte | `NON-026`, conditionnelle, 5 questions |
| Gabarit laissé à l'humain | `DCN-012` |
| Tests du CLI | **124, tous verts** |
| Ressources validant leur schéma | **112 sur 116** |

## Les huit décisions

| Réf | Décision |
|---|---|
| D1 | Le **fait** se distingue du **contexte** par le régime de véracité, non par la nature de l'énoncé |
| D2 | L'**affect entre dans le contexte**, déduit de `session.md` |
| D3 | `INTENTION.md` est un **lien symbolique** vers une instance `INT` |
| D4 | Trois types, aucun obligatoire sauf l'intention ultime |
| D5 | **L'ADR est une justification dérivée de `DCN` et de `FRG`, non l'acte de décider** |
| D6 | Justifier un changement de cap par `DCN` et `FRG` est une bonne pratique, non une obligation |
| D7 | `peremption` devient facultatif |
| D8 | Le type Acteur est reporté |

## D5, la décision la plus lourde

Elle ne répondait pas à la question posée. Q3 demandait s'il manque un type pour la décision de cap ; la réponse pose que l'ADR ne décide de rien.

| Avant | Depuis |
|---|---|
| L'ADR décide, la `DCN` enregistre une décision prise ailleurs | La `DCN` porte l'acte, l'ADR en dérive la justification |
| `edition: co-edition` | `edition: ia` |
| Source : le raisonnement de l'agent | Sources : une ou plusieurs `DCN`, un ou plusieurs `FRG` |

**C'est le troisième mouvement de dérivation en trois jours.** `ADR-015` D4 a retiré la justification des définitions, `ADR-016` D3 a retiré l'autorité aux skills, `ADR-017` D5 la retire aux ADR. Le système converge vers une structure où seuls les actes et la matière captée sont écrits.

**Deux des trois mouvements n'ont aucun outil.** Seize ADR existent, tous écrits à la main comme des actes de décision, et aucun ne déclare de source.

## D1, le déplacement de critère

La frontière entre `FCT` et `CTX` ne porte plus sur la nature de l'énoncé mais sur le régime de confiance.

| Type | Ce qu'il affirme | Régime |
|---|---|---|
| `CTX`, et toute rubrique de contexte | Une situation telle qu'elle est perçue | Affirmé **sans vérification**, lu comme tel |
| `FCT` | Un énoncé dont la véracité est établie | **Éprouvé par un processus rigoureux et normé** |

Le test d'admission de `RES-005` passe de trois à quatre conditions. La première est vérifiable : le processus qui établit la véracité doit être nommé dans le recueil.

**Conséquence rétroactive constatée.** `FCT-001`, produite hier, ne nomme aucun processus d'établissement. Elle est à relire sous ce critère.

## D2, un renversement soutenu par D1

`RES-002` posait que l'affect n'entre pas dans le contexte : une ressource est versionnée, partageable et opposable, et l'état émotionnel n'a aucune de ces propriétés.

L'argument tombe par D1. Si le contexte porte des affirmations non vérifiées, lues comme telles, il n'a pas à être opposable. Un affect consigné est une perception d'agent, non un dossier.

## D3, l'exception retirée

`RES-003` déclarait un emplacement dérogatoire : `INT-001` vivait à `INTENTION.md`.

L'instance vit désormais à l'emplacement conventionnel du type, et `INTENTION.md` est un lien symbolique vers elle. Le type n'a plus d'exception, et le document le plus important du dépôt garde son adresse fixe.

**Non implémenté.** `setup.sh` n'a aucun verbe d'initialisation de dépôt, et ce dépôt n'est pas conforme à sa propre prescription.

## La tension déclarée

`ADR-017` instruit une décision qui fait de l'ADR un document dérivé d'une `DCN`. Sa propre `DCN` source n'existe pas : `CONSTITUTION.md` C1 en réserve la rédaction à l'humain.

L'ADR a été écrit et la tension déclarée dans sa section Statut, plutôt que de produire en silence le cas que la décision interdit.

`NON-026` Q3 pose la question : quel ordre de travail adopter quand seul l'humain peut écrire la source ?

## Ce qui n'a pas été fait

`DCN-012` n'est pas rédigée : C1 l'interdit. Le gabarit est là, avec ses cinq champs `À RENSEIGNER`.

Le lien symbolique de `INTENTION.md` n'est pas posé.

Les seize ADR existants ne sont pas rattachés à des `DCN`. L'opération suppose seize `DCN` que seul l'humain peut écrire.

Aucun générateur n'est produit. D5 rejoint `ADR-016` D3 dans les décisions de dérivation non outillées.
