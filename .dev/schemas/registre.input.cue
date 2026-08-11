// registre.input.cue - Donnees a fournir au gabarit registre.template.md
//
// Genere depuis RES-035-registre.md le 2026-08-11. Ne pas editer a la main.

package clia

#RES_registre_Input: {
	slug:          =~"^[a-z0-9]+(-[a-z0-9]+)*$"
	titre:         string & !=""
	resume:        string & !=""
	discriminant:  =~"^[0-9]{3}$"
	"registre-de": string & !=""
	tenue:         string & !=""
}
