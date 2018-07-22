{$IFC UNDEFINED DRAGSTERTCB}
{$SETC DRAGSTERTCB=TRUE}

{ include de Dragster Run Time BackGround }

{-----------------------------------------------------------------------------}
CONST
     DOOpen    =    0;
     DOClose   =    1;
     DOEvent   =    2;
     DORun     =    3;
     DOCursor  =    4;
     DOMenu    =    5;
     cutCall   =   70;
     copyCall  =   71;
     pasteCall =   72;
     clearCall =   73;

{-----------------------------------------------------------------------------}
     ReadyCst   =   0;  { Attente avec delay: StatusWord impair }
     DelayCst   =   1;
     IOWaitCst  =   2;
     IOTWaitCst =   3;
     ChrCst     =   4;
     ChrTCst    =   5;
     PdCst      =   6;
     PdTCst     =   7;
     StrPdCst   =   8;
     StrPdTCst  =   9;
     NetCst     =  10;
     NetTCst    =  11;
     WOutCst    =  12;
     StartCst   =  14;
     PostCst    =  16;
     PostTCst   =  17;
	 SuspendCst =  18;
	 PendWCst	=  20;
	 WDataCst	=  22;
	 WDataTCst	=  23;
	 WComCst	=  24;
	 WComTCst	=  25;
	 WOBuffCst	=  26;
	 PendBCst	=  28;	{ Pend sur un BOOLEAN ( réactive qd TRUE ) }
	 PendBTCst	=  29;	{  ""   ""  avec Timeout }
	 PostBCst	=  30;
	 PostBTCst	=  31;
     IOEndedCst =   0;
	 ADSPWaitCst=  32;
	 RunModeCst =  33;
	 BaseWaitCst=  34;
	 
{-----------------------------------------------------------------------------}

     MaxZones   	=  40;	{ nombre maxi. de zones de saisies }
     MaxFile    	=  12;	{ nombre de fichiers ouverts par une voie/tâche }
     MaxStrLen  	= 255;	{ taille maxi. des chaines }
     MaxTasks   	=  65;	{ nombre maxi. de tâches/voies }
	 MaxAux			=  10;	{ nombre maxi. de tâches annexes }
	 MaxFileName	= 255;	{ longueur maxi. d'un chemin d'accès de fichier }

	 SZCALL			=  26;

	 SerBufSz		=8192;	{ 12/1/98 - passage de 1Ko à 8Ko }
	 
	 InBuffSzMin	=  64;
	 
	{ offsets des pointeurs dans un TCB }
     TheSCst    =  12;
     TheCcst    =  20;
     TheAGCst   =  24;
     TheGcst    =  28;
     TheC68Cst  =  32;
     TheJump    =  40;
     TheNCst    =  48;
     TheVCst    =  52;
	 TheNLCst	= 106;
	 TheNICst	= 108;
	 
     XRunTask	     =	  1;
     XCarPrint	     =	  2;
     XNumPrint	     =	  3;
     XStrPrint	     =	  4;
     XCarWrite	     =	  5;
     XNumWrite	     =	  6;
     XStrWrite	     =	  7;
     XSeekScreen     =	  8;
     XVarInput	     =	  9;
     XNumRead	     =	 10;
     XStrRead	     =	 11;
	 XTimeIt		 =	 12;
	 XStartRead		 = 	 13;
	 XStartWrite 	 =   14;
	 XEndWrite		 =	 15;
     OffRT	     	 =	 20;  {offset Run Time}

