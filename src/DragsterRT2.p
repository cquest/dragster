{ ======== deuxième partie de la Run-Time ======== }
UNIT DragsterRT;

INTERFACE

{$DECL DrgTree}
{$SETC DrgTree := TRUE}

USES	MemTypes, OSIntf ,ToolIntf ,PackIntf, AppleTalk, ADSP, TextUtils,
		{$U :Wintree:DrgTree.p} DrgTree;

{$D+}
{$R+}

TYPE
        Pstr255 =       ^Str255;

FUNCTION NumPlus(Num1, Num2: Longint): Longint;
FUNCTION Moins(Num1, Num2: Longint): Longint;
FUNCTION SNeg(Num1: Longint): Longint;
FUNCTION SDiv(Num1,Num2: Longint): Longint;
FUNCTION Mul(Num1,Num2: Longint): Longint;
FUNCTION NumOr(Num1,Num2: Longint): Longint;
FUNCTION NumAnd(Num1,Num2: Longint): Longint;
FUNCTION SNot(Num1: Longint): Longint;
FUNCTION NumEq(Num1, Num2: Longint): Longint;
FUNCTION StrEq(VAR Str1, Str2: Str255): Longint;
FUNCTION NumDiff(Num1, Num2: Longint): Longint;
FUNCTION StrDiff(VAR Str1, Str2: Str255): Longint;
FUNCTION NumInf(Num1, Num2: Longint): Longint;
FUNCTION StrInf(VAR Str1, Str2: Str255): Longint;
FUNCTION NumSup(Num1, Num2: Longint): Longint;
FUNCTION StrSup(VAR Str1, Str2: Str255): Longint;
FUNCTION NumEqInf(Num1, Num2: Longint): Longint;
FUNCTION StrEqInf(VAR Str1, Str2: Str255): Longint;
FUNCTION NumEqSup(Num1, Num2: Longint): Longint;
FUNCTION StrEqSup(VAR Str1, Str2: Str255): Longint;
FUNCTION SAbs(Num1: Longint): Longint;
FUNCTION SAsc(VAR Str1: Str255): Longint;
FUNCTION SLen(VAR Str1: Str255): Longint;
FUNCTION STickCount: longint;
PROCEDURE StrPlus(VAR Str1,Str2,Str3:Str255);
PROCEDURE SChr(VAR Str1: str255; Num1: Longint);
PROCEDURE Date(VAR AdStr: Str255; Num1: Longint);
PROCEDURE DSpcR(VAR Str1,Str2: Str255);
PROCEDURE DSpcL(VAR Str1,Str2: Str255);
PROCEDURE Format(VAR Str1: Str255; Num1, Num2, Num3: Longint; VAR Str4: Str255);
PROCEDURE SLeft(VAR Str1,Str2: Str255; Num2: Longint);
PROCEDURE SRight(VAR Str1,Str2: Str255; Num2: Longint);
PROCEDURE SSpc(VAR Str1: Str255; Num1: Longint);
PROCEDURE Lwc(VAR Str1,Str2: Str255);
PROCEDURE Upc(VAR Str1,Str2: Str255);
PROCEDURE Mid(VAR Str1,Str2: Str255; Num2, Num3: Longint);
PROCEDURE Str(VAR Str1: Str255; Num1: Longint);
PROCEDURE SString(VAR Str1: Str255; Num1: Longint; VAR StrB: Str255);
PROCEDURE STime(VAR AdStr: Str255);
FUNCTION SInstr(VAR Str1,Str2: Str255): Longint;
FUNCTION SMod(Num1,Num2: Longint): Longint;
FUNCTION SSecs: longint;
FUNCTION SDate2Secs(VAR Str1: Str255): longint;
PROCEDURE SSecs2Date(VAR AdStr: Str255; Num1: longint);

PROCEDURE ResetZones;
FUNCTION SError: Longint;
FUNCTION SSVal(VAR Str1: str255): Longint;
FUNCTION SVal(Str1: str255):Longint;
FUNCTION ZoneNumber: Longint;
FUNCTION Key: Longint;
FUNCTION Logtime: Longint;
PROCEDURE TimeOut(Num1: Longint);
PROCEDURE Filter(Num1: longint);

PROCEDURE BaseOpen(NumBase: Longint; VAR NomBase: Str255);
PROCEDURE BaseClose(NumBase: Longint);
PROCEDURE BaseSeek(NumBase, NumIndex: Longint; PtIndex: Ptr; TpIndex: Integer);
PROCEDURE BaseUpdate(NumBase: Longint);
PROCEDURE BaseAdd(NumBase: Longint);
PROCEDURE BaseRemove(NumBase: Longint);
PROCEDURE BaseNext(NumBase, NumIndex: Longint);
PROCEDURE BasePred(NumBase, NumIndex: Longint);
PROCEDURE BaseCreate(NbIndex: Longint; VAR NomBase: Str255);
PROCEDURE BaseInfo(NumBase: Longint; VAR Num1, Num2, Num3, Num4: Longint);
PROCEDURE BASEINCR(NumBase, Flag: Longint);
PROCEDURE BASEREAD(NumBase: Longint);
PROCEDURE BASESETREF(NumBase, RecRef: Longint);
FUNCTION BASEGETREF(NumBase: Longint): Longint;
FUNCTION BASEMAXSIZE:Longint;

PROCEDURE CarWrite(NumFile: Longint; C: Char);
PROCEDURE NumWrite(NumFile: Longint; Num1: Longint);
PROCEDURE StrWrite(NumFile: Longint; VAR S: Str255);
PROCEDURE StrRead(NumFile: Longint; VAR Str1: Str255);
PROCEDURE NumRead(NumFile: Longint; VAR Num2: Longint);
PROCEDURE StartRead(NumFile: Longint);
PROCEDURE StartWrite;
PROCEDURE EndWrite(NumFile: Longint);
FUNCTION SEof(NumFile: Longint): Longint;
FUNCTION SFPos(NumFile: Longint): Longint;
FUNCTION FAsGetEOF(NumFile: Longint): Longint;
PROCEDURE FAsSetEOF(NumFile: Longint; Num1: Longint);
PROCEDURE RLen(NumFile, Num1: Longint);
PROCEDURE RSeek(NumFile, Num1: Longint);
PROCEDURE SSeek(NumFile, Num1: Longint);
PROCEDURE SLock(NumFile: Longint);
PROCEDURE SUnlock(NumFile: Longint);
PROCEDURE BRead(NumFile: Longint; VAR Num2: Longint; Num3: Longint);
PROCEDURE BWrite(NumFile, Num2, Num3: Longint);
PROCEDURE DirFile(VAR TheFile: Str255; TheDir: Str255; TheIndex: Longint);
PROCEDURE SOpenRF(Num1: Longint; VAR Str1: Str255);
PROCEDURE SNewFolder(Str1: Str255);
PROCEDURE SGetFInfo(Str1: Str255; VAR Str2: Str255; VAR Num1, Num2, Num3, Num4: Longint);
PROCEDURE SSetFInfo(Str1: Str255; VAR Str2: Str255);
PROCEDURE SGetVol(VAR AdStr: Str255; Num1: Longint);
PROCEDURE SClose(Num1: Longint);
PROCEDURE SCreate(VAR Str1: Str255);
PROCEDURE FASDelete(VAR Str1: Str255);
PROCEDURE SOpenDrg(Num1: Longint; VAR Str1: Str255);
PROCEDURE SAppend(Num1: Longint; VAR Str1: Str255);
PROCEDURE FASRename(VAR Str1, Str2: Str255);

FUNCTION MyTest(Num1:LONGINT):LONGINT;

FUNCTION GetTCB:Ptr;		{ utile pour les routines externes }
PROCEDURE HandleSelector;

PROCEDURE UnitInit;


IMPLEMENTATION

     {$I DragsterTCB.p}

