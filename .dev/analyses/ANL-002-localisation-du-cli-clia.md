---
type: analyse
id: ANL-localisation-du-cli-clia
title: "Localisation du CLI clia : dépôt unique ou dépôt indépendant"
status: draft
date: 2026-08-09
sujet: "Où développer clia, au regard des faits du corpus et des propriétés des CLI orientés ressources"
generated:
  by: claude-opus-5
  at: 2026-08-09
---

# ANL-002 - Localisation du CLI clia : dépôt unique ou dépôt indépendant

> `clia` doit-il appartenir à ce dépôt ou être développé dans un dépôt indépendant ? Réponse : **rester ici pour l'instant**, avec une frontière interne stricte et un critère de bascule mesurable. La séparation est juste au moment de la diffusion, pas au moment de la conception.

## Objet

La tâche 5 de la session du 2026-08-09 pose une question de génie logiciel ordinaire, et la pose au bon moment : avant qu'un ADR n'engage l'usage de `clia`.

Cette analyse répond en confrontant deux corpus : les faits mesurés du corpus local par `ANL-001`, et les propriétés du modèle orienté ressources établies par `FND-001`.

## Ce que les deux sources apportent à la question

`FND-001` n'apporte rien directement, et le dit : aucune source consultée ne traite de la localisation d'un CLI par rapport au système qu'il outille. La recherche apporte en revanche deux contraintes indirectes.

Un CLI orienté ressources est **extensible par type** : ajouter un type ajoute une branche sans toucher aux autres. Cette propriété vaut quelle que soit la localisation du code, mais elle suppose que le CLI connaisse la liste des types, donc qu'il ait accès aux définitions.

Un CLI destiné à être consommé par un agent IA doit être **installé et disponible** dans le dépôt où l'agent travaille. C'est une contrainte de distribution, non de développement.

`ANL-001` apporte, lui, onze faits directement pertinents. Ils sont rassemblés ci-dessous parce que la décision se prend sur eux.

## Les faits du corpus

### Le corpus réinvente ses CLI, et n'en garde aucun

| CLI | Dépôt | Période | Sort |
|---|---|---|---|
| `nou` | `jvtrudel-adhoc/nou` | 2024-11, 9 jours | Abandonné. Premier CLI d'objets typés validés par schéma |
| `nou2` | `jvtrudel-adhoc/nou2` | 2024-12, 1 commit | Abandonné immédiatement |
| `devops` | `noumanity/devops-cli` | 2023-11 | Abandonné, jamais poussé |
| `devops` | `disruptiva-dev/devops-cli` | 2026-06 | Homonyme du précédent, l'ignorant, abandonné |
| `nty` | `disruptiva-dev/nty` | 2026-03, 12 jours | Abandonné. CLI ontologique avec validateurs |
| `cpm` | `datalyse/cli-photomanager` | 2025-04 | Abandonné |
| `shelp` | `jvtrudel-adhoc/shelp` | 2024-10 | Abandonné |
| `git-resource` | `archive/...git-resource` | 2026-06, 1 jour | Archivé |
| `nou-ia` | `...nou-scripts-ia-support` | 2026 | **Jamais commité**, 30 fichiers dont un CLI Go fonctionnel |
| `tda` | `noumanity-dev/ticket-driven-ai` | 2026-06 à 07 | Délaissé après cinq semaines, mais **il a fonctionné** |
| `clia` | `cli-based-organization/clia` | 2026-07 à 08 | En cours, sources archivées le 2026-08-08 |

Onze CLI en vingt-et-un mois. Un dépôt, `noumanity-dev/cli-convention`, a été créé pour établir une convention commune : il est vide et n'a jamais été commité.

### Le seul CLI qui a réellement équipé des dépôts était dans un dépôt à lui

