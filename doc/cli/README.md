# CLI de génération du pdf de présentation

> Documentation utilisateur de `scripts/dev.sh`, l'outil qui génère `dist/presentation.pdf` à partir des fichiers `src/slide-<SEQ>/content.md`. Stack : bash + `texlua` + LuaLaTeX + Beamer (voir `.dev/adr/ADR-001-cli-generation-pdf-presentation.md` pour les choix d'architecture ; ce document-ci ne couvre que l'usage).

## Démarrage rapide

```bash
. activate          # ajoute scripts/ au PATH, exporte PRESENTATION_ROOT
dev.sh gen          # genere dist/presentation.pdf
```

`. activate` vérifie aussi la présence des dépendances système (`texlua`, `lualatex`, `inkscape`, `convert`) et avertit si l'une d'elles manque.

## Dépendances système

- `texlua` et `lualatex` (TeX Live) : moteur de rendu.
- `latexmk` : optionnel ; à défaut, `dev.sh gen` bascule automatiquement sur une double passe `lualatex` directe.
- `inkscape` : conversion des images `.svg` en `.pdf` (à la demande, pour les champs `background`/`photo`/logos).
- `convert`/`identify` (ImageMagick) : conversion `.webp`→`.png`, composition d'images (commande `qrcode`).
- `qrencode` : génération de codes QR (commande `qrcode`).

## Commandes

### `dev.sh gen [--verbatim] [--dev|--prod]`
Génère le pdf à partir de tous les `src/slide-*/content.md` existants.

- Sans option : `dist/presentation.pdf`.
- `--verbatim` : intercale une page de notes après chaque slide qui a un fichier `verbatim.md` associé.
- `--dev` : équivalent à `--verbatim`, sortie `dist/<YYYY-MM-DD>_presentation-dev.pdf`.
- `--prod` : sans notes, sortie `dist/<YYYY-MM-DD>_presentation.pdf`.
- `--dev` et `--prod` sont mutuellement exclusifs.

### `dev.sh clean`
Vide `workdir/` (fichiers temporaires de compilation). Ne touche jamais à `dist/`.

### `dev.sh model ls`
Liste les modèles de diapositive disponibles (voir [format-contenu.md](./format-contenu.md)).

### `dev.sh model explain MODEL`
Affiche les champs (obligatoires/optionnels), les notes d'usage et un exemple de `content.md` pour un modèle donné. C'est la référence à jour, ce document ne duplique pas le détail de chaque champ.

### `dev.sh diapo init [--params] [--global-params] SEQ MODEL`
Crée `src/slide-<SEQ>/content.md` (numéro `SEQ` normalisé sur 2 chiffres) avec le squelette des champs obligatoires du modèle choisi. `--params`/`--global-params` ajoutent les sections correspondantes vides.

### `dev.sh diapo check SEQ`
Valide le format de `src/slide-<SEQ>/content.md` : présence du front matter, modèle connu, champs obligatoires renseignés.

### `dev.sh qrcode URL OUTPUT [--logo PATH] [--ratio N]`
Génère `dist/OUTPUT` : un code QR (noir, correction d'erreur élevée) encodant `URL`, avec un logo composité au centre.

- `--logo PATH` : image à superposer (défaut : `src/assets/isotipo-noumanity.png`).
- `--ratio N` : proportion de la largeur du QR occupée par le logo (défaut `0.30`). Une valeur trop haute peut rendre le QR illisible par un lecteur, vérifier visuellement après génération.

Le fichier produit dans `dist/` peut ensuite être référencé depuis n'importe quel `content.md` via le champ `qr-image` (modèles `title-qr`, `remerciements`) pour garantir que la même image de QR apparaît sur plusieurs diapositives.

### `dev.sh --help` / `dev.sh -h`
Affiche l'aide (générée depuis le bloc de commentaires en tête de `scripts/dev.sh`, source unique de vérité, toujours à jour avec les commandes réellement implémentées).

## Voir aussi

- [format-contenu.md](./format-contenu.md) : format de `content.md`, système de modèles, résolution des chemins d'assets.
- `.dev/adr/ADR-001-cli-generation-pdf-presentation.md` : décisions d'architecture (stack, emplacement in-repo).
- `.dev/skills/skl-007-script-pdf-presentation/SKILL.md` : règles à suivre pour faire évoluer ce CLI (agents et humains).
