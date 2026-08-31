// log.input.cue - Donnees a fournir au gabarit log.template.md
//
// Genere depuis RES-03x le 2026-08-11. Ne pas editer a la main.

package clia

#RES_log_Input: {
	slug:         =~"^[a-z0-9]+(-[a-z0-9]+)*$"
	titre:        string & !=""
	resume:       string & !=""
	discriminant: =~"^[0-9]{3}$"
}
