{
	File:		AntiVirus.p

	Contains:	Routines de vérification anti-virus

	Written by:	Christian

	Copyright:	1990 JCA Télématique

	Change History:

		24/10/90	CQ		Première version
}

UNIT Antivirus;


INTERFACE

{$IFC UNDEFINED THINK_PASCAL}
{$SETC THINK_PASCAL := FALSE}
{$ENDC}

{$IFC NOT THINK_PASCAL}
USES
	Types, Memory, Resources, Dialogs, Files, OSUtils;
{$ENDC}


FUNCTION VerifyAvir(key1,key2:LONGINT; message:BOOLEAN):BOOLEAN;
PROCEDURE DeleteAvir(theFile: INTEGER);
FUNCTION UpdateAVir (theType: ResType; theFile: INTEGER; key1,key2:LONGINT): OsErr;

IMPLEMENTATION

CONST
	AVirType = 'AVIR';
	AVIRALRT = 10000;

TYPE
	AVirRec = RECORD
			codeType: LONGINT;	{ type de ressource (codé) }
			nbRes: INTEGER;	{ nb de ressources de ce type }
			SizeRes: LONGINT;	{ Taille totale des ressources de ce type }
			CSRes: LONGINT;	{ Checksum de ces ressources }
			Key: LONGINT;	{ clé de vérification du reste des infos }
		END;

	AVirPtr = ^AVirRec;
	AVirHandle = ^AVirPtr;

	Buff = PACKED ARRAY[0..100000] OF CHAR;
	BuffPtr = ^Buff;
	BuffHandle = ^BuffPtr;


{$R-}