`tda` vivait dans `noumanity-dev/ticket-driven-ai`, avec un remote, un `setup.sh` documenté à trois modes, et une commande `init` d'installation dans un dépôt tiers. Il a équipé au moins huit dépôts du corpus, identifiables par l'empreinte identique de leur `CLAUDE.md` : les quatre dépôts `cryptosecops`, `pdg-augmenté`, `noumanity-communication-stratégique`, `parti-horizon/fondation` et `cli-convention`.

C'est le seul précédent de diffusion réussie du corpus, et il valide la séparation **au moment de la diffusion**.

### Mais la séparation n'a protégé de rien

Ces huit dépôts portent un `README.md` qui renvoie à `github.com/noumanity-dev/ticket-driven-ai` comme méthode de référence. La méthode a été délaissée deux semaines après leur création. Rien ne les mettra à jour, et rien ne leur dira que la référence est morte.

La séparation du CLI n'a donc protégé ni la méthode, ni les dépôts équipés. Elle a seulement rendu la diffusion possible.

### Le dépôt actuel a perdu son installabilité

Le refactor `2373ec7` du 2026-08-08 a archivé `setup.sh` et les tests avec le reste. Au matin du 2026-08-09, le dépôt `clia` ne contenait aucun exécutable et aucun moyen d'être installé ni vérifié, alors que son `INTENTION.md` promet un cadre de collaboration entre humain, automatismes et agent IA.

C'est un fait décisif pour la question posée : l'urgence n'est pas de choisir un dépôt, elle est de restaurer un moyen d'installation. Et ce problème existe identiquement dans les deux options.

### La dispersion tue, dans ce corpus, de manière mesurée

Quatre-vingt-quatorze dépôts sur cent soixante-six n'ont aucun remote. Quarante-cinq n'ont jamais été commités. Soixante-et-un portent du travail non commité.

Le cas le plus net est `nou-scripts-ia-support` : un CLI Go complet, avec générateur d'ADR et intention machine-lisible, trente fichiers, zéro commit, aucun remote. Le travail existe sur un disque et nulle part ailleurs.

Trois paires de dépôts homonymes non résolues existent, dont deux CLI portant le même nom et la même intention. Trois remotes ne correspondent pas au nom du répertoire local.

Multiplier les dépôts, dans ce corpus, multiplie ces défauts.

### Le travail se fait par vagues, avec des creux de plusieurs mois

Trente-six pour cent des commits de 2026 entre 21h et 6h. Creux de sept à quatorze commits par mois de novembre 2025 à février 2026. Le coût de reprise domine toute autre considération.

Deux dépôts à reprendre après quatre mois coûtent plus que un.

### La méthode et l'outil changent aujourd'hui ensemble

C'est le fait le plus direct, et il est observable dans la session en cours plutôt que dans le corpus.

En quatre tâches, `RES-001` a été modifié deux fois, `skl-001-ressource` deux fois, `.dev/ressources/index.md` trois fois, chaque fois parce qu'une tâche ultérieure rendait faux ce qu'une tâche antérieure déclarait. Les contrôles de validation de `skl-001` sont, par construction, le cahier des charges d'une future commande `clia`. Le fichier d'état d'installation que `ADR-002` réclame est à la fois une décision de méthode et une structure de données du CLI.

Tant que ce couplage existe, séparer les dépôts transforme chaque mise en cohérence en deux commits dans deux dépôts, sans mécanisme pour garantir qu'ils sont faits ensemble.

### Le versionnage à deux domaines était déjà prévu

Le `resource-types.yaml` archivé et le `CLAUDE.md` archivé posaient un versionnage séparant deux domaines indépendants : le système d'augmentation, versionné par ressource dans le frontmatter, et le domaine métier, versionné dans un `version.yaml` à la racine et incrémenté par `clia release`.

Cette séparation logique existe donc déjà, sans séparation physique des dépôts. C'est un argument fort : la frontière est déjà pensée, il reste à la tenir.

## Les quatre options

