---
type: plan
id: PLN-003
title: "Mise en conformité avec DCN-013"
status: draft
statut-plan: propose
date: 2026-08-11
initiateur: agent
porte-sur: [CONSTITUTION.md, RES-009, RES-019, lib/clia/resource.sh]
---

# PLN-003 - Mise en conformité avec DCN-013

> Huit chantiers, dont trois suffisent à lever le conflit actif. Le chantier D est bloquant et appartient à l'humain : il décide du sort de deux cent quarante-huit renvois. Ce plan n'est pas exécuté.

## Statut

`propose`. Aucun chantier n'est engagé.

Le diagnostic et les mesures sont dans `ANL-006`. Ce plan ordonne l'adaptation.

**Limite de temps.** Non déclarée. `PDC-003` V-S3 l'exige au régime extrême SMART, et les cinq plans du dépôt échouent à ce contrôle. Le défaut porte sur le plan entier, non sur un chantier ; il est constaté ici plutôt que corrigé, faute de base pour estimer une durée.

## Intention

Rendre le dépôt conforme à `DCN-013`, qui fait de la décision humaine l'autorité ultime.

Cible mesurable : **zéro conflit actif** entre un document de harnais et une `DCN`.

## Chantiers

### Chantier A - Aligner CONSTITUTION.md sur DCN-013

Le conflit le plus direct, et le seul qui soit actif aujourd'hui.

`CONSTITUTION.md` C1 dit « un agent IA ne crée ni ne modifie une décision ». `DCN-013` dit que l'IA peut rédiger un premier jet, suspendu jusqu'à approbation. `DCN-013` est l'autorité ultime par son propre énoncé.

| Étape | Action |
|---|---|
| A1 | Réécrire C1 : la **création** est réservée à l'humain, la **rédaction** est permise à l'agent, la décision est alors suspendue |
| A2 | Nommer l'approbation comme un geste distinct, réservé à l'humain |
| A3 | Étendre ou non le régime aux `PDC`, selon la réponse à `NON-027` Q1 |

**Coût.** Un fichier, trois éditions.

**Dépend de.** Rien pour A1 et A2. A3 dépend d'une réponse humaine.

**Vérification.** Aucun document de harnais ne contredit une `DCN`.

### Chantier B - Poser la garde de création

`DCN-013` réserve la création d'une `DCN` à l'humain, via `clia res new`. La commande ne fait aucune distinction.

| Étape | Action |
|---|---|
| B1 | `clia res new decision` refuse dans un environnement d'agent, code 3 |
| B2 | Le message renvoie à `DCN-013` et nomme le geste attendu de l'humain |
| B3 | Tests, sur le modèle des six qui couvrent `clia git save` |

**Coût.** Un module, une garde, trois tests. Le mécanisme existe déjà : `clia_git_acteur_est_agent` est réutilisable tel quel.

**Dépend de.** Chantier A, qui fixe ce qui est interdit.

**Point à trancher.** La garde s'applique-t-elle aussi à `principe-de-conception` ? Même question que A3.

### Chantier C - Enrichir le champ effet

`DCN-013` nomme le besoin : un champ qui dit si la décision est active, et si non pourquoi.

| Étape | Action |
|---|---|
| C1 | Ajouter la valeur `redigee-par-agent` à l'énumération de `effet` dans `RES-009` |
| C2 | Déclarer, dans `RES-009`, quelles valeurs sont actives et lesquelles ne le sont pas |
| C3 | Régénérer `decision.cue` et `decision.input.cue` |
| C4 | Renseigner la valeur sur les instances concernées |

**Coût.** Une définition, deux schémas, treize instances.

**C4 appartient à l'humain.** `CONSTITUTION.md` C1 et `DCN-013` réservent le frontmatter d'une `DCN` à l'humain, sauf pour le cli qui répercute un état. Un outil peut donc le faire ; l'agent non.

