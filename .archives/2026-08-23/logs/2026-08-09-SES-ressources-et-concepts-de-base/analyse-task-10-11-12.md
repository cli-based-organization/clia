# Analyse préalable, tâches 10, 11 et 12

## Pourquoi la tâche 12 d'abord

Trois raisons. Elle est vérifiable immédiatement, par une commande. Son principe est invocable par les deux autres tâches. Et un bogue de découvrabilité signalé par l'humain doit être corrigé avant d'écrire de nouveaux documents, sinon le système gagne de la théorie et garde son défaut.

## Ce que le relevé de la tâche 12 a changé

L'humain signale un cas. J'ai commencé par relever l'étendue, et six verbes sur sept étaient atteints.

Le geste juste n'était donc pas de corriger `res new` mais de comprendre la cause commune : chaque verbe validait ses arguments avant de reconnaître l'aide. Une fonction `clia_is_help` appelée en première ligne règle les sept d'un coup, et empêche que le huitième verbe reproduise le défaut.

C'est la différence entre corriger un symptôme et corriger une cause, et le relevé initial est ce qui l'a permis.

## Le principe est plus utile que la correction

`PDC-001` est le premier principe de conception de ce dépôt, et le type `PDC` existait depuis la tâche 8 sans instance.

Deux choix de rédaction.

**Énoncer les interdits de manière reconnaissable.** Quatre interdits, chacun avec le signe qui permet de le constater. Le troisième est celui qui a été violé : un message d'erreur qui constate sans orienter. « description manquante » est vrai et inutile ; « description manquante, voir clia res new --help » oriente.

**Automatiser deux des trois contrôles.** `RES-012` pose que la violation d'un principe est un défaut, ce qui suppose de savoir la détecter. Un principe sans moyen de vérification est une exhortation. Le troisième contrôle, celui des harnais, reste manuel, et il échoue.

## Deux bogues trouvés en chemin, et le motif qui revient

En validant `PDC-001`, `clia res ls` a affiché **deux lignes pour un seul type** : « Principe de conception » avec zéro instance, et « principe-de-conception » sans définition.

Cause : le décompte comparait le **titre** de la définition au champ `type` des instances. Le titre est un libellé lisible, le champ `type` porte le nom canonique.

C'est la quatrième fois de cette session que cette confusion produit un défaut. À la tâche 6, l'adresse était prise pour l'identité. À la tâche 8, le champ `type` était dérivé du titre, et la résolution échouait sur les accents. Ici, le décompte comparait des titres.

Le motif est stable et mérite d'être nommé : **l'outil dérivait de ce qui s'affiche plutôt que de ce qui identifie.** C'est le même défaut que celui que `ADR-001` D3 corrige au niveau du modèle, reproduit quatre fois au niveau du code.

Le second bogue est plus simple : les gabarits étaient comptés comme instances, alors que `RES-001` les place hors du modèle. C'est la réponse à `NON-012` Q6, qui demandait si le décompte devait exclure autre chose que les archives.

## Tâche 10 : ce que « strictement » impose

L'adverbe de la demande fait tout le travail. Sans lui, la tâche serait un rangement ; avec lui, elle exige une frontière vérifiable et sans recouvrement.

Deux décisions en découlent, et elles sont inconfortables.

**Un critère unique, en une question.** « Cet artefact reste-t-il vrai si l'on change de langage ? » Un critère plus riche aurait été plus juste et inapplicable. Celui-ci tranche en une lecture.

**Un test exécutable.** Supprimer l'implémentation et voir ce qu'il reste. C'est le test que le corpus a échoué onze fois, et il échoue aujourd'hui sur ce dépôt : la grammaire du CLI n'existe que dans le code.

Écrire une décision dont le test échoue immédiatement est le geste utile. L'alternative aurait été de poser un critère assez faible pour que le système le satisfasse, ce qui n'aurait rien mesuré.

## Ce que la tâche 10 fait apparaître et que je n'avais pas vu

`ADR-006` D2 interdit de nommer une technologie dans la spécification. Or `ADR-001` D2 nomme le markdown et le YAML, et c'est une décision fondatrice du système.

Je n'ai pas tranché. Les deux positions sont défendables : soit `ADR-001` D2 est de l'implémentation déguisée en spécification et doit être scindé, soit le format est une propriété observable du système et D2 est trop strict. `NON-018` Q2 le porte.

C'est le genre de contradiction qu'une décision de séparation stricte devait faire apparaître, et c'est son premier bénéfice.

## Tâche 11 : accepter la critique et la chiffrer

L'humain dit que `FND-002` n'est pas assez long ni exhaustif et que ses citations ne sont pas au niveau universitaire. La critique est fondée, et la réponse utile n'est pas de l'admettre mais de la **mesurer**.

Trente lignes par question de recherche. Quatre sources par question. Zéro référence complète. Ces trois chiffres sont dans `MET-001`, dans un tableau qui compare le seuil attendu au résultat obtenu, ligne par ligne.

Deux choix suivent de là.

**Conserver les sept étapes de la tâche 7.** Elles ne sont pas en cause : le procédé a bien fonctionné, et l'inventaire sémantique a même été la meilleure partie de `FND-002`. Ce qui manquait était en aval du procédé.

**Ajouter trois étapes qui portent sur la rigueur plutôt que sur la démarche.** Vérifier les références, mesurer la densité, dire ce qui manque. Les trois sont mécaniques, donc vérifiables, ce qui est la seule manière de ne pas répéter le défaut.

**Et déclarer que la méthodologie est dérivée d'un échec.** Sa rubrique « Éprouvé sur » ne contient que deux cas, tous deux avec leurs défauts. Une méthodologie qui prétendrait à la validité sans avoir été employée serait exactement le travers qu'elle dénonce.

## Ce qui a été refusé

**Écrire les spécifications manquantes.** La tâche 10 demande une DCN et un ADR, pas un corpus de spécifications. Les écrire aurait engagé un travail que `NON-018` Q1 doit d'abord cadrer.

**Déplacer les quatre-vingt-neuf artefacts dérivés.** Ils sont régénérables, donc le coût serait faible, et `ADR-006` D7 pose que la décision est de nature et non de rangement.

**Produire une fondation pour éprouver `MET-001`.** Aucune n'était demandée.

**Corriger `ADR-001` D2.** La contradiction est ouverte, non tranchée. Le corriger de ma propre initiative aurait été trancher à la place de l'humain une question fondatrice.
