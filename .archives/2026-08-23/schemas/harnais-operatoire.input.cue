// harnais-operatoire.input.cue - Donnees a fournir au gabarit harnais-operatoire.template.md
//
// Genere depuis RES-014-harnais-operatoire.md le 2026-08-10. Ne pas editer a la main.

package clia

#RES_harnais_operatoire_Input: {
	slug:         =~"^[a-z0-9]+(-[a-z0-9]+)*$"
	titre:        string & !=""
	resume:       string & !=""
	discriminant: =~"^([0-9]{3}|[0-9]{4}-[0-9]{2}-[0-9]{2})$"
}
