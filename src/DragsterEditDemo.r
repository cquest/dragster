resource 'MENU' (261, "New Fenêtre", locked, preload) {
	261,
	textMenuProc,
	0x7FFFFFFB,
	enabled,
	"Fenêtres",
	{	/* array: 5 elements */
		/* [1] */
		"Fenêtres Basic", noIcon, "B", noMark, plain,
		/* [2] */
		"Fenêtres Vidéotex", noIcon, "P", noMark, plain,
		/* [3] */
		"-", noIcon, noKey, noMark, plain,
		/* [4] */
		"Fenêtre 'TRACE'", noIcon, noKey, noMark, plain,
		/* [5] */
		"Routines Externes…", noIcon, noKey, noMark, plain
	}
};

resource 'MENU' (262, "New Basic", locked, preload) {
	262,
	textMenuProc,
	0x7FFFFEDB,
	enabled,
	"Basic",
	{	/* array: 11 elements */
		/* [1] */
		"Analyser la syntaxe", noIcon, "Y", noMark, plain,
		/* [2] */
		"Compiler", noIcon, "K", noMark, plain,
		/* [3] */
		"-", noIcon, noKey, noMark, plain,
		/* [4] */
		"Lancer l'application", noIcon, "L", noMark, plain,
		/* [5] */
		"Arrêter", noIcon, ":", noMark, plain,
		/* [6] */
		"-", noIcon, noKey, noMark, plain,
		/* [7] */
		"Trace complète", noIcon, "+", noMark, plain,
		/* [8] */
		"Affichage des TRACE", noIcon, "-", noMark, plain,
		/* [9] */
		"-", noIcon, noKey, noMark, plain,
		/* [10] */
		"Options d'analyse…", noIcon, noKey, noMark, plain,
		/* [11] */
		"Options de compilation…", noIcon, noKey, noMark, plain
	}
};

resource 'MENU' (130, "Edition (Vidéotex)", preload) {
	258,
	textMenuProc,
	0x7FFFFFFC,
	enabled,
	"Edition",
	{	/* array: 7 elements */
		/* [1] */
		"Annuler", noIcon, "Z", noMark, plain,
		/* [2] */
		"-", noIcon, noKey, noMark, plain,
		/* [3] */
		"Couper", noIcon, "X", noMark, plain,
		/* [4] */
		"Copier", noIcon, "C", noMark, plain,
		/* [5] */
		"Coller", noIcon, "V", noMark, plain,
		/* [6] */
		"Effacer", noIcon, noKey, noMark, plain,
		/* [7] */
		"Tout effacer", noIcon, noKey, noMark, plain
	}
};

resource 'MENU' (256, "Apple", locked, preload) {
	256,
	textMenuProc,
	0x7FFFFFFD,
	enabled,
	apple,
	{	/* array: 2 elements */
		/* [1] */
		"A propos de DragsterEdit…", noIcon, noKey, noMark, plain,
		/* [2] */
		"-", noIcon, noKey, noMark, plain
	}
};

resource 'MENU' (257, "Fichier", locked, preload) {
	257,
	textMenuProc,
	0x7FFF9ABF,
	enabled,
	"Fichier",
	{	/* array: 18 elements */
		/* [1] */
		"Nouvel écran", noIcon, noKey, noMark, plain,
		/* [2] */
		"Ouvrir un écran…", noIcon, "O", noMark, plain,
		/* [3] */
		"Dupliquer l'écran…", noIcon, "D", noMark, plain,
		/* [4] */
		"Superposer l'écran…", noIcon, noKey, noMark, plain,
		/* [5] */
		"Sauver l'écran", noIcon, "S", noMark, plain,
		/* [6] */
		"Sauver l'écran sous…", noIcon, noKey, noMark, plain,
		/* [7] */
		"Fermer l'écran", noIcon, "W", noMark, plain,
		/* [8] */
		"-", noIcon, noKey, noMark, plain,
		/* [9] */
		"Ecran original", noIcon, noKey, noMark, plain,
		/* [10] */
		"-", noIcon, noKey, noMark, plain,
		/* [11] */
		"Tester l'écran", noIcon, "T", noMark, plain,
		/* [12] */
		"-", noIcon, noKey, noMark, plain,
		/* [13] */
		"Format d'impression…", noIcon, noKey, noMark, plain,
		/* [14] */
		"Imprimer…", noIcon, "I", noMark, plain,
		/* [15] */
		"-", noIcon, noKey, noMark, plain,
		/* [16] */
		"Configurer…", noIcon, noKey, noMark, plain,
		/* [17] */
		"-", noIcon, noKey, noMark, plain,
		/* [18] */
		"Quitter", noIcon, "Q", noMark, plain
	}
};

resource 'MENU' (258, "Edition", locked, preload) {
	258,
	textMenuProc,
	0x7FFFFFFD,
	enabled,
	"Edition",
	{	/* array: 12 elements */
		/* [1] */
		"Annuler", noIcon, "Z", noMark, plain,
		/* [2] */
		"-", noIcon, noKey, noMark, plain,
		/* [3] */
		"Couper", noIcon, "X", noMark, plain,
		/* [4] */
		"Copier", noIcon, "C", noMark, plain,
		/* [5] */
		"Coller", noIcon, "V", noMark, plain,
		/* [6] */
		"Effacer", noIcon, noKey, noMark, plain,
		/* [7] */
		"Tout sélectionner", noIcon, "A", noMark, plain,
		/* [8] */
		"-", noIcon, noKey, noMark, plain,
		/* [9] */
		"Chercher…", noIcon, "F", noMark, plain,
		/* [10] */
		"Chercher suivant", noIcon, "G", noMark, plain,
		/* [11] */
		"Remplacer…", noIcon, "R", noMark, plain,
		/* [12] */
		"Remplacer suivant", noIcon, "T", noMark, plain
	}
};

resource 'MENU' (260, "Jeu", preload) {
	260,
	textMenuProc,
	0x7FFFDF7B,
	enabled,
	"Jeu",
	{	/* array: 15 elements */
		/* [1] */
		"G0 - Normal", noIcon, "0", noMark, plain,
		/* [2] */
		"G1 - Graphique", noIcon, "1", noMark, plain,
		/* [3] */
		"-", noIcon, noKey, noMark, plain,
		/* [4] */
		"Grandeur normale", noIcon, "N", noMark, plain,
		/* [5] */
		"Double Hauteur", noIcon, "H", noMark, plain,
		/* [6] */
		"Double Largeur", noIcon, "L", noMark, plain,
		/* [7] */
		"Double Grandeur", noIcon, "G", noMark, plain,
		/* [8] */
		"-", noIcon, noKey, noMark, plain,
		/* [9] */
		"Flash", noIcon, "F", noMark, plain,
		/* [10] */
		"Souligné - Disjoint", noIcon, "D", noMark, plain,
		/* [11] */
		"Masquage", noIcon, "M", noMark, plain,
		/* [12] */
		"Fond inversé", noIcon, "I", noMark, plain,
		/* [13] */
		"Incrustation", noIcon, noKey, noMark, plain,
		/* [14] */
		"-", noIcon, noKey, noMark, plain,
		/* [15] */
		"Attributs normaux", noIcon, "=", noMark, plain
	}
};

resource 'MENU' (259, "Couleurs", preload) {
	259,
	textMenuProc,
	0x7FFFFDFE,
	enabled,
	"Couleurs",
	{	/* array: 18 elements */
		/* [1] */
		"Couleur du caractère", noIcon, noKey, noMark, plain,
		/* [2] */
		"0     %   Noir", noIcon, noKey, noMark, plain,
		/* [3] */
		"40   %   Bleu", noIcon, noKey, noMark, plain,
		/* [4] */
		"50   %   Rouge", noIcon, noKey, noMark, plain,
		/* [5] */
		"60   %   Magenta", noIcon, noKey, noMark, plain,
		/* [6] */
		"70   %   Vert", noIcon, noKey, noMark, plain,
		/* [7] */
		"80   %   Cyan", noIcon, noKey, noMark, plain,
		/* [8] */
		"90   %   Jaune", noIcon, noKey, noMark, plain,
		/* [9] */
		"100 %\t  Blanc", noIcon, noKey, noMark, plain,
		/* [10] */
		"Couleur du fond du caractère", noIcon, noKey, noMark, plain,
		/* [11] */
		"0     %   Noir", noIcon, noKey, noMark, plain,
		/* [12] */
		"40   %   Bleu", noIcon, noKey, noMark, plain,
		/* [13] */
		"50   %   Rouge", noIcon, noKey, noMark, plain,
		/* [14] */
		"60   %   Magenta", noIcon, noKey, noMark, plain,
		/* [15] */
		"70   %   Vert", noIcon, noKey, noMark, plain,
		/* [16] */
		"80   %   Cyan", noIcon, noKey, noMark, plain,
		/* [17] */
		"90   %   Jaune", noIcon, noKey, noMark, plain,
		/* [18] */
		"100 %\t  Blanc", noIcon, noKey, noMark, plain
	}
};

resource 'STR#' (256) {
	{	/* array StringArray: 5 elements */
		/* [1] */
		"Nom du nouvel écran:",
		/* [2] */
		"Sélectionner l'écran:",
		/* [3] */
		"Dupliquer l'écran:",
		/* [4] */
		"Nom du code compilé:",
		/* [5] */
		"Trace de compilation:"
	}
};

resource 'STR#' (257) {
	{	/* array StringArray: 34 elements */
		/* [1] */
		"La directory du disque destination est p"
		"leine. Changez de disquette destination.",
		/* [2] */
		"Le disque destination est plein. Changez"
		" de disque destination.",
		/* [3] */
		"La disquette destination est protégée co"
		"ntre l'écriture.",
		/* [4] */
		"Erreur disque n°:",
		/* [5] */
		"Dragster fonctionne déjà en arrière plan",
		/* [6] */
		"Pas d'aide pour cette routine externe.",
		/* [7] */
		"Fin d'éxécution",
		/* [8] */
		"Fin anormale: erreur ",
		/* [9] */
		"Page: ",
		/* [10] */
		"Erreur ",
		/* [11] */
		" dans ",
		/* [12] */
		"L: ",
		/* [13] */
		"C: ",
		/* [14] */
		"Pas de sélection",
		/* [15] */
		"sél. de ",
		/* [16] */
		"car",
		/* [17] */
		"cars",
		/* [18] */
		"Sans Titre",
		/* [19] */
		"Taille du code vidéotex: ",
		/* [20] */
		"Erreurs / Trace système",
		/* [21] */
		"Etiquettes:",
		/* [22] */
		"Etiquette",
		/* [23] */
		" ---> jamais définie !",
		/* [24] */
		"Variables locales à la tâche:",
		/* [25] */
		"Variables partagées (SHARED):",
		/* [26] */
		"Liste des constantes chaîne:",
		/* [27] */
		"Status: pas d'erreur",
		/* [28] */
		"Status: définissez les étiquettes manqua"
		"ntes",
		/* [29] */
		"Status: il manque ",
		/* [30] */
		" Wend/Next/Endif",
		/* [31] */
		"Erreur de compilation: ",
		/* [32] */
		"Fin de compilation",
		/* [33] */
		"Démarrage de ",
		/* [34] */
		"Code généré trop long !"
	}
};

resource 'STR#' (258) {
	{	/* array StringArray: 1 elements */
		/* [1] */
		"000000"
	}
};

resource 'STR#' (512) {
	{	/* array StringArray: 1 elements */
		/* [1] */
		"DragsterExternes"
	}
};

resource 'STR#' (261) {
	{	/* array StringArray: 29 elements */
		/* [1] */
		"Erreur de syntaxe",
		/* [2] */
		"Mauvaise valeur de paramêtre",
		/* [3] */
		"Etiquette non définie",
		/* [4] */
		"Redéfinition d'une étiquette",
		/* [5] */
		"Mauvais type de paramêtre",
		/* [6] */
		"Mauvais nombre de paramêtres",
		/* [7] */
		"FOR sans NEXT",
		/* [8] */
		"NEXT sans FOR",
		/* [9] */
		"WHILE sans WEND",
		/* [10] */
		"WEND sans WHILE",
		/* [11] */
		"Division par zéro",
		/* [12] */
		"RETURN sans GOSUB",
		/* [13] */
		"Problème de tokenisation",
		/* [14] */
		"Mauvais appel de la fonction",
		/* [15] */
		"Conflit de type",
		/* [16] */
		"Trop d'imbrications de WHILE ou FOR",
		/* [17] */
		"Trop d'imbrications de IF",
		/* [18] */
		"ELSE sans IF",
		/* [19] */
		"ENDIF sans IF",
		/* [20] */
		"BREAK sans WHILE ni FOR",
		/* [21] */
		"CONTINUE sans WHILE ni FOR",
		/* [22] */
		"Fichier non analysé ou introuvable",
		/* [23] */
		"Double définition d'une étiquette",
		/* [24] */
		"Mauvais numéro de fichier",
		/* [25] */
		"Fichier non ouvert",
		/* [26] */
		"Fichier déjà ouvert",
		/* [27] */
		"Erreur dans un indice de tableau",
		/* [28] */
		"Fonction ou Intruction indisponible en i"
		"nterpretté",
		/* [29] */
		"Queue vide"
	}
};

resource 'STR#' (259) {
	{	/* array StringArray: 1 elements */
		/* [1] */
		"SN# GJ9999G192"
	}
};

resource 'STR#' (262, "Msg Compilateur") {
	{	/* array StringArray: 42 elements */
		/* [1] */
		"Routine externe inconnue: ^0 dans ^1.",
		/* [2] */
		"Compilation de ^0 du ^1 à ^2",
		/* [3] */
		"Fichier executable en sortie: \"^0\"",
		/* [4] */
		"Options de compilation:",
		/* [5] */
		"  - inclusion des numéros de ligne dans "
		"le code",
		/* [6] */
		"  - inclusion des numéros d'instruction "
		"dans le code",
		/* [7] */
		"  - inclusion des bounds check dans le c"
		"ode",
		/* [8] */
		"Compilation démarrée à ^0",
		/* [9] */
		"*********** WARNINGs du module: ",
		/* [10] */
		"Erreur: tableau ^0 non dimensionné",
		/* [11] */
		"Nombre de modules: ",
		/* [12] */
		"Mod. Offset Nom",
		/* [13] */
		"Status de fin de compilation",
		/* [14] */
		"Nombre de Warnings   : ",
		/* [15] */
		"Taille du code       : ",
		/* [16] */
		"Taille des écrans    : ",
		/* [17] */
		"Taille des csts      : ",
		/* [18] */
		"Taille des partagées : ",
		/* [19] */
		"Taille des globales  : ",
		/* [20] */
		"Taille de la pile    : ",
		/* [21] */
		"Nombre d'écrans      : ",
		/* [22] */
		"Nombre de variables  : ",
		/* [23] */
		"Nb routines externes : ",
		/* [24] */
		"Liste des variables de compilation\n-----"
		"-----------------------------",
		/* [25] */
		"Routines externes utilisées:",
		/* [26] */
		"Génération de la map des variables",
		/* [27] */
		"Map des variables utilisées\n\nType Nom   "
		"                     Dim Offset Taille",
		/* [28] */
		"Erreur au module \"^0\"",
		/* [29] */
		"Compilation terminée à ^0",
		/* [30] */
		"Compilation stoppée à ^0",
		/* [31] */
		"Nombre de lignes compilées: ",
		/* [32] */
		"Erreur en cours de compilation\nMémoire s"
		"aturée",
		/* [33] */
		"Module ",
		/* [34] */
		"Problème avec: ",
		/* [35] */
		"Line Offset  Source",
		/* [36] */
		"La variable \"^0\" n'a pas été déclarée SH"
		"ARED dans un module précedent ou elle a "
		"été utilisée.",
		/* [37] */
		"Utilisation du tableau \"^0\" qui n'a pas "
		"encore été déclaré.",
		/* [38] */
		"Fin de module. Code généré: ",
		/* [39] */
		" octets",
		/* [40] */
		"*********** WARNING : pas de check pour "
		"\"^0\" - dimension inconnue",
		/* [41] */
		"utilisé par ",
		/* [42] */
		"Le fichier \"^0\" n'est pas au format Drag"
		"ster."
	}
};

resource 'STR#' (260) {
	{	/* array StringArray: 197 elements */
		/* [1] */
		"ABS",
		/* [2] */
		"AND",
		/* [3] */
		"APPEND",
		/* [4] */
		"ASC",
		/* [5] */
		"BACKCOLOR",
		/* [6] */
		"BREAK",
		/* [7] */
		"CHR$",
		/* [8] */
		"CLOSE",
		/* [9] */
		"CLS",
		/* [10] */
		"CONTINUE",
		/* [11] */
		"CREATE",
		/* [12] */
		"CURSOR",
		/* [13] */
		"DATE$",
		/* [14] */
		"DECSCREEN",
		/* [15] */
		"DELAY",
		/* [16] */
		"DELSPCR$",
		/* [17] */
		"DELSPCL$",
		/* [18] */
		"DIM",
		/* [19] */
		"DISCONNECT",
		/* [20] */
		"DRAW",
		/* [21] */
		"ECHO",
		/* [22] */
		"ELSE",
		/* [23] */
		"ENDIF",
		/* [24] */
		"NEXT",
		/* [25] */
		"WEND",
		/* [26] */
		"EOF",
		/* [27] */
		"ERROR",
		/* [28] */
		"FLASH",
		/* [29] */
		"FONT",
		/* [30] */
		"FOR",
		/* [31] */
		"FORECOLOR",
		/* [32] */
		"FORMAT$",
		/* [33] */
		"FPOS",
		/* [34] */
		"FPRINT",
		/* [35] */
		"GETEOF",
		/* [36] */
		"GOSUB",
		/* [37] */
		"GOSUBSCREEN",
		/* [38] */
		"GOTO",
		/* [39] */
		"GOTOSCREEN",
		/* [40] */
		"IF",
		/* [41] */
		"INPUT",
		/* [42] */
		"INSTR",
		/* [43] */
		"INVERSE",
		/* [44] */
		"KILL",
		/* [45] */
		"LEFT$",
		/* [46] */
		"LEN",
		/* [47] */
		"LOADSCREEN",
		/* [48] */
		"LOCATE",
		/* [49] */
		"LOGTIME",
		/* [50] */
		"LWC$",
		/* [51] */
		"MID$",
		/* [52] */
		"NOT",
		/* [53] */
		"ON",
		/* [54] */
		"OPEN",
		/* [55] */
		"OR",
		/* [56] */
		"PRINT",
		/* [57] */
		"READ",
		/* [58] */
		"REM",
		/* [59] */
		"RENAME",
		/* [60] */
		"RESETZONES",
		/* [61] */
		"RETURN",
		/* [62] */
		"RIGHT$",
		/* [63] */
		"RLEN",
		/* [64] */
		"RSEEK",
		/* [65] */
		"SEEK",
		/* [66] */
		"SETEOF",
		/* [67] */
		"SIZE",
		/* [68] */
		"SPC$",
		/* [69] */
		"STEP",
		/* [70] */
		"STR$",
		/* [71] */
		"STRING$",
		/* [72] */
		"TICKCOUNT",
		/* [73] */
		"TIME$",
		/* [74] */
		"TIMEOUT",
		/* [75] */
		"THEN",
		/* [76] */
		"TO",
		/* [77] */
		"TRACE",
		/* [78] */
		"TRON",
		/* [79] */
		"TROFF",
		/* [80] */
		"UNDERLINE",
		/* [81] */
		"UPC$",
		/* [82] */
		"VAL",
		/* [83] */
		"WAIT",
		/* [84] */
		"WAITCONNECT",
		/* [85] */
		"WHILE",
		/* [86] */
		"WRITE",
		/* [87] */
		"ZONENUMBER",
		/* [88] */
		"ZONE",
		/* [89] */
		"MESSAGE",
		/* [90] */
		"CANEOL",
		/* [91] */
		"DRAWSCREEN",
		/* [92] */
		"PEND",
		/* [93] */
		"POST",
		/* [94] */
		"LOCK",
		/* [95] */
		"UNLOCK",
		/* [96] */
		"CONTROLSN",
		/* [97] */
		"SHARED",
		/* [98] */
		"DIAL",
		/* [99] */
		"RESTART",
		/* [100] */
		"FRONTSCREEN",
		/* [101] */
		"GETID$",
		/* [102] */
		"SETID",
		/* [103] */
		"STATUS$",
		/* [104] */
		"TASKNUMBER",
		/* [105] */
		"GETPRIORITY",
		/* [106] */
		"SETPRIORITY",
		/* [107] */
		"YIELDCPU",
		/* [108] */
		"REQUEST",
		/* [109] */
		"SWMODEM",
		/* [110] */
		"CONNECTED",
		/* [111] */
		"CURPOS$",
		/* [112] */
		"SCROLL",
		/* [113] */
		"LOWER",
		/* [114] */
		"CANBLOCK",
		/* [115] */
		"MODNUMBER",
		/* [116] */
		"STARFLAG",
		/* [117] */
		"MESSDOWNLOAD$",
		/* [118] */
		"MESSUPLOAD",
		/* [119] */
		"BREAD",
		/* [120] */
		"BWRITE",
		/* [121] */
		"SYSPARM",
		/* [122] */
		"GETFILE$",
		/* [123] */
		"_SE_INIT",
		/* [124] */
		"_SE_MOTEUR",
		/* [125] */
		"_SE_RESULTAT",
		/* [126] */
		"_SE_DONNEE",
		/* [127] */
		"KEY",
		/* [128] */
		"PRINTSCREEN",
		/* [129] */
		"ENQUEUE",
		/* [130] */
		"DEQUEUE$",
		/* [131] */
		"_SE_QUESTION",
		/* [132] */
		"SIMILARITY",
		/* [133] */
		"RESETQUEUE",
		/* [134] */
		"QUEUESIZE",
		/* [135] */
		"END",
		/* [136] */
		"GET$",
		/* [137] */
		"GETPAQ$",
		/* [138] */
		"SERCONFIG",
		/* [139] */
		"SECS",
		/* [140] */
		"DATE2SECS",
		/* [141] */
		"SECS2DATE$",
		/* [142] */
		"NEWFOLDER",
		/* [143] */
		"GETFINFO",
		/* [144] */
		"SETFINFO",
		/* [145] */
		"GETVOL$",
		/* [146] */
		"RND",
		/* [147] */
		"OPENSER",
		/* [148] */
		"FILTER",
		/* [149] */
		"PAR",
		/* [150] */
		"LISTE",
		/* [151] */
		"LIGNE",
		/* [152] */
		"*",
		/* [153] */
		"/",
		/* [154] */
		"MOD",
		/* [155] */
		"+",
		/* [156] */
		"+",
		/* [157] */
		"-",
		/* [158] */
		"-",
		/* [159] */
		"=",
		/* [160] */
		"<",
		/* [161] */
		">",
		/* [162] */
		"<=",
		/* [163] */
		">=",
		/* [164] */
		"<>",
		/* [165] */
		"ETIQ",
		/* [166] */
		";",
		/* [167] */
		",",
		/* [168] */
		"NUMCSTDEC",
		/* [169] */
		"STRCSTDEC",
		/* [170] */
		"NUMVARDEC",
		/* [171] */
		"STRVARDEC",
		/* [172] */
		"UETIQ",
		/* [173] */
		"ISNUMVARDEC",
		/* [174] */
		"ISSTRVARDEC",
		/* [175] */
		"INUMVARDEC",
		/* [176] */
		"ISTRVARDEC",
		/* [177] */
		"IUETIQ",
		/* [178] */
		"REMSTR",
		/* [179] */
		"BASEOPEN",
		/* [180] */
		"BASECLOSE",
		/* [181] */
		"BASESEEK",
		/* [182] */
		"BASEUPDATE",
		/* [183] */
		"BASEADD",
		/* [184] */
		"BASEREMOVE",
		/* [185] */
		"BASENEXT",
		/* [186] */
		"BASEPRED",
		/* [187] */
		"BASECREATE",
		/* [188] */
		"BASEINFO",
		/* [189] */
		"BASERINC",
		/* [190] */
		"BASEREAD",
		/* [191] */
		"BASESETREF",
		/* [192] */
		"BASEGETREF",
		/* [193] */
		"TRPRINT",
		/* [194] */
		"INPUTMODE",
		/* [195] */
		"RUNFLAGS$",
		/* [196] */
		"OPENRF",
		/* [197] */
		"BASEMAXSIZE"
	}
};

resource 'STR#' (-3000, "Balloon Help String 1") {
	{	/* array StringArray: 50 elements */
		/* [1] */
		"Affiche des informations sur DragsterEdi"
		"t.",
		/* [2] */
		"Menu Basic\n\nCe menu permet d'agir sur le"
		"s sources Basic créés avec Dragster.",
		/* [3] */
		"Menu Basic\n\nCe menu permet d'agir sur le"
		"s sources Basic créés avec Dragster.",
		/* [4] */
		"Analyse la syntaxe du source Basic coura"
		"nt.",
		/* [5] */
		"Permet d'analyser la syntaxe d'un source"
		" Basic.\nPour activer ce choix, vous deve"
		"z sélectionner une fenêtre contenant un "
		"source Basic.",
		/* [6] */
		"Compile un ensemble de sources en commen"
		"çant par le source courant pour créer un"
		"e application vidéotex éxécutable en tâc"
		"he de fond.",
		/* [7] */
		"Permet de compiler un ensemble de source"
		"s pour créer une application vidéotex éx"
		"écutable en tâche de fond.\nPour activer "
		"ce choix, vous devez sélectionner une fe"
		"nêtre contenant un source Basic.",
		/* [8] */
		"Lance l'exécution du source Basic couran"
		"t en mode \"interpretté\".",
		/* [9] */
		"Permet de lancer l'exécution du source B"
		"asic courant en mode \"interpretté\".\nPour"
		" activer ce choix, vous devez sélectionn"
		"er une fenêtre contenant un source Basic"
		" analysé et déjà sauvé.",
		/* [10] */
		"Stoppe l'exécution en cours.",
		/* [11] */
		"Permet de stopper l'exécution en cours.\n"
		"Ce choix est inactif car il n'y a aucune"
		" exécution en cours.",
		/* [12] */
		"Active l'affichage complet des traces lo"
		"rs de l'exécution en mode \"interpretté\"."
		"\nCes traces permettent de suivre le déro"
		"ulement de votre application.",
		/* [13] */
		"Supprime l'affichage complet des traces "
		"lors de l'exécution en mode \"interpretté"
		"\".\n",
		/* [14] */
		"Active l'affichage des traces dans la fe"
		"nêtre \"Erreurs/Trace système\".",
		/* [15] */
		"Désactive l'affichage des traces dans la"
		" fenêtre \"Erreurs/Trace système\".",
		/* [16] */
		"Affiche un dialogue regroupant les optio"
		"ns liées à l'analyse des sources Basic.",
		/* [17] */
		"Affiche un dialogue regroupant les optio"
		"ns liées à la compilation d'une applicat"
		"ion vidéotex.",
		/* [18] */
		"Menu Edition\n\nUtilisez ce menu pour annu"
		"ler la dernière opération et pour manipu"
		"ler votre source Basic.",
		/* [19] */
		"Menu Edition\n\nUtilisez ce menu pour annu"
		"ler la dernière opération et pour manipu"
		"ler votre source Basic.",
		/* [20] */
		"Annule la dernière opération. Permet de "
		"récupérer l'élément que vous venez de co"
		"uper ou d'effacer, ou de supprimer celui"
		" que vous venez de coller ou de taper.",
		/* [21] */
		"Annule la dernière opération. Permet de "
		"récupérer l'élément que vous venez de co"
		"uper ou d'effacer ou de supprimer celui "
		"que vous venez de coller ou de taper.\nCe"
		"t article n'est pas disponible car la de"
		"rnière opération effectuée ne peut être "
		"annulée.",
		/* [22] */
		"Supprime la sélection et la transfère da"
		"ns le Presse-papiers (zone de mémoire te"
		"mporaire du Macintosh).",
		/* [23] */
		"Supprime la sélection et la transfère da"
		"ns le Presse-papiers (zone de mémoire te"
		"mporaire du Macintosh).\nCet article n'es"
		"t pas disponible car aucun texte ou grap"
		"hique n'est sélectionné.",
		/* [24] */
		"Place une copie de la sélection dans le "
		"Presse-papiers (zone de mémoire temporai"
		"re du Macintosh) sans supprimer l'origin"
		"al.",
		/* [25] */
		"Place une copie de la sélection dans le "
		"Presse-papiers (zone de mémoire temporai"
		"re du Macintosh) sans supprimer l'origin"
		"al.\nCet article n'est pas disponible car"
		" aucun texte ou graphique n'est sélectio"
		"nné.",
		/* [26] */
		"Insère le contenu du Presse-papiers à l'"
		"emplacement du point d'insertion (ou à l"
		"a place de la sélection).",
		/* [27] */
		"Insère le contenu du Presse-papiers à l'"
		"emplacement du point d'insertion (ou à l"
		"a place de la sélection).\nNon disponible"
		" pour l'instant car le Presse-papiers es"
		"t vide ou car il n'est pas possible de c"
		"oller son contenu au point d'insertion.",
		/* [28] */
		"Supprime définitivement la sélection san"
		"s la stocker dans le Presse-papiers.",
		/* [29] */
		"Supprime définitivement la sélection san"
		"s la stocker dans le Presse-papiers.\nCet"
		" article n'est pas disponible car aucun "
		"texte ou graphique n'est sélectionné.",
		/* [30] */
		"Sélectionne tout le source Basic courant"
		".",
		/* [31] */
		"Permet de sélectionner tout le source Ba"
		"sic courant.\nPour activer ce choix, séle"
		"ctionnez une fenêtre contenant un source"
		" Basic.",
		/* [32] */
		"Cherche une partie de texte dans le sour"
		"ce Basic courant.",
		/* [33] */
		"Permet de chercher une partie de texte d"
		"ans le source Basic courant.\nPour active"
		"r ce choix, sélectionnez une fenêtre con"
		"tenant un source Basic.",
		/* [34] */
		"Cherche la même partie de texte que préc"
		"édemment.",
		/* [35] */
		"Permet de chercher la même partie de tex"
		"te que précédemment.\nPour activer ce cho"
		"ix, sélectionnez une fenêtre contenant u"
		"n source Basic.",
		/* [36] */
		"Remplace une partie de texte par une aut"
		"re dans le source Basic courant.",
		/* [37] */
		"Permet de remplacer une partie de texte "
		"par une autre dans le source Basic coura"
		"nt.\nPour activer ce choix, sélectionnez "
		"une fenêtre contenant un source Basic.",
		/* [38] */
		"Effectue le même remplacement que precéd"
		"emment.",
		/* [39] */
		"Effectue le même remplacement que precéd"
		"emment.\nPour activer ce choix, sélection"
		"nez une fenêtre contenant un source Basi"
		"c.",
		/* [40] */
		"Fait apparaître la fenêtre correspondant"
		"e au premier plan.",
		/* [41] */
		"Menu Fenêtres\n\nCe menu agit sur les fenê"
		"tres de DragsterEdit.",
		/* [42] */
		"Menu Fenêtres\n\nCe menu agit sur les fenê"
		"tres de DragsterEdit.",
		/* [43] */
		"Fait apparaître les fenêtres contenant u"
		"n source Basic.",
		/* [44] */
		"Fait disparaître de l'écran les fenêtres"
		" contenant un source Basic.",
		/* [45] */
		"Fait apparaître les fenêtres contenant u"
		"ne image vidéotex.",
		/* [46] */
		"Fait disparaître de l'écran les fenêtres"
		" contenant une image vidéotex.",
		/* [47] */
		"Fait disparaître le fenêtre \"Erreur/Trac"
		"e système\".",
		/* [48] */
		"Fait apparaître le fenêtre \"Erreur/Trace"
		" système\".",
		/* [49] */
		"Fait apparaître la fenêtre \"Routines ext"
		"ernes\" contenant la liste des routines e"
		"xternes disponibles ainsi qu'une aide év"
		"entuelle.",
		/* [50] */
		"Menu Fichier\n\nUtilisez ce menu pour ouvr"
		"ir, créer, sauver, imprimer, fermer des "
		"\"écrans\" Dragster. Vous pouvez aussi con"
		"figurer et quitter DragsterEdit."
	}
};

resource 'STR#' (-2999, "Balloon Help String 2") {
	{	/* array StringArray: 50 elements */
		/* [1] */
		"Menu Fichier\n\nUtilisez ce menu pour ouvr"
		"ir, créer, sauver, imprimer, fermer des "
		"\"écrans\" Dragster. Vous pouvez aussi con"
		"figurer et quitter DragsterEdit.",
		/* [2] */
		"Crée un nouvel écran vide.",
		/* [3] */
		"Permet de créer un nouvel écran.\nCe choi"
		"x est indisponible car vous avez déjà be"
		"aucoup d'écrans ouverts. Fermez-en pour "
		"réactiver ce choix.",
		/* [4] */
		"Ouvre un nouvel écran.",
		/* [5] */
		"Permet d'ouvrir un nouvel écran.\nCe choi"
		"x est indisponible car vous avez déjà be"
		"aucoup d'écrans ouverts. Fermez-en pour "
		"réactiver ce choix.",
		/* [6] */
		"Duplique un écran et ouvre un nouvel écr"
		"an \"Sans Titre\" avec la copie.",
		/* [7] */
		"Permet de dupliquer un écran et ouvre un"
		" nouvel écran \"Sans Titre\" avec la copie"
		".\nCe choix est indisponible car vous ave"
		"z déjà beaucoup d'écrans ouverts. Fermez"
		"-en pour réactiver ce choix.",
		/* [8] */
		"Superpose la partie vidéotex d'un écran "
		"sur l'écran courant.",
		/* [9] */
		"Permet de superposer la partie vidéotex "
		"d'un écran sur l'écran courant.\nPour act"
		"iver ce choix, sélectionner une fenêtre "
		"contenant une image vidéotex.",
		/* [10] */
		"Enregistre les modifications apportées à"
		" l'écran courant.",
		/* [11] */
		"Permet d'enregistrer les modifications a"
		"pportées à l'écran courant.",
		/* [12] */
		"Enregistre l'écran courant sous un autre"
		" nom que son nom actuel.",
		/* [13] */
		"Permet d'enregistrer l'écran courant sou"
		"s un autre nom que son nom actuel.",
		/* [14] */
		"Ferme l'écran courant.",
		/* [15] */
		"Permet de fermer l'écran courant.\nCe cho"
		"ix est inactif car il n'y a aucun écran "
		"d'ouvert.",
		/* [16] */
		"Relit la version original se trouvant en"
		"core sur disque de l'écran courant. Les "
		"modifications que vous venez de faire se"
		"ront perdues.",
		/* [17] */
		"Permet de relire la version original se "
		"trouvant encore sur disque de l'écran co"
		"urant. Les modifications que vous venez "
		"de faire seront perdues.",
		/* [18] */
		"Envoi l'image vidéotex de l'écran couran"
		"t sur le minitel relié à votre modem Dra"
		"gster.",
		/* [19] */
		"Permet d'envoyer l'image vidéotex de l'é"
		"cran courant sur le minitel relié à votr"
		"e modem Dragster.\nCe choix est inactif c"
		"ar vous n'avez pas branché de modem Drag"
		"ster à votre Macintosh.",
		/* [20] */
		"Affiche une zone de dialogue où vous pré"
		"cisez le format de papier utilisé, son o"
		"rientation et d'autres options.",
		/* [21] */
		"Imprime le source Basic courant.",
		/* [22] */
		"Affiche une zone de dialogue permettant "
		"de configurer DragsterEdit.",
		/* [23] */
		"Quitte DragsterEdit.",
		/* [24] */
		"Cliquez ici pour valider vos choix. ",
		/* [25] */
		"Cliquez ici pour annuler vos choix.",
		/* [26] */
		"Cette zone contient le texte à chercher.",
		/* [27] */
		"Cliquez ici si vous voulez que les Majus"
		"cules et les Minuscules soient différenc"
		"iées.",
		/* [28] */
		"Cette option indique que les Majuscules "
		"et les Minuscules sont différenciées lor"
		"s des recherches.\nCliquez ici pour suppr"
		"imer cette option.",
		/* [29] */
		"Cliquez ici si vous voulez que les accen"
		"ts soient pris en compte dans les recher"
		"ches.",
		/* [30] */
		"Cette option indique que les accents son"
		"t pris en compte dans les recherches.\nCl"
		"iquez ici pour supprimer cette option.",
		/* [31] */
		"Accents\nOther\n",
		/* [32] */
		"Cliquez ici pour que les recherches repr"
		"ennent au début du source une fois la fi"
		"n atteinte.",
		/* [33] */
		"Cette option indique que les recherches "
		"reprennent au début du source une fois l"
		"a fin atteinte.\nCliquez ici pour supprim"
		"er cette option.",
		/* [34] */
		"Cliquez ici pour valider les modificatio"
		"ns.",
		/* [35] */
		"Cliquez ici pour annuler les modificatio"
		"ns.",
		/* [36] */
		"Cliquez ici pour utiliser l'émulateur Mi"
		"nitel.",
		/* [37] */
		"Cette option indique que DragsterEdit de"
		"vra utiliser l'émulateur Minitel lors de"
		" l'exécution en mode \"interpretté\".",
		/* [38] */
		"Cliquez ici pour utiliser un Modem Drags"
		"ter au lieu de l'émulateur Minitel.",
		/* [39] */
		"Cette option indique que DragsterEdit de"
		"vra utiliser le modem Dragster lors de l"
		"'exécution en mode \"interpretté\".",
		/* [40] */
		"Cliquez ici si votre Modem Dragster est "
		"branché sur le port \"Modem\".",
		/* [41] */
		"Cette option permet d'indiquer au progra"
		"mme que votre Modem Dragster est branché"
		" sur le port \"Modem\".\nPour activer cette"
		" option, vous devez choisir \"Utiliser le"
		" Modem Dragster\" au préalable.",
		/* [42] */
		"Cette option indique au programme que vo"
		"us avez branché votre Modem Dragster sur"
		" le port \"Modem\".",
		/* [43] */
		"Cliquez ici si votre Modem Dragster est "
		"branché sur le port \"Imprimante\".",
		/* [44] */
		"Cette option permet d'indiquer au progra"
		"mme que votre Modem Dragster est branché"
		" sur le port \"Imprimante\".\nPour activer "
		"cette option, vous devez choisir \"Utilis"
		"er le Modem Dragster\" au préalable.",
		/* [45] */
		"Cette option indique au programme que vo"
		"us avez branché votre Modem Dragster sur"
		" le port \"Imprimante\".",
		/* [46] */
		"Cliquez ici pour valider vos choix. ",
		/* [47] */
		"Cliquez ici pour annuler vos choix.",
		/* [48] */
		"Cochez cette case pour obtenir la liste "
		" des variables contenues dans un source "
		"Basic après l'analyse de sa syntaxe.",
		/* [49] */
		"Lorsque cette case est cochée, la liste "
		"des variables contenues dans un source B"
		"asic est affichée après l'analyse de sa "
		"syntaxe.\nCliquez sur la case pour ne plu"
		"s afficher cette liste.",
		/* [50] */
		"Cochez cette case pour obtenir la liste "
		"des étiquettes contenues dans un source "
		"Basic après l'analyse de sa syntaxe.\n"
	}
};

