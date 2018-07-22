Unit INITerror;


{***********************************************************************}
{*								       								   *}
{*	      Gestion erreur sur Init					     	   		   *}
{*								       								   *}
{***********************************************************************}

Interface

USES	MemTypes,QuickDraw ,OSIntf ,ToolIntf ,PackIntf;

Function GetInitError: integer;
	{ rend le code d'erreur memorise }

Procedure SetInitError(Error: integer);
	{ memorise le code d'erreur }

Implementation

{$IFC NOT INITFLAG }
	Var TheError	:	Integer;
{$ELSEC}
	TYPE
		ErrHandle	=	^ErrPtr;
		ErrPtr		=	^Integer;
	
{$ENDC }

Function GetInitError: integer;
	{ rend le code d'erreur memorise }
{$IFC INITFLAG }
	Var MyError	:	ErrHandle;
{$ENDC }
Begin
{$IFC NOT INITFLAG }
	GetInitError:=TheError;
{$ELSEC }
	MyError:=ErrHandle(GetResource('ERRF',256));
	GetInitError:=MyError^^;
	ReleaseResource(Handle(MyError));
{$ENDC }
End;

Procedure SetInitError(Error: integer);
	{ memorise le code d'erreur }
{$IFC INITFLAG }
	Var MyError	:	ErrHandle;
{$ENDC }
Begin
{$IFC NOT INITFLAG }
	TheError:=Error;
{$ELSEC }
	MyError:=ErrHandle(GetResource('ERRF',256));
	If Error<>MyError^^ then
	begin
		MyError^^:=Error;
	 	ChangedResource(Handle(MyError));
	 	UpdateResFile(HomeResFile(Handle(MyError)));
	end;
	ReleaseResource(Handle(MyError));
{$ENDC }
End;

End. { of Unit }
