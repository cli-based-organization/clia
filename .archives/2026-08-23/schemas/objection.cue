// objection.cue - Frontmatter du type Objection, prefixe NON.
//
// Genere depuis RES-004-objection.md le 2026-08-10. Ne pas editer a la main.
// Famille : fondamentale. Cycle de vie : travail. Edition : hybride.

package clia

#RES_objection: #Frontmatter & {
	type: "objection"
	id: #Id
	title: string & !=""
	status: #Status
	initiateur: "humain" | "agent"
	effet: "bloquant" | "conditionnel" | "informatif"
	// Les sept etats declares par RES-004, rubrique « Etats ». Le schema
	// acceptait auparavant n'importe quelle chaine : la definition etait
	// ecrite et rien ne la faisait respecter. Cinq de ces valeurs n'avaient
	// jamais servi le 2026-08-13, alors qu'elles decrivent des situations
	// que le depot vit. Voir ANL-011 C3.
	etat: "ouverte" | "partiellement-repondue" | "repondue" | "resolue" |
	      "levee-par-decision" | "differee" | "caduque"
	"porte-sur": [...string]
}
