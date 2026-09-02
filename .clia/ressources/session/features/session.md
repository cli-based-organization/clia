---
nom: session
description: "Ce dépôt travaille par sessions : où elles vivent, et ce qu'un agent en fait."
---

Ce dépôt travaille par sessions. Une session est un segment de travail borné
par une intention ; son énoncé porte le contexte, l'intention, les livrables,
et les tâches demandées.

### Où elles vivent

```
.dev/sessions/SES-<SEQ>[-<SLUG>].md   l'énoncé d'une session
focus/SES-<SEQ>[-<SLUG>].md           celle qui est en cours
```

La session en cours est celle dont l'énoncé se déclare `etat: ouverte`. Le
focus la désigne ; il ne la décide pas.

### Avant de travailler

Un énoncé mal formé se lit mal, et une tâche mal lue est une tâche faite à
côté. **Vérifiez la forme avant de prendre une tâche, et interrompez
l'exécution si elle n'est pas conforme.**

```sh
clia ses check              la forme de l'énoncé en cours
clia ses check SES-002      celle d'un autre
```

`check` nomme chaque écart. Il n'écrit rien : corriger l'énoncé appartient à
l'humain.

### Prendre une tâche

Le prompt d'une tâche se récupère par la commande, et non en lisant le
fichier de bout en bout : la commande rend le texte exact de la tâche
demandée, et rien d'autre.

```sh
clia ses show task 3        le prompt de la tâche 3
```

### Ce que l'agent n'écrit pas

Un énoncé de session est une demande de travail, et `CONSTITUTION.md` R2
place ce geste chez l'humain.

**Un agent ne modifie jamais un fichier de session** — ni son texte, ni son
frontmatter, ni son nom, ni son état. Ce qu'il a à en dire, il le dit ; ce
qu'il produit va ailleurs. Ouvrir et fermer une session sont des décisions :
`clia ses open` et `clia ses close` appartiennent à l'humain.
