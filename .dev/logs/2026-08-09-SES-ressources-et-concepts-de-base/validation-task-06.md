# Démarche de validation, tâche 6

## Validation du code

1. Analyse syntaxique de chaque fichier par `bash -n`.
2. `shellcheck -S warning` sur les cinq fichiers de code et sur la suite de tests.
3. Suite de tests automatisée, `tests/test_clia.sh`, 66 assertions.
4. Essais manuels de chaque commande demandée, dans le dépôt de travail et dans un dépôt d'essai distinct.

## Ce que la suite de tests couvre

| Domaine | Assertions | Ce qui est vérifié |
|---|---|---|
| Réflexivité | 7 | version, aide, aide sans argument, contexte, code de retour d'une commande inconnue |
| Contexte-répertoire | 5 | dépôt courant distinct de `CLIA_HOME`, remontée depuis un sous-répertoire, refus hors dépôt |
| `res ls` | 8 | types définis, préfixe, cycle, types sans définition, alias, absence d'instance, type inconnu |
| Résolution de type | 5 | par nom, par préfixe, singulier, pluriel |
| `res new` | 15 | slug translittéré, frontmatter, version selon le cycle, nommage daté, séquence, refus de doublon, refus de type non défini, arguments manquants |
| `res show` et `edit` | 8 | trois formes d'identifiant, ambiguïté, ressource archivée, éditeur appelé |
| Configuration | 12 | clés, origines, normalisation, remplacement sans doublon, clé inconnue, arguments manquants, fichier non exécuté |
| Exclusion des archives | 2 | exclusion par défaut, désactivation par variable |

## Isolation des tests

Chaque exécution crée un dépôt temporaire et redirige `XDG_CONFIG_HOME` vers un répertoire temporaire, supprimé à la sortie par un `trap`. Les variables de configuration héritées du poste sont explicitement neutralisées.

Aucun test ne touche le dépôt de travail ni la configuration de l'utilisateur. C'est la condition pour qu'ils soient rejouables, et elle a été vérifiée : `git status` ne montre aucun fichier résiduel après exécution.

## Contrôles de sécurité

5. Le fichier de configuration n'est jamais sourcé. Un test y écrit une substitution de commande et vérifie qu'elle ne s'exécute pas.
6. `setup.sh install` demande confirmation avant de modifier `~/.bashrc`, sauvegarde le fichier, et délimite son ajout pour permettre le retrait.
7. `setup.sh activate` ne modifie aucun fichier du système.
8. `config set` réécrit le fichier de manière atomique, par fichier temporaire puis remplacement.

## Contrôles de conformité au modèle

9. Chaque décision de `ADR-003` appliquée par le code est identifiée dans un commentaire du fichier concerné.
10. Le squelette produit par `res new` porte les cinq champs communs que `skl-001-ressource` règle A1 rend obligatoires.
11. Le nommage produit suit le cycle de vie déclaré par la définition du type, conformément à `RES-001`.
12. Les objections et l'index sont mis à jour pour refléter ce que l'implémentation a révélé.

## Contrôles sur les livrables documentaires

13. `NON-012` et la mise à jour de `NON-001` passent les contrôles V1, V2, V4, V5, V6 et V8 de `skl-001-ressource`.
