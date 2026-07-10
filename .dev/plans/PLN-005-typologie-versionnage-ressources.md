# PLN-005 - Typologie des ressources livrables (axe cycle de vie) et versionnage atomique

**Statut : objection**

## Intention

Formaliser une **typologie des ressources livrables** selon l'axe du **cycle de vie** (distinct de l'axe des droits d'édition déjà en place dans `CONSTITUTION.md`), et proposer un **mécanisme de versionnage atomique** où un ensemble de ressources porte une version et où chaque ressource de l'ensemble porte aussi la sienne. Le tout est acté dans un ADR sur les ressources livrables, puis reflété dans le harnais.

## Contexte

Demande de la tâche 12 de `session.md`. L'humain distingue, parmi les documents sous gestion de l'IA, trois catégories sur l'axe du cycle de vie :

1. **Point fixe dans le temps** (produit une fois, non modifié) : `FND`, `ANL`, `logs/ia-output/*`, et documents publiés (`publications/*`).
2. **Vivant** (évolue et mûrit sur un cycle long, versionné en *semantic versioning*) : `ADR`, `REQ`, `SPEC`, `skl` (skills), base de code.
3. **Document de travail** (cycle court, sans suivi de version) : `PLN`.

Exemple de versionnage atomique donné par l'humain : l'ensemble des fichiers de harnais a une version, et chaque fichier qu'il contient (`CLAUDE.md`, `CONSTITUTION.md`, chaque skill, etc.) a aussi une version.

Cet axe « cycle de vie » est **orthogonal** à la classification existante par droits d'édition (humain-only / IA-only / co-édition). Une même ressource relève des deux axes (ex. un skill est en co-édition ET vivant/semver).

## Spécification du livrable

À produire après approbation :

1. **ADR-004** - `.dev/adr/ADR-004-ressources-livrables.md` : définit les notions de ressource / livrable / document, la typologie par cycle de vie (les trois catégories), et le mécanisme de versionnage atomique retenu. Produit par `skl-006`.
2. **Amendement `CONSTITUTION.md`** (`skl-004`) : ajouter une section « Classification par cycle de vie » complétant la « Classification des documents » existante (droits d'édition), en précisant leur orthogonalité.
3. **Amendement `CLAUDE.md`** (`skl-004`) : renvoyer vers la typologie et la convention de versionnage ; indiquer où vit la version de chaque type.
4. **Manifeste de versions** - `.dev/RESSOURCES.md` (ou format retenu en OBJECTION-1) : registre agrégateur listant chaque ressource vivante et sa version, et chaque ensemble et sa version.

## Proposition de mécanisme de versionnage atomique (à valider)

Conception proposée, sujette aux objections ci-dessous :

- **Catégorie 1 (point fixe)** : pas de semver. Identité = préfixe + séquence + date. Une ressource fixe ne se modifie pas ; si son contenu doit changer, on produit une **nouvelle instance numérotée** qui supersède l'ancienne (ex. `ANL-002` supersède `ANL-001`), l'ancienne restant intacte comme trace.
- **Catégorie 2 (vivant)** : **semver `MAJEUR.MINEUR.CORRECTIF`** porté par chaque ressource. Règles de déclenchement proposées :
  - MAJEUR : changement incompatible du contrat/sens (un skill change son processus de façon rupturante ; un ADR renverse sa décision ; un REQ retire ou durcit une exigence existante).
  - MINEUR : ajout rétrocompatible (nouvelle section, nouvelle règle, nouvelle exigence optionnelle).
  - CORRECTIF : clarification sans effet sémantique (typo, reformulation, correction de lien).
- **Catégorie 3 (travail)** : pas de version ; le `Changelog` en tête de plan suffit (déjà en usage).
- **Versionnage composite (atomique)** :
  - chaque ressource vivante porte sa version dans son **frontmatter** (`version: X.Y.Z`) ;
  - chaque **ensemble** défini (ex. « harnais », « collection de skills », « base de code ») porte sa propre version dans le **manifeste** `.dev/RESSOURCES.md` ;
  - **atomicité** : toute modification d'une ressource vivante bumpe, dans la même opération, (a) la version de la ressource et (b) la version de l'ensemble qui la contient, avec mise à jour du manifeste. Le manifeste est ainsi toujours cohérent avec l'état des membres.
  - le versionnage est **piloté par fichiers** (frontmatter + manifeste), pas par tags git, conformément à l'interdiction faite à l'agent d'opérer git et au principe « interface = fichiers ».

## Plan proposé

### 1. Rédiger ADR-004
Définir ressource / livrable / document, la typologie par cycle de vie, et le mécanisme de versionnage (selon la proposition ci-dessus, amendée par les objections résolues).

### 2. Définir les ensembles versionnés
Lister les ensembles portant une version (au minimum : harnais ; à discuter : collection de skills, base de code, convention CLI comme ensemble ADR-002 + REQ-001 + SPEC-001).

### 3. Créer le manifeste `.dev/RESSOURCES.md`
Registre initial : chaque ressource vivante et sa version de départ (`0.1.0` ou `1.0.0`, voir OBJECTION-4), chaque ensemble et sa version.

### 4. Amender le harnais
Ajouter la « Classification par cycle de vie » dans `CONSTITUTION.md` et les renvois dans `CLAUDE.md` ; préciser où vit la version de chaque type (frontmatter, manifeste, ou en-tête pour les fichiers sans frontmatter comme `CLAUDE.md`).

### 5. Cohérence croisée
Vérifier l'articulation avec la classification par droits d'édition et avec les skills existants (ex. `skl-004` pour le harnais versionné).

## Objections de l'agent IA

### [OBJECTION-1] Où vit la version, pour les fichiers sans frontmatter ?
**Risque :** `CLAUDE.md` et `CONSTITUTION.md` n'ont pas de frontmatter (forme source, PLN-003). Y ajouter un `version:` en frontmatter romprait cette forme ; ne rien y mettre laisse leur version seulement dans le manifeste, créant une asymétrie avec les skills (qui, eux, ont un frontmatter). **Décision requise :** version en frontmatter partout (au prix d'ajouter un frontmatter à `CLAUDE.md`/`CONSTITUTION.md`), ou version dans le manifeste seul, ou en-tête ligne dédiée.

