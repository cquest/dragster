{
	File:				Videotex.p

	Contains:		UNIT d'émulation vidéotex (CEPT2+DRCS)

	Written by:	Christian QUEST / Serge VILLA

	Copyright:	1990-1992 JCA Télématique

}

UNIT Videotex;

INTERFACE
{$IFC UNDEFINED THINK_PASCAL}
{$SETC THINK_PASCAL=FALSE}
{$ENDC}

{$IFC NOT THINK_PASCAL } 
USES 
    Memtypes,QuickDraw,OSIntf,ToolIntf,PackIntf, CTB;
		
{$ENDC}

CONST
		offsetV = 8;		{ <---- position de l'émulation dans le grafport }
		offsetH = 8;
		
    cFistSize                   =   1;      {premiere Taille disponible }
    c2ndSize                    =   2;      {seconde Taille disponible  }
    cTreeSize                   =   3;      {troisieme Taille Disponible}
    cFourSize                   =   4;      {Quatrieme Taille Disponible}
    cTaille5										=		5;			{ 1,5 fois la normale }
		
    {modes d'affichage à l'écran en fonction du choix utilisateur}
    cModeBlancNoir              =   1;
    cModeNoirBlanc              =   2;
    cModeNoirGris               =   3;
    cModeNivGris                =   4;
    cModeCouleur                =   5;    
    
    {indices du tableau caract ^}
    cChar                       =   0;
    cJeu                        =   1;
    cCouleur                    =   2;
    cFond                       =   3;
    ctaille                     =   4;
    clignage                    =   5;
    cInverse                    =   6;
    cFlash                      =   7;
    cMasque                     =   8;
    
    {indices des listes de couleurs}
    cBlack                      =   0;
    cRed                        =   1;
    cGreen                      =   2;
    cYellow                     =   3;
    cBlue                       =   4;
    cMagenta                    =   5;
    cCyan                       =   6;
    cWhite                      =   7;
    
    {références de quelques caractères utilisés }   
    NUL                         =   $00;
    SOH                         =   $01;
    EOT                         =   $04;
    ENQ                         =   $05;
    BEL                         =   $07;
    BS                          =   $08;
    HT                          =   $09;
    LF                          =   $0A;
    VT                          =   $0B;
    FF                          =   $0C;
    CR                          =   $0D;
    SO                          =   $0E;
    SI                          =   $0F;
    DLE                         =   $10;
    CON                         =   $11;
    REP                         =   $12;
    SEP                         =   $13;
    COFF                        =   $14;
    NACK                        =   $15;
    SYN                         =   $16;
    CAN                         =   $18;
    SS2                         =   $19;
    SUB                         =   $1A;
    ESC                         =   $1B;
    SS3                         =   $1D;
    RS                          =   $1E;
    US                          =   $1F;
    
    cNormal                     =   0;
    cDbleHaut                   =   1;
    cDbleLarg                   =   2;
    cDbleTaille                 =   3;
          
		JeuVide											= 0;
		JeuSI												= 1;
		JeuSO												= 2;
		JeuDRCS1										= 3;
		JeuDRCS2										= 4;
		
    PerifForce                  =   1;
    PerifHayes                  =   2;
    PerifMinitel                =   3;
    
    MaxColVideoTex              =   40;
    MaxLinVideotex              =   24;
    
    
TYPE
    VideoScreen   = PACKED ARRAY[1..MaxColVideoTex,0..MaxLinVideotex,cChar..cMasque] OF integer;
    VideoPtr      = ^VideoScreen;
    ListOfPat     = ARRAY[cblack..cWhite] OF pattern;
    ListOfColor   = ARRAY[cblack..cWhite] OF RGBColor;
    ListOfRGB			= ARRAY[cBlack..cWhite] OF RGBColor;
		
		ScreenData = PACKED RECORD
				leJeu: Byte;				{ jeu du caract. }
				leCar: CHAR;				{ code 'Mac' du caractère à afficher }
				CoulCar: Byte;			{ couleur du caractère }
				CoulFond: Byte;			{ couleur du fond }
				Taille: Byte;				{ taille pour le JeuSI }
				souligne: BOOLEAN;	{ souligné pour JeuSI, le disjoint est inclu dans 'leCar' }
				inverse: BOOLEAN;		
				flash: BOOLEAN;
				masque: BOOLEAN;
				delim: BOOLEAN;			{ indique si espace délimiteur }
				redraw: BOOLEAN;		{ a besoin d'âtre redessiné }
				dummy: INTEGER;			{ aligne ScreenData à 8 octets }
		END;
		Screen = ARRAY[0..MaxLinVideotex,1..MaxColVideotex] OF ScreenData;
		ScreenPtr = ^Screen;
		ScreenH = ^ScreenPtr;
		
		TLine        =  0..MaxLinVideotex;
    TColone      =  1..MaxLinVideotex;
  
		Str10 = STRING[10];
		Outbuffer = ^Str10;	{ buffer de sortie de car. }
		
		DRCSChar = RECORD
			data: PACKED ARRAY [0..19] OF Byte;
			Loaded: BOOLEAN;
			dummy: INTEGER;		{ aligne DRCSChar à 24 octets }
		END;
		DRCSCharTable = ARRAY [1..188] OF DRCSChar;
		DRCSCharTablePtr = ^DRCSCharTable;
		DRCSCharTableH = ^DRCSCharTablePtr;
		
		DRCSTable = ARRAY [$21..$7E,JeuDRCS1..JeuDRCS2] OF INTEGER;
		
		ParamCSITable = ARRAY [1..10] OF INTEGER;
		
GlobRec = RECORD
    fCursorON               :   boolean;    {Indique si curseur allumé ou éteint}
    fScrollON               :   boolean;    {Indique si en mode rouleau} 
    fMasquageON             :   boolean;    {Indique le masquage plein ecran}
    fDrawInPort             :   boolean;    {permet l'arret de l'affichage mais pas de l'analyse}
    fRecvOn                 :   boolean;    {Permet la validation de la reception}
    
    fposLine0               :   boolean;
    fLastSave               :   boolean;    {Indique que la derniere modif ecran a ete sauvee}
    
    
    RectChar                :   Rect;       {Englobe un char en size 9}
    Destrect                :   Rect;
    
    vSizeVisu               :   integer;    {Taille ecran courante}
    
    RectScreen              :   Rect;       {l'ecran dans lequel on dessine}
    RectOff                 :   Rect;
   
    LargCh,HautCh           :   integer;    {largeur et hauteur d'un caractère  }
    
    Lcurs,Ccurs             :   integer;    {pos. en cours du curseur videotex  }
    xMac,yMac               :   integer;    {idem sur l'ecran Macintosh         }

    patternList             :   ListOfPat;  {Liste des patterns utilisées       }
    ColorList               :   ListOfColor;{Liste des couleurs utilisées       }
    GrayList								:		ListOfRGB;	{Liste des RGBColors pour le niveau de gris }
		
    ChDelim									:		BOOLEAN;
		Chjeu                   :   integer;    {attributs courants au niveau char  }
    Chlignage               :   integer;    { idem                              }
    Chcouleur               :   integer;    { idem                              }
    Chfond                  :   integer;    { idem                              }
    ChFlash                 :   integer;    { idem                              }
    Chinverse               :   integer;    { idem                              }
    Chtaille                :   integer;    { idem                              }
    ChMasque                :   integer;    { idem                              }
    ChChar                  :   integer;    {caractère courant}
    ExChar                  :   integer;    {caractère précédent}
    NbChar                  :   integer;    {compteur de char dans sequence}
    SaveFond								:		integer;		
		SaveLignage							:		integer;
		
    ModeInterpretation      :   integer;    {interpretation du caractère reçu   }
    TypePerif               :   integer;    { type de l'interface connectée     }
    ModeAffichage           :   integer;
    
		theScreen								:		ScreenH;		{ Handle vers tableau de la représentation de l'écran }
		
    mycount                 :   integer;		{ compteur pour car. transparents }
    
    OffCharport							:		grafport;  {grafport offscreen pour calcul image}
    OffCharport2						:		grafport;  {grafport offscreen pour calcul image}
    OffPort									:		grafport;  {offscreen image}
		
    Oldport                 :   grafptr;   {sauve le port courant               }
    DrawPort                :   grafPtr;   {le port dans lequel on dessine}
   
    PortStyle               :   Style;
    saverep                 :   integer;
    exjeu                   :   integer;
    
    RectCurs,SaveRect       : Rect;
    fStatCursOn     				: boolean;
    fConnected      				: boolean;
    fStatMask       				: boolean;
    
    myTime,saveTime 				: longint;
    xCac,yCac       				: integer;
    savefirst       				: integer;
    fModeEcran      				: boolean;
    IDEmulator      				: STRING[3];
    fIgnore         				: boolean;
    
    
    MyRgn           				: RgnHandle;
    PtrBufOut								: OutBuffer;
		
		TermData								:	Handle;	{ Handle vers les données du Terminal Tool CTB }
		
    offsetX									: INTEGER;
    offsetY									: INTEGER;
		
		redrawing								: BOOLEAN;
		DRCSLoad								: BOOLEAN;
		DRCSCurLoad							: INTEGER;	{ jeu en cours de téléchargement }
		DRCSCharLoad						:	INTEGER;	{ caract. en cours de téléchargement }
		DRCSCurByte							: INTEGER;	{ octet en cours de téléchargement }
		DRCSCountByte						:	INTEGER;
		DRCSFirstLoad						: BOOLEAN;
		
		G0isDRCS								: BOOLEAN;
		G1isDRCS								: BOOLEAN;
		
		TableDRCS								: DRCSTable;
		TableDRCSChars					: DRCSCharTableH;
		
		SaveDrawPort						: GrafPtr;	{ pour garder le pour lors des impressions }

    SizeJeu         				: INTEGER;    { Taille des Jeux de caractères utilisés}
		
		Connecte								: BOOLEAN;		{ flag indiquant si on est connecté (pour C/F en haut) }

		ParamCSI								: ParamCSITable;
		NbParamCSI							: INTEGER;
		
		FontSI									: INTEGER;
		FontSO									: INTEGER;
END;	{ globRec }

	GlobPtr = ^GlobRec;
	GlobHdl = ^GlobPtr;

PROCEDURE InitVideotex(VAR Glob: GlobPtr; whichPort:grafptr; typeEmul: INTEGER; theSize: INTEGER; Hterm: Handle);
PROCEDURE Emul(Glob: GlobPtr; theBuffer: Ptr; thebuffersize: LONGINT; VAR SendString:Str255);
PROCEDURE EmulOneChar(Glob: GlobPtr; thechar:INTEGER);
PROCEDURE ClearScreen(Glob: GlobPtr);                {Ecran Effacé                        }
PROCEDURE UpDateScreen(Glob: GlobPtr);
PROCEDURE VideoCurseur(Glob: GlobPtr);
PROCEDURE CleanEmul(Glob:GlobPtr);
PROCEDURE ChangeModeAffichage(glob: globPtr; nouveauMode: INTEGER);
PROCEDURE ChangeTailleAffichage(glob: globPtr; newSize: INTEGER);
PROCEDURE GetKeyWord(glob:GlobPtr; where:Point; VAR KeyWord:Str255);
FUNCTION	GetScreenPicture(Glob:GlobPtr; pictType:INTEGER):PicHandle;
PROCEDURE SupprimeCurseur(glob:globptr);
PROCEDURE SetStatutConnexion(Glob:GlobPtr; connecte:BOOLEAN);
FUNCTION WordInScreen(Glob:GlobPtr; VAR Word:Str255):INTEGER;

IMPLEMENTATION 

{$IFC NOT THINK_PASCAL }
{$I Videotex.inc.p }
{$ENDC}

END.	{ of UNIT Videotex }




