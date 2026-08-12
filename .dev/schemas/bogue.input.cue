// bogue.input.cue - Donnees a fournir au gabarit bogue.template.md
//
// Genere depuis RES-036-bogue.md le 2026-08-11. Ne pas editer a la main.

package clia

#RES_bogue_Input: {
	slug:          =~"^[a-z0-9]+(-[a-z0-9]+)*$"
	titre:         string & !=""
	resume:        string & !=""
	discriminant:  =~"^[0-9]{3}$"
	regle:         string & !=""
	"constate-le": string & !=""
	etat:          string & !=""
}
