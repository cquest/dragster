UNIT DrgDcmd;

(* The following MPW commands will build the dcmd and copy it to the
   "Debugger Prefs" file in the System folder. The dcmd's name in
		 MacsBug will be the name of the file built by the Linker.

	    Pascal DrgDcmd.p
	    Link -w -sg Main=PASLIB {Libraries}dcmdGlue.a.o DrgDcmd.p.o "{Libraries}"Interface.o {Libraries}Runtime.o {PLibraries}PasLib.o -o DrgDcmd
	    BuildDcmd DrgDcmd 102
			Echo 'include "DrgDcmd";'			|			Rez -a -o "Cris40:[divers]:dcmds:Debugger Prefs"
*)

{$R-}

INTERFACE

		USES MemTypes, memory, dcmd, SysEqu, ADSP, Files, Devices,Packages, TextUtils;
		

		PROCEDURE CommandEntry (paramPtr: dcmdBlockPtr);


IMPLEMENTATION

CONST CR = $0D;

{$I DragsterTCB.p }

Type
	UTable = array[0..0] of DCtlHandle;
	UPtr = ^UTable;
	DrvrHdr= record
				Dummy: array[0..8] of integer;
				DrvrName: str255;
			 end;
	DrvrHdrPtr = ^DrvrHdr;
	DrvrHdrHdl = ^DrvrHdrPtr;
	IPtr = ^INTEGER;
	
	LIPtr = ^LONGINT;
	

