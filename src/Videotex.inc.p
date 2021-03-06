{$IFC NOT THINK_PASCAL}
USES	Terminals, TextUtils, {$U $$Shell(PUtilUnits)OffScreen.p } OffScreen;
{$ENDC}

{$SETC TEST=FALSE}

{$S Videotex}

CONST
    {modes d'interpretation du caractère reçu en fonction des caractères précédents}
    cTypeChar                   =   0;
    cTypeEsc                    =   1;
    cTypeRep                    =   2;
    cTypeSS2                    =   3;
    cTypePosL                   =   4;
    cTypePosC                   =   5;
    cTypeGrave                  =   6;
    cTypeAigu                   =   7;
    cTypeCirFlex                =   8;
    cTypeTreima                 =   9;
    cTypeCedille                =   10;
    cTypeCLine0                 =   11;
    cTypeSep                    =   12;
    cTypeTransp                 =   13;
    cTypeMasquage               =   14;
    cTypeIgnore                 =   15;
    cTypePro1                   =   16;
    cTypePro2                   =   17;
    cTypePro3                   =   18;
    cTypeCSI                    =   19;
    cTypeESC3A69                =   20;
    cTypeESC3A6A                =   21;
    cTypeESC3A32								=		22;
    cTypeESC3A31								=		23;
		cTypeISO										=		24;	{ ESC 3/x … }
    cTypeDRCS										=		25;	{ ESC 2/3 }
		cTypeDRCSHeader							=		26;	{ ESC 2/3 2/0 }
		cTypeDRCSLoad								=		27;	{ ESC 2/3 x/y }
		cTypeDRCSG0									=		28;	{ ESC 2/8 }
		cTypeDRCSG1									=		29;	{ ESC 2/9 }
		cTypeCmdPhoto								=		30;	{ $FF }
		cTypePhoto									=		31;	{ $FF,$D8, … }
		cTypeSOH										=		32;	{ SOH … EOT }
		
		{a suivre...}
    
PROCEDURE ScrollHaut(Glob: GlobPtr);
	FORWARD;
PROCEDURE ScrollBas(Glob: GlobPtr);
	FORWARD;
 PROCEDURE ReDrawRect(glob:GlobPtr;top,left,bottom,right:INTEGER);
	FORWARD;
PROCEDURE UpdateStatutConnexion(Glob:GlobPtr);
	FORWARD;
PROCEDURE SetStatutConnexion2(Glob:GlobPtr; connecte:BOOLEAN);
	FORWARD;
PROCEDURE UpDateScreenRgn(Glob:GlobPtr; rgn:RgnHandle);
	FORWARD;
PROCEDURE ReDrawScreen(Glob: GlobPtr);
	FORWARD;
PROCEDURE ShowScreen(Glob: GlobPtr);
	FORWARD;
PROCEDURE Emulchar(Glob: GlobPtr; char : integer);
	FORWARD;
	
FUNCTION DecToHex(val :integer): STRING;
VAR
    reste   : integer;
    digit   : integer;
    hexa    : str255;
BEGIN
    hexa := '0123456789ABCDEF';
    IF val > 255 THEN BEGIN
        DecToHex := '00';
        EXIT(DecToHex);
    END;
    reste := BAND(val,15); 
    digit := val DIV 16;
    DecToHex := concat(hexa[digit+1],hexa[reste+1]);    
END;


FUNCTION Max(n1,n2:INTEGER):INTEGER;

BEGIN
	IF n1>n2 THEN
		max:=n1
	ELSE
		max := n2;
END;

FUNCTION Min(n1,n2: INTEGER):INTEGER;

BEGIN
	IF n1<n2 THEN
		Min := N1
	ELSE
		Min := n2;
END;

FUNCTION StrInRes(theId : integer) : STRING;
{
    Renvoie la chaine en ressouce N° theId
}
VAR
    StrHdl : StringHandle;
BEGIN
    strHdl := GetString(theId);
	  IF StrHdl <> NIL THEN
		BEGIN
			StrInRes := Str255(strHdl^^);
	   	ReleaseResource(Handle(strHdl));
		END
		ELSE StrInRes := '';
END;


FUNCTION AllocateOffport(glob:globPtr):BOOLEAN;

VAR	bMap:BitMap;

BEGIN
    WITH glob^,glob^.OffPort.portBits DO
		BEGIN
	    OpenPort(@OffPort);
	    OffPort.portRect  :=  RectScreen;
			WITH BMap DO
			BEGIN
				bounds := RectScreen;
	    	rowBytes := (((bounds.right - bounds.left)+15) DIV 16)*2;
				baseAddr := NIL;
			END;
			SetPortBits(bMap);
    	baseAddr := NewPtr(longint(rowBytes)*longint(bounds.bottom - bounds.top));
			AllocateOffport := (baseAddr<>NIL);
			IF baseAddr <>NIL THEN
			BEGIN
				SetPort(@glob^.OffPort);
				EraseRect(bounds);
			END;
			SetRectRgn(OffPort.visRgn,0,0,32000,32000);
			SetRectRgn(OffPort.clipRgn,0,0,32000,32000);
		END;
END;


PROCEDURE DeAllocateOffport(glob:globPtr);

BEGIN
	WITH Glob^ DO
	BEGIN
		DisposPtr(OffPort.PortBits.baseAddr);
		ClosePort(@OffPort);
		OffPort.PortBits.baseAddr := NIL;
	END;
END;


PROCEDURE Emul;

TYPE
		CharPtr = ^Chars;
		
VAR
    i           :   integer;
		
BEGIN   

  IF Glob = NIL THEN EXIT(Emul);
	
	WITH Glob^ DO
	BEGIN
		i := PostEvent(NullEvent,0);		{ pour réveiller le portable ! }
		SystemTask;
		getport(oldport);
    IF DrawPort <> NIL THEN setport(drawPort);
		fDrawInPort := True;
		PtrBufOut^[0]:=CHR(0);
		SupprimeCurseur(Glob);
		FOR i := 0 TO theBufferSize-1 DO Emulchar(Glob,ORD(CharPtr(theBuffer)^[i])); 
    setport(oldport);
		SendString := PtrBufOut^;
	END;
END;

PROCEDURE EmulOneChar;

BEGIN
	IF Glob=NIL THEN EXIT(EmulOneChar);
	WITH Glob^ DO
	BEGIN
		getPort(oldPort);
		IF DrawPort <> NIL THEN SetPort(DrawPort);
		fDrawinPort := TRUE;
		EmulChar(Glob,theChar);
		SetPort(OldPort);
	END;
END;

PROCEDURE CurseurOff(Glob: GlobPtr);
BEGIN
	WITH Glob^ DO
	BEGIN
    invertrect(RectCurs);
    fStatCursOn := false;
	END;
END;

PROCEDURE ShowScreen;
BEGIN
  IF glob^.ModeAffichage <= cModeNoirGris THEN
	WITH Glob^ DO
	BEGIN
		GetPort(OldPort);
		SetPort(DrawPort);
		copybits(OffPort.portbits,DrawPort^.portBits,RectScreen,RectScreen,srcCopy,NIL);    
		SetPort(OldPort);
	END;
END;


PROCEDURE EraseScreen(Glob: GlobPtr; theRect : rect);
{
    Efface l'ecran 'Minitel' sur le Mac en fonction de l'affichage choisi
}
BEGIN
	WITH Glob^ DO
	BEGIN
		PenNormal;
    CASE ModeAffichage OF
        cModeBlancNoir  : PenPat(patternList[cWhite]);
        cModeNoirBlanc,
        cModeNoirGris		: PenNormal;	{ noir }
        cModeNivGris,
        cModeCouleur    :
					BEGIN
						PenNormal;
						RGBForecolor(GrayList[cBlack]);
					END;
    END;	{ CASE ModeAffichage }
		PaintRect(theRect);
	END;
END;


PROCEDURE ChooseSizeScreen(Glob:GlobPtr; theSize:INTEGER);
{
    choix de la taille ecran et définition de la taille des caractères
}
BEGIN
	WITH Glob^ DO
	BEGIN
    SizeJeu := 10;
		SetRect(RectChar,0,0,320,10);
		getport(oldPort);
    setport(DrawPort);
    CASE theSize OF 
        cFistSize:		{ petit écran (50%) }
					BEGIN
						LargCh := 4;
						HautCh := 5;
					END;
					
        c2ndSize:			{ écran normal (100%) }
					BEGIN
						LargCh := 8;
						HautCh := 10;
					END;
					
        cTreeSize:		{ écran double (200%) }
					BEGIN
						LargCh := 16;
						HautCh := 20;
					END;
					
        cFourSize: 		{ très grand écran (400%) }
					BEGIN
						LargCh := 32;
						HautCh := 40;
					END;
					
				cTaille5:	{ écran élargi (150%) }
					BEGIN
						LargCh := 12;
						HautCh := 15;
						SizeJeu := 15;
						SetRect(RectChar,0,0,480,15);
					END;
    END;
    SetRect(RectScreen,OffsetX,OffSetY,OffsetX+(40*LargCh),OffsetY+(25*HautCh));
		{ClipRect(RectScreen);}
    setport(oldPort);
	END;
END;

PROCEDURE ResetAttributs(Glob: GlobPtr);
{
    reinitialise les attributs courants
}
BEGIN
	WITH Glob^ DO
	BEGIN
    chJeu       := JeuSI;
    chFond      := $50;
    chCouleur   := $47;
    chTaille    := $4C;
    chLignage   := $59;
    chFlash     := $49;
    chInverse   := $5C;
    chMasque    := $5F;
		chDelim			:= FALSE;
	END;
END;


PROCEDURE ControlCurseur(Glob: GlobPtr);
{
    limite les déplacements du curseur
}
BEGIN
	WITH Glob^ DO
	BEGIN		
    IF fposLine0 THEN	{ cas particulier de la ligne 0 }
		BEGIN
        IF Ccurs > 40 THEN Ccurs := 40;
				IF Ccurs < 1 THEN CCurs := 1;
    END ELSE BEGIN		{ cas général }
        IF Ccurs < 1 THEN BEGIN
            Ccurs  := 40;
            Lcurs := Lcurs-1;
        END;
        IF Ccurs > 40 THEN BEGIN
            Ccurs := 1;
            Lcurs := Lcurs+1;
        END;
        IF Lcurs > 24 THEN
				BEGIN
					IF fScrollOn THEN
					BEGIN
						ScrollHaut(Glob);
						LCurs := 24;
					END
					ELSE
          	Lcurs := 1;
        END;
				
        IF Lcurs < 1 THEN
				BEGIN
					IF fScrollOn THEN
					BEGIN
						ScrollBas(Glob);
						LCurs := 1;
					END
					ELSE
						Lcurs := 24;
				END;
    END;
  END;
END;



PROCEDURE WriteOnScreen(Glob: GlobPtr; L,C:integer; nb: INTEGER);

VAR	i:INTEGER;
		Str: STRING[40];
		FondNoir: BOOLEAN;
		RectChar2: Rect;
		RectVisible: BOOLEAN;
		coul: RgbColor;
		
	PROCEDURE MyExit;
	
	BEGIN
		HUnlock(Handle(glob^.theScreen));
		EXIT(WriteOnScreen);
	END;
	
	
	FUNCTION AdjustPat(pat:Pattern):Pattern;
	{ ajuste les patterns pour qu'elles soient toujours continues }
	
	VAR Pat2: Pattern;
			i: INTEGER;
			
	BEGIN
		WITH Glob^ DO
		BEGIN
			FOR i:=0 TO 7 DO
				Pat2.pat[i] := Pat2.pat[BAND(i+DestRect.top,7)];
			AdjustPat := Pat2;
		END;
	END;
	
	
	PROCEDURE RedefCoul(CoulC,CoulF:INTEGER; UseBold: BOOLEAN);
	
	VAR	BoldFlag: BOOLEAN;

	BEGIN
		BoldFlag := FALSE;
		WITH Glob^ DO
		BEGIN
			SetPort(@OffCharPort2);
			CASE CoulC OF
				cBlack:
				BEGIN
					PenPat(patternList[cBlack]);		{ Noir }
					IF NOT (CoulF IN [cBlack,cWhite]) THEN BoldFlag := TRUE;
				END;
				
				cBlue,cRed,cMagenta,cGreen:
				BEGIN
					PenPat(AdjustPat(PatternList[cMagenta]));	{ Gris 50% décalé }
					BoldFlag := TRUE;
				END;
				
				cCyan,cYellow,cWhite:
				BEGIN
					PenPat(patternList[cWhite]);		{ Blanc }
					IF NOT (Coulf IN [cBlack,cWhite]) THEN BoldFlag := TRUE;
				END;
			END;
			SetPort(@OffCharPort);
			IF UseBold & BoldFlag THEN TextFace([Bold]);
		END;
	END;

	PROCEDURE DrawSouligne(theRect:Rect);
	
	BEGIN
		HLock(Handle(glob^.theScreen));
		WITH Glob^,theScreen^^[L,C] DO
		IF Souligne & ((leCar<>' ') | (delim=FALSE)) THEN
		BEGIN
			moveto(theRect.left,theRect.Bottom-1);
			Lineto(theRect.Right-1,theRect.Bottom-1);
		END;
		HUnlock(Handle(glob^.theScreen));
	END;
	
	PROCEDURE DrawTheString;
	
	VAR	i:INTEGER;
			ch: CHAR;
			
	BEGIN
		WITH Glob^ DO
		BEGIN
			CASE SizeJeu OF
			10: DrawString(str);
			15:
				FOR i := 1 TO Length(str) DO
				BEGIN
					CASE ORD(str[i]) OF
						$0..$1F,$40..$5F: ch:=CHR(ORD(str[i])+160);
						OTHERWISE ch := str[i];
					END;
					DrawChar(ch);
				END;
			END;	{ CASE }
		END;
	END;
	
	
	PROCEDURE DrawDRCSString(leJeu: INTEGER);
	
	VAR	DRCSRect:Rect;
			i:INTEGER;
			Bits: BitMap;
			
	BEGIN
		WITH Glob^ DO
		BEGIN
			IF SizeJeu=10 THEN
				SetRect(DRCSRect,0,0,8,10)
			ELSE
				SetRect(DRCSRect,0,0,12,15);
				
			IF (ORD(str[1]) = $20) OR (ORD(str[1]) = $7F) THEN
				DrawString(Str)
			ELSE
			BEGIN
				FOR i := 1 TO NB DO
				IF (ORD(str[1]) IN [$21..$7E]) & (TableDRCSChars<>NIL) & (TableDRCS[ORD(str[1]),leJeu]>0) THEN
				BEGIN
					WITH TableDRCSChars^^[TableDRCS[ORD(str[1]),leJeu]] DO
					IF Loaded THEN
					BEGIN
						SetRect(Bits.Bounds,0,0,8,10);		{ taille de la forme }
						Bits.RowBytes := 2;
						Bits.BaseAddr := @Data[0];				
						CopyBits(Bits,OffCharPort.PortBits,Bits.Bounds,DRCSRect,srcCopy,NIL);
						DRCSRect.Left := DRCSRect.Left+8;
						DRCSRect.Right := DRCSRect.Right+8;
					END
					ELSE DrawChar(' ');
				END
				ELSE DrawChar(' ');
			END;
		END;
	END;
	
	
BEGIN
	WITH Glob^ DO
	BEGIN
		IF NOT fDrawInPort THEN EXIT(WriteOnScreen);
		
		IF L=0 THEN SetStatutConnexion2(Glob,Connecte);
		
    {traduire en coordonnées Macintosh les lignes et colonnes Minitel}
    xMac := LargCh*(pred(C)) + offsetX;        
    yMac := HautCh*(Succ(L)) + offsetY;

		SetPort(@OffCharPort);
		
		HLock(Handle(theScreen)); 
		WITH theScreen^^[L,C] DO
		BEGIN
    
			CASE leJeu OF
				JeuVide:
					myExit;
				JeuSI:
				BEGIN
					textfont(FontSI);
					CASE taille OF
						cNormal   : SetRect(DestRect,xMac,yMac - HautCh,xMac+LargCh*nb,yMac);
						cDbleHaut   : SetRect(DestRect,xMac,yMac - 2*HautCh,xMac+LargCh*nb,yMac);
						cDbleLarg   : SetRect(DestRect,xMac,yMac - HautCh,xMac+2*LargCh*nb,yMac);
						cDbleTaille : SetRect(DestRect,xMac,yMac- 2*HautCh ,xMac+2*LargCh*nb,yMac);     
					END;
				END;
			 
				JeuSO,JeuDRCS1,JeuDRCS2:
				BEGIN
					textFont(FontSO);
					SetRect(DestRect,xMac,yMac - HautCh,xMac+LargCh*nb,yMac);
				END;
			END;	{ CASE leJeu }
			 
			{ zone de dessin visible ? 11/5/92}
			RectVisible := (DrawPort<>NIL) & RectInRgn(destRect,DrawPort^.VisRgn);
			
			IF (ModeAffichage>cModeNoirGris) & NOT RectVisible THEN myExit;
			
			IF SizeJeu=10 THEN
				SetRect(RectChar,0,0,8*nb,10)
			ELSE
				SetRect(RectChar,0,0,12*nb,15);
				
			FOR i := 1 TO NB DO Str[i] := leCar;
			Str[0] := CHR(nb);
			
			backcolor(WhiteColor);
			forecolor(BlackColor);  
			textSize(SizeJeu);
			
			CASE ModeAffichage OF
			 
				cModeBlancNoir:		{ on dessine tout sauf le noir }
					BEGIN
						fillrect(RectChar,patternList[cWhite]);
						moveto(0,SizeJeu);
						IF CoulCar <> cBlack THEN
						CASE leJeu OF
							JeuSI: DrawString(str);
							JeuSO: DrawTheString;
							JeuDRCS1,JeuDRCS2: DrawDRCSString(leJeu);
						END;
						setport(@Offport);
						fillrect(DestRect,patternList[cWhite]);
						copybits(OffCharPort.portbits,Offport.portBits,RectChar,Destrect,srcXor,NIL);  
						IF Inverse AND (CoulFond <> cBlack) THEN Invertrect(DestRect);
					END;
					
				cModeNoirBlanc:
					BEGIN                          
						fillrect(RectChar,patternList[cWhite]);
						moveto(0,SizeJeu);
						IF CoulCar <> cBlack THEN
						CASE leJeu OF
							JeuSI: DrawString(str);
							JeuSO: DrawTheString;
							JeuDRCS1,JeuDRCS2: DrawDRCSString(leJeu);
						END;
						setport(@Offport);
						fillrect(DestRect,PatternList[cBlack]);
						copybits(OffCharPort.portbits,Offport.portBits,RectChar,Destrect,srcXor,NIL);  
						IF Inverse AND (CoulFond <> cBlack) THEN Invertrect(DestRect);
					END;
					
				cModeNoirGris:
					BEGIN
						{ Dessin du caractère }
						FondNoir := (inverse & (coulCar = cBlack)) | ((inverse=FALSE) & (coulFond = cBlack));
						RectChar2 := RectChar;
						IF (Taille = cDbleHaut) OR (Taille = cDbleTaille) THEN RectChar2.bottom := 2*RectChar2.Bottom;
						IF (Taille = cDbleLarg) OR (Taille = cDbleTaille) THEN RectChar2.right := 2*RectChar2.Right;
						
						fillrect(RectChar,patternList[cWhite]); 
						moveto(0,SizeJeu);

						CASE leJeu OF			{ dessin du texte ou graphique }
							JeuSI:
							BEGIN
								IF Inverse THEN
									RedefCoul(CoulFond,CoulCar,Taille IN [cNormal,cDbleHaut])
								ELSE
									RedefCoul(CoulCar,CoulFond,Taille IN [cNormal,cDbleHaut]);
								DrawString(str);
								textFace([]);
							END;
							JeuSO: DrawTheString;
							JeuDRCS1,JeuDRCS2: DrawDRCSString(leJeu);
						END;

						SetPort(@OffCharPort2);
						IF leJeu <> JeuSI THEN 			{ Sélection des couleurs }
							IF Inverse THEN PenPat(AdjustPat(PatternList[CoulFond])) ELSE PenPat(AdjustPat(PatternList[CoulCar]));
							
						copyBits(offCharPort.portbits,offCharPort2.portBits,RectChar,RectChar2,SrcCopy,NIL);
						PenMode(PatBic);
						PaintRect(RectChar2);
						copybits(offCharPort2.portbits,offport.portBits,RectChar2,Destrect,srcCopy,NIL);
						
						IF NOT FondNoir THEN
						BEGIN
							copyBits(offCharPort.portbits,offCharPort2.portBits,RectChar,RectChar2,NotSrcCopy,NIL);
							SetPort(@OffCharPort2);
							IF Inverse THEN PenPat(AdjustPat(PatternList[CoulCar])) ELSE PenPat(AdjustPat(PatternList[CoulFond]));
							PenMode(PatBic);
							PaintRect(RectChar2);
							copybits(OffCharPort2.portbits,offport.portBits,RectChar2,Destrect,srcOr,NIL);
						END;
						SetPort(@OffPort);
						InvertRect(Destrect);
						DrawSouligne(DestRect);
					END;

				cModeNivGris:
					BEGIN
						fillrect(RectChar,patternList[cWhite]);
						moveto(0,SizeJeu);
						CASE leJeu OF
							JeuSI: DrawString(str);
							JeuSO: DrawTheString;
							JeuDRCS1,JeuDRCS2:	DrawDRCSString(leJeu);
						END;
						IF fStatCursOn THEN CurseurOff(Glob);
						
						IF DrawPort<>NIL THEN setport(DrawPort);
						IF inverse THEN
						BEGIN
							RGBbackcolor(GrayList[CoulCar]);
							RGBforecolor(GrayList[CoulFond]);
						END
						ELSE
						BEGIN
							RGBbackcolor(GrayList[CoulFond]);
							RGBforecolor(GrayList[CoulCar]);
						END;
						
						copybits(OffCharPort.portbits,qd.thePort^.portBits,RectChar,Destrect,srcCopy,NIL);
						PenNormal;
						DrawSouligne(DestRect);
						RGBforecolor(GrayList[cBlack]);
						RGBbackColor(GrayList[cWhite]);
						myExit;
					END;

				cModeCouleur:
					BEGIN
						fillrect(RectChar,patternList[cWhite]);
						moveto(0,SizeJeu);
						CASE leJeu OF
							JeuSI: DrawString(str);
							JeuSO: DrawTheString;
							JeuDRCS1,JeuDRCS2:	DrawDRCSString(leJeu);
						END;
						IF fStatCursOn THEN CurseurOff(Glob);
						
						IF DrawPort<>NIL THEN setport(DrawPort);
						IF l=9 THEN
							i := coulFond;
						IF inverse THEN
						BEGIN
							RGBbackcolor(ColorList[CoulCar]);
							RGBforecolor(ColorList[CoulFond]);
						END
						ELSE
						BEGIN
							RGBbackcolor(ColorList[CoulFond]);
							RGBforecolor(ColorList[CoulCar]);
						END;
						
						copybits(OffCharPort.portbits,qd.thePort^.portBits,RectChar,Destrect,srcCopy,NIL);
						PenNormal;
						DrawSouligne(DestRect);
						RGBforecolor(ColorList[cBlack]);
						RGBbackColor(ColorList[cWhite]);
						myExit;
					END;
    
     END;
    
    END; {With} 
    HUnlock(Handle(theScreen));
		
    IF (Drawport <> NIL) & RectVisible & (ModeAffichage<=cModeNoirGris) & (NOT redrawing) THEN
		BEGIN
			setport(DrawPort);
    	IF fStatCursOn THEN CurseurOff(Glob);
    	copybits(OffPort.portBits,DrawPort^.portBits,Destrect,Destrect,srcCopy,NIL); 
		END;

	END;
END;


PROCEDURE VideoCurseur;

VAR
	x, y : INTEGER;
	
BEGIN
    WITH Glob^ DO
		BEGIN
				IF NOT fCursorON THEN EXIT(VideoCurseur);
				saveTime := tickCount;
				IF (saveTime - mytime) > 20 THEN BEGIN
						getport(oldport);
						setport(DrawPort);
						IF NOT fStatCursOn THEN
						BEGIN    
								UpdateStatutConnexion(Glob);	{ mise à jour du 'C' ou 'F' en haut d'écran }
								x := LargCh*(pred(Ccurs)) + offsetX;        
								y := HautCh*(Succ(Lcurs)) + offsetY;
								SetRect(RectCurs,x,y - HautCh,x+LargCh,y);
								invertrect(RectCurs);
								fStatCursOn := true;    
						END
						ELSE CurseurOff(Glob);
						
						setport(oldport);
						mytime := saveTime;
				END;
		END;
END;


PROCEDURE resetline(glob:globptr; theline:integer);

VAR	carData : ScreenData;
		theCol: INTEGER;
		
BEGIN
	WITH CarData DO
	BEGIN
		leCar := chr(0);
		leJeu := 0;
		coulCar := 0;
		coulFond := 0;
		Taille := 0;
		souligne := false;
		inverse := false;
		flash := false;
		masque := false;
		delim := false;
		redraw := false;
	END;
	WITH Glob^ DO
		FOR theCol := 1 TO MaxColVideotex DO theScreen^^[theLine,theCol] := carData;
END;

PROCEDURE ScrollHaut(Glob: GlobPtr);

VAR	rgn:RgnHandle;
		nulRect: Rect;
		tempPort: GrafPtr;
		
BEGIN
	WITH Glob^ DO
	BEGIN
    getport(tempPort);
    Rgn:=NewRgn;
    nulrect := RectScreen;
    nulrect.top := RectScreen.top+hautch;
    
		IF ModeAffichage < cModeNivGris THEN
			setport(@offPort)
		ELSE
			setPort(DrawPort);
			
		BackColor(blackColor);
    Scrollrect(nulrect,0,-HautCh,Rgn);
		BackColor(whiteColor);
		
    nulrect.top := RectScreen.bottom-hautch;
		EraseScreen(Glob, nulrect);
		{ on décale la mémoire d'écran et on reset la ligne du bas }
		BlockMoveData(@theScreen^^[2,1],@theScreen^^[1,1],(MaxLinVideotex-1)*MaxColVideotex*sizeOf(ScreenData));
		ResetLine(glob,MaxLinVideotex);
		UpdateScreenRgn(Glob,Rgn);
		DisposeRgn(Rgn);
    setport(tempPort);
	END;
END;

PROCEDURE ScrollBas(Glob:GlobPtr);

VAR	rgn: RgnHandle;
		tempPort: GrafPtr;
		nulRect: Rect;
		
BEGIN
	WITH Glob^ DO
	BEGIN
		getport(tempPort);
    Rgn := NewRgn;
    nulrect := RectScreen;
    nulrect.top := RectScreen.top+HautCh;

		IF ModeAffichage < cModeNivGris THEN
			setport(@offPort)
		ELSE
			setPort(DrawPort);
			
		BackColor(blackColor);
    Scrollrect(NulRect,0,HautCh,Rgn);
    BackColor(WhiteColor);
		
		nulrect.bottom := nulrect.top+HautCh;
		
		EraseScreen(Glob, nulrect);
		{ on décale la mémoire d'écran et on reset la ligne du haut }
		BlockMoveData(@theScreen^^[1,1],@theScreen^^[2,1],(MaxLinVideotex-1)*MaxColVideotex*sizeOf(ScreenData));
		ResetLine(glob,1);
		UpdateScreenRgn(Glob,Rgn);
		DisposeRgn(Rgn);
    setport(tempPort);
	END;
END;


PROCEDURE emulchar;
{
    Emulation Videotex
    but positionner le caractère reçu dans la mémoire de page
    ou effectuer la commande nécessaire
    interpretation et analyse de chaque caractère dans son contexte
}
VAR
    i         :   integer;
    nbrep     :   integer;
    saveCol   :   integer;
    saveLig   :   integer;
    achar     :   integer;
    tempRep   :   integer;
    theVal,LoByte : STRING;
    theNum    :   longint;

		PROCEDURE WriteInScreen(thechar:integer;L,C:integer;fDraw:boolean);
		{
				- stocke le caractère dans la mémoire écran
				représentant l'écran Minitel.
				- analyse des curiosités de la norme videotex
				- appel de la procedure d'affichage
				- mise à jour de la pos. du curseur
		}
		VAR
				savePatFond   : pattern;
				SaveCouleur   : longint;
				PC            : integer;
		BEGIN
			WITH Glob^ DO
			BEGIN
				{ caractère affichable ? }
				IF (theChar<0) | (theChar>255) THEN theChar := 184;	{ ¿ }
				
				{ on se recale dans l'écran au cas où l'on en soit sorti… }
				IF C> 40 THEN C:=40;
				IF c<1 THEN C:=1;
				IF L<0 THEN L:=0;
				IF L>24 THEN L:=24;
				
				pc := C-1;
				HLock(Handle(theScreen));
				WITH theScreen^^[L,C] DO
				BEGIN
					chChar  := thechar;
				
					leCar := chr(theChar);
					CASE chJeu OF
						JeuSI:	IF G0isDRCS AND (L>0) THEN leJeu := JeuDRCS1 ELSE leJeu := ChJeu;
						JeuSO:	IF G1isDRCS AND (L>0) THEN leJeu := JeuDRCS2 ELSE leJeu := ChJeu;
					END;
					
					{ Particularité du Videotex }
					{ STUM § 4 page 86 }
					
					
					CASE chCouleur OF
						64..71: 		CoulCar := ChCouleur - 64;
						OTHERWISE		CoulCar := ChCouleur;
					END;
			 
					CASE chJeu OF
						0,JeuSI:	{ jeu texte }
								BEGIN
									Inverse := (ChInverse = $5D);
									Taille := chTaille-$4C;
									IF (chChar <> 32) & (C > 1)  THEN { recopie des attributs série }
									BEGIN
										coulFond := theScreen^^[L,pc].CoulFond;
										souligne := theScreen^^[L,pc].Souligne;   
									END
									ELSE
										IF (C>1) OR (chChar=32) THEN
										BEGIN
											IF (chChar = 32) & chDelim THEN	{ c'est un espace délimiteur }
											BEGIN
												delim := TRUE;
												ChDelim := FALSE;
											END;
											IF (ChFond = 0) | ((chChar=32) & (delim = FALSE)) THEN
												IF pc>0 THEN coulFond := theScreen^^[L,pc].coulFond
												ELSE coulFond := 0
											ELSE
												CASE chFond OF
													80..87:			CoulFond := chFond-80;
													0..7:				CoulFond := chFond;
													OTHERWISE	CoulFond := 0;
												END;
											IF (ChLignage = 0) | ((chChar=32) & (delim = FALSE)) THEN
												souligne := (pc<>0) & (theScreen^^[L,pc].souligne)
											ELSE
												souligne := chLignage = 90;
										END
										ELSE
										BEGIN
											{ChFond := 0;}
											CoulFond := 0;
											{ChLignage := 89;}
											chDelim := FALSE;
											souligne := FALSE;
										END;
								END;
							JeuSO:	{ jeu graphique }
								BEGIN
									inverse := FALSE;
									Taille := cNormal;
									CASE chFond OF
										80..87:			CoulFond := chFond-80;
										0..7:				CoulFond := chFond;
										OTHERWISE	CoulFond := 0;
									END;
									IF leJeu<>JeuDRCS2 THEN
									BEGIN
										souligne := chLignage = 90;
										CASE chChar OF	{ calcul du car. en fonction du disjoint }
											$20..$3F,$60..$7E:
											BEGIN
												IF souligne THEN
													leCar := chr(chChar-32)
												ELSE
													leCar := chr(chChar);
											END;
											
											$40..$5F:	{ remappe en $60..$7F }
												IF souligne THEN
													leCar := chr(chChar)
												ELSE
													leCar := chr(chChar+32);
											
											OTHERWISE leCar := chr(0);	{ inconnu=vide }
										END;	{ CASE }
										Souligne := FALSE;
									END;
								END;
					END;

				
					IF fDraw & fDrawInPort THEN
						WriteOnScreen(Glob,L,C,1)
					ELSE
						Redraw := TRUE;
				
					{ mise à jour de la position du curseur dans l'écran }
					CASE Taille OF
						cNormal,cDbleHaut:
							IF (LCurs > 0) | (cCurs<40) THEN Ccurs := cCurs+1;
						
						cDbleLarg,cDbleTaille:
							BEGIN
								IF C < 40 THEN
								BEGIN
									theScreen^^[L,C+1].CoulFond := CoulFond;
									theScreen^^[L,C+1].Souligne := Souligne;
								END;
								Ccurs := cCurs+2;
							END;  
					END;    
					
					IF Taille IN [cDbleHaut,cDbleTaille] THEN
					BEGIN
						IF ccurs>40 THEN lcurs := lCurs+1;
						IF l>1 THEN
						BEGIN
							theScreen^^[l-1,c].CoulFond := CoulFond;
							theScreen^^[L-1,C].Souligne := Souligne;
							IF (Taille=cDbleTaille) & (c<40) THEN
							BEGIN
								theScreen^^[L-1,c+1].CoulFond := CoulFond;
								theScreen^^[L-1,C+1].Souligne := Souligne;
							END;
						END;
					END;
					
					ControlCurseur(Glob);
					
			END;{With theScreen}
			HUnlock(Handle(theScreen));
		END;	{ WITH Glob^ }
	END;
	

	PROCEDURE NewDRCSChar(VAR Element:INTEGER);
	
	VAR	i,nb:INTEGER;
	
	BEGIN
		WITH Glob^ DO
		BEGIN
			IF Element=0 THEN
			BEGIN
				nb := 1+GetHandleSize(Handle(TableDRCSChars)) DIV SizeOf(DRCSChar);
				SetHandleSize(Handle(TableDRCSChars),nb*SizeOf(DRCSChar));
				IF MemError<>NoErr THEN
					Element := 0
				ELSE
					WITH TableDRCSChars^^[nb] DO
					BEGIN
						Element := nb;
						FOR i := 0 TO 19 DO Data[i]:=0;		{ RAZ de la forme }
						Loaded := FALSE;									{ pas de forme pour l'instant ! }
					END;
			END;
		END;
	END;

BEGIN
	WITH Glob^ DO
	BEGIN

    CASE ModeInterpretation OF
 
    ctypeChar : BEGIN {c'est un caractère }
                 CASE char OF
                  NUL,$02,$03,ENQ:
										BEGIN
										END;
										
									SOH:
										BEGIN
											ModeInterpretation := cTypeSOH;
											MyCount := 0;
										END;
									
                  BEL      : sysbeep(60);
                  BS       : BEGIN {STUM 1B p97}
																CASE ChJeu OF
																	JeuSI:
																		BEGIN
																			IF chFond <> 0 THEN		{ STUM p }
																			BEGIN
																				SaveFond := chFond;
																				SaveLignage := chLignage;
																				ChLignage := 0;
																				ChFond := 0;
																			END;
																		END;
																END;
																
                                CASE Lcurs OF
                                00     : BEGIN
                                            IF Ccurs > 1 THEN Ccurs := Ccurs-1
                                         END;
                                01     : BEGIN
                                            IF Ccurs = 1 THEN BEGIN
                                                Lcurs := 24;
                                                Ccurs := 40;
                                            END ELSE BEGIN
                                                Ccurs := Ccurs-1;
                                            END;   
                                         END;
                                02..24 : BEGIN
                                            IF Ccurs = 1 THEN BEGIN
                                                Lcurs := Lcurs-1;
                                                Ccurs := 40;
                                            END ELSE BEGIN
                                                Ccurs := Ccurs-1;
                                            END;
                                         END;
                                END;
                             END;
                  HT       : BEGIN
																CASE ChJeu OF
																	JeuSI:
																		BEGIN
																			IF chFond <> 0 THEN
																			BEGIN
																				SaveFond := chFond;
																				SaveLignage := chLignage;
																				ChLignage := 0;
																				ChFond := 0;
																			END;
																		END;
																END;
																
                                CASE Lcurs OF
                                00      : BEGIN
                                            IF Ccurs < 40 THEN Ccurs := Ccurs+1
                                          END;
                                1..23   : BEGIN
                                            IF Ccurs = 40 THEN BEGIN
                                                Lcurs := Lcurs+1;
                                                Ccurs := 1;
                                            END ELSE BEGIN
                                                Ccurs := Ccurs+1;
                                            END;
                                          END;
                                24      : BEGIN
                                            IF Ccurs = 40 THEN BEGIN
                                                Lcurs := 01;
                                                Ccurs := 01;
                                            END ELSE BEGIN
                                                Ccurs := Ccurs+1;
                                            END;           
                                          END;
                                END;
                             END;
                  LF       : BEGIN
																CASE ChJeu OF
																	JeuSI:
																		BEGIN
																			IF chFond <> 0 THEN
																			BEGIN
																				SaveFond := chFond;
																				SaveLignage := chLignage;
																				ChLignage := 0;
																				ChFond := 0;
																			END;
																		END;
																END;
																
                                CASE Lcurs OF
                                00      : BEGIN	{ sortie de ligne 0 }
                                            Lcurs := yCac;
																						CCurs := xCac;
                                            fposLine0 := false;
                                          END;
                                1..23   : BEGIN
                                            Lcurs := Lcurs +1
                                          END;
                                24      : BEGIN
                                            IF fScrollOn THEN BEGIN
                                                {FAIRE SCROLL Haut DE L'ECRAN}
                                                ScrollHaut(Glob);
                                            END ELSE
                                            Lcurs := 1;       
                                          END;
                                END;
                             END;
                  VT       : BEGIN
																CASE ChJeu OF
																	JeuSI:
																		BEGIN
																			IF chFond <> 0 THEN
																			BEGIN
																				SaveFond := chFond;
																				SaveLignage := chLignage;
																				ChLignage := 0;
																				ChFond := 0;
																			END;
																		END;
																END;
																
                                CASE Lcurs OF
                                1       : BEGIN
                                            IF fScrollOn THEN BEGIN
                                                ScrollBas(Glob);
                                            END ELSE
                                                Lcurs := 24;       
                                          END;
                                2..24   : BEGIN
                                            Lcurs := Lcurs -1;
                                          END; 
                                END;                      
                             END;
                  FF       : BEGIN
                                ClearScreen(Glob);
                                ResetAttributs(Glob);
                                fposLine0 := false;{STUM 1B p97}
                             END;
                  CR       : BEGIN
																Ccurs := 1;
																CASE ChJeu OF
																	JeuSI:
																		BEGIN
																			IF chFond <> 0 THEN
																			BEGIN
																				SaveFond := chFond;
																				SaveLignage := chLignage;
																				ChLignage := 0;
																				ChFond := 0;
																			END;
																		END;
																END;
															END;
															
                  SO       : BEGIN                       {0E : SO jeu graphique   } 
                                Chtaille  := $4C;          {STUM page 91  § 1.2.4.2 }
                                Chinverse := $5C;
																ChLignage := $59;
																chDelim 	:= FALSE;
                                Chjeu     := JeuSO;
																IF chFond=0 THEN chFond := SaveFond;
																IF ChLignage = 0 THEN ChLignage := SaveLignage;
                             END;
                  SI       : BEGIN                       {0F : SI jeu NORMAL}
                                Chjeu     := JeuSI;
                                Chinverse := $5C;          {STUM 1B page 91 § 1242 }
                                Chtaille  := $4C;
																ChLignage := $59;
                             END;
                  DLE      : BEGIN END;
                  CON      : fCursorON := true;
                  REP      : ModeInterpretation := cTypeRep;
                  SEP      : ModeInterpretation := cTypeSep;
                  COFF     : BEGIN
															SupprimeCurseur(Glob);
														 	fCursorON := false;
														 END;
                  NACK     : BEGIN END;
                  SUB,CAN  : BEGIN
                                ControlCurseur(Glob);
																SaveCol := Ccurs;
                                SaveLig := Lcurs;
                                FOR i := SaveCol TO 40 DO  
                                    WriteInScreen(32,Lcurs,Ccurs,false);
                                                              
                                WriteOnScreen(Glob,SaveLig,saveCol,41-saveCol); 
                                
                                Ccurs := SaveCol; {curseur non déplacé par cette commande}          
                                Lcurs := SaveLig;
                             END;
                  SYN,SS2  : IF ChJeu = JeuSI THEN
                                ModeInterpretation := cTypeSS2
                             ELSE
                                ModeInterpretation := cTypeChar;{STUM 1B P.90 1234}
                  
                  ESC      : ModeInterpretation := cTypeESC;
                  SS3      : ModeInterpretation := cTypeIgnore;{voir resynchro...} 
                  RS       : BEGIN                      {1/E : RS }
                                Ccurs := 1;
                                Lcurs := 1;
                                ResetAttributs(Glob);
                                fposLine0 := false;     {STUM 1B p97}
                             END;
                  US       : BEGIN                      {positionnement absolu}
                                ModeInterpretation := cTypePosL;
                                {ResetAttributs(Glob);}
                                fposLine0 := false;
																IF LCurs = 0 THEN	{ on vient de la ligne 0 ! }
																BEGIN
																	G0isDRCS := FALSE;
																	G1isDRCS := FALSE;
																END;
                             END;
                  32..126  : WriteInScreen(char,Lcurs,Ccurs,true);
                	127      : IF (chJeu = JeuSI) | G1isDRCS THEN
															WriteInScreen($7F,Lcurs,Ccurs,true)
														 ELSE
                  						WriteInScreen($5F,Lcurs,Ccurs,true);
									$FF				: ModeInterpretation := cTypeCmdPhoto;

									OTHERWISE  WriteInScreen(ord('¿'),Lcurs,Ccurs,true);

                 END; {char of }
                END;  {begin}
    cTypeESC  : BEGIN {interpretation des séquences escape}
                    CASE char OF
                    
                        $23     : ModeInterpretation := cTypeMasquage;
                        $25     : ModeInterpretation := cTypeTransp;
												
												$28     : ModeInterpretation := cTypeDRCSG0;
												$29     : ModeInterpretation := cTypeDRCSG1;
												
												$35,$36,$37:
																	ModeInterpretation := cTypeIgnore;
																	
                        $39     : ModeInterpretation := cTypePro1;
                        $3A     : ModeInterpretation := cTypePro2;
                        $3B     : ModeInterpretation := cTypePro3;                                    
                        $61     : BEGIN  {Demande position Curseur}
                                    PtrBufOut^[1] := chr(US);
                                    PtrBufOut^[2] := chr(Lcurs+64);
                                    PtrBufOut^[3] := chr(Ccurs+64);
                                    PtrBufOut^[0] := CHR(3);  
                                  END;
                        64..71  : chCouleur := char;
                        72,73   : chFlash   := char;
                        76..79  : chTaille  := char;
                        80..87  : BEGIN
																		chFond	:= char;
																		chDelim := TRUE;
																	END;
                        88      : BEGIN
																		chMasque  := char;
																		IF chJeu = JeuSI THEN chDelim := TRUE;
																	END;
                        89,90   : BEGIN
																		chLignage := char;
																		IF chJeu = JeuSI THEN chDelim := TRUE;
																	END;
                        $5B     :
												BEGIN
													ModeInterpretation := cTypeCSI;
													FOR i := 1 TO 10 DO ParamCSI[i] := 0;
													NbParamCSI := 1;
													EXIT(EmulChar);
												END;
												
                        92..93  : chInverse := char;
                        95      : BEGIN
																		chMasque  := char;
																		IF chJeu = JeuSI THEN chDelim := TRUE;
																	END;
                        
												$20,$21,$22,$24,$26,$27,$2A..$2F: ModeInterpretation := cTypeISO;
												
                        OTHERWISE ModeInterpretation := cTypeChar;
                    END; {case char of}
										IF Char > $3F THEN ModeInterpretation := cTypeChar;
                    EXIT(EmulChar);
                END;
								
    cTypeRep  : BEGIN {interpretation des répetitions de caractère}
                    ControlCurseur(Glob);
										nbrep     := char-64;
                    saveLig   := Lcurs;
                    saveCol   := Ccurs;
                    
                    IF chChar >= 32 THEN BEGIN     {on ne repete pas si < espace}
                    
                    FOR i := 1 TO nbrep DO 
                        WriteInScreen(chChar,Lcurs,Ccurs,false);
                    
                    
                    IF nbrep > (40-saveCol) THEN BEGIN
                        WriteOnScreen(Glob,saveLig,saveCol,40+1-saveCol);
                        nbrep := nbrep-(41-saveCol);
                        IF SaveLig>0 THEN
												BEGIN
													SaveLig := SaveLig+1;
                        	IF SaveLig > 24 THEN SaveLig := 1;
                        	saveCol := 1;
												END
												ELSE NbRep:=0;
                    END;
                    IF nbrep > 40 THEN BEGIN 
                        WriteOnScreen(Glob,saveLig,1,40);
                        nbrep := nbrep-40;
                        saveLig := SaveLig+1;
                        IF SaveLig > 24 THEN SaveLig := 1;
                        WriteOnScreen(Glob,saveLig,1,nbrep);
                    END ELSE BEGIN
                        IF nbrep > 0 THEN 
                            WriteOnScreen(Glob,saveLig,saveCol,nbrep);
                    END;
                    END;
                    ModeInterpretation := cTypeChar;
                END;
    cTypeSS2  : BEGIN {caractères du jeu étendu: conversion en caractères Mac}
                    achar := 0;
                    CASE char OF
                        00..$1F : BEGIN
                                    ModeInterpretation := cTypeChar;
                                    Emulchar(Glob,char);{STUM 1B p90 1234}
                                  END;
                        35      : aChar := 163;	{ £ }
												36			: aChar := ord('$');
                        39			: aChar := ord('#');
                        44      : aChar := 167; { flèches… }
                        45      : aChar := 168;
                        46      : aChar := 169;
                        47      : aChar := 170;
                        48      : achar := 161;	{ ° }
												49			: achar := 177; { ± }
                        56      : aChar := 214; { ÷ }
                        60      : aChar := 171; { 1/4 }
                        61      : aChar := 172; { 1/2 }
                        62      : aChar := 173; { 3/4 }
                        65      : ModeInterpretation := cTypeGrave;   {grave}
                        66      : ModeInterpretation := cTypeAigu;    {aigu}
                        67      : ModeInterpretation := cTypeCirFlex; {circonflex}   
                        72      : ModeInterpretation := cTypeTreima;  {treima}
                        75      : ModeInterpretation := cTypeCedille; {ç}
                        106     : aChar := 206; { Œ }
                        122     : aChar := 207; { œ }
                        123     : aChar := 174;
                        OTHERWISE achar := ord('_');  {STUM 1B p.90 1234}                
                    END;
                    IF achar > 0 THEN BEGIN
                        WriteInScreen(aChar,Lcurs,Ccurs,true);
                        ModeInterpretation := cTypeChar;
                    END
                    ELSE;
                END;
    cTypePosL : BEGIN {positionnement absolu Ligne}
										yCac := LCurs;
										xCac := CCurs;
                    IF Char=$23 THEN	{ DRCS }
										BEGIN
											ModeInterpretation := cTypeDRCS;
											EXIT(EmulChar);
										END;
										DRCSLoad := FALSE;
										SaveLig :=  Char-64;  {calcul de la ligne}
										
                    IF fIgnore THEN BEGIN
                        theVal := DecToHex(Char);
                        loByte := theVal[2]; 
                        StringToNum(loByte,theNum);
                        SaveLig := theNum;
                        Ccurs := 1;
                        Lcurs := Savefirst*10 + SaveLig; 
                        fIgnore := false;
                        ResetAttributs(Glob);
                        ControlCurseur(Glob);
                        ModeInterpretation := cTypeChar;
                        EXIT(EmulChar); 
                    END;
                    IF (SaveLig < 0) OR (SaveLig > 24) THEN
										BEGIN
                        fIgnore := true;
                        theVal := DecToHex(Char);
                        loByte := theVal[2]; 
                        StringToNum(loByte,theNum);
                        Savefirst := theNum;
                        EXIT(EmulChar) ;            {STUM 1B page 96 ???? Nimporte quoi}
                    END
										ELSE
                        Lcurs := SaveLig; 
                    
                    IF LCurs = 0 THEN
										BEGIN
                        ModeInterpretation := cTypeCLine0;
                        fposLine0 := true;
                    END
										ELSE
										BEGIN    
                        ModeInterpretation := cTypePosC;
                        fposLine0 := false;
                    END;
                    ResetAttributs(Glob);

{$IFC TEST}
										{ attributs série indéfinis 11/2/94 }
										chFond := 0;
										chLignage := 0;
{$ENDC}

                    fIgnore := false;
                    ControlCurseur(Glob); 
                END;
    cTypePosC:	BEGIN {positionnement absolu Colonne}
                    IF (Char-64) IN [1..40] THEN Ccurs := Char-64; {calcul de la colone    }                    
                    ControlCurseur(Glob);   {si mauvais caractère interprété...}
                    ModeInterpretation := cTypeChar;
                END;
                
    cTypeCLine0:BEGIN
                    IF (Char-64) IN [1..40] THEN Ccurs := char-64;
                    fposLine0 := true;
                    ModeInterpretation := cTypeChar;
                END;

    cTypeGrave: BEGIN {caractere precedent = accent grave}
                    CASE char OF
                        97      : achar := 136;	{ à }
                        101     : achar := 143;
                        105			:	achar := $93;
												111			:	achar := $98;
												117     : achar := 157;
												$41     : achar := $CB;	{ A grave }
												$45     : achar := $E9;	{ E grave }
												$49     : achar := $ED;	{ I grave }
												$4F     : achar := $F1;	{ O grave }
												$55     : achar := $F4;	{ U grave }
                    END;
                    WriteInScreen(aChar,Lcurs,Ccurs,true);
                    ModeInterpretation := cTypeChar;
                END;
    cTypeAigu : BEGIN {caractere precedent = accent aigu}
                    CASE char OF
                        97      : achar := $87;
												101     : achar := 142;	{ é }
												105     : achar := $92;
												111     : achar := $97;
												117			: achar := $9C;
												$41     : achar := $E7;	{ A aigu }
												$45     : achar := $83;	{ E aigu }
												$49     : achar := $EA;	{ I aigu }
												$4F     : achar := $EE;	{ O aigu }
												$55     : achar := $F2;	{ U aigu }
                    END;
                    WriteInScreen(aChar,Lcurs,Ccurs,true);
                    ModeInterpretation := cTypeChar;
                END;            
    cTypeCirflex : BEGIN
                    CASE char OF
                        97      : achar := 137;
                        101     : achar := 144;
                        105     : achar := 148;
                        111     : achar := 153;
                        117     : achar := 158;
												$41     : achar := $E5;	{ A circ }
												$45     : achar := $E6;	{ E circ }
												$49     : achar := $EB;	{ I circ }
												$4F     : achar := $EF;	{ O circ }
												$55     : achar := $F3;	{ U circ }
                    END;
                    WriteInScreen(aChar,Lcurs,Ccurs,true);
                    ModeInterpretation := cTypeChar;
                END;
    cTypeTreima : BEGIN
                    CASE char OF
                        97      : achar := 138;	{ ä }
                        101     : achar := 145; { ë }
                        105     : achar := 149;	{ ï }
                        111     : achar := 154;	{ ö }
                        117     : achar := 159;	{ ü }
												$41     : achar := $80;	{ Ä }
												$45     : achar := $E8;	{ E trema }
												$49     : achar := $EC;	{ I trema }
												$4F     : achar := $85;	{ O trema }
												$55     : achar := $86;	{ U trema }
                    END;
                    WriteInScreen(aChar,Lcurs,Ccurs,true);
                    ModeInterpretation := cTypeChar;
                END;
    cTypeCedille : BEGIN
                    CASE char OF
                        99      : achar := 141;	{ ç }
												$43			: achar := $82;	{ Ç }
                    END; 
                    WriteInScreen(aChar,Lcurs,Ccurs,true);
                    ModeInterpretation := cTypeChar;
                END;
                
    cTypeSep    : BEGIN
                    CASE char OF
                        $53 : fConnected := NOT fConnected; 
                        $59 : fConnected := NOT fConnected; 
                        $56 : fScrollOn := NOT fScrollON;  
                        $70 : BEGIN
                                fModeEcran := true; {80 colones}
                                fScrollOn := true;
                                ClearScreen(Glob);
                              END; 
                        $71 : BEGIN
                                fModeEcran := false;{40 colones}
                              END; 
                    END;
                    ModeInterpretation := cTypeChar;
                END;
                
    cTypeTransp : BEGIN             {STUM 1B p.99 1.2.7 Mode transparent}
                    CASE char OF
                        $25 :  ExChar := char;
                        $2F :  Exchar := char;
                        $3F :  IF ExChar = $2F THEN ModeInterpretation := cTypeChar;                  
                        $40 :  IF ExChar = $25 THEN ModeInterpretation := cTypeChar;       
                    END;
                END;
                
    cTypeMasquage: BEGIN
                    CASE char OF
                        $20 : Exchar := char;
                        $58 : IF Exchar = $20 THEN BEGIN
                                fMasquageON := true;
                                ModeInterpretation := cTypeChar;
                              END;
                        $5F : IF Exchar = $20 THEN BEGIN
                                fMasquageON := false;
                                ModeInterpretation := cTypeChar;
                              END;
                        OTHERWISE ModeInterpretation := cTypeChar;
                    END;
    
                  END;
    cTypeIgnore  :BEGIN {le module ecran ignore ces séquences}
                       {macsbug('esc');
                       test(char);}
                       ModeInterpretation := cTypeChar; 
                  END;
                  
    cTypePro1    :BEGIN
                     CASE char OF
                        $68  : fConnected := true;
                        $67  : fConnected := false;
                        $6C  : BEGIN {Ret1} END;
                        $6D  : BEGIN {Ret2} END;
                        $6E  : BEGIN {accret} END;
                        $6F  : BEGIN {oppo} END;
                        $7A  : BEGIN {ident Ram 2} END;
                        $7B  : BEGIN {ident Rom  } 
                        {renvoyer identité ROM :IDEmulator}
                                    PtrBufOut^[1] := chr(SOH);
                                    PtrBufOut^[2] := IDEmulator[1] ;
                                    PtrBufOut^[3] := IDEmulator[2];
                                    PtrBufOut^[4] := IDEmulator[3];
                                    PtrBufOut^[5] := chr(EOT);
                                    PtrBufOut^[0] := CHR(5);  
                               END;
                        $7F  : BEGIN {Statut} END;
                     END;
                     ModeInterpretation := cTypeChar;
                  END;
									
    cTypePro2    :BEGIN
                     IF NbChar=0 THEN
										 BEGIN
											 CASE char OF
													$69 : ModeInterpretation := cTypeESC3A69;
													$6A : ModeInterpretation := cTypeESC3A6A;
													$32 : ModeInterpretation := cTypeESC3A32;
													$31 : ModeInterpretation := cTypeESC3A31;
											 END;
											 IF ModeInterpretation<>cTypePro2 THEN EXIT(EmulChar);
										 END;
                     nbchar := nbchar + 1;
                     IF nbChar > 1 THEN BEGIN
                        nbchar := 0;
                        ModeInterpretation := cTypeChar;
                     END;
                  END;
                  
    cTypeESC3A69 :BEGIN
                     CASE char OF
                        $43 : fScrollOn := True;
                     END;
										 ModeInterpretation := cTypeChar;
                  END;     
    cTypeESC3A6A :BEGIN
                     CASE char OF
                        $43 : fScrollOn := false;
										 END;
                     ModeInterpretation := cTypeChar;
                  END; 
    cTypeESC3A32 :BEGIN
                     ModeInterpretation := cTypeChar;
										 CASE char OF
                        $7D : BEGIN
                                fScrollOn := true;  {Mode Mixte}
                                fModeEcran := true;
                                ClearScreen(Glob);
                              END;
                        $7E : BEGIN
                                fScrollOn := false; {Mode videotex}
                                fModeEcran := false;
                                ClearScreen(Glob);
                              END;
                     END;
                  END;
    cTypeESC3A31 :BEGIN
                     CASE char OF
                        $7D : BEGIN
                                fScrollOn := true;  {Mode Teleinformatique}
                                fModeEcran := true;
                                ClearScreen(Glob);
                                ModeInterpretation := cTypeChar;
                              END;
                        OTHERWISE ModeInterpretation := cTypeChar;
                     END;
                  END;                
                 
    cTypePro3    :BEGIN
                     CASE char OF
                        $30..$7F : ExChar := char;
                     END;
                     nbchar := nbchar + 1;
                     IF nbChar > 2 THEN BEGIN
                        nbchar := 0;
                        ModeInterpretation := cTypeChar;
                     END;
                  END;
    cTypeCSI: BEGIN
                    CASE char OF
                        $30..$39 : ParamCSI[nbParamCSI]:=ParamCSI[nbParamCSI]*10+(char-$30);
                        $3B: NbParamCSI := nbParamCSI+1;
												
												$41:	{ déplacement curseur vers le haut }
													BEGIN
														lcurs := lcurs-paramCsi[1];
														IF lcurs<1 THEN lcurs := 1;
													END;
													
												$42:	{ déplacement curseur vers le bas }
													BEGIN
														lcurs := lcurs+paramCsi[1];
														IF lcurs>MaxLinVideotex THEN lcurs := MaxLinVideotex;
													END;
												
												$43:	{ déplacement curseur vers la droite }
													BEGIN
														ccurs := ccurs+paramCsi[1];
														IF ccurs>MaxColVideotex THEN ccurs := MaxColVideotex;
													END;
												
												$44:	{ déplacement curseur vers la gauche }
													BEGIN
														ccurs := ccurs-paramCsi[1];
														IF ccurs<1 THEN ccurs := 1;
													END;
												
												$48:	{ positionnement direct du curseur }
													BEGIN
														lCurs := paramCSI[1];
														cCurs := ParamCSI[2];
													END;
(*
												$4A:	{ effacements }
												CASE ParamCSI[1] OF
												0:	{ curseur -> fin écran }
												1:	{ debut écran -> curseur }
												2:	{ effacement de tout l'écran }
												END;	{ CASE }

												$4B:	{ effacement ligne }
												CASE paramCSI[1] OF
												0:	{ curseur -> fin ligne }
												1:	{ début ligne -> curseur }
												2:	{ toute la ligne }
												END;	{ CASE }
												
												$50:	{ suppression de n car. }
												
												$40:	{ insertion de n car. }
												
												$68:	{ début mode insertion }
												IF paramCSI[1]=4 THEN insertmode := TRUE;
												
												$6C:	{ fin mode insertion }
												IF paramCSI[1]=4 THEN insertMode := FALSE;
												
												$4D:	{ suppression n lignes }
												
												$4C:	{ insertion n lignes }
*)
												$60 : BEGIN
                                CASE ExChar OF
                                    $30 : BEGIN
                                            ScrollHaut(Glob);
                                          END;
                                    $31 : BEGIN
                                            ScrollBas(Glob);
                                          END;
                                    $32 : fScrollON := true;
                                    $33 : fScrollON := false;
                                END;
                              END;
                        OTHERWISE ModeInterpretation := cTypeChar;
                    END;
    								IF char>$3F THEN ModeInterpretation := cTypeChar;
                  END;
    
		cTypeISO: BEGIN
								CASE Char OF
									$20..$2F: EXIT(EmulChar);	{ toujours en ISO }
									OTHERWISE ModeInterpretation := cTypeChar;
								END;
								EXIT(EmulChar);
							END;
		
		cTypeDRCS:
							BEGIN
								CASE Char OF
									$20:	{ en-tête de téléchargement }
										ModeInterpretation := cTypeDRCSHeader;
									$21..$7E:
										BEGIN
											ModeInterpretation := cTypeDRCSLoad;
											DRCSCharLoad := Char;
											DRCSFirstLoad := TRUE;
										END;
								END;
							END;
		
		cTypeDRCSHeader:	{ en-tête de téléchargement DRCS }
							BEGIN
								CASE Char OF
									$20:
										BEGIN
										END;
									$42:
										DRCSCurLoad := JeuDRCS1;
									$43:
										DRCSCurLoad := JeuDRCS2;
									$49:
										BEGIN
											DRCSLoad := TRUE;
											ModeInterpretation := cTypeChar;
										END;
									OTHERWISE
										ModeInterpretation := cTypeChar;
								END;
							END;
							
		cTypeDRCSLoad:
							BEGIN
								CASE Char OF
									$30:	{ forme suivante }
										BEGIN
											IF NOT DRCSFirstLoad THEN DRCSCharLoad := DRCSCharLoad+1;
											DRCSFirstLoad := FALSE;
											IF (DRCSCharLoad IN [$21..$7E]) & (DRCSCurLoad IN [JeuDRCS1..JeuDRCS2])THEN	{ toujours valable ? }
											BEGIN
												NewDRCSChar(TableDRCS[DRCSCharLoad,DRCSCurLoad]);
												WITH TableDRCSChars^^[TableDRCS[DRCSCharLoad,DRCSCurLoad]] DO
												BEGIN
													FOR i := 0 TO 19 DO Data[i] := 0;
													Loaded := TRUE;
												END;
												DRCSCurByte := 0;
												DRCSCountByte := 0;
											END
											ELSE ModeInterpretation := cTypeChar;
										END;
					 
									$40..$7F:	{ 6 bits de forme }
										IF (DRCSCurLoad IN [JeuDRCS1..JeuDRCS2]) & (DRCSCurByte<14) THEN
										BEGIN
											WITH TableDRCSChars^^[TableDRCS[DRCSCharLoad,DRCSCurLoad]] DO
											BEGIN
												Char := BAND(Char,$3F);	{ 6 derniers bits }
												CASE BAND(DRCSCurByte,3) OF
													0:	Data[DRCSCountByte*2] := BSL(Char,2);
													
													1:	BEGIN
																Data[DRCSCountByte*2] := Data[DRCSCountByte*2]+BSR(Char,4);
																DRCSCountByte := DRCSCountByte+1;
																IF DRCSCountByte<10 THEN Data[DRCSCountByte*2] := BSL(BAND(Char,$F),4);
															END;
													
													2:	BEGIN
																Data[DRCSCountByte*2] := Data[DRCSCountByte*2]+BSR(Char,2);
																DRCSCountByte := DRCSCountByte+1;
																Data[DRCSCountByte*2] := BSL(BAND(Char,$3),6);
															END;
													
													3:	BEGIN
																Data[DRCSCountByte*2] := Data[DRCSCountByte*2]+Char;
																DRCSCountByte := DRCSCountByte+1;
															END;
												END;
												DRCSCurByte := DRCSCurByte + 1;
											END;	{ WITH }
										END;
										
									$1F:
										ModeInterpretation := cTypePosL;	{ sortie du téléchargement }
										
									OTHERWISE
										ModeInterpretation := cTypeChar;	{ car. non reconnu ! }
								END;
							END;
											
		cTypeDRCSG0,cTypeDRCSG1:
							CASE Char OF
								$20:	BEGIN
											END;
								$40:	BEGIN
												G0isDRCS := FALSE;
												ModeInterpretation := cTypeChar;
											END;
								$63:	BEGIN
												G1isDRCS := FALSE;
												ModeInterpretation := cTypeChar;
											END;
								$42:	BEGIN
												G0isDRCS := TRUE;
												ModeInterpretation := cTypeChar;
											END;
								$43:	BEGIN
												G1isDRCS := TRUE;
												ModeInterpretation := cTypeChar;
											END;
								OTHERWISE ModeInterpretation := cTypeChar;
							END;
		
		cTypeCmdPhoto:
			CASE char OF
				{ $D0..$D7:  resynchronisation photo }

				$D8:	{ début de photo }
					ModeInterpretation := cTypePhoto;
				$D9:	{ fin de photo }
					ModeInterpretation := cTypeChar;		
				OTHERWISE	{ autres données photo }
					ModeInterpretation := cTypePhoto;
			END;
		
		cTypePhoto:
			IF char = $FF THEN ModeInterpretation := cTypeCmdPhoto;	{ commande Photo }
				
		cTypeSOH:
			BEGIN
				MyCount:=MyCount+1;
				IF (char=EOT) | (MyCount>16) THEN ModeInterpretation := cTypeChar;
			END;
			
    OTHERWISE 	{ no reconnu ! }
			ModeInterpretation := cTypeChar;  

    END; {Case ModeInterpretation}
	END;
END;


PROCEDURE ClearScreen;
{
    - effacer la représentation de l'écran du Minitel
    - vider le contenu du tableau de caractères
    - positioner le curseur
}
TYPE
	IPtr = ^INTEGER;
	
VAR
	x: LONGINT;
	
BEGIN
  WITH Glob^ DO
	BEGIN
    getport(oldport);
    IF DrawPort <> NIL THEN setport(drawport);
    EraseScreen(Glob, rectscreen);

    IF ModeAffichage IN [cModeBlancNoir,cModeNoirBlanc,cModeNoirGris] THEN
		BEGIN
    	Setport(@OffPort);
			EraseScreen(Glob, rectscreen);
		END;
		
    setport(oldport);   

		HLock(Handle(TheScreen));
    x := ORD4(theScreen^);
		WHILE x <  ORD4(theScreen^) + sizeof(Screen)-1 DO
		BEGIN
			IPtr(X)^ := 0;
			x := x + 2;
		END;
		HUnlock(Handle(theScreen));
		
    Ccurs := 1;
    Lcurs := 1;
		UpdateStatutConnexion(Glob);
  END;
END;



PROCEDURE ReDrawRect(glob:GlobPtr;top,left,bottom,right:INTEGER);

VAR
    i,j,k: integer; 
		
	FUNCTION IsEqual(VAR S1,S2:ScreenData):BOOLEAN;
	
	BEGIN
		IsEqual := FALSE;
		IF S1.leJeu<>S2.leJeu THEN EXIT(IsEqual);
		IF S1.leCar<>S2.leCar THEN EXIT(IsEqual);
		IF S1.CoulCar<>S2.CoulCar THEN EXIT(IsEqual);
		IF S1.CoulFond<>S2.CoulFond THEN EXIT(IsEqual);
		IF S1.Taille<>S2.Taille THEN EXIT(IsEqual);
		IF S1.souligne<>S2.souligne THEN EXIT(IsEqual);
		IF S1.inverse<>S2.inverse THEN EXIT(IsEqual);
		IF S1.flash<>S2.flash THEN EXIT(IsEqual);
		IF S1.masque<>S2.masque THEN EXIT(IsEqual);
		IF S1.delim<>S2.delim THEN EXIT(IsEqual);
		IsEqual := TRUE;
	END;
	
BEGIN
	WITH Glob^ DO
	BEGIN
		GetPort(OldPort);
		IF DrawPort<>NIL THEN SetPort(DrawPort);
		EraseScreen(glob, rectscreen);
		
		IF ModeAffichage IN [cModeBlancNoir,cModeNoirBlanc,cModeNoirGris] THEN
		BEGIN
    	Setport(@OffPort); 
			EraseScreen(Glob, rectscreen);
    END;
    
    FOR j := top TO bottom DO
		BEGIN
			i := left;
			WHILE i<=Right DO
      BEGIN
				IF theScreen^^[j,i].leJeu <> 0 THEN
				BEGIN
					IF theScreen^^[j,i].taille > cDbleHaut THEN
					BEGIN
						WriteOnScreen(Glob,j,i,1);
						i:=i+2;
					END
					ELSE
					BEGIN
						FOR k := i+1 TO Right DO
							IF IsEqual(theScreen^^[j,k],theScreen^^[j,i])=FALSE THEN Leave;
						WriteOnScreen(Glob,j,i,k-i);
						i:=k;
					END;
        END
				ELSE i:=i+1;
			END;
		END;
		
    setport(oldport); 
  END;
END;


PROCEDURE SupprimeCurseur(glob:globptr);

BEGIN
		{ suppression du curseur… }
		WITH Glob^ DO IF fCursorON THEN
		BEGIN
			ControlCurseur(Glob);
			WriteOnScreen(Glob,lcurs,ccurs,1);
		END;
END;

PROCEDURE UpDateScreen;

BEGIN
	WITH Glob^ DO
	BEGIN
    CASE ModeAffichage OF
			cModeBlancNoir,cModeNoirBlanc,cModeNoirGris : 
		 		ShowScreen(Glob); 
			cModeNivGris,cModeCouleur:
		 		WITH DrawPort^.visRgn^^.rgnBBox DO
					RedrawRect(Glob,Max((top-offsetX) DIV HautCh-1,0),Max((left-offsetY) DIV LargCh-1,1),
					Min((bottom-offsetX) DIV HautCh+1,24),Min((right-offsetY) DIV LargCh+1,40));
		END;
	END;
	UpdateStatutConnexion(glob);	{ on remet le 'F' ou le 'C' en ligne 0 }
END;


PROCEDURE UpDateScreenRgn(Glob:GlobPtr; rgn:RgnHandle);

VAR	savergn: RgnHandle;

BEGIN
	WITH Glob^ DO
	BEGIN
		savergn:=NewRgn;
		GetClip(savergn);					{ on sauvegarde la clip region }
    SectRgn(saveRgn,rgn,rgn);	{ intersection de la clip et de la région à updater }
		SetClip(rgn);
		CASE ModeAffichage OF
			cModeBlancNoir,cModeNoirBlanc,cModeNoirGris : 
		 		ShowScreen(Glob); 
			cModeNivGris,cModeCouleur:
		 		WITH Rgn^^.rgnBBox DO
					RedrawRect(Glob,Max((top-offsetX) DIV HautCh-1,0),Max((left-offsetY) DIV LargCh-1,1),
					Min((bottom-offsetX) DIV HautCh+1,24),Min((right-offsetY) DIV LargCh+1,40));
		END;
		SetClip(savergn);
		DisposeRgn(savergn);
	END;
	UpdateStatutConnexion(glob);	{ on remet le 'F' ou le 'C' en ligne 0 }
END;

PROCEDURE RedrawScreen;

BEGIN
	RedrawRect(Glob,0,1,24,40);
END;


PROCEDURE CleanEmul;
{
    a appeler en quittant l'application pour faire le menage
}
BEGIN
	WITH Glob^ DO
	BEGIN
    ClosePort(@OffCharport);
    ClosePort(@OffCharport2);
    Disposptr(OffCharPort.portBits.baseAddr);
    Disposptr(OffCharPort2.portBits.baseAddr);
    IF OffPort.PortBits.baseAddr<>NIL THEN
		BEGIN
			DisposPtr(OffPort.PortBits.baseAddr);
			OffPort.PortBits.baseAddr:=NIL;
			ClosePort(@Offport);
		END;
		DisposPtr(Ptr(PtrBufOut));
		HUnlock(Handle(theScreen));
		DisposHandle(Handle(theScreen));
		IF TableDRCSChars <> NIL THEN
		BEGIN
			DisposHandle(Handle(TableDRCSChars));
			TableDRCSChars := NIL;
		END;
		DisposPtr(Ptr(PtrBufOut));
		IF MyRgn<>NIL THEN DisposeRgn(MyRgn);
	END;
END;

PROCEDURE ChangeModeAffichage(glob: globPtr; nouveauMode: INTEGER);

BEGIN
	WITH Glob^ DO
	BEGIN
		IF (ModeAffichage<=cModeNoirGris) & (nouveauMode>cModeNoirGris) THEN
			DeAllocateOffPort(glob);
		IF (ModeAffichage>cModeNoirGris) & (nouveauMode<=cModeNoirGris) THEN
			IF AllocateOffport(glob)=FALSE THEN EXIT(ChangeModeAffichage);
		ModeAffichage := nouveauMode;
	END;
	RedrawScreen(Glob);
END;


PROCEDURE ChangeTailleAffichage(glob: globPtr; newSize: INTEGER);

BEGIN
	WITH Glob^ DO
	BEGIN
		{ on doit changer la taille de l'offPort ! }
		IF ModeAffichage<=cModeNoirGris THEN DeAllocateOffPort(glob);
		ChooseSizeScreen(Glob,newSize);
		IF ModeAffichage<=cModeNoirGris THEN
			IF NOT AllocateOffport(glob) THEN
			BEGIN
				SysBeep(60);	{ problème d'alloc. de l'offport !! }
				EXIT(ChangeTailleAffichage);
			END;
		{ redessine l'écran complet }
		RedrawScreen(Glob);
	END;
END;


PROCEDURE GetKeyWord(glob:GlobPtr; where:Point; VAR KeyWord:Str255);

{ where est en coord. locales pour cette émulation }

	FUNCTION CompareAttribs(L1,C1,L2,C2:INTEGER):BOOLEAN;
	{ indique si les deux positions ont les mêmes attributs }
	
	BEGIN
		WITH Glob^ DO
		BEGIN
			CompareAttribs := FALSE;
			IF NOT (theScreen^^[L2,C2].leCar IN ['0'..'9','A'..'Z','a'..'z','*','.']) THEN EXIT(CompareAttribs);
			IF theScreen^^[L1,C1].leJeu <> theScreen^^[L2,C2].leJeu THEN EXIT(CompareAttribs);
			IF theScreen^^[L1,C1].CoulCar <> theScreen^^[L2,C2].CoulCar THEN EXIT(CompareAttribs);
			IF theScreen^^[L1,C1].CoulFond <> theScreen^^[L2,C2].CoulFond THEN EXIT(CompareAttribs);
			IF theScreen^^[L1,C1].Taille <> theScreen^^[L2,C2].Taille THEN EXIT(CompareAttribs);
			IF theScreen^^[L1,C1].souligne <> theScreen^^[L2,C2].souligne THEN EXIT(CompareAttribs);
			IF theScreen^^[L1,C1].inverse <> theScreen^^[L2,C2].inverse THEN EXIT(CompareAttribs);
			IF theScreen^^[L1,C1].flash <> theScreen^^[L2,C2].flash THEN EXIT(CompareAttribs);
			CompareAttribs := TRUE;
		END;
	END;

VAR L,C,X,dx,i,j:INTEGER;
		Str: Str255;
		b:BOOLEAN;
		
BEGIN
	WITH Glob^ DO
	BEGIN
		KeyWord:='';
		
		Getport(oldport);
		SetPort(DrawPort);
		GlobalToLocal(where);
		Setport(OldPort);
		
		L := (where.v-offsetY) DIV HautCh;
		C := ((where.h-offsetX) DIV LargCh)+1;
		IF (L<1) OR (L>24) OR (C<1) OR (C>40) THEN EXIT(GetKeyWord);
		
		IF (L<24) & (theScreen^^[l+1,c].taille IN [cDbleHaut,cDbleTaille]) THEN l:=l+1
		ELSE
			IF (c>1) & (theScreen^^[l,c-1].taille IN [cDbleLarg,cDbleTaille]) THEN c := c-1
			ELSE
				IF (L<24) & (C>1) & (theScreen^^[l+1,c-1].taille = cDbleTaille) THEN
				BEGIN
					c := c-1;
					l := l+1;
				END;
		
		IF theScreen^^[L,C].leJeu<>JeuSI THEN EXIT(GetKeyWord);	{ pas du texte !!! }
		IF NOT (theScreen^^[L,C].leCar IN ['0'..'9','A'..'Z','a'..'z','*','.']) THEN EXIT(GetKeyWord);
		dx := 1+longint(theScreen^^[L,C].Taille > 1);
		x:=C-dx;
		WHILE (x>0) & CompareAttribs(L,C,L,x) DO x:=x-dx;
		C:=x+dx;
		X:=C;
		REPEAT
			IF CompareAttribs(L,C,L,x) THEN
				KeyWord := concat(KeyWord,theScreen^^[L,X].leCar)
			ELSE
				x := 40;
			x:=x+dx;
		UNTIL (x>min(40,c+10*dx)) | (KeyWord[length(KeyWord)]='.');
		IF KeyWord[1]='.' THEN KeyWord:='';
	END;
	
	IF KeyWord<>'' THEN
	BEGIN
		UpperString(KeyWord,FALSE);	{ passage en majuscule sans accents… }
		b:=FALSE;
		FOR i := 1 TO 8 DO	{ pour chaque touche de fonction }
		BEGIN	{ ENVOI,RET,REPET,GUID,ANNUL,SOMM,CORR,SUITE }
			j := 0;
			REPEAT
				j:=j+1;
				GetIndString(Str,1000+i,j);
				IF str='' THEN Cycle;	{ touche de fonction suivante… }
				IF KeyWord=str THEN
				BEGIN
					KeyWord := concat(chr(SEP),chr($40+i));
					b:=TRUE;
				END
				ELSE
					IF KeyWord=concat('*',str) THEN
					BEGIN
						KeyWord := concat('*',chr(SEP),chr($40+i));
						b:=TRUE;
					END;
			UNTIL (Str='') | b;
		END;	{ FOR }
		IF NOT b THEN KeyWord := concat(KeyWord,CHR(SEP),CHR($41));
	END;
END;


FUNCTION GetScreenPicture(Glob:GlobPtr; pictType:INTEGER):PicHandle;

{ on crée une picture en faisant un updateScreen dans une Offscreen Bitmap ou Pixmap }

VAR	oldPort: GrafPtr;
		offscreenHandle: Handle;
		savedPort: GrafPtr;
		buffNotNeeded: BOOLEAN;
		oldMode: INTEGER;
		thePict: PicHandle;
		theClut: CTabHandle;
		
BEGIN
	GetScreenPicture :=NIL;
	GetPort(oldPort);
	WITH Glob^ DO
	BEGIN
		IF pictType=0 THEN pictType := ModeAffichage; { on utilise le mode courant }
		{ 
			on dessine en 'offscreen' si:
			- le type demandé n'est pas celui affiché
			- le type demandé utilise color quickdraw
		}
		IF (pictType>cModeNoirGris) | (ModeAffichage>cModeNoirGris) THEN
		BEGIN
			IF pictType>cModeNoirGris THEN
			BEGIN
				theClut := GetCTable(1024+ModeAffichage-cModeNivGris);
				IF NewOffscreen(drawport^.portRect,4,theClut,FALSE,buffNotNeeded,offscreenHandle) <>NoErr THEN EXIT(GetScreenPicture);
				SavedPort := DrawPort;
				oldMode := ModeAffichage;
				ModeAffichage := pictType;
				DrawPort := NIL;
				BeginOffscreenDrawing(offscreenHandle,NIL);
				DrawPort := qd.thePort;
				RedrawScreen(Glob);
				ClipRect(qd.thePort^.portRect);
				GetScreenPicture := OpenPicture(qd.thePort^.portRect);
				CopyBits(GetMap(offscreenHandle)^,GetMap(offscreenHandle)^,qd.thePort^.portRect,qd.thePort^.portRect,srcCopy,NIL);
				ClosePicture;
				EndOffscreenDrawing(offscreenHandle);
				DisposeOffscreen(offscreenHandle);
				UnloadSeg(@NewOffScreen);	{ seg: OffScreen }
				Drawport := savedport;
				modeAffichage := oldMode;
				IF theClut<>NIL THEN DisposCTable(theClut);
			END
			ELSE
			BEGIN	{ on est en couleur et on veut du N&B }
				IF AllocateOffport(glob) THEN
				BEGIN
					SavedPort := DrawPort;
					DrawPort := NIL;
					oldMode := ModeAffichage;
					ModeAffichage := pictType;
					Setport(@OffPort);
					RedrawScreen(Glob);
					ModeAffichage := oldMode;
					DrawPort := SavedPort;
					ClipRect(DrawPort^.portRect);
					GetScreenPicture := OpenPicture(DrawPort^.portRect);
					copybits(OffPort.portbits,OffPort.portBits,OffPort.portRect,OffPort.portRect,srcCopy,NIL);    
					ClosePicture;
					DeAllocateOffport(glob);
				END;
			END;
		END
		ELSE
		IF ModeAffichage=pictType THEN
		BEGIN	{ on est en N&B et on veut du N&B avec le même mode }
			SetPort(DrawPort);
			SetClip(DrawPort^.clipRgn);
			GetScreenPicture := OpenPicture(drawport^.portRect);
			UpdateScreen(Glob);
			ClosePicture;
		END
		ELSE
		BEGIN	{ on est en N&B et on veut du N&B mais d'un autre mode }
			SavedPort := DrawPort;
			DrawPort := NIL;
			oldMode := ModeAffichage;
			ModeAffichage := pictType;
			Setport(@OffPort);
			RedrawScreen(Glob);				{ dessin dans le mode demandé }
			ModeAffichage := oldMode;
			DrawPort := SavedPort;
			ClipRect(DrawPort^.portRect);
			GetScreenPicture := OpenPicture(DrawPort^.portRect);
			copybits(OffPort.portbits,OffPort.portBits,OffPort.portRect,OffPort.portRect,srcCopy,NIL);    
			ClosePicture;
			DrawPort := NIL;
			RedrawScreen(Glob);				{ on redessine dans le mode d'origine }
			DrawPort := savedPort;
		END;
	END;
	SetPort(oldPort);
END;


PROCEDURE UpdateStatutConnexion(Glob:GlobPtr);

BEGIN
	SetStatutConnexion2(Glob,glob^.Connecte);
	WriteOnScreen(Glob,0,39,1);
END;


PROCEDURE SetStatutConnexion2(Glob:GlobPtr; connecte:BOOLEAN);

BEGIN
	Glob^.connecte := connecte;
	WITH Glob^.theScreen^^[0,39] DO
	BEGIN
		IF Connecte THEN leCar := 'C' ELSE leCar := 'F';
		inverse := TRUE;
		coulcar := cWhite;
		coulFond := cBlack;
		leJeu := JeuSI;
	END;
END;

PROCEDURE ResetDRCSTable(Glob:GlobPtr);

VAR	i:INTEGER;

BEGIN
	WITH Glob^ DO
	BEGIN
		IF TableDRCSChars<>NIL THEN
			SetHandleSize(Handle(TableDRCSChars),0)
		ELSE
			TableDRCSChars:=DRCSCharTableH(NewHandle(0));
			
		FOR i := $21 TO $7E DO
		BEGIN
			TableDRCS[i,JeuDRCS1] := 0;
			TableDRCS[i,JeuDRCS2] := 0;
		END;
	END;
END;

PROCEDURE SetStatutConnexion(Glob:GlobPtr; connecte:BOOLEAN);

VAR redraw:BOOLEAN;
		i:INTEGER;
		
BEGIN
	{ on reset la table DRCS qd on se connecte }
	IF (Glob^.connecte=FALSE) &
		 (connecte = TRUE) &
		 (Glob^.TableDRCSChars<>NIL) THEN ResetDRCSTable(Glob);
	redraw := Glob^.connecte<>connecte;
	SetStatutConnexion2(Glob,Connecte);
	IF redraw THEN WriteOnScreen(Glob,0,39,1);
END;


FUNCTION WordInScreen(Glob:GlobPtr; VAR Word:Str255):INTEGER;
{ cherche une chaine dans l'écran et rend sa position }

VAR L,C,T: INTEGER;
		Long: INTEGER;
		
BEGIN
	WordInScreen := 0;
	Long := Length(Word);
	IF Long=0 THEN EXIT(WordInScreen);
	WITH Glob^ DO
	BEGIN
		FOR L:=0 TO MaxLinVideotex DO
		BEGIN
			T := 0;
			FOR C := 1 TO MaxColVideotex DO
			BEGIN
				IF (theScreen^^[L,C].leJeu=JeuSI) & (theScreen^^[L,C].leCar=Word[T+1]) THEN
				BEGIN
					T:=T+1;
					IF T=Long THEN
					BEGIN
						WordInScreen:=BSL(L,8)+C-T+1;
						EXIT(WordInScreen);
					END;
				END
				ELSE
					T:=0;
			END;
		END;
	END;
END;


PROCEDURE InitVideotex;

VAR	BMap: Bitmap;
		i:INTEGER;
		
	FUNCTION SetRGB(value:INTEGER):RGBColor;
	
	BEGIN
		SetRGB.Red := value;
		SetRGB.Green := Value;
		SetRGB.Blue := value;
	END;
	
	FUNCTION MakeRGB(r,g,b:INTEGER):RGBColor;
	
	BEGIN
		MakeRGB.Red := r;
		MakeRGB.green := g;
		MakeRGB.blue := b;
	END;
	
BEGIN
	IF Glob=NIL THEN Glob:=GlobPtr(NewPtrClear(SizeOf(GlobRec)));
	WITH Glob^ DO
	BEGIN
		TermData := hTerm;
		
    {====== prendre les Patterns Systeme et les Stocker dans le tableau ======== }    
    Getindpattern(patternList[cBlack],0,1);
    Getindpattern(patternList[cBlue],0,2);
    Getindpattern(patternList[cRed],0,3);
    Getindpattern(patternList[cMagenta],0,4);
    Getindpattern(patternList[cGreen],0,23);
    Getindpattern(patternList[cCyan],0,22);
    Getindpattern(patternList[cYellow],0,21);
    Getindpattern(patternList[cWhite],0,20);
    
    ColorList[cBlack]   := MakeRGB(0,0,0);
    ColorList[cRed]     := MakeRGB(65000,0,0);
    ColorList[cGreen]   := MakeRGB(0,65000,0);
    ColorList[cYellow]  := MakeRGB(65000,65000,0);
    ColorList[cBlue]    := MakeRGB(0,0,65000);
    ColorList[cMagenta] := MakeRGB(65000,0,65000);
    ColorList[cCyan]    := MakeRGB(0,65000,65000);
    ColorList[cWhite]   := MakeRGB(65535,65535,65535);
    
		GrayList[cBlack] := SetRGB(0);				{ noir = 0% }
		GrayList[cBlue] := SetRGB(26213);			{ bleu = 40% }
		GrayList[cRed] := SetRGB(32767);			{ rouge = 50% }
		GrayList[cMagenta] := SetRGB(39320);	{ magenta = 60% }
		GrayList[cGreen] := SetRGB(45872);		{ vert = 70% }
		GrayList[cCyan] := SetRGB(52425);			{ cyan = 80% }
		GrayList[cYellow] := SetRGB(58982);		{ jaune = 90% }
		GrayList[cWhite] := SetRGB(65535);		{ blanc = 100% }
		
{$IFC UNDEFINED THINK_PASCAL}
    IF TermData <> NIL THEN
		BEGIN
			OffsetX := TermHandle(TermData)^^.termRect.left;
			OffSetY := TermHandle(TermData)^^.termRect.top;
		END
		ELSE
{$ENDC}
		BEGIN
			OffSetX := offsetH;
			OffSetY := offsetV;
		END;
		
		GetFNum('Velizy',FontSI);
		GetFNum('VidGraph',FontSO);
		
		ModeInterpretation := cTypeChar;            {interprétation normale du 1er caractère reçu}
		ModeAffichage      := TypeEmul;
    fCursorON          := false;                {curseur allumé par défaut          }
    fStatCursOn        := false;                {etat Allumé ou eteint du curseur}
    fModeEcran         := false;                {vrai si Mode 80 colones}
    fConnected         := false;                {Etat de la connexion}
    mytime := 0;
    ResetAttributs(Glob);                       {initialiser les attributs          }
    MyCount := 0;
    
    fposLine0 := false;                         {utilisé pour gestion de la ligne 0 }
    Exchar := 0;                                {permet de se souvenir du caractère précédent pour certaines séquences}
    fLastSave  := false;
    fStatMask := false;
    Lcurs := 1;
    Ccurs := 1;
		xCac := 1;
		yCac := 1;
    Savefirst := 0;
    fIgnore := false;
    ExJeu   := FontSI;                           {jeu de base                        }
    fScrollOn := false;                         {on n'est pas en mode rouleau       }
    NbChar := 0;
    DrawPort := WhichPort;                      {on dessine dans ce port            } 
		redrawing := FALSE;
		
		DRCSLoad := FALSE;													{ on est pas en téléchargement DRCS }
		G0isDRCS := FALSE;
		G1isDRCS := FALSE;
		
		SaveDrawPort := DrawPort;
		
		IF DrawPort = NIL THEN DebugStr('DrawPort=NIL');
		
    vSizeVisu := theSize;												{ taille écran demandée }
    ChooseSizeScreen(Glob,vSizeVisu);       { utiliser taille memorisée }
		
		theScreen := ScreenH(NewHandle(sizeOf(screen)));
		
    GetPort(OldPort);

		OffPort.PortBits.baseAddr:=NIL;
		IF TypeEmul IN [cModeBlancNoir,cModeNoirBlanc,cModeNoirGris] THEN
			IF AllocateOffport(glob) THEN;
		
    SetRect(RectChar,0,0,480,15);
    OpenPort(@OffCharPort);
    textFont(FontSI);
    textsize(SizeJeu);
    OffCharPort.portRect  :=  RectChar;
    WITH BMap DO
		BEGIN
			bounds := RectChar;
    	rowBytes := (((bounds.right - bounds.left)+15)DIV 16)*2; 
    	baseAddr := NewPtr(longint(rowBytes)*longint(bounds.bottom - bounds.top));
		END;
		SetPortBits(bMap);
    IF OffCharPort.PortBits.BaseAddr = NIL THEN DebugStr('Pb avec OffCharPort');

    OpenPort(@OffCharPort2);
    textFont(FontSI);
    textsize(SizeJeu);
    SetRect(OffCharPort2.portRect,0,0,480,30);
    WITH BMap DO
		BEGIN
			bounds := OffCharPort2.portRect;
    	rowBytes := (((bounds.right - bounds.left)+15)DIV 16)*2; 
    	baseAddr := NewPtr(longint(rowBytes)*longint(bounds.bottom - bounds.top));
		END;
		SetPortBits(bMap);
    IF OffCharPort2.PortBits.BaseAddr = NIL THEN DebugStr('Pb avec OffCharPort2');

    IF SizeJeu=10 THEN SetRect(RectChar,0,0,320,10);
    SetPort(OldPort);

		{ raz des tables DRCS }
		TableDRCSChars := NIL;
		ResetDRCSTable(Glob);
		
		DRCSCurLoad := JeuDRCS1;
	  MyRgn := NewRgn;
    IDEmulator := StrInRes(1000);
		PtrBufOut := OutBuffer(NewPtr(SizeOf(Str10)));
		fDrawInPort := TRUE;
		SetStatutConnexion(Glob,FALSE);	{ par défaut on n'est pas connecté }
    ClearScreen(Glob);
	END;
END;
