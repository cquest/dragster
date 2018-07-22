{
	File:		DragsterEdit.p

	Contains:	Source principal de DragsterEdit/DragsterEditDemo

	Modified by:	Christian QUEST, JCA Télématique
	
}

PROGRAM DragsterEdit;

{************************************************************************}
{*								       									*}
{*	      Fichier Implementation Editeur Videotex		       			*}
{*								       									*}
{*		  Version 0.1 du  28 février 1986		       					*}
{*								       									*}
{*		    (C) Philippe BOULANGER 1986			       					*}
{*								       									*}
{************************************************************************}
{*								       									*}
{*		  Version 1.90 (C) Ch. QUEST / JCA Télématique	1990-1991		*}
{*								       									*}
{************************************************************************}
{$SETC TEST=FALSE}
{$SETC Debug = FALSE}
{$SETC DragAndDrop=TRUE}

{$SETC DrgTree := FALSE}
{$SETC Protection = FALSE }
{$SETC AntiVir = TRUE }
{$SETC StopDebugger = TRUE }

{$IFC Debug}
{$SETC AntiVir = FALSE }
{$SETC StopDebugger = FALSE }
{$ENDC}

{$IFC UNDEFINED DEMO}
{$SETC DEMO=FALSE}
{$ENDC}

{$IFC DEMO}
{$SETC Protection=FALSE}
{$SETC StopDebugger = FALSE }
{$ENDC}

USES	MemTypes,QuickDraw , OSIntf ,ToolIntf , Sane , MacPrint ,Packages ,
		GestaltEqu, AppleEvents, ADSP, CursorCtl, StandardFile, TextUtils, Drag,
		{$U $$Shell(PUtilities) }Utilities,
		WritelnWindow, Emulator, DragsterIO, TokDetok,
		{$U :Wintree:DrgTree.p } DrgTree,
        InterPretor, Compilator, VideoWork, Protect, AntiVirus, PreCompilator,
		InterpretorLib;

