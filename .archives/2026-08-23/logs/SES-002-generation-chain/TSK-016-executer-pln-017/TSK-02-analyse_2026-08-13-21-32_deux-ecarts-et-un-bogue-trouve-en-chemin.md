# Analyse, tâche 16 de SES-002

`MET-003` étape 2. Écrit après avoir lu `setup.sh`, `CONSTITUTION.md`, `ARCHITECTURE.md`, `RES-003` et leur schéma.

## Ce que le terrain établit, que le plan ne savait pas

### Écart 1 — le critère du chantier B ne tient pas pour `CLAUDE.md`

`PLN-017` chantier B exige un `diff` **non vide** entre les harnais générés et ceux du dépôt source, pour `CLAUDE.md` et `CONSTITUTION.md`.

**J'ai lu les deux fichiers.** Aucun ne porte de contenu propre au *projet* `clia` — tous deux décrivent le système `clia` en général, applicable tel quel à n'importe quel dépôt instrumenté. `CONSTITUTION.md` ne cite que des mécanismes génériques (`INTENTION.md`, `workspace/session.md`, `.dev/decisions/`). `CLAUDE.md` définit `clia` lui-même, ce qui est une information correcte pour **tout** dépôt qui l'utilise.

**Le vrai défaut de `BUG-006` n'est pas « identique à la source »**, c'est « **dépend** de la source ». `INTENTION.md` est fautif parce que son contenu — le but d'un dépôt précis — ne peut être vrai que pour un seul dépôt. `CLAUDE.md` et `CONSTITUTION.md` peuvent légitimement être identiques partout, parce qu'ils décrivent le système et non le projet.

**Un `diff` non vide forcerait une différence artificielle** là où l'identité est correcte. Ce serait satisfaire la lettre du critère et trahir son esprit — exactement le défaut relevé sur le critère de `PLN-013` à la tâche 9.

**Le critère corrigé** : la génération ne doit pas dépendre du fichier racine du dépôt source, mais d'un gabarit **découplé**, situé dans `.dev/templates/harnais/`. Le test devient : modifier le gabarit change la sortie ; modifier `$source/CLAUDE.md` ne la change pas. C'est la propriété que `BUG-006` réclame réellement — l'indépendance du mécanisme, pas une différence de façade.

**Décidé en avançant** — `MET-005` étape 2 : réversible, code, une lecture qui tient à l'examen du contenu réel, se tromper coûte une correction.

### Écart 2 — le gabarit d'`INTENTION.md` n'est pas un fichier statique

Chantier A demande un gabarit par harnais. Pour les trois premiers, un fichier `.tmpl` convient. **Pour `INTENTION.md`, ce serait dupliquer `RES-003`.**

`RES-003` déclare déjà les champs obligatoires et les sections d'une intention. Écrire un second gabarit statique répéterait cette déclaration ailleurs, avec le risque de désynchronisation que `ADR-018` D2 vient de nommer pour un autre cas : « une documentation rédigée à part se périme, une dérivation ne le peut pas ».

**Le gabarit d'`INTENTION.md` est donc `RES-003` lui-même** : le chantier C dérive le contenu du squelette depuis les champs et sections que `RES-003` déclare, au lieu de lire un fichier `.tmpl`. `harnais.yaml` le documente ainsi plutôt que de mentir sur un fichier gabarit qui n'existerait pas.

## Un bogue trouvé en préparant ce travail, et non corrigé ici

**`clia res new` ne pose plus les trois champs universels depuis `DCN-016`.**

Mesuré : une instance créée à l'instant échoue `cue vet`, faute de `maturity`, `adoption`, `activated`. Le code qui les pose n'existe dans aucune des fonctions de création — ni dans `clia_resource_new`, ni ailleurs.

**Trois instances du dépôt en portent la marque** : `DCN-019`, `DCN-020`, `ISU-013`, créées par l'humain après 16:29 — l'heure où le chantier D de `PLN-007` a posé les champs sur les 183 instances existantes, sans toucher au code qui en crée de nouvelles.

**Je ne le corrige pas dans cette tâche.** `clia_resource_new` est un autre module, touché par aucun chantier de `PLN-017`. Le corriger ici mélangerait deux livrables sous une seule directive, contre `MET-005` étape 6. Ma propre génération de `INT-001`, plus bas, pose les trois champs directement — elle n'a pas besoin que `resource.sh` soit corrigé pour être juste.

**Un bogue le documente**, pour que `clia focus` le désigne après celui-ci.

## Une décision entrée en vigueur pendant que je travaillais

**`DCN-019` est maintenant rédigée** : « chaque ressource a une version qui lui est propre, incrémentée quand l'humain approuve la modification ». `effet: en-vigueur`.

**Elle ne change rien à ce que je fais ici.** Son propre corps laisse le mécanisme à définir : « on doit définir les mécanismes de validation et d'incrément de version ». Je ne bumpe donc aucune version dans ce que je produis — ni les gabarits, ni le YAML — faute de mécanisme déclaré, et parce que la décision réserve l'incrément à l'approbation humaine, non à l'agent qui écrit.

**`DCN-020` porte `effet: en-vigueur` et un corps entièrement vide.** Je ne peux pas appliquer une décision dont je ne peux pas lire le contenu. Je le signale dans le journal de suites plutôt que d'agir sur une règle que je ne connais pas.

## Ce que je vérifie avant de toucher au mécanisme éprouvé

Le plan le déclare en objection : le chantier B change le régime d'un `clia setup init` validé à la tâche 5. Je testerai chaque chantier sur un dépôt jetable avant de rien exécuter sur un dépôt réel — `clia-repos` n'est pas touché, la section « Ce qui est écarté » du plan l'exclut explicitement.
