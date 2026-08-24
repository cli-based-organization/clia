// ressource.input.cue - Donnees a fournir au gabarit ressource.template.md
//
// Genere depuis RES-001-ressource.md le 2026-08-10. Ne pas editer a la main.

package clia

#RES_ressource_Input: {
	slug:         =~"^[a-z0-9]+(-[a-z0-9]+)*$"
	titre:        string & !=""
	resume:       string & !=""
	discriminant: =~"^([0-9]{3}|[0-9]{4}-[0-9]{2}-[0-9]{2})$"
	prefixe:      string & !=""
	emplacement:  string & !=""
	cycle_de_vie: string & !=""
	edition:      string & !=""
	famille:      string & !=""
	champs_obligatoires: string & !=""
	relations_admissibles: string & !=""
	sections:     string & !=""
	skill:        string & !=""
	adr:          string & !=""
	statut:       string & !=""
}
