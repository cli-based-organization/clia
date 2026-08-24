// fonctionnalite.input.cue - Donnees a fournir au gabarit
//
// Genere depuis RES-037-fonctionnalite.md le 2026-08-13. Ne pas editer a la main.

package clia

#RES_fonctionnalite_Input: {
	slug:         =~"^[a-z0-9]+(-[a-z0-9]+)*$"
	titre:        string & !=""
	resume:       string & !=""
	discriminant: =~"^[0-9]{3}$"
	etat:         "pressentie" | "en-cours" | "livree" | "retiree"
	usage:        string & !=""
}