resource 'STR#' (-2998, "Balloon Help String 3") {
	{	/* array StringArray: 35 elements */
		/* [1] */
		"Lorsque cette case est cochée, la liste "
		"des étiquettes contenues dans un source "
		"Basic est affichée après l'analyse de sa"
		" syntaxe.\nCliquez sur la case pour ne pl"
		"us afficher cette liste.",
		/* [2] */
		"Cochez cette case pour obtenir la liste "
		"des constantes \"chaînes\" contenues dans "
		"un source Basic après l'analyse de sa sy"
		"ntaxe.\n",
		/* [3] */
		"Lorsque cette case est cochée, la liste "
		"des constantes \"chaînes\" contenues dans "
		"un source Basic est affichée après l'ana"
		"lyse de sa syntaxe.\nCliquez sur la case "
		"pour ne plus afficher cette liste.",
		/* [4] */
		"Cliquez ici pour valider vos choix. ",
		/* [5] */
		"Cliquez ici pour annuler vos choix.",
		/* [6] */
		"Cliquez ici si vous voulez qu'un listing"
		" soit créé au moment de la compilation d"
		"e votre application.",
		/* [7] */
		"Cette option indique qu'un listing sera "
		"créé au moment de la compilation de votr"
		"e application.\nCliquez ici pour supprime"
		"r cette option.",
		/* [8] */
		"Cliquez ici pour que la liste des variab"
		"les utilisées par votre application soit"
		" affichée dans la fenêtre de trace après"
		" la compilation.",
		/* [9] */
		"Cette option indique que la liste des va"
		"riables utilisées par votre application "
		"sera affichée dans la fenêtre de trace a"
		"près la compilation.\nCliquez ici pour su"
		"pprimer cette option.",
		/* [10] */
		"Cliquez ici pour que la liste des variab"
		"les utilisées par votre application soit"
		" enregistrée dans un fichier \"texte\" apr"
		"ès la compilation.",
		/* [11] */
		"Cette option indique que la liste des va"
		"riables utilisées par votre application "
		"sera enregistrée dans un fichier \"texte\""
		" après la compilation.\nCliquez ici pour "
		"supprimer cette option.",
		/* [12] */
		"Cliquez ici pour que le nom de chaque éc"
		"ran compilé apparaisse dans la fenêtre \""
		"Trace\" lors de la compilation de votre a"
		"pplication.",
		/* [13] */
		"Cette option indique que le nom de chaqu"
		"e écran compilé apparaîtra dans la fenêt"
		"re \"Trace\" lors de la compilation de vot"
		"re application.\nCliqiez ici pour supprim"
		"er cette option.",
		/* [14] */
		"Cliquez ici pour que les numéros des lig"
		"nes soient inclus dans votre application"
		" compilée.\nCette option est utile en cas"
		" de problème de fonctionnement de votre "
		"application.",
		/* [15] */
		"Cette option est obligatoirement activée"
		" si vous avez demandé de \"Vérifer les dé"
		"passements de tableaux\".",
		/* [16] */
		"Cette option indique que les numéros des"
		" lignes seront inclus dans votre applica"
		"tion compilée.\nCette option est utile en"
		" cas de problème de fonctionnement de vo"
		"tre application.\nCliquez ici pour suppri"
		"mer cette option.",
		/* [17] */
		"Cliquez ici pour que les numéros d'instr"
		"uction soient inclus dans votre applicat"
		"ion compilée.\nCette option est utile en "
		"cas de problème de fonctionnement de vot"
		"re application.",
		/* [18] */
		"Cette option est obligatoirement activée"
		" si vous avez demandé de \"Vérifer les dé"
		"passements de tableaux\".",
		/* [19] */
		"Cette option indique que les numéros d'i"
		"nstruction seront inclus dans votre appl"
		"ication compilée.\nCette option est utile"
		" en cas de problème de fonctionnement de"
		" votre application.\nCliquez ici pour sup"
		"primer cette option.",
		/* [20] */
		"Cliquez ici si vous voulez que le compil"
		"ateur génère des instructions de test de"
		" dépassement des tableaux dans votre app"
		"lication compilée.",
		/* [21] */
		"Cette option indique que le compilateur "
		"génèrera des instructions de test de dép"
		"assement des tableaux dans votre applica"
		"tion compilée.\nCliquez ici pour supprime"
		"r cette option.",
		/* [22] */
		"Cliquez ici pour valider vos choix. ",
		/* [23] */
		"Cliquez ici pour annuler vos choix.",
		/* [24] */
		"Cette zone contient le texte original à "
		"chercher.",
		/* [25] */
		"Cliquez ici si vous voulez que les Majus"
		"cules et les Minuscules soient différenc"
		"iées.",
		/* [26] */
		"Cette option indique que les Majuscules "
		"et les Minuscules sont différenciées lor"
		"s des remplacements.\nCliquez ici pour su"
		"pprimer cette option.",
		/* [27] */
		"Cliquez ici si vous voulez que les accen"
		"ts soient pris en compte dans les rempla"
		"cements.",
		/* [28] */
		"Cette option indique que les accents son"
		"t pris en compte dans les remplacements."
		"\nCliquez ici pour supprimer cette option"
		".",
		/* [29] */
		"Cliquez ici pour que les recherches repr"
		"ennent au début du source une fois la fi"
		"n atteinte.",
		/* [30] */
		"Cette option indique que les recherches "
		"reprennent au début du source une fois l"
		"a fin atteinte.\nCliquez ici pour supprim"
		"er cette option.",
		/* [31] */
		"Cette zone contient le texte qui remplac"
		"era le texte original cherché.",
		/* [32] */
		"Cette fenêtre contient les messages prov"
		"enant du programme durant l'analyse de s"
		"yntaxe, la compilation ou l'éxécution de"
		"s sources Basic.",
		/* [33] */
		"Ce fenêtre contient une émulation Minite"
		"l permettant de tester votre application"
		" sans avoir à brancher un modem Dragster"
		" et un Minitel à votre Macintosh.\n",
		/* [34] */
		"Cette zone contient éventuellement une e"
		"xplication au sujet de la routine extern"
		"e sélectionné dans la liste ci-dessus.",
		/* [35] */
		"Ceci est la liste des routines externes "
		"disponibles.\nEn cliquant sur l'un des no"
		"ms figurant dans cette liste, vous obtie"
		"ndrez plus d'informations sur la routine"
		"s ainsi choisie."
	}
};

resource 'STR#' (263, "Menu Items") {
	{	/* array StringArray: 2 elements */
		/* [1] */
		"Compiler",
		/* [2] */
		"Compiler…"
	}
};

resource 'WIND' (256, "Sans Titre (Videotex)", purgeable) {
	{50, 50, 330, 446},
	noGrowDocProc,
	invisible,
	goAway,
	0x0,
	"Sans Titre (Videotex)"
};

resource 'WIND' (1000, "Minitel", purgeable) {
	{54, 26, 322, 488},
	documentProc,
	invisible,
	noGoAway,
	0x0,
	"Minitel"
	/****** Extra bytes follow... ******/
	/* $"0000"                                               /* .. */
};

resource 'WIND' (257, "Sans Titre (Basic)", purgeable) {
	{50, 50, 310, 476},
	zoomDocProc,
	invisible,
	goAway,
	0x0,
	"Sans Titre (Basic)"
};

resource 'CNTL' (256, preload) {
	{-1, 445, 285, 461},
	0,
	visible,
	400,
	0,
	scrollBarProc,
	0,
	"x"
};

resource 'CNTL' (257, preload) {
	{284, -1, 300, 446},
	0,
	invisible,
	300,
	0,
	scrollBarProc,
	0,
	"x"
};

resource 'CNTL' (1000, preload) {
	{8, 336, 29, 452},
	0,
	visible,
	1,
	0,
	pushButProc,
	0,
	"Connexion/Fin"
};

resource 'CNTL' (1001, preload) {
	{40, 336, 61, 452},
	0,
	visible,
	1,
	0,
	pushButProc,
	0,
	"Répétition"
};

resource 'CNTL' (1002, preload) {
	{64, 336, 85, 452},
	0,
	visible,
	1,
	0,
	pushButProc,
	0,
	"Guide"
};

resource 'CNTL' (1003, preload) {
	{88, 336, 109, 452},
	0,
	visible,
	1,
	0,
	pushButProc,
	0,
	"Sommaire"
};

resource 'CNTL' (1004, preload) {
	{120, 336, 141, 452},
	0,
	visible,
	1,
	0,
	pushButProc,
	0,
	"Annulation"
};

resource 'CNTL' (1005, preload) {
	{144, 336, 165, 452},
	0,
	visible,
	1,
	0,
	pushButProc,
	0,
	"Correction"
};

resource 'CNTL' (1006, preload) {
	{176, 336, 197, 452},
	0,
	visible,
	1,
	0,
	pushButProc,
	0,
	"Retour"
};

resource 'CNTL' (1007, preload) {
	{200, 336, 221, 452},
	0,
	visible,
	1,
	0,
	pushButProc,
	0,
	"Suite"
};

resource 'CNTL' (1008, preload) {
	{232, 336, 253, 452},
	0,
	visible,
	1,
	0,
	pushButProc,
	0,
	"Envoi"
};

resource 'DITL' (136) {
	{	/* array DITLarray: 3 elements */
		/* [1] */
		{90, 140, 110, 198},
		Button {
			enabled,
			"OK"
		},
		/* [2] */
		{10, 10, 42, 42},
		Icon {
			disabled,
			0
		},
		/* [3] */
		{10, 60, 78, 206},
		StaticText {
			disabled,
			"Le modem maitre Dragster n'a pas été dét"
			"ecté. L'émulateur a donc été activé."
		}
	}
};

resource 'DITL' (137, "Analyser?") {
	{	/* array DITLarray: 5 elements */
		/* [1] */
		{80, 20, 100, 80},
		Button {
			enabled,
			"Oui"
		},
		/* [2] */
		{110, 20, 130, 80},
		Button {
			enabled,
			"Non"
		},
		/* [3] */
		{110, 231, 130, 291},
		Button {
			enabled,
			"Annuler"
		},
		/* [4] */
		{20, 20, 52, 52},
		Icon {
			disabled,
			2
		},
		/* [5] */
		{17, 67, 73, 304},
		StaticText {
			disabled,
			"\"^0\" a été modifié.\nVoulez-vous analyser"
			" la syntaxe ?"
		}
	}
};

resource 'DITL' (135) {
	{	/* array DITLarray: 2 elements */
		/* [1] */
		{10, 10, 27, 240},
		StaticText {
			disabled,
			"Analyse de \"^0\""
		},
		/* [2] */
		{30, 11, 45, 241},
		UserItem {
			disabled
		}
	}
};

resource 'DITL' (256) {
	{	/* array DITLarray: 3 elements */
		/* [1] */
		{0, 0, 240, 416},
		UserItem {
			enabled
		},
		/* [2] */
		{152, 208, 199, 398},
		StaticText {
			enabled,
			"Version ^0\n^1"
		},
		/* [3] */
		{0, 0, 0, 0},
		HelpItem {
			disabled,
			HMScanhdlg {
				-2995
			}
		}
	}
};

resource 'DITL' (257) {
	{	/* array DITLarray: 3 elements */
		/* [1] */
		{86, 230, 105, 294},
		Button {
			enabled,
			"OK"
		},
		/* [2] */
		{13, 30, 30, 269},
		StaticText {
			disabled,
			"Erreur en cours de traitement:"
		},
		/* [3] */
		{42, 8, 76, 301},
		StaticText {
			disabled,
			"^0"
		}
	}
};

resource 'DITL' (128, "Chercher") {
	{	/* array DITLarray: 10 elements */
		/* [1] */
		{125, 110, 145, 170},
		Button {
			enabled,
			"OK"
		},
		/* [2] */
		{125, 182, 145, 242},
		Button {
			enabled,
			"Annuler"
		},
		/* [3] */
		{42, 17, 58, 244},
		EditText {
			enabled,
			""
		},
		/* [4] */
		{66, 78, 83, 226},
		CheckBox {
			enabled,
			"MAJ / minuscules"
		},
		/* [5] */
		{82, 78, 99, 156},
		CheckBox {
			enabled,
			"Accents"
		},
		/* [6] */
		{98, 78, 115, 240},
		CheckBox {
			enabled,
			"Recherche circulaire"
		},
		/* [7] */
		{13, 47, 28, 126},
		StaticText {
			disabled,
			"Chercher…"
		},
		/* [8] */
		{67, 14, 82, 72},
		StaticText {
			disabled,
			"Options:"
		},
		/* [9] */
		{6, 13, 38, 45},
		Icon {
			enabled,
			128
		},
		/* [10] */
		{0, 0, 0, 0},
		HelpItem {
			disabled,
			HMScanhdlg {
				-2999
			}
		}
	}
};

resource 'DITL' (129, "Remplacer") {
	{	/* array DITLarray: 12 elements */
		/* [1] */
		{167, 116, 187, 176},
		Button {
			enabled,
			"OK"
		},
		/* [2] */
		{167, 187, 187, 247},
		Button {
			enabled,
			"Annuler"
		},
		/* [3] */
		{42, 17, 58, 244},
		EditText {
			enabled,
			""
		},
		/* [4] */
		{107, 78, 124, 226},
		CheckBox {
			enabled,
			"MAJ / minuscules"
		},
		/* [5] */
		{123, 78, 140, 156},
		CheckBox {
			enabled,
			"Accents"
		},
		/* [6] */
		{139, 78, 156, 250},
		CheckBox {
			enabled,
			"Recherche circulaire"
		},
		/* [7] */
		{85, 17, 101, 244},
		EditText {
			enabled,
			""
		},
		/* [8] */
		{13, 47, 28, 126},
		StaticText {
			disabled,
			"Remplacer…"
		},
		/* [9] */
		{108, 14, 123, 73},
		StaticText {
			disabled,
			"Options:"
		},
		/* [10] */
		{6, 13, 38, 45},
		Icon {
			enabled,
			128
		},
		/* [11] */
		{66, 14, 82, 51},
		StaticText {
			disabled,
			"par :"
		},
		/* [12] */
		{0, 0, 0, 0},
		HelpItem {
			disabled,
			HMScanhdlg {
				-2989
			}
		}
	}
};

resource 'DITL' (259) {
	{	/* array DITLarray: 5 elements */
		/* [1] */
		{80, 20, 100, 80},
		Button {
			enabled,
			"Oui"
		},
		/* [2] */
		{110, 20, 130, 80},
		Button {
			enabled,
			"Non"
		},
		/* [3] */
		{110, 231, 130, 291},
		Button {
			enabled,
			"Annuler"
		},
		/* [4] */
		{20, 20, 52, 52},
		Icon {
			disabled,
			2
		},
		/* [5] */
		{17, 67, 73, 304},
		StaticText {
			disabled,
			"\"^0\" a été modifié.\nVoulez-vous enregist"
			"rer les modifications ?"
		}
	}
};

resource 'DITL' (260) {
	{	/* array DITLarray: 8 elements */
		/* [1] */
		{136, 160, 156, 220},
		Button {
			enabled,
			"OK"
		},
		/* [2] */
		{136, 88, 156, 148},
		Button {
			enabled,
			"Annuler"
		},
		/* [3] */
		{56, 32, 72, 184},
		RadioButton {
			enabled,
			"Utiliser l'émulateur"
		},
		/* [4] */
		{72, 32, 88, 240},
		RadioButton {
			enabled,
			"Utiliser le Modem Dragster"
		},
		/* [5] */
		{88, 56, 104, 186},
		RadioButton {
			enabled,
			"Port Modem"
		},
		/* [6] */
		{104, 56, 120, 186},
		RadioButton {
			enabled,
			"Port Imprimante"
		},
		/* [7] */
		{24, 48, 40, 160},
		StaticText {
			disabled,
			"Configuration…"
		},
		/* [8] */
		{8, 8, 40, 40},
		Icon {
			disabled,
			131
		}
	}
};

resource 'DITL' (130) {
	{	/* array DITLarray: 6 elements */
		/* [1] */
		{16, 17, 128, 196},
		UserItem {
			enabled
		},
		/* [2] */
		{132, 17, 199, 329},
		UserItem {
			disabled
		},
		/* [3] */
		{34, 236, 49, 290},
		StaticText {
			disabled,
			"Infos…"
		},
		/* [4] */
		{55, 203, 71, 332},
		StaticText {
			enabled,
			"Taille: ^0"
		},
		/* [5] */
		{99, 205, 102, 243},
		StaticText {
			disabled,
			"Fichier:\n^1"
		},
		/* [6] */
		{17, 202, 49, 234},
		Icon {
			disabled,
			132
		}
	}
};

resource 'DITL' (131) {
	{	/* array DITLarray: 12 elements */
		/* [1] */
		{184, 184, 204, 244},
		Button {
			enabled,
			"OK"
		},
		/* [2] */
		{184, 112, 204, 172},
		Button {
			enabled,
			"Annuler"
		},
		/* [3] */
		{56, 16, 72, 183},
		CheckBox {
			enabled,
			"Listing de compilation"
		},
		/* [4] */
		{72, 16, 88, 163},
		CheckBox {
			enabled,
			"Liste des variables"
		},
		/* [5] */
		{88, 16, 104, 160},
		CheckBox {
			enabled,
			"Map des variables"
		},
		/* [6] */
		{104, 16, 120, 232},
		CheckBox {
			enabled,
			"Afficher les noms des écrans"
		},
		/* [7] */
		{152, 16, 168, 256},
		CheckBox {
			enabled,
			"Inclure N° de ligne dans le code"
		},
		/* [8] */
		{136, 16, 152, 280},
		CheckBox {
			enabled,
			"Inclure N° d'instruction dans le code"
		},
		/* [9] */
		{120, 16, 136, 296},
		CheckBox {
			enabled,
			"Vérifier les dépassements de tableaux"
		},
		/* [10] */
		{24, 56, 40, 256},
		StaticText {
			enabled,
			"Options de compilation…"
		},
		/* [11] */
		{8, 16, 40, 48},
		Icon {
			enabled,
			129
		},
		/* [12] */
		{0, 0, 0, 0},
		HelpItem {
			disabled,
			HMScanhdlg {
				-2991
			}
		}
	}
};

resource 'DITL' (132, "Opt. Analyse") {
	{	/* array DITLarray: 7 elements */
		/* [1] */
		{120, 168, 140, 228},
		Button {
			enabled,
			"OK"
		},
		/* [2] */
		{120, 88, 140, 148},
		Button {
			enabled,
			"Annuler"
		},
		/* [3] */
		{56, 16, 72, 200},
		CheckBox {
			enabled,
			"Liste des variables"
		},
		/* [4] */
		{72, 16, 88, 200},
		CheckBox {
			enabled,
			"Liste des étiquettes"
		},
		/* [5] */
		{88, 16, 104, 232},
		CheckBox {
			enabled,
			"Liste des constantes chaînes"
		},
		/* [6] */
		{24, 56, 40, 216},
		StaticText {
			enabled,
			"Options d'analyse…"
		},
		/* [7] */
		{8, 16, 40, 48},
		Icon {
			enabled,
			130
		}
	}
};

resource 'DITL' (301, purgeable) {
	{	/* array DITLarray: 2 elements */
		/* [1] */
		{5, 47, 58, 237},
		StaticText {
			enabled,
			"La disquette originale vous sera demandé"
			"e au prochain démarrage."
		},
		/* [2] */
		{8, 8, 40, 40},
		Icon {
			enabled,
			0
		}
	}
};

resource 'DITL' (302, purgeable) {
	{	/* array DITLarray: 3 elements */
		/* [1] */
		{73, 147, 93, 207},
		Button {
			enabled,
			"OK"
		},
		/* [2] */
		{5, 44, 67, 231},
		StaticText {
			enabled,
			"La disquette originale est protégée cont"
			"re l'écriture !\nRetirez la protection et"
			" introduisez-la à nouveau."
		},
		/* [3] */
		{8, 9, 40, 41},
		Icon {
			enabled,
			0
		}
	}
};

resource 'DITL' (300, purgeable) {
	{	/* array DITLarray: 2 elements */
		/* [1] */
		{12, 165, 32, 225},
		Button {
			enabled,
			"Quitter"
		},
		/* [2] */
		{6, 10, 38, 154},
		StaticText {
			enabled,
			"Veuillez insérer la disquette originale…"
		}
	}
};

resource 'DITL' (10000) {
	{	/* array DITLarray: 3 elements */
		/* [1] */
		{172, 172, 192, 232},
		Button {
			enabled,
			"OK"
		},
		/* [2] */
		{9, 49, 164, 254},
		StaticText {
			disabled,
			"ATTENTION !!!\nCertaines ressources impor"
			"tantes de type \"^0\" de DragsterEdit ont "
			"été modifiées.\nCeci peut être dû à un vi"
			"rus. Reprennez une copie originale de vo"
			"tre programme DragsterEdit."
		},
		/* [3] */
		{11, 11, 43, 43},
		Icon {
			enabled,
			0
		}
	}
};

resource 'DITL' (133) {
	{	/* array DITLarray: 4 elements */
		/* [1] */
		{112, 141, 132, 201},
		Button {
			enabled,
			"Non"
		},
		/* [2] */
		{112, 66, 132, 126},
		Button {
			enabled,
			"Oui"
		},
		/* [3] */
		{10, 52, 99, 207},
		StaticText {
			disabled,
			"Le port série choisi est déjà occupé par"
			" une autre application. Voulez-vous quan"
			"d même l'utiliser ?"
		},
		/* [4] */
		{13, 13, 45, 45},
		Icon {
			disabled,
			0
		}
	}
};

resource 'DITL' (134) {
	{	/* array DITLarray: 3 elements */
		/* [1] */
		{93, 150, 113, 210},
		Button {
			enabled,
			"OK"
		},
		/* [2] */
		{15, 14, 47, 46},
		Icon {
			disabled,
			2
		},
		/* [3] */
		{14, 64, 82, 226},
		StaticText {
			disabled,
			"Impossible d'ouvrir le port série choisi"
			".\nL'émulateur a donc été activé."
		}
	}
};

resource 'DITL' (1260, "Modem ?") {
	{	/* array DITLarray: 3 elements */
		/* [1] */
		{66, 100, 86, 160},
		Button {
			enabled,
			"OK"
		},
		/* [2] */
		{8, 46, 60, 187},
		StaticText {
			enabled,
			"Il n'y a pas de modem Dragster maitre en"
			" ligne."
		},
		/* [3] */
		{9, 9, 41, 41},
		Icon {
			enabled,
			0
		}
	}
};

resource 'DITL' (138) {
	{	/* array DITLarray: 7 elements */
		/* [1] */
		{74, 80, 91, 245},
		StaticText {
			disabled,
			"Pour stopper, tapez \0x11-:"
		},
		/* [2] */
		{8, 57, 24, 313},
		StaticText {
			disabled,
			""
		},
		/* [3] */
		{30, 129, 46, 240},
		StaticText {
			disabled,
			""
		},
		/* [4] */
		{51, 109, 67, 220},
		StaticText {
			disabled,
			""
		},
		/* [5] */
		{8, 8, 24, 53},
		StaticText {
			disabled,
			"Ecran:"
		},
		/* [6] */
		{51, 8, 67, 106},
		StaticText {
			disabled,
			"Taille du code:"
		},
		/* [7] */
		{30, 8, 46, 127},
		StaticText {
			disabled,
			"Nombre d'écrans:"
		}
	}
};

data 'vers' (1, purgeable) {
	$"0192 2004 0001 0731 2E39 322E 3464 1831"            /* .í ....1.92.4d.1 */
	$"2E39 322E 3464 20A9 4A43 4120 548E 6C8E"            /* .92.4d ©JCA Télé */
	$"6D61 7469 7175 65"                                  /* matique */
};

data 'vers' (2, purgeable) {
	$"0000 8000 0001 0013 4472 6167 7374 6572"            /* ..Ä.....Dragster */
	$"A920 3139 3836 2D31 3939 32"                        /* © 1986-1992 */
};

resource 'SIZE' (0, purgeable) {
	reserved,
	acceptSuspendResumeEvents,
	reserved,
	canBackground,
	notMultiFinderAware,
	backgroundAndForeground,
	dontGetFrontClicks,
	ignoreChildDiedEvents,
	is32BitCompatible,
	isHighLevelEventAware,
	onlyLocalHLEvents,
	notStationeryAware,
	dontUseTextEditServices,
	reserved,
	reserved,
	reserved,
	524288,
	393216
};

resource 'SIZE' (-1, purgeable) {
	reserved,
	acceptSuspendResumeEvents,
	reserved,
	canBackground,
	notMultiFinderAware,
	backgroundAndForeground,
	dontGetFrontClicks,
	ignoreChildDiedEvents,
	is32BitCompatible,
	isHighLevelEventAware,
	onlyLocalHLEvents,
	notStationeryAware,
	dontUseTextEditServices,
	reserved,
	reserved,
	reserved,
	393216,
	393216
};

resource 'ICN#' (129) {
	{	/* array: 2 elements */
		/* [1] */
		$"0555 5540 1000 0000 2492 2040 4010 5400"
		$"D545 0040 0892 2400 8000 0040 0092 2400"
		$"91FF FFC0 0200 0040 94FF FF20 058F FFA0"
		$"8507 FFA0 1507 FFA0 AD07 FFA0 0507 FFA0"
		$"9507 FFA0 058F FFA0 85FF FFA0 15FF FFA0"
		$"85FF FFA0 14FF FF20 8400 0020 07FF FFE0"
		$"8400 0020 0999 9990 9000 0008 2667 E666"
		$"C000 0002 FFFF FFFF 8000 0001 FFFF FFFF",
		/* [2] */
		$"0FFF FFC0 1FFF FFC0 3FFF FFC0 7FFF FFC0"
		$"FFFF FFC0 FFFF FFC0 FFFF FFC0 FFFF FFC0"
		$"FFFF FFC0 FFFF FFC0 FFFF FFE0 FFFF FFE0"
		$"FFFF FFE0 FFFF FFE0 FFFF FFE0 FFFF FFE0"
		$"FFFF FFE0 FFFF FFE0 FFFF FFE0 FFFF FFE0"
		$"FFFF FFE0 FFFF FFE0 FFFF FFE0 FFFF FFE0"
		$"FFFF FFE0 FFFF FFF0 FFFF FFF8 FFFF FFFE"
		$"FFFF FFFE FFFF FFFF FFFF FFFF FFFF FFFF"
	}
};

resource 'ICN#' (128) {
	{	/* array: 2 elements */
		/* [1] */
		$"0000 0000 0000 0000 001F C000 003F A000"
		$"007F 2000 00FE A000 01FC 8000 03FA 8000"
		$"07F2 7F80 0FEA 0040 0FC8 FF20 102B FFA0"
		$"15A3 6DA0 15AA AAA0 058A AAA0 05FB 6DA0"
		$"05FF FFA0 05B6 DDA0 05AA AAA0 05AA AAA0"
		$"05B6 DDA0 04FF FF20 0400 0020 07FF FFE0"
		$"0400 0020 0999 9990 1000 0008 2667 E664"
		$"4000 0002 FFFF FFFF 8000 0001 FFFF FFFF",
		/* [2] */
		$"0000 0000 0000 0000 001F C000 003F E000"
		$"007F E000 00FF E000 01FF C000 03FF 8000"
		$"07FF FF80 0FFF FFC0 0FFF FFE0 1FFF FFE0"
		$"1FFF FFE0 1FFF FFE0 07FF FFE0 07FF FFE0"
		$"07FF FFE0 07FF FFE0 07FF FFE0 07FF FFE0"
		$"07FF FFE0 07FF FFE0 07FF FFE0 07FF FFE0"
		$"07FF FFE0 0FFF FFF0 1FFF FFF8 3FFF FFFC"
		$"7FFF FFFE FFFF FFFF FFFF FFFF FFFF FFFF"
	}
};

resource 'ICN#' (256) {
	{	/* array: 2 elements */
		/* [1] */
		$"0000 000C 0000 0014 0000 002C 0000 0048"
		$"0000 00B0 0000 0110 0000 02E0 0000 0240"
		$"01FF E580 0200 0900 04FF 9220 058F 94A0"
		$"0507 25A0 0507 29A0 0507 33A0 0507 33A0"
		$"0507 27A0 058F 27A0 05FF AFA0 05FF 8FA0"
		$"05FF FFA0 04FF FF20 0400 0020 07FF FFE0"
		$"0400 0020 0999 9990 1000 0008 2667 E664"
		$"4000 0002 FFFF FFFF 8000 0001 FFFF FFFF",
		/* [2] */
		$"0000 000C 0000 001C 0000 003C 0000 0078"
		$"0000 00F0 0000 01F0 0000 03E0 0000 03C0"
		$"01FF FF80 03FF FFC0 07FF FFE0 07FF FFE0"
		$"07FF FFE0 07FF FFE0 07FF FFE0 07FF FFE0"
		$"07FF FFE0 07FF FFE0 07FF FFE0 07FF FFE0"
		$"07FF FFE0 07FF FFE0 07FF FFE0 07FF FFE0"
		$"07FF FFE0 0FFF FFF0 1FFF FFF8 3FFF FFFC"
		$"7FFF FFFE FFFF FFFF FFFF FFFF FFFF FFFF"
	}
};

resource 'ICN#' (257) {
	{	/* array: 2 elements */
		/* [1] */
		$"0000 0000 0000 0000 0000 0000 0000 0000"
		$"0000 0000 0000 0000 0000 0000 0000 0000"
		$"01FF FF80 0200 0040 04FF FF20 0500 01A0"
		$"057E 00A0 0500 00A0 057F F0A0 0500 00A0"
		$"057E 00A0 0500 1CA0 057F D4A0 0500 1CA0"
		$"0580 01A0 04FF FF20 0400 0020 07FF FFE0"
		$"0400 0020 0999 9990 1000 0008 2667 E664"
		$"4000 0002 FFFF FFFF 8000 0001 FFFF FFFF",
		/* [2] */
		$"0000 0000 0000 0000 0000 0000 0000 0000"
		$"0000 0000 0000 0000 0000 0000 0000 0000"
		$"01FF FF80 03FF FFC0 07FF FFE0 07FF FFE0"
		$"07FF FFE0 07FF FFE0 07FF FFE0 07FF FFE0"
		$"07FF FFE0 07FF FFE0 07FF FFE0 07FF FFE0"
		$"07FF FFE0 07FF FFE0 07FF FFE0 07FF FFE0"
		$"07FF FFE0 0FFF FFF0 1FFF FFF8 3FFF FFFC"
		$"7FFF FFFE FFFF FFFF FFFF FFFF FFFF FFFF"
	}
};

resource 'ICN#' (258) {
	{	/* array: 2 elements */
		/* [1] */
		$"0000 0000 0000 0000 0000 0000 0000 0000"
		$"0000 0000 0000 0000 0000 0000 0000 0000"
		$"01FF FF80 0200 0040 04FF FF20 05FF FFA0"
		$"05FE FBA0 05FF F9A0 0532 8BA0 0556 ABA0"
		$"0536 AAA0 057F FFA0 057F FFA0 05FF FFA0"
		$"05FF FFA0 04FF FF20 0400 0020 07FF FFE0"
		$"0400 0020 0999 9990 1000 0008 2667 E664"
		$"4000 0002 FFFF FFFF 8000 0001 FFFF FFFF",
		/* [2] */
		$"0000 0000 0000 0000 0000 0000 0000 0000"
		$"0000 0000 0000 0000 0000 0000 0000 0000"
		$"01FF FF80 03FF FFC0 07FF FFE0 07FF FFE0"
		$"07FF FFE0 07FF FFE0 07FF FFE0 07FF FFE0"
		$"07FF FFE0 07FF FFE0 07FF FFE0 07FF FFE0"
		$"07FF FFE0 07FF FFE0 07FF FFE0 07FF FFE0"
		$"07FF FFE0 0FFF FFF0 1FFF FFF8 3FFF FFFC"
		$"7FFF FFFE FFFF FFFF FFFF FFFF FFFF FFFF"
	}
};

resource 'ICN#' (259) {
	{	/* array: 2 elements */
		/* [1] */
		$"0000 0000 0000 0000 0000 0000 0000 0000"
		$"0000 0000 0000 0000 0000 0000 0000 0000"
		$"01FF FF80 0200 0040 04FF FF20 05FF FFA0"
		$"05FF 07A0 05FE FBA0 05FD F7A0 05FB EFA0"
		$"05F0 1FA0 05EF BFA0 05DF 73A0 05BE F3A0"
		$"05FF FFA0 04FF FF20 0400 0020 07FF FFE0"
		$"0400 0020 0999 9990 1000 0008 2667 E664"
		$"4000 0002 FFFF FFFF 8000 0001 FFFF FFFF",
		/* [2] */
		$"0000 0000 0000 0000 0000 0000 0000 0000"
		$"0000 0000 0000 0000 0000 0000 0000 0000"
		$"01FF FF80 03FF FFC0 07FF FFE0 07FF FFE0"
		$"07FF FFE0 07FF FFE0 07FF FFE0 07FF FFE0"
		$"07FF FFE0 07FF FFE0 07FF FFE0 07FF FFE0"
		$"07FF FFE0 07FF FFE0 07FF FFE0 07FF FFE0"
		$"07FF FFE0 0FFF FFF0 1FFF FFF8 3FFF FFFC"
		$"7FFF FFFE FFFF FFFF FFFF FFFF FFFF FFFF"
	}
};

resource 'ICN#' (260) {
	{	/* array: 2 elements */
		/* [1] */
		$"003F FFFC 0040 0002 0080 0001 0087 FFE1"
		$"008A AAB1 0095 5559 009A AAA9 0095 5559"
		$"01FF FFA9 0200 0059 04FF FF29 0500 00B9"
		$"0500 00A9 0522 38B9 0536 40A9 052A 38B9"
		$"0522 04A9 0522 04B9 0522 78A1 0500 00A1"
		$"0500 00B9 04FF FF21 0400 0021 03FF FFDF"
		$"0400 0021 0999 9991 1000 0009 2667 E665"
		$"4000 0003 FFFF FFFF 8000 0001 FFFF FFFF",
		/* [2] */
		$"003F FFFC 007F FFFE 00FF FFFF 00FF FFFF"
		$"00FF FFFF 00FF FFFF 00FF FFFF 00FF FFFF"
		$"01FF FFFF 03FF FFFF 07FF FFFF 07FF FFFF"
		$"07FF FFFF 07FF FFFF 07FF FFFF 07FF FFFF"
		$"07FF FFFF 07FF FFFF 07FF FFFF 07FF FFFF"
		$"07FF FFFF 07FF FFFF 07FF FFFF 07FF FFFF"
		$"07FF FFFF 0FFF FFFF 1FFF FFFF 3FFF FFFF"
		$"7FFF FFFF FFFF FFFF FFFF FFFF FFFF FFFF"
	}
};

