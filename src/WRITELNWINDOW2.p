{$IFC qWWdebug}
{$r+}
{$D+}
{$ELSEC}
{$r-}
{$D-}
{$ENDC}

USES TextUtils;

CONST
    kWWHMargin = 5;
    kWWVMargin = 10;


TYPE
    ZHLineArray =   ^ZPLineArray;
    ZPLineArray =   ^ZLineArray;
    ZLineArray  =   ARRAY[1..100] OF StringHandle;

VAR gSavedLines:     ZHLineArray;		     {the saved lines}
    gNSavedLines:    INTEGER;			     {how many lines we save as StringHandles}
    gCurLine:	     Str255;			     {the last line (not included in gNSavedLines)}
    gSizeCurLine:    INTEGER;			     {number of characters in gCurLine}

    gHideCur:	     Boolean;
    gCurRect:	     Rect;			     {rectangle du curseur}
    gCurState:	     Integer;			     {etat du curseur}
    gWidth:	     INTEGER;			     {font gWidth}
    gHeight:	     INTEGER;			     {font gHeight}
    gLnAscent:	     INTEGER;			     {font ascent}
    gSBars:	     ARRAY[VHSelect] OF ControlHandle;	 {the xyzafWindow scroll bars}
    gScrollOffset:   Point;			     {the position to which we are scrolled}
    gViewSize:	     Point;			     {total xyzitsfView size}
    gEndOfText:	     Point;			     {the pen position after drawing all the lines}

    gStdDrag:	     Rect;
    gStdSize:	     Rect;
    gOrthogonal:     ARRAY[VHSelect] OF VHSelect;
    gWRec:	     WindowRecord;
    gARgn:	     RgnHandle;

FUNCTION  GetSaveVisRgn: RgnHandle; FORWARD;

PROCEDURE WWAddText(textBuf: Ptr; byteCount: INTEGER); FORWARD;
FUNCTION  WWBaseLine(ln: INTEGER): INTEGER; FORWARD;
PROCEDURE WWDoScrolling; FORWARD;
PROCEDURE WWDraw; FORWARD;
PROCEDURE WWCursor; FORWARD;
PROCEDURE WWHideCursor; FORWARD;
PROCEDURE WWGrown; FORWARD;
PROCEDURE WWInvalGrowBox; FORWARD;
PROCEDURE WWNewLine; FORWARD;
PROCEDURE WWShowPoint(pt: Point); FORWARD;
PROCEDURE WWTrackScroll(aControl: ControlHandle; partCode: INTEGER); FORWARD;


{$S TRACE}
FUNCTION  GetSaveVisRgn: RgnHandle;
    CONST   addr    =   $09F2;
    TYPE    pRgn = ^RgnHandle;
    VAR	    pSaveVisRgn:    pRgn;
BEGIN
    pSaveVisRgn := pRgn(addr);
    GetSaveVisRgn := pSaveVisRgn^;
END;


{$S TRACE}
FUNCTION  LongerSide(VAR r: Rect): VHSelect;
BEGIN
    WITH r DO
        IF (bottom - top) >= (left - right) THEN
            LongerSide := v
        ELSE
            LongerSide := h;
END;


{$S TRACE}
PROCEDURE WindowFocus;
BEGIN
    SetPort(gDebugWindowPtr);
    SetOrigin(0, 0);
    ClipRect(thePort^.portRect);
    SetRect(gCurRect,0,0,0,0);
END;


{$S TRACE}
PROCEDURE ContentFocus;
    VAR r:  Rect;
BEGIN
    SetPort(gDebugWindowPtr);
    SetOrigin(gScrollOffset.h, gScrollOffset.v);
    r := thePort^.portRect;
    WITH r DO
        BEGIN
        right := right - 15;
        bottom := bottom - 15;
        END;
    ClipRect(r);
END;



{$S TRACE}
PROCEDURE WWInit;
BEGIN
    gDebugWindowPtr := NIL;

    gSavedLines := NIL;
    gOrthogonal[v] := h;
    gOrthogonal[h] := v;
    gHideCur := FALSE;
