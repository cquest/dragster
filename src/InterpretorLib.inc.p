USES	Memtypes, Quickdraw, OSIntf, ToolIntf, packages, Sane, MacPrint, ADSP, TextUtils,
		  WritelnWindow, DragsterIO,
      TokDetok, Emulator, DragsterExternals, Kit, Interpretor,
			EVELib;

{$S INTERPRETEUR }

{$I DragsterTCB.p }

TYPE
		DatasRec =	RECORD
									Name: StringHandle;		{ nom de ces datas… }
									thePtr: Ptr;					{ pointeur à conserver… }
								END;
		DatasArray = ARRAY [1..10000] OF DatasRec;
		DPtr = ^DatasArray;
		DHandle = ^DPtr;

		ShutDownRec = ARRAY [0..1000] OF RECORD
										procPtr: Ptr;						{ adresse à rappeler }
										dataPtr: Ptr;						{ data à repasser en paramètre }
									END;
		ShutDownPtr = ^ShutDownRec;
		ShutDownH = ^ShutDownPtr;
		
VAR
	theData				: DHandle;
	numOfData			: INTEGER;
	shutDownProcs	:	ShutDownH;


PROCEDURE AddJumpTable(entryNum:INTEGER; Addr:Ptr);

BEGIN
	JumpTable^[entryNum].JumpInst := $4EF9;	{ JUMP }
	JumpTable^[EntryNum].JumpAddr := Addr;
END;


PROCEDURE Drg_ResetZones;

BEGIN
	CurTCB^.NbZones := 0;
END;


PROCEDURE Drg_Zone(ZPosX, ZPosY, ZLen: Longint; TheVar: Ptr; ZTkVar: Integer; TheColor: Longint);

