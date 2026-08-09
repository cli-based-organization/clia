---
type: adr
version: 0.1.1
title: "Version du système d'augmentation, découverte et marque d'installation"
status: À réviser
date: 2026-07-29
---

# ADR-013 - Version du système d'augmentation, découverte et marque d'installation

- **Décideurs** : Jérémy Viau-Trudel (humain), agent IA
- **Sources** : [`PLN-018`](../plans/PLN-018-preparation-installation-outil-et-depot.md) étape 1.2, résolution de l'objection 3 à la tâche 40 de `.dev/session.md`, [`ANL-015`](../analyses/ANL-015-faisabilite-installation-et-versions.md) (constats C1, C2, C9 ; recommandations R1 et R2)

## Contexte

Trois parcours d'usage manipulent un objet nommé version : créer un dépôt équipé en y enregistrant la version posée ([`USE-002`](../usages/USE-002-creer-un-depot-neuf-deja-equipe.md), pas 5), énumérer les versions disponibles et dire laquelle est installée ([`USE-003`](../usages/USE-003-connaitre-les-versions-disponibles.md)), et plus tard se déplacer d'une version à l'autre.

[`ANL-015`](../analyses/ANL-015-faisabilite-installation-et-versions.md) constate que cet objet **n'a aucun référent** dans le modèle actuel (constat C1) : `version.yaml` porte la version du domaine métier, explicitement séparée du système d'augmentation par [`ADR-007`](ADR-007-architecture-systeme-augmentation.md) ; [`ADR-004`](ADR-004-ressources-livrables.md) a aboli le manifeste central au profit de versions portées par chaque ressource ; et aucune étiquette n'existe dans le dépôt. Corollaire (constat C2) : rien, dans un dépôt équipé, ne dit ce qui y est installé.

La résolution humaine de la tâche 40 lève l'essentiel de ce constat par une observation que l'analyse avait manquée : **dans le dépôt source, la version du domaine métier est la version du système d'augmentation**, puisque ce dépôt ne produit rien d'autre. Il n'y a donc pas de troisième domaine de version à créer.

## Décision (résumé)

> Dans le **dépôt source**, la version du système d'augmentation **est** la version du domaine métier (`version.yaml`) : les deux coïncident parce que le domaine de ce dépôt est le système lui-même. Les **versions disponibles** sont les **étiquettes** du dépôt source, chacune correspondant à un état de ce fichier. Dans un **dépôt utilisateur**, où les deux versions sont distinctes et sans rapport, une **marque d'installation** (`.dev/installation.yaml`) enregistre la version posée, la date, la source et l'empreinte des fichiers écrits. Cette marque est la **source de vérité** de ce qui est installé ; la **déduction depuis les versions de frontmatter** en est un **contrôle de cohérence**, jamais une source concurrente.

## Décisions détaillées

### D1 - Coïncidence des versions dans le dépôt source

- **Décision** : dans le dépôt qui produit le système d'augmentation, `version.yaml` porte **à la fois** la version du domaine métier et celle du système d'augmentation, parce que ce domaine **est** ce système. La commande de publication existante l'incrémente déjà selon semver.
- **Portée stricte de la coïncidence** : elle vaut **pour ce dépôt et pour lui seul**. Dans un dépôt utilisateur, `version.yaml` porte la version du contenu métier de ce dépôt, qui n'a aucun rapport avec la version du système d'augmentation qui y est installée. Confondre les deux ferait qu'une publication de contenu métier semblerait déplacer la version du harnais.
- **Conséquence** : [`ADR-007`](ADR-007-architecture-systeme-augmentation.md) est amendé pour énoncer cette coïncidence et sa limite.
- *Alternatives écartées* : **créer un troisième domaine de version** avec son propre fichier dans le harnais : rejeté, c'est la réintroduction du manifeste central que [`ADR-004`](ADR-004-ressources-livrables.md) a aboli, et un fichier de plus à tenir cohérent avec `version.yaml` sans qu'aucun des deux ne fasse autorité. **Agréger les versions de frontmatter** des ressources pour en déduire une version d'ensemble : rejeté, une collection de versions ne définit aucun ordre global, et deux états différents du dépôt pourraient produire le même agrégat.

