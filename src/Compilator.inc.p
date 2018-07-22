{
Utilisation des registres du 68000:

	A7 = pile
	A6 = stack frame
	A5 = pointeur vers Jump Table (externes)
	A4 = pointeur vers TCB courant
	A3 = pointeur vers Jump Table
	A2 = pointeur vers variables
	A1/A0 = modifiable
	
	D7 = utilisé par FOR, PRINT, READ, etc…
	D0 = scratch
}

{$SETC CDisk	= FALSE}
{$SETC GenAsm = FALSE}
{$SETC UseAsm = FALSE}
{$SETC Debug  = FALSE}
{$SETC DebugCode = FALSE}	{ debugging du code généré… }
{$SETC TempVtx=FALSE}
{$SETC Perf=FALSE}

{$SETC TEST=FALSE}

{$IFC TEST}
{$SETC DebugCode = TRUE}	{ debugging du code généré… }
{$ENDC}

{$IFC UNDEFINED DEMO}
{$SET DEMO=FALSE}
{$ENDC}

		USES StandardFile, Folders, GestaltEqu, CursorCtl, TextUtils,
					{$IFC Perf}
					Perf,
					{$ENDC}
 					{$U $$Shell(PUtilities) }Utilities;
		
		CONST
			{ on recupere les constantes des tokens }

			{$I TkTokenCst.p}

			US = chr(31);
			CAN = chr(24);
			FF = chr(12);
			REP = chr(18);
			ESC = chr(27);
			SP = chr(32);
			SO = chr(14);
			SI = chr(15);
			SS2 = chr(22);
			RS = chr(30);
			DC1 = chr(17);
			DC4 = chr(20);

			kCreatorbis = 'DRG1';
			kCreator = 'DRG0';
			kType = 'CODE';

