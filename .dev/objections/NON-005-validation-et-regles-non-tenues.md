---
type: objection
id: NON-validation-et-regles-non-tenues
title: "Validation mécanique et règles écrites non tenues"
status: draft
initiateur: agent
effet: bloquant
etat: ouverte
porte-sur: [RES-ressource, RES-intention, RES-fait, RES-ontologie]
---

# NON-005 - Validation mécanique et règles écrites non tenues

> Le modèle repose sur des règles qu'aucun mécanisme ne vérifie, et il en conserve au moins trois qui sont écrites et notoirement transgressées. Une règle écrite et non tenue est pire que son absence, parce qu'elle fait croire à une garantie.

## Journal

- 2026-08-09 : ouverte par l'agent, à la production du premier jet des ressources fondamentales.

## Ce qui est contesté

Le fait que le modèle produit le 2026-08-09 s'appuie sur cinq règles dont aucune n'est vérifiable en l'état, et dont trois sont déjà transgressées dans le corpus.

| Règle | État dans le corpus |
|---|---|
| Une relation dont la cible n'existe pas est un défaut | Aucun détecteur. La couche relations était déjà déclarée par `resource-types.yaml` et n'a jamais été instanciée |
| Une ressource `point-fixe` est immuable | Écrite et transgressée. `RES-001` de `micrologic-clients` le reconnaît explicitement |
| Un fichier en édition `humain` n'est jamais modifié par l'agent | Transgressée au moins une fois, avec un log qui le documente. Copiée à l'identique dans trois dépôts |
| Le régime `hybride` implique une propriété par bloc | Aucun vérificateur. C'est le régime de trois des sept types définis |
| Un terme écarté par l'ontologie ne doit pas être employé | Aucun détecteur, alors que ce serait une simple recherche textuelle |

## Pourquoi cela ne peut pas rester implicite

`ANL-001` établit au défaut D2 que rien ne propage et rien ne valide, avec trois mesures : trente-trois `CLAUDE.md` pour dix-huit contenus, un `CONSTITUTION.md` de zéro octet non détecté, et trois `INTENTION.md` identiques désignant le mauvais client, accompagnés des mêmes dix-huit logs aux empreintes md5 identiques.

Le corpus a pourtant eu la validation mécanique entre les mains trois fois, avec CUE dans `specruptiva`, dans `poc-cue-validated-yaml-editor` et dans `jvtrudel-cv`, et une fois avec les validateurs d'ontologie de `nty`. Elle a été perdue chaque fois, sans décision écrite.

La formulation la plus juste du problème est celle de `RES-001` de `micrologic-clients` lui-même, à propos de l'immuabilité : soit elle est appliquée, soit elle est abandonnée ; l'état actuel est le pire des deux.

## Questions

### Q1 - Les règles non vérifiables doivent-elles rester écrites comme règles ?

Trois positions. Les maintenir, en assumant qu'elles sont des intentions et non des garanties, à condition de le dire. Les rétrograder en recommandations jusqu'à ce qu'un outil les vérifie. Les retirer, et n'écrire que ce qui est tenu.

**Réponse.**

### Q2 - L'immuabilité du point fixe est-elle appliquée, abandonnée, ou remplacée par un versionnage ?

`RES-005` déclare le recueil de faits `point-fixe`. La règle n'est tenue dans aucun dépôt du corpus. Trois positions tenables, une seule à choisir. La position actuelle, la déclarer et la transgresser, n'en est pas une.

**Réponse.**

### Q3 - Comment protéger effectivement un fichier en édition humaine exclusive ?

La règle a été violée une fois et le fichier a été copié à tort trois fois. Candidats : une empreinte enregistrée par `clia` qui signale toute modification ; un marqueur dans le frontmatter que l'agent doit vérifier avant d'écrire ; rien de plus que la règle, en assumant le risque.

**Réponse.**

### Q4 - Quelle validation minimale rendrait le modèle tenable, et à quel coût ?

Candidats par ordre de rentabilité apparente : vérifier la présence des champs obligatoires ; vérifier que les cibles de relations existent ; vérifier qu'aucun terme écarté n'est employé ; vérifier la conformité de nommage. Les quatre sont des vérifications textuelles. Faut-il les traiter dans la session d'outillage, ou plus tôt ?

**Réponse.**

### Q5 - Pourquoi la validation par schéma a-t-elle été abandonnée, et cette décision est-elle maintenue ?

Le corpus l'a perdue trois fois sans trace écrite. C'est l'une des quatre ruptures de cap non actées du défaut D3. La réponse à cette question est aussi la première trace de cette décision.

**Réponse.**

### Q6 - Le nombre de champs obligatoires doit-il être réduit tant qu'aucun outil ne les vérifie ?

`ANL-001` mesure que la seule règle de statut a déjà dérivé, avec `completed` et `complet` dans le même dépôt. Quatorze champs saisis à la main sans vérification produiront des écarts. Faut-il un noyau minimal obligatoire et le reste en facultatif ?

**Réponse.**

### Q7 - Qui est responsable de la conformité, en l'absence d'outil ?

Aujourd'hui : personne nommément. L'agent produit, l'humain relit. Faut-il déclarer explicitement que la conformité est de la responsabilité de l'agent au moment de produire, avec obligation de signaler ses propres écarts, ce qui est vérifiable dans le log ?

**Réponse.**

## Ce qui lèverait cette objection

Une réponse à Q1 et Q2. Ces deux réponses suffisent à sortir de l'état où des règles sont affirmées sans être tenues, qui est l'état actuel.

L'effet est déclaré `bloquant` pour une raison précise : les sept définitions produites ajoutent cinq règles non vérifiables aux règles existantes. Continuer à en ajouter avant d'avoir statué aggrave mécaniquement le défaut.

## Relations

- `objecte-a` [RES-001](../ressources/RES-001-ressource.md)
- `objecte-a` [RES-003](../ressources/RES-003-intention.md)
- `objecte-a` [RES-005](../ressources/RES-005-fait.md)
- `objecte-a` [RES-006](../ressources/RES-006-ontologie.md)
- `derive-de` [ANL-001](../analyses/ANL-001-observation-corpus-repos-et-pratiques/analyse-critique.md)
