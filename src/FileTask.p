{$SETC Debug=FALSE}
{$SETC FLUSH=TRUE}

UNIT FileTask;

	INTERFACE

		USES MemTypes, QuickDraw, OSIntf, ToolIntf, PackIntf, AppleTalk, ADSP, TextUtils;

		PROCEDURE TheTask;

	IMPLEMENTATION

		USES Traps;

			{$D+} { procedure names in the code }
			{$R-} { pas de Range Checking }

			{$I DragsterTCB.p}

		CONST
			TaskQueue = FileQ; { numero de la queue du serveur }

			MaxOpFile = 100;		{ nombre max de fichiers ouverts a un instant donne }
			MaxPoolFile = 350;	{ nombre max de fichiers simultannes }
			
			FCBSPtr = $34E;			{ Pointer vers la table des FCBs (Var. Globale) }
			FCBLen = 94;

		TYPE
			Pstr255 = ^Str255;
			
			FName = STRING[MaxFileName];
			FNamePtr = ^FName;

			{Str31= String[31];} { path name }
			PStr31 = ^Str31;

			IntPtr = ^Integer;
			LIPtr = ^LONGINT;

			PoolIndex = Integer;

			TOpFile = ARRAY [1..MaxOpFile] OF PoolIndex;
			{ numeros des fichiers dans le pool }
			{ taille: 2 * MaxOpFile = 200 }

			TPoolFile = ARRAY [1..MaxPoolFile] OF
										RECORD
									TheName: FName; { nom du fichier }
									TheFRef: Integer; { file ref number }
									NbAccess: Integer; { nb acces simultanne }
									TCBLocker: TPtr; { TCBPtr du Locker}
									ResFlag: BOOLEAN; { indique si c'est la partie resource qui est utilisée }
									END; { taille: 88 * MaxPoolFile = 30800 }

		FUNCTION GetCurSt: TPtr;
		{ GetCurSt rend CurStPtr, qui pointe sur le TCB actif }
			EXTERNAL;

		PROCEDURE SwapTasks(AdRegs1, AdRegs2: Ptr);
		{ Sauvegarde contexte courant dans AdRegs1 et restaure AdRegs2 }
			EXTERNAL;

		PROCEDURE AsmCompletion;
		{ IOCompletion qui donne l'adresse de la tache appelante }
			EXTERNAL;

		PROCEDURE StrSetLen(TheStr: CharsPtr; TheLen: Integer);
		{ met la bonne longueur a la chaine }
			EXTERNAL;

		PROCEDURE WaitDelay(Num1: LONGINT);

			BEGIN
				WITH GetCurSt^ DO
					BEGIN
						IF Num1 <> 0 THEN
							BEGIN
								DelayValue := Num1;
								StatusWord := DelayCst;
							END;
						SwapTasks(@RegArea, @RegAreaF);
					END;
			END;

			
			FUNCTION str(num:LONGINT):Str255;
			
			VAR		temp:Str255;
						negatif: BOOLEAN;
						
			BEGIN
				Temp := '';
				negatif := (num<0);
				num := abs(num);
				WHILE Num<>0 DO
				BEGIN
					temp := concat(CHR($30+Num MOD 10),Temp);
					Num := Num DIV 10;
				END;
				IF Temp='' THEN Temp := '0';
				IF negatif THEN temp := concat('-',Temp);
				Str := Temp;
			END;
			
			
			FUNCTION hex(num:LONGINT):Str255;
			
			VAR		temp:Str255;
						negatif: BOOLEAN;
						
			BEGIN
				Temp := '';
				WHILE Num<>0 DO
				BEGIN
					IF Num MOD 16 > 9 THEN
						temp := concat(CHR($41-10+Num MOD 16),Temp)
					ELSE
						temp := concat(CHR($30+Num MOD 16),Temp);
					Num := Num DIV 16;
				END;
				IF Temp='' THEN Temp := '0';
				hex := Temp;
			END;


		FUNCTION NumOfFcb:INTEGER;
		
		CONST
			FCBSPtr = $34E;		{ Pointer vers la table des FCBs (Var. Globale) }
			FCBLen = 94;			{ longueur d'un FCB }
			
		
		TYPE
			FCB = RECORD
				flNum: LONGINT;
				flByt:INTEGER;
				SBlk: INTEGER;
				Eof: LONGINT;
				PLen: LONGINT;
				CrPs: LONGINT;
				VPtr: Ptr;
				BfAdr: LONGINT;
				FlPos: INTEGER;
				ClmpSize: LONGINT;
				BTCBPtr: LONGINT;
				ExtRec: PACKED ARRAY [1..12] OF CHAR;
				FType: LONGINT;
				CarPos: LONGINT;
				DirID: LONGINT;
				Name: STRING[32];
			END;
			
			FCBPtr = ^FCB;
			
		VAR
			MyFCBPtr: FCBPtr;
			X: INTEGER;
			FCBTable: LONGINT;
			FCBTableLen: INTEGER;
			nbUsed: INTEGER;
			
			BEGIN
				FCBTable := LongintPtr($34E)^;
				FCBTableLen := IntegerPtr(FCBTable)^ DIV FCBLen;
				nbUsed := 0;
				FOR X := 0 TO FCBTableLen -1 DO
				BEGIN
					MyFCBPtr := FCBPtr(FCBTable+2+X*FCBLen);
					IF MyFCBPtr^.flNum <> 0 THEN nbUsed := nbUsed+1;
				END;
				NumOfFCB := nbUsed;
			END;	{ NumOfFCB }


		PROCEDURE TheTask; { Tache Serveur Fichier }

			VAR
				ThePtr: TPtr;
				NbOFile: Integer;
				NbPFile: Integer;
				Pb: MyParamBlockRec;
				TheRequest: TQEPtr;
				TheFilePNum: Integer; { numero d'un fichier dans le pool }
				i: Integer;
				CurMaxOpFile: Integer; { nombre maxi de fichier que l'on s'autorise à ouvrir }
				theMac: SysEnvRec;
				nf:INTEGER;
				TheOFile: TOpFile;
				ThePFile: TPoolFile;
{$IFC FLUSH}
				LastFlush: LONGINT;	{ TickCount au dernier flush }


			PROCEDURE FlushAll;
			
			VAR
				Err: OsErr;
				pb: MyParamBlockRec;	{ PBGetVinfo / PBFlushVol }
				i: INTEGER;
				
			BEGIN
				{ on flush toutes les 30 secondes }
				IF TickCount<LastFlush+1800 THEN EXIT(FlushAll);
				LastFlush := TickCount;
				
				i:=0;
				REPEAT
					i := i+1;
					
					{ préparation du TCB pour I/O }
					WITH GetCurSt^ DO
					BEGIN
						IOCompFlag := 1;
						StatusWord := IOWaitCst;
					END;
					
					{ préparation du paramBlock pour I/O }
					WITH pb DO
					BEGIN
						TcbPtr := GetCurSt;
						ioCompletion := @AsmCompletion;
						ioNamePtr := NIL;
						iovRefNum := 0;
						ioVolIndex := i;	{ ième volume monté }
					END;
					Err := PBGetVInfoASync(@pb.qLink);
					WITH GetCurSt^ DO SwapTasks(@RegArea, @RegAreaF);
					
					IF Err=NoErr THEN	{ un volume à flusher }
					BEGIN
						WITH GetCurSt^ DO
						BEGIN
							ioCompFlag := 1;
							StatusWord := IOWaitCst;
						END;
						pb.ioCompletion := @AsmCompletion;
						IF PBFlushVolASync(@pb.qLink)=NoErr THEN;
						WITH GetCurSt^ DO SwapTasks(@RegArea, @RegAreaF);
					END;
				UNTIL err<>NoErr;
			END;
{$ENDC}


			PROCEDURE RechFName(TestFork, RF: BOOLEAN);

				VAR
					i: Integer;
					Termine: BOOLEAN;

				BEGIN
					WITH TheRequest^ DO
						IF length(Pstr255(MyParmBlkPtr(EParam1)^.ioNamePtr)^) > MaxFileName THEN
							BEGIN
												{
												DebugStr('FileTask: nom trop long');
												DebugStr(PStr255(MyParmBlkPtr(EParam1)^.ioNamePtr)^);
												}
								MyParmBlkPtr(EParam1)^.ioNamePtr^[0] := chr(MaxFileName);
							END;
					i := 0; Termine := False;
					WITH TheRequest^ DO
						WHILE (i < MaxPoolFile) AND (NOT Termine) DO
							BEGIN
								i := i + 1;
								WITH ThePFile[i] DO
									IF NbAccess > 0 THEN
										Termine := EqualString(Pstr255(Ord4(@TheName))^,
																					 Pstr255(MyParmBlkPtr(EParam1)^.ioNamePtr)^, False,
															 true) & (NOT TestFork | (ResFlag = RF));
																				{ on a fini si le nom est correct et que soit l'on se fiche de
																						quelle fork est active ou alors que c'est la bonne fork qui
																						est active }
							END;
					IF Termine THEN TheFilePNum := i
					ELSE TheFilePNum := 0;
				END;

			FUNCTION ValRequestFound: BOOLEAN; { trouve la prochaine requete valide }

				VAR
					XRequest: TQEPtr;
					Termine: BOOLEAN;

				BEGIN
				{ ATTENTION: on part du principe que tous les parametres
					d'appel au serveur sont bons. Le resultat d'une requete sera
					imprevisible si les parametres sont mauvais...
					Garbage in, garbage out }
					WITH ThePtr^.TheQueues^[TaskQueue] DO
						BEGIN
							TheRequest := QFirst; Termine := False;
							WHILE (TheRequest <> NIL) AND (NOT Termine) DO
								WITH TheRequest^ DO
									BEGIN
										{ requete possible ?}
										CASE ECode OF
											ReqRead, ReqWrite, ReqSetEof, ReqLock:
											{ si fichier non locke }
											{ ou user du lock }
											BEGIN
												WITH ThePFile[EMisc] DO
												BEGIN
													Termine := (TCBLocker = NIL) | (TCBLocker = EOwner);
{$IFC DEBUG}
IF Termine=FALSE THEN
	DebugStr(concat('EMisc=',str(EMisc),' TCBLocker=',hex(ORD4(TCBLocker)),' EOwner=',hex(ORD4(EOwner))));
{$ENDC}
												END;
											END;
											
											OTHERWISE { toujours possible }
												Termine := true;
												
										END; {case}

										IF NOT Termine THEN { requete suivante }
											BEGIN
												XRequest := TheRequest;
												TheRequest := TheRequest^.QLink;
											END;
									END;

							IF Termine THEN { on retire la requete de la queue  }
								BEGIN
									IF TheRequest = QFirst THEN
										BEGIN
											QFirst := QFirst^.QLink;
											IF QFirst = NIL THEN QEnd := NIL;
										END
									ELSE
										BEGIN
											XRequest^.QLink := TheRequest^.QLink;
											IF XRequest^.QLink = NIL THEN QEnd := XRequest;
										END;
									QNumber := QNumber - 1;
								END;

							ValRequestFound := Termine;
						END;
				END;

			PROCEDURE SetRunMode(NewMode: Integer);

				VAR
					SaveStatus: Integer;

				BEGIN
					WITH GetCurSt^ DO
						BEGIN
							SaveStatus := StatusWord;
							RunMode := NewMode;
							StatusWord := ReadyCst;
							WHILE CurRunMode > RunMode DO
								SwapTasks(@RegArea, @RegAreaF);
							StatusWord := SaveStatus;
						END;
				END;

			PROCEDURE DirectRequest;

				VAR
					Err: OSErr;
					ThePB: ParmBlkPtr;
					
				BEGIN
					WITH TheRequest^, ThePtr^ DO
						BEGIN
							ThePB := ParmBlkPtr(Ord4(EParam1) + 4);
							CASE ECode OF
								ReqOpen:
									BEGIN
										Err := PbOpenAsync(ThePB);
										WITH MyParmBlkPtr(EParam1)^ DO
											IF (ioFRefNum = - 7) OR (ioFRefNum = - 9) THEN
												BEGIN
													TcbPtr^.StatusWord := ReadyCst;
												END;
									END;
								ReqOpRsrc:	Err := PbOpenRFAsync(ThePB);
								ReqRead:		Err := PbReadAsync(ThePB);
								ReqWrite:		Err := PbWriteAsync(ThePB);
								ReqClose:		Err := PbCloseAsync(ThePB);
								ReqGetEof:	Err := PbGetEofAsync(ThePB);
								ReqSetEof:	Err := PbSetEofAsync(ThePB);
								ReqRename:	Err := PbHRenameAsync(HParmBlkPtr(ThePB));
								ReqDelete:	Err := PbHDeleteAsync(HParmBlkPtr(ThePB));
								ReqCreate:	Err := PbCreateAsync(ThePB);
								ReqGetFInfo:Err := PbHGetFInfoAsync(HParmBlkPtr(ThePB));
								ReqSetFInfo:Err := PbHSetFInfoAsync(HParmBlkPtr(ThePB));
								ReqOpWd:
									BEGIN
										SetRunMode(0);
										Err := PbOpenWdAsync(WdPbPtr(ThePB));
										SetRunMode(1);
									END;
								ReqClWd:
									BEGIN
										SetRunMode(0);
										Err := PbCloseWdAsync(WdPbPtr(ThePB));
										SetRunMode(1);
									END;
								ReqGetCat:		Err := PbGetCatInfoAsync(CInfoPBPtr(ThePB));
								ReqDirCreate:	Err := PbDirCreateAsync(HParmBlkPtr(ThePB));
								ReqFlush:			Err := PbFlushVolAsync(ThePB);
								ReqGetVol:		Err := PBGetVolAsync(ThePB);
								ReqSetVol:		Err := PBSetVolAsync(ThePB);
								ReqGetVInfo:	Err := PBGetVInfoASync(ThePB);
								ReqCatMove:		Err := PBCatMoveASync(CMovePBPtr(ThePB));
							END;

							WITH GetCurSt^ DO SwapTasks(@RegArea, @RegAreaF);
						END;
				END;

			PROCEDURE OpOpen(ThePoolIndex: Integer);

				VAR
					i: Integer;
					Err: OSErr;

				BEGIN
					WITH ThePFile[ThePoolIndex], ThePtr^ DO
						BEGIN
							IF NbOFile = CurMaxOpFile THEN
								BEGIN
									{ fermeture de NbOFile }
									IOCompFlag := 1;
									StatusWord := IOWaitCst;
									WITH Pb DO
										BEGIN
											ioCompletion := ProcPtr(Ord4(@AsmCompletion));
											ioRefNum := ThePFile[TheOFile[NbOFile]].TheFRef;
										END;
									nf := NumOfFCB;	{ nb de FCB occupés avant le CLOSE }
									Err := PbCloseAsync(@Pb.QLink); {CLOSE ASYNC}
									SwapTasks(@RegArea, @RegAreaF);

									ThePFile[TheOFile[NbOFile]].TheFRef := 0;	{ il est réellement fermé !! }
									NbOFile := NbOFile - 1;
								END;

							{ decalage des fichiers ouverts }
							FOR i := NbOFile DOWNTO 1 DO
								TheOFile[i + 1] := TheOFile[i];
							NbOFile := NbOFile + 1;

							{ ouverture de PoolIndex, si pas deja ouvert }
							IF TheFRef = 0 THEN
								BEGIN
									IOCompFlag := 1;
									StatusWord := IOWaitCst;
									WITH Pb DO
										BEGIN
											ioCompletion := ProcPtr(Ord4(@AsmCompletion));
											ioNamePtr := @TheName;
											ioVRefNum := 0;
											ioVersNum := 0;
											ioPermssn := fsRdWrPerm;
											ioMisc := NIL;
										END;
									IF ResFlag THEN Err := PbOpenRFAsync(@Pb.QLink)
									ELSE Err := PbOpenAsync(@Pb.QLink);
									SwapTasks(@RegArea, @RegAreaF);
									TheFRef := Pb.ioFRefNum;
								END;
							TheOFile[1] := ThePoolIndex;
						END; { WITH }
				END; {opOpen}


			PROCEDURE CloseAll;		{ ferme tous les fichiers encore ouverts… }
			
				VAR
					i: Integer;
					Err: OSErr;

			BEGIN
				WITH ThePtr^ DO
				BEGIN
					FOR i := 1 TO NbOFile DO
					BEGIN
						{ fermeture de NbOFile }
						IOCompFlag := 1;
						StatusWord := IOWaitCst;
						WITH Pb DO
							BEGIN
								ioCompletion := ProcPtr(Ord4(@AsmCompletion));
								ioRefNum := ThePFile[TheOFile[i]].TheFRef;
							END;
						Err := PbCloseAsync(@Pb.QLink); {CLOSE ASYNC}
						SwapTasks(@RegArea, @RegAreaF);
					END;
				END;
			END;
			
			
			PROCEDURE ServeRequest;

				VAR
					i, j, Err: Integer;

				BEGIN
					WITH TheRequest^, ThePtr^ DO
						BEGIN
							ZoneNumber := ECode;
							MaxTime := Ord4(EOwner);

							CASE ECode OF
								-1: { fermeture du serveur… }
								BEGIN
									CloseAll;	{ fermeture des fichiers encore ouverts }
									ECode := 0;	{ indique que c'est fait ! }
									REPEAT
										WaitDelay(3600);	{ on bloque cette tâche }
									UNTIL FALSE;
								END;
								
								ReqLock:
									BEGIN
										ThePFile[EMisc].TCBLocker := EOwner;
										EOwner^.StatusWord := ReadyCst;
										MyParmBlkPtr(EParam1)^.ioResult := NoErr;
									END;

								ReqUnlock:
									BEGIN
										IF ThePFile[EMisc].TCBLocker = EOwner THEN ThePFile[EMisc].TCBLocker := NIL;
										EOwner^.StatusWord := ReadyCst;
										MyParmBlkPtr(EParam1)^.ioResult := NoErr;
									END;

								ReqDelete:
									BEGIN { si fichier non ouvert }
										RechFName(False, False);
										IF TheFilePNum = 0 THEN { Fichier non trouve, Ok }
											DirectRequest
										ELSE
											BEGIN { Fichier ouvert, erreur }
												MyParmBlkPtr(EParam1)^.ioResult := FBsyErr;
												EOwner^.StatusWord := ReadyCst;
											END;
									END;

								ReqCreate, ReqDirCreate, ReqGetFInfo, ReqSetFInfo, ReqOpWd, ReqClWd, ReqGetCat,
								ReqFlush, ReqGetVol, ReqSetVol, ReqGetVInfo:
									BEGIN
										DirectRequest;
									END;

								ReqNameOfId:
									BEGIN
										EParam1 := @ThePFile[EMisc].TheName;
									END;

								ReqRename:
									BEGIN
										MyParmBlkPtr(EParam1)^.TcbPtr := GetCurSt;
										MaxTime := Ord4(GetCurSt);
										IOCompFlag := 1;
										StatusWord := IOWaitCst;
										DirectRequest;
										MyParmBlkPtr(EParam1)^.TcbPtr := EOwner;
										IF MyParmBlkPtr(EParam1)^.ioResult = NoErr THEN
											BEGIN
												REPEAT
													RechFName(False, False);
													IF TheFilePNum <> 0 THEN
														WITH ThePFile[TheFilePNum] DO
														{ fichier present dans le pool }
															TheName := FNamePtr(MyParmBlkPtr(EParam1)^.ioMisc)^;
												UNTIL TheFilePNum = 0; { au cas où DATA et RSRC ouvertes }
											END;
										EOwner^.StatusWord := ReadyCst;
									END;

								ReqClose:
									WITH ThePFile[EMisc] DO
										BEGIN
											IF TCBLocker = EOwner THEN TCBLocker := NIL;	{ on dévérouille }
											IF NbAccess>0 THEN NbAccess := NbAccess - 1;	{ un accès de moins }
											
											IF NbAccess=0 THEN
											BEGIN
												IF (TheFRef<>0) THEN	{ bien sûr, NbAccess = 0 }
													BEGIN
														{ il faut vraiment fermer le fichier }
														IOCompFlag := 1;
														StatusWord := IOWaitCst;
														WITH Pb DO
															BEGIN
																ioCompletion := @AsmCompletion;
																ioRefNum := TheFRef;
															END;
														nf := NumOfFCB;
														Err := PbCloseAsync(@Pb.QLink); {CLOSE ASYNC}
														SwapTasks(@RegArea, @RegAreaF);

														{ recherche dans les fichiers ouverts }
														i := 1;
														WHILE TheOFile[i] <> EMisc DO
															i := i + 1;
														FOR j := i + 1 TO NbOFile DO
															TheOFile[j - 1] := TheOFile[j];
														{ suppression du fichier dans le pool }
														NbOFile := NbOFile - 1;
													END;
												{ on supprime le fichier du tableau des fichiers utilisés }
												TheName := '';
												TheFRef := 0;
												TCBLocker := NIL;
												NbPFile := NbPFile - 1;	{ il y a un fichier en moins dans le tableau }
											END;
											{ on réactive la tâche d'origine }
											EOwner^.StatusWord := ReadyCst;
											MyParmBlkPtr(EParam1)^.ioResult := NoErr;
										END;

								ReqOpen, ReqOpRsrc:
									BEGIN
										RechFName(true, (ECode = ReqOpRsrc));
										IF TheFilePNum <> 0 THEN
											BEGIN { fichier present dans le pool }
												EMisc := TheFilePNum;
												MyParmBlkPtr(EParam1)^.ioResult := NoErr;
												WITH ThePFile[TheFilePNum] DO
													NbAccess := NbAccess + 1;
											END
										ELSE
											BEGIN { fichier non present dans le pool, on l'installe }
												{ recherche d'une place libre }
												IF NbPFile < MaxPoolFile THEN	{ on peut encore ouvrir des fichiers ! }
													BEGIN
														{ on ouvre réellement }
														MyParmBlkPtr(EParam1)^.TcbPtr := GetCurSt;
														MaxTime := Ord4(GetCurSt);
														IOCompFlag := 1;
														StatusWord := IOWaitCst;
														DirectRequest;
														MyParmBlkPtr(EParam1)^.TcbPtr := EOwner;
														IF (MyParmBlkPtr(EParam1)^.ioResult = NoErr) | (MyParmBlkPtr(EParam1)^.ioResult = opWrErr) THEN	{ tout est ok ! }
															BEGIN
																{ ajout dans le tab. des fichiers utilisés }
																i := 1;
																WHILE ThePFile[i].NbAccess > 0 DO i := i + 1;
																EMisc := i;
																WITH ThePFile[i] DO
																	BEGIN
																		TheName := FNamePtr(MyParmBlkPtr(EParam1)^.ioNamePtr)^;
																		NbAccess := 1;
																		TheFRef := MyParmBlkPtr(EParam1)^.ioFRefNum;
																		ResFlag := (ECode = ReqOpRsrc);
																	END;
																NbPFile := NbPFile + 1;
																OpOpen(EMisc);	{ ajout dans tab. des fichiers ouverts }
															END;
													END
												ELSE { too many files open error }
													BEGIN
														MyParmBlkPtr(EParam1)^.ioResult := TMFOErr;
													END;
											END;
										EOwner^.StatusWord := ReadyCst;
									END;

								ReqRead, ReqWrite, ReqGetEof, ReqSetEof:
									WITH ThePFile[EMisc] DO
										BEGIN
											IF TheFRef = 0 THEN OpOpen(EMisc)
											ELSE
												BEGIN
													i := 1; { recherche dans les fichiers ouverts }
													WHILE TheOFile[i] <> EMisc DO
														i := i + 1;
													{ on met la ref en tete }
													FOR j := i - 1 DOWNTO 1 DO
														TheOFile[j + 1] := TheOFile[j];
													TheOFile[1] := EMisc;
												END;
											MyParmBlkPtr(EParam1)^.ioFRefNum := TheFRef;
											DirectRequest;
										END;

								ReqCatMove:
									BEGIN
										MyParmBlkPtr(EParam1)^.TcbPtr := GetCurSt;
										MaxTime := Ord4(GetCurSt);
										IOCompFlag := 1;
										StatusWord := IOWaitCst;
										DirectRequest;
										MyParmBlkPtr(EParam1)^.TcbPtr := EOwner;
										IF MyParmBlkPtr(EParam1)^.ioResult = NoErr THEN
										REPEAT
											RechFName(False, False);
											IF TheFilePNum <> 0 THEN
												WITH ThePFile[TheFilePNum] DO
												{ fichier present dans le pool }
													TheName := FNamePtr(MyParmBlkPtr(EParam1)^.ioMisc)^;
										UNTIL TheFilePNum = 0; { au cas où DATA et RSRC ouvertes }
										EOwner^.StatusWord := ReadyCst;
									END;

							END; { CASE }

							ZoneNumber := 0;
							MaxTime := 0;
						END; { WITH }
				END; { ServeRequest }

			PROCEDURE WaitRequest; { on attend une nouvelle requête dans la queue }

				BEGIN
					WITH ThePtr^, ThePtr^.TheQueues^[TaskQueue] DO
						BEGIN
							IF QFirst = NIL THEN PendAdr := @QFirst
							ELSE PendAdr := @QEnd^.QLink;

							StatusWord := PdCst;
							SwapTasks(@RegArea, @RegAreaF);
						END;
				END;


			BEGIN
{$IFC FLUSH}
				LastFlush := 0;
{$ENDC}

				{ Nombre maxi de FCB utilisables par Dragster }
				IF SysEnvirons(curSysEnvVers, theMac) = 0 THEN;
				IF theMac.SystemVersion >= $700 THEN
					CurMaxOpFile := MaxOpFile { <7.0> les FCB sont alloués dynamiquement ! }
				ELSE
					CurMaxOpFile := (IntPtr(LIPtr(FCBSPtr)^)^ DIV FCBLen) DIV 2;

				IF CurMaxOpFile > MaxOpFile THEN CurMaxOpFile := MaxOpFile;
				IF CurMaxOpFile < 10 THEN CurMaxOpFile := 10;

				ThePtr := GetCurSt;

				Pb.TcbPtr := ThePtr;

				WITH ThePtr^ DO
					BEGIN
						StartTime := 0;

						{ initialisation de la queue de requetes }
						WITH TheQueues^[TaskQueue] DO
							BEGIN
								QOwner := ThePtr;
								QFirst := NIL;
								QEnd := NIL;
								QNumber := 0;
							END;

						{ initialisation des fichiers réellement Ouverts }
						FOR i := 1 TO MaxOpFile DO TheOFile[i] := 0;
						NbOFile := 0;

						{ initialisation du pool des fichiers utilisés }
						FOR i := 1 TO MaxPoolFile DO
							WITH ThePFile[i] DO
								BEGIN
									TheName := ''; { nom du fichier }
									TheFRef := 0; { file ref number }
									NbAccess := 0; { nb accès simultannés sur ce fichier }
									TCBLocker := NIL; { TCBPtr du Locker}
									resFlag := FALSE;
								END;
						NbPFile := 0;

					END;

				{ nous allons servir }
				WHILE true DO
				BEGIN
					{ on cherche une requete valide }
					WHILE NOT ValRequestFound DO WaitRequest;

					{ on traite la requete en cours }
					{ ecode  contient le code de la requete a traiter }
					{ eparam1 contient le MyParamBlockPtr }
					{ EMisc 		contient le numero du fichier a traiter (dans le pool)}
					ServeRequest;
						
{$IFC FLUSH}
					FlushAll;
{$ENDC}
				END;	{ WHILE TRUE }
			END; { of TheTask }

END. {of File Server}