| Option | Description |
|---|---|
| **A. Monolithe indifférencié** | Tout dans `clia`, sans frontière interne. Statu quo antérieur au refactor |
| **B. Deux dépôts** | Méthode et harnais ici, outil dans `cli-based-organization/<outil>` |
| **C. Trois dépôts** | Harnais installable, théorie de la méthode, outil |
| **D. Monolithe à frontière interne** | Un dépôt, zones séparées, versionnage et release distincts, extraction préparée |

## Évaluation

Sept critères, chacun rattaché à un fait ou à une contrainte établie.

| Critère | A | B | C | D |
|---|---|---|---|---|
| Coût de cohérence en phase de conception, méthode et outil changeant ensemble | Faible | **Élevé** | **Très élevé** | Faible |
| Installabilité chez un tiers | Nulle aujourd'hui | Bonne | Bonne | Bonne si `setup.sh` restauré |
| Risque de mortalité, mesuré par les 94 dépôts sans remote | Faible | Moyen | **Élevé** | Faible |
| Coût de reprise après un creux de plusieurs mois | Faible | Moyen | **Élevé** | Faible |
| Cycle de release propre à l'outil | **Impossible** | Bon | Bon | Acceptable |
| Conformité au précédent `tda`, seule diffusion réussie du corpus | Contraire | **Conforme** | Partiellement | Conforme en cible |
| Charge tenable pour une personne travaillant par vagues | Bonne | Moyenne | **Mauvaise** | Bonne |

Option A écartée : elle rend impossible tout cycle de release de l'outil et reproduit le mélange qui a mené au refactor drastique du 2026-08-08.

Option C écartée : trois dépôts pour une personne, dans un corpus où quatre-vingt-quatorze dépôts sur cent soixante-six sont déjà sans remote, est la configuration la plus exposée à la mortalité. Le gain de pureté ne compense rien.

Option B est la bonne réponse, mais pas maintenant. Elle est conforme au seul précédent de diffusion réussie et elle offre un cycle de release propre. Son coût est celui du couplage actuel : chaque décision de méthode touchant le CLI demanderait deux commits coordonnés dans deux dépôts, sans mécanisme pour garantir la coordination. Le corpus montre exactement ce que devient une coordination non outillée : trois `INTENTION.md` identiques désignant le mauvais client.

## Réponse à la question posée

**`clia` reste dans ce dépôt, et l'extraction est préparée plutôt que faite.**

Trois raisons, dans l'ordre de leur poids.

**La méthode et l'outil changent ensemble aujourd'hui.** Ce n'est pas une hypothèse : quatre tâches d'une seule journée ont produit trois mises en cohérence entre documents de méthode, et les contrôles de validation d'un skill sont déjà le cahier des charges d'une commande du CLI. Séparer un couple qui évolue ensemble crée une dette de synchronisation que rien, dans ce corpus, n'a jamais tenue.

**L'urgence est ailleurs.** Le dépôt n'a plus de `setup.sh` ni de tests depuis le 2026-08-08. Il n'est ni installable, ni vérifiable. Ce défaut est identique dans les quatre options, et il doit être corrigé avant toute question de localisation.

**Le précédent `tda` situe le bon moment.** `tda` a été extrait, non pas dès sa conception, mais quand la méthode était consolidée : une intention en cinq sections, un CLI complet, un `setup.sh` à trois modes, une commande `init`. C'est cet état qui a rendu la diffusion possible. `clia` n'y est pas : sept définitions en `draft`, deux ADR au statut `propose`, dix objections ouvertes dont quatre bloquantes, aucun exécutable.

## Ce que « préparer l'extraction » veut dire

Cinq mesures, toutes réalisables sans créer de dépôt.

**Une frontière interne déclarée.** Trois zones nommées et disjointes : le harnais, à la racine ; la méthode, dans `.dev/` ; l'outil, dans un emplacement dédié avec ses sources et ses tests. Aucun fichier de l'outil ne lit un fichier de la méthode autrement que par une interface déclarée.

