UNIT Kit;

INTERFACE

USES MemTypes, ToolIntf, SysEqu, Devices, Packages ;


PROCEDURE CenterDlog(theDialog: DialogPtr);	{ centre un dialogue à l'écran }
PROCEDURE CenterMovableDlog(theDialog:DialogPtr; VAR position:Point);
FUNCTION GoodWindow(Where:Rect):BOOLEAN;		{ teste si une fenêtre est dans l'écran }
FUNCTION MyAlert(theID:INTEGER):INTEGER;		{ ma gestion d'alertes }
FUNCTION PathNameFromWD(vRefNum:longint):str255;
FUNCTION PathNameFromDirID(DirID:longint; vRefnum:integer):str255;
FUNCTION CenterSF(theID:INTEGER):Point;
PROCEDURE SetHSize(theHandle: HANDLE; NewSize: LONGINT);
Function RechDrag: integer;
FUNCTION GetVersion:Str255;

IMPLEMENTATION

TYPE
	LIPtr		=	^Longint;
	IPtr		= ^Integer;
	
{$S Main}

PROCEDURE CenterDlog(theDialog: DialogPtr);

VAR	x,y: INTEGER;

BEGIN
	WITH ScreenBits, Windowpeek(theDialog)^.Port.PortRect DO
	BEGIN
		x := ((Bounds.Right-Bounds.Left) - (Right-Left)) DIV 2;
		y := ((Bounds.Bottom-Bounds.Top) - (Bottom-Top)) DIV 3;
		MoveWindow(theDialog,x,y,FALSE);
	END;
	ShowWindow(theDialog);
END;


PROCEDURE CenterMovableDlog(theDialog:DialogPtr; VAR position:Point);

BEGIN
	IF position = point(0) THEN
	BEGIN
		CenterDlog(theDialog);
		position := theDialog^.ContRgn^^.rgnBBox.topLeft;
	END
	ELSE
	BEGIN
		MoveWindow(theDialog,position.left,position.top,FALSE);
		ShowDialog(theDialog);
	END;
END;

{$S Main}
FUNCTION CenterSF(theID:INTEGER):Point;

VAR	theDLOG: DialogTHndl;
		thePoint: Point;
		
BEGIN
	theDLOG := DialogTHndl(GetResource('DLOG',theID));
	IF theDLOG <> NIL THEN
	BEGIN
		WITH theDLOG^^.BoundsRect, ScreenBits DO
			SetPt(thePoint,((bounds.Right-bounds.Left) - (Right-Left)) DIV 2,((bounds.Bottom-bounds.Top) - (Bottom-Top)) DIV 3);
		ReleaseResource(Handle(theDLOG));
	END
	ELSE SetPt(thePoint,90,100);
	CenterSF := thePoint;
END;



{$S Main}
FUNCTION MyAlert(theID:INTEGER):INTEGER;

VAR
	theDialog: DialogPtr;
	itemHit: INTEGER;
	itemh: Handle;
	leRect: Rect;
	car: INTEGER;
	thePen: Penstate;
	
BEGIN
	theDialog := GetNewDialog(theID,NIL,POINTER(-1));
	IF theDialog = NIL THEN Exit(MyAlert);
	CenterDlog(theDialog);
	ShowWindow(theDialog);

	GetDitem(theDialog,1,car,itemh,lerect);
	SetPort(theDialog);
	GetPenState(thePen);
	PenSize(3,3); InsetRect(lerect,-4,-4);
	FrameRoundRect(lerect,16,16);
	SetPenState(thePen);

	SetCursor(Arrow);
	ModalDialog(NIL,itemHit);
	DisposDialog(theDialog);
	MyAlert := ItemHit;
END;


{$S UTILS}

FUNCTION GoodWindow(Where:Rect):BOOLEAN;

{ Vérifie qu'une fenêtre tient dans l'écran principal }
TYPE
	PInteger = ^INTEGER;
	
BEGIN
	GoodWindow := FALSE;
	WITH Where DO
	BEGIN
		IF Top < PInteger(MBarHeight)^ THEN Exit(GoodWindow);
		IF Top > ScreenBits.Bounds.Bottom THEN Exit(GoodWindow);
		IF (Left < 0) | (Left>ScreenBits.Bounds.Right-20) THEN Exit(GoodWindow);
		IF Bottom-Top > ScreenBits.Bounds.Bottom-ScreenBits.Bounds.Top THEN Exit(GoodWindow);
		IF Right-Left > ScreenBits.Bounds.Right-ScreenBits.Bounds.Left THEN Exit(GoodWindow);
	END;
	GoodWindow := TRUE;
END;



{ rend le chemin d'accès d'après un VolRef }

{$S UTILS}

FUNCTION PathNameFromDirID (DirID:longint; vRefnum:integer):str255;

		VAR
			Block : CInfoPBRec;
			directoryName, FullPathName : str255;
			Err: OsErr;
			
		BEGIN
			FullPathName := '';
			WITH block DO BEGIN
				ioNamePtr := @directoryName;
				ioDrParID := DirId;
			END;

			REPEAT
				WITH block DO BEGIN
					ioVRefNum := vRefNum;
					ioFDirIndex := -1;
					ioDrDirID := block.ioDrParID;
				END;
				err := PBGetCatInfo(@Block,FALSE);

				directoryName := concat(directoryName,':');
				fullPathName := concat(directoryName,fullPathName);

			UNTIL (block.ioDrDirID = 2);

			PathNameFromDirID := fullPathName;
		END;

	FUNCTION PathNameFromWD(vRefNum:longint):str255;

		VAR
			myBlock : WDPBRec;
			Err: OsErr;
			
		BEGIN

				WITH myBlock DO BEGIN
					ioNamePtr := NIL;
					ioVRefNum := vRefNum;
					ioWDIndex := 0;
					ioWDProcID := 0;
				END;

				err := PBGetWDInfo(@myBlock,FALSE);

				WITH myBlock DO
					PathNameFromWD := PathNameFromDirID(ioWDDirID,ioWDVRefnum);
		END;


{$S Main}
PROCEDURE SetHSize(theHandle: HANDLE; NewSize: LONGINT);
		
		VAR	flags: SignedByte;
				L:LONGINT;
				temp:Str255;
				
		BEGIN
			flags := HGetState(theHandle);
			HUnlock(theHandle);
			SetHandleSize(theHandle, NewSize);
			IF MemError<>NoErr THEN
			BEGIN
				L:=MaxMem(L);
				SetHandleSize(theHandle, NewSize);
				IF MemError<>NoErr THEN
				BEGIN
					NumToString(MemError,temp);
					DebugStr(concat('Memoire saturee !! (SetHSize) MemError=',temp,';g'));
					NumToString(GetHandleSize(theHandle),temp);
					DebugStr(concat('Ancienne taille:',temp,';g'));
					NumToString(NewSize,temp);
					DebugStr(concat('Nouvelle taille:',temp));
				END;
			END;
			HSetState(theHandle,flags);
		END;
		
{$S INIT}
Function RechDrag: integer;
Type
	UTable = array[0..255] of DCtlHandle;
	UPtr = ^UTable;
	DrvrHdr= record
				Dummy: array[0..8] of integer;
				DrvrName: str255;
			 end;
	DrvrHdrPtr = ^DrvrHdr;
	DrvrHdrHdl = ^DrvrHdrPtr;
	
	var TheUPtr	: UPtr;
		Termine	: Boolean;
		i		: integer;
begin
	TheUptr:=UPtr(LIPtr(UTableBase)^);
	termine:=False;
	i:=IPtr(UnitNtryCnt)^-1;	{ Nombre de driver maxi. }
	While (not termine) and (i>12) do
	begin
		if (TheUPtr^[i]<>Nil) { a driver is here }
		 & (ord4(TheUPtr^[i]^^.dCtlDriver)<ord4(ApplicZone)) { heap système }
		 & (BAND(TheUPtr^[i]^^.dCtlFlags,$40)<>0)						 { Handle }
		 & (DrvrHdrHdl(TheUPtr^[i]^^.DCtlDriver)<>NIL)
		 & (DrvrHdrHdl(TheUPtr^[i]^^.DCtlDriver)^<>NIL) THEN
		BEGIN
			Termine:=DrvrHdrHdl(TheUPtr^[i]^^.DCtlDriver)^^.DrvrName='Dragster';
		END;
		
		If not termine then i:=i-1;
	end;
	if i=12 Then RechDrag:=-1 else RechDrag:=i;
end;


FUNCTION GetVersion;

VAR	VersRes: Handle;

BEGIN
	VersRes := GetResource('vers',1);
	IF VersRes <> NIL THEN
	BEGIN
		GetVersion := VersRecHndl(VersRes)^^.shortVersion;
		ReleaseResource(VersRes);
	END
	ELSE
		GetVersion := '';
END;


END. { UNIT }