END;



{$S TRACE}
PROCEDURE WWNew(bounds: Rect; windowTitle: Str255; goAway: BOOLEAN; visible: BOOLEAN;
                linesToSave, outputFont, outputSize: INTEGER);
    VAR fInfo:	    FontInfo;
        control:    ControlHandle;
        i:	    INTEGER;
        aLine:	    StringHandle;
        vhs:	    VHSelect;
BEGIN
    IF (gDebugWindowPtr = NIL) AND (linesToSave > 0) THEN
        BEGIN
        gDebugWindowPtr := NewWindow(@gWRec, bounds, windowTitle, visible, documentProc,
                                    POINTER(-1), goAway, 0);

        WITH screenBits.bounds DO
            BEGIN
            SetRect(gStdDrag, 4, 24, right - 4, bottom - 4);    {this is suggested in Inside Macintosh}
            SetRect(gStdSize, 20, 20, right, bottom - 20);      {arbitrary Min size; Max size is screen}
            END;

        gARgn := NewRgn;

        gNSavedLines := linesToSave - 1;
        gSavedLines := ZHLineArray(NewHandle(SIZEOF(StringHandle) * gNSavedLines));

        {start off with all lines blank}
        FOR i := 1 TO gNSavedLines DO
            BEGIN
            aLine := NewString('');
            gSavedLines^^[i] := aLine;
            END;
        gSizeCurLine := 0;

        SetPt(gEndOfText, kWWHMargin, WWBaseLine(linesToSave));

        SetPort(gDebugWindowPtr);
        TextFont(outputFont);
        TextSize(outputSize);
        TextMode(srcCopy);
        PenMode(patCopy);
        GetFontInfo(fInfo);

        WITH fInfo DO
            BEGIN
            gWidth := widmax;
            gHeight := ascent + descent + leading;
            gLnAscent := ascent;
            SetPt(gViewSize, (2 * kWWHMargin) + (255 * widMax), (2 * kWWVMargin) + (gHeight * linesToSave));
            END;

        {scroll bars}
        FOR vhs := v TO h DO
            gSBars[vhs] := NewControl(gDebugWindowPtr, gDebugWindowPtr^.portRect, '', FALSE,
                                0, 0, 1, scrollBarProc, 0);

        {SetPt(gScrollOffset, 0, 0);}
        gScrollOffset := Point(0);

        {put the scroll bars in the right place}
        WWGrown;

        {PlSetWrPort(gDebugWindowPtr);}
        {PLSetWProc(@WWAddText);}
        END;
END;


{$S UPDATE}
PROCEDURE WWActivateEvent(activate: BOOLEAN);
    VAR r:	    Rect;
        vhs:	    VHSelect;
        anSBar:	      ControlHandle;
        savePort:   GrafPtr;
BEGIN
    GetPort(savePort);

    WindowFocus;

    r := thePort^.portRect;

    FOR vhs := v TO h DO
        BEGIN
        anSBar := gSBars[vhs];
        IF activate THEN
            ShowControl(anSBar)
        ELSE
            BEGIN
            WWHideCursor;
            HideControl(anSBar);
            END;
        END;

    DrawGrowIcon(gDebugWindowPtr);

    SetPort(savePort);
END;


{$S TRACE}
PROCEDURE WWAddText(textBuf: Ptr; byteCount: INTEGER);
    CONST BackSpace = CHR($08);
          HTab	    = CHR($09);
          Space	    = CHR($20);
    VAR destPtr:    Ptr;
        done:	    BOOLEAN;
        b:	    QDByte;
        startPtr,
        affPtr:	    Ptr;
        startCount: INTEGER;
        ps:	    PenState;
        savePort:   GrafPtr;
        nbcar,
        nbbs,
        nbdc,
        nbsp:	    Integer;
        er:	    rect;

