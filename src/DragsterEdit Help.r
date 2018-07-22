/*	Rez file for balloon document "DragsterEdit Help" */
/*	Created Ven 23 Aoû 1991 at 14:32 */

#include "Types.r"
#include "BalloonTypes.r"

resource 'hmnu' (256,"Apple") {
	HelpMgrVersion,
	hmDefaultOptions,
	0,
	0,
	HMSkipItem { },
	{
		HMStringResItem {		/* Menu title messages */
			0,0,		/*  Normal */
			0,0,		/*  Grayed */
			0,0,		/*  Checked */
			0,0,		/*  Other */
		},
		HMStringResItem {		/* item 1:A propos de DragsterEdit… */
			-3000,1,
			-1,0,
			-1,0,
			-1,0
		}
	}
};

resource 'hmnu' (262,"Basic") {
	HelpMgrVersion,
	hmDefaultOptions,
	0,
	0,
	HMSkipItem { },
	{

		HMStringResItem {		/* Basic */
			-3000,2,
			-3000,3,
			-1,0,
			-1,0
		},
		HMStringResItem {		/* item 1:Analyser la syntaxe */
			-3000,4,
			-3000,5,
			-1,0,
			-1,0
		},
		HMStringResItem {		/* item 2:Compiler */
			-3000,6,
			-3000,7,
			-1,0,
			-1,0
		},
					HMSkipItem { },
		HMStringResItem {		/* item 4:Lancer l'application */
			-3000,8,
			-3000,9,
			-1,0,
			-1,0
		},
		HMStringResItem {		/* item 5:Arrêter */
			-3000,10,
			-3000,11,
			-1,0,
			-1,0
		},
					HMSkipItem { },
		HMStringResItem {		/* item 7:Trace complète */
			-3000,12,
			-1,0,
			-3000,13,
			-1,0
		},
		HMStringResItem {		/* item 8:Affichage des TRACE */
			-3000,14,
			-1,0,
			-3000,15,
			-1,0
		},
					HMSkipItem { },
		HMStringResItem {		/* item 10:Options d'analyse… */
			-3000,16,
			-1,0,
			-1,0,
			-1,0
		},
		HMStringResItem {		/* item 11:Options de compilation… */
			-3000,17,
			-1,0,
			-1,0,
			-1,0
		}
	}
};

resource 'hmnu' (258,"Edition") {
	HelpMgrVersion,
	hmDefaultOptions,
	0,
	0,
	HMSkipItem { },
	{

		HMStringResItem {		/* Edition */
			-3000,18,
			-3000,19,
			-1,0,
			-1,0
		},
		HMStringResItem {		/* item 1:Annuler */
			-3000,20,
			-3000,21,
			-1,0,
			-1,0
		},
					HMSkipItem { },
		HMStringResItem {		/* item 3:Couper */
			-3000,22,
			-3000,23,
			-1,0,
			-1,0
		},
		HMStringResItem {		/* item 4:Copier */
			-3000,24,
			-3000,25,
			-1,0,
			-1,0
		},
		HMStringResItem {		/* item 5:Coller */
			-3000,26,
			-3000,27,
			-1,0,
			-1,0
		},
		HMStringResItem {		/* item 6:Effacer */
			-3000,28,
			-3000,29,
			-1,0,
			-1,0
		},
		HMStringResItem {		/* item 7:Tout sélectionner */
			-3000,30,
			-3000,31,
			-1,0,
			-1,0
		},
					HMSkipItem { },
		HMStringResItem {		/* item 9:Chercher… */
			-3000,32,
			-3000,33,
			-1,0,
			-1,0
		},
		HMStringResItem {		/* item 10:Chercher suivant */
			-3000,34,
			-3000,35,
			-1,0,
			-1,0
		},
		HMStringResItem {		/* item 11:Remplacer… */
			-3000,36,
			-3000,37,
			-1,0,
			-1,0
		},
		HMStringResItem {		/* item 12:Remplacer suivant */
			-3000,38,
			-3000,39,
			-1,0,
			-1,0
		}
	}
};

resource 'hmnu' (261,"Fenêtres") {
	HelpMgrVersion,
	hmDefaultOptions,
	0,
	0,

		HMStringResItem {		/* Default balloon for Fenêtres */
			-3000,40,
			-1,0,
			-1,0,
			-1,0
		},
	{

		HMStringResItem {		/* Fenêtres */
			-3000,41,
			-3000,42,
			-1,0,
			-1,0
		},
		HMStringResItem {		/* item 1:Fenêtres Basic */
			-3000,43,
			-1,0,
			-3000,44,
			-1,0
		},
		HMStringResItem {		/* item 2:Fenêtres Vidéotex */
			-3000,45,
			-1,0,
			-3000,46,
			-1,0
		},
					HMSkipItem { },
		HMStringResItem {		/* item 4:Fenêtre 'TRACE' */
			-3000,47,
			-1,0,
			-3000,48,
			-1,0
		},
		HMStringResItem {		/* item 5:Routines Externes… */
			-3000,49,
			-1,0,
			-1,0,
			-1,0
		}
	}
};

