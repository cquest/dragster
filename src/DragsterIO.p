{$SETC SERIAL=FALSE}

UNIT DragsterIO;
{===============================================================================

     VIDEO BASIC

     Basic adapté au Videotex - partie E/S

     Version du 2/2/86 - Philippe Boulanger

===============================================================================}



INTERFACE
{==============================================================================}
{			        I N T E R F A C E			       }
{==============================================================================}

USES	MemTypes,QuickDraw,OSIntf,ToolIntf,Packages,
		{$U $$Shell(PUtilities) }Utilities,
		Emulator, WritelnWindow, ADSP;

{$I DragsterTCB.p }

     CONST
               ErrTime	 =    128; { timeOut }
               CRepetition =  129;
               CEnvoi	 =    130;
               CGuide	 =    131;
               CSommaire =    132;
               CSuite	 =    133;
               CRetour	 =    134;
               CAnnulation =  135;
               CCorrection =  136;
               CConnexion=    137;
               CAutre=	      138;
			   CIgnore=		  255;
			   
	 	  	   xSerBufSz	 = 	  1024;
		  
		  	   rALRTPortUsed = 133;
			   rALRTCantOpen = 134;
			   rALRTNoModem	 = 136;
			   

     TYPE      PStr255	 =    ^Str255;
               Conf	     = PACKED ARRAY[0..127] OF byte;
               Confptr	     = ^Conf;
               ConfHandle    = ^ConfPtr;
               SNH	     = ^SNP;
               SNP	     = ^SNR;
               SNR	     = RECORD
                                 TheMask,TheSn: Longint;
                           END;


     VAR      LocalMode : Boolean;		  { Mode minitel local }
               ConfH	 : ConfHandle;		  { Handle de configuration}
               BreakCount: Integer;		  { protection }
               RunFlag	 : Boolean;		  { Indicateur de Run }
               EchoFlag	 : Boolean;		  { Indicateur d'echo }
               MySn	 : SNH;
               TraceFlag : Boolean;		  { Indicateur de trace	   }
               MonMain	 : Ptr;			  { Pointeur sur MainEventLoop }
               SnFlag	 : Boolean;
               ConFlag	 : Boolean;		  { Indicateur de connexion }
               SysParms	 : SysParmType;	  { Sauvegarde config }
               TheModNumber: integer;
               ProtCount : Integer;		  { Protection		   }
			   TheSerBuf : Ptr;
			   TheAuxSerBuf: Ptr;
			   
			   BackFlag	:	Boolean;		{ Dragster en Back }
	 	  	   DemoRSflag: Boolean;			{ sortie RS232C sur demo }
			   DemoConnect: Boolean;
          	   TheBuffer : Handle;		     { Buffer de sortie	      }
               SerRefIn  : Integer;		     { Fichier d'entree	      }
               SerRefOut : Integer;		     { Fichier de sortie      }
               TheSPort  : Char;		     { port série utilisé     }
               Inited    : Boolean;			 { indique si un port est utilisé }
               PBloc	 : ParmBlkPtr;

				CurTCB	: TPtr;			{ TCB bidon pour l'interpreteur }

PROCEDURE InitIO;
PROCEDURE InitSerial(newPort:Char);
PROCEDURE ResetBuffer;
PROCEDURE CheckButton;
PROCEDURE FlushIn;
PROCEDURE PAddBuffer(P: Ptr; pLen: Longint);
PROCEDURE AddBuffer(P: PStr255);
PROCEDURE FlushBuffer;
FUNCTION Zinput(VAR Str1: Str255; PosX,PosY,MaxLen, Attribs: Integer;
                MaxTime: Longint; BackCar: Char; ReqInput: Boolean): Integer;
PROCEDURE WaitDelay(NbTicks: longint);
PROCEDURE StopIO;
PROCEDURE AsRead(VAR ThePrompt, TheBuffer: str255; TimeLimit: Longint;
                 SkipEnt: Boolean);
PROCEDURE PaqPrep(VAR TheBuffer: Str255; ComChar: Char);
PROCEDURE StartDataPaq;
PROCEDURE EndDataPaq;
PROCEDURE AddDataPaq(P: PStr255);
PROCEDURE WordAlign;
PROCEDURE WordEdAlign;
FUNCTION AuxRefIn: integer;
PROCEDURE TestConnect(VAR Rep: Boolean);
PROCEDURE SetSpeed(Bauds: longint);


IMPLEMENTATION
{===============================================================================}
{						I M P L E M E N T A T I O N								}
{===============================================================================}
CONST
		BS		 = chr(8);
		LF		 = chr(10);
		FF		 = chr(12);
		RC		 = chr(13);
		SO		 = chr(14);
		SI		 = chr(15);
		DC1		 = chr(17);
		REP		 = chr(18);
		SEP		 = chr(19);
		DC4		 = chr(20);
		SS2		 = chr(22);
		CAN		 = chr(24);
		ACC		 = chr(25);
		ESC		 = chr(27);
		RS		 = chr(30);
		US		 = chr(31);
		SP		 = chr(32);
		
		rNoModemALRT = 260;

VAR
		NextEvent : LONGINT;			 { Valeur de tickcount lors du dernier 'CheckButton' }

{==============================================================================}
{			       F O R W A R D S				       }
{==============================================================================}


{==============================================================================}
{			     U T I L I T A I R E S			       }
{==============================================================================}

PROCEDURE MonCallProc(TheProc: Ptr); EXTERNAL;



{$S INIT}
PROCEDURE InitIO;
    VAR Err     : OsErr;
BEGIN
	{ on regarde d'abord si la tâche de fond est là }
	NextEvent:=TickCount;
	Err:=RechDrag;
	
	BackFlag:=(Err>0);
	
    { config }
    ConfH:=ConfHandle(GetResource('SVCF',256));
	EmulFlag := (ConfH^^[0]=0);
	EmulType := ConfH^^[2];
	IF (EmulType<0) OR (EmulType>2) THEN EmulType := 1;
	
    TheSPort := ' ';	{ aucun port utilisé pour le moment }
	
    ProtCount:=0;
    BreakCount:=0;

	{$IFC DEMO}
	 DemoRSflag:=False;
	 DemoConnect:=False;
	{$ENDC}
	
    { buffer de sortie }
    IF TheBuffer=NIL THEN TheBuffer:=NewHandle(0);
    HNoPurge(Handle(TheBuffer));

    Inited:=False;
    IF EmulFlag=FALSE THEN
		InitSerial(chr(Ord('A')+ConfH^^[1]))
	ELSE
		SerRefIn := -8;	{ émulation -> port auxiliaire = port modem }

    TheModNumber:=0;
END;	{ InitIO }


{$S DRAGSTERIO}

PROCEDURE WaitDelay(NbTicks: longint);
     VAR ToWait: Longint;
BEGIN
     ToWait:=TickCount+NbTicks;
     REPEAT
          CheckButton
     UNTIL (tickCount>ToWait) OR (NOT RunFlag);
END;


FUNCTION AuxRefIn: integer;
BEGIN
	IF SerRefIn=-6 THEN AuxRefIn:=-8 ELSE AuxRefIn:=-6;
END;


PROCEDURE SetSpeed(Bauds: longint);
    VAR Err	 : OsErr;
        flags	 : SerShk;
BEGIN
	IF NOT BackFlag THEN
	BEGIN
		Err:=SerReset(SerRefOut, bauds);
		Err:=SerReset(SerRefIn,  bauds);
		WITH Flags DO
		  BEGIN
			fXon:=0;
			finX:=0;
			xOn:=chr(19);
			xOff:=chr(17);
			fcts:=0;
			errs:=0;
			evts:=0;
		  END;
		Err:=SerHShake(SerRefOut, flags);
		Err:=SerSetBuf(SerRefIn,TheSerBuf,xSerBufSz);
	END;
END;


{ teste si un port série est libre ou non }

FUNCTION PortFree(whichport:CHAR):BOOLEAN;

VAR
	Device: DCtlHandle;
	Used: BOOLEAN;
	
BEGIN
	IF ArbitratorPresent THEN
		PortFree := TRUE
	ELSE
	BEGIN
		PortFree := false;
		
		CASE whichport OF
		
		'A':	{ modem }
			Used := DriverIsOpen(GetDrvrRefNum('.AIn')) |
				 	DriverIsOpen(GetDrvrRefNum('.AOut'));
	
		'B':	{ imprimante / AppleTalk }
			Used := DriverIsOpen(GetDrvrRefNum('.BIn')) |
				 	DriverIsOpen(GetDrvrRefNum('.BOut'));
		
		END;	{ CASE }
		IF Used THEN
			IF BackFlag THEN	{ Tâche de fond active ? }
				Used := TRUE
			ELSE
				Used := (MyAlert(rALRTPortUsed)=1);
				
		PortFree := NOT Used;
	END;
END;


PROCEDURE InitSerial(newPort:Char);
    VAR Err	 : OsErr;
        flags	 : SerShk;
        WhichPort: SPortSel;
		
BEGIN
	IF Inited THEN StopIO;	{ on ferme l'ancien port si besoin }
	IF NOT PortFree(newPort) THEN
	BEGIN	{ le port demandé est utilisé ! -> on active l'émulateur }
		EmulFlag := TRUE;
		EXIT(InitSerial);
	END;
	
    CASE newPort OF
     'A': BEGIN
               Err := OpenDriver('.AIn',SerRefIn);
               IF Err=NoErr THEN Err := OpenDriver('.AOut',SerRefOut);
          END;
     'B': BEGIN
               Err := OpenDriver('.BIn',SerRefIn);
               IF Err=NoErr THEN Err := OpenDriver('.BOut',SerRefOut);
          END;
    END;
	
	IF Err = NoErr THEN
	BEGIN
	  IF NOT DemoRSflag THEN
	  BEGIN
		  Setspeed(baud19200+data8+stop10+noparity);		{ MODEM }
		  Runflag := TRUE;
		  WordAlign;	{ on identifie le modem }
		  IF SnFlag THEN	{ Modem absent ! }
		  BEGIN
		  	StopIO;
			SnFlag := FALSE;
			EmulFlag := TRUE;
			Err := MyAlert(rALRTNoModem);
		  END;
		  RunFlag := FALSE;
	  END
	  ELSE
		  Setspeed(baud1200+data7+stop10+evenparity);		{ SERIAL }
	  theSPort:= newPort;
	  Inited := TRUE;		{ tout est Ok, on a ouvert le port }
	END
	ELSE
	BEGIN
		Err := MyAlert(rALRTCantOpen);
		EmulFlag := TRUE;		{ on n'a pas pu ouvrir le port ! }
		SnFlag := FALSE;
	END;
END;


PROCEDURE StopIO;
     VAR Err: OSErr;
BEGIN
	Err := CloseDriver(SerRefin);
	Err := CloseDriver(SerRefOut);
	Inited := FALSE;
END;


PROCEDURE CheckButton;
     VAR theEvent: EventRecord;
		 
BEGIN
	IF (EventAvail(everyEvent,theEvent) & (theEvent.what<>nullEvent))
	   | ((MonMain<>Nil) & RunFlag & ((Tickcount>NextEvent) | Button)) THEN
	BEGIN
		MonCallProc(MonMain);
		NextEvent := TickCount+60;
	END;
END;

PROCEDURE ResetBuffer;
BEGIN
     SetHandleSize(TheBuffer,0);
END;


PROCEDURE PAddBuffer(P: Ptr; pLen: Longint);
     VAR Len: Longint;
BEGIN
     Len:=GetHandleSize(TheBuffer);
     SetHandleSize(TheBuffer,Len+pLen);
     BlockMoveData(p,Ptr(Ord4(TheBuffer^)+Len),pLen);
END;


PROCEDURE AddBuffer(P: PStr255);
BEGIN
     PAddBuffer(Ptr(Ord4(P)+1),Length(P^));
END;

PROCEDURE CarPrint(TheChar: Char);
BEGIN
     PAddBuffer(Ptr(Ord4(@TheChar)+1),1);
END;

PROCEDURE FlushBuffer;
     VAR Err: OsErr; Count: Longint;
BEGIN
     Count:=GetHandleSize(TheBuffer);
	 IF Count=0 THEN EXIT(FlushBuffer);
	 IF (NOT EmulFlag) | DemoRSflag THEN
	 BEGIN	{•••• Modem ou Serial ••••}
		Err:=FSWrite(SerRefOut,Count,TheBuffer^);
		ResetBuffer;
		IF (NOT EmulFlag) & (ProtCount>1800) THEN {•••• Prot. sur les modems ••••}
		BEGIN
			ProtCount:=0;
			WordAlign;
			IF SnFlag THEN
				 BreakCount:=BreakCount+1
			ELSE BreakCount:=0;
			IF BreakCount>100 THEN TheModNumber:=TickCount MOD 8;
		END;
	 END
	 ELSE
	 BEGIN	{•••• Emulateur ••••}
		EM_Write(TheBuffer);
		ResetBuffer;
	 END;
END;


PROCEDURE FlushIn;

VAR
	Count, ToRead	: Longint;
	TheChar			: Integer;
	Err				: OSErr;
	TheCars			: Str255;
	
BEGIN
	IF (NOT EmulFlag) | (DemoRSflag) THEN
	BEGIN	{•••• Modem ou Serial ••••}
    REPEAT
		Count:=0;
		Err:=SerGetBuf(SerRefIn,Count);
		IF (Err=NoErr) & (Count<>0) THEN
		BEGIN
			ToRead:=1;
			Err:=FSRead(SerRefIn,ToRead,Ptr(Ord4(@TheChar)+1));
		END;
	UNTIL Count=0;
	END
	ELSE
	BEGIN	{•••• Emulateur ••••}
		theCars := EM_Read;
	END;
END;


{$IFC SERIAL}
{•••• Serial ••••}
PROCEDURE RS_Read(TheCars: Handle);
	CONST
		 ConnFrame	=	67; 	{ Répétition }
         SEP	    =   19;
		 
     VAR Count, ToRead	 : Longint;
         Err		 	 : OSErr;
		 TheCarPtr		 : Ptr;
		 
BEGIN
	 SetHandleSize(TheCars,0);
     REPEAT
          Count:=0;
          Err:=SerGetBuf(SerRefIn,Count);
          IF Count<>0 THEN
          BEGIN
		  	   count:=GetHandleSize(TheCars);
	 		   SetHandleSize(TheCars,count+1);
               ToRead:=1;
			   TheCarPtr:=Ptr(Ord4(TheCars^)+count);
               Err:=FSRead(SerRefIn,ToRead,TheCarPtr);
			   {WWriteCh(chr(TheCarPtr^));
			   TheCarPtr:=Ptr(Ord4(TheCars^)+count);}
			   IF TheCarPtr^=SEP THEN { connexion ...?}
			   BEGIN
		  	   		count:=GetHandleSize(TheCars);
	 		   		SetHandleSize(TheCars,count+1);
               		ToRead:=1;
			   		TheCarPtr:=Ptr(Ord4(TheCars^)+count);
               		Err:=FSRead(SerRefIn,ToRead,TheCarPtr);
			   		{WWriteCh(chr(TheCarPtr^));
			   		TheCarPtr:=Ptr(Ord4(TheCars^)+count);}
					IF TheCarPtr^=ConnFrame THEN
					BEGIN
						DemoConnect:=NOT DemoConnect;
	 		   			SetHandleSize(TheCars,0);
						{ rem on envoie la sequence d'echappement pour echo off }
						IF DemoConnect THEN
						BEGIN
							ResetBuffer;
							CarPrint(' ');
							CarPrint(chr(12));
							CarPrint(' ');
							CarPrint(chr(12));
							CarPrint('D');
							CarPrint('e');
							CarPrint('m');
							CarPrint('o');
							CarPrint(chr(27));
							CarPrint(';');
							CarPrint(chr(96));
							CarPrint('Z');
							CarPrint('Q');
							FlushBuffer;
						END ELSE
						BEGIN
							ResetBuffer;
							CarPrint(DC4);
							FlushBuffer;
						END;
					END;
			   END;
			   count:=1;
          END;
     UNTIL Count=0;
	 IF NOT DemoConnect THEN
	 	SetHandleSize(TheCars,0);
END;
{$ENDC}


PROCEDURE TestConnect(VAR Rep: Boolean);

VAR	Repi	:	Integer;
	TheCars	:	Handle;

BEGIN
	IF NOT EmulFlag THEN Rep:=false
	ELSE
{$IFC SERIAL}
	  IF DemoRSflag THEN
	  BEGIN
		  IF NOT DemoConnect THEN
		  BEGIN
			  TheCars:=NewHandle(0);
			  RS_Read(TheCars);
			  DisposHandle(TheCars);
		  END;
		  Rep:=DemoConnect;
	  END
	  ELSE
{$ENDC}
	  BEGIN
		  EM_Ctrl(0,repi);
		  rep:=repi=1;
		  DemoConnect:=Rep;
	  END;
END;



{•••• Générale pour Modem, Emul, Serial ••••}
PROCEDURE AsRead(VAR ThePrompt, TheBuffer: str255; TimeLimit: Longint;
                 SkipEnt: Boolean);
				 
{•••• Modem ••••}
PROCEDURE PaqAsRead(VAR TheBuffer: Str255; TimeLimit: Longint);
     VAR  Err	    : OSErr;
          Index	    : Integer;
          XTimeLimit: Longint;
          SyncChar  : Integer;
          Count	    : Longint;
          ToRead    : Longint;
          termine   : boolean;
BEGIN
     CurTCB^.Error:=0;
     XTimeLimit:=TickCount+TimeLimit;
     Termine:=False;
     SyncChar:=0;
     TheBuffer:='';

     { synchro sur debut de paquet }
     REPEAT
          Count:=0;
          Err:=SerGetBuf(SerRefIn,Count);
          IF Count>2 THEN
          BEGIN
               ToRead:=1;
               Err:=FSRead(SerRefIn,ToRead,Ptr(Ord4(@SyncChar)+1));
               Termine:=SyncChar=(192+TheModNumber);
               { XTimeLimit:=TickCount+TimeLimit; }
          END { else CheckButton} ;
     UNTIL Termine OR (XTimeLimit<TickCount) OR (NOT RunFlag);

     IF (NOT Termine)  OR (NOT RunFlag) THEN
     BEGIN
          CurTCB^.Error:=ErrTime;
          EXIT(PaqAsRead);
     END;

     Termine:=False;
     Index:=1;
     XTimeLimit:=TickCount+TimeLimit;
     { recup jusqu'a fin de paquet }
     REPEAT
          Count:=0;
          Err:=SerGetBuf(SerRefIn,Count);
          IF Count>0 THEN
          BEGIN
               ToRead:=1;
               Err:=FSRead(SerRefIn,ToRead,Ptr(Ord4(@SyncChar)+1));
               Termine:=SyncChar=128;
               IF NOT Termine THEN
               BEGIN
                    TheBuffer[Index]:=chr(SyncChar);
                    Index:=Index+1;
                    XTimeLimit:=TickCount+TimeLimit;
               END;
          END { else CheckButton } ;
     UNTIL Termine OR (XTimeLimit<TickCount) OR (NOT RunFlag);

     TheBuffer[0]:=Chr(Index-1);

     IF NOT Termine THEN
     BEGIN
          CurTCB^.Error:=ErrTime;
     END;
END;



{•••• Modem ••••}
PROCEDURE AsReadModem;
     LABEL 0;
     VAR Err	    : OSErr;
         NbCar	    : Integer;
         CCon	    : Char;
         XTimeLimit : Longint;
BEGIN
	XTimeLimit:=TickCount+TimeLimit;
	CurTCB^.Error:=0;

0:
 
	IF Length(ThePrompt)>0 THEN
	BEGIN
		FlushIn;
		AddBuffer(@ThePrompt);
		FlushBuffer;
	END;
 
	PaqAsRead(TheBuffer, 30);
	IF CurTCB^.Error=0 THEN
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
				CurTCB^.Error:=ErrTime;
				TheBuffer:='';
				EXIT(AsRead);
			 END
			ELSE IF CCon='c' THEN
				 BEGIN
					  XTimeLimit:=TickCount+TimeLimit;
				 END;
				 
			IF XTimeLimit<TickCount THEN
				 BEGIN
					CurTCB^.Error:=ErrTime;
					TheBuffer:='';
					EXIT(AsRead);
				 END;
				 
			IF Length(TheBuffer)=0 THEN
			   BEGIN
				   CheckButton;
				   GOTO 0;
			   END;
		END;
	END
	ELSE
	BEGIN
		TheBuffer:='';
		CurTCB^.Error:=ErrTime;
	END;
END;


{•••• Emulateur et Serial ••••}
PROCEDURE AsReadDemo;

     LABEL 0;
     VAR NbCar		: integer;
	 	 Rep		: Boolean;
         XTimeLimit : Longint;
		 TheCars	: Str255;

BEGIN
	XTimeLimit:=TickCount;
	CurTCB^.Error:=0;
	 
0:
	MonCallProc(MonMain);
	TheCars := EM_Read;
	 
	nbcar:=Length(TheCars);
	IF nbcar=0 THEN
	BEGIN
		CheckButton;
		TestConnect(rep);
		IF (abs(XTimeLimit-TickCount)>TimeLimit) OR (NOT Rep) THEN
		BEGIN
			CurTCB^.Error:=ErrTime;
			TheBuffer:='';
			EXIT(AsRead);
		END;
		IF RunFlag THEN GOTO 0;
	END;
	TheBuffer:=concat(TheBuffer,theCars);
	CurTCB^.Error:=0;
END;


BEGIN	{ AsRead pour modem, émulateur et sérial }
	IF EmulFlag THEN AsReadDemo ELSE AsReadModem;
END;


PROCEDURE PaqPrep(VAR TheBuffer: Str255; ComChar: Char);
     VAR nbcar	    : integer;
BEGIN
	IF NOT EmulFlag THEN
	BEGIN	{•••• Modem ••••}
		IF ComChar='!' THEN
		BEGIN
			  ProtCount:=ProtCount+1;
			  IF ProtCount>1800 THEN
			  BEGIN
				  ProtCount:=0;
				  WordAlign;
				  IF SnFlag THEN
					   BreakCount:=BreakCount+1
				  ELSE BreakCount:=0;
				  IF BreakCount>100 THEN TheModNumber:=TickCount MOD 8;
			  END;
		END;
		IF BreakCount>1000 THEN TheModNumber:=TickCount MOD 8;
		nbcar:=Length(TheBuffer);
		IF nbcar>240 THEN nbcar:=240;
		BlockMoveData(Ptr(Ord4(@TheBuffer)+1),Ptr(Ord4(@TheBuffer)+3),nbcar);
		TheBuffer[1]:=chr($C0+TheModNumber);
		TheBuffer[2]:=ComChar;
		TheBuffer[nbcar+3]:=chr($80);
		TheBuffer[0]:=chr(NbCar+3);
	END;
END;


PROCEDURE CheckFilter(VAR TheStr: Str255);
	VAR Str2: Str255;
		i,j: integer;
BEGIN
	i:=0;
	j:=0;
	WHILE i<length(TheStr) DO
	BEGIN
		i:=i+1;
		IF TheStr[i]>=chr(32) THEN
		BEGIN
			j:=j+1;
			Str2[j]:=TheStr[i];
		END
		ELSE
		IF (TheStr[i]=chr(27)) THEN
			CASE TheStr[i+1] OF
			'9': i:=i+2;
			':': i:=i+3;
			';': i:=i+4;
			END
		ELSE
		IF TheStr[i]=ACC THEN
		BEGIN
			  j:=j+1;
			  IF (TheStr[i+1] IN ['A'..'K']) THEN
				 BEGIN
				   CASE TheStr[i+2] OF
				   'a': CASE TheStr[i+1] OF
						'A': Str2[j]:='à';
						'C': Str2[j]:='â';
						END;
				   'e': CASE TheStr[i+1] OF
						'A': Str2[j]:='è';
						'B': Str2[j]:='é';
						'C': Str2[j]:='ê';
						'H': Str2[j]:='ë';
						END;
				   'i': CASE TheStr[i+1] OF
						'C': Str2[j]:='î';
						'H': Str2[j]:='ï';
						END;
				   'o': CASE TheStr[i+1] OF
						'C': Str2[j]:='ô';
						END;
				   'u': CASE TheStr[i+1] OF
						'C': Str2[j]:='û';
						'A': Str2[j]:='ù';
						END;
					OTHERWISE Str2[j]:=TheStr[i+2];
				   END;
				   i:=i+2;
				 END
				 ELSE
				 BEGIN
					CASE TheStr[i+1] OF
					'#': Str2[j]:=chr($83);
					'&': Str2[j]:='#';
					'''': Str2[j]:=chr($86);
					',': Str2[j]:=chr($A7);
					'-': Str2[j]:=chr($A8);
					'.': Str2[j]:=chr($A9);
					'/': Str2[j]:=chr($AA);
					'0': Str2[j]:=chr($A1);
					'1': Str2[j]:=chr($B1);
					'8': Str2[j]:=chr($D6);
					'<': Str2[j]:=chr($AB);
					'=': Str2[j]:=chr($AC);
					'>': Str2[j]:=chr($AD);
					'j': Str2[j]:=chr($CE);
					'z': Str2[j]:=chr($CF);
					OTHERWISE
						Str2[j]:=' ';
					END;
					i:=i+1;
				END;
		END
		ELSE
		{ caractères de contrôles }
		BEGIN
			j:=j+1;
			Str2[j]:=TheStr[i];
		END;
	END;
	Str2[0]:=chr(j);
	TheStr:=Str2;
END;



FUNCTION Zinput(VAR Str1: Str255; PosX,PosY,MaxLen, Attribs: Integer;
                MaxTime: Longint; BackCar: Char; ReqInput: Boolean): Integer;

FUNCTION ZInputModem:INTEGER;

VAR Termine  : boolean;
	Requete  : Str255;
	nbcar	  : Integer;
	i		  :	Integer;

     FUNCTION GetVChar: integer;
          VAR  Count    : Longint;
               Err: OSErr;
     BEGIN
		 IF Length(Str1)>=2 THEN
         BEGIN
           IF Str1[Length(Str1)-1]=SEP THEN	{ SEP/xx }
           BEGIN
              CASE Str1[Length(Str1)] OF
               'A': GetVChar:=CEnvoi;
               'B': GetVChar:=CRetour;
               'C': GetVChar:=CRepetition;
               'D': GetVChar:=CGuide;
               'E': GetVChar:=CAnnulation;
               'F': GetVChar:=CSommaire;
               'G': GetVChar:=CCorrection;
               'H': GetVChar:=CSuite;
               OTHERWISE
                    GetVChar:=CAutre;
              END;
              Delete(Str1,Length(Str1)-1,2);
           END ELSE
           IF Str1[Length(Str1)]=chr(13) THEN	{ xx/CR (Télétel) }
           BEGIN
			 CASE Str1[length(str1)-1] OF
				  'A': GetVChar:=CEnvoi;
				  'B': GetVChar:=CRetour;
				  'C': GetVChar:=CRepetition;
				  'D': GetVChar:=CGuide;
				  'E': GetVChar:=CAnnulation;
				  'F': GetVChar:=CSommaire;
				  'G': GetVChar:=CCorrection;
				  'H': GetVChar:=CSuite;
				  OTHERWISE GetVChar := cENVOI;
			 END;
			 IF Str1[length(str1)-1] IN ['A'..'H'] THEN Delete(Str1,Length(Str1)-1,2)
			 ELSE Delete(Str1,Length(Str1),1);
		   END;
         END ELSE
         IF Str1[Length(Str1)]=chr(13) THEN
         BEGIN
            GetVChar:=CEnVoi;
            Str1:='';
         END
         ELSE GetVChar:=CAutre;
     END;


BEGIN
	IF NOT ReqInput THEN
    BEGIN     { saisie de zone }
		{ envoyer la commande de saisie de zone }
		Requete:='XYLLAAER';
		IF MaxLen>240 THEN MaxLen:=240;
		Requete[1]:=Chr($40+PosX);
		Requete[2]:=Chr($40+PosY);
		Requete[3]:=Chr($40+MaxLen DIV 16);
		Requete[4]:=Chr($40+MaxLen MOD 16);
		Requete[5]:=Chr($40+Attribs DIV 16);
		Requete[6]:=Chr($40+Attribs MOD 16);
		IF EchoFlag THEN Requete[7]:=chr($7F) ELSE Requete[7]:='*';
		IF EchoFlag THEN Requete[8]:='.' ELSE Requete[8]:='X';
		NbCar:=Length(Str1);
		IF NbCar>240 THEN NbCar:=240;
		BlockMoveData(Ptr(Ord4(@Str1)+1),Ptr(Ord4(@Requete)+9),NbCar);
		Requete[0]:=Chr(NbCar+Length(Requete));
		PaqPrep(Requete,'Z');
	END
	ELSE      { saisie Input }
	BEGIN
		{ envoyer la commande d'input }
		Requete:='E';
		IF EchoFlag THEN Requete[1]:=chr($7F) ELSE Requete[1]:='*';
		PaqPrep(Requete,'U');
	END;

	AddBuffer(@Requete);
	FlushBuffer;

	{ preparer la requete de demande d'etat de saisie }
	Requete:='';
	PaqPrep(Requete,'?');

	Termine:=False;
	REPEAT
		ASRead(Requete,Str1,MaxTime,true);
		IF CurTCB^.Error<>0 THEN Termine:=True
		ELSE
		BEGIN
			CurTCB^.Error:=GetVChar;
			Termine:=True;
			CheckFilter(Str1);
		END;
	UNTIL termine;

	ZinputModem:=CurTCB^.Error;
END;

FUNCTION ZinputDemo: Integer;

VAR	Termine  	: boolean;
	Requete  	: Str255;
	StrIn		: Str255;
	nbcar	  	: Integer;
	i		  	: Integer;
	k			: Integer;
	LCpt		: Integer;
	ResIn		: Integer;

    FUNCTION GetVChar: integer;
	LABEL 0;
    VAR	Count	: Longint;
		Err		: OSErr;
		
	BEGIN
		0:
		IF Length(StrIn)>=2 THEN
		BEGIN
			IF StrIn[1]=SEP THEN
			BEGIN
				CASE StrIn[2] OF
					'A': GetVChar:=CEnvoi;
					'B': GetVChar:=CRetour;
					'C': GetVChar:=CRepetition;
					'D': GetVChar:=CGuide;
					'E': GetVChar:=CAnnulation;
					'F': GetVChar:=CSommaire;
					'G': GetVChar:=CCorrection;
					'H': GetVChar:=CSuite;
					OTHERWISE
					BEGIN
						GetVChar:=CAutre;
						EXIT(GetVChar);
					END
				END;	{ CASE }
				Delete(StrIn,1,2);
			END
			ELSE
			BEGIN
				CASE StrIn[1] OF
					RC:  		GetVChar:=CEnvoi;
					chr(8): 	GetVChar:=CCorrection;
					chr(9): 	GetVChar:=CSuite;
					LF:
					BEGIN
						Delete(StrIn,1,1);
						GOTO 0;
					END;
					OTHERWISE
					BEGIN
						GetVChar:=CAutre;
						EXIT(GetVChar);
					END;
				END;	{ CASE }
				Delete(StrIn,1,1);
			END;
		END
		ELSE
		BEGIN
			CASE StrIn[1] OF
				RC:		GetVChar:=CEnvoi;
				chr(8): GetVChar:=CCorrection;
				chr(9): GetVChar:=CSuite;
				LF:
				BEGIN
					Delete(StrIn,1,1);
					GetVChar:=CIgnore;
				END;
				OTHERWISE
				BEGIN
					GetVChar:=CAutre;
					EXIT(GetVChar);
				END;
			END;
			Delete(StrIn,1,1);
		END;
	END;	{ GetVChar }

	PROCEDURE AffTheAtts;
	
	BEGIN
		IF ReqInput=FALSE THEN
		BEGIN
			{ position }
			StrIn:='	   ';
			StrIn[1]:=US;
			StrIn[2]:=chr($40+Posx+(Length(Str1) DIV 40));
			StrIn[3]:=chr($40+PosY+(Length(Str1) MOD 40));
			StrIn[4]:=DC1;
			AddBuffer(@StrIn);
		
			{ ========= affichage des attributs ========= }
	
			{ ***** Couleur ***** }
	
			k:=BAND(Attribs,7);
			IF k<>7 THEN	  { autre que blanc }
			BEGIN
				CASE k OF
					1: k:=4;
					2: k:=1;
					3: k:=5;
					4: k:=2;
					5: k:=6;
					6: k:=3;
				END;
				StrIn:='  ';
				StrIn[1]:=ESC;
				StrIn[2]:=chr($40+k);
				AddBuffer(@StrIn);
			END;
	
			{ ***** Taille ***** }
	
			k:=BSR(Attribs,6);
			k:=BAND(k,1);
			IF k<>0 THEN	  { autre que taille normale }
			BEGIN
				StrIn:='  ';
				StrIn[1]:=ESC;
				StrIn[2]:=chr($4C+k);
				AddBuffer(@StrIn);
			END;
		  
			{ ***** Inversion ***** }
	
			k:=BAND(BSR(Attribs,5),1);
			IF k<>0 THEN	  { inversion }
			BEGIN
				StrIn:='  ';
				StrIn[1]:=ESC;
				StrIn[2]:=chr($5D);
				AddBuffer(@StrIn);
			END;
	
			{ ***** Clignotement ***** }
	
			k:=BAND(BSR(Attribs,4),1);
			IF k<>0 THEN	  { Clignotement }
			BEGIN
				StrIn:='  ';
				StrIn[1]:=ESC;
				StrIn[2]:=chr($48);
				AddBuffer(@StrIn);
			END;
		END		{ IF ReqInput=FALSE }
		ELSE
			CarPrint(DC1);	{ cas de l'INPUT }

	END;	{ AffTheAtts }
	
BEGIN

	 IF length(Str1)>MaxLen THEN
	 	Str1[0]:=chr(MaxLen);
		
	 AffTheAtts;
	 
	 Requete:='';
	 StrIn:='';
     Termine:=False;
	 Lcpt:=length(Str1);
	 FlushBuffer;
	 
     REPEAT
        ASRead(Requete,StrIn,MaxTime,true);
        IF (CurTCB^.Error<>0) OR (NOT RunFlag) THEN
		BEGIN
			 ResIn:=CurTCB^.Error;
             Termine:=True;
		END
        ELSE
        BEGIN
		   		WHILE (length(StrIn)>0) AND (NOT termine) DO
				BEGIN
                   ResIn:=GetVChar;
				   CASE ResIn OF
				   
				     CAutre:
					 	BEGIN
							IF length(Str1)<MaxLen THEN
							BEGIN
								Str1[0]:=succ(Str1[0]);
								Str1[length(Str1)]:=StrIn[1];
								IF EchoFlag THEN
									CarPrint(StrIn[1])
								ELSE
									CarPrint('*');
								LCpt:=LCpt+1;
							END;
							Delete(StrIn,1,1);
						END;
						
					 CCorrection:
					 	BEGIN
							IF MaxLen=0 THEN
								Termine:=True
							ELSE
							IF (LCpt>0) AND (LCpt<=MaxLen) THEN
							BEGIN
								Delete(Str1,Length(Str1),1);
								CarPrint(BS);
								IF ReqInput THEN
									CarPrint(' ')
								ELSE
								IF EchoFlag THEN
									CarPrint('.')
								ELSE
									CarPrint(BackCar);
								CarPrint(BS);
							END;
							IF LCpt>0 THEN LCpt:=LCpt-1;
						END;
						
					 CAnnulation:
					 	BEGIN
							IF (MaxLen=0) OR (Str1='*') THEN
								Termine:=True
							ELSE
							BEGIN
								Str1:='';
								IF NOT ReqInput THEN
								BEGIN
									AffTheAtts;
									FOR i:=1 TO MaxLen DO
									IF EchoFlag THEN
										CarPrint('.')
									ELSE
										CarPrint(BackCar);
									AffTheAtts;
								END
								ELSE
								FOR i:=1 TO LCpt DO
								BEGIN
									CarPrint(BS);
									CarPrint(' ');
									Carprint(BS);
								END;
								LCpt:=0;
								StrIn:='';
							END;
						END;
						
					 CIgnore: ;
					 
					 OTHERWISE
					 BEGIN
                   		Termine:=True;
						CheckFilter(Str1);
					 END;
					END; { case }
				END; { while }
				FlushBuffer;
           END; { if }
     UNTIL termine OR (NOT runflag);

     ZinputDemo:=ResIn;
	 CurTCB^.Error:=ResIn;
END;


BEGIN	{•••• ZInput général pour Modem, Emul, Sérial ••••}
	IF EmulFlag THEN ZInput := ZInputDemo ELSE ZInput := ZInputModem;
END;


PROCEDURE StartDataPaq;
     VAR Chr1: Char;
BEGIN
	IF NOT EmulFlag THEN
	BEGIN
		Chr1:=Chr(192+TheModNumber); {modem 1}
		PAddBuffer(Ptr(Ord4(@Chr1)+1),1);
		Chr1:='!';
		PAddBuffer(Ptr(Ord4(@Chr1)+1),1);
		ProtCount:=ProtCount+1;
	END;
END;


PROCEDURE EndDataPaq;
     VAR Chr1: Char;
BEGIN
	IF NOT EmulFlag THEN
	BEGIN
		Chr1:=Chr(128);
    	PAddBuffer(Ptr(Ord4(@Chr1)+1),1);
	END;
END;


PROCEDURE AddDataPaq(P: PStr255);

BEGIN
	IF NOT EmulFlag THEN StartDataPaq;
	AddBuffer(P);
	IF NOT EmulFlag THEN EndDataPaq;
END;


PROCEDURE SwapBits(VAR K: longint; Bit1,Bit2: integer);
     VAR FBit1,FBit2: Boolean;
BEGIN
	FBit1:=BTst(K,Bit1);
	FBit2:=BTst(K,Bit2);
	IF FBit1 THEN BSet(K,Bit2) ELSE BClr(K,Bit2);
	IF FBit2 THEN BSet(K,Bit1) ELSE BClr(K,Bit1);
END;


PROCEDURE WordAlign;

LABEL 0;

VAR  Key,
	 keyB,
	 IdC		: longint;
	 Str1,
	 Str2		: str255;
	 i			: integer;
	 Retrys		: integer;
	 
BEGIN
	IF BackFlag | EmulFlag THEN
	BEGIN
		SnFlag:=False;
		EXIT(WordAlign);
	END;
	retrys:=0;

	REPEAT
		retrys:=retrys+1;
		{ test du numero de serie du modem }
		Key:=BitXor(BRotL(TickCount,BAnd(TickCount,$0F)),$47DA2E51);
		Str1:='@@@@@@@@';
		FOR i:=1 TO 8 DO
			 Str1[i]:=chr($40+Bitand(BSR(Key,32-(i*4)),$0F));
		PaqPrep(Str1,'0');
		AsRead(Str1,Str2,120,false);
		SnFlag:=False;

		{   #### test erreur  ####    }
		IF CurTCB^.Error<>0 THEN
		BEGIN
			SnFlag:=True;
			GOTO 0;
		END;

		KeyB:=0;
		FOR i:=1 TO 8 DO
			 KeyB:=Bitor(KeyB,BSL(Bitand(Ord(Str2[1+i]),$0F),32-(i*4)));
		{ keyB est la clé de cryptage }

		{Break;}
		Idc:=0;
		FOR i:=1 TO 8 DO
			 Idc:=Bitor(Idc,BSL(Bitand(Ord(Str2[9+i]),$0F),32-(i*4)));
			 
		{Break;}
		{ Idc est crypte avec ma cle }
		{ je triture ma clé }
		Key:=BitXor(Key,$A720351D);
		i:=BitAnd(BSR(Key,16),31)+1;
		Key:=BRotL(Key,i);
		SwapBits(Key,3,15);
		SwapBits(Key,7,13);
		SwapBits(Key,10,28);
		SwapBits(Key,22,31);
		Idc:=BitXOr(Idc,Key);
		{Break;}
		SnFlag:=Idc<>Bitxor(MySn^^.TheSn,MySn^^.TheMask);
		IF SnFlag THEN
			 GOTO 0;

		{ j'encrypte avec la clé qu'on m'a donné }
		Key:=KeyB;
		{ je triture ma clé }
		Key:=BitXor(Key,$A720351D);
		i:=BitAnd(BSR(Key,16),31)+1;
		Key:=BRotL(Key,i);
		SwapBits(Key,3,15);
		SwapBits(Key,7,13);
		SwapBits(Key,10,28);
		SwapBits(Key,22,31);
		Key:=BitXOr(BitXOr(MySn^^.TheSn,MySn^^.TheMask),Key);

		{break;}
		Str1:='@@@@@@@@';
		FOR i:=1 TO 8 DO
			 Str1[i]:=chr($40+Bitand(BSR(Key,32-(i*4)),$0F));
		{break;}

		{Writeln('paquet 2: 2',Str1);}
		PaqPrep(Str1,'2');
		AddBuffer(@Str1);
		FlushBuffer;
		0:
	UNTIL (NOT SnFlag) OR (Retrys>=5);
END;


PROCEDURE WordEdAlign;
BEGIN
	IF BackFlag THEN
	BEGIN
		EmulFlag := TRUE;	{•••• serveur en background ••••}
		SnFlag:=False;
		EXIT(WordEdAlign);
	END;
	
	RunFlag:=True;
	EmulFlag := FALSE;
	WordAlign;
	RunFlag:=False;
	SetCursor(Arrow);
	IF SnFlag THEN
	BEGIN
	 	EmulFlag := TRUE;	{•••• pas de modem en ligne ••••}
		SnFlag := FALSE;
	END;
END;


END. { Implementation }