BEGIN
    GetPort(savePort);

    WHILE byteCount > 0 DO
        BEGIN

        destPtr := Ptr(ORD(@gCurLine) + gSizeCurLine + 1);    {leave 1 byte for string size}
        nbbs := 0;
        nbdc := 0;
        nbsp := 0;

        done := FALSE;
        startPtr := textBuf;
        startCount := byteCount;
        affPtr := Ptr(ORD(@gCurLine) + gSizeCurLine + 1);

        WHILE (byteCount > 0) AND (gSizeCurLine < 255) AND (NOT done) DO
            BEGIN
            b := QDPtr(textBuf)^;
            byteCount := byteCount - 1;
            textBuf := Ptr(LONGINT(textBuf) + 1);

            IF b = ORD(kWWEol) THEN
                done := TRUE
            ELSE
            IF b = ORD(BackSpace) THEN
              IF gSizeCurLine>0 THEN
                BEGIN
                nbbs := nbbs + 1;
                nbdc := nbdc + 1;
                gSizeCurLine := gSizeCurLine - 1;
                destPtr := Ptr(LONGINT(destPtr) - 1);
                END
                ELSE nbbs := nbbs + 1
            ELSE
            IF b = ORD(HTab) THEN
                BEGIN
                nbcar := 8 - (gSizeCurline MOD 8);
                IF (gSizeCurline + nbcar)<=255 THEN
                   BEGIN
                   nbsp := nbsp + nbcar;
                   WHILE nbcar<>0 DO
                        BEGIN
                                QDPtr(destPtr)^ := ORD(Space);
                                nbcar := PRED(nbcar);
                                gSizeCurLine := gSizeCurLine + 1;
                                destPtr := Ptr(LONGINT(destPtr) + 1);
                        END
                   END
                   ELSE done := TRUE;
                END
            ELSE
            IF (b IN [10,11]) THEN
                BEGIN
                        nbbs:=nbbs+1;
                END
            ELSE
                BEGIN
                QDPtr(destPtr)^ := b;
                gSizeCurLine := gSizeCurLine + 1;
                destPtr := Ptr(LONGINT(destPtr) + 1);
                END;
            END;

        ContentFocus;
        MoveTo(gEndOfText.h - (nbdc*gWidth), gEndOfText.v);
        IF done THEN
        DrawText(QDPtr(affPtr), 0, (startCount - byteCount)+nbsp-nbdc-nbbs-1)
        ELSE
        DrawText(QDPtr(affPtr), 0, (startCount - byteCount)+nbsp-nbdc-nbbs);
        GetPenState(ps);
        gEndOfText := ps.pnLoc;
        SetRect(er, gEndOfText.h, gEndOfText.v - gLnAscent,
                    gEndOfText.h + 1000, gEndOfText.v + gHeight - gLnAscent );
        EraseRect(er);

        IF (gSizeCurLine >= 255) OR done THEN
            BEGIN
            gHideCur := TRUE;
            WWNewLine;
            gHideCur := FALSE;
            END;
        END;
        { dessin du curseur }
        WWCursor;

    SetPort(savePort);
END;


PROCEDURE WWriteStr(TheStr: Str255);
BEGIN
	IF Length(TheStr)>0 THEN
		WWAddText(Ptr(Ord4(@TheStr)+1), length(TheStr));
END;


PROCEDURE WWriteCh(TheChr: Char);
BEGIN
	WWAddText(Ptr(Ord4(@TheChr)+1), 1);
END;


PROCEDURE WWriteNum(NumToWrite: longint; TheLength: integer);
	VAR TheStr: str255;
BEGIN
	NumToString(NumToWrite,TheStr);
	IF TheLength>255 THEN TheLength:=255;
	WHILE length(TheStr)<TheLength DO
		Insert(' ',TheStr,1);
	WWAddText(Ptr(Ord4(@TheStr)+1), length(TheStr));
END;


PROCEDURE WWlnStr(TheStr: Str255);
BEGIN
	IF Length(TheStr)>0 THEN
		WWAddText(Ptr(Ord4(@TheStr)+1), length(TheStr));
	TheStr[1]:=chr(13);
	WWAddText(Ptr(Ord4(@TheStr)+1), 1);
END;


