{
	File:		InTask.p

	Contains:	Tâche d'interrogation des modems Dragster

	Written by:	Christian QUEST

	Copyright:	1991 JCA Télématique

	Change History (most recent first):

				16/10/91	CQ		Modification de la réception des paquets provenant
									des modems, on lit désormais le contenu du buffer
									de réception d'un coup et plus car. par car.
									Modification des I/O pour ne plus se mettre en
									attente si l'on n'a pas besoin (ioresult=1)
									Modification pour avoir deux tâches d'I/O pour
									la version deux ports de communication.
				17/04/91	CQ		Modification pour que les I/O se fassent en utilisant
									les drivers d'entrée sortie de la tâche appelante.
									Ceci permet d'utiliser des ports série différents.

}

UNIT InTask;

INTERFACE

USES	MemTypes,QuickDraw ,OSIntf ,ToolIntf ,PackIntf, AppleTalk, ADSP, GestaltEqu;


TYPE
        Pstr255 =       ^Str255;


PROCEDURE TheTask;

IMPLEMENTATION

     {$I DragsterTCB.p}

     CONST
	 
{$IFC UNDEFINED QUEUE2}
	 	TaskQueue = IOQ;
{$ELSEC}
	 	TaskQueue = IOQ2;
{$ENDC}

               ErrTime	      = 128;

               BS	      = chr(8);
               FF	      = chr(12);
               SO	      = chr(14);
               SI	      = chr(15);
               DC1	      = chr(17);
               REP	      = chr(18);
               SEP	      = chr(19);
               DC4	      = chr(20);
               SS2	      = chr(22);
               CAN	      = chr(24);
               ACC	      = chr(25);
               ESC	      = chr(27);
               RS	      = chr(30);
               US	      = chr(31);
               SP	      = chr(32);


FUNCTION GetCurSt: TPtr;
{ GetCurSt rend CurStPtr, qui pointe sur le TCB actif }
EXTERNAL;

PROCEDURE SwapTasks(AdRegs1,AdRegs2:    Ptr);
{ Sauvegarde contexte courant dans AdRegs1 et restaure AdRegs2 }
EXTERNAL;

