// comportement-attendu.cue - Frontmatter du type Comportement attendu, prefixe CMP.
//
// Genere depuis RES-024-comportement-attendu.md le 2026-08-10. Ne pas editer a la main.
// Famille : preparation. Cycle de vie : vivant. Edition : co-edition.

package clia

#RES_comportement_attendu: #Frontmatter & {
	type: "comportement-attendu"
	id: #Id
	title: string & !=""
	version: #Semver
	status: #Status
	verifie: string & !=""
}
