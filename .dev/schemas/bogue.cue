// bogue.cue - Frontmatter du type Bogue, prefixe BUG.
//
// Genere depuis RES-036-bogue.md le 2026-08-11. Ne pas editer a la main.
// Famille : preparation. Cycle de vie : travail. Edition : hybride.
//
// Pas de champ version : un type au cycle travail a une histoire.
//
// Le champ regle porte l'alias de la regle enfreinte. Sa forme n'est pas
// contrainte a #Id : une regle se cite souvent avec son numero de decision,
// par exemple ADR-007 D4.

package clia

#RES_bogue: #Frontmatter & {
	type: "bogue"
	id: #Id
	title: string & !=""
	status: #Status
	regle: string & !=""
	"constate-le": #Date
	etat: "ouvert" | "corrige" | "non-reproduit" | "accepte"
}
