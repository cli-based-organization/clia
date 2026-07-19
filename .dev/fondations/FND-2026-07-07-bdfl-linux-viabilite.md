# FND-2026-07-07 - Le *Benevolent Dictatorship* de Linux : viabilité à long terme, état des lieux

**Statut : complété**
**Date : 2026-07-07**
**Provenance** : rapatriée depuis `noumanity-formation/intentional-doers-governance/.dev/fondations/FND-002-bdfl-linux-viabilite.md` (tâche 16). Le corps conserve ses références d'origine (argumentaire de recherche de ce dépôt-là), historiques et propres à `intentional-doers-governance`.
**Objectif** : vérifier empiriquement l'affirmation de l'argumentaire de la recherche (session.md, tâche 13) selon laquelle « la structure de gouvernance de Linux (Benevolent Dictatorship) met en péril la viabilité à long terme de Linux ».

## Note de rigueur

Recherche web ciblée (juillet 2026), sources primaires et secondaires de la presse spécialisée (The Register, Phoronix, LWN.net, heise.de), un document officiel du projet (le commit de succession lui-même n'a pas été consulté directement, seulement des comptes-rendus journalistiques convergents), et un ensemble de synthèses généralistes sur le modèle BDFL. Aucune source académique évaluée par les pairs traitant spécifiquement du cas Linux n'a été trouvée dans le temps imparti à cette recherche ; les affirmations sur le risque général du modèle BDFL (« bottleneck », absence de garde-fous) proviennent de sources de vulgarisation technique (Search Engine Journal, CMSWire, Grokipedia, OSS Watch), pas de littérature scientifique. Ce document doit donc être lu comme un état des lieux journalistique et documentaire solide, pas comme une synthèse académique. Ne remplace pas une revue de littérature en sciences des organisations sur le sujet, qui reste à faire si le rapport final l'exige.

## Cadrage / Thèse

Question de recherche : existe-t-il des preuves documentées que le modèle BDFL de Linus Torvalds pose un risque réel et actuel pour la viabilité à long terme du noyau Linux ? Périmètre : Linux spécifiquement (gouvernance du noyau, pas de l'écosystème Linux au sens large), avec un cadre de comparaison transversal sur la transition de gouvernance de Python (retrait de Guido van Rossum comme BDFL en 2018) et une mention du cas WordPress (2024-2025) comme second point de comparaison sur les dérives possibles du modèle.

## 1. Plan de succession

**Constat central, et le plus significatif de cette recherche : un plan de succession formel existe désormais, mais il est extrêmement récent.**

En 2025, lors du Linux Kernel Maintainer Summit à Tokyo, le mainteneur Dan Williams (Intel) a rédigé le « Linux kernel project continuity » document, signé par Linus Torvalds lui-même dans un commit officiel. C'est le **premier processus de succession formel dans les plus de 30 ans d'histoire du projet**. Le mécanisme (surnommé le « Conclave ») : en cas d'indisponibilité de Torvalds, l'organisateur du dernier Maintainer Summit ou le président du Technical Advisory Board (TAB) de la Linux Foundation dispose de 72 heures pour convoquer les participants du dernier sommet et les membres du TAB, avec deux semaines pour communiquer une décision à la communauté. Le document ne désigne pas de successeur unique ; Greg Kroah-Hartman (mainteneur de la branche stable, membre du TAB) est cité comme le successeur intérimaire le plus probable, mais l'option d'un modèle de conseil collégial reste ouverte.

Point important pour l'évaluation du risque : les sources convergent pour dire que cette démarche est **préventive et non motivée par une crise immédiate** — Torvalds (56 ans) reste pleinement actif. Mais le fait qu'il ait fallu 30+ ans avant qu'un tel plan existe constitue en soi une donnée : pendant l'essentiel de l'histoire du noyau, **aucun mécanisme de continuité n'était documenté**, ce qui correspond à un point de défaillance unique non couvert pendant l'essentiel de la vie du projet. Le fait que la communauté ait jugé utile de formaliser un plan maintenant, sans crise déclenchante, peut se lire soit comme un signe de maturité rassurant, soit comme la reconnaissance tardive et implicite d'un risque réel jusque-là seulement toléré.

## 2. Tensions de gouvernance récentes

Le modèle BDFL de Linux a produit des tensions documentées et récentes, avec des conséquences concrètes (départs de contributeurs) :

- **Wedson Almeida Filho (août 2024)**, qui pilotait le projet « Rust for Linux », a démissionné en invoquant le manque d'énergie face à des « nontechnical nonsense » et des conflits avec d'autres développeurs du noyau (dont Ted Ts'o, mainteneur d'ext4), après avoir essuyé une opposition marquée lors d'un Linux Kernel Summit.
- **Hector Martin (février 2025)**, chef de projet d'Asahi Linux, a démissionné de son rôle de mainteneur amont après un échange tendu avec Linus Torvalds sur la liste de diffusion, Torvalds l'ayant critiqué pour du « social media brigading » ; Martin cite explicitement l'épuisement et la gestion de Torvalds du dossier Rust comme facteurs de son départ.

Ces deux cas montrent que le style de gouvernance directe, personnalisé et parfois conflictuel propre au BDFL a un **coût réel et actuel**, spécifiquement sur le dossier Rust (perçu comme un test de la capacité du noyau à intégrer un changement technique majeur sous ce modèle de gouvernance). Ce n'est pas une menace hypothétique : c'est une friction déjà matérialisée en départs de contributeurs clés sur un chantier stratégique pour l'avenir du noyau. Cela dit, il n'y a pas de preuve que ces tensions aient mis en cause la **viabilité globale** du projet (le rythme de développement du noyau ne semble pas affecté), seulement la vitesse et le climat d'intégration d'un sous-projet spécifique.

## 3. Rôle structurel de la Linux Foundation

La Linux Foundation ne gouverne pas les décisions techniques du noyau (c'est le rôle de Torvalds et des mainteneurs de sous-systèmes), mais son Technical Advisory Board (TAB) est désormais formellement intégré au mécanisme de succession (le « Conclave »). Greg Kroah-Hartman, Fellow de la Linux Foundation et membre du TAB, joue un rôle de continuité de fait (il a déjà agi comme mainteneur suppléant par le passé). La fondation atténue donc partiellement le risque de point de défaillance unique, mais seulement depuis l'adoption du plan de continuité en 2025 — pas structurellement depuis l'origine.

## 4. Comparaison : la transition BDFL de Python, et le cas WordPress

**Python (2018)** est le cas de comparaison le plus direct : Guido van Rossum a démissionné de son rôle de BDFL en juillet 2018, dans un contexte de tensions autour de PEP 572 (l'opérateur *walrus*). La transition vers un nouveau modèle de gouvernance (conseil de pilotage à cinq membres, formalisé par PEP 8016/PEP 13) a pris plusieurs mois, durant lesquels **les décisions PEP majeures ont été essentiellement gelées** (de juillet 2018 à début 2019), produisant un arriéré de plus de 30 PEP en attente. Ce cas démontre un coût réel et mesurable de la transition **hors** du modèle BDFL, pas une preuve que le maintien du modèle BDFL est en soi dangereux — mais il montre que le jour où Linux devra effectivement gérer une succession, une période de flottement est un risque concret et précédenté, pas une hypothèse abstraite.

**WordPress (2024-2025)** est cité dans plusieurs synthèses généralistes comme un exemple de dérive du modèle BDFL vers ce qu'une source qualifie de « pipeline BDFL vers l'autoritarisme » : le conflit entre Matt Mullenweg (fondateur, BDFL de WordPress) et l'hébergeur WP Engine a mis en lumière l'absence de garde-fous formels dans ce modèle de gouvernance lorsque le détenteur de l'autorité agit unilatéralement. Ce cas n'est pas celui de Linux, mais il illustre, dans le même registre de gouvernance (BDFL d'un projet open source majeur), un mode de défaillance documenté du modèle : pas la lenteur ou le blocage, mais l'absence de recours face à une décision unilatérale contestée.

## Synthèse

La question posée était : l'affirmation « le BDFL met en péril la viabilité à long terme de Linux » tient-elle, en tout ou en partie ?

**Réponse nuancée : l'affirmation est trop forte et trop alarmiste dans sa formulation actuelle, mais elle n'est pas sans fondement — le niveau de preuve est faible à modéré, pas absent.**

- Il n'existe **aucune preuve d'un péril actuel et imminent** pour la viabilité du noyau : le rythme de développement reste soutenu, un plan de succession existe désormais, et rien n'indique une crise en cours.
- En revanche, il existe des **preuves documentées et récentes (2024-2025) de coûts réels** attribuables spécifiquement au style de gouvernance BDFL de Torvalds : deux départs de contributeurs clés sur le dossier stratégique Rust, largement attribués à sa gestion des désaccords.
- Il existe une **preuve structurelle indirecte** : l'absence de tout mécanisme de continuité formel pendant plus de 30 ans, comblée seulement en 2025, et le cas de comparaison Python montre qu'une transition de gouvernance BDFL, quand elle survient, a un coût réel et documenté (gel de plusieurs mois des décisions majeures).
- Le cas WordPress illustre, sur un projet comparable, qu'un mode de défaillance du BDFL (décision unilatérale sans recours) est documenté ailleurs dans l'écosystème open source, ce qui rend l'inquiétude générale sur le modèle **plausible par analogie**, sans constituer une preuve directe pour Linux.

**Conclusion pour le rapport final** : l'argumentaire ne peut pas affirmer un péril établi sans nuance. Il peut en revanche affirmer, avec un niveau de preuve raisonnable, que le modèle BDFL de Linux a produit des **coûts de gouvernance réels et récents** (frictions, départs de contributeurs) et repose depuis l'origine sur un **point de défaillance unique resté sans plan de continuité pendant l'essentiel de l'histoire du projet** — deux constats bien plus défendables et sourcés que l'affirmation initiale d'un péril pour la « viabilité à long terme ».

## Limites

- Recherche menée en juillet 2026 ; le sujet (succession, tensions Rust) est en évolution active, à revalider si le rapport final est rédigé plusieurs mois plus tard.
- Aucune source académique évaluée par les pairs consultée spécifiquement sur le cas Linux ; les affirmations générales sur les risques du modèle BDFL proviennent de sources de vulgarisation, pas de recherche scientifique publiée.
- N'a pas investigué en détail l'épisode du Code of Conduct de 2018 (retrait temporaire de Torvalds) au-delà de ce qui est notoire ; une recherche dédiée à cet épisode renforcerait ou nuancerait la section 2.
- Le cas WordPress est utilisé par analogie de modèle de gouvernance, pas comme preuve directe concernant Linux ; à ne pas présenter comme équivalent dans le rapport final.

## Sources

- [Linux Kernel Community Establishes Formal Succession Plan for Life After Linus Torvalds - BigGo News](https://biggo.com/news/202601282221_linux-kernel-succession-plan-linus-torvalds)
- [What Happens to Linux After Linus Torvalds? We Finally Have the Answer to This Uncomfortable Question - It's FOSS](https://itsfoss.com/news/linux-kernel-continuity-plan/)
- [The Linux kernel now has a succession plan for when Linus Torvalds checks out - PC Gamer](https://www.pcgamer.com/gaming-industry/the-linux-kernel-now-has-a-succession-plan-for-when-linus-torvalds-checks-out-which-emerged-after-an-apparently-uplifting-discussion-about-our-eventual-march-toward-death/)
- [Kernel Community Drafts a Plan For Replacing Linus Torvalds - Slashdot](https://linux.slashdot.org/story/26/01/28/2253239/kernel-community-drafts-a-plan-for-replacing-linus-torvalds)
- [Missing Link: How Linux would continue without Linus Torvalds - heise online](https://www.heise.de/en/background/Missing-Link-How-Linux-would-continue-without-Linus-Torvalds-11070718.html)
- [Rust for Linux maintainer steps down in frustration - The Register](https://www.theregister.com/2024/09/02/rust_for_linux_maintainer_steps_down/)
- [One Of The Rust Linux Kernel Maintainers Steps Down - Cites "Nontechnical Nonsense" - Phoronix](https://www.phoronix.com/news/Rust-Linux-Maintainer-Step-Down)
- [Asahi Linux head quits, citing kernel leadership failure - The Register](https://www.theregister.com/2025/02/13/ashai_linux_head_quits/)
- [Leadership - Linux Foundation](https://www.linuxfoundation.org/about/leadership)
- [Python after Guido BDFL, the future of the governance of python - Hervé Beraud, Medium](https://medium.com/@herveberaud.pro/python-after-guido-bdfl-the-future-of-the-governance-of-python-2969bab19c7e)
- [Guido van Rossum resigns as Python leader - LWN.net](https://lwn.net/Articles/759654/)
- [Python post-Guido - LWN.net](https://lwn.net/Articles/759756/)
- [Guido van Rossum Stepping Down from Role as Python's Benevolent Dictator For Life - Linux Journal](https://www.linuxjournal.com/content/guido-van-rossum-stepping-down-role-pythons-benevolent-dictator-life)
- [Why Open Source Projects Are Run By Benevolent Dictators For Life - Search Engine Journal](https://www.searchenginejournal.com/why-open-source-projects-are-run-by-benevolent-dictators-for-life/568532/)
- [Is the End of the Benevolent Dictator for Life in Open-Source Software Here? - CMSWire](https://www.cmswire.com/information-management/is-the-end-of-the-benevolent-dictator-for-life-in-open-source-software-here/)
- [Benevolent dictator for life - Wikipedia](https://en.wikipedia.org/wiki/Benevolent_dictator_for_life)