{$IFC DEMO}
			kCreatorDemo = 'DRGd';	{ code compilé pour Démo }
			kTypeDemo = 'CODd';
{$ENDC}

			kProcID = $44524739;	{ 'DRG9' }
			
			IntSize = 4;
			StrSize = 256;
			
			MsgListID = 262;	{ STR# des messages d'erreur }
			
			{$I DragsterTCB.p }

		TYPE
			{ tab. des structures de contrôles (IF/ELSE/ENDIF, FOR/NEXT, WHILE/WEND) }
			RecWIFEt = RECORD
									 CASE tpRec: Integer OF
										 0:
											 (EtWhile, EtEndWhile: Integer);
										 1:
											 (EtForInc, EtForTest, EtEndFor: Integer);
										 2:
											 (EtIfStart, EtIfEnd: LONGINT;	{ pc avant et après IF }
											  EtElse, EtEndif: Integer);
										 3:
										   (EtRepeat, EtUntil, EtUntilEnd: INTEGER);
(*
										 4:
										   (EtCase, EtEndCase: INTEGER);
*)
								 END;
			TRecWIFEt = ARRAY [1..MaxImb] OF RecWIFEt;	{ alloc. statique }
			PRecWIFet = ^TRecWIFEt;
			HRecWIFet = ^PRecWIFet;

			{ tab. de pile d'étiquettes }
			RecEt = RECORD
								FlagDefined: Boolean;
								LastOffset: Integer;
							END;
			TRecEt = ARRAY [1..MaxEtiq] OF RecEt;		{ alloc. statique }
			PRecEt = ^TRecEt;
			HRecEt = ^PRecEt;

			{ tab. d'indirection de variables }
			RICstRes = ARRAY [1..10000] OF Longint;			{ alloc. dynamique }
			PICstRes = ^RICstRes;
			HICstRes = ^PICstRes;

			{ tableau des variables }
			TGVar = RECORD
								NomVar: Str20;
								DimVal: Integer;
								Shared: Boolean;
								TpVar: Integer;
								OffsetVar: Longint;
								SizeVar: Longint;
							END;
			TbVar = RECORD
								NbVars: Integer;
								Vars: ARRAY [1..10000] OF TGVar;	{ alloc. dynamique }
							END;
			PTbVar = ^TbVar;
			HTbVar = ^PTbVar;

			{ tableau des modules compilés }
			TGScreen = RECORD
									 NomScreen: StringHandle;
									 OffsetCode, OffsetVcode: Longint;
									 FlagProcessed: Boolean;
									 FromScreen: Integer;
								 END;
			TgBScreen = RECORD
										NbScreens: Integer;
										TheScreens: ARRAY [1..10000] OF TGScreen;		{ alloc. dynamique }
									END;
			PTgScreen = ^TgBScreen;
			HTgScreen = ^PTgScreen;

			{ Tab. des routines externes utilisées par le code compilé }
			ExtTable = ARRAY [1..MaxExtMots] OF INTEGER;
						
			{ divers }
			BPtr = ^Char;
			IPtr = ^Integer;
			LPtr = ^Longint;

			
		VAR
			Pc, OffPc: Longint; { Program Counter }
			PcFlag: Boolean; { Indicateur de Jump }
			BreakFlag: Boolean; { Indicateur de Break }
			ContFlag: Boolean; { Indicateur de Continue }
			TheGScreen: HTgScreen; { Pool de noms d'ecran }
			TheGVars: HTbVar; { variables globales pool}
			TheCVars: HVarRes; { variables locales ecran}
			TheGCode: Handle; { handle du code 68000 (32Ko) }
			TheCCode: TparamHandle; { handle du code Basic }
			TheGCsts: Handle; { constantes compactees }
			TheCCsts: HCstRes; { constantes locales }
			TheICsts: HICstRes; { indirection constantes }
			TheGVCode: Handle; { code Videotex pool }
			NumCode: Integer; { numero de code en cours}
			NumEtiq: Integer; { nombre d'etiquettes }
			NumWIF: Integer; { niveau d'imbrication While/For/If }
			StackEt: HRecEt; { pile etiquettes }
			StackWIF: HRecWIFet; { pile While/For/If }
			StackSnif: Longint; { detection de taille de pile }
			StackUp: Longint; { profondeur max de la pile }
			CurVol: Integer; { Volume du premier nom }
			CDRef: Integer; { Reference fichier de code }
			{$Z+}
			CodeStart: Longint; { début du code temporaire }
			CodeEnd: Longint; { fin du code temporaire }
			{$Z-}

			LWarn, GWarn: Integer; { # warning locaux et globaux }

			theEvent: EventRecord;
			StartTime: Longint;
			EndTime: Longint;
			Chaine: Str255;
			
			ExtUsed: ExtTable;		{ Table des routines externes utilisées }
			NbExtUsed: INTEGER;		{ Nombre de routines externes utilisées }
			TheExtList: Handle;		{ Handle pour enregistrer la liste des routines utilisées dans une STR# }
			theExtJump: Handle;		{ Handle pour enregistrer le N° de JumpTable des externes }
			CurExt: LONGINT;			{ index pour créer la STR# des externes }
			n: INTEGER;						{ " " }
			L: LONGINT;						{ offset pour la création de la liste des modules STR# }
			
			PreCompFile: INTEGER;
			gCurCode:		 INTEGER;	{ numéro du code courant }
			
			Stat: LONGINT;			{ nombre de lignes compilées }

{$IFC Debug}
			CheckHandle: Handle;	{ handle pour provoquer les check mémoire }
{$ENDC}

			NL			: INTEGER;	{ numéro de ligne courante }
			NInst		: INTEGER;	{ numéro d'instruction courante }
			LastLine: INTEGER;	{ numéro de dernière ligne générée }
			LastInst: INTEGER;	{ numéro de dernière instruction générée }

			CompFlag: INTEGER;	{ compteur pour les TRACEBEGIN/TRACEEND }

			{ Tableau des déclarations d'exécution conditionnelle }
			CompCondTable : ARRAY [1..MaxCondEx] OF INTEGER;
			NbCompCond: INTEGER;
			P: Ptr;
			
			{ ref fichier temporaire des écrans vidéotex }
			vtxtRef: INTEGER;
			vtxtSize: LONGINT;	{ longueur écrans vidéotex }

{$IFC DEMO}
			nbDemoScreens: INTEGER;	{ nombre de sources compilés }
{$ENDC}

{$IFC Perf }
			thePerfGlobals: TP2PerfGlobals;
{$ENDC}

		PROCEDURE ErrorManager(Error: OsErr; from: Integer);
			FORWARD;

		PROCEDURE InstXCute(e: TParamPtr);
			FORWARD;

		PROCEDURE ContXCute(e: TParamPtr);
			FORWARD;

		PROCEDURE ProcXCute(e: TParamPtr);
			FORWARD;

		PROCEDURE StrExprXCute(e: TParamPtr);
			FORWARD;

		PROCEDURE NumExprXCute(e: TParamPtr);
			FORWARD;

		PROCEDURE NumExprXCuteDx(e: TParamPtr; x:INTEGER);
			FORWARD;

		PROCEDURE AffXCute(e: TParamPtr);
			FORWARD;

		PROCEDURE ListeXCute(e: TParamPtr);
			FORWARD;

		PROCEDURE LoadCode(NumCC: Integer; DirID:LONGINT);
			FORWARD;

		PROCEDURE AdrA0(e: TParamPtr);
			FORWARD;

		PROCEDURE VarToA7(e: TParamPtr);
			FORWARD;

		PROCEDURE PAdrVar(e: TParamPtr);
			FORWARD;

		PROCEDURE CheckMem;
			FORWARD;

		PROCEDURE AddCode1(Val: Integer);
			FORWARD;
		PROCEDURE AddCode2(Val1, Val2: Integer);
			FORWARD;
		PROCEDURE AddCode3(Val1: Integer; Val2: Longint);
			FORWARD;
		PROCEDURE AddCodeL(Val: Longint);
			FORWARD;
			

{$S COMPILATEUR}
		FUNCTION GetMessage(MsgID:INTEGER):Str255;
		
		VAR
			temp:Str255;
			
		BEGIN
			GetIndString(temp,MsgListID,MsgID);
			GetMessage := Temp;
		END;
		
{$S COMPILATEUR}
		FUNCTION ParamMessage(MsgID:INTEGER; Str1,Str2,Str3,Str4:Str255):Str255;
		
		VAR
			temp:Str255;
		
		BEGIN
			GetIndString(temp,MsgListID,MsgID);
			ParamStr(temp,str1,str2,str3,str4);
			ParamMessage := temp;
		END;
		

{ •••• Routines externes •••• }

{ Utilisation d'une routine -> enregistrement dans ExtUsed }

{$S COMPILATEUR}
PROCEDURE UseExtToken(e: TParamPtr);

VAR
	i: INTEGER;
	
BEGIN
	FOR i := nbTokens+1 TO nbTok DO
		IF mots^^[i].MotRes = e^.extInfos.ExtName THEN
		BEGIN
			e^.tk := i;
			Leave;
		END;
	IF i>NbTok THEN
	BEGIN
		WWLNStr('');
		WWLnStr(ParamMessage(1, e^.extInfos.ExtName, TheGScreen^^.TheScreens[NumCode].NomScreen^^, '', ''));
		
		ErrFlag := TRUE;
		Error := ErrNoExtToken;
		e^.tk:=0;
		EXIT(UseExtToken);
	END;
	FOR i := 1 TO NbExtUsed DO IF ExtUsed[i] = e^.tk THEN Leave;
	IF i>NbExtUsed THEN
	BEGIN
		NbExtUsed := NbExtUsed + 1;
		ExtUsed[NbExtUsed] := e^.tk;
	END;
END;


{ Rend le token suivant }

{$S COMPILATEUR}
PROCEDURE NextCompToken(VAR e:TParamPtr;offset:LONGINT);

BEGIN
	e:= TParamPtr(Ord4(StripAddress(Ptr(e)))+offset);
	IF e^.Tk = ExtToken THEN UseExtToken(e);
END;

		
{$S COMPILATEUR}
FUNCTION CallExtToken(number: INTEGER):INTEGER;

VAR
	i: INTEGER;
	
BEGIN
	CallExtToken := 0;
	FOR i := 1 TO NbExtUsed DO IF ExtUsed[i] = number THEN
	BEGIN
		CallExtToken := i;
		Leave;
	END;
END;


{==============================================================================}
{ 											 U T I L I T A I R E S																 }
{==============================================================================}

{$S COMPILATEUR}


		PROCEDURE CheckWrite(Err: OsErr);

			BEGIN
				IF Err = DskFulErr THEN
				BEGIN
					ErrorManager(Err, 1000);
					ErrFlag := TRUE;
					Error := Err;
				END;
			END;

		FUNCTION CodeGen;

			VAR
				i, Numvar: Integer;
				NoMoreGen: Boolean;
				TheXConf: XFileRecord;
				TheOffs: THOffScreen;
				TheSNames: Handle;
				Err: OsErr;
				OffCode, OffMax: Longint;
				prompt,prompt2: Str255;
				fname: Str255;
				FileDest: SFReply;
				RefW: Integer;
				CurTime: Longint;
				XvarTab: HVarRes;
				XcstTab: HCstRes;
				TheExt: Handle;
				TheExtID: INTEGER;
				TheExtType: ResType;
				TheExtName: Str255;
				reply: SFReply;
				typelist: SFTypeList;
				FirstCodeName: Str255;	{ nom du premier module à compiler }
				NewReply: StandardFileReply;
				TempFile: FSSpec;
				box: Rect;
				fndrInfo: FInfo;
				items: ARRAY [1..10] OF Handle;
{$IFC TempVtx}
				TempVtxFile: FSSpec;
{$ENDC}

			PROCEDURE AddNum(TheNum: Longint; TheLen: Integer);

				VAR
					temp: Str255;
					i, j: Integer;

				BEGIN
					j := length(prompt) + 1;
					NumToString(TheNum, temp);
					i := TheLen - length(temp);
					WHILE i > 0 DO
						BEGIN
						prompt[j] := ' ';
						j := j + 1;
						i := i - 1;
						END;
					FOR i := 1 TO length(temp) DO
						BEGIN
						prompt[j] := temp[i];
						j := j + 1;
						END;
					prompt[0] := chr(j - 1);
				END;

			PROCEDURE AddStr(temp: Str255);

				VAR
					i, j: Integer;

				BEGIN
					j := length(prompt) + 1;
					FOR i := 1 TO length(temp) DO
						BEGIN
						prompt[j] := temp[i];
						j := j + 1;
						END;
					prompt[0] := chr(j - 1);
				END;

			PROCEDURE AddChar(temp: Char);

			VAR
				j: Integer;

			BEGIN
				j := length(prompt) + 1;
				prompt[j] := temp;
				prompt[0] := chr(j);
			END;

			PROCEDURE WriteTemp;

			BEGIN
				IF CodeEnd - CodeStart > 0 THEN
				BEGIN
					CodeEnd := CodeEnd - CodeStart;
					SetDiskCache(FALSE);
					CheckWrite(FSWrite(CDRef, CodeEnd, Ptr(CodeStart)));
					SetDiskCache(TRUE);
					CodeEnd := CodeStart;
				END;
			END;

			FUNCTION GetFirstCodeName:Str255;
			
			VAR	TempStr: Str255;
					theID: INTEGER;
					theType: ResType;
					theRes: Handle;
					
			BEGIN
					TempStr := '';
					SetResLoad(FALSE);
					TheRes := GetResource(PreCompType,1);
					IF ResError=NoErr THEN GetResInfo(theRes,theID,theType,TempStr);
					ReleaseResource(theRes);
					SetResLoad(TRUE);
					GetFirstCodeName := TempStr;
			END;
			
			
			BEGIN	{ of CodeGen }
{$IFC Perf}
Err := InitPerf(thePerfGlobals,4,8,TRUE,TRUE,'CODE',0,'IIfxROM',FALSE,0,0,16);
IF PerfControl(thePerfGlobals, true) THEN;
{$ENDC}

				Stat := 0;
				NbCompCond := 0;	{ nombre de constantes de compil. conditionnelle }

{$IFC DEMO}
				NbDemoScreens := 0;
{$ENDC}

				FirstCodeName := CodeName;
				IF CodeName = '' THEN		{ précompil, où est le fichier précompilé ? }
				BEGIN
					typeList[0]:='PCOM';
(*
					IF gSystemVersion>=$700 THEN
					BEGIN
						StandardGetFile(NIL,1,typeList,NewReply);
						WITH NewReply.SFFile DO
						BEGIN
							Err:= OpenWD(vRefNum,parID,kProcID,reply.vRefNum);
							reply.fName := name;
							reply.good := NewReply.SFgood;
						END;
					END
					ELSE
*)
					BEGIN
						GetIndString(fName,262,56);
						ParamText(fName,'','','');
						SFPGetFile(CenterSF(putDlgID),'',NIL,1,@typeList,NIL,reply,500,NIL);
					END;
					IF NOT reply.good THEN EXIT(CodeGen);
					PreCompFile := OpenRFPerm(reply.Fname,reply.VRefnum,fsRdPerm);
					CurVol := ResError;
					CodeName := Reply.Fname;
					VolNum := reply.VRefnum;
					FirstCodeName := GetFirstCodeName;
					
					{ on vérifie si l'on est dans le dossier où se trouvent les modules à ajouter
						à la précompilation }
					GetIndString(fName,10000,1);
					IF fName<>'' THEN
					BEGIN
						err := GetFInfo(fName,reply.VRefnum,fndrInfo);
						IF err<>NoErr THEN
						BEGIN
							TypeList[0] := 'VCOD';
							GetIndString(fName,262,55);	{ Indiquez où se trouvent vos sources }
							ParamText(fName,'','','');
							SFPGetFile(CenterSF(500),'',NIL,1,@typeList,NIL,reply,500,NIL);
							IF reply.good THEN VolNum := reply.vRefNum;	{ voici l'endroit où se trouvent les sources }
						END;
					END;
				END
				ELSE PreCompFile := 0;	{ pas de fichier précompilé }
				
				GetIndString(prompt, 256, 4);
				fname := Concat('X-', CodeName);
				IF gSystemVersion >=$700 THEN
				BEGIN
					StandardPutFile(prompt,fname,NewReply);
					WITH NewReply.SFFile DO
					BEGIN
						Err:= OpenWD(vRefNum,parID,kProcID,FileDest.vRefNum);
						FileDest.fName := name;
						FileDest.good := NewReply.SFgood;
					END;
				END
				ELSE
					SFPutFile(CenterSF(putDlgID), prompt, fname, NIL, FileDest);
				
				IF FileDest.good THEN
				BEGIN
{$IFC Debug}
					DebugStr(';HS;G');
					CheckHandle := NewHandle(0);
{$ENDC}
					IF IncList THEN
					BEGIN
						{ suppression du fichier deja existant }
						fname := Concat(FileDest.fname, '.list');
						Err := FSDelete(fname, FileDest.vRefNum);
						IF (Err <> 0) AND (Err <> fnfErr) THEN ErrorManager(Err, 0);

						{ creation du fichier si celui-ci n'existe pas }
						Err := Create(fname, FileDest.vRefNum, 'MPS ', 'TEXT');
						IF (Err <> 0) AND (Err <> DupFNErr) THEN ErrorManager(Err, 1000);

						{ ouverture du fichier }
						TraceOpen(fname, FileDest.vRefNum, 'MPS ');
						{ entête de debug }
						GetDateTime(CurTime);
						IUDateString(CurTime, longDate, prompt);
						IUTimeString(CurTime, TRUE, prompt2);
						TraceStrLn(ParamMessage(2,CodeName,prompt,prompt2,''));
						TraceStrLn(ParamMessage(3,FileDest.fname,'','',''));
						TraceLn;
						TraceStrLn(GetMessage(4));
						IF IncLine THEN TraceStrLn(GetMessage(5));
						IF IncInst THEN TraceStrLn(GetMessage(6));
						IF IncCheck THEN TraceStrLn(GetMessage(7));
						TraceLn;
						TraceLn;
					END
				END
				ELSE EXIT(CodeGen);

				SetCursor(GetCursor(watchCursor)^^);	{ la montre… }
				
				StackUp := 0;
				StackSnif := 0;

				CurVol := VolNum;

				{ pool de noms de fichier }
				TheGScreen := HTgScreen(NewHandle(Sizeof(Integer) + Sizeof(TGScreen)));
				CheckMem;
				HLock(Handle(TheGScreen));
				WITH TheGScreen^^ DO
				BEGIN
					NbScreens := 1;
					WITH TheScreens[1] DO
					BEGIN
						NomScreen := NewString(FirstCodeName);
						OffsetCode := 0;
						OffsetVcode := 0;
						FlagProcessed := TRUE;
						FromScreen := 0;
					END;
				END;
				HUnlock(Handle(TheGScreen));
				
				NumCode := 1; { no ecran en cours }
				
				{ variables globales} {pool}
				TheGVars := HTbVar(NewHandle(Sizeof(Integer)));
				CheckMem;
				TheGVars^^.NbVars := 0;

				{ handle Table de variables locales} {local}
				TheCVars := HVarRes(NewHandle(0));
				CheckMem;
				HUnLock(Handle(TheCVars));

				{ handle du code 68000} {pool}
				CDFlag := TRUE;
				TheGCode := NewHandle(32767); {•••• 32Ko maxi de code pour un module ••••}
				MoveHHi(theGCode);

				CheckMem;
				MoveHHi(theGCode);
				HLock(TheGCode);
				CodeStart := Longint(StripAddress(TheGCode^));
				CodeEnd := CodeStart;

				{ handle du code VBasic} {local}
				TheCCode := TparamHandle(NewHandle(0));
				CheckMem;
				HLock(Handle(TheCCode));
				
				{ handle Table de constantes compactees} {pool}
				TheGCsts := NewHandleClear(2);
				CheckMem;

				{ handle Table de constantes en tableau} {local}
				TheCCsts := HCstRes(NewHandle(0));
				CheckMem;

				{ handle des indirections pour les constantes }
				TheICsts := HICstRes(NewHandleClear(4));
				CheckMem;

				{ handle Videotex } {pool}
				TheGVCode := NewHandle(0);
				CheckMem;

				{ sauvegarde des handles de Expr }
				XvarTab := VarTab;
				XcstTab := CstTab;
				VarTab := TheCVars;
				CstTab := TheCCsts;

				StackEt := HRecEt(NewHandle(SizeOf(TRecEt))); { pile etiquettes }
				CheckMem;
				MoveHHi(Handle(StackEt));
				Hlock(Handle(StackEt));
				
				StackWIF := HRecWIFet(NewHandle(SizeOf(TRecWIFEt))); { pile While/For/If }
				CheckMem;
				MoveHHi(Handle(StackWIF));
				HLock(Handle(StackWIF));
				
				vtxtRef := 0;
				vtxtSize := 0;
				
				IF CDFlag THEN
				BEGIN
					TempFile.Name := 'DragsterEdit.temp';
					IF BTst(GetGestaltResult(gestaltFindFolderAttr),gestaltFindFolderPresent) THEN	{ <7.0> }
						Err := FindFolder(kOnSystemDisk,kTemporaryFolderType,TRUE,TempFile.vRefNum,TempFile.ParID)
					ELSE
					BEGIN
						TempFile.vRefNum := 0;
						TempFile.ParID := 0;
					END;
					{ suppression ancien fichier temporaire }
					WITH TempFile DO Err := HDelete(vRefNum,ParID,Name);
					IF (Err <> 0) AND (Err <> fnfErr) THEN ErrorManager(Err, 0);
					{ creation du fichier si celui-ci n'existe pas }
					WITH TempFile DO Err := HCreate(vRefNum,ParID,Name, kCreator, kType);
					IF (Err <> 0) AND (Err <> DupFNErr) THEN ErrorManager(Err, 1000);
					{ ouverture du fichier }
					WITH TempFile DO Err := HOpen(vRefNum,ParID,Name,fsRdWrPerm, CDRef);
					IF (Err <> 0) THEN ErrorManager(Err, 1000);
					Err := SetEof(CDRef, 0);
					IF (Err <> 0) THEN ErrorManager(Err, 1000);

{$IFC TempVtx}
					TempVtxFile.Name := 'DragsterEdit.temp2';
					IF BTst(GetGestaltResult(gestaltFindFolderAttr),gestaltFindFolderPresent) THEN	{ <7.0> }
						Err := FindFolder(kOnSystemDisk,kTemporaryFolderType,TRUE,TempVtxFile.vRefNum,TempVtxFile.ParID)
					ELSE
					BEGIN
						TempVtxFile.vRefNum := 0;
						TempVtxFile.ParID := 0;
					END;
					{ suppression ancien fichier temporaire }
					WITH TempVtxFile DO Err := HDelete(vRefNum,ParID,Name);
					IF (Err <> 0) AND (Err <> fnfErr) THEN ErrorManager(Err, 0);
					{ creation du fichier si celui-ci n'existe pas }
					WITH TempVtxFile DO Err := HCreate(vRefNum,ParID,Name, kCreator, kType);
					IF (Err <> 0) AND (Err <> DupFNErr) THEN ErrorManager(Err, 1000);
					{ ouverture du fichier }
					WITH TempVtxFile DO Err := HOpen(vRefNum,ParID,Name,fsRdWrPerm, vtxtRef);
					IF (Err <> 0) THEN ErrorManager(Err, 1000);
					Err := SetEof(vtxtRef, 0);
					IF (Err <> 0) THEN ErrorManager(Err, 1000);
{$ENDC}
				END;

				GWarn := 0;
				NbExtUsed := 0;		{ •••• raz du nb de routines externes utilisées •••• }
				OffPC := 0;
				
				WWLnStr('');
				
				GetDateTime(StartTime);
				IUTimeString(StartTime, TRUE, prompt);
				WWLnStr(ParamMessage(8,Prompt,'','',''));

				compDlog := GetNewDialog(138+1000*longint(gSystemVersion<$700),NIL,Pointer(-1));
				IF compDlog<>NIL THEN
				BEGIN
					SetWRefCon(compDlog,512);
					CenterMovableDlog(compDlog,PosCompil.topLeft);
					DrawDialog(compDlog);
					GetDItem(compDlog,2,i,items[1],box);
					GetDItem(compDlog,3,i,items[2],box);
					GetDItem(compDlog,4,i,items[3],box);
					FOR i := 4 TO 10 DO items[i]:=NIL;
				END ELSE compDlog := NIL;
				
				REPEAT
					{ on charge le code }
					ErrFlag := false;
					Error := 0;

					{ mise à jour du dialogue de compil. }
					IF compDlog<>NIL THEN
					BEGIN
						IF items[1]<>NIL THEN SetIText(items[1],TheGScreen^^.TheScreens[NumCode].NomScreen^^);
						IF items[2]<>NIL THEN SetIText(items[2],NumToStr(NumCode));
						IF items[3]<>NIL THEN SetIText(items[3],concat(NumToStr(OffPC DIV 1024),' Ko'));
					END;
					
					LoadCode(NumCode, DirID);
					
					IF NOT ErrFlag THEN	{ pas d'erreur, on continue… }
					BEGIN
						{ reset du pc }
						Pc := 0;
						WriteTemp;
						Err := GetEof(CDRef, OffPc);
						PcFlag := false;
						runFlag := TRUE;
						traceFlag := false;
						NoMoreGen := TRUE;

						TheGScreen^^.TheScreens[NumCode].OffsetCode := OffPc;
						TheGScreen^^.TheScreens[NumCode].FlagProcessed := TRUE;
						
						RotateCursor(32);
						
						LWarn := 0;
						gCurCode := NumCode;
						{ et on se lance...}
						ListeXCute(TheCCode^);	{ génération du code }

						IF LWarn > 0 THEN
						BEGIN
							IF IncList THEN
							BEGIN
								TraceStr(GetMessage(9));
								TraceNLn(LWarn, 0, false);
								TraceLn;
							END;
							WWriteStr(GetMessage(9));
							WWlnNum(LWarn, 0);
							WWLnStr('');
						END;

						WHILE WaitNextEvent(EveryEvent, theEvent,0,NIL) DO
						CASE theEvent.What OF
							keyDown:
								BEGIN
									IF (BitAnd(TheEvent.Modifiers,CmdKey) <> 0)
									 & (BitAnd(TheEvent.Message,charCodeMask) = ORD(':'))
									THEN
									BEGIN
										ErrFlag := TRUE;
										Error := 0;
									END;
								END;
								
							OTHERWISE
								IF TheEvent.What<>nullEvent THEN HandleEvent(TheEvent);
						END;	{CASE}


						{recherche d'un autre code à compiler}
						IF NOT ErrFlag THEN
						BEGIN
							Hlock(Handle(TheGScreen));
							WITH TheGScreen^^ DO
							BEGIN
								NumCode := 0;
								WHILE (NumCode < NbScreens) AND NoMoreGen DO
									BEGIN
									NumCode := NumCode + 1;
									NoMoreGen := TheScreens[NumCode].FlagProcessed;
									END;
							END;
							HUnlock(Handle(TheGScreen));
						END;
					END;

(*
{$IFC DEMO}
				IF NbDemoScreens>=20 THEN
				BEGIN
					NoMoreGen := TRUE;	{ limitation à 20 sources non précompilés }
					WWLnStr('');
					WWLnStr(GetMessage(54));	{ compil. limitée à 20 modules en version de démo !!! }
					WWLnStr('');
					ErrFlag := TRUE;
				END;
{$ENDC}
*)
				UNTIL NoMoreGen OR ErrFlag;

				{ fermeture du dialogue de compilation }
				IF compDlog<>NIL THEN
				BEGIN
					PosCompil := WindowPeek(CompDlog)^.ContRgn^^.rgnBBox;
					DisposDialog(CompDlog);
					compDlog := NIL;
				END;
				
				IF PreCompFile<>0 THEN CloseResFile(PreCompFile);
				
				IF CDFlag THEN WriteTemp;

				runFlag := false;

				{ •• Vérification des dimensions des tableaux… •• }
				IF NOT ErrFlag THEN
				BEGIN
					HLock(Handle(TheGVars));
					WITH TheGVars^^ DO
						FOR i := 1 TO NbVars DO
							WITH Vars[i] DO
								IF (TpVar IN [finumvar, fistrvar]) & (DimVal=0) THEN
								BEGIN
									IF NOT ErrFlag THEN
									BEGIN
										WWLnStr('');
										SysBeep(60);
									END;
									WWlnStr(ParamMessage(10,NomVar,'','',''));
									ErrFlag := TRUE;
								END;
					HUnlock(Handle(TheGVars));
					IF ErrFlag THEN WWLnStr('');
				END;

				IF NOT ErrFlag THEN
					BEGIN { sauvegarde du resultat de la compilation }
					{ construction table des offsets }
					TheOffs := THOffScreen(NewHandle(TheGScreen^^.NbScreens * 8));
					CheckMem;
					Hlock(Handle(TheGScreen));
					WITH TheGScreen^^ DO
						FOR i := 1 TO NbScreens DO
						BEGIN
							TheOffs^^[i-1].OffCode := TheScreens[i].OffsetCode;
							TheOffs^^[i-1].OffVCode := TheScreens[i].OffsetVcode;
						END;
					HUnlock(Handle(TheGScreen));

					{ construction table des noms d'ecran }
					TheSNames := NewHandle(0);
					CheckMem;
					HLock(Handle(TheSNames));
					IF IncList THEN
						BEGIN
						{ rappel des modules et des tailles }
						TraceLn;
						TraceStr(GetMessage(11));
						TraceN(TheGScreen^^.NbScreens, 0, false);
						TraceLn;
						TraceLn;
						TraceStrLn(GetMessage(12));
						TraceLn;
					END;

					FOR i := 1 TO TheGScreen^^.NbScreens DO
					BEGIN
						OffMax := GetHandleSize(TheSNames);
						OffCode := OffMax;
						OffMax := OffMax + length(TheGScreen^^.TheScreens[i].NomScreen^^)+1;
						IF Odd(OffMax) THEN
							OffMax := OffMax+1;
						SetHSize(TheSNames, OffMax);
						{ raz de l'octet d'alignement à 0 }
						p:=Ptr(Ord4(TheSNames^)+OffMax-1);
						p^:=0;
						
						BlockMoveData(Ptr(Ord4(TheGScreen^^.TheScreens[i].NomScreen^)),
											Ptr(Ord4(TheSNames^) + OffCode),
											length(TheGScreen^^.TheScreens[i].NomScreen^^) + 1);
							
						IF IncList THEN
						BEGIN
							TraceN(i, 4, TRUE);
							TraceStr(' ');
							TraceHN(TheGScreen^^.TheScreens[i].OffsetCode, 6, TRUE);
							TraceStr(' "');
							TraceStr(TheGScreen^^.TheScreens[i].NomScreen^^);
							TraceStrLn('"');
						END;
					END;
					i := 0;
					Err := PtrAndHand(@i, TheSNames, 2);
					CheckMem;

					IF IncList THEN
					BEGIN
						TraceLn;
						TraceLn;
					END;

					WITH TheXConf DO
					BEGIN
						{ evaluation de la place necessaire aux variables }
						SzSVars := 0;
						SzVars := 0;
						HLock(Handle(TheGVars));
						WITH TheGVars^^ DO
							FOR i := 1 TO NbVars DO
								IF Vars[i].Shared THEN
									SzSVars := SzSVars + Vars[i].SizeVar
								ELSE
									SzVars := SzVars + Vars[i].SizeVar;
						HUnlock(Handle(TheGVars));
						
						SzNameScreen := GetHandleSize(Handle(TheSNames));
						SzOffScreen := GetHandleSize(Handle(TheOffs));
						SzStringCsts := GetHandleSize(Handle(TheGCsts));
						IF vtxtRef=0 THEN
							SzVCode := GetHandleSize(Handle(TheGVCode))
						ELSE
							SzVCode := vtxtSize;
						IF CDFlag THEN
							Err := GetEof(CDRef, SzCode)
						ELSE
							SzCode := GetHandleSize(Handle(TheGCode));

						SzStack := StackUp + 2048 + TheGScreen^^.NbScreens * 10;
					END;

					IF IncList THEN
					BEGIN
						TraceStrLn(GetMessage(13));
						TraceLn;
						IF GWarn > 0 THEN
						BEGIN
							TraceStr(GetMessage(14));
							TraceNLn(GWarn, 0, false);
							TraceLn;
						END;
						TraceStr(GetMessage(15));
						TraceNLn(TheXConf.SzCode, 0, false);
						TraceStr(GetMessage(16));
						TraceNLn(TheXConf.SzVCode, 0, false);
						TraceStr(GetMessage(17));
						TraceNLn(GetHandleSize(Handle(TheGCsts)), 0, false);
						TraceStr(GetMessage(18));
						TraceNLn(TheXConf.SzSVars, 0, false);
						TraceStr(GetMessage(19));
						TraceNLn(TheXConf.SzVars, 0, false);
						TraceStr(GetMessage(20));
						TraceNLn(TheXConf.SzStack, 0, false);
						TraceLn;
						TraceStr(GetMessage(21));
						TraceNLn(TheGScreen^^.NbScreens, 0, false);
						TraceStr(GetMessage(22));
						TraceNLn(TheGVars^^.NbVars, 0, false);
						TraceLn;
						TraceLn;
					END;

					WWLnStr('');
					WWLnStr('');

					IF GWarn > 0 THEN
					BEGIN
						WWriteStr(GetMessage(14));
						WWlnNum(GWarn, 0);
						WWLnStr('');
					END;

					WWriteStr(GetMessage(15));
					WWlnNum(TheXConf.SzCode, 0);
					WWriteStr(GetMessage(16));
					WWlnNum(TheXConf.SzVCode, 0);
					WWriteStr(GetMessage(17));
					WWlnNum(GetHandleSize(Handle(TheGCsts)), 0);
					WWriteStr(GetMessage(18));
					WWlnNum(TheXConf.SzSVars, 0);
					WWriteStr(GetMessage(19));
					WWlnNum(TheXConf.SzVars, 0);
					WWriteStr(GetMessage(20));
					WWlnNum(TheXConf.SzStack, 0);
					WWLnStr('');
					WWriteStr(GetMessage(21));
					WWlnNum(TheGScreen^^.NbScreens, 0);
					WWriteStr(GetMessage(22));
					WWlnNum(TheGVars^^.NbVars, 0);

					IF NbExtUsed > 0 THEN
					BEGIN
						WWriteStr(GetMessage(23));
						WWlnNum(NbExtUsed, 0);
					END;

					WWLnStr('');
					IF CLVarFlag THEN
						BEGIN
						WWLnStr(GetMessage(24));
						WWLnStr('');
						HLock(Handle(TheGVars));
						WITH TheGVars^^ DO
							FOR i := 1 TO NbVars DO
								WITH Vars[i] DO
									BEGIN
									IF Shared THEN
										WWriteStr('S  ')
									ELSE
										WWriteStr('P  ');
									WWriteStr(NomVar);
									IF (TpVar IN [finumvar, fistrvar]) THEN
										WWlnNum(DimVal, 30 - length(NomVar))
									ELSE
										WWLnStr('');
									END;
						WWLnStr('');
						END;
						HUnlock(Handle(TheGVars));
						
					{ suppression du fichier deja existant }
					Err := FSDelete(FileDest.fname, FileDest.vRefNum);
					IF (Err <> 0) AND (Err <> fnfErr) THEN
						ErrorManager(Err, 0);

					{ creation du fichier si celui-ci n'existe pas }
{$IFC DEMO=FALSE}
					IF NbExtUsed > 0 THEN
						Err := Create(FileDest.fname, FileDest.vRefNum, kCreatorbis, kType)
					ELSE
						Err := Create(FileDest.fname, FileDest.vRefNum, kCreator, kType);
{$ELSEC}
					Err := Create(FileDest.fname, FileDest.vRefNum, kCreatorDemo, kTypeDemo);
{$ENDC}

					IF (Err <> 0) AND (Err <> DupFNErr) THEN ErrorManager(Err, 1000);

					{ ouverture du fichier }
					SetDiskCache(FALSE);
					Err := FSOpen(FileDest.fname, FileDest.vRefNum, RefW);
					OffCode := Sizeof(TheXConf);
					Err := FSWrite(RefW, OffCode, @TheXConf);
					OffCode := GetHandleSize(Handle(TheOffs));
					Err := FSWrite(RefW, OffCode, Ptr(Ord4(TheOffs^)));
					OffCode := GetHandleSize(Handle(TheSNames));
					Err := FSWrite(RefW, OffCode, Ptr(Ord4(TheSNames^)));
					OffCode := GetHandleSize(Handle(TheGCsts));
					Err := FSWrite(RefW, OffCode, Ptr(Ord4(TheGCsts^)));
					OffCode := TheXConf.SzVCode;
					IF vtxtRef=0 THEN
						Err := FSWrite(RefW, OffCode, Ptr(Ord4(TheGVCode^)))
					ELSE
					BEGIN		{ recopie fic. temporaire codes vidéotex }
						Err := SetFPos(vtxtRef,fsFromStart,0);
						REPEAT
							OffCode := GetHandleSize(TheGCode); { 32Ko par 32Ko }
							Err := FSRead(vtxtRef, OffCode, Ptr(Ord4(TheGCode^)));
							IF offCode>0 THEN Err := FSWrite(RefW,OffCode, Ptr(Ord4(TheGCode^)));
							RotateCursor(32);
							WHILE WaitNextEvent(EveryEvent, theEvent,0,NIL) DO HandleEvent(TheEvent);
						UNTIL (offCode=0) | (Err<>NoErr);
					END;
					
					IF CDFlag THEN
					BEGIN
						CheckMem;
						Err := SetFPos(CDRef, fsFromStart, 0);
						REPEAT
							OffCode := GetHandleSize(TheGCode); { 32Ko par 32Ko }
							Err := FSRead(CDRef, OffCode, Ptr(Ord4(TheGCode^)));
							IF OffCode > 0 THEN CheckWrite(FSWrite(RefW, OffCode, Ptr(Ord4(TheGCode^))));
							RotateCursor(32);
							WHILE WaitNextEvent(EveryEvent, theEvent,0,NIL) DO HandleEvent(TheEvent);
						UNTIL (OffCode=0) | (Err<>NoErr);
					END
					ELSE
					BEGIN
						OffCode := GetHandleSize(Handle(TheGCode));
						CheckWrite(FSWrite(RefW, OffCode, Ptr(Ord4(TheGCode^))));
					END;
					
					SetDiskCache(TRUE);		{ on remet le cache… }
					Err := FSClose(RefW);
					
					CreateResFile(concat(PathNameFromWD(FileDest.vRefNum),FileDest.fname));
					RefW := OpenRFPerm(FileDest.fname, FileDest.vRefNum,fsRdWrPerm);

					{ •••• on recopie les routines externes utilisées •••• }
					{ •••• et la liste des routines utilisées •••• }
					
					IF NbExtUsed > 0 THEN
					BEGIN
						TheExtList := NewHandle(2);
						BlockMoveData(@NbExtUsed,TheExtList^,2);
						CurExt := 2;
						IF IncList THEN
						BEGIN
							TraceStrLn(GetMessage(25));
							TraceLn;
						END;
						FOR i := 1 TO NbExtUsed DO
						BEGIN
							LoadResource(Mots^^[ExtUsed[i]].TheResC);
							HLock(Mots^^[ExtUsed[i]].TheResC);
							TheExt := Mots^^[ExtUsed[i]].TheResC;
							Err := HandToHand(TheExt);
							HLock(TheExt);
							GetResInfo(Mots^^[ExtUsed[i]].TheResC,TheExtID, TheExtType, TheExtName);
							HUnLock(Mots^^[ExtUsed[i]].TheResC);
							HPurge(Mots^^[ExtUsed[i]].TheResC);
							AddResource (TheExt, TheExtType,i,TheExtName);
							HPurge(TheExt);
							SetHSize(TheExtList,CurExt+Length(TheExtName)+1);
							BlockMoveData(@TheExtName[0],Ptr(ORD4(TheExtList^)+CurExt),Length(TheExtName)+1);
							CurExt := CurExt+Length(TheExtName)+1;
							IF IncList THEN TraceStrLn(TheExtName);
						END;
						UseResFile(RefW);
						AddResource(TheExtList, 'STR#', 128,'Liste des externes');
						WriteResource(TheExtList);
						HUnlock(TheExtList);
						ReleaseResource(TheExtList);
						
						{ on sauve l'entrée dans la JumpTable de la 1ère Rout. Externe }
						theExtJump := NewHandle(2);	
						IPtr(theExtJump^)^:=NbTokens+2-OffRT;
						AddResource(theExtJump,'EXJT',128,'');
						WriteResource(TheExtJump);
						HUnlock(TheExtJump);
						ReleaseResource(TheExtJump);
						
						IF IncList THEN TraceLn;
					END;
					
					{ on enregistre la liste des modules présents dans la compil }
					L:=SizeOf(INTEGER);
					TheExtList := NewHandle(L);
					n := 0;
					FOR i := 1 TO TheGScreen^^.NbScreens DO
					BEGIN
						SetHSize(TheExtList,L+Length(TheGScreen^^.TheScreens[i].NomScreen^^)+1);
						BlockMoveData(@TheGScreen^^.TheScreens[i].NomScreen^^[0],Ptr(ORD4(TheExtList^)+L),Length(TheGScreen^^.TheScreens[i].NomScreen^^)+1);
						L := GetHandleSize(TheExtList);
						n := n + 1;
					END;
					BlockMoveData(@n,TheExtList^,2);
					AddResource(TheExtList, 'STR#', 10001,'Liste des modules');
					WriteResource(TheExtList);
					HUnlock(TheExtList);
					ReleaseResource(TheExtList);

					{ création nouvelle ressource DATE }
					GetDateTime(L);
					CreateDateResource(RefW, L);
					
					CloseResFile(RefW);		{ on a fini avec les ressources }


					IF CMVarFlag THEN
						BEGIN
						WWLnStr(GetMessage(26));
						fname := Concat(FileDest.fname, '.map');
						Err := FSDelete(fname, FileDest.vRefNum);
						IF (Err <> 0) AND (Err <> fnfErr) THEN ErrorManager(Err, 0);
							
						{ creation du fichier si celui-ci n'existe pas }
						Err := Create(fname, FileDest.vRefNum, 'MPS ', 'TEXT');
						IF (Err <> 0) AND (Err <> DupFNErr) THEN ErrorManager(Err, 1000);
						
						{ ouverture du fichier }
						Err := FSOpen(fname, FileDest.vRefNum, RefW);

						HLock(Handle(TheGVars));
						WITH TheGVars^^ DO
						BEGIN
							IF IncList THEN
							BEGIN
								TraceStrLn(GetMessage(27));
								TraceLn;
							END;
							FOR i := 1 TO NbVars DO
								WITH Vars[i] DO
								BEGIN
									prompt := '';
									IF Shared THEN
										AddStr('  S  ')
									ELSE
										AddStr('  P  ');
									AddStr(NomVar);
									IF (TpVar IN [finumvar, fistrvar]) THEN
										AddNum(DimVal, 30 - length(NomVar))
									ELSE
										AddNum(1, 30 - length(NomVar));
									AddNum(OffsetVar, 9);
									AddNum(SizeVar, 9);
									AddChar(chr(13));
									OffCode := length(prompt);
									Err := FSWrite(RefW, OffCode, Ptr(Ord4(@prompt) + 1));
									IF IncList THEN
									BEGIN
										IF Shared THEN
											TraceStr('S  ')
										ELSE
											TraceStr('P  ');
										TraceStr(NomVar);
										IF (TpVar IN [finumvar, fistrvar]) THEN
											TraceN(DimVal, 30 - length(NomVar), false)
										ELSE
											TraceN(1, 30 - length(NomVar), false);
										TraceStr('   ');
										TraceHN(OffsetVar, 6, TRUE);
										TraceNLn(SizeVar, 7, false);
									END;
								END;
							IF IncList THEN
							BEGIN
								TraceLn;
								TraceLn;
							END;
						END;
						HUnlock(Handle(TheGVars));
						
						Err := FSClose(RefW);
					END;
					
					IF (Err <> 0) THEN ErrorManager(Err, 1000);

					DisposHandle(Handle(TheOffs));
					DisposHandle(Handle(TheSNames));

					END
				ELSE { IF Not ErrFlag }
					IF Err <> NoErr THEN
					BEGIN
					{ Erreur de compilation }
					WWLnStr('');
					WWLnStr(ParamMessage(28,TheGScreen^^.TheScreens[NumCode].NomScreen^^,'','',''));
					WWLnStr('');
					END;

				CodeGen := Error;

				IF IncList THEN	{ fermeture du listing de compil. }
				BEGIN
					TraceClose;
					IF ErrFlag & (Error=0) THEN
					BEGIN
						{ suppression du listing de compil si on a stoppé la compil. }
						fname := Concat(FileDest.fname, '.list');
						Err := FSDelete(fname, FileDest.vRefNum);
					END;
				END;

				{ •••• on ferme le fichier '.tmp' après compil •••• }

				IF CDFlag THEN
				BEGIN
					Err := FSClose(CDRef);
					IF (Err <> 0) THEN ErrorManager(Err, 0);
					{ suppression du fichier temporaire }
					WITH TempFile DO Err := HDelete(vRefNum,ParID,Name);
					IF (Err <> 0) AND (Err <> fnfErr) THEN ErrorManager(Err, 0);

{$IFC TempVtx}
					IF vtxtRef<>0 THEN
					BEGIN
						Err := FSClose(vtxtRef);
						IF (Err <> 0) THEN ErrorManager(Err, 0);
						{ suppression du fichier temporaire }
						WITH TempVtxFile DO Err := HDelete(vRefNum,ParID,Name);
						IF (Err <> 0) AND (Err <> fnfErr) THEN ErrorManager(Err, 0);
					END;
{$ENDC}
				END;

				{ restore des handles de Expr }
				VarTab := XvarTab;
				CstTab := XcstTab;

				Hlock(Handle(TheGScreen));
				WITH TheGScreen^^ DO
					FOR i := 1 TO NbScreens DO
					BEGIN
						DisposHandle(Handle(TheScreens[i].NomScreen));
					END;
				HUnlock(Handle(TheGScreen));
				
				HUnlock(Handle(TheGVars));
				HUnlock(Handle(TheCVars));
				HUnlock(Handle(TheGCode));
				HUnlock(Handle(TheCCode));
				HUnlock(Handle(TheGCsts));
				HUnlock(Handle(TheCCsts));
				HUnlock(Handle(TheICsts));
				HUnlock(Handle(TheGVCode));
				HUnlock(Handle(StackEt));
				HUnlock(Handle(StackWIF));

				DisposHandle(Handle(TheGScreen));
				DisposHandle(Handle(TheGVars));
				DisposHandle(Handle(TheCVars));
				DisposHandle(Handle(TheGCode));
				DisposHandle(Handle(TheCCode));
				DisposHandle(Handle(TheGCsts));
				DisposHandle(Handle(TheCCsts));
				DisposHandle(Handle(TheICsts));
				DisposHandle(Handle(TheGVCode));
				DisposHandle(Handle(StackEt));
				DisposHandle(Handle(StackWIF));

				WWLnStr('');
				GetDateTime(EndTime);
				IUTimeString(EndTime, TRUE, Prompt);
				IF NOT ErrFlag THEN
					Chaine := GetMessage(29)
				ELSE
					Chaine := GetMessage(30);
				ParamStr(Chaine,Prompt,'','','');
				WWLnStr(Chaine);

				Err := FlushVol(NIL, FileDest.vRefNum);

				IF gSystemVersion>=$700 THEN
				BEGIN
					Err:= CloseWD(reply.vRefNum);
					Err:= CloseWD(fileDest.vRefNum);
				END;
				
				WWriteStr(GetMessage(31));
				WWLnNum(Stat,0);

{$IFC Perf}
Err := PerfDump(thePerfGlobals, 'Perform.out', true, 100);
TermPerf(thePerfGlobals);
{$ENDC}
			
			END;	{ CodeGen }

		PROCEDURE CheckMem;

			BEGIN
				IF MemError <> NoErr THEN
					BEGIN
					WWLnStr('');
					WWLnStr('');
					WWLnStr(GetMessage(32));
					WWLnStr('');
					IF IncList THEN
						BEGIN
						TraceLn;
						TraceLn;
						TraceStrLn(GetMessage(32));
						TraceLn;
						END;
					ErrFlag := TRUE;
					Error := MemError;
					END;
			END;

		PROCEDURE ErrorManager(Error: OsErr; from: Integer);

			CONST
				Debug = false;

			VAR
				temp: Integer;
				monDialog: DialogPtr;
				ErrorStr, TempS: Str255;

			BEGIN
				CASE Error OF
					-1:	GetIndString(ErrorStr,257,34);
					DirFulErr: GetIndString(ErrorStr, 257, 1);
					DskFulErr: GetIndString(ErrorStr, 257, 2);
					WPrErr: GetIndString(ErrorStr, 257, 3);
					OTHERWISE
					BEGIN
						NumToString(Error, TempS);
						GetIndString(ErrorStr, 257, 4);
						ErrorStr := Concat(ErrorStr, ' ', TempS);
					END;
				END;
				ParamText(ErrorStr, '', '', '');
				monDialog := GetNewDialog(257, NIL, POINTER( - 1));
				IF MonDialog<>NIL THEN
				BEGIN
					CenterDlog(monDialog);
					REPEAT
						ModalDialog(NIL, temp);
					UNTIL temp = 1;
					DisposDialog(monDialog);
				END
				ELSE
				BEGIN
					WWLnStr('');
					WWLnStr(ErrorStr);
				END;
			END;

		PROCEDURE StackEval(Offset: Integer);

			BEGIN
				StackSnif := StackSnif + Offset;
				IF StackSnif > StackUp THEN StackUp := StackSnif;
			END;

		PROCEDURE CheckPc;	

			BEGIN
				IF (Pc > 32760) & (ErrFlag=FALSE) THEN
				BEGIN
					ErrFlag := TRUE;
					Error := - 1;			{ code généré trop long !! }
					ErrorManager(-1,0);
				END;
			END;

{$IFC Debug}
	PROCEDURE MyCheck;
	
	BEGIN
		DebugStr(';hc;g');
	END;
{$ENDC}	

	PROCEDURE CheckInstLine;
	{ inclusion des numéros de lignes et d'instruction }
	{ le code de mise à jour de ces données n'est généré
		qu'au moment de générer du code pour une instruction
		de cette manière on évite de générer ce code pour
		des instructions ne générant pas de code… }
		
	BEGIN
		IF LastLine<>NL THEN	{ on a changé de ligne }
		BEGIN
			LastLine := NL;
			LastInst := NInst;
			AddCode1($397C);			{ move.w #nl,TheNLCst(A4) }
			AddCode2(NL,TheNLCst);
			IF IncInst THEN
			BEGIN
				AddCode1($397C);
				AddCode2(NInst,TheNiCst);
			END;
			EXIT(CheckInstLine);
		END;
		
		IF IncInst & (LastInst<>NInst) THEN
		BEGIN
			LastInst := NInst;
			{ code de numero d'instruction }
			{ on met le code de mise a jour d'instruction }
			AddCode1($397C); 		{ move.w #ninst,TheNInst(A4) }
			AddCode2(NInst, TheNICst);
		END;
	END;

	
	PROCEDURE AddCode1(Val: Integer);

	BEGIN
		IF CompFlag>0 THEN EXIT(AddCode1);
{$IFC DEMO}
		Val := BXor(Val,$1405);
{$ENDC}

{$IFC Debug}
		MyCheck;
{$ENDC}
		IF IncLine THEN CheckInstLine;
		IPtr(CodeEnd)^ := Val;
		CodeEnd := CodeEnd + 2;
		Pc := Pc + 2;
		CheckPc;
	END;

PROCEDURE AddCode2(Val1, Val2: Integer);

BEGIN
	IF CompFlag>0 THEN EXIT(AddCode2);
{$IFC DEMO}
	Val1 := BXor(Val1,$1405);
	Val2 := BXor(Val2,$1405);
{$ENDC}
{$IFC Debug}
	MyCheck;
{$ENDC}
	IF IncLine THEN CheckInstLine;
	IPtr(CodeEnd)^ := Val1;
	CodeEnd := CodeEnd + 2;
	IPtr(CodeEnd)^ := Val2;
	CodeEnd := CodeEnd + 2;
	Pc := Pc + 4;
	CheckPc;
END;

PROCEDURE AddCode3(Val1: Integer; Val2: Longint);

BEGIN
	IF CompFlag>0 THEN EXIT(AddCode3);		{ pas de génération de code dans les TRACEBEGIN/TRACEEND }
{$IFC DEMO}
	Val1 := BXor(Val1,$1405);
	Val2 := BXor(Val2,$14051405);
{$ENDC}
{$IFC Debug}
	MyCheck;
{$ENDC}
	IF IncLine THEN CheckInstLine;
	IPtr(CodeEnd)^ := Val1;
	CodeEnd := CodeEnd + 2;
	LPtr(CodeEnd)^ := Val2;
	CodeEnd := CodeEnd + 4;
	Pc := Pc + 6;
	CheckPc;
END;


PROCEDURE AddCodeL(Val: Longint);

BEGIN
	IF CompFlag>0 THEN EXIT(AddCodeL);		{ pas de génération de code dans les TRACEBEGIN/TRACEEND }
{$IFC DEMO}
	Val := BXor(Val,$14051405);
{$ENDC}
{$IFC Debug}
	MyCheck;
{$ENDC}
	LPtr(CodeEnd)^ := Val;
	CodeEnd := CodeEnd + 4;
	Pc := Pc + 4;
	CheckPc;
END;


FUNCTION PeekCode(Offset: Integer): Integer;

VAR	k: INTEGER;

	BEGIN
{$IFC DEMO}
		PeekCode := BXor(IPtr(Ord4(CodeStart) + Offset)^,$1405);
{$ELSEC}
		PeekCode := IPtr(Ord4(CodeStart) + Offset)^;
{$ENDC}
	END;

PROCEDURE PokeCode(Offset, ThePatch: Integer);

VAR
	ThePtr: IPtr;
	k: INTEGER;

BEGIN
	ThePtr := IPtr(Ord4(CodeStart) + Offset);
{$IFC DEMO}
	ThePtr^ := BXor(thePatch,$1405);
{$ELSEC}
	ThePtr^ := ThePatch;
{$ENDC}
END;

PROCEDURE NewEtiq(Defined: Boolean;
									Offset: Integer);

	BEGIN { creation d'une etiquette }
		NumEtiq := NumEtiq + 1;
		{$IFC GenAsm}
		IF FlagCC THEN WriteLn('%XX/', NumEtiq: 1);
		{$ENDC}
		
		WITH StackEt^^[NumEtiq] DO
			BEGIN
			FlagDefined := Defined;
			LastOffset := Offset;
			END;
	END;

PROCEDURE NewWIF(tp: Integer);

	BEGIN { creation d'une etiquette }
		NumWIF := NumWIF + 1;
		StackWIF^^[NumWIF].tpRec := tp;
	END;

PROCEDURE SubWIF;

	BEGIN { destruction d'une etiquette }
		NumWIF := NumWIF - 1;
	END;

PROCEDURE DefEtiq(TheEtiq, TheOffset: Integer);

	VAR
		xoffset: Integer;
		Err: OsErr;

	BEGIN { definition d'une etiquette }
		{$IFC GenAsm}
		IF FlagCC THEN WriteLn('; Definition Etiquette ', TheEtiq);
		{$ENDC}
		WITH StackEt^^[TheEtiq] DO
			BEGIN
			FlagDefined := TRUE;
			xoffset := LastOffset;
			WHILE xoffset <> 0 DO
				BEGIN
				{$IFC GenAsm}
				IF FlagCC THEN WriteLn('; Remise a jour appel etiquette');
				{$ENDC}
				LastOffset := PeekCode(xoffset);
				PokeCode(xoffset, TheOffset - xoffset);
				xoffset := LastOffset;
				END;
			LastOffset := TheOffset;
			END;
	END;

PROCEDURE UseEtiq(TheEtiq: Integer; OffCode: Integer);

	BEGIN
		{$IFC GenAsm}
		IF FlagCC THEN WriteLn('; Utilisation etiquette ', TheEtiq);
		{$ENDC}
		WITH StackEt^^[TheEtiq] DO
			BEGIN
			IF FlagDefined THEN
				PokeCode(OffCode, LastOffset - OffCode)
			ELSE
				BEGIN
				PokeCode(OffCode, LastOffset);
				LastOffset := OffCode;
				END;
			END;
	END;

PROCEDURE BranchEtiq(theEtiq: INTEGER; BranchCode: INTEGER);

VAR	off:INTEGER;

BEGIN
	AddCode2(BranchCode,0);
	UseEtiq(theEtiq,pc-2);
END;


PROCEDURE UseCst(i:INTEGER);

VAR
	OffMax, OffCode: LONGINT;
	
BEGIN
	IF TheICsts^^[i]=-1 THEN
	BEGIN
		OffCode := GetHandleSize(TheGCsts);
		OffMax := OffCode + length(TheCCsts^^[i]) + 1;
		IF Odd(OffMax) THEN OffMax := OffMax + 1;
		SetHSize(TheGCsts, OffMax);
		{ raz de l'octet d'alignement }
		p:=Ptr(Ord4(TheGCsts^)+OffMax-1);
		p^:=0;
		BlockMoveData(Ptr(Ord4(@TheCCsts^^[i])), Ptr(Longint(StripAddress(TheGCsts^)) + OffCode),length(TheCCsts^^[i]) + 1);
		TheICsts^^[i]:=OffCode;	{ voici l'offset de cette constante }
	END;
END;

PROCEDURE LoadCode(NumCC: Integer; DirID:LONGINT);

	LABEL 0;	{ beurk !!! }
	
	VAR
		count: Longint;
		Err: OsErr;
		RefW: Integer;
		OffMax, OffCode, lgtext: Longint;
		NbVar, NbCst, LgCode: Integer;
		Vlg: Longint;
		Trouve: Boolean;
		TheStr: Pstr255;
		Numvar, i: Integer;
		e: TParamPtr;
		L,L2: Longint;
		theTOKNRes: Handle;
		theVCODRes: Handle;
		key: INTEGER;
		Loaded: BOOLEAN;
		gCurScreen: Str255;
		infos: FInfo;
		
		
		PROCEDURE MsgBadType;
		
		BEGIN
			WWLnStr('');
			WWLnStr(ParamMessage(42,gCurScreen,'','',''));
			ErrFlag:=TRUE;
			EXIT(LoadCode);
		END;

BEGIN
		gCurScreen := TheGScreen^^.TheScreens[numCC].NomScreen^^;
		
		Loaded := FALSE;
		PreCompFlag := FALSE;
		
		IF IncList THEN
		BEGIN
			TraceLn;
			TraceStr(GetMessage(33));
			TraceN(NumCC, 4, TRUE);
			TraceStr(': "');
			TraceStr(gCurScreen);
			TraceStrLn('"');
		END;
		
		NumEtiq := 0;
		NumWIF := 0;

		NumCode := NumCC;
		IF NamesFlag THEN
			WWLnStr(gCurScreen)
		ELSE
		BEGIN
			IF compDlog=NIL THEN
			BEGIN
				WWriteStr('.');
				IF NumCC MOD 50 = 0 THEN WWLnStr('');
			END;
		END;
		
		{ on regarde si le fichier source est là… }
		Err := HGetFInfo(CurVol,DirId,gCurScreen,infos);
		IF Err<>NoErr THEN Err := GetFInfo(gCurScreen,0,infos);

		{ source introuvable, on prend la version précompilée }
		IF ((Err<>NoErr) | PreCompOverRide) & (PreCompFile <> 0) THEN
		BEGIN
			theTOKNRes := GetNamedResource(PreCompType,gCurScreen);
			
			IF ResError = NoErr THEN
			BEGIN		{ •••• cet écran est précompilé •••• }
				Loaded := TRUE;
				precompFlag := TRUE;
				
				HLock(theTOKNRes);
				
				{ •• Chargement du code vidéotex •• }
				theVCODRes := GetNamedResource('VCOD',gCurScreen);
				IF (ResError=NoErr) & (theVCODRes<>NIL) THEN
				BEGIN
					HLock(theVCODRes);
					Vlg := SizeResource(theVCODRes);
					IF Vlg=1 THEN Vlg := 0;	{ écran vide ! }
{$IFC TempVtx=FALSE}
					OffCode := GetHandleSize(TheGVCode);
					TheGScreen^^.TheScreens[NumCode].OffsetVcode := OffCode;
					IF Odd(Vlg) THEN {on aligne}
					BEGIN
						SetHSize(TheGVCode, GetHandleSize(TheGVCode) + 4 + Vlg + 1);
						{ raz de l'octet d'alignement }
						p:=Ptr(Ord4(TheGVCode^)+OffCode+4+Vlg);
						p^:=0;
					END
					ELSE
						SetHSize(TheGVCode, GetHandleSize(TheGVCode) + 4 + Vlg);
			
					{ on mémorise la longueur de la page }
					HLock(Handle(TheGVCode));
					OffCode := Ord4(StripAddress(Ptr(TheGVCode^))) + OffCode;
					LPtr(OffCode)^ := Vlg;
			
					{ on mémorise la page vidéotex }
					IF Vlg> 0 THEN BlockMoveData(theVCODRes^,Ptr(OffCode + 4),Vlg);
{$ELSEC}
					{ on enregistre la longueur de la page }
					L := SizeOf(LONGINT);
					Err := FSWrite(vtxtRef,L,@Vlg);
					vtxtSize := vtxtSize + L;
					IF Vlg>0 THEN
					BEGIN
						L := Vlg;
						Err := FSWrite(vtxtRef,L,theVCodRes^);
						vtxtSize := vtxtSize + L;
						IF odd(Vlg) THEN
						BEGIN
							L := 1;
							Vlg := 0;
							Err := FSWrite(vtxtRef,L,@Vlg);
							vtxtSize := vtxtSize + L;
						END;
					END;
{$ENDC}

					HUnlock(theVCODRes);
					ReleaseResource(theVCODRes);
					HUnlock(Handle(TheGVCode));
				END;
				
				{ •• Décodage de la resource TOKN •• }
				L := SizeResource(theTOKNRes);
				Count := 0;
				WITH dataH(theTOKNRes)^^ DO
				BEGIN
					key := BXOR(BAND($000000FF,L),BXOR($d3,TOKNh(theTOKNRes)^^.KeyTOKN));
					REPEAT
						Info[count] := CHR(BXOR(255-ORD(Info[count]),key));
						Count := Count+1;
					UNTIL Count >= L;
				END;
				
				L := ORD4(StripAddress(Ptr(ORD4(theTOKNRes^)+SizeOf(TOKNRec))));
				
				{ •• Chargement table des Variables •• }
				NbVar := TOKNh(theTOKNRes)^^.NbVars;	{ taille de la table }
				count := Sizeof(TVar) * Longint(NbVar);
				SetHSize(Handle(TheCVars), count);
				IF Count<>0 THEN BlockMoveData(Ptr(L),Ptr(TheCVars^),count);
				L := L+count;
				
				{ •• Chargement table des constantes •• }
				
				NbCst := TOKNh(theTOKNRes)^^.NbCst;	{ utilisé plus loin }
				count := Sizeof(Str64) * Longint(NbCst);
				SetHSize(Handle(TheCCsts), count);
				SetHSize(Handle(TheICsts), Sizeof(Longint) * Longint(NbCst));
				
				HLock(Handle(TheGCsts));
				FOR i := 1 TO NbCst DO
				BEGIN
					{ Recherche d'une constante equivalente }
					OffMax := GetHandleSize(TheGCsts);
					OffCode := 0;
					Trouve := false;
					L2 := Ord4(StripAddress(Ptr(TheGCsts^)));
					WHILE (OffCode < OffMax) & (NOT Trouve) DO
					BEGIN
						TheStr := Pstr255(L2 + OffCode);
						Trouve := (TheStr^ = PStr255(L)^);
						IF NOT Trouve THEN
						BEGIN
							OffCode := OffCode + length(TheStr^) + 1;
							IF Odd(OffCode) THEN OffCode := OffCode + 1;
						END;
					END;
					count := length(PStr255(L)^)+1;
					BlockMoveData(Ptr(L),@TheCCsts^^[i],count);
					IF NOT Trouve THEN TheICsts^^[i] := -1 ELSE TheICsts^^[i] := OffCode;
					L := L + count;
				END;
				HUnlock(Handle(TheGCsts));
				
				{ •• Chargement du code tokenisé •• }
				
				LgCode := TOKNh(theTOKNRes)^^.SizeTokens;
				IF LgCode<0 THEN LgCode := 0;
				SetHSize(Handle(TheCCode), LgCode + 2);
				HLock(Handle(theCCode));	{ par sécurité }
				IF LgCode <> 0 THEN BlockMoveData(Ptr(L),Ptr(TheCCode^),LgCode);
				
				HUnlock(theTOKNRes);
				ReleaseResource(theTOKNRes);
			END;
		END;
		
		IF NOT Loaded THEN
		BEGIN		{ fichier normal }
{$IFC DEMO}
			NbDemoScreens := NbDemoScreens + 1;		{ limitation du nombre d'écran compilés en démo }
{$ENDC}

			{ vérification du type de fichier… }
			Err := HGetFInfo(CurVol,DirId,gCurScreen,infos);
			IF (Err=NoErr) & (infos.fdType<>'VCOD') THEN MsgBadType;
			
			Err := HOpen(CurVol,DirId,gCurScreen, fsRdPerm, RefW);
			IF (Err <> 0) THEN
			BEGIN
				{ vérif. du type de fichier }
				Err := GetFInfo(gCurScreen,0,infos);
				IF (Err=NoErr) & (infos.fdType<>'VCOD') THEN MsgBadType;
				Err := FSOpen(gCurScreen, 0, RefW);
				IF (Err <> 0) THEN
				BEGIN
					ErrFlag := TRUE;
					Error := Err;
					WWLnStr('');
					WWriteStr(GetMessage(34));
					WWLnStr(gCurScreen);
					WWriteStr(GetMessage(41));
					WWLnStr(TheGScreen^^.TheScreens[TheGScreen^^.TheScreens[NumCode].FromScreen].NomScreen^^);
					EXIT(LoadCode);
				END
			END;
		
			{ code VideoTex compacté }
				
			count := Sizeof(Longint);
			Err := FSRead(RefW, count, @Vlg);
			IF (Err <> 0) THEN
			BEGIN
				ErrFlag := TRUE;
				Error := Err;
				Vlg := 0;
			END;
		
{$IFC TempVtx=FALSE}
			OffCode := GetHandleSize(TheGVCode);
			TheGScreen^^.TheScreens[NumCode].OffsetVcode := OffCode;
			IF Odd(Vlg) THEN {on aligne}
			BEGIN
				SetHSize(TheGVCode, GetHandleSize(TheGVCode) + 4 + Vlg + 1);
				{ raz de l'octet d'alignement }
				p:=Ptr(Ord4(TheGVCode^)+OffCode+4+Vlg);
				p^:=0;
			END
			ELSE
				SetHSize(TheGVCode, GetHandleSize(TheGVCode) + 4 + Vlg);
		
			{ on mémorise la longueur de la page }
			OffCode := Ord4(TheGVCode^) + OffCode;
			LPtr(OffCode)^ := Vlg;
		
			{ on mémorise la page vidéotex }
			Err := FSRead(RefW, Vlg, Ptr(OffCode + 4));
			
{$ELSEC}
			TheGScreen^^.TheScreens[NumCode].OffsetVcode := vtxtSize;
			{ lecture du code vidéotex de l'écran }
			SetHSize(TheGVCode,Vlg);			
			Err := FSRead(RefW,Vlg,TheGVCode^);
			IF Vlg=1 THEN Vlg := 0;
			{ on enregistre la longueur de la page }
			L := SizeOf(LONGINT);
			Err := FSWrite(vtxtRef,L,@Vlg);
			IF Vlg>0 THEN
			BEGIN
				L := Vlg;
				Err := FSWrite(vtxtRef,L,TheGVCode^);
				IF odd(Vlg) THEN
				BEGIN
					L := 1;
					Vlg := 0;
					Err := FSWrite(vtxtRef,L,@Vlg);
				END;
			END;
{$ENDC}

			{ on skippe le source si il est la }
			count := Sizeof(Longint);
			Err := FSRead(RefW, count, @lgtext);
			IF (Err <> 0) | (infos.fdCreator<>'DRG9') THEN	{ seulement un écran vidéotex }
			BEGIN
				lgtext := 0;
				NbVar := 0;
				SetHSize(Handle(TheCVars), 0);
				NbCst := 0;
				SetHSize(Handle(TheCCsts), 0);
				SetHSize(Handle(TheICsts), 0);
				LgCode := 0;
				SetHSize(Handle(TheCCode), 2);
				GOTO 0;	{ beurk }
			END;
		
			Err := SetFPos(RefW, fsFromMark, lgtext);
			IF (Err <> 0) OR (lgtext > 0) THEN
			BEGIN
				ErrFlag := TRUE;
				IF Err<>0 THEN Error := Err ELSE Error := ErrNonXFile;
				WWLnStr('');
				WWriteStr(GetMessage(34));
				WWLnStr(gCurScreen);
				WWriteStr(GetMessage(41));
				WWLnStr(TheGScreen^^.TheScreens[TheGScreen^^.TheScreens[NumCode].FromScreen].NomScreen^^);
				EXIT(LoadCode);
			END;
		
			{ lecture de la table de variables }
			count := Sizeof(Integer);
			Err := FSRead(RefW, count, @NbVar);
			IF (Err <> 0) THEN
			BEGIN
				ErrFlag := TRUE;
				Error := Err;
				NbVar := 0;
			END;
		
			count := Sizeof(TVar) * Longint(NbVar);
			SetHSize(Handle(TheCVars), count);
			Err := FSRead(RefW, count, Ptr(TheCVars^));
			IF (Err <> 0) THEN
			BEGIN
				NbVar := 0;
				ErrFlag := TRUE;
				Error := Err;
			END;
	
			{ lecture de la table de constantes }
			count := Sizeof(Integer);
			Err := FSRead(RefW, count, @NbCst);
			IF (Err <> 0) THEN
			BEGIN
				ErrFlag := TRUE;
				Error := Err;
				NbCst := 0;
			END;
	
			count := Sizeof(Str64) * Longint(NbCst);
			SetHSize(Handle(TheCCsts), count);
			SetHSize(Handle(TheICsts), Sizeof(Longint) * Longint(NbCst));
			Err := FSRead(RefW, count, Ptr(TheCCsts^));
			IF (Err <> 0) THEN
			BEGIN
				{ErrorManager(Err,107);}
				ErrFlag := TRUE;
				Error := Err;
				NbCst := 0;
				SetHSize(Handle(TheCCsts), 0);
			END;
	
			{ Integration des constantes }
			{$IFC GenAsm}
			IF FlagCC THEN WriteLn('; Integration des constantes');
			{$ENDC}
			
			HLock(Handle(TheGCsts));
			FOR i := 1 TO NbCst DO
			BEGIN
				{ Recherche d'une constante equivalente }
				OffMax := GetHandleSize(TheGCsts);
				OffCode := 0;
				Trouve := false;
				L := Ord4(TheGCsts^);
				WHILE (OffCode < OffMax) & (NOT Trouve) DO
				BEGIN
					TheStr := Pstr255(L + OffCode);
					Trouve := (TheStr^ = TheCCsts^^[i]);
					IF NOT Trouve THEN
					BEGIN
						OffCode := OffCode + length(TheStr^) + 1;
						IF Odd(OffCode) THEN OffCode := OffCode + 1;
					END;
				END;
				IF NOT Trouve THEN
					TheICsts^^[i] := -1
				ELSE
					TheICsts^^[i] := OffCode;
			END;
			HUnlock(Handle(TheGCsts));
			
			{ lecture du code tokenise }
			count := Sizeof(Integer);
			Err := FSRead(RefW, count, @LgCode);
			IF (Err <> 0) THEN
			BEGIN
				ErrFlag := TRUE;
				Error := Err;
				LgCode := 0;
			END;
	
			count := LgCode; { pour le LParam a 0 }
			SetHSize(Handle(TheCCode), count + 2);
			HLock(Handle(TheCCode));
			Err := FSRead(RefW, count, Ptr(TheCCode^));
			IF (Err <> 0) THEN
			BEGIN
				ErrFlag := TRUE;
				Error := Err;
				LgCode := 2;
			END;
	
			Err := FSClose(RefW);		{ fermeture du fichier source }
			IF (Err <> 0) THEN
			BEGIN
				ErrFlag := TRUE;
				Error := Err;
			END;
		
		END;	{ IF NOT Loaded }
	
0:
		IF (LgCode > 0) & IncList & (PreCompFlag=FALSE) THEN
		BEGIN
			TraceLn;
			TraceStrLn(GetMessage(35));
			TraceLn;
		END;

		IF ErrFlag THEN EXIT(LoadCode);

		{ on met un 0 à la fin du code tokenisé }
		e := TParamPtr(ORD4(StripAddress(TheCCode^)) + LgCode);
		e^.LParam := 0;

		{ integration des variables numeriques et chaines }
		FOR Numvar := 1 TO NbVar DO
			IF (TheCVars^^[Numvar].TpVar IN [fvarnum, fvarstr, finumvar,
				 fistrvar]) THEN
			BEGIN
				Trouve := false;
				i := 0;
				
				Hlock(Handle(theCVars));
				WITH TheCVars^^[Numvar] DO
					WHILE (NOT Trouve) & (i < TheGVars^^.NbVars) DO
					BEGIN
						i := i + 1;
						Trouve := (TheGVars^^.Vars[i].NomVar = NomVar);
					END;
				HUnlock(Handle(theCVars));
				
				IF Trouve THEN
				BEGIN { on met a jour l'indirection }
					TheCVars^^[Numvar].Indir := i;
					{ on verifie le flag shared }
					IF TheCVars^^[Numvar].Shared AND (NOT TheGVars^^.Vars[i].Shared) THEN
					BEGIN
						WWLnStr('');
						WWLnStr(ParamMessage(28,gCurScreen,'','',''));
						WWLnStr(ParamMessage(36,TheCVars^^[Numvar].NomVar,'','',''));
						ErrFlag := TRUE;
						Error := 0;
					END;
				END
				ELSE { on ajoute la variable et on met a jour l'indirection }
				BEGIN
					TheGVars^^.NbVars := TheGVars^^.NbVars + 1;
					SetHSize(Handle(TheGVars), Sizeof(Integer) + Sizeof(TGVar) * longint(TheGVars^^.NbVars));
					TheCVars^^[Numvar].Indir := TheGVars^^.NbVars;
					
					HLock(Handle(TheGVars));
					WITH TheGVars^^.Vars[TheGVars^^.NbVars] DO
					BEGIN
						NomVar := TheCVars^^[Numvar].NomVar;
						TpVar := TheCVars^^[Numvar].TpVar;
						DimVal := TheCVars^^[Numvar].DimVal;
						Shared := TheCVars^^[Numvar].Shared;
						CASE TpVar OF
							fvarnum: SizeVar := IntSize;
							fvarstr: SizeVar := StrSize;
							finumvar: SizeVar := Ord4(IntSize) * Ord4(DimVal);
							fistrvar: SizeVar := Ord4(StrSize) * Ord4(DimVal);
						END;	{ CASE TpVar }
						
						IF SizeVar=0 THEN	{ test tableau déclaré ?? }
						BEGIN
							WWLnStr('');
						 	WWLnStr(ParamMessage(28,gCurScreen,'','','')); 
							WWLnStr(ParamMessage(37,TheCVars^^[Numvar].NomVar,'','',''));
							ErrFlag := TRUE;
							Error := 0;
						END;
						
						{calcul de l'offset en fonction de shared}
						OffsetVar := 0;
						FOR i := 1 TO TheGVars^^.NbVars - 1 DO
							IF Shared AND TheGVars^^.Vars[i].Shared THEN
								OffsetVar := OffsetVar + TheGVars^^.Vars[i].SizeVar
							ELSE IF (NOT Shared) AND (NOT TheGVars^^.Vars[i].Shared) THEN
								OffsetVar := OffsetVar + TheGVars^^.Vars[i].SizeVar;
					END;	{ WITH TheGVars^^… }
					HUnlock(Handle(TheGVars));
				END;
			END
			ELSE IF (TheCVars^^[Numvar].TpVar IN [fetiq, fuetiq]) THEN
			BEGIN
				NewEtiq(false, 0);
				TheCVars^^[Numvar].Indir := NumEtiq;
			END;

	END;	{ LoadCode }

{==============================================================================}
{ 					 C O N T R O L E							 }
{==============================================================================}

PROCEDURE CallJump(TheCall: Integer);

	BEGIN
		AddCode2($4EAB, TheCall * 6);
		{$IFC GenAsm}
		IF FlagCC THEN WriteLn('  jsr ', TheCall, '*6(A3)');
		{$ENDC}
	END;

PROCEDURE GosubScreen(e: TParamPtr;
											JSRFlag, JmpFlag, LoadFlag, DecFlag, DrawFlag,
											FrontFlag: Boolean);

	VAR
		NumCode: Integer;
		Trouve: Boolean;
		TheStr, TheNStr: Pstr255;

	BEGIN
		{$IFC GenAsm}
		IF FlagCC THEN WriteLn('; GOSUBSCREEN');
		{$ENDC}
		NextCompToken(e, Sizeof(TDummy) + 2);
		IF JSRFlag THEN
			BEGIN
			AddCode2($2F2C, TheNCst); { push du numero de code courant }
			{ move.l TheNCst(A4),-(SP) }
			END;
		{ si constante on regarde si elle existe dans la liste des ecrans }
		IF e^.tk = tkStrCst THEN
		BEGIN
			HLock(Handle(TheGCsts));
			HLock(handle(theGScreen));
			TheStr := @TheCCsts^^[e^.Indir];
			WITH TheGScreen^^ DO
			BEGIN
				NumCode := 0;
				Trouve := false;
				WHILE (NumCode < NbScreens) AND (NOT Trouve) DO
				BEGIN
					NumCode := NumCode + 1;
					TheNStr := Pstr255(Ord4(@TheScreens[NumCode].NomScreen^^));
					Trouve := EqualString(TheNStr^, TheStr^, false, TRUE);
				END;
			END;
			
			IF NOT Trouve THEN
			BEGIN
				NumCode := NumCode + 1;
				SetHSize(Handle(TheGScreen), Sizeof(Integer) + Sizeof(TGScreen) * longint(NumCode));
				TheStr := @TheCCsts^^[e^.Indir];
				WITH TheGScreen^^ DO
				BEGIN
					NbScreens := NbScreens + 1;
					WITH TheScreens[NbScreens] DO
					BEGIN
						NomScreen := NewString(TheStr^);
						OffsetCode := 0;
						OffsetVcode := 0;
						FlagProcessed := false;
						fromScreen := gCurCode;
					END;
				END;
			END;
			IF NOT DecFlag THEN
			BEGIN
				{ Numcode contient le numero d'ecran a executer }
				IF NumCode-1<=127 THEN
					AddCode1($7000+NumCode-1)			{ moveq.l #NumCode-1,D0 }
				ELSE
					AddCode3($203C, NumCode - 1); { move.l #NumCode-1,D0 }
			END;
			HUnlock(Handle(TheGCsts));
			HUnlock(handle(theGScreen));
		END
		ELSE
		BEGIN { on evalue le nom de l'écran }
			AddCode2($9EFC, 256);			{ suba.w #256,SP }
			StackEval(270);
			AddCode1($42A7);					{ clr.l -(SP) }
			AddCode2($486F, 4);				{ pea 4(SP) }
			StrExprXCute(e);
			AddCode2($486F, 4);				{ pea 4(SP) }
			CallJump(XSeekScreen);
			AddCode1($201F);					{ move.l (SP)+,D0 }
			AddCode2($DEFC, 256);			{ adda.w #256,SP }
			StackEval(-270);
		END;
		
		IF NOT DecFlag THEN
		BEGIN
			IF NOT DrawFlag THEN
				AddCode2($2940, TheNCst);	{ move.l D0,TheNCst(A4) }
			AddCode1($E788);						{ lsl.l #3,D0 }
			AddCode2($206C, TheSCst);		{ move.l OffScreen(A4),A0 }
			IF NOT LoadFlag THEN
				AddCode2($2270, $0800);		{ move.l (A0,D0.L),A1 }
			
			IF JSRFlag OR JmpFlag OR LoadFlag THEN
			BEGIN
				{ mise à jour offset ecran videotex }
				AddCode3($2970,$08040000+TheVCst);	{ move.l 4(A0,D0.L),TheVScreen(A4) }
				IF NOT LoadFlag THEN
				BEGIN
					IF JSRFlag THEN
						AddCode1($4E91)				{ jsr (A1) }
					ELSE
						AddCode1($4ED1);			{ jmp (A1) }
				END;
			END
			ELSE
			BEGIN
				AddCode2($2F30, $0804);		{ move.l 4(A0,D0).L,-(SP) (N° de l'écran à afficher) }
				IF DrawFlag THEN
					CallJump(Mots^^[tkDrawScreen].JumpCode + OffRT);
			END;
		END;
	END;

PROCEDURE SInput(e: TParamPtr);

	VAR
		nb, i: Integer;

	BEGIN
		{$IFC GenAsm}
		IF FlagCC THEN WriteLn('; INPUT');
		{$ENDC}
		nb := e^.nbparam;
		NextCompToken(e, Sizeof(TDummy) + 2);
		
		IF nb > 1 THEN
		BEGIN
			AddCode2($9EFC, 256);	{ suba.w #256,SP }
			StackEval(270);
			AddCode1($4857);	{ pea (SP) }
			StrExprXCute(e);
			AddCode1($4857);	{ pea (SP) }
			NextCompToken(e, e^.LParam);
		END
		ELSE
			AddCode1($42A7);	{ clr.l -(SP) }

		CASE Mots^^[e^.tk].tfunc OF { type numerique ou chaine }
			fvarstr, fistrvar:
				AddCode2($7001,$2F00);	{ MOVEQ #1,D0  ;  MOVE.L D0,-(SP) }
				
			fvarnum, finumvar:
				AddCode1($42A7);					{ CLR.L -(SP) }
		END;

		PAdrVar(e);
		CallJump(XVarInput);
		IF nb > 1 THEN
		BEGIN
			AddCode2($DEFC, 256);			{ adda.w #256,SP }
			StackEval( - 270);
		END;
	END;

PROCEDURE SZone(e: TParamPtr);

	VAR
		i: Integer;

	BEGIN
		{$IFC GenAsm}
		IF FlagCC THEN WriteLn('; ZONE');
		{$ENDC}
		NextCompToken(e, Sizeof(TDummy) + 2);
		FOR i := 1 TO 3 DO { x,y,len }
		BEGIN
			NumExprXCute(e);
			NextCompToken(e, e^.LParam);
		END;
			
		PAdrVar(e);
		CASE Mots^^[e^.tk].tfunc OF { type numerique ou chaine }
			fvarstr, fistrvar: AddCode2($3F3C, 1);		{ move.w #i,-(SP) }
			fvarnum, finumvar: AddCode1($4267);				{ clr.w -(sp) }
		END;
		
		NextCompToken(e, e^.LParam);
		NumExprXCute(e); { couleur }
		CallJump(Mots^^[tkZone].JumpCode + OffRT);
	END;

PROCEDURE SWaitConnect(e: TParamPtr);

	VAR
		i: Integer;

	BEGIN
		i := 0;
		IF e^.nbparam > 0 THEN
		BEGIN
			NextCompToken(e, Sizeof(TDummy) + 2);
			NumExprXCute(e);
		END
		ELSE
			AddCode1($42A7);	{ CLR.L -(SP) }
		CallJump(Mots^^[tkWaitConnect].JumpCode + OffRT);
	END;

PROCEDURE BaseSeek(e: TParamPtr);

	VAR
		i: Integer;

	BEGIN
		{$IFC GenAsm}
		IF FlagCC THEN WriteLn('; BaseSeek');
		{$ENDC}
		NextCompToken(e, Sizeof(TDummy) + 2);
		FOR i := 1 TO 2 DO { NumBase, NumIndex }
			BEGIN
			NumExprXCute(e);
			NextCompToken(e, e^.LParam);
			END;
		i := 1;	{ •••• obligatoirement une chaine ! •••• }

		PAdrVar(e);
		AddCode2($3F3C, i);
		{$IFC GenAsm}
		IF FlagCC THEN WriteLn('   move.w #', i: 1, '-(SP)'); { type variable }
		{$ENDC}
		CallJump(Mots^^[tkBaseSeek].JumpCode + OffRT);
	END;

PROCEDURE Print(e: TParamPtr; FilePrint, SepFlag, SPFlag: Boolean);

	VAR
		nb, i, LastTk: Integer;
		tempFlag: BOOLEAN;
		
	BEGIN
		{$IFC GenAsm}
		IF FlagCC THEN WriteLn('; PRINT');
		{$ENDC}
		nb := e^.nbparam;
		NextCompToken(e, Sizeof(TDummy) + 2);
		IF FilePrint THEN
		BEGIN
			NumExprXCuteDx(e,7);	{ résultat dans D7 }
			NextCompToken(e, e^.LParam);
			nb := nb - 1;
			CallJump(XStartWrite);
		END;
		LastTk := 0;
		FOR i := 1 TO nb DO
		BEGIN
			LastTk := e^.tk;
			CASE Mots^^[e^.tk].tfunc OF
				fvarstr, fistrvar, fcstStr, fcstr, fstr:
				BEGIN
					CASE Mots^^[e^.tk].tfunc OF
						fvarstr, fistrvar:
						{ récupération directe de l'adresse de la variable }
						BEGIN
							IF FilePrint THEN
								AdrA0(e) 							{ adresse chaine dans A0 }
							ELSE
								PAdrVar(e);						{ adresse chaîne sur la pile }
							TempFlag := FALSE;
						END;
						
						fcstStr:	{ contante chaine… }
						BEGIN
							UseCst(e^.indir);
							IF TheICsts^^[e^.Indir] < 32767 THEN
							BEGIN
								AddCode2($206C, TheCCst);									{ move.l GCst(A4),A0 }
								IF FilePrint THEN
									AddCode2($41E8, TheICsts^^[e^.Indir])		{ lea offsetCst(A0),A0 }
								ELSE
									IF TheICsts^^[e^.Indir]>0 THEN
										AddCode2($4868,TheICsts^^[e^.Indir])	{ pea offsetCst(A0) }
									ELSE
										AddCode1($4850);											{ PEA (A0) !!! }
							END
							ELSE
							BEGIN
								AddCode2($206C, TheCCst);								{ move.l GCst(A4),A0 }
								AddCode3($203C, TheICsts^^[e^.Indir]);	{ move.l #offsetCst,D0 }
								IF FilePrint THEN
									AddCode2($41F0,$0800)									{ lea (A0,D0.L),A0 }
								ELSE
									AddCode2($4870,$0800);								{ pea (A0,D0.L) }
							END;
							TempFlag := FALSE;
						END;
					
						fcstr, fstr:
						{ fonction chaine, on alloue une chaine temporaire pour le résultat }
						BEGIN
							AddCode2($9EFC, 256);		{ SUBA.W #256,SP }
							StackEval(270);
							AddCode1($4857);				{ PEA (SP) }
							StrExprXCute(e);
							TempFlag := TRUE;
						END;
					END;	{ CASE }
					
					IF FilePrint THEN
					BEGIN
						AddCode1($2F07);			{ move.l D7,-(SP) }
						IF TempFlag THEN
							AddCode2($486F, 4)	{ pea 4(SP) = addr. chaîne temporaire }
						ELSE
							AddCode1($2F08);		{ move.L A0,-(SP)}
						CallJump(XStrWrite);
					END
					ELSE
					BEGIN
						IF TempFlag THEN AddCode1($4857);		{ pea (SP) }
						CallJump(XStrPrint);
					END;
					IF TempFlag THEN
					BEGIN
						AddCode2($DEFC, 256);		{ add.w #256,SP }
						StackEval(-270);
					END;
				END;
				
				fcnum, fnum, fcstnum, fvarnum, finumvar:
				BEGIN
					IF FilePrint THEN AddCode1($2F07);	{ move.l D7,-(SP) }

					NumExprXCute(e);
					IF FilePrint THEN
						CallJump(XNumWrite)
					ELSE
						CallJump(XNumPrint);
				END;
				
				OTHERWISE
					IF LastTk = TkV THEN
					BEGIN
						IF FilePrint THEN
						BEGIN
							AddCode1($2F07);			{ move.l D7,-(SP) }
							IF SPFlag THEN
								AddCode2($3F3C, 32)	{ move.w #32,-(SP) }
							ELSE
								AddCode2($3F3C, 9);	{ move.w #9,-(SP) }
						END
						ELSE
							AddCode2($3F3C, 32);	{ move.w #32,-(SP) }
							
						IF FilePrint THEN
							CallJump(XCarWrite)
						ELSE
							CallJump(XCarPrint);
					END;
			END;	{ CASE }
			
			IF SepFlag AND (i < nb) THEN
			BEGIN
				IF FilePrint THEN
				BEGIN
					AddCode1($2F07);			{ move.l D7,-(SP) }
					AddCode2($3F3C, 9);		{ move.w #9,-(SP) }
				END
				ELSE
					AddCode2($3F3C, 32);	{ move.w #32,-(SP) }

				IF FilePrint THEN
					CallJump(XCarWrite)
				ELSE
					CallJump(XCarPrint);
				END;
				
				NextCompToken(e, e^.LParam);
			END;

		IF (LastTk <> TkV) AND (LastTk <> TkPV) THEN
		BEGIN
			IF FilePrint THEN
				AddCode1($2F07);			{ move.l D7,-(SP) }

			AddCode2($3F3C, 13);		{ move.w #13,-(SP) }
			IF FilePrint THEN
				CallJump(XCarWrite)
			ELSE
			BEGIN
				CallJump(XCarPrint);
				AddCode2($3F3C, 10);	{ move.w #10,-(SP) }
				CallJump(XCarPrint);
			END;
		END;

		IF FilePrint THEN
		BEGIN
			AddCode1($2F07);	{ move.l D7,-(SP) }
			CallJump(XEndWrite);
		END;
	END;

PROCEDURE SRead(e: TParamPtr);

	VAR
		nb, i: Integer;

	BEGIN
		{$IFC GenAsm}
		IF FlagCC THEN WriteLn('; READ');
		{$ENDC}
		nb := e^.nbparam;
		NextCompToken(e, Sizeof(TDummy) + 2);
		NumExprXCuteDx(e,7);	{ résultat dans D7 }
		NextCompToken(e, e^.LParam);
		nb := nb - 1;
		AddCode1($2F07);	{ move.l D7,-(SP) }
		CallJump(XStartRead);
		FOR i := 1 TO nb DO
		BEGIN
			AddCode1($2F07);		{ move.l D7,-(SP) }
			PAdrVar(e);
			CASE Mots^^[e^.tk].tfunc OF
				fvarstr, fistrvar: CallJump(XStrRead);
				fvarnum, finumvar: CallJump(XNumRead);
			END;
			NextCompToken(e, e^.LParam);
		END;
	END;

PROCEDURE SIF(e: TParamPtr);

	VAR
		TheEtiq: Integer;

	BEGIN
		{$IFC GenAsm}
		IF FlagCC THEN WriteLn('; IF');
		{$ENDC}
		NewWIF(2);
		NewEtiq(false, 0);
		StackWIF^^[NumWIF].EtIfStart := pc;	{ PC avant le IF }
		StackWIF^^[NumWIF].EtElse := NumEtiq;
		NewEtiq(false, 0);
		StackWIF^^[NumWIF].EtEndif := NumEtiq;
		TheEtiq := NumEtiq;
		NextCompToken(e, Sizeof(TDummy) + 2);

		{ évaluation avec résultat dans D0 }
		NumExprXCuteDx(e,0);

		NextCompToken(e, e^.LParam);
		IF e^.num = 0 THEN {pas de else}
		BEGIN
			BranchEtiq(TheEtiq, $6700);
			{$IFC GenAsm}
			IF FlagCC THEN WriteLn('    beq    EtEndif');
			{$ENDC}
		END
		ELSE
		BEGIN
			BranchEtiq(TheEtiq - 1, $6700);
			{$IFC GenAsm}
			IF FlagCC THEN WriteLn('    beq    EtElse');
			{$ENDC}
		END;
		StackWIF^^[NumWIF].EtIfEnd := pc;	{ sauve le PC en fin de IF }
	END;

PROCEDURE SWhile(e: TParamPtr);

	VAR
		TheEtiq: Integer;

	BEGIN
		{$IFC GenAsm}
		IF FlagCC THEN WriteLn('; WHILE');
		{$ENDC}
		NewWIF(0);
		NewEtiq(false, 0);
		StackWIF^^[NumWIF].EtWhile := NumEtiq;
		NewEtiq(false, 0);
		StackWIF^^[NumWIF].EtEndWhile := NumEtiq;
		TheEtiq := NumEtiq;
		DefEtiq(TheEtiq - 1, Pc);
		NextCompToken(e, Sizeof(TDummy) + 2);
		NumExprXCuteDx(e,0);
		BranchEtiq(TheEtiq, $6700);
		{$IFC GenAsm}
		IF FlagCC THEN WriteLn('  beq    EndWhile');
		{$ENDC}
	END;

PROCEDURE SGoto(e: TParamPtr);

	BEGIN
		{$IFC GenAsm}
		IF FlagCC THEN WriteLn('; GOTO');
		{$ENDC}
		NextCompToken(e, Sizeof(TDummy) + 2);
		BranchEtiq(TheCVars^^[e^.Indir].Indir, $6000);
	END;

PROCEDURE SOn(e: TParamPtr);

	VAR
		nb, i: Integer;
		theTk, TheEtiq: Integer;

	BEGIN
		{$IFC GenAsm}
		IF FlagCC THEN WriteLn('; ON');
		{$ENDC}
		NewEtiq(false, 0);
		TheEtiq := NumEtiq;
		nb := e^.nbparam;
		NextCompToken(e, Sizeof(TDummy) + 2);
		NumExprXCuteDx(e,0);

		BranchEtiq(TheEtiq, $6F00);
		{$IFC GenAsm}
		IF FlagCC THEN WriteLn('   ble EndOn');
		{$ENDC}

		AddCode3($0C80, nb - 1);
		{$IFC GenAsm}
		IF FlagCC THEN WriteLn('   cmp.l #', nb - 1: 1, ',D0');
		{$ENDC}

		BranchEtiq(TheEtiq, $6A00);
		{$IFC GenAsm}
		IF FlagCC THEN WriteLn('   bpl EndOn');
		{$ENDC}

		NextCompToken(e, e^.LParam);
		theTk := e^.tk;
		IF theTk = tkGosub THEN
			BEGIN
			{ on empile le numero de code }
			{$IFC GenAsm}
			IF FlagCC THEN WriteLn('   move.l theNCst(A4),-(SP)');
			{$ENDC}
			AddCode2($2F2C, TheNCst); { push du numero de code }
			END;
		FOR i := 1 TO nb - 2 DO
			BEGIN
			NextCompToken(e, e^.LParam);
			AddCode1($5380);
			{$IFC GenAsm}
			IF FlagCC THEN WriteLn('    subq.l #1,D0');
			{$ENDC}
			IF theTk = tkGosub THEN
				BEGIN
				AddCode1($6608);
				{$IFC GenAsm}
				IF FlagCC THEN WriteLn('    bne *+8'); { 2 octets }
				{$ENDC}
				AddCode2($4EBA, 0);
				UseEtiq(TheCVars^^[e^.Indir].Indir, Pc - 2);
				{$IFC GenAsm}
				IF FlagCC THEN WriteLn('    jsr Etiq'); { 4 octets }
				{$ENDC}
				BranchEtiq(TheEtiq, $6000);
				{$IFC GenAsm}
				IF FlagCC THEN WriteLn('    bra EndOn'); { 4 octets }
				{$ENDC}
				END
			ELSE
				BEGIN
				AddCode1($6604);
				{$IFC GenAsm}
				IF FlagCC THEN WriteLn('    bne *+4'); { 2 octets }
				{$ENDC}
				AddCode2($4EFA, 0);
				UseEtiq(TheCVars^^[e^.Indir].Indir, Pc - 2);
				{$IFC GenAsm}
				IF FlagCC THEN WriteLn('    jmp Etiq'); { 4 octets }
				{$ENDC}
				END;
			END;
		{$IFC GenAsm}
		IF FlagCC THEN WriteLn('; EndOn:');
		{$ENDC}
		DefEtiq(TheEtiq, Pc);
	END;

PROCEDURE SGosub(e: TParamPtr);

	BEGIN
		{$IFC GenAsm}
		IF FlagCC THEN WriteLn('; GOSUB');
		{$ENDC}
		NextCompToken(e, Sizeof(TDummy) + 2);
		AddCode2($2F2C, TheNCst); { push du numero de code }
		AddCode2($4EBA, 0); { jsr etiquette }
		UseEtiq(TheCVars^^[e^.Indir].Indir, Pc - 2);
	END;

PROCEDURE Sfor(e: TParamPtr);

	VAR
		TheEtiq, Numvar: Integer;
		ex, ex0, ex1, ex2: TParamPtr;

	BEGIN
		{$IFC GenAsm}
		IF FlagCC THEN WriteLn('; FOR');
		{$ENDC}
		NewWIF(1);
		NewEtiq(false, 0);
		StackWIF^^[NumWIF].EtForInc := NumEtiq;
		NewEtiq(false, 0);
		StackWIF^^[NumWIF].EtForTest := NumEtiq;
		NewEtiq(false, 0);
		StackWIF^^[NumWIF].EtEndFor := NumEtiq;
		TheEtiq := NumEtiq;

		{ affectation }
		NextCompToken(e, Sizeof(TDummy) + 2);
		ex := e;
		ex0 := e; NextCompToken(ex0, Sizeof(TDummy) + 2);
		NextCompToken(e, e^.LParam);
		ex1 := e;
		NextCompToken(e, e^.LParam);
		ex2 := e;
		AffXCute(ex);

		{ evaluation valeur variable -> pile }
		VarToA7(ex0);

		NumExprXCuteDx(ex2,7);	{ résultat dans D7 }

		{ saut au test }
		BranchEtiq(StackWIF^^[NumWIF].EtForTest, $6000);
		{$IFC GenAsm}
		IF FlagCC THEN
			BEGIN
			WriteLn('   bra EtForTest');
			WriteLn('; EtForInc:');
			END;
		{$ENDC}

		DefEtiq(TheEtiq - 2, Pc);		{ •• incrémentation •• }
		NumExprXCuteDx(ex2,7);	{ valeur incrément dans D7 }
		AdrA0(ex0); 						{ adresse de la variable d'indice -> A0 }
		AddCode1($2007);				{ MOVE.L D7,D0	; incrément -> D0 }
		AddCode1($D190);				{ ADD.L D0,(A0)	; on incrémente l'indice }
		AddCode1($2F10);				{ MOVE.L (A0),-(SP)	; nouvel indice -> pile }
		
		DefEtiq(TheEtiq - 1, Pc);		{ •• test •• }
		NumExprXCuteDx(ex1,0);	{ évaluation borne de fin -> D0 }
		IF ex2^.tk=TkNumCst THEN		{ l'incrément est une constante numérique ! }
		BEGIN
			AddCode1($B09F);						{ cmp.l (SP)+,D0	; compare indice et borne de fin }				
			IF ex2^.Num>0 THEN	{ incrément positif }
				BranchEtiq(TheEtiq, $6D00)	{ blt.s EndFor		; l'indice a dépasse la borne }
			ELSE	{ incrément négatif }
				BranchEtiq(TheEtiq, $6E00);	{ bgt.s EndFor		; l'indice a dépassé la borne }
		END
		ELSE
		BEGIN
			AddCode1($4A87);						{ tst.l D7 ; incrémentation positive ou négative }
			AddCode1($6B08);						{ bmi.s TestDownTo }
			AddCode1($B09F);						{ cmp.l (SP)+,D0	; compare indice et borne de fin }
			BranchEtiq(TheEtiq, $6D00);	{ blt.s EndFor		; l'indice a dépasse la borne }
			AddCode1($6006);						{ bra.s DoFor			; sinon on continue }
			AddCode1($B09F);						{ TestDownTo: cmp.l (SP)+,D0 }
			BranchEtiq(TheEtiq, $6E00);	{ bgt.s EndFor		; l'indice a dépassé la borne }
																	{ DoFor: }
		END;
	END;

PROCEDURE Selse(e: TParamPtr);

	BEGIN
		{$IFC GenAsm}
		IF FlagCC THEN WriteLn('; ELSE');
		{$ENDC}
		{ on doit sauter au endif }
		BranchEtiq(StackWIF^^[NumWIF].EtEndif,$6000);
		{$IFC GenAsm}
		IF FlagCC THEN WriteLn('   bra EtEndif');
		{$ENDC}
		{ on genere l'etiquette du Else }
		DefEtiq(StackWIF^^[NumWIF].EtElse, Pc);
	END;

PROCEDURE Sendif(e: TParamPtr);

	BEGIN
		{$IFC GenAsm}
		IF FlagCC THEN WriteLn('; ENDIF');
		{$ENDC}
(*
		IF StackWIF^^[NumWIF].EtIfEnd<>pc THEN	{ a-t-on généré du code entre IF et ENDIF ? }
		BEGIN
			DefEtiq(StackWIF^^[NumWIF].EtEndif, Pc);
		END
		ELSE		{ pas de code généré, on vire le code du IF/ENDIF }
		BEGIN	
			pc := StackWIF^^[NumWIF].EtIfStart;
			IF NInst=1 THEN LastLine := NL-1;	{ il faudra regénérer le N° de ligne ! }
		END;
		{on depile un RecWIFet}
		SubWIF;
*)
		{ on genere l'etiquette du Endif }
		DefEtiq(StackWIF^^[NumWIF].EtEndif, Pc);
		{on depile un RecWIFet}
		SubWIF;
	END;

PROCEDURE Sbreak(e: TParamPtr);

	VAR
		NumFor: Integer;
		Trouve: Boolean;

	BEGIN
		{$IFC GenAsm}
		IF FlagCC THEN WriteLn('; BREAK');
		{$ENDC}
		{ rechercher le premier While/For dans la pile }
		NumFor := NumWIF;
		Trouve := false;
		WHILE (NumFor <> 0) AND (NOT Trouve) DO
		BEGIN
			Trouve := StackWIF^^[NumFor].tpRec <> 2;
			IF NOT Trouve THEN NumFor := NumFor - 1;
		END;
		
		CASE StackWIF^^[NumFor].tpRec OF
			0: {While}
				BranchEtiq(StackWIF^^[NumFor].EtEndWhile, $6000);
				
			1: {for} 
				BranchEtiq(StackWIF^^[NumFor].EtEndFor, $6000);
				
			3: {repeat}
				BranchEtiq(StackWIF^^[NumFor].EtUntilEnd,$6000);
		END;	{ CASE }
		
	END;	{ sBreak }

PROCEDURE Scontinue(e: TParamPtr);

	VAR
		NumFor: Integer;
		Trouve: Boolean;

	BEGIN
		{$IFC GenAsm}
		IF FlagCC THEN WriteLn('; CONTINUE');
		{$ENDC}
		{ rechercher le premier While/For dans la pile }
		NumFor := NumWIF;
		Trouve := false;
		WHILE (NumFor <> 0) AND (NOT Trouve) DO
		BEGIN
			Trouve := StackWIF^^[NumFor].tpRec <> 2;
			IF NOT Trouve THEN NumFor := NumFor - 1;
		END;
		
		CASE StackWIF^^[NumFor].tpRec OF
			0: {While}
				BranchEtiq(StackWIF^^[NumFor].EtWhile, $6000);
				
			1: {for}
				BranchEtiq(StackWIF^^[NumFor].EtForInc,$6000);
			
			3: {repeat/until}
				BranchEtiq(StackWIF^^[NumFor].EtUntil,$6000);
		END;	{ CASE }
		
	END;	{ sContinue }

PROCEDURE Swend(e: TParamPtr);

	BEGIN
		{$IFC GenAsm}
		IF FlagCC THEN WriteLn('; ENDWHILE');
		{$ENDC}
		{ on saute au While }
		BranchEtiq(StackWIF^^[NumWIF].EtWhile, $6000);
		{$IFC GenAsm}
		IF FlagCC THEN WriteLn('   bra While');
		{$ENDC}
		{ on genere l'etiquette du EndWhile }
		DefEtiq(StackWIF^^[NumWIF].EtEndWhile, Pc);
		{on depile un RecWIFet}
		SubWIF;
	END;


PROCEDURE SRepeat(e: TParamPtr);

BEGIN
	{ on défini l'étiquette pour les UNTIL }
	NewWIF(3);
	NewEtiq(TRUE,pc);
	StackWIF^^[NumWIF].EtRepeat := NumEtiq;		{ étiquette du REPEAT }
	NewEtiq(false, 0);
	StackWIF^^[NumWIF].EtUntil := NumEtiq;		{ étiquette du UNTIL (pour les CONTINUE) }
	NewEtiq(false, 0);
	StackWIF^^[NumWIF].EtUntilEnd := NumEtiq;	{ étiquette du UNTIL (pour les BREAK) }
END;


PROCEDURE SUntil(e:TParamPtr);

VAR ex:TParamPtr;

BEGIN
	{ on genere l'etiquette du UNTIL (continue)}
	DefEtiq(StackWIF^^[NumWIF].EtUNTIL, Pc);

	ex:=e;
	{ évaluation de la condition du UNTIL }
	NextCompToken (e, sizeOf(TDummy)+2);
	NumExprXCuteDx(e,0);	{ résultat condition -> D0 }
	AddCode1($4A80);			{ TST.L D0 }
	BranchEtiq(StackWIF^^[NumWIF].EtRepeat, $6700);
	
	{ on genere l'etiquette du UNTIL (break)}
	DefEtiq(StackWIF^^[NumWIF].EtUNTILend, Pc);
	{on depile un RecWIFet}
	SubWIF;
END;


PROCEDURE Snext(e: TParamPtr);

	BEGIN
		{$IFC GenAsm}
		IF FlagCC THEN WriteLn('; NEXT');
		{$ENDC}
		{ on saute a l'incrementation du for }
		BranchEtiq(StackWIF^^[NumWIF].EtForInc, $6000);
		{$IFC GenAsm}
		IF FlagCC THEN WriteLn('   bra EtForInc');
		{$ENDC}
		{ on genere l'etiquette du Next }
		DefEtiq(StackWIF^^[NumWIF].EtEndFor, Pc);
		{on depile un RecWIFet}
		SubWIF;
	END;

PROCEDURE Sreturn(e: TParamPtr);

	BEGIN
		{$IFC GenAsm}
		IF FlagCC THEN
			BEGIN
			WriteLn('; RETURN');
			WriteLn('  move.l (SP)+,A1'); { adresse retour }
			WriteLn('  move.l (SP)+,D0'); { numero ecran }
			WriteLn('  move.l D0,TheNScreen(A4)'); { on le sauvegarde }
			WriteLn('  lsl.l #3,D0	; ≈ *8'); { on calcule l'offset ecran videotex }
			WriteLn('  move.l OffScreen(A4),A0');
			WriteLn('  move.l 4(A0,D0.L),TheVScreen(A4)'); { mise a jour offset ecran videotex }
			WriteLn('  jmp (A1)'); { saut a l'appelant }
			END;
		{$ENDC}

		 { dans la pile, on a:
					• adresse de retour
					• numero du code de retour
		 }
		AddCode2($225F, $201F);
		AddCode2($2940, TheNCst);
		AddCode1($E788);
		AddCode2($206C, TheSCst);
		AddCode2($2970, $0804);
		AddCode2(TheVCst, $4ED1);
	END;


{==============================================================================}
{ 						R O U T A G E 						 }
{==============================================================================}

PROCEDURE ListeXCute(e: TParamPtr);

	VAR
		NStartEt: Integer;
		xpc: Longint;
		prompt: Str255;

	FUNCTION CheckIRem(e: TParamPtr): Boolean;

		BEGIN
			CheckIRem := (e^.tk = TkRem);
		END;

	FUNCTION CheckLRem(e: TParamPtr): Boolean;

		BEGIN
			IF e^.nbparam > 1 THEN
				BEGIN
				NextCompToken(e, Sizeof(TDummy) + 2);
				NextCompToken(e, e^.LParam); { token listint, formatage }
				CheckLRem := CheckIRem(e);
				END
			ELSE
				CheckLRem := false;
		END;

	BEGIN { executer la liste }
	
{$IFC DebugCode}
				AddCode1($A9FF);	{ _Debugger en début de module… }
{$ENDC}

		LastLine := 0;
		LastInst := 0;
		NL := 0;
		
		{ la trace est ici }
		{ ... }
		xpc := Pc;
		NewEtiq(TRUE, 0);
		NStartEt := NumEtiq;
		CompFlag := 0;					{ compteur pour les TRACEBEGIN/TRACEEND }
		IF e^.LParam = 0 THEN
			BEGIN
			Sreturn(e);
			{$IFC GenAsm}
			IF FlagCC THEN WriteLn('; Fin Generation de code') {else WWlnStr('')} ;
			{$ENDC}
			IF IncList THEN
				BEGIN
				TraceLn;
				TraceStr(GetMessage(38));
				TraceN(Pc - xpc, 0, false);
				TraceStrLn(getmessage(39));
				TraceLn;
				END;
			EXIT(ListeXCute); { fin physique du code }
			END;
		WHILE TRUE DO
			BEGIN
			{$IFC GenAsm}
			IF FlagCC THEN
				WriteLn('; ==========Ligne')
			ELSE
			{$ENDC}
			BEGIN
				nl := nl + 1;
				IF CompFlag=0 THEN Stat := Stat + 1;
				IF IncList & (PreCompFlag=FALSE) THEN
				BEGIN
					TraceN(nl, 4, TRUE);
					TraceStr(' ');
					TraceHN(OffPc + Pc, 6, TRUE);
					TraceStr('  ');
					{ on detokenize et on imprime la ligne }
					SetHSize(Handle(Resliste), e^.LParam);
					BlockMoveData(Ptr(e), Ptr(Resliste^), e^.LParam);
					Detokenize;
					IF PreCompFlag=FALSE THEN TraceStrLn(TempOut);
				END;
			END;
			NextCompToken(e, Sizeof(TDummy) + 2);
			NextCompToken(e, e^.LParam); { token listint, formatage }
			IF e^.LParam = 0 THEN
			BEGIN
				Sreturn(e);
				{$IFC GenAsm}
				IF FlagCC THEN WriteLn('; Fin Generation de code') {else WWlnStr('');} ;
				{$ENDC}
				IF IncList THEN
				BEGIN
					TraceLn;
					TraceStr(GetMessage(38));
					TraceN(Pc - xpc, 0, false);
					TraceStrLn(GetMessage(39));
					TraceLn;
				END;
				EXIT(ListeXCute); { fin physique du code }
			END;
			NInst := 0;
			WHILE (e^.tk <> tkliste) & (ErrFlag=FALSE) DO
			BEGIN
				NInst := NInst + 1;
				InstXCute(e);
				IF ErrFlag OR (NOT runFlag) THEN EXIT(ListeXCute);
				NextCompToken(e, e^.LParam);
				IF e^.LParam = 0 THEN
				BEGIN
					Sreturn(e);
					{$IFC GenAsm}
					IF FlagCC THEN
						WriteLn('; Fin Generation de code') {else WWlnStr('');} ;
					{$ENDC}
					IF IncList THEN
					BEGIN
						TraceLn;
						TraceStr(GetMessage(38));
						TraceN(Pc - xpc, 0, false);
						TraceStrLn(GetMessage(39));
						TraceLn;
					END;
					EXIT(ListeXCute); { fin physique du code }
				END;
			END;
		END;
END;

{==============================================================================}

PROCEDURE CallGen(e: TParamPtr; Fonc, KeepResult: Boolean);

	VAR
		Numvar, Num1, Totp: Longint;
		thep: ARRAY [1..MaxParams] OF Integer;
		OffTp: Integer;
		j, nb: Integer;
		ex: TParamPtr;
		dexcFlag: INTEGER;
		
	PROCEDURE CheckTpStr;

		BEGIN
			IF (ex^.tk IN [TkEq..TkDiff]) THEN OffTp := 6;
		END;

	BEGIN
		OffTp := 0;
		nb := e^.nbparam;
		ex := e;
		
		IF e^.tk <= NbTokens THEN
			NextCompToken(e, Sizeof(TDummy) + 2)
		ELSE
			BEGIN	{ •••• cas particulier des routines externes •••• }
				NextCompToken(e, Sizeof(TDummy) + Sizeof(ExtRec) - SizeOf(TNextI));
			END;
			
		IF Mots^^[ex^.tk].tFunc IN [fcnum, fnum] THEN
		BEGIN
				AddCode1($42A7);	{ place pour le retour du résult. numérique }
				{$IFC GenAsm}
				IF FlagCC THEN WriteLn('    clr.l  -(SP)');
				{$ENDC}
		END;
		
		{ preparer les arguments }
		Totp := 0;
		FOR j := 1 TO MaxParams DO thep[j] := 0;
		{ éval. de la taille des arg. sur la pile (chaines temporaires) }
		FOR j := 1 TO nb DO
		BEGIN
			IF (Mots^^[e^.tk].tfunc IN [fstr, fcstr]) THEN
			BEGIN
				thep[j] := Totp;
				IF Fonc THEN thep[j] := thep[j] + 4;
				Totp := Totp + 256;
			END;
			NextCompToken(e, e^.LParam);
		END;
		
		IF Totp > 0 THEN	{ il y a des chaînes temporaires à allouer }
		BEGIN
			IF Fonc THEN
			BEGIN
				AddCode1($205F);
				{$IFC GenAsm}
				IF FlagCC THEN WriteLn('    movea.l (SP)+,A0');
				{$ENDC}
			END;
			IF Totp<32767 THEN
				AddCode2($9EFC,Totp)		{ suba.w	#Totp,SP }
			ELSE
				AddCode3($9FFC, Totp);	{ suba.l  #Totp,SP }

			StackEval(Totp + 10);
			IF Fonc THEN
			BEGIN
				AddCode1($2F08);	{ adresse chaine de retour }
				{$IFC GenAsm}
				IF FlagCC THEN WriteLn('    move.l A0,-(SP)');
				{$ENDC}
			END;
		END;
		
		e := ex;
		
		{ on met l'addresse de la JumpTable sur la pile pour les rout. externes (1er paramètre!)
			qui font des callbacks dans Dragster 'DEXC' }
		IF (e^.tk > NbTokens) & (Mots^^[e^.tk].TypeExt = ExtType2) THEN
		BEGIN
			AddCode1($2F0B);	{ MOVE A3,-(SP) }
			dexcFlag := 4;
		END
		ELSE
			dexcFlag := 0;

		{ evaluation des arguments }
		IF e^.tk <= NbTokens THEN	{ •••• cas particulier des routines externes •••• }
			NextCompToken(e, Sizeof(TDummy) + 2)
		ELSE
			NextCompToken(e, Sizeof(TDummy) + Sizeof(ExtRec) - SizeOf(TNextI));

		FOR j := 1 TO nb DO
			BEGIN
			CASE Mots^^[e^.tk].tfunc OF { type du parametre effectif }
				fnum, fcnum, fpar, fcstnum: NumExprXCute(e);	{ expression numérique }
				
				fvarstr, fvarnum, fistrvar, finumvar:		{ variables }
				BEGIN
					IF (Mots^^[e^.tk].tfunc = fvarstr) OR (Mots^^[e^.tk].tfunc =
						 fistrvar) THEN CheckTpStr;
					IF ((Mots^^[ex^.tk].tparms[j] = fexpnum) OR (Mots^^[ex^.tk].tfunc =
						 fcnum)) AND ((Mots^^[e^.tk].tfunc = fvarnum) OR
						 (Mots^^[e^.tk].tfunc = finumvar)) THEN
						NumExprXCute(e) { demande explicite de non var numerique }
					ELSE
						PAdrVar(e);
				END;
				
				fcststr:	{ constante chaine }
				BEGIN
					UseCst(e^.indir);
					IF TheICsts^^[e^.Indir] < 32767 THEN
					BEGIN
						AddCode2($206C, TheCCst);
						IF TheICsts^^[e^.Indir]<>0 THEN
							AddCode2($4868, TheICsts^^[e^.Indir])	{ PEA xxx(A0) !!! }
						ELSE
							AddCode1($4850);	{ PEA (A0) !!! }
					END
					ELSE
					BEGIN
						AddCode2($206C, TheCCst);									{ move.l GCst(A4),A0 }
						IF (TheICsts^^[e^.Indir]>127) | (TheICsts^^[e^.Indir]<-128) THEN
							AddCode3($203C, TheICsts^^[e^.Indir])		{ move.l #TheICsts^^[e^.Indir],D0 }
						ELSE
							AddCode1($7000+TheICsts^^[e^.Indir]);		{ moveq #TheICsts^^[e^.Indir],D0 }
						AddCode2($4870, $0800);										{ pea (DO.L,A0) }
					END;
					CheckTpStr;
				END;
				
				fcstr, fstr:	{ calcul ou fonction chaîne }
				BEGIN
					CheckTpStr;
					IF (thep[j]) + (j - 1) * 4 + dexcFlag <>0 THEN
						AddCode2($486F, (thep[j]) + (j - 1) * 4 + dexcFlag)	{ PEA xx(SP) !!! }
					ELSE
						AddCode1($4857);	{ PEA (SP) !!! }
					StrExprXCute(e);
					IF (thep[j]) + (j - 1) * 4 + dexcFlag <>0 THEN
						AddCode2($486F, (thep[j]) + (j - 1) * 4 + dexcFlag)	{ PEA xx(SP) !!! }
					ELSE
						AddCode1($4857);	{ PEA (SP) !!! }
				END;
			END; {case}
			NextCompToken(e, e^.LParam); {parametre suivant}
		END; {begin}
		
		{ appel a la fonction }
		e := ex;

		IF e^.tk > NbTokens THEN { •••• appel routine externe •••• }
		BEGIN
			{ appel de la routine externe via la JumpTable }
			CallJump(NbTokens+CallExtToken(e^.tk)+2-OffRT);
		END
		ELSE
			CallJump(Mots^^[e^.tk].JumpCode + OffRT + OffTp);
		
		IF Totp > 0 THEN
		BEGIN
			{ recup resultat fonction }
			IF KeepResult THEN
				AddCode1($205F);					{ movea.l (SP)+,A0 }

			IF Totp<32767 THEN
				AddCode2($DEFC,Totp)			{ adda.w	#Totp,SP }
			ELSE
				AddCode3($DFFC,Totp);			{ adda.l	#Totp,SP }
				
			StackEval(-Totp-10);
			{ restore resultat fonction }
			IF KeepResult THEN
				AddCode1($2F08);					{ movea.l A0,-(SP) }
		END;
		
		IF e^.tk > NbTokens THEN	{ •••• appel routine externe •••• }
			IF Mots^^[e^.tk].tFunc IN [fCStr, fStr] THEN
				AddCode2($DEFC,$0004);		{ ADDA.W	#$04,A7 }
				
	END;

{==============================================================================}

PROCEDURE ParamGen(e: TParamPtr);

VAR
	Numvar, Num1, Totp: Longint;
	thep: ARRAY [1..5] OF Integer;
	j, nb: Integer;
	ex: TParamPtr;
	fonc: BOOLEAN;
	
	BEGIN
		nb := e^.nbparam;	{ nombre de paramètres à préparer }
		ex := e;

		NextCompToken(e, Sizeof(TDummy) + 2);
		
		FOR j := 1 TO nb DO
		BEGIN
			CASE Mots^^[e^.tk].tfunc OF { type du parametre effectif }
				fnum, fcnum, fpar, fcstnum: NumExprXCute(e);
				fvarstr, fvarnum, fistrvar, finumvar:
					IF ((Mots^^[ex^.tk].tparms[j] = fexpnum) OR (Mots^^[ex^.tk].tfunc =
						 fcnum)) AND ((Mots^^[e^.tk].tfunc = fvarnum) OR
						 (Mots^^[e^.tk].tfunc = finumvar)) THEN
						NumExprXCute(e) { demande explicite de var numerique }
{$IFC DEBUG}
					ELSE
						DebugStr('Mauvais passage de param dans ParamGen');
{$ELSEC}
					;
{$ENDC}
			END; {case}
			NextCompToken(e, e^.LParam); {parametre suivant}
		END; {begin}
	END;	{ ParamGen }

{==============================================================================}


PROCEDURE PAdrVar(e: TParamPtr);
{ met l'adresse d'une variable sur la pile }

	VAR
		AdNum, NumIndice: Longint;
		Numvar: Integer;
		ex: TParamPtr;
		L: LONGINT;
		
	BEGIN
		{ variable num ou str }
		ex := e;
		
		CASE Mots^^[e^.tk].tfunc OF
		
			fvarnum, fvarstr:
			BEGIN
				Numvar := TheCVars^^[e^.Indir].Indir;
				IF TheGVars^^.Vars[Numvar].Shared THEN
				BEGIN
					AddCode2($206C, TheAGCst);		{ move.l GVar(A4),A0 }
					IF TheGVars^^.Vars[Numvar].OffsetVar < 32767 THEN
					BEGIN
						IF TheGVars^^.Vars[Numvar].OffsetVar<>0 THEN
							AddCode2($4868, TheGVars^^.Vars[Numvar].OffsetVar)	{ PEA xx(A0) !! }
						ELSE
							AddCode1($4850);	{ PEA (A0) !! }
					END
					ELSE
					BEGIN
						{ adda.l #', TheGVars^^.Vars[Numvar].OffsetVar,a0' }
						AddCode3($D1FC, TheGVars^^.Vars[Numvar].OffsetVar);
						AddCode1($2F08);		{ move.l A0,-(SP) }
					END;
				END
				ELSE
				BEGIN
					IF TheGVars^^.Vars[Numvar].OffsetVar < 32767 THEN
					BEGIN
						{ pea TheGVars^^.Vars[Numvar].OffsetVar(A2) }
						AddCode2($486A, TheGVars^^.Vars[Numvar].OffsetVar);
					END
					ELSE
					BEGIN
						AddCode1($2F0A);		{ move.l A2,-(SP) }
							
						IF TheGVars^^.Vars[Numvar].OffsetVar>0 THEN
						BEGIN
							{ addi.l #TheGVars^^.Vars[Numvar].OffsetVar,(SP) }
							AddCode3($0697, TheGVars^^.Vars[Numvar].OffsetVar);
						END;
					END;
				END;
			END;	{ fVarNum, fVarStr }
			
			finumvar, fistrvar:
			BEGIN
				NextCompToken(ex, Sizeof(TDummy) + 2);
				Numvar := TheCVars^^[ex^.Indir].Indir;
				NextCompToken(ex, ex^.LParam);
				
				{ 9/12/94 - optimisation des indices de tableau constants }
				IF Mots^^[ex^.tk].tfunc=fcstnum THEN	{ on contrôle l'indice lors de la compil }
				BEGIN
					{ contrôle de dépassement de tableau… }
					IF (ex^.Num < 0) OR (ex^.Num > TheGVars^^.Vars[Numvar].DimVal-1) THEN
					BEGIN
						Sysbeep(60);
						WWLnStr(ParamMessage(57,TheGScreen^^.TheScreens[NumCode].NomScreen^^, NumToStr(NL), NumToStr(TheGVars^^.Vars[Numvar].DimVal-1), NumToStr(ex^.Num)));
					END;
					{ calcul de l'offset de l'élément }
					IF Mots^^[e^.tk].tfunc = finumvar THEN
						L := ex^.Num * 4			{ tableau de nombres }
					ELSE
						L := ex^.Num * 256;	{ tableau de chaines }
					L := L + TheGVars^^.Vars[Numvar].OffsetVar;
					IF (L>127) | (L<-128) THEN
						AddCode3($203C, L)				{ MOVE.L	cst,D0 }
					ELSE
						IF L>=0 THEN
							AddCode1($7000+L)				{ MOVEQ #cst,D0 }
						ELSE
							AddCode1($7000+256+L);	{ MOVEQ #cst,D0 }
				END
				ELSE
				BEGIN
					NumExprXCuteDx(ex,0);	{ évaluation de l'indice, résultat dans D0 }
	
					{ CHECK ARRAY }
					IF IncCheck THEN
					BEGIN
						IF TheGVars^^.Vars[Numvar].DimVal > 0 THEN
							AddCode2($41BC, TheGVars^^.Vars[Numvar].DimVal - 1)
							{ CHK	#maxbound,D0 }
						ELSE
							IF IncList THEN
							BEGIN
								TraceStrLn(ParamMessage(40,TheGVars^^.Vars[Numvar].NomVar,'','',''));
								GWarn := GWarn + 1;
								LWarn := LWarn + 1;
							END;
					END;
						
					IF Mots^^[e^.tk].tfunc = finumvar THEN
						AddCode1($E588)		{ lsl.l  #2,d0 }
					ELSE
						AddCode1($E188);	{ lsl.l  #8,D0 }
	
					IF TheGVars^^.Vars[Numvar].OffsetVar<>0 THEN
					BEGIN
						AddCode3($0680, TheGVars^^.Vars[Numvar].OffsetVar);
						{ add.l  #TheGVars^^.Vars[Numvar].OffsetVar,D0 }
					END;
				END;
				
				IF TheGVars^^.Vars[Numvar].Shared THEN
				BEGIN
					AddCode2($206C, TheAGCst);	{ move.l GVar(A4),A0 }
					AddCode2($4870, $0800);			{ pea (A0,D0.L) }
				END
				ELSE
					AddCode2($4872, $0800);			{ pea (A2,D0.L) }
			END;
		END;
	END;

{==============================================================================}

PROCEDURE AdrA0(e: TParamPtr);
{ met l'adresse d'une variable dans A0 }

VAR
	AdNum, NumIndice: Longint;
	Numvar: Integer;
	ex: TParamPtr;
	L: LONGINT;
	
BEGIN
	{ variable num ou str }
	ex := e;
	CASE Mots^^[e^.tk].tfunc OF
		fvarnum, fvarstr:
		BEGIN
			Numvar := TheCVars^^[e^.Indir].Indir;
			IF TheGVars^^.Vars[Numvar].Shared THEN
			BEGIN
				AddCode2($206C, TheAGCst);	{ move.l GVar(A4),A0 }
				IF TheGVars^^.Vars[Numvar].OffsetVar < 32767 THEN
				BEGIN
					AddCode2($41E8, TheGVars^^.Vars[Numvar].OffsetVar);
					{ lea TheGVars^^.Vars[Numvar].OffsetVar(A0),A0 }
				END
				ELSE
				BEGIN
					{ adda.l #TheGVars^^.Vars[Numvar].OffsetVar,a0' }
					AddCode3($D1FC, TheGVars^^.Vars[Numvar].OffsetVar);
				END;
			END
			ELSE
			BEGIN
				IF TheGVars^^.Vars[Numvar].OffsetVar < 32767 THEN
				BEGIN
					AddCode2($41EA, TheGVars^^.Vars[Numvar].OffsetVar);
					{ lea TheGVars^^.Vars[Numvar].OffsetVar(A2),A0 }
				END
				ELSE
				BEGIN
					AddCode1($204A);	{ movea.l a2,a0 }
					{ adda.l #TheGVars^^.Vars[Numvar].OffsetVar,a0 }
					AddCode3($D1FC, TheGVars^^.Vars[Numvar].OffsetVar);
				END;
			END;
		END;
		
		finumvar, fistrvar:
		BEGIN
			NextCompToken(ex, Sizeof(TDummy) + 2);
			Numvar := TheCVars^^[ex^.Indir].Indir;
			NextCompToken(ex, ex^.LParam);
			
			{ 9/12/94 - optimisation des indices de tableau constants }
			IF Mots^^[ex^.tk].tfunc=fcstnum THEN	{ on contrôle l'indice lors de la compil }
			BEGIN
				{ contrôle de dépassement de tableau… }
				IF (ex^.Num < 0) OR (ex^.Num > TheGVars^^.Vars[Numvar].DimVal-1) THEN
				BEGIN
					SysBeep(60);
					WWLnStr(ParamMessage(57,TheGScreen^^.TheScreens[NumCode].NomScreen^^, NumToStr(NL), NumToStr(TheGVars^^.Vars[Numvar].DimVal-1), NumToStr(ex^.Num)));
				END;
				{ calcul de l'offset de l'élément }
				IF Mots^^[e^.tk].tfunc = finumvar THEN
					L := ex^.Num * 4			{ tableau de nombres }
				ELSE
					L := ex^.Num * 256;		{ tableau de chaines }
				L := L + TheGVars^^.Vars[Numvar].OffsetVar;
				IF (L>127) | (L<-128) THEN
					AddCode3($203C, L)				{ MOVE.L	cst,D0 }
				ELSE
					IF L>=0 THEN
						AddCode1($7000+L)				{ MOVEQ #cst,D0 }
					ELSE
						AddCode1($7000+256+L);	{ MOVEQ #cst,D0 }
			END
			ELSE
			BEGIN
				{ évaluation de l'indice, résultat dans D0 }
				NumExprXCuteDx(ex,0);

				{ CHECK ARRAY }
				IF IncCheck THEN
				BEGIN
					IF TheGVars^^.Vars[Numvar].DimVal > 0 THEN
						AddCode2($41BC, TheGVars^^.Vars[Numvar].DimVal - 1)
						{ CHK	#maxbound,D0 }
					ELSE IF IncList THEN
					BEGIN
						TraceStrLn(ParamMessage(40,TheGVars^^.Vars[Numvar].NomVar,'','',''));
						GWarn := GWarn + 1;
						LWarn := LWarn + 1;
					END;
				END;
				
				IF Mots^^[e^.tk].tfunc = finumvar THEN
					AddCode1($E588)		{ lsl.l  #2,d0 }
				ELSE
					AddCode1($E188);	{ lsl.l  #8,d0 }
					
				IF TheGVars^^.Vars[Numvar].OffsetVar<>0 THEN
				BEGIN
					AddCode3($0680, TheGVars^^.Vars[Numvar].OffsetVar);
					{ add.l  #TheGVars^^.Vars[Numvar].OffsetVar,D0 }
				END;
			END;	
			
			IF TheGVars^^.Vars[Numvar].Shared THEN
			BEGIN
				AddCode2($206C, TheAGCst);	{ move.l GVar(A4),A0 }
				AddCode2($41F0, $0800);			{ lea (A0,D0.L),A0 }
			END
			ELSE
				AddCode2($41F2, $0800);			{ lea (A2,D0.L),A0 }
		END;
	END;
END;


PROCEDURE VarToA7(e:TParamPtr);
{ met le contenu d'une variable numérique sur la pile }

VAR	NumVar: INTEGER;

BEGIN
	IF Mots^^[e^.tk].tfunc = fvarNum THEN	{ variable numérique… }
	BEGIN
		Numvar := TheCVars^^[e^.Indir].Indir;
		IF (TheGVars^^.Vars[Numvar].Shared=FALSE) & (TheGVars^^.Vars[Numvar].OffsetVar < 32767) THEN
		BEGIN
			{ on met directement la valeur sur la pile… }
			AddCode2($2f2a, TheGVars^^.Vars[Numvar].OffsetVar);	{ MOVE.L xxxx(A2),-(SP) }
			EXIT(VarToA7);
		END;
	END;
	AdrA0(e);					{ calcul adresse variable dans A0 }
	AddCode1($2F10);	{ move.l (A0),-(SP) }
END;	{ VarToA7 }


{==============================================================================}

PROCEDURE AffXCute(e: TParamPtr);

	VAR
		AdNum, NumIndice: Longint;
		Numvar: Integer;
		ex: TParamPtr;

	BEGIN
		{ variable num ou str }
		NextCompToken(e, Sizeof(TDummy) + 2);
		ex := e;
		CASE Mots^^[e^.tk].tfunc OF
			fvarnum, finumvar:
			BEGIN
				NextCompToken(e, e^.LParam);
				Numvar := TheCVars^^[ex^.Indir].Indir;
				IF (Mots^^[ex^.tk].tfunc=fVarNum)										{ variable numérique simple }
				 & (TheGVars^^.Vars[Numvar].Shared = FALSE) 				{ non SHARED }
				 & (TheGVars^^.Vars[Numvar].OffsetVar < 32767) THEN	{ offset < 32k }
				BEGIN
					IF Mots^^[e^.tk].tfunc = fcstnum THEN	{ 10/2/94 optim: affectation d'une constante }
					BEGIN
						IF e^.num=0 THEN	{ optim: affect. d'une constante nulle }
						BEGIN
							{ CLR.L xxx(a2) }
							AddCode2($42AA,TheGVars^^.Vars[Numvar].OffsetVar);
						END
						ELSE
						BEGIN
							{ MOVE.L #cst,OffsetVar(A2) }
							AddCode1($257C);																{ MOVE.L #xx,$yy(A2) }
							AddCodeL(e^.num);																{ la constante }
							AddCode1(TheGVars^^.Vars[Numvar].OffsetVar);		{ OffsetVar }
						END;
					END
					ELSE
					BEGIN
						{ évaluation de l'expression dans D0, puis stockage dans la variable }
						NumExprXCuteDx(e,0);	{ résultat -> D0 }
						AddCode2($2540, TheGVars^^.Vars[Numvar].OffsetVar);
						{ move.l D0,TheGVars^^.Vars[Numvar].OffsetVar(A2) }
					END;
				END
				ELSE
				BEGIN	
					{ 9/12/94 }
					NumExprXCuteDx(e,6);	{ met la valeur de l'expression dans D6 }
					AdrA0(ex);						{ calcule l'adresse de la var. et la met en A0 }
					AddCode1($2086);			{ met la valeur D6 dans la variable (A0)  move.l D6,(A0) }
(*
					NumExprXCute(e);			{ met la valeur de l'expression sur la pile }
					AdrA0(ex);						{ calcule l'adresse de la var. et la met en A0 }
					AddCode1($209F);			{ met la valeur (pile) dans la variable (A0)  move.l (A7)+,(A0) }
*)
				END;
			END;

			fistrvar,fvarstr:
			BEGIN
				NextCompToken(e, e^.LParam);
				IF (Mots^^[e^.tk].tFunc = fCstStr) & (TheCCsts^^[e^.Indir]='') THEN { optim: xx$="" }
				BEGIN
					IF (Mots^^[ex^.tk].tFunc = fVarStr)
					 & (TheGVars^^.Vars[TheCVars^^[ex^.Indir].Indir].OffsetVar<32767) THEN	{ 10/2/94 }
					BEGIN
						{ optim: CLR.B xxx(A2) }
						AddCode2($422A,TheGVars^^.Vars[TheCVars^^[ex^.Indir].Indir].OffsetVar);
					END
					ELSE
					BEGIN
						AdrA0(ex);						{ adresse de la variable dans A0 }
						AddCode1($4210);			{ CLR.B (A0) (remet la longueur à 0) }
					END;
				END
				ELSE
				BEGIN
					PAdrVar(ex);					{ met l'adresse de la var. sur la pile }
					StrExprXCute(e);			{ évalue la partie "droite" de l'affectation }
				END;
			END;

		END;
	END;

PROCEDURE NumExprXCute(e: TParamPtr);
{ évalue une valeur numérique: résultat sur la pile }

	VAR
		Num1, Numvar: Longint;

	BEGIN
		CASE Mots^^[e^.tk].tfunc OF
		
			fvarnum,finumvar: { on va chercher la valeur de la variable }
				VarToA7(e);
			
			fcstnum: { on donne la valeur de la constante numérique }
			BEGIN
				IF e^.Num = 0 THEN
					AddCode1($42A7)												{ CLR.L -(A7) }
				ELSE
					IF (e^.Num>127) | (e^.Num<-128) THEN
						AddCode3($2F3C, e^.num)							{ MOVE.L	cst,-(A7) }
					ELSE
						IF e^.Num>0 THEN
							AddCode2($7000+e^.Num,$2F00)			{ MOVEQ #cst,D0 ; MOVE.L D0,-(A7) }
						ELSE
							AddCode2($7000+256+e^.Num,$2F00);	{ MOVEQ #cst,D0 ; MOVE.L D0,-(A7) }
			END;
			
			fpar: { on donne la valeur dans les parentheses }
			BEGIN
				NextCompToken(e, Sizeof(TDummy) + 2);
				NumExprXCute(e);
			END;
			
			fcnum, fnum: { fonction numerique } {en fonction des parametres}
			BEGIN
				{ on génère directement le code ? }
				IF e^.tk IN [TkPlus,TkMoins,TkNeg,tkAbs] THEN
				BEGIN
					ParamGen(e);			{ on génère les params. sur la pile }
					CASE e^.Tk OF			{ on génère le code correspondant au token }
						tkPlus:
							AddCode3($201F,$D0972E80);		{ MOVE.L	(A7)+,D0; ADD.L	(A7),D0; MOVE.L D0,(A7) }
						
						tkMoins:
						BEGIN
							AddCode3($202F,$0004909F);
							AddCode1($2E80);		{ MOVE.L	4(A7),D0; SUB.L	(A7)+,D0; MOVE.L D0,(A7) }
						END;
						
						tkNeg:		AddCode1($4497);							{ NEG.L		(A7) }
						
						tkAbs:		AddCode3($4A97,$6A024497);		{ TST.L		(A7);  BPL.S *+4; NEG.L (A7) }
					END
				END
				ELSE
					CallGen(e, TRUE, TRUE);		{ appel normal }
			END;	{ fcNum, fNum }
		END;	{ CASE }
	END;	{ NumExprXCute }


PROCEDURE NumExprXCuteDx(e: TParamPtr; x: INTEGER);
{ évalue une valeur numérique: résultat dans Dx }

	VAR
		Num1, Numvar: Longint;

	BEGIN
		CASE Mots^^[e^.tk].tfunc OF
		
			fvarnum: { on va chercher la valeur de la variable }
			BEGIN
				Numvar := TheCVars^^[e^.Indir].Indir;
				IF (TheGVars^^.Vars[Numvar].Shared=FALSE) & (TheGVars^^.Vars[Numvar].OffsetVar < 32767) THEN
				BEGIN
					{ on met directement la valeur sur la pile… }
					AddCode2($202A+$200*x, TheGVars^^.Vars[Numvar].OffsetVar);	{ MOVE.L xxxx(A2),Dx }
				END
				ELSE
				BEGIN
					AdrA0(e);					{ calcul adresse variable dans A0 }
					AddCode1($2010+$200*x);	{ move.l (A0),Dx }
				END;
			END;
			
			finumvar:
			BEGIN
				AdrA0(e);					{ calcul adresse variable dans A0 }
				AddCode1($2010+$200*x);	{ move.l (A0),Dx) }
			END;
			
			fcstnum: { on donne la valeur de la constante numérique }
			BEGIN
				IF (e^.Num>127) | (e^.Num<-128) THEN
					AddCode3($203C+$200*x, e^.num)							{ MOVE.L	cst,Dx }
				ELSE
					IF e^.Num>=0 THEN
						AddCode1($7000+e^.Num+$200*x)				{ MOVEQ #cst,Dx }
					ELSE
						AddCode1($7000+256+e^.Num+$200*x);	{ MOVEQ #cst,Dx }
			END;
			
			fpar: { on donne la valeur dans les parentheses }
				BEGIN
					NextCompToken(e, Sizeof(TDummy) + 2);
					NumExprXCute(e);
					AddCode1($201F+$200*x);					{ MOVE.L (A7)+,Dx ; résultat dans Dx SVP }
				END;
				
			fcnum, fnum: { fonction numerique } {en fonction des parametres}
				BEGIN

					{ on génère directement le code ? }
					IF e^.tk IN [TkPlus,TkMoins] THEN
					BEGIN
						ParamGen(e);			{ on génère les params. sur la pile }
						CASE e^.Tk OF			{ on génère le code correspondant au token }
							tkPlus:
								AddCode2($201F+$200*x,$D097+$200*x);		{ MOVE.L	(A7)+,Dx; ADD.L	(A7),Dx }
							
							tkMoins:
							BEGIN
								AddCode3($202F+$200*x,$0004909F+$200*x);{ MOVE.L	4(A7),Dx; SUB.L	(A7)+,Dx }
							END;
						END;
						{ on retire le deuxième param. de la pile }
						AddCode1($584F);	{ ADDQ #4,A7 }
					END
					ELSE
					BEGIN
						CallGen(e, TRUE, TRUE);		{ appel normal }
						AddCode1($201F+$200*x);		{ MOVE.L (A7)+,Dx ; résultat dans Dx SVP }
					END;
				END;
		END;
	END;


PROCEDURE StrExprXCute(e: TParamPtr);
{ évalue une expression chaine: résultat mis à l'adresse qui se trouve déjà sur la pile }

	VAR
		Numvar, Num1: Longint;
		thep: ARRAY [1..5] OF Integer;

	BEGIN
		CASE Mots^^[e^.tk].tfunc OF
			fvarstr, fistrvar: { on va chercher le pointeur sur la variable }
			BEGIN
				AdrA0(e);						{ adresse chaine résultat dans A0 }
				AddCode1($225F);		{ move.l (SP)+,A1 }
				AddCode1($7000);		{ moveq	#0,D0 		; pour remettre D0 complètement à 0 }
				AddCode1($1010);		{ move.b (A0),D0 	; longueur de la chaine à recopier de A0 vers A1 }
				AddCode3 ($12D8, $51C8FFFC);	{ MOVE.B (A0)+,(A1)+, DBF D0 }
			END;
			
			fcststr: { on donne la valeur de la constante }
			BEGIN
				UseCst(e^.indir);
				IF TheICsts^^[e^.Indir] < 32767 THEN
				BEGIN
					AddCode2($206C, TheCCst);								{ move.l GCst(A4),A0 }
					IF TheICsts^^[e^.Indir]>0 THEN
						AddCode2($41E8, TheICsts^^[e^.Indir])	{ lea offsetCst(A0),A0 }
					ELSE
						AddCode1($41D0);											{ lea (A0),A0 }
				END
				ELSE
				BEGIN
					AddCode2($206C, TheCCst);								{ move.l GCst(A4),A0 }
					AddCode3($203C, TheICsts^^[e^.Indir]);	{ move.l #offsetCst,D0 }
					AddCode2($41F0, $0800);									{ lea (DO.L,A0),A0 }
				END;

				AddCode1($225F);		{ move.l (SP)+,A1 }
				AddCode1($7000);		{ moveq	#0,D0 		; pour remettre D0 complètement à 0 }
				AddCode1($1010);		{ move.b (A0),D0 	; longueur de la chaine à recopier de A0 vers A1 }
				AddCode3 ($12D8, $51C8FFFC);	{ MOVE.B (A0)+,(A1)+, DBF D0 }
			END;
			
			fstr, fcstr: { fonction chaine } {en fonction des parametres}
				CallGen(e, TRUE, false);
		END;
	END;

{========================= DIRECTIVES DE COMPILATION ==========================}

PROCEDURE DecExec(e:TParamPtr);

VAR	i: INTEGER;

BEGIN
	NextCompToken(e,Sizeof(TDummy) + 2);	{ constante de condition }
	FOR i := 1 TO NbCompCond DO
		IF CompCondTable[i]=e^.indir THEN EXIT(DecExec);
	NbCompCond := nbCompCond+1;
	CompCondTable[NbCompCond]:=e^.indir;
END;


PROCEDURE IfExec(e:TParamPtr);

VAR	i:INTEGER;

BEGIN
	NextCompToken(e,Sizeof(TDummy)+2);	{ constante de condition }
	FOR i := 1 TO NbCompCond DO
		IF CompCondTable[i]=e^.indir THEN EXIT(IfExec);
	CompFlag := CompFlag+1;
END;


PROCEDURE EndifExec(e:TParamPtr);

BEGIN
	IF CompFlag>0 THEN CompFlag := CompFlag-1;
END;


{==============================================================================}

PROCEDURE ProcXCute(e: TParamPtr);

	VAR
		temp: Str255;
		nb, len, i: Integer;

	BEGIN { Executer la procedure ... }
		CASE e^.tk OF
			TkGosubScreen: GosubScreen(e, TRUE, false, false, false, false, false);
			TkGotoScreen: GosubScreen(e, false, TRUE, false, false, false, false);
			TkLoadScreen: GosubScreen(e, false, false, TRUE, false, false, false);
			TkDecScreen: GosubScreen(e, false, false, false, TRUE, false, false);
			TkDrawScreen: GosubScreen(e, false, false, false, false, TRUE, false);
			TkFPrint: Print(e, TRUE, false, TRUE); 	{ procedure generique }
			TkInPut: SInput(e); 										{ procedure generique }
			TkPrint: Print(e, false, false, false); { procedure generique }
			TkRead: SRead(e); 											{ procedure generique }
			TkWrite: Print(e, TRUE, TRUE, false);		{ procedure generique }
			
			{ Trace & C° }
			TkTrace: ; { pas de code généré }
			TkTron: ;	 { pas de code généré }
			TkTroff: ; { pas de code généré }
			
			{ compil conditionnelle }
			TkDecExec:		DecExec(e);
			TkIfExec: 		IfExec(e);
			TkEndifExec:	EndifExec(e);
			
			TkZone: SZone(e); 											{ appel special }
			TkBaseSeek: BaseSeek(e); 								{ appel special }
			TkWaitConnect: SWaitConnect(e); 				{ upward compatibility }
			OTHERWISE CallGen(e, false, false); 		{ parametres fixes }
		END;
	END;

{==============================================================================}

PROCEDURE ContXCute(e: TParamPtr);

	BEGIN { Executer la structure de controle }
		CASE e^.tk OF
			tkif: 			SIF(e);
			tkwhile:		SWhile(e);
			tkgoto:			SGoto(e);
			tkGosub:		SGosub(e);
			tkon:				SOn(e);
			tkfor:			Sfor(e);
			tkelse:			Selse(e);
			tkendif:		Sendif(e);
			tkbreak:		Sbreak(e);
			tkcontinue: Scontinue(e);
			tkWend:			Swend(e);
			tkNext:			Snext(e);
			tkreturn:		Sreturn(e);
			tkdim: ; { ne fait rien en compile }
			TkREPEAT:		SRepeat(e);
			TkUNTIL:		SUntil(e);
		END;
	END;

{==============================================================================}

PROCEDURE EtiqXCute(e: TParamPtr);

	BEGIN
		DefEtiq(TheCVars^^[e^.Indir].Indir, Pc);
	END;

{==============================================================================}
(*
PROCEDURE InstXCute(e: TParamPtr);

	BEGIN
		CASE Mots^^[e^.tk].tfunc OF
			fcNum:	AffXCute(e);
			fproc:	ProcXCute(e);
			fcont:	ContXCute(e);
			fuetiq:	EtiqXCute(e);
		END;
	END;
*)

PROCEDURE InstXCute(e: TParamPtr);

	VAR
		tpf: Integer;

	BEGIN
		IF (CompFlag=0) | (e^.tk=TkEndifExec) THEN	{ génération de code active ? }
		BEGIN
			tpf := Mots^^[e^.tk].tfunc;
			IF tpf = fcnum THEN
				AffXCute(e)
			ELSE IF tpf = fproc THEN
				ProcXCute(e)
			ELSE IF tpf = fcont THEN
				ContXCute(e)
			ELSE IF tpf = fuetiq THEN EtiqXCute(e);
		END;
	END;
