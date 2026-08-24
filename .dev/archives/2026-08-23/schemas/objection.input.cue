// objection.input.cue - Donnees a fournir au gabarit objection.template.md
//
// Genere depuis RES-004-objection.md le 2026-08-10. Ne pas editer a la main.

package clia

#RES_objection_Input: {
	slug:         =~"^[a-z0-9]+(-[a-z0-9]+)*$"
	titre:        string & !=""
	resume:       string & !=""
	discriminant: =~"^([0-9]{3}|[0-9]{4}-[0-9]{2}-[0-9]{2})$"
	initiateur:   string & !=""
	effet:        string & !=""
	etat:         string & !=""
	porte_sur:    string & !=""
}
