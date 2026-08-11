# Résultat de la validation, tâche 13

## Migration : complète

| Vérification | Résultat |
|---|---|
| Fichiers au nommage daté hors archives | **0** |
| Prescriptions `<PREFIX>-<DATE>` dans les définitions et skills | **0** |
| Identifiants à slug dans un frontmatter | **0** |
| Identifiants convertis | 83, dans 83 fichiers |
| Fichiers renommés | 1 |

La table de correspondance a été dérivée du nom de fichier, non saisie. Le remplacement a traité les identifiants du plus long au plus court avec une frontière de mot, ce qui évite qu'un identifiant court ne soit remplacé à l'intérieur d'un plus long : `RES-fait` et `RES-faits` coexistaient dans le corpus.

## Validation de schéma : 85 valides sur 87

`cue vet` ne signale rien sur les soixante schémas régénérés.

Les deux échecs sont `FRG-001` et `NON-013`, créés par l'humain avec `clia res new` et portant des champs `À RENSEIGNER`. Ils n'ont pas été complétés : ces champs lui appartiennent, et l'échec est le signalement.

Le schéma `#Id` accepte les deux formes retenues et rejette la forme à slug, ce qui garantit qu'un identifiant ancien ne peut plus être introduit.

## Code : conforme, après quatre régénérations

Trois bogues du générateur ont été trouvés et corrigés, tous dus à la même cause : le générateur dépendait de l'`id`, dont la forme venait de changer.

| Bogue | Symptôme |
|---|---|
| Nom des définitions CUE dérivé de l'`id` | `reference "#RES_adr" not found` |
| Valeur du champ `type` dérivée de l'`id` | `conflicting values "019" and "adr"` |
| Énumération du champ `effet` conditionnée par l'ancien `id` | Les décisions recevaient l'énumération des objections |

Les trois sont désormais dérivés du slug du nom de fichier. Le coût a été de quatre régénérations complètes, sans édition manuelle, ce qui est le bénéfice de la dérivation mécanique.

Le CLI : 91 assertions vertes. `clia res ls` résout les trente types et n'affiche aucun type sans définition.

## Forme : conforme, après deux corrections

Deux faux positifs ont été trouvés et corrigés.

`DCN-007` portait un motif de nommage en clair dans son titre, que le contrôle V8 signalait comme reste de gabarit. Le titre du frontmatter a été reformulé et celui du corps encadré en code inline.

Les liens vers `NON-019` et `DCN-007` étaient cassés le temps que ces fichiers soient créés, ce qui est un artefact de l'ordre de rédaction et non un défaut.

## Cohérence de la décision : conforme

`ADR-007` déclare abroger `ADR-001` D3 et le nomme.

Il explique pourquoi la position antérieure de l'agent était fausse, plutôt que de l'écarter : la prémisse selon laquelle le numéro se renumérote n'était pas un fait mais une permission tacite, et `ADR-007` D2 la retire.

L'ajout de l'agent, l'interdiction de renuméroter, est signalé comme tel dans l'ADR, dans la DCN et dans le log.

Les réponses aux questions de `NON-001` et `NON-011` sont consignées dans les objections, avec leur date et leur source. L'état de `NON-001` passe à `partiellement-repondue`, valeur prévue par `RES-004`, et non à `resolue` : quatre de ses questions restent ouvertes.

## Réserve : la décision repose sur une règle non vérifiée

`ADR-007` D2 interdit de renuméroter, et c'est cette interdiction qui fait du numéro une identité. Rien ne la vérifie. Un renommage de fichier suffirait à changer une identité en silence.

C'est la quatrième règle écrite et non tenue ajoutée en deux jours, après le test de `ADR-006` D4, l'agnosticisme de `ADR-006` D2 et le contrôle manuel des harnais de `PDC-001`. `NON-005` conteste cette accumulation depuis le 2026-08-09, et `NON-019` Q2 porte le cas précis.

## Ce que la validation confirme du motif récurrent

Cinq fois en trois jours, un mécanisme s'est révélé couplé à une valeur qui ne devait pas porter cette information : l'adresse prise pour l'identité, le type dérivé du titre, la résolution sensible aux accents, le décompte comparant des titres, et ici le générateur dépendant de l'`id`.

Le motif est stable et il mérite peut-être un concept au sens de `RES-007` : une valeur qui sert à deux fins finit par ne plus servir à aucune.
