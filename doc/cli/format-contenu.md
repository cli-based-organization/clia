# Format de `content.md` et système de modèles

> Comment écrire le contenu d'une diapositive. Voir [README.md](./README.md) pour les commandes CLI.

## Structure d'un fichier `content.md`

Chaque diapositive vit dans `src/slide-<SEQ>/content.md` (`SEQ` sur 2 chiffres, ex. `slide-01`). Format :

```markdown
---
diapo:
  model: plain
content:
  title: "Titre de la slide"
  section: "Nom de section"
---

Corps de la diapositive en Markdown (listes, gras, italique, tableaux `|...|`).
```

- Le bloc YAML entre `---` définit `diapo.model` (obligatoire) et les champs `content:` propres au modèle.
- Le corps Markdown après le second `---` est optionnel selon le modèle (ex. `title`/`title-qr`/`remerciements` n'en ont pas besoin).
- Champs supportés en plus de `content:` : `params:` (surcharge locale) et `global-params:` (surcharge globale pour cette variation), cascade décrite plus bas.

### Variations multiples dans un seul fichier

Un `content.md` peut contenir plusieurs blocs `--- yaml --- corps` à la suite : chaque variation hérite des champs de la précédente (fusion profonde), seuls les champs explicitement redéfinis changent. Utile pour des slides quasi identiques (ex. une séquence d'étapes sur le même visuel).

## Cascade de configuration

Du plus général au plus spécifique (chaque niveau surcharge le précédent) :

```
src/global-params.yaml  <  config.yaml (racine)  <  global-params: (dans le content.md)  <  params:  <  content:
```

`src/global-params.yaml` porte les réglages transverses à toute la présentation (modèle par défaut, couleur de fond). `config.yaml` (racine du dépôt, optionnel) permet une surcharge par présentation sans toucher aux valeurs par défaut versionnées dans `src/`.

## Résolution des chemins d'assets

Tout champ de type chemin (`background`, `photo`, `qr-image`, entrées de `logos`, `csv`) accepte un préfixe `@` optionnel (ex. `@src/assets/photo.jpg`) et est résolu dans cet ordre :

1. Chemin relatif à la racine du dépôt (`PRESENTATION_ROOT`).
2. Nom de fichier seul, cherché dans `src/assets/`.
3. Rétrocompatibilité : `.dev/assets/` → `assets/branding/`.

Les `.svg` sont convertis en `.pdf` à la volée (`inkscape`), les `.webp` en `.png` (`convert`), résultats mis en cache dans `workdir/assets/`, jamais dans `dist/`.

## Modèles disponibles

Référence à jour : `dev.sh model ls` (liste) et `dev.sh model explain MODEL` (champs détaillés + exemple). Résumé :

| Modèle | Usage |
|---|---|
| `title` | Page de titre : titre, auteurs, date/événement/lieu, petits logos (1.1cm, coin bas-droit) |
| `title-qr` | Variante de `title` : remplace les logos par une photo + un QR-image (1.9cm), centrés sous le bloc auteur |
| `plain` | Slide standard : titre + contenu Markdown libre |
| `tableau` | Extension de `plain` : tableau depuis un fichier CSV, largeurs de colonnes contrôlables |
| `equation` | Extension de `plain` : équation/formule centrée en grand |
| `verbatim` | Page de notes (2 colonnes, pagination automatique), utilisée avec `dev.sh gen --verbatim` |
| `remerciements` | Diapositive de clôture : message, mot-clé en grand, QR code (image pré-générée via `qr-image`, ou généré nativement via `qr-url`) |

### QR code : image pré-générée vs génération native

`remerciements` accepte deux façons de produire son QR :

- `qr-image` (chemin vers un `.png` déjà généré, ex. par `dev.sh qrcode`), **prioritaire si présent**. À utiliser pour garantir que la diapositive de titre (`title-qr`) et la diapositive de clôture affichent exactement le même code QR.
- `qr-url` (chaîne, URL brute), génération native en LaTeX (`\qrcode`) si `qr-image` est absent. Plus simple pour un usage ponctuel, mais produit un QR visuellement différent (pas de logo composité) de celui de `title-qr`.

## Marge de sécurité

Convention transverse à tous les modèles : les éléments ancrés à un coin de page (logos, QR, bloc événement/date/lieu, numérotation) respectent une marge de **1.4cm** par rapport aux bords de la diapositive. Cette valeur est actuellement dupliquée dans chaque fichier `.tex` de `templates/models/` (pas de constante centralisée dans `beamerthemeNoumanity.sty`), à garder en tête en cas de modification d'un gabarit : privilégier des `\vspace`/`\hspace` fixes plutôt que du `\vfill`, qui peut s'écraser silencieusement à 0 si le contenu de la diapositive dépasse la hauteur de page disponible.
