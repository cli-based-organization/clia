// log.cue - Frontmatter du type Log, prefixe LOG.
//
// Genere depuis RES-032-log.md le 2026-08-11. Ne pas editer a la main.
// Famille : contenu. Cycle de vie : point-fixe. Edition : ia.
//
// Pas de champ version : un type point-fixe est arrete a sa date.

package clia

#RES_log: #Frontmatter & {
	type: "log"
	id: #Id
	title: string & !=""
	status: #Status
	tache: =~"^TSK-[0-9]{3}$"
	"type-log": "demande" | "analyse" | "fait" | "validation" |
	            "resultat-validation" | "next" | "commit-message"
	"ecrit-le": =~"^[0-9]{4}-[0-9]{2}-[0-9]{2} [0-9]{2}:[0-9]{2}$"
}
