UNIT INITdrgutil;


{***********************************************************************}
{*								       																						   *}
{*	  	    Fichier Utilitaires sur le Boot de Dragster     	   		   *}
{*																						       								   *}
{***********************************************************************}


INTERFACE

USES	MemTypes,QuickDraw ,OSIntf ,ToolIntf ,PackIntf, AppleTalk, ADSP;
			
TYPE
	ModsArray	=	ARRAY[0..255] OF RECORD
		ModNum:integer;
		ModRef:integer;
		ModType:INTEGER;
	END;
    SNH	        =	^SNP;
    SNP	        =	^SNR;
    SNR	        =	RECORD
						TheMask,TheSn: Longint;
                  	END;

{$I DragsterTCB.p }

FUNCTION CountModem(RefDrvr: Integer; VAR FlagMaster: boolean; VAR TheMods: ModsArray; VAR Nb: INTEGER; OurStor: TConfHdle):INTEGER;
	{ compte le nombre de modems en ligne, rend FlagMaster si un Modem 00 est là }
	
FUNCTION WordAlign(RefDrvr: integer; VAR SNFlag: Boolean; MySN: SNH): Integer;
	{ checke la protection des modems }

FUNCTION CountMuxASM(RefDrvr: Integer; VAR TheMods: ModsArray; VAR nbMods: INTEGER; OurStor: TConfHdle):INTEGER;
	{ compte le nombre de voies ASM en ligne, rend FlagMaster si on en a trouvé au moins une }
	
