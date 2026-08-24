# Analyse, tâche 13 de SES-002

`MET-003` étape 2.

## Le grief est fondé, et je peux le mesurer

**Ce que j'ai rendu aux tâches 11 et 12 nommait bien un geste** — « statuer sur `DCN-016` » — mais en dernière ligne, après le rapport, sans dire comment le faire ni ce qu'il débloque.

**Trois mesures établissent que le système ne conduit pas l'humain.**

| Mesure | Valeur |
|---|---|
| Suites proposées sur treize tâches | **51**, dont 26 pour l'humain |
| Items en attente au 2026-08-13 | **61** |
| Items destinés à l'humain que `clia focus` affiche | **3** |

**Et la mesure qui explique tout** : `clia focus` lit les objections, les plans, les issues et les bogues. **Il ne lit pas les décisions.**

`DCN-016` — le geste qui débloque cinq chantiers de `PLN-007` — **n'est un item pour personne**. Il n'apparaît dans la commande que comme motif d'un plan rangé à défricher, jamais comme une action que l'humain pourrait prendre.

## La cause, en une phrase

**Le dépôt sait dire ce qui bloque. Il ne sait pas dire quoi faire pour débloquer.**

Trois défauts distincts s'additionnent.

### D1. `clia focus` répond à la mauvaise question

Il répond à « quelle est la priorité du dépôt ? », non à « que dois-je faire, moi ? ».

Résultat vérifiable à l'instant : la commande affiche `qui: agent` et propose `BUG-001`. **L'humain qui la lance apprend ce que l'agent doit faire.** Sur 61 items, 3 lui sont destinés, et aucun n'est celui qui débloque le travail en cours.

### D2. Le geste débloquant n'est pas modélisé

Un plan bloqué déclare son blocage en prose — dans ses objections, dans sa section « Statut ». **Aucun champ ne porte ce qui le débloquerait.**

`clia focus` a été corrigé à la tâche 11 pour détecter le blocage. Il sait dire « `PLN-007` a un préalable suspendu ». **Il ne sait pas dire « approuvez `DCN-016` ».** La première phrase décrit, la seconde conduit.

C'est le prolongement de `BUG-004` : l'exécutabilité n'est modélisée nulle part, et le déblocage non plus.

### D3. La restitution dilue la directive

`MET-005` prescrit, quand une exécution échoue : « il nomme l'anomalie, en cherche la cause, et propose l'action utile ».

**Rien ne dit où cette action va, sous quelle forme, ni combien il y en a.** Chaque tâche produit donc quatre à cinq suites, un rapport de plusieurs dizaines de lignes, et le geste noyé dedans.

**C'est une règle écrite et non tenue**, le défaut exact que `NON-005` décrit : elle fait croire à une garantie qui n'existe pas.

### Ce qui aggrave : deux sources qui se contredisent

Aux tâches 11 et 12, j'ai écrit « statuer sur `DCN-016` ». `clia focus` disait au même moment « corriger `BUG-001` ».

**L'humain a deux réponses différentes à la même question**, et rien ne dit laquelle prime.

## La solution proposée

Quatre gestes, du plus mécanique au plus documentaire. **Les trois premiers retirent du travail à l'humain ; le quatrième en retire à l'agent.**

### S1. Les décisions suspendues deviennent des items

Une décision qui porte `effet: suspendue` attend une approbation humaine — `DCN-013` le pose. C'est un item en attente, au même titre qu'une objection sans réponse.

**Nouvelle catégorie `A APPROUVER`, destinataire humain.**

### S2. Ce qui débloque le plus passe devant

`PLN-012` posait déjà le principe : « ce qui débloque le plus grand nombre d'autres items d'abord ». Il est calculé sur les renvois déclarés, qui sont incomplets.

**Une décision suspendue qui bloque des chantiers doit passer devant un bogue que personne n'attend.** Le poids se calcule sur les plans qu'elle bloque, non sur les citations.

### S3. `clia focus` répond à celui qui le lance

**`clia focus --humain` et `clia focus --agent`** filtrent sur le destinataire. Sans argument, le comportement ne change pas.

L'humain obtient enfin son geste à lui, et non la priorité globale du dépôt.

### S4. Une directive unique, et une seule, en tête de ce qui est rendu

`MET-005` reçoit le format et le contrôle qui manquent.

| Élément | Ce qu'il porte |
|---|---|
| **Le geste** | Une phrase à l'impératif, un seul |
| **La commande** | Ce qu'on tape, exactement |
| **Ce qu'il débloque** | Combien de chantiers, quels plans |
| **Qui** | L'humain ou l'agent |

**Et une règle de cohérence** : la directive rendue est celle que `clia focus` désigne. Si les deux divergent, c'est la commande qui a raison, et l'agent corrige la commande plutôt que son message.

**Le skill d'écriture des plans reçoit la contrepartie** : un plan qui déclare un blocage déclare **par quel geste il se lève**.

## Ce que la solution ne fait pas

**Elle ne fait pas descendre le compteur.** 61 items restent 61 items ; S1 en ajoute même un. Ce qui change est que l'humain voit lequel prendre.

**Elle ne débloque pas `DCN-016`.** Aucun mécanisme ne peut approuver une décision à la place de l'humain — `CONSTITUTION.md` C1.

**Elle ne garantit pas que la directive soit la bonne.** Elle garantit qu'il y en ait une, unique, exécutable, et cohérente avec l'outil.

## Ce que je décide en avançant

**Implémenter S1, S2 et S3, et pas seulement les écrire.** La tâche est un rapport de bogue, et l'humain demande de réécrire les méthodes. Écrire la règle sans la rendre mécanique reproduirait D3 — une prescription que rien ne tient. C'est du code, réversible, une lecture raisonnable : le filtre range du côté « avancer ».

**Ne pas créer de méthodologie nouvelle.** `MET-005` porte l'exécution, `skl-006` porte l'écriture des plans. Les deux existent et suffisent. La session cherche à retirer des items, pas à en ajouter.
