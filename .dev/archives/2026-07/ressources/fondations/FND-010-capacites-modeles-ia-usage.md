---
type: fondation
version: 0.1.0
title: "Capacités des modèles d'IA et raison d'usage"
status: actif
date: 2026-07-18
---

# FND-010 - Capacités des modèles d'IA et raison d'usage

- **Objectif** : établir une base factuelle et sourcée sur ce que les modèles de langage savent faire (en particulier les modèles Claude Haiku, Sonnet et Opus), sur ce qu'un modèle peut faire qu'un programme sans IA ne peut pas (et inversement), et sur ce qui a rendu l'IA si productive. Sert de référence pour décider **quand** recourir à l'IA plutôt qu'à l'automatisation déterministe.

## Note de rigueur

Fondation appuyée sur des sources primaires (documentation officielle des modèles Claude via `platform.claude.com` et les annonces Anthropic ; littérature académique sur les capacités émergentes et l'apprentissage en contexte) et sur des sources secondaires de synthèse (benchmarks comparatifs). Les faits sur les **modèles** (versions, prix, scores de benchmark) sont périssables et datés au 2026-07-18 ; les principes sur les **capacités** des LLM (apprentissage en contexte, généralisation, non-déterminisme) sont plus stables. Les affirmations normatives sont rattachées à leur source. Recherche menée le 2026-07-18.

## Cadrage

**Question** : que peut faire un modèle d'IA, qu'un programme déterministe ne peut pas, et à quel moment ce surcroît de capacité justifie-t-il d'employer l'IA plutôt que d'automatiser ?

**Périmètre** : les grands modèles de langage (LLM) génératifs et leurs capacités opérationnelles, avec un focus sur la famille Claude. Hors périmètre : l'architecture interne des modèles, l'entraînement, et les détails d'API (voir le skill `claude-api`).

**Définitions** :
- **Modèle de langage (LLM)** : modèle génératif entraîné à prédire du texte, capable de produire et transformer du langage naturel et du code.
- **Apprentissage en contexte (in-context learning)** : capacité à réaliser une tâche nouvelle à partir d'instructions et/ou d'exemples fournis dans l'invite, **sans modifier les poids** du modèle.
- **Programme déterministe** : logiciel dont les mêmes entrées produisent toujours les mêmes sorties, sans heuristique (au sens où `clia` est déterministe, voir `ADR-007`).

## 1. Capacités fondamentales des LLM

- **Généralisation à des tâches non explicitement entraînées.** Les LLM présentent des « capacités émergentes » : de bonnes performances sur des tâches variées pour lesquelles ils n'ont pas été spécifiquement entraînés, y compris des tâches de raisonnement (voir Sources : survey des capacités émergentes ; travaux ACL 2024).
- **Apprentissage en contexte (zero-shot / few-shot).** Le modèle réalise une tâche à partir d'une description ou de quelques exemples dans l'invite, sans réentraînement ni changement de code. C'est l'une des capacités émergentes les plus étudiées et la plus distinctive vis-à-vis des paradigmes classiques, qui exigent des mises à jour de paramètres par gradient.
- **Compréhension et génération de langage naturel.** Interprétation d'entrées non structurées et ambiguës (texte libre, code, documents) et production de sorties en langage naturel ou en code.
- **Raisonnement multi-étapes et « effort » réglable.** Les modèles récents raisonnent avant de répondre ; l'effort/la profondeur de réflexion se règle (compromis intelligence / latence / coût).
- **Usage d'outils et agentivité.** Au-delà de répondre, un modèle peut décider d'appeler des outils, d'agir en boucle (agent), de manipuler des fichiers, de chercher de l'information : il passe de « répondre » à « accomplir ».

**Nuance de rigueur** : un débat subsiste sur le caractère réellement « émergent » de ces capacités ; certains travaux les attribuent à une combinaison d'apprentissage en contexte, de mémoire du modèle et de connaissance linguistique (voir Sources). Cela ne change pas leur portée opérationnelle, mais invite à ne pas les mythifier.

## 2. Ce qu'un modèle fait, qu'un programme déterministe ne peut pas (et inversement)

**Ce que l'IA apporte, qu'un programme classique ne sait pas faire sans être reprogrammé :**

- **Traiter l'ambiguïté et le non-structuré.** Un programme déterministe exige des entrées structurées et des règles explicites ; un LLM absorbe du texte libre, incomplet ou ambigu, et en tire du sens.
- **Généraliser sans règles écrites.** Là où automatiser suppose d'énumérer les cas, le modèle traite la « longue traîne » de cas non prévus par apprentissage en contexte.
- **Exercer du jugement et synthétiser.** Comparer, hiérarchiser, arbitrer, rédiger une décision argumentée : des opérations sémantiques hors de portée d'un algorithme fixe.
- **Produire du contenu nouveau.** Plans, spécifications, analyses, code : de la création, pas seulement de la transformation déterministe.
- **S'adapter par l'invite, pas par le code.** Changer de comportement se fait en langage naturel, sans cycle de développement.

**Ce qu'un programme déterministe fait mieux que l'IA (et pourquoi il reste irremplaçable) :**

- **Déterminisme et reproductibilité.** Mêmes entrées, mêmes sorties, garanties ; un LLM est intrinsèquement variable.
- **Exactitude et absence d'affabulation.** Pas d'hallucination, pas d'invention ; le résultat est vérifiable et auditable ligne à ligne.
- **Coût, latence, échelle.** Une opération scriptée est quasi gratuite et instantanée face à un appel de modèle.
- **Intégrité et sûreté des opérations irréversibles.** Déplacer/renommer des fichiers, valider un format, allouer un numéro de séquence : à confier au déterministe, où toute « improvisation » serait un risque.

**Corollaire** : IA et automatisation ne sont pas concurrentes mais complémentaires. Le bon découpage confie au déterministe tout ce qui est spécifiable et vérifiable, et réserve l'IA à ce qui exige jugement, langage naturel ou généralisation.

## 3. Ce qui a rendu l'IA productive et indispensable

- **La généralité.** Un même modèle couvre une multitude de tâches sans logiciel dédié par tâche : l'économie de développement est massive.
- **L'apprentissage en contexte.** Adapter le comportement par l'invite, sans réentraînement ni redéploiement, effondre le coût d'itération.
- **L'interface en langage naturel.** Le barrière d'entrée tombe : décrire l'intention suffit, plus besoin de coder chaque automatisation.
- **L'agentivité outillée.** Les modèles n'aident plus seulement à penser, ils exécutent des chaînes d'actions (lire, écrire, chercher, tester), automatisant du travail cognitif de bout en bout.
- **La couverture de la longue traîne.** Le travail non structuré et non répétable, longtemps rétif à l'automatisation classique, devient adressable.

## 4. Les modèles Claude : Haiku, Sonnet, Opus

Trois paliers, un compromis intelligence / vitesse / coût (source : documentation des modèles Claude et annonces Anthropic, 2026-07-18) :

- **Opus (palier « intelligence premium »)** : le plus capable, pour le codage agentique complexe, le raisonnement scientifique de haut niveau et les workflows agentiques exigeant un raisonnement multi-étapes profond. Modèle courant : **Opus 4.8** (`claude-opus-4-8`), fenêtre de contexte 1M, tarif indicatif 5 $/25 $ par million de tokens (entrée/sortie). Repères publics : SWE-bench Pro ~69 %, GPQA Diamond ~91 %, meilleur modèle d'usage ordinateur/navigateur testé (~84 % Online-Mind2Web).
- **Sonnet (palier « production équilibré »)** : le meilleur rapport vitesse/intelligence pour la majorité du travail agentique, l'outillage et le travail de connaissance ; comble une grande part de l'écart avec Opus. Modèle courant : **Sonnet 5** (`claude-sonnet-5`), contexte 1M, tarif indicatif 3 $/15 $ par million de tokens (offre d'introduction 2 $/10 $ jusqu'au 2026-08-31). Repères : SWE-bench Pro ~63 %, OSWorld-Verified ~81 %.
- **Haiku (palier « rapide et économique »)** : pour les appels à fort volume et sensibles à la latence, les tâches simples (classification, extraction courte). Modèle courant : **Haiku 4.5** (`claude-haiku-4-5`), contexte 200K, tarif indicatif 1 $/5 $ par million de tokens.

**Règle de sélection** (source : documentation Anthropic) : réserver Opus aux tâches critiques en exactitude et au raisonnement agentique le plus exigeant ; router l'essentiel du travail agentique et de connaissance vers Sonnet ; garder Haiku pour le volume et la latence. Autrement dit, le choix du palier est lui-même un arbitrage capacité / coût, à l'image du choix IA vs automatisation.

## 5. Application : quand recourir à l'IA plutôt qu'automatiser

De ce qui précède se dégage un critère opérationnel. Recourir à l'IA quand **au moins un** des traits suivants est présent :

- entrée **non structurée ou ambiguë** (langage naturel, intention à interpréter) ;
- besoin de **jugement, de synthèse ou de création** (arbitrer, rédiger, concevoir) ;
- **généralisation** à des cas non énumérables d'avance.

Automatiser (déterministe) dès que la tâche est **spécifiable et vérifiable** : règles explicites, entrées structurées, sorties contrôlables, opérations à garantir (intégrité, séquence, format, versionnage). Le déterministe y est plus sûr, moins cher, reproductible et auditable.

Un critère décisionnel de la littérature agentique complète ce partage : n'employer un agent IA que si la tâche est **multi-étapes et difficile à spécifier d'avance**, si la **valeur** justifie le surcoût, si le modèle en est **capable**, et si le **coût d'une erreur** est récupérable (tests, revue, retour arrière). Sinon, rester au palier le plus simple, jusqu'à l'automatisation pure.

## Synthèse

Les LLM apportent une capacité qu'aucun programme déterministe n'égale : traiter l'ambiguïté et le langage naturel, généraliser sans règles écrites via l'apprentissage en contexte, exercer du jugement et créer du contenu, et agir en boucle outillée. Ces propriétés, jointes à la généralité et à l'interface en langage naturel, expliquent leur productivité et leur caractère indispensable. Mais elles s'accompagnent d'un coût structurel : variabilité, hallucination possible, prix et latence. Le déterministe reste supérieur pour tout ce qui est spécifiable et vérifiable (exactitude, reproductibilité, intégrité, coût). La conséquence pratique, valable pour le choix IA/automatisation comme pour le choix du palier de modèle (Haiku/Sonnet/Opus), est un arbitrage explicite : n'employer l'IA (et le palier le plus puissant) que là où sa capacité est **nécessaire**, et automatiser tout le reste.

## Limites

- Panorama des modèles daté (2026-07-18) : versions, prix et benchmarks évoluent vite.
- Les scores de benchmark cités sont indicatifs et dépendent des protocoles ; à revalider à la source.
- La fondation ne couvre pas la sécurité, l'alignement, ni les biais des modèles, qui conditionnent aussi l'opportunité de recourir à l'IA.
- Le débat sur la nature des capacités « émergentes » n'est pas tranché ; la fondation retient leur portée opérationnelle, pas une thèse théorique.

## Sources

- Documentation des modèles Claude (paliers, IDs, contexte, tarifs) : https://platform.claude.com/docs/en/about-claude/models/overview
- Anthropic, annonce Claude Opus 4.8 : https://www.anthropic.com/news/claude-opus-4-8
- Anthropic, annonce Claude Sonnet 5 : https://www.anthropic.com/news/claude-sonnet-5
- Benchmarks comparatifs Claude (2026) : https://www.morphllm.com/claude-benchmarks
- Comparatif agentic coding Sonnet 5 / Opus 4.8 (MarkTechPost, 2026) : https://www.marktechpost.com/2026/07/13/anthropic-claude-sonnet-5-vs-sonnet-4-6-vs-opus-4-8-agentic-coding-benchmarks-api-pricing-and-cost-performance-tradeoffs-compared/
- « Are Emergent Abilities in Large Language Models just In-Context Learning? » (ACL 2024) : https://aclanthology.org/2024.acl-long.279/
- « Emergent Abilities in Large Language Models: A Survey » (arXiv) : https://arxiv.org/pdf/2503.05788
- Article de référence sur les capacités émergentes et l'apprentissage en contexte (arXiv 2309.01809) : https://arxiv.org/abs/2309.01809
