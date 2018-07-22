{
	File:		DrgLink.p

	Contains:	Définition de la Librairie Dragster

	Written by:	Christian

	Copyright:	Christian Quest / JCA Télématique 1989

	Change History:

		2/10/89 	CQ		Ajout de DrgConnected et DrgStatus

	To Do:
}

{$IFC UNDEFINED DRAGSTERTCB}
{$I DragsterTCB.p}
{$ENDC}

{-----------------------------------------------------------------------------}

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
							ThePtrs   :	Array[1..MaxTasks+MaxAux] of TPtr;
						 END;

	DrgStatusRec = RECORD
		Conflag : BOOLEAN;            { indique si la voie est connectée }
		ModemNumber : INTEGER;        { numéro de voie du modem }
		StatusWord : INTEGER;         { status de la tache (voir plus haut) }
		ScreenNumber : INTEGER;       { numéro de l'écran courant }
		LineNumber : INTEGER;         { numéro de ligne courante }
		InstructionNumber : INTEGER;  { numéro d'instruction courante }
	END;
	
							 
							 
{-----------------------------------------------------------------------------}


{ Test pour savoir si un serveur Dragster tourne en tâche de fond}

FUNCTION DrgPresent:BOOLEAN; EXTERNAL;


{ Initialisation du record DrgLink }
{ les routines suivantes doivent être utilisée après cette initialisation }

FUNCTION  DrgInit:DrgLinkHndl; EXTERNAL;


{ Lecture d'une variable alpha. de Dragster }

FUNCTION  DrgGetString(DrgLink : DrgLinkHndl ;Tache : INTEGER ;Offset : LONGINT ) : Str255; EXTERNAL;


{ Ecriture d'une variable alpha. de Dragster }

PROCEDURE DrgSetString(DrgLink : DrgLinkHndl ; Tache : INTEGER ;Offset : LONGINT ; laChaine : Str255 ); EXTERNAL;


{ Lecture d'une variable numérique de Dragster }

FUNCTION  DrgGetNum(DrgLink : DrgLinkHndl ;Tache : INTEGER ;Offset : LONGINT ) : LONGINT; EXTERNAL;


{ Ecriture d'une variable numérique de Dragster }

PROCEDURE DrgSetNum(DrgLink : DrgLinkHndl ;Tache : INTEGER ;Offset : LONGINT;laVar:LONGINT ); EXTERNAL;


{ Test pour savoir si une voie est connectée }

FUNCTION  DrgConnected(DrgLink : DrgLinkHndl ;Tache: INTEGER):BOOLEAN; EXTERNAL;


{ Lecture d'un record de status voir son contenu plus haut }

FUNCTION  DrgStatus(DrgLink:DrgLinkHndl; Tache:INTEGER):DrgStatusRec; EXTERNAL;


{ Rend le nom du module Dragster courant d'une tâche }

FUNCTION DrgGetScreen(DrgLink:DrgLinkHndl;Tache : Integer):Str255; EXTERNAL;