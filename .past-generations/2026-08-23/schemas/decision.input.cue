// decision.input.cue - Donnees a fournir au gabarit decision.template.md
//
// Genere depuis RES-009-decision.md v0.2.0 le 2026-08-10. Ne pas editer a la main.

package clia

#RES_decision_Input: {
	slug:         =~"^[a-z0-9]+(-[a-z0-9]+)*$"
	titre:        string & !=""
	resume:       string & !=""
	discriminant: =~"^([0-9]{3}|[0-9]{4}-[0-9]{2}-[0-9]{2})$"
	instance:     string & !=""
	date_de_decision: string & !=""
	portee:       string & !=""
	effet:        string & !=""
	attestation:  string & !=""
	diffusion:    string & !=""
}