PROCEDURE WWlnNum(NumToWrite: longint; TheLength: integer);
	VAR TheStr: str255;
BEGIN
	NumToString(NumToWrite,TheStr);
	IF TheLength>255 THEN TheLength:=255;
	WHILE length(TheStr)<TheLength DO
		Insert(' ',TheStr,1);
	WWAddText(Ptr(Ord4(@TheStr)+1), length(TheStr));
	TheStr[1]:=chr(13);
	WWAddText(Ptr(Ord4(@TheStr)+1), 1);
END;



{$S TRACE}
FUNCTION  WWBaseLine(ln: INTEGER): INTEGER;
BEGIN
    WWBaseLine := kWWVMargin + (ln - 1) * gHeight;
END;


{$S TRACE}
PROCEDURE WWDoScrolling;
    VAR newOffset:      Point;
        delta:	        Point;
BEGIN
    newOffset.v := GetCtlValue(gSBars[v]);
    delta.v := gScrollOffset.v - newOffset.v;
    newOffset.h := GetCtlValue(gSBars[h]);
    delta.h := gScrollOffset.h - newOffset.h;

    IF (delta.h <> 0) | (delta.v <> 0) THEN
    BEGIN
        ContentFocus;
        ScrollRect(thePort^.portRect, delta.h, delta.v, gARgn);
        gScrollOffset := newOffset;
        InvalRgn(gARgn);
        WWUpdateEvent;
    END;
END;


{$S UPDATE}
PROCEDURE WWDraw;
    VAR i:      INTEGER;
        y:      INTEGER;
        aLine:  StringHandle;
        ps:     PenState;
BEGIN
    y := kWWVMargin;

    FOR i := 1 TO gNSavedLines DO
        BEGIN
        aLine := gSavedLines^^[i];

        MoveTo(kWWHMargin, y);

        HLock(Handle(aLine));
        DrawString(aLine^^);
        HUnlock(Handle(aLine));

        y := y + gHeight;
        END;

    MoveTo(kWWHMargin, y);
    DrawText(QDPtr(@gCurLine), 1, gSizeCurLine);

    GetPenState(ps);
    gEndOfText := ps.pnLoc;
    WWCursor;
END;


{$S UPDATE}
PROCEDURE WWCursor;
BEGIN
        IF gHideCur THEN EXIT(WWCursor);
        SetRect(gCurRect,gEndOfText.h,gEndOfText.v-gLnAscent,
                  gEndOfText.h+gWidth, gEndOfText.v+gHeight-gLnAscent);
        FillRect(gCurRect,black);
        gCurState := 0;
END;



{$S TRACE}
PROCEDURE WWIdle;
BEGIN
        IF gHideCur THEN EXIT(WWIdle);
        IF gDebugWindowPtr = FrontWindow THEN
           BEGIN
                SetPort(gDebugWindowPtr);
                gCurState := (gCurState + 1) MOD 8;
                CASE gCurState OF
                        0: FillRect(gCurRect, black);
                        1,7: FillRect(gCurRect, dkgray);
                        2,6: FillRect(gCurRect, gray);
                        3,5: FillRect(gCurRect, ltgray);
                        4: FillRect(gCurRect, white);
                END;
           END;
END;


{$S UPDATE}
PROCEDURE WWHideCursor;
BEGIN
        FillRect(gCurRect,white);
        gCurState := 0;
END;


{$S TRACE}
PROCEDURE WWGrown;
    VAR r:	        Rect;
        vhs:	        VHSelect;
        anSBar:		  ControlHandle;
        newMax:	        INTEGER;
        isVisible:      BOOLEAN;
        savePort:       GrafPtr;
