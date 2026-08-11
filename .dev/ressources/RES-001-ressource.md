---
type: ressource
id: RES-001
title: "Ressource"
version: 2.0.0
status: draft
prefixe: RES
emplacement: ".dev/ressources/RES-<SEQ>-<SLUG>.md"
cycle-de-vie: vivant
edition: co-edition
famille: fondamentale
champs-obligatoires: [type, id, title, version, status, prefixe, emplacement, cycle-de-vie, edition, famille, champs-obligatoires, relations-admissibles, sections, skill, adr, statut]
relations-admissibles: [ressource, adr, decision]
sections: [Objet, Ce qu'est une ressource, Identité, Cycle de vie et versionnage, Régimes d'édition, Frontmatter, Relations, Points ouverts]
skill: skl-001-ressource
adr: ADR-009
statut: actif
---

# RES-001 - Ressource

> Une ressource est un fichier typé, versionné, produit dans un dépôt équipé, dont un type déclaré gouverne la forme. Cette définition se prend elle-même pour objet : elle définit le type dont elle est une instance, et fixe la forme de toutes les autres définitions.

## Objet

Ce document définit ce que `clia` appelle une **ressource**, et fixe la forme que doit prendre toute définition de type.

Il est la source de vérité du type `ressource`. Rien de ce qu'il porte n'est déclaré ailleurs.

Ce qu'il n'est pas : ni la décision d'introduire ce type, qui appartient à [ADR-001](../adr/ADR-001-adoption-de-la-notion-de-ressource.md), ni le processus de production d'une définition, qui appartient à [skl-001-ressource](../skills/skl-001-ressource/SKILL.md). Le triplet de ce type est complet depuis le 2026-08-09 ; les six autres types fondamentaux n'ont encore ni décision ni processus.

## Ce qu'est une ressource

**Définition en vigueur depuis le 2026-08-09**, révisée par `DCN-001` et instruite par `ADR-004` : une ressource est un **ensemble identifiable et auto-cohérent d'informations**. Son implémentation est indifférente : fichier, répertoire de fichiers, dépôt git, ou toute autre forme.

Le markdown à frontmatter YAML reste le **format par défaut** d'une ressource textuelle, pour les motifs que `ADR-001` D2 énonce et qui restent valables. Ce n'est plus une définition mais un choix de mise en oeuvre.

Sa fonction est de déplacer la vérité du travail hors de la conversation, qui est volatile, vers un objet versionné, qui persiste.

### Composition et atomicité

Une ressource est **composable** : elle peut être construite par assemblage d'autres ressources. Une telle ressource est dite **composite**, et son entrée est conventionnellement nommée `index`.

Chaque composant d'un composite est un **atome**, c'est-à-dire une ressource de plein droit : identifiable, auto-cohérent, typé, et déclarant son appartenance par la relation `fait-partie-de`. Un atome peut lui-même être composite ; la composition n'a pas de profondeur imposée.

**Propriété holographique.** Tout atome est auto-cohérent au même titre que son composite : il se lit seul et porte assez de contexte pour être compris seul. Un fichier qui ne se comprend qu'après avoir lu l'index de son composite n'est pas un atome, c'est une section mal découpée.

Un composite et ses atomes portent des **identités distinctes**. L'identité de l'atome n'est pas dérivée de celle du composite par concaténation.

Le **décompte** des instances d'un type compte les ressources et non les fichiers : un composite compte pour une.

Trois conséquences suivent de cette fonction, et elles sont plus importantes que le format.

Une ressource est **relisible sans mémoire de session**. C'est la contrainte dominante du régime de travail observé : le travail se fait par vagues séparées de plusieurs mois (`ANL-001`, `observations-pratiques.md`). Une ressource qui n'est compréhensible qu'en se souvenant de la conversation qui l'a produite a manqué son objet.

Une ressource est **opposable**. L'humain et l'agent peuvent tous deux s'y référer pour contester une avancée. C'est ce qui rend la gouvernance par objection possible.

