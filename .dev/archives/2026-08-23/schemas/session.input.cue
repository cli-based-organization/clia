// session.input.cue - Donnees a fournir au gabarit session.template.md
//
// Genere depuis RES-034-session.md le 2026-08-11. Ne pas editer a la main.

package clia

#RES_session_Input: {
	slug:         =~"^[a-z0-9]+(-[a-z0-9]+)*$"
	titre:        string & !=""
	resume:       string & !=""
	discriminant: =~"^[0-9]{3}$"
	ouverture:    =~"^[0-9]{4}-[0-9]{2}-[0-9]{2}$" | "À RENSEIGNER"
	etat:         "todo" | "opened" | "closed"
}
