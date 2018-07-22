UNIT Compilator;

	INTERFACE

		USES 	MemTypes, QuickDraw, OSIntf, ToolIntf, Sane, MacPrint, packages,
					AppleTalk, ADSP,
				 	WritelnWindow, DragsterIO, TokDetok, 
					PreCompilator,
				  Trace;
					
		VAR
			FlagCC: Boolean; 			{ pour avoir la trace de generation de code }
			CLVarFlag: Boolean; 	{ pour avoir la liste des variables }
			CMVarFlag: Boolean; 	{ pour avoir la map des variables }
			CDFlag: Boolean; 			{ pour compiler sur disque }
			NamesFlag: Boolean;		{ pour afficher les noms des écrans compilés }
			IncLine: Boolean; 		{ pour inclure les numéros de ligne }
			IncList: Boolean; 		{ pour un listing }
			IncInst: Boolean; 		{ pour inclure les numéros d'instruction }
			IncCheck: Boolean; 		{ pour inclure un check sur tableaux }
			preCompFlag: Boolean;	{ écran courant précompilé }
			compDlog: DialogPtr;	{ dialogue de compilation en cours }
			PosCompil: Rect;			{ position du 'compDlog' }
			PreCompOverRide: BOOLEAN;	{ utiliser uniquement écrans précompilés }
			
		FUNCTION CodeGen(PROCEDURE HandleEvent(theEvent:EventRecord);VAR CodeName: Str64; VolNum: Integer; DirID:LONGINT): Integer;
		FUNCTION ParamMessage(MsgID:INTEGER; Str1,Str2,Str3,Str4:Str255):Str255;
		FUNCTION GetMessage(MsgID:INTEGER):Str255;


	IMPLEMENTATION

{$I Compilator.inc.p}

END. { Implementation }