BEGIN { ajout d'une zone }
	WITH CurTCB^ DO
		IF NBZones < MaxZones THEN
		BEGIN
			NBZones := NBZones + 1;
			WITH TheZones[NBZones] DO
			BEGIN
				PosX := ZPosX;
				PosY := ZPosY;
				IF ZLen > 240 THEN ZLen := 240;
				IF ZLen < 0 THEN ZLen := 0;
				Len := ZLen;
				TkVar := 0;	{ ATTENTION, on fournit un pointeur vers une Str255 !!! }
				AdVar := TheVar;
				Color := TheColor;
			END;
		END;
END;


PROCEDURE Drg_Wait(zoneNum:INTEGER);

BEGIN
	WaitBis(zoneNum);	{ l'interpreteur va traiter le WAIT directement… }
END;


PROCEDURE Drg_Input(VAR Str:Str255);

BEGIN
	CurTCB^.Error := Zinput(Str, 0, 0, 240, 0, CurTCB^.MaxTime, ' ', True);
END;


PROCEDURE Drg_PrintChar(thechar: CHAR);

VAR Str1: Str255;

BEGIN
	Str1 := theChar;
	AddDataPaq(@Str1);
END;


PROCEDURE Drg_PrintNum(num:LONGINT);

VAR Str1: Str255;

BEGIN
	NumToString(num,Str1);
	AddDataPaq(@Str1);
END;


PROCEDURE Drg_PrintStr(Str:Str255);

BEGIN
	AddDataPaq(@Str);
END;


PROCEDURE Drg_PrintScreen(Str:Str255);

BEGIN
	PrintScreenBis(Str);
END;


FUNCTION GetTCB:TPtr;	{ rend le TCB courant }

BEGIN
	GetTcb := CurTCB;
END;


FUNCTION FAsRead(NumFile: Longint; VAR Count: Longint; TheBuffer: Ptr):OsErr;

BEGIN
	CurTCB^.Error := FSRead(CurTCB^.TheFiles[NumFile].FileRef, count, TheBuffer);
	FASRead := CurTCB^.Error;
END;


FUNCTION FAsWrite(NumFile: Longint; VAR Count: Longint; TheBuffer: Ptr):OsErr;

BEGIN
	CurTCB^.Error := FAsWrite(CurTCB^.TheFiles[NumFile].FileRef, count, TheBuffer);
	FASWrite := CurTCB^.Error;
END;


FUNCTION PBCall(theCall:INTEGER; PbPtr:Ptr):OsErr;

VAR
	pb: ParmBlkPtr;
	
BEGIN
	pb := ParmBlkPtr(ORD4(PbPtr)+4);
	CASE theCall OF
		ReqOpen:			PBCall := PBOpenSync(ParmBlkPtr(ORD4(PbPtr)+4));
		ReqClose:			PBCall := PBCloseSync(ParmBlkPtr(ORD4(PbPtr)+4));
		ReqRead:			PBCall := PBReadSync(ParmBlkPtr(ORD4(PbPtr)+4));
		ReqWrite:			PBCall := PBWriteSync(ParmBlkPtr(ORD4(PbPtr)+4));
		ReqGetEof:		PBCall := PBGetEofSync(ParmBlkPtr(ORD4(PbPtr)+4));
		ReqSetEof:		PBCall := PBSetEofSync(ParmBlkPtr(ORD4(PbPtr)+4));
		ReqRename:		PBCall := PBHRenameSync(hParmBlkPtr(ORD4(PbPtr)+4));
		ReqDelete:		PBCall := PBHDeleteSync(hParmBlkPtr(ORD4(PbPtr)+4));
		ReqLock:			PBCall := PBCloseSync(ParmBlkPtr(ORD4(PbPtr)+4));
		ReqUnlock:		PBCall := PBCloseSync(ParmBlkPtr(ORD4(PbPtr)+4));
		ReqCreate:		PBCall := PBCreateSync(ParmBlkPtr(ORD4(PbPtr)+4));
		ReqGetFInfo:	PBCall := PBHGetFInfoSync(hParmBlkPtr(ORD4(PbPtr)+4));
		ReqSetFInfo:	PBCall := PBHSetFInfoSync(hParmBlkPtr(ORD4(PbPtr)+4));
		ReqOpWd:			PBCall := PBOpenWDSync(WDPBPtr(ORD4(PbPtr)+4));
	 	ReqClWd:			PBCall := PBCloseWDSync(WDPBPtr(ORD4(PbPtr)+4));
	 	ReqGetCat:		PBCall := PBGetCatInfoSync(CInfoPBPtr(ORD4(PbPtr)+4));
		ReqOpRsrc:		PBCall := PBOpenRFSync(ParmBlkPtr(ORD4(PbPtr)+4));
		ReqDirCreate:	PBCall := PBDirCreateSync(HParmBlkPtr(ORD4(PbPtr)+4));
		ReqFlush:			PBCall := PBFlushVolSync(ParmBlkPtr(ORD4(PbPtr)+4));
		ReqGetVol:		PBCall := PBGetVolSync(ParmBlkPtr(ORD4(PbPtr)+4));
		ReqSetVol:		PBCall := PBSetVolSync(ParmBlkPtr(ORD4(PbPtr)+4));
		ReqGetVInfo:	PBCall := PBGetVInfoSync(ParmBlkPtr(ORD4(PbPtr)+4));
		ReqCatMove:		PBCall := PBCatMoveSync(CMovePBPtr(ORD4(PbPtr)+4));
		ReqNameOfId:	{ •••• pas traité !!! •••• }
	END;
END;


PROCEDURE Drg_SetRunMode (NewMode: INTEGER);
BEGIN
END;


PROCEDURE Drg_ShutDownInstall(procPtr, dataPtr: Ptr);
{ installation d'une procédure d'arrêt }

VAR	nbProcs: INTEGER;

BEGIN
	lockExternal := TRUE;	{ il faut conserver la routine externe en mémoire !!! }
	nbProcs := GetHandleSize(Handle(ShutDownPRocs)) DIV SizeOf(ShutDownRec);
	SetHandleSize(Handle(ShutDownPRocs),GetHandleSize(Handle(ShutDownPRocs))+SizeOf(ShutDownRec));
	ShutDownProcs^^[nbProcs].ProcPtr := procPtr;
	ShutDownProcs^^[NbProcs].dataPtr := dataPtr;
END;


PROCEDURE Drg_Delay(value:LONGINT);

BEGIN
	IF Value>0 THEN WaitDelay(value);	{ from DragsterIO }
END;


PROCEDURE Drg_YieldCpu;
BEGIN
END;


FUNCTION Drg_RunFlags:Str255;

BEGIN
	IF EmulFlag THEN
		Drg_RunFlags[2] := 'E'	{ Emulateur }
	ELSE
		Drg_RunFlags[2]:= 'M';	{ modem }
	Drg_RunFlags[1] := 'I';		{ mode interpreté }
	Drg_RunFlags[0] := chr(2);
END;


FUNCTION Drg_NewHandle(size:LONGINT):Handle;

BEGIN
	IF MaxBlock<size+65536 THEN	{ on utilise de la RAM temporaire ? }
		Drg_NewHandle := TempNewHandle(size,CurTCB^.Error)
	ELSE
	BEGIN
		Drg_NewHandle := NewHandle(size);
		CurTCB^.Error := MemError;
	END;
END;


FUNCTION Drg_StoreData(dataPtr:Ptr; VAR dataName:Str255):OsErr;

VAR
	i: INTEGER;
	
BEGIN
	{ on cherche si ces données existent déjà… }
	FOR i := 1 TO NumOfData DO
		IF theData^^[i].Name^^=dataName THEN	{ trouvé !! }
		BEGIN
			theData^^[i].thePtr := dataPtr;
			Leave;
		END;
	IF i>NumOfData THEN	{ pas trouvé, on crée… }
	BEGIN
		NumOfData:=NumOfData+1;
		SetHandleSize(Handle(TheData),NumOfData*SizeOf(DatasRec));
		IF MemError=NoErr THEN
		BEGIN
			theData^^[NumOfData].Name:=NewString(dataName);
			theData^^[NumOfData].thePtr := dataPtr;
		END;
		CurTCB^.error := MemError;	{ prévenir la tâche de fond du résultat… }
	END;
END;


FUNCTION Drg_RestoreData(VAR dataName:Str255):Ptr;

VAR
	i: INTEGER;
	
BEGIN
	Drg_RestoreData:=NIL;
	FOR i := 1 TO NumOfData DO
		IF theData^^[i].Name^^=dataName THEN	{ trouvé !! }
		BEGIN
			Drg_RestoreData:=theData^^[i].thePtr;
			Leave;
		END;
END;


PROCEDURE Drg_KillData(VAR dataName:Str255);

VAR
	i: INTEGER;
	
BEGIN
	FOR i := 1 TO NumOfData DO
		IF theData^^[i].Name^^=dataName THEN	{ trouvé !! }
		BEGIN
			{ on libère la RAM occupée par le nom }
			DisposHandle(Handle(theData^^[i].Name));
			{ on décale les datas suivantes pour boucher le trou }
			IF i<NumOfData THEN BlockMoveData(@theData^^[i+1],@theData^^[i],(NumOfData-i)*SizeOf(DatasRec));
			{ on met à jour la taille du tableau }
			NumOfData := NumOfData-1;
			SetHandleSize(Handle(TheData),NumOfData*SizeOf(DatasRec));	
			Leave;
		END;
END;


FUNCTION Drg_EVEEnable(VAR PASSWORD:STRING):INTEGER ;

VAR		i:INTEGER;
			mask: INTEGER;
			pw: STRING[16];
			
BEGIN
	IF CurTCB^.TheNScreen<$1000 THEN
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


FUNCTION Value:INTEGER;
	INLINE $3E80;							{ MOVE.W D0,(A7) }

PROCEDURE Jump(Addr:Ptr);
	INLINE $205F,$4E5E,$4ED0;		{ MOVEA.L (A7)+,A0 ; UNLK A6; JMP (A0) }
	
PROCEDURE HandleSelector;

BEGIN
	CASE Value OF
		{ routines interne de la librairie }
		1: Jump(@FASRead);
		2: Jump(@FASWrite);
		3: Jump(@PBCall);		{ appels 'normaux' du file manager }
		4: Jump(@PBCall);		{ appels 'hiérarchiques' du file manager }
		5: Jump(@Drg_SetRunMode);
		6: Jump(@Drg_ShutDownInstall);	{ installation proc. d'arrêt serveur… }
		
		$1000: Jump(@EVEReset);
		$1001: Jump(@EVEStatus);
		$1002: Jump(@Drg_EVEEnable);
		$1003: Jump(@EVEChallenge);
		$1004: Jump(@EVEReadGPR);
		$1005: Jump(@EVEWriteGPR);
		$1006: Jump(@EVESetLock);
		$1007: Jump(@EVEReadCTR);
		
(*
		{ routines utilitaires de la librairie }
		128: Jump(@PathNameFromDirID);
*)
		{ routines utilitaires en liaison avec DragsterBoot }
		256: Jump(@Drg_NewHandle);
		257: Jump(@Drg_StoreData);
		258: Jump(@Drg_RestoreData);
		259: Jump(@Drg_KillData);
		
	END;
END;


PROCEDURE InitTCB;
{ initialisation complète du TCB pour l'interpretteur }

VAR	i:INTEGER;

BEGIN
	{ allocation et initialisation du TCB }
	CurTCB := TPtr(NewPtr(SizeOf(TRecord)));
	WITH CurTCB^ DO
	BEGIN
		MagicN1:=$87654321;	{ $12345678 en compilé !! }
		NextTCB:=NIL;
		PredTCB:=NIL;
		PtOffScreen:=NIL;
		PtNameScreen:=NIL;
		PtStringCsts :=NIL;
		PtSVars :=NIL;
		PtLVars :=NIL;
		PtCode :=NIL;
		PtScreens :=NIL;
		PtJump:=Ptr(JumpTable);
    PtOrgStk :=NIL; 
		TheNScreen:=-1;
		TheVScreen:=NIL;
		TheQueues:=NIL;
		TheMQueues:=NIL;
		TheAuxBuffPtr:=NIL;
    TheModem:=0;
		SerRefIn:=0;
		SerRefOut:=0;
		StatusWord:=0;
		DelayValue:=0;
		IOCompFlag:=0;
		Error:=0;
		PendAdr:=NIL;
		PendStr:=0;
		StartTime:=0;
		MaxTime:=0;
		ZoneNumber:=0;
		TaskNumber:=1;
		TaskPriority:=40;
		TheNLine:=0;
		TheNInst:=0;
		LocalMode:=TRUE;
		EchoFlag:=TRUE;
		OutPutFlag:=TRUE;
		FrOutPut:=TRUE;
		StarFlag:=FALSE;
		IsTeletel:=FALSE;
		TaskSNumber:=0;
		HardType:=1;
		OpFlag:=0;
		SerSpeed:=0;
		Infos:=NIL;
		OPPtr:=NIL;
		(* RegArea : ARRAY[0..16] OF Ptr; { 132 registres tache background} *)
    (* RegAreaF: ARRAY[0..16] OF Ptr; { 136 registres tache principale} *)
    NbZones:=0;
		RTId:=0;
		BreakCount:=0;
		ProtCount:=0;
		XCallDatas:='';
		ConnTime:=0;
		InBuffEnd:=NIL;
		InBuffPool:=NIL;
		RunMode:=0;
		CurRunMode:=0;
		InSilentFlag:=FALSE;
		WBuffFlag:=FALSE;
		ConFlag:=FALSE;
		XConFlag:=FALSE;
		InBuffNb:=0;
		FilterFlag:=TRUE;
		TrPrintFlag:=FALSE;
		RWSz:=256;
		RWPtr:=RWBPtr(NewPtr(RWSz));
		RWCount:=0;
		RWIdx:=0;
		DBPtr:=NIL;
		DBSz:=4096;
		DBCount:=0;
		DBRef:=0;
		DBIdx:=0;
		IOQueue:=0;
		RndMemo:=0;
		RndCount:=0;
		DemoCount:=0;
		InBuffSt:=NIL;
		FOR i := 1 TO MaxFile DO
			WITH TheFiles[i] DO
			BEGIN
				FileRef:=0;
				FileRLen:=0;
				FilePos:=0;
				BaseFlag:=FALSE;
			END;
	END;
END;


PROCEDURE InitInterpretorLib;

VAR	L: LONGINT;

BEGIN
	{ allocation de la Jump Table }
	JumpTable := JTPtr(NewPtr(SizeOf(JT)));
	
	{ allocation du tableau des datas sauvegardées pour les rout. externes }
	theData := DHandle(NewHandle(0));
	NumOfData := 0;

	{ allocation tableau des procédures d'arrêt }
	ShutDownProcs := ShutdownH(NewHandle(0));
	
	{ init du TCB bidon }
	InitTCB;
	
	{ JumpTable pour les routines externes }

	AddJumpTable(16,@GetTCB);
	AddJumpTable(17,@HandleSelector);
	AddJumpTable(31,@Drg_Delay);
	AddJumpTable(120,@Drg_YieldCpu);
	AddJumpTable(176,@Drg_Runflags);
	
	AddJumpTable(58,@Drg_ResetZones);
	AddJumpTable(77,@Drg_Zone);
	AddJumpTable(74,@Drg_Wait);
	AddJumpTable(9,@Drg_Input);
	
	AddJumpTable(2,@Drg_PrintChar);
	AddJumpTable(3,@Drg_PrintNum);
	AddJumpTable(4,@Drg_PrintStr);
	AddJumpTable(141,@Drg_PrintScreen);
	
	{ GOSUBSCREEN, GOTOSCREEN, CALLSCREEN }
	
(*
	AddJumpTable(26,@Drg_Close);
	AddJumpTable(55,@Drg_Open);
	AddJumpTable(28,@Drg_Create);
	AddJumpTable(37,@Drg_EOF);
	AddJumpTable(43,@Drg_FPOS);
	AddJumpTable(44,@Drg_GetEof);
	AddJumpTable(47,@Drg_Delete);
	AddJumpTable(57,@Drg_Rename);
	AddJumpTable(60,@Drg_RLen);
	AddJumpTable(61,@Drg_RSeek);
	AddJumpTable(62,@Drg_Seek);
	AddJumpTable(63,@Drg_SetEof);
	AddJumpTable(108,@Drg_Lock);
	AddJumpTable(109,@Drg_Unlock);
*)
END;


PROCEDURE CleanUpTCB;

BEGIN
	WITH CurTCB^ DO
	BEGIN
		DisposPtr(Ptr(RWPtr));
	END;
	DisposPtr(Ptr(CurTCB));
	CurTCB := NIL;
END;

PROCEDURE DoShutDownProcs;

VAR	nbProcs: INTEGER;
		i: INTEGER;
	
	PROCEDURE Push(data: LongInt);
		INLINE $4E71; { empilage d'une info = NOP }

	PROCEDURE CallShutDownProc(addr,dataPtr: ProcPtr); INLINE $205F,$4E90;
	{ MOVE (A7)+,A0 ; JSR (A0) }

BEGIN
	nbProcs := GetHandleSize(Handle(ShutDownProcs)) DIV SizeOf(ShutDownRec);
	HLock(Handle(ShutDownProcs));
	FOR i := 1 TO NbProcs DO
		WITH ShutDownProcs^^[i-1] DO
		BEGIN
			Push(ORD4(JumpTable));
			CallShutDownProc(dataPtr,procPtr);
		END;
		
	HUnlock(Handle(ShutDownProcs));
	DisposHandle(Handle(ShutDownProcs));
END;

PROCEDURE CleanUpLib;

BEGIN
	DoShutDownProcs;

	CleanUpTCB;
	DisposPtr(Ptr(JumpTable));
	JumpTable := NIL;
	
	DisposHandle(Handle(theData));
END;
