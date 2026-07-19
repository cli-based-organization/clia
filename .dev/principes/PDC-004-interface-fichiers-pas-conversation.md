# PDC-004 - L'interface de travail est des fichiers, pas la conversation

- **Statut** : accepté
- **Version** : 0.1.0
- **Date** : 2026-07-18

## Énoncé

La source de vérité du travail est toujours le fichier markdown versionné ; les échanges textuels (stdout, conversation) sont secondaires et ne servent qu'à orienter vers les fichiers.

## Justification

Un système fondé sur des fichiers versionnés est inspectable, traçable, réutilisable et durable, contrairement à une conversation éphémère (`CONSTITUTION.md`). Ce principe garantit que tout travail laisse une trace consultable et que l'humain peut inspecter n'importe quelle étape.

## Portée

Toute production de l'agent (plans, logs, fondations, analyses, ADR, principes, bugs). S'applique aussi à la façon dont l'humain consulte le travail (les fichiers, pas un résumé conversationnel).

## Implications

- Impose de matérialiser toute production en fichier à l'emplacement conventionné.
- Impose que la réponse textuelle de l'agent se limite à indiquer les fichiers produits, leur chemin et un résumé.
- Interdit de faire d'un échange conversationnel la source de vérité d'un livrable.

## Critères de conformité

- Chaque tâche traitée produit ses fichiers et son log (`skl-008`).
- Aucune décision ou livrable ne vit uniquement dans la conversation.

## Tensions

- Aucune majeure ; principe très stable, aligné avec le pattern LLM Wiki (`FND-2026-07-18-llm-wiki-okf-gestion-connaissance`).

## Références

- `CONSTITUTION.md` (« Interface de travail : fichiers, pas conversation »)
- `ANL-2026-07-18-principes-de-conception-du-repo` (P4)
