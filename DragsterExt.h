#ifndef DRAGSTEREXT_H#define DRAGSTEREXT_H/*  Fichier:  DragsterExt.p  Contenu:  D�finitions des callBack � utiliser dans les routines externes de            Dragster (� partir de la version 1.93) mode compil�.  Ecrit par:  Christian QUEST  Copyright:  1991 JCA T�l�matique / Ch. QUEST  Historique:        11/05/95  CQ    Remise en forme de UNIT pour traduction en C.        27/05/92  CQ    Suppression de l'utilisation de $A78. L'adresse de la                        JumpTable se trouve sur la pile (dernier param�tre).                        Modif. du compilateur pour que celui-ci mette cette                        adresse sur la pile avant d'appeler l'externe                        MOVE.L A3,-(A7)        21/05/92  CQ    Version utilisant $A78 � la place de A5                        pour compatibilit� en interprett�.        15/08/91  CQ    Premi�re �bauche des callbacks de Dragster*/#include "Types.h"#define MaxZones 40                               /* nombre maxi de zones */#define MaxFile 12                                /* nombre maxi de fichiers *//*�constantes 'NewMode' pour Drg_SetRunMode */#define kNoInterrupt 0                            /*�d�sactivation de l'exec. sous interruptions pour cette t�che*/#define kInterrupt 1                              /*�r�activation de l'exec. sous interruptions pour cette t�che *//* requ�tes du serveur de fichier pour les PBCall, PBHCall */#define ReqOpen 1                                 /* demande d'Open */#define ReqClose 2                                /* demande de Close */#define ReqRename 3                               /* demande de Rename� */#define ReqDelete 4                               /* demande de Delete� */#define ReqRead 5                                 /* demande de Read */#define ReqWrite 6                                /* demande de Write */#define ReqGetEof 7                               /* demande de GetEof */#define ReqSetEof 8                               /* demande de SetEof */#define ReqLock 9                                 /* demande de Lock */#define ReqUnlock 10                              /* demande de Unlock */#define ReqCreate 11                              /* demande de Create */#define ReqGetFInfo 12                            /* demande de GetFInfo� */#define ReqSetFInfo 13                            /* demande de SetFInfo� */#define ReqOpWd 14                                /* demande de OpenWD� */#define ReqClWd 15                                /* demande de CloseWD� */#define ReqGetCat 16                              /* demande de GetCatInfo */#define ReqOpRsrc 17                              /* demande de Open resource fork */#define ReqDirCreate 18                           /* demande de Creation de Folder */#define ReqFlush 19                               /* demande de FlushVol */#define ReqNameOfId 20                            /* demande de nom courant */#define ReqGetVol 21                              /* demande de GetVol */#define ReqSetVol 22                              /* demande de SetVol */#define ReqGetVInfo 23                            /* demande de GetVInfo */#define ReqCatMove 24                             /* demande de PBCatMove *//* � PBHCall  *//*  � PBWDCall */struct FRecord {  short FileRef;                                  /* Numero de reference interne du fichier */  short FileRLen;                                 /* Longueur d'un record (acces dir) */  long FilePos;                                   /* Prochaine pos � lire, ou record courant */  Boolean BaseFlag;                               /* base ou fichier ? */};typedef struct FRecord FRecord;struct RSZone {                                   /* d�finition d'une ZONE */  short PosX;  short PosY;  short Len;  short TkVar;                                    /* type de variable (Alpha ou Num ?) */  Ptr AdVar;                                      /* Ptr vers la variable */  short Color;};typedef struct RSZone RSZone;typedef struct TCBRec *TCBPtr;struct TCBRec {  long Reserv1;                                   /* tjrs = $12345678 */  TCBPtr NextTCB;                                 /* prochain TCB dans la liste */  TCBPtr PredTCB;                                 /*  TCB pr�c�dent */  Ptr PtOffScreen;                                /* offset des codes + videotex*/  Ptr PtNameScreen;                               /* noms des ecrans*/  Ptr PtStringCsts;                               /* Ptr vers constantes chaine*/  Ptr PtSVars;                                    /* Ptr variables shared */  Ptr PtLVars;                                    /* Ptr variables locales */  Ptr PtCode;                                     /* Ptr code application */  Ptr PtScreens;                                  /* Ptr �crans Videotex */  Ptr PtJump;                                     /* jump table Run Time */  Ptr PtOrgStk;                                   /* pile de d�part */  long TheNScreen;                                /* Numero ecran courant*/  Ptr TheVScreen;                                 /* Ecran VideoTex Courant*/  Ptr TheQueues;                                  /* Queues des serveurs */  Ptr TheMQueues;                                 /* Queues des messages */  Ptr TheAuxBuffPtr;                              /* Buffer serial port */  short TheModem;                                 /* Numero du modem associ� */  short SerRefIn;                                 /* RefNum Driver In  */  short SerRefOut;                                /* RefNum Driver Out */  short StatusWord;                               /* �tat de la t�che                                                                   0: ready                                                                   1: waiting delay                                                                   2: waiting IOCompletion                                                                   3: waiting IOCompletion with TimeOut                                                                   4: waiting char                                                                   5: waiting char with TimeOut                                                                   6: pending for mailbox                                                                   7: pending for mailbox with TimeOut                                                                   8: pending for string                                                                   9: pending for string with TimeOut                                                                  10: waiting network response                                                                  11: waiting network response with TimeOut                                                                  12: waiting for OutPut allowing                                                                  14: waiting for Start                                                              */  long DelayValue;                                /* Nombre de Ticks � attendre */  short IOCompFlag;                               /* 0: IO termin�e, 1: IO en cours */  short Error;                                    /* Code d'Erreur */  Ptr PendAdr;                                    /* Var Adress for pend */  long PendStr;                                   /* Str Pattern to wait */  long StartTime;                                 /* 'secs' � la connexion */  long MaxTime;                                   /* TimeOut */  short ZoneNumber;                               /* Zone de sortie du Wait*/  short TaskNumber;                               /* Numero de la tache/voie logique*/  short TaskPriority;                             /* Priorit� de la tache */  short TheNLine;                                 /* Numero de ligne dans le module */  short TheNInst;                                 /* Numero d'intruction dans la ligne */  Boolean LocalMode;                              /* mode local ou non */  Boolean EchoFlag;                               /* echo ou non */  Boolean OutPutFlag;  Boolean FrOutPut;                               /* vrai si FrontScreen en cours */  Boolean StarFlag;                               /* si * seule en saisie */  Boolean StoppedFlag;                            /* vrai si la tache a �t� arr�t�e */  short TaskSNumber;  short HardType;                                 /* Type de HardWare */  short OPFlag;  short OPFirst;  Ptr Infos;                                      /* pointeur vers infos suppl�mentaires */  Ptr OPPtr;                                      /* pointeur vers buffer de sortie */  Ptr RegArea[17];                                /* registres tache background */  Ptr RegAreaF[17];                               /* registres tache principale */  short NbZones;                                  /* Nb Zones de saisie */  RSZone TheZones[MaxZones];  long Res2;  short Res3;  short Res4;  unsigned char XCallDatas [27];  /* donn�es d'appel Transpac */  long Res5;  Ptr Res6;  Ptr Res7;  short Res8;  short Res9;  Boolean Res10;  Boolean Res11;  Boolean ConFlag;                                /* valide si voie connect�e */  Boolean XConFlag;  short Res12;  Boolean FilterFlag;                             /* vrai si FILTER */  Boolean TrPrintFlag;                            /* print "transparent" ? */  short RWSz;                                     /* Taille buffer Read/Write des fichiers */  Ptr RWPtr;                                      /* Pointer sur Buffer Read/Write */  short RWCount;                                  /* nb octets lus/�crits */  short RWIdx;                                    /* Index dans RW buffer 1..RWSz */  Ptr DBPtr;                                      /* Pointer to data base Buffer */  long DBSz;                                      /* Data Base com area size */  long DBCount;                                   /* com area actual size */  long DBRef;                                     /* record reference */  long DBIdx;                                     /* com area actual index */  short IOQueue;                                  /* N� Queue pour I/O */  long RndMemo;                                   /* random seed 1 */  long RndCount;                                  /* random seed 2 */  long Res13;  Ptr Res14;  FRecord TheFiles[MaxFile];                      /* tableau des fichiers de la t�che */};typedef struct TCBRec TCBRec;struct MyParamBlockRec {  TCBPtr TCB;  ParamBlockRec PB;};typedef struct MyParamBlockRec MyParamBlockRec;typedef struct MyParamBlockRec *MyParamBlockPtr;struct MyHParamBlockRec {  TCBPtr TCB;  HParamBlockRec HPB;};typedef struct MyHParamBlockRec MyHParamBlockRec;typedef struct MyHParamBlockRec *MyHParamBlockPtr;extern pascal void Drg_PrintChar(char theChar, Ptr JT);extern pascal void Drg_PrintNum(long theNum, Ptr JT);extern pascal void Drg_PrintStr(StringPtr theStr, Ptr JT);extern pascal void Drg_PrintScreen(StringPtr theStr, Ptr JT);extern pascal void Drg_Message(long Ligne, long Colonne, long Tempo, StringPtr theStr, Ptr JT);extern pascal void Drg_ResetZones(Ptr JT);extern pascal void Drg_Zone(long ZPosX, long ZPosY, long ZLen, Ptr TheVar, short ZTkVar, long TheColor, Ptr JT);extern pascal void Drg_Wait(short zoneNum, Ptr JT);extern pascal void Drg_Input(StringPtr str, Ptr JT);extern pascal TCBPtr Drg_GetTCB(Ptr JT);extern pascal void Drg_Delay(long Delay, Ptr JT);extern pascal void Drg_YieldCpu(Ptr JT);extern pascal Str255 Drg_RunFlags(Ptr JT);extern pascal void Drg_SetRunMode(short NewMode, Ptr JT);extern pascal void Drg_Open(long NumLog, StringPtr Nom, Ptr JT );extern pascal void Drg_OpenRF(long NumLog, StringPtr Nom, Ptr JT );extern pascal void Drg_Close(long NumLog, Ptr JT );extern pascal OSErr Drg_FSRead(long NumLog, LongIntPtr count, Ptr Buffer, Ptr JT);extern pascal OSErr Drg_FSWrite(long NumLog, LongIntPtr count, Ptr Buffer, Ptr JT);extern pascal long Drg_Error(Ptr JT);extern pascal long Drg_EOF(long NumLog, Ptr JT);extern pascal long Drg_GetEOF(long NumLog, Ptr JT);extern pascal void Drg_SetEOF(long NumLog, long LogEof, Ptr JT);extern pascal long Drg_FPos(long NumLog, Ptr JT);extern pascal void Drg_Seek(long NumLog, long Pos, Ptr JT);extern pascal void Drg_RLen(long NumLog, long RecLen, Ptr JT);extern pascal void Drg_RSeek(long NumLog, long NumRec, Ptr JT);extern pascal void Drg_Create(StringPtr Nom, Ptr JT);extern pascal void Drg_Kill(StringPtr Nom, Ptr JT);extern pascal void Drg_Rename(StringPtr ancien, StringPtr nouveau, Ptr JT);extern pascal void Drg_Lock(long NumLog, Ptr JT);extern pascal void Drg_Unlock(long NumLog, Ptr JT);extern pascal void Drg_GetFile(StringPtr NomFicDos, StringPtr NomDoss, long Index, Ptr JT);extern pascal void Drg_NewFolder(StringPtr Nom, Ptr JT);extern pascal void Drg_GetFInfo(StringPtr Nom, StringPtr TypeCreat, LongIntPtr DataSz, LongIntPtr RsrcSz, LongIntPtr DateCr, LongIntPtr DateMod, Ptr JT);extern pascal void Drg_SetFinfo(StringPtr Nom, StringPtr TypeCreate, Ptr JT);extern pascal void Drg_GetVol(StringPtr NomVol, long Index, Ptr JT);extern pascal OSErr Drg_PBCall(short theCall, MyParamBlockPtr thePB, Ptr JT);extern pascal OSErr Drg_PBHCall(short theCall, MyHParamBlockPtr thePB, Ptr JT);extern pascal Handle Drg_NewHandle(long size, Ptr JT);extern pascal OSErr Drg_StoreData(Ptr dataPtr, StringPtr dataName, Ptr JT);extern pascal Ptr Drg_RestoreData(StringPtr dataName, Ptr JT);extern pascal void Drg_KillData(StringPtr dataName, Ptr JT);extern pascal void Drg_ShutDownInstall(Ptr procPtr, Ptr dataPtr, Ptr JT);extern pascal void GosubScreen(StringPtr screen, Ptr JT);#endif