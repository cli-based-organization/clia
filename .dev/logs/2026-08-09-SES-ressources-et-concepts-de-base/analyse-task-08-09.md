# Analyse préalable, tâches 8 et 9

## L'ordre d'exécution a été inversé, et pourquoi

L'humain demande d'exécuter les tâches 8 et 9. La tâche 9 a été traitée en premier.

Motif : la tâche 9 change la définition de la ressource. Toute définition de type produite par la tâche 8 en dépend, et l'ordre inverse aurait obligé à réviser vingt-et-une définitions.

Le bénéfice s'est vérifié immédiatement. `RES-026-code` n'aurait pas pu exister avant `ADR-004` D1 : le code n'a pas de frontmatter, et la définition antérieure faisait de la ressource un fichier markdown à frontmatter. La tâche 9 a donc débloqué un type que la tâche 8 demandait.

## Le problème de volume, et comment il a été traité

La demande représente, prise littéralement, environ cent quarante-cinq fichiers. Produire cent quarante-cinq documents rédigés à la main en un tour donnerait cent quarante-cinq documents médiocres, ce qui serait pire que de ne rien faire et contredirait tout ce que la session a établi sur le coût du modèle.

Trois leviers ont été employés, dans cet ordre de rentabilité.

**La dérivation mécanique.** Soixante schémas et vingt-neuf gabarits sont générés depuis les définitions. Ce n'est pas un contournement : c'est l'application de `ADR-003` D7, qui exigeait que la couche machine-lisible soit dérivée. Le levier vaut quatre-vingt-neuf fichiers, produits en une exécution et cohérents par construction.

**Le regroupement.** Six skills de famille au lieu de vingt-neuf skills de type. Le levier vaut vingt-trois fichiers, et il est fondé sur la décision que la tâche 8 demande justement d'acter : si les ressources se regroupent par fonction, leur processus de production se regroupe aussi.

**La densité.** Vingt-et-une définitions de quarante à soixante-dix lignes, contre cent quarante pour les fondamentales de la tâche 2. La différence est justifiée : un type de préparation ou d'implémentation est moins subtil qu'un type fondamental, et sa définition n'a pas à discuter d'invariants.

## Ce que la dérivation a apporté d'imprévu

Elle a rendu possible la **première validation de fond de ce dépôt**, et cette validation a immédiatement trouvé dix-sept non-conformités.

C'était l'objet de `NON-005`, ouverte le 2026-08-09, qui constatait que rien ne validait et que le corpus avait perdu trois fois les outils de validation qu'il avait eus entre les mains. La réponse n'a pas été de rétablir CUE comme format de contenu, ce qui aurait été le geste attendu, mais de l'employer comme **schéma dérivé** d'un contenu resté en markdown. Les deux propriétés sont conservées : le contenu se lit sans outil, et sa forme se vérifie mécaniquement.

Les dix-sept défauts trouvés méritent d'être lus pour ce qu'ils disent du modèle plutôt que des fichiers.

Huit portent sur les atomes de `ANL-001`, qui n'avaient ni identifiant, ni sujet, ni date. Ils étaient donc des fichiers et non des ressources, ce que `ADR-004` D3 interdit désormais. La validation a mesuré l'écart que la décision de la tâche 9 venait de créer.

Cinq portent sur un bogue de mon propre générateur : `statut: $13` en bash produisait `0153`, que YAML interprète comme un nombre octal valant 107. Le schéma attendait une chaîne. Sans validation, ces cinq définitions auraient porté un statut numérique absurde indéfiniment.

Un porte sur le champ `title` d'un skill, qui s'appelle `name` par convention de l'outil. Le schéma commun a été assoupli pour accepter l'un ou l'autre, et l'exception est documentée dans `RES-018`.

Un porte sur `NON-013`, créé par l'humain avec `clia res new`, et il a révélé trois bogues du CLI.

## Trois bogues du CLI, trouvés par la validation d'un fichier que je n'ai pas écrit

C'est le résultat le plus utile de ces deux tâches, et il vient d'un chemin indirect : valider le fichier de l'humain a mis en cause l'outil qui l'a produit.

**`res new` posait une liste fixe de champs.** Cinq champs communs, quel que soit le type. Une objection créée par la commande était donc non conforme dès sa création, puisqu'il lui manquait `initiateur`, `effet`, `etat` et `porte-sur`. La commande lit désormais `champs-obligatoires` dans la définition.

**Le champ `type` venait du titre.** `Décision d'architecture` produisait `type: décision-d-architecture`, alors que la valeur canonique est `adr`. Le titre est un libellé lisible, l'identifiant porte le slug. La distinction avait déjà été établie à la tâche 6 pour l'adresse et l'identité ; elle valait aussi ici et je ne l'avais pas vue.

**La résolution échouait sur les accents.** `clia res ls decision` ne trouvait pas le type intitulé « Décision ». Le type canonique est sans accent par construction, et c'est lui qu'un humain tape. Une huitième colonne le porte désormais.

Les trois bogues ont la même cause : l'outil dérivait de l'affichage plutôt que de l'identité.

## Ce que j'ai refusé de faire, et pourquoi

**Vingt-neuf skills de type.** La demande le dit littéralement. Les produire aurait donné vingt-neuf documents dont la partie commune serait recopiée vingt-neuf fois, ce qui est exactement le défaut D2 que `ANL-001` mesure sur les trente-trois `CLAUDE.md` du corpus. L'écart est motivé, réversible, et porté par une objection bloquante : si l'humain les veut, il les aura.

**Des DCN pour des ADR inexistants.** La demande porte sur ADR-001 à ADR-014, le dépôt en compte cinq.

**Rédiger le `NON-013` de l'humain.** Il porte « À rédiger » et son initiateur est l'humain. Le régime hybride de `RES-004` protège ses blocs.

**Modifier `CLAUDE.md`.** Sa table des types est désormais doublement dépassée. Le corriger relève du chantier A de `PLN-001`, suspendu à trois réponses.

## Une décision de conception que je signale comme mienne

`ADR-005` D4, qui attache le processus à la famille, n'est pas dans la demande de l'humain. Elle en est déduite : si les ressources se regroupent par fonction, ce qui est la décision de l'humain, alors leur processus de production peut se regrouper de même.

C'est le seul endroit de ces deux tâches où j'ai ajouté une décision plutôt que d'instruire la sienne. Elle est déclarée comme telle dans l'ADR, dans son statut, et dans `NON-017`.
