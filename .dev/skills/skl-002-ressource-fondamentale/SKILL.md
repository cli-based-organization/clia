---
type: skill
id: skl-002
name: skl-002-ressource-fondamentale
version: 0.1.0
status: draft
description: >-
  Produire ou modifier une ressource de la famille **fondamentale** : Ressource `RES`, Contexte `CTX`, Intention `INT`, Objection `NON`, Faits `FCT`, Ontologie `ONT`, Concept `CPT`..
  À utiliser après `skl-001-ressource` partie A, qui porte les règles communes à
  toute ressource. Ce skill ne porte que ce qui est propre à la famille.
famille: fondamentale
---

# Skill - Ressource de la famille fondamentale

> Ce skill porte le **processus commun à la famille**, conformément à `ADR-005` D4. Les règles communes à toute ressource vivent dans `skl-001-ressource` partie A. Les spécificités de chaque type vivent dans sa définition.

## Trois niveaux, à lire dans cet ordre

| Niveau | Où | Ce qu'il porte |
|---|---|---|
| Méta-type | `skl-001-ressource` partie A | Frontmatter, identité, écriture, relations, quand objecter |
| Famille | ce document | Le processus commun à la famille fondamentale |
| Type | la définition `RES` du type | Champs propres, sections, frontières, test d'admission |

Ne pas produire une ressource de cette famille sans avoir lu la définition de son type : elle déclare ses `champs-obligatoires` et ses `sections`, et le gabarit correspondant en est dérivé.

## Types de la famille

Ressource `RES`, Contexte `CTX`, Intention `INT`, Objection `NON`, Faits `FCT`, Ontologie `ONT`, Concept `CPT`.

## Le mouvement propre à cette famille

Une ressource fondamentale définit ou porte un élément du socle conceptuel. Le mouvement est celui de la **délimitation** : dire ce que la chose est, puis ce qu'elle n'est pas, puis où passe la frontière avec ses voisines.

La rubrique « Ce que ce n'est pas » est obligatoire dans cette famille, et c'est elle qui coûte le plus d'effort. Une définition fondamentale qui ne se distingue pas de ses voisines produit des recouvrements que tout le modèle paiera.

## Procédure

1. **Lire la définition du type.** Ses champs obligatoires et ses sections sont la forme à respecter, et le gabarit `.dev/templates/<type>.template.md` en est dérivé.
2. **Vérifier le test d'admission**, quand la définition en porte un. Une ressource qui ne le passe pas ne doit pas être produite : ouvrir une objection.
3. **Créer le fichier par `clia res new <type> "<description>"`.** L'outil pose le frontmatter, attribue le discriminant selon le cycle de vie déclaré, et laisse les valeurs propres à renseigner.
4. **Rédiger**, section par section, dans l'ordre déclaré.
5. **Renseigner les champs marqués `À RENSEIGNER`.** Ils sont posés par l'outil et leur valeur dépend du contenu.
6. **Déclarer les relations.** Vocabulaire admis dans `skl-001` règle A4, restreint par le champ `relations-admissibles` du type.
7. **Valider.** Contrôles V1 à V9 de `skl-001`, plus le contrôle propre à cette famille ci-dessous, plus la validation de schéma.

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

## Contrôle propre à la famille fondamentale

**Vérifier qu'aucune frontière n'est laissée implicite.** Pour chaque type voisin cité par la définition, une ligne doit dire ce qui départage. `NON-003`, `NON-004` et `NON-017` existent parce que ce contrôle n'avait pas été appliqué.

## Le piège de cette famille

Définir en fonction de ce qu'on veut produire, plutôt que de ce qui est. Un type fondamental décrit une réalité du travail ; s'il n'a aucune instance après un mois, c'est le signe qu'il décrivait une intention et non une réalité. Quatre des sept types de cette famille n'ont encore aucune instance.

## Relations

- `derive-de` [skl-001-ressource](../skl-001-ressource/SKILL.md)
- `derive-de` [ADR-005](../../adr/ADR-005-regroupement-fonctionnel-des-ressources.md)
