# Analyse avant réalisation, tâche 22

## La réponse qui commande le reste

Six des sept réponses ajustent des définitions. La septième, Q3, change ce qu'est un ADR.

La question posée était : faut-il un type distinct pour la décision de cap, puisqu'un ADR décide d'une architecture et non d'un cap ?

La réponse ne traite pas ce cas. Elle pose que l'ADR ne décide de rien : « les décisions relèvent de DCN et non pas de ADR. L'ADR est une justification raisonnée générée à partir d'un ou plusieurs DCN et un ou plusieurs FRG. »

La question devient sans objet : si aucun ADR ne décide, il n'y a pas de type manquant pour la décision de cap, il y a une `DCN` à écrire.

## Ce que cette réponse recoupe

C'est le troisième mouvement de dérivation en trois jours, et le troisième document de méthode à perdre son autorité propre.

| Décision | Ce qui devient dérivé | Outillé |
|---|---|---|
| `ADR-015` D4, tâche 17 | L'ADR devient le foyer du pourquoi, retiré des définitions | oui, par réécriture |
| `ADR-016` D3, tâche 21 | Le skill devient dérivable de `RES`, `ADR`, `SPC`, `RQF` | **non** |
| `ADR-017` D5, tâche 22 | L'ADR devient dérivable de `DCN` et `FRG` | **non** |

Le système converge vers une structure où seuls les actes, `DCN`, et la matière captée, `FRG`, sont écrits, et où tout le reste se dérive. L'humain le dit : « c'est vers ce résultat vers lequel le système clia converge ».

Deux des trois mouvements n'ont aucun outil.

## Le déplacement de critère de Q5

La question demandait si un contexte peut énoncer des mesures sans les consigner comme faits. Elle supposait que la frontière portait sur la nature de l'énoncé.

La réponse déplace le critère sur le **régime de véracité** : un `FCT` est établi par un processus rigoureux et normé, un `CTX` est affirmé sans vérification.

C'est plus opérationnel que la frontière précédente. Le test d'admission de `RES-005` passe de trois à quatre conditions, et la première est vérifiable : le processus qui établit la véracité doit être nommé.

**Conséquence rétroactive.** `ANL-001` énonce des dizaines de mesures sans produire aucun recueil `FCT`. Sous ce critère, elle reste conforme, ses mesures étant des affirmations d'agent. `FCT-001`, produite hier, est en revanche à relire : elle ne nomme aucun processus d'établissement.

## Ce que Q2 renverse

`RES-002` posait que l'affect n'entre pas dans le contexte, avec un argument en trois temps : une ressource est versionnée, partageable et opposable, et l'état émotionnel n'a aucune de ces propriétés.

L'argument tombe par Q5, non par Q2. Si le contexte porte des affirmations non vérifiées, lues comme telles, il n'a pas à être opposable. Un affect consigné dans un contexte est une perception d'agent, pas un dossier.

Les deux réponses se soutiennent, et c'est ce qui rend le renversement cohérent plutôt qu'arbitraire.

## La tension que la tâche ne peut pas résoudre

`ADR-017` instruit une décision qui fait de l'ADR un document dérivé d'une `DCN`. Sa propre `DCN` source n'existe pas : C1 en réserve la rédaction à l'humain, et seul le gabarit a été produit.

Trois conduites étaient possibles.

**Ne pas écrire l'ADR** et se contenter du gabarit. Écarté : les sept réponses seraient sans instruction, et les six définitions à corriger resteraient sans fondement écrit.

**Écrire l'ADR sans le signaler.** Écarté : ce serait produire en silence le cas que la décision interdit.

**Écrire l'ADR et déclarer la tension.** Retenu. La section Statut la porte, et `NON-026` Q3 demande quel ordre de travail adopter quand seul l'humain peut écrire la source.

## Ce qui n'a pas été fait, et pourquoi

Le lien symbolique de `INTENTION.md` n'est pas posé. La prescription est écrite dans `RES-003` ; l'implémentation demande un verbe d'initialisation que `setup.sh` n'a pas, et la tâche est un traitement d'objections.

Les seize ADR existants ne sont pas rattachés à des `DCN`. L'opération suppose que l'humain écrive seize `DCN`, ce que C1 lui réserve. `NON-026` Q1 pose la question.
