{$S COMPOSEUR}
PROCEDURE CalPos(n: integer; VAR i,j: integer);
BEGIN
     j:=n MOD 40;
     i:=n DIV 40;
END;

{$S UPDATE }
{========================================================================
                            C A L C A R
 ========================================================================}
PROCEDURE CalCar(n: integer; VAR i,j: integer; VAR R: Rect);
BEGIN
     j:=n MOD 40;
     i:=n DIV 40;
     SetRect(R,10+j*8,10+i*10,10+(j+1)*8,10+(i+1)*10);
END;


{========================================================================
                            C A R D R A W
 ========================================================================}
{ dessin d'un car. dans le composeur vidéotex }

PROCEDURE CarDraw(VAR TC: TCar; VAR c: integer; InColor:BOOLEAN);

VAR	R,D: Rect; i,j,off: integer;
	Fc, Fi, Fd, Fm,Fn: boolean;
	oldPort: GrafPtr;
	
BEGIN
      WITH TC,screenptr^ DO
      BEGIN
        j:=c MOD 40;
        i:=c DIV 40;
        SetRect(R,10+j*8,10+i*10,10+(j+1)*8,10+(i+1)*10);
        IF RectInRgn(R,ScreenPtr^.VisRgn) THEN
        BEGIN	 
			GetAttrib(VFlags,fc,fd,fm,fi,fn);
			
			IF inColor THEN
			BEGIN
				GetPort(OldPort);
				SetPort(@OffChar);
				EraseRect(OffChar.PortRect);
			END
			ELSE EraseRect(R);
			
			IF VJeu<>txFont THEN
			CASE Vjeu OF
				0: BEGIN
					TextFont(Velizy);
					offx:=0; offy:=2;
				END;
				1: BEGIN
					TextFont(VidGraph);
					offx:=0; offy:=2;
				END;
			END;
			
			IF inColor THEN
			BEGIN
				MoveTo(0,10);
				IF ValG01<>' ' THEN
				BEGIN
					IF (Vjeu=1) AND fd THEN
						DrawChar(chr(ord(valG01)-32))
					ELSE
						DrawChar(valG01);
				END;
				SetPort(oldPort);
				
				CASE VBCouleur*LONGINT(FI=FALSE)+VCouleur*LONGINT(FI) OF
					0:	BackColor(blackColor);
					4:	BackColor(blueColor);
					1:	BackColor(redColor);
					5:	BackColor(magentaColor);
					2:	BackColor(greenColor);
					6:	BackColor(cyanColor);
					3:	BackColor(yellowColor);
					7:	BackColor(whiteColor);
				END;
				CASE VCouleur*LONGINT(FI=FALSE)+VBCouleur*LONGINT(FI) OF
					0:	ForeColor(blackColor);
					4:	ForeColor(blueColor);
					1:	ForeColor(redColor);
					5:	ForeColor(magentaColor);
					2:	ForeColor(greenColor);
					6:	ForeColor(cyanColor);
					3:	ForeColor(yellowColor);
					7:	ForeColor(whiteColor);
				END;
			END
			ELSE
			BEGIN
				IF ValG01<>' ' THEN
				BEGIN
					moveto(R.left+offx,R.top+8+offy);
					IF (Vjeu=1) AND fd THEN
						DrawChar(chr(ord(valG01)-32))
					ELSE
						DrawChar(valG01);
				END;
				IF FI THEN InvertRect(R);
			END;
			
			CASE VTaille OF
			 	0:	{ taille normale }
					IF inColor THEN copyBits(offChar.portBits,screenptr^.portbits,offChar.PortRect,R,srcCopy,Nil);
					
				1:	{ double hauteur }
			 	BEGIN
					D:=R;
					D.top:=D.top-10;
					IF inColor THEN
						copybits(offChar.portbits,screenptr^.portbits,offChar.PortRect,D,srcCopy,Nil)
					ELSE
						copybits(screenptr^.portbits,screenptr^.portbits,R,D,srcCopy,Nil);
				END;
				2:	{ double largeur }
				BEGIN
					c:=c+1;
					D:=R;
					D.Right:=D.Right+8;
					IF inColor THEN
						copybits(offchar.portbits,screenptr^.portbits,offChar.PortRect,D,srcCopy,Nil)
					ELSE
						copybits(screenptr^.portbits,screenptr^.portbits,R,D,srcCopy,Nil);
				END;
				3:	{ double taille }
				BEGIN
					c:=c+1;
					D:=R;
					D.top:=D.top-10;
					D.Right:=D.Right+8;
					IF inColor THEN
						copybits(offchar.portbits,screenptr^.portbits,offChar.PortRect,D,srcCopy,Nil)
					ELSE
						copybits(screenptr^.portbits,screenptr^.portbits,R,D,srcCopy,Nil);
				END; {case}
			END; {if}
		END; {do}
	END;
	
	IF inColor THEN
	BEGIN
		ForeColor(blackColor);
		BackColor(whiteColor);
	END;
END; {CarDraw}

{========================================================================
                            D R A W L I N E
 ========================================================================}
PROCEDURE DrawLine(NumCar1,NumCar2: integer);
    VAR i: integer;
		inColor:BOOLEAN;
		
BEGIN
	inColor := ShowColor;
    PenNormal;
    TextMode(srcxor);
    Cliprect(EditRect);
    FOR i:=NumCar1 TO NumCar2 DO CarDraw(Screen^.Cars[i],i,inColor);
    Cliprect(ScreenPtr^.Portrect);
END;


{========================================================================
                            D R A W J E U
 ========================================================================}
PROCEDURE DrawJeu;
    VAR R,D: Rect; i,j,c,off: integer;
	
	PROCEDURE DrawTheChar(i: integer);
		VAR C: Char;
	BEGIN
		CASE i OF
		 0:	C:=chr($2f);
		 1:	C:=chr($5b);
		 2:	C:=chr($5c);
		 3:	C:=chr($5d);
		 4:	C:=chr($5e);
		 5:	C:=chr($5f);
		 6:	C:=chr($60);
		 7:	C:=chr($7b);
		 8:	C:=chr($7c);
		 9:	C:=chr($7d);
		10:	C:=chr($7e);
		11:	C:=chr($7f);
		12:	C:=chr($83);
		13:	C:=chr($86);
		14:	C:=chr($a1);
		15:	C:=chr($a7);
		16:	C:=chr($a8);
		17:	C:=chr($a9);
		18:	C:=chr($aa);
		19:	C:=chr($ab);
		20:	C:=chr($ac);
		21:	C:=chr($ad);
		22:	C:=chr($b1);
		23:	C:=chr($ce);
		24:	C:=chr($cf);
		25:	C:=chr($d6);
		END;
		DrawChar(C);
	END;
	
BEGIN
    PenSize(3,3);
    PenPat(qd.Gray);
    SetRect(R,350-3,10-3,350+22+3,10+195+3);
    EraseRect(R);
    FrameRect(R);
    PenPat(qd.Black);
    PenSize(1,1);
    {for i:=0 to 23 do
        for j:=0 to 39 do
        begin
            SetRect(R,10+j*8,10+i*10,10+(j+1)*8,10+(i+1)*10);
            Framerect(R);
        end;}
    PenPat(qd.Gray);
    FOR i:=1 TO 12 DO
        BEGIN
            Moveto(350,10+i*15);
            LineTo(372, 10+i*15);
        END;
    Moveto(350+11, 10);
    LineTo(350+11, 205);
    PenPat(qd.Black);
    TextFont(Velizy);
    TextSize(10);
    TextMode(srcOr);
    FOR i:=0 TO 12 DO
     FOR j:=0 TO 1 DO
        BEGIN
            Moveto(350+j*11+2,10+i*15+13);
            DrawTheChar(j*13+i);
        END;
    TextMode(srcxor);
    ValidRect(JeuRect);
END;

{ Affichage de la position du curseur/sélection }

PROCEDURE AffCurPos;
    VAR x,y: integer;
        r: rect;
        str1: Str255;
BEGIN
    PenMode(PatCopy);
    PenSize(3,3);
    PenPat(qd.Gray);
    SetRect(R,10-3,260-3,330+3,272+3);
    EraseRect(R);
    FrameRect(R);
    PenNormal;
    CalPos(PSel,x,y); y:=y+1; x:=x+1;
    TextFont(Velizy);
    MoveTo(20,271);
    GetIndString(gResStr,rSTRErrors,12);
	drawstring(gResStr);
    NumToString(x,Str1);
    Drawstring(Str1);
    GetIndString(gResStr,rSTRErrors,13);
	drawstring('  ');
	drawString(gResStr);
    NumToString(y,Str1);
    Drawstring(Str1);
    DrawString('  ');
	IF (DSel-PSel)=0 THEN
    BEGIN
		GetIndString(gResStr,rSTRErrors,14);
	    drawstring(gResStr);
	END
    ELSE
    BEGIN
        GetIndString(gResStr,rSTRErrors,15);
	    	drawstring(gResStr);
				NumToString(DSel-PSel,Str1);
        Drawstring(Str1);
        DrawString(' ');
        GetIndString(gResStr,rSTRErrors,16+LONGINT((DSel-PSel)>1));
				DrawString(gResStr);
    END;
	
	{ dessin des boutons Edit, pinceau, pict }
    SetRect(R,350-3,260-3,350+66+3,272+3);
    DrawPicture(MyPicButton,R);
	
	{ inversion en fonction du mode choisi }
	CASE Mode OF
		EditModeCst: InvertRect(BTexRect);
		PenModeCst : InvertRect(BPenRect);
	END;
END;


{$S COMPOSEUR}
{=================================================================
         S A U V E G A R D E    S E L	 C O U R A N T E
 =================================================================}
PROCEDURE SauveSel;
BEGIN
    IF Screen=Nil THEN EXIT(SauveSel);
		IF Screen^.mode<>EditModeCst THEN EXIT(SauveSel);
    Screen^.SSel:=PSel;
    Screen^.ESel:=DSel;
    Screen^.IdleFlag:=IdleFlag;
END;

PROCEDURE SauveIdle;
BEGIN
    IF Screen=Nil THEN EXIT(SauveIdle);
		IF Screen^.mode<>EditModeCst THEN EXIT(SauveIdle);
    Screen^.IdleFlag:=IdleFlag;
END;


{=================================================================
                 T R O U V E R	  U N	 V E
 =================================================================}
PROCEDURE VEFindSelect(QFenetre: WindowPtr;
                       VAR SSel,ESel: integer;
                       VAR SelRgn: RgnHandle;
                       VAR IdlePtr: BooleanPtr;
                       VAR Mode: integer);

VAR i: integer;

BEGIN
    FOR i:=1 TO PEcr.NbEcran DO
      IF (PEcr.Ecrans[i]^^.WEcran=QFenetre) THEN
         BEGIN
            SSel:=PEcr.Ecrans[i]^^.SSel;
            ESel:=PEcr.Ecrans[i]^^.ESel;
            SelRgn:=PEcr.Ecrans[i]^^.SelRgn;
            IdlePtr:=@PEcr.Ecrans[i]^^.IdleFlag;
			Mode:=PEcr.Ecrans[i]^^.mode;
            EXIT(VEFindSelect);
         END;
    SSel:=0; { cas d'erreur ... }
    ESel:=0; { cas d'erreur ... }
    SelRgn:=Nil; { cas d'erreur ... }
END;


PROCEDURE CalCur(n: integer; VAR R: Rect);
    VAR i,j: integer;
BEGIN
     IF n>=nbCar THEN n:=nbCar-1;
     j:=n MOD 40;
     i:=n DIV 40;
     SetRect(R,10+j*8,10+i*10,11+(j)*8,10+(i+1)*10);
END;


PROCEDURE Curoff(QFenetre: WindowPtr);
    VAR R	    : rect;
        SavePort    : GrafPtr;
        PSel, DSel, mode  : Integer;
        SelRgn	    : RgnHandle;
        IdlePtr	    : BooleanPtr;
BEGIN
    IF (QFenetre=Nil) THEN EXIT(Curoff);
    IF GetWRefCon(QFenetre)<>VRef THEN EXIT(Curoff);

    GetPort(SavePort);
    SetPort(QFenetre);

    ClipRect(QFenetre^.PortRect);
    VEFindSelect(QFenetre,PSel,DSel,SelRgn,IdlePtr,mode);
		IF mode<>EditModeCst THEN EXIT(Curoff);
    IF PSel=DSel THEN
      BEGIN
         IF IdlePtr^ THEN
            BEGIN
               IdlePtr^:=False;
               IF FrontWindow=QFenetre THEN IdleFlag:=False;
               CalCur(PSel,R);
               InvertRect(R);
            END;
      END
      ELSE
      IF IdlePtr^ THEN
        BEGIN
            IdlePtr^:=False;
            IF FrontWindow=QFenetre THEN IdleFlag:=False;
            PenMode(PatXor);
            PenPat(qd.ltgray);
            PaintRgn(SelRgn);
        END;

    SetPort(SavePort);
END;


{========================================================================
            P O S I T I O N    D U    C A R    C L I Q U E
 ========================================================================}
FUNCTION WhichCar(pt: point; off: integer): integer;
    LABEL 0;
    VAR c,x,y: integer;
BEGIN
    globaltolocal(pt);
    x:=(pt.h-10+off) DIV 8;
    IF x>39 THEN x:=39;
    IF x<0 THEN x:=0;

    y:=(pt.v-10) DIV 10;
    IF y>23 THEN BEGIN y:=23; x:=40; END;
    IF y<0 THEN BEGIN y:=0; x:=0; END;

    c:=(y*40)+x;
    IF screen^.cars[c].VTaille>0 THEN GOTO 0;
    IF x>0 THEN
       IF screen^.cars[c-1].VTaille>1 THEN
         BEGIN
            x:=x+1;
            GOTO 0;
         END;
    IF y<23 THEN
      BEGIN
       IF (screen^.cars[c+40].VTaille=1) OR (screen^.cars[c+40].VTaille=3) THEN
          BEGIN
            y:=y+1;
            GOTO 0;
          END;
       IF x>0 THEN
       IF (screen^.cars[c+39].VTaille=3) THEN
          BEGIN
            y:=y+1; x:=x+1;
            GOTO 0;
          END;
      END;
    0:;
    WhichCar:=(y*40)+x;
END;


{$S COMPOSEUR}
{========================================================================
                A T T R I B U T S    C O U R A N T S
 ========================================================================}
PROCEDURE CheckAtt;
    VAR num: integer; Fd: boolean;
BEGIN

    IF Psel=DSel THEN
    BEGIN
        IF PSel=0 THEN Num:=0
           ELSE
            BEGIN num:=PSel-1;
                  IF num>0 THEN
                    IF Screen^.cars[num-1].Vtaille>1 THEN num:=num-1;
            END;
    END
    ELSE Num:=PSel;

    WITH Screen^.cars[num] DO
      BEGIN
        Taille:=VTAille;
        Couleur:=VCouleur;
        BCouleur:=VBCouleur;
        GetAttrib(VFlags,Clignotement,Fd,Masquage,Inverse,Incrust);
        IF (Jeu<>Vjeu) OR ((Vjeu=1) AND (Fd<>Disjoint)) THEN
           BEGIN
               Jeu:=VJeu;
               Disjoint:=Fd;
           END
        ELSE
           BEGIN
               Jeu:=VJeu;
               Disjoint:=Fd;
           END;
      END;

END;


{$S COMPOSEUR}
{========================================================================
           P O S I T I O N    D U    P I X E L    C L I Q U E
 ========================================================================}
FUNCTION GetPix(pt: point): integer; {0,1,2,3,4,6}

VAR x,y: integer;

BEGIN
	globaltolocal(pt);
	IF PtInRect(Pt,EditRect) THEN
	BEGIN
		x:=(pt.h-10) MOD 8;
		IF x>3 THEN x:=1 ELSE x:=0;
		
		y:=(pt.v-10) MOD 10;
		IF y>6 THEN y:=2
		ELSE IF y>2 THEN y:=1
		ELSE y:=0;
		
		CASE x OF
		0: CASE y OF
			0:	GetPix:=1;
			1:	GetPix:=4;
			2:	GetPix:=16;
		   END;
		1: CASE y OF
			0:	GetPix:=2;
			1:	GetPix:=8;
			2:	GetPix:=64;
		   END;
		END;
	END
	ELSE GetPix := -1;	{ curseur en dehors de la zone d'édition }
END;


{$S COMPOSEUR}
PROCEDURE CheckDelim(pos:INTEGER);
{ on devrait aussi traiter le soulignement… }

VAR	i:INTEGER;
	BCouleur: INTEGER;
	
BEGIN
	BCouleur := Screen^.Cars[pos-1].VBCouleur;	{ couleur de fond du car. précédent… }
	i:=pos;
	WHILE (i MOD 40)<>0 DO
		WITH Screen^.cars[i] DO
		BEGIN
			{ on a trouvé un délimiteur, on arrête là }
			IF (VJeu=1) | (ValG01=' ') THEN Leave;
			VBCouleur := BCouleur;
			i:=i+1;
			IF VTaille>=2 THEN i:=i+1;	{ dble largeur/dble hauteur }
		END;
	IF i>pos THEN DrawLine(pos,i-1);
END;


{========================================================================
            S E L E C T I O N	 P I X E L    V I D E O T E X
 ========================================================================}
PROCEDURE CheckPix(pt: point; modifiers: integer);
	VAR theCar, ThePix: integer; 
		FirstPass,
		OrFlag,
		Fc,Fd,Fm,Fi,Fn : boolean;
		oldChar: Char;
		inColor: BOOLEAN;
		
BEGIN
	inColor := ShowColor;
	FirstPass:=True;
	REPEAT
    TheCar:=WhichCar(Pt,0);
		WITH screen^.cars[TheCar] DO
		IF (VJeu=1) OR ((VJeu=0) AND (ValG01=' ') AND (VTaille=0)) THEN
		BEGIN
			ThePix:=GetPix(Pt);
			IF thePix>=0 THEN	{ le curseur est toujours dans la zone d'édition ? }
			BEGIN
				VJeu:=1;
				oldChar := ValG01;
				IF FirstPass THEN OrFlag:=BitAnd(ord(ValG01),ThePix)=0;
				IF OrFlag THEN
					ValG01:=chr(BitOr(ord(ValG01),ThePix))
				ELSE
					ValG01:=chr(BitAnd(ord(ValG01),BitNot(ThePix)));
				
				VCouleur:=Couleur;
				IF VBCouleur<>BCouleur THEN	{ on change la couleur de fond ? }
				BEGIN
					VBCouleur:=BCouleur;
					CheckDelim(theCar+1);
				END;
				VFlags := SetAttrib(Clignotement,Disjoint,Masquage,False,Incrust);
				IF FirstPass | (oldChar<>ValG01) THEN CarDraw(Screen^.Cars[TheCar],TheCar,InColor);
				FirstPass := FALSE;
			END;
		END;
		GetMouse(Pt);
		LocalToGlobal(Pt);
	UNTIL NOT StillDown;
	Modification:=true;
END;


{$S COMPOSEUR}
{========================================================================
            S E L E C T I O N	 L I G N E    V I D E O T E X
 ========================================================================}
PROCEDURE ChangeSel(pt: point; modifiers: integer);
    VAR MinSel,MaxSel: Integer;

    PROCEDURE Select;
    { selectionne entre PSel et Dsel }
        VAR     Rgn1,Rgn2      : RgnHandle;
                i,j,k,c: integer; R1,R2:rect; D,P: integer; deb,fin: integer;
                fini:boolean;
    BEGIN
        { calcul de la nouvelle region }
        Rgn1:=NewRgn;
        Rgn2:=NewRgn;
        IF PSel<DSel THEN
            IF Screen^.Cars[DSel-1].VTaille>=2 THEN DSel:=DSel+1;
        IF PSel>DSel THEN
            IF Screen^.Cars[PSel-1].VTaille>=2 THEN PSel:=PSel+1;
        D:=DSel;
        P:=PSel;
        IF PSel>DSel THEN Swapint(D,P);
        D:=D-1;
        IF PSel<>DSel THEN
            REPEAT
                Deb:=P;
                IF D<=((Deb DIV 40)*40 + 39) THEN
                   BEGIN Fin:=D; Fini:=True; END
                ELSE
                   BEGIN Fin:=((Deb DIV 40)*40 + 39);
                         Fini:=False;
                   END;
                FOR k:=Deb TO Fin DO
                BEGIN
                   j:=k MOD 40;
                   i:=k DIV 40;
                   SetRect(R2,10+j*8,10+i*10,10+(j+1)*8,10+(i+1)*10);
                   CASE Screen^.Cars[k].VTaille OF
                      1: R2.top:=R2.top-10;
                      2: BEGIN
                           r2.right:=r2.right+8;
                           k:=k+1;
                         END;
                      3: BEGIN
                           R2.top:=R2.top-10;
                           r2.right:=r2.right+8;
                           k:=k+1;
                         END;
                   END;
                   RectRgn(rgn2,R2);
                   UnionRgn(Rgn1,Rgn2,Rgn1);
                END;
                CalCar(Fin,i,j,R2);
                R1.right:=R2.Right;
                P:=Fin+1
            UNTIL fini;
        SectRgn(SelRgn,Rgn1,Rgn2);
        PenMode(PatXor);
        PenPat(qd.ltgray);
        IF EmptyRgn(Rgn2) THEN
          BEGIN
            PaintRgn(SelRgn);
            CopyRgn(Rgn1,SelRgn);
            PaintRgn(SelRgn);
          END
          ELSE
          BEGIN
            XorRgn(SelRgn,Rgn1,Rgn2);
            PaintRgn(Rgn2);
            CopyRgn(Rgn1,SelRgn);
          END;
        PenNormal;
        disposeRgn(Rgn1);
        disposeRgn(Rgn2);
    END; { Select }

BEGIN
    Memo;
    MinSel:=(PSel DIV 40)*40;
    MaxSel:=((PSel DIV 40)+1)*40;
    IF PSel=DSel
        THEN Curoff(ScreenPtr)
        ELSE BEGIN
                IdleFlag:=False;
                SauveIdle;
             END;

    IF BitAnd (monEvent.modifiers,512) <> 0 THEN
       BEGIN
           XSel:=DSel;
           DSel:=Whichcar(Pt,4);
           IF DSel>MaxSel THEN DSel:=MaxSel;
           IF DSel<MinSel THEN DSel:=MinSel;
           Select;
           IF PSel>DSel THEN Swapint(DSel,PSel);
           CheckAtt;
           IdleFlag:=(PSel<>DSel);
           SauveSel;
           SauveIdle;
           EXIT(ChangeSel);
       END;

    PSel:=WhichCar(Pt,4);
    MinSel:=(PSel DIV 40)*40;
    MaxSel:=((PSel DIV 40)+1)*40;

    REPEAT
        GetMouse(Pt);
        LocalToGlobal(Pt);
        XSel:=DSel;
        DSel:=WhichCar(Pt,4);
        IF DSel>MaxSel THEN DSel:=MaxSel;
        IF DSel<MinSel THEN DSel:=MinSel;
        Select;
    UNTIL NOT Stilldown;

    IF PSel>DSel THEN Swapint(DSel,PSel);
    CheckAtt;
    IdleFlag:=(PSel<>DSel);
    SauveSel;
    SauveIdle;
    AffCurPos;
END;


{========================================================================
                C L I C	  C A R	  - - -	  V I D E O T E X
 ========================================================================}
FUNCTION ClicCar(pt: point; VAR c:char): Boolean;
    VAR cd: char; Flag: boolean;
        x,y: integer; R:rect;

	FUNCTION ConvClicChar(i: integer): Char;
		VAR C: Char;
	BEGIN
		CASE i OF
		 0:	C:=chr($2f);
		 1:	C:=chr($5b);
		 2:	C:=chr($5c);
		 3:	C:=chr($5d);
		 4:	C:=chr($5e);
		 5:	C:=chr($5f);
		 6:	C:=chr($60);
		 7:	C:=chr($7b);
		 8:	C:=chr($7c);
		 9:	C:=chr($7d);
		10:	C:=chr($7e);
		11:	C:=chr($7f);
		12:	C:=chr($83);
		13:	C:=chr($86);
		14:	C:=chr($a1);
		15:	C:=chr($a7);
		16:	C:=chr($a8);
		17:	C:=chr($a9);
		18:	C:=chr($aa);
		19:	C:=chr($ab);
		20:	C:=chr($ac);
		21:	C:=chr($ad);
		22:	C:=chr($b1);
		23:	C:=chr($ce);
		24:	C:=chr($cf);
		25:	C:=chr($d6);
		END;
		ConvClicChar:=C;
	END;

    FUNCTION WhichClic(pt: point): char;
    BEGIN
        IF NOT ptinRect(pt,JeuRect) THEN
           BEGIN
            WhichClic:=chr(0);
            EXIT(WhichClic);
           END;
        x:=(pt.h-350) DIV 11;
        y:=(pt.v-10) DIV 15;
        WhichClic:=ConvClicChar(x*13+y);
    END;

BEGIN
    c:=WhichClic(pt);
    SetRect(R,350+1+(x*11),10+1+(y*15),350+10+(x*11),10+14+(y*15));
    InvertRect(R);
    REPEAT
        GetMouse(Pt);
        cd:=WhichClic(pt);
        IF cd<>c THEN
           BEGIN
             IF c<>chr(0) THEN InvertRect(R);
             IF cd<>chr(0) THEN
                BEGIN
                  SetRect(R,350+1+(x*11),10+1+(y*15),350+10+(x*11),10+14+(y*15));
                  InvertRect(R);
                END;
             c:=cd;
           END
    UNTIL NOT StillDown;
    ClicCar:=(c<>chr(0));
    IF c<>chr(0) THEN InvertRect(R);
END;


{$S COMPOSEUR}
{=================================================================
               G E S T I O N    D E S	 M E N U S
 =================================================================}
PROCEDURE CheckTaille;
    VAR i,
        start,
        stop	    : integer;
        FlagDisable,
        FlagSM,
        FlagSM2	    : boolean;
		theMenu		: MenuHandle;
		
BEGIN
	theMenu := GetMHandle(JeuMenu);
	FlagDisable:=False;
	FlagSM:=False;
	EnableItem(theMenu,OffDH);
	EnableItem(theMenu,OffDL);
	EnableItem(theMenu,OffDG);
	EnableItem(theMenu,OffInverse);

	{ quinquonce avec la ligne superieure ?}
	IF PSel>39 THEN
	BEGIN
	   Start:=((PSel DIV 40)-1)*40;
	   Stop:=Start+39;
		 IF Stop>=nbCar THEN Stop := nbCar-1;
		 
	   FOR i:=Start TO Stop DO
		 WITH Screen^.cars[i] DO
			IF (VTaille=1) OR (VTAille=3) THEN FlagDisable:=True;
	END ELSE FlagDisable:=True;

	{ quinquonce avec la ligne inferieure ?}
	IF PSel<920 THEN
	BEGIN
	   Start:=((PSel DIV 40)+1)*40;
	   Stop:=Start+39;
	   FOR i:=Start TO Stop DO
		 WITH Screen^.cars[i] DO
			IF (VTaille=1) OR (VTAille=3) THEN FlagDisable:=True;
	END;

	{ Disable des menus si besoin est }
	IF FlagPP THEN EnableItem(GetMHandle(EditMenu),OffPaste);
	IF FlagDisable THEN
	   BEGIN
		   DisableItem(theMenu,OffDH);
		   DisableItem(theMenu,OffDG);

		   IF (Taille=1) OR (Taille=3) THEN
			  BEGIN
			   CheckItem(theMenu,Taille+OffTaille,False);
			   Taille:=0;
			   CheckItem(theMenu,Taille+OffTaille,True);
			  END;

		   { on ne doit pas pouvoir coller en double hauteur }
		   IF FlagPP THEN
		   BEGIN
			   FlagSM:=False;
			   FOR i:=CpPSel TO CpDsel-1 DO
				 WITH cpScreen^.cars[i] DO
				  BEGIN
				   FlagSm:=FlagSm OR (Vtaille=1) OR (Vtaille=3);
				   IF Vtaille>=2 THEN i:=i+1;
				  END;
			   IF FlagSm THEN DisableItem(GetMHandle(EditMenu),OffPaste);
		   END;
	   END
	ELSE
	   BEGIN
		   EnableItem(theMenu,OffDH);
		   EnableItem(theMenu,OffDG);
	   END;

	FlagSM:=Jeu=1;
	FlagSM2:=False;
	EnableItem(theMenu,OffG1);

	IF NOT FlagSM THEN
	IF PSel<>DSel THEN
	  BEGIN
	   FOR i:=PSel TO DSel-1 DO
		WITH Screen^.Cars[i] DO
		 BEGIN
		   FlagSM:=FlagSM OR (Vjeu=1);
		   FlagSM2:=FlagSM2 OR (Vtaille=1) OR (Vtaille=2);
		   IF VTaille>=2 THEN i:=i+1;
		 END;
	  END
	ELSE IF PSel>0 THEN FlagSM:=Screen^.Cars[Psel-1].Vjeu=1;

	IF FlagSM THEN
	  BEGIN
		   DisableItem(theMenu,OffDH);
		   DisableItem(theMenu,OffDL);
		   DisableItem(theMenu,OffDG);
		   DisableItem(theMenu,OffInverse);
	  END;

	IF FlagSM2 OR Inverse THEN
	  BEGIN
		   DisableItem(theMenu,OffG1);
	  END;
END;


{$S COMPOSEUR}
{========================================================================
                     C U R S E U R    V I D E O T E X
 ========================================================================}
PROCEDURE VEIdle(QFenetre: WindowPtr);
    VAR R	    : rect;
        SavePort    : GrafPtr;
        PSel, DSel, mode  : Integer;
        SelRgn	    : RgnHandle;
        IdlePtr	    : BooleanPtr;
BEGIN
    IF QFenetre=Nil THEN EXIT(VEIdle);
    IF GetWRefCon(QFenetre)<>VRef THEN EXIT(VEIdle);

    GetPort(SavePort);
    SetPort(QFenetre);

    ClipRect(QFenetre^.PortRect);
    VEFindSelect(QFenetre,PSel,DSel,SelRgn,IdlePtr,mode);
	IF mode<>EditModeCst THEN EXIT(VEIdle);
    IF PSel=DSel THEN
      BEGIN
         IdlePtr^:=NOT IdlePtr^;
         IF FrontWindow=QFenetre THEN IdleFlag:=NOT IdleFlag;
         CalCur(Psel,R);
         InvertRect(R);
      END
      ELSE
      IF NOT IdlePtr^ THEN
         BEGIN
           IdlePtr^:=True;
           IF FrontWindow=QFenetre THEN IdleFlag:=True;
           PenMode(PatXor);
           PenPat(qd.ltgray);
           PaintRgn(SelRgn);
         END;

    SetPort(SavePort);
END;


PROCEDURE DrawSel(QFenetre: WindowPtr);

VAR PSel, DSel, mode  : Integer;
		SelRgn	    : RgnHandle;
		IdlePtr	    : BooleanPtr;

BEGIN
	VEFindSelect(QFenetre,PSel,DSel,SelRgn,IdlePtr,mode);
	IdlePtr^:= FALSE;
	VEIdle(QFenetre);
END;



{$S UPDATE}
PROCEDURE VEActivate(QFenetre: WindowPtr);
BEGIN
    IdleFlag:=False;
    SauveIdle;
    VEIdle(QFenetre);
END;


PROCEDURE VEDeActivate(QFenetre: WindowPtr);
BEGIN
    Curoff(QFenetre);
END;

{$S COMPOSEUR}
PROCEDURE TestScreen;
    VAR TheCode : Handle;
        C       : char;
        LgV, LgC, CurPos: Longint;
BEGIN
	IF BackFlag THEN
	BEGIN
		ErrorManager(BackErr,0);
		EXIT(TestScreen);
	END;
    WordEdAlign;
    IF NOT SnFlag THEN
    BEGIN
        ResetBuffer;
        C:=FF;
        TheCode:=Compact(Screen^.Cars);
        StartDataPaq;
        PAddBuffer(Ptr(Ord4(@C)+1),1);
        EndDataPaq;
        FlushBuffer;
        HLock(TheCode);
        CurPos:=0;
        LgV:=GetHandleSize(TheCode);
        WHILE CurPos<LgV DO
        BEGIN
             Lgc:=Lgv-CurPos; IF Lgc>128 THEN Lgc:=128;
             StartDataPaq;
             PAddBuffer(Ptr(Ord4(TheCode^)+CurPos),LgC);
             EndDataPaq;
             FlushBuffer;
             CurPos:=CurPos+Lgc;
        END;
        HUnlock(TheCode);
        GetIndString(gResStr,rSTRErrors,19);
		WWriteStr(gResStr);
		WWlnNum(Lgv,4);
        DisposHandle(TheCode);
    END;
END;


{========================================================================
                            I N V A L S E L
 ========================================================================}
PROCEDURE InvalSel(SupInval,EolFlag: boolean);
    VAR IAttrib: byte; i:integer; FlagScroll: boolean;
        k,j,x,y,XSel,LastCar: integer; R, R2, RC: Rect;
        InfFlag, SupFlag: Boolean; Rgn1,Rgn2: RgnHandle;
BEGIN
    IF Psel<>Dsel THEN
      BEGIN
       IF EolFlag THEN
          LastCar:=(PSel DIV 40)*40 + 39
          ELSE
          LastCar:=DSel-1;
       InfFlag:=False;
       SupFlag:=False;
       Curoff(ScreenPtr);
        { est ce qu'on affecte la ligne superieure }
        IF PSel>39 THEN
        BEGIN
           FlagScroll:=SupInval;
           FOR i:=PSel TO LastCar DO
             WITH Screen^.cars[i] DO
                IF (VTaille=1) OR (VTAille=3) THEN FlagScroll:=True;
           IF FlagScroll OR (Taille=1) OR (Taille=3)
              THEN {InvalLigne(PSel-40)} InfFlag:=True;
        END;
        { est ce qu'on affecte la ligne inferieure }
        IF PSel<920 THEN
        BEGIN
           FlagScroll:=False;
           FOR i:=PSel+40 TO LastCar+40 DO
             WITH Screen^.cars[i] DO
                IF (VTaille=1) OR (VTAille=3) THEN FlagScroll:=True;
           IF FlagScroll THEN {InvalLigne(PSel+40)} SupFlag:=True;
        END;
       IF InfFlag THEN DrawLine(PSel-40,LastCar-40);
       DrawLine(PSel,LastCar);
       { cliprect }
       IF SupFlag THEN
         BEGIN
             RC:=EditRect;
             Calcar(PSel,i,j,R);
             RC.bottom:=R.Bottom;
             Cliprect(RC);
             DrawLine(PSel+40,LastCar+40);
             cliprect(screenptr^.portrect);
         END;
       IF EolFlag OR SupInval THEN
       BEGIN { calcul nouvelle region de selection }
            Rgn1:=NewRgn;
            Rgn2:=NewRgn;
            FOR k:=Psel TO DSel-1 DO
            BEGIN
               j:=k MOD 40;
               i:=k DIV 40;
               SetRect(R2,10+j*8,10+i*10,10+(j+1)*8,10+(i+1)*10);
               CASE Screen^.Cars[k].VTaille OF
                  1: R2.top:=R2.top-10;
                  2: BEGIN
                       r2.right:=r2.right+8;
                       k:=k+1;
                     END;
                  3: BEGIN
                       R2.top:=R2.top-10;
                       r2.right:=r2.right+8;
                       k:=k+1;
                     END;
               END;
               RectRgn(rgn2,R2);
               UnionRgn(Rgn1,Rgn2,Rgn1);
            END;
            SetEmptyRgn(SelRgn);
            CopyRgn(Rgn1,SelRgn);
            disposeRgn(Rgn1);
            disposeRgn(Rgn2);
       END;
      END ELSE SetEmptyRgn(SelRgn);
END;


{$S COMPOSEUR}
{========================================================================
                            D O C O L O R
 ========================================================================}
PROCEDURE DoColorMenu(TheItem: Integer);

VAR	i: integer;
	flagDelim: BOOLEAN;
	
BEGIN
    Modification:=True;
    Memo;

    CASE TheItem OF

        OffCouleur..FinCouleur:
            BEGIN
                TheItem:=TheItem-OffCouleur;
                CASE TheItem OF
                    1: TheItem:=4;
                    2: TheItem:=1;
                    3: TheItem:=5;
                    4: TheItem:=2;
                    5: TheItem:=6;
                    6: TheItem:=3;
                END;
                Couleur:=TheItem;
                IF DSel<>PSel THEN
                FOR i:=PSel TO DSel-1 DO
                  WITH Screen^.cars[i] DO
                     VCouleur:=Couleur;
            END;

        OffBCouleur..FinBCouleur:
            BEGIN
                TheItem:=TheItem-OffBCouleur;
                CASE TheItem OF
                    1: TheItem:=4;
                    2: TheItem:=1;
                    3: TheItem:=5;
                    4: TheItem:=2;
                    5: TheItem:=6;
                    6: TheItem:=3;
                END;
                BCouleur:=TheItem;
				FlagDelim := FALSE;
                IF DSel<>PSel THEN
                FOR i:=PSel TO DSel-1 DO
                WITH Screen^.cars[i] DO
				BEGIN
					IF (VJeu=1) | (ValG01=' ') THEN FlagDelim := TRUE;
                    IF FlagDelim THEN VBCouleur:=BCouleur;
				END;
				
				IF FlagDelim THEN CheckDelim(DSel);	{ recopie du fond… }
            END;
    END;

(*
    InvalSel(False,False);
*)
		DrawLine(PSel,DSel);
		DrawSel(ScreenPtr);
		
    IdleTime:=TickCount;
END;


{$S COMPOSEUR}
{========================================================================
                                D O J E U
 ========================================================================}
PROCEDURE DoJeu(TheItem: Integer);
    VAR i, LastCar: integer; Att: byte; SupInval,EolInval: boolean;
        Fc, Fi, Fd, Fm,Fn: boolean;
BEGIN
    Modification:=True;
    Memo;
    SupInval:=False;
    EolInval:=False;

    CASE TheItem OF
        OffJeu..FinJeu:
            BEGIN
                TheItem:=TheItem-OffJeu;
				IF (TheItem=0) AND (Jeu=1) THEN
				BEGIN
                	IF DSel<>PSel THEN
                	FOR i:=PSel TO DSel-1 DO
                  	WITH Screen^.cars[i] DO
                    	VJeu:=TheItem;
				END ELSE
				IF (TheItem=1) AND (Jeu=0) THEN
				BEGIN
                	IF DSel<>PSel THEN
                	FOR i:=PSel TO DSel-1 DO
                  	WITH Screen^.cars[i] DO
					BEGIN
						IF NOT (((ValG01>=' ') AND (ValG01<='?')) OR
						   ((ValG01>=chr($60)) AND (ValG01<=chr($7F)))) THEN
							ValG01:=' ';
                    	VJeu:=TheItem;
					END;
				END;
				Jeu:=TheItem;
            END;

        OffTaille..FinTaille:
            BEGIN
                EolInval:=True;
                Taille:=TheItem-OffTaille;
                i:=PSel;
                LastCar:=(PSel DIV 40)*40 + 39;
                WHILE (i<DSel) DO
                BEGIN
                  WITH Screen^.cars[i] DO
                    BEGIN
                       SupInval:=SupInval OR (VTaille>0);
                       IF (VTaille<>Taille) THEN
                       BEGIN
                        IF (VTaille < 2) AND (Taille >=2) THEN
                           BEGIN { taille augmente }
                            { decalage des autres car a droite }
                            BlockMoveData(ptr(ord4(Screen)+SizeOf(TCar)*(i+1)),
                                      ptr(ord4(Screen)+SizeOf(TCar)*(i+2)),
                                      SizeOf(TCar)*(Lastcar-i-1));
                            DSel:=DSel+1; i:=i+1;
                           END
                        ELSE
                        IF ((VTaille = 2) AND (Taille=3)) OR
                           ((VTaille = 3) AND (Taille=2)) THEN
                           BEGIN
                            i:=i+1;
                           END
                        ELSE
                        IF (VTaille >= 2) AND (Taille <2) THEN
                           BEGIN { taille diminue }
                            { decalage des autres car a gauche }
                            BlockMoveData(ptr(ord4(Screen)+SizeOf(TCar)*(i+2)),
                                      ptr(ord4(Screen)+SizeOf(TCar)*(i+1)),
                                      SizeOf(TCar)*(Lastcar-i-1));
                            Screen^.cars[LastCar]:=CarNeutre;
                            DSel:=DSel-1;
                           END
                       END;
                     VTaille:=taille;
                     IF Dsel>LastCar THEN DSel:=LastCar;
                     END;
               i:=i+1;
               END;
            END;

        OffClign:
            BEGIN
                Clignotement:=NOT Clignotement;
                IF DSel<>PSel THEN
                FOR i:=PSel TO DSel-1 DO
                  WITH Screen^.cars[i] DO
                    BEGIN
                        GetAttrib(VFlags,fc,fd,fm,fi,fn);
                        VFlags:=SetAttrib(Clignotement,fd,fm,fi,fn);
                    END;
            END;

        OffDisjoint:
            BEGIN
                Disjoint:=NOT Disjoint;
                IF DSel<>PSel THEN
                FOR i:=PSel TO DSel-1 DO
                  WITH Screen^.cars[i] DO
                    BEGIN
                        GetAttrib(VFlags,fc,fd,fm,fi,fn);
                        VFlags:=SetAttrib(fc,Disjoint,fm,fi,fn);
                    END;
            END;

        OffMasquage:
            BEGIN
                Masquage:=NOT Masquage;
                IF DSel<>PSel THEN
                FOR i:=PSel TO DSel-1 DO
                  WITH Screen^.cars[i] DO
                    BEGIN
                        GetAttrib(VFlags,fc,fd,fm,fi,fn);
                        VFlags:=SetAttrib(fc,fd,Masquage,fi,fn);
                    END;
            END;

        OffInverse:
            BEGIN
                Inverse:=NOT Inverse;
                IF DSel<>PSel THEN
                FOR i:=PSel TO DSel-1 DO
                  WITH Screen^.cars[i] DO
                    BEGIN
                        GetAttrib(VFlags,fc,fd,fm,fi,fn);
                        VFlags:=SetAttrib(fc,fd,fm,Inverse,fn);
                    END;
            END;

        OffIncrust:
            BEGIN
                Incrust:=NOT Incrust;
                IF DSel<>PSel THEN
                FOR i:=PSel TO DSel-1 DO
                  WITH Screen^.cars[i] DO
                    BEGIN
                        GetAttrib(VFlags,fc,fd,fm,fi,fn);
                        VFlags:=SetAttrib(fc,fd,fm,fi,Incrust);
                    END;
            END;

        OffAttNormaux:
            BEGIN
                DoColorMenu(FinCouleur);
                DoColorMenu(OffBCouleur);
                DoJeu(OffJeu);
                DoJeu(OffTaille);
                IF Clignotement THEN DoJeu(OffClign);
                IF Disjoint THEN DoJeu(OffDisjoint);
                IF Masquage THEN DoJeu(OffMasquage);
                IF Inverse THEN DoJeu(OffInverse);
                IF Incrust THEN DoJeu(OffIncrust);
            END;

    END;
(*
    InvalSel(SupInval,EolInval);
*)
		DrawLine(PSel,DSel);
		DrawSel(ScreenPtr);
		
    IdleTime:=TickCount;
END;


{========================================================================
      K E Y D O W N   - - -   A U T O K E Y   - - -   V I D E O T E X
 ========================================================================}
PROCEDURE VEKey(C: char);
    VAR FlagScroll, InfFlag, SupFlag: boolean;
        i,j,x,y,XSel,LastCar,FirstCar: integer;
        R,Rb:rect;
BEGIN

    InfFlag:=False;
    SupFlag:=False;
    { suppression de la selection }
    Curoff(ScreenPtr);
    SetEmptyRgn(SelRgn);

    FirstCar:=PSel;
    LastCar:=(PSel DIV 40)*40 +39;

     { est ce qu'on affecte la ligne superieure }
     IF PSel>39 THEN
     BEGIN
        FlagScroll:=False;
        FOR i:=PSel TO LastCar DO
          WITH Screen^.cars[i] DO
             IF (VTaille=1) OR (VTAille=3) THEN FlagScroll:=True;
        IF FlagScroll OR (Taille=1) OR (Taille=3)
           THEN InfFlag:=True;
     END;

     { est ce qu'on affecte la ligne inferieure }
     IF PSel<920 THEN
     BEGIN
        FlagScroll:=False;
        FOR i:=PSel+40 TO Lastcar+40 DO
          WITH Screen^.cars[i] DO
             IF (VTaille=1) OR (VTAille=3) THEN FlagScroll:=True;
        IF FlagScroll THEN SupFlag:=True;
     END;

    IF PSel<>DSel THEN
       BEGIN
            { suppression selection }
            BlockMoveData(ptr(ord4(Screen)+SizeOf(TCar)*(DSel)),
                      ptr(ord4(Screen)+SizeOf(TCar)*(PSel)),
                      SizeOf(TCar)*(Lastcar-DSel+1));
            FOR i:=Lastcar-(DSel-PSel-1) TO LastCar DO
              Screen^.cars[i]:=CarNeutre;
            IdleFlag:=False;
       END;

    IF Ord(c)=8	    { backspace }
        THEN
         BEGIN
            IF PSel=DSel   { il faut reculer d'une place }
               THEN
                  BEGIN
                    CASE Taille OF
                        0,1: PSel:=PSel-1;
                        2,3: PSel:=PSel-2;
                    END;
                    IF Psel<0 THEN PSel:=0;
                  END
         END
    ELSE
    IF Ord(c)=13     { return }
        THEN
         BEGIN
            IF PSel=DSel   { il faut avancer d'une ligne en se mettant au debut }
               THEN
                  BEGIN
                    CASE Taille OF
                        0,2: PSel:=PSel+40;
                        1,3: PSel:=PSel+80;
                    END;
                    PSel:=(PSel DIV 40)*40;
                    IF PSel>=nbcar THEN PSel:=0;
                  END
         END
    ELSE
    { Insertion du caractere }
    IF (ord(C)>=32) THEN
    BEGIN
        x:=0;
        IF (taille=2) OR (taille=3) THEN
            x:=1;
                BlockMoveData(ptr(ord4(Screen)+SizeOf(TCar)*(PSel)),
                          ptr(ord4(Screen)+SizeOf(TCar)*(PSel+1+x)),
                          SizeOf(TCar)*(Lastcar-PSel-x));
        WITH Screen^.Cars[PSel] DO
          BEGIN
		  	ValG01:=C;
			Vjeu:=jeu MOD 2;
            VCouleur:=Couleur;
            VBCouleur:=BCouleur;
            VTAille:=Taille;
            VFlags:=SetAttrib(Clignotement,Disjoint,Masquage,Inverse,Incrust);
          END;
        IF (taille=2) OR (taille=3) THEN
            psel:=psel+1;
        PSel:=PSel+1;
        IF ((psel MOD 40)=0) OR ((psel MOD 40)=1) THEN
           BEGIN {IdleFlag:=True;}
                 IF (taille=1) OR (taille=3) THEN
                    IF psel<=880 THEN psel:=psel+40;
           END;
        IF PSel>=NbCar THEN PSel:=0;
    END;

    DSel:=PSel;
    SauveSel;
    IF InfFlag THEN DrawLine(FirstCar-40,Lastcar-40);
    DrawLine(FirstCar,Lastcar);
    IF SupFlag THEN
      BEGIN
          Rb:=EditRect;
          Calcar(PSel,i,j,R);
          Rb.bottom:=R.Bottom;
          Cliprect(Rb);
          DrawLine(PSel+40,DSel+40);
          cliprect(screenptr^.portrect);
      END;
    AffCurPos;
END;


{$S UPDATE}
{========================================================================
                D E S S I N    E C R A N    V I D E O T E X
 ========================================================================}
PROCEDURE MonWDraw;

VAR R,D: Rect; i,j,c: integer; AffOk, AffFlag: boolean;

BEGIN
	Setport(ScreenPtr);
	SetCursor(GetCursor(WatchCursor)^^);		{ la montre… }
  
	{ dessin du cadre gris }
	PenMode(PatCopy);
    PenSize(3,3);
    PenPat(qd.Gray);
    SetRect(R,10-3,10-3,10+320+3,10+240+3);
    FrameRect(R);
    DrawJeu;
    AffCurPos;
    TextMode(srcxor);
    ClipRect(EditRect);
    
		IF ShowColor THEN	{ on efface la zone d'édition avec du noir }
		BEGIN
			BackColor(blackColor);
			EraseRect(EditRect);
			BackColor(WhiteColor);
		END;
		
		{ dessin de l'image vidéotex… }
		AffOk:=False;
    FOR i:=0 TO 23 DO
		BEGIN
			c:=i*40;
			CalCar(c,i,j,D);
			SetRect(R,D.Left,D.top,10+320+3,D.bottom);
			AffFlag:=RectInRgn(R,ScreenPtr^.VisRgn);
			IF AffFlag & (i<=23) THEN
			BEGIN
				Drawline(c,c+39);
				AffOk:=True;
			END
			ELSE
			IF AffOk & (i<=23) THEN
			BEGIN
				Drawline(c,c+39);
				AffOk:=False;
			END;
		END;
    ClipRect(ScreenPtr^.portrect);
    ValidRect(EditRect);
END;

