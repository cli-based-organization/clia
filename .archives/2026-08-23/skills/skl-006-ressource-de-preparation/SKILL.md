---
type: skill
id: skl-006
name: skl-006-ressource-de-preparation
version: 0.1.0
status: draft
description: >-
  Produire ou modifier une ressource de la famille **preparation** : Décision d'architecture `ADR`, Spécification `SPC`, Requis fonctionnel `RQF`, Requis non fonctionnel `RQNF`, Cas d'usage `USE`, Comportement attendu `CMP`, Plan `PLN`..
  À utiliser après `skl-001-ressource` partie A, qui porte les règles communes à
  toute ressource. Ce skill ne porte que ce qui est propre à la famille.
famille: preparation
---

# Skill - Ressource de la famille preparation

> Ce skill porte le **processus commun à la famille**, conformément à `ADR-005` D4. Les règles communes à toute ressource vivent dans `skl-001-ressource` partie A. Les spécificités de chaque type vivent dans sa définition.

## Trois niveaux, à lire dans cet ordre

| Niveau | Où | Ce qu'il porte |
|---|---|---|
| Méta-type | `skl-001-ressource` partie A | Frontmatter, identité, écriture, relations, quand objecter |
| Famille | ce document | Le processus commun à la famille preparation |
| Type | la définition `RES` du type | Champs propres, sections, frontières, test d'admission |

Ne pas produire une ressource de cette famille sans avoir lu la définition de son type : elle déclare ses `champs-obligatoires` et ses `sections`, et le gabarit correspondant en est dérivé.

## Types de la famille

Décision d'architecture `ADR`, Spécification `SPC`, Requis fonctionnel `RQF`, Requis non fonctionnel `RQNF`, Cas d'usage `USE`, Comportement attendu `CMP`, Plan `PLN`.

## Le mouvement propre à cette famille

Une ressource de préparation prépare une réalisation. Le mouvement est celui de l'**engagement conditionnel** : dire ce qu'on va faire, à quelles conditions, et ce qui ferait changer d'avis.

La famille se lit en chaîne : un cas d'usage part du but d'un acteur, une spécification fixe le comportement sans technologie, un requis le traduit en contrainte contextuelle, un comportement attendu le rend vérifiable, un ADR acte un choix, un plan ordonne le travail.

## Procédure

1. **Lire la définition du type.** Ses champs obligatoires et ses sections sont la forme à respecter, et le gabarit `.dev/templates/<type>.template.md` en est dérivé.
2. **Vérifier le test d'admission**, quand la définition en porte un. Une ressource qui ne le passe pas ne doit pas être produite : ouvrir une objection.
3. **Créer le fichier par `clia res new <type> "<description>"`.** L'outil pose le frontmatter, attribue le discriminant selon le cycle de vie déclaré, et laisse les valeurs propres à renseigner.
4. **Rédiger**, section par section, dans l'ordre déclaré.
5. **Renseigner les champs marqués `À RENSEIGNER`.** Ils sont posés par l'outil et leur valeur dépend du contenu.
6. **Déclarer les relations.** Vocabulaire admis dans `skl-001` règle A4, restreint par le champ `relations-admissibles` du type.
7. **Valider.** Contrôles V1 à V10 de `skl-001`, plus le contrôle propre à cette famille ci-dessous, plus la validation de schéma.

## Validation de schéma

Depuis le 2026-08-10, le frontmatter de chaque type a un schéma CUE dérivé de sa définition.

```sh
python3 -c "
import yaml,json,datetime
def c(o):
    if isinstance(o,dict): return {k:c(v) for k,v in o.items()}
    if isinstance(o,list): return [c(v) for v in o]
    if isinstance(o,(datetime.date,datetime.datetime)): return o.isoformat()
    return o
print(json.dumps(c(yaml.safe_load(open('$F').read().split('---')[1])),ensure_ascii=False))" > /tmp/fm.json
cue vet -d '#RES_<type>' .dev/schemas/commun.cue .dev/schemas/<type>.cue /tmp/fm.json
```

Un échec signale un champ absent, mal orthographié, ou dont la valeur sort de l'énumération. C'est le premier contrôle de fond que ce dépôt possède.

## Contrôle propre à la famille preparation

**Vérifier la traçabilité vers l'amont.** Un requis sans spécification parente, un comportement sans requis, un plan sans intention sont orphelins, et un orphelin signale soit un maillon manquant, soit une exigence inventée en chemin.

Pour un ADR, vérifier en outre que chaque décision porte son alternative écartée et, quand elle est révisable, sa porte de sortie.

## Écrire un plan : ce qui bloque se déclare avec ce qui le lève

**Un plan qui déclare un blocage déclare par quel geste il se lève.** Sans quoi le blocage est une constatation, et personne ne sait quoi en faire.

| Ce qui ne suffit pas | Ce qu'il faut écrire |
|---|---|
| « Ce chantier attend `DCN-016` » | « Ce chantier attend que `DCN-016` passe de `suspendue` à `en-vigueur`. Geste : `clia res edit DCN-016`. Qui : l'humain. Débloque : 5 chantiers » |
| « Un préalable est ouvert » | Lequel, quel geste le lève, qui peut le faire |

**Trois éléments, à chaque blocage déclaré** : le geste, qui peut le faire, ce qu'il débloque.

**Le motif est mesuré.** `BUG-005` : `PLN-007` déclarait son blocage en prose depuis le 2026-08-11, dans ses objections et sa section « Statut ». Le geste qui le levait n'apparaissait dans aucune commande, et l'humain est resté deux jours sans savoir quoi faire.

**Ce que la règle rend possible.** `clia focus` lit les décisions suspendues et les range en `A APPROUVER`. Un blocage écrit selon cette règle devient une ligne de la file de l'humain ; un blocage écrit en prose reste invisible.

**Le contrôle.** Après avoir écrit un plan qui déclare un blocage, lancer `clia focus --humain` : le geste doit y apparaître. S'il n'y est pas, c'est le plan qui est mal écrit, ou le dépôt qui ne sait pas encore voir ce type de blocage — et alors c'est un bogue, non une prose à étoffer.

## Le piège de cette famille

Décider sans dire ce qui ferait changer d'avis. `ANL-001` mesure au défaut D3 que le corpus compte quatre-vingt-neuf ADR et aucun sur ses quatre ruptures de cap réelles : les décisions y sont abandonnées en silence plutôt que révisées, faute de porte de sortie écrite.

## Journalisation

`MET-003` fixe le procédé. La règle qui commande les autres : **chaque information de log est écrite au moment où le travail qu'elle rapporte est fait**, jamais reconstruite à la clôture.

| Moment | Log à écrire |
|---|---|
| Avant tout travail | `TSK-01-demande` |
| Avant de produire | `TSK-02-analyse` |
| **Pendant**, à chaque lot de livrables | `TSK-03-fait`, un versement par lot |
| Avant de valider | `TSK-04-validation` |
| Après les contrôles | `TSK-05-resultat-validation` |
| À la clôture | `TSK-06-next`, `TSK-07-commit-message` |

Un log ne rapporte qu'une tâche, et il ne se réécrit pas : le type est `point-fixe`.

## Relations

- `derive-de` [skl-001-ressource](../skl-001-ressource/SKILL.md)
- `derive-de` [ADR-005](../../adr/ADR-005-regroupement-fonctionnel-des-ressources.md)
