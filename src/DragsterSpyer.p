UNIT DragSpyer;

			{ Tache d'espionnage de Dragster }
			
INTERFACE

USES	MemTypes,QuickDraw ,OSIntf ,ToolIntf ,PackIntf, AppleTalk,
		ADSP, OsUtils, Traps;

TYPE
        Pstr255 =       ^Str255;

PROCEDURE MyPTProc;  { Tache d'espionnage }
PROCEDURE MyPCheck;  { restart the faulty task }


IMPLEMENTATION

     {$I DragsterTCB.p}

	 CONST
	 	kSpyerFileName = 'Dragster Error';
		
	 TYPE
		TCBsArray	=	ARRAY[1..MaxTasks] OF TPtr;
		TCBsPtr		=	^TCBsArray;
		IntPtr		=	^Integer;
		RegTab	=		RECORD
							Dr: ARRAY[0..7] OF Longint;
							Ar:	ARRAY[0..7] OF Ptr;
						END;
		RegTabPtr=		^RegTab;
		TVar		=	RECORD
							Regs	:	RegTabPtr;
							pc		:	Ptr;
							sr		:	integer;
							FTCB	:	TPtr;
							TheSEid	:	integer;
							TheVol	:	Integer;
							TheFile	:	Integer;
							TheMod	:	Integer;
							TheLine	:	Integer;
							TheInst	:	Integer;
							TheIndex:	Integer;
							TheBound:	Integer;
							ThePhase:	Integer;
							TheStr	:	Str255;
							pb		:	ParamBlockRec;
						END;
		TVarPtr		=	^TVar;
		
		tVar2		= RECORD
						NumTache: INTEGER;
						QuandTache: LONGINT;
						CombienTache: INTEGER;
					END;
		tVar2Ptr=^tVar2;


FUNCTION GetCheck1: TVarPtr; EXTERNAL;
FUNCTION GetCheck2: TVarPtr; EXTERNAL;
FUNCTION GetCheck3: tVar2Ptr; EXTERNAL;
FUNCTION GetMyJump: Ptr; EXTERNAL;
FUNCTION GetMyIdle: Longint; EXTERNAL;


PROCEDURE MGetVol(ThePtr: TVarPtr; TheProc: Ptr);
     VAR Err	    : OSErr;
BEGIN
         WITH ThePtr^,ThePtr^.pb DO
         BEGIN
		 		 ThePhase:=ThePhase+1;
                 ioCompletion:=TheProc;
				 ioNamePtr:=Nil;
				 ioVRefNum:=0;
				 ioVolIndex:=1;
         		 Err:=PBGetVInfo(@pb,true);
         END;
END;

PROCEDURE MDelete(ThePtr: TVarPtr; TheProc: Ptr);
     VAR Err	    : OSErr;
BEGIN
         WITH ThePtr^,ThePtr^.pb DO
         BEGIN
		 		 ThePhase:=ThePhase+1;
                 ioCompletion:=TheProc;
				 ioNamePtr:=@TheStr;
				 ioVRefNum:=TheVol;
				 ioFVersNum:=0;
         		 Err:=PBDelete(@pb,true);
         END;
END;

PROCEDURE MCreate(ThePtr: TVarPtr; TheProc: Ptr);
     VAR Err	    : OSErr;
BEGIN

         WITH ThePtr^ DO
		 CASE ThePhase OF
		 1:
	 	 {********************* Create *********************}
         WITH pb DO
         BEGIN
		 		 ThePhase:=ThePhase+1;
                 ioCompletion:=TheProc;
                 ioNamePtr:=@TheStr;
                 ioVRefNum:=TheVol;
                 ioVersNum:=0;
		 		 Err:=PBCreate(@pb,True);
         END;
		 
		 2:
         {********************* Get Info *********************}
         WITH pb DO
         BEGIN
		 		 ThePhase:=ThePhase+1;
                 ioCompletion:=TheProc;
                 ioNamePtr:=@TheStr;
                 ioVRefNum:=TheVol;
                 ioVersNum:=0;
                 ioFDirIndex:=0;
		 		 Err:=PBGetFInfo(@Pb,True);
         END;

		 3:
         {******************** Set Info *********************}
         WITH pb DO
         BEGIN
		 		 ThePhase:=ThePhase+1;
                 ioCompletion:=TheProc;
                 ioFlFndrInfo.fdType:='TEXT';
                 ioFlFndrInfo.fdCreator:='MPS ';
		 		 Err:=PBSetFInfo(@Pb,True);
         END;
		 END; { case et with }
END;

PROCEDURE MOpen(ThePtr: TVarPtr; TheProc: Ptr);
     VAR Err	    : OSErr;
BEGIN
         WITH ThePtr^,ThePtr^.pb DO
         BEGIN
		 		 ThePhase:=ThePhase+1;
                 ioCompletion:=TheProc;
                 ioNamePtr:=@TheStr;
                 ioVRefNum:=TheVol;
                 ioPermssn:=fsrdwrperm;
				 iomisc:=Nil;
		 		 Err:=PBOpen(@pb,True);
         END;
END;

PROCEDURE MClose(ThePtr: TVarPtr; TheProc: Ptr);
     VAR Err	    : OSErr;
BEGIN
         WITH ThePtr^,ThePtr^.pb DO
         BEGIN
		 		 ThePhase:=ThePhase+1;
                 ioCompletion:=TheProc;
				 ioRefNum:=TheFile;
         		 Err:=PBClose(@pb,True);
         END;
END;

PROCEDURE MFlush(ThePtr: TVarPtr; TheProc: Ptr);
     VAR Err	    : OSErr;
BEGIN
         WITH ThePtr^,ThePtr^.pb DO
         BEGIN
		 		 ThePhase:=ThePhase+1;
                 ioCompletion:=TheProc;
				 ioNamePtr:=Nil;
				 ioVRefNum:=TheVol;
         		 Err:=PBFlushVol(@pb,True);
         END;
END;

PROCEDURE MWLn(ThePtr: TVarPtr; TheProc: Ptr);
     VAR Err	    : OSErr;
BEGIN
         WITH ThePtr^,ThePtr^.pb DO
         BEGIN
		 		 TheStr[1]:=chr(13);
		 		 ThePhase:=ThePhase+1;
                 ioCompletion:=TheProc;
				 ioRefNum:=TheFile;
				 ioBuffer:=Ptr(Ord4(@TheStr)+1);
				 ioReqCount:=1;
				 ioPosMode:=fsfromLEof;
				 ioPosOffset:=0;
         		 Err:=PBWrite(@pb,True);
         END;
END;

PROCEDURE MWStr(ThePtr: TVarPtr; TheProc: Ptr);
     VAR Err	    : OSErr;
BEGIN
         WITH ThePtr^,ThePtr^.pb DO
         BEGIN
		 		 ThePhase:=ThePhase+1;
                 ioCompletion:=TheProc;
				 ioRefNum:=TheFile;
				 ioBuffer:=Ptr(Ord4(@TheStr)+1);
				 ioReqCount:=length(TheStr);
				 ioPosMode:=fsfromLEof;
				 ioPosOffset:=0;
         		 Err:=PBWrite(@pb,True);
         END;
END;

PROCEDURE MWLnStr(ThePtr: TVarPtr; TheProc: Ptr);
BEGIN
	WITH ThePtr^ DO
	BEGIN
		TheStr[0]:=chr(length(TheStr)+1);
		TheStr[length(TheStr)]:=chr(13);
		MWStr(ThePtr,TheProc);
	END;
END;


PROCEDURE Conv(VAR TheStr: Str255; Num: integer; Idx: integer);
BEGIN
	TheStr[Idx]  :=chr((Num DIV 10)+ord('0'));
	TheStr[Idx+1]:=chr((Num MOD 10)+ord('0'));
END;


PROCEDURE MConv(VAR TheStr: Str255; TheNum: Longint; Idx,len: integer);
	VAR i: integer;
BEGIN
	IF TheNum<0 THEN
	BEGIN
		TheNum:=-TheNum;
		TheStr[idx]:='-';
		idx:=idx+1;
		len:=len-1;
	END;
	FOR i:=idx+len-1 DOWNTO idx DO
	BEGIN
		IF TheNum>0 THEN
			TheStr[i]:=chr(ord('0')+TheNum MOD 10)
		ELSE
			TheStr[i]:=' ';
		TheNum:=TheNum DIV 10;
	END;
	IF TheStr[Idx+Len-1]=' ' THEN TheStr[Idx+Len-1]:='0';
END;

	
PROCEDURE MHConv(VAR TheStr: Str255; TheNum: Longint; Idx,len: integer);
	VAR i,j: integer;
BEGIN
	FOR i:=idx+len-1 DOWNTO idx DO
	BEGIN
		j:=bitand(TheNum,$0F);
		TheNum:=bsr(thenum,4);
		IF j<10 THEN
			TheStr[i]:=chr(ord('0')+j)
		ELSE
			TheStr[i]:=chr(ord('A')-10+j);
	END;
END;


FUNCTION GetScreenName(theNScreen: INTEGER; Names:TPtNameScreen):TPtNameScreen;

VAR	index: INTEGER;
	cherche: BOOLEAN;
	TheS: TPtNameScreen;
	LenTexte : Integer;
		
BEGIN
	TheS 	:= Names;	{ adresse de la table des noms de modules }
	Index	:= 0;
	Cherche	:= True;
	WHILE (Index < theNScreen) & Cherche DO
	BEGIN
		Cherche := NOT(Length(TheS^)=0);
		IF Cherche THEN
		BEGIN
			Index := Index+1;
			LenTexte := Length(TheS^) +1;
			TheS := TPtNameScreen(Ord4(TheS) + LenTexte);
			IF ODD(LenTexte) THEN TheS := TPtNameScreen(Ord4(TheS)+1);
		END;
	END;
	GetScreenName := TheS;
END;


PROCEDURE DoRestart;

BEGIN
	ShutDwnStart;	{ on redémarre le Mac proprement }
END;


PROCEDURE MyPCheck;  { restart the faulty task }
	TYPE
		IntPtr	= ^Integer;
	VAR DTRec	: DateTimeRec;
		CurTime : Longint;
		i,j		: Integer;
		Termine,
		FlagUNLK: Boolean;
		xpc		: Ptr;
BEGIN
	WITH GetCheck1^ DO
	CASE ThePhase OF
	0:
		BEGIN
			WITH GetCheck3^ DO
			BEGIN
				IF NumTache=FTCB^.TaskNumber THEN
				BEGIN
					GetDateTime(curtime);
					IF QuandTache>curTime-10 THEN	{ moins de 10s entre 2 plantages }
					BEGIN
						IF CombienTache>1 THEN DoRestart	{ on redémarre après 2 plantages }
						ELSE
							CombienTache := CombienTache+1;
					END
					ELSE
					BEGIN
						QuandTache := curTime;	{ plantage plus de 10s après le précédent }
						CombienTache := 1;
					END;
				END	ELSE BEGIN
					NumTache := FTCB^.TaskNumber;	{ plantage sur autre voie ! }
					GetDateTime(QuandTache);
					CombienTache := 1;
				END;
			END;	{ WITH GetCheck3^ }
			
			IF odd(ord4(pc)) THEN
				pc:=ptr(ord4(pc)+1);
			TheMod:=FTCB^.TheNScreen+1;			{ infos de debug }
			TheLine:=FTCB^.TheNLine;
			TheInst:=FTCB^.TheNInst;
			
			sysbeep(5);
			MGetVol(GetCheck1,@MyPCheck);
		END;
	1:
		BEGIN
			TheVol:=pb.ioVRefNum;
			TheStr:= kSpyerFileName;
			MCreate(GetCheck1,@MyPCheck);
		END;
	2,3:
		BEGIN
			TheStr:=kSpyerFileName;
			MCreate(GetCheck1,@MyPCheck);
		END;
	4:
		BEGIN
			TheStr:=kSpyerFileName;
			MOpen(GetCheck1,@MyPCheck);
		END;
	5:
		BEGIN
			TheFile:=pb.ioRefNum;
			TheStr:='Dragster System Error at XX/XX/XX - 99:99:99';
			GetDateTime(CurTime);
			Secs2Date(CurTime,DTRec);
			WITH DTRec DO
			BEGIN
			   Conv(TheStr,day,26);
			   Conv(TheStr,month,29);
			   Conv(TheStr,year-1900,32);
			   Conv(TheStr,hour,37);
			   Conv(TheStr,minute,40);
			   Conv(TheStr,second,43);
			END;
			MWLnStr(GetCheck1,@MyPCheck);
		END;
	6:
		BEGIN
			TheStr:='Faulty task: XXXX  Module: XXXX  Line: XXXX  Inst: XXXX';
			MConv(TheStr,FTcb^.TaskNumber,14,4);
			MConv(TheStr,TheMod,28,4);
			MConv(TheStr,TheLine,40,4);
			MConv(TheStr,TheInst,52,4);
			IF FTcb^.TaskNumber<1024 THEN TheStr := concat(theStr,' (',GetScreenName(TheMod-1,FTcb^.PtNameScreen)^,')');
			MWLnStr(GetCheck1,@MyPCheck);
		END;
	7:
		BEGIN
			TheStr:='System Error #XX';
			MConv(TheStr,TheSEId,15,2);
			MWLnStr(GetCheck1,@MyPCheck);
		END;
	8:
		BEGIN
			TheStr:='PC: XXXXXXXX      SR: XXXX';
			MHConv(TheStr,ord4(pc),5,8);
			MHConv(TheStr,sr,23,4);
			MWLnStr(GetCheck1,@MyPCheck);
		END;
	9:
		BEGIN
			TheStr:='D0       D1       D2       D3       D4       D5       D6       D7';
			MWLnStr(GetCheck1,@MyPCheck);
		END;
	10:
		BEGIN
			TheStr:='XXXXXXXX XXXXXXXX XXXXXXXX XXXXXXXX XXXXXXXX XXXXXXXX XXXXXXXX XXXXXXXX';
			FOR i:=0 TO 7 DO
				MHConv(TheStr,Regs^.Dr[i],1+i*9,8);
			MWLnStr(GetCheck1,@MyPCheck);
		END;
	11:
		BEGIN
			TheStr:='A0       A1       A2       A3       A4       A5       A6       A7';
			MWLnStr(GetCheck1,@MyPCheck);
		END;
	12:
		BEGIN
			TheStr:='XXXXXXXX XXXXXXXX XXXXXXXX XXXXXXXX XXXXXXXX XXXXXXXX XXXXXXXX XXXXXXXX';
			FOR i:=0 TO 7 DO
				MHConv(TheStr,ord4(Regs^.Ar[i]),1+i*9,8);
			MWLnStr(GetCheck1,@MyPCheck);
		END;
	13:
		BEGIN
			TheStr:='Task control block: XXXXXXXX';
			MHConv(TheStr,ord4(FTCB),21,8);
			MWLnStr(GetCheck1,@MyPCheck);
		END;
	14:
		BEGIN
			TheStr:='Task start of code: XXXXXXXX';
			MHConv(TheStr,ord4(FTCB^.PtCode),21,8);
			MWLnStr(GetCheck1,@MyPCheck);
		END;
	15:
		BEGIN
			TheStr:='Task start of RT  : XXXXXXXX';
			MHConv(TheStr,ord4(FTCB^.PtJump),21,8);
			MWLnStr(GetCheck1,@MyPCheck);
		END;
	16:
		BEGIN
			TheStr:='Task start of shrd: XXXXXXXX';
			MHConv(TheStr,ord4(FTCB^.PtSVars),21,8);
			MWLnStr(GetCheck1,@MyPCheck);
		END;
	17:
		BEGIN
			TheStr:='Task start of prvt: XXXXXXXX';
			MHConv(TheStr,ord4(FTCB^.PtLVars),21,8);
			MWLnStr(GetCheck1,@MyPCheck);
		END;
	18:
		BEGIN
			TheStr:='Task status       : XXXX';
			MConv(TheStr,FTCB^.StatusWord,21,4);
			MWLnStr(GetCheck1,@MyPCheck);
		END;
	19:
		BEGIN
			TheStr:='Suspected fonction: USER CODE';
			Termine:=false; j:=0; FlagUNLK:=false; xpc:=pc;
			IF (ord4(pc)<ord4(FTCB^.PtCode)) | (ord4(pc)>ord4(FTCB^.PtJump)) THEN	{ si on n'est pas dans le code de la tâche }
			BEGIN
				WHILE (NOT termine) AND (j<2000) DO
				BEGIN
					{ recherche de UNLK, JMP(A0) ou RTS, resp 4E5E,4E75,4ED0}
					i:=IntPtr(xpc)^;
					IF i=$4E5E THEN FlagUNLK:=True;
					termine:=(i=$4E75) OR (i=$4ED0);
					xpc:=ptr(ord4(xpc)+2);
					j:=j+1;
				END;
				IF termine THEN { on a trouve JMP(A0) ou RTS }
				BEGIN
					{ on regarde s'il y a un nom }
					TheStr:='Suspected fonction: UNDEFINED';
					i:=IntPtr(xpc)^;
					i:=bsr(i,8);
					IF i>127 THEN
					BEGIN
						i:=i-128;
						IF (chr(i) IN ['0'..'9','A'..'Z']) THEN
						BEGIN
							{ il y a un nom }
							BlockMoveData(xpc,ptr(ord4(@TheStr)+21),8);
							TheStr[21]:=chr(ord(TheStr[21])-128);
							TheStr[29]:=' ';
							IF FlagUNLK THEN
							BEGIN
								{ recherche arrière du LINK }
								Termine:=false; j:=0; xpc:=pc;
								WHILE (NOT termine) AND (j<2000) DO
								BEGIN
									{ recherche de LINK 4E56}
									i:=IntPtr(xpc)^;
									IF i = $4E56 THEN
										Termine:=true
									ELSE
										xpc:=ptr(ord4(xpc)-2);
									j:=j+1;
								END;
								IF termine THEN
								BEGIN
									{ on donne l'offset dans la fonction }
									TheStr[0]:=chr(28+5);
									TheStr[29]:='+';
									MHConv(TheStr,ord4(pc)-ord4(xpc),30,4);
								END;
							END;
						END;
					END;
				END;
			END;
			IF TheSEid<>5 THEN ThePhase:=ThePhase+1;
			MWLnStr(GetCheck1,@MyPCheck);
		END;
	20:
		BEGIN
			TheStr:='Index value had to be between 0 and XXXXX, was XXXXXX';
			i:=IntPtr(Ord4(pc)-2)^;
			MConv(TheStr,i,37,5);
			i:=IntPtr(Ord4(pc)-4)^;
			i:=bsr(band(i,$0F00),9);
			i:=Regs^.Dr[i];
			MConv(TheStr,i,48,6);
			MWLnStr(GetCheck1,@MyPCheck);
		END;
	21:
		BEGIN
			TheStr:='Task has been restarted.';
			MWLnStr(GetCheck1,@MyPCheck);
		END;
	22:
		BEGIN
			MWLn(GetCheck1,@MyPCheck);
		END;
	23:
		BEGIN
			MClose(GetCheck1,@MyPCheck);
		END;
	24:
		BEGIN
			MFlush(GetCheck1,@MyPCheck);
		END;
	25:
		BEGIN
			FTCB^.StatusWord:=StartCst;			{ on remet dans l'etat initial }
			Regs^.Ar[0]:=@FTCB^.RegAreaF;		{ pour resched }

			ThePhase:=0;
			sysbeep(5);
		END;
	END; { case and with }
	
END;


PROCEDURE MyPTProc;  { Tache d'espionnage }
	VAR DTRec	: DateTimeRec;
		CurTime : Longint;
		TheJump	: TJumpPtr;


BEGIN
	WITH GetCheck2^ DO
	CASE ThePhase OF
	0:
		BEGIN
			sysbeep(5);
			ThePhase:=-2;
			MGetVol(GetCheck2,@MyPTProc);
		END;
	-1:
		BEGIN
			TheVol:=pb.ioVRefNum;
			TheStr:='Dragster Spyer Report';
			ThePhase:=0;
			MDelete(GetCheck2,@MyPTProc);
		END;
	1:
		BEGIN
			TheStr:='Dragster Spyer Report';
			MCreate(GetCheck2,@MyPTProc);
		END;
	2,3:
		BEGIN
			TheStr:='Dragster Spyer Report';
			MCreate(GetCheck2,@MyPTProc);
		END;
	4:
		BEGIN
			TheStr:='Dragster Spyer Report';
			MOpen(GetCheck2,@MyPTProc);
		END;
	5:
		BEGIN
			TheFile:=pb.ioRefNum;
			TheStr:='Dragster Spyer Report at XX/XX/XX - 99:99:99';
			GetDateTime(CurTime);
			Secs2Date(CurTime,DTRec);
			WITH DTRec DO
			BEGIN
			   Conv(TheStr,day,26);
			   Conv(TheStr,month,29);
			   Conv(TheStr,year-1900,32);
			   Conv(TheStr,hour,37);
			   Conv(TheStr,minute,40);
			   Conv(TheStr,second,43);
			END;
			MWLnStr(GetCheck2,@MyPTProc);
		END;
	6,8,10,14,18:
		BEGIN
			MWLn(GetCheck2,@MyPTProc);
		END;
	7:
		BEGIN
			TheStr:='report every XXXXXX seconds.';
			MConv(TheStr,GetMyIdle DIV 1000,14,6);
			MWLnStr(GetCheck2,@MyPTProc);
		END;
	9:
		BEGIN
			TheStr:='Last running task: XXXX';
			FTcb:=TPtr(GetMyJump);
			TheJump:=TJumpPtr(Ord4(FTcb^.PtJump)-SizeOf(TJumpRec)-4);
			MConv(TheStr,TheJump^.CurStPtr^.TaskNumber,20,4);
			MWLnStr(GetCheck2,@MyPTProc);
		END;
	11,13:
		BEGIN
			TheStr:='    -------------------';
			MWLnStr(GetCheck2,@MyPTProc);
		END;
	12:
		BEGIN
			TheStr:='     Task Status table';
			MWLnStr(GetCheck2,@MyPTProc);
		END;
	15:
		BEGIN
			TheStr:='task-stat-----mod--line-inst';
			MWLnStr(GetCheck2,@MyPTProc);
		END;
	17:
		BEGIN
			TheStr:='----------------------------';
			MWLnStr(GetCheck2,@MyPTProc);
		END;
	16:
		BEGIN
			TheStr:='                            ';
			WITH FTcb^ DO
			BEGIN
				MConv(TheStr,TaskNumber,1,4);
				MConv(TheStr,StatusWord,8,2);
				MConv(TheStr,TheNScreen+1,14,4);
				MConv(TheStr,TheNLine,20,4);
				MConv(TheStr,TheNInst,26,3);
			END;
		
			{ au suivant... }
			FTcb:=TPtr(Ord4(FTcb)+SizeOf(TRecord));
			IF FTcb^.MagicN1=$12345678 THEN ThePhase:=ThePhase-1;
			MWLnStr(GetCheck2,@MyPTProc);
		END;
	19:
		BEGIN
			MClose(GetCheck2,@MyPTProc);
		END;
	20:
		BEGIN
			MFlush(GetCheck2,@MyPTProc);
		END;
	21:
		BEGIN
			ThePhase:=0;
		END;
	END; { case and with }
	
END; {of MyPTProc}

END. {of Unit}
