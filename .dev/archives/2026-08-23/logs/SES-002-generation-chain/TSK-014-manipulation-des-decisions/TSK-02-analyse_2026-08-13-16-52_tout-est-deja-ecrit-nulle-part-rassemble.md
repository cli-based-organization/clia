# Analyse, tâche 14 de SES-002

`MET-003` étape 2.

## Ce que le constat de l'humain révèle

« C'est difficile de comprendre comment fonctionne les métadata de décision DCN et son cycle de vie. »

**Tout ce qu'il cherche est écrit, et dispersé en trois endroits.**

| Ce qu'il veut savoir | Où c'est écrit |
|---|---|
| Quels champs porte une `DCN` | `RES-009`, champ `champs-obligatoires` |
| Quelles valeurs ils admettent | `.dev/schemas/decision.cue`, énumérations |
| Quel est le cycle de vie | `RES-009`, champ `cycle-de-vie`, et sa section `domain-status` |
| Qui peut l'éditer | `RES-009`, champ `edition` |
| Vers quoi elle peut pointer | `RES-009`, champ `relations-admissibles` |

**Aucun de ces trois endroits n'est un fichier qu'on lit pour répondre à une question.** `RES-009` fait plusieurs centaines de lignes de prose, le schéma `cue` n'est pas fait pour être lu, et la section `domain-status` vient d'être écrite une heure plus tôt.

**C'est exactement une violation de `PDC-001`.** Le principe exige que toute fonction du système soit découvrable **depuis le système lui-même**. Le modèle de ressources est une fonction du système, et il n'est découvrable qu'en ouvrant des fichiers.

## Ce que `clia res show` ne fait pas

Il exécute `cat` sur le fichier. Sur `RES-009`, cela donne la définition entière — la prose, les objections, les points ouverts.

**`show` montre un document. Ce qui manque est de montrer un *type*.** Les deux ne se recouvrent pas : l'un rend un fichier, l'autre répond à une question.

## Ce que la commande doit rassembler, et d'où

Tout est mécaniquement disponible. Rien n'est à rédiger.

| Rubrique | Source |
|---|---|
| Préfixe, emplacement, famille | Frontmatter du `RES` |
| Cycle de vie, régime d'édition | Frontmatter du `RES` |
| Champs obligatoires | Frontmatter du `RES` |
| **Valeurs admises de chaque champ** | **Schéma `cue` du type** |
| Valeurs de `domain-status` | Section écrite par la tâche 11, ou le schéma |
| Relations admissibles, sections | Frontmatter du `RES` |
| Skill, ADR | Frontmatter du `RES` |
| Nombre d'instances | Comptage du répertoire |

**La dernière ligne est celle qui manque le plus** : savoir qu'un type a deux instances ou soixante change ce qu'on en pense.

## Ce que je décide en avançant

**`explain` et `help` sont le même verbe.** L'humain écrit `explain|help`. Un seul comportement, deux noms — comme `ls|list` et `configuration|config|c` ailleurs dans le CLI.

**La commande accepte un type comme une instance.** `clia res explain RES-009` et `clia res explain DCN-016` doivent tous deux expliquer le type `decision` : l'humain qui bute sur une décision a sous les yeux `DCN-016`, pas `RES-009`. Exiger qu'il fasse la conversion lui-même serait le renvoyer au problème.

**Les valeurs admises sont lues dans le schéma `cue`.** C'est la seule source qui les porte de façon mécanique, et le chantier C de la tâche 11 vient d'établir qu'on sait les en extraire.

## Ce que je surveille

**Un ADR est une décision d'architecture, et `CONSTITUTION.md` C1 réserve les décisions à l'humain.** `NON-024` conteste que l'agent en rédige. **L'humain le demande ici explicitement** — « ajouter un ADR qui impose » — ce qui lève l'objection pour ce cas, sans la lever en général.

**La condition « si ce plan est SMART ».** Le plan doit satisfaire les trois contrôles de `PDC-003` avant que j'implémente quoi que ce soit. Je les vérifierai, et je le dirai.

## Ce que j'écarte

**Générer la documentation dans un fichier.** L'ADR portera sur la commande, non sur une sortie statique : un fichier généré se périme, une commande lit l'état courant.

**Toucher `clia res show`.** Il fait ce qu'il annonce.
