# Démarche de validation, tâche 16

## Reproductibilité des mesures

Les onze expériences sont reproductibles par les commandes ci-dessous. Le dépôt jetable est reconstruit à chaque exécution.

### Sur ce dépôt

```sh
# A - renommages détectés dans le dernier commit
git log -1 --diff-filter=R --summary c2c4d52 | grep -c "rename"

# B - --follow traverse un déplacement massif réel
git log --oneline -- .dev/archives/ressources/analyses/ANL-006-clia-et-open-knowledge-format.md | wc -l
git log --follow --oneline -- .dev/archives/ressources/analyses/ANL-006-clia-et-open-knowledge-format.md | wc -l

# C - --follow sur un répertoire
git log --follow --oneline -- .dev/ressources/ | wc -l
git log --oneline -- .dev/ressources/ | wc -l

# D - identité de contenu d'un fichier et d'un répertoire
git rev-parse HEAD:.dev/ressources/RES-001-ressource.md
git rev-parse HEAD:.dev/ressources
git cat-file -t HEAD:.dev/ressources

# C8 - état de signature
git log --format='%h %G? %an' -8
git config --get commit.gpgsign
```

### Sur un dépôt jetable

```sh
# I - le seuil de similarité ne récupère pas un historique rompu
git log --follow --oneline -- <fichier> | wc -l
git log --follow --find-renames=10% --oneline -- <fichier> | wc -l
git log --follow --find-renames=1%  --oneline -- <fichier> | wc -l

# J - renommage puis réécriture, en deux commits
git mv a b && git commit -m "renommage seul"
# réécriture, puis
git commit -am "réécriture seule"
git log --follow --oneline -- b

# K - renommage d'un répertoire
git mv res autre && git commit -m "renommage du répertoire"
git log --follow --oneline -- autre | wc -l
git log --follow --oneline -- autre/<fichier> | wc -l

# L, M - chaîne des identités et diff entre deux d'entre elles
for c in $(git rev-list --reverse HEAD); do git rev-parse "$c:<chemin>"; done
git diff --stat <tree1> <tree2>

# O, R - déterminisme et indépendance du chemin
git rev-parse HEAD~2:<dir> HEAD:<dir>

# P - écrasement de commits
git rev-list --count HEAD          # avant
git reset --soft <racine> && git commit -m squash
git rev-list --count HEAD          # après
git log --follow --oneline -- <fichier> | wc -l
```

## Contrôles exécutés

1. Chaque chiffre de `ANL-005` est une sortie de commande, non une estimation. Les onze expériences ont été rejouées après rédaction.
2. Vérification que les mesures sur ce dépôt et celles du labo ne sont pas mélangées : la table de Méthode déclare le support de chacune.
3. Vérification de la citation de `git-log(1)` par `man git-log`, texte exact de l'option `--follow`.
4. Vérification de la version de git employée, `2.39.5`, et mention dans les limites.
5. Vérification que le comportement de `--follow` sur un répertoire est bien sans effet et non en erreur, par comparaison du nombre de commits avec et sans l'option.
6. Vérification de l'état de signature par `%G?` sur les huit commits, et de l'expiration de la clé GPG par `gpg --list-secret-keys`.
7. Vérification de la disponibilité des clés SSH, qui fonde la recommandation R3.
8. Vérification qu'aucun outil d'ancrage externe n'est installé, ce qui fonde la limite déclarée sur les options 5 à 7.
9. Vérification que `ADR-004` pose bien les trois formes d'implémentation citées, par lecture de sa décision.

## Validation de forme

10. Validation de schéma de `ANL-005` contre `analyse.cue`.
11. Comparaison des sections présentes avec celles déclarées par `RES-010`.
12. Vérification des liens relatifs.
13. Contrôle V10 proposé par `ANL-004` : aucune rubrique méta.
14. Mesure M2 de `ANL-004` appliquée au livrable : marqueurs de justification en usage.
15. Vérification que chaque source porte son état de vérification, et que les sources non interrogées sont déclarées comme telles.

## Validation de portée

16. Vérification qu'aucune recommandation n'est appliquée : signature non activée, harnais non modifiés, aucune commande implémentée.
17. Vérification que la suite de tests du CLI reste verte.
