PROGRAM TestTool;

{$DECL DrgTree}
{$SETC DrgTree=TRUE}

USES Memtypes, Quickdraw, OSIntf, ToolIntf, PackIntf, AppleTalk, ADSP,
		{$u :Wintree:DrgFile.p} DrgFile,{$u :Wintree:DrgTree.p} DrgTree;

VAR	i: INTEGER;
		passWord,password2: Str255;
		mask: INTEGER;
		
BEGIN
		password := 'SzWGTAqENsMURAMh';
		mask := length(password);
		FOR i := 1 TO Length(PassWord) DO
		BEGIN
			PassWord[i] := CHR(BXOR(ORD(PassWord[i]),mask));
			mask := bxor(mask,band(ord(password[i]),$1f));
		END;		
		mask := length(password);
		Writeln(password);
		password2:=password;
		FOR i := 1 TO Length(PassWord) DO
		BEGIN
			PassWord2[i] := CHR(BXOR(ORD(PassWord[i]),mask));
			mask := bxor(mask,band(ord(password[i]),$1f));
		END;
		Writeln(mask);
		Writeln(Password2);
END.