data 'FONT' (1290, purgeable) {
	$"9000 0000 00FE 001B 0000 FFF6 001B 000A"            /* ê............... */
	$"073C 000A 0000 0001 009F 0200 0000 0000"            /* .<.......ü...... */
	$"0000 0000 0000 0000 0000 0000 0000 0000"            /* ................ */
	$"0000 0000 0000 0000 0000 0000 0000 0000"            /* ................ */
	$"0000 0000 0000 0004 0000 0000 0000 0000"            /* ................ */
	$"0000 0000 0000 0000 0000 0000 0000 0000"            /* ................ */
	$"0000 0000 0000 0000 0000 0000 0000 0000"            /* ................ */
	$"0000 0002 0000 0000 0000 0000 0000 0000"            /* ................ */
	$"0000 0000 0000 0000 0000 0000 0000 0000"            /* ................ */
	$"0000 0200 4007 FFFF 0000 0600 0000 0000"            /* ....@........... */
	$"0000 0000 0000 0000 0000 0000 0000 0000"            /* ................ */
	$"0000 0000 0000 0000 0000 0000 0000 4000"            /* ..............@. */
	$"0000 0000 0001 9800 0000 0000 0000 0000"            /* ......ò......... */
	$"0000 0000 0000 0000 0000 0000 0000 0000"            /* ................ */
	$"0000 0000 0000 0000 0000 0000 0000 0000"            /* ................ */
	$"0000 0000 0000 0000 0000 0000 0000 0000"            /* ................ */
	$"0000 0000 0000 0000 0000 0000 0000 0000"            /* ................ */
	$"0000 0000 0000 0000 0000 0000 0000 0000"            /* ................ */
	$"0000 0000 0000 0000 0000 0000 0000 0000"            /* ................ */
	$"0000 0000 0000 0000 0000 0000 0000 0000"            /* ................ */
	$"0000 0000 0000 0000 0000 0000 0000 0000"            /* ................ */
	$"0000 0000 0000 0000 0200 0000 0000 0000"            /* ................ */
	$"0000 0000 0000 0000 0000 0000 0000 0000"            /* ................ */
	$"0000 0000 0000 0040 A0A0 4180 8040 2080"            /* .......@††AÄÄ@ Ä */
	$"4000 0000 0008 4040 E1F0 21F0 61F0 E0E0"            /* @.....@@..!.a... */
	$"0000 1000 80E0 E0E1 E0E1 E1F1 F0E1 10E0"            /* ....Ä........... */
	$"7111 0111 10E1 E0E1 E0E1 F111 1111 1111"            /* q............... */
	$"F071 00E0 4000 0001 0000 1000 6000 8040"            /* .q..@.......`.Ä@ */
	$"2080 C000 0000 0000 0000 8000 0000 0000"            /*  Ä¿.......Ä..... */
	$"0200 4004 03FF 3872 2981 2010 0000 0000"            /* ..@...8r)Å ..... */
	$"2080 40A0 0000 40A0 0000 0040 0000 0080"            /*  Ä@†..@†...@...Ä */
	$"4000 0060 0020 0000 0000 4000 4101 0380"            /* @..`. ....@.A..Ä */
	$"0000 0042 6400 0048 70E1 E000 0000 E000"            /* ...Bd..Hp....... */
	$"0000 0000 0000 0000 0000 0000 F000 0000"            /* ................ */
	$"0000 0000 0000 0000 0000 F199 9833 1E3E"            /* ...........ôò3.> */
	$"03C7 C3C0 CC60 F80F 1F9F 83E1 E3F0 7E3C"            /* .«√¿Ã`...üÉ...~< */
	$"660F CFCC C000 01F0 F198 1E33 1E03 C3C7"            /* f.œÃ¿....ò.3..√« */
	$"E078 7878 1F8F 1F03 F333 F000 7C3C 3C0F"            /* .xxx.è...3..|<<. */
	$"878C C001 F1F8 F03F 3333 07C7 E7E0 F8FC"            /* áå¿....?33.«.... */
	$"F80F 198F 01E3 3330 3C3C C607 878F 80F1"            /* ...è..30<<Δ.áèÄ. */
	$"98F0 1E1E 3303 CC67 C0FC CCF8 0F0F 3183"            /* ò...3.Ãg¿.Ã...1É */
	$"E1E1 E000 0000 0202 0202 0202 0202 0008"            /* ................ */
	$"0808 0808 0948 080B 7008 0808 0808 0808"            /* ....ΔH..p....... */
	$"0808 0808 0040 A0A0 E191 4040 4041 5000"            /* .....@††.ë@@@AP. */
	$"0000 0008 A0C1 1010 6100 8011 1110 0000"            /* ....†¡..a.Ä..... */
	$"2000 4111 1111 1111 1101 0111 1040 2121"            /*  .A..........@!! */
	$"01B1 1111 1111 1110 4111 1111 1110 1041"            /* .±......A......A */
	$"0020 E000 0001 0000 1000 9000 8000 0080"            /* . ........ê.Ä..Ä */
	$"4000 0000 0000 0000 8000 0000 0000 0200"            /* @.......Ä....... */
	$"4004 03FC 448A 2942 1028 25F9 F800 4040"            /* @...Dä)B.(%...@@ */
	$"A001 F9F8 A001 F9F9 F8A1 F9F9 F860 A1F9"            /* †...†....°...`°. */
	$"F891 F851 F9F9 F840 E020 4303 0081 F9F9"            /* .ë.Q...@. C..Å.. */
	$"F842 4822 F818 1080 21F9 F9F9 11F9 F9F9"            /* .BH"...Ä!....... */
	$"F9F9 F9F9 F9F9 F9F9 F9F9 4001 F9F9 F9F9"            /* ..........@..... */
	$"F9F8 41F9 F9F9 F9F8 F199 9833 3F3F 07E7"            /* ..A......ôò3??.. */
	$"E3C0 CCB0 FC1F 9F9F 83F3 F3F0 7E7E 660F"            /* .¿Ã∞..üüÉ...~~f. */
	$"CFCC C1F9 F9F9 F998 3F33 3F07 E7E7 E0FC"            /* œÃ¡....ò?3?..... */
	$"FC78 1F9F 9F83 F333 F07E 7E7E 7E0F CFCC"            /* .x.üüÉ.3.~~~~.œÃ */
	$"C1F9 F9F9 F83F 3333 07E7 E7E0 FCFC FC1F"            /* ¡....?33........ */
	$"998F 03F3 3330 7E7E EE0F CFCF C1F9 98F0"            /* ôè..30~~..œœ¡.ò. */
	$"3F3F 3303 CEE7 E0FC CCFC 1F9F BB83 F3F3"            /* ??3.Œ...Ã..üªÉ.. */
	$"F07E 0000 0202 0202 0202 0202 0008 0808"            /* .~.............. */
	$"0808 0948 180B F808 0808 0808 0808 0808"            /* ..ΔH............ */
	$"0808 0040 A1F1 4021 4080 8020 E040 0000"            /* ...@°.@!@ÄÄ .@.. */
	$"0011 1040 1020 A1E1 0021 1110 8080 41F0"            /* ...@. °..!..ÄÄA. */
	$"2011 7111 1101 1101 0101 1040 2141 0151"            /*  .q........@!A.Q */
	$"9111 1111 1100 4111 1110 A0A0 2040 8021"            /* ë.....A...†† @Ä! */
	$"5000 00D1 E0E0 F0E0 80F0 B0C0 6090 41A1"            /* P..—....Ä.∞¿`êA° */
	$"60E1 E0F1 60E0 E111 1111 1111 F200 4004"            /* `...`.........@. */
	$"03FF 4089 4C3C 3434 4909 08E0 E0E0 E0E1"            /* ..@âL<44IΔ...... */
	$"0908 00C1 0909 0801 0909 0800 0109 0861"            /* Δ..¡ΔΔ..ΔΔ...Δ.a */
	$"0841 0909 0881 5010 4101 0101 0909 09F0"            /* .AΔΔ.ÅP.A...ΔΔΔ. */
	$"A422 5448 20E0 4109 0909 0109 0909 0909"            /* §"TH .AΔΔΔ.ΔΔΔΔΔ */
	$"0909 0909 0909 0909 40F1 0909 0909 0908"            /* ΔΔΔΔΔΔΔΔ@.ΔΔΔΔΔ. */
	$"0109 0909 0908 61D9 983B 3333 0666 6180"            /* .ΔΔΔΔ.a.ò;33.faÄ */
	$"ECB0 CC19 9818 0333 3300 1866 6603 0C07"            /* .∞Ã.ò..33..ff... */
	$"8109 0999 9998 3333 3306 2661 80C4 CC30"            /* ÅΔΔôôò333.&aÄƒÃ0 */
	$"1819 9983 01E3 0042 6666 660C CCCC C109"            /* ..ôÉ...Bfff.ÃÃ¡Δ */
	$"9861 9830 3B33 0666 0180 CCC0 CC19 9986"            /* òaò0;3.f.ÄÃ¿Ã.ôÜ */
	$"0333 B3B0 6266 FE0C CCCC C189 9860 3333"            /* .3≥∞bf..ÃÃ¡âò`33 */
	$"3B01 8FE6 60C0 ECCC 1999 BF83 3333 3042"            /* ;.è.`¿.Ã.ôøÉ330B */
	$"0000 0202 0202 0202 0202 0008 0808 0808"            /* ................ */
	$"0BF0 300B E008 0808 0808 0808 0808 0808"            /* ..0............. */
	$"0040 00A0 E040 8000 8020 4040 0000 0021"            /* .@.†.@Ä.Ä @@...! */
	$"1040 6061 2011 E040 E0F0 0000 8000 1021"            /* .@`a ..@....Ä..! */
	$"5111 E101 11C1 C101 F040 2181 0111 5111"            /* Q....¡¡..@!Å..Q. */
	$"E111 E0E0 4110 A150 4040 4040 4020 4003"            /* ....A.°P@@@@@ @. */
	$"FD31 1101 1111 C110 C840 20A0 4151 9111"            /* .1....¡.»@ †AQë. */
	$"1111 9100 8111 1110 A110 2200 4004 03FF"            /* ..ë.Å...°.".@... */
	$"4040 9224 4C4C 9109 0901 1111 1111 0908"            /* @@í$LLëΔΔ.....Δ. */
	$"C041 0909 08E1 0909 0911 1109 0801 08E1"            /* ¿AΔΔ..ΔΔΔ..Δ.... */
	$"0909 09FC 43F8 4111 3091 0909 0841 1822"            /* ΔΔΔ.C.A.0ëΔΔ.A." */
	$"504B 972E 9D09 0908 8109 0909 0909 0909"            /* PKó.ùΔΔ.ÅΔΔΔΔΔΔΔ */
	$"0909 0909 0909 6149 0909 0909 0909 F109"            /* ΔΔΔΔΔΔaIΔΔΔΔΔΔ.Δ */
	$"0909 0908 61F9 983F 333F 0607 C180 FC60"            /* ΔΔΔ.a.ò?3?..¡Ä.` */
	$"F819 9E1E 03F3 33C0 1866 6603 0F03 0109"            /* ..û...3¿.ff....Δ */
	$"09F9 9998 303F 3303 8661 8070 CC30 1E19"            /* Δ.ôò0?3.ÜaÄpÃ0.. */
	$"9F03 C0C3 C042 7E66 600F 8CCC C109 F061"            /* ü.¿√¿B~f`.åÃ¡Δ.a */
	$"803C 3F3F 07C7 8180 F8F0 FC18 1986 0333"            /* Ä<??.«ÅÄ.....Ü.3 */
	$"F3F0 3866 D60C 0CCF C0E1 9860 3033 3F01"            /* ..8f÷..œ¿.ò`03?. */
	$"8D67 E0F0 FCFC 1819 B583 E333 0042 0000"            /* çg......µÉ.3.B.. */
	$"0202 0202 0202 0202 0008 0808 0808 0940"            /* ..............Δ@ */
	$"600B E008 0808 0808 0808 0808 0808 0040"            /* `..............@ */
	$"01F0 5099 5000 8020 E1F0 00F0 0041 1040"            /* ..PôP.Ä .....A.@ */
	$"8011 F011 1081 1010 0000 41F0 2041 71F1"            /* Ä....Å....A. Aq. */
	$"1101 1101 0131 1040 2141 0111 3111 0151"            /* .....1.@!A..1..Q */
	$"4010 4110 A150 A040 8040 2020 4000 0111"            /* @.A.°P†@Ä@  @... */
	$"1101 11F0 8110 8840 20C0 4151 1111 1111"            /* ....Å.à@ ¿AQ.... */
	$"00E0 8110 A150 4130 4200 4004 03FF 40F3"            /* ..Å.°PA0B.@...@. */
	$"F224 4444 4909 0901 F1F1 F1F1 0908 4041"            /* .$DDIΔΔ.....Δ.@A */
	$"0909 0911 0909 0911 1109 0801 0841 0909"            /* ΔΔΔ.ΔΔΔ..Δ...AΔΔ */
	$"0880 4010 4131 4B31 0909 0843 C272 508A"            /* .Ä@.A1K1ΔΔ.C¬rPä */
	$"F5EB 1509 0908 4109 0909 0909 0909 0909"            /* ...ΔΔ.AΔΔΔΔΔΔΔΔΔ */
	$"0909 0909 4179 0909 0909 0908 0109 0909"            /* ΔΔΔΔAyΔΔΔΔΔ..ΔΔΔ */
	$"0908 61F8 F03F 333E 06E7 8180 FCEC F81F"            /* Δ.a..?3>..ÅÄ.... */
	$"9E1E 03E3 F3C0 1866 6603 0F03 0109 09F1"            /* û....¿.ff....ΔΔ. */
	$"F998 303F 3F01 C7E1 8038 FC30 1E19 9E03"            /* .ò0??.«.Ä8.0..û. */
	$"C0C3 C042 7C7E 6E0F 0CCC C109 E061 803C"            /* ¿√¿B|~n..Ã¡Δ.aÄ< */
	$"3F1E 0787 8180 F0F0 F81B 9986 03F3 F3F0"            /* ?..áÅÄ....ôÜ.... */
	$"1C66 C60C 0CCF 8071 9860 3033 3F01 8C67"            /* .fΔ..œÄqò`03?.åg */
	$"C0F0 FCF8 1819 B183 C3F3 0042 0000 0202"            /* ¿.....±É√..B.... */
	$"0202 0202 0202 0008 0808 0808 0BF0 C00B"            /* ..............¿. */
	$"F808 0808 0808 0808 0808 0808 0000 00A1"            /* ...............° */
	$"5019 2000 4041 5040 8000 0080 A041 0110"            /* P. .@AP@Ä..Ä†A.. */
	$"2111 1081 1010 0080 2000 4001 0111 1111"            /* !..Å...Ä .@..... */
	$"1101 0111 1041 2121 0111 1111 0121 2110"            /* .....A!!.....!!. */
	$"4110 4151 1041 0040 1020 4000 0131 1101"            /* A.AQ.A.@. @..1.. */
	$"1100 80F0 8840 20A0 4151 1111 1111 0010"            /* ..Ä.à@ †AQ...... */
	$"8130 A150 A0D0 8200 4004 03FF 4440 8C3C"            /* Å0°P†–Ç.@...D@å< */
	$"4C4C 2509 0901 0101 0101 0908 4041 0909"            /* LL%ΔΔ.....Δ.@AΔΔ */
	$"0911 0909 0931 3109 0801 0891 0909 0840"            /* Δ.ΔΔΔ11Δ...ëΔΔ.@ */
	$"4021 5050 1051 0909 0800 01AD 5123 870E"            /* @!PP.QΔΔ...≠Q#á. */
	$"1D09 0908 0109 0909 0909 0909 0909 0909"            /* .ΔΔ..ΔΔΔΔΔΔΔΔΔΔΔ */
	$"0909 4141 0909 0909 0908 4109 0909 0908"            /* ΔΔAAΔΔΔΔΔ.AΔΔΔΔ. */
	$"61B8 F037 333C 06E7 C180 DCB0 CC1F 9818"            /* a∏.73<..¡Ä.∞Ã.ò. */
	$"0303 F300 1866 6603 0C07 8109 0981 F998"            /* .....ff...ÅΔΔÅ.ò */
	$"3333 3F04 67E1 808C FC30 1819 9F03 01E3"            /* 33?.g.Äå.0..ü... */
	$"0042 607E 6E0F 8CCC C109 F061 9830 371E"            /* .B`~n.åÃ¡Δ.aò07. */
	$"07C6 0180 F8C0 C01B 9986 03F3 7370 4666"            /* .Δ.Ä.¿¿.ôÜ..spFf */
	$"C60C CCCF 0119 9860 3333 3701 8C66 00C0"            /* Δ.Ãœ..ò`337.åf.¿ */
	$"DCF0 1999 B183 E3F3 3042 0000 0202 0202"            /* ...ô±É..0B...... */
	$"0202 0202 0008 0808 0808 0949 800B F808"            /* ..........ΔIÄ... */
	$"0808 0808 0808 0808 0808 0040 00A0 E000"            /* ...........@.†.. */
	$"D000 2080 4040 8000 8080 4041 F0E0 20E0"            /* –. Ä@@Ä.ÄÄ@A.. . */
	$"E080 E0E0 8080 1000 8040 E111 E0E1 E1F1"            /* .Ä..ÄÄ..Ä@...... */
	$"00F1 10E0 C111 F111 10E1 00D1 10E0 40E0"            /* ....¡......—..@. */
	$"40A1 1041 F070 10E0 4000 00D1 E0E0 F0E0"            /* @°.A.p..@..—.... */
	$"8010 88E0 2090 E151 10E1 E0F1 01E0 60D0"            /* Ä.à. ê.Q......`– */
	$"40A1 1011 F200 4004 03FF 3883 E442 3434"            /* @°....@...8É.B44 */
	$"0109 08E0 E0E0 E0E1 0908 E0E1 0909 08E1"            /* .Δ......Δ...ΔΔ.. */
	$"0909 08D0 D109 0801 08F1 0909 0800 4000"            /* ΔΔ.–—Δ....ΔΔ..@. */
	$"E0F8 20F9 0909 09F0 01A0 5122 850A 1509"            /* .. .ΔΔΔ..†Q"Ö..Δ */
	$"0908 4109 0909 0909 0909 0909 0909 0908"            /* Δ.AΔΔΔΔΔΔΔΔΔΔΔΔ. */
	$"F0F1 0909 0909 0908 0109 0909 0908 F198"            /* ..ΔΔΔΔΔ..ΔΔΔΔ..ò */
	$"6033 3F36 07E6 E3C0 CCFC FC19 9818 0303"            /* `3?6...¿Ã...ò... */
	$"3300 187E 7E03 0FCC C109 0981 99F8 3F33"            /* 3..~~..Ã¡ΔΔÅô.?3 */
	$"3307 E661 80FC CC78 181F 9B83 F333 F042"            /* 3..aÄ.Ãx..õÉ.3.B */
	$"6066 7E0D CFCF C109 B861 F83F 330C 06E7"            /* `f~¬œœ¡Δ∏a.?3... */
	$"E180 DCFC C01F 9F8F 0333 3330 7E7E C60F"            /* .Ä..¿.üè.330~~Δ. */
	$"CFCD 81F9 F8F0 3F3F 3303 CC66 00FC CCD8"            /* œÕÅ...??3.Ãf..Ãÿ */
	$"1F9F B183 7333 F042 0000 FE02 0202 0202"            /* .ü±És3.B........ */
	$"0202 0008 0808 0808 094B 000B F008 0808"            /* ........ΔK...... */
	$"0808 0808 0808 0808 0000 0000 4000 0000"            /* ............@... */
	$"0000 0001 0000 0100 0000 0000 0000 0000"            /* ................ */
	$"0000 0100 0000 0000 0000 0000 0000 0000"            /* ................ */
	$"0000 0000 0000 0000 0000 0000 0000 0000"            /* ................ */
	$"0000 0000 0800 4000 0000 0000 0000 0090"            /* ......@........ê */
	$"0001 2000 0000 0001 0010 0000 0000 0000"            /* .. ............. */
	$"0110 0200 4004 03FF 10FC 9281 0000 01F9"            /* ....@.....íÅ.... */
	$"F840 0000 0001 F9F8 0001 F9F9 F801 F9F9"            /* .@.............. */
	$"F800 01F9 F801 F801 F9F9 F800 4000 4010"            /* ............@.@. */
	$"7811 F9F9 F800 0260 8EC3 870E 1DF9 F9F8"            /* x......`é√á..... */
	$"01F9 F9F9 F9F9 F9F9 F9F9 F9F9 F9F8 0001"            /* ................ */
	$"F9F9 F9F9 F9F8 01F9 F9F9 F9F8 F198 6033"            /* .............ò`3 */
	$"1E33 03E6 63C0 CC6C F819 9818 0303 3300"            /* .3..c¿Ãl..ò...3. */
	$"183C 3C03 0FCC C1F9 F981 98F0 1E33 3303"            /* .<<..Ã¡..Åò..33. */
	$"C661 8078 CC78 180F 1983 F333 F07E 6066"            /* ΔaÄxÃx...É.3.~`f */
	$"3E0C C787 81F9 9860 F03F 330C 0667 E180"            /* >.«áÅ.ò`.?3..g.Ä */
	$"CCFC C00F 8F0F 0333 3330 3C3C C607 878C"            /* Ã.¿.è..330<<Δ.áå */
	$"C0F0 F0F0 1E1E 3303 CC66 00FC CCCC 0F0F"            /* ¿.....3.Ãf..ÃÃ.. */
	$"3183 3331 E07E 0000 0002 0202 0202 0202"            /* 1É31.~.......... */
	$"0008 0808 0808 0A32 000B 6008 0818 0808"            /* .......2..`..... */
	$"0808 0808 0808 0000 0000 0000 0000 0000"            /* ................ */
	$"0000 0000 0200 0000 0000 0000 0000 0000"            /* ................ */
	$"0000 0000 0000 0000 0000 0000 0000 0000"            /* ................ */
	$"0000 0000 0000 0000 0000 0000 0000 0000"            /* ................ */
	$"0000 0400 43FC 0000 0000 0000 0060 0000"            /* ....C........`.. */
	$"C000 0000 0001 0010 0000 0000 0000 00E0"            /* ¿............... */
	$"0200 4004 03FF 2000 0C00 0000 0000 0080"            /* ..@... ........Ä */
	$"0000 0000 0000 0000 0000 0000 0000 0000"            /* ................ */
	$"0000 0000 0000 0000 0000 4000 0000 0000"            /* ..........@..... */
	$"0000 0000 0000 0000 0000 0000 0000 0000"            /* ................ */
	$"0000 0000 0000 0000 0000 0000 0000 0000"            /* ................ */
	$"0000 0000 0000 0000 0000 0000 0000 0000"            /* ................ */
	$"0000 0000 0000 0000 0000 0000 0000 0000"            /* ................ */
	$"0000 0000 0000 0000 0000 0000 0000 0000"            /* ................ */
	$"0000 0000 0000 0000 0000 0000 0000 0000"            /* ................ */
	$"0000 0000 0000 0000 0000 0000 0000 0000"            /* ................ */
	$"0000 0000 0000 0000 0000 0000 0000 0000"            /* ................ */
	$"0000 0000 0000 0000 0000 0000 0000 0000"            /* ................ */
	$"0000 0000 0000 0000 0000 0008 0010 0018"            /* ................ */
	$"0020 0028 0030 0038 0040 0046 004E 0056"            /* . .(.0.8.@.F.N.V */
	$"005E 005E 0066 006E 0076 007E 0086 008E"            /* .^.^.f.n.v.~.Ü.é */
	$"0096 009E 00A6 00AE 00B6 00BE 00C6 00CE"            /* .ñ.û.¶.Æ.∂.æ.Δ.Œ */
	$"00D6 00DE 00E6 00EE 00F6 00FE 0106 010E"            /* .÷.............. */
	$"0116 011E 0126 012E 0136 013E 0146 014E"            /* .....&...6.>.F.N */
	$"0156 015E 0166 016E 0176 017E 0186 018E"            /* .V.^.f.n.v.~.Ü.é */
	$"0196 019E 01A6 01AE 01B6 01BE 01C6 01CE"            /* .ñ.û.¶.Æ.∂.æ.Δ.Œ */
	$"01D6 01DE 01E6 01EE 01F6 01FE 0206 020E"            /* .÷.............. */
	$"0216 021E 0226 022E 0236 023E 0246 024E"            /* .....&...6.>.F.N */
	$"0256 025E 0266 026E 0276 027E 0286 028E"            /* .V.^.f.n.v.~.Ü.é */
	$"0296 029E 02A6 02AE 02B6 02BE 02C6 02CE"            /* .ñ.û.¶.Æ.∂.æ.Δ.Œ */
	$"02D6 02DE 02E6 02EE 02F6 02FE 0306 030E"            /* .÷.............. */
	$"0316 031E 0326 032E 0336 033E 0346 034E"            /* .....&...6.>.F.N */
	$"0356 035E 0366 036E 0376 037E 0386 038E"            /* .V.^.f.n.v.~.Ü.é */
	$"0396 039E 03A6 03AE 03B6 03BE 03C6 03CE"            /* .ñ.û.¶.Æ.∂.æ.Δ.Œ */
	$"03D6 03DE 03E6 03EE 03EE 03F0 03F8 03FE"            /* .÷.............. */
	$"03FE 0403 0408 0410 0418 0420 0426 042E"            /* ........... .&.. */
	$"0436 043E 0446 044E 0456 045E 0466 046E"            /* .6.>.F.N.V.^.f.n */
	$"0476 047E 0486 048E 0496 049E 04A6 04AE"            /* .v.~.Ü.é.ñ.û.¶.Æ */
	$"04B6 04BE 04C6 04CE 04D6 04DE 04E6 04EE"            /* .∂.æ.Δ.Œ.÷...... */
	$"04F6 04FE 0506 050E 0516 051E 0526 052E"            /* .............&.. */
	$"0536 053E 0546 054E 0556 055E 0562 0566"            /* .6.>.F.N.V.^.b.f */
	$"056A 0570 0576 0577 057B 0581 0588 058F"            /* .j.p.v.w.{.Å.à.è */
	$"0596 059E 05A6 05AE 05B6 05BE 05C6 05CE"            /* .ñ.û.¶.Æ.∂.æ.Δ.Œ */
	$"05D6 05DE 05E6 05EE 05F6 05FE 0606 060E"            /* .÷.............. */
	$"0616 061E 0626 062E 0636 063E 0646 064E"            /* .....&...6.>.F.N */
	$"0656 065E 0666 066E 0676 067E 0686 068E"            /* .V.^.f.n.v.~.Ü.é */
	$"06A9 06C4 06DF 06FA 0715 0730 074B 0766"            /* .©.ƒ.......0.K.f */
	$"076E 0776 0791 07AC 07C7 07E2 07FD 0818"            /* .n.v.ë.¨.«...... */
	$"0820 083B 0856 085E 0879 0894 08AF 08CA"            /* . .;.V.^.y.î.Ø.  */
	$"08E5 0900 091B 0936 0951 096C 0987 09A2"            /* ..Δ.Δ.Δ6ΔQΔlΔáΔ¢ */
	$"09BD 09D8 09D8 09E0 0000 0008 0008 0008"            /* ΔΩΔÿΔÿΔ......... */
	$"0008 0008 0008 0008 0008 0006 0008 0008"            /* ................ */
	$"0008 0000 0008 0008 0008 0008 0008 0008"            /* ................ */
	$"0008 0008 0008 0008 0008 0008 0008 0008"            /* ................ */
	$"0008 0008 0008 0008 0008 0008 0008 0008"            /* ................ */
	$"0008 0008 0008 0008 0008 0008 0008 0008"            /* ................ */
	$"0008 0008 0008 0008 0008 0008 0008 0008"            /* ................ */
	$"0008 0008 0008 0008 0008 0008 0008 0008"            /* ................ */
	$"0008 0008 0008 0008 0008 0008 0008 0008"            /* ................ */
	$"0008 0008 0008 0008 0008 0008 0008 0008"            /* ................ */
	$"0008 0008 0008 0008 0008 0008 0008 0008"            /* ................ */
	$"0008 0008 0008 0008 0008 0008 0008 0008"            /* ................ */
	$"0008 0008 0008 0008 0008 0008 0008 0008"            /* ................ */
	$"0008 0008 0008 0008 0008 0008 0008 0008"            /* ................ */
	$"0008 0008 0008 0008 0008 0008 0008 0008"            /* ................ */
	$"0008 0008 0008 0008 0008 0008 0008 0008"            /* ................ */
	$"0008 0008 0008 0008 FFFF 0308 0008 0108"            /* ................ */
	$"FFFF 0108 0108 0008 0008 0008 0108 0008"            /* ................ */
	$"0008 0008 0008 0008 0008 0008 0008 0008"            /* ................ */
	$"0008 0008 0008 0008 0008 0008 0008 0008"            /* ................ */
	$"0008 0008 0008 0008 0008 0008 0008 0008"            /* ................ */
	$"0008 0008 0008 0008 0008 0008 0008 0008"            /* ................ */
	$"0008 0008 0008 0008 0008 0008 0108 0108"            /* ................ */
	$"0208 0108 0108 0308 0108 0008 0008 0008"            /* ................ */
	$"0008 0008 0008 0008 0008 0008 0008 0008"            /* ................ */
	$"0008 0008 0008 0008 0008 0008 0008 0008"            /* ................ */
	$"0008 0008 0008 0008 0008 0008 0008 0008"            /* ................ */
	$"0008 0008 0008 0008 0008 0008 0008 0008"            /* ................ */
	$"001B 001B 001B 001B 001B 001B 001B 001B"            /* ................ */
	$"0008 0008 001B 001B 001B 001B 001B 001B"            /* ................ */
	$"0008 001B 001B 0008 001B 001B 001B 001B"            /* ................ */
	$"001B 001B 001B 001B 001B 001B 001B 001B"            /* ................ */
	$"001B 001B 0001 0008 001B"                           /* .......... */
};

data 'FONT' (1280, "Velizy") {
};

data 'FONT' (1546, purgeable) {
	$"9000 0000 007F 0008 0000 FFF6 0008 000A"            /* ê............... */
	$"0307 000A 0000 0001 0040 7007 7700 7007"            /* .........@p.w.p. */
	$"7700 7007 7700 7007 7700 7007 7700 700F"            /* w.p.w.p.w.p.w.p. */
	$"7700 7007 7700 7007 7700 F00F FF00 F00F"            /* w.p.w.p.w....... */
	$"FF00 F00F FF00 F00F FF00 F00F FF00 F00F"            /* ................ */
	$"FF00 F00F FF00 F00F FF00 7007 7700 7007"            /* ..........p.w.p. */
	$"7700 7007 7700 7007 7700 7007 7700 7007"            /* w.p.w.p.w.p.w.p. */
	$"7700 7007 7700 7007 7700 F00F FF00 F00F"            /* w.p.w.p.w....... */
	$"FF00 F00F FF00 F00F FF00 F00F FF00 F00F"            /* ................ */
	$"FF00 F00F FF00 F00F FF00 7007 7700 7007"            /* ..........p.w.p. */
	$"7700 7007 7700 7007 7700 7007 7700 700F"            /* w.p.w.p.w.p.w.p. */
	$"7700 7007 7700 7007 7700 F00F FF00 F00F"            /* w.p.w.p.w....... */
	$"FF00 F00F FF00 F00F FF00 F00F FF00 F00F"            /* ................ */
	$"FF00 F00F FF00 F00F FF00 7007 7700 7007"            /* ..........p.w.p. */
	$"7700 7007 7700 7007 7700 7007 7700 7007"            /* w.p.w.p.w.p.w.p. */
	$"7700 7007 7700 7007 7700 F00F FF00 F00F"            /* w.p.w.p.w....... */
	$"FF00 F00F FF00 F00F FF00 F00F FF00 F00F"            /* ................ */
	$"FF00 F00F FF00 F00F FF7E 0000 0000 0000"            /* .........~...... */
	$"0000 0000 0000 0007 7700 0000 0000 0000"            /* ........w....... */
	$"0000 0000 0000 0000 0000 F00F FF00 F00F"            /* ................ */
	$"FF00 F00F FF00 F00F FF00 F00F FF00 F00F"            /* ................ */
	$"FF00 F00F FF00 F00F FF00 0000 0000 0000"            /* ................ */
	$"0000 0000 0000 0000 0000 0000 0000 0000"            /* ................ */
	$"0000 0000 0000 0000 0000 F00F FF00 F00F"            /* ................ */
	$"FF00 F00F FF00 F00F FF00 F00F FF00 F00F"            /* ................ */
	$"FF00 F00F FF00 F00F FF42 0000 0070 7070"            /* .........B...ppp */
	$"7007 0707 0777 7700 0000 0000 0070 7070"            /* p....ww......ppp */
	$"7007 0707 0777 7777 7700 0000 00F0 F0F0"            /* p....wwww....... */
	$"F00F 0F0F 0FFF FFFF FF00 0000 00F0 F0F0"            /* ................ */
	$"F00F 0F0F 0FFF FFFF FF00 0000 0070 7070"            /* .............ppp */
	$"7007 0707 0777 7777 7700 0000 0070 7070"            /* p....wwww....ppp */
	$"7007 0707 0777 7777 7700 0000 00F0 F0F0"            /* p....wwww....... */
	$"F00F 0F0F 0FFF FFFF FF00 0000 00F0 F0F0"            /* ................ */
	$"F00F 0F0F 0FFF FFFF FF42 0000 0070 7070"            /* .........B...ppp */
	$"7007 0707 0777 7777 7700 0000 0070 7070"            /* p....wwww....ppp */
	$"7007 0707 0777 7777 7700 0000 00F0 F0F0"            /* p....wwww....... */
	$"F00F 0F0F 0FFF FFFF FF00 0000 00F0 F0F0"            /* ................ */
	$"F00F 0F0F 0FFF FFFF FF00 0000 0070 7070"            /* .............ppp */
	$"7007 0707 0777 7777 7700 0000 0070 7070"            /* p....wwww....ppp */
	$"7007 0707 0777 7777 7700 0000 00F0 F0F0"            /* p....wwww....... */
	$"F00F 0F0F 0FFF FFFF FF00 0000 00F0 F0F0"            /* ................ */
	$"F00F 0F0F 0FFF FFFF FF42 0000 0070 7070"            /* .........B...ppp */
	$"7007 0707 0777 7777 7700 0000 0070 7070"            /* p....wwww....ppp */
	$"7007 0707 0777 7777 7700 0000 00F0 F0F0"            /* p....wwww....... */
	$"F00F 0F0F 0FFF FFFF FF00 0000 00F0 F0F0"            /* ................ */
	$"F00F 0F0F 0FFF FFFF FF00 0000 0070 7070"            /* .............ppp */
	$"7007 0707 0777 7777 7700 0000 0070 7070"            /* p....wwww....ppp */
	$"7007 0707 0777 7777 7700 0000 00F0 F0F0"            /* p....wwww....... */
	$"F00F 0F0F 0FFF FFFF FF00 0000 00F0 F0F0"            /* ................ */
	$"F00F 0F0F 0FFF FFFF FF42 0000 0000 0000"            /* .........B...... */
	$"0000 0000 0000 0000 0000 0000 0000 0000"            /* ................ */
	$"0000 0000 0000 0000 0000 0000 00F0 F0F0"            /* ................ */
	$"F00F 0F0F 0FFF FFFF FF00 0000 00F0 F0F0"            /* ................ */
	$"F00F 0F0F 0FFF FFFF FF00 0000 0000 0000"            /* ................ */
	$"0000 0000 0000 0000 0000 0000 0000 0000"            /* ................ */
	$"0000 0000 0000 0000 0000 0000 00F0 F0F0"            /* ................ */
	$"F00F 0F0F 0FFF FFFF FF00 0000 00F0 F0F0"            /* ................ */
	$"F00F 0F0F 0FFF FFFF FF42 0000 0000 0000"            /* .........B...... */
	$"0000 0000 0000 0000 0070 7070 7070 7070"            /* .........ppppppp */
	$"7070 7070 7070 7070 7000 0000 0000 0000"            /* ppppppppp....... */
	$"0000 0000 0000 0000 00F0 F0F0 F0F0 F0F0"            /* ................ */
	$"F0F0 F0F0 F0F0 F0F0 F007 0707 0707 0707"            /* ................ */
	$"0707 0707 0707 0707 0777 7777 7777 7777"            /* .........wwwwwww */
	$"7777 7777 7777 7777 770F 0F0F 0F0F 0F0F"            /* wwwwwwwww....... */
	$"0F0F 0F0F 0F0F 0F0F 0FFF FFFF FFFF FFFF"            /* ................ */
	$"FFFF FFFF FFFF FFFF FF42 0000 0000 0000"            /* .........B...... */
	$"0000 0000 0000 0000 0070 7070 7070 7070"            /* .........ppppppp */
	$"7070 7070 7070 7070 7000 0000 0000 0000"            /* ppppppppp....... */
	$"0000 0000 0000 0000 00F0 F0F0 F0F0 F0F0"            /* ................ */
	$"F0F0 F0F0 F0F0 F0F0 F007 0707 0707 0707"            /* ................ */
	$"0707 0707 0707 0707 0777 7777 7777 7777"            /* .........wwwwwww */
	$"7777 7777 7777 7777 770F 0F0F 0F0F 0F0F"            /* wwwwwwwww....... */
	$"0F0F 0F0F 0F0F 0F0F 0FFF FFFF FFFF FFFF"            /* ................ */
	$"FFFF FFFF FFFF FFFF FF7E 0000 0000 0000"            /* .........~...... */
	$"0000 0000 0000 0000 0000 0000 0000 0000"            /* ................ */
	$"0000 0000 0000 0000 0000 0000 0000 0000"            /* ................ */
	$"0000 0000 0000 0000 00F0 F0F0 F0F0 F0F0"            /* ................ */
	$"F0F0 F0F0 F0F0 F0F0 F000 0000 0000 0000"            /* ................ */
	$"0000 0000 0000 0000 0000 0000 0000 0000"            /* ................ */
	$"0000 0000 0000 0000 000F 0F0F 0F0F 0F0F"            /* ................ */
	$"0F0F 0F0F 0F0F 0F0F 0FFF FFFF FFFF FFFF"            /* ................ */
	$"FFFF FFFF FFFF FFFF FF00 0000 0000 0008"            /* ................ */
	$"0010 0018 0020 0028 0030 0038 0040 0048"            /* ..... .(.0.8.@.H */
	$"0050 0058 0060 0068 0070 0078 0080 0088"            /* .P.X.`.h.p.x.Ä.à */
	$"0090 0098 00A0 00A8 00B0 00B8 00C0 00C8"            /* .ê.ò.†.®.∞.∏.¿.» */
	$"00D0 00D8 00E0 00E8 00F0 00F8 0100 0108"            /* .–.ÿ............ */
	$"0110 0118 0120 0128 0130 0138 0140 0148"            /* ..... .(.0.8.@.H */
	$"0150 0158 0160 0168 0170 0178 0180 0188"            /* .P.X.`.h.p.x.Ä.à */
	$"0190 0198 01A0 01A8 01B0 01B8 01C0 01C8"            /* .ê.ò.†.®.∞.∏.¿.» */
	$"01D0 01D8 01E0 01E8 01F0 01F8 0200 0208"            /* .–.ÿ............ */
	$"0210 0218 0220 0228 0230 0238 0240 0248"            /* ..... .(.0.8.@.H */
	$"0250 0258 0260 0268 0270 0278 0280 0288"            /* .P.X.`.h.p.x.Ä.à */
	$"0290 0298 02A0 02A8 02B0 02B8 02C0 02C8"            /* .ê.ò.†.®.∞.∏.¿.» */
	$"02D0 02D8 02E0 02E8 02F0 02F8 0300 0308"            /* .–.ÿ............ */
	$"0310 0318 0320 0328 0330 0338 0340 0348"            /* ..... .(.0.8.@.H */
	$"0350 0358 0360 0368 0370 0378 0380 0388"            /* .P.X.`.h.p.x.Ä.à */
	$"0390 0398 03A0 03A8 03B0 03B8 03C0 03C8"            /* .ê.ò.†.®.∞.∏.¿.» */
	$"03D0 03D8 03E0 03E8 03F0 03F8 0400 0000"            /* .–.ÿ............ */
	$"0008 0008 0008 0008 0008 0008 0008 0008"            /* ................ */
	$"0008 0008 0008 0008 0008 0008 0008 0008"            /* ................ */
	$"0008 0008 0008 0008 0008 0008 0008 0008"            /* ................ */
	$"0008 0008 0008 0008 0008 0008 0008 0008"            /* ................ */
	$"0008 0008 0008 0008 0008 0008 0008 0008"            /* ................ */
	$"0008 0008 0008 0008 0008 0008 0008 0008"            /* ................ */
	$"0008 0008 0008 0008 0008 0008 0008 0008"            /* ................ */
	$"0008 0008 0008 0008 0008 0008 0008 0008"            /* ................ */
	$"0008 0008 0008 0008 0008 0008 0008 0008"            /* ................ */
	$"0008 0008 0008 0008 0008 0008 0008 0008"            /* ................ */
	$"0008 0008 0008 0008 0008 0008 0008 0008"            /* ................ */
	$"0008 0008 0008 0008 0008 0008 0008 0008"            /* ................ */
	$"0008 0008 0008 0008 0008 0008 0008 0008"            /* ................ */
	$"0008 0008 0008 0008 0008 0008 0008 0008"            /* ................ */
	$"0008 0008 0008 0008 0008 0008 0008 0008"            /* ................ */
	$"0008 0008 0008 0008 0008 0008 0008 0008"            /* ................ */
	$"0000"                                               /* .. */
};

