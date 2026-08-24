# Analyse, tâche 2 de SES-002

`MET-003` étape 2.

## Le blocage, précisé

`PLN-007` a sept chantiers. Six d'entre eux — A à F — posent, propagent ou suppriment les quatre champs `maturity`, `adoption`, `activated`, `domain-status` que `DCN-016` déclare. Cette décision est un premier jet d'agent, `effet: suspendue`, sans approbation depuis sa création le 2026-08-11.

**Exécuter A à F serait appliquer cette décision au dépôt entier avant qu'elle soit approuvée.** Le plan le dit lui-même dans ses objections.

## Ce qui ne dépend pas de DCN-016

Le chantier G. Son critère : « Le contrôle signale un champ obligatoire dont toutes les instances portent la même valeur ». C'est une règle générale sur n'importe quel champ obligatoire d'un type déjà défini, elle ne suppose ni ne pose les quatre champs de `DCN-016`.

**Il répond à `NON-035`**, qui a mesuré le défaut à la main sur `status` : 157 instances, une seule valeur, trois jours sans que rien ne le signale. Le chantier G rend cette mesure automatique et généralisée, sans toucher au modèle de champs lui-même.

## Où le livrable trouve sa place

Le plan dit : « dans `clia validate` ou dans le script de validation ». `clia validate` n'existe pas : `ISU-007` le réclame depuis le 2026-08-11 et prévoit de l'implémenter en commençant par les contrôles de schéma, puis les dix contrôles `V1` à `V10`.

**Construire `clia validate` n'est pas le chantier G.** Il déborderait largement l'heure déclarée et empiéterait sur une initiative déjà suivie séparément.

**Le choix retenu.** Un verbe sur la commande existante : `clia resource check [TYPE]`, dans la grammaire déjà en usage — nom puis verbe, `ADR-003` D3. C'est un premier fondement pour `clia validate`, pas l'outil lui-même.

## Ce que le contrôle fait, et ce qu'il exclut

Pour chaque type défini, pour chaque champ que sa définition déclare obligatoire, sur ses instances : si toutes portent la même valeur et qu'il y en a au moins deux, le signaler.

**`type` est exclu.** Il est constant par construction — c'est ce qui définit le type, pas un défaut.

**Le seuil de deux instances.** Une seule instance ne permet aucune mesure de variation ; le signaler serait un faux positif systématique sur tout type neuf.