CONST
	ErrSyntax	 =  1;	  { Erreur de syntaxe		 }
	ErrVParam	 =  2;	  { Mauvaise valeur de parametre }
	ErrLabel	 =  3;	  { Etiquette utilisée et non définie }
	ErrDef	 =  4;	  { Redéfinition d'une étiquette ou d'une var }
	ErrType	 =  5;	  { Mauvais type de parametre }
	ErrMissing	 =  6;	  { Mauvais nombre de parametres }
	ErrFor	 =  7;	  { For sans Next }
	ErrNext	 =  8;	  { Next sans For }
	ErrWhile	 =  9;	  { While sans Wend }
	ErrWend	 = 10;	  { Wend sans While }
	ErrZero	 = 11;	  { Division par zero }
	ErrReturn	 = 12;	  { Return sans Gosub }
	ErrLigne	 = 13;	  { pb de tokenisation }
	ErrCall	 = 14;	  { mauvais appel de la fonction }
	ErrConf	 = 15;	  { conflit de types }
	ErrImbWF	 = 16;	  { trop d'imbrications de while/for }
	ErrImbIf	 = 17;	  { trop d'imbrications de If }
	ErrElse	 = 18;	  { Else sans If }
	ErrEndif	 = 19;	  { Endif sans If }
	ErrBreak	 = 20;	  { Break sans for/while }
	ErrCont	 = 21;	  { Continue sans for/while }
	ErrNonXFile	 = 22;	  { Tentative d'exec d'un fichier non exec }
	ErrDDef	 = 23;	  { Double définition d'une étiquette }
	ErrBadNum	 = 24;	  { Mauvais numero de fichier }
	ErrNotOpen	 = 25;	  { Fichier non ouvert }
	ErrFileOpen	 = 26;	  { Fichier déja ouvert }
	ErrQEmpty	= 29;	{ Queue vide }
	ErrQFull		= 30;   { queue pleine }
	ErrQTx		= 31;   { tache inexistante }

	ErrTime	 =    128; { timeOut }
	CRepetition =  129;
	CEnvoi	 =    130;
	CGuide	 =    131;
	CSommaire =    132;
	CSuite	 =    133;
	CRetour	 =    134;
	CAnnulation =  135;
	CCorrection =  136;
	CAutre=	      137;
	CIgnore=		  255;
	
	SOH	      = chr(1);
	STX		  = chr(2);
	ETX		  = chr(3);
	EOT	      = chr(4);
	ENQ	      = chr(5);
	BS	      = chr(8);
	LF		  = chr(10);
	FF	      = chr(12);
	RC    	  = chr(13);
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
	START	      = chr($69);
	STOP	      = chr($6A);
	IDEN1	      = chr($78);
	IDEN2	      = chr($79);
	ENQRAM	      = chr($7A);
	ENQROM	      = chr($7B);


PROCEDURE MyConst; EXTERNAL;

FUNCTION GetStPtr: TPtr;
{ GetStPtr rend TheStPtr, qui pointe sur la chaine des TCB occupes }
EXTERNAL;

FUNCTION GetCurSt: TPtr;
{ GetCurSt rend CurStPtr, qui pointe sur le TCB actif }
EXTERNAL;

PROCEDURE SetCurSt(ThePtr: TPtr);
{ SetCurSt met a jour CurStPtr, qui pointe sur le TCB actif }
EXTERNAL;

PROCEDURE SaveRegs(AdRegs: Ptr);
{ InitRegs va mettre les valeurs des registres à l'adresse AdRegs }
EXTERNAL;

PROCEDURE SwapTasks(AdRegs1,AdRegs2:Ptr);
{ Sauvegarde contexte courant dans AdRegs1 et restaure AdRegs2 }
EXTERNAL;

PROCEDURE AsmCompletion;
{ IOCompletion qui réactive la tache après un call asynchrone }
EXTERNAL;

PROCEDURE FAsClose(NumFile: Longint);
FORWARD;

PROCEDURE YieldCpu;

BEGIN
	WITH GetCurSt^ DO
	{ on rend la main au scheduler }
		SwapTasks(@RegArea, @RegAreaF);
END;


PROCEDURE TEnQueue(QNum: Integer; VAR pb: TQERec);

VAR
	ThePtr: TPtr;

BEGIN
	ThePtr := GetCurSt;
	WITH ThePtr^, ThePtr^.TheQueues^[QNum] DO
		IF (QNum<>0) & (QOwner=NIL) THEN	{ il y a bien une tâche derrière cette queue ?? }
			DebugStr('Envoi req. a tache absente !')
		ELSE
		BEGIN
			pb.EOwner := ThePtr;
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
			YieldCpu;
		END;
END;

PROCEDURE WaitDelay(Num1: Longint);

BEGIN
	IF Num1 > 0 THEN {•••• pas de DELAY < 1 ••••}
		WITH GetCurSt^ DO
		BEGIN
			DelayValue := Num1;
			StatusWord := DelayCst;
		END;
	YieldCpu;
END;


PROCEDURE SetRunMode(NewMode:INTEGER);

BEGIN
	WITH GetCurSt^ DO
	BEGIN
		RunMode := NewMode;
		IF CurRunMode>NewMode THEN SwapTasks(@RegArea,@RegAreaF);
	END;
END;



FUNCTION NumPlus(Num1, Num2: Longint): Longint;
BEGIN
     NumPlus:= Num1 + Num2;
END;

FUNCTION Moins(Num1, Num2: Longint): Longint;
BEGIN
     Moins:= Num1 - Num2;
END;

FUNCTION SNeg(Num1: Longint): Longint;

BEGIN
     SNeg:= -Num1;
END;


FUNCTION SDiv(Num1,Num2: Longint): Longint;
BEGIN
	IF Num2<>0 THEN
		SDiv:= Num1 DIV Num2
	ELSE
	BEGIN { Division par Zero }
		GetCurSt^.Error:=ErrZero;
		SDiv:=Num1;
	END;
END;


FUNCTION SMod(Num1,Num2: Longint): Longint;
BEGIN
	IF Num2<>0 THEN
		SMod:= Num1 MOD Num2
	ELSE
	BEGIN { Division par Zero }
		GetCurSt^.Error:=ErrZero;
		SMod:=Num1;
	END;
END;


FUNCTION Mul(Num1,Num2: Longint): Longint;

BEGIN
	Mul:= Num1 * Num2;
END;


FUNCTION NumOr(Num1,Num2: Longint): Longint;

BEGIN
	NumOr := LONGINT((Num1<>0) | (Num2<>0));
END;


FUNCTION NumAnd(Num1,Num2: Longint): Longint;

BEGIN
	NumAnd := LONGINT((Num1<>0) & (Num2<>0));
END;


FUNCTION SNot(Num1: Longint): Longint;

BEGIN
	SNot := LONGINT(NOT(Num1<>0));
END;


FUNCTION NumEq(Num1, Num2: Longint): Longint;

BEGIN
	NumEq := LONGINT(Num1=Num2);
END;


FUNCTION StrEq(VAR Str1, Str2: Str255): Longint;

BEGIN
	StrEq := LONGINT(Str1=Str2);
END;


FUNCTION NumDiff(Num1, Num2: Longint): Longint;

BEGIN
	NumDiff := LONGINT(Num1<>Num2);
END;


FUNCTION StrDiff(VAR Str1, Str2: Str255): Longint;

BEGIN
	StrDiff:=LONGINT(Str1<>Str2);
END;


FUNCTION NumInf(Num1, Num2: Longint): Longint;

BEGIN
	NumInf := LONGINT(Num1<Num2);
END;


FUNCTION StrInf(VAR Str1, Str2: Str255): Longint;

BEGIN
	StrInf:=LONGINT(Str1<Str2);
END;


FUNCTION NumSup(Num1, Num2: Longint): Longint;

BEGIN
	NumSup := LONGINT(Num1>Num2);
END;


FUNCTION StrSup(VAR Str1, Str2: Str255): Longint;

BEGIN
	StrSup:=LONGINT(Str1>Str2);
END;


FUNCTION NumEqInf(Num1, Num2: Longint): Longint;

BEGIN
	NumEqInf := LONGINT(Num1<=Num2);
END;


FUNCTION StrEqInf(VAR Str1, Str2: Str255): Longint;

BEGIN
	StrEqInf := LONGINT(Str1<=Str2);
END;


FUNCTION NumEqSup(Num1, Num2: Longint): Longint;

BEGIN
	NumEqSup := LONGINT(Num1>=Num2);
END;


FUNCTION StrEqSup(VAR Str1, Str2: Str255): Longint;

BEGIN
	StrEqSup := LONGINT(Str1>=Str2);
END;


FUNCTION SAbs(Num1: Longint): Longint;

BEGIN
	IF Num1<0 THEN SAbs:= -Num1 ELSE Sabs:= Num1;
END;


FUNCTION SAsc(VAR Str1: Str255): Longint;

BEGIN
	IF length(Str1)=0 THEN
		SAsc:= 0
	ELSE
		SAsc:=ord(Str1[1]);
END;


FUNCTION SLen(VAR Str1: Str255): Longint;

BEGIN
	SLen:=Length(Str1);
END;


FUNCTION STickCount: longint;

BEGIN
	STickCount:= TickCount;
END;


FUNCTION SInstr(VAR Str1,Str2: Str255): Longint;

BEGIN
	SInstr:= Pos(str2,Str1);
END;


PROCEDURE StrPlus(VAR Str1,Str2,Str3:Str255);

BEGIN
	Str1 := concat(Str2,Str3);	{ environ deux fois plus rapide ! }
END;


PROCEDURE SChr(VAR Str1: str255; Num1: Longint);

BEGIN
	Str1:=chr(Num1);
END;


FUNCTION SSecs: longint;

VAR Num1: longint;

BEGIN
	GetDateTime(Num1);
	SSecs:=Num1;
END;


FUNCTION An2000(year: LONGINT):LONGINT;	{ CQ-10/2/99 }

BEGIN
			IF (GetCurSt^.RndMemo = 0) OR (GetCurSt^.RndMemo < year) THEN
				An2000 := year + 1900
			ELSE
				An2000 := year + 2000;
END;


FUNCTION SDate2Secs(VAR Str1: Str255): longint;

VAR Num1: longint; DTRec: DateTimeRec;
	
	FUNCTION Conv(Idx: integer): integer;
	
	BEGIN
		Conv:=(ord(Str1[Idx])-ord('0'))*10+(ord(Str1[Idx+1])-ord('0'));
	END;
	
BEGIN
	CASE Length(Str1) OF
		6:	{ AAMMJJ }
		WITH DTRec DO
		BEGIN
			day := Conv(5);
			month := Conv(3);
			year := An2000(Conv(1));	{ CQ-10/2/99 }
			hour := 0;
			minute := 0;
			second := 0;
		END;

		8:	{ JJ/MM/AA ou AAAAMMJJ }
		IF (Str1[1] = '/') THEN
		WITH DTRec DO
		BEGIN
			day := Conv(1);
			month := Conv(4);
			year := An2000(Conv(7));	{ CQ-10/2/99 }
			hour := 0;
			minute := 0;
			second := 0;
		END
		ELSE
		WITH DTRec DO
		BEGIN
			day := Conv(7);
			month := Conv(5);
			IF (Str1[1]='1') THEN
				year := Conv(3) + 1900
			ELSE
				year := Conv(3) + 2000;
			hour := 0;
			minute := 0;
			second := 0;
		END;
		
		10:	{ JJ/MM/AAAA }
		WITH DTRec DO
		BEGIN
			day := Conv(1);
			month := Conv(4);
			IF (Str1[7]='1') THEN
				year := Conv(9) + 1900
			ELSE
				year := Conv(9) + 2000;
			hour := 0;
			minute := 0;
			second := 0;
		END;
		
		16:	{ JJ/MM/AAhh:mm:ss }
		WITH DTRec DO
		BEGIN
			day := Conv(1);
			month := Conv(4);
			year := An2000(Conv(7));	{ CQ-10/2/99 }
			hour := Conv(9);
			minute := Conv(12);
			second := Conv(15);
		END;

		18:	{ JJ/MM/AAAAhh:mm:ss }
		WITH DTRec DO
		BEGIN
			day := Conv(1);
			month := Conv(4);
			IF (Str1[7]='1') THEN
				year := Conv(9) + 1900
			ELSE
				year := Conv(9) + 2000;
			hour := Conv(11);
			minute := Conv(14);
			second := Conv(17);
		END;

	END;	{ CASE }
	Date2Secs(DTRec,Num1);
	SDate2Secs:=Num1;
END;


PROCEDURE SSecs2Date(VAR AdStr: Str255; Num1: longint);

VAR DTRec: DateTimeRec;
	
	PROCEDURE Conv(Num: integer; Idx: integer);
	
	BEGIN
		AdStr[Idx]  :=chr((Num DIV 10)+ord('0'));
		AdStr[Idx+1]:=chr((Num MOD 10)+ord('0'));
	END;
	
BEGIN
	 AdStr:='XX/XX/XX99:99:99';
	 Secs2Date(Num1,DTRec);
	 WITH DTRec DO
	 BEGIN
	 	Conv(day,1);
	 	Conv(month,4);
	 	Conv(year-1900,7);
	 	Conv(hour,9);
	 	Conv(minute,12);
	 	Conv(second,15);
	 END;
END;


PROCEDURE Date(VAR AdStr: Str255; Num1: longint);

VAR DTRec: DateTimeRec;
		DateTime: LONGINT;
		
	PROCEDURE Conv(Num: integer; Idx: integer);
	BEGIN
		AdStr[Idx]  :=chr((Num DIV 10)+ord('0'));
		AdStr[Idx+1]:=chr((Num MOD 10)+ord('0'));
	END;
	
BEGIN
	GetTime(DTRec);

	CASE Num1 OF	{ format demandé… }
		0:
		WITH DTRec DO
		BEGIN
			AdStr:='JJ/MM/AA';
			Conv(day, 1);
			Conv(month, 4);
			Conv(year - 1900, 7);
		END;
		
		-1:
		WITH DTRec DO
		BEGIN
			AdStr[0]:=chr(6); {'AAMMJJ'}
			Conv(day,5);
			Conv(month,3);
			Conv(year-1900,1);
		END;

		-2:	{ 18/3/98 - date an 2000 }
		WITH DTRec DO
		BEGIN
			IF (year >= 2000) THEN
			BEGIN
				AdStr:='JJ/MM/20AA';
				Conv(year-2000, 9);
			END
			ELSE
			BEGIN
				AdStr:='JJ/MM/19AA';
				Conv(year-1900, 9);
			END;
			Conv(day,1);
			Conv(month,4);
		END;

		-3:	{ 18/3/98 - date an 2000 }
		WITH DTRec DO
		BEGIN
			IF (year >= 2000) THEN
			BEGIN
				AdStr:='20AAMMJJ';
				Conv(year-2000, 3);
			END
			ELSE
			BEGIN
				AdStr:='19AAMMJJ';
				Conv(year-1900, 3);
			END;
			Conv(day,7);
			Conv(month,5);
		END;

	END;
END;


PROCEDURE STime(VAR AdStr: Str255);

VAR DTRec: DateTimeRec;
	
	PROCEDURE Conv(Num: integer; Idx: integer);
	
	BEGIN
		AdStr[Idx]  :=chr((Num DIV 10)+ord('0'));
		AdStr[Idx+1]:=chr((Num MOD 10)+ord('0'));
	END;
	
BEGIN
	 AdStr:='hh:mm:ss';
	 GetTime(DTRec);
	 WITH DTRec DO
	 BEGIN
	 	Conv(hour,1);
	 	Conv(minute,4);
	 	Conv(second,7);
	 END;
END;


PROCEDURE DSpcR(VAR Str1,Str2: Str255);

BEGIN
	Str1:=Str2;
	WHILE (Length(Str1)>0) AND (Str1[Length(Str1)]=' ') DO
		Str1[0] := Chr(Ord(Str1[0]) - 1);
END;


PROCEDURE DSpcL(VAR Str1,Str2: Str255);

BEGIN
	Str1:=Str2;
	WHILE (Length(Str1)>0) AND (Str1[1]=' ') DO
		Delete(Str1,1,1);
END;


PROCEDURE Format(VAR Str1: Str255; Num1, Num2, Num3: Longint; VAR Str4: Str255);

BEGIN
	Str1:=Str4;

	IF Num2>0 THEN	{ virgule à insérer ? }
	BEGIN
		WHILE (Length(Str1)<(Num2+1)) AND (Length(Str1)<MaxStrLen) DO
			Str1:=Concat('0',Str1);
		Insert(',',Str1,Length(Str1)-Num2+1);
	END;

	IF Length(Str1)<Num1 THEN
	BEGIN
		IF Num3<0 THEN { cadrage a gauche }
		BEGIN
			WHILE (Length(Str1)<Num1) AND (Length(Str1)<MaxStrLen) DO
				Str1:= Concat(Str1,' ');
		END
		ELSE
		IF Num3=0 THEN { centrage }
		BEGIN
			WHILE (Length(Str1)<Num1) AND (Length(Str1)<MaxStrLen) DO
			BEGIN
				Str1:= Concat(' ', Str1);
				IF (Length(Str1)<Num1) AND (Length(Str1)<MaxStrLen) THEN
					Str1:= Concat(Str1,' ');
			END;
		END
		ELSE	       { cadrage a droite }
		BEGIN
			WHILE (Length(Str1)<Num1) AND (Length(Str1)<MaxStrLen) DO
				Str1:= Concat(' ',Str1);
		END;
 END
 ELSE
	 Str1[0] := chr(Num1);	{ on coupe la chaîne trop longue }
END;


PROCEDURE SLeft(VAR Str1,Str2: Str255; Num2: Longint);

BEGIN
	Str1:=Str2;
	IF Num2<0 THEN Num2 := 0;
	IF Num2>Length(Str1) THEN Num2:=Length(Str1);
	Str1[0] := Chr(Num2);
END;


PROCEDURE SRight(VAR Str1,Str2: Str255; Num2: Longint);

BEGIN
	Str1:=Str2;
	IF Num2<0 THEN Num2:= 0;
	IF Num2>Length(Str1) THEN Num2:=Length(Str1);
	Str1:=Copy(Str1,Length(Str1)-Num2+1,Num2);
END;


PROCEDURE SSpc(VAR Str1: Str255; Num1: Longint);	{ 45 fois plus rapide ! }

VAR	i: INTEGER;

BEGIN
     IF Num1<0 THEN Num1:= 0;
     IF Num1>255 THEN Num1 := 255;
		 Str1[0]:=chr(num1);
     FOR i := 1 TO Num1 DO Str1[i] := ' ';
END;

(*
PROCEDURE SSpc(VAR Str1: Str255; Num1: Longint);

BEGIN
     IF Num1<0 THEN Num1:= 0;
     Str1:='';
     WHILE (Length(Str1)<Num1) AND (Length(Str1)<MaxStrLen) DO
          Str1:= Concat(Str1,' ');
END;
*)

PROCEDURE Lwc(VAR Str1,Str2: Str255);

VAR i: integer;

BEGIN
	Str1:=Str2;
	FOR i:=1 TO length(Str1) DO
		IF (Str1[i] IN ['A'..'Z']) THEN Str1[i]:=chr(ord(Str1[i])+32);
END;


PROCEDURE Upc(VAR Str1,Str2: Str255);

VAR i: integer;

BEGIN
	Str1:=Str2;
	UpperString(Str1,FALSE);
END;


PROCEDURE Mid(VAR Str1,Str2: Str255; Num2, Num3: Longint);

BEGIN
	Str1:=Str2;
	IF Num2<=0 THEN Num2:=1;
	IF Num2+Num3>Length(Str1) THEN Num3:=Length(Str1)-Num2+1;
	IF (Num3<=0) | (Num2>Length(Str1)) THEN
		Str1:=''
	ELSE
		Str1:=Copy(Str1,Num2,Num3);
END;


PROCEDURE Str(VAR Str1: Str255; Num1: Longint);

BEGIN
	NumToString(Num1,Str1);
END;


PROCEDURE SString(VAR Str1: Str255; Num1: Longint; VAR StrB: Str255);

VAR c: CHAR;
		i: INTEGER;
		
BEGIN
	IF Length(StrB)=0 THEN c:=' ' ELSE c := Strb[1];
	IF Num1>255 THEN Num1:=255;
	IF Num1<0 THEN Num1:=0;
	Str1[0]:=chr(num1);
	FOR i := 1 TO Num1 DO Str1[i] := c;
END;


PROCEDURE ResetZones;

BEGIN
	GetCurSt^.NbZones:=0;
END;


FUNCTION SError: Longint;

BEGIN
	SError:=GetCurSt^.Error;
END;


FUNCTION Key: Longint;

BEGIN
	Key:=GetCurSt^.Error-127;
END;


FUNCTION ZoneNumber: Longint;

BEGIN
	ZoneNumber:=GetCurSt^.ZoneNumber;
END;


FUNCTION Logtime: Longint;

VAR TheTime: longint;

BEGIN
	GetDateTime(TheTime);
	LogTime:= abs(TheTime-GetCurSt^.StartTime);
END;


FUNCTION SSVal(VAR Str1: str255):Longint;
{ ATTENTION: la chaine Str1 est detruite }
VAR Num1: Longint;  k: integer; termine: boolean;

BEGIN
	{ on skippe tous les blancs devant }
	k:=0;
	termine:=false;
	WHILE (k<length(Str1)) AND (NOT termine) DO
	BEGIN
		k:=k+1;
		termine:=Str1[k]<>' ';
	END;
	
	{ on skippe le signe s'il est là }
	IF termine THEN
	BEGIN
		IF (Str1[k] IN ['+'..'-']) THEN
		BEGIN
			{ on remplace le signe par un blanc et on met le signe au 1er car }
			IF k>1 THEN
			BEGIN
				Str1[1]:=Str1[k];
				Str1[k]:=' ';
			END;
			{ on doit encore skipper les blancs }
			termine:=false;
			WHILE (k<length(Str1)) AND (NOT termine) DO
			BEGIN
				k:=k+1;
				termine:=Str1[k]<>' ';
			END;
		END
	END;
	
	{ on skippe les digits }
	IF termine THEN termine:=NOT(Str1[k] IN ['0'..'9']);
	WHILE (k<length(Str1)) AND (NOT termine) DO
	BEGIN
		k:=k+1;
		termine:=NOT(Str1[k] IN ['0'..'9']);
	END;
	IF termine THEN Str1[0]:=chr(k-1);
	
	StringToNum(Str1,Num1);
	SSVal:=Num1;
END;


FUNCTION SVal(Str1: str255):Longint;

BEGIN
	SVal:=SSVal(Str1);
END;


PROCEDURE TimeOut(Num1: Longint);

BEGIN
	GetCurSt^.MaxTime:=Num1*60;
END;


PROCEDURE Filter(Num1: longint);

BEGIN
	GetCurSt^.FilterFlag:=Num1<>0;
END;


PROCEDURE SetBaseEnd(TheEnd: Longint);

BEGIN
	WITH GetCurSt^ DO
		BEGIN
			DBCount := TheEnd;
			IF DBidx > DBCount THEN DBidx := DBCount;
		END;
END;


{ Taille zone base de donnée }
FUNCTION BASEMAXSIZE:Longint;

BEGIN
	BaseMaxSize := GetCurSt^.DBSz;
END;


PROCEDURE BaseOpen(NumBase: Longint; VAR NomBase: Str255);

VAR
	BRec: B_Rec;
	Qpb: TQERec;

BEGIN
	WITH GetCurSt^ DO
		BEGIN
			IF (NumBase < 1) OR (NumBase > MaxFile) THEN
				BEGIN
					Error := ErrBadNum;
					EXIT(BaseOpen);
				END;

			WITH TheFiles[NumBase] DO
				IF FileRef <> 0 THEN
					BEGIN
						Error := ErrFileOpen;
						EXIT(BaseOpen);
					END;

			WITH BRec DO
				BEGIN
					Nom := @NomBase;
					FichCom := @DBPtr;
				END;

			IOCompFlag := 1;
			StatusWord := BaseWaitCst;

			WITH Qpb DO
				BEGIN
					ECode := ReqB_Open;
					EParam1 := @BRec;
				END;
			TEnQueue(BaseQ, Qpb);

			Error := Qpb.ERet;
			IF Error >= GNoErr THEN
				WITH TheFiles[NumBase] DO
					BEGIN
						FileRef := Qpb.EMisc;
						FilePos := DBRef;
						BaseFlag := True;
					END;
		END;
END;

PROCEDURE BaseClose(NumBase: Longint);

VAR
	Qpb: TQERec;

BEGIN
	WITH GetCurSt^ DO
		BEGIN
			IF (NumBase < 1) OR (NumBase > MaxFile) THEN
				BEGIN
					Error := ErrBadNum;
					EXIT(BaseClose);
				END;

			
			WITH TheFiles[NumBase] DO
			BEGIN
				IF BaseFlag=FALSE THEN	{ c'est un fichier et pas une base ! }
				BEGIN
					FASClose(NumBase);
					EXIT(BaseClose);
				END;
				IF FileRef = 0 THEN		{ il n'y avait pas de base ouverte ! }
				BEGIN
					Error := ErrBadNum;
					EXIT(BaseClose);
				END;
			END;
			
			IOCompFlag := 1;
			StatusWord := BaseWaitCst;

			WITH Qpb DO
				BEGIN
					ECode := ReqB_Close;
					EMisc := TheFiles[NumBase].FileRef;
				END;
			TEnQueue(BaseQ, Qpb);

			WITH TheFiles[NumBase] DO
			BEGIN
				FileRef := 0;
				BaseFlag := False;
			END;
		END;
END;


PROCEDURE BaseSeek(NumBase, NumIndex: Longint;
									 PtIndex: Ptr;
									 TpIndex: Integer);

VAR
	BRec: B_Rec;
	Qpb: TQERec;

BEGIN
	WITH GetCurSt^ DO
		BEGIN
			IF (NumBase < 1) OR (NumBase > MaxFile) THEN
				BEGIN
					Error := ErrBadNum;
					EXIT(BaseSeek);
				END;

			WITH TheFiles[NumBase] DO
				IF (FileRef = 0) OR (NOT BaseFlag) THEN
					BEGIN
						Error := ErrBadNum;
						EXIT(BaseSeek);
					END;

			WITH BRec DO
				BEGIN
					Nom := stringptr(PtIndex);
					Index := NumIndex;
					FichCom := @DBPtr;
				END;

			IOCompFlag := 1;
			StatusWord := BaseWaitCst;

			WITH Qpb DO
				BEGIN
					ECode := ReqB_Seek;
					EParam1 := @BRec;
					EMisc := TheFiles[NumBase].FileRef;
				END;
			TEnQueue(BaseQ, Qpb);

			Error := Qpb.ERet;
			WITH TheFiles[NumBase] DO
				BEGIN
					FilePos := DBRef;
				END;
			DBidx := 0;

		END;
END;

PROCEDURE BaseUpdate(NumBase: Longint);

VAR
	BRec: B_Rec;
	Qpb: TQERec;

BEGIN
	WITH GetCurSt^ DO
		BEGIN
			IF (NumBase < 1) OR (NumBase > MaxFile) THEN
				BEGIN
					Error := ErrBadNum;
					EXIT(BaseUpdate);
				END;

			WITH TheFiles[NumBase] DO
				IF (FileRef = 0) OR (NOT BaseFlag) THEN
					BEGIN
						Error := ErrBadNum;
						EXIT(BaseUpdate);
					END;

			WITH BRec DO
				BEGIN
					FichCom := @DBPtr;
				END;

			DBRef := TheFiles[NumBase].FilePos;

			IOCompFlag := 1;
			StatusWord := BaseWaitCst;

			WITH Qpb DO
				BEGIN
					ECode := ReqB_Update;
					EParam1 := @BRec;
					EMisc := TheFiles[NumBase].FileRef;
				END;
			TEnQueue(BaseQ, Qpb);

			Error := Qpb.ERet;
			WITH TheFiles[NumBase] DO
				BEGIN
					FilePos := DBRef;
				END;
		END;
END;

PROCEDURE BaseAdd(NumBase: Longint);

VAR
	BRec: B_Rec;
	Qpb: TQERec;

BEGIN
	WITH GetCurSt^ DO
		BEGIN
			IF (NumBase < 1) OR (NumBase > MaxFile) THEN
				BEGIN
					Error := ErrBadNum;
					EXIT(BaseAdd);
				END;

			WITH TheFiles[NumBase] DO
				IF (FileRef = 0) OR (NOT BaseFlag) THEN
					BEGIN
						Error := ErrBadNum;
						EXIT(BaseAdd);
					END;

			WITH BRec DO
				BEGIN
					FichCom := @DBPtr;
				END;

			IOCompFlag := 1;
			StatusWord := BaseWaitCst;

			WITH Qpb DO
				BEGIN
					ECode := ReqB_Add;
					EParam1 := @BRec;
					EMisc := TheFiles[NumBase].FileRef;
				END;
			TEnQueue(BaseQ, Qpb);

			Error := Qpb.ERet;
			WITH TheFiles[NumBase] DO
				BEGIN
					FilePos := DBRef;
				END;
		END;
END;

PROCEDURE BaseRemove(NumBase: Longint);

VAR
	BRec: B_Rec;
	Qpb: TQERec;

BEGIN
	WITH GetCurSt^ DO
		BEGIN
			IF (NumBase < 1) OR (NumBase > MaxFile) THEN
				BEGIN
					Error := ErrBadNum;
					EXIT(BaseRemove);
				END;

			WITH TheFiles[NumBase] DO
				IF (FileRef = 0) OR (NOT BaseFlag) THEN
					BEGIN
						Error := ErrBadNum;
						EXIT(BaseRemove);
					END;

			WITH BRec DO
				BEGIN
					FichCom := @DBPtr;
				END;

			WITH TheFiles[NumBase] DO
				BEGIN
					DBRef := FilePos;
				END;

			IOCompFlag := 1;
			StatusWord := BaseWaitCst;

			WITH Qpb DO
				BEGIN
					ECode := ReqB_Remove;
					EParam1 := @BRec;
					EMisc := TheFiles[NumBase].FileRef;
				END;
			TEnQueue(BaseQ, Qpb);

			Error := Qpb.ERet;
			WITH TheFiles[NumBase] DO
				BEGIN
					FilePos := DBRef;
				END;
		END;
END;

PROCEDURE BaseNext(NumBase, NumIndex: Longint);

VAR
	BRec: B_Rec;
	Qpb: TQERec;

BEGIN
	WITH GetCurSt^ DO
		BEGIN
			IF (NumBase < 1) OR (NumBase > MaxFile) THEN
				BEGIN
					Error := ErrBadNum;
					EXIT(BaseNext);
				END;

			WITH TheFiles[NumBase] DO
				IF (FileRef = 0) OR (NOT BaseFlag) THEN
					BEGIN
						Error := ErrBadNum;
						EXIT(BaseNext);
					END;

			WITH BRec DO
				BEGIN
					Index := NumIndex;
					FichCom := @DBPtr;
				END;

			WITH TheFiles[NumBase] DO
				BEGIN
					DBRef := FilePos;
				END;

			IOCompFlag := 1;
			StatusWord := BaseWaitCst;

			WITH Qpb DO
				BEGIN
					ECode := ReqB_Next;
					EParam1 := @BRec;
					EMisc := TheFiles[NumBase].FileRef;
				END;
			TEnQueue(BaseQ, Qpb);

			Error := Qpb.ERet;
			WITH TheFiles[NumBase] DO
				BEGIN
					FilePos := DBRef;
				END;
		END;
END;

PROCEDURE BasePred(NumBase, NumIndex: Longint);

VAR
	BRec: B_Rec;
	Qpb: TQERec;

BEGIN
	WITH GetCurSt^ DO
		BEGIN
			IF (NumBase < 1) OR (NumBase > MaxFile) THEN
				BEGIN
					Error := ErrBadNum;
					EXIT(BasePred);
				END;

			WITH TheFiles[NumBase] DO
				IF (FileRef = 0) OR (NOT BaseFlag) THEN
					BEGIN
						Error := ErrBadNum;
						EXIT(BasePred);
					END;

			WITH BRec DO
				BEGIN
					Index := NumIndex;
					FichCom := @DBPtr;
				END;

			WITH TheFiles[NumBase] DO
				BEGIN
					DBRef := FilePos;
				END;

			IOCompFlag := 1;
			StatusWord := BaseWaitCst;

			WITH Qpb DO
				BEGIN
					ECode := ReqB_Pred;
					EParam1 := @BRec;
					EMisc := TheFiles[NumBase].FileRef;
				END;
			TEnQueue(BaseQ, Qpb);

			Error := Qpb.ERet;
			WITH TheFiles[NumBase] DO
				BEGIN
					FilePos := DBRef;
				END;
		END;
END;

PROCEDURE BaseCreate(NbIndex: Longint; VAR NomBase: Str255);

VAR
	BRec: B_Rec;
	Qpb: TQERec;
	ListeCle: GListeCle;
	i: Integer;

BEGIN
	WITH GetCurSt^ DO
		BEGIN
			IF NbIndex < 1 THEN NbIndex := 1;
			IF NbIndex > MaxCle THEN NbIndex := MaxCle;
			WITH ListeCle DO
				BEGIN
					NombreCle := NbIndex;
					FOR i := 1 TO NbIndex DO
						BEGIN
							TypeCle[i] := TypeStr;
							PositionCle[i] := - 1;
							LongueurCle[i] := 0;
						END;
				END;

			WITH BRec DO
				BEGIN
					Nom := @NomBase;
					TheKeys := @ListeCle;
				END;

			IOCompFlag := 1;
			StatusWord := BaseWaitCst;

			WITH Qpb DO
				BEGIN
					ECode := ReqB_Create;
					EParam1 := @BRec;
				END;
			TEnQueue(BaseQ, Qpb);

			Error := Qpb.ERet;
		END;
END;

PROCEDURE BaseInfo(NumBase: Longint;
									 VAR Num1, Num2, Num3, Num4: Longint);

VAR
	BRec: B_Rec;
	Qpb: TQERec;
	Info: GInfo;

BEGIN
	WITH GetCurSt^ DO
		BEGIN
			IF (NumBase < 1) OR (NumBase > MaxFile) THEN
				BEGIN
					Error := ErrBadNum;
					EXIT(BaseInfo);
				END;

			WITH TheFiles[NumBase] DO
				IF (FileRef = 0) OR (NOT BaseFlag) THEN
					BEGIN
						Error := ErrBadNum;
						EXIT(BaseInfo);
					END;

			WITH BRec DO
				BEGIN
					TheInfo := @Info;
				END;

			IOCompFlag := 1;
			StatusWord := BaseWaitCst;

			WITH Qpb DO
				BEGIN
					ECode := ReqB_Info;
					EParam1 := @BRec;
					EMisc := TheFiles[NumBase].FileRef;
				END;
			TEnQueue(BaseQ, Qpb);

			Error := Qpb.ERet;
			IF Error >= GNoErr THEN
				WITH Info DO
					BEGIN
						Num1 := NombreElem;
						Num2 := NombreSupprim;
						Num3 := TailleVide;
						Num4 := NombreCle;
					END
			ELSE
				BEGIN
					Num1 := 0;
					Num2 := 0;
					Num3 := 0;
					Num4 := 0;
				END;
		END;
END;

PROCEDURE BASEINCR(NumBase, Flag: Longint);

VAR
	BRec: B_Rec;
	Qpb: TQERec;

BEGIN
	WITH GetCurSt^ DO
		BEGIN
			IF (NumBase < 1) OR (NumBase > MaxFile) THEN
				BEGIN
					Error := ErrBadNum;
					EXIT(BASEINCR);
				END;

			WITH TheFiles[NumBase] DO
				IF (FileRef = 0) OR (NOT BaseFlag) THEN
					BEGIN
						Error := ErrBadNum;
						EXIT(BASEINCR);
					END;

			WITH BRec DO
				BEGIN
					FichCom := @DBPtr;
					NetFlag := Flag <> 0;
				END;

			IOCompFlag := 1;
			StatusWord := BaseWaitCst;

			WITH Qpb DO
				BEGIN
					ECode := ReqB_IncR;
					EParam1 := @BRec;
					EMisc := TheFiles[NumBase].FileRef;
				END;
			TEnQueue(BaseQ, Qpb);

			Error := Qpb.ERet;
		END;
END;

PROCEDURE BASEREAD(NumBase: Longint);

VAR
	BRec: B_Rec;
	Qpb: TQERec;

BEGIN
	WITH GetCurSt^ DO
		BEGIN
			IF (NumBase < 1) OR (NumBase > MaxFile) THEN
				BEGIN
					Error := ErrBadNum;
					EXIT(BASEREAD);
				END;

			WITH TheFiles[NumBase] DO
				IF (FileRef = 0) OR (NOT BaseFlag) THEN
					BEGIN
						Error := ErrBadNum;
						EXIT(BASEREAD);
					END;

			WITH BRec DO
				BEGIN
					FichCom := @DBPtr;
				END;

			WITH TheFiles[NumBase] DO
				BEGIN
					DBRef := FilePos;
				END;

			IOCompFlag := 1;
			StatusWord := BaseWaitCst;

			WITH Qpb DO
				BEGIN
					ECode := ReqB_Read;
					EParam1 := @BRec;
					EMisc := TheFiles[NumBase].FileRef;
				END;
			TEnQueue(BaseQ, Qpb);

			Error := Qpb.ERet;
			WITH TheFiles[NumBase] DO
				BEGIN
					FilePos := DBRef;
				END;
		END;
END;

PROCEDURE BASESETREF(NumBase, RecRef: Longint);

BEGIN
	WITH GetCurSt^ DO
		BEGIN
			IF (NumBase < 1) OR (NumBase > MaxFile) THEN
				BEGIN
					Error := ErrBadNum;
					EXIT(BASESETREF);
				END;

			WITH TheFiles[NumBase] DO
				BEGIN
					IF (FileRef = 0) OR (NOT BaseFlag) THEN
						BEGIN
							Error := ErrBadNum;
							EXIT(BASESETREF);
						END;

					FilePos := RecRef;
					Error := NoErr;
				END;
		END;
END;

FUNCTION BASEGETREF(NumBase: Longint): Longint;

BEGIN
	WITH GetCurSt^ DO
		BEGIN
			IF (NumBase < 1) OR (NumBase > MaxFile) THEN
				BEGIN
					Error := ErrBadNum;
					EXIT(BASEGETREF);
				END;

			WITH TheFiles[NumBase] DO
				BEGIN
					IF (FileRef = 0) OR (NOT BaseFlag) THEN
						BEGIN
							Error := ErrBadNum;
							EXIT(BASEGETREF);
						END;

					BASEGETREF := FilePos;
					Error := NoErr;
				END;
		END;
END;


FUNCTION MyTest(Num1:LONGINT):LONGINT;

VAR	TCB:TPtr;

BEGIN
	CASE Num1 OF
		1:	BEGIN
					TCB := GetCurSt;	{ première tâche }	
					WHILE TCB^.TaskNumBer<>1025 DO TCB:=TCB^.nextTCB;
					MyTest := ZoneNumber;
				END;
		OTHERWISE	MyTest := -1;
	END; { CASE }
END;


FUNCTION FileTask(thePB:Ptr; theReq: INTEGER; misc: INTEGER; HParam: BOOLEAN):OsErr;

VAR	QPb: TQERec;
		Err: OsErr;
		
BEGIN
	WITH GetCurSt^ DO
	BEGIN
		ioCompFlag := 1;
		StatusWord := IOWaitCst;
	END;

	WITH Qpb DO
	BEGIN
		ECode := theReq;
		EParam1 := thePB;
		EMisc := Misc;
	END;
	TEnQueue(FileQ, Qpb);

	IF HParam THEN
		FileTask := MyHParmBlkPtr(thepb)^.thePB.ioResult
	ELSE
		FileTask := MyParmBlkPtr(thepb)^.ioResult;

END;


FUNCTION FAsRead(NumFile: Longint; VAR Count: Longint; TheBuffer: Ptr):OsErr;

VAR
	Err: OSErr;
	ThePtr: TPtr;
	pb: MyParamblockrec;

BEGIN
	ThePtr := GetCurSt;
	WITH ThePtr^ DO
		BEGIN

			WITH pb DO
				BEGIN
					tcbPtr := ThePtr;
					ioCompletion := @AsmCompletion;
					ioBuffer := TheBuffer;
					ioReqCount := Count;
					ioPosMode := fsFromStart;
					ioPosOffset := TheFiles[NumFile].FilePos;
				END;

			Error := FileTask(@pb,ReqRead,TheFiles[NumFile].FileRef,FALSE);
			TheFiles[NumFile].FilePos := pb.ioPosOffset;
			count := pb.IoActCount;
			FasRead := Error;
		END;
END;

FUNCTION FAsGetEOF(NumFile: Longint): Longint;

VAR
	Err: OSErr;
	ThePtr: TPtr;
	pb: MyParamblockrec;

BEGIN
	ThePtr := GetCurSt;
	WITH ThePtr^ DO
		BEGIN
			IF (NumFile < 1) OR (NumFile > MaxFile) THEN
				BEGIN
					Error := ErrBadNum;
					FAsGetEOF := 0;
					EXIT(FAsGetEOF);
				END;
			IF TheFiles[NumFile].FileRef = 0 THEN
				BEGIN
					Error := ErrNotOpen;
					FAsGetEOF := 0;
					EXIT(FAsGetEOF);
				END;

			IF TheFiles[NumFile].FileRef < 0 THEN
				BEGIN
					Error := 0;
					Err := SerGetBuf(TheFiles[NumFile].FileRef, NumFile);
					FAsGetEOF := NumFile;
					EXIT(FAsGetEOF);
				END;

			IF TheFiles[NumFile].BaseFlag THEN
				BEGIN
					FAsGetEOF := DBCount;
				END
			ELSE
				BEGIN
					WITH pb DO
						BEGIN
							tcbPtr := ThePtr;
							ioCompletion := @AsmCompletion;
						END;

					Error := FileTask(@pb,ReqGetEof,TheFiles[NumFile].FileRef,FALSE);
					FAsGetEOF := Ord4(pb.ioMisc);
				END;
		END;
END;

PROCEDURE FAsSetEOF(NumFile: Longint; Num1: Longint);

VAR
	Err: OSErr;
	ThePtr: TPtr;
	pb: MyParamblockrec;

BEGIN
	ThePtr := GetCurSt;
	WITH ThePtr^ DO
		BEGIN
			IF (NumFile < 1) OR (NumFile > MaxFile) THEN
				BEGIN
					Error := ErrBadNum;
					EXIT(FAsSetEOF);
				END;
			IF TheFiles[NumFile].FileRef = 0 THEN
				BEGIN
					Error := ErrNotOpen;
					EXIT(FAsSetEOF);
				END;

			IF TheFiles[NumFile].BaseFlag THEN
				BEGIN
					IF Num1 < DBsz THEN SetBaseEnd(Num1) ELSE SetBaseEnd(DBsz);
				END
			ELSE
				BEGIN

					WITH pb DO
						BEGIN
							tcbPtr := ThePtr;
							ioCompletion := @AsmCompletion;
							ioMisc := Ptr(Num1);
						END;

					Error := FileTask(@pb,ReqSetEof,TheFiles[NumFile].FileRef,FALSE);
					IF TheFiles[NumFile].FilePos > Num1 THEN	{ 2/9/96 }
						TheFiles[NumFile].FilePos := Num1;
				END;
		END;
END;

PROCEDURE SLock(NumFile: Longint);

VAR
	Err: OSErr;
	pb: MyParamblockrec;
	Qpb: TQERec;

BEGIN
	WITH GetCurSt^ DO
		BEGIN
			IF (NumFile < 1) OR (NumFile > MaxFile) THEN
				BEGIN
					Error := ErrBadNum;
					EXIT(SLock);
				END;
			IF TheFiles[NumFile].FileRef = 0 THEN
				BEGIN
					Error := ErrNotOpen;
					EXIT(SLock);
				END;

			

			IF TheFiles[NumFile].BaseFlag THEN
				BEGIN
					IOCompFlag := 1;
					StatusWord := BaseWaitCst;
					WITH Qpb DO
						BEGIN
							ECode := ReqB_Lock;
							EMisc := TheFiles[NumFile].FileRef;
						END;
					TEnQueue(BaseQ, Qpb);
				END
			ELSE
				Err := FileTask(@pb,ReqLock,TheFiles[NumFile].FileRef,FALSE);
		END;
END;

PROCEDURE SUnlock(NumFile: Longint);

VAR
	Err: OSErr;
	pb: MyParamblockrec;
	Qpb: TQERec;

BEGIN
	WITH GetCurSt^ DO
		BEGIN
			IF (NumFile < 1) OR (NumFile > MaxFile) THEN
				BEGIN
					Error := ErrBadNum;
					EXIT(SUnlock);
				END;
			IF TheFiles[NumFile].FileRef = 0 THEN
				BEGIN
					Error := ErrNotOpen;
					EXIT(SUnlock);
				END;

			IF TheFiles[NumFile].BaseFlag THEN
				BEGIN
					IOCompFlag := 1;
					StatusWord := BaseWaitCst;
					WITH Qpb DO
						BEGIN
							ECode := ReqB_Unlock;
							EMisc := TheFiles[NumFile].FileRef;
						END;
					TEnQueue(BaseQ, Qpb);
				END
			ELSE
				Err := FileTask(@pb,ReqUnlock,TheFiles[NumFile].FileRef,FALSE);
		END;
END;


FUNCTION FAsWrite(NumFile: Longint; VAR Count: Longint; TheBuffer: Ptr):OsErr;

VAR
	Err: OSErr;
	ThePtr: TPtr;
	pb: MyParamblockrec;

BEGIN
	ThePtr := GetCurSt;
	WITH ThePtr^ DO
		BEGIN
			IF (NumFile < 1) OR (NumFile > MaxFile) THEN
				BEGIN
					Error := ErrBadNum;
					EXIT(FAsWrite);
				END;
			IF TheFiles[NumFile].FileRef = 0 THEN
				BEGIN
					Error := ErrNotOpen;
					EXIT(FAsWrite);
				END;
			
			WITH pb DO
				BEGIN
					tcbPtr := ThePtr;
					ioCompletion := @AsmCompletion;
					ioBuffer := TheBuffer;
					ioReqCount := Count;
					ioPosMode := fsFromStart;
					ioPosOffset := TheFiles[NumFile].FilePos;
				END;

			IF TheFiles[NumFile].FileRef < 0 THEN
				BEGIN
					IOCompFlag := 1;
					StatusWord := IOWaitCst;
					pb.ioRefNum := TheFiles[NumFile].FileRef - 1;
					Err := PbWrite(@pb.QLink, True);
					YieldCpu;
					Error := pb.ioResult;
				END
			ELSE
				BEGIN
					Error := FileTask(@pb,ReqWrite,TheFiles[NumFile].FileRef,FALSE);
					TheFiles[NumFile].FilePos := pb.ioPosOffset;
					count := pb.ioActCount;
					FasWrite := Error;
				END;
		END;
END;


{ Cette fonction rend le vRefNum d'un pathname }
FUNCTION VRefNum(VAR Str:Str255):INTEGER;

TYPE
	TVCBPtr = ^VCB;
	PStr = ^Str255;
	
VAR
	Err: OSErr;
	ThePtr: TPtr;
	CurVCB: Integer;
	VCBPtr: TVCBPtr;
	i:INTEGER;
	Vol: Str255;
	TempStr: Str255;
	
BEGIN
	TempStr := ':';
	Vol:= Copy(Str,1,sInstr(Str,TempStr)-1);	{ on coupe au nom du volume }
	Delete(Str,1,sInstr(Str,TempStr)-1);			{ on retire le nom du volume }
	
	ThePtr := GetCurSt;
	WITH ThePtr^ DO
	BEGIN
		{ on doit se palucher la queue des volumes }
		VCBPtr := TVCBPtr(GetVcbQHdr^.qHead);
		CurVCB := 1;
		WHILE (PStr(@VCBPtr^.vcbVN)^<>Vol) & (VCBPtr <> TVCBPtr(GetVcbQHdr^.qTail)) DO
			VCBPtr := TVCBPtr(VCBPtr^.QLink);
			
		IF VCBPtr = TVCBPtr(GetVcbQHdr^.qTail) THEN
		BEGIN
			Error:=-35;
			VRefNum := 0;
		END
		ELSE
			VRefNum:=VCBPtr^.vcbVRefNum;
	END;
END;


PROCEDURE DirFile(VAR TheFile: Str255; TheDir: Str255; TheIndex: Longint);

{
	1- on récupère le volume où se trouve le dossier
	2- on lit le DirID du dossier
	3- on lit les infos sur le fichier/dossier
}

VAR
	ThePtr: TPtr;
	ThePtPb:	RECORD
					TheTPtr: TPtr;
					ThePb: CInfoPbRec;
				END;
	Err: OSErr;
	Qpb: TQERec;
	theXDir: Str255;
	oldVol: INTEGER;
	
	
BEGIN
	ThePtr := GetCurSt;

	TheXDir := TheDir;
	IF TheXDir[length(theXDir)]<>':' THEN TheXDir := concat(theXDir,':');
	
	WITH GetCurSt^ DO
	BEGIN
		thePtPb.theTPtr := GetCurSt;
		{ •• Phase 1 •• GetVInfo pour obtenir le vRefNum du volume }
		ioCompFlag := 1;
		StatusWord := ioWaitCst;
		WITH ThePtPb.ThePb DO
		BEGIN
			ioCompletion := @AsmCompletion;
			ioNamePtr := @theXDir;
			iovRefNum := 0;
			ioFDirIndex := -1;
		END;
	
		WITH Qpb DO
		BEGIN
				ECode := ReqGetVinfo;
				EParam1 := @ThePtPb;
		END;
		TEnQueue(FileQ, Qpb);
		
		IF ThePtPb.ThePb.ioResult=NoErr THEN	{ pas d'erreur ? }
		BEGIN
			{ •• Phase 2 •• GetCatInfo sur le dossier }
			TheXDir := TheDir;
			IF TheXDir[length(theXDir)]<>':' THEN TheXDir := concat(theXDir,':');
			ioCompFlag := 1;
			StatusWord := ioWaitCst;
			WITH ThePtPb.ThePb DO
			BEGIN
				ioCompletion := @AsmCompletion;
				ioNamePtr := @theXDir;
				ioFDirIndex := 0;
				ioDrDirID := 0;
			END;
			
			WITH Qpb DO
			BEGIN
					ECode := ReqGetCat;
					EParam1 := @ThePtPb;
			END;
			TEnQueue(FileQ, Qpb);
		
			IF ThePtPb.ThePb.ioResult=NoErr THEN	{ toujours pas d'erreur ? }
			BEGIN
				{ •• Phase 3 •• GetCatInfo définitif }
				ioCompFlag := 1;
				StatusWord := ioWaitCst;
				WITH ThePtPb.ThePb DO
				BEGIN
					ioCompletion := @AsmCompletion;
					ioNamePtr := @theFile;
					ioFDirIndex := theIndex;
				END;
				
				WITH Qpb DO
				BEGIN
						ECode := ReqGetCat;
						EParam1 := @ThePtPb;
				END;
				TEnQueue(FileQ, Qpb);
			END;
		END;
		
		IF ThePtPb.ThePb.ioResult <> NoErr THEN
			theFile := ''
		ELSE
			IF BTst(ThePtPb.ThePb.IOFlAttrib, 4) THEN theFile := concat(theFile,':');
		
		GetCurSt^.Error := ThePtPb.ThePb.ioResult;
	
	END;
END;	{ DirFile / GetFile }


PROCEDURE FAsOpen(VAR Str1: Str255; NumFile: Longint);


VAR
	Err: OSErr;
	ThePtr: TPtr;
	pb: MyParamblockrec;
	Qpb: TQERec;

BEGIN
	ThePtr := GetCurSt;
	WITH ThePtr^ DO
		BEGIN
			IF (NumFile < 1) OR (NumFile > MaxFile) THEN
				BEGIN
					Error := ErrBadNum;
					EXIT(FAsOpen);
				END;
			IF (TheFiles[NumFile].FileRef <> 0) THEN
				BEGIN
					Error := ErrFileOpen;
					EXIT(FAsOpen);
				END;
			IOCompFlag := 1;
			StatusWord := IOWaitCst;
			WITH pb DO
				BEGIN
					tcbPtr := ThePtr;
					ioCompletion := @AsmCompletion;
					ioNamePtr := @Str1;
					ioVRefNum := 0;
					ioVersNum := 0;
					ioPermssn := FsRdWrPerm;
					ioMisc := NIL;
				END;

			WITH Qpb DO
				BEGIN
					ECode := ReqOpen;
					EParam1 := @pb;
					EMisc := 0;
				END;
			TEnQueue(FileQ, Qpb);

			WITH TheFiles[NumFile] DO
				BEGIN
					FileRef := Qpb.EMisc;
					FilePos := 0;
					FileRLen := 1;
					BaseFlag := False;
				END;

			IF pb.IoResult = -49 THEN		{ 10/07/95 }
				FAsClose(NumFile);

			Error := pb.IoResult;
		END;
END;

PROCEDURE FAsOpenRF(VAR Str1: Str255;
										NumFile: Longint);

VAR
	Err: OSErr;
	ThePtr: TPtr;
	pb: MyParamblockrec;
	Qpb: TQERec;

BEGIN
	ThePtr := GetCurSt;
	WITH ThePtr^ DO
		BEGIN
			IF (NumFile < 1) OR (NumFile > MaxFile) THEN
				BEGIN
					Error := ErrBadNum;
					EXIT(FAsOpenRF);
				END;
			IF (TheFiles[NumFile].FileRef <> 0) THEN
				BEGIN
					Error := ErrFileOpen;
					EXIT(FAsOpenRF);
				END;
			IOCompFlag := 1;
			StatusWord := IOWaitCst;
			WITH pb DO
				BEGIN
					tcbPtr := ThePtr;
					ioCompletion := @AsmCompletion;
					ioNamePtr := @Str1;
					ioVRefNum := 0;
					ioVersNum := 0;
					ioPermssn := FsRdWrPerm;
					ioMisc := NIL;
				END;

			WITH Qpb DO
				BEGIN
					ECode := ReqOpRsrc;
					EParam1 := @pb;
					EMisc := 0;
				END;
			TEnQueue(FileQ, Qpb);

			WITH TheFiles[NumFile] DO
				BEGIN
					FileRef := Qpb.EMisc;
					FilePos := 0;
					FileRLen := 1;
					BaseFlag := False;
				END;
			Error := pb.ioResult;
		END;
END;


FUNCTION FAsFlush(TheStr: Str255): OSErr;

VAR Err	    : OSErr;
		ThePtr	: TPtr;
		pb	    : MyParamblockrec;
		Qpb	    : TQERec;
		i				: Integer;
		Termine	: Boolean;
		
BEGIN
	{ on garde tout jusqu'au ':' }
	TheStr[0]:=chr(pos(':',theStr));
	 
	WITH pb DO
	BEGIN
		TcbPtr:=ThePtr;
		ioCompletion:=@AsmCompletion;
		ioNamePtr:=@TheStr;
		ioVRefNum:=-1;
	END;

	FasFlush := FileTask(@pb,ReqFlush,0,FALSE);
END;


PROCEDURE FAsClose(NumFile: Longint);

VAR
	Err: OSErr;
	ThePtr: TPtr;
	pb: MyParamblockrec;

BEGIN
	ThePtr := GetCurSt;
	WITH ThePtr^ DO
		BEGIN
			IF (NumFile < 1) OR (NumFile > MaxFile) THEN
				BEGIN
					Error := ErrBadNum;
					EXIT(FAsClose);
				END;
			IF TheFiles[NumFile].BaseFlag THEN
			BEGIN
				BaseClose(NumFile);
				EXIT(FASClose);
			END;
			
			IF (TheFiles[NumFile].FileRef = 0) THEN
				BEGIN
					Error := ErrNotOpen;
					EXIT(FAsClose);
				END;
			IF TheFiles[NumFile].FileRef < 0 THEN
				BEGIN
					CASE SerRefIn OF
						ainRefNum:
							BEGIN
								Err := CloseDriver(bInRefNum);
								Err := CloseDriver(bOutRefNum);
							END;

						bInRefNum:
							BEGIN
								Err := CloseDriver(ainRefNum);
								Err := CloseDriver(aOutRefNum);
							END;
					END;
					TheFiles[NumFile].FileRef := 0;
					Error := 0;
					EXIT(FAsClose);
				END;

			WITH pb DO
				BEGIN
					tcbPtr := ThePtr;
					ioCompletion := @AsmCompletion;
				END;

			Error := FileTask(@pb,ReqClose,TheFiles[NumFile].FileRef,FALSE);
			WITH TheFiles[NumFile] DO
				BEGIN
					FileRef := 0;
					FilePos := 0;
					FileRLen := 0;
				END;
		END;
END;

PROCEDURE FAsCreate(VAR Str1: Str255; TheType, TheCreator: OsType);

VAR
	Err: OSErr;
	ThePtr: TPtr;
	pb: MyParamblockrec;
	XStr: Str255;

BEGIN
	ThePtr := GetCurSt;
	WITH ThePtr^ DO
		BEGIN
			{ creation }
			XStr := Str1;
			WITH pb DO
				BEGIN
					tcbPtr := ThePtr;
					ioCompletion := @AsmCompletion;
					ioNamePtr := @XStr;
					ioVRefNum := 0;
					ioFVersNum := 0;
				END;

			Error := FileTask(@pb,ReqCreate,0,FALSE);
			IF Error <> NoErr THEN EXIT(FAsCreate);

			{ Get Info }
			XStr := Str1;
			WITH pb DO
				BEGIN
					tcbPtr := ThePtr;
					ioCompletion := @AsmCompletion;
					ioNamePtr := @XStr;
					ioVRefNum := 0;
					ioVersNum := 0;
					ioFDirIndex := 0;
				END;

			Error := FileTask(@pb,ReqGetFInfo,0,FALSE);
			IF Error <> NoErr THEN EXIT(FAsCreate);

			{ Set Info }
			XStr := Str1;
			WITH pb DO
				BEGIN
					tcbPtr := ThePtr;
					ioCompletion := @AsmCompletion;
					ioNamePtr := @XStr;
					ioFlFndrInfo.fdType := TheType;
					ioFlFndrInfo.fdCreator := TheCreator;
				END;

			Error := FileTask(@pb,ReqSetFinfo,0,FALSE);
		END;
END;

PROCEDURE FASDelete(VAR Str1: Str255);

VAR
	Err: OSErr;
	ThePtr: TPtr;
	pb: MyHParamblockrec;

BEGIN
	WaitDelay(1);
	ThePtr := GetCurSt;
	WITH ThePtr^ DO
		BEGIN
			WITH pb, pb.ThePb DO
				BEGIN
					tcbPtr := ThePtr;
					ioCompletion := @AsmCompletion;
					ioNamePtr := @Str1;
					ioVRefNum := 0;
					ioDirId := 0;
				END;
			Error := FileTask(@pb,ReqDelete,0,TRUE);
		END;
END;

PROCEDURE SNewFolder(Str1: Str255);

VAR
	Err: OSErr;
	ThePtr: TPtr;
	pb: MyParamblockrec;

BEGIN
	ThePtr := GetCurSt;
	WITH ThePtr^ DO
		BEGIN
			WITH pb DO
				BEGIN
					tcbPtr := ThePtr;
					ioNamePtr := @Str1;
					ioVRefNum := 0;
					ioCompletion := @AsmCompletion;
					ioFlNum := 0;
				END;
			Error := FileTask(@pb,ReqDirCreate,0,FALSE);
		END;
END;

PROCEDURE SGetFInfo(Str1: Str255; VAR Str2: Str255; VAR Num1, Num2, Num3, Num4: Longint);

VAR
	Err: OSErr;
	ThePtr: TPtr;
	pb: RECORD
			TheTPtr: TPtr;
			ThePb: CInfoPbRec;
		END;
	XStr: Str255;
	Folder: boolean;

BEGIN
	ThePtr := GetCurSt;
	WITH ThePtr^ DO
		BEGIN
			{ Get Info }
			XStr := Str1;
			WITH pb, pb.ThePb DO
				BEGIN
					TheTPtr := ThePtr;
					ioCompletion := @AsmCompletion;
					ioNamePtr := @XStr;
					ioVRefNum := 0;
					ioFDirIndex := 0;
					ioDirID := 0;
				END;

			Error := FileTask(@pb,ReqGetCat,0,TRUE);

			WITH pb.ThePb DO
				BEGIN
					Folder := BTst(pb.ThePb.IOFlAttrib, 4);
					IF Folder THEN
						BEGIN
							Str2[0] := chr(0);		{ pas de signature ! }
							Num1 := Ord4(ioDrNmFls);
							Num2 := Ord4(ioDrBkDat);
							Num3 := Ord4(ioDrCrDat);
							Num4 := Ord4(ioDrMdDat);
						END
					ELSE
						BEGIN
							Str2[0] := chr(8);
							BlockMove(@ioFlFndrInfo, Ptr(Ord4(@Str2) + 1), 8);
							Num1 := Ord4(ioFlLgLen);
							Num2 := Ord4(ioFlRLgLen);
							Num3 := Ord4(ioFlCrDat);
							Num4 := Ord4(ioFlMdDat);
						END;
				END;
		END;
END;

PROCEDURE SSetFInfo(Str1: Str255; VAR Str2: Str255);

VAR
	Err: OSErr;
	ThePtr: TPtr;
	pb: MyHParamblockrec;
	XStr: Str255;

BEGIN
	ThePtr := GetCurSt;
	WITH ThePtr^ DO
		BEGIN
			{ Get Info }
			XStr := Str1;
			WITH pb, pb.ThePb DO
				BEGIN
					tcbPtr := ThePtr;
					ioCompletion := @AsmCompletion;
					ioNamePtr := @XStr;
					ioVRefNum := 0;
					ioVersNum := 0;
					ioFDirIndex := 0;
				END;

			Error := FileTask(@pb,ReqGetFinfo,0,TRUE);
			IF Error <> NoErr THEN EXIT(SSetFInfo);

			BlockMove(@Str2[1], @pb.ThePb.ioFlFndrInfo, 8);

			{ Set Info }
			XStr := Str1;
			WITH pb, pb.ThePb DO
				BEGIN
					tcbPtr := ThePtr;
					ioCompletion := @AsmCompletion;
					ioNamePtr := @XStr;
				END;
			Error := FileTask(@pb,ReqSetFinfo,0,TRUE);
		END;
END;

PROCEDURE FASRename(VAR Str1, Str2: Str255);

VAR
	ThePtr: TPtr;
	pb: MyHParamblockrec;

BEGIN
	ThePtr := GetCurSt;
	WITH ThePtr^ DO
		BEGIN
			Error := noErr;
			IF Str1<>Str2 THEN		{ 30/3/95 }
			WITH pb, pb.ThePb DO
				BEGIN
					tcbPtr := ThePtr;
					ioCompletion := @AsmCompletion;
					ioNamePtr := @Str1;
					ioVRefNum := 0;
					ioDirId := 0;
					ioMisc := @Str2;
					Error := FileTask(@pb,ReqRename,0,TRUE);
				END;
		END;
END;

PROCEDURE StartWrite;

BEGIN { on positionne RWIdx sur le 1er caractère à écrire }
	WITH GetCurSt^ DO RWIdx := 1;
END;

PROCEDURE EndWrite(NumFile: Longint);

VAR	Err: OsErr;
		Count: LONGINT;
		
BEGIN { flush du buffer vers le fichier }
	WITH GetCurSt^ DO
		BEGIN
			IF RWIdx > 1 THEN
				BEGIN
					count := RWIdx - 1;
					Err := FAsWrite(NumFile,count, Ptr(RWPtr));
					RWIdx := 1;
				END;
		END;
END;

PROCEDURE CarWrite(NumFile: Longint;
									 C: Char);

VAR
	FichCalc: Longint;

BEGIN
	WITH GetCurSt^ DO
		IF TheFiles[NumFile].BaseFlag THEN
			BEGIN
				{ on ecrit entre DBidx et jusqu'à DBsz-1 }
				FichCalc := DBsz - DBidx;
				IF FichCalc > 1 THEN FichCalc := 1;
				IF DBCount < DBidx + FichCalc THEN SetBaseEnd(DBidx + FichCalc);
				IF FichCalc > 0 THEN DBPtr^[DBidx] := C;
				DBidx := DBidx + FichCalc;
			END
		ELSE
			BEGIN
				RWPtr^[RWIdx] := C;
				RWIdx := RWIdx + 1;
				IF RWIdx > RWSz THEN EndWrite(NumFile);
			END;
END;

PROCEDURE StrWrite(NumFile: Longint;
									 VAR S: Str255);

VAR
	i, ToWrite: Integer;
	FichCalc: Longint;

BEGIN
	WITH GetCurSt^ DO
		BEGIN
			IF (NumFile < 1) OR (NumFile > MaxFile) THEN
				BEGIN
					Error := ErrBadNum;
					EXIT(StrWrite);
				END;
			IF TheFiles[NumFile].FileRef = 0 THEN
				BEGIN
					Error := ErrNotOpen;
					EXIT(StrWrite);
				END;
			IF TheFiles[NumFile].BaseFlag THEN
				BEGIN
					{ on ecrit entre DBidx et jusqu'à DBsz-1 }
					FichCalc := DBsz - DBidx;
					IF FichCalc > Length(S) THEN FichCalc := Length(S);
					IF DBCount < DBidx + FichCalc THEN SetBaseEnd(DBidx + FichCalc);
					BlockMove(Ptr(Ord4(@S) + 1), Ptr(Ord4(DBPtr) + DBidx), FichCalc);
					DBidx := DBidx + FichCalc;
				END
			ELSE
				BEGIN
					i := 0;
					WHILE i < Length(S) DO
						BEGIN
							ToWrite := RWSz - RWIdx + 1;
							IF ToWrite > (Length(S) - i) THEN
								BEGIN
									ToWrite := Length(S) - i;
									BlockMove(Ptr(Ord4(@S) + i + 1), Ptr(Ord4(RWPtr) + RWIdx - 1),
														ToWrite);
									i := Length(S);
									RWIdx := RWIdx + ToWrite;
									IF RWIdx > RWSz THEN EndWrite(NumFile);
								END
							ELSE
								BEGIN
									BlockMove(Ptr(Ord4(@S) + i + 1), Ptr(Ord4(RWPtr) + RWIdx - 1),
														ToWrite);
									i := i + ToWrite;
									RWIdx := RWIdx + ToWrite;
									EndWrite(NumFile);
								END;
						END;
				END; { IF }
		END; { WITH }
END;

PROCEDURE NumWrite(NumFile: Longint;
									 Num1: Longint);

VAR
	S: Str255;

BEGIN
	NumToString(Num1, S);
	StrWrite(NumFile, S);
END;

PROCEDURE RLen(NumFile, Num1: Longint);

BEGIN
	WITH GetCurSt^ DO
		BEGIN
			IF (NumFile < 1) OR (NumFile > MaxFile) THEN
				BEGIN
					Error := ErrBadNum;
					EXIT(RLen);
				END;
			IF (TheFiles[NumFile].FileRef = 0) OR TheFiles[NumFile].BaseFlag THEN
				BEGIN
					Error := ErrNotOpen;
					EXIT(RLen);
				END;
			IF Num1 < 1 THEN Num1 := 1;
			TheFiles[NumFile].FileRLen := Num1;
		END;
END;

PROCEDURE RSeek(NumFile, Num1: Longint);

BEGIN
	WITH GetCurSt^ DO
		BEGIN
			IF (NumFile < 1) OR (NumFile > MaxFile) THEN
				BEGIN
					Error := ErrBadNum;
					EXIT(RSeek);
				END;
			IF (TheFiles[NumFile].FileRef = 0) OR TheFiles[NumFile].BaseFlag THEN
				BEGIN
					Error := ErrNotOpen;
					EXIT(RSeek);
				END;
			IF Num1 < 0 THEN Num1 := 0;
			TheFiles[NumFile].FilePos := Num1 * TheFiles[NumFile].FileRLen;
			Error := NoErr;
		END;
END;

PROCEDURE SSeek(NumFile, Num1: Longint);

BEGIN
	WITH GetCurSt^ DO
		BEGIN
			IF (NumFile < 1) OR (NumFile > MaxFile) THEN
				BEGIN
					Error := ErrBadNum;
					EXIT(SSeek);
				END;
			IF TheFiles[NumFile].FileRef = 0 THEN
				BEGIN
					Error := ErrNotOpen;
					EXIT(SSeek);
				END;
			IF Num1 < 0 THEN Num1 := 0;
			IF TheFiles[NumFile].BaseFlag THEN
				BEGIN
					IF Num1 > DBsz THEN Num1 := DBsz;
					DBidx := Num1;
					IF DBidx > DBCount THEN SetBaseEnd(DBidx);
				END
			ELSE
				TheFiles[NumFile].FilePos := Num1;
		END;
END;

FUNCTION SFPos(NumFile: Longint): Longint;

BEGIN
	WITH GetCurSt^ DO
		BEGIN
			IF (NumFile < 1) OR (NumFile > MaxFile) THEN
				BEGIN
					Error := ErrBadNum;
					SFPos := 0;
					EXIT(SFPos);
				END;
			IF TheFiles[NumFile].FileRef = 0 THEN
				BEGIN
					Error := ErrNotOpen;
					SFPos := 0;
					EXIT(SFPos);
				END;
			IF TheFiles[NumFile].FileRef < 0 THEN
				BEGIN
					Error := 0;
					SFPos := 0;
					EXIT(SFPos);
				END;
			IF TheFiles[NumFile].BaseFlag THEN
				BEGIN
					SFPos := DBidx;
				END
			ELSE
				SFPos := TheFiles[NumFile].FilePos;
		END;
END;

FUNCTION SEof(NumFile: Longint): Longint;

BEGIN
	WITH GetCurSt^ DO
		BEGIN
			IF (NumFile < 1) OR (NumFile > MaxFile) THEN
				BEGIN
					Error := ErrBadNum;
					SEof := 1;
					EXIT(SEof);
				END;
			IF TheFiles[NumFile].FileRef = 0 THEN
				BEGIN
					Error := ErrNotOpen;
					SEof := 1;
					EXIT(SEof);
				END;
			IF TheFiles[NumFile].BaseFlag THEN
				BEGIN
					IF DBidx >= DBCount THEN
						SEof := 1
					ELSE
						SEof := 0;
				END
			ELSE
				BEGIN
					IF TheFiles[NumFile].FilePos >= FAsGetEOF(NumFile) THEN
						SEof := 1
					ELSE
						SEof := 0;
				END;
		END;
END;

PROCEDURE StartRead(NumFile: Longint);

VAR
	XPos: Longint;
	count: LONGINT;
	err: OsErr;
	
BEGIN
	WITH GetCurSt^ DO
		BEGIN
			IF (NumFile < 1) OR (NumFile > MaxFile) THEN
				BEGIN
					Error := ErrBadNum;
					EXIT(StartRead);
				END;
			IF TheFiles[NumFile].FileRef = 0 THEN
				BEGIN
					{ Disconnect; }
					Error := ErrNotOpen;
					EXIT(StartRead);
				END;

			IF TheFiles[NumFile].FileRef < 0 THEN
				BEGIN
					EXIT(StartRead);
				END;

			IF NOT TheFiles[NumFile].BaseFlag THEN
				BEGIN
					XPos := TheFiles[NumFile].FilePos;

					count := RWSz;
					Err := FAsRead(NumFile, count, Ptr(RWPtr));
					RWCount := count;
					
					RWIdx := 1;

					TheFiles[NumFile].FilePos := XPos;
				END;
		END;
END;

PROCEDURE StrRead(NumFile: Longint; VAR Str1: Str255);

VAR
	ThePtr: TPtr;
	Pos1, Pos2: Integer;
	XPos: Longint;
	termine: boolean;
	i: Integer;

	PROCEDURE FetchBase;

	VAR
		C, NextC: Char;

	BEGIN
		{ on lit dans la zone de com jusqu'à TAB, CR ou 255 caractères }
		WITH ThePtr^ DO
			BEGIN
				{ on lit entre DBidx et DBCount }
				Str1 := '';
				C := ' ';
				IF DBidx < DBCount THEN
				BEGIN
					REPEAT
						C := DBPtr^[DBidx];
						NextC := DBPtr^[DBidx+1];
						DBidx := DBidx + 1;
						IF (C <> chr($09)) AND (C <> chr($0D)) THEN
							BEGIN
								Str1[0] := chr(Length(Str1) + 1);
								Str1[Length(Str1)] := C;
								{Writeln('SRead:',Err,Ord(C));}
							END;
					UNTIL (DBidx > DBCount) OR (C = chr($09)) OR (C = chr($0D)) OR
								(Length(Str1) = 255);
					{ on vient de lire 255 car. suivi d'un TAB ou CR ? }
					IF (Length(Str1)=255) & (ord(NextC) IN [9,13]) THEN DbIdx:=DBIdx+1;
				END;
				IF DBidx > DBCount THEN
					Error := EofErr
				ELSE
					Error := 0;
			END;
	END;

	PROCEDURE FetchSerial;

	VAR
		pb: MyParamblockrec;
		TheChar: Integer;
		Err: OSErr;

	BEGIN
		{ on lit le port série jusque TAB, CR ou 255 caractères }
		Str1 := '';
		termine := False;
		TheChar := 0;
		WHILE NOT termine DO
			WITH ThePtr^ DO
				BEGIN
					Err := SerGetBuf(TheFiles[NumFile].FileRef, XPos);
					IF XPos > 0 THEN
						BEGIN
							{ on lit le caractère suivant }
							IOCompFlag := 1;
							StatusWord := IOWaitCst;

							WITH pb DO
								BEGIN
									tcbPtr := ThePtr;
									ioRefNum := TheFiles[NumFile].FileRef;
									ioCompletion := @AsmCompletion;
									ioBuffer := Ptr(Ord4(@TheChar) + 1);
									ioReqCount := 1;
									ioPosMode := fsFromStart;
									ioPosOffset := 0;
								END;
							Err := PBRead(@pb.QLink, True);
							YieldCpu;
							Error := pb.ioResult;
							IF Error = NoErr THEN
								BEGIN
									termine := (TheChar = 9) OR (TheChar = 13);
									IF NOT termine THEN
										BEGIN
											Str1[0] := chr(Ord(Str1[0]) + 1);
											Str1[Length(Str1)] := chr(TheChar);
											termine := Length(Str1) = 255;
										END;
								END
							ELSE
								termine := True;
						END
					ELSE
						WaitDelay(10);
				END;
	END;

BEGIN
	ThePtr := GetCurSt;
	WITH ThePtr^ DO
		BEGIN
			IF (NumFile < 1) OR (NumFile > MaxFile) THEN
				BEGIN
					Error := ErrBadNum;
					EXIT(StrRead);
				END;
			IF TheFiles[NumFile].FileRef = 0 THEN
				BEGIN
					Error := ErrNotOpen;
					EXIT(StrRead);
				END;

			IF TheFiles[NumFile].FileRef < 0 THEN
				BEGIN
					FetchSerial;
					EXIT(StrRead);
				END;

			IF TheFiles[NumFile].BaseFlag THEN
				BEGIN
					FetchBase;
					EXIT(StrRead);
				END;

			{ recherche de TAB ou CR }
			Str1 := '';
			IF RWIdx > RWCount THEN
				BEGIN
					StartRead(NumFile);
					termine := (RWCount = 0);
				END
			ELSE
				termine := False;
			Pos1 := RWIdx;
			Pos2 := RWIdx;
			WHILE (NOT termine) & (Length(Str1) + Pos2 - Pos1 <> 255) DO
				BEGIN
					termine := (Ord(RWPtr^[RWIdx]) IN [$09, $0D]);
					RWIdx := RWIdx + 1;
					IF NOT termine THEN	{ ce n'est pas un séparateur }
						BEGIN
							Pos2 := Pos2 + 1;
							IF RWIdx > RWCount THEN	{ fin de ce bloc de lecture… }
								BEGIN
									{ on recopie à la fin de la chaine Str1 }
									BlockMove(Ptr(Ord4(RWPtr)+Pos1-1), @Str1[Length(Str1)+1],Pos2-Pos1);
									Str1[0] := chr(Length(Str1)+Pos2-Pos1);

									{ on prepare encore un buffer }
									WITH TheFiles[NumFile] DO FilePos := FilePos+Pos2-Pos1;
									StartRead(NumFile);
									termine := (RWCount = 0);
									Pos1 := RWIdx;
									Pos2 := RWIdx;
								END;
							IF (Length(Str1)+Pos2-Pos1=255) & (RWCount<>0) & (Ord(RWPtr^[RWIdx]) IN [$09, $0D]) THEN
								RWIdx := RWIdx+1;	{ on saute le TAB ou CR qui suit 255 car. }
						END;
				END;

			Error := NoErr;

			IF (RWIdx - Pos1) > 0 THEN
				BEGIN
					IF (Pos2 - Pos1) > 0 THEN
						BEGIN
							{ on recopie à la fin de la chaine Str1 }
							BlockMove(Ptr(Ord4(RWPtr) + Pos1 - 1), Ptr(Ord4(@Str1) +
																												 Length(Str1) + 1),
												Pos2 - Pos1);
							Str1[0] := chr(Length(Str1) + Pos2 - Pos1);
						END;

					{ on met a jour le FilePos }
					WITH TheFiles[NumFile] DO FilePos := FilePos + RWIdx - Pos1;
				END;

			(* If (RWIdx>RWCount) and (RWCount<RWSz) then *)
			IF RWCount = 0 THEN Error := EofErr;

		END;
END;


PROCEDURE NumRead(NumFile: Longint; VAR Num2: Longint);

VAR
	Str1: Str255;
	i: Integer;
	termine: boolean;

BEGIN
	WITH GetCurSt^ DO
		BEGIN
			Str1 := '0';
			StrRead(NumFile, Str1);
			IF (Error <> NoErr) AND (Error <> EofErr) THEN
				BEGIN
					Num2 := 0;
					EXIT(NumRead);
				END;
			Num2 := SSVal(Str1);
		END;
END;

PROCEDURE BRead(NumFile: Longint; VAR Num2: Longint; Num3: Longint);

VAR
	FichCalc: Longint;
	dummy: LONGINT;
	count: LONGINT;
	
BEGIN
	WITH GetCurSt^ DO
		BEGIN
			IF (NumFile < 1) OR (NumFile > MaxFile) THEN
				BEGIN
					Error := ErrBadNum;
					EXIT(BRead);
				END;
			IF TheFiles[NumFile].FileRef = 0 THEN
				BEGIN
					Error := ErrNotOpen;
					EXIT(BRead);
				END;

			Num2 := 0;

			IF TheFiles[NumFile].BaseFlag THEN
				BEGIN
					{ on lit entre FichPtr et FichEnd }
					FichCalc := DBCount - DBidx;
					IF FichCalc > Num3 THEN FichCalc := Num3;
					BlockMove(Ptr(Ord4(DBPtr) + DBidx), Ptr(Ord4(@Num2) + 4 - FichCalc),
										FichCalc);
					DBidx := DBidx + FichCalc;
					IF FichCalc < Num3 THEN Error := EofErr;
				END
			ELSE
			BEGIN
				count := Num3;
				dummy := FAsRead(NumFile, count,Ptr(Ord4(@Num2) + 4 - Num3));
			END;
		END;
END;

PROCEDURE BWrite(NumFile, Num2, Num3: Longint);

VAR
	FichCalc: Longint;
	count: LONGINT;
	Err: OsErr;
	
BEGIN
	WITH GetCurSt^ DO
		BEGIN
			IF (NumFile < 1) OR (NumFile > MaxFile) THEN
				BEGIN
					Error := ErrBadNum;
					EXIT(BWrite);
				END;
			IF TheFiles[NumFile].FileRef = 0 THEN
				BEGIN
					Error := ErrNotOpen;
					EXIT(BWrite);
				END;

			IF TheFiles[NumFile].BaseFlag THEN
				BEGIN
					{ on ecrit entre DBidx et jusqu'à DBsz-1 }
					FichCalc := DBsz - DBidx;
					IF FichCalc > Num3 THEN FichCalc := Num3;
					IF DBCount < DBidx + FichCalc THEN SetBaseEnd(DBidx + FichCalc);
					BlockMove(Ptr(Ord4(@Num2) + 4 - Num3), Ptr(Ord4(DBPtr) + DBidx),
										Num3);
					DBidx := DBidx + FichCalc;
				END
			ELSE
			BEGIN
				count := Num3;
				Err := FAsWrite(NumFile,count, Ptr(Ord4(@Num2) + 4 - Num3));
			END;
		END;
END;


PROCEDURE SAppend(Num1: Longint; VAR Str1: Str255);

BEGIN
	WITH GetCurSt^ DO
		BEGIN
			FAsOpen(Str1, Num1);
			IF Error = 0 THEN
				BEGIN
					SLock(Num1); { 29/6/93 }
					TheFiles[Num1].FilePos := FAsGetEOF(Num1);
				END;
			IF Error <> 0 THEN TheFiles[Num1].FileRef := 0;
		END;
END;


PROCEDURE SOpenDrg(Num1: Longint; VAR Str1: Str255);

BEGIN
	WITH GetCurSt^ DO
		BEGIN
			FAsOpen(Str1, Num1);
			{ IF Error <> 0 THEN TheFiles[Num1].FileRef := 0; }
		END;
END;


PROCEDURE SOpenRF(Num1: Longint; VAR Str1: Str255); { •••• ouverture resource fork •••• }

BEGIN
	WITH GetCurSt^ DO
		BEGIN
			FAsOpenRF(Str1, Num1);
			IF Error <> 0 THEN TheFiles[Num1].FileRef := 0;
		END;
END;


PROCEDURE SClose(Num1: Longint);

BEGIN
	FAsClose(Num1);
END;


PROCEDURE SCreate(VAR Str1: Str255);

BEGIN
	FAsCreate(Str1, 'TEXT', 'DRAG');
END;


PROCEDURE SGetVol(VAR AdStr: Str255; Num1: Longint);

TYPE
	TVCBPtr = ^VCB;

VAR
	Err: OSErr;
	ThePtr: TPtr;
	CurVCB: Integer;
	VCBPtr: TVCBPtr;

BEGIN
	ThePtr := GetCurSt;
	WITH ThePtr^ DO
		BEGIN
			AdStr := '';
			IF (Num1 < 1) THEN
				BEGIN
					Error := - 35;
					EXIT(SGetVol);
				END;

			{ on doit se palucher la queue des volumes }
			VCBPtr := TVCBPtr(GetVcbQHdr^.qHead);
			CurVCB := 1;
			WHILE (CurVCB <> Num1) AND (VCBPtr <> TVCBPtr(GetVcbQHdr^.qTail)) DO
				BEGIN
					CurVCB := CurVCB + 1;
					VCBPtr := TVCBPtr(VCBPtr^.QLink);
				END;

			IF (VCBPtr <> NIL) AND (CurVCB = Num1) THEN
				BEGIN
					BlockMove(@VCBPtr^.vcbVN, @AdStr, 40);
					AdStr[0] := chr(Length(AdStr) + 1);
					AdStr[Length(AdStr)] := ':';
					Error := 0;
				END
			ELSE
				BEGIN
					Error := - 35;
					EXIT(SGetVol);
				END;
		END;
END;


PROCEDURE TraceOpen(VAR name:Str255);
{ création du fichier }
{ ouverture du fichier }

VAR
	Err: OSErr;
	pb: MyParamblockrec;
	Qpb: TQERec;

BEGIN
	WITH GetCurSt^ DO
	BEGIN
		IF traceFile<>0 THEN
			Error := ErrFileOpen
		ELSE
		BEGIN
			{ création du fichier }
			FAsCreate (name, 'TEXT', 'DRAG');
			{ ouverture du fichier de trace }
			IOCompFlag := 1;
			StatusWord := IOWaitCst;
			WITH pb DO
			BEGIN
				tcbPtr := GetCurSt;
				ioCompletion := @AsmCompletion;
				ioNamePtr := @Name;
				ioVRefNum := 0;
				ioVersNum := 0;
				ioPermssn := FsRdWrPerm;
				ioMisc := NIL;
			END;

			WITH Qpb DO
			BEGIN
				ECode := ReqOpen;
				EParam1 := @pb;
				EMisc := 0;
			END;
			TEnQueue(FileQ, Qpb);

			Error := pb.ioResult;
			IF pb.IoResult=NoErr THEN
				traceFile := Qpb.EMisc;
		END;	{ IF TraceFile <> 0 }
	END;	{ WITH GetCurST^ }
END;

PROCEDURE TraceWrite(VAR data:Str255);

VAR
	Err: OSErr;
	pb: MyParamblockrec;
	LogEOF: LONGINT;
	
BEGIN
	WITH GetCurSt^ DO
	BEGIN
		IF TraceFile<>0 THEN
		BEGIN
			{ on se positionne à la fin }
			WITH pb DO
			BEGIN
				tcbPtr := GetCurST;
				ioCompletion := @AsmCompletion;
			END;
			Error := FileTask(@pb,ReqGetEof,TraceFile,FALSE);
			IF Error=NoErr THEN
			BEGIN
				LogEOF := Ord4(pb.ioMisc);	{ longueur actuelle du fichier }
				{ on écrit à la fin du fichier }
				WITH pb DO
				BEGIN
					tcbPtr := GetCurST;
					ioCompletion := @AsmCompletion;
					ioBuffer := @data[1];
					ioReqCount := length(data);
					ioPosMode := fsFromStart;
					ioPosOffset := LogEOF;
				END;
				Error := FileTask(@pb,ReqWrite,TraceFile,FALSE);
			END;
		END
		ELSE
			Error := ErrNotOpen;
	END;
END;


PROCEDURE TraceClose;
{ fermeture du fichier }

VAR
	pb: MyParamblockrec;

BEGIN
	WITH GetCurST^ DO
	BEGIN
		WITH pb DO
		BEGIN
			tcbPtr := GetCurST;
			ioCompletion := @AsmCompletion;
		END;
		Error := FileTask (@pb, ReqClose, TraceFile, FALSE);
	END;
END;

{===============================================================================}
{							      				U T I L I T A I R E S     													}
{===============================================================================}

FUNCTION PathNameFromDirID (DirID:longint; vRefnum:integer; VAR FullPathName:Str255):OsErr;
{ rend le pathname partant d'un vRefNum+DirID }

VAR Qpb	    : TQERec;
		Block :	RECORD
						TheTPtr: TPtr;
						ThePb: CInfoPbRec;
					END;
		directoryName : str255;
	
BEGIN
	FullPathName := '';
	WITH block.thePB DO
	BEGIN
		ioNamePtr := @directoryName;
		ioDrParID := DirId;
	END;

	REPEAT
		{ préparation de l'I/O }
		WITH GetCurSt^ DO
		BEGIN
			ioCompFlag := 1;
			StatusWord := ioWaitCst;
		END;
		Block.theTPtr := GetCurSt;

		{ préparation du ParamBlock }
		WITH block.thePB DO
		BEGIN
			ioCompletion := @AsmCompletion;
			ioVRefNum := vRefNum;
			ioFDirIndex := -1;
			ioDrDirID := block.thePB.ioDrParID;
		END;
		
		{ Appel de PBGetCatInfo }
		WITH Qpb DO
		BEGIN
				ECode := ReqGetCat;
				EParam1 := @block;
		END;
		TEnQueue(FileQ, Qpb);
		IF block.thePB.ioResult=NoErr THEN	{ pas d'erreur }
		BEGIN
			directoryName := concat(directoryName,':');
			fullPathName := concat(directoryName,fullPathName);
		END;
		
	UNTIL (block.thePB.ioDrDirID = 2) | (block.thePB.ioResult<>NoErr) ;

	PathNameFromDirID := block.thePB.ioResult;	{ code erreur en retour }
END;


{===============================================================================}
{											R	O	U	T	I	N	E	S	 	E	X	T	E	R	N	E	S													}
{===============================================================================}


FUNCTION GetTCB:Ptr;	{ rend le TCB courant }

BEGIN
	GetTcb := Ptr(GetCurSt);
END;


FUNCTION PBCall(theCall:INTEGER; PbPtr:MyParmBlkPtr):OsErr;

VAR	QPb: TQERec;
		Err: OsErr;

BEGIN
	WITH PbPtr^ DO
	BEGIN
		tcbPtr := GetCurSt;
		ioCompletion := @AsmCompletion;
		{ les autres champs sont remplis par l'appelant }
	END;
	
	WITH GetCurSt^ DO
	BEGIN
		ioCompFlag := 1;
		StatusWord := IOWaitCst;
	END;

	WITH Qpb DO
	BEGIN
		ECode := theCall;
		EParam1 := Ptr(PbPtr);
		EMisc := PbPtr^.ioRefNum;	{ on passe le RefNum éventuel }
	END;
	TEnQueue(FileQ, Qpb);
	PbPtr^.ioRefNum := Qpb.EMisc;
	PBCall := PbPtr^.ioResult;	{ code erreur }

END;


FUNCTION PBHCall(theCall:INTEGER; PbPtr:MyHParmBlkPtr):OsErr;

BEGIN
	WITH PbPtr^, PbPtr^.thePb DO
	BEGIN
		tcbPtr := GetCurSt;
		ioCompletion := @AsmCompletion;
		{ les autres champs sont remplis par l'appelant }
	END;
	PbHCall := FileTask(Ptr(PbPtr),theCall,PbPtr^.thePb.ioRefNum,TRUE);
END;

{ ======================= APPELS DANS DRAGSTERBOOT ===================== }

FUNCTION CallTask(Queue: INTEGER; VAR param1: Ptr; param2:Ptr; misc: LONGINT; theReq: INTEGER):OsErr;

VAR	QPb: TQERec;
		
BEGIN
	WITH GetCurSt^ DO	{ on se met en attente d'I/O }
	BEGIN
		ioCompFlag := 1;
		StatusWord := IOWaitCst;
	END;

	WITH Qpb DO
	BEGIN
		ECode := theReq;
		EParam1 := param1;
		EParam2 := param2;
		EMisc := misc;
		TEnQueue(Queue, Qpb);
		param1 := EParam1;
		misc := EMisc;
	END;
	CallTask := QPB.ERet;	{ code d'erreur rendu }
END;

FUNCTION CallTask2(Queue: INTEGER; param1,misc:LONGINT; theReq: INTEGER):OsErr;

VAR	QPb: TQERec;
		
BEGIN
	WITH GetCurSt^ DO	{ on se met en attente d'I/O }
	BEGIN
		ioCompFlag := 1;
		StatusWord := IOWaitCst;
	END;

	WITH Qpb DO
	BEGIN
		ECode := theReq;
		EParam1 := ptr(param1);
		EMisc := misc;
		TEnQueue(Queue, Qpb);
	END;
	CallTask2 := QPB.ERet;	{ code d'erreur rendu }
END;

{ ======================= GESTION MEMOIRE PAR DRAGSTERBOOT ===================== }

FUNCTION DrgNewHandle(size:LONGINT):Handle;
{ allocation d'un Handle par DragsterBoot }

VAR
	Err: OsErr;
	param1: Ptr;
	
BEGIN
	Err := CallTask(MainQueue,param1,NIL,size,ReqNewHandle);
	GetCurST^.Error := Err;
	IF Err = NoErr THEN
		DrgNewHandle := Handle(Param1)
	ELSE
		DrgNewHandle := NIL;	{ prob d'allocation, voir DrgError }
END;


FUNCTION DrgStoreData(dataPtr:Ptr; dataName:Str255):OsErr;
{ enregistrement de datas par DragsterBoot }

BEGIN
(*	DebugStr('RT: CallTask');	{ bugstoredata } *)
	DrgStoreData := CallTask(MainQueue,dataPtr,@DataName,0,ReqStoreData);
(*	DebugStr('RT: Retour CallTask');	{ bugstoredata } *)
END;


FUNCTION DrgRestoreData(dataName:Str255):Ptr;
{ récupération de datas conservées par DragsterBoot }

VAR
	param1: Ptr;
	err: OsErr;
	
BEGIN
	IF GetCurST^.TaskNumber=2000 THEN
		Err := CallTask(MainQueue,param1,@DataName,0,ReqRestoreData)
	ELSE
		Err := CallTask(ShutDownQ,param1,@DataName,0,3);
	DrgRestoreData := param1;	{ = NIL si datas inconnues }
END;


PROCEDURE DrgKillData(dataName:Str255);
{ suppression de datas conservées par DragsterBoot }

VAR
	Err: OsErr;
	param1: Ptr;
	
BEGIN
	Err := CallTask(MainQueue,param1,@dataName,0,ReqKillData);
END;

{$D-}
{ ======================== CallBack protection EVE ====================== }
FUNCTION DrgEVEReset:INTEGER;
{ raz de la clé }

BEGIN
	DrgEVEReset := CallTask2(MainQueue,0,0,$1000);	
END;

FUNCTION DrgEVEStatus:INTEGER;
{ lecture status clé }

BEGIN
	DrgEVEStatus := CallTask2(MainQueue,0,0,$1001);	
END;


FUNCTION DrgEVEEnable(VAR PASSWORD:STRING) : INTEGER;
{ activation des mots de passe }

BEGIN
	DrgEVEEnable := CallTask2(MainQueue,ORD4(@password),0,$1002);
END;


FUNCTION DrgEVEChallenge(LOCK,VALUE : INTEGER) : INTEGER;
{ utilisation registres "challenge" }

BEGIN
	DrgEVEChallenge := CallTask2(MainQueue,0,Band(bsl(Lock,16),value),$1003);
END;


FUNCTION DrgEVEReadGPR(GPR : INTEGER) : INTEGER;
{ lecture registres normaux }

BEGIN
	DrgEVEReadGPR := CallTask2(MainQueue,0,GPR,$1004);
END;


FUNCTION DrgEVEWriteGPR(GPR,VALUE : INTEGER) : INTEGER ;
{ écriture registres normaux }

BEGIN
	IF GetCurST^.TheNScreen>$1000 THEN
		DrgEVEWriteGPR := CallTask2(MainQueue,0,Band(bsl(gpr,16),value),$1005)
	ELSE
		DrgEVEWriteGPR := NoErr;
END;


FUNCTION DrgEVESetLock(LOCK,CHALLENGE,RESPONSE:INTEGER) : INTEGER ;
{ écriture registres "challenge" }

BEGIN
	IF GetCurST^.TheNScreen>$1000 THEN
		DrgEVESetLock := CallTask2(MainQueue,band(bsr(lock,16),response),challenge,$1006)
	ELSE
		DrgEVESetLock := noErr;
END;


FUNCTION DrgEVEReadCTR : INTEGER ;
{ lecture compteur d'accès }

BEGIN
	IF GetCurST^.TheNScreen>$1000 THEN
		DrgEVEReadCTR := CallTask2(MainQueue,0,0,$1007)
	ELSE
		DrgEVEReadCTR := 0;
END;


PROCEDURE DrgShutDownInstall(procPtr,dataPtr: Ptr);

VAR
	Err: OsErr;
	
BEGIN
	Err := CallTask(MainQueue,procPtr, dataPtr, 0, 6)
END;


{$D+}
PROCEDURE HandleSelector;		{ appelle la routine correspondant à D0 }

	FUNCTION Value:INTEGER;
		INLINE $3E80;							{ MOVE.W D0,(A7) }
	
PROCEDURE Jump(Addr:Ptr);
	INLINE $205F,$4E5E,$4ED0;		{ MOVEA.L (A7)+,A0 ; UNLK A6; JMP (A0) }
		
BEGIN
	CASE Value OF
		{ routines interne de la librairie }
		1: Jump(@FASRead);
		2: Jump(@FASWrite);
		3: Jump(@PBCall);		{ appels 'normaux' du file manager }
		4: Jump(@PBHCall);	{ appels 'hiérarchiques' du file manager }
		5: Jump(@SetRunMode);
		6: Jump(@DrgShutDownInstall);
		
		{ routines utilitaires de la librairie }
		128: Jump(@PathNameFromDirID);

		{ routines utilitaires en liaison avec DragsterBoot }
		256: Jump(@DrgNewHandle);
		257: Jump(@DrgStoreData);
		258: Jump(@DrgRestoreData);
		259: Jump(@DrgKillData);
		
		{ appels protection EVE }
		$1000: Jump(@DrgEVEReset);
		$1001: Jump(@DrgEVEStatus);
		$1002: Jump(@DrgEVEEnable);
		$1003: Jump(@DrgEVEChallenge);
		$1004: Jump(@DrgEVEReadGPR);
		$1005: Jump(@DrgEVEWriteGPR);	{ protégé }
		$1006: Jump(@DrgEVESetLock);	{ protégé }
		$1007: Jump(@DrgEVEReadCTR);	{ protégé }

	END;
END;


PROCEDURE UnitInit;
BEGIN
	MyConst;
END;

END. { of Unit }
