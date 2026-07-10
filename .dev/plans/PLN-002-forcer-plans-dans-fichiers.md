# PLN-002 - Forcer l'écriture des plans dans des fichiers, pas en stdout

**Statut : exécuté**

## Changelog

- **v1 (tâche-4 à tâche-5)** : création et exécution sous Haiku.
- **v2 (tâche-6/tâche-7, migration de format)** : migration au format canonique du dépôt source (statut inline, sans frontmatter YAML), tirets cadratins convertis. Le principe « les plans vivent dans des fichiers » demeure ; il est désormais porté par `CONSTITUTION.md` (« Interface de travail : fichiers, pas conversation ») et par `skl-003-plan-de-travail`, sans l'appareillage YAML retiré par PLN-003.

## Intention

Clarifier et forcer dans le harnais que :
1. tout plan proposé par l'agent est écrit dans un fichier `.dev/plans/PLN-<SEQ>-<SLUG>.md` ;
2. la réponse textuelle de l'agent référence le plan (chemin du fichier) sans reproduire son contenu en stdout.

## Contexte

Le système de travail du dépôt repose sur des fichiers markdown versionnés. L'interface input/output **est** des fichiers, pas des échanges conversationnels. La tâche 3 avait produit un plan dans un fichier (correct), mais la réponse en résumait aussi le contenu en stdout, brouillant la source de vérité. La règle : le plan vit dans le fichier ; stdout n'en est qu'une référence.

## Objections de l'agent IA

### [OBJECTION-1] Risque d'UX confuse avec réponses très brèves

**Statut : LEVÉE.** Paradigme documentaire accepté : l'humain lit les fichiers. La réponse textuelle se limite à l'indication du plan créé, son chemin, un résumé d'une phrase, et une invitation à lire le fichier.

### [OBJECTION-2] Ambiguïté sur la séquence des plans

**Statut : LEVÉE.** Numérotation séquentielle avec incrément +1 (PLN-001 -> PLN-002). La convention de statut précisée à la tâche 5 a ensuite été remplacée par le vocabulaire de la source à la tâche 7 (voir PLN-003).

### [OBJECTION-3] Besoin d'éclaircir le lien session.md vers PLN

**Statut : LEVÉE.** La traçabilité session-tâche a été précisée à la tâche 5 via un frontmatter dédié, puis abandonnée à la tâche 7 au profit du format source (sans frontmatter), sur décision de l'humain (voir PLN-003, OBJECTION-1).

## Travail effectué

1. Modification de `CLAUDE.md` : section sur l'interface fichiers et réponse textuelle réduite.
2. Modification de `CONSTITUTION.md` : section « Interface de travail : fichiers, pas conversation ».
3. Logs produits pour les tâches 3, 4, 5.

Ces modifications ont ensuite été révisées par PLN-003 (tâche 7) pour s'aligner sur le dépôt source.

## Note sur les objections humaines

Conformément à la gouvernance, les objections de l'humain sur ce plan ne sont pas consignées ici mais dans `.dev/session.md`.
