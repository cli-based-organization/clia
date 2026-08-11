---
type: skill
id: skl-003
name: skl-003-ressource-de-conception
version: 0.1.0
status: draft
description: >-
  Produire ou modifier une ressource de la famille **conception** : Analyse `ANL`, Recherche de fondation `FND`, Principe de conception `PDC`, Méthodologie `MET`..
  À utiliser après `skl-001-ressource` partie A, qui porte les règles communes à
  toute ressource. Ce skill ne porte que ce qui est propre à la famille.
famille: conception
---

# Skill - Ressource de la famille conception

> Ce skill porte le **processus commun à la famille**, conformément à `ADR-005` D4. Les règles communes à toute ressource vivent dans `skl-001-ressource` partie A. Les spécificités de chaque type vivent dans sa définition.

## Trois niveaux, à lire dans cet ordre

| Niveau | Où | Ce qu'il porte |
|---|---|---|
| Méta-type | `skl-001-ressource` partie A | Frontmatter, identité, écriture, relations, quand objecter |
| Famille | ce document | Le processus commun à la famille conception |
| Type | la définition `RES` du type | Champs propres, sections, frontières, test d'admission |

Ne pas produire une ressource de cette famille sans avoir lu la définition de son type : elle déclare ses `champs-obligatoires` et ses `sections`, et le gabarit correspondant en est dérivé.

## Types de la famille

Analyse `ANL`, Recherche de fondation `FND`, Principe de conception `PDC`, Méthodologie `MET`.

## Le mouvement propre à cette famille

Une ressource de conception produit du savoir en vue d'une décision. Le mouvement est celui de l'**établissement** : poser une question, dire d'où vient ce qu'on avance, et dire où l'on s'arrête.

La distinction interne à la famille tient à l'origine du contenu. Si le contenu vient d'autrui avec des sources, c'est une fondation. S'il vient d'un existant observé, c'est une analyse. S'il énonce une contrainte durable, c'est un principe. S'il décrit un savoir-faire rejouable, c'est une méthodologie.

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

## Contrôle propre à la famille conception

**Vérifier que les limites sont écrites.** Toute ressource de cette famille porte une rubrique disant ce qu'elle n'a pas pu établir. Un document de conception silencieux sur ses manques se lit comme complet, et c'est le défaut le plus coûteux de la famille.

Pour une fondation, vérifier en outre que chaque URL répond, et consigner la date de vérification.

## Le type Principe de conception est en édition humaine

`CONSTITUTION.md` C1 : seuls les humains créent un principe de conception. Un agent ne crée ni ne modifie un `PDC`.

**Ce que l'agent fait.** `clia res new principe-de-conception "<description>"`, puis il s'arrête.

**Pourquoi ce type et pas les autres de la famille.** Un principe est opposable : l'humain l'invoque pour refuser, l'agent l'invoque pour objecter. Un principe qu'un agent se donne à lui-même ne contraint personne.

Les autres types de la famille, `ANL`, `FND` et `MET`, restent en édition `ia`.

## Le piège de cette famille

Produire du savoir qui ne servira à rien. Une analyse sans question posée est une description. Une fondation sans décision à éclairer est un exercice. Avant de commencer, nommer la décision que le document doit rendre possible.

## Relations

- `derive-de` [skl-001-ressource](../skl-001-ressource/SKILL.md)
- `derive-de` [ADR-005](../../adr/ADR-005-regroupement-fonctionnel-des-ressources.md)
