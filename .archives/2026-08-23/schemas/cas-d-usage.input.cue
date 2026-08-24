// cas-d-usage.input.cue - Donnees a fournir au gabarit cas-d-usage.template.md
//
// Genere depuis RES-023-cas-d-usage.md le 2026-08-10. Ne pas editer a la main.

package clia

#RES_cas_d_usage_Input: {
	slug:         =~"^[a-z0-9]+(-[a-z0-9]+)*$"
	titre:        string & !=""
	resume:       string & !=""
	discriminant: =~"^([0-9]{3}|[0-9]{4}-[0-9]{2}-[0-9]{2})$"
	acteur_principal: string & !=""
	niveau:       string & !=""
}
