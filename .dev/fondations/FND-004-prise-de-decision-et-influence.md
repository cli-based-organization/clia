---
type: fondation
version: 0.1.0
title: "Prise de décision et influence stratégique dans la vente de services PQC"
---

# FND-004 - Prise de décision et influence stratégique dans la vente de services PQC

> **Statut** : instable (version initiale)
>
> **Date** : 2026-06-24
>
> **Provenance** : rapatriée depuis `cryptosecops/stratégie/.dev/fondations/FND-005-prise-de-decision-et-influence.md` (tâche 17, demande explicite). Contenu de domaine business (vente PQC, CryptoSecOps) conservé fidèlement ; à traiter comme savoir importé, non comme ressource générique du harnais.
>
> **Objectif** : analyser les mécanismes de prise de décision et d'influence dans les champs sociaux pertinents pour la pénétration du marché PQC (cybersécurité, financier, gouvernemental, technologique), de manière à identifier les leviers d'activation de la demande, les dynamiques sociales en jeu, et les techniques de persuasion les plus efficaces pour accélérer la conversion commerciale.

## 1. Introduction et cadrage théorique

### 1.1 Question centrale

Comment convertir la conscience d'une menace (quantique) en urgence d'action réelle, puis en décision d'achat ? Autrement dit : quels sont les mécanismes psychologiques, sociaux et organisationnels qui transforment une personne ou une organisation de l'inertie vers la mobilisation, puis vers l'engagement d'une ressource financière significative ?

### 1.2 Défis spécifiques au contexte PQC

Trois asymétries rendent ce problème particulièrement difficile :

1. **Asymétrie temporelle** : la menace quantique est présentée comme réelle mais future (3 à 10 ans). Les décideurs actuels optimisent pour les urgences immédiates (ransomwares, conformité réglementaire à court terme), pas pour les menaces lointaines.

2. **Asymétrie de compréhension** : comprendre le risque PQC exige de la maîtrise technique (cryptographie, algorithmes, architecture informatique). La majorité des décideurs - CISO, CFO, Chief Compliance Officers - n'ont pas cette maîtrise et ne peuvent donc pas évaluer indépendamment la validité de la menace.

3. **Asymétrie de coût** : une migration PQC est coûteuse, disruptive, et implique une réingénierie des systèmes critiques. Les bénéfices attendus (protection contre une menace future) sont hypothétiques, alors que les coûts sont certains et immédiats.

### 1.3 Approche théorique

Cet essai mobilise trois courants complémentaires :

1. **Théorie comportementale de la décision** (Kahneman, Tversky) : comment les décideurs réels (contrairement aux hypothèses de la théorie classique) utilisent des heuristiques, sont sujets aux biais cognitifs, et réagissent différemment aux gains et aux pertes.

2. **Théorie de l'influence sociale** (Cialdini, Milgram) : les mécanismes par lesquels les individus changent d'opinion et d'action sous l'effet de la pression sociale, de l'autorité, de la réciprocité et de la preuve sociale.

3. **Théorie des champs sociaux** (Bourdieu, déjà utilisée dans le document post-quantum-startup-scenario.md) : comment la légitimité, le capital symbolique et les règles implicites du jeu varient selon le contexte institutionnel.

## 2. Théorie comportementale de la décision sous risque et incertitude

### 2.1 De la théorie rationnelle à la rationalité limitée

La théorie économique classique suppose des décideurs qui :
- maximisent l'utilité attendue (calcul rationnel des risques et des gains) ;
- disposent d'une information complète ;
- n'ont pas de biais cognitifs ;
- agissent de manière cohérente et prévisible.

La réalité décisionnelle des organisations est radicalement différente. Herbert Simon (1957) a introduit le concept de **bounded rationality** (rationalité limitée) : les décideurs sont contraints par trois facteurs.

**1. Limites cognitives** : capacité de traitement de l'information limitée. Un CISO reçoit des dizaines de demandes de budget pour des initiatives de sécurité concurrentes. Il ne peut pas évaluer en détail chacune ; il utilise des heuristiques (règles de décision simplifiées) basées sur l'expérience passée, les recommandations d'experts de confiance, ou la disponibilité mentale (ce qui vient à l'esprit le plus facilement).

