# Résultat de la validation

## Couverture : conforme

166 dépôts détectés, 166 couverts. Répartition vérifiée : 22 dans `01`, 58 dans `02`, 62 dans `03`, 24 dans `04`. Le total inclut une reprise volontaire, `noumanity-ops/technotes`, mentionné en `02` au titre du groupe et en `04` au titre de la série des technotes.

Le contrôle programmatique de couverture des dépôts non traités en `01` et `02` a signalé deux absences, `orignal-bleu-finance/poc-landing-page-0` et `-2`. Vérification manuelle : les deux sont couverts par une ligne de table groupée qui les nomme sous forme abrégée. Faux positifs du contrôle, aucune correction nécessaire.

## Forme : conforme

Aucun tiret cadratin ni demi-cadratin dans les neuf fichiers du bundle. Aucun filet `---` hors clôture de frontmatter. Les huit fichiers markdown portent les quatre champs `type`, `title`, `version`, `status`, plus un bloc `generated`.

## Justesse : conforme, avec une réserve

Toutes les mesures citées sont reproductibles par commande. Les trois mesures décisives ont été confirmées par une seconde commande indépendante.

Réserve à signaler : les dates issues de git sont les dates d'auteur, et le corpus contient au moins une anomalie manifeste, `noumanity/devops-cli` daté du 2023-11-17 avec un contenu qui semble postérieur. Les dates de dépôts jamais commités ne sont pas connues du tout : ces dépôts sont datés par leur mtime, mentionné comme tel dans l'analyse. Aucune conclusion de l'analyse ne repose sur une date isolée.

## Corrections appliquées pendant la validation

Les compteurs de dépôts par fichier annoncés dans `index.md`, `repos/01` et `repos/02` étaient estimés lors de la première rédaction. Ils ont été recalculés et corrigés : 14, 24, 57 et 71 remplacés par 22, 58, 62 et 24. La section `Méthode` de `index.md` a reçu un paragraphe déclarant le calibrage de profondeur, qui n'était pas explicite.