**Alternative écartée.** Un champ `motif-inactivite` distinct. Écartée : deux champs pour un état, alors que `NON-022` conteste déjà le nombre de champs obligatoires de ce type.

### Chantier D - Décider du sort des ADR

**Bloquant.** Il appartient à l'humain et commande les chantiers E et F.

`NON-026` Q1 : « Rendre les ADR non-active. » Q2 : un ADR ne peut exister sans source.

| Mesure | Valeur |
|---|---|
| ADR du dépôt | 17 |
| ADR déclarant une `DCN` source | 6 |
| ADR sans source | **11** |
| Renvois de la forme `ADR-<SEQ> D<n>` dans les documents actifs | **248**, dans 58 fichiers |

Trois options.

| Option | Ce qu'elle demande | Ce qu'elle coûte |
|---|---|---|
| **D-a** | Marquer les 17 ADR non actifs et laisser les renvois | Le dépôt cite 248 fois des fondements sans autorité |
| **D-b** | Écrire les `DCN` manquantes, puis marquer | 11 `DCN` que seul l'humain peut créer |
| **D-c** | Marquer non actif à partir d'une date, et traiter les renvois au fil de l'eau | Un état mixte, lisible mais long |

**Recommandation de l'agent.** D-c. D-a laisse le dépôt dans un état où rien ne fonde rien, et D-b demande onze actes conscients avant tout autre travail.

### Chantier E - Rediriger les renvois

**Dépend de.** Chantier D.

Les 248 renvois citent des décisions d'ADR comme fondement. Sous `DCN-013`, le fondement est la `DCN`.

| Étape | Action |
|---|---|
| E1 | Établir la table de correspondance entre chaque décision d'ADR citée et sa `DCN` |
| E2 | Réécrire les renvois, du plus long au plus court, avec frontière de mot |
| E3 | Contrôler qu'aucun renvoi ne cite plus une décision d'ADR comme fondement |

**Coût.** 58 fichiers. Le geste est celui de la migration de la tâche 13, qui a converti 83 identifiants avec deux précautions consignées.

**Ce qui manque.** La table E1 n'existe pas et ne peut pas être dérivée : onze ADR n'ont aucune `DCN` correspondante.

### Chantier F - Nommer et spécifier les deux mécanismes de génération

`NON-026` Q5 demande de trouver un nom pour la génération déterministe par gabarit et pour la génération non déterministe par IA.

| Étape | Action |
|---|---|
| F1 | Nommer les deux mécanismes |
| F2 | Écrire la `MET` du mécanisme hybride en cinq étapes, que la source réclame par un `todo` |
| F3 | Déclarer, dans chaque `RES` de ressource générée, ses ressources sources et sa `MET` de génération |
| F4 | Implémenter les étapes 1 à 3, qui sont la part non déterministe |

**Ce que le dépôt possède déjà.** Les étapes 4 et 5 : trente gabarits et soixante-deux schémas, dont les `*.input.cue` qui sont exactement le contrat de l'étape 4.

**Ce qui manque.** Les étapes 1 à 3, et le nom.

**Dépend de.** Rien. Peut être fait en parallèle.

### Chantier G - Le verbe d'initialisation

`NON-026` Q4 demande `clia [-C ROOT_PATH] setup init <.|[PATH/]REPO_NAME>`, et « on doit définir les critères pour que clia soit un repo clia conforme ».

| Étape | Action |
|---|---|
| G1 | **Écrire les critères de conformité d'un dépôt `clia`** |
| G2 | Ajouter l'option `-C ROOT_PATH` au CLI |
| G3 | Implémenter `clia setup init` |
| G4 | Poser le lien symbolique de `INTENTION.md`, prescrit par `ADR-017` D3 |

**G1 avant tout le reste.** Sans les critères, `init` ne sait pas quoi produire et aucun contrôle ne sait quoi vérifier. C'est un livrable de spécification, type `SPC`, qui n'a aucune instance.