Une ressource a un **coût**. Elle se produit, se relit, se maintient, se renumérote. Ce coût est un critère de conception au même titre que l'utilité, et le corpus montre qu'il a été systématiquement ignoré (`ANL-001`, D4).

## Les sept invariants

`FND-2026-08-07-notion-de-ressource` du dépôt `micrologic-clients` dégage sept invariants de la notion de ressource. Le tableau ci-dessous dit lesquels `clia` retient, et à quelles conditions.

| Invariant | Retenu | Comment, ou pourquoi pas |
|---|---|---|
| I1 Identité stable | **Non à l'interne**, oui à l'externe | À l'interne, le champ `id` porte un alias modifiable sous condition de propagation. L'identité stable relève du régime externe, non fixé. Voir la section « Identité » |
| I2 Type comme contrat | **Oui**, partiellement | Le type est déclaré et ses champs obligatoires sont écrits en un seul endroit. La vérification reste humaine, faute d'outil. Voir `NON-005` |
| I3 Représentation distincte | **Oui**, partiellement | Une ressource peut être publiée sous une autre forme. La relation entre les deux se déclare, elle n'est pas outillée |
| I4 Désiré et constaté | **Non**, transposé | Pas de dualité déclarative. Les sections « Points ouverts » et les objections en tiennent lieu |
| I5 Interface uniforme | **Non**, pour l'instant | Chaque type a son skill. `clia` est précisément l'outil qui rendrait une interface commune possible ; la question est reportée à la session d'outillage. Voir `NON-006` |
| I6 Cycle de vie explicite | **Oui** | Trois classes, plus le champ `status` |
| I7 Extensibilité | **Oui** | Ajouter un type demande une définition et un skill, sans toucher au harnais |

## Identité

L'identification se fait à deux niveaux, fixés par `ADR-008` D1.

| Régime | Portée | Contrainte | Porteur |
|---|---|---|---|
| **Interne** | Le dépôt | Relatif et auto-cohérent | L'alias, `<PREFIX>-<SEQ>` par défaut |
| **Externe** | Hors du dépôt | Complet | Non fixé, `ADR-008` D7 |

### L'alias interne

`<PREFIX>-<SEQ>` désigne une ressource à l'intérieur du dépôt. Exemples : `RES-001`, `NON-014`, `ADR-006`.

C'est un **alias**, non l'identité. `ADR-008` D2.

| Propriété | Porteur | Rôle |
|---|---|---|
| Alias interne | Champ `id`, `<PREFIX>-<SEQ>` | Cible de tout renvoi interne |
| Libellé | Slug du nom de fichier | Lisible, révisable sans effet |
| Nom canonique du type | Slug du nom de fichier d'une définition | Ce que porte le champ `type` des instances |
| Localisation | Chemin | Déductible du type et du nom |
| Identifiant intrinsèque | Identifiant de contenu git | Suivi de l'historique, attestation des modifications |

Trois règles.

**Corriger un slug n'a aucune conséquence.** Le slug ne participe pas à l'alias. `ADR-008` D4.

**Déplacer un fichier ne casse aucun renvoi.** Les renvois ciblent l'alias.

**Changer un alias est permis, à condition de propager.** Tout changement met à jour, dans le même geste, toutes les références internes qui le citent. `ADR-008` D3. Aucune commande ne le fait et aucun contrôle ne le vérifie : `NON-023` Q3.

L'alias est **relatif au dépôt**. `RES-001` ne désigne la même chose que dans un dépôt donné.

### L'identité

L'identité désigne l'**oeuvre**. `ADR-008` D5.

Aucun champ ne la porte à l'interne. `NON-023` Q1.

### L'ergonomie

L'alias satisfait trois contraintes vérifiables : lisible, retenable en huit caractères au plus, tapable sans copier-coller. `PDC-002`.

L'exigence est opposable. Un arbitrage qui l'affaiblit produit une objection.

## Cycle de vie et versionnage

Trois classes. Le cycle de vie commande le nommage et le versionnage.

