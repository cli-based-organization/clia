// issue.input.cue - Donnees a fournir au gabarit issue.template.md
//
// Genere depuis RES-031-issue.md le 2026-08-11. Ne pas editer a la main.

package clia

#RES_issue_Input: {
	slug:         =~"^[a-z0-9]+(-[a-z0-9]+)*$"
	titre:        string & !=""
	resume:       string & !=""
	discriminant: =~"^[0-9]{3}$"
	initiateur:   string & !=""
	etat:         string & !=""
	ouverture:    string & !=""
}
