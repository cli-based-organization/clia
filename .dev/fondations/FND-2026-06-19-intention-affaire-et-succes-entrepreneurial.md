# FND-2026-06-19 - Intention d'affaire et succès entrepreneurial

> **Statut** : instable (peut être enrichi au fil des tickets)
>
> **Date** : 2026-06-19
>
> **Provenance** : rapatriée depuis `cryptosecops/stratégie/.dev/fondations/FND-002-intention-affaire-et-succes-entrepreneurial.md` (tâche 17, demande explicite). Contenu de domaine business (CryptoSecOps) conservé fidèlement ; à traiter comme savoir importé, non comme ressource générique du harnais.
>
> **Objectif** : mobiliser les cadres théoriques relatifs à l'intention d'affaire (choisir quoi construire), au succès entrepreneurial, à la direction d'entreprise efficace, aux startups technologiques et aux pratiques deeptech. Cet essai sert de support à l'optimisation de INTENTION.md pour le projet CryptoSecOps.
>
> **Note de rigueur** : cet essai s'appuie sur des sources secondaires et tertiaires de référence (manuels, travaux académiques, essais fondateurs du milieu VC et entrepreneurial). Les auteurs primaires sont cités nommément. À traiter comme une revue de cadrage orientée pratique, non comme une recension académique exhaustive. Les données empiriques sur les taux d'échec et de succès proviennent de rapports de recherche (Startup Genome, CBInsights) et sont à interpréter avec les biais de sélection inhérents à ces sources.

## 1. Cadrage

### 1.1 Questions traitées

1. Quelles théories permettent de valider ou de critiquer le choix d'une intention d'affaire donnée (quel type d'entreprise construire, pourquoi, pour qui) ?
2. Que sait-on empiriquement et théoriquement sur les facteurs de succès et d'échec des startups ?
3. Quelles sont les compétences et pratiques distinctives de la direction d'entreprise efficace en contexte de démarrage ?
4. Qu'est-ce qui distingue une startup technologique d'une startup de services, et quelles implications pour ce projet ?
5. Qu'est-ce que le deeptech, et en quoi le marché PQC relève-t-il (ou non) de cette catégorie ?
6. Quelles implications concrètes pour la rédaction de INTENTION.md ?

### 1.2 Périmètre

Dans le périmètre : théories de la reconnaissance et de la création d'opportunité entrepreneuriale ; facteurs empiriques de succès et d'échec des startups ; fonctions et pratiques du dirigeant de startup ; spécificités des startups technologiques et de services technologiques ; caractéristiques et cycle de vie deeptech ; implications sur le go-to-market d'un marché émergent sous pression réglementaire.

Hors périmètre : planification stratégique générale, alliances, modèles de revenus et GTM opérationnel (traités dans FND-001) ; financement et levée de fonds (traité séparément si nécessaire) ; droit des affaires et réglementation ; architecture technique PQC.

### 1.3 Définitions de travail

**Intention d'affaire** : l'ensemble cohérent qui répond à trois questions - quel problème résoudre, pour qui, et pourquoi maintenant. Une intention d'affaire forte est à la fois une lecture de marché (externalité objectivable) et une conviction personnelle du fondateur (ce qu'il est uniquement positionné pour voir et résoudre).

**Succès entrepreneurial** : dans cet essai, le succès est défini au sens large - une entreprise qui atteint la viabilité financière, crée de la valeur pour ses clients et réalise l'objectif stratégique des fondateurs (ici : revendre la startup en conservant 20 à 30 % des actions). Les métriques de succès varient selon les sources citées ; le contexte est précisé à chaque fois.

**Deeptech** : categorie de startups dont l'offre repose sur une avancée scientifique ou technologique fondamentale qui constitue elle-même une barrière à l'entrée. Distinct des "startups tech" dont l'avantage est opérationnel ou commercial, non technologique à la frontière.

**Startup technologique de services** : entreprise dont la proposition de valeur est l'application d'une expertise technologique pointue sous forme de services professionnels (conseil, formation, intégration), et non sous forme de produit logiciel ou matériel. Ce projet en est un exemple.

## 2. L'intention d'affaire : choisir quoi construire

### 2.1 Deux visions de la découverte d'opportunité

La théorie de la reconnaissance d'opportunité (Shane & Venkataraman, 2000) postule que les opportunités entrepreneuriales existent objectivement dans l'environnement - asymétries d'information, inefficacités de marché, changements réglementaires ou technologiques - et que certains individus sont mieux positionnés que d'autres pour les percevoir. La perception dépend du capital de connaissance préalable (prior knowledge) : on voit des opportunités là où on a de l'expérience. Un ingénieur DevSecOps avec dix ans de pratique verra des opportunités invisibles pour un consultant généraliste en stratégie.

