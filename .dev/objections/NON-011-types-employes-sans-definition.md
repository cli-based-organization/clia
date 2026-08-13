---
type: objection
id: NON-011
title: "Types employés sans définition, et nommage non conforme"
status: draft
maturity: conception
adoption: propose
activated: true
domain-status: "repondue"
initiateur: agent
effet: conditionnel
etat: repondue
porte-sur: [RES-001, ADR-001, ADR-003]
---

# NON-011 - Types employés sans définition, et nommage non conforme

> Ce dépôt emploie neuf types de ressources et n'en a défini que deux. Les sept autres, dont l'ADR, le plan, la fondation et l'analyse, sont produits par imitation du corpus. Deux d'entre eux sont de surcroît nommés en contradiction avec ce que `RES-001` déclare.

## Journal

- 2026-08-09 : ouverte par l'agent, après que la validation de la tâche 4 a révélé que le contrôle V3 est inapplicable à trois de ses quatre livrables, et que la tâche 5 a produit deux types non définis supplémentaires.
- 2026-08-11 : **objet partiellement dépassé**, noté au ménage de la tâche 30. Trente-six types sont définis, contre sept à l'ouverture de l'objection. `ADR-016` D5 a clos la contestation sur leur nombre, et `ADR-016` D4 pose qu'un type se crée sous le besoin. L'objection n'est pas levée : la question du nommage des types point fixe est réglée par `ADR-007` D4, celle des types employés sans définition subsiste pour les types annoncés par `CLAUDE.md` et non définis.
- 2026-08-13 : passe a `repondue` par `PLN-010`, chantier B. Critere mecanique : chaque question porte une reponse. Aucune reponse n'a ete interpretee.

## Ce qui est contesté

### Neuf types employés, deux définis

| Type | Instances dans ce dépôt | Définition |
|---|---|---|
| `ressource` | 8 | `RES-001` |
| `objection` | 11 | `RES-004` |
| `adr` | 3 | **aucune** |
| `analyse` | 2 | **aucune** |
| `fondation` | 1 | **aucune** |
| `plan` | 1 | **aucune** |
| `skill` | 1 | **aucune** |
| `log` | 28 fichiers de journal | **aucune** |
| `session` | 1 | **aucune** |

Les sept types sans définition sont produits par imitation du corpus : préfixe, emplacement et structure viennent de ce que d'autres dépôts ont fait, sans qu'aucune règle de ce dépôt ne les fixe.

### Le contrôle de conformité en devient inapplicable

Le contrôle V3 de `skl-001-ressource` vérifie que les champs déclarés obligatoires par un type sont présents dans ses instances. Il suppose qu'une définition les déclare.

Sur les quatre livrables de la tâche 4, trois appartenaient à des types non définis. Sur les trois de la tâche 5, les trois. Le seul contrôle de fond du système est donc inapplicable à la majorité de ce que ce dépôt produit.

### Deux instances violent la règle de nommage de RES-001

`RES-001` déclare que les types au cycle de vie `point-fixe`, dont les analyses et les fondations, se nomment par date, sous la forme `<PREFIXE>-<DATE>-<SLUG>`.

`FND-001-usage-des-cli-et-leur-renouveau.md` et `ANL-002-localisation-du-cli-clia.md`, produits le 2026-08-09, sont nommés par séquence. `ANL-001` l'est également, mais son nom a été imposé par la demande de la tâche 1.

Le choix a été fait sciemment, pour ne pas faire cohabiter deux conventions de nommage dans le même répertoire, et il est non conforme. Il est déclaré ici plutôt que dissimulé.

## Pourquoi cela ne peut pas rester implicite

Trois raisons, de poids croissant.

**Un type non défini fait précédent.** La règle A5 de `skl-001-ressource` dit d'ouvrir une objection plutôt que de produire une instance non conforme, précisément parce que la première instance devient le modèle des suivantes. Trois ADR ont désormais été produits sur ce mode : la structure du troisième imite celle du premier, qui imitait `ADR-008` d'un autre dépôt.

**`clia` ne pourra pas lire ce qui n'est pas déclaré.** `ADR-003` D7 pose qu'une source machine-lisible des types est nécessaire, et qu'elle doit être dérivée des définitions plutôt qu'écrite à la main. Un type sans définition n'y figurera pas, donc `clia` ne pourra ni le lister, ni le valider, ni le créer.

**La contradiction de nommage porte sur l'identité.** `ADR-001` D3 pose que l'identité est le champ `id`, dérivé du slug. Si la convention de nommage varie, le contrôle V7, qui vérifie la cohérence entre l'`id` et le nom de fichier, ne sait plus ce qu'il doit attendre.

