# Analyse préalable, tâche 5

## La chaîne demandée impose une discipline

La tâche enchaîne trois livrables dans un ordre qui n'est pas indifférent : recherche, puis analyse, puis décision. Chacun ne peut employer que ce que le précédent a établi.

La conséquence pratique est que la recherche ne devait pas anticiper la réponse. `FND-001` sépare donc explicitement ses sections 1 à 6, qui sont de la recherche, de sa section 7, qui est de l'interprétation en vue de `clia`, et déclare cette séparation en tête de section.

## Ce que la recherche a réellement apporté, et qui n'était pas prévu

Trois apports n'étaient pas dans mon hypothèse de départ.

**Le renversement de grammaire.** Un CLI orienté ressources n'est pas une liste de commandes mais un produit cartésien de ressources et de verbes. Un nouveau type hérite des verbes existants sans que l'outil change. C'est exactement l'invariant d'extensibilité que `RES-001` retient, et il se trouve que la littérature de conception d'API l'a formalisé indépendamment.

**La frontière plus haute.** Dans les CLI d'infrastructure, créer une ressource est mécanique. Ici, créer une ressource est un travail de rédaction. La frontière entre ce que l'outil fait et ce que l'agent fait passe donc plus haut que dans les outils dont le modèle est emprunté. Ce point est devenu `ADR-003` D3 et D5, et je ne l'avais pas formulé avant la recherche.

**Le déterminisme comme partage de responsabilité.** La recherche établit que donner à un agent un outil déterministe permet de retirer à l'agent la charge de garantir ce que l'outil garantit. `ADR-002` D1 avait posé ce partage comme une intuition locale ; la recherche montre que c'est la pratique qui s'impose. L'argument est donc plus fort qu'il n'y paraissait.

## Ce que la recherche n'a pas apporté

Aucune source consultée ne traite d'un CLI dont les ressources sont des documents rédigés, ni de la localisation d'un outil par rapport au système qu'il outille. La question de la tâche 5 est donc une question de génie logiciel ordinaire, à trancher sur les faits locaux.

C'est écrit dans `FND-001` section 7.3 plutôt que dissimulé, parce qu'une recherche qui ne dit pas où elle s'arrête laisse croire qu'elle couvre tout.

## Comment l'analyse a été conduite

La question posée est fermée et attend une réponse. Trois choix de méthode.

**Rassembler les faits avant les options.** Huit faits de `ANL-001` sont rassemblés en tête, dont le plus décisif n'était pas attendu : le seul CLI du corpus qui ait réellement équipé des dépôts, `tda`, vivait dans un dépôt à lui et avait un `setup.sh`. C'est un précédent en faveur de la séparation.

**Retourner le précédent.** Le même précédent montre autre chose : les huit dépôts équipés par `tda` renvoient encore aujourd'hui à une méthode délaissée deux semaines après leur création. La séparation a rendu la diffusion possible et n'a protégé de rien. Le précédent ne dit donc pas qu'il faut séparer, il dit **quand** il faut séparer.

**Trancher avec un critère de renversement.** La réponse est de rester dans ce dépôt, ce qui contredit le précédent le plus visible. Une réponse qui va contre un précédent doit porter son propre mécanisme de révision, sinon elle devient une opinion qu'on redébat. La condition de découplage, mesurable sur les vingt derniers commits, mesure exactement la raison invoquée pour ne pas séparer : si le couplage disparaît, la décision se renverse sans discussion.

## Le fait qui a emporté la décision

La méthode et l'outil changent aujourd'hui ensemble, et ce n'est pas une hypothèse.

En quatre tâches d'une seule journée, `RES-001` a été modifié deux fois, `skl-001-ressource` deux fois, l'index trois fois, chaque fois parce qu'une tâche ultérieure rendait faux ce qu'une tâche antérieure déclarait. Les neuf contrôles de `skl-001` sont, par construction, le cahier des charges d'une commande de validation. Le fichier d'état d'installation est à la fois une décision de méthode et une structure de données du CLI.

Séparer un couple qui évolue à ce rythme transformerait chaque mise en cohérence en deux commits dans deux dépôts, sans mécanisme pour garantir qu'ils sont faits ensemble. Le corpus montre ce que devient une coordination non outillée : trois `INTENTION.md` identiques désignant le mauvais client.

## Pourquoi l'ADR s'arrête où il s'arrête

La session annonce une prochaine session dédiée à l'outillage. `ADR-003` décide donc de l'adoption et du modèle, et reporte explicitement quatre choses : l'ordre des axes de la grammaire, le langage d'implémentation, le mécanisme d'extension, le format des sorties.

La borne est motivée par un fait et non par prudence : `ANL-001` établit au défaut D8 que le harnais actuel décrit sept commandes `clia` dans un dépôt qui n'a aucun exécutable. Décrire une interface avant de l'avoir est l'erreur mesurée de ce dépôt.

## Une tension que l'ADR n'a pas pu résoudre

`ADR-003` D7 pose qu'une source machine-lisible des types est nécessaire, parce qu'un outil ne peut pas lire une table rédigée pour un humain. Mais `ADR-001` fait de la définition de type la source de vérité unique, et une source parallèle recréerait le défaut de duplication que `NON-002` Q6 porte déjà.

La seule position tenable est que la source machine-lisible soit **dérivée** des définitions et non écrite à la main, et que cette dérivation soit un travail de `clia`. C'est écrit dans D7 comme tension signalée, pas comme problème résolu : l'outil qui doit produire la dérivation est celui dont l'existence dépend de la dérivation.

## Ce que la tâche a révélé sur l'état du dépôt

Les trois livrables appartiennent à des types sans définition. Combiné aux constats de la tâche 4, cela donne sept types employés sans définition sur neuf, et un contrôle de conformité inapplicable à la majorité des livrables.

Le constat est plus large qu'un défaut de rangement. Il signifie que ce dépôt produit, depuis cinq tâches, des ressources dont la forme n'est fixée par rien d'autre que l'imitation. `NON-011` le porte, et propose la voie la moins coûteuse : rapatrier six définitions depuis `micrologic-clients`, ce que `ANL-001` recommandait déjà au titre du risque de perte.

## Ce qui a été refusé

Toute spécification de commande, tout code, toute restauration de `setup.sh`. La session d'outillage est annoncée.

Toute création de dépôt et tout déplacement de fichier. `ADR-003` D4 prépare l'extraction, il ne la fait pas.

Le renommage de `FND-001` et `ANL-002` en nommage daté pour se conformer à `RES-001`. Trois fichiers sont concernés, dont un nommé sur demande de l'humain à la tâche 1. Corriger de ma propre initiative aurait tranché une question qui appartient à l'humain, et qui est portée par `NON-011` Q2.
