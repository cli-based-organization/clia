---
type: specification
version: 0.1.0
title: "Format markdown-clia-session"
date: 2026-07-10
---

# SPEC-003 - Format markdown-clia-session

- **Requis couverts** : `REQ-002-cli-clia` (F pour `ses check`)
- **Décisions applicables** : `ADR-006-gestion-des-sessions`, `ADR-004-ressources-livrables`

## Objet et périmètre

Décrit le format `markdown-clia-session` d'un fichier session (`session.md`, `.dev/session-x<YZ>.md`, `.dev/sessions/SES-*.md`) et les règles vérifiables par `clia ses check`. Hors périmètre : le contenu métier des tâches (libre).

## Comportement

Un fichier conforme comporte, dans cet ordre :

1. un **en-tête** (frontmatter YAML) optionnel en planification, **obligatoire** dès l'ouverture, délimité par `---`, contenant au moins `start-at` (session active ou archivée) et `end-at` (session archivée) ;
2. une section `# Intention` non vide ;
3. une section `# Contexte` non vide ;
4. une section `# Tâches` contenant au moins une tâche `## <N>. [<catégorie>] <titre>`.

`clia ses check` valide ces règles et retourne 0 si conforme, un code non nul sinon (diagnostic sur stderr).

Note : le frontmatter est la seule occurrence autorisée de `---` (règle markdown strict du dépôt, `CLAUDE.md`).

## Interfaces

Structure attendue :

```markdown
---
start-at: 2026-07-10T08:00:00-04:00
end-at: 2026-07-10T09:30:00-04:00
---
# Intention

<texte>

# Contexte

<texte>

# Tâches

## 1. [<catégorie>] <titre>

<description>
```

Règles vérifiables (`clia ses check`) :

- **S1** : présence des trois titres de niveau 1 `# Intention`, `# Contexte`, `# Tâches`, dans cet ordre.
- **S2** : au moins une tâche `## <N>. [...] ...` sous `# Tâches`.
- **S3** : numérotation des tâches strictement croissante à partir de 1.
- **S4** : pour une session **active** (`session.md`), présence de `start-at` dans le frontmatter ; pour une **archive** (`SES-*`), présence de `start-at` et `end-at`.
- **S5** : aucun filet `---` hors frontmatter.

## Contraintes et garanties

- Le template `.dev/templates/session.template.md` est un squelette conforme aux règles S1 et S2 (sans frontmatter, ajouté à l'ouverture).
- `clia ses check` opère en lecture seule (aucun effet de bord).
- La catégorie de tâche (entre crochets) est libre ; sa présence est vérifiée, pas sa valeur.

## Exemples

Conforme :

```
clia ses check
# stdout : (rien) ; code 0
```

Non conforme (section manquante) :

```
clia ses check
# stderr : [ERR] section manquante : # Contexte ; code 1
```

## Traçabilité

| Élément spécifié | Requis satisfait |
|---|---|
| règles S1-S5 vérifiées par `ses check` | REQ-002-F7 |
| lecture seule de `ses check` | REQ-002-NF3 |
| template conforme réutilisé | REQ-002-F4 |