data 'FONT' (1536, "VidGraph") {
};

resource 'PICT' (257, purgeable) {
	264,
	{231, 253, 249, 324},
	$"1101 0100 0A00 0000 0002 D002 4098 000A"
	$"00E7 00F8 00F9 0148 00E7 00FD 00F9 0144"
	$"00E7 00FD 00F9 0144 0000 0B09 07FF FF01"
	$"FFFF C055 5550 0A06 0400 0101 0060 40FE"
	$"000B 0904 0001 0100 9040 4555 100A 0604"
	$"18C1 0100 C840 FE00 0B01 0405 FE01 0430"
	$"4044 5110 0A01 0402 FE01 0110 40FE 000B"
	$"0904 0201 0102 2040 4451 100B 0904 0201"
	$"0102 2040 0020 000B 0904 0201 0102 4040"
	$"4555 100B 0904 0201 0104 4040 0020 000B"
	$"0904 0201 0106 4040 4401 100B 0904 0201"
	$"0107 8040 0050 000B 0904 0201 0107 8040"
	$"458D 100A 0604 0501 0107 0040 FE00 0B09"
	$"0418 C101 0600 4045 5510 0A06 0400 0101"
	$"0400 40FE 000B 0904 0001 0100 0040 4000"
	$"100B 0907 FFFF 01FF FFC0 2AAA A0FF"
};

