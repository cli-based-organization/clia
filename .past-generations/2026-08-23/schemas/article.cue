// article.cue - Frontmatter du type Article, prefixe ART.
//
// Genere depuis RES-028-article.md le 2026-08-10. Ne pas editer a la main.
// Famille : implementation. Cycle de vie : point-fixe. Edition : ia.

package clia

#RES_article: #Frontmatter & {
	type: "article"
	id: #Id
	title: string & !=""
	status: #Status
	date: #Date
	auditoire: string & !=""
	publication: string & !=""
}
