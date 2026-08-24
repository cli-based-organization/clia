---
type: analyse
id: ANL-014
title: "Historique du développement de la notion d'intention"
status: draft
maturity: conception
adoption: propose
activated: true
date: 2026-08-20
sujet: "reconstitution, à travers $HOME/git/*, de la lignée de développement du concept d'intention repris par RES-003"
---

# ANL-014 - Historique du développement de la notion d'intention

> Six étapes, un embranchement isolé jamais réintégré, et trois dépôts nommés au nom du concept sans un seul commit. Le gabarit `INTENTION.md` que `clia` porte aujourd'hui est l'aboutissement direct d'une lignée unique, pas d'une convergence entre plusieurs pratiques concurrentes.

## Objet

Répondre à la tâche 17 de `SES-002` : parcourir les dépôts sous `$HOME/git/*` pour reconstituer l'historique de développement de la notion d'intention, dire quels dépôts l'utilisent, et quels documents en discutent — par opposition à ceux qui se contentent de l'employer.

## Méthode

191 dépôts git recensés sous `$HOME/git/`. Recherche par nom de fichier (`INTENTION.md`, `intention.md`) et par nom de dépôt, puis lecture ciblée : les quatre dépôts dont le nom porte le concept lui-même en priorité, un échantillon représentatif de la cinquantaine de fichiers `INTENTION.md` trouvés ailleurs (couvrant chaque période et chaque groupe de dépôts), et une recherche par contenu pour isoler les documents qui **discutent** le concept de ceux qui l'**emploient**. Les dates s'appuient sur le premier commit de chaque fichier (`git log --follow --reverse`).

## Constats

### La lignée, en six étapes

**1. 2026-03 à 2026-06-05 — naissance comme critère de priorisation.** `noumanity-ai-assisted-development-toolkit` (méta-repo « ticket-driven »). `skl-009-harness-file-intention` définit `INTENTION.md` comme référence d'importance (« what matters », dans la filiation des OKR) pour prioriser des issues. Le concept est encore ouvert : `ISU-008-definir-l-INTENTION-du-repo` pose la question sans la trancher.

**2. 2026-06-15 à 2026-06-19 — pic de complexité.** `cryptosecops`, `noumanity-communication`. `INTENTION.md` atteint 8 sections, façon plan d'affaires (opportunité, thèse why-now, modèle d'affaires, etc.). C'est le point le plus chargé de tout le corpus — jamais dépassé ensuite.

**3. 2026-06-21 — le document charnière.** `noumanity-dev/ticket-driven-ai`, ticket `TKT-001-definir-l-intention`. Consolide six expérimentations antérieures. Pose formellement « l'intention détermine ce qui doit être fait » comme principe fondateur, et ramène le gabarit à 5 sections (opportunité, intention profonde, modèle de travail, contenu, objectif).

**4. 2026-07-06/07 — identification et distinction locale/globale.** `noumanity-formation/intentional-doers-governance`, produit pour une présentation publique sur la gouvernance sociocratique-par-objection. Introduit la numérotation `INT-001` et distingue explicitement l'intention globale du dépôt des intentions locales de plan. Le gabarit se stabilise : court, identifié par séquence.

**5. 2026-07 à 2026-08 — diffusion sans reconception.** Une quarantaine de dépôts (`cryptosecops/*`, `noumanity-ops/*`, `noumanity-consultation/*`, `disruptiva-dev/*`, `cli-based-organization/clia-datacentric-architecture`, `clia-repos`, `linux-inspect`, entre autres) héritent du gabarit stabilisé à l'étape 4. Aucun ne le redéfinit ; c'est une pratique, plus une conception.

**6. 2026-08-09 à aujourd'hui — ressource fondamentale dans `clia`.** L'intention devient une des sept ressources fondamentales du système (`ADR-003`, `RES-003`, `skl-003`), avec critère de satisfaction et critère de trahison — un ajout que la lignée antérieure ne portait pas. La session `SES-002` (tâches 15 et 16, `PLN-017`) entreprend de corriger le défaut où `clia setup init` copiait l'intention de `clia` dans les nouveaux dépôts au lieu d'en générer une vierge, en visant à faire de `INTENTION.md` un symlink vers `.dev/intentions/INT-001.md` — reprise directe de la distinction globale/locale posée à l'étape 4.

### Un embranchement isolé, jamais réintégré

