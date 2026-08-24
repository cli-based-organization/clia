---
type: bug
version: 0.1.0
title: "L'agent porte des mécaniques déterministes automatisables (écart à PDC-002)"
status: diagnostiqué
---

# BUG-002 - L'agent porte des mécaniques déterministes automatisables (écart à PDC-002)

- **Date de rapport** : 2026-07-18
- **Origine** : session.md tâche 21 (généré depuis `ANL-010-principes-de-conception-du-repo`, P2)
- **Tâche liée** : `.dev/logs/ia-output/LOG-2026-07-17-task-21.md`

## Rapport

Symptôme : l'agent IA réalise « à la main » des opérations entièrement spécifiables et vérifiables (versionnage atomique de `.dev/ressources.yaml`, allocation des numéros de séquence, construction des noms datés, gabarits de logs et d'en-têtes).
Attendu (PDC-002) : ces mécaniques déterministes sont automatisées (confiées à `clia`) ; l'IA n'est employée que là où elle est nécessaire.
Observé : elles sont portées par l'agent à chaque tâche.
Contexte : constaté par `ANL-012-usage-ia-projet` (C3) puis formalisé comme écart à `PDC-002`.

## Diagnostic

Principe enfreint : `PDC-002` (« n'employer l'IA que si nécessaire ; automatiser le reste »). Critère de conformité violé : « aucune tâche purement spécifiable/vérifiable n'est portée par l'agent IA quand `clia` pourrait la réaliser ».
Cause immédiate : `clia` n'expose pas encore de commande pour ces opérations (bump de version, numérotation, gabarits).
Cause systémique : l'automatisation de ces mécaniques n'a pas été spécifiée ni implémentée ; le versionnage manuel est aussi une fragilité de `PDC-009`.

## Solution appliquée

Correctif non encore appliqué. Correctif prévu (recommandé par `ANL-012-usage-ia-projet`) : doter `clia` de commandes déterministes pour le versionnage atomique et la numérotation/nommage, et générer les squelettes déterministes par gabarit `clia`. Nécessite un plan et l'ordre séquentiel `ADR-007` (conception -> méthodologie -> implémentation).

## Vérification

Le bogue sera résolu quand `clia` réalisera le versionnage et la numérotation, vérifié par : `clia` bumpe atomiquement membre + ensemble sans intervention manuelle de l'agent, et alloue les séquences/noms de façon déterministe.

## Historique

- 2026-07-18 v0.1.0 : rapport et diagnostic (écart à PDC-002 identifié en tâche 21).
