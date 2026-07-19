# ADR-003 - Gestion des bogues et ressource BUG

- **Statut** : Accepté
- **Date** : 2026-07-10
- **Décideurs** : Jérémy Viau-Trudel (humain), agent IA
- **Sources** : tâche 13 de `session.md`, `BUG-001-aucun-log-produit`

## Contexte

Des comportements incorrects de l'agent surviennent (ex. tâche 13 : aucun log produit à la tâche 12 alors que la journalisation est obligatoire). Jusqu'ici, un bogue était rapporté de façon informelle dans `session.md` et corrigé sans trace structurée du symptôme, du diagnostic et de la solution. Il manque une ressource dédiée qui capture le cycle de vie d'un bogue et un skill pour la produire.

## Décision (résumé)

> On crée un type de ressource livrable **BUG** (`.dev/bugs/BUG-<SEQ>-<SLUG>.md`), un **document vivant** qui consigne un bogue sur son cycle de vie : rapport (symptôme, attendu vs observé), diagnostic (cause racine), solution appliquée (correctif, fichiers touchés), vérification. Sa production est encadrée par `skl-013-rapport-de-bogue`. Un bogue suit le statut `ouvert -> diagnostiqué -> résolu -> fermé`.

## Décisions détaillées

### Nature et cycle de vie du BUG

- **Décision** : BUG est un **document vivant** (catégorie 2 de la typologie par cycle de vie, tâche 12) : il évolue du rapport initial jusqu'à la résolution, en accumulant diagnostic et solution. Statuts : `ouvert`, `diagnostiqué`, `résolu`, `fermé`.
- *Alternatives écartées* :
  - consigner le bogue seulement dans `session.md` : rejeté, `session.md` est en édition humaine uniquement et n'offre pas de structure diagnostic/solution ni de trace réutilisable ;
  - traiter le bogue comme un simple log : rejeté, le log est une trace immuable d'une tâche (catégorie 1), pas un suivi vivant de résolution.

### Emplacement et nomenclature

- **Décision** : `.dev/bugs/BUG-<SEQ>-<SLUG>.md`, suivant la nomenclature `.dev/<type>/<PREFIX>-<SEQ>-<SLUG>.md`.

### Articulation avec la journalisation

- **Décision** : rapporter, diagnostiquer et résoudre un bogue reste **une tâche** : elle produit donc un log dans `logs/ia-output/` comme toute tâche (voir `skl-008`). Le BUG documente le fond du bogue ; le log documente l'intervention de la tâche.

### Lien avec la correction du harnais

- **Décision** : quand un bogue révèle une lacune du harnais (comme BUG-001), la solution inclut l'amendement des fichiers de harnais concernés, tracé dans la section « Solution appliquée » du BUG.

### Non-respect d'un principe de conception (amendement, tâche 19)

- **Décision** : le **non-respect d'un principe de conception** (ressource `PDC`, voir `ADR-008-ressource-principe-de-conception`) **est un bogue** au sens de cette ADR. Les **critères de conformité** d'un `PDC` définissent ce qu'est un respect ; un écart avéré d'un élément du système (harnais, `clia`, document de conception, livrable) à un principe se consigne, se diagnostique et se corrige via une ressource `BUG` (`skl-013`). Justification : un principe de conception ne vaut que s'il est respecté universellement ; un écart érode l'intégrité conceptuelle du système (voir `FND-2026-07-18-principes-de-conception-systemes-complexes`), c'est donc un défaut à traiter comme tel. Le rapport du `BUG` référence le `PDC` enfreint et le critère de conformité violé.

## Conséquences

**Positives**
- Les bogues gagnent une trace structurée et réutilisable (symptôme, cause, correctif).
- Distinction nette entre le suivi vivant d'un bogue (BUG) et la trace immuable d'une tâche (log).
- Base pour mesurer les récurrences et les causes systémiques.

**Négatives / risques**
- Un type de plus à maintenir.
- Risque de recouvrement avec les plans (PLN) si un bogue exige une intervention lourde ; règle : un BUG documente le bogue, un PLN cadre une intervention complexe si nécessaire.

## Migration / porte de sortie

Premier jet. Si l'usage montre que BUG et PLN se recouvrent trop pour les correctifs lourds, un ADR ultérieur clarifiera leur frontière. Le mécanisme de versionnage du document vivant BUG suivra la convention arrêtée par le plan de versionnage (PLN-005) une fois approuvé.

## Références

- `skl-013-rapport-de-bogue` (skill de production)
- `BUG-001-aucun-log-produit` (premier BUG)
- `skl-008-log-ia-output` (journalisation, distincte)
- `PLN-005-typologie-versionnage-ressources` (typologie et versionnage, en cours)
