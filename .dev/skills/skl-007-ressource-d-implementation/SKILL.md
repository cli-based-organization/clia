---
type: skill
id: skl-007
name: skl-007-ressource-d-implementation
version: 0.1.0
status: draft
description: >-
  Produire ou modifier une ressource de la famille **implementation** : Code `CDE`, Rapport de recherche `RPT`, Article `ART`, Présentation `PRS`..
  À utiliser après `skl-001-ressource` partie A, qui porte les règles communes à
  toute ressource. Ce skill ne porte que ce qui est propre à la famille.
famille: implementation
---

# Skill - Ressource de la famille implementation

> Ce skill porte le **processus commun à la famille**, conformément à `ADR-005` D4. Les règles communes à toute ressource vivent dans `skl-001-ressource` partie A. Les spécificités de chaque type vivent dans sa définition.

## Trois niveaux, à lire dans cet ordre

| Niveau | Où | Ce qu'il porte |
|---|---|---|
| Méta-type | `skl-001-ressource` partie A | Frontmatter, identité, écriture, relations, quand objecter |
| Famille | ce document | Le processus commun à la famille implementation |
| Type | la définition `RES` du type | Champs propres, sections, frontières, test d'admission |

Ne pas produire une ressource de cette famille sans avoir lu la définition de son type : elle déclare ses `champs-obligatoires` et ses `sections`, et le gabarit correspondant en est dérivé.

## Types de la famille

Code `CDE`, Rapport de recherche `RPT`, Article `ART`, Présentation `PRS`.

## Le mouvement propre à cette famille

Une ressource d'implémentation réalise ou diffuse. Le mouvement est celui de la **sortie** : produire quelque chose qui vaut hors du dépôt.

C'est la famille dont les membres ont le moins en commun, et `ADR-005` D4 le signale comme la faiblesse de sa propre hypothèse. Ce qu'ils partagent est un destinataire extérieur : un exécutant pour le code, un lecteur pour le rapport et l'article, un auditoire pour la présentation.

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

## Contrôle propre à la famille implementation

**Vérifier que la ressource ne suppose rien du dépôt.** Un rapport qui renvoie à `ANL-001` sans l'expliquer est inutilisable hors du dépôt. La règle vaut pour les quatre types : le destinataire n'a pas accès au contexte.

Vérifier le régime de diffusion : un livrable ne peut pas être plus ouvert que le moins ouvert des faits qu'il emploie.

## Le piège de cette famille

Confondre un instrument de travail et un livrable. Une fondation n'est pas un rapport, une analyse n'est pas un article. Le passage de l'un à l'autre demande de réécrire pour un lecteur qui ne sait rien, et non de renommer le fichier.

## Relations

- `derive-de` [skl-001-ressource](../skl-001-ressource/SKILL.md)
- `derive-de` [ADR-005](../../adr/ADR-005-regroupement-fonctionnel-des-ressources.md)
