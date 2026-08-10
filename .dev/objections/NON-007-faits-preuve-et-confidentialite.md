---
type: objection
id: NON-faits-preuve-et-confidentialite
title: "Faits, preuve et confidentialité"
status: draft
initiateur: agent
effet: conditionnel
etat: ouverte
porte-sur: [RES-fait]
---

# NON-007 - Faits, preuve et confidentialité

> `RES-005` propose de consigner des faits, dont certains privés ou concernant des tiers identifiables, dans des dépôts dont plus de la moitié n'ont aucun remote et dont aucun ne porte de règle de confidentialité. Le type crée une responsabilité que rien n'encadre.

## Journal

- 2026-08-09 : ouverte par l'agent, à la production du premier jet des ressources fondamentales.

## Ce qui est contesté

Trois aspects du type `faits`.

Le critère qui départage un fait consigné d'un simple champ de provenance : `RES-005` propose la réutilisation par plus d'un document, ce qui est un critère de commodité et non de nature.

Le régime de diffusion : `RES-005` introduit un champ `diffusion` à trois valeurs, `public`, `prive` et `confidentiel`, sans dire qui garantit la contrainte ni ce qui se passe quand elle est violée.

La granularité par recueil : `RES-005` fait du recueil l'unité de fichier et du fait l'unité de sens, avec des adresses de la forme `FCT-<DATE>-<SLUG>#F03`. Cette solution n'a jamais été essayée.

## Pourquoi cela ne peut pas rester implicite

Le besoin qui a fait naître ce travail est de prouver l'adéquation d'un candidat à un poste, et les deux essais de fondation qui le documentent portent sur la journalisation des faits privés et sur la persuasion. Le sujet est donc, dès l'origine, celui de faits sur des personnes.

Or `ANL-001` mesure que les dépôts à contenu sensible sont les moins encadrés du corpus. `cryptosecops/noumanity+qguard`, registre de documents légaux et confidentiels partagés avec un tiers, ne porte aucun harnais, seulement un `.claude/`. `noumanity-deals/noumanity-redaction-ententes` porte cinquante-trois markdown de rédaction d'ententes, sans harnais, avec huit fichiers non commités. `noumanity-talents/guillaume_viau-trudel` porte vingt-cinq fichiers sur une personne nommée, sans un seul commit et sans remote.

Un type qui invite à consigner systématiquement des faits datés et attribués, dans ce contexte, augmente le risque avant d'augmenter la rigueur.

## Questions

### Q1 - Un fait est-il une ressource, ou un champ de provenance des autres ressources ?

`RES-005` propose la coexistence, avec un critère de réutilisation. La position concurrente est que le format OKF adopté par `micrologic-clients` suffit, avec sa famille `sources` et sa convention d'acteur `human:<id>`, et qu'un type distinct est redondant.

**Réponse.**

### Q2 - Qui garantit le respect du champ `diffusion`, et que se passe-t-il en cas de violation ?

Aujourd'hui rien ne l'empêche : un fait marqué `confidentiel` peut être cité dans un livrable destiné à un tiers sans qu'aucun mécanisme ne le signale. Candidats : une règle de harnais opposable à l'agent ; une vérification par `clia` avant production d'un livrable ; rien, en assumant que la responsabilité est humaine.

**Réponse.**

### Q3 - Des faits concernant une personne nommée peuvent-ils être consignés sans son accord ?

La question est juridique autant que méthodologique, et le corpus contient déjà des dépôts nommés d'après des personnes. `RES-005` prévoit que la valeur `confidentiel` nomme la contrainte, ce qui documente le problème sans le régler.

**Réponse.**

### Q4 - La granularité par recueil est-elle la bonne, et l'adressage par ancre est-il tenable ?

Une adresse de la forme `FCT-2026-08-09-corpus-des-depots#F03` suppose que la numérotation interne d'un recueil ne change jamais. Un recueil `point-fixe` le garantit en théorie, et `NON-005` établit que l'immuabilité n'est tenue nulle part.

**Réponse.**

### Q5 - Faut-il consigner les faits déjà produits par `ANL-001` ?

`ANL-001` énonce des dizaines de mesures sans produire aucun recueil. Certaines sont reproductibles par une commande, donc non consignables selon le test d'admission de `RES-005`. D'autres portent sur un état qui a déjà changé, et sont perdues si elles ne sont pas consignées. Faut-il un recueil de reprise ?

**Réponse.**

### Q6 - La distinction entre fait et preuve est-elle opérationnelle ?

`RES-005` la reprend de `FND-2026-08-08-persuasion-preuve-et-auditoires` : un fait est neutre, ce qui fait preuve dépend de l'auditoire, donc un recueil porte le mode de vérification et jamais la force persuasive. Cette règle est juste et exigeante. Est-elle applicable par un agent qui produit un recueil dans le cadre d'un travail persuasif, comme une candidature ?

**Réponse.**

### Q7 - Le type doit-il exister avant que la question de la confidentialité soit réglée ?

C'est la question de fond de cette objection. Le type augmente la rigueur et le risque simultanément. Faut-il le déclarer `non-installe` jusqu'à ce que Q2 et Q3 aient reçu réponse ?

**Réponse.**

## Ce qui lèverait cette objection

Une réponse à Q2 et Q7. Les deux portent sur la responsabilité, qui est la seule chose que le type ne peut pas se donner à lui-même.

L'effet est `conditionnel` : le type est utilisable, et tout recueil produit avant résolution est réputé provisoire, en particulier s'il contient des faits marqués `prive` ou `confidentiel`.

## Relations

- `objecte-a` [RES-005](../ressources/RES-005-fait.md)
- `reference` [NON-005](NON-005-validation-et-regles-non-tenues.md)
- `derive-de` [ANL-001](../analyses/ANL-001-observation-corpus-repos-et-pratiques/repos/02-repos-de-travail.md)
