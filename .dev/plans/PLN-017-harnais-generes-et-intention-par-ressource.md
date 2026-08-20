---
type: plan
id: PLN-017
title: "Harnais générés et intention par ressource"
status: draft
maturity: conception
adoption: propose
activated: true
domain-status: "execute"
statut-plan: execute
date: 2026-08-13
initiateur: agent
sert: [FNC-003]  # instrumentation d'un dépôt
porte-sur: [BUG-006, lib/clia/setup.sh]
---

# PLN-017 - Harnais générés et intention par ressource

> `BUG-006` : `clia setup init` copie les harnais du dépôt source, et un dépôt neuf hérite de l'intention de `clia` mot pour mot. Quatre chantiers pour que les harnais soient **générés** et que l'intention soit une **ressource**.

## Statut

`execute`. **Les quatre chantiers ont été exécutés par la tâche 16 de `SES-002`, le 2026-08-13.**

**Le critère du chantier B a été corrigé en l'exécutant.** Il exigeait un `diff` non vide entre les harnais générés et ceux du dépôt source, pour `CLAUDE.md` et `CONSTITUTION.md`. Les deux fichiers décrivent le système `clia`, pas le projet `clia` : leur contenu peut être identique d'un dépôt à l'autre sans que ce soit un défaut. Le critère corrigé exige l'**indépendance** de la sortie envers le fichier racine du dépôt source, prouvée par deux essais symétriques : modifier `$source/CLAUDE.md` ne change rien à la sortie ; modifier le gabarit dans `.dev/templates/harnais/` la change. Les deux ont été éprouvés sur un dépôt jetable, et le second est devenu un test du banc.

**Un bogue trouvé en préparant le chantier C, non corrigé ici** : `clia_resource_new` ne pose plus `maturity`, `adoption`, `activated` depuis que `DCN-016` est en vigueur. `BUG-007` le documente. Ma propre génération de `INT-001`, chantier C, pose les trois champs directement et n'en dépend pas.

Produit par la tâche 15, qui ne l'a pas exécuté : `MET-005` étape 1.

## Intention

Qu'un dépôt neuf reçoive les harnais que `clia` prescrit, et déclare sa propre intention.

**Cible mesurable.** Après `clia setup init` sur un dépôt vierge : `CONSTITUTION.md` existe, `INTENTION.md` est un lien vers `.dev/intentions/INT-001.md`, et son contenu ne se retrouve dans aucun autre dépôt.

## Chantiers

### Chantier A - La source de vérité des harnais

| Élément | Valeur |
|---|---|
| **Livrable** | `.dev/harnais.yaml`, et un gabarit par harnais dans `.dev/templates/harnais/` |
| **Critère de réussite** | Le fichier déclare les quatre harnais avec, pour chacun, son nom, son gabarit, et s'il est **obligatoire ou optionnel** ; `ARCHITECTURE.md` y est optionnel et `CONSTITUTION.md` obligatoire |
| **Limite de temps** | 2 heures |
| **Dépend de** | rien |

**Ce que le chantier déclare**, et que rien ne portait :

| Harnais | Régime |
|---|---|
| `CLAUDE.md` | Obligatoire |
| `CONSTITUTION.md` | Obligatoire |
| `INTENTION.md` | Obligatoire, mais **lié**, voir chantier C |
| `ARCHITECTURE.md` | **Optionnel** : il décrit `clia`, non un dépôt quelconque |

**Le gabarit de `CONSTITUTION.md` est à écrire** : le dépôt en a un, et il porte les règles de `clia` sur lui-même. Ce qui est générique — C2 réserve le commit à l'humain — s'y retrouve ; ce qui est propre à `clia` n'y entre pas.

### Chantier B - Générer au lieu de copier

| Élément | Valeur |
|---|---|
| **Livrable** | `lib/clia/setup.sh`, fonction de génération remplaçant `cp -p` pour les harnais |
| **Critère de réussite** | ~~Sur un dépôt jetable, `clia setup init` produit `CLAUDE.md` et `CONSTITUTION.md` ; `diff` contre les fichiers du dépôt source est non vide pour les deux~~ **corrigé en exécutant, voir ci-dessous** |
| **Limite de temps** | 3 heures |
| **Dépend de** | A |

**Critère corrigé, tâche 16.** Un `diff` non vide forçait une différence artificielle : `CLAUDE.md` et `CONSTITUTION.md` décrivent le système `clia`, pas le projet `clia`, et un contenu identique d'un dépôt à l'autre y est correct. Ce que `BUG-006` reproche est la **dépendance** au fichier racine du dépôt source, pas une éventuelle identité de contenu.

**Le critère devient : la sortie dépend du gabarit, jamais du fichier racine du dépôt source.** Éprouvé par deux essais symétriques sur un dépôt jetable — modifier `$source/CLAUDE.md` ne change rien à la sortie ; modifier le gabarit dans `.dev/templates/harnais/` la change. Les deux figurent au banc de tests.

