// harnais-d-architecture.input.cue - Donnees a fournir au gabarit harnais-d-architecture.template.md
//
// Genere depuis RES-015-harnais-d-architecture.md le 2026-08-10. Ne pas editer a la main.

package clia

#RES_harnais_d_architecture_Input: {
	slug:         =~"^[a-z0-9]+(-[a-z0-9]+)*$"
	titre:        string & !=""
	resume:       string & !=""
	discriminant: =~"^([0-9]{3}|[0-9]{4}-[0-9]{2}-[0-9]{2})$"
}