La théorie de la création d'opportunité (Alvarez & Barney, 2007) nuance cette vision : certaines opportunités n'existent pas avant d'être créées par l'entrepreneur lui-même, à travers ses actions et ses expérimentations. Il ne s'agit pas de découvrir un marché existant mais de le construire. Dans les marchés émergents (comme le PQC en 2026), les deux logiques coexistent : le problème existe objectivement (la menace quantique est réelle), mais le marché de services autour de ce problème est à construire.

### 2.2 La causalité vs. l'effectuation (Sarasvathy, 2001)

Sarasvathy (« Effectuation », 2001) compare deux modes de raisonnement entrepreneurial. La causalité (causation) : définir un objectif, puis choisir les moyens pour l'atteindre - logique de planification. L'effectuation : partir des moyens disponibles (qui suis-je, que sais-je, qui je connais), imaginer ce qu'on peut créer avec ces moyens, puis itérer. Sarasvathy montre empiriquement que les entrepreneurs experts utilisent massivement l'effectuation, surtout en situation de haute incertitude.

L'implication pratique : dans un marché aussi incertain que le PQC, forcer une logique causale pure (plan stratégique détaillé sur 3 ans) avant d'avoir validé le marché est prématuré. L'effectuation suggère de partir des actifs existants (expertise DevSecOps + cybersécurité, réseau actuel, conférence "La menace quantique") et de voir quels marchés et clients émergent de l'action.

### 2.3 Le founder-market fit

Le concept de founder-market fit (popularisé par les fonds de capital-risque, notamment First Round Capital et a16z) désigne l'adéquation entre le profil du fondateur et le marché qu'il cherche à servir. Un fondateur avec un fort founder-market fit est reconnu comme expert par ses futurs clients avant même d'avoir vendu quoi que ce soit, bénéficie de la légitimité nécessaire pour vendre à un marché technique, et perçoit les nuances du problème inaccessibles à un entrant de l'extérieur.

Le founder-market fit est considéré comme l'un des prédicteurs les plus forts de succès en phase initiale, car il détermine à la fois la crédibilité (facteur de vente), la qualité de la solution (facteur de livraison) et la résilience face aux obstacles (facteur de persévérance). Pour ce projet, le profil DevSecOps de Jérémy Viau-Trudel et le profil conformité cybersécurité d'André Gerges représentent un founder-market fit fort pour le marché PQC.

### 2.4 La thèse de conviction : "why us, why now"

