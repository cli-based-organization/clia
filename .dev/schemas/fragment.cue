// fragment.cue - Frontmatter du type Fragment, prefixe FRG.
//
// Genere depuis RES-008-fragment.md le 2026-08-10. Ne pas editer a la main.
// Famille : contenu. Cycle de vie : point-fixe. Edition : hybride.

package clia

#RES_fragment: #Frontmatter & {
	type: "fragment"
	id: #Id
	title: string & !=""
	status: #Status
	origine: string & !=""
	"date-de-captation": #Date
	exploitation: "non-exploite" | "partiellement-exploite" | "exploite" | "sterile"
}