**2. Incertitude de l'environnement** : l'avenir est imprévisible. Le risque PQC est intrinsèquement incertain. Personne ne sait si les ordinateurs quantiques utiles apparaîtront en 5 ans ou en 20 ans, si les algorithmes post-quantiques du NIST résisteront à des attaques futures, ou si la menace « harvest now, decrypt later » se concrétisera.

**3. Coûts de recherche d'information** : se renseigner complètement coûte du temps et des ressources. Pour une PME ou même pour un CISO d'une banque, passer 40 heures à évaluer les risques PQC détaillés n'est pas une option viable. Le décideur arrête la recherche dès qu'il a suffisamment d'information pour justifier une décision acceptable, pas une décision optimale (satisficing vs. maximizing, Simon 1957).

### 2.2 Prospect theory et aversion à la perte

Kahneman et Tversky (1979) ont montré expérimentalement que les individus ne réagissent pas symétriquement aux gains et aux pertes. La **Prospect Theory** identifie deux asymétries clés.

**Aversion à la perte** : la perte de X $ crée un malaise psychologique plus intense que le plaisir procuré par un gain de X $. Mathématiquement, la courbe d'utilité est plus raide en négatif qu'en positif. Implication : une communication axée sur le risque (« vous allez perdre X $ si vous ne faites rien ») est souvent plus motivante qu'une communication axée sur le bénéfice (« vous gagnerez Y $ en migrant »).

**Effet de certitude** : les individus surpondèrent les probabilités certaines ou très hautes (ex : 95 %) par rapport aux probabilités intermédiaires (ex : 60 %). Implication : si vous pouvez reframer le risque PQC comme « pratiquement certain » plutôt que « probable mais lointain », vous augmentez la saillance psychologique du problème.

### 2.3 La théorie du coût cognitif de la décision

Plus une décision comporte d'étapes, de critères à évaluer ou d'incertitude, plus le coût cognitif est élevé pour le décideur, et plus celui-ci hésite et retarde. C'est particulièrement vrai pour les décisions organisationnelles complexes, qui impliquent plusieurs parties prenantes (CISO, CFO, équipe technique, légal, comité de direction).

Pour une migration PQC :
- Diagnostic : 40 à 60 heures de travail de l'équipe interne
- Évaluation d'architecture : 20 à 30 heures
- Appels d'offres et évaluation de fournisseurs : 30 à 50 heures
- Mise en œuvre : 500 à 2000 heures selon la complexité
- Formation et documentation : 50 à 100 heures

Coût cognitif organisationnel total : significatif. Les dépenses augmentent, le timeline s'allonge, plusieurs départements doivent se coordonner.

**Levier de réduction du coût cognitif** : simplifier la décision par étapes. Au lieu de demander « voulez-vous lancer une migration PQC complète ? » (décision massive), proposer d'abord un diagnostic rapide et peu coûteux (« permettez-nous 2 jours d'évaluation gratuite ») qui réduit l'incertitude et pavé le chemin vers les décisions ultérieures.

### 2.4 Le framing effect

La manière de présenter une décision influence le choix, même si le contenu objectif est identique. Kahneman et Tversky (1981) ont montré que les décideurs qui reçoivent un problème présenté en termes de **pertes** réagissent différemment que ceux qui reçoivent le même problème présenté en termes de **gains**.

Exemple pour le PQC :

**Framing gain** : « Une migration vers les algorithmes post-quantiques protégera vos données contre les futures attaques quantiques, positionnant votre organisation comme un leader en sécurité. »

**Framing perte** : « Sans une migration rapide vers les algorithmes post-quantiques, vos données chiffrées aujourd'hui seront vulnérables au déchiffrement dans 5 à 10 ans, exposant votre organisation à un risque de conformité non documenté et à une perte de réputation. »

Empiriquement, le second framing est plus motivant pour le changement organisationnel. Pourquoi ? Parce qu'il active l'aversion à la perte, qui est psychologiquement plus puissante que la recherche de gain.

## 3. Influence sociale et persuasion : le modèle de Cialdini

### 3.1 Les six principes de l'influence

