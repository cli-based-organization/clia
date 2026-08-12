# Demande interprétée, tâche 2 de SES-002

Écrit avant toute exploration. `MET-003` étape 1.

## Ce que l'humain demande

« Exécuter le plan `PLN-007` », sans autre précision.

## Ce que `PLN-007` est

Sept chantiers pour remplacer les champs d'état actuels par les quatre champs `maturity`, `adoption`, `activated`, `domain-status`, déclarés par `DCN-016`.

## Le blocage que le plan porte lui-même

**`DCN-016` a `effet: suspendue`.** Elle est un premier jet rédigé par l'agent le 2026-08-11 ; `DCN-013` autorise ce premier jet mais le tient suspendu jusqu'à approbation manuelle de l'humain. Elle n'a reçu aucune approbation depuis : le fichier est inchangé, vérifié à l'instant.

**`PLN-007` le dit lui-même**, dans ses propres objections : « Ce plan applique une décision suspendue... Exécuter ce plan avant l'approbation reviendrait à appliquer une décision qui n'en est pas une. »

**La portée n'est pas mineure.** 628 valeurs sur 157 instances, 154 champs supprimés, 62 schémas régénérés, et un chantier — E — que le plan qualifie lui-même de risqué et mal protégé par les contrôles existants.

## Ce que je ne fais pas sans trancher ce point

Exécuter les chantiers A à F reviendrait à appliquer, de mon propre chef, une décision que le système lui-même tient pour non active. `CONSTITUTION.md` C1 réserve la création d'une décision à l'humain ; l'appliquer au dépôt entier avant son approbation en est le prolongement direct.

**Un chantier fait exception : G**, le contrôle de valeur unique. Il est déclaré indépendant dans le plan, ne touche aucun champ de `DCN-016`, et répond à `NON-035` par un mécanisme générique, pas par l'application de la décision suspendue.

## Ce que je fais

Chantier G, dans la foulée. Pour A à F, je pose la question à l'humain plutôt que de supposer une réponse : c'est exactement ce que `skl-001` A8 demande de ne pas faire — prendre le silence pour un accord.
