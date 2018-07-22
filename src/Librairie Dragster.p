{
	File:		Librairie Dragster.p

	Contains:	Librairie pour accéder à Dragster depuis une Appl. MPW Pascal.

	Written by:	Christian

	Copyright:	1989 Ch. QUEST pour JCA Télématique

	Change History:

		2/10/89 	CQ		Ajout de nouvelles fonctions
		14/09/89	CQ		Correction de DrgInit (bug dans RechDrag corrigé)

}

UNIT Dragster;

INTERFACE

USES	MemTypes, QuickDraw, OSIntf, ToolIntf, ADSP, SysEqu,
			{$U $$Shell(PUtilities) } Utilities;
			
{$I DragsterTCB.p}


CONST
	DrgNoErr = 0;
	DrgMemErr = -1;
	DrgNotFound = 1;

TYPE
	IPtr	= ^INTEGER;
	ChPtr	= ^Str255;
	LIPtr	= ^LONGINT;

	DrgLinkHndl  = ^DrgLinkPtr;
	DrgLinkPtr  = ^DrgLinkRec;		
	DrgLinkRec  = RECORD	
							NbVoies   : Integer;    { voies normales }
							NbAux     : Integer;    { taches annexes }
							DrgFlagPtr:	IPtr;       { flag de réentrance }
							ThePtrs   :	ARRAY[1..MaxTasks+MaxAux] OF TPtr;
						 END;

	DrgStatusRec = RECORD
		Conflag : BOOLEAN;            { indique si la voie est connectée }
		ModemNumber : INTEGER;        { numéro de voie du modem }
		StatusWord : INTEGER;         { status de la tache (voir plus haut) }
		ScreenNumber : INTEGER;       { numéro de l'écran courant }
		LineNumber : INTEGER;         { numéro de ligne courante }
		InstructionNumber : INTEGER;  { numéro d'instruction courante }
	END;
	
							 
FUNCTION  DrgPresent:BOOLEAN;

FUNCTION	DrgInit:DrgLinkHndl;

FUNCTION  DrgGetString(DrgLink : DrgLinkHndl ;Tache:INTEGER ;Offset : LONGINT ) : Str255;

PROCEDURE DrgSetString(DrgLink : DrgLinkHndl ;Tache:INTEGER ;Offset : LONGINT;laChaine:Str255 );

FUNCTION  DrgGetNum(DrgLink : DrgLinkHndl ;Tache:INTEGER ;Offset : LONGINT ) : LONGINT;

PROCEDURE DrgSetNum(DrgLink : DrgLinkHndl ;Tache:INTEGER ;Offset,laVar:LONGINT );

FUNCTION  DrgConnected(DrgLink : DrgLinkHndl ;Tache: INTEGER):BOOLEAN;

FUNCTION  DrgStatus(DrgLink:DrgLinkHndl; Tache:INTEGER):DrgStatusRec;

FUNCTION DrgGetScreen(DrgLink:DrgLinkHndl;Tache : Integer):Str255;

PROCEDURE DrgDummy;


IMPLEMENTATION

TYPE
	UTable	= ARRAY[0..10000] OF DCtlHandle;
	UPtr	= ^UTable;
	DrvrHdrHdl	= ^DrvrHdrPtr;
	DrvrHdrPtr	= ^DrvrHdr;
	DrvrHdr		= RECORD
		Dummy   : ARRAY[0..8] OF integer;
		DrvrName: str255;
	END;


PROCEDURE DrgDummy;

VAR	H:DrgLinkHndl;
		S:DrgStatusRec;
		
BEGIN
	IF DRGPRESENT AND DrgConnected(H,0) THEN
	BEGIN
		H := DrgInit;
		DrgSetString(H,0,0,DrgGetString(H,0,0));
		DrgSetNum(H,0,0,DrgGetNum(H,0,0));
		S :=DrgStatus(H,0);
		IF DrgGetScreen(H,0)='' THEN;
	END;
END;
		
{$S DrgLink}

{******************** DrgPresent *************************
 *
 * Teste la présence de Dragster en back-ground
 *
 * Utilisation:  IF DrgPresent THEN …
 *
 *********************************************************}

FUNCTION DrgPresent:BOOLEAN;

BEGIN
	DrgPresent:= (RechDrag>0);
END; {of DrgPresent}




{************************** DrgInit ************************
 * Initialisation de la librairie
 *
 * Valeurs rendues par la fonction:
 *
 *  -1 = Impossible de créer le handle pour DrgLink
 *   0 = Tout est Ok
 *   1 = Dragster n'est pas démarré
 *
 ***********************************************************}

FUNCTION DrgInit:DrgLinkHndl;

VAR
	DragNumber	: Integer;
	JumpPtr			: TJumpPtr;
	DrgFlag			: IPtr;
	ThePtr			: TPtr;
	i						: Integer;
	Nb1,Nb2			: Integer;
	DrgLink			: DrgLinkHndl;
	TheUPtr			: UPtr;
	
BEGIN
	DrgInit := NIL;
	Nb1 := 0;
	Nb2 := 0;
	
	DragNumber:= RechDrag;   { on va regarder si dragster est présent }
	
	HANDLE(DrgLink) := NewHandle(sizeof(DrgLinkRec));
	IF DrgLink = NIL THEN EXIT(DrgInit);

	HLock(HANDLE(DrgLink));
	HNoPurge(HANDLE(DrgLink));

	DrgLink^^.NbVoies     := 0;
	DrgLink^^.NbAux       := 0;
	DrgLink^^.DrgFlagPtr  := Nil;

	IF DragNumber<>-1 THEN
	BEGIN
		{ on retrouve le Flag de réentrance et le JumpPtr }
		TheUptr := UPtr(LIPtr(UTableBase)^);
		DrgFlag:=IPtr(Ord4(DrvrHdrHdl(TheUPtr^[DragNumber]^^.DCtlDriver)^)+22+18); {...Ouf!}
		JumpPtr:=TJumpPtr(Ord4(DrgFlag)-4);
		JumpPtr:=TJumpPtr(Ord4(Handle(JumpPtr)^)-20);
	
		FOR i:=1 TO MaxTasks+MaxAux DO DrgLink^^.ThePtrs[i]:=Nil;
	
		Hunlock(Handle(DrgLink));
		IF NOT DrgPresent THEN EXIT(DrgInit);     { Dragster n'est pas démarré ! }
		Hlock(Handle(DrgLink));
		
		DrgFlag^:= 1;                   { on bloque Dragster auparavant }
		ThePtr:= JumpPtr^.TheStPtr;     { on va chopper les TCB }
	
		WITH DrgLink^^ DO
		BEGIN
			DrgFlagPtr:=DrgFlag;
			WHILE ThePtr <> Nil DO        { on parcourt le tableau de TCB }
			BEGIN
				WITH ThePtr^ DO
				BEGIN
					IF TaskNumber<256 THEN
					BEGIN
						ThePtrs[TaskNumber]:=ThePtr;
						Nb1:=Nb1+1;
					END
					ELSE
					IF TaskNumber<300 THEN
					BEGIN
						ThePtrs[MaxTasks+TaskNumber-255]:=ThePtr;
						Nb2:=Nb2+1;
					END;
				END; {of WITH}
				ThePtr:=TPtr(Ord4(ThePtr)+SizeOf(TRecord));
				IF ThePtr^.MagicN1<>$12345678 THEN ThePtr:=Nil;
			END; {of WHILE}
		END; {of WITH}
		DrgFlag^:=0;                { on débloque Dragster }
		DrgLink^^.NbVoies := Nb1;
		DrgLink^^.NbAux := Nb2;
		Hunlock(Handle(DrgLink));
	END;
	DrgInit := DrgLink;
END; {of DrgInit}



{************************ DrgGetString *********************
 *
 * Lecture d'une chaine de car. de Dragster
 *
 ***********************************************************}

FUNCTION DrgGetString(DrgLink : DrgLinkHndl ;Tache:INTEGER ;Offset : LONGINT ) : Str255;

VAR
	laVar          : Str255;
	longueur       : INTEGER;

BEGIN
	DrgGetString := '';
	IF NOT DrgPresent THEN EXIT(DrgGetString);
	IF DrgLink = NIL THEN EXIT(DrgGetString);
	IF Tache > MaxTasks+MaxAux THEN EXIT(DrgGetString);

	Hlock(Handle(DrgLink));
	WITH DrgLink^^ DO BEGIN
		IF Tache = 0 THEN BEGIN         {Variable Partagée}
			DrgFlagPtr^:=1;
			Longueur:=Ord(ChPtr(Ord4(ThePtrs[1]^.PTSVars)+Offset)^[0]);
			BlockMoveData(Ptr(Ord4(ThePtrs[1]^.PTSVars)+Offset),@laVar,ord(Longueur+1));
			DrgFlagPtr^:=0;
		END ELSE BEGIN                  {Variable Locale}
			IF ThePtrs[Tache] = NIL THEN EXIT(DrgGetString);
			DrgFlagPtr^:=1;
			Longueur:=Ord(ChPtr(Ord4(ThePtrs[Tache]^.PTLVars)+Offset)^[0]);
			BlockMoveData(Ptr(Ord4(ThePtrs[Tache]^.PTLVars)+Offset),@laVar,ord(Longueur+1));
			DrgFlagPtr^:=0;
		END;
	END; {of WITH}
	DrgGetString := lavar;
	Hunlock(Handle(DrgLink));
END; {of DrgGetString}



{************************ DrgSetString *********************
 *
 * Ecriture d'une chaine de car. vers Dragster
 *
 ***********************************************************}

PROCEDURE DrgSetString(DrgLink : DrgLinkHndl ;Tache:INTEGER ;Offset : LONGINT;laChaine:Str255 );

VAR
	longueur       : INTEGER;

BEGIN
	IF NOT DrgPresent THEN EXIT(DrgSetString);
	IF DrgLink = NIL THEN EXIT(DrgSetString);
	IF Tache > MaxTasks+MaxAux THEN EXIT(DrgSetString);

	Hlock(Handle(DrgLink));
	WITH DrgLink^^ DO BEGIN
		IF (Tache = 0) THEN BEGIN				{**** Variable Partagée ****}
			DrgFlagPtr^:=1;
			Longueur:=Ord(ChPtr(@laChaine)^[0]);
			BlockMoveData(@laChaine,Ptr(Ord4(ThePtrs[1]^.PTSVars)+Offset),ord(Longueur+1));
			DrgFlagPtr^:=0;
		END	ELSE BEGIN                  {**** Variable Locale ****}
			IF ThePtrs[Tache] = NIL THEN EXIT(DrgSetString);
			DrgFlagPtr^:=1;
			Longueur:=Ord(ChPtr(@laChaine)^[0]);
			BlockMoveData(@laChaine,Ptr(Ord4(ThePtrs[Tache]^.PTLVars)+Offset),ord(Longueur+1));
			DrgFlagPtr^:=0;
		END;
	END;
	Hunlock(Handle(DrgLink));
END; {of DrgSetString}


{************************ DrgGetNum ************************
 *
 * Lecture d'un nombre de Dragster
 *
 ***********************************************************}

FUNCTION DrgGetNum(DrgLink : DrgLinkHndl ;Tache:INTEGER ;Offset : LONGINT ) : LONGINT;

VAR
	laVar : LONGINT;

BEGIN
	DrgGetNum := 0;
	IF NOT DrgPresent THEN EXIT(DrgGetNum);
	IF DrgLink = NIL THEN EXIT(DrgGetNum);
	IF Tache > MaxTasks+MaxAux THEN EXIT(DrgGetNum);

	Hlock(Handle(DrgLink));
	WITH DrgLink^^ DO BEGIN
		IF Tache = 0 THEN BEGIN         {Variable Partagée}
			DrgFlagPtr^:=1;
			laVar := LIPtr(Ord4(ThePtrs[1]^.PTSVars)+Offset)^;
			DrgFlagPtr^:=0;
		END ELSE BEGIN                  {Variable Locale}
			IF ThePtrs[Tache] = NIL THEN EXIT(DrgGetNum);
			DrgFlagPtr^:=1;
			laVar := LIPtr(Ord4(ThePtrs[Tache]^.PTLVars)+Offset)^;
			DrgFlagPtr^:=0;
		END;
	END; {of WITH}
	DrgGetNum := laVar;
	Hunlock(Handle(DrgLink));
END; {of DrgGetNum}



{************************ DrgSetNum **********************
 *
 * Ecriture d'un nombre vers Dragster
 *
 ***********************************************************}

PROCEDURE DrgSetNum(DrgLink : DrgLinkHndl ;Tache:INTEGER ;Offset,laVar:LONGINT );

VAR
	TheLIPtr:LIPtr;

BEGIN
	IF NOT DrgPresent THEN EXIT(DrgSetNum);
	IF DrgLink = NIL THEN EXIT(DrgSetNum);
	IF Tache > MaxTasks+MaxAux THEN EXIT(DrgSetNum);

	Hlock(Handle(DrgLink));
	WITH DrgLink^^ DO BEGIN
		IF (Tache = 0) THEN BEGIN				{**** Variable Partag ****}
			DrgFlagPtr^:=1;
			TheLIPtr := LIPtr(Ord4(ThePtrs[1]^.PTSVars)+Offset);
			TheLIPtr^:= LaVar;
			DrgFlagPtr^:=0;
		END	ELSE BEGIN                  {**** Variable Locale ****}
			DrgFlagPtr^:=1;
			TheLIPtr := LIPtr(Ord4(ThePtrs[Tache]^.PTLVars)+Offset);
			TheLIPtr^:= LaVar;
			DrgFlagPtr^:=0;
		END;
	END; {of WITH}
	Hunlock(Handle(DrgLink));
END; {of DrgSetNum}



{************************ DrgConnected *********************
 *
 * Teste si une voie est connectée
 *
 ***********************************************************}

FUNCTION DrgConnected(DrgLink : DrgLinkHndl ;Tache: INTEGER):BOOLEAN;

BEGIN
	IF NOT DrgPresent THEN EXIT(DrgConnected);
	IF DrgLink = NIL THEN EXIT(DrgConnected);
	IF Tache > MaxTasks+MaxAux THEN EXIT(DrgConnected);
	
	DrgConnected := DrgLink^^.ThePtrs[Tache]^.Conflag;

END; {of DrgConnected}



{************************** DrgStatus **********************
 *
 * Récupère le status d'un voie
 *
 ***********************************************************}

FUNCTION DrgStatus(DrgLink:DrgLinkHndl; Tache:INTEGER):DrgStatusRec;

BEGIN
	IF NOT DrgPresent THEN EXIT(DrgStatus);
	IF DrgLink = NIL THEN EXIT(DrgStatus);
	IF Tache > MaxTasks+MaxAux THEN EXIT(DrgStatus);

	Hlock(Handle(DrgLink));
	WITH DrgLink^^ DO BEGIN
		DrgFlagPtr^:=1;
		DrgStatus.ConFlag := ThePtrs[Tache]^.Conflag;
		DrgStatus.ModemNumber := ThePtrs[Tache]^.TheModem;
		DrgStatus.StatusWord := ThePtrs[Tache]^.StatusWord;
		DrgStatus.ScreenNumber := ThePtrs[Tache]^.TheNScreen;
		DrgStatus.LineNumber := ThePtrs[Tache]^.TheNLine;
		DrgStatus.InstructionNumber := ThePtrs[Tache]^.TheNInst;
		DrgFlagPtr^:=0;
	END; {of WITH}
	Hunlock(Handle(DrgLink));
END; {of DrgStatus}



FUNCTION DrgGetScreen(DrgLink:DrgLinkHndl;Tache : Integer):Str255;

	VAR 
		LenTexte : Integer;
    TheS     : TPtNameScreen;
		TheNs    : Integer;
    Index    : Integer;
    Cherche  : Boolean;
		TheScreen: Str255;
		
	BEGIN	
		DrgGetScreen := '';
		IF NOT DrgPresent THEN EXIT(DrgGetScreen);
		IF DrgLink = NIL THEN EXIT(DrgGetScreen);
		IF Tache > MaxTasks+MaxAux THEN EXIT(DrgGetScreen);
		
		WITH DrgLink^^,DrgLink^^.ThePtrs[Tache]^ DO
		BEGIN
			DrgFlagPtr^ :=1;			
			TheS 	:= PtNameScreen;
			TheNs := TheNScreen;
      Index	:= 0;
			Cherche	:= True;
			WHILE (Index < TheNs) AND (Cherche) DO {**** on recherche le nom de l'écran ****}
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
			IF Cherche THEN LenTexte := Length(TheS^) ELSE LenTexte := 0 ;
			BlockMoveData(Ptr(Ord4(TheS)),@TheScreen,LenTexte+1);
			DrgFlagPtr^:=0;
		END; {WITH}
		DrgGetScreen := TheScreen;
	END; {of DrgGetScreen}



END. { of UNIT }