resource 'hmnu' (257,"Fichier") {
	HelpMgrVersion,
	hmDefaultOptions,
	0,
	0,
	HMSkipItem { },
	{

		HMStringResItem {		/* Fichier */
			-3000,50,
			-2999,1,
			-1,0,
			-1,0
		},
		HMStringResItem {		/* item 1:Nouvel écran */
			-2999,2,
			-2999,3,
			-1,0,
			-1,0
		},
		HMStringResItem {		/* item 2:Ouvrir un écran… */
			-2999,4,
			-2999,5,
			-1,0,
			-1,0
		},
		HMStringResItem {		/* item 3:Dupliquer l'écran… */
			-2999,6,
			-2999,7,
			-1,0,
			-1,0
		},
		HMStringResItem {		/* item 4:Superposer l'écran… */
			-2999,8,
			-2999,9,
			-1,0,
			-1,0
		},
		HMStringResItem {		/* item 5:Sauver l'écran */
			-2999,10,
			-2999,11,
			-1,0,
			-1,0
		},
		HMStringResItem {		/* item 6:Sauver l'écran sous… */
			-2999,12,
			-2999,13,
			-1,0,
			-1,0
		},
		HMStringResItem {		/* item 7:Fermer l'écran */
			-2999,14,
			-2999,15,
			-1,0,
			-1,0
		},
					HMSkipItem { },
		HMStringResItem {		/* item 9:Ecran original */
			-2999,16,
			-2999,17,
			-1,0,
			-1,0
		},
					HMSkipItem { },
		HMStringResItem {		/* item 11:Tester l'écran */
			-2999,18,
			-2999,19,
			-1,0,
			-1,0
		},
					HMSkipItem { },
		HMStringResItem {		/* item 13:Format d'impression… */
			-2999,20,
			-1,0,
			-1,0,
			-1,0
		},
		HMStringResItem {		/* item 14:Imprimer… */
			-2999,21,
			-1,0,
			-1,0,
			-1,0
		},
					HMSkipItem { },
		HMStringResItem {		/* item 16:Configurer… */
			-2999,22,
			-1,0,
			-1,0,
			-1,0
		},
					HMSkipItem { },
		HMStringResItem {		/* item 18:Quitter */
			-2999,23,
			-1,0,
			-1,0,
			-1,0
		}
	}
};

resource 'hdlg' (-3000,"Chercher") {
	HelpMgrVersion,
	0,
	hmDefaultOptions,
	0,
	0,
	HMSkipItem { },
	{

		HMStringResItem {		/* item 1:OK */
			{0,0},
			{0,0,0,0},
			-2999,24,
			-1,0,
			-1,0,
			-1,0
		},
		HMStringResItem {		/* item 2:Annuler */
			{0,0},
			{0,0,0,0},
			-2999,25,
			-1,0,
			-1,0,
			-1,0
		},
		HMStringResItem {		/* item 3:Texte */
			{0,0},
			{0,0,16,227},
			-2999,26,
			-1,0,
			-1,0,
			-1,0
		},
		HMStringResItem {		/* item 4:MAJ / minuscules */
			{0,0},
			{0,0,0,0},
			-2999,27,
			-1,0,
			-2999,28,
			-1,0
		},
		HMStringResItem {		/* item 5:Accents */
			{0,0},
			{0,0,0,0},
			-2999,29,
			-1,0,
			-2999,30,
			-2999,31
		},
		HMStringResItem {		/* item 6:Recherche circulaire */
			{0,0},
			{0,0,0,0},
			-2999,32,
			-1,0,
			-2999,33,
			-1,0
		}
	}
};

resource 'hdlg' (-2999,"Config") {
	HelpMgrVersion,
	0,
	hmDefaultOptions,
	0,
	0,
	HMSkipItem { },
	{

		HMStringResItem {		/* item 1:OK */
			{0,0},
			{0,0,0,0},
			-2999,34,
			-1,0,
			-1,0,
			-1,0
		},
		HMStringResItem {		/* item 2:Annuler */
			{0,0},
			{0,0,0,0},
			-2999,35,
			-1,0,
			-1,0,
			-1,0
		},
		HMStringResItem {		/* item 3:Utiliser l'émulateur */
			{0,0},
			{0,0,0,0},
			-2999,36,
			-1,0,
			-2999,37,
			-1,0
		},
		HMStringResItem {		/* item 4:Utiliser le Modem Dragster */
			{0,0},
			{0,0,0,0},
			-2999,38,
			-1,0,
			-2999,39,
			-1,0
		},
		HMStringResItem {		/* item 5:Port Modem */
			{0,0},
			{0,0,0,0},
			-2999,40,
			-2999,41,
			-2999,42,
			-1,0
		},
		HMStringResItem {		/* item 6:Port Imprimante */
			{0,0},
			{0,0,0,0},
			-2999,43,
			-2999,44,
			-2999,45,
			-1,0
		}
	}
};

