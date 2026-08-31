// rapport-de-recherche.input.cue - Donnees a fournir au gabarit rapport-de-recherche.template.md
//
// Genere depuis RES-027-rapport-de-recherche.md le 2026-08-10. Ne pas editer a la main.

package clia

#RES_rapport_de_recherche_Input: {
	slug:         =~"^[a-z0-9]+(-[a-z0-9]+)*$"
	titre:        string & !=""
	resume:       string & !=""
	discriminant: =~"^([0-9]{3}|[0-9]{4}-[0-9]{2}-[0-9]{2})$"
	date:         string & !=""
	auditoire:    string & !=""
	diffusion:    string & !=""
}