Y Combinator et Sequoia Capital formalisent la thèse d'investissement autour de deux questions centrales : "why this" (pourquoi ce problème mérite d'être résolu), "why now" (pourquoi c'est le bon moment), et "why us" (pourquoi cette équipe est la mieux placée). Ces questions sont également un outil de clarification de l'intention d'affaire pour les fondateurs eux-mêmes.

**Why this (pour ce projet)** : la migration PQC est un problème réel, urgent et non résolu pour la majorité des organisations. Les standards NIST (FIPS 203-206) et les obligations réglementaires (ITSM, OSFI B-13) créent une demande non élastique.

**Why now** : la fenêtre d'opportunité est limitée dans le temps. Les standards NIST ont été finalisés en 2024 ; les organismes réglementaires commencent à fixer des échéanciers ; dans 3 à 5 ans, des intégrateurs établis occuperont le marché. La fenêtre early mover est ouverte maintenant.

**Why us** : expertise technique PQC (DevSecOps + conformité), réseau institutionnel (Frappier, PINQ2, Amora), positionnement bilingue au Québec avec accès aux deux marchés (entreprises privées et organismes publics).

### 2.5 L'intentionnalité stratégique vs. l'adaptabilité

Hamel & Prahalad (« Strategic Intent », 1989) soutiennent que les organisations qui réussissent ont une intention stratégique stable à long terme (où veut-on être dans 10 ans) couplée à une adaptabilité tactique à court terme (comment s'y prendre peut changer). Cette tension est caractéristique des meilleures startups : une conviction profonde sur le problème à résoudre, une extrême flexibilité sur la manière.

L'intention déclarée dans INTENTION.md doit donc articuler deux niveaux : l'intention profonde (invariante, résistante aux pivots) et les moyens actuels (variables, à tester et ajuster). Mélanger les deux fragilise l'intention : si "offrir des conférences" est dans l'intention permanente, un pivot sur le format de livraison devient une remise en question de l'intention elle-même.

## 3. Le succès entrepreneurial

### 3.1 Données empiriques sur l'échec

CBInsights (2023), dans son analyse des raisons d'échec de startups, identifie les causes principales : pas de besoin marché (35 % des cas), manque de liquidités (38 %), équipe inadéquate (14 %), concurrence (20 %), modèle de prix ou de coûts problématique (18 %). Ces chiffres sont à lire avec prudence (biais de mémoire, auto-déclaration) mais ils signalent que l'échec vient rarement de la technologie ou du produit, mais de l'adéquation marché et de la gestion.

Le Startup Genome Report (2022) ajoute le concept de "scaling prématuré" : 70 % des startups qui échouent scale avant d'avoir validé leur modèle. Elles recrutent, investissent en marketing et en infrastructure avant d'avoir prouvé que le marché paie pour leur offre. Pour une startup de services, le scaling prématuré prend la forme d'une diversification trop rapide de l'offre avant de maîtriser la livraison du premier service.

### 3.2 Le timing comme facteur premier

Bill Gross (Idealab) a analysé 200 startups sur les facteurs de succès et a conclu que le timing est le facteur numéro un, devant l'équipe, l'idée, le modèle d'affaires et le financement. Être trop en avance sur le marché (le marché n'est pas prêt) est fatal autant qu'être trop en retard (des acteurs établis ont capturé le marché). Le timing idéal est quand le problème est réel et urgent pour les clients, mais qu'aucun acteur établi n'a encore de solution convaincante.

Pour le PQC en 2026, le timing semble favorable : la menace est de plus en plus reconnue, les standards sont finalisés, les régulateurs commencent à agir, mais le marché de services est encore fragmenté et peu mature. Le risque principal n'est pas d'être trop tôt (les réglementations créent une demande non négociable) mais potentiellement trop lent si des concurrents établis s'organisent rapidement.

### 3.3 L'équipe avant tout

Paul Graham (Y Combinator) affirme que les investisseurs investissent d'abord dans des fondateurs, ensuite dans des marchés, et en dernier dans des idées. La raison : les idées pivotent, les marchés évoluent, mais la qualité de l'équipe fondatrice détermine la capacité à naviguer ces changements. Les qualités les plus valorisées chez les fondateurs de startups technologiques : résilience (capacité à encaisser les échecs et rebondir), vitesse d'apprentissage, compréhension profonde du problème, et capacité d'exécution (passer de l'idée à l'action rapidement).

Noam Wasserman (« The Founder's Dilemmas », 2012) identifie le dilemme central du fondateur : vouloir "être riche" (maximiser la valeur financière) ou "être roi" (maintenir le contrôle). Ces objectifs sont souvent incompatibles. Pour ce projet, l'objectif est explicitement "être riche" (revendre en conservant 20-30 %), ce qui implique une ouverture à partager le contrôle, à recruter des compétences complémentaires et à faire entrer des investisseurs si nécessaire.

### 3.4 La résilience et la gestion de l'incertitude

Angela Duckworth (« Grit », 2016) documente que la persévérance dans la durée et la passion pour un objectif à long terme prédisent la réussite mieux que le talent immédiat. En entrepreneuriat, cela se traduit par la capacité à traverser les phases de doute, de résistance du marché et d'échecs successifs sans abandonner l'intention fondamentale. La grit est distincte de l'obstination aveugle : elle s'accompagne d'une capacité à apprendre et à ajuster les moyens (effectuation) tout en maintenant l'intention.

Nassim Nicholas Taleb (« Antifragile », 2012) propose le concept d'antifragilité : certains systèmes se renforcent sous l'effet des chocs, de la volatilité et de l'incertitude. Une startup antifragile construit des optionalités (plusieurs sources de revenus potentielles, plusieurs segments de marché possibles) plutôt que de se sur-optimiser pour un seul scénario. Pour ce projet, proposer plusieurs niveaux d'engagement (conférence, formation, pilote) est une stratégie antifragile : si les conférences ne convertissent pas, les courriels directs peuvent fonctionner ; si le pilote est trop coûteux à livrer, les formations peuvent être le modèle principal.

### 3.5 Le succès comme construction narrative

Jerome Bruner et Herminia Ibarra (« Working Identity », 2003) montrent que les entrepreneurs qui réussissent construisent activement leur identité professionnelle et la narration de leur parcours. Cette narration n'est pas cosmétique : elle attire les co-fondateurs, les clients, les partenaires et les investisseurs. Une identité d'expert PQC crédible et cohérente (conférences, publications, réseau institutionnel) est un actif stratégique qui se construit dans le temps et qui amplifie chaque action commerciale.

## 4. La direction d'entreprise efficace en startup

### 4.1 Le piège de l'expert-technicien (E-Myth)

Michael Gerber (« The E-Myth », 1986) identifie le piège le plus fréquent de l'entrepreneur : confondre être compétent dans un métier (technicien) avec savoir gérer une entreprise. L'expert technique qui crée une entreprise pour "faire ce qu'il aime" néglige les fonctions de gestion (opérations, finances, RH) et les fonctions entrepreneuriales (vision, stratégie, développement marché). Gerber préconise de travailler "sur" l'entreprise (la concevoir, la faire évoluer) autant que "dans" l'entreprise (livrer le service).

Pour ce projet, le risque Gerber est réel : les deux fondateurs ont des expertises techniques profondes (DevSecOps, cybersécurité). La valeur qu'ils apportent comme techniciens est claire. La question est : qui gère la vision long terme, le développement commercial, la livraison scalable, et la préparation à la cession ?

### 4.2 Founder mode vs. manager mode

Paul Graham (« Founder Mode », 2024) documente une tension fondamentale dans la direction d'une startup : le "manager mode" (déléguer à des hiérarchies, ne gérer que les N-1 directs) fonctionne dans les grandes organisations mais est sous-optimal pour les startups. Le "founder mode" (implication directe du fondateur dans les décisions opérationnelles critiques, contact direct avec les équipes et les clients) préserve l'agilité et la qualité d'exécution des premières phases.

À l'échelle de ce projet (équipe de 2 fondateurs, premier client à obtenir), le founder mode est non seulement approprié mais nécessaire. Le risque est de rester en founder mode trop longtemps après la croissance, ce qui génère un goulot d'étranglement humain. Le moment de basculer vers plus de délégation est quand le temps du fondateur devient le facteur limitant de la croissance.

### 4.3 La prise de décision sous incertitude radicale

Gary Klein (« Sources of Power », 1998 ; « Seeing What Others Don't », 2013) a étudié comment les experts décident en situation de haute incertitude et de temps limité. Son modèle Recognition-Primed Decision (RPD) montre que les experts ne comparent pas les options systématiquement : ils reconnaissent des patterns dans la situation, génèrent une option plausible, la simulent mentalement, et agissent si elle semble acceptable. La décision experte est rapide et contextuelle, non algorithmique.

En contexte startup, cela implique que le fondateur expert (bon founder-market fit) prend souvent de meilleures décisions tactiques en "faisant confiance à son instinct" qu'en suivant un processus analytique complet, surtout quand le temps est limité et l'information partielle. L'analytique reste utile pour les décisions stratégiques à fort enjeu et délai suffisant.

Annie Duke (« Thinking in Bets », 2018) complète cette vision : en incertitude, les bonnes décisions ne produisent pas toujours de bons résultats. La qualité d'une décision s'évalue sur son processus (informations disponibles, raisonnement suivi), non sur son résultat. Ce cadre aide les fondateurs à distinguer une mauvaise décision d'une bonne décision avec un mauvais résultat, et à apprendre différemment de chacune.

### 4.4 Gestion de l'énergie et des priorités

Andy Grove (« High Output Management », 1983) formule le principe de levier managérial : le manager doit concentrer son temps sur les activités à fort levier - celles dont l'impact sur les résultats est disproportionné. Pour un fondateur de startup, les activités à fort levier sont : les ventes et le développement commercial (chaque meeting avec un client potentiel a un impact direct sur la survie), le recrutement des premières personnes clés, et les décisions de pivot stratégique.

Les activités à faible levier (administration, tâches qui pourraient être déléguées, optimisations prématurées) doivent être minimisées. Dans une startup de deux fondateurs, l'enjeu est de ne pas se noyer dans les tâches opérationnelles au détriment du développement commercial.

### 4.5 La décision du pivot

Steve Blank et Eric Ries définissent le pivot comme un changement de direction stratégique qui maintient une continuité d'apprentissage. Un pivot n'est pas un abandon : c'est une réorientation fondée sur des données (ce qui fonctionne, ce qui ne fonctionne pas). Les types de pivots décrits par Ries incluent : pivot de segment (même offre, nouveau segment de clients), pivot de problème (même segment, problème différent identifié), pivot de canal (même offre et segment, canal de distribution différent), pivot de modèle de revenus.

La capacité à pivoter vite et de manière disciplinée (fondé sur l'apprentissage, non sur la panique) est l'une des compétences distinctives des dirigeants de startup qui réussissent. Elle requiert que l'intention d'affaire soit définie à un niveau suffisamment abstrait pour survivre au pivot : si l'intention est "mettre en oeuvre la conformité PQC", un pivot du service pilote vers la formation en ligne est un ajustement tactique ; si l'intention est "offrir le service de task-force PQC", le même pivot remet l'intention en question.

## 5. Les startups technologiques et leurs spécificités

### 5.1 Qu'est-ce qu'une startup technologique ?

Une startup technologique est une entreprise dont la proposition de valeur centrale repose sur la technologie comme source d'avantage compétitif. Deux sous-catégories principales :

**Startup produit tech (software, hardware)** : l'avantage est dans le produit lui-même. La croissance est potentiellement exponentielle (effets de réseau, faible coût marginal). La scalabilité est le moteur principal de création de valeur. Exemples : GitHub, Stripe, Datadog.

**Startup de services tech (tech-enabled services)** : l'avantage est dans l'application d'une expertise technologique profonde sous forme de services. La croissance est limitée par la capacité humaine (chaque engagement requiert du temps expert). La scalabilité passe par la mise en produit de l'expertise (formations, méthodologies, outils propriétaires) ou par le recrutement. Exemples : McKinsey Digital, Thoughtworks, OWASP Security Firms.

Ce projet est dans la deuxième catégorie. Les implications : valorisation à la cession différente (multiple de revenu, non multiple d'ARR SaaS), importance critique de la propriété intellectuelle (méthodologies, frameworks, formations) pour la valorisation, et nécessité de construire des "actifs scalables" (formations enregistrées, guides certifiants) pour compléter les revenus de services.

### 5.2 La propriété intellectuelle comme actif stratégique

Dans une startup de services, la propriété intellectuelle prend des formes spécifiques : méthodologies propriétaires (frameworks d'évaluation de conformité PQC, playbooks de migration), outils logiciels internes (scripts, tableaux de bord d'analyse), formations certifiantes (curriculum structuré, matériel pédagogique), marque et réputation (positionnement expert reconnu). Ces actifs sont critiques pour deux raisons : ils permettent la scalabilité (une formation peut servir 20 participants sans coût marginal additionnel en expert) et ils constituent l'essentiel de la valeur perçue par un acquéreur à la cession.

### 5.3 Le cold start problem dans les services tech

Andrew Chen (« The Cold Start Problem », 2021) analyse comment les plateformes et réseaux surmontent le problème du démarrage sans utilisateurs. Appliqué aux services tech B2B, le cold start problem se traduit par le paradoxe de la crédibilité : pour obtenir des clients, il faut des références ; pour avoir des références, il faut des clients. Les stratégies classiques pour le surmonter sont : le client pilote à prix réduit ou gratuit (accepter un premier client à conditions favorables pour obtenir la référence), le partenariat avec une organisation légitime (l'association avec Marc Frappier ou une institution comme l'UdeS valide la crédibilité), ou la démonstration publique de l'expertise (conférences, publications, rapport "Prêt pour l'ère post-quantique").

## 6. Les pratiques deeptech

### 6.1 Définition et caractéristiques

Hello Tomorrow et BCG définissent les startups deeptech comme des entreprises dont l'avantage compétitif repose sur une avancée scientifique ou d'ingénierie difficile à reproduire, et dont le développement requiert généralement des cycles longs, des investissements importants en R&D, et une collaboration étroite avec le monde académique. Les domaines typiques du deeptech incluent : biotechnologie, matériaux avancés, intelligence artificielle fondamentale, informatique quantique, robotique avancée, énergie.

Le deeptech se distingue de la "tech classique" par trois caractéristiques : un risque technologique (la solution fondamentale n'est pas encore prouvée), un cycle de développement long (3 à 10 ans avant commercialisation), et un investissement initial élevé avant de générer des revenus.

### 6.2 Le PQC comme deeptech de service

La cryptographie post-quantique est une technologie deeptech du point de vue de sa R&D fondamentale (algorithmes de cryptographie post-quantique, mathématiques avancées). Cependant, ce projet n'est pas une startup deeptech au sens strict : il n'y a pas de R&D fondamentale à mener. La startup est une "startup de services deeptech" - elle applique et déploie des technologies deeptech existantes (standards NIST FIPS 203-206, CRYSTALS-Kyber, CRYSTALS-Dilithium, etc.) pour résoudre des problèmes concrets chez des clients.

Cette distinction est fondamentale pour le positionnement et la stratégie :

**Comme service deeptech, les avantages sont** : cycles de vente plus courts que le deeptech pur (pas de R&D interne), revenus plus rapides, risque technologique limité (les algorithmes existent, ils sont standardisés).

**Les défis subsistants** : éduquer un marché qui ne comprend pas encore bien la menace (deeptech marketing challenge), naviguer une réglementation en cours d'élaboration, et convaincre des clients d'investir dans une migration avant que la menace soit perceptible.

### 6.3 Le "valley of death" pour les services deeptech

Dans le deeptech pur, le "valley of death" désigne la période entre la fin du financement de R&D (subventions, fonds publics) et le premier revenu commercial - une période où beaucoup de startups meurent par manque de liquidités. Pour les services deeptech, le valley of death équivalent est la période entre le lancement des services et la signature du premier contrat commercial. Cette période doit être aussi courte que possible, d'où l'importance de l'offre pilote : elle cible un premier revenu dans un délai court.

### 6.4 L'écosystème deeptech et ses ressources

L'écosystème deeptech québécois et canadien offre des ressources spécifiques exploitables : le PINQ2 (ordinateur quantique accessible) comme démonstrateur et partenaire de crédibilité, les programmes d'accélération comme Centech (Montréal) et Creative Destruction Lab (CDL) qui ont des programmes quantiques et cybersécurité, le Programme d'aide à la recherche industrielle (PARI/IRAP) du CNRC pour le financement de la R&D appliquée, et les partenariats université-industrie formalisés via l'Institut Quantique de l'Université de Sherbrooke (Marc Frappier).

### 6.5 La lisibilité externe du positionnement deeptech

Se positionner comme "startup de services deeptech PQC" plutôt que comme "firme de conseil en cybersécurité" a un impact direct sur les interlocuteurs accessibles : les programmes de financement deeptech, les accélérateurs spécialisés, les journalistes tech, et les investisseurs qui suivent le marché quantique. Ce positionnement élève le profil et ouvre des portes que le positionnement "service de conseil" ne permet pas. Il crée aussi une obligation implicite de crédibilité technique : le marché deeptech est exigeant sur la profondeur réelle de l'expertise.

## 7. Go-to-market pour un marché émergent sous pression réglementaire

### 7.1 L'urgence réglementaire comme déclencheur de marché

Les marchés créés par l'obligation réglementaire ont une dynamique distincte des marchés créés par la demande organique. Dans un marché de conformité, le déclencheur d'achat n'est pas la perception du problème (les organisations savent que la menace PQC existe) mais la perception de l'urgence et de la sanction (quand serai-je contrôlé ? Que risque-je en cas de non-conformité ?). Cette distinction est critique pour le GTM.

**Implications** : le message le plus efficace n'est pas "le quantum computing est dangereux" (information) mais "votre rapport OSFI B-13 est attendu d'ici [date] et voici ce qu'il doit contenir" (urgence actionnable). Le meilleur prospect est celui qui a une échéance réglementaire proche, pas celui qui comprend le mieux la cryptographie post-quantique.

### 7.2 La fenêtre early mover en marché réglementaire

Moore (1991) et Thiel (2014) notent que dans les marchés créés par l'obligation (conformité, réglementation), les early movers bénéficient d'un avantage disproportionné : ils s'installent comme les experts de référence auprès des régulateurs, des associations professionnelles et des médias spécialisés avant que les concurrents établis s'organisent. Cet avantage se traduit en contrats récurrents (le client qui a utilisé la startup pour sa première évaluation PQC la rappellera pour la conformité annuelle) et en barrières à l'entrée réputationnelles.

L'urgence du timing pour ce projet est réelle : NIST FIPS 203-206 est finalisé depuis 2024 ; les régulateurs canadiens traduisent ces standards en obligations en 2025-2026 ; la fenêtre early mover se rétrécit à mesure que des acteurs établis (KPMG Cybersécurité, Deloitte Cyber, intégrateurs IBM) organisent leurs pratiques PQC.

### 7.3 La segmentation par urgence

Rogers (1962) et Moore (1991) segmentent les adopteurs par leur rapport à la nouveauté. Pour un service de conformité PQC, une segmentation plus utile que la courbe classique est la segmentation par urgence perçue :

**Segment 1 - Contraintes immédiates** : organisations ayant une obligation réglementaire avec une date précise (institutions financières OSFI, ministères fédéraux CST/CCCS). Ce segment n'a pas besoin d'éducation sur le "pourquoi" mais sur le "comment" et "par où commencer". C'est le beachhead idéal.

**Segment 2 - Anticipateurs** : organisations qui anticipent les obligations futures ou qui ont subi un incident de sécurité récent. Elles comprennent l'enjeu mais n'ont pas d'urgence immédiate. Le message doit créer l'urgence.

**Segment 3 - Sensibilisables** : organisations qui n'ont pas encore pris conscience de l'enjeu PQC. Nécessitent de l'éducation fondamentale. Segment à traiter via les conférences de sensibilisation ("La menace quantique") mais pas prioritaire pour les premières ventes.

## 8. Implications pour INTENTION.md

### 8.1 Ce que les théories valident dans l'intention actuelle

L'intention telle que formulée dans INTENTION.md actuel est valide sur plusieurs points confirmés par les théories mobilisées :

Le founder-market fit est fort (expertise DevSecOps + conformité cyber). Le timing du marché est favorable (standards NIST finalisés, réglementations en cours, marché non encore structuré). Le modèle d'affaires de services (pas de produit tech) est cohérent avec les capacités et l'objectif de revente rapide. L'objectif de revente en conservant 20-30 % des actions est légitime et correspond au profil "vouloir être riche" (Wasserman), ce qui implique une culture de délégation et d'ouverture.

### 8.2 Ce que les théories suggèrent de préciser ou d'ajouter

Quatre éléments méritent d'être renforcés dans INTENTION.md au regard des cadres théoriques :

**1. L'invariant vs. le variable** : INTENTION.md mélange l'intention profonde (mettre sur pied une startup de services PQC de haute valeur et la revendre) et les moyens actuels (conférences, formation, pilote). L'intention doit clairement distinguer ces deux niveaux. L'invariant doit résister aux pivots ; les moyens peuvent changer sans remettre l'intention en cause.

**2. Le profil de l'acquéreur cible** : si l'objectif est de revendre à un opérateur, INTENTION.md devrait préciser quel type d'acquéreur est visé et ce qu'il valorisera (portefeuille de clients, équipe, PI, réseau de partenaires). Cette clarté oriente chaque décision de construction de la startup.

**3. La thèse de conviction "why now"** : INTENTION.md cite la menace quantique mais ne formule pas clairement la fenêtre d'opportunité et l'urgence de la saisir maintenant. Articuler explicitement le timing renforce la conviction interne et la communication externe.

**4. La définition de succès minimal viable** : à quel moment peut-on dire que la startup a suffisamment prouvé son modèle pour être en position de cession ? Un jalon de succès minimal (premier client payant, deux pilotes livrés, revenus récurrents à X$, etc.) aide à orienter les décisions et à résister aux faux signaux.

### 8.3 Ce que les théories suggèrent de surveiller comme risques

Quatre risques principaux identifiés par les cadres théoriques :

**Risque de scaling prématuré** : diversifier l'offre (formations, services additionnels) avant d'avoir validé et livré le service pilote avec succès.

**Risque E-Myth** : les fondateurs restent en mode technicien (livrer l'expertise) au détriment du mode entrepreneur (construire la machine commerciale et la PI).

**Risque de timing manqué** : les concurrents établis s'organisent plus vite que prévu, réduisant la fenêtre early mover. À surveiller : mouvements de KPMG, Deloitte, IBM Consulting dans l'espace PQC-services au Canada.

**Risque de dépendance sur les conférences** : si les conférences ne convertissent pas en prospects qualifiés dans les 6 premiers mois, le plan de prospection doit être activé de manière plus agressive (cold outreach direct vers les ICP réglementés).

## Synthèse

Cinq cadres complémentaires à FND-001 sont mobilisables pour ce projet.

La **théorie de l'intention d'affaire** (Shane & Venkataraman, Sarasvathy, founder-market fit) valide que l'opportunité est réelle et que l'équipe est bien positionnée pour la saisir, à condition de distinguer l'invariant de l'intention et ses moyens variables. L'**analyse du succès entrepreneurial** (CBInsights, Startup Genome, Bill Gross, Graham) signale que le timing est favorable, que l'équipe est un actif fort, et que le risque principal est le scaling prématuré et le piège E-Myth. La **direction efficace en startup** (Gerber, Graham, Grove, Klein) recommande de maintenir un founder mode actif centré sur le développement commercial, de décider vite sous incertitude en s'appuyant sur l'expertise, et de pivoter sur les moyens sans jamais remettre l'intention en cause. Les **spécificités tech-services** rappellent que la propriété intellectuelle (formations, méthodologies, frameworks) est l'actif le plus important à construire pour la valorisation à la cession. Enfin, le **positionnement deeptech de service** (Hello Tomorrow, BCG, écosystème québécois) ouvre des canaux de financement, d'accélération et de crédibilité qui dépassent ceux d'une firme de conseil traditionnelle.

La lecture d'ensemble : l'intention d'affaire est solide. Les risques principaux ne sont pas stratégiques mais opérationnels et comportementaux. INTENTION.md doit être enrichi pour distinguer clairement l'invariant (l'intention profonde) des moyens (les vecteurs d'exécution actuels), préciser le profil de l'acquéreur cible et articuler la thèse de conviction "why now" de manière explicite.

## Limites et péremption

Cet essai mobilise des cadres théoriques établis dont la validité est large mais dont l'application au contexte PQC québécois en 2026 nécessite une validation empirique (entretiens de découverte client, analyse concurrentielle réelle). Les données CBInsights et Startup Genome sont à jour au moment de la rédaction mais sont des agrégats globaux qui peuvent ne pas refléter fidèlement la dynamique du marché deeptech-services cybersécurité au Canada. L'analyse du timing du marché PQC est fondée sur l'état des réglementations connu au 2026-06-19 et doit être mise à jour si les obligations OSFI ou ITSM évoluent. Les théories de direction (E-Myth, founder mode) sont des cadres de pensée, non des recettes : leur application dépend du contexte de l'équipe et doit être adaptée.

## Sources

- Alvarez, Sharon A. & Barney, Jay B. (2007). « Discovery and Creation: Alternative Theories of Entrepreneurial Action. » Strategic Entrepreneurship Journal.
- BCG & Hello Tomorrow (2021). « Deep Tech: The Great Wave. » Boston Consulting Group.
- CBInsights (2023). « The Top Reasons Startups Fail. » CBInsights Research Briefs.
- Chen, Andrew (2021). « The Cold Start Problem. » HarperBusiness.
- Christensen, Clayton (1997). « The Innovator's Dilemma. » Harvard Business School Press.
- Doz, Yves L. & Hamel, Gary (1998). « Alliance Advantage. » Harvard Business School Press.
- Duckworth, Angela (2016). « Grit: The Power of Passion and Perseverance. » Scribner.
- Duke, Annie (2018). « Thinking in Bets: Making Smarter Decisions When You Don't Have All the Facts. » Portfolio/Penguin.
- Gerber, Michael E. (1986). « The E-Myth: Why Most Businesses Don't Work and What to Do About It. » HarperBusiness.
- Graham, Paul (2024). « Founder Mode. » paulgraham.com.
- Gross, Bill (2015). « The Single Biggest Reason Why Startups Succeed. » TED Talk.
- Grove, Andrew S. (1983). « High Output Management. » Random House.
- Hamel, Gary & Prahalad, C.K. (1989). « Strategic Intent. » Harvard Business Review.
- Horowitz, Ben (2014). « The Hard Thing About Hard Things. » HarperBusiness.
- Ibarra, Herminia (2003). « Working Identity: Unconventional Strategies for Reinventing Your Career. » Harvard Business School Press.
- Klein, Gary (1998). « Sources of Power: How People Make Decisions. » MIT Press.
- Klein, Gary (2013). « Seeing What Others Don't: The Remarkable Ways We Gain Insights. » PublicAffairs.
- Moore, Geoffrey A. (1991). « Crossing the Chasm. » HarperBusiness.
- NIST (2024). « Federal Information Processing Standards 203, 204, 205, 206. » National Institute of Standards and Technology.
- Rogers, Everett M. (1962). « Diffusion of Innovations. » Free Press.
- Sarasvathy, Saras D. (2001). « Causation and Effectuation: Toward a Theoretical Shift from Economic Inevitability to Entrepreneurial Contingency. » Academy of Management Review.
- Shane, Scott (2000). « Prior Knowledge and the Discovery of Entrepreneurial Opportunities. » Organization Science.
- Shane, Scott & Venkataraman, Sankaran (2000). « The Promise of Entrepreneurship as a Field of Research. » Academy of Management Review.
- Startup Genome (2022). « Global Startup Ecosystem Report. » Startup Genome LLC.
- Taleb, Nassim Nicholas (2012). « Antifragile: Things That Gain from Disorder. » Random House.
- Thiel, Peter (2014). « Zero to One: Notes on Startups, or How to Build the Future. » Crown Business.
- Wasserman, Noam (2012). « The Founder's Dilemmas: Anticipating and Avoiding the Pitfalls That Can Sink a Startup. » Princeton University Press.
