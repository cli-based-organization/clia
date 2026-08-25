Met en oeuvre SPC-001. Complète REQ-002, ne le remplace pas.

@_ressources/<RESSOURCE>/            := répertoire de ressource
@_ressources/<CATEGORIE>/<RESSOURCE>/ := ressource dans une catégorie

Une catégorie n'est pas un namespace. Le namespace est celui du dépôt, un
seul, déclaré dans @.dev/clia.yaml. Voir USE-003.

Une ressource se reconnaît à sa définition. Un répertoire de _ressources/ qui
ne porte pas schemas/<NOM>.yaml est une catégorie, et ses enfants sont des
ressources. Pas de troisième niveau.

La ressource elle-même, de REQ-002 :

schemas/<NOM>.yaml    := définition du type. Une seule. Fait la ressource
templates/            := gabarit d'une instance
primitives/           := primitives ne relevant d'aucun concept ci-dessous

Les concepts rattachés. <X> pour les primitives, _<X> pour les templates
d'instrumentation :

principes/  _principes/  := principes de conception de cette ressource
ontology/   _ontology/   := concepts et relations propres à cette ressource
specs/      _specs/      := spécifications de cette ressource
reqs/       _reqs/       := requis d'implémentation de cette ressource
scripts/    _scripts/    := scripts d'instrumentation, dont ses commandes
skills/     _skills/     := skills opérant sur cette ressource
features/   _features/   := fonctionnalités fournies pour ou par cette ressource
methodes/   _methodes/   := méthodologies pour opérer sur cette ressource

Règles :

1. Un template porte le nom de sa primitive, suffixé .template :
   features/session.md  ->  _features/session.template.md

2. Aucun répertoire vide. Les onze emplacements sont admis, aucun n'est exigé.

3. Aucun catalogue central. Un concept rattaché vit sous sa ressource, et le
   CLI le trouve en balayant _ressources/*/<X>/ et _ressources/*/*/<X>/.

4. Un concept rattaché n'est pas une ressource. La commande qui opère sur
   tous les <X> de toutes les ressources est une commande du CLI, et son
   script vit dans _scripts/lib/cmd/.