Robert Cialdini a identifié six principes universels de l'influence sociale, validés par des décennies de recherche comportementale. Appliqués au contexte PQC, ils opèrent comme suit.

### 3.2 Principe 1 : Réciprocité

**Théorie** : les individus ont une forte tendance à rendre la pareille. Si quelqu'un vous aide, vous avez un sentiment d'obligation de l'aider en retour.

**Application dans la vente PQC** : offrir un service à forte valeur perçue gratuitement (diagnostic, évaluation de risque, note technique) crée une obligation informelle de réciprocité. L'organisation qui reçoit un diagnostic détaillé de son exposition PQC gratuit ressent une dette morale envers le fournisseur. Cette dette augmente la probabilité que le prospect propose un contrat de suivi ou au minimum reste engagé dans la conversation.

**Contraste avec la vente transactionnelle** : la plupart des vendeurs tentent de maximiser la valeur extraite à chaque interaction (« achetez maintenant, discount temporaire »). La réciprocité fonctionne mieux quand elle est asymétrique au départ : le fournisseur donne plus qu'il ne prend au début, créant un déséquilibre psychologique qui pousse le prospect à rééquilibrer en achetant.

### 3.3 Principe 2 : Engagement et cohérence

**Théorie** : une fois qu'une personne prend une décision ou adopte une position, elle est fortement motivée à rester cohérente avec cette position, même quand les circonstances changent.

**Application dans la vente PQC** : la séquence suivante augmente la probabilité d'une migration complète :

1. Obtenir un engagement petit et facile : « accepteriez-vous une évaluation de risque rapide de 2 heures ? »
2. L'organisation dit oui.
3. Au cours de l'évaluation, documenter les gaps et les risques, et les faire valider par le CISO et le CFO.
4. L'organisation a maintenant publiquement (ou semi-publiquement) reconnu le problème.
5. Le coût psychologique de revenir sur cette reconnaissance est élevé : admettre que le problème n'existe pas ou n'est pas urgent changerait la position adoptée.
6. La décision de migration devient plus probable, car elle est cohérente avec la reconnaissance précédente du problème.

**Mécanique** : ce principe explique pourquoi les appels d'offres formels et les diagnostics documentés sont plus puissants que les conversations exploratoires informelles. Une fois l'organisation engagée publiquement sur un diagnostic, elle ne peut pas facilement l'ignorer.

### 3.4 Principe 3 : Preuve sociale

**Théorie** : les individus décident correctement (ou du moins acceptent plus facilement une décision) quand ils voient que d'autres la font. La preuve sociale est particulièrement puissante quand l'individu est incertain et quand « les autres » sont perçus comme similaires ou crédibles.

**Application dans la vente PQC** : la preuve sociale opère à plusieurs niveaux.

1. **Niveau réglementaire** : les décisions des régulateurs (NIST finalise les standards PQC en 2024, OSFI publie B-13) sont des signaux puissants pour les CISO. Un CISO peut se dire : « Si le régulateur dit que c'est important, c'est que ce ne sont pas des consultants qui venaient vendre du vent. »

2. **Niveau de pairs** : une banque qui lance une migration PQC en est à un stade pilote. Mais si trois autres banques (du même secteur, de taille similaire) le font aussi, cela devient une preuve sociale du secteur. Les pairs réduisent l'incertitude.

