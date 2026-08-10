# Analyse préalable, tâche 2

## Ce que l'observation impose au jet

`ANL-001` a établi que le meilleur travail conceptuel du corpus est `RES-001-ressource.md` de `micrologic-clients`, et que le rédiger à neuf serait un gâchis. Le jet part donc de cet état de l'art et s'en écarte là où une mesure l'exige.

Trois mesures ont directement modifié la conception.

**D1, la collision de numérotation.** Douze numéros de skill sur vingt portent plusieurs noms selon le dépôt. `RES-001` de `micrologic-clients` écarte l'invariant d'identité stable au motif que le volume du dépôt le permet. Ce calcul ne tient pas pour un système multi-dépôts. Le jet retient donc l'identité stable, par un champ `id` de la forme `<PREFIXE>-<SLUG>`, ce qui coûte un champ et rend renumérotation et déplacement inoffensifs.

**D4, le coût de l'auto-description.** Sept types font vingt-et-un documents avec le triplet complet, vingt-sept en font quatre-vingt-un. Le jet ne produit que les définitions, et introduit un seuil d'admission à trois conditions pour le type le plus susceptible de proliférer, le concept.

**D9 et le régime d'objection.** Le `CLAUDE.md` archivé interdit toute exécution tant qu'une objection reste ouverte, règle qui rend le travail impossible dès la première objection sérieuse et que le même document compensait par un mécanisme de breakpoint. Le jet remplace cela par un champ `effet` à trois valeurs, déclaré à l'ouverture.

## Deux apports de conception qui ne viennent pas du corpus

**Les deux critères de l'intention.** `CLAUDE.md` charge l'agent d'objecter en cas de conflit avec l'intention ultime, et aucun `INTENTION.md` du corpus ne permet d'instruire un tel conflit : ce sont des affirmations, non des critères. `RES-003` rend obligatoires un critère de satisfaction, qui permet de clore, et un critère de trahison, qui permet d'objecter. C'est la condition pour que la fonction assignée par le harnais soit remplie.

**Le recueil de faits.** Le type `FCT` n'a aucune instance dans le corpus malgré une base théorique sérieuse, et l'obstacle probable est la granularité : un fichier par fait est ingérable. `RES-005` fait du recueil par sujet l'unité de fichier et du fait atomique l'unité de sens, avec une adresse par ancre.

## Ce que l'objection doit être, d'après la demande

La formulation de la tâche est instructive : « produire un fichier NON-xyz par thématique et contenant plusieurs questions sur un même sujet ». Une objection n'est donc pas un refus, c'est un faisceau de questions thématique. Cette propriété a été inscrite dans `RES-004` comme définitionnelle, et non comme une convention de rédaction, parce qu'elle a trois conséquences utiles : l'objection devient traitable par morceaux, elle désigne un thème plutôt qu'un incident, et elle établit qu'une décision est en attente sans prétendre avoir raison.

Le jet applique ensuite à ses propres objections la structure que `RES-004` définit, ce qui est le seul test d'auto-application disponible en l'absence de skill.

## Choix des huit thématiques

Les thématiques ne sont pas déduites des sept types mais des points où le jet prend une décision non arbitrée ou laisse un manque.

| Objection | Origine |
|---|---|
| `NON-001` identité et nommage | L'écart avec l'état de l'art, et le double préfixe `NON` contre `OBJ` |
| `NON-002` coût du modèle | D4, et la duplication de la table des types entre `CLAUDE.md` et l'index |
| `NON-003` frontière contexte, intention, faits | Les trois types latents, définis sans aucune instance pour les éprouver |
| `NON-004` frontière du savoir | La contradiction interne du jet : des relations employées et non définies |
| `NON-005` validation et règles non tenues | Le jet ajoute cinq règles non vérifiables aux règles existantes |
| `NON-006` portée du système | Le modèle est mono-dépôt et textuel, la pratique ne l'est pas |
| `NON-007` faits, preuve et confidentialité | Le type `FCT` crée une responsabilité que rien n'encadre |
| `NON-008` régime de travail | Ce que les sept définitions présupposent et laissent hors champ |

## Ce qui a été refusé

Un index dans `.dev/objections/` n'a pas été produit : l'index des ressources porte déjà la table des huit objections, et en ajouter un second serait exactement le coût que `NON-002` conteste.

Les répertoires `.dev/contextes/`, `.dev/intentions/`, `.dev/faits/`, `.dev/concepts/` et `.dev/ontologies/` n'ont pas été créés. `ANL-001` mesure le coût des arborescences vides peuplées de `.gitkeep`, avec neuf occurrences dans un seul dépôt du corpus.

`CLAUDE.md` n'a pas été touché, bien que sa table des types et son mode de désignation par numéro soient contestés. C'est un fichier de harnais, la tâche ne le demande pas, et l'écart est signalé dans l'index et dans `NON-001` et `NON-002`.
