// skill.input.cue - Donnees a fournir au gabarit skill.template.md
//
// Genere depuis RES-018-skill.md le 2026-08-10. Ne pas editer a la main.

package clia

#RES_skill_Input: {
	slug:         =~"^[a-z0-9]+(-[a-z0-9]+)*$"
	titre:        string & !=""
	resume:       string & !=""
	discriminant: =~"^([0-9]{3}|[0-9]{4}-[0-9]{2}-[0-9]{2})$"
	name:         string & !=""
	description:  string & !=""
}
