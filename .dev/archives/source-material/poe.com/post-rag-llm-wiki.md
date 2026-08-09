QUESTION =>>>

Quel sont les méthodes "post RAG" de gestion contextuel. Apparemment, Google conclu que juste des fichiers markdown peuvent très bien faire l'affaire. De quoi s'agit-il?

RÉPONSE =>>>

*Thinking...*

> I'm looking into recent developments around post-RAG context management, particularly Google's findings on using markdown files as an effective approach for handling context.
> 
> I'm ready to write about post-RAG context management approaches, particularly Google's OKF framework and the LLM Wiki pattern.

Tu fais référence à un ensemble de tendances récentes autour de ce qu'on appelle le « context engineering », et plus précisément au **pattern LLM Wiki** que Google a formalisé en juin 2026 sous le nom **Open Knowledge Format (OKF)**. Voici de quoi il s'agit.

## L'idée centrale : le « LLM Wiki »

Le concept de base a été popularisé par Andrej Karpathy. Contrairement au RAG, qui comporte des coûts réels (complexité d'infrastructure, échecs de récupération, casse-têtes de découpage en chunks et maintenance continue), il existe une approche plus simple : le LLM wiki, une base de connaissances markdown structurée conçue pour vivre directement dans la fenêtre de contexte d'un LLM. Pour des bases de connaissances petites et ciblées, cela peut réduire l'usage de tokens jusqu'à 95% par rapport au chargement naïf de documents.[[5]](https://www.mindstudio.ai/blog/llm-wiki-vs-rag-markdown-knowledge-base-comparison)

La différence fondamentale avec le RAG est la suivante : le pattern LLM Wiki stocke les informations dans des fichiers markdown ou texte structurés plutôt que dans une base de données vectorielle. Au lieu d'utiliser la recherche sémantique pour récupérer des fragments pertinents, un agent utilise une couche de routage — souvent un fichier index ou le propre jugement du LLM — pour charger directement le ou les documents pertinents dans le contexte.[[1]](https://www.mindstudio.ai/blog/llm-wiki-vs-rag-knowledge-base)

L'argument clé de Karpathy sur *pourquoi* cela fonctionne avec des LLM : les LLM ne s'ennuient pas, n'oublient pas de mettre à jour les références croisées, et peuvent éditer plusieurs fichiers en une seule passe. Le travail de tenue à jour qui pousse les humains à abandonner leurs wikis personnels est précisément ce que les LLM gèrent bien.[[3]](https://www.marktechpost.com/2026/06/16/google-cloud-introduces-open-knowledge-format-okf-a-vendor-neutral-markdown-spec-for-giving-ai-agents-curated-context/)

## Ce que Google a fait : l'Open Knowledge Format (OKF)

L'Open Knowledge Format (OKF) est une spécification ouverte et neutre en termes de fournisseur pour stocker la connaissance organisationnelle sous forme de répertoire de fichiers markdown avec du frontmatter YAML. Annoncé par Google Cloud le 12 juin 2026, OKF donne aux agents IA un moyen standardisé de lire, écrire et échanger de la connaissance sans plateformes propriétaires, SDK ou verrouillage.[[1]](https://flowtivity.ai/blog/google-open-knowledge-format/)

Concrètement, la structure est volontairement minimaliste. Il n'y a pas de schéma de compression, pas de nouveau runtime, et pas de SDK requis. Un bundle de documents OKF, ce ne sont que du markdown, des fichiers et du frontmatter YAML. Cela s'affiche sur GitHub, se livre comme un tarball, et se monte sur n'importe quel système de fichiers.[[3]](https://www.marktechpost.com/2026/06/16/google-cloud-introduces-open-knowledge-format-okf-a-vendor-neutral-markdown-spec-for-giving-ai-agents-curated-context/)

Les mécanismes structurants sont simples :

- Les liens markdown normaux créent un graphe de connaissance. La hiérarchie du système de fichiers donne les relations parent/enfant. Les liens croisés ajoutent des connexions plus riches — jointures, dépendances, références. Un agent consommateur peut parcourir ce graphe pour construire son contexte.[[1]](https://flowtivity.ai/blog/google-open-knowledge-format/)
- Les champs structurés réservés sont : type, title, description, resource, tags et timestamp.[[3]](https://www.marktechpost.com/2026/06/16/google-cloud-introduces-open-knowledge-format-okf-a-vendor-neutral-markdown-spec-for-giving-ai-agents-curated-context/) Mais OKF n'exige exactement qu'un seul champ sur chaque concept : type. Tout le reste est laissé au producteur.[[3]](https://www.marktechpost.com/2026/06/16/google-cloud-introduces-open-knowledge-format-okf-a-vendor-neutral-markdown-spec-for-giving-ai-agents-curated-context/)
- Les bundles peuvent optionnellement inclure des fichiers index.md pour la « progressive disclosure » et des fichiers log.md pour l'historique des changements.[[3]](https://www.marktechpost.com/2026/06/16/google-cloud-introduces-open-knowledge-format-okf-a-vendor-neutral-markdown-spec-for-giving-ai-agents-curated-context/)

La distinction essentielle par rapport au RAG : contrairement au RAG, OKF stocke des concepts curés et versionnés que les agents lisent et mettent à jour directement.[[3]](https://www.marktechpost.com/2026/06/16/google-cloud-introduces-open-knowledge-format-okf-a-vendor-neutral-markdown-spec-for-giving-ai-agents-curated-context/)

## Pourquoi ça marche : « juste du markdown » suffit souvent

Ton intuition est correcte. La logique repose sur deux facteurs :

**Les fenêtres de contexte sont devenues grandes.** Les LLM modernes ont de grandes fenêtres de contexte. Pour la plupart des bases de connaissances petites à moyennes, la base entière tient confortablement dans le contexte. Quand la connaissance tient dans le contexte, on n'a rien besoin de récupérer — le LLM lit tout et raisonne dessus directement.[[5]](https://www.mindstudio.ai/blog/llm-wiki-vs-rag-markdown-knowledge-base-comparison)

**C'est plus fiable que la récupération.** C'est plus fiable que la récupération — on ne dépend pas de la similarité d'embeddings pour faire remonter les bons fragments. Les échecs de récupération en RAG sont souvent silencieux : le système ne vous dit pas qu'il n'a pas trouvé le fragment pertinent, il génère simplement une réponse sans lui.[[5]](https://www.mindstudio.ai/blog/llm-wiki-vs-rag-markdown-knowledge-base-comparison)

Ce pattern existait déjà de manière informelle. Le même pattern réapparaît sous différents noms : des vaults Obsidian câblés à des agents de code, les fichiers de convention AGENTS.md et CLAUDE.md, les repos « metadata as code ». Chaque instance était sur-mesure, donc aucune n'interopérait. OKF standardise cette couche d'interopérabilité pour que les agents fassent le gros du travail.[[3]](https://www.marktechpost.com/2026/06/16/google-cloud-introduces-open-knowledge-format-okf-a-vendor-neutral-markdown-spec-for-giving-ai-agents-curated-context/)

## Quand utiliser quoi

Ce n'est pas nécessairement un remplacement total du RAG. Le cadre de décision généralement admis :

- Pour des bases de connaissances petites à moyennes et bien structurées, le LLM Wiki est plus rapide à construire, moins cher à faire tourner, plus précis et plus facile à maintenir. Les facteurs qui le favorisent : périmètre restreint, exigences de haute précision, contenu structuré, besoins de contrôle de version, ressources d'ingénierie limitées.[[1]](https://www.mindstudio.ai/blog/llm-wiki-vs-rag-knowledge-base)
- Le RAG reste le bon choix pour de grandes collections de documents non structurés où la recherche sémantique apporte une réelle valeur.[[1]](https://www.mindstudio.ai/blog/llm-wiki-vs-rag-knowledge-base)

Beaucoup optent d'ailleurs pour une approche hybride : le wiki gère la connaissance fondamentale qui doit toujours être disponible ; le RAG gère le contenu de longue traîne, à fort volume ou changeant fréquemment qui ne peut pas résider en permanence dans le contexte. Cette approche combine la fiabilité d'une connaissance de base toujours disponible avec le passage à l'échelle de la récupération pour les cas limites.[[5]](https://www.mindstudio.ai/blog/llm-wiki-vs-rag-markdown-knowledge-base-comparison)

## En résumé

Le « post-RAG » dont tu parles désigne le glissement d'une architecture basée sur la récupération vectorielle vers des bases de connaissances curées en markdown lisibles directement — le pattern LLM Wiki. La contribution de Google avec OKF n'est pas une nouvelle technologie révolutionnaire mais une **standardisation** d'une pratique existante. OKF vaut la peine d'être suivi moins pour sa profondeur technique que parce qu'il nomme une couche qui manquait à l'écosystème des agents : un paquet de contexte portable que l'on peut remettre à un agent sans construire d'intégration sur-mesure.[[7]](https://medium.com/@marc.bara.iniesta/googles-new-format-for-agent-context-a-standard-or-just-a-folder-82fb21d92041)

À noter qu'il s'agit encore d'une v0.1 : la distinction utile en version 0.1 est entre interopérabilité structurelle et interopérabilité sémantique. OKF fait clairement avancer la première. Il laisse surtout la seconde aux producteurs, aux consommateurs et aux conventions futures.[[7]](https://medium.com/@marc.bara.iniesta/googles-new-format-for-agent-context-a-standard-or-just-a-folder-82fb21d92041)

---
Learn more:
1. [Google's Open Knowledge Format: The Markdown Standard That Could Replace Your Wiki | Flowtivity](https://flowtivity.ai/blog/google-open-knowledge-format/)
2. [LLM Wiki vs RAG: A Decision Framework for AI Knowledge Bases | MindStudio](https://www.mindstudio.ai/blog/llm-wiki-vs-rag-knowledge-base)
3. [Improved RAG Document Processing With Markdown | by Dr. Leon Eversberg | TDS Archive | Medium](https://medium.com/data-science/improved-rag-document-processing-with-markdown-426a2e0dd82b)
4. [Google Cloud Introduces Open Knowledge Format (OKF): A Vendor-Neutral Markdown Spec for Giving AI Agents Curated Context - MarkTechPost](https://www.marktechpost.com/2026/06/16/google-cloud-introduces-open-knowledge-format-okf-a-vendor-neutral-markdown-spec-for-giving-ai-agents-curated-context/)
5. [GitHub - verloop/md2chunks: Context Enriched Markdown Chunking for RAG · GitHub](https://github.com/verloop/md2chunks)
6. [GitHub - Zackriya-Solutions/MCP-Markdown-RAG: A semantic search engine for markdown files based on MCP architecture. · GitHub](https://github.com/Zackriya-Solutions/MCP-Markdown-RAG)
7. [Unlock PDFs for RAG with Markdown and Gemini | by Greg Sommerville | Google Cloud - Community | Medium](https://medium.com/google-cloud/unlocking-pdfs-for-rag-with-markdown-and-gemini-503846463f3f)
8. [Karpathy's LLM Wiki: 95% Less Token Use Than RAG | MindStudio](https://www.mindstudio.ai/blog/llm-wiki-vs-rag-markdown-knowledge-base-comparison)
9. [Context Engineering vs. RAG: Key Differences in 2026 | Atlan](https://atlan.com/know/context-engineering-vs-rag/)
10. [Google’s New Format for Agent Context: A Standard, or Just a Folder? | by Marc Bara | Jun, 2026 | Medium](https://medium.com/@marc.bara.iniesta/googles-new-format-for-agent-context-a-standard-or-just-a-folder-82fb21d92041)
11. [MarkItDown: PDF to Markdown for RAG Pipelines \[2026 Guide\]](https://www.aibuilderclub.com/blog/markitdown-microsoft-convert-files-markdown-llm)
12. [Optimizing RAG Context: Chunking and Summarization for Technical Docs - DEV Community](https://dev.to/oleh-halytskyi/optimizing-rag-context-chunking-and-summarization-for-technical-docs-3pel)
13. [GitHub - EasyDevv/project-to-markdown: Project To Markdown: Project files into structured markdown, optimizing documentation for AI analysis. Enhances AI assistants' performance in understanding project context, featuring both GUI and CLI interfaces. Ideal for improving AI-powered code comprehension and problem-solving. · GitHub](https://github.com/EasyDevv/project-to-markdown)
14. [Building a Markdown Knowledge Ingestor for RAG with LangChain | by vishal khushlani | Medium](https://medium.com/@vishalkhushlani123/building-a-markdown-knowledge-ingestor-for-rag-with-langchain-ba201515f6c4)
15. [Open Knowledge Format (OKF): Google's New Markdown Format for AI Agents — Suganthan](https://suganthan.com/blog/open-knowledge-format/)
16. [Why I Chose Markdown as the Foundation of my RAG Pipeline | by Samuel Owolabi | May, 2026 | Artificial Intelligence in Plain English](https://ai.plainenglish.io/why-i-chose-markdown-as-the-foundation-of-my-rag-pipeline-5f5b46c10f2b?gi=df1db6810824)