resource 'PICT' (258, purgeable) {
	14492,
	{0, 0, 240, 416},
	$"0011 02FF 0C00 FFFF FFFF 0000 0000 0000"
	$"0000 01A0 0000 00F0 0000 0000 0000 00A0"
	$"0082 00A0 008E 001E 0001 000A 0000 0000"
	$"00F0 01A0 0098 81A8 0000 0000 007B 01A7"
	$"0000 0000 0000 0000 0048 0000 0048 0000"
	$"0000 0008 0001 0008 0000 0000 0000 1F10"
	$"0000 0000 0000 2638 8000 00FF 0000 FFFE"
	$"FFFF FFFF 0000 DB6C FFFF FFFF 0000 B6DA"
	$"FFFF FFFF 0000 9248 FFFF FFFF 0000 6DB6"
	$"FFFF FFFF 0000 4924 FFFF FFFF 0000 2492"
	$"FFFF FFFF 0000 0000 FFFF FFFF 0000 FFFE"
	$"FFFF AAAA 0000 DB6C FFFF AAAA 0000 B6DA"
	$"FFFF AAAA 0000 9248 FFFF AAAA 0000 6DB6"
	$"FFFF AAAA 0000 4924 FFFF AAAA 0000 2492"
	$"FFFF AAAA 0000 0000 FFFF AAAA 0000 FFFE"
	$"FFFF 5555 0000 DB6C FFFF 5555 0000 B6DA"
	$"FFFF 5555 0000 9248 FFFF 5555 0000 6DB6"
	$"FFFF 5555 0000 4924 FFFF 5555 0000 2492"
	$"FFFF 5555 0000 0000 FFFF 5555 0000 FFFE"
	$"FFFF 0000 0000 DB6C FFFF 0000 0000 B6DA"
	$"FFFF 0000 0000 9248 FFFF 0000 0000 6DB6"
	$"FFFF 0000 0000 4924 FFFF 0000 0000 2492"
	$"FFFF 0000 0000 0000 FFFF 0000 0000 FFFE"
	$"AAAA FFFF 0000 DB6C AAAA FFFF 0000 B6DA"
	$"AAAA FFFF 0000 9248 AAAA FFFF 0000 6DB6"
	$"AAAA FFFF 0000 4924 AAAA FFFF 0000 2492"
	$"AAAA FFFF 0000 0000 AAAA FFFF 0000 FFFE"
	$"AAAA AAAA 0000 DB6C AAAA AAAA 0000 B6DA"
	$"AAAA AAAA 0000 9248 AAAA AAAA 0000 6DB6"
	$"AAAA AAAA 0000 4924 AAAA AAAA 0000 2492"
	$"AAAA AAAA 0000 0000 AAAA AAAA 0000 FFFE"
	$"AAAA 5555 0000 DB6C AAAA 5555 0000 B6DA"
	$"AAAA 5555 0000 9248 AAAA 5555 0000 6DB6"
	$"AAAA 5555 0000 4924 AAAA 5555 0000 2492"
	$"AAAA 5555 0000 0000 AAAA 5555 0000 FFFE"
	$"AAAA 0000 0000 DB6C AAAA 0000 0000 B6DA"
	$"AAAA 0000 0000 9248 AAAA 0000 0000 6DB6"
	$"AAAA 0000 0000 4924 AAAA 0000 0000 2492"
	$"AAAA 0000 0000 0000 AAAA 0000 0000 FFFE"
	$"5555 FFFF 0000 DB6C 5555 FFFF 0000 B6DA"
	$"5555 FFFF 0000 9248 5555 FFFF 0000 6DB6"
	$"5555 FFFF 0000 4924 5555 FFFF 0000 2492"
	$"5555 FFFF 0000 0000 5555 FFFF 0000 FFFE"
	$"5555 AAAA 0000 DB6C 5555 AAAA 0000 B6DA"
	$"5555 AAAA 0000 9248 5555 AAAA 0000 6DB6"
	$"5555 AAAA 0000 4924 5555 AAAA 0000 2492"
	$"5555 AAAA 0000 0000 5555 AAAA 0000 FFFE"
	$"5555 5555 0000 DB6C 5555 5555 0000 B6DA"
	$"5555 5555 0000 9248 5555 5555 0000 6DB6"
	$"5555 5555 0000 4924 5555 5555 0000 2492"
	$"5555 5555 0000 0000 5555 5555 0000 FFFE"
	$"5555 0000 0000 DB6C 5555 0000 0000 B6DA"
	$"5555 0000 0000 9248 5555 0000 0000 6DB6"
	$"5555 0000 0000 4924 5555 0000 0000 2492"
	$"5555 0000 0000 0000 5555 0000 0000 FFFE"
	$"0000 FFFF 0000 DB6C 0000 FFFF 0000 B6DA"
	$"0000 FFFF 0000 9248 0000 FFFF 0000 6DB6"
	$"0000 FFFF 0000 4924 0000 FFFF 0000 2492"
	$"0000 FFFF 0000 0000 0000 FFFF 0000 FFFE"
	$"0000 AAAA 0000 DB6C 0000 AAAA 0000 B6DA"
	$"0000 AAAA 0000 9248 0000 AAAA 0000 6DB6"
	$"0000 AAAA 0000 4924 0000 AAAA 0000 2492"
	$"0000 AAAA 0000 0000 0000 AAAA 0000 FFFE"
	$"0000 5555 0000 DB6C 0000 5555 0000 B6DA"
	$"0000 5555 0000 9248 0000 5555 0000 6DB6"
	$"0000 5555 0000 4924 0000 5555 0000 2492"
	$"0000 5555 0000 0000 0000 5555 0000 FFFE"
	$"0000 0000 0000 DB6C 0000 0000 0000 B6DA"
	$"0000 0000 0000 9248 0000 0000 0000 6DB6"
	$"0000 0000 0000 4924 0000 0000 0000 2492"
	$"0000 0000 0000 0787 0787 0787 0000 0F0F"
	$"0F0F 0F0F 0000 1696 1696 1696 0000 1E1E"
	$"1E1E 1E1E 0000 25A5 25A5 25A5 0000 2D2D"
	$"2D2D 2D2D 0000 34B4 34B4 34B4 0000 3C3C"
	$"3C3C 3C3C 0000 43C3 43C3 43C3 0000 4B4B"
	$"4B4B 4B4B 0000 52D2 52D2 52D2 0000 5A5A"
	$"5A5A 5A5A 0000 61E1 61E1 61E1 0000 6969"
	$"6969 6969 0000 70F0 70F0 70F0 0000 7878"
	$"7878 7878 0000 7FFF 7FFF 7FFF 0000 8787"
	$"8787 8787 0000 8F0E 8F0E 8F0E 0000 9696"
	$"9696 9696 0000 9E1D 9E1D 9E1D 0000 A5A5"
	$"A5A5 A5A5 0000 AD2C AD2C AD2C 0000 B4B4"
	$"B4B4 B4B4 0000 BC3B BC3B BC3B 0000 C3C3"
	$"C3C3 C3C3 0000 CB4A CB4A CB4A 0000 D2D2"
	$"D2D2 D2D2 0000 DA59 DA59 DA59 0000 E1E1"
	$"E1E1 E1E1 0000 E968 E968 E968 0000 F0F0"
	$"F0F0 F0F0 C000 7FFF 7FFF 7FFF C000 7FFF"
	$"7FFF 7FFF C000 7FFF 7FFF 7FFF C000 7FFF"
	$"7FFF 7FFF C000 7FFF 7FFF 7FFF C000 7FFF"
	$"7FFF 7FFF C000 7FFF 7FFF 7FFF C000 7FFF"
	$"7FFF 7FFF C000 7FFF 7FFF 7FFF C000 7FFF"
	$"7FFF 7FFF C000 7FFF 7FFF 7FFF C000 7FFF"
	$"7FFF 7FFF C000 7FFF 7FFF 7FFF C000 7FFF"
	$"7FFF 7FFF C000 7FFF 7FFF 7FFF C000 7FFF"
	$"7FFF 7FFF C000 7FFF 7FFF 7FFF C000 7FFF"
	$"7FFF 7FFF C000 7FFF 7FFF 7FFF C000 7FFF"
	$"7FFF 7FFF C000 7FFF 7FFF 7FFF C000 7FFF"
	$"7FFF 7FFF C000 7FFF 7FFF 7FFF C000 7FFF"
	$"7FFF 7FFF C000 7FFF 7FFF 7FFF C000 7FFF"
	$"7FFF 7FFF C000 7FFF 7FFF 7FFF C000 7FFF"
	$"7FFF 7FFF C000 7FFF 7FFF 7FFF C000 7FFF"
	$"7FFF 7FFF C000 7FFF 7FFF 7FFF C000 7FFF"
	$"7FFF 7FFF C000 7FFF 7FFF 7FFF C000 7FFF"
	$"7FFF 7FFF C000 7FFF 7FFF 7FFF C000 7FFF"
	$"7FFF 7FFF C000 7FFF 7FFF 7FFF C000 7FFF"
	$"7FFF 7FFF C000 7FFF 7FFF 7FFF C000 7FFF"
	$"7FFF 7FFF C000 7FFF 7FFF 7FFF C000 7FFF"
	$"7FFF 7FFF C000 7FFF 7FFF 7FFF C000 7FFF"
	$"7FFF 7FFF C000 7FFF 7FFF 7FFF C000 7FFF"
	$"7FFF 7FFF C000 7FFF 7FFF 7FFF C000 7FFF"
	$"7FFF 7FFF C000 7FFF 7FFF 7FFF C000 7FFF"
	$"7FFF 7FFF C000 7FFF 7FFF 7FFF C000 7FFF"
	$"7FFF 7FFF C000 7FFF 7FFF 7FFF C000 7FFF"
	$"7FFF 7FFF C000 7FFF 7FFF 7FFF C000 7FFF"
	$"7FFF 7FFF C000 7FFF 7FFF 7FFF C000 7FFF"
	$"7FFF 7FFF C000 7FFF 7FFF 7FFF C000 7FFF"
	$"7FFF 7FFF C000 7FFF 7FFF 7FFF C000 7FFF"
	$"7FFF 7FFF C000 7FFF 7FFF 7FFF C000 7FFF"
	$"7FFF 7FFF C000 7FFF 7FFF 7FFF C000 7FFF"
	$"7FFF 7FFF C000 7FFF 7FFF 7FFF C000 7FFF"
	$"7FFF 7FFF C000 7FFF 7FFF 7FFF C000 7FFF"
	$"7FFF 7FFF C000 7FFF 7FFF 7FFF C000 7FFF"
	$"7FFF 7FFF C000 7FFF 7FFF 7FFF C000 7FFF"
	$"7FFF 7FFF C000 7FFF 7FFF 7FFF C000 7FFF"
	$"7FFF 7FFF C000 7FFF 7FFF 7FFF C000 7FFF"
	$"7FFF 7FFF C000 7FFF 7FFF 7FFF C000 7FFF"
	$"7FFF 7FFF C000 7FFF 7FFF 7FFF C000 7FFF"
	$"7FFF 7FFF C000 7FFF 7FFF 7FFF C000 7FFF"
	$"7FFF 7FFF C000 7FFF 7FFF 7FFF C000 7FFF"
	$"7FFF 7FFF C000 7FFF 7FFF 7FFF C000 7FFF"
	$"7FFF 7FFF C000 7FFF 7FFF 7FFF C000 7FFF"
	$"7FFF 7FFF C000 7FFF 7FFF 7FFF C000 7FFF"
	$"7FFF 7FFF C000 7FFF 7FFF 7FFF C000 7FFF"
	$"7FFF 7FFF C000 7FFF 7FFF 7FFF C000 7FFF"
	$"7FFF 7FFF 0000 0000 0000 0000 0000 0000"
	$"007B 01A0 0000 0000 007B 01A0 0000 000A"
	$"8100 8100 8100 E100 F9FF 000A 8100 8100"
	$"8100 E100 F9FF 000A 8100 8100 8100 E100"
	$"F9FF 000A 8100 8100 8100 E100 F9FF 000C"
	$"EC00 81FF 81FF 8CFF EB00 F9FF 000C ED00"
	$"81FF 81FF 8AFF EC00 F9FF 000C EE00 81FF"
	$"81FF 88FF ED00 F9FF 000C EE00 81FF 81FF"
	$"88FF ED00 F9FF 000C EE00 81FF 81FF 88FF"
	$"ED00 F9FF 000E EE00 88FF F678 81FF 8CFF"
	$"ED00 F9FF 000E EE00 9CFF D978 81FF 95FF"
	$"ED00 F9FF 000E EE00 A2FF D078 81FF 98FF"
	$"ED00 F9FF 000E EE00 93FF DE78 81FF 99FF"
	$"ED00 F9FF 000E EE00 88FF E778 81FF 9BFF"
	$"ED00 F9FF 0010 EE00 81FF FDFF F178 81FF"
	$"9CFF ED00 F9FF 0010 EE00 81FF F8FF F578"
	$"81FF 9DFF ED00 F9FF 0010 EE00 81FF F5FF"
	$"F778 81FF 9EFF ED00 F9FF 0010 EE00 81FF"
	$"F4FF F878 81FF 9EFF ED00 F9FF 0010 EE00"
	$"81FF F2FF F978 81FF 9FFF ED00 F9FF 0010"
	$"EE00 81FF F1FF F978 81FF A0FF ED00 F9FF"
	$"0010 EE00 81FF F0FF FA78 81FF A0FF ED00"
	$"F9FF 0012 EE00 8CFF F278 F3FF FB78 81FF"
	$"A0FF ED00 F9FF 0012 EE00 9DFF DC78 F8FF"
	$"FA78 81FF A1FF ED00 F9FF 0012 EE00 A0FF"
	$"D878 F8FF FB78 81FF A1FF ED00 F9FF 0016"
	$"EE00 94FF E278 F9FF FB78 E3FF F518 81FF"
	$"CCFF ED00 F9FF 0016 EE00 8AFF EB78 F9FF"
	$"FC78 E8FF ED18 81FF CFFF ED00 F9FF 0016"
	$"EE00 82FF F278 FAFF FB78 E6FF EF18 81FF"
	$"D0FF ED00 F9FF 0018 EE00 81FF FDFF F678"
	$"FAFF FC78 DEFF F618 81FF D1FF ED00 F9FF"
	$"001C EE00 81FF FBFF F878 FAFF FC78 F8FF"
	$"001C E5FF F918 81FF D1FF ED00 F9FF 001C"
	$"EE00 81FF F8FF FA78 FAFF FC78 FDFF F81C"
	$"E8FF FA18 81FF D1FF ED00 F9FF 001C EE00"
	$"81FF F8FF FA78 FAFF FC78 F9FF FA1C EAFF"
	$"FA18 81FF D1FF ED00 F9FF 001C EE00 81FF"
	$"F6FF FB78 FBFF FC78 F7FF FA1C ECFF FA18"
	$"81FF D1FF ED00 F9FF 001C EE00 81FF F6FF"
	$"FB78 FBFF FB78 F5FF FC1C EEFF FA18 81FF"
	$"D0FF ED00 F9FF 001C EE00 81FF F5FF FB78"
	$"FBFF FC78 F4FF FC1C EFFF FB18 81FF CFFF"
	$"ED00 F9FF 001C EE00 81FF F5FF FB78 FBFF"
	$"FC78 F2FF FD1C F0FF FC18 81FF CEFF ED00"
	$"F9FF 001C EE00 81FF F5FF FB78 FAFF FD78"
	$"F1FF FD1C F1FF FC18 81FF CEFF ED00 F9FF"
	$"001C EE00 81FF F4FF FC78 FAFF FC78 F1FF"
	$"FC1C F2FF FD18 81FF CEFF ED00 F9FF 001C"
	$"EE00 81FF F4FF FC78 F9FF FD78 EFFF FD1C"
	$"F2FF FD18 81FF CFFF ED00 F9FF 001C EE00"
	$"81FF F3FF FD78 F8FF FE78 EFFF FC1C F2FF"
	$"FE18 81FF CFFF ED00 F9FF 001D EE00 81FF"
	$"F3FF FD78 F7FF 0178 78ED FFFC 1CF4 FFFD"
	$"1881 FFD0 FFED 00F9 FF00 1CEE 0081 FFF2"
	$"FFFE 78F6 FF00 78EC FFFC 1CF4 FFFE 1881"
	$"FFD0 FFED 00F9 FF00 14EE 0081 FFCD FFFC"
	$"1CF4 FFFE 1881 FFD1 FFED 00F9 FF00 14EE"
	$"0081 FFCC FFFC 1CF4 FFFE 1881 FFD2 FFED"
	$"00F9 FF00 17EE 0087 FFF6 27CF FFFC 1CF4"
	$"FF01 1818 81FF D3FF ED00 F9FF 0016 EE00"
	$"8CFF EE27 D2FF FA1C F5FF 0018 81FF D3FF"
	$"ED00 F9FF 0012 EE00 8FFF E927 D3FF F81C"
	$"81FF C9FF ED00 F9FF 0012 EE00 91FF E627"
	$"D2FF F81C 81FF CBFF ED00 F9FF 0012 EE00"
	$"94FF E127 D2FF F61C 81FF CFFF ED00 F9FF"
	$"0012 EE00 96FF DF27 D0FF F21C 81FF D5FF"
	$"ED00 F9FF 0016 EE00 98FF F327 F5FF F627"
	$"CEFF EF1C 81FF DBFF ED00 F9FF 0016 EE00"
	$"9CFF F427 EEFF F727 CCFF EA1C 81FF E3FF"
	$"ED00 F9FF 0016 EE00 9DFF F627 E9FF F927"
	$"C8FF E61C 81FF EBFF ED00 F9FF 0016 EE00"
	$"9FFF F527 E7FF F927 C4FF E41C 81FF F2FF"
	$"ED00 F9FF 0016 EE00 A3FF F427 E3FF FA27"
	$"BFFF DF1C 81FF FCFF ED00 F9FF 0014 EE00"
	$"A5FF F427 E0FF FB27 B7FF DD1C 86FF ED00"
	$"F9FF 0014 EE00 A8FF F227 DFFF FA27 B0FF"
	$"DB1C 90FF ED00 F9FF 0014 EE00 ACFF F127"
	$"DBFF FB27 A8FF D81C 9BFF ED00 F9FF 0014"
	$"EE00 B0FF EF27 D9FF FB27 A1FF D21C A8FF"
	$"ED00 F9FF 0014 EE00 B3FF EF27 D6FF FB27"
	$"94FF D31C B4FF ED00 F9FF 0014 EE00 B8FF"
	$"EC27 D3FF FB27 8AFF D41C BEFF ED00 F9FF"
	$"0016 EE00 BDFF EB27 CFFF FB27 81FF FCFF"
	$"D71C C9FF ED00 F9FF 001A EE00 FCFF F927"
	$"D2FF E627 CCFF FB27 81FF F0FF DC1C D0FF"
	$"ED00 F9FF 001A EE00 F9FF F027 E8FF E027"
	$"C7FF FC27 81FF E2FF E61C D4FF ED00 F9FF"
	$"0016 EE00 F6FF BD27 C3FF FC27 81FF D6FF"
	$"F01C D6FF ED00 F9FF 0016 EE00 F0FF C927"
	$"BDFF FC27 81FF CEFF F71C D7FF ED00 F9FF"
	$"001A EE00 EAFF D427 B8FF FC27 81FF CAFF"
	$"FB1C ECFF FA27 F3FF ED00 F9FF 001A EE00"
	$"E3FF E327 B0FF FC27 81FF C8FF FD1C EFFF"
	$"F427 F6FF ED00 F9FF 0019 EE00 81FF F4FF"
	$"FC27 81FF C6FF 011C 1CF2 FFF0 27F7 FFED"
	$"00F9 FF00 14EE 0081 FFF4 FFFC 2781 FFB7"
	$"FFED 27F8 FFED 00F9 FF00 14EE 0081 FFF4"
	$"FFFC 2781 FFBA FFE9 27F9 FFED 00F9 FF00"
	$"14EE 0081 FFF4 FFFC 2781 FFBC FFE7 27F9"
	$"FFED 00F9 FF00 18EE 0081 FFF4 FFFC 2781"
	$"FFBF FFF4 27F8 FFF9 27FA FFED 00F9 FF00"
	$"18EE 0081 FFF4 FFFC 2781 FFC1 FFF4 27F5"
	$"FFFA 27FA FFED 00F9 FF00 18EE 0081 FFF4"
	$"FFFC 2781 FFC4 FFF3 27F2 FFFB 27FA FFED"
	$"00F9 FF00 18EE 0081 FFF4 FFFC 2781 FFC8"
	$"FFF1 27F0 FFFB 27FA FFED 00F9 FF00 18EE"
	$"0081 FFF4 FFFC 2781 FFCC FFEF 27ED FFFC"
	$"27FA FFED 00F9 FF00 18EE 0081 FFF4 FFFC"
	$"2781 FFD3 FFEA 27EB FFFC 27FA FFED 00F9"
	$"FF00 18EE 0081 FFF5 FFFB 2781 FFE2 FFDE"
	$"27E8 FFFC 27FA FFED 00F9 FF00 1AEE 0081"
	$"FFF5 FFFB 27E0 FFAD 1CDD FFDD 27E3 FFFC"
	$"27FA FFED 00F9 FF00 1AEE 0081 FFF5 FFFC"
	$"27F6 FF83 1CEC FFF3 27D1 FFFC 27FA FFED"
	$"00F9 FF00 16EE 0081 FFF6 FFFB 27E6 FF91"
	$"1CB0 FFFC 27FA FFED 00F9 FF00 16EE 0081"
	$"FFF6 FFFB 27CB FFAB 1CB1 FFFC 27FA FFED"
	$"00F9 FF00 16EE 0081 FFF7 FFFA 27A9 FFCE"
	$"1CB0 FFFC 27FA FFED 00F9 FF00 16EE 0081"
	$"FFF7 FFFB 2788 FFF8 1CA6 FFFC 27FA FFED"
	$"00F9 FF00 16EE 00C8 FFF6 27BC FFFA 2781"
	$"FFA5 FFFB 27FA FFED 00F9 FF00 16EE 00D9"
	$"FFD8 27CA FFFA 2781 FFA4 FFFB 27FA FFED"
	$"00F9 FF00 16EE 00E2 FFCA 27D0 FFF9 2781"
	$"FFA4 FFFC 27F9 FFED 00F9 FF00 16EE 00E7"
	$"FFC1 27D5 FFF8 2781 FFA5 FFFB 27F9 FFED"
	$"00F9 FF00 16EE 00C0 FFE4 27DA FFF8 2781"
	$"FFA4 FFFB 27F9 FFED 00F9 FF00 1AEE 00B5"
	$"FFE9 27E0 FFF9 2781 FFD8 FFE8 27E6 FFFA"
	$"27F9 FFED 00F9 FF00 1AEE 00B1 FFE9 27E6"
	$"FFF7 2781 FFDE FFDE 27EB FFFA 27F8 FFED"
	$"00F9 FF00 1AEE 00AB FFEC 27EA FFF7 2781"
	$"FFD5 FFE3 27EF FFF9 27F8 FFED 00F9 FF00"
	$"1AEE 00A7 FFED 27EF FFF6 2781 FFC9 FFEA"
	$"27F4 FFF9 27F7 FFED 00F9 FF00 1AEE 00A4"
	$"FFEC 27F5 FFF5 2781 FFC2 FFEE 27F8 FFF8"
	$"27F6 FFED 00F9 FF00 16EE 00A1 FFEC 27FD"
	$"FFF1 2781 FFBE FFDF 27F6 FFED 00F9 FF00"
	$"12EE 009E FFDC 2781 FFB9 FFE4 27F5 FFED"
	$"00F9 FF00 12EE 009B FFE1 2781 FFB4 FFE8"
	$"27F4 FFED 00F9 FF00 12EE 0098 FFE5 2781"
	$"FFB1 FFEB 27F3 FFED 00F9 FF00 12EE 0093"
	$"FFED 2781 FFAB FFF0 27F1 FFED 00F9 FF00"
	$"12EE 008E FFF5 2781 FFA5 FFF5 27EF FFED"
	$"00F9 FF00 0CEE 0081 FF81 FF88 FFED 00F9"
	$"FF00 0CEE 0081 FF81 FF88 FFED 00F9 FF00"
	$"0CEE 0081 FF81 FF88 FFED 00F9 FF00 0CEE"
	$"0081 FF81 FF88 FFED 00F9 FF00 0CEE 0081"
	$"FF81 FF88 FFED 00F9 FF00 0CED 0081 FF81"
	$"FF8A FFEC 00F9 FF00 0CEC 0081 FF81 FF8C"
	$"FFEB 00F9 FF00 0A81 0081 0081 00E1 00F9"
	$"FF00 0A81 0081 0081 00E1 00F9 FF00 0A81"
	$"0081 0081 00E1 00F9 FF00 0A81 0081 0081"
	$"00E1 00F9 FF00 0A81 0081 0081 00E1 00F9"
	$"FF00 0A81 0081 0081 00E1 00F9 FF00 0CCF"
	$"00C1 FF81 0081 00D3 00F9 FF00 10CF 0000"
	$"FFC3 0000 FF81 0081 00D3 00F9 FF00 12CF"
	$"0001 FF00 C5FF 0100 FF81 0081 00D3 00F9"
	$"FF00 30CF 0002 FF00 FFFB 0000 FFFA 0000"
	$"FFFB 0000 FFFA 0000 FFFB 0000 FFFB 0000"
	$"FFFA 0000 FFFB 0002 FF00 FF81 0081 00D3"
	$"00F9 FF00 30CF 0002 FF00 FFFB 0000 FFFA"
	$"0000 FFFB 0000 FFFA 0000 FFFB 0000 FFFB"
	$"0000 FFFA 0000 FFFB 0002 FF00 FF81 0081"
	$"00D3 00F9 FF00 30CF 0002 FF00 FFFB 0000"
	$"FFFA 0000 FFFB 0000 FFFA 0000 FFFB 0000"
	$"FFFB 0000 FFFA 0000 FFFB 0002 FF00 FF81"
	$"0081 00D3 00F9 FF00 30CF 0002 FF00 FFFB"
	$"0000 FFFA 0000 FFFB 0000 FFFA 0000 FFFB"
	$"0000 FFFB 0000 FFFA 0000 FFFB 0002 FF00"
	$"FF81 0081 00D3 00F9 FF00 32CF 0002 FF00"
	$"FFFB 0000 FFFA 0000 FFFB 0000 FFFA 0000"
	$"FFFB 0000 FFFB 0000 FFFA 0000 FFFB 0002"
	$"FF00 FF81 009E 00FD FFBA 00F9 FF00 38CF"
	$"0002 FF00 FFFB 0000 FFFA 0000 FFFB 0000"
	$"FFFA 0000 FFFB 0000 FFFB 00FD FFFD 0000"
	$"FFFB 0002 FF00 FF81 00A0 0001 FFFF FD00"
	$"01FF FFBC 00F9 FF00 3ACF 0002 FF00 FFFB"
	$"0000 FFFA 0000 FFFB 0000 FFFA 0000 FFFE"
	$"00FD FFFB 0000 FFFE 2400 FFFE 0000 FFFB"
	$"0002 FF00 FF81 00A1 0000 FFF9 0000 FFBD"
	$"00F9 FF00 0098 81A8 007B 0000 00F0 01A7"
	$"0000 0000 0000 0000 0048 0000 0048 0000"
	$"0000 0008 0001 0008 0000 0000 0000 1F10"
	$"0000 0000 0000 2638 8000 00FF 0000 FFFE"
	$"FFFF FFFF 0000 DB6C FFFF FFFF 0000 B6DA"
	$"FFFF FFFF 0000 9248 FFFF FFFF 0000 6DB6"
	$"FFFF FFFF 0000 4924 FFFF FFFF 0000 2492"
	$"FFFF FFFF 0000 0000 FFFF FFFF 0000 FFFE"
	$"FFFF AAAA 0000 DB6C FFFF AAAA 0000 B6DA"
	$"FFFF AAAA 0000 9248 FFFF AAAA 0000 6DB6"
	$"FFFF AAAA 0000 4924 FFFF AAAA 0000 2492"
	$"FFFF AAAA 0000 0000 FFFF AAAA 0000 FFFE"
	$"FFFF 5555 0000 DB6C FFFF 5555 0000 B6DA"
	$"FFFF 5555 0000 9248 FFFF 5555 0000 6DB6"
	$"FFFF 5555 0000 4924 FFFF 5555 0000 2492"
	$"FFFF 5555 0000 0000 FFFF 5555 0000 FFFE"
	$"FFFF 0000 0000 DB6C FFFF 0000 0000 B6DA"
	$"FFFF 0000 0000 9248 FFFF 0000 0000 6DB6"
	$"FFFF 0000 0000 4924 FFFF 0000 0000 2492"
	$"FFFF 0000 0000 0000 FFFF 0000 0000 FFFE"
	$"AAAA FFFF 0000 DB6C AAAA FFFF 0000 B6DA"
	$"AAAA FFFF 0000 9248 AAAA FFFF 0000 6DB6"
	$"AAAA FFFF 0000 4924 AAAA FFFF 0000 2492"
	$"AAAA FFFF 0000 0000 AAAA FFFF 0000 FFFE"
	$"AAAA AAAA 0000 DB6C AAAA AAAA 0000 B6DA"
	$"AAAA AAAA 0000 9248 AAAA AAAA 0000 6DB6"
	$"AAAA AAAA 0000 4924 AAAA AAAA 0000 2492"
	$"AAAA AAAA 0000 0000 AAAA AAAA 0000 FFFE"
	$"AAAA 5555 0000 DB6C AAAA 5555 0000 B6DA"
	$"AAAA 5555 0000 9248 AAAA 5555 0000 6DB6"
	$"AAAA 5555 0000 4924 AAAA 5555 0000 2492"
	$"AAAA 5555 0000 0000 AAAA 5555 0000 FFFE"
	$"AAAA 0000 0000 DB6C AAAA 0000 0000 B6DA"
	$"AAAA 0000 0000 9248 AAAA 0000 0000 6DB6"
	$"AAAA 0000 0000 4924 AAAA 0000 0000 2492"
	$"AAAA 0000 0000 0000 AAAA 0000 0000 FFFE"
	$"5555 FFFF 0000 DB6C 5555 FFFF 0000 B6DA"
	$"5555 FFFF 0000 9248 5555 FFFF 0000 6DB6"
	$"5555 FFFF 0000 4924 5555 FFFF 0000 2492"
	$"5555 FFFF 0000 0000 5555 FFFF 0000 FFFE"
	$"5555 AAAA 0000 DB6C 5555 AAAA 0000 B6DA"
	$"5555 AAAA 0000 9248 5555 AAAA 0000 6DB6"
	$"5555 AAAA 0000 4924 5555 AAAA 0000 2492"
	$"5555 AAAA 0000 0000 5555 AAAA 0000 FFFE"
	$"5555 5555 0000 DB6C 5555 5555 0000 B6DA"
	$"5555 5555 0000 9248 5555 5555 0000 6DB6"
	$"5555 5555 0000 4924 5555 5555 0000 2492"
	$"5555 5555 0000 0000 5555 5555 0000 FFFE"
	$"5555 0000 0000 DB6C 5555 0000 0000 B6DA"
	$"5555 0000 0000 9248 5555 0000 0000 6DB6"
	$"5555 0000 0000 4924 5555 0000 0000 2492"
	$"5555 0000 0000 0000 5555 0000 0000 FFFE"
	$"0000 FFFF 0000 DB6C 0000 FFFF 0000 B6DA"
	$"0000 FFFF 0000 9248 0000 FFFF 0000 6DB6"
	$"0000 FFFF 0000 4924 0000 FFFF 0000 2492"
	$"0000 FFFF 0000 0000 0000 FFFF 0000 FFFE"
	$"0000 AAAA 0000 DB6C 0000 AAAA 0000 B6DA"
	$"0000 AAAA 0000 9248 0000 AAAA 0000 6DB6"
	$"0000 AAAA 0000 4924 0000 AAAA 0000 2492"
	$"0000 AAAA 0000 0000 0000 AAAA 0000 FFFE"
	$"0000 5555 0000 DB6C 0000 5555 0000 B6DA"
	$"0000 5555 0000 9248 0000 5555 0000 6DB6"
	$"0000 5555 0000 4924 0000 5555 0000 2492"
	$"0000 5555 0000 0000 0000 5555 0000 FFFE"
	$"0000 0000 0000 DB6C 0000 0000 0000 B6DA"
	$"0000 0000 0000 9248 0000 0000 0000 6DB6"
	$"0000 0000 0000 4924 0000 0000 0000 2492"
	$"0000 0000 0000 0787 0787 0787 0000 0F0F"
	$"0F0F 0F0F 0000 1696 1696 1696 0000 1E1E"
	$"1E1E 1E1E 0000 25A5 25A5 25A5 0000 2D2D"
	$"2D2D 2D2D 0000 34B4 34B4 34B4 0000 3C3C"
	$"3C3C 3C3C 0000 43C3 43C3 43C3 0000 4B4B"
	$"4B4B 4B4B 0000 52D2 52D2 52D2 0000 5A5A"
	$"5A5A 5A5A 0000 61E1 61E1 61E1 0000 6969"
	$"6969 6969 0000 70F0 70F0 70F0 0000 7878"
	$"7878 7878 0000 7FFF 7FFF 7FFF 0000 8787"
	$"8787 8787 0000 8F0E 8F0E 8F0E 0000 9696"
	$"9696 9696 0000 9E1D 9E1D 9E1D 0000 A5A5"
	$"A5A5 A5A5 0000 AD2C AD2C AD2C 0000 B4B4"
	$"B4B4 B4B4 0000 BC3B BC3B BC3B 0000 C3C3"
	$"C3C3 C3C3 0000 CB4A CB4A CB4A 0000 D2D2"
	$"D2D2 D2D2 0000 DA59 DA59 DA59 0000 E1E1"
	$"E1E1 E1E1 0000 E968 E968 E968 0000 F0F0"
	$"F0F0 F0F0 C000 7FFF 7FFF 7FFF C000 7FFF"
	$"7FFF 7FFF C000 7FFF 7FFF 7FFF C000 7FFF"
	$"7FFF 7FFF C000 7FFF 7FFF 7FFF C000 7FFF"
	$"7FFF 7FFF C000 7FFF 7FFF 7FFF C000 7FFF"
	$"7FFF 7FFF C000 7FFF 7FFF 7FFF C000 7FFF"
	$"7FFF 7FFF C000 7FFF 7FFF 7FFF C000 7FFF"
	$"7FFF 7FFF C000 7FFF 7FFF 7FFF C000 7FFF"
	$"7FFF 7FFF C000 7FFF 7FFF 7FFF C000 7FFF"
	$"7FFF 7FFF C000 7FFF 7FFF 7FFF C000 7FFF"
	$"7FFF 7FFF C000 7FFF 7FFF 7FFF C000 7FFF"
	$"7FFF 7FFF C000 7FFF 7FFF 7FFF C000 7FFF"
	$"7FFF 7FFF C000 7FFF 7FFF 7FFF C000 7FFF"
	$"7FFF 7FFF C000 7FFF 7FFF 7FFF C000 7FFF"
	$"7FFF 7FFF C000 7FFF 7FFF 7FFF C000 7FFF"
	$"7FFF 7FFF C000 7FFF 7FFF 7FFF C000 7FFF"
	$"7FFF 7FFF C000 7FFF 7FFF 7FFF C000 7FFF"
	$"7FFF 7FFF C000 7FFF 7FFF 7FFF C000 7FFF"
	$"7FFF 7FFF C000 7FFF 7FFF 7FFF C000 7FFF"
	$"7FFF 7FFF C000 7FFF 7FFF 7FFF C000 7FFF"
	$"7FFF 7FFF C000 7FFF 7FFF 7FFF C000 7FFF"
	$"7FFF 7FFF C000 7FFF 7FFF 7FFF C000 7FFF"
	$"7FFF 7FFF C000 7FFF 7FFF 7FFF C000 7FFF"
	$"7FFF 7FFF C000 7FFF 7FFF 7FFF C000 7FFF"
	$"7FFF 7FFF C000 7FFF 7FFF 7FFF C000 7FFF"
	$"7FFF 7FFF C000 7FFF 7FFF 7FFF C000 7FFF"
	$"7FFF 7FFF C000 7FFF 7FFF 7FFF C000 7FFF"
	$"7FFF 7FFF C000 7FFF 7FFF 7FFF C000 7FFF"
	$"7FFF 7FFF C000 7FFF 7FFF 7FFF C000 7FFF"
	$"7FFF 7FFF C000 7FFF 7FFF 7FFF C000 7FFF"
	$"7FFF 7FFF C000 7FFF 7FFF 7FFF C000 7FFF"
	$"7FFF 7FFF C000 7FFF 7FFF 7FFF C000 7FFF"
	$"7FFF 7FFF C000 7FFF 7FFF 7FFF C000 7FFF"
	$"7FFF 7FFF C000 7FFF 7FFF 7FFF C000 7FFF"
	$"7FFF 7FFF C000 7FFF 7FFF 7FFF C000 7FFF"
	$"7FFF 7FFF C000 7FFF 7FFF 7FFF C000 7FFF"
	$"7FFF 7FFF C000 7FFF 7FFF 7FFF C000 7FFF"
	$"7FFF 7FFF C000 7FFF 7FFF 7FFF C000 7FFF"
	$"7FFF 7FFF C000 7FFF 7FFF 7FFF C000 7FFF"
	$"7FFF 7FFF C000 7FFF 7FFF 7FFF C000 7FFF"
	$"7FFF 7FFF C000 7FFF 7FFF 7FFF C000 7FFF"
	$"7FFF 7FFF C000 7FFF 7FFF 7FFF C000 7FFF"
	$"7FFF 7FFF C000 7FFF 7FFF 7FFF C000 7FFF"
	$"7FFF 7FFF C000 7FFF 7FFF 7FFF C000 7FFF"
	$"7FFF 7FFF C000 7FFF 7FFF 7FFF C000 7FFF"
	$"7FFF 7FFF C000 7FFF 7FFF 7FFF C000 7FFF"
	$"7FFF 7FFF C000 7FFF 7FFF 7FFF C000 7FFF"
	$"7FFF 7FFF C000 7FFF 7FFF 7FFF C000 7FFF"
	$"7FFF 7FFF C000 7FFF 7FFF 7FFF C000 7FFF"
	$"7FFF 7FFF 0000 0000 0000 0000 007B 0000"
	$"00F0 01A0 007B 0000 00F0 01A0 0000 0025"
	$"CF00 01FF 00DE FF01 2424 FAFF FD24 F5FF"
	$"0100 FF81 00A1 0002 FF00 00FE FFFE 0000"
	$"FFBD 00F9 FF00 43CF 0002 FF00 FFFB 0000"
	$"FFFA 0000 FFFB 0000 FFFA 0003 FF00 00FF"
	$"FD24 FEFF 0200 00FF FD24 FEFF 0100 FFFB"
	$"0002 FF00 FF81 00A2 0000 FFFE 0003 FF00"
	$"00FF FE00 00FF BE00 F9FF 003F CF00 02FF"
	$"00FF FB00 00FF FA00 00FF FB00 00FF FA00"
	$"03FF 0000 FFFD 24FD FF01 00FF FD24 FCFF"
	$"FB00 02FF 00FF 8100 A200 00FF FE00 03FF"
	$"0000 FFFE 0000 FFBE 00F9 FF00 46CF 0002"
	$"FF00 FFFB 0000 FFFA 0000 FFFB 0000 FFFA"
	$"0003 FF00 00FF FE24 FAFF FD24 00FF FE24"
	$"01FF FFFC 0002 FF00 FF81 00D1 0000 FFF6"
	$"0000 FFDF 0000 FFFE 00FE FFFD 0000 FFBE"
	$"00F9 FF00 5BCF 0002 FF00 FFFB 0000 FFFA"
	$"0000 FFFB 0000 FFFA 0005 FF00 00FF FF24"
	$"FAFF F724 01FF FFFD 0002 FF00 FFA3 00F8"
	$"FFFA 00F8 FFF2 0000 FFF1 00FA FFFA 00FB"
	$"FFFC 00F4 FFFE 00F6 FFFE 00F8 FFF9 0000"
	$"FFFE 0003 FF00 00FF FE00 00FF BE00 F9FF"
	$"0080 CF00 02FF 00FF FB00 00FF FA00 00FF"
	$"FB00 00FF FA00 00FF FE00 F9FF F624 FEFF"
	$"FE00 02FF 00FF A100 01FF FFFC 0001 FFFF"
	$"FA00 01FF FFFC 0001 FFFF F400 00FF F300"
	$"01FF FFFC 00FE FFFC 0000 FFFD 00FE FFFD"
	$"0001 FFFF FE00 01FF FFFD 0001 FFFF FC00"
	$"01FF FFFC 00FE FFFD 0001 FFFF FC00 01FF"
	$"FFFA 0009 FF00 00FF 0000 FF00 00FF BD00"
	$"F9FF 0067 CF00 01FF 00D9 FFF5 24F9 FF01"
	$"00FF A100 01FF FFFB 0001 FFFF FB00 01FF"
	$"FFFB 0001 FFFF F500 01FF FFF5 0001 FFFF"
	$"FA00 01FF FFFD 0000 FFFB 0001 FFFF FD00"
	$"00FF FD00 01FF FFFC 0000 FFFC 0001 FFFF"
	$"FB00 01FF FFFD 0001 FFFF FB00 01FF FFFB"
	$"0000 FFF9 0000 FFBD 00F9 FF00 79CF 0002"
	$"FF00 FFFB 0000 FFFA 0000 FFFB 0000 FFFA"
	$"0002 FF00 00FE FF03 00FF 00FF F724 FBFF"
	$"FE00 02FF 00FF A100 01FF FFFA 0001 FFFF"
	$"FC00 01FF FFFB 0001 FFFF F600 FEFF F600"
	$"01FF FFF8 0000 FFFE 0001 FFFF FA00 00FF"
	$"F800 01FF FFF6 0001 FFFF FA00 00FF FD00"
	$"01FF FFFB 0001 FFFF FA00 01FF FFFD 0001"
	$"FFFF BC00 F9FF 006A CF00 02FF 00FF FB00"
	$"00FF FA00 00FF FB00 00FF FA00 04FF 00FF"
	$"FF24 FEFF 0100 FFF9 24FA FFFD 0002 FF00"
	$"FFA1 0001 FFFF FA00 01FF FFFC 0001 FFFF"
	$"FB00 01FF FFF6 0003 FF00 FFFF F700 01FF"
	$"FFF4 0001 FFFF F000 01FF FFF6 0001 FFFF"
	$"F500 01FF FFFB 0001 FFFF F800 FDFF BA00"
	$"F9FF 0062 CF00 02FF 00FF FB00 00FF FA00"
	$"00FF FB00 00FF FA00 01FF FFFD 24FD FFFA"
	$"24FA FFFC 0002 FF00 FFA1 0001 FFFF F900"
	$"01FF FFFD 0001 FFFF FB00 01FF FFF6 0003"
	$"FF00 FFFF F800 01FF FFF3 0001 FFFF F000"
	$"01FF FFF6 0001 FFFF F500 01FF FFFB 0001"
	$"FFFF AD00 F9FF 0066 CF00 02FF 00FF FB00"
	$"00FF FA00 00FF FB00 00FF FA00 01FF FFFD"
	$"24FA FFFD 24FB FFFB 0002 FF00 FFA1 0001"
	$"FFFF F900 01FF FFFD 0001 FFFF FB00 01FF"
	$"FFF7 0000 FFFE 0000 FFF8 0001 FFFF F200"
	$"FEFF F200 01FF FFF6 0001 FFFF FC00 00FF"
	$"FB00 01FF FFFB 0001 FFFF AD00 F9FF 006E"
	$"CF00 02FF 00FF FB00 00FF FA00 00FF FB00"
	$"00FF FE00 FDFF FB24 FDFF 0200 00FF FD24"
	$"FDFF 0100 FFFB 0002 FF00 FFA1 0001 FFFF"
	$"F900 01FF FFFD 0001 FFFF FC00 01FF FFF6"
	$"0000 FFFE 0001 FFFF F900 01FF FFF2 00FC"
	$"FFF4 0001 FFFF F600 01FF FFFD 0001 FFFF"
	$"FB00 01FF FFFC 0001 FFFF AC00 F9FF 0058"
	$"CF00 02FF 00FF FB00 00FF FA00 00FF FB00"
	$"FDFF F724 FDFF 0200 00FF FD24 FDFF 0100"
	$"FFFB 0002 FF00 FFA1 0001 FFFF F900 01FF"
	$"FFFD 00F9 FFF5 0000 FFFE 0001 FFFF F900"
	$"01FF FFF0 00FC FFF6 0001 FFFF F600 F9FF"
	$"FB00 F9FF AB00 F9FF 006D CF00 02FF 00FF"
	$"FB00 00FF FA00 FEFF FD00 00FF F424 FDFF"
	$"0200 00FF FD24 FEFF 0200 00FF FB00 02FF"
	$"00FF A100 01FF FFF9 0001 FFFF FD00 05FF"
	$"FF00 00FF FFF4 0000 FFFC 0001 FFFF FA00"
	$"01FF FFFA 00FC FFFA 00FD FFF7 0001 FFFF"
	$"F600 01FF FFFD 0001 FFFF FB00 05FF FF00"
	$"00FF FFA9 00F9 FF00 5ECF 0001 FF00 F1FF"
	$"0124 24FC FFF4 24FA FFFD 24F4 FF01 00FF"
	$"A100 01FF FFF9 0001 FFFF FD00 01FF FFFE"
	$"0001 FFFF F500 00FF FC00 01FF FFFA 0001"
	$"FFFF F800 01FF FFF7 00FE FFF8 0001 FFFF"
	$"F600 01FF FFFC 0000 FFFB 0001 FFFF FE00"
	$"01FF FFAA 00F9 FF00 6ACF 0005 FF00 FF00"
	$"00FF FD24 FDFF 0200 00FF FD24 FDFF F424"
	$"FDFF 0200 FFFF FD24 FDFF 0324 24FF FFFD"
	$"0002 FF00 FFA1 0001 FFFF F900 01FF FFFD"
	$"0001 FFFF FE00 01FF FFF5 00F9 FFFA 0001"
	$"FFFF F800 01FF FFF6 00FE FFF9 0001 FFFF"
	$"F600 01FF FFF5 0001 FFFF FE00 01FF FFAA"
	$"00F9 FF00 6ECF 0004 FF00 FF00 FFFA 24FC"
	$"FFFD 24FD FFFA 2401 FFFF FD24 FDFF 0100"
	$"FFFC 24FE FFFD 24FE FF04 0000 FF00 FFA1"
	$"0001 FFFF F900 01FF FFFD 0001 FFFF FD00"
	$"01FF FFF7 0000 FFFA 0001 FFFF FB00 01FF"
	$"FFF8 0001 FFFF F500 01FF FFF9 0001 FFFF"
	$"F600 01FF FFF5 0001 FFFF FD00 01FF FFAB"
	$"00F9 FF00 70CF 0003 FF00 FFFF F824 FDFF"
	$"FD24 FDFF FB24 FEFF FD24 FEFF 0100 FFFB"
	$"2401 FFFF FC24 FDFF 0300 FF00 FFA1 0001"
	$"FFFF FA00 01FF FFFC 0001 FFFF FC00 01FF"
	$"FFF8 0000 FFFA 0001 FFFF FA00 01FF FFF9"
	$"0001 FFFF F500 01FF FFF9 0001 FFFF F600"
	$"01FF FFFA 0000 FFFD 0001 FFFF FC00 01FF"
	$"FFAC 00F9 FF00 6FCF 0003 FF00 FFFF F824"
	$"FDFF FD24 FDFF FC24 FDFF FD24 FEFF 0100"
	$"FFF4 24FD FF03 00FF 00FF A100 01FF FFFA"
	$"0001 FFFF FC00 01FF FFFC 0001 FFFF F800"
	$"00FF FA00 01FF FFFA 0001 FFFF F900 01FF"
	$"FFFE 0000 FFF9 0001 FFFF F900 01FF FFF6"
	$"0001 FFFF FA00 00FF FD00 01FF FFFC 0001"
	$"FFFF AC00 F9FF 006D CF00 03FF 00FF FFF7"
	$"24FE FFFD 24FD FFFC 24FD FFFD 24FC FFF5"
	$"24FC FF03 00FF 00FF A100 01FF FFFB 0001"
	$"FFFF FB00 01FF FFFB 0001 FFFF FA00 00FF"
	$"F800 01FF FFFA 0001 FFFF FA00 01FF FFFE"
	$"0001 FFFF FA00 00FF F800 01FF FFF6 0001"
	$"FFFF FB00 01FF FFFD 0001 FFFF FB00 01FF"
	$"FFAD 00F9 FF00 6BCF 0001 FF00 FEFF 0324"
	$"24FF FFFC 24FE FFFD 24FD FFFC 24FD FFFD"
	$"24FE FFF4 24F9 FF01 00FF A100 FEFF FD00"
	$"01FF FFFA 0001 FFFF FB00 FEFF FB00 00FF"
	$"F800 01FF FFF9 0001 FFFF FC00 01FF FFFD"
	$"00FE FFFC 0000 FFF7 0001 FFFF F600 01FF"
	$"FFFC 00FE FFFD 0001 FFFF FB00 FEFF AE00"
	$"F9FF 0050 CF00 04FF 00FF 0000 FDFF FC24"
	$"FEFF FD24 FDFF FC24 FDFF EE24 FCFF FE00"
	$"02FF 00FF A300 F8FF FA00 FBFF FC00 FEFF"
	$"FE00 FCFF FC00 FBFF F900 FCFF FA00 FAFF"
	$"F800 FBFF FA00 F6FF FE00 FBFF FC00 FEFF"
	$"AF00 F9FF 002B CF00 02FF 00FF FC00 00FF"
	$"FD24 FDFF FD24 03FF FF00 FFFC 24FD FFF3"
	$"24F8 FFFD 0002 FF00 FF81 0081 00D3 00F9"
	$"FF00 2ACF 0002 FF00 FFFC 0000 FFFD 24FD"
	$"FFFD 2402 FFFF 00FB 24FD FFF6 24F7 FFFB"
	$"0002 FF00 FF81 0081 00D3 00F9 FF00 2DCF"
	$"0002 FF00 FFFD 0000 FFFC 24FE FFFC 2402"
	$"FFFF 00FB 24FD FFF8 24F7 FF01 00FF FB00"
	$"02FF 00FF 8100 8100 D300 F9FF 0031 CF00"
	$"02FF 00FF FE00 01FF FFFC 24FE FFFC 24FE"
	$"FFFC 24FD FF00 00FE FFFE 24F9 FFFB 0000"
	$"FFFB 0002 FF00 FF81 0081 00D3 00F9 FF00"
	$"2ECF 0002 FF00 FFFE 0000 FFFB 2401 FFFF"
	$"FB24 01FF FFFC 24FC FFFD 00F7 FFFA 0000"
	$"FFFB 0002 FF00 FF81 0081 00D3 00F9 FF00"
	$"1ACF 0001 FF00 FCFF FB24 00FF F324 DFFF"
	$"0100 FF81 0081 00D3 00F9 FF00 28CF 0002"
	$"FF00 FFFE 0000 FFED 24FB FFFB 0000 FFFB"
	$"0000 FFFA 0000 FFFB 0002 FF00 FF81 0081"
	$"00D3 00F9 FF00 2DCF 0002 FF00 FFFE 0000"
	$"FFF6 2401 FFFF FB24 FAFF FB00 00FF FB00"
	$"00FF FA00 00FF FB00 02FF 00FF 8100 8100"
	$"D300 F9FF 002B CF00 02FF 00FF FE00 00FF"
	$"F724 F3FF 0100 FFFB 0000 FFFB 0000 FFFA"
	$"0000 FFFB 0002 FF00 FF81 0081 00D3 00F9"
	$"FF00 2CCF 0002 FF00 FFFD 0000 FFF8 24F4"
	$"FF02 0000 FFFB 0000 FFFB 0000 FFFA 0000"
	$"FFFB 0002 FF00 FF81 0081 00D3 00F9 FF00"
	$"31CF 0002 FF00 FFFD 0000 FFF9 24FC FF01"
	$"0000 FCFF FD00 00FF FB00 00FF FB00 00FF"
	$"FA00 00FF FB00 02FF 00FF 8100 8100 D300"
	$"F9FF 0031 CF00 02FF 00FF FC00 03FF FF24"
	$"24F8 FFFE 0000 FFFA 0000 FFFB 0000 FFFB"
	$"0000 FFFA 0000 FFFB 0002 FF00 FF81 0081"
	$"00D3 00F9 FF00 12CF 0001 FF00 C5FF 0100"
	$"FF81 0081 00D3 00F9 FF00 30CF 0002 FF00"
	$"FFFB 0002 FF00 00FB FFFB 0000 FFFA 0000"
	$"FFFB 0000 FFFB 0000 FFFA 0000 FFFB 0002"
	$"FF00 FF81 0081 00D3 00F9 FF00 30CF 0002"
	$"FF00 FFFB 0000 FFFA 0000 FFFB 0000 FFFA"
	$"0000 FFFB 0000 FFFB 0000 FFFA 0000 FFFB"
	$"0002 FF00 FF81 0081 00D3 00F9 FF00 30CF"
	$"0002 FF00 FFFB 0000 FFFA 0000 FFFB 0000"
	$"FFFA 0000 FFFB 0000 FFFB 0000 FFFA 0000"
	$"FFFB 0002 FF00 FF81 0081 00D3 00F9 FF00"
	$"1CCF 0002 FF00 FFFB 0000 FFD5 0000 FFFB"
	$"0002 FF00 FF81 0081 00D3 00F9 FF00 3ACF"
	$"0002 FF00 FFFB 0000 FFFD 00FD FF01 0000"
	$"FDFF 0000 FDFF 0100 00FD FF00 00FD FF00"
	$"00FC FF00 00FE FFFD 0000 FFFB 0002 FF00"
	$"FF81 0081 00D3 00F9 FF00 41CF 0002 FF00"
	$"FFFB 0000 FFFD 000B FF00 00FF 0000 FF00"
	$"00FF 00FF FE00 07FF 00FF 0000 FF00 FFFD"
	$"0000 FFFE 0003 FF00 00FF FC00 00FF FB00"
	$"02FF 00FF 8100 8100 D300 F9FF 0034 CF00"
	$"01FF 00F6 FF01 00FF FC00 05FF 0000 FF00"
	$"FFFE 0002 FF00 FFFD 00FD FF00 00FC FF04"
	$"0000 FF00 00F6 FF01 00FF 8100 8100 D300"
	$"F9FF 003E CF00 02FF 00FF FB00 00FF FD00"
	$"0BFF 0000 FF00 00FF 0000 FF00 FFFE 0007"
	$"FF00 FF00 00FF 00FF FD00 00FF FB00 00FF"
	$"FC00 00FF FB00 02FF 00FF 8100 8100 D300"
	$"F9FF 003A CF00 02FF 00FF FB00 00FF FD00"
	$"FDFF 0100 00FD FF01 00FF FE00 01FF 00FD"
	$"FF00 00FD FF01 00FF FB00 00FF FC00 00FF"
	$"FB00 02FF 00FF 8100 8100 D300 F9FF 001C"
	$"CF00 02FF 00FF FB00 00FF D500 00FF FB00"
	$"02FF 00FF 8100 8100 D300 F9FF 0030 CF00"
	$"02FF 00FF FB00 00FF FA00 00FF FB00 00FF"
	$"FA00 00FF FB00 00FF FB00 00FF FA00 00FF"
	$"FB00 02FF 00FF 8100 8100 D300 F9FF 0030"
	$"CF00 02FF 00FF FB00 00FF FA00 00FF FB00"
	$"00FF FA00 00FF FB00 00FF FB00 00FF FA00"
	$"00FF FB00 02FF 00FF 8100 8100 D300 F9FF"
	$"0030 CF00 02FF 00FF FB00 00FF FA00 00FF"
	$"FB00 00FF FA00 00FF FB00 00FF FB00 00FF"
	$"FA00 00FF FB00 02FF 00FF 8100 8100 D300"
	$"F9FF 0012 CF00 01FF 00C5 FF01 00FF 8100"
	$"8100 D300 F9FF 0010 CF00 00FF C300 00FF"
	$"8100 8100 D300 F9FF 000C CF00 C1FF 8100"
	$"8100 D300 F9FF 000A 8100 8100 8100 E100"
	$"F9FF 000A 8100 8100 8100 E100 F9FF 000A"
	$"8100 8100 8100 E100 F9FF 000A 8100 8100"
	$"8100 E100 F9FF 000A 8100 8100 8100 E100"
	$"F9FF 000A 8100 8100 8100 E100 F9FF 000A"
	$"8100 8100 8100 E100 F9FF 0014 C300 F8FF"
	$"0000 F0FF 0000 EEFF 8100 8100 CE00 F9FF"
	$"001B C500 FEFF FC94 FDFF F194 03FF 00FF"
	$"FFF1 94FE FF81 0081 00D0 00F9 FF00 1FC7"
	$"00FE FFFB 9404 FFFF 00FF FFF0 9403 FFFF"
	$"94FF F094 FDFF 8100 8100 D300 F9FF 0020"
	$"C900 FEFF FB94 FEFF 0200 FFFF EF94 04FF"
	$"FF94 94FF EE94 FEFF 8100 8100 D500 F9FF"
	$"0021 CA00 01FF FFF9 9404 FF94 94FF FFED"
	$"9400 FFFE 9400 FFEC 94FE FF81 0081 00D8"
	$"00F9 FF00 23CC 0001 FFFF F994 05FF FF94"
	$"94FF FFEC 9405 FFFF 9494 FFFF EB94 FEFF"
	$"8100 8100 DA00 F9FF 0023 CE00 01FF FFF8"
	$"9405 FFFF 9494 FFFF EA94 00FF FE94 01FF"
	$"FFE9 94FE FF81 0081 00DD 00F9 FF00 24D0"
	$"0001 FFFF F794 05FF FF94 94FF FFE8 9400"
	$"FFFE 9401 FFFF E794 01FF FF81 0081 00DF"
	$"00F9 FF00 15D2 00F2 FF01 9494 E3FF FE94"
	$"E1FF 8100 8100 E200 F9FF 0014 D200 F3FF"
	$"FE94 E3FF FE94 E1FF 8100 8100 E200 F9FF"
	$"0026 D200 01FF FFF7 7901 FFFF FE94 01FF"
	$"FFE7 7901 FFFF FE94 01FF FFE5 7901 FFFF"
	$"8100 8100 E200 F9FF 0026 D200 01FF FFF7"
	$"7901 FFFF FE94 01FF FFE7 7901 FFFF FE94"
	$"01FF FFE5 7901 FFFF 8100 8100 E200 F9FF"
	$"0026 D200 01FF FFF7 7901 FFFF FE94 01FF"
	$"FFE7 7901 FFFF FE94 01FF FFE5 7901 FFFF"
	$"8100 8100 E200 F9FF 002A D200 01FF FFF7"
	$"7901 FFFF FE94 01FF FFE7 7901 FFFF FE94"
	$"01FF FFF6 79FA FFF7 7901 FFFF 8100 8100"
	$"E200 F9FF 002A D200 01FF FFF7 7901 FFFF"
	$"FE94 01FF FFE7 7901 FFFF FE94 01FF FFF6"
	$"79FA FFF7 7901 FFFF 8100 8100 E200 F9FF"
	$"002F D400 FDFF F779 01FF FFFE 9401 FFFF"
	$"E779 01FF FFFE 9401 FFFF F679 01FF FFFE"
	$"9401 FFFF F779 01FF FF81 0081 00E2 00F9"
	$"FF00 33D5 0004 FFFF 94FF FFF7 7901 FFFF"
	$"FE94 01FF FFE7 7901 FFFF FE94 01FF FFF6"
	$"7901 FFFF FE94 01FF FFF7 7901 FFFF 8100"
	$"8100 E200 F9FF 0034 D600 00FF FE94 01FF"
	$"FFF7 7901 FFFF FE94 01FF FFE7 7901 FFFF"
	$"FE94 01FF FFF6 7901 FFFF FE94 01FF FFF7"
	$"7901 FFFF 8100 8100 E200 F9FF 002E D800"
	$"01FF FFFD 9401 FFFF F779 01FF FFFE 9401"
	$"FFFF F679 F0FF FE94 01FF FFF6 79FA FFF7"
	$"7901 FFFF 8100 8100 E200 F9FF 002E D900"
	$"01FF FFFC 9401 FFFF F779 01FF FFFE 9401"
	$"FFFF F679 F0FF FE94 01FF FFF6 79FA FFF7"
	$"7901 FFFF 8100 8100 E200 F9FF 0031 DB00"
	$"01FF FFFA 9401 FFFF F779 01FF FFFE 9401"
	$"FFFF F679 01FF FFF5 9402 FF00 FFFE 9401"
	$"FFFF E579 01FF FF81 0081 00E2 00F9 FF00"
	$"30DC 0001 FFFF F994 01FF FFF7 7901 FFFF"
	$"FE94 01FF FFF6 7901 FFFF F494 01FF FFFE"
	$"9401 FFFF E579 01FF FF81 0081 00E2 00F9"
	$"FF00 2EDE 00FE FFF8 9401 FFFF F779 01FF"
	$"FFFE 9401 FFFF F679 01FF FFF4 94FE FF03"
	$"9494 FFFF E579 01FF FF81 0081 00E2 00F9"
	$"FF00 28DF 00F2 FFF7 7901 FFFF FE94 01FF"
	$"FFF6 79EF FF03 9494 FFFF F679 FAFF F779"
	$"01FF FF81 0081 00E2 00F9 FF00 28DF 00F2"
	$"FFF7 7901 FFFF FE94 01FF FFF6 79EF FF03"
	$"9494 FFFF F679 FAFF F779 01FF FF81 0081"
	$"00E2 00F9 FF00 30DF 0001 FFFF EA79 01FF"
	$"FFFE 9401 FFFF E779 06FF FF00 FF94 FFFF"
	$"F679 01FF FFFE 9401 FFFF F779 01FF FF81"
	$"0081 00E2 00F9 FF00 69DF 0001 FFFF EA79"
	$"03FF FF94 94FE FFE7 7906 FFFF 00FF 94FF"
	$"FFF6 7901 FFFF FE94 01FF FFF7 7901 FFFF"
	$"AB00 FDFF FE00 00FF F400 00FF F600 00FF"
	$"FC00 00FF EB00 FDFF FE00 00FF FD00 02FF"
	$"0000 FCFF FE00 FDFF 0100 00FA FFF8 0000"
	$"FFFC 00FD FFFD 00FD FFFC 0001 FFFF BC00"
	$"F9FF 0076 DF00 01FF FFEA 7902 FFFF 94FD"
	$"FFE7 7906 FFFF 00FF 94FF FFF6 7901 FFFF"
	$"FE94 01FF FFF7 7901 FFFF B800 FDFF F900"
	$"00FF FD00 03FF 0000 FFE8 0000 FFE6 0000"
	$"FFFD 0003 FF00 00FF FD00 03FF 0000 FFFB"
	$"0000 FFFD 0000 FFFD 0000 FFF6 0001 FFFF"
	$"FD00 00FF FD00 03FF 0000 FFFD 0000 FFFE"
	$"0003 FF00 00FF BD00 F9FF 0094 DF00 01FF"
	$"FFEA 7906 FFFF 94FF 00FF FFE7 7903 FFFF"
	$"0000 FEFF F679 FEFF 0394 94FF FFF7 7901"
	$"FFFF B900 00FF FD00 00FF FA00 00FF FA00"
	$"03FF 00FF FFFE 0001 FF00 FEFF 0200 FFFF"
	$"FD00 FEFF FE00 FEFF FE00 01FF FFFD 00FE"
	$"FFFE 0003 FF00 FFFF FA00 00FF FD00 03FF"
	$"0000 FFFD 0003 FF00 00FF FB00 00FF F800"
	$"00FF F500 00FF FD00 00FF FD00 03FF 0000"
	$"FFFD 0003 FF00 00FF FD00 00FF BE00 F9FF"
	$"0099 DF00 01FF FFEA 79FD FF02 00FF FFE7"
	$"7903 FFFF 0000 FEFF F679 FDFF 0294 FFFF"
	$"F779 01FF FFBA 0007 FF00 00FF FF00 00FF"
	$"FB00 00FF FA00 08FF FF00 00FF 0000 FFFF"
	$"FC00 00FF FE00 00FF FE00 00FF FE00 00FF"
	$"FC00 00FF FE00 00FF FE00 07FF 0000 FFFF"
	$"0000 FFFB 0000 FFFD 0003 FF00 00FF FD00"
	$"03FF 0000 FFFB 0000 FFF8 0000 FFF5 0000"
	$"FFFD 0000 FFFD 0003 FF00 00FF FD00 03FF"
	$"0000 FFFD 0000 FFBE 00F9 FF00 94DF 0001"
	$"FFFF EA79 FEFF 0300 00FF FFE7 7903 FFFF"
	$"0000 FEFF F679 06FF FF00 FF94 FFFF F779"
	$"01FF FFBA 0002 FF00 FFFD 0000 FFFB 0000"
	$"FFFA 0000 FFFE 0003 FF00 00FF FB00 00FF"
	$"FE00 00FF FA00 00FF FC00 00FF FD00 FDFF"
	$"0200 00FF FE00 00FF FB00 00FF FD00 03FF"
	$"0000 FFFD 0002 FF00 00FD FFFD 00FD FFFC"
	$"0000 FFF5 0000 FFFD 0000 FFFD 0003 FF00"
	$"00FF FD00 03FF 0000 FFFD 0000 FFBE 00F9"
	$"FF00 8FDF 0001 FFFF EA79 FEFF 0300 00FF"
	$"FFE7 7901 FFFF FE00 01FF FFF6 7902 FFFF"
	$"00FD FFF7 7901 FFFF BA00 02FF 00FF FD00"
	$"00FF FB00 00FF FA00 00FF FE00 03FF 0000"
	$"FFFB 0000 FFFD 00FE FFFD 0000 FFFC 0000"
	$"FFFE 0000 FFFE 0003 FF00 00FF FE00 00FF"
	$"FB00 00FF FD00 03FF 0000 FFFD 0003 FF00"
	$"00FF F600 00FF FD00 00FF F500 00FF FC00"
	$"FCFF FE00 FCFF 0200 00FF FD00 00FF BE00"
	$"F9FF 0091 DF00 01FF FFEA 7901 FFFF FE00"
	$"01FF FFE7 7901 FFFF FE00 01FF FFF6 7903"
	$"FFFF 0000 FEFF F779 01FF FFBA 0007 FF00"
	$"00FF FF00 00FF FB00 00FF FA00 00FF FE00"
	$"03FF 0000 FFFB 0000 FFFA 0000 FFFE 0000"
	$"FFFC 0000 FFFE 0000 FFFE 0003 FF00 00FF"
	$"FE00 00FF FB00 00FF FD00 03FF 0000 FFFD"
	$"0003 FF00 00FF F600 00FF FD00 00FF F500"
	$"00FF F800 00FF FA00 03FF 0000 FFFD 0000"
	$"FFBE 00F9 FF00 83DF 00E6 FFFE 00E3 FFFE"
	$"00F2 FFFE 00F3 FFB9 0000 FFFD 0000 FFFA"
	$"0000 FFFD 0003 FF00 00FF FE00 03FF 0000"
	$"FFFB 0000 FFFE 0000 FFFE 0000 FFFE 0000"
	$"FFFC 0000 FFFE 0000 FFFE 0003 FF00 00FF"
	$"FE00 00FF FB00 08FF 0000 FF00 FF00 00FF"
	$"FD00 03FF 0000 FFFB 0000 FFFD 0000 FFFD"
	$"0000 FFF5 0000 FFF9 0000 FFFA 0000 FFFD"
	$"0003 FF00 00FF BD00 F9FF 0069 DF00 E6FF"
	$"FE00 E3FF FE00 F2FF FE00 F3FF B800 FDFF"
	$"F800 FDFF FE00 00FF FE00 03FF 0000 FFFB"
	$"0000 FFFD 00FE FFFC 0001 FFFF FE00 00FF"
	$"FD00 FDFF 0200 00FF FE00 00FF FA00 FDFF"
	$"FD00 FDFF FE00 FCFF FE00 FDFF FC00 00FF"
	$"F500 00FF FC00 FEFF FC00 FEFF FB00 01FF"
	$"FFBC 00F9 FF00 0E81 0081 00E8 0000 FF81"
	$"00FB 00F9 FF00 0A81 0081 0081 00E1 00F9"
	$"FF00 0A81 0081 0081 00E1 00F9 FF00 0A81"
	$"0081 0081 00E1 00F9 FF00 44D7 00FB FF01"
	$"0000 FBFF 0300 00FF FFFC 00FB FF02 00FF"
	$"FFFD 0001 FFFF FD00 01FF FFFE 00FB FF02"
	$"00FF FFFE 00FD FFFE 0001 FFFF FE00 03FF"
	$"FF00 00FB FFA9 00FD FF81 00B8 00F9 FF00"
	$"9CD5 0001 FFFF FD00 01FF FFFB 0001 FFFF"
	$"FC00 01FF FFFC 0001 FFFF FD00 01FF FFFD"
	$"0001 FFFF FC00 01FF FFFE 000D FFFF 0000"
	$"FFFF 0000 FFFF 0000 FFFF FE00 05FF FF00"
	$"00FF FFA6 0000 FFFD 0000 FFFC 00FD FF02"
	$"0000 FFFC 0006 FF00 FFFF 0000 FFEE 00FD"
	$"FFFE 00FE FF02 0000 FFFE 0002 FF00 FFFA"
	$"0000 FFFE 0006 FFFF 0000 FF00 00FE FF01"
	$"0000 FDFF 0000 FDFF FA00 00FF FD00 FEFF"
	$"FE00 FEFF FD00 01FF FFB2 00F9 FF00 A4D5"
	$"0001 FFFF FD00 01FF FFFB 0001 FFFF FC00"
	$"01FF FFFC 00FE FF01 0000 FEFF FE00 FDFF"
	$"FD00 01FF FFFE 0004 FFFF 00FF FFFD 0004"
	$"FFFF 00FF FFFE 0005 FFFF 0000 FFFF A700"
	$"07FF 0000 FFFF 0000 FFFD 0000 FFFE 0002"
	$"FF00 FFF9 0000 FFEB 0000 FFFE 0002 FF00"
	$"FFFE 0002 FF00 FFFE 0002 FF00 FFFA 0000"
	$"FFFE 0006 FFFF 0000 FF00 FFFE 0002 FF00"
	$"FFFD 0000 FFFE 0000 FFFC 0001 FFFF FE00"
	$"00FF FE00 02FF 00FF FE00 03FF 0000 FFB0"
	$"00F9 FF00 B3D5 0001 FFFF FD00 FBFF 0300"
	$"00FF FFFC 00FB FF00 00FE FF01 0000 FEFF"
	$"FE00 FDFF FD00 01FF FFFE 0004 FFFF 00FF"
	$"FFFD 0004 FFFF 00FF FFFE 0003 FFFF 0000"
	$"FBFF AB00 02FF 00FF FD00 00FF FD00 00FF"
	$"FE00 01FF 00FE FF0A 0000 FFFF 0000 FF00"
	$"FFFF 00FE FF01 0000 FEFF FE00 01FF FFFC"
	$"0000 FFFE 0002 FF00 FFFE 0002 FF00 FFFE"
	$"0002 FF00 FFFB 000B FF00 FF00 00FF 00FF"
	$"00FF 00FF FC00 00FF FD00 00FF FE00 00FF"
	$"FB00 00FF FE00 00FF FE00 02FF 00FF FE00"
	$"02FF 00FF AF00 F9FF 00B1 D500 01FF FFFD"
	$"0001 FFFF FB00 01FF FFFC 0001 FFFF FC00"
	$"F9FF 0700 00FF FF00 00FF FFFE 0001 FFFF"
	$"FE00 04FF FF00 FFFF FD00 04FF FF00 FFFF"
	$"FE00 05FF FF00 00FF FFA7 0002 FF00 FFFD"
	$"0000 FFFD 00FD FF1D 0000 FF00 00FF 0000"
	$"FF00 00FF 0000 FF00 FF00 00FF 00FF 0000"
	$"FF00 FF00 00FF FD00 FDFF 0200 00FF FE00"
	$"02FF 00FF FE00 02FF 00FF FB00 10FF 00FF"
	$"0000 FF00 FF00 FF00 FF00 00FF FF00 FEFF"
	$"0100 00FD FFFA 0000 FFFD 00FD FF01 0000"
	$"FEFF 0100 00FD FFB2 00F9 FF00 AED5 0001"
	$"FFFF FD00 01FF FFFB 0001 FFFF FC00 01FF"
	$"FFFC 00F9 FF01 0000 FBFF FE00 01FF FFFE"
	$"0006 FFFF 00FF FF00 00FD FF02 00FF FFFE"
	$"0005 FFFF 0000 FFFF A700 07FF 0000 FFFF"
	$"0000 FFFD 0000 FFFC 0017 FF00 00FF 0000"
	$"FF00 00FF 0000 FF00 FF00 00FF 00FF 0000"
	$"FF00 FDFF FD00 00FF FE00 02FF 00FF FE00"
	$"02FF 00FF FE00 02FF 00FF FC00 FCFF 0700"
	$"FF00 00FF FF00 FFFE 0002 FF00 FFFD 0002"
	$"FF00 FFF9 0000 FFFA 0002 FF00 FFFE 0002"
	$"FF00 FFFE 0000 FFB3 00F9 FF00 B9D5 0001"
	$"FFFF FD00 01FF FFFB 0001 FFFF FC00 01FF"
	$"FFFC 000A FFFF 00FF FF00 FFFF 00FF FFFD"
	$"0005 FFFF 0000 FFFF FE00 09FF FF00 00FF"
	$"FF00 00FF FFFE 0004 FFFF 00FF FFFE 0001"
	$"FFFF A600 00FF FD00 00FF FC00 00FF FC00"
	$"18FF 0000 FF00 00FF 0000 FF00 00FF 00FF"
	$"0000 FF00 FF00 00FF 00FF FA00 00FF FE00"
	$"02FF 00FF FE00 02FF 00FF FE00 02FF 00FF"
	$"FC00 00FF FE00 08FF 00FF 0000 FFFF 00FF"
	$"FE00 02FF 00FF FD00 03FF 0000 FFFA 0000"
	$"FFFB 0003 FF00 00FF FE00 02FF 00FF FE00"
	$"00FF B300 F9FF 00A3 D500 01FF FFFD 00FB"
	$"FF01 0000 FCFF 0100 00FB FF0B 00FF FF00"
	$"FFFF 00FF FF00 FFFF FD00 05FF FF00 00FF"
	$"FFFE 0001 FFFF FE00 FBFF FE00 FEFF FD00"
	$"FBFF A900 FDFF FB00 00FF FC00 0DFF 0000"
	$"FF00 00FF 0000 FF00 00FF 00FE FF01 0000"
	$"FEFF FE00 01FF FFFC 00FD FFFE 00FE FFFE"
	$"00FE FF01 0000 FDFF 0200 00FF FE00 02FF"
	$"00FF FE00 02FF 0000 FEFF 0100 00FD FF01"
	$"00FF FE00 00FF FB00 00FF FD00 01FF FFFD"
	$"00FE FFFE 00FE FFB2 00F9 FF00 1081 0090"
	$"0000 FFFD 0000 FF81 00D8 00F9 FF00 1081"
	$"0090 0000 FFFD 0000 FF81 00D8 00F9 FF00"
	$"0A81 0081 0081 00E1 00F9 FF00 0A81 0081"
	$"0081 00E1 00F9 FF00 0A81 0081 0081 00E1"
	$"00F9 FF00 0A81 0081 0081 00E1 00F9 FF00"
	$"0A81 0081 0081 00E1 00F9 FF00 0A81 0081"
	$"0081 00E1 00F9 FF00 0A81 0081 0081 00E1"
	$"00F9 FF00 0A81 0081 0081 00E1 00F9 FF00"
	$"0A81 0081 0081 00E1 00F9 FF00 0A81 0081"
	$"0081 00E1 00F9 FF00 00A0 008F 00A0 0083"
	$"00FF"
};

