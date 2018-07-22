UNIT Emulator;

INTERFACE

USES MemTypes, QuickDraw, OSIntf, ToolIntf, Packages;

CONST
	EMRef = 1000;

VAR
	PosEmul: Rect;
	EmulFlag: BOOLEAN;	{ indique si on utilise l'émulateur ou pas }
	EmulType: INTEGER;	{ type d'émulation… }
	ReadBuff: Str255;
	
PROCEDURE EM_Init;

PROCEDURE EM_Open;

PROCEDURE EM_Close;

PROCEDURE EM_Draw(LaFen: WindowPtr);

PROCEDURE EM_Clic(ThePoint: point);

PROCEDURE EM_Key(TheKey: Char; shift: BOOLEAN);

PROCEDURE EM_Write(LesCar: Handle);

FUNCTION EM_Read:Str255;

PROCEDURE EM_Ctrl(Action: Integer; VAR Reponse: Integer);

IMPLEMENTATION

USES Traps, CTB, Videotex,
			{$U $$Shell(PUtilities) }Utilities;

CONST
	MinBut = 1000;
	MaxBut = 1008;

	EM_Left = 8;
	EM_Top = 8;
	EM_Right = 328;
	EM_Bottom = 258;

	Velizy = 10;
	VidGraph = 12;

	Connexion = 'I';
	Repetition = 'C';
	Sommaire = 'F';
	Guide = 'D';
	Annulation = 'E';
	Correction = 'G';
	Retour = 'B';
	Suite = 'H';
	Envoi = 'A';

TYPE
	VtxChar = STRING[3];

VAR
	ScPtr: DialogPtr;
	CHdl: ARRAY [0..10] OF ControlHandle;
	EmRect: Rect;
	conFlag: BOOLEAN;

	EmulData: GlobPtr;
	



{$S Videotex}
PROCEDURE EM_Init;

BEGIN
	ScPtr := NIL;
	EmulData := NIL;
	SetRect(EmRect, EM_Left, EM_Top, EM_Right, EM_Bottom);
END;


{$S Videotex}
PROCEDURE GenConnect;

BEGIN
	conFlag := NOT conFlag;
	SetStatutConnexion(EmulData,conFlag);
END;


{$S Videotex}
PROCEDURE GenChar(TheChar: Char; SepGen: BOOLEAN);

VAR
	CLen: Longint;

BEGIN
	IF (conFlag=FALSE) | (Length(ReadBuff)>250) THEN EXIT(GenChar);
	IF SepGen THEN ReadBuff := concat(ReadBuff,chr(SEP));
	ReadBuff := concat(ReadBuff,theChar);
END;


{$S Videotex}
PROCEDURE GenCtl(TheC: ControlHandle);

VAR
	i: Integer;
	termine: BOOLEAN;

BEGIN
	{ on choppe le bon controle }
	termine := false;
	i := 0;
	WHILE (i <= MaxBut - MinBut) AND NOT termine DO
		BEGIN
			termine := (TheC = CHdl[i]);
			IF NOT termine THEN i := i + 1;
		END;
	{ on genere le code équivalent }
	IF termine THEN
		CASE i OF
			0:
				GenConnect;
			1:
				GenChar(Repetition, true);
			2:
				GenChar(Guide, true);
			3:
				GenChar(Sommaire, true);
			4:
				GenChar(Annulation, true);
			5:
				GenChar(Correction, true);
			6:
				GenChar(Retour, true);
			7:
				GenChar(Suite, true);
			8:
				GenChar(Envoi, true);
		END;
END;

{======================================================================}
{ 											 I N I T																			 }
{======================================================================}

{$S Videotex}
PROCEDURE Init_EM;

VAR
	Att: Byte;
	i: Integer;

BEGIN
	IF (ScPtr <> NIL) THEN EXIT(Init_EM);

	{ écran physique }
	IF gQDVersion>0 THEN
		ScPtr := GetNewCWindow(EMRef, NIL, Pointer( - 1))	{ couleur }
	ELSE
		ScPtr := GetNewWindow(EMRef, NIL, Pointer( - 1));	{ noir & blanc }
	
	SetWRefCon(ScPtr, EMRef);
	MoveWindow(ScPtr, PosEmul.left, PosEmul.top, false);

	{ on choppe les boutons }
	FOR i := MinBut TO MaxBut DO
		BEGIN
			CHdl[i - MinBut] := GetNewControl(i, ScPtr);
		END;

	ShowWindow(ScPtr);

	{ init émulation… }
	EmulData := GlobPtr(NewPtr(SizeOf(GlobRec)));
	IF gQDVersion>0 THEN
		InitVideotex(EmulData,ScPtr,EmulType+3,c2ndSize,NIL)
	ELSE	{ on force le gris tramés si Color QD absent }
		InitVideotex(EmulData,ScPtr,cModeNoirGris,c2ndSize,NIL);
	{ buffer d'entrée }
	ReadBuff := '';
END;

{======================================================================}
{ 													 O P E N																	 }
{======================================================================}

{$S Videotex}
PROCEDURE EM_Open;

VAR
	i: Integer;

BEGIN
	Init_EM;
	conFlag := false;
	ReadBuff := '';
END;

{======================================================================}
{ 													C L O S E 																 }
{======================================================================}

{$S Videotex}
PROCEDURE EM_Close;

BEGIN
	IF (ScPtr = NIL) THEN EXIT(EM_Close);
	HideWindow(ScPtr);
	KillControls(ScPtr);
	DisposeWindow(ScPtr);
	ScPtr := NIL;
	CleanEmul(EmulData);
	EmulData := NIL;
END;

{======================================================================}
{ 													D R A W 																	 }
{======================================================================}

{$S Videotex}
PROCEDURE EM_Draw(LaFen: WindowPtr);

VAR
	Arect: Rect;

BEGIN
	IF (ScPtr = NIL) OR (ScPtr <> LaFen) THEN EXIT(EM_Draw);
	DrawControls(ScPtr);
	PenSize(3, 3);
	PenPat(gray);
	Arect := EmRect;
	InSetRect(Arect, - 3, - 3);
	FrameRect(Arect);
	PenNormal;
	SupprimeCurseur(EmulData);
	UpdateScreen(EmulData);
END;

{======================================================================}
{ 													C L I C 																	 }
{======================================================================}

{$S Videotex}
PROCEDURE EM_Clic(ThePoint: point);

VAR
	TheC: ControlHandle;

BEGIN
	IF (ScPtr = NIL) THEN EXIT(EM_Clic);
	IF (FindControl(ThePoint, ScPtr, TheC) = inButton)
	 & (TrackControl(TheC, ThePoint, NIL) = inButton) THEN GenCtl(TheC);
END;

{======================================================================}
{ 														K E Y 																	 }
{======================================================================}

{$S Videotex}
FUNCTION MacToVtx(Data:CHAR):VtxChar;

VAR
	Temp:VtxChar;
	G2: BOOLEAN;

BEGIN	{ •• on ne gère pas les majuscules accentuées ! •• }
	Temp := Chr(SS2);
	CASE Data OF
		'á','é','í','ó','ú': Temp := concat(Temp,CHR($42));
		'à','è','ì','ò','ù','À': Temp := concat(Temp,CHR($41));
		'â','ê','î','ô','û': Temp := concat(Temp,CHR($43));
		'ä','ë','ï','ö','ü','Ä','Ö','Ü': Temp := concat(Temp,CHR($48));
		'ç','Ç': Temp := concat(Temp,CHR($4B));
		
		'£': Temp := concat(Temp,CHR($23));
		'§': Temp := concat(Temp,CHR($27));
		'±': Temp := concat(Temp,CHR($31));
		'÷': Temp := concat(Temp,CHR($38));
		'œ': Temp := concat(Temp,CHR($7A));
		'Œ': Temp := concat(Temp,CHR($6A));
		'ß': Temp := concat(Temp,CHR($7B));
		OTHERWISE Temp := '';
	END;
	IF (length(Temp) <>0) & (ORD(Temp[2])>=$40) & (ORD(Temp[2])<=$4F) THEN
	CASE Data OF
		'á','à','â','ä': Temp := concat(Temp,'a');
		'é','è','ê','ë': Temp := concat(Temp,'e');
		'í','ì','î','ï': Temp := concat(Temp,'i');
		'ó','ò','ô','ö': Temp := concat(Temp,'o');
		'ú','ù','û','ü': Temp := concat(Temp,'u');
		'À','Ä': Temp := concat(Temp,'A');
		'Ö': Temp := concat(Temp,'O');
		'Ü': Temp := concat(Temp,'U');
		'ç': Temp := concat(Temp,'c');
		'Ç': Temp := concat(Temp,'C');
	END;
	MacToVtx := Temp;
END;

{$S Videotex}
PROCEDURE EM_Key(TheKey: Char; shift: BOOLEAN);

VAR	Temp: Str255;
		i: INTEGER;
		
BEGIN
	IF (ScPtr = NIL) THEN EXIT(EM_Key);
	{ caractère spécial ? }
	IF Ord(TheKey) IN [32..127] THEN
		temp := theKey
	ELSE
		CASE ORD(TheKey) OF
			3,13: Temp := concat(CHR(SEP),ENVOI);
			27:	IF Shift THEN
						Temp := concat(CHR(SEP),REPETITION)
					ELSE
						Temp := concat(CHR(SEP),SOMMAIRE);
			28: Temp := concat(CHR(SEP),SOMMAIRE);
			29: Temp := concat(CHR(SEP),GUIDE);
			30: Temp := concat(CHR(SEP),RETOUR);
			9,31: Temp := concat(CHR(SEP),SUITE);
			8:	IF Shift THEN
						Temp := concat(CHR(SEP),ANNULATION)
					ELSE
						Temp := concat(CHR(SEP),Correction);
			OTHERWISE Temp := MacToVtx(TheKey);
		END;
	
	FOR i := 1 TO Length(temp) DO GenChar(Temp[i],FALSE);
END;

{======================================================================}
{ 													 R E A D																	 }
{======================================================================}

{$S Videotex}
FUNCTION EM_Read:Str255;

BEGIN
	VideoCurseur(EmulData);
	EM_Read := ReadBuff;
	ReadBuff := '';
END;

{======================================================================}
{ 													C T R L 																	 }
{======================================================================}

{$S Videotex}
PROCEDURE EM_Ctrl(Action: Integer; VAR Reponse: Integer);

BEGIN
	{ on execute l'action de contrôle }
	CASE Action OF
		0:
			IF conFlag THEN Reponse := 1
			ELSE Reponse := 0;
	END;
END;

{======================================================================}
{ 													W R I T E 																 }
{======================================================================}

{$S Videotex}
PROCEDURE EM_Write(LesCar: Handle);

VAR
	flags: SignedByte;
	sendString: Str255;
	
BEGIN
	IF NOT conFlag THEN EXIT(EM_Write);
	flags := HGetState(LesCar);
	HLock(LesCar);
	Emul(EmulData,LesCar^,GetHandleSize(LesCar),SendString);
	HSetState(Lescar,Flags);
	IF SendString<>'' THEN
		FOR flags := 1 TO Length(SendString) DO
			GenChar(SendString[flags],FALSE);
END;

END. { Implementation }