### D2 - Les versions disponibles sont les étiquettes du dépôt source

- **Décision** : une version publiée du système d'augmentation est une **étiquette** semver posée sur le dépôt source, correspondant à un état de `version.yaml`. L'énumération des versions disponibles est la lecture de ces étiquettes, en lecture seule, hors ligne, triée selon l'ordre semver et non l'ordre lexicographique.
- **Qui pose les étiquettes** : l'humain, jamais l'outil ni l'agent. La frontière lecture / écriture d'[`ADR-010`](ADR-010-clia-setup-commandes-modes-installation.md) (décision D5) autorise l'outil à les lire, pas à les créer.
- **Cas à traiter, qui sont aujourd'hui la règle et non l'exception** :
  - **aucune version publiée** : le dépôt source n'en porte aucune à ce jour. L'énumération doit le dire explicitement plutôt que rendre une liste vide sans explication (flux `2a` de [`USE-003`](../usages/USE-003-connaitre-les-versions-disponibles.md)) ;
  - **arbre source à un état de travail** ne correspondant à aucune étiquette : c'est l'état normal du dépôt pendant son développement. Une installation faite depuis cet état est valide, et la marque doit pouvoir l'exprimer (voir D3).
- *Alternative écartée* : tirer les versions d'une publication distante : hors périmètre, cela introduirait le réseau, la vérification d'intégrité et les risques associés ([`FND-008`](../fondations/FND-008-installateurs-packaging.md)).

### D3 - La marque d'installation

- **Décision** : un dépôt équipé porte un fichier d'état, `.dev/installation.yaml`, dans la zone de développement. Il enregistre :
  - la **version** du système d'augmentation posée, ou l'indication explicite qu'elle provient d'un état de travail sans étiquette ;
  - l'**identifiant de la révision source**, qui reste exact même sans étiquette ;
  - la **date** de l'opération ;
  - le **mode de pose** (copie ou lien, [`ADR-010`](ADR-010-clia-setup-commandes-modes-installation.md) décision D6) ;
  - l'**empreinte** de chaque fichier posé.
- **Nature** : c'est un **fichier d'état**, ni ressource livrable ni trace. Il n'est pas versionné en semver, ne porte pas de frontmatter markdown, et n'est pas produit par un skill. Il est écrit par l'outil et lu par l'outil.
- **Ce que l'empreinte sert** : détecter qu'une ressource d'augmentation a été **modifiée localement** dans la cible. C'est le seul moyen d'éviter qu'une mise à niveau ultérieure n'écrase du travail sans le signaler. La présente décision la fait **écrire** ; son exploitation en cas de conflit relève des parcours de version.
- **Pourquoi ce n'est pas le manifeste aboli** : le manifeste centralisait les versions **de la source** et servait de source de vérité pour les ressources du dépôt qui le portait. La marque enregistre l'état **d'une installation** dans un dépôt tiers. Ni le même lieu, ni le même propriétaire, ni la même durée de vie, ni le même lecteur. Le dire ici évite que l'objection ne revienne à chaque relecture.

### D4 - La déduction depuis les frontmatters est un contrôle, pas une source

- **Décision** : comparer les versions portées par les frontmatters des ressources d'augmentation installées à ce que la marque déclare constitue un **contrôle de cohérence**. Il signale deux anomalies : un dépôt dans un **état mixte** (ressources de versions hétérogènes), et une **marque qui ment** (l'état réel ne correspond pas à ce qu'elle affirme).
- **Motif** : la résolution humaine de la tâche 40 proposait la marque « ou bien » la déduction. Les deux sont retenues, à des postes distincts et non concurrents. La déduction ne peut pas être la source de vérité pour la raison énoncée en D1 ; elle est en revanche le seul moyen de vérifier la marque sans faire confiance à ce qu'elle affirme.
- **Conséquence** : la marque reste faisant foi ; le contrôle produit un signalement, jamais une correction automatique.