resource 'PICT' (256, purgeable) {
	4879,
	{0, 0, 240, 416},
	$"1101 A000 82A0 008E 0100 0A00 0000 0000"
	$"F001 A098 0034 0000 0000 003B 01A0 0000"
	$"0000 003B 01A0 0000 0000 003B 01A0 0000"
	$"02CD 0002 CD00 02CD 0002 CD00 0A02 0000"
	$"07D3 FF00 C0FF 000A 0200 000F D3FF 00E0"
	$"FF00 0A02 0000 1FD3 FF00 F0FF 000A 0200"
	$"001F D3FF 00F0 FF00 0A02 0000 1FD3 FF00"
	$"F0FF 000F 0200 001F F3FF 01FA ABE3 FF00"
	$"F0FF 000E 0200 001F F5FF FC55 E4FF 00F0"
	$"FF00 1202 0000 1FF6 FF00 EAFC AA00 BFE5"
	$"FF00 F0FF 0012 0200 001F F4FF 00D5 FE55"
	$"005F E5FF 00F0 FF00 1102 0000 1FF3 FF03"
	$"FAAA AAAB E5FF 00F0 FF00 0F02 0000 1FF1"
	$"FF01 5555 E5FF 00F0 FF00 0F02 0000 1FF1"
	$"FF01 FAAA E5FF 00F0 FF00 0F02 0000 1FF0"
	$"FF01 557F E6FF 00F0 FF00 0E02 0000 1FF0"
	$"FF00 AAE5 FF00 F0FF 000F 0200 001F F0FF"
	$"01D5 7FE6 FF00 F0FF 000F 0200 001F F0FF"
	$"01EA BFE6 FF00 F0FF 000F 0200 001F F0FF"
	$"01F5 5FE6 FF00 F0FF 0012 0200 001F F3FF"
	$"04AA ABFF FABF E6FF 00F0 FF00 1202 0000"
	$"1FF5 FFFD 5502 5FFD 5FE6 FF00 F0FF 0014"
	$"0200 001F F6FF 00FA FDAA 02AF FEAF E6FF"
	$"00F0 FF00 1602 0000 1FF4 FFFD 5501 FF57"
	$"FEFF 01E0 41EB FF00 F0FF 0018 0200 001F"
	$"F3FF 0AEA AAAA FFAF FFFF FC00 003F ECFF"
	$"00F0 FF00 1702 0000 1FF2 FF03 D555 7F57"
	$"FEFF 0284 041F ECFF 00F0 FF00 1602 0000"
	$"1FF2 FF03 FEAA BFAB FDFF 0180 0FEC FF00"
	$"F0FF 0015 0200 001F F1FF 02D5 7FD7 FDFF"
	$"01F0 4FEC FF00 F0FF 0016 0200 001F F1FF"
	$"08FA BFEB E00F FFFF F80F ECFF 00F0 FF00"
	$"1602 0000 1FF1 FF08 F55F D5FE 47FF FFFC"
	$"0FEC FF00 F0FF 0016 0200 001F F1FF 08FE"
	$"AFEB FF80 FFFF F80F ECFF 00F0 FF00 1602"
	$"0000 1FF1 FF08 FD5F D5FF F17F FFF0 5FEC"
	$"FF00 F0FF 0016 0200 001F F1FF 08FE AFEA"
	$"FFF8 3FFF F03F ECFF 00F0 FF00 1502 0000"
	$"1FF0 FF07 57F5 FFFE 5FFF F47F ECFF 00F0"
	$"FF00 1602 0000 1FF1 FF08 FEAF FAFF FF0F"
	$"FFF0 7FEC FF00 F0FF 0015 0200 001F F0FF"
	$"0757 F57F FF93 FFF8 7FEC FF00 F0FF 0015"
	$"0200 001F F0FF 07AF FAFF FFE1 FFFC 3FEC"
	$"FF00 F0FF 0015 0200 001F F0FF 07D7 FD7F"
	$"FFE4 FFFE 3FEC FF00 F0FF 0015 0200 001F"
	$"F0FF 07AF FEFF FFF8 3FFE 1FEC FF00 F0FF"
	$"0015 0200 001F F0FF 07D7 FF7F FFFD 1FFF"
	$"5FEC FF00 F0FF 0011 0200 001F ECFF 03FE"
	$"0FFF 8FEC FF00 F0FF 0010 0200 001F EBFF"
	$"0247 FFC7 ECFF 00F0 FF00 1502 0000 1FF3"
	$"FF01 F911 FBFF 02C1 FFF3 ECFF 00F0 FF00"
	$"1602 0000 1FF3 FF02 4444 5FFC FF02 D17F"
	$"FBEC FF00 F0FF 0016 0200 001F F4FF 03F9"
	$"1111 17FC FF01 E00F EBFF 00F0 FF00 1602"
	$"0000 1FF4 FF03 E444 4447 FCFF 01FC 47EB"
	$"FF00 F0FF 0014 0200 001F F4FF FD11 FCFF"
	$"02FE 003F ECFF 00F0 FF00 1502 0000 1FF5"
	$"FF00 FCFD 44FB FF01 9111 ECFF 00F0 FF00"
	$"1902 0000 1FF5 FF05 F111 3FFD 117F FCFF"
	$"02F0 0003 EDFF 00F0 FF00 1A02 0000 1FF5"
	$"FF05 4447 FFFF 447F FCFF 03FE 4444 47EE"
	$"FF00 F0FF 001A 0200 001F F5FF 0511 3FFF"
	$"FFD1 3FFB FF03 E000 0003 EFFF 00F0 FF00"
	$"1A02 0000 1FF6 FF06 FC44 7FFF FFE4 5FFA"
	$"FFFE 1100 17F0 FF00 F0FF 001C 0200 001F"
	$"F6FF 0191 13FE FF01 F11F FAFF 00F8 FE00"
	$"0001 F1FF 00F0 FF00 1D02 0000 1FF7 FF02"
	$"FE44 4FFE FF01 FC5F F9FF 00FC FD44 007F"
	$"F3FF 00F0 FF00 1D02 0000 1FF7 FF02 F111"
	$"1FFE FF01 F91F F8FF 00F8 FD00 001F F4FF"
	$"00F0 FF00 1C02 0000 1FF7 FF01 4444 FDFF"
	$"01FC 4FF7 FF00 F9FD 1100 13F5 FF00 F0FF"
	$"001D 0200 001F F8FF 02F1 1113 FDFF 01FD"
	$"1FF6 FF00 F0FC 0000 1FF7 FF00 F0FF 001D"
	$"0200 001F F8FF 02C4 445F FDFF 01FC 4FF4"
	$"FF00 C4FD 4400 45F8 FF02 F000 0098 0034"
	$"003B 0000 0076 01A0 003B 0000 0076 01A0"
	$"003B 0000 0076 01A0 0000 1D02 0000 1FF9"
	$"FF03 F111 117F FCFF 0017 F3FF 00F0 FC00"
	$"007F FAFF 00F0 FF00 1E02 0000 1FFA FF03"
	$"FE44 4447 FCFF 01FE 47F1 FF00 D1FD 1100"
	$"1FFB FF00 F0FF 001D 0300 001F 11FB FFFE"
	$"1100 3FFB FF00 17F0 FF00 FCFD 0000 1FFC"
	$"FF00 F0FF 001F 0800 001F E444 4FFF FFFC"
	$"FE44 0047 FAFF 0047 EEFF 03F4 4444 45FC"
	$"FF00 F0FF 0019 0300 001F FDF9 1100 3FFA"
	$"FF00 17EC FF02 0000 7FFD FF00 F0FF 0019"
	$"0400 001F FFF4 FB44 004F F9FF 0047 EBFF"
	$"0111 3FFD FF00 F0FF 0019 0500 001F FFFF"
	$"D1FC 11F8 FF00 17EB FF06 F03F FFFF 13FF"
	$"F0FF 001B 0200 001F FEFF 03C4 4444 45F7"
	$"FF00 47EB FF06 FC7F FFF4 447F F0FF 0013"
	$"0200 001F F0FF 0017 EAFF 053F FF91 113F"
	$"F0FF 0012 0200 001F F0FF 0047 E9FF 04FE"
	$"4444 5FF0 FF00 1202 0000 1FF0 FF00 17E9"
	$"FF04 F111 111F F0FF 0012 0200 001F F0FF"
	$"0047 E9FF 04C4 4444 4FF0 FF00 1202 0000"
	$"1FF0 FF00 17E9 FF04 111F F917 F0FF 0013"
	$"0200 001F F0FF 0047 EAFF 05FC 447F FC47"
	$"F0FF 0013 0200 001F F0FF 0017 EAFF 05D1"
	$"11FF FF17 F0FF 0014 0200 001F F0FF 0047"
	$"EBFF 06FC 4447 FFFE 47F0 FF00 1402 0000"
	$"1FF0 FF00 17EB FF06 D111 1FFF FF17 F0FF"
	$"0015 0200 001F F0FF 0047 ECFF 07E4 4444"
	$"7FFF FF47 F0FF 0015 0200 001F F0FF 0017"
	$"EEFF 00F1 FD11 FEFF 0117 F0FF 0020 0200"
	$"001F F1FF 01FE 47FE FF00 FCF7 4400 7FFE"
	$"FF00 FCFD 4400 7FFE FF01 47F0 FF00 1802"
	$"0000 1FF0 FF01 1FFE F200 0407 FFFF D111"
	$"FBFF 0117 F0FF 0014 0200 001F F1FF 01FC"
	$"4FFE FFF3 11F7 FF01 47F0 FF00 1602 0000"
	$"1FF1 FF01 FD1F FBFF 00C0 F700 F7FF 0117"
	$"F0FF 0018 0200 001F F1FF 01FC 4FF7 FF00"
	$"F4FC 4400 45F7 FF01 47F0 FF00 1502 0000"
	$"1FF1 FF01 F91F F3FF 01F0 07F6 FF01 17F0"
	$"FF00 1602 0000 1FFB FF01 F445 F9FF 01F4"
	$"5FE7 FF02 FE47 F0FF 0018 0200 001F FDFF"
	$"00F1 FD11 001F FBFF 01F1 3FE6 FF01 17F0"
	$"FF00 1902 0000 1FFE FF00 C4FB 4400 7FFC"
	$"FF01 C47F E7FF 02FE 4FF0 FF00 1805 0000"
	$"1FFF FFF9 FA11 0017 FCFF 0191 3FE7 FF02"
	$"FD1F F0FF 0019 0200 001F FAFF 00F4 FE44"
	$"007F FDFF 0144 7FE7 FF02 FC4F F0FF 001A"
	$"0200 001F F8FF FE11 FDFF 0011 ECFF 0891"
	$"1111 3FFF FFF9 1FF0 FF00 1E02 0000 1FF8"
	$"FF07 E444 445F FFFF FC44 EDFF 00E4 FE44"
	$"0547 FFFF F45F F0FF 001C 0200 001F F7FF"
	$"0691 1113 FFFF F911 ECFF 00F1 FE11 047F"
	$"FFF1 1FF0 FF00 1B02 0000 1FF7 FF06 FC44"
	$"447F FFE4 47EB FF07 FC44 4447 FFC4 7FF0"
	$"FF00 1902 0000 1FF6 FF05 1111 17FF 9117"
	$"EAFF 06F1 1111 FF11 7FF0 FF00 1802 0000"
	$"1FF6 FF05 E444 44F4 444F EAFF 00FE FD44"
	$"017F F0FF 0017 0200 001F F6FF 00FD FD11"
	$"001F E9FF 00F1 FE11 01FF F0FF 0017 0200"
	$"001F F5FF 00C4 FE44 007F E9FF 05FC 4444"
	$"45FF F0FF 0014 0200 001F F5FF 00F1 FE11"
	$"E7FF 0411 1113 FFF0 FF00 1402 0000 1FF4"
	$"FF02 C444 47E7 FF04 E444 4FFF F0FF 0014"
	$"0200 001F F4FF 02FD 113F E7FF 04FD 113F"
	$"FFF0 FF00 0A02 0000 1FD3 FF00 F0FF 000A"
	$"0200 001F D3FF 00F0 FF00 0A02 0000 1FD3"
	$"FF00 F0FF 000A 0200 001F D3FF 00F0 FF00"
	$"0A02 0000 1FD3 FF00 F0FF 000A 0200 000F"
	$"D3FF 00E0 FF00 0A02 0000 07D3 FF00 C0FF"
	$"0002 CD00 02CD 0002 CD00 02CD 0002 CD00"
	$"02CD 000A FB00 003F FAFF 00C0 DC00 0AFB"
	$"0000 20FA 0000 40DC 000A FB00 002F FAFF"
	$"0040 DC00 0EFB 0008 2810 1020 2040 8081"
	$"40DC 000E FB00 0828 1010 2020 4080 8140"
	$"DC00 9800 3400 7600 0000 B101 A000 7600"
	$"0000 B101 A000 7600 0000 B101 A000 000E"
	$"FB00 0828 1010 2020 4080 8140 DC00 0EFB"
	$"0008 2810 1020 2040 8081 40DC 0013 FB00"
	$"0828 1010 2020 4080 8140 E600 0107 80F9"
	$"0013 FB00 0828 1010 2020 40F0 8140 E600"
	$"0118 60F9 0013 FB00 0828 1010 2023 C0D8"
	$"8140 E600 0120 10F9 0013 FB00 002F FEFF"
	$"04FE FFAF FF40 E600 0127 10F9 0013 FB00"
	$"0828 1010 2025 795E 8140 E600 0144 88F9"
	$"0013 FB00 0828 1010 2026 BDAF 8140 E600"
	$"0144 88F9 0018 FB00 0828 1010 2025 7F5D"
	$"C140 EC00 0120 02FD 0001 4708 F900 23FB"
	$"0008 2810 1020 26FE AAE1 40F6 0011 FF80"
	$"FF80 0080 007F 01F8 3FFE 3FF8 FF80 4488"
	$"F900 23FB 0008 2810 1020 23FD 5571 40F6"
	$"0011 3060 3060 0080 0183 821C 3186 0C1C"
	$"3060 2490 F900 20FB 0000 2FFD FF03 FAAA"
	$"FF40 F600 FD30 0D00 C003 0184 0C21 820C"
	$"0C30 3020 10F9 0023 FB00 0828 1010 2027"
	$"5557 F140 F600 1130 1830 3001 C006 008C"
	$"0401 800C 0430 3018 60F9 0023 FB00 0828"
	$"1010 202F DAAF E140 F600 1130 1830 3001"
	$"6006 000C 0001 800C 0030 3007 80F9 0021"
	$"FB00 0828 1010 2035 F55F C140 F600 0F30"
	$"0C30 3001 600C 000C 0001 800C 0030 30F7"
	$"0021 FB00 0828 1010 203A FEBF 8140 F600"
	$"0F30 0C30 3002 200C 0007 0001 800C 1030"
	$"30F7 0021 FB00 0828 1010 23D5 F35E 8140"
	$"F600 0F30 0C30 6002 300C 0007 C001 800C"
	$"3030 60F7 0021 FB00 0828 1010 3EAA F2BE"
	$"8140 F600 0F30 0C3F C002 300C 0001 F001"
	$"800F F03F C0F7 0020 FB00 0828 101C 3555"
	$"F35C 8140 F600 0E30 0C33 0004 180C 07C0"
	$"7801 800C 3033 F600 21FB 0008 2FFF FBEA"
	$"AAFE BFFF 40F6 000F 300C 3180 0418 0C01"
	$"801C 0180 0C10 3180 F700 21FB 0008 295F"
	$"35F5 55F7 5F61 40F6 000F 300C 3180 07F8"
	$"0C01 800E 0180 0C00 3180 F700 21FB 0008"
	$"2AAB EBEA BAF6 BEB9 40F6 000F 300C 30C0"
	$"080C 0C01 8006 0180 0C00 30C0 F700 21FB"
	$"0008 2D55 F5F5 75ED 5D7D 40F6 000F 3018"
	$"3060 080C 0601 8006 0180 0C04 3060 F700"
	$"21FB 0008 2EAB EBEA FAEA AABD 40F6 000F"
	$"3018 3060 080C 0601 8806 0180 0C04 3060"
	$"F700 1FFB 0001 2D55 FEF5 03FD 557D 40F6"
	$"00FD 300B 1006 0301 8C04 0180 0C0C 3030"
	$"F700 21FB 0008 2EEA EBEA FAEA AAFF 40F6"
	$"000F 3860 3038 1006 0183 0E08 0180 0C1C"
	$"3038 F700 20FB 0000 29FD F503 5555 F140"
	$"F600 0FFF 80FC 1C7C 1F80 7C07 F007 E03F"
	$"F8FC 1CF7 000E FB00 0828 2BEB AAFA AABF"
	$"E140 DC00 0EFB 0008 2835 F595 F555 FF81"
	$"40DC 000E FB00 0828 6BEB AAFA AFFE 8140"
	$"DC00 0EFB 0000 28FE D504 EF7F C081 40DC"
	$"000E FB00 0028 FEAB 04E1 FF80 8140 DC00"
	$"0DFB 0003 2FD5 5557 FDFF 0040 DC00 0EFB"
	$"0008 28AA AAAF E040 8081 40DC 000E FB00"
	$"0828 D55D 5FE0 4080 8140 DC00 0EFB 0008"
	$"28AA BFFF A040 8081 40DC 000E FB00 0828"
	$"555F FF20 4080 8140 DC00 0EFB 0008 286A"
	$"BE7C 2040 8081 40DC 000E FB00 0828 37FE"
	$"2020 4080 8140 DC00 0AFB 0000 2FFA FF00"
	$"40DC 000E FB00 0828 13F0 2020 4080 8140"
	$"DC00 0EFB 0008 2810 1020 2040 8081 40DC"
	$"000E FB00 0828 1010 2020 4080 8140 DC00"
	$"0CFB 0001 2810 FC00 0181 40DC 000E FB00"
	$"0828 10F3 DE7B DF70 8140 DC00 0EFB 0008"
	$"2810 9251 4A11 2081 40DC 000E FB00 082F"
	$"FE82 5143 DF27 FF40 DC00 0EFB 0008 2810"
	$"9251 4A10 2081 40DC 000E FB00 0828 10F3"
	$"D17B D020 8140 DC00 0CFB 0001 2810 FC00"
	$"0181 40DC 000E FB00 0828 1010 2020 4080"
	$"8140 DC00 0EFB 0008 2810 1020 2040 8081"
	$"40DC 000E FB00 0828 1010 2020 4080 8140"
	$"DC00 0AFB 0000 2FFA FF00 40DC 000A FB00"
	$"0020 FA00 0040 DC00 0AFB 0000 3FFA FF00"
	$"C0DC 0002 CD00 02CD 0002 CD00 9800 3400"
	$"B100 0000 EC01 A000 B100 0000 EC01 A000"
	$"B100 0000 EC01 A000 0002 CD00 02CD 0002"
	$"CD00 02CD 000C FA00 0603 FEFF FFBF FFF8"
	$"DB00 0CFA 0006 0E4F 4444 B444 4EDB 000D"
	$"FA00 0739 1B11 1179 1113 C0DC 000D FA00"
	$"07E4 7644 4464 4444 70DC 000E FB00 0801"
	$"915D 1111 3311 111E DC00 0FFB 0009 0645"
	$"DC44 4477 4444 4780 DD00 0FFB 0002 1913"
	$"31FE 1103 9111 1170 DD00 0FFB 0009 6446"
	$"6444 444C C444 444C DD00 11FC 0002 01FF"
	$"FDFE FF01 FD7F FEFF 0080 DE00 11FC 0002"
	$"01FF FCFE FF01 FC7F FEFF 0080 DE00 11FC"
	$"0007 01BB B9FB BBBB BD7B FEBB 0080 DE00"
	$"11FC 0002 01EE FCFE EE05 EC6E EEEE EF80"
	$"DE00 11FC 0007 01BB B9FB BBBB BD7B FEBB"
	$"0080 DE00 11FC 0002 01EE FCFE EE05 EC6E"
	$"EFFE EF80 DE00 11FC 000B 01BB B9FB BBBB"
	$"BD7B BBFB BB80 DE00 11FC 0002 07EE FCFE"
	$"EE05 EC6E EF5E EF80 DE00 11FC 000B 0DBB"
	$"B9FB BBBB BD7B BB1B BB80 DE00 11FC 0002"
	$"15EE FCFE EE05 EC6E EF5E EF80 DE00 11FC"
	$"000B 71BB B9FB BFFF FD7B BBFB BB80 DE00"
	$"11FC 000B C5EE FCEE EFFF FC6E EFFE EF80"
	$"DE00 12FD 0008 0311 BBB9 FBBF 1115 7BFE"
	$"BB00 80DE 0012 FD00 0C06 45EE FCEE EE44"
	$"4C6E EEEE EF80 DE00 12FD 0008 1D11 BBB9"
	$"FBBF 111F 7BFE BB00 80DE 0012 FD00 0C3F"
	$"FFEE FCEE EFFF FE6E EFFE EF80 DE00 12FD"
	$"000C 3FFF BBB9 FBBF FFFF 7BBB FBBB 80DE"
	$"0012 FD00 033E EEEE FCFE EE05 ED6E EF5E"
	$"EF80 DE00 27FD 000C 3BBB BBB9 FBBB BBBD"
	$"7BBB 1BBB 80F8 0011 01E2 0008 0082 0000"
	$"0788 4F8F 3F80 20F0 F060 F900 28FD 0003"
	$"3EEE EEFF FEEE 05ED 6EEF 5EEF 80F9 0002"
	$"3C02 12FE 000C 8000 0008 4848 1084 0061"
	$"0908 90F9 0028 FD00 0C3B BBBB BAFB BBBB"
	$"BCFB BB9B BB80 F900 1242 0202 C5D8 71C6"
	$"1C58 0848 4810 0400 2109 0908 F900 28FD"
	$"0003 3EEE EEFE FEEE 05EC EEEF DEEF 80F9"
	$"0012 9902 0326 0888 8222 6408 4848 1004"
	$"0021 0909 08F9 0028 FD00 0C3B BBBB BCFB"
	$"BBBB BCFB BB5B BB80 F900 12A1 0202 2408"
	$"8082 1E44 0848 4F0F 0400 2109 0908 F900"
	$"28FD 0003 3EEE EEFC FEEE 05EC 6EEF 7EEF"
	$"80F9 0012 A102 0224 0870 8222 4408 4848"
	$"0084 0020 F8F9 08F9 0028 FD00 0C3B BBBB"
	$"B8FB BBBB BC7B BB3B BB80 F900 1299 0202"
	$"2408 0882 2244 0848 4800 8400 2008 0908"
	$"F900 28FD 0003 3FFF FFF8 FEFF 05FC 7FFF"
	$"1FFF 80F9 0012 4202 1224 0888 8222 4409"
	$"4848 1084 0020 1010 90F9 0028 FD00 033F"
	$"FFFF F8FE FF05 FC7F FF1F FF80 F900 123C"
	$"01E2 2408 7062 1E44 0787 8F8F 0400 20E0"
	$"E060 F900 06DE 0000 40F1 0002 CD00 02CD"
	$"0002 CD00 14FC 000A 3F3F 307E C30C 7EC7"
	$"8C67 E0F7 0000 1EE8 0023 FC00 090C 3030"
	$"60C3 0C18 CCCC 66F6 0010 2107 9059 0000"
	$"1E39 1404 64E7 BC04 38E1 80F8 0022 FC00"
	$"090C 3030 60E7 1E18 D86C 66F6 000F 4C84"
	$"5008 0000 1145 1404 6514 220C 4512 F700"
	$"23FC 000A 0C3F 307E E71E 18D8 6C67 E0F7"
	$"000F 5084 5CCB 738C 1145 140A 5504 2204"
	$"4514 F700 23FC 0009 0C30 3060 FF33 18D8"
	$"6C66 F600 1050 8792 494A 521E 4514 0A55"
	$"373C 043C E780 F800 23FC 0009 0C30 3060"
	$"FF3F 18D9 EC66 F600 104C 8412 494A 5E11"
	$"4514 1F4D 1428 0405 1440 F800 23FC 0009"
	$"0C30 3060 DB61 98CC C6C6 F600 1021 0412"
	$"494A 5011 4514 114D 1424 0409 1440 F800"
	$"24FC 000A 0C3F 3E7E DB61 98C7 E387 E0F7"
	$"0010 1E04 1249 738C 1E38 E791 44E7 A204"
	$"30E3 80F8 0006 E300 0042 EC00 06E3 0000"
	$"42EC 0002 CD00 02CD 0002 CD00 02CD 0002"
	$"CD00 02CD 0098 0034 00EC 0000 00F0 01A0"
	$"00EC 0000 00F0 01A0 00EC 0000 00F0 01A0"
	$"0000 02CD 0002 CD00 02CD 0002 CD00 A000"
	$"8FA0 0083 FF"
};

resource 'DLOG' (137, "Analyser?", purgeable) {
	{40, 40, 181, 350},
	dBoxProc,
	invisible,
	goAway,
	0x200,
	137,
	""
};

resource 'DLOG' (136, "Modem introuvable", purgeable) {
	{40, 40, 162, 252},
	dBoxProc,
	invisible,
	goAway,
	0x200,
	136,
	""
};

resource 'DLOG' (259, "Sauver?", purgeable) {
	{40, 40, 180, 344},
	dBoxProc,
	invisible,
	goAway,
	0x0,
	259,
	""
};

resource 'DLOG' (135, "Analyse de syntaxe") {
	{78, 124, 135, 376},
	dBoxProc,
	invisible,
	noGoAway,
	0x200,
	135,
	""
};

resource 'DLOG' (128, "Chercher") {
	{56, 36, 212, 298},
	movableDBoxProc,
	invisible,
	noGoAway,
	0x200,
	128,
	"Chercher"
	/****** Extra bytes follow... ******/
	/* $"0028 0A"                                            /* .(. */
};

resource 'DLOG' (129, "Remplacer") {
	{52, 36, 250, 294},
	movableDBoxProc,
	invisible,
	noGoAway,
	0x200,
	129,
	"Remplacer"
	/****** Extra bytes follow... ******/
	/* $"280A"                                               /* (. */
};

resource 'DLOG' (256, "About", purgeable) {
	{60, 48, 300, 464},
	altDBoxProc,
	invisible,
	noGoAway,
	0x200,
	256,
	""
};

resource 'DLOG' (257, "Erreur", purgeable) {
	{95, 97, 212, 404},
	dBoxProc,
	invisible,
	noGoAway,
	0x0,
	257,
	""
};

resource 'DLOG' (260, "Config") {
	{90, 98, 258, 336},
	dBoxProc,
	invisible,
	noGoAway,
	0x200,
	260,
	"Config"
};

resource 'DLOG' (130, "Routines Externes") {
	{86, 60, 286, 404},
	documentProc,
	invisible,
	goAway,
	0x0,
	130,
	"Routines Externes"
};

resource 'DLOG' (131, "Opt. Compil") {
	{40, 40, 252, 338},
	dBoxProc,
	invisible,
	noGoAway,
	0x200,
	131,
	"Opt. Compil."
};

resource 'DLOG' (132, "Opt. Analyse") {
	{64, 58, 214, 302},
	dBoxProc,
	invisible,
	noGoAway,
	0x200,
	132,
	"Opt. Analyse"
};

resource 'DLOG' (300, "Insérez la disquette…", purgeable) {
	{218, 74, 264, 312},
	dBoxProc,
	invisible,
	noGoAway,
	0x0,
	300,
	""
};

resource 'DLOG' (301, purgeable) {
	{52, 60, 110, 298},
	dBoxProc,
	invisible,
	noGoAway,
	0x0,
	301,
	""
};

resource 'DLOG' (133, "Port utilisé") {
	{40, 40, 182, 258},
	dBoxProc,
	invisible,
	goAway,
	0x200,
	133,
	""
};

resource 'DLOG' (134, "Prob. Port") {
	{40, 40, 166, 268},
	dBoxProc,
	invisible,
	noGoAway,
	0x200,
	134,
	""
};

resource 'DLOG' (138, "Compilation") {
	{58, 18, 156, 338},
	movableDBoxProc,
	invisible,
	noGoAway,
	0x200,
	138,
	"Compilation"
	/****** Extra bytes follow... ******/
	/* $"0000"                                               /* .. */
};

resource 'ICON' (128, "Find", purgeable) {
	$"0000 0000 0000 0000 0000 0000 0000 0000"
	$"001F 0000 0065 C000 00BE A000 01C1 B000"
	$"0100 7000 0200 3800 0200 2800 0600 1800"
	$"0600 1800 0600 1800 0500 1800 0700 1000"
	$"0380 2800 0360 E400 01DF 5200 00FF E900"
	$"003E 3480 0000 1A40 0000 0D20 0000 06E0"
	$"0000 0360 0000 01E0 0000 00C0"
};

resource 'ICON' (129) {
	$"0FFF FFC0 1400 0040 2492 2440 4555 5440"
	$"F555 5440 9C92 2440 8000 0040 9092 2440"
	$"91FF FFC0 9200 0040 94FF FF20 858F FFA0"
	$"8507 FFA0 9507 FFA0 AD07 FFA0 AD07 FFA0"
	$"9507 FFA0 858F FFA0 85FF FFA0 95FF FFA0"
	$"95FF FFA0 94FF FF20 9400 0020 87FF FFE0"
	$"8400 0020 8999 9990 9000 0008 A667 E666"
	$"C000 0002 FFFF FFFF 8000 0001 FFFF FFFF"
};

resource 'ICON' (130) {
	$"0000 0000 0000 0000 0000 0000 0000 0000"
	$"0000 0000 0000 0000 0000 0000 0000 0000"
	$"01FF FF80 0200 0040 04FF FF20 0500 01A0"
	$"057E 00A0 0500 00A0 057F F0A0 0500 00A0"
	$"057E 00A0 0500 1CA0 057F D4A0 0500 1CA0"
	$"0580 01A0 04FF FF20 0400 0020 07FF FFE0"
	$"0400 0020 0999 9990 1000 0008 2667 E664"
	$"4000 0002 FFFF FFFF 8000 0001 FFFF FFFF"
};

resource 'ICON' (131) {
	$"0000 000C 0000 0014 0000 002C 0000 0048"
	$"0000 00B0 0000 0110 0000 02E0 0000 0240"
	$"01FF E580 0200 0900 04FF 9220 058F 94A0"
	$"0507 25A0 0507 29A0 0507 33A0 0507 33A0"
	$"0507 27A0 058F 27A0 05FF AFA0 05FF 8FA0"
	$"05FF FFA0 04FF FF20 0400 0020 07FF FFE0"
	$"0400 0020 0999 9990 1000 0008 2667 E664"
	$"4000 0002 FFFF FFFF 8000 0001 FFFF FFFF"
};

resource 'ICON' (132) {
	$"0000 0000 0000 0000 001F C000 003F A000"
	$"007F 2000 00FE A000 01FC 8000 03FA 8000"
	$"07FF FF80 0FEA 0040 0FFF FF20 14A8 00A0"
	$"1520 00A0 1520 00A0 0500 00A0 0500 00A0"
	$"0500 00A0 0500 00A0 0500 00A0 0500 00A0"
	$"0500 00A0 04FF FF20 0400 0020 07FF FFE0"
	$"0400 0020 0999 9990 1000 0008 2667 E664"
	$"4000 0002 FFFF FFFF 8000 0001 FFFF FFFF"
};