{$S INIT}
FUNCTION VerifyAvir(key1,key2:LONGINT; message:BOOLEAN):BOOLEAN;

	VAR
		i,j: INTEGER;
		L, CS: LONGINT;
		OffSet: LONGINT;
		theType: ResType;
		nbAVir: INTEGER;
		AVir: Handle;
		theRes: Handle;
		NotLoaded: BOOLEAN;
		theAVirID: INTEGER;
		theResID: INTEGER;
		name: Str255;
		hState: SignedByte;
		theKey: LONGINT;
		apParam: Handle;
		apRefNum: INTEGER;
		thePtr: BuffPtr;
		
	PROCEDURE Bad;

		BEGIN
			IF message THEN
			BEGIN
				name[0] := CHR(4);
				name[1] := theType[1];
				name[2] := theType[2];
				name[3] := theType[3];
				name[4] := theType[4];
				ParamText(name, '', '', '');
				SetCursor(qd.Arrow);
				IF Alert(AVirALRT, NIL) = 0 THEN;
				IF AVir <> NIL THEN
					ReleaseResource(Avir);
			END;
			VerifyAvir := TRUE;
			EXIT(VerifyAvir);
		END;

	BEGIN
		VerifyAvir := TRUE;
		NbAvir := Count1Resources(AVirType);
		FOR j := 1 TO NbAvir DO
		BEGIN
			theType := AVirType;
			SetResLoad(TRUE);
			AVir := Get1IndResource(AVirType, j);
			MoveHHi(Avir);
			Hlock(Avir);
			IF SizeResource(Avir) <> SizeOf(AVirRec) THEN Bad;
			GetResInfo(AVir,theAVirID,theType,name);			
			WITH AVirHandle(Avir)^^ DO
			BEGIN
				IF theAvirID = 0 THEN
				BEGIN
					theKey := SizeRes;
					SizeRes := 0;
				END
				ELSE theKey := theAvirID;
				theType := ResType(BXOR(codeType, key1));
				IF Key <> BXor(BXor(BROTL(BXor(BAND(BXor(LONGINT(theType), SizeRes), key2), NbRes), theAVIRId MOD 8), CSRes),theKey) THEN Bad;
				IF (Count1Resources(theType) <> nbRes+LONGINT(theType = AVirType)) THEN Bad;
				L := 0;
				CS := 0;
				FOR i := 1 TO nbRes+LONGINT(theType = AVirType) DO
				BEGIN
					SetResLoad(False);	{ on ne charge pas la resource }
					Notloaded := FALSE;
					theRes := Get1IndResource(theType, i);
					hState := HGetState(theRes);
					theResID := theAVirID;
					IF (TheType = AVirType) THEN
						GetResInfo(theRes,theResID,theType,name);
					IF (theType <> AVirType) | (theResID <> 0) THEN
					BEGIN
						{ chargement de la resource }
						IF TheRes^ = NIL THEN
						BEGIN
							NotLoaded := TRUE;
							SetResLoad(TRUE);
							LoadResource(theRes);
						END;
						{ impossible de charger la resource !!! }
						IF (theRes = NIL) | (theRes^=NIL) THEN Bad;
						HLock(theRes);
						{ màj de la longueur }
						IF theAVirID <> 0 THEN L := L + SizeResource(theRes);
						thePtr := BuffPtr(theRes^);
						{ calcul du checksum }
						FOR Offset := 0 TO SizeResource(theRes) - 1 DO
							CS := CS + ORD(thePtr^[OffSet]);
					END;
					
					IF NotLoaded THEN	{ la resource n'était pas chargée avant le contrôle }
						{ on libère la mémoire qu'elle occupe… }
						ReleaseResource(theRes)
					ELSE
						{ on remet la resource dans l'état original }
						HSetState(theRes,HState);
						
				END;
				IF L <> BRotR(SizeRes,theAVirID MOD 17) THEN Bad;
				IF CS <> BXor(CSRes,$10166954) THEN Bad;
			END;
			{ Si theAVirID = 0 on valide la sortie de VerifyAvir }
			{ BXor(L,theAVirID) doit être égal à L }
			IF L+BXor(L,LONGINT(theAVirID)) = BSL(L,1) THEN VerifyAvir := FALSE;
			HUnlock(AVir);
			HPurge(AVir);
		END;
		IF Avir<>NIL THEN ReleaseResource(AVir);
		SetResLoad(TRUE);
	END;


FUNCTION UpdateAVir (theType: ResType; theFile: INTEGER; key1,key2:LONGINT): OsErr;

	VAR
		i: INTEGER;
		L, CS: LONGINT;
		OffSet: LONGINT;
		curFile: INTEGER;
		AVir: Handle;
		theRes: Handle;
		NotLoaded: BOOLEAN;
		theID: INTEGER;
		theKey: LONGINT;
		thePtr: BuffPtr;
		
	BEGIN
		IF theType = AVirType THEN	{ on va lire la date de création du fichier }
		BEGIN
			GetDateTime(theKey);
			theKey := BXor(theKey,Tickcount);
		END;
		
		AVir := NewHandle(SizeOf(AVirRec));
		curFile := CurResfile;
		UseResFile(theFile);
		MoveHHi(Avir);
		HLock(AVir);
		WITH AVirHandle(Avir)^^ DO BEGIN
			nbRes := Count1Resources(theType);
			L := 0;
			CS := 0;
			SetResLoad(False);
			FOR i := 1 TO nbRes DO BEGIN
				theRes := Get1IndResource(theType, i);
				L := L + SizeResource(theRes);
				SetResLoad(TRUE);
				LoadResource(theRes);
				HLock(theRes);
				thePtr := BuffPtr(theRes^);
				FOR Offset := 0 TO SizeResource(theRes) - 1 DO
					CS := CS + ORD(thePtr^[OffSet]);
				HUnlock(theRes);
				HPurge(theRes);
			END;
			theID := 0;
			IF theType <> AVirType THEN		{ ID=0 réservé au type 'AVIR' }
			BEGIN
				WHILE theID = 0 DO theID := Unique1Id(AVirType);
				theKey := theID;
			END;
			codeType := BXOR(LONGINT(theType), key1);
			IF theType = AVirType THEN SizeRes := 0
			ELSE SizeRes := BROTL(L,theID MOD 17);
			CSRes := BXor(CS,$10166954);
			Key := BXor(BXor(BROTL(BXor(BAND(BXor(LONGINT(theType), SizeRes), key2), nbRes), theID MOD 8), CSRes),theKey);
			IF theType = AVirType THEN SizeRes := theKey;
		END;
		AddResource(AVir, AVirType, theID, '');
		UpdateAVIR := ResError;
		WriteResource(AVir);
		ReleaseResource(AVir);
		UseResFile(CurFile);
	END;


PROCEDURE DeleteAvir(theFile: INTEGER);

VAR	nb: INTEGER;
		curFile: INTEGER;
		theRes: Handle;
		
BEGIN
	curFile := CurResFile;
	UseResFile(theFile);
	nb := Count1Resources(AVirType);
	SetResLoad(FALSE);
	WHILE nb > 0 DO
	BEGIN
		theRes := Get1IndResource(AVirType,1);
		RmveResource (theRes);
		Nb := Nb-1;
	END;
	SetResLoad(TRUE);
	UseResFile(CurFile);
END;

		

END.	{ IMPLEMENTATION }
