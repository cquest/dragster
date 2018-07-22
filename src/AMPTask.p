UNIT AMPTask;

{$SETC DEBUG=FALSE}

	{ Tache gérant le flot d'entrée en protocole AMP }

	INTERFACE

		USES MemTypes, OSIntf, ToolIntf, PackIntf, ADSP;

		PROCEDURE TheTask;

	IMPLEMENTATION

		{$I DragsterTCB.p}

		TYPE
			TCBsArray = ARRAY [0..255] OF RECORD
				TCB: TPtr;
				NextInArray: INTEGER;
			END;
			
			TCBsPtr = ^TCBsArray;

		CONST
			ErrTime = 128;

			SOH = chr(1);
			STX = chr(2);
			ETX = chr(3);
			BS = chr(8);
			FF = chr(12);
			SO = chr(14);
			SI = chr(15);
			DLE = chr(16);
			DC1 = chr(17);
			REP = chr(18);
			SEP = chr(19);
			DC4 = chr(20);
			SS2 = chr(22);
			CAN = chr(24);
			ACC = chr(25);
			ESC = chr(27);
			RS = chr(30);
			US = chr(31);
			SP = chr(32);

			DataHdr = 0;		{ 000xxxxxx = données normales }
			DataMHdr = 1;		{ 001xxxxxx = données à suivre (bit M) }
			DataQHdr = 2;		{ 010xxxxxx = donées qualifiées (bit Q) }
			DataQMHdr = 3;	{ 011xxxxxx = données qualifiées à suivre (bits Q et M) }
			ResetHdr = 4; 	{ 100xxxxxx }
			CtrlHdr = 5;		{ 101xxxxxx yyyyyyyyy }
			CallHdr = 6;		{ 110xxxxxx appel }
			ClearHdr = 7;		{ 111xxxxxx }
			

		FUNCTION GetCurSt: TPtr;
		{ GetCurSt rend CurStPtr, qui pointe sur le TCB actif }
			EXTERNAL;

		PROCEDURE SwapTasks(AdRegs1, AdRegs2: Ptr);
		{ Sauvegarde contexte courant dans AdRegs1 et restaure AdRegs2 }
			EXTERNAL;

		PROCEDURE AsmCompletion;
		{ IOCompletion qui donne l'adresse de la tache appelante }
			EXTERNAL;

		PROCEDURE WaitDelay(Num1: Longint);

			BEGIN
				WITH GetCurSt^ DO
					BEGIN
						DelayValue := Num1;
						StatusWord := DelayCst;
						SwapTasks(@RegArea, @RegAreaF);
					END;
			END;
		
		FUNCTION Concatnum(str:str255; num:longint):str255;
		
		VAR	tempStr:Str255;
		
		BEGIN
			numtostring(num,tempstr);
			concatnum := concat(str,tempstr);
		END;
		
		

		PROCEDURE TheTask; { Tache de pool d'entree }

			CONST
				ErrCode = - 1; { mauvais code action }

			VAR
				ThePtr, CurTCB: TPtr;
				TheTCBs: TCBsArray;
				i: Integer;
				InChar, TpPaq: Integer;
				FirstInArray: Integer;
				buff: Str255;
				
			PROCEDURE GetNext;

				VAR
					Err: OSErr;

				BEGIN
					IF buff='' THEN
					WITH pb, GetCurSt^ DO
						BEGIN		{ le buffer est vide… }
							{ 1/ on lit un caractère
								2/ on regarde si il y en a d'autres…
								3/ on lit les autres
							}
							StatusWord := IOWaitCst;
							ioReqCount := 1;
							Err := PbReadAsync(@QLink);
							SwapTasks(@RegArea, @RegAreaF);
							inChar := ord(buff[1]);
							
							Err := SerGetBuf(iorefNum,ioReqCount);
							IF ioReqCount<>0 THEN	{ il y a encore des données à lire }
							BEGIN
								StatusWord := IOWaitCst;
								IF ioReqCount>255 THEN ioReqCount := 255;
								Err := PbReadAsync(@QLink);
								SwapTasks(@RegArea, @RegAreaF);
								buff[0] := chr(ioActCount);
							END;
						END
					ELSE
						BEGIN		{ il reste des données dans le buffer }
							inChar := ord(buff[1]);
							Delete(buff,1,1);
						END;
				END;

			PROCEDURE CallPack;

				VAR
					XDataCount: Integer;
					
				BEGIN { la voie va etre connectée }
					{ il faut remplir les données d'entrée - max 24 cars }
					WITH CurTCB^ DO
						BEGIN
							XCallDatas := '                          ';
							XDataCount := 0;
							
							REPEAT
								GetNext;
								IF (XDataCount<SZCALL) & (inChar>$20) & (inChar<>ord('/')) THEN
								BEGIN
									XDataCount := XDatacount+1;
									XCallDatas[xDataCount] := Chr(InChar);
								END;
							UNTIL InChar=ord(ETX);
							
							ConFlag := FALSE;	{ au cas où on n'aurait pas reçu le LIB précédent… }
							XConFlag := True;	{ connecté au niveau X25 !! }
							IF (StatusWord IN [WDataCst..WComTCst]) THEN	{ on réactive la tâche d'origine }
								BEGIN
									Error := NoErr;
									StatusWord := ReadyCst;
								END;
						END;
				END;


			PROCEDURE LibPack;

				BEGIN { la voie est deconnectée }
					WITH CurTCB^ DO
						BEGIN
							XCallDatas := '                          ';
							ConFlag := False;
							XConFlag := False;
							IF (StatusWord IN [WDataCst..WComTCst]) THEN	{ on réactive la tâche d'origine }
								BEGIN
									Error := NoErr;
									StatusWord := ReadyCst;
								END;
						END;
				END;


			PROCEDURE ComPack;

				BEGIN { la voie est connectée }
					{ pas de données d'entrée }
					WITH CurTCB^ DO
						BEGIN
							XCallDatas := '                          ';
							XConFlag := True;
						END;
				END;


			PROCEDURE DataPack;

				VAR
					Idx: Integer;
					ABuff: iBuffPtr;
					transp: BOOLEAN;
					
				BEGIN { on met les données dans InBuff --- max 255 chars }
					WITH CurTCB^ DO
						BEGIN
							IF InBuffEnd = NIL THEN	{ pas de buffer pour l'instant }
							BEGIN
								InBuffEnd := InBuffPool^.Link;	{ on en prend un nouveau }
								IF InBuffEnd = NIL THEN EXIT(DataPack); { plus de buffer, infos perdues }
								InBuffPool^.Link := InBuffPool^.Link^.Link;
								InBuffEnd^.InBuff[0] := chr(0);	{ raz de ce nouveau buffer }
								InBuffSt := InBuffEnd;	{ c'est le premier à utiliser }
								InBuffEnd^.Link := NIL;	{ pas de buffer suivant }
								InBuffNb := 1;					{ on a un seul buffer pour l'intant }
							END;
								
							WBuffFlag := True;	{ remplissage du buffer en cours !!! }

							REPEAT
								IF length(InBuffEnd^.InBuff) = 255 THEN { ce buffer en plein ! }
								BEGIN
									ABuff := InBuffPool^.Link;	{ on en prend un nouveau }
									IF ABuff <> NIL THEN
									BEGIN
										InBuffNb := InBuffNb + 1;
										InBuffPool^.Link := InBuffPool^.Link^.Link;
										InBuffEnd^.Link := ABuff;
										ABuff^.Link := NIL;
										InBuffEnd := ABuff;
										InBuffEnd^.InBuff[0]:=chr(0);
									END
									ELSE Leave; { on sort du REPEAT car on n'a plus de buffer libre ! }
								END;

								GetNext;
								Transp := (InChar = ord(DLE));
								IF Transp THEN GetNext;	{ Transparence des DLE }
								IF Transp | (Inchar<>ord(ETX)) THEN
								WITH InBuffEnd^ DO
								BEGIN
									InBuff[0] := CHR(ORD(InBuff[0])+1);
									InBuff[length(InBuff)] := chr(InChar);
{$IFC DEBUG}
DebugStr(concat('Data= ',chr(Inchar),concatnum(' ',inchar),' ',InBuff));
{$ENDC}
								END;
							UNTIL (inChar=ord(ETX)) & (Transp=FALSE);
							
{$IFC DEBUG}
DebugStr(concatNum('Sortie= ',inchar));
{$ENDC}
							WBuffFlag := False;	{ plus d'écriture dans le buffer }
							IF (StatusWord IN [WDataCst..WComTCst]) THEN	{ on réactive la tâche d'origine }
								BEGIN
									Error := NoErr;
									StatusWord := ReadyCst;
								END;
						END;
				END;

			PROCEDURE X29DataPack;
			
			VAR
				transp: BOOLEAN;
				temp: Str255;
				
			BEGIN
				WITH CurTcb^,CurTcb^.Infos^ DO
				BEGIN
					LastX29 := '';
					REPEAT
						GetNext;
						Transp := (InChar = ord(DLE));
						IF Transp THEN GetNext;	{ Transparence des DLE }
						IF Transp | (Inchar<>ord(ETX)) THEN
						BEGIN
							LastX29[0] := CHR(ORD(LastX29[0])+1);
							LastX29[length(LastX29)] := chr(InChar);
						END;
					UNTIL (inChar=ord(ETX)) & (Transp=FALSE);
					
					IF LastX29[1]=chr($92) THEN { Commande POSSIBILITES }
					BEGIN
						PO1 := 0;
						PO[2] := '';
						PO[3] := '';
						PO[4] := '';
						PO[5] := '';
						PO[6] := '';
						temp := LastX29;
						Delete(Temp,1,3);	{ $92 + 2 oct. de longueur }
						REPEAT
							CASE ORD(Temp[1]) OF
								$81:
									PO1 := ord(Temp[3]);
								$82..$86:	
									PO[ORD(Temp[1])-$80] := Copy(temp,3,ORD(Temp[2]));
								OTHERWISE
									Temp := '';
							END;
							Delete(Temp,1,2+ORD(Temp[2]));
						UNTIL temp='';
					END;
				END;	{ WITH CurTcb^ }
			END;
			
			
			PROCEDURE IndispPack;

				BEGIN { on change le flag OutPutFlag de la voie a false }
					{ seulement si la voie est encore connectée }
					WITH CurTCB^ DO OutPutFlag := False;
				END;

			PROCEDURE DispPack;

				BEGIN { on change le flag OutPutFlag de la voie a true }
					WITH CurTCB^ DO OutPutFlag := True;
				END;


BEGIN
	ThePtr := GetCurSt;	{ TCB de cette tâche }

	InChar := 0;
	TpPaq := 0;
	buff := '';
	
	WITH pb, ThePtr^ DO
		BEGIN
			TcbPtr := ThePtr;
			ioCompletion := ProcPtr(@AsmCompletion);
			ioBuffer := @buff[1];
			ioReqCount := 1;
			ioPosMode := fsAtMark;
			ioPosOffset := 0;
			ioRefNum := SerRefIn;
		END;

	{ raz du tableau des TCBs }
	FOR i := 0 TO 255 DO
	BEGIN
		theTCBS[i].TCB := NIL;
		theTCBs[i].NextInArray := 0;
	END;
	
	{ on initialise le tableau de TPtr }
	CurTcb := ThePtr;
	REPEAT
		CurTCB := CurTCB^.NextTCB;
		IF (CurTCB^.TaskNumber<1024) & (CurTCB^.HardType = MuxASM) THEN
		BEGIN
			TheTCBs[CurTCB^.TheModem].TCB := CurTCB;
		END;
	UNTIL CurTCB^.NextTCB=NIL;
	
	FirstInArray := 0;
	FOR i := 255 DOWNTO 0 DO
	BEGIN
		IF theTCBs[i].TCB <> NIL THEN
		BEGIN
			theTCBs[i].NextInArray := FirstInArray;
			FirstInArray := i;
		END;
	END;
	
	WITH ThePtr^ DO
		WHILE True DO
			BEGIN
				{ réception du type de paquet & N° de cvc }
				GetNext;
				TpPaq := BSR(Inchar,6);			{ type de trame }
				InChar := BAND(InChar,$1F);	{ N° de cvc }
				
{$IFC DEBUG}
DebugStr(concat(concatnum('Mux: cv=',InChar),' Type=',chr(tppaq)));
{$ENDC}
				IF (TpPaq IN [XonFrame,XoffFrame]) & (inChar=ord(ETX)) THEN
				BEGIN
					{ contrôle de flux général !! }
					i := FirstInArray;
					WHILE i<>0 DO
					BEGIN
						TheTCBs[i].TCB^.OutputFlag := (tpPaq=XOnFrame);
						i := theTCBs[i].NextInArray;
					END;
				END
				ELSE
				BEGIN
					CurTCB := TheTCBs[InChar].TCB;
					IF CurTCB <> NIL THEN
					BEGIN
{$IFC DEBUG}
DebugStr(concat(concatnum('Mux: voie=',CurTCB^.Tasknumber),' Type=',chr(tppaq)));
{$ENDC}
						CASE TpPaq OF
							DataFrame,NextDataFrame: DataPack;
							CallFrame: CallPack;
							LibFrame,CLibFrame,ErrFrame: LibPack;
							ComFrame: ComPack;
							XoffFrame: IndispPack;
							XonFrame: DispPack;
							X29Frame: X29DataPack;
						END;
					END;
				END;
				
				{ attente du ETX de fin de trame }
				WHILE InChar <> ord(ETX) DO GetNext;

			END;
END; {of theTask}
END. {of Unit}