### D5 - Reconnaître un dépôt équipé

- **Décision** : la marque est le **marqueur de reconnaissance** attendu par la décision D9 d'[`ADR-010`](ADR-010-clia-setup-commandes-modes-installation.md). Sa présence et sa lisibilité établissent l'état « équipé et marqué ».
- **Cas de repli** : lorsque la marque est absente mais que les fichiers de harnais sont présents, le dépôt est **équipé sans marque**. Cet état n'est ni assimilé à « non équipé » (ce serait proposer d'équiper un dépôt qui l'est déjà, au risque d'écraser) ni assimilé à « équipé » (ce serait laisser croire qu'on sait ce qui est installé). Il est **signalé comme à régulariser**.
- *Alternative écartée* : reconnaître un dépôt à la seule présence des fichiers de harnais : rejeté, cela rendrait la marque facultative et priverait les parcours de version de leur point de départ.

## Conséquences

**Positives**

- Aucun objet nouveau n'est créé dans le dépôt source : la version y existait déjà, sous un autre nom.
- L'énumération des versions ne coûte rien à maintenir : les étiquettes sont posées par l'humain dans le cours normal de son travail.
- Un dépôt équipé sait ce qu'il porte, ce qui est la précondition de toute mise à niveau ultérieure.
- Marque et contrôle de cohérence se vérifient mutuellement plutôt que de se concurrencer.

**Négatives / risques**

- La coïncidence énoncée en D1 est **contextuelle** : vraie dans le dépôt source, fausse ailleurs. Une règle qui change de valeur de vérité selon le dépôt est une règle qu'on applique mal un jour. Sa limite doit être répétée partout où elle est citée.
- Tant qu'aucune étiquette n'est posée, toutes les installations proviennent d'un état de travail et aucune version publiée n'existe. Le mécanisme est correct mais reste sans matière.
- L'empreinte est écrite avant d'avoir un lecteur : les parcours qui l'exploitent sont hors portée immédiate. Sa justesse ne sera éprouvée que par le harnais de test.
- L'état « équipé sans marque » n'a pas de commande pour le régulariser dans la portée actuelle. C'est un cul-de-sac connu, à ouvrir avec les parcours de version.

## Migration / porte de sortie

Aucune migration : le dépôt source ne porte encore aucune étiquette et aucun dépôt utilisateur n'est équipé. La première étiquette posée établira la première version publiée. Si l'usage montre que l'empreinte est trop coûteuse à tenir, elle peut être réduite à un sous-ensemble de fichiers sans remettre en cause le reste de la décision.

## Références

- [`PLN-018-preparation-installation-outil-et-depot`](../plans/PLN-018-preparation-installation-outil-et-depot.md) (étape 1.2)
- [`ADR-010-clia-setup-commandes-modes-installation`](ADR-010-clia-setup-commandes-modes-installation.md) (décisions D5, D6, D9)
- [`ADR-004-ressources-livrables`](ADR-004-ressources-livrables.md) (abolition du manifeste, versions en frontmatter)
- [`ADR-007-architecture-systeme-augmentation`](ADR-007-architecture-systeme-augmentation.md) (versions indépendantes, amendé par la décision D1)
- [`ANL-015-faisabilite-installation-et-versions`](../analyses/ANL-015-faisabilite-installation-et-versions.md) (constats C1, C2, C9)
- [`USE-002`](../usages/USE-002-creer-un-depot-neuf-deja-equipe.md), [`USE-003`](../usages/USE-003-connaitre-les-versions-disponibles.md)
- [`FND-008-installateurs-packaging`](../fondations/FND-008-installateurs-packaging.md)