resource 'hdlg' (-2998,"Opt. Analyse") {
	HelpMgrVersion,
	0,
	hmDefaultOptions,
	0,
	0,
	HMSkipItem { },
	{

		HMStringResItem {		/* item 1:Ok */
			{0,0},
			{0,0,0,0},
			-2999,46,
			-1,0,
			-1,0,
			-1,0
		},
		HMStringResItem {		/* item 2:Annuler */
			{0,0},
			{0,0,0,0},
			-2999,47,
			-1,0,
			-1,0,
			-1,0
		},
		HMStringResItem {		/* item 3:Liste des variables */
			{0,0},
			{0,0,0,0},
			-2999,48,
			-1,0,
			-2999,49,
			-1,0
		},
		HMStringResItem {		/* item 4:Liste des étiquettes */
			{0,0},
			{0,0,0,0},
			-2999,50,
			-1,0,
			-2998,1,
			-1,0
		},
		HMStringResItem {		/* item 5:Liste des constantes chaînes */
			{0,0},
			{0,0,0,0},
			-2998,2,
			-1,0,
			-2998,3,
			-1,0
		}
	}
};

resource 'hdlg' (-2997,"Opt. Compilation") {
	HelpMgrVersion,
	0,
	hmDefaultOptions,
	0,
	0,
	HMSkipItem { },
	{

		HMStringResItem {		/* item 1:Ok */
			{0,0},
			{0,0,0,0},
			-2998,4,
			-1,0,
			-1,0,
			-1,0
		},
		HMStringResItem {		/* item 2:Annuler */
			{0,0},
			{0,0,0,0},
			-2998,5,
			-1,0,
			-1,0,
			-1,0
		},
		HMStringResItem {		/* item 3:Listing de compilation */
			{0,0},
			{0,0,0,0},
			-2998,6,
			-1,0,
			-2998,7,
			-1,0
		},
		HMStringResItem {		/* item 4:Liste des variables */
			{0,0},
			{0,0,0,0},
			-2998,8,
			-1,0,
			-2998,9,
			-1,0
		},
		HMStringResItem {		/* item 5:Map des variables */
			{0,0},
			{0,0,0,0},
			-2998,10,
			-1,0,
			-2998,11,
			-1,0
		},
		HMStringResItem {		/* item 6:Afficher les noms des écrans */
			{0,0},
			{0,0,0,0},
			-2998,12,
			-1,0,
			-2998,13,
			-1,0
		},
		HMStringResItem {		/* item 7:Inclure N° de ligne dans le code */
			{0,0},
			{0,0,0,0},
			-2998,14,
			-2998,15,
			-2998,16,
			-1,0
		},
		HMStringResItem {		/* item 8:Inclure N° d'instruction dans le code */
			{0,0},
			{0,0,0,0},
			-2998,17,
			-2998,18,
			-2998,19,
			-1,0
		},
		HMStringResItem {		/* item 9:Vérifier les dépassements de tableaux */
			{0,0},
			{0,0,0,0},
			-2998,20,
			-1,0,
			-2998,21,
			-1,0
		}
	}
};

resource 'hdlg' (-2996,"Remplacer") {
	HelpMgrVersion,
	0,
	hmDefaultOptions,
	0,
	0,
	HMSkipItem { },
	{

		HMStringResItem {		/* item 1:OK */
			{0,0},
			{0,0,0,0},
			-2998,22,
			-1,0,
			-1,0,
			-1,0
		},
		HMStringResItem {		/* item 2:Annuler */
			{0,0},
			{0,0,0,0},
			-2998,23,
			-1,0,
			-1,0,
			-1,0
		},
		HMStringResItem {		/* item 3:Original */
			{0,0},
			{0,0,0,0},
			-2998,24,
			-1,0,
			-1,0,
			-1,0
		},
		HMStringResItem {		/* item 4:MAJ / minuscules */
			{0,0},
			{0,0,0,0},
			-2998,25,
			-1,0,
			-2998,26,
			-1,0
		},
		HMStringResItem {		/* item 5:Accents */
			{0,0},
			{0,0,0,0},
			-2998,27,
			-1,0,
			-2998,28,
			-1,0
		},
		HMStringResItem {		/* item 6:Recherche circulaire */
			{0,0},
			{0,0,0,0},
			-2998,29,
			-1,0,
			-2998,30,
			-1,0
		},
		HMStringResItem {		/* item 7:Text.Remplace */
			{0,0},
			{0,0,0,0},
			-2998,31,
			-1,0,
			-1,0,
			-1,0
		}
	}
};

resource 'hrct' (-3000,"Erreurs / Trace système") {
	HelpMgrVersion,
	hmDefaultOptions,
	0,
	0,
	{

		HMStringResItem {		/* Erreurs */
			{34,316},
			{19,301,49,331},
			-2998,32
		}
	}
};

resource 'hrct' (-2999,"Minitel") {
	HelpMgrVersion,
	hmDefaultOptions,
	0,
	0,
	{

		HMStringResItem {		/* Minitel */
			{134,231},
			{5,5,263,457},
			-2998,33
		}
	}
};

resource 'hrct' (-2998,"Routines externes") {
	HelpMgrVersion,
	hmDefaultOptions,
	0,
	0,
	{

		HMStringResItem {		/* Aide */
			{144,26},
			{135,17,190,329},
			-2998,34
		}
	}
};

resource 'hrct' (-2997,"Routines externes") {
	HelpMgrVersion,
	hmDefaultOptions,
	0,
	0,
	{

		HMStringResItem {		/* Liste */
			{123,191},
			{15,14,128,196},
			-2998,35
		}
	}
};



