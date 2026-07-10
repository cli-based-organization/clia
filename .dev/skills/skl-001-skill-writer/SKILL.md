---
name: skl-001-skill-writer
description: >-
  Produire un fichier SKILL.md (`.dev/skills/skl-<SEQ>-<nom>/SKILL.md`) encadrant la production
  d'un type de livrable de domaine. À utiliser quand un nouveau type de livrable est introduit
  dans un repo et nécessite un playbook de production pour l'agent IA.
---

# Skill - Conception d'un skill de livrable

> Un skill de livrable est un playbook Markdown qui encode le processus, les critères de qualité et le template d'un type de livrable donné. Ce skill produit ce playbook avec rigueur et cohérence structurelle et les conventions du repo cible.

## Quand l'utiliser

Quand un nouveau type de livrable est introduit dans un repo (via ADR ou `tda deliverable new`) et qu'il faut formaliser comment l'agent IA doit le produire. Exemples : nouveau type de rapport, de spécification métier, de plan stratégique.

Ne pas utiliser pour les skills utilitaires (scripts, automatisations) ni pour les skills de gouvernance déjà couverts par les harness-files.

## Processus

1. Lire l'ADR ou la définition du livrable cible : objet, emplacement, propriétaire, critères de complétude.
2. Identifier les **entrées** du processus de production : quels documents, contextes ou informations l'agent doit-il avoir avant de commencer ?
3. Identifier les **sorties** : quel est exactement le fichier produit, son format, son emplacement ?
4. Décomposer le processus de production en étapes ordonnées et actionnables (3 à 7 étapes).
5. Définir les **critères de qualité** du livrable : liste de conditions vérifiables (pas de formulations vagues).
6. Rédiger le **template** du livrable : structure Markdown minimale garantissant la conformité.
7. Écrire le frontmatter YAML : `name` = identifiant kebab-case complet, `description` = une phrase discriminante qui permet à l'agent de savoir quand invoquer ce skill (inclure le type de livrable, le préfixe, l'emplacement).
8. Appliquer la garde-fou : vérifier que la `description` est suffisamment précise pour ne pas être confondue avec un autre skill du repo.

## Critères de qualité

- Le frontmatter est valide YAML et la `description` contient le préfixe du livrable et son emplacement.
- "Quand l'utiliser" distingue clairement ce skill des skills voisins (artefact-de-travail, adr, etc.).
- Le processus est numéroté, chaque étape est actionnable sans ambiguïté.
- Les critères de qualité sont vérifiables (pas "le document est clair" mais "chaque section obligatoire est présente").
- Le template inclut toutes les sections requises avec des placeholders explicites.
- Markdown strict respecté (pas de filet `---` hors frontmatter, pas de tiret cadratin).

## Structure du livrable

- **Emplacement** : `.dev/skills/skl-<SEQ>-<nom>/SKILL.md`

```markdown
---
name: skl-<SEQ>-<nom>
description: >-
  Produire un <TYPE_LIVRABLE> (`<EMPLACEMENT>`). À utiliser quand <CONDITION>.
---

# Skill - <Titre>

> <Résumé en une phrase de ce que ce skill produit et pourquoi.>

## Quand l'utiliser

<Critères de déclenchement. Ce qui distingue ce skill des autres.>

## Processus

1. <Étape 1>
2. <Étape 2>
   ...

## Critères de qualité

- <Critère vérifiable 1>
- <Critère vérifiable 2>
  ...

## Structure du livrable

- **Emplacement** : `<EMPLACEMENT>`

<TEMPLATE_MARKDOWN>
```