## Questions

### Q1 - Que fait-on des sept types employés sans définition ?

Trois positions. Les définir à neuf, sept définitions de plus, ce que `NON-002` conteste par avance au titre du coût. Les **rapatrier** depuis `micrologic-clients`, qui en définit six sur sept, éprouvées et de bonne qualité. Ou tolérer explicitement l'emploi de types non définis, en déclarant lesquels et jusqu'à quand.

**Réponse.**

### Q2 - Les analyses et les fondations sont-elles nommées par date ou par séquence ?

**Réponse, du 2026-08-10, par l'humain.** Par séquence, et pour tous les types sans exception. `ADR-007` D4 abolit le nommage daté et retire au cycle de vie le pouvoir de commander le nommage : il ne commande plus que le versionnage.

La troisième position que cette question envisageait, reconnaître que ces types ne sont pas des points fixes, n'est pas retenue : ils le restent quant au versionnage.

`RES-001` dit par date, l'usage de ce dépôt dit par séquence, avec trois instances. Il faut soit corriger `RES-001`, soit renommer les trois fichiers, soit reconnaître que le cycle de vie de ces types n'est pas `point-fixe`.

La troisième hypothèse mérite examen : `ANL-001` a été relu et corrigé après sa production, et son bundle porte huit fichiers dont plusieurs seront révisés. Un document qu'on révise n'est pas un point fixe.

**Réponse.**

### Q3 - Est-il acceptable que le seul contrôle de fond soit inapplicable à la majorité des livrables ?

Le contrôle V3 est le seul qui porte sur le contenu du frontmatter et non sur la forme du texte. Tant que sept types sur neuf n'ont pas de définition, la validation du système est réduite à des contrôles typographiques.

**Réponse.**

### Q4 - Peut-on employer un type avant de l'avoir défini, et à quelle condition ?

La pratique de cette session répond oui, quatre fois. Une règle explicite vaudrait mieux qu'une tolérance de fait. Candidat : un type peut être employé une première fois sans définition, à condition que l'instance déclare son type dans son frontmatter et qu'une objection soit ouverte ; sa définition devient exigible à la deuxième instance.

**Réponse.**

### Q5 - Un skill est-il une ressource ?

`RES-001` classe le skill parmi les types au cycle `vivant`, mais un skill vit dans `.dev/skills/skl-<SEQ>-<nom>/SKILL.md`, ce qui est une convention imposée par l'outil et non par ce dépôt. Le contrôle V7 doit d'ailleurs prévoir une exception pour lui. Une ressource dont l'emplacement échappe à la règle générale est-elle une ressource, ou un objet de harnais ?

**Réponse.**

### Q6 - Le log et la session sont-ils des ressources ou des traces ?

Le `resource-types.yaml` archivé les classait comme traces immuables, catégorie distincte des ressources livrables, non versionnées et sans skill de production. `RES-001` ne reprend pas cette catégorie : il ne connaît que trois cycles de vie, tous appliqués à des ressources.

Vingt-huit fichiers de journal existent dans ce dépôt sans qu'aucune règle ne dise ce qu'ils sont. La question du statut de la session est par ailleurs déjà portée par `NON-009` Q1.

**Réponse.**

### Q7 - Comment un type non défini figure-t-il dans la source machine-lisible que `clia` doit lire ?

`ADR-003` D7 pose que cette source est dérivée des définitions. Un type sans définition en est donc absent, et `clia` l'ignorera. Faut-il que `clia` refuse de travailler sur un type inconnu, qu'il le signale, ou qu'il le tolère avec un avertissement ?

**Réponse.**

## Ce qui lèverait cette objection

Une réponse à Q1 et Q2.

Q1 fixe la trajectoire : rapatrier six définitions depuis `micrologic-clients` est de loin le geste le moins coûteux, et `ANL-001` recommande déjà ce rapatriement au titre du risque de perte, ce dépôt étant sans remote avec treize fichiers non commités.

Q2 est une correction matérielle qui ne demande aucune théorie, et elle porte sur trois fichiers.

L'effet est `conditionnel` : les instances produites restent utilisables, et elles sont réputées provisoires quant à leur nom et à leur conformité de frontmatter.

## Relations

- `objecte-a` [RES-001](../ressources/RES-001-ressource.md)
- `objecte-a` [ADR-001](../adr/ADR-001-adoption-de-la-notion-de-ressource.md)
- `objecte-a` [ADR-003](../adr/ADR-003-adoption-de-l-usage-de-clia.md)
- `reference` [NON-002](NON-002-cout-du-modele.md)
- `reference` [NON-009](NON-009-statut-de-la-session-et-convergence.md)