resource 'hwin' (-3000) {
	HelpMgrVersion,
	0,
	{
		-2997,	'hrct',	17,	"Routines externes",
		-2998,	'hrct',	17,	"Routines externes",
		-2999,	'hrct',	7,	"Minitel",
		-3000,	'hrct',	23,	"Erreurs / Trace système",
		-2996,	'hdlg',	9,	"Remplacer",	/* WARNING: this window title must be corrected! */
		-2997,	'hdlg',	16,	"Opt. Compilation",	/* WARNING: this window title must be corrected! */
		-2998,	'hdlg',	12,	"Opt. Analyse",
		-2999,	'hdlg',	6,	"Config",
		-3000,	'hdlg',	8,	"Chercher"	/* WARNING: this window title must be corrected! */
	}
};

resource 'STR#' (-3000, "Balloon Help String 1") {
	{
		/* [1] A propos de DragsterEdit…, Normal */
			"Affiche des informations sur DragsterEdit.",
		/* [2] Basic, Normal */
			"Menu Basic\$0D\$0DCe menu permet d'agir sur les sources Basic"
			" créés avec Dragster.",
		/* [3] Basic, Grayed */
			"Menu Basic\$0D\$0DCe menu permet d'agir sur les sources Basic"
			" créés avec Dragster.",
		/* [4] Analyser la syntaxe, Normal */
			"Analyse la syntaxe du source Basic courant.",
		/* [5] Analyser la syntaxe, Grayed */
			"Permet d'analyser la syntaxe d'un source Basic.\$0DPour acti"
			"ver ce choix, vous devez sélectionner une fenêtre contenant "
			"un source Basic.",
		/* [6] Compiler, Normal */
			"Compile un ensemble de sources en commençant par le source "
			"courant pour créer une application vidéotex éxécutable en tâ"
			"che de fond.",
		/* [7] Compiler, Grayed */
			"Permet de compiler un ensemble de sources pour créer une ap"
			"plication vidéotex éxécutable en tâche de fond.\$0DPour activ"
			"er ce choix, vous devez sélectionner une fenêtre contenant u"
			"n source Basic.",
		/* [8] Lancer l'application, Normal */
			"Lance l'exécution du source Basic courant en mode \"interpr"
			"etté\".",
		/* [9] Lancer l'application, Grayed */
			"Permet de lancer l'exécution du source Basic courant en mod"
			"e \"interpretté\".\$0DPour activer ce choix, vous devez sélec"
			"tionner une fenêtre contenant un source Basic analysé et déj"
			"à sauvé.",
		/* [10] Arrêter, Normal */
			"Stoppe l'exécution en cours.",
		/* [11] Arrêter, Grayed */
			"Permet de stopper l'exécution en cours.\$0DCe choix est inac"
			"tif car il n'y a aucune exécution en cours.",
		/* [12] Trace complète, Normal */
			"Active l'affichage complet des traces lors de l'exécution e"
			"n mode \"interpretté\".\$0DCes traces permettent de suivre le"
			" déroulement de votre application.",
		/* [13] Trace complète, Checked */
			"Supprime l'affichage complet des traces lors de l'exécution"
			" en mode \"interpretté\".\$0D",
		/* [14] Affichage des TRACE, Normal */
			"Active l'affichage des traces dans la fenêtre \"Erreurs/Tra"
			"ce système\".",
		/* [15] Affichage des TRACE, Checked */
			"Désactive l'affichage des traces dans la fenêtre \"Erreurs/"
			"Trace système\".",
		/* [16] Options d'analyse…, Normal */
			"Affiche un dialogue regroupant les options liées à l'analys"
			"e des sources Basic.",
		/* [17] Options de compilation…, Normal */
			"Affiche un dialogue regroupant les options liées à la compi"
			"lation d'une application vidéotex.",
		/* [18] Edition, Normal */
			"Menu Edition\$0D\$0DUtilisez ce menu pour annuler la dernière"
			" opération et pour manipuler votre source Basic.",
		/* [19] Edition, Grayed */
			"Menu Edition\$0D\$0DUtilisez ce menu pour annuler la dernière"
			" opération et pour manipuler votre source Basic.",
		/* [20] Annuler, Normal */
			"Annule la dernière opération. Permet de récupérer l'élément"
			" que vous venez de couper ou d'effacer, ou de supprimer celu"
			"i que vous venez de coller ou de taper.",
		/* [21] Annuler, Grayed */
			"Annule la dernière opération. Permet de récupérer l'élément"
			" que vous venez de couper ou d'effacer ou de supprimer celui"
			" que vous venez de coller ou de taper.\$0DCet article n'est p"
			"as disponible car la dernière opération effectuée ne peut êt"
			"re annulée.",
		/* [22] Couper, Normal */
			"Supprime la sélection et la transfère dans le Presse-papier"
			"s (zone de mémoire temporaire du Macintosh).",
		/* [23] Couper, Grayed */
			"Supprime la sélection et la transfère dans le Presse-papier"
			"s (zone de mémoire temporaire du Macintosh).\$0DCet article n"
			"'est pas disponible car aucun texte ou graphique n'est sélec"
			"tionné.",
		/* [24] Copier, Normal */
			"Place une copie de la sélection dans le Presse-papiers (zon"
			"e de mémoire temporaire du Macintosh) sans supprimer l'origi"
			"nal.",
		/* [25] Copier, Grayed */
			"Place une copie de la sélection dans le Presse-papiers (zon"
			"e de mémoire temporaire du Macintosh) sans supprimer l'origi"
			"nal.\$0DCet article n'est pas disponible car aucun texte ou g"
			"raphique n'est sélectionné.",
		/* [26] Coller, Normal */
			"Insère le contenu du Presse-papiers à l'emplacement du poin"
			"t d'insertion (ou à la place de la sélection).",
		/* [27] Coller, Grayed */
			"Insère le contenu du Presse-papiers à l'emplacement du poin"
			"t d'insertion (ou à la place de la sélection).\$0DNon disponi"
			"ble pour l'instant car le Presse-papiers est vide ou car il "
			"n'est pas possible de coller son contenu au point d'insertio"
			"n.",
		/* [28] Effacer, Normal */
			"Supprime définitivement la sélection sans la stocker dans l"
			"e Presse-papiers.",
		/* [29] Effacer, Grayed */
			"Supprime définitivement la sélection sans la stocker dans l"
			"e Presse-papiers.\$0DCet article n'est pas disponible car auc"
			"un texte ou graphique n'est sélectionné.",
		/* [30] Tout sélectionner, Normal */
			"Sélectionne tout le source Basic courant.",
		/* [31] Tout sélectionner, Grayed */
			"Permet de sélectionner tout le source Basic courant.\$0DPour"
			" activer ce choix, sélectionnez une fenêtre contenant un sou"
			"rce Basic.",
		/* [32] Chercher…, Normal */
			"Cherche une partie de texte dans le source Basic courant.",
		/* [33] Chercher…, Grayed */
			"Permet de chercher une partie de texte dans le source Basic"
			" courant.\$0DPour activer ce choix, sélectionnez une fenêtre "
			"contenant un source Basic.",
		/* [34] Chercher suivant, Normal */
			"Cherche la même partie de texte que précédemment.",
		/* [35] Chercher suivant, Grayed */
			"Permet de chercher la même partie de texte que précédemment"
			".\$0DPour activer ce choix, sélectionnez une fenêtre contenan"
			"t un source Basic.",
		/* [36] Remplacer…, Normal */
			"Remplace une partie de texte par une autre dans le source B"
			"asic courant.",
		/* [37] Remplacer…, Grayed */
			"Permet de remplacer une partie de texte par une autre dans "
			"le source Basic courant.\$0DPour activer ce choix, sélectionn"
			"ez une fenêtre contenant un source Basic.",
		/* [38] Remplacer suivant, Normal */
			"Effectue le même remplacement que precédemment.",
		/* [39] Remplacer suivant, Grayed */
			"Effectue le même remplacement que precédemment.\$0DPour acti"
			"ver ce choix, sélectionnez une fenêtre contenant un source B"
			"asic.",
		/* [40] Default balloon for Fenêtres, Normal */
			"Fait apparaître la fenêtre correspondante au premier plan.",
		/* [41] Fenêtres, Normal */
			"Menu Fenêtres\$0D\$0DCe menu agit sur les fenêtres de Dragste"
			"rEdit.",
		/* [42] Fenêtres, Grayed */
			"Menu Fenêtres\$0D\$0DCe menu agit sur les fenêtres de Dragste"
			"rEdit.",
		/* [43] Fenêtres Basic, Normal */
			"Fait apparaître les fenêtres contenant un source Basic.",
		/* [44] Fenêtres Basic, Checked */
			"Fait disparaître de l'écran les fenêtres contenant un sourc"
			"e Basic.",
		/* [45] Fenêtres Vidéotex, Normal */
			"Fait apparaître les fenêtres contenant une image vidéotex.",
		/* [46] Fenêtres Vidéotex, Checked */
			"Fait disparaître de l'écran les fenêtres contenant une imag"
			"e vidéotex.",
		/* [47] Fenêtre 'TRACE', Normal */
			"Fait disparaître le fenêtre \"Erreur/Trace système\".",
		/* [48] Fenêtre 'TRACE', Checked */
			"Fait apparaître le fenêtre \"Erreur/Trace système\".",
		/* [49] Routines Externes…, Normal */
			"Fait apparaître la fenêtre \"Routines externes\" contenant "
			"la liste des routines externes disponibles ainsi qu'une aide"
			" éventuelle.",
		/* [50] Fichier, Normal */
			"Menu Fichier\$0D\$0DUtilisez ce menu pour ouvrir, créer, sauv"
			"er, imprimer, fermer des \"écrans\" Dragster. Vous pouvez au"
			"ssi configurer et quitter DragsterEdit."
	}
};

