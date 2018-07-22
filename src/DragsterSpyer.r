/***********************************************************************

 		  	Fichier Ressource DragsterSpyer


***********************************************************************/



include "DragsterSpyer.code" 	'DRGC' (1) as 'DRGC' (256,"Spyer", sysheap,locked);

resource 'STR#' (256) {
	 {	
		"Dragster Spyer - (C) Philippe BOULANGER 1987";
		"UTILISATION DANGEREUSE"
	}
};


type 'TIME' {
		unsigned longint;
};


resource 'TIME' (256) {
		25
};