PROCEDURE AsmCompletion;
{ IOCompletion qui donne l'adresse de la tache appelante }
EXTERNAL;

PROCEDURE StrSetLen(TheStr: CharsPtr; TheLen: Integer);
{ met la bonne longueur a la chaine }
EXTERNAL;


PROCEDURE WaitDelay(Num1: Longint);

BEGIN
	WITH GetCurSt^ DO
	BEGIN
		DelayValue:=Num1;
		StatusWord:=DelayCst;
		SwapTasks(@RegArea,@RegAreaF);
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


PROCEDURE TheTask;  { Tache de pool d'entree }

	CONST ErrCode      =       -1;     { mauvais code action }

	VAR
		TheOwner	: TPtr;
		TheRequests: ARRAY[1..MaxTasks] OF TQEPtr;
		NbRequest,
		CurRequest,
		i	    		: Integer;
		thePaquet	: Str255;
		pb	    	: MyParamblockrec;
		SyncChar	: Integer;
		result		: Longint;
		
	


	PROCEDURE StrPrint(VAR str1: str255);

		VAR	Err	    : OSErr;
			pb	    : MyParamblockrec;
			 
	BEGIN
		WITH GetCurSt^ DO
		BEGIN
			IOCompFlag:=1;
			StatusWord:=IOWaitCst;
			WITH pb DO
			BEGIN
				TcbPtr:=GetCurSt;
				ioCompletion:=ProcPtr(Ord4(@AsmCompletion));
				ioRefNum:=TheOwner^.SerRefOut;		{ modif du 17/4/91 }
				ioBuffer:=@Str1[1];
				ioReqCount:=Length(Str1);
				ioPosMode:=0;
			END;
			Err:=PbWriteAsync(@Pb.QLink);
			SwapTasks(@RegArea,@RegAreaF);
		END;
	END;
	
		
(*	
	Procedure PaqAsRead(TheBuffer: CharsPtr; TimeLimit: Longint);
	{ version originale Ph.B }
	
	Var Err,Errb		: OSErr;
		Timeout			: LONGINT;
		
	Begin
		TimeOut := TickCount+TimeLimit;
		With ThePtr^ do
		begin
			repeat	{ attente début de paquet }
				IOCompFlag:=1;
				If TimeLimit=0 then
					StatusWord:=IOWaitCst
				else
					begin
						StatusWord:=IOTWaitCst;
						DelayValue:=TimeLimit;
					end;

				With pb do
				begin
					TcbPtr:=ThePtr;
					ioCompletion:=ProcPtr(Ord4(@AsmCompletion));
					ioRefNum:=TheOwner^.SerRefIn;		{ modif du 17/4/91 }
					ioBuffer:=Ptr(Ord4(@SyncChar)+1);
					ioReqCount:=1;
					ioPosMode:=fsAtMark;
					ioPosOffset:=0;
				end;
				Err:=PbReadAsync(@Pb.QLink);
				SwapTasks(@RegArea,@RegAreaF);
				Err:=pb.IOResult;
				If Err<>0 then
				With pb do {Time Out }
				begin
					ioCompletion:=Nil;
					Error:=ErrTime;
					Errb:=PbKillIOSync(@Pb.QLink);
				end;
				
			until (SyncChar>=192) or (Err<>0);
			
			If Err<>0 then exit(PaqAsRead);

			{ recup jusqu'a fin de paquet }
			i:=1;
			repeat
				IOCompFlag:=1;
				If TimeLimit=0 then
					StatusWord:=IOWaitCst
				else
				begin
					StatusWord:=IOTWaitCst;
					DelayValue:=TimeLimit;
				end;

				With pb do
				begin
					TcbPtr:=ThePtr;
					ioCompletion:=ProcPtr(Ord4(@AsmCompletion));
					ioRefNum:=TheOwner^.SerRefIn;		{ modif du 17/4/91 }
					ioBuffer:=Ptr(Ord4(TheBuffer)+i);
					ioReqCount:=1;
					ioPosMode:=fsAtMark;
					ioPosOffset:=0;
				end;
				Err:=PbReadAsync(@Pb.QLink);
				SwapTasks(@RegArea,@RegAreaF);
				Err:=pb.IOResult;
				If Err<>0 then {Time Out }
				With pb do
				begin
					ioCompletion:=Nil;
					Error:=ErrTime;
					Errb:=PbKillIOSync(@Pb.QLink);
				end
				else i:=i+1;
			until (Ord(TheBuffer^[i-1])=128) or (Err<>0);

			If Err=0 then
			begin
				Error:=0;
				StrSetLen(TheBuffer,i-2); {longueur paquet - 1}
			end;
		end;
	End;
*)


	PROCEDURE PaqAsRead(TheBuffer: CharsPtr; TimeLimit: Longint);

	VAR
		Err			: INTEGER;
		count		: LONGINT;
		Timeout	: LONGINT;
		Flag		: INTEGER;
		i				: INTEGER;
		oldZN		: INTEGER;
		
	BEGIN
		oldZN := GetCurSt^.ZoneNumber;
		GetCurSt^.ZoneNumber := 80;
		Flag := 0;	{ attente de synchro début }
		Timeout := TickCount + TimeLimit;
		theBuffer^[0] := CHR(0);
		WITH GetCurSt^ DO
		REPEAT
			IF thePaquet = '' THEN	{ il faut lire des données }
			BEGIN
				ZoneNumber := 81;
				Err := SerGetBuf(TheOwner^.SerRefIn,count);	{ 13/5/98 }
				IF count>0 THEN
				BEGIN
					ZoneNumber := 82;
					{ on se prépare à l'I/O }
					IOCompFlag:=1;
					IF TimeLimit=0 THEN
						StatusWord:=IOWaitCst
					ELSE
						BEGIN
							StatusWord:=IOTWaitCst;
							DelayValue:=TimeLimit;
						END;
					
					{ lecture du contenu du buffer }
					IF Count > 255 THEN Count := 255;	{ 255 car. maxi !! }
					WITH pb DO
					BEGIN
						TcbPtr:=GetCurSt;
						ioCompletion:=ProcPtr(Ord4(@AsmCompletion));
						ioRefNum:=TheOwner^.SerRefIn;		{ modif du 17/4/91 }
						ioBuffer:=@thePaquet[1];
						ioReqCount:=count;
						ioPosMode:=fsAtMark;
						ioPosOffset:=0;
					END;
					ZoneNumber := 83;
					Err:=PbReadAsync(@Pb.QLink);
					SwapTasks(@RegArea,@RegAreaF);
					ZoneNumber := 84;
					Err:=pb.IOResult;
					thePaquet[0] := CHR(pb.ioActCount);	{ mise à jour longueur }
					IF Err<>0 THEN
					WITH pb DO {Time Out }
					BEGIN
						ioCompletion:=Nil;
						Error:=ErrTime;
						ZoneNumber := 85;
						Err:=PbKillIOSync(@Pb.QLink);
						thePaquet := '';
					END;
				END	{ IF count>0 }
				ELSE
					WaitDelay(1);	{ rien à recevoir… on attend un peu }
			END;	{ IF thePaquet = '' }
			
			ZoneNumber := 86;
			i:=0;
			{ on analyse ce que l'on a reçu… }
			FOR i := 1 TO length(thePaquet) DO
			CASE Flag OF
				0:	{ attente synchro début }
				BEGIN
					ZoneNumber := 87;
					IF thePaquet[i]>=CHR(192) THEN
					BEGIN
						Flag := 1;
						SyncChar := ORD(thePaquet[i]);
					END;
				END;
				
				1:	{ lecture paquet et attente fin paquet }
				BEGIN
					ZoneNumber := 88;
					IF thePaquet[i]<>CHR(128) THEN
					BEGIN
						IF ORD(theBuffer^[0])<255 THEN	{ 4/1/92: dépassement longueur paquet }
						BEGIN
							theBuffer^[0]:=CHR(ORD(theBuffer^[0])+1);
							theBuffer^[ORD(theBuffer^[0])] := thePaquet[i];
						END;
					END
					ELSE
					BEGIN
						Flag := 2;
						Error := 0;
						Leave;
					END;
				END;
				
				2:
				BEGIN
					ZoneNumber := 89;
					Leave;
				END;
			END;
			
			IF i>0 THEN
			BEGIN
				ZoneNumber := 90;
				IF i<length(thePaquet) THEN
					Delete(thePaquet,1,i)
				ELSE
					thePaquet := '';
			END;
			
			ZoneNumber := 91;		
		UNTIL ((TimeLimit<>0) & (TickCount>Timeout)) | (Flag=2);
		GetCurSt^.ZoneNumber := oldZN;
	END;

(*
	PROCEDURE PaqAsRead(TheBuffer: CharsPtr; TimeLimit: Longint);

	VAR	Err			: INTEGER;
		count		: LONGINT;
		Timeout		: LONGINT;
		Flag		: INTEGER;
		i			: INTEGER;
		
	BEGIN
		Flag := 0;	{ attente de synchro début }
		Timeout := TickCount + TimeLimit;
		theBuffer^[0] := CHR(0);
		WITH ThePtr^ DO
		REPEAT
			Err := SerGetBuf(TheOwner^.SerRefIn,count);
			IF count>0 THEN
			BEGIN
				{ on se prépare à l'I/O }
				IOCompFlag:=1;
				IF TimeLimit=0 THEN
					StatusWord:=IOWaitCst
				ELSE
					BEGIN
						StatusWord:=IOTWaitCst;
						DelayValue:=TimeLimit;
					END;
					
				{ lecture du contenu du buffer }
				IF Count > 255 THEN Count := 255;	{ 255 car. maxi !! }
				WITH pb DO
				BEGIN
					TcbPtr:=ThePtr;
					ioCompletion:=ProcPtr(Ord4(@AsmCompletion));
					ioRefNum:=TheOwner^.SerRefIn;		{ modif du 17/4/91 }
					ioBuffer:=@thePaquet[1];
					ioReqCount:=count;
					ioPosMode:=fsAtMark;
					ioPosOffset:=0;
				END;
				Err:=PbReadAsync(@Pb.QLink);
				SwapTasks(@RegArea,@RegAreaF);
				Err:=pb.IOResult;
				thePaquet[0] := CHR(pb.ioActCount);	{ mise à jour longueur }
				IF Err<>0 THEN
				WITH pb DO {Time Out }
				BEGIN
					ioCompletion:=Nil;
					Error:=ErrTime;
					Err:=PbKillIOSync(@Pb.QLink);
					thePaquet := '';
				END;
				
				{ on analyse ce que l'on a reçu… }
				FOR i := 1 TO length(thePaquet) DO
				CASE Flag OF
					0:	{ attente synchro début }
						IF thePaquet[i]>=CHR(192) THEN
						BEGIN
							Flag := 1;
							SyncChar := ORD(thePaquet[i]);
						END;
					1:	{ lecture paquet et attente fin paquet }
						IF thePaquet[i]<>CHR(128) THEN
						BEGIN
							IF ORD(theBuffer^[0])<255 THEN	{ 4/1/92: dépassement longueur paquet }
							BEGIN
								theBuffer^[0]:=CHR(ORD(theBuffer^[0])+1);
								theBuffer^[ORD(theBuffer^[0])] := thePaquet[i];
							END;
						END
						ELSE
						BEGIN
							Flag := 2;
							Error := 0;
							Leave;
						END;
					2:	Leave;
				END;
				thePaquet := '';
			END
			ELSE WaitDelay(1);
		UNTIL ((TimeLimit<>0) & (TickCount>Timeout)) | (Flag=2);
	END;
*)

     PROCEDURE QRequests; { vide la queue des requetes }
     BEGIN
        WITH GetCurSt^.TheQueues^[TaskQueue] DO
        WHILE QNumber>0 DO
        BEGIN
                IF QFirst^.ECode=ReqOff THEN
                BEGIN   { Annulation de requete }
                        IF TheRequests[QFirst^.EOwner^.TaskNumber]<>Nil THEN
                        BEGIN
                             TheRequests[QFirst^.EOwner^.TaskNumber]:=Nil;
                             NbRequest:=NbRequest-1;
                        END;
                        QFirst^.ERet:=ReqCanceled;
                END
                ELSE
                IF QFirst^.ECode=ReqOn THEN
                BEGIN   { Mise en route de requete }
                        IF TheRequests[QFirst^.EOwner^.TaskNumber]=Nil THEN
                        BEGIN
                            TheRequests[QFirst^.EOwner^.TaskNumber]:=QFirst;
                            NbRequest:=NbRequest+1;
                        END;
                        QFirst^.ERet:=ReqActive;
                END
                ELSE { code action errone }
                BEGIN
                        QFirst^.EOWner^.Error:=ErrCode;
                        QFirst^.EOwner^.StatusWord:=ReadyCst;
                END;
                { on retire la requete de la queue }
                QNumber:=QNumber-1;
                QFirst:=QFirst^.QLink;
                IF QFirst=Nil THEN QEnd:=Nil;
        END;
     END;


	PROCEDURE WaitRequest; { on attend une nouvelle requête dans la queue }

	BEGIN
		WITH GetCurSt^,GetCurSt^.TheQueues^[TaskQueue] DO
		BEGIN
			IF QFirst=Nil THEN
				PendAdr:=@QFirst
			ELSE
				PendAdr:=@QEnd^.QLink;
				
			StatusWord:=PdCst;
			SwapTasks(@RegArea, @RegAreaF);
		END;
	END;


BEGIN
	{ 14/5/98 }
{
	i := Gestalt(gestaltNativeCPUtype, result);
	IF (result >= gestaltCPU601) THEN
		SetRunMode(0);
}
	SetRunMode(1);	{ 15/6/99 }

	SyncChar:=0;
	WITH GetCurSt^ DO
	BEGIN
		{ initialisation de notre queue }
		WITH TheQueues^[TaskQueue] DO
		BEGIN
			QOwner:=GetCurSt;
			QFirst:=Nil;
			QEnd:=Nil;
			QNumber:=0;
		END;
		{ initialisation de l'ensemble des requetes }
		FOR i:=1 TO MaxTasks DO TheRequests[i]:=Nil;
		NbRequest:=0;
	END;

	CurRequest:=1;
	WITH GetCurSt^ DO
	WHILE true DO
	BEGIN
		{ attente d'une requete }
		REPEAT
			ZoneNumber := 70;
			QRequests;
			ZoneNumber := 71;
			IF NbRequest = 0 THEN
			BEGIN
				ZoneNumber := 72;
				WaitRequest;
			END;
		UNTIL NbRequest<>0;
		
		{ recherche requete valide }
		REPEAT
			ZoneNumber := 73;
			CurRequest:=CurRequest+1;
			IF CurRequest>MaxTasks THEN CurRequest:=1;
		UNTIL TheRequests[CurRequest]<>Nil;
 
		{ on traite la requete en cours }
		{ param1 contient le code de la requete }
		{ param2 contient le pointeur sur le car d'entree }
		WITH TheRequests[CurRequest]^ DO
		BEGIN
			ZoneNumber := 74;
			{ infos pour affichage dans Macsbug par la dcmd }
			MaxTime := ORD4(EOwner);
			
			TheOwner := EOwner;	{ TCB de la tâche appelante }
			
			{ envoi requete au modem }
			IF EParam1<>Nil THEN
			BEGIN
				ZoneNumber := 75;
				StrPrint(PStr255(EParam1)^);
			END;
			
			{ reception de la reponse }
			ZoneNumber := 76;
			PaqASRead(CharsPtr(Ord4(EParam2)),20); {240 pour les tests, 5 sinon}
			
			ZoneNumber := 77;
			IF (Error=0) AND (ECode=ReqOn) THEN
				IF (SyncChar-192)=EOwner^.TheModem THEN
				BEGIN   { Requete OK }
					ZoneNumber := 78;
					ERet:=ReqDone;
					EOwner^.Error:=NoErr;
					EOwner^.StatusWord:=ReadyCst;
					TheRequests[CurRequest]:=Nil;
					NbRequest:=NbRequest-1;
					{WaitDelay(1);}
				END;
				
			ZoneNumber := 0;
			MaxTime := 0;
		END;
	END;
END;

END. {of Dragster Run Time}