resource 'STR#' (-2999, "Balloon Help String 2") {
	{
		/* [1] Fichier, Grayed */
			"Menu Fichier\$0D\$0DUtilisez ce menu pour ouvrir, créer, sauv"
			"er, imprimer, fermer des \"écrans\" Dragster. Vous pouvez au"
			"ssi configurer et quitter DragsterEdit.",
		/* [2] Nouvel écran, Normal */
			"Crée un nouvel écran vide.",
		/* [3] Nouvel écran, Grayed */
			"Permet de créer un nouvel écran.\$0DCe choix est indisponibl"
			"e car vous avez déjà beaucoup d'écrans ouverts. Fermez-en po"
			"ur réactiver ce choix.",
		/* [4] Ouvrir un écran…, Normal */
			"Ouvre un nouvel écran.",
		/* [5] Ouvrir un écran…, Grayed */
			"Permet d'ouvrir un nouvel écran.\$0DCe choix est indisponibl"
			"e car vous avez déjà beaucoup d'écrans ouverts. Fermez-en po"
			"ur réactiver ce choix.",
		/* [6] Dupliquer l'écran…, Normal */
			"Duplique un écran et ouvre un nouvel écran \"Sans Titre\" a"
			"vec la copie.",
		/* [7] Dupliquer l'écran…, Grayed */
			"Permet de dupliquer un écran et ouvre un nouvel écran \"San"
			"s Titre\" avec la copie.\$0DCe choix est indisponible car vou"
			"s avez déjà beaucoup d'écrans ouverts. Fermez-en pour réacti"
			"ver ce choix.",
		/* [8] Superposer l'écran…, Normal */
			"Superpose la partie vidéotex d'un écran sur l'écran courant"
			".",
		/* [9] Superposer l'écran…, Grayed */
			"Permet de superposer la partie vidéotex d'un écran sur l'éc"
			"ran courant.\$0DPour activer ce choix, sélectionner une fenêt"
			"re contenant une image vidéotex.",
		/* [10] Sauver l'écran, Normal */
			"Enregistre les modifications apportées à l'écran courant.",
		/* [11] Sauver l'écran, Grayed */
			"Permet d'enregistrer les modifications apportées à l'écran "
			"courant.",
		/* [12] Sauver l'écran sous…, Normal */
			"Enregistre l'écran courant sous un autre nom que son nom ac"
			"tuel.",
		/* [13] Sauver l'écran sous…, Grayed */
			"Permet d'enregistrer l'écran courant sous un autre nom que "
			"son nom actuel.",
		/* [14] Fermer l'écran, Normal */
			"Ferme l'écran courant.",
		/* [15] Fermer l'écran, Grayed */
			"Permet de fermer l'écran courant.\$0DCe choix est inactif ca"
			"r il n'y a aucun écran d'ouvert.",
		/* [16] Ecran original, Normal */
			"Relit la version original se trouvant encore sur disque de "
			"l'écran courant. Les modifications que vous venez de faire s"
			"eront perdues.",
		/* [17] Ecran original, Grayed */
			"Permet de relire la version original se trouvant encore sur"
			" disque de l'écran courant. Les modifications que vous venez"
			" de faire seront perdues.",
		/* [18] Tester l'écran, Normal */
			"Envoi l'image vidéotex de l'écran courant sur le minitel re"
			"lié à votre modem Dragster.",
		/* [19] Tester l'écran, Grayed */
			"Permet d'envoyer l'image vidéotex de l'écran courant sur le"
			" minitel relié à votre modem Dragster.\$0DCe choix est inacti"
			"f car vous n'avez pas branché de modem Dragster à votre Maci"
			"ntosh.",
		/* [20] Format d'impression…, Normal */
			"Affiche une zone de dialogue où vous précisez le format de "
			"papier utilisé, son orientation et d'autres options.",
		/* [21] Imprimer…, Normal */
			"Imprime le source Basic courant.",
		/* [22] Configurer…, Normal */
			"Affiche une zone de dialogue permettant de configurer Drags"
			"terEdit.",
		/* [23] Quitter, Normal */
			"Quitte DragsterEdit.",
		/* [24] OK, Normal */
			"Cliquez ici pour valider vos choix. ",
		/* [25] Annuler, Normal */
			"Cliquez ici pour annuler vos choix.",
		/* [26] Texte, Normal */
			"Cette zone contient le texte à chercher.",
		/* [27] MAJ / minuscules, Normal */
			"Cliquez ici si vous voulez que les Majuscules et les Minusc"
			"ules soient différenciées.",
		/* [28] MAJ / minuscules, Checked */
			"Cette option indique que les Majuscules et les Minuscules s"
			"ont différenciées lors des recherches.\$0DCliquez ici pour su"
			"pprimer cette option.",
		/* [29] Accents, Normal */
			"Cliquez ici si vous voulez que les accents soient pris en c"
			"ompte dans les recherches.",
		/* [30] Accents, Checked */
			"Cette option indique que les accents sont pris en compte da"
			"ns les recherches.\$0DCliquez ici pour supprimer cette option"
			".",
		/* [31] Accents, Other */
			"Accents\$0DOther\$0D",
		/* [32] Recherche circulaire, Normal */
			"Cliquez ici pour que les recherches reprennent au début du "
			"source une fois la fin atteinte.",
		/* [33] Recherche circulaire, Checked */
			"Cette option indique que les recherches reprennent au début"
			" du source une fois la fin atteinte.\$0DCliquez ici pour supp"
			"rimer cette option.",
		/* [34] OK, Normal */
			"Cliquez ici pour valider les modifications.",
		/* [35] Annuler, Normal */
			"Cliquez ici pour annuler les modifications.",
		/* [36] Utiliser l'émulateur, Normal */
			"Cliquez ici pour utiliser l'émulateur Minitel.",
		/* [37] Utiliser l'émulateur, Checked */
			"Cette option indique que DragsterEdit devra utiliser l'émul"
			"ateur Minitel lors de l'exécution en mode \"interpretté\".",
		/* [38] Utiliser le Modem Dragster, Normal */
			"Cliquez ici pour utiliser un Modem Dragster au lieu de l'ém"
			"ulateur Minitel.",
		/* [39] Utiliser le Modem Dragster, Checked */
			"Cette option indique que DragsterEdit devra utiliser le mod"
			"em Dragster lors de l'exécution en mode \"interpretté\".",
		/* [40] Port Modem, Normal */
			"Cliquez ici si votre Modem Dragster est branché sur le port"
			" \"Modem\".",
		/* [41] Port Modem, Grayed */
			"Cette option permet d'indiquer au programme que votre Modem"
			" Dragster est branché sur le port \"Modem\".\$0DPour activer "
			"cette option, vous devez choisir \"Utiliser le Modem Dragste"
			"r\" au préalable.",
		/* [42] Port Modem, Checked */
			"Cette option indique au programme que vous avez branché vot"
			"re Modem Dragster sur le port \"Modem\".",
		/* [43] Port Imprimante, Normal */
			"Cliquez ici si votre Modem Dragster est branché sur le port"
			" \"Imprimante\".",
		/* [44] Port Imprimante, Grayed */
			"Cette option permet d'indiquer au programme que votre Modem"
			" Dragster est branché sur le port \"Imprimante\".\$0DPour act"
			"iver cette option, vous devez choisir \"Utiliser le Modem Dr"
			"agster\" au préalable.",
		/* [45] Port Imprimante, Checked */
			"Cette option indique au programme que vous avez branché vot"
			"re Modem Dragster sur le port \"Imprimante\".",
		/* [46] Ok, Normal */
			"Cliquez ici pour valider vos choix. ",
		/* [47] Annuler, Normal */
			"Cliquez ici pour annuler vos choix.",
		/* [48] Liste des variables, Normal */
			"Cochez cette case pour obtenir la liste  des variables cont"
			"enues dans un source Basic après l'analyse de sa syntaxe.",
		/* [49] Liste des variables, Checked */
			"Lorsque cette case est cochée, la liste des variables conte"
			"nues dans un source Basic est affichée après l'analyse de sa"
			" syntaxe.\$0DCliquez sur la case pour ne plus afficher cette "
			"liste.",
		/* [50] Liste des étiquettes, Normal */
			"Cochez cette case pour obtenir la liste des étiquettes cont"
			"enues dans un source Basic après l'analyse de sa syntaxe.\$0D"
	}
};

