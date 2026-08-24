// harnais-de-gouvernance.input.cue - Donnees a fournir au gabarit harnais-de-gouvernance.template.md
//
// Genere depuis RES-017-harnais-de-gouvernance.md le 2026-08-10. Ne pas editer a la main.

package clia

#RES_harnais_de_gouvernance_Input: {
	slug:         =~"^[a-z0-9]+(-[a-z0-9]+)*$"
	titre:        string & !=""
	resume:       string & !=""
	discriminant: =~"^([0-9]{3}|[0-9]{4}-[0-9]{2}-[0-9]{2})$"
}
