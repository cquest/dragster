PROGRAM DragsterBoot;

{$SETC AntiVir = FALSE}
{$SETC DEBUG=FALSE}

{$IFC UNDEFINED MACARBO}
{$SETC MACARBO=FALSE}
{$ENDC}

{$IFC UNDEFINED DEMO}
{$SETC DEMO=FALSE}
{$ENDC}

{$SETC AEVT=FALSE}
{$SETC SYS7ONLY=TRUE}

{************************************************************************}
{*																																			*}
{*	      Fichier Implementation Boot Background Videotex								*}
{*																																			*}
{************************************************************************}

USES	MemTypes,QuickDraw ,OSIntf ,ToolIntf ,PackIntf, AppleTalk,
		ADSP, SysEqu, AppleEvents, TextUTils,
		{$U $$Shell(PUtilities) } Utilities, Antivirus, EVELib,
		DragsterInit1, DragsterINIT2, DragsterInitProt;
		
TYPE
		UTable	= ARRAY[0..10000] OF DCtlHandle;
		UPtr	= ^UTable;
		DrvrHdrHdl	= ^DrvrHdrPtr;
		DrvrHdrPtr	= ^DrvrHdr;
		DrvrHdr		= RECORD
			Dummy   : ARRAY[0..8] OF integer;
			DrvrName: str255;
		END;
	
		SizeRes = RECORD
			Flags: INTEGER;
			Preferred: LONGINT;
			Minimum: LONGINT;
		END;
		SizeResPtr = ^SizeRes;
		SizeResHdl = ^SizeResPtr;
		
		LongStuffType		= RECORD   {For type conversions}
				CASE Integer OF
					1:
							(long: longint);
					2:
							(HiWrd,LoWrd: Integer);
					3:
							(HiByte,HiMidByte,LoMidByte,LoByte: SignedByte);
				END;	   {LongStuffType}

		{ tableau de stockage des datas pour les routines externes }
		DatasRec =	RECORD
									Name: StringHandle;		{ nom de ces datas… }
									thePtr: Ptr;					{ pointeur à conserver… }
								END;
		DatasArray = RECORD
				NbDatas: INTEGER;
				Datas: ARRAY [1..10000] OF DatasRec;
		END;
		DPtr = ^DatasArray;
		DHandle = ^DPtr;
		
		{ tableau des procedures d'arrêt }
		ShutDownRec = ARRAY [0..1000] OF RECORD
										procPtr: Ptr;						{ adresse à rappeler }
										dataPtr: Ptr;						{ data à repasser en paramètre }
									END;
		ShutDownPtr = ^ShutDownRec;
		ShutDownH = ^ShutDownPtr;


CONST	r_menubar = 128;
		r_menupomme = 128;
		i_a_propos = 1;
		r_menufichier = 129;
{$IFC MACARBO}
		i_visu = 1;
		i_config = 3;
		i_quitter = 5;

			o_STARTs = 42248;		{ offset des variables de MacARBO }
			o_STs = 23300;
			o_OUs = 6400;
			o_QD = 23040;
			o_NC = 39940;
			o_NCMAX = 740;
			o_LCs = 42760;

{$ELSEC}
		i_visu = 1;
		i_debug = 2;
		i_config = 4;
		i_quitter = 6;
		
{$ENDC}

{		r_MenuServer = 130;		}
		i_RelaunchServer = 1;
		i_DisconnectUser = 3;
		i_RestartUser = 4;

		r_DLOGvisu = 260;
		r_PICTNB = 128;
		r_PICTCouleur = 129;
		r_PICTDemo = 259;
		r_STRJCA = 256;
		r_ALRTa_propos = 256;
		r_DLOGConfirmQuit = 259;
		
		r_WINDinvis = 128;
		
{$I DragsterTCB.p }
{$I DrgLink.p}		 {Définitions des TYPE, CONST etc, de DrgLink}

VAR
  fname   	: Str255;
	apRefNum	: INTEGER;
	apParam		: Handle;
	TheEvent	: EventRecord;
	TheDrvRef	: integer;
	TheLJump	: LIPtr;
	Err			  : integer;
	DrgHandle	: Handle;	{ TempHandle de Dragster (Système 7) }
	DrgPtr		: Ptr;		{ Ptr de Dragster (Système 6) }
	DrgSize		: LONGINT;
	L				  : LONGINT;
	theRes		: Handle;
	
	reLaunch	: BOOLEAN;	{ indique si on doit se redémarrer }
	
	screenlimits	: Rect;
	DrgLink				: DrgLinkHndl;  	{c'est pour causer à Dragster }
	gDoneFlag			: BOOLEAN;			{ indique si on quitte }
	suspended			: boolean;  		{ indique si appli en backgnd }
	Visu					: WindowPtr;  	{ c'est ma fenètre de visu ! }
	LoopDelay			: LONGINT;
	lastTicks			: Longint;
	OFFSET				: LONGINT;
	gVisuDebug		: BOOLEAN;
	theLine				: INTEGER;
	gCanQuit			: BOOLEAN;
	
	tempStr				: Str255;
	theQueue			: TQPtr;
	theData				: DHandle;
	
  MyLaunch			: RECORD
                		pfname:^Str255;
                		param: integer;
               	  END;
	
	pb 			: RECORD
					  {12 byte header used by the file and IO system}
					  qLink: QElemPtr;	{queue link in header}
					  qType: INTEGER;		{type byte for safety check}
					  ioTrap: INTEGER;	{FS: the Trap}
					  ioCmdAddr: Ptr;		{FS: address to dispatch to}
	   
					  {common header to all variants}
					  ioCompletion: ProcPtr;	   {completion routine addr (0 for synch calls)}
					  ioResult: OSErr;		   {result code}
					  ioNamePtr: StringPtr;	   {ptr to Vol:FileName string}
					  ioVRefNum: INTEGER;	   {volume refnum (DrvNum for Eject and MountVol)}
	   
					  ioRefNum: INTEGER;    {refNum for I/O operation}
					  CSCode: INTEGER;	      {word for control status code}
					  CSParam: Ptr;  {operation-defined parameters}
					END;
	
	InvisWindow : WindowPtr;
	AboutWindow	: DialogPtr;
	gAboutPict	: Handle;
	gMsgItem		: Handle;
	gAutoStart	: BOOLEAN;		{ indique si le serveur doit démarrer automatiquement }
	gRelaunch		: BOOLEAN;		{ indique si l'on attend pour relancer le serveur }
	gDoRelaunch	: BOOLEAN;		{ indique si l'on doit relancer le serveur }
	gDoQuit			: BOOLEAN;		{ indique si l'on attend pour arrêter le serveur }
	gDoBeep			: BOOLEAN;		{ indique si il faut faire des "beep" quand on quitte }
	ShutDownProcs: ShutDownH;

	kPrefFileName		: Str255;
	prefs						: INTEGER;
	
	
PROCEDURE LaunchIt(TheLaunch: Ptr);
INLINE $205F, $A9F2;

PROCEDURE Jsr(addr: ProcPtr); INLINE $205F,$4E90;
{ MOVE (A7)+,A0 ; JSR (A0) }

PROCEDURE HandleQueue;
FORWARD;


{$S Main}
FUNCTION Concatnum(str:str255; num:longint):str255;

VAR	tempStr:Str255;

BEGIN
	numtostring(num,tempstr);
	concatnum := concat(str,tempstr);
END;


{$S Main}
PROCEDURE ShowMsg(Msg:Integer);

VAR	Str			: Str255;
		r				: Rect;
		theType	: INTEGER;

BEGIN
	IF AboutWindow<>NIL THEN
	BEGIN
		IF gMsgItem=NIL THEN
		BEGIN
			GetDItem(AboutWindow,3,theType,gMsgItem,r);
			WITH AboutWindow^.portRect DO
				SizeWindow(AboutWindow,right-left,bottom-top+24,FALSE);
		END;
		
		GetIndString(Str,260,msg);
		SetIText(gMsgItem,Str);
	END;
END;

{$S Main}
PROCEDURE DrawButtonOutline(dlog: DialogPtr; itemNum: INTEGER);

VAR
	itemType: INTEGER;
	item: Handle;
	box: Rect;
	thePen: PenState;
	
BEGIN
	{ on entoure le bouton par défaut }
	GetDItem(dlog,itemNum,itemType,item,box);
	SetPort(dlog);
	GetPenState(thePen);
	PenSize(3,3); InsetRect(Box,-4,-4);
	FrameRoundRect(Box,16,16);
	SetPenState(thePen);
END;


PROCEDURE ChooseQuit;

VAR
	dlog: DialogPtr;
	itemHit: INTEGER;
	i: INTEGER;
	itemType: INTEGER;
	item: Handle;
	box: Rect;
	quitType: INTEGER;
	thePen: PenState;
	
BEGIN
	dlog := GetNewDialog(r_DLOGConfirmQuit, NIL, POINTER(-1));
	quitType := 1;
	IF dlog=NIL THEN
		gDoneFlag := TRUE
	ELSE
	BEGIN
		gDoneFlag := FALSE;
		gDoQuit := FALSE;
		gRelaunch := FALSE;
		
		{ on entoure le bouton par défaut }
		DrawButtonOutline(dlog, 1);

		{ on sélectionne le bouton radio par défaut }
		GetDItem(dlog,3,itemType,item,box);
		SetCtlValue(ControlHandle(item),1);
		
		REPEAT
			ModalDialog(NIL,itemHit);
			IF itemHit IN [3,4,5] THEN
			BEGIN
				FOR i := 3 TO 5 DO
				BEGIN
					GetDItem(dlog,i,itemType,item,box);
					SetCtlValue(ControlHandle(item),INTEGER(itemHit=i));
				END;
				quitType := itemHit-2;
			END;
		UNTIL itemHit IN [1,2];
		IF itemHit = 2 THEN	{ OK }
		BEGIN
			IF quitType = 1 THEN gDoQuit := TRUE;		{ quitter qd plus personne }
			IF quitType = 2 THEN gDoneFlag := TRUE;	{ quitter immédiatement }
			IF quitType = 3 THEN gRelaunch := TRUE;	{ relancer le serveur qd plus personne }
		END;
		DisposDialog(dlog);
	END;
END;

{$S UTILS}
PROCEDURE DoShutDownProcs;

VAR	nbProcs: INTEGER;
		i: INTEGER;
		pb: TQERec;
		ThePtr: TPtr;
		
BEGIN
	nbProcs := GetHandleSize(Handle(ShutDownProcs)) DIV SizeOf(ShutDownRec);
	HLock(Handle(ShutDownProcs));
	ThePtr := DrgLink^^.ThePtrs[1];	{ TCB de la première tâche… }
	FOR i := 1 TO NbProcs DO
		WITH ThePtr^, ThePtr^.TheQueues^[ShutDownQ], ShutDownProcs^^[i-1] DO
		BEGIN
			pb.ERet := 1;						{ traitement en cours }
			pb.ECode := 1;					{ appel ShutDownProc }
			pb.EParam1 := procPtr;	{ adresse à appeler }
			pb.EParam2 := DataPtr;	{ ptr données à fournir }
			pb.EOwner := NIL;
			pb.QLink := NIL;
			IF QNumber = 0 THEN
				BEGIN
					QFirst := @pb;
					QEnd := @pb;
				END
			ELSE
				BEGIN
					QEnd^.QLink := @pb;
					QEnd := @pb;
				END;
			QNumber := QNumber + 1;
			WHILE pb.eRet>0 DO	{ requete en cours de traitement }
			BEGIN
				SystemTask;
				HandleQueue;
			END;
			
		END;	{ WITH … }
		
	HUnlock(Handle(ShutDownProcs));
	DisposHandle(Handle(ShutDownProcs));
END;


PROCEDURE RemoveDragster(complete:BOOLEAN);	{ retire le driver Dragster (si présent) }

VAR
	theUTable	: UPtr;
	refNum		: INTEGER;
	i					: INTEGER;
	MPPPB			: MPPParamBlock;
	ThePtr		: TPtr;
	pb				: TQERec;
	
BEGIN
	SetCursor(GetCursor(watchCursor)^^);
	refNum:=-(RechDrag+1);	{ recherche de Dragster en mémoire… }
	IF refnum<>0 THEN				{ Dragster présent ? }
	BEGIN
		{ appel des procédures d'arrêt }
		DoShutDownProcs;
		
		{ fermeture fichier si Dragster déjà lancé }
		IF DrgGlobs.started THEN
		BEGIN
			{ il faut fermer les bases et fichiers ouverts par le serveur… }
			ThePtr := DrgLink^^.ThePtrs[1];	{ TCB de la première tâche… }
			{ on commence par les bases }
			WITH ThePtr^, ThePtr^.TheQueues^[BaseQ] DO
			BEGIN
				pb.ECode := -1;	{ closeAll ! }
				pb.EOwner := NIL;
				pb.QLink := NIL;
				IF QNumber = 0 THEN
					BEGIN
						QFirst := @pb;
						QEnd := @pb;
					END
				ELSE
					BEGIN
						QEnd^.QLink := @pb;
						QEnd := @pb;
					END;
				QNumber := QNumber + 1;
				Delay(120,L);
			END;
			{ on termine par les fichiers }
			WITH ThePtr^, ThePtr^.TheQueues^[FileQ] DO
			BEGIN
				pb.ECode := -1;	{ closeAll ! }
				pb.EOwner := NIL;
				pb.QLink := NIL;
				IF QNumber = 0 THEN
					BEGIN
						QFirst := @pb;
						QEnd := @pb;
					END
				ELSE
					BEGIN
						QEnd^.QLink := @pb;
						QEnd := @pb;
					END;
				QNumber := QNumber + 1;
				Delay(120,L);
				{ si pb.Ecode <> 0, les fichiers ne sont toujours pas fermés par FileTask ! }
			END;
		END;
		
		IF DrgGlobs.MemoryHold THEN	{ déverouillage mémoire virtuelle }
			Err := UnHoldMemory(DrgPtr,DrgSize);

		Err:=CloseDriver(refNum);	{ on stoppe Dragster }
		
		{ on supprime le spyer }
		IF DrgGlobs.SpyerPtr<>NIL THEN Jsr(ptr(ord4(DrgGlobs.SpyerPtr)+4));
		
		WITH DrgGlobs DO
		BEGIN
			{ on referme les drivers série utilisés }
			IF PortAUsed THEN
			BEGIN
				Err := KillIO(-6);
				Err := KillIO(-7);
				Err := CloseDriver(-6);
				Err := CloseDriver(-7);
			END;
			IF PortBUsed THEN
			BEGIN
				Err := KillIO(-8);
				Err := KillIO(-9);
				Err := CloseDriver(-8);
				Err := CloseDriver(-9);
			END;
			{ on se dépublie du réseau }
			IF NBPData.ObjStr <>'' THEN
			BEGIN
				MPPPB.nbpPtrs := @NBPData;
				Err := PRemoveName(@MPPPB,FALSE);
{$IFC DEBUG}
				IF Err<>NoErr THEN DebugStr(concatnum('PRemoveName Err=',Err));
{$ENDC}
			END;
			
			{ on supprime les connections ADSP }
			FOR i := 0 TO 32 DO
			BEGIN
				IF ADSPData[i]=NIL THEN Leave;	{ y'en a plus ! }
				WITH DSPPBPtr(AdspData[i])^ DO
				BEGIN
					IF i>0 THEN
					BEGIN
						csCode := dspRemove;		{ connection normale }
						abort := 1;
					END
					ELSE
						csCode := dspCLRemove;	{ connection listener }
				END;
				Err := PBControl(AdspData[i],FALSE);
{$IFC DEBUG}
				IF Err<>NoErr THEN DebugStr(concatnum('DspRemove Err=',Err));
{$ENDC}
			END;
		END;
		
		IF complete THEN			{ on retire même le driver de la table… }
		BEGIN
			theUTable := UPtr(LIPtr(UTableBase)^);
			DisposHandle(Handle(theUTable^[-refNum-1]));
			theUTable^[-refNum-1]:=NIL;	{ DCtlHandle à NIL }
		END;
	END;
END;


{$S UTILS}	{ <aevt> }
FUNCTION HandleQUIT(theAppleEvent,reply: AppleEvent; handlerRefcon: LONGINT ):OSErr;		{ <aevt> }

BEGIN
	HandleQUIT := noErr ;
	gDoneFlag:=TRUE;
END;


{$S INIT}
PROCEDURE MyInit;

VAR Menus : Handle;

BEGIN
	IF gRelaunch=FALSE THEN	{ vient-on de relancer le serveur ? }
	BEGIN
		{-------------- Chargement des menus… -----------}
		Menus := GetNewMBar(r_menubar);
		SetMenuBar(Menus);
		AddResMenu(GetMHandle(r_menupomme),'DRVR');
		DrawMenuBar;
		ReleaseResource(Menus);
		
	  screenlimits := qd.screenbits.bounds;   { Limite pour les Drag et Grow }
		insetrect(screenlimits,2,2);
		
		{ <aevt> }
		Err:=AEInstallEventHandler(kCoreEventClass,kAEQuitApplication,@HandleQUIT,0,false);
		
		theQueue := NIL;	{ pas encore initialisée… }
		theData := NIL;		{ sera initialisée au premier StoreData }
		ShutDownProcs := ShutDownH(NewHandle(0));
	END;
	
	gRelaunch := FALSE;
	gDoRelaunch := FALSE;
	gDoQuit := FALSE;
	gDoBeep := FALSE;
END;


{$S Main}
FUNCTION ShowColor:BOOLEAN;

BEGIN
	ShowColor := (gQDVersion>0) & (GetGDevice^^.gdpMap^^.pixelSize > 2);
END;


PROCEDURE ShowAbout;

VAR
	theType: INTEGER;
	tItem: Handle;
	theBox: Rect;
	
BEGIN
	IF AboutWindow=NIL THEN
	BEGIN
		AboutWindow := GetNewDialog(r_ALRTa_propos,NIL,POINTER(-1));
		ParamText(GetVersion, GetDateVersion,'','');

		IF ShowColor THEN
			gAboutPict:=GetResource('PICT',258)
		ELSE
			gAboutPict:=GetResource('PICT',256);
		
		IF gAboutPict<>NIL THEN
		BEGIN
			GetDItem(AboutWindow,1,thetype,titem,theBox);
			SetDItem(AboutWindow,1,picItem,gAboutPict,theBox);
		END;
		
		CenterDlog(AboutWindow);
		DrawDialog(AboutWindow);
	
		gMsgItem := NIL;
	END;
END;


PROCEDURE RemoveAbout;

BEGIN
	IF AboutWindow<>NIL THEN
	BEGIN
		DisposDialog(AboutWindow);
		ReleaseResource(gAboutPict);
		AboutWindow := NIL;
		gMsgItem := NIL;
	END;
END;


{$S UTILS}
PROCEDURE ErrorManager(TheError: INTEGER; Quit: BOOLEAN);

VAR
	ErrorStr: str255;
	i		: integer;
	TempRes	: Handle;
	
BEGIN
	RemoveAbout;
	IF TheError<>-1 THEN	{ on affiche l'erreur ? }
	BEGIN
		IF TheError>0 THEN
			GetIndString(ErrorStr,257,TheError+1)
		ELSE
		BEGIN
			NumToString(TheError,ErrorStr);
			ErrorStr:=concat('Erreur système n° ',ErrorStr);
			TheRes := GetResource('ERR ',theError);
			IF theRes<>NIL THEN
				ErrorStr := concat(ErrorStr,CHAR(13),StringHandle(TheRes)^^);
		END;
	  ParamText(ErrorStr,'','','');
	  Err:=MyAlert(257);
	END;
	
	IF Quit THEN	{ il faut quitter Dragster ? }
	BEGIN
		RemoveDragster(TRUE);	{ on retire le driver de Dragster }
		EXIT(DragsterBoot);
	END;
END;

{$S INIT}
FUNCTION GoodFile(name:Str255):BOOLEAN;
{ indique si le fichier est bien un fichier exécutable Dragster }

VAR	fndrInfo:FInfo;

BEGIN
	GoodFile:=FALSE;
	Err:=GetFInfo(name,0,fndrInfo);
  IF Err=NoErr THEN
		WITH fndrInfo DO
{$IFC DEMO=FALSE}
			goodFile := (fdType='CODE') & ((fdCreator='DRG0') | (fdCreator='DRG1'));
{$ELSEC}
			goodFile := (fdType='CODE') & ((fdCreator='DRG0') | (fdCreator='DRG1')) | ((fdType = 'CODd') & (fdCreator = 'DRGd'));
{$ENDC}
END;


{$S Config}
PROCEDURE ConfigLicence;

VAR
		Temp				: INTEGER;
		monDialog		: DialogPtr;
		tp					: integer;
		ith					: handle;
		box					: rect;
		s						: Str255;
		tab2				: Str255;
		itemHit			: INTEGER;
		i						: INTEGER;
		sH					: StringHandle;
		res					: Handle;
		
BEGIN	
  monDialog := GetNewDialog (263, NIL, POINTER (-1));

  CenterDlog(MonDialog);	{ centre et affiche }

	GetDItem(monDialog,3,Tp,ith,Box);
  SetIText(ith,'');
	
	DrawButtonOutline(monDialog, 1);
	
	REPEAT
		ModalDialog(NIL,itemHit);
		IF itemHit=1 THEN	{ OK }
		BEGIN		{ contrôle du numéro de licence }
    	GetIText(ith,s);
			IF (Length(s) <> 22) THEN		{ contrôle longueur numéro de série }
				itemHit := 0
			ELSE
			BEGIN
				FOR i := 1 to Length(s) DO
					IF (s[i] < '0') or (s[i]>'9') THEN
						itemHit := 0;
				IF NOT IsLicOK(s) THEN
					itemHit := 0;
			END;
			
			IF itemHit = 0 THEN
				SysBeep(60);								
		END;
	UNTIL ItemHit IN [1,2];
	
	IF (itemHit = 1) THEN	{ enregistrement numéro de licence }
	BEGIN
		tp := CurResFile;
		UseResFile(gAppResRef);	{ enregistrement dans l'appli }

		{ 13/9/99 - suppression ancien N° de série }
		REPEAT
			res := Get1Resource('DRGK',128);
			IF (res <> NIL) THEN
				RemoveResource(res);
		UNTIL (res = NIL);
		
		sH := NewString(s);
		AddResource(Handle(sH),'DRGK',128,'');
		WriteResource(Handle(sH));
		ReleaseResource(Handle(sH));
		IF prefs<>0 THEN
		BEGIN
			UseResFile(prefs);	{ enregistrement dans les prefs }

			{ 13/9/99 - suppression ancien N° de série }
			REPEAT
				res := Get1Resource('DRGK',128);
				IF (res <> NIL) THEN
					RemoveResource(res);
			UNTIL (res = NIL);
			
			sH := NewString(s);
			AddResource(Handle(sH),'DRGK',128,'');
			WriteResource(Handle(sH));
			ReleaseResource(Handle(sH));
		END;
		UseResFile(tp);
	END;
	
	DisposDialog(monDialog);
END;	{ procedure ConfigLicence }


FUNCTION ConfigScreen(BootOk: Boolean): integer;

LABEL 0;

CONST
	TheDBsz		=	14;
	BootCst		=	15;

VAR OurStor	    : TConfHdle;
		Temp				: INTEGER;
		monDialog		: DialogPtr;
		TempS,
		TempN				: str255;
		tp					: integer;
		ith					: handle;
		box					: rect;
		i						: integer;
		Num					: Longint;
		MaxTime			: Longint;
		AutoFlag		: Boolean;
		TheEvent		: EventRecord;
		RetCode			: Integer;
		thePen			: PenState;
		
BEGIN
	RemoveAbout;
	
	RetCode:=0;
	 
	{--------- recherche de la ressource de configuration ----------}
	
	SetResLoad(TRUE);
	ourStor := TConfHdle(GetResource('CONF',256));
	IF (ourStor = Nil) THEN	{ il faut créer une ressource de config. par défaut… }
	BEGIN
		ourStor := TConfHdle(NewHandle(SizeOf(TConfRecord)));
		WITH ourStor^^ DO
		BEGIN
    	SerPort:=0;	{ port modem }
{$IFC DEMO OR MACARBO}
			SerSpeed := 94;	{ 1200Bds }
{$ELSEC}
			SerSpeed := 0;
{$ENDC}
			MessSize := 1024;
			NbAux:=0;
			RWBSize:=256;
			DBComSize:=0;
			AntPqSize:=0;		{ libre }
			X25Number:=0;		{ libre }
			WModNumber:=0;	{ libre }
			InBuffSz:=InBuffSzMin;
      TheXScreen:='';
		END;
		AddResource(Handle(ourStor),'CONF',256,'');
	END;
	HnoPurge(Handle(OurStor));

  monDialog := GetNewDialog (255, NIL, POINTER (-1));

	ParamText(GetVersion,GetDateVersion,'','');
  CenterDlog(MonDialog);	{ centre et affiche }

	NumToString(OurStor^^.MessSize,TempN);
    GetDItem(monDialog,9,Tp,ith,Box);
    SetIText(ith,TempN);

	NumToString(OurStor^^.NbAux,TempN);
    GetDItem(monDialog,10,Tp,ith,Box);
    SetIText(ith,TempN);

	IF ourStor^^.SerPort IN [0,1] THEN
	BEGIN
		GetDItem(monDialog,ourStor^^.SerPort+4,Tp,ith,Box);
		SetCtlValue(ControlHandle(ith),1);
		GetDItem(monDialog,6,Tp,ith,Box);
		SetCtlValue(ControlHandle(ith),0);
	END
	ELSE
	BEGIN
		GetDItem(monDialog,4,Tp,ith,Box);
		SetCtlValue(ControlHandle(ith),0);
		GetDItem(monDialog,5,Tp,ith,Box);
		SetCtlValue(ControlHandle(ith),0);
		GetDItem(monDialog,6,Tp,ith,Box);
		SetCtlValue(ControlHandle(ith),1);
	END;
	
	NumToString(OurStor^^.DBComSize,TempN);
	GetDItem(monDialog,TheDBsz,Tp,ith,Box);
	SetIText(ith,TempN);

	GetDItem(monDialog,BootCst,Tp,ith,Box);
	IF BootOk THEN
		HiliteControl(ControlHandle(ith),0)
	ELSE
		HiliteControl(ControlHandle(ith),255);
	
	TempS:=ourStor^^.TheXScreen;
	GetDItem(monDialog,3,Tp,ith,Box);
	SetIText(ith,TempS);
	SelIText(monDialog,3,0,255);

	DrawButtonOutline(monDialog, 1);

	AutoFlag:=FALSE;
	MaxTime:=TickCount;
	
	0:
	REPEAT
	  TeIdle(DialogPeek(monDialog)^.textH);
	  IF WaitNextEvent(everyEvent,TheEvent,0,NIL) THEN
	  BEGIN
			IF (TheEvent.what IN [keydown,mousedown]) THEN AutoFlag:=False;
			IF IsDialogEvent(TheEvent) THEN
		  BEGIN
		  	{ ESC pour Annuler et RETURN ou ENTER pour Ok }
		  	IF (TheEvent.what=keydown) AND ((TheEvent.message MOD 256=27)
											OR (TheEvent.message MOD 256=13)
											OR (TheEvent.message MOD 256=03))
				THEN
				BEGIN
					IF (TheEvent.message MOD 256=27) THEN Temp:=2 ELSE Temp:=1;
				END
				ELSE
					IF DialogSelect(TheEvent,monDialog,temp) THEN
						IF (Temp IN [4,5,6]) THEN
						BEGIN
							GetDItem(monDialog,4,Tp,ith,Box);
							SetCtlValue(ControlHandle(ith),LONGINT(Temp=4));
							GetDItem(monDialog,5,Tp,ith,Box);
							SetCtlValue(ControlHandle(ith),LONGINT(Temp=5));
							GetDItem(monDialog,6,Tp,ith,Box);
							SetCtlValue(ControlHandle(ith),LONGINT(Temp=6));
							IF Temp = 6 THEN
								ourStor^^.SerPort:=-1
							ELSE
								ourStor^^.SerPort:=Temp-4;
						END
						ELSE
							IF Temp = 20 THEN	{ Saisie du numéro de licence }
								ConfigLicence;
		  END;
	  END;
	  IF AutoFlag & (Abs(TickCount)-Maxtime>15*60) THEN Temp:=BootCst;
    UNTIL Temp IN [1,2,BootCst];
	
	RetCode:=Temp;
	IF Temp=BootCst THEN RetCode:=3;
	
	{ •• Nom de l'appli. vidéotex •• }
	GetDItem(monDialog,3,Tp,ith,Box);
	GetIText(ith,TempS);
	HUnlock(Handle(OurStor));
	SetHSize(Handle(ourStor),SizeOf(TConfRecord)-SizeOf(Str64)+Length(TempS)+1);
	HLock(Handle(OurStor));
	BlockMoveData(@Temps,@ourStor^^.TheXScreen,length(Temps)+1);

	{ •• Taille des queues de messages •• }
	GetDItem(monDialog,9,Tp,ith,Box);
	GetIText(ith,TempN);
	StringToNum(TempN,Num);
	IF Num>4095 THEN Num:=4095;
	IF Num<2 THEN Num:=2;
	ourStor^^.MessSize:=Num;

    { •• Nb de tâches annexes •• }
	GetDItem(monDialog,10,Tp,ith,Box);
	GetIText(ith,TempN);
	StringToNum(TempN,Num);
	IF Num>10 THEN Num:=10;
	IF Num<0 THEN Num:=0;
	ourStor^^.NbAux:=Num;

	{ •• Taille zone de comm. de la base •• }
	GetDItem(monDialog,TheDBsz,Tp,ith,Box);
	GetIText(ith,TempN);
	StringToNum(TempN,Num);
	IF Num>32000 THEN Num:=32000;
	IF Num<0 THEN Num:=0;
	ourStor^^.DBComsize:=Num;

	IF Temp IN [1,BootCst] THEN	{ •• on sauve la config •• }
	BEGIN
{$IFC MACARBO=FALSE}
		{ verification du type du fichier executable }
		IF NOT GoodFile(TempS) THEN
		BEGIN
			AutoFlag:=False;
			SysBeep(5);
			ErrorManager(2,FALSE);
			GOTO 0;
		END;
{$ELSEC}
		TempS:='';
{$ENDC}

		{ •• mise à jour des ressources •• }
		ChangedResource(Handle(OurStor));
		UpdateResFile(HomeResFile(Handle(OurStor)));
	END;

	ReleaseResource (Handle(OurStor));
	DisposDialog (monDialog);
	ConfigScreen:=RetCode;
END;

{$S Phase1}
PROCEDURE BootPhase1;

BEGIN
		SetCursor(GetCursor(watchCursor)^^);

		{ on calcule l'espace nécess. à Dragster }
		Err:= Init1Proc(ShowMsg);
		DrgSize := Init1ProcSize;

		{ on prend un peu plus de mémoire pour pouvoir relancer
			le serveur avec une nouvelle version }
{$IFC SYS7ONLY}
		L:=TempMaxMem(L);
		IF (DrgSize<L) & (DrgSize+8192>L) THEN
			DrgSize := L
		ELSE
			DrgSize := DrgSize + 32*1024;	{ 32 Kilo-octets de marge }
{$ELSEC}
		IF gSystemVersion>=$700 THEN
		BEGIN
			L:=TempMaxMem(L);
			IF (DrgSize<L) & (DrgSize+8192>L) THEN
				DrgSize := L
			ELSE
				DrgSize := DrgSize + 8192;	{ 8 Kilo-octets de marge }
		END
		ELSE
			DrgSize := DrgSize + 1024;		{ 1 Kilo-octets de sécurité }
{$ENDC}

		IF Err<>0 THEN ErrorManager(Err,TRUE);	{ erreur durant la phase 1 (Quitte)}

{$IFC SYS7ONLY}
		{ assez de mémoire temporaire ? }
		L:=TempMaxMem(L);
		IF L<DrgSize THEN
		BEGIN
			NumToString((DrgSize-L) DIV 1024,tempStr);
			ParamText(tempStr,'','','');
			Err := MyAlert(258);
			RemoveDragster(TRUE);	{ on retire complètement Dragster }
			EXIT(DragsterBoot);
		END;
{$ELSEC}
		IF NOT gHasMultiFinder THEN
		BEGIN	{ Système 6.0.x sans multifinder }
			{ si pas assez de mémoire… on Quitte }
			IF LIPtr(BufPtr)^-DrgSize < LIPtr(LIPtr(SysZone)^)^+131072 THEN ErrorManager(12,TRUE);
			
			LIPtr(BufPtr)^:=LIPtr(BufPtr)^-DrgSize;	{ on déplace BufPtr }
			LIPtr(LIPtr(BufPtr)^)^:=0;	{ reset la première adresse de Dragster }
			reLaunch := TRUE;
		END
		ELSE
			IF gSystemVersion < $700 THEN
			BEGIN	{ Système 6.0 avec MultiFinder }
				UseResFile(gAppResRef);
				theRes := GetResource('SIZE',0);	{ •• on supprime l'ancienne SIZE 0 •• }
				IF theRes <> NIL THEN RmveResource (theRes);
				theRes := GetResource('SIZE',-1);	{ •• on reprend l'original SIZE -1 •• }
				DetachResource(theRes);
				WITH SizeResHdl(theRes)^^ DO
				BEGIN
					Preferred := Minimum + DrgSize;
					Minimum := Preferred;
				END;
				AddResource(theRes,'SIZE',0,'');	{ •• on enregistre en SIZE 0 •• }
				reLaunch := TRUE;
			END
			ELSE
			BEGIN	{ Système 7.0 ou suivants }
				{ assez de mémoire temporaire ? }
				L:=TempMaxMem(L);
				IF L<DrgSize THEN
				BEGIN
					NumToString((DrgSize-L) DIV 1024,tempStr);
					ParamText(tempStr,'','','');
					Err := MyAlert(258);
					RemoveDragster(TRUE);	{ on retire complètement Dragster }
					EXIT(DragsterBoot);
				END;
			END;

		IF reLaunch THEN
		BEGIN
			{ •• On conserve le résultat de la phase 1 •• }
			UseResFile(gAppResRef);
			theRes:=GetResource('TEMP',0);	{ •• on supprime l'ancienne TEMP 0 •• }
			RmveResource(theRes);
			theRes := NewHandle(SizeOf(LONGINT));	{ •• on crée la nouvelle TEMP 0 •• }
			LIPtr(theRes^)^:=DrgSize;
			AddResource(theRes,'TEMP',0,'');
			UpdateResFile(gAppResRef);
			
			GetAppParms (fName, apRefNum,apParam);
			WITH MyLaunch DO
			BEGIN
				pfname:=@fname;
				param:=0;
			END;
			LaunchIt(@MyLaunch);
			EXIT(DragsterBoot);	{ on ne sait jamais ! }
		END;
{$ENDC}
END;	{ BootPhase1 }



{$S Phase2}
PROCEDURE BootPhase2;

BEGIN
{$IFC SYS7ONLY}
	DrgHandle := TempNewHandle(DrgSize,Err);
	IF DrgHandle=NIL THEN ErrorManager(12,TRUE);
	HLock(DrgHandle);
	DrgPtr := StripAddress(DrgHandle^);
	LIPtr(StkLowPt)^:=0; { on désactive le Stack Sniffer }
{$ELSEC}
	IF NOT gHasMultiFinder THEN
	BEGIN	{ Système sans MultiFinder }
		DrgPtr := Ptr(LIPtr(BufPtr)^);
		IF LIPtr(DrgPtr)^<>0 THEN	EXIT(BootPhase2);	{ on a déjà démarré }
		{ •• on récupère le résultat de la phase 1 •• }
		theRes := GetResource('TEMP',0);
		DrgSize := LIPtr(theRes^)^;
	END
	ELSE
		IF gSystemVersion < $700 THEN
		BEGIN	{ Système 6 avec MultiFinder }
			UseResFile(gAppResRef);	{ •• on supprime SIZE 0 •• }
			theRes := GetResource('SIZE',0);
			IF theRes=NIL THEN ErrorManager(14,TRUE);
			RmveResource (theRes);
			{ •• on récupère le résultat de la phase 1 •• }
			theRes := GetResource('TEMP',0);
			IF theRes=NIL THEN ErrorManager(14,TRUE);	{ redémarrer le Mac SVP }
			DrgSize := LIPtr(theRes^)^;
			RmveResource (theRes); { •• on supprime TEMP 0 •• }
			UpdateResFile(gAppResRef);
			UnloadSeg(@MyInit);
			L:=MaxMem(L);	{ on compacte notre heap }
			MaxApplZone;	{ on étend le heap au maximum }
						
			DrgPtr := NewPtr(DrgSize);
			IF DrgPtr=NIL THEN ErrorManager(12,TRUE); { pas assez de mémoire }
			LIPtr(StkLowPt)^:=0; { on désactive le Stack Sniffer }
		END
		ELSE
		BEGIN	{ Système 7 et suivants }
			DrgHandle := TempNewHandle(DrgSize,Err);
			IF DrgHandle=NIL THEN ErrorManager(12,TRUE);
			HLock(DrgHandle);
			DrgPtr := StripAddress(DrgHandle^);
			LIPtr(StkLowPt)^:=0; { on désactive le Stack Sniffer }
		END;
{$ENDC}

	SetCursor(GetCursor(watchCursor)^^);

	Err:=Init2Proc(ShowMsg,DrgPtr,DrgSize);	{ Phase 2: installation de Dragster en tâche de fond }
	UnloadSeg(@Init2Proc);
	
	IF Err<>0 THEN ErrorManager(Err,TRUE);
END;	{ BootPhase2 }


{$S SUIVI}
FUNCTION Mid(str:str255 ; start,len:INTEGER):Str255;

VAR	x			: integer;
		str2	: Str255;
		
BEGIN
	str2:='';
	x := start;
	WHILE (x < ORD(str[0])) AND (x<Start+Len) DO BEGIN
		str2 := concat(str2,str[x]);
		x := x+1;
	END;
	Mid := Str2;
END;			{Mid}

{$S SUIVI}
PROCEDURE a_propos;

VAR Temp:INTEGER;

BEGIN
	ShowAbout;
	REPEAT
		SystemTask;
	UNTIL Button;
	FlushEvents(mDownMask+mUpMask,0);
	RemoveAbout;
END;

FUNCTION Vtxt2Asc(str1:Str255):Str255;

VAR str2			:Str255;
		x					:Integer;
		
BEGIN
	str2 := '';
	FOR x:=1 TO ORD(str1[0]) DO
		IF str1[x] = CHAR(25) THEN
			IF str1[x+1] = CHAR(46) THEN BEGIN
				str2 := concat(str2,'» ');
				x := x+1;
			END ELSE 
		ELSE
			str2 := concat(str2,str1[x]);
	Vtxt2Asc := str2;
END; 		{Vtxt2Ascii}
	

{$IFC MACARBO}

PROCEDURE UpdateVisuData;

VAR theStr			:Str255;
		theStr2			:Str255;
		cv					:Integer;
		ligne				:Integer;
		theRect			:Rect;
		oldPort			:GrafPtr;
		LaDate			:DateTimeRec;			
		nbConn			:INTEGER;
		
	FUNCTION Vtxt2Asc(str1:Str255):Str255;

	VAR str2			:Str255;
			x					:Integer;
			
	BEGIN
		str2 := '';
		FOR x:=1 TO ORD(str1[0]) DO
			IF str1[x] = CHAR(25) THEN
				IF str1[x+1] = CHAR(46) THEN BEGIN
					str2 := concat(str2,'» ');
					x := x+1;
				END ELSE 
			ELSE
				str2 := concat(str2,str1[x]);
		Vtxt2Asc := str2;
	END; 		{Vtxt2Ascii}
	
BEGIN
	IF visu = NIL THEN EXIT(UpdateVisuData);
	GetPort(OldPort);
	SetPort(Visu);
	nbConn := 0;
	IF DrgPresent & (OffSet<>0) THEN BEGIN
		theRect := Visu^.portrect;
		therect.top := theline+1;
		FillRect(theRect,qd.white);
		
		TextFont(Monaco);
		TextSize(9);
	  MoveTo(5,theLine+17);
		GetIndString(theStr,r_STRJCA,4); DrawString(theStr);
		DrawString(DrgGetString(DrgLink,0,OFFSET+o_STARTs));
		
	  MoveTo(5,theLine+29);
		NumToString(DrgGetNum(DrgLink,0,OFFSET+o_NC),theStr);
		DrawString(theStr);
		GetIndString(theStr,r_STRJCA,5);
		DrawString(theStr);
		NumToString(DrgGetNum(DrgLink,0,OFFSET+o_NCMAX),theStr);
		DrawString(theStr);
		GetIndString(theStr,r_STRJCA,6);
		DrawString(theStr);
		
	  MoveTo(5,theLine+41);
		GetIndString(theStr,r_STRJCA,7);
		DrawString(theStr);
		DrawString(DrgGetString(DrgLink,0,OFFSET+o_LCs));
		
		
		ligne := 0;
		FOR cv := 1 TO DrgLink^^.NBVoies DO BEGIN
			IF DrgConnected(DrgLink,cv) THEN BEGIN
				nbConn := NbConn + 1;
				ligne := ligne + 1;
				
				MoveTo(5,theLine+60+ligne*12);
				NumTostring(cv-1,thestr);
				IF cv <= 10 THEN theStr := concat(' ',theStr);
				DrawString(theStr);
				
				DrawChar(' ');
				Secs2Date(DrgGetNum(DrgLink,0,OFFSET+o_QD+(cv-1)*4),Ladate);
				WITH Ladate DO BEGIN
					NumtoString(Hour,theStr);
					IF Hour < 10 THEN theStr := Concat(' ',theStr);
					DrawString(theStr);DrawChar(':');
					NumToString(Minute,theStr);
					IF Minute < 10 THEN theStr := Concat('0',theStr);
					DrawString(theStr);
				END;		{WITH}
				
				DrawChar(' ');
				theStr := DrgGetString(DrgLink,0,OFFSET+o_STs+(cv-1)*256);
				IF theStr[1]=char('M') THEN BEGIN
					IF theStr[4] = char('L') THEN
						GetIndString(theStr2,r_STRJCA,8)
					ELSE
						GetIndString(theStr2,r_STRJCA,9);
					DrawString(theStr2)
				END ELSE BEGIN
					DrawString(Mid(theStr,17,2));
					DrawChar('/');
					DrawString(Mid(theStr,9,2));
				END;
				
				DrawChar(' ');
				theStr := Vtxt2Asc(DrgGetString(DrgLink,0,OFFSET+o_OUs+(cv-1)*256));
				DrawString(theStr);
				
			END;
		END;
	END;

	SetRect(theRect,5,theline-26,100,theLine-17);
	FillRect(theRect,qd.white);
	TextFont(Geneva);
	TextSize(9);
	MoveTo(5,theLine-17);
	GetIndString(theStr,r_STRJCA,2);	{ Voies connectées }
	DrawString(theStr);
	NumToString(Nbconn,theStr);
	DrawString(theStr);
	
	IF gRelaunch & (NbConn=0) THEN gDoRelaunch := TRUE;	{ relancer le serveur }
	IF gDoQuit & (NbConn=0) THEN gDoneFlag := TRUE;			{ quitter le serveur }
	IF gDoQuit & (NbConn>0) THEN gDoBeep := TRUE;				{ on ne quitte pas tt de suite, il faudra beeper }
	
	lastTicks := Tickcount;
	SetPort(OldPort);
END;

{$ELSEC}

PROCEDURE UpdateVisuData;

VAR
	theStr					: Str255;
	theStr2					: Str255;
	cv,nb,nbConn		: Integer;
	ligne,colonne		: Integer;
	theRect					: Rect;
	oldPort					: GrafPtr;
	LaDate					: DateTimeRec;			
	theStatus				: DrgStatusRec;
	thePICT					: PicHandle;
	MaxInCol				: INTEGER;

CONST
	pixelsPerLine = 10;
	
BEGIN
	IF visu = NIL THEN EXIT(UpdateVisuData);
	GetPort(OldPort);
	SetPort(Visu);

	IF DrgPresent THEN
	BEGIN
			
		IF (DrgLink^^.NBVoies > 40) THEN
			SizeWindow(visu,Visu^.portrect.right-Visu^.portrect.left,380,FALSE);
		theRect := Visu^.portrect;
		therect.top := theLine+1;
		FillRect(theRect,qd.white);
		
		TextFont(Monaco);
		TextSize(9);

		MaxInCol := (theRect.bottom-theRect.top) DIV pixelsPerLine;
		nb := 0; nbConn := 0;
		FOR cv := 1 TO DrgLink^^.NBVoies DO
		BEGIN
			theStatus := DrgStatus(DrgLink,cv);
			IF theStatus.Conflag THEN NbConn := nbConn+1;
			IF theStatus.conFlag | gVisuDebug THEN BEGIN
				nb := nb + 1;
				ligne := (((nb-1) MOD MaxInCol)+1)*pixelsPerLine+5+theLine;
				colonne := LONGINT(nb>MaxInCol)*(theRect.right-theRect.left) DIV 2;
				MoveTo(colonne+5,ligne);
				NumTostring(cv-1,thestr);
				IF gVisuDebug & theStatus.Conflag THEN DrawString('√ ') ELSE DrawString('  ');
				IF cv <= 10 THEN DrawChar(' ');
				DrawString(theStr);
				
				HLock(Handle(DrgLink));
				WITH DrgLink^^.thePtrs[cv]^ DO
				BEGIN
					IUTimeString(StartTime,FALSE,theStr);	{ •• Heure de connexion }
					MoveTo(colonne+40,ligne);
					IF Length(theStr)=4 THEN DrawChar(' ');
					DrawString(theStr);
					
					theStr := DrgGetScreen(DrgLink,cv);
					IF (Length(theStr)>18) & (DrgLink^^.NBVoies>19) THEN
					BEGIN
						theStr[0] := CHAR(17);
						theStr := concat(theStr,'…');
					END;
					
					theStr2 := theStr;
					
					IF gVisuDebug THEN
					BEGIN
						{ •• Status •• }
						NumToString(theStatus.statusWord,theStr);
						theStr2 := concat(theStr2,' (S=',theStr);
						
						{ •• Ligne •• }
						IF theStatus.LineNumber<>0 THEN
						BEGIN
							NumToString(theStatus.LineNumber,theStr);
							theStr2:=concat(theStr2,'/L=',theStr);
						END;
						
						{ •• Instruction •• }
						IF theStatus.InstructionNumber<>0 THEN
						BEGIN
							NumToString(theStatus.InstructionNumber,theStr);
							theStr2:=concat(theStr2,'/I=',theStr);
						END;
						theStr2:=concat(theStr2,')');
					END;	{ gDebugVisu }
					MoveTo(colonne+76,ligne);
					DrawString(theStr2);	{ •• Ecran courant + statut }
				END; { WITH DrgLink^^.thePtrs[cv]^… }
				HUnlock(Handle(DrgLink));
			END;	{ FOR cv := 1 TO… }
		END;	{ IF DrgPresent… }
		
		SetRect(theRect,5,theline-27,100,theLine-17);
		FillRect(theRect,qd.white);
		TextFont(Geneva);
		TextSize(9);
		MoveTo(5,theLine-17);
		GetIndString(theStr,r_STRJCA,2);	{ Voies connectées }
		DrawString(theStr);
		NumToString(Nbconn,theStr);
		DrawString(theStr);
		
{$IFC DEMO}
	  thePICT := GetPicture(r_PictDemo);		{ dessin de la pict de la version de démo }
		IF thePict<>NIL THEN
		WITH visu^, thePict^^ DO
		BEGIN
			{ on centre l'image dans le dialogue }
			theRect.Top := portRect.top+((portRect.bottom-portRect.top)-(PicFrame.Bottom-PicFrame.Top)) DIV 2;
			theRect.Bottom := theRect.Top+PicFrame.Bottom-PicFrame.Top;
			theRect.left := portRect.left+((portRect.right-portRect.left)-(PicFrame.Right-PicFrame.Left)) DIV 2;
			theRect.right := theRect.left+(PicFrame.Right-PicFrame.Left);
			DrawPicture(thePict,theRect);
		END;
{$ENDC}

		IF gRelaunch & (NbConn=0) THEN gDoRelaunch := TRUE;	{ relancer le serveur }
		IF gDoQuit & (NbConn=0) THEN gDoneFlag := TRUE;			{ quitter le serveur }
		IF gDoQuit & (NbConn>0) THEN gDoBeep := TRUE;					{ on ne quitte pas tt de suite, il faudra beeper }
	END;	{ IF DrgPresent }
	lastTicks := Tickcount;
	SetPort(OldPort);
END;

{$ENDC}

{$S SUIVI}
PROCEDURE UpdateVisu;

VAR oldPort			:GrafPtr;
		theRect			:Rect;
		thePict			:PicHandle;
		theStr			:Str255;
		showColor		:BOOLEAN;
		MacScreen		:GDHandle;
		
BEGIN
	IF visu = NIL THEN EXIT(UpdateVisu);
	BeginUpdate(Visu);
	GetPort(oldport);
	Setport(Visu);

	FillRect(Visu^.portrect,qd.white);
	
	{ on est en couleur ? }
	ShowColor := FALSE;
	IF gQDVersion>0 THEN
	BEGIN
		MacScreen := GetGDevice;
		IF MacScreen^^.gdpMap^^.pixelSize > 2 THEN ShowColor := TRUE;
	END;

	thePICT := NIL;
	
	IF thePict = NIL THEN thePICT := GetPicture(257);	{ Dragster® ou rien }
	IF thePICT <> NIL THEN
	BEGIN
		HLock(Handle(thePICT));
		theRect.Top := 4;
		theRect.left := ((Visu^.portrect.right-Visu^.portrect.left)-(thePICT^^.PicFrame.Right-thePICT^^.PicFrame.Left)) DIV 2;
		theRect.Bottom := theRect.Top+thePICT^^.PicFrame.Bottom-thePICT^^.PicFrame.Top;
		theRect.right := theRect.left+(thePICT^^.PicFrame.Right-thePICT^^.PicFrame.Left);
		DrawPicture(thePICT,theRect);
		HUnlock(Handle(thePICT));
		HPurge(Handle(thePICT));
	END;
	ReleaseResource(Handle(thePICT));
	
	thePict := NIL;
	IF ShowColor THEN thePICT := GetPicture(r_PICTCouleur);
	IF thePict = NIL THEN thePICT := GetPicture(r_PICTNB);
	
	IF thePICT <> NIL THEN
	BEGIN
		HLock(Handle(thePICT));
		theRect.Top := 4;
		theRect.Bottom := theRect.Top+thePICT^^.PicFrame.Bottom-thePICT^^.PicFrame.Top;
		theRect.right := Visu^.portrect.right-5;
		theRect.left := theRect.right-(thePICT^^.PicFrame.Right-thePICT^^.PicFrame.Left);
		DrawPicture(thePICT,theRect);
		HUnlock(Handle(thePICT));
		HPurge(Handle(thePICT));
	END
	ELSE theRect.bottom := 50;
	
	theLine := theRect.Bottom+5;
	
	Moveto(5,theLine); Line(Visu^.portrect.right-5,0);

	TextFont(Geneva);
	TextSize(9);
	
	MoveTo(5,theline-27);
	GetIndString(theStr,r_STRJCA,1);	{ Nb Voies }
	DrawString(theStr);
	NumToString(DrgLink^^.Nbvoies,theStr);
	DrawString(thestr);
	
	Moveto(5,theline-7);
	GetIndString(theStr,r_STRJCA,3);	{ Nb auxTask }
	DrawString(thestr);
	NumToString(DrgLink^^.NbAux,theStr);
	DrawString(thestr);

	UpdateVisuData;
	
	SetRect (theRect, -32767, -32767, 32767, 32767);
  ClipRect (theRect);

	SetPort(oldport);
	EndUpdate(Visu);
END;

{$S SUIVI}
PROCEDURE Openvisu;

BEGIN
	DialogPtr(Visu) := GetNewDialog(r_DLOGvisu,NIL,POINTER(-1));
	IF qd.screenbits.bounds.right<=512 THEN	{ sur écran 9" on ne centre pas }
		ShowWindow(Visu)
	ELSE
		CenterDlog(DialogPtr(Visu));
	UpdateVisu;
	CheckItem(GetMHandle(r_menufichier),i_visu,TRUE);
END;

PROCEDURE CloseVisu;

BEGIN
	IF Visu<>NIL THEN DisposeWindow(Visu);
	Visu := NIL;
	CheckItem(GetMHandle(r_menufichier),i_visu,FALSE);
END;


{-------------- Exécution des commandes -----------}

{$S SUIVI}
PROCEDURE DoCommand(menudata:Longint);

VAR	svport			:grafptr;
		daName			:str255;
		temp				:integer;
		MenuID			:integer;
		ItemID			:integer;
		
BEGIN
	MenuID := hiword(menudata);
	ItemID := loword(menudata);
	CASE MenuID OF
		
		r_menupomme:
			IF ItemID = i_a_propos THEN
				a_propos
			ELSE BEGIN
				GetPort(svPort);
				GetItem(GetMHandle(r_menupomme),ItemID,daName);
				temp := OpenDeskAcc(daName);
				SetPort(svPort);
			END;			   {ELSE}
			
		r_menufichier:
			CASE ItemID OF
				i_quitter:
					BEGIN
						IF gHasMultiFinder & (gCanQuit=FALSE) THEN	{ on va stopper le serveur ?? }
						BEGIN
							ChooseQuit;	{ confirmer quitter ! }
						END
						ELSE
							gDoneFlag := TRUE;
					END;
					
				i_visu:
					IF Visu = NIL THEN OpenVisu ELSE CloseVisu;
				
{$IFC MACARBO=FALSE}
				i_debug:
					BEGIN
						gVisuDebug := NOT gVisuDebug;
						CheckItem(GetMHandle(r_menuFichier),i_debug,gVisuDebug);
						UpdateVisuData;
					END;
{$ENDC}

				i_config:
				BEGIN
{$IFC MACARBO=FALSE}
					prefs := OpenResFile(kPrefFileName);
{$ENDC}
					Err:=ConfigScreen(FALSE);
{$IFC MACARBO=FALSE}
					CloseResFile(prefs);
					prefs := 0;
{$ENDC}
				END;
				
			END;				{CASE}
			
(*
			r_menuServer:
			CASE ItemID OF
				i_ReLaunchServer:
				IF gSystemVersion>=$700 THEN	{ uniquement sous système 7 }
				BEGIN
					gRelaunch := NOT gReLaunch;
					CheckItem(GetMHandle(r_MenuServer), i_relaunchServer, gRelaunch);
				END;
{					
				i_DisconnectUser:
				
				i_RestartUser:
}				
			END;				{ CASE }
*)
	END;		{CASE}

	HiliteMenu(0);
END;			{DoCommand}


{-------------- HandleQueue: Trait. des req. de la tâche de fond --------------}
{$S Main}

PROCEDURE TEnQueue(QNum: Integer; VAR pb: TQERec);

VAR
	ThePtr: TPtr;

BEGIN
	ThePtr := DrgLink^^.ThePtrs[1];
	WITH ThePtr^.TheQueues^[QNum] DO
		IF (QNum<>0) & (QOwner=NIL) THEN	{ il y a bien une tâche derrière cette queue ?? }
		BEGIN
{$IFC DEBUG}
			DebugStr('Envoi req. a tache absente !');
{$ENDC}
		END
		ELSE
		BEGIN
			pb.EOwner := NIL;
			pb.QLink := NIL;
			IF QNumber = 0 THEN
				BEGIN
					QFirst := @pb;
					QEnd := @pb;
				END
			ELSE
				BEGIN
					QEnd^.QLink := @pb;
					QEnd := @pb;
				END;
			QNumber := QNumber + 1;
			WHILE pb.ERet>0 DO	{ requete en cours de traitement }
			BEGIN
				SystemTask;
				HandleQueue;
			END;
		END;
END;

{$D-}
FUNCTION Drg_EVEEnable(PASSWORD:STRING; theNScreen:INTEGER):INTEGER ;

VAR		i:INTEGER;
			mask: INTEGER;
			pw: STRING[16];
			
BEGIN
	IF TheNScreen<$1000 THEN
	BEGIN		(* décryptage du mot de passe 'CiMPSUpTK}^XGSLe' en 'SzWGTAqENsMURAMh' *)
		mask := length(password);
		pw := password;
		FOR i := 1 TO Length(PassWord) DO
		BEGIN
			password[i] := CHR(BXOR(ORD(pw[i]),mask));
			mask := bxor(mask,band(ord(pw[i]),$1f));
		END;
		IF mask<>8 THEN
		BEGIN
			Drg_EVEEnable := EVEReset;
			EXIT(Drg_EVEEnable);
		END;
	END;
	Drg_EVEEnable := EVEEnable(password);
END;


{$D+}
PROCEDURE Drg_ShutDownInstall(req:TQEPtr);
{ installation d'une procédure d'arrêt }

VAR	nbProcs: INTEGER;

BEGIN
	nbProcs := GetHandleSize(Handle(ShutDownPRocs)) DIV SizeOf(ShutDownRec);
	SetHandleSize(Handle(ShutDownPRocs),GetHandleSize(Handle(ShutDownPRocs))+SizeOf(ShutDownRec));
	ShutDownProcs^^[nbProcs].ProcPtr := req^.eParam1;
	ShutDownProcs^^[NbProcs].dataPtr := req^.eParam2;
END;


PROCEDURE UpdateDatas;

VAR
	req: TQERec;
	
BEGIN
	WITH req DO
	BEGIN
		eCode := 2;	{ mise à jour handle datas… }
		eParam1 := Ptr(thedata);
		eRet := 1;
	END;
	TEnQueue(ShutDownQ, req);
END;


PROCEDURE HandleQueue;

VAR theReq: TQEPtr;	{ ptr vers la requête }
		i: INTEGER;
		L: LONGINT;
		s: STRING;
		
BEGIN
	IF theQueue=NIL THEN
		IF (DrgGlobs.Started) & (DrgGlobs.FirstTCB<>NIL) THEN
		BEGIN
			theQueue := TPtr(DrgGlobs.FirstTCB)^.theQueues;
		END
		ELSE EXIT(HandleQueue);
		
	WITH theQueue^[MainQueue] DO
	BEGIN
		IF QNumber>0 THEN	{ il y a une requête en attente… }
		BEGIN
			theReq := QFirst;
			{ on retire cette requete de la queue }
			QFirst := QFirst^.QLink;
			IF QFirst = NIL THEN
			BEGIN
				QEnd := Nil;
				QNumber := 0;
			END;
			IF QNumber > 0 THEN QNumber := QNumber -1;
			
{$IFC DEBUG}
DebugStr(concat('DrgBoot/HandleQueue: Req#',NumToStr(theReq^.ecode)));
{$ENDC}

			{ on traite la requête… }
			WITH theReq^ DO
			CASE ECode OF
				ReqNewHandle:	{ allocation d'un Handle }
					BEGIN
						L:=EMisc;
						IF MaxBlock<EMisc+10240 THEN	{ on utilise de la RAM temporaire ? }
							EParam1 := Ptr(TempNewHandle(L,Eret))
						ELSE
						BEGIN
							EParam1 := Ptr(NewHandle(L));
							ERet := MemError;
						END;
					END;
				
{$R-}
				ReqStoreData:		{ sauvegarde de données }
					BEGIN
(*						DebugStr('DrgBoot: ReqStoreData');	{ bugstoredata } *)
						IF theData=NIL THEN
						BEGIN
							theData := DHandle(NewHandle(2));
							theData^^.NbDatas := 0;
							UpdateDatas;	{ on passe l'adresse du tableau de données à UtilTask }
						END;
						{ on cherche si ces données existent déjà… }
						FOR i := 1 TO theData^^.NbDatas DO
							IF theData^^.Datas[i].Name^^=stringPtr(EParam2)^ THEN	{ trouvé !! }
							BEGIN
								theData^^.Datas[i].thePtr := EParam1;
								Leave;
							END;
						IF i>theData^^.NbDatas THEN	{ pas trouvé, on crée… }
						BEGIN
							theData^^.NbDatas := theData^^.NbDatas+1;
							SetHandleSize(Handle(TheData),2+theData^^.NbDatas*SizeOf(DatasRec));
							IF MemError=NoErr THEN
							BEGIN
								theData^^.Datas[theData^^.NbDatas].Name:=NewString(StringPtr(EParam2)^);
{$IFC DEBUG}
DebugStr('StoreData');
{$ENDC}
								theData^^.Datas[theData^^.NbDatas].thePtr := EParam1;
							END;
							
(*
							{ 8/3/94 • Protection Librairie QuickBase }
							s := stringPtr(EParam2)^;
							s[0] := chr(6);
							IF (s='QB Lib') & (EvEStatus=NoErr) THEN
								ERet := MaxTasks
							ELSE
								ERet := MemError;	{ prévenir la tâche de fond du résultat… }
*)
						END;
					END;
					
				ReqRestoreData:	{ récupération de données }
					BEGIN
						EParam1:=NIL;
						IF theData<>NIL THEN
							FOR i := 1 TO theData^^.NbDatas DO
								IF theData^^.Datas[i].Name^^=StringPtr(EParam2)^ THEN	{ trouvé !! }
								BEGIN
									EParam1:=theData^^.Datas[i].thePtr;
									Leave;
								END;
					END;

				ReqKillData:	{ suppression de données }
					BEGIN
						IF theData<>NIL THEN
							FOR i := 1 TO theData^^.NbDatas DO
								IF theData^^.Datas[i].Name^^=StringPtr(EParam2)^ THEN	{ trouvé !! }
								BEGIN
									{ on libère la RAM occupée par le nom }
									DisposHandle(Handle(theData^^.Datas[i].Name));
									{ on décale les datas suivantes pour boucher le trou }
									IF i<theData^^.NbDatas THEN
										BlockMoveData(@theData^^.Datas[i+1],@theData^^.Datas[i],(theData^^.NbDatas-i)*SizeOf(DatasRec));
									{ on met à jour la taille du tableau }
									theData^^.NbDatas := theData^^.NbDatas-1;
									SetHandleSize(Handle(TheData),2+theData^^.NbDatas*SizeOf(DatasRec));	
									Leave;
								END;
					END;
					
				$1000:	{ EVEReset }
					ERet := EVEReset;
					
				$1001:	{ EVEStatus }
					ERet := EVEStatus;
					
				$1002:	{ EVEEnable }
					ERet := DRG_EVEEnable(StringPtr(eParam1)^,theReq^.EOwner^.theNScreen);
				
				$1003:	{ EVEChallenge }
					ERet := EVEChallenge(HiWord(eMisc),LoWord(eMisc));
					
				$1004:	{ EVEReadGPR }
					ERet := EVEReadGPR(eMisc);
					
				$1005:	{ EVEWriteGPR }
					ERet := EVEWriteGPR(HiWord(eMisc),LoWord(eMisc));
					
				$1006:	{ EVESetLock }
					ERet := EVESetLock(HiWord(ORD4(eParam1)),eMisc,LoWord(ORD4(eParam1)));
					
				$1007:	{ EVEReadCTR }
					ERet := EVEReadCTR;
					
				6:	{ Drg_ShutDownInstall }
					Drg_ShutDownInstall(theReq);
					
{$R+}
			END;	{ CASE }
			
(*			DebugStr('DrgBoot: StatusWord := ReadyCst');	{ bugstoredata } *)
			theReq^.EOwner^.StatusWord := ReadyCst;	{ on réactive la tâche d'origine… }

{$IFC DEBUG}
DebugStr('DrgBoot/HandleQueue: fin');
{$ENDC}
		END;
	END;
END;


{$IFC AEVT}
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
	err := GotRequiredParams(theAppleEvent) ;
	IF err <> noErr THEN
		HandleOAPP := err
	ELSE
		HandleOAPP := noErr ;
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

	FailErr( AEGetNthPtr( docList, 1, typeFSS, keywd, typeCode,@myFSS, sizeof( myFSS ), actualSize ) ) ;
	OpenThisScreen(myFSS) ;

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
	END ;

BEGIN
	HandlePDOC := noErr ;

	{ we are expecting a list of aliases: first get the list into docList }
	FailErr(AEGetParamDesc(theAppleEvent,keyDirectObject,typeAEList,docList));

	{ now check that all required params have been used: return error if there are any
	  that we don't understand }
	FailErr(GotRequiredParams(theAppleEvent));

	{ now get each alias (as FSSpec) from the list and open it. }
	FailErr(AECountItems(docList,itemsInList));

	FOR index := 1 TO itemsInList DO
	BEGIN
		FailErr(AEGetNthPtr(docList, index, typeFSS, keywd, typeCode,@myFSS, sizeof(myFSS), actSize));
		{ Print… ici }
	END ;

	FailErr(AEDisposeDesc(docList)) ;
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
{$ENDC}

{-------------- Boucle d'évènements -----------}

{$S SUIVI}
PROCEDURE MainEventLoop;

VAR	MyEvent				:EventRecord;
		hasEvent			:BOOLEAN;
		WhichPart			:Integer;
		WhichWindow		:WindowPtr;
		theChar				:Char;
		longstuff			:LongStuffType;
		
		
BEGIN
	hasEvent := WaitNextEvent(everyEvent,MyEvent,0,NIL);

	HandleQueue;	{ traitement des requêtes provenant de la tâche de fond }
	
	IF (TickCount > lastTicks + 300) AND (Visu <> NIL) AND DrgPresent THEN UpdateVisuData;
	
	IF hasEvent THEN
		CASE MyEvent.what OF {which event?}
			kHighLevelEvent:
				Err := AEProcessAppleEvent(MyEvent);	{ <aevt> }
				
			mouseDown: BEGIN
				whichPart := FindWindow(MyEvent.where,whichWindow);
				
				CASE whichPart OF

					inMenuBar: BEGIN
						DoCommand(MenuSelect(MyEvent.where));
					END; {inMenuBar}

					inSysWindow: BEGIN
						SystemClick(MyEvent,whichWindow);
					END; {inSysWindow}
					
					inContent: BEGIN
						IF whichWindow <> FrontWindow THEN
							SelectWindow(whichWindow);
						IF whichWindow = Visu THEN UpdateVisuData;
					END; {inContent}
					
					inDrag: BEGIN
						DragWindow(whichWindow,MyEvent.where,screenlimits);
					END; {inDrag}
					
					inGoAway: BEGIN
						IF whichwindow = Visu THEN
							IF TrackGoAway(Visu,MyEvent.Where) THEN CloseVisu;
					END; {inGoAway}
					
				END;   {CASE}
			END;		   {mouseDown}

			keyDown,autoKey: BEGIN
				theChar := CHR(BitAnd(MyEvent.message,charCodeMask));
				IF BitAnd(MyEvent.modifiers,cmdKey) <> 0 THEN
					DoCommand(MenuKey(theChar));
			END;		   {keyDown}

			updateEvt: BEGIN
				SetPort(WindowPtr(MyEvent.message));
				IF WindowPtr(MyEvent.message) = Visu THEN
					UpdateVisu;
			END;		   {updateEvt}

			diskEvt: BEGIN
				longStuff.long := MyEvent.message;
				IF longStuff.HiWrd < 0 THEN {got a bad mount}
					IF DIBadMount(Point($00320064),MyEvent.message)=0 THEN;
			END;		   {diskEvt}

			app4Evt: BEGIN
				longStuff.long := MyEvent.message;
				IF Odd(MyEvent.message) THEN BEGIN
					InitCursor;
				END 	   {ELSE IF}
				ELSE BEGIN
					Suspended := TRUE;
				END;	   {ELSE}
			END;		   {app4Evt}
		END;			   {event.what case}
END;						 {MainEventLoop}


PROCEDURE OpenPrefs;

VAR
	theFile					: AppFile;
	count						: INTEGER;
	message					: INTEGER;
	fndrInfo				: FInfo;
	
BEGIN
(*
	{ 6/3/95 - on a double-cliqué sur un fichier de prefs ? }
	CountAppFiles(message,count);
	IF count>=1 THEN
	BEGIN
		GetAppFiles(1,theFile);
		kPrefFileName := theFile.fName;
		gAutoStart := FALSE;	{ -> on passe en configuration }
	END;
*)
	IF kPrefFileName='' THEN
		kPrefFileName := concat(gAppName,' - prefs');
		
	{ 6/3/95 - création et ouverture du fichier de prefs }
	CreateResFile(kPrefFileName);
	IF ResError=noErr THEN	{ 6/3/95 - on modifie la signature du fichier que l'on vient de créer }
	BEGIN
		Err := GetFInfo(kPrefFileName,0,fndrInfo);
		fndrInfo.fdType := 'pref';
		fndrInfo.fdCreator := 'DRG1';
		IF Err=NoErr THEN Err := SetFInfo(kPrefFileName,0,fndrInfo);
	END;
	
	prefs := OpenResFile(kPrefFileName);
	{ 6/3/95 - copie de la ressource de config }
	theRes := GetResource('CONF',256);
	IF (prefs<>-1) & (theRes<>NIL) & (HomeResFile(theRes)<>CurResFile) THEN
	BEGIN
		DetachResource(theRes);
		AddResource(theRes,'CONF',256,'');
	END;
END;


PROCEDURE CheckLic;

VAR
	curRes: INTEGER;
	ok: BOOLEAN;
	key1,key2: StringHandle;
	
BEGIN
	ok := FALSE;
	curRes := CurResFile;
	UseResFile(prefs);
	key1 := StringHandle(Get1Resource('DRGK',128));
	UseResFile(gAppResRef);
	key2 := StringHandle(Get1Resource('DRGK',128));
	IF (key1 <> NIL) AND (key2 <> NIL) THEN
		IF key1^^ = key2^^ THEN
			IF IsLicOk(Key1^^) THEN
				ok := TRUE;
	IF NOT ok THEN
	BEGIN
		RmveResource(Handle(key1));
		RmveResource(Handle(key2));
		UpdateResFile(prefs);
		UpdateResFile(gAppResRef);
		SysBeep(60);
		ConfigLicence;
	END;
	UseResFile(curRes);
END;


{$S Main}
BEGIN   { •••• Programme principal •••• }
	MaxApplZone;
	
	StandardInitialization(0);	{ Utilities }
	UnLoadSeg(@StandardInitialization);

	IF gSystemVersion<$700 THEN
	BEGIN
		Err := MyAlert (262);
		EXIT(DragsterBoot);
	END;
	
	AboutWindow := NIL;
	gMsgItem := NIL;
	gAutoStart := NOT KeyIsDown(58);
	
	IF gAutoStart THEN ShowAbout;
	
{$IFC Antivir}
	IF VerifyAvir($43971717,$45111020,TRUE) THEN EXIT(DragsterBoot);
	UnloadSeg(@VerifyAvir);
	L:=MaxMem(L);	{ compacte la mémoire }
{$ENDC}
	
	gRelaunch := FALSE;

{$IFC MACARBO=FALSE}
	prefs := 0;
	OpenPrefs;
{$ENDC}

	CheckLic;
		
	REPEAT		{ UNTIL gDoRelaunch=FALSE ---> on boucle pour pouvoir relancer le serveur }
		
		IF gAutoStart THEN
		BEGIN
			{ pas de boot automatique si pas ressource de config. }
			theRes:=GetResource('CONF',256);
			IF theRes=NIL THEN
				gAutoStart := FALSE
			ELSE
{$IFC MACARBO=FALSE}
			BEGIN
				{ on a bien un fichier exécutable ? }
				gAutoStart:=GoodFile(TConfHdle(theRes)^^.theXScreen);
				ReleaseResource(theRes);
			END;
{$ELSEC}
				ReleaseResource(theRes);
{$ENDC}
		END;
		
		DrgGlobs.Started := FALSE;
	
		{ on installe le serveur si nécessaire }
		TheDrvRef:=-(RechDrag+1);
		
		gCanQuit := TRUE;
{$IFC AEVT}
		IF (Gestalt(gestaltAppleEventsAttr,L)=NoErr)
		 & BTst(L,gestaltAppleEventsPresent) THEN InitAEVTStuff;	{ <aevt> }
{$ENDC}
	
		{ serveur déjà en place sous système 7 !! }
		IF NOT ((gSystemVersion>=$700) & (theDrvRef<>0)) THEN 
		BEGIN
			gCanQuit := FALSE;
			IF TheDrvRef=0 THEN	{ •• Phase 1: calcule taille du serveur en mémoire }
			BEGIN
				IF NOT gAutoStart THEN
					IF ConfigScreen(TRUE)<>3 THEN EXIT(DragsterBoot);	{ on quitte (OK/Annuler)}
				ShowAbout;
				UnloadSeg(@ConfigScreen);
				IF prefs<>0 THEN UseResFile(prefs);
				BootPhase1;
				UnloadSeg(@BootPhase1);
			END;
			UnloadSeg(@RechDrag);	{ Utils }
			UnloadSeg(@MyInit);		{ Init }
			
			L:=MaxMem(L);	{ compacte la mémoire }
			BootPhase2;	{ •• Phase 2: intallation du serveur en mémoire et démarrage }
			UnloadSeg(@BootPhase2);
			
			{ •• Ajout d'une fenêtre cachée (Top=-20000) pour empêcher
				Système 7 Tune Up de proposer de Quitter DragsterBoot }
			IF gSystemVersion>=$700 THEN
				InvisWindow := GetNewWindow(r_WINDinvis,NIL,Pointer(-1))
			ELSE
				InvisWindow := NIL;
		END;
{$IFC MACARBO=FALSE}
		CloseResFile(prefs);
		prefs := 0;
{$ENDC}

		RemoveAbout;
		
		{ ici commence le suivi des voies… }
		gDoneFlag := FALSE;
		
		MyInit;
		UnloadSeg(@MyInit);
		
		DrgLink:=DrgInit;	{ on initialise la liaison avec le serveur }
		
		SetCursor(qd.Arrow);
		
		L:=MaxMem(L);	{ compacte la mémoire }

		OpenVisu;
(*
		CheckItem(GetMHandle(r_menuServer), i_relaunchServer, gRelaunch);
*)

		REPEAT
			MainEventLoop;
{$IFC MACARBO}
		IF (OffSet=0) & DrgPresent THEN OFFSET := DrgGetnum(DrgLink,0,0);
{$ENDC}
		UNTIL gDoneFlag | gDoRelaunch;	{ on quitte ou on relance ? }
		
		IF gHasMultiFinder & (gCanQuit=FALSE) THEN RemoveDragster(TRUE);	{ on laisse le Driver pour ne pas relancer Dragster }
		
		gAutoStart := TRUE;
		CloseVisu;
		
	UNTIL gDoRelaunch=FALSE;

	IF gDoBeep THEN	{ 5 beeps pour prévenir que le serveur s'arrête }
	BEGIN
		SysBeep(60);
		SysBeep(60);
		SysBeep(60);
		SysBeep(60);
		SysBeep(60);
	END;
END.  {* Programme principal *}
