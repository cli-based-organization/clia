# Démarche de validation

## Contrôles de couverture

1. Liste des 166 dépôts établie par recherche des répertoires `.git` jusqu'à trois niveaux sous `$HOME/git`.
2. Vérification que la somme des dépôts attribués aux quatre fichiers `repos/` égale 166, sans doublon non intentionnel.
3. Vérification programmatique que chaque dépôt non traité dans `01` et `02` apparaît nommément dans `03` ou `04`.

## Contrôles de forme

Les règles de markdown strict observées dans le corpus ont été appliquées et vérifiées :

1. absence de tiret cadratin (U+2014) et de tiret demi-cadratin (U+2013) dans tous les fichiers du bundle ;
2. absence de filet horizontal `---` hors clôture de frontmatter ;
3. frontmatter YAML présent sur chaque fichier markdown, avec `type`, `title`, `version`, `status` et bloc `generated`.

## Contrôles de justesse

1. Chaque chiffre avancé dans les analyses provient d'une commande dont le résultat est reproductible, et non d'une estimation.
2. Les trois mesures transverses décisives (collision des numéros de skill, divergence des harnais, propagation des traces) ont été revérifiées par une seconde commande indépendante avant rédaction.
3. Les citations de contenu de dépôt ont été lues dans le fichier source, non déduites du nom du fichier.
