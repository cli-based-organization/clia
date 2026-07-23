---
type: principe
version: 0.1.0
title: "N'employer l'IA que lorsque c'est nécessaire ; automatiser le reste"
status: accepté
date: 2026-07-18
---

# PDC-002 - N'employer l'IA que lorsque c'est nécessaire ; automatiser le reste


## Énoncé

L'IA n'est employée que pour les tâches exigeant jugement, langage naturel ou généralisation ; tout ce qui est spécifiable et vérifiable est automatisé (confié à `clia`) ou opéré par l'humain.

## Justification

L'IA est variable, coûteuse et faillible ; le déterministe est reproductible, gratuit et sûr (`FND-010-capacites-modeles-ia-usage`). Réserver l'IA à ce qui l'exige maximise fiabilité et intégrité, et minimise coût et surface d'erreur.

## Portée

La répartition des tâches entre l'humain, `clia` (déterministe) et l'agent IA. S'applique à toute nouvelle capacité du système.

## Implications

- Impose de déplacer vers `clia` les mécaniques spécifiables et vérifiables (versionnage, numérotation, gabarits, validation).
- Interdit de confier à l'IA une tâche que le déterminisme réaliserait de façon sûre et reproductible.
- Impose de justifier, pour toute capacité, pourquoi elle relève de l'IA plutôt que de l'automatisation.

## Critères de conformité

- Aucune tâche purement spécifiable/vérifiable n'est portée par l'agent IA quand `clia` pourrait la réaliser.
- Toute production porteuse de jugement (plans, conception, analyses) reste du ressort de l'IA.
- Un écart avéré (l'agent porte une mécanique déterministe automatisable) est un bogue au sens de `ADR-003`.

## Tensions

- Avec `PDC-009` (versionnage atomique) : le versionnage est aujourd'hui réalisé manuellement par l'agent, ce qui enfreint partiellement ce principe (voir bogue associé).
- Avec la simplicité (KISS) : automatiser demande un effort ; l'arbitrage se fait au cas par cas.

## Références

- `ADR-007-architecture-systeme-augmentation`, `FND-010-capacites-modeles-ia-usage`
- `ANL-012-usage-ia-projet`, `ANL-010-principes-de-conception-du-repo` (P2)