data 'mstr' (100, purgeable) {
	$"0746 6963 6869 6572"                                /* .Fichier */
};

data 'mstr' (101, purgeable) {
	$"0751 7569 7474 6572"                                /* .Quitter */
};

data 'mstr' (102, purgeable) {
	$"0746 6963 6869 6572"                                /* .Fichier */
};

data 'mstr' (103, purgeable) {
	$"104F 7576 7269 7220 756E 208E 6372 616E"            /* .Ouvrir un écran */
	$"C9"                                                 /* … */
};

resource 'MBAR' (128, purgeable) {
	{	/* array MenuArray: 5 elements */
		/* [1] */
		256,
		/* [2] */
		257,
		/* [3] */
		258,
		/* [4] */
		261,
		/* [5] */
		262
	}
};

resource 'MBAR' (129, purgeable) {
	{	/* array MenuArray: 6 elements */
		/* [1] */
		256,
		/* [2] */
		257,
		/* [3] */
		130,
		/* [4] */
		261,
		/* [5] */
		259,
		/* [6] */
		260
	}
};

resource 'ALRT' (259, "Sauver ?") {
	{100, 100, 242, 410},
	259,
	{	/* array: 4 elements */
		/* [1] */
		OK, visible, silent,
		/* [2] */
		OK, visible, silent,
		/* [3] */
		OK, visible, silent,
		/* [4] */
		OK, visible, sound1
	}
};

resource 'ALRT' (302, "Disquette vérouillée", purgeable) {
	{86, 80, 186, 312},
	302,
	{	/* array: 4 elements */
		/* [1] */
		OK, visible, sound1,
		/* [2] */
		OK, visible, sound1,
		/* [3] */
		OK, visible, sound1,
		/* [4] */
		OK, visible, sound1
	}
};

resource 'ALRT' (10000) {
	{44, 46, 248, 308},
	10000,
	{	/* array: 4 elements */
		/* [1] */
		OK, visible, sound1,
		/* [2] */
		OK, visible, sound1,
		/* [3] */
		OK, visible, sound1,
		/* [4] */
		OK, visible, sound1
	}
};

resource 'ALRT' (260, "Modem ?") {
	{90, 132, 184, 308},
	1260,
	{	/* array: 4 elements */
		/* [1] */
		OK, visible, sound1,
		/* [2] */
		OK, visible, sound1,
		/* [3] */
		OK, visible, sound1,
		/* [4] */
		OK, visible, sound1
	}
};

data 'FREF' (129) {
	$"5043 4F4D 0005 7F"                                  /* PCOM... */
};

resource 'FREF' (128) {
	'DEXT',
	5,
	""
};

data 'FREF' (130) {
	$"5043 4F4D 0005 01"                                  /* PCOM... */
};

resource 'FREF' (256) {
	'APPL',
	0,
	""
};

resource 'FREF' (257) {
	'VCOD',
	1,
	""
};

resource 'FREF' (258) {
	'TEXT',
	2,
	""
};

resource 'FREF' (259) {
	'FONT',
	3,
	""
};

resource 'FREF' (260) {
	'RSRC',
	4,
	""
};

resource 'icl8' (257) {
	$"0000 0000 0000 0000 0000 0000 0000 0000"
	$"0000 0000 0000 0000 0000 0000 0000 0000"
	$"0000 0000 0000 0000 0000 0000 0000 0000"
	$"0000 0000 0000 0000 0000 0000 0000 0000"
	$"0000 0000 0000 0000 0000 0000 0000 0000"
	$"0000 0000 0000 0000 0000 0000 0000 0000"
	$"0000 0000 0000 0000 0000 0000 0000 0000"
	$"0000 0000 0000 0000 0000 0000 0000 0000"
	$"0000 0000 0000 0000 0000 0000 0000 0000"
	$"0000 0000 0000 0000 0000 0000 0000 0000"
	$"0000 0000 0000 0000 0000 0000 0000 0000"
	$"0000 0000 0000 0000 0000 0000 0000 0000"
	$"0000 0000 0000 0000 0000 0000 0000 0000"
	$"0000 0000 0000 0000 0000 0000 0000 0000"
	$"0000 0000 0000 0000 0000 0000 0000 0000"
	$"0000 0000 0000 0000 0000 0000 0000 0000"
	$"0000 0000 0000 00FF FFFF FFFF FFFF FFFF"
	$"FFFF FFFF FFFF FFFF FF00 0000 0000 0000"
	$"0000 0000 0000 FF33 3333 3333 3333 3333"
	$"3333 3333 3333 3333 33FF 0000 0000 0000"
	$"0000 0000 00FF 3333 FBFB FBFB FBFB FBFB"
	$"FBFB FBFB FBFB FBFB 3333 FF00 0000 0000"
	$"0000 0000 00FF 33FB 2A2A 2A2A 2A2A 2A2A"
	$"2A2A 2A2A 2A2A 2A2A F533 FF00 0000 0000"
	$"0000 0000 00FF 33FB 2A7F 7F7F 7F7F 7F7F"
	$"7F7F 2A2A 2A2A 2A2A F533 FF00 0000 0000"
	$"0000 0000 00FF 33FB 2A2A 2A2A 2A2A 2A2A"
	$"2A2A 2A2A 2A2A 2A2A F533 FF00 0000 0000"
	$"0000 0000 00FF 33FB 2A7F 7F2A 7F7F 7F7F"
	$"2A2A 2A2A 2A2A 2A2A F533 FF00 0000 0000"
	$"0000 0000 00FF 33FB 2A2A 2A2A 2A2A 2A2A"
	$"2A2A 2A2A 2A2A 2A2A F533 FF00 0000 0000"
	$"0000 0000 00FF 33FB 2A7F 7F7F 7F7F 7F7F"
	$"7F7F 7F7F 2A2A 2A2A F533 FF00 0000 0000"
	$"0000 0000 00FF 33FB 2A2A 2A2A 2A2A 2A2A"
	$"2A2A 2A2A 2A2A 2A2A F533 FF00 0000 0000"
	$"0000 0000 00FF 33FB 2A7F 7F2A 7F7F 2A7F"
	$"7F7F 7F7F 2A2A 2A2A F533 FF00 0000 0000"
	$"0000 0000 00FF 33FB 2A2A 2A2A 2A2A 2A2A"
	$"2A2A 2A2A 2A2A 2A2A F533 FF00 0000 0000"
	$"0000 0000 00FF 33FB 2A2A 2A2A 2A2A 2A2A"
	$"2A2A 2A2A 2A2A 2AF5 F533 FF00 0000 0000"
	$"0000 0000 00FF 3333 F5F5 F5F5 F5F5 F5F5"
	$"F5F5 F5F5 F5F5 F5F5 3333 FF00 0000 0000"
	$"0000 0000 00FF 3333 3333 3333 3333 3333"
	$"3333 3333 3333 3333 3333 FF00 0000 0000"
	$"0000 0000 00FF FFFF FFFF FFFF FFFF FFFF"
	$"FFFF FFFF FFFF FFFF FFFF FF00 0000 0000"
	$"0000 0000 00FF 3333 3333 3333 3333 3333"
	$"3333 3333 3333 3333 3333 FF00 0000 0000"
	$"0000 0000 FF33 33FF FF33 33FF FF33 33FF"
	$"FF33 33FF FF33 33FF FF33 33FF 0000 0000"
	$"0000 00FF 3333 3333 3333 3333 3333 3333"
	$"3333 3333 3333 3333 3333 3333 FF00 0000"
	$"0000 FF33 33FF FF33 33FF FF33 33FF FFFF"
	$"FFFF FF33 33FF FF33 33FF FF33 33FF 0000"
	$"00FF 3333 3333 3333 3333 3333 3333 3333"
	$"3333 3333 3333 3333 3333 3333 3333 FF00"
	$"FFFF FFFF FFFF FFFF FFFF FFFF FFFF FFFF"
	$"FFFF FFFF FFFF FFFF FFFF FFFF FFFF FFFF"
	$"FF08 0808 0808 0808 0808 0808 0808 0808"
	$"0808 0808 0808 0808 0808 0808 0808 08FF"
	$"FFFF FFFF FFFF FFFF FFFF FFFF FFFF FFFF"
	$"FFFF FFFF FFFF FFFF FFFF FFFF FFFF FFFF"
};

resource 'icl8' (128) {
	$"0000 0000 0000 0000 0000 0000 0000 0000"
	$"0000 0000 0000 0000 0000 0000 0000 0000"
	$"0000 0000 0000 0000 0000 0000 0000 0000"
	$"0000 0000 0000 0000 0000 0000 0000 0000"
	$"0000 0000 0000 0000 0000 00EC ECEC ECEC"
	$"ECEC 0000 0000 0000 0000 0000 0000 0000"
	$"0000 0000 0000 0000 0000 ECEC ECEC ECEC"
	$"EC00 EC00 0000 0000 0000 0000 0000 0000"
	$"0000 0000 0000 0000 00EC ECEC ECEC ECEC"
	$"0000 EC00 0000 0000 0000 0000 0000 0000"
	$"0000 0000 0000 0000 ECEC ECEC ECEC EC00"
	$"EC00 EC00 0000 0000 0000 0000 0000 0000"
	$"0000 0000 0000 00EC ECEC ECEC ECEC 0000"
	$"EC00 0000 0000 0000 0000 0000 0000 0000"
	$"0000 0000 0000 ECEC ECEC ECEC EC00 EC00"
	$"EC00 0000 0000 0000 0000 0000 0000 0000"
	$"0000 0000 00EC ECEC ECEC ECEC FFFF ECFF"
	$"FFFF FFFF FFFF FFFF FF00 0000 0000 0000"
	$"0000 0000 ECEC ECEC ECEC EC33 EC33 EC33"
	$"3333 3333 3333 3333 33FF 0000 0000 0000"
	$"0000 0000 ECEC ECEC ECEC FBFB ECFB FBFB"
	$"FBFB FBFB FBFB FBFB 3333 FF00 0000 0000"
	$"0000 00EC 00FF 3333 FB2A EC2A EC2A 2A2A"
	$"2A2A 2A2A 2A2A 2A2A F533 FF00 0000 0000"
	$"0000 00EC 00FF 33FB 2A2A EC2A 2A2A 2A2A"
	$"2A2A 2A2A 2A2A 2A2A F533 FF00 0000 0000"
	$"0000 00EC 00FF 33FB 2A2A EC2A 2A2A 2A2A"
	$"2A2A 2A2A 2A2A 2A2A F533 FF00 0000 0000"
	$"0000 0000 00FF 33FB 2A2A 2A2A 2A2A 2A2A"
	$"2A2A 2A2A 2A2A 2A2A F533 FF00 0000 0000"
	$"0000 0000 00FF 33FB 2A2A 2A2A 2A2A 2A2A"
	$"2A2A 2A2A 2A2A 2A2A F533 FF00 0000 0000"
	$"0000 0000 00FF 33FB 2A2A 2A2A 2A2A 2A2A"
	$"2A2A 2A2A 2A2A 2A2A F533 FF00 0000 0000"
	$"0000 0000 00FF 33FB 2A2A 2A2A 2A2A 2A2A"
	$"2A2A 2A2A 2A2A 2A2A F533 FF00 0000 0000"
	$"0000 0000 00FF 33FB 2A2A 2A2A 2A2A 2A2A"
	$"2A2A 2A2A 2A2A 2A2A F533 FF00 0000 0000"
	$"0000 0000 00FF 33FB 2A2A 2A2A 2A2A 2A2A"
	$"2A2A 2A2A 2A2A 2A2A F533 FF00 0000 0000"
	$"0000 0000 00FF 33FB 2A2A 2A2A 2A2A 2A2A"
	$"2A2A 2A2A 2A2A 2AF5 F533 FF00 0000 0000"
	$"0000 0000 00FF 3333 F5F5 F5F5 F5F5 F5F5"
	$"F5F5 F5F5 F5F5 F5F5 3333 FF00 0000 0000"
	$"0000 0000 00FF 3333 3333 3333 3333 3333"
	$"3333 3333 3333 3333 3333 FF00 0000 0000"
	$"0000 0000 00FF FFFF FFFF FFFF FFFF FFFF"
	$"FFFF FFFF FFFF FFFF FFFF FF00 0000 0000"
	$"0000 0000 00FF 3333 3333 3333 3333 3333"
	$"3333 3333 3333 3333 3333 FF00 0000 0000"
	$"0000 0000 FF33 33FF FF33 33FF FF33 33FF"
	$"FF33 33FF FF33 33FF FF33 33FF 0000 0000"
	$"0000 00FF 3333 3333 3333 3333 3333 3333"
	$"3333 3333 3333 3333 3333 3333 FF00 0000"
	$"0000 FF33 33FF FF33 33FF FF33 33FF FFFF"
	$"FFFF FF33 33FF FF33 33FF FF33 33FF 0000"
	$"00FF 3333 3333 3333 3333 3333 3333 3333"
	$"3333 3333 3333 3333 3333 3333 3333 FF00"
	$"FFFF FFFF FFFF FFFF FFFF FFFF FFFF FFFF"
	$"FFFF FFFF FFFF FFFF FFFF FFFF FFFF FFFF"
	$"FF08 0808 0808 0808 0808 0808 0808 0808"
	$"0808 0808 0808 0808 0808 0808 0808 08FF"
	$"FFFF FFFF FFFF FFFF FFFF FFFF FFFF FFFF"
	$"FFFF FFFF FFFF FFFF FFFF FFFF FFFF FFFF"
};

resource 'icl8' (129) {
	$"0000 0000 FF00 FF00 FF00 FF00 FF00 FF00"
	$"FF00 FF00 FF00 FF00 FF00 0000 0000 0000"
	$"0000 0000 00FF 002A 002A 002A 002A 002A"
	$"002A 002A 002A 002A 00FF 0000 0000 0000"
	$"0000 FF00 7F00 2A00 2A00 2A00 2A00 2A00"
	$"2A00 2A00 2A00 2A00 2A00 0000 0000 0000"
	$"0000 007F 00FF 002A 00FF 002A 00FF 002A"
	$"00FF 002A 00FF 002A 00FF 0000 0000 0000"
	$"FF00 FF00 7F00 2A00 2A00 2A00 2A00 2A00"
	$"2A00 2A00 2A00 2A00 2A00 0000 0000 0000"
	$"002A 00FF 00FF 002A 002A 00FF 002A 002A"
	$"002A 002A 00FF 002A 00FF 0000 0000 0000"
	$"FF00 2A00 2A00 2A00 2A00 2A00 2A00 2A00"
	$"2A00 2A00 2A00 2A00 2A00 0000 0000 0000"
	$"002A 00FF 002A 002A FF2A 00FF 002A FF2A"
	$"002A FF2A 00FF 002A 00FF 0000 0000 0000"
	$"FF00 2A00 2A00 2AFF FFFF FFFF FFFF FFFF"
	$"FFFF FFFF FFFF FFFF FFFF 0000 0000 0000"
	$"002A 00FF 002A FF33 3333 3333 3333 3333"
	$"3333 3333 3333 3333 33FF 0000 0000 0000"
	$"FF00 2A00 2AFF 3333 FBFB FBFB FBFB FBFB"
	$"FBFB FBFB FBFB FBFB 3333 FF00 0000 0000"
	$"002A 002A 00FF 33FB 2A2A 2A2A 2A2A 2A2A"
	$"2A2A 2A2A 2A2A 2A2A F533 FF00 0000 0000"
	$"FF00 2A00 2AFF 33FB 2A2A 2A2A 2A2A 2A2A"
	$"2A2A 2A2A 2A2A 2A2A F533 FF00 0000 0000"
	$"002A 00FF 00FF 33FB 2A2A 2A2A 2A2A 2A2A"
	$"2A2A 2A2A 2A2A 2A2A F533 FF00 0000 0000"
	$"FF00 FF00 FFFF 33FB 2A2A 2A2A 2A2A 2A2A"
	$"2A2A 2A2A 2A2A 2A2A F533 FF00 0000 0000"
	$"002A 002A 00FF 33FB 2A2A 2A2A 2A2A 2A2A"
	$"2A2A 2A2A 2A2A 2A2A F533 FF00 0000 0000"
	$"FF00 2AFF 2AFF 33FB 2A2A 2A2A 2A2A 2A2A"
	$"2A2A 2A2A 2A2A 2A2A F533 FF00 0000 0000"
	$"002A 002A 00FF 33FB 2A2A 2A2A 2A2A 2A2A"
	$"2A2A 2A2A 2A2A 2A2A F533 FF00 0000 0000"
	$"FF00 2A00 2AFF 33FB 2A2A 2A2A 2A2A 2A2A"
	$"2A2A 2A2A 2A2A 2A2A F533 FF00 0000 0000"
	$"002A 00FF 00FF 33FB 2A2A 2A2A 2A2A 2A2A"
	$"2A2A 2A2A 2A2A 2A2A F533 FF00 0000 0000"
	$"FF00 2A00 2AFF 33FB 2A2A 2A2A 2A2A 2A2A"
	$"2A2A 2A2A 2A2A 2AF5 F533 FF00 0000 0000"
	$"002A 00FF 00FF 3333 F5F5 F5F5 F5F5 F5F5"
	$"F5F5 F5F5 F5F5 F5F5 3333 FF00 0000 0000"
	$"FF00 2A00 2AFF 3333 3333 3333 3333 3333"
	$"3333 3333 3333 3333 3333 FF00 0000 0000"
	$"002A 002A 00FF FFFF FFFF FFFF FFFF FFFF"
	$"FFFF FFFF FFFF FFFF FFFF FF00 0000 0000"
	$"FF00 2A00 2AFF 3333 3333 3333 3333 3333"
	$"3333 3333 3333 3333 3333 FF00 0000 0000"
	$"002A 002A FF33 33FF FF33 33FF FF33 33FF"
	$"FF33 33FF FF33 33FF FF33 33FF 0000 0000"
	$"FF00 2AFF 3333 3333 3333 3333 3333 3333"
	$"3333 3333 3333 3333 3333 3333 FF00 0000"
	$"002A FF33 33FF FF33 33FF FF33 33FF FFFF"
	$"FFFF FF33 33FF FF33 33FF FF33 33FF 0000"
	$"FFFF 3333 3333 3333 3333 3333 3333 3333"
	$"3333 3333 3333 3333 3333 3333 3333 FF00"
	$"FFFF FFFF FFFF FFFF FFFF FFFF FFFF FFFF"
	$"FFFF FFFF FFFF FFFF FFFF FFFF FFFF FFFF"
	$"FF08 0808 0808 0808 0808 0808 0808 0808"
	$"0808 0808 0808 0808 0808 0808 0808 08FF"
	$"FFFF FFFF FFFF FFFF FFFF FFFF FFFF FFFF"
	$"FFFF FFFF FFFF FFFF FFFF FFFF FFFF FFFF"
};

resource 'icl8' (256) {
	$"0000 0000 0000 0000 0000 0000 0000 0000"
	$"0000 0000 0000 0000 0000 0000 ECEC 0000"
	$"0000 0000 0000 0000 0000 0000 0000 0000"
	$"0000 0000 0000 0000 0000 00EC ECEC 0000"
	$"0000 0000 0000 0000 0000 0000 0000 0000"
	$"0000 0000 0000 0000 0000 ECEC ECEC 0000"
	$"0000 0000 0000 0000 0000 0000 0000 0000"
	$"0000 0000 0000 0000 00EC ECEC EC00 0000"
	$"0000 0000 0000 0000 0000 0000 0000 0000"
	$"0000 0000 0000 0000 ECEC ECEC 0000 0000"
	$"0000 0000 0000 0000 0000 0000 0000 0000"
	$"0000 0000 0000 00EC ECEC ECEC 0000 0000"
	$"0000 0000 0000 0000 0000 0000 0000 0000"
	$"0000 0000 0000 ECEC ECEC EC00 0000 0000"
	$"0000 0000 0000 0000 0000 0000 0000 0000"
	$"0000 0000 0000 ECEC ECEC 0000 0000 0000"
	$"0000 0000 0000 00FF FFFF FFFF FFFF FFFF"
	$"FFFF FFFF FFEC ECEC EC00 0000 0000 0000"
	$"0000 0000 0000 FF33 3333 3333 3333 3333"
	$"3333 3333 ECEC ECEC 33FF 0000 0000 0000"
	$"0000 0000 00FF 3333 FBFB FBFB FBFB FBFB"
	$"FBFB FBEC ECEC ECFB 3333 FF00 0000 0000"
	$"0000 0000 00FF 33FB FB2A 2A2A 2A2A 2A2A"
	$"2A2A 2AEC ECEC 2A2A F533 FF00 0000 0000"
	$"0000 0000 00FF 33FB 2A2A 2A2A 2A2A 2A2A"
	$"2A2A ECEC ECEC 2A2A F533 FF00 0000 0000"
	$"0000 0000 00FF 33FB 2A2A 2A2A 2A2A 2A2A"
	$"2A2A ECEC EC2A 2A2A F533 FF00 0000 0000"
	$"0000 0000 00FF 33FB 2A2A 2A2A 2A2A 2A2A"
	$"2A2A ECEC 2A2A 2A2A F533 FF00 0000 0000"
	$"0000 0000 00FF 33FB 2A2A 2A2A 2A2A 2A2A"
	$"2A2A ECEC 2A2A 2A2A F533 FF00 0000 0000"
	$"0000 0000 00FF 33FB 2A2A 2A2A 2A2A 2A2A"
	$"2A2A EC2A 2A2A 2A2A F533 FF00 0000 0000"
	$"0000 0000 00FF 33FB 2A2A 2A2A 2A2A 2A2A"
	$"2A2A EC2A 2A2A 2A2A F533 FF00 0000 0000"
	$"0000 0000 00FF 33FB 2A2A 2A2A 2A2A 2A2A"
	$"2A2A EC2A 2A2A 2A2A F533 FF00 0000 0000"
	$"0000 0000 00FF 33FB 2A2A 2A2A 2A2A 2A2A"
	$"2A2A 2A2A 2A2A 2A2A F533 FF00 0000 0000"
	$"0000 0000 00FF 33FB 2A2A 2A2A 2A2A 2A2A"
	$"2A2A 2A2A 2A2A 2AF5 F533 FF00 0000 0000"
	$"0000 0000 00FF 3333 F5F5 F5F5 F5F5 F5F5"
	$"F5F5 F5F5 F5F5 F5F5 3333 FF00 0000 0000"
	$"0000 0000 00FF 3333 3333 3333 3333 3333"
	$"3333 3333 3333 3333 3333 FF00 0000 0000"
	$"0000 0000 00FF FFFF FFFF FFFF FFFF FFFF"
	$"FFFF FFFF FFFF FFFF FFFF FF00 0000 0000"
	$"0000 0000 00FF 3333 3333 3333 3333 3333"
	$"3333 3333 3333 3333 3333 FF00 0000 0000"
	$"0000 0000 FF33 33FF FF33 33FF FF33 33FF"
	$"FF33 33FF FF33 33FF FF33 33FF 0000 0000"
	$"0000 00FF 3333 3333 3333 3333 3333 3333"
	$"3333 3333 3333 3333 3333 3333 FF00 0000"
	$"0000 FF33 33FF FF33 33FF FF33 33FF FFFF"
	$"FFFF FF33 33FF FF33 33FF FF33 33FF 0000"
	$"00FF 3333 3333 3333 3333 3333 3333 3333"
	$"3333 3333 3333 3333 3333 3333 3333 FF00"
	$"FFFF FFFF FFFF FFFF FFFF FFFF FFFF FFFF"
	$"FFFF FFFF FFFF FFFF FFFF FFFF FFFF FFFF"
	$"FF08 0808 0808 0808 0808 0808 0808 0808"
	$"0808 0808 0808 0808 0808 0808 0808 08FF"
	$"FFFF FFFF FFFF FFFF FFFF FFFF FFFF FFFF"
	$"FFFF FFFF FFFF FFFF FFFF FFFF FFFF FFFF"
};

resource 'ics#' (257) {
	{	/* array: 2 elements */
		/* [1] */
		$"0000 0000 0000 0000 1FF8 3FFC 3F0C 3FCC"
		$"3F6C 3FEC 3FFC 3FFC 3FFC 7FFE FFFF FFFF",
		/* [2] */
		$"0000 0000 0000 0000 1FF8 3FFC 3FFC 3FFC"
		$"3FFC 3FFC 3FFC 3FFC 3FFC 7FFE FFFF FFFF"
	}
};

resource 'ics#' (256) {
	{	/* array: 2 elements */
		/* [1] */
		$"0006 000E 001C 001C 1FF8 3FFC 337C 335C"
		$"3B7C 3FFC 3FFC 3FFC 3FFC 7FFE FFFF FFFF",
		/* [2] */
		$"0006 000E 001C 001C 1FF8 3FFC 3FFC 3FFC"
		$"3FFC 3FFC 3FFC 3FFC 3FFC 7FFE FFFF FFFF"
	}
};

resource 'ics#' (258) {
	{	/* array: 2 elements */
		/* [1] */
		$"0000 0000 0000 0000 1FF8 3FFC 3FFC 3FFC"
		$"3FFC 3FFC 3FFC 3FFC 3FFC 7FFE FFFF FFFF",
		/* [2] */
		$"0000 0000 0000 0000 1FF8 3FFC 3FFC 3FFC"
		$"3FFC 3FFC 3FFC 3FFC 3FFC 7FFE FFFF FFFF"
	}
};

resource 'ics#' (128) {
	{	/* array: 2 elements */
		/* [1] */
		$"0000 07C0 0FC0 1F80 3FF8 7FFC 7FFC 3FFC"
		$"3FFC 3FFC 3FFC 3FFC 3FFC 7FFE FFFF FFFF",
		/* [2] */
		$"0000 07C0 0FC0 1F80 3FF8 7FFC 7FFC 3FFC"
		$"3FFC 3FFC 3FFC 3FFC 3FFC 7FFE FFFF FFFF"
	}
};

resource 'ics8' (257) {
	$"0000 0000 0000 0000 0000 0000 0000 0000"
	$"0000 0000 0000 0000 0000 0000 0000 0000"
	$"0000 0000 0000 0000 0000 0000 0000 0000"
	$"0000 0000 0000 0000 0000 0000 0000 0000"
	$"0000 00FF FFFF FFFF FFFF FFFF FF00 0000"
	$"0000 FFFB FBFB FBFB FBFB FBFB F5FF 0000"
	$"0000 FFFB 7F7F 7F7F 7F2A 2A2A F5FF 0000"
	$"0000 FFFB 7F7F 7F7F 2A2A 2A2A F5FF 0000"
	$"0000 FFFB 7F7F 7F7F 7F7F 2A2A F5FF 0000"
	$"0000 FFFB 7F7F 7F7F 7F7F 2A2A F5FF 0000"
	$"0000 FFFB F5F5 F5F5 F5F5 F5F5 F5FF 0000"
	$"0000 FFFF FFFF FFFF FFFF FFFF FFFF 0000"
	$"0000 FFFF FFFF FFFF FFFF FFFF FFFF 0000"
	$"00FF FFFF FFFF FFFF FFFF FFFF FFFF FF00"
	$"FFFF FFFF FFFF FFFF FFFF FFFF FFFF FFFF"
	$"FFFF FFFF FFFF FFFF FFFF FFFF FFFF FFFF"
};

resource 'ics8' (256) {
	$"0000 0000 0000 0000 0000 0000 00EC EC00"
	$"0000 0000 0000 0000 0000 0000 ECEC EC00"
	$"0000 0000 0000 0000 0000 00EC ECEC 0000"
	$"0000 0000 0000 0000 0000 00EC ECEC 0000"
	$"0000 00FF FFFF FFFF FFFF FFEC FF00 0000"
	$"0000 FFFB FBFB FBFB FBFB ECFB F5FF 0000"
	$"0000 FFFB 2A2A 2A2A 2AEC EC2A F5FF 0000"
	$"0000 FFFB 2A2A 2A2A ECEC 2A2A F5FF 0000"
	$"0000 FFFB 2A2A 2A2A ECEC 2A2A F5FF 0000"
	$"0000 FFFB 2A2A 2A2A EC2A 2A2A F5FF 0000"
	$"0000 FFFB F5F5 F5F5 F5F5 F5F5 F5FF 0000"
	$"0000 FFFF FFFF FFFF FFFF FFFF FFFF 0000"
	$"0000 FFFF FFFF FFFF FFFF FFFF FFFF 0000"
	$"00FF FFFF FFFF FFFF FFFF FFFF FFFF FF00"
	$"FFFF FFFF FFFF FFFF FFFF FFFF FFFF FFFF"
	$"FFFF FFFF FFFF FFFF FFFF FFFF FFFF FFFF"
};

resource 'ics8' (128) {
	$"0000 0000 0000 0000 0000 0000 0000 0000"
	$"0000 0000 00EC ECEC ECEC 0000 0000 0000"
	$"0000 0000 ECEC ECEC ECEC 0000 0000 0000"
	$"0000 00EC ECEC ECEC EC00 0000 0000 0000"
	$"0000 ECEC ECEC FFFF FFFF FFFF FF00 0000"
	$"00EC FFEC FBFB FBFB FBFB FBFB F5FF 0000"
	$"00EC FFFB 2AEC 2A2A 2A2A 2A2A F5FF 0000"
	$"0000 FFFB 2A2A 2A2A 2A2A 2A2A F5FF 0000"
	$"0000 FFFB 2A2A 2A2A 2A2A 2A2A F5FF 0000"
	$"0000 FFFB 2A2A 2A2A 2A2A 2A2A F5FF 0000"
	$"0000 FFFB F5F5 F5F5 F5F5 F5F5 F5FF 0000"
	$"0000 FFFF FFFF FFFF FFFF FFFF FFFF 0000"
	$"0000 FFFF FFFF FFFF FFFF FFFF FFFF 0000"
	$"00FF FFFF FFFF FFFF FFFF FFFF FFFF FF00"
	$"FFFF FFFF FFFF FFFF FFFF FFFF FFFF FFFF"
	$"FFFF FFFF FFFF FFFF FFFF FFFF FFFF FFFF"
};

data 'hmnu' (256, "Apple") {
	$"0002 0000 0000 0000 0000 0002 0004 0100"            /* ................ */
	$"0014 0003 0000 0000 0000 0000 0000 0000"            /* ................ */
	$"0000 0000 0014 0003 F448 0001 FFFF 0000"            /* .........H...... */
	$"FFFF 0000 FFFF 0000"                                /* ........ */
};

data 'hmnu' (262, "Basic") {
	$"0002 0000 0000 0000 0000 000C 0004 0100"            /* ................ */
	$"0014 0003 F448 0002 F448 0003 FFFF 0000"            /* .....H...H...... */
	$"FFFF 0000 0014 0003 F448 0004 F448 0005"            /* .........H...H.. */
	$"FFFF 0000 FFFF 0000 0014 0003 F448 0006"            /* .............H.. */
	$"F448 0007 FFFF 0000 FFFF 0000 0004 0100"            /* .H.............. */
	$"0014 0003 F448 0008 F448 0009 FFFF 0000"            /* .....H...H.Δ.... */
	$"FFFF 0000 0014 0003 F448 000A F448 000B"            /* .........H...H.. */
	$"FFFF 0000 FFFF 0000 0004 0100 0014 0003"            /* ................ */
	$"F448 000C FFFF 0000 F448 000D FFFF 0000"            /* .H.......H.¬.... */
	$"0014 0003 F448 000E FFFF 0000 F448 000F"            /* .....H.......H.. */
	$"FFFF 0000 0004 0100 0014 0003 F448 0010"            /* .............H.. */
	$"FFFF 0000 FFFF 0000 FFFF 0000 0014 0003"            /* ................ */
	$"F448 0011 FFFF 0000 FFFF 0000 FFFF 0000"            /* .H.............. */
};

data 'hmnu' (258, "Edition") {
	$"0002 0000 0000 0000 0000 000D 0004 0100"            /* ...........¬.... */
	$"0014 0003 F448 0012 F448 0013 FFFF 0000"            /* .....H...H...... */
	$"FFFF 0000 0014 0003 F448 0014 F448 0015"            /* .........H...H.. */
	$"FFFF 0000 FFFF 0000 0004 0100 0014 0003"            /* ................ */
	$"F448 0016 F448 0017 FFFF 0000 FFFF 0000"            /* .H...H.......... */
	$"0014 0003 F448 0018 F448 0019 FFFF 0000"            /* .....H...H...... */
	$"FFFF 0000 0014 0003 F448 001A F448 001B"            /* .........H...H.. */
	$"FFFF 0000 FFFF 0000 0014 0003 F448 001C"            /* .............H.. */
	$"F448 001D FFFF 0000 FFFF 0000 0014 0003"            /* .H.............. */
	$"F448 001E F448 001F FFFF 0000 FFFF 0000"            /* .H...H.......... */
	$"0004 0100 0014 0003 F448 0020 F448 0021"            /* .........H. .H.! */
	$"FFFF 0000 FFFF 0000 0014 0003 F448 0022"            /* .............H." */
	$"F448 0023 FFFF 0000 FFFF 0000 0014 0003"            /* .H.#............ */
	$"F448 0024 F448 0025 FFFF 0000 FFFF 0000"            /* .H.$.H.%........ */
	$"0014 0003 F448 0026 F448 0027 FFFF 0000"            /* .....H.&.H.'.... */
	$"FFFF 0000"                                          /* .... */
};

data 'hmnu' (261, "Fenêtres") {
	$"0002 0000 0000 0000 0000 0006 0014 0003"            /* ................ */
	$"F448 0028 FFFF 0000 FFFF 0000 FFFF 0000"            /* .H.(............ */
	$"0014 0003 F448 0029 F448 002A FFFF 0000"            /* .....H.).H.*.... */
	$"FFFF 0000 0014 0003 F448 002B FFFF 0000"            /* .........H.+.... */
	$"F448 002C FFFF 0000 0014 0003 F448 002D"            /* .H.,.........H.- */
	$"FFFF 0000 F448 002E FFFF 0000 0004 0100"            /* .....H.......... */
	$"0014 0003 F448 002F FFFF 0000 F448 0030"            /* .....H./.....H.0 */
	$"FFFF 0000 0014 0003 F448 0031 FFFF 0000"            /* .........H.1.... */
	$"FFFF 0000 FFFF 0000"                                /* ........ */
};

data 'hmnu' (257, "Fichier") {
	$"0002 0000 0000 0000 0000 0013 0004 0100"            /* ................ */
	$"0014 0003 F448 0032 F449 0001 FFFF 0000"            /* .....H.2.I...... */
	$"FFFF 0000 0014 0003 F449 0002 F449 0003"            /* .........I...I.. */
	$"FFFF 0000 FFFF 0000 0014 0003 F449 0004"            /* .............I.. */
	$"F449 0005 FFFF 0000 FFFF 0000 0014 0003"            /* .I.............. */
	$"F449 0006 F449 0007 FFFF 0000 FFFF 0000"            /* .I...I.......... */
	$"0014 0003 F449 0008 F449 0009 FFFF 0000"            /* .....I...I.Δ.... */
	$"FFFF 0000 0014 0003 F449 000A F449 000B"            /* .........I...I.. */
	$"FFFF 0000 FFFF 0000 0014 0003 F449 000C"            /* .............I.. */
	$"F449 000D FFFF 0000 FFFF 0000 0014 0003"            /* .I.¬............ */
	$"F449 000E F449 000F FFFF 0000 FFFF 0000"            /* .I...I.......... */
	$"0004 0100 0014 0003 F449 0010 F449 0011"            /* .........I...I.. */
	$"FFFF 0000 FFFF 0000 0004 0100 0014 0003"            /* ................ */
	$"F449 0012 F449 0013 FFFF 0000 FFFF 0000"            /* .I...I.......... */
	$"0004 0100 0014 0003 F449 0014 FFFF 0000"            /* .........I...... */
	$"FFFF 0000 FFFF 0000 0014 0003 F449 0015"            /* .............I.. */
	$"FFFF 0000 FFFF 0000 FFFF 0000 0004 0100"            /* ................ */
	$"0014 0003 F449 0016 FFFF 0000 FFFF 0000"            /* .....I.......... */
	$"FFFF 0000 0004 0100 0014 0003 F449 0017"            /* .............I.. */
	$"FFFF 0000 FFFF 0000 FFFF 0000"                      /* ............ */
};

data 'hdlg' (-3000, "Chercher") {
	$"0002 0000 0000 0008 0000 0000 0006 0004"            /* ................ */
	$"0100 0020 0003 0000 0000 0000 0000 0000"            /* ... ............ */
	$"0000 F449 0018 FFFF 0000 FFFF 0000 FFFF"            /* ...I............ */
	$"0000 0020 0003 0000 0000 0000 0000 0000"            /* ... ............ */
	$"0000 F449 0019 FFFF 0000 FFFF 0000 FFFF"            /* ...I............ */
	$"0000 0020 0003 0000 0000 0000 0000 0010"            /* ... ............ */
	$"00E3 F449 001A FFFF 0000 FFFF 0000 FFFF"            /* ...I............ */
	$"0000 0020 0003 0000 0000 0000 0000 0000"            /* ... ............ */
	$"0000 F449 001B FFFF 0000 F449 001C FFFF"            /* ...I.......I.... */
	$"0000 0020 0003 0000 0000 0000 0000 0000"            /* ... ............ */
	$"0000 F449 001D FFFF 0000 F449 001E F449"            /* ...I.......I...I */
	$"001F 0020 0003 0000 0000 0000 0000 0000"            /* ... ............ */
	$"0000 F449 0020 FFFF 0000 F449 0021 FFFF"            /* ...I. .....I.!.. */
	$"0000"                                               /* .. */
};