3. **Niveau de clients** : si la startup a déjà migré trois organisations, ce fait devient une preuve sociale puissante pour les prospects. Une première référence « sortante » (cas d'usage publié) est plusieurs fois plus efficace qu'un cas d'usage anonyme (« nous avons aidé une banque »).

**Limitation importante** : la preuve sociale fonctionne quand elle est authentique et crédible. Les fausses recommandations ou les cas d'usage exagérés détruisent la crédibilité.

### 3.5 Principe 4 : Autorité

**Théorie** : les individus sont plus susceptibles de suivre les conseils d'une personne qu'ils perçoivent comme une autorité crédible dans un domaine pertinent.

**Application dans la vente PQC** : trois formes d'autorité opèrent.

1. **Autorité formelle** : titres, certifications (CISSP, CISM), positions officielles (« Chief Security Officer of Bank X »). Cette forme est facile à imiter (faux certificats) mais reste puissante.

2. **Autorité de connaissance** : demonstrated expertise. Un expert reconnu en cryptographie qui publie des articles techniques, participe à des conférences ou co-signe des RFC a une autorité fondée sur la substance, pas juste sur le titre.

3. **Autorité de réseau** : accès et relations. Si un consultant PQC est recommandé par un pair de confiance (« mon ancien collègue qui travaille maintenant à la banque X me l'a recommandé »), cette relation crée une transitivité d'autorité.

**Levier pour la startup** : investir dans la construction du capital symbolique collectif (voir post-quantum-startup-scenario.md) est un investissement dans l'autorité. Publier des notes techniques, participer à des conférences de l'industrie, publier des codes open source - tout cela accumule de l'autorité pour les conversations commerciales futures.

### 3.6 Principe 5 : Appréciation (Liking)

**Théorie** : les individus sont plus susceptibles d'être influencés par quelqu'un qu'ils aiment. L'appréciation est produite par : la similarité (« cette personne est comme moi »), les compliments, la coopération perçue, ou l'attrait physique.

**Application dans la vente PQC** : ce principe fonctionne de manière subtile.

1. **Similarité** : si le conseiller PQC vient du même environnement que le prospect (ex : ancien CISO devenu conseiller), ce background partagé crée une connexion rapide. Cela n'est pas de la manipulation ; c'est une résonance authentique.

2. **Coopération** : les approches où le consultant et l'organisation travaillent ensemble sur un diagnostic (plutôt que le consultant qui livre un diagnostic au prospect) crée une relation coopérative. La coopération produit de l'appréciation, qui produit plus de transparence et d'engagement.

3. **Complexité organisationnelle** : dans les ventes B2B, il y a rarement une personne décisionnaire unique. Il y a un CISO, un CFO, une équipe technique, etc. Si le consultant a une bonne relation avec chacun de ces acteurs (plutôt que juste avec le CISO), il crée plusieurs canaux d'influence.

## 4. Psychologie des décideurs : types de décideurs et illusios organisationnels

### 4.1 Cartographie des décideurs par champ

Le document post-quantum-startup-scenario.md identifie cinq champs sociaux (cybersécurité, financier, gouvernemental, académique, technologique), chacun avec ses propres décideurs et sa propre logique. Chaque décideur joue un « jeu » spécifique, avec ses propres règles non écrites et ses propres critères d'évaluation.

**Champ cybersécurité** :
- **CISO / CSO** : joue le jeu de la conformité et de la protection. Son illusio : « Mon rôle est de réduire le risque et de démontrer cette réduction. » Activation : parlez en termes de risque résiduel, de documentation de la diligence, de couverture d'audit.
- **Architecte sécurité** : joue le jeu de la faisabilité technique. Son illusio : « Je dois trouver une solution qui fonctionne dans nos systèmes existants. » Activation : démonstration technique, cas d'usage, évaluation de compatibilité.

**Champ financier** :
- **CFO / Chief Financial Officer** : joue le jeu du coût et du ROI. Son illusio : « Chaque dollar dépensé doit produire un retour mesurable. » Problème : le ROI d'une migration PQC est difficile à chiffrer. Levier : reframer en termes de réduction du coût du risque non documenté (coût d'un potentiel audit manqué ou d'une conformité réglementaire manquée).
- **Chief Compliance Officer** : joue le jeu de la conformité réglementaire. Son illusio : « Mon rôle est de garantir que l'organisation ne viole pas ses obligations légales. » Activation : lier PQC aux attentes réglementaires (OSFI B-13, ITSM.40.001), aux attentes d'audit.

**Champ gouvernemental** :
- **Responsable de la sécurité IT gouvernementale** : joue le jeu de la souveraineté et de la protection des données nationales. Son illusio : « Je dois protéger les systèmes de l'État contre les adversaires. » Activation : parlez de menaces étatiques spécifiques (Chine, Russie, acteurs state-sponsored).

### 4.2 Modèle de prise de décision multi-stakeholder en organisation

Dans presque tous les cas réels, la décision de migrer vers le PQC n'est pas prise par une seule personne. Elle implique :

1. **L'initiateur** : souvent un CISO qui perçoit le risque et cherche des solutions.
2. **L'évaluateur technique** : l'architecte sécurité ou l'équipe infrastructure qui évalue la faisabilité.
3. **L'approbateur budgétaire** : le CFO ou le VP Opérations qui approuve la dépense.
4. **L'approuveur réglementaire** : le responsable de conformité ou l'avocat général qui valide la conformité légale.
5. **Le champion exécutif** : souvent un C-level (CTO, CRO) qui doit "sponsoriser" le projet devant le comité exécutif.

**Défi** : chacun de ces acteurs a un illusio différent, des critères d'évaluation différents, et une aversion au risque différente. Une présentation qui convainct le CISO (« le risque est réel ») ne convaincra peut-être pas le CFO (« le coût est justifié »). Une présentation qui convainct le CFO (« c'est un investissement en conformité ») ne convaincra peut-être pas l'architecte technique (« comment on l'implémente ? »).