PROCEDURE CommandEntry (paramPtr: DCmdBlockPtr);

		
		Function RechDrag: integer;
		
			var TheUPtr	: UPtr;
				Termine	: Boolean;
				i		: integer;
		begin
			TheUptr:=UPtr(LIPtr(UTableBase)^);	{ Add. Table des Drivers }
			i:=IPtr(UnitNtryCnt)^-1;				{ Nombre de Drivers maxi. }
			termine:=False;
			While (not termine) and (i>12) do
			begin
				if (TheUPtr^[i]<>Nil) { a driver is here }
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
		
		Procedure MConv(Var TheStr: Str255; TheNum: Longint; len: integer);
		
		Var i: integer;
				
		begin
			for i:=len downto 1 do
			BEGIN
				IF theNum>0 THEN
					TheStr[i]:=chr(ord('0')+TheNum mod 10)
				ELSE
					TheStr[i] := ' ';
				theNum := theNum DIV 10;
			END;
			TheStr[0] := CHR(len);
			IF theStr[len]=' ' THEN theStr[len]:='0';
		end;
		
		Procedure MHConv(Var TheStr: Str255; TheNum: Longint; len: integer);
		Var i,j: integer;
		
		begin
			for i:=len downto 1 do
			begin
				j:=band(TheNum,$0F);
				TheNum:=bsr(thenum,4);
				If j<10 then
					TheStr[i]:=chr(ord('0')+j)
				else
					TheStr[i]:=chr(ord('A')-10+j);
			end;
			theStr[0] := chr(Len);
		end;


		FUNCTION GetScreenName(theNScreen: INTEGER; Names:TPtNameScreen):TPtNameScreen;
		
		VAR	index: INTEGER;
				cherche: BOOLEAN;
				TheS: TPtNameScreen;
				LenTexte : Integer;
				
		BEGIN
		  TheS 	:= Names;	{ adresse de la table des noms de modules }
			Index	:= 0;
			Cherche	:= True;
			WHILE (Index < theNScreen) & Cherche DO
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
			GetScreenName := TheS;
		END;


		FUNCTION GetCodeName(pc:Ptr):Str255;
		
		VAR
			Termine: BOOLEAN;
			FlagUNLK: BOOLEAN;
			i,j: INTEGER;
			xpc: Ptr;
			tempS: Str255;
			theStr: Str255;
			
		BEGIN
			GetCodeName := '';
			Termine:=false; j:=0; FlagUNLK:=false; xpc:=pc;
			while (not termine) and (j<2000) do
			begin
				{ recherche de UNLK, JMP(A0) ou RTS, resp 4E5E,4E75,4ED0}
				i:=IPtr(xpc)^;
				if i=$4E5E then FlagUNLK:=True;
				termine:=(i=$4E75) or (i=$4ED0);
				xpc:=ptr(ord4(xpc)+2);
				j:=j+1;
			end;
			if termine then { on a trouve JMP(A0) ou RTS }
			begin
				{ on regarde s'il y a un nom }
				TheStr:='';
				Debugger;
				i:=IPtr(xpc)^;
				i:=bsr(i,8);
				if i>127 then
				begin
					i:=i-128;
					{ il y a un nom }
					blockmove(xpc,@TheStr[0],i+1);
					TheStr[0]:=chr(i);
					If FlagUNLK then
					begin
						{ recherche arrière du LINK }
						Termine:=false; j:=0; xpc:=pc;
						while (not termine) and (j<2000) do
						begin
							{ recherche de LINK 4E56}
							i:=IPtr(xpc)^;
							if i = $4E56 then
								Termine:=true
							else
								xpc:=ptr(ord4(xpc)-2);
							j:=j+1;
						end;
						If termine then
						begin
							{ on donne l'offset dans la fonction }
							MHConv(TempS,ord4(pc)-ord4(xpc),4);
							theStr := concat(theStr,'+',Temps);
						end;
					end;
					GetCodeName := theStr;
				end;
			end;
		END;
		
		
VAR
	DragNumber	: Integer;
	JumpPtr			: TJumpPtr;
	DrgFlag			: IPtr;
	ThePtr			: TPtr;
	TheUPtr			: UPtr;
	Chaine			: Str255;
	Line				: Str255;
	theTask			: LONGINT;
	ok					: BOOLEAN;
	curTask			: BOOLEAN;
	
BEGIN
  CASE paramPtr^.request OF
		dcmdInit:
		  BEGIN { The dcmd gets called once when loaded to init itself }
			END;

  	dcmdDoIt:
		  BEGIN { Do the command's normal function }
				DragNumber := RechDrag;
				IF DragNumber = -1 THEN
					dcmdDrawLine('Dragster absent')
				ELSE
				BEGIN
					IF dcmdGetNextExpression(theTask,ok)=' ' THEN;
					IF not ok THEN theTask := -1;
					ok := FALSE;
					
					{ on retrouve le Flag de réentrance et le JumpPtr }
					TheUptr := UPtr(LIPtr(UTableBase)^);
					DrgFlag:=IPtr(Ord4(DrvrHdrHdl(TheUPtr^[DragNumber]^^.DCtlDriver)^)+22+18); {...Ouf!}
					JumpPtr:=TJumpPtr(Ord4(DrgFlag)-4);
					JumpPtr:=TJumpPtr(Ord4(Handle(JumpPtr)^)-20);
					
					ThePtr:= JumpPtr^.TheStPtr;     { on va chopper les TCB }
					MHConv(Chaine,ORD4(ThePtr),8);
					if theTask=-1 THEN dcmdDrawLine(concat('Adresse premier TCB: $',chaine));
					WHILE ThePtr <> Nil DO        	{ on parcourt le tableau de TCB }
					BEGIN
						IF (theTask=-1) | (thePtr^.Tasknumber=theTask) THEN
						WITH ThePtr^ DO
						BEGIN
							IF not ok THEN
							BEGIN
								dcmdDrawLine('TCB      Task Status Mod Lin Ins Code');
								ok := TRUE;
							END;
							curTask := JumpPtr^.CurStPtr=ThePtr;
							
							MHConv(Line,ORD4(thePtr),8);	{ TCB }
							MConv(Chaine,Tasknumber,4);
							Line := concat(Line,' ',Chaine);
							IF curTask THEN	{ une étoile sur la tâche courante… }
								Line := concat(Line,'* ')
							ELSE
								Line := concat(Line,'  ');
								
							MConv(chaine,StatusWord,3);
							Line := concat(Line,Chaine,'   ');
							IF TaskNumber<300 THEN	{ tâche normale & annexe }
							BEGIN
								MConv(chaine,TheNScreen+1,3); { N° Module }
								Line := concat(Line,Chaine,' ');
								MConv(chaine,TheNLine,3); { N° Ligne }
								Line := concat(Line,Chaine,' ');
								MConv(chaine,TheNInst,3); { N° Module }
								Line := concat(line,Chaine,' ');
								MConv(chaine,HardType,1);	{ HardType }
								Line := concat(Line,Chaine,' ');
								Chaine := GetScreenName(theNScreen,PtNameScreen)^;	{ Screen Name }
								Line := concat(line,Chaine,' ');
								IF curTask=FALSE THEN
								BEGIN
									MHConv(Chaine,ORD4(RegArea[0]),8); { D0= adresse retour = PC }
									Line := concat(Line,Chaine);
									dcmdGetNameAndOffset(ORD4(RegArea[0]),Chaine);
									IF Chaine<>'' THEN Line := concat(Line,'=',chaine);
								END
								ELSE
									Line := concat(Line,'running');
								dcmdDrawLine(line);
							END
							ELSE										{ tâche interne }
							BEGIN
								Line := concat(line,' ');
								IF curTask=FALSE THEN	{ tâche en éxécution ? }
								BEGIN
									MHConv(Chaine,ORD4(RegArea[0]),8); { D0= adresse retour = PC }
									Line := concat(Line,Chaine);
									dcmdGetNameAndOffset(ORD4(RegArea[0]),Chaine);
									IF Chaine<>'' THEN Line := concat(Line,'=',chaine);
								END
								ELSE
									Line := concat(Line,'running');
									
								IF ZoneNumber<>0 THEN		{ il y a une requete en cours }
								BEGIN
									MConv(Chaine,ZoneNumber,2);		{ code Requete }
									Line := concat(Line,' Req=',Chaine);
									NumToString(TPtr(MaxTime)^.TaskNumber,Chaine);			{ TCB d'origine de la requete }
									Line := concat(Line,' Task=',Chaine);
								END;
								dcmdDrawLine(Line);
							END;
						END; {of WITH}
						ThePtr:=TPtr(Ord4(ThePtr)+SizeOf(TRecord));
						IF ThePtr^.MagicN1<>$12345678 THEN ThePtr:=Nil;
					END; {of WHILE}
					IF Not ok THEN dcmdDrawLine('TCB inconnu');
				END;	{ Dragster présent }
			END;	{ dcmdDoIt }
			
			dcmdHelp:
			BEGIN
				dcmdDrawLine('TCB [tasknumber]    v1.1 29/5/92');
				dcmdDrawLine('   rend la liste des taches de Dragster ou d''une');
				dcmdDrawLine('   tache donnee par tasknumber.');
			END;
		END;	{ CASE }
END;


END.