**Le versionnage à deux domaines, tenu.** Il est déjà décidé dans les archives, il n'est pas appliqué. La version du système d'augmentation vit dans le frontmatter de chaque ressource, celle de l'outil vit dans son propre fichier.

**Le `setup.sh` restauré.** C'est la mesure la plus urgente, et elle est indépendante de la décision de localisation.

**L'interface entre l'outil et la méthode, explicitée.** Le CLI a besoin de connaître la liste des types de ressources. Aujourd'hui, cette liste vit dans `.dev/ressources/index.md`, document rédigé pour un lecteur humain. Une interface machine-lisible sera nécessaire, et c'est exactement le rôle que jouait le `resource-types.yaml` archivé. Le rétablir est la seule dépendance technique de l'extraction future.

**Aucun contenu de domaine dans l'outil.** Le principe est déjà écrit dans les archives sous le nom de généricité du harnais. Il doit valoir pour le CLI : rien de propre à ce dépôt dans son code.

## Le critère de bascule

L'extraction est déclenchée quand **l'une** des trois conditions est remplie. Le critère est écrit pour que la décision soit constatable et non discutée.

**Condition de diffusion.** Un deuxième dépôt consomme `clia` pour du travail réel, c'est-à-dire produit des ressources par son intermédiaire. C'est le moment où la copie manuelle cesse d'être tenable, et c'est le moment où `tda` avait été extrait.

**Condition de release.** Le CLI a besoin d'une version publiée, indépendante de l'état de la méthode. Une version publiée que l'on ne peut pas incrémenter sans toucher à sept définitions en `draft` n'est pas une version.

**Condition de découplage, mesurable.** Les commits cessent de toucher à la fois la zone méthode et la zone outil. La mesure est directe : sur les vingt derniers commits, compter ceux qui modifient les deux zones. Sous un seuil à fixer, de l'ordre de deux sur vingt, le couplage a disparu et la co-localisation ne se justifie plus.

La troisième condition est la plus intéressante des trois, parce qu'elle est objective et qu'elle mesure exactement ce que la présente analyse invoque comme raison de ne pas séparer maintenant. Si la raison disparaît, la décision se renverse d'elle-même.

## Objections que cette analyse soulève

**Le couplage invoqué est peut-être un artefact de la phase.** Quatre tâches d'une journée ne font pas une tendance. La condition de découplage est écrite pour que cette objection soit vérifiable dans quelques semaines plutôt que débattue maintenant.

**Rester dans un dépôt qui vient d'archiver son propre outillage est inconfortable.** Le dépôt a montré qu'il pouvait perdre son `setup.sh` sans que personne s'en aperçoive. Un dépôt dédié à l'outil aurait rendu cette perte visible. C'est l'argument le plus solide en faveur de l'option B, et il est de nature organisationnelle, non technique.

**La frontière interne est une promesse.** Rien ne la vérifiera, comme rien ne vérifie les autres règles du système. `NON-005` porte déjà ce défaut général ; il s'applique ici.

## Relations

- `derive-de` [ANL-001](ANL-001-observation-corpus-repos-et-pratiques/index.md)
- `derive-de` [FND-001](../fondations/FND-001-usage-des-cli-et-leur-renouveau.md)
- `specifie` [ADR-003](../adr/ADR-003-adoption-de-l-usage-de-clia.md)

## Lacunes

**Aucun coût chiffré.** L'analyse raisonne en ordres de grandeur et en précédents, pas en heures. Le coût réel d'une extraction dans ce dépôt n'a pas été estimé.

**Le seuil de la condition de découplage est proposé, pas fondé.** Deux commits sur vingt est un ordre de grandeur, non une mesure.

**Aucune consultation d'un cas comparable externe.** `FND-001` établit que la littérature sur les CLI ne traite pas cette question. Aucun projet tiers ayant fait ce choix n'a été examiné.
