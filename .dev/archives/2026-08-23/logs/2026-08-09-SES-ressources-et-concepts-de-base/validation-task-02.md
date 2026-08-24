# Démarche de validation, tâche 2

## Contrôles de forme

1. Absence de tiret cadratin (U+2014) et demi-cadratin (U+2013) dans les seize fichiers.
2. Absence de filet horizontal `---` hors clôture de frontmatter.
3. Frontmatter YAML analysable par un parseur, avec présence des champs `type` et `id`.
4. Dénombrement des champs de frontmatter, attendu quatorze pour les définitions et huit pour les objections.

## Contrôles de cohérence interne

5. Tous les liens relatifs des seize fichiers résolvent vers un fichier existant.
6. Les huit `id` de définitions et les huit `id` d'objections sont distincts.
7. Chaque objection porte des questions numérotées et un bloc de réponse.
8. Chaque définition renvoie aux objections qui portent sur elle, et chaque objection déclare son champ `porte-sur`.

## Contrôle d'auto-application

9. Les huit objections respectent la structure que `RES-004` définit. C'est le seul test d'auto-application disponible en l'absence de skill, et il porte sur le type le plus employé par ce jet.
10. `RES-001` porte les quatorze champs qu'elle déclare obligatoires, vit à l'emplacement qu'elle déclare et suit la nomenclature qu'elle fixe.

## Contrôle de fondation

11. Chaque apport de conception qui s'écarte de l'état de l'art renvoie à une mesure de `ANL-001`, et non à une préférence.
