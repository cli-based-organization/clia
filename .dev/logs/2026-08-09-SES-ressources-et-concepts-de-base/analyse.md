# Analyse préalable

## Problème de méthode

La tâche demande un résumé et une analyse critique de chaque dépôt sous `$HOME/git`. Le relevé en dénombre 166. Une lecture individuelle approfondie de chacun est hors de portée d'une tâche, et la majeure partie n'apporterait rien à la conception de `clia` : une trentaine de dépôts sont des prototypes web abandonnés en moins d'une semaine entre 2022 et 2023.

## Stratégie retenue

Relevé mécanique exhaustif d'abord, lecture sélective ensuite.

1. Inventaire automatisé des 166 dépôts : commits, dates, fichiers suivis, fichiers sur disque, entrées non commitées, remote, fichiers de harnais présents, extensions dominantes. Ces données sont consignées telles quelles dans `inventaire.yaml`.
2. Trois mesures transverses que la lecture individuelle ne peut pas produire : empreintes md5 croisées des harnais du corpus, dénombrement des instances de ressources par préfixe, table des noms distincts par numéro de skill.
3. Lecture approfondie d'une vingtaine de dépôts porteurs du système, plus le dépôt métier le plus avancé sur les ressources.
4. Calibrage de la profondeur de rédaction sur l'apport à la conception : traitement développé pour les dépôts de méthode et de travail, condensé pour les produits et les notes. Couverture des 166 dépôts sans exception.

## Ce que les mesures transverses ont apporté

Trois constats n'auraient pas été atteignables autrement, et ce sont les plus décisifs de l'analyse.

La collision de numérotation : 12 numéros de skill sur 20 portent plusieurs noms distincts selon le dépôt. Le triplet `ADR-XXX, RES-XXX, skl-XXX` du `CLAUDE.md` actuel ne désigne donc rien de stable.

La divergence des harnais : 33 `CLAUDE.md` pour 18 contenus, 32 `CONSTITUTION.md` pour 15 contenus, dont un vide de zéro octet. Aucun mécanisme de propagation n'existe.

La propagation des traces : trois dépôts de consultation partagent le même `INTENTION.md` au bit près, désignant le mauvais client, et les mêmes 18 logs avec des empreintes identiques. Parmi ces logs, celui qui documente l'écrasement d'un `INTENTION.md` par du contenu générique a été copié dans les deux dépôts où l'`INTENTION.md` est justement resté générique.

## Décision de structure du livrable

La tâche impose un répertoire, `ANL-001-<SLUG>/*`, et non un fichier unique. Le bundle suit la forme observée dans `micrologic-clients` : `index.md` en racine, données brutes séparées du texte interprété, un fichier par angle d'analyse.
