# Analyse avant réalisation, tâches 23 et 24

## Le conflit que la tâche 23 pose à l'agent

La demande dit « générer un PDC ». `CONSTITUTION.md` C1, que l'agent a écrit la veille, l'interdit et déclare qu'aucune consigne ordinaire ne peut le lever, « y compris une demande explicite écrite dans le fichier de session ».

Trois conduites étaient possibles.

**Produire le gabarit vide et s'arrêter.** Respecte la lettre de C1. Rend la tâche sans objet : l'humain a demandé un contenu.

**Produire le document sans le signaler.** Rend le service. Masque une transgression de la règle la plus récente du dépôt.

**Produire le document et le déclarer non actif.** Retenu. Le contenu est disponible, la question est visible, et le régime appliqué est celui que `DCN-013` fixe pour les décisions : un premier jet d'agent n'est pas actif tant que l'humain ne l'a pas approuvé.

**Ce que cette conduite emprunte sans autorisation.** L'analogie entre `DCN` et `PDC`. `DCN-013` ne parle que des décisions. C1 nomme les deux types dans la même phrase, ce qui rend l'analogie plausible et non fondée. `NON-027` Q1 la porte.

## Ce que le corpus archivé apporte à la tâche 23

`ANL-016` documente le modèle d'origine : issue non SMART, ticket extrême SMART, timebox de douze heures, CLI dédié.

Elle porte surtout une objection résolue qui va contre la demande : « Extreme SMART ne devient **pas** un `PDC` ». Le motif, dans l'objection N4 de la même analyse, est précis : deux des cinq critères ne contraignaient rien dans le dépôt, et le nom promettait plus que le contenu.

**Ce que `PDC-003` fait de ce motif.** Il ne l'écarte pas, il l'applique. Le principe déclare, critère par critère, lequel contraint, lequel est seulement mesuré, et lequel est sans objet. C'était exactement la suggestion de l'objection archivée.

**Ce qu'il ne règle pas.** Le choix du type. `NON-027` Q2 le porte.

## La mesure qui rend PDC-003 immédiatement contestable

Le principe déclare non conformes les deux seuls plans du dépôt. `PLN-002` porte huit livrables là où E1 en exige un.

Un principe non actif qui déclare non conforme l'existant est ambigu : le lecteur ne sait pas si `PLN-002` est en faute.

La mesure est écrite dans le principe plutôt que tue, et `NON-027` Q3 demande ce qu'on en fait.

## Le point de la tâche 24 qui change la position de l'agent

`DCN-013` est **plus permissive** que `CONSTITUTION.md` C1, écrit par l'agent à la tâche 20.

| Document | Ce qu'il dit |
|---|---|
| C1 | « Un agent IA ne crée ni ne modifie une décision » |
| `DCN-013` | « une [IA] peut faire un premier jet de DCN. Mais ce premier jet n'est pas actif tant qu'il n'a pas été approuvé » |

`DCN-013` est l'autorité ultime par son propre énoncé, donc C1 lui est subordonné.

**Ce que le conflit a coûté.** Deux gabarits vides, `DCN-011` et `DCN-012`, laissés aux tâches 21 et 22 au motif que C1 l'exigeait. Sous `DCN-013`, l'agent aurait pu les rédiger en régime suspendu, et l'humain aurait eu deux brouillons à approuver plutôt que deux formulaires à remplir.

## L'interprétation que l'agent produit, et pourquoi elle est suspecte

`NON-026` Q3 donne le motif du mécanisme : forcer l'action consciente de l'humain.

L'agent en tire que ce n'est pas la **rédaction** qui est protégée mais l'**intention** : un humain qui tape `clia res new decision "..."` a formulé le sujet ; ce qu'un agent écrit ensuite reste sous son contrôle si l'approbation est un geste distinct.

Cette lecture est cohérente avec la justification écrite. Elle est aussi celle qui élargit le plus ce que l'agent peut faire, et c'est l'agent qui la produit.

Elle est donc signalée comme interprétation dans `ANL-006` C3, et `PLN-003` porte l'objection en toutes lettres : le chantier A lève un interdit qui vise l'agent, et c'est l'agent qui le propose.

## Ce que la mise en conformité coûte réellement

La mesure la plus lourde n'est pas dans les sources : elle a été produite pour l'analyse.

| Mesure | Valeur |
|---|---|
| ADR du dépôt | 17 |
| ADR sans `DCN` source | **11** |
| Renvois de la forme `ADR-<SEQ> D<n>` dans les documents actifs | **248**, dans 58 fichiers |

Rendre les ADR non actifs, ce que `NON-026` Q1 demande, invalide le fondement cité par ces 248 renvois. Aucune source ne dit comment traiter cet intervalle, et l'agent ne peut pas écrire les onze `DCN` manquantes.

C'est ce qui rend le chantier D bloquant et sans bonne option.

## Ce qui a été mesuré plutôt qu'estimé

Trois chiffres ont été corrigés après vérification : six ADR ont une source et non cinq, trente gabarits existent et non trente-deux, et les renvois sont deux cent quarante-huit et non « environ quarante » comme la première rédaction l'estimait.

L'écart sur le dernier est d'un facteur six, et il change la lecture du chantier E.