data 'hdlg' (-2999, "Config") {
	$"0002 0000 0000 0008 0000 0000 0006 0004"            /* ................ */
	$"0100 0020 0003 0000 0000 0000 0000 0000"            /* ... ............ */
	$"0000 F449 0022 FFFF 0000 FFFF 0000 FFFF"            /* ...I.".......... */
	$"0000 0020 0003 0000 0000 0000 0000 0000"            /* ... ............ */
	$"0000 F449 0023 FFFF 0000 FFFF 0000 FFFF"            /* ...I.#.......... */
	$"0000 0020 0003 0000 0000 0000 0000 0000"            /* ... ............ */
	$"0000 F449 0024 FFFF 0000 F449 0025 FFFF"            /* ...I.$.....I.%.. */
	$"0000 0020 0003 0000 0000 0000 0000 0000"            /* ... ............ */
	$"0000 F449 0026 FFFF 0000 F449 0027 FFFF"            /* ...I.&.....I.'.. */
	$"0000 0020 0003 0000 0000 0000 0000 0000"            /* ... ............ */
	$"0000 F449 0028 F449 0029 F449 002A FFFF"            /* ...I.(.I.).I.*.. */
	$"0000 0020 0003 0000 0000 0000 0000 0000"            /* ... ............ */
	$"0000 F449 002B F449 002C F449 002D FFFF"            /* ...I.+.I.,.I.-.. */
	$"0000"                                               /* .. */
};

data 'hdlg' (-2998, "Opt. Analyse") {
	$"0002 0000 0000 0008 0000 0000 0005 0004"            /* ................ */
	$"0100 0020 0003 0000 0000 0000 0000 0000"            /* ... ............ */
	$"0000 F449 002E FFFF 0000 FFFF 0000 FFFF"            /* ...I............ */
	$"0000 0020 0003 0000 0000 0000 0000 0000"            /* ... ............ */
	$"0000 F449 002F FFFF 0000 FFFF 0000 FFFF"            /* ...I./.......... */
	$"0000 0020 0003 0000 0000 0000 0000 0000"            /* ... ............ */
	$"0000 F449 0030 FFFF 0000 F449 0031 FFFF"            /* ...I.0.....I.1.. */
	$"0000 0020 0003 0000 0000 0000 0000 0000"            /* ... ............ */
	$"0000 F449 0032 FFFF 0000 F44A 0001 FFFF"            /* ...I.2.....J.... */
	$"0000 0020 0003 0000 0000 0000 0000 0000"            /* ... ............ */
	$"0000 F44A 0002 FFFF 0000 F44A 0003 FFFF"            /* ...J.......J.... */
	$"0000"                                               /* .. */
};

data 'hdlg' (-2996, "Remplacer") {
	$"0002 0000 0000 0008 0000 0000 0007 0004"            /* ................ */
	$"0100 0020 0003 0000 0000 0000 0000 0000"            /* ... ............ */
	$"0000 F44A 0016 FFFF 0000 FFFF 0000 FFFF"            /* ...J............ */
	$"0000 0020 0003 0000 0000 0000 0000 0000"            /* ... ............ */
	$"0000 F44A 0017 FFFF 0000 FFFF 0000 FFFF"            /* ...J............ */
	$"0000 0020 0003 0000 0000 0000 0000 0000"            /* ... ............ */
	$"0000 F44A 0018 FFFF 0000 FFFF 0000 FFFF"            /* ...J............ */
	$"0000 0020 0003 0000 0000 0000 0000 0000"            /* ... ............ */
	$"0000 F44A 0019 FFFF 0000 F44A 001A FFFF"            /* ...J.......J.... */
	$"0000 0020 0003 0000 0000 0000 0000 0000"            /* ... ............ */
	$"0000 F44A 001B FFFF 0000 F44A 001C FFFF"            /* ...J.......J.... */
	$"0000 0020 0003 0000 0000 0000 0000 0000"            /* ... ............ */
	$"0000 F44A 001D FFFF 0000 F44A 001E FFFF"            /* ...J.......J.... */
	$"0000 0020 0003 0000 0000 0000 0000 0000"            /* ... ............ */
	$"0000 F44A 001F FFFF 0000 FFFF 0000 FFFF"            /* ...J............ */
	$"0000"                                               /* .. */
};

data 'hdlg' (-2991, "Opt. Compilation") {
	$"0002 0000 0000 0008 0000 0000 0009 0004"            /* .............Δ.. */
	$"0100 0020 0003 0000 0000 0000 0000 0000"            /* ... ............ */
	$"0000 F44A 0004 FFFF 0000 FFFF 0000 FFFF"            /* ...J............ */
	$"0000 0020 0003 0000 0000 0000 0000 0000"            /* ... ............ */
	$"0000 F44A 0005 FFFF 0000 FFFF 0000 FFFF"            /* ...J............ */
	$"0000 0020 0003 0000 0000 0000 0000 0000"            /* ... ............ */
	$"0000 F44A 0006 FFFF 0000 F44A 0007 FFFF"            /* ...J.......J.... */
	$"0000 0020 0003 0000 0000 0000 0000 0000"            /* ... ............ */
	$"0000 F44A 0008 FFFF 0000 F44A 0009 FFFF"            /* ...J.......J.Δ.. */
	$"0000 0020 0003 0000 0000 0000 0000 0000"            /* ... ............ */
	$"0000 F44A 000A FFFF 0000 F44A 000B FFFF"            /* ...J.......J.... */
	$"0000 0020 0003 0000 0000 0000 0000 0000"            /* ... ............ */
	$"0000 F44A 000C FFFF 0000 F44A 000D FFFF"            /* ...J.......J.¬.. */
	$"0000 0020 0003 0000 0000 0000 0000 0000"            /* ... ............ */
	$"0000 F44A 000E F44A 000F F44A 0010 FFFF"            /* ...J...J...J.... */
	$"0000 0020 0003 0000 0000 0000 0000 0000"            /* ... ............ */
	$"0000 F44A 0011 F44A 0012 F44A 0013 FFFF"            /* ...J...J...J.... */
	$"0000 0020 0003 0000 0000 0000 0000 0000"            /* ... ............ */
	$"0000 F44A 0014 FFFF 0000 F44A 0015 FFFF"            /* ...J.......J.... */
	$"0000"                                               /* .. */
};

data 'hrct' (-3000, "Erreurs / Trace système") {
	$"0002 0000 0000 0000 0000 0001 0014 0003"            /* ................ */
	$"0022 013C 0013 012D 0031 014B F44A 0020"            /* .".<...-.1.K.J.  */
};

data 'hrct' (-2999, "Minitel") {
	$"0002 0000 0000 0000 0000 0001 0014 0003"            /* ................ */
	$"0086 00E7 0005 0005 0107 01C9 F44A 0021"            /* .Ü.........….J.! */
};

data 'hrct' (-2998, "Routines externes") {
	$"0002 0000 0000 0000 0000 0001 0014 0003"            /* ................ */
	$"0090 001A 0087 0011 00BE 0149 F44A 0022"            /* .ê...á...æ.I.J." */
};

data 'hrct' (-2997, "Routines externes") {
	$"0002 0000 0000 0000 0000 0001 0014 0003"            /* ................ */
	$"007B 00BF 000F 000E 0080 00C4 F44A 0023"            /* .{.ø.....Ä.ƒ.J.# */
};

resource 'dctb' (131) {
	{	/* array ColorSpec: 5 elements */
		/* [1] */
		wContentColor, 65535, 65535, 65535,
		/* [2] */
		wFrameColor, 0, 0, 0,
		/* [3] */
		wTextColor, 0, 0, 0,
		/* [4] */
		wHiliteColor, 0, 0, 0,
		/* [5] */
		wTitleBarColor, 65535, 65535, 65535
	}
};

resource 'dctb' (260) {
	{	/* array ColorSpec: 5 elements */
		/* [1] */
		wContentColor, 65535, 65535, 65535,
		/* [2] */
		wFrameColor, 0, 0, 0,
		/* [3] */
		wTextColor, 0, 0, 0,
		/* [4] */
		wHiliteColor, 0, 0, 0,
		/* [5] */
		wTitleBarColor, 65535, 65535, 65535
	}
};

resource 'cicn' (131) {
	16,
	{0, 0, 32, 32},
	4,
	$"0000 000C 0000 001C 0000 003C 0000 0078"
	$"0000 00F0 0000 01F0 0000 03E0 0000 03C0"
	$"01FF FF80 03FF FFC0 07FF FFE0 07FF FFE0"
	$"07FF FFE0 07FF FFE0 07FF FFE0 07FF FFE0"
	$"07FF FFE0 07FF FFE0 07FF FFE0 07FF FFE0"
	$"07FF FFE0 07FF FFE0 07FF FFE0 07FF FFE0"
	$"07FF FFE0 0FFF FFF0 1FFF FFF8 3FFF FFFC"
	$"7FFF FFFE FFFF FFFF FFFF FFFF FFFF FFFF",
	$"0000 000C 0000 001C 0000 003C 0000 0078"
	$"0000 00F0 0000 01F0 0000 03E0 0000 03C0"
	$"01FF FF80 0200 0F40 04FF FF20 0580 1CA0"
	$"0500 3CA0 0500 38A0 0500 30A0 0500 30A0"
	$"0500 20A0 0500 20A0 0500 20A0 0500 00A0"
	$"0500 00A0 04FF FF20 0400 0020 07FF FFE0"
	$"0400 0020 0999 9990 1000 0008 2667 E664"
	$"4000 0002 FFFF FFFF 8000 0001 FFFF FFFF",
	{	/* array ColorSpec: 8 elements */
		/* [1] */
		0, 65535, 65535, 65535,
		/* [2] */
		1, 65535, 52428, 39321,
		/* [3] */
		2, 52428, 39321, 26214,
		/* [4] */
		3, 0, 0, 56797,
		/* [5] */
		4, 52428, 52428, 65535,
		/* [6] */
		5, 61166, 61166, 61166,
		/* [7] */
		6, 21845, 21845, 21845,
		/* [8] */
		15, 0, 0, 0
	},
	$"0000 0000 0000 0000 0000 0000 0000 3300"
	$"0000 0000 0000 0000 0000 0000 0003 3300"
	$"0000 0000 0000 0000 0000 0000 0033 3300"
	$"0000 0000 0000 0000 0000 0000 0333 3000"
	$"0000 0000 0000 0000 0000 0000 3333 0000"
	$"0000 0000 0000 0000 0000 0003 3333 0000"
	$"0000 0000 0000 0000 0000 0033 3330 0000"
	$"0000 0000 0000 0000 0000 0033 3300 0000"
	$"0000 000F FFFF FFFF FFFF F333 3000 0000"
	$"0000 00F2 2222 2222 2222 3333 2F00 0000"
	$"0000 0F22 6666 6666 6663 3336 22F0 0000"
	$"0000 0F26 6444 4444 4443 3344 52F0 0000"
	$"0000 0F26 4444 4444 4433 3344 52F0 0000"
	$"0000 0F26 4444 4444 4433 3444 52F0 0000"
	$"0000 0F26 4444 4444 4433 4444 52F0 0000"
	$"0000 0F26 4444 4444 4433 4444 52F0 0000"
	$"0000 0F26 4444 4444 4434 4444 52F0 0000"
	$"0000 0F26 4444 4444 4434 4444 52F0 0000"
	$"0000 0F26 4444 4444 4434 4444 52F0 0000"
	$"0000 0F26 4444 4444 4444 4444 52F0 0000"
	$"0000 0F26 4444 4444 4444 4445 52F0 0000"
	$"0000 0F22 5555 5555 5555 5555 22F0 0000"
	$"0000 0F22 2222 2222 2222 2222 22F0 0000"
	$"0000 0FFF FFFF FFFF FFFF FFFF FFF0 0000"
	$"0000 0F22 2222 2222 2222 2222 22F0 0000"
	$"0000 F22F F22F F22F F22F F22F F22F 0000"
	$"000F 2222 2222 2222 2222 2222 2222 F000"
	$"00F2 2FF2 2FF2 2FFF FFF2 2FF2 2FF2 2F00"
	$"0F22 2222 2222 2222 2222 2222 2222 22F0"
	$"FFFF FFFF FFFF FFFF FFFF FFFF FFFF FFFF"
	$"F111 1111 1111 1111 1111 1111 1111 111F"
	$"FFFF FFFF FFFF FFFF FFFF FFFF FFFF FFFF"
};

resource 'cicn' (130) {
	16,
	{0, 0, 32, 32},
	4,
	$"0000 0000 0000 0000 0000 0000 0000 0000"
	$"0000 0000 0000 0000 0000 0000 0000 0000"
	$"01FF FF80 03FF FFC0 07FF FFE0 07FF FFE0"
	$"07FF FFE0 07FF FFE0 07FF FFE0 07FF FFE0"
	$"07FF FFE0 07FF FFE0 07FF FFE0 07FF FFE0"
	$"07FF FFE0 07FF FFE0 07FF FFE0 07FF FFE0"
	$"07FF FFE0 0FFF FFF0 1FFF FFF8 3FFF FFFC"
	$"7FFF FFFE FFFF FFFF FFFF FFFF FFFF FFFF",
	$"0000 0000 0000 0000 0000 0000 0000 0000"
	$"0000 0000 0000 0000 0000 0000 0000 0000"
	$"01FF FF80 0200 0040 04FF FF20 0500 00A0"
	$"057F C0A0 0500 00A0 056F 00A0 0500 00A0"
	$"057F F0A0 0500 00A0 056D F0A0 0500 00A0"
	$"0500 00A0 04FF FF20 0400 0020 07FF FFE0"
	$"0400 0020 0999 9990 1000 0008 2667 E664"
	$"4000 0002 FFFF FFFF 8000 0001 FFFF FFFF",
	{	/* array ColorSpec: 8 elements */
		/* [1] */
		0, 65535, 65535, 65535,
		/* [2] */
		1, 65535, 52428, 39321,
		/* [3] */
		2, 52428, 39321, 26214,
		/* [4] */
		3, 52428, 52428, 65535,
		/* [5] */
		4, 26214, 26214, 52428,
		/* [6] */
		5, 61166, 61166, 61166,
		/* [7] */
		6, 21845, 21845, 21845,
		/* [8] */
		15, 0, 0, 0
	},
	$"0000 0000 0000 0000 0000 0000 0000 0000"
	$"0000 0000 0000 0000 0000 0000 0000 0000"
	$"0000 0000 0000 0000 0000 0000 0000 0000"
	$"0000 0000 0000 0000 0000 0000 0000 0000"
	$"0000 0000 0000 0000 0000 0000 0000 0000"
	$"0000 0000 0000 0000 0000 0000 0000 0000"
	$"0000 0000 0000 0000 0000 0000 0000 0000"
	$"0000 0000 0000 0000 0000 0000 0000 0000"
	$"0000 000F FFFF FFFF FFFF FFFF F000 0000"
	$"0000 00F2 2222 2222 2222 2222 2F00 0000"
	$"0000 0F22 6666 6666 6666 6666 22F0 0000"
	$"0000 0F26 3333 3333 3333 3333 52F0 0000"
	$"0000 0F26 3444 4444 4433 3333 52F0 0000"
	$"0000 0F26 3333 3333 3333 3333 52F0 0000"
	$"0000 0F26 3443 4444 3333 3333 52F0 0000"
	$"0000 0F26 3333 3333 3333 3333 52F0 0000"
	$"0000 0F26 3444 4444 4444 3333 52F0 0000"
	$"0000 0F26 3333 3333 3333 3333 52F0 0000"
	$"0000 0F26 3443 4434 4444 3333 52F0 0000"
	$"0000 0F26 3333 3333 3333 3333 52F0 0000"
	$"0000 0F26 3333 3333 3333 3335 52F0 0000"
	$"0000 0F22 5555 5555 5555 5555 22F0 0000"
	$"0000 0F22 2222 2222 2222 2222 22F0 0000"
	$"0000 0FFF FFFF FFFF FFFF FFFF FFF0 0000"
	$"0000 0F22 2222 2222 2222 2222 22F0 0000"
	$"0000 F22F F22F F22F F22F F22F F22F 0000"
	$"000F 2222 2222 2222 2222 2222 2222 F000"
	$"00F2 2FF2 2FF2 2FFF FFF2 2FF2 2FF2 2F00"
	$"0F22 2222 2222 2222 2222 2222 2222 22F0"
	$"FFFF FFFF FFFF FFFF FFFF FFFF FFFF FFFF"
	$"F111 1111 1111 1111 1111 1111 1111 111F"
	$"FFFF FFFF FFFF FFFF FFFF FFFF FFFF FFFF"
};

resource 'cicn' (129) {
	16,
	{0, 0, 32, 32},
	4,
	$"0FFF FFC0 1FFF FFC0 3FFF FFC0 7FFF FFC0"
	$"FFFF FFC0 FFFF FFC0 FFFF FFC0 FFFF FFC0"
	$"FFFF FFC0 FFFF FFC0 FFFF FFE0 FFFF FFE0"
	$"FFFF FFE0 FFFF FFE0 FFFF FFE0 FFFF FFE0"
	$"FFFF FFE0 FFFF FFE0 FFFF FFE0 FFFF FFE0"
	$"FFFF FFE0 FFFF FFE0 FFFF FFE0 FFFF FFE0"
	$"FFFF FFE0 FFFF FFF0 FFFF FFF8 FFFF FFFC"
	$"FFFF FFFE FFFF FFFF FFFF FFFF FFFF FFFF",
	$"0FFF FFC0 1C00 0040 3C92 2440 7D55 5440"
	$"FD55 5440 9C92 2440 8000 0040 9092 2440"
	$"91FF FFC0 9200 0040 94FF FF20 8500 00A0"
	$"8500 00A0 9500 00A0 AD00 00A0 AD00 00A0"
	$"9500 00A0 8500 00A0 8500 00A0 9500 00A0"
	$"9500 00A0 94FF FF20 9400 0020 87FF FFE0"
	$"8400 0020 8999 9990 9000 0008 A667 E664"
	$"C000 0002 FFFF FFFF 8000 0001 FFFF FFFF",
	{	/* array ColorSpec: 8 elements */
		/* [1] */
		0, 65535, 65535, 65535,
		/* [2] */
		1, 65535, 52428, 39321,
		/* [3] */
		2, 52428, 39321, 26214,
		/* [4] */
		3, 52428, 52428, 65535,
		/* [5] */
		4, 26214, 26214, 52428,
		/* [6] */
		5, 61166, 61166, 61166,
		/* [7] */
		6, 21845, 21845, 21845,
		/* [8] */
		15, 0, 0, 0
	},
	$"0000 FFFF FFFF FFFF FFFF FFFF FF00 0000"
	$"000F 4F33 3333 3333 3333 3333 3F00 0000"
	$"00F4 4F33 F33F 33F3 33F3 3F33 3F00 0000"
	$"0F44 4F3F 3F3F 3F3F 3F3F 3F33 3F00 0000"
	$"FFFF 4F3F 3F3F 3F3F 3F3F 3F33 3F00 0000"
	$"F33F FF33 F33F 33F3 33F3 3F33 3F00 0000"
	$"F333 3333 3333 3333 3333 3333 3F00 0000"
	$"F33F 3333 F33F 33F3 33F3 3F33 3F00 0000"
	$"F33F 333F FFFF FFFF FFFF FFFF FF00 0000"
	$"F33F 33F2 2222 2222 2222 2222 2F00 0000"
	$"F33F 3F22 6666 6666 6666 6666 22F0 0000"
	$"F333 3F26 3333 3333 3333 3333 52F0 0000"
	$"F333 3F26 3333 3333 3333 3333 52F0 0000"
	$"F33F 3F26 3333 3333 3333 3333 52F0 0000"
	$"F3F3 FF26 3333 3333 3333 3333 52F0 0000"
	$"F3F3 FF26 3333 3333 3333 3333 52F0 0000"
	$"F33F 3F26 3333 3333 3333 3333 52F0 0000"
	$"F333 3F26 3333 3333 3333 3333 52F0 0000"
	$"F333 3F26 3333 3333 3333 3333 52F0 0000"
	$"F33F 3F26 3333 3333 3333 3333 52F0 0000"
	$"F33F 3F26 3333 3333 3333 3335 52F0 0000"
	$"F33F 3F22 5555 5555 5555 5555 22F0 0000"
	$"F33F 3F22 2222 2222 2222 2222 22F0 0000"
	$"F333 3FFF FFFF FFFF FFFF FFFF FFF0 0000"
	$"F333 3F22 2222 2222 2222 2222 22F0 0000"
	$"F333 F22F F22F F22F F22F F22F F22F 0000"
	$"F33F 2222 2222 2222 2222 2222 2222 F000"
	$"F3F2 2FF2 2FF2 2FFF FFF2 2FF2 2FF2 2F00"
	$"FF22 2222 2222 2222 2222 2222 2222 22F0"
	$"FFFF FFFF FFFF FFFF FFFF FFFF FFFF FFFF"
	$"F111 1111 1111 1111 1111 1111 1111 111F"
	$"FFFF FFFF FFFF FFFF FFFF FFFF FFFF FFFF"
};

resource 'cicn' (128) {
	16,
	{0, 0, 32, 32},
	4,
	$"0000 0000 0000 0000 0000 0000 0000 0000"
	$"003F 0000 007F C000 00FF E000 01FF F000"
	$"01FF F000 03FF F800 03FF F800 07FF F800"
	$"07FF F800 07FF F800 07FF F800 07FF F000"
	$"03FF F800 03FF FC00 01FF FE00 00FF FF00"
	$"003F 3F80 0000 1FC0 0000 0FE0 0000 07E0"
	$"0000 03E0 0000 01E0 0000 00C0 0000 0000"
	$"0000 0000 0000 0000 0000 0000 0000 0000",
	$"0000 0000 0000 0000 0000 0000 0000 0000"
	$"003F 0000 0040 C000 00BE 2000 01C1 B000"
	$"0100 5000 0200 2800 0200 2800 0600 1800"
	$"0600 1800 0600 1800 0500 1800 0500 1000"
	$"0280 2800 0260 E400 019F 6200 00C0 F100"
	$"003F 3880 0000 1C40 0000 0E20 0000 0720"
	$"0000 03E0 0000 01E0 0000 00C0 0000 0000"
	$"0000 0000 0000 0000 0000 0000 0000 0000",
	{	/* array ColorSpec: 7 elements */
		/* [1] */
		0, 65535, 65535, 65535,
		/* [2] */
		1, 48059, 48059, 48059,
		/* [3] */
		2, 30583, 30583, 30583,
		/* [4] */
		3, 43690, 43690, 43690,
		/* [5] */
		4, 52428, 52428, 52428,
		/* [6] */
		5, 56797, 56797, 56797,
		/* [7] */
		15, 0, 0, 0
	},
	$"0000 0000 0000 0000 0000 0000 0000 0000"
	$"0000 0000 0000 0000 0000 0000 0000 0000"
	$"0000 0000 0000 0000 0000 0000 0000 0000"
	$"0000 0000 0000 0000 0000 0000 0000 0000"
	$"0000 0000 00FF FFFF 0000 0000 0000 0000"
	$"0000 0000 0F11 1111 FF00 0000 0000 0000"
	$"0000 0000 F1FF FFF1 11F0 0000 0000 0000"
	$"0000 000F FF55 555F F1FF 0000 0000 0000"
	$"0000 000F 5555 5555 5F1F 0000 0000 0000"
	$"0000 00F5 5555 5555 55F1 F000 0000 0000"
	$"0000 00F5 5555 5555 55F1 F000 0000 0000"
	$"0000 0FF5 5555 5555 555F F000 0000 0000"
	$"0000 0FF5 5555 5555 555F F000 0000 0000"
	$"0000 0FF5 5555 5555 555F F000 0000 0000"
	$"0000 0F1F 5555 5555 555F F000 0000 0000"
	$"0000 0F1F 5555 5555 555F 0000 0000 0000"
	$"0000 00F1 F555 5555 55F0 F000 0000 0000"
	$"0000 00F1 1FF5 5555 FFF4 0F00 0000 0000"
	$"0000 000F F11F FFFF 1F23 40F0 0000 0000"
	$"0000 0000 FF11 1111 FFF2 340F 0000 0000"
	$"0000 0000 00FF FFFF 00FF 2340 F000 0000"
	$"0000 0000 0000 0000 000F F234 0F00 0000"
	$"0000 0000 0000 0000 0000 FF23 40F0 0000"
	$"0000 0000 0000 0000 0000 0FF2 34F0 0000"
	$"0000 0000 0000 0000 0000 00FF 2FF0 0000"
	$"0000 0000 0000 0000 0000 000F FFF0 0000"
	$"0000 0000 0000 0000 0000 0000 FF00 0000"
	$"0000 0000 0000 0000 0000 0000 0000 0000"
	$"0000 0000 0000 0000 0000 0000 0000 0000"
	$"0000 0000 0000 0000 0000 0000 0000 0000"
	$"0000 0000 0000 0000 0000 0000 0000 0000"
	$"0000 0000 0000 0000 0000 0000 0000 0000"
};

resource 'cicn' (132) {
	16,
	{0, 0, 32, 32},
	4,
	$"0000 0000 0000 0000 001F C000 003F A000"
	$"007F 2000 00FF A000 01FF 8000 03FF 8000"
	$"07FF FF80 0FFF FFC0 0FFF FFE0 17FF FFE0"
	$"17FF FFE0 17FF FFE0 07FF FFE0 07FF FFE0"
	$"07FF FFE0 07FF FFE0 07FF FFE0 07FF FFE0"
	$"07FF FFE0 07FF FFE0 07FF FFE0 07FF FFE0"
	$"07FF FFE0 0FFF FFF0 1FFF FFF8 3FFF FFFC"
	$"7FFF FFFE FFFF FFFF FFFF FFFF FFFF FFFF",
	$"0000 0000 0000 0000 001F C000 003F A000"
	$"007F 2000 00FE A000 01FC 8000 03FA 8000"
	$"07FF FF80 0FEA 0040 0FFF FF20 14A8 00A0"
	$"1520 00A0 1520 00A0 0500 00A0 0500 00A0"
	$"0500 00A0 0500 00A0 0500 00A0 0500 00A0"
	$"0500 00A0 04FF FF20 0400 0020 07FF FFE0"
	$"0400 0020 0999 9990 1000 0008 2667 E664"
	$"4000 0002 FFFF FFFF 8000 0001 FFFF FFFF",
	{	/* array ColorSpec: 8 elements */
		/* [1] */
		0, 65535, 65535, 65535,
		/* [2] */
		1, 65535, 52428, 39321,
		/* [3] */
		2, 52428, 39321, 26214,
		/* [4] */
		3, 0, 0, 56797,
		/* [5] */
		4, 52428, 52428, 65535,
		/* [6] */
		5, 61166, 61166, 61166,
		/* [7] */
		6, 21845, 21845, 21845,
		/* [8] */
		15, 0, 0, 0
	},
	$"0000 0000 0000 0000 0000 0000 0000 0000"
	$"0000 0000 0000 0000 0000 0000 0000 0000"
	$"0000 0000 0003 3333 3300 0000 0000 0000"
	$"0000 0000 0033 3333 3030 0000 0000 0000"
	$"0000 0000 0333 3333 0030 0000 0000 0000"
	$"0000 0000 3333 3330 3030 0000 0000 0000"
	$"0000 0003 3333 3300 3000 0000 0000 0000"
	$"0000 0033 3333 3030 3000 0000 0000 0000"
	$"0000 0333 3333 FF3F FFFF FFFF F000 0000"
	$"0000 3333 3332 3232 2222 2222 2F00 0000"
	$"0000 3333 3366 3666 6666 6666 22F0 0000"
	$"0003 0F22 6434 3444 4444 4444 52F0 0000"
	$"0003 0F26 4434 4444 4444 4444 52F0 0000"
	$"0003 0F26 4434 4444 4444 4444 52F0 0000"
	$"0000 0F26 4444 4444 4444 4444 52F0 0000"
	$"0000 0F26 4444 4444 4444 4444 52F0 0000"
	$"0000 0F26 4444 4444 4444 4444 52F0 0000"
	$"0000 0F26 4444 4444 4444 4444 52F0 0000"
	$"0000 0F26 4444 4444 4444 4444 52F0 0000"
	$"0000 0F26 4444 4444 4444 4444 52F0 0000"
	$"0000 0F26 4444 4444 4444 4445 52F0 0000"
	$"0000 0F22 5555 5555 5555 5555 22F0 0000"
	$"0000 0F22 2222 2222 2222 2222 22F0 0000"
	$"0000 0FFF FFFF FFFF FFFF FFFF FFF0 0000"
	$"0000 0F22 2222 2222 2222 2222 22F0 0000"
	$"0000 F22F F22F F22F F22F F22F F22F 0000"
	$"000F 2222 2222 2222 2222 2222 2222 F000"
	$"00F2 2FF2 2FF2 2FFF FFF2 2FF2 2FF2 2F00"
	$"0F22 2222 2222 2222 2222 2222 2222 22F0"
	$"FFFF FFFF FFFF FFFF FFFF FFFF FFFF FFFF"
	$"F111 1111 1111 1111 1111 1111 1111 111F"
	$"FFFF FFFF FFFF FFFF FFFF FFFF FFFF FFFF"
};

data 'WINY' (256) {
	$"0000 0000 7A99 9971"                                /* ....zôôq */
};

data 'SVCF' (256) {
	$"0000 0000 0000 0000 0000 0000 0000 0000"            /* ................ */
	$"0000 0000 0000 0000 0000 0000 0000 0000"            /* ................ */
	$"0000 0000 0000 0000 0000 0000 0000 0000"            /* ................ */
	$"0000 0000 0000 0000 0000 0000 0000 0000"            /* ................ */
	$"0000 00"                                            /* ... */
};

resource 'CURS' (256, "Crayon") {
	$"00F0 0088 0108 0190 0270 0220 0440 0440"
	$"0880 0880 1100 1E00 1C00 1800 10",
	$"00F0 00F8 01F8 01F0 03F0 03E0 07C0 07C0"
	$"0F80 0F80 1100 1200 1400 1800 10",
	{14, 3}
};

data 'styl' (-3000) {
	$"0002 0000 0000 000C 000A 0001 0100 0009"            /* ...............Δ */
	$"0000 0000 0000 0000 000C 000C 000A 0001"            /* ................ */
	$"0000 0009 0000 0000 0000"                           /* ...Δ...... */
};

data 'hwin' (-3000) {
	$"0002 0000 0000 0009 F44B 6872 6374 0011"            /* .......Δ.Khrct.. */
	$"1152 6F75 7469 6E65 7320 6578 7465 726E"            /* .Routines extern */
	$"6573 F44A 6872 6374 0011 1152 6F75 7469"            /* es.Jhrct...Routi */
	$"6E65 7320 6578 7465 726E 6573 F449 6872"            /* nes externes.Ihr */
	$"6374 0007 074D 696E 6974 656C F448 6872"            /* ct...Minitel.Hhr */
	$"6374 0017 1745 7272 6575 7273 202F 2054"            /* ct...Erreurs / T */
	$"7261 6365 2073 7973 748F 6D65 F44C 6864"            /* race système.Lhd */
	$"6C67 0009 0952 656D 706C 6163 6572 F44B"            /* lg.ΔΔRemplacer.K */
	$"6864 6C67 0010 104F 7074 2E20 436F 6D70"            /* hdlg...Opt. Comp */
	$"696C 6174 696F 6E00 F44A 6864 6C67 000C"            /* ilation..Jhdlg.. */
	$"0C4F 7074 2E20 416E 616C 7973 6500 F449"            /* .Opt. Analyse..I */
	$"6864 6C67 0006 0643 6F6E 6669 6700 F448"            /* hdlg...Config..H */
	$"6864 6C67 0008 0843 6865 7263 6865 7200"            /* hdlg...Chercher. */
};

data 'TEXT' (-3000) {
	$"4472 6167 7374 6572 4564 6974 2070 6572"            /* DragsterEdit per */
	$"6D65 7420 6465 2063 728E 6572 2C20 6D6F"            /* met de créer, mo */
	$"6469 6669 6572 2C20 7465 7374 6572 2065"            /* difier, tester e */
	$"7420 636F 6D70 696C 6572 2075 6E65 2061"            /* t compiler une a */
	$"7070 6C69 6361 7469 6F6E 2076 6964 8E6F"            /* pplication vidéo */
	$"7465 7820 7065 726D 6574 7465 6E74 2064"            /* tex permettent d */
	$"6520 7472 616E 7366 6F72 6D65 7220 766F"            /* e transformer vo */
	$"7472 6520 4D61 6369 6E74 6F73 6820 656E"            /* tre Macintosh en */
	$"2073 6572 7665 7572 2076 6964 8E6F 7465"            /*  serveur vidéote */
	$"782E"                                               /* x. */
};

data 'hfdr' (-5696) {
	$"0002 0000 0000 0000 0000 0001 0006 0006"            /* ................ */
	$"F448"                                               /* .H */
};

data 'DRG9' (0) {
	$"00"                                                 /* . */
};

resource 'BNDL' (128, preload) {
	'DRG9',
	0,
	{	/* array TypeArray: 2 elements */
		/* [1] */
		'FREF',
		{	/* array IDArray: 6 elements */
			/* [1] */
			0, 256,
			/* [2] */
			1, 257,
			/* [3] */
			2, 258,
			/* [4] */
			3, 259,
			/* [5] */
			4, 260,
			/* [6] */
			5, 130
		},
		/* [2] */
		'ICN#',
		{	/* array IDArray: 6 elements */
			/* [1] */
			0, 256,
			/* [2] */
			1, 257,
			/* [3] */
			2, 258,
			/* [4] */
			3, 128,
			/* [5] */
			4, 260,
			/* [6] */
			5, 129
		}
	}
};

resource 'mctb' (259, "Couleurs menu") {
	{	/* array MCTBArray: 12 elements */
		/* [1] */
		259, 3,
		{	/* array: 4 elements */
			/* [1] */
			0, 0, 0,
			/* [2] */
			0, 0, 56797,
			/* [3] */
			0, 0, 0,
			/* [4] */
			65535, 65535, 65535
		},
		/* [2] */
		259, 4,
		{	/* array: 4 elements */
			/* [1] */
			0, 0, 0,
			/* [2] */
			56797, 0, 0,
			/* [3] */
			0, 0, 0,
			/* [4] */
			65535, 65535, 65535
		},
		/* [3] */
		259, 5,
		{	/* array: 4 elements */
			/* [1] */
			0, 0, 0,
			/* [2] */
			65535, 0, 52428,
			/* [3] */
			0, 0, 0,
			/* [4] */
			65535, 65535, 65535
		},
		/* [4] */
		259, 6,
		{	/* array: 4 elements */
			/* [1] */
			0, 0, 0,
			/* [2] */
			13107, 52428, 13107,
			/* [3] */
			0, 0, 0,
			/* [4] */
			65535, 65535, 65535
		},
		/* [5] */
		259, 7,
		{	/* array: 4 elements */
			/* [1] */
			0, 0, 0,
			/* [2] */
			0, 39321, 65535,
			/* [3] */
			0, 0, 0,
			/* [4] */
			65535, 65535, 65535
		},
		/* [6] */
		259, 8,
		{	/* array: 4 elements */
			/* [1] */
			0, 0, 0,
			/* [2] */
			65535, 65535, 0,
			/* [3] */
			0, 0, 0,
			/* [4] */
			65535, 65535, 65535
		},
		/* [7] */
		259, 12,
		{	/* array: 4 elements */
			/* [1] */
			0, 0, 0,
			/* [2] */
			0, 0, 56797,
			/* [3] */
			0, 0, 0,
			/* [4] */
			65535, 65535, 65535
		},
		/* [8] */
		259, 13,
		{	/* array: 4 elements */
			/* [1] */
			0, 0, 0,
			/* [2] */
			56797, 0, 0,
			/* [3] */
			0, 0, 0,
			/* [4] */
			65535, 65535, 65535
		},
		/* [9] */
		259, 14,
		{	/* array: 4 elements */
			/* [1] */
			0, 0, 0,
			/* [2] */
			65535, 0, 52428,
			/* [3] */
			0, 0, 0,
			/* [4] */
			65535, 65535, 65535
		},
		/* [10] */
		259, 15,
		{	/* array: 4 elements */
			/* [1] */
			0, 0, 0,
			/* [2] */
			13107, 52428, 13107,
			/* [3] */
			0, 0, 0,
			/* [4] */
			65535, 65535, 65535
		},
		/* [11] */
		259, 16,
		{	/* array: 4 elements */
			/* [1] */
			0, 0, 0,
			/* [2] */
			0, 39321, 65535,
			/* [3] */
			0, 0, 0,
			/* [4] */
			65535, 65535, 65535
		},
		/* [12] */
		259, 17,
		{	/* array: 4 elements */
			/* [1] */
			0, 0, 0,
			/* [2] */
			65535, 65535, 0,
			/* [3] */
			0, 0, 0,
			/* [4] */
			65535, 65535, 65535
		}
	}
};

resource 'clut' (127, sysheap) {
	{	/* array ColorSpec: 8 elements */
		/* [1] */
		0, 0, 0,
		/* [2] */
		65535, 65535, 0,
		/* [3] */
		65535, 0, 65535,
		/* [4] */
		65535, 0, 0,
		/* [5] */
		0, 65535, 65535,
		/* [6] */
		0, 65535, 0,
		/* [7] */
		0, 0, 65535,
		/* [8] */
		65535, 65535, 65535
	}
};

