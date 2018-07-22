UNIT DragsterInitProt;

{$SETC DEBUG=FALSE}
{$IFC UNDEFINED DEMO}
{$SETC DEMO=FALSE}
{$ENDC}

INTERFACE

VAR
	NbLocal			: integer;	{ nombre de voies AppleTalk }
	NbLocal2		: integer;
	NbLocalBad	: integer;
	NbLocalBad2	: integer;
	JCAFlag			: integer;
	NbX25key		: integer;	{ nb de voies X25 provenant de la clé }
	
{$IFC DEMO=FALSE}	
	PROCEDURE GetNbLocal;
	
{ Fonctions de la libraire Eve… }

	FUNCTION EVEReset:INTEGER;
	FUNCTION EVEStatus:INTEGER;
	FUNCTION EVEEnable(VAR PASSWORD:STRING):INTEGER;
	FUNCTION EVEReadCTR:INTEGER;
	FUNCTION EVEChallenge(LOCK,VALUE:INTEGER):INTEGER;
	FUNCTION EVEReadGPR(GPR:INTEGER):INTEGER;
	FUNCTION EVEWriteGPR(GPR,VALUE:INTEGER):INTEGER;
	FUNCTION EVESetLock(LOCK,CHALLANGE,RESPONSE:INTEGER):INTEGER;
{$ENDC}

IMPLEMENTATION

USES MemTypes, ToolIntf, OsIntf, Packages;

{ Fonctions de la libraire Eve… }

	FUNCTION EVEReset : INTEGER ; EXTERNAL ;
	FUNCTION EVEStatus : INTEGER ; EXTERNAL ;
	FUNCTION EVEEnable(VAR PASSWORD:STRING) : INTEGER ; EXTERNAL;
	FUNCTION EVEReadCTR : INTEGER ; EXTERNAL ;
	FUNCTION EVEChallenge(LOCK,VALUE : INTEGER) : INTEGER ; EXTERNAL ;
	FUNCTION EVEReadGPR(GPR : INTEGER) : INTEGER; EXTERNAL ;
	FUNCTION EVEWriteGPR(GPR,VALUE : INTEGER) : INTEGER ; EXTERNAL ;
	FUNCTION EVESetLock(LOCK,CHALLANGE,RESPONSE:INTEGER) : INTEGER ; EXTERNAL ;
	
PROCEDURE GetNbLocal;

	TYPE
		Str16 = STRING[16];
		
	VAR
		theMdp		: STRING;
		i					:INTEGER;
		tempNb		: INTEGER;
		tempRes		: Handle;
		Err				: Integer;
		
		PROCEDURE Mdp;
		
			FUNCTION Dec(S:Str16):Str16;
			
			VAR	j: INTEGER;
			
			BEGIN
				FOR j := 1 TO 16 DO
					Dec[17-j] := CHR(BXOR(ORD(S[j]),(1-BAND(j+i,1))*$20));
				Dec[0]:=CHR(16);
			END;
			
		BEGIN
			CASE BAND(i,7) OF 
				0:	theMdp := Dec('XDegLaPeISdLMeZs');
				1:	theMdp := Dec('HMaRuMSNeqaTgWZS');	{ read password }
				2:	theMdp := Dec('XDegLaPeISdLMeZs');
				3:	theMdp := Dec('FcEiFmWnBAOrDshu');
				4:	theMdp := Dec('oTcrALdlEoDnJtrD');
				5:	theMdp := Dec('HMaRuMSNeqaTgWZS');	{ read password }
				6:	theMdp := Dec('LQplkDtRUNbkSryE');
				7:	theMdp := Dec('oTcrALdlEoDnJtrD');
			END;
		END;
		
		PROCEDURE GetIt(VAR nb:INTEGER);
		
		VAR	Temp:INTEGER;
		
		BEGIN
			nb := INTEGER(i<4) * (INTEGER(ORD(theMdp[3]))*16+INTEGER(ORD(theMdp[10]))*256)
						+ 16*INTEGER(i>4)*(ORD(theMDP[12])*16+ORD(theMDP[3]));
			nb := EVEChallenge(1,nb);
			CASE i OF
				0,2:	Nb := EVEReadGPR(i);
				1,3:	{ 3= bidon }
				BEGIN
					IF nb = ORD(theMdp[14])+ORD(theMdp[5]) THEN	{ NbLocal réel }
					BEGIN
						JCAFlag := EVEReadGPR(2);
						Temp := EVEReadGPR(i);
						IF Temp<>0 THEN Temp := BXOR(Temp,nb*256+nb);
						NbX25Key := BAND(127,temp);	{ nb de cv X25 }
						nb := BAND(63,BSR(BXOR(EVEReadGPR(i),nb*256+nb),10));
					END;
				END;
				5,7:	{ 7= bidon }
				BEGIN
					nb := EVEReadGPR(1);					{ NbLocal2 codé }
					IF NB=0 THEN nb:=-1;	{ cas de MacARBO Junior: GPR=0 }
				END;
				4,6:	Nb := BXor(EveReadGpr(1),nblocal+256*nb);
			END;
		END;
		
	{ Challenge#1= 30832 }
	{ Lock#1= 149 }
	{ GPR#1 XOR 38293 = Bits15..10 = NbVoies ADSP
		Bits 9..7=Nb liaison 4D
		Bits 6..0=Nb voies X25
	}
	
	{ Challenge#2= }
	{ Lock#2= }
	
	BEGIN
		TempRes := GetResource('EvE ',256);
{$IFC DEBUG}
		IF ResError<>NoErr THEN DebugStr(concatnum('GetResource=',ResError));
{$ENDC}
		NbLocal:=0;
		NbX25Key := 0;
		Err:= EVEStatus;
{$IFC DEBUG}
		IF Err<>NoErr THEN DebugStr(concatnum('EVEStatus=',Err));
{$ENDC}
		IF Err=0 THEN	{ on passe en niveau 0 }
		BEGIN
			Err := EVEReset;
			FOR i := 0 TO 7 DO
			BEGIN
				Mdp;
				Err := EVEEnable(theMDP);
				CASE i OF
					1:	GetIt(NbLocal);
					3:	GetIt(NbLocalBad);	{ bidon }
					5:	GetIt(NbLocal2);
					7:	GetIt(NbLocalBad2);	{ bidon }
				END;
			END;
		END;
	END;
END.	{ of UNIT }