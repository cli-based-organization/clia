// tache.cue - Frontmatter du type Tache, prefixe TSK.
//
// Genere depuis RES-033-tache.md le 2026-08-11. Ne pas editer a la main.
// Famille : preparation. Cycle de vie : travail. Edition : hybride.

package clia

#RES_tache: #Frontmatter & {
	type: "tache"
	id: #Id
	title: string & !=""
	status: #Status
	session: =~"^SES-[0-9]{3}$"
	categorie: string & !=""
	etat: "demandee" | "en-cours" | "faite" | "abandonnee"
}
