# Ce qui a été fait, tâche 12 de SES-002 — premier versement

`MET-003` étape 3. Le chantier A de `PLN-015`.

## Le critère n'est pas satisfait

**Un hook ne fait pas passer une commande que le dépôt demande.** C'est le contraire de ce que `ANL-012` supposait en retenant la piste D.

## Le dispositif

Dépôt jetable hors du dépôt `clia`, configuration propre, variables `CLAUDE_*` de la session parente retirées — sans quoi la sous-session hérite de l'approbation de celle qui la lance, ce que le premier essai a montré.

Commande d'essai : `echo "MARQUEUR $(date +%s)"`. La substitution est exactement le motif de huit des quinze interruptions de `BUG-001`.

Le hook d'essai laisse une trace à chaque appel, pour distinguer « il n'a pas été appelé » de « il a été appelé et sa décision n'a pas été suivie ».

## Les quatre passages

| Règle `ask` | Hook | Résultat | Hook appelé ? |
|---|---|---|---|
| `["Bash"]` | aucun | **Refusée** | — |
| `["Bash"]` | rend `allow` | **Refusée** | **oui**, `decision=allow outil=Bash` |
| `[]` | aucun | Exécutée | — |
| `[]` | rend `deny` | **Refusée** | **oui**, `decision=deny outil=Bash` |

## Ce que la mesure établit

**Le hook est appelé, sa sortie JSON est lue, et sa décision est appliquée — dans le sens du refus.** Le quatrième passage le prouve : une commande qui passait est bloquée par le seul effet du hook.

**Une décision `allow` ne lève pas une règle `ask` du projet.** Deuxième passage : le hook est appelé, il rend `allow`, la commande reste refusée. La règle explicite l'emporte.

**Le mode non interactif ne reproduit pas la demande de confirmation.** C'est le point qui fait échouer le chantier. Sans règle `ask`, la commande contenant `$(date)` **passe** en `-p` — elle n'est donc pas refusée pour la raison qui fait l'objet de `BUG-001`. Le seul moyen de la faire refuser dans ce dispositif était une règle `ask` explicite, et c'est précisément le cas où `allow` ne fait rien.

## L'hypothèse de méthode qui s'est révélée fausse

Le log d'analyse de 14:04 posait cette équivalence :

> En interactif : la demande apparaît. En `-p` : la commande est refusée.

**Elle est fausse.** En `-p`, une commande non analysable statiquement n'est pas refusée : elle s'exécute. La demande de confirmation de `BUG-001` n'a pas d'équivalent observable en mode non interactif.

**Ce qu'aucun script ne peut faire** : produire cette demande et constater qu'un hook la supprime. Il faudrait une session interactive et un humain qui regarde l'écran.

## Ce que cela fait au plan

`PLN-015` déclarait : « Si la mesure échoue, tout le plan tombe et la piste B de `ANL-012` — le mode de permission à l'invocation — redevient la seule. »

**La mesure n'établit pas que la piste D est impossible. Elle établit que je ne peux pas la vérifier, et qu'elle ne fonctionne pas là où elle a été éprouvée.** Ce n'est pas la même chose, et le plan ne prévoyait pas cette nuance.

| Chantier | Sort |
|---|---|
| A | **Exécuté, critère non satisfait** |
| B | Indépendant : reste exécutable, et le sera |
| C | **Dépend de A : hors d'atteinte.** Une commande qui diagnostique une politique dont on ne sait pas si elle peut agir n'a pas d'objet |

**`PLN-015` reste `propose`** : `MET-005` étape 5, un plan partiellement exécuté ne passe pas à `execute`.