| Classe | Nommage | Versionnage | Types concernés |
|---|---|---|---|
| **Vivant** | Séquencé, `<PREFIXE>-<SEQ>-<SLUG>` | Semver dans le frontmatter | Ressource, Contexte, Intention, Ontologie, Concept |
| **Point fixe** | Daté, `<PREFIXE>-<SEQ>-<SLUG>` | Aucun. Une modification produit une nouvelle instance datée | Faits, analyses, fondations, logs, publications |
| **Travail** | Séquencé | Aucun. Un journal en tête du document suffit | Objection, plans |

Règles de semver pour les ressources vivantes. Majeur : changement incompatible du sens ou du contrat. Mineur : ajout rétrocompatible. Correctif : clarification sans effet sémantique.

**Le versionnage relève de la publication externe.** `ADR-008` D5. À l'interne, les modifications sont tracées par l'historique, dont `ANL-005` établit qu'il fournit un identifiant de contenu par version et le diff entre deux d'entre elles. La fonction interne du champ `version` est ouverte : `NON-023` Q4.

**Réserve reprise et assumée.** La règle d'immuabilité du point fixe n'a été tenue dans aucun dépôt du corpus, et `RES-001` de `micrologic-clients` le reconnaît explicitement. La règle est conservée et l'écart est signalé. Trois positions sont tenables : l'appliquer, l'abandonner, ou la remplacer par un versionnage. Voir `NON-005`.

## Régimes d'édition

Quatre régimes. Chaque définition de type déclare le sien.

| Régime | Qui écrit | Qui lit et commente |
|---|---|---|
| `humain` | L'humain seul. L'agent ne modifie jamais | L'agent |
| `ia` | L'agent seul | L'humain |
| `hybride` | Les deux, avec **propriété par bloc** : l'initiateur possède les blocs d'ouverture, l'autre partie les blocs de réponse | Les deux |
| `co-edition` | Les deux, sans découpage par bloc | Les deux |

Le régime `humain` a une histoire : il vient d'un incident réel, documenté par le premier log du dépôt `commission-scolaire-de-la-capitale`, où l'agent avait écrasé un `INTENTION.md` avec du contenu générique. La règle est fondée sur l'expérience, non sur un principe.

Le régime `humain` n'est aujourd'hui protégé par rien d'autre que la règle elle-même. Voir `NON-005`.

## Frontmatter d'une définition de type

Toute définition de type porte les quatorze champs suivants. Les cinq premiers sont ceux que porte n'importe quelle ressource ; les neuf suivants décrivent le type défini.

| Champ | Portée | Rôle |
|---|---|---|
| `type` | La définition | Vaut `ressource` |
| `id` | La définition | Identité stable, `RES-<SLUG>` |
| `title` | La définition | Nom lisible du type défini |
| `version` | La définition | Semver de la définition |
| `status` | La définition | `draft`, `stable` ou `deprecated` |
| `prefixe` | Le type défini | Les trois lettres du type |
| `emplacement` | Le type défini | Répertoire et motif de nom des instances |
| `cycle-de-vie` | Le type défini | `vivant`, `point-fixe` ou `travail` |
| `edition` | Le type défini | `humain`, `ia`, `hybride` ou `co-edition` |
| `champs-obligatoires` | Le type défini | Clefs que le frontmatter des instances doit porter |
| `relations-admissibles` | Le type défini | Types vers lesquels une instance peut pointer |
| `skill` | Le type défini | Le skill de production, ou `aucun` |
| `adr` | Le type défini | La décision qui a acté le type, ou `aucun` |
| `statut` | Le type défini | `actif`, `deprecie` ou `non-installe` |

La cohabitation, dans un même frontmatter, des métadonnées de la définition et des propriétés du type défini est un compromis assumé : elle évite un second fichier par type. Elle demande en retour de savoir lire la colonne « Portée » du tableau ci-dessus.

## Relations

Une relation est un renvoi typé d'une ressource vers une autre, écrit dans une section `## Relations` du corps du document, sous forme de lien markdown accompagné du nom de la relation et de l'`id` de la cible.

Vocabulaire hérité de `resource-types.yaml` de `clia`, réduit à ce qui est effectivement employé.

