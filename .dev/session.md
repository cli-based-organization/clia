---
start-at: 2026-07-31T15:46:08-04:00
---

# Intention

Nettoyer et refactorer pour la version 0.1.0

- Définir fonctionnalités de coeur et fonctionalités étendues
- Inspecter et corriger tous les ADR
- S'assurer d'un comportement correcte de clia dans les principaux cas d'usage
- Extensibilité démontrée


# Contexte

Depuis 1 an, nous étudions l'usage de l'IA avec harness. Nous avons convergé vers une méthodologie.

Actuellement, nous pouvons l'utiliser minimalement dans n'importe quel repo, cependant nous n'avons pas une version stable.

La présente session de travail cherche à stabiliser une version 0.1.0 qui soit présentable publiquement

# Tâches

## 1. [bogue] Identifier le contexte-répertoire de clia

Nous avions demandé de reproduire le comportement du cli tda. Mais une fonctionnalité est manquante. => prendre en compte le contexte-répertoire du cli.

La configuration (repo-root, dev-dir, logs-dir, session-dir, session-file, template, ressources, version-file) doivent être déterminés à l'exécution et tenir compte du répertoire où clia est lancé.

Comportement problématique => actuellement, peut importe le répertoire de lancement de clia, le repo de référence est ~/cli-based-organisation/clia. 

Comportement attendu => lorsque l'exécution de clia a lieu dans un repo clia-valide: 
- seul le cli-root et les templates pointe vers cli-based-organization/clia
- le reste devrait pointer vers le repo clia-valide

Ouvrir un bogue.
Expliquer pourquoi ça a été implémenté comme ça. Dire quels composants du code est impacté/responsable. Et proposer un plan de rémédiation.

Ne pas implémenter le plan