**Ce que la génération remplace.** `clia_setup_poser` copiait ou liait le fichier source. `clia_setup_generer_harnais` lit le gabarit déclaré par `harnais.yaml`, jamais le fichier racine.

### Chantier C - L'intention devient une ressource

| Élément | Valeur |
|---|---|
| **Livrable** | `.dev/intentions/INT-001-<slug>.md` et le lien `INTENTION.md` |
| **Critère de réussite** | Après `init` sur un dépôt vierge : `INTENTION.md` est un lien symbolique **relatif** vers `.dev/intentions/INT-001-*.md`, et le fichier cible est un gabarit **sans aucune phrase de l'intention de `clia`** |
| **Limite de temps** | 2 heures |
| **Dépend de** | A |

**C'est le motif de `PLN-008`, appliqué à l'intention.** Le fichier de session vit dans `.dev/logs/` et `workspace/session.md` n'est qu'un lien ; l'intention suit la même règle.

**Ce que le chantier donne au passage** : la première instance du type `intention`, défini par `RES-003` depuis le 2026-08-09 et jamais instancié.

**Le lien est relatif**, comme celui de la session : un dépôt déplacé ne casse pas.

### Chantier D - Migrer un dépôt déjà instrumenté

| Élément | Valeur |
|---|---|
| **Livrable** | `lib/clia/setup.sh`, traitement d'un `INTENTION.md` préexistant |
| **Critère de réussite** | Sur un dépôt portant un `INTENTION.md` réel et non vide, `init` le déplace vers `.dev/intentions/INT-001-*.md`, pose le lien, et **le contenu est intact** — `diff` avant et après est vide |
| **Limite de temps** | 2 heures |
| **Dépend de** | C |

**L'exigence est celle de l'humain** : « si un fichier INTENTION.md existe déjà, le déplacer vers INT-001.md et en faire un symlink ».

**Ce que le critère protège.** Le contenu d'une intention écrite à la main ne doit pas être perdu par une migration. `ANL-005` T1 pose qu'un renommage accompagné d'une réécriture coupe l'historique : ici le déplacement est fait sans réécriture, et le `diff` l'établit.

## Livrables attendus

| Livrable | Chantier | Durée |
|---|---|---|
| `harnais.yaml` et les gabarits | A | 2 h |
| Génération au lieu de copie | B | 3 h |
| L'intention comme ressource liée | C | 2 h |
| La migration d'un dépôt existant | D | 2 h |
| | **Total** | **9 h** |

## Ce qui est écarté

**La génération des skills.** L'humain les nomme dans sa liste — « CLAUDE.md, SKILLs, CONSTITUTION.md, ARCHITECTURE.md ». Elle sort du plan : `ADR-016` D3 pose que les skills sont dérivables de `RES`, `ADR`, `SPC` et `RQF`, et **aucun générateur n'existe** — `ISU-002` et `NON-025` le portent depuis le 2026-08-11.

**Aucun critère exécutable ne peut être écrit** tant que la règle de dérivation n'est pas établie. `PDC-003` interdit d'appeler cela un chantier SMART. Les sept skills du dépôt restent copiés, et ce plan ne le change pas.

**La reprise du dépôt `clia-repos` déjà initialisé.** Le chantier D livre le mécanisme ; l'appliquer à ce dépôt-là est un geste de l'humain, sur son dépôt.

## Objections de l'agent

**Le gabarit de `CONSTITUTION.md` est à écrire, et une constitution est un document d'autorité.** `CONSTITUTION.md` C1 réserve les décisions à l'humain. Le chantier A produit un **gabarit**, non une constitution en vigueur : la distinction tient tant que le gabarit ne pose pas de règle que l'humain n'a pas voulue.

**Neuf heures déclarées, et aucune durée du dépôt n'a jamais été mesurée.** Comme `PLN-007`, les estimations sont déclarées telles quelles — `PDC-003` V-S3 exige une déclaration, non une justification.

**Le chantier B change le régime d'un mécanisme éprouvé.** `clia setup init` fonctionne et a été validé par la tâche 5. Remplacer la copie par la génération peut casser ce qui marche ; le critère l'éprouve sur un dépôt jetable, non sur un dépôt réel.

## Relations

- `derive-de` [BUG-006](../bogues/BUG-006-l-initialisation-copie-l-intention-du-depot-source.md)
- `reference` [PLN-008](PLN-008-chaine-de-session-par-lien-symbolique.md)
- `reference` [PLN-009](PLN-009-commandes-d-installation-et-d-instrumentation.md)
- `reference` [RES-003](../ressources/RES-003-intention.md)
- `reference` [ISU-002](../issues/ISU-002-aucun-generateur-de-ressources-derivees.md)