BEGIN
    GetPort(savePort);

    WindowFocus;
    r.topLeft := Point(0);
    r.botRight := Point(0);
    ClipRect(r);

    FOR vhs := v TO h DO
        BEGIN
        anSBar := gSBars[vhs];

        r := thePort^.portRect;

        WITH r DO
            BEGIN
            {Calculate new position of scroll bar}
            topLeft.vh[vhs] := topLeft.vh[vhs] - 1;
            topLeft.vh[gOrthogonal[vhs]] := botRight.vh[gOrthogonal[vhs]] - 15;
            botRight.vh[vhs] := botRight.vh[vhs] - 14;
            botRight.vh[gOrthogonal[vhs]] := topLeft.vh[gOrthogonal[vhs]] + 16;

            {Move the scroll bar}
            MoveControl(anSBar, left, top);
            SizeControl(anSBar, right-left, bottom-top);

            newMax := gViewSize.vh[vhs] - (bottom - top);
            IF newMax < 0 THEN
                newMax := 0;
            SetCtlMax(anSBar, newMax);
            END;
        END;

    WWInvalGrowBox;

    WWDoScrolling;  {in case we are showing too much white space}

    SetPort(savePort);
END;


{$S TRACE}
PROCEDURE WWInvalGrowBox;
    VAR r:  Rect;
BEGIN
    r.botRight := thePort^.portRect.botRight;
    WITH r DO
        BEGIN
        top := bottom - 15;
        left := right - 15;
        END;
    InvalRect(r);
END;


{$S TRACE}
PROCEDURE WWMouseDown(where: INTEGER; pt: Point; modifiers: INTEGER);
    VAR r:	        Rect;
        sizeStuff:      RECORD CASE INTEGER OF
                            1:  (growResult: LONGINT);	    {Information returned by GrowRect}
                            2:  (newV,			    {new vertical size}
                                 newH: INTEGER);	    {new horizontal size}
                            3:  (newSize: Point);	    {new size as a point}
                        END;
        partCode:       INTEGER;
        whichControl:   ControlHandle;
        oldSize:        Point;
        savePort:       GrafPtr;
BEGIN
    GetPort(savePort);

    CASE where OF
        inDrag:
            DragWindow(gDebugWindowPtr, pt, gStdDrag);

        inGrow:
            BEGIN
            WindowFocus;

            WITH sizeStuff DO
                BEGIN
                WITH gDebugWindowPtr^.portRect, oldSize DO
                    BEGIN
                    h := right - left;
                    v := bottom - top;
                    END;

                growResult := GrowWindow(gDebugWindowPtr, pt, gStdSize);
                IF growResult <> 0 THEN
                    BEGIN
                    WWInvalGrowBox;
                    SizeWindow(gDebugWindowPtr, newH, newV, TRUE);
                    WWGrown;
                    END;
                END;
            WWInvalGrowBox;
            END;

        inGoAway:
            IF TrackGoAway(gDebugWindowPtr, pt) THEN
                HideWindow(gDebugWindowPtr);

        inContent:
            IF gDebugWindowPtr = FrontWindow THEN
                BEGIN
                WindowFocus;

                GlobalToLocal(pt);
                partCode := FindControl(pt, gDebugWindowPtr, whichControl);
                IF partCode <> 0 THEN
                    CASE partCode OF
                        inUpButton, inDownButton, inPageUp, inPageDown:
                            partCode := TrackControl(whichControl, pt, @WWTrackScroll);
                        inThumb:
                            BEGIN
                            partCode := TrackControl(whichControl, pt, NIL);
                            WWDoScrolling;
                            END;
                        END;
                WWInvalGrowBox;
                END
            ELSE
                SelectWindow(gDebugWindowPtr);
        END;  {CASE}

    SetPort(savePort);
END;


{$S TRACE}
PROCEDURE WWNewLine;
    VAR savePort:       GrafPtr;
        i:	        INTEGER;
        s:	        StringHandle;
        pt:	        Point;
        r:	        Rect;
        p:	        QDPtr;
