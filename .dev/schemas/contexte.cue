// contexte.cue - Frontmatter du type Contexte, prefixe CTX.
//
// Genere depuis RES-002-contexte.md le 2026-08-10. Ne pas editer a la main.
// Famille : fondamentale. Cycle de vie : vivant. Edition : hybride.

package clia

#RES_contexte: #Frontmatter & {
	type: "contexte"
	id: #Id
	title: string & !=""
	version: #Semver
	status: #Status
	portee: string & !=""
	peremption: string & !=""
}