`disruptiva-dev/devops-cli`, skill `intention-writer` (2026-06-05, en anglais, contemporain de l'étape 1). Définit `INTENTION.md` façon produit : mission, problem, audience, goals, **non-goals**, success criteria. Structurellement distinct de la lignée française — jamais cité par `TKT-001`, jamais repris ensuite. Une branche parallèle qui s'arrête là où elle commence.

### Trois dépôts au nom du concept, sans contenu

`cli-based-organization/INTENTION`, `noumanity-dev/INTENTION`, `noumanity-formation/INTENTION` : trois dépôts créés, dont le nom seul porte le concept — aucun commit dans les trois. Une intention nommée trois fois, jamais réalisée. Je le rapporte comme fait, sans y voir davantage.

### Dépôts qui utilisent la notion, groupés

| Groupe | Dépôts | Nature |
|---|---|---|
| Dédiés au concept (noms réservés, vides) | `cli-based-organization/INTENTION`, `noumanity-dev/INTENTION`, `noumanity-formation/INTENTION` | Aucun contenu |
| Discutent réellement le concept | `noumanity-dev/ticket-driven-ai` (`TKT-001`), `noumanity-ai-assisted-development-toolkit` (`skl-009`), `disruptiva-dev/devops-cli` (`intention-writer`), `noumanity-formation/intentional-doers-governance` | Conception, en discussion ou en redéfinition |
| Emploient le gabarit stabilisé | ~45 dépôts (`cryptosecops/*`, `noumanity-ops/*`, `noumanity-consultation/*`, `disruptiva-dev/*` restants, `cli-based-organization/clia-datacentric-architecture`, `clia-repos`, `linux-inspect`, `horizon-ia/app-itinerance`, `ontpe/dossier-president`, `parti-horizon/fondation`, etc.) | Pratique, sans reconception |
| Ressource fondamentale actuelle | `cli-based-organization/clia` | `ADR-003`/`RES-003`/`skl-003`, critères de satisfaction/trahison |

### Documents qui discutent vraiment le concept

Par ordre de valeur ajoutée à la définition :

1. `noumanity-dev/ticket-driven-ai/.dev/tickets/TKT-001-definir-l-intention/{ticket.md, 01-analyse-experimentation.md}` — l'analyse comparative la plus riche, classe six variantes antérieures par maturité.
2. `noumanity-ai-assisted-development-toolkit/.../skills/skl-009-harness-file-intention/SKILL.md` — première définition fonctionnelle, comme référence de priorisation.
3. `disruptiva-dev/devops-cli/.skills/agents/intention-writer/SKILL.md` — définition alternative, façon produit, jamais convergée avec la lignée reprise par `clia`.
4. `noumanity-formation/intentional-doers-governance/INTENTION.md` — introduit `INT-001` et la distinction globale/locale, forme reprise telle quelle par `RES-003`.

## Réponse à la question posée

Le concept d'intention que porte `RES-003` n'est pas né dans `clia`. Il descend d'une lignée continue de six mois, amorcée dans les expérimentations « ticket-driven » de `noumanity-ai-assisted-development-toolkit`, consolidée par `TKT-001`, stabilisée et identifiée par `intentional-doers-governance`, puis diffusée sans reconception dans une quarantaine de dépôts avant d'arriver dans `clia` avec l'ajout propre à ce dépôt : les critères de satisfaction et de trahison, qui permettent l'objection. Une branche parallèle (`intention-writer`, façon produit anglophone) est restée isolée et n'a jamais influencé cette lignée.

## Limites

**L'échantillon, pas l'exhaustivité.** Sur la cinquantaine de fichiers `INTENTION.md` recensés, un échantillon représentatif a été lu en détail ; les autres ont été datés par leur premier commit sans lecture complète. Au-delà de l'étape 5, ils sont des copies du gabarit stabilisé — les lire tous n'aurait pas changé la chronologie.

**Les dates s'appuient sur le premier commit local**, pas sur une date de conception antérieure éventuelle (brouillon non versionné, discussion orale).

**Le statut du symlink `INTENTION.md` → `.dev/intentions/INT-001.md` dans `clia`** relève de l'exécution de `PLN-017` (tâches 15-16), pas de cette analyse — je rapporte l'intention de la correction, pas sa réalisation constatée à l'instant de cette lecture.

## Relations

- `reference` [RES-003](../ressources/RES-003-intention.md)
- `reference` [ADR-003](../adr/ADR-003-adoption-de-l-usage-de-clia.md)
- `reference` [PLN-017](../plans/PLN-017-harnais-generes-et-intention-par-ressource.md)
