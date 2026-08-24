# Analyse

`MET-003` étape 2.

## Ce qui a été mesuré, et qui a changé la conception

**Une règle `deny` ne suffit pas.** Quatre essais en dépôt jetable.

| Essai | Résultat |
|---|---|
| `deny` sur le verbe seul, appel direct | **Bloqué** |
| Le même, appel avec l'option `-C` | **Un commit a été créé** |
| `deny` avec joker au milieu, même appel | **Un commit a été créé** |
| `deny` sur toute la commande git | Bloqué, **mais la lecture aussi** |

**Une règle `deny` ne compare que le début de la ligne.** Et `deny` l'emporte sur `allow` : interdire toute la commande puis rouvrir la lecture est impossible.

**Le `deny` tient en revanche sous `bypassPermissions`**, vérifié : c'est ce qui en fait une garantie et non une préférence. Le hook hérite de cette propriété.

## Le hook, et pourquoi un parseur

Un hook `PreToolUse` reçoit la ligne de commande entière et décide.

**Une expression régulière a été écrite d'abord, puis abandonnée.** Sur un banc de vingt-trois cas, elle laissait passer deux formes : le motif ne prévoyait pas les options globales dont la valeur est un argument séparé.

**La sous-commande n'est pas le deuxième mot de la ligne.** C'est le premier mot qui n'est ni une option globale, ni la valeur d'une option globale. Le déterminer demande de parcourir les jetons.

## Ce que les settings portent encore

| Mécanisme | Ce qu'il porte |
|---|---|
| `allow` | Ce qui est courant et sûr : lecture, tests, `clia`, `cue` |
| `ask` | Ce que `C3` protège : les documents en régime d'édition humaine |
| `deny` | La poussée vers un dépôt distant, la configuration globale, les secrets |
| hook | `C2`, les six verbes, quelle que soit la forme d'appel |

**`defaultMode` reste `default`.** Poser `dontAsk` dans un fichier versionné ferait échouer silencieusement toute commande non listée, y compris en session interactive. Le mode appartient à l'invocation, la politique appartient au dépôt.

## Ce que la garde ne garantit pas

Un script tiers, un alias, ou un appel indirect depuis un interpréteur atteignent l'outil sans que la ligne de commande le montre.

**La garde rend la transgression explicite ; elle ne la rend pas impossible.** C'est la portée que `CONSTITUTION.md` déclare déjà dans sa section « Ce que cette constitution ne garantit pas », et celle que `clia_acteur_est_agent` déclare dans son commentaire.
