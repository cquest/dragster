UNIT DrgGlobals;

INTERFACE


USES	MemTypes, OsIntf, ToolIntf,
		TokDetok;

CONST	MaxEcran	= 8;
		nbcar		= 960;	    { nombre de car d'un ecran vidéotex }

TYPE      TNumero       = ARRAY [1..2] OF INTEGER;
          TmonControl   = ARRAY [1..2] OF ControlHandle;

          TCar	        =	  PACKED RECORD
                                        VCouleur : byte;
                                        VBCouleur: byte;
                                        VJeu	 : byte;
                                        VTaille	 : byte;
                                        VFlags	 : byte;
                                        ValG01	 : char;
                                  END;

          ACar	        =	  ARRAY[0..nbcar] OF TCar;

          ptEcran       = ^Ecran;
          HandleEcran   = ^ptEcran;

          Ecran	        = RECORD
                             Cars: ACar;
                             SSel, ESel: integer; { selection }
                             SelRgn: RgnHandle;
                             IdleFlag: Boolean;
                             WEcran: WindowPtr;
                             WEdit: WindowPtr;
                             hte: tehandle;
                             Offx, offy: integer;
                             Modified: boolean;
                             VolNumber: integer;
                             FileName: str255;
							 DirID: LONGINT;
                             Couleur,
                             BCouleur,
                             Jeu,
                             Taille	 : integer;
                             Clignotement,
                             Disjoint,
                             Masquage,
                             Inverse,
                             Incrust		: boolean;
                             Numero			: TNumero;
                             monControl		: TMonControl;
                             Modification,
                             ErrFlag	 : boolean; { syntaxe non ok }
                             NbVar,
                             NbCst,
                             LgCode		: integer;
                             CodeHdle   : TParamHandle;
                             VarTab     : HVarRes;
                             CstTab     : HCstRes;
							 Mode		: integer;	{0=texte, 1=pinceau, 2=digitalisation }
							 WPict		: PicHandle;
							 HasMoved	: BOOLEAN;	{ indique si l'utilisateur a bougé la fenêtre }
                          END;

          PoolEcran     = RECORD
                             NbEcran: Integer;
                             Ecrans: ARRAY[1..MaxEcran] OF HandleEcran;
                          END;

VAR		Screen		: PtEcran;
		ScreenPtr	: WindowPtr;
		
		TheMac		: SysEnvRec;
		BTexRect,
		BPenRect,
	    EditRect,
	    JeuRect     : Rect;
	    PSel,DSel,
		XSel		: integer;
	    Couleur,
	    BCouleur,
	    Jeu,
	    Taille		: integer;
	    Clignotement,
	    Disjoint,
	    Masquage,
	    Inverse,
	    Incrust		: boolean;

FUNCTION ShowColor:BOOLEAN;


IMPLEMENTATION

{$S UTILS}
FUNCTION ShowColor:BOOLEAN;

BEGIN
	ShowColor := FALSE;
	IF TheMac.HasColorQD THEN
	BEGIN
		MacScreen := GetGDevice;
		IF MacScreen^^.gdpMap^^.pixelSize > 2 THEN ShowColor := TRUE;
	END;
END;


END.
