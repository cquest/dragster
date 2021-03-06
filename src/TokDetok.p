UNIT TokDetok;
{===============================================================================

     VIDEO BASIC

     Basic adapté au Videotex - partie tokenisation/detokenisation

     Version du 29/1/86 - Philippe Boulanger

===============================================================================}



INTERFACE
{==============================================================================}
{			        I N T E R F A C E			       }
{==============================================================================}


USES	  MemTypes,QuickDraw ,OSIntf ,ToolIntf ,Sane ,MacPrint , packages, CursorCtl,
        ADSP, DragsterIO, WriteLnWindow;


{==============================================================================}
{			       C O N S T A N T E S			       }
{==============================================================================}

CONST
		MaxId			= 10000;	{ nombre max d'Identificateurs }
		MaxCst			= 10000;	{ nombre max de constantes chaine }
		MaxParm		= 511;		{ longueur max d'une liste d'instruction tok }
		MaxMots		= 300;		{ nombre max de tokens }
		MaxExtMots	= 100;		{ nombre maxi de routines externes }
	  MaxImb	 		= 50;			{ imbrication maximum de struct de controle }
	  MaxParams	= 10;			{ nombre maxi de paramètres pour une instruction }
	  MaxEtiq		= 1000;		{ nombre maximum d'étiquettes dans un source }
		MaxCondEx	= 100;		{ nombre maxi. de condition d'exécution }
		kMaxExtFiles = 15;		{ nombre maxi de fichiers de routines externes }
				
			 fproc		=  0;	  	{ type  0, procedure }
			 fnum			=  1;	  	{ type  1, fonction numerique }
			 fstr			=  2;	  	{ type  2, fonction chaine }
			 fcnum		=  3;	  	{ type  3, fonction calcul num }
			 fcstr		=  4;	  	{ type  4, fonction calcul str }
			 fanum		=  5;	  	{ type  5, fonction affect num }
			 fastr		=  6;	  	{ type  6, fonction affect str }
			 fetiq		=  7;	  	{ type  7, declaration etiq }
			 fcont		=  8;	  	{ type  8, fonction de control }
			 fcstnum	=  9;			{ type  9, constante num	 }
			 fcststr	= 10;			{ type 10, constante chaine ind}
			 fvarnum	= 11;			{ type 11, variable num	 }
			 fvarstr	= 12;			{ type 12, variable str	 }
			 fliste		= 13;	 		{ type 13, liste d'instructs	 }
			 fligne		= 14;	  	{ type 14, ligne		 }
			 fvar			= 15;	  	{ type 15, variable		 }
			 fexp			= 16;	  	{ type 16, expression		 }
			 fexpnum	= 17;			{ type 17, expression num	 }
			 fexpstr	= 18;			{ type 18, expression str	 }
			 frem			= 19;	  	{ type 19, commentaire	 }
			 fpar			= 20;	  	{ type 20, parentheses	 }

			 finumvar	= 21;	  { type 21, var num indexe   }
			 fistrvar	= 22;	  { type 23, var str indexe   }

			 fisnumvar= 23;  { type 22, var num ind shared	 }
			 fisstrvar= 24;  { type 24, var str ind shared	 }
			 fuetiq		= 25;	  	{ type 25, utilisation d'etiq	 }
			 fiuetiq	= 26;	  { type 26, ut indirect d'etiq	 }

			 fnop			= 98;	  	{ type 98, ne fait rien	 }
			 fundef		= 99;	  	{ type 99, non trouve		 }

			 ErrorStrings = 261;		{ STR# des messages d'erreur dans DragsterEdit }

			 ErrSyntax			=  1;		{ Erreur de syntaxe		 }
			 ErrVParam			=  2;		{ Mauvaise valeur de parametre }
			 ErrLabel				=  3;		{ Etiquette utilisée et non définie }
			 ErrDef					=  4;		{ Redéfinition d'une étiquette ou d'une var }
			 ErrType				=  5;		{ Mauvais type de parametre }
			 ErrMissing			=  6;		{ Mauvais nombre de parametres }
			 ErrFor					=  7;		{ For sans Next }
			 ErrNext				=  8;		{ Next sans For }
			 ErrWhile				=  9;	  { While sans Wend }
			 ErrWend				= 10;	  { Wend sans While }
			 ErrZero				= 11;	  { Division par zero }
			 ErrReturn			= 12;		{ Return sans Gosub }
			 ErrLigne				= 13;	  { pb de tokenisation }
			 ErrCall				= 14;	  { mauvais appel de la fonction }
			 ErrConf				= 15;	  { conflit de types }
			 ErrImbWF				= 16;	  { trop d'imbrications de while/for }
			 ErrImbIf				= 17;	  { trop d'imbrications de If }
			 ErrElse				= 18;	  { Else sans If }
			 ErrEndif				= 19;	  { Endif sans If }
			 ErrBreak				= 20;	  { Break sans for/while }
			 ErrCont				= 21;	  { Continue sans for/while }
			 ErrNonXFile		= 22;		{ Tentative d'exec d'un fichier non exec }
			 ErrDDef				= 23;	  { Double définition d'une étiquette }
			 ErrBadNum			= 24;		{ Mauvais numero de fichier }
			 ErrNotOpen			= 25;		{ Fichier non ouvert }
			 ErrFileOpen		= 26;		{ Fichier déja ouvert }
			 ErrIndice			= 27;		{ Erreur dans un indice de tableau }
			 ErrInterp			= 28;		{ Fonction ou proc non dispo version interp }
		   ErrQEmpty			= 29;		{ Queue vide }
		   ErrNoExtToken	= 30;		{ Routine externe inconnue }
			 ErrTooLong			= 31;		{ Source BASIC trop long }
			 ErrUntil				= 32;		{ UNTIL sans REPEAT }
			 
		   ExtToken = -1;			{ N° de token des routines externes }
		   ExtType1 = 'DEXT';	{ Type des resources externes }
		   ExtType2 = 'DEXC';	{ Type des rout. ext. avec callbacks }
			 ExtFileName = 512;	{ STR# contenant les noms des fichiers de resource possible }
		   
{==================================}
{				    T Y P E S				       }
{==================================}

     TYPE
          str20	 = STRING[20];
{$IFC UNDEFINED STR64}
					str64	= STRING[63];
{$SETC STR64 = TRUE}
{$ENDC}

					{ Types des paramètres }
					TParRec = ARRAY[1..MaxParams] OF integer;
          TRes = PACKED RECORD		  { Token }
										motRes    : str20;		  { Mot Réservé du Token }
										tfunc     : integer;	  { Type du Token }
										token     : integer;	  { Numéro du Token }
										nbparms   : integer;	  { Nombre de Paramètres }
										tparms    : TParRec;
                    jumpcode  : integer;	  { N° routine jump table}
										flagAnalys:	boolean;	  { vrai si a analyser }
										TheResC	  : Handle;		  { Handle du code des routines externes }
										TypeExt		: OsType;			{ type d'externe DEXT/DEXC… }
								END;

          { Paramètres d'une Inst }
					TNextI = PACKED ARRAY[0..MaxParm] OF Char;

          TDummy = RECORD			  			{ Entête d'instruction }
                    lparam: integer;	{ Longueur totale avec parms }
                    tk: integer;		  { Token }
                   END;

          TParamHandle=^TParamPtr;		  { Pointeur sur une instruction }
          TParamPtr=^TParam;			  { Pointeur sur une instruction }

          ExtRec = RECORD
						 	 extNbParam: integer;	{ nombre de params }
							 extType: Integer;		{ Type de routine externe (fProc, fNum, fStr }
						 	 extName: str20;			{ nom routine externe }
							 extparams: TNextI;		{ Paramètres }
					END;
					
					TParam = RECORD			  { Instruction }
                    lparam: integer;		  { Longueur totale avec parms }
                    tk: integer;		  { Token }
                    CASE integer OF
                         0: (nbparam: integer;	  { Nombre de paramètres }
                             pp: TNextI );	 			{ Paramètres }
                         1: (param: str255);	  	{ Chaine Paramètre }
                         2: (num: longint);	  		{ Valeur Paramètre }
                         3: (indir: integer);	  	{ Indirection Paramètre }
						 						 4: (ExtInfos: ExtRec);		{ infos sur pour token externe }
                   END;

          TVar	  = RECORD			  { Descr. Ident ou Cst Chaine }
                         nomVar:   str20;	  { Identificateur }
                         tpvar:	   integer;	  { Type de l'Identificateur }
                         Indir:	   integer;	  { Numero de l'indir au runtime }
                         DimVal:   integer;	  { Dimension pour var indexée }
                         CASE integer OF
                         0:(shared:   boolean);	  { Variable partagée ? }
                         1:(defined:  boolean);	  { Etiquette définie ? }
												 2:(varFlags: PACKED RECORD
												 								shared:	BOOLEAN;
																				local:	BOOLEAN;
																			END)
                    END;


          MRes	 = PACKED ARRAY[0..MaxMots] OF TRes;		{ Tableau de Tokens }
          PMRes	 = ^MRes;
          HMRes	 = ^PMRes;


          VarRes = PACKED ARRAY[1..MaxId] OF TVar;		  { Tableau d'Identificateurs }
          PVarRes  = ^VarRes;
          HVarRes  = ^PVarRes;


          CstRes = ARRAY[1..MaxCst] OF Str64;	  				{ Tableau de Cst chaines }
          PCstRes  = ^CstRes;
          HCstRes  = ^PCstRes;


          PBrkLst = ^TBrkLst;
          HBrkLst = ^PBrkLst;
          TBrkLst = RECORD
                         NextBrk:  HBrkLst;	  { Break suivant }
                         BrkIndex: Longint;	  { adresse break }
                    END;


          TCont = RECORD
                    WhileFlag: integer;		  { 0=While 1=for 2=if 3=repeat }
                    WFIIndex: longint;		  { adresse while for if repeat }
                    WNEIndex: longint;		  { adresse wend next else until}
                    EndIndex: longint;	  	{ adresse Endif }
                    Brklist: HBrklst;				{ liste des break en attente }
										ContList: HBrkLst;			{ liste des CONTINUE en attente }
                  END;

          TContPile = ARRAY[1..MaxImb] OF TCont;  { Imbrication de structures }

					ExtNamesData = ARRAY [0..MaxExtMots] OF LONGINT;

					
{==============================================================================}
{			       V A R I A B L E S			       }
{==============================================================================}

     VAR

          tempout   : str255;		     		{ Ligne de sortie détokenisée }
          tempin    : CharsPtr;		    	{ Ligne d'entrée à tokeniser }

          ErrFlag   : Boolean;		    	{ Flag d'Erreur }
          ErrPos    : integer;		    	{ Numero et position d'Erreur }
          ErrorStr  : str255;

          Dbg	    	: boolean;		    	{ Flag de debug }

          mots	    : HMRes;		     		{ Tokens du Basic (UNLOCK) }
		  		VarTab    : HVarRes;		     	{ Identificateurs }
          CstTab    : HCstRes;		     	{ Constantes chaines }

          NbCst,			     							{ Nombre de constantes chaine }
          NbVar,			     							{ Nombre d'identificateurs }
          NbWF	    : integer;		     	{ Nombre de For/While/if imbriques }

          ResListe  : TParamHandle;		  { Ligne Tokenisee }

          CurIndex  : Longint;		     	{ Index dans la ligne }
          BaseIndex : Longint;		     	{ offset de la ligne }
          RepIndex  : Longint;		     	{ reponse au break, continue, next,..}

          curs	    : Longint;		     	{ Curseur sur la ligne d'entree }

          LgCode    : Integer;

          CodeHdle  : TParamHandle;

          hTE	      : TEHandle;
		 			nbtok			: Integer;
					ExtNames	: ExtNamesData;
					ExtNamesH	: Handle;

					NbExtFiles:	INTEGER;
					ExtFiles	: ARRAY [0..kMaxExtFiles] OF INTEGER;		{ refNum des fichiers contenant les routines externes }


PROCEDURE InitTokens;	 { Initialise le Tokeniseur/Detokeniseur.
                           A n'appeler qu'une seule fois, au debut !!!
                         }

PROCEDURE InitTables;	 { ReInitialise les tables d'identificateurs et
                           de constantes (plus de place mémoire)
                         }

PROCEDURE Tokenize;	 { Tokenise la chaine TempIn.
                           Le resultat tokenise se trouve dans ResListe.
                           Les variables d'erreur sont positionnées.
                         }

PROCEDURE DeTokenize;	 { Detokenise ResListe.
                           Le Resultat detokenise se trouve dans TempOut
                         }

PROCEDURE routdetok(e:TParamPtr; VAR s: str255);
{ detokenise une instruction }

PROCEDURE NextToken(VAR e:TParamPtr;offset:LONGINT); { Rend le token suivant }


IMPLEMENTATION
{==============================================================================}
{		        I M P L E M E N T A T I O N			       }
{==============================================================================}

{$I TokDetok.inc.p}

END. { Implementation }

