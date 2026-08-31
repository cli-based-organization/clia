# Le critère de PLN-013 éprouvé par jugement, tâche 9 de SES-002

Troisième versement, `MET-003` étape 3.

`derive-de` `TSK-05-resultat-validation_2026-08-13-12-49_quatorze-controles.md`, contrôle 4, déclaré **« réussi à la lettre et faiblement à l'esprit »**.

## Pourquoi ce versement

Le chantier A de `PLN-013` demande que le critère range les 39 objections **sans cas ambigu**. La première exécution l'a éprouvé par recherche de mots dans le corps des documents : le mot « supprim » suffisait à ranger une objection du côté « irréversible ». Un critère qui demande un jugement ne s'éprouve pas par `grep`.

Les 39 objections ont été relues et rangées une à une par les quatre lignes du filtre de `MET-005` étape 2.

## Le rangement

**L'agent devait s'arrêter — 26 objections.**

| Objection | La ligne du filtre qui arrête |
|---|---|
| `NON-001` Identité et nommage | Se tromper coûte une migration : tous les renvois du système |
| `NON-002` Coût du modèle | Deux lectures incompatibles : produire ou non 81 documents |
| `NON-003` Frontière CTX/INT/FCT | Migration des instances si la frontière bouge |
| `NON-004` Frontière du savoir | Idem |
| `NON-005` Règles non tenues | Retirer une règle touche `CONSTITUTION.md` et les ADR |
| `NON-006` Portée du système | Décision de portée : engage tout le reste |
| `NON-007` Faits et confidentialité | Irréversible : des données sur des tiers, dans des dépôts sans règle |
| `NON-008` Régime de travail et arbitrage | Gouvernance : qui tranche est une question à l'humain |
| `NON-009` Statut de la session | Deux documents d'autorité se contredisent |
| `NON-010` Rôles des trois agents | Gouvernance |
| `NON-014` Trilemme de nommage | Touche `INTENTION.md`, régime humain strict |
| `NON-015` Mécanismes d'entrée | Faire entrer deux mécanismes dans le modèle l'engage |
| `NON-016` Composition et atomicité | Un mot de la demande humaine n'est pas défini |
| `NON-017` Familles et processus | L'agent a substitué sa proposition à ce que la tâche demandait |
| `NON-019` Identifiant par séquence | Migration |
| `NON-023` Identification à deux niveaux | Migration, et une règle laissée sans remplaçant |
| `NON-024` Ressources d'autorité écrites par l'agent | `CONSTITUTION.md` C1, explicitement |
| `NON-026` ADR dérivé | Le sort des 16 ADR existants est une migration |
| `NON-027` PDC produit par l'agent | `CONSTITUTION.md` C1 |
| `NON-028` Système de journalisation | Migrer 116 logs est coûteux à défaire |
| `NON-031` Cycle de vie collectif | 137 ressources à reclasser |
| `NON-032` Deux frontières et l'ontologie | Circulaire : deux lectures, aucune amorce |
| `NON-033` Autorité de création des principes | `CONSTITUTION.md` C1 |
| `NON-037` Forme de la session | Régime humain : gabarit d'entrée de l'humain |
| `NON-038` Ce que `PLN-008` laisse ouvert | Prescrit par la tâche : « un seul NON pour ce qui n'est pas SMART » |
| `NON-039` Ce que `PLN-009` laisse ouvert | Idem |

**L'agent pouvait décider et avancer — 12 objections.**

| Objection | Pourquoi elle n'avait pas à s'arrêter |
|---|---|
| `NON-011` Types sans définition | Écrire les définitions manquantes : document d'agent, réversible |
| `NON-012` Granularité et décompte | Le décompte est du code |
| `NON-018` Spécification et implémentation | Écrire les specs est long, pas irréversible |
| `NON-020` Seuil de densité inatteignable | Le seuil est dans une `MET`, et la mesure était faite : 6,4 |
| `NON-021` Aucune recherche préalable | Ajouter une étape à une méthodologie d'agent |
| `NON-022` Charge du type Décision | Le contrôle manquant est du code |
| `NON-025` Skills dérivables | Le générateur est du code |
| `NON-029` Registres et leur tenue | Automatiser la tenue est du code |
| `NON-030` Trois familles sans générateur | Le générateur est du code |
| `NON-034` Nettoyage non mesurable | Lire et nettoyer : réversible, document d'agent |
| `NON-035` `status` constant | **Démontré** : `PLN-011` l'a fait en une heure, tâche 9 |
| `NON-036` Frontière du bogue | **Démontré** : le type existe et porte trois instances |

**Un cas que le filtre ne range pas — `NON-013`.**

Le document est un brouillon de deux lignes, sans champ `etat`, sans question posée. **Ce n'est pas une objection** : le filtre ne s'y applique pas, faute d'incertitude formulée. C'est un déchet à supprimer ou à rédiger, et il appartient à l'humain d'en décider — l'objection est son instrument.

## Ce que le rangement établit, et ce qu'il corrige

| | Par recherche de mots | Par jugement |
|---|---|---|
| S'arrêter | 29 | **26** |
| Avancer | 10 | **12** |
| Non rangé | 0 | **1**, et nommé |

**Douze objections sur trente-neuf n'avaient pas lieu d'être ouvertes** — 31 %. Deux d'entre elles, `NON-035` et `NON-036`, ont été traitées depuis en avançant, sans que la décision coûte quoi que ce soit : c'est la preuve la plus directe que le filtre range juste.

**Le « 0 ambigu » de la première exécution était un artefact.** Une heuristique range toujours tout : c'est ce qu'elle fait. Le jugement, lui, a buté sur un cas — et ce cas était une vraie anomalie du dépôt, invisible jusqu'ici.

## La cible de PLN-013 reste à mesurer

Le plan vise « moins d'objections ouvertes que de tâches sur les dix tâches suivantes ». Zéro objection ouverte depuis. **Une tâche sur dix ne mesure rien** : la cible se vérifiera à la tâche 19.