{-----------------------------------------------------------------------------}

	{ Numéro des queues des serveurs internes }

	MainQueue = 0;		{ Queue pour DragsterBoot… }
	IOQ = 1;			{ TSKC 1024 = interrogation des modems }
	FileQ = 2;			{ TSKC 1025 = gestion de fichiers }
	IOQ2 = 3;			{ TSKC 1026 = interrogation des modems 2ème port }
	IOAsm = 4;			{ TSKC 1027 = tâche de réception des voies ASM }
	BaseQ = 5;			{ TSKC 1030 = base de donnée }
	ADSPQ = 6;			{ TASK 1031 = Gestion ADSP }
	ShutDownQ = 7;		{ TASK 2000 = Appel ShutDownProcs }
	 
	MaxQueues = 7;
	
	
     { requetes pour les serveurs }
	 
	 { MainQueue = DragsterBoot }
	 ReqNewHandle = 1;		{ appel de NewHandle dans le heap de DrgBoot }
	 ReqStoreData = 2;		{ conserve des données }
	 ReqRestoreData = 3;	{ rappel des données }
	 ReqKillData = 4;		{ suppression de données }
	 
     { Serveur d'entree }
     ReqOn	     =	 3;	        { demande activation requete }
     ReqOff	     =	 2;	        { demande annulation requete }
     ReqDone	     =	 0;	        { status: requete terminee   }
     ReqActive	     =	 1;	        { status: requete active     }
     ReqCanceled     =  -1;	        { status: requete annulee    }

     { Serveur de fichier }
     ReqOpen	     =	 1;	        { demande d'Open }
     ReqClose	     =	 2;	        { demande de Close }
     ReqRename	     =	 3;	        { demande de Rename }
     ReqDelete	     =	 4;	        { demande de Delete }
     ReqRead	     =	 5;	        { demande de Read }
     ReqWrite	     =	 6;	        { demande de Write }
     ReqGetEof	     =	 7;	        { demande de GetEof }
     ReqSetEof	     =	 8;	        { demande de SetEof }
     ReqLock	     =	 9;	        { demande de Lock }
     ReqUnlock	     =  10;	        { demande de Unlock }
     ReqCreate	     =  11;	        { demande de Create }
     ReqGetFInfo     =  12;	        { demande de GetFInfo }
     ReqSetFInfo     =  13;	        { demande de SetFInfo }
	 ReqOpWd		 =	14;			{ demande de OpenWD }
	 ReqClWd		 =	15;			{ demande de CloseWD }
	 ReqGetCat		 =	16;			{ demande de GetCatInfo }
	 ReqOpRsrc		 =	17;			{ demande de Open resource fork }
	 ReqDirCreate	 =	18;			{ demande de Creation de Folder }
	 ReqFlush		 =	19;			{ demande de FlushVol }
	 ReqNameOfId	 =	20;			{ demande de nom courant }
	 ReqGetVol		 =  21;			{ demande de GetVol }
	 ReqSetVol		 =  22;			{ demande de SetVol }
	 ReqGetVInfo	 =	23;			{ demande de GetVInfo }
	 ReqCatMove		 =	24;			{ demande de PBCatMove }
	 
	 
     { Serveur Base de données }
	 
	 ReqB_Create	 =	 1;
	 ReqB_Open		 =	 2;
	 ReqB_Next		 =	 3;
	 ReqB_Pred		 =	 4;
	 ReqB_Seek		 =	 5;
	 ReqB_Close		 =	 6;
	 ReqB_Add		 =	 7;
	 ReqB_Remove	 =	 8;
	 ReqB_Update	 =	 9;
	 ReqB_Lock		 =	10;
	 ReqB_Unlock	 =	11;
	 ReqB_Info		 =	12;
	 ReqB_SetNet	 =	13;
	 ReqB_IncR		 =	14;
	 ReqB_Read		 =	15;

	{ Serveur ADSP }
	
	ReqADSPWaitConnect = 1;
	

{ •••• ADSP •••• }
	NBPBuffLen = 100;
	DSPSendSize = 600;
	DSPRecvSize = 600;
	
	
{ •••• Types de HardWare •••• }

	NoHard = 0;			{ pas de Hard (tâches annexes) }
	ModemDrg = 1;		{ Modem/WitBoost/Télétel }
	ADSPLink = 2;		{ AppleTalk }
	SerialLink = 3;		{ Port série }
	MuxASM = 4;			{ Multiplexeur ASM }
	ModemHayes = 5;		{ Modem compatible Hayes }
	MuxASMT = 6;		{ Multiplexeur ASM Transparent (Namtel) }
	
{-----------------------------------------------------------------------------}
TYPE

{ Type du bloc de controle }

		 CString= PACKED ARRAY [0..255] OF char;

{$IFC UNDEFINED STR64}
		str64	= STRING[63];
{$SETC STR64 = TRUE}
{$ENDC}
		PStr64	 = ^Str64;

         Buffer	 = PACKED ARRAY[0..1023] OF char;

          RSZone      = RECORD
                         PosX,
                         PosY,
                         Len	   : Integer;
                         TkVar	   : Integer;
						 Color	   : Integer;
                         CASE integer OF
						 1:	(AdVar		: Ptr;);		{ compilé }
						 2:	(NumVar		: Integer;
						 	 IndVar	: Integer;);	{ interpretté }
                      	END;

         SCode	 = RECORD
                NbCodes	        : Integer;		        {Nombre de codes}
                Offsets	        : ARRAY[1..100] OF Integer;     {Offsets}
         END;

         FRecord = RECORD
                FileRef	        : Integer;      {Numero de reference du fichier }
                FileRLen        : Integer;      {Longueur d'un record (acces dir)}
                FilePos	        : Longint;      {Prochaine pos a lire, ou record courant}
				BaseFlag		: Boolean;		{base ou fichier}
         END;

         ROffScreen = ARRAY[0..1200] OF
                         RECORD
                              OffCode:  Longint; {offset ecran dans le code}
                              OffVCode: Longint; {offset videotex}
                         END;

         TPtOffScreen = ^ROffScreen;
         THOffScreen  = ^TPtOffScreen;

         TPtNameScreen = ^Str255;
         TPtStringCsts = ^Str255;

         TPtr = ^TRecord;

         TQEPtr =   ^TQERec;
         TQERec =   RECORD
                         QLink	   : TQEPtr;  { element suivant }
                         EOwner	   : TPtr;    { Tache proprietaire de l'element }
                         ECode	   : Integer; { Code requete }
                         EParam1   : Ptr;     { Parametres requete }
                         EParam2   : Ptr;     { Parametres requete }
                         CASE Integer OF
                         0: (EMisc     : Longint); { Futur use }
                         1: (ERet      : Integer);
                    END;

         TQPtr =    ^TQRec;
         TQRec =    ARRAY[0..MaxQueues] OF RECORD
                         QOwner	   : TPtr;    { Tache proprietaire de la queue }
                         QFirst	   : TQEPtr;  { 1er element de la queue }
                         QEnd	   : TQEPtr;  { dernier element de la queue }
                         QNumber   : Integer; { nombre d'elements dans la queue }
                    END;
		 
		 MXQPtr =	^MXQRec;
		 MXQRec =	PACKED ARRAY[0..4095] OF Char;

		 MQPtr =	^MQRec;
		 MQRec =	ARRAY[1..MaxTasks+MaxAux] OF
		 			RECORD
		 				MFirst	   : Integer; { Position du premier car occupé }
						MFree	   : Integer; { Position du premier car libre  }
						MNb		   : Integer; { Nombre de messages en attente  }
						MMax       : Integer; { Taille du buffer			   }
						MPtr	   : MXQPtr;  { pointeur sur le buffer, NIL sinon }
		 			END;
		 

				PStr2550 = ^Str255;
				
				
				{********** interface base de données **********}
				B_Ptr	=	^B_Rec;
				B_Rec	=	RECORD
							TheInfo	: Ptr;			{ infos sur la base }
							TheKeys	: Ptr;			{ en création }
							Nom		: StringPtr;	{ nom de la base en création,
											  		  titre en recherche }
							FichCom	:	Ptr;		{ fiche de communication }
							Index	:	Integer;	{ index de travail }
							NetFlag	:	Boolean;	{ NetWork Flag }
						  END;
						  

		 RWBPtr =	^RWBRec;
		 RWBRec	=	PACKED ARRAY[1..10000] OF char;
					
		 DBBPtr =	^DBBRec;
		 DBBRec	=	PACKED ARRAY[0..10000] OF char;
					
		 iBuffPtr =	^iBuffRec;
		 iBuffRec =	RECORD
		 				Link	:	iBuffPtr;
						InBuff	:	Str255;
					END;
		 
		 PBuffPtr =	^PBuffRec;
		 PBuffRec =	RECORD
		 				Link	:	iBuffPtr;
					END;
					
		 OutBuf = STRING[128];
		 OutBufPtr = ^OutBuf;
		 

{ •• Datas pour les liaisons ADSP •• }

		MyADSPPBRec = RECORD
			TCBPtr: TPTr;
			ADSPPB: DSPParamBlock;
			END;
		 
		MyADSPPbPtr = ^MyADSPPBRec;
	   
		InfoRec = RECORD CASE integer OF
		1: (	{ infos suppl. pour ADSP }
			PB: MyADSPPBRec;
			theCCB: TRCCB;	{ 242 octets }
			SendBuff: PACKED ARRAY [1..DSPSendSize] OF Byte;
			RecvBuff: PACKED ARRAY [1..DSPRecvSize] OF Byte;
			AttnBuff: PACKED ARRAY [1..attnBufSize] OF BYTE;
		);
		2: (	{ infos suppl. pour X25 }
			LastX29: Str255;	{ dernier message X29 reçu }
			PO1: Byte;			{ type de minitel }
			PO: ARRAY [2..6] OF Str255;
		);
		END;
		
		InfoPtr = ^InfoRec;
		 
         TRecord = RECORD
                MagicN1	        : Longint;      {   0 magic Number}
                NextTCB	        : TPtr;	        {   4 next TCB in the task list}
				PredTCB			: TPtr;			{	8 pred TCB in the task list}
                PtOffScreen     : TPtOffScreen; {  12 offset des codes + videotex}
                PtNameScreen    : TPtNameScreen;{  16 noms des ecrans}
                PtStringCsts    : TPtStringCsts;{  20 constantes chaine}
                PtSVars	        : Ptr;	        {  24 variables shared application}
                PtLVars	        : Ptr;	        {  28 variables locales application}
                PtCode	        : Ptr;	        {  32 code application}
                PtScreens       : Ptr;	        {  36 codes Videotex}
                PtJump	        : Ptr;	        {  40 jump table Run Time}
                PtOrgStk        : Ptr;	        {  44 original stack pointer}
                TheNScreen      : Longint;      {  48 Numero ecran courant}
                TheVScreen      : Ptr;	        {  52 Ecran VideoTex Courant}
                TheQueues       : TQPtr;        {  56 Queues des serveurs }
				TheMQueues      : MQPtr;        {  60 Queues des messages }
				TheAuxBuffPtr   : Ptr;          {  64 Buffer serial port }
                TheModem        : Integer;      {  68 Numero du modem correspondant }
                SerRefIn		: integer;		{  70 Driver In  }
                SerRefOut       : Integer;      {  72 Driver Out }
                StatusWord      : Integer;      {  74 Mot d'etat:
                                  0: ready
                                  1: waiting delay
                                  2: waiting IOCompletion
                                  3: waiting IOCompletion with TimeOut
                                  4: waiting char
                                  5: waiting char with TimeOut
                                  6: pending for mailbox
                                  7: pending for mailbox with TimeOut
                                  8: pending for string
                                  9: pending for string with TimeOut
                                 10: waiting network response
                                 11: waiting network response with TimeOut
                                 12: waiting for OutPut allowing
                                 14: waiting for Start
								 20: waiting data or lib on input channel
								 21: waiting data or lib on input channel with TimeOut
								 22: waiting communication on input chanel
								 23: waiting communication on input channel with TimeOut
								 }
                DelayValue      : Longint;      {  76 Nombre de Ticks a attendre}
                IOCompFlag      : Integer;      {  80 0: IO terminée, 1: IO en cours}
                Error	        : Integer;      {  82 Code d'Erreur}
                PendAdr	        : Ptr;	        {  84 Var Adress for pend}
                PendStr	        : Longint;      {  88 Str Pattern to wait}
                StartTime       : Longint;      {  92 TickCount de connexion}
                MaxTime	        : Longint;      {  96 TimeOut}
                ZoneNumber      : Integer;      { 100 Zone de sortie du Wait}
                TaskNumber      : Integer;      { 102 Numero de la tache/voie logique}
                TaskPriority    : Integer;      { 104 Priorité de la tache }
				TheNLine		: Integer;		{ 106 Numero de ligne dans le module }
				TheNInst		: Integer;		{ 108 Numero d'intruction dans la ligne }
                LocalMode       : Boolean;      { 110 mode local ou non }
                EchoFlag        : Boolean;      { 111 echo ou non }
                OutPutFlag      : Boolean;      { 112 output allowed, Transpac version}
				FrOutPut		: Boolean;		{ 113 vrai si FrontScreen On }
                StarFlag        : Boolean;      { 114 si * seule en saisie }
				IsTeletel		: Boolean;		{ 115 indique un Dragster Télétel si HardType=ModemDrg }
				TaskSNumber		: Integer;		{ 116 TaskNumber dans le type }
				HardType		: Integer;		{ 118 Type de HardWare }
		 		OpFlag	   		: Integer; 		{ 120 sortie possible (Télétel) }
		 		SerSpeed	   	: Integer; 		{ 122 vitesse port série }
				Infos			: InfoPtr;		{ 124 pointeur vers infos supplémentaires }
				OPPtr			: OutBufPtr;	{ 128 Pointer to Output Paquet Ring •••• pointeur vers buffer de sortie }
                RegArea	        : ARRAY[0..16] OF Ptr; { 132 registres tache background}
                RegAreaF        : ARRAY[0..16] OF Ptr; { 136 registres tache principale}
                NbZones	        : Integer;      {Zones de saisie }
                TheZones        : ARRAY[1..MaxZones] OF RSZone;
                RTId	        : Longint;      { Serial number of Run Time }
                TraceFile		: Integer;		{ refNum du fichier de trace }
                ProtCount       : Integer;
				XCallDatas      : STRING[SZCALL]; { données d'appel Transpac }
				ConnTime		: LONGINT;		{ DateTime (secs) lors de la connexion }
				InBuffEnd		: iBuffPtr;		{ pointeur sur dernier buffer d'entrée }
				InBuffPool		: PBuffPtr;		{ pointeur sur pool de buffers d'entrée }
				RunMode			: Integer;		{ Mode de fonctionnement (VBL ou DRVR ?) }
				CurRunMode		: Integer;		{ Mode de fonctionnement actuel }
				InSilentFlag	: Boolean;		{ input "silencieux" }
				WBuffFlag		: Boolean;		{ vrai si remplissage du buffer en cours }
				ConFlag			: Boolean;      { valide sur connexion }
				XConFlag		: Boolean;		{ devalide sur deconnexion }
				InBuffNb		: Integer;		{ nombre de buffers d'entrée courant }
				FilterFlag		: boolean;		{ vrai si ESC filtré }
				TrPrintFlag		: boolean;		{ 0= print normal, 1= print Transparent, 2= X29/bit Q à 1, 3=normal sans REPET }
				RWSz			: Integer;		{ Read/Write Buffer Size }
				RWPtr			: RWBPtr;		{ Pointer to Read/Write Buffer }
				RWCount			: Integer;		{ Count of read bytes }
				RWIdx			: Integer;		{ Index dans RW buffer 1..RWSz }
				DBPtr			: DBBPtr;		{ Pointer to data base Buffer }
				DBSz			: Longint;		{ Data Base com area size }
				DBCount			: Longint;		{ com area actual size }
				DBRef			: Longint;		{ record reference }
				DBIdx			: Longint;		{ com area actual index }
				IOQueue			: Integer;		{ N° Queue d'I/O }
				RndMemo			: Longint;		{ random seed 1 }
				RndCount		: Longint;		{ random seed 2 }
				DemoCount		: Longint;		{ decompteur pour demo }
				InBuffSt		: iBuffPtr;		{ pointeur sur premier buffer d'entrée }
                TheFiles        : ARRAY[1..MaxFile] OF FRecord;
         END;

		 TPTPtr		=	^TPTRecord;
		 
		 TPTRecord	=	ARRAY[0..255] OF RECORD
		 					PredPTY,
							NextPTY		:	Integer;
							LastTCB		:	TPtr;
						END;
						

{-----------------------------------------------------------------------------}
{ Ressource de configuration du serveur }

         TConfRecord = RECORD
                SerPort	        : Integer;      {0=A, 1=B, -1=les deux…}
				SerSpeed		: Integer;		{ voir cstes Mac }
				MessSize		: integer;		{default 1024}
				NbAux			: integer;      {default 0}
				RWBSize			: integer;		{default 256}
				DBComSize		: integer;		{default 1024}
				AntPqSize		: integer;		{default 10 paquets de 128}
				X25Number		: integer;		{default 1} { nb voies locales ADSP }
				WModNumber		: integer;	    {default 0}
				InBuffSz		: integer;		{default 40 paquets de 256+4 }
                TheXScreen      : Str64;        {Nom du code compile à booter}
         END;

         TConfPtr = ^TConfRecord;
         TConfHdle = ^TConfPtr;

{-----------------------------------------------------------------------------}
{ Definition du fichier executable }

         XFileRecord = RECORD
                SzSVars	        : Longint;      {Taille des var partagees}
                SzVars	        : Longint;      {Taille des variables}
                SzStack	        : Longint;      {Taille de la pile}
                SzOffScreen     : Integer;      {Taille table offsets}
                SzNameScreen    : Integer;      {Taille table nom d'ecran}
                SzStringCsts    : Longint;      {Taille table cst chaine}
                SzVCode	        : Longint;      {Taille table ecrans videotex}
                SzCode	        : Longint;      {Taille code executable}
                { suivi de
                    - table offsets
                    - table nom d'ecran
                    - table cst chaine
                    - table ecrans videotex
                    - code executable
                }
         END;

{-----------------------------------------------------------------------------}
{ Definition des pointeurs avant la Jump Table }

     TJumpRec  =    RECORD
                         CurStPtr,	     { TCB actif    }
                         TheStPtr,	     { TCBs occupes }
                         TheLStPtr,	     { dernier TCB  }
                         TheFSTPtr : TPtr;   { TCBs libres  }
                    END;

     TJumpPtr  =    ^TJumpRec;

{-----------------------------------------------------------------------------}
{ Definition des parametres resource TSKP }

     TSKPRec   =    RECORD
                         QNumber,		       			{ recoit sur cette queue }
                         TPriority,		       			{ priorite }
                         TSKCNumber,  					{ numero code TSKC  }
						 TNumber:    Integer;			{ nombre de taches de ce type }
                         SzGlobs        :    Longint;  	{ taille des globales }
						 SzLocs			:	 Longint;	{ taille des locales }
                         SzStack        :    Longint;  	{ taille de la pile }
						 NeedsRW		:	 Integer;	{ a besoin d'un buffer RW }
						 NeedsDB		:	 Integer;	{ a besoin d'un buffer DB }
                    END;
     TSKPPtr   =    ^TSKPRec;
     TSKPHdle  =    ^TSKPPtr;

{-----------------------------------------------------------------------------}
{ ParamBloc destine aux IO }

  MyParamBlockRec = RECORD
        { 4 byte header used by the Completion routine }
        TcbPtr:	    TPtr;

        {12 byte header used by the file and IO system}
        qLink: QElemPtr;	    {queue link in header}
        qType: INTEGER;		    {type byte for safety check}
        ioTrap: INTEGER;	    {FS: the Trap}
        ioCmdAddr: Ptr;		    {FS: address to dispatch to}

        {common header to all variants}
        ioCompletion: ProcPtr;	    {completion routine addr (0 for synch calls)}
        ioResult: OSErr;	    {result code}
        ioNamePtr: StringPtr;	    {ptr to Vol:FileName string}
        ioVRefNum: INTEGER;	    {volume refnum (DrvNum for Eject and MountVol)}

        {different components for the different type of parameter blocks}
        CASE INTEGER OF
        0:
          (ioRefNum: INTEGER;	    {refNum for I/O operation}
           ioVersNum: SignedByte;   {version number}
           ioPermssn: SignedByte;   {Open: permissions (byte)}

           ioMisc: Ptr;		    {Rename: new name}
                                    {GetEOF,SetEOF: logical end of file}
                                    {Open: optional ptr to buffer}
                                    {SetFileType: new type}
           ioBuffer: Ptr;	    {data buffer Ptr}
           ioReqCount: LongInt;	    {requested byte count; also = ioNewDirID}
           ioActCount: LongInt;	    {actual byte count completed}
           ioPosMode: INTEGER;	    {initial file positioning}
           ioPosOffset: LongInt);   {file position offset}

        1:
          (ioFRefNum: INTEGER;	     {reference number}
           ioFVersNum: SignedByte;   {version number}
           filler1: SignedByte;
           ioFDirIndex: INTEGER;    {GetFInfo directory index}
           ioFlAttrib: SignedByte;  {GetFInfo: in-use bit=7, lock bit=0}
           ioFlVersNum: SignedByte; {file version number}
           ioFlFndrInfo: FInfo;	    {user info}
           ioFlNum: LongInt;	    {GetFInfo: file number; TF- ioDirID}
           ioFlStBlk: INTEGER;	    {start file block (0 if none)}
           ioFlLgLen: LongInt;	    {logical length (EOF)}
           ioFlPyLen: LongInt;	    {physical lenght}
           ioFlRStBlk: INTEGER;	    {start block rsrc fork}
           ioFlRLgLen: LongInt;	    {file logical length rsrc fork}
           ioFlRPyLen: LongInt;	    {file physical length rsrc fork}
           ioFlCrDat: LongInt;	    {file creation date & time (32 bits in secs)}
           ioFlMdDat: LongInt);	    {last modified date and time}

         2:
           (filler2: LongInt;
            ioVolIndex: INTEGER;    {volume index number}
            ioVCrDate: LongInt;	    {creation date and time}
            ioVLsBkUp: LongInt;	    {last backup date and time}
            ioVAtrb: INTEGER;	    {volume attrib}
            ioVNmFls: INTEGER;	    {number of files in directory}
            ioVDirSt: INTEGER;	    {start block of file directory}
            ioVBlLn: INTEGER;	    {GetVolInfo: length of dir in blocks}
            ioVNmAlBlks: INTEGER;   {GetVolInfo: num blks (of alloc size)}
            ioVAlBlkSiz: LongInt;   {GetVolInfo: alloc blk byte size}
            ioVClpSiz: LongInt;	    {GetVolInfo: bytes to allocate at a time}
            ioAlBlSt: INTEGER;	    {starting disk(512-byte) block in block map}
            ioVNxtFNum: LongInt;    {GetVolInfo: next free file number}
            ioVFrBlk: INTEGER);	    {GetVolInfo: # free alloc blks for this vol}

          3:
            (ioCRefNum: INTEGER;    {refNum for I/O operation}
             CSCode: INTEGER;	    {word for control status code}
             CSParam: ARRAY[0..10] OF INTEGER);	 {operation-defined parameters}
           END; {ParamBlockRec}
  MyParmBlkPtr = ^MyParamBlockRec;


  MyHParamBlockRec = RECORD
        { 4 byte header used by the Completion routine }
        TcbPtr:	    TPtr;

		ThePB: HParamBlockRec;
		END;
  MyHParmBlkPtr = ^MyHParamBlockRec;
  
{$ENDC}