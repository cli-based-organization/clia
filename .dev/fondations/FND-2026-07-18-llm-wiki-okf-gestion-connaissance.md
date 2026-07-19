# FND-2026-07-18 - LLM Wiki, Open Knowledge Format et gestion de la connaissance

- **Statut** : actif
- **Date** : 2026-07-18
- **Objectif** : établir une base factuelle et sourcée sur le pattern « LLM Wiki » (approche post-RAG), sur le **Google Open Knowledge Format (OKF)** qui le standardise, et plus largement sur la gestion et l'utilisation de la connaissance et les systèmes sémantiques et ontologiques. Sert de référence à l'analyse critique de `clia` et de ses ressources livrables documentaires face à l'OKF.

## Note de rigueur

Fondation appuyée sur une source primaire (le billet officiel Google Cloud annonçant l'OKF) et des sources secondaires de référence (MarkTechPost, comparatifs LLM Wiki vs RAG, littérature sur le web sémantique et les ontologies RDF/OWL/SPARQL). Le **source-material** fourni par l'humain (`.dev/source-material/poe.com/post-rag-llm-wiki.md`) est un échange assisté par IA : il a servi de point d'entrée et d'orientation, mais ses affirmations ont été **revérifiées** par recherche indépendante (blog Google Cloud, presse spécialisée) ; il n'est pas cité comme autorité factuelle. L'OKF est une spécification **v0.1 récente (12 juin 2026)** : les faits sont datés et périssables ; les principes de gestion de la connaissance (ontologies, graphes) sont plus stables. Recherche menée le 2026-07-18.

## Cadrage / Thèse

**Question** : qu'est-ce que le pattern LLM Wiki et l'OKF, où se situent-ils dans le paysage de la gestion de la connaissance et des systèmes sémantiques, et que standardisent-ils réellement ?

**Périmètre** : le pattern LLM Wiki (post-RAG), l'OKF v0.1, et leur place dans le spectre des approches de représentation de la connaissance (du markdown informel aux ontologies formelles). Hors périmètre : l'implémentation détaillée d'un pipeline RAG et les formalismes ontologiques au-delà de leur principe.

**Définitions** :
- **RAG (Retrieval-Augmented Generation)** : injecter dans le contexte d'un LLM des fragments récupérés par recherche (souvent vectorielle) dans une base documentaire.
- **LLM Wiki** : base de connaissances en markdown structuré, lue directement dans le contexte du LLM, sans récupération vectorielle.
- **OKF (Open Knowledge Format)** : spécification ouverte représentant la connaissance comme un répertoire de fichiers markdown à frontmatter YAML.
- **Ontologie / graphe de connaissances** : représentation formelle de concepts, relations et contraintes, permettant l'inférence machine (RDF, OWL).

## 1. Le pattern « LLM Wiki » (post-RAG)

Popularisé par Andrej Karpathy, le LLM Wiki est une **base de connaissances markdown structurée** conçue pour vivre directement dans la fenêtre de contexte d'un LLM. Au lieu d'une recherche sémantique qui remonte des fragments (RAG), un agent utilise une **couche de routage** (un fichier index, ou le jugement du LLM lui-même) pour charger directement les documents pertinents.

L'argument de fond, propre aux LLM : « les LLM ne s'ennuient pas, n'oublient pas de mettre à jour une référence croisée, et peuvent toucher quinze fichiers en une passe. Le travail de tenue à jour qui pousse les humains à abandonner leurs wikis est précisément ce que les LLM font bien. » Autrement dit, la maintenance qui condamnait les wikis humains devient un atout avec un agent.

Pourquoi « juste du markdown » suffit souvent : (a) les **fenêtres de contexte sont devenues larges** : pour une base petite à moyenne, tout tient dans le contexte, donc rien à récupérer ; (b) c'est **plus fiable** que la récupération : les échecs de RAG sont souvent silencieux (le système ne signale pas qu'il n'a pas trouvé le bon fragment). Pour de petites bases ciblées, l'économie de tokens revendiquée atteint jusqu'à 95 % par rapport au chargement naïf.

## 2. Post-RAG : cadre de décision

Le LLM Wiki n'est pas un remplacement universel du RAG. Le cadre admis :
- **LLM Wiki** favorisé par : périmètre restreint, contenu **structuré**, exigence de haute précision, besoin de **versionnage**, ressources d'ingénierie limitées.
- **RAG** reste pertinent pour de **grandes collections non structurées** où la recherche sémantique apporte une valeur réelle.
- **Hybride** courant : le wiki porte la connaissance fondamentale toujours disponible ; le RAG gère la longue traîne, volumineuse ou changeant vite.

Distinction essentielle : le RAG est un **système de recherche** (sans état, chaque requête indépendante) ; le LLM Wiki est un **système de connaissance** (concepts curés, versionnés, lus et mis à jour directement par l'agent).

## 3. Le Google Open Knowledge Format (OKF v0.1)

Annoncé par Google Cloud le **12 juin 2026**, l'OKF formalise le pattern LLM Wiki en un **format portable, neutre en fournisseur**, lisible par l'humain et parsable par un agent **sans SDK**.

Structure (volontairement minimaliste) :
- **Un répertoire de fichiers markdown à frontmatter YAML.** « Juste des fichiers » : livrable en tarball, hébergeable dans un dépôt git, montable sur tout système de fichiers. Pas de runtime, pas de SDK, pas de schéma de compression.
- **Un seul champ requis par concept : `type`.** Tout le reste est laissé au producteur. Champs réservés (optionnels) : `type`, `title`, `description`, `resource`, `tags`, `timestamp`.
- **Les liens forment un graphe** : les liens markdown normaux créent un graphe de connaissances ; la hiérarchie du système de fichiers donne les relations parent/enfant ; les liens croisés ajoutent des relations plus riches (jointures, dépendances, références). Un agent parcourt ce graphe pour construire son contexte.
- **Fichiers optionnels** : `index.md` (divulgation progressive, progressive disclosure) et `log.md` (historique des changements).
- **Séparation producteur / consommateur** : qui écrit la connaissance est distinct de qui la consomme ; des wikis de producteurs différents sont consommables par des agents différents sans traduction.
- **Implémentations de référence** : un agent d'enrichissement (parcourt un dataset BigQuery, rédige un document OKF par table, enrichit de citations/schémas), et un **visualiseur HTML statique** transformant un bundle OKF en vue graphe interactive dans un seul fichier autonome.

Point de maturité crucial (v0.1) : OKF fait avancer l'**interopérabilité structurelle** (des fichiers, des champs, des liens communs) mais laisse l'**interopérabilité sémantique** (le sens des `type`, des relations) aux producteurs, aux consommateurs et à des conventions futures. OKF « nomme une couche qui manquait » (un paquet de contexte portable), ce n'est pas une percée technique.

## 4. Gestion de la connaissance et systèmes sémantiques / ontologiques

L'OKF se situe au bas d'un **spectre de formalisation** de la connaissance :

- **Informel structuré** : markdown + frontmatter (LLM Wiki, OKF). Structure légère, sémantique implicite, lisible humain et LLM.
- **Métadonnées typées** : champs réservés, tags, types (OKF `type`). Interop structurelle.
- **Graphes de connaissances et ontologies formelles** : **RDF** (modèle en triplets sujet-prédicat-objet), **OWL** (classes, relations, contraintes logiques permettant l'**inférence** machine), **SPARQL** (langage de requête). Cette pile apporte ce que la récupération purement vectorielle n'a pas : **structure formelle, typage, contraintes et vérifiabilité**.

Tendances actuelles : les LLM servent de **co-modélisateurs** pour construire des ontologies et des graphes de connaissances (traduire des descriptions en langage naturel en OWL) ; inversement, les graphes et ontologies sont mobilisés pour **ancrer** les LLM (réduire l'hallucination, fournir provenance et justifications vérifiables). Le web sémantique fournit le socle (structure, sémantique, provenance) que les pipelines LLM, seuls, n'ont pas.

**Positionnement d'OKF** : il choisit délibérément le **bas du spectre** (markdown + `type`), pariant que pour la plupart des bases curées, la structure légère + le jugement du LLM suffisent, et que la sémantique formelle (ontologies) n'est nécessaire que pour l'inférence et la vérifiabilité à grande échelle. C'est un compromis **pragmatique** : maximiser l'adoption et la simplicité, différer la sémantique formelle.

## Synthèse

Le pattern **LLM Wiki** (post-RAG) stocke la connaissance en markdown structuré lu directement dans le contexte, exploitant les grandes fenêtres de contexte et la capacité des LLM à maintenir eux-mêmes un wiki curé ; il est plus fiable et moins coûteux que le RAG pour des bases petites à moyennes, structurées et versionnées, le RAG restant pertinent pour la grande longue traîne non structurée. Le **Google OKF (v0.1, juin 2026)** standardise ce pattern en un format neutre : un répertoire de markdown à frontmatter YAML dont le seul champ requis est `type`, les liens formant un graphe, avec `index.md`/`log.md` optionnels. Sur le **spectre de la gestion de la connaissance**, OKF occupe volontairement le bas (interop **structurelle**), laissant l'interop **sémantique** et la formalisation ontologique (RDF/OWL/SPARQL, inférence, vérifiabilité) aux conventions et aux besoins plus exigeants. OKF est donc moins une technologie qu'une **convention d'interopérabilité** pour rendre un dossier de markdown curé portable d'un agent à l'autre.

## Limites

- OKF est en **v0.1** : périmètre, champs et conventions peuvent évoluer ; l'interop sémantique n'est pas traitée.
- Les gains chiffrés du LLM Wiki (jusqu'à 95 % de tokens) proviennent de sources secondaires et dépendent fortement de la taille et de la structure de la base.
- La fondation ne tranche pas le débat LLM Wiki vs RAG : les deux coexistent, souvent en hybride.
- Le source-material fourni est un échange assisté par IA, utilisé comme orientation, non comme preuve.

## Sources

- Google Cloud, « How the Open Knowledge Format can improve data sharing » (annonce OKF v0.1, 2026-06-12) : https://cloud.google.com/blog/products/data-analytics/how-the-open-knowledge-format-can-improve-data-sharing/
- MarkTechPost, « Google Cloud Introduces Open Knowledge Format (OKF) » : https://www.marktechpost.com/2026/06/16/google-cloud-introduces-open-knowledge-format-okf-a-vendor-neutral-markdown-spec-for-giving-ai-agents-curated-context/
- MindStudio, « LLM Wiki vs RAG: A Decision Framework » : https://www.mindstudio.ai/blog/llm-wiki-vs-rag-knowledge-base
- MindStudio, « Karpathy's LLM Wiki: 95% Less Token Use Than RAG » : https://www.mindstudio.ai/blog/llm-wiki-vs-rag-markdown-knowledge-base-comparison
- Marc Bara, « Google's New Format for Agent Context: A Standard, or Just a Folder? » (interop structurelle vs sémantique) : https://medium.com/@marc.bara.iniesta/googles-new-format-for-agent-context-a-standard-or-just-a-folder-82fb21d92041
- Atlan, « RDF vs OWL: Key Differences » : https://atlan.com/know/rdf-vs-owl/
- « Semantic Web and Software Agents » (arXiv) : https://arxiv.org/pdf/2503.20793
- « LLM-empowered knowledge graph construction: A survey » (arXiv) : https://arxiv.org/html/2510.20345v1
- Source-material (orientation, revérifié) : `.dev/source-material/poe.com/post-rag-llm-wiki.md`
