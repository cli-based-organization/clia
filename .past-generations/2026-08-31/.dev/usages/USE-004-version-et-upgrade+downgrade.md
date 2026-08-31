un repo a une version.

```sh
cat .dev/clia.yaml

version: X.Y.Z
```

La source de vérité de la version est le numéro de version dans le fichier @.dev/clia.yaml sur la branche main.

Si la version du commit précédent est identique, la version effective est une version de développement. Et on y ajoute le hash_commit => `X.Y.Z+short_commit_hash`


Le mainteneur peut publier une version avec la commande `clia release ...`


```sh
# affiche toutes les versions p
clia release ls

# incrémente la version majeur ou mineur ou patch
cli release major|minor|patch
```


Une nouvelle version ne peut pas être incrémentée si:

- le repo git n'est pas propre
- il n'y a aucun changement depuis le dernier release de version