| Relation | Sens |
|---|---|
| `specifie` | La source fixe la forme de la cible |
| `derive-de` | La source procède de la cible |
| `compose` | La source assemble la cible comme atome |
| `fait-partie-de` | La source est un atome de la cible |
| `remplace` et `est-remplacee-par` | Succession d'identité |
| `reference` | Renvoi simple, sans engagement |
| `objecte-a` | La source conteste la cible |
| `repond-a` | La source répond à la cible |

Une relation dont la cible n'existe pas est un défaut. Rien ne le détecte aujourd'hui, et c'est la lacune la plus structurante du modèle : la couche relations était déjà déclarée par `resource-types.yaml` et n'a jamais été instanciée. Voir `NON-005`.

Pour une définition de type, les relations admissibles se limitent à `ressource` : une définition ne pointe que vers d'autres définitions. Ses renvois vers un ADR ou un skill passent par ses champs `adr` et `skill`.

## Le critère de départage

Trois documents accompagnent un type. Ce qui va dans lequel :

| Question | Document |
|---|---|
| **Ce qu'est** le type | La définition, `RES` |
| **Pourquoi** il a été adopté | La décision, `ADR` |
| **Comment** on le produit | Le processus, `skl` |

Test pratique, repris de `micrologic-clients` : un passage qui cesserait d'être vrai en changeant d'avis relève de la décision ; un passage qui décrit une suite d'actions relève du processus ; un passage qui décrit une propriété du type telle qu'elle est aujourd'hui relève de la définition.

Ce triplet a un coût, sujet de `NON-002` : sept types font vingt-et-un documents, trente types en font quatre-vingt-dix.

## Ce qui n'est pas une ressource

| Objet | Pourquoi |
|---|---|
| `CLAUDE.md`, `ARCHITECTURE.md` | Fichiers de harnais. Noms fixes, autorité sur le comportement de l'agent, hors du système de types |
| `workspace/session.md` | Point d'entrée humain. Éphémère par destination |
| `.dev/templates/*.template.md` | Squelettes destinés à être copiés puis renseignés |
| Matériel source importé | Conservé verbatim, non conforme par nature. Sa place est `source-material/` |
| Assets binaires, PDF générés | Portée non tranchée. `ADR-004` D1 les rend possibles sans les modéliser. Voir `NON-006` |

Le statut de `INTENTION.md` est traité par `RES-003` et n'est pas tranché ici : c'est le seul fichier de racine dont la nature est disputée.

## Relations

- `reference` [ANL-001](../analyses/ANL-001-observation-corpus-repos-et-pratiques/index.md)
- `derive-de` [ADR-001](../adr/ADR-001-adoption-de-la-notion-de-ressource.md)
- `derive-de` [ADR-004](../adr/ADR-004-nature-composable-de-la-ressource.md)
- `derive-de` [ADR-005](../adr/ADR-005-regroupement-fonctionnel-des-ressources.md)
- `derive-de` [ADR-008](../adr/ADR-008-regime-d-identification-a-deux-niveaux.md)
- `reference` [skl-001-ressource](../skills/skl-001-ressource/SKILL.md)

## Points ouverts

Portés par des objections, non enterrés ici.

| Question | Objection |
|---|---|
| Ce qui porte l'identité de l'oeuvre à l'interne | `NON-023` |
| Sort d'un numéro libéré, l'interdiction de renuméroter étant levée | `NON-023` |
| Vérification de la propagation d'un changement d'alias | `NON-023` |
| Fonction interne du champ `version` | `NON-023` |
| Forme de l'identifiant externe | `NON-023` |
| Redondance du champ `id` avec le nom de fichier | `NON-019` |
| Coût du triplet définition, décision, processus ; seuil d'admission d'un type | `NON-002` |
| Absence de validation mécanique ; règles écrites et non tenues | `NON-005` |
| Portée du modèle : textuel seulement, ou aussi les assets et les données | `NON-006` |
| Granularité minimale utile d'un atome | `NON-016` |
| Portée de la propriété holographique | `NON-016` |
