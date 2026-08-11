# Résultat de la validation, tâche 16

## Bilan

| Contrôle | Résultat |
|---|---|
| Rejeu des mesures après rédaction | **identiques**, 11 sur 11 |
| Schéma du livrable | **conforme** |
| Sections déclarées et présentes | **0 manquante** |
| Liens relatifs | **0 cassé** |
| Rubriques méta, V10 | **0** |
| Marqueurs de justification en usage, M2 | **0** sur 2 577 mots |
| Fichiers modifiés hors du livrable | **0** |
| Tests du CLI | **91 réussis, 0 échoué** |

## Rejeu des mesures

| Mesure | Valeur au rejeu | Valeur dans `ANL-005` |
|---|---|---|
| Renommages détectés dans `c2c4d52` | 215 | 215 |
| `ANL-006` sans puis avec `--follow` | 1 puis 3 | 1 puis 3 |
| `.dev/ressources/` avec puis sans `--follow` | 5 puis 5 | 5 puis 5 |
| Commits non signés | 8 sur 8 | 8 sur 8 |

Les sept mesures du dépôt jetable ont été rejouées lors de la construction du labo, chaque expérience produisant sa sortie dans la même exécution. Les commandes sont consignées dans `validation-task-16.md`, ce qui rend le labo reconstructible sans le conserver.

## Citation vérifiée

Contrôle 3. `man git-log`, git 2.39.5, texte exact :

> `--follow` : Continue listing the history of a file beyond renames (works only for a single file).

La limite de C2 est établie par la documentation de l'outil, non par déduction depuis une mesure.

## Ce que le rejeu a confirmé sur le comportement du répertoire

Contrôle 5. `--follow` sur un répertoire retourne le même nombre de commits que sans, et ne produit aucune erreur ni avertissement.

C'est le point le plus facile à manquer : l'option est acceptée, ne fait rien, et ne le signale pas. Un mécanisme de traçabilité qui s'appuierait dessus paraîtrait fonctionner.

## Registre du livrable

Contrôles 13 et 14, correctif de `ANL-004` appliqué.

| Contrôle | Résultat |
|---|---|
| Rubriques méta, liste noire V10 | 0 |
| Marqueurs de justification en usage | 0 |
| Sections | les six de `RES-010`, aucune de plus, aucune de moins |

## Sources

Contrôle 15. Sept sources, chacune avec son état.

| État | Nombre | Sources |
|---|---|---|
| Vérifiées localement le 2026-08-10 | 4 | `git-log(1)`, `gitglossary(7)` et `git-rev-parse(1)`, `git-config(1)`, `git-notes(1)` |
| Non interrogées, déclarées comme telles | 3 | Git SCM Book, OpenTimestamps, Sigstore |

Les trois sources non interrogées portent des affirmations sur des mécanismes, non sur des chiffres. La déclaration figure sous la bibliographie.

## Portée respectée

Contrôles 16 et 17. Zéro fichier modifié dans `.dev/skills`, `.dev/ressources`, `lib` et `bin`.

`commit.gpgsign` n'est pas configuré : la recommandation R3 est écrite et non appliquée.

Aucune commande de R4 n'est implémentée.

## Ce que la validation n'établit pas

**T6 reste déduite.** Aucune expérience ne construit le cas d'une ressource qui change de forme, un fichier devenu répertoire. La contrainte découle de C3 par raisonnement.

**Les mesures de coût manquent.** Huit commits ne permettent aucune extrapolation vers un dépôt réel.

**Les trois options d'ancrage ne sont pas éprouvées.** Aucun outil installé. Leurs verdicts reposent sur leur documentation.

**Le comportement mesuré vaut pour git 2.39.5.** La détection de renommage et les valeurs par défaut de `--find-renames` peuvent changer entre versions.