BEGIN
    GetPort(savePort);

    SetPt(pt, kWWHMargin, gEndOfText.v);
    WWShowPoint(pt);

    s := gSavedLines^^[1];
    FOR i := 2 TO gNSavedLines DO
        gSavedLines^^[i-1] := gSavedLines^^[i];

    gSavedLines^^[gNSavedLines] := s;

    p := @gCurLine;
    IF gSizeCurLine > 127 THEN
        p^ := gSizeCurLine - 256
    ELSE
        p^ := gSizeCurLine;

    SetString(s, gCurLine);

    gSizeCurLine := 0;

    ContentFocus;
    SetRect(r, kWWHMargin, kWWVMargin - gLnAscent, gViewSize.h, gEndOfText.v + gHeight - gLnAscent);
    ScrollRect(r, 0, -gHeight, gARgn);
    InvalRgn(gARgn);

    WWUpdateEvent;

    SetPort(savePort);
END;


PROCEDURE WWShowPoint(pt: Point);
    VAR minToSee:   Point;
        deltaCd:    INTEGER;
		
BEGIN
    WindowFocus;

    SetPt(minToSee, 50, gHeight);

    {the following code is actually better than writing a loop with VHSelect}
    WITH thePort^.portRect DO
	BEGIN
		deltaCd := pt.v + mintoSee.v - (bottom - 15 + gScrollOffset.v);
        IF deltaCd <= 0 THEN
        BEGIN
            deltaCd := pt.v - minToSee.v - (top + gScrollOffset.v);
            IF deltaCd >= 0 THEN deltaCd := 0;
        END;
        IF deltaCd<>0 THEN SetCtlValue(gSBars[v], GetCtlValue(gSBars[v]) + deltaCd);

        deltaCd := pt.h + mintoSee.h - (right - 15 + gScrollOffset.h);
        IF deltaCd <= 0 THEN
        BEGIN
            deltaCd := pt.h - minToSee.h - (left + gScrollOffset.h);
            IF deltaCd >= 0 THEN deltaCd := 0;
        END;
        IF deltaCd<>0 THEN SetCtlValue(gSBars[h], GetCtlValue(gSBars[h]) + deltaCd);
	END;

    WWDoScrolling;
END;


{$S TRACE}
PROCEDURE WWTrackScroll(aControl: ControlHandle; partCode: INTEGER);
    VAR up:	    BOOLEAN;
        ctlValue:   INTEGER;
        vhs:	    VHSelect;
        r:	    Rect;
        delta:	    INTEGER;
BEGIN
    IF partCode <> 0 THEN
        BEGIN
        up := (partCode = inUpButton) OR (partCode = inPageUp);
        ctlValue := GetCtlValue(aControl);

      {avoid flicker in setting thumb, IF user tries to scroll past end}
        IF (up AND (ctlValue > GetCtlMin(aControl))) OR
           (NOT up AND (ctlValue < GetCtlMax(aControl))) THEN
            BEGIN
            r := aControl^^.contrlRect;	  {heap may compact when we call LongerSide}
            vhs := LongerSide(r);	    {this tells us which way we are scrolling}

            IF (partCode = inPageUp) OR (partCode = inPageDown) THEN
                WITH gDebugWindowPtr^.portRect DO
                    delta := botRight.vh[vhs] - topLeft.vh[vhs] - gHeight
            ELSE
                delta := gHeight;

            IF up THEN
                delta := - delta;

            SetCtlValue(aControl, ctlValue + delta);
            WWDoScrolling;

            WindowFocus;
            END;
        END;
END;


{$S UPDATE}
PROCEDURE WWUpdateEvent;
    VAR savePort:       GrafPtr;
        saveSaveVisRgn: RgnHandle;
        saveVisRgn:     RgnHandle;
BEGIN
    GetPort(savePort);

    saveSaveVisRgn := NewRgn;
    saveVisRgn := GetSaveVisRgn;

    CopyRgn(saveVisRgn, saveSaveVisRgn);

    BeginUpdate(gDebugWindowPtr);

    WindowFocus;

    EraseRect(thePort^.portRect);

    DrawGrowIcon(gDebugWindowPtr);
    DrawControls(gDebugWindowPtr);

    ContentFocus;
    WWDraw;

    EndUpdate(gDebugWindowPtr);

    CopyRgn(saveSaveVisRgn, saveVisRgn);
    DisposeRgn(saveSaveVisRgn);

    SetPort(savePort);
END;