CONST	  rMBARBasic	=  128;		{ barre de menu des écrans Basic }
		  rMBARVtex		=  129;		{ barre de menu des écrans Vidéotex }
		  
		  AppleMenu     =  256;	    { ID menu Pomme }
          FileMenu      =  257;	    { ID menu Fichier }
          EditMenu      =  258;	    { ID menu Edition }
          ColorMenu     =  259;	    { ID menu Couleur }
          JeuMenu       =  260;	    { ID menu Jeu }
          FenMenu       =  261;	    { ID menu Options }
          BasicMenu     =  262;	    { ID menu Basic }
		  
          OffCouleur    =    2;	    { item premiere couleur }
          FinCouleur    =    9;	    { item derniere couleur }

          OffBCouleur   =   11;	    { item premiere couleur de fond}
          FinBCouleur   =   18;	    { item derniere couleur de fond}

          OffJeu        =    1;	    { item premier jeu }
          FinJeu        =    3;	    { item dernier jeu }
          OffG0	        =    1;	    { item G0 }
          OffG1	        =    2;	    { item G1 }
          OffG2	        =    3;	    { item G2 }

          OffTaille     =    4;	    { item premiere taille }
          FinTaille     =    7;	    { item derniere taille }
          OffTN	        =    4;	    { item Taille Normale }
          OffDH	        =    5;	    { item Double Hauteur }
          OffDL	        =    6;	    { item Double Largeur }
          OffDG	        =    7;	    { item Double Grandeur }

          OffClign      =    9;	    { item clignotement }
          OffDisjoint   =   10;	    { item disjoint }
          OffMasquage   =   11;	    { item masquage }
          OffInverse    =   12;	    { item inverse }
          OffIncrust    =   13;	    { item incrust }

          OffAttNormaux =   15;	    { item Attributs normaux }

          OffWBas       =    1;	    { item fenetres edition }
          OffWVid       =    2;	    { item fenetres videotex }
          OffWErr       =    4;	    { item fenetre erreur }
		  OffExtern		=	 5;		{ item Routines Externes }
		  OffWindows	=	 6;		{ premier item pour la liste des fenêtres }
		  
          OffUndo 	    =    1;	    { item Annuler }
          OffCut        =    3;	    { item Couper }
          OffCopy       =    4;	    { item Copier }
          OffPaste      =    5;	    { item Coller }
          OffDelete     =    6;	    { item Effacer }
          OffAll		=    7;	    { item Tout Effacer }
          OffSearch		=	 9;	    { item Chercher }
          OffSearchNext	=	10;	    { item Chercher suivant }
          OffSearchSel	=	11;		{ item Chercher Sélection }
		  OffReplace	=	12;	    { item Remplacer }
          OffReplaceNext=	13;	    { item Remplacer suivant }
		  OffShiftLeft	=	15;
		  OffShiftRight	=	16;
		  OffAlign		= 	17;
		  OffGotoLine	=	18;
		  
          OffNew        =    1;	    { item Nouveau }
          OffOpen       =    2;	    { item Ouvrir }
          offOpenSel	=	 3;		{ item Ouvrir sélection }
		  OffDup        =    4;	    { item Dupliquer }
          OffSup        =    5;	    { item Superposer }
          OffSave       =    6;	    { item Sauver }
          OffUnder      =    7;	    { item Sauver sous }
          OffClose      =    8;	    { item Fermer }
          OffOrg        =   10;	    { item Original }
          OffTest       =   12;	    { item Test }
          OffFormat     =   14;	    { item Format d'impression }
          OffPrint      =   15;	    { item Imprimer }
		  OffCServ      =   17;	    { item Config du serveur }
          OffQuit       =   19;	    { item Quitter }

          OffSyntax     =    1;	    { item Verifier syntaxe }
          OffComp       =    2;	    { item compiler }
          OffRun        =    4;	    { item Lancer }
          OffStop       =    5;	    { item arreter }
          OffTrace      =    7;	    { item Trace }
		  OffTrace2		=	 8;		{ item Trace actifs }
          OffAnalys     =   10;	    { item Liste des variables }
		  OffCompil		=	11;		{ item 'Options de compilation' }

		  BackErr		= 1000;		{ Erreur à cause du Back}
		  
          IdleSpeed     =   20;	    { vitesse du curseur }

          MaxEcran		=   16;	    {nombre d'ecrans simultanés }

          VRef	        =   256;    { Videotex RefCon }
          ERef	        =   257;    { Edit     RefCon }
          DRef	        =   258;    { Debug    RefCon }
          SRef	        =   259;    { Status   RefCon }
		  ExtRef		=	260;	{ Externes RefCon}
		  DlogRef		=	512;	{ dialogue normal }
		  
		  EditModeCst	=	  0;	{ mode texte   }
		  PenModeCst	=	  1;	{ mode pinceau }
		  PictModeCst	=	  2;	{ mode digitalisation }

		  Velizy		=	248;	{ jeu G0-G2 }
		  VidGraph		=	247;	{ jeu G1 }
		  
		  rFindDLOG		=	128;
		  rReplaceDLOG	=	129;
		  rExternDLOG	=	130;
		  rOptCompDLOG	=	131;
		  rOptAnalysDLOG=	132;
		  rGotoLineDLOG =	140;
		  rNoModemALRT	=	260;
		  
		  rSTRErrors	=	257;
		  rSTRTokens	=	260;
		  rSTRIntErrors =	261;	{ Messages d'erreur de l'interpreteur }
		  
		  WPosResType	=	'WPOS';
		  
		  ProtResType	=	'PREF';
		  ProtResID		=	129;
		  ProtResIDTest	=	130;
		  ProtResName	=	'';
		  ProtDLOG		=	300;	{ insérez la disquette }
		  ProtDLOG2		=	301;	{ disquette demandée prochain coup }
		  ProtALRT		=	302;	{ disquette vérouillée ! }
		  
	{$I	TkTokenCst.p }

TYPE	  VarInt        = RECORD CASE INTEGER OF
                              1	   : (VarL    : LONGINT);
                              2	   : (VarIH   : INTEGER;
                                      VarIL   : INTEGER);
                          END;
          LomemPtr      = ^LongInt;
          Str80	        = STRING[80];
		  
          TNumero       = ARRAY [1..2] OF INTEGER;
          TmonControl   = ARRAY [1..2] OF ControlHandle;

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
                             Incrust	 : boolean;
                             Numero	 : TNumero;
                             monControl	 : TMonControl;
                             Modification,
                             ErrFlag	 : boolean; { syntaxe non ok }
                             NbVar,
                             NbCst,
                             LgCode	 : integer;
                             CodeHdle   : TParamHandle;
                             VarTab     : HVarRes;
                             CstTab     : HCstRes;
							 Mode		: integer;	{0=texte, 1=pinceau, 2=digitalisation }
							 WPict		: PicHandle;
							 HasMoved	: BOOLEAN;		{ indique si l'utilisateur a bougé la fenêtre }
							 DragAccepted: BOOLEAN;
							 DragOffset: INTEGER;
							 DragItem: ItemReference;
							 DragCaretVisible: BOOLEAN;
							 DragTime: LONGINT;
                          END;

          PoolEcran     = RECORD
                             NbEcran: Integer;
                             Ecrans: ARRAY[1..MaxEcran] OF HandleEcran;
                          END;

		  FindRec	= RECORD
			  FindStr		: Str255;
			  ReplaceStr	: Str255;
			  CaseSens		: BOOLEAN;
			  DiacSens		: BOOLEAN;
			  WrapFind		: BOOLEAN;
			  WordFind		: BOOLEAN;
		  END;

		  UndoRec = RECORD
			  canUndo	: BOOLEAN;
			  undoMode	: INTEGER;
			  doc		: windowptr;
			  selStart	: INTEGER;
			  selEnd	: INTEGER;
			  longueur	: INTEGER;
			  TheText	: Handle;
			  oldStart	: INTEGER;
			  oldEnd	: INTEGER;
			  undoDirty	: BOOLEAN;
			  undoname	: INTEGER;
			  undostate	: BOOLEAN;
		  END;

		  PrefRec = RECORD
		  	PrefVersion:	INTEGER;
			Ecran: Rect;
			W1: Rect;		{ position fenêtre Trace }
			W2: Rect;		{ position fenêtre Emulation }
			W3: Rect;		{ position fenêtre Routines externes }
			W4: Rect;		{ position dialogue 'Chercher/Remplacer' }
			W5: Rect;		{ position dialogue 'Compilation' }
			Flag: PACKED ARRAY [0..15] OF BOOLEAN;
		  END;
		  
		  PrefPtr = ^PrefRec;
		  PrefHdl = ^PrefPtr;
		  
		  WindPosRec = RECORD
		  	Ecran: Rect;		{ Taille écran }
			Window1: Rect;		{ Taille et position fenêtre Basic }
			Window2: Rect;		{ Taille et position fenêtre Vidéotex }
			SelStart: INTEGER;	{ Début sélection de texte }
			SelEnd: INTEGER;	{ Fin sélection de texte }
		  END;
		
		  WindPosPtr = ^WindPosRec;
		  WindPosHdl = ^WindPosPtr;
			
{$IFC Protection}
		ProtRec = RECORD	{ format de la ressource de protection }
			compteur: INTEGER;
			version: INTEGER;
			numero: LONGINT;
			key: LONGINT;
			date: LONGINT;
		END;
		
		ProtPtr = ^ProtRec;
		ProtHdl = ^ProtPtr;
{$ENDC}



VAR
	i			: INTEGER;
	TheMac		: SysEnvRec;
	RefHelp		: Integer;
	FndStr		: Str255;
	RemplStr	: Str255;
	
	FindData	: FindRec;
	UndoData	: UndoRec;
	Shifted		: BOOLEAN;
	Option		: BOOLEAN;
	Ctrl		: BOOLEAN;
	
	BasicBar	: Handle;
	VTexBar		: Handle;
	
    PEcr        : PoolEcran;

        { LgCode,
          NbVar,
          NbCst	     : integer; } { dans Expr }

        { CodeHdle,
          VarTab,
          CstTab     : Handle;  } { dans Expr }

        { ErrFlag    : Boolean; } { dans Expr }

        { hTE	     : TEHandle;} { dans Expr }

    WDrawDialog	: DialogPtr;
	
	ShownWindowFlag,
    FlagProg,
    PrintVFlag,
    PrintBFlag,
    WBasFlag,
    WVidFlag,
    WErrFlag,
    VLstFlag,
    ELstFlag,
    ClstFlag,
    NameFlag,
    FlagPP,
    FlagPPT,
    DoneFlag,
    IdleFlag	: BOOLEAN;

    PrintHdl	: THPrint;

    FontFile,
    NbCreator,
    NbExcl		: Integer;

    MonEvent	: Eventrecord;
    Wh			: Integer;
	
    QFenetre	: WindowPtr;

    F			: text;

    IdleTime,
    BootTime	: longint;
    BootFlag	: Boolean;

    Err			: OsErr;

    Screen,
    CpScreen,
    ExScreen	: ptEcran;

	Mode,
    CurrentS,
    ExPSel,
    ExDSel,
    CpPSel,
    CpDSel		: Integer;

    CarWid,
    Largeur,
    Couleur,
    BCouleur,
    Jeu,
    Taille		: integer;

    Clignotement,
    Disjoint,
    Masquage,
    Inverse,
    Incrust		: boolean;

    Modification: boolean;
	HasMoved:	boolean;
	
    MonType,
    MonCreator	: OSType;

    ScreenPtr,
    EditPtr		: WindowPtr;

    GrowRect    : rect;
    StdDrag     : rect;
    TeRect      : rect;

    Valeur,
    Etat,
    fgWidth,
    fgHeight,
    fgLnAscent,
    offx,offy   : integer;

    SnCount:    Integer;
    SnSched:    longint;

    PSel,DSel, XSel		: integer;
    SelRgn,ExSelRgn		: RgnHandle;

	BTexRect,
	BPenRect,
    EditRect,
    JeuRect     : Rect;

	MyPen,
    ICurs,
    WCurs,
    CCurs       : CursHandle;

    Numero      : TNumero;
    monControl  : TMonControl;

    myPic,
	MyPicButton : PicHandle;
    monPPort    : TPPrPort;

    TheModStr   : STRING[10];
	MyRefFile	: Integer;
	
	MacScreen	: GDHandle;
	
	PosTrace	: Rect;	{ position de la fenêtre de Trace }
	PosExt		: Rect;	{ position de la fenêtre des Routines externes }
	PosCherche	: Rect;	{ position du dialogue 'chercher/remplacer' }
	
	Chaine		: Str255;	{ fourre tout }
	Hdl			: Handle;
	L			: LONGINT;
	
	ExtDlog		: DialogPtr;
	ExtList		: ListHandle;
	ExtRect2	: Rect;
	
	LastFenItem	: INTEGER;
	CursRgn		: RgnHandle;
	
	gAppRefnum	: INTEGER;
	
	gForeGround : BOOLEAN;
	gEditEnable	: BOOLEAN;
	gCurMBAR	: INTEGER;
	gResStr		: Str255;
	Closing		: BOOLEAN;
	
	gNewSF		: BOOLEAN;	{ StandardGetFile /StandardPutFile présents ? }
	thePrefs	: PrefRec;
	
{$IFC Protection}
	compteur	: INTEGER;
	gTheProt	: ProtRec;
	gProt		: BOOLEAN;
	Vectors		: Handle;
{$ENDC}

{$IFC Antivir}
	BadAVIR		: BOOLEAN;
{$ENDC}
	gForceDrawBar: BOOLEAN;	{ force l'update de la barre de menus }
	
	gOkItem		: INTEGER;	{ item 'OK' du dialogue courant }
	gCancelItem	: INTEGER;	{ item 'Annuler' du dialogue courant }
	gGotoLine	: INTEGER;	{ dernière valeur pour le "Aller à la ligne N°" }
	gHandleFen	: BOOLEAN;	{ faut-il gérer les activate de fenêtres ? }
	gHasDrag	: BOOLEAN;
	
{$IFC Protection AND StopDebugger}
	PROCEDURE SuspendDebugger (saveSpaceH: Handle); EXTERNAL;
	PROCEDURE RestoreDebugger (saveSpaceH: Handle); EXTERNAL;
{$ENDC}

PROCEDURE SaveScreen; FORWARD;

{ FORWARD de la partie Vidéotex }
PROCEDURE MonWDraw; FORWARD;
PROCEDURE Checktaille; FORWARD;
PROCEDURE CheckAtt; FORWARD;
PROCEDURE DrawLine(NumCar1,NumCar2: integer); FORWARD;
PROCEDURE CalCar(n: integer; VAR i,j: integer; VAR R: Rect); FORWARD;
PROCEDURE InvalSel(SupInval,EolFlag: boolean); FORWARD;
PROCEDURE Curoff(QFenetre: WindowPtr); FORWARD;

PROCEDURE Memo; FORWARD;
PROCEDURE ShowAbout; FORWARD;
PROCEDURE HideAbout; FORWARD;
PROCEDURE ManageMenu; FORWARD;
PROCEDURE SelFen(QFenetre: WindowPtr); FORWARD;
PROCEDURE SaveSelFen; FORWARD;
PROCEDURE UnSelFen; FORWARD;
PROCEDURE MainEventLoop; FORWARD;
PROCEDURE DoBasic(TheItem: Integer); FORWARD;
PROCEDURE HandleEvent(theEvent:EventRecord); FORWARD;
PROCEDURE DoHandleEvent; FORWARD;
FUNCTION WMouseDown(where: INTEGER; QFenetre: WindowPtr; pt: Point; modifiers: INTEGER):BOOLEAN; FORWARD;
PROCEDURE EvenementMultiFinder; FORWARD;
PROCEDURE  CtrlAction (theControl: ControlHandle; partCode: INTEGER); FORWARD;
PROCEDURE SaveForUndo(curScreen:PtEcran); FORWARD;

(*
{ Returns a pointer to the Dialog Manager’s standard dialog filter }
FUNCTION GetStdFilterProc(VAR theProc: ProcPtr ): OSErr;
    INLINE $303C, $0203, $AA68;

{ Indicates to the Dialog Manager which item is default.  Will then alias the return & }
{ enter key }
{ to this item, and also bold border it for you (yaaaaa!) }        
FUNCTION SetDialogDefaultItem(theDialog: DialogPtr; newItem: INTEGER): OSErr; 
    INLINE $303C, $0304, $AA68;        

{ Indicates which item should be aliased to escape or Command - . }
FUNCTION SetDialogCancelItem(theDialog: DialogPtr; newItem: INTEGER): OSErr;
    INLINE $303C, $0305, $AA68;

{ Tells the Dialog Manager that there is an edit line in this dialog, and }
{ it should track and change to an I-Beam cursor when over the edit line }

FUNCTION SetDialogTracksCursor(theDialog: DialogPtr; tracks: Boolean):OSErr;
    INLINE $303C, $0306, $AA68 ;

FUNCTION StdFilterProc(theDialog:  DialogPtr; VAR theEvent:  EventRecord; VAR itemHit:  INTEGER) :  BOOLEAN;
	EXTERNAL;
*)
	

{$S UtilInit}
FUNCTION ShowColor:BOOLEAN;

BEGIN
	ShowColor := FALSE;
	IF TheMac.HasColorQD THEN
	BEGIN
		MacScreen := GetGDevice;
		IF MacScreen^^.gdpMap^^.pixelSize > 2 THEN ShowColor := TRUE;
	END;
END;


{$S UtilInit}
PROCEDURE Notify(msg:Str255; iconID:INTEGER);
{ affiche un message via le notification manager }
VAR Notif: NMRec;
	T: LONGINT;
	
BEGIN
	IF (gSystemVersion>$700) & NOT gForeGround THEN
	BEGIN
		WITH Notif DO
		BEGIN
			qType := ORD(nmType);
			nmMark := 1;
			nmIcon := GetIconFamily(256);
			nmSound := Handle(-1);
			nmStr := @Msg;
			nmResp := NIL;
			nmRefCon := 0;
		END;
		{ on installe la notification }
		Err := NMInstall(@notif);
		{ on attend 1 minute de repasser en premier plan }
		T := TickCount + 3600;	{ 1 minute }
		WHILE (T>TickCount) & NOT gForeGround DO DoHandleEvent;
		{ on supprime la notification }
		Err := NMRemove(@Notif);
		{ on libère la famille d'icônes }
		ReleaseIconFamily(notif.nmIcon);		
	END
	ELSE
		SysBeep(60);	{ un beep si: on est en premier plan ou pas sous Sys. 7 }
END;

{$S Main}
FUNCTION GetSelection:Str255;

VAR	s:Str255;

BEGIN
	GetSelection := '';
	IF Hte<>NIL THEN
	WITH Hte^^ DO
	BEGIN
		{ pas de sélection ou trop grande ! }
		IF (SelStart=SelEnd) OR (SelEnd-SelStart>128) THEN EXIT(GetSelection);
		BlockMoveData(Ptr(Ord4(CharsHandle(htext)^)+selStart),@s[1],SelEnd-SelStart);
		s[0] := chr(SelEnd-SelStart);
		GetSelection := s;
	END;
END;


{$S DIALOGS}
{ •••• GESTION DES DIALOGUES •••• }

FUNCTION Sys6Filter(currentDialog: DialogPtr; VAR theEventIn: EventRecord; VAR theItem: INTEGER): BOOLEAN;

CONST 
	kMyButtonDelay = 8;
	
VAR
  itemKind      : INTEGER;
  itemHandle    : Handle;
  itemRect      : Rect;
  savePort      : GrafPtr;
  waitTicks     : LONGINT;

	PROCEDURE SelectItem;
	
	BEGIN
		GetDItem(currentDialog, theItem, itemKind, itemHandle, itemRect);
		HiliteControl(ControlHandle(itemHandle), 1);
		Delay(kMyButtonDelay , waitTicks);
		HiliteControl(ControlHandle(itemHandle), 0);
		Sys6Filter := TRUE;
	END;
	
BEGIN
	Sys6Filter := FALSE;
	IF ((theEventIn.what = keyDown) OR (theEventIn.what = autoKey)) THEN
	CASE BAnd(theEventIn.message, charCodeMask) OF
		13, 10:	{ Return & Enter }
		BEGIN
			theItem := gOkItem;
			SelectItem;
		END;
		
		27:	{ Escape }
		BEGIN
			theItem := gCancelitem;
			SelectItem;
		END;
		
	END; {CASE}
END;


FUNCTION MyFilter(theDialog: DialogPtr;VAR theEvent: EventRecord;VAR itemHit: INTEGER) :  BOOLEAN;

BEGIN
	itemHit := 0;
	CASE theEvent.what OF
		UpdateEvt,ActivateEvt:
			HandleEvent(theEvent);
		
		MouseDown:
			BEGIN
				Wh := FindWindow(theEvent.where, QFenetre);
				CASE Wh OF
				inDrag:
					IF (QFenetre=FrontWindow) & (WMouseDown(Wh, QFenetre, theEvent.where,theEvent.modifiers)) THEN;
				inContent:
					IF QFenetre=FrontWindow THEN
					BEGIN
						IF theMac.SystemVersion>=$700 THEN
							MyFilter := StdFilterProc(theDialog,theEvent,itemHit)
						ELSE
							MyFilter := Sys6Filter(theDialog,theEvent,itemHit);
					END;
				END;  {* Case *}
			END;  {* Mousedown *}

		KeyDown, AutoKey:
			IF theMac.SystemVersion>=$700 THEN
				MyFilter := StdFilterProc(theDialog,theEvent,itemHit)
			ELSE
				MyFilter := Sys6Filter(theDialog,theEvent,itemHit);
		
	END;
END;


PROCEDURE MyModalDialog(filterProc:Ptr; VAR itemHit:INTEGER);

BEGIN
	itemHit := 0;
	REPEAT
		IF WaitNextEvent(everyEvent,monEvent,0,NIL) THEN
		BEGIN
			Wh := FindWindow (monEvent.where, QFenetre); 
			IF MyFilter(QFenetre, monEvent,itemHit) THEN;
		END;
	UNTIL itemHit<>0;
END;



PROCEDURE DrawButtonOutline(theDialog:DialogPtr);

VAR thePen: PenState;
	itemH: Handle;
	leRect: Rect;
	car: INTEGER;
	
BEGIN
	IF gOkItem<>0 THEN
	BEGIN
		GetDitem(theDialog,gokItem,car,itemh,lerect);
		SetPort(theDialog);
		GetPenState(thePen);
		PenSize(3,3); InsetRect(lerect,-4,-4);
		FrameRoundRect(lerect,16,16);
		SetPenState(thePen);
	END;
END;


PROCEDURE DialogBegin(theDialog:DialogPtr; okItem,CancelItem: INTEGER; hasEditText:BOOLEAN);

BEGIN
	DrawDialog(theDialog);
	IF theMac.SystemVersion>=$700 THEN	{ système 7… }
	BEGIN
		IF okItem>0 THEN Err := SetDialogDefaultItem(theDialog, okItem);                                            
		IF cancelItem>0 THEN Err := SetDialogCancelItem(theDialog, CancelItem);
		Err := SetDialogTracksCursor(theDialog, hasEditText);
	END;

	gOkItem := okItem;
	gCancelItem := cancelItem;
	DrawButtonOutline(theDialog);
	SetCursor(qd.arrow);
END;


PROCEDURE DialogEnd(theDialog:DialogPtr);

BEGIN
	IF theMac.SystemVersion>=$700 THEN	{ système 7… }
	BEGIN
		Err := SetDialogDefaultItem(theDialog, 0);                                            
		Err := SetDialogCancelItem(theDialog, 0);
	END;
	DisposDialog(theDialog);
	gOkItem := 0;
	gCancelItem := 0;
END;


{$S UPDATE}
PROCEDURE UpdateExtDlog;

VAR
	i			: INTEGER;
	theCell		: Cell;
	Name		: Str255;
	Message		: Str255;
	R			: Rect;
	theResource	: Handle;
	dataLen		: INTEGER;
	SaveRes		: INTEGER;
	
BEGIN
	IF ExtDlog = NIL THEN EXIT(UpdateExtDlog);
	SaveRes := CurResFile;
	SetPt(Cell(theCell),0,0);
	ParamText('','','','');
	IF LGetSelect(TRUE,theCell,ExtList) THEN
	BEGIN
		dataLen := 255;	{ taille de Name }
		LGetCell(@Name[1],dataLen,theCell,ExtList);
		Name[0] := CHR(dataLen);

		SetResLoad(FALSE);
		Message := '';
		theResource := NIL;
		UseResFile(SaveRes);
		theResource := GetNamedResource('DEXT',Name);
		IF theResource = NIL THEN
		  FOR i := 0 TO NbExtFiles DO
		  BEGIN
			  UseResFile(ExtFiles[i]);
			  theResource := GetNamedResource('DEXT',Name);
			  IF theResource <> NIL THEN Leave;
		  END;
		IF theResource <> NIL THEN
		BEGIN
			NumToString(SizeResource(theResource),Message);
		END;
		ParamText(Message,'','','');
		
		SetResLoad(TRUE);
		{ Affichage du message d'aide }
		Message := '';
		UseResFile(SaveRes);
		theResource := GetNamedResource('DHLP',Name);
		IF theResource = NIL THEN
		  FOR i := 0 TO NbExtFiles DO
		  BEGIN
			  UseResFile(ExtFiles[i]);
			  theResource := GetNamedResource('DHLP',Name);
			  IF theResource <> NIL THEN Leave;
		  END;
		IF theResource <> NIL THEN
		BEGIN
			BlockMoveData(theResource^,@Message[0],SizeResource(theResource));
			ReleaseResource (theResource);
		END;
		IF Message = '' THEN GetIndString(Message,rSTRErrors,6);
		TextFont(Geneva);
		TextSize(9);
		TextBox(@Message[1], Length(Message), ExtRect2,teJustLeft);
		TextFont(SystemFont);
		TextSize(12);
	END;
	
	DrawDialog(ExtDLOG);
	
	{ on trace le cadre autour de la liste }
	R := ExtList^^.rView;
	InSetRect(R,-1,-1);
	FrameRect(R);
	UseResFile(SaveRes);
END;


{$S DIALOGS}
PROCEDURE OptCompilDLOG(SaveModif:BOOLEAN);

VAR
	TempValue: INTEGER;
	itemH: Handle;
	leRect: Rect;
	itemHit,car: INTEGER;
	theDialog: DialogPtr;
	
BEGIN
	theDialog := GetNewDialog(rOptCompDLOG,NIL,POINTER(-1));		
	
	GetDitem(theDialog,3,car,itemh,lerect);
	SetCtlValue(ControlHandle(itemH),LONGINT(IncList));
	
	GetDitem(theDialog,4,car,itemh,lerect);
	SetCtlValue(ControlHandle(itemH),LONGINT(CLVarFlag));
	
	GetDitem(theDialog,5,car,itemh,lerect);
	SetCtlValue(ControlHandle(itemH),LONGINT(CMVarFlag));
	
	GetDitem(theDialog,6,car,itemh,lerect);
	SetCtlValue(ControlHandle(itemH),LONGINT(NamesFlag));
	
	GetDitem(theDialog,7,car,itemh,lerect);
	SetCtlValue(ControlHandle(itemH),LONGINT(IncLine));
	
	GetDitem(theDialog,8,car,itemh,lerect);
	SetCtlValue(ControlHandle(itemH),LONGINT(IncInst));
	
	GetDitem(theDialog,9,car,itemh,lerect);
	SetCtlValue(ControlHandle(itemH),LONGINT(IncCheck));
	
	GetDitem(theDialog,10,car,itemh,lerect);
	SetCtlValue(ControlHandle(itemH),LONGINT(PreCompOverRide));
	
	CenterDlog(theDialog);
	DialogBegin(theDialog,1,2,FALSE);
	
	REPEAT
		{ inclu N° ligne si inclu N° instruction }
		GetDitem(theDialog,8,car,itemh,lerect);
		TempValue := GetCtlValue(ControlHandle(itemh));
		GetDitem(theDialog,7,car,itemh,lerect);
		IF TempValue = 1 THEN SetCtlValue(ControlHandle(itemh),TempValue);
		HiliteControl(ControlHandle(itemH),255*TempValue);
		
		ModalDialog(@MyFilter,itemHit);
		CASE itemHit OF
		3..10:
			BEGIN
				GetDitem(theDialog,itemHit,car,itemh,lerect);
				TempValue := GetCtlValue(ControlHandle(itemh));
				SetCtlValue(ControlHandle(itemh),1-TempValue);
			END;
		END;
		
	UNTIL (itemHit = 1) OR (itemHit = 2);
	IF itemHit = 1 THEN BEGIN	
		GetDitem(theDialog,3,car,itemh,lerect);
		IncList := BOOLEAN(GetCtlValue(ControlHandle(itemh)));

		GetDitem(theDialog,4,car,itemh,lerect);
		CLVarFlag := BOOLEAN(GetCtlValue(ControlHandle(itemh)));

		GetDitem(theDialog,5,car,itemh,lerect);
		CMVarFlag := BOOLEAN(GetCtlValue(ControlHandle(itemh)));

		GetDitem(theDialog,6,car,itemh,lerect);
		TempValue := GetCtlValue(ControlHandle(itemh));
		NamesFlag := (TempValue=1);
		
		GetDitem(theDialog,7,car,itemh,lerect);
		IncLine := BOOLEAN(GetCtlValue(ControlHandle(itemh)));

		GetDitem(theDialog,8,car,itemh,lerect);
		IncInst := BOOLEAN(GetCtlValue(ControlHandle(itemh)));

		GetDitem(theDialog,9,car,itemh,lerect);
		IncCheck := BOOLEAN(GetCtlValue(ControlHandle(itemh)));

		GetDitem(theDialog,10,car,itemh,lerect);
		PreCompOverRide := BOOLEAN(GetCtlValue(ControlHandle(itemh)));

		IF SaveModif THEN
		WITH thePrefs DO
		BEGIN
		  Flag[4]:=CMVarFlag;
		  Flag[5]:=NamesFlag;
		  Flag[6]:=IncLine;
		  Flag[7]:=IncInst;
		  Flag[8]:=IncCheck;
		  Flag[9]:=IncList;
		  Flag[10]:=PreCompOverRide;
		  Flag[11] := FALSE;
		  Flag[12] := FALSE;
		  Flag[13] := FALSE;
		  Flag[14] := FALSE;
		  Flag[15] := FALSE;
		END;
	END;
	
	DialogEnd(theDialog);
END;


{$S DIALOGS}
PROCEDURE OptAnalysDLOG;

VAR
	theDialog: DialogPtr;
	itemH: Handle;
	leRect: Rect;
	car: INTEGER;
	itemHit: INTEGER;
	
BEGIN
	theDialog := GetNewDialog(rOptAnalysDLOG,NIL,POINTER(-1));		

	GetDitem(theDialog,3,car,itemh,lerect);
	SetCtlValue(ControlHandle(itemH),LONGINT(VLstFlag));
	
	GetDitem(theDialog,4,car,itemh,lerect);
	SetCtlValue(ControlHandle(itemH),LONGINT(ELstFlag));
	
	GetDitem(theDialog,5,car,itemh,lerect);
	SetCtlValue(ControlHandle(itemH),LONGINT(CLstFlag));
	
	CenterDlog(theDialog);
	DialogBegin(theDialog,1,2,FALSE);
	
	REPEAT
		ModalDialog(@MyFilter,itemHit);
		CASE itemHit OF
		3..5: BEGIN
				GetDitem(theDialog,itemHit,car,itemh,lerect);
				SetCtlValue(ControlHandle(itemh),1-GetCtlValue(ControlHandle(itemh)));
			END;
		END;
	UNTIL (itemHit = 1) OR (itemHit = 2);
	
	IF itemHit = 1 THEN BEGIN	
		GetDitem(theDialog,3,car,itemh,lerect);
		VLstFlag := BOOLEAN(GetCtlValue(ControlHandle(itemh)));

		GetDitem(theDialog,4,car,itemh,lerect);
		ELstFlag := BOOLEAN(GetCtlValue(ControlHandle(itemh)));

		GetDitem(theDialog,5,car,itemh,lerect);
		CLstFlag := BOOLEAN(GetCtlValue(ControlHandle(itemh)));
	END;
	
	DialogEnd(theDialog);
END;


{$S DIALOGS}
PROCEDURE ConfServ;
VAR
        Temp		    : INTEGER;
        monDialog	    : DialogPtr;
        i,tp	  	 	: integer;
        ith		   		: handle;
        box		   		: rect;
        x0,x1,x2	    : byte;
        STemp, BTemp    : str255;
        Li		    	: Longint;
		
BEGIN
	monDialog := GetNewDialog (260, NIL, POINTER (-1));
	LoadResource(Handle(ConFH));
	HnoPurge(Handle(ConFH));

	FOR temp:=3 TO 9 DO
	BEGIN
	  GetDItem(monDialog,temp,Tp,ith,Box);
	  SetCtlValue(ControlHandle(ith),0);
	END;

	x0:=ConfH^^[0];	{ emulateur ou modem ? }
	x1:=ConfH^^[1];	{ port modem ou imprimante }
	x2:=ConfH^^[2];	{ type d'émulation }
	IF (x2<0) OR (x2>2) THEN x2:=1;
	
 	GetDItem(monDialog,3+x0,Tp,ith,Box);
	SetCtlValue(ControlHandle(ith),1);

 	GetDItem(monDialog,5+x1,Tp,ith,Box);
	SetCtlValue(ControlHandle(ith),1);

 	GetDItem(monDialog,7+x2,Tp,ith,Box);
	SetCtlValue(ControlHandle(ith),1);

	CenterDlog(MonDialog);
	DialogBegin(MonDialog,1,2,FALSE);
	
	REPEAT
		FOR i := 5 TO 6 DO
		BEGIN
			GetDItem(monDialog,i,Tp,ith,Box);
			HiliteControl(ControlHandle(ith),255*(1-x0));
		END;
		
		FOR i := 7 TO 9 DO
		BEGIN
			GetDItem(monDialog,i,Tp,ith,Box);
			HiliteControl(ControlHandle(ith),255*(x0));
		END;
		
		ModalDialog (@MyFilter, Temp);
		CASE Temp OF
		3..4: IF Temp<>3+x0 THEN
			BEGIN
				GetDItem(monDialog,3+x0,Tp,ith,Box);
				SetCtlValue(ControlHandle(ith),0);
				x0:=Temp-3;
				GetDItem(monDialog,3+x0,Tp,ith,Box);
				SetCtlValue(ControlHandle(ith),1);
			END;
			
		5..6: IF Temp<>5+x1 THEN
			BEGIN
				GetDItem(monDialog,5+x1,Tp,ith,Box);
				SetCtlValue(ControlHandle(ith),0);
				x1:=Temp-5;
				GetDItem(monDialog,5+x1,Tp,ith,Box);
				SetCtlValue(ControlHandle(ith),1);
			END;
			
		7..9: IF Temp<>7+x2 THEN
			BEGIN
				GetDItem(monDialog,7+x2,Tp,ith,Box);
				SetCtlValue(ControlHandle(ith),0);
				x2:=Temp-7;
				GetDItem(monDialog,7+x2,Tp,ith,Box);
				SetCtlValue(ControlHandle(ith),1);
			END;
			
		END;	{ CASE }
		 
	UNTIL (Temp = 1) OR (Temp = 2);

	DialogEnd(monDialog);

	IF Temp=2 THEN	{ ANNULER }
	BEGIN
		 HPurge(Handle(ConFH));
		 EXIT(ConfServ);
	END;

	IF (x0<>ConfH^^[0]) OR (x1<>ConfH^^[1]) OR (x2<>ConfH^^[2]) THEN
	BEGIN
		EmulFlag := (x0=0);
		EmulType := x2;
		IF EmulFlag THEN StopIO;
		IF (x0=1) & ((ConfH^^[1]<>x1) | (x0<>ConfH^^[0])) THEN
		BEGIN
			ConfH^^[0]:=x0;
			ConfH^^[1]:=x1;
			InitSerial(Chr(Ord('A')+x1));
			IF EmulFlag THEN x0:=0;	{ Retour en émulation }
		END;
		ConfH^^[0]:=x0;
		ConfH^^[2]:=x2;
		ChangedResource(Handle(ConFH));
		WriteResource(Handle(ConFH));
	END;
	IF EmulFlag THEN SnFlag := FALSE;
	HPurge(Handle(ConFH));
END;


{$S Main}
PROCEDURE UpdateWindMenu;

VAR
	TheWind: WindowPeek;
	TheTitle: Str255;
	NbWind: INTEGER;
	i: INTEGER;
	theMenu: MenuHandle;
	
BEGIN
	theMenu := GetMHandle(FenMenu);
	
	{ on efface la liste précédente }
	FOR i := OffWindows TO CountMItems(TheMenu)
		DO DelMenuItem(theMenu,OffWindows);

	LastFenItem := 0;
	
	{ on ajoute la liste des fenêtres si il y en a }
	IF FrontWindow <> NIL THEN
	BEGIN
		AppendMenu(theMenu,'-(');	{ ligne de séparation }
		TheWind := WindowPeek(FrontWindow);
		NbWind := OffWindows;
		REPEAT
			GetWTitle(WindowPtr(TheWind),TheTitle);
			IF TheWind^.visible THEN
			BEGIN
				AppendMenu(theMenu,' ');
				nbWind := nbWind + 1;
				LastFenItem := LastFenItem +1;
				IF theTitle[1]='-' THEN theTitle := concat(CHAR(0),theTitle);
				SetItem(theMenu,nbWind,TheTitle);
			END;
			TheWind := TheWind^.nextWindow;
		UNTIL TheWind = NIL;
	END;
END;


{$ UPDATE}
PROCEDURE ChooseWindow(Theitem:INTEGER);

VAR
	TheWind		: WindowPtr;
	TheTitle	: Str255;
	TheChoice	: Str255;
	
BEGIN
	GetItem(GetMHandle(FenMenu),TheItem,TheChoice);
	IF theChoice[1]=CHAR(0) THEN Delete(theChoice,1,1);
	
	TheWind := FrontWindow;
	WHILE TheWind <> NIL DO
	BEGIN
		GetWTitle(TheWind,TheTitle);
		IF TheChoice = TheTitle THEN
		BEGIN
			SelectWindow(TheWind);
			Leave;
		END;
		TheWind := WindowPtr(WindowPeek(TheWind)^.nextWindow);
	END;
END;


{$ INIT}
{$S INIT}
PROCEDURE GetPrefs;

VAR
	PrefRes: Handle;
	
BEGIN
	PrefRes := Get1Resource('PREF',128);
	IF (PrefRes = NIL)
	 | (SizeResource(PrefRes)<>SizeOf(PrefRec))
	 | (PrefHdl(PrefRes)^^.PrefVersion <> 1) THEN 
	BEGIN
		SetRect(PosTrace,20,200,420,340);
{$IFC EMUL}
		SetRect(PosEmul,26,54,488,322);
{$ENDC}
		SetRect(PosExt,60,86,404,286);
		SetRect(PosCherche,0,0,0,0);
		SetRect(PosCompil,0,0,0,0);
		
		WITH thePrefs DO
		BEGIN
			W1 := PosTrace;
			W2 := PosEmul;
			W3 := PosEmul;
			W4 := PosCherche;
			W5 := PosCompil;
		END;
	END
	ELSE
	BEGIN
		Hlock(PrefRes);
		WITH PrefHdl(PrefRes)^^ DO
		BEGIN
			IF NOT EqualRect(qd.ScreenBits.Bounds,PrefHdl(PrefRes)^^.Ecran) THEN
			BEGIN
				{ attention ! la taille d'écran a changé }
				SetRect(PosTrace,20,200,420,340);
{$IFC EMUL}
				SetRect(PosEmul,26,54,488,322);
{$ENDC}
				SetRect(PosExt,60,86,404,286);
				SetRect(PosCherche,0,0,0,0);
				SetRect(PosCompil,0,0,0,0);
			END
			ELSE
			BEGIN
	 			IF GoodWindow(W1) THEN PosTrace := W1 ELSE SetRect(PosTrace,20,200,420,340);
				IF GoodWindow(W3) THEN PosExt := W3 ELSE SetRect(PosExt,60,86,404,286);
{$IFC EMUL}
				IF GoodWindow(W2) THEN PosEmul := W2 ELSE SetRect(PosEmul,26,54,488,322);
{$ENDC}
				IF GoodWindow(W4) THEN PosCherche := W4 ELSE SetRect(PosCherche,0,0,0,0);
				IF GoodWindow(W5) THEN PosCompil := W5 ELSE SetRect(PosCompil,0,0,0,0);
			END;
			
			WVidFlag:=Flag[1];
			WErrFlag:=Flag[2];
			Trace2Flag := Flag[3];
			CMVarFlag:=Flag[4];
			NamesFlag := Flag[5];
			IncLine:=Flag[6];
			IncInst:=Flag[7];
			IncCheck:=Flag[8];
			IncList:=Flag[9];
			PreCompOverRide := Flag[10];
			
			thePrefs := PrefHdl(PrefRes)^^;
			
			ReleaseResource(PrefRes);
		END;
	END;
END;	{ GetPrefs }


{$S Main}
PROCEDURE SavePrefs;

VAR
	PrefRes: Handle;
	i: INTEGER;
	apName: Str255;
	apRefNum: INTEGER;
	apParam: Handle;
	
BEGIN
	i:= CurResFile;
	GetAppParms(apName,apRefNum,apParam);
	UseResFile(apRefNum);	{ on conserve la pos. des fenêtres dans l'appli ! }
	PrefRes := Get1Resource('PREF',128);
	IF PrefRes <> NIL THEN RmveResource(PrefRes);
	PrefRes := NewHandle(sizeOf(PrefRec));
	HLock(PrefRes);
	AddResource(PrefRes,'PREF',128,'');
	PrefHdl(PrefRes)^^:=thePrefs;
	WITH PrefHdl(PrefRes)^^ DO
	BEGIN
		PrefVersion := 1;
		Ecran := qd.ScreenBits.Bounds;
		W1 := PosTrace;
		W3 := PosExt;
{$IFC EMUL}
		W2 := PosEmul;
{$ENDC}
		W4 := posCherche;
		W5 := PosCompil;
		
		Flag[1]:=WVidFlag;
		Flag[2]:=WErrFlag;
		Flag[3]:=Trace2Flag;
	END;
	ChangedResource(PrefRes);
	IF ResError <> NoErr THEN sysBeep(60);
	HUnlock(PrefRes);
	UseResFile(i);
END;	{ SavePrefs }



{$IFC Protection}

{$S Main}
FUNCTION ValidateConf:LONGINT;
	
BEGIN
	ValidateConf := BXor(BXor(gTheProt.compteur * 7,gTheProt.date),4397);
END;
		
		
{$S INIT}
PROCEDURE GetConfig2;
		
VAR
	apName: Str255;
	apRefNum: INTEGER;
	apParam: Handle;

BEGIN
	UseResFile(gAppRefNum);
	Hdl := GetResource(ProtResType,ProtResID);
	IF (Hdl = NIL) | (HomeResFile(Hdl)<>gAppRefNum) THEN
	WITH gTheProt DO
	BEGIN
		version := 1;
		compteur := bXor(LONGINT(0),4397);
		Err := ReadDateTime(gtheProt.Date);
		gtheProt.Date := BXor(gtheProt.Date,94100);
		key := ValidateConf;
		EXIT(GetConfig2);
	END;
		
	IF GetHandleSize(Hdl)<>SizeOf(ProtRec) THEN EXIT(DragsterEdit);
	IF Hdl <> NIL THEN
	BEGIN
		Hlock(Handle(Hdl));
		WITH ProtHdl(Hdl)^^ DO
		BEGIN
			IF version = 1 THEN gTheProt := ProtHdl(Hdl)^^;
			IF ValidateConf <> gTheProt.key THEN EXIT(DragsterEdit);
		END;
		HUnlock(Handle(Hdl));
	END;
	ReleaseResource(Hdl);
	Hdl := NewHandle(0);
	AddResource(Hdl, ProtResType, ProtResIDTest,'');
	i := ResError;
	RmveResource(Hdl);
	UpdateResFile(gAppRefNum);
END;

{$S Main}
PROCEDURE SaveConfig2;

VAR
	hRestheConfig : Handle;
	i: INTEGER;

BEGIN
	i:= CurResFile;
	hRestheConfig := GetResource(ProtResType,ProtResID);
	IF (hRestheConfig = NIL) | (HomeResFile(hRestheConfig)<>gAppRefNum) THEN
		BEGIN
			hRestheConfig := NewHandle(sizeOf(ProtRec));
			AddResource(hRestheConfig,ProtResType,ProtResID,ProtResName);
		END;
	ProtHdl(hRestheConfig)^^:=gTheProt;
	ChangedResource(hRestheConfig);
	UpdateResFile(gAppRefNum);
	UseResFile(i);
END;

{$ENDC}



{$S IMPRESSION}
PROCEDURE DoPageSetUp;

BEGIN
    PrOpen;                                {open the driver}
    IF PrError = noErr THEN BEGIN          {check the error}
	   IF PrValidate(PrintHdl) THEN;
       IF PrStlDialog(PrintHdl) THEN; {call the dialog}
    END;
    PrClose;                               {close the driver}
END;



{$S IMPRESSION}
PROCEDURE DoPrint;

CONST
	PageTop		= 40;	{ place pour le titre en haut de page }
	
VAR	oldPort		: GrafPtr;
	printPort	: TPPrPort;
	PrintStatus	: TPrStatus;
	page		: INTEGER;
	maxpage		: INTEGER;
	oldRect1	: Rect;
	oldRect2	: Rect;
	DateTime	: LONGINT;
	Chaine		: Str255;
	DateHeure	: Str255;
	
	FUNCTION TotalPages:INTEGER;	{ calcule dernière page à imprimer… }
	
	BEGIN
		WITH Screen^,PrintHdl^^ DO
		BEGIN
			TotalPages := (hte^^.nLines DIV ((prInfo.rpage.bottom-PageTop) DIV hte^^.LineHeight)) +1;
		END;
	END;
	

	PROCEDURE PrintPage(Page:INTEGER);
	
	VAR	Str			: Str255;
		NbLignes	: INTEGER;
		Ligne		: INTEGER;
		Hauteur		: INTEGER;
		Last		: INTEGER;
		First		: INTEGER;
		
		FUNCTION TextLine(ligne:INTEGER):Str255;
		
		VAR	Text		: Str255;
			Debut,Fin	: INTEGER;
			TE			: TEHandle;
			
		BEGIN
			HLock(Handle(Screen^.hte));
			TE := Screen^.hte;
			WITH Screen^.hte^^ DO
			BEGIN
				Text := '';
				Debut := lineStarts[ligne-1];	{ début de la ligne }
				Fin := lineStarts[ligne];		{ fin de la ligne }
				IF Fin = -1 THEN Fin := teLength;
				IF Fin-Debut>255 THEN Fin := Debut+255;	{ 255 car. par ligne maxi. }
				IF Fin-Debut>0 THEN	{ ligne non vide ? }
				BEGIN
					BlockMoveData(Ptr(Ord4(hText^)+Debut-1),@Text[0],ord(Fin-Debut+1));
					
					IF (ligne>1) & (Text[0]<>chr(13)) THEN	{ suite d'une ligne précédente ? }
					BEGIN
						Text[0] := chr(Fin-Debut);
						Text := concat('…',Text);
					END
					ELSE Text[0] := CHR(Fin-Debut);
					
					IF Text[ORD(Text[0])] = CHR(13) THEN	{ ligne incomplète ? }
						Text[0] := PRED(Text[0])			{ fin de ligne normale }
					ELSE
						Text[ORD(Text[0])]:='…';			{ suite à la ligne suivante }
				END;
			END;
			TextLine := Text;
			HUnlock(Handle(Screen^.hte));
		END;
		
		
		FUNCTION IsEtiq(ligne:Str255):BOOLEAN;
		{ indique si une ligne ne contient qu'une étiquette… }
		
		VAR i:INTEGER;
			etat:INTEGER;
			
		BEGIN
			etat := 0;
			FOR i := 1 TO Length(ligne) DO
			BEGIN
				IF (Etat=0) & (ligne[i] IN ['A'..'Z','a'..'z']) THEN Etat := 1	{ début ou milieu d'un étiq. }
				ELSE
				IF (Etat=1) & (ligne[i] IN ['0'..'9','_']) THEN Etat := 1	{ suite d'une étiq }
				ELSE
				IF (Etat=1) & (ligne[i]=':') THEN Etat := 2 	{ fin d'une étiq }
				ELSE
				IF (Etat=1) & NOT(ligne[i] IN ['A'..'Z','a'..'z','0'..'9','_']) THEN Etat := 3
				ELSE
				IF (Etat=2) & (ligne[i]<>' ') THEN Etat :=3;		{ plus qu'une étiquette ! }
				IF Etat=3 THEN Leave;
			END;
			IsEtiq:=(etat=2);
		END;
		
		
	BEGIN
		WITH Screen^ DO BEGIN
			Hauteur := hte^^.lineheight;
			NbLignes := (PrintHdl^^.prInfo.rpage.bottom-PageTop) DIV Hauteur -1;
			First := (Page-1) * NbLignes;
			Ligne := First+1;
			Last := hte^^.nlines + 1;
			IF Ligne + NbLignes < Last THEN Last := Ligne + NbLignes;
			
			TextFont(hte^^.txFont);	{ Monaco }
			TextSize(hte^^.txSize);	{ 9 points }
			TextFace([Bold]);
			
			MoveTo(0,20);
			DrawString(Screen^.fileName);
			
			MoveTo((PrintHdl^^.prInfo.rpage.right - StringWidth(Chaine)) DIV 2,20);
			DrawString(DateHeure);

			NumToString(Page,Str);
			GetIndString(gResStr,rSTRErrors,9);
			Str := concat(gResStr,Str);
			MoveTo(PrintHdl^^.prInfo.rpage.right - StringWidth(str),20);
			DrawString(Str);
			
			WHILE Ligne < Last DO
			BEGIN
				MoveTo(0,PageTop + (Ligne-First) * Hauteur);
				Chaine := TextLine(Ligne);
				IF IsEtiq(Chaine) THEN TextFace([Bold]) ELSE TextFace([]);
				DrawString(Chaine);
				Ligne := Ligne + 1;
			END;
	
		END;
	END;


BEGIN
	SaveSelFen;
	PrOpen;
	IF PrError = noErr THEN BEGIN
		IF PrValidate(PrintHdl) THEN;
		IF PrJobDialog(PrintHdl) THEN WITH PrintHdl^^ DO
		BEGIN
			GetPort(oldPort);						{save port for later}
			IF PrError = noErr THEN BEGIN
				printPort := PrOpenDoc(PrintHdl, NIL, NIL); {open printing grafPort}
				
				{ on recalcule le texte en fonction du rectangle d'impression… }
				oldRect1 := Hte^^.DestRect;
				oldRect2 := hTE^^.ViewRect;
				Hte^^.DestRect := PrintHdl^^.prInfo.rpage;
				InsetRect(Hte^^.DestRect,carWid,0);
				Hte^^.ViewRect := PrintHdl^^.prInfo.rpage;
				Hte^^.crOnly := 0;	{ retour à la ligne même sans CR }
				TECalText(hte);
				
				GetDateTime(DateTime);
				IUDateString (dateTime, ShortDate,Chaine);
				IUTimeString (dateTime, TRUE,DateHeure);
				DateHeure := Concat(Chaine,' ',DateHeure);

				FOR page := 1 TO TotalPages DO BEGIN
					PrOpenPage(printPort,NIL);
					IF PrError = noErr THEN PrintPage(page);
					PrClosePage(printPort);
				END;
				
				{ on recalcule le texte pour le rectangle d'édition normal… }
				Hte^^.DestRect := oldRect1;
				Hte^^.ViewRect := oldRect2;
				Hte^^.crOnly := -1;
				TECalText(Hte);
				
				PrCloseDoc(printPort);
				IF (PrError = noErr) AND (prJob.bJDocLoop = bSpoolLoop) THEN
				PrPicFile(PrintHdl, NIL, NIL, NIL, PrintStatus);{print spooled document}
			END;  {IF}
			SetPort(oldPort);                    {set my port back}
		END;
	END;
	PrClose;
END;


{$S Main}
{========================================================================
                          U T I L I T A I R E S
 ========================================================================}
PROCEDURE ErrorManager(Error: OsErr; from: integer);
    CONST Debug = False;
    VAR
        Temp		    : INTEGER;
        monDialog	    : DialogPtr;
        ErrorStr,
        TempS		    : str255;
BEGIN
    GetIndString(gResStr,rSTRErrors,10);
	WWriteStr(gResStr);
	WWriteNum(Error,0);
    GetIndString(gResStr,rSTRErrors,11);
	WWriteStr(gResStr);
	WWlnNum(From,0);
    CASE Error OF
        DirFulErr:  GetIndString(ErrorStr,rSTRErrors,1);
        DskFulErr:  GetIndString(ErrorStr,rSTRErrors,2);
        WPrErr	 :  GetIndString(ErrorStr,rSTRErrors,3);
		BackErr	 :  GetIndString(ErrorStr,rSTRErrors,5);
        OTHERWISE
          BEGIN
            NumToString(Error,TempS);
            GetIndString(ErrorStr,rSTRErrors,4);
            ErrorStr:=Concat(ErrorStr,' ',TempS);
          END;
    END;
    ParamText(ErrorStr,'','','');
    monDialog := GetNewDialog (257, NIL, POINTER (-1));
    CenterDlog(monDialog);
	DialogBegin(monDialog,1,1,FALSE);
	REPEAT
      ModalDialog (@MyFilter, Temp);
    UNTIL Temp = 1;
    DialogEnd(monDialog);
END;


{$S Main}
PROCEDURE Swapint(VAR i,j: integer);
    VAR temp: integer;
BEGIN
    temp:=i;
    i:=j;
    j:=temp;
END;


{$S Main}
{========================================================================
                            S E T P R E C T
 ========================================================================}
PROCEDURE  SetpRect (QFenetre: WindowPtr);

CONST   LgScroll    = 16;

BEGIN
    TeRect := QFenetre^.portRect;
    TeRect.right := TeRect.right - LgScroll;
    TeRect.bottom := TeRect.bottom - LgScroll;
    InsetRect (TeRect, 4, 0);
    Largeur := (TeRect.right - TeRect.left) DIV CarWid;
END;  {* Setprect *}


{========================================================================
                            F O C A L H T E
 ========================================================================}
PROCEDURE FocalHTE(AutoScroll:BOOLEAN);

VAR	i: INTEGER;
	dv: INTEGER;
	dh: INTEGER;
	pv,ph: INTEGER;
	p1,p2: Point;
	
BEGIN
	dh:=0;
	dv:=0;
    SetPRect(FrontWindow);
    { mise à jour ascenseur vertical }
    HLock(Handle(Hte));
	WITH Hte^^ DO
	BEGIN
		i:=nlines - ((TeRect.bottom - TeRect.top) DIV lineHeight) + 2;
		IF i<0 THEN
		BEGIN
			SetCtlMax(MonControl[1],0);
			dv := -destRect.top;
		END
		ELSE
		BEGIN
			SetCtlMax(MonControl[1],i);
			IF AutoScroll THEN	{ on doit scroller le texte… }
			BEGIN
				p1 := TEGetPoint(selStart,hte);
				p2 := TEGetPoint(selEnd,hte);
				
				{ scrolling vertical ??? }
				IF p1.v-lineHeight < viewRect.top THEN
					dv := -(p1.v-lineHeight)
				ELSE
					IF p2.v+lineHeight>viewRect.bottom THEN dv := -((p2.v+lineHeight-viewRect.bottom) DIV lineHeight) * lineHeight;

				{ scrolling horizontal ??? }
				IF p1.h < viewRect.left THEN
					dh := (1+(viewRect.left-p1.h) DIV (CarWid*10)) * (CarWid*10)
				ELSE
					IF p2.h>viewRect.right THEN dh := -(1+(p2.h-viewRect.right) DIV (CarWid*10)) * (CarWid*10);
			END;
		END;
		
		IF (dv<>0) | (dh<>0) THEN TEScroll(dh,dv,hte);
		
		SetCtlMax(MonControl[2],180);
		Numero[1] := (-destRect.top) DIV lineHeight;
		SetCtlValue(MonControl[1],Numero[1]);
		Numero[2] := ((-destRect.left+CarWid-1) DIV CarWid);
		SetCtlValue(MonControl[2],Numero[2]);
		IF Screen<>Nil THEN Screen^.Numero:=Numero;
	END;
END;

(*
PROCEDURE FocalHTE(AutoScroll:BOOLEAN);

VAR	i: INTEGER;
	dv: INTEGER;
	dh: INTEGER;
	pv,ph: INTEGER;
	
BEGIN
	dh:=0;
	dv:=0;
    SetPRect(FrontWindow);
    { mise à jour ascenseur vertical }
    WITH Hte^^ DO
	BEGIN
		i:=(nlines +2)*lineheight;
		If i<(teRect.Bottom-teRect.Top) then
		BEGIN
			SetCtlMax(MonControl[1],0);
			TEScroll(0, -destRect.top,hTE);
		END
		ELSE
			SetCtlMax(MonControl[1],i);

		SetCtlMax(MonControl[2],180);

		IF AutoScroll THEN
		BEGIN
			IF (selrect.right>viewRect.right) THEN dh := (viewRect.right-selrect.right) mod (4*CarWid);
			if (selRect.left<viewRect.left) THEN dh := (viewRect.left-selrect.left) mod (4*CarWid);
			IF (selrect.bottom>viewRect.bottom) THEN dv := viewRect.bottom-selrect.bottom;
			if (selRect.top<viewRect.top) THEN dv := viewRect.top-selrect.top;
			IF (dv<>0) | (dh<>0) THEN TEScroll(dh,dv,hte);
			SetCtlValue(MonControl[1],GetCtlValue(Moncontrol[1])+dv);
			SetCtlValue(MonControl[2],GetCtlValue(Moncontrol[2])+dh);
		END;
		
	END;
END;
*)


PROCEDURE UpdateScrolls(QFenetre: WindowPtr);

VAR
        I		: INTEGER;
		tRect   : Rect;

BEGIN
    SetpRect (QFenetre);

    hTE^^.viewRect := TeRect;

    tRect := QFenetre^.portRect;
    tRect.left := tRect.right-20;
    InvalRect (tRect);

    tRect := QFenetre^.portRect;
    tRect.top := tRect.bottom-20;
    InvalRect (tRect);

    tRect := QFenetre^.portRect;

    WITH monControl[1]^^.contrlRect DO
    BEGIN
        top     := tRect.top - 1;
        left    := tRect.right - 15;
        bottom  := tRect.bottom - 14;
        right   := tRect.right + 1;
    END;

    WITH monControl[2]^^.contrlRect DO
    BEGIN
        top     := tRect.bottom - 15;
        left    := tRect.left - 1;
        bottom  := tRect.bottom + 1;
        right   := tRect.right - 14;
    END;

    FOR I := 1 TO 2 DO ShowControl (monControl[I]);
    FocalHte(FALSE);
END;


{$S UPDATE}
{========================================================================
                                G R O W N D
 ========================================================================}
PROCEDURE  GroWnd (QFenetre: WindowPtr);

VAR     NewDim  : Varint;
        I       : INTEGER;
        tRect   : Rect;

BEGIN
    NewDim.VarL := GrowWindow (QFenetre,monEvent.where,GrowRect);
    IF NewDim.VarL = 0 THEN EXIT (GroWnd);
    FOR I := 1 TO 2 DO HideControl (monControl[I]);

    tRect := QFenetre^.portRect;
    tRect.left := tRect.right-20;
    InvalRect (tRect);

    tRect := QFenetre^.portRect;
    tRect.top := tRect.bottom-20;
    InvalRect (tRect);

    SizeWindow (QFenetre,NewDim.VarIL,NewDim.VarIH,TRUE);
	FocalHte(FALSE);
	HasMoved := TRUE;
	
	UpdateScrolls(Qfenetre);
END;  {* Grownd *}


{========================================================================
                            D E F V A L U E S
 ========================================================================}
{$S INIT}
PROCEDURE DefValues;
BEGIN
    PSel        :=0;
    DSel        :=0;
    Couleur     :=7;
    BCouleur    :=0;
    Jeu	        :=0;
    Taille      :=0;
    Clignotement:=False;
    Disjoint    :=False;
    Masquage    :=False;
    Inverse     :=False;
    Modification:=False;
    NameFlag    :=False;
END;


{==============================================================================================}
{ Interface avec pour le Drag and Drop }
{$I DragAndDrop.p }
{==============================================================================================}
{ Interface avec les fichiers }
{$I DragsterFile.p }
{==============================================================================================}
{ Gestion partie vidéotex… }
{$I VideoWork.inc.p }
{==============================================================================================}


{$S Main}
PROCEDURE QuitApp;

BEGIN
	DoneFlag:=True;
    HideWindow(ExtDlog);
	SendBehind(ExtDlog,Nil);
	HideWindow(gDebugWindowPtr);
	SendBehind(gDebugWindowPtr,Nil);
	WHILE (Pecr.NbEcran > 0) & DoneFlag DO
	BEGIN
		SelFen(FrontWindow);
		DoneFlag := CloseScreen(FALSE);
	END;
END;


{$S AppleEvents }
{------------------------------------------------------------------------------------
						Here are the four handlers for the required AppleEvents
------------------------------------------------------------------------------------}

{ First, a utility routine for checking that all required parameters have been used. }
FUNCTION GotRequiredParams(theAppleEvent: AppleEvent ):OSErr;		{ <aevt> }

VAR	typeCode: DescType ;
	actualSize: Size ;
	err: OSErr ;

BEGIN
	err := AEGetAttributePtr(theAppleEvent,keyMissedKeywordAttr,typeWildCard,typeCode,nil,0,actualSize) ;
	IF err = errAEDescNotFound THEN		{ we got all the required params: all is ok }
		GotRequiredParams := noErr
	ELSE
		IF err = noErr THEN
			GotRequiredParams := errAEEventNotHandled
		ELSE
			GotRequiredParams := err ;
END ; { GotRequiredParams }


FUNCTION HandleOAPP( theAppleEvent, reply: AppleEvent; handlerRefcon: LONGINT ): OSErr ;{ <aevt> }

VAR	err: OSErr ;

BEGIN
	{ We don't expect any params at all, but check in case the client requires any }
	err := GotRequiredParams( theAppleEvent ) ;
	IF err <> noErr THEN
		HandleOAPP := err
	ELSE
		HandleOAPP := noErr ;
END ;


FUNCTION HandleQUIT(theAppleEvent,reply: AppleEvent;handlerRefcon: LONGINT):OSErr;	{ <aevt> }

BEGIN
	QuitApp;
END ;


FUNCTION HandleODOC(theAppleEvent,reply:AppleEvent;handlerRefcon:LONGINT): OSErr;	{ <aevt> }

VAR myFSS: FSSpec ;
	docList: AEDescList ;
	index, itemsInList: LONGINT ;
	actualSize: Size ;
	keywd: AEKeyword ;
	typeCode: descType ;
	ignoreWPtr: WindowPtr ;
	
	PROCEDURE FailErr( err: OSErr ) ;
	BEGIN
		IF err <> noErr THEN	
		BEGIN
			{Debugger ;}
			HandleODOC := err ;
			EXIT( HandleODOC ) ;
		END ;
	END ;

BEGIN
	{ we are expecting a list of aliases: first get the list into theDesc and check
	  that it is the only param the sender considers essential }

	FailErr( AEGetParamDesc( theAppleEvent, keyDirectObject, typeAEList, docList ) ) ;
	FailErr( GotRequiredParams( theAppleEvent ) ) ;

	{ now get each alias from the list (as an FSSSpec) and open the associated file. }

	FailErr( AECountItems( docList, itemsInList ) ) ;

	FOR index := 1 TO itemsInList DO
	BEGIN
		FailErr( AEGetNthPtr( docList, index, typeFSS, keywd, typeCode,@myFSS, sizeof( myFSS ), actualSize ) ) ;
		IF Pecr.NbEcran<MaxEcran THEN
			IF OpenThisScreen(myFSS)=FALSE THEN Sysbeep(60);
	END;

	HandleODOC := noErr ;

	FailErr( AEDisposeDesc( docList ) ) ;
END ; { HandleODOC }


{ HandlePDOC:
	Given a list of aliases in message, get the list, resolve each constituent alias
	to a cannonicalFileSpec, which is then passed to PrintFile (prints without
	opening any windows).
}

FUNCTION HandlePDOC( theAppleEvent, reply: AppleEvent; handlerRefcon: LONGINT ): OSErr ;		{ <aevt> }

VAR
	docList: AEDescList ;
	index: INTEGER ;
	err: OSErr ;
	ignoreDesc: AEDesc ;
	keywd: AEKeyword ;
	ignore: Boolean ;
	myFSS: FSSpec ;
	itemsInList, actSize: LONGINT ;
	typeCode: descType ;

	
	PROCEDURE FailErr( err: OSErr ) ;
	BEGIN
(*
		IF err <> noErr THEN Debugger ;
*)
	END ;

BEGIN
	HandlePDOC := noErr ;

	{ we are expecting a list of aliases: first get the list into docList }

	FailErr( AEGetParamDesc( theAppleEvent, keyDirectObject, typeAEList, docList ) ) ;

	{ now check that all required params have been used: return error if there are any
	  that we don't understand }

	FailErr( GotRequiredParams( theAppleEvent ) ) ;

	{ now get each alias (as FSSpec) from the list and open it. }

	FailErr( AECountItems( docList, itemsInList ) ) ;

	FOR index := 1 TO itemsInList DO
	BEGIN
		FailErr( AEGetNthPtr( docList, index, typeFSS, keywd, typeCode,@myFSS, sizeof( myFSS ), actSize ) ) ;
		{ Print… ici }
	END ;

	FailErr( AEDisposeDesc( docList ) ) ;
END ; { HandlePDOC }



{$S INIT}
PROCEDURE InitAEVTStuff ;	{ <aevt> }

VAR aevtErr: OSErr ;

BEGIN
	aevtErr := AEInstallEventHandler( kCoreEventClass, kAEQuitApplication,@HandleQUIT, 0, false ) ;
	aevtErr := AEInstallEventHandler( kCoreEventClass, kAEOpenApplication,@HandleOAPP, 0, false ) ;
	aevtErr := AEInstallEventHandler( kCoreEventClass, kAEOpenDocuments,@HandleODOC, 0, false ) ;
	aevtErr := AEInstallEventHandler( kCoreEventClass, kAEPrintDocuments,@HandlePDOC, 0, false ) ;
END ;


{$S Main}
{========================================================================
                                D O F I L E
 ========================================================================}
PROCEDURE DoFile(TheItem: Integer);

VAR
	theFile: FSSpec;
	s,folder: Str255;
	pb: CInfoPBRec;
	err: OsErr;
	
BEGIN
    SaveSelFen;
	
	IF shifted & (theItem=offOpen) & (GetSelection<>'') THEN theItem := OffOpenSel;
	
    CASE TheItem OF
        OffNew  	: NewScreen(FALSE);
        OffOpen 	: OpenScreen;
		OffOpenSel	:
		IF GetSelection<>'' THEN
		WITH theFile DO
		BEGIN
			vRefNum := screen^.volNumber;
			s := GetSelection;
			IF s[1]=':' THEN
			BEGIN
				{ cas 1: même dossier }
				name := s;
				Delete(name,1,1);
				folder := name;
				IF pos(':',name)<>0 THEN
				BEGIN
					folder[0] := chr(pos(':',folder)-1);
					Delete(name,1,pos(':',name));
				END;
				parID := screen^.dirID;
				IF OpenThisScreen(theFile)=FALSE THEN
				WITH pb DO
				BEGIN	{ cas 2: sous dossier }
					s := PathNameFromDirID (screen^.dirID, vRefnum);
					s := concat(s,folder);
					ioNamePtr := @s;
					ioFDirIndex := 0;
					iovRefnum := vRefNum;
					ioDirID := 0;
					Err := PBGetCatInfoSync(@pb);
					theFile.parID := pb.ioDirID;
					IF OpenThisScreen(theFile)=FALSE THEN
					BEGIN	{ Cas 3: autre sous-dossier }
						s := PathNameFromDirID (screen^.dirID, vRefnum);
						REPEAT
							Delete(s,length(s),1);
						UNTIL (s[length(s)]=':') | (s='');
						s := concat(s,folder);
						ioNamePtr := @s;
						ioFDirIndex := 0;
						iovRefNum := vRef;
						ioDirID := 0;
						Err := PBGetCatInfoSync(@pb);
						theFile.parID := pb.ioDirID;
						IF OpenThisScreen(theFile)=FALSE THEN SysBeep(60);
					END;
				END;
			END
			ELSE
			BEGIN
				name := s;
				parID := screen^.dirID;
				IF OpenThisScreen(theFile)=FALSE THEN SysBeep(60);
			END;
        END;
		
		OffDup  	: DupScreen;
        OffSup  	: SupScreen;
        OffSave 	: IF (NOT DoneFlag) AND (PSel>=0) AND (NOT SnFlag) AND (TheItem>0) THEN IF NameFlag THEN SaveScreen ELSE SaveUnder;
        OffUnder	: IF (NOT DoneFlag) AND (PSel>=0) AND (NOT SnFlag) AND (TheItem>0) THEN SaveUnder;
        OffClose	: IF CloseScreen(FALSE) THEN;
        OffOrg  	: RevertScreen;
        OffTest 	: TestScreen;
        OffFormat 	: DoPageSetUp;
        OffPrint	: IF (NOT DoneFlag) AND (PSel>=0) AND (NOT SnFlag) AND (TheItem>0) THEN DoPrint;
        OffCServ	: ConfServ;
        OffQuit 	: QuitApp;
    END;
    UnloadSeg(@DoPrint);	{ Impression }
    IdleTime:=TickCount;
END;


{========================================================================
                                M E M O
 ========================================================================}
PROCEDURE Memo;
BEGIN
        { les ecrans }
        ExScreen^:=Screen^;

        { les regions de selection }
        CopyRgn(SelRgn,ExSelrgn);

        { les bornes de selection }
        ExDSel:=DSel;
        ExPSel:=PSel;
END;


{$S Main}
{=================================================================
                          GESTION 'ANNULER'
 =================================================================}


PROCEDURE DocRedraw;

BEGIN
	SetPort(FrontWindow);
	InvalRect(hTE^^.viewrect);
	FocalhTE(TRUE);
END;


PROCEDURE SaveForUndo(curScreen:PtEcran);

BEGIN
	IF curScreen=NIL THEN curScreen := screen;
	WITH UndoData,curScreen^ DO
	BEGIN
		canundo := TRUE;
		UndoMode := 0;
		undoDirty := TRUE;	{ modification | ErrFlag }
		doc := FrontWindow;
		selStart := hTE^^.selStart;
		selEnd := hTE^^.selEnd;
		longueur := hTE^^.telength;
		IF theText <> NIL THEN
		BEGIN
			HUnlock(theText);
			DisposHandle(theText);
			theText:=NIL;
		END;
		theText := hTE^^.htext;
		Err := HandToHand(theText);
		IF Err = MemFullErr THEN
			canUndo := FALSE
		ELSE 
			HLock(theText);
	END;	{ WITH }
END;


		
PROCEDURE DoUndo;

VAR tempText	: Handle;
	tempStart	: INTEGER;
	tempEnd		: INTEGER;
	templong	: INTEGER;
	tempDirty	: BOOLEAN;
	
BEGIN
	IF (NOT UndoData.canUndo) OR (UndoData.doc <> FrontWindow) THEN EXIT(DoUndo);
	WITH UndoData,Screen^ DO BEGIN
		temptext := hTE^^.htext;
		Err := HandToHand(tempText);
		HLock(tempText);
		
		tempstart := hTE^^.selStart;
		tempend := hTE^^.selEnd;
		templong := hTE^^.teLength;
		tempdirty := TRUE; { Modification | ErrFlag }
		
		TESetText(TheText^,longueur,hTE);
		TESetSelect(selStart,selEnd,hTE);
		Modification := undoDirty;
		ErrFlag := UndoDirty;
		
		IF theText<>NIL THEN
		BEGIN
			Hunlock(theText);
			DisposHandle(theText);
		END;
		
		theText := tempText;
		Err := HandToHand(theText);
		selstart := tempStart;
		selend := tempend;
		longueur := templong;
		UndoMode := 0;
		undoDirty := TempDirty;
		
		Hunlock(tempText);
		DisposHandle(temptext);
		HLock(theText);
	END;
	DocRedraw;
END;



{========================================================================
                          CHERCHER / REMPLACER
 ========================================================================}

{$S UTILTEXT}
FUNCTION DoFindNext(sens:Boolean):BOOLEAN;

VAR	car			: INTEGER;
	c2			: INTEGER;
	str1,str2	: Str255;
	startFind	: INTEGER;
	
  FUNCTION TestCar:Boolean;
  
  BEGIN
  	Str1[1] := CharsHandle(Hte^^.htext)^^[car+c2-1];
	Str2[1] := FindData.FindStr[c2];
	TestCar := EqualString(Str1,Str2,FindData.CaseSens,FindData.DiacSens);
  END;

  FUNCTION TestWord:BOOLEAN;
  
  BEGIN
  	IF FindData.WordFind THEN
  		TestWord := ((car=0) | NOT (ORD(CharsHandle(Hte^^.htext)^^[car-1]) IN [$30..$39,$41..$5A,$61..$7A]))
				  & ((car+c2+1>=HTe^^.teLength) | NOT (ORD(CharsHandle(Hte^^.htext)^^[car+c2]) IN [$30..$39,$41..$5A,$61..$7A]))
  	ELSE
		TestWord := TRUE;
		
  END;
  
  
BEGIN
	Str1 := ' ';
	Str2 := ' ';
	IF Sens=FALSE THEN	{ recherche en avant… }
	WITH Hte^^ DO
	BEGIN
		startFind := selEnd;
		car := selEnd;
		Hlock(htext);
		WHILE car < teLength-LENGTH(FindData.FindStr) DO
		BEGIN
			c2 := 1;
			WHILE TestCar DO
			BEGIN
				IF (c2 >= LENGTH(FindData.FindStr)) & TestWord THEN
				BEGIN
					TESetSelect(car,car+c2,hTE);
					DoFindNext := TRUE;
					EXIT(DoFindNext);
				END;
				c2 := c2+1;
			END;
			car := car +1;
		END;
		IF FindData.WrapFind & (startFind > 0) THEN
		BEGIN
		  car := 0;
		  WHILE car < startFind DO
		  BEGIN
		  	c2 := 1;
			WHILE TestCar DO
			BEGIN
				IF (c2 >= LENGTH(FindData.FindStr)) & TestWord THEN
				BEGIN
					TESetSelect(car,Car+c2,hTE);
					DoFindNext := TRUE;
					EXIT(DoFindNext);
				END;
				c2 := c2+1;
			END;
			car := car + 1;
		  END;
		END;
		
		DoFindNext := FALSE;
	END
	
	ELSE
	
	WITH Hte^^ DO
	BEGIN
		startFind := selStart-1;
		car := selstart-2;
		Hlock(htext);
		WHILE car >= 0 DO
		BEGIN
			c2 := 1;
			WHILE TestCar DO
			BEGIN
				IF (c2 >= LENGTH(FindData.FindStr)) & TestWord THEN
				BEGIN
					TESetSelect(car,car+c2,hTE);
					DoFindNext := TRUE;
					EXIT(DoFindNext);
				END;
				c2 := c2+1;
			END;
			car := car -1;
		END;
		IF FindData.WrapFind & (startFind > 0) THEN
		BEGIN
		  car := teLength-LENGTH(FindData.FindStr);
		  WHILE car > startFind DO
		  BEGIN
		  	c2 := 1;
			WHILE TestCar DO
			BEGIN
				IF (c2 >= LENGTH(FindData.FindStr)) & TestWord THEN
				BEGIN
					TESetSelect(car,Car+c2,hTE);
					DoFindNext := TRUE;
					EXIT(DoFindNext);
				END;
				c2 := c2+1;
			END;
			car := car - 1;
		  END;
		END;
		
		DoFindNext := FALSE;
	END;
END;


{$S UTILTEXT}
PROCEDURE DoFindReplaceNext(replace:BOOLEAN);

VAR	Sel		: INTEGER;

BEGIN
	SaveSelFen;
	IF DoFindNext(Shifted) THEN
	BEGIN
		IF replace THEN
		BEGIN
			Sel := Hte^^.selStart;
			SaveForUndo(NIL);
			TEDelete(Hte);
			TEInsert(PTR(ORD4(@FindData.ReplaceStr)+1),length(FindData.ReplaceStr),hTE);
			TESetSelect(Sel,Sel+LENGTH(FindData.ReplaceStr),Hte);
			Modification := TRUE;
			ErrFlag := TRUE;
			SaveSelFen;
		END;
		FocalHte(TRUE);
	END ELSE SysBeep(60);
END;



{$S UTILTEXT}
PROCEDURE DoFindReplace(replace:BOOLEAN);

VAR	theDialog	: DialogPtr;
	itemHit		: INTEGER;
	car			: INTEGER;
	LeRect		: Rect;
	itemH		: Handle;
	
BEGIN
	SaveSelFen;
	IF replace THEN
		theDialog := GetNewDialog(rReplaceDLOG +1000*longint(gSystemVersion<$700),NIL,POINTER(-1))
	ELSE
		theDialog := GetNewDialog(rFindDLOG +1000*longint(gSystemVersion<$700),NIL,POINTER(-1));		
	
	GetDitem(theDialog,3,car,itemh,lerect);
	SetIText(itemh,FindData.FindStr);
	SelIText(theDialog,3,0,LENGTH(FindData.FindStr));
	
	GetDitem(theDialog,4,car,itemh,lerect);
	SetCtlValue(ControlHandle(itemH),LONGINT(FindData.CaseSens));
	
	GetDitem(theDialog,5,car,itemh,lerect);
	SetCtlValue(ControlHandle(itemH),LONGINT(FindData.DiacSens));
	
	GetDitem(theDialog,6,car,itemh,lerect);
	SetCtlValue(ControlHandle(itemH),LONGINT(FindData.WrapFind));
	
	GetDitem(theDialog,8,car,itemh,lerect);
	SetCtlValue(ControlHandle(itemH),LONGINT(FindData.WordFind));
	
	IF replace THEN
	BEGIN
		GetDitem(theDialog,7,car,itemh,lerect);
		SetIText(itemh,FindData.ReplaceStr);
	END;
	
	CenterMovableDlog(theDialog,PosCherche.topLeft);
	DialogBegin(theDialog,1,2,TRUE);
	
	REPEAT
		ModalDialog(@MyFilter,itemHit);
		CASE itemHit OF
		4..6,8:
			BEGIN
				GetDitem(theDialog,itemHit,car,itemh,lerect);
				SetCtlValue(ControlHandle(itemh),1-GetCtlValue(ControlHandle(itemh)));
			END;
		END;
	UNTIL (itemHit = 1) OR (itemHit = 2);
	
	{ sauvegarde de la position du movable dialog }
	PosCherche := WindowPeek(theDialog)^.ContRgn^^.rgnBBox;

	IF itemHit = 1 THEN
	BEGIN
		GetDItem(theDialog,3,car,itemH,LeRect);
		GetIText(itemH,FindData.FindStr);

		GetDitem(theDialog,4,car,itemh,lerect);
		FindData.CaseSens := BOOLEAN(GetCtlValue(ControlHandle(itemh)));

		GetDitem(theDialog,5,car,itemh,lerect);
		FindData.DiacSens := BOOLEAN(GetCtlValue(ControlHandle(itemh)));
		
		GetDitem(theDialog,6,car,itemh,lerect);
		FindData.WrapFind := BOOLEAN(GetCtlValue(ControlHandle(itemh)));
		
		GetDitem(theDialog,8,car,itemh,lerect);
		FindData.WordFind := BOOLEAN(GetCtlValue(ControlHandle(itemh)));
		
		IF replace THEN
		BEGIN
			GetDItem(theDialog,7,car,itemH,LeRect);
			GetIText(itemH,FindData.ReplaceStr);
		END;
		
		DialogEnd(theDialog);
		
		SelFen(FrontWindow);
		DoFindReplaceNext(replace);
	END
	ELSE DialogEnd(theDialog);
END;


{$S UTILTEXT}
PROCEDURE DoFindSel;

VAR	s:Str255;

BEGIN
	s := GetSelection;
	IF s <> '' THEN
	BEGIN
		FindData.FindStr := s;
		IF DoFindNext(shifted) THEN FocalHte(TRUE);	{ on a trouvé, on montre la sélection… }
	END;
END;


{$S UTILTEXT}
{========================================================================
                      DECALAGE / ALIGNEMENT DE TEXTE
 ========================================================================}
PROCEDURE ResizeSelection(VAR L1,L2:INTEGER);

BEGIN
	WITH Hte^^ DO
	BEGIN
		{ recherche de la première ligne de la sélection… }
		L1 := 0;
		WHILE (L1<nLines) & (lineStarts[L1+1]<=SelStart) DO L1 := L1+1;
		{ rechercher de la dernière ligne de la sélection… }
		L2 := nLines;
		WHILE (L2>=L1) & (lineStarts[L2-1]>=SelEnd) DO L2 := L2-1;
	END;	{ WITH Hte^^ }
END;


PROCEDURE DoShiftText(aDroite:Boolean);

VAR	i:INTEGER;
	L1,L2: INTEGER;
	savedRgn: RgnHandle;
	R: RECT;
	
BEGIN
	IF Hte=NIL THEN EXIT(DoShiftText);
	HLock(handle(Hte));
	WITH Hte^^ DO
	BEGIN
		savedRgn := inPort^.clipRgn;
		inPort^.clipRgn := NewRgn;
		SaveForUndo(NIL);
		ResizeSelection(L1,L2);
		FOR i := L1 TO L2-1 DO
		BEGIN
			IF aDroite THEN
			BEGIN
				TESetSelect(lineStarts[i],lineStarts[i],hte);
				TEKey(' ',hTE);
			END
			ELSE
				IF CharsHandle(hText)^^[LineStarts[i]]=' ' THEN
				BEGIN
					TESetSelect(lineStarts[i],lineStarts[i]+1,hte);
					TEDelete(hte);
				END;
		END;
		TESetSelect(LineStarts[L1],LineStarts[L1],HTE);
		R.top := SelRect.Top;
		R.Left := viewRect.left;
		TESetSelect(LineStarts[L2],LineStarts[L2],HTE);
		R.Bottom := selRect.Bottom;
		R.Left := viewRect.left;
		R.Right := viewRect.right;
		TESetSelect(LineStarts[L1],LineStarts[L2],HTE);
		DisposeRgn(inPort^.clipRgn);
		inPort^.clipRgn := savedRgn;
		SetPort(Inport);
		InValRect(R);
		modification := TRUE;
		ErrFlag := TRUE;	{ il faut analyser le source… }
	END;
	HUnlock(handle(Hte));
END;


PROCEDURE DoAlign;

VAR	i,j:INTEGER;
	L1,L2: INTEGER;
	savedRgn: RgnHandle;
	R: RECT;
	indent, n: INTEGER;
	
BEGIN
	IF (Hte=NIL) | (HTE^^.SelStart=HTE^^.SelEnd) THEN EXIT(DoAlign);
	HLock(handle(Hte));
	WITH Hte^^ DO
	BEGIN
		savedRgn := inPort^.clipRgn;
		inPort^.clipRgn := NewRgn;
		SaveForUndo(NIL);
		ResizeSelection(L1,L2);
		FOR indent := lineStarts[L1] TO lineStarts[L1+1] DO
			IF CharsHandle(hText)^^[indent]<>' ' THEN Leave;
		Indent := Indent - lineStarts[L1];
		
		FOR i := L1+1 TO L2-1 DO
		BEGIN
			n := 0;
			FOR j := lineStarts[i] TO lineStarts[i+1]-1 DO
				IF CharsHandle(hText)^^[j]=' ' THEN n := n+1 ELSE Leave;
			IF n>indent THEN
			BEGIN
				TESetSelect(lineStarts[i],lineStarts[i]+n-indent,hte);
				TEDelete(hte);
			END
			ELSE
			BEGIN
				TESetSelect(lineStarts[i],lineStarts[i],hte);
				FOR j := n+1 TO indent DO TEKey(' ',hte);
			END;
		END;
		TESetSelect(LineStarts[L1],LineStarts[L1],HTE);
		R.top := SelRect.Top;
		R.Left := viewRect.left;
		TESetSelect(LineStarts[L2],LineStarts[L2],HTE);
		R.Bottom := selRect.Bottom;
		R.Left := viewRect.left;
		R.Right := viewRect.right;
		TESetSelect(LineStarts[L1],LineStarts[L2],HTE);
		DisposeRgn(inPort^.clipRgn);
		inPort^.clipRgn := savedRgn;
		SetPort(Inport);
		InValRect(R);
		modification := TRUE;
		ErrFlag := TRUE;	{ source à analyser }
	END;
	HUnlock(handle(Hte));
END;


PROCEDURE DoGotoLine;

VAR	dlog: WindowPtr;
	i: INTEGER;
	leRect: Rect;
	itemH: Handle;
	str: Str255;
	laligne: LONGINT;
	
BEGIN
	IF Hte=NIL THEN EXIT(DoGotoLine);
	SaveSelFen;
	dlog := GetNewDialog(rGotolineDLOG,NIL,POINTER(-1));

	IF gGotoLine>0 THEN
	BEGIN
		GetDitem(dlog,3,i,itemh,lerect);
		NumToString(gGotoLine,str);
		SetIText(itemh,str);
		SelIText(dlog,3,0,LENGTH(str));
	END
	ELSE
		SelIText(dlog,3,0,10);
	
	CenterDLOG(dlog);
	DialogBegin(dlog,1,2,TRUE);
	REPEAT
      ModalDialog (@MyFilter, i);
    UNTIL i IN [1,2];
	IF i=1 THEN	{ OK }
	BEGIN
		GetDItem(dlog,3,i,itemH,LeRect);
		GetIText(itemH,str);
		StringToNum(str,laligne);
		DialogEnd(dlog);
		SelFen(FrontWindow);
		IF (laligne>=1) & (laligne<=Hte^^.nLines) THEN
		BEGIN
			gGotoLine := laLigne;
			TESetSelect(Hte^^.lineStarts[laligne-1],Hte^^.lineStarts[laligne],hTE);
			FocalHte(TRUE);
		END
		ELSE
			SysBeep(60);	{ N° de ligne incorrect ! }
	END
	ELSE
    	DialogEnd(dlog);
END;

{$S Main}
{========================================================================
                            D O E D I T
 ========================================================================}
PROCEDURE DoEdit(TheItem: Integer);
    VAR TempScreen	: ptEcran;
        TempPSel,TempDSel, LastCar, CarEnCours,
		i			: Integer;
        TempSelRgn	: RgnHandle;
      	IO   		: INTEGER;
        Off,Size	: LongInt;
        DScrap		: ScrapStuffPtr;
		
BEGIN
    IF NOT SystemEdit (theItem-1) THEN
		IF FrontWindow = Nil THEN
			EXIT(DoEdit)
		ELSE
		IF FrontWindow = ScreenPtr THEN	{ fenêtre vidéotex }
		CASE TheItem OF
		OffUndo: BEGIN	{ annuler }
			Modification:=True;
			Curoff(ScreenPtr);
			{ les ecrans }
			TempScreen:=Screen;
			Screen:=ExScreen;
			ExScreen:=TempScreen;
	
			{ les regions de selection }
			TempSelRgn:=NewRgn;
			CopyRgn(SelRgn,TempSelrgn);
			CopyRgn(ExSelrgn,SelRgn);
			CopyRgn(TempSelrgn,ExSelrgn);
			DisposeRgn(TempSelRgn);
	
			{ les bornes de selection }
			TempDSel:=DSel;
			DSel:=ExDSel;
			ExDSel:=TempDSel;
			TempPSel:=PSel;
			PSel:=ExPSel;
			ExPSel:=TempPSel;
	
			SauveSel;
			{ on redessine tout l'ecran }
			MonWDraw;
		   END;
		 OffCut,OffCopy:
			IF PSel<>DSel THEN
			BEGIN
				FlagPP:=True;
				BlockMoveData(ptr(SCreen),ptr(CpScreen),Sizeof(Ecran));
				CpPSel:=PSel;
				CpDSel:=DSel;
				IF theItem = 3 THEN
				BEGIN
					Modification:=True;
					Memo;
					FOR i:= PSel TO DSel-1 DO
						Screen^.cars[i]:=CarNeutre;
					Curoff(ScreenPtr);
					InvalSel(True,False);
				END;
			END;
		 OffPaste:
			BEGIN
				Memo;
				IF FlagPP THEN
				BEGIN
					Modification:=True;
					LastCar:=(PSel DIV 40)*40 + 40;
					CarEnCours:=PSel;
					FOR i:=CpPSel TO CpDSel-1 DO
					 IF CarEnCours<LastCar THEN
						BEGIN
						 Screen^.Cars[CarEnCours]:=CpScreen^.Cars[i];
						 CarEnCours:=CarEnCours+1;
						END;
					Curoff(ScreenPtr);
					DSel:=CarEnCours;
					IF DSel>Lastcar THEN DSel:=LastCar;
					InvalSel(True,False);
					IdleFlag:=False;
					SauveSel;
				END;
			END;
		 OffDelete:
			BEGIN
				Modification:=True;
				Memo;
				FOR i:= PSel TO DSel-1 DO
				  Screen^.cars[i]:=CarNeutre;
				Curoff(ScreenPtr);
				InvalSel(True,False);
			END;
			
		 OffAll:	{ tout effacer }
			BEGIN
				Modification:=True;
				Memo;
				FOR i:= 0 TO nbcar DO
				  Screen^.cars[i]:=CarNeutre;
				Curoff(ScreenPtr);
				IF ShowColor THEN BackColor(blackColor);
				EraseRect(EditRect);
				IF ShowColor THEN BackColor(whiteColor);
			END;
		END
		ELSE
		IF FrontWindow = EditPtr THEN	{ fenêtre BASIC }
		BEGIN
		CASE theItem OF
		
		OffUndo : DoUndo;
		
		OffCut:
			BEGIN
				SaveForUndo(NIL);
				TECut (hTE);
				FocalHte(TRUE);
				Modification:=True;
				ErrFlag:=true;
			END;
				
		OffCopy: TECopy (hTE);
		
		OffPaste:
			IF FlagPPT THEN
			BEGIN
				DScrap := InfoScrap;
				IF DScrap^.scrapCount <> Etat THEN
				BEGIN
				  Etat := DScrap^.scrapCount;		{ on met à jour notre compteur interne }
				  Size := GetScrap(NIL,'TEXT',Off);	{ il y a du texte dans le presse-papiers ? }
				  IF Size>0 THEN IO:=TEFromScrap;	{ oui, on le récupère }
				END;  {* If state *}
				SaveForUndo(NIL);
				TEPaste (hTE);
				FocalHte(TRUE);
				Modification:=True;
				ErrFlag:=true;
			END;
			
		OffDelete:
			BEGIN
				SaveForUndo(NIL);
				TEDelete (hTE);
				FocalHte(TRUE);
				Modification:=True;
				ErrFlag:=true;
			END;
			
		OffAll:
			TESetSelect(0,32767,hTE);
		
		OffSearch:		DoFindReplace(FALSE);
		OffSearchNext:	DoFindReplaceNext(FALSE);
		OffSearchSel:	DoFindSel;
		OffReplace:		DoFindReplace(TRUE);
		OffReplaceNext:	DoFindReplaceNext(TRUE);
			
		OffShiftLeft:	DoShiftText(FALSE);
		OffShiftRight:	DoShiftText(TRUE);
		OffAlign:		DoAlign;
		OffGotoLine:	DoGotoLine;
		
		END;  {* Case *}
		
		IF theItem IN [OffCut, OffCopy] THEN
		BEGIN
			FlagPPT:=True;
			IO := ZeroScrap;
			IO := TEToScrap;
		END;  {* If the item *}
    END;
    IdleTime:=TickCount;
	UnloadSeg(@DoFindNext);		{ UtilText }
END;

{$S Main}
{========================================================================
                                D O F E N
 ========================================================================}
PROCEDURE DoFen(TheItem: Integer);
    VAR i: integer;
BEGIN
    IF TheItem >= OffWindows THEN ChooseWindow(TheItem)
	ELSE
	CASE TheItem OF

        OffWBas:
            BEGIN
                WBasFlag:=NOT WBasFlag;
                FOR i:=1 TO PEcr.NbEcran DO
                    IF WBasFlag THEN ShowWindow(PEcr.Ecrans[i]^^.WEdit)
                                ELSE HideWindow(PEcr.Ecrans[i]^^.WEdit);
				UpdateWindMenu;
            END;

        OffWVid:
            BEGIN
                WVidFlag:=NOT WVidFlag;
                FOR i:=1 TO PEcr.NbEcran DO
                    IF WVidFlag THEN ShowWindow(PEcr.Ecrans[i]^^.WEcran)
                                ELSE HideWindow(PEcr.Ecrans[i]^^.WEcran);
				UpdateWindMenu;
            END;

        OffWErr:
            BEGIN
                WErrFlag:=NOT WErrFlag;
                IF WErrFlag THEN
					ShowWindow(gDebugWindowPtr)
                ELSE
					HideWindow(gDebugWindowPtr);
				UpdateWindMenu;
            END;
			
		OffExtern:
			IF ExtDlog <> NIL THEN
			BEGIN
				ShowWindow(ExtDLOG);
				SelectWindow(ExtDLOG);
			END;

    END;
    IdleTime:=TickCount;
END;


{========================================================================
                                D O H E L P
 ========================================================================}
PROCEDURE DoHelp(TheItem: Integer);
    VAR i: integer;
BEGIN
    CASE TheItem OF

    END;
    IdleTime:=TickCount;
END;



{$S Main}
{=================================================================
                K E Y D O W N   - - -   A U T O K E Y
 =================================================================}


PROCEDURE WKey(C: char);

VAR	Rep,
	Line		: integer;
	Del			: longint;
	key			: INTEGER;
	theControl	: ControlHandle;
	
BEGIN
	key := ord(c);
    IF FrontWindow=Nil THEN EXIT(WKey);

	IF key IN [1,4,11,12] THEN
	BEGIN
		theControl := WindowPeek(FrontWindow)^.ControlList;
		IF theControl^^.contrlRect.bottom<=theControl^^.contrlRect.top+16 THEN
			theControl := theControl^^.nextControl;
		IF theControl<>NIL THEN
		CASE key OF
			1:
			BEGIN
				Valeur := GetCtlValue(theControl);
				SetCtlValue(theControl, GetCtlMin(theControl));
				CtrlAction (theControl, inThumb);
			END;
			
			4:
			BEGIN
				Valeur := GetCtlValue(theControl);
				SetCtlValue(theControl, GetCtlMax(theControl));
				CtrlAction (theControl, inThumb);
			END;
			
			11: CtrlAction (theControl, inPageUp);
			12: CtrlAction (theControl, inPageDown);
		END;	{ CASE key }
		EXIT(WKey);
	END;
	
    IF FrontWindow=gdebugwindowptr THEN
       BEGIN
            {WWriteCh(c);}
            EXIT(WKey);
       END;

    IF ((GetWRefCon(FrontWindow) = ERef) & (NOT (key IN [1,3,4,11,12,28..31]))) |
	   (GetWRefCon(FrontWindow) = VRef)  THEN Modification:=True;

    CASE GetWRefCon(FrontWindow) OF

        VRef:   IF NOT runflag AND (mode=EditModeCst) THEN VEKey(C);
	{$IFC EMUL}
		EMRef:	EM_Key(C,shifted);		{ Emulateur }
	{$ENDC}

(*
		ExtRef:	{ fenêtre des routines externes }
			BEGIN
				IF TickCount - LastKey > 60 THEN ExtChoosed := '';
				LastKey := TickCount;
				ExtChoosed := concat(ExtChoosed,CHR(c));
			END;
*)

        ERef: IF NOT runflag THEN
			  BEGIN
			  
                IF NOT (key IN [10,28..31]) THEN
				BEGIN
					ErrFlag:=true;
					CASE UndoData.UndoMode OF
					  0:	{ normal }
					  BEGIN
						  SaveForUndo(NIL);
						  IF key=8 THEN UndoData.UndoMode := 2 ELSE UndoData.UndoMode := 1;
					  END;
					  
					  1:	{ saisie }
					  BEGIN
						  IF key=8 THEN
						  BEGIN
							  SaveForUndo(NIL);
							  UndoData.UndoMode := 2;
						  END;
					  END;
					  
					  2:	{ effacement }
					  BEGIN
						  IF key<>8 THEN
						  BEGIN
							  SaveForUndo(NIL);
							  UndoData.UndoMode := 1;
						  END;
					  END;
					END;	{CASE}
				END;
				
				{ recherche de la ligne de SelStart }
                Line:=0;
                WITH Hte^^ DO
				BEGIN
				  WHILE (lineStarts[Line]<=SelStart) AND (Line<nlines) DO
					  line:=Line+1;
  
				  IF Line>0 THEN Line:=Line-1 ELSE Line:=0;
  				
				  CASE key OF
				  	28:	{ <- }
					BEGIN
						IF SelEnd<>SelStart THEN
						BEGIN
							TESetSelect(selStart,selStart,Hte);
							rep := 0;
						END
						ELSE
							rep := 1;
					END;
					
				  	29:	{ -> }
					BEGIN
						IF SelEnd<>SelStart THEN
						BEGIN
							TESetSelect(SelEnd,SelEnd,Hte);
							rep := 0;
						END
						ELSE
							rep := 1;
					END;
					
					9:	{ TAB }
					BEGIN
						Rep := 2;
						C := ' ';
					END;
					
					13:	{ CR }
					BEGIN
						{ on regarde l'indentation de la ligne en cours }
						Rep := 0;
						Line:=lineStarts[Line];
						WHILE (Line<TeLength) AND (CharsPtr(htext^)^[Line]=' ') DO
						BEGIN
							Rep:=Rep+1;
							Line:=Line+1;
						END;
						
						{ on regarde l'indentation déja existante sur la prochaine ligne }
						Line:=SelEnd;
						WHILE (Line<TeLength) AND (CharsPtr(htext^)^[Line]=' ') AND (Rep>0) DO
						BEGIN
							Rep:=Rep-1;
							Line:=Line+1;
						END;
						
						{ on insere le Return }
						TEKey(C, Hte);
						{ on se prepare a indenter des spaces }
						C := ' ';
					 END;
					 
					 OTHERWISE Rep := 1;
				END;	{ CASE }
  
				IF (ord(c) IN [8,13,28..255]) THEN	{•••• flèches du clavier… ••••}
				WHILE (Rep>0) DO
				BEGIN
					TEKey(C, Hte);
					Rep := Rep-1;
				END;
	  
				FocalHte(TRUE);
				
				IF key=3 THEN DoBasic(OffSyntax);	{ enter = analyse de syntaxe }
				
			END; {WITH}
		END;

    END;

END; { WKey }


{$S Main}
{=================================================================
                        A S C E N C E U R S
 =================================================================}
PROCEDURE  CtrlAction (theControl: ControlHandle; partCode: INTEGER);

VAR     I, N1, N2, N3,
        Nombre, Value   : INTEGER;

BEGIN

    IF PartCode = 0 THEN
        EXIT (CtrlAction);
	
    IF theControl = monControl[1] THEN
    BEGIN
        I := 1;
        Nombre := ((TeRect.bottom - TeRect.top) DIV hTE^^.lineHeight) DIV 2;
        N1 := hTE^^.nlines - ((TeRect.bottom - TeRect.top) DIV hTE^^.lineHeight) + 2;
        IF N1<0 THEN N1:=0;
        N2 := 0;
        N3 := hTE^^.lineHeight;
    END;  {* If *}

    IF theControl = monControl[2] THEN	{ ascenseur vertical }
    BEGIN
        I := 2;
        Nombre := 10;	{ scroll d'une page (10 car.) }
        N1 := 180;		{ maximum }
        N2 := CarWid;	{ scroll horizontal pour une unité }
        N3 := 0;		{ scroll vertical pour une unité }
    END;  {* If *}

    IF N1 < 0 THEN EXIT(CtrlAction);

	CASE partCode OF
        inUpButton    : Value := 1;
        inDownButton  : Value := - 1;
        inPageUp      : Value := Nombre;
        inPageDown    : Value := - Nombre;
        inThumb	      : Value := Valeur - GetCtlValue(theControl);
    END;   {* Case *}
	
	{ on ne dépasse pas les limites maxi/mini ? }
    IF (Value < 0) & ((Numero[I] - Value) > N1) THEN Value := Numero[I]-N1;
    IF (Value > 0) & (Numero[I] < Value) THEN Value := Numero[I];

	{ mise à jour du scroll bar }
    Numero[I] := Numero[I] - Value;
    SetCtlValue (theControl, Numero[I]);

	{ scroll du contenu }
    IF (Value*N2<>0) OR (Value*N3<>0) THEN TEScroll (Value * N2, Value * N3, hTE);
	
END;  {* Ctrlaction *}


PROCEDURE  DoControl(pt: point);

VAR	CtrlOu, CtrlNb  : INTEGER;
	QuelControl     : ControlHandle;

BEGIN
    SetPRect(FrontWindow);
    CtrlNb := FindControl (pt, EditPtr, QuelControl);
    IF CtrlNb <> 0 THEN
  	BEGIN
		Valeur := GetCtlValue (QuelControl);
        IF CtrlNb = inThumb THEN
            BEGIN
                CtrlOu := TrackControl (QuelControl, pt, NIL);
                CtrlAction (QuelControl, inThumb);
            END	 {* Then *}
        ELSE
            CtrlOu := TrackControl (QuelControl,pt,@CtrlAction);
	END;
END;  {* DoControl *}


FUNCTION PasClikLoop: Boolean;
    VAR pt: point;
BEGIN
	GetMouse(Pt);
    WITH pt DO
    BEGIN
        IF v<hte^^.viewrect.top THEN CtrlAction(monControl[1],inUpButton)
        ELSE
        IF v>hte^^.viewrect.bottom THEN CtrlAction(monControl[1],inDownButton)
        ELSE
        IF h<hte^^.viewrect.left THEN CtrlAction(monControl[2],inUpButton)
        ELSE
        IF h>hte^^.viewrect.right THEN CtrlAction(monControl[2],inDownButton);
    END;
	PasClikLoop:=True;
END;


{=================================================================
                            M O U S E D O W N
 =================================================================}
FUNCTION WMouseDown(where: INTEGER; QFenetre: WindowPtr; pt: Point; modifiers: INTEGER):BOOLEAN;

VAR savePort: GrafPtr;
    ptl		: point;
    c		: char;
	ref		: LONGINT;
	pos		: INTEGER;
	
BEGIN
	IF FrontWindow=NIL THEN EXIT(WMouseDown);
	
	IF (where=inDrag) & (QFenetre<>FrontWindow)
	 & (GetWRefCon(FrontWindow)=DlogRef) THEN EXIT(WMouseDown);
		
	WMouseDown := TRUE;	{ update barre de menu par défaut }
	
	GetPort(savePort);
	SetPort(QFenetre);
	
    IF QFenetre=gdebugwindowptr THEN
	BEGIN
		WWMouseDown(Where, pt,modifiers);
		WErrFlag:=(Where<>InGoAway);
		IF WErrFlag THEN PosTrace := WindowPeek(QFenetre)^.ContRgn^^.rgnBBox;
		EXIT(WMouseDown);
	END;

    ptl:=pt;
    globaltolocal(ptl);
	
	ref := GetWRefCon(QFenetre);
	
    CASE where OF
        inDrag:
        BEGIN
			IF (QFenetre<>FrontWindow) & (BitAnd(monEvent.modifiers,256)=0) THEN SelectWindow(QFenetre); 
			
			DragWindow(QFenetre, pt, StdDrag);
			IF ref = ERef THEN HasMoved := TRUE;
			IF ref = ExtRef THEN
				PosExt := WindowPeek(QFenetre)^.ContRgn^^.rgnBBox;
{$IFC EMUL}
			IF ref = EMRef THEN
				PosEmul := WindowPeek(QFenetre)^.ContRgn^^.rgnBBox;
{$ENDC}
		END;
		
		inContent:
			IF QFenetre=FrontWindow THEN
			CASE GetWRefCon(QFenetre) OF
				VRef:   { fenetre d'edition Videotex }
					IF NOT RunFlag THEN
					BEGIN
						IF PtInRect(ptl,EditRect) THEN
						CASE mode OF 
							EditModeCst: ChangeSel(pt, modifiers);
							PenModeCst : CheckPix(pt,modifiers);
						END
						ELSE
						IF PtInRect(ptl,JeuRect) THEN
						CASE mode OF 
							EditModeCst: IF ClicCar(ptl,c) THEN WKey(c);
						END
						ELSE
						IF PtInRect(ptl,BTexRect) THEN
						CASE mode OF 
							EditModeCst:;
							PenModeCst:
							BEGIN
								Screen^.mode:=EditModeCst;
								mode:=EditModeCst;
								AffCurPos;
							END;
						END
						ELSE
						IF PtInRect(ptl,BPenRect) THEN
						CASE mode OF 
							EditModeCst:
							BEGIN
								Curoff(QFenetre);
								Screen^.mode:=PenModeCst;
								mode:=PenModeCst;
								AffCurPos;
							END;
							PenModeCst:;
						END
					END;

					ERef:   { fenetre d'edition du Basic }
						IF PtInRect(ptl,TeRect) THEN
						BEGIN
							IF NOT RunFlag THEN
							BEGIN
								pos := TEGetOffset(ptl,hTE);
								IF gHasDrag & (hTE^^.selStart<>hTE^^.selEnd) & (pos>hTE^^.selStart) & (pos<hTE^^.selEnd) THEN	{ click dans la sélection }
									DoDragStart(monEvent, hTE)
								ELSE
								BEGIN
									SetClikLoop(@PasClikLoop, hTE);
									UndoData.UndoMode := 0;
									TEClick(ptl,(BitAnd(monEvent.modifiers,512)<>0),hte);
									DrawControls(FrontWindow);
								END;
							END;
						END
						ELSE DoControl(ptl);
						 
	{$IFC EMUL}
					EMRef:
						EM_Clic(ptl);
	{$ENDC}
	
					ExtRef:		{ click dans la fenêtre 'Routines externes' }
					BEGIN
						IF LClick(ptl,monEvent.modifiers,ExtList) THEN;
						UpdateExtDlog;
						WMouseDown := FALSE;
					END;
						
				END { case }
			ELSE
				IF GetWRefCon(FrontWindow)<>DlogRef THEN SelectWindow(QFenetre);
			
		inGoAway:
			IF QFenetre=FrontWindow THEN
			BEGIN
				IF TrackGoAway(QFenetre,pt) THEN
				CASE GetWRefCon(QFenetre) OF
					ERef,VRef:	IF NOT runFlag THEN IF CloseScreen(FALSE) THEN;
					ExtRef:		HideWindow(ExtDlog);
				END;
			END
			ELSE
				IF GetWRefCon(FrontWindow)<>DlogRef THEN SelectWindow (QFenetre);

		inGrow:
		BEGIN
			IF QFenetre = FrontWindow THEN
			BEGIN
				IF GetWRefCon(QFenetre)=ERef THEN GroWnd(QFenetre);
				WMouseDown := FALSE;
			END
			ELSE
				IF GetWRefCon(FrontWindow)<>DlogRef THEN SelectWindow(QFenetre);
		END;  {* Ingrow *}

		inZoomin,InZoomOut:
		BEGIN
			IF QFenetre=FrontWindow THEN
			BEGIN
				WMouseDown := FALSE;
				IF TrackBox(QFenetre, pt, where) THEN
				BEGIN
					InvalRect(QFenetre^.portRect);
					ZoomWindow(QFenetre, where, TRUE);
					UpdateScrolls(Qfenetre);
				END;
			END
			ELSE IF GetWRefCon(FrontWindow)<>DlogRef THEN SelectWindow (QFenetre);
		END;
	
	END;  {case}

	SetPort(SavePort);
END;


{=================================================================
                 T R O U V E R	  U N	 H T E
 =================================================================}
FUNCTION HTEFindSelect(QFenetre: WindowPtr): TEHandle;
    VAR i: integer;
BEGIN
    FOR i:=1 TO PEcr.NbEcran DO
      IF (PEcr.Ecrans[i]^^.WEdit=QFenetre) THEN
         BEGIN
            HTEFindSelect:=PEcr.Ecrans[i]^^.Hte;
            EXIT(HTEFindSelect);
         END;
    HTEFindSelect:=Nil; { cas d'erreur ... }
END;


{$S UPDATE}
{=================================================================
      ( D E ) A C T I V A T E	 D ' U N E    F E N E T R E
 =================================================================}
PROCEDURE WActivateEvent(QFenetre: WindowPtr; Activate:BOOLEAN);

VAR	savePort	: GrafPtr;
	i			: integer;

BEGIN
    IF QFenetre=gdebugwindowptr THEN
       BEGIN
            IF Activate THEN SetPort(gdebugwindowptr);
            WWActivateEvent(Activate);
            EXIT(WActivateEvent);
       END;

    GetPort(savePort);
    SetPort(QFenetre);

    { meffi au refcon }
    CASE GetWRefCon(QFenetre) OF

        VRef:   { fenetre d'edition Videotex }
            IF Activate
                THEN
                    BEGIN   { Selection VideoTex }
                        SavePort:=GrafPtr(QFenetre);
                        SelFen(QFenetre);
                        VEActivate(QFenetre);
                        Memo;
                    END
                ELSE
                    BEGIN   { Deselection VideoTex }
                        VEDeactivate(QFenetre);
                        UnselFen;
						UnloadSeg(@DoColorMenu);	{ COMPOSEUR }
                    END;

        ERef:   { fenetre d'edition du Basic }
            IF Activate
                THEN
                    BEGIN   { Selection Texte }
                        SavePort:=GrafPtr(QFenetre);
                        SelFen(QFenetre);
                        TeActivate(hte);
                        DrawGrowIcon (EditPtr);
                        FOR I := 1 TO 2 DO
                        BEGIN
							ShowControl (monControl[I]);
							HiliteControl (monControl[I],0);
						END;
                        SetpRect(QFenetre);
                    END
                ELSE
                    BEGIN   { Deselection Texte }
                        TeDeactivate(HteFindSelect(QFenetre));
                        DrawGrowIcon (EditPtr);
                        FOR I := 1 TO 2 DO
                            HideControl (monControl[I]);
                        UnSelFen;
                    END;
		
		ExtRef:
			LActivate(Activate,ExtList)
			
			
    END; {case}

    SetPort(savePort);

END;


{$S UPDATE}
{=======================================================================
  S A U V E G A R D E	 D ' U N E    F E N E T R E    V I D E O T E X
 =======================================================================}
PROCEDURE SaveselFen;
BEGIN
    IF NOT gHandleFen | (PEcr.NbEcran=0) | (Screen=Nil) THEN EXIT(SaveSelFen);
    Screen^.SSel:=PSel;
    Screen^.ESel:=DSel;
    Screen^.Modified:=Modification;
    Screen^.Offx:=Offx;
    Screen^.Offy:=Offy;
    Screen^.WEcran:=ScreenPtr;
    Screen^.WEdit:=EditPtr;
    Screen^.hte:=hte;
    Screen^.Couleur:=Couleur;
    Screen^.BCouleur:=BCouleur;
    Screen^.Jeu:=Jeu;
    Screen^.Taille:=Taille;
    Screen^.Clignotement:=Clignotement;
    Screen^.Disjoint:=Disjoint;
    Screen^.Masquage:=Masquage;
    Screen^.Inverse:=Inverse;
    Screen^.Incrust:=Incrust;
    Screen^.Numero:=Numero;
    Screen^.MonControl:=MonControl;
    Screen^.SelRgn:=SelRgn;
    Screen^.IdleFlag:=IdleFlag;
    Screen^.Modification:=Modification;
    Screen^.ErrFlag:=ErrFlag;
    Screen^.NbVar:=NbVar;
    Screen^.NbCst:=NbCst;
    Screen^.LgCode:=LgCode;
    Screen^.CodeHdle:=CodeHdle;
    Screen^.VarTab:=VarTab;
    Screen^.CstTab:=CstTab;
    Screen^.HasMoved:=HasMoved;
END;


{=======================================================================
 D E S E L E C T I O N	  D ' U N E    F E N E T R E    V I D E O T E X
 =======================================================================}
PROCEDURE UnselFen;
BEGIN
    IF (Screen=Nil) | NOT gHandleFen | (PEcr.NbEcran=0) THEN EXIT(UnselFen);
    Screen^.SSel:=PSel;
    Screen^.ESel:=DSel;
    Screen^.Modified:=Modification;
    Screen^.Offx:=Offx;
    Screen^.Offy:=Offy;
    Screen^.WEcran:=ScreenPtr;
    Screen^.WEdit:=EditPtr;
    Screen^.hte:=hte;
    Screen^.Couleur:=Couleur;
    Screen^.BCouleur:=BCouleur;
    Screen^.Jeu:=Jeu;
    Screen^.Taille:=Taille;
    Screen^.Clignotement:=Clignotement;
    Screen^.Disjoint:=Disjoint;
    Screen^.Masquage:=Masquage;
    Screen^.Inverse:=Inverse;
    Screen^.Incrust:=Incrust;
    Screen^.Numero:=Numero;
    Screen^.MonControl:=MonControl;
    Screen^.SelRgn:=SelRgn;
    Screen^.IdleFlag:=IdleFlag;
    Screen^.Modification:=Modification;
    Screen^.ErrFlag:=ErrFlag;
    Screen^.NbVar:=NbVar;
    Screen^.NbCst:=NbCst;
    Screen^.LgCode:=LgCode;
    Screen^.CodeHdle:=CodeHdle;
    Screen^.VarTab:=VarTab;
    Screen^.CstTab:=CstTab;
	Screen^.mode:=mode;
    Screen^.HasMoved:=HasMoved;
	HUnlock(Handle(PEcr.Ecrans[CurrentS]));

    Screen:=Nil;
    ScreenPtr:=Nil;
    EditPtr:=Nil;
    Hte:=Nil;
    Modification:=False;
    NameFlag:=False;
END;


{=======================================================================
            S E L E C T I O N	 D ' U N E    F E N E T R E
 =======================================================================}
PROCEDURE SelFen(QFenetre: WindowPtr);

VAR i: integer;

BEGIN
	IF NOT gHandleFen THEN EXIT(SelFen);
	FOR i:=1 TO PEcr.NbEcran DO
		IF (PEcr.Ecrans[i]^^.WEcran=QFenetre) OR (PEcr.Ecrans[i]^^.WEdit=QFenetre) THEN
		BEGIN
			Currents:=i;
			MoveHhi(Handle(PEcr.Ecrans[CurrentS]));
			Hlock(Handle(PEcr.Ecrans[CurrentS]));
			Screen:=PEcr.Ecrans[CurrentS]^;
			ScreenPtr:=Screen^.WEcran;
			EditPtr:=Screen^.WEdit;
			hTe:=Screen^.hte;
			PSel:=Screen^.SSel;
			DSel:=Screen^.ESel;
			Modification:=Screen^.Modified;
			Offx:=Screen^.Offx;
			Offy:=Screen^.Offy;
			Couleur:=Screen^.Couleur;
			BCouleur:=Screen^.BCouleur;
			Jeu:=Screen^.Jeu;
			Taille:=Screen^.Taille;
			Clignotement:=Screen^.Clignotement;
			Disjoint:=Screen^.Disjoint;
			Masquage:=Screen^.Masquage;
			Inverse:=Screen^.Inverse;
			Incrust:=Screen^.Incrust;
			Numero:=Screen^.Numero;
			MonControl:=Screen^.MonControl;
			SelRgn:=Screen^.SelRgn;
			IdleFlag:=Screen^.IdleFlag;
			NameFlag:=Length(Screen^.FileName)<>0;
			Modification:=Screen^.Modification;
			ErrFlag:=Screen^.ErrFlag;
			NbVar:=Screen^.NbVar;
			NbCst:=Screen^.NbCst;
			LgCode:=Screen^.LgCode;
			CodeHdle:=Screen^.CodeHdle;
			VarTab:=Screen^.VarTab;
			CstTab:=Screen^.CstTab;
			Mode:=Screen^.Mode;
			HasMoved := Screen^.HasMoved;
			EXIT(SelFen);
		END;

     Screen:=Nil;
     ScreenPtr:=Nil;
     EditPtr:=Nil;
     Hte:=Nil;
     Modification:=False;
     NameFlag:=False;
END;

{=================================================================
            U P D A T E	   D ' U N E    F E N E T R E
 =================================================================}
{$S UPDATE}
PROCEDURE WUpdateEvent(Ev: EventRecord);
    VAR QFenetre: WindowPtr;
        savePort: GrafPtr;
        XCurrent: integer;

BEGIN
    QFenetre:=WindowPtr(Ev.message);

    IF QFenetre=gdebugwindowptr THEN
       BEGIN    { fenetre des erreurs }
            WWUpdateEvent;
            EXIT(WUpdateEvent);
       END;

    BeginUpdate(QFenetre);
    GetPort(savePort);
    SetPort(QFenetre);

	CASE GetWRefCon(QFenetre) OF

        VRef:   { fenetre d'edition Videotex }
            BEGIN
                IF QFenetre<>FrontWindow THEN
                   BEGIN    { on recupere le contexte de la fenetre a dessiner }
                        UnselFen;
                        SelFen(QFenetre);
                   END
                   ELSE Curoff(QFenetre);  { on efface le curseur }
                BackColor(whiteColor);
				EraseRect(QFenetre^.portrect);
				MonWDraw; {VEUpdate}
                IF QFenetre<>FrontWindow THEN
                   BEGIN    { on restaure le contexte de l'ancienne fenetre }
                        UnselFen;
                        SelFen(FrontWindow);
                   END;
            END;

        ERef:   { fenetre d'edition du Basic }
            BEGIN
                EraseRect(QFenetre^.portrect);
                TeUpdate(QFenetre^.portrect,HteFindSelect(QFenetre));
                DrawControls (QFenetre);
                DrawGrowIcon (QFenetre);
            END;

	{$IFC EMUL}
        EMRef:   { fenetre d'emulation }
            EM_Draw(QFenetre);
	{$ENDC}
	
		ExtRef:
			BEGIN
				UpdateExtDlog;
				LUpdate(QFenetre^.VisRgn,ExtList);
			END;
			
		DlogRef:	{ dialogue 'normal' }
			BEGIN
				DrawDialog(QFenetre);
				DrawButtonOutline(QFenetre);
			END;
			
    END; {case}

    SetPort(savePort);
    EndUpdate(QFenetre);
END;

{$S Main}
PROCEDURE HandleEvent(theEvent:EventRecord);

BEGIN
	gHandleFen := FALSE;
	MonEvent:=theEvent;	{ on remet l'évenement dans la globale MonEvent }
	CASE monEvent.what OF
		ActivateEvt:
			BEGIN
				WactivateEvent(WindowPtr(monEvent.message),Odd(monEvent.modifiers));
				ManageMenu;
				UnloadSeg(@WactivateEvent);		{ Update }
			END;
			
		UpdateEvt:
			BEGIN
				WupdateEvent(monEvent);
				UnloadSeg(@WupdateEvent);	{ Update }
			END;
			
		MouseDown:
			BEGIN
				Wh := FindWindow(monEvent.where, QFenetre);
				CASE Wh OF
				inSysWindow:
					SystemClick (monEvent, QFenetre);
				inDrag:
					IF WMouseDown(Wh, QFenetre, monEvent.where,monEvent.modifiers) THEN;
				END;  {* Case *}
				ManageMenu;	{ mise à jour des menus }
			END;  {* Mousedown *}
			
		app4Evt:
			EvenementMultiFinder;
	END;
	gHandleFen := TRUE;
END;


PROCEDURE DoHandleEvent;

VAR	theEvent: EventRecord;

BEGIN
	IF WaitNextEvent(everyEvent,theEvent,0,NIL) THEN HandleEvent(theEvent);
END;

{$S Main}
{=================================================================
                G E S T I O N	 D U    C U R S E U R
 =================================================================}
PROCEDURE CheckCursor;

VAR Pt: point;
	err: OsErr;
	TERgn: RgnHandle;
	
BEGIN
	IF FrontWindow=Nil THEN
        SetCursor(qd.arrow)
    ELSE
    IF FrontWindow=ScreenPtr THEN	{•••• Vidéotex ••••}
       BEGIN
           GetMouse(Pt);
           IF PtInRect(Pt,EditRect) THEN	{•• partie édition ••}
		   		CASE mode OF
					EditModeCst: SetCursor(ICurs^^);
					PenModeCst : SetCursor(MyPen^^);
				OTHERWISE
					SetCursor(qd.arrow);
				END
              ELSE
           IF PtInRect(Pt,JeuRect) THEN	{•• car. spéciaux ••}
		   		CASE mode OF
					EditModeCst: SetCursor(CCurs^^);
					PenModeCst : SetCursor(qd.arrow);
				OTHERWISE
					SetCursor(qd.arrow);
				END
           ELSE SetCursor(qd.arrow);
       END
    ELSE
    IF FrontWindow=EditPtr THEN	{•••• Basic ••••}
       BEGIN
			GetMouse(Pt);
			TERgn := NewRgn;
			IF gHasDrag THEN Err := TEGetHiliteRgn(TERgn, hTE);	{ 9/3/94 • Drag Manager }
			IF PtInRect(Pt,TeRect) & (PtInRgn(pt,TERgn)=FALSE) THEN
				SetCursor(ICurs^^)
            ELSE
				SetCursor(qd.arrow);
			DisposeRgn(TERgn);
       END
    ELSE
    IF (FrontWindow=gDebugWindowPtr) OR (FrontWindow=ExtDlog) THEN
       BEGIN
            SetCursor(qd.arrow);
       END;
END;


{$ Main}
PROCEDURE ManageMenu;
    VAR i,num: integer;
		Fc,Fd,Fm,Fi,Fn: boolean;
		TheItem, BTheItem: Integer;
        DScrap	        : ScrapStuffPtr;
        LongScrap       : LomemPtr;
		IO,Off			: Longint;
		theMenu			: MenuHandle;
		DAWindow		: BOOLEAN;
		NewMBAR			: INTEGER;
		EditState		: BOOLEAN;
		
		
PROCEDURE DoDrawMenuBar;

BEGIN
	IF gForceDrawBar | (EditState <> gEditEnable) | (gCurMBAR <> NewMBAR) THEN DrawMenuBar;
	gEditEnable := EditState;
	gCurMBAR := NewMBAR;
	gForceDrawBar:=FALSE;
END;


BEGIN
	NewMBar := gCurMBAR;
	IF RunFlag | (FrontWindow = NIL) | (FrontWindow <> ScreenPtr) THEN
	BEGIN
		IF (FrontWindow = NIL)
		 | (WindowPeek(FrontWindow)^.WindowKind > 0) THEN
			BEGIN
				NewMBAR := 1;
				IF gCurMBar<>NewMBAR THEN SetMenuBar(BasicBar);
			END;
	END
	ELSE
	BEGIN
		IF gCurMBar <> 2 THEN
		BEGIN
			NewMBAR := 2;
			IF gCurMBar<>NewMBAR THEN SetMenuBar(VtexBar);
		END;
	END;
	
	IO := GetScrap (NIL, 'TEXT', Off);
	FlagPPT:= FlagPPT OR (IO > 0);

	{ Menu Basic }
	theMenu := GetMHandle(BasicMenu);
	IF theMenu <> NIL THEN
	BEGIN
		EnableItem(theMenu,0);
		FOR i:=1 TO OffCompil DO DisableItem(theMenu,i);
		EnableItem(theMenu,OffTrace);
		EnableItem(theMenu,OffTrace2);
		IF NOT RunFlag THEN
		BEGIN
			EnableItem(theMenu,OffAnalys);
			EnableItem(theMenu,OffCompil);
		END;
		CheckItem(theMenu,OffTrace,TraceFlag);
		CheckItem(theMenu,OffTrace2,Trace2Flag);
	END;

	IF RunFlag THEN
	BEGIN
		DisableItem(GetMHandle(FileMenu),0);
		DisableItem(GetMHandle(EditMenu),0);
		EditState := FALSE;
		
		{ Menu Fenêtres }
		EnableItem(GetMHandle(FenMenu),0);
		UpdateWindMenu;
		
		{ Menu Basic }
		EnableItem(GetMHandle(BasicMenu),OffStop);

		DoDrawMenuBar;
		EXIT(ManageMenu);
    END;

	DAWindow := TRUE;
	
	{ Cas général }
    EnableItem(GetMHandle(AppleMenu),0);
    EnableItem(GetMHandle(FileMenu),0);
	EnableItem(GetMHandle(EditMenu),0);
	EditState := TRUE;
	EnableItem(GetMHandle(FenMenu),0);
	
	{ items menu Fichier }
    theMenu := GetMHandle(FileMenu);
	FOR i:=1 TO OffQuit-1 DO
        DisableItem(theMenu,i);
	EnableItem(theMenu,OffCServ);
	
    IF Pecr.NbEcran<MaxEcran THEN
	BEGIN
		EnableItem(theMenu,OffNew);
		EnableItem(theMenu,OffOpen);
		IF GetSelection<>'' THEN
		BEGIN
			EnableItem(theMenu,OffOpenSel);
			
		END;
		EnableItem(theMenu,OffDup);
	END;

	{ items menu Fenêtres }
	theMenu := GetMHandle(FenMenu);
	CheckItem(theMenu,OffWBas,WBasFlag);
	CheckItem(theMenu,OffWVid,WVidFlag);
	CheckItem(theMenu,OffWErr,WErrFlag);
	
	IF FrontWindow = NIL THEN
	BEGIN
		DisableItem(GetMHandle(EditMenu),0);
		EditState := FALSE;
		theMenu := GetMHandle(BasicMenu);
		EnableItem(theMenu,0);
	END
	ELSE
	BEGIN
		{•••• fenêtre Vidéotex ••••}
		IF FrontWindow = ScreenPtr THEN
		BEGIN
			DAWindow := FALSE;
			
			{ titres }
			EnableItem(GetMHandle(ColorMenu),0);
			EnableItem(GetMHandle(JeuMenu),0);
			
			{ raz du menu Edition }
			FOR i:=1 TO OffAll DO
				DisableItem(GetMHandle(EditMenu),i);
		
			{ raz du menu Couleur }
			FOR i:=1 TO FinBCouleur DO
				CheckItem(GetMHandle(ColorMenu),i,False);
		
			{ raz du menu Jeu }
			FOR i:=1 TO OffIncrust DO
				CheckItem(GetMHandle(JeuMenu),i,False);
	
			{ items }
			{ menu File }
			theMenu := GetMHandle(FileMenu);
			IF Modification AND NameFlag THEN
			BEGIN
				EnableItem(theMenu,OffSave);
				EnableItem(theMenu,OffOrg);
			END;
			EnableItem(theMenu,OffSup);
			EnableItem(theMenu,OffUnder);
			EnableItem(theMenu,OffClose);
			EnableItem(theMenu,OffTest);
			DisableItem(theMenu,OffFormat);
			DisableItem(theMenu,OffPrint);
	
			{ menu Edit }
			theMenu := GetMHandle(EditMenu);
			DisableItem(theMenu,OffUndo);
			IF PSel<>DSel THEN
			BEGIN
				EnableItem(theMenu,OffCut);
				EnableItem(theMenu,OffCopy);
				EnableItem(theMenu,OffDelete);
			END;
			IF FlagPP THEN EnableItem(theMenu,OffPaste);
			EnableItem(theMenu,OffAll);
			
			{ menu Couleur }
			theMenu := GetMHandle(ColorMenu);
			TheItem:=Couleur;
			CASE TheItem OF
				1: TheItem:=2;
				2: TheItem:=4;
				3: TheItem:=6;
				4: TheItem:=1;
				5: TheItem:=3;
				6: TheItem:=5;
			END;
			CheckItem(theMenu,TheItem+OffCouleur,True);
			BTheItem:=BCouleur;
			CASE BTheItem OF
				1: BTheItem:=2;
				2: BTheItem:=4;
				3: BTheItem:=6;
				4: BTheItem:=1;
				5: BTheItem:=3;
				6: BTheItem:=5;
			END;
			CheckItem(theMenu,BTheItem+OffBCouleur,True);
	
			{ menu Jeu }
			theMenu := GetMHandle(JeuMenu);
			CheckItem(theMenu,Jeu+OffJeu,True);
			CheckItem(theMenu,Taille+OffTaille,True);
			CheckItem(theMenu,OffClign,Clignotement);
			CheckItem(theMenu,OffDisjoint,Disjoint);
			CheckItem(theMenu,OffMasquage,Masquage);
			CheckItem(theMenu,OffInverse,Inverse);
			CheckItem(theMenu,OffIncrust,Incrust);
			
			IF PSel<>DSel THEN
				FOR i:=PSel TO DSel-1 DO
				WITH Screen^.Cars[i] DO
				BEGIN
					theMenu := GetMHandle(ColorMenu);
					
					IF VCouleur<>Couleur THEN
						CheckItem(theMenu,TheItem+OffCouleur,False);
					IF VBCouleur<>BCouleur THEN
						CheckItem(theMenu,BTheItem+OffBCouleur,False);
						
					theMenu := GetMHandle(JeuMenu);
	
					IF VJeu<>Jeu THEN
						CheckItem(theMenu,Jeu+OffJeu,False);
					IF VTaille<>Taille THEN
						CheckItem(theMenu,Taille+OffTaille,False);
					IF VTaille>=2 THEN i:=i+1;
					GetAttrib(VFlags,Fc,Fd,Fm,Fi,Fn);
					IF Fc<>Clignotement THEN
						CheckItem(theMenu,OffClign,False);
					IF Fd<>Disjoint THEN
						CheckItem(theMenu,OffDisjoint,False);
					IF Fm<>Masquage THEN
						CheckItem(theMenu,OffMasquage,False);
					IF Fi<>Inverse THEN
						CheckItem(theMenu,OffInverse,False);
					IF Fn<>Incrust THEN
						CheckItem(theMenu,OffIncrust,False);
				END;
			CheckTaille;
		END;
	
	
		{•••• TRACE ou Routines Externes ••••}
		IF (FrontWindow = gDebugWindowPtr) OR (FrontWindow = ExtDlog) THEN
		BEGIN
			DAWindow := FALSE;
			{ titres }
			DisableItem(GetMHandle(EditMenu),0);
			EditState := FALSE;
			theMenu := GetMHandle(BasicMenu);
			IF theMenu<>NIL THEN
			BEGIN
				EnableItem(theMenu,0);
				EnableItem(theMenu,OffTrace);
				EnableItem(theMenu,OffTrace2);
				EnableItem(theMenu,OffAnalys);
				EnableItem(theMenu,OffCompil);
			END;
		END;
	
	
		{•••• fenêtre Basic ••••}
		IF FrontWindow=EditPtr THEN
		BEGIN
			DAWindow := FALSE;
			
			{ titres }
			EnableItem(GetMHandle(BasicMenu),0);
	
			{ items menu File }
			IF Modification {•••• and NameFlag} THEN
			BEGIN
				EnableItem(GetMHandle(FileMenu),OffSave);
				EnableItem(GetMHandle(FileMenu),OffOrg);
			END;
			EnableItem(GetMHandle(FileMenu),OffUnder);
			EnableItem(GetMHandle(FileMenu),OffClose);
			EnableItem(GetMHandle(FileMenu),OffTest);
			EnableItem(GetMHandle(FileMenu),OffFormat);
			EnableItem(GetMHandle(FileMenu),OffPrint);
			
			{ menu Edit }
			theMenu := GetMHandle(EditMenu);
			FOR i := OffUndo TO OffGotoLine DO DisableItem(theMenu,i);
				
			IF (UndoData.Canundo) & (UndoData.doc = FrontWindow) THEN
				EnableItem(theMenu,OffUndo)
			ELSE
				DisableItem(theMenu,OffUndo);
			
			WITH Hte^^ DO
			BEGIN
				IF (SelStart<>SelEnd) THEN
				BEGIN
					EnableItem(theMenu,OffCut);
					EnableItem(theMenu,OffCopy);
					EnableItem(theMenu,OffDelete);
					EnableItem(theMenu,OffAlign);
					EnableItem(theMenu,OffSearchSel);
				END;
				IF FlagPPT THEN EnableItem(theMenu,OffPaste);
			END;
			EnableItem(theMenu,OffAll);
			EnableItem(theMenu,OffSearch);
			EnableItem(theMenu,OffReplace);
			IF length(FindData.FindStr)>0 THEN
			BEGIN
				EnableItem(theMenu,OffSearchNext);
				EnableItem(theMenu,OffReplaceNext);
			END;
			EnableItem(theMenu,OffShiftLeft);
			EnableItem(theMenu,OffShiftRight);
			EnableItem(theMenu,OffGotoLine);
			
			{ menu Basic }
			theMenu := GetMHandle(BasicMenu);
			IF ErrFlag THEN EnableItem(theMenu,OffSyntax);
			IF NameFlag THEN
				BEGIN
					EnableItem(theMenu,OffComp);
					{$IFC NOT DEMO }
					IF NOT BackFlag THEN
					{$ENDC }
						EnableItem(theMenu,OffRun);
				END;
		END; { Fenêtre = Basic }
		   
	
		IF DAWindow THEN
		BEGIN
			{ accessoire de bureau }
			{ titres }
			theMenu := GetMHandle(BasicMenu);
			IF theMenu<>NIL THEN
			BEGIN
				EnableItem(theMenu,0);
				EnableItem(theMenu,OffTrace);
				EnableItem(theMenu,OffTrace2);
				EnableItem(theMenu,OffAnalys);
				EnableItem(theMenu,OffCompil);
			END;
			
			{ items }
			theMenu := GetMHandle(EditMenu);
			IF theMenu<>NIL THEN
			BEGIN
				EnableItem(theMenu,OffUndo);
				EnableItem(theMenu,OffCut);
				EnableItem(theMenu,OffCopy);
				EnableItem(theMenu,OffPaste);
				EnableItem(theMenu,OffDelete);
				DisableItem(theMenu,OffAll);
				DisableItem(theMenu,OffSearch);		{ pas chercher/remplacer }
				DisableItem(theMenu,OffReplace);
				DisableItem(theMenu,OffSearchNext);
				DisableItem(theMenu,OffReplaceNext);
				DisableItem(theMenu,OffShiftLeft);
				DisableItem(theMenu,OffShiftRight);
				DisableItem(theMenu,OffAlign);
				DisableItem(theMenu,OffGotoLine);
			END;
		END;	{ Fenêtre = DA }
  	END;	{ FrontWindow <> NIL }
	
	{$IFC EMUL}
    IF EmulFlag THEN DisableItem(GetMHandle(FileMenu),OffTest);
	{$ENDC}
	
	UpdateWindMenu;
    DoDrawMenuBar;
	
END;	{ ManageMenu }


{$S INIT}
{=================================================================
                    I N I T I A L I S A T I O N S
 =================================================================}
PROCEDURE  GetMenus;

VAR     I		: INTEGER;
		TheMenu : MenuHandle;
BEGIN
    { on chope les menus dans les ressources }
    InitMenus;

    BasicBar := GetNewMBar(rMBARBasic);
	SetMenuBar(BasicBar);
	
	VtexBar := GetNewMBar(rMBARVtex);
	
	AddResMenu (GetMHandle(AppleMenu),'DRVR');
	
{$IFC Protection}
	Vectors := NewHandle(64);
{$ENDC}

END;



PROCEDURE SetUpExtDLOG;

VAR
		i			: INTEGER;
		R1,R2		: Rect;
		P1			: Point;
		Chaine		: Str255;
		H			: Handle;
		dataPtr		: Ptr;
		dataLen		: INTEGER;

	FUNCTION MyCompare (aPtr,bPtr: Ptr; aLen,bLen: INTEGER) : INTEGER;

	VAR
		i	: INTEGER;
		
	BEGIN
		i := IUMagString(aPtr,bPtr,aLen,bLen);
		IF i<0 THEN i:=0;
		MyCompare := i;
	END;
	
	
BEGIN
	ExtDlog := GetNewDialog(rExternDLOG,NIL,POINTER(-1));
	SetWRefCon(ExtDLOG,ExtRef);
	MoveWindow(ExtDlog,PosExt.Left,PosExt.Top,FALSE);
	
	IF (ExtDlog <> NIL) & (ExtNamesH <> NIL) THEN
	BEGIN
		GetDItem(ExtDlog,2,i,H,ExtRect2);
		GetDItem(ExtDlog,1,i,H,R1);
		WITH R1 DO
		BEGIN
			right := right-15;	{ pour l'ascenseur de droite }
		END;
		SetRect(R2,0,0,1,0);
		ExtList := LNew(R1,R2,Point(0),0,ExtDlog,TRUE,FALSE,FALSE,TRUE);
		IF ExtList <> NIL THEN
		BEGIN
			ExtList^^.SelFlags := LOnlyOne;
			FOR i := NbTokens TO NbTok-1 DO
			BEGIN
				IF i>NbTokens THEN
				BEGIN
					SetPt(P1,0,-1);
					dataPtr := @Chaine[1];
					dataLen := SizeOf(Chaine);
					REPEAT
						P1.v := P1.v+1;
						LGetCell(dataPtr,dataLen,P1,ExtList);
					UNTIL (P1.v >= i-NbTokens) |
						  (IUMagString( Ptr(Ord4(ExtNamesH^)+ExtNames[i-NbTokens]+1),
										dataPtr,
										Length(PStr255(Ord4(ExtNamesH^)+ExtNames[i-NbTokens])^),
										dataLen
										) < 1);
				END
				ELSE	SetPt(P1,0,0);
				{IF P1.v > i-NbTokens THEN P1.v := P1.v-1;}
				Err := LAddRow(1,P1.v,ExtList);
				LSetCell(	Ptr(Ord4(ExtNamesH^)+ExtNames[i-NbTokens]+1),
							Length(PStr255(Ord4(ExtNamesH^)+ExtNames[i-NbTokens])^),
							Cell(P1),ExtList);
			END;
		END;
	END;
	DisposHandle(ExtNamesH);
	
{$IFC Protection AND StopDebugger}
	HLock(Vectors);
	IF Vectors <> NIL THEN SuspendDebugger(Vectors);
	HUnlock(Vectors);
{$ENDC}

END;	{ SetUpExtDLOG }

{$S INIT}
PROCEDURE SetUp;

VAR     DScrap	    : ScrapStuffPtr;
        TSN,TSNT	: longint;
        hdlStr	    : StringHandle;
        j	  		: INTEGER;
        Resultat    : LONGINT;
        bounds	    : rect;
        flags	    : SerShk;
        fInfo	    : FontInfo;
        Err			: OSErr;
        TestSn	    : Str255;
		theDialog	: DialogPtr;
		theDialog2	: DialogPtr;
		
BEGIN
	InitGraf (@qd.thePort);
    InitFonts;
    InitWindows;
    TEInit;
    InitDialogs (NIL);
    FlushEvents (everyEvent,0);
    WWInit;
	Resultat := CompactMem (MaxSize);
    Err := SysEnvirons(curSysEnvVers,TheMac);
	
	IF theMac.SystemVersion>=$700 THEN
	BEGIN
		Err := Gestalt(gestaltStandardFileAttr, L);
		gNewSF := (Err=NoErr) & BTst(L,gestaltStandardFile58);
	END;
	
    { on remet la petite fleche }
    InitCursor;

	SetCursor(GetCursor(watchCursor)^^);
	
    SnFlag:=False; { true si erreur SN }
    
	{ gestion du presse-papiers }
	DScrap := InfoScrap;
    Etat := DScrap^.ScrapCount;
    IF DScrap^.ScrapSize > 0 THEN Etat := Etat - 1;

    CpScreen := ptEcran(newptr(sizeof(Ecran)));
    ExScreen := ptEcran(newptr(sizeof(Ecran)));

	{ comme ça on est bien en premier plan }
	FOR j := 1 TO 3 DO IF WaitNextEvent(0,MonEvent,0,NIL) THEN;
	
	ShowAbout;	{ affiche la fenêtre de démarrage }
	ShownWindowFlag:=TRUE;
	
	
    { Flags des fenetres affichees }
    WBasFlag:=True;
    WVidFlag:=False;
    WErrFlag:=False;
    VLstFlag:=False;
    ELstFlag:=False;
    CLstFlag:=False;

    LocalMode :=False;
    RunFlag :=False;
    TraceFlag :=False;	{ Trace complète }
    Trace2Flag := TRUE;	{ affichage des TRACE }
	FlagCC :=False;

    PrintVFlag:=False;
    PrintBFlag:=True;

	{ Flags par défaut du compilateur }
	CLVarFlag:=False;	{ Liste des variables }
	CMVarFlag:=False;	{ Map des variables }
	CDFlag:=TRUE;		{ •••• Compilation Disque }
	NamesFlag := FALSE;	{ Noms des écrans lors de la compil ? }
	IncLine:=False;		{ pour inclure les numéros de ligne }
	IncInst:=False;		{ pour inclure les numéros d'instruction }
	IncCheck:=False;	{ pour inclure un check sur tableaux }
	IncList:=False;		{ pour créer un listing de compilation }
	PreCompOverRide := TRUE;	{ on utilise uniquement les écrans précompilés }
	
	GetPrefs;
	
    { fenetre d'erreurs / writeln }
    GetIndString(gResStr,rSTRErrors,20);
	WWNew(PosTrace,gResStr,true,false,200,monaco,9);
	
    GetIndString(TestSn,259,1);

{$IFC Antivir}
	BadAVIR := TRUE;	{ par défaut c'est pas bon }
{$ENDC}

	FndStr:='';
	RemplStr:='';

    Screen := Nil;
    PEcr.NbEcran:=0;
    Hte:=Nil;
    ScreenPtr:=Nil;
    EditPtr:=Nil;

    { rectangle de Drag standard }
    WITH qd.screenBits.bounds DO
        BEGIN
            SetRect(StdDrag, 4, 24, right - 4, bottom - 4);
        END;

    GrowRect := qd.screenBits.bounds;
    InsetRect(GrowRect,4,4);
	GrowRect.Top := 75;
	GrowRect.Left := 100;
	
    { rectangle divers }
    SetRect(EditRect,10,10,330,250);
    SetRect(JeuRect,350,10,372,205);
	SetRect(BTexRect,347,257,366,275);
    SetRect(BPenRect,373,257,393,275);

    { quelques infos sur Monaco 9 }
    TextFont(Velizy);
    TextSize(10);
    drawchar(' ');
    SetFontLock(true);

    MySN:=SNH(GetResource('WINY',256));
    HNoPurge(Handle(MySn));

    { jeu graphique }
    TextFont(VidGraph);
    TextSize(10);
    drawchar(' ');
    SetFontLock(true);

    { jeu alterne }
    TextFont(Velizy);
    TextSize(10);
    drawchar(' ');
    SetFontLock(true);

    { on revient en Monaco 9 }
    TextFont(Monaco);
    TextSize(9);
    offx:=1; offy:=0;
    drawchar(' ');
    SetFontLock(true);
    TextMode(srcCopy);
    PenMode(patCopy);

    GetFontInfo(fInfo);
    CarWid := fInfo.WidMax;
    Largeur := (TeRect.right - TeRect.left) DIV CarWid;
    WITH fInfo DO
        BEGIN
            fgWidth := widmax;
            fgHeight := ascent + descent + leading;
            fgLnAscent := ascent;
        END;

    { calcul de coherence sn }
    WITH MySN^^ DO
    BEGIN
        TSN:=BXOR(TheMask,TheSN);
    END;

    TSNT:=0;
    FOR j:=0 TO 7 DO
        TSNT:=BOR(TSNT,(BSL(BAND(ord(TestSN[5+j]),$0F),28-(j*4))));
    SNFlag:=TSNT<>TSN;
    {Writeln(' test sn: ',snflag);}

    SNFlag:=False;

    { flags de sortie du programme }
    DoneFlag:=SnFlag;

    { flags du presse papier }
    FlagPP:=False;
    FlagPPT:=(DScrap^.ScrapSize > 0);

    { valeurs par defaut }
    DefValues;

    MonType:='VCOD';
    MonCreator:='DRG9';

    IdleFlag:=False;
    ExSelRgn:=NewRgn;

    IdleTime := TickCount;

    { on s'occupe des curseurs }
    ICurs:=GetCursor(1);
    HnoPurge(Handle(ICurs));
    CCurs:=GetCursor(2);
    HnoPurge(Handle(CCurs));
    WCurs:=GetCursor(4);
    HnoPurge(Handle(WCurs));
	MyPen:=GetCursor(256);
	HnoPurge(Handle(MyPen));
	
    { on initialise le tokeniseur }
    InitTokens;

    { on initialise VideoWork }
    InitVWork;
    UnloadSeg(@InitVWork);	{ COMPOSEUR }

    { on initialise E/S }
	
	BackFlag:=False;
	InitIO;
	
    { on met les flags ok pour un boot du serveur }
    BootTime:=TickCount+60*15; {15 secondes d'attentes}
    BootFlag:=True;
    SnCount:=2000;
    SnSched:=TickCount+10800;
    MonMain:=Nil;

    { on va chercher les menus }
    GetMenus;		{ Protection: alloue un Handle pour la protection }

	SetUpExtDLOG;	{ Protection: suspend aussi le debugger !!!}

	{$IFC EMUL}
	EM_Init;
	UnloadSeg(@EM_init);	{ Videotex }
	{$ENDC}
	
(*
	RefHelp:=-13;
	CloseDeskAcc(RefHelp);
	RefHelp:=0;
*)

{$IFC Protection}
(*
	GetConfig2;		{ i <> 0 si fichier vérouillé }
	Err := ReadDateTime(L);
	IF ABS(L-BXor(gTheProt.Date,94100))>BSL(168,8) THEN
		gTheProt.compteur := Bxor(gTheProt.compteur,4397) -1;
	j := gTheProt.Compteur;
	DoneFlag := (gTheProt.compteur < 1)
				| (i<>0)	{ globale modifiée par GetConfig2 }
				| (L >=  BXor(gTheProt.Date,94100) + BSL($5703,8))
				| (BXor(gTheProt.Date,94100) > L);
	gTheProt.compteur := Bxor(gTheProt.compteur,4397);
*)
	GetConfig2;		{ i <> 0 si fichier vérouillé }
	Err := ReadDateTime(L);
	gTheProt.compteur := Bxor(gTheProt.compteur,4397) -1;
	j := gTheProt.Compteur;
	DoneFlag := (gTheProt.compteur < 1)
				| (i<>0)	{ globale modifiée par GetConfig2 }
				| (L >=  BXor(gTheProt.Date,94100) + BSL($5703,8))
				| (BXor(gTheProt.Date,94100) > L);
	gTheProt.compteur := Bxor(gTheProt.compteur,4397);
	IF DoneFlag | (i<>0) | (j<1) | (L=BXor(gTheProt.Date,94100)) THEN
	BEGIN
		compteur := 0;
		IF FloppyPresent THEN	{ il y a un lecteur, alors on contrôle la protection }
		BEGIN
			IF (DoNotify(compteur,1) <> Bsr($2BE8,3)) & (DoNotify(compteur,2) <> Bsr($2BE8,3)) THEN
			BEGIN
				SetCursor(qd.arrow);
				HideAbout;
				theDialog:= GetNewDialog(ProtDLOG,nil,Pointer(-1));
				CenterDlog(theDialog);
				monEvent.Message := 1;
				REPEAT
					Err := UnmountVol(NIL,LoWrd(MonEvent.Message));
					Err := Eject(Nil,LoWrd(MonEvent.Message));
					DrawDialog(theDialog);
					REPEAT
						IF Compteur = wPrErr THEN Err := Alert(ProtALRT,NIL);
						Compteur := 0;
						IF WaitNextEvent(updateMask+diskMask+mDownMask,MonEvent,30,NIL) THEN
							IF IsDialogEvent(MonEvent) & DialogSelect(MonEvent,theDialog2,i) & (i = 1) THEN
								EXIT(DragsterEdit);
					UNTIL (MonEvent.what = diskEvt);
				UNTIL DoNotify(compteur,LoWrd(MonEvent.Message))=Bsr($15F4,2);
				Err := ReadDateTime(gTheProt.Date);
				Err := UnmountVol(NIL,LoWrd(MonEvent.Message));
				Err := Eject(Nil,LoWrd(MonEvent.Message));
				gTheProt.Date := BXor(gTheProt.Date,94100);
				DialogEnd(theDialog);
				gTheProt.compteur := Bxor(14,4397);
			END;
		END;	{ IF FloppyPresent }
	END;
	gProt := DoneFlag;
	DoneFlag := FALSE;
	gTheProt.key := ValidateConf;
	SaveConfig2;
{$ENDC}


	WITH FindData DO
	BEGIN
		FindStr := '';
		ReplaceStr := '';
		CaseSens := FALSE;
		DiacSens := FALSE;
		WrapFind := TRUE;
		WordFind := FALSE;
	END;

	gGotoLine := 0;
	gHandleFen := TRUE;

{$IFC Protection}
{$IFC StopDebugger }
	HLock(Vectors);
	IF Vectors <> NIL THEN RestoreDebugger(Vectors);
	DisposHandle(Vectors);
{$ENDC}

	IF j = 1 THEN	{ on demandera la disquette au prochain démarrage ! }
	BEGIN
		HideAbout;
		theDialog := GetNewDialog(ProtDLOG2,nil,Pointer(-1));
		CenterDlog(theDialog);
		SysBeep(60);
		DrawDialog(theDialog);
		SysBeep(60);
		L := Tickcount;
		SetCursor(GetCursor(watchCursor)^^);
		REPEAT
			IF GetNextEvent(updateMask,MonEvent) & IsDialogEvent(MonEvent) THEN
			BEGIN
				BeginUpdate(theDialog);
				DrawDialog(theDialog);
				EndUpdate(theDialog);
			END;
		UNTIL (TickCount > L+300) | Button;
		DialogEnd(theDialog);
	END;
{$ENDC}

	SetCursor(GetCursor(watchCursor)^^);
	
    IF NOT EmulFlag THEN WordEdAlign;	{ recherche du modem maitre }

	HideAbout;	{ on vire la fenêtre de démarrage }

    PrintHdl := THPrint(NewHandle(120));  {120 pour printdefault}
    MoveHHi(Handle(PrintHdl));
	HLock(Handle(PrintHdl));
	
	SetCursor(GetCursor(watchCursor)^^);
	
{$IFC Antivir}
	DoneFlag := VerifyAvir($43971717,$45111020,TRUE) | DoneFlag;
{$ENDC}

	IF WErrFlag & (DoneFlag=FALSE) THEN ShowWindow(gDebugWindowPtr);

	SetCursor(qd.arrow);
{$IFC Antivir}
	BadAVIR := DoneFlag;
{$ENDC}

	IF (Gestalt(gestaltAppleEventsAttr,L)=NoErr)
	 & BTst(L,gestaltAppleEventsPresent) THEN InitAEVTStuff;	{ <aevt> }
	 
	MyPicButton:=PicHandle(GetResource('PICT',257));
	HnoPurge(Handle(MyPicButton));

{$IFC DRAGANDDROP}
	{ on peut faire du Drag & Drop ? }
	gHasDrag := BTst(GetGestaltResult(gestaltDragMgrAttr),gestaltDragMgrPresent) & BTst(GetGestaltResult(gestaltTEAttr),gestaltTEHasGetHiliteRgn);
	IF gHasDrag THEN DoDragInit;
{$ELSEC}
	gHasDrag := FALSE;
{$ENDC}

	InitCursorCtl(NIL);
END;  {* Setup *}

{$S Main}
PROCEDURE ThatsAll;
BEGIN
    { CloseResFile(FontFile); }
    StopIO;
	IF RefHelp<>0 THEN CloseDeskAcc(RefHelp);
	SavePrefs;
END;



{$S Main}
{========================================================================
                                D O B A S I C
 ========================================================================}
PROCEDURE DoBasic(TheItem: Integer);

    VAR i: integer;
        return : integer;
        TempStr: str255;
        CodePos: longint;
        LineErr: integer;
        temp64 :str64;
        EtiqFlag,
        WhilFlag,
        IfFlag: boolean;
    	VAR Size: Longint;
		theDialog: DialogPtr;
		r1,r2: Rect;
		h: Handle;
		
BEGIN
    SauveSel;
	SaveSelFen;
    
	unloadseg(@Doprint);		{ Impression }
	unloadseg(@GetMenus);		{ Init }
    UnloadSeg(@Tokenize);		{ Tokeniseur }
    UnloadSeg(@Detokenize);		{ DETOKENISEUR }
    UnloadSeg(@CodeGen);		{ COMPILATEUR }
{$IFC DEMO=FALSE}
    UnloadSeg(@PreCodeGen);		{ PRECOMPILATEUR }
{$ENDC}

	IF NOT RunFlag THEN
	BEGIN
		PurgeMem(MaxSize);
    	size:=CompactMem(MaxSize);
	END;
	
    CASE TheItem OF

        OffSyntax:
            BEGIN { tentative de tokenisation }
                IF NOT Closing THEN InvalRect(TeRect);
				SetCursor(WCurs^^);
				Modification:=True;
                ShowWindow(gDebugWindowPtr);
                
				ParamText(screen^.filename,'','','');
				theDialog := GetNewDialog(135,NIL,Pointer(-1));
				CenterDlog(theDialog);
				DrawDialog(theDialog);
				GetDItem(theDialog,2,i,h,r1);
				SetPort(theDialog);
				PenNormal;
				FrameRect(r1);
				InSetRect(r1,1,1);
				r2 := r1;
				
				WErrFlag:=True;

                { on verifie que le dernier caractere du texte est un return }
                IF Hte^^.TeLength>0 THEN
                    BEGIN
                        IF Ord(Ptr(Ord4(Hte^^.hText^)+Hte^^.TeLength-1)^)<>$0D THEN
                            BEGIN
                                return := $0D00;
                                SetHSize(Hte^^.hText,Hte^^.TeLength+1);
                                BlockMoveData(@return, Ptr(Ord4(Hte^^.hText^)+Hte^^.TeLength),1);
                                Hte^^.TeLength:=Hte^^.TeLength+1;
                                TeCalText(hTe);
                            END;
                    END;

                 { on resete les tables de var, cst, code }
                 InitTables;
                 LgCode:=0;
                 SetHSize(Handle(CodeHdle),0);
				 				 
                 { on essaie de tokeniser le texte }
                 Hlock(Handle(hte^^.htext));
                 ErrFlag:=False;
                 i:=1;
				 CodePos := Hte^^.Nlines;

                 Tempin:=CharsPtr(hte^^.htext^);
                 WHILE (i<=Hte^^.Nlines) AND (NOT ErrFlag) DO
                    BEGIN
                        Curs:=hte^^.lineStarts[i-1];
                        Tokenize;
                        IF NOT ErrFlag THEN
                           BEGIN
                            LgCode:=LgCode+ResListe^^.LParam;
                            IF LgCode<0 THEN
							BEGIN
								ErrFlag := TRUE;
								GetIndString(ErrorStr,rSTRErrors,34);
								i:=0;
							END
							ELSE i:=i+1;	{ Ligne suivante… }
                           END;
						SetPort(theDialog);
						r2.right := r2.left+((r1.right-r1.left)*LONGINT(i)) DIV CodePos;
						PenPat(qd.Gray);
						PaintRect(r2);
                    END;
					
                 HUnlock(Handle(hte^^.htext));
                 HideWindow(theDialog);
				 UnloadSeg(@Tokenize);	{ TOKENISEUR }

                 IF ErrFlag THEN
                  BEGIN
                      IF i>0 THEN
					  BEGIN
						  { recuperation de la ligne en erreur }
						  TempStr:='';
						  LineErr:=i-1;
						  i:=hte^^.lineStarts[LineErr];
						  WHILE CharsPtr(Ord4(hte^^.htext^)+i)^[0]<>chr($0D) DO
							BEGIN
							  TempStr:=concat(TempStr,' ');
							  TempStr[Length(TempStr)]:=
								CharsPtr(Ord4(hte^^.htext^)+i)^[0];
							  i:=i+1;
							END;
	
						  { affichage de la ligne }
						  { affichage de la position et message d'erreur }
						  WWlnStr(TempStr);
						  FOR i:=1 TO ErrPos-1 DO WWriteCh(' ');
						  WWriteStr('î ');
					  END;
					  WWlnStr(ErrorStr);

                      { positionnement du textedit sur la ligne d'erreur }
                      { calculer le nouveau dest rectangle }
                      TeCalText(hTe);
                      TeSetSelect(hTe^^.LineStarts[LineErr]+ErrPos-1,hTe^^.LineStarts[LineErr]+ErrPos-1,hte);
                      FocalHte(TRUE);
                  END
                 ELSE
                  BEGIN
				  
				 	  {WWlnStr(' Verif etiq ');} { #######################}

                      { ok, pas d'erreurs de syntaxe }
                      { on verifie les étiquettes }
					  { •• on inclu la liste si Cmd-Shift-Y •• }
                      IF ELstFlag THEN
					  BEGIN
					  	GetIndString(gResStr,rSTRErrors,21);
						WWlnStr(gResStr);
					  END;
                      FOR i:=1 TO NbVar DO
                        IF (VarTab^^[i].tpvar=fetiq) OR (VarTab^^[i].tpvar=fuetiq) THEN
						BEGIN
							IF ELstFlag THEN WWriteStr(VarTab^^[i].NomVar);
							IF NOT VarTab^^[i].defined THEN
							BEGIN
								IF NOT ELstFlag THEN 
								BEGIN
									GetIndString(gResStr,rSTRErrors,22);
									WWriteStr(gResStr);
									WWriteStr(concat('<<',VarTab^^[i].NomVar,'>>'));
								END;
								GetIndString(gResStr,rSTRErrors,23);
								WWlnStr(gResStr);
								ErrFlag:=true;
							END
							ELSE
								IF ELstFlag THEN WWlnStr('');
						END;
						
					EtiqFlag:=ErrFlag;
					WhilFlag:=NbWF>0;
					ErrFlag:=EtiqFlag OR WhilFlag;
					
					{WWlnStr(' Verif vars ');} { #######################}

					IF VLstFlag OR Shifted THEN
					BEGIN
						WWlnStr('');
						GetIndString(gResStr,rSTRErrors,24);
						WWlnStr(gResStr);
						FOR i:=1 TO NbVar DO
							IF (VarTab^^[i].tpvar<>fetiq) AND
								(VarTab^^[i].tpvar<>fUetiq) AND
								(NOT VarTab^^[i].shared) THEN WWlnStr(VarTab^^[i].NomVar);
		
						WWlnStr('');
						GetIndString(gResStr,rSTRErrors,25);
						WWlnStr(gResStr);
						FOR i:=1 TO NbVar DO
							IF (VarTab^^[i].tpvar<>fetiq) AND
								(VarTab^^[i].tpvar<>fUetiq) AND
								(VarTab^^[i].shared) THEN WWlnStr(VarTab^^[i].NomVar);
					END;
					
					{WWlnStr(' Verif csts ');} { #######################}
					
					IF CLstFlag THEN
					BEGIN
						WWlnStr('');
						GetIndString(gResStr,rSTRErrors,26);
						WWlnStr(gResStr);
						FOR i:=1 TO NbCst DO WWLnStr(concat('"',CstTab^^[i],'"'));
					END;
					
					WWlnStr('');
					
					IF NOT ErrFlag THEN
					BEGIN
						{WWlnStr(' debut detok ');} { #######################}
						GetIndString(gResStr,rSTRErrors,27);
						WWlnStr(gResStr);
						{ on Detokenise, pour le nouveau texte }
						HUnLock(Handle(Hte));
						SetHSize(hte^^.hText,0);
						hte^^.TeLength:=0;
						CodePos:=0;
						WHILE CodePos<LgCode DO
						BEGIN
							SetHSize(Handle(Resliste),TParamPtr(Ord4(CodeHdle^)+CodePos)^.LParam);
							BlockMoveData(Ptr(Ord4(CodeHdle^)+CodePos),Ptr(ResListe^),TParamPtr(Ord4(CodeHdle^)+CodePos)^.LParam);
							Detokenize;
							TempOut:=Concat(Tempout,chr($0D));
							SetHSize(hte^^.htext,hte^^.TeLength+Length(TempOut));
							BlockMoveData(@TempOut[1],Ptr(Ord4(Hte^^.hText^)+hTe^^.TeLength),Length(Tempout));
							hte^^.TeLength:=hte^^.TeLength+Length(TempOut);
							CodePos:=CodePos+TParamPtr(Ord4(CodeHdle^)+CodePos)^.LParam
						END;
						HUnLock(Handle(Hte));
						
						TeCalText(hTe);
						
						IF NameFlag THEN DoFile(OffSave);
					END
					ELSE
					BEGIN
						IF EtiqFlag THEN
						BEGIN
							GetIndString(gResStr,rSTRErrors,28);
							WWlnStr(gResStr);
						END;
						IF WhilFlag THEN
						BEGIN
							GetIndString(gResStr,rSTRErrors,29);
							WWriteStr(gResStr);
							WWriteNum(NbWF,1);
							GetIndString(gResStr,rSTRErrors,30);
							WWlnStr(gResStr);
						END;
					END;
				END;
				
				IF ErrFlag THEN SelectWindow(gDebugWindowPtr);
				
				UnloadSeg(@Detokenize);		{ DETOKENISEUR }
				DialogEnd(theDialog);
            END;

        OffComp:
            BEGIN
                hilitemenu(0);
				
                IF Option THEN	{ options de compilation… }
				BEGIN
					OptCompilDLOG(FALSE);
					SelFen(FrontWindow);
				END;
				IF Screen=NIL THEN EXIT(DoBasic);	{ pas de fenetre basic courante ! }
				
				IF Ctrl | (Shifted=FALSE) THEN
				BEGIN
					IF ErrFlag THEN DoBasic(OffSyntax);
                	IF ErrFlag THEN EXIT(DoBasic);
					temp64:=screen^.filename;
                END
				ELSE Temp64 := '';	{ précompilation }
				
				ShowWindow(gDebugWindowPtr);
                { SelectWindow(gDebugWindowPtr); }
    
{$IFC DEMO=FALSE}            
				IF Ctrl THEN	{ précompilation… }
					return := PreCodeGen(HandleEvent,temp64,screen^.volnumber,screen^.DirID)
				ELSE
{$ENDC}
					IF Shifted THEN
						{ utilisation d'une précompil. }
						return:=CodeGen(HandleEvent,temp64,0,0)
					ELSE
						{ compilation "normale" }
						return:=CodeGen(HandleEvent,temp64,screen^.volnumber,screen^.DirID);
				
				UnloadSeg(@CodeGen);	{ COMPILATEUR }
{$IFC DEMO=FALSE}
				UnloadSeg(@PreCodeGen);	{ PRECOMPILATEUR }
{$ENDC}
                IF ErrFlag & (return <> Noerr) THEN
                BEGIN
					SysBeep(60);
					SysBeep(60);
					SysBeep(60);
					WWlnStr('');
                    GetIndString(gResStr,rSTRErrors,31);
					WWriteStr(gResStr);
					WWlnNum(return,1);
					GetIndString(gResStr,rSTRErrors,36);
					Notify(gResStr,256);
                END
                ELSE
				BEGIN	{ pas d'erreur }
					GetIndString(gResStr,rSTRErrors,32);
					WWlnStr(gResStr);
					GetIndString(gResStr,rSTRErrors,35);
					Notify(gResStr,256);
				END;
				SelFen(FrontWindow);
            END;

        OffRun:
            BEGIN
                hilitemenu(0);
                IF ErrFlag THEN DoBasic(OffSyntax);
                IF ErrFlag THEN EXIT(DoBasic);
                RunFlag:=True;
                ShowWindow(gDebugWindowPtr);
                SelectWindow(gDebugWindowPtr);
                ManageMenu;
                temp64:=screen^.filename;
                GetIndString(gResStr,rSTRErrors,33);
				WWriteStr(gResStr);
				WWLnStr(concat('"',temp64,'"'));
			{$IFC EMUL}
				IF EmulFlag THEN EM_Open;
			{$ENDC}
                return:=XCute(temp64,screen^.volnumber,screen^.DirID,@MainEventLoop);
                UnloadSeg(@Xcute);					{ Interpreteur }
                UnloadSeg(@BaseAdd);				{ Interpreteur1 }
                UnloadSeg(@BaseMaxSize);			{ Interpreteur2 }
                UnloadSeg(@InitInterpretorLib);		{ InterpreteurLib }
				UnloadSeg(@GInit);					{ WinTree }
				
                IF ErrFlag THEN
                BEGIN
                    GetIndString(TempStr,rSTRErrors,8);
					WWriteStr(TempStr);
					WWriteNum(return,1);
					{ Message d'erreur en clair }
					GetIndString(TempStr,rSTRIntErrors,return);
					WWLnStr(concat(' ',TempStr));
                END
                ELSE
				BEGIN
					GetIndString(TempStr,rSTRErrors,7);
					WWlnStr(tempStr);
				END;
				
			{$IFC EMUL}
				IF EmulFlag THEN EM_Close;
				UnloadSeg(@EM_init);	{ EMULATEUR }
			{$ENDC}
                MonMain:=Nil;
				gForceDrawBar := TRUE;
				ManageMenu;
            END;

        OffStop:
            BEGIN
                RunFlag:=False;
            END;

        OffTrace:
            BEGIN
                TraceFlag:=NOT TraceFlag;
				IF TraceFlag THEN Trace2Flag := TRUE;
            END;

        OffTrace2:
			Trace2Flag:=NOT Trace2Flag;

        OffAnalys:
			OptAnalysDLOG;
			
		OffCompil:
			OptCompilDLOG(TRUE);
			
    END;
    IdleTime:=TickCount;
	
	unloadseg(@GetMenus);		{ Init }
    UnloadSeg(@Tokenize);		{ Tokeniseur }
    UnloadSeg(@Detokenize);		{ Detokeniseur }
    UnloadSeg(@CodeGen);		{ Compilateur }
{$IFC DEMO=FALSE}
    UnloadSeg(@PreCodeGen);		{ PreCompilateur }
{$ENDC}
	
	IF NOT RunFlag THEN
	BEGIN
		PurgeMem(MaxSize);
		size:=CompactMem(MaxSize);
	END;
END;

{========================================================================
                            D O C O M M A N D
 ========================================================================}

{$S DIALOGS}
PROCEDURE ShowAbout;

VAR     theItem			: INTEGER;
        thetype		    : integer;
        titem		    : handle;
        thebox		    : rect;
		
BEGIN
	ParamText(GetVersion,GetDateVersion,'','');
	WDrawDialog := GetNewDialog (256, NIL, POINTER (-1));

	IF ShowColor THEN
		MyPic:=PicHandle(GetResource('PICT',258))
	ELSE
		MyPic:=PicHandle(GetResource('PICT',256));
	
	GetDItem(WDrawDialog,1,thetype,titem,theBox);
	SetDItem(WDrawDialog,1,picItem,Handle(MyPic),theBox);
	
	CenterDlog(WDrawDialog);
	DrawDialog(WDrawDialog);
	ShownWindowFlag:=True;
END;


{$S DIALOGS}
PROCEDURE HideAbout;

BEGIN
	IF ShownWindowFlag THEN
	BEGIN
		DialogEnd(WDrawDialog);
		ReleaseResource(Handle(MyPic));
		ShownWindowFlag:=False;
	END;
END;


{$S Main}
FUNCTION DoCommand (MenuSel: LONGINT):BOOLEAN;

VAR     theMenu, theItem,
        Temp		    : INTEGER;
        TestSn,
        TestV,
        Name		    : Str255;
        monDialog	    : DialogPtr;
        thetype		    : integer;
        titem		    : handle;
        thebox		    : rect;

BEGIN
	theMenu := HiWord (MenuSel);
	theItem := LoWord (MenuSel);
	DoCommand := theMenu <> 0;
  
  CASE theMenu OF
		
    AppleMenu:
    BEGIN
      SauveSel;
      IF theItem = 1 THEN
      BEGIN
		ShowAbout;
		REPEAT
            ModalDialog(NIL,Temp);
        UNTIL Temp>0;
        HideAbout;
		UnloadSeg(@ShowAbout);	{ Dialogs }
      END  {* If = 1 *  A propos… }
      ELSE
      BEGIN
        GetItem (GetMHandle(AppleMenu), theItem, Name);
		Temp := OpenDeskAcc (Name);
      END;  {* Else *}
    END;

    FileMenu   : DoFile(TheItem);

    EditMenu   : DoEdit(TheItem);

    ColorMenu   : DoColorMenu(TheItem);

    JeuMenu   : DoJeu(TheItem);

    FenMenu   : DoFen(TheItem);

    BasicMenu : IF NOT SnFlag THEN
				BEGIN
					Closing := FALSE;
					DoBasic(TheItem);
				END;

  END; {* Case themenu *}
  HiliteMenu (0);

END;  {* docommand *}


{$S Main}
{=================================================================
               B O U C L E    D ' E V E N E M E N T S
=================================================================}

PROCEDURE EvenementMultiFinder;

BEGIN
	CASE Bsr(MonEvent.message, 24) OF
		1:		{ suspend / resume }
		BEGIN
			gForeGround := (Band(MonEvent.message, 1) = 1);
			IF FrontWindow<>NIL THEN WActivateEvent(FrontWindow,gForeGround);
		END;
		
		$FA:	{ mouse moved }
			;
	END;
END;

PROCEDURE SpecialMenu(before:BOOLEAN);

VAR theMenu:MenuHandle;
	sel: Str255;
	
BEGIN
	IF gCurMBar=1 THEN	{ barre de menu BASIC }
	BEGIN
		chaine:='';
		IF before THEN
		BEGIN
			IF Shifted THEN	{ compil. à partir d'une précompil. }
			BEGIN
				GetIndString(chaine,263,2);
				EnableItem(GetMHandle(BasicMenu),OffComp);
				IF Chaine<>'' THEN SetItem(GetMHandle(BasicMenu),offComp,chaine);
			END;
			
			{ mise à jour item 'Chercher ""' }
			GetIndString(Chaine,263,4);
			Sel := GetSelection;
			IF length(Sel)>10 THEN	{ sélection trop longue pour le menu ! }
			BEGIN
				Sel[0]:=chr(11);
				Sel[11]:='…';
			END;
			Chaine := concat(Chaine,'"',Sel,'"');
			IF Chaine<>'' THEN SetItem(GetMHandle(EditMenu),offSearchSel,chaine);
			
			{ mise à jour item 'Ouvrir ""' }
			GetIndString(Chaine,263,6);
			Sel := GetSelection;
			IF length(Sel)>15 THEN	{ sélection trop longue pour le menu ! }
			BEGIN
				Sel[0]:=chr(16);
				Sel[16]:='…';
			END;
			Chaine := concat(Chaine,'"',Sel,'"');
			IF Chaine<>'' THEN SetItem(GetMHandle(FileMenu),offOpenSel,chaine);
		END
		ELSE
		BEGIN
			{ on remet l'item "Compiler" }
			GetIndString(chaine,263,1);
			IF Chaine<>'' THEN SetItem(GetMHandle(BasicMenu),offComp,chaine);
			{ on remet l'item "Chercher sélection" }
			GetIndString(chaine,263,3);
			IF Chaine<>'' THEN SetItem(GetMHandle(EditMenu),offSearchSel,chaine);
			{ on remet l'item "Ouvrir sélection" }
			GetIndString(chaine,263,5);
			IF Chaine<>'' THEN SetItem(GetMHandle(FileMenu),offOpenSel,chaine);
		END;
	END;
END;


PROCEDURE MainEventLoop;

VAR
	Update: BOOLEAN;
	Sleep: LONGINT;
	OldFront: WindowPtr;	{ FrontWindow avant le trait. de l'évènement }
	
BEGIN
    {PurgeMem(MaxSize);
     size:=CompactMem(MaxSize);}

{$IFC Antivir}
	IF BadAVIR THEN EXIT(DragsterEdit);
{$ENDC}

	Sleep := 0;
	
    IF NOT RunFlag THEN
    BEGIN
        CheckCursor;

        IF gForeGround THEN
		BEGIN
			IF FrontWindow<>Nil THEN
				IF FrontWindow=EditPtr THEN TeIDle(Hte);
	
			IF (TickCount-IdleTime)>IdleSpeed THEN
			   BEGIN
					IdleTime:=TickCount;
					IF (FrontWindow<>Nil) & (FrontWindow=ScreenPtr) THEN
							VEIDle(ScreenPtr);
					WWIdle;
			   END;
		END;
		
        IF SnSched<TickCount THEN
        BEGIN
            SnSched:=TicKCount+10800+(TickCount MOD 5000);
            IF NOT EmulFlag THEN WordEdAlign;
        END;
		Sleep := 30;
    END
    ELSE IF gForeGround THEN SetCursor(qd.arrow);

    WHILE WaitNextEvent(everyEvent,monEvent,Sleep,NIL) DO
	BEGIN
		Sleep := 0;
		OldFront := FrontWindow;
		IF SnFlag THEN SnCount:=SnCount-1;
		Shifted := (BitAnd(monEvent.modifiers,ShiftKey)<>0);
		Option := (BitAnd(monEvent.modifiers,OptionKey)<>0);
		Ctrl := (BitAnd(monEvent.modifiers,ControlKey)<>0);
		gHandleFen := TRUE;
		
		CASE monEvent.what OF
		MouseDown:
			BEGIN
				BootFlag:=False;
				HideAbout;
				Wh := FindWindow (monEvent.where, QFenetre);
				CASE Wh OF
				inMenuBar:
					BEGIN
						SetCursor(qd.Arrow);
						SpecialMenu(TRUE);
						Update := DoCommand(MenuSelect(monEvent.where));
						SpecialMenu(FALSE);
					END;
				inSysWindow:
					SystemClick (monEvent, QFenetre);
				inContent, inDrag, inGoAway, InGrow, InZoomin, InZoomOut:
					Update := WMouseDown(Wh, QFenetre, monEvent.where,monEvent.modifiers);
				END;  {* Case *}
				gForceDrawBar:= FrontWindow<>OldFront;
				ManageMenu;	{ mise à jour des menus }
			END;  {* Mousedown *}
	
		KeyDown, autoKey:
			BEGIN
				IF BitAnd(monEvent.modifiers,256)<>0 THEN
				BEGIN
					Update := DoCommand(MenuKey (CHR (monEvent.Message MOD 256)));
				END
				ELSE WKey(CHR (monEvent.Message MOD 256));
				gForceDrawBar:= FrontWindow<>OldFront;
				ManageMenu;	{ mise à jour des menus }
			END;
	
		ActivateEvt:
			BEGIN
				WactivateEvent(WindowPtr(monEvent.message),Odd(monEvent.modifiers));
				gForceDrawBar:= FrontWindow<>OldFront;
				ManageMenu;
			END;
			
		UpdateEvt:
			BEGIN
				WupdateEvent(monEvent);
				UnloadSeg(@WupdateEvent);	{ Update }
			END;
	
		diskEvt:
			BEGIN
				IF HiWrd(monEvent.message) <> noErr THEN
				Err := DIBadMount(point($00320064), monEvent.message)
			END;

		app4Evt:
			EvenementMultiFinder;
			
		kHighLevelEvent:
			Err := AEProcessAppleEvent(monEvent) ;	{ <aevt> }

		END;	 {* Case *}
		
	END;	{ WHILE WaitNextEvent… }
	
END; { MainEventLoop }


PROCEDURE _DataInit; EXTERNAL;

{$S Main}
PROCEDURE Unload;

BEGIN
	UnloadSeg(@CalCur);			{ composeur }
	UnloadSeg(@WWIdle);			{ trace }
	UnloadSeg(@WUpdateEvent);	{ update }
	UnloadSeg(@Abort);			{ fichiers }
	UnloadSeg(@AddBuffer);		{ dragsterIO }
	UnloadSeg(@ShowColor);		{ utils }
	UnloadSeg(@SetUp);			{ init }
END;

{=================================================================
                                M A I N
 =================================================================}
BEGIN   {* Programme principal *}	
	{ 50Ko de pile de plus que d'habitude svp }
	SetApplLimit(ptr(LomemPtr($908)^-50*1024));
	MaxApplZone;
	MyRefFile:=CurResFile;
  
	GetAppParms(gAppName,gAppRefNum,Hdl);
	{ Non relocatable allocation blocks }
	
	FOR i := 1 TO 10 DO MoreMasters;
	
	TheSerBuf:=NewPtr(xSerBufSz);
	TheAuxSerBuf:=NewPtr(xSerBufSz);

  	InitUtilities;
	SetUp;
	IF DoneFlag THEN EXIT(DragsterEdit);
	
	UnloadSeg(@InitUtilities);	{ UtilInit }
  	Unload;
	
	FlushEvents(everyEvent,0);
  
	IF NOT StScreen THEN;	{ ouverture des documents du Finder }
	
	gCurMBAR := -1;
	gForceDrawBar:=TRUE;
	ManageMenu;
	
	gForeGround := TRUE;
	
	PurgeMem(1000000);
	L := CompactMem(1000000);

	WHILE NOT DoneFlag DO
	BEGIN
		MainEventLoop;
		Unload;
	END;
  
	ThatsAll;

END.  {* Programme principal *}