**Levier stratégique** : au lieu de chercher à convaincre une seule personne, la startup doit préparer des argumentaires différents pour chaque type de décideur, et s'assurer que chacun voit le projet à travers son propre cadre de référence.

### 4.3 Biais décisionnels organisationnels

Au-delà des biais individuels (disponibilité mentale, ancrage), les organisations exhibent des biais décisionnels collectifs.

**Biais de confirmation** : une fois que le CISO a décidé que le PQC est un risque, l'organisation tend à chercher (et à trouver) des preuves que le risque est réel, tout en ignorant les preuves contraires. Implication : une fois que vous avez « activé » le problème chez un décideur clé, ce décideur fera le travail pour vous en cherchant des preuves du risque.

**Biais de statu quo** : les organisations préfèrent rester dans l'état actuel, sauf si la douleur du changement est clairement inférieure à la douleur de l'inaction. Implication : vous devez non seulement montrer que le risque PQC existe, mais aussi que le coût de la migration est inférieur au coût de l'inaction.

**Biais de groupe (groupthink)** : quand plusieurs décideurs sont réunis, la pression à la conformité au groupe peut amener des individus à supprimer des objections légitimes. Implication : dans les comités de décision, la première personne à exprimer une objection diminue le groupthink ultérieur. Une question du type « Y a-t-il des risques que je n'aurais pas couverts ? » peut activer le raisonnement critique du groupe.

## 5. La menace future et l'urgence artificielle

### 5.1 Le problème paradoxal : urgent mais lointain

Le risque PQC est présenté comme réel et grave, mais éloigné temporellement (3 à 10 ans pour les ordinateurs quantiques utiles). C'est un cas particulier d'un problème décisionnel large : comment mobiliser une organisation sur une menace future ?

La psychologie de la procrastination (Piers Steel, 2007) montre que les individus et les organisations ont tendance à pondérer les tâches selon deux facteurs : l'importance perçue et l'imminence perçue. Une tâche qui est très importante mais peu imminente est systématiquement repoussée en bas de la liste de priorités, même si rationnellement elle devrait être en haut.

**Levier stratégique** : augmenter l'imminence perçue de l'action, pas l'imminence perçue de la menace (qui ne peut pas changer - la menace est réellement lointaine).

Comment ? En reliant le PQC à des urgences immédiates : audit réglementaire imminent, obligation de conformité prochaine, incident de sécurité récent dans le secteur.

### 5.2 Stratégies de création d'urgence légitime

**1. Urgence réglementaire** : OSFI B-13 (Canada) et ITSM.40.001 (Québec) créent une pression réglementaire mesurable pour les institutions financières et gouvernementales. Cette urgence est réelle et légitime, pas artificielle. Implication : ciblez d'abord les organisations soumises à ces réglementations, car l'urgence externe est déjà présente.