**L'humain régularise ce dépôt à la main**, selon sa réponse à Q4. G4 ne porte donc que sur les dépôts futurs.

### Chantier H - La forme en répertoire des définitions

`NON-026` Q5, dernière ligne, au conditionnel : « il faudrait penser à inclure DANS la ressource RES l'ensemble des dépendances nécessaires à son usage ».

| Mesure | Valeur |
|---|---|
| Définitions | 31 |
| Gabarits | 30 |
| Schémas | 62 |
| **Fichiers à déplacer** | **123** |

**Traité comme une piste, non comme une décision.** La source l'écrit au conditionnel. Le chantier est décrit pour que son coût soit connu, et il n'est pas recommandé avant que `clia validate` existe : déplacer 123 fichiers sans contrôle de conformité est le geste que `ANL-005` T1 déconseille.

## Livrables attendus

| Chantier | Livrable | Nature |
|---|---|---|
| A | `CONSTITUTION.md` | Modification |
| B | `lib/clia/resource.sh`, `tests/test_clia.sh` | Modification |
| C | `RES-009`, `decision.cue`, `decision.input.cue` | Modification |
| C | 13 instances `DCN` | Modification, par l'humain ou par le cli |
| D | Une `DCN` qui acte le sort des ADR | Création, par l'humain |
| E | Table de correspondance, puis 58 fichiers | Création, modification |
| F | Une `MET`, et les définitions des ressources générées | Création, modification |
| G | Une `SPC` de conformité, `setup.sh`, `bin/clia` | Création, modification |
| H | 123 fichiers déplacés | Migration |

## Ordre d'exécution

```
A ──> B
│
├──> C ──> [C4, humain ou cli]
│
└──> D (décision humaine, bloquante) ──> E

F, indépendant
G1 ──> G2 ──> G3 ──> G4
H, après clia validate
```

**Trois points d'arrêt.**

Après A : le conflit actif est levé, et c'est le minimum de la mise en conformité.

Avant E : la décision D appartient à l'humain, et elle engage 248 renvois.

Avant H : `clia validate` doit exister.

**L'adaptation minimale est A, B et C.** Trois chantiers, un fichier de harnais, un module et une définition. Aucun outil nouveau, aucune instance touchée hors C4.

## Objections de l'agent

**Ce plan élargit ce que l'agent peut faire, et c'est l'agent qui le propose.** Le chantier A lève un interdit qui le vise. La lecture de `ANL-006` C3, qui fait porter la protection sur l'intention plutôt que sur la rédaction, est une interprétation de l'agent et elle lui profite. `NON-027` Q1 porte la question voisine pour les `PDC`.

**Le chantier E est peut-être impossible.** Il suppose une table de correspondance entre chaque décision d'ADR et sa `DCN`. Onze ADR sur dix-sept n'ont aucune `DCN`, et l'agent ne peut pas les créer. La correspondance devra donc être établie par l'humain, ou les renvois concernés resteront sans fondement.

**Le chantier D n'a pas de bonne option.** Les trois laissent le dépôt dans un état imparfait pendant un temps qu'aucune ne borne.

**`DCN-013` elle-même porte cinq champs `À RENSEIGNER`.** La décision qui fait autorité ne déclare pas son propre état, dont son `effet`. Le chantier C lui est applicable en premier.

**Ce plan est le troisième non exécuté.** `PLN-001` attend depuis le 2026-08-09. `PLN-002` est exécuté. `PLN-003` s'ajoute aux chantiers ouverts par `ANL-005` R2 et par `NON-025`.

## Relations

- `derive-de` [ANL-006](../analyses/ANL-006-mise-en-conformite-avec-dcn-013.md)
- `reference` [RES-009](../ressources/RES-009-decision.md)
- `reference` [RES-019](../ressources/RES-019-adr.md)
- `reference` [PLN-002](PLN-002-remediation-de-la-verbosite-justificative.md)
