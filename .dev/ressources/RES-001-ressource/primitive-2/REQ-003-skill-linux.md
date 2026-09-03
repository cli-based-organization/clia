---
type: requis
id: REQ-003
titre: "Un skill de ressource, sur Linux"
ordre: 2
source: SES-001 tâche 21
editeur: agent
---

# REQ-003 — Un skill de ressource, sur Linux

SPC-001 dit ce qu'une ressource est. Ce document dit comment la troisième des
choses qu'elle apporte — le skill — existe sur un système de fichiers Linux :
où il est, quelle forme il a, ce que l'activation fait, et ce qui se vérifie.

Il est de deuxième ordre : un agent l'a rédigé en lisant le code, et un
humain le relit. Ce qu'il décrit est ce que `_scripts/lib/fourniture.sh` et
`_scripts/lib/cmd/skill.sh` tiennent au 2026-09-02.

## 1. Ce qu'est un skill

**Une procédure qu'un agent charge au moment de s'en servir.**

Une fonctionnalité est toujours dans le contexte ; un skill n'y entre qu'à
l'invocation. C'est ce qui permet à un skill d'être long : il ne coûte rien
tant qu'on ne l'appelle pas.

Deux choses le composent, et les deux sont nécessaires :

* **la procédure**, déposée là où l'agent va la chercher ;
* **la directive**, posée dans le harnais, qui dit quand l'employer.

Une procédure sans directive n'est jamais invoquée : l'agent ne sait pas
qu'elle existe. C'est pourquoi l'activation pose les deux.

## 2. Où il vit

Deux formes sont admises :

```
<zone livrée>/<ressource>/skills/<nom>/SKILL.md   un répertoire
<zone livrée>/<ressource>/skills/<nom>.md         un fichier seul
```

La première est celle que Claude Code emploie, et elle laisse le skill porter
ses propres fichiers — un gabarit, un script, un exemple. La seconde est
commode pour un skill qui tient en une page.

**L'activation les ramène toutes deux à la première.** Ce qui est posé sous
`.claude/` est toujours un répertoire portant `SKILL.md`.

Un répertoire qui ne porte pas `SKILL.md` n'est pas un skill, et n'est pas
listé. Un fichier qui n'est pas `.md` non plus.

## 3. Sa forme

Un frontmatter YAML, puis un corps markdown :

```markdown
---
name: analyse-task
description: "Prendre une tâche de la session en cours…"
---

# Analyser une tâche de la session en cours
…
```

Seul `description` est lu par clia — elle devient la directive posée dans le
harnais. Le reste appartient au système IA qui lira la procédure, et clia n'y
touche pas : il la copie.

## 4. Ce que l'activation fait

`clia skill activate <nom> [PREFIXE]` fait deux gestes, dans cet ordre.

**1. La procédure est copiée** sous `.claude/skills/<nom>/` :

```
cp -r <source>/.  .claude/skills/<nom>/     forme répertoire
cp   <source>     .claude/skills/<nom>/SKILL.md   forme fichier
```

Un emplacement déjà occupé est **refusé**. clia n'écrase pas ce qu'il n'a pas
posé — un skill écrit à la main sous `.claude/` n'est pas une variante de
celui d'une ressource, c'est le travail de quelqu'un.

**2. La directive est posée** dans `CLAUDE.md`, entre les marqueurs de la
zone gérée des skills :

```html
<!-- CLIA:SKILLS:BEGIN -->
<!-- BEGIN analyse-task skill -->
## Skill : analyse-task

Prendre une tâche de la session en cours…

La procédure est dans `.claude/skills/analyse-task`. Elle vient de la
ressource session.
<!-- END analyse-task skill -->
<!-- CLIA:SKILLS:END -->
```

La directive porte la description et l'emplacement, non la procédure. C'est
tout l'intérêt : ce qui reste dans le contexte est court.

## 5. Ce que la désactivation fait

Elle retire la copie et la directive. Elle **refuse** quand la copie diffère
du skill dont elle vient :

```
clia: .claude/skills/<nom> diffère du skill dont il vient
      la modification serait perdue ; clia ne l'efface pas
```

Une copie modifiée porte un travail que clia ne sait pas rendre à sa source.
Il nomme l'écart et n'écrit pas — c'est ce qui le rend sûr à lancer.

Le skill lui-même n'est pas touché : il reste sous la ressource. Désactiver
n'est pas désinstaller.

## 6. L'état

**Il ne se déclare nulle part.** Un skill est actif quand sa procédure est
sous `.claude/skills/` et sa directive dans le harnais. `clia skill ls` lit
les deux, et sait donc dire qu'un skill est à moitié posé.

## 7. Ce qui se vérifie

1. Les deux formes — répertoire et fichier — sont reconnues, et l'activation
   les ramène toutes deux à un répertoire portant `SKILL.md`.
2. Un emplacement occupé sous `.claude/skills/` est refusé, code 1.
3. Une copie modifiée n'est pas effacée, code 1.
4. Activer pose la procédure **et** la directive.
5. Désactiver retire les deux, et laisse le skill sous la ressource.
6. Une désignation ambiguë est refusée, et les candidates sont nommées.

`_scripts/tests/test_fourniture.sh` les mesure.

## 8. Ce que ce document ne tranche pas

**L'emplacement `.claude/`.** C'est le seul que clia sait servir. L'énoncé de
SES-001 tâche 15 disait « .claude (ou autre selon le système IA utilisé) » ;
rien ne rend cet emplacement réglable, et il n'est pas une zone au sens de
REQ-005 — aucune ressource ne le déclare, et aucune variable ne le déplace.

C'est le premier candidat évident à en devenir une : un dépôt qui emploie un
autre système IA n'a aujourd'hui aucun moyen de le dire.

**Le nom du frontmatter.** Les skills observés portent `name:`, les
fonctionnalités `nom:`. clia ne lit ni l'un ni l'autre — il ne lit que
`description` — et la divergence n'a donc aucun effet, mais elle se voit.