**2. Urgence de cycle de vie** : une organisation qui planifie une refonte de son infrastructure cryptographique (ex : renouvellement d'une PKI, migration vers le cloud) a une fenêtre de vulnérabilité temporelle. L'urgence de planifier la migration PQC avant cette refonte est réelle.

**3. Urgence de pair** : si un pair du prospect a lancé une migration PQC, cela crée une urgence sociale. « Si mon concurrent a commencé, je dois aussi. »

**4. Urgence de crise** : un incident de sécurité récent dans le secteur, une publication académique montrant une nouvelle vulnérabilité cryptographique, une notification de régulateur - ces événements externes créent une urgence réelle et justifiée.

**Attention** : créer une urgence artificielle (faux délais, faux scénarios catastrophes) détruit la crédibilité à long terme. L'urgence légitime est plus puissante et plus durable.

## 6. Application intégrée : cartographie des leviers d'influence par type de décideur

Pour chaque type de décideur clé, cette section identifie l'illusio, les biais les plus pertinents, les principes d'influence les plus efficaces, et les urgences légitimes à activer.

### 6.1 CISO / Chief Security Officer

**Illusio** : protéger l'organisation, démontrer la diligence aux auditeurs, réduire le risque résiduel.

**Biais clés** : aversion au risque non documenté, biais de confirmation (une fois convaincu, il cherche des preuves du problème), biais de statu quo (préfère connaître les risques actuels à découvrir de nouveaux risques).

**Principes d'influence les plus puissants** :
- **Autorité** : une publication du NIST, une recommandation d'une agence réglementaire (ANSSI, CSE), ou une présentation d'un expert reconnu en cryptographie augmente drastiquement la crédibilité du message.
- **Preuve sociale** : « Trois CISO du secteur financier ont lancé une évaluation PQC cette année » est plus convaincant que « le risque existe ».
- **Réciprocité** : offrir un diagnostic gratuit et détaillé crée une obligation d'évaluation sérieuse du rapport.

**Urgences légitimes à activer** :
- OSFI B-13 ou ITSM.40.001 si applicable.
- Prochaine campagne d'audit (« le vérificateur va poser cette question »).
- Besoin documenté de conformité NIST.

**Message calibré** : « Vous avez un angle mort de conformité non documenté. Voici comment le combler. »

### 6.2 Chief Financial Officer / Chief Compliance Officer

**Illusio** : gérer le coût, démontrer un ROI, éviter les non-conformités réglementaires.

**Biais clés** : biais d'ancrage (le premier chiffre entendu influence fortement la négociation), biais de sunk cost (réticence à abandonner un investissement antérieur dans la cryptographie existante).

**Principes d'influence les plus puissants** :
- **Engagement et cohérence** : obtenir un accord préalable sur la définition du risque (« acceptez-vous que le risque PQC existe ? ») rend difficile le refus ultérieur du budget (« si le risque existe, il faut l'atténuer »).
- **Réciprocité** : un diagnostic gratuit qui chiffre précisément le coût du risque non géré crée une obligation de sérieux.

**Urgences légitimes à activer** :
- Obligation réglementaire imminente avec pénalités chiffrées.
- Attente des auditeurs externes (« l'audit annuel va poser cette question »).
- Coût potentiel d'une non-conformité (amende réglementaire, perte de contrats, augmentation du coût du capital).

**Message calibré** : « Votre exposition PQC non documentée représente un risque de conformité de X millions $. Une évaluation de 2 jours à Y coût réduit cette exposition à Z %. »

### 6.3 Architecte technique / Équipe infrastructure

**Illusio** : faisabilité technique, compatibilité avec l'existant, impact minimal sur les systèmes critiques.

**Biais clés** : biais de complexité (tendance à supposer que la solution est plus complexe qu'elle ne l'est réellement), méfiance envers les nouvelles technologies non éprouvées.

**Principes d'influence les plus puissants** :
- **Preuve sociale** : cas d'usage concrets, démonstrations d'implémentation réelle dans des environnements similaires.
- **Autorité de connaissance** : code open source audité, démonstrations techniques, guides pas-à-pas.

**Urgences légitimes à activer** :
- Planification imminente de refonte infrastructure.
- Cycles de renouvellement matériel ou logiciel existants.

**Message calibré** : « Voici comment intégrer CRYSTALS-Kyber dans votre pipeline CI/CD existant en trois étapes. Voici le code et les tests. »

### 6.4 Responsable gouvernemental / Sécurité nationale

**Illusio** : souveraineté, protection contre les adversaires étatiques, conformité aux mandats de sécurité nationale.

**Biais clés** : aversion au risque géopolitique, méfiance envers les fournisseurs étrangers ou non éprouvés, biais d'information compartimentée (l'information circule dans des cercles fermés).

**Principes d'influence les plus puissants** :
- **Autorité institutionnelle** : publications d'agences nationales (CSE au Canada, ANSSI en France, NSA/CISA aux États-Unis).
- **Preuve sociale** : d'autres agences gouvernementales ou pays alliés ayant lancé des programmes PQC.

**Urgences légitimes à activer** :
- Mandats publics des agences nationales de cybersécurité.
- Menaces géopolitiques documentées (ex : révélations d'espionnage informatique par un État).

**Message calibré** : « L'agence X [CSE, ANSSI] a mandaté la migration PQC. Voici comment nous avons aidé Y [agence similaire] à se conformer. »

## 7. Synthèse : architecture de persuasion pour une stratégie GTM

### 7.1 Séquence type d'influence

Pour convertir un prospect inactif en client, la séquence suivante mobilise les principes établis ci-dessus.

**Phase 1 : Activation (semaine 1-2)**
- Objectif : faire exister le problème dans l'esprit du décideur.
- Mécanisme : preuve sociale (« trois pairs ont lancé une évaluation ») + urgence légitime (« OSFI B-13 sera imposée en 2027 ») + framing perte (« votre exposition non documentée »).
- Livrable : conversation.

**Phase 2 : Éducation (semaine 2-4)**
- Objectif : augmenter la compréhension du risque et de la solution.
- Mécanisme : autorité (expert) + réciprocité (diagnostic gratuit) + engagement (faire exprimer le problème en même temps).
- Livrable : rapport d'évaluation détaillé.

**Phase 3 : Justification (semaine 4-8)**
- Objectif : documenter l'urgence et la justification pour l'approbation interne.
- Mécanisme : engagement et cohérence (le prospect a reconnu le problème, il doit maintenant en documenter la solution) + preuve sociale (cas d'usage similaires).
- Livrable : proposition ou appel d'offres formel.

**Phase 4 : Décision (semaine 8-16)**
- Objectif : convertir en contrat.
- Mécanisme : simplification du coût cognitif (réduire les points de friction), réciprocité inverse (créer un petit avantage ou urgence pour le prospect qui décide rapidement).
- Livrable : contrat signé.

### 7.2 Outils et formats

Pour chaque phase, le format du livrable influence l'efficacité.

**Activateurs puissants** :
- Note technique ou whitepaper : crée de l'autorité et de la preuve sociale.
- Conférence ou webinaire : touche un audience large, crée de l'autorité de preuve sociale.
- Diagnostic gratuit : réduit la friction, crée de la réciprocité.
- Recommandation pair-à-pair : crée de l'appréciation et de la preuve sociale.

**Erreurs courantes** :
- Présentation trop longue : surcharge cognitive, le décideur repousse.
- Focus sur le produit/la solution, pas sur le problème : le décideur ne se voit pas dans la présentation.
- Absence de urgence : le projet part en backlog sans fin.
- Faux cas d'usage : détruit la crédibilité d'autorité.

## 8. Conclusion

La conversion d'une menace perçue (PQC) en action organisationnelle (migration) n'est pas principalement un problème technique ou informatif. C'est un problème de psychologie décisionnelle et d'influence sociale.

Les trois leviers les plus puissants pour accélérer cette conversion sont :

1. **Autorité crédible** : construire une présence visible et prouvable en tant qu'expert (publications, cas d'usage, réseau).

2. **Réciprocité sincère** : offrir de la valeur réelle (diagnostics détaillés, insights, perspectives) sans attendre immédiatement un retour, en sachant que la réciprocité arrive naturellement.

3. **Urgence légitime** : relier le PQC aux obligations réglementaires réelles, aux cycles de vie des systèmes réels, et aux décisions de pairs réelles - pas à des urgences artificielles.

Pour la startup PQC, cela signifie que le chemin vers la traction commerciale n'est pas « faire la meilleure technologie » ou « avoir le prix le plus bas ». C'est « être perçu comme un expert crédible, généreux et pertinent ». Le reste suit naturellement.