### [OBJECTION-2] Un ADR est conventionnellement immuable
**Risque :** classer les `ADR` en catégorie « vivant/semver » entre en tension avec la pratique établie (un ADR accepté ne se modifie pas ; on le supersède par un nouvel ADR, cf. le champ « Remplacé par ADR-XXX » de `skl-006`). Versionner un ADR en semver pourrait brouiller sa fonction de trace décisionnelle. **Proposition :** conserver l'ADR immuable quant à la décision, et réserver le semver aux corrections éditoriales (CORRECTIF) et aux ajouts non décisionnels ; tout renversement de décision passe par un nouvel ADR. **Décision requise.**

### [OBJECTION-3] Périmètre des ensembles versionnés
**Risque :** sans liste arrêtée des ensembles, le versionnage composite est ambigu (un fichier peut appartenir à plusieurs ensembles). **Décision requise :** quels ensembles portent une version, et un fichier peut-il appartenir à plusieurs ensembles versionnés à la fois ?

### [OBJECTION-4] Version initiale et statut de maturité
**Risque :** démarrer les ressources existantes à `1.0.0` laisserait entendre une maturité non atteinte (premiers jets). **Proposition :** initialiser les ressources de premier jet à `0.1.0`. **Décision requise.**

### [OBJECTION-5] Conséquence sur l'immuabilité déjà enfreinte
**Signalement (non bloquant) :** à la tâche 7, des logs (catégorie 1, immuables) ont été édités pour retirer des tirets cadratins. Sous cette typologie, un tel cas devrait passer par une nouvelle instance ou une note de correction, pas par une édition en place. À intégrer comme règle prospective dans l'ADR.

### [OBJECTION-6] Répertoire `publications/` inexistant
**Signalement (non bloquant) :** `publications/*` est cité en catégorie 1 mais n'existe pas encore. Il sera créé au premier document publié ; l'ADR peut le prévoir sans le matérialiser maintenant.

## Note sur les objections humaines

Conformément à la gouvernance, les objections de l'humain sur ce plan ne sont pas consignées ici mais dans `.dev/session.md`.