FUNCTION TestHayes(refDrvr:INTEGER):BOOLEAN;
	{ teste la présence d'un modem compatible Hayes™ }

VAR
	inBuff1: Ptr;
	outBuff1: Ptr;
	inBuff2: Ptr;
	outBuff2: Ptr;
	
IMPLEMENTATION

{$SETC Debug=FALSE}

CONST ErrTime       =   128;
		  
TYPE
    LIPtr  = ^Longint;
    LIHdle = ^LIPtr;

{$I DragsterTCB.p }

CONST
	STX = chr(2);
	ETX = chr(3);
	DLE = chr(16);
	
FUNCTION num(theNum:longint):str255;

VAR	tempStr:Str255;

BEGIN
	numtostring(theNum,tempstr);
	num := tempStr;
END;


PROCEDURE StrPrint(RefDrvr: Integer; Str1: Str255);
    VAR Err     : OSerr;
        ToWrite : Longint;
BEGIN
    ToWrite:=Length(Str1);
    Err:=FSWrite(RefDrvr, ToWrite, Ptr(Ord(@Str1)+1));
{$IFC Debug} DebugStr(concat('FSWrite Err=',num(Err),' ToWrite=',num(towrite),' "',Str1,'"')); {$ENDC}
END;


PROCEDURE Zinput(RefDrvr: Integer; VAR Str1: Str255; MaxTime: Longint);
     VAR c	  : char;
         TimeLimit: Longint;
         Termine  : boolean;
         nbcar	  : integer;
         Automate : integer;
	
	PROCEDURE GetVChar(VAR c: char);
	
	VAR	Count,
			ToRead: longint;
			Err: OSErr;
			C1: Char;
	
	BEGIN
		C1:=' ';
		Err:=SerGetBuf(RefDrvr+1, count);
{$IFC Debug} DebugStr(concat('SerGetBuf Err=',num(Err), 'Count=', num(Count))); {$ENDC}
		IF Count>0 THEN
		BEGIN
			ToRead:=1;
			Err:=FSRead(RefDrvr+1, ToRead, Ptr(Ord(@C1)+1));
{$IFC Debug} DebugStr(concat('FSRead Err=',num(Err), 'Count=', num(Count), 'ToRead=', num(Toread))); {$ENDC}
			C:=C1;
		END {if count}
		ELSE C:=chr(0);
	END;
	

BEGIN
     Str1 := '';
	 TimeLimit:=TickCount+MaxTime;
     Automate:=0;
     Termine:=False;

     REPEAT
          GetVChar(C);
          IF C<>Chr(0) THEN BEGIN
                    TimeLimit:=TickCount+MaxTime;
                    IF Ord(C)>=192 THEN Automate:=0;
                    CASE Automate OF
                     0: IF Ord(C)>=192 THEN Automate:=1;
                     1: IF C='B' THEN Automate:=2 ELSE Automate:=0;
                     2: IF Ord(C)=128 THEN
                           BEGIN
                            Termine:=True;
                            Automate:=3
                           END
                         ELSE Automate:=0;
                    END;
                    IF Automate>0 THEN Str1[Automate]:=C;
            END;
     UNTIL (TimeLimit<TickCount) OR Termine;

    IF Termine THEN Str1[0]:=CHR(3);
END;

FUNCTION PaqAsRead(RefDrvr: integer; VAR TheBuffer: Str255; TimeLimit: Longint): integer;
     VAR  Err	    : OSErr;
          Index	    : Integer;
          XTimeLimit: Longint;
          SyncChar  : Integer;
          Count	    : Longint;
          ToRead    : Longint;
          termine   : boolean;
		  Error		: Integer;
BEGIN
     Error:=0;
     XTimeLimit:=TickCount+TimeLimit;
     Termine:=False;
     SyncChar:=0;
     TheBuffer:='';

     { synchro sur debut de paquet }
     REPEAT
          Count:=0;
          Err:=SerGetBuf(RefDrvr+1,Count);
          IF Count>2 THEN
          BEGIN
               ToRead:=1;
               Err:=FSRead(RefDrvr+1,ToRead,Ptr(Ord4(@SyncChar)+1));
               Termine:=SyncChar=192;
               { XTimeLimit:=TickCount+TimeLimit; }
          END { else CheckButton} ;
     UNTIL Termine OR (XTimeLimit<TickCount);

     IF (NOT Termine) THEN
     BEGIN
          Error:=ErrTime;
		  PaqAsRead:=Error;
          EXIT(PaqAsRead);
     END;

     Termine:=False;
     Index:=1;
     XTimeLimit:=TickCount+TimeLimit;
     { recup jusqu'a fin de paquet }
     REPEAT
          Count:=0;
          Err:=SerGetBuf(RefDrvr+1,Count);
          IF Count>0 THEN
          BEGIN
               ToRead:=1;
               Err:=FSRead(RefDrvr+1,ToRead,Ptr(Ord4(@SyncChar)+1));
               Termine:=SyncChar=128;
               IF NOT Termine THEN
               BEGIN
                    TheBuffer[Index]:=chr(SyncChar);
                    Index:=Index+1;
                    XTimeLimit:=TickCount+TimeLimit;
               END;
          END { else CheckButton } ;
     UNTIL Termine OR (XTimeLimit<TickCount);

     TheBuffer[0]:=Chr(Index-1);

     IF NOT Termine THEN
     BEGIN
          Error:=ErrTime;
     END;
	 PaqAsRead:=Error;
END;

FUNCTION AsRead(RefDrvr: integer; VAR ThePrompt, TheBuffer: str255; TimeLimit: Longint;
                 SkipEnt: Boolean): Integer;
     LABEL 0;
     VAR Err	    : OSErr;
         NbCar	    : Integer;
         CCon	    : Char;
         XTimeLimit : Longint;
		 Error		: Integer;
BEGIN
          XTimeLimit:=TickCount+TimeLimit;
          Error:=0;

         0:

         IF Length(ThePrompt)>0 THEN
            BEGIN
               StrPrint(RefDrvr,ThePrompt);
            END;

         Error:=PaqAsRead(RefDrvr, TheBuffer, 30);
         IF Error=0 THEN
         BEGIN
                IF SkipEnt THEN
                BEGIN
                  { les entetes de paquets sont deja retires }
                  CCon:=TheBuffer[1]; nbcar:=Length(TheBuffer)-1;
                  BlockMoveData(Ptr(Ord4(@TheBuffer)+2),Ptr(Ord4(@TheBuffer)+1),
                            nbcar);
                  TheBuffer[0]:=chr(NbCar);
                  { on verifie la validite connexion }
                  IF CCon='F' THEN
                       BEGIN
                          Error:=ErrTime;
                          TheBuffer:='';
						  ASread:=Error;
                          EXIT(AsRead);
                       END
                  ELSE IF CCon='c' THEN
                         BEGIN
                              XTimeLimit:=TickCount+TimeLimit;
                         END;
                  IF XTimeLimit<TickCount THEN
                       BEGIN
                          Error:=ErrTime;
                          TheBuffer:='';
						  ASRead:=Error;
                          EXIT(AsRead);
                       END;
                  IF Length(TheBuffer)=0 THEN
                         GOTO 0;
                END;
         END
         ELSE
         BEGIN
            TheBuffer:='';
            Error:=ErrTime;
         END;
		 ASRead:=Error;
END;

PROCEDURE PaqPrep(VAR TheBuffer: Str255; ComChar: Char);
     VAR nbcar	    : integer;
BEGIN
         nbcar:=Length(TheBuffer);
         IF nbcar>240 THEN nbcar:=240;
         BlockMoveData(Ptr(Ord4(@TheBuffer)+1),Ptr(Ord4(@TheBuffer)+3),nbcar);
         TheBuffer[1]:=chr($C0);
         TheBuffer[2]:=ComChar;
         TheBuffer[nbcar+3]:=chr($80);
         TheBuffer[0]:=chr(NbCar+3);
END;

PROCEDURE SwapBits(VAR K: longint; Bit1,Bit2: integer);
     VAR FBit1,FBit2: Boolean;
BEGIN
     FBit1:=BTst(K,Bit1);
     FBit2:=BTst(K,Bit2);
     IF FBit1 THEN BSET(K,Bit2) ELSE BCLR(K,Bit2);
     IF FBit2 THEN BSET(K,Bit1) ELSE BCLR(K,Bit1);
END;

FUNCTION WordAlign(RefDrvr: integer; VAR SNFlag: Boolean; MySN: SNH): Integer;
    LABEL 0;
     VAR  Key,
          keyB,
          IdC:	    longint;
          Str1,
          Str2:	    str255;
          i:	    integer;
          retrys:   integer;
		  Error:	integer;
BEGIN
    retrys:=0;

    REPEAT
        retrys:=retrys+1;
        SnFlag:=False;
         { test du numero de serie du modem }
         Key:=BXOR(BRotL(TickCount,BAnd(TickCount,15)),$47DA2E51);
         Str1:='@@@@@@@@';
         FOR i:=1 TO 8 DO
              Str1[i]:=chr($40+BAND(BSR(Key,32-(i*4)),$0F));
         {Writeln('paquet 0: 0',Str1);}
         PaqPrep(Str1,'0');
         Error:=AsRead(RefDrvr,Str1,Str2,120,false);
         IF Error<>0 THEN
           BEGIN
              SnFlag:=True;
              GOTO 0;
           END;

         {Writeln('paquet 1: ',Str2);}

         KeyB:=0;
         FOR i:=1 TO 8 DO
              KeyB:=BOR(KeyB,BSL(BAND(Ord(Str2[1+i]),$0F),32-(i*4)));
         { keyB est la clé de cryptage }

         Idc:=0;
         FOR i:=1 TO 8 DO
              Idc:=BOR(Idc,BSL(BAND(Ord(Str2[9+i]),$0F),32-(i*4)));
         { Idc est crypte avec ma cle }
         { je triture ma clé }
         Key:=BXOR(Key,$A720351D);
         i:=BAND(BSR(Key,16),31)+1;
         Key:=BRotL(Key,i);
         SwapBits(Key,3,15);
         SwapBits(Key,7,13);
         SwapBits(Key,10,28);
         SwapBits(Key,22,31);
         Idc:=BXOR(BXOR(Idc,Key),MySn^^.TheMask);
         SnFlag:=Idc<>MySn^^.TheSn;
         {Writeln(SnFlag);}
         IF SnFlag THEN
              GOTO 0;

         { j'encrypte avec la clé qu'on m'a donné }
         Key:=KeyB;
         { je triture ma clé }
         Key:=BXOR(Key,$A720351D);
         i:=BAND(BSR(Key,16),31)+1;
         Key:=BRotL(Key,i);
         SwapBits(Key,3,15);
         SwapBits(Key,7,13);
         SwapBits(Key,10,28);
         SwapBits(Key,22,31);
         Key:=BXOR(BXOR(MySn^^.TheSn,MySn^^.TheMask),Key);

         Str1:='@@@@@@@@';
         FOR i:=1 TO 8 DO
              Str1[i]:=chr($40+BAND(BSR(Key,32-(i*4)),$0F));

         {Writeln('paquet 2: 2',Str1);}
         PaqPrep(Str1,'2');
         StrPrint(RefDrvr,Str1);
         0:
     UNTIL (retrys>=5) OR (NOT SnFlag);
	 WordAlign:=Error;
END;


FUNCTION TestHayes(refDrvr:INTEGER):BOOLEAN;

VAR	XTimeLimit: LONGINT;
		Count: LONGINT;
		Recv: Str255;
		Err: INTEGER;
		Test: INTEGER;
		ok: BOOLEAN;
		
BEGIN
	ok := FALSE;
	FOR Test := 1 TO 3 DO
	BEGIN
		Recv := concat('AT',chr(13));
		StrPrint(RefDrvr,Recv);

		XTimeLimit:=TickCount+120;
		{ recup jusqu'a CR }
		Recv:='';
		REPEAT
			Count:=0;
			Err:=SerGetBuf(RefDrvr+1,Count);
			IF Count>0 THEN
			BEGIN
				Count:=1;
				Err:=FSRead(RefDrvr+1,Count,@Recv[length(Recv)+1]);
				Recv[0]:=CHR(Length(Recv)+Count);
				IF Length(Recv)>200 THEN Delete(Recv,1,1);
				ok := (Pos('OK',Recv)<>0);
			END;
		UNTIL ok OR (XTimeLimit<TickCount);
		IF ok THEN Leave;
	END;
	IF ok THEN
	BEGIN
		Delay(60,count);
		Recv := concat('ATE0V1S0=1',chr(13));
		StrPrint(RefDrvr,Recv);
		Delay(60,count);
	END;
	TestHayes := ok;
END;

FUNCTION CountModem(RefDrvr: Integer; VAR FlagMaster: boolean; VAR TheMods: ModsArray; VAR Nb: INTEGER; OurStor: TConfHdle):INTEGER;
{	scrute modems Dragster
	si 64 modems présents, c'est sûrement un modem Hayes
}
VAR	i: integer;
	StrP,StrR: str255;
	c:CHAR;
	
BEGIN
	{ 6/4/93 - envoi d'un ATE0 pour éviter l'écho des modems Hayes }
	StrP := concat('ATE0',chr(13));
	StrPrint(RefDrvr, StrP);
	
	FlagMaster:=False;
	StrP:=' B ';
	StrP[3]:=Chr(128);
	FOR i:=0 TO 63 DO
	BEGIN
		StrP[1]:=Chr($C0+i);
		StrPrint(RefDrvr,StrP);
		StrR:='';
		Zinput(RefDrvr,StrR,6);
		
		IF StrP=StrR THEN
		BEGIN
			nb:=nb+1;
			TheMods[nb].ModNum:=i;				{ numéro du modem }
			TheMods[nb].ModRef:=RefDrvr;	{ driver pour y accéder }
			TheMods[nb].ModType:=ModemDrg;
			IF i=0 THEN FlagMaster:=True;
		END;
		IF (i=0) & (FlagMaster=FALSE) THEN Leave;	{ pas de modem maitre ! }
	END;
	
	IF Nb=64 THEN
	BEGIN		{ ça doit être un modem Hayes™ }
		nb := 0;
(*
		nb:=1;
		TheMods[1].ModNum := 0;
		TheMods[1].ModRef:=RefDrvr;	{ driver pour y accéder }
		TheMods[1].ModType:=modemHayes;
		FlagMaster := FALSE;
*)
	END;
	CountModem:=Nb;
END;


PROCEDURE MuxRead(RefDrvr: integer; VAR TheBuffer: Str255; TimeLimit: Longint);

VAR	Err			: OSErr;
	TimeOut		: Longint;
	Count	    : Longint;
	ToRead    	: Longint;
	Error		: Integer;
	State		: INTEGER;
	
BEGIN
	Error:=0;
	TimeOut:=TickCount+TimeLimit;
	TheBuffer:='';
	State := 0;	{ on attend un STX de début de trame }

	REPEAT
		Count:=0;
		Err:=SerGetBuf(RefDrvr+1,Count);
		IF Count>0 THEN
		BEGIN
			ToRead:=1;
			Err:=FSRead(RefDrvr+1,ToRead,@theBuffer[length(thebuffer)+1]);
			CASE State OF
				0:	{ attente de STX de début de trame }
					IF theBuffer[length(thebuffer)+1]=STX THEN State := 1;
				1:
				IF (length(thebuffer)>2) & (theBuffer[length(thebuffer)+1]=ETX) THEN
					State := 2
				ELSE
					theBuffer[0] := CHR(ORD(theBuffer[0])+1);
			END;
		END;
	UNTIL (State=2) OR (TickCount>TimeOut);

END;


FUNCTION CountMuxASM;

VAR	i: integer;
	StrP: str255;
	nb: INTEGER;
	TypeMux: INTEGER;
	max: Integer;
	
  PROCEDURE PrintMux(Str1: Str255);
  
  BEGIN
	  StrPrint(RefDrvr,concat(STX,str1,ETX));
  END;
  
BEGIN
{$IFC DEBUG}
	DebugStr('CountMuxAsm');
{$ENDC}

	CountMuxASM := 0;
	
	{ 28/4/98 - on vide le buffer de réception }
	REPEAT
		StrP := '';
		MuxRead(RefDrvr,StrP,30);
	UNTIL StrP='';

	{ on envoie une trame au format ASM normal pour détecter l'ASM Transparent }
	StrP := concat(STX,'0',chr(255),chr(0),chr(0),ETX);	{ envoi des données sur CV inexistant }
	StrPrint(RefDrvr,StrP);

	StrP := '';
	MuxRead(RefDrvr,StrP,60);
{$IFC DEBUG}
DebugStr(concat('Rep1="',strp,'"'));
{$ENDC}
	IF (Strp<>'') & (Strp[1]='?') THEN	{ on doit recevoir une trame $3F d'erreur }
	BEGIN
{$IFC DEBUG}
DebugStr('Multiplexeur ASM/T');
{$ENDC}
		TypeMux := MuxASMT;			{ on est en ASMT si on a reçu une trame de 6 octets }
	END
	ELSE	{ 24/4/98 - modif détection ASM/T sur nouvelle version soft ModComp 64cv }
	BEGIN
		{ on envoie une trame au format ASM normal pour détecter l'ASM Transparent }
		StrP := concat(STX,ETX,ETX,ETX,ETX,ETX);	{ envoi des données incohérentes }
		StrPrint(RefDrvr,StrP);
	
		StrP := '';
		MuxRead(RefDrvr,StrP,60);
{$IFC DEBUG}
DebugStr(concat('Rep2="',strp,'"'));
{$ENDC}
		IF (Strp<>'') & (Strp[1]='?') THEN	{ on doit recevoir une trame $3F d'erreur }
		BEGIN
{$IFC DEBUG}
DebugStr('Multiplexeur ASM/T');
{$ENDC}
			TypeMux := MuxASMT;			{ on est en ASMT si on a reçu une trame de 6 octets }
		END
		ELSE
			TypeMux := MuxASM;
	END;
	
	{ 18/1/95 - on vide le buffer de réception }
	REPEAT
		StrP := '';
		MuxRead(RefDrvr,StrP,30);
	UNTIL StrP='';
	
	IF OurStor^^.AntPqSize <> 0 THEN { premier N° de voie ASM }
	BEGIN
		max := OurStor^^.X25Number-nbMods;
		IF (max>32) AND (TypeMux=MuxASMT) THEN
			max := 32;	{ 7/1/98 - 32cv maxi par liaison série en ASM/T }
		
		FOR i := 1 TO max DO
		BEGIN
			nbMods := nbMods+1;
			TheMods[nbMods].ModNum:=OurStor^^.AntPqSize+i-1;			{ numéro de voie ASM }
			TheMods[nbMods].ModRef:=RefDrvr;											{ driver pour y accéder }
			TheMods[nbMods].ModType := TypeMux;										{ type d'ASM }
		END;
		CountMuxAsm := nbMods;
		EXIT(CountMuxASM);
	END;
	
	{ on vide le buffer de réception… }
	REPEAT
		MuxRead(RefDrvr,Strp,120);
	UNTIL Strp='';
	
	FOR i:=4 TO 255 DO
    BEGIN
		StrP := concat('2',chr(i));
		PrintMux(StrP);
		MuxRead(RefDrvr,StrP,6);
		IF (i=4) & (StrP='') THEN EXIT(CountMuxASM);
		IF (length(StrP)>0) & ((StrP[1]='2') | (StrP[1]=CHR($3C))) THEN	{ il y a bien une voie ici !! }
		BEGIN
			nbMods:=nbMods+1;
			TheMods[nbMods].ModNum:=i;						{ numéro du modem }
			TheMods[nbMods].ModRef:=RefDrvr;			{ driver pour y accéder }
			TheMods[nbMods].ModType := TypeMux;
{$IFC DEBUG}
			DebugStr('une voie');
{$ENDC}
		END;
	END;
	CountMuxASM:=nbMods;
END;

END. { of Unit }
