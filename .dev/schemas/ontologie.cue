// ontologie.cue - Frontmatter du type Ontologie, prefixe ONT.
//
// Genere depuis RES-006-ontologie.md le 2026-08-10. Ne pas editer a la main.
// Famille : fondamentale. Cycle de vie : vivant. Edition : co-edition.

package clia

#RES_ontologie: #Frontmatter & {
	type: "ontologie"
	id: #Id
	title: string & !=""
	version: #Semver
	status: #Status
	domaine: string & !=""
}
