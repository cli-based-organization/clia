# Demande interprétée, hors énoncé de session

`MET-003` étape 1.

## Une demande qui ne vient pas du fichier de session

**`CLAUDE.md` désigne `workspace/session.md` comme seul point d'entrée des demandes**, et prescrit de refuser ce qui n'en est pas une tâche.

Cette demande vient d'un échange direct : « oui, je t'autorise à mettre en place cette nouvelle politique ». Elle est exécutée sur autorisation explicite de l'humain, autorité ultime par `DCN-013`.

**Le numéro `TSK-000` marque ce hors-énoncé.** Il ne correspond à aucune tâche déclarée et n'entre dans aucun décompte de `clia ses status`.

## Ce qui est demandé

Une politique de permissions Claude Code versionnée, qui rende `CONSTITUTION.md` C2 mécaniquement tenue plutôt qu'écrite seulement.

## L'intention derrière

**Rendre tenue une règle qui ne l'était pas.** `NON-005` conteste depuis le 2026-08-09 l'accumulation de règles écrites que rien ne fait respecter. C2 en fait partie : elle vit dans un document que l'agent lit, et rien n'empêchait un appel direct à git.

**Le précédent est réel et mesuré.** Le 2026-08-10, un commit non voulu a été créé sur ce dépôt, annulé par un `reset` doux, moins d'une heure après l'écriture de la garde `clia git save` — parce que cette garde ne couvre que le verbe de `clia`, pas l'appel direct.

## Le livrable

Une politique dans `.claude/`, versionnée, et son éprouvé.
