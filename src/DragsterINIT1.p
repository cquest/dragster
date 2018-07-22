{$IFC UNDEFINED Debug}
{$SETC Debug = FALSE }
{$ENDC}
{$SETC SERIAL = TRUE }
{$IFC UNDEFINED Demo}
{$SETC Demo = FALSE }
{$ENDC}
{$IFC UNDEFINED LIGHT}
{$SETC LIGHT = FALSE }
{$ENDC}

UNIT DragsterInit1;

INTERFACE

{************************************************************************}
{*								       								   															*}
{*	      Fichier Implementation Boot Background Videotex								*}
{*																																			*}
{************************************************************************}

USES	MemTypes,QuickDraw ,OSIntf ,ToolIntf ,PackIntf, SysEqu, AppleTalk, ADSP, TextUtils,
			DragsterInitProt, INITDrgUtil,
		{$U $$Shell(PUtilities) } Utilities;

FUNCTION Init1Proc(PROCEDURE ShowMsg(Msg:INTEGER)):INTEGER;	{ calcule l'espace mémoire nécessaire à la tâche de fond }

VAR
	Init1ProcSize: LONGINT;
	
IMPLEMENTATION


{$S Phase1}

TYPE
    IPtr = ^INTEGER;
		LIPtr = ^LONGINT;
    LIHdle = ^LIPtr;
	
	SizeRes = RECORD
		flags: PACKED ARRAY [0..7] OF BOOLEAN;
		preferred: LONGINT;
		minimum: LONGINT;
	END;
	SizeResPtr = ^SizeRes;
	SizeResHdl = ^SizeResPtr;

{$I DragsterTCB.p }
{$SETC Debug = FALSE }


	FUNCTION SizeExt:LONGINT;		{•••• évalue la taille des routines externes ••••}
	
		PROCEDURE ExtMissing(name:Str255);
		
		VAR
			Err: INTEGER;
			
		BEGIN
			ParamText(name,'','','');
			Err := MyAlert(261);	{ routine externe ??? manquante ! }
		END;
		
	CONST
		ExtType = 'DEXT';
		ExtType2 = 'DEXC';
		
	VAR
		Res: Handle;
		ResName: Str255;
		ResIndex: INTEGER;
		TheSize: LONGINT;
		
	BEGIN
		ResIndex := 0;
		TheSize := 0;
		REPEAT
			ResIndex := ResIndex+1;
			SetResLoad(TRUE);
			GetIndString(ResName,128,ResIndex);
			IF ResName <> '' THEN
			BEGIN
				SetResLoad(FALSE);
				Res := GetNamedResource(ExtType2,ResName);
				IF Res=NIL THEN Res := GetNamedResource(ExtType,ResName);
				IF Res=NIL THEN
				BEGIN
					ExtMissing(ResName);
					TheSize := -1;
				END
				ELSE
				BEGIN
					IF TheSize<>-1 THEN
					BEGIN
						TheSize := TheSize + SizeResource(Res);
						IF Odd(TheSize) THEN TheSize := TheSize + 1;
					END;
					ReleaseResource(Res);
				END;
			END;
		UNTIL ResName='';
		SizeExt := TheSize;
	END;


FUNCTION Concatnum(str:str255; num:longint):str255;

VAR	tempStr:Str255;

BEGIN
	numtostring(num,tempstr);
	concatnum := concat(str,tempstr);
END;


{ •• Recherche une entrée libre dans la table des Drivers •• }

FUNCTION RechFreeUnit: INTEGER;

TYPE
	UTable = ARRAY[0..10000] OF DCtlHandle;
	UPtr = ^UTable;

VAR TheUPtr	: UPtr;
		Termine	: BOOLEAN;
		i				: INTEGER;
		max			: INTEGER;	{ nb maxi de Drivers }
		
BEGIN
	TheUptr:=UPtr(LIPtr(UTableBase)^);
	termine:=FALSE;
	max := Iptr(UnitNtryCnt)^;
	i:= 13;
	WHILE (NOT termine) & (i<max) DO
	BEGIN
		termine:=TheUPtr^[i]=Nil;
		IF NOT termine THEN i:=i+1;
	END;
	IF i>=max THEN RechFreeUnit:=-1 ELSE RechFreeUnit:=i;
END;


FUNCTION Init1Proc;  { 1ere phase du boot }

VAR theRf, RefR : Integer;
		Err	    		: OSErr;
		TheBigSize  : longint;
		TheXFile    : XFileRecord;
		OurRT	    	: Handle;
		OurStor	    : TConfHdle;
		ThePtr	    : LIPtr;
		Count	    	: Longint;
		fndrInfo    : FInfo;
		TSKPH	    	: TSKPHdle;
		TSKCH	    	: Handle;
		i,L	    		: Longint;
		MaxRes	    : Longint;
		TheDRVR	    : Handle;
		TheDrvRef		: integer;
		DTRec				: DateTimeRec;
		HSpyer			: Handle;
		NbRt,RtIdx	: integer;
		NbTask			: integer;	{ nombre de tâches de communication }
		NbModem			: integer;	{ nombre de modems }
		NbMuxASM		: integer;	{ nombre de voies ASM }
		NbMuxASM2		: integer;	{ nombre de voies ASM deuxième port }
		NbMods			: integer;
		FlagMaster	: Boolean;
		SerRefIn,
		SerRefOut		: Integer;
		SerRefIn2,					{ deuxième port série }
		SerRefOut2	: INTEGER;
    DeskName 		: Str255;
    flags    		: SerShk;
		TheMods			: ModsArray;
		CodeName		: Str255;
		AppRefNum		: INTEGER;
		TheRes			: Handle;
		KeepIt			: BOOLEAN;
		Junior			: BOOLEAN;
		EveKey			: BOOLEAN;
		ADSPRefNum	: Integer;
		
PROCEDURE MyExit(theError:INTEGER);

BEGIN
	Init1Proc := theError;
	EXIT(Init1Proc);
END;

PROCEDURE Test(Num:INTEGER);

BEGIN
	IF theBigSize<0 THEN DebugStr(concatnum('Pb test No:',num));
END;


PROCEDURE MySerReset(ref:INTEGER; format: INTEGER);

BEGIN
	IF BAND(OurStor^^.WModNumber,2)=0 THEN
	BEGIN
		Err:=SerReset(ref, OurStor^^.SerSpeed+format);			{ out }
		Err:=SerReset(ref+1,  OurStor^^.SerSpeed+format);		{ in }
	END
	ELSE
	BEGIN
		Err:=SerReset(ref, OurStor^^.SerSpeed);			{ out }
		Err:=SerReset(ref+1,  OurStor^^.SerSpeed);	{ in }
	END;
END;

BEGIN		{ Init1Proc }
	
	Init1Proc := 0;	{ optimiste ! }
	
{$IFC Debug}
	DebugStr('InitProc1');
{$ENDC}
		
	nbModem := 0;
	NbLocal := 0;
	nbMuxAsm := 0;
	nbMuxAsm2 := 0;
	
	ourStor := TConfHdle(GetResource('CONF',256));
  IF (ourStor = Nil) THEN MyExit(1);
  
	HnoPurge(Handle(OurStor));


  {--------- verification du type du fichier executable ----------}
	IF OurStor^^.TheXScreen <> '' THEN	{ version DragsterBoot normale }
	BEGIN
		Err:=GetFInfo(OurStor^^.TheXScreen,0,fndrInfo);
		WITH fndrInfo DO
		BEGIN
			IF ((fdType<>'CODE') | ((fdCreator<>'DRG0') & (fdCreator<>'DRG1')))
				& (fdType<>'CODd') & (fdCreator<>'DRGd') THEN
				MyExit(5);
		END;
	END;
	
	CodeName := OurStor^^.TheXScreen;
	IF CodeName = '' THEN GetAppParms(CodeName,AppRefNum,HSpyer);
	HSpyer := NIL;
	
  {-------------- ouverture du fichier executable -------------}
  ShowMsg(1);
	Err:=FSOpen(CodeName,0,RefR);
  IF Err<>0 THEN
	BEGIN
		Err:=FSClose(RefR);
		MyExit(2);
	END;

  {--------- lecture parametres du fichier executable ---------}
  Count:=SizeOf(XFileRecord);
  Err:=FSRead(RefR,Count,@TheXFile);
  IF Err<>0 THEN
	BEGIN
    Err:=FSClose(RefR);
		MyExit(3);
  END;
  
	Err:=FSClose(RefR);


  {--------------- initialiser le port serie ----------------}
  ShowMsg(2);
	{ Choix et ouverture du port }
	CASE OurStor^^.Serport OF
		0:
		BEGIN
			Err:=OpenDriver('.AOut',SerRefOut);		{ modem }
			Err:=OpenDriver('.AIn',SerRefIn);
			outBuff1 := NewPtr(1024);
			Err := SerSetBuf(SerRefOut, outBuff1, 1024);
			inBuff1 := NewPtr(1024);
			Err := SerSetBuf(SerRefIn, inBuff1, 1024);
		END;
		1:
		BEGIN
			Err:=OpenDriver('.BOut',SerRefOut);		{ imprimante }
			Err:=OpenDriver('.BIn',SerRefIn);
			outBuff1 := NewPtr(1024);
			Err := SerSetBuf(SerRefOut, outBuff1, 1024);
			inBuff1 := NewPtr(1024);
			Err := SerSetBuf(SerRefIn, inBuff1, 1024);
		END;
		-1:
		BEGIN
			Err:=OpenDriver('.AOut',SerRefOut);		{ modem et...}
			Err:=OpenDriver('.AIn',SerRefIn);
			outBuff1 := NewPtr(1024);
			Err := SerSetBuf(SerRefOut, outBuff1, 1024);
			inBuff1 := NewPtr(1024);
			Err := SerSetBuf(SerRefIn, inBuff1, 1024);
			Err:=OpenDriver('.BOut',SerRefOut2);	{ ...imprimante }
			Err:=OpenDriver('.BIn',SerRefIn2);
			outBuff2 := NewPtr(1024);
			Err := SerSetBuf(SerRefOut, outBuff2, 1024);
			inBuff2 := NewPtr(1024);
			Err := SerSetBuf(SerRefIn, inBuff2, 1024);
		END;
		
		OTHERWISE		{ port série supplémentaire… (Hurdler) }
		BEGIN
			Err := OpenDriver(concat('.',chr($41+OurStor^^.Serport),'Out'),SerRefOut);
			Err := OpenDriver(concat('.',chr($41+OurStor^^.Serport),'In'),SerRefIn);
		END;
	END;
	
{$IFC Debug}
DebugStr(concatnum('Init du port serie, Err=',Err));
{$ENDC}

	{ Réglage paramètres de comm. }
	Err:=SerReset(SerRefOut, baud19200+data8+stop10+noparity);
	Err:=SerReset(SerRefIn,  baud19200+data8+stop10+noparity);
	
  { Réglage HandShake }
	WITH Flags DO
  BEGIN
    fXon:=0;
		finX:=0;
		xOn:=chr(19);
		xOff:=chr(17);
		fCTS:=0;
		errs:=0;
		evts:=0;
	END;
	Err:=SerHShake(SerRefOut, flags);
	
	
	IF OurStor^^.SerPort=-1 THEN	{ utilisation des deux ports }
	BEGIN
		{ Réglage paramètres de comm. du deuxième port }
		Err:=SerReset(SerRefOut2, baud19200+data8+stop10+noparity);
		Err:=SerReset(SerRefIn2,  baud19200+data8+stop10+noparity);

		{ Réglage HandShake }
		WITH Flags DO
		BEGIN
			fXon:=0;
			finX:=0;
			xOn:=chr(19);
			xOff:=chr(17);
			fCTS:=0;
			errs:=0;
			evts:=0;
		END;
		Err:=SerHShake(SerRefOut2, flags);
	END;
	
  {--------------- on compte le nombre de voies… ----------------}
	
	{ 1- détection des voies Dragster }
	{ 2- détection voies AppleTalk }
	{ 3- détection des voies ASM }
	{ 4- config voie port série }

	NbMods:=0;
	
{$IFC Demo=FALSE}
(*
EveKey := (EveStatus=noErr);	{ indique si une clé EvE est présente }
*)
	GetNbLocal;									{ on lit le nombre de voies dans la clé EvE }
	EveKey := (NbLocal2 = 0);

{$IFC Debug}
if EveKey THEN
	DebugStr('evekey = vrai');
DebugStr(concatnum('NbLocal: ',NbLocal));
DebugStr(concatnum('NbLocal2: ',NbLocal2));
DebugStr(concatnum('NbX25key: ',NbX25key));
{$ENDC}

{$IFC Debug}
DebugStr('comptage des modems dragster');
{$ENDC}
	ShowMsg(3);
	{ Réglage paramètres de comm. pour modems Dragster }
	Err:=SerReset(SerRefOut, baud19200+data8+stop10+noparity);
	Err:=SerReset(SerRefIn,  baud19200+data8+stop10+noparity);
	NBModem:=CountModem(SerRefOut,FlagMaster,TheMods,NbMods,OurStor);

	IF (BAND(OurStor^^.WModNumber,1)<>0) & (NbModem=0) THEN
	BEGIN		{ pas de modem Dragster… on cherche un modem Hayes™ }
		ShowMsg(19);
		{ Réglage paramètres de comm. pour modem Hayes }
		MySerReset(SerRefOut,data8+stop10+noparity);
		
		IF EveKey & TestHayes(SerRefOut) THEN
		BEGIN
			NbMods := NbMods+1;
			NbModem := NbModem+1;
			TheMods[NbMods].ModNum := 0;
			TheMods[NbMods].ModRef:=SerRefOut;	{ driver pour y accéder }
			TheMods[NbMods].ModType:=modemHayes;
		END;
	END;
	
	IF OurStor^^.SerPort=-1 THEN	{ on utilise les deux ports… }
	BEGIN
		{ Réglage paramètres de comm. pour modem Dragster }
		Err:=SerReset(SerRefOut2, baud19200+data8+stop10+noparity);
		Err:=SerReset(SerRefIn2,  baud19200+data8+stop10+noparity);
		NBModem:=CountModem(SerRefOut2,FlagMaster,TheMods,NbMods,OurStor);
		IF (BAND(OurStor^^.WModNumber,1)<>0) & (((NbModem=1) & (TheMods[1].ModRef<>SerRefOut2)) | (NbModem=0)) THEN
		BEGIN
			{ Réglage paramètres de comm. pour modem Hayes }
			MySerReset(SerRefOut2,data8+stop10+noparity);
			
			IF TestHayes(SerRefOut2) THEN
			BEGIN
				NbMods := NbMods+1;
				NbModem := NbModem+1;
				TheMods[NbMods].ModNum := 0;
				TheMods[NbMods].ModRef:=SerRefOut2;	{ driver pour y accéder }
				TheMods[NbMods].ModType:=modemHayes;
			END;
		END;
	END;
{$IFC Debug}
	DebugStr(concatnum('Nb Modems: ',NBModem));
{$ENDC}
{$ELSEC}
	NbModem := 0;
{$ENDC}


	{ NbLocal := 0; // 13/9/99 }
	
	Junior := ourStor^^.theXScreen='';	{ MacARBO Démo ou Junior }
	
{$IFC DEMO=FALSE}
	IF NOT EveKey THEN
		NbX25Key := 0;			{ pas de clé = pas de voies X25 ASM }
	{ nb voies ASM = voies de la clé si nb en config=0 ou > à nb dans la clé }
	IF (OurStor^^.X25Number=0) | (NbX25Key < OurStor^^.X25Number) THEN
		OurStor^^.X25Number := NbX25Key;
{$ENDC}

	{ AppleTalk et ADSP disponibles ? }
	IF (MPPOpen = NoErr) & (OpenDriver('.DSP',ADSPRefNum)=NoErr) THEN
	BEGIN
{$IFC Demo=FALSE}
		IF NOT Junior THEN	{ autre que démo ou junior }
		BEGIN	{ DragsterBoot normal }
			IF (NbLocal=0) | (EveKey=FALSE) | (NbLocal>32) THEN
			BEGIN
				NbLocal := 1;		{ une seule voie locale si clé absente }
				NbLocal2 := 255;{ AppleTalk en démo… }
			END;
		END
		ELSE	{ MacARBO Démo ou Junior }
{$ENDC}
		BEGIN
			NbLocal := 1;		{ une seule voie AppleTalk de démo }
			NbLocal2 := 255;{ AppleTalk en démo… }
		END;
	END
	ELSE
		NbLocal := 0;	{ pas d'AppleTalk/ADSP = pas de voie locale }
	
	
{$IFC Debug}
	DebugStr(concatnum('NbLocal=',nblocal));
{$ENDC}

{$IFC Demo=FALSE AND LIGHT=FALSE }
  IF EveKey & (NbModem=0) THEN	{ pas de modem Dragster en ligne !! }
  BEGIN
{$IFC Debug}
DebugStr('comptage des voies ASM');
{$ENDC}
		IF NOT Junior & (OurStor^^.SerSpeed<>0) THEN	{ détection voies ASM… }
		BEGIN
			MySerReset(SerRefOut,data8+stop10+noparity);
			NBMuxASM:=CountMuxAsm(SerRefOut,TheMods, NbMods, OurStor);
			IF ourStor^^.SerPort=-1 THEN 	{ sur les deux ports série… }
			BEGIN
				MySerReset(SerRefOut2,data8+stop10+noparity);
				NBMuxASM2:=CountMuxAsm(SerRefOut2,TheMods, NbMods, OurStor)-NBMuxASM;
			END;
		END;
	END;
{$ENDC}

	IF (NbModem=0) & (NbMuxAsm=0) THEN	{ pas de modem Dragster ni voies ASM !! }
	BEGIN
{$IFC SERIAL}
		IF OurStor^^.SerSpeed<>0 THEN	{ port série utilisable directement }
		BEGIN
			{ on reconfigure pour un minitel en local }
{$IFC Debug}
DebugStr('config voie locale');
{$ENDC}
			Err:=SerReset(SerRefOut, baud1200+data7+stop10+evenParity);
			Err:=SerReset(SerRefIn,  baud1200+data7+stop10+evenParity);
			NbModem := 1;
			IF ourStor^^.SerPort=-1 THEN 	{ sur les deux ports série… }
			BEGIN
				Err:=SerReset(SerRefOut2, baud1200+data7+stop10+evenParity);
				Err:=SerReset(SerRefIn2,  baud1200+data7+stop10+evenParity);
				NbModem := 2;
			END;
			FlagMaster := FALSE;
		END
		ELSE
{$ENDC}
		BEGIN	{ port série inutilisable en direct }
			Err := CloseDriver(SerRefOut);
			Err := CloseDriver(SerRefIn);
			IF OurStor^^.SerPort=-1 THEN
			BEGIN
				Err := CloseDriver(SerRefOut2);
				Err := CloseDriver(SerRefIn2);
			END;
(*
			IF EVEStatus<>0 THEN MyExit(6);	{ pas de modem en ligne et pas de clé EvE ! }
*)
		END;
	END;
	
	NbTask := NbModem + NbMuxASM + NbMuxASM2 + NbLocal;

	IF NbTask = 0 THEN MyExit(6);	{ aucune voie !! }
{$IFC Demo=FALSE}
	IF (NbTask=NbLocal) & (NbLocal2=255) THEN
		MyExit(6);	{ pas de hard, pas de clé AppleTalk ! }
{$ENDC}


{$IFC Debug}
	DebugStr('Calcul taille');
{$ENDC}

	ShowMsg(4);
	{---- on calcule la place nécessaire aux queues de messages ---}
	{ Règle de calcul:
	 
	 	Place a allouer=
		
		Un fois pour toutes les voies + Tache annexe 
		
		*- Auxiliary IOBuffer
		*- Input Buffer Pool	( output pour version RTC )
		*- Espion et Bound Checker
		*- Messages Queues
		*- Server Queues
		*- Shared Vars
		*- Xcutable Code ( 	Table Offsets,
							Screen Names,
							Csts chaine,
							screens,
							code)
							•••• routines externes ••••
		*- RunTime
		
		une fois par voie + tache annexe
		
		*- Task control block
		*- locales
		*- stack
		*- RW buffers
		*- DB Buffers
		
		une fois par voie
		
		*- OutPut Ring Buffer
		
		une fois par voie locale
		
		*- ADSP Buffers
		
		pour taches de service
		
		*- Task control block
		*- globales
		*- locales
		*- stack
		*- code
		*- RW Buffers
		*- DB Buffers
		
	}
	
	Hlock(Handle(ourStor));
	 
	WITH ourStor^^ DO
	BEGIN
		{ Init TheBigSize }
	 	TheBigSize:=0;
		
		{•••• Taille des routines externes ••••}
		SetResLoad(FALSE);
		RefR := OpenResFile(TheXScreen);
		L:=SizeExt;
		IF L=-1 THEN MyExit(-1);	{ il manque au moins une externe }
		TheBigSize:=TheBigSize+L;
		IF RefR <> AppRefNum THEN CloseResFile(RefR);
		
{$IFC Debug} test(1);	{$ENDC}
		
		{ Buffer IO Auxiliaire }
		TheBigSize:=TheBigSize+SerBufSz*2;
		
{$IFC Debug} test(2);	{$ENDC}
		
		{ Buffer d'entrée pour les voies ASM }
		IF NbMuxASM>0 THEN
		BEGIN
			IF InBuffSz<InBuffSzMin THEN
				InBuffSz := InBuffSzMin;	{ 16/7/97 }
			
			IF (NbMuxAsm+NbMuxAsm2)>0 THEN
				TheBigSize := theBigSize +Ord4((NbMuxAsm+NbMuxAsm2)*2+InBuffSz)*Ord4(sizeOf(iBuffRec))+Ord4(SizeOf(PBuffRec))
		END;
		
{$IFC Debug} test(3);	{$ENDC}
		
		{ Espion et Bound Checker }
		SetResLoad(FALSE);
		HSpyer:=GetResource('DRGC',256);
    IF (HSpyer <> Nil) THEN
		BEGIN
			TheBigSize:=TheBigSize+SizeResource(HSpyer);
			ReleaseResource(HSpyer);
    END;
		
{$IFC Debug} test(4);	{$ENDC}
		
		{ Messages entre taches }
	 	TheBigSize:=TheBigSize+SizeOf(MQRec)+(Ord4(MessSize)*Ord4(NbTask+NbAux));

{$IFC Debug} test(5);	{$ENDC}
		
		{ Queues des serveurs }
	 	TheBigSize:=TheBigSize+SizeOf(TQRec);

{$IFC Debug} test(6);	{$ENDC}
		{ Variables Partagées }
		WITH TheXFile DO TheBigSize:=TheBigSize+SzSVars;

{$IFC Debug} test(7);	{$ENDC}
		{ Table Offsets }
		WITH TheXFile DO TheBigSize:=TheBigSize+Ord4(SzOffScreen);

{$IFC Debug} test(8);	{$ENDC}
		{ Table Nom d'ecrans }
		WITH TheXFile DO TheBigSize:=TheBigSize+Ord4(SzNameScreen);

{$IFC Debug} test(9);	{$ENDC}
		{ Table Cst Chaine }
		WITH TheXFile DO TheBigSize:=TheBigSize+Ord4(SzStringCsts);

{$IFC Debug} test(10);	{$ENDC}
		{ Table Ecrans Videotex }
		WITH TheXFile DO TheBigSize:=TheBigSize+SzVCode;

{$IFC Debug} test(11);	{$ENDC}
		{ Code executable }
		WITH TheXFile DO TheBigSize:=TheBigSize+SzCode;
					
		SetResLoad(FALSE);

{$IFC Debug} test(12);	{$ENDC}
		{ Table de Jump }
    ourRT := GetResource('DRJT',256);
    TheBigSize:=TheBigSize+SizeResource(OurRT);
		ReleaseResource(OurRT);
		
{$IFC Debug} test(13);	{$ENDC}
		{ taille des RunTimes }
		NbRT:=CountResources('DRRT');
		FOR RTidx:=1 TO NbRT DO
		BEGIN
			ourRT := GetIndResource('DRRT',RTidx);
			TheBigSize:=TheBigSize+SizeResource(OurRT);
			ReleaseResource(OurRT);
		END;
		
{$IFC Debug} test(14);	{$ENDC}
		{ Pour chaque voie + tache annexe }
		WITH TheXFile DO
     	TheBigSize:=TheBigSize+
					(SzVars+
					 SzStack+
					 SizeOf(TRecord)+
					 RWBSize+
					 DBComSize
					 )*ord4(NbTask+NbAux);
		
{$IFC Debug} test(15);	{$ENDC}
    { Buffers de sortie de données }
		TheBigSize:=TheBigSize+140*ord4(NbTask);	
		
{$IFC Debug} test(16);	{$ENDC}
		{ infos supplémentaires (ADSP & X25) }
		TheBigSize:= TheBigSize+Ord4(SizeOf(InfoRec)*ORD4(NbMuxASM + NbMuxASM2 + NbLocal + LONGINT(NbLocal>0)));
		
{$IFC Debug} test(17);	{$ENDC}
		{ pour chaque tache de service }
    MaxRes:=CountResources('TSKP');
    FOR i:=1 TO MaxRes DO
    BEGIN
      SetResLoad(TRUE);
			TSKPH:=TSKPHdle(GetIndResource('TSKP',i));
			
			WITH TSKPH^^ DO
			BEGIN
				{ on vérifie si chaque tâche serveur est à conserver… }
				CASE TSKCNumber OF
					1024:	{ modems Dragster }
						KeepIt := FlagMaster;	{ on garde si on utilise des modems Dragster }
					1025:	{ fichiers }
						KeepIt := TRUE;	{ toujours nécessaire ! }
					1026:	{ modems Dragster 2ème port }
						KeepIt := FlagMaster & (OurStor^^.SerPort=-1);	{ uniquement si deux ports utilisés }
					1027:	{ ASM }
						KeepIt := (NbMuxAsm>0);	{ uniquement si on a des voies ASM/X }
					1028:	{ ASM 2ème port }
						KeepIt := ((OurStor^^.SerPort=-1) & (NbMuxAsm2>0));	{ uniquement si deux ports utilisés }
					1030:	{ WinTree }
						KeepIt := (OurStor^^.DBComSize<>0);	{ taille base <> 0 }
					1031:	{ ADSP }
						KeepIt := (NbLocal>0);	{ uniquement si on a des voies AppleTalk }
					OTHERWISE
						KeepIt := TRUE;
				END;
				
				IF KeepIt THEN
				BEGIN
					{Taille du code de la tache }
					SetResLoad(FALSE);
					TSKCH:=GetResource('TSKC',TSKPH^^.TSKCNumber);
					TheBigSize:=TheBigSize+SizeResource(TSKCH);
					ReleaseResource(Handle(TSKCH));
												
					{ globales une fois }
					TheBigSize:=TheBigSize+ord4(SzGlobs);
								
					{ (TCB + locales + pile + code) * Nombre de tache }
					TheBigSize:=TheBigSize+ ord4(ord4(SzLocs)+ord4(SzStack)+ord4(SizeOf(TRecord)))*ord4(TNumber);
								
					{ (RW Buffer + DB Buffer) * Nombre de tache }
					TheBigSize:=TheBigSize+
						ord4(ord4(RWBSize) * NeedsRW +
						ord4(DBComSize) * NeedsDB
						)*ord4(TNumber);

{$IFC Debug} test(TSKPH^^.TSKCNumber); {$ENDC}

				END;
			END;	{ TSKPH^^ }
			
      ReleaseResource(Handle(TSKPH));
			
    END;
		
	END; { with OurStor^^ }
	 
	ShowMsg(5);
	{--------------- recherche d'une Unit Entry libre --------------}
	TheDrvRef:=RechFreeUnit;
	IF TheDrvRef=-1 THEN MyExit(10);	{ plus de place dans la table des Drivers }
		    
	{-------------- on renumerote le Driver Dragster ---------------}
	SetResLoad(TRUE);
	TheDRVR:=GetNamedResource('DRVR','.Dragster');
	SetResInfo(TheDRVR,TheDrvRef,'.Dragster');
	ChangedResource(TheDRVR);
	UpdateResFile(HomeResFile(TheDRVR));
	ReleaseResource(TheDRVR);
	 
  {-------------- on ouvre le Driver Dragster ------------------}
  DeskName:='.Dragster';
	Err:=OpenDriver(DeskName,TheDrvRef);
	IF Err<>NoErr THEN MyExit(Err);

  {----------- on detache le driver du fichier ressource ---------}
  TheDRVR:=GetNamedResource('DRVR',DeskName);
  DetachResource(TheDRVR);

	IF Odd(TheBigSize) THEN TheBigSize := TheBigSize+1;
	
	Init1ProcSize := theBigSize;
	Init1Proc := NoErr;
{$IFC Debug}
	DebugStr(concatnum('Taille: ',theBigSize));
	DebugStr(concatNum('TempMaxMem: ',L));
{$ENDC}
END;	{ Init1Proc }


END.
