// iie.cue — la forme d'une IIE, décrite en CUE.
//
// SES-001 tâche 24 : « choix d'implémentation : utiliser cuelang pour
// décrire et valider l'IIE ».
//
// Ce fichier est la description. Il n'est pas un commentaire sur le code :
// c'est lui que cue lit pour juger, et une IIE qui ne s'y conforme pas est
// refusée. Ce que le bash du noyau vérifie — la présence, la forme absolue —
// en est un sous-ensemble, celui qui doit répondre même sans cue installé.
//
// Employé par : livrables/_scripts/valider-iie.sh
//
//     cue vet iie.cue <une IIE extraite en YAML>

// L'identité absolue. Un uuid v4 en minuscules, préfixé par le schéma clia.
// C'est la seule des trois formes qui soit déclarée : les deux autres se
// dérivent du dépôt, et ce qui se déduit ne se déclare pas.
#Identite: =~"^clia:[0-9a-f]{8}-[0-9a-f]{4}-[0-9a-f]{4}-[0-9a-f]{4}-[0-9a-f]{12}$"

// Le préfixe : deux à cinq majuscules. Il fait la forme relative — RES — et,
// avec une séquence, celle d'une instance — RES-001.
#Prefixe: =~"^[A-Z]{2,5}$"

// Le nom : minuscules, chiffres et tirets. C'est aussi le nom du fichier de
// définition, et celui du répertoire d'une ressource installée.
#Nom: =~"^[a-z0-9][a-z0-9-]*$"

// La version sémantique. Le tag de pré-publication n'est pas admis : clia
// n'en publie pas, et l'ordonner demanderait une règle que rien n'emploie.
#Version: =~"^[0-9]+\\.[0-9]+\\.[0-9]+$"

// Une composition : une ou plusieurs identités absolues, séparées par des
// espaces. Pointer vers l'IIE d'une ressource suffit à désigner l'ensemble
// de ses fichiers — SES-001 tâche 24.
//
// La liste est un scalaire séparé par des espaces, et non une liste YAML :
// le lecteur du noyau rend un champ par entrée, non une liste imbriquée.
#Composition: =~"^clia:[0-9a-f-]{36}( +clia:[0-9a-f-]{36})*$"

// Une IIE.
//
// L'identité atteste l'unicité ; les cinq autres champs disent ce que la
// ressource est. Ce qui décrit comment elle est, ou ce qui lui est arrivé,
// n'a pas sa place ici : ce sont des informations accidentelles, et elles
// vivent où elles servent.
//
// « representation » n'est présent que dans une IIE externe — celle qui
// identifie autre chose que le fichier qui la porte. Elle est alors
// obligatoire : sans elle, l'IIE n'identifie rien.
#IIE: {
	id:           #Identite
	nom:          #Nom
	titre:        string & !=""
	prefixe:      #Prefixe
	version:      #Version
	description:  string & !=""
	representation?: string & !=""
	"composee-de"?: #Composition

	// Une définition porte aussi ce que les commandes de clia savent tenir —
	// zones, primitives, recettes. Elles ne font pas partie de l'IIE, et ne
	// sont donc pas décrites ici.
	...
}

#IIE
