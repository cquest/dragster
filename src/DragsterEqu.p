PROGRAM BackBoot;


{***********************************************************************}
{*								       								   *}
{*	      Calcul des offsets DragsterTCB.a automatique		       	   *}
{*								       								   *}
{***********************************************************************}



USES	MemTypes,QuickDraw ,OSIntf ,ToolIntf ,PackIntf, AppleTalk, ADSP ;

{$R-} {Ne pas faire de verifications de limites}


TYPE
    LIPtr  = ^Longint;
    LIHdle = ^LIPtr;

{$I DragsterTCB.p }

VAR
    toto   		: TRecord;

BEGIN
		 Writeln(';   Offsets calculés automatiquement');
         WITH toto DO
		 BEGIN
                Writeln('cstTCBlen			EQU	',sizeOF(TRECORD)); { longueur d'un TCB }
				WriteLn;
                Writeln('cstMagicN1			EQU	',Ord4(@MagicN1)-ord4(@toto)); {	        : Longint;      {   0 magic Number}
                Writeln('cstNextTCB			EQU	',Ord4(@NextTCB)-ord4(@toto)); {	        : TPtr;	        {   4 next TCB in the task list}
				Writeln('cstPredTCB			EQU	',Ord4(@PredTCB)-ord4(@toto)); {			: TPtr;			{	8 pred TCB in the task list}
                Writeln('cstPtOffScreen		EQU	',Ord4(@PtOffScreen)-ord4(@toto)); {     : TPtOffScreen; {  12 offset des codes + videotex}
                Writeln('cstPtNameScreen		EQU	',Ord4(@PtNameScreen)-ord4(@toto)); {    : TPtNameScreen;{  16 noms des ecrans}
                Writeln('cstPtStringCsts		EQU	',Ord4(@PtStringCsts)-ord4(@toto)); {    : TPtStringCsts;{  20 constantes chaine}
                Writeln('cstPtSVars			EQU	',Ord4(@PtSVars)-ord4(@toto)); {	        : Ptr;	        {  24 variables shared application}
                Writeln('cstPtLVars			EQU	',Ord4(@PtLVars)-ord4(@toto)); {	        : Ptr;	        {  28 variables locales application}
                Writeln('cstPtCode			EQU	',Ord4(@PtCode)-ord4(@toto)); {	        : Ptr;	        {  32 code application}
                Writeln('cstPtScreens		EQU	',Ord4(@PtScreens)-ord4(@toto)); {       : Ptr;	        {  36 codes Videotex}
                Writeln('cstPtJump			EQU	',Ord4(@PtJump)-ord4(@toto)); {	        : Ptr;	        {  40 jump table Run Time}
                Writeln('cstPtOrgStk			EQU	',Ord4(@PtOrgStk)-ord4(@toto)); {        : Ptr;	        {  44 original stack pointer}
                Writeln('cstTheNScreen		EQU	',Ord4(@TheNScreen)-ord4(@toto)); {      : Longint;      {  48 Numero ecran courant}
                Writeln('cstTheVScreen		EQU	',Ord4(@TheVScreen)-ord4(@toto)); {      : Ptr;	        {  52 Ecran VideoTex Courant}
                Writeln('cstTheQueues		EQU	',Ord4(@TheQueues)-ord4(@toto)); {       : TQPtr;        {  56 Queues des serveurs }
				Writeln('cstTheMQueues		EQU	',Ord4(@TheMQueues)-ord4(@toto)); {      : MQPtr;        {  60 Queues des messages }
				Writeln('cstTheAuxBuffPtr	EQU	',Ord4(@TheAuxBuffPtr)-ord4(@toto)); {   : Ptr;          {  64 Buffer serial port }
                Writeln('cstTheModem			EQU	',Ord4(@TheModem)-ord4(@toto)); {        : Integer;      {  68 Numero du modem correspondant }
                Writeln('cstSerRefIn			EQU	',Ord4(@SerRefIn)-ord4(@toto)); {		: integer;		{  70 Driver In  }
                Writeln('cstSerRefOut		EQU	',Ord4(@SerRefOut)-ord4(@toto)); {       : Integer;      {  72 Driver Out }
                Writeln('cstStatusWord		EQU	',Ord4(@StatusWord)-ord4(@toto)); {      : Integer;      {  74 Mot d'etat:
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
                Writeln('cstDelayValue		EQU	',Ord4(@DelayValue)-ord4(@toto)); {      : Longint;      {  76 Nombre de Ticks a attendre}
                Writeln('cstIOCompFlag		EQU	',Ord4(@IOCompFlag)-ord4(@toto)); {      : Integer;      {  80 0: IO terminée, 1: IO en cours}
                Writeln('cstError			EQU	',Ord4(@Error)-ord4(@toto)); {	        : Integer;      {  82 Code d'Erreur}
                Writeln('cstPendAdr			EQU	',Ord4(@PendAdr)-ord4(@toto)); {	        : Ptr;	        {  84 Var Adress for pend}
                Writeln('cstPendStr			EQU	',Ord4(@PendStr)-ord4(@toto)); {	        : Longint;      {  88 Str Pattern to wait}
                Writeln('cstStartTime		EQU	',Ord4(@StartTime)-ord4(@toto)); {       : Longint;      {  92 TickCount de connexion}
                Writeln('cstMaxTime			EQU	',Ord4(@MaxTime)-ord4(@toto)); {	        : Longint;      {  96 TimeOut}
                Writeln('cstZoneNumber		EQU	',Ord4(@ZoneNumber)-ord4(@toto)); {      : Integer;      { 100 Zone de sortie du Wait}
                Writeln('cstTaskNumber		EQU	',Ord4(@TaskNumber)-ord4(@toto)); {      : Integer;      { 102 Numero de la tache/voie logique}
                Writeln('cstTaskPriority		EQU	',Ord4(@TaskPriority)-ord4(@toto)); {    : Integer;      { 104 Priorité de la tache }
				Writeln('cstTheNLine			EQU	',Ord4(@TheNLine)-ord4(@toto)); {		: Integer;		{ 106 Numero de ligne dans le module }
				Writeln('cstTheNInst			EQU	',Ord4(@TheNInst)-ord4(@toto)); {		: Integer;		{ 108 Numero d'intruction dans la ligne }
                Writeln('cstLocalMode		EQU	',Ord4(@LocalMode)-ord4(@toto)); {       : Boolean;      { 110 mode local ou non }
                Writeln('cstEchoFlag			EQU	',Ord4(@EchoFlag)-ord4(@toto)); {        : Boolean;      { 111 echo ou non }
                Writeln('cstOutPutFlag		EQU	',Ord4(@OutPutFlag)-ord4(@toto)); {      : Boolean;      { 112 output allowed, Transpac version}
				Writeln('cstFrOutPut			EQU	',Ord4(@FrOutPut)-ord4(@toto)); {		: Boolean;		{ 113 vrai si FrontScreen On }
                Writeln('cstStarFlag			EQU	',Ord4(@StarFlag)-ord4(@toto)); {        : Boolean;      { 114 si * seule en saisie }
				Writeln('cstTaskSNumber		EQU	',Ord4(@TaskSNumber)-ord4(@toto)); {		: Integer;		{ 116 TaskNumber dans le type }
				Writeln('cstHardType				EQU	',Ord4(@HardType)-ord4(@toto)); {			: Integer;		{ 118 Ouput Paquet Number }
		 		Writeln('cstOPFlag			EQU	',Ord4(@OPFlag)-ord4(@toto)); {	   		: Integer; 		{ 120 Flag - 1 si voie libre sur Ring }
		 		Writeln('cstSerSpeed			EQU	',Ord4(@SerSpeed)-ord4(@toto)); {	   		: Integer; 		{ 122 Premier paquet occupé }
(*
				Writeln('cstOPFree			EQU	',Ord4(@OPFree)-ord4(@toto)); {	   		: Integer; 		{ 124 Premier paquet libre  }
				Writeln('cstOPNb				EQU	',Ord4(@OPNb)-ord4(@toto)); {		   	: Integer; 		{ 126 Nombre de paquets en attente  }
*)				
				Writeln('cstOPPtr			EQU	',Ord4(@OPPtr)-ord4(@toto)); {			: OPBPtr;		{ 128 Pointer to Output Paquet Ring }
                Writeln('cstRegArea			EQU	',Ord4(@RegArea)-ord4(@toto)); {	        : Array[0..16] of Ptr; { 132 registres tache background}
                Writeln('cstRegAreaF			EQU	',Ord4(@RegAreaF)-ord4(@toto)); {        : Array[0..16] of Ptr; { 136 registres tache principale}
                Writeln('cstNbZones			EQU	',Ord4(@NbZones)-ord4(@toto)); {	        : Integer;      {Zones de saisie }
                Writeln('cstTheZones			EQU	',Ord4(@TheZones)-ord4(@toto)); {        : Array[1..MaxZones] of RSZone; }
                Writeln('cstRTId				EQU	',Ord4(@RTId)-ord4(@toto)); {	        : Longint;      { Serial number of Run Time }
                Writeln('cstTraceFile		EQU	',Ord4(@TraceFile)-ord4(@toto)); {      : Integer; }
                Writeln('cstProtCount		EQU	',Ord4(@ProtCount)-ord4(@toto)); {       : Integer; }
				Writeln('cstXCallDatas		EQU	',Ord4(@XCallDatas)-ord4(@toto)); {      : String[SZCALL]; { données d'appel Transpac }
				(* InBuff			: Str255;   { buffer d'entrée } *)
				Writeln('cstInBuffEnd		EQU	',Ord4(@InBuffEnd)-ord4(@toto)); {		: BuffPtr;		{ pointeur sur dernier buffer d'entrée }
				Writeln('cstInBuffPool		EQU	',Ord4(@InBuffPool)-ord4(@toto)); {		: PBuffPtr;		{ pointeur sur pool de buffers d'entrée }
				Writeln('cstInSilentFlag		EQU	',Ord4(@InSilentFlag)-ord4(@toto)); {	: Boolean;		{ input "silencieux" }
				Writeln('cstWBuffFlag		EQU	',Ord4(@WBuffFlag)-ord4(@toto)); {		: Boolean;		{ vrai si remplissage du buffer en cours }
				Writeln('cstConFlag			EQU	',Ord4(@ConFlag)-ord4(@toto)); {			: Boolean;      { valide sur connexion }
				Writeln('cstXConFlag			EQU	',Ord4(@XConFlag)-ord4(@toto)); {		: Boolean;		{ devalide sur deconnexion }
				Writeln('cstFilterFlag		EQU	',Ord4(@FilterFlag)-ord4(@toto)); {		: boolean;		{ vrai si ESC filtré }
				Writeln('cstTrPrintFlag		EQU	',Ord4(@TrPrintFlag)-ord4(@toto)); {		: boolean;		{ vrai si on active print Transparent }
				Writeln('cstRWSz				EQU	',Ord4(@RWSz)-ord4(@toto)); {			: Integer;		{ Read/Write Buffer Size }
				Writeln('cstRWPtr			EQU	',Ord4(@RWPtr)-ord4(@toto)); {			: RWBPtr;		{ Pointer to Read/Write Buffer }
				Writeln('cstRWCount			EQU	',Ord4(@RWCount)-ord4(@toto)); {			: Integer;		{ Count of read bytes }
				Writeln('cstRWIdx			EQU	',Ord4(@RWIdx)-ord4(@toto)); {			: Integer;		{ Index dans RW buffer 1..RWSz }
				Writeln('cstDBPtr			EQU	',Ord4(@DBPtr)-ord4(@toto)); {			: DBBPtr;		{ Pointer to data base Buffer }
				Writeln('cstDBSz				EQU	',Ord4(@DBSz)-ord4(@toto)); {			: Longint;		{ Data Base com area size }
				Writeln('cstDBCount			EQU	',Ord4(@DBCount)-ord4(@toto)); {			: Longint;		{ com area actual size }
				Writeln('cstDBRef			EQU	',Ord4(@DBRef)-ord4(@toto)); {			: Longint;		{ record reference }
				Writeln('cstDBIdx			EQU	',Ord4(@DBIdx)-ord4(@toto)); {			: Longint;		{ com area actual index }
				Writeln('cstIOQueue			EQU	',Ord4(@IOQueue)-ord4(@toto)); {			: Integer;		{ SANE environment }
				Writeln('cstRndMemo			EQU	',Ord4(@RndMemo)-ord4(@toto)); {			: Longint;		{ random seed 1 }
				Writeln('cstRndCount			EQU	',Ord4(@RndCount)-ord4(@toto)); {		: Longint;		{ random seed 2 }
				Writeln('cstDemoCount		EQU	',Ord4(@DemoCount)-ord4(@toto)); {		: Longint;		{ decompteur pour demo }
                Writeln('cstTheFiles			EQU	',Ord4(@TheFiles)-ord4(@toto)); {        : Array[1..MaxFile] of FRecord; }
                Writeln('cstRunMode			EQU	',Ord4(@RunMode)-ord4(@toto));
                Writeln('cstCurRunMode			EQU	',Ord4(@CurRunMode)-ord4(@toto));
				Writeln;
         END;

END.