resource 'STR#' (-2998, "Balloon Help String 3") {
	{
		/* [1] Liste des étiquettes, Checked */
			"Lorsque cette case est cochée, la liste des étiquettes cont"
			"enues dans un source Basic est affichée après l'analyse de s"
			"a syntaxe.\$0DCliquez sur la case pour ne plus afficher cette"
			" liste.",
		/* [2] Liste des constantes chaînes, Normal */
			"Cochez cette case pour obtenir la liste des constantes \"ch"
			"aînes\" contenues dans un source Basic après l'analyse de sa"
			" syntaxe.\$0D",
		/* [3] Liste des constantes chaînes, Checked */
			"Lorsque cette case est cochée, la liste des constantes \"ch"
			"aînes\" contenues dans un source Basic est affichée après l'"
			"analyse de sa syntaxe.\$0DCliquez sur la case pour ne plus af"
			"ficher cette liste.",
		/* [4] Ok, Normal */
			"Cliquez ici pour valider vos choix. ",
		/* [5] Annuler, Normal */
			"Cliquez ici pour annuler vos choix.",
		/* [6] Listing de compilation, Normal */
			"Cliquez ici si vous voulez qu'un listing soit créé au momen"
			"t de la compilation de votre application.",
		/* [7] Listing de compilation, Checked */
			"Cette option indique qu'un listing sera créé au moment de l"
			"a compilation de votre application.\$0DCliquez ici pour suppr"
			"imer cette option.",
		/* [8] Liste des variables, Normal */
			"Cliquez ici pour que la liste des variables utilisées par v"
			"otre application soit affichée dans la fenêtre de trace aprè"
			"s la compilation.",
		/* [9] Liste des variables, Checked */
			"Cette option indique que la liste des variables utilisées p"
			"ar votre application sera affichée dans la fenêtre de trace "
			"après la compilation.\$0DCliquez ici pour supprimer cette opt"
			"ion.",
		/* [10] Map des variables, Normal */
			"Cliquez ici pour que la liste des variables utilisées par v"
			"otre application soit enregistrée dans un fichier \"texte\" "
			"après la compilation.",
		/* [11] Map des variables, Checked */
			"Cette option indique que la liste des variables utilisées p"
			"ar votre application sera enregistrée dans un fichier \"text"
			"e\" après la compilation.\$0DCliquez ici pour supprimer cette"
			" option.",
		/* [12] Afficher les noms des écrans, Normal */
			"Cliquez ici pour que le nom de chaque écran compilé apparai"
			"sse dans la fenêtre \"Trace\" lors de la compilation de votr"
			"e application.",
		/* [13] Afficher les noms des écrans, Checked */
			"Cette option indique que le nom de chaque écran compilé app"
			"araîtra dans la fenêtre \"Trace\" lors de la compilation de "
			"votre application.\$0DCliqiez ici pour supprimer cette option"
			".",
		/* [14] Inclure N° de ligne dans le code, Normal */
			"Cliquez ici pour que les numéros des lignes soient inclus d"
			"ans votre application compilée.\$0DCette option est utile en "
			"cas de problème de fonctionnement de votre application.",
		/* [15] Inclure N° de ligne dans le code, Grayed */
			"Cette option est obligatoirement activée si vous avez deman"
			"dé de \"Vérifer les dépassements de tableaux\".",
		/* [16] Inclure N° de ligne dans le code, Checked */
			"Cette option indique que les numéros des lignes seront incl"
			"us dans votre application compilée.\$0DCette option est utile"
			" en cas de problème de fonctionnement de votre application.\$0D"
			"Cliquez ici pour supprimer cette option.",
		/* [17] Inclure N° d'instruction dans le code, Normal */
			"Cliquez ici pour que les numéros d'instruction soient inclu"
			"s dans votre application compilée.\$0DCette option est utile "
			"en cas de problème de fonctionnement de votre application.",
		/* [18] Inclure N° d'instruction dans le code, Grayed */
			"Cette option est obligatoirement activée si vous avez deman"
			"dé de \"Vérifer les dépassements de tableaux\".",
		/* [19] Inclure N° d'instruction dans le code, Checked */
			"Cette option indique que les numéros d'instruction seront i"
			"nclus dans votre application compilée.\$0DCette option est ut"
			"ile en cas de problème de fonctionnement de votre applicatio"
			"n.\$0DCliquez ici pour supprimer cette option.",
		/* [20] Vérifier les dépassements de tableaux, Normal */
			"Cliquez ici si vous voulez que le compilateur génère des in"
			"structions de test de dépassement des tableaux dans votre ap"
			"plication compilée.",
		/* [21] Vérifier les dépassements de tableaux, Checked */
			"Cette option indique que le compilateur génèrera des instru"
			"ctions de test de dépassement des tableaux dans votre applic"
			"ation compilée.\$0DCliquez ici pour supprimer cette option.",
		/* [22] OK, Normal */
			"Cliquez ici pour valider vos choix. ",
		/* [23] Annuler, Normal */
			"Cliquez ici pour annuler vos choix.",
		/* [24] Original, Normal */
			"Cette zone contient le texte original à chercher.",
		/* [25] MAJ / minuscules, Normal */
			"Cliquez ici si vous voulez que les Majuscules et les Minusc"
			"ules soient différenciées.",
		/* [26] MAJ / minuscules, Checked */
			"Cette option indique que les Majuscules et les Minuscules s"
			"ont différenciées lors des remplacements.\$0DCliquez ici pour"
			" supprimer cette option.",
		/* [27] Accents, Normal */
			"Cliquez ici si vous voulez que les accents soient pris en c"
			"ompte dans les remplacements.",
		/* [28] Accents, Checked */
			"Cette option indique que les accents sont pris en compte da"
			"ns les remplacements.\$0DCliquez ici pour supprimer cette opt"
			"ion.",
		/* [29] Recherche circulaire, Normal */
			"Cliquez ici pour que les recherches reprennent au début du "
			"source une fois la fin atteinte.",
		/* [30] Recherche circulaire, Checked */
			"Cette option indique que les recherches reprennent au début"
			" du source une fois la fin atteinte.\$0DCliquez ici pour supp"
			"rimer cette option.",
		/* [31] Text.Remplace, Normal */
			"Cette zone contient le texte qui remplacera le texte origin"
			"al cherché.",
		/* [32] Erreurs, Normal */
			"Cette fenêtre contient les messages provenant du programme "
			"durant l'analyse de syntaxe, la compilation ou l'éxécution d"
			"es sources Basic.",
		/* [33] Minitel, Normal */
			"Ce fenêtre contient une émulation Minitel permettant de tes"
			"ter votre application sans avoir à brancher un modem Dragste"
			"r et un Minitel à votre Macintosh.\$0D",
		/* [34] Aide, Normal */
			"Cette zone contient éventuellement une explication au sujet"
			" de la routine externe sélectionné dans la liste ci-dessus.",
		/* [35] Liste, Normal */
			"Ceci est la liste des routines externes disponibles.\$0DEn c"
			"liquant sur l'un des noms figurant dans cette liste, vous ob"
			"tiendrez plus d'informations sur la routines ainsi choisie."
	}
};

data 'TEXT' (-3000) {
			"DragsterEdit permet de créer, modifier, tester et compiler "
			"une application vidéotex permettent de transformer votre Mac"
			"intosh en serveur vidéotex."
};

resource 'hfdr' (-5696) {	/* Help balloon for application icon */
	HelpMgrVersion, hmDefaultOptions, 0, 0, /* header information */
	{
	HMTEResItem { -3000 }
	}
};

