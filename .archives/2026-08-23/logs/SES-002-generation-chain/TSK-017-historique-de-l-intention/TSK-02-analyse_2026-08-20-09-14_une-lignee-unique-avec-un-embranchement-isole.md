# Analyse, tâche 17 de SES-002

`MET-003` étape 2.

## Ce que l'exploration établit

191 dépôts git sous `$HOME/git/`. La notion d'intention y apparaît sous deux formes distinctes, et une seule des deux converge vers ce que `clia` porte aujourd'hui.

**Une lignée unique, six étapes.**

1. **2026-03 à 06-05** — `noumanity-ai-assisted-development-toolkit` (méta-repo « ticket-driven »). `INTENTION.md` naît comme référence de priorisation (« what matters »), documentée dans `skl-009-harness-file-intention`. Le concept est encore en discussion — `ISU-008-definir-l-INTENTION-du-repo` pose la question sans la trancher.
2. **2026-06-15 à 06-19** — `cryptosecops`, `noumanity-communication`. `INTENTION.md` gonfle à 8 sections, façon business plan (opportunité, thèse why-now, modèle d'affaires...). C'est le pic de complexité de tout le corpus.
3. **2026-06-21** — `noumanity-dev/ticket-driven-ai`, ticket `TKT-001-definir-l-intention`. **Le document charnière.** Consolide six expérimentations antérieures, pose « l'intention détermine ce qui doit être fait » comme principe, ramène le gabarit à 5 sections.
4. **2026-07-06/07** — `noumanity-formation/intentional-doers-governance`. Apparition de l'identifiant `INT-001` et de la distinction intention globale du dépôt / intentions locales de plan. Le gabarit se stabilise, court, identifié.
5. **2026-07 à 08** — ~45 dépôts (`cryptosecops/*`, `noumanity-ops/*`, `noumanity-consultation/*`, `disruptiva-dev/*`, etc.) héritent du gabarit stabilisé sans le rediscuter. Simple pratique, plus de conception.
6. **2026-08-09 à aujourd'hui** — `clia`. L'intention devient une des sept ressources fondamentales (`ADR-003`/`RES-003`/`skl-003`). La tâche 15 de cette session corrige le défaut où `clia setup init` copiait l'intention de `clia` dans les nouveaux dépôts, en faisant de `INTENTION.md` un symlink vers `.dev/intentions/INT-001.md` — directement héritier de la distinction posée à l'étape 4.

**Un embranchement isolé, jamais réintégré.** `disruptiva-dev/devops-cli`, skill `intention-writer` (2026-06-05, en anglais) définit `INTENTION.md` façon produit : mission, problem, audience, goals, **non-goals**, success criteria. Structurellement différent de la lignée française, il n'a jamais convergé avec elle — ni influencé `TKT-001`, ni cité ensuite.

**Trois dépôts au nom du concept, vides.** `cli-based-organization/INTENTION`, `noumanity-dev/INTENTION`, `noumanity-formation/INTENTION` : des noms de dépôt réservés, sans commit. Une intention nommée trois fois, jamais réalisée — je le note tel quel, sans y voir plus qu'un fait à rapporter.

## Ce qui a été écarté

**L'exhaustivité des ~50 fichiers `INTENTION.md`.** Le fork en a examiné un échantillon représentatif couvrant chaque période et chaque groupe de dépôts (`cryptosecops`, `noumanity-dev`, `noumanity-ops`, `disruptiva-dev`, `noumanity-consultation`, `cli-based-organization`). Au-delà de l'étape 4, les fichiers sont des copies du même gabarit stabilisé : les lire tous n'aurait rien changé à la chronologie, seulement confirmé le palier. Lecture raisonnable au regard de la demande, qui porte sur l'historique du concept, non sur un audit de conformité.

## Ce qui est décidé en avançant

**La structure du livrable suit les six étapes ci-dessus**, plus une section sur l'embranchement isolé et une sur les dépôts-noms vides — c'est ce que `MET-005` étape 2 range du côté « décider et avancer », aucune ambiguïté à soumettre à l'humain.
