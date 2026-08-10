# Analyse préalable, tâche 3

## La difficulté principale : ne pas dupliquer

`RES-001` existe déjà et dit ce qu'est une ressource. Le risque de la tâche 3 était d'écrire deux documents qui répètent la définition en changeant le ton.

`ADR-008` du dépôt `micrologic-clients` documente précisément ce dégât : dans ce dépôt, six ADR sur sept servaient de définition, et deux ont dû être amendés en place le jour de leur création parce qu'une décision est datée et close alors qu'une définition est vivante.

Le critère de départage de `RES-001` a donc été appliqué avant d'écrire, et non après. Un passage qui cesserait d'être vrai en changeant d'avis appartient à la décision. Un passage qui décrit une suite d'actions appartient au processus. Un passage qui décrit une propriété du type appartient à la définition.

Conséquence concrète sur la répartition : `RES-001` porte les trois classes de cycle de vie et les quatre régimes d'édition ; `ADR-001` porte le motif de ces choix et les alternatives écartées ; `skl-001` porte l'ordre dans lequel on les décide en produisant un type.

## Ce que l'ADR devait apporter, et que la définition ne peut pas porter

Trois choses, dont la troisième est celle qui manque le plus au corpus.

Les **alternatives écartées**. Base de données, YAML pur, schéma exécutable pour la forme. Identité par chemin pour l'identité. Régime uniforme pour le cycle de vie. Deux régimes d'édition au lieu de quatre. Triplet simultané au lieu de progressif.

Les **motifs mesurés**. Chaque décision renvoie à un fait de `ANL-001` et non à une préférence. D3 sur l'identité s'appuie sur les douze numéros de skill portant plusieurs noms ; D9 sur la validation s'appuie sur le `CONSTITUTION.md` de zéro octet et les trois `INTENTION.md` identiques.

Les **portes de sortie**. À quelles conditions chaque décision serait révisée. C'est ce que `ANL-001` établit comme le défaut D3 : le corpus compte quatre-vingt-neuf ADR et aucun sur ses quatre ruptures de cap réelles, si bien qu'un lecteur ne peut reconstituer ni pourquoi `tda` a été abandonné pour `clia`, ni pourquoi la validation par schéma a été perdue trois fois. `ADR-001` D9 est d'ailleurs la première trace écrite de cet abandon, et elle le déclare temporaire.

## Pourquoi le statut de décision est `propose` et non `accepte`

Trois objections bloquantes sont ouvertes et portent directement sur D3, D6 et D9. Déclarer la décision acceptée avant leur réponse aggraverait exactement le défaut que l'ADR entend corriger : produire des ADR qui décrivent un état souhaité plutôt qu'un état décidé.

Le champ `statut-decision` vaut donc `propose`, distinct du champ `status` du frontmatter qui vaut `draft` et qui porte sur la maturité du document.

## Ce que le skill devait apporter

La demande porte sur les directives d'écriture **et de validation**. La partie validation est la plus utile et la plus délicate, parce que `ANL-001` établit au défaut D2 qu'aucune validation n'existe et que le corpus a perdu trois fois les outils qui en donnaient une.

Deux choix ont été faits.

**Les contrôles sont des commandes, pas des recommandations.** Neuf contrôles exécutables sans outil, tous testés sur les livrables réels des tâches 2 et 3. Ils constituent le cahier des charges de la future validation par `clia`, ce que `ADR-001` D9 déclare explicitement.

**Chaque contrôle nomme le dégât qu'il prévient.** V1 le `CONSTITUTION.md` de zéro octet. V8 les `INTENTION.md` restés aux crochets du gabarit. V9 les trois `INTENTION.md` identiques désignant le mauvais client et les dix-huit logs recopiés. Un contrôle sans motif ne survit pas à la première fois où il dérange.

## Le skill a révélé un défaut dans ses propres contrôles

Les contrôles V4 et V5 de la première version signalaient le skill lui-même comme non conforme : ils trouvaient les tirets cadratins dans leurs propres commandes et les filets du gabarit de la partie B.

Le défaut était réel, non un artefact. Un contrôle textuel qui ne distingue pas une mention d'un emploi est inutilisable sur un document de méthode, c'est-à-dire précisément sur le type de document que ce système produit le plus.

Les trois contrôles textuels excluent désormais le frontmatter, les blocs de code et le code inline, et la règle d'exclusion est énoncée en tête de la section de validation avec l'incident qui l'a fondée. C'est le seul test d'auto-application disponible en l'absence d'outil, et il a servi.

## Ce qui a été refusé

Un fichier de script exécutable. La tâche demande un document de directives ; produire un script relèverait de la session d'outillage annoncée.

La modification de `CLAUDE.md`, dont la table des types duplique l'index et dont la désignation par triplet de numéros est invalidée par `ADR-001` D3. C'est un fichier de harnais, la tâche ne le demande pas, et l'écart est signalé dans l'index, dans `NON-001` et dans `NON-002` Q6.

L'écriture des six autres ADR et skills, que `ADR-001` D6 déclare justement inutile de produire d'avance.
