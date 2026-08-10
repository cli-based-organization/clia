---
type: skill
id: skl-ressource-de-contenu
name: skl-004-ressource-de-contenu
version: 0.1.0
status: draft
description: >-
  Produire ou modifier une ressource de la famille **contenu** : Fragment `FRG`, Décision `DCN`, Entrevue `ENT`..
  À utiliser après `skl-001-ressource` partie A, qui porte les règles communes à
  toute ressource. Ce skill ne porte que ce qui est propre à la famille.
famille: contenu
---

# Skill - Ressource de la famille contenu

> Ce skill porte le **processus commun à la famille**, conformément à `ADR-005` D4. Les règles communes à toute ressource vivent dans `skl-001-ressource` partie A. Les spécificités de chaque type vivent dans sa définition.

## Trois niveaux, à lire dans cet ordre

| Niveau | Où | Ce qu'il porte |
|---|---|---|
| Méta-type | `skl-001-ressource` partie A | Frontmatter, identité, écriture, relations, quand objecter |
| Famille | ce document | Le processus commun à la famille contenu |
| Type | la définition `RES` du type | Champs propres, sections, frontières, test d'admission |

Ne pas produire une ressource de cette famille sans avoir lu la définition de son type : elle déclare ses `champs-obligatoires` et ses `sections`, et le gabarit correspondant en est dérivé.

## Types de la famille

Fragment `FRG`, Décision `DCN`, Entrevue `ENT`.

## Le mouvement propre à cette famille

Une ressource de contenu fait **entrer** de la matière dans le système. Le mouvement est celui de la **captation** : recueillir sans retoucher, puis annoter à côté.

C'est la seule famille où la fidélité prime sur la clarté. Un fragment mal écrit reste tel quel ; une réponse d'entrevue n'est jamais reformulée ; la teneur d'une décision enregistrée est immuable.

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

## Contrôle propre à la famille contenu

**Vérifier que le bloc capté n'a pas été retouché.** Les trois types de cette famille sont en régime hybride avec propriété par bloc, et le bloc de matière appartient à celui qui l'apporte.

Vérifier aussi que l'origine est renseignée : une matière sans provenance n'est pas citable.

## Le piège de cette famille

Améliorer ce qu'on capte. C'est le réflexe naturel d'un agent rédacteur, et il détruit la valeur de cette famille. La règle est absolue : l'agent n'édite jamais le bloc de matière, il produit une ressource dérivée qui déclare `derive-de`.

## Relations

- `derive-de` [skl-001-ressource](../skl-001-ressource/SKILL.md)
- `derive-de` [ADR-005](../../adr/ADR-005-regroupement-fonctionnel-des-ressources.md)
