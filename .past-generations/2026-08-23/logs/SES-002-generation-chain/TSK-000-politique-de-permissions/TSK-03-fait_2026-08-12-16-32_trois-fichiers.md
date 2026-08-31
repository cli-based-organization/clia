# Ce qui a été fait

`MET-003` étape 3.

## Trois fichiers

| Fichier | Rôle |
|---|---|
| `.claude/settings.json` | La politique, versionnée : 30 `allow`, 14 `ask`, 7 `deny`, un hook |
| `.claude/hooks/refuser-git-en-ecriture.py` | La garde `C2`, un parseur de sous-commande |
| `.claude/hooks/test_refuser-git-en-ecriture.sh` | Son banc, **51 cas** |

`.claude/` n'est pas ignoré par git : la politique est versionnable et vaudra pour tout agent travaillant dans ce dépôt, pas seulement pour cette machine.

## Ce que la garde refuse, et ce qu'elle laisse passer

Elle refuse les six verbes que `C2` nomme, sous toutes les formes d'appel éprouvées : option de répertoire, option de configuration, chemin absolu du binaire, préfixe d'environnement ou d'élévation, commande composée, enchaînement par tube, plusieurs lignes.

Elle laisse passer toute lecture, les autres verbes de `clia`, et les documents qui **parlent** de ces commandes sans les exécuter.

## Trois défauts trouvés en éprouvant, dont un en conditions réelles

### Le premier : une expression régulière ne suffit pas

Deux formes passaient sur vingt-trois cas. Remplacée par un parseur qui parcourt les jetons.

### Le deuxième : le lexer ignore les opérateurs shell

Sur une commande enchaînée par point-virgule, le jeton produit collait le séparateur au mot précédent et la seconde commande passait inaperçue. Corrigé par `punctuation_chars`, puis par la reconnaissance de tout jeton fait uniquement de ponctuation — ce qui couvre aussi les formes composées de redirection.

### Le troisième : **la garde a bloqué l'écriture de son propre journal**

En écrivant ce journal, la garde a refusé la commande. Motif : le corps du document en place citait les verbes interdits dans un tableau de documentation.

**C'est le faux positif le plus coûteux possible pour ce dépôt**, où la plupart des documents sont écrits par un document en place. Corrigé : le corps d'un document en place est du texte, pas une commande, et il est retiré avant l'analyse.

**Le défaut s'est manifesté en usage réel, pas au banc.** Les quarante-deux cas du banc passaient tous.

## Un quatrième défaut, sans conséquence

Le saut de ligne n'était pas traité comme séparateur : une commande sur la ligne suivante se retrouvait dans le segment de la précédente. Trouvé au banc, corrigé, et couvert par quatre cas.

## Ce que Claude Code a signalé de lui-même

Les règles `ask` de la forme `Write(chemin)` ne sont jamais évaluées : seule la forme `Edit(chemin)` couvre les outils d'écriture. L'avertissement était explicite, les quatre règles concernées ont été reprises.

## Ce que la politique ne fait pas

**Elle ne modifie pas `CONSTITUTION.md`.** Le document énonce `C2` ; la politique la rend tenue. Écrire dans la constitution que sa règle est désormais outillée serait utile, et ce document est en régime d'édition humaine.

**Elle ne touche pas à `settings.local.json`.** Ses cent soixante règles accumulées restent en place. Elles n'affaiblissent pas la politique — `deny` et le hook l'emportent sur tout `allow` — mais elles ne servent plus à rien : une bonne part désigne des chemins qui n'existent plus.
