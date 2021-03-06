UNIT Interpretor;
{===============================================================================

     VIDEO BASIC

     Basic adapté au Videotex - partie interpreteur

     Version du 2/2/86 - Philippe Boulanger

===============================================================================}



INTERFACE
{==============================================================================}
{			        I N T E R F A C E			       }
{==============================================================================}


{$DECL DrgTree}
{$SETC DrgTree := FALSE}

USES	Memtypes, Quickdraw, ToolIntf, OSIntf, packages, Sane, MacPrint, ADSP,
		WritelnWindow, DragsterIO,
		{$U :Wintree:DrgTree.p } DrgTree,
        TokDetok, Emulator, DragsterExternals, Kit;

{$I DragsterTCB.p}

{==============================================================================}
{			       C O N S T A N T E S			       }
{==============================================================================}

     CONST
               MaxBuf	 =    511;	     { Nombre Max de Car d'un buffer }

{==============================================================================}
{				    T Y P E S				       }
{==============================================================================}

     TYPE
		  { tableau de chaines… }
          TSRecord   = ARRAY [0..1000] OF Str255;		{ dynamique }
          TSP	     = ^TSRecord;
          TSHandle   = ^TSP;
		
		  { tableau de valeurs numériques }
          TVRecord   = ARRAY[0..10000] OF Longint;			{ dynamique }
          TVP	     = ^TVRecord;
          TVHandle   = ^TVP;

		  { déf. d'un variable }
          TGVar	     = RECORD
                         NomVar: Str20;
                         DimVal: Integer;
                         CASE TpVar:Integer OF
                              0: (Sptr: StringHandle);	{ val. numérique }
                              1: (Value: longint);		{ chaine }
                              2: (TVPtr: TVHandle);		{ tabl. de val. num }
                              3: (TSPtr: TSHandle);		{ tabl. de chaines }
                      END;

          TbVar	    = RECORD
                         NbVars:   Integer;
                         Vars:	   ARRAY[1..10000] OF TGVar;	{ dynamique !! }
                      END;
          PTbVar    = ^TbVar;
          HTbVar    = ^PTbVar;


          { adresses de retour }
          PCPile    = RECORD
                         CodeNum:  Integer;
                         RetPc:	   Longint;
                      END;
          TPCPile   = RECORD
                         NbCalls: Integer;
                         TheCalls: ARRAY[1..10000] OF PCPile;	{ dynamique }
                      END;
          PPCPile = ^TPCPile;
          HPCPile = ^PPCPile;


          { noms des codes }
          CodePile  = RECORD
                         VolNum	 : integer;
                         CodeName: str64;
                      END;
          TCodePile = RECORD
                         NbCode: Integer;
                         TheCodes: ARRAY[1..10000] OF CodePile;	{ dynamique }
                      END;
          PTCodePile = ^TCodePile;
          HTCodePile = ^PTCodePile;

		  { divers }
		  PCRec		= PACKED ARRAY[0..10000] OF Char;
		  PCPtr		= ^PCRec;
		  PCHdl		= ^PCPtr;
		  
{==============================================================================}
{			       V A R I A B L E S			       }
{==============================================================================}

FUNCTION Xcute(VAR CodeName: Str64; VolNum: Integer; DirID:LONGINT; TheMain:Ptr): integer;
     { Xcute devrait etre réentrant, pour marcher en multi-tâches   }

VAR	Trace2Flag: BOOLEAN;	{ les TRACE s'affichent ou pas }

PROCEDURE StrExprXCute(e: TParamPtr; ps: PStr255);
PROCEDURE NumExprXCute(e: TParamPtr; pn: LongintPtr);

{ pour permettre des UnLoadSeg }
PROCEDURE BaseAdd(e: TParamPtr);
PROCEDURE BaseMaxSize(e: TParamPtr; pn:LongintPtr);

{ appels depuis InterpretorLib }
PROCEDURE WaitBis(NumZone:INTEGER);
PROCEDURE PrintScreenBis(screen:Str255);

IMPLEMENTATION

{$I Interpretor.inc.p }

END. { Implementation }