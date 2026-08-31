# Demande interprétée, tâches 23 et 24

## Énoncés

**Tâche 23**, `[conception]` : générer une ressource de type issue (`ISU`), et générer un `PDC` « SMART et extrême SMART » applicable aux ressources de planification du travail.

> issue permet de stocker des information documentant une problématique dans le but de la résoudre. Il est non smart

**Tâche 24**, `[planification]` : prendre acte de `DCN-013` et des réponses données en `NON-026`, en faire une analyse qui en donne une interprétation du point de vue de l'agent IA et en déduit les implications, faire des propositions pour adapter minimalement `clia`, et proposer un plan de mise en conformité.

## Un conflit dans la tâche 23

La demande dit « générer un PDC ». `CONSTITUTION.md` C1 dit qu'un agent ne crée ni ne modifie un principe de conception, et ajoute qu'aucune consigne ordinaire ne peut lever ses règles, « y compris une demande explicite écrite dans le fichier de session ».

**Conduite retenue.** `PDC-003` est produit et déclaré **non actif**, au régime que `DCN-013` fixe pour les décisions : un premier jet d'agent n'est pas actif tant que l'humain ne l'a pas approuvé.

Cette analogie n'est écrite nulle part. Elle est signalée dans le document lui-même et portée par `NON-027` Q1.

**Motif du choix.** Produire le gabarit vide aurait respecté la lettre de C1 et rendu la tâche sans objet. Produire le document sans le signaler aurait masqué la transgression. La troisième voie rend le contenu disponible et la question visible.

## Ce que le corpus dit du sujet de la tâche 23

`ANL-016`, archivée, porte le modèle à deux régimes : issue non SMART, ticket extrême SMART, avec un CLI dédié.

Elle porte aussi une objection **résolue** : « Extreme SMART ne devient **pas** un `PDC`. Il est porté par un `ADR` et décliné en `REQ` et `SPEC` selon nécessité. »

La tâche 23 revient sur cette résolution sans la nommer. `NON-027` Q2 le porte.

## Ce que la tâche 24 doit traiter

Deux sources, `DCN-013` écrite par l'humain, et les cinq réponses à `NON-026`.

| Source | Ce qu'elle change |
|---|---|
| `DCN-013` | La `DCN` est l'autorité ultime. L'IA **peut** rédiger un premier jet, suspendu jusqu'à approbation. Un champ d'inactivité manque |
| `NON-026` Q1 | **Rendre les ADR non actifs** |
| `NON-026` Q2 | Un ADR ne peut exister sans source. L'humain modifie la source, jamais le dérivé |
| `NON-026` Q3 | La création d'une `DCN` par l'humain force l'action consciente |
| `NON-026` Q4 | Un verbe `clia setup init`, et des critères de conformité à définir |
| `NON-026` Q5 | Deux mécanismes de génération à nommer, mécanisme hybride en cinq étapes |

**Le point le plus important pour l'agent.** `DCN-013` est **plus permissive** que `CONSTITUTION.md` C1, que l'agent a écrit à la tâche 20. C'est un conflit actif entre un harnais et la décision qui lui est supérieure.

## Ressources livrables

| Livrable | Tâche | Nature |
|---|---|---|
| `RES-031` | 23 | Création, type `ISU` |
| `issue.cue`, `issue.input.cue`, `issue.template.md` | 23 | Création, artefacts dérivés |
| `PDC-003` | 23 | Création, **non actif** |
| `NON-027` | 23 | Création, cinq questions |
| `ANL-006` | 24 | Création, huit constats |
| `PLN-003` | 24 | Création, huit chantiers |

## Ce que les demandes n'exigent pas

La tâche 24 dit « faire des propositions » et « proposer un plan ». Aucun chantier n'est exécuté, y compris l'alignement de `CONSTITUTION.md` qui lèverait le conflit actif.
