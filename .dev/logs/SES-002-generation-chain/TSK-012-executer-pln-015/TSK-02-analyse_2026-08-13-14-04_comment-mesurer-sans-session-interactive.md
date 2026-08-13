# Analyse, tâche 12 de SES-002

`MET-003` étape 2.

## Le chantier A commande les deux autres

Son critère : « Sur un dépôt jetable, avec un hook d'essai qui rend `allow`, une commande contenant `$(date)` s'exécute **sans demande de confirmation** ; le même essai sans le hook la déclenche. »

**Si la mesure échoue, `PLN-015` tombe** et la piste B de `ANL-012` — le mode de permission à l'invocation — redevient la seule. Le plan le déclare. Je commence donc par là, et j'accepte le résultat quel qu'il soit.

## Le problème de méthode : une demande de confirmation ne s'observe pas depuis un script

Le critère parle d'une **demande de confirmation**, qui n'existe qu'en session interactive. Un script ne peut ni la voir ni y répondre.

**Ce qui la remplace en mode non interactif.** `claude -p` n'a personne à qui demander : une commande qui aurait été demandée est **refusée**. Le refus est observable — l'outil échoue, et le texte le dit.

**L'équivalence que j'emploie**, et qui est une hypothèse de méthode à déclarer :

| En interactif | En `-p` |
|---|---|
| La demande apparaît | La commande est refusée |
| L'humain répond « oui » | — |
| Rien n'est demandé | La commande s'exécute |

**Ce que cela mesure exactement** : qu'un hook peut faire passer une commande de « refusée » à « exécutée » sans qu'aucune règle `allow` ne la couvre. C'est la propriété dont dépend `PLN-015`.

**Ce que cela ne mesure pas** : que la demande disparaît visuellement en interactif. Personne ne peut le mesurer par script, et je préfère le déclarer plutôt que de prétendre l'avoir fait.

## Le dispositif

Un dépôt jetable dans le répertoire de travail temporaire, avec sa propre configuration, et **trois passages** au lieu des deux que le critère demande :

| Passage | Configuration | Attendu |
|---|---|---|
| 1 | Aucune règle, aucun hook | La commande est refusée |
| 2 | Un hook qui rend `allow` | La commande s'exécute |
| 3 | Le même hook, rendant `deny` | La commande est refusée, avec le motif du hook |

**Le troisième passage n'est pas dans le critère.** Je l'ajoute parce que sans lui, un passage 2 réussi pourrait s'expliquer par une permission héritée d'ailleurs plutôt que par le hook. Le passage 3 établit que c'est bien le hook qui décide.

**La commande d'essai contient `$(date)`**, ce qui est exactement le motif de huit des quinze interruptions de `BUG-001` : une substitution que l'analyse statique ne peut pas résoudre.

## Ce qui pourrait fausser la mesure

**La configuration de l'utilisateur s'applique aussi.** `~/.claude/settings.json` peut porter des règles qui autorisent déjà la commande. Si le passage 1 réussit, la mesure est invalide et je le dirai plutôt que de conclure.

**Le dépôt jetable doit être hors du dépôt `clia`**, sinon il hérite de `.claude/settings.json` du projet, qui autorise `echo` et `date`.

## Sur `NON-040`, vérifié avant de commencer

L'objection est ouverte et bloquante. Elle porte sur **ce que la politique autorisera** — la portée de la liste blanche, le sort de l'écriture hors du dépôt.

**Les trois chantiers du plan ne la touchent pas** : le premier mesure un mécanisme, le deuxième écrit une règle de conduite, le troisième livre un diagnostic qui ne modifie rien. Les deux chantiers qui dépendaient de `NON-040` sont ceux que le plan a explicitement sortis.

Exécuter A, B et C ne préjuge donc pas de la réponse.
